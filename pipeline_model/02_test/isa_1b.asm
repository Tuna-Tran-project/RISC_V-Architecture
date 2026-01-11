
isa_1b.bin:     file format binary


Disassembly of section .data:

00000000 <.data>:
       0:	00007137          	lui	sp,0x7
       4:	00010113          	mv	sp,sp
       8:	0cc0006f          	j	0xd4
       c:	100002b7          	lui	t0,0x10000
      10:	00028293          	mv	t0,t0
      14:	00a28023          	sb	a0,0(t0) # 0x10000000
      18:	00008067          	ret
      1c:	00100073          	ebreak
      20:	ffdff06f          	j	0x1c
      24:	00112023          	sw	ra,0(sp) # 0x7000
      28:	02e00513          	li	a0,46
      2c:	fe1ff0ef          	jal	ra,0xc
      30:	02e00513          	li	a0,46
      34:	fd9ff0ef          	jal	ra,0xc
      38:	02e00513          	li	a0,46
      3c:	fd1ff0ef          	jal	ra,0xc
      40:	05000513          	li	a0,80
      44:	fc9ff0ef          	jal	ra,0xc
      48:	04100513          	li	a0,65
      4c:	fc1ff0ef          	jal	ra,0xc
      50:	05300513          	li	a0,83
      54:	fb9ff0ef          	jal	ra,0xc
      58:	05300513          	li	a0,83
      5c:	fb1ff0ef          	jal	ra,0xc
      60:	00d00513          	li	a0,13
      64:	fa9ff0ef          	jal	ra,0xc
      68:	00a00513          	li	a0,10
      6c:	fa1ff0ef          	jal	ra,0xc
      70:	00012083          	lw	ra,0(sp)
      74:	00008067          	ret
      78:	00112023          	sw	ra,0(sp)
      7c:	02e00513          	li	a0,46
      80:	f8dff0ef          	jal	ra,0xc
      84:	02e00513          	li	a0,46
      88:	f85ff0ef          	jal	ra,0xc
      8c:	02e00513          	li	a0,46
      90:	f7dff0ef          	jal	ra,0xc
      94:	04500513          	li	a0,69
      98:	f75ff0ef          	jal	ra,0xc
      9c:	05200513          	li	a0,82
      a0:	f6dff0ef          	jal	ra,0xc
      a4:	05200513          	li	a0,82
      a8:	f65ff0ef          	jal	ra,0xc
      ac:	04f00513          	li	a0,79
      b0:	f5dff0ef          	jal	ra,0xc
      b4:	05200513          	li	a0,82
      b8:	f55ff0ef          	jal	ra,0xc
      bc:	00d00513          	li	a0,13
      c0:	f4dff0ef          	jal	ra,0xc
      c4:	00a00513          	li	a0,10
      c8:	f45ff0ef          	jal	ra,0xc
      cc:	00012083          	lw	ra,0(sp)
      d0:	00008067          	ret
      d4:	0a0000ef          	jal	ra,0x174
      d8:	184000ef          	jal	ra,0x25c
      dc:	240000ef          	jal	ra,0x31c
      e0:	320000ef          	jal	ra,0x400
      e4:	3f0000ef          	jal	ra,0x4d4
      e8:	4a8000ef          	jal	ra,0x590
      ec:	57c000ef          	jal	ra,0x668
      f0:	63c000ef          	jal	ra,0x72c
      f4:	710000ef          	jal	ra,0x804
      f8:	7d8000ef          	jal	ra,0x8d0
      fc:	21d000ef          	jal	ra,0xb18
     100:	0f5000ef          	jal	ra,0x9f4
     104:	2d5000ef          	jal	ra,0xbd8
     108:	391000ef          	jal	ra,0xc98
     10c:	43d000ef          	jal	ra,0xd48
     110:	4c5000ef          	jal	ra,0xdd4
     114:	579000ef          	jal	ra,0xe8c
     118:	609000ef          	jal	ra,0xf20
     11c:	6b5000ef          	jal	ra,0xfd0
     120:	741000ef          	jal	ra,0x1060
     124:	7bd000ef          	jal	ra,0x10e0
     128:	064010ef          	jal	ra,0x118c
     12c:	10c010ef          	jal	ra,0x1238
     130:	1a4010ef          	jal	ra,0x12d4
     134:	23c010ef          	jal	ra,0x1370
     138:	2b8010ef          	jal	ra,0x13f0
     13c:	344010ef          	jal	ra,0x1480
     140:	3c4010ef          	jal	ra,0x1504
     144:	428010ef          	jal	ra,0x156c
     148:	480010ef          	jal	ra,0x15c8
     14c:	574010ef          	jal	ra,0x16c0
     150:	664010ef          	jal	ra,0x17b4
     154:	750010ef          	jal	ra,0x18a4
     158:	03d010ef          	jal	ra,0x1994
     15c:	12d010ef          	jal	ra,0x1a88
     160:	21d010ef          	jal	ra,0x1b7c
     164:	265010ef          	jal	ra,0x1bc8
     168:	2ad010ef          	jal	ra,0x1c14
     16c:	33d010ef          	jal	ra,0x1ca8
     170:	eadff06f          	j	0x1c
     174:	00112223          	sw	ra,4(sp)
     178:	06100513          	li	a0,97
     17c:	e91ff0ef          	jal	ra,0xc
     180:	06400513          	li	a0,100
     184:	e89ff0ef          	jal	ra,0xc
     188:	06400513          	li	a0,100
     18c:	e81ff0ef          	jal	ra,0xc
     190:	02e00513          	li	a0,46
     194:	e79ff0ef          	jal	ra,0xc
     198:	02e00513          	li	a0,46
     19c:	e71ff0ef          	jal	ra,0xc
     1a0:	02e00513          	li	a0,46
     1a4:	e69ff0ef          	jal	ra,0xc
     1a8:	00000893          	li	a7,0
     1ac:	00000313          	li	t1,0
     1b0:	00000393          	li	t2,0
     1b4:	007302b3          	add	t0,t1,t2
     1b8:	08589863          	bne	a7,t0,0x248
     1bc:	00a00893          	li	a7,10
     1c0:	00200313          	li	t1,2
     1c4:	00800393          	li	t2,8
     1c8:	007302b3          	add	t0,t1,t2
     1cc:	06589e63          	bne	a7,t0,0x248
     1d0:	ffff88b7          	lui	a7,0xffff8
     1d4:	00088893          	mv	a7,a7
     1d8:	00000313          	li	t1,0
     1dc:	ffff83b7          	lui	t2,0xffff8
     1e0:	00038393          	mv	t2,t2
     1e4:	007002b3          	add	t0,zero,t2
     1e8:	06589063          	bne	a7,t0,0x248
     1ec:	800088b7          	lui	a7,0x80008
     1f0:	ffe88893          	addi	a7,a7,-2 # 0x80007ffe
     1f4:	80000337          	lui	t1,0x80000
     1f8:	fff30313          	addi	t1,t1,-1 # 0x7fffffff
     1fc:	000083b7          	lui	t2,0x8
     200:	fff38393          	addi	t2,t2,-1 # 0x7fff
     204:	007302b3          	add	t0,t1,t2
     208:	04589063          	bne	a7,t0,0x248
     20c:	00000893          	li	a7,0
     210:	fff00313          	li	t1,-1
     214:	00100393          	li	t2,1
     218:	007302b3          	add	t0,t1,t2
     21c:	02589663          	bne	a7,t0,0x248
     220:	03b00893          	li	a7,59
     224:	00b00313          	li	t1,11
     228:	00c00393          	li	t2,12
     22c:	00d00e13          	li	t3,13
     230:	007302b3          	add	t0,t1,t2
     234:	005302b3          	add	t0,t1,t0
     238:	01c282b3          	add	t0,t0,t3
     23c:	005382b3          	add	t0,t2,t0
     240:	00589463          	bne	a7,t0,0x248
     244:	00c0006f          	j	0x250
     248:	e31ff0ef          	jal	ra,0x78
     24c:	0080006f          	j	0x254
     250:	dd5ff0ef          	jal	ra,0x24
     254:	00412083          	lw	ra,4(sp)
     258:	00008067          	ret
     25c:	00112223          	sw	ra,4(sp)
     260:	06100513          	li	a0,97
     264:	da9ff0ef          	jal	ra,0xc
     268:	06400513          	li	a0,100
     26c:	da1ff0ef          	jal	ra,0xc
     270:	06400513          	li	a0,100
     274:	d99ff0ef          	jal	ra,0xc
     278:	06900513          	li	a0,105
     27c:	d91ff0ef          	jal	ra,0xc
     280:	02e00513          	li	a0,46
     284:	d89ff0ef          	jal	ra,0xc
     288:	02e00513          	li	a0,46
     28c:	d81ff0ef          	jal	ra,0xc
     290:	00000893          	li	a7,0
     294:	00000313          	li	t1,0
     298:	00030293          	mv	t0,t1
     29c:	06589663          	bne	a7,t0,0x308
     2a0:	00a00893          	li	a7,10
     2a4:	00200313          	li	t1,2
     2a8:	00830293          	addi	t0,t1,8
     2ac:	04589e63          	bne	a7,t0,0x308
     2b0:	ffff88b7          	lui	a7,0xffff8
     2b4:	00088893          	mv	a7,a7
     2b8:	ffff8337          	lui	t1,0xffff8
     2bc:	00030313          	mv	t1,t1
     2c0:	00030293          	mv	t0,t1
     2c4:	04589263          	bne	a7,t0,0x308
     2c8:	000088b7          	lui	a7,0x8
     2cc:	ffe88893          	addi	a7,a7,-2 # 0x7ffe
     2d0:	00008337          	lui	t1,0x8
     2d4:	fff30313          	addi	t1,t1,-1 # 0x7fff
     2d8:	fff30293          	addi	t0,t1,-1
     2dc:	02589663          	bne	a7,t0,0x308
     2e0:	00000893          	li	a7,0
     2e4:	fff00313          	li	t1,-1
     2e8:	00130293          	addi	t0,t1,1
     2ec:	00589e63          	bne	a7,t0,0x308
     2f0:	02200893          	li	a7,34
     2f4:	00b00313          	li	t1,11
     2f8:	00c30293          	addi	t0,t1,12
     2fc:	00b28293          	addi	t0,t0,11
     300:	00589463          	bne	a7,t0,0x308
     304:	00c0006f          	j	0x310
     308:	d71ff0ef          	jal	ra,0x78
     30c:	0080006f          	j	0x314
     310:	d15ff0ef          	jal	ra,0x24
     314:	00412083          	lw	ra,4(sp)
     318:	00008067          	ret
     31c:	00112223          	sw	ra,4(sp)
     320:	07300513          	li	a0,115
     324:	ce9ff0ef          	jal	ra,0xc
     328:	07500513          	li	a0,117
     32c:	ce1ff0ef          	jal	ra,0xc
     330:	06200513          	li	a0,98
     334:	cd9ff0ef          	jal	ra,0xc
     338:	02e00513          	li	a0,46
     33c:	cd1ff0ef          	jal	ra,0xc
     340:	02e00513          	li	a0,46
     344:	cc9ff0ef          	jal	ra,0xc
     348:	02e00513          	li	a0,46
     34c:	cc1ff0ef          	jal	ra,0xc
     350:	00000893          	li	a7,0
     354:	00000313          	li	t1,0
     358:	00000393          	li	t2,0
     35c:	407302b3          	sub	t0,t1,t2
     360:	08589663          	bne	a7,t0,0x3ec
     364:	00600893          	li	a7,6
     368:	00800313          	li	t1,8
     36c:	00200393          	li	t2,2
     370:	407302b3          	sub	t0,t1,t2
     374:	06589c63          	bne	a7,t0,0x3ec
     378:	000088b7          	lui	a7,0x8
     37c:	00088893          	mv	a7,a7
     380:	ffff83b7          	lui	t2,0xffff8
     384:	00038393          	mv	t2,t2
     388:	407002b3          	neg	t0,t2
     38c:	06589063          	bne	a7,t0,0x3ec
     390:	7fff88b7          	lui	a7,0x7fff8
     394:	00188893          	addi	a7,a7,1 # 0x7fff8001
     398:	80000337          	lui	t1,0x80000
     39c:	00030313          	mv	t1,t1
     3a0:	000083b7          	lui	t2,0x8
     3a4:	fff38393          	addi	t2,t2,-1 # 0x7fff
     3a8:	407302b3          	sub	t0,t1,t2
     3ac:	04589063          	bne	a7,t0,0x3ec
     3b0:	ffe00893          	li	a7,-2
     3b4:	fff00313          	li	t1,-1
     3b8:	00100393          	li	t2,1
     3bc:	407302b3          	sub	t0,t1,t2
     3c0:	02589663          	bne	a7,t0,0x3ec
     3c4:	00300893          	li	a7,3
     3c8:	05900313          	li	t1,89
     3cc:	00d00393          	li	t2,13
     3d0:	00300e13          	li	t3,3
     3d4:	407302b3          	sub	t0,t1,t2
     3d8:	405302b3          	sub	t0,t1,t0
     3dc:	41c282b3          	sub	t0,t0,t3
     3e0:	405382b3          	sub	t0,t2,t0
     3e4:	00589463          	bne	a7,t0,0x3ec
     3e8:	00c0006f          	j	0x3f4
     3ec:	c8dff0ef          	jal	ra,0x78
     3f0:	0080006f          	j	0x3f8
     3f4:	c31ff0ef          	jal	ra,0x24
     3f8:	00412083          	lw	ra,4(sp)
     3fc:	00008067          	ret
     400:	00112223          	sw	ra,4(sp)
     404:	06100513          	li	a0,97
     408:	c05ff0ef          	jal	ra,0xc
     40c:	06e00513          	li	a0,110
     410:	bfdff0ef          	jal	ra,0xc
     414:	06400513          	li	a0,100
     418:	bf5ff0ef          	jal	ra,0xc
     41c:	02e00513          	li	a0,46
     420:	bedff0ef          	jal	ra,0xc
     424:	02e00513          	li	a0,46
     428:	be5ff0ef          	jal	ra,0xc
     42c:	02e00513          	li	a0,46
     430:	bddff0ef          	jal	ra,0xc
     434:	0f0018b7          	lui	a7,0xf001
     438:	f0088893          	addi	a7,a7,-256 # 0xf000f00
     43c:	ff010337          	lui	t1,0xff010
     440:	f0030313          	addi	t1,t1,-256 # 0xff00ff00
     444:	0f0f13b7          	lui	t2,0xf0f1
     448:	f0f38393          	addi	t2,t2,-241 # 0xf0f0f0f
     44c:	007372b3          	and	t0,t1,t2
     450:	06589863          	bne	a7,t0,0x4c0
     454:	f000f8b7          	lui	a7,0xf000f
     458:	00088893          	mv	a7,a7
     45c:	f00ff337          	lui	t1,0xf00ff
     460:	00f30313          	addi	t1,t1,15 # 0xf00ff00f
     464:	f0f0f3b7          	lui	t2,0xf0f0f
     468:	0f038393          	addi	t2,t2,240 # 0xf0f0f0f0
     46c:	007372b3          	and	t0,t1,t2
     470:	04589863          	bne	a7,t0,0x4c0
     474:	00000893          	li	a7,0
     478:	00000313          	li	t1,0
     47c:	ffff83b7          	lui	t2,0xffff8
     480:	00038393          	mv	t2,t2
     484:	007072b3          	and	t0,zero,t2
     488:	02589c63          	bne	a7,t0,0x4c0
     48c:	f00f08b7          	lui	a7,0xf00f0
     490:	00088893          	mv	a7,a7
     494:	ff100337          	lui	t1,0xff100
     498:	f0f30313          	addi	t1,t1,-241 # 0xff0fff0f
     49c:	ffff03b7          	lui	t2,0xffff0
     4a0:	00038393          	mv	t2,t2
     4a4:	f00ffe37          	lui	t3,0xf00ff
     4a8:	00fe0e13          	addi	t3,t3,15 # 0xf00ff00f
     4ac:	007372b3          	and	t0,t1,t2
     4b0:	01c2f2b3          	and	t0,t0,t3
     4b4:	0053f2b3          	and	t0,t2,t0
     4b8:	00589463          	bne	a7,t0,0x4c0
     4bc:	00c0006f          	j	0x4c8
     4c0:	bb9ff0ef          	jal	ra,0x78
     4c4:	0080006f          	j	0x4cc
     4c8:	b5dff0ef          	jal	ra,0x24
     4cc:	00412083          	lw	ra,4(sp)
     4d0:	00008067          	ret
     4d4:	00112223          	sw	ra,4(sp)
     4d8:	06100513          	li	a0,97
     4dc:	b31ff0ef          	jal	ra,0xc
     4e0:	06e00513          	li	a0,110
     4e4:	b29ff0ef          	jal	ra,0xc
     4e8:	06400513          	li	a0,100
     4ec:	b21ff0ef          	jal	ra,0xc
     4f0:	06900513          	li	a0,105
     4f4:	b19ff0ef          	jal	ra,0xc
     4f8:	02e00513          	li	a0,46
     4fc:	b11ff0ef          	jal	ra,0xc
     500:	02e00513          	li	a0,46
     504:	b09ff0ef          	jal	ra,0xc
     508:	ff0108b7          	lui	a7,0xff010
     50c:	f0088893          	addi	a7,a7,-256 # 0xff00ff00
     510:	ff010337          	lui	t1,0xff010
     514:	f0030313          	addi	t1,t1,-256 # 0xff00ff00
     518:	f0f37293          	andi	t0,t1,-241
     51c:	06589063          	bne	a7,t0,0x57c
     520:	00f00893          	li	a7,15
     524:	00ff0337          	lui	t1,0xff0
     528:	0ff30313          	addi	t1,t1,255 # 0xff00ff
     52c:	70f37293          	andi	t0,t1,1807
     530:	04589663          	bne	a7,t0,0x57c
     534:	00000893          	li	a7,0
     538:	f00ff337          	lui	t1,0xf00ff
     53c:	00f30313          	addi	t1,t1,15 # 0xf00ff00f
     540:	0f037293          	andi	t0,t1,240
     544:	02589c63          	bne	a7,t0,0x57c
     548:	00000893          	li	a7,0
     54c:	ff010337          	lui	t1,0xff010
     550:	f0030313          	addi	t1,t1,-256 # 0xff00ff00
     554:	00030293          	mv	t0,t1
     558:	0f02f293          	andi	t0,t0,240
     55c:	02589063          	bne	a7,t0,0x57c
     560:	00f00893          	li	a7,15
     564:	f00ff337          	lui	t1,0xf00ff
     568:	00f30313          	addi	t1,t1,15 # 0xf00ff00f
     56c:	70f37293          	andi	t0,t1,1807
     570:	f0f2f293          	andi	t0,t0,-241
     574:	00589463          	bne	a7,t0,0x57c
     578:	00c0006f          	j	0x584
     57c:	afdff0ef          	jal	ra,0x78
     580:	0080006f          	j	0x588
     584:	aa1ff0ef          	jal	ra,0x24
     588:	00412083          	lw	ra,4(sp)
     58c:	00008067          	ret
     590:	00112223          	sw	ra,4(sp)
     594:	06f00513          	li	a0,111
     598:	a75ff0ef          	jal	ra,0xc
     59c:	07200513          	li	a0,114
     5a0:	a6dff0ef          	jal	ra,0xc
     5a4:	02e00513          	li	a0,46
     5a8:	a65ff0ef          	jal	ra,0xc
     5ac:	02e00513          	li	a0,46
     5b0:	a5dff0ef          	jal	ra,0xc
     5b4:	02e00513          	li	a0,46
     5b8:	a55ff0ef          	jal	ra,0xc
     5bc:	02e00513          	li	a0,46
     5c0:	a4dff0ef          	jal	ra,0xc
     5c4:	ff1008b7          	lui	a7,0xff100
     5c8:	f0f88893          	addi	a7,a7,-241 # 0xff0fff0f
     5cc:	ff010337          	lui	t1,0xff010
     5d0:	f0030313          	addi	t1,t1,-256 # 0xff00ff00
     5d4:	0f0f13b7          	lui	t2,0xf0f1
     5d8:	f0f38393          	addi	t2,t2,-241 # 0xf0f0f0f
     5dc:	007362b3          	or	t0,t1,t2
     5e0:	06589a63          	bne	a7,t0,0x654
     5e4:	f0fff8b7          	lui	a7,0xf0fff
     5e8:	0ff88893          	addi	a7,a7,255 # 0xf0fff0ff
     5ec:	f00ff337          	lui	t1,0xf00ff
     5f0:	00f30313          	addi	t1,t1,15 # 0xf00ff00f
     5f4:	f0f0f3b7          	lui	t2,0xf0f0f
     5f8:	0f038393          	addi	t2,t2,240 # 0xf0f0f0f0
     5fc:	007362b3          	or	t0,t1,t2
     600:	04589a63          	bne	a7,t0,0x654
     604:	ffff88b7          	lui	a7,0xffff8
     608:	00088893          	mv	a7,a7
     60c:	00000313          	li	t1,0
     610:	ffff83b7          	lui	t2,0xffff8
     614:	00038393          	mv	t2,t2
     618:	007062b3          	or	t0,zero,t2
     61c:	02589c63          	bne	a7,t0,0x654
     620:	ff1008b7          	lui	a7,0xff100
     624:	f0f88893          	addi	a7,a7,-241 # 0xff0fff0f
     628:	ff100337          	lui	t1,0xff100
     62c:	f0f30313          	addi	t1,t1,-241 # 0xff0fff0f
     630:	ff0003b7          	lui	t2,0xff000
     634:	00038393          	mv	t2,t2
     638:	f00ffe37          	lui	t3,0xf00ff
     63c:	00fe0e13          	addi	t3,t3,15 # 0xf00ff00f
     640:	007362b3          	or	t0,t1,t2
     644:	01c2e2b3          	or	t0,t0,t3
     648:	0053e2b3          	or	t0,t2,t0
     64c:	00589463          	bne	a7,t0,0x654
     650:	00c0006f          	j	0x65c
     654:	a25ff0ef          	jal	ra,0x78
     658:	0080006f          	j	0x660
     65c:	9c9ff0ef          	jal	ra,0x24
     660:	00412083          	lw	ra,4(sp)
     664:	00008067          	ret
     668:	00112223          	sw	ra,4(sp)
     66c:	06f00513          	li	a0,111
     670:	99dff0ef          	jal	ra,0xc
     674:	07200513          	li	a0,114
     678:	995ff0ef          	jal	ra,0xc
     67c:	06900513          	li	a0,105
     680:	98dff0ef          	jal	ra,0xc
     684:	02e00513          	li	a0,46
     688:	985ff0ef          	jal	ra,0xc
     68c:	02e00513          	li	a0,46
     690:	97dff0ef          	jal	ra,0xc
     694:	02e00513          	li	a0,46
     698:	975ff0ef          	jal	ra,0xc
     69c:	f0f00893          	li	a7,-241
     6a0:	ff010337          	lui	t1,0xff010
     6a4:	f0f30313          	addi	t1,t1,-241 # 0xff00ff0f
     6a8:	f0f36293          	ori	t0,t1,-241
     6ac:	06589663          	bne	a7,t0,0x718
     6b0:	00ff08b7          	lui	a7,0xff0
     6b4:	7ff88893          	addi	a7,a7,2047 # 0xff07ff
     6b8:	00ff0337          	lui	t1,0xff0
     6bc:	0ff30313          	addi	t1,t1,255 # 0xff00ff
     6c0:	70f36293          	ori	t0,t1,1807
     6c4:	04589a63          	bne	a7,t0,0x718
     6c8:	f00ff8b7          	lui	a7,0xf00ff
     6cc:	0ff88893          	addi	a7,a7,255 # 0xf00ff0ff
     6d0:	f00ff337          	lui	t1,0xf00ff
     6d4:	00f30313          	addi	t1,t1,15 # 0xf00ff00f
     6d8:	0f036293          	ori	t0,t1,240
     6dc:	02589e63          	bne	a7,t0,0x718
     6e0:	ff0108b7          	lui	a7,0xff010
     6e4:	ff088893          	addi	a7,a7,-16 # 0xff00fff0
     6e8:	ff010337          	lui	t1,0xff010
     6ec:	f0030313          	addi	t1,t1,-256 # 0xff00ff00
     6f0:	00030293          	mv	t0,t1
     6f4:	0f02e293          	ori	t0,t0,240
     6f8:	02589063          	bne	a7,t0,0x718
     6fc:	f0f00893          	li	a7,-241
     700:	f00ff337          	lui	t1,0xf00ff
     704:	00f30313          	addi	t1,t1,15 # 0xf00ff00f
     708:	70f36293          	ori	t0,t1,1807
     70c:	f0f2e293          	ori	t0,t0,-241
     710:	00589463          	bne	a7,t0,0x718
     714:	00c0006f          	j	0x720
     718:	961ff0ef          	jal	ra,0x78
     71c:	0080006f          	j	0x724
     720:	905ff0ef          	jal	ra,0x24
     724:	00412083          	lw	ra,4(sp)
     728:	00008067          	ret
     72c:	00112223          	sw	ra,4(sp)
     730:	07800513          	li	a0,120
     734:	8d9ff0ef          	jal	ra,0xc
     738:	06f00513          	li	a0,111
     73c:	8d1ff0ef          	jal	ra,0xc
     740:	07200513          	li	a0,114
     744:	8c9ff0ef          	jal	ra,0xc
     748:	02e00513          	li	a0,46
     74c:	8c1ff0ef          	jal	ra,0xc
     750:	02e00513          	li	a0,46
     754:	8b9ff0ef          	jal	ra,0xc
     758:	02e00513          	li	a0,46
     75c:	8b1ff0ef          	jal	ra,0xc
     760:	f00ff8b7          	lui	a7,0xf00ff
     764:	00f88893          	addi	a7,a7,15 # 0xf00ff00f
     768:	ff010337          	lui	t1,0xff010
     76c:	f0030313          	addi	t1,t1,-256 # 0xff00ff00
     770:	0f0f13b7          	lui	t2,0xf0f1
     774:	f0f38393          	addi	t2,t2,-241 # 0xf0f0f0f
     778:	007342b3          	xor	t0,t1,t2
     77c:	06589a63          	bne	a7,t0,0x7f0
     780:	00ff08b7          	lui	a7,0xff0
     784:	0ff88893          	addi	a7,a7,255 # 0xff00ff
     788:	f00ff337          	lui	t1,0xf00ff
     78c:	00f30313          	addi	t1,t1,15 # 0xf00ff00f
     790:	f0f0f3b7          	lui	t2,0xf0f0f
     794:	0f038393          	addi	t2,t2,240 # 0xf0f0f0f0
     798:	007342b3          	xor	t0,t1,t2
     79c:	04589a63          	bne	a7,t0,0x7f0
     7a0:	ffff88b7          	lui	a7,0xffff8
     7a4:	00088893          	mv	a7,a7
     7a8:	00000313          	li	t1,0
     7ac:	ffff83b7          	lui	t2,0xffff8
     7b0:	00038393          	mv	t2,t2
     7b4:	007042b3          	xor	t0,zero,t2
     7b8:	02589c63          	bne	a7,t0,0x7f0
     7bc:	0f0018b7          	lui	a7,0xf001
     7c0:	f0088893          	addi	a7,a7,-256 # 0xf000f00
     7c4:	ff100337          	lui	t1,0xff100
     7c8:	f0f30313          	addi	t1,t1,-241 # 0xff0fff0f
     7cc:	ffff03b7          	lui	t2,0xffff0
     7d0:	00038393          	mv	t2,t2
     7d4:	f00ffe37          	lui	t3,0xf00ff
     7d8:	00fe0e13          	addi	t3,t3,15 # 0xf00ff00f
     7dc:	007342b3          	xor	t0,t1,t2
     7e0:	01c2c2b3          	xor	t0,t0,t3
     7e4:	0053c2b3          	xor	t0,t2,t0
     7e8:	00589463          	bne	a7,t0,0x7f0
     7ec:	00c0006f          	j	0x7f8
     7f0:	889ff0ef          	jal	ra,0x78
     7f4:	0080006f          	j	0x7fc
     7f8:	82dff0ef          	jal	ra,0x24
     7fc:	00412083          	lw	ra,4(sp)
     800:	00008067          	ret
     804:	00112223          	sw	ra,4(sp)
     808:	07800513          	li	a0,120
     80c:	801ff0ef          	jal	ra,0xc
     810:	06f00513          	li	a0,111
     814:	ff8ff0ef          	jal	ra,0xc
     818:	07200513          	li	a0,114
     81c:	ff0ff0ef          	jal	ra,0xc
     820:	06900513          	li	a0,105
     824:	fe8ff0ef          	jal	ra,0xc
     828:	02e00513          	li	a0,46
     82c:	fe0ff0ef          	jal	ra,0xc
     830:	02e00513          	li	a0,46
     834:	fd8ff0ef          	jal	ra,0xc
     838:	ff0108b7          	lui	a7,0xff010
     83c:	f0088893          	addi	a7,a7,-256 # 0xff00ff00
     840:	00ff0337          	lui	t1,0xff0
     844:	00f30313          	addi	t1,t1,15 # 0xff000f
     848:	f0f34293          	xori	t0,t1,-241
     84c:	06589863          	bne	a7,t0,0x8bc
     850:	00ff08b7          	lui	a7,0xff0
     854:	7f088893          	addi	a7,a7,2032 # 0xff07f0
     858:	00ff0337          	lui	t1,0xff0
     85c:	0ff30313          	addi	t1,t1,255 # 0xff00ff
     860:	70f34293          	xori	t0,t1,1807
     864:	04589c63          	bne	a7,t0,0x8bc
     868:	f00ff8b7          	lui	a7,0xf00ff
     86c:	0ff88893          	addi	a7,a7,255 # 0xf00ff0ff
     870:	f00ff337          	lui	t1,0xf00ff
     874:	00f30313          	addi	t1,t1,15 # 0xf00ff00f
     878:	0f034293          	xori	t0,t1,240
     87c:	04589063          	bne	a7,t0,0x8bc
     880:	ff0108b7          	lui	a7,0xff010
     884:	ff088893          	addi	a7,a7,-16 # 0xff00fff0
     888:	ff010337          	lui	t1,0xff010
     88c:	f0030313          	addi	t1,t1,-256 # 0xff00ff00
     890:	00030293          	mv	t0,t1
     894:	0f02c293          	xori	t0,t0,240
     898:	02589263          	bne	a7,t0,0x8bc
     89c:	0ff018b7          	lui	a7,0xff01
     8a0:	80f88893          	addi	a7,a7,-2033 # 0xff0080f
     8a4:	f00ff337          	lui	t1,0xf00ff
     8a8:	00f30313          	addi	t1,t1,15 # 0xf00ff00f
     8ac:	70f34293          	xori	t0,t1,1807
     8b0:	f0f2c293          	xori	t0,t0,-241
     8b4:	00589463          	bne	a7,t0,0x8bc
     8b8:	00c0006f          	j	0x8c4
     8bc:	fbcff0ef          	jal	ra,0x78
     8c0:	0080006f          	j	0x8c8
     8c4:	f60ff0ef          	jal	ra,0x24
     8c8:	00412083          	lw	ra,4(sp)
     8cc:	00008067          	ret
     8d0:	00112223          	sw	ra,4(sp)
     8d4:	07300513          	li	a0,115
     8d8:	f34ff0ef          	jal	ra,0xc
     8dc:	06c00513          	li	a0,108
     8e0:	f2cff0ef          	jal	ra,0xc
     8e4:	07400513          	li	a0,116
     8e8:	f24ff0ef          	jal	ra,0xc
     8ec:	02e00513          	li	a0,46
     8f0:	f1cff0ef          	jal	ra,0xc
     8f4:	02e00513          	li	a0,46
     8f8:	f14ff0ef          	jal	ra,0xc
     8fc:	02e00513          	li	a0,46
     900:	f0cff0ef          	jal	ra,0xc
     904:	00000893          	li	a7,0
     908:	00000313          	li	t1,0
     90c:	00000393          	li	t2,0
     910:	007322b3          	slt	t0,t1,t2
     914:	0c589663          	bne	a7,t0,0x9e0
     918:	00100893          	li	a7,1
     91c:	00300313          	li	t1,3
     920:	00700393          	li	t2,7
     924:	007322b3          	slt	t0,t1,t2
     928:	0a589c63          	bne	a7,t0,0x9e0
     92c:	00000893          	li	a7,0
     930:	00700313          	li	t1,7
     934:	00300393          	li	t2,3
     938:	007322b3          	slt	t0,t1,t2
     93c:	0a589263          	bne	a7,t0,0x9e0
     940:	00100893          	li	a7,1
     944:	80000337          	lui	t1,0x80000
     948:	00030313          	mv	t1,t1
     94c:	00800393          	li	t2,8
     950:	007322b3          	slt	t0,t1,t2
     954:	08589663          	bne	a7,t0,0x9e0
     958:	00000893          	li	a7,0
     95c:	00800313          	li	t1,8
     960:	800003b7          	lui	t2,0x80000
     964:	00038393          	mv	t2,t2
     968:	007322b3          	slt	t0,t1,t2
     96c:	06589a63          	bne	a7,t0,0x9e0
     970:	00100893          	li	a7,1
     974:	80000337          	lui	t1,0x80000
     978:	00030313          	mv	t1,t1
     97c:	fff00393          	li	t2,-1
     980:	007322b3          	slt	t0,t1,t2
     984:	04589e63          	bne	a7,t0,0x9e0
     988:	00000893          	li	a7,0
     98c:	fff00313          	li	t1,-1
     990:	800003b7          	lui	t2,0x80000
     994:	00038393          	mv	t2,t2
     998:	007322b3          	slt	t0,t1,t2
     99c:	04589263          	bne	a7,t0,0x9e0
     9a0:	00000893          	li	a7,0
     9a4:	00800313          	li	t1,8
     9a8:	006322b3          	slt	t0,t1,t1
     9ac:	02589a63          	bne	a7,t0,0x9e0
     9b0:	00000893          	li	a7,0
     9b4:	00800313          	li	t1,8
     9b8:	00000293          	li	t0,0
     9bc:	005322b3          	slt	t0,t1,t0
     9c0:	02589063          	bne	a7,t0,0x9e0
     9c4:	00100893          	li	a7,1
     9c8:	80000337          	lui	t1,0x80000
     9cc:	00030313          	mv	t1,t1
     9d0:	00000293          	li	t0,0
     9d4:	005322b3          	slt	t0,t1,t0
     9d8:	00589463          	bne	a7,t0,0x9e0
     9dc:	00c0006f          	j	0x9e8
     9e0:	e98ff0ef          	jal	ra,0x78
     9e4:	0080006f          	j	0x9ec
     9e8:	e3cff0ef          	jal	ra,0x24
     9ec:	00412083          	lw	ra,4(sp)
     9f0:	00008067          	ret
     9f4:	00112223          	sw	ra,4(sp)
     9f8:	07300513          	li	a0,115
     9fc:	e10ff0ef          	jal	ra,0xc
     a00:	06c00513          	li	a0,108
     a04:	e08ff0ef          	jal	ra,0xc
     a08:	07400513          	li	a0,116
     a0c:	e00ff0ef          	jal	ra,0xc
     a10:	07500513          	li	a0,117
     a14:	df8ff0ef          	jal	ra,0xc
     a18:	02e00513          	li	a0,46
     a1c:	df0ff0ef          	jal	ra,0xc
     a20:	02e00513          	li	a0,46
     a24:	de8ff0ef          	jal	ra,0xc
     a28:	00000893          	li	a7,0
     a2c:	00000313          	li	t1,0
     a30:	00000393          	li	t2,0
     a34:	007332b3          	sltu	t0,t1,t2
     a38:	0c589663          	bne	a7,t0,0xb04
     a3c:	00100893          	li	a7,1
     a40:	00300313          	li	t1,3
     a44:	00700393          	li	t2,7
     a48:	007332b3          	sltu	t0,t1,t2
     a4c:	0a589c63          	bne	a7,t0,0xb04
     a50:	00000893          	li	a7,0
     a54:	00700313          	li	t1,7
     a58:	00300393          	li	t2,3
     a5c:	007332b3          	sltu	t0,t1,t2
     a60:	0a589263          	bne	a7,t0,0xb04
     a64:	00000893          	li	a7,0
     a68:	80000337          	lui	t1,0x80000
     a6c:	00030313          	mv	t1,t1
     a70:	00800393          	li	t2,8
     a74:	007332b3          	sltu	t0,t1,t2
     a78:	08589663          	bne	a7,t0,0xb04
     a7c:	00100893          	li	a7,1
     a80:	00800313          	li	t1,8
     a84:	800003b7          	lui	t2,0x80000
     a88:	00038393          	mv	t2,t2
     a8c:	007332b3          	sltu	t0,t1,t2
     a90:	06589a63          	bne	a7,t0,0xb04
     a94:	00100893          	li	a7,1
     a98:	80000337          	lui	t1,0x80000
     a9c:	00030313          	mv	t1,t1
     aa0:	fff00393          	li	t2,-1
     aa4:	007332b3          	sltu	t0,t1,t2
     aa8:	04589e63          	bne	a7,t0,0xb04
     aac:	00000893          	li	a7,0
     ab0:	fff00313          	li	t1,-1
     ab4:	800003b7          	lui	t2,0x80000
     ab8:	00038393          	mv	t2,t2
     abc:	007332b3          	sltu	t0,t1,t2
     ac0:	04589263          	bne	a7,t0,0xb04
     ac4:	00000893          	li	a7,0
     ac8:	00800313          	li	t1,8
     acc:	006332b3          	sltu	t0,t1,t1
     ad0:	02589a63          	bne	a7,t0,0xb04
     ad4:	00000893          	li	a7,0
     ad8:	00800313          	li	t1,8
     adc:	00000293          	li	t0,0
     ae0:	005332b3          	sltu	t0,t1,t0
     ae4:	02589063          	bne	a7,t0,0xb04
     ae8:	00000893          	li	a7,0
     aec:	80000337          	lui	t1,0x80000
     af0:	00030313          	mv	t1,t1
     af4:	00000293          	li	t0,0
     af8:	005332b3          	sltu	t0,t1,t0
     afc:	00589463          	bne	a7,t0,0xb04
     b00:	00c0006f          	j	0xb0c
     b04:	d74ff0ef          	jal	ra,0x78
     b08:	0080006f          	j	0xb10
     b0c:	d18ff0ef          	jal	ra,0x24
     b10:	00412083          	lw	ra,4(sp)
     b14:	00008067          	ret
     b18:	00112223          	sw	ra,4(sp)
     b1c:	07300513          	li	a0,115
     b20:	cecff0ef          	jal	ra,0xc
     b24:	06c00513          	li	a0,108
     b28:	ce4ff0ef          	jal	ra,0xc
     b2c:	07400513          	li	a0,116
     b30:	cdcff0ef          	jal	ra,0xc
     b34:	06900513          	li	a0,105
     b38:	cd4ff0ef          	jal	ra,0xc
     b3c:	02e00513          	li	a0,46
     b40:	cccff0ef          	jal	ra,0xc
     b44:	02e00513          	li	a0,46
     b48:	cc4ff0ef          	jal	ra,0xc
     b4c:	00000893          	li	a7,0
     b50:	00000313          	li	t1,0
     b54:	00032293          	slti	t0,t1,0
     b58:	06589663          	bne	a7,t0,0xbc4
     b5c:	00100893          	li	a7,1
     b60:	00300313          	li	t1,3
     b64:	00732293          	slti	t0,t1,7
     b68:	04589e63          	bne	a7,t0,0xbc4
     b6c:	00000893          	li	a7,0
     b70:	00700313          	li	t1,7
     b74:	00332293          	slti	t0,t1,3
     b78:	04589663          	bne	a7,t0,0xbc4
     b7c:	00100893          	li	a7,1
     b80:	80000337          	lui	t1,0x80000
     b84:	00030313          	mv	t1,t1
     b88:	00232293          	slti	t0,t1,2
     b8c:	02589c63          	bne	a7,t0,0xbc4
     b90:	00000893          	li	a7,0
     b94:	00800313          	li	t1,8
     b98:	fff32293          	slti	t0,t1,-1
     b9c:	02589463          	bne	a7,t0,0xbc4
     ba0:	00100893          	li	a7,1
     ba4:	00000293          	li	t0,0
     ba8:	0082a293          	slti	t0,t0,8
     bac:	00589c63          	bne	a7,t0,0xbc4
     bb0:	00000893          	li	a7,0
     bb4:	00000293          	li	t0,0
     bb8:	fff2a293          	slti	t0,t0,-1
     bbc:	00589463          	bne	a7,t0,0xbc4
     bc0:	00c0006f          	j	0xbcc
     bc4:	cb4ff0ef          	jal	ra,0x78
     bc8:	0080006f          	j	0xbd0
     bcc:	c58ff0ef          	jal	ra,0x24
     bd0:	00412083          	lw	ra,4(sp)
     bd4:	00008067          	ret
     bd8:	00112223          	sw	ra,4(sp)
     bdc:	07300513          	li	a0,115
     be0:	c2cff0ef          	jal	ra,0xc
     be4:	06c00513          	li	a0,108
     be8:	c24ff0ef          	jal	ra,0xc
     bec:	07400513          	li	a0,116
     bf0:	c1cff0ef          	jal	ra,0xc
     bf4:	06900513          	li	a0,105
     bf8:	c14ff0ef          	jal	ra,0xc
     bfc:	07500513          	li	a0,117
     c00:	c0cff0ef          	jal	ra,0xc
     c04:	02e00513          	li	a0,46
     c08:	c04ff0ef          	jal	ra,0xc
     c0c:	00000893          	li	a7,0
     c10:	00000313          	li	t1,0
     c14:	00033293          	sltiu	t0,t1,0
     c18:	06589663          	bne	a7,t0,0xc84
     c1c:	00100893          	li	a7,1
     c20:	00300313          	li	t1,3
     c24:	00733293          	sltiu	t0,t1,7
     c28:	04589e63          	bne	a7,t0,0xc84
     c2c:	00000893          	li	a7,0
     c30:	00700313          	li	t1,7
     c34:	00333293          	sltiu	t0,t1,3
     c38:	04589663          	bne	a7,t0,0xc84
     c3c:	00000893          	li	a7,0
     c40:	80000337          	lui	t1,0x80000
     c44:	00030313          	mv	t1,t1
     c48:	00233293          	sltiu	t0,t1,2
     c4c:	02589c63          	bne	a7,t0,0xc84
     c50:	00100893          	li	a7,1
     c54:	00800313          	li	t1,8
     c58:	fff33293          	sltiu	t0,t1,-1
     c5c:	02589463          	bne	a7,t0,0xc84
     c60:	00100893          	li	a7,1
     c64:	00000293          	li	t0,0
     c68:	0082b293          	sltiu	t0,t0,8
     c6c:	00589c63          	bne	a7,t0,0xc84
     c70:	00100893          	li	a7,1
     c74:	00000293          	li	t0,0
     c78:	fff2b293          	sltiu	t0,t0,-1
     c7c:	00589463          	bne	a7,t0,0xc84
     c80:	00c0006f          	j	0xc8c
     c84:	bf4ff0ef          	jal	ra,0x78
     c88:	0080006f          	j	0xc90
     c8c:	b98ff0ef          	jal	ra,0x24
     c90:	00412083          	lw	ra,4(sp)
     c94:	00008067          	ret
     c98:	00112223          	sw	ra,4(sp)
     c9c:	07300513          	li	a0,115
     ca0:	b6cff0ef          	jal	ra,0xc
     ca4:	06c00513          	li	a0,108
     ca8:	b64ff0ef          	jal	ra,0xc
     cac:	06c00513          	li	a0,108
     cb0:	b5cff0ef          	jal	ra,0xc
     cb4:	02e00513          	li	a0,46
     cb8:	b54ff0ef          	jal	ra,0xc
     cbc:	02e00513          	li	a0,46
     cc0:	b4cff0ef          	jal	ra,0xc
     cc4:	02e00513          	li	a0,46
     cc8:	b44ff0ef          	jal	ra,0xc
     ccc:	000048b7          	lui	a7,0x4
     cd0:	00088893          	mv	a7,a7
     cd4:	00100313          	li	t1,1
     cd8:	00e00393          	li	t2,14
     cdc:	007312b3          	sll	t0,t1,t2
     ce0:	04589a63          	bne	a7,t0,0xd34
     ce4:	f8000893          	li	a7,-128
     ce8:	fff00313          	li	t1,-1
     cec:	00700393          	li	t2,7
     cf0:	007312b3          	sll	t0,t1,t2
     cf4:	04589063          	bne	a7,t0,0xd34
     cf8:	484848b7          	lui	a7,0x48484
     cfc:	00088893          	mv	a7,a7
     d00:	21212337          	lui	t1,0x21212
     d04:	12130313          	addi	t1,t1,289 # 0x21212121
     d08:	00e00393          	li	t2,14
     d0c:	007312b3          	sll	t0,t1,t2
     d10:	02589263          	bne	a7,t0,0xd34
     d14:	484848b7          	lui	a7,0x48484
     d18:	00088893          	mv	a7,a7
     d1c:	21212337          	lui	t1,0x21212
     d20:	12130313          	addi	t1,t1,289 # 0x21212121
     d24:	fee00393          	li	t2,-18
     d28:	007312b3          	sll	t0,t1,t2
     d2c:	00589463          	bne	a7,t0,0xd34
     d30:	00c0006f          	j	0xd3c
     d34:	b44ff0ef          	jal	ra,0x78
     d38:	0080006f          	j	0xd40
     d3c:	ae8ff0ef          	jal	ra,0x24
     d40:	00412083          	lw	ra,4(sp)
     d44:	00008067          	ret
     d48:	00112223          	sw	ra,4(sp)
     d4c:	07300513          	li	a0,115
     d50:	abcff0ef          	jal	ra,0xc
     d54:	06c00513          	li	a0,108
     d58:	ab4ff0ef          	jal	ra,0xc
     d5c:	06c00513          	li	a0,108
     d60:	aacff0ef          	jal	ra,0xc
     d64:	06900513          	li	a0,105
     d68:	aa4ff0ef          	jal	ra,0xc
     d6c:	02e00513          	li	a0,46
     d70:	a9cff0ef          	jal	ra,0xc
     d74:	02e00513          	li	a0,46
     d78:	a94ff0ef          	jal	ra,0xc
     d7c:	000048b7          	lui	a7,0x4
     d80:	00088893          	mv	a7,a7
     d84:	00100313          	li	t1,1
     d88:	00e31293          	slli	t0,t1,0xe
     d8c:	02589a63          	bne	a7,t0,0xdc0
     d90:	f8000893          	li	a7,-128
     d94:	fff00313          	li	t1,-1
     d98:	00731293          	slli	t0,t1,0x7
     d9c:	02589263          	bne	a7,t0,0xdc0
     da0:	484848b7          	lui	a7,0x48484
     da4:	00088893          	mv	a7,a7
     da8:	21212337          	lui	t1,0x21212
     dac:	12130313          	addi	t1,t1,289 # 0x21212121
     db0:	00e00393          	li	t2,14
     db4:	00e31293          	slli	t0,t1,0xe
     db8:	00589463          	bne	a7,t0,0xdc0
     dbc:	00c0006f          	j	0xdc8
     dc0:	ab8ff0ef          	jal	ra,0x78
     dc4:	0080006f          	j	0xdcc
     dc8:	a5cff0ef          	jal	ra,0x24
     dcc:	00412083          	lw	ra,4(sp)
     dd0:	00008067          	ret
     dd4:	00112223          	sw	ra,4(sp)
     dd8:	07300513          	li	a0,115
     ddc:	a30ff0ef          	jal	ra,0xc
     de0:	07200513          	li	a0,114
     de4:	a28ff0ef          	jal	ra,0xc
     de8:	06c00513          	li	a0,108
     dec:	a20ff0ef          	jal	ra,0xc
     df0:	02e00513          	li	a0,46
     df4:	a18ff0ef          	jal	ra,0xc
     df8:	02e00513          	li	a0,46
     dfc:	a10ff0ef          	jal	ra,0xc
     e00:	02e00513          	li	a0,46
     e04:	a08ff0ef          	jal	ra,0xc
     e08:	020008b7          	lui	a7,0x2000
     e0c:	f0088893          	addi	a7,a7,-256 # 0x1ffff00
     e10:	ffff8337          	lui	t1,0xffff8
     e14:	00030313          	mv	t1,t1
     e18:	00700393          	li	t2,7
     e1c:	007352b3          	srl	t0,t1,t2
     e20:	04589c63          	bne	a7,t0,0xe78
     e24:	000408b7          	lui	a7,0x40
     e28:	fff88893          	addi	a7,a7,-1 # 0x3ffff
     e2c:	fff00313          	li	t1,-1
     e30:	00e00393          	li	t2,14
     e34:	007352b3          	srl	t0,t1,t2
     e38:	04589063          	bne	a7,t0,0xe78
     e3c:	004248b7          	lui	a7,0x424
     e40:	24288893          	addi	a7,a7,578 # 0x424242
     e44:	21212337          	lui	t1,0x21212
     e48:	12130313          	addi	t1,t1,289 # 0x21212121
     e4c:	00700393          	li	t2,7
     e50:	007352b3          	srl	t0,t1,t2
     e54:	02589263          	bne	a7,t0,0xe78
     e58:	000088b7          	lui	a7,0x8
     e5c:	48488893          	addi	a7,a7,1156 # 0x8484
     e60:	21212337          	lui	t1,0x21212
     e64:	12130313          	addi	t1,t1,289 # 0x21212121
     e68:	fee00393          	li	t2,-18
     e6c:	007352b3          	srl	t0,t1,t2
     e70:	00589463          	bne	a7,t0,0xe78
     e74:	00c0006f          	j	0xe80
     e78:	a00ff0ef          	jal	ra,0x78
     e7c:	0080006f          	j	0xe84
     e80:	9a4ff0ef          	jal	ra,0x24
     e84:	00412083          	lw	ra,4(sp)
     e88:	00008067          	ret
     e8c:	00112223          	sw	ra,4(sp)
     e90:	07300513          	li	a0,115
     e94:	978ff0ef          	jal	ra,0xc
     e98:	07200513          	li	a0,114
     e9c:	970ff0ef          	jal	ra,0xc
     ea0:	06c00513          	li	a0,108
     ea4:	968ff0ef          	jal	ra,0xc
     ea8:	06900513          	li	a0,105
     eac:	960ff0ef          	jal	ra,0xc
     eb0:	02e00513          	li	a0,46
     eb4:	958ff0ef          	jal	ra,0xc
     eb8:	02e00513          	li	a0,46
     ebc:	950ff0ef          	jal	ra,0xc
     ec0:	000408b7          	lui	a7,0x40
     ec4:	ffe88893          	addi	a7,a7,-2 # 0x3fffe
     ec8:	ffff8337          	lui	t1,0xffff8
     ecc:	00030313          	mv	t1,t1
     ed0:	00e35293          	srli	t0,t1,0xe
     ed4:	02589c63          	bne	a7,t0,0xf0c
     ed8:	010008b7          	lui	a7,0x1000
     edc:	fff88893          	addi	a7,a7,-1 # 0xffffff
     ee0:	80000337          	lui	t1,0x80000
     ee4:	fff30313          	addi	t1,t1,-1 # 0x7fffffff
     ee8:	00735293          	srli	t0,t1,0x7
     eec:	02589063          	bne	a7,t0,0xf0c
     ef0:	000088b7          	lui	a7,0x8
     ef4:	48488893          	addi	a7,a7,1156 # 0x8484
     ef8:	21212337          	lui	t1,0x21212
     efc:	12130313          	addi	t1,t1,289 # 0x21212121
     f00:	00e35293          	srli	t0,t1,0xe
     f04:	00589463          	bne	a7,t0,0xf0c
     f08:	00c0006f          	j	0xf14
     f0c:	96cff0ef          	jal	ra,0x78
     f10:	0080006f          	j	0xf18
     f14:	910ff0ef          	jal	ra,0x24
     f18:	00412083          	lw	ra,4(sp)
     f1c:	00008067          	ret
     f20:	00112223          	sw	ra,4(sp)
     f24:	07300513          	li	a0,115
     f28:	8e4ff0ef          	jal	ra,0xc
     f2c:	07200513          	li	a0,114
     f30:	8dcff0ef          	jal	ra,0xc
     f34:	06100513          	li	a0,97
     f38:	8d4ff0ef          	jal	ra,0xc
     f3c:	02e00513          	li	a0,46
     f40:	8ccff0ef          	jal	ra,0xc
     f44:	02e00513          	li	a0,46
     f48:	8c4ff0ef          	jal	ra,0xc
     f4c:	02e00513          	li	a0,46
     f50:	8bcff0ef          	jal	ra,0xc
     f54:	f0000893          	li	a7,-256
     f58:	ffff8337          	lui	t1,0xffff8
     f5c:	00030313          	mv	t1,t1
     f60:	00700393          	li	t2,7
     f64:	407352b3          	sra	t0,t1,t2
     f68:	04589a63          	bne	a7,t0,0xfbc
     f6c:	fff00893          	li	a7,-1
     f70:	fff00313          	li	t1,-1
     f74:	00e00393          	li	t2,14
     f78:	407352b3          	sra	t0,t1,t2
     f7c:	04589063          	bne	a7,t0,0xfbc
     f80:	004248b7          	lui	a7,0x424
     f84:	24288893          	addi	a7,a7,578 # 0x424242
     f88:	21212337          	lui	t1,0x21212
     f8c:	12130313          	addi	t1,t1,289 # 0x21212121
     f90:	00700393          	li	t2,7
     f94:	407352b3          	sra	t0,t1,t2
     f98:	02589263          	bne	a7,t0,0xfbc
     f9c:	000088b7          	lui	a7,0x8
     fa0:	48488893          	addi	a7,a7,1156 # 0x8484
     fa4:	21212337          	lui	t1,0x21212
     fa8:	12130313          	addi	t1,t1,289 # 0x21212121
     fac:	fee00393          	li	t2,-18
     fb0:	407352b3          	sra	t0,t1,t2
     fb4:	00589463          	bne	a7,t0,0xfbc
     fb8:	00c0006f          	j	0xfc4
     fbc:	8bcff0ef          	jal	ra,0x78
     fc0:	0080006f          	j	0xfc8
     fc4:	860ff0ef          	jal	ra,0x24
     fc8:	00412083          	lw	ra,4(sp)
     fcc:	00008067          	ret
     fd0:	00112223          	sw	ra,4(sp)
     fd4:	07300513          	li	a0,115
     fd8:	834ff0ef          	jal	ra,0xc
     fdc:	07200513          	li	a0,114
     fe0:	82cff0ef          	jal	ra,0xc
     fe4:	06100513          	li	a0,97
     fe8:	824ff0ef          	jal	ra,0xc
     fec:	06900513          	li	a0,105
     ff0:	81cff0ef          	jal	ra,0xc
     ff4:	02e00513          	li	a0,46
     ff8:	814ff0ef          	jal	ra,0xc
     ffc:	02e00513          	li	a0,46
    1000:	80cff0ef          	jal	ra,0xc
    1004:	ffe00893          	li	a7,-2
    1008:	ffff8337          	lui	t1,0xffff8
    100c:	00030313          	mv	t1,t1
    1010:	40e35293          	srai	t0,t1,0xe
    1014:	02589c63          	bne	a7,t0,0x104c
    1018:	010008b7          	lui	a7,0x1000
    101c:	fff88893          	addi	a7,a7,-1 # 0xffffff
    1020:	80000337          	lui	t1,0x80000
    1024:	fff30313          	addi	t1,t1,-1 # 0x7fffffff
    1028:	40735293          	srai	t0,t1,0x7
    102c:	02589063          	bne	a7,t0,0x104c
    1030:	000088b7          	lui	a7,0x8
    1034:	48488893          	addi	a7,a7,1156 # 0x8484
    1038:	21212337          	lui	t1,0x21212
    103c:	12130313          	addi	t1,t1,289 # 0x21212121
    1040:	40e35293          	srai	t0,t1,0xe
    1044:	00589463          	bne	a7,t0,0x104c
    1048:	00c0006f          	j	0x1054
    104c:	82cff0ef          	jal	ra,0x78
    1050:	0080006f          	j	0x1058
    1054:	fd1fe0ef          	jal	ra,0x24
    1058:	00412083          	lw	ra,4(sp)
    105c:	00008067          	ret
    1060:	00112223          	sw	ra,4(sp)
    1064:	06c00513          	li	a0,108
    1068:	fa5fe0ef          	jal	ra,0xc
    106c:	07700513          	li	a0,119
    1070:	f9dfe0ef          	jal	ra,0xc
    1074:	02e00513          	li	a0,46
    1078:	f95fe0ef          	jal	ra,0xc
    107c:	02e00513          	li	a0,46
    1080:	f8dfe0ef          	jal	ra,0xc
    1084:	02e00513          	li	a0,46
    1088:	f85fe0ef          	jal	ra,0xc
    108c:	02e00513          	li	a0,46
    1090:	f7dfe0ef          	jal	ra,0xc
    1094:	123458b7          	lui	a7,0x12345
    1098:	67888893          	addi	a7,a7,1656 # 0x12345678
    109c:	deadc837          	lui	a6,0xdeadc
    10a0:	eef80813          	addi	a6,a6,-273 # 0xdeadbeef
    10a4:	00003337          	lui	t1,0x3
    10a8:	00030313          	mv	t1,t1
    10ac:	01132023          	sw	a7,0(t1) # 0x3000
    10b0:	01032223          	sw	a6,4(t1)
    10b4:	00032283          	lw	t0,0(t1)
    10b8:	00589a63          	bne	a7,t0,0x10cc
    10bc:	00080893          	mv	a7,a6
    10c0:	00432283          	lw	t0,4(t1)
    10c4:	00589463          	bne	a7,t0,0x10cc
    10c8:	00c0006f          	j	0x10d4
    10cc:	fadfe0ef          	jal	ra,0x78
    10d0:	0080006f          	j	0x10d8
    10d4:	f51fe0ef          	jal	ra,0x24
    10d8:	00412083          	lw	ra,4(sp)
    10dc:	00008067          	ret
    10e0:	00112223          	sw	ra,4(sp)
    10e4:	06c00513          	li	a0,108
    10e8:	f25fe0ef          	jal	ra,0xc
    10ec:	06800513          	li	a0,104
    10f0:	f1dfe0ef          	jal	ra,0xc
    10f4:	02e00513          	li	a0,46
    10f8:	f15fe0ef          	jal	ra,0xc
    10fc:	02e00513          	li	a0,46
    1100:	f0dfe0ef          	jal	ra,0xc
    1104:	02e00513          	li	a0,46
    1108:	f05fe0ef          	jal	ra,0xc
    110c:	02e00513          	li	a0,46
    1110:	efdfe0ef          	jal	ra,0xc
    1114:	123458b7          	lui	a7,0x12345
    1118:	67888893          	addi	a7,a7,1656 # 0x12345678
    111c:	deadc837          	lui	a6,0xdeadc
    1120:	eef80813          	addi	a6,a6,-273 # 0xdeadbeef
    1124:	00003337          	lui	t1,0x3
    1128:	01030313          	addi	t1,t1,16 # 0x3010
    112c:	01132023          	sw	a7,0(t1)
    1130:	01032223          	sw	a6,4(t1)
    1134:	000058b7          	lui	a7,0x5
    1138:	67888893          	addi	a7,a7,1656 # 0x5678
    113c:	00031283          	lh	t0,0(t1)
    1140:	02589c63          	bne	a7,t0,0x1178
    1144:	000018b7          	lui	a7,0x1
    1148:	23488893          	addi	a7,a7,564 # 0x1234
    114c:	00231283          	lh	t0,2(t1)
    1150:	02589463          	bne	a7,t0,0x1178
    1154:	ffffc8b7          	lui	a7,0xffffc
    1158:	eef88893          	addi	a7,a7,-273 # 0xffffbeef
    115c:	00431283          	lh	t0,4(t1)
    1160:	00589c63          	bne	a7,t0,0x1178
    1164:	ffffe8b7          	lui	a7,0xffffe
    1168:	ead88893          	addi	a7,a7,-339 # 0xffffdead
    116c:	00631283          	lh	t0,6(t1)
    1170:	00589463          	bne	a7,t0,0x1178
    1174:	00c0006f          	j	0x1180
    1178:	f01fe0ef          	jal	ra,0x78
    117c:	0080006f          	j	0x1184
    1180:	ea5fe0ef          	jal	ra,0x24
    1184:	00412083          	lw	ra,4(sp)
    1188:	00008067          	ret
    118c:	00112223          	sw	ra,4(sp)
    1190:	06c00513          	li	a0,108
    1194:	e79fe0ef          	jal	ra,0xc
    1198:	06800513          	li	a0,104
    119c:	e71fe0ef          	jal	ra,0xc
    11a0:	07500513          	li	a0,117
    11a4:	e69fe0ef          	jal	ra,0xc
    11a8:	02e00513          	li	a0,46
    11ac:	e61fe0ef          	jal	ra,0xc
    11b0:	02e00513          	li	a0,46
    11b4:	e59fe0ef          	jal	ra,0xc
    11b8:	02e00513          	li	a0,46
    11bc:	e51fe0ef          	jal	ra,0xc
    11c0:	123458b7          	lui	a7,0x12345
    11c4:	67888893          	addi	a7,a7,1656 # 0x12345678
    11c8:	deadc837          	lui	a6,0xdeadc
    11cc:	eef80813          	addi	a6,a6,-273 # 0xdeadbeef
    11d0:	00003337          	lui	t1,0x3
    11d4:	02030313          	addi	t1,t1,32 # 0x3020
    11d8:	01132023          	sw	a7,0(t1)
    11dc:	01032223          	sw	a6,4(t1)
    11e0:	000058b7          	lui	a7,0x5
    11e4:	67888893          	addi	a7,a7,1656 # 0x5678
    11e8:	00035283          	lhu	t0,0(t1)
    11ec:	02589c63          	bne	a7,t0,0x1224
    11f0:	000018b7          	lui	a7,0x1
    11f4:	23488893          	addi	a7,a7,564 # 0x1234
    11f8:	00235283          	lhu	t0,2(t1)
    11fc:	02589463          	bne	a7,t0,0x1224
    1200:	0000c8b7          	lui	a7,0xc
    1204:	eef88893          	addi	a7,a7,-273 # 0xbeef
    1208:	00435283          	lhu	t0,4(t1)
    120c:	00589c63          	bne	a7,t0,0x1224
    1210:	0000e8b7          	lui	a7,0xe
    1214:	ead88893          	addi	a7,a7,-339 # 0xdead
    1218:	00635283          	lhu	t0,6(t1)
    121c:	00589463          	bne	a7,t0,0x1224
    1220:	00c0006f          	j	0x122c
    1224:	e55fe0ef          	jal	ra,0x78
    1228:	0080006f          	j	0x1230
    122c:	df9fe0ef          	jal	ra,0x24
    1230:	00412083          	lw	ra,4(sp)
    1234:	00008067          	ret
    1238:	00112223          	sw	ra,4(sp)
    123c:	06c00513          	li	a0,108
    1240:	dcdfe0ef          	jal	ra,0xc
    1244:	06200513          	li	a0,98
    1248:	dc5fe0ef          	jal	ra,0xc
    124c:	02e00513          	li	a0,46
    1250:	dbdfe0ef          	jal	ra,0xc
    1254:	02e00513          	li	a0,46
    1258:	db5fe0ef          	jal	ra,0xc
    125c:	02e00513          	li	a0,46
    1260:	dadfe0ef          	jal	ra,0xc
    1264:	02e00513          	li	a0,46
    1268:	da5fe0ef          	jal	ra,0xc
    126c:	123458b7          	lui	a7,0x12345
    1270:	67888893          	addi	a7,a7,1656 # 0x12345678
    1274:	deadc837          	lui	a6,0xdeadc
    1278:	eef80813          	addi	a6,a6,-273 # 0xdeadbeef
    127c:	00003337          	lui	t1,0x3
    1280:	02030313          	addi	t1,t1,32 # 0x3020
    1284:	01132023          	sw	a7,0(t1)
    1288:	01032223          	sw	a6,4(t1)
    128c:	07800893          	li	a7,120
    1290:	00030283          	lb	t0,0(t1)
    1294:	02589663          	bne	a7,t0,0x12c0
    1298:	05600893          	li	a7,86
    129c:	00130283          	lb	t0,1(t1)
    12a0:	02589063          	bne	a7,t0,0x12c0
    12a4:	fef00893          	li	a7,-17
    12a8:	00430283          	lb	t0,4(t1)
    12ac:	00589a63          	bne	a7,t0,0x12c0
    12b0:	fde00893          	li	a7,-34
    12b4:	00730283          	lb	t0,7(t1)
    12b8:	00589463          	bne	a7,t0,0x12c0
    12bc:	00c0006f          	j	0x12c8
    12c0:	db9fe0ef          	jal	ra,0x78
    12c4:	0080006f          	j	0x12cc
    12c8:	d5dfe0ef          	jal	ra,0x24
    12cc:	00412083          	lw	ra,4(sp)
    12d0:	00008067          	ret
    12d4:	00112223          	sw	ra,4(sp)
    12d8:	06c00513          	li	a0,108
    12dc:	d31fe0ef          	jal	ra,0xc
    12e0:	06200513          	li	a0,98
    12e4:	d29fe0ef          	jal	ra,0xc
    12e8:	07500513          	li	a0,117
    12ec:	d21fe0ef          	jal	ra,0xc
    12f0:	02e00513          	li	a0,46
    12f4:	d19fe0ef          	jal	ra,0xc
    12f8:	02e00513          	li	a0,46
    12fc:	d11fe0ef          	jal	ra,0xc
    1300:	02e00513          	li	a0,46
    1304:	d09fe0ef          	jal	ra,0xc
    1308:	123458b7          	lui	a7,0x12345
    130c:	67888893          	addi	a7,a7,1656 # 0x12345678
    1310:	deadc837          	lui	a6,0xdeadc
    1314:	eef80813          	addi	a6,a6,-273 # 0xdeadbeef
    1318:	00003337          	lui	t1,0x3
    131c:	04030313          	addi	t1,t1,64 # 0x3040
    1320:	01132023          	sw	a7,0(t1)
    1324:	01032223          	sw	a6,4(t1)
    1328:	07800893          	li	a7,120
    132c:	00034283          	lbu	t0,0(t1)
    1330:	02589663          	bne	a7,t0,0x135c
    1334:	05600893          	li	a7,86
    1338:	00134283          	lbu	t0,1(t1)
    133c:	02589063          	bne	a7,t0,0x135c
    1340:	0ef00893          	li	a7,239
    1344:	00434283          	lbu	t0,4(t1)
    1348:	00589a63          	bne	a7,t0,0x135c
    134c:	0de00893          	li	a7,222
    1350:	00734283          	lbu	t0,7(t1)
    1354:	00589463          	bne	a7,t0,0x135c
    1358:	00c0006f          	j	0x1364
    135c:	d1dfe0ef          	jal	ra,0x78
    1360:	0080006f          	j	0x1368
    1364:	cc1fe0ef          	jal	ra,0x24
    1368:	00412083          	lw	ra,4(sp)
    136c:	00008067          	ret
    1370:	00112223          	sw	ra,4(sp)
    1374:	07300513          	li	a0,115
    1378:	c95fe0ef          	jal	ra,0xc
    137c:	07700513          	li	a0,119
    1380:	c8dfe0ef          	jal	ra,0xc
    1384:	02e00513          	li	a0,46
    1388:	c85fe0ef          	jal	ra,0xc
    138c:	02e00513          	li	a0,46
    1390:	c7dfe0ef          	jal	ra,0xc
    1394:	02e00513          	li	a0,46
    1398:	c75fe0ef          	jal	ra,0xc
    139c:	02e00513          	li	a0,46
    13a0:	c6dfe0ef          	jal	ra,0xc
    13a4:	123458b7          	lui	a7,0x12345
    13a8:	67888893          	addi	a7,a7,1656 # 0x12345678
    13ac:	deadc837          	lui	a6,0xdeadc
    13b0:	eef80813          	addi	a6,a6,-273 # 0xdeadbeef
    13b4:	00003337          	lui	t1,0x3
    13b8:	05030313          	addi	t1,t1,80 # 0x3050
    13bc:	01132023          	sw	a7,0(t1)
    13c0:	01032223          	sw	a6,4(t1)
    13c4:	00032283          	lw	t0,0(t1)
    13c8:	00589a63          	bne	a7,t0,0x13dc
    13cc:	00080893          	mv	a7,a6
    13d0:	00432283          	lw	t0,4(t1)
    13d4:	00589463          	bne	a7,t0,0x13dc
    13d8:	00c0006f          	j	0x13e4
    13dc:	c9dfe0ef          	jal	ra,0x78
    13e0:	0080006f          	j	0x13e8
    13e4:	c41fe0ef          	jal	ra,0x24
    13e8:	00412083          	lw	ra,4(sp)
    13ec:	00008067          	ret
    13f0:	00112223          	sw	ra,4(sp)
    13f4:	07300513          	li	a0,115
    13f8:	c15fe0ef          	jal	ra,0xc
    13fc:	06800513          	li	a0,104
    1400:	c0dfe0ef          	jal	ra,0xc
    1404:	02e00513          	li	a0,46
    1408:	c05fe0ef          	jal	ra,0xc
    140c:	02e00513          	li	a0,46
    1410:	bfdfe0ef          	jal	ra,0xc
    1414:	02e00513          	li	a0,46
    1418:	bf5fe0ef          	jal	ra,0xc
    141c:	02e00513          	li	a0,46
    1420:	bedfe0ef          	jal	ra,0xc
    1424:	123458b7          	lui	a7,0x12345
    1428:	67888893          	addi	a7,a7,1656 # 0x12345678
    142c:	deadc837          	lui	a6,0xdeadc
    1430:	eef80813          	addi	a6,a6,-273 # 0xdeadbeef
    1434:	00003337          	lui	t1,0x3
    1438:	06030313          	addi	t1,t1,96 # 0x3060
    143c:	01131023          	sh	a7,0(t1)
    1440:	01031223          	sh	a6,4(t1)
    1444:	01131323          	sh	a7,6(t1)
    1448:	000058b7          	lui	a7,0x5
    144c:	67888893          	addi	a7,a7,1656 # 0x5678
    1450:	00032283          	lw	t0,0(t1)
    1454:	00589c63          	bne	a7,t0,0x146c
    1458:	5678c8b7          	lui	a7,0x5678c
    145c:	eef88893          	addi	a7,a7,-273 # 0x5678beef
    1460:	00432283          	lw	t0,4(t1)
    1464:	00589463          	bne	a7,t0,0x146c
    1468:	00c0006f          	j	0x1474
    146c:	c0dfe0ef          	jal	ra,0x78
    1470:	0080006f          	j	0x1478
    1474:	bb1fe0ef          	jal	ra,0x24
    1478:	00412083          	lw	ra,4(sp)
    147c:	00008067          	ret
    1480:	00112223          	sw	ra,4(sp)
    1484:	07300513          	li	a0,115
    1488:	b85fe0ef          	jal	ra,0xc
    148c:	06200513          	li	a0,98
    1490:	b7dfe0ef          	jal	ra,0xc
    1494:	02e00513          	li	a0,46
    1498:	b75fe0ef          	jal	ra,0xc
    149c:	02e00513          	li	a0,46
    14a0:	b6dfe0ef          	jal	ra,0xc
    14a4:	02e00513          	li	a0,46
    14a8:	b65fe0ef          	jal	ra,0xc
    14ac:	02e00513          	li	a0,46
    14b0:	b5dfe0ef          	jal	ra,0xc
    14b4:	123458b7          	lui	a7,0x12345
    14b8:	67888893          	addi	a7,a7,1656 # 0x12345678
    14bc:	deadc837          	lui	a6,0xdeadc
    14c0:	eef80813          	addi	a6,a6,-273 # 0xdeadbeef
    14c4:	00003337          	lui	t1,0x3
    14c8:	07030313          	addi	t1,t1,112 # 0x3070
    14cc:	01130023          	sb	a7,0(t1)
    14d0:	010300a3          	sb	a6,1(t1)
    14d4:	01130123          	sb	a7,2(t1)
    14d8:	011301a3          	sb	a7,3(t1)
    14dc:	7878f8b7          	lui	a7,0x7878f
    14e0:	f7888893          	addi	a7,a7,-136 # 0x7878ef78
    14e4:	00032283          	lw	t0,0(t1)
    14e8:	00589463          	bne	a7,t0,0x14f0
    14ec:	00c0006f          	j	0x14f8
    14f0:	b89fe0ef          	jal	ra,0x78
    14f4:	0080006f          	j	0x14fc
    14f8:	b2dfe0ef          	jal	ra,0x24
    14fc:	00412083          	lw	ra,4(sp)
    1500:	00008067          	ret
    1504:	00112223          	sw	ra,4(sp)
    1508:	06100513          	li	a0,97
    150c:	b01fe0ef          	jal	ra,0xc
    1510:	07500513          	li	a0,117
    1514:	af9fe0ef          	jal	ra,0xc
    1518:	06900513          	li	a0,105
    151c:	af1fe0ef          	jal	ra,0xc
    1520:	07000513          	li	a0,112
    1524:	ae9fe0ef          	jal	ra,0xc
    1528:	06300513          	li	a0,99
    152c:	ae1fe0ef          	jal	ra,0xc
    1530:	02e00513          	li	a0,46
    1534:	ad9fe0ef          	jal	ra,0xc
    1538:	00007297          	auipc	t0,0x7
    153c:	00000897          	auipc	a7,0x0
    1540:	ffc88893          	addi	a7,a7,-4 # 0x1538
    1544:	00700313          	li	t1,7
    1548:	00c31313          	slli	t1,t1,0xc
    154c:	006888b3          	add	a7,a7,t1
    1550:	00589463          	bne	a7,t0,0x1558
    1554:	00c0006f          	j	0x1560
    1558:	b21fe0ef          	jal	ra,0x78
    155c:	0080006f          	j	0x1564
    1560:	ac5fe0ef          	jal	ra,0x24
    1564:	00412083          	lw	ra,4(sp)
    1568:	00008067          	ret
    156c:	00112223          	sw	ra,4(sp)
    1570:	06c00513          	li	a0,108
    1574:	a99fe0ef          	jal	ra,0xc
    1578:	07500513          	li	a0,117
    157c:	a91fe0ef          	jal	ra,0xc
    1580:	06900513          	li	a0,105
    1584:	a89fe0ef          	jal	ra,0xc
    1588:	02e00513          	li	a0,46
    158c:	a81fe0ef          	jal	ra,0xc
    1590:	02e00513          	li	a0,46
    1594:	a79fe0ef          	jal	ra,0xc
    1598:	02e00513          	li	a0,46
    159c:	a71fe0ef          	jal	ra,0xc
    15a0:	000072b7          	lui	t0,0x7
    15a4:	00700893          	li	a7,7
    15a8:	00c89893          	slli	a7,a7,0xc
    15ac:	00589463          	bne	a7,t0,0x15b4
    15b0:	00c0006f          	j	0x15bc
    15b4:	ac5fe0ef          	jal	ra,0x78
    15b8:	0080006f          	j	0x15c0
    15bc:	a69fe0ef          	jal	ra,0x24
    15c0:	00412083          	lw	ra,4(sp)
    15c4:	00008067          	ret
    15c8:	00112223          	sw	ra,4(sp)
    15cc:	06200513          	li	a0,98
    15d0:	a3dfe0ef          	jal	ra,0xc
    15d4:	06500513          	li	a0,101
    15d8:	a35fe0ef          	jal	ra,0xc
    15dc:	07100513          	li	a0,113
    15e0:	a2dfe0ef          	jal	ra,0xc
    15e4:	02e00513          	li	a0,46
    15e8:	a25fe0ef          	jal	ra,0xc
    15ec:	02e00513          	li	a0,46
    15f0:	a1dfe0ef          	jal	ra,0xc
    15f4:	02e00513          	li	a0,46
    15f8:	a15fe0ef          	jal	ra,0xc
    15fc:	00000293          	li	t0,0
    1600:	00000313          	li	t1,0
    1604:	00628663          	beq	t0,t1,0x1610
    1608:	0a40006f          	j	0x16ac
    160c:	00c0006f          	j	0x1618
    1610:	fe628ee3          	beq	t0,t1,0x160c
    1614:	0980006f          	j	0x16ac
    1618:	00100293          	li	t0,1
    161c:	00100313          	li	t1,1
    1620:	00628663          	beq	t0,t1,0x162c
    1624:	0880006f          	j	0x16ac
    1628:	00c0006f          	j	0x1634
    162c:	fe628ee3          	beq	t0,t1,0x1628
    1630:	07c0006f          	j	0x16ac
    1634:	fff00293          	li	t0,-1
    1638:	fff00313          	li	t1,-1
    163c:	00628663          	beq	t0,t1,0x1648
    1640:	06c0006f          	j	0x16ac
    1644:	00c0006f          	j	0x1650
    1648:	fe628ee3          	beq	t0,t1,0x1644
    164c:	0600006f          	j	0x16ac
    1650:	00100293          	li	t0,1
    1654:	fff00313          	li	t1,-1
    1658:	04628a63          	beq	t0,t1,0x16ac
    165c:	0080006f          	j	0x1664
    1660:	04c0006f          	j	0x16ac
    1664:	fe628ee3          	beq	t0,t1,0x1660
    1668:	00100293          	li	t0,1
    166c:	00528663          	beq	t0,t0,0x1678
    1670:	03c0006f          	j	0x16ac
    1674:	00c0006f          	j	0x1680
    1678:	fe528ee3          	beq	t0,t0,0x1674
    167c:	0300006f          	j	0x16ac
    1680:	00100293          	li	t0,1
    1684:	00000013          	nop
    1688:	00000013          	nop
    168c:	00100313          	li	t1,1
    1690:	00000013          	nop
    1694:	00628663          	beq	t0,t1,0x16a0
    1698:	0140006f          	j	0x16ac
    169c:	00c0006f          	j	0x16a8
    16a0:	fe628ee3          	beq	t0,t1,0x169c
    16a4:	0080006f          	j	0x16ac
    16a8:	00c0006f          	j	0x16b4
    16ac:	9cdfe0ef          	jal	ra,0x78
    16b0:	0080006f          	j	0x16b8
    16b4:	971fe0ef          	jal	ra,0x24
    16b8:	00412083          	lw	ra,4(sp)
    16bc:	00008067          	ret
    16c0:	00112223          	sw	ra,4(sp)
    16c4:	06200513          	li	a0,98
    16c8:	945fe0ef          	jal	ra,0xc
    16cc:	06e00513          	li	a0,110
    16d0:	93dfe0ef          	jal	ra,0xc
    16d4:	06500513          	li	a0,101
    16d8:	935fe0ef          	jal	ra,0xc
    16dc:	02e00513          	li	a0,46
    16e0:	92dfe0ef          	jal	ra,0xc
    16e4:	02e00513          	li	a0,46
    16e8:	925fe0ef          	jal	ra,0xc
    16ec:	02e00513          	li	a0,46
    16f0:	91dfe0ef          	jal	ra,0xc
    16f4:	00000293          	li	t0,0
    16f8:	00100313          	li	t1,1
    16fc:	00629663          	bne	t0,t1,0x1708
    1700:	0a00006f          	j	0x17a0
    1704:	00c0006f          	j	0x1710
    1708:	fe629ee3          	bne	t0,t1,0x1704
    170c:	0940006f          	j	0x17a0
    1710:	00100293          	li	t0,1
    1714:	fff00313          	li	t1,-1
    1718:	00629663          	bne	t0,t1,0x1724
    171c:	0840006f          	j	0x17a0
    1720:	00c0006f          	j	0x172c
    1724:	fe629ee3          	bne	t0,t1,0x1720
    1728:	0780006f          	j	0x17a0
    172c:	fff00293          	li	t0,-1
    1730:	00100313          	li	t1,1
    1734:	00629663          	bne	t0,t1,0x1740
    1738:	0680006f          	j	0x17a0
    173c:	00c0006f          	j	0x1748
    1740:	fe629ee3          	bne	t0,t1,0x173c
    1744:	05c0006f          	j	0x17a0
    1748:	00100293          	li	t0,1
    174c:	00100313          	li	t1,1
    1750:	04629863          	bne	t0,t1,0x17a0
    1754:	0080006f          	j	0x175c
    1758:	0480006f          	j	0x17a0
    175c:	fe629ee3          	bne	t0,t1,0x1758
    1760:	00100293          	li	t0,1
    1764:	02529e63          	bne	t0,t0,0x17a0
    1768:	0080006f          	j	0x1770
    176c:	0340006f          	j	0x17a0
    1770:	fe529ee3          	bne	t0,t0,0x176c
    1774:	00100293          	li	t0,1
    1778:	00000013          	nop
    177c:	00000013          	nop
    1780:	fff00313          	li	t1,-1
    1784:	00000013          	nop
    1788:	00629663          	bne	t0,t1,0x1794
    178c:	0140006f          	j	0x17a0
    1790:	00c0006f          	j	0x179c
    1794:	fe629ee3          	bne	t0,t1,0x1790
    1798:	0080006f          	j	0x17a0
    179c:	00c0006f          	j	0x17a8
    17a0:	8d9fe0ef          	jal	ra,0x78
    17a4:	0080006f          	j	0x17ac
    17a8:	87dfe0ef          	jal	ra,0x24
    17ac:	00412083          	lw	ra,4(sp)
    17b0:	00008067          	ret
    17b4:	00112223          	sw	ra,4(sp)
    17b8:	06200513          	li	a0,98
    17bc:	851fe0ef          	jal	ra,0xc
    17c0:	06c00513          	li	a0,108
    17c4:	849fe0ef          	jal	ra,0xc
    17c8:	07400513          	li	a0,116
    17cc:	841fe0ef          	jal	ra,0xc
    17d0:	02e00513          	li	a0,46
    17d4:	839fe0ef          	jal	ra,0xc
    17d8:	02e00513          	li	a0,46
    17dc:	831fe0ef          	jal	ra,0xc
    17e0:	02e00513          	li	a0,46
    17e4:	829fe0ef          	jal	ra,0xc
    17e8:	00000293          	li	t0,0
    17ec:	00100313          	li	t1,1
    17f0:	0062c663          	blt	t0,t1,0x17fc
    17f4:	09c0006f          	j	0x1890
    17f8:	00c0006f          	j	0x1804
    17fc:	fe62cee3          	blt	t0,t1,0x17f8
    1800:	0900006f          	j	0x1890
    1804:	fff00293          	li	t0,-1
    1808:	00100313          	li	t1,1
    180c:	0062c663          	blt	t0,t1,0x1818
    1810:	0800006f          	j	0x1890
    1814:	00c0006f          	j	0x1820
    1818:	fe62cee3          	blt	t0,t1,0x1814
    181c:	0740006f          	j	0x1890
    1820:	00100293          	li	t0,1
    1824:	fff00313          	li	t1,-1
    1828:	0662c463          	blt	t0,t1,0x1890
    182c:	0080006f          	j	0x1834
    1830:	0600006f          	j	0x1890
    1834:	fe62cee3          	blt	t0,t1,0x1830
    1838:	fff00293          	li	t0,-1
    183c:	ffe00313          	li	t1,-2
    1840:	0462c863          	blt	t0,t1,0x1890
    1844:	0080006f          	j	0x184c
    1848:	0480006f          	j	0x1890
    184c:	fe62cee3          	blt	t0,t1,0x1848
    1850:	00100293          	li	t0,1
    1854:	0252ce63          	blt	t0,t0,0x1890
    1858:	0080006f          	j	0x1860
    185c:	0340006f          	j	0x1890
    1860:	fe52cee3          	blt	t0,t0,0x185c
    1864:	00000293          	li	t0,0
    1868:	00000013          	nop
    186c:	00000013          	nop
    1870:	00100313          	li	t1,1
    1874:	00000013          	nop
    1878:	0062c663          	blt	t0,t1,0x1884
    187c:	0140006f          	j	0x1890
    1880:	00c0006f          	j	0x188c
    1884:	fe62cee3          	blt	t0,t1,0x1880
    1888:	0080006f          	j	0x1890
    188c:	00c0006f          	j	0x1898
    1890:	fe8fe0ef          	jal	ra,0x78
    1894:	0080006f          	j	0x189c
    1898:	f8cfe0ef          	jal	ra,0x24
    189c:	00412083          	lw	ra,4(sp)
    18a0:	00008067          	ret
    18a4:	00112223          	sw	ra,4(sp)
    18a8:	06200513          	li	a0,98
    18ac:	f60fe0ef          	jal	ra,0xc
    18b0:	06c00513          	li	a0,108
    18b4:	f58fe0ef          	jal	ra,0xc
    18b8:	07400513          	li	a0,116
    18bc:	f50fe0ef          	jal	ra,0xc
    18c0:	07500513          	li	a0,117
    18c4:	f48fe0ef          	jal	ra,0xc
    18c8:	02e00513          	li	a0,46
    18cc:	f40fe0ef          	jal	ra,0xc
    18d0:	02e00513          	li	a0,46
    18d4:	f38fe0ef          	jal	ra,0xc
    18d8:	00000293          	li	t0,0
    18dc:	00100313          	li	t1,1
    18e0:	0062e663          	bltu	t0,t1,0x18ec
    18e4:	09c0006f          	j	0x1980
    18e8:	00c0006f          	j	0x18f4
    18ec:	fe62eee3          	bltu	t0,t1,0x18e8
    18f0:	0900006f          	j	0x1980
    18f4:	00100293          	li	t0,1
    18f8:	fff00313          	li	t1,-1
    18fc:	0062e663          	bltu	t0,t1,0x1908
    1900:	0800006f          	j	0x1980
    1904:	00c0006f          	j	0x1910
    1908:	fe62eee3          	bltu	t0,t1,0x1904
    190c:	0740006f          	j	0x1980
    1910:	fff00293          	li	t0,-1
    1914:	ffe00313          	li	t1,-2
    1918:	0662e463          	bltu	t0,t1,0x1980
    191c:	0080006f          	j	0x1924
    1920:	0600006f          	j	0x1980
    1924:	fe62eee3          	bltu	t0,t1,0x1920
    1928:	fff00293          	li	t0,-1
    192c:	00100313          	li	t1,1
    1930:	0462e863          	bltu	t0,t1,0x1980
    1934:	0080006f          	j	0x193c
    1938:	0480006f          	j	0x1980
    193c:	fe62eee3          	bltu	t0,t1,0x1938
    1940:	00100293          	li	t0,1
    1944:	0252ee63          	bltu	t0,t0,0x1980
    1948:	0080006f          	j	0x1950
    194c:	0340006f          	j	0x1980
    1950:	fe52eee3          	bltu	t0,t0,0x194c
    1954:	00000293          	li	t0,0
    1958:	00000013          	nop
    195c:	00000013          	nop
    1960:	00100313          	li	t1,1
    1964:	00000013          	nop
    1968:	0062e663          	bltu	t0,t1,0x1974
    196c:	0140006f          	j	0x1980
    1970:	00c0006f          	j	0x197c
    1974:	fe62eee3          	bltu	t0,t1,0x1970
    1978:	0080006f          	j	0x1980
    197c:	00c0006f          	j	0x1988
    1980:	ef8fe0ef          	jal	ra,0x78
    1984:	0080006f          	j	0x198c
    1988:	e9cfe0ef          	jal	ra,0x24
    198c:	00412083          	lw	ra,4(sp)
    1990:	00008067          	ret
    1994:	00112223          	sw	ra,4(sp)
    1998:	06200513          	li	a0,98
    199c:	e70fe0ef          	jal	ra,0xc
    19a0:	06700513          	li	a0,103
    19a4:	e68fe0ef          	jal	ra,0xc
    19a8:	06500513          	li	a0,101
    19ac:	e60fe0ef          	jal	ra,0xc
    19b0:	02e00513          	li	a0,46
    19b4:	e58fe0ef          	jal	ra,0xc
    19b8:	02e00513          	li	a0,46
    19bc:	e50fe0ef          	jal	ra,0xc
    19c0:	02e00513          	li	a0,46
    19c4:	e48fe0ef          	jal	ra,0xc
    19c8:	00100293          	li	t0,1
    19cc:	00000313          	li	t1,0
    19d0:	0062d663          	bge	t0,t1,0x19dc
    19d4:	0a00006f          	j	0x1a74
    19d8:	00c0006f          	j	0x19e4
    19dc:	fe62dee3          	bge	t0,t1,0x19d8
    19e0:	0940006f          	j	0x1a74
    19e4:	00100293          	li	t0,1
    19e8:	fff00313          	li	t1,-1
    19ec:	0062d663          	bge	t0,t1,0x19f8
    19f0:	0840006f          	j	0x1a74
    19f4:	00c0006f          	j	0x1a00
    19f8:	fe62dee3          	bge	t0,t1,0x19f4
    19fc:	0780006f          	j	0x1a74
    1a00:	fff00293          	li	t0,-1
    1a04:	00100313          	li	t1,1
    1a08:	0662d663          	bge	t0,t1,0x1a74
    1a0c:	0080006f          	j	0x1a14
    1a10:	0640006f          	j	0x1a74
    1a14:	fe62dee3          	bge	t0,t1,0x1a10
    1a18:	ffe00293          	li	t0,-2
    1a1c:	fff00313          	li	t1,-1
    1a20:	0462da63          	bge	t0,t1,0x1a74
    1a24:	0080006f          	j	0x1a2c
    1a28:	04c0006f          	j	0x1a74
    1a2c:	fe62dee3          	bge	t0,t1,0x1a28
    1a30:	00100293          	li	t0,1
    1a34:	0052d663          	bge	t0,t0,0x1a40
    1a38:	03c0006f          	j	0x1a74
    1a3c:	00c0006f          	j	0x1a48
    1a40:	fe52dee3          	bge	t0,t0,0x1a3c
    1a44:	0300006f          	j	0x1a74
    1a48:	00100293          	li	t0,1
    1a4c:	00000013          	nop
    1a50:	00000013          	nop
    1a54:	fff00313          	li	t1,-1
    1a58:	00000013          	nop
    1a5c:	0062d663          	bge	t0,t1,0x1a68
    1a60:	0140006f          	j	0x1a74
    1a64:	00c0006f          	j	0x1a70
    1a68:	fe62dee3          	bge	t0,t1,0x1a64
    1a6c:	0080006f          	j	0x1a74
    1a70:	00c0006f          	j	0x1a7c
    1a74:	e04fe0ef          	jal	ra,0x78
    1a78:	0080006f          	j	0x1a80
    1a7c:	da8fe0ef          	jal	ra,0x24
    1a80:	00412083          	lw	ra,4(sp)
    1a84:	00008067          	ret
    1a88:	00112223          	sw	ra,4(sp)
    1a8c:	06200513          	li	a0,98
    1a90:	d7cfe0ef          	jal	ra,0xc
    1a94:	06700513          	li	a0,103
    1a98:	d74fe0ef          	jal	ra,0xc
    1a9c:	06500513          	li	a0,101
    1aa0:	d6cfe0ef          	jal	ra,0xc
    1aa4:	07500513          	li	a0,117
    1aa8:	d64fe0ef          	jal	ra,0xc
    1aac:	02e00513          	li	a0,46
    1ab0:	d5cfe0ef          	jal	ra,0xc
    1ab4:	02e00513          	li	a0,46
    1ab8:	d54fe0ef          	jal	ra,0xc
    1abc:	00100293          	li	t0,1
    1ac0:	00000313          	li	t1,0
    1ac4:	0062f663          	bgeu	t0,t1,0x1ad0
    1ac8:	0a00006f          	j	0x1b68
    1acc:	00c0006f          	j	0x1ad8
    1ad0:	fe62fee3          	bgeu	t0,t1,0x1acc
    1ad4:	0940006f          	j	0x1b68
    1ad8:	fff00293          	li	t0,-1
    1adc:	00100313          	li	t1,1
    1ae0:	0062f663          	bgeu	t0,t1,0x1aec
    1ae4:	0840006f          	j	0x1b68
    1ae8:	00c0006f          	j	0x1af4
    1aec:	fe62fee3          	bgeu	t0,t1,0x1ae8
    1af0:	0780006f          	j	0x1b68
    1af4:	00100293          	li	t0,1
    1af8:	fff00313          	li	t1,-1
    1afc:	0662f663          	bgeu	t0,t1,0x1b68
    1b00:	0080006f          	j	0x1b08
    1b04:	0640006f          	j	0x1b68
    1b08:	fe62fee3          	bgeu	t0,t1,0x1b04
    1b0c:	ffe00293          	li	t0,-2
    1b10:	fff00313          	li	t1,-1
    1b14:	0462fa63          	bgeu	t0,t1,0x1b68
    1b18:	0080006f          	j	0x1b20
    1b1c:	04c0006f          	j	0x1b68
    1b20:	fe62fee3          	bgeu	t0,t1,0x1b1c
    1b24:	00100293          	li	t0,1
    1b28:	0052f663          	bgeu	t0,t0,0x1b34
    1b2c:	03c0006f          	j	0x1b68
    1b30:	00c0006f          	j	0x1b3c
    1b34:	fe52fee3          	bgeu	t0,t0,0x1b30
    1b38:	0300006f          	j	0x1b68
    1b3c:	fff00293          	li	t0,-1
    1b40:	00000013          	nop
    1b44:	00000013          	nop
    1b48:	00100313          	li	t1,1
    1b4c:	00000013          	nop
    1b50:	0062f663          	bgeu	t0,t1,0x1b5c
    1b54:	0140006f          	j	0x1b68
    1b58:	00c0006f          	j	0x1b64
    1b5c:	fe62fee3          	bgeu	t0,t1,0x1b58
    1b60:	0080006f          	j	0x1b68
    1b64:	00c0006f          	j	0x1b70
    1b68:	d10fe0ef          	jal	ra,0x78
    1b6c:	0080006f          	j	0x1b74
    1b70:	cb4fe0ef          	jal	ra,0x24
    1b74:	00412083          	lw	ra,4(sp)
    1b78:	00008067          	ret
    1b7c:	00112223          	sw	ra,4(sp)
    1b80:	06a00513          	li	a0,106
    1b84:	c88fe0ef          	jal	ra,0xc
    1b88:	06100513          	li	a0,97
    1b8c:	c80fe0ef          	jal	ra,0xc
    1b90:	06c00513          	li	a0,108
    1b94:	c78fe0ef          	jal	ra,0xc
    1b98:	02e00513          	li	a0,46
    1b9c:	c70fe0ef          	jal	ra,0xc
    1ba0:	02e00513          	li	a0,46
    1ba4:	c68fe0ef          	jal	ra,0xc
    1ba8:	02e00513          	li	a0,46
    1bac:	c60fe0ef          	jal	ra,0xc
    1bb0:	00c0006f          	j	0x1bbc
    1bb4:	cc4fe0ef          	jal	ra,0x78
    1bb8:	0080006f          	j	0x1bc0
    1bbc:	c68fe0ef          	jal	ra,0x24
    1bc0:	00412083          	lw	ra,4(sp)
    1bc4:	00008067          	ret
    1bc8:	00112223          	sw	ra,4(sp)
    1bcc:	06a00513          	li	a0,106
    1bd0:	c3cfe0ef          	jal	ra,0xc
    1bd4:	06100513          	li	a0,97
    1bd8:	c34fe0ef          	jal	ra,0xc
    1bdc:	06c00513          	li	a0,108
    1be0:	c2cfe0ef          	jal	ra,0xc
    1be4:	07200513          	li	a0,114
    1be8:	c24fe0ef          	jal	ra,0xc
    1bec:	02e00513          	li	a0,46
    1bf0:	c1cfe0ef          	jal	ra,0xc
    1bf4:	02e00513          	li	a0,46
    1bf8:	c14fe0ef          	jal	ra,0xc
    1bfc:	00c0006f          	j	0x1c08
    1c00:	c78fe0ef          	jal	ra,0x78
    1c04:	0080006f          	j	0x1c0c
    1c08:	c1cfe0ef          	jal	ra,0x24
    1c0c:	00412083          	lw	ra,4(sp)
    1c10:	00008067          	ret
    1c14:	00112223          	sw	ra,4(sp)
    1c18:	06d00513          	li	a0,109
    1c1c:	bf0fe0ef          	jal	ra,0xc
    1c20:	06100513          	li	a0,97
    1c24:	be8fe0ef          	jal	ra,0xc
    1c28:	06c00513          	li	a0,108
    1c2c:	be0fe0ef          	jal	ra,0xc
    1c30:	06700513          	li	a0,103
    1c34:	bd8fe0ef          	jal	ra,0xc
    1c38:	06e00513          	li	a0,110
    1c3c:	bd0fe0ef          	jal	ra,0xc
    1c40:	02e00513          	li	a0,46
    1c44:	bc8fe0ef          	jal	ra,0xc
    1c48:	123458b7          	lui	a7,0x12345
    1c4c:	67888893          	addi	a7,a7,1656 # 0x12345678
    1c50:	deadc837          	lui	a6,0xdeadc
    1c54:	eef80813          	addi	a6,a6,-273 # 0xdeadbeef
    1c58:	00003337          	lui	t1,0x3
    1c5c:	00030313          	mv	t1,t1
    1c60:	01132023          	sw	a7,0(t1) # 0x3000
    1c64:	01032223          	sw	a6,4(t1)
    1c68:	beef18b7          	lui	a7,0xbeef1
    1c6c:	23488893          	addi	a7,a7,564 # 0xbeef1234
    1c70:	00232283          	lw	t0,2(t1)
    1c74:	00589463          	bne	a7,t0,0x1c7c
    1c78:	00c0006f          	j	0x1c84
    1c7c:	bfcfe0ef          	jal	ra,0x78
    1c80:	0080006f          	j	0x1c88
    1c84:	ba0fe0ef          	jal	ra,0x24
    1c88:	00412083          	lw	ra,4(sp)
    1c8c:	00008067          	ret
    1c90:	00c0006f          	j	0x1c9c
    1c94:	be4fe0ef          	jal	ra,0x78
    1c98:	0080006f          	j	0x1ca0
    1c9c:	bdcfe0ef          	jal	ra,0x78
    1ca0:	00412083          	lw	ra,4(sp)
    1ca4:	00008067          	ret
    1ca8:	00112223          	sw	ra,4(sp)
    1cac:	06900513          	li	a0,105
    1cb0:	b5cfe0ef          	jal	ra,0xc
    1cb4:	06f00513          	li	a0,111
    1cb8:	b54fe0ef          	jal	ra,0xc
    1cbc:	07300513          	li	a0,115
    1cc0:	b4cfe0ef          	jal	ra,0xc
    1cc4:	07700513          	li	a0,119
    1cc8:	b44fe0ef          	jal	ra,0xc
    1ccc:	02e00513          	li	a0,46
    1cd0:	b3cfe0ef          	jal	ra,0xc
    1cd4:	02e00513          	li	a0,46
    1cd8:	b34fe0ef          	jal	ra,0xc
    1cdc:	10010337          	lui	t1,0x10010
    1ce0:	00030313          	mv	t1,t1
    1ce4:	00032283          	lw	t0,0(t1) # 0x10010000
    1ce8:	123458b7          	lui	a7,0x12345
    1cec:	67888893          	addi	a7,a7,1656 # 0x12345678
    1cf0:	00589463          	bne	a7,t0,0x1cf8
    1cf4:	00c0006f          	j	0x1d00
    1cf8:	b80fe0ef          	jal	ra,0x78
    1cfc:	0080006f          	j	0x1d04
    1d00:	b24fe0ef          	jal	ra,0x24
    1d04:	00412083          	lw	ra,4(sp)
    1d08:	00008067          	ret
	...
