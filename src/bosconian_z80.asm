;	map(0x0000, 0x3fff).rom();
;	map(0x8000, 0x8fff).ram().w(FUNC(rallyx_state::videoram_w)).share(m_videoram);
;	map(0x9800, 0x9fff).ram();
;	map(0xa000, 0xa000).portr("P1");
;	map(0xa080, 0xa080).portr("P2");
;	map(0xa100, 0xa100).portr("DSW");
;	map(0xa000, 0xa00f).writeonly().share(m_radarattr);
;	map(0xa080, 0xa080).w("watchdog", FUNC(watchdog_timer_device::reset_w));
;	map(0xa100, 0xa11f).w(m_namco_sound, FUNC(namco_device::pacman_sound_w));
;	map(0xa130, 0xa130).w(FUNC(rallyx_state::scrollx_w));
;	map(0xa140, 0xa140).w(FUNC(rallyx_state::scrolly_w));
;	map(0xa170, 0xa170).nopw();            // ?
;	map(0xa180, 0xa187).w("mainlatch", FUNC(ls259_device::write_d0));

dummy_6830 = $6830
stack_save_89b7 = $89b7
nb_lives_83e2 = $83e2
p1_a000 = $a000
p2_a080 = $a080

reset_0000:  ; [global]
0000: 31 40 80    ld   sp,$8040
0003: C3 0E 01    jp   continue_boot_010e

add_2a_to_hl_0008:
0008: 87          add  a,a
0009: 30 05       jr   nc,$0010
000B: 24          inc  h
000C: C3 10 00    jp   $0010

add_a_to_hl_0010:
0010: 85          add  a,l
0011: 6F          ld   l,a
0012: D0          ret  nc
0013: 24          inc  h
0014: C9          ret

0018: 7C          ld   a,h
0019: 2F          cpl
001A: 67          ld   h,a
001B: 7D          ld   a,l
001C: 2F          cpl
001D: 6F          ld   l,a
001E: 23          inc  hl
001F: C9          ret

indirect_jump_0020:
0020: CF          rst  $08		; add_2a_to_hl_0008
0021: 7E          ld   a,(hl)   ; read lsb
0022: 23          inc  hl
0023: 66          ld   h,(hl)	; read msb
0024: 6F          ld   l,a
0025: E9          jp   (hl)		; jump


0028: CD 04 0D    call $0D04
002B: 3A E6 83    ld   a,($83E6)
002E: C9          ret

0030: 11 00 70    ld   de,$7000
0033: 06 00       ld   b,$00
0035: C3 D2 0B    jp   $0BD2

irq_0038:
0038: C3 E6 01    jp   irq_01e6

003B: 21 F7 89    ld   hl,$89F7
003E: 11 E3 8B    ld   de,$8BE3
0041: 06 03       ld   b,$03
0043: A7          and  a
0044: 1A          ld   a,(de)
0045: 8E          adc  a,(hl)
0046: 27          daa
0047: 77          ld   (hl),a
0048: 2B          dec  hl
0049: 1B          dec  de
004A: 10 F8       djnz $0044
004C: F5          push af
004D: 1A          ld   a,(de)
004E: E6 0F       and  $0F
0050: 4F          ld   c,a
0051: F1          pop  af
0052: 79          ld   a,c
0053: 8E          adc  a,(hl)
0054: 27          daa
0055: 77          ld   (hl),a
0056: C9          ret
0057: 1F          rra
0058: 1F          rra
0059: 1F          rra
005A: E6 02       and  $02
005C: F6 60       or   $60
005E: C9          ret
005F: 3A 06 68    ld   a,($6806)
0062: C3 29 04    jp   $0429

006C: 21 00 71    ld   hl,$7100
006F: 36 10       ld   (hl),$10
0071: F5          push af
0072: 2A 90 80    ld   hl,($8090)
0075: CB BD       res  7,l
0077: 7E          ld   a,(hl)
0078: A7          and  a
0079: 28 1E       jr   z,$0099
007B: 36 00       ld   (hl),$00
007D: F5          push af
007E: 2C          inc  l
007F: 2C          inc  l
0080: 4E          ld   c,(hl)
0081: 2C          inc  l
0082: 46          ld   b,(hl)
0083: 2C          inc  l
0084: 5E          ld   e,(hl)
0085: 2C          inc  l
0086: 56          ld   d,(hl)
0087: 2C          inc  l
0088: 7E          ld   a,(hl)
0089: 2C          inc  l
008A: 2C          inc  l
008B: 22 90 80    ld   ($8090),hl
008E: 2D          dec  l
008F: 66          ld   h,(hl)
0090: 6F          ld   l,a
0091: D9          exx
0092: F1          pop  af
0093: 32 00 71    ld   ($7100),a
0096: F1          pop  af
0097: ED 45       retn
0099: F1          pop  af
009A: D9          exx
009B: ED 45       retn

009D: 3E 07       ld   a,$07
009F: 32 30 98    ld   ($9830),a
00A2: 3A 04 68    ld   a,($6804)
00A5: 32 30 68    ld   (dummy_6830),a
00A8: E6 02       and  $02
00AA: C0          ret  nz
00AB: 01 FA 0D    ld   bc,$0DFA
00AE: 0D          dec  c
00AF: 20 FD       jr   nz,$00AE
00B1: 10 FB       djnz $00AE
00B3: 18 ED       jr   $00A2
00B5: 21 00 68    ld   hl,$6800
00B8: 06 08       ld   b,$08
00BA: 7E          ld   a,(hl)
00BB: 1F          rra
00BC: CB 1A       rr   d
00BE: 1F          rra
00BF: CB 1B       rr   e
00C1: 23          inc  hl
00C2: 10 F6       djnz $00BA
00C4: 7B          ld   a,e
00C5: E6 03       and  $03
00C7: 4F          ld   c,a
00C8: 7B          ld   a,e
00C9: E6 FC       and  $FC
00CB: 87          add  a,a
00CC: 30 02       jr   nc,$00D0
00CE: F6 04       or   $04
00D0: B1          or   c
00D1: 67          ld   h,a
00D2: 6A          ld   l,d
00D3: 22 50 80    ld   ($8050),hl
00D6: C9          ret
00D7: 3A AE 83    ld   a,($83AE)
00DA: A7          and  a
00DB: C0          ret  nz
00DC: 21 FC 89    ld   hl,$89FC
00DF: 34          inc  (hl)
00E0: 01 00 01    ld   bc,$0100
00E3: 7E          ld   a,(hl)
00E4: FE 3C       cp   $3C
00E6: C0          ret  nz
00E7: 71          ld   (hl),c
00E8: 2B          dec  hl
00E9: 7E          ld   a,(hl)
00EA: 80          add  a,b
00EB: 27          daa
00EC: 77          ld   (hl),a
00ED: D0          ret  nc
00EE: 2B          dec  hl
00EF: 7E          ld   a,(hl)
00F0: 80          add  a,b
00F1: 27          daa
00F2: 77          ld   (hl),a
00F3: D0          ret  nc
00F4: 2B          dec  hl
00F5: 78          ld   a,b
00F6: 86          add  a,(hl)
00F7: 27          daa
00F8: 77          ld   (hl),a
00F9: 2B          dec  hl
00FA: 79          ld   a,c
00FB: 8E          adc  a,(hl)
00FC: 27          daa
00FD: 77          ld   (hl),a
00FE: C9          ret

continue_boot_010e:
010E: 3E 10       ld   a,$10                                          
0110: 32 00 71    ld   ($7100),a                                      
0113: 21 E8 89    ld   hl,$89E8
0116: 06 18       ld   b,$18
0118: 36 00       ld   (hl),$00
011A: 23          inc  hl
011B: 10 FB       djnz $0118
011D: 3E 07       ld   a,$07
011F: 32 30 98    ld   ($9830),a
0122: C3 32 36    jp   rest_of_boot_3632

0125: 3E 10       ld   a,$10
0127: 32 9A 80    ld   ($809A),a
012A: 21 C0 83    ld   hl,$83C0
012D: 22 D0 83    ld   ($83D0),hl
0130: 2C          inc  l
0131: 22 D2 83    ld   ($83D2),hl
0134: CD B5 00    call $00B5
0137: 01 00 20    ld   bc,$2000
013A: 32 30 68    ld   (dummy_6830),a
013D: 0D          dec  c
013E: 20 FA       jr   nz,$013A
0140: 10 F8       djnz $013A
0142: 3A 51 80    ld   a,($8051)
0145: 1F          rra
0146: 1F          rra
0147: 3C          inc  a
0148: E6 01       and  $01
014A: 32 AD 89    ld   ($89AD),a
014D: 21 60 88    ld   hl,$8860
0150: 06 04       ld   b,$04
0152: 36 62       ld   (hl),$62
0154: 23          inc  hl
0155: 10 FB       djnz $0152
0157: 06 03       ld   b,$03
0159: 36 60       ld   (hl),$60
015B: 23          inc  hl
015C: 10 FB       djnz $0159
015E: 36 62       ld   (hl),$62
0160: 21 60 80    ld   hl,$8060
0163: 06 07       ld   b,$07
0165: 36 00       ld   (hl),$00
0167: 23          inc  hl
0168: 10 FB       djnz $0165
016A: 36 02       ld   (hl),$02
016C: 21 E4 8B    ld   hl,$8BE4
016F: 06 10       ld   b,$10
0171: 36 00       ld   (hl),$00
0173: 23          inc  hl
0174: 10 FB       djnz $0171
0176: 3E 02       ld   a,$02
0178: 32 E5 8B    ld   ($8BE5),a
017B: 32 E9 8B    ld   ($8BE9),a
017E: 32 ED 8B    ld   ($8BED),a
0181: 32 F1 8B    ld   ($8BF1),a
0184: 32 5D 88    ld   ($885D),a
0187: 21 FF 00    ld   hl,$00FF
018A: 11 C5 8B    ld   de,$8BC5
018D: 01 0F 00    ld   bc,$000F
0190: ED B0       ldir
0192: 3E 01       ld   a,$01
0194: 32 E5 83    ld   ($83E5),a
0197: CD B1 0C    call $0CB1
019A: ED 56       im   1
019C: 21 20 68    ld   hl,$6820
019F: 36 00       ld   (hl),$00
01A1: 36 01       ld   (hl),$01
01A3: FB          ei
01A4: CD 77 0E    call $0E77
01A7: 21 40 88    ld   hl,$8840
01AA: 06 08       ld   b,$08
01AC: 36 78       ld   (hl),$78
01AE: 23          inc  hl
01AF: 10 FB       djnz $01AC
01B1: 21 80 88    ld   hl,$8880
01B4: 06 08       ld   b,$08
01B6: 36 62       ld   (hl),$62
01B8: 23          inc  hl
01B9: 10 FB       djnz $01B6
01BB: 21 00 89    ld   hl,$8900
01BE: 06 08       ld   b,$08
01C0: 36 62       ld   (hl),$62
01C2: 2C          inc  l
01C3: 10 FB       djnz $01C0
01C5: 21 21 0D    ld   hl,$0D21
01C8: 11 00 81    ld   de,$8100
01CB: 0E 08       ld   c,$08
01CD: ED B0       ldir
01CF: 21 19 0D    ld   hl,$0D19
01D2: 11 40 80    ld   de,$8040
01D5: 0E 08       ld   c,$08
01D7: ED B0       ldir
01D9: 21 29 0D    ld   hl,$0D29
01DC: 11 80 80    ld   de,$8080
01DF: 0E 08       ld   c,$08
01E1: ED B0       ldir
01E3: C3 43 04    jp   $0443

irq_01e6:   ; [global]
01E6: E5          push hl
01E7: D5          push de
01E8: C5          push bc
01E9: F5          push af
01EA: 08          ex   af,af'
01EB: F5          push af
01EC: DD E5       push ix
01EE: FD E5       push iy
01F0: AF          xor  a
01F1: 32 20 68    ld   ($6820),a
01F4: CD 04 0D    call $0D04
01F7: 3A C0 8B    ld   a,($8BC0)
01FA: FE BB       cp   $BB
01FC: CA 1D 01    jp   z,$011D
01FF: FE A1       cp   $A1
0201: D4 6C 02    call nc,$026C
0204: 3A 18 82    ld   a,($8218)
0207: 3C          inc  a
0208: 32 70 98    ld   ($9870),a
020B: 3D          dec  a
020C: 3A CC 80    ld   a,($80CC)
020F: 28 02       jr   z,$0213
0211: EE 03       xor  $03
0213: 32 D4 83    ld   ($83D4),a
0216: 3A 6D 80    ld   a,($806D)
0219: 32 10 98    ld   ($9810),a
021C: 3A 6F 80    ld   a,($806F)
021F: 32 20 98    ld   ($9820),a
0222: 3A E0 83    ld   a,($83E0)
0225: 21 C8 03    ld   hl,$03C8
0228: 3C          inc  a
0229: 28 12       jr   z,$023D
022B: 21 CE 03    ld   hl,$03CE
022E: 3D          dec  a
022F: 28 0C       jr   z,$023D
0231: 21 F6 03    ld   hl,$03F6
0234: 3D          dec  a
0235: 28 06       jr   z,$023D
0237: 3D          dec  a
0238: 20 03       jr   nz,$023D
023A: 21 D8 03    ld   hl,jump_table_03d8
023D: AF          xor  a
023E: 32 BC 89    ld   ($89BC),a
0241: E5          push hl
0242: E7          rst  $20		; [nb_entries=36]
0243: E1          pop  hl
0244: 3A BC 89    ld   a,($89BC)
0247: 3C          inc  a
0248: 20 F4       jr   nz,$023E
024A: CD B5 00    call $00B5
024D: CD BB 16    call $16BB
0250: 3A 04 68    ld   a,($6804)
0253: 32 30 68    ld   (dummy_6830),a
0256: E6 02       and  $02
0258: CC 9D 00    call z,$009D
025B: 3E 01       ld   a,$01
025D: 32 20 68    ld   ($6820),a
0260: FD E1       pop  iy
0262: DD E1       pop  ix
0264: F1          pop  af
0265: 08          ex   af,af'
0266: F1          pop  af
0267: C1          pop  bc
0268: D1          pop  de
0269: E1          pop  hl
026A: FB          ei
026B: C9          ret

jump_table_03d8:
	.word	$1128 
	.word	$125A 
	.word	$0279 
	.word	$03A6 
	.word	$265B 
	.word	$1A8F
	.word	$0388
	.word	$035A
	.word	$0287
	.word	$1671
	.word	$0D49
	.word	$02D0 
	.word	$0315
	.word	$00D7
	.word	$03B2 
	.word	$1128
	.word	$125A 
	.word	$03B8
	.word	$265B
	.word	$1AAB
	.word	$0279 
	.word	$0287
	.word	$035A
	.word	$0D49
	.word	$02D0
	.word	$12CB
	.word	$02DE 
	.word	$02F5 
	.word	$03C3 
	.word	$005F 
	.word	$103A
	.word	$0EEF
	.word	$0315 
	.word	$1671 
	.word	$00D7 
	.word	$03B2


026C: 3A E0 83    ld   a,($83E0)
026F: 3C          inc  a
0270: C8          ret  z
0271: 21 59 80    ld   hl,$8059
0274: 34          inc  (hl)
0275: C0          ret  nz
0276: C3 00 00    jp   $0000

0279: 21 00 70    ld   hl,$7000
027C: 11 C0 8B    ld   de,$8BC0
027F: 01 03 00    ld   bc,$0003
0282: 3E 71       ld   a,$71
0284: C3 D2 0B    jp   $0BD2
0287: 21 E0 8B    ld   hl,$8BE0
028A: 3A EB 83    ld   a,($83EB)
028D: CB 77       bit  6,a
028F: 20 04       jr   nz,$0295
0291: CB 76       bit  6,(hl)
0293: 20 08       jr   nz,$029D
0295: CB 6F       bit  5,a
0297: 20 2E       jr   nz,$02C7
0299: CB 6E       bit  5,(hl)
029B: 28 2A       jr   z,$02C7
029D: 7E          ld   a,(hl)
029E: E6 0E       and  $0E
02A0: 20 25       jr   nz,$02C7
02A2: 3A EB 83    ld   a,($83EB)
02A5: B6          or   (hl)
02A6: 32 EB 83    ld   ($83EB),a
02A9: 7E          ld   a,(hl)
02AA: 21 EF 89    ld   hl,$89EF
02AD: 37          scf
02AE: 06 04       ld   b,$04
02B0: 3E 00       ld   a,$00
02B2: 8E          adc  a,(hl)
02B3: 27          daa
02B4: 77          ld   (hl),a
02B5: 2B          dec  hl
02B6: 10 F8       djnz $02B0
02B8: 21 E2 83    ld   hl,nb_lives_83e2
02BB: 7E          ld   a,(hl)
02BC: A7          and  a
02BD: C8          ret  z
02BE: 34          inc  (hl)
02BF: 21 0E 8A    ld   hl,$8A0E
02C2: 36 01       ld   (hl),$01
02C4: CD 63 0C    call $0C63
02C7: 3A BB 89    ld   a,($89BB)
02CA: 21 EB 83    ld   hl,$83EB
02CD: A6          and  (hl)
02CE: 77          ld   (hl),a
02CF: C9          ret
02D0: 21 00 70    ld   hl,$7000
02D3: 11 E0 8B    ld   de,$8BE0
02D6: 01 04 00    ld   bc,$0004
02D9: 3E 94       ld   a,$94
02DB: C3 D2 0B    jp   $0BD2
02DE: 3A AE 83    ld   a,($83AE)
02E1: A7          and  a
02E2: C0          ret  nz
02E3: 3A 7C 80    ld   a,($807C)
02E6: CD 57 00    call $0057
02E9: 2A B0 89    ld   hl,($89B0)
02EC: 77          ld   (hl),a
02ED: 23          inc  hl
02EE: 77          ld   (hl),a
02EF: 23          inc  hl
02F0: 77          ld   (hl),a
02F1: C9          ret
02F2: 23          inc  hl
02F3: 77          ld   (hl),a
02F4: C9          ret
02F5: 2A 68 80    ld   hl,($8068)
02F8: ED 5B 4C 80 ld   de,($804C)
02FC: 19          add  hl,de
02FD: 22 4C 80    ld   ($804C),hl
0300: 7C          ld   a,h
0301: 92          sub  d
0302: CD F8 16    call $16F8
0305: 2A 6A 80    ld   hl,($806A)
0308: ED 5B 4E 80 ld   de,($804E)
030C: 19          add  hl,de
030D: 22 4E 80    ld   ($804E),hl
0310: 7C          ld   a,h
0311: 92          sub  d
0312: C3 42 17    jp   $1742
0315: 2A CA 80    ld   hl,($80CA)
0318: 11 F0 FF    ld   de,$FFF0
031B: 19          add  hl,de
031C: 7D          ld   a,l
031D: CB 2C       sra  h
031F: 1F          rra
0320: CB 2C       sra  h
0322: 1F          rra
0323: CB 2C       sra  h
0325: 1F          rra
0326: CB 2C       sra  h
0328: CB 3F       srl  a
032A: ED 44       neg
032C: C6 9D       add  a,$9D
032E: FE 2F       cp   $2F
0330: 30 02       jr   nc,$0334
0332: 3E 2F       ld   a,$2F
0334: 21 CE 80    ld   hl,$80CE
0337: 77          ld   (hl),a
0338: 23          inc  hl
0339: 3A 7C 80    ld   a,($807C)
033C: 0F          rrca
033D: 0F          rrca
033E: E6 02       and  $02
0340: 77          ld   (hl),a
0341: ED 5B C8 80 ld   de,($80C8)
0345: 7B          ld   a,e
0346: CB 2A       sra  d
0348: 1F          rra
0349: CB 2A       sra  d
034B: 1F          rra
034C: CB 2A       sra  d
034E: 1F          rra
034F: 1F          rra
0350: E6 3F       and  $3F
0352: C6 E0       add  a,$E0
0354: 32 CD 80    ld   ($80CD),a
0357: D8          ret  c
0358: 34          inc  (hl)
0359: C9          ret
035A: 21 CD 80    ld   hl,$80CD
035D: 3A 18 82    ld   a,($8218)
0360: A7          and  a
0361: 20 10       jr   nz,$0373
0363: 11 F4 83    ld   de,$83F4
0366: ED A0       ldi
0368: 11 F4 8B    ld   de,$8BF4
036B: ED A0       ldi
036D: 11 04 98    ld   de,$9804
0370: ED A0       ldi
0372: C9          ret
0373: 3E 21       ld   a,$21
0375: 96          sub  (hl)
0376: 32 F4 83    ld   ($83F4),a
0379: 2C          inc  l
037A: 3E FC       ld   a,$FC
037C: 96          sub  (hl)
037D: 32 F4 8B    ld   ($8BF4),a
0380: 2C          inc  l
0381: 7E          ld   a,(hl)
0382: F6 01       or   $01
0384: 32 04 98    ld   ($9804),a
0387: C9          ret
0388: 11 FE 89    ld   de,$89FE
038B: 1A          ld   a,(de)
038C: 21 D4 8B    ld   hl,$8BD4
038F: A7          and  a
0390: C4 9A 03    call nz,$039A
0393: 13          inc  de
0394: 1A          ld   a,(de)
0395: 21 D5 83    ld   hl,$83D5
0398: A7          and  a
0399: C8          ret  z
039A: CB 7F       bit  7,a
039C: 28 04       jr   z,$03A2
039E: 3C          inc  a
039F: 12          ld   (de),a
03A0: 35          dec  (hl)
03A1: C9          ret
03A2: 3D          dec  a
03A3: 12          ld   (de),a
03A4: 34          inc  (hl)
03A5: C9          ret

03A6: 3A AE 83    ld   a,($83AE)
03A9: A7          and  a
03AA: C0          ret  nz
03AB: 21 BC 89    ld   hl,$89BC
03AE: 34          inc  (hl)
03AF: 34          inc  (hl)
03B0: 34          inc  (hl)
03B1: C9          ret
03B2: 3E FF       ld   a,$FF
03B4: 32 BC 89    ld   ($89BC),a
03B7: C9          ret
03B8: 3A D0 80    ld   a,($80D0)
03BB: A7          and  a
03BC: C8          ret  z
03BD: 21 BC 89    ld   hl,$89BC
03C0: 34          inc  (hl)
03C1: 34          inc  (hl)
03C2: C9          ret
03C3: 3A E3 83    ld   a,($83E3)
03C6: 18 F3       jr   $03BB

0420: 32 18 82    ld   ($8218),a
0423: 3A E2 83    ld   a,(nb_lives_83e2)
0426: C3 63 0C    jp   $0C63
0429: E6 02       and  $02
042B: C8          ret  z
042C: 2A B2 89    ld   hl,($89B2)
042F: CB 6E       bit  5,(hl)
0431: 21 7F 83    ld   hl,$837F
0434: 20 07       jr   nz,$043D
0436: 34          inc  (hl)
0437: C0          ret  nz
0438: 36 F0       ld   (hl),$F0
043A: C3 B1 10    jp   $10B1
043D: 36 F0       ld   (hl),$F0
043F: C9          ret

0443: 3A AD 89    ld   a,($89AD)
0446: 32 18 82    ld   ($8218),a
0449: 32 B4 89    ld   ($89B4),a
044C: 32 40 98    ld   ($9840),a
044F: 3E 03       ld   a,$03
0451: 32 78 83    ld   ($8378),a
0454: 3E 4E       ld   a,$4E
0456: CD 67 0B    call $0B67
0459: 3A C0 8B    ld   a,($8BC0)
045C: A7          and  a
045D: CC 1E 29    call z,$291E
0460: AF          xor  a
0461: 32 AE 83    ld   ($83AE),a
0464: 32 52 80    ld   ($8052),a
0467: 32 2C 83    ld   ($832C),a
046A: 32 35 83    ld   ($8335),a
046D: 32 4C 83    ld   ($834C),a
0470: 32 55 83    ld   ($8355),a
0473: 21 00 88    ld   hl,$8800
0476: 06 40       ld   b,$40
0478: 77          ld   (hl),a
0479: 23          inc  hl
047A: 10 FC       djnz $0478
047C: 21 FC 8B    ld   hl,$8BFC
047F: 77          ld   (hl),a
0480: 23          inc  hl
0481: 10 FC       djnz $047F
0483: 3E 4E       ld   a,$4E
0485: CD 67 0B    call $0B67
0488: F3          di
0489: 3A 00 71    ld   a,($7100)
048C: FE 10       cp   $10
048E: 20 F9       jr   nz,$0489
0490: 3E 02       ld   a,$02
0492: 32 00 70    ld   ($7000),a
0495: 21 CE 0B    ld   hl,$0BCE
0498: 3E C1       ld   a,$C1
049A: 0E 02       ld   c,$02
049C: F7          rst  $30
049D: C3 D1 04    jp   $04D1

04A0: 21 6F 7B    ld   hl,$7B6F
04A3: 3E FF       ld   a,$FF
04A5: 77          ld   (hl),a
04A6: 23          inc  hl
04A7: 77          ld   (hl),a
04A8: 2E 8F       ld   l,$8F
04AA: 77          ld   (hl),a
04AB: 23          inc  hl
04AC: 77          ld   (hl),a
04AD: 21 6F 7E    ld   hl,$7E6F
04B0: 77          ld   (hl),a
04B1: 23          inc  hl
04B2: 77          ld   (hl),a
04B3: 2E 8F       ld   l,$8F
04B5: 77          ld   (hl),a
04B6: 23          inc  hl
04B7: 77          ld   (hl),a
04B8: C9          ret
04B9: 3E 01       ld   a,$01
04BB: 32 E2 83    ld   (nb_lives_83e2),a
04BE: C3 88 05    jp   $0588
04C1: 27          daa
04C2: 47          ld   b,a
04C3: 7E          ld   a,(hl)
04C4: FE A0       cp   $A0
04C6: 30 06       jr   nc,$04CE
04C8: 21 0D 8A    ld   hl,$8A0D
04CB: 34          inc  (hl)
04CC: 10 FD       djnz $04CB
04CE: CD BA 0A    call $0ABA
04D1: 3A C0 8B    ld   a,($8BC0)
04D4: 21 E1 83    ld   hl,$83E1
04D7: 4E          ld   c,(hl)
04D8: 77          ld   (hl),a
04D9: 91          sub  c
04DA: 28 F2       jr   z,$04CE
04DC: 30 E3       jr   nc,$04C1
04DE: 47          ld   b,a
04DF: 79          ld   a,c
04E0: FE A1       cp   $A1
04E2: 30 EA       jr   nc,$04CE
04E4: 78          ld   a,b
04E5: E6 01       and  $01
04E7: 28 1E       jr   z,$0507
04E9: 21 39 0D    ld   hl,$0D39
04EC: 11 C0 80    ld   de,$80C0
04EF: 01 08 00    ld   bc,$0008
04F2: 3E 62       ld   a,$62
04F4: CD F9 07    call $07F9
04F7: 21 39 0D    ld   hl,$0D39
04FA: 11 E0 80    ld   de,$80E0
04FD: 0E 08       ld   c,$08
04FF: CD F9 07    call $07F9
0502: 3E 01       ld   a,$01
0504: C3 2E 05    jp   $052E
0507: 21 31 0D    ld   hl,$0D31
050A: 11 C0 80    ld   de,$80C0
050D: 01 08 00    ld   bc,$0008
0510: 3E 62       ld   a,$62
0512: CD F9 07    call $07F9
0515: 21 41 0D    ld   hl,$0D41
0518: 11 E0 80    ld   de,$80E0
051B: 0E 08       ld   c,$08
051D: CD F9 07    call $07F9
0520: 3A AB 89    ld   a,($89AB)
0523: 32 A8 89    ld   ($89A8),a
0526: 6F          ld   l,a
0527: 26 00       ld   h,$00
0529: 22 CC 81    ld   ($81CC),hl
052C: 3E 02       ld   a,$02
052E: 21 EB 89    ld   hl,$89EB
0531: 86          add  a,(hl)
0532: 27          daa
0533: 77          ld   (hl),a
0534: 06 03       ld   b,$03
0536: 3E 00       ld   a,$00
0538: 23          inc  hl
0539: 86          add  a,(hl)
053A: 27          daa
053B: 77          ld   (hl),a
053C: 10 F8       djnz $0536
053E: 21 29 0D    ld   hl,$0D29
0541: 11 80 80    ld   de,$8080
0544: 0E 08       ld   c,$08
0546: 3E 62       ld   a,$62
0548: CD F9 07    call $07F9
054B: 21 41 0D    ld   hl,$0D41
054E: 11 A0 80    ld   de,$80A0
0551: 0E 08       ld   c,$08
0553: CD F9 07    call $07F9
0556: 3A AB 89    ld   a,($89AB)
0559: 32 E2 83    ld   (nb_lives_83e2),a
055C: 6F          ld   l,a
055D: 26 00       ld   h,$00
055F: 22 CA 81    ld   ($81CA),hl
0562: 21 A5 80    ld   hl,$80A5
0565: 22 AE 89    ld   ($89AE),hl
0568: 21 84 88    ld   hl,$8884
056B: 22 B0 89    ld   ($89B0),hl
056E: 21 C1 8B    ld   hl,$8BC1
0571: 22 B2 89    ld   ($89B2),hl
0574: CD 1E 0A    call $0A1E
0577: 3E 01       ld   a,$01
0579: 32 09 8A    ld   ($8A09),a
057C: 21 01 01    ld   hl,$0101
057F: 22 DC 89    ld   ($89DC),hl
0582: 3A E2 83    ld   a,(nb_lives_83e2)
0585: CD 63 0C    call $0C63
0588: AF          xor  a
0589: 67          ld   h,a
058A: 6F          ld   l,a
058B: 22 DE 89    ld   ($89DE),hl
058E: 32 E4 83    ld   ($83E4),a
0591: 32 A9 89    ld   ($89A9),a
0594: 32 AC 89    ld   ($89AC),a
0597: 32 E5 83    ld   ($83E5),a
059A: 32 AA 89    ld   ($89AA),a
059D: 3E 02       ld   a,$02
059F: 32 E0 83    ld   ($83E0),a
05A2: 21 E5 83    ld   hl,$83E5
05A5: 34          inc  (hl)
05A6: AF          xor  a
05A7: 32 52 80    ld   ($8052),a
05AA: 3C          inc  a
05AB: 32 EF 83    ld   ($83EF),a
05AE: 21 DE 89    ld   hl,$89DE
05B1: 34          inc  (hl)
05B2: CD F9 0C    call $0CF9
05B5: 21 48 80    ld   hl,$8048
05B8: CB C6       set  0,(hl)
05BA: CB 46       bit  0,(hl)
05BC: 20 FC       jr   nz,$05BA
05BE: CD A0 04    call $04A0
05C1: 11 E8 80    ld   de,$80E8
05C4: 3E 01       ld   a,$01
05C6: 32 DE 80    ld   ($80DE),a
05C9: 3A E4 83    ld   a,($83E4)
05CC: 47          ld   b,a
05CD: 1A          ld   a,(de)
05CE: 67          ld   h,a
05CF: 13          inc  de
05D0: 1A          ld   a,(de)
05D1: 6F          ld   l,a
05D2: CD 4E 0C    call $0C4E
05D5: 16 83       ld   d,$83
05D7: 7B          ld   a,e
05D8: E6 9F       and  $9F
05DA: 5F          ld   e,a
05DB: 1A          ld   a,(de)
05DC: 16 80       ld   d,$80
05DE: CB F3       set  6,e
05E0: CB EB       set  5,e
05E2: 13          inc  de
05E3: 0E 0A       ld   c,$0A
05E5: 3D          dec  a
05E6: 28 02       jr   z,$05EA
05E8: 0E 06       ld   c,$06
05EA: CD 16 0C    call $0C16
05ED: 10 DE       djnz $05CD
05EF: CD A0 0D    call $0DA0
05F2: 21 1E 00    ld   hl,$001E
05F5: 22 74 80    ld   ($8074),hl
05F8: 21 48 80    ld   hl,$8048
05FB: CB CE       set  1,(hl)
05FD: CB 4E       bit  1,(hl)
05FF: 20 FC       jr   nz,$05FD
0601: CD B1 0C    call $0CB1
0604: CD 77 0E    call $0E77
0607: CD 91 0E    call $0E91
060A: DD 21 08 81 ld   ix,$8108
060E: 11 20 00    ld   de,$0020
0611: 06 07       ld   b,$07
0613: AF          xor  a
0614: DD 77 00    ld   (ix+$00),a
0617: DD 77 14    ld   (ix+$14),a
061A: DD 77 13    ld   (ix+$13),a
061D: DD 36 0E 02 ld   (ix+$0e),$02
0621: DD 19       add  ix,de
0623: 10 EF       djnz $0614
0625: 32 1A 82    ld   ($821A),a
0628: 3A AE 83    ld   a,($83AE)
062B: A7          and  a
062C: 20 47       jr   nz,$0675
062E: CD 48 0A    call $0A48
0631: 3A B4 89    ld   a,($89B4)
0634: 00          nop
0635: 00          nop
0636: 00          nop
0637: 3E 41       ld   a,$41
0639: CD 67 0B    call $0B67
063C: 32 CC 80    ld   ($80CC),a
063F: 21 93 0B    ld   hl,$0B93
0642: 11 E8 85    ld   de,$85E8
0645: 01 06 00    ld   bc,$0006
0648: ED B0       ldir
064A: 3A AC 89    ld   a,($89AC)
064D: 0F          rrca
064E: D7          rst  $10   ; add_a_to_hl
064F: 01 04 00    ld   bc,$0004
0652: ED B0       ldir
0654: 21 8E 0B    ld   hl,$0B8E
0657: 11 2B 86    ld   de,$862B
065A: 01 05 00    ld   bc,$0005
065D: ED B0       ldir
065F: CD 15 03    call $0315
0662: CD 5A 03    call $035A
0665: AF          xor  a
0666: 32 7C 80    ld   ($807C),a
0669: 3A 7C 80    ld   a,($807C)
066C: FE 50       cp   $50
066E: 38 F9       jr   c,$0669
0670: 3E 3C       ld   a,$3C
0672: 32 D0 80    ld   ($80D0),a
0675: 21 48 80    ld   hl,$8048
0678: CB D6       set  2,(hl)
067A: CB 56       bit  2,(hl)
067C: 20 FC       jr   nz,$067A
067E: 3A 09 8A    ld   a,($8A09)
0681: A7          and  a
0682: 20 FA       jr   nz,$067E
0684: 3A AE 83    ld   a,($83AE)
0687: A7          and  a
0688: C4 C9 2C    call nz,$2CC9
068B: 3E 03       ld   a,$03
068D: 32 E0 83    ld   ($83E0),a
0690: 3A E2 83    ld   a,(nb_lives_83e2)
0693: 3D          dec  a
0694: CD 63 0C    call $0C63
0697: 3E 01       ld   a,$01
0699: 32 0B 8A    ld   ($8A0B),a
069C: 21 88 83    ld   hl,$8388
069F: 06 08       ld   b,$08
06A1: AF          xor  a
06A2: 77          ld   (hl),a
06A3: 2C          inc  l
06A4: 2C          inc  l
06A5: 10 FB       djnz $06A2
06A7: 21 D4 83    ld   hl,$83D4
06AA: 36 00       ld   (hl),$00
06AC: 23          inc  hl
06AD: 36 6A       ld   (hl),$6A
06AF: CB DC       set  3,h
06B1: 36 01       ld   (hl),$01
06B3: 2D          dec  l
06B4: 36 74       ld   (hl),$74
06B6: 3A 18 82    ld   a,($8218)
06B9: A7          and  a
06BA: 28 07       jr   z,$06C3
06BC: 36 7C       ld   (hl),$7C
06BE: 2C          inc  l
06BF: CB 9C       res  3,h
06C1: 36 8A       ld   (hl),$8A
06C3: AF          xor  a
06C4: 32 E9 81    ld   ($81E9),a
06C7: 32 8C 80    ld   ($808C),a
06CA: 32 8A 80    ld   ($808A),a
06CD: 32 CC 80    ld   ($80CC),a
06D0: 32 2C 83    ld   ($832C),a
06D3: 32 35 83    ld   ($8335),a
06D6: 32 4C 83    ld   ($834C),a
06D9: 32 55 83    ld   ($8355),a
06DC: 32 9B 80    ld   ($809B),a
06DF: 21 00 00    ld   hl,$0000
06E2: 22 79 83    ld   ($8379),hl
06E5: 22 7B 83    ld   ($837B),hl
06E8: 3E 01       ld   a,$01
06EA: 32 EF 83    ld   ($83EF),a
06ED: 3E F0       ld   a,$F0
06EF: 32 F0 83    ld   ($83F0),a
06F2: 21 F0 01    ld   hl,$01F0
06F5: 22 F2 83    ld   ($83F2),hl
06F8: 3E 01       ld   a,$01
06FA: 32 5A 80    ld   ($805A),a
06FD: 3A AE 83    ld   a,($83AE)
0700: A7          and  a
0701: C4 1D 30    call nz,$301D
0704: 3A E4 83    ld   a,($83E4)
0707: A7          and  a
0708: CA 53 0A    jp   z,$0A53
070B: 3A AE 83    ld   a,($83AE)
070E: A7          and  a
070F: 20 00       jr   nz,$0711
0711: 3A E0 83    ld   a,($83E0)
0714: FE 03       cp   $03
0716: D2 FD 06    jp   nc,$06FD
0719: 3A E0 83    ld   a,($83E0)
071C: FE 03       cp   $03
071E: 30 F9       jr   nc,$0719
0720: 2A B0 89    ld   hl,($89B0)
0723: 36 62       ld   (hl),$62
0725: 2C          inc  l
0726: 36 62       ld   (hl),$62
0728: 2C          inc  l
0729: 36 62       ld   (hl),$62
072B: CD 15 08    call $0815
072E: AF          xor  a
072F: 32 D4 8B    ld   ($8BD4),a
0732: 32 E3 83    ld   ($83E3),a
0735: 32 09 82    ld   ($8209),a
0738: 32 DE 80    ld   ($80DE),a
073B: 32 DF 80    ld   ($80DF),a
073E: 32 52 80    ld   ($8052),a
0741: 21 88 80    ld   hl,$8088
0744: 06 06       ld   b,$06
0746: 77          ld   (hl),a
0747: 23          inc  hl
0748: 10 FC       djnz $0746
074A: 3A DC 89    ld   a,($89DC)
074D: FE 06       cp   $06
074F: 38 02       jr   c,$0753
0751: 3E 06       ld   a,$06
0753: 32 DC 89    ld   ($89DC),a
0756: 3A AE 83    ld   a,($83AE)
0759: A7          and  a
075A: C0          ret  nz
075B: 21 E2 83    ld   hl,nb_lives_83e2
075E: 35          dec  (hl)
075F: CA D3 08    jp   z,$08D3
0762: AF          xor  a
0763: 32 7C 80    ld   ($807C),a
0766: 32 D4 83    ld   ($83D4),a
0769: 3A 7C 80    ld   a,($807C)
076C: FE 50       cp   $50
076E: 38 F9       jr   c,$0769
0770: 3A E4 83    ld   a,($83E4)
0773: A7          and  a
0774: 20 05       jr   nz,$077B
0776: 3E 01       ld   a,$01
0778: 32 0C 8A    ld   ($8A0C),a
077B: 3A A8 89    ld   a,($89A8)
077E: A7          and  a
077F: 28 03       jr   z,$0784
0781: CD 9A 07    call $079A
0784: 3A 0C 8A    ld   a,($8A0C)
0787: A7          and  a
0788: 20 FA       jr   nz,$0784
078A: 3A B4 89    ld   a,($89B4)
078D: CD 20 04    call $0420
0790: 3A E4 83    ld   a,($83E4)
0793: A7          and  a
0794: CA 88 0A    jp   z,$0A88
0797: C3 F2 05    jp   $05F2
079A: CD 50 08    call $0850
079D: ED 5B B0 89 ld   de,($89B0)
07A1: 3A AC 89    ld   a,($89AC)
07A4: EE 08       xor  $08
07A6: 32 AC 89    ld   ($89AC),a
07A9: 2A CA 81    ld   hl,($81CA)
07AC: ED 5B CC 81 ld   de,($81CC)
07B0: 22 CC 81    ld   ($81CC),hl
07B3: ED 53 CA 81 ld   ($81CA),de
07B7: 21 05 08    ld   hl,$0805
07BA: D7          rst  $10   ; add_a_to_hl
07BB: 4E          ld   c,(hl)
07BC: 23          inc  hl
07BD: 46          ld   b,(hl)
07BE: ED 43 AE 89 ld   ($89AE),bc
07C2: 23          inc  hl
07C3: 4E          ld   c,(hl)
07C4: 23          inc  hl
07C5: 46          ld   b,(hl)
07C6: ED 43 B0 89 ld   ($89B0),bc
07CA: 23          inc  hl
07CB: 3A AD 89    ld   a,($89AD)
07CE: A6          and  (hl)
07CF: 32 B4 89    ld   ($89B4),a
07D2: 23          inc  hl
07D3: 3A AD 89    ld   a,($89AD)
07D6: A6          and  (hl)
07D7: 3C          inc  a
07D8: F6 C0       or   $C0
07DA: 6F          ld   l,a
07DB: 26 8B       ld   h,$8B
07DD: 22 B2 89    ld   ($89B2),hl
07E0: 3E 62       ld   a,$62
07E2: 12          ld   (de),a
07E3: 1C          inc  e
07E4: 12          ld   (de),a
07E5: 1C          inc  e
07E6: 12          ld   (de),a
07E7: 3A AC 89    ld   a,($89AC)
07EA: F6 60       or   $60
07EC: 32 B5 89    ld   ($89B5),a
07EF: 21 B5 89    ld   hl,$89B5
07F2: 0E 01       ld   c,$01
07F4: 3E 64       ld   a,$64
07F6: C3 30 00    jp   $0030
07F9: 41          ld   b,c
07FA: 0C          inc  c
07FB: CB DA       set  3,d
07FD: 12          ld   (de),a
07FE: CB 9A       res  3,d
0800: ED A0       ldi
0802: 10 F7       djnz $07FB
0804: C9          ret

0815: AF          xor  a
0816: 32 E3 83    ld   ($83E3),a
0819: 21 68 80    ld   hl,$8068
081C: 06 04       ld   b,$04
081E: 77          ld   (hl),a
081F: 2C          inc  l
0820: 10 FC       djnz $081E
0822: 21 70 80    ld   hl,$8070
0825: 77          ld   (hl),a
0826: 2C          inc  l
0827: 77          ld   (hl),a
0828: 21 D6 8B    ld   hl,$8BD6
082B: 06 0A       ld   b,$0A
082D: 77          ld   (hl),a
082E: 2C          inc  l
082F: 10 FC       djnz $082D
0831: 32 2C 83    ld   ($832C),a
0834: 32 35 83    ld   ($8335),a
0837: 32 4C 83    ld   ($834C),a
083A: 32 55 83    ld   ($8355),a
083D: 32 08 8A    ld   ($8A08),a
0840: 32 0B 8A    ld   ($8A0B),a
0843: 32 14 8A    ld   ($8A14),a
0846: 32 F6 8B    ld   ($8BF6),a
0849: 32 F5 8B    ld   ($8BF5),a
084C: 32 8D 80    ld   ($808D),a
084F: C9          ret
0850: 21 A8 89    ld   hl,$89A8
0853: 11 E2 83    ld   de,nb_lives_83e2
0856: CD CC 08    call $08CC
0859: 1C          inc  e
085A: CD CC 08    call $08CC
085D: CD CC 08    call $08CC
0860: 2A EB 83    ld   hl,($83EB)
0863: 7D          ld   a,l
0864: 6C          ld   l,h
0865: 67          ld   h,a
0866: 22 EB 83    ld   ($83EB),hl
0869: 2A DE 89    ld   hl,($89DE)
086C: 7D          ld   a,l
086D: 6C          ld   l,h
086E: 67          ld   h,a
086F: 22 DE 89    ld   ($89DE),hl
0872: 2A DC 89    ld   hl,($89DC)
0875: 7D          ld   a,l
0876: 6C          ld   l,h
0877: 67          ld   h,a
0878: 22 DC 89    ld   ($89DC),hl
087B: 21 E8 80    ld   hl,$80E8
087E: 11 48 88    ld   de,$8848
0881: 01 11 10    ld   bc,$1011
0884: CD CC 08    call $08CC
0887: 10 FB       djnz $0884
0889: 21 28 82    ld   hl,$8228
088C: 11 68 88    ld   de,$8868
088F: 06 08       ld   b,$08
0891: C5          push bc
0892: 01 19 18    ld   bc,$1819
0895: CD CC 08    call $08CC
0898: 10 FB       djnz $0895
089A: 01 08 00    ld   bc,$0008
089D: 09          add  hl,bc
089E: EB          ex   de,hl
089F: 09          add  hl,bc
08A0: C1          pop  bc
08A1: 10 EE       djnz $0891
08A3: 21 88 83    ld   hl,$8388
08A6: 11 68 89    ld   de,$8968
08A9: 01 11 10    ld   bc,$1011
08AC: CD CC 08    call $08CC
08AF: 10 FB       djnz $08AC
08B1: 21 B0 83    ld   hl,$83B0
08B4: 11 88 89    ld   de,$8988
08B7: 01 11 10    ld   bc,$1011
08BA: CD CC 08    call $08CC
08BD: 10 FB       djnz $08BA
08BF: 21 00 78    ld   hl,$7800
08C2: 7E          ld   a,(hl)
08C3: ED 67       rrd  (hl)
08C5: 23          inc  hl
08C6: 7C          ld   a,h
08C7: FE 7F       cp   $7F
08C9: 20 F7       jr   nz,$08C2
08CB: C9          ret
08CC: 1A          ld   a,(de)
08CD: ED A0       ldi
08CF: 2B          dec  hl
08D0: 77          ld   (hl),a
08D1: 23          inc  hl
08D2: C9          ret
08D3: AF          xor  a
08D4: 32 7C 80    ld   ($807C),a
08D7: 3A 7C 80    ld   a,($807C)
08DA: FE 20       cp   $20
08DC: 38 F9       jr   c,$08D7
08DE: 3A E2 83    ld   a,(nb_lives_83e2)
08E1: A7          and  a
08E2: C2 62 07    jp   nz,$0762
08E5: 2A B0 89    ld   hl,($89B0)
08E8: 36 62       ld   (hl),$62
08EA: 2C          inc  l
08EB: 36 62       ld   (hl),$62
08ED: 2C          inc  l
08EE: 36 62       ld   (hl),$62
08F0: 3E 40       ld   a,$40
08F2: CD 67 0B    call $0B67
08F5: 21 A1 0B    ld   hl,$0BA1
08F8: 3A 18 82    ld   a,($8218)
08FB: A7          and  a
08FC: 28 03       jr   z,$0901
08FE: 21 B1 0B    ld   hl,$0BB1
0901: 11 D6 83    ld   de,$83D6
0904: 01 08 00    ld   bc,$0008
0907: ED B0       ldir
0909: 11 D6 8B    ld   de,$8BD6
090C: 0E 08       ld   c,$08
090E: ED B0       ldir
0910: AF          xor  a
0911: 32 52 80    ld   ($8052),a
0914: 32 7C 80    ld   ($807C),a
0917: 3A 7C 80    ld   a,($807C)
091A: 3D          dec  a
091B: 3D          dec  a
091C: 20 F9       jr   nz,$0917
091E: 3A E0 8B    ld   a,($8BE0)
0921: 87          add  a,a
0922: 30 11       jr   nc,$0935
0924: E6 18       and  $18
0926: 20 0D       jr   nz,$0935
0928: 3E 01       ld   a,$01
092A: 32 0A 8A    ld   ($8A0A),a
092D: CD 48 0A    call $0A48
0930: CD 7A 19    call $197A
0933: 18 07       jr   $093C
0935: 3A 7C 80    ld   a,($807C)
0938: FE A0       cp   $A0
093A: 38 F9       jr   c,$0935
093C: CD 3B 00    call $003B
093F: CD 4D 31    call $314D
0942: CD 48 0A    call $0A48
0945: 3A A8 89    ld   a,($89A8)
0948: A7          and  a
0949: 3E 00       ld   a,$00
094B: C2 7B 07    jp   nz,$077B
094E: 32 E0 83    ld   ($83E0),a
0951: 3A 51 80    ld   a,($8051)
0954: E6 08       and  $08
0956: CA 43 04    jp   z,$0443
0959: 3A AC 89    ld   a,($89AC)
095C: A7          and  a
095D: C4 9A 07    call nz,$079A
0960: 3E 4E       ld   a,$4E
0962: CD 67 0B    call $0B67
0965: 3A B4 89    ld   a,($89B4)
0968: 32 18 82    ld   ($8218),a
096B: CD B3 18    call $18B3
096E: F3          di
096F: 3A 00 71    ld   a,($7100)
0972: FE 10       cp   $10
0974: 20 F9       jr   nz,$096F
0976: 3E 02       ld   a,$02
0978: 32 00 70    ld   ($7000),a
097B: 21 CE 0B    ld   hl,$0BCE
097E: 3E C1       ld   a,$C1
0980: 0E 02       ld   c,$02
0982: F7          rst  $30
0983: 3E F5       ld   a,$F5
0985: 32 7A 83    ld   ($837A),a
0988: 18 16       jr   $09A0
098A: 27          daa
098B: 47          ld   b,a
098C: 7E          ld   a,(hl)
098D: FE A0       cp   $A0
098F: 30 06       jr   nc,$0997
0991: 21 0D 8A    ld   hl,$8A0D
0994: 34          inc  (hl)
0995: 10 FD       djnz $0994
0997: CD B3 18    call $18B3
099A: 3A 7A 83    ld   a,($837A)
099D: 3C          inc  a
099E: 28 65       jr   z,$0A05
09A0: 3A C0 8B    ld   a,($8BC0)
09A3: 21 E1 83    ld   hl,$83E1
09A6: 4E          ld   c,(hl)
09A7: 77          ld   (hl),a
09A8: 91          sub  c
09A9: 28 EC       jr   z,$0997
09AB: 30 DD       jr   nc,$098A
09AD: E6 01       and  $01
09AF: 28 1B       jr   z,$09CC
09B1: 21 39 0D    ld   hl,$0D39
09B4: 11 C0 80    ld   de,$80C0
09B7: 01 08 00    ld   bc,$0008
09BA: 3E 62       ld   a,$62
09BC: CD F9 07    call $07F9
09BF: 21 39 0D    ld   hl,$0D39
09C2: 11 E0 80    ld   de,$80E0
09C5: 0E 08       ld   c,$08
09C7: CD F9 07    call $07F9
09CA: 18 23       jr   $09EF
09CC: 3A C4 80    ld   a,($80C4)
09CF: FE 24       cp   $24
09D1: CA 07 05    jp   z,$0507
09D4: 3A AB 89    ld   a,($89AB)
09D7: 3C          inc  a
09D8: 32 A8 89    ld   ($89A8),a
09DB: 21 CC 81    ld   hl,$81CC
09DE: CD 14 0A    call $0A14
09E1: 21 31 0D    ld   hl,$0D31
09E4: 11 C0 80    ld   de,$80C0
09E7: 01 08 00    ld   bc,$0008
09EA: 3E 62       ld   a,$62
09EC: CD F9 07    call $07F9
09EF: 3A AB 89    ld   a,($89AB)
09F2: 3C          inc  a
09F3: 32 E2 83    ld   (nb_lives_83e2),a
09F6: 21 CA 81    ld   hl,$81CA
09F9: CD 14 0A    call $0A14
09FC: 21 A5 80    ld   hl,$80A5
09FF: 22 AE 89    ld   ($89AE),hl
0A02: C3 84 07    jp   $0784
0A05: 3A C0 8B    ld   a,($8BC0)
0A08: A7          and  a
0A09: CA 43 04    jp   z,$0443
0A0C: 3E 4E       ld   a,$4E
0A0E: CD 67 0B    call $0B67
0A11: C3 D1 04    jp   $04D1
0A14: 86          add  a,(hl)
0A15: 27          daa
0A16: 77          ld   (hl),a
0A17: 23          inc  hl
0A18: 3E 00       ld   a,$00
0A1A: 8E          adc  a,(hl)
0A1B: 27          daa
0A1C: 77          ld   (hl),a
0A1D: C9          ret
0A1E: 21 40 04    ld   hl,$0440
0A21: 0E 03       ld   c,$03
0A23: 3E 84       ld   a,$84
0A25: F7          rst  $30
0A26: AF          xor  a
0A27: 32 EB 83    ld   ($83EB),a
0A2A: 32 EC 83    ld   ($83EC),a
0A2D: 3A 7C 80    ld   a,($807C)
0A30: C6 02       add  a,$02
0A32: 4F          ld   c,a
0A33: 3A 7C 80    ld   a,($807C)
0A36: B9          cp   c
0A37: 20 FA       jr   nz,$0A33
0A39: 21 E0 8B    ld   hl,$8BE0
0A3C: 7E          ld   a,(hl)
0A3D: E6 0F       and  $0F
0A3F: 06 03       ld   b,$03
0A41: 23          inc  hl
0A42: B6          or   (hl)
0A43: 10 FC       djnz $0A41
0A45: 20 D7       jr   nz,$0A1E
0A47: C9          ret
0A48: 21 D4 8B    ld   hl,$8BD4
0A4B: 06 0C       ld   b,$0C
0A4D: 36 00       ld   (hl),$00
0A4F: 23          inc  hl
0A50: 10 FB       djnz $0A4D
0A52: C9          ret
0A53: 3A E3 83    ld   a,($83E3)
0A56: A7          and  a
0A57: C2 19 07    jp   nz,$0719
0A5A: 3E 02       ld   a,$02
0A5C: 32 E0 83    ld   ($83E0),a
0A5F: CD 15 08    call $0815
0A62: 32 7C 80    ld   ($807C),a
0A65: 3A AE 83    ld   a,($83AE)
0A68: A7          and  a
0A69: C0          ret  nz
0A6A: 2A B0 89    ld   hl,($89B0)
0A6D: 36 62       ld   (hl),$62
0A6F: 2C          inc  l
0A70: 36 62       ld   (hl),$62
0A72: 2C          inc  l
0A73: 36 62       ld   (hl),$62
0A75: 3A 7C 80    ld   a,($807C)
0A78: FE 50       cp   $50
0A7A: 38 F9       jr   c,$0A75
0A7C: 3E 01       ld   a,$01
0A7E: 32 0C 8A    ld   ($8A0C),a
0A81: 3A DE 80    ld   a,($80DE)
0A84: A7          and  a
0A85: C4 91 0A    call nz,$0A91
0A88: 3A 0C 8A    ld   a,($8A0C)
0A8B: A7          and  a
0A8C: 20 FA       jr   nz,$0A88
0A8E: C3 A2 05    jp   $05A2
0A91: 21 DF 80    ld   hl,$80DF
0A94: 34          inc  (hl)
0A95: 4E          ld   c,(hl)
0A96: 21 DE 89    ld   hl,$89DE
0A99: 7E          ld   a,(hl)
0A9A: FE 07       cp   $07
0A9C: 30 03       jr   nc,$0AA1
0A9E: 34          inc  (hl)
0A9F: 18 11       jr   $0AB2
0AA1: FE 0C       cp   $0C
0AA3: 30 06       jr   nc,$0AAB
0AA5: 0D          dec  c
0AA6: 28 0A       jr   z,$0AB2
0AA8: 34          inc  (hl)
0AA9: 18 07       jr   $0AB2
0AAB: 0D          dec  c
0AAC: 28 04       jr   z,$0AB2
0AAE: 0D          dec  c
0AAF: 28 01       jr   z,$0AB2
0AB1: 34          inc  (hl)
0AB2: 3A 1B 82    ld   a,($821B)
0AB5: A7          and  a
0AB6: C8          ret  z
0AB7: C3 AC 30    jp   $30AC
0ABA: 21 16 0B    ld   hl,$0B16
0ABD: CD 37 1A    call $1A37
0AC0: 3A C0 8B    ld   a,($8BC0)
0AC3: A7          and  a
0AC4: C8          ret  z
0AC5: 21 2B 0B    ld   hl,$0B2B
0AC8: 3D          dec  a
0AC9: 28 03       jr   z,$0ACE
0ACB: 21 3D 0B    ld   hl,$0B3D
0ACE: CD 37 1A    call $1A37
0AD1: 11 01 86    ld   de,$8601
0AD4: CD 44 3B    call $3B44
0AD7: 11 68 87    ld   de,$8768
0ADA: 21 B0 2B    ld   hl,$2BB0
0ADD: 46          ld   b,(hl)
0ADE: 23          inc  hl
0ADF: CD C6 0B    call $0BC6
0AE2: 3A E1 83    ld   a,($83E1)
0AE5: FE A0       cp   $A0
0AE7: 28 27       jr   z,$0B10
0AE9: D0          ret  nc
0AEA: 21 4F 0B    ld   hl,$0B4F
0AED: CD 37 1A    call $1A37
0AF0: 3A E1 83    ld   a,($83E1)
0AF3: 0F          rrca
0AF4: 0F          rrca
0AF5: 0F          rrca
0AF6: 0F          rrca
0AF7: 21 F0 86    ld   hl,$86F0
0AFA: E6 0F       and  $0F
0AFC: 20 02       jr   nz,$0B00
0AFE: 3E 24       ld   a,$24
0B00: 77          ld   (hl),a
0B01: 23          inc  hl
0B02: 3A E1 83    ld   a,($83E1)
0B05: E6 0F       and  $0F
0B07: 77          ld   (hl),a
0B08: CB DC       set  3,h
0B0A: 36 62       ld   (hl),$62
0B0C: 2B          dec  hl
0B0D: 36 62       ld   (hl),$62
0B0F: C9          ret
0B10: 21 5A 0B    ld   hl,$0B5A
0B13: C3 37 1A    jp   $1A37

0B67: 21 00 84    ld   hl,$8400
0B6A: 11 01 84    ld   de,$8401
0B6D: 01 FF 03    ld   bc,$03FF
0B70: 36 24       ld   (hl),$24
0B72: ED B0       ldir
0B74: 21 00 8C    ld   hl,$8C00
0B77: 11 01 8C    ld   de,$8C01
0B7A: 01 FF 03    ld   bc,$03FF
0B7D: 77          ld   (hl),a
0B7E: ED B0       ldir
0B80: AF          xor  a
0B81: 32 6D 80    ld   ($806D),a
0B84: 32 6F 80    ld   ($806F),a
0B87: 32 10 98    ld   ($9810),a
0B8A: 32 20 98    ld   ($9820),a
0B8D: C9          ret


0BC1: 5E          ld   e,(hl)
0BC2: 23          inc  hl
0BC3: 56          ld   d,(hl)
0BC4: 23          inc  hl
0BC5: 46          ld   b,(hl)
0BC6: 23          inc  hl
0BC7: 7E          ld   a,(hl)
0BC8: 12          ld   (de),a
0BC9: 13          inc  de
0BCA: 10 FA       djnz $0BC6
0BCC: 23          inc  hl
0BCD: C9          ret
0BCE: 02          ld   (bc),a
0BCF: 02          ld   (bc),a
0BD0: 02          ld   (bc),a
0BD1: 02          ld   (bc),a
0BD2: F3          di
0BD3: 08          ex   af,af'
0BD4: 3A 00 71    ld   a,($7100)
0BD7: E6 E0       and  $E0
0BD9: 20 07       jr   nz,$0BE2
0BDB: 08          ex   af,af'
0BDC: D9          exx
0BDD: 32 00 71    ld   ($7100),a
0BE0: FB          ei
0BE1: C9          ret
0BE2: E5          push hl
0BE3: D5          push de
0BE4: EB          ex   de,hl
0BE5: 2A 92 80    ld   hl,($8092)
0BE8: CB BD       res  7,l
0BEA: 7D          ld   a,l
0BEB: C6 08       add  a,$08
0BED: 6F          ld   l,a
0BEE: 22 92 80    ld   ($8092),hl
0BF1: 2D          dec  l
0BF2: 72          ld   (hl),d
0BF3: 2D          dec  l
0BF4: 73          ld   (hl),e
0BF5: 2D          dec  l
0BF6: D1          pop  de
0BF7: 72          ld   (hl),d
0BF8: 2D          dec  l
0BF9: 73          ld   (hl),e
0BFA: 2D          dec  l
0BFB: 70          ld   (hl),b
0BFC: 2D          dec  l
0BFD: 71          ld   (hl),c
0BFE: 2D          dec  l
0BFF: 2D          dec  l
0C00: 08          ex   af,af'
0C01: 77          ld   (hl),a
0C02: 3A 00 71    ld   a,($7100)
0C05: FE 10       cp   $10
0C07: 28 03       jr   z,$0C0C
0C09: E1          pop  hl
0C0A: FB          ei
0C0B: C9          ret
0C0C: 7E          ld   a,(hl)
0C0D: 36 00       ld   (hl),$00
0C0F: 22 92 80    ld   ($8092),hl
0C12: E1          pop  hl
0C13: C3 DB 0B    jp   $0BDB
0C16: CD 31 0C    call $0C31
0C19: 0C          inc  c
0C1A: E5          push hl
0C1B: CD 37 0C    call $0C37
0C1E: CD 31 0C    call $0C31
0C21: E1          pop  hl
0C22: 0C          inc  c
0C23: CD 41 0C    call $0C41
0C26: CD 31 0C    call $0C31
0C29: 0C          inc  c
0C2A: CD 37 0C    call $0C37
0C2D: CD 31 0C    call $0C31
0C30: C9          ret
0C31: ED 67       rrd  (hl)
0C33: 79          ld   a,c
0C34: ED 6F       rld  (hl)
0C36: C9          ret
0C37: 2C          inc  l
0C38: 7D          ld   a,l
0C39: E6 1F       and  $1F
0C3B: C0          ret  nz
0C3C: 7D          ld   a,l
0C3D: D6 20       sub  $20
0C3F: 6F          ld   l,a
0C40: C9          ret
0C41: D5          push de
0C42: 11 20 00    ld   de,$0020
0C45: 19          add  hl,de
0C46: D1          pop  de
0C47: 7C          ld   a,h
0C48: FE 7F       cp   $7F
0C4A: C0          ret  nz
0C4B: 26 78       ld   h,$78
0C4D: C9          ret
0C4E: 7D          ld   a,l
0C4F: 87          add  a,a
0C50: 87          add  a,a
0C51: 87          add  a,a
0C52: CB 3C       srl  h
0C54: 1F          rra
0C55: CB 3C       srl  h
0C57: 1F          rra
0C58: CB 3C       srl  h
0C5A: 1F          rra
0C5B: 6F          ld   l,a
0C5C: 7C          ld   a,h
0C5D: E6 07       and  $07
0C5F: F6 78       or   $78
0C61: 67          ld   h,a
0C62: C9          ret
0C63: 06 08       ld   b,$08
0C65: 21 40 83    ld   hl,$8340
0C68: 36 24       ld   (hl),$24
0C6A: 23          inc  hl
0C6B: 10 FB       djnz $0C68
0C6D: 06 08       ld   b,$08
0C6F: 21 60 83    ld   hl,$8360
0C72: 36 24       ld   (hl),$24
0C74: 23          inc  hl
0C75: 10 FB       djnz $0C72
0C77: 21 40 8B    ld   hl,$8B40
0C7A: 06 08       ld   b,$08
0C7C: 36 61       ld   (hl),$61
0C7E: 23          inc  hl
0C7F: 10 FB       djnz $0C7C
0C81: 21 60 8B    ld   hl,$8B60
0C84: 06 08       ld   b,$08
0C86: 36 61       ld   (hl),$61
0C88: 23          inc  hl
0C89: 10 FB       djnz $0C86
0C8B: A7          and  a
0C8C: C8          ret  z
0C8D: FE 04       cp   $04
0C8F: 38 02       jr   c,$0C93
0C91: 3E 04       ld   a,$04
0C93: 47          ld   b,a
0C94: 21 44 83    ld   hl,$8344
0C97: CD 9D 0C    call $0C9D
0C9A: 10 FB       djnz $0C97
0C9C: C9          ret
0C9D: 0E 30       ld   c,$30
0C9F: 71          ld   (hl),c
0CA0: 0C          inc  c
0CA1: 2C          inc  l
0CA2: 71          ld   (hl),c
0CA3: CB ED       set  5,l
0CA5: 0C          inc  c
0CA6: 2D          dec  l
0CA7: 71          ld   (hl),c
0CA8: 0C          inc  c
0CA9: 2C          inc  l
0CAA: 71          ld   (hl),c
0CAB: 2C          inc  l
0CAC: CB 9D       res  3,l
0CAE: CB AD       res  5,l
0CB0: C9          ret
0CB1: 3A AE 83    ld   a,($83AE)
0CB4: A7          and  a
0CB5: C0          ret  nz
0CB6: 3A E5 83    ld   a,($83E5)
0CB9: FE 63       cp   $63
0CBB: 38 02       jr   c,$0CBF
0CBD: 3E 63       ld   a,$63
0CBF: 6F          ld   l,a
0CC0: 26 00       ld   h,$00
0CC2: 0E 0A       ld   c,$0A
0CC4: CD 7A 1A    call $1A7A
0CC7: 4D          ld   c,l
0CC8: 21 A0 83    ld   hl,$83A0
0CCB: 36 0D       ld   (hl),$0D
0CCD: 2E A4       ld   l,$A4
0CCF: 36 1B       ld   (hl),$1B
0CD1: 2C          inc  l
0CD2: 36 18       ld   (hl),$18
0CD4: 2C          inc  l
0CD5: 36 1E       ld   (hl),$1E
0CD7: 2C          inc  l
0CD8: 36 17       ld   (hl),$17
0CDA: 2E A3       ld   l,$A3
0CDC: 77          ld   (hl),a
0CDD: 2D          dec  l
0CDE: 79          ld   a,c
0CDF: 36 24       ld   (hl),$24
0CE1: A7          and  a
0CE2: 28 07       jr   z,$0CEB
0CE4: FE 0A       cp   $0A
0CE6: 38 02       jr   c,$0CEA
0CE8: 3E 09       ld   a,$09
0CEA: 77          ld   (hl),a
0CEB: 2D          dec  l
0CEC: 36 24       ld   (hl),$24
0CEE: 06 08       ld   b,$08
0CF0: 21 A0 8B    ld   hl,$8BA0
0CF3: 36 61       ld   (hl),$61
0CF5: 23          inc  hl
0CF6: 10 FB       djnz $0CF3
0CF8: C9          ret
0CF9: 21 F7 80    ld   hl,$80F7
0CFC: 06 10       ld   b,$10
0CFE: 36 FF       ld   (hl),$FF
0D00: 2B          dec  hl
0D01: 10 FB       djnz $0CFE
0D03: C9          ret
0D04: E5          push hl
0D05: F5          push af
0D06: 2A E6 83    ld   hl,($83E6)
0D09: 7D          ld   a,l
0D0A: AC          xor  h
0D0B: 2F          cpl
0D0C: 87          add  a,a
0D0D: 87          add  a,a
0D0E: ED 6A       adc  hl,hl
0D10: ED 5F       ld   a,r
0D12: D7          rst  $10   ; add_a_to_hl
0D13: 22 E6 83    ld   ($83E6),hl
0D16: F1          pop  af
0D17: E1          pop  hl
0D18: C9          ret

0D49: 3A AE 83    ld   a,($83AE)
0D4C: A7          and  a
0D4D: C0          ret  nz
0D4E: 3A E3 83    ld   a,($83E3)
0D51: A7          and  a
0D52: C0          ret  nz
0D53: 0E 60       ld   c,$60
0D55: 21 E0 8B    ld   hl,$8BE0
0D58: ED 5B AE 89 ld   de,($89AE)
0D5C: 7E          ld   a,(hl)
0D5D: E6 0F       and  $0F
0D5F: FE 0A       cp   $0A
0D61: D0          ret  nc
0D62: CD E0 0E    call $0EE0
0D65: 23          inc  hl
0D66: 7E          ld   a,(hl)
0D67: CD CC 0E    call $0ECC
0D6A: CB 9B       res  3,e
0D6C: 23          inc  hl
0D6D: 7E          ld   a,(hl)
0D6E: CD CC 0E    call $0ECC
0D71: 23          inc  hl
0D72: 7E          ld   a,(hl)
0D73: 0E 62       ld   c,$62
0D75: CD CC 0E    call $0ECC
0D78: 3A E0 8B    ld   a,($8BE0)
0D7B: CB 7F       bit  7,a
0D7D: C8          ret  z
0D7E: E6 0C       and  $0C
0D80: C0          ret  nz
0D81: F6 F0       or   $F0
0D83: 3C          inc  a
0D84: C8          ret  z
0D85: 2A AE 89    ld   hl,($89AE)
0D88: 7D          ld   a,l
0D89: E6 F0       and  $F0
0D8B: 6F          ld   l,a
0D8C: 11 60 80    ld   de,$8060
0D8F: 01 08 00    ld   bc,$0008
0D92: ED B0       ldir
0D94: CB 9D       res  3,l
0D96: CB DC       set  3,h
0D98: 11 60 88    ld   de,$8860
0D9B: 0E 08       ld   c,$08
0D9D: ED B0       ldir
0D9F: C9          ret
0DA0: 21 E8 80    ld   hl,$80E8
0DA3: 11 28 82    ld   de,$8228
0DA6: 06 08       ld   b,$08
0DA8: CD AE 0D    call $0DAE
0DAB: 10 FB       djnz $0DA8
0DAD: C9          ret
0DAE: 7E          ld   a,(hl)
0DAF: 23          inc  hl
0DB0: 4E          ld   c,(hl)
0DB1: 23          inc  hl
0DB2: 3C          inc  a
0DB3: CA 69 0E    jp   z,$0E69
0DB6: E5          push hl
0DB7: 26 83       ld   h,$83
0DB9: CB B5       res  6,l
0DBB: CB AD       res  5,l
0DBD: 2D          dec  l
0DBE: 35          dec  (hl)
0DBF: CA 16 0E    jp   z,$0E16
0DC2: 34          inc  (hl)
0DC3: 3D          dec  a
0DC4: 87          add  a,a
0DC5: 87          add  a,a
0DC6: 67          ld   h,a
0DC7: 79          ld   a,c
0DC8: 87          add  a,a
0DC9: 87          add  a,a
0DCA: 6F          ld   l,a
0DCB: 0E 01       ld   c,$01
0DCD: EB          ex   de,hl
0DCE: 71          ld   (hl),c
0DCF: 23          inc  hl
0DD0: C6 03       add  a,$03
0DD2: 77          ld   (hl),a
0DD3: 23          inc  hl
0DD4: 72          ld   (hl),d
0DD5: 23          inc  hl
0DD6: 23          inc  hl
0DD7: 0C          inc  c
0DD8: 0C          inc  c
0DD9: 71          ld   (hl),c
0DDA: 23          inc  hl
0DDB: 77          ld   (hl),a
0DDC: 23          inc  hl
0DDD: 7A          ld   a,d
0DDE: C6 06       add  a,$06
0DE0: 77          ld   (hl),a
0DE1: 23          inc  hl
0DE2: 23          inc  hl
0DE3: 0C          inc  c
0DE4: 0C          inc  c
0DE5: 71          ld   (hl),c
0DE6: 23          inc  hl
0DE7: 73          ld   (hl),e
0DE8: 23          inc  hl
0DE9: 14          inc  d
0DEA: 72          ld   (hl),d
0DEB: 23          inc  hl
0DEC: 23          inc  hl
0DED: 0C          inc  c
0DEE: 0C          inc  c
0DEF: 71          ld   (hl),c
0DF0: 23          inc  hl
0DF1: 7B          ld   a,e
0DF2: C6 05       add  a,$05
0DF4: 77          ld   (hl),a
0DF5: 23          inc  hl
0DF6: 72          ld   (hl),d
0DF7: 23          inc  hl
0DF8: 23          inc  hl
0DF9: 0C          inc  c
0DFA: 0C          inc  c
0DFB: 71          ld   (hl),c
0DFC: 23          inc  hl
0DFD: 73          ld   (hl),e
0DFE: 23          inc  hl
0DFF: 7A          ld   a,d
0E00: C6 04       add  a,$04
0E02: 57          ld   d,a
0E03: 77          ld   (hl),a
0E04: 23          inc  hl
0E05: 23          inc  hl
0E06: 0C          inc  c
0E07: 0C          inc  c
0E08: 71          ld   (hl),c
0E09: 23          inc  hl
0E0A: 7B          ld   a,e
0E0B: C6 05       add  a,$05
0E0D: 77          ld   (hl),a
0E0E: 23          inc  hl
0E0F: 72          ld   (hl),d
0E10: 3E 0A       ld   a,$0A
0E12: D7          rst  $10   ; add_a_to_hl
0E13: EB          ex   de,hl
0E14: E1          pop  hl
0E15: C9          ret
0E16: 34          inc  (hl)
0E17: 3D          dec  a
0E18: 87          add  a,a
0E19: 87          add  a,a
0E1A: 67          ld   h,a
0E1B: 79          ld   a,c
0E1C: 87          add  a,a
0E1D: 87          add  a,a
0E1E: 6F          ld   l,a
0E1F: 0E 0D       ld   c,$0D
0E21: EB          ex   de,hl
0E22: 71          ld   (hl),c
0E23: 2C          inc  l
0E24: 3C          inc  a
0E25: 77          ld   (hl),a
0E26: 2C          inc  l
0E27: 72          ld   (hl),d
0E28: 2C          inc  l
0E29: 2C          inc  l
0E2A: 0C          inc  c
0E2B: 0C          inc  c
0E2C: 71          ld   (hl),c
0E2D: 2C          inc  l
0E2E: C6 04       add  a,$04
0E30: 77          ld   (hl),a
0E31: 2C          inc  l
0E32: 72          ld   (hl),d
0E33: 2C          inc  l
0E34: 2C          inc  l
0E35: 0C          inc  c
0E36: 0C          inc  c
0E37: 71          ld   (hl),c
0E38: 2C          inc  l
0E39: 77          ld   (hl),a
0E3A: 2C          inc  l
0E3B: 7A          ld   a,d
0E3C: C6 05       add  a,$05
0E3E: 77          ld   (hl),a
0E3F: 2C          inc  l
0E40: 2C          inc  l
0E41: 0C          inc  c
0E42: 0C          inc  c
0E43: 71          ld   (hl),c
0E44: 2C          inc  l
0E45: 73          ld   (hl),e
0E46: 34          inc  (hl)
0E47: 2C          inc  l
0E48: 77          ld   (hl),a
0E49: 2C          inc  l
0E4A: 2C          inc  l
0E4B: 0C          inc  c
0E4C: 0C          inc  c
0E4D: 71          ld   (hl),c
0E4E: 2C          inc  l
0E4F: 73          ld   (hl),e
0E50: 2C          inc  l
0E51: 7A          ld   a,d
0E52: C6 03       add  a,$03
0E54: 77          ld   (hl),a
0E55: 57          ld   d,a
0E56: 2C          inc  l
0E57: 2C          inc  l
0E58: 0C          inc  c
0E59: 0C          inc  c
0E5A: 71          ld   (hl),c
0E5B: 2C          inc  l
0E5C: 7B          ld   a,e
0E5D: C6 06       add  a,$06
0E5F: 77          ld   (hl),a
0E60: 2C          inc  l
0E61: 72          ld   (hl),d
0E62: 11 0A 00    ld   de,$000A
0E65: 19          add  hl,de
0E66: EB          ex   de,hl
0E67: E1          pop  hl
0E68: C9          ret
0E69: 0E 18       ld   c,$18
0E6B: 12          ld   (de),a
0E6C: 13          inc  de
0E6D: 0D          dec  c
0E6E: 20 FB       jr   nz,$0E6B
0E70: 0E 08       ld   c,$08
0E72: 13          inc  de
0E73: 0D          dec  c
0E74: 20 FC       jr   nz,$0E72
0E76: C9          ret
0E77: 0E 0E       ld   c,$0E
0E79: 21 80 81    ld   hl,$8180
0E7C: 11 18 00    ld   de,$0018
0E7F: 06 08       ld   b,$08
0E81: 36 25       ld   (hl),$25
0E83: CB DC       set  3,h
0E85: 36 63       ld   (hl),$63
0E87: CB 9C       res  3,h
0E89: 2C          inc  l
0E8A: 10 F5       djnz $0E81
0E8C: 19          add  hl,de
0E8D: 0D          dec  c
0E8E: 20 EF       jr   nz,$0E7F
0E90: C9          ret
0E91: 06 08       ld   b,$08
0E93: 11 E8 80    ld   de,$80E8
0E96: 0E 23       ld   c,$23
0E98: 1A          ld   a,(de)
0E99: 13          inc  de
0E9A: 0F          rrca
0E9B: 0F          rrca
0E9C: 30 02       jr   nc,$0EA0
0E9E: CB F9       set  7,c
0EA0: 67          ld   h,a
0EA1: 1A          ld   a,(de)
0EA2: 13          inc  de
0EA3: 3C          inc  a
0EA4: 28 23       jr   z,$0EC9
0EA6: 3D          dec  a
0EA7: 0F          rrca
0EA8: 0F          rrca
0EA9: 30 02       jr   nc,$0EAD
0EAB: CB F1       set  6,c
0EAD: C6 04       add  a,$04
0EAF: E6 07       and  $07
0EB1: 6F          ld   l,a
0EB2: 7C          ld   a,h
0EB3: 87          add  a,a
0EB4: 87          add  a,a
0EB5: 87          add  a,a
0EB6: 87          add  a,a
0EB7: 87          add  a,a
0EB8: 26 81       ld   h,$81
0EBA: 30 01       jr   nc,$0EBD
0EBC: 24          inc  h
0EBD: 85          add  a,l
0EBE: C6 80       add  a,$80
0EC0: 30 01       jr   nc,$0EC3
0EC2: 24          inc  h
0EC3: 6F          ld   l,a
0EC4: 36 27       ld   (hl),$27
0EC6: CB DC       set  3,h
0EC8: 71          ld   (hl),c
0EC9: 10 CB       djnz $0E96
0ECB: C9          ret
0ECC: F5          push af
0ECD: 0F          rrca
0ECE: 0F          rrca
0ECF: 0F          rrca
0ED0: 0F          rrca
0ED1: E6 0F       and  $0F
0ED3: 28 02       jr   z,$0ED7
0ED5: 0E 62       ld   c,$62
0ED7: 12          ld   (de),a
0ED8: CB DA       set  3,d
0EDA: 79          ld   a,c
0EDB: 12          ld   (de),a
0EDC: CB 9A       res  3,d
0EDE: 13          inc  de
0EDF: F1          pop  af
0EE0: E6 0F       and  $0F
0EE2: 28 02       jr   z,$0EE6
0EE4: 0E 62       ld   c,$62
0EE6: 12          ld   (de),a
0EE7: CB DA       set  3,d
0EE9: 79          ld   a,c
0EEA: 12          ld   (de),a
0EEB: CB 9A       res  3,d
0EED: 13          inc  de
0EEE: C9          ret
0EEF: 3A D0 80    ld   a,($80D0)
0EF2: A7          and  a
0EF3: C0          ret  nz
0EF4: 21 08 81    ld   hl,$8108
0EF7: 06 06       ld   b,$06
0EF9: 7E          ld   a,(hl)
0EFA: A7          and  a
0EFB: 28 47       jr   z,$0F44
0EFD: FE FE       cp   $FE
0EFF: 28 43       jr   z,$0F44
0F01: D6 05       sub  $05
0F03: FE 05       cp   $05
0F05: 38 3D       jr   c,$0F44
0F07: 7D          ld   a,l
0F08: C6 13       add  a,$13
0F0A: 6F          ld   l,a
0F0B: 7E          ld   a,(hl)
0F0C: A7          and  a
0F0D: 28 3C       jr   z,$0F4B
0F0F: 7D          ld   a,l
0F10: D6 07       sub  $07
0F12: 6F          ld   l,a
0F13: 7E          ld   a,(hl)
0F14: 2D          dec  l
0F15: D6 6A       sub  $6A
0F17: FE 15       cp   $15
0F19: 30 08       jr   nc,$0F23
0F1B: 7E          ld   a,(hl)
0F1C: D6 60       sub  $60
0F1E: FE 15       cp   $15
0F20: DA 90 0F    jp   c,$0F90
0F23: 7D          ld   a,l
0F24: C6 15       add  a,$15
0F26: 6F          ld   l,a
0F27: 10 D0       djnz $0EF9
0F29: 21 6A 74    ld   hl,$746A
0F2C: CD 5A 27    call flags_changing_275a
0F2F: C8          ret  z
0F30: 7C          ld   a,h
0F31: C6 0E       add  a,$0E
0F33: 57          ld   d,a
0F34: 7B          ld   a,e
0F35: 5D          ld   e,l
0F36: 1C          inc  e
0F37: 2A 53 80    ld   hl,($8053)
0F3A: FE C0       cp   $C0
0F3C: 30 14       jr   nc,$0F52
0F3E: CD 3E 15    call $153E
0F41: C3 A3 0F    jp   $0FA3
0F44: 7D          ld   a,l
0F45: C6 20       add  a,$20
0F47: 6F          ld   l,a
0F48: C3 27 0F    jp   $0F27
0F4B: 7D          ld   a,l
0F4C: C6 0D       add  a,$0D
0F4E: 6F          ld   l,a
0F4F: C3 27 0F    jp   $0F27
0F52: CD F1 14    call $14F1
0F55: EB          ex   de,hl
0F56: 06 08       ld   b,$08
0F58: 7A          ld   a,d
0F59: FE F0       cp   $F0
0F5B: 38 02       jr   c,$0F5F
0F5D: C6 E0       add  a,$E0
0F5F: FE E0       cp   $E0
0F61: 38 02       jr   c,$0F65
0F63: D6 E0       sub  $E0
0F65: 57          ld   d,a
0F66: CB BB       res  7,e
0F68: 21 28 82    ld   hl,$8228
0F6B: 0E 06       ld   c,$06
0F6D: 23          inc  hl
0F6E: 7B          ld   a,e
0F6F: 96          sub  (hl)
0F70: FE 03       cp   $03
0F72: 23          inc  hl
0F73: 7E          ld   a,(hl)
0F74: 23          inc  hl
0F75: 23          inc  hl
0F76: 30 07       jr   nc,$0F7F
0F78: 92          sub  d
0F79: ED 44       neg
0F7B: FE 03       cp   $03
0F7D: 38 0B       jr   c,$0F8A
0F7F: 0D          dec  c
0F80: 20 EB       jr   nz,$0F6D
0F82: 3E 08       ld   a,$08
0F84: D7          rst  $10   ; add_a_to_hl
0F85: 10 E4       djnz $0F6B
0F87: C3 A3 0F    jp   $0FA3
0F8A: CD 73 14    call $1473
0F8D: C3 A3 0F    jp   $0FA3
0F90: 7D          ld   a,l
0F91: D6 0B       sub  $0B
0F93: DD 6F       ld   ixl,a
0F95: 7C          ld   a,h
0F96: DD 67       ld   ixh,a
0F98: CD 05 23    call $2305
0F9B: DD 36 00 FE ld   (ix+$00),$FE
0F9F: DD 36 14 00 ld   (ix+$14),$00
0FA3: 21 01 10    ld   hl,$1001
0FA6: DD 21 08 81 ld   ix,$8108
0FAA: 11 20 00    ld   de,$0020
0FAD: 01 05 06    ld   bc,$0605
0FB0: DD 7E 00    ld   a,(ix+$00)
0FB3: DD 36 00 09 ld   (ix+$00),$09
0FB7: 3C          inc  a
0FB8: 3C          inc  a
0FB9: 28 1A       jr   z,$0FD5
0FBB: DD 71 00    ld   (ix+$00),c
0FBE: 0C          inc  c
0FBF: 7E          ld   a,(hl)
0FC0: DD 77 0B    ld   (ix+$0b),a
0FC3: 23          inc  hl
0FC4: 7E          ld   a,(hl)
0FC5: DD 77 0C    ld   (ix+$0c),a
0FC8: 23          inc  hl
0FC9: DD 36 0E 09 ld   (ix+$0e),$09
0FCD: DD 36 13 01 ld   (ix+$13),$01
0FD1: DD 36 14 00 ld   (ix+$14),$00
0FD5: DD 19       add  ix,de
0FD7: 79          ld   a,c
0FD8: FE 09       cp   $09
0FDA: 28 12       jr   z,$0FEE
0FDC: 10 D2       djnz $0FB0
0FDE: AF          xor  a
0FDF: 32 D5 8B    ld   ($8BD5),a
0FE2: 3C          inc  a
0FE3: 32 E3 83    ld   ($83E3),a
0FE6: 3E 03       ld   a,$03
0FE8: 21 D7 80    ld   hl,$80D7
0FEB: B6          or   (hl)
0FEC: 77          ld   (hl),a
0FED: C9          ret
0FEE: 05          dec  b
0FEF: 28 ED       jr   z,$0FDE
0FF1: DD 7E 00    ld   a,(ix+$00)
0FF4: 3C          inc  a
0FF5: 3C          inc  a
0FF6: 20 04       jr   nz,$0FFC
0FF8: DD 36 00 09 ld   (ix+$00),$09
0FFC: DD 19       add  ix,de
0FFE: C3 EE 0F    jp   $0FEE
1001: 62          ld   h,d
1002: 7C          ld   a,h
1003: 72          ld   (hl),d
1004: 7C          ld   a,h
1005: 62          ld   h,d
1006: 6D          ld   l,l
1007: 72          ld   (hl),d
1008: 6D          ld   l,l
1009: 7D          ld   a,l
100A: 87          add  a,a
100B: 87          add  a,a
100C: 87          add  a,a
100D: CB 1C       rr   h
100F: 1F          rra
1010: CB 1C       rr   h
1012: 1F          rra
1013: CB 1C       rr   h
1015: 1F          rra
1016: 6F          ld   l,a
1017: 7C          ld   a,h
1018: E6 03       and  $03
101A: F6 84       or   $84
101C: 67          ld   h,a
101D: C9          ret
101E: 7C          ld   a,h
101F: E6 03       and  $03
1021: 5F          ld   e,a
1022: 7D          ld   a,l
1023: E6 03       and  $03
1025: 57          ld   d,a
1026: 7C          ld   a,h
1027: 1F          rra
1028: 1F          rra
1029: CB 15       rl   l
102B: 1F          rra
102C: CB 1D       rr   l
102E: 1F          rra
102F: CB 1D       rr   l
1031: 1F          rra
1032: CB 1D       rr   l
1034: E6 07       and  $07
1036: F6 78       or   $78
1038: 67          ld   h,a
1039: C9          ret
103A: 3A D0 80    ld   a,($80D0)
103D: A7          and  a
103E: 28 05       jr   z,$1045
1040: 3D          dec  a
1041: 32 D0 80    ld   ($80D0),a
1044: C9          ret
1045: 3A AE 83    ld   a,($83AE)
1048: A7          and  a
1049: C4 FE 34    call nz,$34FE
104C: 2A B2 89    ld   hl,($89B2)
104F: 7E          ld   a,(hl)
1050: CB 67       bit  4,a
1052: CC B1 10    call z,$10B1
1055: 2A B2 89    ld   hl,($89B2)
1058: 7E          ld   a,(hl)
1059: CB 5F       bit  3,a
105B: 20 1B       jr   nz,$1078
105D: CD 8D 10    call $108D
1060: 21 63 18    ld   hl,$1863
1063: 3A 8C 80    ld   a,($808C)
1066: D7          rst  $10   ; add_a_to_hl
1067: 3A CC 80    ld   a,($80CC)
106A: E6 04       and  $04
106C: B6          or   (hl)
106D: 32 CC 80    ld   ($80CC),a
1070: 3A 8C 80    ld   a,($808C)
1073: 21 90 17    ld   hl,jump_table_1790
1076: E7          rst  $20			; [nb_entries=9]
1077: C9          ret
1078: 21 88 80    ld   hl,$8088
107B: 34          inc  (hl)
107C: 7E          ld   a,(hl)
107D: E6 0F       and  $0F
107F: 20 DF       jr   nz,$1060
1081: 21 8A 80    ld   hl,$808A
1084: 7E          ld   a,(hl)
1085: FE 0C       cp   $0C
1087: 30 D7       jr   nc,$1060
1089: 34          inc  (hl)
108A: C3 60 10    jp   $1060
108D: E6 07       and  $07
108F: 21 94 80    ld   hl,$8094
1092: BE          cp   (hl)
1093: 77          ld   (hl),a
1094: C0          ret  nz
1095: 32 8C 80    ld   ($808C),a
1098: 6F          ld   l,a
1099: 85          add  a,l
109A: 85          add  a,l
109B: 32 8B 80    ld   ($808B),a
109E: 21 89 80    ld   hl,$8089
10A1: 34          inc  (hl)
10A2: 7E          ld   a,(hl)
10A3: E6 03       and  $03
10A5: C0          ret  nz
10A6: 21 8A 80    ld   hl,$808A
10A9: 3A 9A 80    ld   a,($809A)
10AC: 34          inc  (hl)
10AD: BE          cp   (hl)
10AE: D0          ret  nc
10AF: 77          ld   (hl),a
10B0: C9          ret
10B1: 21 A8 80    ld   hl,$80A8
10B4: 7E          ld   a,(hl)
10B5: 2C          inc  l
10B6: B6          or   (hl)
10B7: 28 12       jr   z,$10CB
10B9: 2C          inc  l
10BA: 7E          ld   a,(hl)
10BB: 2C          inc  l
10BC: B6          or   (hl)
10BD: C0          ret  nz
10BE: 36 01       ld   (hl),$01
10C0: 2D          dec  l
10C1: 36 01       ld   (hl),$01
10C3: 11 B4 80    ld   de,$80B4
10C6: 0E 00       ld   c,$00
10C8: C3 D5 10    jp   $10D5
10CB: 0E 01       ld   c,$01
10CD: 36 01       ld   (hl),$01
10CF: 2D          dec  l
10D0: 36 01       ld   (hl),$01
10D2: 11 AC 80    ld   de,$80AC
10D5: 21 00 11    ld   hl,$1100
10D8: 3A 8C 80    ld   a,($808C)
10DB: E6 03       and  $03
10DD: 47          ld   b,a
10DE: 87          add  a,a
10DF: 87          add  a,a
10E0: 80          add  a,b
10E1: CF          rst  $08
10E2: 79          ld   a,c
10E3: 01 08 00    ld   bc,$0008
10E6: ED B0       ldir
10E8: 11 BC 80    ld   de,$80BC
10EB: A7          and  a
10EC: 20 02       jr   nz,$10F0
10EE: 1C          inc  e
10EF: 1C          inc  e
10F0: ED A0       ldi
10F2: ED A0       ldi
10F4: 21 D7 80    ld   hl,$80D7
10F7: CB D6       set  2,(hl)
10F9: 21 9B 80    ld   hl,$809B
10FC: 34          inc  (hl)
10FD: C0          ret  nz
10FE: 35          dec  (hl)
10FF: C9          ret

1128: 21 AC 80    ld   hl,$80AC
112B: 11 A8 80    ld   de,$80A8
112E: 1A          ld   a,(de)
112F: A7          and  a
1130: 28 33       jr   z,$1165
1132: 7E          ld   a,(hl)
1133: 2C          inc  l
1134: 86          add  a,(hl)
1135: 77          ld   (hl),a
1136: FE DD       cp   $DD
1138: 4F          ld   c,a
1139: 30 2A       jr   nc,$1165
113B: 2C          inc  l
113C: 7E          ld   a,(hl)
113D: 2C          inc  l
113E: 86          add  a,(hl)
113F: 77          ld   (hl),a
1140: D6 08       sub  $08
1142: FE ED       cp   $ED
1144: 30 1F       jr   nc,$1165
1146: 47          ld   b,a
1147: 3A BC 80    ld   a,($80BC)
114A: 11 FC 83    ld   de,$83FC
114D: CD 27 12    call $1227
1150: CD AD 13    call $13AD
1153: 11 A8 80    ld   de,$80A8
1156: 12          ld   (de),a
1157: 87          add  a,a
1158: 30 10       jr   nc,$116A
115A: 3A AE 80    ld   a,($80AE)
115D: ED 44       neg
115F: 32 AE 80    ld   ($80AE),a
1162: C3 6A 11    jp   $116A
1165: AF          xor  a
1166: 12          ld   (de),a
1167: 32 FC 8B    ld   ($8BFC),a
116A: 21 B0 80    ld   hl,$80B0
116D: 13          inc  de
116E: 1A          ld   a,(de)
116F: A7          and  a
1170: 28 33       jr   z,$11A5
1172: 7E          ld   a,(hl)
1173: 2C          inc  l
1174: 86          add  a,(hl)
1175: 77          ld   (hl),a
1176: FE DD       cp   $DD
1178: 4F          ld   c,a
1179: 30 2A       jr   nc,$11A5
117B: 2C          inc  l
117C: 7E          ld   a,(hl)
117D: 2C          inc  l
117E: 86          add  a,(hl)
117F: 77          ld   (hl),a
1180: D6 08       sub  $08
1182: FE ED       cp   $ED
1184: 30 1F       jr   nc,$11A5
1186: 47          ld   b,a
1187: 11 FD 83    ld   de,$83FD
118A: 3A BD 80    ld   a,($80BD)
118D: CD 27 12    call $1227
1190: CD AD 13    call $13AD
1193: 11 A9 80    ld   de,$80A9
1196: 12          ld   (de),a
1197: 87          add  a,a
1198: 30 10       jr   nc,$11AA
119A: 3A B2 80    ld   a,($80B2)
119D: ED 44       neg
119F: 32 B2 80    ld   ($80B2),a
11A2: C3 AA 11    jp   $11AA
11A5: AF          xor  a
11A6: 12          ld   (de),a
11A7: 32 FD 8B    ld   ($8BFD),a
11AA: 21 B4 80    ld   hl,$80B4
11AD: 1C          inc  e
11AE: 1A          ld   a,(de)
11AF: A7          and  a
11B0: 28 33       jr   z,$11E5
11B2: 7E          ld   a,(hl)
11B3: 2C          inc  l
11B4: 86          add  a,(hl)
11B5: 77          ld   (hl),a
11B6: FE DD       cp   $DD
11B8: 4F          ld   c,a
11B9: 30 2A       jr   nc,$11E5
11BB: 2C          inc  l
11BC: 7E          ld   a,(hl)
11BD: 2C          inc  l
11BE: 86          add  a,(hl)
11BF: 77          ld   (hl),a
11C0: D6 08       sub  $08
11C2: FE ED       cp   $ED
11C4: 30 1F       jr   nc,$11E5
11C6: 47          ld   b,a
11C7: 3A BE 80    ld   a,($80BE)
11CA: 11 FE 83    ld   de,$83FE
11CD: CD 27 12    call $1227
11D0: CD AD 13    call $13AD
11D3: 11 AA 80    ld   de,$80AA
11D6: 12          ld   (de),a
11D7: 87          add  a,a
11D8: 30 10       jr   nc,$11EA
11DA: 3A B6 80    ld   a,($80B6)
11DD: ED 44       neg
11DF: 32 B6 80    ld   ($80B6),a
11E2: C3 EA 11    jp   $11EA
11E5: AF          xor  a
11E6: 12          ld   (de),a
11E7: 32 FE 8B    ld   ($8BFE),a
11EA: 21 B8 80    ld   hl,$80B8
11ED: 1C          inc  e
11EE: 1A          ld   a,(de)
11EF: A7          and  a
11F0: 28 2F       jr   z,$1221
11F2: 7E          ld   a,(hl)
11F3: 2C          inc  l
11F4: 86          add  a,(hl)
11F5: 77          ld   (hl),a
11F6: FE DD       cp   $DD
11F8: 4F          ld   c,a
11F9: 30 26       jr   nc,$1221
11FB: 2C          inc  l
11FC: 7E          ld   a,(hl)
11FD: 2C          inc  l
11FE: 86          add  a,(hl)
11FF: 77          ld   (hl),a
1200: D6 08       sub  $08
1202: FE ED       cp   $ED
1204: 30 1B       jr   nc,$1221
1206: 47          ld   b,a
1207: 3A BF 80    ld   a,($80BF)
120A: 11 FF 83    ld   de,$83FF
120D: CD 27 12    call $1227
1210: CD AD 13    call $13AD
1213: 32 AB 80    ld   ($80AB),a
1216: 87          add  a,a
1217: D0          ret  nc
1218: 3A BA 80    ld   a,($80BA)
121B: ED 44       neg
121D: 32 BA 80    ld   ($80BA),a
1220: C9          ret
1221: AF          xor  a
1222: 12          ld   (de),a
1223: 32 FF 8B    ld   ($8BFF),a
1226: C9          ret
1227: F5          push af
1228: 3A 18 82    ld   a,($8218)
122B: A7          and  a
122C: 20 12       jr   nz,$1240
122E: 79          ld   a,c
122F: 12          ld   (de),a
1230: 16 8B       ld   d,$8B
1232: 78          ld   a,b
1233: C6 08       add  a,$08
1235: 12          ld   (de),a
1236: 16 98       ld   d,$98
1238: 7B          ld   a,e
1239: E6 0F       and  $0F
123B: 5F          ld   e,a
123C: F1          pop  af
123D: 12          ld   (de),a
123E: 78          ld   a,b
123F: C9          ret
1240: 3E 20       ld   a,$20
1242: 91          sub  c
1243: 12          ld   (de),a
1244: 38 04       jr   c,$124A
1246: F1          pop  af
1247: E6 FE       and  $FE
1249: F5          push af
124A: 3E F4       ld   a,$F4
124C: 90          sub  b
124D: 16 8B       ld   d,$8B
124F: 12          ld   (de),a
1250: 16 98       ld   d,$98
1252: 7B          ld   a,e
1253: E6 0F       and  $0F
1255: 5F          ld   e,a
1256: F1          pop  af
1257: 12          ld   (de),a
1258: 78          ld   a,b
1259: C9          ret

125A: 11 FB 83    ld   de,$83FB
125D: 01 0B 98    ld   bc,$980B
1260: 21 2C 83    ld   hl,$832C
1263: CD 75 12    call $1275
1266: 21 35 83    ld   hl,$8335
1269: CD 75 12    call $1275
126C: 21 4C 83    ld   hl,$834C
126F: CD 75 12    call $1275
1272: 21 55 83    ld   hl,$8355
1275: 7E          ld   a,(hl)
1276: A7          and  a
1277: 20 08       jr   nz,$1281
1279: 16 8B       ld   d,$8B
127B: 12          ld   (de),a
127C: 16 83       ld   d,$83
127E: 0D          dec  c
127F: 1D          dec  e
1280: C9          ret
1281: 3E 06       ld   a,$06
1283: 85          add  a,l
1284: 6F          ld   l,a
1285: 3A 18 82    ld   a,($8218)
1288: A7          and  a
1289: 20 10       jr   nz,$129B
128B: 7E          ld   a,(hl)
128C: 12          ld   (de),a
128D: CD B3 12    call $12B3
1290: 3C          inc  a
1291: 02          ld   (bc),a
1292: 16 8B       ld   d,$8B
1294: 2C          inc  l
1295: 2C          inc  l
1296: ED A8       ldd
1298: 16 83       ld   d,$83
129A: C9          ret
129B: 3E 21       ld   a,$21
129D: 96          sub  (hl)
129E: 12          ld   (de),a
129F: CD B3 12    call $12B3
12A2: 30 01       jr   nc,$12A5
12A4: 3C          inc  a
12A5: 02          ld   (bc),a
12A6: 16 8B       ld   d,$8B
12A8: 2C          inc  l
12A9: 2C          inc  l
12AA: 3E FC       ld   a,$FC
12AC: 96          sub  (hl)
12AD: 12          ld   (de),a
12AE: 16 83       ld   d,$83
12B0: 0D          dec  c
12B1: 1D          dec  e
12B2: C9          ret
12B3: 08          ex   af,af'
12B4: 3A 7C 80    ld   a,($807C)
12B7: 0F          rrca
12B8: 0F          rrca
12B9: E6 03       and  $03
12BB: 1F          rra
12BC: 30 02       jr   nc,$12C0
12BE: F6 02       or   $02
12C0: 87          add  a,a
12C1: F6 08       or   $08
12C3: 32 D6 80    ld   ($80D6),a
12C6: 08          ex   af,af'
12C7: 3A D6 80    ld   a,($80D6)
12CA: C9          ret
12CB: 21 2C 83    ld   hl,$832C
12CE: CD E0 12    call $12E0
12D1: 21 35 83    ld   hl,$8335
12D4: CD E0 12    call $12E0
12D7: 21 4C 83    ld   hl,$834C
12DA: CD E0 12    call $12E0
12DD: 21 55 83    ld   hl,$8355
12E0: 7E          ld   a,(hl)
12E1: A7          and  a
12E2: C8          ret  z
12E3: E5          push hl
12E4: 2C          inc  l
12E5: 5E          ld   e,(hl)
12E6: 2C          inc  l
12E7: 56          ld   d,(hl)
12E8: 2C          inc  l
12E9: 4E          ld   c,(hl)
12EA: 2C          inc  l
12EB: 46          ld   b,(hl)
12EC: C5          push bc
12ED: 2C          inc  l
12EE: 4E          ld   c,(hl)
12EF: 2C          inc  l
12F0: 46          ld   b,(hl)
12F1: EB          ex   de,hl
12F2: 09          add  hl,bc
12F3: EB          ex   de,hl
12F4: 72          ld   (hl),d
12F5: 2D          dec  l
12F6: 73          ld   (hl),e
12F7: 2C          inc  l
12F8: 2C          inc  l
12F9: C1          pop  bc
12FA: 7A          ld   a,d
12FB: FE DD       cp   $DD
12FD: 30 18       jr   nc,$1317
12FF: 5E          ld   e,(hl)
1300: 2C          inc  l
1301: 56          ld   d,(hl)
1302: EB          ex   de,hl
1303: 09          add  hl,bc
1304: EB          ex   de,hl
1305: 72          ld   (hl),d
1306: 2D          dec  l
1307: 73          ld   (hl),e
1308: 2D          dec  l
1309: 4E          ld   c,(hl)
130A: 7A          ld   a,d
130B: D6 08       sub  $08
130D: FE ED       cp   $ED
130F: 30 06       jr   nc,$1317
1311: CD 1B 13    call $131B
1314: E1          pop  hl
1315: 77          ld   (hl),a
1316: C9          ret
1317: AF          xor  a
1318: E1          pop  hl
1319: 77          ld   (hl),a
131A: C9          ret
131B: FE 76       cp   $76
131D: 30 18       jr   nc,$1337
131F: FE 6C       cp   $6C
1321: 38 14       jr   c,$1337
1323: 47          ld   b,a
1324: 79          ld   a,c
1325: FE 76       cp   $76
1327: 30 0D       jr   nc,$1336
1329: FE 6C       cp   $6C
132B: 38 09       jr   c,$1336
132D: 3A E3 83    ld   a,($83E3)
1330: A7          and  a
1331: CC A3 0F    call z,$0FA3
1334: AF          xor  a
1335: C9          ret
1336: 78          ld   a,b
1337: CD 53 13    call $1353
133A: 62          ld   h,d
133B: 6B          ld   l,e
133C: CD CD 14    call $14CD
133F: 7E          ld   a,(hl)
1340: CB 7F       bit  7,a
1342: 20 03       jr   nz,$1347
1344: 3E 01       ld   a,$01
1346: C9          ret
1347: FE C0       cp   $C0
1349: 38 03       jr   c,$134E
134B: 3E 01       ld   a,$01
134D: C9          ret
134E: CD 3E 15    call $153E
1351: AF          xor  a
1352: C9          ret
1353: 59          ld   e,c
1354: C6 08       add  a,$08
1356: 57          ld   d,a
1357: 06 06       ld   b,$06
1359: 21 08 81    ld   hl,$8108
135C: 7E          ld   a,(hl)
135D: A7          and  a
135E: 28 3A       jr   z,$139A
1360: D6 05       sub  $05
1362: FE 05       cp   $05
1364: 38 34       jr   c,$139A
1366: 7D          ld   a,l
1367: C6 13       add  a,$13
1369: 6F          ld   l,a
136A: 7E          ld   a,(hl)
136B: A7          and  a
136C: 28 32       jr   z,$13A0
136E: 7D          ld   a,l
136F: D6 08       sub  $08
1371: 6F          ld   l,a
1372: 7B          ld   a,e
1373: 96          sub  (hl)
1374: 3C          inc  a
1375: 2C          inc  l
1376: FE 0E       cp   $0E
1378: 30 2C       jr   nc,$13A6
137A: 7A          ld   a,d
137B: 96          sub  (hl)
137C: FE 0E       cp   $0E
137E: 30 26       jr   nc,$13A6
1380: 7D          ld   a,l
1381: D6 0C       sub  $0C
1383: DD 6F       ld   ixl,a
1385: 7C          ld   a,h
1386: DD 67       ld   ixh,a
1388: DD 7E 00    ld   a,(ix+$00)
138B: FE 0A       cp   $0A
138D: CC 6F 22    call z,$226F
1390: CD 05 23    call $2305
1393: DD 36 00 09 ld   (ix+$00),$09
1397: F1          pop  af
1398: AF          xor  a
1399: C9          ret
139A: 7D          ld   a,l
139B: C6 20       add  a,$20
139D: 6F          ld   l,a
139E: 18 0A       jr   $13AA
13A0: 7D          ld   a,l
13A1: C6 0D       add  a,$0D
13A3: 6F          ld   l,a
13A4: 18 04       jr   $13AA
13A6: 7D          ld   a,l
13A7: C6 14       add  a,$14
13A9: 6F          ld   l,a
13AA: 10 B0       djnz $135C
13AC: C9          ret
13AD: 59          ld   e,c
13AE: C6 0A       add  a,$0A
13B0: 57          ld   d,a
13B1: 1C          inc  e
13B2: 1C          inc  e
13B3: 62          ld   h,d
13B4: 6B          ld   l,e
13B5: CD CD 14    call $14CD
13B8: 7E          ld   a,(hl)
13B9: FE B0       cp   $B0
13BB: 30 0A       jr   nc,$13C7
13BD: 1D          dec  e
13BE: 1D          dec  e
13BF: 15          dec  d
13C0: 15          dec  d
13C1: CD 57 13    call $1357
13C4: 3E 01       ld   a,$01
13C6: C9          ret
13C7: FE C0       cp   $C0
13C9: 38 04       jr   c,$13CF
13CB: FE C6       cp   $C6
13CD: 38 0D       jr   c,$13DC
13CF: FE D0       cp   $D0
13D1: 38 04       jr   c,$13D7
13D3: FE D4       cp   $D4
13D5: 38 05       jr   c,$13DC
13D7: CD 3E 15    call $153E
13DA: AF          xor  a
13DB: C9          ret
13DC: C5          push bc
13DD: CD F1 14    call $14F1
13E0: C1          pop  bc
13E1: CD 10 14    call $1410
13E4: 3E 01       ld   a,$01
13E6: 32 0F 8A    ld   ($8A0F),a
13E9: 0E 01       ld   c,$01
13EB: 21 00 88    ld   hl,$8800
13EE: 06 10       ld   b,$10
13F0: AF          xor  a
13F1: BE          cp   (hl)
13F2: 28 07       jr   z,$13FB
13F4: 23          inc  hl
13F5: 23          inc  hl
13F6: 23          inc  hl
13F7: 23          inc  hl
13F8: 10 F7       djnz $13F1
13FA: C9          ret
13FB: 23          inc  hl
13FC: 77          ld   (hl),a
13FD: 23          inc  hl
13FE: 73          ld   (hl),e
13FF: 23          inc  hl
1400: 72          ld   (hl),d
1401: 2B          dec  hl
1402: 2B          dec  hl
1403: 2B          dec  hl
1404: 71          ld   (hl),c
1405: 11 0F 14    ld   de,$140F
1408: 06 01       ld   b,$01
140A: CD 5C 16    call $165C
140D: AF          xor  a
140E: C9          ret
140F: 8D          adc  a,l
1410: EB          ex   de,hl
1411: CB BB       res  7,e
1413: 7A          ld   a,d
1414: FE F0       cp   $F0
1416: 38 02       jr   c,$141A
1418: C6 E0       add  a,$E0
141A: FE E0       cp   $E0
141C: 38 02       jr   c,$1420
141E: D6 E0       sub  $E0
1420: 57          ld   d,a
1421: 21 28 82    ld   hl,$8228
1424: 06 08       ld   b,$08
1426: AF          xor  a
1427: 32 EA 83    ld   ($83EA),a
142A: 0E 06       ld   c,$06
142C: CB 46       bit  0,(hl)
142E: C4 B9 14    call nz,$14B9
1431: 23          inc  hl
1432: 7B          ld   a,e
1433: 96          sub  (hl)
1434: FE 03       cp   $03
1436: 23          inc  hl
1437: 7E          ld   a,(hl)
1438: 23          inc  hl
1439: 23          inc  hl
143A: 30 07       jr   nc,$1443
143C: 92          sub  d
143D: ED 44       neg
143F: FE 03       cp   $03
1441: 38 09       jr   c,$144C
1443: 0D          dec  c
1444: 20 E6       jr   nz,$142C
1446: 3E 08       ld   a,$08
1448: D7          rst  $10   ; add_a_to_hl
1449: 10 DB       djnz $1426
144B: C9          ret
144C: 2B          dec  hl
144D: 2B          dec  hl
144E: 56          ld   d,(hl)
144F: 2B          dec  hl
1450: 5E          ld   e,(hl)
1451: 2B          dec  hl
1452: 7E          ld   a,(hl)
1453: 32 98 80    ld   ($8098),a
1456: CB 46       bit  0,(hl)
1458: 28 08       jr   z,$1462
145A: 34          inc  (hl)
145B: 3A EA 83    ld   a,($83EA)
145E: 3D          dec  a
145F: 32 EA 83    ld   ($83EA),a
1462: CB 46       bit  0,(hl)
1464: C4 B9 14    call nz,$14B9
1467: 23          inc  hl
1468: 23          inc  hl
1469: 23          inc  hl
146A: 23          inc  hl
146B: 0D          dec  c
146C: 20 F4       jr   nz,$1462
146E: 3A EA 83    ld   a,($83EA)
1471: A7          and  a
1472: C0          ret  nz
1473: D5          push de
1474: 3E 08       ld   a,$08
1476: 90          sub  b
1477: 21 E8 80    ld   hl,$80E8
147A: CF          rst  $08
147B: 5E          ld   e,(hl)
147C: 23          inc  hl
147D: 7E          ld   a,(hl)
147E: 3C          inc  a
147F: 28 36       jr   z,$14B7
1481: 3D          dec  a
1482: 87          add  a,a
1483: 87          add  a,a
1484: 6F          ld   l,a
1485: 7B          ld   a,e
1486: 87          add  a,a
1487: 87          add  a,a
1488: 67          ld   h,a
1489: CD A9 15    call $15A9
148C: E5          push hl
148D: 0E 03       ld   c,$03
148F: CD 90 16    call $1690
1492: E1          pop  hl
1493: 0E 04       ld   c,$04
1495: 7D          ld   a,l
1496: 81          add  a,c
1497: 6F          ld   l,a
1498: E5          push hl
1499: CD 90 16    call $1690
149C: E1          pop  hl
149D: 7C          ld   a,h
149E: C6 04       add  a,$04
14A0: FE E0       cp   $E0
14A2: 38 02       jr   c,$14A6
14A4: D6 E0       sub  $E0
14A6: 67          ld   h,a
14A7: E5          push hl
14A8: 0E 06       ld   c,$06
14AA: CD 90 16    call $1690
14AD: E1          pop  hl
14AE: 7D          ld   a,l
14AF: D6 04       sub  $04
14B1: 6F          ld   l,a
14B2: 0E 05       ld   c,$05
14B4: CD 90 16    call $1690
14B7: D1          pop  de
14B8: C9          ret
14B9: 3A EA 83    ld   a,($83EA)
14BC: 3C          inc  a
14BD: 32 EA 83    ld   ($83EA),a
14C0: C9          ret

14CD: C5          push bc
14CE: F5          push af
14CF: 01 6D 80    ld   bc,$806D
14D2: 0A          ld   a,(bc)
14D3: 85          add  a,l
14D4: D6 04       sub  $04
14D6: CB 3F       srl  a
14D8: CB 3F       srl  a
14DA: CB 3F       srl  a
14DC: 6F          ld   l,a
14DD: 0C          inc  c
14DE: 0C          inc  c
14DF: 0A          ld   a,(bc)
14E0: 3D          dec  a
14E1: 94          sub  h
14E2: 26 21       ld   h,$21
14E4: 17          rla
14E5: CB 14       rl   h
14E7: 17          rla
14E8: CB 14       rl   h
14EA: E6 E0       and  $E0
14EC: B5          or   l
14ED: 6F          ld   l,a
14EE: F1          pop  af
14EF: C1          pop  bc
14F0: C9          ret
14F1: D5          push de
14F2: 3A 49 80    ld   a,($8049)
14F5: A7          and  a
14F6: 20 FA       jr   nz,$14F2
14F8: ED 5B 72 80 ld   de,($8072)
14FC: ED 4B 74 80 ld   bc,($8074)
1500: 3A 49 80    ld   a,($8049)
1503: A7          and  a
1504: 20 EC       jr   nz,$14F2
1506: 7D          ld   a,l
1507: 91          sub  c
1508: E6 1F       and  $1F
150A: 83          add  a,e
150B: 5F          ld   e,a
150C: 7C          ld   a,h
150D: CB 05       rlc  l
150F: 8F          adc  a,a
1510: CB 05       rlc  l
1512: 8F          adc  a,a
1513: CB 05       rlc  l
1515: 8F          adc  a,a
1516: 90          sub  b
1517: E6 1F       and  $1F
1519: 82          add  a,d
151A: FE E0       cp   $E0
151C: 38 02       jr   c,$1520
151E: D6 E0       sub  $E0
1520: 67          ld   h,a
1521: 6B          ld   l,e
1522: D1          pop  de
1523: C9          ret
1524: FE B0       cp   $B0
1526: D8          ret  c
1527: CD F1 14    call $14F1
152A: 0E 02       ld   c,$02
152C: CD 90 16    call $1690
152F: 21 D7 80    ld   hl,$80D7
1532: CB C6       set  0,(hl)
1534: 11 69 15    ld   de,$1569
1537: 06 01       ld   b,$01
1539: CD 5C 16    call $165C
153C: AF          xor  a
153D: C9          ret
153E: FE B4       cp   $B4
1540: 38 E2       jr   c,$1524
1542: FE C0       cp   $C0
1544: 30 2B       jr   nc,$1571
1546: F5          push af
1547: CD F1 14    call $14F1
154A: 3E 01       ld   a,$01
154C: 32 16 8A    ld   ($8A16),a
154F: F1          pop  af
1550: 0F          rrca
1551: 30 01       jr   nc,$1554
1553: 2D          dec  l
1554: 0F          rrca
1555: DC 6A 15    call c,$156A
1558: EB          ex   de,hl
1559: 0E 01       ld   c,$01
155B: CD 98 16    call $1698
155E: 11 68 15    ld   de,$1568
1561: 06 01       ld   b,$01
1563: CD 5C 16    call $165C
1566: AF          xor  a
1567: C9          ret
1568: 81          add  a,c
1569: 83          add  a,e
156A: 25          dec  h
156B: 7C          ld   a,h
156C: 3C          inc  a
156D: C0          ret  nz
156E: 26 DF       ld   h,$DF
1570: C9          ret
1571: FE F1       cp   $F1
1573: D8          ret  c
1574: FE F8       cp   $F8
1576: C8          ret  z
1577: CD F1 14    call $14F1
157A: 24          inc  h
157B: 2D          dec  l
157C: E5          push hl
157D: 0E 05       ld   c,$05
157F: CD 90 16    call $1690
1582: E1          pop  hl
1583: E5          push hl
1584: 7C          ld   a,h
1585: D6 04       sub  $04
1587: FE E0       cp   $E0
1589: 38 02       jr   c,$158D
158B: C6 E0       add  a,$E0
158D: 67          ld   h,a
158E: E5          push hl
158F: 0E 03       ld   c,$03
1591: CD 90 16    call $1690
1594: E1          pop  hl
1595: CD A9 15    call $15A9
1598: 2C          inc  l
1599: 2C          inc  l
159A: 0E 04       ld   c,$04
159C: E5          push hl
159D: CD 90 16    call $1690
15A0: E1          pop  hl
15A1: 7D          ld   a,l
15A2: E1          pop  hl
15A3: 6F          ld   l,a
15A4: 0E 06       ld   c,$06
15A6: C3 90 16    jp   $1690
15A9: E5          push hl
15AA: 3E 01       ld   a,$01
15AC: 32 EF 83    ld   ($83EF),a
15AF: 7C          ld   a,h
15B0: 0F          rrca
15B1: 0F          rrca
15B2: E6 3F       and  $3F
15B4: 57          ld   d,a
15B5: 7D          ld   a,l
15B6: 0F          rrca
15B7: 0F          rrca
15B8: E6 1F       and  $1F
15BA: 5F          ld   e,a
15BB: 21 D7 80    ld   hl,$80D7
15BE: CB CE       set  1,(hl)
15C0: 2A 9E 80    ld   hl,($809E)
15C3: 22 F2 83    ld   ($83F2),hl
15C6: 21 E8 80    ld   hl,$80E8
15C9: 06 08       ld   b,$08
15CB: 7E          ld   a,(hl)
15CC: BA          cp   d
15CD: 23          inc  hl
15CE: 7E          ld   a,(hl)
15CF: 23          inc  hl
15D0: 20 03       jr   nz,$15D5
15D2: BB          cp   e
15D3: 28 04       jr   z,$15D9
15D5: 10 F4       djnz $15CB
15D7: E1          pop  hl
15D8: C9          ret
15D9: 2B          dec  hl
15DA: 36 FF       ld   (hl),$FF
15DC: 2B          dec  hl
15DD: 36 FF       ld   (hl),$FF
15DF: 26 83       ld   h,$83
15E1: 7D          ld   a,l
15E2: C6 C9       add  a,$C9
15E4: 6F          ld   l,a
15E5: 7E          ld   a,(hl)
15E6: 36 00       ld   (hl),$00
15E8: 6F          ld   l,a
15E9: 26 81       ld   h,$81
15EB: 7E          ld   a,(hl)
15EC: 3C          inc  a
15ED: 20 0E       jr   nz,$15FD
15EF: 77          ld   (hl),a
15F0: 3E 13       ld   a,$13
15F2: 85          add  a,l
15F3: 6F          ld   l,a
15F4: 7E          ld   a,(hl)
15F5: 3D          dec  a
15F6: 20 05       jr   nz,$15FD
15F8: 77          ld   (hl),a
15F9: 21 1A 82    ld   hl,$821A
15FC: 35          dec  (hl)
15FD: 3E 08       ld   a,$08
15FF: 90          sub  b
1600: 87          add  a,a
1601: 87          add  a,a
1602: 87          add  a,a
1603: 87          add  a,a
1604: 87          add  a,a
1605: 21 28 82    ld   hl,$8228
1608: D7          rst  $10   ; add_a_to_hl
1609: 06 06       ld   b,$06
160B: CB FE       set  7,(hl)
160D: 2C          inc  l
160E: 2C          inc  l
160F: 2C          inc  l
1610: 2C          inc  l
1611: 10 F8       djnz $160B
1613: 11 8F 16    ld   de,$168F
1616: 06 01       ld   b,$01
1618: CD 5C 16    call $165C
161B: CD 77 0E    call $0E77
161E: CD 91 0E    call $0E91
1621: 3A 08 8A    ld   a,($8A08)
1624: A7          and  a
1625: 20 1C       jr   nz,$1643
1627: 21 1B 81    ld   hl,$811B
162A: 11 08 81    ld   de,$8108
162D: 06 05       ld   b,$05
162F: 7E          ld   a,(hl)
1630: A7          and  a
1631: 20 05       jr   nz,$1638
1633: 1A          ld   a,(de)
1634: CD 49 16    call $1649
1637: 12          ld   (de),a
1638: 78          ld   a,b
1639: 01 20 00    ld   bc,$0020
163C: 09          add  hl,bc
163D: EB          ex   de,hl
163E: 09          add  hl,bc
163F: EB          ex   de,hl
1640: 47          ld   b,a
1641: 10 EC       djnz $162F
1643: 21 E4 83    ld   hl,$83E4
1646: 35          dec  (hl)
1647: E1          pop  hl
1648: C9          ret
1649: 3D          dec  a
164A: 28 02       jr   z,$164E
164C: AF          xor  a
164D: C9          ret
164E: E5          push hl
164F: 7D          ld   a,l
1650: D6 06       sub  $06
1652: 6F          ld   l,a
1653: 7E          ld   a,(hl)
1654: E1          pop  hl
1655: FE 80       cp   $80
1657: 38 F3       jr   c,$164C
1659: 3E 01       ld   a,$01
165B: C9          ret
165C: 2A D2 83    ld   hl,($83D2)
165F: 1A          ld   a,(de)
1660: A7          and  a
1661: 28 05       jr   z,$1668
1663: BE          cp   (hl)
1664: 38 02       jr   c,$1668
1666: 77          ld   (hl),a
1667: 2C          inc  l
1668: 13          inc  de
1669: CB A5       res  4,l
166B: 10 F2       djnz $165F
166D: 22 D2 83    ld   ($83D2),hl
1670: C9          ret
1671: 2A D0 83    ld   hl,($83D0)
1674: 36 00       ld   (hl),$00
1676: 2C          inc  l
1677: CB A5       res  4,l
1679: 7E          ld   a,(hl)
167A: A7          and  a
167B: C8          ret  z
167C: 22 D0 83    ld   ($83D0),hl
167F: 3A AE 83    ld   a,($83AE)
1682: A7          and  a
1683: C0          ret  nz
1684: 01 01 00    ld   bc,$0001
1687: 11 00 70    ld   de,$7000
168A: 3E 64       ld   a,$64
168C: C3 D2 0B    jp   $0BD2
168F: A2          and  d
1690: 7C          ld   a,h
1691: E6 FC       and  $FC
1693: 57          ld   d,a
1694: 7D          ld   a,l
1695: E6 FC       and  $FC
1697: 5F          ld   e,a
1698: 21 00 88    ld   hl,$8800
169B: 06 10       ld   b,$10
169D: AF          xor  a
169E: BE          cp   (hl)
169F: 28 07       jr   z,$16A8
16A1: 23          inc  hl
16A2: 23          inc  hl
16A3: 23          inc  hl
16A4: 23          inc  hl
16A5: 10 F7       djnz $169E
16A7: C9          ret
16A8: 23          inc  hl
16A9: 77          ld   (hl),a
16AA: 23          inc  hl
16AB: 73          ld   (hl),e
16AC: 23          inc  hl
16AD: 72          ld   (hl),d
16AE: 2B          dec  hl
16AF: 2B          dec  hl
16B0: 2B          dec  hl
16B1: 71          ld   (hl),c
16B2: EB          ex   de,hl
16B3: CD 1E 10    call $101E
16B6: 7E          ld   a,(hl)
16B7: F6 0F       or   $0F
16B9: 77          ld   (hl),a
16BA: C9          ret
16BB: 21 D7 80    ld   hl,$80D7
16BE: 7E          ld   a,(hl)
16BF: E6 07       and  $07
16C1: C8          ret  z
16C2: 36 00       ld   (hl),$00
16C4: 21 DB 16    ld   hl,$16DB
16C7: 3D          dec  a
16C8: 4F          ld   c,a
16C9: 87          add  a,a
16CA: 81          add  a,c
16CB: D7          rst  $10   ; add_a_to_hl
16CC: 4E          ld   c,(hl)
16CD: 23          inc  hl
16CE: 7E          ld   a,(hl)
16CF: 23          inc  hl
16D0: 66          ld   h,(hl)
16D1: 6F          ld   l,a
16D2: 3A 15 8A    ld   a,($8A15)
16D5: A7          and  a
16D6: C0          ret  nz
16D7: 3E 48       ld   a,$48
16D9: F7          rst  $30
16DA: C9          ret

16F8: C5          push bc
16F9: F5          push af
16FA: ED 44       neg
16FC: 5F          ld   e,a
16FD: 16 00       ld   d,$00
16FF: 17          rla
1700: 30 01       jr   nc,$1703
1702: 15          dec  d
1703: 2A C8 80    ld   hl,($80C8)
1706: A7          and  a
1707: ED 52       sbc  hl,de
1709: 22 C8 80    ld   ($80C8),hl
170C: 21 13 81    ld   hl,$8113
170F: 06 06       ld   b,$06
1711: 7E          ld   a,(hl)
1712: 83          add  a,e
1713: 77          ld   (hl),a
1714: 1F          rra
1715: AA          xor  d
1716: E6 80       and  $80
1718: 2C          inc  l
1719: 2C          inc  l
171A: 2C          inc  l
171B: AE          xor  (hl)
171C: 77          ld   (hl),a
171D: 7D          ld   a,l
171E: C6 1D       add  a,$1D
1720: 6F          ld   l,a
1721: 10 EE       djnz $1711
1723: 3A 32 83    ld   a,($8332)
1726: 83          add  a,e
1727: 32 32 83    ld   ($8332),a
172A: 3A 3B 83    ld   a,($833B)
172D: 83          add  a,e
172E: 32 3B 83    ld   ($833B),a
1731: 3A 52 83    ld   a,($8352)
1734: 83          add  a,e
1735: 32 52 83    ld   ($8352),a
1738: 3A 5B 83    ld   a,($835B)
173B: 83          add  a,e
173C: 32 5B 83    ld   ($835B),a
173F: F1          pop  af
1740: C1          pop  bc
1741: C9          ret
1742: C5          push bc
1743: F5          push af
1744: 4F          ld   c,a
1745: 06 00       ld   b,$00
1747: 17          rla
1748: 30 01       jr   nc,$174B
174A: 05          dec  b
174B: 2A CA 80    ld   hl,($80CA)
174E: 09          add  hl,bc
174F: 22 CA 80    ld   ($80CA),hl
1752: 7C          ld   a,h
1753: FE 07       cp   $07
1755: 38 0C       jr   c,$1763
1757: C6 07       add  a,$07
1759: CB 7C       bit  7,h
175B: 20 02       jr   nz,$175F
175D: D6 0E       sub  $0E
175F: 67          ld   h,a
1760: 22 CA 80    ld   ($80CA),hl
1763: 06 06       ld   b,$06
1765: 21 14 81    ld   hl,$8114
1768: 11 20 00    ld   de,$0020
176B: 7E          ld   a,(hl)
176C: 81          add  a,c
176D: 77          ld   (hl),a
176E: 19          add  hl,de
176F: 10 FA       djnz $176B
1771: 3A 34 83    ld   a,($8334)
1774: 81          add  a,c
1775: 32 34 83    ld   ($8334),a
1778: 3A 3D 83    ld   a,($833D)
177B: 81          add  a,c
177C: 32 3D 83    ld   ($833D),a
177F: 3A 54 83    ld   a,($8354)
1782: 81          add  a,c
1783: 32 54 83    ld   ($8354),a
1786: 3A 5D 83    ld   a,($835D)
1789: 81          add  a,c
178A: 32 5D 83    ld   ($835D),a
178D: F1          pop  af
178E: C1          pop  bc
178F: C9          ret

jump_table_1790:
	.word	$17A2 
	.word	$17B9 
	.word	$17D0 
	.word	$17E6 
	.word	$17FC 
	.word	$1812 
	.word	$1829 
	.word	$1840
	.word	$1854

 
17A2: 3A 8A 80    ld   a,($808A)
17A5: 26 00       ld   h,$00
17A7: 6F          ld   l,a
17A8: 29          add  hl,hl
17A9: 29          add  hl,hl
17AA: 29          add  hl,hl
17AB: 29          add  hl,hl
17AC: DF          rst  $18
17AD: 22 6A 80    ld   ($806A),hl
17B0: 21 00 00    ld   hl,$0000
17B3: 22 68 80    ld   ($8068),hl
17B6: C3 54 18    jp   $1854
17B9: 3A 8A 80    ld   a,($808A)
17BC: 16 00       ld   d,$00
17BE: 5F          ld   e,a
17BF: 62          ld   h,d
17C0: 6B          ld   l,e
17C1: 29          add  hl,hl
17C2: 29          add  hl,hl
17C3: 19          add  hl,de
17C4: 29          add  hl,hl
17C5: 19          add  hl,de
17C6: 22 68 80    ld   ($8068),hl
17C9: DF          rst  $18
17CA: 22 6A 80    ld   ($806A),hl
17CD: C3 54 18    jp   $1854
17D0: 3A 8A 80    ld   a,($808A)
17D3: 26 00       ld   h,$00
17D5: 6F          ld   l,a
17D6: 29          add  hl,hl
17D7: 29          add  hl,hl
17D8: 29          add  hl,hl
17D9: 29          add  hl,hl
17DA: 22 68 80    ld   ($8068),hl
17DD: 21 00 00    ld   hl,$0000
17E0: 22 6A 80    ld   ($806A),hl
17E3: C3 54 18    jp   $1854
17E6: 3A 8A 80    ld   a,($808A)
17E9: 16 00       ld   d,$00
17EB: 5F          ld   e,a
17EC: 62          ld   h,d
17ED: 6B          ld   l,e
17EE: 29          add  hl,hl
17EF: 29          add  hl,hl
17F0: 19          add  hl,de
17F1: 29          add  hl,hl
17F2: 19          add  hl,de
17F3: 22 68 80    ld   ($8068),hl
17F6: 22 6A 80    ld   ($806A),hl
17F9: C3 54 18    jp   $1854
17FC: 3A 8A 80    ld   a,($808A)
17FF: 26 00       ld   h,$00
1801: 6F          ld   l,a
1802: 29          add  hl,hl
1803: 29          add  hl,hl
1804: 29          add  hl,hl
1805: 29          add  hl,hl
1806: 22 6A 80    ld   ($806A),hl
1809: 21 00 00    ld   hl,$0000
180C: 22 68 80    ld   ($8068),hl
180F: C3 54 18    jp   $1854
1812: 3A 8A 80    ld   a,($808A)
1815: 16 00       ld   d,$00
1817: 5F          ld   e,a
1818: 62          ld   h,d
1819: 6B          ld   l,e
181A: 29          add  hl,hl
181B: 29          add  hl,hl
181C: 19          add  hl,de
181D: 29          add  hl,hl
181E: 19          add  hl,de
181F: 22 6A 80    ld   ($806A),hl
1822: DF          rst  $18
1823: 22 68 80    ld   ($8068),hl
1826: C3 54 18    jp   $1854
1829: 3A 8A 80    ld   a,($808A)
182C: 26 00       ld   h,$00
182E: 6F          ld   l,a
182F: 29          add  hl,hl
1830: 29          add  hl,hl
1831: 29          add  hl,hl
1832: 29          add  hl,hl
1833: DF          rst  $18
1834: 22 68 80    ld   ($8068),hl
1837: 21 00 00    ld   hl,$0000
183A: 22 6A 80    ld   ($806A),hl
183D: C3 54 18    jp   $1854
1840: 3A 8A 80    ld   a,($808A)
1843: 16 00       ld   d,$00
1845: 5F          ld   e,a
1846: 62          ld   h,d
1847: 6B          ld   l,e
1848: 29          add  hl,hl
1849: 29          add  hl,hl
184A: 19          add  hl,de
184B: 29          add  hl,hl
184C: 19          add  hl,de
184D: DF          rst  $18
184E: 22 68 80    ld   ($8068),hl
1851: 22 6A 80    ld   ($806A),hl
1854: 3A 7C 80    ld   a,($807C)
1857: E6 07       and  $07
1859: C0          ret  nz
185A: 3A CC 80    ld   a,($80CC)
185D: EE 04       xor  $04
185F: 32 CC 80    ld   ($80CC),a
1862: C9          ret

18B3: 21 68 19    ld   hl,$1968
18B6: 3A 7C 80    ld   a,($807C)
18B9: 0E 4E       ld   c,$4E
18BB: E6 10       and  $10
18BD: 28 02       jr   z,$18C1
18BF: 0E 5D       ld   c,$5D
18C1: 79          ld   a,c
18C2: 11 06 85    ld   de,$8506
18C5: CD 32 19    call $1932
18C8: 11 67 85    ld   de,$8567
18CB: 3A E1 83    ld   a,($83E1)
18CE: A7          and  a
18CF: 20 0A       jr   nz,$18DB
18D1: 21 37 19    ld   hl,$1937
18D4: 01 0F 00    ld   bc,$000F
18D7: ED B0       ldir
18D9: 18 1A       jr   $18F5
18DB: 06 0F       ld   b,$0F
18DD: 3E 24       ld   a,$24
18DF: 12          ld   (de),a
18E0: 13          inc  de
18E1: 10 FC       djnz $18DF
18E3: 3A E1 83    ld   a,($83E1)
18E6: 21 2B 0B    ld   hl,$0B2B
18E9: 3D          dec  a
18EA: 28 03       jr   z,$18EF
18EC: 21 3D 0B    ld   hl,$0B3D
18EF: 11 47 86    ld   de,$8647
18F2: CD 25 19    call $1925
18F5: 21 16 0B    ld   hl,$0B16
18F8: 11 06 86    ld   de,$8606
18FB: CD 25 19    call $1925
18FE: 21 46 19    ld   hl,$1946
1901: CD 37 1A    call $1A37
1904: CD 37 1A    call $1A37
1907: 21 54 19    ld   hl,$1954
190A: 11 2A 87    ld   de,$872A
190D: 01 05 00    ld   bc,$0005
1910: ED B0       ldir
1912: EB          ex   de,hl
1913: 3A 7A 83    ld   a,($837A)
1916: 2F          cpl
1917: 0E 24       ld   c,$24
1919: FE 0A       cp   $0A
191B: 38 04       jr   c,$1921
191D: 0E 01       ld   c,$01
191F: D6 0A       sub  $0A
1921: 71          ld   (hl),c
1922: 23          inc  hl
1923: 77          ld   (hl),a
1924: C9          ret
1925: 3A 7C 80    ld   a,($807C)
1928: E6 10       and  $10
192A: 3E 4E       ld   a,$4E
192C: 28 02       jr   z,$1930
192E: 3E 40       ld   a,$40
1930: 23          inc  hl
1931: 23          inc  hl
1932: 4E          ld   c,(hl)
1933: 23          inc  hl
1934: C3 3E 1A    jp   $1A3E



197A: 3E 41       ld   a,$41
197C: CD 67 0B    call $0B67
197F: 3E 04       ld   a,$04
1981: 32 6D 80    ld   ($806D),a
1984: 32 10 98    ld   ($9810),a
1987: 21 DF 19    ld   hl,$19DF
198A: CD 37 1A    call $1A37
198D: CD 37 1A    call $1A37
1990: CD 37 1A    call $1A37
1993: CD 37 1A    call $1A37
1996: CD 37 1A    call $1A37
1999: 3E 01       ld   a,$01
199B: 32 C8 81    ld   ($81C8),a
199E: 3A C8 81    ld   a,($81C8)
19A1: A7          and  a
19A2: 20 FA       jr   nz,$199E
19A4: 3A 7C 80    ld   a,($807C)
19A7: E6 1F       and  $1F
19A9: CC D2 19    call z,$19D2
19AC: E6 0F       and  $0F
19AE: CC C5 19    call z,$19C5
19B1: 3A 0A 8A    ld   a,($8A0A)
19B4: A7          and  a
19B5: 20 ED       jr   nz,$19A4
19B7: CD C5 19    call $19C5
19BA: AF          xor  a
19BB: 32 7C 80    ld   ($807C),a
19BE: 3A 7C 80    ld   a,($807C)
19C1: FE 78       cp   $78
19C3: 38 F9       jr   c,$19BE
19C5: 21 C0 8D    ld   hl,$8DC0
19C8: 06 80       ld   b,$80
19CA: CB C6       set  0,(hl)
19CC: 23          inc  hl
19CD: 10 FB       djnz $19CA
19CF: 3E 01       ld   a,$01
19D1: C9          ret
19D2: 21 C0 8D    ld   hl,$8DC0
19D5: 06 80       ld   b,$80
19D7: CB 86       res  0,(hl)
19D9: 23          inc  hl
19DA: 10 FB       djnz $19D7
19DC: 3E 01       ld   a,$01
19DE: C9          ret

1A37: 5E          ld   e,(hl)
1A38: 23          inc  hl
1A39: 56          ld   d,(hl)
1A3A: 23          inc  hl
1A3B: 4E          ld   c,(hl)
1A3C: 23          inc  hl
1A3D: 7E          ld   a,(hl)
1A3E: 23          inc  hl
1A3F: 41          ld   b,c
1A40: 0C          inc  c
1A41: CB DA       set  3,d
1A43: 12          ld   (de),a
1A44: CB 9A       res  3,d
1A46: ED A0       ldi
1A48: 10 F7       djnz $1A41
1A4A: C9          ret

1A63: AF          xor  a
1A64: 6F          ld   l,a
1A65: 57          ld   d,a
1A66: CB 7B       bit  7,e
1A68: 28 01       jr   z,$1A6B
1A6A: 94          sub  h
1A6B: CB 7C       bit  7,h
1A6D: 28 01       jr   z,$1A70
1A6F: 93          sub  e
1A70: 06 08       ld   b,$08
1A72: 29          add  hl,hl
1A73: 30 01       jr   nc,$1A76
1A75: 19          add  hl,de
1A76: 10 FA       djnz $1A72
1A78: 84          add  a,h
1A79: C9          ret
1A7A: AF          xor  a
1A7B: 06 11       ld   b,$11
1A7D: 8F          adc  a,a
1A7E: 38 0A       jr   c,$1A8A
1A80: 91          sub  c
1A81: 30 01       jr   nc,$1A84
1A83: 81          add  a,c
1A84: 3F          ccf
1A85: ED 6A       adc  hl,hl
1A87: 10 F4       djnz $1A7D
1A89: C9          ret
1A8A: 91          sub  c
1A8B: A7          and  a
1A8C: C3 84 1A    jp   $1A84
1A8F: DD 21 08 81 ld   ix,$8108
1A93: 06 06       ld   b,$06
1A95: DD 7E 00    ld   a,(ix+$00)
1A98: A7          and  a
1A99: 28 08       jr   z,$1AA3
1A9B: FE 09       cp   $09
1A9D: CC 08 24    call z,$2408
1AA0: CD 28 25    call $2528
1AA3: 11 20 00    ld   de,$0020
1AA6: DD 19       add  ix,de
1AA8: 10 EB       djnz $1A95
1AAA: C9          ret
1AAB: DD 21 08 81 ld   ix,$8108
1AAF: AF          xor  a
1AB0: 32 08 82    ld   ($8208),a
1AB3: 32 EB 81    ld   ($81EB),a
1AB6: 06 05       ld   b,$05
1AB8: DD 7E 00    ld   a,(ix+$00)
1ABB: A7          and  a
1ABC: 28 28       jr   z,$1AE6
1ABE: FE FE       cp   $FE
1AC0: 28 20       jr   z,$1AE2
1AC2: FE 0A       cp   $0A
1AC4: D2 E7 1E    jp   nc,$1EE7
1AC7: FE 05       cp   $05
1AC9: D2 BA 23    jp   nc,$23BA
1ACC: 3A 7C 80    ld   a,($807C)
1ACF: DD A6 17    and  (ix+$17)
1AD2: B8          cp   b
1AD3: CC D9 1F    call z,$1FD9
1AD6: CD FE 24    call $24FE
1AD9: CD 39 22    call $2239
1ADC: CD 83 21    call $2183
1ADF: CD 28 25    call $2528
1AE2: 21 EB 81    ld   hl,$81EB
1AE5: 34          inc  (hl)
1AE6: 11 20 00    ld   de,$0020
1AE9: DD 19       add  ix,de
1AEB: 10 CB       djnz $1AB8
1AED: 3A 7A 83    ld   a,($837A)
1AF0: FE 23       cp   $23
1AF2: CC C8 1D    call z,$1DC8
1AF5: FE 28       cp   $28
1AF7: CA F1 1D    jp   z,$1DF1
1AFA: FE 37       cp   $37
1AFC: CC C8 1D    call z,$1DC8
1AFF: FE 3C       cp   $3C
1B01: CA CD 1D    jp   z,$1DCD
1B04: FE 50       cp   $50
1B06: CC B5 1D    call z,$1DB5
1B09: 21 F2 83    ld   hl,$83F2
1B0C: 7E          ld   a,(hl)
1B0D: 3D          dec  a
1B0E: 28 02       jr   z,$1B12
1B10: 77          ld   (hl),a
1B11: C9          ret
1B12: 23          inc  hl
1B13: 4E          ld   c,(hl)
1B14: 0D          dec  c
1B15: 28 04       jr   z,$1B1B
1B17: 71          ld   (hl),c
1B18: 2B          dec  hl
1B19: 77          ld   (hl),a
1B1A: C9          ret
1B1B: 2A 68 83    ld   hl,($8368)
1B1E: 7C          ld   a,h
1B1F: B5          or   l
1B20: 20 05       jr   nz,$1B27
1B22: CB F9       set  7,c
1B24: 21 10 0E    ld   hl,$0E10
1B27: 2B          dec  hl
1B28: 22 68 83    ld   ($8368),hl
1B2B: 2A 6A 83    ld   hl,($836A)
1B2E: 7C          ld   a,h
1B2F: B5          or   l
1B30: 20 05       jr   nz,$1B37
1B32: CB F1       set  6,c
1B34: 21 08 07    ld   hl,$0708
1B37: 2B          dec  hl
1B38: 22 6A 83    ld   ($836A),hl
1B3B: 2A 6C 83    ld   hl,($836C)
1B3E: 7C          ld   a,h
1B3F: B5          or   l
1B40: 20 05       jr   nz,$1B47
1B42: CB E9       set  5,c
1B44: 21 2C 01    ld   hl,$012C
1B47: 2B          dec  hl
1B48: 22 6C 83    ld   ($836C),hl
1B4B: 2A 6E 83    ld   hl,($836E)
1B4E: 7C          ld   a,h
1B4F: B5          or   l
1B50: 20 05       jr   nz,$1B57
1B52: CB E1       set  4,c
1B54: 21 A4 01    ld   hl,$01A4
1B57: 2B          dec  hl
1B58: 22 6E 83    ld   ($836E),hl
1B5B: 2A 70 83    ld   hl,($8370)
1B5E: 7C          ld   a,h
1B5F: B5          or   l
1B60: 20 05       jr   nz,$1B67
1B62: CB C9       set  1,c
1B64: 21 50 00    ld   hl,$0050
1B67: 2B          dec  hl
1B68: 22 70 83    ld   ($8370),hl
1B6B: 21 72 83    ld   hl,$8372
1B6E: 7E          ld   a,(hl)
1B6F: 35          dec  (hl)
1B70: A7          and  a
1B71: 20 04       jr   nz,$1B77
1B73: 36 78       ld   (hl),$78
1B75: CB D1       set  2,c
1B77: 21 74 83    ld   hl,$8374
1B7A: 7E          ld   a,(hl)
1B7B: 35          dec  (hl)
1B7C: A7          and  a
1B7D: 20 04       jr   nz,$1B83
1B7F: 36 B4       ld   (hl),$B4
1B81: CB D9       set  3,c
1B83: 3A 76 83    ld   a,($8376)
1B86: 47          ld   b,a
1B87: AF          xor  a
1B88: CB 11       rl   c
1B8A: 30 01       jr   nc,$1B8D
1B8C: 3C          inc  a
1B8D: 10 F9       djnz $1B88
1B8F: 47          ld   b,a
1B90: 3A E9 81    ld   a,($81E9)
1B93: 3D          dec  a
1B94: 28 2F       jr   z,$1BC5
1B96: 3A 79 83    ld   a,($8379)
1B99: A7          and  a
1B9A: 20 1B       jr   nz,$1BB7
1B9C: 3A 7A 83    ld   a,($837A)
1B9F: FE 0F       cp   $0F
1BA1: 28 1D       jr   z,$1BC0
1BA3: FE 23       cp   $23
1BA5: 28 19       jr   z,$1BC0
1BA7: FE 32       cp   $32
1BA9: 28 15       jr   z,$1BC0
1BAB: FE 82       cp   $82
1BAD: 28 11       jr   z,$1BC0
1BAF: FE A0       cp   $A0
1BB1: 28 0D       jr   z,$1BC0
1BB3: FE BE       cp   $BE
1BB5: 28 09       jr   z,$1BC0
1BB7: 78          ld   a,b
1BB8: A7          and  a
1BB9: C8          ret  z
1BBA: CD 22 1D    call $1D22
1BBD: 10 FB       djnz $1BBA
1BBF: C9          ret
1BC0: 3E 01       ld   a,$01
1BC2: 32 E9 81    ld   ($81E9),a
1BC5: 3A 97 80    ld   a,($8097)
1BC8: A7          and  a
1BC9: 20 EC       jr   nz,$1BB7
1BCB: 3A EB 81    ld   a,($81EB)
1BCE: A7          and  a
1BCF: C0          ret  nz
1BD0: 32 F1 83    ld   ($83F1),a
1BD3: 32 E9 81    ld   ($81E9),a
1BD6: 3C          inc  a
1BD7: 32 5C 80    ld   ($805C),a
1BDA: 32 08 8A    ld   ($8A08),a
1BDD: DD 21 08 81 ld   ix,$8108
1BE1: 3E 0A       ld   a,$0A
1BE3: DD 77 00    ld   (ix+$00),a
1BE6: 3A 99 83    ld   a,($8399)
1BE9: DD 77 0D    ld   (ix+$0d),a
1BEC: 3A 9A 83    ld   a,($839A)
1BEF: F6 30       or   $30
1BF1: DD 77 0E    ld   (ix+$0e),a
1BF4: DD 36 01 00 ld   (ix+$01),$00
1BF8: DD 36 02 00 ld   (ix+$02),$00
1BFC: DD 36 03 00 ld   (ix+$03),$00
1C00: DD 36 04 00 ld   (ix+$04),$00
1C04: DD 36 13 00 ld   (ix+$13),$00
1C08: DD 36 12 F0 ld   (ix+$12),$F0
1C0C: DD 36 15 12 ld   (ix+$15),$12
1C10: 3A F9 81    ld   a,($81F9)
1C13: DD 77 17    ld   (ix+$17),a
1C16: EF          rst  $28
1C17: E6 03       and  $03
1C19: 32 BD 89    ld   ($89BD),a
1C1C: CD 8E 1E    call $1E8E
1C1F: 3A BD 89    ld   a,($89BD)
1C22: 21 C0 27    ld   hl,$27C0
1C25: CF          rst  $08
1C26: 5E          ld   e,(hl)
1C27: 23          inc  hl
1C28: 56          ld   d,(hl)
1C29: DD 21 28 81 ld   ix,$8128
1C2D: 06 04       ld   b,$04
1C2F: 0E 0B       ld   c,$0B
1C31: DD 71 00    ld   (ix+$00),c
1C34: DD 36 01 00 ld   (ix+$01),$00
1C38: DD 36 02 00 ld   (ix+$02),$00
1C3C: DD 36 03 00 ld   (ix+$03),$00
1C40: DD 36 04 00 ld   (ix+$04),$00
1C44: DD 36 13 00 ld   (ix+$13),$00
1C48: 3A 99 83    ld   a,($8399)
1C4B: DD 77 0D    ld   (ix+$0d),a
1C4E: 3A 9A 83    ld   a,($839A)
1C51: DD 77 0E    ld   (ix+$0e),a
1C54: DD 36 15 12 ld   (ix+$15),$12
1C58: 3A F9 81    ld   a,($81F9)
1C5B: DD 77 17    ld   (ix+$17),a
1C5E: 0C          inc  c
1C5F: 2A EF 81    ld   hl,($81EF)
1C62: 1A          ld   a,(de)
1C63: CD 11 1D    call $1D11
1C66: DD 74 0A    ld   (ix+$0a),h
1C69: DD 75 09    ld   (ix+$09),l
1C6C: 13          inc  de
1C6D: 2A ED 81    ld   hl,($81ED)
1C70: 1A          ld   a,(de)
1C71: CD 11 1D    call $1D11
1C74: DD 74 07    ld   (ix+$07),h
1C77: DD 75 06    ld   (ix+$06),l
1C7A: DD 36 12 F0 ld   (ix+$12),$F0
1C7E: D6 10       sub  $10
1C80: EB          ex   de,hl
1C81: 11 20 00    ld   de,$0020
1C84: DD 19       add  ix,de
1C86: EB          ex   de,hl
1C87: 13          inc  de
1C88: 10 A7       djnz $1C31
1C8A: 3E 60       ld   a,$60
1C8C: 21 20 81    ld   hl,$8120
1C8F: 11 20 89    ld   de,$8920
1C92: 06 08       ld   b,$08
1C94: 36 24       ld   (hl),$24
1C96: 12          ld   (de),a
1C97: 2C          inc  l
1C98: 1C          inc  e
1C99: 10 F9       djnz $1C94
1C9B: 2E 40       ld   l,$40
1C9D: 5D          ld   e,l
1C9E: 06 08       ld   b,$08
1CA0: 36 24       ld   (hl),$24
1CA2: 12          ld   (de),a
1CA3: 2C          inc  l
1CA4: 1C          inc  e
1CA5: 10 F9       djnz $1CA0
1CA7: 2E 60       ld   l,$60
1CA9: 5D          ld   e,l
1CAA: 06 08       ld   b,$08
1CAC: 36 24       ld   (hl),$24
1CAE: 12          ld   (de),a
1CAF: 2C          inc  l
1CB0: 1C          inc  e
1CB1: 10 F9       djnz $1CAC
1CB3: 3A BD 89    ld   a,($89BD)
1CB6: E6 03       and  $03
1CB8: 4F          ld   c,a
1CB9: 81          add  a,c
1CBA: 81          add  a,c
1CBB: 87          add  a,a
1CBC: 21 F9 1C    ld   hl,$1CF9
1CBF: D7          rst  $10   ; add_a_to_hl
1CC0: EB          ex   de,hl
1CC1: 21 25 81    ld   hl,$8125
1CC4: CD DA 1C    call $1CDA
1CC7: 2E 44       ld   l,$44
1CC9: CD DA 1C    call $1CDA
1CCC: 2C          inc  l
1CCD: CD DA 1C    call $1CDA
1CD0: 2E 64       ld   l,$64
1CD2: CD DA 1C    call $1CDA
1CD5: 2C          inc  l
1CD6: CD DA 1C    call $1CDA
1CD9: 2C          inc  l
1CDA: 1A          ld   a,(de)
1CDB: 36 3D       ld   (hl),$3D
1CDD: CB 6F       bit  5,a
1CDF: 20 0E       jr   nz,$1CEF
1CE1: CB 67       bit  4,a
1CE3: 28 01       jr   z,$1CE6
1CE5: 34          inc  (hl)
1CE6: F6 30       or   $30
1CE8: 26 89       ld   h,$89
1CEA: 77          ld   (hl),a
1CEB: 13          inc  de
1CEC: 26 81       ld   h,$81
1CEE: C9          ret
1CEF: 36 24       ld   (hl),$24
1CF1: 26 89       ld   h,$89
1CF3: 36 60       ld   (hl),$60
1CF5: 26 81       ld   h,$81
1CF7: 13          inc  de
1CF8: C9          ret

1D11: CB 7F       bit  7,a
1D13: CA 10 00    jp   z,$0010
1D16: 25          dec  h
1D17: C3 10 00    jp   $0010
1D1A: 87          add  a,a
1D1B: D2 10 00    jp   nc,$0010
1D1E: 25          dec  h
1D1F: C3 10 00    jp   $0010

1D22: DD 21 08 81 ld   ix,$8108
1D26: 3A 77 83    ld   a,($8377)
1D29: 4F          ld   c,a
1D2A: AF          xor  a
1D2B: 11 20 00    ld   de,$0020
1D2E: DD BE 00    cp   (ix+$00)
1D31: 28 08       jr   z,$1D3B
1D33: DD 19       add  ix,de
1D35: 0D          dec  c
1D36: 20 F6       jr   nz,$1D2E
1D38: 06 01       ld   b,$01
1D3A: C9          ret
1D3B: 21 19 82    ld   hl,$8219
1D3E: 34          inc  (hl)
1D3F: 7E          ld   a,(hl)
1D40: E6 03       and  $03
1D42: 3C          inc  a
1D43: FE 02       cp   $02
1D45: 20 01       jr   nz,$1D48
1D47: 3D          dec  a
1D48: DD 77 00    ld   (ix+$00),a
1D4B: DD 36 13 00 ld   (ix+$13),$00
1D4F: DD 36 15 06 ld   (ix+$15),$06
1D53: 21 E8 27    ld   hl,$27E8
1D56: 3D          dec  a
1D57: CF          rst  $08
1D58: 7E          ld   a,(hl)
1D59: DD 77 0D    ld   (ix+$0d),a
1D5C: 23          inc  hl
1D5D: 7E          ld   a,(hl)
1D5E: DD 77 0E    ld   (ix+$0e),a
1D61: EF          rst  $28
1D62: E6 60       and  $60
1D64: DD 77 16    ld   (ix+$16),a
1D67: DD 7E 00    ld   a,(ix+$00)
1D6A: 21 F6 81    ld   hl,$81F6
1D6D: 3D          dec  a
1D6E: D7          rst  $10   ; add_a_to_hl
1D6F: 7E          ld   a,(hl)
1D70: DD 77 17    ld   (ix+$17),a
1D73: EF          rst  $28
1D74: E6 03       and  $03
1D76: 4F          ld   c,a
1D77: 21 90 28    ld   hl,$2890
1D7A: 3A 7A 83    ld   a,($837A)
1D7D: FE 5A       cp   $5A
1D7F: 38 03       jr   c,$1D84
1D81: 21 D0 28    ld   hl,$28D0
1D84: 3A 8C 80    ld   a,($808C)
1D87: 87          add  a,a
1D88: 87          add  a,a
1D89: B1          or   c
1D8A: CF          rst  $08
1D8B: EB          ex   de,hl
1D8C: 2A C8 80    ld   hl,($80C8)
1D8F: 1A          ld   a,(de)
1D90: CD 1A 1D    call $1D1A
1D93: DD 74 07    ld   (ix+$07),h
1D96: DD 75 06    ld   (ix+$06),l
1D99: 2A CA 80    ld   hl,($80CA)
1D9C: 13          inc  de
1D9D: 1A          ld   a,(de)
1D9E: CD 1A 1D    call $1D1A
1DA1: DD 74 0A    ld   (ix+$0a),h
1DA4: DD 75 09    ld   (ix+$09),l
1DA7: AF          xor  a
1DA8: DD 77 08    ld   (ix+$08),a
1DAB: DD 77 05    ld   (ix+$05),a
1DAE: DD 36 12 01 ld   (ix+$12),$01
1DB2: C3 D9 1F    jp   $1FD9
1DB5: 3A E5 83    ld   a,($83E5)
1DB8: FE 02       cp   $02
1DBA: 38 06       jr   c,$1DC2
1DBC: 3E 1E       ld   a,$1E
1DBE: 32 7A 83    ld   ($837A),a
1DC1: C9          ret
1DC2: 3E 32       ld   a,$32
1DC4: 32 7A 83    ld   ($837A),a
1DC7: C9          ret
1DC8: AF          xor  a
1DC9: 32 D2 80    ld   ($80D2),a
1DCC: C9          ret
1DCD: 3A D2 80    ld   a,($80D2)
1DD0: A7          and  a
1DD1: C0          ret  nz
1DD2: 3A E5 83    ld   a,($83E5)
1DD5: FE 03       cp   $03
1DD7: D0          ret  nc
1DD8: DD 21 08 81 ld   ix,$8108
1DDC: 06 05       ld   b,$05
1DDE: AF          xor  a
1DDF: 11 20 00    ld   de,$0020
1DE2: DD BE 00    cp   (ix+$00)
1DE5: 28 2E       jr   z,$1E15
1DE7: DD 19       add  ix,de
1DE9: 10 F7       djnz $1DE2
1DEB: 3E 3B       ld   a,$3B
1DED: 32 7A 83    ld   ($837A),a
1DF0: C9          ret
1DF1: 3A D2 80    ld   a,($80D2)
1DF4: A7          and  a
1DF5: C0          ret  nz
1DF6: 3A E5 83    ld   a,($83E5)
1DF9: FE 03       cp   $03
1DFB: D8          ret  c
1DFC: DD 21 08 81 ld   ix,$8108
1E00: 06 05       ld   b,$05
1E02: AF          xor  a
1E03: 11 20 00    ld   de,$0020
1E06: DD BE 00    cp   (ix+$00)
1E09: 28 0A       jr   z,$1E15
1E0B: DD 19       add  ix,de
1E0D: 10 F7       djnz $1E06
1E0F: 3E 27       ld   a,$27
1E11: 32 7A 83    ld   ($837A),a
1E14: C9          ret
1E15: 3A F0 83    ld   a,($83F0)
1E18: FE 19       cp   $19
1E1A: 30 10       jr   nc,$1E2C
1E1C: 3E 01       ld   a,$01
1E1E: 32 D2 80    ld   ($80D2),a
1E21: 3E 6D       ld   a,$6D
1E23: 32 7A 83    ld   ($837A),a
1E26: 3E 09       ld   a,$09
1E28: 32 7C 83    ld   ($837C),a
1E2B: C9          ret
1E2C: 32 D2 80    ld   ($80D2),a
1E2F: 3C          inc  a
1E30: 32 5D 80    ld   ($805D),a
1E33: DD 36 00 01 ld   (ix+$00),$01
1E37: DD 36 0D 80 ld   (ix+$0d),$80
1E3B: DD 36 0E 07 ld   (ix+$0e),$07
1E3F: DD 36 13 00 ld   (ix+$13),$00
1E43: DD 36 16 01 ld   (ix+$16),$01
1E47: 3A F0 83    ld   a,($83F0)
1E4A: C6 1E       add  a,$1E
1E4C: 30 02       jr   nc,$1E50
1E4E: 3E FF       ld   a,$FF
1E50: DD 77 12    ld   (ix+$12),a
1E53: 3A F0 83    ld   a,($83F0)
1E56: CB 3F       srl  a
1E58: 32 F0 83    ld   ($83F0),a
1E5B: 3A F7 81    ld   a,($81F7)
1E5E: DD 77 17    ld   (ix+$17),a
1E61: EF          rst  $28
1E62: E6 03       and  $03
1E64: 4F          ld   c,a
1E65: 3A 8C 80    ld   a,($808C)
1E68: 87          add  a,a
1E69: 87          add  a,a
1E6A: B1          or   c
1E6B: 21 90 28    ld   hl,$2890
1E6E: CF          rst  $08
1E6F: EB          ex   de,hl
1E70: 2A C8 80    ld   hl,($80C8)
1E73: 1A          ld   a,(de)
1E74: CD 1A 1D    call $1D1A
1E77: DD 74 07    ld   (ix+$07),h
1E7A: DD 75 06    ld   (ix+$06),l
1E7D: 2A CA 80    ld   hl,($80CA)
1E80: 13          inc  de
1E81: 1A          ld   a,(de)
1E82: CD 1A 1D    call $1D1A
1E85: DD 74 0A    ld   (ix+$0a),h
1E88: DD 75 09    ld   (ix+$09),l
1E8B: C3 D9 1F    jp   $1FD9
1E8E: EF          rst  $28
1E8F: E6 07       and  $07
1E91: 47          ld   b,a
1E92: 21 E8 80    ld   hl,$80E8
1E95: CF          rst  $08
1E96: 3E 08       ld   a,$08
1E98: 90          sub  b
1E99: 47          ld   b,a
1E9A: 0E 08       ld   c,$08
1E9C: 7E          ld   a,(hl)
1E9D: 5F          ld   e,a
1E9E: 23          inc  hl
1E9F: A6          and  (hl)
1EA0: 3C          inc  a
1EA1: 7E          ld   a,(hl)
1EA2: 23          inc  hl
1EA3: 28 30       jr   z,$1ED5
1EA5: 6F          ld   l,a
1EA6: AF          xor  a
1EA7: 57          ld   d,a
1EA8: 67          ld   h,a
1EA9: 29          add  hl,hl
1EAA: 29          add  hl,hl
1EAB: 29          add  hl,hl
1EAC: 29          add  hl,hl
1EAD: 29          add  hl,hl
1EAE: 01 18 00    ld   bc,$0018
1EB1: 09          add  hl,bc
1EB2: DD 74 07    ld   (ix+$07),h
1EB5: DD 75 06    ld   (ix+$06),l
1EB8: 22 ED 81    ld   ($81ED),hl
1EBB: EB          ex   de,hl
1EBC: 29          add  hl,hl
1EBD: 29          add  hl,hl
1EBE: 29          add  hl,hl
1EBF: 29          add  hl,hl
1EC0: 29          add  hl,hl
1EC1: 3A BD 89    ld   a,($89BD)
1EC4: A7          and  a
1EC5: 20 03       jr   nz,$1ECA
1EC7: 01 F8 FF    ld   bc,$FFF8
1ECA: 09          add  hl,bc
1ECB: DD 74 0A    ld   (ix+$0a),h
1ECE: DD 75 09    ld   (ix+$09),l
1ED1: 22 EF 81    ld   ($81EF),hl
1ED4: C9          ret
1ED5: 0D          dec  c
1ED6: 10 C4       djnz $1E9C
1ED8: 41          ld   b,c
1ED9: C8          ret  z
1EDA: 21 E8 80    ld   hl,$80E8
1EDD: C3 9C 1E    jp   $1E9C
1EE0: DD 36 12 01 ld   (ix+$12),$01
1EE4: C3 E6 1A    jp   $1AE6
1EE7: 3C          inc  a
1EE8: CA DF 1A    jp   z,$1ADF
1EEB: FE 10       cp   $10
1EED: D2 12 1F    jp   nc,$1F12
1EF0: FE 0B       cp   $0B
1EF2: CC 4C 1F    call z,$1F4C
1EF5: CD 39 22    call $2239
1EF8: CD 83 21    call $2183
1EFB: CD 28 25    call $2528
1EFE: 21 EB 81    ld   hl,$81EB
1F01: 34          inc  (hl)
1F02: DD 7E 13    ld   a,(ix+$13)
1F05: A7          and  a
1F06: CA E6 1A    jp   z,$1AE6
1F09: DD 35 12    dec  (ix+$12)
1F0C: CA E0 1E    jp   z,$1EE0
1F0F: C3 E6 1A    jp   $1AE6
1F12: 3A 7C 80    ld   a,($807C)
1F15: DD A6 17    and  (ix+$17)
1F18: B8          cp   b
1F19: CC 22 1F    call z,$1F22
1F1C: CD 39 22    call $2239
1F1F: C3 DC 1A    jp   $1ADC
1F22: DD 7E 14    ld   a,(ix+$14)
1F25: A7          and  a
1F26: C8          ret  z
1F27: DD 35 14    dec  (ix+$14)
1F2A: 3A F5 81    ld   a,($81F5)
1F2D: 32 0D 82    ld   ($820D),a
1F30: DD 7E 00    ld   a,(ix+$00)
1F33: D6 11       sub  $11
1F35: 38 01       jr   c,$1F38
1F37: 3C          inc  a
1F38: DD 86 15    add  a,(ix+$15)
1F3B: F2 42 1F    jp   p,$1F42
1F3E: C6 18       add  a,$18
1F40: 18 06       jr   $1F48
1F42: FE 18       cp   $18
1F44: 38 02       jr   c,$1F48
1F46: D6 18       sub  $18
1F48: C5          push bc
1F49: C3 6D 20    jp   $206D
1F4C: 3A 7C 80    ld   a,($807C)
1F4F: F6 F8       or   $F8
1F51: 3C          inc  a
1F52: C0          ret  nz
1F53: C5          push bc
1F54: CD 77 24    call sub_2477
1F57: DD 7E 13    ld   a,(ix+$13)
1F5A: A7          and  a
1F5B: 3A F5 81    ld   a,($81F5)
1F5E: 20 02       jr   nz,$1F62
1F60: 3E 28       ld   a,$28
1F62: CD D5 1F    call $1FD5
1F65: DD 6E 01    ld   l,(ix+$01)
1F68: DD 66 02    ld   h,(ix+$02)
1F6B: DD 5E 03    ld   e,(ix+$03)
1F6E: DD 56 04    ld   d,(ix+$04)
1F71: DD 4E 0D    ld   c,(ix+$0d)
1F74: DD 46 15    ld   b,(ix+$15)
1F77: 3A 28 81    ld   a,($8128)
1F7A: 3C          inc  a
1F7B: FE 0C       cp   $0C
1F7D: 38 0F       jr   c,$1F8E
1F7F: 22 29 81    ld   ($8129),hl
1F82: ED 53 2B 81 ld   ($812B),de
1F86: 79          ld   a,c
1F87: 32 35 81    ld   ($8135),a
1F8A: 78          ld   a,b
1F8B: 32 3D 81    ld   ($813D),a
1F8E: 3A 48 81    ld   a,($8148)
1F91: 3C          inc  a
1F92: FE 0C       cp   $0C
1F94: 38 0F       jr   c,$1FA5
1F96: 22 49 81    ld   ($8149),hl
1F99: ED 53 4B 81 ld   ($814B),de
1F9D: 79          ld   a,c
1F9E: 32 55 81    ld   ($8155),a
1FA1: 78          ld   a,b
1FA2: 32 5D 81    ld   ($815D),a
1FA5: 3A 68 81    ld   a,($8168)
1FA8: 3C          inc  a
1FA9: FE 0C       cp   $0C
1FAB: 38 0F       jr   c,$1FBC
1FAD: 22 69 81    ld   ($8169),hl
1FB0: ED 53 6B 81 ld   ($816B),de
1FB4: 79          ld   a,c
1FB5: 32 75 81    ld   ($8175),a
1FB8: 78          ld   a,b
1FB9: 32 7D 81    ld   ($817D),a
1FBC: 3A 88 81    ld   a,($8188)
1FBF: 3C          inc  a
1FC0: FE 0C       cp   $0C
1FC2: 38 0F       jr   c,$1FD3
1FC4: 22 89 81    ld   ($8189),hl
1FC7: ED 53 8B 81 ld   ($818B),de
1FCB: 79          ld   a,c
1FCC: 32 95 81    ld   ($8195),a
1FCF: 78          ld   a,b
1FD0: 32 9D 81    ld   ($819D),a
1FD3: C1          pop  bc
1FD4: C9          ret
1FD5: C5          push bc
1FD6: C3 61 20    jp   $2061
1FD9: C5          push bc
1FDA: DD 7E 00    ld   a,(ix+$00)
1FDD: 3D          dec  a
1FDE: 28 50       jr   z,$2030
1FE0: 3D          dec  a
1FE1: 3D          dec  a
1FE2: FE 14       cp   $14
1FE4: D2 6D 22    jp   nc,$226D
1FE7: DD 7E 13    ld   a,(ix+$13)
1FEA: A7          and  a
1FEB: C2 FA 1F    jp   nz,$1FFA
1FEE: DD 36 12 FF ld   (ix+$12),$FF
1FF2: CD 77 24    call sub_2477
1FF5: 3E 28       ld   a,$28
1FF7: C3 61 20    jp   $2061
1FFA: DD 7E 00    ld   a,(ix+$00)
1FFD: FE 03       cp   $03
1FFF: C2 5F 21    jp   nz,$215F
2002: DD 34 12    inc  (ix+$12)
2005: CD 77 24    call sub_2477
2008: CD D0 20    call $20D0
200B: 47          ld   b,a
200C: DD 7E 12    ld   a,(ix+$12)
200F: E6 1F       and  $1F
2011: 21 F0 27    ld   hl,$27F0
2014: D7          rst  $10   ; add_a_to_hl
2015: DD 7E 16    ld   a,(ix+$16)
2018: D7          rst  $10   ; add_a_to_hl
2019: 7E          ld   a,(hl)
201A: 80          add  a,b
201B: FE 18       cp   $18
201D: 38 06       jr   c,$2025
201F: C6 18       add  a,$18
2021: 38 02       jr   c,$2025
2023: D6 30       sub  $30
2025: 4F          ld   c,a
2026: 3A F4 81    ld   a,($81F4)
2029: 32 0D 82    ld   ($820D),a
202C: 79          ld   a,c
202D: C3 67 20    jp   $2067
2030: CD 77 24    call sub_2477
2033: DD 7E 13    ld   a,(ix+$13)
2036: A7          and  a
2037: 3E 28       ld   a,$28
2039: 28 26       jr   z,$2061
203B: DD 7E 0E    ld   a,(ix+$0e)
203E: E6 7F       and  $7F
2040: FE 03       cp   $03
2042: 3A F3 81    ld   a,($81F3)
2045: 28 1A       jr   z,$2061
2047: 3A F2 81    ld   a,($81F2)
204A: 32 0D 82    ld   ($820D),a
204D: CD D0 20    call $20D0
2050: DD 4E 12    ld   c,(ix+$12)
2053: 0D          dec  c
2054: 20 11       jr   nz,$2067
2056: C6 0C       add  a,$0C
2058: FE 18       cp   $18
205A: 38 0B       jr   c,$2067
205C: D6 18       sub  $18
205E: C3 67 20    jp   $2067
2061: 32 0D 82    ld   ($820D),a
2064: CD D0 20    call $20D0
2067: DD 4E 15    ld   c,(ix+$15)
206A: CD D7 24    call $24D7
206D: DD 77 15    ld   (ix+$15),a
2070: CD 1A 27    call $271A
2073: CD 53 27    call $2753
2076: 28 1D       jr   z,$2095
2078: 3D          dec  a
2079: 28 0E       jr   z,$2089
207B: DD 7E 15    ld   a,(ix+$15)
207E: C6 04       add  a,$04
2080: FE 18       cp   $18
2082: 38 0E       jr   c,$2092
2084: D6 18       sub  $18
2086: C3 92 20    jp   $2092
2089: DD 7E 15    ld   a,(ix+$15)
208C: D6 04       sub  $04
208E: 30 02       jr   nc,$2092
2090: C6 18       add  a,$18
2092: DD 77 15    ld   (ix+$15),a
2095: DD 7E 15    ld   a,(ix+$15)
2098: 4F          ld   c,a
2099: 21 6B 18    ld   hl,$186B
209C: D7          rst  $10   ; add_a_to_hl
209D: DD 7E 0D    ld   a,(ix+$0d)
20A0: E6 E0       and  $E0
20A2: B6          or   (hl)
20A3: DD 77 0D    ld   (ix+$0d),a
20A6: 79          ld   a,c
20A7: 21 83 18    ld   hl,$1883
20AA: CF          rst  $08
20AB: 5E          ld   e,(hl)
20AC: 22 13 82    ld   ($8213),hl
20AF: 3A 0D 82    ld   a,($820D)
20B2: 67          ld   h,a
20B3: CD 63 1A    call $1A63
20B6: DD 77 02    ld   (ix+$02),a
20B9: DD 75 01    ld   (ix+$01),l
20BC: 2A 13 82    ld   hl,($8213)
20BF: 23          inc  hl
20C0: 5E          ld   e,(hl)
20C1: 3A 0D 82    ld   a,($820D)
20C4: 67          ld   h,a
20C5: CD 63 1A    call $1A63
20C8: DD 77 04    ld   (ix+$04),a
20CB: DD 75 03    ld   (ix+$03),l
20CE: C1          pop  bc
20CF: C9          ret
20D0: CB 7C       bit  7,h
20D2: C2 08 21    jp   nz,$2108
20D5: CB 7A       bit  7,d
20D7: C2 F4 20    jp   nz,$20F4
20DA: 7C          ld   a,h
20DB: B5          or   l
20DC: 0E 0C       ld   c,$0C
20DE: CA 33 21    jp   z,$2133
20E1: CD 39 21    call $2139
20E4: 21 10 29    ld   hl,$2910
20E7: 06 06       ld   b,$06
20E9: BE          cp   (hl)
20EA: D2 33 21    jp   nc,$2133
20ED: 0D          dec  c
20EE: 23          inc  hl
20EF: 10 F8       djnz $20E9
20F1: C3 33 21    jp   $2133
20F4: 7A          ld   a,d
20F5: 2F          cpl
20F6: 57          ld   d,a
20F7: 7B          ld   a,e
20F8: 2F          cpl
20F9: 5F          ld   e,a
20FA: 13          inc  de
20FB: 0E 00       ld   c,$00
20FD: 7C          ld   a,h
20FE: B5          or   l
20FF: CA 33 21    jp   z,$2133
2102: CD 39 21    call $2139
2105: C3 13 21    jp   $2113
2108: CB 7A       bit  7,d
210A: C2 23 21    jp   nz,$2123
210D: DF          rst  $18
210E: CD 39 21    call $2139
2111: 0E 0C       ld   c,$0C
2113: 21 10 29    ld   hl,$2910
2116: 06 06       ld   b,$06
2118: BE          cp   (hl)
2119: D2 33 21    jp   nc,$2133
211C: 0C          inc  c
211D: 23          inc  hl
211E: 10 F8       djnz $2118
2120: C3 33 21    jp   $2133
2123: DF          rst  $18
2124: 7A          ld   a,d
2125: 2F          cpl
2126: 57          ld   d,a
2127: 7B          ld   a,e
2128: 2F          cpl
2129: 5F          ld   e,a
212A: 13          inc  de
212B: CD 39 21    call $2139
212E: 0E 18       ld   c,$18
2130: C3 E4 20    jp   $20E4
2133: 79          ld   a,c
2134: FE 18       cp   $18
2136: C0          ret  nz
2137: AF          xor  a
2138: C9          ret
2139: 7C          ld   a,h
213A: A7          and  a
213B: C2 46 21    jp   nz,$2146
213E: EB          ex   de,hl
213F: 29          add  hl,hl
2140: 29          add  hl,hl
2141: 29          add  hl,hl
2142: 29          add  hl,hl
2143: C3 57 21    jp   $2157
2146: CB 2C       sra  h
2148: CB 1D       rr   l
214A: CB 2C       sra  h
214C: CB 1D       rr   l
214E: CB 2C       sra  h
2150: CB 1D       rr   l
2152: CB 2C       sra  h
2154: CB 1D       rr   l
2156: EB          ex   de,hl
2157: 51          ld   d,c
2158: 4B          ld   c,e
2159: CD 7A 1A    call $1A7A
215C: 4A          ld   c,d
215D: 7D          ld   a,l
215E: C9          ret
215F: FE 04       cp   $04
2161: C2 6D 22    jp   nz,$226D
2164: DD 34 12    inc  (ix+$12)
2167: DD 7E 12    ld   a,(ix+$12)
216A: E6 1F       and  $1F
216C: 21 70 28    ld   hl,$2870
216F: D7          rst  $10   ; add_a_to_hl
2170: 7E          ld   a,(hl)
2171: DD 86 15    add  a,(ix+$15)
2174: FE 18       cp   $18
2176: DA 25 20    jp   c,$2025
2179: C6 18       add  a,$18
217B: DA 25 20    jp   c,$2025
217E: D6 30       sub  $30
2180: C3 25 20    jp   $2025
2183: DD 66 02    ld   h,(ix+$02)
2186: DD 6E 01    ld   l,(ix+$01)
2189: DD 56 06    ld   d,(ix+$06)
218C: DD 5E 05    ld   e,(ix+$05)
218F: CB 7C       bit  7,h
2191: 28 03       jr   z,$2196
2193: DD 35 07    dec  (ix+$07)
2196: 19          add  hl,de
2197: 30 03       jr   nc,$219C
2199: DD 34 07    inc  (ix+$07)
219C: DD 74 06    ld   (ix+$06),h
219F: DD 75 05    ld   (ix+$05),l
21A2: 7C          ld   a,h
21A3: 92          sub  d
21A4: DD 86 0B    add  a,(ix+$0b)
21A7: DD 77 0B    ld   (ix+$0b),a
21AA: DD 66 04    ld   h,(ix+$04)
21AD: DD 6E 03    ld   l,(ix+$03)
21B0: DD 56 09    ld   d,(ix+$09)
21B3: DD 5E 08    ld   e,(ix+$08)
21B6: CB 7C       bit  7,h
21B8: 28 03       jr   z,$21BD
21BA: DD 35 0A    dec  (ix+$0a)
21BD: 19          add  hl,de
21BE: 30 03       jr   nc,$21C3
21C0: DD 34 0A    inc  (ix+$0a)
21C3: DD 74 09    ld   (ix+$09),h
21C6: DD 75 08    ld   (ix+$08),l
21C9: 7A          ld   a,d
21CA: 94          sub  h
21CB: DD 86 0C    add  a,(ix+$0c)
21CE: DD 77 0C    ld   (ix+$0c),a
21D1: DD 7E 0A    ld   a,(ix+$0a)
21D4: FE 07       cp   $07
21D6: 38 11       jr   c,$21E9
21D8: CB 7F       bit  7,a
21DA: 20 08       jr   nz,$21E4
21DC: D6 07       sub  $07
21DE: DD 77 0A    ld   (ix+$0a),a
21E1: C3 E9 21    jp   $21E9
21E4: C6 07       add  a,$07
21E6: DD 77 0A    ld   (ix+$0a),a
21E9: DD 7E 00    ld   a,(ix+$00)
21EC: FE 0A       cp   $0A
21EE: C0          ret  nz
21EF: DD 66 0A    ld   h,(ix+$0a)
21F2: DD 6E 09    ld   l,(ix+$09)
21F5: CB 2C       sra  h
21F7: CB 1D       rr   l
21F9: CB 2C       sra  h
21FB: CB 1D       rr   l
21FD: CB 2C       sra  h
21FF: CB 1D       rr   l
2201: CB 2C       sra  h
2203: CB 1D       rr   l
2205: CB BD       res  7,l
2207: 3E 9D       ld   a,$9D
2209: 95          sub  l
220A: FE 2E       cp   $2E
220C: 20 01       jr   nz,$220F
220E: 3C          inc  a
220F: DD 77 10    ld   (ix+$10),a
2212: DD 66 07    ld   h,(ix+$07)
2215: DD 6E 06    ld   l,(ix+$06)
2218: CB 2C       sra  h
221A: CB 1D       rr   l
221C: CB 2C       sra  h
221E: CB 1D       rr   l
2220: CB 2C       sra  h
2222: CB 1D       rr   l
2224: CB 2C       sra  h
2226: CB 1D       rr   l
2228: 7D          ld   a,l
2229: E6 3F       and  $3F
222B: 2E 04       ld   l,$04
222D: C6 E0       add  a,$E0
222F: 38 01       jr   c,$2232
2231: 2C          inc  l
2232: DD 77 0F    ld   (ix+$0f),a
2235: DD 75 11    ld   (ix+$11),l
2238: C9          ret
2239: DD 7E 13    ld   a,(ix+$13)
223C: A7          and  a
223D: C8          ret  z
223E: DD 66 0C    ld   h,(ix+$0c)
2241: DD 6E 0B    ld   l,(ix+$0b)
2244: CD 54 27    call $2754
2247: C8          ret  z
2248: 7B          ld   a,e
2249: FE C0       cp   $C0
224B: D0          ret  nc
224C: CD 05 23    call $2305
224F: DD 7E 00    ld   a,(ix+$00)
2252: FE 0A       cp   $0A
2254: CC 6F 22    call z,$226F
2257: DD 36 00 09 ld   (ix+$00),$09
225B: DD 36 14 00 ld   (ix+$14),$00
225F: 7C          ld   a,h
2260: C6 0E       add  a,$0E
2262: 57          ld   d,a
2263: 7B          ld   a,e
2264: 5D          ld   e,l
2265: 1C          inc  e
2266: C5          push bc
2267: 2A 53 80    ld   hl,($8053)
226A: CD 3E 15    call $153E
226D: C1          pop  bc
226E: C9          ret
226F: F5          push af
2270: 3A 28 81    ld   a,($8128)
2273: 3C          inc  a
2274: FE 0C       cp   $0C
2276: 38 0F       jr   c,$2287
2278: C6 03       add  a,$03
227A: 32 28 81    ld   ($8128),a
227D: 3E 01       ld   a,$01
227F: 32 3A 81    ld   ($813A),a
2282: 3E 05       ld   a,$05
2284: 32 3C 81    ld   ($813C),a
2287: 3A 48 81    ld   a,($8148)
228A: 3C          inc  a
228B: FE 0C       cp   $0C
228D: 38 0F       jr   c,$229E
228F: C6 03       add  a,$03
2291: 32 48 81    ld   ($8148),a
2294: 3E 01       ld   a,$01
2296: 32 5A 81    ld   ($815A),a
2299: 3E 08       ld   a,$08
229B: 32 5C 81    ld   ($815C),a
229E: 3A 68 81    ld   a,($8168)
22A1: 3C          inc  a
22A2: FE 0C       cp   $0C
22A4: 38 0F       jr   c,$22B5
22A6: C6 03       add  a,$03
22A8: 32 68 81    ld   ($8168),a
22AB: 3E 01       ld   a,$01
22AD: 32 7A 81    ld   ($817A),a
22B0: 3E 08       ld   a,$08
22B2: 32 7C 81    ld   ($817C),a
22B5: 3A 88 81    ld   a,($8188)
22B8: 3C          inc  a
22B9: FE 0C       cp   $0C
22BB: 38 0F       jr   c,$22CC
22BD: C6 03       add  a,$03
22BF: 32 88 81    ld   ($8188),a
22C2: 3E 01       ld   a,$01
22C4: 32 9A 81    ld   ($819A),a
22C7: 3E 05       ld   a,$05
22C9: 32 9C 81    ld   ($819C),a
22CC: AF          xor  a
22CD: 32 F5 8B    ld   ($8BF5),a
22D0: 32 F6 8B    ld   ($8BF6),a
22D3: 32 08 8A    ld   ($8A08),a
22D6: F1          pop  af
22D7: C9          ret

2305: E5          push hl
2306: D5          push de
2307: C5          push bc
2308: DD 7E 00    ld   a,(ix+$00)
230B: C6 02       add  a,$02
230D: 21 D8 22    ld   hl,$22D8
2310: D7          rst  $10   ; add_a_to_hl
2311: 6E          ld   l,(hl)
2312: 26 8A       ld   h,$8A
2314: 34          inc  (hl)
2315: DD 7E 00    ld   a,(ix+$00)
2318: FE 0A       cp   $0A
231A: 30 18       jr   nc,$2334
231C: 3D          dec  a
231D: 28 60       jr   z,$237F
231F: 3C          inc  a
2320: C6 02       add  a,$02
2322: 21 EF 22    ld   hl,$22EF
2325: D7          rst  $10   ; add_a_to_hl
2326: 06 01       ld   b,$01
2328: EB          ex   de,hl
2329: CD 5C 16    call $165C
232C: DD 36 15 00 ld   (ix+$15),$00
2330: C1          pop  bc
2331: D1          pop  de
2332: E1          pop  hl
2333: C9          ret
2334: 3C          inc  a
2335: 28 E9       jr   z,$2320
2337: 21 F1 83    ld   hl,$83F1
233A: 34          inc  (hl)
233B: 7E          ld   a,(hl)
233C: FE 05       cp   $05
233E: 28 0D       jr   z,$234D
2340: DD 7E 00    ld   a,(ix+$00)
2343: 21 9B 83    ld   hl,$839B
2346: FE 0A       cp   $0A
2348: 28 DC       jr   z,$2326
234A: 2C          inc  l
234B: 18 D9       jr   $2326
234D: 3A 9A 83    ld   a,($839A)
2350: D6 03       sub  $03
2352: E6 03       and  $03
2354: 21 70 23    ld   hl,$2370
2357: 4F          ld   c,a
2358: 81          add  a,c
2359: 81          add  a,c
235A: D7          rst  $10   ; add_a_to_hl
235B: 7E          ld   a,(hl)
235C: DD 77 15    ld   (ix+$15),a
235F: 23          inc  hl
2360: 06 02       ld   b,$02
2362: EB          ex   de,hl
2363: CD 5C 16    call $165C
2366: C1          pop  bc
2367: D1          pop  de
2368: E1          pop  hl
2369: C9          ret

237F: DD CB 16 46 bit  0,(ix+$16)
2383: 28 9A       jr   z,$231F
2385: 3A E5 83    ld   a,($83E5)
2388: FE 03       cp   $03
238A: 3E 31       ld   a,$31
238C: 38 02       jr   c,$2390
238E: 3E 1D       ld   a,$1D
2390: 32 7A 83    ld   ($837A),a
2393: 3E 09       ld   a,$09
2395: 32 7C 83    ld   ($837C),a
2398: 3A 9B 80    ld   a,($809B)
239B: 11 6E 23    ld   de,$236E
239E: FE 3D       cp   $3D
23A0: 38 0A       jr   c,$23AC
23A2: 11 6C 23    ld   de,$236C
23A5: FE 65       cp   $65
23A7: 38 03       jr   c,$23AC
23A9: 11 6A 23    ld   de,$236A
23AC: 1A          ld   a,(de)
23AD: DD 77 15    ld   (ix+$15),a
23B0: 13          inc  de
23B1: 06 01       ld   b,$01
23B3: CD 5C 16    call $165C
23B6: C1          pop  bc
23B7: D1          pop  de
23B8: E1          pop  hl
23B9: C9          ret
23BA: FE 09       cp   $09
23BC: 28 41       jr   z,$23FF
23BE: D6 05       sub  $05
23C0: 87          add  a,a
23C1: 87          add  a,a
23C2: 57          ld   d,a
23C3: 3A E0 83    ld   a,($83E0)
23C6: FE 07       cp   $07
23C8: CA 50 24    jp   z,$2450
23CB: DD 7E 14    ld   a,(ix+$14)
23CE: DD 34 14    inc  (ix+$14)
23D1: DD 34 12    inc  (ix+$12)
23D4: 1E D0       ld   e,$D0
23D6: A7          and  a
23D7: 28 1A       jr   z,$23F3
23D9: 1E E0       ld   e,$E0
23DB: FE 08       cp   $08
23DD: 28 14       jr   z,$23F3
23DF: 1E F0       ld   e,$F0
23E1: FE 10       cp   $10
23E3: 28 0E       jr   z,$23F3
23E5: FE 18       cp   $18
23E7: DA E2 1A    jp   c,$1AE2
23EA: 21 E0 83    ld   hl,$83E0
23ED: 34          inc  (hl)
23EE: 3E 7C       ld   a,$7C
23F0: C3 F5 23    jp   $23F5
23F3: 7A          ld   a,d
23F4: B3          or   e
23F5: DD 77 0D    ld   (ix+$0d),a
23F8: DD 36 0E 4C ld   (ix+$0e),$4C
23FC: C3 E2 1A    jp   $1AE2
23FF: CD 08 24    call $2408
2402: C2 E6 1A    jp   nz,$1AE6
2405: C3 DC 1A    jp   $1ADC
2408: DD 7E 14    ld   a,(ix+$14)
240B: DD 34 14    inc  (ix+$14)
240E: DD 34 12    inc  (ix+$12)
2411: 1E A0       ld   e,$A0
2413: A7          and  a
2414: 28 31       jr   z,$2447
2416: 1E A4       ld   e,$A4
2418: FE 08       cp   $08
241A: 28 2B       jr   z,$2447
241C: 1E A8       ld   e,$A8
241E: FE 10       cp   $10
2420: 28 25       jr   z,$2447
2422: FE 18       cp   $18
2424: 20 4A       jr   nz,$2470
2426: DD 7E 15    ld   a,(ix+$15)
2429: A7          and  a
242A: 20 33       jr   nz,$245F
242C: DD 36 14 00 ld   (ix+$14),$00
2430: DD 36 00 00 ld   (ix+$00),$00
2434: DD 36 0D 6C ld   (ix+$0d),$6C
2438: DD 7E 13    ld   a,(ix+$13)
243B: DD 36 13 00 ld   (ix+$13),$00
243F: 3D          dec  a
2440: C0          ret  nz
2441: 21 1A 82    ld   hl,$821A
2444: 35          dec  (hl)
2445: 3C          inc  a
2446: C9          ret
2447: DD 73 0D    ld   (ix+$0d),e
244A: DD 36 0E 08 ld   (ix+$0e),$08
244E: AF          xor  a
244F: C9          ret
2450: 3E 02       ld   a,$02
2452: 32 E0 83    ld   ($83E0),a
2455: AF          xor  a
2456: DD 77 00    ld   (ix+$00),a
2459: DD 77 13    ld   (ix+$13),a
245C: C3 E2 1A    jp   $1AE2
245F: DD 77 0D    ld   (ix+$0d),a
2462: AF          xor  a
2463: DD 77 01    ld   (ix+$01),a
2466: DD 77 02    ld   (ix+$02),a
2469: DD 77 03    ld   (ix+$03),a
246C: DD 77 04    ld   (ix+$04),a
246F: C9          ret
2470: FE 40       cp   $40
2472: D2 2C 24    jp   nc,$242C
2475: AF          xor  a
2476: C9          ret

sub_2477:
2477: 2A CA 80    ld   hl,($80CA)
247A: 7C          ld   a,h
247B: E6 07       and  $07
247D: 67          ld   h,a
247E: DD 7E 0A    ld   a,(ix+$0a)
2481: E6 07       and  $07
2483: 57          ld   d,a
2484: DD 5E 09    ld   e,(ix+$09)
2487: BC          cp   h
2488: CC D4 24    call z,$24D4
248B: D2 BA 24    jp   nc,$24BA
248E: ED 52       sbc  hl,de
2490: 7C          ld   a,h
2491: FE 03       cp   $03
2493: DA A2 24    jp   c,$24A2
2496: C2 9E 24    jp   nz,$249E
2499: CB 7D       bit  7,l
249B: CA A2 24    jp   z,$24A2
249E: 11 00 F9    ld   de,$F900
24A1: 19          add  hl,de
24A2: EB          ex   de,hl
24A3: 2A C8 80    ld   hl,($80C8)
24A6: DD 46 07    ld   b,(ix+$07)
24A9: DD 4E 06    ld   c,(ix+$06)
24AC: A7          and  a
24AD: ED 42       sbc  hl,bc
24AF: 7C          ld   a,h
24B0: E6 03       and  $03
24B2: CB 4F       bit  1,a
24B4: 28 02       jr   z,$24B8
24B6: F6 FC       or   $FC
24B8: 67          ld   h,a
24B9: C9          ret
24BA: EB          ex   de,hl
24BB: A7          and  a
24BC: ED 52       sbc  hl,de
24BE: 7C          ld   a,h
24BF: FE 03       cp   $03
24C1: DA D0 24    jp   c,$24D0
24C4: C2 CC 24    jp   nz,$24CC
24C7: CB 7D       bit  7,l
24C9: CA D0 24    jp   z,$24D0
24CC: 11 00 F9    ld   de,$F900
24CF: 19          add  hl,de
24D0: DF          rst  $18
24D1: C3 A2 24    jp   $24A2
24D4: 7B          ld   a,e
24D5: BD          cp   l
24D6: C9          ret
24D7: B9          cp   c
24D8: C8          ret  z
24D9: 08          ex   af,af'
24DA: DD 7E 13    ld   a,(ix+$13)
24DD: A7          and  a
24DE: 20 02       jr   nz,$24E2
24E0: 08          ex   af,af'
24E1: C9          ret
24E2: 08          ex   af,af'
24E3: C6 18       add  a,$18
24E5: 91          sub  c
24E6: FE 18       cp   $18
24E8: 38 02       jr   c,$24EC
24EA: D6 18       sub  $18
24EC: FE 0C       cp   $0C
24EE: 3E 01       ld   a,$01
24F0: 38 02       jr   c,$24F4
24F2: ED 44       neg
24F4: 81          add  a,c
24F5: FE 18       cp   $18
24F7: D8          ret  c
24F8: C6 18       add  a,$18
24FA: D8          ret  c
24FB: D6 30       sub  $30
24FD: C9          ret
24FE: DD 7E 00    ld   a,(ix+$00)
2501: 3D          dec  a
2502: 28 05       jr   z,$2509
2504: 21 08 82    ld   hl,$8208
2507: 34          inc  (hl)
2508: C9          ret
2509: DD 7E 13    ld   a,(ix+$13)
250C: A7          and  a
250D: C8          ret  z
250E: DD 35 12    dec  (ix+$12)
2511: C0          ret  nz
2512: DD 34 12    inc  (ix+$12)
2515: C9          ret
2516: 4C          ld   c,h
2517: C5          push bc
2518: 4F          ld   c,a
2519: CB 7C       bit  7,h
251B: C4 18 00    call nz,$0018
251E: CD 7A 1A    call $1A7A
2521: C1          pop  bc
2522: CB 79       bit  7,c
2524: C8          ret  z
2525: C3 18 00    jp   $0018
2528: ED 5B C8 80 ld   de,($80C8)
252C: DD 66 07    ld   h,(ix+$07)
252F: DD 6E 06    ld   l,(ix+$06)
2532: A7          and  a
2533: ED 52       sbc  hl,de
2535: 11 80 FF    ld   de,$FF80
2538: 19          add  hl,de
2539: 7C          ld   a,h
253A: F6 FC       or   $FC
253C: 3C          inc  a
253D: C2 B6 25    jp   nz,$25B6
2540: 7D          ld   a,l
2541: D6 10       sub  $10
2543: FE DF       cp   $DF
2545: D2 B6 25    jp   nc,$25B6
2548: 4D          ld   c,l
2549: 2A CA 80    ld   hl,($80CA)
254C: 7C          ld   a,h
254D: E6 07       and  $07
254F: 20 0D       jr   nz,$255E
2551: DD 7E 0A    ld   a,(ix+$0a)
2554: E6 07       and  $07
2556: FE 06       cp   $06
2558: 20 10       jr   nz,$256A
255A: 3C          inc  a
255B: C3 6A 25    jp   $256A
255E: FE 06       cp   $06
2560: DD 7E 0A    ld   a,(ix+$0a)
2563: 20 05       jr   nz,$256A
2565: E6 07       and  $07
2567: 20 01       jr   nz,$256A
2569: 24          inc  h
256A: 57          ld   d,a
256B: DD 5E 09    ld   e,(ix+$09)
256E: A7          and  a
256F: ED 52       sbc  hl,de
2571: 11 80 FF    ld   de,$FF80
2574: 19          add  hl,de
2575: 7C          ld   a,h
2576: F6 F8       or   $F8
2578: 3C          inc  a
2579: C2 B6 25    jp   nz,$25B6
257C: 7D          ld   a,l
257D: D6 10       sub  $10
257F: FE DF       cp   $DF
2581: D2 B6 25    jp   nc,$25B6
2584: DD 7E 13    ld   a,(ix+$13)
2587: 3D          dec  a
2588: C8          ret  z
2589: DD 7E 00    ld   a,(ix+$00)
258C: FE 02       cp   $02
258E: 28 03       jr   z,$2593
2590: 3C          inc  a
2591: 20 06       jr   nz,$2599
2593: DD 36 13 02 ld   (ix+$13),$02
2597: 18 10       jr   $25A9
2599: 3A 1A 82    ld   a,($821A)
259C: FE 05       cp   $05
259E: D2 18 26    jp   nc,$2618
25A1: 3C          inc  a
25A2: 32 1A 82    ld   ($821A),a
25A5: DD 36 13 01 ld   (ix+$13),$01
25A9: 3E F4       ld   a,$F4
25AB: 85          add  a,l
25AC: DD 77 0C    ld   (ix+$0c),a
25AF: 3E EA       ld   a,$EA
25B1: 81          add  a,c
25B2: DD 77 0B    ld   (ix+$0b),a
25B5: C9          ret
25B6: DD 7E 13    ld   a,(ix+$13)
25B9: DD 36 13 00 ld   (ix+$13),$00
25BD: 3D          dec  a
25BE: 28 11       jr   z,$25D1
25C0: 3C          inc  a
25C1: C0          ret  nz
25C2: DD 7E 00    ld   a,(ix+$00)
25C5: 3C          inc  a
25C6: FE 10       cp   $10
25C8: 30 03       jr   nc,$25CD
25CA: FE 03       cp   $03
25CC: C0          ret  nz
25CD: C3 F6 25    jp   $25F6
25D0: 34          inc  (hl)
25D1: 3A 1A 82    ld   a,($821A)
25D4: 3D          dec  a
25D5: 32 1A 82    ld   ($821A),a
25D8: DD 7E 00    ld   a,(ix+$00)
25DB: 3D          dec  a
25DC: 28 22       jr   z,$2600
25DE: 3C          inc  a
25DF: FE 0A       cp   $0A
25E1: 30 08       jr   nc,$25EB
25E3: FE 05       cp   $05
25E5: D0          ret  nc
25E6: DD 36 00 00 ld   (ix+$00),$00
25EA: C9          ret
25EB: 3C          inc  a
25EC: 28 F8       jr   z,$25E6
25EE: DD 7E 12    ld   a,(ix+$12)
25F1: 3D          dec  a
25F2: C0          ret  nz
25F3: DD 7E 00    ld   a,(ix+$00)
25F6: DD 36 00 00 ld   (ix+$00),$00
25FA: FE 0A       cp   $0A
25FC: CA 6F 22    jp   z,$226F
25FF: C9          ret
2600: DD 7E 12    ld   a,(ix+$12)
2603: 3D          dec  a
2604: C0          ret  nz
2605: DD 77 00    ld   (ix+$00),a
2608: DD CB 16 46 bit  0,(ix+$16)
260C: C8          ret  z
260D: 3E 6B       ld   a,$6B
260F: 32 7A 83    ld   ($837A),a
2612: 3E 07       ld   a,$07
2614: 32 7C 83    ld   ($837C),a
2617: C9          ret
2618: DD 7E 00    ld   a,(ix+$00)
261B: 3C          inc  a
261C: FE 0B       cp   $0B
261E: 30 05       jr   nc,$2625
2620: DD 36 00 00 ld   (ix+$00),$00
2624: C9          ret
2625: DD 7E 15    ld   a,(ix+$15)
2628: C6 0C       add  a,$0C
262A: FE 18       cp   $18
262C: 38 02       jr   c,$2630
262E: D6 18       sub  $18
2630: DD 77 15    ld   (ix+$15),a
2633: 21 6B 18    ld   hl,$186B
2636: D7          rst  $10   ; add_a_to_hl
2637: DD 7E 0D    ld   a,(ix+$0d)
263A: E6 E0       and  $E0
263C: B6          or   (hl)
263D: DD 77 0D    ld   (ix+$0d),a
2640: DD 66 04    ld   h,(ix+$04)
2643: DD 6E 03    ld   l,(ix+$03)
2646: DF          rst  $18
2647: DD 75 03    ld   (ix+$03),l
264A: DD 74 04    ld   (ix+$04),h
264D: DD 66 02    ld   h,(ix+$02)
2650: DD 6E 01    ld   l,(ix+$01)
2653: DF          rst  $18
2654: DD 75 01    ld   (ix+$01),l
2657: DD 74 02    ld   (ix+$02),h
265A: C9          ret
265B: 21 F4 83    ld   hl,$83F4
265E: 22 13 82    ld   ($8213),hl
2661: 21 D6 83    ld   hl,$83D6
2664: 01 05 05    ld   bc,$0505
2667: DD 21 08 81 ld   ix,$8108
266B: 11 20 00    ld   de,$0020
266E: DD 7E 00    ld   a,(ix+$00)
2671: A7          and  a
2672: 28 2C       jr   z,$26A0
2674: FE 0A       cp   $0A
2676: CC D2 26    call z,$26D2
2679: DD 7E 13    ld   a,(ix+$13)
267C: A7          and  a
267D: 28 21       jr   z,$26A0
267F: 3A 18 82    ld   a,($8218)
2682: A7          and  a
2683: C2 AF 26    jp   nz,$26AF
2686: DD 7E 0D    ld   a,(ix+$0d)
2689: 77          ld   (hl),a
268A: 23          inc  hl
268B: DD 7E 0B    ld   a,(ix+$0b)
268E: 77          ld   (hl),a
268F: 2B          dec  hl
2690: CB DC       set  3,h
2692: DD 7E 0C    ld   a,(ix+$0c)
2695: 77          ld   (hl),a
2696: 23          inc  hl
2697: DD 7E 0E    ld   a,(ix+$0e)
269A: 77          ld   (hl),a
269B: 23          inc  hl
269C: CB 9C       res  3,h
269E: 0D          dec  c
269F: C8          ret  z
26A0: DD 19       add  ix,de
26A2: 10 CA       djnz $266E
26A4: 41          ld   b,c
26A5: AF          xor  a
26A6: CB DC       set  3,h
26A8: 77          ld   (hl),a
26A9: 23          inc  hl
26AA: 77          ld   (hl),a
26AB: 23          inc  hl
26AC: 10 FA       djnz $26A8
26AE: C9          ret
26AF: DD 7E 0D    ld   a,(ix+$0d)
26B2: EE 03       xor  $03
26B4: 77          ld   (hl),a
26B5: 2C          inc  l
26B6: 3E F4       ld   a,$F4
26B8: DD 96 0B    sub  (ix+$0b)
26BB: 77          ld   (hl),a
26BC: 2D          dec  l
26BD: CB DC       set  3,h
26BF: 3E F0       ld   a,$F0
26C1: DD 96 0C    sub  (ix+$0c)
26C4: 77          ld   (hl),a
26C5: 2C          inc  l
26C6: DD 7E 0E    ld   a,(ix+$0e)
26C9: 77          ld   (hl),a
26CA: 2C          inc  l
26CB: CB 9C       res  3,h
26CD: 0D          dec  c
26CE: C2 A0 26    jp   nz,$26A0
26D1: C9          ret
26D2: E5          push hl
26D3: 3A 18 82    ld   a,($8218)
26D6: A7          and  a
26D7: C2 F7 26    jp   nz,$26F7
26DA: 2A 13 82    ld   hl,($8213)
26DD: 23          inc  hl
26DE: 22 13 82    ld   ($8213),hl
26E1: DD 7E 0F    ld   a,(ix+$0f)
26E4: 77          ld   (hl),a
26E5: DD 7E 10    ld   a,(ix+$10)
26E8: 26 8B       ld   h,$8B
26EA: 77          ld   (hl),a
26EB: 7D          ld   a,l
26EC: E6 0F       and  $0F
26EE: 6F          ld   l,a
26EF: DD 7E 11    ld   a,(ix+$11)
26F2: 26 98       ld   h,$98
26F4: 77          ld   (hl),a
26F5: E1          pop  hl
26F6: C9          ret
26F7: 2A 13 82    ld   hl,($8213)
26FA: 23          inc  hl
26FB: 22 13 82    ld   ($8213),hl
26FE: 3E 21       ld   a,$21
2700: DD 96 0F    sub  (ix+$0f)
2703: 77          ld   (hl),a
2704: 26 8B       ld   h,$8B
2706: 3E FC       ld   a,$FC
2708: DD 96 10    sub  (ix+$10)
270B: 77          ld   (hl),a
270C: 7D          ld   a,l
270D: E6 0F       and  $0F
270F: 6F          ld   l,a
2710: DD 7E 11    ld   a,(ix+$11)
2713: F6 01       or   $01
2715: 26 98       ld   h,$98
2717: 77          ld   (hl),a
2718: E1          pop  hl
2719: C9          ret
271A: DD 7E 13    ld   a,(ix+$13)
271D: A7          and  a
271E: C8          ret  z
271F: DD 56 04    ld   d,(ix+$04)
2722: DD 5E 03    ld   e,(ix+$03)
2725: DD 66 09    ld   h,(ix+$09)
2728: DD 6E 08    ld   l,(ix+$08)
272B: 19          add  hl,de
272C: 19          add  hl,de
272D: 19          add  hl,de
272E: 19          add  hl,de
272F: DD 7E 09    ld   a,(ix+$09)
2732: 94          sub  h
2733: DD 86 0C    add  a,(ix+$0c)
2736: 4F          ld   c,a
2737: DD 56 02    ld   d,(ix+$02)
273A: DD 5E 01    ld   e,(ix+$01)
273D: DD 66 06    ld   h,(ix+$06)
2740: DD 6E 05    ld   l,(ix+$05)
2743: 19          add  hl,de
2744: 19          add  hl,de
2745: 19          add  hl,de
2746: 19          add  hl,de
2747: 7C          ld   a,h
2748: DD 96 06    sub  (ix+$06)
274B: DD 86 0B    add  a,(ix+$0b)
274E: 6F          ld   l,a
274F: 61          ld   h,c
2750: AF          xor  a
2751: 3C          inc  a
2752: C0          ret  nz
2753: C8          ret  z
2754: C5          push bc
2755: 06 40       ld   b,$40
2757: C3 5D 27    jp   $275D

flags_changing_275a:
275A: C5          push bc
275B: 06 80       ld   b,$80
275D: 25          dec  h
275E: 25          dec  h
275F: 25          dec  h
2760: 2C          inc  l
2761: 2C          inc  l
2762: 2C          inc  l
2763: 4D          ld   c,l
2764: CD 99 27    call $2799
2767: 1A          ld   a,(de)
2768: 16 01       ld   d,$01
276A: B8          cp   b
276B: 30 27       jr   nc,$2794
276D: 3E 09       ld   a,$09
276F: 85          add  a,l
2770: 6F          ld   l,a
2771: CD 99 27    call $2799
2774: 1A          ld   a,(de)
2775: 16 02       ld   d,$02
2777: B8          cp   b
2778: 30 1A       jr   nc,$2794
277A: 7C          ld   a,h
277B: D6 09       sub  $09
277D: 67          ld   h,a
277E: CD 99 27    call $2799
2781: 1A          ld   a,(de)
2782: 16 02       ld   d,$02
2784: B8          cp   b
2785: 30 0D       jr   nc,$2794
2787: 69          ld   l,c
2788: CD 99 27    call $2799
278B: 1A          ld   a,(de)
278C: 16 01       ld   d,$01
278E: B8          cp   b
278F: 30 03       jr   nc,$2794
2791: C1          pop  bc
2792: 15          dec  d
2793: C8          ret  z
2794: 5F          ld   e,a
2795: 7A          ld   a,d
2796: C1          pop  bc
2797: A7          and  a
2798: C0          ret  nz
2799: EB          ex   de,hl
279A: 3A 70 80    ld   a,($8070)
279D: 83          add  a,e
279E: C6 0D       add  a,$0D
27A0: 1F          rra
27A1: 1F          rra
27A2: 1F          rra
27A3: 6F          ld   l,a
27A4: 3A 74 80    ld   a,($8074)
27A7: 85          add  a,l
27A8: 6F          ld   l,a
27A9: 3A 71 80    ld   a,($8071)
27AC: 92          sub  d
27AD: D6 0F       sub  $0F
27AF: 1F          rra
27B0: 1F          rra
27B1: 1F          rra
27B2: 67          ld   h,a
27B3: 3A 75 80    ld   a,($8075)
27B6: 84          add  a,h
27B7: 67          ld   h,a
27B8: CD 09 10    call $1009
27BB: 22 53 80    ld   ($8053),hl
27BE: EB          ex   de,hl
27BF: C9          ret

2918: 32 AE 83    ld   ($83AE),a
291B: C3 5A 03    jp   $035A

291E: ED 73 B7 89 ld   (stack_save_89b7),sp
2922: AF          xor  a
2923: 32 B9 89    ld   ($89B9),a
2926: 6F          ld   l,a
2927: 67          ld   h,a
2928: 22 FE 89    ld   ($89FE),hl
292B: 3C          inc  a
292C: CD 18 29    call $2918
292F: CD 1D 30    call $301D
2932: 21 3C 29    ld   hl,jump_table_293c
2935: 3A B9 89    ld   a,($89B9)
2938: E7          rst  $20		; [nb_entries=6]

2939: C3 2F 29    jp   $292F

jump_table_293c:
	.word 	$294D 
	.word 	$2A5F 
	.word 	$2BCE
	.word 	$2FCE
	.word 	$3451
	.word 	$2948

2948: AF          xor  a
2949: 32 B9 89    ld   ($89B9),a
294C: C9          ret
294D: 3E 59       ld   a,$59
294F: CD 67 0B    call $0B67
2952: 21 AD 29    ld   hl,$29AD
2955: 11 E1 84    ld   de,$84E1
2958: 06 01       ld   b,$01
295A: CD 6F 29    call $296F
295D: 11 A1 85    ld   de,$85A1
2960: 06 09       ld   b,$09
2962: CD 6F 29    call $296F
2965: 0E 1E       ld   c,$1E
2967: CD 3E 31    call $313E
296A: 21 B9 89    ld   hl,$89B9
296D: 34          inc  (hl)
296E: C9          ret
296F: 7E          ld   a,(hl)
2970: E5          push hl
2971: 21 B7 29    ld   hl,$29B7
2974: CF          rst  $08
2975: 7E          ld   a,(hl)
2976: 23          inc  hl
2977: 66          ld   h,(hl)
2978: 6F          ld   l,a
2979: CD 81 29    call $2981
297C: E1          pop  hl
297D: 23          inc  hl
297E: 10 EF       djnz $296F
2980: C9          ret
2981: C5          push bc
2982: 46          ld   b,(hl)
2983: 23          inc  hl
2984: C5          push bc
2985: D5          push de
2986: 06 06       ld   b,$06
2988: EB          ex   de,hl
2989: 1A          ld   a,(de)
298A: E6 0F       and  $0F
298C: F6 24       or   $24
298E: FE 26       cp   $26
2990: 38 02       jr   c,$2994
2992: F6 70       or   $70
2994: 77          ld   (hl),a
2995: CB DC       set  3,h
2997: 1A          ld   a,(de)
2998: E6 C0       and  $C0
299A: F6 19       or   $19
299C: 77          ld   (hl),a
299D: CB 9C       res  3,h
299F: 13          inc  de
29A0: 3E 20       ld   a,$20
29A2: D7          rst  $10   ; add_a_to_hl
29A3: 10 E4       djnz $2989
29A5: EB          ex   de,hl
29A6: D1          pop  de
29A7: C1          pop  bc
29A8: 13          inc  de
29A9: 10 D9       djnz $2984
29AB: C1          pop  bc
29AC: C9          ret

2A5F: AF       xor  a
2A60: 32 D4 8B ld   ($8BD4),a
2A63: 32 CC 80 ld   ($80CC),a
2A66: 32 08 81 ld   ($8108),a
2A69: 32 28 81 ld   ($8128),a
2A6C: 32 48 81 ld   ($8148),a
2A6F: 32 68 81 ld   ($8168),a
2A72: 32 88 81 ld   ($8188),a
2A75: CD 5B 26 call $265B
2A78: 32 6F 80 ld   ($806F),a
2A7B: 3E 18    ld   a,$18
2A7D: 32 6D 80 ld   ($806D),a
2A80: 21 00 8C ld   hl,$8C00                                       
2A83: 11 20 00    ld   de,$0020
2A86: 06 20       ld   b,$20
2A88: 34          inc  (hl)
2A89: 19          add  hl,de
2A8A: 10 FC       djnz $2A88
2A8C: 11 FF 03    ld   de,$03FF
2A8F: A7          and  a
2A90: ED 52       sbc  hl,de
2A92: EB          ex   de,hl
2A93: 06 08       ld   b,$08
2A95: 21 6D 80    ld   hl,$806D
2A98: 34          inc  (hl)
2A99: 28 0C       jr   z,$2AA7
2A9B: CD 3C 30    call $303C
2A9E: CD 1D 30    call $301D
2AA1: 10 F5       djnz $2A98
2AA3: EB          ex   de,hl
2AA4: C3 83 2A    jp   $2A83
2AA7: 21 AE 2B    ld   hl,$2BAE
2AAA: CD 37 1A    call $1A37
2AAD: CD 37 1A    call $1A37
2AB0: 0E B4       ld   c,$B4
2AB2: CD 3E 31    call $313E
2AB5: 21 0E 8E    ld   hl,$8E0E
2AB8: 11 02 01    ld   de,$0102
2ABB: 0E 0F       ld   c,$0F
2ABD: 42          ld   b,d
2ABE: 34          inc  (hl)
2ABF: 34          inc  (hl)
2AC0: 34          inc  (hl)
2AC1: 3E 20       ld   a,$20
2AC3: D7          rst  $10   ; add_a_to_hl
2AC4: 10 F8       djnz $2ABE
2AC6: 42          ld   b,d
2AC7: 34          inc  (hl)
2AC8: 34          inc  (hl)
2AC9: 34          inc  (hl)
2ACA: 2B          dec  hl
2ACB: 10 FA       djnz $2AC7
2ACD: 43          ld   b,e
2ACE: 34          inc  (hl)
2ACF: 34          inc  (hl)
2AD0: 34          inc  (hl)
2AD1: 25          dec  h
2AD2: 3E E0       ld   a,$E0
2AD4: D7          rst  $10   ; add_a_to_hl
2AD5: 10 F7       djnz $2ACE
2AD7: 43          ld   b,e
2AD8: 34          inc  (hl)
2AD9: 34          inc  (hl)
2ADA: 34          inc  (hl)
2ADB: 23          inc  hl
2ADC: 10 FA       djnz $2AD8
2ADE: 14          inc  d
2ADF: 14          inc  d
2AE0: 1C          inc  e
2AE1: 1C          inc  e
2AE2: CB 59       bit  3,c
2AE4: 28 06       jr   z,$2AEC
2AE6: CD 3C 30    call $303C
2AE9: CD 1D 30    call $301D
2AEC: CD 3C 30    call $303C
2AEF: CD 1D 30    call $301D
2AF2: 0D          dec  c
2AF3: 20 C8       jr   nz,$2ABD
2AF5: 0E 50       ld   c,$50
2AF7: CD 3E 31    call $313E
2AFA: 06 08       ld   b,$08
2AFC: 21 8D 2B    ld   hl,$2B8D
2AFF: C5          push bc
2B00: 56          ld   d,(hl)
2B01: 23          inc  hl
2B02: 5E          ld   e,(hl)
2B03: 23          inc  hl
2B04: CD 41 2B    call $2B41
2B07: C1          pop  bc
2B08: 10 F2       djnz $2AFC
2B0A: 23          inc  hl
2B0B: CD 41 2B    call $2B41
2B0E: 21 9C 2B    ld   hl,$2B9C
2B11: CD 37 1A    call $1A37
2B14: 0E B4       ld   c,$B4
2B16: CD 3E 31    call $313E
2B19: 11 00 8C    ld   de,$8C00
2B1C: 21 6F 80    ld   hl,$806F
2B1F: 06 20       ld   b,$20
2B21: 3E 40       ld   a,$40
2B23: 12          ld   (de),a
2B24: 13          inc  de
2B25: 10 FC       djnz $2B23
2B27: 06 08       ld   b,$08
2B29: 34          inc  (hl)
2B2A: 28 0B       jr   z,$2B37
2B2C: CD 3C 30    call $303C
2B2F: CD 1D 30    call $301D
2B32: 10 F5       djnz $2B29
2B34: C3 1F 2B    jp   $2B1F
2B37: 0E 32       ld   c,$32
2B39: CD 3E 31    call $313E
2B3C: 21 B9 89    ld   hl,$89B9
2B3F: 34          inc  (hl)
2B40: C9          ret
2B41: 4E          ld   c,(hl)
2B42: 23          inc  hl
2B43: CD 54 2B    call $2B54
2B46: 7B          ld   a,e
2B47: 59          ld   e,c
2B48: 82          add  a,d
2B49: 57          ld   d,a
2B4A: 0E 02       ld   c,$02
2B4C: CD 3E 31    call $313E
2B4F: 7E          ld   a,(hl)
2B50: 3C          inc  a
2B51: 20 EE       jr   nz,$2B41
2B53: C9          ret
2B54: E5          push hl
2B55: 21 DF 8C    ld   hl,$8CDF
2B58: 06 0C       ld   b,$0C
2B5A: C5          push bc
2B5B: 42          ld   b,d
2B5C: 7E          ld   a,(hl)
2B5D: E6 C0       and  $C0
2B5F: F6 1D       or   $1D
2B61: 77          ld   (hl),a
2B62: 23          inc  hl
2B63: 10 F7       djnz $2B5C
2B65: 43          ld   b,e
2B66: 7E          ld   a,(hl)
2B67: E6 C0       and  $C0
2B69: F6 0F       or   $0F
2B6B: 77          ld   (hl),a
2B6C: 23          inc  hl
2B6D: 10 F7       djnz $2B66
2B6F: 41          ld   b,c
2B70: 7E          ld   a,(hl)
2B71: E6 C0       and  $C0
2B73: F6 1E       or   $1E
2B75: 77          ld   (hl),a
2B76: 23          inc  hl
2B77: 10 F7       djnz $2B70
2B79: 3E 20       ld   a,$20
2B7B: 92          sub  d
2B7C: 93          sub  e
2B7D: 91          sub  c
2B7E: 47          ld   b,a
2B7F: 7E          ld   a,(hl)
2B80: E6 C0       and  $C0
2B82: F6 1D       or   $1D
2B84: 77          ld   (hl),a
2B85: 23          inc  hl
2B86: 10 F7       djnz $2B7F
2B88: C1          pop  bc
2B89: 10 CF       djnz $2B5A
2B8B: E1          pop  hl
2B8C: C9          ret
2B8D: 01 01 04    ld   bc,$0401
2B90: 03          inc  bc
2B91: 03          inc  bc
2B92: 03          inc  bc
2B93: 03          inc  bc
2B94: 03          inc  bc
2B95: 01 03 03    ld   bc,$0303
2B98: 01 FF 01    ld   bc,$01FF
2B9B: FF          rst  $38
2B9C: 28 85       jr   z,$2B23
2B9E: 0E 5E       ld   c,$5E
2BA0: 1C          inc  e
2BA1: 1D          dec  e
2BA2: 0A          ld   a,(bc)
2BA3: 1B          dec  de
2BA4: 24          inc  h
2BA5: 0D          dec  c
2BA6: 0E 1C       ld   c,$1C
2BA8: 1D          dec  e
2BA9: 1B          dec  de
2BAA: 18 22       jr   $2BCE

2BCE: AF          xor  a
2BCF: 32 8A 80    ld   ($808A),a
2BD2: 3E 4E       ld   a,$4E
2BD4: CD 67 0B    call $0B67
2BD7: 3A 51 80    ld   a,($8051)
2BDA: E6 10       and  $10
2BDC: 32 15 8A    ld   ($8A15),a
2BDF: 21 64 2E    ld   hl,$2E64
2BE2: CD FC 2F    call $2FFC
2BE5: 21 1E 00    ld   hl,$001E
2BE8: 22 74 80    ld   ($8074),hl
2BEB: 21 00 00    ld   hl,$0000
2BEE: 22 72 80    ld   ($8072),hl
2BF1: 21 80 01    ld   hl,$0180
2BF4: 22 C8 80    ld   ($80C8),hl
2BF7: 22 CA 80    ld   ($80CA),hl
2BFA: AF          xor  a
2BFB: 32 52 80    ld   ($8052),a
2BFE: 3E 02       ld   a,$02
2C00: 32 E0 83    ld   ($83E0),a
2C03: CD 1C 2C    call $2C1C
2C06: AF          xor  a
2C07: 32 BA 89    ld   ($89BA),a
2C0A: 21 3F 2C    ld   hl,jump_table_2c3f
2C0D: E7          rst  $20		; [nb_entries=20]
2C0E: 3A BA 89    ld   a,($89BA)
2C11: 3C          inc  a
2C12: 20 F3       jr   nz,$2C07
2C14: 32 E0 83    ld   ($83E0),a
2C17: 21 B9 89    ld   hl,$89B9
2C1A: 34          inc  (hl)
2C1B: C9          ret
2C1C: 21 D4 83    ld   hl,$83D4
2C1F: AF          xor  a
2C20: 32 CC 80    ld   ($80CC),a
2C23: 77          ld   (hl),a
2C24: 23          inc  hl
2C25: 3A 18 82    ld   a,($8218)
2C28: A7          and  a
2C29: 28 0A       jr   z,$2C35
2C2B: 36 8A       ld   (hl),$8A
2C2D: CB DC       set  3,h
2C2F: 36 01       ld   (hl),$01
2C31: 2B          dec  hl
2C32: 36 7C       ld   (hl),$7C
2C34: C9          ret
2C35: 36 6A       ld   (hl),$6A
2C37: CB DC       set  3,h
2C39: 36 01       ld   (hl),$01
2C3B: 2B          dec  hl
2C3C: 36 74       ld   (hl),$74
2C3E: C9          ret

jump_table_2c3f:
	.word	$2C72  
	.word	$2CCE  
	.word	$2D0B  
	.word	$2D34  
	.word	$2D5A  
	.word	$2D80 
	.word	$2CC4 
	.word	$0815 
	.word	$2E72 
	.word	$2EB9 
	.word	$2EDF 
	.word	$2EE9 
	.word	$2F09  
	.word	$2F42 
	.word	$2F7E  
	.word	$2CC4 
	.word	$0815 
	.word	$2C67 
	.word	$2C1C 
	.word	$2C6C 

2C67: 3E 4E       ld   a,$4E
2C69: C3 67 0B    jp   $0B67
2C6C: 3E FF       ld   a,$FF
2C6E: 32 BA 89    ld   ($89BA),a
2C71: C9          ret
2C72: 3E B4       ld   a,$B4
2C74: 0E 46       ld   c,$46
2C76: 21 E3 85    ld   hl,$85E3
2C79: CD F0 2C    call $2CF0
2C7C: 3E 06       ld   a,$06
2C7E: CD 53 2E    call $2E53
2C81: CD 5F 2E    call $2E5F
2C84: 21 96 2C    ld   hl,$2C96
2C87: CD 37 1A    call $1A37
2C8A: CD 37 1A    call $1A37
2C8D: 3E B4       ld   a,$B4
2C8F: 0E 46       ld   c,$46
2C91: 21 A3 85    ld   hl,$85A3
2C94: 18 5A       jr   $2CF0

2CC4: 0E B4       ld   c,$B4
2CC6: C3 3E 31    jp   $313E

2CC9: 0E 1E       ld   c,$1E
2CCB: C3 3E 31    jp   $313E

2CCE: 3E B0       ld   a,$B0
2CD0: 0E 45       ld   c,$45
2CD2: 21 27 85    ld   hl,$8527
2CD5: CD F0 2C    call $2CF0
2CD8: 3E 07       ld   a,$07
2CDA: CD 53 2E    call $2E53
2CDD: CD 5F 2E    call $2E5F
2CE0: 21 AC 2C    ld   hl,$2CAC
2CE3: CD 37 1A    call $1A37
2CE6: CD 37 1A    call $1A37
2CE9: 3E B0       ld   a,$B0
2CEB: 0E 45       ld   c,$45
2CED: 21 E8 84    ld   hl,$84E8
2CF0: CD 00 2D    call $2D00
2CF3: 11 1F 00    ld   de,$001F
2CF6: 19          add  hl,de
2CF7: 3C          inc  a
2CF8: CD 00 2D    call $2D00
2CFB: 0E 10       ld   c,$10
2CFD: C3 3E 31    jp   $313E
2D00: 77          ld   (hl),a
2D01: CB DC       set  3,h
2D03: 71          ld   (hl),c
2D04: 23          inc  hl
2D05: 71          ld   (hl),c
2D06: CB 9C       res  3,h
2D08: 3C          inc  a
2D09: 77          ld   (hl),a
2D0A: C9          ret
2D0B: 11 40 03    ld   de,$0340
2D0E: 21 B4 4C    ld   hl,$4CB4
2D11: 0E 01       ld   c,$01
2D13: CD AE 2D    call $2DAE
2D16: 3E 01       ld   a,$01
2D18: CD 53 2E    call $2E53
2D1B: 0E 64       ld   c,$64
2D1D: CD 3E 31    call $313E
2D20: 21 F5 2D    ld   hl,$2DF5
2D23: CD 37 1A    call $1A37
2D26: CD 37 1A    call $1A37
2D29: CD 37 1A    call $1A37
2D2C: 11 40 03    ld   de,$0340
2D2F: 21 B1 3F    ld   hl,$3FB1
2D32: 18 7A       jr   $2DAE
2D34: 11 60 04    ld   de,$0460
2D37: 21 D0 80    ld   hl,$80D0
2D3A: 0E 03       ld   c,$03
2D3C: CD AE 2D    call $2DAE
2D3F: 3E 02       ld   a,$02
2D41: CD 53 2E    call $2E53
2D44: 0E 64       ld   c,$64
2D46: CD 3E 31    call $313E
2D49: 21 14 2E    ld   hl,$2E14
2D4C: CD 37 1A    call $1A37
2D4F: CD 37 1A    call $1A37
2D52: 11 60 04    ld   de,$0460
2D55: 21 D0 70    ld   hl,$70D0
2D58: 18 54       jr   $2DAE
2D5A: 11 20 02    ld   de,$0220
2D5D: 21 B4 B4    ld   hl,$B4B4
2D60: 0E 02       ld   c,$02
2D62: CD AE 2D    call $2DAE
2D65: 3E 03       ld   a,$03
2D67: CD 53 2E    call $2E53
2D6A: 0E 64       ld   c,$64
2D6C: CD 3E 31    call $313E
2D6F: 21 28 2E    ld   hl,$2E28
2D72: CD 37 1A    call $1A37
2D75: CD 37 1A    call $1A37
2D78: 11 20 02    ld   de,$0220
2D7B: 21 B4 A4    ld   hl,$A4B4
2D7E: 18 2E       jr   $2DAE
2D80: 11 80 07    ld   de,$0780
2D83: 21 4C B4    ld   hl,$B44C
2D86: 0E 01       ld   c,$01
2D88: CD AE 2D    call $2DAE
2D8B: 3E 05       ld   a,$05
2D8D: CD 53 2E    call $2E53
2D90: 0E 64       ld   c,$64
2D92: CD 3E 31    call $313E
2D95: 21 3C 2E    ld   hl,$2E3C
2D98: CD 37 1A    call $1A37
2D9B: CD 37 1A    call $1A37
2D9E: 11 80 07    ld   de,$0780
2DA1: 21 4C A4    ld   hl,$A44C
2DA4: CD AE 2D    call $2DAE
2DA7: AF          xor  a
2DA8: 32 8C 80    ld   ($808C),a
2DAB: C3 60 10    jp   $1060
2DAE: DD 21 08 81 ld   ix,$8108
2DB2: 06 05       ld   b,$05
2DB4: AF          xor  a
2DB5: 32 1A 82    ld   ($821A),a
2DB8: DD BE 00    cp   (ix+$00)
2DBB: 28 0A       jr   z,$2DC7
2DBD: D5          push de
2DBE: 11 20 00    ld   de,$0020
2DC1: DD 19       add  ix,de
2DC3: D1          pop  de
2DC4: 10 F2       djnz $2DB8
2DC6: C9          ret
2DC7: E5          push hl
2DC8: DD E5       push ix
2DCA: E1          pop  hl
2DCB: 06 18       ld   b,$18
2DCD: 77          ld   (hl),a
2DCE: 23          inc  hl
2DCF: 10 FC       djnz $2DCD
2DD1: E1          pop  hl
2DD2: DD 73 0D    ld   (ix+$0d),e
2DD5: DD 72 0E    ld   (ix+$0e),d
2DD8: DD 75 06    ld   (ix+$06),l
2DDB: DD 36 07 01 ld   (ix+$07),$01
2DDF: DD 74 09    ld   (ix+$09),h
2DE2: DD 36 0A 01 ld   (ix+$0a),$01
2DE6: DD 71 00    ld   (ix+$00),c
2DE9: 79          ld   a,c
2DEA: A7          and  a
2DEB: C2 FB 2C    jp   nz,$2CFB
2DEE: DD 36 00 02 ld   (ix+$00),$02
2DF2: C3 FB 2C    jp   $2CFB

2E53: 32 8C 80    ld   ($808C),a
2E56: CD 60 10    call $1060
2E59: CD FB 2C    call $2CFB
2E5C: C3 B1 10    jp   $10B1
2E5F: 0E 64       ld   c,$64
2E61: C3 3E 31    jp   $313E

2E72: 21 C0 84    ld   hl,$84C0
2E75: 11 C1 84    ld   de,$84C1
2E78: 01 3F 03    ld   bc,$033F
2E7B: 36 24       ld   (hl),$24
2E7D: ED B0       ldir
2E7F: 21 C0 8C    ld   hl,$8CC0
2E82: 11 C1 8C    ld   de,$8CC1
2E85: 01 3F 03    ld   bc,$033F
2E88: 36 4E       ld   (hl),$4E
2E8A: ED B0       ldir
2E8C: 21 08 81    ld   hl,$8108
2E8F: 11 20 00    ld   de,$0020
2E92: 06 07       ld   b,$07
2E94: 36 00       ld   (hl),$00
2E96: 19          add  hl,de
2E97: 10 FB       djnz $2E94
2E99: 21 A5 2E    ld   hl,$2EA5
2E9C: 11 AC 80    ld   de,$80AC
2E9F: 01 14 00    ld   bc,$0014
2EA2: ED B0       ldir
2EA4: C9          ret

2EB9: 3E 04       ld   a,$04
2EBB: CD 78 2F    call $2F78
2EBE: 21 82 00    ld   hl,$0082
2EC1: 3A 18 82    ld   a,($8218)
2EC4: A7          and  a
2EC5: 28 08       jr   z,$2ECF
2EC7: 7C          ld   a,h
2EC8: ED 44       neg
2ECA: 67          ld   h,a
2ECB: 7D          ld   a,l
2ECC: ED 44       neg
2ECE: 6F          ld   l,a
2ECF: 22 FE 89    ld   ($89FE),hl
2ED2: CD 1D 30    call $301D
2ED5: 21 FE 89    ld   hl,$89FE
2ED8: 7E          ld   a,(hl)
2ED9: 23          inc  hl
2EDA: B6          or   (hl)
2EDB: 2B          dec  hl
2EDC: 20 F4       jr   nz,$2ED2
2EDE: C9          ret
2EDF: 21 48 80    ld   hl,$8048
2EE2: CB DE       set  3,(hl)
2EE4: CB 5E       bit  3,(hl)
2EE6: 20 FC       jr   nz,$2EE4
2EE8: C9          ret
2EE9: AF          xor  a
2EEA: CD 78 2F    call $2F78
2EED: 0E 1E       ld   c,$1E
2EEF: CD 3E 31    call $313E
2EF2: 21 2A 00    ld   hl,$002A
2EF5: CD C1 2E    call $2EC1
2EF8: 0E 28       ld   c,$28
2EFA: CD 3E 31    call $313E
2EFD: 21 D7 80    ld   hl,$80D7
2F00: CB D6       set  2,(hl)
2F02: 21 01 01    ld   hl,$0101
2F05: 22 A8 80    ld   ($80A8),hl
2F08: C9          ret
2F09: 0E 14       ld   c,$14
2F0B: CD 3E 31    call $313E
2F0E: CD 2D 2F    call $2F2D
2F11: 0E 32       ld   c,$32
2F13: CD 3E 31    call $313E
2F16: 21 A6 2F    ld   hl,$2FA6
2F19: CD 37 1A    call $1A37
2F1C: CD 37 1A    call $1A37
2F1F: 0E 78       ld   c,$78
2F21: CD 3E 31    call $313E
2F24: 21 BB 2F    ld   hl,$2FBB
2F27: CD C1 0B    call $0BC1
2F2A: C3 C1 0B    jp   $0BC1
2F2D: 21 57 1A    ld   hl,$1A57
2F30: 11 4D 86    ld   de,$864D
2F33: CD 0E 30    call $300E
2F36: 11 6D 86    ld   de,$866D
2F39: CD 0E 30    call $300E
2F3C: 11 8D 86    ld   de,$868D
2F3F: C3 0E 30    jp   $300E
2F42: 3E 02       ld   a,$02
2F44: CD 78 2F    call $2F78
2F47: 21 00 20    ld   hl,$2000
2F4A: CD C1 2E    call $2EC1
2F4D: 3E 01       ld   a,$01
2F4F: CD 78 2F    call $2F78
2F52: 21 40 40    ld   hl,$4040
2F55: CD C1 2E    call $2EC1
2F58: AF          xor  a
2F59: CD 78 2F    call $2F78
2F5C: 21 14 00    ld   hl,$0014
2F5F: CD C1 2E    call $2EC1
2F62: 3E 06       ld   a,$06
2F64: CD 78 2F    call $2F78
2F67: 0E 28       ld   c,$28
2F69: CD 3E 31    call $313E
2F6C: 21 D7 80    ld   hl,$80D7
2F6F: CB D6       set  2,(hl)
2F71: 21 01 01    ld   hl,$0101
2F74: 22 AA 80    ld   ($80AA),hl
2F77: C9          ret
2F78: 32 8C 80    ld   ($808C),a
2F7B: C3 60 10    jp   $1060
2F7E: 0E 78       ld   c,$78
2F80: CD 3E 31    call $313E
2F83: 21 8C 2F    ld   hl,$2F8C
2F86: CD 37 1A    call $1A37
2F89: C3 37 1A    jp   $1A37

2FCE: 3E 01       ld   a,$01
2FD0: 32 15 8A    ld   ($8A15),a
2FD3: 3D          dec  a
2FD4: 32 BF 89    ld   ($89BF),a
2FD7: 3E 62       ld   a,$62
2FD9: 32 A2 88    ld   ($88A2),a
2FDC: 32 A3 88    ld   ($88A3),a
2FDF: 21 BE 89    ld   hl,$89BE
2FE2: 22 B2 89    ld   ($89B2),hl
2FE5: CD B9 04    call $04B9
2FE8: 0E 3C       ld   c,$3C
2FEA: CD 3E 31    call $313E
2FED: AF          xor  a
2FEE: 32 E0 83    ld   ($83E0),a
2FF1: 32 52 80    ld   ($8052),a
2FF4: CD FB 2C    call $2CFB
2FF7: 21 B9 89    ld   hl,$89B9
2FFA: 34          inc  (hl)
2FFB: C9          ret
2FFC: 5E          ld   e,(hl)
2FFD: 23          inc  hl
2FFE: 56          ld   d,(hl)
2FFF: 23          inc  hl
3000: 46          ld   b,(hl)
3001: 23          inc  hl
3002: 7E          ld   a,(hl)
3003: 12          ld   (de),a
3004: 23          inc  hl
3005: 13          inc  de
3006: 0E 10       ld   c,$10
3008: CD 3E 31    call $313E
300B: 10 F5       djnz $3002
300D: C9          ret
300E: 06 02       ld   b,$02
3010: 7E          ld   a,(hl)
3011: 12          ld   (de),a
3012: 23          inc  hl
3013: CB DA       set  3,d
3015: ED A0       ldi
3017: CB 9A       res  3,d
3019: 03          inc  bc
301A: 10 F4       djnz $3010
301C: C9          ret
301D: 3A C0 8B    ld   a,($8BC0)
3020: A7          and  a
3021: C8          ret  z
3022: 3A AE 83    ld   a,($83AE)
3025: A7          and  a
3026: C8          ret  z
3027: AF          xor  a
3028: 32 E0 83    ld   ($83E0),a
302B: 32 52 80    ld   ($8052),a
302E: 32 15 8A    ld   ($8A15),a
3031: 32 D4 8B    ld   ($8BD4),a
3034: CD 15 08    call $0815
3037: ED 7B B7 89 ld   sp,(stack_save_89b7)
303B: C9          ret					; jumps to $0460 when credit is inserted

303C: E5          push hl
303D: 21 7C 80    ld   hl,$807C
3040: 7E          ld   a,(hl)
3041: BE          cp   (hl)
3042: 28 FD       jr   z,$3041
3044: E1          pop  hl
3045: C9          ret

30AC: 3E 41       ld   a,$41
30AE: CD 67 0B    call $0B67
30B1: AF          xor  a
30B2: 32 D4 8B    ld   ($8BD4),a
30B5: 0E 50       ld   c,$50
30B7: CD 3E 31    call $313E
30BA: 21 46 30    ld   hl,$3046
30BD: CD C1 0B    call $0BC1
30C0: 0E 50       ld   c,$50
30C2: CD 3E 31    call $313E
30C5: CD C1 0B    call $0BC1
30C8: 0E 50       ld   c,$50
30CA: CD 3E 31    call $313E
30CD: 3A E5 83    ld   a,($83E5)
30D0: 3D          dec  a
30D1: 20 11       jr   nz,$30E4
30D3: 11 81 30    ld   de,$3081
30D6: 06 01       ld   b,$01
30D8: CD 5C 16    call $165C
30DB: 21 69 30    ld   hl,$3069
30DE: CD C1 0B    call $0BC1
30E1: C3 29 31    jp   $3129
30E4: 3D          dec  a
30E5: 20 1F       jr   nz,$3106
30E7: 21 71 30    ld   hl,$3071
30EA: 11 82 30    ld   de,$3082
30ED: 3A DC 89    ld   a,($89DC)
30F0: 3D          dec  a
30F1: 28 06       jr   z,$30F9
30F3: 21 79 30    ld   hl,$3079
30F6: 11 83 30    ld   de,$3083
30F9: 06 01       ld   b,$01
30FB: E5          push hl
30FC: CD 5C 16    call $165C
30FF: E1          pop  hl
3100: CD C1 0B    call $0BC1
3103: C3 29 31    jp   $3129
3106: 21 62 30    ld   hl,$3062
3109: CD C1 0B    call $0BC1
310C: 3A DC 89    ld   a,($89DC)
310F: 3D          dec  a
3110: 21 98 30    ld   hl,$3098
3113: CF          rst  $08
3114: 11 2A 86    ld   de,$862A
3117: ED A0       ldi
3119: ED A0       ldi
311B: 3A DC 89    ld   a,($89DC)
311E: 3D          dec  a
311F: 21 84 30    ld   hl,$3084
3122: CF          rst  $08
3123: EB          ex   de,hl
3124: 06 02       ld   b,$02
3126: CD 5C 16    call $165C
3129: 3A DC 89    ld   a,($89DC)
312C: FE 0A       cp   $0A
312E: 28 01       jr   z,$3131
3130: 3C          inc  a
3131: 32 DC 89    ld   ($89DC),a
3134: 0E 50       ld   c,$50
3136: CD 3E 31    call $313E
3139: CD 49 0D    call $0D49
313C: 0E 78       ld   c,$78
313E: 3A 7C 80    ld   a,($807C)
3141: 81          add  a,c
3142: 4F          ld   c,a
3143: CD 1D 30    call $301D
3146: 3A 7C 80    ld   a,($807C)
3149: B9          cp   c
314A: 20 F7       jr   nz,$3143
314C: C9          ret
314D: 21 E0 8B    ld   hl,$8BE0
3150: 11 58 88    ld   de,$8858
3153: 7E          ld   a,(hl)
3154: E6 0F       and  $0F
3156: 12          ld   (de),a
3157: 2C          inc  l
3158: 1C          inc  e
3159: 01 03 00    ld   bc,$0003
315C: ED B0       ldir
315E: 11 5C 88    ld   de,$885C
3161: CD 3C 33    call flags_changing_333c
3164: D0          ret  nc
3165: 11 F0 8B    ld   de,$8BF0
3168: CD 3C 33    call flags_changing_333c
316B: 3E 05       ld   a,$05
316D: 30 20       jr   nc,$318F
316F: 11 EC 8B    ld   de,$8BEC
3172: CD 3C 33    call flags_changing_333c
3175: 3E 04       ld   a,$04
3177: 30 16       jr   nc,$318F
3179: 11 E8 8B    ld   de,$8BE8
317C: CD 3C 33    call flags_changing_333c
317F: 3E 03       ld   a,$03
3181: 30 0C       jr   nc,$318F
3183: 11 E4 8B    ld   de,$8BE4
3186: CD 3C 33    call flags_changing_333c
3189: 3E 02       ld   a,$02
318B: 30 02       jr   nc,$318F
318D: 3E 01       ld   a,$01
318F: 32 C4 8B    ld   ($8BC4),a
3192: 21 EB 32    ld   hl,jump_table_32eb
3195: 3D          dec  a
3196: E7          rst  $20		; [nb_entries=5]
3197: 3A C4 8B    ld   a,($8BC4)
319A: 21 CD 34    ld   hl,jump_table_34cd
319D: 3D          dec  a
319E: E7          rst  $20		; [nb_entries=5]
319F: 3A C4 8B    ld   a,($8BC4)
31A2: 21 E6 32    ld   hl,$32E6
31A5: 3D          dec  a
31A6: D7          rst  $10   ; add_a_to_hl
31A7: 7E          ld   a,(hl)
31A8: 21 D0 8B    ld   hl,$8BD0
31AB: 11 D3 8B    ld   de,$8BD3
31AE: A7          and  a
31AF: 28 05       jr   z,$31B6
31B1: 4F          ld   c,a
31B2: 06 00       ld   b,$00
31B4: ED B8       lddr
31B6: 06 03       ld   b,$03
31B8: 3E 24       ld   a,$24
31BA: 22 5E 83    ld   ($835E),hl
31BD: 2C          inc  l
31BE: 77          ld   (hl),a
31BF: 10 FC       djnz $31BD
31C1: 3E 53       ld   a,$53
31C3: 32 C3 8B    ld   ($8BC3),a
31C6: 3E 41       ld   a,$41
31C8: CD 67 0B    call $0B67
31CB: 21 FE 33    ld   hl,$33FE
31CE: CD 37 1A    call $1A37
31D1: CD C1 0B    call $0BC1
31D4: 11 45 85    ld   de,$8545
31D7: 21 58 88    ld   hl,$8858
31DA: CD C5 33    call $33C5
31DD: 21 53 85    ld   hl,$8553
31E0: 36 0A       ld   (hl),$0A
31E2: 23          inc  hl
31E3: 36 0A       ld   (hl),$0A
31E5: 23          inc  hl
31E6: 36 0A       ld   (hl),$0A
31E8: CD 4A 33    call $334A
31EB: CD C3 32    call $32C3
31EE: 0E 5A       ld   c,$5A
31F0: CD 3E 31    call $313E
31F3: 21 20 1C    ld   hl,$1C20
31F6: 22 55 80    ld   ($8055),hl
31F9: AF          xor  a
31FA: 32 7A 83    ld   ($837A),a
31FD: CD 4A 33    call $334A
3200: CD C3 32    call $32C3
3203: 3A 7C 80    ld   a,($807C)
3206: 4F          ld   c,a
3207: CD 95 34    call $3495
320A: 3A 7C 80    ld   a,($807C)
320D: B9          cp   c
320E: 28 F7       jr   z,$3207
3210: 4F          ld   c,a
3211: E6 0F       and  $0F
3213: CC 85 32    call z,$3285
3216: 2A 55 80    ld   hl,($8055)
3219: 2B          dec  hl
321A: 22 55 80    ld   ($8055),hl
321D: 7C          ld   a,h
321E: B5          or   l
321F: C8          ret  z
3220: 2A B2 89    ld   hl,($89B2)
3223: CB 66       bit  4,(hl)
3225: CA 90 32    jp   z,$3290
3228: 7E          ld   a,(hl)
3229: E6 0F       and  $0F
322B: 21 58 88    ld   hl,$8858
322E: 11 59 88    ld   de,$8859
3231: BE          cp   (hl)
3232: 28 04       jr   z,$3238
3234: 77          ld   (hl),a
3235: 3E FD       ld   a,$FD
3237: 12          ld   (de),a
3238: 1A          ld   a,(de)
3239: 3C          inc  a
323A: 12          ld   (de),a
323B: E6 0F       and  $0F
323D: 20 C8       jr   nz,$3207
323F: 7E          ld   a,(hl)
3240: FE 02       cp   $02
3242: 28 1E       jr   z,$3262
3244: FE 06       cp   $06
3246: 20 BF       jr   nz,$3207
3248: AF          xor  a
3249: 32 7A 83    ld   ($837A),a
324C: 3A C3 8B    ld   a,($8BC3)
324F: 6F          ld   l,a
3250: 26 85       ld   h,$85
3252: 7E          ld   a,(hl)
3253: 3D          dec  a
3254: FE 09       cp   $09
3256: CC 7C 32    call z,$327C
3259: FE 33       cp   $33
325B: CC 7F 32    call z,$327F
325E: 77          ld   (hl),a
325F: C3 07 32    jp   $3207
3262: 3A C3 8B    ld   a,($8BC3)
3265: 6F          ld   l,a
3266: 26 85       ld   h,$85
3268: AF          xor  a
3269: 32 7A 83    ld   ($837A),a
326C: 7E          ld   a,(hl)
326D: 3C          inc  a
326E: FE 35       cp   $35
3270: CC 82 32    call z,$3282
3273: FE 25       cp   $25
3275: CC 7C 32    call z,$327C
3278: 77          ld   (hl),a
3279: C3 07 32    jp   $3207
327C: 3E 34       ld   a,$34
327E: C9          ret
327F: 3E 24       ld   a,$24
3281: C9          ret
3282: 3E 0A       ld   a,$0A
3284: C9          ret
3285: 3A C3 8B    ld   a,($8BC3)
3288: 6F          ld   l,a
3289: 26 8D       ld   h,$8D
328B: 7E          ld   a,(hl)
328C: EE 1C       xor  $1C
328E: 77          ld   (hl),a
328F: C9          ret
3290: 3A C3 8B    ld   a,($8BC3)
3293: 6F          ld   l,a
3294: 26 8D       ld   h,$8D
3296: 36 41       ld   (hl),$41
3298: 26 85       ld   h,$85
329A: 4E          ld   c,(hl)
329B: AF          xor  a
329C: 32 7A 83    ld   ($837A),a
329F: 2A 5E 83    ld   hl,($835E)
32A2: 23          inc  hl
32A3: 22 5E 83    ld   ($835E),hl
32A6: 71          ld   (hl),c
32A7: 21 C3 8B    ld   hl,$8BC3
32AA: 34          inc  (hl)
32AB: 7E          ld   a,(hl)
32AC: FE 56       cp   $56
32AE: C2 FD 31    jp   nz,$31FD
32B1: CD 4A 33    call $334A
32B4: CD C3 32    call $32C3
32B7: 3E 4C       ld   a,$4C
32B9: 32 7C 80    ld   ($807C),a
32BC: 3A 7C 80    ld   a,($807C)
32BF: A7          and  a
32C0: 20 FA       jr   nz,$32BC
32C2: C9          ret
32C3: 3A C4 8B    ld   a,($8BC4)
32C6: 21 DC 32    ld   hl,$32DC
32C9: 3D          dec  a
32CA: CF          rst  $08
32CB: 7E          ld   a,(hl)
32CC: 23          inc  hl
32CD: 66          ld   h,(hl)
32CE: 6F          ld   l,a
32CF: 06 20       ld   b,$20
32D1: 3E 4E       ld   a,$4E
32D3: BE          cp   (hl)
32D4: 20 02       jr   nz,$32D8
32D6: 36 50       ld   (hl),$50
32D8: 23          inc  hl
32D9: 10 F8       djnz $32D3
32DB: C9          ret

jump_table_32eb:
	.word	$32F5  
	.word	$32F9  
	.word	$32FD  
	.word	$3313  
	.word	$331E 


32F5: 3E 0C       ld   a,$0C
32F7: 18 06       jr   $32FF
32F9: 3E 08       ld   a,$08
32FB: 18 02       jr   $32FF
32FD: 3E 04       ld   a,$04
32FF: 21 F3 8B    ld   hl,$8BF3
3302: 11 5F 88    ld   de,$885F
3305: 01 04 00    ld   bc,$0004
3308: ED B8       lddr
330A: 11 F3 8B    ld   de,$8BF3
330D: 4F          ld   c,a
330E: ED B8       lddr
3310: C3 1E 33    jp   $331E
3313: 11 5F 88    ld   de,$885F
3316: 21 F3 8B    ld   hl,$8BF3
3319: 01 04 00    ld   bc,$0004
331C: ED B8       lddr
331E: 3A C4 8B    ld   a,($8BC4)
3321: 3D          dec  a
3322: 21 32 33    ld   hl,$3332
3325: CF          rst  $08
3326: 5E          ld   e,(hl)
3327: 23          inc  hl
3328: 56          ld   d,(hl)
3329: 21 58 88    ld   hl,$8858
332C: 01 04 00    ld   bc,$0004
332F: ED B0       ldir
3331: C9          ret

flags_changing_333c:
333C: 21 58 88    ld   hl,$8858
333F: 06 04       ld   b,$04
3341: 1A          ld   a,(de)
3342: BE          cp   (hl)
3343: C0          ret  nz
3344: 2C          inc  l
3345: 1C          inc  e
3346: 10 F9       djnz $3341
3348: AF          xor  a
3349: C9          ret
334A: 21 DC 33    ld   hl,$33DC
334D: CD 37 1A    call $1A37
3350: CD C1 0B    call $0BC1
3353: 06 05       ld   b,$05
3355: CD 71 33    call $3371
3358: 10 FB       djnz $3355
335A: 21 20 8E    ld   hl,$8E20
335D: 7E          ld   a,(hl)
335E: FE 62       cp   $62
3360: 28 04       jr   z,$3366
3362: FE 41       cp   $41
3364: 20 02       jr   nz,$3368
3366: 36 4E       ld   (hl),$4E
3368: 23          inc  hl
3369: 7C          ld   a,h
336A: FE 90       cp   $90
336C: 20 EF       jr   nz,$335D
336E: C3 48 0A    jp   $0A48
3371: 78          ld   a,b
3372: 3D          dec  a
3373: 87          add  a,a
3374: 87          add  a,a
3375: 87          add  a,a
3376: 21 29 34    ld   hl,$3429
3379: D7          rst  $10   ; add_a_to_hl
337A: 5E          ld   e,(hl)
337B: 23          inc  hl
337C: 56          ld   d,(hl)
337D: 23          inc  hl
337E: 7E          ld   a,(hl)
337F: 23          inc  hl
3380: 4E          ld   c,(hl)
3381: 23          inc  hl
3382: E5          push hl
3383: 6F          ld   l,a
3384: 61          ld   h,c
3385: 7E          ld   a,(hl)
3386: E6 0F       and  $0F
3388: 28 01       jr   z,$338B
338A: 12          ld   (de),a
338B: 13          inc  de
338C: 2B          dec  hl
338D: AF          xor  a
338E: ED 6F       rld  (hl)
3390: 12          ld   (de),a
3391: A7          and  a
3392: CC BA 33    call z,$33BA
3395: 13          inc  de
3396: ED 6F       rld  (hl)
3398: 12          ld   (de),a
3399: 13          inc  de
339A: ED 6F       rld  (hl)
339C: E1          pop  hl
339D: 1C          inc  e
339E: 7E          ld   a,(hl)
339F: 23          inc  hl
33A0: 4E          ld   c,(hl)
33A1: 23          inc  hl
33A2: E5          push hl
33A3: 61          ld   h,c
33A4: 6F          ld   l,a
33A5: CD C5 33    call $33C5
33A8: 7B          ld   a,e
33A9: C6 06       add  a,$06
33AB: 5F          ld   e,a
33AC: E1          pop  hl
33AD: 0E 04       ld   c,$04
33AF: 7E          ld   a,(hl)
33B0: 23          inc  hl
33B1: 66          ld   h,(hl)
33B2: 6F          ld   l,a
33B3: ED A0       ldi
33B5: ED A0       ldi
33B7: ED A0       ldi
33B9: C9          ret
33BA: 23          inc  hl
33BB: B6          or   (hl)
33BC: 2B          dec  hl
33BD: 3E 00       ld   a,$00
33BF: C0          ret  nz
33C0: 3E 24       ld   a,$24
33C2: 12          ld   (de),a
33C3: AF          xor  a
33C4: C9          ret
33C5: 7E          ld   a,(hl)
33C6: 0E 40       ld   c,$40
33C8: CD E0 0E    call $0EE0
33CB: 2C          inc  l
33CC: 7E          ld   a,(hl)
33CD: CD CC 0E    call $0ECC
33D0: 2C          inc  l
33D1: 7E          ld   a,(hl)
33D2: CD CC 0E    call $0ECC
33D5: 2C          inc  l
33D6: 0E 62       ld   c,$62
33D8: 7E          ld   a,(hl)
33D9: C3 CC 0E    jp   $0ECC


3451: 3E 41       ld   a,$41
3453: CD 67 0B    call $0B67
3456: 21 75 34    ld   hl,$3475
3459: CD C1 0B    call $0BC1
345C: CD C1 0B    call $0BC1
345F: CD 4A 33    call $334A
3462: 3E 01       ld   a,$01
3464: 32 7C 80    ld   ($807C),a
3467: CD 1D 30    call $301D
346A: 3A 7C 80    ld   a,($807C)
346D: A7          and  a
346E: 20 F7       jr   nz,$3467
3470: 21 B9 89    ld   hl,$89B9
3473: 34          inc  (hl)
3474: C9          ret

3495: 3A C0 8B    ld   a,($8BC0)
3498: 47          ld   b,a
3499: 3A E1 83    ld   a,($83E1)
349C: 90          sub  b
349D: 38 08       jr   c,$34A7
349F: 3A 7A 83    ld   a,($837A)
34A2: FE 14       cp   $14
34A4: 30 12       jr   nc,$34B8
34A6: C9          ret
34A7: 3A E1 83    ld   a,($83E1)
34AA: 4F          ld   c,a
34AB: 78          ld   a,b
34AC: 32 E1 83    ld   ($83E1),a
34AF: 91          sub  c
34B0: 27          daa
34B1: 47          ld   b,a
34B2: 21 0D 8A    ld   hl,$8A0D
34B5: 34          inc  (hl)
34B6: 10 FD       djnz $34B5
34B8: E1          pop  hl
34B9: 26 85       ld   h,$85
34BB: 3A C3 8B    ld   a,($8BC3)
34BE: 6F          ld   l,a
34BF: ED 5B 5E 83 ld   de,($835E)
34C3: 7E          ld   a,(hl)
34C4: 13          inc  de
34C5: 12          ld   (de),a
34C6: 2C          inc  l
34C7: 7D          ld   a,l
34C8: FE 56       cp   $56
34CA: 20 F7       jr   nz,$34C3
34CC: C9          ret

jump_table_34cd:
	.word	$34D7 
	.word	$34DC
	.word	$34E1
	.word	$34E6 
	.word	$34F9

34D7: 01 08 00    ld   bc,$0008
34DA: 18 0D       jr   $34E9

34DC: 01 06 00    ld   bc,$0006
34DF: 18 08       jr   $34E9

34E1: 01 04 00    ld   bc,$0004
34E4: 18 03       jr   $34E9

34E6: 01 02 00    ld   bc,$0002
34E9: 21 D5 81    ld   hl,$81D5
34EC: 11 D7 81    ld   de,$81D7
34EF: ED B8       lddr
34F1: 21 CB 81    ld   hl,$81CB
34F4: ED A8       ldd
34F6: ED A8       ldd
34F8: C9          ret

34F9: 11 D7 81    ld   de,$81D7
34FC: 18 F3       jr   $34F1
34FE: 21 BF 89    ld   hl,$89BF
3501: 7E          ld   a,(hl)
3502: 35          dec  (hl)
3503: A7          and  a
3504: 20 11       jr   nz,$3517
3506: 77          ld   (hl),a
3507: 11 E8 80    ld   de,$80E8
350A: 06 08       ld   b,$08
350C: 1A          ld   a,(de)
350D: 3C          inc  a
350E: 20 0F       jr   nz,$351F
3510: 13          inc  de
3511: 13          inc  de
3512: 10 F8       djnz $350C
3514: C3 B9 35    jp   $35B9
3517: 2A B2 89    ld   hl,($89B2)
351A: CB E6       set  4,(hl)
351C: C3 D9 35    jp   $35D9
351F: 13          inc  de
3520: 4F          ld   c,a
3521: 1A          ld   a,(de)
3522: 3C          inc  a
3523: 6F          ld   l,a
3524: 26 00       ld   h,$00
3526: 29          add  hl,hl
3527: 29          add  hl,hl
3528: 29          add  hl,hl
3529: 29          add  hl,hl
352A: 2B          dec  hl
352B: 29          add  hl,hl
352C: ED 5B C8 80 ld   de,($80C8)
3530: A7          and  a
3531: ED 52       sbc  hl,de
3533: EB          ex   de,hl
3534: 69          ld   l,c
3535: 26 00       ld   h,$00
3537: 29          add  hl,hl
3538: 29          add  hl,hl
3539: 29          add  hl,hl
353A: 29          add  hl,hl
353B: 29          add  hl,hl
353C: ED 4B CA 80 ld   bc,($80CA)
3540: A7          and  a
3541: ED 42       sbc  hl,bc
3543: 44          ld   b,h
3544: CB 7C       bit  7,h
3546: 28 01       jr   z,$3549
3548: DF          rst  $18
3549: 25          dec  h
354A: 3E 6A       ld   a,$6A
354C: D7          rst  $10   ; add_a_to_hl
354D: CB 52       bit  2,d
354F: 20 05       jr   nz,$3556
3551: A7          and  a
3552: ED 52       sbc  hl,de
3554: 18 05       jr   $355B
3556: 7A          ld   a,d
3557: F6 FC       or   $FC
3559: 57          ld   d,a
355A: 19          add  hl,de
355B: CB 7C       bit  7,h
355D: 2A B2 89    ld   hl,($89B2)
3560: 28 2B       jr   z,$358D
3562: 13          inc  de
3563: 13          inc  de
3564: 13          inc  de
3565: 7A          ld   a,d
3566: A7          and  a
3567: 20 05       jr   nz,$356E
3569: 7B          ld   a,e
356A: FE 07       cp   $07
356C: 38 0C       jr   c,$357A
356E: 36 32       ld   (hl),$32
3570: CB 7A       bit  7,d
3572: CA B9 35    jp   z,$35B9
3575: 36 36       ld   (hl),$36
3577: C3 B9 35    jp   $35B9
357A: 36 00       ld   (hl),$00
357C: CB 78       bit  7,b
357E: 20 02       jr   nz,$3582
3580: 36 04       ld   (hl),$04
3582: 3A 7C 80    ld   a,($807C)
3585: E6 0F       and  $0F
3587: 28 3F       jr   z,$35C8
3589: CB E6       set  4,(hl)
358B: 18 3B       jr   $35C8
358D: 13          inc  de
358E: 13          inc  de
358F: 13          inc  de
3590: 7A          ld   a,d
3591: CB 78       bit  7,b
3593: 28 13       jr   z,$35A8
3595: 36 30       ld   (hl),$30
3597: A7          and  a
3598: 20 05       jr   nz,$359F
359A: 7B          ld   a,e
359B: FE 07       cp   $07
359D: 38 1A       jr   c,$35B9
359F: 34          inc  (hl)
35A0: CB 7A       bit  7,d
35A2: 28 15       jr   z,$35B9
35A4: 36 37       ld   (hl),$37
35A6: 18 11       jr   $35B9
35A8: 36 34       ld   (hl),$34
35AA: A7          and  a
35AB: 20 05       jr   nz,$35B2
35AD: 7B          ld   a,e
35AE: FE 07       cp   $07
35B0: 38 07       jr   c,$35B9
35B2: 35          dec  (hl)
35B3: CB 7A       bit  7,d
35B5: 28 02       jr   z,$35B9
35B7: 36 35       ld   (hl),$35
35B9: 2A B2 89    ld   hl,($89B2)
35BC: 3A 7C 80    ld   a,($807C)
35BF: E6 1F       and  $1F
35C1: 20 05       jr   nz,$35C8
35C3: EF          rst  $28
35C4: E6 10       and  $10
35C6: AE          xor  (hl)
35C7: 77          ld   (hl),a
35C8: 3A 1A 82    ld   a,($821A)
35CB: A7          and  a
35CC: 28 0B       jr   z,$35D9
35CE: 3E 03       ld   a,$03
35D0: 86          add  a,(hl)
35D1: E6 07       and  $07
35D3: 77          ld   (hl),a
35D4: 3E 10       ld   a,$10
35D6: 32 BF 89    ld   ($89BF),a
35D9: 3A 8C 80    ld   a,($808C)
35DC: E6 07       and  $07
35DE: 21 22 36    ld   hl,$3622
35E1: CF          rst  $08
35E2: 7E          ld   a,(hl)
35E3: 23          inc  hl
35E4: 66          ld   h,(hl)
35E5: 6F          ld   l,a
35E6: CD 5A 27    call flags_changing_275a
35E9: C8          ret  z
35EA: 3E 20       ld   a,$20
35EC: 32 BF 89    ld   ($89BF),a
35EF: 3A 8C 80    ld   a,($808C)
35F2: 3C          inc  a
35F3: 15          dec  d
35F4: 28 02       jr   z,$35F8
35F6: 3D          dec  a
35F7: 3D          dec  a
35F8: E6 07       and  $07
35FA: F6 30       or   $30
35FC: 2A B2 89    ld   hl,($89B2)
35FF: 77          ld   (hl),a
3600: E6 07       and  $07
3602: 21 22 36    ld   hl,$3622
3605: CF          rst  $08
3606: 7E          ld   a,(hl)
3607: 23          inc  hl
3608: 66          ld   h,(hl)
3609: 6F          ld   l,a
360A: D5          push de
360B: CD 5A 27    call flags_changing_275a
360E: D1          pop  de
360F: C8          ret  z
3610: 3A 8C 80    ld   a,($808C)
3613: 3C          inc  a
3614: 15          dec  d
3615: 28 02       jr   z,$3619
3617: 3D          dec  a
3618: 3D          dec  a
3619: E6 07       and  $07
361B: F6 10       or   $10
361D: 2A B2 89    ld   hl,($89B2)
3620: 77          ld   (hl),a
3621: C9          ret

rest_of_boot_3632:
3632: F3          di
3633: 3E 34       ld   a,$34
3635: 32 23 68    ld   ($6823),a
3638: 32 00 91    ld   ($9100),a
363B: 06 80       ld   b,$80
363D: 32 30 68    ld   (dummy_6830),a		; write in ????
3640: 3D          dec  a
3641: 20 FA       jr   nz,$363D
3643: 10 F8       djnz $363D
3645: 3D          dec  a
3646: 32 00 70    ld   ($7000),a
3649: 32 00 90    ld   ($9000),a	; not mapped
364C: 3E 10       ld   a,$10
364E: 32 00 71    ld   ($7100),a
3651: 32 00 91    ld   ($9100),a
3654: 32 15 68    ld   ($6815),a
3657: 32 1A 68    ld   ($681A),a
365A: 32 1F 68    ld   ($681F),a
365D: 32 77 98    ld   ($9877),a
3660: 06 0A       ld   b,$0A
3662: D9          exx
3663: 11 00 84    ld   de,$8400
3666: 21 00 00    ld   hl,$0000
3669: 01 00 04    ld   bc,$0400
366C: 7D          ld   a,l
366D: AC          xor  h
366E: 2F          cpl
366F: 87          add  a,a
3670: 87          add  a,a
3671: ED 6A       adc  hl,hl
3673: 7D          ld   a,l
3674: 32 30 68    ld   (dummy_6830),a		; write in ???
3677: 12          ld   (de),a
3678: 13          inc  de
3679: 0B          dec  bc
367A: 78          ld   a,b
367B: B1          or   c
367C: 20 EE       jr   nz,$366C
367E: 11 00 84    ld   de,$8400
3681: 21 00 00    ld   hl,$0000		; pattern
3684: 01 00 04    ld   bc,$0400
; screen test loop
3687: 7D          ld   a,l
3688: AC          xor  h
3689: 2F          cpl
368A: 87          add  a,a
368B: 87          add  a,a
368C: ED 6A       adc  hl,hl
368E: 1A          ld   a,(de)
368F: AD          xor  l
3690: C2 AF 37    jp   nz,$37AF
3693: 13          inc  de
3694: 32 30 68    ld   (dummy_6830),a
3697: 0B          dec  bc
3698: 78          ld   a,b
3699: B1          or   c
369A: 20 EB       jr   nz,$3687
369C: 11 00 84    ld   de,$8400
369F: 21 55 55    ld   hl,$5555		; pattern
36A2: 01 00 04    ld   bc,$0400
36A5: 7D          ld   a,l
36A6: AC          xor  h
36A7: 2F          cpl
36A8: 87          add  a,a
36A9: 87          add  a,a
36AA: ED 6A       adc  hl,hl
36AC: 7D          ld   a,l
36AD: 32 30 68    ld   (dummy_6830),a
36B0: 12          ld   (de),a
36B1: 13          inc  de
36B2: 0B          dec  bc
36B3: 78          ld   a,b
36B4: B1          or   c
36B5: 20 EE       jr   nz,$36A5
36B7: 11 00 84    ld   de,$8400
36BA: 21 55 55    ld   hl,$5555
36BD: 01 00 04    ld   bc,$0400
36C0: 7D          ld   a,l
36C1: AC          xor  h
36C2: 2F          cpl
36C3: 87          add  a,a
36C4: 87          add  a,a
36C5: ED 6A       adc  hl,hl
36C7: 1A          ld   a,(de)
36C8: AD          xor  l
36C9: C2 AF 37    jp   nz,$37AF
36CC: 13          inc  de
36CD: 32 30 68    ld   (dummy_6830),a
36D0: 0B          dec  bc
36D1: 78          ld   a,b
36D2: B1          or   c
36D3: 20 EB       jr   nz,$36C0
36D5: 11 00 84    ld   de,$8400
36D8: 21 AA AA    ld   hl,$AAAA
36DB: 01 00 04    ld   bc,$0400
36DE: 7D          ld   a,l
36DF: AC          xor  h
36E0: 2F          cpl
36E1: 87          add  a,a
36E2: 87          add  a,a
36E3: ED 6A       adc  hl,hl
36E5: 7D          ld   a,l
36E6: 32 30 68    ld   (dummy_6830),a
36E9: 12          ld   (de),a
36EA: 13          inc  de
36EB: 0B          dec  bc
36EC: 78          ld   a,b
36ED: B1          or   c
36EE: 20 EE       jr   nz,$36DE
36F0: 11 00 84    ld   de,$8400
36F3: 21 AA AA    ld   hl,$AAAA
36F6: 01 00 04    ld   bc,$0400
36F9: 7D          ld   a,l
36FA: AC          xor  h
36FB: 2F          cpl
36FC: 87          add  a,a
36FD: 87          add  a,a
36FE: ED 6A       adc  hl,hl
3700: 1A          ld   a,(de)
3701: AD          xor  l
3702: C2 AF 37    jp   nz,$37AF
3705: 13          inc  de
3706: 32 30 68    ld   (dummy_6830),a
3709: 0B          dec  bc
370A: 78          ld   a,b
370B: B1          or   c
370C: 20 EB       jr   nz,$36F9
370E: D9          exx
370F: 05          dec  b
3710: C2 62 36    jp   nz,$3662
end_of_tests_1_3713:
3713: 31 00 88    ld   sp,$8800
3716: 11 00 78    ld   de,$7800
3719: CD 5A 37    call mem_test_375a
371C: 11 00 7C    ld   de,$7C00
371F: CD 5A 37    call mem_test_375a
3722: 11 00 80    ld   de,$8000
3725: CD 5A 37    call mem_test_375a
3728: 31 00 7B    ld   sp,$7B00
372B: 11 00 84    ld   de,$8400
372E: CD 5A 37    call mem_test_375a
3731: 21 E8 89    ld   hl,$89E8
3734: 01 18 00    ld   bc,$0018
3737: 11 00 7C    ld   de,$7C00
373A: ED B0       ldir
373C: 11 00 88    ld   de,$8800
373F: CD 5A 37    call mem_test_375a
3742: 11 00 8C    ld   de,$8C00
3745: CD 5A 37    call mem_test_375a
3748: CD FB 3D    call $3DFB
374B: 21 84 3E    ld   hl,$3E84
374E: 11 64 84    ld   de,$8464
3751: CD 6D 3E    call memcopy_3e6d		; [video_address]
3754: 32 30 68    ld   (dummy_6830),a
3757: C3 F6 37    jp   end_of_self_tests_37f6

mem_test_375a:
375A: 06 1E       ld   b,$1E
375C: 21 00 00    ld   hl,$0000
375F: C5          push bc
3760: CD 67 37    call $3767
3763: C1          pop  bc
3764: 10 F9       djnz $375F
3766: C9          ret

3767: D5          push de
3768: E5          push hl
3769: 01 00 04    ld   bc,$0400
376C: 7D          ld   a,l
376D: AC          xor  h
376E: 2F          cpl
376F: 87          add  a,a
3770: 87          add  a,a
3771: ED 6A       adc  hl,hl
3773: 7D          ld   a,l
3774: 32 30 68    ld   (dummy_6830),a
3777: 12          ld   (de),a
3778: 13          inc  de
3779: 0B          dec  bc
377A: 78          ld   a,b
377B: B1          or   c
377C: 20 EE       jr   nz,$376C
377E: E1          pop  hl
377F: D1          pop  de
3780: D5          push de
3781: 01 00 04    ld   bc,$0400
3784: 7D          ld   a,l
3785: AC          xor  h
3786: 2F          cpl
3787: 87          add  a,a
3788: 87          add  a,a
3789: ED 6A       adc  hl,hl
378B: 1A          ld   a,(de)
378C: AD          xor  l
378D: C2 AF 37    jp   nz,$37AF
3790: 13          inc  de
3791: 32 30 68    ld   (dummy_6830),a
3794: 0B          dec  bc
3795: 78          ld   a,b
3796: B1          or   c
3797: 20 EB       jr   nz,$3784
3799: D1          pop  de
379A: C9          ret

37AF: D9          exx
37B0: 21 00 80    ld   hl,$8000
37B3: 11 01 80    ld   de,$8001
37B6: 01 00 08    ld   bc,$0800
37B9: 36 24       ld   (hl),$24
37BB: ED B0       ldir
37BD: 01 00 08    ld   bc,$0800
37C0: 36 62       ld   (hl),$62
37C2: ED B0       ldir
37C4: D9          exx
37C5: 22 00 78    ld   ($7800),hl
37C8: ED 53 02 78 ld   ($7802),de
37CC: E6 0F       and  $0F
37CE: 20 07       jr   nz,$37D7
37D0: 3E 11       ld   a,$11
37D2: 32 6A 84    ld   ($846A),a
37D5: 18 05       jr   $37DC
37D7: 3E 15       ld   a,$15
37D9: 32 6A 84    ld   ($846A),a
37DC: 7A          ld   a,d
37DD: D6 74       sub  $74
37DF: 1F          rra
37E0: 1F          rra
37E1: E6 07       and  $07
37E3: 32 69 84    ld   ($8469),a
37E6: 21 64 84    ld   hl,$8464
37E9: 36 1B       ld   (hl),$1B
37EB: 23          inc  hl
37EC: 36 0A       ld   (hl),$0A
37EE: 23          inc  hl
37EF: 36 16       ld   (hl),$16
37F1: 32 30 68    ld   (dummy_6830),a
37F4: 18 FE       jr   $37F4

end_of_self_tests_37f6:
37F6: 21 00 00    ld   hl,$0000
37F9: 3A FC 3F    ld   a,($3FFC)
37FC: 4F          ld   c,a
37FD: CD 8C 3E    call $3E8C
3800: 3A FD 3F    ld   a,($3FFD)
3803: 4F          ld   c,a
3804: CD 8C 3E    call $3E8C
3807: 3A FE 3F    ld   a,($3FFE)
380A: 4F          ld   c,a
380B: CD 8C 3E    call $3E8C
380E: 3A FF 3F    ld   a,($3FFF)
3811: 4F          ld   c,a
3812: CD 8C 3E    call $3E8C
3815: 32 30 68    ld   (dummy_6830),a
3818: AF          xor  a
3819: 32 00 8C    ld   ($8C00),a
381C: 32 01 8C    ld   ($8C01),a
381F: 21 25 68    ld   hl,$6825
3822: 06 03       ld   b,$03
3824: 3C          inc  a
3825: 77          ld   (hl),a
3826: 23          inc  hl
3827: 10 FC       djnz $3825
3829: 3E FF       ld   a,$FF
382B: 32 E0 83    ld   ($83E0),a
382E: 32 E1 83    ld   ($83E1),a
3831: 3E 01       ld   a,$01
3833: 32 22 68    ld   ($6822),a
3836: 32 23 68    ld   ($6823),a
3839: 32 77 98    ld   ($9877),a
383C: 32 30 68    ld   (dummy_6830),a
383F: 3A 00 8C    ld   a,($8C00)
3842: A7          and  a
3843: 28 FA       jr   z,$383F
3845: 3C          inc  a
3846: C2 A3 3E    jp   nz,$3EA3
3849: 3A 01 8C    ld   a,($8C01)
384C: A7          and  a
384D: 28 FA       jr   z,$3849
384F: 3C          inc  a
3850: C2 A3 3E    jp   nz,$3EA3
3853: 11 A4 84    ld   de,$84A4
3856: 21 DE 3E    ld   hl,$3EDE
3859: CD 6D 3E    call memcopy_3e6d
385C: AF          xor  a
385D: 32 7C 80    ld   ($807C),a
3860: 32 00 8C    ld   ($8C00),a
3863: 32 01 8C    ld   ($8C01),a
3866: 32 30 68    ld   (dummy_6830),a
3869: 3A 7C 80    ld   a,($807C)
386C: FE 0C       cp   $0C
386E: CA 32 36    jp   z,rest_of_boot_3632
3871: FE 04       cp   $04
3873: 20 F4       jr   nz,$3869
3875: 32 30 68    ld   (dummy_6830),a
3878: 21 39 3F    ld   hl,$3F39
387B: 11 00 78    ld   de,$7800
387E: 01 18 00    ld   bc,$0018
3881: ED B0       ldir
3883: 3A 00 71    ld   a,($7100)
3886: FE 10       cp   $10
3888: 20 F9       jr   nz,$3883
388A: 21 B8 39    ld   hl,$39B8
388D: AF          xor  a
388E: 32 00 70    ld   ($7000),a
3891: 0E 11       ld   c,$11
3893: 3E C8       ld   a,$C8
3895: F7          rst  $30
3896: 21 C9 39    ld   hl,$39C9
3899: 3E 61       ld   a,$61
389B: 0E 01       ld   c,$01
389D: F7          rst  $30
389E: ED 56       im   1
38A0: 21 20 68    ld   hl,$6820
38A3: 36 00       ld   (hl),$00
38A5: 36 01       ld   (hl),$01
38A7: CD B5 00    call $00B5
38AA: CD 6B 3A    call $3A6B
38AD: FB          ei
38AE: 3A 00 80    ld   a,($8000)
38B1: A7          and  a
38B2: C4 8D 3D    call nz,$3D8D
38B5: 3A E1 83    ld   a,($83E1)
38B8: 3C          inc  a
38B9: 28 F3       jr   z,$38AE
38BB: F3          di
38BC: CD FB 3D    call $3DFB
38BF: 3A 20 78    ld   a,($7820)
38C2: 32 BB 89    ld   ($89BB),a
38C5: 3A 21 78    ld   a,($7821)
38C8: 32 AB 89    ld   ($89AB),a
38CB: 32 30 68    ld   (dummy_6830),a
38CE: 3A 22 78    ld   a,($7822)
38D1: 32 1B 82    ld   ($821B),a
38D4: 3A 23 78    ld   a,($7823)
38D7: 32 1C 82    ld   ($821C),a
38DA: 3A 24 78    ld   a,($7824)
38DD: 32 1D 82    ld   ($821D),a
38E0: 21 00 7C    ld   hl,$7C00
38E3: 11 E8 89    ld   de,$89E8
38E6: 01 18 00    ld   bc,$0018
38E9: ED B0       ldir
38EB: 31 40 80    ld   sp,$8040
38EE: 21 08 78    ld   hl,$7808
38F1: 0E 05       ld   c,$05
38F3: 3E 84       ld   a,$84
38F5: F7          rst  $30
38F6: 01 00 20    ld   bc,$2000
38F9: 32 30 68    ld   (dummy_6830),a
38FC: 0D          dec  c
38FD: 20 FA       jr   nz,$38F9
38FF: 10 F8       djnz $38F9
3901: 21 10 78    ld   hl,$7810
3904: 0E 05       ld   c,$05
3906: 3E 84       ld   a,$84
3908: F7          rst  $30
3909: 01 00 40    ld   bc,$4000
390C: 32 30 68    ld   (dummy_6830),a
390F: 0D          dec  c
3910: 20 FA       jr   nz,$390C
3912: 10 F8       djnz $390C
3914: 21 54 39    ld   hl,$3954
3917: 0E 05       ld   c,$05
3919: 3E 84       ld   a,$84
391B: F7          rst  $30
391C: 32 30 68    ld   (dummy_6830),a
391F: 3A 00 71    ld   a,($7100)
3922: FE 10       cp   $10
3924: 20 F6       jr   nz,$391C
3926: 21 00 78    ld   hl,$7800
3929: 0E 08       ld   c,$08
392B: 3E A1       ld   a,$A1
392D: F7          rst  $30
392E: 21 00 70    ld   hl,$7000
3931: 11 B0 8C    ld   de,$8CB0
3934: 01 03 00    ld   bc,$0003
3937: 3E 91       ld   a,$91
3939: CD D2 0B    call $0BD2
393C: 3A 00 71    ld   a,($7100)
393F: FE 10       cp   $10
3941: 20 F9       jr   nz,$393C
3943: 3A B0 8C    ld   a,($8CB0)
3946: FE A0       cp   $A0
3948: 28 03       jr   z,$394D
394A: A7          and  a
394B: 20 D9       jr   nz,$3926
394D: AF          xor  a
394E: 32 00 78    ld   ($7800),a
3951: C3 25 01    jp   $0125

3959: E5          push hl
395A: C5          push bc
395B: CD 70 39    call $3970
395E: AF          xor  a
395F: 32 7A 83    ld   ($837A),a
3962: C1          pop  bc
3963: E1          pop  hl
3964: C9          ret
3965: 21 E4 86    ld   hl,$86E4
3968: 06 18       ld   b,$18
396A: 36 24       ld   (hl),$24
396C: 23          inc  hl
396D: 10 FB       djnz $396A
396F: C9          ret
3970: 21 02 7C    ld   hl,$7C02
3973: 11 E4 86    ld   de,$86E4
3976: 0E 02       ld   c,$02
3978: 06 01       ld   b,$01
397A: CD 94 39    call $3994
397D: 21 0C 7C    ld   hl,$7C0C
3980: 06 04       ld   b,$04
3982: CD 97 39    call $3997
3985: 1B          dec  de
3986: 21 11 7C    ld   hl,$7C11
3989: 01 04 02    ld   bc,$0204
398C: CD 94 39    call $3994
398F: 21 06 7C    ld   hl,$7C06
3992: 06 01       ld   b,$01
3994: CD A7 39    call $39A7
3997: CD 9D 39    call $399D
399A: 10 FB       djnz $3997
399C: C9          ret
399D: 3E 99       ld   a,$99
399F: 96          sub  (hl)
39A0: 1F          rra
39A1: 1F          rra
39A2: 1F          rra
39A3: 1F          rra
39A4: CD AB 39    call $39AB
39A7: 3E 99       ld   a,$99
39A9: 96          sub  (hl)
39AA: 23          inc  hl
39AB: E6 0F       and  $0F
39AD: 12          ld   (de),a
39AE: 13          inc  de
39AF: 0D          dec  c
39B0: C0          ret  nz
39B1: 3E 34       ld   a,$34
39B3: 0E 04       ld   c,$04
39B5: 12          ld   (de),a
39B6: 13          inc  de
39B7: C9          ret

39CA: 21 0A 88    ld   hl,$880A
39CD: 11 0B 88    ld   de,$880B
39D0: 01 07 00    ld   bc,$0007
39D3: ED B8       lddr
39D5: 3A C0 8B    ld   a,($8BC0)
39D8: CB 7F       bit  7,a
39DA: C2 28 3F    jp   nz,$3F28
39DD: 21 04 88    ld   hl,$8804
39E0: 77          ld   (hl),a
39E1: 23          inc  hl
39E2: B6          or   (hl)
39E3: 2F          cpl
39E4: 23          inc  hl
39E5: A6          and  (hl)
39E6: 23          inc  hl
39E7: A6          and  (hl)
39E8: 57          ld   d,a
39E9: 77          ld   (hl),a
39EA: 23          inc  hl
39EB: 3A C1 8B    ld   a,($8BC1)
39EE: 77          ld   (hl),a
39EF: 23          inc  hl
39F0: B6          or   (hl)
39F1: 23          inc  hl
39F2: 2F          cpl
39F3: A6          and  (hl)
39F4: 23          inc  hl
39F5: A6          and  (hl)
39F6: 77          ld   (hl),a
39F7: 5F          ld   e,a
39F8: EB          ex   de,hl
39F9: 3A 00 80    ld   a,($8000)
39FC: 3D          dec  a
39FD: C8          ret  z
39FE: 06 0F       ld   b,$0F
3A00: 29          add  hl,hl
3A01: 29          add  hl,hl
3A02: 38 05       jr   c,$3A09
3A04: 10 FB       djnz $3A01
3A06: C3 43 3A    jp   $3A43
3A09: 78          ld   a,b
3A0A: FE 0F       cp   $0F
3A0C: CC 59 39    call z,$3959
3A0F: 21 08 8A    ld   hl,$8A08
3A12: 11 09 8A    ld   de,$8A09
3A15: 01 14 00    ld   bc,$0014
3A18: 36 00       ld   (hl),$00
3A1A: ED B0       ldir
3A1C: 21 28 8A    ld   hl,$8A28
3A1F: 11 29 8A    ld   de,$8A29
3A22: 0E 14       ld   c,$14
3A24: 36 00       ld   (hl),$00
3A26: ED B0       ldir
3A28: 21 EC 3E    ld   hl,$3EEC
3A2B: 3A 20 80    ld   a,($8020)
3A2E: 00          nop
3A2F: 3C          inc  a
3A30: FE 14       cp   $14
3A32: 20 01       jr   nz,$3A35
3A34: AF          xor  a
3A35: 32 20 80    ld   ($8020),a
3A38: 47          ld   b,a
3A39: 87          add  a,a
3A3A: 80          add  a,b
3A3B: D7          rst  $10   ; add_a_to_hl
3A3C: 4E          ld   c,(hl)
3A3D: 23          inc  hl
3A3E: 7E          ld   a,(hl)
3A3F: 23          inc  hl
3A40: 66          ld   h,(hl)
3A41: 6F          ld   l,a
3A42: 71          ld   (hl),c
3A43: 21 E6 3E    ld   hl,$3EE6
3A46: 11 E4 85    ld   de,$85E4
3A49: 01 06 00    ld   bc,$0006
3A4C: ED B0       ldir
3A4E: EB          ex   de,hl
3A4F: 3A 20 80    ld   a,($8020)
3A52: FE 0A       cp   $0A
3A54: 38 03       jr   c,$3A59
3A56: 0C          inc  c
3A57: D6 0A       sub  $0A
3A59: 71          ld   (hl),c
3A5A: 23          inc  hl
3A5B: 77          ld   (hl),a
3A5C: 3A 7A 83    ld   a,($837A)
3A5F: FE 0F       cp   $0F
3A61: CC 65 39    call z,$3965
3A64: 3A 04 88    ld   a,($8804)
3A67: 0F          rrca
3A68: D4 3B 3D    call nc,$3D3B
3A6B: 3A 51 80    ld   a,($8051)
3A6E: 21 74 3E    ld   hl,$3E74
3A71: E6 04       and  $04
3A73: CF          rst  $08
3A74: 11 E4 84    ld   de,$84E4
3A77: 01 07 00    ld   bc,$0007
3A7A: ED B0       ldir
3A7C: 3A 51 80    ld   a,($8051)
3A7F: 1F          rra
3A80: 1F          rra
3A81: 3C          inc  a
3A82: E6 01       and  $01
3A84: 4F          ld   c,a
3A85: 3A 04 88    ld   a,($8804)
3A88: E6 0C       and  $0C
3A8A: 3E 00       ld   a,$00
3A8C: 20 01       jr   nz,$3A8F
3A8E: 3C          inc  a
3A8F: A9          xor  c
3A90: 32 18 82    ld   ($8218),a
3A93: 3A 50 80    ld   a,($8050)
3A96: E6 07       and  $07
3A98: 21 B9 3C    ld   hl,$3CB9
3A9B: CF          rst  $08
3A9C: 7E          ld   a,(hl)
3A9D: 23          inc  hl
3A9E: 46          ld   b,(hl)
3A9F: 21 01 78    ld   hl,$7801
3AA2: 77          ld   (hl),a
3AA3: 23          inc  hl
3AA4: 70          ld   (hl),b
3AA5: 23          inc  hl
3AA6: 77          ld   (hl),a
3AA7: 23          inc  hl
3AA8: 70          ld   (hl),b
3AA9: 11 24 85    ld   de,$8524
3AAC: 21 C9 3C    ld   hl,$3CC9
3AAF: CF          rst  $08
3AB0: 78          ld   a,b
3AB1: CD 69 3E    call $3E69
3AB4: 21 D3 3C    ld   hl,$3CD3
3AB7: CF          rst  $08
3AB8: CD 69 3E    call $3E69
3ABB: 3A 50 80    ld   a,($8050)
3ABE: 07          rlca
3ABF: 07          rlca
3AC0: E6 03       and  $03
3AC2: 3C          inc  a
3AC3: FE 04       cp   $04
3AC5: 20 01       jr   nz,$3AC8
3AC7: 3C          inc  a
3AC8: 32 21 78    ld   ($7821),a
3ACB: 32 AB 89    ld   ($89AB),a
3ACE: 11 64 85    ld   de,$8564
3AD1: 12          ld   (de),a
3AD2: 1C          inc  e
3AD3: 1C          inc  e
3AD4: 21 B5 3C    ld   hl,$3CB5
3AD7: 01 04 00    ld   bc,$0004
3ADA: ED B0       ldir
3ADC: EB          ex   de,hl
3ADD: 0E 24       ld   c,$24
3ADF: 3D          dec  a
3AE0: 28 02       jr   z,$3AE4
3AE2: 0E 1C       ld   c,$1C
3AE4: 71          ld   (hl),c
3AE5: 21 8A 3C    ld   hl,$3C8A
3AE8: 11 A4 85    ld   de,$85A4
3AEB: CD 6D 3E    call memcopy_3e6d
3AEE: 3A 51 80    ld   a,($8051)
3AF1: 87          add  a,a
3AF2: E6 06       and  $06
3AF4: 21 91 3C    ld   hl,$3C91
3AF7: D7          rst  $10   ; add_a_to_hl
3AF8: 7E          ld   a,(hl)
3AF9: 23          inc  hl
3AFA: 66          ld   h,(hl)
3AFB: 6F          ld   l,a
3AFC: 7E          ld   a,(hl)
3AFD: 32 23 78    ld   ($7823),a
3B00: 23          inc  hl
3B01: 7E          ld   a,(hl)
3B02: 32 22 78    ld   ($7822),a
3B05: 23          inc  hl
3B06: CD 6D 3E    call memcopy_3e6d
3B09: 21 4A 3C    ld   hl,$3C4A
3B0C: 3A AB 89    ld   a,($89AB)
3B0F: FE 05       cp   $05
3B11: 20 03       jr   nz,$3B16
3B13: 21 6A 3C    ld   hl,$3C6A
3B16: 3A 50 80    ld   a,($8050)
3B19: 32 1D 82    ld   ($821D),a
3B1C: 32 24 78    ld   ($7824),a
3B1F: 0F          rrca
3B20: E6 1C       and  $1C
3B22: D7          rst  $10   ; add_a_to_hl
3B23: 11 0A 78    ld   de,$780A
3B26: ED A0       ldi
3B28: ED A0       ldi
3B2A: 11 12 78    ld   de,$7812
3B2D: 7E          ld   a,(hl)
3B2E: 0E 40       ld   c,$40
3B30: CB 7F       bit  7,a
3B32: 20 02       jr   nz,$3B36
3B34: CB E9       set  5,c
3B36: E6 7F       and  $7F
3B38: 12          ld   (de),a
3B39: 79          ld   a,c
3B3A: 32 20 78    ld   ($7820),a
3B3D: 23          inc  hl
3B3E: 13          inc  de
3B3F: ED A0       ldi
3B41: 11 21 86    ld   de,$8621
3B44: 21 4A 3C    ld   hl,$3C4A
3B47: 3A AB 89    ld   a,($89AB)
3B4A: FE 05       cp   $05
3B4C: 20 03       jr   nz,$3B51
3B4E: 21 6A 3C    ld   hl,$3C6A
3B51: 3A 1D 82    ld   a,($821D)
3B54: 0F          rrca
3B55: E6 1C       and  $1C
3B57: D7          rst  $10   ; add_a_to_hl
3B58: 7E          ld   a,(hl)
3B59: 3C          inc  a
3B5A: CA C8 3B    jp   z,$3BC8
3B5D: 0E 00       ld   c,$00
3B5F: CD 64 3B    call $3B64
3B62: 0E 01       ld   c,$01
3B64: C5          push bc
3B65: D5          push de
3B66: E5          push hl
3B67: 21 FF 3B    ld   hl,$3BFF
3B6A: 0D          dec  c
3B6B: 20 03       jr   nz,$3B70
3B6D: 21 18 3C    ld   hl,$3C18
3B70: CD 6D 3E    call memcopy_3e6d
3B73: 13          inc  de
3B74: 13          inc  de
3B75: 13          inc  de
3B76: CD 6D 3E    call memcopy_3e6d
3B79: D1          pop  de
3B7A: E1          pop  hl
3B7B: E5          push hl
3B7C: 01 0F 00    ld   bc,$000F
3B7F: 09          add  hl,bc
3B80: 1A          ld   a,(de)
3B81: 0F          rrca
3B82: 0F          rrca
3B83: 0F          rrca
3B84: 0F          rrca
3B85: E6 07       and  $07
3B87: 20 02       jr   nz,$3B8B
3B89: 3E 24       ld   a,$24
3B8B: 77          ld   (hl),a
3B8C: 23          inc  hl
3B8D: 1A          ld   a,(de)
3B8E: E6 0F       and  $0F
3B90: 77          ld   (hl),a
3B91: 13          inc  de
3B92: 23          inc  hl
3B93: 1A          ld   a,(de)
3B94: A7          and  a
3B95: 28 02       jr   z,$3B99
3B97: 3E 05       ld   a,$05
3B99: 77          ld   (hl),a
3B9A: 13          inc  de
3B9B: E1          pop  hl
3B9C: 01 40 00    ld   bc,$0040
3B9F: 09          add  hl,bc
3BA0: C1          pop  bc
3BA1: EB          ex   de,hl
3BA2: 0D          dec  c
3BA3: C0          ret  nz
3BA4: 2B          dec  hl
3BA5: 2B          dec  hl
3BA6: CB 7E       bit  7,(hl)
3BA8: 28 31       jr   z,$3BDB
3BAA: 21 31 3C    ld   hl,$3C31
3BAD: D5          push de
3BAE: CD 6D 3E    call memcopy_3e6d
3BB1: 13          inc  de
3BB2: 13          inc  de
3BB3: 13          inc  de
3BB4: CD 6D 3E    call memcopy_3e6d
3BB7: E1          pop  hl
3BB8: 01 0F 00    ld   bc,$000F
3BBB: 09          add  hl,bc
3BBC: 54          ld   d,h
3BBD: 5D          ld   e,l
3BBE: 01 C0 FF    ld   bc,$FFC0
3BC1: 09          add  hl,bc
3BC2: 01 0A 00    ld   bc,$000A
3BC5: ED B0       ldir
3BC7: C9          ret
3BC8: D5          push de
3BC9: 21 E4 3B    ld   hl,$3BE4
3BCC: CD 6D 3E    call memcopy_3e6d
3BCF: E1          pop  hl
3BD0: 01 40 00    ld   bc,$0040
3BD3: 09          add  hl,bc
3BD4: 54          ld   d,h
3BD5: 5D          ld   e,l
3BD6: 09          add  hl,bc
3BD7: CD DB 3B    call $3BDB
3BDA: EB          ex   de,hl
3BDB: 06 1C       ld   b,$1C
3BDD: 3E 24       ld   a,$24
3BDF: 12          ld   (de),a
3BE0: 13          inc  de
3BE1: 10 FC       djnz $3BDF
3BE3: C9          ret

3D32: 21 84 3D    ld   hl,$3D84
3D35: 22 25 78    ld   ($7825),hl
3D38: AF          xor  a
3D39: 12          ld   (de),a
3D3A: C9          ret
3D3B: 3A 0B 88    ld   a,($880B)
3D3E: E6 0F       and  $0F
3D40: C8          ret  z
3D41: 2A 25 78    ld   hl,($7825)
3D44: 11 27 78    ld   de,$7827
3D47: BE          cp   (hl)
3D48: 20 E8       jr   nz,$3D32
3D4A: 1A          ld   a,(de)
3D4B: 3C          inc  a
3D4C: 12          ld   (de),a
3D4D: 23          inc  hl
3D4E: 96          sub  (hl)
3D4F: C0          ret  nz
3D50: 12          ld   (de),a
3D51: 23          inc  hl
3D52: 22 25 78    ld   ($7825),hl
3D55: 7E          ld   a,(hl)
3D56: A7          and  a
3D57: C0          ret  nz
3D58: 21 A0 86    ld   hl,$86A0
3D5B: 06 00       ld   b,$00
3D5D: 36 24       ld   (hl),$24
3D5F: 23          inc  hl
3D60: 10 FB       djnz $3D5D
3D62: 21 A0 8E    ld   hl,$8EA0
3D65: 36 62       ld   (hl),$62
3D67: 23          inc  hl
3D68: 10 FB       djnz $3D65
3D6A: 21 70 3D    ld   hl,$3D70
3D6D: C3 C1 0B    jp   $0BC1

3D8D: 3A 40 80    ld   a,($8040)
3D90: FE 7F       cp   $7F
3D92: C8          ret  z
3D93: 3E 03       ld   a,$03
3D95: 32 10 98    ld   ($9810),a
3D98: 32 6D 80    ld   ($806D),a
3D9B: 21 40 80    ld   hl,$8040
3D9E: 06 08       ld   b,$08
3DA0: 36 7F       ld   (hl),$7F
3DA2: 23          inc  hl
3DA3: 10 FB       djnz $3DA0
3DA5: 2E 40       ld   l,$40
3DA7: 11 60 80    ld   de,$8060
3DAA: 01 FF 1B    ld   bc,$1BFF
3DAD: CD E9 3D    call $3DE9
3DB0: 21 00 84    ld   hl,$8400
3DB3: 36 7F       ld   (hl),$7F
3DB5: 23          inc  hl
3DB6: CB 5C       bit  3,h
3DB8: 28 F9       jr   z,$3DB3
3DBA: 26 8C       ld   h,$8C
3DBC: 0E A2       ld   c,$A2
3DBE: 7D          ld   a,l
3DBF: 87          add  a,a
3DC0: 87          add  a,a
3DC1: E6 80       and  $80
3DC3: CB 45       bit  0,l
3DC5: 20 02       jr   nz,$3DC9
3DC7: C6 40       add  a,$40
3DC9: A9          xor  c
3DCA: 77          ld   (hl),a
3DCB: 23          inc  hl
3DCC: CB 5C       bit  3,h
3DCE: 20 EE       jr   nz,$3DBE
3DD0: 21 18 8C    ld   hl,$8C18
3DD3: 11 40 88    ld   de,$8840
3DD6: 01 08 00    ld   bc,$0008
3DD9: ED B0       ldir
3DDB: 1E 60       ld   e,$60
3DDD: 0E 08       ld   c,$08
3DDF: ED B0       ldir
3DE1: 1E 80       ld   e,$80
3DE3: 21 40 88    ld   hl,$8840
3DE6: 01 FF 1A    ld   bc,$1AFF
3DE9: 3E 08       ld   a,$08
3DEB: ED A0       ldi
3DED: 3D          dec  a
3DEE: 20 FB       jr   nz,$3DEB
3DF0: EB          ex   de,hl
3DF1: 3E 18       ld   a,$18
3DF3: D7          rst  $10   ; add_a_to_hl
3DF4: EB          ex   de,hl
3DF5: 3E 18       ld   a,$18
3DF7: D7          rst  $10   ; add_a_to_hl
3DF8: 10 EF       djnz $3DE9
3DFA: C9          ret
3DFB: 21 00 80    ld   hl,$8000
3DFE: 11 01 80    ld   de,$8001
3E01: 01 00 04    ld   bc,$0400
3E04: 36 00       ld   (hl),$00
3E06: 32 30 68    ld   (dummy_6830),a
3E09: ED B0       ldir			; [video_address]
3E0B: 36 24       ld   (hl),$24			; [video_address]
3E0D: 01 00 04    ld   bc,$0400
3E10: ED B0       ldir				; [video_address]
3E12: 36 00       ld   (hl),$00			; [video_address]
3E14: 0E 40       ld   c,$40
3E16: ED B0       ldir			; [video_address]
3E18: 36 60       ld   (hl),$60		; [video_address]
3E1A: 0E 08       ld   c,$08
3E1C: ED B0       ldir			; [video_address]
3E1E: 36 00       ld   (hl),$00  ; [video_address]
3E20: 0E 18       ld   c,$18
3E22: ED B0       ldir   ; [video_address]
3E24: 21 40 88    ld   hl,$8840
3E27: 11 60 88    ld   de,$8860
3E2A: 01 A0 03    ld   bc,$03A0
3E2D: 32 30 68    ld   (dummy_6830),a
3E30: ED B0       ldir			; [video_address]
3E32: 21 00 8C    ld   hl,$8C00
3E35: 11 01 8C    ld   de,$8C01
3E38: 36 62       ld   (hl),$62    ; [video_address]
3E3A: 01 00 04    ld   bc,$0400
3E3D: 32 30 68    ld   (dummy_6830),a
3E40: ED B0       ldir    ; [video_address]
3E42: AF          xor  a
3E43: 21 00 7F    ld   hl,$7F00
3E46: 11 01 7F    ld   de,$7F01
3E49: 01 7F 00    ld   bc,$007F
3E4C: 77          ld   (hl),a
3E4D: 32 30 68    ld   (dummy_6830),a
3E50: ED B0       ldir
3E52: 21 00 7F    ld   hl,$7F00
3E55: 22 90 80    ld   ($8090),hl
3E58: 22 92 80    ld   ($8092),hl
3E5B: 32 10 98    ld   ($9810),a
3E5E: 32 20 98    ld   ($9820),a
3E61: 32 30 68    ld   (dummy_6830),a
3E64: 3C          inc  a
3E65: 32 1F 8A    ld   ($8A1F),a
3E68: C9          ret
3E69: 4E          ld   c,(hl)
3E6A: 23          inc  hl
3E6B: 66          ld   h,(hl)
3E6C: 69          ld   l,c

; < HL: word with number of bytes to copy, then data
; < DE: source
memcopy_3e6d:
3E6D: 4E          ld   c,(hl)
3E6E: 23          inc  hl
3E6F: 06 00       ld   b,$00
3E71: ED B0       ldir
3E73: C9          ret

3E8C: AF          xor  a
3E8D: 16 10       ld   d,$10
3E8F: 06 00       ld   b,$00
3E91: 86          add  a,(hl)
3E92: 32 30 68    ld   (dummy_6830),a
3E95: 23          inc  hl
3E96: 10 F9       djnz $3E91
3E98: 15          dec  d
3E99: 20 F6       jr   nz,$3E91
3E9B: B9          cp   c
3E9C: C8          ret  z
3E9D: 7C          ld   a,h
3E9E: 0F          rrca
3E9F: 0F          rrca
3EA0: 0F          rrca
3EA1: 0F          rrca
3EA2: 3D          dec  a
3EA3: E6 0F       and  $0F
3EA5: 32 A9 84    ld   ($84A9),a
3EA8: 3E 24       ld   a,$24
3EAA: 32 AA 84    ld   ($84AA),a
3EAD: 21 A4 84    ld   hl,$84A4
3EB0: 36 1B       ld   (hl),$1B		; [video_address]
3EB2: 23          inc  hl
3EB3: 36 18       ld   (hl),$18		; [video_address]
3EB5: 23          inc  hl
3EB6: 36 16       ld   (hl),$16		; [video_address]
3EB8: 3E 01       ld   a,$01
3EBA: 32 23 68    ld   ($6823),a
3EBD: 01 00 40    ld   bc,$4000
3EC0: 32 30 68    ld   (dummy_6830),a
3EC3: 0D          dec  c
3EC4: 20 FA       jr   nz,$3EC0
3EC6: 10 F8       djnz $3EC0
3EC8: CD 79 02    call $0279
3ECB: 3A 00 71    ld   a,($7100)
3ECE: FE 10       cp   $10
3ED0: 20 F9       jr   nz,$3ECB
3ED2: 3A C0 8B    ld   a,($8BC0)
3ED5: 87          add  a,a
3ED6: 38 F3       jr   c,$3ECB
3ED8: 32 30 68    ld   (dummy_6830),a
3EDB: C3 D8 3E    jp   $3ED8

3F28: 21 00 80    ld   hl,$8000
3F2B: 36 01       ld   (hl),$01
3F2D: 21 01 80    ld   hl,$8001
3F30: 34          inc  (hl)
3F31: CB 7E       bit  7,(hl)
3F33: C8          ret  z
3F34: AF          xor  a
3F35: 32 E1 83    ld   ($83E1),a
3F38: C9          ret
