
stopwatch_fast.bin:     file format binary


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
  2e:	6382                	flw	ft7,0(sp)
  30:	a000                	fsd	fs0,0(s0)
  32:	1308                	addi	a0,sp,416
  34:	f8ff                	0xf8ff
  36:	1308                	addi	a0,sp,416
  38:	08fe                	slli	a7,a7,0x1f
  3a:	e31e                	fsw	ft7,132(sp)
  3c:	1200                	addi	s0,sp,288
  3e:	9382                	jalr	t2
  40:	a000                	fsd	fs0,0(s0)
  42:	1308                	addi	a0,sp,416
  44:	0205                	addi	tp,tp,1
  46:	63c6                	flw	ft7,80(sp)
  48:	0000                	unimp
  4a:	9302                	jalr	t1
  4c:	1300                	addi	s0,sp,416
  4e:	03051303          	lh	t1,48(a0)
  52:	6340                	flw	fs0,4(a4)
  54:	0000                	unimp
  56:	13001303          	lh	t1,304(zero) # 0x130
  5a:	03039383          	lh	t2,48(t2)
  5e:	63ca                	flw	ft7,144(sp)
  60:	0000                	unimp
  62:	1e009303          	lh	t1,480(ra)
  66:	130e                	slli	t1,t1,0x23
  68:	6000                	flw	fs0,0(s0)
  6a:	1308                	addi	a0,sp,416
  6c:	63420e03          	lb	t3,1588(tp) # 0x634
  70:	0000                	unimp
  72:	130e                	slli	t1,t1,0x23
  74:	1e00                	addi	s0,sp,816
  76:	938e                	add	t2,t2,gp
  78:	a000                	fsd	fs0,0(s0)
  7a:	1308                	addi	a0,sp,416
  7c:	0e01                	addi	t3,t3,0
  7e:	63ca                	flw	ft7,144(sp)
  80:	0000                	unimp
  82:	930e                	add	t1,t1,gp
  84:	1f00                	addi	s0,sp,944
  86:	0f01130f          	0xf01130f
  8a:	6344                	flw	fs1,4(a4)
  8c:	0000                	unimp
  8e:	0200130f          	0x200130f
  92:	1385                	addi	t2,t2,-31
  94:	0504                	addi	s1,sp,640
  96:	6308                	flw	fa0,0(a4)
  98:	1000                	addi	s0,sp,32
  9a:	9305                	srli	a4,a4,0x21
  9c:	b504                	fsd	fs1,40(a0)
  9e:	6308                	flw	fa0,0(a4)
  a0:	2000                	fld	fs0,0(s0)
  a2:	9305                	srli	a4,a4,0x21
  a4:	b504                	fsd	fs1,40(a0)
  a6:	6308                	flw	fa0,0(a4)
  a8:	3000                	fld	fs0,32(s0)
  aa:	9305                	srli	a4,a4,0x21
  ac:	b504                	fsd	fs1,40(a0)
  ae:	6308                	flw	fa0,0(a4)
  b0:	4000                	lw	s0,0(s0)
  b2:	9305                	srli	a4,a4,0x21
  b4:	b504                	fsd	fs1,40(a0)
  b6:	6308                	flw	fa0,0(a4)
  b8:	5000                	lw	s0,32(s0)
  ba:	9305                	srli	a4,a4,0x21
  bc:	b504                	fsd	fs1,40(a0)
  be:	6308                	flw	fa0,0(a4)
  c0:	6000                	flw	fs0,0(s0)
  c2:	9305                	srli	a4,a4,0x21
  c4:	b504                	fsd	fs1,40(a0)
  c6:	6308                	flw	fa0,0(a4)
  c8:	7000                	flw	fs0,32(s0)
  ca:	9305                	srli	a4,a4,0x21
  cc:	b504                	fsd	fs1,40(a0)
  ce:	6308                	flw	fa0,0(a4)
  d0:	8000                	0x8000
  d2:	9305                	srli	a4,a4,0x21
  d4:	b504                	fsd	fs1,40(a0)
  d6:	6308                	flw	fa0,0(a4)
  d8:	9000                	0x9000
  da:	9305                	srli	a4,a4,0x21
  dc:	b504                	fsd	fs1,40(a0)
  de:	6308                	flw	fa0,0(a4)
  e0:	0005                	c.nop	1
  e2:	6f00                	flw	fs0,24(a4)
  e4:	0004                	0x4
  e6:	1305                	addi	t1,t1,-31
  e8:	8004                	0x8004
  ea:	6f00                	flw	fs0,24(a4)
  ec:	13059007          	0x13059007
  f0:	0004                	0x4
  f2:	6f00                	flw	fs0,24(a4)
  f4:	4002                	0x4002
  f6:	1305                	addi	t1,t1,-31
  f8:	6f008003          	lb	zero,1776(ra)
  fc:	13050003          	lb	zero,304(a0)
 100:	6f000003          	lb	zero,1776(zero) # 0x6f0
 104:	9001                	srli	s0,s0,0x20
 106:	1305                	addi	t1,t1,-31
 108:	8002                	0x8002
 10a:	6f00                	flw	fs0,24(a4)
 10c:	2001                	jal	0x10c
 10e:	1305                	addi	t1,t1,-31
 110:	0002                	c.slli64	zero
 112:	6f00                	flw	fs0,24(a4)
 114:	2000                	fld	fs0,0(s0)
 116:	1305                	addi	t1,t1,-31
 118:	8001                	c.srli64	s0
 11a:	6f00                	flw	fs0,24(a4)
 11c:	13058007          	0x13058007
 120:	0001                	nop
 122:	6f00                	flw	fs0,24(a4)
 124:	0000                	unimp
 126:	1305                	addi	t1,t1,-31
 128:	8000                	0x8000
 12a:	6f00                	flw	fs0,24(a4)
 12c:	0001                	nop
 12e:	1305                	addi	t1,t1,-31
 130:	a900                	fsd	fs0,16(a0)
 132:	2300                	fld	fs0,0(a4)
 134:	0300                	addi	s0,sp,384
 136:	1305                	addi	t1,t1,-31
 138:	0504                	addi	s1,sp,640
 13a:	6308                	flw	fa0,0(a4)
 13c:	1000                	addi	s0,sp,32
 13e:	9305                	srli	a4,a4,0x21
 140:	b504                	fsd	fs1,40(a0)
 142:	6308                	flw	fa0,0(a4)
 144:	2000                	fld	fs0,0(s0)
 146:	9305                	srli	a4,a4,0x21
 148:	b504                	fsd	fs1,40(a0)
 14a:	6308                	flw	fa0,0(a4)
 14c:	3000                	fld	fs0,32(s0)
 14e:	9305                	srli	a4,a4,0x21
 150:	b504                	fsd	fs1,40(a0)
 152:	6308                	flw	fa0,0(a4)
 154:	4000                	lw	s0,0(s0)
 156:	9305                	srli	a4,a4,0x21
 158:	b504                	fsd	fs1,40(a0)
 15a:	6308                	flw	fa0,0(a4)
 15c:	5000                	lw	s0,32(s0)
 15e:	9305                	srli	a4,a4,0x21
 160:	b504                	fsd	fs1,40(a0)
 162:	6308                	flw	fa0,0(a4)
 164:	6000                	flw	fs0,0(s0)
 166:	9305                	srli	a4,a4,0x21
 168:	b504                	fsd	fs1,40(a0)
 16a:	6308                	flw	fa0,0(a4)
 16c:	7000                	flw	fs0,32(s0)
 16e:	9305                	srli	a4,a4,0x21
 170:	b504                	fsd	fs1,40(a0)
 172:	6308                	flw	fa0,0(a4)
 174:	8000                	0x8000
 176:	9305                	srli	a4,a4,0x21
 178:	b504                	fsd	fs1,40(a0)
 17a:	6308                	flw	fa0,0(a4)
 17c:	9000                	0x9000
 17e:	9305                	srli	a4,a4,0x21
 180:	b504                	fsd	fs1,40(a0)
 182:	6308                	flw	fa0,0(a4)
 184:	0005                	c.nop	1
 186:	6f00                	flw	fs0,24(a4)
 188:	0004                	0x4
 18a:	1305                	addi	t1,t1,-31
 18c:	8004                	0x8004
 18e:	6f00                	flw	fs0,24(a4)
 190:	13059007          	0x13059007
 194:	0004                	0x4
 196:	6f00                	flw	fs0,24(a4)
 198:	4002                	0x4002
 19a:	1305                	addi	t1,t1,-31
 19c:	6f008003          	lb	zero,1776(ra)
 1a0:	13050003          	lb	zero,304(a0)
 1a4:	6f000003          	lb	zero,1776(zero) # 0x6f0
 1a8:	9001                	srli	s0,s0,0x20
 1aa:	1305                	addi	t1,t1,-31
 1ac:	8002                	0x8002
 1ae:	6f00                	flw	fs0,24(a4)
 1b0:	2001                	jal	0x1b0
 1b2:	1305                	addi	t1,t1,-31
 1b4:	0002                	c.slli64	zero
 1b6:	6f00                	flw	fs0,24(a4)
 1b8:	2000                	fld	fs0,0(s0)
 1ba:	1305                	addi	t1,t1,-31
 1bc:	8001                	c.srli64	s0
 1be:	6f00                	flw	fs0,24(a4)
 1c0:	13058007          	0x13058007
 1c4:	0001                	nop
 1c6:	6f00                	flw	fs0,24(a4)
 1c8:	0000                	unimp
 1ca:	1305                	addi	t1,t1,-31
 1cc:	8000                	0x8000
 1ce:	6f00                	flw	fs0,24(a4)
 1d0:	0001                	nop
 1d2:	1305                	addi	t1,t1,-31
 1d4:	a900                	fsd	fs0,16(a0)
 1d6:	a300                	fsd	fs0,0(a4)
 1d8:	0300                	addi	s0,sp,384
 1da:	1385                	addi	t2,t2,-31
 1dc:	0504                	addi	s1,sp,640
 1de:	6308                	flw	fa0,0(a4)
 1e0:	1000                	addi	s0,sp,32
 1e2:	9305                	srli	a4,a4,0x21
 1e4:	b504                	fsd	fs1,40(a0)
 1e6:	6308                	flw	fa0,0(a4)
 1e8:	2000                	fld	fs0,0(s0)
 1ea:	9305                	srli	a4,a4,0x21
 1ec:	b504                	fsd	fs1,40(a0)
 1ee:	6308                	flw	fa0,0(a4)
 1f0:	3000                	fld	fs0,32(s0)
 1f2:	9305                	srli	a4,a4,0x21
 1f4:	b504                	fsd	fs1,40(a0)
 1f6:	6308                	flw	fa0,0(a4)
 1f8:	4000                	lw	s0,0(s0)
 1fa:	9305                	srli	a4,a4,0x21
 1fc:	b504                	fsd	fs1,40(a0)
 1fe:	6308                	flw	fa0,0(a4)
 200:	5000                	lw	s0,32(s0)
 202:	9305                	srli	a4,a4,0x21
 204:	b504                	fsd	fs1,40(a0)
 206:	6308                	flw	fa0,0(a4)
 208:	6000                	flw	fs0,0(s0)
 20a:	9305                	srli	a4,a4,0x21
 20c:	b504                	fsd	fs1,40(a0)
 20e:	6308                	flw	fa0,0(a4)
 210:	7000                	flw	fs0,32(s0)
 212:	9305                	srli	a4,a4,0x21
 214:	b504                	fsd	fs1,40(a0)
 216:	6308                	flw	fa0,0(a4)
 218:	8000                	0x8000
 21a:	9305                	srli	a4,a4,0x21
 21c:	b504                	fsd	fs1,40(a0)
 21e:	6308                	flw	fa0,0(a4)
 220:	9000                	0x9000
 222:	9305                	srli	a4,a4,0x21
 224:	b504                	fsd	fs1,40(a0)
 226:	6308                	flw	fa0,0(a4)
 228:	0005                	c.nop	1
 22a:	6f00                	flw	fs0,24(a4)
 22c:	0004                	0x4
 22e:	1305                	addi	t1,t1,-31
 230:	8004                	0x8004
 232:	6f00                	flw	fs0,24(a4)
 234:	13059007          	0x13059007
 238:	0004                	0x4
 23a:	6f00                	flw	fs0,24(a4)
 23c:	4002                	0x4002
 23e:	1305                	addi	t1,t1,-31
 240:	6f008003          	lb	zero,1776(ra)
 244:	13050003          	lb	zero,304(a0)
 248:	6f000003          	lb	zero,1776(zero) # 0x6f0
 24c:	9001                	srli	s0,s0,0x20
 24e:	1305                	addi	t1,t1,-31
 250:	8002                	0x8002
 252:	6f00                	flw	fs0,24(a4)
 254:	2001                	jal	0x254
 256:	1305                	addi	t1,t1,-31
 258:	0002                	c.slli64	zero
 25a:	6f00                	flw	fs0,24(a4)
 25c:	2000                	fld	fs0,0(s0)
 25e:	1305                	addi	t1,t1,-31
 260:	8001                	c.srli64	s0
 262:	6f00                	flw	fs0,24(a4)
 264:	13058007          	0x13058007
 268:	0001                	nop
 26a:	6f00                	flw	fs0,24(a4)
 26c:	0000                	unimp
 26e:	1305                	addi	t1,t1,-31
 270:	8000                	0x8000
 272:	6f00                	flw	fs0,24(a4)
 274:	0001                	nop
 276:	1305                	addi	t1,t1,-31
 278:	a900                	fsd	fs0,16(a0)
 27a:	2301                	jal	0x77a
 27c:	0e00                	addi	s0,sp,784
 27e:	1305                	addi	t1,t1,-31
 280:	0502                	c.slli64	a0
 282:	6308                	flw	fa0,0(a4)
 284:	1000                	addi	s0,sp,32
 286:	9305                	srli	a4,a4,0x21
 288:	b502                	fsd	ft0,168(sp)
 28a:	6308                	flw	fa0,0(a4)
 28c:	2000                	fld	fs0,0(s0)
 28e:	9305                	srli	a4,a4,0x21
 290:	b502                	fsd	ft0,168(sp)
 292:	6308                	flw	fa0,0(a4)
 294:	3000                	fld	fs0,32(s0)
 296:	9305                	srli	a4,a4,0x21
 298:	b502                	fsd	ft0,168(sp)
 29a:	6308                	flw	fa0,0(a4)
 29c:	4000                	lw	s0,0(s0)
 29e:	9305                	srli	a4,a4,0x21
 2a0:	b502                	fsd	ft0,168(sp)
 2a2:	6308                	flw	fa0,0(a4)
 2a4:	5000                	lw	s0,32(s0)
 2a6:	9305                	srli	a4,a4,0x21
 2a8:	b502                	fsd	ft0,168(sp)
 2aa:	6308                	flw	fa0,0(a4)
 2ac:	6f000003          	lb	zero,1776(zero) # 0x6f0
 2b0:	0004                	0x4
 2b2:	1305                	addi	t1,t1,-31
 2b4:	8002                	0x8002
 2b6:	6f00                	flw	fs0,24(a4)
 2b8:	13059007          	0x13059007
 2bc:	0002                	c.slli64	zero
 2be:	6f00                	flw	fs0,24(a4)
 2c0:	4002                	0x4002
 2c2:	1305                	addi	t1,t1,-31
 2c4:	8001                	c.srli64	s0
 2c6:	6f00                	flw	fs0,24(a4)
 2c8:	13050003          	lb	zero,304(a0)
 2cc:	0001                	nop
 2ce:	6f00                	flw	fs0,24(a4)
 2d0:	9001                	srli	s0,s0,0x20
 2d2:	1305                	addi	t1,t1,-31
 2d4:	8000                	0x8000
 2d6:	6f00                	flw	fs0,24(a4)
 2d8:	2001                	jal	0x2d8
 2da:	1305                	addi	t1,t1,-31
 2dc:	a900                	fsd	fs0,16(a0)
 2de:	a301                	j	0x7de
 2e0:	0e00                	addi	s0,sp,784
 2e2:	1385                	addi	t2,t2,-31
 2e4:	0504                	addi	s1,sp,640
 2e6:	6308                	flw	fa0,0(a4)
 2e8:	1000                	addi	s0,sp,32
 2ea:	9305                	srli	a4,a4,0x21
 2ec:	b504                	fsd	fs1,40(a0)
 2ee:	6308                	flw	fa0,0(a4)
 2f0:	2000                	fld	fs0,0(s0)
 2f2:	9305                	srli	a4,a4,0x21
 2f4:	b504                	fsd	fs1,40(a0)
 2f6:	6308                	flw	fa0,0(a4)
 2f8:	3000                	fld	fs0,32(s0)
 2fa:	9305                	srli	a4,a4,0x21
 2fc:	b504                	fsd	fs1,40(a0)
 2fe:	6308                	flw	fa0,0(a4)
 300:	4000                	lw	s0,0(s0)
 302:	9305                	srli	a4,a4,0x21
 304:	b504                	fsd	fs1,40(a0)
 306:	6308                	flw	fa0,0(a4)
 308:	5000                	lw	s0,32(s0)
 30a:	9305                	srli	a4,a4,0x21
 30c:	b504                	fsd	fs1,40(a0)
 30e:	6308                	flw	fa0,0(a4)
 310:	6000                	flw	fs0,0(s0)
 312:	9305                	srli	a4,a4,0x21
 314:	b504                	fsd	fs1,40(a0)
 316:	6308                	flw	fa0,0(a4)
 318:	7000                	flw	fs0,32(s0)
 31a:	9305                	srli	a4,a4,0x21
 31c:	b504                	fsd	fs1,40(a0)
 31e:	6308                	flw	fa0,0(a4)
 320:	8000                	0x8000
 322:	9305                	srli	a4,a4,0x21
 324:	b504                	fsd	fs1,40(a0)
 326:	6308                	flw	fa0,0(a4)
 328:	9000                	0x9000
 32a:	9305                	srli	a4,a4,0x21
 32c:	b504                	fsd	fs1,40(a0)
 32e:	6308                	flw	fa0,0(a4)
 330:	0005                	c.nop	1
 332:	6f00                	flw	fs0,24(a4)
 334:	0004                	0x4
 336:	1305                	addi	t1,t1,-31
 338:	8004                	0x8004
 33a:	6f00                	flw	fs0,24(a4)
 33c:	13059007          	0x13059007
 340:	0004                	0x4
 342:	6f00                	flw	fs0,24(a4)
 344:	4002                	0x4002
 346:	1305                	addi	t1,t1,-31
 348:	6f008003          	lb	zero,1776(ra)
 34c:	13050003          	lb	zero,304(a0)
 350:	6f000003          	lb	zero,1776(zero) # 0x6f0
 354:	9001                	srli	s0,s0,0x20
 356:	1305                	addi	t1,t1,-31
 358:	8002                	0x8002
 35a:	6f00                	flw	fs0,24(a4)
 35c:	2001                	jal	0x35c
 35e:	1305                	addi	t1,t1,-31
 360:	0002                	c.slli64	zero
 362:	6f00                	flw	fs0,24(a4)
 364:	2000                	fld	fs0,0(s0)
 366:	1305                	addi	t1,t1,-31
 368:	8001                	c.srli64	s0
 36a:	6f00                	flw	fs0,24(a4)
 36c:	13058007          	0x13058007
 370:	0001                	nop
 372:	6f00                	flw	fs0,24(a4)
 374:	0000                	unimp
 376:	1305                	addi	t1,t1,-31
 378:	8000                	0x8000
 37a:	6f00                	flw	fs0,24(a4)
 37c:	0001                	nop
 37e:	1305                	addi	t1,t1,-31
 380:	a900                	fsd	fs0,16(a0)
 382:	2380                	fld	fs0,0(a5)
 384:	0f00                	addi	s0,sp,912
 386:	1305                	addi	t1,t1,-31
 388:	0504                	addi	s1,sp,640
 38a:	6308                	flw	fa0,0(a4)
 38c:	1000                	addi	s0,sp,32
 38e:	9305                	srli	a4,a4,0x21
 390:	b504                	fsd	fs1,40(a0)
 392:	6308                	flw	fa0,0(a4)
 394:	2000                	fld	fs0,0(s0)
 396:	9305                	srli	a4,a4,0x21
 398:	b504                	fsd	fs1,40(a0)
 39a:	6308                	flw	fa0,0(a4)
 39c:	3000                	fld	fs0,32(s0)
 39e:	9305                	srli	a4,a4,0x21
 3a0:	b504                	fsd	fs1,40(a0)
 3a2:	6308                	flw	fa0,0(a4)
 3a4:	4000                	lw	s0,0(s0)
 3a6:	9305                	srli	a4,a4,0x21
 3a8:	b504                	fsd	fs1,40(a0)
 3aa:	6308                	flw	fa0,0(a4)
 3ac:	5000                	lw	s0,32(s0)
 3ae:	9305                	srli	a4,a4,0x21
 3b0:	b504                	fsd	fs1,40(a0)
 3b2:	6308                	flw	fa0,0(a4)
 3b4:	6000                	flw	fs0,0(s0)
 3b6:	9305                	srli	a4,a4,0x21
 3b8:	b504                	fsd	fs1,40(a0)
 3ba:	6308                	flw	fa0,0(a4)
 3bc:	7000                	flw	fs0,32(s0)
 3be:	9305                	srli	a4,a4,0x21
 3c0:	b504                	fsd	fs1,40(a0)
 3c2:	6308                	flw	fa0,0(a4)
 3c4:	8000                	0x8000
 3c6:	9305                	srli	a4,a4,0x21
 3c8:	b504                	fsd	fs1,40(a0)
 3ca:	6308                	flw	fa0,0(a4)
 3cc:	9000                	0x9000
 3ce:	9305                	srli	a4,a4,0x21
 3d0:	b504                	fsd	fs1,40(a0)
 3d2:	6308                	flw	fa0,0(a4)
 3d4:	0005                	c.nop	1
 3d6:	6f00                	flw	fs0,24(a4)
 3d8:	0004                	0x4
 3da:	1305                	addi	t1,t1,-31
 3dc:	8004                	0x8004
 3de:	6f00                	flw	fs0,24(a4)
 3e0:	13059007          	0x13059007
 3e4:	0004                	0x4
 3e6:	6f00                	flw	fs0,24(a4)
 3e8:	4002                	0x4002
 3ea:	1305                	addi	t1,t1,-31
 3ec:	6f008003          	lb	zero,1776(ra)
 3f0:	13050003          	lb	zero,304(a0)
 3f4:	6f000003          	lb	zero,1776(zero) # 0x6f0
 3f8:	9001                	srli	s0,s0,0x20
 3fa:	1305                	addi	t1,t1,-31
 3fc:	8002                	0x8002
 3fe:	6f00                	flw	fs0,24(a4)
 400:	2001                	jal	0x400
 402:	1305                	addi	t1,t1,-31
 404:	0002                	c.slli64	zero
 406:	6f00                	flw	fs0,24(a4)
 408:	2000                	fld	fs0,0(s0)
 40a:	1305                	addi	t1,t1,-31
 40c:	8001                	c.srli64	s0
 40e:	6f00                	flw	fs0,24(a4)
 410:	13058007          	0x13058007
 414:	0001                	nop
 416:	6f00                	flw	fs0,24(a4)
 418:	0000                	unimp
 41a:	1305                	addi	t1,t1,-31
 41c:	8000                	0x8000
 41e:	6f00                	flw	fs0,24(a4)
 420:	0001                	nop
 422:	1305                	addi	t1,t1,-31
 424:	a900                	fsd	fs0,16(a0)
 426:	a380                	fsd	fs0,0(a5)
 428:	1305f007          	0x1305f007
 42c:	a900                	fsd	fs0,16(a0)
 42e:	2381                	jal	0x96e
 430:	a900                	fsd	fs0,16(a0)
 432:	a381                	j	0x972
 434:	6ff01fbf  	0x6ff01fbf
