
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	1902                	slli	s2,s2,0x20
  1e:	02095913          	srli	s2,s2,0x20
  22:	090e                	slli	s2,s2,0x3
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	30c080e7          	jalr	780(ra) # 336 <unlink>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: rm files...\n");
  3e:	00000597          	auipc	a1,0x0
  42:	7ca58593          	addi	a1,a1,1994 # 808 <malloc+0xe4>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	5f0080e7          	jalr	1520(ra) # 638 <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	294080e7          	jalr	660(ra) # 2e6 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00000597          	auipc	a1,0x0
  60:	7c458593          	addi	a1,a1,1988 # 820 <malloc+0xfc>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	5d2080e7          	jalr	1490(ra) # 638 <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	276080e7          	jalr	630(ra) # 2e6 <exit>

0000000000000078 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0x8>
    ;
  return os;
}
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb91                	beqz	a5,b2 <strcmp+0x1e>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71763          	bne	a4,a5,b2 <strcmp+0x1e>
    p++, q++;
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	fbe5                	bnez	a5,a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b2:	0005c503          	lbu	a0,0(a1)
}
  b6:	40a7853b          	subw	a0,a5,a0
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cf91                	beqz	a5,e6 <strlen+0x26>
  cc:	0505                	addi	a0,a0,1
  ce:	87aa                	mv	a5,a0
  d0:	4685                	li	a3,1
  d2:	9e89                	subw	a3,a3,a0
  d4:	00f6853b          	addw	a0,a3,a5
  d8:	0785                	addi	a5,a5,1
  da:	fff7c703          	lbu	a4,-1(a5)
  de:	fb7d                	bnez	a4,d4 <strlen+0x14>
    ;
  return n;
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  for(n = 0; s[n]; n++)
  e6:	4501                	li	a0,0
  e8:	bfe5                	j	e0 <strlen+0x20>

00000000000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f0:	ca19                	beqz	a2,106 <memset+0x1c>
  f2:	87aa                	mv	a5,a0
  f4:	1602                	slli	a2,a2,0x20
  f6:	9201                	srli	a2,a2,0x20
  f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 100:	0785                	addi	a5,a5,1
 102:	fee79de3          	bne	a5,a4,fc <memset+0x12>
  }
  return dst;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strchr>:

char*
strchr(const char *s, char c)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  for(; *s; s++)
 112:	00054783          	lbu	a5,0(a0)
 116:	cb99                	beqz	a5,12c <strchr+0x20>
    if(*s == c)
 118:	00f58763          	beq	a1,a5,126 <strchr+0x1a>
  for(; *s; s++)
 11c:	0505                	addi	a0,a0,1
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbfd                	bnez	a5,118 <strchr+0xc>
      return (char*)s;
  return 0;
 124:	4501                	li	a0,0
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  return 0;
 12c:	4501                	li	a0,0
 12e:	bfe5                	j	126 <strchr+0x1a>

0000000000000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	711d                	addi	sp,sp,-96
 132:	ec86                	sd	ra,88(sp)
 134:	e8a2                	sd	s0,80(sp)
 136:	e4a6                	sd	s1,72(sp)
 138:	e0ca                	sd	s2,64(sp)
 13a:	fc4e                	sd	s3,56(sp)
 13c:	f852                	sd	s4,48(sp)
 13e:	f456                	sd	s5,40(sp)
 140:	f05a                	sd	s6,32(sp)
 142:	ec5e                	sd	s7,24(sp)
 144:	1080                	addi	s0,sp,96
 146:	8baa                	mv	s7,a0
 148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14e:	4aa9                	li	s5,10
 150:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 152:	89a6                	mv	s3,s1
 154:	2485                	addiw	s1,s1,1
 156:	0344d863          	bge	s1,s4,186 <gets+0x56>
    cc = read(0, &c, 1);
 15a:	4605                	li	a2,1
 15c:	faf40593          	addi	a1,s0,-81
 160:	4501                	li	a0,0
 162:	00000097          	auipc	ra,0x0
 166:	19c080e7          	jalr	412(ra) # 2fe <read>
    if(cc < 1)
 16a:	00a05e63          	blez	a0,186 <gets+0x56>
    buf[i++] = c;
 16e:	faf44783          	lbu	a5,-81(s0)
 172:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 176:	01578763          	beq	a5,s5,184 <gets+0x54>
 17a:	0905                	addi	s2,s2,1
 17c:	fd679be3          	bne	a5,s6,152 <gets+0x22>
  for(i=0; i+1 < max; ){
 180:	89a6                	mv	s3,s1
 182:	a011                	j	186 <gets+0x56>
 184:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 186:	99de                	add	s3,s3,s7
 188:	00098023          	sb	zero,0(s3)
  return buf;
}
 18c:	855e                	mv	a0,s7
 18e:	60e6                	ld	ra,88(sp)
 190:	6446                	ld	s0,80(sp)
 192:	64a6                	ld	s1,72(sp)
 194:	6906                	ld	s2,64(sp)
 196:	79e2                	ld	s3,56(sp)
 198:	7a42                	ld	s4,48(sp)
 19a:	7aa2                	ld	s5,40(sp)
 19c:	7b02                	ld	s6,32(sp)
 19e:	6be2                	ld	s7,24(sp)
 1a0:	6125                	addi	sp,sp,96
 1a2:	8082                	ret

00000000000001a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a4:	1101                	addi	sp,sp,-32
 1a6:	ec06                	sd	ra,24(sp)
 1a8:	e822                	sd	s0,16(sp)
 1aa:	e426                	sd	s1,8(sp)
 1ac:	e04a                	sd	s2,0(sp)
 1ae:	1000                	addi	s0,sp,32
 1b0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b2:	4581                	li	a1,0
 1b4:	00000097          	auipc	ra,0x0
 1b8:	172080e7          	jalr	370(ra) # 326 <open>
  if(fd < 0)
 1bc:	02054563          	bltz	a0,1e6 <stat+0x42>
 1c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c2:	85ca                	mv	a1,s2
 1c4:	00000097          	auipc	ra,0x0
 1c8:	17a080e7          	jalr	378(ra) # 33e <fstat>
 1cc:	892a                	mv	s2,a0
  close(fd);
 1ce:	8526                	mv	a0,s1
 1d0:	00000097          	auipc	ra,0x0
 1d4:	13e080e7          	jalr	318(ra) # 30e <close>
  return r;
}
 1d8:	854a                	mv	a0,s2
 1da:	60e2                	ld	ra,24(sp)
 1dc:	6442                	ld	s0,16(sp)
 1de:	64a2                	ld	s1,8(sp)
 1e0:	6902                	ld	s2,0(sp)
 1e2:	6105                	addi	sp,sp,32
 1e4:	8082                	ret
    return -1;
 1e6:	597d                	li	s2,-1
 1e8:	bfc5                	j	1d8 <stat+0x34>

00000000000001ea <atoi>:

int
atoi(const char *s)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f0:	00054603          	lbu	a2,0(a0)
 1f4:	fd06079b          	addiw	a5,a2,-48
 1f8:	0ff7f793          	andi	a5,a5,255
 1fc:	4725                	li	a4,9
 1fe:	02f76963          	bltu	a4,a5,230 <atoi+0x46>
 202:	86aa                	mv	a3,a0
  n = 0;
 204:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 206:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 208:	0685                	addi	a3,a3,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb1                	addw	a5,a5,a2
 216:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21a:	0006c603          	lbu	a2,0(a3)
 21e:	fd06071b          	addiw	a4,a2,-48
 222:	0ff77713          	andi	a4,a4,255
 226:	fee5f1e3          	bgeu	a1,a4,208 <atoi+0x1e>
  return n;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
  n = 0;
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <atoi+0x40>

0000000000000234 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23a:	02b57463          	bgeu	a0,a1,262 <memmove+0x2e>
    while(n-- > 0)
 23e:	00c05f63          	blez	a2,25c <memmove+0x28>
 242:	1602                	slli	a2,a2,0x20
 244:	9201                	srli	a2,a2,0x20
 246:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24a:	872a                	mv	a4,a0
      *dst++ = *src++;
 24c:	0585                	addi	a1,a1,1
 24e:	0705                	addi	a4,a4,1
 250:	fff5c683          	lbu	a3,-1(a1)
 254:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 258:	fee79ae3          	bne	a5,a4,24c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
    dst += n;
 262:	00c50733          	add	a4,a0,a2
    src += n;
 266:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 268:	fec05ae3          	blez	a2,25c <memmove+0x28>
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x46>
 28a:	bfc9                	j	25c <memmove+0x28>

000000000000028c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 292:	ca05                	beqz	a2,2c2 <memcmp+0x36>
 294:	fff6069b          	addiw	a3,a2,-1
 298:	1682                	slli	a3,a3,0x20
 29a:	9281                	srli	a3,a3,0x20
 29c:	0685                	addi	a3,a3,1
 29e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00e79863          	bne	a5,a4,2b8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ac:	0505                	addi	a0,a0,1
    p2++;
 2ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b0:	fed518e3          	bne	a0,a3,2a0 <memcmp+0x14>
  }
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	a019                	j	2bc <memcmp+0x30>
      return *p1 - *p2;
 2b8:	40e7853b          	subw	a0,a5,a4
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <memcmp+0x30>

00000000000002c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ce:	00000097          	auipc	ra,0x0
 2d2:	f66080e7          	jalr	-154(ra) # 234 <memmove>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2de:	4885                	li	a7,1
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e6:	4889                	li	a7,2
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ee:	488d                	li	a7,3
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f6:	4891                	li	a7,4
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <read>:
.global read
read:
 li a7, SYS_read
 2fe:	4895                	li	a7,5
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <write>:
.global write
write:
 li a7, SYS_write
 306:	48c1                	li	a7,16
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <close>:
.global close
close:
 li a7, SYS_close
 30e:	48d5                	li	a7,21
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <kill>:
.global kill
kill:
 li a7, SYS_kill
 316:	4899                	li	a7,6
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exec>:
.global exec
exec:
 li a7, SYS_exec
 31e:	489d                	li	a7,7
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <open>:
.global open
open:
 li a7, SYS_open
 326:	48bd                	li	a7,15
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32e:	48c5                	li	a7,17
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 336:	48c9                	li	a7,18
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33e:	48a1                	li	a7,8
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <link>:
.global link
link:
 li a7, SYS_link
 346:	48cd                	li	a7,19
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34e:	48d1                	li	a7,20
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 356:	48a5                	li	a7,9
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <dup>:
.global dup
dup:
 li a7, SYS_dup
 35e:	48a9                	li	a7,10
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 366:	48ad                	li	a7,11
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 36e:	48b1                	li	a7,12
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 376:	48b5                	li	a7,13
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37e:	48b9                	li	a7,14
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 386:	48d9                	li	a7,22
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38e:	1101                	addi	sp,sp,-32
 390:	ec06                	sd	ra,24(sp)
 392:	e822                	sd	s0,16(sp)
 394:	1000                	addi	s0,sp,32
 396:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39a:	4605                	li	a2,1
 39c:	fef40593          	addi	a1,s0,-17
 3a0:	00000097          	auipc	ra,0x0
 3a4:	f66080e7          	jalr	-154(ra) # 306 <write>
}
 3a8:	60e2                	ld	ra,24(sp)
 3aa:	6442                	ld	s0,16(sp)
 3ac:	6105                	addi	sp,sp,32
 3ae:	8082                	ret

00000000000003b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	7139                	addi	sp,sp,-64
 3b2:	fc06                	sd	ra,56(sp)
 3b4:	f822                	sd	s0,48(sp)
 3b6:	f426                	sd	s1,40(sp)
 3b8:	f04a                	sd	s2,32(sp)
 3ba:	ec4e                	sd	s3,24(sp)
 3bc:	0080                	addi	s0,sp,64
 3be:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c0:	c299                	beqz	a3,3c6 <printint+0x16>
 3c2:	0805c863          	bltz	a1,452 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c6:	2581                	sext.w	a1,a1
  neg = 0;
 3c8:	4881                	li	a7,0
 3ca:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3ce:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d0:	2601                	sext.w	a2,a2
 3d2:	00000517          	auipc	a0,0x0
 3d6:	47650513          	addi	a0,a0,1142 # 848 <digits>
 3da:	883a                	mv	a6,a4
 3dc:	2705                	addiw	a4,a4,1
 3de:	02c5f7bb          	remuw	a5,a1,a2
 3e2:	1782                	slli	a5,a5,0x20
 3e4:	9381                	srli	a5,a5,0x20
 3e6:	97aa                	add	a5,a5,a0
 3e8:	0007c783          	lbu	a5,0(a5)
 3ec:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f0:	0005879b          	sext.w	a5,a1
 3f4:	02c5d5bb          	divuw	a1,a1,a2
 3f8:	0685                	addi	a3,a3,1
 3fa:	fec7f0e3          	bgeu	a5,a2,3da <printint+0x2a>
  if(neg)
 3fe:	00088b63          	beqz	a7,414 <printint+0x64>
    buf[i++] = '-';
 402:	fd040793          	addi	a5,s0,-48
 406:	973e                	add	a4,a4,a5
 408:	02d00793          	li	a5,45
 40c:	fef70823          	sb	a5,-16(a4)
 410:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 414:	02e05863          	blez	a4,444 <printint+0x94>
 418:	fc040793          	addi	a5,s0,-64
 41c:	00e78933          	add	s2,a5,a4
 420:	fff78993          	addi	s3,a5,-1
 424:	99ba                	add	s3,s3,a4
 426:	377d                	addiw	a4,a4,-1
 428:	1702                	slli	a4,a4,0x20
 42a:	9301                	srli	a4,a4,0x20
 42c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 430:	fff94583          	lbu	a1,-1(s2)
 434:	8526                	mv	a0,s1
 436:	00000097          	auipc	ra,0x0
 43a:	f58080e7          	jalr	-168(ra) # 38e <putc>
  while(--i >= 0)
 43e:	197d                	addi	s2,s2,-1
 440:	ff3918e3          	bne	s2,s3,430 <printint+0x80>
}
 444:	70e2                	ld	ra,56(sp)
 446:	7442                	ld	s0,48(sp)
 448:	74a2                	ld	s1,40(sp)
 44a:	7902                	ld	s2,32(sp)
 44c:	69e2                	ld	s3,24(sp)
 44e:	6121                	addi	sp,sp,64
 450:	8082                	ret
    x = -xx;
 452:	40b005bb          	negw	a1,a1
    neg = 1;
 456:	4885                	li	a7,1
    x = -xx;
 458:	bf8d                	j	3ca <printint+0x1a>

000000000000045a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 45a:	7119                	addi	sp,sp,-128
 45c:	fc86                	sd	ra,120(sp)
 45e:	f8a2                	sd	s0,112(sp)
 460:	f4a6                	sd	s1,104(sp)
 462:	f0ca                	sd	s2,96(sp)
 464:	ecce                	sd	s3,88(sp)
 466:	e8d2                	sd	s4,80(sp)
 468:	e4d6                	sd	s5,72(sp)
 46a:	e0da                	sd	s6,64(sp)
 46c:	fc5e                	sd	s7,56(sp)
 46e:	f862                	sd	s8,48(sp)
 470:	f466                	sd	s9,40(sp)
 472:	f06a                	sd	s10,32(sp)
 474:	ec6e                	sd	s11,24(sp)
 476:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 478:	0005c903          	lbu	s2,0(a1)
 47c:	18090f63          	beqz	s2,61a <vprintf+0x1c0>
 480:	8aaa                	mv	s5,a0
 482:	8b32                	mv	s6,a2
 484:	00158493          	addi	s1,a1,1
  state = 0;
 488:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 48a:	02500a13          	li	s4,37
      if(c == 'd'){
 48e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 492:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 496:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 49a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 49e:	00000b97          	auipc	s7,0x0
 4a2:	3aab8b93          	addi	s7,s7,938 # 848 <digits>
 4a6:	a839                	j	4c4 <vprintf+0x6a>
        putc(fd, c);
 4a8:	85ca                	mv	a1,s2
 4aa:	8556                	mv	a0,s5
 4ac:	00000097          	auipc	ra,0x0
 4b0:	ee2080e7          	jalr	-286(ra) # 38e <putc>
 4b4:	a019                	j	4ba <vprintf+0x60>
    } else if(state == '%'){
 4b6:	01498f63          	beq	s3,s4,4d4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4ba:	0485                	addi	s1,s1,1
 4bc:	fff4c903          	lbu	s2,-1(s1)
 4c0:	14090d63          	beqz	s2,61a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4c4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4c8:	fe0997e3          	bnez	s3,4b6 <vprintf+0x5c>
      if(c == '%'){
 4cc:	fd479ee3          	bne	a5,s4,4a8 <vprintf+0x4e>
        state = '%';
 4d0:	89be                	mv	s3,a5
 4d2:	b7e5                	j	4ba <vprintf+0x60>
      if(c == 'd'){
 4d4:	05878063          	beq	a5,s8,514 <vprintf+0xba>
      } else if(c == 'l') {
 4d8:	05978c63          	beq	a5,s9,530 <vprintf+0xd6>
      } else if(c == 'x') {
 4dc:	07a78863          	beq	a5,s10,54c <vprintf+0xf2>
      } else if(c == 'p') {
 4e0:	09b78463          	beq	a5,s11,568 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4e4:	07300713          	li	a4,115
 4e8:	0ce78663          	beq	a5,a4,5b4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ec:	06300713          	li	a4,99
 4f0:	0ee78e63          	beq	a5,a4,5ec <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4f4:	11478863          	beq	a5,s4,604 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4f8:	85d2                	mv	a1,s4
 4fa:	8556                	mv	a0,s5
 4fc:	00000097          	auipc	ra,0x0
 500:	e92080e7          	jalr	-366(ra) # 38e <putc>
        putc(fd, c);
 504:	85ca                	mv	a1,s2
 506:	8556                	mv	a0,s5
 508:	00000097          	auipc	ra,0x0
 50c:	e86080e7          	jalr	-378(ra) # 38e <putc>
      }
      state = 0;
 510:	4981                	li	s3,0
 512:	b765                	j	4ba <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 514:	008b0913          	addi	s2,s6,8
 518:	4685                	li	a3,1
 51a:	4629                	li	a2,10
 51c:	000b2583          	lw	a1,0(s6)
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	e8e080e7          	jalr	-370(ra) # 3b0 <printint>
 52a:	8b4a                	mv	s6,s2
      state = 0;
 52c:	4981                	li	s3,0
 52e:	b771                	j	4ba <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 530:	008b0913          	addi	s2,s6,8
 534:	4681                	li	a3,0
 536:	4629                	li	a2,10
 538:	000b2583          	lw	a1,0(s6)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e72080e7          	jalr	-398(ra) # 3b0 <printint>
 546:	8b4a                	mv	s6,s2
      state = 0;
 548:	4981                	li	s3,0
 54a:	bf85                	j	4ba <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 54c:	008b0913          	addi	s2,s6,8
 550:	4681                	li	a3,0
 552:	4641                	li	a2,16
 554:	000b2583          	lw	a1,0(s6)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e56080e7          	jalr	-426(ra) # 3b0 <printint>
 562:	8b4a                	mv	s6,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	bf91                	j	4ba <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 568:	008b0793          	addi	a5,s6,8
 56c:	f8f43423          	sd	a5,-120(s0)
 570:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 574:	03000593          	li	a1,48
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e14080e7          	jalr	-492(ra) # 38e <putc>
  putc(fd, 'x');
 582:	85ea                	mv	a1,s10
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	e08080e7          	jalr	-504(ra) # 38e <putc>
 58e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 590:	03c9d793          	srli	a5,s3,0x3c
 594:	97de                	add	a5,a5,s7
 596:	0007c583          	lbu	a1,0(a5)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	df2080e7          	jalr	-526(ra) # 38e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5a4:	0992                	slli	s3,s3,0x4
 5a6:	397d                	addiw	s2,s2,-1
 5a8:	fe0914e3          	bnez	s2,590 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5ac:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b721                	j	4ba <vprintf+0x60>
        s = va_arg(ap, char*);
 5b4:	008b0993          	addi	s3,s6,8
 5b8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5bc:	02090163          	beqz	s2,5de <vprintf+0x184>
        while(*s != 0){
 5c0:	00094583          	lbu	a1,0(s2)
 5c4:	c9a1                	beqz	a1,614 <vprintf+0x1ba>
          putc(fd, *s);
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	dc6080e7          	jalr	-570(ra) # 38e <putc>
          s++;
 5d0:	0905                	addi	s2,s2,1
        while(*s != 0){
 5d2:	00094583          	lbu	a1,0(s2)
 5d6:	f9e5                	bnez	a1,5c6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5d8:	8b4e                	mv	s6,s3
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bdf9                	j	4ba <vprintf+0x60>
          s = "(null)";
 5de:	00000917          	auipc	s2,0x0
 5e2:	26290913          	addi	s2,s2,610 # 840 <malloc+0x11c>
        while(*s != 0){
 5e6:	02800593          	li	a1,40
 5ea:	bff1                	j	5c6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5ec:	008b0913          	addi	s2,s6,8
 5f0:	000b4583          	lbu	a1,0(s6)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	d98080e7          	jalr	-616(ra) # 38e <putc>
 5fe:	8b4a                	mv	s6,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	bd65                	j	4ba <vprintf+0x60>
        putc(fd, c);
 604:	85d2                	mv	a1,s4
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	d86080e7          	jalr	-634(ra) # 38e <putc>
      state = 0;
 610:	4981                	li	s3,0
 612:	b565                	j	4ba <vprintf+0x60>
        s = va_arg(ap, char*);
 614:	8b4e                	mv	s6,s3
      state = 0;
 616:	4981                	li	s3,0
 618:	b54d                	j	4ba <vprintf+0x60>
    }
  }
}
 61a:	70e6                	ld	ra,120(sp)
 61c:	7446                	ld	s0,112(sp)
 61e:	74a6                	ld	s1,104(sp)
 620:	7906                	ld	s2,96(sp)
 622:	69e6                	ld	s3,88(sp)
 624:	6a46                	ld	s4,80(sp)
 626:	6aa6                	ld	s5,72(sp)
 628:	6b06                	ld	s6,64(sp)
 62a:	7be2                	ld	s7,56(sp)
 62c:	7c42                	ld	s8,48(sp)
 62e:	7ca2                	ld	s9,40(sp)
 630:	7d02                	ld	s10,32(sp)
 632:	6de2                	ld	s11,24(sp)
 634:	6109                	addi	sp,sp,128
 636:	8082                	ret

0000000000000638 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 638:	715d                	addi	sp,sp,-80
 63a:	ec06                	sd	ra,24(sp)
 63c:	e822                	sd	s0,16(sp)
 63e:	1000                	addi	s0,sp,32
 640:	e010                	sd	a2,0(s0)
 642:	e414                	sd	a3,8(s0)
 644:	e818                	sd	a4,16(s0)
 646:	ec1c                	sd	a5,24(s0)
 648:	03043023          	sd	a6,32(s0)
 64c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 650:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 654:	8622                	mv	a2,s0
 656:	00000097          	auipc	ra,0x0
 65a:	e04080e7          	jalr	-508(ra) # 45a <vprintf>
}
 65e:	60e2                	ld	ra,24(sp)
 660:	6442                	ld	s0,16(sp)
 662:	6161                	addi	sp,sp,80
 664:	8082                	ret

0000000000000666 <printf>:

void
printf(const char *fmt, ...)
{
 666:	711d                	addi	sp,sp,-96
 668:	ec06                	sd	ra,24(sp)
 66a:	e822                	sd	s0,16(sp)
 66c:	1000                	addi	s0,sp,32
 66e:	e40c                	sd	a1,8(s0)
 670:	e810                	sd	a2,16(s0)
 672:	ec14                	sd	a3,24(s0)
 674:	f018                	sd	a4,32(s0)
 676:	f41c                	sd	a5,40(s0)
 678:	03043823          	sd	a6,48(s0)
 67c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 680:	00840613          	addi	a2,s0,8
 684:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 688:	85aa                	mv	a1,a0
 68a:	4505                	li	a0,1
 68c:	00000097          	auipc	ra,0x0
 690:	dce080e7          	jalr	-562(ra) # 45a <vprintf>
}
 694:	60e2                	ld	ra,24(sp)
 696:	6442                	ld	s0,16(sp)
 698:	6125                	addi	sp,sp,96
 69a:	8082                	ret

000000000000069c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69c:	1141                	addi	sp,sp,-16
 69e:	e422                	sd	s0,8(sp)
 6a0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a6:	00000797          	auipc	a5,0x0
 6aa:	1ba7b783          	ld	a5,442(a5) # 860 <freep>
 6ae:	a805                	j	6de <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6b0:	4618                	lw	a4,8(a2)
 6b2:	9db9                	addw	a1,a1,a4
 6b4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b8:	6398                	ld	a4,0(a5)
 6ba:	6318                	ld	a4,0(a4)
 6bc:	fee53823          	sd	a4,-16(a0)
 6c0:	a091                	j	704 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c2:	ff852703          	lw	a4,-8(a0)
 6c6:	9e39                	addw	a2,a2,a4
 6c8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6ca:	ff053703          	ld	a4,-16(a0)
 6ce:	e398                	sd	a4,0(a5)
 6d0:	a099                	j	716 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d2:	6398                	ld	a4,0(a5)
 6d4:	00e7e463          	bltu	a5,a4,6dc <free+0x40>
 6d8:	00e6ea63          	bltu	a3,a4,6ec <free+0x50>
{
 6dc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6de:	fed7fae3          	bgeu	a5,a3,6d2 <free+0x36>
 6e2:	6398                	ld	a4,0(a5)
 6e4:	00e6e463          	bltu	a3,a4,6ec <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e8:	fee7eae3          	bltu	a5,a4,6dc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6ec:	ff852583          	lw	a1,-8(a0)
 6f0:	6390                	ld	a2,0(a5)
 6f2:	02059713          	slli	a4,a1,0x20
 6f6:	9301                	srli	a4,a4,0x20
 6f8:	0712                	slli	a4,a4,0x4
 6fa:	9736                	add	a4,a4,a3
 6fc:	fae60ae3          	beq	a2,a4,6b0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 700:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 704:	4790                	lw	a2,8(a5)
 706:	02061713          	slli	a4,a2,0x20
 70a:	9301                	srli	a4,a4,0x20
 70c:	0712                	slli	a4,a4,0x4
 70e:	973e                	add	a4,a4,a5
 710:	fae689e3          	beq	a3,a4,6c2 <free+0x26>
  } else
    p->s.ptr = bp;
 714:	e394                	sd	a3,0(a5)
  freep = p;
 716:	00000717          	auipc	a4,0x0
 71a:	14f73523          	sd	a5,330(a4) # 860 <freep>
}
 71e:	6422                	ld	s0,8(sp)
 720:	0141                	addi	sp,sp,16
 722:	8082                	ret

0000000000000724 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 724:	7139                	addi	sp,sp,-64
 726:	fc06                	sd	ra,56(sp)
 728:	f822                	sd	s0,48(sp)
 72a:	f426                	sd	s1,40(sp)
 72c:	f04a                	sd	s2,32(sp)
 72e:	ec4e                	sd	s3,24(sp)
 730:	e852                	sd	s4,16(sp)
 732:	e456                	sd	s5,8(sp)
 734:	e05a                	sd	s6,0(sp)
 736:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 738:	02051493          	slli	s1,a0,0x20
 73c:	9081                	srli	s1,s1,0x20
 73e:	04bd                	addi	s1,s1,15
 740:	8091                	srli	s1,s1,0x4
 742:	0014899b          	addiw	s3,s1,1
 746:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 748:	00000517          	auipc	a0,0x0
 74c:	11853503          	ld	a0,280(a0) # 860 <freep>
 750:	c515                	beqz	a0,77c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 752:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 754:	4798                	lw	a4,8(a5)
 756:	02977f63          	bgeu	a4,s1,794 <malloc+0x70>
 75a:	8a4e                	mv	s4,s3
 75c:	0009871b          	sext.w	a4,s3
 760:	6685                	lui	a3,0x1
 762:	00d77363          	bgeu	a4,a3,768 <malloc+0x44>
 766:	6a05                	lui	s4,0x1
 768:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 76c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 770:	00000917          	auipc	s2,0x0
 774:	0f090913          	addi	s2,s2,240 # 860 <freep>
  if(p == (char*)-1)
 778:	5afd                	li	s5,-1
 77a:	a88d                	j	7ec <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 77c:	00000797          	auipc	a5,0x0
 780:	0ec78793          	addi	a5,a5,236 # 868 <base>
 784:	00000717          	auipc	a4,0x0
 788:	0cf73e23          	sd	a5,220(a4) # 860 <freep>
 78c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 78e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 792:	b7e1                	j	75a <malloc+0x36>
      if(p->s.size == nunits)
 794:	02e48b63          	beq	s1,a4,7ca <malloc+0xa6>
        p->s.size -= nunits;
 798:	4137073b          	subw	a4,a4,s3
 79c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 79e:	1702                	slli	a4,a4,0x20
 7a0:	9301                	srli	a4,a4,0x20
 7a2:	0712                	slli	a4,a4,0x4
 7a4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7a6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7aa:	00000717          	auipc	a4,0x0
 7ae:	0aa73b23          	sd	a0,182(a4) # 860 <freep>
      return (void*)(p + 1);
 7b2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b6:	70e2                	ld	ra,56(sp)
 7b8:	7442                	ld	s0,48(sp)
 7ba:	74a2                	ld	s1,40(sp)
 7bc:	7902                	ld	s2,32(sp)
 7be:	69e2                	ld	s3,24(sp)
 7c0:	6a42                	ld	s4,16(sp)
 7c2:	6aa2                	ld	s5,8(sp)
 7c4:	6b02                	ld	s6,0(sp)
 7c6:	6121                	addi	sp,sp,64
 7c8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7ca:	6398                	ld	a4,0(a5)
 7cc:	e118                	sd	a4,0(a0)
 7ce:	bff1                	j	7aa <malloc+0x86>
  hp->s.size = nu;
 7d0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7d4:	0541                	addi	a0,a0,16
 7d6:	00000097          	auipc	ra,0x0
 7da:	ec6080e7          	jalr	-314(ra) # 69c <free>
  return freep;
 7de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7e2:	d971                	beqz	a0,7b6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e6:	4798                	lw	a4,8(a5)
 7e8:	fa9776e3          	bgeu	a4,s1,794 <malloc+0x70>
    if(p == freep)
 7ec:	00093703          	ld	a4,0(s2)
 7f0:	853e                	mv	a0,a5
 7f2:	fef719e3          	bne	a4,a5,7e4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7f6:	8552                	mv	a0,s4
 7f8:	00000097          	auipc	ra,0x0
 7fc:	b76080e7          	jalr	-1162(ra) # 36e <sbrk>
  if(p == (char*)-1)
 800:	fd5518e3          	bne	a0,s5,7d0 <malloc+0xac>
        return 0;
 804:	4501                	li	a0,0
 806:	bf45                	j	7b6 <malloc+0x92>
