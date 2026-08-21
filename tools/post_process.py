import re,pathlib

gamename = "bosconian"

# game_specific: replace or remove I/O addresses
# if not done it will write in ROM here!!
input_dict = {
"watchdog_a080":["","read_p2_inputs"],
"scrollx_a130":"set_scroll_x",
"scrolly_a140":"set_scroll_y",
"dsw_a100":"read_dsw",
"p1_a000":"read_p1_inputs",
"dummy_6830":"",
}

single_line_to_cc_protect = {0x00ec,0xf2,0x020c,0x0354,0x1093,0x1243,0x192a,0x1b8c,0x2042,0x2037,
0x1f5b,0x355d,0x2edb,0x24ee,0x3a8a,0x238a,0x2560,0x316b,0x3175,0x317f,0x3189,0x00f9,0x0a17}
remove_error_in_next_line = {0x12,0x0053,0x00ed,0x00f3,0x0357,0x0434,0x094b,0X0eba,0x0f70,0X0f76,
0x1094,0x1244,0x1434,0x143a,0x020f,0x15cc,0x15d0,0x1b88,0x1ea3,0x1ed9,0x2039,0x2040,0x2045,0x3560,
0x33bf,0x360f,0x2edc,0x24ec,0x24f0,0x3a8c,0x1f5e,0x20DE,0x238c,0x255e,0x2563,0x318b,0x192c,0x3181,0x3177,0x316d}
remove_error_in_prev_line = {0,0x0a16,0x1093,0x3713,0x3728,0x3037,0x38eb,0x238a,0X00f8,0x0533,0x053b,0x291e}
line_to_push_cc_protect ={0x0047,0x0f72,0x1436,0x15cd,0x1ea1,0x33bc}  | single_line_to_cc_protect
line_to_pull_cc_protect ={0x0049,0X0f75,0x1439,0x15cf,0x1ea2,0x33bd}  | single_line_to_cc_protect
line_to_pull_cc_prev_protect =set()


store_to_video = re.compile("GET_ADDRESS\s+(0x8\w\w\w|video_ram_d)",flags=re.I)   # game_specific


def game_specific(address,lines,i):
    line = lines[i]
    # game_specific
    toks = line.split()
    if len(toks)>1 and toks[1].startswith("jump_table_"):
        line = change_instruction(f"lea\t{toks[1]},a4",lines,i)
    if address == 0x0:
        line = remove_instruction(lines,i)
    elif address == 0x10:
        line = change_instruction("add.b\td0,d6",lines,i)
        lines[i+1] = remove_instruction(lines,i+1)
    elif address == 0x20:
        kill_code(lines,i,0X25)
        line = """\tand.w\t#0xFF,d0
\tadd.w\td0,d0
\tadd.w\td0,d0
\tmove.l\t(a4,d0.w),a0
\tjmp\t(a0)
"""

    elif address in {0x0047,0x55,0x00fd,0x02b4,0x0a1c}:  # addx+daa => abcd
        lines[i-1] = remove_error(lines[i-1])
        lines[i-2] = change_instruction("abcd\td7,d0",lines,i-2)
    elif address == 0x0041:
        line = change_instruction("moveq\t#3-1,d1",lines,i)
    elif address == 0x004a:
        line = change_instruction("dbf\td1,l_0044",lines,i)
    elif address in {0x019a,0x3713,0x3728,0x38eb}:
        line = remove_instruction(lines,i)
    elif address == 0x0431:
        line = swap_lines(lines,i,i-1)
    elif address == 0x0eb8:
        line = swap_lines(lines,i,i-1)
    elif address == 0x20dc:
        line = swap_lines(lines,i,i-1)
    elif address in {0x1138,0x1178,0x11b8,0x11f8}:
        line = swap_lines(lines,i,i-2)
        lines[i+2] = remove_error(lines[i+2])
        lines[i-1] = remove_error(lines[i-1])
    elif address in {0x00eb,0x00f1}:
        lines[i+2] = remove_error(lines[i+2])
    elif address == 0x094b:
        line = "\ttst.b\t(a0)\n"+line
    elif address == 0x0945:
        lines[i+1] = remove_instruction(lines,i+1,False)
    elif address in {0x00f6,0xA14}:
        line += change_instruction("""CLR_XC_FLAGS
\tmove.b\t(a0),d7
\tabcd    d7,d0                              | [...]""",lines,i)
    elif address in {0x00fb,0x0a1a,0x0531,0x0539}:
        line += change_instruction("""move.b\t(a0),d7
\tabcd    d7,d0                              | [...]""",lines,i)
    elif address == 0x1b86:
        line = f"""\tmoveq\t#0,d1
{line}\tsubq\t#1,d1   | for dbf
"""
    elif address == 0x1b8d:
        line = change_instruction("dbf\td1,l_1b88",lines,i)
    elif address in {0x1b88,0x389e}:
        line = remove_instruction(lines,i)
    elif address == 0x360a:
        line = change_instruction("movem.l\td3-d4,-(a7)",lines,i)
    elif address == 0x360e:
        line = change_instruction("movem.l\t(a7)+,d3-d4",lines,i)
    elif address == 0x3037:
        line = change_instruction('BREAKPOINT  "3037"',lines,i)
    elif address in {0x04d9,0x09a8}:
        line = change_instruction("sbcd\td2,d0",lines,i)
    elif address == 0x1381:
        line = change_instruction("move.l\td6,d7",lines,i)+"""\tsub.b\t#0xc,d7
\tlea\t(a6,d7.l),a2
"""
        kill_code(lines,i,address+0x5)
    elif address == 0xF91:
        line = change_instruction("move.l\td6,d7",lines,i)+"""\tsub.b\t#0xb,d7
\tlea\t(a6,d7.l),a2
"""
        kill_code(lines,i,address+0x5)
    elif address == 0x0D10:
        line = change_instruction("jbsr\tosd_get_random",lines,i)
    elif address == 0x291E:
        line = change_instruction("move.l\ta7,save_stack",lines,i)
    elif address == 0x3037:
        line = change_instruction("move.l\tsave_stack,a7",lines,i)
    elif address == 0x3663:
        line = change_instruction("jra\tend_of_rom_checksum_3815",lines,i)
    elif address == 0x375A:
        line = change_instruction("rts",lines,i)
    if "review if carry flag not used" in line or "addx mix" in line:
        line = remove_error(lines[i])
    if "DAA" in line.split():
        line = ""
    return line

def remove_continuing_lines(lines,i):
    for j in range(i+1,i+4):
        if "[...]" in lines[j]:
            lines[j] = ""
        else:
            break


def get_line_address(line):
    try:
        toks = line.split("|")
        address = toks[1].strip(" [$").split(":")[0]
        return int(address,16)
    except (ValueError,IndexError):
        return None

def remove_continuing_lines(lines,i):
    for j in range(i+1,i+4):
        if "[...]" in lines[j]:
            lines[j] = ""
        else:
            break


def change_instruction(code,lines,i,continuing_lines=True):
    line = lines[i]
    toks = line.split("|")
    if len(toks)==2:
        toks[0] = f"\t{code}"
        if continuing_lines:
            remove_continuing_lines(lines,i)
        return " | ".join(toks)
    return line

def remove_error(line,ignore=False):
    if not isinstance(line,str):
        raise Exception("line should be a string")
    if "ERROR" in line:
        return ""
    elif not ignore:
        raise Exception(f"No ERROR to remove in {line}")
    else:
        return line
def remove_instruction(lines,i,continuing_lines=True):
    return change_instruction("",lines,i,continuing_lines=continuing_lines)

def remove_continuing_lines(lines,i):
    for j in range(i+1,i+4):
        if "[...]" in lines[j]:
            lines[j] = ""
        else:
            break


def process_jump_table(line):

    m = re.search("\[nb_entries=(\d+)",line)
    if m:
        nb_entries = m.group(1)
        line = f"""\t.ifndef\tRELEASE
\tmove.w\t#{nb_entries},d7
\t.endif
"""+line

    return line

def get_original_instruction(line):
    toks = line.split("| [")
    if len(toks)==1:
        return ""
    inst = toks[1][7:].split("]")[0]
    return inst


def remove_code(pattern,lines,i):
    if pattern in lines[i]:
        lines[i] = remove_instruction(lines,i)
        remove_continuing_lines(lines,i)
    return lines[i]

def rebuild_lines(lines):
    return "".join(lines).splitlines(True)

def swap_lines(lines,i,j):
    lines[i],lines[j] = lines[j].rstrip()+ "| swapped\n",lines[i].rstrip()+ "| swapped\n"
    return lines[i]

def kill_code(lines,start_line,end_address):
    rval = lines[start_line]
    while True:
        address = get_line_address(lines[start_line])
        lines[start_line] = remove_instruction(lines,start_line)
        if "|" not in lines[start_line]:
            lines[start_line] = ""
        if address == end_address:
            break
        start_line+=1
    return rval

def subt(m):
    tn = m.group(1)
    rn = m.group(2)
    offset = tn.split("_")[-1]
    rval = f"""
\t.ifndef\tRELEASE
\tmove.w\t#0x{offset},d{rn}
\t.endif
\tlea\t{tn},a{rn}"""
    return rval

equates = []
global_symbols = []
equates_re = re.compile("(\w+)\s*=\s*(\$?\w+)")
this_dir = pathlib.Path(__file__).absolute().parent

source_dir = this_dir / "../src"

rest_of_jump_table_code = """    MAKE_DE_NO_AR
    add.w    d4,d4
    add.w    d4,d4
    move.l  (a4,d4.w),a4
    jmp     (a4)
"""

# various dirty but at least automatic patches applying on the converted code
with open(source_dir / "conv.s") as f:
    lines = list(f)

    for i,line in enumerate(lines):
        m = equates_re.match(line)
        if m:
            equates.append(line)
            line = ""


##        elif "review stray daa" in line:
##            line = """\tCLR_XC_FLAGS
##\tmove.b\t(a0),d6
##\tabcd\td6,d0
##"""
        address = get_line_address(line)


        if "[return]" in line:
            if "MAKE_" in line:
                line = ""
            else:
                line = change_instruction("rts",lines,i)

        elif "[nop]" in line:
            line = remove_instruction(lines,i)

        elif "[push_function]" in line:
            toks = line.split()
            line = remove_instruction(lines,i)
            pa = toks[1].strip("#")
            lines[i+1] = change_instruction(f"pea\t{pa}",lines,i+1)
        elif "[breakpoint]" in line and address:
            line = f'\tBREAKPOINT "{address:04x}"\n{line}'

        elif "[cc_ok]" in line:
            if "rts" in line and "ret]" not in line: # conditional return
                lines[i-1] = remove_error(lines[i-1],True)
            else:
                lines[i+1] = remove_error(lines[i+1],True)


        line = process_jump_table(line)


        # pre-add video_address tag if we find a store instruction to an explicit 3000-3FFF address
        m = store_to_video.search(line)
        if m:
            g = m.group(1)
            okay = True
            if g.startswith("0x"):
                target_address = int(g,16)  # not used
                if "ix," not in line and "iy," not in line:
                    line = line.rstrip() + " [video_address]\n"

        if "[video_address" in line or "[unchecked_address" in line:
            if (",a2" in line or ",a3" in line) and "GET_ADDRESS" not in line:
                    # using indexed ix/iy: parse code to insert the proper dirty macro
                    toks = line.split()
                    toks = toks[1].split(",")
                    destreg = toks[2].strip("()")
                    destz = "IX" if destreg=="a2" else "IY"
                    offset = toks[1].strip("()")
                    line += f"\tVIDEO_BYTE_DIRTY_{destz}\t{offset}\n"
            else:
                # give me the original instruction
                line = line.replace("_ADDRESS","_UNCHECKED_ADDRESS")
                if "MAKE" in line:
                    line = re.sub(r"(MAKE_AR)",r"\1_UNCHECKED",line)
                    line = re.sub(r"(MAKE_[HDB]\w)",r"\1_UNCHECKED",line)
                elif "MAKE" in lines[i-1] and "UNCHECKED" not in lines[i-1]:
                    lines[i-1] = re.sub(r"(MAKE_AR)",r"\1_UNCHECKED",lines[i-1])
                    lines[i-1] = re.sub(r"(MAKE_[HDB]\w)",r"\1_UNCHECKED",lines[i-1])

                if "ldir" in line:
                    line = line.replace("ldir","ldir_video" if "[video_address" in line else "ldir_unchecked")
                elif "memcpy_3e6" in line and "jbsr" in line and "[video_address" in line:
                    line = re.sub(r"(memcpy_3e6\w)","\\1_video",line)
                elif "[video_address" in line:
                    if ",(a0)" in line or ("(a0)" in line and "clr.b" in line):
                        line += "\tVIDEO_BYTE_DIRTY | [...]\n"
                    elif (",(a0)" in lines[i+1] or ("(a0)" in  lines[i+1]  and "clr.b" in lines[i+1] )):
                        lines[i+1]  += "\tVIDEO_BYTE_DIRTY | [...]\n"
        if "[pop_stack]" in line:
            line = change_instruction("addq\t#4,sp",lines,i)

        line = re.sub("#(i[xy][hl])",r"\1",line)
        ###############################################

        lines[i] = line
        line = game_specific(address,lines,i)

        ###############################################
        if address in remove_error_in_prev_line:
            lines[i-1] = remove_error(lines[i-1].strip()+f" ({address:04x})")
        if address in remove_error_in_next_line:
            lines[i+1] = remove_error(lines[i+1].strip()+f" ({address:04x})")
        if address in line_to_pull_cc_protect:
            # protect the sub instructions if any
            for j in range(i+1,len(lines)):
                if not "[...]" in lines[j]:
                    break

            lines[j-1] += "\tPOP_SR\n"
            if j-1==i:
                line = lines[i]

        if address in line_to_push_cc_protect:
            # protect the sub instructions
            line = "\tPUSH_SR\n"+line
        if address in line_to_pull_cc_prev_protect:
            # protect the sub instructions
            line = "\tPOP_SR\n"+line

        if "GET_ADDRESS" in line:
            val = line.split()[1].split(",")[0]
            osd_call = input_dict.get(val)
            if osd_call is not None:

                if osd_call:
                    if isinstance(osd_call,list):
                        # choose depending on read/write
                        if "a,(" in line:
                            osd_call = osd_call[1]
                        else:
                            osd_call = osd_call[0]
                    if osd_call:
                        line = change_instruction(f"jbsr\tosd_{osd_call}",lines,i)
                    else:
                        line = remove_instruction(lines,i)
                else:
                    line = remove_instruction(lines,i)
                lines[i+1] = remove_instruction(lines,i+1)

        if "[global]" in line:
            label = line.split(":")[0]
            global_symbols.append(label)

        lines[i] = line

    # remove duplicate VIDEO_BYTE_DIRTY
    lines = rebuild_lines(lines)
    new_lines = []
    prev_line = ""
    for line in lines:
        if "VIDEO_BYTE_DIRTY" in line and "VIDEO_BYTE_DIRTY" in prev_line:
            pass
        else:
            new_lines.append(line)
        prev_line = line

with open(source_dir / "data.inc","w") as fw:
    fw.writelines(equates)

with open(source_dir / f"{gamename}.68k","w") as fw:

    fw.write(f"""\t.include "data.inc"
""")
    for g in global_symbols:
        fw.write(f"\t.global\t{g}\n")

    fw.writelines(new_lines)
    fw.write("""* < HL: word with number of bytes to copy, then data
* < DE: source
memcpy_3e69_video:
    MAKE_HL    a0                                 | [$3e69: ld   c,(hl)]
    move.b    (a0)+,d2                             | [...]
    addq.w    #1,d6                               | [...]
    MAKE_H                                     | [...]
    move.b    (a0),d5                             | [...]
    move.b    d2,d6                               | [$3e6c: ld   l,c]
memcpy_3e6d_video:
    MAKE_HL    a0                                 | [$3e6d: ld   c,(hl)]
    move.b    (a0),d2                             | [...]
    addq.w    #1,d6                               | [...]
    MAKE_H                                     | [...]
    moveq    #0x00,d1                            | [$3e6f: ld   b,$00]
    jbsr    ldir_video                                  | [$3e71: ldir]
    rts
""")
