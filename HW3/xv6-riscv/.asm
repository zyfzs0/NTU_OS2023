
user/_thrdtest4:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thrdstop_handler_resume_main_id>:

int main_id = -1;
int second_id = -1;

void thrdstop_handler_resume_main_id(void *arg)
{
       0:	7179                	addi	sp,sp,-48
       2:	f406                	sd	ra,40(sp)
       4:	f022                	sd	s0,32(sp)
       6:	1800                	addi	s0,sp,48
       8:	fca43c23          	sd	a0,-40(s0)
    thrdresume(main_id);  // jump to line 23
       c:	00002797          	auipc	a5,0x2
      10:	0ec78793          	addi	a5,a5,236 # 20f8 <main_id>
      14:	439c                	lw	a5,0(a5)
      16:	853e                	mv	a0,a5
      18:	00000097          	auipc	ra,0x0
      1c:	6b2080e7          	jalr	1714(ra) # 6ca <thrdresume>
    int *v = (int *)arg;
      20:	fd843783          	ld	a5,-40(s0)
      24:	fef43423          	sd	a5,-24(s0)
    ++v;                  // not executed
      28:	fe843783          	ld	a5,-24(s0)
      2c:	0791                	addi	a5,a5,4
      2e:	fef43423          	sd	a5,-24(s0)
}
      32:	0001                	nop
      34:	70a2                	ld	ra,40(sp)
      36:	7402                	ld	s0,32(sp)
      38:	6145                	addi	sp,sp,48
      3a:	8082                	ret

000000000000003c <test_multi_context>:

int test_multi_context()
{
      3c:	1141                	addi	sp,sp,-16
      3e:	e406                	sd	ra,8(sp)
      40:	e022                	sd	s0,0(sp)
      42:	0800                	addi	s0,sp,16
    static int v1 = 0, v2 = 0;

    thrdstop(100, &main_id, thrdstop_handler_resume_main_id, (void *)NULL);
      44:	4681                	li	a3,0
      46:	00000617          	auipc	a2,0x0
      4a:	fba60613          	addi	a2,a2,-70 # 0 <thrdstop_handler_resume_main_id>
      4e:	00002597          	auipc	a1,0x2
      52:	0aa58593          	addi	a1,a1,170 # 20f8 <main_id>
      56:	06400513          	li	a0,100
      5a:	00000097          	auipc	ra,0x0
      5e:	668080e7          	jalr	1640(ra) # 6c2 <thrdstop>
    cancelthrdstop(main_id, 0);
      62:	00002797          	auipc	a5,0x2
      66:	09678793          	addi	a5,a5,150 # 20f8 <main_id>
      6a:	439c                	lw	a5,0(a5)
      6c:	4581                	li	a1,0
      6e:	853e                	mv	a0,a5
      70:	00000097          	auipc	ra,0x0
      74:	662080e7          	jalr	1634(ra) # 6d2 <cancelthrdstop>

    if (v2 == 77) {
      78:	00002797          	auipc	a5,0x2
      7c:	09078793          	addi	a5,a5,144 # 2108 <v2.1>
      80:	439c                	lw	a5,0(a5)
      82:	873e                	mv	a4,a5
      84:	04d00793          	li	a5,77
      88:	02f71363          	bne	a4,a5,ae <test_multi_context+0x72>
        v1 = 210;
      8c:	00002797          	auipc	a5,0x2
      90:	08078793          	addi	a5,a5,128 # 210c <v1.0>
      94:	0d200713          	li	a4,210
      98:	c398                	sw	a4,0(a5)
        thrdresume(second_id); // jump to the while loop below
      9a:	00002797          	auipc	a5,0x2
      9e:	06278793          	addi	a5,a5,98 # 20fc <second_id>
      a2:	439c                	lw	a5,0(a5)
      a4:	853e                	mv	a0,a5
      a6:	00000097          	auipc	ra,0x0
      aa:	624080e7          	jalr	1572(ra) # 6ca <thrdresume>
    }

    v2 += 77;
      ae:	00002797          	auipc	a5,0x2
      b2:	05a78793          	addi	a5,a5,90 # 2108 <v2.1>
      b6:	439c                	lw	a5,0(a5)
      b8:	04d7879b          	addiw	a5,a5,77
      bc:	0007871b          	sext.w	a4,a5
      c0:	00002797          	auipc	a5,0x2
      c4:	04878793          	addi	a5,a5,72 # 2108 <v2.1>
      c8:	c398                	sw	a4,0(a5)
    thrdstop(5, &second_id, thrdstop_handler_resume_main_id, (void *)&v1);
      ca:	00002697          	auipc	a3,0x2
      ce:	04268693          	addi	a3,a3,66 # 210c <v1.0>
      d2:	00000617          	auipc	a2,0x0
      d6:	f2e60613          	addi	a2,a2,-210 # 0 <thrdstop_handler_resume_main_id>
      da:	00002597          	auipc	a1,0x2
      de:	02258593          	addi	a1,a1,34 # 20fc <second_id>
      e2:	4515                	li	a0,5
      e4:	00000097          	auipc	ra,0x0
      e8:	5de080e7          	jalr	1502(ra) # 6c2 <thrdstop>
    while (v1 == 0) {
      ec:	0001                	nop
      ee:	00002797          	auipc	a5,0x2
      f2:	01e78793          	addi	a5,a5,30 # 210c <v1.0>
      f6:	439c                	lw	a5,0(a5)
      f8:	dbfd                	beqz	a5,ee <test_multi_context+0xb2>
        // wait for the handler
    }

    return v1 != 210 || v2 != 77;
      fa:	00002797          	auipc	a5,0x2
      fe:	01278793          	addi	a5,a5,18 # 210c <v1.0>
     102:	439c                	lw	a5,0(a5)
     104:	873e                	mv	a4,a5
     106:	0d200793          	li	a5,210
     10a:	00f71c63          	bne	a4,a5,122 <test_multi_context+0xe6>
     10e:	00002797          	auipc	a5,0x2
     112:	ffa78793          	addi	a5,a5,-6 # 2108 <v2.1>
     116:	439c                	lw	a5,0(a5)
     118:	873e                	mv	a4,a5
     11a:	04d00793          	li	a5,77
     11e:	00f70463          	beq	a4,a5,126 <test_multi_context+0xea>
     122:	4785                	li	a5,1
     124:	a011                	j	128 <test_multi_context+0xec>
     126:	4781                	li	a5,0
}
     128:	853e                	mv	a0,a5
     12a:	60a2                	ld	ra,8(sp)
     12c:	6402                	ld	s0,0(sp)
     12e:	0141                	addi	sp,sp,16
     130:	8082                	ret

0000000000000132 <main>:

int main(int argc, char **argv)
{
     132:	7179                	addi	sp,sp,-48
     134:	f406                	sd	ra,40(sp)
     136:	f022                	sd	s0,32(sp)
     138:	1800                	addi	s0,sp,48
     13a:	87aa                	mv	a5,a0
     13c:	fcb43823          	sd	a1,-48(s0)
     140:	fcf42e23          	sw	a5,-36(s0)
    int result = test_multi_context();
     144:	00000097          	auipc	ra,0x0
     148:	ef8080e7          	jalr	-264(ra) # 3c <test_multi_context>
     14c:	87aa                	mv	a5,a0
     14e:	fef42623          	sw	a5,-20(s0)
    fprintf(2, "[%s] %s\n", result ? "FAILED" : "OK", "test_multi_context");
     152:	fec42783          	lw	a5,-20(s0)
     156:	2781                	sext.w	a5,a5
     158:	c791                	beqz	a5,164 <main+0x32>
     15a:	00002797          	auipc	a5,0x2
     15e:	dfe78793          	addi	a5,a5,-514 # 1f58 <schedule_rm+0x2ac>
     162:	a029                	j	16c <main+0x3a>
     164:	00002797          	auipc	a5,0x2
     168:	dfc78793          	addi	a5,a5,-516 # 1f60 <schedule_rm+0x2b4>
     16c:	00002697          	auipc	a3,0x2
     170:	dfc68693          	addi	a3,a3,-516 # 1f68 <schedule_rm+0x2bc>
     174:	863e                	mv	a2,a5
     176:	00002597          	auipc	a1,0x2
     17a:	e0a58593          	addi	a1,a1,-502 # 1f80 <schedule_rm+0x2d4>
     17e:	4509                	li	a0,2
     180:	00001097          	auipc	ra,0x1
     184:	990080e7          	jalr	-1648(ra) # b10 <fprintf>

    exit(0);
     188:	4501                	li	a0,0
     18a:	00000097          	auipc	ra,0x0
     18e:	498080e7          	jalr	1176(ra) # 622 <exit>

0000000000000192 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     192:	7179                	addi	sp,sp,-48
     194:	f422                	sd	s0,40(sp)
     196:	1800                	addi	s0,sp,48
     198:	fca43c23          	sd	a0,-40(s0)
     19c:	fcb43823          	sd	a1,-48(s0)
  char *os;

  os = s;
     1a0:	fd843783          	ld	a5,-40(s0)
     1a4:	fef43423          	sd	a5,-24(s0)
  while((*s++ = *t++) != 0)
     1a8:	0001                	nop
     1aa:	fd043703          	ld	a4,-48(s0)
     1ae:	00170793          	addi	a5,a4,1
     1b2:	fcf43823          	sd	a5,-48(s0)
     1b6:	fd843783          	ld	a5,-40(s0)
     1ba:	00178693          	addi	a3,a5,1
     1be:	fcd43c23          	sd	a3,-40(s0)
     1c2:	00074703          	lbu	a4,0(a4)
     1c6:	00e78023          	sb	a4,0(a5)
     1ca:	0007c783          	lbu	a5,0(a5)
     1ce:	fff1                	bnez	a5,1aa <strcpy+0x18>
    ;
  return os;
     1d0:	fe843783          	ld	a5,-24(s0)
}
     1d4:	853e                	mv	a0,a5
     1d6:	7422                	ld	s0,40(sp)
     1d8:	6145                	addi	sp,sp,48
     1da:	8082                	ret

00000000000001dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
     1dc:	1101                	addi	sp,sp,-32
     1de:	ec22                	sd	s0,24(sp)
     1e0:	1000                	addi	s0,sp,32
     1e2:	fea43423          	sd	a0,-24(s0)
     1e6:	feb43023          	sd	a1,-32(s0)
  while(*p && *p == *q)
     1ea:	a819                	j	200 <strcmp+0x24>
    p++, q++;
     1ec:	fe843783          	ld	a5,-24(s0)
     1f0:	0785                	addi	a5,a5,1
     1f2:	fef43423          	sd	a5,-24(s0)
     1f6:	fe043783          	ld	a5,-32(s0)
     1fa:	0785                	addi	a5,a5,1
     1fc:	fef43023          	sd	a5,-32(s0)
  while(*p && *p == *q)
     200:	fe843783          	ld	a5,-24(s0)
     204:	0007c783          	lbu	a5,0(a5)
     208:	cb99                	beqz	a5,21e <strcmp+0x42>
     20a:	fe843783          	ld	a5,-24(s0)
     20e:	0007c703          	lbu	a4,0(a5)
     212:	fe043783          	ld	a5,-32(s0)
     216:	0007c783          	lbu	a5,0(a5)
     21a:	fcf709e3          	beq	a4,a5,1ec <strcmp+0x10>
  return (uchar)*p - (uchar)*q;
     21e:	fe843783          	ld	a5,-24(s0)
     222:	0007c783          	lbu	a5,0(a5)
     226:	0007871b          	sext.w	a4,a5
     22a:	fe043783          	ld	a5,-32(s0)
     22e:	0007c783          	lbu	a5,0(a5)
     232:	2781                	sext.w	a5,a5
     234:	40f707bb          	subw	a5,a4,a5
     238:	2781                	sext.w	a5,a5
}
     23a:	853e                	mv	a0,a5
     23c:	6462                	ld	s0,24(sp)
     23e:	6105                	addi	sp,sp,32
     240:	8082                	ret

0000000000000242 <strlen>:

uint
strlen(const char *s)
{
     242:	7179                	addi	sp,sp,-48
     244:	f422                	sd	s0,40(sp)
     246:	1800                	addi	s0,sp,48
     248:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
     24c:	fe042623          	sw	zero,-20(s0)
     250:	a031                	j	25c <strlen+0x1a>
     252:	fec42783          	lw	a5,-20(s0)
     256:	2785                	addiw	a5,a5,1
     258:	fef42623          	sw	a5,-20(s0)
     25c:	fec42783          	lw	a5,-20(s0)
     260:	fd843703          	ld	a4,-40(s0)
     264:	97ba                	add	a5,a5,a4
     266:	0007c783          	lbu	a5,0(a5)
     26a:	f7e5                	bnez	a5,252 <strlen+0x10>
    ;
  return n;
     26c:	fec42783          	lw	a5,-20(s0)
}
     270:	853e                	mv	a0,a5
     272:	7422                	ld	s0,40(sp)
     274:	6145                	addi	sp,sp,48
     276:	8082                	ret

0000000000000278 <memset>:

void*
memset(void *dst, int c, uint n)
{
     278:	7179                	addi	sp,sp,-48
     27a:	f422                	sd	s0,40(sp)
     27c:	1800                	addi	s0,sp,48
     27e:	fca43c23          	sd	a0,-40(s0)
     282:	87ae                	mv	a5,a1
     284:	8732                	mv	a4,a2
     286:	fcf42a23          	sw	a5,-44(s0)
     28a:	87ba                	mv	a5,a4
     28c:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
     290:	fd843783          	ld	a5,-40(s0)
     294:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
     298:	fe042623          	sw	zero,-20(s0)
     29c:	a00d                	j	2be <memset+0x46>
    cdst[i] = c;
     29e:	fec42783          	lw	a5,-20(s0)
     2a2:	fe043703          	ld	a4,-32(s0)
     2a6:	97ba                	add	a5,a5,a4
     2a8:	fd442703          	lw	a4,-44(s0)
     2ac:	0ff77713          	andi	a4,a4,255
     2b0:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
     2b4:	fec42783          	lw	a5,-20(s0)
     2b8:	2785                	addiw	a5,a5,1
     2ba:	fef42623          	sw	a5,-20(s0)
     2be:	fec42703          	lw	a4,-20(s0)
     2c2:	fd042783          	lw	a5,-48(s0)
     2c6:	2781                	sext.w	a5,a5
     2c8:	fcf76be3          	bltu	a4,a5,29e <memset+0x26>
  }
  return dst;
     2cc:	fd843783          	ld	a5,-40(s0)
}
     2d0:	853e                	mv	a0,a5
     2d2:	7422                	ld	s0,40(sp)
     2d4:	6145                	addi	sp,sp,48
     2d6:	8082                	ret

00000000000002d8 <strchr>:

char*
strchr(const char *s, char c)
{
     2d8:	1101                	addi	sp,sp,-32
     2da:	ec22                	sd	s0,24(sp)
     2dc:	1000                	addi	s0,sp,32
     2de:	fea43423          	sd	a0,-24(s0)
     2e2:	87ae                	mv	a5,a1
     2e4:	fef403a3          	sb	a5,-25(s0)
  for(; *s; s++)
     2e8:	a01d                	j	30e <strchr+0x36>
    if(*s == c)
     2ea:	fe843783          	ld	a5,-24(s0)
     2ee:	0007c703          	lbu	a4,0(a5)
     2f2:	fe744783          	lbu	a5,-25(s0)
     2f6:	0ff7f793          	andi	a5,a5,255
     2fa:	00e79563          	bne	a5,a4,304 <strchr+0x2c>
      return (char*)s;
     2fe:	fe843783          	ld	a5,-24(s0)
     302:	a821                	j	31a <strchr+0x42>
  for(; *s; s++)
     304:	fe843783          	ld	a5,-24(s0)
     308:	0785                	addi	a5,a5,1
     30a:	fef43423          	sd	a5,-24(s0)
     30e:	fe843783          	ld	a5,-24(s0)
     312:	0007c783          	lbu	a5,0(a5)
     316:	fbf1                	bnez	a5,2ea <strchr+0x12>
  return 0;
     318:	4781                	li	a5,0
}
     31a:	853e                	mv	a0,a5
     31c:	6462                	ld	s0,24(sp)
     31e:	6105                	addi	sp,sp,32
     320:	8082                	ret

0000000000000322 <gets>:

char*
gets(char *buf, int max)
{
     322:	7179                	addi	sp,sp,-48
     324:	f406                	sd	ra,40(sp)
     326:	f022                	sd	s0,32(sp)
     328:	1800                	addi	s0,sp,48
     32a:	fca43c23          	sd	a0,-40(s0)
     32e:	87ae                	mv	a5,a1
     330:	fcf42a23          	sw	a5,-44(s0)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     334:	fe042623          	sw	zero,-20(s0)
     338:	a8a1                	j	390 <gets+0x6e>
    cc = read(0, &c, 1);
     33a:	fe740793          	addi	a5,s0,-25
     33e:	4605                	li	a2,1
     340:	85be                	mv	a1,a5
     342:	4501                	li	a0,0
     344:	00000097          	auipc	ra,0x0
     348:	2f6080e7          	jalr	758(ra) # 63a <read>
     34c:	87aa                	mv	a5,a0
     34e:	fef42423          	sw	a5,-24(s0)
    if(cc < 1)
     352:	fe842783          	lw	a5,-24(s0)
     356:	2781                	sext.w	a5,a5
     358:	04f05763          	blez	a5,3a6 <gets+0x84>
      break;
    buf[i++] = c;
     35c:	fec42783          	lw	a5,-20(s0)
     360:	0017871b          	addiw	a4,a5,1
     364:	fee42623          	sw	a4,-20(s0)
     368:	873e                	mv	a4,a5
     36a:	fd843783          	ld	a5,-40(s0)
     36e:	97ba                	add	a5,a5,a4
     370:	fe744703          	lbu	a4,-25(s0)
     374:	00e78023          	sb	a4,0(a5)
    if(c == '\n' || c == '\r')
     378:	fe744783          	lbu	a5,-25(s0)
     37c:	873e                	mv	a4,a5
     37e:	47a9                	li	a5,10
     380:	02f70463          	beq	a4,a5,3a8 <gets+0x86>
     384:	fe744783          	lbu	a5,-25(s0)
     388:	873e                	mv	a4,a5
     38a:	47b5                	li	a5,13
     38c:	00f70e63          	beq	a4,a5,3a8 <gets+0x86>
  for(i=0; i+1 < max; ){
     390:	fec42783          	lw	a5,-20(s0)
     394:	2785                	addiw	a5,a5,1
     396:	0007871b          	sext.w	a4,a5
     39a:	fd442783          	lw	a5,-44(s0)
     39e:	2781                	sext.w	a5,a5
     3a0:	f8f74de3          	blt	a4,a5,33a <gets+0x18>
     3a4:	a011                	j	3a8 <gets+0x86>
      break;
     3a6:	0001                	nop
      break;
  }
  buf[i] = '\0';
     3a8:	fec42783          	lw	a5,-20(s0)
     3ac:	fd843703          	ld	a4,-40(s0)
     3b0:	97ba                	add	a5,a5,a4
     3b2:	00078023          	sb	zero,0(a5)
  return buf;
     3b6:	fd843783          	ld	a5,-40(s0)
}
     3ba:	853e                	mv	a0,a5
     3bc:	70a2                	ld	ra,40(sp)
     3be:	7402                	ld	s0,32(sp)
     3c0:	6145                	addi	sp,sp,48
     3c2:	8082                	ret

00000000000003c4 <stat>:

int
stat(const char *n, struct stat *st)
{
     3c4:	7179                	addi	sp,sp,-48
     3c6:	f406                	sd	ra,40(sp)
     3c8:	f022                	sd	s0,32(sp)
     3ca:	1800                	addi	s0,sp,48
     3cc:	fca43c23          	sd	a0,-40(s0)
     3d0:	fcb43823          	sd	a1,-48(s0)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     3d4:	4581                	li	a1,0
     3d6:	fd843503          	ld	a0,-40(s0)
     3da:	00000097          	auipc	ra,0x0
     3de:	288080e7          	jalr	648(ra) # 662 <open>
     3e2:	87aa                	mv	a5,a0
     3e4:	fef42623          	sw	a5,-20(s0)
  if(fd < 0)
     3e8:	fec42783          	lw	a5,-20(s0)
     3ec:	2781                	sext.w	a5,a5
     3ee:	0007d463          	bgez	a5,3f6 <stat+0x32>
    return -1;
     3f2:	57fd                	li	a5,-1
     3f4:	a035                	j	420 <stat+0x5c>
  r = fstat(fd, st);
     3f6:	fec42783          	lw	a5,-20(s0)
     3fa:	fd043583          	ld	a1,-48(s0)
     3fe:	853e                	mv	a0,a5
     400:	00000097          	auipc	ra,0x0
     404:	27a080e7          	jalr	634(ra) # 67a <fstat>
     408:	87aa                	mv	a5,a0
     40a:	fef42423          	sw	a5,-24(s0)
  close(fd);
     40e:	fec42783          	lw	a5,-20(s0)
     412:	853e                	mv	a0,a5
     414:	00000097          	auipc	ra,0x0
     418:	236080e7          	jalr	566(ra) # 64a <close>
  return r;
     41c:	fe842783          	lw	a5,-24(s0)
}
     420:	853e                	mv	a0,a5
     422:	70a2                	ld	ra,40(sp)
     424:	7402                	ld	s0,32(sp)
     426:	6145                	addi	sp,sp,48
     428:	8082                	ret

000000000000042a <atoi>:

int
atoi(const char *s)
{
     42a:	7179                	addi	sp,sp,-48
     42c:	f422                	sd	s0,40(sp)
     42e:	1800                	addi	s0,sp,48
     430:	fca43c23          	sd	a0,-40(s0)
  int n;

  n = 0;
     434:	fe042623          	sw	zero,-20(s0)
  while('0' <= *s && *s <= '9')
     438:	a815                	j	46c <atoi+0x42>
    n = n*10 + *s++ - '0';
     43a:	fec42703          	lw	a4,-20(s0)
     43e:	87ba                	mv	a5,a4
     440:	0027979b          	slliw	a5,a5,0x2
     444:	9fb9                	addw	a5,a5,a4
     446:	0017979b          	slliw	a5,a5,0x1
     44a:	0007871b          	sext.w	a4,a5
     44e:	fd843783          	ld	a5,-40(s0)
     452:	00178693          	addi	a3,a5,1
     456:	fcd43c23          	sd	a3,-40(s0)
     45a:	0007c783          	lbu	a5,0(a5)
     45e:	2781                	sext.w	a5,a5
     460:	9fb9                	addw	a5,a5,a4
     462:	2781                	sext.w	a5,a5
     464:	fd07879b          	addiw	a5,a5,-48
     468:	fef42623          	sw	a5,-20(s0)
  while('0' <= *s && *s <= '9')
     46c:	fd843783          	ld	a5,-40(s0)
     470:	0007c783          	lbu	a5,0(a5)
     474:	873e                	mv	a4,a5
     476:	02f00793          	li	a5,47
     47a:	00e7fb63          	bgeu	a5,a4,490 <atoi+0x66>
     47e:	fd843783          	ld	a5,-40(s0)
     482:	0007c783          	lbu	a5,0(a5)
     486:	873e                	mv	a4,a5
     488:	03900793          	li	a5,57
     48c:	fae7f7e3          	bgeu	a5,a4,43a <atoi+0x10>
  return n;
     490:	fec42783          	lw	a5,-20(s0)
}
     494:	853e                	mv	a0,a5
     496:	7422                	ld	s0,40(sp)
     498:	6145                	addi	sp,sp,48
     49a:	8082                	ret

000000000000049c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     49c:	7139                	addi	sp,sp,-64
     49e:	fc22                	sd	s0,56(sp)
     4a0:	0080                	addi	s0,sp,64
     4a2:	fca43c23          	sd	a0,-40(s0)
     4a6:	fcb43823          	sd	a1,-48(s0)
     4aa:	87b2                	mv	a5,a2
     4ac:	fcf42623          	sw	a5,-52(s0)
  char *dst;
  const char *src;

  dst = vdst;
     4b0:	fd843783          	ld	a5,-40(s0)
     4b4:	fef43423          	sd	a5,-24(s0)
  src = vsrc;
     4b8:	fd043783          	ld	a5,-48(s0)
     4bc:	fef43023          	sd	a5,-32(s0)
  if (src > dst) {
     4c0:	fe043703          	ld	a4,-32(s0)
     4c4:	fe843783          	ld	a5,-24(s0)
     4c8:	02e7fc63          	bgeu	a5,a4,500 <memmove+0x64>
    while(n-- > 0)
     4cc:	a00d                	j	4ee <memmove+0x52>
      *dst++ = *src++;
     4ce:	fe043703          	ld	a4,-32(s0)
     4d2:	00170793          	addi	a5,a4,1
     4d6:	fef43023          	sd	a5,-32(s0)
     4da:	fe843783          	ld	a5,-24(s0)
     4de:	00178693          	addi	a3,a5,1
     4e2:	fed43423          	sd	a3,-24(s0)
     4e6:	00074703          	lbu	a4,0(a4)
     4ea:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     4ee:	fcc42783          	lw	a5,-52(s0)
     4f2:	fff7871b          	addiw	a4,a5,-1
     4f6:	fce42623          	sw	a4,-52(s0)
     4fa:	fcf04ae3          	bgtz	a5,4ce <memmove+0x32>
     4fe:	a891                	j	552 <memmove+0xb6>
  } else {
    dst += n;
     500:	fcc42783          	lw	a5,-52(s0)
     504:	fe843703          	ld	a4,-24(s0)
     508:	97ba                	add	a5,a5,a4
     50a:	fef43423          	sd	a5,-24(s0)
    src += n;
     50e:	fcc42783          	lw	a5,-52(s0)
     512:	fe043703          	ld	a4,-32(s0)
     516:	97ba                	add	a5,a5,a4
     518:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
     51c:	a01d                	j	542 <memmove+0xa6>
      *--dst = *--src;
     51e:	fe043783          	ld	a5,-32(s0)
     522:	17fd                	addi	a5,a5,-1
     524:	fef43023          	sd	a5,-32(s0)
     528:	fe843783          	ld	a5,-24(s0)
     52c:	17fd                	addi	a5,a5,-1
     52e:	fef43423          	sd	a5,-24(s0)
     532:	fe043783          	ld	a5,-32(s0)
     536:	0007c703          	lbu	a4,0(a5)
     53a:	fe843783          	ld	a5,-24(s0)
     53e:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
     542:	fcc42783          	lw	a5,-52(s0)
     546:	fff7871b          	addiw	a4,a5,-1
     54a:	fce42623          	sw	a4,-52(s0)
     54e:	fcf048e3          	bgtz	a5,51e <memmove+0x82>
  }
  return vdst;
     552:	fd843783          	ld	a5,-40(s0)
}
     556:	853e                	mv	a0,a5
     558:	7462                	ld	s0,56(sp)
     55a:	6121                	addi	sp,sp,64
     55c:	8082                	ret

000000000000055e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     55e:	7139                	addi	sp,sp,-64
     560:	fc22                	sd	s0,56(sp)
     562:	0080                	addi	s0,sp,64
     564:	fca43c23          	sd	a0,-40(s0)
     568:	fcb43823          	sd	a1,-48(s0)
     56c:	87b2                	mv	a5,a2
     56e:	fcf42623          	sw	a5,-52(s0)
  const char *p1 = s1, *p2 = s2;
     572:	fd843783          	ld	a5,-40(s0)
     576:	fef43423          	sd	a5,-24(s0)
     57a:	fd043783          	ld	a5,-48(s0)
     57e:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     582:	a0a1                	j	5ca <memcmp+0x6c>
    if (*p1 != *p2) {
     584:	fe843783          	ld	a5,-24(s0)
     588:	0007c703          	lbu	a4,0(a5)
     58c:	fe043783          	ld	a5,-32(s0)
     590:	0007c783          	lbu	a5,0(a5)
     594:	02f70163          	beq	a4,a5,5b6 <memcmp+0x58>
      return *p1 - *p2;
     598:	fe843783          	ld	a5,-24(s0)
     59c:	0007c783          	lbu	a5,0(a5)
     5a0:	0007871b          	sext.w	a4,a5
     5a4:	fe043783          	ld	a5,-32(s0)
     5a8:	0007c783          	lbu	a5,0(a5)
     5ac:	2781                	sext.w	a5,a5
     5ae:	40f707bb          	subw	a5,a4,a5
     5b2:	2781                	sext.w	a5,a5
     5b4:	a01d                	j	5da <memcmp+0x7c>
    }
    p1++;
     5b6:	fe843783          	ld	a5,-24(s0)
     5ba:	0785                	addi	a5,a5,1
     5bc:	fef43423          	sd	a5,-24(s0)
    p2++;
     5c0:	fe043783          	ld	a5,-32(s0)
     5c4:	0785                	addi	a5,a5,1
     5c6:	fef43023          	sd	a5,-32(s0)
  while (n-- > 0) {
     5ca:	fcc42783          	lw	a5,-52(s0)
     5ce:	fff7871b          	addiw	a4,a5,-1
     5d2:	fce42623          	sw	a4,-52(s0)
     5d6:	f7dd                	bnez	a5,584 <memcmp+0x26>
  }
  return 0;
     5d8:	4781                	li	a5,0
}
     5da:	853e                	mv	a0,a5
     5dc:	7462                	ld	s0,56(sp)
     5de:	6121                	addi	sp,sp,64
     5e0:	8082                	ret

00000000000005e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     5e2:	7179                	addi	sp,sp,-48
     5e4:	f406                	sd	ra,40(sp)
     5e6:	f022                	sd	s0,32(sp)
     5e8:	1800                	addi	s0,sp,48
     5ea:	fea43423          	sd	a0,-24(s0)
     5ee:	feb43023          	sd	a1,-32(s0)
     5f2:	87b2                	mv	a5,a2
     5f4:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
     5f8:	fdc42783          	lw	a5,-36(s0)
     5fc:	863e                	mv	a2,a5
     5fe:	fe043583          	ld	a1,-32(s0)
     602:	fe843503          	ld	a0,-24(s0)
     606:	00000097          	auipc	ra,0x0
     60a:	e96080e7          	jalr	-362(ra) # 49c <memmove>
     60e:	87aa                	mv	a5,a0
}
     610:	853e                	mv	a0,a5
     612:	70a2                	ld	ra,40(sp)
     614:	7402                	ld	s0,32(sp)
     616:	6145                	addi	sp,sp,48
     618:	8082                	ret

000000000000061a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     61a:	4885                	li	a7,1
 ecall
     61c:	00000073          	ecall
 ret
     620:	8082                	ret

0000000000000622 <exit>:
.global exit
exit:
 li a7, SYS_exit
     622:	4889                	li	a7,2
 ecall
     624:	00000073          	ecall
 ret
     628:	8082                	ret

000000000000062a <wait>:
.global wait
wait:
 li a7, SYS_wait
     62a:	488d                	li	a7,3
 ecall
     62c:	00000073          	ecall
 ret
     630:	8082                	ret

0000000000000632 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     632:	4891                	li	a7,4
 ecall
     634:	00000073          	ecall
 ret
     638:	8082                	ret

000000000000063a <read>:
.global read
read:
 li a7, SYS_read
     63a:	4895                	li	a7,5
 ecall
     63c:	00000073          	ecall
 ret
     640:	8082                	ret

0000000000000642 <write>:
.global write
write:
 li a7, SYS_write
     642:	48c1                	li	a7,16
 ecall
     644:	00000073          	ecall
 ret
     648:	8082                	ret

000000000000064a <close>:
.global close
close:
 li a7, SYS_close
     64a:	48d5                	li	a7,21
 ecall
     64c:	00000073          	ecall
 ret
     650:	8082                	ret

0000000000000652 <kill>:
.global kill
kill:
 li a7, SYS_kill
     652:	4899                	li	a7,6
 ecall
     654:	00000073          	ecall
 ret
     658:	8082                	ret

000000000000065a <exec>:
.global exec
exec:
 li a7, SYS_exec
     65a:	489d                	li	a7,7
 ecall
     65c:	00000073          	ecall
 ret
     660:	8082                	ret

0000000000000662 <open>:
.global open
open:
 li a7, SYS_open
     662:	48bd                	li	a7,15
 ecall
     664:	00000073          	ecall
 ret
     668:	8082                	ret

000000000000066a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     66a:	48c5                	li	a7,17
 ecall
     66c:	00000073          	ecall
 ret
     670:	8082                	ret

0000000000000672 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     672:	48c9                	li	a7,18
 ecall
     674:	00000073          	ecall
 ret
     678:	8082                	ret

000000000000067a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     67a:	48a1                	li	a7,8
 ecall
     67c:	00000073          	ecall
 ret
     680:	8082                	ret

0000000000000682 <link>:
.global link
link:
 li a7, SYS_link
     682:	48cd                	li	a7,19
 ecall
     684:	00000073          	ecall
 ret
     688:	8082                	ret

000000000000068a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     68a:	48d1                	li	a7,20
 ecall
     68c:	00000073          	ecall
 ret
     690:	8082                	ret

0000000000000692 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     692:	48a5                	li	a7,9
 ecall
     694:	00000073          	ecall
 ret
     698:	8082                	ret

000000000000069a <dup>:
.global dup
dup:
 li a7, SYS_dup
     69a:	48a9                	li	a7,10
 ecall
     69c:	00000073          	ecall
 ret
     6a0:	8082                	ret

00000000000006a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     6a2:	48ad                	li	a7,11
 ecall
     6a4:	00000073          	ecall
 ret
     6a8:	8082                	ret

00000000000006aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     6aa:	48b1                	li	a7,12
 ecall
     6ac:	00000073          	ecall
 ret
     6b0:	8082                	ret

00000000000006b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     6b2:	48b5                	li	a7,13
 ecall
     6b4:	00000073          	ecall
 ret
     6b8:	8082                	ret

00000000000006ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     6ba:	48b9                	li	a7,14
 ecall
     6bc:	00000073          	ecall
 ret
     6c0:	8082                	ret

00000000000006c2 <thrdstop>:
.global thrdstop
thrdstop:
 li a7, SYS_thrdstop
     6c2:	48d9                	li	a7,22
 ecall
     6c4:	00000073          	ecall
 ret
     6c8:	8082                	ret

00000000000006ca <thrdresume>:
.global thrdresume
thrdresume:
 li a7, SYS_thrdresume
     6ca:	48dd                	li	a7,23
 ecall
     6cc:	00000073          	ecall
 ret
     6d0:	8082                	ret

00000000000006d2 <cancelthrdstop>:
.global cancelthrdstop
cancelthrdstop:
 li a7, SYS_cancelthrdstop
     6d2:	48e1                	li	a7,24
 ecall
     6d4:	00000073          	ecall
 ret
     6d8:	8082                	ret

00000000000006da <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     6da:	1101                	addi	sp,sp,-32
     6dc:	ec06                	sd	ra,24(sp)
     6de:	e822                	sd	s0,16(sp)
     6e0:	1000                	addi	s0,sp,32
     6e2:	87aa                	mv	a5,a0
     6e4:	872e                	mv	a4,a1
     6e6:	fef42623          	sw	a5,-20(s0)
     6ea:	87ba                	mv	a5,a4
     6ec:	fef405a3          	sb	a5,-21(s0)
  write(fd, &c, 1);
     6f0:	feb40713          	addi	a4,s0,-21
     6f4:	fec42783          	lw	a5,-20(s0)
     6f8:	4605                	li	a2,1
     6fa:	85ba                	mv	a1,a4
     6fc:	853e                	mv	a0,a5
     6fe:	00000097          	auipc	ra,0x0
     702:	f44080e7          	jalr	-188(ra) # 642 <write>
}
     706:	0001                	nop
     708:	60e2                	ld	ra,24(sp)
     70a:	6442                	ld	s0,16(sp)
     70c:	6105                	addi	sp,sp,32
     70e:	8082                	ret

0000000000000710 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     710:	7139                	addi	sp,sp,-64
     712:	fc06                	sd	ra,56(sp)
     714:	f822                	sd	s0,48(sp)
     716:	0080                	addi	s0,sp,64
     718:	87aa                	mv	a5,a0
     71a:	8736                	mv	a4,a3
     71c:	fcf42623          	sw	a5,-52(s0)
     720:	87ae                	mv	a5,a1
     722:	fcf42423          	sw	a5,-56(s0)
     726:	87b2                	mv	a5,a2
     728:	fcf42223          	sw	a5,-60(s0)
     72c:	87ba                	mv	a5,a4
     72e:	fcf42023          	sw	a5,-64(s0)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     732:	fe042423          	sw	zero,-24(s0)
  if(sgn && xx < 0){
     736:	fc042783          	lw	a5,-64(s0)
     73a:	2781                	sext.w	a5,a5
     73c:	c38d                	beqz	a5,75e <printint+0x4e>
     73e:	fc842783          	lw	a5,-56(s0)
     742:	2781                	sext.w	a5,a5
     744:	0007dd63          	bgez	a5,75e <printint+0x4e>
    neg = 1;
     748:	4785                	li	a5,1
     74a:	fef42423          	sw	a5,-24(s0)
    x = -xx;
     74e:	fc842783          	lw	a5,-56(s0)
     752:	40f007bb          	negw	a5,a5
     756:	2781                	sext.w	a5,a5
     758:	fef42223          	sw	a5,-28(s0)
     75c:	a029                	j	766 <printint+0x56>
  } else {
    x = xx;
     75e:	fc842783          	lw	a5,-56(s0)
     762:	fef42223          	sw	a5,-28(s0)
  }

  i = 0;
     766:	fe042623          	sw	zero,-20(s0)
  do{
    buf[i++] = digits[x % base];
     76a:	fc442783          	lw	a5,-60(s0)
     76e:	fe442703          	lw	a4,-28(s0)
     772:	02f777bb          	remuw	a5,a4,a5
     776:	0007861b          	sext.w	a2,a5
     77a:	fec42783          	lw	a5,-20(s0)
     77e:	0017871b          	addiw	a4,a5,1
     782:	fee42623          	sw	a4,-20(s0)
     786:	00002697          	auipc	a3,0x2
     78a:	93a68693          	addi	a3,a3,-1734 # 20c0 <digits>
     78e:	02061713          	slli	a4,a2,0x20
     792:	9301                	srli	a4,a4,0x20
     794:	9736                	add	a4,a4,a3
     796:	00074703          	lbu	a4,0(a4)
     79a:	ff040693          	addi	a3,s0,-16
     79e:	97b6                	add	a5,a5,a3
     7a0:	fee78023          	sb	a4,-32(a5)
  }while((x /= base) != 0);
     7a4:	fc442783          	lw	a5,-60(s0)
     7a8:	fe442703          	lw	a4,-28(s0)
     7ac:	02f757bb          	divuw	a5,a4,a5
     7b0:	fef42223          	sw	a5,-28(s0)
     7b4:	fe442783          	lw	a5,-28(s0)
     7b8:	2781                	sext.w	a5,a5
     7ba:	fbc5                	bnez	a5,76a <printint+0x5a>
  if(neg)
     7bc:	fe842783          	lw	a5,-24(s0)
     7c0:	2781                	sext.w	a5,a5
     7c2:	cf95                	beqz	a5,7fe <printint+0xee>
    buf[i++] = '-';
     7c4:	fec42783          	lw	a5,-20(s0)
     7c8:	0017871b          	addiw	a4,a5,1
     7cc:	fee42623          	sw	a4,-20(s0)
     7d0:	ff040713          	addi	a4,s0,-16
     7d4:	97ba                	add	a5,a5,a4
     7d6:	02d00713          	li	a4,45
     7da:	fee78023          	sb	a4,-32(a5)

  while(--i >= 0)
     7de:	a005                	j	7fe <printint+0xee>
    putc(fd, buf[i]);
     7e0:	fec42783          	lw	a5,-20(s0)
     7e4:	ff040713          	addi	a4,s0,-16
     7e8:	97ba                	add	a5,a5,a4
     7ea:	fe07c703          	lbu	a4,-32(a5)
     7ee:	fcc42783          	lw	a5,-52(s0)
     7f2:	85ba                	mv	a1,a4
     7f4:	853e                	mv	a0,a5
     7f6:	00000097          	auipc	ra,0x0
     7fa:	ee4080e7          	jalr	-284(ra) # 6da <putc>
  while(--i >= 0)
     7fe:	fec42783          	lw	a5,-20(s0)
     802:	37fd                	addiw	a5,a5,-1
     804:	fef42623          	sw	a5,-20(s0)
     808:	fec42783          	lw	a5,-20(s0)
     80c:	2781                	sext.w	a5,a5
     80e:	fc07d9e3          	bgez	a5,7e0 <printint+0xd0>
}
     812:	0001                	nop
     814:	0001                	nop
     816:	70e2                	ld	ra,56(sp)
     818:	7442                	ld	s0,48(sp)
     81a:	6121                	addi	sp,sp,64
     81c:	8082                	ret

000000000000081e <printptr>:

static void
printptr(int fd, uint64 x) {
     81e:	7179                	addi	sp,sp,-48
     820:	f406                	sd	ra,40(sp)
     822:	f022                	sd	s0,32(sp)
     824:	1800                	addi	s0,sp,48
     826:	87aa                	mv	a5,a0
     828:	fcb43823          	sd	a1,-48(s0)
     82c:	fcf42e23          	sw	a5,-36(s0)
  int i;
  putc(fd, '0');
     830:	fdc42783          	lw	a5,-36(s0)
     834:	03000593          	li	a1,48
     838:	853e                	mv	a0,a5
     83a:	00000097          	auipc	ra,0x0
     83e:	ea0080e7          	jalr	-352(ra) # 6da <putc>
  putc(fd, 'x');
     842:	fdc42783          	lw	a5,-36(s0)
     846:	07800593          	li	a1,120
     84a:	853e                	mv	a0,a5
     84c:	00000097          	auipc	ra,0x0
     850:	e8e080e7          	jalr	-370(ra) # 6da <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     854:	fe042623          	sw	zero,-20(s0)
     858:	a82d                	j	892 <printptr+0x74>
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     85a:	fd043783          	ld	a5,-48(s0)
     85e:	93f1                	srli	a5,a5,0x3c
     860:	00002717          	auipc	a4,0x2
     864:	86070713          	addi	a4,a4,-1952 # 20c0 <digits>
     868:	97ba                	add	a5,a5,a4
     86a:	0007c703          	lbu	a4,0(a5)
     86e:	fdc42783          	lw	a5,-36(s0)
     872:	85ba                	mv	a1,a4
     874:	853e                	mv	a0,a5
     876:	00000097          	auipc	ra,0x0
     87a:	e64080e7          	jalr	-412(ra) # 6da <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     87e:	fec42783          	lw	a5,-20(s0)
     882:	2785                	addiw	a5,a5,1
     884:	fef42623          	sw	a5,-20(s0)
     888:	fd043783          	ld	a5,-48(s0)
     88c:	0792                	slli	a5,a5,0x4
     88e:	fcf43823          	sd	a5,-48(s0)
     892:	fec42783          	lw	a5,-20(s0)
     896:	873e                	mv	a4,a5
     898:	47bd                	li	a5,15
     89a:	fce7f0e3          	bgeu	a5,a4,85a <printptr+0x3c>
}
     89e:	0001                	nop
     8a0:	0001                	nop
     8a2:	70a2                	ld	ra,40(sp)
     8a4:	7402                	ld	s0,32(sp)
     8a6:	6145                	addi	sp,sp,48
     8a8:	8082                	ret

00000000000008aa <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     8aa:	715d                	addi	sp,sp,-80
     8ac:	e486                	sd	ra,72(sp)
     8ae:	e0a2                	sd	s0,64(sp)
     8b0:	0880                	addi	s0,sp,80
     8b2:	87aa                	mv	a5,a0
     8b4:	fcb43023          	sd	a1,-64(s0)
     8b8:	fac43c23          	sd	a2,-72(s0)
     8bc:	fcf42623          	sw	a5,-52(s0)
  char *s;
  int c, i, state;

  state = 0;
     8c0:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     8c4:	fe042223          	sw	zero,-28(s0)
     8c8:	a42d                	j	af2 <vprintf+0x248>
    c = fmt[i] & 0xff;
     8ca:	fe442783          	lw	a5,-28(s0)
     8ce:	fc043703          	ld	a4,-64(s0)
     8d2:	97ba                	add	a5,a5,a4
     8d4:	0007c783          	lbu	a5,0(a5)
     8d8:	fcf42e23          	sw	a5,-36(s0)
    if(state == 0){
     8dc:	fe042783          	lw	a5,-32(s0)
     8e0:	2781                	sext.w	a5,a5
     8e2:	eb9d                	bnez	a5,918 <vprintf+0x6e>
      if(c == '%'){
     8e4:	fdc42783          	lw	a5,-36(s0)
     8e8:	0007871b          	sext.w	a4,a5
     8ec:	02500793          	li	a5,37
     8f0:	00f71763          	bne	a4,a5,8fe <vprintf+0x54>
        state = '%';
     8f4:	02500793          	li	a5,37
     8f8:	fef42023          	sw	a5,-32(s0)
     8fc:	a2f5                	j	ae8 <vprintf+0x23e>
      } else {
        putc(fd, c);
     8fe:	fdc42783          	lw	a5,-36(s0)
     902:	0ff7f713          	andi	a4,a5,255
     906:	fcc42783          	lw	a5,-52(s0)
     90a:	85ba                	mv	a1,a4
     90c:	853e                	mv	a0,a5
     90e:	00000097          	auipc	ra,0x0
     912:	dcc080e7          	jalr	-564(ra) # 6da <putc>
     916:	aac9                	j	ae8 <vprintf+0x23e>
      }
    } else if(state == '%'){
     918:	fe042783          	lw	a5,-32(s0)
     91c:	0007871b          	sext.w	a4,a5
     920:	02500793          	li	a5,37
     924:	1cf71263          	bne	a4,a5,ae8 <vprintf+0x23e>
      if(c == 'd'){
     928:	fdc42783          	lw	a5,-36(s0)
     92c:	0007871b          	sext.w	a4,a5
     930:	06400793          	li	a5,100
     934:	02f71463          	bne	a4,a5,95c <vprintf+0xb2>
        printint(fd, va_arg(ap, int), 10, 1);
     938:	fb843783          	ld	a5,-72(s0)
     93c:	00878713          	addi	a4,a5,8
     940:	fae43c23          	sd	a4,-72(s0)
     944:	4398                	lw	a4,0(a5)
     946:	fcc42783          	lw	a5,-52(s0)
     94a:	4685                	li	a3,1
     94c:	4629                	li	a2,10
     94e:	85ba                	mv	a1,a4
     950:	853e                	mv	a0,a5
     952:	00000097          	auipc	ra,0x0
     956:	dbe080e7          	jalr	-578(ra) # 710 <printint>
     95a:	a269                	j	ae4 <vprintf+0x23a>
      } else if(c == 'l') {
     95c:	fdc42783          	lw	a5,-36(s0)
     960:	0007871b          	sext.w	a4,a5
     964:	06c00793          	li	a5,108
     968:	02f71663          	bne	a4,a5,994 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 0);
     96c:	fb843783          	ld	a5,-72(s0)
     970:	00878713          	addi	a4,a5,8
     974:	fae43c23          	sd	a4,-72(s0)
     978:	639c                	ld	a5,0(a5)
     97a:	0007871b          	sext.w	a4,a5
     97e:	fcc42783          	lw	a5,-52(s0)
     982:	4681                	li	a3,0
     984:	4629                	li	a2,10
     986:	85ba                	mv	a1,a4
     988:	853e                	mv	a0,a5
     98a:	00000097          	auipc	ra,0x0
     98e:	d86080e7          	jalr	-634(ra) # 710 <printint>
     992:	aa89                	j	ae4 <vprintf+0x23a>
      } else if(c == 'x') {
     994:	fdc42783          	lw	a5,-36(s0)
     998:	0007871b          	sext.w	a4,a5
     99c:	07800793          	li	a5,120
     9a0:	02f71463          	bne	a4,a5,9c8 <vprintf+0x11e>
        printint(fd, va_arg(ap, int), 16, 0);
     9a4:	fb843783          	ld	a5,-72(s0)
     9a8:	00878713          	addi	a4,a5,8
     9ac:	fae43c23          	sd	a4,-72(s0)
     9b0:	4398                	lw	a4,0(a5)
     9b2:	fcc42783          	lw	a5,-52(s0)
     9b6:	4681                	li	a3,0
     9b8:	4641                	li	a2,16
     9ba:	85ba                	mv	a1,a4
     9bc:	853e                	mv	a0,a5
     9be:	00000097          	auipc	ra,0x0
     9c2:	d52080e7          	jalr	-686(ra) # 710 <printint>
     9c6:	aa39                	j	ae4 <vprintf+0x23a>
      } else if(c == 'p') {
     9c8:	fdc42783          	lw	a5,-36(s0)
     9cc:	0007871b          	sext.w	a4,a5
     9d0:	07000793          	li	a5,112
     9d4:	02f71263          	bne	a4,a5,9f8 <vprintf+0x14e>
        printptr(fd, va_arg(ap, uint64));
     9d8:	fb843783          	ld	a5,-72(s0)
     9dc:	00878713          	addi	a4,a5,8
     9e0:	fae43c23          	sd	a4,-72(s0)
     9e4:	6398                	ld	a4,0(a5)
     9e6:	fcc42783          	lw	a5,-52(s0)
     9ea:	85ba                	mv	a1,a4
     9ec:	853e                	mv	a0,a5
     9ee:	00000097          	auipc	ra,0x0
     9f2:	e30080e7          	jalr	-464(ra) # 81e <printptr>
     9f6:	a0fd                	j	ae4 <vprintf+0x23a>
      } else if(c == 's'){
     9f8:	fdc42783          	lw	a5,-36(s0)
     9fc:	0007871b          	sext.w	a4,a5
     a00:	07300793          	li	a5,115
     a04:	04f71c63          	bne	a4,a5,a5c <vprintf+0x1b2>
        s = va_arg(ap, char*);
     a08:	fb843783          	ld	a5,-72(s0)
     a0c:	00878713          	addi	a4,a5,8
     a10:	fae43c23          	sd	a4,-72(s0)
     a14:	639c                	ld	a5,0(a5)
     a16:	fef43423          	sd	a5,-24(s0)
        if(s == 0)
     a1a:	fe843783          	ld	a5,-24(s0)
     a1e:	eb8d                	bnez	a5,a50 <vprintf+0x1a6>
          s = "(null)";
     a20:	00001797          	auipc	a5,0x1
     a24:	57078793          	addi	a5,a5,1392 # 1f90 <schedule_rm+0x2e4>
     a28:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     a2c:	a015                	j	a50 <vprintf+0x1a6>
          putc(fd, *s);
     a2e:	fe843783          	ld	a5,-24(s0)
     a32:	0007c703          	lbu	a4,0(a5)
     a36:	fcc42783          	lw	a5,-52(s0)
     a3a:	85ba                	mv	a1,a4
     a3c:	853e                	mv	a0,a5
     a3e:	00000097          	auipc	ra,0x0
     a42:	c9c080e7          	jalr	-868(ra) # 6da <putc>
          s++;
     a46:	fe843783          	ld	a5,-24(s0)
     a4a:	0785                	addi	a5,a5,1
     a4c:	fef43423          	sd	a5,-24(s0)
        while(*s != 0){
     a50:	fe843783          	ld	a5,-24(s0)
     a54:	0007c783          	lbu	a5,0(a5)
     a58:	fbf9                	bnez	a5,a2e <vprintf+0x184>
     a5a:	a069                	j	ae4 <vprintf+0x23a>
        }
      } else if(c == 'c'){
     a5c:	fdc42783          	lw	a5,-36(s0)
     a60:	0007871b          	sext.w	a4,a5
     a64:	06300793          	li	a5,99
     a68:	02f71463          	bne	a4,a5,a90 <vprintf+0x1e6>
        putc(fd, va_arg(ap, uint));
     a6c:	fb843783          	ld	a5,-72(s0)
     a70:	00878713          	addi	a4,a5,8
     a74:	fae43c23          	sd	a4,-72(s0)
     a78:	439c                	lw	a5,0(a5)
     a7a:	0ff7f713          	andi	a4,a5,255
     a7e:	fcc42783          	lw	a5,-52(s0)
     a82:	85ba                	mv	a1,a4
     a84:	853e                	mv	a0,a5
     a86:	00000097          	auipc	ra,0x0
     a8a:	c54080e7          	jalr	-940(ra) # 6da <putc>
     a8e:	a899                	j	ae4 <vprintf+0x23a>
      } else if(c == '%'){
     a90:	fdc42783          	lw	a5,-36(s0)
     a94:	0007871b          	sext.w	a4,a5
     a98:	02500793          	li	a5,37
     a9c:	00f71f63          	bne	a4,a5,aba <vprintf+0x210>
        putc(fd, c);
     aa0:	fdc42783          	lw	a5,-36(s0)
     aa4:	0ff7f713          	andi	a4,a5,255
     aa8:	fcc42783          	lw	a5,-52(s0)
     aac:	85ba                	mv	a1,a4
     aae:	853e                	mv	a0,a5
     ab0:	00000097          	auipc	ra,0x0
     ab4:	c2a080e7          	jalr	-982(ra) # 6da <putc>
     ab8:	a035                	j	ae4 <vprintf+0x23a>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     aba:	fcc42783          	lw	a5,-52(s0)
     abe:	02500593          	li	a1,37
     ac2:	853e                	mv	a0,a5
     ac4:	00000097          	auipc	ra,0x0
     ac8:	c16080e7          	jalr	-1002(ra) # 6da <putc>
        putc(fd, c);
     acc:	fdc42783          	lw	a5,-36(s0)
     ad0:	0ff7f713          	andi	a4,a5,255
     ad4:	fcc42783          	lw	a5,-52(s0)
     ad8:	85ba                	mv	a1,a4
     ada:	853e                	mv	a0,a5
     adc:	00000097          	auipc	ra,0x0
     ae0:	bfe080e7          	jalr	-1026(ra) # 6da <putc>
      }
      state = 0;
     ae4:	fe042023          	sw	zero,-32(s0)
  for(i = 0; fmt[i]; i++){
     ae8:	fe442783          	lw	a5,-28(s0)
     aec:	2785                	addiw	a5,a5,1
     aee:	fef42223          	sw	a5,-28(s0)
     af2:	fe442783          	lw	a5,-28(s0)
     af6:	fc043703          	ld	a4,-64(s0)
     afa:	97ba                	add	a5,a5,a4
     afc:	0007c783          	lbu	a5,0(a5)
     b00:	dc0795e3          	bnez	a5,8ca <vprintf+0x20>
    }
  }
}
     b04:	0001                	nop
     b06:	0001                	nop
     b08:	60a6                	ld	ra,72(sp)
     b0a:	6406                	ld	s0,64(sp)
     b0c:	6161                	addi	sp,sp,80
     b0e:	8082                	ret

0000000000000b10 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     b10:	7159                	addi	sp,sp,-112
     b12:	fc06                	sd	ra,56(sp)
     b14:	f822                	sd	s0,48(sp)
     b16:	0080                	addi	s0,sp,64
     b18:	fcb43823          	sd	a1,-48(s0)
     b1c:	e010                	sd	a2,0(s0)
     b1e:	e414                	sd	a3,8(s0)
     b20:	e818                	sd	a4,16(s0)
     b22:	ec1c                	sd	a5,24(s0)
     b24:	03043023          	sd	a6,32(s0)
     b28:	03143423          	sd	a7,40(s0)
     b2c:	87aa                	mv	a5,a0
     b2e:	fcf42e23          	sw	a5,-36(s0)
  va_list ap;

  va_start(ap, fmt);
     b32:	03040793          	addi	a5,s0,48
     b36:	fcf43423          	sd	a5,-56(s0)
     b3a:	fc843783          	ld	a5,-56(s0)
     b3e:	fd078793          	addi	a5,a5,-48
     b42:	fef43423          	sd	a5,-24(s0)
  vprintf(fd, fmt, ap);
     b46:	fe843703          	ld	a4,-24(s0)
     b4a:	fdc42783          	lw	a5,-36(s0)
     b4e:	863a                	mv	a2,a4
     b50:	fd043583          	ld	a1,-48(s0)
     b54:	853e                	mv	a0,a5
     b56:	00000097          	auipc	ra,0x0
     b5a:	d54080e7          	jalr	-684(ra) # 8aa <vprintf>
}
     b5e:	0001                	nop
     b60:	70e2                	ld	ra,56(sp)
     b62:	7442                	ld	s0,48(sp)
     b64:	6165                	addi	sp,sp,112
     b66:	8082                	ret

0000000000000b68 <printf>:

void
printf(const char *fmt, ...)
{
     b68:	7159                	addi	sp,sp,-112
     b6a:	f406                	sd	ra,40(sp)
     b6c:	f022                	sd	s0,32(sp)
     b6e:	1800                	addi	s0,sp,48
     b70:	fca43c23          	sd	a0,-40(s0)
     b74:	e40c                	sd	a1,8(s0)
     b76:	e810                	sd	a2,16(s0)
     b78:	ec14                	sd	a3,24(s0)
     b7a:	f018                	sd	a4,32(s0)
     b7c:	f41c                	sd	a5,40(s0)
     b7e:	03043823          	sd	a6,48(s0)
     b82:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     b86:	04040793          	addi	a5,s0,64
     b8a:	fcf43823          	sd	a5,-48(s0)
     b8e:	fd043783          	ld	a5,-48(s0)
     b92:	fc878793          	addi	a5,a5,-56
     b96:	fef43423          	sd	a5,-24(s0)
  vprintf(1, fmt, ap);
     b9a:	fe843783          	ld	a5,-24(s0)
     b9e:	863e                	mv	a2,a5
     ba0:	fd843583          	ld	a1,-40(s0)
     ba4:	4505                	li	a0,1
     ba6:	00000097          	auipc	ra,0x0
     baa:	d04080e7          	jalr	-764(ra) # 8aa <vprintf>
}
     bae:	0001                	nop
     bb0:	70a2                	ld	ra,40(sp)
     bb2:	7402                	ld	s0,32(sp)
     bb4:	6165                	addi	sp,sp,112
     bb6:	8082                	ret

0000000000000bb8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     bb8:	7179                	addi	sp,sp,-48
     bba:	f422                	sd	s0,40(sp)
     bbc:	1800                	addi	s0,sp,48
     bbe:	fca43c23          	sd	a0,-40(s0)
  Header *bp, *p;

  bp = (Header*)ap - 1;
     bc2:	fd843783          	ld	a5,-40(s0)
     bc6:	17c1                	addi	a5,a5,-16
     bc8:	fef43023          	sd	a5,-32(s0)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     bcc:	00001797          	auipc	a5,0x1
     bd0:	55478793          	addi	a5,a5,1364 # 2120 <freep>
     bd4:	639c                	ld	a5,0(a5)
     bd6:	fef43423          	sd	a5,-24(s0)
     bda:	a815                	j	c0e <free+0x56>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     bdc:	fe843783          	ld	a5,-24(s0)
     be0:	639c                	ld	a5,0(a5)
     be2:	fe843703          	ld	a4,-24(s0)
     be6:	00f76f63          	bltu	a4,a5,c04 <free+0x4c>
     bea:	fe043703          	ld	a4,-32(s0)
     bee:	fe843783          	ld	a5,-24(s0)
     bf2:	02e7eb63          	bltu	a5,a4,c28 <free+0x70>
     bf6:	fe843783          	ld	a5,-24(s0)
     bfa:	639c                	ld	a5,0(a5)
     bfc:	fe043703          	ld	a4,-32(s0)
     c00:	02f76463          	bltu	a4,a5,c28 <free+0x70>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     c04:	fe843783          	ld	a5,-24(s0)
     c08:	639c                	ld	a5,0(a5)
     c0a:	fef43423          	sd	a5,-24(s0)
     c0e:	fe043703          	ld	a4,-32(s0)
     c12:	fe843783          	ld	a5,-24(s0)
     c16:	fce7f3e3          	bgeu	a5,a4,bdc <free+0x24>
     c1a:	fe843783          	ld	a5,-24(s0)
     c1e:	639c                	ld	a5,0(a5)
     c20:	fe043703          	ld	a4,-32(s0)
     c24:	faf77ce3          	bgeu	a4,a5,bdc <free+0x24>
      break;
  if(bp + bp->s.size == p->s.ptr){
     c28:	fe043783          	ld	a5,-32(s0)
     c2c:	479c                	lw	a5,8(a5)
     c2e:	1782                	slli	a5,a5,0x20
     c30:	9381                	srli	a5,a5,0x20
     c32:	0792                	slli	a5,a5,0x4
     c34:	fe043703          	ld	a4,-32(s0)
     c38:	973e                	add	a4,a4,a5
     c3a:	fe843783          	ld	a5,-24(s0)
     c3e:	639c                	ld	a5,0(a5)
     c40:	02f71763          	bne	a4,a5,c6e <free+0xb6>
    bp->s.size += p->s.ptr->s.size;
     c44:	fe043783          	ld	a5,-32(s0)
     c48:	4798                	lw	a4,8(a5)
     c4a:	fe843783          	ld	a5,-24(s0)
     c4e:	639c                	ld	a5,0(a5)
     c50:	479c                	lw	a5,8(a5)
     c52:	9fb9                	addw	a5,a5,a4
     c54:	0007871b          	sext.w	a4,a5
     c58:	fe043783          	ld	a5,-32(s0)
     c5c:	c798                	sw	a4,8(a5)
    bp->s.ptr = p->s.ptr->s.ptr;
     c5e:	fe843783          	ld	a5,-24(s0)
     c62:	639c                	ld	a5,0(a5)
     c64:	6398                	ld	a4,0(a5)
     c66:	fe043783          	ld	a5,-32(s0)
     c6a:	e398                	sd	a4,0(a5)
     c6c:	a039                	j	c7a <free+0xc2>
  } else
    bp->s.ptr = p->s.ptr;
     c6e:	fe843783          	ld	a5,-24(s0)
     c72:	6398                	ld	a4,0(a5)
     c74:	fe043783          	ld	a5,-32(s0)
     c78:	e398                	sd	a4,0(a5)
  if(p + p->s.size == bp){
     c7a:	fe843783          	ld	a5,-24(s0)
     c7e:	479c                	lw	a5,8(a5)
     c80:	1782                	slli	a5,a5,0x20
     c82:	9381                	srli	a5,a5,0x20
     c84:	0792                	slli	a5,a5,0x4
     c86:	fe843703          	ld	a4,-24(s0)
     c8a:	97ba                	add	a5,a5,a4
     c8c:	fe043703          	ld	a4,-32(s0)
     c90:	02f71563          	bne	a4,a5,cba <free+0x102>
    p->s.size += bp->s.size;
     c94:	fe843783          	ld	a5,-24(s0)
     c98:	4798                	lw	a4,8(a5)
     c9a:	fe043783          	ld	a5,-32(s0)
     c9e:	479c                	lw	a5,8(a5)
     ca0:	9fb9                	addw	a5,a5,a4
     ca2:	0007871b          	sext.w	a4,a5
     ca6:	fe843783          	ld	a5,-24(s0)
     caa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     cac:	fe043783          	ld	a5,-32(s0)
     cb0:	6398                	ld	a4,0(a5)
     cb2:	fe843783          	ld	a5,-24(s0)
     cb6:	e398                	sd	a4,0(a5)
     cb8:	a031                	j	cc4 <free+0x10c>
  } else
    p->s.ptr = bp;
     cba:	fe843783          	ld	a5,-24(s0)
     cbe:	fe043703          	ld	a4,-32(s0)
     cc2:	e398                	sd	a4,0(a5)
  freep = p;
     cc4:	00001797          	auipc	a5,0x1
     cc8:	45c78793          	addi	a5,a5,1116 # 2120 <freep>
     ccc:	fe843703          	ld	a4,-24(s0)
     cd0:	e398                	sd	a4,0(a5)
}
     cd2:	0001                	nop
     cd4:	7422                	ld	s0,40(sp)
     cd6:	6145                	addi	sp,sp,48
     cd8:	8082                	ret

0000000000000cda <morecore>:

static Header*
morecore(uint nu)
{
     cda:	7179                	addi	sp,sp,-48
     cdc:	f406                	sd	ra,40(sp)
     cde:	f022                	sd	s0,32(sp)
     ce0:	1800                	addi	s0,sp,48
     ce2:	87aa                	mv	a5,a0
     ce4:	fcf42e23          	sw	a5,-36(s0)
  char *p;
  Header *hp;

  if(nu < 4096)
     ce8:	fdc42783          	lw	a5,-36(s0)
     cec:	0007871b          	sext.w	a4,a5
     cf0:	6785                	lui	a5,0x1
     cf2:	00f77563          	bgeu	a4,a5,cfc <morecore+0x22>
    nu = 4096;
     cf6:	6785                	lui	a5,0x1
     cf8:	fcf42e23          	sw	a5,-36(s0)
  p = sbrk(nu * sizeof(Header));
     cfc:	fdc42783          	lw	a5,-36(s0)
     d00:	0047979b          	slliw	a5,a5,0x4
     d04:	2781                	sext.w	a5,a5
     d06:	2781                	sext.w	a5,a5
     d08:	853e                	mv	a0,a5
     d0a:	00000097          	auipc	ra,0x0
     d0e:	9a0080e7          	jalr	-1632(ra) # 6aa <sbrk>
     d12:	fea43423          	sd	a0,-24(s0)
  if(p == (char*)-1)
     d16:	fe843703          	ld	a4,-24(s0)
     d1a:	57fd                	li	a5,-1
     d1c:	00f71463          	bne	a4,a5,d24 <morecore+0x4a>
    return 0;
     d20:	4781                	li	a5,0
     d22:	a03d                	j	d50 <morecore+0x76>
  hp = (Header*)p;
     d24:	fe843783          	ld	a5,-24(s0)
     d28:	fef43023          	sd	a5,-32(s0)
  hp->s.size = nu;
     d2c:	fe043783          	ld	a5,-32(s0)
     d30:	fdc42703          	lw	a4,-36(s0)
     d34:	c798                	sw	a4,8(a5)
  free((void*)(hp + 1));
     d36:	fe043783          	ld	a5,-32(s0)
     d3a:	07c1                	addi	a5,a5,16
     d3c:	853e                	mv	a0,a5
     d3e:	00000097          	auipc	ra,0x0
     d42:	e7a080e7          	jalr	-390(ra) # bb8 <free>
  return freep;
     d46:	00001797          	auipc	a5,0x1
     d4a:	3da78793          	addi	a5,a5,986 # 2120 <freep>
     d4e:	639c                	ld	a5,0(a5)
}
     d50:	853e                	mv	a0,a5
     d52:	70a2                	ld	ra,40(sp)
     d54:	7402                	ld	s0,32(sp)
     d56:	6145                	addi	sp,sp,48
     d58:	8082                	ret

0000000000000d5a <malloc>:

void*
malloc(uint nbytes)
{
     d5a:	7139                	addi	sp,sp,-64
     d5c:	fc06                	sd	ra,56(sp)
     d5e:	f822                	sd	s0,48(sp)
     d60:	0080                	addi	s0,sp,64
     d62:	87aa                	mv	a5,a0
     d64:	fcf42623          	sw	a5,-52(s0)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     d68:	fcc46783          	lwu	a5,-52(s0)
     d6c:	07bd                	addi	a5,a5,15
     d6e:	8391                	srli	a5,a5,0x4
     d70:	2781                	sext.w	a5,a5
     d72:	2785                	addiw	a5,a5,1
     d74:	fcf42e23          	sw	a5,-36(s0)
  if((prevp = freep) == 0){
     d78:	00001797          	auipc	a5,0x1
     d7c:	3a878793          	addi	a5,a5,936 # 2120 <freep>
     d80:	639c                	ld	a5,0(a5)
     d82:	fef43023          	sd	a5,-32(s0)
     d86:	fe043783          	ld	a5,-32(s0)
     d8a:	ef95                	bnez	a5,dc6 <malloc+0x6c>
    base.s.ptr = freep = prevp = &base;
     d8c:	00001797          	auipc	a5,0x1
     d90:	38478793          	addi	a5,a5,900 # 2110 <base>
     d94:	fef43023          	sd	a5,-32(s0)
     d98:	00001797          	auipc	a5,0x1
     d9c:	38878793          	addi	a5,a5,904 # 2120 <freep>
     da0:	fe043703          	ld	a4,-32(s0)
     da4:	e398                	sd	a4,0(a5)
     da6:	00001797          	auipc	a5,0x1
     daa:	37a78793          	addi	a5,a5,890 # 2120 <freep>
     dae:	6398                	ld	a4,0(a5)
     db0:	00001797          	auipc	a5,0x1
     db4:	36078793          	addi	a5,a5,864 # 2110 <base>
     db8:	e398                	sd	a4,0(a5)
    base.s.size = 0;
     dba:	00001797          	auipc	a5,0x1
     dbe:	35678793          	addi	a5,a5,854 # 2110 <base>
     dc2:	0007a423          	sw	zero,8(a5)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     dc6:	fe043783          	ld	a5,-32(s0)
     dca:	639c                	ld	a5,0(a5)
     dcc:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
     dd0:	fe843783          	ld	a5,-24(s0)
     dd4:	4798                	lw	a4,8(a5)
     dd6:	fdc42783          	lw	a5,-36(s0)
     dda:	2781                	sext.w	a5,a5
     ddc:	06f76863          	bltu	a4,a5,e4c <malloc+0xf2>
      if(p->s.size == nunits)
     de0:	fe843783          	ld	a5,-24(s0)
     de4:	4798                	lw	a4,8(a5)
     de6:	fdc42783          	lw	a5,-36(s0)
     dea:	2781                	sext.w	a5,a5
     dec:	00e79963          	bne	a5,a4,dfe <malloc+0xa4>
        prevp->s.ptr = p->s.ptr;
     df0:	fe843783          	ld	a5,-24(s0)
     df4:	6398                	ld	a4,0(a5)
     df6:	fe043783          	ld	a5,-32(s0)
     dfa:	e398                	sd	a4,0(a5)
     dfc:	a82d                	j	e36 <malloc+0xdc>
      else {
        p->s.size -= nunits;
     dfe:	fe843783          	ld	a5,-24(s0)
     e02:	4798                	lw	a4,8(a5)
     e04:	fdc42783          	lw	a5,-36(s0)
     e08:	40f707bb          	subw	a5,a4,a5
     e0c:	0007871b          	sext.w	a4,a5
     e10:	fe843783          	ld	a5,-24(s0)
     e14:	c798                	sw	a4,8(a5)
        p += p->s.size;
     e16:	fe843783          	ld	a5,-24(s0)
     e1a:	479c                	lw	a5,8(a5)
     e1c:	1782                	slli	a5,a5,0x20
     e1e:	9381                	srli	a5,a5,0x20
     e20:	0792                	slli	a5,a5,0x4
     e22:	fe843703          	ld	a4,-24(s0)
     e26:	97ba                	add	a5,a5,a4
     e28:	fef43423          	sd	a5,-24(s0)
        p->s.size = nunits;
     e2c:	fe843783          	ld	a5,-24(s0)
     e30:	fdc42703          	lw	a4,-36(s0)
     e34:	c798                	sw	a4,8(a5)
      }
      freep = prevp;
     e36:	00001797          	auipc	a5,0x1
     e3a:	2ea78793          	addi	a5,a5,746 # 2120 <freep>
     e3e:	fe043703          	ld	a4,-32(s0)
     e42:	e398                	sd	a4,0(a5)
      return (void*)(p + 1);
     e44:	fe843783          	ld	a5,-24(s0)
     e48:	07c1                	addi	a5,a5,16
     e4a:	a091                	j	e8e <malloc+0x134>
    }
    if(p == freep)
     e4c:	00001797          	auipc	a5,0x1
     e50:	2d478793          	addi	a5,a5,724 # 2120 <freep>
     e54:	639c                	ld	a5,0(a5)
     e56:	fe843703          	ld	a4,-24(s0)
     e5a:	02f71063          	bne	a4,a5,e7a <malloc+0x120>
      if((p = morecore(nunits)) == 0)
     e5e:	fdc42783          	lw	a5,-36(s0)
     e62:	853e                	mv	a0,a5
     e64:	00000097          	auipc	ra,0x0
     e68:	e76080e7          	jalr	-394(ra) # cda <morecore>
     e6c:	fea43423          	sd	a0,-24(s0)
     e70:	fe843783          	ld	a5,-24(s0)
     e74:	e399                	bnez	a5,e7a <malloc+0x120>
        return 0;
     e76:	4781                	li	a5,0
     e78:	a819                	j	e8e <malloc+0x134>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     e7a:	fe843783          	ld	a5,-24(s0)
     e7e:	fef43023          	sd	a5,-32(s0)
     e82:	fe843783          	ld	a5,-24(s0)
     e86:	639c                	ld	a5,0(a5)
     e88:	fef43423          	sd	a5,-24(s0)
    if(p->s.size >= nunits){
     e8c:	b791                	j	dd0 <malloc+0x76>
  }
}
     e8e:	853e                	mv	a0,a5
     e90:	70e2                	ld	ra,56(sp)
     e92:	7442                	ld	s0,48(sp)
     e94:	6121                	addi	sp,sp,64
     e96:	8082                	ret

0000000000000e98 <setjmp>:
     e98:	e100                	sd	s0,0(a0)
     e9a:	e504                	sd	s1,8(a0)
     e9c:	01253823          	sd	s2,16(a0)
     ea0:	01353c23          	sd	s3,24(a0)
     ea4:	03453023          	sd	s4,32(a0)
     ea8:	03553423          	sd	s5,40(a0)
     eac:	03653823          	sd	s6,48(a0)
     eb0:	03753c23          	sd	s7,56(a0)
     eb4:	05853023          	sd	s8,64(a0)
     eb8:	05953423          	sd	s9,72(a0)
     ebc:	05a53823          	sd	s10,80(a0)
     ec0:	05b53c23          	sd	s11,88(a0)
     ec4:	06153023          	sd	ra,96(a0)
     ec8:	06253423          	sd	sp,104(a0)
     ecc:	4501                	li	a0,0
     ece:	8082                	ret

0000000000000ed0 <longjmp>:
     ed0:	6100                	ld	s0,0(a0)
     ed2:	6504                	ld	s1,8(a0)
     ed4:	01053903          	ld	s2,16(a0)
     ed8:	01853983          	ld	s3,24(a0)
     edc:	02053a03          	ld	s4,32(a0)
     ee0:	02853a83          	ld	s5,40(a0)
     ee4:	03053b03          	ld	s6,48(a0)
     ee8:	03853b83          	ld	s7,56(a0)
     eec:	04053c03          	ld	s8,64(a0)
     ef0:	04853c83          	ld	s9,72(a0)
     ef4:	05053d03          	ld	s10,80(a0)
     ef8:	05853d83          	ld	s11,88(a0)
     efc:	06053083          	ld	ra,96(a0)
     f00:	06853103          	ld	sp,104(a0)
     f04:	c199                	beqz	a1,f0a <longjmp_1>
     f06:	852e                	mv	a0,a1
     f08:	8082                	ret

0000000000000f0a <longjmp_1>:
     f0a:	4505                	li	a0,1
     f0c:	8082                	ret

0000000000000f0e <__list_add>:
 * the prev/next entries already!
 */
static inline void __list_add(struct list_head *new_entry,
                              struct list_head *prev,
                              struct list_head *next)
{
     f0e:	7179                	addi	sp,sp,-48
     f10:	f422                	sd	s0,40(sp)
     f12:	1800                	addi	s0,sp,48
     f14:	fea43423          	sd	a0,-24(s0)
     f18:	feb43023          	sd	a1,-32(s0)
     f1c:	fcc43c23          	sd	a2,-40(s0)
    next->prev = new_entry;
     f20:	fd843783          	ld	a5,-40(s0)
     f24:	fe843703          	ld	a4,-24(s0)
     f28:	e798                	sd	a4,8(a5)
    new_entry->next = next;
     f2a:	fe843783          	ld	a5,-24(s0)
     f2e:	fd843703          	ld	a4,-40(s0)
     f32:	e398                	sd	a4,0(a5)
    new_entry->prev = prev;
     f34:	fe843783          	ld	a5,-24(s0)
     f38:	fe043703          	ld	a4,-32(s0)
     f3c:	e798                	sd	a4,8(a5)
    prev->next = new_entry;
     f3e:	fe043783          	ld	a5,-32(s0)
     f42:	fe843703          	ld	a4,-24(s0)
     f46:	e398                	sd	a4,0(a5)
}
     f48:	0001                	nop
     f4a:	7422                	ld	s0,40(sp)
     f4c:	6145                	addi	sp,sp,48
     f4e:	8082                	ret

0000000000000f50 <list_add_tail>:
 *
 * Insert a new entry before the specified head.
 * This is useful for implementing queues.
 */
static inline void list_add_tail(struct list_head *new_entry, struct list_head *head)
{
     f50:	1101                	addi	sp,sp,-32
     f52:	ec06                	sd	ra,24(sp)
     f54:	e822                	sd	s0,16(sp)
     f56:	1000                	addi	s0,sp,32
     f58:	fea43423          	sd	a0,-24(s0)
     f5c:	feb43023          	sd	a1,-32(s0)
    __list_add(new_entry, head->prev, head);
     f60:	fe043783          	ld	a5,-32(s0)
     f64:	679c                	ld	a5,8(a5)
     f66:	fe043603          	ld	a2,-32(s0)
     f6a:	85be                	mv	a1,a5
     f6c:	fe843503          	ld	a0,-24(s0)
     f70:	00000097          	auipc	ra,0x0
     f74:	f9e080e7          	jalr	-98(ra) # f0e <__list_add>
}
     f78:	0001                	nop
     f7a:	60e2                	ld	ra,24(sp)
     f7c:	6442                	ld	s0,16(sp)
     f7e:	6105                	addi	sp,sp,32
     f80:	8082                	ret

0000000000000f82 <__list_del>:
 *
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 */
static inline void __list_del(struct list_head *prev, struct list_head *next)
{
     f82:	1101                	addi	sp,sp,-32
     f84:	ec22                	sd	s0,24(sp)
     f86:	1000                	addi	s0,sp,32
     f88:	fea43423          	sd	a0,-24(s0)
     f8c:	feb43023          	sd	a1,-32(s0)
    next->prev = prev;
     f90:	fe043783          	ld	a5,-32(s0)
     f94:	fe843703          	ld	a4,-24(s0)
     f98:	e798                	sd	a4,8(a5)
    prev->next = next;
     f9a:	fe843783          	ld	a5,-24(s0)
     f9e:	fe043703          	ld	a4,-32(s0)
     fa2:	e398                	sd	a4,0(a5)
}
     fa4:	0001                	nop
     fa6:	6462                	ld	s0,24(sp)
     fa8:	6105                	addi	sp,sp,32
     faa:	8082                	ret

0000000000000fac <list_del>:
 * @entry: the element to delete from the list.
 * Note: list_empty on entry does not return true after this, the entry is
 * in an undefined state.
 */
static inline void list_del(struct list_head *entry)
{
     fac:	1101                	addi	sp,sp,-32
     fae:	ec06                	sd	ra,24(sp)
     fb0:	e822                	sd	s0,16(sp)
     fb2:	1000                	addi	s0,sp,32
     fb4:	fea43423          	sd	a0,-24(s0)
    __list_del(entry->prev, entry->next);
     fb8:	fe843783          	ld	a5,-24(s0)
     fbc:	6798                	ld	a4,8(a5)
     fbe:	fe843783          	ld	a5,-24(s0)
     fc2:	639c                	ld	a5,0(a5)
     fc4:	85be                	mv	a1,a5
     fc6:	853a                	mv	a0,a4
     fc8:	00000097          	auipc	ra,0x0
     fcc:	fba080e7          	jalr	-70(ra) # f82 <__list_del>
    entry->next = LIST_POISON1;
     fd0:	fe843783          	ld	a5,-24(s0)
     fd4:	00100737          	lui	a4,0x100
     fd8:	10070713          	addi	a4,a4,256 # 100100 <__global_pointer$+0xfd840>
     fdc:	e398                	sd	a4,0(a5)
    entry->prev = LIST_POISON2;
     fde:	fe843783          	ld	a5,-24(s0)
     fe2:	00200737          	lui	a4,0x200
     fe6:	20070713          	addi	a4,a4,512 # 200200 <__global_pointer$+0x1fd940>
     fea:	e798                	sd	a4,8(a5)
}
     fec:	0001                	nop
     fee:	60e2                	ld	ra,24(sp)
     ff0:	6442                	ld	s0,16(sp)
     ff2:	6105                	addi	sp,sp,32
     ff4:	8082                	ret

0000000000000ff6 <list_empty>:
/**
 * list_empty - tests whether a list is empty
 * @head: the list to test.
 */
static inline int list_empty(const struct list_head *head)
{
     ff6:	1101                	addi	sp,sp,-32
     ff8:	ec22                	sd	s0,24(sp)
     ffa:	1000                	addi	s0,sp,32
     ffc:	fea43423          	sd	a0,-24(s0)
    return head->next == head;
    1000:	fe843783          	ld	a5,-24(s0)
    1004:	639c                	ld	a5,0(a5)
    1006:	fe843703          	ld	a4,-24(s0)
    100a:	40f707b3          	sub	a5,a4,a5
    100e:	0017b793          	seqz	a5,a5
    1012:	0ff7f793          	andi	a5,a5,255
    1016:	2781                	sext.w	a5,a5
}
    1018:	853e                	mv	a0,a5
    101a:	6462                	ld	s0,24(sp)
    101c:	6105                	addi	sp,sp,32
    101e:	8082                	ret

0000000000001020 <thread_create>:

void __dispatch(void);
void __schedule(void);

struct thread *thread_create(void (*f)(void *), void *arg, int processing_time, int period, int n)
{
    1020:	715d                	addi	sp,sp,-80
    1022:	e486                	sd	ra,72(sp)
    1024:	e0a2                	sd	s0,64(sp)
    1026:	0880                	addi	s0,sp,80
    1028:	fca43423          	sd	a0,-56(s0)
    102c:	fcb43023          	sd	a1,-64(s0)
    1030:	87b2                	mv	a5,a2
    1032:	faf42e23          	sw	a5,-68(s0)
    1036:	87b6                	mv	a5,a3
    1038:	faf42c23          	sw	a5,-72(s0)
    103c:	87ba                	mv	a5,a4
    103e:	faf42a23          	sw	a5,-76(s0)
    static int _id = 1;
    struct thread *t = (struct thread *)malloc(sizeof(struct thread));
    1042:	05800513          	li	a0,88
    1046:	00000097          	auipc	ra,0x0
    104a:	d14080e7          	jalr	-748(ra) # d5a <malloc>
    104e:	fea43423          	sd	a0,-24(s0)
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long)malloc(sizeof(unsigned long) * 0x200);
    1052:	6505                	lui	a0,0x1
    1054:	00000097          	auipc	ra,0x0
    1058:	d06080e7          	jalr	-762(ra) # d5a <malloc>
    105c:	87aa                	mv	a5,a0
    105e:	fef43023          	sd	a5,-32(s0)
    new_stack_p = new_stack + 0x200 * 8 - 0x2 * 8;
    1062:	fe043703          	ld	a4,-32(s0)
    1066:	6785                	lui	a5,0x1
    1068:	17c1                	addi	a5,a5,-16
    106a:	97ba                	add	a5,a5,a4
    106c:	fcf43c23          	sd	a5,-40(s0)
    t->fp = f;
    1070:	fe843783          	ld	a5,-24(s0)
    1074:	fc843703          	ld	a4,-56(s0)
    1078:	e398                	sd	a4,0(a5)
    t->arg = arg;
    107a:	fe843783          	ld	a5,-24(s0)
    107e:	fc043703          	ld	a4,-64(s0)
    1082:	e798                	sd	a4,8(a5)
    t->ID = _id++;
    1084:	00001797          	auipc	a5,0x1
    1088:	08078793          	addi	a5,a5,128 # 2104 <_id.0>
    108c:	439c                	lw	a5,0(a5)
    108e:	0017871b          	addiw	a4,a5,1
    1092:	0007069b          	sext.w	a3,a4
    1096:	00001717          	auipc	a4,0x1
    109a:	06e70713          	addi	a4,a4,110 # 2104 <_id.0>
    109e:	c314                	sw	a3,0(a4)
    10a0:	fe843703          	ld	a4,-24(s0)
    10a4:	d31c                	sw	a5,32(a4)
    t->buf_set = 0;
    10a6:	fe843783          	ld	a5,-24(s0)
    10aa:	0207ac23          	sw	zero,56(a5)
    t->stack = (void *)new_stack;
    10ae:	fe043703          	ld	a4,-32(s0)
    10b2:	fe843783          	ld	a5,-24(s0)
    10b6:	eb98                	sd	a4,16(a5)
    t->stack_p = (void *)new_stack_p;
    10b8:	fd843703          	ld	a4,-40(s0)
    10bc:	fe843783          	ld	a5,-24(s0)
    10c0:	ef98                	sd	a4,24(a5)

    t->processing_time = processing_time;
    10c2:	fe843783          	ld	a5,-24(s0)
    10c6:	fbc42703          	lw	a4,-68(s0)
    10ca:	c3b8                	sw	a4,64(a5)
    t->period = period;
    10cc:	fe843783          	ld	a5,-24(s0)
    10d0:	fb842703          	lw	a4,-72(s0)
    10d4:	c3f8                	sw	a4,68(a5)
    t->n = n;
    10d6:	fe843783          	ld	a5,-24(s0)
    10da:	fb442703          	lw	a4,-76(s0)
    10de:	c7b8                	sw	a4,72(a5)
    t->remaining_time = 0;
    10e0:	fe843783          	ld	a5,-24(s0)
    10e4:	0407a623          	sw	zero,76(a5)
    t->current_deadline = 0;
    10e8:	fe843783          	ld	a5,-24(s0)
    10ec:	0407a823          	sw	zero,80(a5)
    return t;
    10f0:	fe843783          	ld	a5,-24(s0)
}
    10f4:	853e                	mv	a0,a5
    10f6:	60a6                	ld	ra,72(sp)
    10f8:	6406                	ld	s0,64(sp)
    10fa:	6161                	addi	sp,sp,80
    10fc:	8082                	ret

00000000000010fe <thread_add_at>:

void thread_add_at(struct thread *t, int arrival_time)
{
    10fe:	7179                	addi	sp,sp,-48
    1100:	f406                	sd	ra,40(sp)
    1102:	f022                	sd	s0,32(sp)
    1104:	1800                	addi	s0,sp,48
    1106:	fca43c23          	sd	a0,-40(s0)
    110a:	87ae                	mv	a5,a1
    110c:	fcf42a23          	sw	a5,-44(s0)
    struct release_queue_entry *new_entry = (struct release_queue_entry *)malloc(sizeof(struct release_queue_entry));
    1110:	02000513          	li	a0,32
    1114:	00000097          	auipc	ra,0x0
    1118:	c46080e7          	jalr	-954(ra) # d5a <malloc>
    111c:	fea43423          	sd	a0,-24(s0)
    new_entry->thrd = t;
    1120:	fe843783          	ld	a5,-24(s0)
    1124:	fd843703          	ld	a4,-40(s0)
    1128:	e398                	sd	a4,0(a5)
    new_entry->release_time = arrival_time;
    112a:	fe843783          	ld	a5,-24(s0)
    112e:	fd442703          	lw	a4,-44(s0)
    1132:	cf98                	sw	a4,24(a5)
    t->current_deadline = arrival_time;
    1134:	fd843783          	ld	a5,-40(s0)
    1138:	fd442703          	lw	a4,-44(s0)
    113c:	cbb8                	sw	a4,80(a5)
    list_add_tail(&new_entry->thread_list, &release_queue);
    113e:	fe843783          	ld	a5,-24(s0)
    1142:	07a1                	addi	a5,a5,8
    1144:	00001597          	auipc	a1,0x1
    1148:	fa458593          	addi	a1,a1,-92 # 20e8 <release_queue>
    114c:	853e                	mv	a0,a5
    114e:	00000097          	auipc	ra,0x0
    1152:	e02080e7          	jalr	-510(ra) # f50 <list_add_tail>
}
    1156:	0001                	nop
    1158:	70a2                	ld	ra,40(sp)
    115a:	7402                	ld	s0,32(sp)
    115c:	6145                	addi	sp,sp,48
    115e:	8082                	ret

0000000000001160 <__release>:

void __release()
{
    1160:	7139                	addi	sp,sp,-64
    1162:	fc06                	sd	ra,56(sp)
    1164:	f822                	sd	s0,48(sp)
    1166:	0080                	addi	s0,sp,64
    struct release_queue_entry *cur, *nxt;
    list_for_each_entry_safe(cur, nxt, &release_queue, thread_list) {
    1168:	00001797          	auipc	a5,0x1
    116c:	f8078793          	addi	a5,a5,-128 # 20e8 <release_queue>
    1170:	639c                	ld	a5,0(a5)
    1172:	fcf43c23          	sd	a5,-40(s0)
    1176:	fd843783          	ld	a5,-40(s0)
    117a:	17e1                	addi	a5,a5,-8
    117c:	fef43423          	sd	a5,-24(s0)
    1180:	fe843783          	ld	a5,-24(s0)
    1184:	679c                	ld	a5,8(a5)
    1186:	fcf43823          	sd	a5,-48(s0)
    118a:	fd043783          	ld	a5,-48(s0)
    118e:	17e1                	addi	a5,a5,-8
    1190:	fef43023          	sd	a5,-32(s0)
    1194:	a851                	j	1228 <__release+0xc8>
        if (threading_system_time >= cur->release_time) {
    1196:	fe843783          	ld	a5,-24(s0)
    119a:	4f98                	lw	a4,24(a5)
    119c:	00001797          	auipc	a5,0x1
    11a0:	f9478793          	addi	a5,a5,-108 # 2130 <threading_system_time>
    11a4:	439c                	lw	a5,0(a5)
    11a6:	06e7c363          	blt	a5,a4,120c <__release+0xac>
            cur->thrd->remaining_time = cur->thrd->processing_time;
    11aa:	fe843783          	ld	a5,-24(s0)
    11ae:	6398                	ld	a4,0(a5)
    11b0:	fe843783          	ld	a5,-24(s0)
    11b4:	639c                	ld	a5,0(a5)
    11b6:	4338                	lw	a4,64(a4)
    11b8:	c7f8                	sw	a4,76(a5)
            cur->thrd->current_deadline = cur->release_time + cur->thrd->period;
    11ba:	fe843783          	ld	a5,-24(s0)
    11be:	4f94                	lw	a3,24(a5)
    11c0:	fe843783          	ld	a5,-24(s0)
    11c4:	639c                	ld	a5,0(a5)
    11c6:	43f8                	lw	a4,68(a5)
    11c8:	fe843783          	ld	a5,-24(s0)
    11cc:	639c                	ld	a5,0(a5)
    11ce:	9f35                	addw	a4,a4,a3
    11d0:	2701                	sext.w	a4,a4
    11d2:	cbb8                	sw	a4,80(a5)
            list_add_tail(&cur->thrd->thread_list, &run_queue);
    11d4:	fe843783          	ld	a5,-24(s0)
    11d8:	639c                	ld	a5,0(a5)
    11da:	02878793          	addi	a5,a5,40
    11de:	00001597          	auipc	a1,0x1
    11e2:	efa58593          	addi	a1,a1,-262 # 20d8 <run_queue>
    11e6:	853e                	mv	a0,a5
    11e8:	00000097          	auipc	ra,0x0
    11ec:	d68080e7          	jalr	-664(ra) # f50 <list_add_tail>
            list_del(&cur->thread_list);
    11f0:	fe843783          	ld	a5,-24(s0)
    11f4:	07a1                	addi	a5,a5,8
    11f6:	853e                	mv	a0,a5
    11f8:	00000097          	auipc	ra,0x0
    11fc:	db4080e7          	jalr	-588(ra) # fac <list_del>
            free(cur);
    1200:	fe843503          	ld	a0,-24(s0)
    1204:	00000097          	auipc	ra,0x0
    1208:	9b4080e7          	jalr	-1612(ra) # bb8 <free>
    list_for_each_entry_safe(cur, nxt, &release_queue, thread_list) {
    120c:	fe043783          	ld	a5,-32(s0)
    1210:	fef43423          	sd	a5,-24(s0)
    1214:	fe043783          	ld	a5,-32(s0)
    1218:	679c                	ld	a5,8(a5)
    121a:	fcf43423          	sd	a5,-56(s0)
    121e:	fc843783          	ld	a5,-56(s0)
    1222:	17e1                	addi	a5,a5,-8
    1224:	fef43023          	sd	a5,-32(s0)
    1228:	fe843783          	ld	a5,-24(s0)
    122c:	00878713          	addi	a4,a5,8
    1230:	00001797          	auipc	a5,0x1
    1234:	eb878793          	addi	a5,a5,-328 # 20e8 <release_queue>
    1238:	f4f71fe3          	bne	a4,a5,1196 <__release+0x36>
        }
    }
}
    123c:	0001                	nop
    123e:	0001                	nop
    1240:	70e2                	ld	ra,56(sp)
    1242:	7442                	ld	s0,48(sp)
    1244:	6121                	addi	sp,sp,64
    1246:	8082                	ret

0000000000001248 <__thread_exit>:

void __thread_exit(struct thread *to_remove)
{
    1248:	1101                	addi	sp,sp,-32
    124a:	ec06                	sd	ra,24(sp)
    124c:	e822                	sd	s0,16(sp)
    124e:	1000                	addi	s0,sp,32
    1250:	fea43423          	sd	a0,-24(s0)
    current = to_remove->thread_list.prev;
    1254:	fe843783          	ld	a5,-24(s0)
    1258:	7b98                	ld	a4,48(a5)
    125a:	00001797          	auipc	a5,0x1
    125e:	ece78793          	addi	a5,a5,-306 # 2128 <current>
    1262:	e398                	sd	a4,0(a5)
    list_del(&to_remove->thread_list);
    1264:	fe843783          	ld	a5,-24(s0)
    1268:	02878793          	addi	a5,a5,40
    126c:	853e                	mv	a0,a5
    126e:	00000097          	auipc	ra,0x0
    1272:	d3e080e7          	jalr	-706(ra) # fac <list_del>

    free(to_remove->stack);
    1276:	fe843783          	ld	a5,-24(s0)
    127a:	6b9c                	ld	a5,16(a5)
    127c:	853e                	mv	a0,a5
    127e:	00000097          	auipc	ra,0x0
    1282:	93a080e7          	jalr	-1734(ra) # bb8 <free>
    free(to_remove);
    1286:	fe843503          	ld	a0,-24(s0)
    128a:	00000097          	auipc	ra,0x0
    128e:	92e080e7          	jalr	-1746(ra) # bb8 <free>

    __schedule();
    1292:	00000097          	auipc	ra,0x0
    1296:	446080e7          	jalr	1094(ra) # 16d8 <__schedule>
    __dispatch();
    129a:	00000097          	auipc	ra,0x0
    129e:	2b6080e7          	jalr	694(ra) # 1550 <__dispatch>
    thrdresume(main_thrd_id);
    12a2:	00001797          	auipc	a5,0x1
    12a6:	e5e78793          	addi	a5,a5,-418 # 2100 <main_thrd_id>
    12aa:	439c                	lw	a5,0(a5)
    12ac:	853e                	mv	a0,a5
    12ae:	fffff097          	auipc	ra,0xfffff
    12b2:	41c080e7          	jalr	1052(ra) # 6ca <thrdresume>
}
    12b6:	0001                	nop
    12b8:	60e2                	ld	ra,24(sp)
    12ba:	6442                	ld	s0,16(sp)
    12bc:	6105                	addi	sp,sp,32
    12be:	8082                	ret

00000000000012c0 <thread_exit>:

void thread_exit(void)
{
    12c0:	7179                	addi	sp,sp,-48
    12c2:	f406                	sd	ra,40(sp)
    12c4:	f022                	sd	s0,32(sp)
    12c6:	1800                	addi	s0,sp,48
    if (current == &run_queue) {
    12c8:	00001797          	auipc	a5,0x1
    12cc:	e6078793          	addi	a5,a5,-416 # 2128 <current>
    12d0:	6398                	ld	a4,0(a5)
    12d2:	00001797          	auipc	a5,0x1
    12d6:	e0678793          	addi	a5,a5,-506 # 20d8 <run_queue>
    12da:	02f71063          	bne	a4,a5,12fa <thread_exit+0x3a>
        fprintf(2, "[FATAL] thread_exit is called on a nonexistent thread\n");
    12de:	00001597          	auipc	a1,0x1
    12e2:	cba58593          	addi	a1,a1,-838 # 1f98 <schedule_rm+0x2ec>
    12e6:	4509                	li	a0,2
    12e8:	00000097          	auipc	ra,0x0
    12ec:	828080e7          	jalr	-2008(ra) # b10 <fprintf>
        exit(1);
    12f0:	4505                	li	a0,1
    12f2:	fffff097          	auipc	ra,0xfffff
    12f6:	330080e7          	jalr	816(ra) # 622 <exit>
    }

    struct thread *to_remove = list_entry(current, struct thread, thread_list);
    12fa:	00001797          	auipc	a5,0x1
    12fe:	e2e78793          	addi	a5,a5,-466 # 2128 <current>
    1302:	639c                	ld	a5,0(a5)
    1304:	fef43423          	sd	a5,-24(s0)
    1308:	fe843783          	ld	a5,-24(s0)
    130c:	fd878793          	addi	a5,a5,-40
    1310:	fef43023          	sd	a5,-32(s0)
    int consume_ticks = cancelthrdstop(to_remove->thrdstop_context_id, 1);
    1314:	fe043783          	ld	a5,-32(s0)
    1318:	5fdc                	lw	a5,60(a5)
    131a:	4585                	li	a1,1
    131c:	853e                	mv	a0,a5
    131e:	fffff097          	auipc	ra,0xfffff
    1322:	3b4080e7          	jalr	948(ra) # 6d2 <cancelthrdstop>
    1326:	87aa                	mv	a5,a0
    1328:	fcf42e23          	sw	a5,-36(s0)
    threading_system_time += consume_ticks;
    132c:	00001797          	auipc	a5,0x1
    1330:	e0478793          	addi	a5,a5,-508 # 2130 <threading_system_time>
    1334:	439c                	lw	a5,0(a5)
    1336:	fdc42703          	lw	a4,-36(s0)
    133a:	9fb9                	addw	a5,a5,a4
    133c:	0007871b          	sext.w	a4,a5
    1340:	00001797          	auipc	a5,0x1
    1344:	df078793          	addi	a5,a5,-528 # 2130 <threading_system_time>
    1348:	c398                	sw	a4,0(a5)

    __release();
    134a:	00000097          	auipc	ra,0x0
    134e:	e16080e7          	jalr	-490(ra) # 1160 <__release>
    __thread_exit(to_remove);
    1352:	fe043503          	ld	a0,-32(s0)
    1356:	00000097          	auipc	ra,0x0
    135a:	ef2080e7          	jalr	-270(ra) # 1248 <__thread_exit>
}
    135e:	0001                	nop
    1360:	70a2                	ld	ra,40(sp)
    1362:	7402                	ld	s0,32(sp)
    1364:	6145                	addi	sp,sp,48
    1366:	8082                	ret

0000000000001368 <__finish_current>:

void __finish_current()
{
    1368:	7179                	addi	sp,sp,-48
    136a:	f406                	sd	ra,40(sp)
    136c:	f022                	sd	s0,32(sp)
    136e:	1800                	addi	s0,sp,48
    struct thread *current_thread = list_entry(current, struct thread, thread_list);
    1370:	00001797          	auipc	a5,0x1
    1374:	db878793          	addi	a5,a5,-584 # 2128 <current>
    1378:	639c                	ld	a5,0(a5)
    137a:	fef43423          	sd	a5,-24(s0)
    137e:	fe843783          	ld	a5,-24(s0)
    1382:	fd878793          	addi	a5,a5,-40
    1386:	fef43023          	sd	a5,-32(s0)
    --current_thread->n;
    138a:	fe043783          	ld	a5,-32(s0)
    138e:	47bc                	lw	a5,72(a5)
    1390:	37fd                	addiw	a5,a5,-1
    1392:	0007871b          	sext.w	a4,a5
    1396:	fe043783          	ld	a5,-32(s0)
    139a:	c7b8                	sw	a4,72(a5)

    printf("thread#%d finish one cycle at %d: %d cycles left\n",
    139c:	fe043783          	ld	a5,-32(s0)
    13a0:	5398                	lw	a4,32(a5)
    13a2:	00001797          	auipc	a5,0x1
    13a6:	d8e78793          	addi	a5,a5,-626 # 2130 <threading_system_time>
    13aa:	4390                	lw	a2,0(a5)
    13ac:	fe043783          	ld	a5,-32(s0)
    13b0:	47bc                	lw	a5,72(a5)
    13b2:	86be                	mv	a3,a5
    13b4:	85ba                	mv	a1,a4
    13b6:	00001517          	auipc	a0,0x1
    13ba:	c1a50513          	addi	a0,a0,-998 # 1fd0 <schedule_rm+0x324>
    13be:	fffff097          	auipc	ra,0xfffff
    13c2:	7aa080e7          	jalr	1962(ra) # b68 <printf>
           current_thread->ID, threading_system_time, current_thread->n);

    if (current_thread->n > 0) {
    13c6:	fe043783          	ld	a5,-32(s0)
    13ca:	47bc                	lw	a5,72(a5)
    13cc:	04f05563          	blez	a5,1416 <__finish_current+0xae>
        struct list_head *to_remove = current;
    13d0:	00001797          	auipc	a5,0x1
    13d4:	d5878793          	addi	a5,a5,-680 # 2128 <current>
    13d8:	639c                	ld	a5,0(a5)
    13da:	fcf43c23          	sd	a5,-40(s0)
        current = current->prev;
    13de:	00001797          	auipc	a5,0x1
    13e2:	d4a78793          	addi	a5,a5,-694 # 2128 <current>
    13e6:	639c                	ld	a5,0(a5)
    13e8:	6798                	ld	a4,8(a5)
    13ea:	00001797          	auipc	a5,0x1
    13ee:	d3e78793          	addi	a5,a5,-706 # 2128 <current>
    13f2:	e398                	sd	a4,0(a5)
        list_del(to_remove);
    13f4:	fd843503          	ld	a0,-40(s0)
    13f8:	00000097          	auipc	ra,0x0
    13fc:	bb4080e7          	jalr	-1100(ra) # fac <list_del>
        thread_add_at(current_thread, current_thread->current_deadline);
    1400:	fe043783          	ld	a5,-32(s0)
    1404:	4bbc                	lw	a5,80(a5)
    1406:	85be                	mv	a1,a5
    1408:	fe043503          	ld	a0,-32(s0)
    140c:	00000097          	auipc	ra,0x0
    1410:	cf2080e7          	jalr	-782(ra) # 10fe <thread_add_at>
    } else {
        __thread_exit(current_thread);
    }
}
    1414:	a039                	j	1422 <__finish_current+0xba>
        __thread_exit(current_thread);
    1416:	fe043503          	ld	a0,-32(s0)
    141a:	00000097          	auipc	ra,0x0
    141e:	e2e080e7          	jalr	-466(ra) # 1248 <__thread_exit>
}
    1422:	0001                	nop
    1424:	70a2                	ld	ra,40(sp)
    1426:	7402                	ld	s0,32(sp)
    1428:	6145                	addi	sp,sp,48
    142a:	8082                	ret

000000000000142c <switch_handler>:

void switch_handler(void *arg)
{
    142c:	7139                	addi	sp,sp,-64
    142e:	fc06                	sd	ra,56(sp)
    1430:	f822                	sd	s0,48(sp)
    1432:	0080                	addi	s0,sp,64
    1434:	fca43423          	sd	a0,-56(s0)
    uint64 elapsed_time = (uint64)arg;
    1438:	fc843783          	ld	a5,-56(s0)
    143c:	fef43423          	sd	a5,-24(s0)
    struct thread *current_thread = list_entry(current, struct thread, thread_list);
    1440:	00001797          	auipc	a5,0x1
    1444:	ce878793          	addi	a5,a5,-792 # 2128 <current>
    1448:	639c                	ld	a5,0(a5)
    144a:	fef43023          	sd	a5,-32(s0)
    144e:	fe043783          	ld	a5,-32(s0)
    1452:	fd878793          	addi	a5,a5,-40
    1456:	fcf43c23          	sd	a5,-40(s0)

    threading_system_time += elapsed_time;
    145a:	fe843783          	ld	a5,-24(s0)
    145e:	0007871b          	sext.w	a4,a5
    1462:	00001797          	auipc	a5,0x1
    1466:	cce78793          	addi	a5,a5,-818 # 2130 <threading_system_time>
    146a:	439c                	lw	a5,0(a5)
    146c:	2781                	sext.w	a5,a5
    146e:	9fb9                	addw	a5,a5,a4
    1470:	2781                	sext.w	a5,a5
    1472:	0007871b          	sext.w	a4,a5
    1476:	00001797          	auipc	a5,0x1
    147a:	cba78793          	addi	a5,a5,-838 # 2130 <threading_system_time>
    147e:	c398                	sw	a4,0(a5)
     __release();
    1480:	00000097          	auipc	ra,0x0
    1484:	ce0080e7          	jalr	-800(ra) # 1160 <__release>
    current_thread->remaining_time -= elapsed_time;
    1488:	fd843783          	ld	a5,-40(s0)
    148c:	47fc                	lw	a5,76(a5)
    148e:	0007871b          	sext.w	a4,a5
    1492:	fe843783          	ld	a5,-24(s0)
    1496:	2781                	sext.w	a5,a5
    1498:	40f707bb          	subw	a5,a4,a5
    149c:	2781                	sext.w	a5,a5
    149e:	0007871b          	sext.w	a4,a5
    14a2:	fd843783          	ld	a5,-40(s0)
    14a6:	c7f8                	sw	a4,76(a5)

    if (threading_system_time > current_thread->current_deadline || 
    14a8:	fd843783          	ld	a5,-40(s0)
    14ac:	4bb8                	lw	a4,80(a5)
    14ae:	00001797          	auipc	a5,0x1
    14b2:	c8278793          	addi	a5,a5,-894 # 2130 <threading_system_time>
    14b6:	439c                	lw	a5,0(a5)
    14b8:	02f74163          	blt	a4,a5,14da <switch_handler+0xae>
        (threading_system_time == current_thread->current_deadline && current_thread->remaining_time > 0)) {
    14bc:	fd843783          	ld	a5,-40(s0)
    14c0:	4bb8                	lw	a4,80(a5)
    14c2:	00001797          	auipc	a5,0x1
    14c6:	c6e78793          	addi	a5,a5,-914 # 2130 <threading_system_time>
    14ca:	439c                	lw	a5,0(a5)
    if (threading_system_time > current_thread->current_deadline || 
    14cc:	02f71e63          	bne	a4,a5,1508 <switch_handler+0xdc>
        (threading_system_time == current_thread->current_deadline && current_thread->remaining_time > 0)) {
    14d0:	fd843783          	ld	a5,-40(s0)
    14d4:	47fc                	lw	a5,76(a5)
    14d6:	02f05963          	blez	a5,1508 <switch_handler+0xdc>
        printf("thread#%d misses a deadline at %d\n", current_thread->ID, threading_system_time);
    14da:	fd843783          	ld	a5,-40(s0)
    14de:	5398                	lw	a4,32(a5)
    14e0:	00001797          	auipc	a5,0x1
    14e4:	c5078793          	addi	a5,a5,-944 # 2130 <threading_system_time>
    14e8:	439c                	lw	a5,0(a5)
    14ea:	863e                	mv	a2,a5
    14ec:	85ba                	mv	a1,a4
    14ee:	00001517          	auipc	a0,0x1
    14f2:	b1a50513          	addi	a0,a0,-1254 # 2008 <schedule_rm+0x35c>
    14f6:	fffff097          	auipc	ra,0xfffff
    14fa:	672080e7          	jalr	1650(ra) # b68 <printf>
        exit(0);
    14fe:	4501                	li	a0,0
    1500:	fffff097          	auipc	ra,0xfffff
    1504:	122080e7          	jalr	290(ra) # 622 <exit>
    }

    if (current_thread->remaining_time <= 0) {
    1508:	fd843783          	ld	a5,-40(s0)
    150c:	47fc                	lw	a5,76(a5)
    150e:	00f04663          	bgtz	a5,151a <switch_handler+0xee>
        __finish_current();
    1512:	00000097          	auipc	ra,0x0
    1516:	e56080e7          	jalr	-426(ra) # 1368 <__finish_current>
    }

    __release();
    151a:	00000097          	auipc	ra,0x0
    151e:	c46080e7          	jalr	-954(ra) # 1160 <__release>
    __schedule();
    1522:	00000097          	auipc	ra,0x0
    1526:	1b6080e7          	jalr	438(ra) # 16d8 <__schedule>
    __dispatch();
    152a:	00000097          	auipc	ra,0x0
    152e:	026080e7          	jalr	38(ra) # 1550 <__dispatch>
    thrdresume(main_thrd_id);
    1532:	00001797          	auipc	a5,0x1
    1536:	bce78793          	addi	a5,a5,-1074 # 2100 <main_thrd_id>
    153a:	439c                	lw	a5,0(a5)
    153c:	853e                	mv	a0,a5
    153e:	fffff097          	auipc	ra,0xfffff
    1542:	18c080e7          	jalr	396(ra) # 6ca <thrdresume>
}
    1546:	0001                	nop
    1548:	70e2                	ld	ra,56(sp)
    154a:	7442                	ld	s0,48(sp)
    154c:	6121                	addi	sp,sp,64
    154e:	8082                	ret

0000000000001550 <__dispatch>:

void __dispatch()
{
    1550:	7179                	addi	sp,sp,-48
    1552:	f406                	sd	ra,40(sp)
    1554:	f022                	sd	s0,32(sp)
    1556:	1800                	addi	s0,sp,48
    if (current == &run_queue) {
    1558:	00001797          	auipc	a5,0x1
    155c:	bd078793          	addi	a5,a5,-1072 # 2128 <current>
    1560:	6398                	ld	a4,0(a5)
    1562:	00001797          	auipc	a5,0x1
    1566:	b7678793          	addi	a5,a5,-1162 # 20d8 <run_queue>
    156a:	16f70263          	beq	a4,a5,16ce <__dispatch+0x17e>
    if (allocated_time < 0) {
        fprintf(2, "[FATAL] allocated_time is negative\n");
        exit(1);
    }

    struct thread *current_thread = list_entry(current, struct thread, thread_list);
    156e:	00001797          	auipc	a5,0x1
    1572:	bba78793          	addi	a5,a5,-1094 # 2128 <current>
    1576:	639c                	ld	a5,0(a5)
    1578:	fef43423          	sd	a5,-24(s0)
    157c:	fe843783          	ld	a5,-24(s0)
    1580:	fd878793          	addi	a5,a5,-40
    1584:	fef43023          	sd	a5,-32(s0)
     if (allocated_time == 0) { // miss deadline, abort
    1588:	00001797          	auipc	a5,0x1
    158c:	bb078793          	addi	a5,a5,-1104 # 2138 <allocated_time>
    1590:	639c                	ld	a5,0(a5)
    1592:	e795                	bnez	a5,15be <__dispatch+0x6e>
        printf("thread#%d misses a deadline at %d\n", current_thread->ID, current_thread->current_deadline);
    1594:	fe043783          	ld	a5,-32(s0)
    1598:	5398                	lw	a4,32(a5)
    159a:	fe043783          	ld	a5,-32(s0)
    159e:	4bbc                	lw	a5,80(a5)
    15a0:	863e                	mv	a2,a5
    15a2:	85ba                	mv	a1,a4
    15a4:	00001517          	auipc	a0,0x1
    15a8:	a6450513          	addi	a0,a0,-1436 # 2008 <schedule_rm+0x35c>
    15ac:	fffff097          	auipc	ra,0xfffff
    15b0:	5bc080e7          	jalr	1468(ra) # b68 <printf>
        exit(0);
    15b4:	4501                	li	a0,0
    15b6:	fffff097          	auipc	ra,0xfffff
    15ba:	06c080e7          	jalr	108(ra) # 622 <exit>
    }

    printf("dispatch thread#%d at %d: allocated_time=%d\n", current_thread->ID, threading_system_time, allocated_time);
    15be:	fe043783          	ld	a5,-32(s0)
    15c2:	5398                	lw	a4,32(a5)
    15c4:	00001797          	auipc	a5,0x1
    15c8:	b6c78793          	addi	a5,a5,-1172 # 2130 <threading_system_time>
    15cc:	4390                	lw	a2,0(a5)
    15ce:	00001797          	auipc	a5,0x1
    15d2:	b6a78793          	addi	a5,a5,-1174 # 2138 <allocated_time>
    15d6:	639c                	ld	a5,0(a5)
    15d8:	86be                	mv	a3,a5
    15da:	85ba                	mv	a1,a4
    15dc:	00001517          	auipc	a0,0x1
    15e0:	a5450513          	addi	a0,a0,-1452 # 2030 <schedule_rm+0x384>
    15e4:	fffff097          	auipc	ra,0xfffff
    15e8:	584080e7          	jalr	1412(ra) # b68 <printf>

    if (current_thread->buf_set) {
    15ec:	fe043783          	ld	a5,-32(s0)
    15f0:	5f9c                	lw	a5,56(a5)
    15f2:	c7a1                	beqz	a5,163a <__dispatch+0xea>
        thrdstop(allocated_time, &(current_thread->thrdstop_context_id), switch_handler, (void *)allocated_time);
    15f4:	00001797          	auipc	a5,0x1
    15f8:	b4478793          	addi	a5,a5,-1212 # 2138 <allocated_time>
    15fc:	639c                	ld	a5,0(a5)
    15fe:	0007871b          	sext.w	a4,a5
    1602:	fe043783          	ld	a5,-32(s0)
    1606:	03c78593          	addi	a1,a5,60
    160a:	00001797          	auipc	a5,0x1
    160e:	b2e78793          	addi	a5,a5,-1234 # 2138 <allocated_time>
    1612:	639c                	ld	a5,0(a5)
    1614:	86be                	mv	a3,a5
    1616:	00000617          	auipc	a2,0x0
    161a:	e1660613          	addi	a2,a2,-490 # 142c <switch_handler>
    161e:	853a                	mv	a0,a4
    1620:	fffff097          	auipc	ra,0xfffff
    1624:	0a2080e7          	jalr	162(ra) # 6c2 <thrdstop>
        thrdresume(current_thread->thrdstop_context_id);
    1628:	fe043783          	ld	a5,-32(s0)
    162c:	5fdc                	lw	a5,60(a5)
    162e:	853e                	mv	a0,a5
    1630:	fffff097          	auipc	ra,0xfffff
    1634:	09a080e7          	jalr	154(ra) # 6ca <thrdresume>
    1638:	a071                	j	16c4 <__dispatch+0x174>
    } else {
        current_thread->buf_set = 1;
    163a:	fe043783          	ld	a5,-32(s0)
    163e:	4705                	li	a4,1
    1640:	df98                	sw	a4,56(a5)
        unsigned long new_stack_p = (unsigned long)current_thread->stack_p;
    1642:	fe043783          	ld	a5,-32(s0)
    1646:	6f9c                	ld	a5,24(a5)
    1648:	fcf43c23          	sd	a5,-40(s0)
        current_thread->thrdstop_context_id = -1;
    164c:	fe043783          	ld	a5,-32(s0)
    1650:	577d                	li	a4,-1
    1652:	dfd8                	sw	a4,60(a5)
        thrdstop(allocated_time, &(current_thread->thrdstop_context_id), switch_handler, (void *)allocated_time);
    1654:	00001797          	auipc	a5,0x1
    1658:	ae478793          	addi	a5,a5,-1308 # 2138 <allocated_time>
    165c:	639c                	ld	a5,0(a5)
    165e:	0007871b          	sext.w	a4,a5
    1662:	fe043783          	ld	a5,-32(s0)
    1666:	03c78593          	addi	a1,a5,60
    166a:	00001797          	auipc	a5,0x1
    166e:	ace78793          	addi	a5,a5,-1330 # 2138 <allocated_time>
    1672:	639c                	ld	a5,0(a5)
    1674:	86be                	mv	a3,a5
    1676:	00000617          	auipc	a2,0x0
    167a:	db660613          	addi	a2,a2,-586 # 142c <switch_handler>
    167e:	853a                	mv	a0,a4
    1680:	fffff097          	auipc	ra,0xfffff
    1684:	042080e7          	jalr	66(ra) # 6c2 <thrdstop>
        if (current_thread->thrdstop_context_id < 0) {
    1688:	fe043783          	ld	a5,-32(s0)
    168c:	5fdc                	lw	a5,60(a5)
    168e:	0207d063          	bgez	a5,16ae <__dispatch+0x15e>
            fprintf(2, "[ERROR] number of threads may exceed MAX_THRD_NUM\n");
    1692:	00001597          	auipc	a1,0x1
    1696:	9ce58593          	addi	a1,a1,-1586 # 2060 <schedule_rm+0x3b4>
    169a:	4509                	li	a0,2
    169c:	fffff097          	auipc	ra,0xfffff
    16a0:	474080e7          	jalr	1140(ra) # b10 <fprintf>
            exit(1);
    16a4:	4505                	li	a0,1
    16a6:	fffff097          	auipc	ra,0xfffff
    16aa:	f7c080e7          	jalr	-132(ra) # 622 <exit>
        }

        // set sp to stack pointer of current thread.
        asm volatile("mv sp, %0"
    16ae:	fd843783          	ld	a5,-40(s0)
    16b2:	813e                	mv	sp,a5
                     :
                     : "r"(new_stack_p));
        current_thread->fp(current_thread->arg);
    16b4:	fe043783          	ld	a5,-32(s0)
    16b8:	6398                	ld	a4,0(a5)
    16ba:	fe043783          	ld	a5,-32(s0)
    16be:	679c                	ld	a5,8(a5)
    16c0:	853e                	mv	a0,a5
    16c2:	9702                	jalr	a4
    }
    thread_exit();
    16c4:	00000097          	auipc	ra,0x0
    16c8:	bfc080e7          	jalr	-1028(ra) # 12c0 <thread_exit>
    16cc:	a011                	j	16d0 <__dispatch+0x180>
        return;
    16ce:	0001                	nop
}
    16d0:	70a2                	ld	ra,40(sp)
    16d2:	7402                	ld	s0,32(sp)
    16d4:	6145                	addi	sp,sp,48
    16d6:	8082                	ret

00000000000016d8 <__schedule>:

void __schedule(void)
{
    16d8:	711d                	addi	sp,sp,-96
    16da:	ec86                	sd	ra,88(sp)
    16dc:	e8a2                	sd	s0,80(sp)
    16de:	1080                	addi	s0,sp,96
    struct threads_sched_args args = {
    16e0:	00001797          	auipc	a5,0x1
    16e4:	a5078793          	addi	a5,a5,-1456 # 2130 <threading_system_time>
    16e8:	439c                	lw	a5,0(a5)
    16ea:	fcf42c23          	sw	a5,-40(s0)
    16ee:	00001797          	auipc	a5,0x1
    16f2:	9ea78793          	addi	a5,a5,-1558 # 20d8 <run_queue>
    16f6:	fef43023          	sd	a5,-32(s0)
    16fa:	00001797          	auipc	a5,0x1
    16fe:	9ee78793          	addi	a5,a5,-1554 # 20e8 <release_queue>
    1702:	fef43423          	sd	a5,-24(s0)
#ifdef THREAD_SCHEDULER_EDF
    r = schedule_edf(args);
#endif

#ifdef THREAD_SCHEDULER_RM
    r = schedule_rm(args);
    1706:	fd843783          	ld	a5,-40(s0)
    170a:	faf43023          	sd	a5,-96(s0)
    170e:	fe043783          	ld	a5,-32(s0)
    1712:	faf43423          	sd	a5,-88(s0)
    1716:	fe843783          	ld	a5,-24(s0)
    171a:	faf43823          	sd	a5,-80(s0)
    171e:	fa040793          	addi	a5,s0,-96
    1722:	853e                	mv	a0,a5
    1724:	00000097          	auipc	ra,0x0
    1728:	588080e7          	jalr	1416(ra) # 1cac <schedule_rm>
    172c:	872a                	mv	a4,a0
    172e:	87ae                	mv	a5,a1
    1730:	fce43423          	sd	a4,-56(s0)
    1734:	fcf43823          	sd	a5,-48(s0)
#endif

    current = r.scheduled_thread_list_member;
    1738:	fc843703          	ld	a4,-56(s0)
    173c:	00001797          	auipc	a5,0x1
    1740:	9ec78793          	addi	a5,a5,-1556 # 2128 <current>
    1744:	e398                	sd	a4,0(a5)
    allocated_time = r.allocated_time;
    1746:	fd042783          	lw	a5,-48(s0)
    174a:	873e                	mv	a4,a5
    174c:	00001797          	auipc	a5,0x1
    1750:	9ec78793          	addi	a5,a5,-1556 # 2138 <allocated_time>
    1754:	e398                	sd	a4,0(a5)
}
    1756:	0001                	nop
    1758:	60e6                	ld	ra,88(sp)
    175a:	6446                	ld	s0,80(sp)
    175c:	6125                	addi	sp,sp,96
    175e:	8082                	ret

0000000000001760 <back_to_main_handler>:

void back_to_main_handler(void *arg)
{
    1760:	1101                	addi	sp,sp,-32
    1762:	ec06                	sd	ra,24(sp)
    1764:	e822                	sd	s0,16(sp)
    1766:	1000                	addi	s0,sp,32
    1768:	fea43423          	sd	a0,-24(s0)
    sleeping = 0;
    176c:	00001797          	auipc	a5,0x1
    1770:	9c878793          	addi	a5,a5,-1592 # 2134 <sleeping>
    1774:	0007a023          	sw	zero,0(a5)
    threading_system_time += (uint64)arg;
    1778:	fe843783          	ld	a5,-24(s0)
    177c:	0007871b          	sext.w	a4,a5
    1780:	00001797          	auipc	a5,0x1
    1784:	9b078793          	addi	a5,a5,-1616 # 2130 <threading_system_time>
    1788:	439c                	lw	a5,0(a5)
    178a:	2781                	sext.w	a5,a5
    178c:	9fb9                	addw	a5,a5,a4
    178e:	2781                	sext.w	a5,a5
    1790:	0007871b          	sext.w	a4,a5
    1794:	00001797          	auipc	a5,0x1
    1798:	99c78793          	addi	a5,a5,-1636 # 2130 <threading_system_time>
    179c:	c398                	sw	a4,0(a5)
    thrdresume(main_thrd_id);
    179e:	00001797          	auipc	a5,0x1
    17a2:	96278793          	addi	a5,a5,-1694 # 2100 <main_thrd_id>
    17a6:	439c                	lw	a5,0(a5)
    17a8:	853e                	mv	a0,a5
    17aa:	fffff097          	auipc	ra,0xfffff
    17ae:	f20080e7          	jalr	-224(ra) # 6ca <thrdresume>
}
    17b2:	0001                	nop
    17b4:	60e2                	ld	ra,24(sp)
    17b6:	6442                	ld	s0,16(sp)
    17b8:	6105                	addi	sp,sp,32
    17ba:	8082                	ret

00000000000017bc <thread_start_threading>:

void thread_start_threading()
{
    17bc:	1141                	addi	sp,sp,-16
    17be:	e406                	sd	ra,8(sp)
    17c0:	e022                	sd	s0,0(sp)
    17c2:	0800                	addi	s0,sp,16
    threading_system_time = 0;
    17c4:	00001797          	auipc	a5,0x1
    17c8:	96c78793          	addi	a5,a5,-1684 # 2130 <threading_system_time>
    17cc:	0007a023          	sw	zero,0(a5)
    current = &run_queue;
    17d0:	00001797          	auipc	a5,0x1
    17d4:	95878793          	addi	a5,a5,-1704 # 2128 <current>
    17d8:	00001717          	auipc	a4,0x1
    17dc:	90070713          	addi	a4,a4,-1792 # 20d8 <run_queue>
    17e0:	e398                	sd	a4,0(a5)

    // call thrdstop just for obtain an ID
    thrdstop(1000, &main_thrd_id, back_to_main_handler, (void *)0);
    17e2:	4681                	li	a3,0
    17e4:	00000617          	auipc	a2,0x0
    17e8:	f7c60613          	addi	a2,a2,-132 # 1760 <back_to_main_handler>
    17ec:	00001597          	auipc	a1,0x1
    17f0:	91458593          	addi	a1,a1,-1772 # 2100 <main_thrd_id>
    17f4:	3e800513          	li	a0,1000
    17f8:	fffff097          	auipc	ra,0xfffff
    17fc:	eca080e7          	jalr	-310(ra) # 6c2 <thrdstop>
    cancelthrdstop(main_thrd_id, 0);
    1800:	00001797          	auipc	a5,0x1
    1804:	90078793          	addi	a5,a5,-1792 # 2100 <main_thrd_id>
    1808:	439c                	lw	a5,0(a5)
    180a:	4581                	li	a1,0
    180c:	853e                	mv	a0,a5
    180e:	fffff097          	auipc	ra,0xfffff
    1812:	ec4080e7          	jalr	-316(ra) # 6d2 <cancelthrdstop>

    while (!list_empty(&run_queue) || !list_empty(&release_queue)) {
    1816:	a0c9                	j	18d8 <thread_start_threading+0x11c>
        __release();
    1818:	00000097          	auipc	ra,0x0
    181c:	948080e7          	jalr	-1720(ra) # 1160 <__release>
        __schedule();
    1820:	00000097          	auipc	ra,0x0
    1824:	eb8080e7          	jalr	-328(ra) # 16d8 <__schedule>
        cancelthrdstop(main_thrd_id, 0);
    1828:	00001797          	auipc	a5,0x1
    182c:	8d878793          	addi	a5,a5,-1832 # 2100 <main_thrd_id>
    1830:	439c                	lw	a5,0(a5)
    1832:	4581                	li	a1,0
    1834:	853e                	mv	a0,a5
    1836:	fffff097          	auipc	ra,0xfffff
    183a:	e9c080e7          	jalr	-356(ra) # 6d2 <cancelthrdstop>
        __dispatch();
    183e:	00000097          	auipc	ra,0x0
    1842:	d12080e7          	jalr	-750(ra) # 1550 <__dispatch>

        if (list_empty(&run_queue) && list_empty(&release_queue)) {
    1846:	00001517          	auipc	a0,0x1
    184a:	89250513          	addi	a0,a0,-1902 # 20d8 <run_queue>
    184e:	fffff097          	auipc	ra,0xfffff
    1852:	7a8080e7          	jalr	1960(ra) # ff6 <list_empty>
    1856:	87aa                	mv	a5,a0
    1858:	cb99                	beqz	a5,186e <thread_start_threading+0xb2>
    185a:	00001517          	auipc	a0,0x1
    185e:	88e50513          	addi	a0,a0,-1906 # 20e8 <release_queue>
    1862:	fffff097          	auipc	ra,0xfffff
    1866:	794080e7          	jalr	1940(ra) # ff6 <list_empty>
    186a:	87aa                	mv	a5,a0
    186c:	ebd9                	bnez	a5,1902 <thread_start_threading+0x146>
            break;
        }

        // no thread in run_queue, release_queue not empty
        printf("run_queue is empty, sleep for %d ticks\n", allocated_time);
    186e:	00001797          	auipc	a5,0x1
    1872:	8ca78793          	addi	a5,a5,-1846 # 2138 <allocated_time>
    1876:	639c                	ld	a5,0(a5)
    1878:	85be                	mv	a1,a5
    187a:	00001517          	auipc	a0,0x1
    187e:	81e50513          	addi	a0,a0,-2018 # 2098 <schedule_rm+0x3ec>
    1882:	fffff097          	auipc	ra,0xfffff
    1886:	2e6080e7          	jalr	742(ra) # b68 <printf>
        sleeping = 1;
    188a:	00001797          	auipc	a5,0x1
    188e:	8aa78793          	addi	a5,a5,-1878 # 2134 <sleeping>
    1892:	4705                	li	a4,1
    1894:	c398                	sw	a4,0(a5)
        thrdstop(allocated_time, &main_thrd_id, back_to_main_handler, (void *)allocated_time);
    1896:	00001797          	auipc	a5,0x1
    189a:	8a278793          	addi	a5,a5,-1886 # 2138 <allocated_time>
    189e:	639c                	ld	a5,0(a5)
    18a0:	0007871b          	sext.w	a4,a5
    18a4:	00001797          	auipc	a5,0x1
    18a8:	89478793          	addi	a5,a5,-1900 # 2138 <allocated_time>
    18ac:	639c                	ld	a5,0(a5)
    18ae:	86be                	mv	a3,a5
    18b0:	00000617          	auipc	a2,0x0
    18b4:	eb060613          	addi	a2,a2,-336 # 1760 <back_to_main_handler>
    18b8:	00001597          	auipc	a1,0x1
    18bc:	84858593          	addi	a1,a1,-1976 # 2100 <main_thrd_id>
    18c0:	853a                	mv	a0,a4
    18c2:	fffff097          	auipc	ra,0xfffff
    18c6:	e00080e7          	jalr	-512(ra) # 6c2 <thrdstop>
        while (sleeping) {
    18ca:	0001                	nop
    18cc:	00001797          	auipc	a5,0x1
    18d0:	86878793          	addi	a5,a5,-1944 # 2134 <sleeping>
    18d4:	439c                	lw	a5,0(a5)
    18d6:	fbfd                	bnez	a5,18cc <thread_start_threading+0x110>
    while (!list_empty(&run_queue) || !list_empty(&release_queue)) {
    18d8:	00001517          	auipc	a0,0x1
    18dc:	80050513          	addi	a0,a0,-2048 # 20d8 <run_queue>
    18e0:	fffff097          	auipc	ra,0xfffff
    18e4:	716080e7          	jalr	1814(ra) # ff6 <list_empty>
    18e8:	87aa                	mv	a5,a0
    18ea:	d79d                	beqz	a5,1818 <thread_start_threading+0x5c>
    18ec:	00000517          	auipc	a0,0x0
    18f0:	7fc50513          	addi	a0,a0,2044 # 20e8 <release_queue>
    18f4:	fffff097          	auipc	ra,0xfffff
    18f8:	702080e7          	jalr	1794(ra) # ff6 <list_empty>
    18fc:	87aa                	mv	a5,a0
    18fe:	df89                	beqz	a5,1818 <thread_start_threading+0x5c>
            // zzz...
        }
    }
}
    1900:	a011                	j	1904 <thread_start_threading+0x148>
            break;
    1902:	0001                	nop
}
    1904:	0001                	nop
    1906:	60a2                	ld	ra,8(sp)
    1908:	6402                	ld	s0,0(sp)
    190a:	0141                	addi	sp,sp,16
    190c:	8082                	ret

000000000000190e <list_empty>:
{
    190e:	1101                	addi	sp,sp,-32
    1910:	ec22                	sd	s0,24(sp)
    1912:	1000                	addi	s0,sp,32
    1914:	fea43423          	sd	a0,-24(s0)
    return head->next == head;
    1918:	fe843783          	ld	a5,-24(s0)
    191c:	639c                	ld	a5,0(a5)
    191e:	fe843703          	ld	a4,-24(s0)
    1922:	40f707b3          	sub	a5,a4,a5
    1926:	0017b793          	seqz	a5,a5
    192a:	0ff7f793          	andi	a5,a5,255
    192e:	2781                	sext.w	a5,a5
}
    1930:	853e                	mv	a0,a5
    1932:	6462                	ld	s0,24(sp)
    1934:	6105                	addi	sp,sp,32
    1936:	8082                	ret

0000000000001938 <schedule_default>:

#define NULL 0

/* default scheduling algorithm */
struct threads_sched_result schedule_default(struct threads_sched_args args)
{
    1938:	715d                	addi	sp,sp,-80
    193a:	e4a2                	sd	s0,72(sp)
    193c:	e0a6                	sd	s1,64(sp)
    193e:	0880                	addi	s0,sp,80
    1940:	84aa                	mv	s1,a0
    struct thread *thread_with_smallest_id = NULL;
    1942:	fe043423          	sd	zero,-24(s0)
    struct thread *th = NULL;
    1946:	fe043023          	sd	zero,-32(s0)
    // find the running thread with smallest id  
    list_for_each_entry(th, args.run_queue, thread_list) {
    194a:	649c                	ld	a5,8(s1)
    194c:	639c                	ld	a5,0(a5)
    194e:	fcf43c23          	sd	a5,-40(s0)
    1952:	fd843783          	ld	a5,-40(s0)
    1956:	fd878793          	addi	a5,a5,-40
    195a:	fef43023          	sd	a5,-32(s0)
    195e:	a81d                	j	1994 <schedule_default+0x5c>
        if (thread_with_smallest_id == NULL || th->ID < thread_with_smallest_id->ID) {
    1960:	fe843783          	ld	a5,-24(s0)
    1964:	cb89                	beqz	a5,1976 <schedule_default+0x3e>
    1966:	fe043783          	ld	a5,-32(s0)
    196a:	5398                	lw	a4,32(a5)
    196c:	fe843783          	ld	a5,-24(s0)
    1970:	539c                	lw	a5,32(a5)
    1972:	00f75663          	bge	a4,a5,197e <schedule_default+0x46>
            thread_with_smallest_id = th;
    1976:	fe043783          	ld	a5,-32(s0)
    197a:	fef43423          	sd	a5,-24(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    197e:	fe043783          	ld	a5,-32(s0)
    1982:	779c                	ld	a5,40(a5)
    1984:	fcf43823          	sd	a5,-48(s0)
    1988:	fd043783          	ld	a5,-48(s0)
    198c:	fd878793          	addi	a5,a5,-40
    1990:	fef43023          	sd	a5,-32(s0)
    1994:	fe043783          	ld	a5,-32(s0)
    1998:	02878713          	addi	a4,a5,40
    199c:	649c                	ld	a5,8(s1)
    199e:	fcf711e3          	bne	a4,a5,1960 <schedule_default+0x28>
        }
    }

    struct threads_sched_result r;
    if (thread_with_smallest_id != NULL) {
    19a2:	fe843783          	ld	a5,-24(s0)
    19a6:	cf89                	beqz	a5,19c0 <schedule_default+0x88>
        r.scheduled_thread_list_member = &thread_with_smallest_id->thread_list;
    19a8:	fe843783          	ld	a5,-24(s0)
    19ac:	02878793          	addi	a5,a5,40
    19b0:	faf43823          	sd	a5,-80(s0)
        r.allocated_time = thread_with_smallest_id->remaining_time;
    19b4:	fe843783          	ld	a5,-24(s0)
    19b8:	47fc                	lw	a5,76(a5)
    19ba:	faf42c23          	sw	a5,-72(s0)
    19be:	a039                	j	19cc <schedule_default+0x94>
    } else {
        r.scheduled_thread_list_member = args.run_queue;
    19c0:	649c                	ld	a5,8(s1)
    19c2:	faf43823          	sd	a5,-80(s0)
        r.allocated_time = 1;
    19c6:	4785                	li	a5,1
    19c8:	faf42c23          	sw	a5,-72(s0)
    }

    return r;
    19cc:	fb043783          	ld	a5,-80(s0)
    19d0:	fcf43023          	sd	a5,-64(s0)
    19d4:	fb843783          	ld	a5,-72(s0)
    19d8:	fcf43423          	sd	a5,-56(s0)
    19dc:	fc043703          	ld	a4,-64(s0)
    19e0:	fc843783          	ld	a5,-56(s0)
    19e4:	863a                	mv	a2,a4
    19e6:	86be                	mv	a3,a5
    19e8:	8732                	mv	a4,a2
    19ea:	87b6                	mv	a5,a3
}
    19ec:	853a                	mv	a0,a4
    19ee:	85be                	mv	a1,a5
    19f0:	6426                	ld	s0,72(sp)
    19f2:	6486                	ld	s1,64(sp)
    19f4:	6161                	addi	sp,sp,80
    19f6:	8082                	ret

00000000000019f8 <schedule_edf>:

/* Earliest-Deadline-First scheduling */
struct threads_sched_result schedule_edf(struct threads_sched_args args)
{
    19f8:	7155                	addi	sp,sp,-208
    19fa:	e586                	sd	ra,200(sp)
    19fc:	e1a2                	sd	s0,192(sp)
    19fe:	fd26                	sd	s1,184(sp)
    1a00:	f94a                	sd	s2,176(sp)
    1a02:	f54e                	sd	s3,168(sp)
    1a04:	0980                	addi	s0,sp,208
    1a06:	84aa                	mv	s1,a0
    struct thread *thread_edf = NULL;
    1a08:	fc043423          	sd	zero,-56(s0)
    struct thread *th = NULL;
    1a0c:	fc043023          	sd	zero,-64(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    1a10:	649c                	ld	a5,8(s1)
    1a12:	639c                	ld	a5,0(a5)
    1a14:	f8f43823          	sd	a5,-112(s0)
    1a18:	f9043783          	ld	a5,-112(s0)
    1a1c:	fd878793          	addi	a5,a5,-40
    1a20:	fcf43023          	sd	a5,-64(s0)
    1a24:	a899                	j	1a7a <schedule_edf+0x82>
      if (thread_edf==NULL || th->current_deadline<thread_edf->current_deadline 
    1a26:	fc843783          	ld	a5,-56(s0)
    1a2a:	cb8d                	beqz	a5,1a5c <schedule_edf+0x64>
    1a2c:	fc043783          	ld	a5,-64(s0)
    1a30:	4bb8                	lw	a4,80(a5)
    1a32:	fc843783          	ld	a5,-56(s0)
    1a36:	4bbc                	lw	a5,80(a5)
    1a38:	02f74263          	blt	a4,a5,1a5c <schedule_edf+0x64>
          || (th->current_deadline==thread_edf->current_deadline&&th->ID<thread_edf->ID) )
    1a3c:	fc043783          	ld	a5,-64(s0)
    1a40:	4bb8                	lw	a4,80(a5)
    1a42:	fc843783          	ld	a5,-56(s0)
    1a46:	4bbc                	lw	a5,80(a5)
    1a48:	00f71e63          	bne	a4,a5,1a64 <schedule_edf+0x6c>
    1a4c:	fc043783          	ld	a5,-64(s0)
    1a50:	5398                	lw	a4,32(a5)
    1a52:	fc843783          	ld	a5,-56(s0)
    1a56:	539c                	lw	a5,32(a5)
    1a58:	00f75663          	bge	a4,a5,1a64 <schedule_edf+0x6c>
        thread_edf = th;
    1a5c:	fc043783          	ld	a5,-64(s0)
    1a60:	fcf43423          	sd	a5,-56(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    1a64:	fc043783          	ld	a5,-64(s0)
    1a68:	779c                	ld	a5,40(a5)
    1a6a:	f4f43823          	sd	a5,-176(s0)
    1a6e:	f5043783          	ld	a5,-176(s0)
    1a72:	fd878793          	addi	a5,a5,-40
    1a76:	fcf43023          	sd	a5,-64(s0)
    1a7a:	fc043783          	ld	a5,-64(s0)
    1a7e:	02878713          	addi	a4,a5,40
    1a82:	649c                	ld	a5,8(s1)
    1a84:	faf711e3          	bne	a4,a5,1a26 <schedule_edf+0x2e>
    }

    struct threads_sched_result r;

    if (list_empty(args.run_queue)) {
    1a88:	649c                	ld	a5,8(s1)
    1a8a:	853e                	mv	a0,a5
    1a8c:	00000097          	auipc	ra,0x0
    1a90:	e82080e7          	jalr	-382(ra) # 190e <list_empty>
    1a94:	87aa                	mv	a5,a0
    1a96:	cfb5                	beqz	a5,1b12 <schedule_edf+0x11a>
        // empty run_queue
        r.scheduled_thread_list_member = args.run_queue;
    1a98:	649c                	ld	a5,8(s1)
    1a9a:	f2f43823          	sd	a5,-208(s0)

        int next_intval = 9999;
    1a9e:	6789                	lui	a5,0x2
    1aa0:	70f78793          	addi	a5,a5,1807 # 270f <__BSS_END__+0x5cf>
    1aa4:	faf42e23          	sw	a5,-68(s0)
        struct release_queue_entry *rqe;
        list_for_each_entry(rqe, args.release_queue, thread_list) {
    1aa8:	689c                	ld	a5,16(s1)
    1aaa:	639c                	ld	a5,0(a5)
    1aac:	f6f43023          	sd	a5,-160(s0)
    1ab0:	f6043783          	ld	a5,-160(s0)
    1ab4:	17e1                	addi	a5,a5,-8
    1ab6:	faf43823          	sd	a5,-80(s0)
    1aba:	a081                	j	1afa <schedule_edf+0x102>
            if (rqe->release_time-args.current_time < next_intval)
    1abc:	fb043783          	ld	a5,-80(s0)
    1ac0:	4f98                	lw	a4,24(a5)
    1ac2:	409c                	lw	a5,0(s1)
    1ac4:	40f707bb          	subw	a5,a4,a5
    1ac8:	0007871b          	sext.w	a4,a5
    1acc:	fbc42783          	lw	a5,-68(s0)
    1ad0:	2781                	sext.w	a5,a5
    1ad2:	00f75a63          	bge	a4,a5,1ae6 <schedule_edf+0xee>
                next_intval = rqe->release_time-args.current_time; 
    1ad6:	fb043783          	ld	a5,-80(s0)
    1ada:	4f98                	lw	a4,24(a5)
    1adc:	409c                	lw	a5,0(s1)
    1ade:	40f707bb          	subw	a5,a4,a5
    1ae2:	faf42e23          	sw	a5,-68(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list) {
    1ae6:	fb043783          	ld	a5,-80(s0)
    1aea:	679c                	ld	a5,8(a5)
    1aec:	f4f43c23          	sd	a5,-168(s0)
    1af0:	f5843783          	ld	a5,-168(s0)
    1af4:	17e1                	addi	a5,a5,-8
    1af6:	faf43823          	sd	a5,-80(s0)
    1afa:	fb043783          	ld	a5,-80(s0)
    1afe:	00878713          	addi	a4,a5,8
    1b02:	689c                	ld	a5,16(s1)
    1b04:	faf71ce3          	bne	a4,a5,1abc <schedule_edf+0xc4>
        }

        //printf("%d\n", next_release);
        r.allocated_time = next_intval;
    1b08:	fbc42783          	lw	a5,-68(s0)
    1b0c:	f2f42c23          	sw	a5,-200(s0)
    1b10:	a2ad                	j	1c7a <schedule_edf+0x282>
    } else {
        // look for missed threads
        struct thread *thread_missed = NULL;
    1b12:	fa043423          	sd	zero,-88(s0)
        list_for_each_entry(th, args.run_queue, thread_list) {
    1b16:	649c                	ld	a5,8(s1)
    1b18:	639c                	ld	a5,0(a5)
    1b1a:	f8f43423          	sd	a5,-120(s0)
    1b1e:	f8843783          	ld	a5,-120(s0)
    1b22:	fd878793          	addi	a5,a5,-40
    1b26:	fcf43023          	sd	a5,-64(s0)
    1b2a:	a089                	j	1b6c <schedule_edf+0x174>
          if (th->current_deadline <= args.current_time){
    1b2c:	fc043783          	ld	a5,-64(s0)
    1b30:	4bb8                	lw	a4,80(a5)
    1b32:	409c                	lw	a5,0(s1)
    1b34:	02e7c163          	blt	a5,a4,1b56 <schedule_edf+0x15e>
            if (thread_missed == NULL || th->ID < thread_missed->ID)
    1b38:	fa843783          	ld	a5,-88(s0)
    1b3c:	cb89                	beqz	a5,1b4e <schedule_edf+0x156>
    1b3e:	fc043783          	ld	a5,-64(s0)
    1b42:	5398                	lw	a4,32(a5)
    1b44:	fa843783          	ld	a5,-88(s0)
    1b48:	539c                	lw	a5,32(a5)
    1b4a:	00f75663          	bge	a4,a5,1b56 <schedule_edf+0x15e>
              thread_missed = th;
    1b4e:	fc043783          	ld	a5,-64(s0)
    1b52:	faf43423          	sd	a5,-88(s0)
        list_for_each_entry(th, args.run_queue, thread_list) {
    1b56:	fc043783          	ld	a5,-64(s0)
    1b5a:	779c                	ld	a5,40(a5)
    1b5c:	f6f43423          	sd	a5,-152(s0)
    1b60:	f6843783          	ld	a5,-152(s0)
    1b64:	fd878793          	addi	a5,a5,-40
    1b68:	fcf43023          	sd	a5,-64(s0)
    1b6c:	fc043783          	ld	a5,-64(s0)
    1b70:	02878713          	addi	a4,a5,40
    1b74:	649c                	ld	a5,8(s1)
    1b76:	faf71be3          	bne	a4,a5,1b2c <schedule_edf+0x134>
          }
        }

        if (thread_missed){
    1b7a:	fa843783          	ld	a5,-88(s0)
    1b7e:	c395                	beqz	a5,1ba2 <schedule_edf+0x1aa>
          r.scheduled_thread_list_member = &thread_missed->thread_list;
    1b80:	fa843783          	ld	a5,-88(s0)
    1b84:	02878793          	addi	a5,a5,40
    1b88:	f2f43823          	sd	a5,-208(s0)
          r.allocated_time = 0;
    1b8c:	f2042c23          	sw	zero,-200(s0)

          return r;
    1b90:	f3043783          	ld	a5,-208(s0)
    1b94:	f4f43023          	sd	a5,-192(s0)
    1b98:	f3843783          	ld	a5,-200(s0)
    1b9c:	f4f43423          	sd	a5,-184(s0)
    1ba0:	a0ed                	j	1c8a <schedule_edf+0x292>
        }

        r.scheduled_thread_list_member = &thread_edf->thread_list;
    1ba2:	fc843783          	ld	a5,-56(s0)
    1ba6:	02878793          	addi	a5,a5,40
    1baa:	f2f43823          	sd	a5,-208(s0)

        // get allocated_time
        r.allocated_time = thread_edf->current_deadline - args.current_time;
    1bae:	fc843783          	ld	a5,-56(s0)
    1bb2:	4bb8                	lw	a4,80(a5)
    1bb4:	409c                	lw	a5,0(s1)
    1bb6:	40f707bb          	subw	a5,a4,a5
    1bba:	2781                	sext.w	a5,a5
    1bbc:	f2f42c23          	sw	a5,-200(s0)
        if (thread_edf->remaining_time < r.allocated_time)
    1bc0:	fc843783          	ld	a5,-56(s0)
    1bc4:	47f8                	lw	a4,76(a5)
    1bc6:	f3842783          	lw	a5,-200(s0)
    1bca:	00f75763          	bge	a4,a5,1bd8 <schedule_edf+0x1e0>
            r.allocated_time = thread_edf->remaining_time; 
    1bce:	fc843783          	ld	a5,-56(s0)
    1bd2:	47fc                	lw	a5,76(a5)
    1bd4:	f2f42c23          	sw	a5,-200(s0)

        // maybe preepted by other threads in terms of deadline priority
        struct release_queue_entry *rqe;
        int preepted_time = 9999;
    1bd8:	6789                	lui	a5,0x2
    1bda:	70f78793          	addi	a5,a5,1807 # 270f <__BSS_END__+0x5cf>
    1bde:	f8f42e23          	sw	a5,-100(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list) {
    1be2:	689c                	ld	a5,16(s1)
    1be4:	639c                	ld	a5,0(a5)
    1be6:	f8f43023          	sd	a5,-128(s0)
    1bea:	f8043783          	ld	a5,-128(s0)
    1bee:	17e1                	addi	a5,a5,-8
    1bf0:	faf43023          	sd	a5,-96(s0)
    1bf4:	a08d                	j	1c56 <schedule_edf+0x25e>
            int future_deadline = rqe->thrd->period + rqe->release_time;
    1bf6:	fa043783          	ld	a5,-96(s0)
    1bfa:	639c                	ld	a5,0(a5)
    1bfc:	43f8                	lw	a4,68(a5)
    1bfe:	fa043783          	ld	a5,-96(s0)
    1c02:	4f9c                	lw	a5,24(a5)
    1c04:	9fb9                	addw	a5,a5,a4
    1c06:	f6f42e23          	sw	a5,-132(s0)
            //printf("%d\n", future_deadline);
            if (thread_edf->current_deadline > future_deadline){
    1c0a:	fc843783          	ld	a5,-56(s0)
    1c0e:	4bb8                	lw	a4,80(a5)
    1c10:	f7c42783          	lw	a5,-132(s0)
    1c14:	2781                	sext.w	a5,a5
    1c16:	02e7d663          	bge	a5,a4,1c42 <schedule_edf+0x24a>
              int tmp = rqe->release_time - args.current_time; 
    1c1a:	fa043783          	ld	a5,-96(s0)
    1c1e:	4f98                	lw	a4,24(a5)
    1c20:	409c                	lw	a5,0(s1)
    1c22:	40f707bb          	subw	a5,a4,a5
    1c26:	f6f42c23          	sw	a5,-136(s0)
              if (tmp < preepted_time)
    1c2a:	f7842703          	lw	a4,-136(s0)
    1c2e:	f9c42783          	lw	a5,-100(s0)
    1c32:	2701                	sext.w	a4,a4
    1c34:	2781                	sext.w	a5,a5
    1c36:	00f75663          	bge	a4,a5,1c42 <schedule_edf+0x24a>
                preepted_time = tmp;
    1c3a:	f7842783          	lw	a5,-136(s0)
    1c3e:	f8f42e23          	sw	a5,-100(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list) {
    1c42:	fa043783          	ld	a5,-96(s0)
    1c46:	679c                	ld	a5,8(a5)
    1c48:	f6f43823          	sd	a5,-144(s0)
    1c4c:	f7043783          	ld	a5,-144(s0)
    1c50:	17e1                	addi	a5,a5,-8
    1c52:	faf43023          	sd	a5,-96(s0)
    1c56:	fa043783          	ld	a5,-96(s0)
    1c5a:	00878713          	addi	a4,a5,8
    1c5e:	689c                	ld	a5,16(s1)
    1c60:	f8f71be3          	bne	a4,a5,1bf6 <schedule_edf+0x1fe>
            }
        }
        if (preepted_time < r.allocated_time)
    1c64:	f3842703          	lw	a4,-200(s0)
    1c68:	f9c42783          	lw	a5,-100(s0)
    1c6c:	2781                	sext.w	a5,a5
    1c6e:	00e7d663          	bge	a5,a4,1c7a <schedule_edf+0x282>
          r.allocated_time = preepted_time;
    1c72:	f9c42783          	lw	a5,-100(s0)
    1c76:	f2f42c23          	sw	a5,-200(s0)

        //printf("%d\n", preepted_time);
        //printf("%d\n", r.allocated_time);
    }

    return r;
    1c7a:	f3043783          	ld	a5,-208(s0)
    1c7e:	f4f43023          	sd	a5,-192(s0)
    1c82:	f3843783          	ld	a5,-200(s0)
    1c86:	f4f43423          	sd	a5,-184(s0)
}
    1c8a:	f4043703          	ld	a4,-192(s0)
    1c8e:	f4843783          	ld	a5,-184(s0)
    1c92:	893a                	mv	s2,a4
    1c94:	89be                	mv	s3,a5
    1c96:	874a                	mv	a4,s2
    1c98:	87ce                	mv	a5,s3
    1c9a:	853a                	mv	a0,a4
    1c9c:	85be                	mv	a1,a5
    1c9e:	60ae                	ld	ra,200(sp)
    1ca0:	640e                	ld	s0,192(sp)
    1ca2:	74ea                	ld	s1,184(sp)
    1ca4:	794a                	ld	s2,176(sp)
    1ca6:	79aa                	ld	s3,168(sp)
    1ca8:	6169                	addi	sp,sp,208
    1caa:	8082                	ret

0000000000001cac <schedule_rm>:

/* Rate-Monotonic Scheduling */
struct threads_sched_result schedule_rm(struct threads_sched_args args)
{
    1cac:	7155                	addi	sp,sp,-208
    1cae:	e586                	sd	ra,200(sp)
    1cb0:	e1a2                	sd	s0,192(sp)
    1cb2:	fd26                	sd	s1,184(sp)
    1cb4:	f94a                	sd	s2,176(sp)
    1cb6:	f54e                	sd	s3,168(sp)
    1cb8:	0980                	addi	s0,sp,208
    1cba:	84aa                	mv	s1,a0
    struct thread *thread_rm = NULL;
    1cbc:	fc043423          	sd	zero,-56(s0)
    struct thread *th = NULL;
    1cc0:	fc043023          	sd	zero,-64(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    1cc4:	649c                	ld	a5,8(s1)
    1cc6:	639c                	ld	a5,0(a5)
    1cc8:	f8f43823          	sd	a5,-112(s0)
    1ccc:	f9043783          	ld	a5,-112(s0)
    1cd0:	fd878793          	addi	a5,a5,-40
    1cd4:	fcf43023          	sd	a5,-64(s0)
    1cd8:	a899                	j	1d2e <schedule_rm+0x82>
      if (thread_rm==NULL || th->period<thread_rm->period || 
    1cda:	fc843783          	ld	a5,-56(s0)
    1cde:	cb8d                	beqz	a5,1d10 <schedule_rm+0x64>
    1ce0:	fc043783          	ld	a5,-64(s0)
    1ce4:	43f8                	lw	a4,68(a5)
    1ce6:	fc843783          	ld	a5,-56(s0)
    1cea:	43fc                	lw	a5,68(a5)
    1cec:	02f74263          	blt	a4,a5,1d10 <schedule_rm+0x64>
          (th->period==thread_rm->period&&th->ID<thread_rm->ID) )
    1cf0:	fc043783          	ld	a5,-64(s0)
    1cf4:	43f8                	lw	a4,68(a5)
    1cf6:	fc843783          	ld	a5,-56(s0)
    1cfa:	43fc                	lw	a5,68(a5)
      if (thread_rm==NULL || th->period<thread_rm->period || 
    1cfc:	00f71e63          	bne	a4,a5,1d18 <schedule_rm+0x6c>
          (th->period==thread_rm->period&&th->ID<thread_rm->ID) )
    1d00:	fc043783          	ld	a5,-64(s0)
    1d04:	5398                	lw	a4,32(a5)
    1d06:	fc843783          	ld	a5,-56(s0)
    1d0a:	539c                	lw	a5,32(a5)
    1d0c:	00f75663          	bge	a4,a5,1d18 <schedule_rm+0x6c>
        thread_rm = th;
    1d10:	fc043783          	ld	a5,-64(s0)
    1d14:	fcf43423          	sd	a5,-56(s0)
    list_for_each_entry(th, args.run_queue, thread_list) {
    1d18:	fc043783          	ld	a5,-64(s0)
    1d1c:	779c                	ld	a5,40(a5)
    1d1e:	f4f43823          	sd	a5,-176(s0)
    1d22:	f5043783          	ld	a5,-176(s0)
    1d26:	fd878793          	addi	a5,a5,-40
    1d2a:	fcf43023          	sd	a5,-64(s0)
    1d2e:	fc043783          	ld	a5,-64(s0)
    1d32:	02878713          	addi	a4,a5,40
    1d36:	649c                	ld	a5,8(s1)
    1d38:	faf711e3          	bne	a4,a5,1cda <schedule_rm+0x2e>
    }

    struct threads_sched_result r;

    if (list_empty(args.run_queue)) {
    1d3c:	649c                	ld	a5,8(s1)
    1d3e:	853e                	mv	a0,a5
    1d40:	00000097          	auipc	ra,0x0
    1d44:	bce080e7          	jalr	-1074(ra) # 190e <list_empty>
    1d48:	87aa                	mv	a5,a0
    1d4a:	c3c1                	beqz	a5,1dca <schedule_rm+0x11e>
    // empty run_queue
        r.scheduled_thread_list_member = args.run_queue;
    1d4c:	649c                	ld	a5,8(s1)
    1d4e:	f2f43823          	sd	a5,-208(s0)

        int near_intval = 9999;
    1d52:	6789                	lui	a5,0x2
    1d54:	70f78793          	addi	a5,a5,1807 # 270f <__BSS_END__+0x5cf>
    1d58:	faf42e23          	sw	a5,-68(s0)
        struct release_queue_entry *rqe = NULL;
    1d5c:	fa043823          	sd	zero,-80(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list) {
    1d60:	689c                	ld	a5,16(s1)
    1d62:	639c                	ld	a5,0(a5)
    1d64:	f6f43023          	sd	a5,-160(s0)
    1d68:	f6043783          	ld	a5,-160(s0)
    1d6c:	17e1                	addi	a5,a5,-8
    1d6e:	faf43823          	sd	a5,-80(s0)
    1d72:	a081                	j	1db2 <schedule_rm+0x106>
            if (rqe->release_time-args.current_time < near_intval)
    1d74:	fb043783          	ld	a5,-80(s0)
    1d78:	4f98                	lw	a4,24(a5)
    1d7a:	409c                	lw	a5,0(s1)
    1d7c:	40f707bb          	subw	a5,a4,a5
    1d80:	0007871b          	sext.w	a4,a5
    1d84:	fbc42783          	lw	a5,-68(s0)
    1d88:	2781                	sext.w	a5,a5
    1d8a:	00f75a63          	bge	a4,a5,1d9e <schedule_rm+0xf2>
              near_intval = rqe->release_time-args.current_time; 
    1d8e:	fb043783          	ld	a5,-80(s0)
    1d92:	4f98                	lw	a4,24(a5)
    1d94:	409c                	lw	a5,0(s1)
    1d96:	40f707bb          	subw	a5,a4,a5
    1d9a:	faf42e23          	sw	a5,-68(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list) {
    1d9e:	fb043783          	ld	a5,-80(s0)
    1da2:	679c                	ld	a5,8(a5)
    1da4:	f4f43c23          	sd	a5,-168(s0)
    1da8:	f5843783          	ld	a5,-168(s0)
    1dac:	17e1                	addi	a5,a5,-8
    1dae:	faf43823          	sd	a5,-80(s0)
    1db2:	fb043783          	ld	a5,-80(s0)
    1db6:	00878713          	addi	a4,a5,8
    1dba:	689c                	ld	a5,16(s1)
    1dbc:	faf71ce3          	bne	a4,a5,1d74 <schedule_rm+0xc8>
        }

        r.allocated_time = near_intval;
    1dc0:	fbc42783          	lw	a5,-68(s0)
    1dc4:	f2f42c23          	sw	a5,-200(s0)
    1dc8:	aaa1                	j	1f20 <schedule_rm+0x274>
    } else {
        // look for missed threads
        struct thread *thread_missed = NULL;
    1dca:	fa043423          	sd	zero,-88(s0)
        list_for_each_entry(th, args.run_queue, thread_list) {
    1dce:	649c                	ld	a5,8(s1)
    1dd0:	639c                	ld	a5,0(a5)
    1dd2:	f8f43423          	sd	a5,-120(s0)
    1dd6:	f8843783          	ld	a5,-120(s0)
    1dda:	fd878793          	addi	a5,a5,-40
    1dde:	fcf43023          	sd	a5,-64(s0)
    1de2:	a089                	j	1e24 <schedule_rm+0x178>
          if (th->current_deadline <= args.current_time){
    1de4:	fc043783          	ld	a5,-64(s0)
    1de8:	4bb8                	lw	a4,80(a5)
    1dea:	409c                	lw	a5,0(s1)
    1dec:	02e7c163          	blt	a5,a4,1e0e <schedule_rm+0x162>
            //printf("th id %d\n", th->ID);
            if (thread_missed == NULL || th->ID < thread_missed->ID)
    1df0:	fa843783          	ld	a5,-88(s0)
    1df4:	cb89                	beqz	a5,1e06 <schedule_rm+0x15a>
    1df6:	fc043783          	ld	a5,-64(s0)
    1dfa:	5398                	lw	a4,32(a5)
    1dfc:	fa843783          	ld	a5,-88(s0)
    1e00:	539c                	lw	a5,32(a5)
    1e02:	00f75663          	bge	a4,a5,1e0e <schedule_rm+0x162>
              thread_missed = th;
    1e06:	fc043783          	ld	a5,-64(s0)
    1e0a:	faf43423          	sd	a5,-88(s0)
        list_for_each_entry(th, args.run_queue, thread_list) {
    1e0e:	fc043783          	ld	a5,-64(s0)
    1e12:	779c                	ld	a5,40(a5)
    1e14:	f6f43423          	sd	a5,-152(s0)
    1e18:	f6843783          	ld	a5,-152(s0)
    1e1c:	fd878793          	addi	a5,a5,-40
    1e20:	fcf43023          	sd	a5,-64(s0)
    1e24:	fc043783          	ld	a5,-64(s0)
    1e28:	02878713          	addi	a4,a5,40
    1e2c:	649c                	ld	a5,8(s1)
    1e2e:	faf71be3          	bne	a4,a5,1de4 <schedule_rm+0x138>
          }
        }

        if (thread_missed){
    1e32:	fa843783          	ld	a5,-88(s0)
    1e36:	c395                	beqz	a5,1e5a <schedule_rm+0x1ae>
          r.scheduled_thread_list_member = &thread_missed->thread_list;
    1e38:	fa843783          	ld	a5,-88(s0)
    1e3c:	02878793          	addi	a5,a5,40
    1e40:	f2f43823          	sd	a5,-208(s0)
          r.allocated_time = 0;
    1e44:	f2042c23          	sw	zero,-200(s0)

          return r;
    1e48:	f3043783          	ld	a5,-208(s0)
    1e4c:	f4f43023          	sd	a5,-192(s0)
    1e50:	f3843783          	ld	a5,-200(s0)
    1e54:	f4f43423          	sd	a5,-184(s0)
    1e58:	a8e1                	j	1f30 <schedule_rm+0x284>
        }

        r.scheduled_thread_list_member = &thread_rm->thread_list;
    1e5a:	fc843783          	ld	a5,-56(s0)
    1e5e:	02878793          	addi	a5,a5,40
    1e62:	f2f43823          	sd	a5,-208(s0)

        // get allocated_time
        r.allocated_time = thread_rm->current_deadline - args.current_time;
    1e66:	fc843783          	ld	a5,-56(s0)
    1e6a:	4bb8                	lw	a4,80(a5)
    1e6c:	409c                	lw	a5,0(s1)
    1e6e:	40f707bb          	subw	a5,a4,a5
    1e72:	2781                	sext.w	a5,a5
    1e74:	f2f42c23          	sw	a5,-200(s0)
        if (thread_rm->remaining_time < r.allocated_time)
    1e78:	fc843783          	ld	a5,-56(s0)
    1e7c:	47f8                	lw	a4,76(a5)
    1e7e:	f3842783          	lw	a5,-200(s0)
    1e82:	00f75763          	bge	a4,a5,1e90 <schedule_rm+0x1e4>
            r.allocated_time = thread_rm->remaining_time; 
    1e86:	fc843783          	ld	a5,-56(s0)
    1e8a:	47fc                	lw	a5,76(a5)
    1e8c:	f2f42c23          	sw	a5,-200(s0)

        // look for higer priority thread in release_queue
        struct release_queue_entry *rqe;
        int intval = 9999;
    1e90:	6789                	lui	a5,0x2
    1e92:	70f78793          	addi	a5,a5,1807 # 270f <__BSS_END__+0x5cf>
    1e96:	f8f42e23          	sw	a5,-100(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list) {
    1e9a:	689c                	ld	a5,16(s1)
    1e9c:	639c                	ld	a5,0(a5)
    1e9e:	f8f43023          	sd	a5,-128(s0)
    1ea2:	f8043783          	ld	a5,-128(s0)
    1ea6:	17e1                	addi	a5,a5,-8
    1ea8:	faf43023          	sd	a5,-96(s0)
    1eac:	a881                	j	1efc <schedule_rm+0x250>
          if (rqe->thrd->period < thread_rm->period){
    1eae:	fa043783          	ld	a5,-96(s0)
    1eb2:	639c                	ld	a5,0(a5)
    1eb4:	43f8                	lw	a4,68(a5)
    1eb6:	fc843783          	ld	a5,-56(s0)
    1eba:	43fc                	lw	a5,68(a5)
    1ebc:	02f75663          	bge	a4,a5,1ee8 <schedule_rm+0x23c>
              int tmp = rqe->release_time - args.current_time; 
    1ec0:	fa043783          	ld	a5,-96(s0)
    1ec4:	4f98                	lw	a4,24(a5)
    1ec6:	409c                	lw	a5,0(s1)
    1ec8:	40f707bb          	subw	a5,a4,a5
    1ecc:	f6f42e23          	sw	a5,-132(s0)
              if (tmp < intval)
    1ed0:	f7c42703          	lw	a4,-132(s0)
    1ed4:	f9c42783          	lw	a5,-100(s0)
    1ed8:	2701                	sext.w	a4,a4
    1eda:	2781                	sext.w	a5,a5
    1edc:	00f75663          	bge	a4,a5,1ee8 <schedule_rm+0x23c>
                intval = tmp;
    1ee0:	f7c42783          	lw	a5,-132(s0)
    1ee4:	f8f42e23          	sw	a5,-100(s0)
        list_for_each_entry(rqe, args.release_queue, thread_list) {
    1ee8:	fa043783          	ld	a5,-96(s0)
    1eec:	679c                	ld	a5,8(a5)
    1eee:	f6f43823          	sd	a5,-144(s0)
    1ef2:	f7043783          	ld	a5,-144(s0)
    1ef6:	17e1                	addi	a5,a5,-8
    1ef8:	faf43023          	sd	a5,-96(s0)
    1efc:	fa043783          	ld	a5,-96(s0)
    1f00:	00878713          	addi	a4,a5,8
    1f04:	689c                	ld	a5,16(s1)
    1f06:	faf714e3          	bne	a4,a5,1eae <schedule_rm+0x202>
          }
        }

        if (intval < r.allocated_time)
    1f0a:	f3842703          	lw	a4,-200(s0)
    1f0e:	f9c42783          	lw	a5,-100(s0)
    1f12:	2781                	sext.w	a5,a5
    1f14:	00e7d663          	bge	a5,a4,1f20 <schedule_rm+0x274>
            r.allocated_time = intval;
    1f18:	f9c42783          	lw	a5,-100(s0)
    1f1c:	f2f42c23          	sw	a5,-200(s0)
    }

    return r;
    1f20:	f3043783          	ld	a5,-208(s0)
    1f24:	f4f43023          	sd	a5,-192(s0)
    1f28:	f3843783          	ld	a5,-200(s0)
    1f2c:	f4f43423          	sd	a5,-184(s0)
}
    1f30:	f4043703          	ld	a4,-192(s0)
    1f34:	f4843783          	ld	a5,-184(s0)
    1f38:	893a                	mv	s2,a4
    1f3a:	89be                	mv	s3,a5
    1f3c:	874a                	mv	a4,s2
    1f3e:	87ce                	mv	a5,s3
    1f40:	853a                	mv	a0,a4
    1f42:	85be                	mv	a1,a5
    1f44:	60ae                	ld	ra,200(sp)
    1f46:	640e                	ld	s0,192(sp)
    1f48:	74ea                	ld	s1,184(sp)
    1f4a:	794a                	ld	s2,176(sp)
    1f4c:	79aa                	ld	s3,168(sp)
    1f4e:	6169                	addi	sp,sp,208
    1f50:	8082                	ret
