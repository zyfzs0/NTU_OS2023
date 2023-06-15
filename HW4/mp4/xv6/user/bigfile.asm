
user/_bigfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <public1>:
static int failed = 0;


static void
public1()
{
   0:	bc010113          	addi	sp,sp,-1088
   4:	42113c23          	sd	ra,1080(sp)
   8:	42813823          	sd	s0,1072(sp)
   c:	42913423          	sd	s1,1064(sp)
  10:	43213023          	sd	s2,1056(sp)
  14:	41313c23          	sd	s3,1048(sp)
  18:	41413823          	sd	s4,1040(sp)
  1c:	41513423          	sd	s5,1032(sp)
  20:	44010413          	addi	s0,sp,1088
  char buf[BSIZE];
  int fd, blocks;
  int target = 270;

  fd = open("big.file", O_CREATE | O_WRONLY);
  24:	20100593          	li	a1,513
  28:	00001517          	auipc	a0,0x1
  2c:	a1050513          	addi	a0,a0,-1520 # a38 <malloc+0xe6>
  30:	00000097          	auipc	ra,0x0
  34:	524080e7          	jalr	1316(ra) # 554 <open>
  38:	892a                	mv	s2,a0
  if(fd < 0){
  3a:	00054c63          	bltz	a0,52 <public1+0x52>
  3e:	4481                	li	s1,0
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
  40:	06400a13          	li	s4,100
      printf(".");
  44:	00001a97          	auipc	s5,0x1
  48:	a3ca8a93          	addi	s5,s5,-1476 # a80 <malloc+0x12e>
    if(blocks == target)
  4c:	10e00993          	li	s3,270
  50:	a00d                	j	72 <public1+0x72>
    fail("bigfile: cannot open big.file for writing\n");
  52:	00001517          	auipc	a0,0x1
  56:	9f650513          	addi	a0,a0,-1546 # a48 <malloc+0xf6>
  5a:	00001097          	auipc	ra,0x1
  5e:	83a080e7          	jalr	-1990(ra) # 894 <printf>
  62:	4785                	li	a5,1
  64:	00001717          	auipc	a4,0x1
  68:	aaf72a23          	sw	a5,-1356(a4) # b18 <failed>
  6c:	a0bd                	j	da <public1+0xda>
    if(blocks == target)
  6e:	0b348463          	beq	s1,s3,116 <public1+0x116>
    *(int*)buf = blocks;
  72:	bc942023          	sw	s1,-1088(s0)
    int cc = write(fd, buf, sizeof(buf));
  76:	40000613          	li	a2,1024
  7a:	bc040593          	addi	a1,s0,-1088
  7e:	854a                	mv	a0,s2
  80:	00000097          	auipc	ra,0x0
  84:	4b4080e7          	jalr	1204(ra) # 534 <write>
    if(cc <= 0)
  88:	00a05f63          	blez	a0,a6 <public1+0xa6>
    blocks++;
  8c:	0014879b          	addiw	a5,s1,1
  90:	0007849b          	sext.w	s1,a5
    if (blocks % 100 == 0)
  94:	0347e7bb          	remw	a5,a5,s4
  98:	fbf9                	bnez	a5,6e <public1+0x6e>
      printf(".");
  9a:	8556                	mv	a0,s5
  9c:	00000097          	auipc	ra,0x0
  a0:	7f8080e7          	jalr	2040(ra) # 894 <printf>
  a4:	b7e9                	j	6e <public1+0x6e>
      break;
  }
  printf("\nwrote %d blocks\n", blocks);
  a6:	85a6                	mv	a1,s1
  a8:	00001517          	auipc	a0,0x1
  ac:	9e050513          	addi	a0,a0,-1568 # a88 <malloc+0x136>
  b0:	00000097          	auipc	ra,0x0
  b4:	7e4080e7          	jalr	2020(ra) # 894 <printf>
  if(blocks != target) {
  b8:	10e00793          	li	a5,270
  bc:	06f48763          	beq	s1,a5,12a <public1+0x12a>
    fail("bigfile: file is too small\n");
  c0:	00001517          	auipc	a0,0x1
  c4:	9e050513          	addi	a0,a0,-1568 # aa0 <malloc+0x14e>
  c8:	00000097          	auipc	ra,0x0
  cc:	7cc080e7          	jalr	1996(ra) # 894 <printf>
  d0:	4785                	li	a5,1
  d2:	00001717          	auipc	a4,0x1
  d6:	a4f72323          	sw	a5,-1466(a4) # b18 <failed>
  }

  printf("public testcase 1: ok\n");

done:
  close(fd);
  da:	854a                	mv	a0,s2
  dc:	00000097          	auipc	ra,0x0
  e0:	460080e7          	jalr	1120(ra) # 53c <close>
  unlink("big.file");
  e4:	00001517          	auipc	a0,0x1
  e8:	95450513          	addi	a0,a0,-1708 # a38 <malloc+0xe6>
  ec:	00000097          	auipc	ra,0x0
  f0:	478080e7          	jalr	1144(ra) # 564 <unlink>
}
  f4:	43813083          	ld	ra,1080(sp)
  f8:	43013403          	ld	s0,1072(sp)
  fc:	42813483          	ld	s1,1064(sp)
 100:	42013903          	ld	s2,1056(sp)
 104:	41813983          	ld	s3,1048(sp)
 108:	41013a03          	ld	s4,1040(sp)
 10c:	40813a83          	ld	s5,1032(sp)
 110:	44010113          	addi	sp,sp,1088
 114:	8082                	ret
  printf("\nwrote %d blocks\n", blocks);
 116:	10e00593          	li	a1,270
 11a:	00001517          	auipc	a0,0x1
 11e:	96e50513          	addi	a0,a0,-1682 # a88 <malloc+0x136>
 122:	00000097          	auipc	ra,0x0
 126:	772080e7          	jalr	1906(ra) # 894 <printf>
  printf("public testcase 1: ok\n");
 12a:	00001517          	auipc	a0,0x1
 12e:	99e50513          	addi	a0,a0,-1634 # ac8 <malloc+0x176>
 132:	00000097          	auipc	ra,0x0
 136:	762080e7          	jalr	1890(ra) # 894 <printf>
 13a:	b745                	j	da <public1+0xda>

000000000000013c <public2>:

static void 
public2()
{
 13c:	bc010113          	addi	sp,sp,-1088
 140:	42113c23          	sd	ra,1080(sp)
 144:	42813823          	sd	s0,1072(sp)
 148:	42913423          	sd	s1,1064(sp)
 14c:	43213023          	sd	s2,1056(sp)
 150:	41313c23          	sd	s3,1048(sp)
 154:	41413823          	sd	s4,1040(sp)
 158:	41513423          	sd	s5,1032(sp)
 15c:	44010413          	addi	s0,sp,1088
  char buf[BSIZE];
  int fd, blocks;
  int target = 6666;

  fd = open("big.file", O_CREATE | O_WRONLY);
 160:	20100593          	li	a1,513
 164:	00001517          	auipc	a0,0x1
 168:	8d450513          	addi	a0,a0,-1836 # a38 <malloc+0xe6>
 16c:	00000097          	auipc	ra,0x0
 170:	3e8080e7          	jalr	1000(ra) # 554 <open>
 174:	892a                	mv	s2,a0
  if(fd < 0){
 176:	00054d63          	bltz	a0,190 <public2+0x54>
 17a:	4481                	li	s1,0
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
 17c:	06400a13          	li	s4,100
      printf(".");
 180:	00001a97          	auipc	s5,0x1
 184:	900a8a93          	addi	s5,s5,-1792 # a80 <malloc+0x12e>
    if(blocks == target)
 188:	6989                	lui	s3,0x2
 18a:	a0a98993          	addi	s3,s3,-1526 # 1a0a <__global_pointer$+0x6f9>
 18e:	a00d                	j	1b0 <public2+0x74>
    fail("bigfile: cannot open big.file for writing\n");
 190:	00001517          	auipc	a0,0x1
 194:	8b850513          	addi	a0,a0,-1864 # a48 <malloc+0xf6>
 198:	00000097          	auipc	ra,0x0
 19c:	6fc080e7          	jalr	1788(ra) # 894 <printf>
 1a0:	4785                	li	a5,1
 1a2:	00001717          	auipc	a4,0x1
 1a6:	96f72b23          	sw	a5,-1674(a4) # b18 <failed>
 1aa:	a885                	j	21a <public2+0xde>
    if(blocks == target)
 1ac:	0b348563          	beq	s1,s3,256 <public2+0x11a>
    *(int*)buf = blocks;
 1b0:	bc942023          	sw	s1,-1088(s0)
    int cc = write(fd, buf, sizeof(buf));
 1b4:	40000613          	li	a2,1024
 1b8:	bc040593          	addi	a1,s0,-1088
 1bc:	854a                	mv	a0,s2
 1be:	00000097          	auipc	ra,0x0
 1c2:	376080e7          	jalr	886(ra) # 534 <write>
    if(cc <= 0)
 1c6:	00a05f63          	blez	a0,1e4 <public2+0xa8>
    blocks++;
 1ca:	0014879b          	addiw	a5,s1,1
 1ce:	0007849b          	sext.w	s1,a5
    if (blocks % 100 == 0)
 1d2:	0347e7bb          	remw	a5,a5,s4
 1d6:	fbf9                	bnez	a5,1ac <public2+0x70>
      printf(".");
 1d8:	8556                	mv	a0,s5
 1da:	00000097          	auipc	ra,0x0
 1de:	6ba080e7          	jalr	1722(ra) # 894 <printf>
 1e2:	b7e9                	j	1ac <public2+0x70>
      break;
  }
  printf("\nwrote %d blocks\n", blocks);
 1e4:	85a6                	mv	a1,s1
 1e6:	00001517          	auipc	a0,0x1
 1ea:	8a250513          	addi	a0,a0,-1886 # a88 <malloc+0x136>
 1ee:	00000097          	auipc	ra,0x0
 1f2:	6a6080e7          	jalr	1702(ra) # 894 <printf>
  if(blocks != target) {
 1f6:	6789                	lui	a5,0x2
 1f8:	a0a78793          	addi	a5,a5,-1526 # 1a0a <__global_pointer$+0x6f9>
 1fc:	06f48863          	beq	s1,a5,26c <public2+0x130>
    fail("bigfile: file is too small\n");
 200:	00001517          	auipc	a0,0x1
 204:	8a050513          	addi	a0,a0,-1888 # aa0 <malloc+0x14e>
 208:	00000097          	auipc	ra,0x0
 20c:	68c080e7          	jalr	1676(ra) # 894 <printf>
 210:	4785                	li	a5,1
 212:	00001717          	auipc	a4,0x1
 216:	90f72323          	sw	a5,-1786(a4) # b18 <failed>
  }
  printf("public testcase 2: ok\n");

done:
  close(fd);
 21a:	854a                	mv	a0,s2
 21c:	00000097          	auipc	ra,0x0
 220:	320080e7          	jalr	800(ra) # 53c <close>
  unlink("big.file");
 224:	00001517          	auipc	a0,0x1
 228:	81450513          	addi	a0,a0,-2028 # a38 <malloc+0xe6>
 22c:	00000097          	auipc	ra,0x0
 230:	338080e7          	jalr	824(ra) # 564 <unlink>
}
 234:	43813083          	ld	ra,1080(sp)
 238:	43013403          	ld	s0,1072(sp)
 23c:	42813483          	ld	s1,1064(sp)
 240:	42013903          	ld	s2,1056(sp)
 244:	41813983          	ld	s3,1048(sp)
 248:	41013a03          	ld	s4,1040(sp)
 24c:	40813a83          	ld	s5,1032(sp)
 250:	44010113          	addi	sp,sp,1088
 254:	8082                	ret
  printf("\nwrote %d blocks\n", blocks);
 256:	6589                	lui	a1,0x2
 258:	a0a58593          	addi	a1,a1,-1526 # 1a0a <__global_pointer$+0x6f9>
 25c:	00001517          	auipc	a0,0x1
 260:	82c50513          	addi	a0,a0,-2004 # a88 <malloc+0x136>
 264:	00000097          	auipc	ra,0x0
 268:	630080e7          	jalr	1584(ra) # 894 <printf>
  printf("public testcase 2: ok\n");
 26c:	00001517          	auipc	a0,0x1
 270:	87450513          	addi	a0,a0,-1932 # ae0 <malloc+0x18e>
 274:	00000097          	auipc	ra,0x0
 278:	620080e7          	jalr	1568(ra) # 894 <printf>
 27c:	bf79                	j	21a <public2+0xde>

000000000000027e <main>:


int
main()
{
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
  public1();
 286:	00000097          	auipc	ra,0x0
 28a:	d7a080e7          	jalr	-646(ra) # 0 <public1>
  public2();
 28e:	00000097          	auipc	ra,0x0
 292:	eae080e7          	jalr	-338(ra) # 13c <public2>
  exit(failed);
 296:	00001517          	auipc	a0,0x1
 29a:	88252503          	lw	a0,-1918(a0) # b18 <failed>
 29e:	00000097          	auipc	ra,0x0
 2a2:	276080e7          	jalr	630(ra) # 514 <exit>

00000000000002a6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ac:	87aa                	mv	a5,a0
 2ae:	0585                	addi	a1,a1,1
 2b0:	0785                	addi	a5,a5,1
 2b2:	fff5c703          	lbu	a4,-1(a1)
 2b6:	fee78fa3          	sb	a4,-1(a5)
 2ba:	fb75                	bnez	a4,2ae <strcpy+0x8>
    ;
  return os;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	cb91                	beqz	a5,2e0 <strcmp+0x1e>
 2ce:	0005c703          	lbu	a4,0(a1)
 2d2:	00f71763          	bne	a4,a5,2e0 <strcmp+0x1e>
    p++, q++;
 2d6:	0505                	addi	a0,a0,1
 2d8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2da:	00054783          	lbu	a5,0(a0)
 2de:	fbe5                	bnez	a5,2ce <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2e0:	0005c503          	lbu	a0,0(a1)
}
 2e4:	40a7853b          	subw	a0,a5,a0
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret

00000000000002ee <strlen>:

uint
strlen(const char *s)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	cf91                	beqz	a5,314 <strlen+0x26>
 2fa:	0505                	addi	a0,a0,1
 2fc:	87aa                	mv	a5,a0
 2fe:	4685                	li	a3,1
 300:	9e89                	subw	a3,a3,a0
 302:	00f6853b          	addw	a0,a3,a5
 306:	0785                	addi	a5,a5,1
 308:	fff7c703          	lbu	a4,-1(a5)
 30c:	fb7d                	bnez	a4,302 <strlen+0x14>
    ;
  return n;
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  for(n = 0; s[n]; n++)
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <strlen+0x20>

0000000000000318 <memset>:

void*
memset(void *dst, int c, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 31e:	ca19                	beqz	a2,334 <memset+0x1c>
 320:	87aa                	mv	a5,a0
 322:	1602                	slli	a2,a2,0x20
 324:	9201                	srli	a2,a2,0x20
 326:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 32a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 32e:	0785                	addi	a5,a5,1
 330:	fee79de3          	bne	a5,a4,32a <memset+0x12>
  }
  return dst;
}
 334:	6422                	ld	s0,8(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <strchr>:

char*
strchr(const char *s, char c)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 340:	00054783          	lbu	a5,0(a0)
 344:	cb99                	beqz	a5,35a <strchr+0x20>
    if(*s == c)
 346:	00f58763          	beq	a1,a5,354 <strchr+0x1a>
  for(; *s; s++)
 34a:	0505                	addi	a0,a0,1
 34c:	00054783          	lbu	a5,0(a0)
 350:	fbfd                	bnez	a5,346 <strchr+0xc>
      return (char*)s;
  return 0;
 352:	4501                	li	a0,0
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret
  return 0;
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <strchr+0x1a>

000000000000035e <gets>:

char*
gets(char *buf, int max)
{
 35e:	711d                	addi	sp,sp,-96
 360:	ec86                	sd	ra,88(sp)
 362:	e8a2                	sd	s0,80(sp)
 364:	e4a6                	sd	s1,72(sp)
 366:	e0ca                	sd	s2,64(sp)
 368:	fc4e                	sd	s3,56(sp)
 36a:	f852                	sd	s4,48(sp)
 36c:	f456                	sd	s5,40(sp)
 36e:	f05a                	sd	s6,32(sp)
 370:	ec5e                	sd	s7,24(sp)
 372:	1080                	addi	s0,sp,96
 374:	8baa                	mv	s7,a0
 376:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 378:	892a                	mv	s2,a0
 37a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 37c:	4aa9                	li	s5,10
 37e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 380:	89a6                	mv	s3,s1
 382:	2485                	addiw	s1,s1,1
 384:	0344d863          	bge	s1,s4,3b4 <gets+0x56>
    cc = read(0, &c, 1);
 388:	4605                	li	a2,1
 38a:	faf40593          	addi	a1,s0,-81
 38e:	4501                	li	a0,0
 390:	00000097          	auipc	ra,0x0
 394:	19c080e7          	jalr	412(ra) # 52c <read>
    if(cc < 1)
 398:	00a05e63          	blez	a0,3b4 <gets+0x56>
    buf[i++] = c;
 39c:	faf44783          	lbu	a5,-81(s0)
 3a0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3a4:	01578763          	beq	a5,s5,3b2 <gets+0x54>
 3a8:	0905                	addi	s2,s2,1
 3aa:	fd679be3          	bne	a5,s6,380 <gets+0x22>
  for(i=0; i+1 < max; ){
 3ae:	89a6                	mv	s3,s1
 3b0:	a011                	j	3b4 <gets+0x56>
 3b2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3b4:	99de                	add	s3,s3,s7
 3b6:	00098023          	sb	zero,0(s3)
  return buf;
}
 3ba:	855e                	mv	a0,s7
 3bc:	60e6                	ld	ra,88(sp)
 3be:	6446                	ld	s0,80(sp)
 3c0:	64a6                	ld	s1,72(sp)
 3c2:	6906                	ld	s2,64(sp)
 3c4:	79e2                	ld	s3,56(sp)
 3c6:	7a42                	ld	s4,48(sp)
 3c8:	7aa2                	ld	s5,40(sp)
 3ca:	7b02                	ld	s6,32(sp)
 3cc:	6be2                	ld	s7,24(sp)
 3ce:	6125                	addi	sp,sp,96
 3d0:	8082                	ret

00000000000003d2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	e426                	sd	s1,8(sp)
 3da:	e04a                	sd	s2,0(sp)
 3dc:	1000                	addi	s0,sp,32
 3de:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e0:	4581                	li	a1,0
 3e2:	00000097          	auipc	ra,0x0
 3e6:	172080e7          	jalr	370(ra) # 554 <open>
  if(fd < 0)
 3ea:	02054563          	bltz	a0,414 <stat+0x42>
 3ee:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3f0:	85ca                	mv	a1,s2
 3f2:	00000097          	auipc	ra,0x0
 3f6:	17a080e7          	jalr	378(ra) # 56c <fstat>
 3fa:	892a                	mv	s2,a0
  close(fd);
 3fc:	8526                	mv	a0,s1
 3fe:	00000097          	auipc	ra,0x0
 402:	13e080e7          	jalr	318(ra) # 53c <close>
  return r;
}
 406:	854a                	mv	a0,s2
 408:	60e2                	ld	ra,24(sp)
 40a:	6442                	ld	s0,16(sp)
 40c:	64a2                	ld	s1,8(sp)
 40e:	6902                	ld	s2,0(sp)
 410:	6105                	addi	sp,sp,32
 412:	8082                	ret
    return -1;
 414:	597d                	li	s2,-1
 416:	bfc5                	j	406 <stat+0x34>

0000000000000418 <atoi>:

int
atoi(const char *s)
{
 418:	1141                	addi	sp,sp,-16
 41a:	e422                	sd	s0,8(sp)
 41c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 41e:	00054603          	lbu	a2,0(a0)
 422:	fd06079b          	addiw	a5,a2,-48
 426:	0ff7f793          	andi	a5,a5,255
 42a:	4725                	li	a4,9
 42c:	02f76963          	bltu	a4,a5,45e <atoi+0x46>
 430:	86aa                	mv	a3,a0
  n = 0;
 432:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 434:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 436:	0685                	addi	a3,a3,1
 438:	0025179b          	slliw	a5,a0,0x2
 43c:	9fa9                	addw	a5,a5,a0
 43e:	0017979b          	slliw	a5,a5,0x1
 442:	9fb1                	addw	a5,a5,a2
 444:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 448:	0006c603          	lbu	a2,0(a3)
 44c:	fd06071b          	addiw	a4,a2,-48
 450:	0ff77713          	andi	a4,a4,255
 454:	fee5f1e3          	bgeu	a1,a4,436 <atoi+0x1e>
  return n;
}
 458:	6422                	ld	s0,8(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret
  n = 0;
 45e:	4501                	li	a0,0
 460:	bfe5                	j	458 <atoi+0x40>

0000000000000462 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 462:	1141                	addi	sp,sp,-16
 464:	e422                	sd	s0,8(sp)
 466:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 468:	02b57463          	bgeu	a0,a1,490 <memmove+0x2e>
    while(n-- > 0)
 46c:	00c05f63          	blez	a2,48a <memmove+0x28>
 470:	1602                	slli	a2,a2,0x20
 472:	9201                	srli	a2,a2,0x20
 474:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 478:	872a                	mv	a4,a0
      *dst++ = *src++;
 47a:	0585                	addi	a1,a1,1
 47c:	0705                	addi	a4,a4,1
 47e:	fff5c683          	lbu	a3,-1(a1)
 482:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 486:	fee79ae3          	bne	a5,a4,47a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
    dst += n;
 490:	00c50733          	add	a4,a0,a2
    src += n;
 494:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 496:	fec05ae3          	blez	a2,48a <memmove+0x28>
 49a:	fff6079b          	addiw	a5,a2,-1
 49e:	1782                	slli	a5,a5,0x20
 4a0:	9381                	srli	a5,a5,0x20
 4a2:	fff7c793          	not	a5,a5
 4a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4a8:	15fd                	addi	a1,a1,-1
 4aa:	177d                	addi	a4,a4,-1
 4ac:	0005c683          	lbu	a3,0(a1)
 4b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4b4:	fee79ae3          	bne	a5,a4,4a8 <memmove+0x46>
 4b8:	bfc9                	j	48a <memmove+0x28>

00000000000004ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e422                	sd	s0,8(sp)
 4be:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4c0:	ca05                	beqz	a2,4f0 <memcmp+0x36>
 4c2:	fff6069b          	addiw	a3,a2,-1
 4c6:	1682                	slli	a3,a3,0x20
 4c8:	9281                	srli	a3,a3,0x20
 4ca:	0685                	addi	a3,a3,1
 4cc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ce:	00054783          	lbu	a5,0(a0)
 4d2:	0005c703          	lbu	a4,0(a1)
 4d6:	00e79863          	bne	a5,a4,4e6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4da:	0505                	addi	a0,a0,1
    p2++;
 4dc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4de:	fed518e3          	bne	a0,a3,4ce <memcmp+0x14>
  }
  return 0;
 4e2:	4501                	li	a0,0
 4e4:	a019                	j	4ea <memcmp+0x30>
      return *p1 - *p2;
 4e6:	40e7853b          	subw	a0,a5,a4
}
 4ea:	6422                	ld	s0,8(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret
  return 0;
 4f0:	4501                	li	a0,0
 4f2:	bfe5                	j	4ea <memcmp+0x30>

00000000000004f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4f4:	1141                	addi	sp,sp,-16
 4f6:	e406                	sd	ra,8(sp)
 4f8:	e022                	sd	s0,0(sp)
 4fa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4fc:	00000097          	auipc	ra,0x0
 500:	f66080e7          	jalr	-154(ra) # 462 <memmove>
}
 504:	60a2                	ld	ra,8(sp)
 506:	6402                	ld	s0,0(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret

000000000000050c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 50c:	4885                	li	a7,1
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <exit>:
.global exit
exit:
 li a7, SYS_exit
 514:	4889                	li	a7,2
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <wait>:
.global wait
wait:
 li a7, SYS_wait
 51c:	488d                	li	a7,3
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 524:	4891                	li	a7,4
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <read>:
.global read
read:
 li a7, SYS_read
 52c:	4895                	li	a7,5
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <write>:
.global write
write:
 li a7, SYS_write
 534:	48c1                	li	a7,16
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <close>:
.global close
close:
 li a7, SYS_close
 53c:	48d5                	li	a7,21
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <kill>:
.global kill
kill:
 li a7, SYS_kill
 544:	4899                	li	a7,6
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <exec>:
.global exec
exec:
 li a7, SYS_exec
 54c:	489d                	li	a7,7
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <open>:
.global open
open:
 li a7, SYS_open
 554:	48bd                	li	a7,15
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 55c:	48c5                	li	a7,17
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 564:	48c9                	li	a7,18
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 56c:	48a1                	li	a7,8
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <link>:
.global link
link:
 li a7, SYS_link
 574:	48cd                	li	a7,19
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 57c:	48d1                	li	a7,20
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 584:	48a5                	li	a7,9
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <dup>:
.global dup
dup:
 li a7, SYS_dup
 58c:	48a9                	li	a7,10
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 594:	48ad                	li	a7,11
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 59c:	48b1                	li	a7,12
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5a4:	48b5                	li	a7,13
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ac:	48b9                	li	a7,14
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 5b4:	48d9                	li	a7,22
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5bc:	1101                	addi	sp,sp,-32
 5be:	ec06                	sd	ra,24(sp)
 5c0:	e822                	sd	s0,16(sp)
 5c2:	1000                	addi	s0,sp,32
 5c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c8:	4605                	li	a2,1
 5ca:	fef40593          	addi	a1,s0,-17
 5ce:	00000097          	auipc	ra,0x0
 5d2:	f66080e7          	jalr	-154(ra) # 534 <write>
}
 5d6:	60e2                	ld	ra,24(sp)
 5d8:	6442                	ld	s0,16(sp)
 5da:	6105                	addi	sp,sp,32
 5dc:	8082                	ret

00000000000005de <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5de:	7139                	addi	sp,sp,-64
 5e0:	fc06                	sd	ra,56(sp)
 5e2:	f822                	sd	s0,48(sp)
 5e4:	f426                	sd	s1,40(sp)
 5e6:	f04a                	sd	s2,32(sp)
 5e8:	ec4e                	sd	s3,24(sp)
 5ea:	0080                	addi	s0,sp,64
 5ec:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ee:	c299                	beqz	a3,5f4 <printint+0x16>
 5f0:	0805c863          	bltz	a1,680 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5f4:	2581                	sext.w	a1,a1
  neg = 0;
 5f6:	4881                	li	a7,0
 5f8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5fc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5fe:	2601                	sext.w	a2,a2
 600:	00000517          	auipc	a0,0x0
 604:	50050513          	addi	a0,a0,1280 # b00 <digits>
 608:	883a                	mv	a6,a4
 60a:	2705                	addiw	a4,a4,1
 60c:	02c5f7bb          	remuw	a5,a1,a2
 610:	1782                	slli	a5,a5,0x20
 612:	9381                	srli	a5,a5,0x20
 614:	97aa                	add	a5,a5,a0
 616:	0007c783          	lbu	a5,0(a5)
 61a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 61e:	0005879b          	sext.w	a5,a1
 622:	02c5d5bb          	divuw	a1,a1,a2
 626:	0685                	addi	a3,a3,1
 628:	fec7f0e3          	bgeu	a5,a2,608 <printint+0x2a>
  if(neg)
 62c:	00088b63          	beqz	a7,642 <printint+0x64>
    buf[i++] = '-';
 630:	fd040793          	addi	a5,s0,-48
 634:	973e                	add	a4,a4,a5
 636:	02d00793          	li	a5,45
 63a:	fef70823          	sb	a5,-16(a4)
 63e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 642:	02e05863          	blez	a4,672 <printint+0x94>
 646:	fc040793          	addi	a5,s0,-64
 64a:	00e78933          	add	s2,a5,a4
 64e:	fff78993          	addi	s3,a5,-1
 652:	99ba                	add	s3,s3,a4
 654:	377d                	addiw	a4,a4,-1
 656:	1702                	slli	a4,a4,0x20
 658:	9301                	srli	a4,a4,0x20
 65a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 65e:	fff94583          	lbu	a1,-1(s2)
 662:	8526                	mv	a0,s1
 664:	00000097          	auipc	ra,0x0
 668:	f58080e7          	jalr	-168(ra) # 5bc <putc>
  while(--i >= 0)
 66c:	197d                	addi	s2,s2,-1
 66e:	ff3918e3          	bne	s2,s3,65e <printint+0x80>
}
 672:	70e2                	ld	ra,56(sp)
 674:	7442                	ld	s0,48(sp)
 676:	74a2                	ld	s1,40(sp)
 678:	7902                	ld	s2,32(sp)
 67a:	69e2                	ld	s3,24(sp)
 67c:	6121                	addi	sp,sp,64
 67e:	8082                	ret
    x = -xx;
 680:	40b005bb          	negw	a1,a1
    neg = 1;
 684:	4885                	li	a7,1
    x = -xx;
 686:	bf8d                	j	5f8 <printint+0x1a>

0000000000000688 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 688:	7119                	addi	sp,sp,-128
 68a:	fc86                	sd	ra,120(sp)
 68c:	f8a2                	sd	s0,112(sp)
 68e:	f4a6                	sd	s1,104(sp)
 690:	f0ca                	sd	s2,96(sp)
 692:	ecce                	sd	s3,88(sp)
 694:	e8d2                	sd	s4,80(sp)
 696:	e4d6                	sd	s5,72(sp)
 698:	e0da                	sd	s6,64(sp)
 69a:	fc5e                	sd	s7,56(sp)
 69c:	f862                	sd	s8,48(sp)
 69e:	f466                	sd	s9,40(sp)
 6a0:	f06a                	sd	s10,32(sp)
 6a2:	ec6e                	sd	s11,24(sp)
 6a4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6a6:	0005c903          	lbu	s2,0(a1)
 6aa:	18090f63          	beqz	s2,848 <vprintf+0x1c0>
 6ae:	8aaa                	mv	s5,a0
 6b0:	8b32                	mv	s6,a2
 6b2:	00158493          	addi	s1,a1,1
  state = 0;
 6b6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6b8:	02500a13          	li	s4,37
      if(c == 'd'){
 6bc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6c0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6c4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6c8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6cc:	00000b97          	auipc	s7,0x0
 6d0:	434b8b93          	addi	s7,s7,1076 # b00 <digits>
 6d4:	a839                	j	6f2 <vprintf+0x6a>
        putc(fd, c);
 6d6:	85ca                	mv	a1,s2
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	ee2080e7          	jalr	-286(ra) # 5bc <putc>
 6e2:	a019                	j	6e8 <vprintf+0x60>
    } else if(state == '%'){
 6e4:	01498f63          	beq	s3,s4,702 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6e8:	0485                	addi	s1,s1,1
 6ea:	fff4c903          	lbu	s2,-1(s1)
 6ee:	14090d63          	beqz	s2,848 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6f2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6f6:	fe0997e3          	bnez	s3,6e4 <vprintf+0x5c>
      if(c == '%'){
 6fa:	fd479ee3          	bne	a5,s4,6d6 <vprintf+0x4e>
        state = '%';
 6fe:	89be                	mv	s3,a5
 700:	b7e5                	j	6e8 <vprintf+0x60>
      if(c == 'd'){
 702:	05878063          	beq	a5,s8,742 <vprintf+0xba>
      } else if(c == 'l') {
 706:	05978c63          	beq	a5,s9,75e <vprintf+0xd6>
      } else if(c == 'x') {
 70a:	07a78863          	beq	a5,s10,77a <vprintf+0xf2>
      } else if(c == 'p') {
 70e:	09b78463          	beq	a5,s11,796 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 712:	07300713          	li	a4,115
 716:	0ce78663          	beq	a5,a4,7e2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 71a:	06300713          	li	a4,99
 71e:	0ee78e63          	beq	a5,a4,81a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 722:	11478863          	beq	a5,s4,832 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 726:	85d2                	mv	a1,s4
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	e92080e7          	jalr	-366(ra) # 5bc <putc>
        putc(fd, c);
 732:	85ca                	mv	a1,s2
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	e86080e7          	jalr	-378(ra) # 5bc <putc>
      }
      state = 0;
 73e:	4981                	li	s3,0
 740:	b765                	j	6e8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 742:	008b0913          	addi	s2,s6,8
 746:	4685                	li	a3,1
 748:	4629                	li	a2,10
 74a:	000b2583          	lw	a1,0(s6)
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	e8e080e7          	jalr	-370(ra) # 5de <printint>
 758:	8b4a                	mv	s6,s2
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b771                	j	6e8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 75e:	008b0913          	addi	s2,s6,8
 762:	4681                	li	a3,0
 764:	4629                	li	a2,10
 766:	000b2583          	lw	a1,0(s6)
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	e72080e7          	jalr	-398(ra) # 5de <printint>
 774:	8b4a                	mv	s6,s2
      state = 0;
 776:	4981                	li	s3,0
 778:	bf85                	j	6e8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 77a:	008b0913          	addi	s2,s6,8
 77e:	4681                	li	a3,0
 780:	4641                	li	a2,16
 782:	000b2583          	lw	a1,0(s6)
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	e56080e7          	jalr	-426(ra) # 5de <printint>
 790:	8b4a                	mv	s6,s2
      state = 0;
 792:	4981                	li	s3,0
 794:	bf91                	j	6e8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 796:	008b0793          	addi	a5,s6,8
 79a:	f8f43423          	sd	a5,-120(s0)
 79e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7a2:	03000593          	li	a1,48
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e14080e7          	jalr	-492(ra) # 5bc <putc>
  putc(fd, 'x');
 7b0:	85ea                	mv	a1,s10
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e08080e7          	jalr	-504(ra) # 5bc <putc>
 7bc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7be:	03c9d793          	srli	a5,s3,0x3c
 7c2:	97de                	add	a5,a5,s7
 7c4:	0007c583          	lbu	a1,0(a5)
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	df2080e7          	jalr	-526(ra) # 5bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d2:	0992                	slli	s3,s3,0x4
 7d4:	397d                	addiw	s2,s2,-1
 7d6:	fe0914e3          	bnez	s2,7be <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7da:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b721                	j	6e8 <vprintf+0x60>
        s = va_arg(ap, char*);
 7e2:	008b0993          	addi	s3,s6,8
 7e6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7ea:	02090163          	beqz	s2,80c <vprintf+0x184>
        while(*s != 0){
 7ee:	00094583          	lbu	a1,0(s2)
 7f2:	c9a1                	beqz	a1,842 <vprintf+0x1ba>
          putc(fd, *s);
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	dc6080e7          	jalr	-570(ra) # 5bc <putc>
          s++;
 7fe:	0905                	addi	s2,s2,1
        while(*s != 0){
 800:	00094583          	lbu	a1,0(s2)
 804:	f9e5                	bnez	a1,7f4 <vprintf+0x16c>
        s = va_arg(ap, char*);
 806:	8b4e                	mv	s6,s3
      state = 0;
 808:	4981                	li	s3,0
 80a:	bdf9                	j	6e8 <vprintf+0x60>
          s = "(null)";
 80c:	00000917          	auipc	s2,0x0
 810:	2ec90913          	addi	s2,s2,748 # af8 <malloc+0x1a6>
        while(*s != 0){
 814:	02800593          	li	a1,40
 818:	bff1                	j	7f4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 81a:	008b0913          	addi	s2,s6,8
 81e:	000b4583          	lbu	a1,0(s6)
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	d98080e7          	jalr	-616(ra) # 5bc <putc>
 82c:	8b4a                	mv	s6,s2
      state = 0;
 82e:	4981                	li	s3,0
 830:	bd65                	j	6e8 <vprintf+0x60>
        putc(fd, c);
 832:	85d2                	mv	a1,s4
 834:	8556                	mv	a0,s5
 836:	00000097          	auipc	ra,0x0
 83a:	d86080e7          	jalr	-634(ra) # 5bc <putc>
      state = 0;
 83e:	4981                	li	s3,0
 840:	b565                	j	6e8 <vprintf+0x60>
        s = va_arg(ap, char*);
 842:	8b4e                	mv	s6,s3
      state = 0;
 844:	4981                	li	s3,0
 846:	b54d                	j	6e8 <vprintf+0x60>
    }
  }
}
 848:	70e6                	ld	ra,120(sp)
 84a:	7446                	ld	s0,112(sp)
 84c:	74a6                	ld	s1,104(sp)
 84e:	7906                	ld	s2,96(sp)
 850:	69e6                	ld	s3,88(sp)
 852:	6a46                	ld	s4,80(sp)
 854:	6aa6                	ld	s5,72(sp)
 856:	6b06                	ld	s6,64(sp)
 858:	7be2                	ld	s7,56(sp)
 85a:	7c42                	ld	s8,48(sp)
 85c:	7ca2                	ld	s9,40(sp)
 85e:	7d02                	ld	s10,32(sp)
 860:	6de2                	ld	s11,24(sp)
 862:	6109                	addi	sp,sp,128
 864:	8082                	ret

0000000000000866 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 866:	715d                	addi	sp,sp,-80
 868:	ec06                	sd	ra,24(sp)
 86a:	e822                	sd	s0,16(sp)
 86c:	1000                	addi	s0,sp,32
 86e:	e010                	sd	a2,0(s0)
 870:	e414                	sd	a3,8(s0)
 872:	e818                	sd	a4,16(s0)
 874:	ec1c                	sd	a5,24(s0)
 876:	03043023          	sd	a6,32(s0)
 87a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 87e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 882:	8622                	mv	a2,s0
 884:	00000097          	auipc	ra,0x0
 888:	e04080e7          	jalr	-508(ra) # 688 <vprintf>
}
 88c:	60e2                	ld	ra,24(sp)
 88e:	6442                	ld	s0,16(sp)
 890:	6161                	addi	sp,sp,80
 892:	8082                	ret

0000000000000894 <printf>:

void
printf(const char *fmt, ...)
{
 894:	711d                	addi	sp,sp,-96
 896:	ec06                	sd	ra,24(sp)
 898:	e822                	sd	s0,16(sp)
 89a:	1000                	addi	s0,sp,32
 89c:	e40c                	sd	a1,8(s0)
 89e:	e810                	sd	a2,16(s0)
 8a0:	ec14                	sd	a3,24(s0)
 8a2:	f018                	sd	a4,32(s0)
 8a4:	f41c                	sd	a5,40(s0)
 8a6:	03043823          	sd	a6,48(s0)
 8aa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ae:	00840613          	addi	a2,s0,8
 8b2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8b6:	85aa                	mv	a1,a0
 8b8:	4505                	li	a0,1
 8ba:	00000097          	auipc	ra,0x0
 8be:	dce080e7          	jalr	-562(ra) # 688 <vprintf>
}
 8c2:	60e2                	ld	ra,24(sp)
 8c4:	6442                	ld	s0,16(sp)
 8c6:	6125                	addi	sp,sp,96
 8c8:	8082                	ret

00000000000008ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ca:	1141                	addi	sp,sp,-16
 8cc:	e422                	sd	s0,8(sp)
 8ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d4:	00000797          	auipc	a5,0x0
 8d8:	24c7b783          	ld	a5,588(a5) # b20 <freep>
 8dc:	a805                	j	90c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8de:	4618                	lw	a4,8(a2)
 8e0:	9db9                	addw	a1,a1,a4
 8e2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e6:	6398                	ld	a4,0(a5)
 8e8:	6318                	ld	a4,0(a4)
 8ea:	fee53823          	sd	a4,-16(a0)
 8ee:	a091                	j	932 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8f0:	ff852703          	lw	a4,-8(a0)
 8f4:	9e39                	addw	a2,a2,a4
 8f6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8f8:	ff053703          	ld	a4,-16(a0)
 8fc:	e398                	sd	a4,0(a5)
 8fe:	a099                	j	944 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 900:	6398                	ld	a4,0(a5)
 902:	00e7e463          	bltu	a5,a4,90a <free+0x40>
 906:	00e6ea63          	bltu	a3,a4,91a <free+0x50>
{
 90a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90c:	fed7fae3          	bgeu	a5,a3,900 <free+0x36>
 910:	6398                	ld	a4,0(a5)
 912:	00e6e463          	bltu	a3,a4,91a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 916:	fee7eae3          	bltu	a5,a4,90a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 91a:	ff852583          	lw	a1,-8(a0)
 91e:	6390                	ld	a2,0(a5)
 920:	02059713          	slli	a4,a1,0x20
 924:	9301                	srli	a4,a4,0x20
 926:	0712                	slli	a4,a4,0x4
 928:	9736                	add	a4,a4,a3
 92a:	fae60ae3          	beq	a2,a4,8de <free+0x14>
    bp->s.ptr = p->s.ptr;
 92e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 932:	4790                	lw	a2,8(a5)
 934:	02061713          	slli	a4,a2,0x20
 938:	9301                	srli	a4,a4,0x20
 93a:	0712                	slli	a4,a4,0x4
 93c:	973e                	add	a4,a4,a5
 93e:	fae689e3          	beq	a3,a4,8f0 <free+0x26>
  } else
    p->s.ptr = bp;
 942:	e394                	sd	a3,0(a5)
  freep = p;
 944:	00000717          	auipc	a4,0x0
 948:	1cf73e23          	sd	a5,476(a4) # b20 <freep>
}
 94c:	6422                	ld	s0,8(sp)
 94e:	0141                	addi	sp,sp,16
 950:	8082                	ret

0000000000000952 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 952:	7139                	addi	sp,sp,-64
 954:	fc06                	sd	ra,56(sp)
 956:	f822                	sd	s0,48(sp)
 958:	f426                	sd	s1,40(sp)
 95a:	f04a                	sd	s2,32(sp)
 95c:	ec4e                	sd	s3,24(sp)
 95e:	e852                	sd	s4,16(sp)
 960:	e456                	sd	s5,8(sp)
 962:	e05a                	sd	s6,0(sp)
 964:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 966:	02051493          	slli	s1,a0,0x20
 96a:	9081                	srli	s1,s1,0x20
 96c:	04bd                	addi	s1,s1,15
 96e:	8091                	srli	s1,s1,0x4
 970:	0014899b          	addiw	s3,s1,1
 974:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 976:	00000517          	auipc	a0,0x0
 97a:	1aa53503          	ld	a0,426(a0) # b20 <freep>
 97e:	c515                	beqz	a0,9aa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 980:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 982:	4798                	lw	a4,8(a5)
 984:	02977f63          	bgeu	a4,s1,9c2 <malloc+0x70>
 988:	8a4e                	mv	s4,s3
 98a:	0009871b          	sext.w	a4,s3
 98e:	6685                	lui	a3,0x1
 990:	00d77363          	bgeu	a4,a3,996 <malloc+0x44>
 994:	6a05                	lui	s4,0x1
 996:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 99a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 99e:	00000917          	auipc	s2,0x0
 9a2:	18290913          	addi	s2,s2,386 # b20 <freep>
  if(p == (char*)-1)
 9a6:	5afd                	li	s5,-1
 9a8:	a88d                	j	a1a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9aa:	00000797          	auipc	a5,0x0
 9ae:	17e78793          	addi	a5,a5,382 # b28 <base>
 9b2:	00000717          	auipc	a4,0x0
 9b6:	16f73723          	sd	a5,366(a4) # b20 <freep>
 9ba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9bc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9c0:	b7e1                	j	988 <malloc+0x36>
      if(p->s.size == nunits)
 9c2:	02e48b63          	beq	s1,a4,9f8 <malloc+0xa6>
        p->s.size -= nunits;
 9c6:	4137073b          	subw	a4,a4,s3
 9ca:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9cc:	1702                	slli	a4,a4,0x20
 9ce:	9301                	srli	a4,a4,0x20
 9d0:	0712                	slli	a4,a4,0x4
 9d2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9d4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d8:	00000717          	auipc	a4,0x0
 9dc:	14a73423          	sd	a0,328(a4) # b20 <freep>
      return (void*)(p + 1);
 9e0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9e4:	70e2                	ld	ra,56(sp)
 9e6:	7442                	ld	s0,48(sp)
 9e8:	74a2                	ld	s1,40(sp)
 9ea:	7902                	ld	s2,32(sp)
 9ec:	69e2                	ld	s3,24(sp)
 9ee:	6a42                	ld	s4,16(sp)
 9f0:	6aa2                	ld	s5,8(sp)
 9f2:	6b02                	ld	s6,0(sp)
 9f4:	6121                	addi	sp,sp,64
 9f6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9f8:	6398                	ld	a4,0(a5)
 9fa:	e118                	sd	a4,0(a0)
 9fc:	bff1                	j	9d8 <malloc+0x86>
  hp->s.size = nu;
 9fe:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a02:	0541                	addi	a0,a0,16
 a04:	00000097          	auipc	ra,0x0
 a08:	ec6080e7          	jalr	-314(ra) # 8ca <free>
  return freep;
 a0c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a10:	d971                	beqz	a0,9e4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a12:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a14:	4798                	lw	a4,8(a5)
 a16:	fa9776e3          	bgeu	a4,s1,9c2 <malloc+0x70>
    if(p == freep)
 a1a:	00093703          	ld	a4,0(s2)
 a1e:	853e                	mv	a0,a5
 a20:	fef719e3          	bne	a4,a5,a12 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a24:	8552                	mv	a0,s4
 a26:	00000097          	auipc	ra,0x0
 a2a:	b76080e7          	jalr	-1162(ra) # 59c <sbrk>
  if(p == (char*)-1)
 a2e:	fd5518e3          	bne	a0,s5,9fe <malloc+0xac>
        return 0;
 a32:	4501                	li	a0,0
 a34:	bf45                	j	9e4 <malloc+0x92>
