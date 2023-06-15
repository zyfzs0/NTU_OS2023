
user/_symlinkdir_private:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/sleeplock.h"
#include "kernel/fs.h"
#include "kernel/file.h"
#include "user/user.h"

int main() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  exit(0);
   8:	4501                	li	a0,0
   a:	00000097          	auipc	ra,0x0
   e:	276080e7          	jalr	630(ra) # 280 <exit>

0000000000000012 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  12:	1141                	addi	sp,sp,-16
  14:	e422                	sd	s0,8(sp)
  16:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  18:	87aa                	mv	a5,a0
  1a:	0585                	addi	a1,a1,1
  1c:	0785                	addi	a5,a5,1
  1e:	fff5c703          	lbu	a4,-1(a1)
  22:	fee78fa3          	sb	a4,-1(a5)
  26:	fb75                	bnez	a4,1a <strcpy+0x8>
    ;
  return os;
}
  28:	6422                	ld	s0,8(sp)
  2a:	0141                	addi	sp,sp,16
  2c:	8082                	ret

000000000000002e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  2e:	1141                	addi	sp,sp,-16
  30:	e422                	sd	s0,8(sp)
  32:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  34:	00054783          	lbu	a5,0(a0)
  38:	cb91                	beqz	a5,4c <strcmp+0x1e>
  3a:	0005c703          	lbu	a4,0(a1)
  3e:	00f71763          	bne	a4,a5,4c <strcmp+0x1e>
    p++, q++;
  42:	0505                	addi	a0,a0,1
  44:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  46:	00054783          	lbu	a5,0(a0)
  4a:	fbe5                	bnez	a5,3a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  4c:	0005c503          	lbu	a0,0(a1)
}
  50:	40a7853b          	subw	a0,a5,a0
  54:	6422                	ld	s0,8(sp)
  56:	0141                	addi	sp,sp,16
  58:	8082                	ret

000000000000005a <strlen>:

uint
strlen(const char *s)
{
  5a:	1141                	addi	sp,sp,-16
  5c:	e422                	sd	s0,8(sp)
  5e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  60:	00054783          	lbu	a5,0(a0)
  64:	cf91                	beqz	a5,80 <strlen+0x26>
  66:	0505                	addi	a0,a0,1
  68:	87aa                	mv	a5,a0
  6a:	4685                	li	a3,1
  6c:	9e89                	subw	a3,a3,a0
  6e:	00f6853b          	addw	a0,a3,a5
  72:	0785                	addi	a5,a5,1
  74:	fff7c703          	lbu	a4,-1(a5)
  78:	fb7d                	bnez	a4,6e <strlen+0x14>
    ;
  return n;
}
  7a:	6422                	ld	s0,8(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret
  for(n = 0; s[n]; n++)
  80:	4501                	li	a0,0
  82:	bfe5                	j	7a <strlen+0x20>

0000000000000084 <memset>:

void*
memset(void *dst, int c, uint n)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  8a:	ca19                	beqz	a2,a0 <memset+0x1c>
  8c:	87aa                	mv	a5,a0
  8e:	1602                	slli	a2,a2,0x20
  90:	9201                	srli	a2,a2,0x20
  92:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  96:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  9a:	0785                	addi	a5,a5,1
  9c:	fee79de3          	bne	a5,a4,96 <memset+0x12>
  }
  return dst;
}
  a0:	6422                	ld	s0,8(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret

00000000000000a6 <strchr>:

char*
strchr(const char *s, char c)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e422                	sd	s0,8(sp)
  aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	cb99                	beqz	a5,c6 <strchr+0x20>
    if(*s == c)
  b2:	00f58763          	beq	a1,a5,c0 <strchr+0x1a>
  for(; *s; s++)
  b6:	0505                	addi	a0,a0,1
  b8:	00054783          	lbu	a5,0(a0)
  bc:	fbfd                	bnez	a5,b2 <strchr+0xc>
      return (char*)s;
  return 0;
  be:	4501                	li	a0,0
}
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret
  return 0;
  c6:	4501                	li	a0,0
  c8:	bfe5                	j	c0 <strchr+0x1a>

00000000000000ca <gets>:

char*
gets(char *buf, int max)
{
  ca:	711d                	addi	sp,sp,-96
  cc:	ec86                	sd	ra,88(sp)
  ce:	e8a2                	sd	s0,80(sp)
  d0:	e4a6                	sd	s1,72(sp)
  d2:	e0ca                	sd	s2,64(sp)
  d4:	fc4e                	sd	s3,56(sp)
  d6:	f852                	sd	s4,48(sp)
  d8:	f456                	sd	s5,40(sp)
  da:	f05a                	sd	s6,32(sp)
  dc:	ec5e                	sd	s7,24(sp)
  de:	1080                	addi	s0,sp,96
  e0:	8baa                	mv	s7,a0
  e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  e4:	892a                	mv	s2,a0
  e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  e8:	4aa9                	li	s5,10
  ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  ec:	89a6                	mv	s3,s1
  ee:	2485                	addiw	s1,s1,1
  f0:	0344d863          	bge	s1,s4,120 <gets+0x56>
    cc = read(0, &c, 1);
  f4:	4605                	li	a2,1
  f6:	faf40593          	addi	a1,s0,-81
  fa:	4501                	li	a0,0
  fc:	00000097          	auipc	ra,0x0
 100:	19c080e7          	jalr	412(ra) # 298 <read>
    if(cc < 1)
 104:	00a05e63          	blez	a0,120 <gets+0x56>
    buf[i++] = c;
 108:	faf44783          	lbu	a5,-81(s0)
 10c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 110:	01578763          	beq	a5,s5,11e <gets+0x54>
 114:	0905                	addi	s2,s2,1
 116:	fd679be3          	bne	a5,s6,ec <gets+0x22>
  for(i=0; i+1 < max; ){
 11a:	89a6                	mv	s3,s1
 11c:	a011                	j	120 <gets+0x56>
 11e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 120:	99de                	add	s3,s3,s7
 122:	00098023          	sb	zero,0(s3)
  return buf;
}
 126:	855e                	mv	a0,s7
 128:	60e6                	ld	ra,88(sp)
 12a:	6446                	ld	s0,80(sp)
 12c:	64a6                	ld	s1,72(sp)
 12e:	6906                	ld	s2,64(sp)
 130:	79e2                	ld	s3,56(sp)
 132:	7a42                	ld	s4,48(sp)
 134:	7aa2                	ld	s5,40(sp)
 136:	7b02                	ld	s6,32(sp)
 138:	6be2                	ld	s7,24(sp)
 13a:	6125                	addi	sp,sp,96
 13c:	8082                	ret

000000000000013e <stat>:

int
stat(const char *n, struct stat *st)
{
 13e:	1101                	addi	sp,sp,-32
 140:	ec06                	sd	ra,24(sp)
 142:	e822                	sd	s0,16(sp)
 144:	e426                	sd	s1,8(sp)
 146:	e04a                	sd	s2,0(sp)
 148:	1000                	addi	s0,sp,32
 14a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14c:	4581                	li	a1,0
 14e:	00000097          	auipc	ra,0x0
 152:	172080e7          	jalr	370(ra) # 2c0 <open>
  if(fd < 0)
 156:	02054563          	bltz	a0,180 <stat+0x42>
 15a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 15c:	85ca                	mv	a1,s2
 15e:	00000097          	auipc	ra,0x0
 162:	17a080e7          	jalr	378(ra) # 2d8 <fstat>
 166:	892a                	mv	s2,a0
  close(fd);
 168:	8526                	mv	a0,s1
 16a:	00000097          	auipc	ra,0x0
 16e:	13e080e7          	jalr	318(ra) # 2a8 <close>
  return r;
}
 172:	854a                	mv	a0,s2
 174:	60e2                	ld	ra,24(sp)
 176:	6442                	ld	s0,16(sp)
 178:	64a2                	ld	s1,8(sp)
 17a:	6902                	ld	s2,0(sp)
 17c:	6105                	addi	sp,sp,32
 17e:	8082                	ret
    return -1;
 180:	597d                	li	s2,-1
 182:	bfc5                	j	172 <stat+0x34>

0000000000000184 <atoi>:

int
atoi(const char *s)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 18a:	00054603          	lbu	a2,0(a0)
 18e:	fd06079b          	addiw	a5,a2,-48
 192:	0ff7f793          	andi	a5,a5,255
 196:	4725                	li	a4,9
 198:	02f76963          	bltu	a4,a5,1ca <atoi+0x46>
 19c:	86aa                	mv	a3,a0
  n = 0;
 19e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1a0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1a2:	0685                	addi	a3,a3,1
 1a4:	0025179b          	slliw	a5,a0,0x2
 1a8:	9fa9                	addw	a5,a5,a0
 1aa:	0017979b          	slliw	a5,a5,0x1
 1ae:	9fb1                	addw	a5,a5,a2
 1b0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1b4:	0006c603          	lbu	a2,0(a3)
 1b8:	fd06071b          	addiw	a4,a2,-48
 1bc:	0ff77713          	andi	a4,a4,255
 1c0:	fee5f1e3          	bgeu	a1,a4,1a2 <atoi+0x1e>
  return n;
}
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret
  n = 0;
 1ca:	4501                	li	a0,0
 1cc:	bfe5                	j	1c4 <atoi+0x40>

00000000000001ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1d4:	02b57463          	bgeu	a0,a1,1fc <memmove+0x2e>
    while(n-- > 0)
 1d8:	00c05f63          	blez	a2,1f6 <memmove+0x28>
 1dc:	1602                	slli	a2,a2,0x20
 1de:	9201                	srli	a2,a2,0x20
 1e0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1e4:	872a                	mv	a4,a0
      *dst++ = *src++;
 1e6:	0585                	addi	a1,a1,1
 1e8:	0705                	addi	a4,a4,1
 1ea:	fff5c683          	lbu	a3,-1(a1)
 1ee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1f2:	fee79ae3          	bne	a5,a4,1e6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret
    dst += n;
 1fc:	00c50733          	add	a4,a0,a2
    src += n;
 200:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 202:	fec05ae3          	blez	a2,1f6 <memmove+0x28>
 206:	fff6079b          	addiw	a5,a2,-1
 20a:	1782                	slli	a5,a5,0x20
 20c:	9381                	srli	a5,a5,0x20
 20e:	fff7c793          	not	a5,a5
 212:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 214:	15fd                	addi	a1,a1,-1
 216:	177d                	addi	a4,a4,-1
 218:	0005c683          	lbu	a3,0(a1)
 21c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 220:	fee79ae3          	bne	a5,a4,214 <memmove+0x46>
 224:	bfc9                	j	1f6 <memmove+0x28>

0000000000000226 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 226:	1141                	addi	sp,sp,-16
 228:	e422                	sd	s0,8(sp)
 22a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 22c:	ca05                	beqz	a2,25c <memcmp+0x36>
 22e:	fff6069b          	addiw	a3,a2,-1
 232:	1682                	slli	a3,a3,0x20
 234:	9281                	srli	a3,a3,0x20
 236:	0685                	addi	a3,a3,1
 238:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 23a:	00054783          	lbu	a5,0(a0)
 23e:	0005c703          	lbu	a4,0(a1)
 242:	00e79863          	bne	a5,a4,252 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 246:	0505                	addi	a0,a0,1
    p2++;
 248:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 24a:	fed518e3          	bne	a0,a3,23a <memcmp+0x14>
  }
  return 0;
 24e:	4501                	li	a0,0
 250:	a019                	j	256 <memcmp+0x30>
      return *p1 - *p2;
 252:	40e7853b          	subw	a0,a5,a4
}
 256:	6422                	ld	s0,8(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
  return 0;
 25c:	4501                	li	a0,0
 25e:	bfe5                	j	256 <memcmp+0x30>

0000000000000260 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 260:	1141                	addi	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 268:	00000097          	auipc	ra,0x0
 26c:	f66080e7          	jalr	-154(ra) # 1ce <memmove>
}
 270:	60a2                	ld	ra,8(sp)
 272:	6402                	ld	s0,0(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret

0000000000000278 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 278:	4885                	li	a7,1
 ecall
 27a:	00000073          	ecall
 ret
 27e:	8082                	ret

0000000000000280 <exit>:
.global exit
exit:
 li a7, SYS_exit
 280:	4889                	li	a7,2
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <wait>:
.global wait
wait:
 li a7, SYS_wait
 288:	488d                	li	a7,3
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 290:	4891                	li	a7,4
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <read>:
.global read
read:
 li a7, SYS_read
 298:	4895                	li	a7,5
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <write>:
.global write
write:
 li a7, SYS_write
 2a0:	48c1                	li	a7,16
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <close>:
.global close
close:
 li a7, SYS_close
 2a8:	48d5                	li	a7,21
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2b0:	4899                	li	a7,6
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2b8:	489d                	li	a7,7
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <open>:
.global open
open:
 li a7, SYS_open
 2c0:	48bd                	li	a7,15
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2c8:	48c5                	li	a7,17
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d0:	48c9                	li	a7,18
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2d8:	48a1                	li	a7,8
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <link>:
.global link
link:
 li a7, SYS_link
 2e0:	48cd                	li	a7,19
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2e8:	48d1                	li	a7,20
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2f0:	48a5                	li	a7,9
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2f8:	48a9                	li	a7,10
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 300:	48ad                	li	a7,11
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 308:	48b1                	li	a7,12
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 310:	48b5                	li	a7,13
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 318:	48b9                	li	a7,14
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 320:	48d9                	li	a7,22
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 328:	1101                	addi	sp,sp,-32
 32a:	ec06                	sd	ra,24(sp)
 32c:	e822                	sd	s0,16(sp)
 32e:	1000                	addi	s0,sp,32
 330:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 334:	4605                	li	a2,1
 336:	fef40593          	addi	a1,s0,-17
 33a:	00000097          	auipc	ra,0x0
 33e:	f66080e7          	jalr	-154(ra) # 2a0 <write>
}
 342:	60e2                	ld	ra,24(sp)
 344:	6442                	ld	s0,16(sp)
 346:	6105                	addi	sp,sp,32
 348:	8082                	ret

000000000000034a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 34a:	7139                	addi	sp,sp,-64
 34c:	fc06                	sd	ra,56(sp)
 34e:	f822                	sd	s0,48(sp)
 350:	f426                	sd	s1,40(sp)
 352:	f04a                	sd	s2,32(sp)
 354:	ec4e                	sd	s3,24(sp)
 356:	0080                	addi	s0,sp,64
 358:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 35a:	c299                	beqz	a3,360 <printint+0x16>
 35c:	0805c863          	bltz	a1,3ec <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 360:	2581                	sext.w	a1,a1
  neg = 0;
 362:	4881                	li	a7,0
 364:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 368:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 36a:	2601                	sext.w	a2,a2
 36c:	00000517          	auipc	a0,0x0
 370:	44450513          	addi	a0,a0,1092 # 7b0 <digits>
 374:	883a                	mv	a6,a4
 376:	2705                	addiw	a4,a4,1
 378:	02c5f7bb          	remuw	a5,a1,a2
 37c:	1782                	slli	a5,a5,0x20
 37e:	9381                	srli	a5,a5,0x20
 380:	97aa                	add	a5,a5,a0
 382:	0007c783          	lbu	a5,0(a5)
 386:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 38a:	0005879b          	sext.w	a5,a1
 38e:	02c5d5bb          	divuw	a1,a1,a2
 392:	0685                	addi	a3,a3,1
 394:	fec7f0e3          	bgeu	a5,a2,374 <printint+0x2a>
  if(neg)
 398:	00088b63          	beqz	a7,3ae <printint+0x64>
    buf[i++] = '-';
 39c:	fd040793          	addi	a5,s0,-48
 3a0:	973e                	add	a4,a4,a5
 3a2:	02d00793          	li	a5,45
 3a6:	fef70823          	sb	a5,-16(a4)
 3aa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ae:	02e05863          	blez	a4,3de <printint+0x94>
 3b2:	fc040793          	addi	a5,s0,-64
 3b6:	00e78933          	add	s2,a5,a4
 3ba:	fff78993          	addi	s3,a5,-1
 3be:	99ba                	add	s3,s3,a4
 3c0:	377d                	addiw	a4,a4,-1
 3c2:	1702                	slli	a4,a4,0x20
 3c4:	9301                	srli	a4,a4,0x20
 3c6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3ca:	fff94583          	lbu	a1,-1(s2)
 3ce:	8526                	mv	a0,s1
 3d0:	00000097          	auipc	ra,0x0
 3d4:	f58080e7          	jalr	-168(ra) # 328 <putc>
  while(--i >= 0)
 3d8:	197d                	addi	s2,s2,-1
 3da:	ff3918e3          	bne	s2,s3,3ca <printint+0x80>
}
 3de:	70e2                	ld	ra,56(sp)
 3e0:	7442                	ld	s0,48(sp)
 3e2:	74a2                	ld	s1,40(sp)
 3e4:	7902                	ld	s2,32(sp)
 3e6:	69e2                	ld	s3,24(sp)
 3e8:	6121                	addi	sp,sp,64
 3ea:	8082                	ret
    x = -xx;
 3ec:	40b005bb          	negw	a1,a1
    neg = 1;
 3f0:	4885                	li	a7,1
    x = -xx;
 3f2:	bf8d                	j	364 <printint+0x1a>

00000000000003f4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3f4:	7119                	addi	sp,sp,-128
 3f6:	fc86                	sd	ra,120(sp)
 3f8:	f8a2                	sd	s0,112(sp)
 3fa:	f4a6                	sd	s1,104(sp)
 3fc:	f0ca                	sd	s2,96(sp)
 3fe:	ecce                	sd	s3,88(sp)
 400:	e8d2                	sd	s4,80(sp)
 402:	e4d6                	sd	s5,72(sp)
 404:	e0da                	sd	s6,64(sp)
 406:	fc5e                	sd	s7,56(sp)
 408:	f862                	sd	s8,48(sp)
 40a:	f466                	sd	s9,40(sp)
 40c:	f06a                	sd	s10,32(sp)
 40e:	ec6e                	sd	s11,24(sp)
 410:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 412:	0005c903          	lbu	s2,0(a1)
 416:	18090f63          	beqz	s2,5b4 <vprintf+0x1c0>
 41a:	8aaa                	mv	s5,a0
 41c:	8b32                	mv	s6,a2
 41e:	00158493          	addi	s1,a1,1
  state = 0;
 422:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 424:	02500a13          	li	s4,37
      if(c == 'd'){
 428:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 42c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 430:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 434:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 438:	00000b97          	auipc	s7,0x0
 43c:	378b8b93          	addi	s7,s7,888 # 7b0 <digits>
 440:	a839                	j	45e <vprintf+0x6a>
        putc(fd, c);
 442:	85ca                	mv	a1,s2
 444:	8556                	mv	a0,s5
 446:	00000097          	auipc	ra,0x0
 44a:	ee2080e7          	jalr	-286(ra) # 328 <putc>
 44e:	a019                	j	454 <vprintf+0x60>
    } else if(state == '%'){
 450:	01498f63          	beq	s3,s4,46e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 454:	0485                	addi	s1,s1,1
 456:	fff4c903          	lbu	s2,-1(s1)
 45a:	14090d63          	beqz	s2,5b4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 45e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 462:	fe0997e3          	bnez	s3,450 <vprintf+0x5c>
      if(c == '%'){
 466:	fd479ee3          	bne	a5,s4,442 <vprintf+0x4e>
        state = '%';
 46a:	89be                	mv	s3,a5
 46c:	b7e5                	j	454 <vprintf+0x60>
      if(c == 'd'){
 46e:	05878063          	beq	a5,s8,4ae <vprintf+0xba>
      } else if(c == 'l') {
 472:	05978c63          	beq	a5,s9,4ca <vprintf+0xd6>
      } else if(c == 'x') {
 476:	07a78863          	beq	a5,s10,4e6 <vprintf+0xf2>
      } else if(c == 'p') {
 47a:	09b78463          	beq	a5,s11,502 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 47e:	07300713          	li	a4,115
 482:	0ce78663          	beq	a5,a4,54e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 486:	06300713          	li	a4,99
 48a:	0ee78e63          	beq	a5,a4,586 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 48e:	11478863          	beq	a5,s4,59e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 492:	85d2                	mv	a1,s4
 494:	8556                	mv	a0,s5
 496:	00000097          	auipc	ra,0x0
 49a:	e92080e7          	jalr	-366(ra) # 328 <putc>
        putc(fd, c);
 49e:	85ca                	mv	a1,s2
 4a0:	8556                	mv	a0,s5
 4a2:	00000097          	auipc	ra,0x0
 4a6:	e86080e7          	jalr	-378(ra) # 328 <putc>
      }
      state = 0;
 4aa:	4981                	li	s3,0
 4ac:	b765                	j	454 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4ae:	008b0913          	addi	s2,s6,8
 4b2:	4685                	li	a3,1
 4b4:	4629                	li	a2,10
 4b6:	000b2583          	lw	a1,0(s6)
 4ba:	8556                	mv	a0,s5
 4bc:	00000097          	auipc	ra,0x0
 4c0:	e8e080e7          	jalr	-370(ra) # 34a <printint>
 4c4:	8b4a                	mv	s6,s2
      state = 0;
 4c6:	4981                	li	s3,0
 4c8:	b771                	j	454 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ca:	008b0913          	addi	s2,s6,8
 4ce:	4681                	li	a3,0
 4d0:	4629                	li	a2,10
 4d2:	000b2583          	lw	a1,0(s6)
 4d6:	8556                	mv	a0,s5
 4d8:	00000097          	auipc	ra,0x0
 4dc:	e72080e7          	jalr	-398(ra) # 34a <printint>
 4e0:	8b4a                	mv	s6,s2
      state = 0;
 4e2:	4981                	li	s3,0
 4e4:	bf85                	j	454 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4e6:	008b0913          	addi	s2,s6,8
 4ea:	4681                	li	a3,0
 4ec:	4641                	li	a2,16
 4ee:	000b2583          	lw	a1,0(s6)
 4f2:	8556                	mv	a0,s5
 4f4:	00000097          	auipc	ra,0x0
 4f8:	e56080e7          	jalr	-426(ra) # 34a <printint>
 4fc:	8b4a                	mv	s6,s2
      state = 0;
 4fe:	4981                	li	s3,0
 500:	bf91                	j	454 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 502:	008b0793          	addi	a5,s6,8
 506:	f8f43423          	sd	a5,-120(s0)
 50a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 50e:	03000593          	li	a1,48
 512:	8556                	mv	a0,s5
 514:	00000097          	auipc	ra,0x0
 518:	e14080e7          	jalr	-492(ra) # 328 <putc>
  putc(fd, 'x');
 51c:	85ea                	mv	a1,s10
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	e08080e7          	jalr	-504(ra) # 328 <putc>
 528:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 52a:	03c9d793          	srli	a5,s3,0x3c
 52e:	97de                	add	a5,a5,s7
 530:	0007c583          	lbu	a1,0(a5)
 534:	8556                	mv	a0,s5
 536:	00000097          	auipc	ra,0x0
 53a:	df2080e7          	jalr	-526(ra) # 328 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 53e:	0992                	slli	s3,s3,0x4
 540:	397d                	addiw	s2,s2,-1
 542:	fe0914e3          	bnez	s2,52a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 546:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 54a:	4981                	li	s3,0
 54c:	b721                	j	454 <vprintf+0x60>
        s = va_arg(ap, char*);
 54e:	008b0993          	addi	s3,s6,8
 552:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 556:	02090163          	beqz	s2,578 <vprintf+0x184>
        while(*s != 0){
 55a:	00094583          	lbu	a1,0(s2)
 55e:	c9a1                	beqz	a1,5ae <vprintf+0x1ba>
          putc(fd, *s);
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	dc6080e7          	jalr	-570(ra) # 328 <putc>
          s++;
 56a:	0905                	addi	s2,s2,1
        while(*s != 0){
 56c:	00094583          	lbu	a1,0(s2)
 570:	f9e5                	bnez	a1,560 <vprintf+0x16c>
        s = va_arg(ap, char*);
 572:	8b4e                	mv	s6,s3
      state = 0;
 574:	4981                	li	s3,0
 576:	bdf9                	j	454 <vprintf+0x60>
          s = "(null)";
 578:	00000917          	auipc	s2,0x0
 57c:	23090913          	addi	s2,s2,560 # 7a8 <malloc+0xea>
        while(*s != 0){
 580:	02800593          	li	a1,40
 584:	bff1                	j	560 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 586:	008b0913          	addi	s2,s6,8
 58a:	000b4583          	lbu	a1,0(s6)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	d98080e7          	jalr	-616(ra) # 328 <putc>
 598:	8b4a                	mv	s6,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	bd65                	j	454 <vprintf+0x60>
        putc(fd, c);
 59e:	85d2                	mv	a1,s4
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	d86080e7          	jalr	-634(ra) # 328 <putc>
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b565                	j	454 <vprintf+0x60>
        s = va_arg(ap, char*);
 5ae:	8b4e                	mv	s6,s3
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b54d                	j	454 <vprintf+0x60>
    }
  }
}
 5b4:	70e6                	ld	ra,120(sp)
 5b6:	7446                	ld	s0,112(sp)
 5b8:	74a6                	ld	s1,104(sp)
 5ba:	7906                	ld	s2,96(sp)
 5bc:	69e6                	ld	s3,88(sp)
 5be:	6a46                	ld	s4,80(sp)
 5c0:	6aa6                	ld	s5,72(sp)
 5c2:	6b06                	ld	s6,64(sp)
 5c4:	7be2                	ld	s7,56(sp)
 5c6:	7c42                	ld	s8,48(sp)
 5c8:	7ca2                	ld	s9,40(sp)
 5ca:	7d02                	ld	s10,32(sp)
 5cc:	6de2                	ld	s11,24(sp)
 5ce:	6109                	addi	sp,sp,128
 5d0:	8082                	ret

00000000000005d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5d2:	715d                	addi	sp,sp,-80
 5d4:	ec06                	sd	ra,24(sp)
 5d6:	e822                	sd	s0,16(sp)
 5d8:	1000                	addi	s0,sp,32
 5da:	e010                	sd	a2,0(s0)
 5dc:	e414                	sd	a3,8(s0)
 5de:	e818                	sd	a4,16(s0)
 5e0:	ec1c                	sd	a5,24(s0)
 5e2:	03043023          	sd	a6,32(s0)
 5e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5ee:	8622                	mv	a2,s0
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e04080e7          	jalr	-508(ra) # 3f4 <vprintf>
}
 5f8:	60e2                	ld	ra,24(sp)
 5fa:	6442                	ld	s0,16(sp)
 5fc:	6161                	addi	sp,sp,80
 5fe:	8082                	ret

0000000000000600 <printf>:

void
printf(const char *fmt, ...)
{
 600:	711d                	addi	sp,sp,-96
 602:	ec06                	sd	ra,24(sp)
 604:	e822                	sd	s0,16(sp)
 606:	1000                	addi	s0,sp,32
 608:	e40c                	sd	a1,8(s0)
 60a:	e810                	sd	a2,16(s0)
 60c:	ec14                	sd	a3,24(s0)
 60e:	f018                	sd	a4,32(s0)
 610:	f41c                	sd	a5,40(s0)
 612:	03043823          	sd	a6,48(s0)
 616:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 61a:	00840613          	addi	a2,s0,8
 61e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 622:	85aa                	mv	a1,a0
 624:	4505                	li	a0,1
 626:	00000097          	auipc	ra,0x0
 62a:	dce080e7          	jalr	-562(ra) # 3f4 <vprintf>
}
 62e:	60e2                	ld	ra,24(sp)
 630:	6442                	ld	s0,16(sp)
 632:	6125                	addi	sp,sp,96
 634:	8082                	ret

0000000000000636 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 636:	1141                	addi	sp,sp,-16
 638:	e422                	sd	s0,8(sp)
 63a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 640:	00000797          	auipc	a5,0x0
 644:	1887b783          	ld	a5,392(a5) # 7c8 <freep>
 648:	a805                	j	678 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 64a:	4618                	lw	a4,8(a2)
 64c:	9db9                	addw	a1,a1,a4
 64e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 652:	6398                	ld	a4,0(a5)
 654:	6318                	ld	a4,0(a4)
 656:	fee53823          	sd	a4,-16(a0)
 65a:	a091                	j	69e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 65c:	ff852703          	lw	a4,-8(a0)
 660:	9e39                	addw	a2,a2,a4
 662:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 664:	ff053703          	ld	a4,-16(a0)
 668:	e398                	sd	a4,0(a5)
 66a:	a099                	j	6b0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66c:	6398                	ld	a4,0(a5)
 66e:	00e7e463          	bltu	a5,a4,676 <free+0x40>
 672:	00e6ea63          	bltu	a3,a4,686 <free+0x50>
{
 676:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 678:	fed7fae3          	bgeu	a5,a3,66c <free+0x36>
 67c:	6398                	ld	a4,0(a5)
 67e:	00e6e463          	bltu	a3,a4,686 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 682:	fee7eae3          	bltu	a5,a4,676 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 686:	ff852583          	lw	a1,-8(a0)
 68a:	6390                	ld	a2,0(a5)
 68c:	02059713          	slli	a4,a1,0x20
 690:	9301                	srli	a4,a4,0x20
 692:	0712                	slli	a4,a4,0x4
 694:	9736                	add	a4,a4,a3
 696:	fae60ae3          	beq	a2,a4,64a <free+0x14>
    bp->s.ptr = p->s.ptr;
 69a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 69e:	4790                	lw	a2,8(a5)
 6a0:	02061713          	slli	a4,a2,0x20
 6a4:	9301                	srli	a4,a4,0x20
 6a6:	0712                	slli	a4,a4,0x4
 6a8:	973e                	add	a4,a4,a5
 6aa:	fae689e3          	beq	a3,a4,65c <free+0x26>
  } else
    p->s.ptr = bp;
 6ae:	e394                	sd	a3,0(a5)
  freep = p;
 6b0:	00000717          	auipc	a4,0x0
 6b4:	10f73c23          	sd	a5,280(a4) # 7c8 <freep>
}
 6b8:	6422                	ld	s0,8(sp)
 6ba:	0141                	addi	sp,sp,16
 6bc:	8082                	ret

00000000000006be <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6be:	7139                	addi	sp,sp,-64
 6c0:	fc06                	sd	ra,56(sp)
 6c2:	f822                	sd	s0,48(sp)
 6c4:	f426                	sd	s1,40(sp)
 6c6:	f04a                	sd	s2,32(sp)
 6c8:	ec4e                	sd	s3,24(sp)
 6ca:	e852                	sd	s4,16(sp)
 6cc:	e456                	sd	s5,8(sp)
 6ce:	e05a                	sd	s6,0(sp)
 6d0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d2:	02051493          	slli	s1,a0,0x20
 6d6:	9081                	srli	s1,s1,0x20
 6d8:	04bd                	addi	s1,s1,15
 6da:	8091                	srli	s1,s1,0x4
 6dc:	0014899b          	addiw	s3,s1,1
 6e0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6e2:	00000517          	auipc	a0,0x0
 6e6:	0e653503          	ld	a0,230(a0) # 7c8 <freep>
 6ea:	c515                	beqz	a0,716 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6ee:	4798                	lw	a4,8(a5)
 6f0:	02977f63          	bgeu	a4,s1,72e <malloc+0x70>
 6f4:	8a4e                	mv	s4,s3
 6f6:	0009871b          	sext.w	a4,s3
 6fa:	6685                	lui	a3,0x1
 6fc:	00d77363          	bgeu	a4,a3,702 <malloc+0x44>
 700:	6a05                	lui	s4,0x1
 702:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 706:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 70a:	00000917          	auipc	s2,0x0
 70e:	0be90913          	addi	s2,s2,190 # 7c8 <freep>
  if(p == (char*)-1)
 712:	5afd                	li	s5,-1
 714:	a88d                	j	786 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 716:	00000797          	auipc	a5,0x0
 71a:	0ba78793          	addi	a5,a5,186 # 7d0 <base>
 71e:	00000717          	auipc	a4,0x0
 722:	0af73523          	sd	a5,170(a4) # 7c8 <freep>
 726:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 728:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 72c:	b7e1                	j	6f4 <malloc+0x36>
      if(p->s.size == nunits)
 72e:	02e48b63          	beq	s1,a4,764 <malloc+0xa6>
        p->s.size -= nunits;
 732:	4137073b          	subw	a4,a4,s3
 736:	c798                	sw	a4,8(a5)
        p += p->s.size;
 738:	1702                	slli	a4,a4,0x20
 73a:	9301                	srli	a4,a4,0x20
 73c:	0712                	slli	a4,a4,0x4
 73e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 740:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 744:	00000717          	auipc	a4,0x0
 748:	08a73223          	sd	a0,132(a4) # 7c8 <freep>
      return (void*)(p + 1);
 74c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 750:	70e2                	ld	ra,56(sp)
 752:	7442                	ld	s0,48(sp)
 754:	74a2                	ld	s1,40(sp)
 756:	7902                	ld	s2,32(sp)
 758:	69e2                	ld	s3,24(sp)
 75a:	6a42                	ld	s4,16(sp)
 75c:	6aa2                	ld	s5,8(sp)
 75e:	6b02                	ld	s6,0(sp)
 760:	6121                	addi	sp,sp,64
 762:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 764:	6398                	ld	a4,0(a5)
 766:	e118                	sd	a4,0(a0)
 768:	bff1                	j	744 <malloc+0x86>
  hp->s.size = nu;
 76a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 76e:	0541                	addi	a0,a0,16
 770:	00000097          	auipc	ra,0x0
 774:	ec6080e7          	jalr	-314(ra) # 636 <free>
  return freep;
 778:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 77c:	d971                	beqz	a0,750 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 780:	4798                	lw	a4,8(a5)
 782:	fa9776e3          	bgeu	a4,s1,72e <malloc+0x70>
    if(p == freep)
 786:	00093703          	ld	a4,0(s2)
 78a:	853e                	mv	a0,a5
 78c:	fef719e3          	bne	a4,a5,77e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 790:	8552                	mv	a0,s4
 792:	00000097          	auipc	ra,0x0
 796:	b76080e7          	jalr	-1162(ra) # 308 <sbrk>
  if(p == (char*)-1)
 79a:	fd5518e3          	bne	a0,s5,76a <malloc+0xac>
        return 0;
 79e:	4501                	li	a0,0
 7a0:	bf45                	j	750 <malloc+0x92>
