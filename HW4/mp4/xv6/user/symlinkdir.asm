
user/_symlinkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
static void public12(void);
static void cleanup(void);

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	1800                	addi	s0,sp,48
}

static void
cleanup(void)
{
  unlink("/testsymlink2/p");
   c:	00001517          	auipc	a0,0x1
  10:	98c50513          	addi	a0,a0,-1652 # 998 <malloc+0xea>
  14:	00000097          	auipc	ra,0x0
  18:	4ac080e7          	jalr	1196(ra) # 4c0 <unlink>
  unlink("/testsymlink3/q");
  1c:	00001517          	auipc	a0,0x1
  20:	98c50513          	addi	a0,a0,-1652 # 9a8 <malloc+0xfa>
  24:	00000097          	auipc	ra,0x0
  28:	49c080e7          	jalr	1180(ra) # 4c0 <unlink>
  unlink("/testsymlink2");
  2c:	00001517          	auipc	a0,0x1
  30:	98c50513          	addi	a0,a0,-1652 # 9b8 <malloc+0x10a>
  34:	00000097          	auipc	ra,0x0
  38:	48c080e7          	jalr	1164(ra) # 4c0 <unlink>
  unlink("/testsymlink3");
  3c:	00001517          	auipc	a0,0x1
  40:	98c50513          	addi	a0,a0,-1652 # 9c8 <malloc+0x11a>
  44:	00000097          	auipc	ra,0x0
  48:	47c080e7          	jalr	1148(ra) # 4c0 <unlink>

static void
public12()
{
  int r, fd1 = -1, fd2 = -1;
  char c = 0, c2 = 0;
  4c:	fc040f23          	sb	zero,-34(s0)
  50:	fc040fa3          	sb	zero,-33(s0)
    
  printf("Start: test symlinks to directory\n");
  54:	00001517          	auipc	a0,0x1
  58:	98450513          	addi	a0,a0,-1660 # 9d8 <malloc+0x12a>
  5c:	00000097          	auipc	ra,0x0
  60:	794080e7          	jalr	1940(ra) # 7f0 <printf>

  mkdir("/testsymlink2");
  64:	00001517          	auipc	a0,0x1
  68:	95450513          	addi	a0,a0,-1708 # 9b8 <malloc+0x10a>
  6c:	00000097          	auipc	ra,0x0
  70:	46c080e7          	jalr	1132(ra) # 4d8 <mkdir>
  mkdir("/testsymlink3");
  74:	00001517          	auipc	a0,0x1
  78:	95450513          	addi	a0,a0,-1708 # 9c8 <malloc+0x11a>
  7c:	00000097          	auipc	ra,0x0
  80:	45c080e7          	jalr	1116(ra) # 4d8 <mkdir>

  fd1 = open("/testsymlink2/p", O_CREATE | O_RDWR);
  84:	20200593          	li	a1,514
  88:	00001517          	auipc	a0,0x1
  8c:	91050513          	addi	a0,a0,-1776 # 998 <malloc+0xea>
  90:	00000097          	auipc	ra,0x0
  94:	420080e7          	jalr	1056(ra) # 4b0 <open>
  98:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open p");
  9a:	08054163          	bltz	a0,11c <main+0x11c>

  r = symlink("/testsymlink2", "/testsymlink3/q");
  9e:	00001597          	auipc	a1,0x1
  a2:	90a58593          	addi	a1,a1,-1782 # 9a8 <malloc+0xfa>
  a6:	00001517          	auipc	a0,0x1
  aa:	91250513          	addi	a0,a0,-1774 # 9b8 <malloc+0x10a>
  ae:	00000097          	auipc	ra,0x0
  b2:	462080e7          	jalr	1122(ra) # 510 <symlink>
  if(r < 0)
  b6:	0a054363          	bltz	a0,15c <main+0x15c>
    fail("symlink q -> p failed");

  fd2 = open("/testsymlink3/q/p", O_RDWR);
  ba:	4589                	li	a1,2
  bc:	00001517          	auipc	a0,0x1
  c0:	98450513          	addi	a0,a0,-1660 # a40 <malloc+0x192>
  c4:	00000097          	auipc	ra,0x0
  c8:	3ec080e7          	jalr	1004(ra) # 4b0 <open>
  cc:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open /testsymlink3/q/p\n");
  ce:	0a054663          	bltz	a0,17a <main+0x17a>

  printf("public testcase 1: ok\n");
  d2:	00001517          	auipc	a0,0x1
  d6:	9b650513          	addi	a0,a0,-1610 # a88 <malloc+0x1da>
  da:	00000097          	auipc	ra,0x0
  de:	716080e7          	jalr	1814(ra) # 7f0 <printf>

  c = '#';
  e2:	02300793          	li	a5,35
  e6:	fcf40f23          	sb	a5,-34(s0)
  r = write(fd1, &c, 1);
  ea:	4605                	li	a2,1
  ec:	fde40593          	addi	a1,s0,-34
  f0:	8526                	mv	a0,s1
  f2:	00000097          	auipc	ra,0x0
  f6:	39e080e7          	jalr	926(ra) # 490 <write>
  if(r!=1) fail("Failed to write to /testsymlink2/p\n");
  fa:	4785                	li	a5,1
  fc:	08f50d63          	beq	a0,a5,196 <main+0x196>
 100:	00001517          	auipc	a0,0x1
 104:	9a050513          	addi	a0,a0,-1632 # aa0 <malloc+0x1f2>
 108:	00000097          	auipc	ra,0x0
 10c:	6e8080e7          	jalr	1768(ra) # 7f0 <printf>
 110:	4785                	li	a5,1
 112:	00001717          	auipc	a4,0x1
 116:	a8f72723          	sw	a5,-1394(a4) # ba0 <failed>
 11a:	a839                	j	138 <main+0x138>
  if(fd1 < 0) fail("failed to open p");
 11c:	00001517          	auipc	a0,0x1
 120:	8e450513          	addi	a0,a0,-1820 # a00 <malloc+0x152>
 124:	00000097          	auipc	ra,0x0
 128:	6cc080e7          	jalr	1740(ra) # 7f0 <printf>
 12c:	4785                	li	a5,1
 12e:	00001717          	auipc	a4,0x1
 132:	a6f72923          	sw	a5,-1422(a4) # ba0 <failed>
  int r, fd1 = -1, fd2 = -1;
 136:	597d                	li	s2,-1
  if(c!=c2)
    fail("Value read from /testsymlink2/p differs from value written to /testsymlink3/q/p\n");

  printf("public testcase 2: ok\n");
done:
  close(fd1);
 138:	8526                	mv	a0,s1
 13a:	00000097          	auipc	ra,0x0
 13e:	35e080e7          	jalr	862(ra) # 498 <close>
  close(fd2);
 142:	854a                	mv	a0,s2
 144:	00000097          	auipc	ra,0x0
 148:	354080e7          	jalr	852(ra) # 498 <close>
  exit(failed);
 14c:	00001517          	auipc	a0,0x1
 150:	a5452503          	lw	a0,-1452(a0) # ba0 <failed>
 154:	00000097          	auipc	ra,0x0
 158:	31c080e7          	jalr	796(ra) # 470 <exit>
    fail("symlink q -> p failed");
 15c:	00001517          	auipc	a0,0x1
 160:	8c450513          	addi	a0,a0,-1852 # a20 <malloc+0x172>
 164:	00000097          	auipc	ra,0x0
 168:	68c080e7          	jalr	1676(ra) # 7f0 <printf>
 16c:	4785                	li	a5,1
 16e:	00001717          	auipc	a4,0x1
 172:	a2f72923          	sw	a5,-1486(a4) # ba0 <failed>
  int r, fd1 = -1, fd2 = -1;
 176:	597d                	li	s2,-1
    fail("symlink q -> p failed");
 178:	b7c1                	j	138 <main+0x138>
  if(fd2<0) fail("Failed to open /testsymlink3/q/p\n");
 17a:	00001517          	auipc	a0,0x1
 17e:	8de50513          	addi	a0,a0,-1826 # a58 <malloc+0x1aa>
 182:	00000097          	auipc	ra,0x0
 186:	66e080e7          	jalr	1646(ra) # 7f0 <printf>
 18a:	4785                	li	a5,1
 18c:	00001717          	auipc	a4,0x1
 190:	a0f72a23          	sw	a5,-1516(a4) # ba0 <failed>
 194:	b755                	j	138 <main+0x138>
  r = read(fd2, &c2, 1);
 196:	4605                	li	a2,1
 198:	fdf40593          	addi	a1,s0,-33
 19c:	854a                	mv	a0,s2
 19e:	00000097          	auipc	ra,0x0
 1a2:	2ea080e7          	jalr	746(ra) # 488 <read>
  if(r!=1) fail("Failed to read from /testsymlink3/q/p\n");
 1a6:	4785                	li	a5,1
 1a8:	02f51663          	bne	a0,a5,1d4 <main+0x1d4>
  if(c!=c2)
 1ac:	fde44703          	lbu	a4,-34(s0)
 1b0:	fdf44783          	lbu	a5,-33(s0)
 1b4:	02f70e63          	beq	a4,a5,1f0 <main+0x1f0>
    fail("Value read from /testsymlink2/p differs from value written to /testsymlink3/q/p\n");
 1b8:	00001517          	auipc	a0,0x1
 1bc:	95050513          	addi	a0,a0,-1712 # b08 <malloc+0x25a>
 1c0:	00000097          	auipc	ra,0x0
 1c4:	630080e7          	jalr	1584(ra) # 7f0 <printf>
 1c8:	4785                	li	a5,1
 1ca:	00001717          	auipc	a4,0x1
 1ce:	9cf72b23          	sw	a5,-1578(a4) # ba0 <failed>
 1d2:	b79d                	j	138 <main+0x138>
  if(r!=1) fail("Failed to read from /testsymlink3/q/p\n");
 1d4:	00001517          	auipc	a0,0x1
 1d8:	8fc50513          	addi	a0,a0,-1796 # ad0 <malloc+0x222>
 1dc:	00000097          	auipc	ra,0x0
 1e0:	614080e7          	jalr	1556(ra) # 7f0 <printf>
 1e4:	4785                	li	a5,1
 1e6:	00001717          	auipc	a4,0x1
 1ea:	9af72d23          	sw	a5,-1606(a4) # ba0 <failed>
 1ee:	b7a9                	j	138 <main+0x138>
  printf("public testcase 2: ok\n");
 1f0:	00001517          	auipc	a0,0x1
 1f4:	97850513          	addi	a0,a0,-1672 # b68 <malloc+0x2ba>
 1f8:	00000097          	auipc	ra,0x0
 1fc:	5f8080e7          	jalr	1528(ra) # 7f0 <printf>
 200:	bf25                	j	138 <main+0x138>

0000000000000202 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 208:	87aa                	mv	a5,a0
 20a:	0585                	addi	a1,a1,1
 20c:	0785                	addi	a5,a5,1
 20e:	fff5c703          	lbu	a4,-1(a1)
 212:	fee78fa3          	sb	a4,-1(a5)
 216:	fb75                	bnez	a4,20a <strcpy+0x8>
    ;
  return os;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret

000000000000021e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 224:	00054783          	lbu	a5,0(a0)
 228:	cb91                	beqz	a5,23c <strcmp+0x1e>
 22a:	0005c703          	lbu	a4,0(a1)
 22e:	00f71763          	bne	a4,a5,23c <strcmp+0x1e>
    p++, q++;
 232:	0505                	addi	a0,a0,1
 234:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 236:	00054783          	lbu	a5,0(a0)
 23a:	fbe5                	bnez	a5,22a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 23c:	0005c503          	lbu	a0,0(a1)
}
 240:	40a7853b          	subw	a0,a5,a0
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret

000000000000024a <strlen>:

uint
strlen(const char *s)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 250:	00054783          	lbu	a5,0(a0)
 254:	cf91                	beqz	a5,270 <strlen+0x26>
 256:	0505                	addi	a0,a0,1
 258:	87aa                	mv	a5,a0
 25a:	4685                	li	a3,1
 25c:	9e89                	subw	a3,a3,a0
 25e:	00f6853b          	addw	a0,a3,a5
 262:	0785                	addi	a5,a5,1
 264:	fff7c703          	lbu	a4,-1(a5)
 268:	fb7d                	bnez	a4,25e <strlen+0x14>
    ;
  return n;
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
  for(n = 0; s[n]; n++)
 270:	4501                	li	a0,0
 272:	bfe5                	j	26a <strlen+0x20>

0000000000000274 <memset>:

void*
memset(void *dst, int c, uint n)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 27a:	ca19                	beqz	a2,290 <memset+0x1c>
 27c:	87aa                	mv	a5,a0
 27e:	1602                	slli	a2,a2,0x20
 280:	9201                	srli	a2,a2,0x20
 282:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 286:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 28a:	0785                	addi	a5,a5,1
 28c:	fee79de3          	bne	a5,a4,286 <memset+0x12>
  }
  return dst;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <strchr>:

char*
strchr(const char *s, char c)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cb99                	beqz	a5,2b6 <strchr+0x20>
    if(*s == c)
 2a2:	00f58763          	beq	a1,a5,2b0 <strchr+0x1a>
  for(; *s; s++)
 2a6:	0505                	addi	a0,a0,1
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	fbfd                	bnez	a5,2a2 <strchr+0xc>
      return (char*)s;
  return 0;
 2ae:	4501                	li	a0,0
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
  return 0;
 2b6:	4501                	li	a0,0
 2b8:	bfe5                	j	2b0 <strchr+0x1a>

00000000000002ba <gets>:

char*
gets(char *buf, int max)
{
 2ba:	711d                	addi	sp,sp,-96
 2bc:	ec86                	sd	ra,88(sp)
 2be:	e8a2                	sd	s0,80(sp)
 2c0:	e4a6                	sd	s1,72(sp)
 2c2:	e0ca                	sd	s2,64(sp)
 2c4:	fc4e                	sd	s3,56(sp)
 2c6:	f852                	sd	s4,48(sp)
 2c8:	f456                	sd	s5,40(sp)
 2ca:	f05a                	sd	s6,32(sp)
 2cc:	ec5e                	sd	s7,24(sp)
 2ce:	1080                	addi	s0,sp,96
 2d0:	8baa                	mv	s7,a0
 2d2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d4:	892a                	mv	s2,a0
 2d6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d8:	4aa9                	li	s5,10
 2da:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2dc:	89a6                	mv	s3,s1
 2de:	2485                	addiw	s1,s1,1
 2e0:	0344d863          	bge	s1,s4,310 <gets+0x56>
    cc = read(0, &c, 1);
 2e4:	4605                	li	a2,1
 2e6:	faf40593          	addi	a1,s0,-81
 2ea:	4501                	li	a0,0
 2ec:	00000097          	auipc	ra,0x0
 2f0:	19c080e7          	jalr	412(ra) # 488 <read>
    if(cc < 1)
 2f4:	00a05e63          	blez	a0,310 <gets+0x56>
    buf[i++] = c;
 2f8:	faf44783          	lbu	a5,-81(s0)
 2fc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 300:	01578763          	beq	a5,s5,30e <gets+0x54>
 304:	0905                	addi	s2,s2,1
 306:	fd679be3          	bne	a5,s6,2dc <gets+0x22>
  for(i=0; i+1 < max; ){
 30a:	89a6                	mv	s3,s1
 30c:	a011                	j	310 <gets+0x56>
 30e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 310:	99de                	add	s3,s3,s7
 312:	00098023          	sb	zero,0(s3)
  return buf;
}
 316:	855e                	mv	a0,s7
 318:	60e6                	ld	ra,88(sp)
 31a:	6446                	ld	s0,80(sp)
 31c:	64a6                	ld	s1,72(sp)
 31e:	6906                	ld	s2,64(sp)
 320:	79e2                	ld	s3,56(sp)
 322:	7a42                	ld	s4,48(sp)
 324:	7aa2                	ld	s5,40(sp)
 326:	7b02                	ld	s6,32(sp)
 328:	6be2                	ld	s7,24(sp)
 32a:	6125                	addi	sp,sp,96
 32c:	8082                	ret

000000000000032e <stat>:

int
stat(const char *n, struct stat *st)
{
 32e:	1101                	addi	sp,sp,-32
 330:	ec06                	sd	ra,24(sp)
 332:	e822                	sd	s0,16(sp)
 334:	e426                	sd	s1,8(sp)
 336:	e04a                	sd	s2,0(sp)
 338:	1000                	addi	s0,sp,32
 33a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33c:	4581                	li	a1,0
 33e:	00000097          	auipc	ra,0x0
 342:	172080e7          	jalr	370(ra) # 4b0 <open>
  if(fd < 0)
 346:	02054563          	bltz	a0,370 <stat+0x42>
 34a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 34c:	85ca                	mv	a1,s2
 34e:	00000097          	auipc	ra,0x0
 352:	17a080e7          	jalr	378(ra) # 4c8 <fstat>
 356:	892a                	mv	s2,a0
  close(fd);
 358:	8526                	mv	a0,s1
 35a:	00000097          	auipc	ra,0x0
 35e:	13e080e7          	jalr	318(ra) # 498 <close>
  return r;
}
 362:	854a                	mv	a0,s2
 364:	60e2                	ld	ra,24(sp)
 366:	6442                	ld	s0,16(sp)
 368:	64a2                	ld	s1,8(sp)
 36a:	6902                	ld	s2,0(sp)
 36c:	6105                	addi	sp,sp,32
 36e:	8082                	ret
    return -1;
 370:	597d                	li	s2,-1
 372:	bfc5                	j	362 <stat+0x34>

0000000000000374 <atoi>:

int
atoi(const char *s)
{
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 37a:	00054603          	lbu	a2,0(a0)
 37e:	fd06079b          	addiw	a5,a2,-48
 382:	0ff7f793          	andi	a5,a5,255
 386:	4725                	li	a4,9
 388:	02f76963          	bltu	a4,a5,3ba <atoi+0x46>
 38c:	86aa                	mv	a3,a0
  n = 0;
 38e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 390:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 392:	0685                	addi	a3,a3,1
 394:	0025179b          	slliw	a5,a0,0x2
 398:	9fa9                	addw	a5,a5,a0
 39a:	0017979b          	slliw	a5,a5,0x1
 39e:	9fb1                	addw	a5,a5,a2
 3a0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a4:	0006c603          	lbu	a2,0(a3)
 3a8:	fd06071b          	addiw	a4,a2,-48
 3ac:	0ff77713          	andi	a4,a4,255
 3b0:	fee5f1e3          	bgeu	a1,a4,392 <atoi+0x1e>
  return n;
}
 3b4:	6422                	ld	s0,8(sp)
 3b6:	0141                	addi	sp,sp,16
 3b8:	8082                	ret
  n = 0;
 3ba:	4501                	li	a0,0
 3bc:	bfe5                	j	3b4 <atoi+0x40>

00000000000003be <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e422                	sd	s0,8(sp)
 3c2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c4:	02b57463          	bgeu	a0,a1,3ec <memmove+0x2e>
    while(n-- > 0)
 3c8:	00c05f63          	blez	a2,3e6 <memmove+0x28>
 3cc:	1602                	slli	a2,a2,0x20
 3ce:	9201                	srli	a2,a2,0x20
 3d0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d4:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d6:	0585                	addi	a1,a1,1
 3d8:	0705                	addi	a4,a4,1
 3da:	fff5c683          	lbu	a3,-1(a1)
 3de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3e2:	fee79ae3          	bne	a5,a4,3d6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret
    dst += n;
 3ec:	00c50733          	add	a4,a0,a2
    src += n;
 3f0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f2:	fec05ae3          	blez	a2,3e6 <memmove+0x28>
 3f6:	fff6079b          	addiw	a5,a2,-1
 3fa:	1782                	slli	a5,a5,0x20
 3fc:	9381                	srli	a5,a5,0x20
 3fe:	fff7c793          	not	a5,a5
 402:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 404:	15fd                	addi	a1,a1,-1
 406:	177d                	addi	a4,a4,-1
 408:	0005c683          	lbu	a3,0(a1)
 40c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 410:	fee79ae3          	bne	a5,a4,404 <memmove+0x46>
 414:	bfc9                	j	3e6 <memmove+0x28>

0000000000000416 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 416:	1141                	addi	sp,sp,-16
 418:	e422                	sd	s0,8(sp)
 41a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41c:	ca05                	beqz	a2,44c <memcmp+0x36>
 41e:	fff6069b          	addiw	a3,a2,-1
 422:	1682                	slli	a3,a3,0x20
 424:	9281                	srli	a3,a3,0x20
 426:	0685                	addi	a3,a3,1
 428:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 42a:	00054783          	lbu	a5,0(a0)
 42e:	0005c703          	lbu	a4,0(a1)
 432:	00e79863          	bne	a5,a4,442 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 436:	0505                	addi	a0,a0,1
    p2++;
 438:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 43a:	fed518e3          	bne	a0,a3,42a <memcmp+0x14>
  }
  return 0;
 43e:	4501                	li	a0,0
 440:	a019                	j	446 <memcmp+0x30>
      return *p1 - *p2;
 442:	40e7853b          	subw	a0,a5,a4
}
 446:	6422                	ld	s0,8(sp)
 448:	0141                	addi	sp,sp,16
 44a:	8082                	ret
  return 0;
 44c:	4501                	li	a0,0
 44e:	bfe5                	j	446 <memcmp+0x30>

0000000000000450 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 450:	1141                	addi	sp,sp,-16
 452:	e406                	sd	ra,8(sp)
 454:	e022                	sd	s0,0(sp)
 456:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 458:	00000097          	auipc	ra,0x0
 45c:	f66080e7          	jalr	-154(ra) # 3be <memmove>
}
 460:	60a2                	ld	ra,8(sp)
 462:	6402                	ld	s0,0(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret

0000000000000468 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 468:	4885                	li	a7,1
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <exit>:
.global exit
exit:
 li a7, SYS_exit
 470:	4889                	li	a7,2
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <wait>:
.global wait
wait:
 li a7, SYS_wait
 478:	488d                	li	a7,3
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 480:	4891                	li	a7,4
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <read>:
.global read
read:
 li a7, SYS_read
 488:	4895                	li	a7,5
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <write>:
.global write
write:
 li a7, SYS_write
 490:	48c1                	li	a7,16
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <close>:
.global close
close:
 li a7, SYS_close
 498:	48d5                	li	a7,21
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4a0:	4899                	li	a7,6
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a8:	489d                	li	a7,7
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <open>:
.global open
open:
 li a7, SYS_open
 4b0:	48bd                	li	a7,15
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b8:	48c5                	li	a7,17
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4c0:	48c9                	li	a7,18
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c8:	48a1                	li	a7,8
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <link>:
.global link
link:
 li a7, SYS_link
 4d0:	48cd                	li	a7,19
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d8:	48d1                	li	a7,20
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4e0:	48a5                	li	a7,9
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e8:	48a9                	li	a7,10
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4f0:	48ad                	li	a7,11
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f8:	48b1                	li	a7,12
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 500:	48b5                	li	a7,13
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 508:	48b9                	li	a7,14
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 510:	48d9                	li	a7,22
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 518:	1101                	addi	sp,sp,-32
 51a:	ec06                	sd	ra,24(sp)
 51c:	e822                	sd	s0,16(sp)
 51e:	1000                	addi	s0,sp,32
 520:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 524:	4605                	li	a2,1
 526:	fef40593          	addi	a1,s0,-17
 52a:	00000097          	auipc	ra,0x0
 52e:	f66080e7          	jalr	-154(ra) # 490 <write>
}
 532:	60e2                	ld	ra,24(sp)
 534:	6442                	ld	s0,16(sp)
 536:	6105                	addi	sp,sp,32
 538:	8082                	ret

000000000000053a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 53a:	7139                	addi	sp,sp,-64
 53c:	fc06                	sd	ra,56(sp)
 53e:	f822                	sd	s0,48(sp)
 540:	f426                	sd	s1,40(sp)
 542:	f04a                	sd	s2,32(sp)
 544:	ec4e                	sd	s3,24(sp)
 546:	0080                	addi	s0,sp,64
 548:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 54a:	c299                	beqz	a3,550 <printint+0x16>
 54c:	0805c863          	bltz	a1,5dc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 550:	2581                	sext.w	a1,a1
  neg = 0;
 552:	4881                	li	a7,0
 554:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 558:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 55a:	2601                	sext.w	a2,a2
 55c:	00000517          	auipc	a0,0x0
 560:	62c50513          	addi	a0,a0,1580 # b88 <digits>
 564:	883a                	mv	a6,a4
 566:	2705                	addiw	a4,a4,1
 568:	02c5f7bb          	remuw	a5,a1,a2
 56c:	1782                	slli	a5,a5,0x20
 56e:	9381                	srli	a5,a5,0x20
 570:	97aa                	add	a5,a5,a0
 572:	0007c783          	lbu	a5,0(a5)
 576:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 57a:	0005879b          	sext.w	a5,a1
 57e:	02c5d5bb          	divuw	a1,a1,a2
 582:	0685                	addi	a3,a3,1
 584:	fec7f0e3          	bgeu	a5,a2,564 <printint+0x2a>
  if(neg)
 588:	00088b63          	beqz	a7,59e <printint+0x64>
    buf[i++] = '-';
 58c:	fd040793          	addi	a5,s0,-48
 590:	973e                	add	a4,a4,a5
 592:	02d00793          	li	a5,45
 596:	fef70823          	sb	a5,-16(a4)
 59a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 59e:	02e05863          	blez	a4,5ce <printint+0x94>
 5a2:	fc040793          	addi	a5,s0,-64
 5a6:	00e78933          	add	s2,a5,a4
 5aa:	fff78993          	addi	s3,a5,-1
 5ae:	99ba                	add	s3,s3,a4
 5b0:	377d                	addiw	a4,a4,-1
 5b2:	1702                	slli	a4,a4,0x20
 5b4:	9301                	srli	a4,a4,0x20
 5b6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ba:	fff94583          	lbu	a1,-1(s2)
 5be:	8526                	mv	a0,s1
 5c0:	00000097          	auipc	ra,0x0
 5c4:	f58080e7          	jalr	-168(ra) # 518 <putc>
  while(--i >= 0)
 5c8:	197d                	addi	s2,s2,-1
 5ca:	ff3918e3          	bne	s2,s3,5ba <printint+0x80>
}
 5ce:	70e2                	ld	ra,56(sp)
 5d0:	7442                	ld	s0,48(sp)
 5d2:	74a2                	ld	s1,40(sp)
 5d4:	7902                	ld	s2,32(sp)
 5d6:	69e2                	ld	s3,24(sp)
 5d8:	6121                	addi	sp,sp,64
 5da:	8082                	ret
    x = -xx;
 5dc:	40b005bb          	negw	a1,a1
    neg = 1;
 5e0:	4885                	li	a7,1
    x = -xx;
 5e2:	bf8d                	j	554 <printint+0x1a>

00000000000005e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5e4:	7119                	addi	sp,sp,-128
 5e6:	fc86                	sd	ra,120(sp)
 5e8:	f8a2                	sd	s0,112(sp)
 5ea:	f4a6                	sd	s1,104(sp)
 5ec:	f0ca                	sd	s2,96(sp)
 5ee:	ecce                	sd	s3,88(sp)
 5f0:	e8d2                	sd	s4,80(sp)
 5f2:	e4d6                	sd	s5,72(sp)
 5f4:	e0da                	sd	s6,64(sp)
 5f6:	fc5e                	sd	s7,56(sp)
 5f8:	f862                	sd	s8,48(sp)
 5fa:	f466                	sd	s9,40(sp)
 5fc:	f06a                	sd	s10,32(sp)
 5fe:	ec6e                	sd	s11,24(sp)
 600:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 602:	0005c903          	lbu	s2,0(a1)
 606:	18090f63          	beqz	s2,7a4 <vprintf+0x1c0>
 60a:	8aaa                	mv	s5,a0
 60c:	8b32                	mv	s6,a2
 60e:	00158493          	addi	s1,a1,1
  state = 0;
 612:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 614:	02500a13          	li	s4,37
      if(c == 'd'){
 618:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 61c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 620:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 624:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 628:	00000b97          	auipc	s7,0x0
 62c:	560b8b93          	addi	s7,s7,1376 # b88 <digits>
 630:	a839                	j	64e <vprintf+0x6a>
        putc(fd, c);
 632:	85ca                	mv	a1,s2
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	ee2080e7          	jalr	-286(ra) # 518 <putc>
 63e:	a019                	j	644 <vprintf+0x60>
    } else if(state == '%'){
 640:	01498f63          	beq	s3,s4,65e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 644:	0485                	addi	s1,s1,1
 646:	fff4c903          	lbu	s2,-1(s1)
 64a:	14090d63          	beqz	s2,7a4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 64e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 652:	fe0997e3          	bnez	s3,640 <vprintf+0x5c>
      if(c == '%'){
 656:	fd479ee3          	bne	a5,s4,632 <vprintf+0x4e>
        state = '%';
 65a:	89be                	mv	s3,a5
 65c:	b7e5                	j	644 <vprintf+0x60>
      if(c == 'd'){
 65e:	05878063          	beq	a5,s8,69e <vprintf+0xba>
      } else if(c == 'l') {
 662:	05978c63          	beq	a5,s9,6ba <vprintf+0xd6>
      } else if(c == 'x') {
 666:	07a78863          	beq	a5,s10,6d6 <vprintf+0xf2>
      } else if(c == 'p') {
 66a:	09b78463          	beq	a5,s11,6f2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 66e:	07300713          	li	a4,115
 672:	0ce78663          	beq	a5,a4,73e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 676:	06300713          	li	a4,99
 67a:	0ee78e63          	beq	a5,a4,776 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 67e:	11478863          	beq	a5,s4,78e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 682:	85d2                	mv	a1,s4
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	e92080e7          	jalr	-366(ra) # 518 <putc>
        putc(fd, c);
 68e:	85ca                	mv	a1,s2
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e86080e7          	jalr	-378(ra) # 518 <putc>
      }
      state = 0;
 69a:	4981                	li	s3,0
 69c:	b765                	j	644 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 69e:	008b0913          	addi	s2,s6,8
 6a2:	4685                	li	a3,1
 6a4:	4629                	li	a2,10
 6a6:	000b2583          	lw	a1,0(s6)
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	e8e080e7          	jalr	-370(ra) # 53a <printint>
 6b4:	8b4a                	mv	s6,s2
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b771                	j	644 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	008b0913          	addi	s2,s6,8
 6be:	4681                	li	a3,0
 6c0:	4629                	li	a2,10
 6c2:	000b2583          	lw	a1,0(s6)
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	e72080e7          	jalr	-398(ra) # 53a <printint>
 6d0:	8b4a                	mv	s6,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bf85                	j	644 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6d6:	008b0913          	addi	s2,s6,8
 6da:	4681                	li	a3,0
 6dc:	4641                	li	a2,16
 6de:	000b2583          	lw	a1,0(s6)
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	e56080e7          	jalr	-426(ra) # 53a <printint>
 6ec:	8b4a                	mv	s6,s2
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bf91                	j	644 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6f2:	008b0793          	addi	a5,s6,8
 6f6:	f8f43423          	sd	a5,-120(s0)
 6fa:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6fe:	03000593          	li	a1,48
 702:	8556                	mv	a0,s5
 704:	00000097          	auipc	ra,0x0
 708:	e14080e7          	jalr	-492(ra) # 518 <putc>
  putc(fd, 'x');
 70c:	85ea                	mv	a1,s10
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	e08080e7          	jalr	-504(ra) # 518 <putc>
 718:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71a:	03c9d793          	srli	a5,s3,0x3c
 71e:	97de                	add	a5,a5,s7
 720:	0007c583          	lbu	a1,0(a5)
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	df2080e7          	jalr	-526(ra) # 518 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72e:	0992                	slli	s3,s3,0x4
 730:	397d                	addiw	s2,s2,-1
 732:	fe0914e3          	bnez	s2,71a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 736:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b721                	j	644 <vprintf+0x60>
        s = va_arg(ap, char*);
 73e:	008b0993          	addi	s3,s6,8
 742:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 746:	02090163          	beqz	s2,768 <vprintf+0x184>
        while(*s != 0){
 74a:	00094583          	lbu	a1,0(s2)
 74e:	c9a1                	beqz	a1,79e <vprintf+0x1ba>
          putc(fd, *s);
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	dc6080e7          	jalr	-570(ra) # 518 <putc>
          s++;
 75a:	0905                	addi	s2,s2,1
        while(*s != 0){
 75c:	00094583          	lbu	a1,0(s2)
 760:	f9e5                	bnez	a1,750 <vprintf+0x16c>
        s = va_arg(ap, char*);
 762:	8b4e                	mv	s6,s3
      state = 0;
 764:	4981                	li	s3,0
 766:	bdf9                	j	644 <vprintf+0x60>
          s = "(null)";
 768:	00000917          	auipc	s2,0x0
 76c:	41890913          	addi	s2,s2,1048 # b80 <malloc+0x2d2>
        while(*s != 0){
 770:	02800593          	li	a1,40
 774:	bff1                	j	750 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 776:	008b0913          	addi	s2,s6,8
 77a:	000b4583          	lbu	a1,0(s6)
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	d98080e7          	jalr	-616(ra) # 518 <putc>
 788:	8b4a                	mv	s6,s2
      state = 0;
 78a:	4981                	li	s3,0
 78c:	bd65                	j	644 <vprintf+0x60>
        putc(fd, c);
 78e:	85d2                	mv	a1,s4
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	d86080e7          	jalr	-634(ra) # 518 <putc>
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b565                	j	644 <vprintf+0x60>
        s = va_arg(ap, char*);
 79e:	8b4e                	mv	s6,s3
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	b54d                	j	644 <vprintf+0x60>
    }
  }
}
 7a4:	70e6                	ld	ra,120(sp)
 7a6:	7446                	ld	s0,112(sp)
 7a8:	74a6                	ld	s1,104(sp)
 7aa:	7906                	ld	s2,96(sp)
 7ac:	69e6                	ld	s3,88(sp)
 7ae:	6a46                	ld	s4,80(sp)
 7b0:	6aa6                	ld	s5,72(sp)
 7b2:	6b06                	ld	s6,64(sp)
 7b4:	7be2                	ld	s7,56(sp)
 7b6:	7c42                	ld	s8,48(sp)
 7b8:	7ca2                	ld	s9,40(sp)
 7ba:	7d02                	ld	s10,32(sp)
 7bc:	6de2                	ld	s11,24(sp)
 7be:	6109                	addi	sp,sp,128
 7c0:	8082                	ret

00000000000007c2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c2:	715d                	addi	sp,sp,-80
 7c4:	ec06                	sd	ra,24(sp)
 7c6:	e822                	sd	s0,16(sp)
 7c8:	1000                	addi	s0,sp,32
 7ca:	e010                	sd	a2,0(s0)
 7cc:	e414                	sd	a3,8(s0)
 7ce:	e818                	sd	a4,16(s0)
 7d0:	ec1c                	sd	a5,24(s0)
 7d2:	03043023          	sd	a6,32(s0)
 7d6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7da:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7de:	8622                	mv	a2,s0
 7e0:	00000097          	auipc	ra,0x0
 7e4:	e04080e7          	jalr	-508(ra) # 5e4 <vprintf>
}
 7e8:	60e2                	ld	ra,24(sp)
 7ea:	6442                	ld	s0,16(sp)
 7ec:	6161                	addi	sp,sp,80
 7ee:	8082                	ret

00000000000007f0 <printf>:

void
printf(const char *fmt, ...)
{
 7f0:	711d                	addi	sp,sp,-96
 7f2:	ec06                	sd	ra,24(sp)
 7f4:	e822                	sd	s0,16(sp)
 7f6:	1000                	addi	s0,sp,32
 7f8:	e40c                	sd	a1,8(s0)
 7fa:	e810                	sd	a2,16(s0)
 7fc:	ec14                	sd	a3,24(s0)
 7fe:	f018                	sd	a4,32(s0)
 800:	f41c                	sd	a5,40(s0)
 802:	03043823          	sd	a6,48(s0)
 806:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 80a:	00840613          	addi	a2,s0,8
 80e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 812:	85aa                	mv	a1,a0
 814:	4505                	li	a0,1
 816:	00000097          	auipc	ra,0x0
 81a:	dce080e7          	jalr	-562(ra) # 5e4 <vprintf>
}
 81e:	60e2                	ld	ra,24(sp)
 820:	6442                	ld	s0,16(sp)
 822:	6125                	addi	sp,sp,96
 824:	8082                	ret

0000000000000826 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 826:	1141                	addi	sp,sp,-16
 828:	e422                	sd	s0,8(sp)
 82a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 82c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 830:	00000797          	auipc	a5,0x0
 834:	3787b783          	ld	a5,888(a5) # ba8 <freep>
 838:	a805                	j	868 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 83a:	4618                	lw	a4,8(a2)
 83c:	9db9                	addw	a1,a1,a4
 83e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 842:	6398                	ld	a4,0(a5)
 844:	6318                	ld	a4,0(a4)
 846:	fee53823          	sd	a4,-16(a0)
 84a:	a091                	j	88e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 84c:	ff852703          	lw	a4,-8(a0)
 850:	9e39                	addw	a2,a2,a4
 852:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 854:	ff053703          	ld	a4,-16(a0)
 858:	e398                	sd	a4,0(a5)
 85a:	a099                	j	8a0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85c:	6398                	ld	a4,0(a5)
 85e:	00e7e463          	bltu	a5,a4,866 <free+0x40>
 862:	00e6ea63          	bltu	a3,a4,876 <free+0x50>
{
 866:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 868:	fed7fae3          	bgeu	a5,a3,85c <free+0x36>
 86c:	6398                	ld	a4,0(a5)
 86e:	00e6e463          	bltu	a3,a4,876 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 872:	fee7eae3          	bltu	a5,a4,866 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 876:	ff852583          	lw	a1,-8(a0)
 87a:	6390                	ld	a2,0(a5)
 87c:	02059713          	slli	a4,a1,0x20
 880:	9301                	srli	a4,a4,0x20
 882:	0712                	slli	a4,a4,0x4
 884:	9736                	add	a4,a4,a3
 886:	fae60ae3          	beq	a2,a4,83a <free+0x14>
    bp->s.ptr = p->s.ptr;
 88a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 88e:	4790                	lw	a2,8(a5)
 890:	02061713          	slli	a4,a2,0x20
 894:	9301                	srli	a4,a4,0x20
 896:	0712                	slli	a4,a4,0x4
 898:	973e                	add	a4,a4,a5
 89a:	fae689e3          	beq	a3,a4,84c <free+0x26>
  } else
    p->s.ptr = bp;
 89e:	e394                	sd	a3,0(a5)
  freep = p;
 8a0:	00000717          	auipc	a4,0x0
 8a4:	30f73423          	sd	a5,776(a4) # ba8 <freep>
}
 8a8:	6422                	ld	s0,8(sp)
 8aa:	0141                	addi	sp,sp,16
 8ac:	8082                	ret

00000000000008ae <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ae:	7139                	addi	sp,sp,-64
 8b0:	fc06                	sd	ra,56(sp)
 8b2:	f822                	sd	s0,48(sp)
 8b4:	f426                	sd	s1,40(sp)
 8b6:	f04a                	sd	s2,32(sp)
 8b8:	ec4e                	sd	s3,24(sp)
 8ba:	e852                	sd	s4,16(sp)
 8bc:	e456                	sd	s5,8(sp)
 8be:	e05a                	sd	s6,0(sp)
 8c0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c2:	02051493          	slli	s1,a0,0x20
 8c6:	9081                	srli	s1,s1,0x20
 8c8:	04bd                	addi	s1,s1,15
 8ca:	8091                	srli	s1,s1,0x4
 8cc:	0014899b          	addiw	s3,s1,1
 8d0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8d2:	00000517          	auipc	a0,0x0
 8d6:	2d653503          	ld	a0,726(a0) # ba8 <freep>
 8da:	c515                	beqz	a0,906 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8de:	4798                	lw	a4,8(a5)
 8e0:	02977f63          	bgeu	a4,s1,91e <malloc+0x70>
 8e4:	8a4e                	mv	s4,s3
 8e6:	0009871b          	sext.w	a4,s3
 8ea:	6685                	lui	a3,0x1
 8ec:	00d77363          	bgeu	a4,a3,8f2 <malloc+0x44>
 8f0:	6a05                	lui	s4,0x1
 8f2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8fa:	00000917          	auipc	s2,0x0
 8fe:	2ae90913          	addi	s2,s2,686 # ba8 <freep>
  if(p == (char*)-1)
 902:	5afd                	li	s5,-1
 904:	a88d                	j	976 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 906:	00000797          	auipc	a5,0x0
 90a:	2aa78793          	addi	a5,a5,682 # bb0 <base>
 90e:	00000717          	auipc	a4,0x0
 912:	28f73d23          	sd	a5,666(a4) # ba8 <freep>
 916:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 918:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 91c:	b7e1                	j	8e4 <malloc+0x36>
      if(p->s.size == nunits)
 91e:	02e48b63          	beq	s1,a4,954 <malloc+0xa6>
        p->s.size -= nunits;
 922:	4137073b          	subw	a4,a4,s3
 926:	c798                	sw	a4,8(a5)
        p += p->s.size;
 928:	1702                	slli	a4,a4,0x20
 92a:	9301                	srli	a4,a4,0x20
 92c:	0712                	slli	a4,a4,0x4
 92e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 930:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 934:	00000717          	auipc	a4,0x0
 938:	26a73a23          	sd	a0,628(a4) # ba8 <freep>
      return (void*)(p + 1);
 93c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 940:	70e2                	ld	ra,56(sp)
 942:	7442                	ld	s0,48(sp)
 944:	74a2                	ld	s1,40(sp)
 946:	7902                	ld	s2,32(sp)
 948:	69e2                	ld	s3,24(sp)
 94a:	6a42                	ld	s4,16(sp)
 94c:	6aa2                	ld	s5,8(sp)
 94e:	6b02                	ld	s6,0(sp)
 950:	6121                	addi	sp,sp,64
 952:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 954:	6398                	ld	a4,0(a5)
 956:	e118                	sd	a4,0(a0)
 958:	bff1                	j	934 <malloc+0x86>
  hp->s.size = nu;
 95a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 95e:	0541                	addi	a0,a0,16
 960:	00000097          	auipc	ra,0x0
 964:	ec6080e7          	jalr	-314(ra) # 826 <free>
  return freep;
 968:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 96c:	d971                	beqz	a0,940 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 970:	4798                	lw	a4,8(a5)
 972:	fa9776e3          	bgeu	a4,s1,91e <malloc+0x70>
    if(p == freep)
 976:	00093703          	ld	a4,0(s2)
 97a:	853e                	mv	a0,a5
 97c:	fef719e3          	bne	a4,a5,96e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 980:	8552                	mv	a0,s4
 982:	00000097          	auipc	ra,0x0
 986:	b76080e7          	jalr	-1162(ra) # 4f8 <sbrk>
  if(p == (char*)-1)
 98a:	fd5518e3          	bne	a0,s5,95a <malloc+0xac>
        return 0;
 98e:	4501                	li	a0,0
 990:	bf45                	j	940 <malloc+0x92>
