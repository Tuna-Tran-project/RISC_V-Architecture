
stopwatch_hardware.bin:     file format binary


Disassembly of section .data:

00000000 <.data>:
   0:	0010                	0x10
   2:	3729                	jal	0xffffff0c
   4:	0010                	0x10
   6:	b739                	j	0xffffff14
   8:	0110                	addi	a2,sp,128
   a:	370a                	fld	fa4,160(sp)
   c:	0000                	unimp
   e:	9302                	jalr	t1
  10:	0000                	unimp
  12:	00001303          	lh	t1,0(zero) # 0x0
  16:	00009303          	lh	t1,0(ra)
  1a:	130e                	slli	t1,t1,0x23
  1c:	0000                	unimp
  1e:	930e                	add	t1,t1,gp
  20:	0000                	unimp
  22:	0a00130f          	0xa00130f
  26:	8328                	0x8328
  28:	1800                	addi	s0,sp,48
  2a:	93f8                	0x93f8
  2c:	0806                	slli	a6,a6,0x1
  2e:	638a                	flw	ft7,128(sp)
  30:	803e                	c.mv	zero,a5
  32:	0000130b          	0x130b
  36:	3728                	fld	fa0,104(a4)
  38:	0871                	addi	a6,a6,28
  3a:	1308                	addi	a0,sp,416
  3c:	f8ff                	0xf8ff
  3e:	1308                	addi	a0,sp,416
  40:	08fe                	slli	a7,a7,0x1f
  42:	e31e                	fsw	ft7,132(sp)
  44:	fbff                	0xfbff
  46:	0bfe130b          	0xbfe130b
  4a:	e316                	fsw	ft5,132(sp)
  4c:	1200                	addi	s0,sp,288
  4e:	9382                	jalr	t2
  50:	a000                	fsd	fs0,0(s0)
  52:	1308                	addi	a0,sp,416
  54:	0205                	addi	tp,tp,1
  56:	63c6                	flw	ft7,80(sp)
  58:	0000                	unimp
  5a:	9302                	jalr	t1
  5c:	1300                	addi	s0,sp,416
  5e:	03051303          	lh	t1,48(a0)
  62:	6340                	flw	fs0,4(a4)
  64:	0000                	unimp
  66:	13001303          	lh	t1,304(zero) # 0x130
  6a:	03039383          	lh	t2,48(t2)
  6e:	63ca                	flw	ft7,144(sp)
  70:	0000                	unimp
  72:	1e009303          	lh	t1,480(ra)
  76:	130e                	slli	t1,t1,0x23
  78:	6000                	flw	fs0,0(s0)
  7a:	1308                	addi	a0,sp,416
  7c:	63420e03          	lb	t3,1588(tp) # 0x634
  80:	0000                	unimp
  82:	130e                	slli	t1,t1,0x23
  84:	1e00                	addi	s0,sp,816
  86:	938e                	add	t2,t2,gp
  88:	a000                	fsd	fs0,0(s0)
  8a:	1308                	addi	a0,sp,416
  8c:	0e01                	addi	t3,t3,0
  8e:	63ca                	flw	ft7,144(sp)
  90:	0000                	unimp
  92:	930e                	add	t1,t1,gp
  94:	1f00                	addi	s0,sp,944
  96:	0f01130f          	0xf01130f
  9a:	6344                	flw	fs1,4(a4)
  9c:	0000                	unimp
  9e:	0200130f          	0x200130f
  a2:	1385                	addi	t2,t2,-31
  a4:	0504                	addi	s1,sp,640
  a6:	6308                	flw	fa0,0(a4)
  a8:	1000                	addi	s0,sp,32
  aa:	9305                	srli	a4,a4,0x21
  ac:	b504                	fsd	fs1,40(a0)
  ae:	6308                	flw	fa0,0(a4)
  b0:	2000                	fld	fs0,0(s0)
  b2:	9305                	srli	a4,a4,0x21
  b4:	b504                	fsd	fs1,40(a0)
  b6:	6308                	flw	fa0,0(a4)
  b8:	3000                	fld	fs0,32(s0)
  ba:	9305                	srli	a4,a4,0x21
  bc:	b504                	fsd	fs1,40(a0)
  be:	6308                	flw	fa0,0(a4)
  c0:	4000                	lw	s0,0(s0)
  c2:	9305                	srli	a4,a4,0x21
  c4:	b504                	fsd	fs1,40(a0)
  c6:	6308                	flw	fa0,0(a4)
  c8:	5000                	lw	s0,32(s0)
  ca:	9305                	srli	a4,a4,0x21
  cc:	b504                	fsd	fs1,40(a0)
  ce:	6308                	flw	fa0,0(a4)
  d0:	6000                	flw	fs0,0(s0)
  d2:	9305                	srli	a4,a4,0x21
  d4:	b504                	fsd	fs1,40(a0)
  d6:	6308                	flw	fa0,0(a4)
  d8:	7000                	flw	fs0,32(s0)
  da:	9305                	srli	a4,a4,0x21
  dc:	b504                	fsd	fs1,40(a0)
  de:	6308                	flw	fa0,0(a4)
  e0:	8000                	0x8000
  e2:	9305                	srli	a4,a4,0x21
  e4:	b504                	fsd	fs1,40(a0)
  e6:	6308                	flw	fa0,0(a4)
  e8:	9000                	0x9000
  ea:	9305                	srli	a4,a4,0x21
  ec:	b504                	fsd	fs1,40(a0)
  ee:	6308                	flw	fa0,0(a4)
  f0:	0005                	c.nop	1
  f2:	6f00                	flw	fs0,24(a4)
  f4:	0004                	0x4
  f6:	1305                	addi	t1,t1,-31
  f8:	8004                	0x8004
  fa:	6f00                	flw	fs0,24(a4)
  fc:	13059007          	0x13059007
 100:	0004                	0x4
 102:	6f00                	flw	fs0,24(a4)
 104:	4002                	0x4002
 106:	1305                	addi	t1,t1,-31
 108:	6f008003          	lb	zero,1776(ra)
 10c:	13050003          	lb	zero,304(a0)
 110:	6f000003          	lb	zero,1776(zero) # 0x6f0
 114:	9001                	srli	s0,s0,0x20
 116:	1305                	addi	t1,t1,-31
 118:	8002                	0x8002
 11a:	6f00                	flw	fs0,24(a4)
 11c:	2001                	jal	0x11c
 11e:	1305                	addi	t1,t1,-31
 120:	0002                	c.slli64	zero
 122:	6f00                	flw	fs0,24(a4)
 124:	2000                	fld	fs0,0(s0)
 126:	1305                	addi	t1,t1,-31
 128:	8001                	c.srli64	s0
 12a:	6f00                	flw	fs0,24(a4)
 12c:	13058007          	0x13058007
 130:	0001                	nop
 132:	6f00                	flw	fs0,24(a4)
 134:	0000                	unimp
 136:	1305                	addi	t1,t1,-31
 138:	8000                	0x8000
 13a:	6f00                	flw	fs0,24(a4)
 13c:	0001                	nop
 13e:	1305                	addi	t1,t1,-31
 140:	a900                	fsd	fs0,16(a0)
 142:	2300                	fld	fs0,0(a4)
 144:	0300                	addi	s0,sp,384
 146:	1305                	addi	t1,t1,-31
 148:	0504                	addi	s1,sp,640
 14a:	6308                	flw	fa0,0(a4)
 14c:	1000                	addi	s0,sp,32
 14e:	9305                	srli	a4,a4,0x21
 150:	b504                	fsd	fs1,40(a0)
 152:	6308                	flw	fa0,0(a4)
 154:	2000                	fld	fs0,0(s0)
 156:	9305                	srli	a4,a4,0x21
 158:	b504                	fsd	fs1,40(a0)
 15a:	6308                	flw	fa0,0(a4)
 15c:	3000                	fld	fs0,32(s0)
 15e:	9305                	srli	a4,a4,0x21
 160:	b504                	fsd	fs1,40(a0)
 162:	6308                	flw	fa0,0(a4)
 164:	4000                	lw	s0,0(s0)
 166:	9305                	srli	a4,a4,0x21
 168:	b504                	fsd	fs1,40(a0)
 16a:	6308                	flw	fa0,0(a4)
 16c:	5000                	lw	s0,32(s0)
 16e:	9305                	srli	a4,a4,0x21
 170:	b504                	fsd	fs1,40(a0)
 172:	6308                	flw	fa0,0(a4)
 174:	6000                	flw	fs0,0(s0)
 176:	9305                	srli	a4,a4,0x21
 178:	b504                	fsd	fs1,40(a0)
 17a:	6308                	flw	fa0,0(a4)
 17c:	7000                	flw	fs0,32(s0)
 17e:	9305                	srli	a4,a4,0x21
 180:	b504                	fsd	fs1,40(a0)
 182:	6308                	flw	fa0,0(a4)
 184:	8000                	0x8000
 186:	9305                	srli	a4,a4,0x21
 188:	b504                	fsd	fs1,40(a0)
 18a:	6308                	flw	fa0,0(a4)
 18c:	9000                	0x9000
 18e:	9305                	srli	a4,a4,0x21
 190:	b504                	fsd	fs1,40(a0)
 192:	6308                	flw	fa0,0(a4)
 194:	0005                	c.nop	1
 196:	6f00                	flw	fs0,24(a4)
 198:	0004                	0x4
 19a:	1305                	addi	t1,t1,-31
 19c:	8004                	0x8004
 19e:	6f00                	flw	fs0,24(a4)
 1a0:	13059007          	0x13059007
 1a4:	0004                	0x4
 1a6:	6f00                	flw	fs0,24(a4)
 1a8:	4002                	0x4002
 1aa:	1305                	addi	t1,t1,-31
 1ac:	6f008003          	lb	zero,1776(ra)
 1b0:	13050003          	lb	zero,304(a0)
 1b4:	6f000003          	lb	zero,1776(zero) # 0x6f0
 1b8:	9001                	srli	s0,s0,0x20
 1ba:	1305                	addi	t1,t1,-31
 1bc:	8002                	0x8002
 1be:	6f00                	flw	fs0,24(a4)
 1c0:	2001                	jal	0x1c0
 1c2:	1305                	addi	t1,t1,-31
 1c4:	0002                	c.slli64	zero
 1c6:	6f00                	flw	fs0,24(a4)
 1c8:	2000                	fld	fs0,0(s0)
 1ca:	1305                	addi	t1,t1,-31
 1cc:	8001                	c.srli64	s0
 1ce:	6f00                	flw	fs0,24(a4)
 1d0:	13058007          	0x13058007
 1d4:	0001                	nop
 1d6:	6f00                	flw	fs0,24(a4)
 1d8:	0000                	unimp
 1da:	1305                	addi	t1,t1,-31
 1dc:	8000                	0x8000
 1de:	6f00                	flw	fs0,24(a4)
 1e0:	0001                	nop
 1e2:	1305                	addi	t1,t1,-31
 1e4:	a900                	fsd	fs0,16(a0)
 1e6:	a300                	fsd	fs0,0(a4)
 1e8:	0300                	addi	s0,sp,384
 1ea:	1385                	addi	t2,t2,-31
 1ec:	0504                	addi	s1,sp,640
 1ee:	6308                	flw	fa0,0(a4)
 1f0:	1000                	addi	s0,sp,32
 1f2:	9305                	srli	a4,a4,0x21
 1f4:	b504                	fsd	fs1,40(a0)
 1f6:	6308                	flw	fa0,0(a4)
 1f8:	2000                	fld	fs0,0(s0)
 1fa:	9305                	srli	a4,a4,0x21
 1fc:	b504                	fsd	fs1,40(a0)
 1fe:	6308                	flw	fa0,0(a4)
 200:	3000                	fld	fs0,32(s0)
 202:	9305                	srli	a4,a4,0x21
 204:	b504                	fsd	fs1,40(a0)
 206:	6308                	flw	fa0,0(a4)
 208:	4000                	lw	s0,0(s0)
 20a:	9305                	srli	a4,a4,0x21
 20c:	b504                	fsd	fs1,40(a0)
 20e:	6308                	flw	fa0,0(a4)
 210:	5000                	lw	s0,32(s0)
 212:	9305                	srli	a4,a4,0x21
 214:	b504                	fsd	fs1,40(a0)
 216:	6308                	flw	fa0,0(a4)
 218:	6000                	flw	fs0,0(s0)
 21a:	9305                	srli	a4,a4,0x21
 21c:	b504                	fsd	fs1,40(a0)
 21e:	6308                	flw	fa0,0(a4)
 220:	7000                	flw	fs0,32(s0)
 222:	9305                	srli	a4,a4,0x21
 224:	b504                	fsd	fs1,40(a0)
 226:	6308                	flw	fa0,0(a4)
 228:	8000                	0x8000
 22a:	9305                	srli	a4,a4,0x21
 22c:	b504                	fsd	fs1,40(a0)
 22e:	6308                	flw	fa0,0(a4)
 230:	9000                	0x9000
 232:	9305                	srli	a4,a4,0x21
 234:	b504                	fsd	fs1,40(a0)
 236:	6308                	flw	fa0,0(a4)
 238:	0005                	c.nop	1
 23a:	6f00                	flw	fs0,24(a4)
 23c:	0004                	0x4
 23e:	1305                	addi	t1,t1,-31
 240:	8004                	0x8004
 242:	6f00                	flw	fs0,24(a4)
 244:	13059007          	0x13059007
 248:	0004                	0x4
 24a:	6f00                	flw	fs0,24(a4)
 24c:	4002                	0x4002
 24e:	1305                	addi	t1,t1,-31
 250:	6f008003          	lb	zero,1776(ra)
 254:	13050003          	lb	zero,304(a0)
 258:	6f000003          	lb	zero,1776(zero) # 0x6f0
 25c:	9001                	srli	s0,s0,0x20
 25e:	1305                	addi	t1,t1,-31
 260:	8002                	0x8002
 262:	6f00                	flw	fs0,24(a4)
 264:	2001                	jal	0x264
 266:	1305                	addi	t1,t1,-31
 268:	0002                	c.slli64	zero
 26a:	6f00                	flw	fs0,24(a4)
 26c:	2000                	fld	fs0,0(s0)
 26e:	1305                	addi	t1,t1,-31
 270:	8001                	c.srli64	s0
 272:	6f00                	flw	fs0,24(a4)
 274:	13058007          	0x13058007
 278:	0001                	nop
 27a:	6f00                	flw	fs0,24(a4)
 27c:	0000                	unimp
 27e:	1305                	addi	t1,t1,-31
 280:	8000                	0x8000
 282:	6f00                	flw	fs0,24(a4)
 284:	0001                	nop
 286:	1305                	addi	t1,t1,-31
 288:	a900                	fsd	fs0,16(a0)
 28a:	2301                	jal	0x78a
 28c:	0e00                	addi	s0,sp,784
 28e:	1305                	addi	t1,t1,-31
 290:	0502                	c.slli64	a0
 292:	6308                	flw	fa0,0(a4)
 294:	1000                	addi	s0,sp,32
 296:	9305                	srli	a4,a4,0x21
 298:	b502                	fsd	ft0,168(sp)
 29a:	6308                	flw	fa0,0(a4)
 29c:	2000                	fld	fs0,0(s0)
 29e:	9305                	srli	a4,a4,0x21
 2a0:	b502                	fsd	ft0,168(sp)
 2a2:	6308                	flw	fa0,0(a4)
 2a4:	3000                	fld	fs0,32(s0)
 2a6:	9305                	srli	a4,a4,0x21
 2a8:	b502                	fsd	ft0,168(sp)
 2aa:	6308                	flw	fa0,0(a4)
 2ac:	4000                	lw	s0,0(s0)
 2ae:	9305                	srli	a4,a4,0x21
 2b0:	b502                	fsd	ft0,168(sp)
 2b2:	6308                	flw	fa0,0(a4)
 2b4:	5000                	lw	s0,32(s0)
 2b6:	9305                	srli	a4,a4,0x21
 2b8:	b502                	fsd	ft0,168(sp)
 2ba:	6308                	flw	fa0,0(a4)
 2bc:	6f000003          	lb	zero,1776(zero) # 0x6f0
 2c0:	0004                	0x4
 2c2:	1305                	addi	t1,t1,-31
 2c4:	8002                	0x8002
 2c6:	6f00                	flw	fs0,24(a4)
 2c8:	13059007          	0x13059007
 2cc:	0002                	c.slli64	zero
 2ce:	6f00                	flw	fs0,24(a4)
 2d0:	4002                	0x4002
 2d2:	1305                	addi	t1,t1,-31
 2d4:	8001                	c.srli64	s0
 2d6:	6f00                	flw	fs0,24(a4)
 2d8:	13050003          	lb	zero,304(a0)
 2dc:	0001                	nop
 2de:	6f00                	flw	fs0,24(a4)
 2e0:	9001                	srli	s0,s0,0x20
 2e2:	1305                	addi	t1,t1,-31
 2e4:	8000                	0x8000
 2e6:	6f00                	flw	fs0,24(a4)
 2e8:	2001                	jal	0x2e8
 2ea:	1305                	addi	t1,t1,-31
 2ec:	a900                	fsd	fs0,16(a0)
 2ee:	a301                	j	0x7ee
 2f0:	0e00                	addi	s0,sp,784
 2f2:	1385                	addi	t2,t2,-31
 2f4:	0504                	addi	s1,sp,640
 2f6:	6308                	flw	fa0,0(a4)
 2f8:	1000                	addi	s0,sp,32
 2fa:	9305                	srli	a4,a4,0x21
 2fc:	b504                	fsd	fs1,40(a0)
 2fe:	6308                	flw	fa0,0(a4)
 300:	2000                	fld	fs0,0(s0)
 302:	9305                	srli	a4,a4,0x21
 304:	b504                	fsd	fs1,40(a0)
 306:	6308                	flw	fa0,0(a4)
 308:	3000                	fld	fs0,32(s0)
 30a:	9305                	srli	a4,a4,0x21
 30c:	b504                	fsd	fs1,40(a0)
 30e:	6308                	flw	fa0,0(a4)
 310:	4000                	lw	s0,0(s0)
 312:	9305                	srli	a4,a4,0x21
 314:	b504                	fsd	fs1,40(a0)
 316:	6308                	flw	fa0,0(a4)
 318:	5000                	lw	s0,32(s0)
 31a:	9305                	srli	a4,a4,0x21
 31c:	b504                	fsd	fs1,40(a0)
 31e:	6308                	flw	fa0,0(a4)
 320:	6000                	flw	fs0,0(s0)
 322:	9305                	srli	a4,a4,0x21
 324:	b504                	fsd	fs1,40(a0)
 326:	6308                	flw	fa0,0(a4)
 328:	7000                	flw	fs0,32(s0)
 32a:	9305                	srli	a4,a4,0x21
 32c:	b504                	fsd	fs1,40(a0)
 32e:	6308                	flw	fa0,0(a4)
 330:	8000                	0x8000
 332:	9305                	srli	a4,a4,0x21
 334:	b504                	fsd	fs1,40(a0)
 336:	6308                	flw	fa0,0(a4)
 338:	9000                	0x9000
 33a:	9305                	srli	a4,a4,0x21
 33c:	b504                	fsd	fs1,40(a0)
 33e:	6308                	flw	fa0,0(a4)
 340:	0005                	c.nop	1
 342:	6f00                	flw	fs0,24(a4)
 344:	0004                	0x4
 346:	1305                	addi	t1,t1,-31
 348:	8004                	0x8004
 34a:	6f00                	flw	fs0,24(a4)
 34c:	13059007          	0x13059007
 350:	0004                	0x4
 352:	6f00                	flw	fs0,24(a4)
 354:	4002                	0x4002
 356:	1305                	addi	t1,t1,-31
 358:	6f008003          	lb	zero,1776(ra)
 35c:	13050003          	lb	zero,304(a0)
 360:	6f000003          	lb	zero,1776(zero) # 0x6f0
 364:	9001                	srli	s0,s0,0x20
 366:	1305                	addi	t1,t1,-31
 368:	8002                	0x8002
 36a:	6f00                	flw	fs0,24(a4)
 36c:	2001                	jal	0x36c
 36e:	1305                	addi	t1,t1,-31
 370:	0002                	c.slli64	zero
 372:	6f00                	flw	fs0,24(a4)
 374:	2000                	fld	fs0,0(s0)
 376:	1305                	addi	t1,t1,-31
 378:	8001                	c.srli64	s0
 37a:	6f00                	flw	fs0,24(a4)
 37c:	13058007          	0x13058007
 380:	0001                	nop
 382:	6f00                	flw	fs0,24(a4)
 384:	0000                	unimp
 386:	1305                	addi	t1,t1,-31
 388:	8000                	0x8000
 38a:	6f00                	flw	fs0,24(a4)
 38c:	0001                	nop
 38e:	1305                	addi	t1,t1,-31
 390:	a900                	fsd	fs0,16(a0)
 392:	2380                	fld	fs0,0(a5)
 394:	0f00                	addi	s0,sp,912
 396:	1305                	addi	t1,t1,-31
 398:	0504                	addi	s1,sp,640
 39a:	6308                	flw	fa0,0(a4)
 39c:	1000                	addi	s0,sp,32
 39e:	9305                	srli	a4,a4,0x21
 3a0:	b504                	fsd	fs1,40(a0)
 3a2:	6308                	flw	fa0,0(a4)
 3a4:	2000                	fld	fs0,0(s0)
 3a6:	9305                	srli	a4,a4,0x21
 3a8:	b504                	fsd	fs1,40(a0)
 3aa:	6308                	flw	fa0,0(a4)
 3ac:	3000                	fld	fs0,32(s0)
 3ae:	9305                	srli	a4,a4,0x21
 3b0:	b504                	fsd	fs1,40(a0)
 3b2:	6308                	flw	fa0,0(a4)
 3b4:	4000                	lw	s0,0(s0)
 3b6:	9305                	srli	a4,a4,0x21
 3b8:	b504                	fsd	fs1,40(a0)
 3ba:	6308                	flw	fa0,0(a4)
 3bc:	5000                	lw	s0,32(s0)
 3be:	9305                	srli	a4,a4,0x21
 3c0:	b504                	fsd	fs1,40(a0)
 3c2:	6308                	flw	fa0,0(a4)
 3c4:	6000                	flw	fs0,0(s0)
 3c6:	9305                	srli	a4,a4,0x21
 3c8:	b504                	fsd	fs1,40(a0)
 3ca:	6308                	flw	fa0,0(a4)
 3cc:	7000                	flw	fs0,32(s0)
 3ce:	9305                	srli	a4,a4,0x21
 3d0:	b504                	fsd	fs1,40(a0)
 3d2:	6308                	flw	fa0,0(a4)
 3d4:	8000                	0x8000
 3d6:	9305                	srli	a4,a4,0x21
 3d8:	b504                	fsd	fs1,40(a0)
 3da:	6308                	flw	fa0,0(a4)
 3dc:	9000                	0x9000
 3de:	9305                	srli	a4,a4,0x21
 3e0:	b504                	fsd	fs1,40(a0)
 3e2:	6308                	flw	fa0,0(a4)
 3e4:	0005                	c.nop	1
 3e6:	6f00                	flw	fs0,24(a4)
 3e8:	0004                	0x4
 3ea:	1305                	addi	t1,t1,-31
 3ec:	8004                	0x8004
 3ee:	6f00                	flw	fs0,24(a4)
 3f0:	13059007          	0x13059007
 3f4:	0004                	0x4
 3f6:	6f00                	flw	fs0,24(a4)
 3f8:	4002                	0x4002
 3fa:	1305                	addi	t1,t1,-31
 3fc:	6f008003          	lb	zero,1776(ra)
 400:	13050003          	lb	zero,304(a0)
 404:	6f000003          	lb	zero,1776(zero) # 0x6f0
 408:	9001                	srli	s0,s0,0x20
 40a:	1305                	addi	t1,t1,-31
 40c:	8002                	0x8002
 40e:	6f00                	flw	fs0,24(a4)
 410:	2001                	jal	0x410
 412:	1305                	addi	t1,t1,-31
 414:	0002                	c.slli64	zero
 416:	6f00                	flw	fs0,24(a4)
 418:	2000                	fld	fs0,0(s0)
 41a:	1305                	addi	t1,t1,-31
 41c:	8001                	c.srli64	s0
 41e:	6f00                	flw	fs0,24(a4)
 420:	13058007          	0x13058007
 424:	0001                	nop
 426:	6f00                	flw	fs0,24(a4)
 428:	0000                	unimp
 42a:	1305                	addi	t1,t1,-31
 42c:	8000                	0x8000
 42e:	6f00                	flw	fs0,24(a4)
 430:	0001                	nop
 432:	1305                	addi	t1,t1,-31
 434:	a900                	fsd	fs0,16(a0)
 436:	a380                	fsd	fs0,0(a5)
 438:	1305f007          	0x1305f007
 43c:	a900                	fsd	fs0,16(a0)
 43e:	2381                	jal	0x97e
 440:	a900                	fsd	fs0,16(a0)
 442:	a381                	j	0x982
 444:	1fbe                	slli	t6,t6,0x2f
 446:	6ff0                	flw	fa2,92(a5)
