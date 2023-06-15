
user/_symlinkfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cleanup>:
  exit(failed);
}

static void
cleanup(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  unlink("/testsymlink/a");
   8:	00001517          	auipc	a0,0x1
   c:	c7050513          	addi	a0,a0,-912 # c78 <malloc+0xea>
  10:	00000097          	auipc	ra,0x0
  14:	790080e7          	jalr	1936(ra) # 7a0 <unlink>
  unlink("/testsymlink/b");
  18:	00001517          	auipc	a0,0x1
  1c:	c7050513          	addi	a0,a0,-912 # c88 <malloc+0xfa>
  20:	00000097          	auipc	ra,0x0
  24:	780080e7          	jalr	1920(ra) # 7a0 <unlink>
  unlink("/testsymlink/c");
  28:	00001517          	auipc	a0,0x1
  2c:	c7050513          	addi	a0,a0,-912 # c98 <malloc+0x10a>
  30:	00000097          	auipc	ra,0x0
  34:	770080e7          	jalr	1904(ra) # 7a0 <unlink>
  unlink("/testsymlink/1");
  38:	00001517          	auipc	a0,0x1
  3c:	c7050513          	addi	a0,a0,-912 # ca8 <malloc+0x11a>
  40:	00000097          	auipc	ra,0x0
  44:	760080e7          	jalr	1888(ra) # 7a0 <unlink>
  unlink("/testsymlink/2");
  48:	00001517          	auipc	a0,0x1
  4c:	c7050513          	addi	a0,a0,-912 # cb8 <malloc+0x12a>
  50:	00000097          	auipc	ra,0x0
  54:	750080e7          	jalr	1872(ra) # 7a0 <unlink>
  unlink("/testsymlink/3");
  58:	00001517          	auipc	a0,0x1
  5c:	c7050513          	addi	a0,a0,-912 # cc8 <malloc+0x13a>
  60:	00000097          	auipc	ra,0x0
  64:	740080e7          	jalr	1856(ra) # 7a0 <unlink>
  unlink("/testsymlink/4");
  68:	00001517          	auipc	a0,0x1
  6c:	c7050513          	addi	a0,a0,-912 # cd8 <malloc+0x14a>
  70:	00000097          	auipc	ra,0x0
  74:	730080e7          	jalr	1840(ra) # 7a0 <unlink>
  unlink("/testsymlink2/1");
  78:	00001517          	auipc	a0,0x1
  7c:	c7050513          	addi	a0,a0,-912 # ce8 <malloc+0x15a>
  80:	00000097          	auipc	ra,0x0
  84:	720080e7          	jalr	1824(ra) # 7a0 <unlink>
  unlink("/testsymlink2/3");
  88:	00001517          	auipc	a0,0x1
  8c:	c7050513          	addi	a0,a0,-912 # cf8 <malloc+0x16a>
  90:	00000097          	auipc	ra,0x0
  94:	710080e7          	jalr	1808(ra) # 7a0 <unlink>
  unlink("/testsymlink/z");
  98:	00001517          	auipc	a0,0x1
  9c:	c7050513          	addi	a0,a0,-912 # d08 <malloc+0x17a>
  a0:	00000097          	auipc	ra,0x0
  a4:	700080e7          	jalr	1792(ra) # 7a0 <unlink>
  unlink("/testsymlink/y");
  a8:	00001517          	auipc	a0,0x1
  ac:	c7050513          	addi	a0,a0,-912 # d18 <malloc+0x18a>
  b0:	00000097          	auipc	ra,0x0
  b4:	6f0080e7          	jalr	1776(ra) # 7a0 <unlink>
  unlink("/testsymlink");
  b8:	00001517          	auipc	a0,0x1
  bc:	c7050513          	addi	a0,a0,-912 # d28 <malloc+0x19a>
  c0:	00000097          	auipc	ra,0x0
  c4:	6e0080e7          	jalr	1760(ra) # 7a0 <unlink>
  unlink("/testsymlink2");
  c8:	00001517          	auipc	a0,0x1
  cc:	c7050513          	addi	a0,a0,-912 # d38 <malloc+0x1aa>
  d0:	00000097          	auipc	ra,0x0
  d4:	6d0080e7          	jalr	1744(ra) # 7a0 <unlink>
}
  d8:	60a2                	ld	ra,8(sp)
  da:	6402                	ld	s0,0(sp)
  dc:	0141                	addi	sp,sp,16
  de:	8082                	ret

00000000000000e0 <main>:
{
  e0:	715d                	addi	sp,sp,-80
  e2:	e486                	sd	ra,72(sp)
  e4:	e0a2                	sd	s0,64(sp)
  e6:	fc26                	sd	s1,56(sp)
  e8:	f84a                	sd	s2,48(sp)
  ea:	0880                	addi	s0,sp,80
  cleanup();
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <cleanup>

static void
public1(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  f4:	646367b7          	lui	a5,0x64636
  f8:	26178793          	addi	a5,a5,609 # 64636261 <__global_pointer$+0x64634a90>
  fc:	fcf42023          	sw	a5,-64(s0)
  char c = 0;
 100:	fa040fa3          	sb	zero,-65(s0)
  struct stat st;
    
  printf("public testcase 1:\n");
 104:	00001517          	auipc	a0,0x1
 108:	c4450513          	addi	a0,a0,-956 # d48 <malloc+0x1ba>
 10c:	00001097          	auipc	ra,0x1
 110:	9c4080e7          	jalr	-1596(ra) # ad0 <printf>

  mkdir("/testsymlink");
 114:	00001517          	auipc	a0,0x1
 118:	c1450513          	addi	a0,a0,-1004 # d28 <malloc+0x19a>
 11c:	00000097          	auipc	ra,0x0
 120:	69c080e7          	jalr	1692(ra) # 7b8 <mkdir>

  // 1. Create file a
  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
 124:	20200593          	li	a1,514
 128:	00001517          	auipc	a0,0x1
 12c:	b5050513          	addi	a0,a0,-1200 # c78 <malloc+0xea>
 130:	00000097          	auipc	ra,0x0
 134:	660080e7          	jalr	1632(ra) # 790 <open>
 138:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
 13a:	06054763          	bltz	a0,1a8 <main+0xc8>

  // 2. Create symlink b -> a
  r = symlink("/testsymlink/a", "/testsymlink/b");
 13e:	00001597          	auipc	a1,0x1
 142:	b4a58593          	addi	a1,a1,-1206 # c88 <malloc+0xfa>
 146:	00001517          	auipc	a0,0x1
 14a:	b3250513          	addi	a0,a0,-1230 # c78 <malloc+0xea>
 14e:	00000097          	auipc	ra,0x0
 152:	6a2080e7          	jalr	1698(ra) # 7f0 <symlink>
  if(r < 0)
 156:	16054863          	bltz	a0,2c6 <main+0x1e6>
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
 15a:	4591                	li	a1,4
 15c:	00001517          	auipc	a0,0x1
 160:	b2c50513          	addi	a0,a0,-1236 # c88 <malloc+0xfa>
 164:	00000097          	auipc	ra,0x0
 168:	62c080e7          	jalr	1580(ra) # 790 <open>
  if(fd < 0)
 16c:	16054c63          	bltz	a0,2e4 <main+0x204>
  if(fstat(fd, st) != 0)
 170:	fc840593          	addi	a1,s0,-56
 174:	00000097          	auipc	ra,0x0
 178:	634080e7          	jalr	1588(ra) # 7a8 <fstat>
    fail("symlink b -> a failed");

  // 3. check b file type
  if (stat_slink("/testsymlink/b", &st) != 0)
 17c:	16051463          	bnez	a0,2e4 <main+0x204>
    fail("failed to stat b");
  if(st.type != T_SYMLINK)
 180:	fd041703          	lh	a4,-48(s0)
 184:	4791                	li	a5,4
 186:	16f70e63          	beq	a4,a5,302 <main+0x222>
    fail("b isn't a symlink");
 18a:	00001517          	auipc	a0,0x1
 18e:	c3650513          	addi	a0,a0,-970 # dc0 <malloc+0x232>
 192:	00001097          	auipc	ra,0x1
 196:	93e080e7          	jalr	-1730(ra) # ad0 <printf>
 19a:	4785                	li	a5,1
 19c:	00001717          	auipc	a4,0x1
 1a0:	e2f72e23          	sw	a5,-452(a4) # fd8 <failed>
  int r, fd1 = -1, fd2 = -1;
 1a4:	597d                	li	s2,-1
    fail("b isn't a symlink");
 1a6:	a839                	j	1c4 <main+0xe4>
  if(fd1 < 0) fail("failed to open a");
 1a8:	00001517          	auipc	a0,0x1
 1ac:	bb850513          	addi	a0,a0,-1096 # d60 <malloc+0x1d2>
 1b0:	00001097          	auipc	ra,0x1
 1b4:	920080e7          	jalr	-1760(ra) # ad0 <printf>
 1b8:	4785                	li	a5,1
 1ba:	00001717          	auipc	a4,0x1
 1be:	e0f72f23          	sw	a5,-482(a4) # fd8 <failed>
  int r, fd1 = -1, fd2 = -1;
 1c2:	597d                	li	s2,-1
    fail("b and a are not the same");

  printf("public testcase 1: ok\n");

done:
  close(fd1);
 1c4:	8526                	mv	a0,s1
 1c6:	00000097          	auipc	ra,0x0
 1ca:	5b2080e7          	jalr	1458(ra) # 778 <close>
  close(fd2);
 1ce:	854a                	mv	a0,s2
 1d0:	00000097          	auipc	ra,0x0
 1d4:	5a8080e7          	jalr	1448(ra) # 778 <close>
  cleanup();
 1d8:	00000097          	auipc	ra,0x0
 1dc:	e28080e7          	jalr	-472(ra) # 0 <cleanup>

static void
public2(void)
{
  int r, fd1 = -1, fd2 = -1;
  char c = 0, c2 = 0;
 1e0:	fc040023          	sb	zero,-64(s0)
 1e4:	fc040423          	sb	zero,-56(s0)
    
  printf("public testcase 2:\n");
 1e8:	00001517          	auipc	a0,0x1
 1ec:	c7850513          	addi	a0,a0,-904 # e60 <malloc+0x2d2>
 1f0:	00001097          	auipc	ra,0x1
 1f4:	8e0080e7          	jalr	-1824(ra) # ad0 <printf>

  mkdir("/testsymlink");
 1f8:	00001517          	auipc	a0,0x1
 1fc:	b3050513          	addi	a0,a0,-1232 # d28 <malloc+0x19a>
 200:	00000097          	auipc	ra,0x0
 204:	5b8080e7          	jalr	1464(ra) # 7b8 <mkdir>

  // 1. Create a symlink chain 1 -> 2 -> 3 -> 4
  r = symlink("/testsymlink/2", "/testsymlink/1");
 208:	00001597          	auipc	a1,0x1
 20c:	aa058593          	addi	a1,a1,-1376 # ca8 <malloc+0x11a>
 210:	00001517          	auipc	a0,0x1
 214:	aa850513          	addi	a0,a0,-1368 # cb8 <malloc+0x12a>
 218:	00000097          	auipc	ra,0x0
 21c:	5d8080e7          	jalr	1496(ra) # 7f0 <symlink>
  if(r) fail("Failed to link 1->2");
 220:	18051963          	bnez	a0,3b2 <main+0x2d2>
  r = symlink("/testsymlink/3", "/testsymlink/2");
 224:	00001597          	auipc	a1,0x1
 228:	a9458593          	addi	a1,a1,-1388 # cb8 <malloc+0x12a>
 22c:	00001517          	auipc	a0,0x1
 230:	a9c50513          	addi	a0,a0,-1380 # cc8 <malloc+0x13a>
 234:	00000097          	auipc	ra,0x0
 238:	5bc080e7          	jalr	1468(ra) # 7f0 <symlink>
  if(r) fail("Failed to link 2->3");
 23c:	1c051063          	bnez	a0,3fc <main+0x31c>
  r = symlink("/testsymlink/4", "/testsymlink/3");
 240:	00001597          	auipc	a1,0x1
 244:	a8858593          	addi	a1,a1,-1400 # cc8 <malloc+0x13a>
 248:	00001517          	auipc	a0,0x1
 24c:	a9050513          	addi	a0,a0,-1392 # cd8 <malloc+0x14a>
 250:	00000097          	auipc	ra,0x0
 254:	5a0080e7          	jalr	1440(ra) # 7f0 <symlink>
  if(r) fail("Failed to link 3->4");
 258:	1c051263          	bnez	a0,41c <main+0x33c>

  // 2. Open 1 and 4.
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
 25c:	20200593          	li	a1,514
 260:	00001517          	auipc	a0,0x1
 264:	a7850513          	addi	a0,a0,-1416 # cd8 <malloc+0x14a>
 268:	00000097          	auipc	ra,0x0
 26c:	528080e7          	jalr	1320(ra) # 790 <open>
 270:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
 272:	1c054563          	bltz	a0,43c <main+0x35c>
  fd2 = open("/testsymlink/1", O_RDWR);
 276:	4589                	li	a1,2
 278:	00001517          	auipc	a0,0x1
 27c:	a3050513          	addi	a0,a0,-1488 # ca8 <malloc+0x11a>
 280:	00000097          	auipc	ra,0x0
 284:	510080e7          	jalr	1296(ra) # 790 <open>
 288:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
 28a:	1c054863          	bltz	a0,45a <main+0x37a>

  // Write 1 and read 4 to check they are the same file.
  c = '#';
 28e:	02300793          	li	a5,35
 292:	fcf40023          	sb	a5,-64(s0)
  r = write(fd2, &c, 1);
 296:	4605                	li	a2,1
 298:	fc040593          	addi	a1,s0,-64
 29c:	00000097          	auipc	ra,0x0
 2a0:	4d4080e7          	jalr	1236(ra) # 770 <write>
  if(r!=1) fail("Failed to write to 1\n");
 2a4:	4785                	li	a5,1
 2a6:	1cf50863          	beq	a0,a5,476 <main+0x396>
 2aa:	00001517          	auipc	a0,0x1
 2ae:	c6e50513          	addi	a0,a0,-914 # f18 <malloc+0x38a>
 2b2:	00001097          	auipc	ra,0x1
 2b6:	81e080e7          	jalr	-2018(ra) # ad0 <printf>
 2ba:	4785                	li	a5,1
 2bc:	00001717          	auipc	a4,0x1
 2c0:	d0f72e23          	sw	a5,-740(a4) # fd8 <failed>
 2c4:	a231                	j	3d0 <main+0x2f0>
    fail("symlink b -> a failed");
 2c6:	00001517          	auipc	a0,0x1
 2ca:	aba50513          	addi	a0,a0,-1350 # d80 <malloc+0x1f2>
 2ce:	00001097          	auipc	ra,0x1
 2d2:	802080e7          	jalr	-2046(ra) # ad0 <printf>
 2d6:	4785                	li	a5,1
 2d8:	00001717          	auipc	a4,0x1
 2dc:	d0f72023          	sw	a5,-768(a4) # fd8 <failed>
  int r, fd1 = -1, fd2 = -1;
 2e0:	597d                	li	s2,-1
    fail("symlink b -> a failed");
 2e2:	b5cd                	j	1c4 <main+0xe4>
    fail("failed to stat b");
 2e4:	00001517          	auipc	a0,0x1
 2e8:	abc50513          	addi	a0,a0,-1348 # da0 <malloc+0x212>
 2ec:	00000097          	auipc	ra,0x0
 2f0:	7e4080e7          	jalr	2020(ra) # ad0 <printf>
 2f4:	4785                	li	a5,1
 2f6:	00001717          	auipc	a4,0x1
 2fa:	cef72123          	sw	a5,-798(a4) # fd8 <failed>
  int r, fd1 = -1, fd2 = -1;
 2fe:	597d                	li	s2,-1
    fail("failed to stat b");
 300:	b5d1                	j	1c4 <main+0xe4>
  if(write(fd1, buf, sizeof(buf)) != 4)
 302:	4611                	li	a2,4
 304:	fc040593          	addi	a1,s0,-64
 308:	8526                	mv	a0,s1
 30a:	00000097          	auipc	ra,0x0
 30e:	466080e7          	jalr	1126(ra) # 770 <write>
 312:	4791                	li	a5,4
 314:	02f50163          	beq	a0,a5,336 <main+0x256>
    fail("failed to write to a");
 318:	00001517          	auipc	a0,0x1
 31c:	ac850513          	addi	a0,a0,-1336 # de0 <malloc+0x252>
 320:	00000097          	auipc	ra,0x0
 324:	7b0080e7          	jalr	1968(ra) # ad0 <printf>
 328:	4785                	li	a5,1
 32a:	00001717          	auipc	a4,0x1
 32e:	caf72723          	sw	a5,-850(a4) # fd8 <failed>
  int r, fd1 = -1, fd2 = -1;
 332:	597d                	li	s2,-1
    fail("failed to write to a");
 334:	bd41                	j	1c4 <main+0xe4>
  fd2 = open("/testsymlink/b", O_RDWR);
 336:	4589                	li	a1,2
 338:	00001517          	auipc	a0,0x1
 33c:	95050513          	addi	a0,a0,-1712 # c88 <malloc+0xfa>
 340:	00000097          	auipc	ra,0x0
 344:	450080e7          	jalr	1104(ra) # 790 <open>
 348:	892a                	mv	s2,a0
  if(fd2 < 0)
 34a:	02054d63          	bltz	a0,384 <main+0x2a4>
  read(fd2, &c, 1);
 34e:	4605                	li	a2,1
 350:	fbf40593          	addi	a1,s0,-65
 354:	00000097          	auipc	ra,0x0
 358:	414080e7          	jalr	1044(ra) # 768 <read>
  if (c != 'a')
 35c:	fbf44703          	lbu	a4,-65(s0)
 360:	06100793          	li	a5,97
 364:	02f70e63          	beq	a4,a5,3a0 <main+0x2c0>
    fail("b and a are not the same");
 368:	00001517          	auipc	a0,0x1
 36c:	ab850513          	addi	a0,a0,-1352 # e20 <malloc+0x292>
 370:	00000097          	auipc	ra,0x0
 374:	760080e7          	jalr	1888(ra) # ad0 <printf>
 378:	4785                	li	a5,1
 37a:	00001717          	auipc	a4,0x1
 37e:	c4f72f23          	sw	a5,-930(a4) # fd8 <failed>
 382:	b589                	j	1c4 <main+0xe4>
    fail("failed to open b");
 384:	00001517          	auipc	a0,0x1
 388:	a7c50513          	addi	a0,a0,-1412 # e00 <malloc+0x272>
 38c:	00000097          	auipc	ra,0x0
 390:	744080e7          	jalr	1860(ra) # ad0 <printf>
 394:	4785                	li	a5,1
 396:	00001717          	auipc	a4,0x1
 39a:	c4f72123          	sw	a5,-958(a4) # fd8 <failed>
 39e:	b51d                	j	1c4 <main+0xe4>
  printf("public testcase 1: ok\n");
 3a0:	00001517          	auipc	a0,0x1
 3a4:	aa850513          	addi	a0,a0,-1368 # e48 <malloc+0x2ba>
 3a8:	00000097          	auipc	ra,0x0
 3ac:	728080e7          	jalr	1832(ra) # ad0 <printf>
 3b0:	bd11                	j	1c4 <main+0xe4>
  if(r) fail("Failed to link 1->2");
 3b2:	00001517          	auipc	a0,0x1
 3b6:	ac650513          	addi	a0,a0,-1338 # e78 <malloc+0x2ea>
 3ba:	00000097          	auipc	ra,0x0
 3be:	716080e7          	jalr	1814(ra) # ad0 <printf>
 3c2:	4785                	li	a5,1
 3c4:	00001717          	auipc	a4,0x1
 3c8:	c0f72a23          	sw	a5,-1004(a4) # fd8 <failed>
  int r, fd1 = -1, fd2 = -1;
 3cc:	597d                	li	s2,-1
 3ce:	54fd                	li	s1,-1
    fail("Value read from 4 differed from value written to 1\n");

  printf("public testcase 2: ok\n");

done:
  close(fd1);
 3d0:	8526                	mv	a0,s1
 3d2:	00000097          	auipc	ra,0x0
 3d6:	3a6080e7          	jalr	934(ra) # 778 <close>
  close(fd2);
 3da:	854a                	mv	a0,s2
 3dc:	00000097          	auipc	ra,0x0
 3e0:	39c080e7          	jalr	924(ra) # 778 <close>
  cleanup();
 3e4:	00000097          	auipc	ra,0x0
 3e8:	c1c080e7          	jalr	-996(ra) # 0 <cleanup>
  exit(failed);
 3ec:	00001517          	auipc	a0,0x1
 3f0:	bec52503          	lw	a0,-1044(a0) # fd8 <failed>
 3f4:	00000097          	auipc	ra,0x0
 3f8:	35c080e7          	jalr	860(ra) # 750 <exit>
  if(r) fail("Failed to link 2->3");
 3fc:	00001517          	auipc	a0,0x1
 400:	a9c50513          	addi	a0,a0,-1380 # e98 <malloc+0x30a>
 404:	00000097          	auipc	ra,0x0
 408:	6cc080e7          	jalr	1740(ra) # ad0 <printf>
 40c:	4785                	li	a5,1
 40e:	00001717          	auipc	a4,0x1
 412:	bcf72523          	sw	a5,-1078(a4) # fd8 <failed>
  int r, fd1 = -1, fd2 = -1;
 416:	597d                	li	s2,-1
 418:	54fd                	li	s1,-1
  if(r) fail("Failed to link 2->3");
 41a:	bf5d                	j	3d0 <main+0x2f0>
  if(r) fail("Failed to link 3->4");
 41c:	00001517          	auipc	a0,0x1
 420:	a9c50513          	addi	a0,a0,-1380 # eb8 <malloc+0x32a>
 424:	00000097          	auipc	ra,0x0
 428:	6ac080e7          	jalr	1708(ra) # ad0 <printf>
 42c:	4785                	li	a5,1
 42e:	00001717          	auipc	a4,0x1
 432:	baf72523          	sw	a5,-1110(a4) # fd8 <failed>
  int r, fd1 = -1, fd2 = -1;
 436:	597d                	li	s2,-1
 438:	54fd                	li	s1,-1
  if(r) fail("Failed to link 3->4");
 43a:	bf59                	j	3d0 <main+0x2f0>
  if(fd1<0) fail("Failed to create 4\n");
 43c:	00001517          	auipc	a0,0x1
 440:	a9c50513          	addi	a0,a0,-1380 # ed8 <malloc+0x34a>
 444:	00000097          	auipc	ra,0x0
 448:	68c080e7          	jalr	1676(ra) # ad0 <printf>
 44c:	4785                	li	a5,1
 44e:	00001717          	auipc	a4,0x1
 452:	b8f72523          	sw	a5,-1142(a4) # fd8 <failed>
  int r, fd1 = -1, fd2 = -1;
 456:	597d                	li	s2,-1
  if(fd1<0) fail("Failed to create 4\n");
 458:	bfa5                	j	3d0 <main+0x2f0>
  if(fd2<0) fail("Failed to open 1\n");
 45a:	00001517          	auipc	a0,0x1
 45e:	a9e50513          	addi	a0,a0,-1378 # ef8 <malloc+0x36a>
 462:	00000097          	auipc	ra,0x0
 466:	66e080e7          	jalr	1646(ra) # ad0 <printf>
 46a:	4785                	li	a5,1
 46c:	00001717          	auipc	a4,0x1
 470:	b6f72623          	sw	a5,-1172(a4) # fd8 <failed>
 474:	bfb1                	j	3d0 <main+0x2f0>
  r = read(fd1, &c2, 1);
 476:	4605                	li	a2,1
 478:	fc840593          	addi	a1,s0,-56
 47c:	8526                	mv	a0,s1
 47e:	00000097          	auipc	ra,0x0
 482:	2ea080e7          	jalr	746(ra) # 768 <read>
  if(r!=1) fail("Failed to read from 4\n");
 486:	4785                	li	a5,1
 488:	02f51663          	bne	a0,a5,4b4 <main+0x3d4>
  if(c!=c2)
 48c:	fc044703          	lbu	a4,-64(s0)
 490:	fc844783          	lbu	a5,-56(s0)
 494:	02f70e63          	beq	a4,a5,4d0 <main+0x3f0>
    fail("Value read from 4 differed from value written to 1\n");
 498:	00001517          	auipc	a0,0x1
 49c:	ac850513          	addi	a0,a0,-1336 # f60 <malloc+0x3d2>
 4a0:	00000097          	auipc	ra,0x0
 4a4:	630080e7          	jalr	1584(ra) # ad0 <printf>
 4a8:	4785                	li	a5,1
 4aa:	00001717          	auipc	a4,0x1
 4ae:	b2f72723          	sw	a5,-1234(a4) # fd8 <failed>
 4b2:	bf39                	j	3d0 <main+0x2f0>
  if(r!=1) fail("Failed to read from 4\n");
 4b4:	00001517          	auipc	a0,0x1
 4b8:	a8450513          	addi	a0,a0,-1404 # f38 <malloc+0x3aa>
 4bc:	00000097          	auipc	ra,0x0
 4c0:	614080e7          	jalr	1556(ra) # ad0 <printf>
 4c4:	4785                	li	a5,1
 4c6:	00001717          	auipc	a4,0x1
 4ca:	b0f72923          	sw	a5,-1262(a4) # fd8 <failed>
 4ce:	b709                	j	3d0 <main+0x2f0>
  printf("public testcase 2: ok\n");
 4d0:	00001517          	auipc	a0,0x1
 4d4:	ad050513          	addi	a0,a0,-1328 # fa0 <malloc+0x412>
 4d8:	00000097          	auipc	ra,0x0
 4dc:	5f8080e7          	jalr	1528(ra) # ad0 <printf>
 4e0:	bdc5                	j	3d0 <main+0x2f0>

00000000000004e2 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 4e2:	1141                	addi	sp,sp,-16
 4e4:	e422                	sd	s0,8(sp)
 4e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4e8:	87aa                	mv	a5,a0
 4ea:	0585                	addi	a1,a1,1
 4ec:	0785                	addi	a5,a5,1
 4ee:	fff5c703          	lbu	a4,-1(a1)
 4f2:	fee78fa3          	sb	a4,-1(a5)
 4f6:	fb75                	bnez	a4,4ea <strcpy+0x8>
    ;
  return os;
}
 4f8:	6422                	ld	s0,8(sp)
 4fa:	0141                	addi	sp,sp,16
 4fc:	8082                	ret

00000000000004fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4fe:	1141                	addi	sp,sp,-16
 500:	e422                	sd	s0,8(sp)
 502:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 504:	00054783          	lbu	a5,0(a0)
 508:	cb91                	beqz	a5,51c <strcmp+0x1e>
 50a:	0005c703          	lbu	a4,0(a1)
 50e:	00f71763          	bne	a4,a5,51c <strcmp+0x1e>
    p++, q++;
 512:	0505                	addi	a0,a0,1
 514:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 516:	00054783          	lbu	a5,0(a0)
 51a:	fbe5                	bnez	a5,50a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 51c:	0005c503          	lbu	a0,0(a1)
}
 520:	40a7853b          	subw	a0,a5,a0
 524:	6422                	ld	s0,8(sp)
 526:	0141                	addi	sp,sp,16
 528:	8082                	ret

000000000000052a <strlen>:

uint
strlen(const char *s)
{
 52a:	1141                	addi	sp,sp,-16
 52c:	e422                	sd	s0,8(sp)
 52e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 530:	00054783          	lbu	a5,0(a0)
 534:	cf91                	beqz	a5,550 <strlen+0x26>
 536:	0505                	addi	a0,a0,1
 538:	87aa                	mv	a5,a0
 53a:	4685                	li	a3,1
 53c:	9e89                	subw	a3,a3,a0
 53e:	00f6853b          	addw	a0,a3,a5
 542:	0785                	addi	a5,a5,1
 544:	fff7c703          	lbu	a4,-1(a5)
 548:	fb7d                	bnez	a4,53e <strlen+0x14>
    ;
  return n;
}
 54a:	6422                	ld	s0,8(sp)
 54c:	0141                	addi	sp,sp,16
 54e:	8082                	ret
  for(n = 0; s[n]; n++)
 550:	4501                	li	a0,0
 552:	bfe5                	j	54a <strlen+0x20>

0000000000000554 <memset>:

void*
memset(void *dst, int c, uint n)
{
 554:	1141                	addi	sp,sp,-16
 556:	e422                	sd	s0,8(sp)
 558:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 55a:	ca19                	beqz	a2,570 <memset+0x1c>
 55c:	87aa                	mv	a5,a0
 55e:	1602                	slli	a2,a2,0x20
 560:	9201                	srli	a2,a2,0x20
 562:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 566:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 56a:	0785                	addi	a5,a5,1
 56c:	fee79de3          	bne	a5,a4,566 <memset+0x12>
  }
  return dst;
}
 570:	6422                	ld	s0,8(sp)
 572:	0141                	addi	sp,sp,16
 574:	8082                	ret

0000000000000576 <strchr>:

char*
strchr(const char *s, char c)
{
 576:	1141                	addi	sp,sp,-16
 578:	e422                	sd	s0,8(sp)
 57a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 57c:	00054783          	lbu	a5,0(a0)
 580:	cb99                	beqz	a5,596 <strchr+0x20>
    if(*s == c)
 582:	00f58763          	beq	a1,a5,590 <strchr+0x1a>
  for(; *s; s++)
 586:	0505                	addi	a0,a0,1
 588:	00054783          	lbu	a5,0(a0)
 58c:	fbfd                	bnez	a5,582 <strchr+0xc>
      return (char*)s;
  return 0;
 58e:	4501                	li	a0,0
}
 590:	6422                	ld	s0,8(sp)
 592:	0141                	addi	sp,sp,16
 594:	8082                	ret
  return 0;
 596:	4501                	li	a0,0
 598:	bfe5                	j	590 <strchr+0x1a>

000000000000059a <gets>:

char*
gets(char *buf, int max)
{
 59a:	711d                	addi	sp,sp,-96
 59c:	ec86                	sd	ra,88(sp)
 59e:	e8a2                	sd	s0,80(sp)
 5a0:	e4a6                	sd	s1,72(sp)
 5a2:	e0ca                	sd	s2,64(sp)
 5a4:	fc4e                	sd	s3,56(sp)
 5a6:	f852                	sd	s4,48(sp)
 5a8:	f456                	sd	s5,40(sp)
 5aa:	f05a                	sd	s6,32(sp)
 5ac:	ec5e                	sd	s7,24(sp)
 5ae:	1080                	addi	s0,sp,96
 5b0:	8baa                	mv	s7,a0
 5b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5b4:	892a                	mv	s2,a0
 5b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5b8:	4aa9                	li	s5,10
 5ba:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5bc:	89a6                	mv	s3,s1
 5be:	2485                	addiw	s1,s1,1
 5c0:	0344d863          	bge	s1,s4,5f0 <gets+0x56>
    cc = read(0, &c, 1);
 5c4:	4605                	li	a2,1
 5c6:	faf40593          	addi	a1,s0,-81
 5ca:	4501                	li	a0,0
 5cc:	00000097          	auipc	ra,0x0
 5d0:	19c080e7          	jalr	412(ra) # 768 <read>
    if(cc < 1)
 5d4:	00a05e63          	blez	a0,5f0 <gets+0x56>
    buf[i++] = c;
 5d8:	faf44783          	lbu	a5,-81(s0)
 5dc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5e0:	01578763          	beq	a5,s5,5ee <gets+0x54>
 5e4:	0905                	addi	s2,s2,1
 5e6:	fd679be3          	bne	a5,s6,5bc <gets+0x22>
  for(i=0; i+1 < max; ){
 5ea:	89a6                	mv	s3,s1
 5ec:	a011                	j	5f0 <gets+0x56>
 5ee:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5f0:	99de                	add	s3,s3,s7
 5f2:	00098023          	sb	zero,0(s3)
  return buf;
}
 5f6:	855e                	mv	a0,s7
 5f8:	60e6                	ld	ra,88(sp)
 5fa:	6446                	ld	s0,80(sp)
 5fc:	64a6                	ld	s1,72(sp)
 5fe:	6906                	ld	s2,64(sp)
 600:	79e2                	ld	s3,56(sp)
 602:	7a42                	ld	s4,48(sp)
 604:	7aa2                	ld	s5,40(sp)
 606:	7b02                	ld	s6,32(sp)
 608:	6be2                	ld	s7,24(sp)
 60a:	6125                	addi	sp,sp,96
 60c:	8082                	ret

000000000000060e <stat>:

int
stat(const char *n, struct stat *st)
{
 60e:	1101                	addi	sp,sp,-32
 610:	ec06                	sd	ra,24(sp)
 612:	e822                	sd	s0,16(sp)
 614:	e426                	sd	s1,8(sp)
 616:	e04a                	sd	s2,0(sp)
 618:	1000                	addi	s0,sp,32
 61a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 61c:	4581                	li	a1,0
 61e:	00000097          	auipc	ra,0x0
 622:	172080e7          	jalr	370(ra) # 790 <open>
  if(fd < 0)
 626:	02054563          	bltz	a0,650 <stat+0x42>
 62a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 62c:	85ca                	mv	a1,s2
 62e:	00000097          	auipc	ra,0x0
 632:	17a080e7          	jalr	378(ra) # 7a8 <fstat>
 636:	892a                	mv	s2,a0
  close(fd);
 638:	8526                	mv	a0,s1
 63a:	00000097          	auipc	ra,0x0
 63e:	13e080e7          	jalr	318(ra) # 778 <close>
  return r;
}
 642:	854a                	mv	a0,s2
 644:	60e2                	ld	ra,24(sp)
 646:	6442                	ld	s0,16(sp)
 648:	64a2                	ld	s1,8(sp)
 64a:	6902                	ld	s2,0(sp)
 64c:	6105                	addi	sp,sp,32
 64e:	8082                	ret
    return -1;
 650:	597d                	li	s2,-1
 652:	bfc5                	j	642 <stat+0x34>

0000000000000654 <atoi>:

int
atoi(const char *s)
{
 654:	1141                	addi	sp,sp,-16
 656:	e422                	sd	s0,8(sp)
 658:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 65a:	00054603          	lbu	a2,0(a0)
 65e:	fd06079b          	addiw	a5,a2,-48
 662:	0ff7f793          	andi	a5,a5,255
 666:	4725                	li	a4,9
 668:	02f76963          	bltu	a4,a5,69a <atoi+0x46>
 66c:	86aa                	mv	a3,a0
  n = 0;
 66e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 670:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 672:	0685                	addi	a3,a3,1
 674:	0025179b          	slliw	a5,a0,0x2
 678:	9fa9                	addw	a5,a5,a0
 67a:	0017979b          	slliw	a5,a5,0x1
 67e:	9fb1                	addw	a5,a5,a2
 680:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 684:	0006c603          	lbu	a2,0(a3)
 688:	fd06071b          	addiw	a4,a2,-48
 68c:	0ff77713          	andi	a4,a4,255
 690:	fee5f1e3          	bgeu	a1,a4,672 <atoi+0x1e>
  return n;
}
 694:	6422                	ld	s0,8(sp)
 696:	0141                	addi	sp,sp,16
 698:	8082                	ret
  n = 0;
 69a:	4501                	li	a0,0
 69c:	bfe5                	j	694 <atoi+0x40>

000000000000069e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 69e:	1141                	addi	sp,sp,-16
 6a0:	e422                	sd	s0,8(sp)
 6a2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6a4:	02b57463          	bgeu	a0,a1,6cc <memmove+0x2e>
    while(n-- > 0)
 6a8:	00c05f63          	blez	a2,6c6 <memmove+0x28>
 6ac:	1602                	slli	a2,a2,0x20
 6ae:	9201                	srli	a2,a2,0x20
 6b0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6b4:	872a                	mv	a4,a0
      *dst++ = *src++;
 6b6:	0585                	addi	a1,a1,1
 6b8:	0705                	addi	a4,a4,1
 6ba:	fff5c683          	lbu	a3,-1(a1)
 6be:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6c2:	fee79ae3          	bne	a5,a4,6b6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6c6:	6422                	ld	s0,8(sp)
 6c8:	0141                	addi	sp,sp,16
 6ca:	8082                	ret
    dst += n;
 6cc:	00c50733          	add	a4,a0,a2
    src += n;
 6d0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6d2:	fec05ae3          	blez	a2,6c6 <memmove+0x28>
 6d6:	fff6079b          	addiw	a5,a2,-1
 6da:	1782                	slli	a5,a5,0x20
 6dc:	9381                	srli	a5,a5,0x20
 6de:	fff7c793          	not	a5,a5
 6e2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6e4:	15fd                	addi	a1,a1,-1
 6e6:	177d                	addi	a4,a4,-1
 6e8:	0005c683          	lbu	a3,0(a1)
 6ec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6f0:	fee79ae3          	bne	a5,a4,6e4 <memmove+0x46>
 6f4:	bfc9                	j	6c6 <memmove+0x28>

00000000000006f6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6f6:	1141                	addi	sp,sp,-16
 6f8:	e422                	sd	s0,8(sp)
 6fa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6fc:	ca05                	beqz	a2,72c <memcmp+0x36>
 6fe:	fff6069b          	addiw	a3,a2,-1
 702:	1682                	slli	a3,a3,0x20
 704:	9281                	srli	a3,a3,0x20
 706:	0685                	addi	a3,a3,1
 708:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 70a:	00054783          	lbu	a5,0(a0)
 70e:	0005c703          	lbu	a4,0(a1)
 712:	00e79863          	bne	a5,a4,722 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 716:	0505                	addi	a0,a0,1
    p2++;
 718:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 71a:	fed518e3          	bne	a0,a3,70a <memcmp+0x14>
  }
  return 0;
 71e:	4501                	li	a0,0
 720:	a019                	j	726 <memcmp+0x30>
      return *p1 - *p2;
 722:	40e7853b          	subw	a0,a5,a4
}
 726:	6422                	ld	s0,8(sp)
 728:	0141                	addi	sp,sp,16
 72a:	8082                	ret
  return 0;
 72c:	4501                	li	a0,0
 72e:	bfe5                	j	726 <memcmp+0x30>

0000000000000730 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 730:	1141                	addi	sp,sp,-16
 732:	e406                	sd	ra,8(sp)
 734:	e022                	sd	s0,0(sp)
 736:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 738:	00000097          	auipc	ra,0x0
 73c:	f66080e7          	jalr	-154(ra) # 69e <memmove>
}
 740:	60a2                	ld	ra,8(sp)
 742:	6402                	ld	s0,0(sp)
 744:	0141                	addi	sp,sp,16
 746:	8082                	ret

0000000000000748 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 748:	4885                	li	a7,1
 ecall
 74a:	00000073          	ecall
 ret
 74e:	8082                	ret

0000000000000750 <exit>:
.global exit
exit:
 li a7, SYS_exit
 750:	4889                	li	a7,2
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <wait>:
.global wait
wait:
 li a7, SYS_wait
 758:	488d                	li	a7,3
 ecall
 75a:	00000073          	ecall
 ret
 75e:	8082                	ret

0000000000000760 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 760:	4891                	li	a7,4
 ecall
 762:	00000073          	ecall
 ret
 766:	8082                	ret

0000000000000768 <read>:
.global read
read:
 li a7, SYS_read
 768:	4895                	li	a7,5
 ecall
 76a:	00000073          	ecall
 ret
 76e:	8082                	ret

0000000000000770 <write>:
.global write
write:
 li a7, SYS_write
 770:	48c1                	li	a7,16
 ecall
 772:	00000073          	ecall
 ret
 776:	8082                	ret

0000000000000778 <close>:
.global close
close:
 li a7, SYS_close
 778:	48d5                	li	a7,21
 ecall
 77a:	00000073          	ecall
 ret
 77e:	8082                	ret

0000000000000780 <kill>:
.global kill
kill:
 li a7, SYS_kill
 780:	4899                	li	a7,6
 ecall
 782:	00000073          	ecall
 ret
 786:	8082                	ret

0000000000000788 <exec>:
.global exec
exec:
 li a7, SYS_exec
 788:	489d                	li	a7,7
 ecall
 78a:	00000073          	ecall
 ret
 78e:	8082                	ret

0000000000000790 <open>:
.global open
open:
 li a7, SYS_open
 790:	48bd                	li	a7,15
 ecall
 792:	00000073          	ecall
 ret
 796:	8082                	ret

0000000000000798 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 798:	48c5                	li	a7,17
 ecall
 79a:	00000073          	ecall
 ret
 79e:	8082                	ret

00000000000007a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7a0:	48c9                	li	a7,18
 ecall
 7a2:	00000073          	ecall
 ret
 7a6:	8082                	ret

00000000000007a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7a8:	48a1                	li	a7,8
 ecall
 7aa:	00000073          	ecall
 ret
 7ae:	8082                	ret

00000000000007b0 <link>:
.global link
link:
 li a7, SYS_link
 7b0:	48cd                	li	a7,19
 ecall
 7b2:	00000073          	ecall
 ret
 7b6:	8082                	ret

00000000000007b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7b8:	48d1                	li	a7,20
 ecall
 7ba:	00000073          	ecall
 ret
 7be:	8082                	ret

00000000000007c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7c0:	48a5                	li	a7,9
 ecall
 7c2:	00000073          	ecall
 ret
 7c6:	8082                	ret

00000000000007c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7c8:	48a9                	li	a7,10
 ecall
 7ca:	00000073          	ecall
 ret
 7ce:	8082                	ret

00000000000007d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7d0:	48ad                	li	a7,11
 ecall
 7d2:	00000073          	ecall
 ret
 7d6:	8082                	ret

00000000000007d8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7d8:	48b1                	li	a7,12
 ecall
 7da:	00000073          	ecall
 ret
 7de:	8082                	ret

00000000000007e0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7e0:	48b5                	li	a7,13
 ecall
 7e2:	00000073          	ecall
 ret
 7e6:	8082                	ret

00000000000007e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7e8:	48b9                	li	a7,14
 ecall
 7ea:	00000073          	ecall
 ret
 7ee:	8082                	ret

00000000000007f0 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 7f0:	48d9                	li	a7,22
 ecall
 7f2:	00000073          	ecall
 ret
 7f6:	8082                	ret

00000000000007f8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7f8:	1101                	addi	sp,sp,-32
 7fa:	ec06                	sd	ra,24(sp)
 7fc:	e822                	sd	s0,16(sp)
 7fe:	1000                	addi	s0,sp,32
 800:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 804:	4605                	li	a2,1
 806:	fef40593          	addi	a1,s0,-17
 80a:	00000097          	auipc	ra,0x0
 80e:	f66080e7          	jalr	-154(ra) # 770 <write>
}
 812:	60e2                	ld	ra,24(sp)
 814:	6442                	ld	s0,16(sp)
 816:	6105                	addi	sp,sp,32
 818:	8082                	ret

000000000000081a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 81a:	7139                	addi	sp,sp,-64
 81c:	fc06                	sd	ra,56(sp)
 81e:	f822                	sd	s0,48(sp)
 820:	f426                	sd	s1,40(sp)
 822:	f04a                	sd	s2,32(sp)
 824:	ec4e                	sd	s3,24(sp)
 826:	0080                	addi	s0,sp,64
 828:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 82a:	c299                	beqz	a3,830 <printint+0x16>
 82c:	0805c863          	bltz	a1,8bc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 830:	2581                	sext.w	a1,a1
  neg = 0;
 832:	4881                	li	a7,0
 834:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 838:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 83a:	2601                	sext.w	a2,a2
 83c:	00000517          	auipc	a0,0x0
 840:	78450513          	addi	a0,a0,1924 # fc0 <digits>
 844:	883a                	mv	a6,a4
 846:	2705                	addiw	a4,a4,1
 848:	02c5f7bb          	remuw	a5,a1,a2
 84c:	1782                	slli	a5,a5,0x20
 84e:	9381                	srli	a5,a5,0x20
 850:	97aa                	add	a5,a5,a0
 852:	0007c783          	lbu	a5,0(a5)
 856:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 85a:	0005879b          	sext.w	a5,a1
 85e:	02c5d5bb          	divuw	a1,a1,a2
 862:	0685                	addi	a3,a3,1
 864:	fec7f0e3          	bgeu	a5,a2,844 <printint+0x2a>
  if(neg)
 868:	00088b63          	beqz	a7,87e <printint+0x64>
    buf[i++] = '-';
 86c:	fd040793          	addi	a5,s0,-48
 870:	973e                	add	a4,a4,a5
 872:	02d00793          	li	a5,45
 876:	fef70823          	sb	a5,-16(a4)
 87a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 87e:	02e05863          	blez	a4,8ae <printint+0x94>
 882:	fc040793          	addi	a5,s0,-64
 886:	00e78933          	add	s2,a5,a4
 88a:	fff78993          	addi	s3,a5,-1
 88e:	99ba                	add	s3,s3,a4
 890:	377d                	addiw	a4,a4,-1
 892:	1702                	slli	a4,a4,0x20
 894:	9301                	srli	a4,a4,0x20
 896:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 89a:	fff94583          	lbu	a1,-1(s2)
 89e:	8526                	mv	a0,s1
 8a0:	00000097          	auipc	ra,0x0
 8a4:	f58080e7          	jalr	-168(ra) # 7f8 <putc>
  while(--i >= 0)
 8a8:	197d                	addi	s2,s2,-1
 8aa:	ff3918e3          	bne	s2,s3,89a <printint+0x80>
}
 8ae:	70e2                	ld	ra,56(sp)
 8b0:	7442                	ld	s0,48(sp)
 8b2:	74a2                	ld	s1,40(sp)
 8b4:	7902                	ld	s2,32(sp)
 8b6:	69e2                	ld	s3,24(sp)
 8b8:	6121                	addi	sp,sp,64
 8ba:	8082                	ret
    x = -xx;
 8bc:	40b005bb          	negw	a1,a1
    neg = 1;
 8c0:	4885                	li	a7,1
    x = -xx;
 8c2:	bf8d                	j	834 <printint+0x1a>

00000000000008c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8c4:	7119                	addi	sp,sp,-128
 8c6:	fc86                	sd	ra,120(sp)
 8c8:	f8a2                	sd	s0,112(sp)
 8ca:	f4a6                	sd	s1,104(sp)
 8cc:	f0ca                	sd	s2,96(sp)
 8ce:	ecce                	sd	s3,88(sp)
 8d0:	e8d2                	sd	s4,80(sp)
 8d2:	e4d6                	sd	s5,72(sp)
 8d4:	e0da                	sd	s6,64(sp)
 8d6:	fc5e                	sd	s7,56(sp)
 8d8:	f862                	sd	s8,48(sp)
 8da:	f466                	sd	s9,40(sp)
 8dc:	f06a                	sd	s10,32(sp)
 8de:	ec6e                	sd	s11,24(sp)
 8e0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8e2:	0005c903          	lbu	s2,0(a1)
 8e6:	18090f63          	beqz	s2,a84 <vprintf+0x1c0>
 8ea:	8aaa                	mv	s5,a0
 8ec:	8b32                	mv	s6,a2
 8ee:	00158493          	addi	s1,a1,1
  state = 0;
 8f2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8f4:	02500a13          	li	s4,37
      if(c == 'd'){
 8f8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 8fc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 900:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 904:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 908:	00000b97          	auipc	s7,0x0
 90c:	6b8b8b93          	addi	s7,s7,1720 # fc0 <digits>
 910:	a839                	j	92e <vprintf+0x6a>
        putc(fd, c);
 912:	85ca                	mv	a1,s2
 914:	8556                	mv	a0,s5
 916:	00000097          	auipc	ra,0x0
 91a:	ee2080e7          	jalr	-286(ra) # 7f8 <putc>
 91e:	a019                	j	924 <vprintf+0x60>
    } else if(state == '%'){
 920:	01498f63          	beq	s3,s4,93e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 924:	0485                	addi	s1,s1,1
 926:	fff4c903          	lbu	s2,-1(s1)
 92a:	14090d63          	beqz	s2,a84 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 92e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 932:	fe0997e3          	bnez	s3,920 <vprintf+0x5c>
      if(c == '%'){
 936:	fd479ee3          	bne	a5,s4,912 <vprintf+0x4e>
        state = '%';
 93a:	89be                	mv	s3,a5
 93c:	b7e5                	j	924 <vprintf+0x60>
      if(c == 'd'){
 93e:	05878063          	beq	a5,s8,97e <vprintf+0xba>
      } else if(c == 'l') {
 942:	05978c63          	beq	a5,s9,99a <vprintf+0xd6>
      } else if(c == 'x') {
 946:	07a78863          	beq	a5,s10,9b6 <vprintf+0xf2>
      } else if(c == 'p') {
 94a:	09b78463          	beq	a5,s11,9d2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 94e:	07300713          	li	a4,115
 952:	0ce78663          	beq	a5,a4,a1e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 956:	06300713          	li	a4,99
 95a:	0ee78e63          	beq	a5,a4,a56 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 95e:	11478863          	beq	a5,s4,a6e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 962:	85d2                	mv	a1,s4
 964:	8556                	mv	a0,s5
 966:	00000097          	auipc	ra,0x0
 96a:	e92080e7          	jalr	-366(ra) # 7f8 <putc>
        putc(fd, c);
 96e:	85ca                	mv	a1,s2
 970:	8556                	mv	a0,s5
 972:	00000097          	auipc	ra,0x0
 976:	e86080e7          	jalr	-378(ra) # 7f8 <putc>
      }
      state = 0;
 97a:	4981                	li	s3,0
 97c:	b765                	j	924 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 97e:	008b0913          	addi	s2,s6,8
 982:	4685                	li	a3,1
 984:	4629                	li	a2,10
 986:	000b2583          	lw	a1,0(s6)
 98a:	8556                	mv	a0,s5
 98c:	00000097          	auipc	ra,0x0
 990:	e8e080e7          	jalr	-370(ra) # 81a <printint>
 994:	8b4a                	mv	s6,s2
      state = 0;
 996:	4981                	li	s3,0
 998:	b771                	j	924 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 99a:	008b0913          	addi	s2,s6,8
 99e:	4681                	li	a3,0
 9a0:	4629                	li	a2,10
 9a2:	000b2583          	lw	a1,0(s6)
 9a6:	8556                	mv	a0,s5
 9a8:	00000097          	auipc	ra,0x0
 9ac:	e72080e7          	jalr	-398(ra) # 81a <printint>
 9b0:	8b4a                	mv	s6,s2
      state = 0;
 9b2:	4981                	li	s3,0
 9b4:	bf85                	j	924 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 9b6:	008b0913          	addi	s2,s6,8
 9ba:	4681                	li	a3,0
 9bc:	4641                	li	a2,16
 9be:	000b2583          	lw	a1,0(s6)
 9c2:	8556                	mv	a0,s5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	e56080e7          	jalr	-426(ra) # 81a <printint>
 9cc:	8b4a                	mv	s6,s2
      state = 0;
 9ce:	4981                	li	s3,0
 9d0:	bf91                	j	924 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 9d2:	008b0793          	addi	a5,s6,8
 9d6:	f8f43423          	sd	a5,-120(s0)
 9da:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 9de:	03000593          	li	a1,48
 9e2:	8556                	mv	a0,s5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	e14080e7          	jalr	-492(ra) # 7f8 <putc>
  putc(fd, 'x');
 9ec:	85ea                	mv	a1,s10
 9ee:	8556                	mv	a0,s5
 9f0:	00000097          	auipc	ra,0x0
 9f4:	e08080e7          	jalr	-504(ra) # 7f8 <putc>
 9f8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9fa:	03c9d793          	srli	a5,s3,0x3c
 9fe:	97de                	add	a5,a5,s7
 a00:	0007c583          	lbu	a1,0(a5)
 a04:	8556                	mv	a0,s5
 a06:	00000097          	auipc	ra,0x0
 a0a:	df2080e7          	jalr	-526(ra) # 7f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a0e:	0992                	slli	s3,s3,0x4
 a10:	397d                	addiw	s2,s2,-1
 a12:	fe0914e3          	bnez	s2,9fa <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 a16:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 a1a:	4981                	li	s3,0
 a1c:	b721                	j	924 <vprintf+0x60>
        s = va_arg(ap, char*);
 a1e:	008b0993          	addi	s3,s6,8
 a22:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 a26:	02090163          	beqz	s2,a48 <vprintf+0x184>
        while(*s != 0){
 a2a:	00094583          	lbu	a1,0(s2)
 a2e:	c9a1                	beqz	a1,a7e <vprintf+0x1ba>
          putc(fd, *s);
 a30:	8556                	mv	a0,s5
 a32:	00000097          	auipc	ra,0x0
 a36:	dc6080e7          	jalr	-570(ra) # 7f8 <putc>
          s++;
 a3a:	0905                	addi	s2,s2,1
        while(*s != 0){
 a3c:	00094583          	lbu	a1,0(s2)
 a40:	f9e5                	bnez	a1,a30 <vprintf+0x16c>
        s = va_arg(ap, char*);
 a42:	8b4e                	mv	s6,s3
      state = 0;
 a44:	4981                	li	s3,0
 a46:	bdf9                	j	924 <vprintf+0x60>
          s = "(null)";
 a48:	00000917          	auipc	s2,0x0
 a4c:	57090913          	addi	s2,s2,1392 # fb8 <malloc+0x42a>
        while(*s != 0){
 a50:	02800593          	li	a1,40
 a54:	bff1                	j	a30 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 a56:	008b0913          	addi	s2,s6,8
 a5a:	000b4583          	lbu	a1,0(s6)
 a5e:	8556                	mv	a0,s5
 a60:	00000097          	auipc	ra,0x0
 a64:	d98080e7          	jalr	-616(ra) # 7f8 <putc>
 a68:	8b4a                	mv	s6,s2
      state = 0;
 a6a:	4981                	li	s3,0
 a6c:	bd65                	j	924 <vprintf+0x60>
        putc(fd, c);
 a6e:	85d2                	mv	a1,s4
 a70:	8556                	mv	a0,s5
 a72:	00000097          	auipc	ra,0x0
 a76:	d86080e7          	jalr	-634(ra) # 7f8 <putc>
      state = 0;
 a7a:	4981                	li	s3,0
 a7c:	b565                	j	924 <vprintf+0x60>
        s = va_arg(ap, char*);
 a7e:	8b4e                	mv	s6,s3
      state = 0;
 a80:	4981                	li	s3,0
 a82:	b54d                	j	924 <vprintf+0x60>
    }
  }
}
 a84:	70e6                	ld	ra,120(sp)
 a86:	7446                	ld	s0,112(sp)
 a88:	74a6                	ld	s1,104(sp)
 a8a:	7906                	ld	s2,96(sp)
 a8c:	69e6                	ld	s3,88(sp)
 a8e:	6a46                	ld	s4,80(sp)
 a90:	6aa6                	ld	s5,72(sp)
 a92:	6b06                	ld	s6,64(sp)
 a94:	7be2                	ld	s7,56(sp)
 a96:	7c42                	ld	s8,48(sp)
 a98:	7ca2                	ld	s9,40(sp)
 a9a:	7d02                	ld	s10,32(sp)
 a9c:	6de2                	ld	s11,24(sp)
 a9e:	6109                	addi	sp,sp,128
 aa0:	8082                	ret

0000000000000aa2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 aa2:	715d                	addi	sp,sp,-80
 aa4:	ec06                	sd	ra,24(sp)
 aa6:	e822                	sd	s0,16(sp)
 aa8:	1000                	addi	s0,sp,32
 aaa:	e010                	sd	a2,0(s0)
 aac:	e414                	sd	a3,8(s0)
 aae:	e818                	sd	a4,16(s0)
 ab0:	ec1c                	sd	a5,24(s0)
 ab2:	03043023          	sd	a6,32(s0)
 ab6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 aba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 abe:	8622                	mv	a2,s0
 ac0:	00000097          	auipc	ra,0x0
 ac4:	e04080e7          	jalr	-508(ra) # 8c4 <vprintf>
}
 ac8:	60e2                	ld	ra,24(sp)
 aca:	6442                	ld	s0,16(sp)
 acc:	6161                	addi	sp,sp,80
 ace:	8082                	ret

0000000000000ad0 <printf>:

void
printf(const char *fmt, ...)
{
 ad0:	711d                	addi	sp,sp,-96
 ad2:	ec06                	sd	ra,24(sp)
 ad4:	e822                	sd	s0,16(sp)
 ad6:	1000                	addi	s0,sp,32
 ad8:	e40c                	sd	a1,8(s0)
 ada:	e810                	sd	a2,16(s0)
 adc:	ec14                	sd	a3,24(s0)
 ade:	f018                	sd	a4,32(s0)
 ae0:	f41c                	sd	a5,40(s0)
 ae2:	03043823          	sd	a6,48(s0)
 ae6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aea:	00840613          	addi	a2,s0,8
 aee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 af2:	85aa                	mv	a1,a0
 af4:	4505                	li	a0,1
 af6:	00000097          	auipc	ra,0x0
 afa:	dce080e7          	jalr	-562(ra) # 8c4 <vprintf>
}
 afe:	60e2                	ld	ra,24(sp)
 b00:	6442                	ld	s0,16(sp)
 b02:	6125                	addi	sp,sp,96
 b04:	8082                	ret

0000000000000b06 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b06:	1141                	addi	sp,sp,-16
 b08:	e422                	sd	s0,8(sp)
 b0a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b0c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b10:	00000797          	auipc	a5,0x0
 b14:	4d07b783          	ld	a5,1232(a5) # fe0 <freep>
 b18:	a805                	j	b48 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b1a:	4618                	lw	a4,8(a2)
 b1c:	9db9                	addw	a1,a1,a4
 b1e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b22:	6398                	ld	a4,0(a5)
 b24:	6318                	ld	a4,0(a4)
 b26:	fee53823          	sd	a4,-16(a0)
 b2a:	a091                	j	b6e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b2c:	ff852703          	lw	a4,-8(a0)
 b30:	9e39                	addw	a2,a2,a4
 b32:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 b34:	ff053703          	ld	a4,-16(a0)
 b38:	e398                	sd	a4,0(a5)
 b3a:	a099                	j	b80 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b3c:	6398                	ld	a4,0(a5)
 b3e:	00e7e463          	bltu	a5,a4,b46 <free+0x40>
 b42:	00e6ea63          	bltu	a3,a4,b56 <free+0x50>
{
 b46:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b48:	fed7fae3          	bgeu	a5,a3,b3c <free+0x36>
 b4c:	6398                	ld	a4,0(a5)
 b4e:	00e6e463          	bltu	a3,a4,b56 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b52:	fee7eae3          	bltu	a5,a4,b46 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 b56:	ff852583          	lw	a1,-8(a0)
 b5a:	6390                	ld	a2,0(a5)
 b5c:	02059713          	slli	a4,a1,0x20
 b60:	9301                	srli	a4,a4,0x20
 b62:	0712                	slli	a4,a4,0x4
 b64:	9736                	add	a4,a4,a3
 b66:	fae60ae3          	beq	a2,a4,b1a <free+0x14>
    bp->s.ptr = p->s.ptr;
 b6a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b6e:	4790                	lw	a2,8(a5)
 b70:	02061713          	slli	a4,a2,0x20
 b74:	9301                	srli	a4,a4,0x20
 b76:	0712                	slli	a4,a4,0x4
 b78:	973e                	add	a4,a4,a5
 b7a:	fae689e3          	beq	a3,a4,b2c <free+0x26>
  } else
    p->s.ptr = bp;
 b7e:	e394                	sd	a3,0(a5)
  freep = p;
 b80:	00000717          	auipc	a4,0x0
 b84:	46f73023          	sd	a5,1120(a4) # fe0 <freep>
}
 b88:	6422                	ld	s0,8(sp)
 b8a:	0141                	addi	sp,sp,16
 b8c:	8082                	ret

0000000000000b8e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b8e:	7139                	addi	sp,sp,-64
 b90:	fc06                	sd	ra,56(sp)
 b92:	f822                	sd	s0,48(sp)
 b94:	f426                	sd	s1,40(sp)
 b96:	f04a                	sd	s2,32(sp)
 b98:	ec4e                	sd	s3,24(sp)
 b9a:	e852                	sd	s4,16(sp)
 b9c:	e456                	sd	s5,8(sp)
 b9e:	e05a                	sd	s6,0(sp)
 ba0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ba2:	02051493          	slli	s1,a0,0x20
 ba6:	9081                	srli	s1,s1,0x20
 ba8:	04bd                	addi	s1,s1,15
 baa:	8091                	srli	s1,s1,0x4
 bac:	0014899b          	addiw	s3,s1,1
 bb0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 bb2:	00000517          	auipc	a0,0x0
 bb6:	42e53503          	ld	a0,1070(a0) # fe0 <freep>
 bba:	c515                	beqz	a0,be6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bbc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bbe:	4798                	lw	a4,8(a5)
 bc0:	02977f63          	bgeu	a4,s1,bfe <malloc+0x70>
 bc4:	8a4e                	mv	s4,s3
 bc6:	0009871b          	sext.w	a4,s3
 bca:	6685                	lui	a3,0x1
 bcc:	00d77363          	bgeu	a4,a3,bd2 <malloc+0x44>
 bd0:	6a05                	lui	s4,0x1
 bd2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bd6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bda:	00000917          	auipc	s2,0x0
 bde:	40690913          	addi	s2,s2,1030 # fe0 <freep>
  if(p == (char*)-1)
 be2:	5afd                	li	s5,-1
 be4:	a88d                	j	c56 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 be6:	00000797          	auipc	a5,0x0
 bea:	40278793          	addi	a5,a5,1026 # fe8 <base>
 bee:	00000717          	auipc	a4,0x0
 bf2:	3ef73923          	sd	a5,1010(a4) # fe0 <freep>
 bf6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bf8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bfc:	b7e1                	j	bc4 <malloc+0x36>
      if(p->s.size == nunits)
 bfe:	02e48b63          	beq	s1,a4,c34 <malloc+0xa6>
        p->s.size -= nunits;
 c02:	4137073b          	subw	a4,a4,s3
 c06:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c08:	1702                	slli	a4,a4,0x20
 c0a:	9301                	srli	a4,a4,0x20
 c0c:	0712                	slli	a4,a4,0x4
 c0e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c10:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c14:	00000717          	auipc	a4,0x0
 c18:	3ca73623          	sd	a0,972(a4) # fe0 <freep>
      return (void*)(p + 1);
 c1c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c20:	70e2                	ld	ra,56(sp)
 c22:	7442                	ld	s0,48(sp)
 c24:	74a2                	ld	s1,40(sp)
 c26:	7902                	ld	s2,32(sp)
 c28:	69e2                	ld	s3,24(sp)
 c2a:	6a42                	ld	s4,16(sp)
 c2c:	6aa2                	ld	s5,8(sp)
 c2e:	6b02                	ld	s6,0(sp)
 c30:	6121                	addi	sp,sp,64
 c32:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c34:	6398                	ld	a4,0(a5)
 c36:	e118                	sd	a4,0(a0)
 c38:	bff1                	j	c14 <malloc+0x86>
  hp->s.size = nu;
 c3a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c3e:	0541                	addi	a0,a0,16
 c40:	00000097          	auipc	ra,0x0
 c44:	ec6080e7          	jalr	-314(ra) # b06 <free>
  return freep;
 c48:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c4c:	d971                	beqz	a0,c20 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c4e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c50:	4798                	lw	a4,8(a5)
 c52:	fa9776e3          	bgeu	a4,s1,bfe <malloc+0x70>
    if(p == freep)
 c56:	00093703          	ld	a4,0(s2)
 c5a:	853e                	mv	a0,a5
 c5c:	fef719e3          	bne	a4,a5,c4e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 c60:	8552                	mv	a0,s4
 c62:	00000097          	auipc	ra,0x0
 c66:	b76080e7          	jalr	-1162(ra) # 7d8 <sbrk>
  if(p == (char*)-1)
 c6a:	fd5518e3          	bne	a0,s5,c3a <malloc+0xac>
        return 0;
 c6e:	4501                	li	a0,0
 c70:	bf45                	j	c20 <malloc+0x92>
