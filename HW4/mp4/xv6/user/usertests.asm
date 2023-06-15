
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	6d2080e7          	jalr	1746(ra) # 56e2 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	6c0080e7          	jalr	1728(ra) # 56e2 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	eba50513          	addi	a0,a0,-326 # 5ef8 <malloc+0x418>
      46:	00006097          	auipc	ra,0x6
      4a:	9dc080e7          	jalr	-1572(ra) # 5a22 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	652080e7          	jalr	1618(ra) # 56a2 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	41078793          	addi	a5,a5,1040 # 9468 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	b1868693          	addi	a3,a3,-1256 # bb78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	e9850513          	addi	a0,a0,-360 # 5f18 <malloc+0x438>
      88:	00006097          	auipc	ra,0x6
      8c:	99a080e7          	jalr	-1638(ra) # 5a22 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	610080e7          	jalr	1552(ra) # 56a2 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	e8850513          	addi	a0,a0,-376 # 5f30 <malloc+0x450>
      b0:	00005097          	auipc	ra,0x5
      b4:	632080e7          	jalr	1586(ra) # 56e2 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	60e080e7          	jalr	1550(ra) # 56ca <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	e8a50513          	addi	a0,a0,-374 # 5f50 <malloc+0x470>
      ce:	00005097          	auipc	ra,0x5
      d2:	614080e7          	jalr	1556(ra) # 56e2 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	e5250513          	addi	a0,a0,-430 # 5f38 <malloc+0x458>
      ee:	00006097          	auipc	ra,0x6
      f2:	934080e7          	jalr	-1740(ra) # 5a22 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	5aa080e7          	jalr	1450(ra) # 56a2 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	e5e50513          	addi	a0,a0,-418 # 5f60 <malloc+0x480>
     10a:	00006097          	auipc	ra,0x6
     10e:	918080e7          	jalr	-1768(ra) # 5a22 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	58e080e7          	jalr	1422(ra) # 56a2 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	e5c50513          	addi	a0,a0,-420 # 5f88 <malloc+0x4a8>
     134:	00005097          	auipc	ra,0x5
     138:	5be080e7          	jalr	1470(ra) # 56f2 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	e4850513          	addi	a0,a0,-440 # 5f88 <malloc+0x4a8>
     148:	00005097          	auipc	ra,0x5
     14c:	59a080e7          	jalr	1434(ra) # 56e2 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	e4458593          	addi	a1,a1,-444 # 5f98 <malloc+0x4b8>
     15c:	00005097          	auipc	ra,0x5
     160:	566080e7          	jalr	1382(ra) # 56c2 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	e2050513          	addi	a0,a0,-480 # 5f88 <malloc+0x4a8>
     170:	00005097          	auipc	ra,0x5
     174:	572080e7          	jalr	1394(ra) # 56e2 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	e2458593          	addi	a1,a1,-476 # 5fa0 <malloc+0x4c0>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	53c080e7          	jalr	1340(ra) # 56c2 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	df450513          	addi	a0,a0,-524 # 5f88 <malloc+0x4a8>
     19c:	00005097          	auipc	ra,0x5
     1a0:	556080e7          	jalr	1366(ra) # 56f2 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	524080e7          	jalr	1316(ra) # 56ca <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	51a080e7          	jalr	1306(ra) # 56ca <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	dde50513          	addi	a0,a0,-546 # 5fa8 <malloc+0x4c8>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	850080e7          	jalr	-1968(ra) # 5a22 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	4c6080e7          	jalr	1222(ra) # 56a2 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	4d2080e7          	jalr	1234(ra) # 56e2 <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	4b2080e7          	jalr	1202(ra) # 56ca <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	4ac080e7          	jalr	1196(ra) # 56f2 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	b1c50513          	addi	a0,a0,-1252 # 5d98 <malloc+0x2b8>
     284:	00005097          	auipc	ra,0x5
     288:	46e080e7          	jalr	1134(ra) # 56f2 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	b08a8a93          	addi	s5,s5,-1272 # 5d98 <malloc+0x2b8>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	8e0a0a13          	addi	s4,s4,-1824 # bb78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x171>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	436080e7          	jalr	1078(ra) # 56e2 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	404080e7          	jalr	1028(ra) # 56c2 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	3f0080e7          	jalr	1008(ra) # 56c2 <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	3ea080e7          	jalr	1002(ra) # 56ca <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	408080e7          	jalr	1032(ra) # 56f2 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	cbe50513          	addi	a0,a0,-834 # 5fd0 <malloc+0x4f0>
     31a:	00005097          	auipc	ra,0x5
     31e:	708080e7          	jalr	1800(ra) # 5a22 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	37e080e7          	jalr	894(ra) # 56a2 <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	cba50513          	addi	a0,a0,-838 # 5ff0 <malloc+0x510>
     33e:	00005097          	auipc	ra,0x5
     342:	6e4080e7          	jalr	1764(ra) # 5a22 <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	35a080e7          	jalr	858(ra) # 56a2 <exit>

0000000000000350 <copyin>:
{
     350:	715d                	addi	sp,sp,-80
     352:	e486                	sd	ra,72(sp)
     354:	e0a2                	sd	s0,64(sp)
     356:	fc26                	sd	s1,56(sp)
     358:	f84a                	sd	s2,48(sp)
     35a:	f44e                	sd	s3,40(sp)
     35c:	f052                	sd	s4,32(sp)
     35e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     360:	4785                	li	a5,1
     362:	07fe                	slli	a5,a5,0x1f
     364:	fcf43023          	sd	a5,-64(s0)
     368:	57fd                	li	a5,-1
     36a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     372:	00006a17          	auipc	s4,0x6
     376:	c96a0a13          	addi	s4,s4,-874 # 6008 <malloc+0x528>
    uint64 addr = addrs[ai];
     37a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37e:	20100593          	li	a1,513
     382:	8552                	mv	a0,s4
     384:	00005097          	auipc	ra,0x5
     388:	35e080e7          	jalr	862(ra) # 56e2 <open>
     38c:	84aa                	mv	s1,a0
    if(fd < 0){
     38e:	08054863          	bltz	a0,41e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     392:	6609                	lui	a2,0x2
     394:	85ce                	mv	a1,s3
     396:	00005097          	auipc	ra,0x5
     39a:	32c080e7          	jalr	812(ra) # 56c2 <write>
    if(n >= 0){
     39e:	08055d63          	bgez	a0,438 <copyin+0xe8>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00005097          	auipc	ra,0x5
     3a8:	326080e7          	jalr	806(ra) # 56ca <close>
    unlink("copyin1");
     3ac:	8552                	mv	a0,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	344080e7          	jalr	836(ra) # 56f2 <unlink>
    n = write(1, (char*)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ce                	mv	a1,s3
     3ba:	4505                	li	a0,1
     3bc:	00005097          	auipc	ra,0x5
     3c0:	306080e7          	jalr	774(ra) # 56c2 <write>
    if(n > 0){
     3c4:	08a04963          	bgtz	a0,456 <copyin+0x106>
    if(pipe(fds) < 0){
     3c8:	fb840513          	addi	a0,s0,-72
     3cc:	00005097          	auipc	ra,0x5
     3d0:	2e6080e7          	jalr	742(ra) # 56b2 <pipe>
     3d4:	0a054063          	bltz	a0,474 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d8:	6609                	lui	a2,0x2
     3da:	85ce                	mv	a1,s3
     3dc:	fbc42503          	lw	a0,-68(s0)
     3e0:	00005097          	auipc	ra,0x5
     3e4:	2e2080e7          	jalr	738(ra) # 56c2 <write>
    if(n > 0){
     3e8:	0aa04363          	bgtz	a0,48e <copyin+0x13e>
    close(fds[0]);
     3ec:	fb842503          	lw	a0,-72(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	2da080e7          	jalr	730(ra) # 56ca <close>
    close(fds[1]);
     3f8:	fbc42503          	lw	a0,-68(s0)
     3fc:	00005097          	auipc	ra,0x5
     400:	2ce080e7          	jalr	718(ra) # 56ca <close>
  for(int ai = 0; ai < 2; ai++){
     404:	0921                	addi	s2,s2,8
     406:	fd040793          	addi	a5,s0,-48
     40a:	f6f918e3          	bne	s2,a5,37a <copyin+0x2a>
}
     40e:	60a6                	ld	ra,72(sp)
     410:	6406                	ld	s0,64(sp)
     412:	74e2                	ld	s1,56(sp)
     414:	7942                	ld	s2,48(sp)
     416:	79a2                	ld	s3,40(sp)
     418:	7a02                	ld	s4,32(sp)
     41a:	6161                	addi	sp,sp,80
     41c:	8082                	ret
      printf("open(copyin1) failed\n");
     41e:	00006517          	auipc	a0,0x6
     422:	bf250513          	addi	a0,a0,-1038 # 6010 <malloc+0x530>
     426:	00005097          	auipc	ra,0x5
     42a:	5fc080e7          	jalr	1532(ra) # 5a22 <printf>
      exit(1);
     42e:	4505                	li	a0,1
     430:	00005097          	auipc	ra,0x5
     434:	272080e7          	jalr	626(ra) # 56a2 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     438:	862a                	mv	a2,a0
     43a:	85ce                	mv	a1,s3
     43c:	00006517          	auipc	a0,0x6
     440:	bec50513          	addi	a0,a0,-1044 # 6028 <malloc+0x548>
     444:	00005097          	auipc	ra,0x5
     448:	5de080e7          	jalr	1502(ra) # 5a22 <printf>
      exit(1);
     44c:	4505                	li	a0,1
     44e:	00005097          	auipc	ra,0x5
     452:	254080e7          	jalr	596(ra) # 56a2 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     456:	862a                	mv	a2,a0
     458:	85ce                	mv	a1,s3
     45a:	00006517          	auipc	a0,0x6
     45e:	bfe50513          	addi	a0,a0,-1026 # 6058 <malloc+0x578>
     462:	00005097          	auipc	ra,0x5
     466:	5c0080e7          	jalr	1472(ra) # 5a22 <printf>
      exit(1);
     46a:	4505                	li	a0,1
     46c:	00005097          	auipc	ra,0x5
     470:	236080e7          	jalr	566(ra) # 56a2 <exit>
      printf("pipe() failed\n");
     474:	00006517          	auipc	a0,0x6
     478:	c1450513          	addi	a0,a0,-1004 # 6088 <malloc+0x5a8>
     47c:	00005097          	auipc	ra,0x5
     480:	5a6080e7          	jalr	1446(ra) # 5a22 <printf>
      exit(1);
     484:	4505                	li	a0,1
     486:	00005097          	auipc	ra,0x5
     48a:	21c080e7          	jalr	540(ra) # 56a2 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48e:	862a                	mv	a2,a0
     490:	85ce                	mv	a1,s3
     492:	00006517          	auipc	a0,0x6
     496:	c0650513          	addi	a0,a0,-1018 # 6098 <malloc+0x5b8>
     49a:	00005097          	auipc	ra,0x5
     49e:	588080e7          	jalr	1416(ra) # 5a22 <printf>
      exit(1);
     4a2:	4505                	li	a0,1
     4a4:	00005097          	auipc	ra,0x5
     4a8:	1fe080e7          	jalr	510(ra) # 56a2 <exit>

00000000000004ac <copyout>:
{
     4ac:	711d                	addi	sp,sp,-96
     4ae:	ec86                	sd	ra,88(sp)
     4b0:	e8a2                	sd	s0,80(sp)
     4b2:	e4a6                	sd	s1,72(sp)
     4b4:	e0ca                	sd	s2,64(sp)
     4b6:	fc4e                	sd	s3,56(sp)
     4b8:	f852                	sd	s4,48(sp)
     4ba:	f456                	sd	s5,40(sp)
     4bc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4be:	4785                	li	a5,1
     4c0:	07fe                	slli	a5,a5,0x1f
     4c2:	faf43823          	sd	a5,-80(s0)
     4c6:	57fd                	li	a5,-1
     4c8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4cc:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4d0:	00006a17          	auipc	s4,0x6
     4d4:	bf8a0a13          	addi	s4,s4,-1032 # 60c8 <malloc+0x5e8>
    n = write(fds[1], "x", 1);
     4d8:	00006a97          	auipc	s5,0x6
     4dc:	ac8a8a93          	addi	s5,s5,-1336 # 5fa0 <malloc+0x4c0>
    uint64 addr = addrs[ai];
     4e0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e4:	4581                	li	a1,0
     4e6:	8552                	mv	a0,s4
     4e8:	00005097          	auipc	ra,0x5
     4ec:	1fa080e7          	jalr	506(ra) # 56e2 <open>
     4f0:	84aa                	mv	s1,a0
    if(fd < 0){
     4f2:	08054663          	bltz	a0,57e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ce                	mv	a1,s3
     4fa:	00005097          	auipc	ra,0x5
     4fe:	1c0080e7          	jalr	448(ra) # 56ba <read>
    if(n > 0){
     502:	08a04b63          	bgtz	a0,598 <copyout+0xec>
    close(fd);
     506:	8526                	mv	a0,s1
     508:	00005097          	auipc	ra,0x5
     50c:	1c2080e7          	jalr	450(ra) # 56ca <close>
    if(pipe(fds) < 0){
     510:	fa840513          	addi	a0,s0,-88
     514:	00005097          	auipc	ra,0x5
     518:	19e080e7          	jalr	414(ra) # 56b2 <pipe>
     51c:	08054d63          	bltz	a0,5b6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     520:	4605                	li	a2,1
     522:	85d6                	mv	a1,s5
     524:	fac42503          	lw	a0,-84(s0)
     528:	00005097          	auipc	ra,0x5
     52c:	19a080e7          	jalr	410(ra) # 56c2 <write>
    if(n != 1){
     530:	4785                	li	a5,1
     532:	08f51f63          	bne	a0,a5,5d0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     536:	6609                	lui	a2,0x2
     538:	85ce                	mv	a1,s3
     53a:	fa842503          	lw	a0,-88(s0)
     53e:	00005097          	auipc	ra,0x5
     542:	17c080e7          	jalr	380(ra) # 56ba <read>
    if(n > 0){
     546:	0aa04263          	bgtz	a0,5ea <copyout+0x13e>
    close(fds[0]);
     54a:	fa842503          	lw	a0,-88(s0)
     54e:	00005097          	auipc	ra,0x5
     552:	17c080e7          	jalr	380(ra) # 56ca <close>
    close(fds[1]);
     556:	fac42503          	lw	a0,-84(s0)
     55a:	00005097          	auipc	ra,0x5
     55e:	170080e7          	jalr	368(ra) # 56ca <close>
  for(int ai = 0; ai < 2; ai++){
     562:	0921                	addi	s2,s2,8
     564:	fc040793          	addi	a5,s0,-64
     568:	f6f91ce3          	bne	s2,a5,4e0 <copyout+0x34>
}
     56c:	60e6                	ld	ra,88(sp)
     56e:	6446                	ld	s0,80(sp)
     570:	64a6                	ld	s1,72(sp)
     572:	6906                	ld	s2,64(sp)
     574:	79e2                	ld	s3,56(sp)
     576:	7a42                	ld	s4,48(sp)
     578:	7aa2                	ld	s5,40(sp)
     57a:	6125                	addi	sp,sp,96
     57c:	8082                	ret
      printf("open(README) failed\n");
     57e:	00006517          	auipc	a0,0x6
     582:	b5250513          	addi	a0,a0,-1198 # 60d0 <malloc+0x5f0>
     586:	00005097          	auipc	ra,0x5
     58a:	49c080e7          	jalr	1180(ra) # 5a22 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	112080e7          	jalr	274(ra) # 56a2 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     598:	862a                	mv	a2,a0
     59a:	85ce                	mv	a1,s3
     59c:	00006517          	auipc	a0,0x6
     5a0:	b4c50513          	addi	a0,a0,-1204 # 60e8 <malloc+0x608>
     5a4:	00005097          	auipc	ra,0x5
     5a8:	47e080e7          	jalr	1150(ra) # 5a22 <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00005097          	auipc	ra,0x5
     5b2:	0f4080e7          	jalr	244(ra) # 56a2 <exit>
      printf("pipe() failed\n");
     5b6:	00006517          	auipc	a0,0x6
     5ba:	ad250513          	addi	a0,a0,-1326 # 6088 <malloc+0x5a8>
     5be:	00005097          	auipc	ra,0x5
     5c2:	464080e7          	jalr	1124(ra) # 5a22 <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	0da080e7          	jalr	218(ra) # 56a2 <exit>
      printf("pipe write failed\n");
     5d0:	00006517          	auipc	a0,0x6
     5d4:	b4850513          	addi	a0,a0,-1208 # 6118 <malloc+0x638>
     5d8:	00005097          	auipc	ra,0x5
     5dc:	44a080e7          	jalr	1098(ra) # 5a22 <printf>
      exit(1);
     5e0:	4505                	li	a0,1
     5e2:	00005097          	auipc	ra,0x5
     5e6:	0c0080e7          	jalr	192(ra) # 56a2 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ea:	862a                	mv	a2,a0
     5ec:	85ce                	mv	a1,s3
     5ee:	00006517          	auipc	a0,0x6
     5f2:	b4250513          	addi	a0,a0,-1214 # 6130 <malloc+0x650>
     5f6:	00005097          	auipc	ra,0x5
     5fa:	42c080e7          	jalr	1068(ra) # 5a22 <printf>
      exit(1);
     5fe:	4505                	li	a0,1
     600:	00005097          	auipc	ra,0x5
     604:	0a2080e7          	jalr	162(ra) # 56a2 <exit>

0000000000000608 <truncate1>:
{
     608:	711d                	addi	sp,sp,-96
     60a:	ec86                	sd	ra,88(sp)
     60c:	e8a2                	sd	s0,80(sp)
     60e:	e4a6                	sd	s1,72(sp)
     610:	e0ca                	sd	s2,64(sp)
     612:	fc4e                	sd	s3,56(sp)
     614:	f852                	sd	s4,48(sp)
     616:	f456                	sd	s5,40(sp)
     618:	1080                	addi	s0,sp,96
     61a:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61c:	00006517          	auipc	a0,0x6
     620:	96c50513          	addi	a0,a0,-1684 # 5f88 <malloc+0x4a8>
     624:	00005097          	auipc	ra,0x5
     628:	0ce080e7          	jalr	206(ra) # 56f2 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62c:	60100593          	li	a1,1537
     630:	00006517          	auipc	a0,0x6
     634:	95850513          	addi	a0,a0,-1704 # 5f88 <malloc+0x4a8>
     638:	00005097          	auipc	ra,0x5
     63c:	0aa080e7          	jalr	170(ra) # 56e2 <open>
     640:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     642:	4611                	li	a2,4
     644:	00006597          	auipc	a1,0x6
     648:	95458593          	addi	a1,a1,-1708 # 5f98 <malloc+0x4b8>
     64c:	00005097          	auipc	ra,0x5
     650:	076080e7          	jalr	118(ra) # 56c2 <write>
  close(fd1);
     654:	8526                	mv	a0,s1
     656:	00005097          	auipc	ra,0x5
     65a:	074080e7          	jalr	116(ra) # 56ca <close>
  int fd2 = open("truncfile", O_RDONLY);
     65e:	4581                	li	a1,0
     660:	00006517          	auipc	a0,0x6
     664:	92850513          	addi	a0,a0,-1752 # 5f88 <malloc+0x4a8>
     668:	00005097          	auipc	ra,0x5
     66c:	07a080e7          	jalr	122(ra) # 56e2 <open>
     670:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     672:	02000613          	li	a2,32
     676:	fa040593          	addi	a1,s0,-96
     67a:	00005097          	auipc	ra,0x5
     67e:	040080e7          	jalr	64(ra) # 56ba <read>
  if(n != 4){
     682:	4791                	li	a5,4
     684:	0cf51e63          	bne	a0,a5,760 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     688:	40100593          	li	a1,1025
     68c:	00006517          	auipc	a0,0x6
     690:	8fc50513          	addi	a0,a0,-1796 # 5f88 <malloc+0x4a8>
     694:	00005097          	auipc	ra,0x5
     698:	04e080e7          	jalr	78(ra) # 56e2 <open>
     69c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69e:	4581                	li	a1,0
     6a0:	00006517          	auipc	a0,0x6
     6a4:	8e850513          	addi	a0,a0,-1816 # 5f88 <malloc+0x4a8>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	03a080e7          	jalr	58(ra) # 56e2 <open>
     6b0:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b2:	02000613          	li	a2,32
     6b6:	fa040593          	addi	a1,s0,-96
     6ba:	00005097          	auipc	ra,0x5
     6be:	000080e7          	jalr	ra # 56ba <read>
     6c2:	8a2a                	mv	s4,a0
  if(n != 0){
     6c4:	ed4d                	bnez	a0,77e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	8526                	mv	a0,s1
     6d0:	00005097          	auipc	ra,0x5
     6d4:	fea080e7          	jalr	-22(ra) # 56ba <read>
     6d8:	8a2a                	mv	s4,a0
  if(n != 0){
     6da:	e971                	bnez	a0,7ae <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6dc:	4619                	li	a2,6
     6de:	00006597          	auipc	a1,0x6
     6e2:	ae258593          	addi	a1,a1,-1310 # 61c0 <malloc+0x6e0>
     6e6:	854e                	mv	a0,s3
     6e8:	00005097          	auipc	ra,0x5
     6ec:	fda080e7          	jalr	-38(ra) # 56c2 <write>
  n = read(fd3, buf, sizeof(buf));
     6f0:	02000613          	li	a2,32
     6f4:	fa040593          	addi	a1,s0,-96
     6f8:	854a                	mv	a0,s2
     6fa:	00005097          	auipc	ra,0x5
     6fe:	fc0080e7          	jalr	-64(ra) # 56ba <read>
  if(n != 6){
     702:	4799                	li	a5,6
     704:	0cf51d63          	bne	a0,a5,7de <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     708:	02000613          	li	a2,32
     70c:	fa040593          	addi	a1,s0,-96
     710:	8526                	mv	a0,s1
     712:	00005097          	auipc	ra,0x5
     716:	fa8080e7          	jalr	-88(ra) # 56ba <read>
  if(n != 2){
     71a:	4789                	li	a5,2
     71c:	0ef51063          	bne	a0,a5,7fc <truncate1+0x1f4>
  unlink("truncfile");
     720:	00006517          	auipc	a0,0x6
     724:	86850513          	addi	a0,a0,-1944 # 5f88 <malloc+0x4a8>
     728:	00005097          	auipc	ra,0x5
     72c:	fca080e7          	jalr	-54(ra) # 56f2 <unlink>
  close(fd1);
     730:	854e                	mv	a0,s3
     732:	00005097          	auipc	ra,0x5
     736:	f98080e7          	jalr	-104(ra) # 56ca <close>
  close(fd2);
     73a:	8526                	mv	a0,s1
     73c:	00005097          	auipc	ra,0x5
     740:	f8e080e7          	jalr	-114(ra) # 56ca <close>
  close(fd3);
     744:	854a                	mv	a0,s2
     746:	00005097          	auipc	ra,0x5
     74a:	f84080e7          	jalr	-124(ra) # 56ca <close>
}
     74e:	60e6                	ld	ra,88(sp)
     750:	6446                	ld	s0,80(sp)
     752:	64a6                	ld	s1,72(sp)
     754:	6906                	ld	s2,64(sp)
     756:	79e2                	ld	s3,56(sp)
     758:	7a42                	ld	s4,48(sp)
     75a:	7aa2                	ld	s5,40(sp)
     75c:	6125                	addi	sp,sp,96
     75e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     760:	862a                	mv	a2,a0
     762:	85d6                	mv	a1,s5
     764:	00006517          	auipc	a0,0x6
     768:	9fc50513          	addi	a0,a0,-1540 # 6160 <malloc+0x680>
     76c:	00005097          	auipc	ra,0x5
     770:	2b6080e7          	jalr	694(ra) # 5a22 <printf>
    exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	f2c080e7          	jalr	-212(ra) # 56a2 <exit>
    printf("aaa fd3=%d\n", fd3);
     77e:	85ca                	mv	a1,s2
     780:	00006517          	auipc	a0,0x6
     784:	a0050513          	addi	a0,a0,-1536 # 6180 <malloc+0x6a0>
     788:	00005097          	auipc	ra,0x5
     78c:	29a080e7          	jalr	666(ra) # 5a22 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     790:	8652                	mv	a2,s4
     792:	85d6                	mv	a1,s5
     794:	00006517          	auipc	a0,0x6
     798:	9fc50513          	addi	a0,a0,-1540 # 6190 <malloc+0x6b0>
     79c:	00005097          	auipc	ra,0x5
     7a0:	286080e7          	jalr	646(ra) # 5a22 <printf>
    exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	efc080e7          	jalr	-260(ra) # 56a2 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ae:	85a6                	mv	a1,s1
     7b0:	00006517          	auipc	a0,0x6
     7b4:	a0050513          	addi	a0,a0,-1536 # 61b0 <malloc+0x6d0>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	26a080e7          	jalr	618(ra) # 5a22 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7c0:	8652                	mv	a2,s4
     7c2:	85d6                	mv	a1,s5
     7c4:	00006517          	auipc	a0,0x6
     7c8:	9cc50513          	addi	a0,a0,-1588 # 6190 <malloc+0x6b0>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	256080e7          	jalr	598(ra) # 5a22 <printf>
    exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00005097          	auipc	ra,0x5
     7da:	ecc080e7          	jalr	-308(ra) # 56a2 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7de:	862a                	mv	a2,a0
     7e0:	85d6                	mv	a1,s5
     7e2:	00006517          	auipc	a0,0x6
     7e6:	9e650513          	addi	a0,a0,-1562 # 61c8 <malloc+0x6e8>
     7ea:	00005097          	auipc	ra,0x5
     7ee:	238080e7          	jalr	568(ra) # 5a22 <printf>
    exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	eae080e7          	jalr	-338(ra) # 56a2 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fc:	862a                	mv	a2,a0
     7fe:	85d6                	mv	a1,s5
     800:	00006517          	auipc	a0,0x6
     804:	9e850513          	addi	a0,a0,-1560 # 61e8 <malloc+0x708>
     808:	00005097          	auipc	ra,0x5
     80c:	21a080e7          	jalr	538(ra) # 5a22 <printf>
    exit(1);
     810:	4505                	li	a0,1
     812:	00005097          	auipc	ra,0x5
     816:	e90080e7          	jalr	-368(ra) # 56a2 <exit>

000000000000081a <writetest>:
{
     81a:	7139                	addi	sp,sp,-64
     81c:	fc06                	sd	ra,56(sp)
     81e:	f822                	sd	s0,48(sp)
     820:	f426                	sd	s1,40(sp)
     822:	f04a                	sd	s2,32(sp)
     824:	ec4e                	sd	s3,24(sp)
     826:	e852                	sd	s4,16(sp)
     828:	e456                	sd	s5,8(sp)
     82a:	e05a                	sd	s6,0(sp)
     82c:	0080                	addi	s0,sp,64
     82e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     830:	20200593          	li	a1,514
     834:	00006517          	auipc	a0,0x6
     838:	9d450513          	addi	a0,a0,-1580 # 6208 <malloc+0x728>
     83c:	00005097          	auipc	ra,0x5
     840:	ea6080e7          	jalr	-346(ra) # 56e2 <open>
  if(fd < 0){
     844:	0a054d63          	bltz	a0,8fe <writetest+0xe4>
     848:	892a                	mv	s2,a0
     84a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84c:	00006997          	auipc	s3,0x6
     850:	9e498993          	addi	s3,s3,-1564 # 6230 <malloc+0x750>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     854:	00006a97          	auipc	s5,0x6
     858:	a14a8a93          	addi	s5,s5,-1516 # 6268 <malloc+0x788>
  for(i = 0; i < N; i++){
     85c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	4629                	li	a2,10
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00005097          	auipc	ra,0x5
     86a:	e5c080e7          	jalr	-420(ra) # 56c2 <write>
     86e:	47a9                	li	a5,10
     870:	0af51563          	bne	a0,a5,91a <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85d6                	mv	a1,s5
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	e48080e7          	jalr	-440(ra) # 56c2 <write>
     882:	47a9                	li	a5,10
     884:	0af51a63          	bne	a0,a5,938 <writetest+0x11e>
  for(i = 0; i < N; i++){
     888:	2485                	addiw	s1,s1,1
     88a:	fd449be3          	bne	s1,s4,860 <writetest+0x46>
  close(fd);
     88e:	854a                	mv	a0,s2
     890:	00005097          	auipc	ra,0x5
     894:	e3a080e7          	jalr	-454(ra) # 56ca <close>
  fd = open("small", O_RDONLY);
     898:	4581                	li	a1,0
     89a:	00006517          	auipc	a0,0x6
     89e:	96e50513          	addi	a0,a0,-1682 # 6208 <malloc+0x728>
     8a2:	00005097          	auipc	ra,0x5
     8a6:	e40080e7          	jalr	-448(ra) # 56e2 <open>
     8aa:	84aa                	mv	s1,a0
  if(fd < 0){
     8ac:	0a054563          	bltz	a0,956 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8b0:	7d000613          	li	a2,2000
     8b4:	0000b597          	auipc	a1,0xb
     8b8:	2c458593          	addi	a1,a1,708 # bb78 <buf>
     8bc:	00005097          	auipc	ra,0x5
     8c0:	dfe080e7          	jalr	-514(ra) # 56ba <read>
  if(i != N*SZ*2){
     8c4:	7d000793          	li	a5,2000
     8c8:	0af51563          	bne	a0,a5,972 <writetest+0x158>
  close(fd);
     8cc:	8526                	mv	a0,s1
     8ce:	00005097          	auipc	ra,0x5
     8d2:	dfc080e7          	jalr	-516(ra) # 56ca <close>
  if(unlink("small") < 0){
     8d6:	00006517          	auipc	a0,0x6
     8da:	93250513          	addi	a0,a0,-1742 # 6208 <malloc+0x728>
     8de:	00005097          	auipc	ra,0x5
     8e2:	e14080e7          	jalr	-492(ra) # 56f2 <unlink>
     8e6:	0a054463          	bltz	a0,98e <writetest+0x174>
}
     8ea:	70e2                	ld	ra,56(sp)
     8ec:	7442                	ld	s0,48(sp)
     8ee:	74a2                	ld	s1,40(sp)
     8f0:	7902                	ld	s2,32(sp)
     8f2:	69e2                	ld	s3,24(sp)
     8f4:	6a42                	ld	s4,16(sp)
     8f6:	6aa2                	ld	s5,8(sp)
     8f8:	6b02                	ld	s6,0(sp)
     8fa:	6121                	addi	sp,sp,64
     8fc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fe:	85da                	mv	a1,s6
     900:	00006517          	auipc	a0,0x6
     904:	91050513          	addi	a0,a0,-1776 # 6210 <malloc+0x730>
     908:	00005097          	auipc	ra,0x5
     90c:	11a080e7          	jalr	282(ra) # 5a22 <printf>
    exit(1);
     910:	4505                	li	a0,1
     912:	00005097          	auipc	ra,0x5
     916:	d90080e7          	jalr	-624(ra) # 56a2 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     91a:	8626                	mv	a2,s1
     91c:	85da                	mv	a1,s6
     91e:	00006517          	auipc	a0,0x6
     922:	92250513          	addi	a0,a0,-1758 # 6240 <malloc+0x760>
     926:	00005097          	auipc	ra,0x5
     92a:	0fc080e7          	jalr	252(ra) # 5a22 <printf>
      exit(1);
     92e:	4505                	li	a0,1
     930:	00005097          	auipc	ra,0x5
     934:	d72080e7          	jalr	-654(ra) # 56a2 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     938:	8626                	mv	a2,s1
     93a:	85da                	mv	a1,s6
     93c:	00006517          	auipc	a0,0x6
     940:	93c50513          	addi	a0,a0,-1732 # 6278 <malloc+0x798>
     944:	00005097          	auipc	ra,0x5
     948:	0de080e7          	jalr	222(ra) # 5a22 <printf>
      exit(1);
     94c:	4505                	li	a0,1
     94e:	00005097          	auipc	ra,0x5
     952:	d54080e7          	jalr	-684(ra) # 56a2 <exit>
    printf("%s: error: open small failed!\n", s);
     956:	85da                	mv	a1,s6
     958:	00006517          	auipc	a0,0x6
     95c:	94850513          	addi	a0,a0,-1720 # 62a0 <malloc+0x7c0>
     960:	00005097          	auipc	ra,0x5
     964:	0c2080e7          	jalr	194(ra) # 5a22 <printf>
    exit(1);
     968:	4505                	li	a0,1
     96a:	00005097          	auipc	ra,0x5
     96e:	d38080e7          	jalr	-712(ra) # 56a2 <exit>
    printf("%s: read failed\n", s);
     972:	85da                	mv	a1,s6
     974:	00006517          	auipc	a0,0x6
     978:	94c50513          	addi	a0,a0,-1716 # 62c0 <malloc+0x7e0>
     97c:	00005097          	auipc	ra,0x5
     980:	0a6080e7          	jalr	166(ra) # 5a22 <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	d1c080e7          	jalr	-740(ra) # 56a2 <exit>
    printf("%s: unlink small failed\n", s);
     98e:	85da                	mv	a1,s6
     990:	00006517          	auipc	a0,0x6
     994:	94850513          	addi	a0,a0,-1720 # 62d8 <malloc+0x7f8>
     998:	00005097          	auipc	ra,0x5
     99c:	08a080e7          	jalr	138(ra) # 5a22 <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	d00080e7          	jalr	-768(ra) # 56a2 <exit>

00000000000009aa <writebig>:
{
     9aa:	7139                	addi	sp,sp,-64
     9ac:	fc06                	sd	ra,56(sp)
     9ae:	f822                	sd	s0,48(sp)
     9b0:	f426                	sd	s1,40(sp)
     9b2:	f04a                	sd	s2,32(sp)
     9b4:	ec4e                	sd	s3,24(sp)
     9b6:	e852                	sd	s4,16(sp)
     9b8:	e456                	sd	s5,8(sp)
     9ba:	0080                	addi	s0,sp,64
     9bc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9be:	20200593          	li	a1,514
     9c2:	00006517          	auipc	a0,0x6
     9c6:	93650513          	addi	a0,a0,-1738 # 62f8 <malloc+0x818>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	d18080e7          	jalr	-744(ra) # 56e2 <open>
  if(fd < 0){
     9d2:	08054563          	bltz	a0,a5c <writebig+0xb2>
     9d6:	89aa                	mv	s3,a0
     9d8:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9da:	0000b917          	auipc	s2,0xb
     9de:	19e90913          	addi	s2,s2,414 # bb78 <buf>
  for(i = 0; i < MAXFILE; i++){
     9e2:	6a41                	lui	s4,0x10
     9e4:	507a0a13          	addi	s4,s4,1287 # 10507 <__BSS_END__+0x197f>
    ((int*)buf)[0] = i;
     9e8:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9ec:	40000613          	li	a2,1024
     9f0:	85ca                	mv	a1,s2
     9f2:	854e                	mv	a0,s3
     9f4:	00005097          	auipc	ra,0x5
     9f8:	cce080e7          	jalr	-818(ra) # 56c2 <write>
     9fc:	40000793          	li	a5,1024
     a00:	06f51c63          	bne	a0,a5,a78 <writebig+0xce>
  for(i = 0; i < MAXFILE; i++){
     a04:	2485                	addiw	s1,s1,1
     a06:	ff4491e3          	bne	s1,s4,9e8 <writebig+0x3e>
  close(fd);
     a0a:	854e                	mv	a0,s3
     a0c:	00005097          	auipc	ra,0x5
     a10:	cbe080e7          	jalr	-834(ra) # 56ca <close>
  fd = open("big", O_RDONLY);
     a14:	4581                	li	a1,0
     a16:	00006517          	auipc	a0,0x6
     a1a:	8e250513          	addi	a0,a0,-1822 # 62f8 <malloc+0x818>
     a1e:	00005097          	auipc	ra,0x5
     a22:	cc4080e7          	jalr	-828(ra) # 56e2 <open>
     a26:	89aa                	mv	s3,a0
  n = 0;
     a28:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2a:	0000b917          	auipc	s2,0xb
     a2e:	14e90913          	addi	s2,s2,334 # bb78 <buf>
  if(fd < 0){
     a32:	06054263          	bltz	a0,a96 <writebig+0xec>
    i = read(fd, buf, BSIZE);
     a36:	40000613          	li	a2,1024
     a3a:	85ca                	mv	a1,s2
     a3c:	854e                	mv	a0,s3
     a3e:	00005097          	auipc	ra,0x5
     a42:	c7c080e7          	jalr	-900(ra) # 56ba <read>
    if(i == 0){
     a46:	c535                	beqz	a0,ab2 <writebig+0x108>
    } else if(i != BSIZE){
     a48:	40000793          	li	a5,1024
     a4c:	0af51f63          	bne	a0,a5,b0a <writebig+0x160>
    if(((int*)buf)[0] != n){
     a50:	00092683          	lw	a3,0(s2)
     a54:	0c969a63          	bne	a3,s1,b28 <writebig+0x17e>
    n++;
     a58:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a5a:	bff1                	j	a36 <writebig+0x8c>
    printf("%s: error: creat big failed!\n", s);
     a5c:	85d6                	mv	a1,s5
     a5e:	00006517          	auipc	a0,0x6
     a62:	8a250513          	addi	a0,a0,-1886 # 6300 <malloc+0x820>
     a66:	00005097          	auipc	ra,0x5
     a6a:	fbc080e7          	jalr	-68(ra) # 5a22 <printf>
    exit(1);
     a6e:	4505                	li	a0,1
     a70:	00005097          	auipc	ra,0x5
     a74:	c32080e7          	jalr	-974(ra) # 56a2 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a78:	8626                	mv	a2,s1
     a7a:	85d6                	mv	a1,s5
     a7c:	00006517          	auipc	a0,0x6
     a80:	8a450513          	addi	a0,a0,-1884 # 6320 <malloc+0x840>
     a84:	00005097          	auipc	ra,0x5
     a88:	f9e080e7          	jalr	-98(ra) # 5a22 <printf>
      exit(1);
     a8c:	4505                	li	a0,1
     a8e:	00005097          	auipc	ra,0x5
     a92:	c14080e7          	jalr	-1004(ra) # 56a2 <exit>
    printf("%s: error: open big failed!\n", s);
     a96:	85d6                	mv	a1,s5
     a98:	00006517          	auipc	a0,0x6
     a9c:	8b050513          	addi	a0,a0,-1872 # 6348 <malloc+0x868>
     aa0:	00005097          	auipc	ra,0x5
     aa4:	f82080e7          	jalr	-126(ra) # 5a22 <printf>
    exit(1);
     aa8:	4505                	li	a0,1
     aaa:	00005097          	auipc	ra,0x5
     aae:	bf8080e7          	jalr	-1032(ra) # 56a2 <exit>
      if(n == MAXFILE - 1){
     ab2:	67c1                	lui	a5,0x10
     ab4:	50678793          	addi	a5,a5,1286 # 10506 <__BSS_END__+0x197e>
     ab8:	02f48a63          	beq	s1,a5,aec <writebig+0x142>
  close(fd);
     abc:	854e                	mv	a0,s3
     abe:	00005097          	auipc	ra,0x5
     ac2:	c0c080e7          	jalr	-1012(ra) # 56ca <close>
  if(unlink("big") < 0){
     ac6:	00006517          	auipc	a0,0x6
     aca:	83250513          	addi	a0,a0,-1998 # 62f8 <malloc+0x818>
     ace:	00005097          	auipc	ra,0x5
     ad2:	c24080e7          	jalr	-988(ra) # 56f2 <unlink>
     ad6:	06054863          	bltz	a0,b46 <writebig+0x19c>
}
     ada:	70e2                	ld	ra,56(sp)
     adc:	7442                	ld	s0,48(sp)
     ade:	74a2                	ld	s1,40(sp)
     ae0:	7902                	ld	s2,32(sp)
     ae2:	69e2                	ld	s3,24(sp)
     ae4:	6a42                	ld	s4,16(sp)
     ae6:	6aa2                	ld	s5,8(sp)
     ae8:	6121                	addi	sp,sp,64
     aea:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     aec:	863e                	mv	a2,a5
     aee:	85d6                	mv	a1,s5
     af0:	00006517          	auipc	a0,0x6
     af4:	87850513          	addi	a0,a0,-1928 # 6368 <malloc+0x888>
     af8:	00005097          	auipc	ra,0x5
     afc:	f2a080e7          	jalr	-214(ra) # 5a22 <printf>
        exit(1);
     b00:	4505                	li	a0,1
     b02:	00005097          	auipc	ra,0x5
     b06:	ba0080e7          	jalr	-1120(ra) # 56a2 <exit>
      printf("%s: read failed %d\n", s, i);
     b0a:	862a                	mv	a2,a0
     b0c:	85d6                	mv	a1,s5
     b0e:	00006517          	auipc	a0,0x6
     b12:	88250513          	addi	a0,a0,-1918 # 6390 <malloc+0x8b0>
     b16:	00005097          	auipc	ra,0x5
     b1a:	f0c080e7          	jalr	-244(ra) # 5a22 <printf>
      exit(1);
     b1e:	4505                	li	a0,1
     b20:	00005097          	auipc	ra,0x5
     b24:	b82080e7          	jalr	-1150(ra) # 56a2 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b28:	8626                	mv	a2,s1
     b2a:	85d6                	mv	a1,s5
     b2c:	00006517          	auipc	a0,0x6
     b30:	87c50513          	addi	a0,a0,-1924 # 63a8 <malloc+0x8c8>
     b34:	00005097          	auipc	ra,0x5
     b38:	eee080e7          	jalr	-274(ra) # 5a22 <printf>
      exit(1);
     b3c:	4505                	li	a0,1
     b3e:	00005097          	auipc	ra,0x5
     b42:	b64080e7          	jalr	-1180(ra) # 56a2 <exit>
    printf("%s: unlink big failed\n", s);
     b46:	85d6                	mv	a1,s5
     b48:	00006517          	auipc	a0,0x6
     b4c:	88850513          	addi	a0,a0,-1912 # 63d0 <malloc+0x8f0>
     b50:	00005097          	auipc	ra,0x5
     b54:	ed2080e7          	jalr	-302(ra) # 5a22 <printf>
    exit(1);
     b58:	4505                	li	a0,1
     b5a:	00005097          	auipc	ra,0x5
     b5e:	b48080e7          	jalr	-1208(ra) # 56a2 <exit>

0000000000000b62 <unlinkread>:
{
     b62:	7179                	addi	sp,sp,-48
     b64:	f406                	sd	ra,40(sp)
     b66:	f022                	sd	s0,32(sp)
     b68:	ec26                	sd	s1,24(sp)
     b6a:	e84a                	sd	s2,16(sp)
     b6c:	e44e                	sd	s3,8(sp)
     b6e:	1800                	addi	s0,sp,48
     b70:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b72:	20200593          	li	a1,514
     b76:	00005517          	auipc	a0,0x5
     b7a:	1b250513          	addi	a0,a0,434 # 5d28 <malloc+0x248>
     b7e:	00005097          	auipc	ra,0x5
     b82:	b64080e7          	jalr	-1180(ra) # 56e2 <open>
  if(fd < 0){
     b86:	0e054563          	bltz	a0,c70 <unlinkread+0x10e>
     b8a:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8c:	4615                	li	a2,5
     b8e:	00006597          	auipc	a1,0x6
     b92:	87a58593          	addi	a1,a1,-1926 # 6408 <malloc+0x928>
     b96:	00005097          	auipc	ra,0x5
     b9a:	b2c080e7          	jalr	-1236(ra) # 56c2 <write>
  close(fd);
     b9e:	8526                	mv	a0,s1
     ba0:	00005097          	auipc	ra,0x5
     ba4:	b2a080e7          	jalr	-1238(ra) # 56ca <close>
  fd = open("unlinkread", O_RDWR);
     ba8:	4589                	li	a1,2
     baa:	00005517          	auipc	a0,0x5
     bae:	17e50513          	addi	a0,a0,382 # 5d28 <malloc+0x248>
     bb2:	00005097          	auipc	ra,0x5
     bb6:	b30080e7          	jalr	-1232(ra) # 56e2 <open>
     bba:	84aa                	mv	s1,a0
  if(fd < 0){
     bbc:	0c054863          	bltz	a0,c8c <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bc0:	00005517          	auipc	a0,0x5
     bc4:	16850513          	addi	a0,a0,360 # 5d28 <malloc+0x248>
     bc8:	00005097          	auipc	ra,0x5
     bcc:	b2a080e7          	jalr	-1238(ra) # 56f2 <unlink>
     bd0:	ed61                	bnez	a0,ca8 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd2:	20200593          	li	a1,514
     bd6:	00005517          	auipc	a0,0x5
     bda:	15250513          	addi	a0,a0,338 # 5d28 <malloc+0x248>
     bde:	00005097          	auipc	ra,0x5
     be2:	b04080e7          	jalr	-1276(ra) # 56e2 <open>
     be6:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be8:	460d                	li	a2,3
     bea:	00006597          	auipc	a1,0x6
     bee:	86658593          	addi	a1,a1,-1946 # 6450 <malloc+0x970>
     bf2:	00005097          	auipc	ra,0x5
     bf6:	ad0080e7          	jalr	-1328(ra) # 56c2 <write>
  close(fd1);
     bfa:	854a                	mv	a0,s2
     bfc:	00005097          	auipc	ra,0x5
     c00:	ace080e7          	jalr	-1330(ra) # 56ca <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c04:	660d                	lui	a2,0x3
     c06:	0000b597          	auipc	a1,0xb
     c0a:	f7258593          	addi	a1,a1,-142 # bb78 <buf>
     c0e:	8526                	mv	a0,s1
     c10:	00005097          	auipc	ra,0x5
     c14:	aaa080e7          	jalr	-1366(ra) # 56ba <read>
     c18:	4795                	li	a5,5
     c1a:	0af51563          	bne	a0,a5,cc4 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1e:	0000b717          	auipc	a4,0xb
     c22:	f5a74703          	lbu	a4,-166(a4) # bb78 <buf>
     c26:	06800793          	li	a5,104
     c2a:	0af71b63          	bne	a4,a5,ce0 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2e:	4629                	li	a2,10
     c30:	0000b597          	auipc	a1,0xb
     c34:	f4858593          	addi	a1,a1,-184 # bb78 <buf>
     c38:	8526                	mv	a0,s1
     c3a:	00005097          	auipc	ra,0x5
     c3e:	a88080e7          	jalr	-1400(ra) # 56c2 <write>
     c42:	47a9                	li	a5,10
     c44:	0af51c63          	bne	a0,a5,cfc <unlinkread+0x19a>
  close(fd);
     c48:	8526                	mv	a0,s1
     c4a:	00005097          	auipc	ra,0x5
     c4e:	a80080e7          	jalr	-1408(ra) # 56ca <close>
  unlink("unlinkread");
     c52:	00005517          	auipc	a0,0x5
     c56:	0d650513          	addi	a0,a0,214 # 5d28 <malloc+0x248>
     c5a:	00005097          	auipc	ra,0x5
     c5e:	a98080e7          	jalr	-1384(ra) # 56f2 <unlink>
}
     c62:	70a2                	ld	ra,40(sp)
     c64:	7402                	ld	s0,32(sp)
     c66:	64e2                	ld	s1,24(sp)
     c68:	6942                	ld	s2,16(sp)
     c6a:	69a2                	ld	s3,8(sp)
     c6c:	6145                	addi	sp,sp,48
     c6e:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c70:	85ce                	mv	a1,s3
     c72:	00005517          	auipc	a0,0x5
     c76:	77650513          	addi	a0,a0,1910 # 63e8 <malloc+0x908>
     c7a:	00005097          	auipc	ra,0x5
     c7e:	da8080e7          	jalr	-600(ra) # 5a22 <printf>
    exit(1);
     c82:	4505                	li	a0,1
     c84:	00005097          	auipc	ra,0x5
     c88:	a1e080e7          	jalr	-1506(ra) # 56a2 <exit>
    printf("%s: open unlinkread failed\n", s);
     c8c:	85ce                	mv	a1,s3
     c8e:	00005517          	auipc	a0,0x5
     c92:	78250513          	addi	a0,a0,1922 # 6410 <malloc+0x930>
     c96:	00005097          	auipc	ra,0x5
     c9a:	d8c080e7          	jalr	-628(ra) # 5a22 <printf>
    exit(1);
     c9e:	4505                	li	a0,1
     ca0:	00005097          	auipc	ra,0x5
     ca4:	a02080e7          	jalr	-1534(ra) # 56a2 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca8:	85ce                	mv	a1,s3
     caa:	00005517          	auipc	a0,0x5
     cae:	78650513          	addi	a0,a0,1926 # 6430 <malloc+0x950>
     cb2:	00005097          	auipc	ra,0x5
     cb6:	d70080e7          	jalr	-656(ra) # 5a22 <printf>
    exit(1);
     cba:	4505                	li	a0,1
     cbc:	00005097          	auipc	ra,0x5
     cc0:	9e6080e7          	jalr	-1562(ra) # 56a2 <exit>
    printf("%s: unlinkread read failed", s);
     cc4:	85ce                	mv	a1,s3
     cc6:	00005517          	auipc	a0,0x5
     cca:	79250513          	addi	a0,a0,1938 # 6458 <malloc+0x978>
     cce:	00005097          	auipc	ra,0x5
     cd2:	d54080e7          	jalr	-684(ra) # 5a22 <printf>
    exit(1);
     cd6:	4505                	li	a0,1
     cd8:	00005097          	auipc	ra,0x5
     cdc:	9ca080e7          	jalr	-1590(ra) # 56a2 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ce0:	85ce                	mv	a1,s3
     ce2:	00005517          	auipc	a0,0x5
     ce6:	79650513          	addi	a0,a0,1942 # 6478 <malloc+0x998>
     cea:	00005097          	auipc	ra,0x5
     cee:	d38080e7          	jalr	-712(ra) # 5a22 <printf>
    exit(1);
     cf2:	4505                	li	a0,1
     cf4:	00005097          	auipc	ra,0x5
     cf8:	9ae080e7          	jalr	-1618(ra) # 56a2 <exit>
    printf("%s: unlinkread write failed\n", s);
     cfc:	85ce                	mv	a1,s3
     cfe:	00005517          	auipc	a0,0x5
     d02:	79a50513          	addi	a0,a0,1946 # 6498 <malloc+0x9b8>
     d06:	00005097          	auipc	ra,0x5
     d0a:	d1c080e7          	jalr	-740(ra) # 5a22 <printf>
    exit(1);
     d0e:	4505                	li	a0,1
     d10:	00005097          	auipc	ra,0x5
     d14:	992080e7          	jalr	-1646(ra) # 56a2 <exit>

0000000000000d18 <linktest>:
{
     d18:	1101                	addi	sp,sp,-32
     d1a:	ec06                	sd	ra,24(sp)
     d1c:	e822                	sd	s0,16(sp)
     d1e:	e426                	sd	s1,8(sp)
     d20:	e04a                	sd	s2,0(sp)
     d22:	1000                	addi	s0,sp,32
     d24:	892a                	mv	s2,a0
  unlink("lf1");
     d26:	00005517          	auipc	a0,0x5
     d2a:	79250513          	addi	a0,a0,1938 # 64b8 <malloc+0x9d8>
     d2e:	00005097          	auipc	ra,0x5
     d32:	9c4080e7          	jalr	-1596(ra) # 56f2 <unlink>
  unlink("lf2");
     d36:	00005517          	auipc	a0,0x5
     d3a:	78a50513          	addi	a0,a0,1930 # 64c0 <malloc+0x9e0>
     d3e:	00005097          	auipc	ra,0x5
     d42:	9b4080e7          	jalr	-1612(ra) # 56f2 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d46:	20200593          	li	a1,514
     d4a:	00005517          	auipc	a0,0x5
     d4e:	76e50513          	addi	a0,a0,1902 # 64b8 <malloc+0x9d8>
     d52:	00005097          	auipc	ra,0x5
     d56:	990080e7          	jalr	-1648(ra) # 56e2 <open>
  if(fd < 0){
     d5a:	10054763          	bltz	a0,e68 <linktest+0x150>
     d5e:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d60:	4615                	li	a2,5
     d62:	00005597          	auipc	a1,0x5
     d66:	6a658593          	addi	a1,a1,1702 # 6408 <malloc+0x928>
     d6a:	00005097          	auipc	ra,0x5
     d6e:	958080e7          	jalr	-1704(ra) # 56c2 <write>
     d72:	4795                	li	a5,5
     d74:	10f51863          	bne	a0,a5,e84 <linktest+0x16c>
  close(fd);
     d78:	8526                	mv	a0,s1
     d7a:	00005097          	auipc	ra,0x5
     d7e:	950080e7          	jalr	-1712(ra) # 56ca <close>
  if(link("lf1", "lf2") < 0){
     d82:	00005597          	auipc	a1,0x5
     d86:	73e58593          	addi	a1,a1,1854 # 64c0 <malloc+0x9e0>
     d8a:	00005517          	auipc	a0,0x5
     d8e:	72e50513          	addi	a0,a0,1838 # 64b8 <malloc+0x9d8>
     d92:	00005097          	auipc	ra,0x5
     d96:	970080e7          	jalr	-1680(ra) # 5702 <link>
     d9a:	10054363          	bltz	a0,ea0 <linktest+0x188>
  unlink("lf1");
     d9e:	00005517          	auipc	a0,0x5
     da2:	71a50513          	addi	a0,a0,1818 # 64b8 <malloc+0x9d8>
     da6:	00005097          	auipc	ra,0x5
     daa:	94c080e7          	jalr	-1716(ra) # 56f2 <unlink>
  if(open("lf1", 0) >= 0){
     dae:	4581                	li	a1,0
     db0:	00005517          	auipc	a0,0x5
     db4:	70850513          	addi	a0,a0,1800 # 64b8 <malloc+0x9d8>
     db8:	00005097          	auipc	ra,0x5
     dbc:	92a080e7          	jalr	-1750(ra) # 56e2 <open>
     dc0:	0e055e63          	bgez	a0,ebc <linktest+0x1a4>
  fd = open("lf2", 0);
     dc4:	4581                	li	a1,0
     dc6:	00005517          	auipc	a0,0x5
     dca:	6fa50513          	addi	a0,a0,1786 # 64c0 <malloc+0x9e0>
     dce:	00005097          	auipc	ra,0x5
     dd2:	914080e7          	jalr	-1772(ra) # 56e2 <open>
     dd6:	84aa                	mv	s1,a0
  if(fd < 0){
     dd8:	10054063          	bltz	a0,ed8 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ddc:	660d                	lui	a2,0x3
     dde:	0000b597          	auipc	a1,0xb
     de2:	d9a58593          	addi	a1,a1,-614 # bb78 <buf>
     de6:	00005097          	auipc	ra,0x5
     dea:	8d4080e7          	jalr	-1836(ra) # 56ba <read>
     dee:	4795                	li	a5,5
     df0:	10f51263          	bne	a0,a5,ef4 <linktest+0x1dc>
  close(fd);
     df4:	8526                	mv	a0,s1
     df6:	00005097          	auipc	ra,0x5
     dfa:	8d4080e7          	jalr	-1836(ra) # 56ca <close>
  if(link("lf2", "lf2") >= 0){
     dfe:	00005597          	auipc	a1,0x5
     e02:	6c258593          	addi	a1,a1,1730 # 64c0 <malloc+0x9e0>
     e06:	852e                	mv	a0,a1
     e08:	00005097          	auipc	ra,0x5
     e0c:	8fa080e7          	jalr	-1798(ra) # 5702 <link>
     e10:	10055063          	bgez	a0,f10 <linktest+0x1f8>
  unlink("lf2");
     e14:	00005517          	auipc	a0,0x5
     e18:	6ac50513          	addi	a0,a0,1708 # 64c0 <malloc+0x9e0>
     e1c:	00005097          	auipc	ra,0x5
     e20:	8d6080e7          	jalr	-1834(ra) # 56f2 <unlink>
  if(link("lf2", "lf1") >= 0){
     e24:	00005597          	auipc	a1,0x5
     e28:	69458593          	addi	a1,a1,1684 # 64b8 <malloc+0x9d8>
     e2c:	00005517          	auipc	a0,0x5
     e30:	69450513          	addi	a0,a0,1684 # 64c0 <malloc+0x9e0>
     e34:	00005097          	auipc	ra,0x5
     e38:	8ce080e7          	jalr	-1842(ra) # 5702 <link>
     e3c:	0e055863          	bgez	a0,f2c <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e40:	00005597          	auipc	a1,0x5
     e44:	67858593          	addi	a1,a1,1656 # 64b8 <malloc+0x9d8>
     e48:	00005517          	auipc	a0,0x5
     e4c:	78050513          	addi	a0,a0,1920 # 65c8 <malloc+0xae8>
     e50:	00005097          	auipc	ra,0x5
     e54:	8b2080e7          	jalr	-1870(ra) # 5702 <link>
     e58:	0e055863          	bgez	a0,f48 <linktest+0x230>
}
     e5c:	60e2                	ld	ra,24(sp)
     e5e:	6442                	ld	s0,16(sp)
     e60:	64a2                	ld	s1,8(sp)
     e62:	6902                	ld	s2,0(sp)
     e64:	6105                	addi	sp,sp,32
     e66:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e68:	85ca                	mv	a1,s2
     e6a:	00005517          	auipc	a0,0x5
     e6e:	65e50513          	addi	a0,a0,1630 # 64c8 <malloc+0x9e8>
     e72:	00005097          	auipc	ra,0x5
     e76:	bb0080e7          	jalr	-1104(ra) # 5a22 <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	00005097          	auipc	ra,0x5
     e80:	826080e7          	jalr	-2010(ra) # 56a2 <exit>
    printf("%s: write lf1 failed\n", s);
     e84:	85ca                	mv	a1,s2
     e86:	00005517          	auipc	a0,0x5
     e8a:	65a50513          	addi	a0,a0,1626 # 64e0 <malloc+0xa00>
     e8e:	00005097          	auipc	ra,0x5
     e92:	b94080e7          	jalr	-1132(ra) # 5a22 <printf>
    exit(1);
     e96:	4505                	li	a0,1
     e98:	00005097          	auipc	ra,0x5
     e9c:	80a080e7          	jalr	-2038(ra) # 56a2 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ea0:	85ca                	mv	a1,s2
     ea2:	00005517          	auipc	a0,0x5
     ea6:	65650513          	addi	a0,a0,1622 # 64f8 <malloc+0xa18>
     eaa:	00005097          	auipc	ra,0x5
     eae:	b78080e7          	jalr	-1160(ra) # 5a22 <printf>
    exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00004097          	auipc	ra,0x4
     eb8:	7ee080e7          	jalr	2030(ra) # 56a2 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ebc:	85ca                	mv	a1,s2
     ebe:	00005517          	auipc	a0,0x5
     ec2:	65a50513          	addi	a0,a0,1626 # 6518 <malloc+0xa38>
     ec6:	00005097          	auipc	ra,0x5
     eca:	b5c080e7          	jalr	-1188(ra) # 5a22 <printf>
    exit(1);
     ece:	4505                	li	a0,1
     ed0:	00004097          	auipc	ra,0x4
     ed4:	7d2080e7          	jalr	2002(ra) # 56a2 <exit>
    printf("%s: open lf2 failed\n", s);
     ed8:	85ca                	mv	a1,s2
     eda:	00005517          	auipc	a0,0x5
     ede:	66e50513          	addi	a0,a0,1646 # 6548 <malloc+0xa68>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	b40080e7          	jalr	-1216(ra) # 5a22 <printf>
    exit(1);
     eea:	4505                	li	a0,1
     eec:	00004097          	auipc	ra,0x4
     ef0:	7b6080e7          	jalr	1974(ra) # 56a2 <exit>
    printf("%s: read lf2 failed\n", s);
     ef4:	85ca                	mv	a1,s2
     ef6:	00005517          	auipc	a0,0x5
     efa:	66a50513          	addi	a0,a0,1642 # 6560 <malloc+0xa80>
     efe:	00005097          	auipc	ra,0x5
     f02:	b24080e7          	jalr	-1244(ra) # 5a22 <printf>
    exit(1);
     f06:	4505                	li	a0,1
     f08:	00004097          	auipc	ra,0x4
     f0c:	79a080e7          	jalr	1946(ra) # 56a2 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f10:	85ca                	mv	a1,s2
     f12:	00005517          	auipc	a0,0x5
     f16:	66650513          	addi	a0,a0,1638 # 6578 <malloc+0xa98>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	b08080e7          	jalr	-1272(ra) # 5a22 <printf>
    exit(1);
     f22:	4505                	li	a0,1
     f24:	00004097          	auipc	ra,0x4
     f28:	77e080e7          	jalr	1918(ra) # 56a2 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f2c:	85ca                	mv	a1,s2
     f2e:	00005517          	auipc	a0,0x5
     f32:	67250513          	addi	a0,a0,1650 # 65a0 <malloc+0xac0>
     f36:	00005097          	auipc	ra,0x5
     f3a:	aec080e7          	jalr	-1300(ra) # 5a22 <printf>
    exit(1);
     f3e:	4505                	li	a0,1
     f40:	00004097          	auipc	ra,0x4
     f44:	762080e7          	jalr	1890(ra) # 56a2 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f48:	85ca                	mv	a1,s2
     f4a:	00005517          	auipc	a0,0x5
     f4e:	68650513          	addi	a0,a0,1670 # 65d0 <malloc+0xaf0>
     f52:	00005097          	auipc	ra,0x5
     f56:	ad0080e7          	jalr	-1328(ra) # 5a22 <printf>
    exit(1);
     f5a:	4505                	li	a0,1
     f5c:	00004097          	auipc	ra,0x4
     f60:	746080e7          	jalr	1862(ra) # 56a2 <exit>

0000000000000f64 <bigdir>:
{
     f64:	715d                	addi	sp,sp,-80
     f66:	e486                	sd	ra,72(sp)
     f68:	e0a2                	sd	s0,64(sp)
     f6a:	fc26                	sd	s1,56(sp)
     f6c:	f84a                	sd	s2,48(sp)
     f6e:	f44e                	sd	s3,40(sp)
     f70:	f052                	sd	s4,32(sp)
     f72:	ec56                	sd	s5,24(sp)
     f74:	e85a                	sd	s6,16(sp)
     f76:	0880                	addi	s0,sp,80
     f78:	89aa                	mv	s3,a0
  unlink("bd");
     f7a:	00005517          	auipc	a0,0x5
     f7e:	67650513          	addi	a0,a0,1654 # 65f0 <malloc+0xb10>
     f82:	00004097          	auipc	ra,0x4
     f86:	770080e7          	jalr	1904(ra) # 56f2 <unlink>
  fd = open("bd", O_CREATE);
     f8a:	20000593          	li	a1,512
     f8e:	00005517          	auipc	a0,0x5
     f92:	66250513          	addi	a0,a0,1634 # 65f0 <malloc+0xb10>
     f96:	00004097          	auipc	ra,0x4
     f9a:	74c080e7          	jalr	1868(ra) # 56e2 <open>
  if(fd < 0){
     f9e:	0c054963          	bltz	a0,1070 <bigdir+0x10c>
  close(fd);
     fa2:	00004097          	auipc	ra,0x4
     fa6:	728080e7          	jalr	1832(ra) # 56ca <close>
  for(i = 0; i < N; i++){
     faa:	4901                	li	s2,0
    name[0] = 'x';
     fac:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fb0:	00005a17          	auipc	s4,0x5
     fb4:	640a0a13          	addi	s4,s4,1600 # 65f0 <malloc+0xb10>
  for(i = 0; i < N; i++){
     fb8:	1f400b13          	li	s6,500
    name[0] = 'x';
     fbc:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fc0:	41f9579b          	sraiw	a5,s2,0x1f
     fc4:	01a7d71b          	srliw	a4,a5,0x1a
     fc8:	012707bb          	addw	a5,a4,s2
     fcc:	4067d69b          	sraiw	a3,a5,0x6
     fd0:	0306869b          	addiw	a3,a3,48
     fd4:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd8:	03f7f793          	andi	a5,a5,63
     fdc:	9f99                	subw	a5,a5,a4
     fde:	0307879b          	addiw	a5,a5,48
     fe2:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe6:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fea:	fb040593          	addi	a1,s0,-80
     fee:	8552                	mv	a0,s4
     ff0:	00004097          	auipc	ra,0x4
     ff4:	712080e7          	jalr	1810(ra) # 5702 <link>
     ff8:	84aa                	mv	s1,a0
     ffa:	e949                	bnez	a0,108c <bigdir+0x128>
  for(i = 0; i < N; i++){
     ffc:	2905                	addiw	s2,s2,1
     ffe:	fb691fe3          	bne	s2,s6,fbc <bigdir+0x58>
  unlink("bd");
    1002:	00005517          	auipc	a0,0x5
    1006:	5ee50513          	addi	a0,a0,1518 # 65f0 <malloc+0xb10>
    100a:	00004097          	auipc	ra,0x4
    100e:	6e8080e7          	jalr	1768(ra) # 56f2 <unlink>
    name[0] = 'x';
    1012:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1016:	1f400a13          	li	s4,500
    name[0] = 'x';
    101a:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101e:	41f4d79b          	sraiw	a5,s1,0x1f
    1022:	01a7d71b          	srliw	a4,a5,0x1a
    1026:	009707bb          	addw	a5,a4,s1
    102a:	4067d69b          	sraiw	a3,a5,0x6
    102e:	0306869b          	addiw	a3,a3,48
    1032:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1036:	03f7f793          	andi	a5,a5,63
    103a:	9f99                	subw	a5,a5,a4
    103c:	0307879b          	addiw	a5,a5,48
    1040:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1044:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1048:	fb040513          	addi	a0,s0,-80
    104c:	00004097          	auipc	ra,0x4
    1050:	6a6080e7          	jalr	1702(ra) # 56f2 <unlink>
    1054:	ed21                	bnez	a0,10ac <bigdir+0x148>
  for(i = 0; i < N; i++){
    1056:	2485                	addiw	s1,s1,1
    1058:	fd4491e3          	bne	s1,s4,101a <bigdir+0xb6>
}
    105c:	60a6                	ld	ra,72(sp)
    105e:	6406                	ld	s0,64(sp)
    1060:	74e2                	ld	s1,56(sp)
    1062:	7942                	ld	s2,48(sp)
    1064:	79a2                	ld	s3,40(sp)
    1066:	7a02                	ld	s4,32(sp)
    1068:	6ae2                	ld	s5,24(sp)
    106a:	6b42                	ld	s6,16(sp)
    106c:	6161                	addi	sp,sp,80
    106e:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1070:	85ce                	mv	a1,s3
    1072:	00005517          	auipc	a0,0x5
    1076:	58650513          	addi	a0,a0,1414 # 65f8 <malloc+0xb18>
    107a:	00005097          	auipc	ra,0x5
    107e:	9a8080e7          	jalr	-1624(ra) # 5a22 <printf>
    exit(1);
    1082:	4505                	li	a0,1
    1084:	00004097          	auipc	ra,0x4
    1088:	61e080e7          	jalr	1566(ra) # 56a2 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    108c:	fb040613          	addi	a2,s0,-80
    1090:	85ce                	mv	a1,s3
    1092:	00005517          	auipc	a0,0x5
    1096:	58650513          	addi	a0,a0,1414 # 6618 <malloc+0xb38>
    109a:	00005097          	auipc	ra,0x5
    109e:	988080e7          	jalr	-1656(ra) # 5a22 <printf>
      exit(1);
    10a2:	4505                	li	a0,1
    10a4:	00004097          	auipc	ra,0x4
    10a8:	5fe080e7          	jalr	1534(ra) # 56a2 <exit>
      printf("%s: bigdir unlink failed", s);
    10ac:	85ce                	mv	a1,s3
    10ae:	00005517          	auipc	a0,0x5
    10b2:	58a50513          	addi	a0,a0,1418 # 6638 <malloc+0xb58>
    10b6:	00005097          	auipc	ra,0x5
    10ba:	96c080e7          	jalr	-1684(ra) # 5a22 <printf>
      exit(1);
    10be:	4505                	li	a0,1
    10c0:	00004097          	auipc	ra,0x4
    10c4:	5e2080e7          	jalr	1506(ra) # 56a2 <exit>

00000000000010c8 <validatetest>:
{
    10c8:	7139                	addi	sp,sp,-64
    10ca:	fc06                	sd	ra,56(sp)
    10cc:	f822                	sd	s0,48(sp)
    10ce:	f426                	sd	s1,40(sp)
    10d0:	f04a                	sd	s2,32(sp)
    10d2:	ec4e                	sd	s3,24(sp)
    10d4:	e852                	sd	s4,16(sp)
    10d6:	e456                	sd	s5,8(sp)
    10d8:	e05a                	sd	s6,0(sp)
    10da:	0080                	addi	s0,sp,64
    10dc:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10de:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10e0:	00005997          	auipc	s3,0x5
    10e4:	57898993          	addi	s3,s3,1400 # 6658 <malloc+0xb78>
    10e8:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10ea:	6a85                	lui	s5,0x1
    10ec:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10f0:	85a6                	mv	a1,s1
    10f2:	854e                	mv	a0,s3
    10f4:	00004097          	auipc	ra,0x4
    10f8:	60e080e7          	jalr	1550(ra) # 5702 <link>
    10fc:	01251f63          	bne	a0,s2,111a <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1100:	94d6                	add	s1,s1,s5
    1102:	ff4497e3          	bne	s1,s4,10f0 <validatetest+0x28>
}
    1106:	70e2                	ld	ra,56(sp)
    1108:	7442                	ld	s0,48(sp)
    110a:	74a2                	ld	s1,40(sp)
    110c:	7902                	ld	s2,32(sp)
    110e:	69e2                	ld	s3,24(sp)
    1110:	6a42                	ld	s4,16(sp)
    1112:	6aa2                	ld	s5,8(sp)
    1114:	6b02                	ld	s6,0(sp)
    1116:	6121                	addi	sp,sp,64
    1118:	8082                	ret
      printf("%s: link should not succeed\n", s);
    111a:	85da                	mv	a1,s6
    111c:	00005517          	auipc	a0,0x5
    1120:	54c50513          	addi	a0,a0,1356 # 6668 <malloc+0xb88>
    1124:	00005097          	auipc	ra,0x5
    1128:	8fe080e7          	jalr	-1794(ra) # 5a22 <printf>
      exit(1);
    112c:	4505                	li	a0,1
    112e:	00004097          	auipc	ra,0x4
    1132:	574080e7          	jalr	1396(ra) # 56a2 <exit>

0000000000001136 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1136:	7179                	addi	sp,sp,-48
    1138:	f406                	sd	ra,40(sp)
    113a:	f022                	sd	s0,32(sp)
    113c:	ec26                	sd	s1,24(sp)
    113e:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1140:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1144:	00007497          	auipc	s1,0x7
    1148:	2044b483          	ld	s1,516(s1) # 8348 <__SDATA_BEGIN__>
    114c:	fd840593          	addi	a1,s0,-40
    1150:	8526                	mv	a0,s1
    1152:	00004097          	auipc	ra,0x4
    1156:	588080e7          	jalr	1416(ra) # 56da <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    115a:	8526                	mv	a0,s1
    115c:	00004097          	auipc	ra,0x4
    1160:	556080e7          	jalr	1366(ra) # 56b2 <pipe>

  exit(0);
    1164:	4501                	li	a0,0
    1166:	00004097          	auipc	ra,0x4
    116a:	53c080e7          	jalr	1340(ra) # 56a2 <exit>

000000000000116e <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116e:	7139                	addi	sp,sp,-64
    1170:	fc06                	sd	ra,56(sp)
    1172:	f822                	sd	s0,48(sp)
    1174:	f426                	sd	s1,40(sp)
    1176:	f04a                	sd	s2,32(sp)
    1178:	ec4e                	sd	s3,24(sp)
    117a:	0080                	addi	s0,sp,64
    117c:	64b1                	lui	s1,0xc
    117e:	35048493          	addi	s1,s1,848 # c350 <buf+0x7d8>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1182:	597d                	li	s2,-1
    1184:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1188:	00005997          	auipc	s3,0x5
    118c:	da898993          	addi	s3,s3,-600 # 5f30 <malloc+0x450>
    argv[0] = (char*)0xffffffff;
    1190:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1194:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1198:	fc040593          	addi	a1,s0,-64
    119c:	854e                	mv	a0,s3
    119e:	00004097          	auipc	ra,0x4
    11a2:	53c080e7          	jalr	1340(ra) # 56da <exec>
  for(int i = 0; i < 50000; i++){
    11a6:	34fd                	addiw	s1,s1,-1
    11a8:	f4e5                	bnez	s1,1190 <badarg+0x22>
  }
  
  exit(0);
    11aa:	4501                	li	a0,0
    11ac:	00004097          	auipc	ra,0x4
    11b0:	4f6080e7          	jalr	1270(ra) # 56a2 <exit>

00000000000011b4 <copyinstr2>:
{
    11b4:	7155                	addi	sp,sp,-208
    11b6:	e586                	sd	ra,200(sp)
    11b8:	e1a2                	sd	s0,192(sp)
    11ba:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11bc:	f6840793          	addi	a5,s0,-152
    11c0:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c4:	07800713          	li	a4,120
    11c8:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11cc:	0785                	addi	a5,a5,1
    11ce:	fed79de3          	bne	a5,a3,11c8 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d2:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d6:	f6840513          	addi	a0,s0,-152
    11da:	00004097          	auipc	ra,0x4
    11de:	518080e7          	jalr	1304(ra) # 56f2 <unlink>
  if(ret != -1){
    11e2:	57fd                	li	a5,-1
    11e4:	0ef51063          	bne	a0,a5,12c4 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e8:	20100593          	li	a1,513
    11ec:	f6840513          	addi	a0,s0,-152
    11f0:	00004097          	auipc	ra,0x4
    11f4:	4f2080e7          	jalr	1266(ra) # 56e2 <open>
  if(fd != -1){
    11f8:	57fd                	li	a5,-1
    11fa:	0ef51563          	bne	a0,a5,12e4 <copyinstr2+0x130>
  ret = link(b, b);
    11fe:	f6840593          	addi	a1,s0,-152
    1202:	852e                	mv	a0,a1
    1204:	00004097          	auipc	ra,0x4
    1208:	4fe080e7          	jalr	1278(ra) # 5702 <link>
  if(ret != -1){
    120c:	57fd                	li	a5,-1
    120e:	0ef51b63          	bne	a0,a5,1304 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1212:	00006797          	auipc	a5,0x6
    1216:	62678793          	addi	a5,a5,1574 # 7838 <malloc+0x1d58>
    121a:	f4f43c23          	sd	a5,-168(s0)
    121e:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1222:	f5840593          	addi	a1,s0,-168
    1226:	f6840513          	addi	a0,s0,-152
    122a:	00004097          	auipc	ra,0x4
    122e:	4b0080e7          	jalr	1200(ra) # 56da <exec>
  if(ret != -1){
    1232:	57fd                	li	a5,-1
    1234:	0ef51963          	bne	a0,a5,1326 <copyinstr2+0x172>
  int pid = fork();
    1238:	00004097          	auipc	ra,0x4
    123c:	462080e7          	jalr	1122(ra) # 569a <fork>
  if(pid < 0){
    1240:	10054363          	bltz	a0,1346 <copyinstr2+0x192>
  if(pid == 0){
    1244:	12051463          	bnez	a0,136c <copyinstr2+0x1b8>
    1248:	00007797          	auipc	a5,0x7
    124c:	21878793          	addi	a5,a5,536 # 8460 <big.0>
    1250:	00008697          	auipc	a3,0x8
    1254:	21068693          	addi	a3,a3,528 # 9460 <__global_pointer$+0x918>
      big[i] = 'x';
    1258:	07800713          	li	a4,120
    125c:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1260:	0785                	addi	a5,a5,1
    1262:	fed79de3          	bne	a5,a3,125c <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1266:	00008797          	auipc	a5,0x8
    126a:	1e078d23          	sb	zero,506(a5) # 9460 <__global_pointer$+0x918>
    char *args2[] = { big, big, big, 0 };
    126e:	00007797          	auipc	a5,0x7
    1272:	cda78793          	addi	a5,a5,-806 # 7f48 <malloc+0x2468>
    1276:	6390                	ld	a2,0(a5)
    1278:	6794                	ld	a3,8(a5)
    127a:	6b98                	ld	a4,16(a5)
    127c:	6f9c                	ld	a5,24(a5)
    127e:	f2c43823          	sd	a2,-208(s0)
    1282:	f2d43c23          	sd	a3,-200(s0)
    1286:	f4e43023          	sd	a4,-192(s0)
    128a:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128e:	f3040593          	addi	a1,s0,-208
    1292:	00005517          	auipc	a0,0x5
    1296:	c9e50513          	addi	a0,a0,-866 # 5f30 <malloc+0x450>
    129a:	00004097          	auipc	ra,0x4
    129e:	440080e7          	jalr	1088(ra) # 56da <exec>
    if(ret != -1){
    12a2:	57fd                	li	a5,-1
    12a4:	0af50e63          	beq	a0,a5,1360 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a8:	55fd                	li	a1,-1
    12aa:	00005517          	auipc	a0,0x5
    12ae:	46650513          	addi	a0,a0,1126 # 6710 <malloc+0xc30>
    12b2:	00004097          	auipc	ra,0x4
    12b6:	770080e7          	jalr	1904(ra) # 5a22 <printf>
      exit(1);
    12ba:	4505                	li	a0,1
    12bc:	00004097          	auipc	ra,0x4
    12c0:	3e6080e7          	jalr	998(ra) # 56a2 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c4:	862a                	mv	a2,a0
    12c6:	f6840593          	addi	a1,s0,-152
    12ca:	00005517          	auipc	a0,0x5
    12ce:	3be50513          	addi	a0,a0,958 # 6688 <malloc+0xba8>
    12d2:	00004097          	auipc	ra,0x4
    12d6:	750080e7          	jalr	1872(ra) # 5a22 <printf>
    exit(1);
    12da:	4505                	li	a0,1
    12dc:	00004097          	auipc	ra,0x4
    12e0:	3c6080e7          	jalr	966(ra) # 56a2 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e4:	862a                	mv	a2,a0
    12e6:	f6840593          	addi	a1,s0,-152
    12ea:	00005517          	auipc	a0,0x5
    12ee:	3be50513          	addi	a0,a0,958 # 66a8 <malloc+0xbc8>
    12f2:	00004097          	auipc	ra,0x4
    12f6:	730080e7          	jalr	1840(ra) # 5a22 <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	00004097          	auipc	ra,0x4
    1300:	3a6080e7          	jalr	934(ra) # 56a2 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1304:	86aa                	mv	a3,a0
    1306:	f6840613          	addi	a2,s0,-152
    130a:	85b2                	mv	a1,a2
    130c:	00005517          	auipc	a0,0x5
    1310:	3bc50513          	addi	a0,a0,956 # 66c8 <malloc+0xbe8>
    1314:	00004097          	auipc	ra,0x4
    1318:	70e080e7          	jalr	1806(ra) # 5a22 <printf>
    exit(1);
    131c:	4505                	li	a0,1
    131e:	00004097          	auipc	ra,0x4
    1322:	384080e7          	jalr	900(ra) # 56a2 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1326:	567d                	li	a2,-1
    1328:	f6840593          	addi	a1,s0,-152
    132c:	00005517          	auipc	a0,0x5
    1330:	3c450513          	addi	a0,a0,964 # 66f0 <malloc+0xc10>
    1334:	00004097          	auipc	ra,0x4
    1338:	6ee080e7          	jalr	1774(ra) # 5a22 <printf>
    exit(1);
    133c:	4505                	li	a0,1
    133e:	00004097          	auipc	ra,0x4
    1342:	364080e7          	jalr	868(ra) # 56a2 <exit>
    printf("fork failed\n");
    1346:	00006517          	auipc	a0,0x6
    134a:	82a50513          	addi	a0,a0,-2006 # 6b70 <malloc+0x1090>
    134e:	00004097          	auipc	ra,0x4
    1352:	6d4080e7          	jalr	1748(ra) # 5a22 <printf>
    exit(1);
    1356:	4505                	li	a0,1
    1358:	00004097          	auipc	ra,0x4
    135c:	34a080e7          	jalr	842(ra) # 56a2 <exit>
    exit(747); // OK
    1360:	2eb00513          	li	a0,747
    1364:	00004097          	auipc	ra,0x4
    1368:	33e080e7          	jalr	830(ra) # 56a2 <exit>
  int st = 0;
    136c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1370:	f5440513          	addi	a0,s0,-172
    1374:	00004097          	auipc	ra,0x4
    1378:	336080e7          	jalr	822(ra) # 56aa <wait>
  if(st != 747){
    137c:	f5442703          	lw	a4,-172(s0)
    1380:	2eb00793          	li	a5,747
    1384:	00f71663          	bne	a4,a5,1390 <copyinstr2+0x1dc>
}
    1388:	60ae                	ld	ra,200(sp)
    138a:	640e                	ld	s0,192(sp)
    138c:	6169                	addi	sp,sp,208
    138e:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1390:	00005517          	auipc	a0,0x5
    1394:	3a850513          	addi	a0,a0,936 # 6738 <malloc+0xc58>
    1398:	00004097          	auipc	ra,0x4
    139c:	68a080e7          	jalr	1674(ra) # 5a22 <printf>
    exit(1);
    13a0:	4505                	li	a0,1
    13a2:	00004097          	auipc	ra,0x4
    13a6:	300080e7          	jalr	768(ra) # 56a2 <exit>

00000000000013aa <truncate3>:
{
    13aa:	7159                	addi	sp,sp,-112
    13ac:	f486                	sd	ra,104(sp)
    13ae:	f0a2                	sd	s0,96(sp)
    13b0:	eca6                	sd	s1,88(sp)
    13b2:	e8ca                	sd	s2,80(sp)
    13b4:	e4ce                	sd	s3,72(sp)
    13b6:	e0d2                	sd	s4,64(sp)
    13b8:	fc56                	sd	s5,56(sp)
    13ba:	1880                	addi	s0,sp,112
    13bc:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13be:	60100593          	li	a1,1537
    13c2:	00005517          	auipc	a0,0x5
    13c6:	bc650513          	addi	a0,a0,-1082 # 5f88 <malloc+0x4a8>
    13ca:	00004097          	auipc	ra,0x4
    13ce:	318080e7          	jalr	792(ra) # 56e2 <open>
    13d2:	00004097          	auipc	ra,0x4
    13d6:	2f8080e7          	jalr	760(ra) # 56ca <close>
  pid = fork();
    13da:	00004097          	auipc	ra,0x4
    13de:	2c0080e7          	jalr	704(ra) # 569a <fork>
  if(pid < 0){
    13e2:	08054063          	bltz	a0,1462 <truncate3+0xb8>
  if(pid == 0){
    13e6:	e969                	bnez	a0,14b8 <truncate3+0x10e>
    13e8:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13ec:	00005a17          	auipc	s4,0x5
    13f0:	b9ca0a13          	addi	s4,s4,-1124 # 5f88 <malloc+0x4a8>
      int n = write(fd, "1234567890", 10);
    13f4:	00005a97          	auipc	s5,0x5
    13f8:	3a4a8a93          	addi	s5,s5,932 # 6798 <malloc+0xcb8>
      int fd = open("truncfile", O_WRONLY);
    13fc:	4585                	li	a1,1
    13fe:	8552                	mv	a0,s4
    1400:	00004097          	auipc	ra,0x4
    1404:	2e2080e7          	jalr	738(ra) # 56e2 <open>
    1408:	84aa                	mv	s1,a0
      if(fd < 0){
    140a:	06054a63          	bltz	a0,147e <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140e:	4629                	li	a2,10
    1410:	85d6                	mv	a1,s5
    1412:	00004097          	auipc	ra,0x4
    1416:	2b0080e7          	jalr	688(ra) # 56c2 <write>
      if(n != 10){
    141a:	47a9                	li	a5,10
    141c:	06f51f63          	bne	a0,a5,149a <truncate3+0xf0>
      close(fd);
    1420:	8526                	mv	a0,s1
    1422:	00004097          	auipc	ra,0x4
    1426:	2a8080e7          	jalr	680(ra) # 56ca <close>
      fd = open("truncfile", O_RDONLY);
    142a:	4581                	li	a1,0
    142c:	8552                	mv	a0,s4
    142e:	00004097          	auipc	ra,0x4
    1432:	2b4080e7          	jalr	692(ra) # 56e2 <open>
    1436:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1438:	02000613          	li	a2,32
    143c:	f9840593          	addi	a1,s0,-104
    1440:	00004097          	auipc	ra,0x4
    1444:	27a080e7          	jalr	634(ra) # 56ba <read>
      close(fd);
    1448:	8526                	mv	a0,s1
    144a:	00004097          	auipc	ra,0x4
    144e:	280080e7          	jalr	640(ra) # 56ca <close>
    for(int i = 0; i < 100; i++){
    1452:	39fd                	addiw	s3,s3,-1
    1454:	fa0994e3          	bnez	s3,13fc <truncate3+0x52>
    exit(0);
    1458:	4501                	li	a0,0
    145a:	00004097          	auipc	ra,0x4
    145e:	248080e7          	jalr	584(ra) # 56a2 <exit>
    printf("%s: fork failed\n", s);
    1462:	85ca                	mv	a1,s2
    1464:	00005517          	auipc	a0,0x5
    1468:	30450513          	addi	a0,a0,772 # 6768 <malloc+0xc88>
    146c:	00004097          	auipc	ra,0x4
    1470:	5b6080e7          	jalr	1462(ra) # 5a22 <printf>
    exit(1);
    1474:	4505                	li	a0,1
    1476:	00004097          	auipc	ra,0x4
    147a:	22c080e7          	jalr	556(ra) # 56a2 <exit>
        printf("%s: open failed\n", s);
    147e:	85ca                	mv	a1,s2
    1480:	00005517          	auipc	a0,0x5
    1484:	30050513          	addi	a0,a0,768 # 6780 <malloc+0xca0>
    1488:	00004097          	auipc	ra,0x4
    148c:	59a080e7          	jalr	1434(ra) # 5a22 <printf>
        exit(1);
    1490:	4505                	li	a0,1
    1492:	00004097          	auipc	ra,0x4
    1496:	210080e7          	jalr	528(ra) # 56a2 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    149a:	862a                	mv	a2,a0
    149c:	85ca                	mv	a1,s2
    149e:	00005517          	auipc	a0,0x5
    14a2:	30a50513          	addi	a0,a0,778 # 67a8 <malloc+0xcc8>
    14a6:	00004097          	auipc	ra,0x4
    14aa:	57c080e7          	jalr	1404(ra) # 5a22 <printf>
        exit(1);
    14ae:	4505                	li	a0,1
    14b0:	00004097          	auipc	ra,0x4
    14b4:	1f2080e7          	jalr	498(ra) # 56a2 <exit>
    14b8:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14bc:	00005a17          	auipc	s4,0x5
    14c0:	acca0a13          	addi	s4,s4,-1332 # 5f88 <malloc+0x4a8>
    int n = write(fd, "xxx", 3);
    14c4:	00005a97          	auipc	s5,0x5
    14c8:	304a8a93          	addi	s5,s5,772 # 67c8 <malloc+0xce8>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14cc:	60100593          	li	a1,1537
    14d0:	8552                	mv	a0,s4
    14d2:	00004097          	auipc	ra,0x4
    14d6:	210080e7          	jalr	528(ra) # 56e2 <open>
    14da:	84aa                	mv	s1,a0
    if(fd < 0){
    14dc:	04054763          	bltz	a0,152a <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14e0:	460d                	li	a2,3
    14e2:	85d6                	mv	a1,s5
    14e4:	00004097          	auipc	ra,0x4
    14e8:	1de080e7          	jalr	478(ra) # 56c2 <write>
    if(n != 3){
    14ec:	478d                	li	a5,3
    14ee:	04f51c63          	bne	a0,a5,1546 <truncate3+0x19c>
    close(fd);
    14f2:	8526                	mv	a0,s1
    14f4:	00004097          	auipc	ra,0x4
    14f8:	1d6080e7          	jalr	470(ra) # 56ca <close>
  for(int i = 0; i < 150; i++){
    14fc:	39fd                	addiw	s3,s3,-1
    14fe:	fc0997e3          	bnez	s3,14cc <truncate3+0x122>
  wait(&xstatus);
    1502:	fbc40513          	addi	a0,s0,-68
    1506:	00004097          	auipc	ra,0x4
    150a:	1a4080e7          	jalr	420(ra) # 56aa <wait>
  unlink("truncfile");
    150e:	00005517          	auipc	a0,0x5
    1512:	a7a50513          	addi	a0,a0,-1414 # 5f88 <malloc+0x4a8>
    1516:	00004097          	auipc	ra,0x4
    151a:	1dc080e7          	jalr	476(ra) # 56f2 <unlink>
  exit(xstatus);
    151e:	fbc42503          	lw	a0,-68(s0)
    1522:	00004097          	auipc	ra,0x4
    1526:	180080e7          	jalr	384(ra) # 56a2 <exit>
      printf("%s: open failed\n", s);
    152a:	85ca                	mv	a1,s2
    152c:	00005517          	auipc	a0,0x5
    1530:	25450513          	addi	a0,a0,596 # 6780 <malloc+0xca0>
    1534:	00004097          	auipc	ra,0x4
    1538:	4ee080e7          	jalr	1262(ra) # 5a22 <printf>
      exit(1);
    153c:	4505                	li	a0,1
    153e:	00004097          	auipc	ra,0x4
    1542:	164080e7          	jalr	356(ra) # 56a2 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1546:	862a                	mv	a2,a0
    1548:	85ca                	mv	a1,s2
    154a:	00005517          	auipc	a0,0x5
    154e:	28650513          	addi	a0,a0,646 # 67d0 <malloc+0xcf0>
    1552:	00004097          	auipc	ra,0x4
    1556:	4d0080e7          	jalr	1232(ra) # 5a22 <printf>
      exit(1);
    155a:	4505                	li	a0,1
    155c:	00004097          	auipc	ra,0x4
    1560:	146080e7          	jalr	326(ra) # 56a2 <exit>

0000000000001564 <exectest>:
{
    1564:	715d                	addi	sp,sp,-80
    1566:	e486                	sd	ra,72(sp)
    1568:	e0a2                	sd	s0,64(sp)
    156a:	fc26                	sd	s1,56(sp)
    156c:	f84a                	sd	s2,48(sp)
    156e:	0880                	addi	s0,sp,80
    1570:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1572:	00005797          	auipc	a5,0x5
    1576:	9be78793          	addi	a5,a5,-1602 # 5f30 <malloc+0x450>
    157a:	fcf43023          	sd	a5,-64(s0)
    157e:	00005797          	auipc	a5,0x5
    1582:	27278793          	addi	a5,a5,626 # 67f0 <malloc+0xd10>
    1586:	fcf43423          	sd	a5,-56(s0)
    158a:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158e:	00005517          	auipc	a0,0x5
    1592:	26a50513          	addi	a0,a0,618 # 67f8 <malloc+0xd18>
    1596:	00004097          	auipc	ra,0x4
    159a:	15c080e7          	jalr	348(ra) # 56f2 <unlink>
  pid = fork();
    159e:	00004097          	auipc	ra,0x4
    15a2:	0fc080e7          	jalr	252(ra) # 569a <fork>
  if(pid < 0) {
    15a6:	04054663          	bltz	a0,15f2 <exectest+0x8e>
    15aa:	84aa                	mv	s1,a0
  if(pid == 0) {
    15ac:	e959                	bnez	a0,1642 <exectest+0xde>
    close(1);
    15ae:	4505                	li	a0,1
    15b0:	00004097          	auipc	ra,0x4
    15b4:	11a080e7          	jalr	282(ra) # 56ca <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b8:	20100593          	li	a1,513
    15bc:	00005517          	auipc	a0,0x5
    15c0:	23c50513          	addi	a0,a0,572 # 67f8 <malloc+0xd18>
    15c4:	00004097          	auipc	ra,0x4
    15c8:	11e080e7          	jalr	286(ra) # 56e2 <open>
    if(fd < 0) {
    15cc:	04054163          	bltz	a0,160e <exectest+0xaa>
    if(fd != 1) {
    15d0:	4785                	li	a5,1
    15d2:	04f50c63          	beq	a0,a5,162a <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d6:	85ca                	mv	a1,s2
    15d8:	00005517          	auipc	a0,0x5
    15dc:	24050513          	addi	a0,a0,576 # 6818 <malloc+0xd38>
    15e0:	00004097          	auipc	ra,0x4
    15e4:	442080e7          	jalr	1090(ra) # 5a22 <printf>
      exit(1);
    15e8:	4505                	li	a0,1
    15ea:	00004097          	auipc	ra,0x4
    15ee:	0b8080e7          	jalr	184(ra) # 56a2 <exit>
     printf("%s: fork failed\n", s);
    15f2:	85ca                	mv	a1,s2
    15f4:	00005517          	auipc	a0,0x5
    15f8:	17450513          	addi	a0,a0,372 # 6768 <malloc+0xc88>
    15fc:	00004097          	auipc	ra,0x4
    1600:	426080e7          	jalr	1062(ra) # 5a22 <printf>
     exit(1);
    1604:	4505                	li	a0,1
    1606:	00004097          	auipc	ra,0x4
    160a:	09c080e7          	jalr	156(ra) # 56a2 <exit>
      printf("%s: create failed\n", s);
    160e:	85ca                	mv	a1,s2
    1610:	00005517          	auipc	a0,0x5
    1614:	1f050513          	addi	a0,a0,496 # 6800 <malloc+0xd20>
    1618:	00004097          	auipc	ra,0x4
    161c:	40a080e7          	jalr	1034(ra) # 5a22 <printf>
      exit(1);
    1620:	4505                	li	a0,1
    1622:	00004097          	auipc	ra,0x4
    1626:	080080e7          	jalr	128(ra) # 56a2 <exit>
    if(exec("echo", echoargv) < 0){
    162a:	fc040593          	addi	a1,s0,-64
    162e:	00005517          	auipc	a0,0x5
    1632:	90250513          	addi	a0,a0,-1790 # 5f30 <malloc+0x450>
    1636:	00004097          	auipc	ra,0x4
    163a:	0a4080e7          	jalr	164(ra) # 56da <exec>
    163e:	02054163          	bltz	a0,1660 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1642:	fdc40513          	addi	a0,s0,-36
    1646:	00004097          	auipc	ra,0x4
    164a:	064080e7          	jalr	100(ra) # 56aa <wait>
    164e:	02951763          	bne	a0,s1,167c <exectest+0x118>
  if(xstatus != 0)
    1652:	fdc42503          	lw	a0,-36(s0)
    1656:	cd0d                	beqz	a0,1690 <exectest+0x12c>
    exit(xstatus);
    1658:	00004097          	auipc	ra,0x4
    165c:	04a080e7          	jalr	74(ra) # 56a2 <exit>
      printf("%s: exec echo failed\n", s);
    1660:	85ca                	mv	a1,s2
    1662:	00005517          	auipc	a0,0x5
    1666:	1c650513          	addi	a0,a0,454 # 6828 <malloc+0xd48>
    166a:	00004097          	auipc	ra,0x4
    166e:	3b8080e7          	jalr	952(ra) # 5a22 <printf>
      exit(1);
    1672:	4505                	li	a0,1
    1674:	00004097          	auipc	ra,0x4
    1678:	02e080e7          	jalr	46(ra) # 56a2 <exit>
    printf("%s: wait failed!\n", s);
    167c:	85ca                	mv	a1,s2
    167e:	00005517          	auipc	a0,0x5
    1682:	1c250513          	addi	a0,a0,450 # 6840 <malloc+0xd60>
    1686:	00004097          	auipc	ra,0x4
    168a:	39c080e7          	jalr	924(ra) # 5a22 <printf>
    168e:	b7d1                	j	1652 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1690:	4581                	li	a1,0
    1692:	00005517          	auipc	a0,0x5
    1696:	16650513          	addi	a0,a0,358 # 67f8 <malloc+0xd18>
    169a:	00004097          	auipc	ra,0x4
    169e:	048080e7          	jalr	72(ra) # 56e2 <open>
  if(fd < 0) {
    16a2:	02054a63          	bltz	a0,16d6 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a6:	4609                	li	a2,2
    16a8:	fb840593          	addi	a1,s0,-72
    16ac:	00004097          	auipc	ra,0x4
    16b0:	00e080e7          	jalr	14(ra) # 56ba <read>
    16b4:	4789                	li	a5,2
    16b6:	02f50e63          	beq	a0,a5,16f2 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16ba:	85ca                	mv	a1,s2
    16bc:	00005517          	auipc	a0,0x5
    16c0:	c0450513          	addi	a0,a0,-1020 # 62c0 <malloc+0x7e0>
    16c4:	00004097          	auipc	ra,0x4
    16c8:	35e080e7          	jalr	862(ra) # 5a22 <printf>
    exit(1);
    16cc:	4505                	li	a0,1
    16ce:	00004097          	auipc	ra,0x4
    16d2:	fd4080e7          	jalr	-44(ra) # 56a2 <exit>
    printf("%s: open failed\n", s);
    16d6:	85ca                	mv	a1,s2
    16d8:	00005517          	auipc	a0,0x5
    16dc:	0a850513          	addi	a0,a0,168 # 6780 <malloc+0xca0>
    16e0:	00004097          	auipc	ra,0x4
    16e4:	342080e7          	jalr	834(ra) # 5a22 <printf>
    exit(1);
    16e8:	4505                	li	a0,1
    16ea:	00004097          	auipc	ra,0x4
    16ee:	fb8080e7          	jalr	-72(ra) # 56a2 <exit>
  unlink("echo-ok");
    16f2:	00005517          	auipc	a0,0x5
    16f6:	10650513          	addi	a0,a0,262 # 67f8 <malloc+0xd18>
    16fa:	00004097          	auipc	ra,0x4
    16fe:	ff8080e7          	jalr	-8(ra) # 56f2 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1702:	fb844703          	lbu	a4,-72(s0)
    1706:	04f00793          	li	a5,79
    170a:	00f71863          	bne	a4,a5,171a <exectest+0x1b6>
    170e:	fb944703          	lbu	a4,-71(s0)
    1712:	04b00793          	li	a5,75
    1716:	02f70063          	beq	a4,a5,1736 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    171a:	85ca                	mv	a1,s2
    171c:	00005517          	auipc	a0,0x5
    1720:	13c50513          	addi	a0,a0,316 # 6858 <malloc+0xd78>
    1724:	00004097          	auipc	ra,0x4
    1728:	2fe080e7          	jalr	766(ra) # 5a22 <printf>
    exit(1);
    172c:	4505                	li	a0,1
    172e:	00004097          	auipc	ra,0x4
    1732:	f74080e7          	jalr	-140(ra) # 56a2 <exit>
    exit(0);
    1736:	4501                	li	a0,0
    1738:	00004097          	auipc	ra,0x4
    173c:	f6a080e7          	jalr	-150(ra) # 56a2 <exit>

0000000000001740 <pipe1>:
{
    1740:	711d                	addi	sp,sp,-96
    1742:	ec86                	sd	ra,88(sp)
    1744:	e8a2                	sd	s0,80(sp)
    1746:	e4a6                	sd	s1,72(sp)
    1748:	e0ca                	sd	s2,64(sp)
    174a:	fc4e                	sd	s3,56(sp)
    174c:	f852                	sd	s4,48(sp)
    174e:	f456                	sd	s5,40(sp)
    1750:	f05a                	sd	s6,32(sp)
    1752:	ec5e                	sd	s7,24(sp)
    1754:	1080                	addi	s0,sp,96
    1756:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1758:	fa840513          	addi	a0,s0,-88
    175c:	00004097          	auipc	ra,0x4
    1760:	f56080e7          	jalr	-170(ra) # 56b2 <pipe>
    1764:	ed25                	bnez	a0,17dc <pipe1+0x9c>
    1766:	84aa                	mv	s1,a0
  pid = fork();
    1768:	00004097          	auipc	ra,0x4
    176c:	f32080e7          	jalr	-206(ra) # 569a <fork>
    1770:	8a2a                	mv	s4,a0
  if(pid == 0){
    1772:	c159                	beqz	a0,17f8 <pipe1+0xb8>
  } else if(pid > 0){
    1774:	16a05e63          	blez	a0,18f0 <pipe1+0x1b0>
    close(fds[1]);
    1778:	fac42503          	lw	a0,-84(s0)
    177c:	00004097          	auipc	ra,0x4
    1780:	f4e080e7          	jalr	-178(ra) # 56ca <close>
    total = 0;
    1784:	8a26                	mv	s4,s1
    cc = 1;
    1786:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1788:	0000aa97          	auipc	s5,0xa
    178c:	3f0a8a93          	addi	s5,s5,1008 # bb78 <buf>
      if(cc > sizeof(buf))
    1790:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1792:	864e                	mv	a2,s3
    1794:	85d6                	mv	a1,s5
    1796:	fa842503          	lw	a0,-88(s0)
    179a:	00004097          	auipc	ra,0x4
    179e:	f20080e7          	jalr	-224(ra) # 56ba <read>
    17a2:	10a05263          	blez	a0,18a6 <pipe1+0x166>
      for(i = 0; i < n; i++){
    17a6:	0000a717          	auipc	a4,0xa
    17aa:	3d270713          	addi	a4,a4,978 # bb78 <buf>
    17ae:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b2:	00074683          	lbu	a3,0(a4)
    17b6:	0ff4f793          	andi	a5,s1,255
    17ba:	2485                	addiw	s1,s1,1
    17bc:	0cf69163          	bne	a3,a5,187e <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17c0:	0705                	addi	a4,a4,1
    17c2:	fec498e3          	bne	s1,a2,17b2 <pipe1+0x72>
      total += n;
    17c6:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17ca:	0019979b          	slliw	a5,s3,0x1
    17ce:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d2:	013b7363          	bgeu	s6,s3,17d8 <pipe1+0x98>
        cc = sizeof(buf);
    17d6:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17d8:	84b2                	mv	s1,a2
    17da:	bf65                	j	1792 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17dc:	85ca                	mv	a1,s2
    17de:	00005517          	auipc	a0,0x5
    17e2:	09250513          	addi	a0,a0,146 # 6870 <malloc+0xd90>
    17e6:	00004097          	auipc	ra,0x4
    17ea:	23c080e7          	jalr	572(ra) # 5a22 <printf>
    exit(1);
    17ee:	4505                	li	a0,1
    17f0:	00004097          	auipc	ra,0x4
    17f4:	eb2080e7          	jalr	-334(ra) # 56a2 <exit>
    close(fds[0]);
    17f8:	fa842503          	lw	a0,-88(s0)
    17fc:	00004097          	auipc	ra,0x4
    1800:	ece080e7          	jalr	-306(ra) # 56ca <close>
    for(n = 0; n < N; n++){
    1804:	0000ab17          	auipc	s6,0xa
    1808:	374b0b13          	addi	s6,s6,884 # bb78 <buf>
    180c:	416004bb          	negw	s1,s6
    1810:	0ff4f493          	andi	s1,s1,255
    1814:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1818:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    181a:	6a85                	lui	s5,0x1
    181c:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x83>
{
    1820:	87da                	mv	a5,s6
        buf[i] = seq++;
    1822:	0097873b          	addw	a4,a5,s1
    1826:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    182a:	0785                	addi	a5,a5,1
    182c:	fef99be3          	bne	s3,a5,1822 <pipe1+0xe2>
        buf[i] = seq++;
    1830:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1834:	40900613          	li	a2,1033
    1838:	85de                	mv	a1,s7
    183a:	fac42503          	lw	a0,-84(s0)
    183e:	00004097          	auipc	ra,0x4
    1842:	e84080e7          	jalr	-380(ra) # 56c2 <write>
    1846:	40900793          	li	a5,1033
    184a:	00f51c63          	bne	a0,a5,1862 <pipe1+0x122>
    for(n = 0; n < N; n++){
    184e:	24a5                	addiw	s1,s1,9
    1850:	0ff4f493          	andi	s1,s1,255
    1854:	fd5a16e3          	bne	s4,s5,1820 <pipe1+0xe0>
    exit(0);
    1858:	4501                	li	a0,0
    185a:	00004097          	auipc	ra,0x4
    185e:	e48080e7          	jalr	-440(ra) # 56a2 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1862:	85ca                	mv	a1,s2
    1864:	00005517          	auipc	a0,0x5
    1868:	02450513          	addi	a0,a0,36 # 6888 <malloc+0xda8>
    186c:	00004097          	auipc	ra,0x4
    1870:	1b6080e7          	jalr	438(ra) # 5a22 <printf>
        exit(1);
    1874:	4505                	li	a0,1
    1876:	00004097          	auipc	ra,0x4
    187a:	e2c080e7          	jalr	-468(ra) # 56a2 <exit>
          printf("%s: pipe1 oops 2\n", s);
    187e:	85ca                	mv	a1,s2
    1880:	00005517          	auipc	a0,0x5
    1884:	02050513          	addi	a0,a0,32 # 68a0 <malloc+0xdc0>
    1888:	00004097          	auipc	ra,0x4
    188c:	19a080e7          	jalr	410(ra) # 5a22 <printf>
}
    1890:	60e6                	ld	ra,88(sp)
    1892:	6446                	ld	s0,80(sp)
    1894:	64a6                	ld	s1,72(sp)
    1896:	6906                	ld	s2,64(sp)
    1898:	79e2                	ld	s3,56(sp)
    189a:	7a42                	ld	s4,48(sp)
    189c:	7aa2                	ld	s5,40(sp)
    189e:	7b02                	ld	s6,32(sp)
    18a0:	6be2                	ld	s7,24(sp)
    18a2:	6125                	addi	sp,sp,96
    18a4:	8082                	ret
    if(total != N * SZ){
    18a6:	6785                	lui	a5,0x1
    18a8:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x83>
    18ac:	02fa0063          	beq	s4,a5,18cc <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18b0:	85d2                	mv	a1,s4
    18b2:	00005517          	auipc	a0,0x5
    18b6:	00650513          	addi	a0,a0,6 # 68b8 <malloc+0xdd8>
    18ba:	00004097          	auipc	ra,0x4
    18be:	168080e7          	jalr	360(ra) # 5a22 <printf>
      exit(1);
    18c2:	4505                	li	a0,1
    18c4:	00004097          	auipc	ra,0x4
    18c8:	dde080e7          	jalr	-546(ra) # 56a2 <exit>
    close(fds[0]);
    18cc:	fa842503          	lw	a0,-88(s0)
    18d0:	00004097          	auipc	ra,0x4
    18d4:	dfa080e7          	jalr	-518(ra) # 56ca <close>
    wait(&xstatus);
    18d8:	fa440513          	addi	a0,s0,-92
    18dc:	00004097          	auipc	ra,0x4
    18e0:	dce080e7          	jalr	-562(ra) # 56aa <wait>
    exit(xstatus);
    18e4:	fa442503          	lw	a0,-92(s0)
    18e8:	00004097          	auipc	ra,0x4
    18ec:	dba080e7          	jalr	-582(ra) # 56a2 <exit>
    printf("%s: fork() failed\n", s);
    18f0:	85ca                	mv	a1,s2
    18f2:	00005517          	auipc	a0,0x5
    18f6:	fe650513          	addi	a0,a0,-26 # 68d8 <malloc+0xdf8>
    18fa:	00004097          	auipc	ra,0x4
    18fe:	128080e7          	jalr	296(ra) # 5a22 <printf>
    exit(1);
    1902:	4505                	li	a0,1
    1904:	00004097          	auipc	ra,0x4
    1908:	d9e080e7          	jalr	-610(ra) # 56a2 <exit>

000000000000190c <exitwait>:
{
    190c:	7139                	addi	sp,sp,-64
    190e:	fc06                	sd	ra,56(sp)
    1910:	f822                	sd	s0,48(sp)
    1912:	f426                	sd	s1,40(sp)
    1914:	f04a                	sd	s2,32(sp)
    1916:	ec4e                	sd	s3,24(sp)
    1918:	e852                	sd	s4,16(sp)
    191a:	0080                	addi	s0,sp,64
    191c:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    191e:	4901                	li	s2,0
    1920:	06400993          	li	s3,100
    pid = fork();
    1924:	00004097          	auipc	ra,0x4
    1928:	d76080e7          	jalr	-650(ra) # 569a <fork>
    192c:	84aa                	mv	s1,a0
    if(pid < 0){
    192e:	02054a63          	bltz	a0,1962 <exitwait+0x56>
    if(pid){
    1932:	c151                	beqz	a0,19b6 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1934:	fcc40513          	addi	a0,s0,-52
    1938:	00004097          	auipc	ra,0x4
    193c:	d72080e7          	jalr	-654(ra) # 56aa <wait>
    1940:	02951f63          	bne	a0,s1,197e <exitwait+0x72>
      if(i != xstate) {
    1944:	fcc42783          	lw	a5,-52(s0)
    1948:	05279963          	bne	a5,s2,199a <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    194c:	2905                	addiw	s2,s2,1
    194e:	fd391be3          	bne	s2,s3,1924 <exitwait+0x18>
}
    1952:	70e2                	ld	ra,56(sp)
    1954:	7442                	ld	s0,48(sp)
    1956:	74a2                	ld	s1,40(sp)
    1958:	7902                	ld	s2,32(sp)
    195a:	69e2                	ld	s3,24(sp)
    195c:	6a42                	ld	s4,16(sp)
    195e:	6121                	addi	sp,sp,64
    1960:	8082                	ret
      printf("%s: fork failed\n", s);
    1962:	85d2                	mv	a1,s4
    1964:	00005517          	auipc	a0,0x5
    1968:	e0450513          	addi	a0,a0,-508 # 6768 <malloc+0xc88>
    196c:	00004097          	auipc	ra,0x4
    1970:	0b6080e7          	jalr	182(ra) # 5a22 <printf>
      exit(1);
    1974:	4505                	li	a0,1
    1976:	00004097          	auipc	ra,0x4
    197a:	d2c080e7          	jalr	-724(ra) # 56a2 <exit>
        printf("%s: wait wrong pid\n", s);
    197e:	85d2                	mv	a1,s4
    1980:	00005517          	auipc	a0,0x5
    1984:	f7050513          	addi	a0,a0,-144 # 68f0 <malloc+0xe10>
    1988:	00004097          	auipc	ra,0x4
    198c:	09a080e7          	jalr	154(ra) # 5a22 <printf>
        exit(1);
    1990:	4505                	li	a0,1
    1992:	00004097          	auipc	ra,0x4
    1996:	d10080e7          	jalr	-752(ra) # 56a2 <exit>
        printf("%s: wait wrong exit status\n", s);
    199a:	85d2                	mv	a1,s4
    199c:	00005517          	auipc	a0,0x5
    19a0:	f6c50513          	addi	a0,a0,-148 # 6908 <malloc+0xe28>
    19a4:	00004097          	auipc	ra,0x4
    19a8:	07e080e7          	jalr	126(ra) # 5a22 <printf>
        exit(1);
    19ac:	4505                	li	a0,1
    19ae:	00004097          	auipc	ra,0x4
    19b2:	cf4080e7          	jalr	-780(ra) # 56a2 <exit>
      exit(i);
    19b6:	854a                	mv	a0,s2
    19b8:	00004097          	auipc	ra,0x4
    19bc:	cea080e7          	jalr	-790(ra) # 56a2 <exit>

00000000000019c0 <twochildren>:
{
    19c0:	1101                	addi	sp,sp,-32
    19c2:	ec06                	sd	ra,24(sp)
    19c4:	e822                	sd	s0,16(sp)
    19c6:	e426                	sd	s1,8(sp)
    19c8:	e04a                	sd	s2,0(sp)
    19ca:	1000                	addi	s0,sp,32
    19cc:	892a                	mv	s2,a0
    19ce:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d2:	00004097          	auipc	ra,0x4
    19d6:	cc8080e7          	jalr	-824(ra) # 569a <fork>
    if(pid1 < 0){
    19da:	02054c63          	bltz	a0,1a12 <twochildren+0x52>
    if(pid1 == 0){
    19de:	c921                	beqz	a0,1a2e <twochildren+0x6e>
      int pid2 = fork();
    19e0:	00004097          	auipc	ra,0x4
    19e4:	cba080e7          	jalr	-838(ra) # 569a <fork>
      if(pid2 < 0){
    19e8:	04054763          	bltz	a0,1a36 <twochildren+0x76>
      if(pid2 == 0){
    19ec:	c13d                	beqz	a0,1a52 <twochildren+0x92>
        wait(0);
    19ee:	4501                	li	a0,0
    19f0:	00004097          	auipc	ra,0x4
    19f4:	cba080e7          	jalr	-838(ra) # 56aa <wait>
        wait(0);
    19f8:	4501                	li	a0,0
    19fa:	00004097          	auipc	ra,0x4
    19fe:	cb0080e7          	jalr	-848(ra) # 56aa <wait>
  for(int i = 0; i < 1000; i++){
    1a02:	34fd                	addiw	s1,s1,-1
    1a04:	f4f9                	bnez	s1,19d2 <twochildren+0x12>
}
    1a06:	60e2                	ld	ra,24(sp)
    1a08:	6442                	ld	s0,16(sp)
    1a0a:	64a2                	ld	s1,8(sp)
    1a0c:	6902                	ld	s2,0(sp)
    1a0e:	6105                	addi	sp,sp,32
    1a10:	8082                	ret
      printf("%s: fork failed\n", s);
    1a12:	85ca                	mv	a1,s2
    1a14:	00005517          	auipc	a0,0x5
    1a18:	d5450513          	addi	a0,a0,-684 # 6768 <malloc+0xc88>
    1a1c:	00004097          	auipc	ra,0x4
    1a20:	006080e7          	jalr	6(ra) # 5a22 <printf>
      exit(1);
    1a24:	4505                	li	a0,1
    1a26:	00004097          	auipc	ra,0x4
    1a2a:	c7c080e7          	jalr	-900(ra) # 56a2 <exit>
      exit(0);
    1a2e:	00004097          	auipc	ra,0x4
    1a32:	c74080e7          	jalr	-908(ra) # 56a2 <exit>
        printf("%s: fork failed\n", s);
    1a36:	85ca                	mv	a1,s2
    1a38:	00005517          	auipc	a0,0x5
    1a3c:	d3050513          	addi	a0,a0,-720 # 6768 <malloc+0xc88>
    1a40:	00004097          	auipc	ra,0x4
    1a44:	fe2080e7          	jalr	-30(ra) # 5a22 <printf>
        exit(1);
    1a48:	4505                	li	a0,1
    1a4a:	00004097          	auipc	ra,0x4
    1a4e:	c58080e7          	jalr	-936(ra) # 56a2 <exit>
        exit(0);
    1a52:	00004097          	auipc	ra,0x4
    1a56:	c50080e7          	jalr	-944(ra) # 56a2 <exit>

0000000000001a5a <forkfork>:
{
    1a5a:	7179                	addi	sp,sp,-48
    1a5c:	f406                	sd	ra,40(sp)
    1a5e:	f022                	sd	s0,32(sp)
    1a60:	ec26                	sd	s1,24(sp)
    1a62:	1800                	addi	s0,sp,48
    1a64:	84aa                	mv	s1,a0
    int pid = fork();
    1a66:	00004097          	auipc	ra,0x4
    1a6a:	c34080e7          	jalr	-972(ra) # 569a <fork>
    if(pid < 0){
    1a6e:	04054163          	bltz	a0,1ab0 <forkfork+0x56>
    if(pid == 0){
    1a72:	cd29                	beqz	a0,1acc <forkfork+0x72>
    int pid = fork();
    1a74:	00004097          	auipc	ra,0x4
    1a78:	c26080e7          	jalr	-986(ra) # 569a <fork>
    if(pid < 0){
    1a7c:	02054a63          	bltz	a0,1ab0 <forkfork+0x56>
    if(pid == 0){
    1a80:	c531                	beqz	a0,1acc <forkfork+0x72>
    wait(&xstatus);
    1a82:	fdc40513          	addi	a0,s0,-36
    1a86:	00004097          	auipc	ra,0x4
    1a8a:	c24080e7          	jalr	-988(ra) # 56aa <wait>
    if(xstatus != 0) {
    1a8e:	fdc42783          	lw	a5,-36(s0)
    1a92:	ebbd                	bnez	a5,1b08 <forkfork+0xae>
    wait(&xstatus);
    1a94:	fdc40513          	addi	a0,s0,-36
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	c12080e7          	jalr	-1006(ra) # 56aa <wait>
    if(xstatus != 0) {
    1aa0:	fdc42783          	lw	a5,-36(s0)
    1aa4:	e3b5                	bnez	a5,1b08 <forkfork+0xae>
}
    1aa6:	70a2                	ld	ra,40(sp)
    1aa8:	7402                	ld	s0,32(sp)
    1aaa:	64e2                	ld	s1,24(sp)
    1aac:	6145                	addi	sp,sp,48
    1aae:	8082                	ret
      printf("%s: fork failed", s);
    1ab0:	85a6                	mv	a1,s1
    1ab2:	00005517          	auipc	a0,0x5
    1ab6:	e7650513          	addi	a0,a0,-394 # 6928 <malloc+0xe48>
    1aba:	00004097          	auipc	ra,0x4
    1abe:	f68080e7          	jalr	-152(ra) # 5a22 <printf>
      exit(1);
    1ac2:	4505                	li	a0,1
    1ac4:	00004097          	auipc	ra,0x4
    1ac8:	bde080e7          	jalr	-1058(ra) # 56a2 <exit>
{
    1acc:	0c800493          	li	s1,200
        int pid1 = fork();
    1ad0:	00004097          	auipc	ra,0x4
    1ad4:	bca080e7          	jalr	-1078(ra) # 569a <fork>
        if(pid1 < 0){
    1ad8:	00054f63          	bltz	a0,1af6 <forkfork+0x9c>
        if(pid1 == 0){
    1adc:	c115                	beqz	a0,1b00 <forkfork+0xa6>
        wait(0);
    1ade:	4501                	li	a0,0
    1ae0:	00004097          	auipc	ra,0x4
    1ae4:	bca080e7          	jalr	-1078(ra) # 56aa <wait>
      for(int j = 0; j < 200; j++){
    1ae8:	34fd                	addiw	s1,s1,-1
    1aea:	f0fd                	bnez	s1,1ad0 <forkfork+0x76>
      exit(0);
    1aec:	4501                	li	a0,0
    1aee:	00004097          	auipc	ra,0x4
    1af2:	bb4080e7          	jalr	-1100(ra) # 56a2 <exit>
          exit(1);
    1af6:	4505                	li	a0,1
    1af8:	00004097          	auipc	ra,0x4
    1afc:	baa080e7          	jalr	-1110(ra) # 56a2 <exit>
          exit(0);
    1b00:	00004097          	auipc	ra,0x4
    1b04:	ba2080e7          	jalr	-1118(ra) # 56a2 <exit>
      printf("%s: fork in child failed", s);
    1b08:	85a6                	mv	a1,s1
    1b0a:	00005517          	auipc	a0,0x5
    1b0e:	e2e50513          	addi	a0,a0,-466 # 6938 <malloc+0xe58>
    1b12:	00004097          	auipc	ra,0x4
    1b16:	f10080e7          	jalr	-240(ra) # 5a22 <printf>
      exit(1);
    1b1a:	4505                	li	a0,1
    1b1c:	00004097          	auipc	ra,0x4
    1b20:	b86080e7          	jalr	-1146(ra) # 56a2 <exit>

0000000000001b24 <reparent2>:
{
    1b24:	1101                	addi	sp,sp,-32
    1b26:	ec06                	sd	ra,24(sp)
    1b28:	e822                	sd	s0,16(sp)
    1b2a:	e426                	sd	s1,8(sp)
    1b2c:	1000                	addi	s0,sp,32
    1b2e:	32000493          	li	s1,800
    int pid1 = fork();
    1b32:	00004097          	auipc	ra,0x4
    1b36:	b68080e7          	jalr	-1176(ra) # 569a <fork>
    if(pid1 < 0){
    1b3a:	00054f63          	bltz	a0,1b58 <reparent2+0x34>
    if(pid1 == 0){
    1b3e:	c915                	beqz	a0,1b72 <reparent2+0x4e>
    wait(0);
    1b40:	4501                	li	a0,0
    1b42:	00004097          	auipc	ra,0x4
    1b46:	b68080e7          	jalr	-1176(ra) # 56aa <wait>
  for(int i = 0; i < 800; i++){
    1b4a:	34fd                	addiw	s1,s1,-1
    1b4c:	f0fd                	bnez	s1,1b32 <reparent2+0xe>
  exit(0);
    1b4e:	4501                	li	a0,0
    1b50:	00004097          	auipc	ra,0x4
    1b54:	b52080e7          	jalr	-1198(ra) # 56a2 <exit>
      printf("fork failed\n");
    1b58:	00005517          	auipc	a0,0x5
    1b5c:	01850513          	addi	a0,a0,24 # 6b70 <malloc+0x1090>
    1b60:	00004097          	auipc	ra,0x4
    1b64:	ec2080e7          	jalr	-318(ra) # 5a22 <printf>
      exit(1);
    1b68:	4505                	li	a0,1
    1b6a:	00004097          	auipc	ra,0x4
    1b6e:	b38080e7          	jalr	-1224(ra) # 56a2 <exit>
      fork();
    1b72:	00004097          	auipc	ra,0x4
    1b76:	b28080e7          	jalr	-1240(ra) # 569a <fork>
      fork();
    1b7a:	00004097          	auipc	ra,0x4
    1b7e:	b20080e7          	jalr	-1248(ra) # 569a <fork>
      exit(0);
    1b82:	4501                	li	a0,0
    1b84:	00004097          	auipc	ra,0x4
    1b88:	b1e080e7          	jalr	-1250(ra) # 56a2 <exit>

0000000000001b8c <createdelete>:
{
    1b8c:	7175                	addi	sp,sp,-144
    1b8e:	e506                	sd	ra,136(sp)
    1b90:	e122                	sd	s0,128(sp)
    1b92:	fca6                	sd	s1,120(sp)
    1b94:	f8ca                	sd	s2,112(sp)
    1b96:	f4ce                	sd	s3,104(sp)
    1b98:	f0d2                	sd	s4,96(sp)
    1b9a:	ecd6                	sd	s5,88(sp)
    1b9c:	e8da                	sd	s6,80(sp)
    1b9e:	e4de                	sd	s7,72(sp)
    1ba0:	e0e2                	sd	s8,64(sp)
    1ba2:	fc66                	sd	s9,56(sp)
    1ba4:	0900                	addi	s0,sp,144
    1ba6:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba8:	4901                	li	s2,0
    1baa:	4991                	li	s3,4
    pid = fork();
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	aee080e7          	jalr	-1298(ra) # 569a <fork>
    1bb4:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb6:	02054f63          	bltz	a0,1bf4 <createdelete+0x68>
    if(pid == 0){
    1bba:	c939                	beqz	a0,1c10 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bbc:	2905                	addiw	s2,s2,1
    1bbe:	ff3917e3          	bne	s2,s3,1bac <createdelete+0x20>
    1bc2:	4491                	li	s1,4
    wait(&xstatus);
    1bc4:	f7c40513          	addi	a0,s0,-132
    1bc8:	00004097          	auipc	ra,0x4
    1bcc:	ae2080e7          	jalr	-1310(ra) # 56aa <wait>
    if(xstatus != 0)
    1bd0:	f7c42903          	lw	s2,-132(s0)
    1bd4:	0e091263          	bnez	s2,1cb8 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd8:	34fd                	addiw	s1,s1,-1
    1bda:	f4ed                	bnez	s1,1bc4 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bdc:	f8040123          	sb	zero,-126(s0)
    1be0:	03000993          	li	s3,48
    1be4:	5a7d                	li	s4,-1
    1be6:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bea:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bec:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bee:	07400a93          	li	s5,116
    1bf2:	a29d                	j	1d58 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bf4:	85e6                	mv	a1,s9
    1bf6:	00005517          	auipc	a0,0x5
    1bfa:	f7a50513          	addi	a0,a0,-134 # 6b70 <malloc+0x1090>
    1bfe:	00004097          	auipc	ra,0x4
    1c02:	e24080e7          	jalr	-476(ra) # 5a22 <printf>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	00004097          	auipc	ra,0x4
    1c0c:	a9a080e7          	jalr	-1382(ra) # 56a2 <exit>
      name[0] = 'p' + pi;
    1c10:	0709091b          	addiw	s2,s2,112
    1c14:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c18:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c1c:	4951                	li	s2,20
    1c1e:	a015                	j	1c42 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c20:	85e6                	mv	a1,s9
    1c22:	00005517          	auipc	a0,0x5
    1c26:	bde50513          	addi	a0,a0,-1058 # 6800 <malloc+0xd20>
    1c2a:	00004097          	auipc	ra,0x4
    1c2e:	df8080e7          	jalr	-520(ra) # 5a22 <printf>
          exit(1);
    1c32:	4505                	li	a0,1
    1c34:	00004097          	auipc	ra,0x4
    1c38:	a6e080e7          	jalr	-1426(ra) # 56a2 <exit>
      for(i = 0; i < N; i++){
    1c3c:	2485                	addiw	s1,s1,1
    1c3e:	07248863          	beq	s1,s2,1cae <createdelete+0x122>
        name[1] = '0' + i;
    1c42:	0304879b          	addiw	a5,s1,48
    1c46:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c4a:	20200593          	li	a1,514
    1c4e:	f8040513          	addi	a0,s0,-128
    1c52:	00004097          	auipc	ra,0x4
    1c56:	a90080e7          	jalr	-1392(ra) # 56e2 <open>
        if(fd < 0){
    1c5a:	fc0543e3          	bltz	a0,1c20 <createdelete+0x94>
        close(fd);
    1c5e:	00004097          	auipc	ra,0x4
    1c62:	a6c080e7          	jalr	-1428(ra) # 56ca <close>
        if(i > 0 && (i % 2 ) == 0){
    1c66:	fc905be3          	blez	s1,1c3c <createdelete+0xb0>
    1c6a:	0014f793          	andi	a5,s1,1
    1c6e:	f7f9                	bnez	a5,1c3c <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c70:	01f4d79b          	srliw	a5,s1,0x1f
    1c74:	9fa5                	addw	a5,a5,s1
    1c76:	4017d79b          	sraiw	a5,a5,0x1
    1c7a:	0307879b          	addiw	a5,a5,48
    1c7e:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c82:	f8040513          	addi	a0,s0,-128
    1c86:	00004097          	auipc	ra,0x4
    1c8a:	a6c080e7          	jalr	-1428(ra) # 56f2 <unlink>
    1c8e:	fa0557e3          	bgez	a0,1c3c <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c92:	85e6                	mv	a1,s9
    1c94:	00005517          	auipc	a0,0x5
    1c98:	cc450513          	addi	a0,a0,-828 # 6958 <malloc+0xe78>
    1c9c:	00004097          	auipc	ra,0x4
    1ca0:	d86080e7          	jalr	-634(ra) # 5a22 <printf>
            exit(1);
    1ca4:	4505                	li	a0,1
    1ca6:	00004097          	auipc	ra,0x4
    1caa:	9fc080e7          	jalr	-1540(ra) # 56a2 <exit>
      exit(0);
    1cae:	4501                	li	a0,0
    1cb0:	00004097          	auipc	ra,0x4
    1cb4:	9f2080e7          	jalr	-1550(ra) # 56a2 <exit>
      exit(1);
    1cb8:	4505                	li	a0,1
    1cba:	00004097          	auipc	ra,0x4
    1cbe:	9e8080e7          	jalr	-1560(ra) # 56a2 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc2:	f8040613          	addi	a2,s0,-128
    1cc6:	85e6                	mv	a1,s9
    1cc8:	00005517          	auipc	a0,0x5
    1ccc:	ca850513          	addi	a0,a0,-856 # 6970 <malloc+0xe90>
    1cd0:	00004097          	auipc	ra,0x4
    1cd4:	d52080e7          	jalr	-686(ra) # 5a22 <printf>
        exit(1);
    1cd8:	4505                	li	a0,1
    1cda:	00004097          	auipc	ra,0x4
    1cde:	9c8080e7          	jalr	-1592(ra) # 56a2 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce2:	054b7163          	bgeu	s6,s4,1d24 <createdelete+0x198>
      if(fd >= 0)
    1ce6:	02055a63          	bgez	a0,1d1a <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1cea:	2485                	addiw	s1,s1,1
    1cec:	0ff4f493          	andi	s1,s1,255
    1cf0:	05548c63          	beq	s1,s5,1d48 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cf4:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf8:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cfc:	4581                	li	a1,0
    1cfe:	f8040513          	addi	a0,s0,-128
    1d02:	00004097          	auipc	ra,0x4
    1d06:	9e0080e7          	jalr	-1568(ra) # 56e2 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d0a:	00090463          	beqz	s2,1d12 <createdelete+0x186>
    1d0e:	fd2bdae3          	bge	s7,s2,1ce2 <createdelete+0x156>
    1d12:	fa0548e3          	bltz	a0,1cc2 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d16:	014b7963          	bgeu	s6,s4,1d28 <createdelete+0x19c>
        close(fd);
    1d1a:	00004097          	auipc	ra,0x4
    1d1e:	9b0080e7          	jalr	-1616(ra) # 56ca <close>
    1d22:	b7e1                	j	1cea <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d24:	fc0543e3          	bltz	a0,1cea <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d28:	f8040613          	addi	a2,s0,-128
    1d2c:	85e6                	mv	a1,s9
    1d2e:	00005517          	auipc	a0,0x5
    1d32:	c6a50513          	addi	a0,a0,-918 # 6998 <malloc+0xeb8>
    1d36:	00004097          	auipc	ra,0x4
    1d3a:	cec080e7          	jalr	-788(ra) # 5a22 <printf>
        exit(1);
    1d3e:	4505                	li	a0,1
    1d40:	00004097          	auipc	ra,0x4
    1d44:	962080e7          	jalr	-1694(ra) # 56a2 <exit>
  for(i = 0; i < N; i++){
    1d48:	2905                	addiw	s2,s2,1
    1d4a:	2a05                	addiw	s4,s4,1
    1d4c:	2985                	addiw	s3,s3,1
    1d4e:	0ff9f993          	andi	s3,s3,255
    1d52:	47d1                	li	a5,20
    1d54:	02f90a63          	beq	s2,a5,1d88 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d58:	84e2                	mv	s1,s8
    1d5a:	bf69                	j	1cf4 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d5c:	2905                	addiw	s2,s2,1
    1d5e:	0ff97913          	andi	s2,s2,255
    1d62:	2985                	addiw	s3,s3,1
    1d64:	0ff9f993          	andi	s3,s3,255
    1d68:	03490863          	beq	s2,s4,1d98 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d6c:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d6e:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d72:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d76:	f8040513          	addi	a0,s0,-128
    1d7a:	00004097          	auipc	ra,0x4
    1d7e:	978080e7          	jalr	-1672(ra) # 56f2 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d82:	34fd                	addiw	s1,s1,-1
    1d84:	f4ed                	bnez	s1,1d6e <createdelete+0x1e2>
    1d86:	bfd9                	j	1d5c <createdelete+0x1d0>
    1d88:	03000993          	li	s3,48
    1d8c:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d90:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d92:	08400a13          	li	s4,132
    1d96:	bfd9                	j	1d6c <createdelete+0x1e0>
}
    1d98:	60aa                	ld	ra,136(sp)
    1d9a:	640a                	ld	s0,128(sp)
    1d9c:	74e6                	ld	s1,120(sp)
    1d9e:	7946                	ld	s2,112(sp)
    1da0:	79a6                	ld	s3,104(sp)
    1da2:	7a06                	ld	s4,96(sp)
    1da4:	6ae6                	ld	s5,88(sp)
    1da6:	6b46                	ld	s6,80(sp)
    1da8:	6ba6                	ld	s7,72(sp)
    1daa:	6c06                	ld	s8,64(sp)
    1dac:	7ce2                	ld	s9,56(sp)
    1dae:	6149                	addi	sp,sp,144
    1db0:	8082                	ret

0000000000001db2 <linkunlink>:
{
    1db2:	711d                	addi	sp,sp,-96
    1db4:	ec86                	sd	ra,88(sp)
    1db6:	e8a2                	sd	s0,80(sp)
    1db8:	e4a6                	sd	s1,72(sp)
    1dba:	e0ca                	sd	s2,64(sp)
    1dbc:	fc4e                	sd	s3,56(sp)
    1dbe:	f852                	sd	s4,48(sp)
    1dc0:	f456                	sd	s5,40(sp)
    1dc2:	f05a                	sd	s6,32(sp)
    1dc4:	ec5e                	sd	s7,24(sp)
    1dc6:	e862                	sd	s8,16(sp)
    1dc8:	e466                	sd	s9,8(sp)
    1dca:	1080                	addi	s0,sp,96
    1dcc:	84aa                	mv	s1,a0
  unlink("x");
    1dce:	00004517          	auipc	a0,0x4
    1dd2:	1d250513          	addi	a0,a0,466 # 5fa0 <malloc+0x4c0>
    1dd6:	00004097          	auipc	ra,0x4
    1dda:	91c080e7          	jalr	-1764(ra) # 56f2 <unlink>
  pid = fork();
    1dde:	00004097          	auipc	ra,0x4
    1de2:	8bc080e7          	jalr	-1860(ra) # 569a <fork>
  if(pid < 0){
    1de6:	02054b63          	bltz	a0,1e1c <linkunlink+0x6a>
    1dea:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dec:	4c85                	li	s9,1
    1dee:	e119                	bnez	a0,1df4 <linkunlink+0x42>
    1df0:	06100c93          	li	s9,97
    1df4:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df8:	41c659b7          	lui	s3,0x41c65
    1dfc:	e6d9899b          	addiw	s3,s3,-403
    1e00:	690d                	lui	s2,0x3
    1e02:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e06:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e08:	4b05                	li	s6,1
      unlink("x");
    1e0a:	00004a97          	auipc	s5,0x4
    1e0e:	196a8a93          	addi	s5,s5,406 # 5fa0 <malloc+0x4c0>
      link("cat", "x");
    1e12:	00005b97          	auipc	s7,0x5
    1e16:	baeb8b93          	addi	s7,s7,-1106 # 69c0 <malloc+0xee0>
    1e1a:	a825                	j	1e52 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e1c:	85a6                	mv	a1,s1
    1e1e:	00005517          	auipc	a0,0x5
    1e22:	94a50513          	addi	a0,a0,-1718 # 6768 <malloc+0xc88>
    1e26:	00004097          	auipc	ra,0x4
    1e2a:	bfc080e7          	jalr	-1028(ra) # 5a22 <printf>
    exit(1);
    1e2e:	4505                	li	a0,1
    1e30:	00004097          	auipc	ra,0x4
    1e34:	872080e7          	jalr	-1934(ra) # 56a2 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e38:	20200593          	li	a1,514
    1e3c:	8556                	mv	a0,s5
    1e3e:	00004097          	auipc	ra,0x4
    1e42:	8a4080e7          	jalr	-1884(ra) # 56e2 <open>
    1e46:	00004097          	auipc	ra,0x4
    1e4a:	884080e7          	jalr	-1916(ra) # 56ca <close>
  for(i = 0; i < 100; i++){
    1e4e:	34fd                	addiw	s1,s1,-1
    1e50:	c88d                	beqz	s1,1e82 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e52:	033c87bb          	mulw	a5,s9,s3
    1e56:	012787bb          	addw	a5,a5,s2
    1e5a:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e5e:	0347f7bb          	remuw	a5,a5,s4
    1e62:	dbf9                	beqz	a5,1e38 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e64:	01678863          	beq	a5,s6,1e74 <linkunlink+0xc2>
      unlink("x");
    1e68:	8556                	mv	a0,s5
    1e6a:	00004097          	auipc	ra,0x4
    1e6e:	888080e7          	jalr	-1912(ra) # 56f2 <unlink>
    1e72:	bff1                	j	1e4e <linkunlink+0x9c>
      link("cat", "x");
    1e74:	85d6                	mv	a1,s5
    1e76:	855e                	mv	a0,s7
    1e78:	00004097          	auipc	ra,0x4
    1e7c:	88a080e7          	jalr	-1910(ra) # 5702 <link>
    1e80:	b7f9                	j	1e4e <linkunlink+0x9c>
  if(pid)
    1e82:	020c0463          	beqz	s8,1eaa <linkunlink+0xf8>
    wait(0);
    1e86:	4501                	li	a0,0
    1e88:	00004097          	auipc	ra,0x4
    1e8c:	822080e7          	jalr	-2014(ra) # 56aa <wait>
}
    1e90:	60e6                	ld	ra,88(sp)
    1e92:	6446                	ld	s0,80(sp)
    1e94:	64a6                	ld	s1,72(sp)
    1e96:	6906                	ld	s2,64(sp)
    1e98:	79e2                	ld	s3,56(sp)
    1e9a:	7a42                	ld	s4,48(sp)
    1e9c:	7aa2                	ld	s5,40(sp)
    1e9e:	7b02                	ld	s6,32(sp)
    1ea0:	6be2                	ld	s7,24(sp)
    1ea2:	6c42                	ld	s8,16(sp)
    1ea4:	6ca2                	ld	s9,8(sp)
    1ea6:	6125                	addi	sp,sp,96
    1ea8:	8082                	ret
    exit(0);
    1eaa:	4501                	li	a0,0
    1eac:	00003097          	auipc	ra,0x3
    1eb0:	7f6080e7          	jalr	2038(ra) # 56a2 <exit>

0000000000001eb4 <manywrites>:
{
    1eb4:	711d                	addi	sp,sp,-96
    1eb6:	ec86                	sd	ra,88(sp)
    1eb8:	e8a2                	sd	s0,80(sp)
    1eba:	e4a6                	sd	s1,72(sp)
    1ebc:	e0ca                	sd	s2,64(sp)
    1ebe:	fc4e                	sd	s3,56(sp)
    1ec0:	f852                	sd	s4,48(sp)
    1ec2:	f456                	sd	s5,40(sp)
    1ec4:	f05a                	sd	s6,32(sp)
    1ec6:	ec5e                	sd	s7,24(sp)
    1ec8:	1080                	addi	s0,sp,96
    1eca:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ecc:	4981                	li	s3,0
    1ece:	4911                	li	s2,4
    int pid = fork();
    1ed0:	00003097          	auipc	ra,0x3
    1ed4:	7ca080e7          	jalr	1994(ra) # 569a <fork>
    1ed8:	84aa                	mv	s1,a0
    if(pid < 0){
    1eda:	02054963          	bltz	a0,1f0c <manywrites+0x58>
    if(pid == 0){
    1ede:	c521                	beqz	a0,1f26 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1ee0:	2985                	addiw	s3,s3,1
    1ee2:	ff2997e3          	bne	s3,s2,1ed0 <manywrites+0x1c>
    1ee6:	4491                	li	s1,4
    int st = 0;
    1ee8:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1eec:	fa840513          	addi	a0,s0,-88
    1ef0:	00003097          	auipc	ra,0x3
    1ef4:	7ba080e7          	jalr	1978(ra) # 56aa <wait>
    if(st != 0)
    1ef8:	fa842503          	lw	a0,-88(s0)
    1efc:	ed6d                	bnez	a0,1ff6 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1efe:	34fd                	addiw	s1,s1,-1
    1f00:	f4e5                	bnez	s1,1ee8 <manywrites+0x34>
  exit(0);
    1f02:	4501                	li	a0,0
    1f04:	00003097          	auipc	ra,0x3
    1f08:	79e080e7          	jalr	1950(ra) # 56a2 <exit>
      printf("fork failed\n");
    1f0c:	00005517          	auipc	a0,0x5
    1f10:	c6450513          	addi	a0,a0,-924 # 6b70 <malloc+0x1090>
    1f14:	00004097          	auipc	ra,0x4
    1f18:	b0e080e7          	jalr	-1266(ra) # 5a22 <printf>
      exit(1);
    1f1c:	4505                	li	a0,1
    1f1e:	00003097          	auipc	ra,0x3
    1f22:	784080e7          	jalr	1924(ra) # 56a2 <exit>
      name[0] = 'b';
    1f26:	06200793          	li	a5,98
    1f2a:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f2e:	0619879b          	addiw	a5,s3,97
    1f32:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f36:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f3a:	fa840513          	addi	a0,s0,-88
    1f3e:	00003097          	auipc	ra,0x3
    1f42:	7b4080e7          	jalr	1972(ra) # 56f2 <unlink>
    1f46:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f48:	0000ab17          	auipc	s6,0xa
    1f4c:	c30b0b13          	addi	s6,s6,-976 # bb78 <buf>
        for(int i = 0; i < ci+1; i++){
    1f50:	8a26                	mv	s4,s1
    1f52:	0209ce63          	bltz	s3,1f8e <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f56:	20200593          	li	a1,514
    1f5a:	fa840513          	addi	a0,s0,-88
    1f5e:	00003097          	auipc	ra,0x3
    1f62:	784080e7          	jalr	1924(ra) # 56e2 <open>
    1f66:	892a                	mv	s2,a0
          if(fd < 0){
    1f68:	04054763          	bltz	a0,1fb6 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f6c:	660d                	lui	a2,0x3
    1f6e:	85da                	mv	a1,s6
    1f70:	00003097          	auipc	ra,0x3
    1f74:	752080e7          	jalr	1874(ra) # 56c2 <write>
          if(cc != sz){
    1f78:	678d                	lui	a5,0x3
    1f7a:	04f51e63          	bne	a0,a5,1fd6 <manywrites+0x122>
          close(fd);
    1f7e:	854a                	mv	a0,s2
    1f80:	00003097          	auipc	ra,0x3
    1f84:	74a080e7          	jalr	1866(ra) # 56ca <close>
        for(int i = 0; i < ci+1; i++){
    1f88:	2a05                	addiw	s4,s4,1
    1f8a:	fd49d6e3          	bge	s3,s4,1f56 <manywrites+0xa2>
        unlink(name);
    1f8e:	fa840513          	addi	a0,s0,-88
    1f92:	00003097          	auipc	ra,0x3
    1f96:	760080e7          	jalr	1888(ra) # 56f2 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f9a:	3bfd                	addiw	s7,s7,-1
    1f9c:	fa0b9ae3          	bnez	s7,1f50 <manywrites+0x9c>
      unlink(name);
    1fa0:	fa840513          	addi	a0,s0,-88
    1fa4:	00003097          	auipc	ra,0x3
    1fa8:	74e080e7          	jalr	1870(ra) # 56f2 <unlink>
      exit(0);
    1fac:	4501                	li	a0,0
    1fae:	00003097          	auipc	ra,0x3
    1fb2:	6f4080e7          	jalr	1780(ra) # 56a2 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb6:	fa840613          	addi	a2,s0,-88
    1fba:	85d6                	mv	a1,s5
    1fbc:	00005517          	auipc	a0,0x5
    1fc0:	a0c50513          	addi	a0,a0,-1524 # 69c8 <malloc+0xee8>
    1fc4:	00004097          	auipc	ra,0x4
    1fc8:	a5e080e7          	jalr	-1442(ra) # 5a22 <printf>
            exit(1);
    1fcc:	4505                	li	a0,1
    1fce:	00003097          	auipc	ra,0x3
    1fd2:	6d4080e7          	jalr	1748(ra) # 56a2 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd6:	86aa                	mv	a3,a0
    1fd8:	660d                	lui	a2,0x3
    1fda:	85d6                	mv	a1,s5
    1fdc:	00004517          	auipc	a0,0x4
    1fe0:	01450513          	addi	a0,a0,20 # 5ff0 <malloc+0x510>
    1fe4:	00004097          	auipc	ra,0x4
    1fe8:	a3e080e7          	jalr	-1474(ra) # 5a22 <printf>
            exit(1);
    1fec:	4505                	li	a0,1
    1fee:	00003097          	auipc	ra,0x3
    1ff2:	6b4080e7          	jalr	1716(ra) # 56a2 <exit>
      exit(st);
    1ff6:	00003097          	auipc	ra,0x3
    1ffa:	6ac080e7          	jalr	1708(ra) # 56a2 <exit>

0000000000001ffe <forktest>:
{
    1ffe:	7179                	addi	sp,sp,-48
    2000:	f406                	sd	ra,40(sp)
    2002:	f022                	sd	s0,32(sp)
    2004:	ec26                	sd	s1,24(sp)
    2006:	e84a                	sd	s2,16(sp)
    2008:	e44e                	sd	s3,8(sp)
    200a:	1800                	addi	s0,sp,48
    200c:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    200e:	4481                	li	s1,0
    2010:	3e800913          	li	s2,1000
    pid = fork();
    2014:	00003097          	auipc	ra,0x3
    2018:	686080e7          	jalr	1670(ra) # 569a <fork>
    if(pid < 0)
    201c:	02054863          	bltz	a0,204c <forktest+0x4e>
    if(pid == 0)
    2020:	c115                	beqz	a0,2044 <forktest+0x46>
  for(n=0; n<N; n++){
    2022:	2485                	addiw	s1,s1,1
    2024:	ff2498e3          	bne	s1,s2,2014 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2028:	85ce                	mv	a1,s3
    202a:	00005517          	auipc	a0,0x5
    202e:	9ce50513          	addi	a0,a0,-1586 # 69f8 <malloc+0xf18>
    2032:	00004097          	auipc	ra,0x4
    2036:	9f0080e7          	jalr	-1552(ra) # 5a22 <printf>
    exit(1);
    203a:	4505                	li	a0,1
    203c:	00003097          	auipc	ra,0x3
    2040:	666080e7          	jalr	1638(ra) # 56a2 <exit>
      exit(0);
    2044:	00003097          	auipc	ra,0x3
    2048:	65e080e7          	jalr	1630(ra) # 56a2 <exit>
  if (n == 0) {
    204c:	cc9d                	beqz	s1,208a <forktest+0x8c>
  if(n == N){
    204e:	3e800793          	li	a5,1000
    2052:	fcf48be3          	beq	s1,a5,2028 <forktest+0x2a>
  for(; n > 0; n--){
    2056:	00905b63          	blez	s1,206c <forktest+0x6e>
    if(wait(0) < 0){
    205a:	4501                	li	a0,0
    205c:	00003097          	auipc	ra,0x3
    2060:	64e080e7          	jalr	1614(ra) # 56aa <wait>
    2064:	04054163          	bltz	a0,20a6 <forktest+0xa8>
  for(; n > 0; n--){
    2068:	34fd                	addiw	s1,s1,-1
    206a:	f8e5                	bnez	s1,205a <forktest+0x5c>
  if(wait(0) != -1){
    206c:	4501                	li	a0,0
    206e:	00003097          	auipc	ra,0x3
    2072:	63c080e7          	jalr	1596(ra) # 56aa <wait>
    2076:	57fd                	li	a5,-1
    2078:	04f51563          	bne	a0,a5,20c2 <forktest+0xc4>
}
    207c:	70a2                	ld	ra,40(sp)
    207e:	7402                	ld	s0,32(sp)
    2080:	64e2                	ld	s1,24(sp)
    2082:	6942                	ld	s2,16(sp)
    2084:	69a2                	ld	s3,8(sp)
    2086:	6145                	addi	sp,sp,48
    2088:	8082                	ret
    printf("%s: no fork at all!\n", s);
    208a:	85ce                	mv	a1,s3
    208c:	00005517          	auipc	a0,0x5
    2090:	95450513          	addi	a0,a0,-1708 # 69e0 <malloc+0xf00>
    2094:	00004097          	auipc	ra,0x4
    2098:	98e080e7          	jalr	-1650(ra) # 5a22 <printf>
    exit(1);
    209c:	4505                	li	a0,1
    209e:	00003097          	auipc	ra,0x3
    20a2:	604080e7          	jalr	1540(ra) # 56a2 <exit>
      printf("%s: wait stopped early\n", s);
    20a6:	85ce                	mv	a1,s3
    20a8:	00005517          	auipc	a0,0x5
    20ac:	97850513          	addi	a0,a0,-1672 # 6a20 <malloc+0xf40>
    20b0:	00004097          	auipc	ra,0x4
    20b4:	972080e7          	jalr	-1678(ra) # 5a22 <printf>
      exit(1);
    20b8:	4505                	li	a0,1
    20ba:	00003097          	auipc	ra,0x3
    20be:	5e8080e7          	jalr	1512(ra) # 56a2 <exit>
    printf("%s: wait got too many\n", s);
    20c2:	85ce                	mv	a1,s3
    20c4:	00005517          	auipc	a0,0x5
    20c8:	97450513          	addi	a0,a0,-1676 # 6a38 <malloc+0xf58>
    20cc:	00004097          	auipc	ra,0x4
    20d0:	956080e7          	jalr	-1706(ra) # 5a22 <printf>
    exit(1);
    20d4:	4505                	li	a0,1
    20d6:	00003097          	auipc	ra,0x3
    20da:	5cc080e7          	jalr	1484(ra) # 56a2 <exit>

00000000000020de <kernmem>:
{
    20de:	715d                	addi	sp,sp,-80
    20e0:	e486                	sd	ra,72(sp)
    20e2:	e0a2                	sd	s0,64(sp)
    20e4:	fc26                	sd	s1,56(sp)
    20e6:	f84a                	sd	s2,48(sp)
    20e8:	f44e                	sd	s3,40(sp)
    20ea:	f052                	sd	s4,32(sp)
    20ec:	ec56                	sd	s5,24(sp)
    20ee:	0880                	addi	s0,sp,80
    20f0:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f2:	4485                	li	s1,1
    20f4:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f6:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f8:	69b1                	lui	s3,0xc
    20fa:	35098993          	addi	s3,s3,848 # c350 <buf+0x7d8>
    20fe:	1003d937          	lui	s2,0x1003d
    2102:	090e                	slli	s2,s2,0x3
    2104:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e8f8>
    pid = fork();
    2108:	00003097          	auipc	ra,0x3
    210c:	592080e7          	jalr	1426(ra) # 569a <fork>
    if(pid < 0){
    2110:	02054963          	bltz	a0,2142 <kernmem+0x64>
    if(pid == 0){
    2114:	c529                	beqz	a0,215e <kernmem+0x80>
    wait(&xstatus);
    2116:	fbc40513          	addi	a0,s0,-68
    211a:	00003097          	auipc	ra,0x3
    211e:	590080e7          	jalr	1424(ra) # 56aa <wait>
    if(xstatus != -1)  // did kernel kill child?
    2122:	fbc42783          	lw	a5,-68(s0)
    2126:	05579d63          	bne	a5,s5,2180 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    212a:	94ce                	add	s1,s1,s3
    212c:	fd249ee3          	bne	s1,s2,2108 <kernmem+0x2a>
}
    2130:	60a6                	ld	ra,72(sp)
    2132:	6406                	ld	s0,64(sp)
    2134:	74e2                	ld	s1,56(sp)
    2136:	7942                	ld	s2,48(sp)
    2138:	79a2                	ld	s3,40(sp)
    213a:	7a02                	ld	s4,32(sp)
    213c:	6ae2                	ld	s5,24(sp)
    213e:	6161                	addi	sp,sp,80
    2140:	8082                	ret
      printf("%s: fork failed\n", s);
    2142:	85d2                	mv	a1,s4
    2144:	00004517          	auipc	a0,0x4
    2148:	62450513          	addi	a0,a0,1572 # 6768 <malloc+0xc88>
    214c:	00004097          	auipc	ra,0x4
    2150:	8d6080e7          	jalr	-1834(ra) # 5a22 <printf>
      exit(1);
    2154:	4505                	li	a0,1
    2156:	00003097          	auipc	ra,0x3
    215a:	54c080e7          	jalr	1356(ra) # 56a2 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    215e:	0004c683          	lbu	a3,0(s1)
    2162:	8626                	mv	a2,s1
    2164:	85d2                	mv	a1,s4
    2166:	00005517          	auipc	a0,0x5
    216a:	8ea50513          	addi	a0,a0,-1814 # 6a50 <malloc+0xf70>
    216e:	00004097          	auipc	ra,0x4
    2172:	8b4080e7          	jalr	-1868(ra) # 5a22 <printf>
      exit(1);
    2176:	4505                	li	a0,1
    2178:	00003097          	auipc	ra,0x3
    217c:	52a080e7          	jalr	1322(ra) # 56a2 <exit>
      exit(1);
    2180:	4505                	li	a0,1
    2182:	00003097          	auipc	ra,0x3
    2186:	520080e7          	jalr	1312(ra) # 56a2 <exit>

000000000000218a <bigargtest>:
{
    218a:	7179                	addi	sp,sp,-48
    218c:	f406                	sd	ra,40(sp)
    218e:	f022                	sd	s0,32(sp)
    2190:	ec26                	sd	s1,24(sp)
    2192:	1800                	addi	s0,sp,48
    2194:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2196:	00005517          	auipc	a0,0x5
    219a:	8da50513          	addi	a0,a0,-1830 # 6a70 <malloc+0xf90>
    219e:	00003097          	auipc	ra,0x3
    21a2:	554080e7          	jalr	1364(ra) # 56f2 <unlink>
  pid = fork();
    21a6:	00003097          	auipc	ra,0x3
    21aa:	4f4080e7          	jalr	1268(ra) # 569a <fork>
  if(pid == 0){
    21ae:	c121                	beqz	a0,21ee <bigargtest+0x64>
  } else if(pid < 0){
    21b0:	0a054063          	bltz	a0,2250 <bigargtest+0xc6>
  wait(&xstatus);
    21b4:	fdc40513          	addi	a0,s0,-36
    21b8:	00003097          	auipc	ra,0x3
    21bc:	4f2080e7          	jalr	1266(ra) # 56aa <wait>
  if(xstatus != 0)
    21c0:	fdc42503          	lw	a0,-36(s0)
    21c4:	e545                	bnez	a0,226c <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21c6:	4581                	li	a1,0
    21c8:	00005517          	auipc	a0,0x5
    21cc:	8a850513          	addi	a0,a0,-1880 # 6a70 <malloc+0xf90>
    21d0:	00003097          	auipc	ra,0x3
    21d4:	512080e7          	jalr	1298(ra) # 56e2 <open>
  if(fd < 0){
    21d8:	08054e63          	bltz	a0,2274 <bigargtest+0xea>
  close(fd);
    21dc:	00003097          	auipc	ra,0x3
    21e0:	4ee080e7          	jalr	1262(ra) # 56ca <close>
}
    21e4:	70a2                	ld	ra,40(sp)
    21e6:	7402                	ld	s0,32(sp)
    21e8:	64e2                	ld	s1,24(sp)
    21ea:	6145                	addi	sp,sp,48
    21ec:	8082                	ret
    21ee:	00006797          	auipc	a5,0x6
    21f2:	17278793          	addi	a5,a5,370 # 8360 <args.1>
    21f6:	00006697          	auipc	a3,0x6
    21fa:	26268693          	addi	a3,a3,610 # 8458 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    21fe:	00005717          	auipc	a4,0x5
    2202:	88270713          	addi	a4,a4,-1918 # 6a80 <malloc+0xfa0>
    2206:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2208:	07a1                	addi	a5,a5,8
    220a:	fed79ee3          	bne	a5,a3,2206 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    220e:	00006597          	auipc	a1,0x6
    2212:	15258593          	addi	a1,a1,338 # 8360 <args.1>
    2216:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    221a:	00004517          	auipc	a0,0x4
    221e:	d1650513          	addi	a0,a0,-746 # 5f30 <malloc+0x450>
    2222:	00003097          	auipc	ra,0x3
    2226:	4b8080e7          	jalr	1208(ra) # 56da <exec>
    fd = open("bigarg-ok", O_CREATE);
    222a:	20000593          	li	a1,512
    222e:	00005517          	auipc	a0,0x5
    2232:	84250513          	addi	a0,a0,-1982 # 6a70 <malloc+0xf90>
    2236:	00003097          	auipc	ra,0x3
    223a:	4ac080e7          	jalr	1196(ra) # 56e2 <open>
    close(fd);
    223e:	00003097          	auipc	ra,0x3
    2242:	48c080e7          	jalr	1164(ra) # 56ca <close>
    exit(0);
    2246:	4501                	li	a0,0
    2248:	00003097          	auipc	ra,0x3
    224c:	45a080e7          	jalr	1114(ra) # 56a2 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2250:	85a6                	mv	a1,s1
    2252:	00005517          	auipc	a0,0x5
    2256:	90e50513          	addi	a0,a0,-1778 # 6b60 <malloc+0x1080>
    225a:	00003097          	auipc	ra,0x3
    225e:	7c8080e7          	jalr	1992(ra) # 5a22 <printf>
    exit(1);
    2262:	4505                	li	a0,1
    2264:	00003097          	auipc	ra,0x3
    2268:	43e080e7          	jalr	1086(ra) # 56a2 <exit>
    exit(xstatus);
    226c:	00003097          	auipc	ra,0x3
    2270:	436080e7          	jalr	1078(ra) # 56a2 <exit>
    printf("%s: bigarg test failed!\n", s);
    2274:	85a6                	mv	a1,s1
    2276:	00005517          	auipc	a0,0x5
    227a:	90a50513          	addi	a0,a0,-1782 # 6b80 <malloc+0x10a0>
    227e:	00003097          	auipc	ra,0x3
    2282:	7a4080e7          	jalr	1956(ra) # 5a22 <printf>
    exit(1);
    2286:	4505                	li	a0,1
    2288:	00003097          	auipc	ra,0x3
    228c:	41a080e7          	jalr	1050(ra) # 56a2 <exit>

0000000000002290 <stacktest>:
{
    2290:	7179                	addi	sp,sp,-48
    2292:	f406                	sd	ra,40(sp)
    2294:	f022                	sd	s0,32(sp)
    2296:	ec26                	sd	s1,24(sp)
    2298:	1800                	addi	s0,sp,48
    229a:	84aa                	mv	s1,a0
  pid = fork();
    229c:	00003097          	auipc	ra,0x3
    22a0:	3fe080e7          	jalr	1022(ra) # 569a <fork>
  if(pid == 0) {
    22a4:	c115                	beqz	a0,22c8 <stacktest+0x38>
  } else if(pid < 0){
    22a6:	04054463          	bltz	a0,22ee <stacktest+0x5e>
  wait(&xstatus);
    22aa:	fdc40513          	addi	a0,s0,-36
    22ae:	00003097          	auipc	ra,0x3
    22b2:	3fc080e7          	jalr	1020(ra) # 56aa <wait>
  if(xstatus == -1)  // kernel killed child?
    22b6:	fdc42503          	lw	a0,-36(s0)
    22ba:	57fd                	li	a5,-1
    22bc:	04f50763          	beq	a0,a5,230a <stacktest+0x7a>
    exit(xstatus);
    22c0:	00003097          	auipc	ra,0x3
    22c4:	3e2080e7          	jalr	994(ra) # 56a2 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22c8:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22ca:	77fd                	lui	a5,0xfffff
    22cc:	97ba                	add	a5,a5,a4
    22ce:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0478>
    22d2:	85a6                	mv	a1,s1
    22d4:	00005517          	auipc	a0,0x5
    22d8:	8cc50513          	addi	a0,a0,-1844 # 6ba0 <malloc+0x10c0>
    22dc:	00003097          	auipc	ra,0x3
    22e0:	746080e7          	jalr	1862(ra) # 5a22 <printf>
    exit(1);
    22e4:	4505                	li	a0,1
    22e6:	00003097          	auipc	ra,0x3
    22ea:	3bc080e7          	jalr	956(ra) # 56a2 <exit>
    printf("%s: fork failed\n", s);
    22ee:	85a6                	mv	a1,s1
    22f0:	00004517          	auipc	a0,0x4
    22f4:	47850513          	addi	a0,a0,1144 # 6768 <malloc+0xc88>
    22f8:	00003097          	auipc	ra,0x3
    22fc:	72a080e7          	jalr	1834(ra) # 5a22 <printf>
    exit(1);
    2300:	4505                	li	a0,1
    2302:	00003097          	auipc	ra,0x3
    2306:	3a0080e7          	jalr	928(ra) # 56a2 <exit>
    exit(0);
    230a:	4501                	li	a0,0
    230c:	00003097          	auipc	ra,0x3
    2310:	396080e7          	jalr	918(ra) # 56a2 <exit>

0000000000002314 <copyinstr3>:
{
    2314:	7179                	addi	sp,sp,-48
    2316:	f406                	sd	ra,40(sp)
    2318:	f022                	sd	s0,32(sp)
    231a:	ec26                	sd	s1,24(sp)
    231c:	1800                	addi	s0,sp,48
  sbrk(8192);
    231e:	6509                	lui	a0,0x2
    2320:	00003097          	auipc	ra,0x3
    2324:	40a080e7          	jalr	1034(ra) # 572a <sbrk>
  uint64 top = (uint64) sbrk(0);
    2328:	4501                	li	a0,0
    232a:	00003097          	auipc	ra,0x3
    232e:	400080e7          	jalr	1024(ra) # 572a <sbrk>
  if((top % PGSIZE) != 0){
    2332:	03451793          	slli	a5,a0,0x34
    2336:	e3c9                	bnez	a5,23b8 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2338:	4501                	li	a0,0
    233a:	00003097          	auipc	ra,0x3
    233e:	3f0080e7          	jalr	1008(ra) # 572a <sbrk>
  if(top % PGSIZE){
    2342:	03451793          	slli	a5,a0,0x34
    2346:	e3d9                	bnez	a5,23cc <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2348:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x1>
  *b = 'x';
    234c:	07800793          	li	a5,120
    2350:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2354:	8526                	mv	a0,s1
    2356:	00003097          	auipc	ra,0x3
    235a:	39c080e7          	jalr	924(ra) # 56f2 <unlink>
  if(ret != -1){
    235e:	57fd                	li	a5,-1
    2360:	08f51363          	bne	a0,a5,23e6 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2364:	20100593          	li	a1,513
    2368:	8526                	mv	a0,s1
    236a:	00003097          	auipc	ra,0x3
    236e:	378080e7          	jalr	888(ra) # 56e2 <open>
  if(fd != -1){
    2372:	57fd                	li	a5,-1
    2374:	08f51863          	bne	a0,a5,2404 <copyinstr3+0xf0>
  ret = link(b, b);
    2378:	85a6                	mv	a1,s1
    237a:	8526                	mv	a0,s1
    237c:	00003097          	auipc	ra,0x3
    2380:	386080e7          	jalr	902(ra) # 5702 <link>
  if(ret != -1){
    2384:	57fd                	li	a5,-1
    2386:	08f51e63          	bne	a0,a5,2422 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    238a:	00005797          	auipc	a5,0x5
    238e:	4ae78793          	addi	a5,a5,1198 # 7838 <malloc+0x1d58>
    2392:	fcf43823          	sd	a5,-48(s0)
    2396:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    239a:	fd040593          	addi	a1,s0,-48
    239e:	8526                	mv	a0,s1
    23a0:	00003097          	auipc	ra,0x3
    23a4:	33a080e7          	jalr	826(ra) # 56da <exec>
  if(ret != -1){
    23a8:	57fd                	li	a5,-1
    23aa:	08f51c63          	bne	a0,a5,2442 <copyinstr3+0x12e>
}
    23ae:	70a2                	ld	ra,40(sp)
    23b0:	7402                	ld	s0,32(sp)
    23b2:	64e2                	ld	s1,24(sp)
    23b4:	6145                	addi	sp,sp,48
    23b6:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23b8:	0347d513          	srli	a0,a5,0x34
    23bc:	6785                	lui	a5,0x1
    23be:	40a7853b          	subw	a0,a5,a0
    23c2:	00003097          	auipc	ra,0x3
    23c6:	368080e7          	jalr	872(ra) # 572a <sbrk>
    23ca:	b7bd                	j	2338 <copyinstr3+0x24>
    printf("oops\n");
    23cc:	00004517          	auipc	a0,0x4
    23d0:	7fc50513          	addi	a0,a0,2044 # 6bc8 <malloc+0x10e8>
    23d4:	00003097          	auipc	ra,0x3
    23d8:	64e080e7          	jalr	1614(ra) # 5a22 <printf>
    exit(1);
    23dc:	4505                	li	a0,1
    23de:	00003097          	auipc	ra,0x3
    23e2:	2c4080e7          	jalr	708(ra) # 56a2 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    23e6:	862a                	mv	a2,a0
    23e8:	85a6                	mv	a1,s1
    23ea:	00004517          	auipc	a0,0x4
    23ee:	29e50513          	addi	a0,a0,670 # 6688 <malloc+0xba8>
    23f2:	00003097          	auipc	ra,0x3
    23f6:	630080e7          	jalr	1584(ra) # 5a22 <printf>
    exit(1);
    23fa:	4505                	li	a0,1
    23fc:	00003097          	auipc	ra,0x3
    2400:	2a6080e7          	jalr	678(ra) # 56a2 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2404:	862a                	mv	a2,a0
    2406:	85a6                	mv	a1,s1
    2408:	00004517          	auipc	a0,0x4
    240c:	2a050513          	addi	a0,a0,672 # 66a8 <malloc+0xbc8>
    2410:	00003097          	auipc	ra,0x3
    2414:	612080e7          	jalr	1554(ra) # 5a22 <printf>
    exit(1);
    2418:	4505                	li	a0,1
    241a:	00003097          	auipc	ra,0x3
    241e:	288080e7          	jalr	648(ra) # 56a2 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2422:	86aa                	mv	a3,a0
    2424:	8626                	mv	a2,s1
    2426:	85a6                	mv	a1,s1
    2428:	00004517          	auipc	a0,0x4
    242c:	2a050513          	addi	a0,a0,672 # 66c8 <malloc+0xbe8>
    2430:	00003097          	auipc	ra,0x3
    2434:	5f2080e7          	jalr	1522(ra) # 5a22 <printf>
    exit(1);
    2438:	4505                	li	a0,1
    243a:	00003097          	auipc	ra,0x3
    243e:	268080e7          	jalr	616(ra) # 56a2 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2442:	567d                	li	a2,-1
    2444:	85a6                	mv	a1,s1
    2446:	00004517          	auipc	a0,0x4
    244a:	2aa50513          	addi	a0,a0,682 # 66f0 <malloc+0xc10>
    244e:	00003097          	auipc	ra,0x3
    2452:	5d4080e7          	jalr	1492(ra) # 5a22 <printf>
    exit(1);
    2456:	4505                	li	a0,1
    2458:	00003097          	auipc	ra,0x3
    245c:	24a080e7          	jalr	586(ra) # 56a2 <exit>

0000000000002460 <rwsbrk>:
{
    2460:	1101                	addi	sp,sp,-32
    2462:	ec06                	sd	ra,24(sp)
    2464:	e822                	sd	s0,16(sp)
    2466:	e426                	sd	s1,8(sp)
    2468:	e04a                	sd	s2,0(sp)
    246a:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    246c:	6509                	lui	a0,0x2
    246e:	00003097          	auipc	ra,0x3
    2472:	2bc080e7          	jalr	700(ra) # 572a <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2476:	57fd                	li	a5,-1
    2478:	06f50363          	beq	a0,a5,24de <rwsbrk+0x7e>
    247c:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    247e:	7579                	lui	a0,0xffffe
    2480:	00003097          	auipc	ra,0x3
    2484:	2aa080e7          	jalr	682(ra) # 572a <sbrk>
    2488:	57fd                	li	a5,-1
    248a:	06f50763          	beq	a0,a5,24f8 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    248e:	20100593          	li	a1,513
    2492:	00003517          	auipc	a0,0x3
    2496:	7ae50513          	addi	a0,a0,1966 # 5c40 <malloc+0x160>
    249a:	00003097          	auipc	ra,0x3
    249e:	248080e7          	jalr	584(ra) # 56e2 <open>
    24a2:	892a                	mv	s2,a0
  if(fd < 0){
    24a4:	06054763          	bltz	a0,2512 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    24a8:	6505                	lui	a0,0x1
    24aa:	94aa                	add	s1,s1,a0
    24ac:	40000613          	li	a2,1024
    24b0:	85a6                	mv	a1,s1
    24b2:	854a                	mv	a0,s2
    24b4:	00003097          	auipc	ra,0x3
    24b8:	20e080e7          	jalr	526(ra) # 56c2 <write>
    24bc:	862a                	mv	a2,a0
  if(n >= 0){
    24be:	06054763          	bltz	a0,252c <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24c2:	85a6                	mv	a1,s1
    24c4:	00004517          	auipc	a0,0x4
    24c8:	75c50513          	addi	a0,a0,1884 # 6c20 <malloc+0x1140>
    24cc:	00003097          	auipc	ra,0x3
    24d0:	556080e7          	jalr	1366(ra) # 5a22 <printf>
    exit(1);
    24d4:	4505                	li	a0,1
    24d6:	00003097          	auipc	ra,0x3
    24da:	1cc080e7          	jalr	460(ra) # 56a2 <exit>
    printf("sbrk(rwsbrk) failed\n");
    24de:	00004517          	auipc	a0,0x4
    24e2:	6f250513          	addi	a0,a0,1778 # 6bd0 <malloc+0x10f0>
    24e6:	00003097          	auipc	ra,0x3
    24ea:	53c080e7          	jalr	1340(ra) # 5a22 <printf>
    exit(1);
    24ee:	4505                	li	a0,1
    24f0:	00003097          	auipc	ra,0x3
    24f4:	1b2080e7          	jalr	434(ra) # 56a2 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    24f8:	00004517          	auipc	a0,0x4
    24fc:	6f050513          	addi	a0,a0,1776 # 6be8 <malloc+0x1108>
    2500:	00003097          	auipc	ra,0x3
    2504:	522080e7          	jalr	1314(ra) # 5a22 <printf>
    exit(1);
    2508:	4505                	li	a0,1
    250a:	00003097          	auipc	ra,0x3
    250e:	198080e7          	jalr	408(ra) # 56a2 <exit>
    printf("open(rwsbrk) failed\n");
    2512:	00004517          	auipc	a0,0x4
    2516:	6f650513          	addi	a0,a0,1782 # 6c08 <malloc+0x1128>
    251a:	00003097          	auipc	ra,0x3
    251e:	508080e7          	jalr	1288(ra) # 5a22 <printf>
    exit(1);
    2522:	4505                	li	a0,1
    2524:	00003097          	auipc	ra,0x3
    2528:	17e080e7          	jalr	382(ra) # 56a2 <exit>
  close(fd);
    252c:	854a                	mv	a0,s2
    252e:	00003097          	auipc	ra,0x3
    2532:	19c080e7          	jalr	412(ra) # 56ca <close>
  unlink("rwsbrk");
    2536:	00003517          	auipc	a0,0x3
    253a:	70a50513          	addi	a0,a0,1802 # 5c40 <malloc+0x160>
    253e:	00003097          	auipc	ra,0x3
    2542:	1b4080e7          	jalr	436(ra) # 56f2 <unlink>
  fd = open("README", O_RDONLY);
    2546:	4581                	li	a1,0
    2548:	00004517          	auipc	a0,0x4
    254c:	b8050513          	addi	a0,a0,-1152 # 60c8 <malloc+0x5e8>
    2550:	00003097          	auipc	ra,0x3
    2554:	192080e7          	jalr	402(ra) # 56e2 <open>
    2558:	892a                	mv	s2,a0
  if(fd < 0){
    255a:	02054963          	bltz	a0,258c <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    255e:	4629                	li	a2,10
    2560:	85a6                	mv	a1,s1
    2562:	00003097          	auipc	ra,0x3
    2566:	158080e7          	jalr	344(ra) # 56ba <read>
    256a:	862a                	mv	a2,a0
  if(n >= 0){
    256c:	02054d63          	bltz	a0,25a6 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2570:	85a6                	mv	a1,s1
    2572:	00004517          	auipc	a0,0x4
    2576:	6de50513          	addi	a0,a0,1758 # 6c50 <malloc+0x1170>
    257a:	00003097          	auipc	ra,0x3
    257e:	4a8080e7          	jalr	1192(ra) # 5a22 <printf>
    exit(1);
    2582:	4505                	li	a0,1
    2584:	00003097          	auipc	ra,0x3
    2588:	11e080e7          	jalr	286(ra) # 56a2 <exit>
    printf("open(rwsbrk) failed\n");
    258c:	00004517          	auipc	a0,0x4
    2590:	67c50513          	addi	a0,a0,1660 # 6c08 <malloc+0x1128>
    2594:	00003097          	auipc	ra,0x3
    2598:	48e080e7          	jalr	1166(ra) # 5a22 <printf>
    exit(1);
    259c:	4505                	li	a0,1
    259e:	00003097          	auipc	ra,0x3
    25a2:	104080e7          	jalr	260(ra) # 56a2 <exit>
  close(fd);
    25a6:	854a                	mv	a0,s2
    25a8:	00003097          	auipc	ra,0x3
    25ac:	122080e7          	jalr	290(ra) # 56ca <close>
  exit(0);
    25b0:	4501                	li	a0,0
    25b2:	00003097          	auipc	ra,0x3
    25b6:	0f0080e7          	jalr	240(ra) # 56a2 <exit>

00000000000025ba <sbrkbasic>:
{
    25ba:	7139                	addi	sp,sp,-64
    25bc:	fc06                	sd	ra,56(sp)
    25be:	f822                	sd	s0,48(sp)
    25c0:	f426                	sd	s1,40(sp)
    25c2:	f04a                	sd	s2,32(sp)
    25c4:	ec4e                	sd	s3,24(sp)
    25c6:	e852                	sd	s4,16(sp)
    25c8:	0080                	addi	s0,sp,64
    25ca:	8a2a                	mv	s4,a0
  pid = fork();
    25cc:	00003097          	auipc	ra,0x3
    25d0:	0ce080e7          	jalr	206(ra) # 569a <fork>
  if(pid < 0){
    25d4:	02054c63          	bltz	a0,260c <sbrkbasic+0x52>
  if(pid == 0){
    25d8:	ed21                	bnez	a0,2630 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    25da:	40000537          	lui	a0,0x40000
    25de:	00003097          	auipc	ra,0x3
    25e2:	14c080e7          	jalr	332(ra) # 572a <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    25e6:	57fd                	li	a5,-1
    25e8:	02f50f63          	beq	a0,a5,2626 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25ec:	400007b7          	lui	a5,0x40000
    25f0:	97aa                	add	a5,a5,a0
      *b = 99;
    25f2:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    25f6:	6705                	lui	a4,0x1
      *b = 99;
    25f8:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1478>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25fc:	953a                	add	a0,a0,a4
    25fe:	fef51de3          	bne	a0,a5,25f8 <sbrkbasic+0x3e>
    exit(1);
    2602:	4505                	li	a0,1
    2604:	00003097          	auipc	ra,0x3
    2608:	09e080e7          	jalr	158(ra) # 56a2 <exit>
    printf("fork failed in sbrkbasic\n");
    260c:	00004517          	auipc	a0,0x4
    2610:	66c50513          	addi	a0,a0,1644 # 6c78 <malloc+0x1198>
    2614:	00003097          	auipc	ra,0x3
    2618:	40e080e7          	jalr	1038(ra) # 5a22 <printf>
    exit(1);
    261c:	4505                	li	a0,1
    261e:	00003097          	auipc	ra,0x3
    2622:	084080e7          	jalr	132(ra) # 56a2 <exit>
      exit(0);
    2626:	4501                	li	a0,0
    2628:	00003097          	auipc	ra,0x3
    262c:	07a080e7          	jalr	122(ra) # 56a2 <exit>
  wait(&xstatus);
    2630:	fcc40513          	addi	a0,s0,-52
    2634:	00003097          	auipc	ra,0x3
    2638:	076080e7          	jalr	118(ra) # 56aa <wait>
  if(xstatus == 1){
    263c:	fcc42703          	lw	a4,-52(s0)
    2640:	4785                	li	a5,1
    2642:	00f70d63          	beq	a4,a5,265c <sbrkbasic+0xa2>
  a = sbrk(0);
    2646:	4501                	li	a0,0
    2648:	00003097          	auipc	ra,0x3
    264c:	0e2080e7          	jalr	226(ra) # 572a <sbrk>
    2650:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2652:	4901                	li	s2,0
    2654:	6985                	lui	s3,0x1
    2656:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d4>
    265a:	a005                	j	267a <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    265c:	85d2                	mv	a1,s4
    265e:	00004517          	auipc	a0,0x4
    2662:	63a50513          	addi	a0,a0,1594 # 6c98 <malloc+0x11b8>
    2666:	00003097          	auipc	ra,0x3
    266a:	3bc080e7          	jalr	956(ra) # 5a22 <printf>
    exit(1);
    266e:	4505                	li	a0,1
    2670:	00003097          	auipc	ra,0x3
    2674:	032080e7          	jalr	50(ra) # 56a2 <exit>
    a = b + 1;
    2678:	84be                	mv	s1,a5
    b = sbrk(1);
    267a:	4505                	li	a0,1
    267c:	00003097          	auipc	ra,0x3
    2680:	0ae080e7          	jalr	174(ra) # 572a <sbrk>
    if(b != a){
    2684:	04951c63          	bne	a0,s1,26dc <sbrkbasic+0x122>
    *b = 1;
    2688:	4785                	li	a5,1
    268a:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    268e:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2692:	2905                	addiw	s2,s2,1
    2694:	ff3912e3          	bne	s2,s3,2678 <sbrkbasic+0xbe>
  pid = fork();
    2698:	00003097          	auipc	ra,0x3
    269c:	002080e7          	jalr	2(ra) # 569a <fork>
    26a0:	892a                	mv	s2,a0
  if(pid < 0){
    26a2:	04054d63          	bltz	a0,26fc <sbrkbasic+0x142>
  c = sbrk(1);
    26a6:	4505                	li	a0,1
    26a8:	00003097          	auipc	ra,0x3
    26ac:	082080e7          	jalr	130(ra) # 572a <sbrk>
  c = sbrk(1);
    26b0:	4505                	li	a0,1
    26b2:	00003097          	auipc	ra,0x3
    26b6:	078080e7          	jalr	120(ra) # 572a <sbrk>
  if(c != a + 1){
    26ba:	0489                	addi	s1,s1,2
    26bc:	04a48e63          	beq	s1,a0,2718 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    26c0:	85d2                	mv	a1,s4
    26c2:	00004517          	auipc	a0,0x4
    26c6:	63650513          	addi	a0,a0,1590 # 6cf8 <malloc+0x1218>
    26ca:	00003097          	auipc	ra,0x3
    26ce:	358080e7          	jalr	856(ra) # 5a22 <printf>
    exit(1);
    26d2:	4505                	li	a0,1
    26d4:	00003097          	auipc	ra,0x3
    26d8:	fce080e7          	jalr	-50(ra) # 56a2 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    26dc:	86aa                	mv	a3,a0
    26de:	8626                	mv	a2,s1
    26e0:	85ca                	mv	a1,s2
    26e2:	00004517          	auipc	a0,0x4
    26e6:	5d650513          	addi	a0,a0,1494 # 6cb8 <malloc+0x11d8>
    26ea:	00003097          	auipc	ra,0x3
    26ee:	338080e7          	jalr	824(ra) # 5a22 <printf>
      exit(1);
    26f2:	4505                	li	a0,1
    26f4:	00003097          	auipc	ra,0x3
    26f8:	fae080e7          	jalr	-82(ra) # 56a2 <exit>
    printf("%s: sbrk test fork failed\n", s);
    26fc:	85d2                	mv	a1,s4
    26fe:	00004517          	auipc	a0,0x4
    2702:	5da50513          	addi	a0,a0,1498 # 6cd8 <malloc+0x11f8>
    2706:	00003097          	auipc	ra,0x3
    270a:	31c080e7          	jalr	796(ra) # 5a22 <printf>
    exit(1);
    270e:	4505                	li	a0,1
    2710:	00003097          	auipc	ra,0x3
    2714:	f92080e7          	jalr	-110(ra) # 56a2 <exit>
  if(pid == 0)
    2718:	00091763          	bnez	s2,2726 <sbrkbasic+0x16c>
    exit(0);
    271c:	4501                	li	a0,0
    271e:	00003097          	auipc	ra,0x3
    2722:	f84080e7          	jalr	-124(ra) # 56a2 <exit>
  wait(&xstatus);
    2726:	fcc40513          	addi	a0,s0,-52
    272a:	00003097          	auipc	ra,0x3
    272e:	f80080e7          	jalr	-128(ra) # 56aa <wait>
  exit(xstatus);
    2732:	fcc42503          	lw	a0,-52(s0)
    2736:	00003097          	auipc	ra,0x3
    273a:	f6c080e7          	jalr	-148(ra) # 56a2 <exit>

000000000000273e <sbrkmuch>:
{
    273e:	7179                	addi	sp,sp,-48
    2740:	f406                	sd	ra,40(sp)
    2742:	f022                	sd	s0,32(sp)
    2744:	ec26                	sd	s1,24(sp)
    2746:	e84a                	sd	s2,16(sp)
    2748:	e44e                	sd	s3,8(sp)
    274a:	e052                	sd	s4,0(sp)
    274c:	1800                	addi	s0,sp,48
    274e:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2750:	4501                	li	a0,0
    2752:	00003097          	auipc	ra,0x3
    2756:	fd8080e7          	jalr	-40(ra) # 572a <sbrk>
    275a:	892a                	mv	s2,a0
  a = sbrk(0);
    275c:	4501                	li	a0,0
    275e:	00003097          	auipc	ra,0x3
    2762:	fcc080e7          	jalr	-52(ra) # 572a <sbrk>
    2766:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2768:	06400537          	lui	a0,0x6400
    276c:	9d05                	subw	a0,a0,s1
    276e:	00003097          	auipc	ra,0x3
    2772:	fbc080e7          	jalr	-68(ra) # 572a <sbrk>
  if (p != a) {
    2776:	0ca49863          	bne	s1,a0,2846 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    277a:	4501                	li	a0,0
    277c:	00003097          	auipc	ra,0x3
    2780:	fae080e7          	jalr	-82(ra) # 572a <sbrk>
    2784:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2786:	00a4f963          	bgeu	s1,a0,2798 <sbrkmuch+0x5a>
    *pp = 1;
    278a:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    278c:	6705                	lui	a4,0x1
    *pp = 1;
    278e:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2792:	94ba                	add	s1,s1,a4
    2794:	fef4ede3          	bltu	s1,a5,278e <sbrkmuch+0x50>
  *lastaddr = 99;
    2798:	064007b7          	lui	a5,0x6400
    279c:	06300713          	li	a4,99
    27a0:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1477>
  a = sbrk(0);
    27a4:	4501                	li	a0,0
    27a6:	00003097          	auipc	ra,0x3
    27aa:	f84080e7          	jalr	-124(ra) # 572a <sbrk>
    27ae:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27b0:	757d                	lui	a0,0xfffff
    27b2:	00003097          	auipc	ra,0x3
    27b6:	f78080e7          	jalr	-136(ra) # 572a <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27ba:	57fd                	li	a5,-1
    27bc:	0af50363          	beq	a0,a5,2862 <sbrkmuch+0x124>
  c = sbrk(0);
    27c0:	4501                	li	a0,0
    27c2:	00003097          	auipc	ra,0x3
    27c6:	f68080e7          	jalr	-152(ra) # 572a <sbrk>
  if(c != a - PGSIZE){
    27ca:	77fd                	lui	a5,0xfffff
    27cc:	97a6                	add	a5,a5,s1
    27ce:	0af51863          	bne	a0,a5,287e <sbrkmuch+0x140>
  a = sbrk(0);
    27d2:	4501                	li	a0,0
    27d4:	00003097          	auipc	ra,0x3
    27d8:	f56080e7          	jalr	-170(ra) # 572a <sbrk>
    27dc:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    27de:	6505                	lui	a0,0x1
    27e0:	00003097          	auipc	ra,0x3
    27e4:	f4a080e7          	jalr	-182(ra) # 572a <sbrk>
    27e8:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    27ea:	0aa49a63          	bne	s1,a0,289e <sbrkmuch+0x160>
    27ee:	4501                	li	a0,0
    27f0:	00003097          	auipc	ra,0x3
    27f4:	f3a080e7          	jalr	-198(ra) # 572a <sbrk>
    27f8:	6785                	lui	a5,0x1
    27fa:	97a6                	add	a5,a5,s1
    27fc:	0af51163          	bne	a0,a5,289e <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2800:	064007b7          	lui	a5,0x6400
    2804:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1477>
    2808:	06300793          	li	a5,99
    280c:	0af70963          	beq	a4,a5,28be <sbrkmuch+0x180>
  a = sbrk(0);
    2810:	4501                	li	a0,0
    2812:	00003097          	auipc	ra,0x3
    2816:	f18080e7          	jalr	-232(ra) # 572a <sbrk>
    281a:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    281c:	4501                	li	a0,0
    281e:	00003097          	auipc	ra,0x3
    2822:	f0c080e7          	jalr	-244(ra) # 572a <sbrk>
    2826:	40a9053b          	subw	a0,s2,a0
    282a:	00003097          	auipc	ra,0x3
    282e:	f00080e7          	jalr	-256(ra) # 572a <sbrk>
  if(c != a){
    2832:	0aa49463          	bne	s1,a0,28da <sbrkmuch+0x19c>
}
    2836:	70a2                	ld	ra,40(sp)
    2838:	7402                	ld	s0,32(sp)
    283a:	64e2                	ld	s1,24(sp)
    283c:	6942                	ld	s2,16(sp)
    283e:	69a2                	ld	s3,8(sp)
    2840:	6a02                	ld	s4,0(sp)
    2842:	6145                	addi	sp,sp,48
    2844:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2846:	85ce                	mv	a1,s3
    2848:	00004517          	auipc	a0,0x4
    284c:	4d050513          	addi	a0,a0,1232 # 6d18 <malloc+0x1238>
    2850:	00003097          	auipc	ra,0x3
    2854:	1d2080e7          	jalr	466(ra) # 5a22 <printf>
    exit(1);
    2858:	4505                	li	a0,1
    285a:	00003097          	auipc	ra,0x3
    285e:	e48080e7          	jalr	-440(ra) # 56a2 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2862:	85ce                	mv	a1,s3
    2864:	00004517          	auipc	a0,0x4
    2868:	4fc50513          	addi	a0,a0,1276 # 6d60 <malloc+0x1280>
    286c:	00003097          	auipc	ra,0x3
    2870:	1b6080e7          	jalr	438(ra) # 5a22 <printf>
    exit(1);
    2874:	4505                	li	a0,1
    2876:	00003097          	auipc	ra,0x3
    287a:	e2c080e7          	jalr	-468(ra) # 56a2 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    287e:	86aa                	mv	a3,a0
    2880:	8626                	mv	a2,s1
    2882:	85ce                	mv	a1,s3
    2884:	00004517          	auipc	a0,0x4
    2888:	4fc50513          	addi	a0,a0,1276 # 6d80 <malloc+0x12a0>
    288c:	00003097          	auipc	ra,0x3
    2890:	196080e7          	jalr	406(ra) # 5a22 <printf>
    exit(1);
    2894:	4505                	li	a0,1
    2896:	00003097          	auipc	ra,0x3
    289a:	e0c080e7          	jalr	-500(ra) # 56a2 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    289e:	86d2                	mv	a3,s4
    28a0:	8626                	mv	a2,s1
    28a2:	85ce                	mv	a1,s3
    28a4:	00004517          	auipc	a0,0x4
    28a8:	51c50513          	addi	a0,a0,1308 # 6dc0 <malloc+0x12e0>
    28ac:	00003097          	auipc	ra,0x3
    28b0:	176080e7          	jalr	374(ra) # 5a22 <printf>
    exit(1);
    28b4:	4505                	li	a0,1
    28b6:	00003097          	auipc	ra,0x3
    28ba:	dec080e7          	jalr	-532(ra) # 56a2 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28be:	85ce                	mv	a1,s3
    28c0:	00004517          	auipc	a0,0x4
    28c4:	53050513          	addi	a0,a0,1328 # 6df0 <malloc+0x1310>
    28c8:	00003097          	auipc	ra,0x3
    28cc:	15a080e7          	jalr	346(ra) # 5a22 <printf>
    exit(1);
    28d0:	4505                	li	a0,1
    28d2:	00003097          	auipc	ra,0x3
    28d6:	dd0080e7          	jalr	-560(ra) # 56a2 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    28da:	86aa                	mv	a3,a0
    28dc:	8626                	mv	a2,s1
    28de:	85ce                	mv	a1,s3
    28e0:	00004517          	auipc	a0,0x4
    28e4:	54850513          	addi	a0,a0,1352 # 6e28 <malloc+0x1348>
    28e8:	00003097          	auipc	ra,0x3
    28ec:	13a080e7          	jalr	314(ra) # 5a22 <printf>
    exit(1);
    28f0:	4505                	li	a0,1
    28f2:	00003097          	auipc	ra,0x3
    28f6:	db0080e7          	jalr	-592(ra) # 56a2 <exit>

00000000000028fa <sbrkarg>:
{
    28fa:	7179                	addi	sp,sp,-48
    28fc:	f406                	sd	ra,40(sp)
    28fe:	f022                	sd	s0,32(sp)
    2900:	ec26                	sd	s1,24(sp)
    2902:	e84a                	sd	s2,16(sp)
    2904:	e44e                	sd	s3,8(sp)
    2906:	1800                	addi	s0,sp,48
    2908:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    290a:	6505                	lui	a0,0x1
    290c:	00003097          	auipc	ra,0x3
    2910:	e1e080e7          	jalr	-482(ra) # 572a <sbrk>
    2914:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2916:	20100593          	li	a1,513
    291a:	00004517          	auipc	a0,0x4
    291e:	53650513          	addi	a0,a0,1334 # 6e50 <malloc+0x1370>
    2922:	00003097          	auipc	ra,0x3
    2926:	dc0080e7          	jalr	-576(ra) # 56e2 <open>
    292a:	84aa                	mv	s1,a0
  unlink("sbrk");
    292c:	00004517          	auipc	a0,0x4
    2930:	52450513          	addi	a0,a0,1316 # 6e50 <malloc+0x1370>
    2934:	00003097          	auipc	ra,0x3
    2938:	dbe080e7          	jalr	-578(ra) # 56f2 <unlink>
  if(fd < 0)  {
    293c:	0404c163          	bltz	s1,297e <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2940:	6605                	lui	a2,0x1
    2942:	85ca                	mv	a1,s2
    2944:	8526                	mv	a0,s1
    2946:	00003097          	auipc	ra,0x3
    294a:	d7c080e7          	jalr	-644(ra) # 56c2 <write>
    294e:	04054663          	bltz	a0,299a <sbrkarg+0xa0>
  close(fd);
    2952:	8526                	mv	a0,s1
    2954:	00003097          	auipc	ra,0x3
    2958:	d76080e7          	jalr	-650(ra) # 56ca <close>
  a = sbrk(PGSIZE);
    295c:	6505                	lui	a0,0x1
    295e:	00003097          	auipc	ra,0x3
    2962:	dcc080e7          	jalr	-564(ra) # 572a <sbrk>
  if(pipe((int *) a) != 0){
    2966:	00003097          	auipc	ra,0x3
    296a:	d4c080e7          	jalr	-692(ra) # 56b2 <pipe>
    296e:	e521                	bnez	a0,29b6 <sbrkarg+0xbc>
}
    2970:	70a2                	ld	ra,40(sp)
    2972:	7402                	ld	s0,32(sp)
    2974:	64e2                	ld	s1,24(sp)
    2976:	6942                	ld	s2,16(sp)
    2978:	69a2                	ld	s3,8(sp)
    297a:	6145                	addi	sp,sp,48
    297c:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    297e:	85ce                	mv	a1,s3
    2980:	00004517          	auipc	a0,0x4
    2984:	4d850513          	addi	a0,a0,1240 # 6e58 <malloc+0x1378>
    2988:	00003097          	auipc	ra,0x3
    298c:	09a080e7          	jalr	154(ra) # 5a22 <printf>
    exit(1);
    2990:	4505                	li	a0,1
    2992:	00003097          	auipc	ra,0x3
    2996:	d10080e7          	jalr	-752(ra) # 56a2 <exit>
    printf("%s: write sbrk failed\n", s);
    299a:	85ce                	mv	a1,s3
    299c:	00004517          	auipc	a0,0x4
    29a0:	4d450513          	addi	a0,a0,1236 # 6e70 <malloc+0x1390>
    29a4:	00003097          	auipc	ra,0x3
    29a8:	07e080e7          	jalr	126(ra) # 5a22 <printf>
    exit(1);
    29ac:	4505                	li	a0,1
    29ae:	00003097          	auipc	ra,0x3
    29b2:	cf4080e7          	jalr	-780(ra) # 56a2 <exit>
    printf("%s: pipe() failed\n", s);
    29b6:	85ce                	mv	a1,s3
    29b8:	00004517          	auipc	a0,0x4
    29bc:	eb850513          	addi	a0,a0,-328 # 6870 <malloc+0xd90>
    29c0:	00003097          	auipc	ra,0x3
    29c4:	062080e7          	jalr	98(ra) # 5a22 <printf>
    exit(1);
    29c8:	4505                	li	a0,1
    29ca:	00003097          	auipc	ra,0x3
    29ce:	cd8080e7          	jalr	-808(ra) # 56a2 <exit>

00000000000029d2 <argptest>:
{
    29d2:	1101                	addi	sp,sp,-32
    29d4:	ec06                	sd	ra,24(sp)
    29d6:	e822                	sd	s0,16(sp)
    29d8:	e426                	sd	s1,8(sp)
    29da:	e04a                	sd	s2,0(sp)
    29dc:	1000                	addi	s0,sp,32
    29de:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    29e0:	4581                	li	a1,0
    29e2:	00004517          	auipc	a0,0x4
    29e6:	4a650513          	addi	a0,a0,1190 # 6e88 <malloc+0x13a8>
    29ea:	00003097          	auipc	ra,0x3
    29ee:	cf8080e7          	jalr	-776(ra) # 56e2 <open>
  if (fd < 0) {
    29f2:	02054b63          	bltz	a0,2a28 <argptest+0x56>
    29f6:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    29f8:	4501                	li	a0,0
    29fa:	00003097          	auipc	ra,0x3
    29fe:	d30080e7          	jalr	-720(ra) # 572a <sbrk>
    2a02:	567d                	li	a2,-1
    2a04:	fff50593          	addi	a1,a0,-1
    2a08:	8526                	mv	a0,s1
    2a0a:	00003097          	auipc	ra,0x3
    2a0e:	cb0080e7          	jalr	-848(ra) # 56ba <read>
  close(fd);
    2a12:	8526                	mv	a0,s1
    2a14:	00003097          	auipc	ra,0x3
    2a18:	cb6080e7          	jalr	-842(ra) # 56ca <close>
}
    2a1c:	60e2                	ld	ra,24(sp)
    2a1e:	6442                	ld	s0,16(sp)
    2a20:	64a2                	ld	s1,8(sp)
    2a22:	6902                	ld	s2,0(sp)
    2a24:	6105                	addi	sp,sp,32
    2a26:	8082                	ret
    printf("%s: open failed\n", s);
    2a28:	85ca                	mv	a1,s2
    2a2a:	00004517          	auipc	a0,0x4
    2a2e:	d5650513          	addi	a0,a0,-682 # 6780 <malloc+0xca0>
    2a32:	00003097          	auipc	ra,0x3
    2a36:	ff0080e7          	jalr	-16(ra) # 5a22 <printf>
    exit(1);
    2a3a:	4505                	li	a0,1
    2a3c:	00003097          	auipc	ra,0x3
    2a40:	c66080e7          	jalr	-922(ra) # 56a2 <exit>

0000000000002a44 <sbrkbugs>:
{
    2a44:	1141                	addi	sp,sp,-16
    2a46:	e406                	sd	ra,8(sp)
    2a48:	e022                	sd	s0,0(sp)
    2a4a:	0800                	addi	s0,sp,16
  int pid = fork();
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	c4e080e7          	jalr	-946(ra) # 569a <fork>
  if(pid < 0){
    2a54:	02054263          	bltz	a0,2a78 <sbrkbugs+0x34>
  if(pid == 0){
    2a58:	ed0d                	bnez	a0,2a92 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2a5a:	00003097          	auipc	ra,0x3
    2a5e:	cd0080e7          	jalr	-816(ra) # 572a <sbrk>
    sbrk(-sz);
    2a62:	40a0053b          	negw	a0,a0
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	cc4080e7          	jalr	-828(ra) # 572a <sbrk>
    exit(0);
    2a6e:	4501                	li	a0,0
    2a70:	00003097          	auipc	ra,0x3
    2a74:	c32080e7          	jalr	-974(ra) # 56a2 <exit>
    printf("fork failed\n");
    2a78:	00004517          	auipc	a0,0x4
    2a7c:	0f850513          	addi	a0,a0,248 # 6b70 <malloc+0x1090>
    2a80:	00003097          	auipc	ra,0x3
    2a84:	fa2080e7          	jalr	-94(ra) # 5a22 <printf>
    exit(1);
    2a88:	4505                	li	a0,1
    2a8a:	00003097          	auipc	ra,0x3
    2a8e:	c18080e7          	jalr	-1000(ra) # 56a2 <exit>
  wait(0);
    2a92:	4501                	li	a0,0
    2a94:	00003097          	auipc	ra,0x3
    2a98:	c16080e7          	jalr	-1002(ra) # 56aa <wait>
  pid = fork();
    2a9c:	00003097          	auipc	ra,0x3
    2aa0:	bfe080e7          	jalr	-1026(ra) # 569a <fork>
  if(pid < 0){
    2aa4:	02054563          	bltz	a0,2ace <sbrkbugs+0x8a>
  if(pid == 0){
    2aa8:	e121                	bnez	a0,2ae8 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	c80080e7          	jalr	-896(ra) # 572a <sbrk>
    sbrk(-(sz - 3500));
    2ab2:	6785                	lui	a5,0x1
    2ab4:	dac7879b          	addiw	a5,a5,-596
    2ab8:	40a7853b          	subw	a0,a5,a0
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	c6e080e7          	jalr	-914(ra) # 572a <sbrk>
    exit(0);
    2ac4:	4501                	li	a0,0
    2ac6:	00003097          	auipc	ra,0x3
    2aca:	bdc080e7          	jalr	-1060(ra) # 56a2 <exit>
    printf("fork failed\n");
    2ace:	00004517          	auipc	a0,0x4
    2ad2:	0a250513          	addi	a0,a0,162 # 6b70 <malloc+0x1090>
    2ad6:	00003097          	auipc	ra,0x3
    2ada:	f4c080e7          	jalr	-180(ra) # 5a22 <printf>
    exit(1);
    2ade:	4505                	li	a0,1
    2ae0:	00003097          	auipc	ra,0x3
    2ae4:	bc2080e7          	jalr	-1086(ra) # 56a2 <exit>
  wait(0);
    2ae8:	4501                	li	a0,0
    2aea:	00003097          	auipc	ra,0x3
    2aee:	bc0080e7          	jalr	-1088(ra) # 56aa <wait>
  pid = fork();
    2af2:	00003097          	auipc	ra,0x3
    2af6:	ba8080e7          	jalr	-1112(ra) # 569a <fork>
  if(pid < 0){
    2afa:	02054a63          	bltz	a0,2b2e <sbrkbugs+0xea>
  if(pid == 0){
    2afe:	e529                	bnez	a0,2b48 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2b00:	00003097          	auipc	ra,0x3
    2b04:	c2a080e7          	jalr	-982(ra) # 572a <sbrk>
    2b08:	67ad                	lui	a5,0xb
    2b0a:	8007879b          	addiw	a5,a5,-2048
    2b0e:	40a7853b          	subw	a0,a5,a0
    2b12:	00003097          	auipc	ra,0x3
    2b16:	c18080e7          	jalr	-1000(ra) # 572a <sbrk>
    sbrk(-10);
    2b1a:	5559                	li	a0,-10
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	c0e080e7          	jalr	-1010(ra) # 572a <sbrk>
    exit(0);
    2b24:	4501                	li	a0,0
    2b26:	00003097          	auipc	ra,0x3
    2b2a:	b7c080e7          	jalr	-1156(ra) # 56a2 <exit>
    printf("fork failed\n");
    2b2e:	00004517          	auipc	a0,0x4
    2b32:	04250513          	addi	a0,a0,66 # 6b70 <malloc+0x1090>
    2b36:	00003097          	auipc	ra,0x3
    2b3a:	eec080e7          	jalr	-276(ra) # 5a22 <printf>
    exit(1);
    2b3e:	4505                	li	a0,1
    2b40:	00003097          	auipc	ra,0x3
    2b44:	b62080e7          	jalr	-1182(ra) # 56a2 <exit>
  wait(0);
    2b48:	4501                	li	a0,0
    2b4a:	00003097          	auipc	ra,0x3
    2b4e:	b60080e7          	jalr	-1184(ra) # 56aa <wait>
  exit(0);
    2b52:	4501                	li	a0,0
    2b54:	00003097          	auipc	ra,0x3
    2b58:	b4e080e7          	jalr	-1202(ra) # 56a2 <exit>

0000000000002b5c <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2b5c:	715d                	addi	sp,sp,-80
    2b5e:	e486                	sd	ra,72(sp)
    2b60:	e0a2                	sd	s0,64(sp)
    2b62:	fc26                	sd	s1,56(sp)
    2b64:	f84a                	sd	s2,48(sp)
    2b66:	f44e                	sd	s3,40(sp)
    2b68:	f052                	sd	s4,32(sp)
    2b6a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2b6c:	4901                	li	s2,0
    2b6e:	49bd                	li	s3,15
    int pid = fork();
    2b70:	00003097          	auipc	ra,0x3
    2b74:	b2a080e7          	jalr	-1238(ra) # 569a <fork>
    2b78:	84aa                	mv	s1,a0
    if(pid < 0){
    2b7a:	02054063          	bltz	a0,2b9a <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2b7e:	c91d                	beqz	a0,2bb4 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2b80:	4501                	li	a0,0
    2b82:	00003097          	auipc	ra,0x3
    2b86:	b28080e7          	jalr	-1240(ra) # 56aa <wait>
  for(int avail = 0; avail < 15; avail++){
    2b8a:	2905                	addiw	s2,s2,1
    2b8c:	ff3912e3          	bne	s2,s3,2b70 <execout+0x14>
    }
  }

  exit(0);
    2b90:	4501                	li	a0,0
    2b92:	00003097          	auipc	ra,0x3
    2b96:	b10080e7          	jalr	-1264(ra) # 56a2 <exit>
      printf("fork failed\n");
    2b9a:	00004517          	auipc	a0,0x4
    2b9e:	fd650513          	addi	a0,a0,-42 # 6b70 <malloc+0x1090>
    2ba2:	00003097          	auipc	ra,0x3
    2ba6:	e80080e7          	jalr	-384(ra) # 5a22 <printf>
      exit(1);
    2baa:	4505                	li	a0,1
    2bac:	00003097          	auipc	ra,0x3
    2bb0:	af6080e7          	jalr	-1290(ra) # 56a2 <exit>
        if(a == 0xffffffffffffffffLL)
    2bb4:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2bb6:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2bb8:	6505                	lui	a0,0x1
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	b70080e7          	jalr	-1168(ra) # 572a <sbrk>
        if(a == 0xffffffffffffffffLL)
    2bc2:	01350763          	beq	a0,s3,2bd0 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2bc6:	6785                	lui	a5,0x1
    2bc8:	953e                	add	a0,a0,a5
    2bca:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x9b>
      while(1){
    2bce:	b7ed                	j	2bb8 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2bd0:	01205a63          	blez	s2,2be4 <execout+0x88>
        sbrk(-4096);
    2bd4:	757d                	lui	a0,0xfffff
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	b54080e7          	jalr	-1196(ra) # 572a <sbrk>
      for(int i = 0; i < avail; i++)
    2bde:	2485                	addiw	s1,s1,1
    2be0:	ff249ae3          	bne	s1,s2,2bd4 <execout+0x78>
      close(1);
    2be4:	4505                	li	a0,1
    2be6:	00003097          	auipc	ra,0x3
    2bea:	ae4080e7          	jalr	-1308(ra) # 56ca <close>
      char *args[] = { "echo", "x", 0 };
    2bee:	00003517          	auipc	a0,0x3
    2bf2:	34250513          	addi	a0,a0,834 # 5f30 <malloc+0x450>
    2bf6:	faa43c23          	sd	a0,-72(s0)
    2bfa:	00003797          	auipc	a5,0x3
    2bfe:	3a678793          	addi	a5,a5,934 # 5fa0 <malloc+0x4c0>
    2c02:	fcf43023          	sd	a5,-64(s0)
    2c06:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c0a:	fb840593          	addi	a1,s0,-72
    2c0e:	00003097          	auipc	ra,0x3
    2c12:	acc080e7          	jalr	-1332(ra) # 56da <exec>
      exit(0);
    2c16:	4501                	li	a0,0
    2c18:	00003097          	auipc	ra,0x3
    2c1c:	a8a080e7          	jalr	-1398(ra) # 56a2 <exit>

0000000000002c20 <fourteen>:
{
    2c20:	1101                	addi	sp,sp,-32
    2c22:	ec06                	sd	ra,24(sp)
    2c24:	e822                	sd	s0,16(sp)
    2c26:	e426                	sd	s1,8(sp)
    2c28:	1000                	addi	s0,sp,32
    2c2a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c2c:	00004517          	auipc	a0,0x4
    2c30:	43450513          	addi	a0,a0,1076 # 7060 <malloc+0x1580>
    2c34:	00003097          	auipc	ra,0x3
    2c38:	ad6080e7          	jalr	-1322(ra) # 570a <mkdir>
    2c3c:	e165                	bnez	a0,2d1c <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c3e:	00004517          	auipc	a0,0x4
    2c42:	27a50513          	addi	a0,a0,634 # 6eb8 <malloc+0x13d8>
    2c46:	00003097          	auipc	ra,0x3
    2c4a:	ac4080e7          	jalr	-1340(ra) # 570a <mkdir>
    2c4e:	e56d                	bnez	a0,2d38 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c50:	20000593          	li	a1,512
    2c54:	00004517          	auipc	a0,0x4
    2c58:	2bc50513          	addi	a0,a0,700 # 6f10 <malloc+0x1430>
    2c5c:	00003097          	auipc	ra,0x3
    2c60:	a86080e7          	jalr	-1402(ra) # 56e2 <open>
  if(fd < 0){
    2c64:	0e054863          	bltz	a0,2d54 <fourteen+0x134>
  close(fd);
    2c68:	00003097          	auipc	ra,0x3
    2c6c:	a62080e7          	jalr	-1438(ra) # 56ca <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c70:	4581                	li	a1,0
    2c72:	00004517          	auipc	a0,0x4
    2c76:	31650513          	addi	a0,a0,790 # 6f88 <malloc+0x14a8>
    2c7a:	00003097          	auipc	ra,0x3
    2c7e:	a68080e7          	jalr	-1432(ra) # 56e2 <open>
  if(fd < 0){
    2c82:	0e054763          	bltz	a0,2d70 <fourteen+0x150>
  close(fd);
    2c86:	00003097          	auipc	ra,0x3
    2c8a:	a44080e7          	jalr	-1468(ra) # 56ca <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2c8e:	00004517          	auipc	a0,0x4
    2c92:	36a50513          	addi	a0,a0,874 # 6ff8 <malloc+0x1518>
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	a74080e7          	jalr	-1420(ra) # 570a <mkdir>
    2c9e:	c57d                	beqz	a0,2d8c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2ca0:	00004517          	auipc	a0,0x4
    2ca4:	3b050513          	addi	a0,a0,944 # 7050 <malloc+0x1570>
    2ca8:	00003097          	auipc	ra,0x3
    2cac:	a62080e7          	jalr	-1438(ra) # 570a <mkdir>
    2cb0:	cd65                	beqz	a0,2da8 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2cb2:	00004517          	auipc	a0,0x4
    2cb6:	39e50513          	addi	a0,a0,926 # 7050 <malloc+0x1570>
    2cba:	00003097          	auipc	ra,0x3
    2cbe:	a38080e7          	jalr	-1480(ra) # 56f2 <unlink>
  unlink("12345678901234/12345678901234");
    2cc2:	00004517          	auipc	a0,0x4
    2cc6:	33650513          	addi	a0,a0,822 # 6ff8 <malloc+0x1518>
    2cca:	00003097          	auipc	ra,0x3
    2cce:	a28080e7          	jalr	-1496(ra) # 56f2 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2cd2:	00004517          	auipc	a0,0x4
    2cd6:	2b650513          	addi	a0,a0,694 # 6f88 <malloc+0x14a8>
    2cda:	00003097          	auipc	ra,0x3
    2cde:	a18080e7          	jalr	-1512(ra) # 56f2 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2ce2:	00004517          	auipc	a0,0x4
    2ce6:	22e50513          	addi	a0,a0,558 # 6f10 <malloc+0x1430>
    2cea:	00003097          	auipc	ra,0x3
    2cee:	a08080e7          	jalr	-1528(ra) # 56f2 <unlink>
  unlink("12345678901234/123456789012345");
    2cf2:	00004517          	auipc	a0,0x4
    2cf6:	1c650513          	addi	a0,a0,454 # 6eb8 <malloc+0x13d8>
    2cfa:	00003097          	auipc	ra,0x3
    2cfe:	9f8080e7          	jalr	-1544(ra) # 56f2 <unlink>
  unlink("12345678901234");
    2d02:	00004517          	auipc	a0,0x4
    2d06:	35e50513          	addi	a0,a0,862 # 7060 <malloc+0x1580>
    2d0a:	00003097          	auipc	ra,0x3
    2d0e:	9e8080e7          	jalr	-1560(ra) # 56f2 <unlink>
}
    2d12:	60e2                	ld	ra,24(sp)
    2d14:	6442                	ld	s0,16(sp)
    2d16:	64a2                	ld	s1,8(sp)
    2d18:	6105                	addi	sp,sp,32
    2d1a:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d1c:	85a6                	mv	a1,s1
    2d1e:	00004517          	auipc	a0,0x4
    2d22:	17250513          	addi	a0,a0,370 # 6e90 <malloc+0x13b0>
    2d26:	00003097          	auipc	ra,0x3
    2d2a:	cfc080e7          	jalr	-772(ra) # 5a22 <printf>
    exit(1);
    2d2e:	4505                	li	a0,1
    2d30:	00003097          	auipc	ra,0x3
    2d34:	972080e7          	jalr	-1678(ra) # 56a2 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d38:	85a6                	mv	a1,s1
    2d3a:	00004517          	auipc	a0,0x4
    2d3e:	19e50513          	addi	a0,a0,414 # 6ed8 <malloc+0x13f8>
    2d42:	00003097          	auipc	ra,0x3
    2d46:	ce0080e7          	jalr	-800(ra) # 5a22 <printf>
    exit(1);
    2d4a:	4505                	li	a0,1
    2d4c:	00003097          	auipc	ra,0x3
    2d50:	956080e7          	jalr	-1706(ra) # 56a2 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2d54:	85a6                	mv	a1,s1
    2d56:	00004517          	auipc	a0,0x4
    2d5a:	1ea50513          	addi	a0,a0,490 # 6f40 <malloc+0x1460>
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	cc4080e7          	jalr	-828(ra) # 5a22 <printf>
    exit(1);
    2d66:	4505                	li	a0,1
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	93a080e7          	jalr	-1734(ra) # 56a2 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2d70:	85a6                	mv	a1,s1
    2d72:	00004517          	auipc	a0,0x4
    2d76:	24650513          	addi	a0,a0,582 # 6fb8 <malloc+0x14d8>
    2d7a:	00003097          	auipc	ra,0x3
    2d7e:	ca8080e7          	jalr	-856(ra) # 5a22 <printf>
    exit(1);
    2d82:	4505                	li	a0,1
    2d84:	00003097          	auipc	ra,0x3
    2d88:	91e080e7          	jalr	-1762(ra) # 56a2 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2d8c:	85a6                	mv	a1,s1
    2d8e:	00004517          	auipc	a0,0x4
    2d92:	28a50513          	addi	a0,a0,650 # 7018 <malloc+0x1538>
    2d96:	00003097          	auipc	ra,0x3
    2d9a:	c8c080e7          	jalr	-884(ra) # 5a22 <printf>
    exit(1);
    2d9e:	4505                	li	a0,1
    2da0:	00003097          	auipc	ra,0x3
    2da4:	902080e7          	jalr	-1790(ra) # 56a2 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2da8:	85a6                	mv	a1,s1
    2daa:	00004517          	auipc	a0,0x4
    2dae:	2c650513          	addi	a0,a0,710 # 7070 <malloc+0x1590>
    2db2:	00003097          	auipc	ra,0x3
    2db6:	c70080e7          	jalr	-912(ra) # 5a22 <printf>
    exit(1);
    2dba:	4505                	li	a0,1
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	8e6080e7          	jalr	-1818(ra) # 56a2 <exit>

0000000000002dc4 <iputtest>:
{
    2dc4:	1101                	addi	sp,sp,-32
    2dc6:	ec06                	sd	ra,24(sp)
    2dc8:	e822                	sd	s0,16(sp)
    2dca:	e426                	sd	s1,8(sp)
    2dcc:	1000                	addi	s0,sp,32
    2dce:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2dd0:	00004517          	auipc	a0,0x4
    2dd4:	2d850513          	addi	a0,a0,728 # 70a8 <malloc+0x15c8>
    2dd8:	00003097          	auipc	ra,0x3
    2ddc:	932080e7          	jalr	-1742(ra) # 570a <mkdir>
    2de0:	04054563          	bltz	a0,2e2a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2de4:	00004517          	auipc	a0,0x4
    2de8:	2c450513          	addi	a0,a0,708 # 70a8 <malloc+0x15c8>
    2dec:	00003097          	auipc	ra,0x3
    2df0:	926080e7          	jalr	-1754(ra) # 5712 <chdir>
    2df4:	04054963          	bltz	a0,2e46 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2df8:	00004517          	auipc	a0,0x4
    2dfc:	2f050513          	addi	a0,a0,752 # 70e8 <malloc+0x1608>
    2e00:	00003097          	auipc	ra,0x3
    2e04:	8f2080e7          	jalr	-1806(ra) # 56f2 <unlink>
    2e08:	04054d63          	bltz	a0,2e62 <iputtest+0x9e>
  if(chdir("/") < 0){
    2e0c:	00004517          	auipc	a0,0x4
    2e10:	30c50513          	addi	a0,a0,780 # 7118 <malloc+0x1638>
    2e14:	00003097          	auipc	ra,0x3
    2e18:	8fe080e7          	jalr	-1794(ra) # 5712 <chdir>
    2e1c:	06054163          	bltz	a0,2e7e <iputtest+0xba>
}
    2e20:	60e2                	ld	ra,24(sp)
    2e22:	6442                	ld	s0,16(sp)
    2e24:	64a2                	ld	s1,8(sp)
    2e26:	6105                	addi	sp,sp,32
    2e28:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e2a:	85a6                	mv	a1,s1
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	28450513          	addi	a0,a0,644 # 70b0 <malloc+0x15d0>
    2e34:	00003097          	auipc	ra,0x3
    2e38:	bee080e7          	jalr	-1042(ra) # 5a22 <printf>
    exit(1);
    2e3c:	4505                	li	a0,1
    2e3e:	00003097          	auipc	ra,0x3
    2e42:	864080e7          	jalr	-1948(ra) # 56a2 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e46:	85a6                	mv	a1,s1
    2e48:	00004517          	auipc	a0,0x4
    2e4c:	28050513          	addi	a0,a0,640 # 70c8 <malloc+0x15e8>
    2e50:	00003097          	auipc	ra,0x3
    2e54:	bd2080e7          	jalr	-1070(ra) # 5a22 <printf>
    exit(1);
    2e58:	4505                	li	a0,1
    2e5a:	00003097          	auipc	ra,0x3
    2e5e:	848080e7          	jalr	-1976(ra) # 56a2 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2e62:	85a6                	mv	a1,s1
    2e64:	00004517          	auipc	a0,0x4
    2e68:	29450513          	addi	a0,a0,660 # 70f8 <malloc+0x1618>
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	bb6080e7          	jalr	-1098(ra) # 5a22 <printf>
    exit(1);
    2e74:	4505                	li	a0,1
    2e76:	00003097          	auipc	ra,0x3
    2e7a:	82c080e7          	jalr	-2004(ra) # 56a2 <exit>
    printf("%s: chdir / failed\n", s);
    2e7e:	85a6                	mv	a1,s1
    2e80:	00004517          	auipc	a0,0x4
    2e84:	2a050513          	addi	a0,a0,672 # 7120 <malloc+0x1640>
    2e88:	00003097          	auipc	ra,0x3
    2e8c:	b9a080e7          	jalr	-1126(ra) # 5a22 <printf>
    exit(1);
    2e90:	4505                	li	a0,1
    2e92:	00003097          	auipc	ra,0x3
    2e96:	810080e7          	jalr	-2032(ra) # 56a2 <exit>

0000000000002e9a <exitiputtest>:
{
    2e9a:	7179                	addi	sp,sp,-48
    2e9c:	f406                	sd	ra,40(sp)
    2e9e:	f022                	sd	s0,32(sp)
    2ea0:	ec26                	sd	s1,24(sp)
    2ea2:	1800                	addi	s0,sp,48
    2ea4:	84aa                	mv	s1,a0
  pid = fork();
    2ea6:	00002097          	auipc	ra,0x2
    2eaa:	7f4080e7          	jalr	2036(ra) # 569a <fork>
  if(pid < 0){
    2eae:	04054663          	bltz	a0,2efa <exitiputtest+0x60>
  if(pid == 0){
    2eb2:	ed45                	bnez	a0,2f6a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2eb4:	00004517          	auipc	a0,0x4
    2eb8:	1f450513          	addi	a0,a0,500 # 70a8 <malloc+0x15c8>
    2ebc:	00003097          	auipc	ra,0x3
    2ec0:	84e080e7          	jalr	-1970(ra) # 570a <mkdir>
    2ec4:	04054963          	bltz	a0,2f16 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ec8:	00004517          	auipc	a0,0x4
    2ecc:	1e050513          	addi	a0,a0,480 # 70a8 <malloc+0x15c8>
    2ed0:	00003097          	auipc	ra,0x3
    2ed4:	842080e7          	jalr	-1982(ra) # 5712 <chdir>
    2ed8:	04054d63          	bltz	a0,2f32 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2edc:	00004517          	auipc	a0,0x4
    2ee0:	20c50513          	addi	a0,a0,524 # 70e8 <malloc+0x1608>
    2ee4:	00003097          	auipc	ra,0x3
    2ee8:	80e080e7          	jalr	-2034(ra) # 56f2 <unlink>
    2eec:	06054163          	bltz	a0,2f4e <exitiputtest+0xb4>
    exit(0);
    2ef0:	4501                	li	a0,0
    2ef2:	00002097          	auipc	ra,0x2
    2ef6:	7b0080e7          	jalr	1968(ra) # 56a2 <exit>
    printf("%s: fork failed\n", s);
    2efa:	85a6                	mv	a1,s1
    2efc:	00004517          	auipc	a0,0x4
    2f00:	86c50513          	addi	a0,a0,-1940 # 6768 <malloc+0xc88>
    2f04:	00003097          	auipc	ra,0x3
    2f08:	b1e080e7          	jalr	-1250(ra) # 5a22 <printf>
    exit(1);
    2f0c:	4505                	li	a0,1
    2f0e:	00002097          	auipc	ra,0x2
    2f12:	794080e7          	jalr	1940(ra) # 56a2 <exit>
      printf("%s: mkdir failed\n", s);
    2f16:	85a6                	mv	a1,s1
    2f18:	00004517          	auipc	a0,0x4
    2f1c:	19850513          	addi	a0,a0,408 # 70b0 <malloc+0x15d0>
    2f20:	00003097          	auipc	ra,0x3
    2f24:	b02080e7          	jalr	-1278(ra) # 5a22 <printf>
      exit(1);
    2f28:	4505                	li	a0,1
    2f2a:	00002097          	auipc	ra,0x2
    2f2e:	778080e7          	jalr	1912(ra) # 56a2 <exit>
      printf("%s: child chdir failed\n", s);
    2f32:	85a6                	mv	a1,s1
    2f34:	00004517          	auipc	a0,0x4
    2f38:	20450513          	addi	a0,a0,516 # 7138 <malloc+0x1658>
    2f3c:	00003097          	auipc	ra,0x3
    2f40:	ae6080e7          	jalr	-1306(ra) # 5a22 <printf>
      exit(1);
    2f44:	4505                	li	a0,1
    2f46:	00002097          	auipc	ra,0x2
    2f4a:	75c080e7          	jalr	1884(ra) # 56a2 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2f4e:	85a6                	mv	a1,s1
    2f50:	00004517          	auipc	a0,0x4
    2f54:	1a850513          	addi	a0,a0,424 # 70f8 <malloc+0x1618>
    2f58:	00003097          	auipc	ra,0x3
    2f5c:	aca080e7          	jalr	-1334(ra) # 5a22 <printf>
      exit(1);
    2f60:	4505                	li	a0,1
    2f62:	00002097          	auipc	ra,0x2
    2f66:	740080e7          	jalr	1856(ra) # 56a2 <exit>
  wait(&xstatus);
    2f6a:	fdc40513          	addi	a0,s0,-36
    2f6e:	00002097          	auipc	ra,0x2
    2f72:	73c080e7          	jalr	1852(ra) # 56aa <wait>
  exit(xstatus);
    2f76:	fdc42503          	lw	a0,-36(s0)
    2f7a:	00002097          	auipc	ra,0x2
    2f7e:	728080e7          	jalr	1832(ra) # 56a2 <exit>

0000000000002f82 <dirtest>:
{
    2f82:	1101                	addi	sp,sp,-32
    2f84:	ec06                	sd	ra,24(sp)
    2f86:	e822                	sd	s0,16(sp)
    2f88:	e426                	sd	s1,8(sp)
    2f8a:	1000                	addi	s0,sp,32
    2f8c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2f8e:	00004517          	auipc	a0,0x4
    2f92:	1c250513          	addi	a0,a0,450 # 7150 <malloc+0x1670>
    2f96:	00002097          	auipc	ra,0x2
    2f9a:	774080e7          	jalr	1908(ra) # 570a <mkdir>
    2f9e:	04054563          	bltz	a0,2fe8 <dirtest+0x66>
  if(chdir("dir0") < 0){
    2fa2:	00004517          	auipc	a0,0x4
    2fa6:	1ae50513          	addi	a0,a0,430 # 7150 <malloc+0x1670>
    2faa:	00002097          	auipc	ra,0x2
    2fae:	768080e7          	jalr	1896(ra) # 5712 <chdir>
    2fb2:	04054963          	bltz	a0,3004 <dirtest+0x82>
  if(chdir("..") < 0){
    2fb6:	00004517          	auipc	a0,0x4
    2fba:	1ba50513          	addi	a0,a0,442 # 7170 <malloc+0x1690>
    2fbe:	00002097          	auipc	ra,0x2
    2fc2:	754080e7          	jalr	1876(ra) # 5712 <chdir>
    2fc6:	04054d63          	bltz	a0,3020 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2fca:	00004517          	auipc	a0,0x4
    2fce:	18650513          	addi	a0,a0,390 # 7150 <malloc+0x1670>
    2fd2:	00002097          	auipc	ra,0x2
    2fd6:	720080e7          	jalr	1824(ra) # 56f2 <unlink>
    2fda:	06054163          	bltz	a0,303c <dirtest+0xba>
}
    2fde:	60e2                	ld	ra,24(sp)
    2fe0:	6442                	ld	s0,16(sp)
    2fe2:	64a2                	ld	s1,8(sp)
    2fe4:	6105                	addi	sp,sp,32
    2fe6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fe8:	85a6                	mv	a1,s1
    2fea:	00004517          	auipc	a0,0x4
    2fee:	0c650513          	addi	a0,a0,198 # 70b0 <malloc+0x15d0>
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	a30080e7          	jalr	-1488(ra) # 5a22 <printf>
    exit(1);
    2ffa:	4505                	li	a0,1
    2ffc:	00002097          	auipc	ra,0x2
    3000:	6a6080e7          	jalr	1702(ra) # 56a2 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3004:	85a6                	mv	a1,s1
    3006:	00004517          	auipc	a0,0x4
    300a:	15250513          	addi	a0,a0,338 # 7158 <malloc+0x1678>
    300e:	00003097          	auipc	ra,0x3
    3012:	a14080e7          	jalr	-1516(ra) # 5a22 <printf>
    exit(1);
    3016:	4505                	li	a0,1
    3018:	00002097          	auipc	ra,0x2
    301c:	68a080e7          	jalr	1674(ra) # 56a2 <exit>
    printf("%s: chdir .. failed\n", s);
    3020:	85a6                	mv	a1,s1
    3022:	00004517          	auipc	a0,0x4
    3026:	15650513          	addi	a0,a0,342 # 7178 <malloc+0x1698>
    302a:	00003097          	auipc	ra,0x3
    302e:	9f8080e7          	jalr	-1544(ra) # 5a22 <printf>
    exit(1);
    3032:	4505                	li	a0,1
    3034:	00002097          	auipc	ra,0x2
    3038:	66e080e7          	jalr	1646(ra) # 56a2 <exit>
    printf("%s: unlink dir0 failed\n", s);
    303c:	85a6                	mv	a1,s1
    303e:	00004517          	auipc	a0,0x4
    3042:	15250513          	addi	a0,a0,338 # 7190 <malloc+0x16b0>
    3046:	00003097          	auipc	ra,0x3
    304a:	9dc080e7          	jalr	-1572(ra) # 5a22 <printf>
    exit(1);
    304e:	4505                	li	a0,1
    3050:	00002097          	auipc	ra,0x2
    3054:	652080e7          	jalr	1618(ra) # 56a2 <exit>

0000000000003058 <subdir>:
{
    3058:	1101                	addi	sp,sp,-32
    305a:	ec06                	sd	ra,24(sp)
    305c:	e822                	sd	s0,16(sp)
    305e:	e426                	sd	s1,8(sp)
    3060:	e04a                	sd	s2,0(sp)
    3062:	1000                	addi	s0,sp,32
    3064:	892a                	mv	s2,a0
  unlink("ff");
    3066:	00004517          	auipc	a0,0x4
    306a:	27250513          	addi	a0,a0,626 # 72d8 <malloc+0x17f8>
    306e:	00002097          	auipc	ra,0x2
    3072:	684080e7          	jalr	1668(ra) # 56f2 <unlink>
  if(mkdir("dd") != 0){
    3076:	00004517          	auipc	a0,0x4
    307a:	13250513          	addi	a0,a0,306 # 71a8 <malloc+0x16c8>
    307e:	00002097          	auipc	ra,0x2
    3082:	68c080e7          	jalr	1676(ra) # 570a <mkdir>
    3086:	38051663          	bnez	a0,3412 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    308a:	20200593          	li	a1,514
    308e:	00004517          	auipc	a0,0x4
    3092:	13a50513          	addi	a0,a0,314 # 71c8 <malloc+0x16e8>
    3096:	00002097          	auipc	ra,0x2
    309a:	64c080e7          	jalr	1612(ra) # 56e2 <open>
    309e:	84aa                	mv	s1,a0
  if(fd < 0){
    30a0:	38054763          	bltz	a0,342e <subdir+0x3d6>
  write(fd, "ff", 2);
    30a4:	4609                	li	a2,2
    30a6:	00004597          	auipc	a1,0x4
    30aa:	23258593          	addi	a1,a1,562 # 72d8 <malloc+0x17f8>
    30ae:	00002097          	auipc	ra,0x2
    30b2:	614080e7          	jalr	1556(ra) # 56c2 <write>
  close(fd);
    30b6:	8526                	mv	a0,s1
    30b8:	00002097          	auipc	ra,0x2
    30bc:	612080e7          	jalr	1554(ra) # 56ca <close>
  if(unlink("dd") >= 0){
    30c0:	00004517          	auipc	a0,0x4
    30c4:	0e850513          	addi	a0,a0,232 # 71a8 <malloc+0x16c8>
    30c8:	00002097          	auipc	ra,0x2
    30cc:	62a080e7          	jalr	1578(ra) # 56f2 <unlink>
    30d0:	36055d63          	bgez	a0,344a <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    30d4:	00004517          	auipc	a0,0x4
    30d8:	14c50513          	addi	a0,a0,332 # 7220 <malloc+0x1740>
    30dc:	00002097          	auipc	ra,0x2
    30e0:	62e080e7          	jalr	1582(ra) # 570a <mkdir>
    30e4:	38051163          	bnez	a0,3466 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    30e8:	20200593          	li	a1,514
    30ec:	00004517          	auipc	a0,0x4
    30f0:	15c50513          	addi	a0,a0,348 # 7248 <malloc+0x1768>
    30f4:	00002097          	auipc	ra,0x2
    30f8:	5ee080e7          	jalr	1518(ra) # 56e2 <open>
    30fc:	84aa                	mv	s1,a0
  if(fd < 0){
    30fe:	38054263          	bltz	a0,3482 <subdir+0x42a>
  write(fd, "FF", 2);
    3102:	4609                	li	a2,2
    3104:	00004597          	auipc	a1,0x4
    3108:	17458593          	addi	a1,a1,372 # 7278 <malloc+0x1798>
    310c:	00002097          	auipc	ra,0x2
    3110:	5b6080e7          	jalr	1462(ra) # 56c2 <write>
  close(fd);
    3114:	8526                	mv	a0,s1
    3116:	00002097          	auipc	ra,0x2
    311a:	5b4080e7          	jalr	1460(ra) # 56ca <close>
  fd = open("dd/dd/../ff", 0);
    311e:	4581                	li	a1,0
    3120:	00004517          	auipc	a0,0x4
    3124:	16050513          	addi	a0,a0,352 # 7280 <malloc+0x17a0>
    3128:	00002097          	auipc	ra,0x2
    312c:	5ba080e7          	jalr	1466(ra) # 56e2 <open>
    3130:	84aa                	mv	s1,a0
  if(fd < 0){
    3132:	36054663          	bltz	a0,349e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3136:	660d                	lui	a2,0x3
    3138:	00009597          	auipc	a1,0x9
    313c:	a4058593          	addi	a1,a1,-1472 # bb78 <buf>
    3140:	00002097          	auipc	ra,0x2
    3144:	57a080e7          	jalr	1402(ra) # 56ba <read>
  if(cc != 2 || buf[0] != 'f'){
    3148:	4789                	li	a5,2
    314a:	36f51863          	bne	a0,a5,34ba <subdir+0x462>
    314e:	00009717          	auipc	a4,0x9
    3152:	a2a74703          	lbu	a4,-1494(a4) # bb78 <buf>
    3156:	06600793          	li	a5,102
    315a:	36f71063          	bne	a4,a5,34ba <subdir+0x462>
  close(fd);
    315e:	8526                	mv	a0,s1
    3160:	00002097          	auipc	ra,0x2
    3164:	56a080e7          	jalr	1386(ra) # 56ca <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3168:	00004597          	auipc	a1,0x4
    316c:	16858593          	addi	a1,a1,360 # 72d0 <malloc+0x17f0>
    3170:	00004517          	auipc	a0,0x4
    3174:	0d850513          	addi	a0,a0,216 # 7248 <malloc+0x1768>
    3178:	00002097          	auipc	ra,0x2
    317c:	58a080e7          	jalr	1418(ra) # 5702 <link>
    3180:	34051b63          	bnez	a0,34d6 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3184:	00004517          	auipc	a0,0x4
    3188:	0c450513          	addi	a0,a0,196 # 7248 <malloc+0x1768>
    318c:	00002097          	auipc	ra,0x2
    3190:	566080e7          	jalr	1382(ra) # 56f2 <unlink>
    3194:	34051f63          	bnez	a0,34f2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3198:	4581                	li	a1,0
    319a:	00004517          	auipc	a0,0x4
    319e:	0ae50513          	addi	a0,a0,174 # 7248 <malloc+0x1768>
    31a2:	00002097          	auipc	ra,0x2
    31a6:	540080e7          	jalr	1344(ra) # 56e2 <open>
    31aa:	36055263          	bgez	a0,350e <subdir+0x4b6>
  if(chdir("dd") != 0){
    31ae:	00004517          	auipc	a0,0x4
    31b2:	ffa50513          	addi	a0,a0,-6 # 71a8 <malloc+0x16c8>
    31b6:	00002097          	auipc	ra,0x2
    31ba:	55c080e7          	jalr	1372(ra) # 5712 <chdir>
    31be:	36051663          	bnez	a0,352a <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    31c2:	00004517          	auipc	a0,0x4
    31c6:	1a650513          	addi	a0,a0,422 # 7368 <malloc+0x1888>
    31ca:	00002097          	auipc	ra,0x2
    31ce:	548080e7          	jalr	1352(ra) # 5712 <chdir>
    31d2:	36051a63          	bnez	a0,3546 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    31d6:	00004517          	auipc	a0,0x4
    31da:	1c250513          	addi	a0,a0,450 # 7398 <malloc+0x18b8>
    31de:	00002097          	auipc	ra,0x2
    31e2:	534080e7          	jalr	1332(ra) # 5712 <chdir>
    31e6:	36051e63          	bnez	a0,3562 <subdir+0x50a>
  if(chdir("./..") != 0){
    31ea:	00004517          	auipc	a0,0x4
    31ee:	1de50513          	addi	a0,a0,478 # 73c8 <malloc+0x18e8>
    31f2:	00002097          	auipc	ra,0x2
    31f6:	520080e7          	jalr	1312(ra) # 5712 <chdir>
    31fa:	38051263          	bnez	a0,357e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    31fe:	4581                	li	a1,0
    3200:	00004517          	auipc	a0,0x4
    3204:	0d050513          	addi	a0,a0,208 # 72d0 <malloc+0x17f0>
    3208:	00002097          	auipc	ra,0x2
    320c:	4da080e7          	jalr	1242(ra) # 56e2 <open>
    3210:	84aa                	mv	s1,a0
  if(fd < 0){
    3212:	38054463          	bltz	a0,359a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3216:	660d                	lui	a2,0x3
    3218:	00009597          	auipc	a1,0x9
    321c:	96058593          	addi	a1,a1,-1696 # bb78 <buf>
    3220:	00002097          	auipc	ra,0x2
    3224:	49a080e7          	jalr	1178(ra) # 56ba <read>
    3228:	4789                	li	a5,2
    322a:	38f51663          	bne	a0,a5,35b6 <subdir+0x55e>
  close(fd);
    322e:	8526                	mv	a0,s1
    3230:	00002097          	auipc	ra,0x2
    3234:	49a080e7          	jalr	1178(ra) # 56ca <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3238:	4581                	li	a1,0
    323a:	00004517          	auipc	a0,0x4
    323e:	00e50513          	addi	a0,a0,14 # 7248 <malloc+0x1768>
    3242:	00002097          	auipc	ra,0x2
    3246:	4a0080e7          	jalr	1184(ra) # 56e2 <open>
    324a:	38055463          	bgez	a0,35d2 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    324e:	20200593          	li	a1,514
    3252:	00004517          	auipc	a0,0x4
    3256:	20650513          	addi	a0,a0,518 # 7458 <malloc+0x1978>
    325a:	00002097          	auipc	ra,0x2
    325e:	488080e7          	jalr	1160(ra) # 56e2 <open>
    3262:	38055663          	bgez	a0,35ee <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3266:	20200593          	li	a1,514
    326a:	00004517          	auipc	a0,0x4
    326e:	21e50513          	addi	a0,a0,542 # 7488 <malloc+0x19a8>
    3272:	00002097          	auipc	ra,0x2
    3276:	470080e7          	jalr	1136(ra) # 56e2 <open>
    327a:	38055863          	bgez	a0,360a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    327e:	20000593          	li	a1,512
    3282:	00004517          	auipc	a0,0x4
    3286:	f2650513          	addi	a0,a0,-218 # 71a8 <malloc+0x16c8>
    328a:	00002097          	auipc	ra,0x2
    328e:	458080e7          	jalr	1112(ra) # 56e2 <open>
    3292:	38055a63          	bgez	a0,3626 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3296:	4589                	li	a1,2
    3298:	00004517          	auipc	a0,0x4
    329c:	f1050513          	addi	a0,a0,-240 # 71a8 <malloc+0x16c8>
    32a0:	00002097          	auipc	ra,0x2
    32a4:	442080e7          	jalr	1090(ra) # 56e2 <open>
    32a8:	38055d63          	bgez	a0,3642 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    32ac:	4585                	li	a1,1
    32ae:	00004517          	auipc	a0,0x4
    32b2:	efa50513          	addi	a0,a0,-262 # 71a8 <malloc+0x16c8>
    32b6:	00002097          	auipc	ra,0x2
    32ba:	42c080e7          	jalr	1068(ra) # 56e2 <open>
    32be:	3a055063          	bgez	a0,365e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    32c2:	00004597          	auipc	a1,0x4
    32c6:	25658593          	addi	a1,a1,598 # 7518 <malloc+0x1a38>
    32ca:	00004517          	auipc	a0,0x4
    32ce:	18e50513          	addi	a0,a0,398 # 7458 <malloc+0x1978>
    32d2:	00002097          	auipc	ra,0x2
    32d6:	430080e7          	jalr	1072(ra) # 5702 <link>
    32da:	3a050063          	beqz	a0,367a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    32de:	00004597          	auipc	a1,0x4
    32e2:	23a58593          	addi	a1,a1,570 # 7518 <malloc+0x1a38>
    32e6:	00004517          	auipc	a0,0x4
    32ea:	1a250513          	addi	a0,a0,418 # 7488 <malloc+0x19a8>
    32ee:	00002097          	auipc	ra,0x2
    32f2:	414080e7          	jalr	1044(ra) # 5702 <link>
    32f6:	3a050063          	beqz	a0,3696 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    32fa:	00004597          	auipc	a1,0x4
    32fe:	fd658593          	addi	a1,a1,-42 # 72d0 <malloc+0x17f0>
    3302:	00004517          	auipc	a0,0x4
    3306:	ec650513          	addi	a0,a0,-314 # 71c8 <malloc+0x16e8>
    330a:	00002097          	auipc	ra,0x2
    330e:	3f8080e7          	jalr	1016(ra) # 5702 <link>
    3312:	3a050063          	beqz	a0,36b2 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3316:	00004517          	auipc	a0,0x4
    331a:	14250513          	addi	a0,a0,322 # 7458 <malloc+0x1978>
    331e:	00002097          	auipc	ra,0x2
    3322:	3ec080e7          	jalr	1004(ra) # 570a <mkdir>
    3326:	3a050463          	beqz	a0,36ce <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    332a:	00004517          	auipc	a0,0x4
    332e:	15e50513          	addi	a0,a0,350 # 7488 <malloc+0x19a8>
    3332:	00002097          	auipc	ra,0x2
    3336:	3d8080e7          	jalr	984(ra) # 570a <mkdir>
    333a:	3a050863          	beqz	a0,36ea <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    333e:	00004517          	auipc	a0,0x4
    3342:	f9250513          	addi	a0,a0,-110 # 72d0 <malloc+0x17f0>
    3346:	00002097          	auipc	ra,0x2
    334a:	3c4080e7          	jalr	964(ra) # 570a <mkdir>
    334e:	3a050c63          	beqz	a0,3706 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3352:	00004517          	auipc	a0,0x4
    3356:	13650513          	addi	a0,a0,310 # 7488 <malloc+0x19a8>
    335a:	00002097          	auipc	ra,0x2
    335e:	398080e7          	jalr	920(ra) # 56f2 <unlink>
    3362:	3c050063          	beqz	a0,3722 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3366:	00004517          	auipc	a0,0x4
    336a:	0f250513          	addi	a0,a0,242 # 7458 <malloc+0x1978>
    336e:	00002097          	auipc	ra,0x2
    3372:	384080e7          	jalr	900(ra) # 56f2 <unlink>
    3376:	3c050463          	beqz	a0,373e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    337a:	00004517          	auipc	a0,0x4
    337e:	e4e50513          	addi	a0,a0,-434 # 71c8 <malloc+0x16e8>
    3382:	00002097          	auipc	ra,0x2
    3386:	390080e7          	jalr	912(ra) # 5712 <chdir>
    338a:	3c050863          	beqz	a0,375a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    338e:	00004517          	auipc	a0,0x4
    3392:	2da50513          	addi	a0,a0,730 # 7668 <malloc+0x1b88>
    3396:	00002097          	auipc	ra,0x2
    339a:	37c080e7          	jalr	892(ra) # 5712 <chdir>
    339e:	3c050c63          	beqz	a0,3776 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    33a2:	00004517          	auipc	a0,0x4
    33a6:	f2e50513          	addi	a0,a0,-210 # 72d0 <malloc+0x17f0>
    33aa:	00002097          	auipc	ra,0x2
    33ae:	348080e7          	jalr	840(ra) # 56f2 <unlink>
    33b2:	3e051063          	bnez	a0,3792 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    33b6:	00004517          	auipc	a0,0x4
    33ba:	e1250513          	addi	a0,a0,-494 # 71c8 <malloc+0x16e8>
    33be:	00002097          	auipc	ra,0x2
    33c2:	334080e7          	jalr	820(ra) # 56f2 <unlink>
    33c6:	3e051463          	bnez	a0,37ae <subdir+0x756>
  if(unlink("dd") == 0){
    33ca:	00004517          	auipc	a0,0x4
    33ce:	dde50513          	addi	a0,a0,-546 # 71a8 <malloc+0x16c8>
    33d2:	00002097          	auipc	ra,0x2
    33d6:	320080e7          	jalr	800(ra) # 56f2 <unlink>
    33da:	3e050863          	beqz	a0,37ca <subdir+0x772>
  if(unlink("dd/dd") < 0){
    33de:	00004517          	auipc	a0,0x4
    33e2:	2fa50513          	addi	a0,a0,762 # 76d8 <malloc+0x1bf8>
    33e6:	00002097          	auipc	ra,0x2
    33ea:	30c080e7          	jalr	780(ra) # 56f2 <unlink>
    33ee:	3e054c63          	bltz	a0,37e6 <subdir+0x78e>
  if(unlink("dd") < 0){
    33f2:	00004517          	auipc	a0,0x4
    33f6:	db650513          	addi	a0,a0,-586 # 71a8 <malloc+0x16c8>
    33fa:	00002097          	auipc	ra,0x2
    33fe:	2f8080e7          	jalr	760(ra) # 56f2 <unlink>
    3402:	40054063          	bltz	a0,3802 <subdir+0x7aa>
}
    3406:	60e2                	ld	ra,24(sp)
    3408:	6442                	ld	s0,16(sp)
    340a:	64a2                	ld	s1,8(sp)
    340c:	6902                	ld	s2,0(sp)
    340e:	6105                	addi	sp,sp,32
    3410:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3412:	85ca                	mv	a1,s2
    3414:	00004517          	auipc	a0,0x4
    3418:	d9c50513          	addi	a0,a0,-612 # 71b0 <malloc+0x16d0>
    341c:	00002097          	auipc	ra,0x2
    3420:	606080e7          	jalr	1542(ra) # 5a22 <printf>
    exit(1);
    3424:	4505                	li	a0,1
    3426:	00002097          	auipc	ra,0x2
    342a:	27c080e7          	jalr	636(ra) # 56a2 <exit>
    printf("%s: create dd/ff failed\n", s);
    342e:	85ca                	mv	a1,s2
    3430:	00004517          	auipc	a0,0x4
    3434:	da050513          	addi	a0,a0,-608 # 71d0 <malloc+0x16f0>
    3438:	00002097          	auipc	ra,0x2
    343c:	5ea080e7          	jalr	1514(ra) # 5a22 <printf>
    exit(1);
    3440:	4505                	li	a0,1
    3442:	00002097          	auipc	ra,0x2
    3446:	260080e7          	jalr	608(ra) # 56a2 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    344a:	85ca                	mv	a1,s2
    344c:	00004517          	auipc	a0,0x4
    3450:	da450513          	addi	a0,a0,-604 # 71f0 <malloc+0x1710>
    3454:	00002097          	auipc	ra,0x2
    3458:	5ce080e7          	jalr	1486(ra) # 5a22 <printf>
    exit(1);
    345c:	4505                	li	a0,1
    345e:	00002097          	auipc	ra,0x2
    3462:	244080e7          	jalr	580(ra) # 56a2 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3466:	85ca                	mv	a1,s2
    3468:	00004517          	auipc	a0,0x4
    346c:	dc050513          	addi	a0,a0,-576 # 7228 <malloc+0x1748>
    3470:	00002097          	auipc	ra,0x2
    3474:	5b2080e7          	jalr	1458(ra) # 5a22 <printf>
    exit(1);
    3478:	4505                	li	a0,1
    347a:	00002097          	auipc	ra,0x2
    347e:	228080e7          	jalr	552(ra) # 56a2 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3482:	85ca                	mv	a1,s2
    3484:	00004517          	auipc	a0,0x4
    3488:	dd450513          	addi	a0,a0,-556 # 7258 <malloc+0x1778>
    348c:	00002097          	auipc	ra,0x2
    3490:	596080e7          	jalr	1430(ra) # 5a22 <printf>
    exit(1);
    3494:	4505                	li	a0,1
    3496:	00002097          	auipc	ra,0x2
    349a:	20c080e7          	jalr	524(ra) # 56a2 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    349e:	85ca                	mv	a1,s2
    34a0:	00004517          	auipc	a0,0x4
    34a4:	df050513          	addi	a0,a0,-528 # 7290 <malloc+0x17b0>
    34a8:	00002097          	auipc	ra,0x2
    34ac:	57a080e7          	jalr	1402(ra) # 5a22 <printf>
    exit(1);
    34b0:	4505                	li	a0,1
    34b2:	00002097          	auipc	ra,0x2
    34b6:	1f0080e7          	jalr	496(ra) # 56a2 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    34ba:	85ca                	mv	a1,s2
    34bc:	00004517          	auipc	a0,0x4
    34c0:	df450513          	addi	a0,a0,-524 # 72b0 <malloc+0x17d0>
    34c4:	00002097          	auipc	ra,0x2
    34c8:	55e080e7          	jalr	1374(ra) # 5a22 <printf>
    exit(1);
    34cc:	4505                	li	a0,1
    34ce:	00002097          	auipc	ra,0x2
    34d2:	1d4080e7          	jalr	468(ra) # 56a2 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    34d6:	85ca                	mv	a1,s2
    34d8:	00004517          	auipc	a0,0x4
    34dc:	e0850513          	addi	a0,a0,-504 # 72e0 <malloc+0x1800>
    34e0:	00002097          	auipc	ra,0x2
    34e4:	542080e7          	jalr	1346(ra) # 5a22 <printf>
    exit(1);
    34e8:	4505                	li	a0,1
    34ea:	00002097          	auipc	ra,0x2
    34ee:	1b8080e7          	jalr	440(ra) # 56a2 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    34f2:	85ca                	mv	a1,s2
    34f4:	00004517          	auipc	a0,0x4
    34f8:	e1450513          	addi	a0,a0,-492 # 7308 <malloc+0x1828>
    34fc:	00002097          	auipc	ra,0x2
    3500:	526080e7          	jalr	1318(ra) # 5a22 <printf>
    exit(1);
    3504:	4505                	li	a0,1
    3506:	00002097          	auipc	ra,0x2
    350a:	19c080e7          	jalr	412(ra) # 56a2 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    350e:	85ca                	mv	a1,s2
    3510:	00004517          	auipc	a0,0x4
    3514:	e1850513          	addi	a0,a0,-488 # 7328 <malloc+0x1848>
    3518:	00002097          	auipc	ra,0x2
    351c:	50a080e7          	jalr	1290(ra) # 5a22 <printf>
    exit(1);
    3520:	4505                	li	a0,1
    3522:	00002097          	auipc	ra,0x2
    3526:	180080e7          	jalr	384(ra) # 56a2 <exit>
    printf("%s: chdir dd failed\n", s);
    352a:	85ca                	mv	a1,s2
    352c:	00004517          	auipc	a0,0x4
    3530:	e2450513          	addi	a0,a0,-476 # 7350 <malloc+0x1870>
    3534:	00002097          	auipc	ra,0x2
    3538:	4ee080e7          	jalr	1262(ra) # 5a22 <printf>
    exit(1);
    353c:	4505                	li	a0,1
    353e:	00002097          	auipc	ra,0x2
    3542:	164080e7          	jalr	356(ra) # 56a2 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3546:	85ca                	mv	a1,s2
    3548:	00004517          	auipc	a0,0x4
    354c:	e3050513          	addi	a0,a0,-464 # 7378 <malloc+0x1898>
    3550:	00002097          	auipc	ra,0x2
    3554:	4d2080e7          	jalr	1234(ra) # 5a22 <printf>
    exit(1);
    3558:	4505                	li	a0,1
    355a:	00002097          	auipc	ra,0x2
    355e:	148080e7          	jalr	328(ra) # 56a2 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3562:	85ca                	mv	a1,s2
    3564:	00004517          	auipc	a0,0x4
    3568:	e4450513          	addi	a0,a0,-444 # 73a8 <malloc+0x18c8>
    356c:	00002097          	auipc	ra,0x2
    3570:	4b6080e7          	jalr	1206(ra) # 5a22 <printf>
    exit(1);
    3574:	4505                	li	a0,1
    3576:	00002097          	auipc	ra,0x2
    357a:	12c080e7          	jalr	300(ra) # 56a2 <exit>
    printf("%s: chdir ./.. failed\n", s);
    357e:	85ca                	mv	a1,s2
    3580:	00004517          	auipc	a0,0x4
    3584:	e5050513          	addi	a0,a0,-432 # 73d0 <malloc+0x18f0>
    3588:	00002097          	auipc	ra,0x2
    358c:	49a080e7          	jalr	1178(ra) # 5a22 <printf>
    exit(1);
    3590:	4505                	li	a0,1
    3592:	00002097          	auipc	ra,0x2
    3596:	110080e7          	jalr	272(ra) # 56a2 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    359a:	85ca                	mv	a1,s2
    359c:	00004517          	auipc	a0,0x4
    35a0:	e4c50513          	addi	a0,a0,-436 # 73e8 <malloc+0x1908>
    35a4:	00002097          	auipc	ra,0x2
    35a8:	47e080e7          	jalr	1150(ra) # 5a22 <printf>
    exit(1);
    35ac:	4505                	li	a0,1
    35ae:	00002097          	auipc	ra,0x2
    35b2:	0f4080e7          	jalr	244(ra) # 56a2 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    35b6:	85ca                	mv	a1,s2
    35b8:	00004517          	auipc	a0,0x4
    35bc:	e5050513          	addi	a0,a0,-432 # 7408 <malloc+0x1928>
    35c0:	00002097          	auipc	ra,0x2
    35c4:	462080e7          	jalr	1122(ra) # 5a22 <printf>
    exit(1);
    35c8:	4505                	li	a0,1
    35ca:	00002097          	auipc	ra,0x2
    35ce:	0d8080e7          	jalr	216(ra) # 56a2 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    35d2:	85ca                	mv	a1,s2
    35d4:	00004517          	auipc	a0,0x4
    35d8:	e5450513          	addi	a0,a0,-428 # 7428 <malloc+0x1948>
    35dc:	00002097          	auipc	ra,0x2
    35e0:	446080e7          	jalr	1094(ra) # 5a22 <printf>
    exit(1);
    35e4:	4505                	li	a0,1
    35e6:	00002097          	auipc	ra,0x2
    35ea:	0bc080e7          	jalr	188(ra) # 56a2 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    35ee:	85ca                	mv	a1,s2
    35f0:	00004517          	auipc	a0,0x4
    35f4:	e7850513          	addi	a0,a0,-392 # 7468 <malloc+0x1988>
    35f8:	00002097          	auipc	ra,0x2
    35fc:	42a080e7          	jalr	1066(ra) # 5a22 <printf>
    exit(1);
    3600:	4505                	li	a0,1
    3602:	00002097          	auipc	ra,0x2
    3606:	0a0080e7          	jalr	160(ra) # 56a2 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    360a:	85ca                	mv	a1,s2
    360c:	00004517          	auipc	a0,0x4
    3610:	e8c50513          	addi	a0,a0,-372 # 7498 <malloc+0x19b8>
    3614:	00002097          	auipc	ra,0x2
    3618:	40e080e7          	jalr	1038(ra) # 5a22 <printf>
    exit(1);
    361c:	4505                	li	a0,1
    361e:	00002097          	auipc	ra,0x2
    3622:	084080e7          	jalr	132(ra) # 56a2 <exit>
    printf("%s: create dd succeeded!\n", s);
    3626:	85ca                	mv	a1,s2
    3628:	00004517          	auipc	a0,0x4
    362c:	e9050513          	addi	a0,a0,-368 # 74b8 <malloc+0x19d8>
    3630:	00002097          	auipc	ra,0x2
    3634:	3f2080e7          	jalr	1010(ra) # 5a22 <printf>
    exit(1);
    3638:	4505                	li	a0,1
    363a:	00002097          	auipc	ra,0x2
    363e:	068080e7          	jalr	104(ra) # 56a2 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3642:	85ca                	mv	a1,s2
    3644:	00004517          	auipc	a0,0x4
    3648:	e9450513          	addi	a0,a0,-364 # 74d8 <malloc+0x19f8>
    364c:	00002097          	auipc	ra,0x2
    3650:	3d6080e7          	jalr	982(ra) # 5a22 <printf>
    exit(1);
    3654:	4505                	li	a0,1
    3656:	00002097          	auipc	ra,0x2
    365a:	04c080e7          	jalr	76(ra) # 56a2 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    365e:	85ca                	mv	a1,s2
    3660:	00004517          	auipc	a0,0x4
    3664:	e9850513          	addi	a0,a0,-360 # 74f8 <malloc+0x1a18>
    3668:	00002097          	auipc	ra,0x2
    366c:	3ba080e7          	jalr	954(ra) # 5a22 <printf>
    exit(1);
    3670:	4505                	li	a0,1
    3672:	00002097          	auipc	ra,0x2
    3676:	030080e7          	jalr	48(ra) # 56a2 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    367a:	85ca                	mv	a1,s2
    367c:	00004517          	auipc	a0,0x4
    3680:	eac50513          	addi	a0,a0,-340 # 7528 <malloc+0x1a48>
    3684:	00002097          	auipc	ra,0x2
    3688:	39e080e7          	jalr	926(ra) # 5a22 <printf>
    exit(1);
    368c:	4505                	li	a0,1
    368e:	00002097          	auipc	ra,0x2
    3692:	014080e7          	jalr	20(ra) # 56a2 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3696:	85ca                	mv	a1,s2
    3698:	00004517          	auipc	a0,0x4
    369c:	eb850513          	addi	a0,a0,-328 # 7550 <malloc+0x1a70>
    36a0:	00002097          	auipc	ra,0x2
    36a4:	382080e7          	jalr	898(ra) # 5a22 <printf>
    exit(1);
    36a8:	4505                	li	a0,1
    36aa:	00002097          	auipc	ra,0x2
    36ae:	ff8080e7          	jalr	-8(ra) # 56a2 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    36b2:	85ca                	mv	a1,s2
    36b4:	00004517          	auipc	a0,0x4
    36b8:	ec450513          	addi	a0,a0,-316 # 7578 <malloc+0x1a98>
    36bc:	00002097          	auipc	ra,0x2
    36c0:	366080e7          	jalr	870(ra) # 5a22 <printf>
    exit(1);
    36c4:	4505                	li	a0,1
    36c6:	00002097          	auipc	ra,0x2
    36ca:	fdc080e7          	jalr	-36(ra) # 56a2 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    36ce:	85ca                	mv	a1,s2
    36d0:	00004517          	auipc	a0,0x4
    36d4:	ed050513          	addi	a0,a0,-304 # 75a0 <malloc+0x1ac0>
    36d8:	00002097          	auipc	ra,0x2
    36dc:	34a080e7          	jalr	842(ra) # 5a22 <printf>
    exit(1);
    36e0:	4505                	li	a0,1
    36e2:	00002097          	auipc	ra,0x2
    36e6:	fc0080e7          	jalr	-64(ra) # 56a2 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    36ea:	85ca                	mv	a1,s2
    36ec:	00004517          	auipc	a0,0x4
    36f0:	ed450513          	addi	a0,a0,-300 # 75c0 <malloc+0x1ae0>
    36f4:	00002097          	auipc	ra,0x2
    36f8:	32e080e7          	jalr	814(ra) # 5a22 <printf>
    exit(1);
    36fc:	4505                	li	a0,1
    36fe:	00002097          	auipc	ra,0x2
    3702:	fa4080e7          	jalr	-92(ra) # 56a2 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3706:	85ca                	mv	a1,s2
    3708:	00004517          	auipc	a0,0x4
    370c:	ed850513          	addi	a0,a0,-296 # 75e0 <malloc+0x1b00>
    3710:	00002097          	auipc	ra,0x2
    3714:	312080e7          	jalr	786(ra) # 5a22 <printf>
    exit(1);
    3718:	4505                	li	a0,1
    371a:	00002097          	auipc	ra,0x2
    371e:	f88080e7          	jalr	-120(ra) # 56a2 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3722:	85ca                	mv	a1,s2
    3724:	00004517          	auipc	a0,0x4
    3728:	ee450513          	addi	a0,a0,-284 # 7608 <malloc+0x1b28>
    372c:	00002097          	auipc	ra,0x2
    3730:	2f6080e7          	jalr	758(ra) # 5a22 <printf>
    exit(1);
    3734:	4505                	li	a0,1
    3736:	00002097          	auipc	ra,0x2
    373a:	f6c080e7          	jalr	-148(ra) # 56a2 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    373e:	85ca                	mv	a1,s2
    3740:	00004517          	auipc	a0,0x4
    3744:	ee850513          	addi	a0,a0,-280 # 7628 <malloc+0x1b48>
    3748:	00002097          	auipc	ra,0x2
    374c:	2da080e7          	jalr	730(ra) # 5a22 <printf>
    exit(1);
    3750:	4505                	li	a0,1
    3752:	00002097          	auipc	ra,0x2
    3756:	f50080e7          	jalr	-176(ra) # 56a2 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    375a:	85ca                	mv	a1,s2
    375c:	00004517          	auipc	a0,0x4
    3760:	eec50513          	addi	a0,a0,-276 # 7648 <malloc+0x1b68>
    3764:	00002097          	auipc	ra,0x2
    3768:	2be080e7          	jalr	702(ra) # 5a22 <printf>
    exit(1);
    376c:	4505                	li	a0,1
    376e:	00002097          	auipc	ra,0x2
    3772:	f34080e7          	jalr	-204(ra) # 56a2 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3776:	85ca                	mv	a1,s2
    3778:	00004517          	auipc	a0,0x4
    377c:	ef850513          	addi	a0,a0,-264 # 7670 <malloc+0x1b90>
    3780:	00002097          	auipc	ra,0x2
    3784:	2a2080e7          	jalr	674(ra) # 5a22 <printf>
    exit(1);
    3788:	4505                	li	a0,1
    378a:	00002097          	auipc	ra,0x2
    378e:	f18080e7          	jalr	-232(ra) # 56a2 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3792:	85ca                	mv	a1,s2
    3794:	00004517          	auipc	a0,0x4
    3798:	b7450513          	addi	a0,a0,-1164 # 7308 <malloc+0x1828>
    379c:	00002097          	auipc	ra,0x2
    37a0:	286080e7          	jalr	646(ra) # 5a22 <printf>
    exit(1);
    37a4:	4505                	li	a0,1
    37a6:	00002097          	auipc	ra,0x2
    37aa:	efc080e7          	jalr	-260(ra) # 56a2 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    37ae:	85ca                	mv	a1,s2
    37b0:	00004517          	auipc	a0,0x4
    37b4:	ee050513          	addi	a0,a0,-288 # 7690 <malloc+0x1bb0>
    37b8:	00002097          	auipc	ra,0x2
    37bc:	26a080e7          	jalr	618(ra) # 5a22 <printf>
    exit(1);
    37c0:	4505                	li	a0,1
    37c2:	00002097          	auipc	ra,0x2
    37c6:	ee0080e7          	jalr	-288(ra) # 56a2 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    37ca:	85ca                	mv	a1,s2
    37cc:	00004517          	auipc	a0,0x4
    37d0:	ee450513          	addi	a0,a0,-284 # 76b0 <malloc+0x1bd0>
    37d4:	00002097          	auipc	ra,0x2
    37d8:	24e080e7          	jalr	590(ra) # 5a22 <printf>
    exit(1);
    37dc:	4505                	li	a0,1
    37de:	00002097          	auipc	ra,0x2
    37e2:	ec4080e7          	jalr	-316(ra) # 56a2 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    37e6:	85ca                	mv	a1,s2
    37e8:	00004517          	auipc	a0,0x4
    37ec:	ef850513          	addi	a0,a0,-264 # 76e0 <malloc+0x1c00>
    37f0:	00002097          	auipc	ra,0x2
    37f4:	232080e7          	jalr	562(ra) # 5a22 <printf>
    exit(1);
    37f8:	4505                	li	a0,1
    37fa:	00002097          	auipc	ra,0x2
    37fe:	ea8080e7          	jalr	-344(ra) # 56a2 <exit>
    printf("%s: unlink dd failed\n", s);
    3802:	85ca                	mv	a1,s2
    3804:	00004517          	auipc	a0,0x4
    3808:	efc50513          	addi	a0,a0,-260 # 7700 <malloc+0x1c20>
    380c:	00002097          	auipc	ra,0x2
    3810:	216080e7          	jalr	534(ra) # 5a22 <printf>
    exit(1);
    3814:	4505                	li	a0,1
    3816:	00002097          	auipc	ra,0x2
    381a:	e8c080e7          	jalr	-372(ra) # 56a2 <exit>

000000000000381e <rmdot>:
{
    381e:	1101                	addi	sp,sp,-32
    3820:	ec06                	sd	ra,24(sp)
    3822:	e822                	sd	s0,16(sp)
    3824:	e426                	sd	s1,8(sp)
    3826:	1000                	addi	s0,sp,32
    3828:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    382a:	00004517          	auipc	a0,0x4
    382e:	eee50513          	addi	a0,a0,-274 # 7718 <malloc+0x1c38>
    3832:	00002097          	auipc	ra,0x2
    3836:	ed8080e7          	jalr	-296(ra) # 570a <mkdir>
    383a:	e549                	bnez	a0,38c4 <rmdot+0xa6>
  if(chdir("dots") != 0){
    383c:	00004517          	auipc	a0,0x4
    3840:	edc50513          	addi	a0,a0,-292 # 7718 <malloc+0x1c38>
    3844:	00002097          	auipc	ra,0x2
    3848:	ece080e7          	jalr	-306(ra) # 5712 <chdir>
    384c:	e951                	bnez	a0,38e0 <rmdot+0xc2>
  if(unlink(".") == 0){
    384e:	00003517          	auipc	a0,0x3
    3852:	d7a50513          	addi	a0,a0,-646 # 65c8 <malloc+0xae8>
    3856:	00002097          	auipc	ra,0x2
    385a:	e9c080e7          	jalr	-356(ra) # 56f2 <unlink>
    385e:	cd59                	beqz	a0,38fc <rmdot+0xde>
  if(unlink("..") == 0){
    3860:	00004517          	auipc	a0,0x4
    3864:	91050513          	addi	a0,a0,-1776 # 7170 <malloc+0x1690>
    3868:	00002097          	auipc	ra,0x2
    386c:	e8a080e7          	jalr	-374(ra) # 56f2 <unlink>
    3870:	c545                	beqz	a0,3918 <rmdot+0xfa>
  if(chdir("/") != 0){
    3872:	00004517          	auipc	a0,0x4
    3876:	8a650513          	addi	a0,a0,-1882 # 7118 <malloc+0x1638>
    387a:	00002097          	auipc	ra,0x2
    387e:	e98080e7          	jalr	-360(ra) # 5712 <chdir>
    3882:	e94d                	bnez	a0,3934 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3884:	00004517          	auipc	a0,0x4
    3888:	efc50513          	addi	a0,a0,-260 # 7780 <malloc+0x1ca0>
    388c:	00002097          	auipc	ra,0x2
    3890:	e66080e7          	jalr	-410(ra) # 56f2 <unlink>
    3894:	cd55                	beqz	a0,3950 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3896:	00004517          	auipc	a0,0x4
    389a:	f1250513          	addi	a0,a0,-238 # 77a8 <malloc+0x1cc8>
    389e:	00002097          	auipc	ra,0x2
    38a2:	e54080e7          	jalr	-428(ra) # 56f2 <unlink>
    38a6:	c179                	beqz	a0,396c <rmdot+0x14e>
  if(unlink("dots") != 0){
    38a8:	00004517          	auipc	a0,0x4
    38ac:	e7050513          	addi	a0,a0,-400 # 7718 <malloc+0x1c38>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	e42080e7          	jalr	-446(ra) # 56f2 <unlink>
    38b8:	e961                	bnez	a0,3988 <rmdot+0x16a>
}
    38ba:	60e2                	ld	ra,24(sp)
    38bc:	6442                	ld	s0,16(sp)
    38be:	64a2                	ld	s1,8(sp)
    38c0:	6105                	addi	sp,sp,32
    38c2:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    38c4:	85a6                	mv	a1,s1
    38c6:	00004517          	auipc	a0,0x4
    38ca:	e5a50513          	addi	a0,a0,-422 # 7720 <malloc+0x1c40>
    38ce:	00002097          	auipc	ra,0x2
    38d2:	154080e7          	jalr	340(ra) # 5a22 <printf>
    exit(1);
    38d6:	4505                	li	a0,1
    38d8:	00002097          	auipc	ra,0x2
    38dc:	dca080e7          	jalr	-566(ra) # 56a2 <exit>
    printf("%s: chdir dots failed\n", s);
    38e0:	85a6                	mv	a1,s1
    38e2:	00004517          	auipc	a0,0x4
    38e6:	e5650513          	addi	a0,a0,-426 # 7738 <malloc+0x1c58>
    38ea:	00002097          	auipc	ra,0x2
    38ee:	138080e7          	jalr	312(ra) # 5a22 <printf>
    exit(1);
    38f2:	4505                	li	a0,1
    38f4:	00002097          	auipc	ra,0x2
    38f8:	dae080e7          	jalr	-594(ra) # 56a2 <exit>
    printf("%s: rm . worked!\n", s);
    38fc:	85a6                	mv	a1,s1
    38fe:	00004517          	auipc	a0,0x4
    3902:	e5250513          	addi	a0,a0,-430 # 7750 <malloc+0x1c70>
    3906:	00002097          	auipc	ra,0x2
    390a:	11c080e7          	jalr	284(ra) # 5a22 <printf>
    exit(1);
    390e:	4505                	li	a0,1
    3910:	00002097          	auipc	ra,0x2
    3914:	d92080e7          	jalr	-622(ra) # 56a2 <exit>
    printf("%s: rm .. worked!\n", s);
    3918:	85a6                	mv	a1,s1
    391a:	00004517          	auipc	a0,0x4
    391e:	e4e50513          	addi	a0,a0,-434 # 7768 <malloc+0x1c88>
    3922:	00002097          	auipc	ra,0x2
    3926:	100080e7          	jalr	256(ra) # 5a22 <printf>
    exit(1);
    392a:	4505                	li	a0,1
    392c:	00002097          	auipc	ra,0x2
    3930:	d76080e7          	jalr	-650(ra) # 56a2 <exit>
    printf("%s: chdir / failed\n", s);
    3934:	85a6                	mv	a1,s1
    3936:	00003517          	auipc	a0,0x3
    393a:	7ea50513          	addi	a0,a0,2026 # 7120 <malloc+0x1640>
    393e:	00002097          	auipc	ra,0x2
    3942:	0e4080e7          	jalr	228(ra) # 5a22 <printf>
    exit(1);
    3946:	4505                	li	a0,1
    3948:	00002097          	auipc	ra,0x2
    394c:	d5a080e7          	jalr	-678(ra) # 56a2 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3950:	85a6                	mv	a1,s1
    3952:	00004517          	auipc	a0,0x4
    3956:	e3650513          	addi	a0,a0,-458 # 7788 <malloc+0x1ca8>
    395a:	00002097          	auipc	ra,0x2
    395e:	0c8080e7          	jalr	200(ra) # 5a22 <printf>
    exit(1);
    3962:	4505                	li	a0,1
    3964:	00002097          	auipc	ra,0x2
    3968:	d3e080e7          	jalr	-706(ra) # 56a2 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    396c:	85a6                	mv	a1,s1
    396e:	00004517          	auipc	a0,0x4
    3972:	e4250513          	addi	a0,a0,-446 # 77b0 <malloc+0x1cd0>
    3976:	00002097          	auipc	ra,0x2
    397a:	0ac080e7          	jalr	172(ra) # 5a22 <printf>
    exit(1);
    397e:	4505                	li	a0,1
    3980:	00002097          	auipc	ra,0x2
    3984:	d22080e7          	jalr	-734(ra) # 56a2 <exit>
    printf("%s: unlink dots failed!\n", s);
    3988:	85a6                	mv	a1,s1
    398a:	00004517          	auipc	a0,0x4
    398e:	e4650513          	addi	a0,a0,-442 # 77d0 <malloc+0x1cf0>
    3992:	00002097          	auipc	ra,0x2
    3996:	090080e7          	jalr	144(ra) # 5a22 <printf>
    exit(1);
    399a:	4505                	li	a0,1
    399c:	00002097          	auipc	ra,0x2
    39a0:	d06080e7          	jalr	-762(ra) # 56a2 <exit>

00000000000039a4 <dirfile>:
{
    39a4:	1101                	addi	sp,sp,-32
    39a6:	ec06                	sd	ra,24(sp)
    39a8:	e822                	sd	s0,16(sp)
    39aa:	e426                	sd	s1,8(sp)
    39ac:	e04a                	sd	s2,0(sp)
    39ae:	1000                	addi	s0,sp,32
    39b0:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    39b2:	20000593          	li	a1,512
    39b6:	00002517          	auipc	a0,0x2
    39ba:	51a50513          	addi	a0,a0,1306 # 5ed0 <malloc+0x3f0>
    39be:	00002097          	auipc	ra,0x2
    39c2:	d24080e7          	jalr	-732(ra) # 56e2 <open>
  if(fd < 0){
    39c6:	0e054d63          	bltz	a0,3ac0 <dirfile+0x11c>
  close(fd);
    39ca:	00002097          	auipc	ra,0x2
    39ce:	d00080e7          	jalr	-768(ra) # 56ca <close>
  if(chdir("dirfile") == 0){
    39d2:	00002517          	auipc	a0,0x2
    39d6:	4fe50513          	addi	a0,a0,1278 # 5ed0 <malloc+0x3f0>
    39da:	00002097          	auipc	ra,0x2
    39de:	d38080e7          	jalr	-712(ra) # 5712 <chdir>
    39e2:	cd6d                	beqz	a0,3adc <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    39e4:	4581                	li	a1,0
    39e6:	00004517          	auipc	a0,0x4
    39ea:	e4a50513          	addi	a0,a0,-438 # 7830 <malloc+0x1d50>
    39ee:	00002097          	auipc	ra,0x2
    39f2:	cf4080e7          	jalr	-780(ra) # 56e2 <open>
  if(fd >= 0){
    39f6:	10055163          	bgez	a0,3af8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    39fa:	20000593          	li	a1,512
    39fe:	00004517          	auipc	a0,0x4
    3a02:	e3250513          	addi	a0,a0,-462 # 7830 <malloc+0x1d50>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	cdc080e7          	jalr	-804(ra) # 56e2 <open>
  if(fd >= 0){
    3a0e:	10055363          	bgez	a0,3b14 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a12:	00004517          	auipc	a0,0x4
    3a16:	e1e50513          	addi	a0,a0,-482 # 7830 <malloc+0x1d50>
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	cf0080e7          	jalr	-784(ra) # 570a <mkdir>
    3a22:	10050763          	beqz	a0,3b30 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a26:	00004517          	auipc	a0,0x4
    3a2a:	e0a50513          	addi	a0,a0,-502 # 7830 <malloc+0x1d50>
    3a2e:	00002097          	auipc	ra,0x2
    3a32:	cc4080e7          	jalr	-828(ra) # 56f2 <unlink>
    3a36:	10050b63          	beqz	a0,3b4c <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3a3a:	00004597          	auipc	a1,0x4
    3a3e:	df658593          	addi	a1,a1,-522 # 7830 <malloc+0x1d50>
    3a42:	00002517          	auipc	a0,0x2
    3a46:	68650513          	addi	a0,a0,1670 # 60c8 <malloc+0x5e8>
    3a4a:	00002097          	auipc	ra,0x2
    3a4e:	cb8080e7          	jalr	-840(ra) # 5702 <link>
    3a52:	10050b63          	beqz	a0,3b68 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3a56:	00002517          	auipc	a0,0x2
    3a5a:	47a50513          	addi	a0,a0,1146 # 5ed0 <malloc+0x3f0>
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	c94080e7          	jalr	-876(ra) # 56f2 <unlink>
    3a66:	10051f63          	bnez	a0,3b84 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3a6a:	4589                	li	a1,2
    3a6c:	00003517          	auipc	a0,0x3
    3a70:	b5c50513          	addi	a0,a0,-1188 # 65c8 <malloc+0xae8>
    3a74:	00002097          	auipc	ra,0x2
    3a78:	c6e080e7          	jalr	-914(ra) # 56e2 <open>
  if(fd >= 0){
    3a7c:	12055263          	bgez	a0,3ba0 <dirfile+0x1fc>
  fd = open(".", 0);
    3a80:	4581                	li	a1,0
    3a82:	00003517          	auipc	a0,0x3
    3a86:	b4650513          	addi	a0,a0,-1210 # 65c8 <malloc+0xae8>
    3a8a:	00002097          	auipc	ra,0x2
    3a8e:	c58080e7          	jalr	-936(ra) # 56e2 <open>
    3a92:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3a94:	4605                	li	a2,1
    3a96:	00002597          	auipc	a1,0x2
    3a9a:	50a58593          	addi	a1,a1,1290 # 5fa0 <malloc+0x4c0>
    3a9e:	00002097          	auipc	ra,0x2
    3aa2:	c24080e7          	jalr	-988(ra) # 56c2 <write>
    3aa6:	10a04b63          	bgtz	a0,3bbc <dirfile+0x218>
  close(fd);
    3aaa:	8526                	mv	a0,s1
    3aac:	00002097          	auipc	ra,0x2
    3ab0:	c1e080e7          	jalr	-994(ra) # 56ca <close>
}
    3ab4:	60e2                	ld	ra,24(sp)
    3ab6:	6442                	ld	s0,16(sp)
    3ab8:	64a2                	ld	s1,8(sp)
    3aba:	6902                	ld	s2,0(sp)
    3abc:	6105                	addi	sp,sp,32
    3abe:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3ac0:	85ca                	mv	a1,s2
    3ac2:	00004517          	auipc	a0,0x4
    3ac6:	d2e50513          	addi	a0,a0,-722 # 77f0 <malloc+0x1d10>
    3aca:	00002097          	auipc	ra,0x2
    3ace:	f58080e7          	jalr	-168(ra) # 5a22 <printf>
    exit(1);
    3ad2:	4505                	li	a0,1
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	bce080e7          	jalr	-1074(ra) # 56a2 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3adc:	85ca                	mv	a1,s2
    3ade:	00004517          	auipc	a0,0x4
    3ae2:	d3250513          	addi	a0,a0,-718 # 7810 <malloc+0x1d30>
    3ae6:	00002097          	auipc	ra,0x2
    3aea:	f3c080e7          	jalr	-196(ra) # 5a22 <printf>
    exit(1);
    3aee:	4505                	li	a0,1
    3af0:	00002097          	auipc	ra,0x2
    3af4:	bb2080e7          	jalr	-1102(ra) # 56a2 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3af8:	85ca                	mv	a1,s2
    3afa:	00004517          	auipc	a0,0x4
    3afe:	d4650513          	addi	a0,a0,-698 # 7840 <malloc+0x1d60>
    3b02:	00002097          	auipc	ra,0x2
    3b06:	f20080e7          	jalr	-224(ra) # 5a22 <printf>
    exit(1);
    3b0a:	4505                	li	a0,1
    3b0c:	00002097          	auipc	ra,0x2
    3b10:	b96080e7          	jalr	-1130(ra) # 56a2 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b14:	85ca                	mv	a1,s2
    3b16:	00004517          	auipc	a0,0x4
    3b1a:	d2a50513          	addi	a0,a0,-726 # 7840 <malloc+0x1d60>
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	f04080e7          	jalr	-252(ra) # 5a22 <printf>
    exit(1);
    3b26:	4505                	li	a0,1
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	b7a080e7          	jalr	-1158(ra) # 56a2 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b30:	85ca                	mv	a1,s2
    3b32:	00004517          	auipc	a0,0x4
    3b36:	d3650513          	addi	a0,a0,-714 # 7868 <malloc+0x1d88>
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	ee8080e7          	jalr	-280(ra) # 5a22 <printf>
    exit(1);
    3b42:	4505                	li	a0,1
    3b44:	00002097          	auipc	ra,0x2
    3b48:	b5e080e7          	jalr	-1186(ra) # 56a2 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3b4c:	85ca                	mv	a1,s2
    3b4e:	00004517          	auipc	a0,0x4
    3b52:	d4250513          	addi	a0,a0,-702 # 7890 <malloc+0x1db0>
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	ecc080e7          	jalr	-308(ra) # 5a22 <printf>
    exit(1);
    3b5e:	4505                	li	a0,1
    3b60:	00002097          	auipc	ra,0x2
    3b64:	b42080e7          	jalr	-1214(ra) # 56a2 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3b68:	85ca                	mv	a1,s2
    3b6a:	00004517          	auipc	a0,0x4
    3b6e:	d4e50513          	addi	a0,a0,-690 # 78b8 <malloc+0x1dd8>
    3b72:	00002097          	auipc	ra,0x2
    3b76:	eb0080e7          	jalr	-336(ra) # 5a22 <printf>
    exit(1);
    3b7a:	4505                	li	a0,1
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	b26080e7          	jalr	-1242(ra) # 56a2 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3b84:	85ca                	mv	a1,s2
    3b86:	00004517          	auipc	a0,0x4
    3b8a:	d5a50513          	addi	a0,a0,-678 # 78e0 <malloc+0x1e00>
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	e94080e7          	jalr	-364(ra) # 5a22 <printf>
    exit(1);
    3b96:	4505                	li	a0,1
    3b98:	00002097          	auipc	ra,0x2
    3b9c:	b0a080e7          	jalr	-1270(ra) # 56a2 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3ba0:	85ca                	mv	a1,s2
    3ba2:	00004517          	auipc	a0,0x4
    3ba6:	d5e50513          	addi	a0,a0,-674 # 7900 <malloc+0x1e20>
    3baa:	00002097          	auipc	ra,0x2
    3bae:	e78080e7          	jalr	-392(ra) # 5a22 <printf>
    exit(1);
    3bb2:	4505                	li	a0,1
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	aee080e7          	jalr	-1298(ra) # 56a2 <exit>
    printf("%s: write . succeeded!\n", s);
    3bbc:	85ca                	mv	a1,s2
    3bbe:	00004517          	auipc	a0,0x4
    3bc2:	d6a50513          	addi	a0,a0,-662 # 7928 <malloc+0x1e48>
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	e5c080e7          	jalr	-420(ra) # 5a22 <printf>
    exit(1);
    3bce:	4505                	li	a0,1
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	ad2080e7          	jalr	-1326(ra) # 56a2 <exit>

0000000000003bd8 <iref>:
{
    3bd8:	7139                	addi	sp,sp,-64
    3bda:	fc06                	sd	ra,56(sp)
    3bdc:	f822                	sd	s0,48(sp)
    3bde:	f426                	sd	s1,40(sp)
    3be0:	f04a                	sd	s2,32(sp)
    3be2:	ec4e                	sd	s3,24(sp)
    3be4:	e852                	sd	s4,16(sp)
    3be6:	e456                	sd	s5,8(sp)
    3be8:	e05a                	sd	s6,0(sp)
    3bea:	0080                	addi	s0,sp,64
    3bec:	8b2a                	mv	s6,a0
    3bee:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3bf2:	00004a17          	auipc	s4,0x4
    3bf6:	d4ea0a13          	addi	s4,s4,-690 # 7940 <malloc+0x1e60>
    mkdir("");
    3bfa:	00004497          	auipc	s1,0x4
    3bfe:	85648493          	addi	s1,s1,-1962 # 7450 <malloc+0x1970>
    link("README", "");
    3c02:	00002a97          	auipc	s5,0x2
    3c06:	4c6a8a93          	addi	s5,s5,1222 # 60c8 <malloc+0x5e8>
    fd = open("xx", O_CREATE);
    3c0a:	00004997          	auipc	s3,0x4
    3c0e:	c2e98993          	addi	s3,s3,-978 # 7838 <malloc+0x1d58>
    3c12:	a891                	j	3c66 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c14:	85da                	mv	a1,s6
    3c16:	00004517          	auipc	a0,0x4
    3c1a:	d3250513          	addi	a0,a0,-718 # 7948 <malloc+0x1e68>
    3c1e:	00002097          	auipc	ra,0x2
    3c22:	e04080e7          	jalr	-508(ra) # 5a22 <printf>
      exit(1);
    3c26:	4505                	li	a0,1
    3c28:	00002097          	auipc	ra,0x2
    3c2c:	a7a080e7          	jalr	-1414(ra) # 56a2 <exit>
      printf("%s: chdir irefd failed\n", s);
    3c30:	85da                	mv	a1,s6
    3c32:	00004517          	auipc	a0,0x4
    3c36:	d2e50513          	addi	a0,a0,-722 # 7960 <malloc+0x1e80>
    3c3a:	00002097          	auipc	ra,0x2
    3c3e:	de8080e7          	jalr	-536(ra) # 5a22 <printf>
      exit(1);
    3c42:	4505                	li	a0,1
    3c44:	00002097          	auipc	ra,0x2
    3c48:	a5e080e7          	jalr	-1442(ra) # 56a2 <exit>
      close(fd);
    3c4c:	00002097          	auipc	ra,0x2
    3c50:	a7e080e7          	jalr	-1410(ra) # 56ca <close>
    3c54:	a889                	j	3ca6 <iref+0xce>
    unlink("xx");
    3c56:	854e                	mv	a0,s3
    3c58:	00002097          	auipc	ra,0x2
    3c5c:	a9a080e7          	jalr	-1382(ra) # 56f2 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3c60:	397d                	addiw	s2,s2,-1
    3c62:	06090063          	beqz	s2,3cc2 <iref+0xea>
    if(mkdir("irefd") != 0){
    3c66:	8552                	mv	a0,s4
    3c68:	00002097          	auipc	ra,0x2
    3c6c:	aa2080e7          	jalr	-1374(ra) # 570a <mkdir>
    3c70:	f155                	bnez	a0,3c14 <iref+0x3c>
    if(chdir("irefd") != 0){
    3c72:	8552                	mv	a0,s4
    3c74:	00002097          	auipc	ra,0x2
    3c78:	a9e080e7          	jalr	-1378(ra) # 5712 <chdir>
    3c7c:	f955                	bnez	a0,3c30 <iref+0x58>
    mkdir("");
    3c7e:	8526                	mv	a0,s1
    3c80:	00002097          	auipc	ra,0x2
    3c84:	a8a080e7          	jalr	-1398(ra) # 570a <mkdir>
    link("README", "");
    3c88:	85a6                	mv	a1,s1
    3c8a:	8556                	mv	a0,s5
    3c8c:	00002097          	auipc	ra,0x2
    3c90:	a76080e7          	jalr	-1418(ra) # 5702 <link>
    fd = open("", O_CREATE);
    3c94:	20000593          	li	a1,512
    3c98:	8526                	mv	a0,s1
    3c9a:	00002097          	auipc	ra,0x2
    3c9e:	a48080e7          	jalr	-1464(ra) # 56e2 <open>
    if(fd >= 0)
    3ca2:	fa0555e3          	bgez	a0,3c4c <iref+0x74>
    fd = open("xx", O_CREATE);
    3ca6:	20000593          	li	a1,512
    3caa:	854e                	mv	a0,s3
    3cac:	00002097          	auipc	ra,0x2
    3cb0:	a36080e7          	jalr	-1482(ra) # 56e2 <open>
    if(fd >= 0)
    3cb4:	fa0541e3          	bltz	a0,3c56 <iref+0x7e>
      close(fd);
    3cb8:	00002097          	auipc	ra,0x2
    3cbc:	a12080e7          	jalr	-1518(ra) # 56ca <close>
    3cc0:	bf59                	j	3c56 <iref+0x7e>
    3cc2:	03300493          	li	s1,51
    chdir("..");
    3cc6:	00003997          	auipc	s3,0x3
    3cca:	4aa98993          	addi	s3,s3,1194 # 7170 <malloc+0x1690>
    unlink("irefd");
    3cce:	00004917          	auipc	s2,0x4
    3cd2:	c7290913          	addi	s2,s2,-910 # 7940 <malloc+0x1e60>
    chdir("..");
    3cd6:	854e                	mv	a0,s3
    3cd8:	00002097          	auipc	ra,0x2
    3cdc:	a3a080e7          	jalr	-1478(ra) # 5712 <chdir>
    unlink("irefd");
    3ce0:	854a                	mv	a0,s2
    3ce2:	00002097          	auipc	ra,0x2
    3ce6:	a10080e7          	jalr	-1520(ra) # 56f2 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3cea:	34fd                	addiw	s1,s1,-1
    3cec:	f4ed                	bnez	s1,3cd6 <iref+0xfe>
  chdir("/");
    3cee:	00003517          	auipc	a0,0x3
    3cf2:	42a50513          	addi	a0,a0,1066 # 7118 <malloc+0x1638>
    3cf6:	00002097          	auipc	ra,0x2
    3cfa:	a1c080e7          	jalr	-1508(ra) # 5712 <chdir>
}
    3cfe:	70e2                	ld	ra,56(sp)
    3d00:	7442                	ld	s0,48(sp)
    3d02:	74a2                	ld	s1,40(sp)
    3d04:	7902                	ld	s2,32(sp)
    3d06:	69e2                	ld	s3,24(sp)
    3d08:	6a42                	ld	s4,16(sp)
    3d0a:	6aa2                	ld	s5,8(sp)
    3d0c:	6b02                	ld	s6,0(sp)
    3d0e:	6121                	addi	sp,sp,64
    3d10:	8082                	ret

0000000000003d12 <openiputtest>:
{
    3d12:	7179                	addi	sp,sp,-48
    3d14:	f406                	sd	ra,40(sp)
    3d16:	f022                	sd	s0,32(sp)
    3d18:	ec26                	sd	s1,24(sp)
    3d1a:	1800                	addi	s0,sp,48
    3d1c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d1e:	00004517          	auipc	a0,0x4
    3d22:	c5a50513          	addi	a0,a0,-934 # 7978 <malloc+0x1e98>
    3d26:	00002097          	auipc	ra,0x2
    3d2a:	9e4080e7          	jalr	-1564(ra) # 570a <mkdir>
    3d2e:	04054263          	bltz	a0,3d72 <openiputtest+0x60>
  pid = fork();
    3d32:	00002097          	auipc	ra,0x2
    3d36:	968080e7          	jalr	-1688(ra) # 569a <fork>
  if(pid < 0){
    3d3a:	04054a63          	bltz	a0,3d8e <openiputtest+0x7c>
  if(pid == 0){
    3d3e:	e93d                	bnez	a0,3db4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d40:	4589                	li	a1,2
    3d42:	00004517          	auipc	a0,0x4
    3d46:	c3650513          	addi	a0,a0,-970 # 7978 <malloc+0x1e98>
    3d4a:	00002097          	auipc	ra,0x2
    3d4e:	998080e7          	jalr	-1640(ra) # 56e2 <open>
    if(fd >= 0){
    3d52:	04054c63          	bltz	a0,3daa <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3d56:	85a6                	mv	a1,s1
    3d58:	00004517          	auipc	a0,0x4
    3d5c:	c4050513          	addi	a0,a0,-960 # 7998 <malloc+0x1eb8>
    3d60:	00002097          	auipc	ra,0x2
    3d64:	cc2080e7          	jalr	-830(ra) # 5a22 <printf>
      exit(1);
    3d68:	4505                	li	a0,1
    3d6a:	00002097          	auipc	ra,0x2
    3d6e:	938080e7          	jalr	-1736(ra) # 56a2 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3d72:	85a6                	mv	a1,s1
    3d74:	00004517          	auipc	a0,0x4
    3d78:	c0c50513          	addi	a0,a0,-1012 # 7980 <malloc+0x1ea0>
    3d7c:	00002097          	auipc	ra,0x2
    3d80:	ca6080e7          	jalr	-858(ra) # 5a22 <printf>
    exit(1);
    3d84:	4505                	li	a0,1
    3d86:	00002097          	auipc	ra,0x2
    3d8a:	91c080e7          	jalr	-1764(ra) # 56a2 <exit>
    printf("%s: fork failed\n", s);
    3d8e:	85a6                	mv	a1,s1
    3d90:	00003517          	auipc	a0,0x3
    3d94:	9d850513          	addi	a0,a0,-1576 # 6768 <malloc+0xc88>
    3d98:	00002097          	auipc	ra,0x2
    3d9c:	c8a080e7          	jalr	-886(ra) # 5a22 <printf>
    exit(1);
    3da0:	4505                	li	a0,1
    3da2:	00002097          	auipc	ra,0x2
    3da6:	900080e7          	jalr	-1792(ra) # 56a2 <exit>
    exit(0);
    3daa:	4501                	li	a0,0
    3dac:	00002097          	auipc	ra,0x2
    3db0:	8f6080e7          	jalr	-1802(ra) # 56a2 <exit>
  sleep(1);
    3db4:	4505                	li	a0,1
    3db6:	00002097          	auipc	ra,0x2
    3dba:	97c080e7          	jalr	-1668(ra) # 5732 <sleep>
  if(unlink("oidir") != 0){
    3dbe:	00004517          	auipc	a0,0x4
    3dc2:	bba50513          	addi	a0,a0,-1094 # 7978 <malloc+0x1e98>
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	92c080e7          	jalr	-1748(ra) # 56f2 <unlink>
    3dce:	cd19                	beqz	a0,3dec <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3dd0:	85a6                	mv	a1,s1
    3dd2:	00003517          	auipc	a0,0x3
    3dd6:	b8650513          	addi	a0,a0,-1146 # 6958 <malloc+0xe78>
    3dda:	00002097          	auipc	ra,0x2
    3dde:	c48080e7          	jalr	-952(ra) # 5a22 <printf>
    exit(1);
    3de2:	4505                	li	a0,1
    3de4:	00002097          	auipc	ra,0x2
    3de8:	8be080e7          	jalr	-1858(ra) # 56a2 <exit>
  wait(&xstatus);
    3dec:	fdc40513          	addi	a0,s0,-36
    3df0:	00002097          	auipc	ra,0x2
    3df4:	8ba080e7          	jalr	-1862(ra) # 56aa <wait>
  exit(xstatus);
    3df8:	fdc42503          	lw	a0,-36(s0)
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	8a6080e7          	jalr	-1882(ra) # 56a2 <exit>

0000000000003e04 <forkforkfork>:
{
    3e04:	1101                	addi	sp,sp,-32
    3e06:	ec06                	sd	ra,24(sp)
    3e08:	e822                	sd	s0,16(sp)
    3e0a:	e426                	sd	s1,8(sp)
    3e0c:	1000                	addi	s0,sp,32
    3e0e:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e10:	00004517          	auipc	a0,0x4
    3e14:	bb050513          	addi	a0,a0,-1104 # 79c0 <malloc+0x1ee0>
    3e18:	00002097          	auipc	ra,0x2
    3e1c:	8da080e7          	jalr	-1830(ra) # 56f2 <unlink>
  int pid = fork();
    3e20:	00002097          	auipc	ra,0x2
    3e24:	87a080e7          	jalr	-1926(ra) # 569a <fork>
  if(pid < 0){
    3e28:	04054563          	bltz	a0,3e72 <forkforkfork+0x6e>
  if(pid == 0){
    3e2c:	c12d                	beqz	a0,3e8e <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e2e:	4551                	li	a0,20
    3e30:	00002097          	auipc	ra,0x2
    3e34:	902080e7          	jalr	-1790(ra) # 5732 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e38:	20200593          	li	a1,514
    3e3c:	00004517          	auipc	a0,0x4
    3e40:	b8450513          	addi	a0,a0,-1148 # 79c0 <malloc+0x1ee0>
    3e44:	00002097          	auipc	ra,0x2
    3e48:	89e080e7          	jalr	-1890(ra) # 56e2 <open>
    3e4c:	00002097          	auipc	ra,0x2
    3e50:	87e080e7          	jalr	-1922(ra) # 56ca <close>
  wait(0);
    3e54:	4501                	li	a0,0
    3e56:	00002097          	auipc	ra,0x2
    3e5a:	854080e7          	jalr	-1964(ra) # 56aa <wait>
  sleep(10); // one second
    3e5e:	4529                	li	a0,10
    3e60:	00002097          	auipc	ra,0x2
    3e64:	8d2080e7          	jalr	-1838(ra) # 5732 <sleep>
}
    3e68:	60e2                	ld	ra,24(sp)
    3e6a:	6442                	ld	s0,16(sp)
    3e6c:	64a2                	ld	s1,8(sp)
    3e6e:	6105                	addi	sp,sp,32
    3e70:	8082                	ret
    printf("%s: fork failed", s);
    3e72:	85a6                	mv	a1,s1
    3e74:	00003517          	auipc	a0,0x3
    3e78:	ab450513          	addi	a0,a0,-1356 # 6928 <malloc+0xe48>
    3e7c:	00002097          	auipc	ra,0x2
    3e80:	ba6080e7          	jalr	-1114(ra) # 5a22 <printf>
    exit(1);
    3e84:	4505                	li	a0,1
    3e86:	00002097          	auipc	ra,0x2
    3e8a:	81c080e7          	jalr	-2020(ra) # 56a2 <exit>
      int fd = open("stopforking", 0);
    3e8e:	00004497          	auipc	s1,0x4
    3e92:	b3248493          	addi	s1,s1,-1230 # 79c0 <malloc+0x1ee0>
    3e96:	4581                	li	a1,0
    3e98:	8526                	mv	a0,s1
    3e9a:	00002097          	auipc	ra,0x2
    3e9e:	848080e7          	jalr	-1976(ra) # 56e2 <open>
      if(fd >= 0){
    3ea2:	02055463          	bgez	a0,3eca <forkforkfork+0xc6>
      if(fork() < 0){
    3ea6:	00001097          	auipc	ra,0x1
    3eaa:	7f4080e7          	jalr	2036(ra) # 569a <fork>
    3eae:	fe0554e3          	bgez	a0,3e96 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3eb2:	20200593          	li	a1,514
    3eb6:	8526                	mv	a0,s1
    3eb8:	00002097          	auipc	ra,0x2
    3ebc:	82a080e7          	jalr	-2006(ra) # 56e2 <open>
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	80a080e7          	jalr	-2038(ra) # 56ca <close>
    3ec8:	b7f9                	j	3e96 <forkforkfork+0x92>
        exit(0);
    3eca:	4501                	li	a0,0
    3ecc:	00001097          	auipc	ra,0x1
    3ed0:	7d6080e7          	jalr	2006(ra) # 56a2 <exit>

0000000000003ed4 <killstatus>:
{
    3ed4:	7139                	addi	sp,sp,-64
    3ed6:	fc06                	sd	ra,56(sp)
    3ed8:	f822                	sd	s0,48(sp)
    3eda:	f426                	sd	s1,40(sp)
    3edc:	f04a                	sd	s2,32(sp)
    3ede:	ec4e                	sd	s3,24(sp)
    3ee0:	e852                	sd	s4,16(sp)
    3ee2:	0080                	addi	s0,sp,64
    3ee4:	8a2a                	mv	s4,a0
    3ee6:	06400913          	li	s2,100
    if(xst != -1) {
    3eea:	59fd                	li	s3,-1
    int pid1 = fork();
    3eec:	00001097          	auipc	ra,0x1
    3ef0:	7ae080e7          	jalr	1966(ra) # 569a <fork>
    3ef4:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3ef6:	02054f63          	bltz	a0,3f34 <killstatus+0x60>
    if(pid1 == 0){
    3efa:	c939                	beqz	a0,3f50 <killstatus+0x7c>
    sleep(1);
    3efc:	4505                	li	a0,1
    3efe:	00002097          	auipc	ra,0x2
    3f02:	834080e7          	jalr	-1996(ra) # 5732 <sleep>
    kill(pid1);
    3f06:	8526                	mv	a0,s1
    3f08:	00001097          	auipc	ra,0x1
    3f0c:	7ca080e7          	jalr	1994(ra) # 56d2 <kill>
    wait(&xst);
    3f10:	fcc40513          	addi	a0,s0,-52
    3f14:	00001097          	auipc	ra,0x1
    3f18:	796080e7          	jalr	1942(ra) # 56aa <wait>
    if(xst != -1) {
    3f1c:	fcc42783          	lw	a5,-52(s0)
    3f20:	03379d63          	bne	a5,s3,3f5a <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    3f24:	397d                	addiw	s2,s2,-1
    3f26:	fc0913e3          	bnez	s2,3eec <killstatus+0x18>
  exit(0);
    3f2a:	4501                	li	a0,0
    3f2c:	00001097          	auipc	ra,0x1
    3f30:	776080e7          	jalr	1910(ra) # 56a2 <exit>
      printf("%s: fork failed\n", s);
    3f34:	85d2                	mv	a1,s4
    3f36:	00003517          	auipc	a0,0x3
    3f3a:	83250513          	addi	a0,a0,-1998 # 6768 <malloc+0xc88>
    3f3e:	00002097          	auipc	ra,0x2
    3f42:	ae4080e7          	jalr	-1308(ra) # 5a22 <printf>
      exit(1);
    3f46:	4505                	li	a0,1
    3f48:	00001097          	auipc	ra,0x1
    3f4c:	75a080e7          	jalr	1882(ra) # 56a2 <exit>
        getpid();
    3f50:	00001097          	auipc	ra,0x1
    3f54:	7d2080e7          	jalr	2002(ra) # 5722 <getpid>
      while(1) {
    3f58:	bfe5                	j	3f50 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    3f5a:	85d2                	mv	a1,s4
    3f5c:	00004517          	auipc	a0,0x4
    3f60:	a7450513          	addi	a0,a0,-1420 # 79d0 <malloc+0x1ef0>
    3f64:	00002097          	auipc	ra,0x2
    3f68:	abe080e7          	jalr	-1346(ra) # 5a22 <printf>
       exit(1);
    3f6c:	4505                	li	a0,1
    3f6e:	00001097          	auipc	ra,0x1
    3f72:	734080e7          	jalr	1844(ra) # 56a2 <exit>

0000000000003f76 <preempt>:
{
    3f76:	7139                	addi	sp,sp,-64
    3f78:	fc06                	sd	ra,56(sp)
    3f7a:	f822                	sd	s0,48(sp)
    3f7c:	f426                	sd	s1,40(sp)
    3f7e:	f04a                	sd	s2,32(sp)
    3f80:	ec4e                	sd	s3,24(sp)
    3f82:	e852                	sd	s4,16(sp)
    3f84:	0080                	addi	s0,sp,64
    3f86:	892a                	mv	s2,a0
  pid1 = fork();
    3f88:	00001097          	auipc	ra,0x1
    3f8c:	712080e7          	jalr	1810(ra) # 569a <fork>
  if(pid1 < 0) {
    3f90:	00054563          	bltz	a0,3f9a <preempt+0x24>
    3f94:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3f96:	e105                	bnez	a0,3fb6 <preempt+0x40>
    for(;;)
    3f98:	a001                	j	3f98 <preempt+0x22>
    printf("%s: fork failed", s);
    3f9a:	85ca                	mv	a1,s2
    3f9c:	00003517          	auipc	a0,0x3
    3fa0:	98c50513          	addi	a0,a0,-1652 # 6928 <malloc+0xe48>
    3fa4:	00002097          	auipc	ra,0x2
    3fa8:	a7e080e7          	jalr	-1410(ra) # 5a22 <printf>
    exit(1);
    3fac:	4505                	li	a0,1
    3fae:	00001097          	auipc	ra,0x1
    3fb2:	6f4080e7          	jalr	1780(ra) # 56a2 <exit>
  pid2 = fork();
    3fb6:	00001097          	auipc	ra,0x1
    3fba:	6e4080e7          	jalr	1764(ra) # 569a <fork>
    3fbe:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3fc0:	00054463          	bltz	a0,3fc8 <preempt+0x52>
  if(pid2 == 0)
    3fc4:	e105                	bnez	a0,3fe4 <preempt+0x6e>
    for(;;)
    3fc6:	a001                	j	3fc6 <preempt+0x50>
    printf("%s: fork failed\n", s);
    3fc8:	85ca                	mv	a1,s2
    3fca:	00002517          	auipc	a0,0x2
    3fce:	79e50513          	addi	a0,a0,1950 # 6768 <malloc+0xc88>
    3fd2:	00002097          	auipc	ra,0x2
    3fd6:	a50080e7          	jalr	-1456(ra) # 5a22 <printf>
    exit(1);
    3fda:	4505                	li	a0,1
    3fdc:	00001097          	auipc	ra,0x1
    3fe0:	6c6080e7          	jalr	1734(ra) # 56a2 <exit>
  pipe(pfds);
    3fe4:	fc840513          	addi	a0,s0,-56
    3fe8:	00001097          	auipc	ra,0x1
    3fec:	6ca080e7          	jalr	1738(ra) # 56b2 <pipe>
  pid3 = fork();
    3ff0:	00001097          	auipc	ra,0x1
    3ff4:	6aa080e7          	jalr	1706(ra) # 569a <fork>
    3ff8:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3ffa:	02054e63          	bltz	a0,4036 <preempt+0xc0>
  if(pid3 == 0){
    3ffe:	e525                	bnez	a0,4066 <preempt+0xf0>
    close(pfds[0]);
    4000:	fc842503          	lw	a0,-56(s0)
    4004:	00001097          	auipc	ra,0x1
    4008:	6c6080e7          	jalr	1734(ra) # 56ca <close>
    if(write(pfds[1], "x", 1) != 1)
    400c:	4605                	li	a2,1
    400e:	00002597          	auipc	a1,0x2
    4012:	f9258593          	addi	a1,a1,-110 # 5fa0 <malloc+0x4c0>
    4016:	fcc42503          	lw	a0,-52(s0)
    401a:	00001097          	auipc	ra,0x1
    401e:	6a8080e7          	jalr	1704(ra) # 56c2 <write>
    4022:	4785                	li	a5,1
    4024:	02f51763          	bne	a0,a5,4052 <preempt+0xdc>
    close(pfds[1]);
    4028:	fcc42503          	lw	a0,-52(s0)
    402c:	00001097          	auipc	ra,0x1
    4030:	69e080e7          	jalr	1694(ra) # 56ca <close>
    for(;;)
    4034:	a001                	j	4034 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4036:	85ca                	mv	a1,s2
    4038:	00002517          	auipc	a0,0x2
    403c:	73050513          	addi	a0,a0,1840 # 6768 <malloc+0xc88>
    4040:	00002097          	auipc	ra,0x2
    4044:	9e2080e7          	jalr	-1566(ra) # 5a22 <printf>
     exit(1);
    4048:	4505                	li	a0,1
    404a:	00001097          	auipc	ra,0x1
    404e:	658080e7          	jalr	1624(ra) # 56a2 <exit>
      printf("%s: preempt write error", s);
    4052:	85ca                	mv	a1,s2
    4054:	00004517          	auipc	a0,0x4
    4058:	99c50513          	addi	a0,a0,-1636 # 79f0 <malloc+0x1f10>
    405c:	00002097          	auipc	ra,0x2
    4060:	9c6080e7          	jalr	-1594(ra) # 5a22 <printf>
    4064:	b7d1                	j	4028 <preempt+0xb2>
  close(pfds[1]);
    4066:	fcc42503          	lw	a0,-52(s0)
    406a:	00001097          	auipc	ra,0x1
    406e:	660080e7          	jalr	1632(ra) # 56ca <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4072:	660d                	lui	a2,0x3
    4074:	00008597          	auipc	a1,0x8
    4078:	b0458593          	addi	a1,a1,-1276 # bb78 <buf>
    407c:	fc842503          	lw	a0,-56(s0)
    4080:	00001097          	auipc	ra,0x1
    4084:	63a080e7          	jalr	1594(ra) # 56ba <read>
    4088:	4785                	li	a5,1
    408a:	02f50363          	beq	a0,a5,40b0 <preempt+0x13a>
    printf("%s: preempt read error", s);
    408e:	85ca                	mv	a1,s2
    4090:	00004517          	auipc	a0,0x4
    4094:	97850513          	addi	a0,a0,-1672 # 7a08 <malloc+0x1f28>
    4098:	00002097          	auipc	ra,0x2
    409c:	98a080e7          	jalr	-1654(ra) # 5a22 <printf>
}
    40a0:	70e2                	ld	ra,56(sp)
    40a2:	7442                	ld	s0,48(sp)
    40a4:	74a2                	ld	s1,40(sp)
    40a6:	7902                	ld	s2,32(sp)
    40a8:	69e2                	ld	s3,24(sp)
    40aa:	6a42                	ld	s4,16(sp)
    40ac:	6121                	addi	sp,sp,64
    40ae:	8082                	ret
  close(pfds[0]);
    40b0:	fc842503          	lw	a0,-56(s0)
    40b4:	00001097          	auipc	ra,0x1
    40b8:	616080e7          	jalr	1558(ra) # 56ca <close>
  printf("kill... ");
    40bc:	00004517          	auipc	a0,0x4
    40c0:	96450513          	addi	a0,a0,-1692 # 7a20 <malloc+0x1f40>
    40c4:	00002097          	auipc	ra,0x2
    40c8:	95e080e7          	jalr	-1698(ra) # 5a22 <printf>
  kill(pid1);
    40cc:	8526                	mv	a0,s1
    40ce:	00001097          	auipc	ra,0x1
    40d2:	604080e7          	jalr	1540(ra) # 56d2 <kill>
  kill(pid2);
    40d6:	854e                	mv	a0,s3
    40d8:	00001097          	auipc	ra,0x1
    40dc:	5fa080e7          	jalr	1530(ra) # 56d2 <kill>
  kill(pid3);
    40e0:	8552                	mv	a0,s4
    40e2:	00001097          	auipc	ra,0x1
    40e6:	5f0080e7          	jalr	1520(ra) # 56d2 <kill>
  printf("wait... ");
    40ea:	00004517          	auipc	a0,0x4
    40ee:	94650513          	addi	a0,a0,-1722 # 7a30 <malloc+0x1f50>
    40f2:	00002097          	auipc	ra,0x2
    40f6:	930080e7          	jalr	-1744(ra) # 5a22 <printf>
  wait(0);
    40fa:	4501                	li	a0,0
    40fc:	00001097          	auipc	ra,0x1
    4100:	5ae080e7          	jalr	1454(ra) # 56aa <wait>
  wait(0);
    4104:	4501                	li	a0,0
    4106:	00001097          	auipc	ra,0x1
    410a:	5a4080e7          	jalr	1444(ra) # 56aa <wait>
  wait(0);
    410e:	4501                	li	a0,0
    4110:	00001097          	auipc	ra,0x1
    4114:	59a080e7          	jalr	1434(ra) # 56aa <wait>
    4118:	b761                	j	40a0 <preempt+0x12a>

000000000000411a <reparent>:
{
    411a:	7179                	addi	sp,sp,-48
    411c:	f406                	sd	ra,40(sp)
    411e:	f022                	sd	s0,32(sp)
    4120:	ec26                	sd	s1,24(sp)
    4122:	e84a                	sd	s2,16(sp)
    4124:	e44e                	sd	s3,8(sp)
    4126:	e052                	sd	s4,0(sp)
    4128:	1800                	addi	s0,sp,48
    412a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    412c:	00001097          	auipc	ra,0x1
    4130:	5f6080e7          	jalr	1526(ra) # 5722 <getpid>
    4134:	8a2a                	mv	s4,a0
    4136:	0c800913          	li	s2,200
    int pid = fork();
    413a:	00001097          	auipc	ra,0x1
    413e:	560080e7          	jalr	1376(ra) # 569a <fork>
    4142:	84aa                	mv	s1,a0
    if(pid < 0){
    4144:	02054263          	bltz	a0,4168 <reparent+0x4e>
    if(pid){
    4148:	cd21                	beqz	a0,41a0 <reparent+0x86>
      if(wait(0) != pid){
    414a:	4501                	li	a0,0
    414c:	00001097          	auipc	ra,0x1
    4150:	55e080e7          	jalr	1374(ra) # 56aa <wait>
    4154:	02951863          	bne	a0,s1,4184 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4158:	397d                	addiw	s2,s2,-1
    415a:	fe0910e3          	bnez	s2,413a <reparent+0x20>
  exit(0);
    415e:	4501                	li	a0,0
    4160:	00001097          	auipc	ra,0x1
    4164:	542080e7          	jalr	1346(ra) # 56a2 <exit>
      printf("%s: fork failed\n", s);
    4168:	85ce                	mv	a1,s3
    416a:	00002517          	auipc	a0,0x2
    416e:	5fe50513          	addi	a0,a0,1534 # 6768 <malloc+0xc88>
    4172:	00002097          	auipc	ra,0x2
    4176:	8b0080e7          	jalr	-1872(ra) # 5a22 <printf>
      exit(1);
    417a:	4505                	li	a0,1
    417c:	00001097          	auipc	ra,0x1
    4180:	526080e7          	jalr	1318(ra) # 56a2 <exit>
        printf("%s: wait wrong pid\n", s);
    4184:	85ce                	mv	a1,s3
    4186:	00002517          	auipc	a0,0x2
    418a:	76a50513          	addi	a0,a0,1898 # 68f0 <malloc+0xe10>
    418e:	00002097          	auipc	ra,0x2
    4192:	894080e7          	jalr	-1900(ra) # 5a22 <printf>
        exit(1);
    4196:	4505                	li	a0,1
    4198:	00001097          	auipc	ra,0x1
    419c:	50a080e7          	jalr	1290(ra) # 56a2 <exit>
      int pid2 = fork();
    41a0:	00001097          	auipc	ra,0x1
    41a4:	4fa080e7          	jalr	1274(ra) # 569a <fork>
      if(pid2 < 0){
    41a8:	00054763          	bltz	a0,41b6 <reparent+0x9c>
      exit(0);
    41ac:	4501                	li	a0,0
    41ae:	00001097          	auipc	ra,0x1
    41b2:	4f4080e7          	jalr	1268(ra) # 56a2 <exit>
        kill(master_pid);
    41b6:	8552                	mv	a0,s4
    41b8:	00001097          	auipc	ra,0x1
    41bc:	51a080e7          	jalr	1306(ra) # 56d2 <kill>
        exit(1);
    41c0:	4505                	li	a0,1
    41c2:	00001097          	auipc	ra,0x1
    41c6:	4e0080e7          	jalr	1248(ra) # 56a2 <exit>

00000000000041ca <sbrkfail>:
{
    41ca:	7119                	addi	sp,sp,-128
    41cc:	fc86                	sd	ra,120(sp)
    41ce:	f8a2                	sd	s0,112(sp)
    41d0:	f4a6                	sd	s1,104(sp)
    41d2:	f0ca                	sd	s2,96(sp)
    41d4:	ecce                	sd	s3,88(sp)
    41d6:	e8d2                	sd	s4,80(sp)
    41d8:	e4d6                	sd	s5,72(sp)
    41da:	0100                	addi	s0,sp,128
    41dc:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    41de:	fb040513          	addi	a0,s0,-80
    41e2:	00001097          	auipc	ra,0x1
    41e6:	4d0080e7          	jalr	1232(ra) # 56b2 <pipe>
    41ea:	e901                	bnez	a0,41fa <sbrkfail+0x30>
    41ec:	f8040493          	addi	s1,s0,-128
    41f0:	fa840993          	addi	s3,s0,-88
    41f4:	8926                	mv	s2,s1
    if(pids[i] != -1)
    41f6:	5a7d                	li	s4,-1
    41f8:	a085                	j	4258 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    41fa:	85d6                	mv	a1,s5
    41fc:	00002517          	auipc	a0,0x2
    4200:	67450513          	addi	a0,a0,1652 # 6870 <malloc+0xd90>
    4204:	00002097          	auipc	ra,0x2
    4208:	81e080e7          	jalr	-2018(ra) # 5a22 <printf>
    exit(1);
    420c:	4505                	li	a0,1
    420e:	00001097          	auipc	ra,0x1
    4212:	494080e7          	jalr	1172(ra) # 56a2 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4216:	00001097          	auipc	ra,0x1
    421a:	514080e7          	jalr	1300(ra) # 572a <sbrk>
    421e:	064007b7          	lui	a5,0x6400
    4222:	40a7853b          	subw	a0,a5,a0
    4226:	00001097          	auipc	ra,0x1
    422a:	504080e7          	jalr	1284(ra) # 572a <sbrk>
      write(fds[1], "x", 1);
    422e:	4605                	li	a2,1
    4230:	00002597          	auipc	a1,0x2
    4234:	d7058593          	addi	a1,a1,-656 # 5fa0 <malloc+0x4c0>
    4238:	fb442503          	lw	a0,-76(s0)
    423c:	00001097          	auipc	ra,0x1
    4240:	486080e7          	jalr	1158(ra) # 56c2 <write>
      for(;;) sleep(1000);
    4244:	3e800513          	li	a0,1000
    4248:	00001097          	auipc	ra,0x1
    424c:	4ea080e7          	jalr	1258(ra) # 5732 <sleep>
    4250:	bfd5                	j	4244 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4252:	0911                	addi	s2,s2,4
    4254:	03390563          	beq	s2,s3,427e <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4258:	00001097          	auipc	ra,0x1
    425c:	442080e7          	jalr	1090(ra) # 569a <fork>
    4260:	00a92023          	sw	a0,0(s2)
    4264:	d94d                	beqz	a0,4216 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4266:	ff4506e3          	beq	a0,s4,4252 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    426a:	4605                	li	a2,1
    426c:	faf40593          	addi	a1,s0,-81
    4270:	fb042503          	lw	a0,-80(s0)
    4274:	00001097          	auipc	ra,0x1
    4278:	446080e7          	jalr	1094(ra) # 56ba <read>
    427c:	bfd9                	j	4252 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    427e:	6505                	lui	a0,0x1
    4280:	00001097          	auipc	ra,0x1
    4284:	4aa080e7          	jalr	1194(ra) # 572a <sbrk>
    4288:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    428a:	597d                	li	s2,-1
    428c:	a021                	j	4294 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    428e:	0491                	addi	s1,s1,4
    4290:	01348f63          	beq	s1,s3,42ae <sbrkfail+0xe4>
    if(pids[i] == -1)
    4294:	4088                	lw	a0,0(s1)
    4296:	ff250ce3          	beq	a0,s2,428e <sbrkfail+0xc4>
    kill(pids[i]);
    429a:	00001097          	auipc	ra,0x1
    429e:	438080e7          	jalr	1080(ra) # 56d2 <kill>
    wait(0);
    42a2:	4501                	li	a0,0
    42a4:	00001097          	auipc	ra,0x1
    42a8:	406080e7          	jalr	1030(ra) # 56aa <wait>
    42ac:	b7cd                	j	428e <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    42ae:	57fd                	li	a5,-1
    42b0:	04fa0163          	beq	s4,a5,42f2 <sbrkfail+0x128>
  pid = fork();
    42b4:	00001097          	auipc	ra,0x1
    42b8:	3e6080e7          	jalr	998(ra) # 569a <fork>
    42bc:	84aa                	mv	s1,a0
  if(pid < 0){
    42be:	04054863          	bltz	a0,430e <sbrkfail+0x144>
  if(pid == 0){
    42c2:	c525                	beqz	a0,432a <sbrkfail+0x160>
  wait(&xstatus);
    42c4:	fbc40513          	addi	a0,s0,-68
    42c8:	00001097          	auipc	ra,0x1
    42cc:	3e2080e7          	jalr	994(ra) # 56aa <wait>
  if(xstatus != -1 && xstatus != 2)
    42d0:	fbc42783          	lw	a5,-68(s0)
    42d4:	577d                	li	a4,-1
    42d6:	00e78563          	beq	a5,a4,42e0 <sbrkfail+0x116>
    42da:	4709                	li	a4,2
    42dc:	08e79d63          	bne	a5,a4,4376 <sbrkfail+0x1ac>
}
    42e0:	70e6                	ld	ra,120(sp)
    42e2:	7446                	ld	s0,112(sp)
    42e4:	74a6                	ld	s1,104(sp)
    42e6:	7906                	ld	s2,96(sp)
    42e8:	69e6                	ld	s3,88(sp)
    42ea:	6a46                	ld	s4,80(sp)
    42ec:	6aa6                	ld	s5,72(sp)
    42ee:	6109                	addi	sp,sp,128
    42f0:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    42f2:	85d6                	mv	a1,s5
    42f4:	00003517          	auipc	a0,0x3
    42f8:	74c50513          	addi	a0,a0,1868 # 7a40 <malloc+0x1f60>
    42fc:	00001097          	auipc	ra,0x1
    4300:	726080e7          	jalr	1830(ra) # 5a22 <printf>
    exit(1);
    4304:	4505                	li	a0,1
    4306:	00001097          	auipc	ra,0x1
    430a:	39c080e7          	jalr	924(ra) # 56a2 <exit>
    printf("%s: fork failed\n", s);
    430e:	85d6                	mv	a1,s5
    4310:	00002517          	auipc	a0,0x2
    4314:	45850513          	addi	a0,a0,1112 # 6768 <malloc+0xc88>
    4318:	00001097          	auipc	ra,0x1
    431c:	70a080e7          	jalr	1802(ra) # 5a22 <printf>
    exit(1);
    4320:	4505                	li	a0,1
    4322:	00001097          	auipc	ra,0x1
    4326:	380080e7          	jalr	896(ra) # 56a2 <exit>
    a = sbrk(0);
    432a:	4501                	li	a0,0
    432c:	00001097          	auipc	ra,0x1
    4330:	3fe080e7          	jalr	1022(ra) # 572a <sbrk>
    4334:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4336:	3e800537          	lui	a0,0x3e800
    433a:	00001097          	auipc	ra,0x1
    433e:	3f0080e7          	jalr	1008(ra) # 572a <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4342:	87ca                	mv	a5,s2
    4344:	3e800737          	lui	a4,0x3e800
    4348:	993a                	add	s2,s2,a4
    434a:	6705                	lui	a4,0x1
      n += *(a+i);
    434c:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1478>
    4350:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4352:	97ba                	add	a5,a5,a4
    4354:	ff279ce3          	bne	a5,s2,434c <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4358:	8626                	mv	a2,s1
    435a:	85d6                	mv	a1,s5
    435c:	00003517          	auipc	a0,0x3
    4360:	70450513          	addi	a0,a0,1796 # 7a60 <malloc+0x1f80>
    4364:	00001097          	auipc	ra,0x1
    4368:	6be080e7          	jalr	1726(ra) # 5a22 <printf>
    exit(1);
    436c:	4505                	li	a0,1
    436e:	00001097          	auipc	ra,0x1
    4372:	334080e7          	jalr	820(ra) # 56a2 <exit>
    exit(1);
    4376:	4505                	li	a0,1
    4378:	00001097          	auipc	ra,0x1
    437c:	32a080e7          	jalr	810(ra) # 56a2 <exit>

0000000000004380 <mem>:
{
    4380:	7139                	addi	sp,sp,-64
    4382:	fc06                	sd	ra,56(sp)
    4384:	f822                	sd	s0,48(sp)
    4386:	f426                	sd	s1,40(sp)
    4388:	f04a                	sd	s2,32(sp)
    438a:	ec4e                	sd	s3,24(sp)
    438c:	0080                	addi	s0,sp,64
    438e:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4390:	00001097          	auipc	ra,0x1
    4394:	30a080e7          	jalr	778(ra) # 569a <fork>
    m1 = 0;
    4398:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    439a:	6909                	lui	s2,0x2
    439c:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x157>
  if((pid = fork()) == 0){
    43a0:	c115                	beqz	a0,43c4 <mem+0x44>
    wait(&xstatus);
    43a2:	fcc40513          	addi	a0,s0,-52
    43a6:	00001097          	auipc	ra,0x1
    43aa:	304080e7          	jalr	772(ra) # 56aa <wait>
    if(xstatus == -1){
    43ae:	fcc42503          	lw	a0,-52(s0)
    43b2:	57fd                	li	a5,-1
    43b4:	06f50363          	beq	a0,a5,441a <mem+0x9a>
    exit(xstatus);
    43b8:	00001097          	auipc	ra,0x1
    43bc:	2ea080e7          	jalr	746(ra) # 56a2 <exit>
      *(char**)m2 = m1;
    43c0:	e104                	sd	s1,0(a0)
      m1 = m2;
    43c2:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    43c4:	854a                	mv	a0,s2
    43c6:	00001097          	auipc	ra,0x1
    43ca:	71a080e7          	jalr	1818(ra) # 5ae0 <malloc>
    43ce:	f96d                	bnez	a0,43c0 <mem+0x40>
    while(m1){
    43d0:	c881                	beqz	s1,43e0 <mem+0x60>
      m2 = *(char**)m1;
    43d2:	8526                	mv	a0,s1
    43d4:	6084                	ld	s1,0(s1)
      free(m1);
    43d6:	00001097          	auipc	ra,0x1
    43da:	682080e7          	jalr	1666(ra) # 5a58 <free>
    while(m1){
    43de:	f8f5                	bnez	s1,43d2 <mem+0x52>
    m1 = malloc(1024*20);
    43e0:	6515                	lui	a0,0x5
    43e2:	00001097          	auipc	ra,0x1
    43e6:	6fe080e7          	jalr	1790(ra) # 5ae0 <malloc>
    if(m1 == 0){
    43ea:	c911                	beqz	a0,43fe <mem+0x7e>
    free(m1);
    43ec:	00001097          	auipc	ra,0x1
    43f0:	66c080e7          	jalr	1644(ra) # 5a58 <free>
    exit(0);
    43f4:	4501                	li	a0,0
    43f6:	00001097          	auipc	ra,0x1
    43fa:	2ac080e7          	jalr	684(ra) # 56a2 <exit>
      printf("couldn't allocate mem?!!\n", s);
    43fe:	85ce                	mv	a1,s3
    4400:	00003517          	auipc	a0,0x3
    4404:	69050513          	addi	a0,a0,1680 # 7a90 <malloc+0x1fb0>
    4408:	00001097          	auipc	ra,0x1
    440c:	61a080e7          	jalr	1562(ra) # 5a22 <printf>
      exit(1);
    4410:	4505                	li	a0,1
    4412:	00001097          	auipc	ra,0x1
    4416:	290080e7          	jalr	656(ra) # 56a2 <exit>
      exit(0);
    441a:	4501                	li	a0,0
    441c:	00001097          	auipc	ra,0x1
    4420:	286080e7          	jalr	646(ra) # 56a2 <exit>

0000000000004424 <sharedfd>:
{
    4424:	7159                	addi	sp,sp,-112
    4426:	f486                	sd	ra,104(sp)
    4428:	f0a2                	sd	s0,96(sp)
    442a:	eca6                	sd	s1,88(sp)
    442c:	e8ca                	sd	s2,80(sp)
    442e:	e4ce                	sd	s3,72(sp)
    4430:	e0d2                	sd	s4,64(sp)
    4432:	fc56                	sd	s5,56(sp)
    4434:	f85a                	sd	s6,48(sp)
    4436:	f45e                	sd	s7,40(sp)
    4438:	1880                	addi	s0,sp,112
    443a:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    443c:	00002517          	auipc	a0,0x2
    4440:	92450513          	addi	a0,a0,-1756 # 5d60 <malloc+0x280>
    4444:	00001097          	auipc	ra,0x1
    4448:	2ae080e7          	jalr	686(ra) # 56f2 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    444c:	20200593          	li	a1,514
    4450:	00002517          	auipc	a0,0x2
    4454:	91050513          	addi	a0,a0,-1776 # 5d60 <malloc+0x280>
    4458:	00001097          	auipc	ra,0x1
    445c:	28a080e7          	jalr	650(ra) # 56e2 <open>
  if(fd < 0){
    4460:	04054a63          	bltz	a0,44b4 <sharedfd+0x90>
    4464:	892a                	mv	s2,a0
  pid = fork();
    4466:	00001097          	auipc	ra,0x1
    446a:	234080e7          	jalr	564(ra) # 569a <fork>
    446e:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4470:	06300593          	li	a1,99
    4474:	c119                	beqz	a0,447a <sharedfd+0x56>
    4476:	07000593          	li	a1,112
    447a:	4629                	li	a2,10
    447c:	fa040513          	addi	a0,s0,-96
    4480:	00001097          	auipc	ra,0x1
    4484:	026080e7          	jalr	38(ra) # 54a6 <memset>
    4488:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    448c:	4629                	li	a2,10
    448e:	fa040593          	addi	a1,s0,-96
    4492:	854a                	mv	a0,s2
    4494:	00001097          	auipc	ra,0x1
    4498:	22e080e7          	jalr	558(ra) # 56c2 <write>
    449c:	47a9                	li	a5,10
    449e:	02f51963          	bne	a0,a5,44d0 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    44a2:	34fd                	addiw	s1,s1,-1
    44a4:	f4e5                	bnez	s1,448c <sharedfd+0x68>
  if(pid == 0) {
    44a6:	04099363          	bnez	s3,44ec <sharedfd+0xc8>
    exit(0);
    44aa:	4501                	li	a0,0
    44ac:	00001097          	auipc	ra,0x1
    44b0:	1f6080e7          	jalr	502(ra) # 56a2 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    44b4:	85d2                	mv	a1,s4
    44b6:	00003517          	auipc	a0,0x3
    44ba:	5fa50513          	addi	a0,a0,1530 # 7ab0 <malloc+0x1fd0>
    44be:	00001097          	auipc	ra,0x1
    44c2:	564080e7          	jalr	1380(ra) # 5a22 <printf>
    exit(1);
    44c6:	4505                	li	a0,1
    44c8:	00001097          	auipc	ra,0x1
    44cc:	1da080e7          	jalr	474(ra) # 56a2 <exit>
      printf("%s: write sharedfd failed\n", s);
    44d0:	85d2                	mv	a1,s4
    44d2:	00003517          	auipc	a0,0x3
    44d6:	60650513          	addi	a0,a0,1542 # 7ad8 <malloc+0x1ff8>
    44da:	00001097          	auipc	ra,0x1
    44de:	548080e7          	jalr	1352(ra) # 5a22 <printf>
      exit(1);
    44e2:	4505                	li	a0,1
    44e4:	00001097          	auipc	ra,0x1
    44e8:	1be080e7          	jalr	446(ra) # 56a2 <exit>
    wait(&xstatus);
    44ec:	f9c40513          	addi	a0,s0,-100
    44f0:	00001097          	auipc	ra,0x1
    44f4:	1ba080e7          	jalr	442(ra) # 56aa <wait>
    if(xstatus != 0)
    44f8:	f9c42983          	lw	s3,-100(s0)
    44fc:	00098763          	beqz	s3,450a <sharedfd+0xe6>
      exit(xstatus);
    4500:	854e                	mv	a0,s3
    4502:	00001097          	auipc	ra,0x1
    4506:	1a0080e7          	jalr	416(ra) # 56a2 <exit>
  close(fd);
    450a:	854a                	mv	a0,s2
    450c:	00001097          	auipc	ra,0x1
    4510:	1be080e7          	jalr	446(ra) # 56ca <close>
  fd = open("sharedfd", 0);
    4514:	4581                	li	a1,0
    4516:	00002517          	auipc	a0,0x2
    451a:	84a50513          	addi	a0,a0,-1974 # 5d60 <malloc+0x280>
    451e:	00001097          	auipc	ra,0x1
    4522:	1c4080e7          	jalr	452(ra) # 56e2 <open>
    4526:	8baa                	mv	s7,a0
  nc = np = 0;
    4528:	8ace                	mv	s5,s3
  if(fd < 0){
    452a:	02054563          	bltz	a0,4554 <sharedfd+0x130>
    452e:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4532:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4536:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    453a:	4629                	li	a2,10
    453c:	fa040593          	addi	a1,s0,-96
    4540:	855e                	mv	a0,s7
    4542:	00001097          	auipc	ra,0x1
    4546:	178080e7          	jalr	376(ra) # 56ba <read>
    454a:	02a05f63          	blez	a0,4588 <sharedfd+0x164>
    454e:	fa040793          	addi	a5,s0,-96
    4552:	a01d                	j	4578 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4554:	85d2                	mv	a1,s4
    4556:	00003517          	auipc	a0,0x3
    455a:	5a250513          	addi	a0,a0,1442 # 7af8 <malloc+0x2018>
    455e:	00001097          	auipc	ra,0x1
    4562:	4c4080e7          	jalr	1220(ra) # 5a22 <printf>
    exit(1);
    4566:	4505                	li	a0,1
    4568:	00001097          	auipc	ra,0x1
    456c:	13a080e7          	jalr	314(ra) # 56a2 <exit>
        nc++;
    4570:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4572:	0785                	addi	a5,a5,1
    4574:	fd2783e3          	beq	a5,s2,453a <sharedfd+0x116>
      if(buf[i] == 'c')
    4578:	0007c703          	lbu	a4,0(a5)
    457c:	fe970ae3          	beq	a4,s1,4570 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4580:	ff6719e3          	bne	a4,s6,4572 <sharedfd+0x14e>
        np++;
    4584:	2a85                	addiw	s5,s5,1
    4586:	b7f5                	j	4572 <sharedfd+0x14e>
  close(fd);
    4588:	855e                	mv	a0,s7
    458a:	00001097          	auipc	ra,0x1
    458e:	140080e7          	jalr	320(ra) # 56ca <close>
  unlink("sharedfd");
    4592:	00001517          	auipc	a0,0x1
    4596:	7ce50513          	addi	a0,a0,1998 # 5d60 <malloc+0x280>
    459a:	00001097          	auipc	ra,0x1
    459e:	158080e7          	jalr	344(ra) # 56f2 <unlink>
  if(nc == N*SZ && np == N*SZ){
    45a2:	6789                	lui	a5,0x2
    45a4:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x156>
    45a8:	00f99763          	bne	s3,a5,45b6 <sharedfd+0x192>
    45ac:	6789                	lui	a5,0x2
    45ae:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x156>
    45b2:	02fa8063          	beq	s5,a5,45d2 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    45b6:	85d2                	mv	a1,s4
    45b8:	00003517          	auipc	a0,0x3
    45bc:	56850513          	addi	a0,a0,1384 # 7b20 <malloc+0x2040>
    45c0:	00001097          	auipc	ra,0x1
    45c4:	462080e7          	jalr	1122(ra) # 5a22 <printf>
    exit(1);
    45c8:	4505                	li	a0,1
    45ca:	00001097          	auipc	ra,0x1
    45ce:	0d8080e7          	jalr	216(ra) # 56a2 <exit>
    exit(0);
    45d2:	4501                	li	a0,0
    45d4:	00001097          	auipc	ra,0x1
    45d8:	0ce080e7          	jalr	206(ra) # 56a2 <exit>

00000000000045dc <fourfiles>:
{
    45dc:	7171                	addi	sp,sp,-176
    45de:	f506                	sd	ra,168(sp)
    45e0:	f122                	sd	s0,160(sp)
    45e2:	ed26                	sd	s1,152(sp)
    45e4:	e94a                	sd	s2,144(sp)
    45e6:	e54e                	sd	s3,136(sp)
    45e8:	e152                	sd	s4,128(sp)
    45ea:	fcd6                	sd	s5,120(sp)
    45ec:	f8da                	sd	s6,112(sp)
    45ee:	f4de                	sd	s7,104(sp)
    45f0:	f0e2                	sd	s8,96(sp)
    45f2:	ece6                	sd	s9,88(sp)
    45f4:	e8ea                	sd	s10,80(sp)
    45f6:	e4ee                	sd	s11,72(sp)
    45f8:	1900                	addi	s0,sp,176
    45fa:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    45fe:	00001797          	auipc	a5,0x1
    4602:	5ca78793          	addi	a5,a5,1482 # 5bc8 <malloc+0xe8>
    4606:	f6f43823          	sd	a5,-144(s0)
    460a:	00001797          	auipc	a5,0x1
    460e:	5c678793          	addi	a5,a5,1478 # 5bd0 <malloc+0xf0>
    4612:	f6f43c23          	sd	a5,-136(s0)
    4616:	00001797          	auipc	a5,0x1
    461a:	5c278793          	addi	a5,a5,1474 # 5bd8 <malloc+0xf8>
    461e:	f8f43023          	sd	a5,-128(s0)
    4622:	00001797          	auipc	a5,0x1
    4626:	5be78793          	addi	a5,a5,1470 # 5be0 <malloc+0x100>
    462a:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    462e:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4632:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    4634:	4481                	li	s1,0
    4636:	4a11                	li	s4,4
    fname = names[pi];
    4638:	00093983          	ld	s3,0(s2)
    unlink(fname);
    463c:	854e                	mv	a0,s3
    463e:	00001097          	auipc	ra,0x1
    4642:	0b4080e7          	jalr	180(ra) # 56f2 <unlink>
    pid = fork();
    4646:	00001097          	auipc	ra,0x1
    464a:	054080e7          	jalr	84(ra) # 569a <fork>
    if(pid < 0){
    464e:	04054463          	bltz	a0,4696 <fourfiles+0xba>
    if(pid == 0){
    4652:	c12d                	beqz	a0,46b4 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    4654:	2485                	addiw	s1,s1,1
    4656:	0921                	addi	s2,s2,8
    4658:	ff4490e3          	bne	s1,s4,4638 <fourfiles+0x5c>
    465c:	4491                	li	s1,4
    wait(&xstatus);
    465e:	f6c40513          	addi	a0,s0,-148
    4662:	00001097          	auipc	ra,0x1
    4666:	048080e7          	jalr	72(ra) # 56aa <wait>
    if(xstatus != 0)
    466a:	f6c42b03          	lw	s6,-148(s0)
    466e:	0c0b1e63          	bnez	s6,474a <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    4672:	34fd                	addiw	s1,s1,-1
    4674:	f4ed                	bnez	s1,465e <fourfiles+0x82>
    4676:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    467a:	00007a17          	auipc	s4,0x7
    467e:	4fea0a13          	addi	s4,s4,1278 # bb78 <buf>
    4682:	00007a97          	auipc	s5,0x7
    4686:	4f7a8a93          	addi	s5,s5,1271 # bb79 <buf+0x1>
    if(total != N*SZ){
    468a:	6d85                	lui	s11,0x1
    468c:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0x30>
  for(i = 0; i < NCHILD; i++){
    4690:	03400d13          	li	s10,52
    4694:	aa1d                	j	47ca <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4696:	f5843583          	ld	a1,-168(s0)
    469a:	00002517          	auipc	a0,0x2
    469e:	4d650513          	addi	a0,a0,1238 # 6b70 <malloc+0x1090>
    46a2:	00001097          	auipc	ra,0x1
    46a6:	380080e7          	jalr	896(ra) # 5a22 <printf>
      exit(1);
    46aa:	4505                	li	a0,1
    46ac:	00001097          	auipc	ra,0x1
    46b0:	ff6080e7          	jalr	-10(ra) # 56a2 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    46b4:	20200593          	li	a1,514
    46b8:	854e                	mv	a0,s3
    46ba:	00001097          	auipc	ra,0x1
    46be:	028080e7          	jalr	40(ra) # 56e2 <open>
    46c2:	892a                	mv	s2,a0
      if(fd < 0){
    46c4:	04054763          	bltz	a0,4712 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    46c8:	1f400613          	li	a2,500
    46cc:	0304859b          	addiw	a1,s1,48
    46d0:	00007517          	auipc	a0,0x7
    46d4:	4a850513          	addi	a0,a0,1192 # bb78 <buf>
    46d8:	00001097          	auipc	ra,0x1
    46dc:	dce080e7          	jalr	-562(ra) # 54a6 <memset>
    46e0:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    46e2:	00007997          	auipc	s3,0x7
    46e6:	49698993          	addi	s3,s3,1174 # bb78 <buf>
    46ea:	1f400613          	li	a2,500
    46ee:	85ce                	mv	a1,s3
    46f0:	854a                	mv	a0,s2
    46f2:	00001097          	auipc	ra,0x1
    46f6:	fd0080e7          	jalr	-48(ra) # 56c2 <write>
    46fa:	85aa                	mv	a1,a0
    46fc:	1f400793          	li	a5,500
    4700:	02f51863          	bne	a0,a5,4730 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    4704:	34fd                	addiw	s1,s1,-1
    4706:	f0f5                	bnez	s1,46ea <fourfiles+0x10e>
      exit(0);
    4708:	4501                	li	a0,0
    470a:	00001097          	auipc	ra,0x1
    470e:	f98080e7          	jalr	-104(ra) # 56a2 <exit>
        printf("create failed\n", s);
    4712:	f5843583          	ld	a1,-168(s0)
    4716:	00003517          	auipc	a0,0x3
    471a:	42250513          	addi	a0,a0,1058 # 7b38 <malloc+0x2058>
    471e:	00001097          	auipc	ra,0x1
    4722:	304080e7          	jalr	772(ra) # 5a22 <printf>
        exit(1);
    4726:	4505                	li	a0,1
    4728:	00001097          	auipc	ra,0x1
    472c:	f7a080e7          	jalr	-134(ra) # 56a2 <exit>
          printf("write failed %d\n", n);
    4730:	00003517          	auipc	a0,0x3
    4734:	41850513          	addi	a0,a0,1048 # 7b48 <malloc+0x2068>
    4738:	00001097          	auipc	ra,0x1
    473c:	2ea080e7          	jalr	746(ra) # 5a22 <printf>
          exit(1);
    4740:	4505                	li	a0,1
    4742:	00001097          	auipc	ra,0x1
    4746:	f60080e7          	jalr	-160(ra) # 56a2 <exit>
      exit(xstatus);
    474a:	855a                	mv	a0,s6
    474c:	00001097          	auipc	ra,0x1
    4750:	f56080e7          	jalr	-170(ra) # 56a2 <exit>
          printf("wrong char\n", s);
    4754:	f5843583          	ld	a1,-168(s0)
    4758:	00003517          	auipc	a0,0x3
    475c:	40850513          	addi	a0,a0,1032 # 7b60 <malloc+0x2080>
    4760:	00001097          	auipc	ra,0x1
    4764:	2c2080e7          	jalr	706(ra) # 5a22 <printf>
          exit(1);
    4768:	4505                	li	a0,1
    476a:	00001097          	auipc	ra,0x1
    476e:	f38080e7          	jalr	-200(ra) # 56a2 <exit>
      total += n;
    4772:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4776:	660d                	lui	a2,0x3
    4778:	85d2                	mv	a1,s4
    477a:	854e                	mv	a0,s3
    477c:	00001097          	auipc	ra,0x1
    4780:	f3e080e7          	jalr	-194(ra) # 56ba <read>
    4784:	02a05363          	blez	a0,47aa <fourfiles+0x1ce>
    4788:	00007797          	auipc	a5,0x7
    478c:	3f078793          	addi	a5,a5,1008 # bb78 <buf>
    4790:	fff5069b          	addiw	a3,a0,-1
    4794:	1682                	slli	a3,a3,0x20
    4796:	9281                	srli	a3,a3,0x20
    4798:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    479a:	0007c703          	lbu	a4,0(a5)
    479e:	fa971be3          	bne	a4,s1,4754 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    47a2:	0785                	addi	a5,a5,1
    47a4:	fed79be3          	bne	a5,a3,479a <fourfiles+0x1be>
    47a8:	b7e9                	j	4772 <fourfiles+0x196>
    close(fd);
    47aa:	854e                	mv	a0,s3
    47ac:	00001097          	auipc	ra,0x1
    47b0:	f1e080e7          	jalr	-226(ra) # 56ca <close>
    if(total != N*SZ){
    47b4:	03b91863          	bne	s2,s11,47e4 <fourfiles+0x208>
    unlink(fname);
    47b8:	8566                	mv	a0,s9
    47ba:	00001097          	auipc	ra,0x1
    47be:	f38080e7          	jalr	-200(ra) # 56f2 <unlink>
  for(i = 0; i < NCHILD; i++){
    47c2:	0c21                	addi	s8,s8,8
    47c4:	2b85                	addiw	s7,s7,1
    47c6:	03ab8d63          	beq	s7,s10,4800 <fourfiles+0x224>
    fname = names[i];
    47ca:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    47ce:	4581                	li	a1,0
    47d0:	8566                	mv	a0,s9
    47d2:	00001097          	auipc	ra,0x1
    47d6:	f10080e7          	jalr	-240(ra) # 56e2 <open>
    47da:	89aa                	mv	s3,a0
    total = 0;
    47dc:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    47de:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    47e2:	bf51                	j	4776 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    47e4:	85ca                	mv	a1,s2
    47e6:	00003517          	auipc	a0,0x3
    47ea:	38a50513          	addi	a0,a0,906 # 7b70 <malloc+0x2090>
    47ee:	00001097          	auipc	ra,0x1
    47f2:	234080e7          	jalr	564(ra) # 5a22 <printf>
      exit(1);
    47f6:	4505                	li	a0,1
    47f8:	00001097          	auipc	ra,0x1
    47fc:	eaa080e7          	jalr	-342(ra) # 56a2 <exit>
}
    4800:	70aa                	ld	ra,168(sp)
    4802:	740a                	ld	s0,160(sp)
    4804:	64ea                	ld	s1,152(sp)
    4806:	694a                	ld	s2,144(sp)
    4808:	69aa                	ld	s3,136(sp)
    480a:	6a0a                	ld	s4,128(sp)
    480c:	7ae6                	ld	s5,120(sp)
    480e:	7b46                	ld	s6,112(sp)
    4810:	7ba6                	ld	s7,104(sp)
    4812:	7c06                	ld	s8,96(sp)
    4814:	6ce6                	ld	s9,88(sp)
    4816:	6d46                	ld	s10,80(sp)
    4818:	6da6                	ld	s11,72(sp)
    481a:	614d                	addi	sp,sp,176
    481c:	8082                	ret

000000000000481e <concreate>:
{
    481e:	7135                	addi	sp,sp,-160
    4820:	ed06                	sd	ra,152(sp)
    4822:	e922                	sd	s0,144(sp)
    4824:	e526                	sd	s1,136(sp)
    4826:	e14a                	sd	s2,128(sp)
    4828:	fcce                	sd	s3,120(sp)
    482a:	f8d2                	sd	s4,112(sp)
    482c:	f4d6                	sd	s5,104(sp)
    482e:	f0da                	sd	s6,96(sp)
    4830:	ecde                	sd	s7,88(sp)
    4832:	1100                	addi	s0,sp,160
    4834:	89aa                	mv	s3,a0
  file[0] = 'C';
    4836:	04300793          	li	a5,67
    483a:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    483e:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4842:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4844:	4b0d                	li	s6,3
    4846:	4a85                	li	s5,1
      link("C0", file);
    4848:	00003b97          	auipc	s7,0x3
    484c:	340b8b93          	addi	s7,s7,832 # 7b88 <malloc+0x20a8>
  for(i = 0; i < N; i++){
    4850:	02800a13          	li	s4,40
    4854:	acc1                	j	4b24 <concreate+0x306>
      link("C0", file);
    4856:	fa840593          	addi	a1,s0,-88
    485a:	855e                	mv	a0,s7
    485c:	00001097          	auipc	ra,0x1
    4860:	ea6080e7          	jalr	-346(ra) # 5702 <link>
    if(pid == 0) {
    4864:	a45d                	j	4b0a <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4866:	4795                	li	a5,5
    4868:	02f9693b          	remw	s2,s2,a5
    486c:	4785                	li	a5,1
    486e:	02f90b63          	beq	s2,a5,48a4 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4872:	20200593          	li	a1,514
    4876:	fa840513          	addi	a0,s0,-88
    487a:	00001097          	auipc	ra,0x1
    487e:	e68080e7          	jalr	-408(ra) # 56e2 <open>
      if(fd < 0){
    4882:	26055b63          	bgez	a0,4af8 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4886:	fa840593          	addi	a1,s0,-88
    488a:	00003517          	auipc	a0,0x3
    488e:	30650513          	addi	a0,a0,774 # 7b90 <malloc+0x20b0>
    4892:	00001097          	auipc	ra,0x1
    4896:	190080e7          	jalr	400(ra) # 5a22 <printf>
        exit(1);
    489a:	4505                	li	a0,1
    489c:	00001097          	auipc	ra,0x1
    48a0:	e06080e7          	jalr	-506(ra) # 56a2 <exit>
      link("C0", file);
    48a4:	fa840593          	addi	a1,s0,-88
    48a8:	00003517          	auipc	a0,0x3
    48ac:	2e050513          	addi	a0,a0,736 # 7b88 <malloc+0x20a8>
    48b0:	00001097          	auipc	ra,0x1
    48b4:	e52080e7          	jalr	-430(ra) # 5702 <link>
      exit(0);
    48b8:	4501                	li	a0,0
    48ba:	00001097          	auipc	ra,0x1
    48be:	de8080e7          	jalr	-536(ra) # 56a2 <exit>
        exit(1);
    48c2:	4505                	li	a0,1
    48c4:	00001097          	auipc	ra,0x1
    48c8:	dde080e7          	jalr	-546(ra) # 56a2 <exit>
  memset(fa, 0, sizeof(fa));
    48cc:	02800613          	li	a2,40
    48d0:	4581                	li	a1,0
    48d2:	f8040513          	addi	a0,s0,-128
    48d6:	00001097          	auipc	ra,0x1
    48da:	bd0080e7          	jalr	-1072(ra) # 54a6 <memset>
  fd = open(".", 0);
    48de:	4581                	li	a1,0
    48e0:	00002517          	auipc	a0,0x2
    48e4:	ce850513          	addi	a0,a0,-792 # 65c8 <malloc+0xae8>
    48e8:	00001097          	auipc	ra,0x1
    48ec:	dfa080e7          	jalr	-518(ra) # 56e2 <open>
    48f0:	892a                	mv	s2,a0
  n = 0;
    48f2:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    48f4:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    48f8:	02700b13          	li	s6,39
      fa[i] = 1;
    48fc:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    48fe:	4641                	li	a2,16
    4900:	f7040593          	addi	a1,s0,-144
    4904:	854a                	mv	a0,s2
    4906:	00001097          	auipc	ra,0x1
    490a:	db4080e7          	jalr	-588(ra) # 56ba <read>
    490e:	08a05163          	blez	a0,4990 <concreate+0x172>
    if(de.inum == 0)
    4912:	f7045783          	lhu	a5,-144(s0)
    4916:	d7e5                	beqz	a5,48fe <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4918:	f7244783          	lbu	a5,-142(s0)
    491c:	ff4791e3          	bne	a5,s4,48fe <concreate+0xe0>
    4920:	f7444783          	lbu	a5,-140(s0)
    4924:	ffe9                	bnez	a5,48fe <concreate+0xe0>
      i = de.name[1] - '0';
    4926:	f7344783          	lbu	a5,-141(s0)
    492a:	fd07879b          	addiw	a5,a5,-48
    492e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4932:	00eb6f63          	bltu	s6,a4,4950 <concreate+0x132>
      if(fa[i]){
    4936:	fb040793          	addi	a5,s0,-80
    493a:	97ba                	add	a5,a5,a4
    493c:	fd07c783          	lbu	a5,-48(a5)
    4940:	eb85                	bnez	a5,4970 <concreate+0x152>
      fa[i] = 1;
    4942:	fb040793          	addi	a5,s0,-80
    4946:	973e                	add	a4,a4,a5
    4948:	fd770823          	sb	s7,-48(a4) # fd0 <bigdir+0x6c>
      n++;
    494c:	2a85                	addiw	s5,s5,1
    494e:	bf45                	j	48fe <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4950:	f7240613          	addi	a2,s0,-142
    4954:	85ce                	mv	a1,s3
    4956:	00003517          	auipc	a0,0x3
    495a:	25a50513          	addi	a0,a0,602 # 7bb0 <malloc+0x20d0>
    495e:	00001097          	auipc	ra,0x1
    4962:	0c4080e7          	jalr	196(ra) # 5a22 <printf>
        exit(1);
    4966:	4505                	li	a0,1
    4968:	00001097          	auipc	ra,0x1
    496c:	d3a080e7          	jalr	-710(ra) # 56a2 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4970:	f7240613          	addi	a2,s0,-142
    4974:	85ce                	mv	a1,s3
    4976:	00003517          	auipc	a0,0x3
    497a:	25a50513          	addi	a0,a0,602 # 7bd0 <malloc+0x20f0>
    497e:	00001097          	auipc	ra,0x1
    4982:	0a4080e7          	jalr	164(ra) # 5a22 <printf>
        exit(1);
    4986:	4505                	li	a0,1
    4988:	00001097          	auipc	ra,0x1
    498c:	d1a080e7          	jalr	-742(ra) # 56a2 <exit>
  close(fd);
    4990:	854a                	mv	a0,s2
    4992:	00001097          	auipc	ra,0x1
    4996:	d38080e7          	jalr	-712(ra) # 56ca <close>
  if(n != N){
    499a:	02800793          	li	a5,40
    499e:	00fa9763          	bne	s5,a5,49ac <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    49a2:	4a8d                	li	s5,3
    49a4:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    49a6:	02800a13          	li	s4,40
    49aa:	a8c9                	j	4a7c <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    49ac:	85ce                	mv	a1,s3
    49ae:	00003517          	auipc	a0,0x3
    49b2:	24a50513          	addi	a0,a0,586 # 7bf8 <malloc+0x2118>
    49b6:	00001097          	auipc	ra,0x1
    49ba:	06c080e7          	jalr	108(ra) # 5a22 <printf>
    exit(1);
    49be:	4505                	li	a0,1
    49c0:	00001097          	auipc	ra,0x1
    49c4:	ce2080e7          	jalr	-798(ra) # 56a2 <exit>
      printf("%s: fork failed\n", s);
    49c8:	85ce                	mv	a1,s3
    49ca:	00002517          	auipc	a0,0x2
    49ce:	d9e50513          	addi	a0,a0,-610 # 6768 <malloc+0xc88>
    49d2:	00001097          	auipc	ra,0x1
    49d6:	050080e7          	jalr	80(ra) # 5a22 <printf>
      exit(1);
    49da:	4505                	li	a0,1
    49dc:	00001097          	auipc	ra,0x1
    49e0:	cc6080e7          	jalr	-826(ra) # 56a2 <exit>
      close(open(file, 0));
    49e4:	4581                	li	a1,0
    49e6:	fa840513          	addi	a0,s0,-88
    49ea:	00001097          	auipc	ra,0x1
    49ee:	cf8080e7          	jalr	-776(ra) # 56e2 <open>
    49f2:	00001097          	auipc	ra,0x1
    49f6:	cd8080e7          	jalr	-808(ra) # 56ca <close>
      close(open(file, 0));
    49fa:	4581                	li	a1,0
    49fc:	fa840513          	addi	a0,s0,-88
    4a00:	00001097          	auipc	ra,0x1
    4a04:	ce2080e7          	jalr	-798(ra) # 56e2 <open>
    4a08:	00001097          	auipc	ra,0x1
    4a0c:	cc2080e7          	jalr	-830(ra) # 56ca <close>
      close(open(file, 0));
    4a10:	4581                	li	a1,0
    4a12:	fa840513          	addi	a0,s0,-88
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	ccc080e7          	jalr	-820(ra) # 56e2 <open>
    4a1e:	00001097          	auipc	ra,0x1
    4a22:	cac080e7          	jalr	-852(ra) # 56ca <close>
      close(open(file, 0));
    4a26:	4581                	li	a1,0
    4a28:	fa840513          	addi	a0,s0,-88
    4a2c:	00001097          	auipc	ra,0x1
    4a30:	cb6080e7          	jalr	-842(ra) # 56e2 <open>
    4a34:	00001097          	auipc	ra,0x1
    4a38:	c96080e7          	jalr	-874(ra) # 56ca <close>
      close(open(file, 0));
    4a3c:	4581                	li	a1,0
    4a3e:	fa840513          	addi	a0,s0,-88
    4a42:	00001097          	auipc	ra,0x1
    4a46:	ca0080e7          	jalr	-864(ra) # 56e2 <open>
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	c80080e7          	jalr	-896(ra) # 56ca <close>
      close(open(file, 0));
    4a52:	4581                	li	a1,0
    4a54:	fa840513          	addi	a0,s0,-88
    4a58:	00001097          	auipc	ra,0x1
    4a5c:	c8a080e7          	jalr	-886(ra) # 56e2 <open>
    4a60:	00001097          	auipc	ra,0x1
    4a64:	c6a080e7          	jalr	-918(ra) # 56ca <close>
    if(pid == 0)
    4a68:	08090363          	beqz	s2,4aee <concreate+0x2d0>
      wait(0);
    4a6c:	4501                	li	a0,0
    4a6e:	00001097          	auipc	ra,0x1
    4a72:	c3c080e7          	jalr	-964(ra) # 56aa <wait>
  for(i = 0; i < N; i++){
    4a76:	2485                	addiw	s1,s1,1
    4a78:	0f448563          	beq	s1,s4,4b62 <concreate+0x344>
    file[1] = '0' + i;
    4a7c:	0304879b          	addiw	a5,s1,48
    4a80:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4a84:	00001097          	auipc	ra,0x1
    4a88:	c16080e7          	jalr	-1002(ra) # 569a <fork>
    4a8c:	892a                	mv	s2,a0
    if(pid < 0){
    4a8e:	f2054de3          	bltz	a0,49c8 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4a92:	0354e73b          	remw	a4,s1,s5
    4a96:	00a767b3          	or	a5,a4,a0
    4a9a:	2781                	sext.w	a5,a5
    4a9c:	d7a1                	beqz	a5,49e4 <concreate+0x1c6>
    4a9e:	01671363          	bne	a4,s6,4aa4 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4aa2:	f129                	bnez	a0,49e4 <concreate+0x1c6>
      unlink(file);
    4aa4:	fa840513          	addi	a0,s0,-88
    4aa8:	00001097          	auipc	ra,0x1
    4aac:	c4a080e7          	jalr	-950(ra) # 56f2 <unlink>
      unlink(file);
    4ab0:	fa840513          	addi	a0,s0,-88
    4ab4:	00001097          	auipc	ra,0x1
    4ab8:	c3e080e7          	jalr	-962(ra) # 56f2 <unlink>
      unlink(file);
    4abc:	fa840513          	addi	a0,s0,-88
    4ac0:	00001097          	auipc	ra,0x1
    4ac4:	c32080e7          	jalr	-974(ra) # 56f2 <unlink>
      unlink(file);
    4ac8:	fa840513          	addi	a0,s0,-88
    4acc:	00001097          	auipc	ra,0x1
    4ad0:	c26080e7          	jalr	-986(ra) # 56f2 <unlink>
      unlink(file);
    4ad4:	fa840513          	addi	a0,s0,-88
    4ad8:	00001097          	auipc	ra,0x1
    4adc:	c1a080e7          	jalr	-998(ra) # 56f2 <unlink>
      unlink(file);
    4ae0:	fa840513          	addi	a0,s0,-88
    4ae4:	00001097          	auipc	ra,0x1
    4ae8:	c0e080e7          	jalr	-1010(ra) # 56f2 <unlink>
    4aec:	bfb5                	j	4a68 <concreate+0x24a>
      exit(0);
    4aee:	4501                	li	a0,0
    4af0:	00001097          	auipc	ra,0x1
    4af4:	bb2080e7          	jalr	-1102(ra) # 56a2 <exit>
      close(fd);
    4af8:	00001097          	auipc	ra,0x1
    4afc:	bd2080e7          	jalr	-1070(ra) # 56ca <close>
    if(pid == 0) {
    4b00:	bb65                	j	48b8 <concreate+0x9a>
      close(fd);
    4b02:	00001097          	auipc	ra,0x1
    4b06:	bc8080e7          	jalr	-1080(ra) # 56ca <close>
      wait(&xstatus);
    4b0a:	f6c40513          	addi	a0,s0,-148
    4b0e:	00001097          	auipc	ra,0x1
    4b12:	b9c080e7          	jalr	-1124(ra) # 56aa <wait>
      if(xstatus != 0)
    4b16:	f6c42483          	lw	s1,-148(s0)
    4b1a:	da0494e3          	bnez	s1,48c2 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4b1e:	2905                	addiw	s2,s2,1
    4b20:	db4906e3          	beq	s2,s4,48cc <concreate+0xae>
    file[1] = '0' + i;
    4b24:	0309079b          	addiw	a5,s2,48
    4b28:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4b2c:	fa840513          	addi	a0,s0,-88
    4b30:	00001097          	auipc	ra,0x1
    4b34:	bc2080e7          	jalr	-1086(ra) # 56f2 <unlink>
    pid = fork();
    4b38:	00001097          	auipc	ra,0x1
    4b3c:	b62080e7          	jalr	-1182(ra) # 569a <fork>
    if(pid && (i % 3) == 1){
    4b40:	d20503e3          	beqz	a0,4866 <concreate+0x48>
    4b44:	036967bb          	remw	a5,s2,s6
    4b48:	d15787e3          	beq	a5,s5,4856 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4b4c:	20200593          	li	a1,514
    4b50:	fa840513          	addi	a0,s0,-88
    4b54:	00001097          	auipc	ra,0x1
    4b58:	b8e080e7          	jalr	-1138(ra) # 56e2 <open>
      if(fd < 0){
    4b5c:	fa0553e3          	bgez	a0,4b02 <concreate+0x2e4>
    4b60:	b31d                	j	4886 <concreate+0x68>
}
    4b62:	60ea                	ld	ra,152(sp)
    4b64:	644a                	ld	s0,144(sp)
    4b66:	64aa                	ld	s1,136(sp)
    4b68:	690a                	ld	s2,128(sp)
    4b6a:	79e6                	ld	s3,120(sp)
    4b6c:	7a46                	ld	s4,112(sp)
    4b6e:	7aa6                	ld	s5,104(sp)
    4b70:	7b06                	ld	s6,96(sp)
    4b72:	6be6                	ld	s7,88(sp)
    4b74:	610d                	addi	sp,sp,160
    4b76:	8082                	ret

0000000000004b78 <bigfile>:
{
    4b78:	7139                	addi	sp,sp,-64
    4b7a:	fc06                	sd	ra,56(sp)
    4b7c:	f822                	sd	s0,48(sp)
    4b7e:	f426                	sd	s1,40(sp)
    4b80:	f04a                	sd	s2,32(sp)
    4b82:	ec4e                	sd	s3,24(sp)
    4b84:	e852                	sd	s4,16(sp)
    4b86:	e456                	sd	s5,8(sp)
    4b88:	0080                	addi	s0,sp,64
    4b8a:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4b8c:	00003517          	auipc	a0,0x3
    4b90:	0a450513          	addi	a0,a0,164 # 7c30 <malloc+0x2150>
    4b94:	00001097          	auipc	ra,0x1
    4b98:	b5e080e7          	jalr	-1186(ra) # 56f2 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4b9c:	20200593          	li	a1,514
    4ba0:	00003517          	auipc	a0,0x3
    4ba4:	09050513          	addi	a0,a0,144 # 7c30 <malloc+0x2150>
    4ba8:	00001097          	auipc	ra,0x1
    4bac:	b3a080e7          	jalr	-1222(ra) # 56e2 <open>
    4bb0:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4bb2:	4481                	li	s1,0
    memset(buf, i, SZ);
    4bb4:	00007917          	auipc	s2,0x7
    4bb8:	fc490913          	addi	s2,s2,-60 # bb78 <buf>
  for(i = 0; i < N; i++){
    4bbc:	4a51                	li	s4,20
  if(fd < 0){
    4bbe:	0a054063          	bltz	a0,4c5e <bigfile+0xe6>
    memset(buf, i, SZ);
    4bc2:	25800613          	li	a2,600
    4bc6:	85a6                	mv	a1,s1
    4bc8:	854a                	mv	a0,s2
    4bca:	00001097          	auipc	ra,0x1
    4bce:	8dc080e7          	jalr	-1828(ra) # 54a6 <memset>
    if(write(fd, buf, SZ) != SZ){
    4bd2:	25800613          	li	a2,600
    4bd6:	85ca                	mv	a1,s2
    4bd8:	854e                	mv	a0,s3
    4bda:	00001097          	auipc	ra,0x1
    4bde:	ae8080e7          	jalr	-1304(ra) # 56c2 <write>
    4be2:	25800793          	li	a5,600
    4be6:	08f51a63          	bne	a0,a5,4c7a <bigfile+0x102>
  for(i = 0; i < N; i++){
    4bea:	2485                	addiw	s1,s1,1
    4bec:	fd449be3          	bne	s1,s4,4bc2 <bigfile+0x4a>
  close(fd);
    4bf0:	854e                	mv	a0,s3
    4bf2:	00001097          	auipc	ra,0x1
    4bf6:	ad8080e7          	jalr	-1320(ra) # 56ca <close>
  fd = open("bigfile.dat", 0);
    4bfa:	4581                	li	a1,0
    4bfc:	00003517          	auipc	a0,0x3
    4c00:	03450513          	addi	a0,a0,52 # 7c30 <malloc+0x2150>
    4c04:	00001097          	auipc	ra,0x1
    4c08:	ade080e7          	jalr	-1314(ra) # 56e2 <open>
    4c0c:	8a2a                	mv	s4,a0
  total = 0;
    4c0e:	4981                	li	s3,0
  for(i = 0; ; i++){
    4c10:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4c12:	00007917          	auipc	s2,0x7
    4c16:	f6690913          	addi	s2,s2,-154 # bb78 <buf>
  if(fd < 0){
    4c1a:	06054e63          	bltz	a0,4c96 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4c1e:	12c00613          	li	a2,300
    4c22:	85ca                	mv	a1,s2
    4c24:	8552                	mv	a0,s4
    4c26:	00001097          	auipc	ra,0x1
    4c2a:	a94080e7          	jalr	-1388(ra) # 56ba <read>
    if(cc < 0){
    4c2e:	08054263          	bltz	a0,4cb2 <bigfile+0x13a>
    if(cc == 0)
    4c32:	c971                	beqz	a0,4d06 <bigfile+0x18e>
    if(cc != SZ/2){
    4c34:	12c00793          	li	a5,300
    4c38:	08f51b63          	bne	a0,a5,4cce <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4c3c:	01f4d79b          	srliw	a5,s1,0x1f
    4c40:	9fa5                	addw	a5,a5,s1
    4c42:	4017d79b          	sraiw	a5,a5,0x1
    4c46:	00094703          	lbu	a4,0(s2)
    4c4a:	0af71063          	bne	a4,a5,4cea <bigfile+0x172>
    4c4e:	12b94703          	lbu	a4,299(s2)
    4c52:	08f71c63          	bne	a4,a5,4cea <bigfile+0x172>
    total += cc;
    4c56:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4c5a:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4c5c:	b7c9                	j	4c1e <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4c5e:	85d6                	mv	a1,s5
    4c60:	00003517          	auipc	a0,0x3
    4c64:	fe050513          	addi	a0,a0,-32 # 7c40 <malloc+0x2160>
    4c68:	00001097          	auipc	ra,0x1
    4c6c:	dba080e7          	jalr	-582(ra) # 5a22 <printf>
    exit(1);
    4c70:	4505                	li	a0,1
    4c72:	00001097          	auipc	ra,0x1
    4c76:	a30080e7          	jalr	-1488(ra) # 56a2 <exit>
      printf("%s: write bigfile failed\n", s);
    4c7a:	85d6                	mv	a1,s5
    4c7c:	00003517          	auipc	a0,0x3
    4c80:	fe450513          	addi	a0,a0,-28 # 7c60 <malloc+0x2180>
    4c84:	00001097          	auipc	ra,0x1
    4c88:	d9e080e7          	jalr	-610(ra) # 5a22 <printf>
      exit(1);
    4c8c:	4505                	li	a0,1
    4c8e:	00001097          	auipc	ra,0x1
    4c92:	a14080e7          	jalr	-1516(ra) # 56a2 <exit>
    printf("%s: cannot open bigfile\n", s);
    4c96:	85d6                	mv	a1,s5
    4c98:	00003517          	auipc	a0,0x3
    4c9c:	fe850513          	addi	a0,a0,-24 # 7c80 <malloc+0x21a0>
    4ca0:	00001097          	auipc	ra,0x1
    4ca4:	d82080e7          	jalr	-638(ra) # 5a22 <printf>
    exit(1);
    4ca8:	4505                	li	a0,1
    4caa:	00001097          	auipc	ra,0x1
    4cae:	9f8080e7          	jalr	-1544(ra) # 56a2 <exit>
      printf("%s: read bigfile failed\n", s);
    4cb2:	85d6                	mv	a1,s5
    4cb4:	00003517          	auipc	a0,0x3
    4cb8:	fec50513          	addi	a0,a0,-20 # 7ca0 <malloc+0x21c0>
    4cbc:	00001097          	auipc	ra,0x1
    4cc0:	d66080e7          	jalr	-666(ra) # 5a22 <printf>
      exit(1);
    4cc4:	4505                	li	a0,1
    4cc6:	00001097          	auipc	ra,0x1
    4cca:	9dc080e7          	jalr	-1572(ra) # 56a2 <exit>
      printf("%s: short read bigfile\n", s);
    4cce:	85d6                	mv	a1,s5
    4cd0:	00003517          	auipc	a0,0x3
    4cd4:	ff050513          	addi	a0,a0,-16 # 7cc0 <malloc+0x21e0>
    4cd8:	00001097          	auipc	ra,0x1
    4cdc:	d4a080e7          	jalr	-694(ra) # 5a22 <printf>
      exit(1);
    4ce0:	4505                	li	a0,1
    4ce2:	00001097          	auipc	ra,0x1
    4ce6:	9c0080e7          	jalr	-1600(ra) # 56a2 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4cea:	85d6                	mv	a1,s5
    4cec:	00003517          	auipc	a0,0x3
    4cf0:	fec50513          	addi	a0,a0,-20 # 7cd8 <malloc+0x21f8>
    4cf4:	00001097          	auipc	ra,0x1
    4cf8:	d2e080e7          	jalr	-722(ra) # 5a22 <printf>
      exit(1);
    4cfc:	4505                	li	a0,1
    4cfe:	00001097          	auipc	ra,0x1
    4d02:	9a4080e7          	jalr	-1628(ra) # 56a2 <exit>
  close(fd);
    4d06:	8552                	mv	a0,s4
    4d08:	00001097          	auipc	ra,0x1
    4d0c:	9c2080e7          	jalr	-1598(ra) # 56ca <close>
  if(total != N*SZ){
    4d10:	678d                	lui	a5,0x3
    4d12:	ee078793          	addi	a5,a5,-288 # 2ee0 <exitiputtest+0x46>
    4d16:	02f99363          	bne	s3,a5,4d3c <bigfile+0x1c4>
  unlink("bigfile.dat");
    4d1a:	00003517          	auipc	a0,0x3
    4d1e:	f1650513          	addi	a0,a0,-234 # 7c30 <malloc+0x2150>
    4d22:	00001097          	auipc	ra,0x1
    4d26:	9d0080e7          	jalr	-1584(ra) # 56f2 <unlink>
}
    4d2a:	70e2                	ld	ra,56(sp)
    4d2c:	7442                	ld	s0,48(sp)
    4d2e:	74a2                	ld	s1,40(sp)
    4d30:	7902                	ld	s2,32(sp)
    4d32:	69e2                	ld	s3,24(sp)
    4d34:	6a42                	ld	s4,16(sp)
    4d36:	6aa2                	ld	s5,8(sp)
    4d38:	6121                	addi	sp,sp,64
    4d3a:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4d3c:	85d6                	mv	a1,s5
    4d3e:	00003517          	auipc	a0,0x3
    4d42:	fba50513          	addi	a0,a0,-70 # 7cf8 <malloc+0x2218>
    4d46:	00001097          	auipc	ra,0x1
    4d4a:	cdc080e7          	jalr	-804(ra) # 5a22 <printf>
    exit(1);
    4d4e:	4505                	li	a0,1
    4d50:	00001097          	auipc	ra,0x1
    4d54:	952080e7          	jalr	-1710(ra) # 56a2 <exit>

0000000000004d58 <fsfull>:
{
    4d58:	7171                	addi	sp,sp,-176
    4d5a:	f506                	sd	ra,168(sp)
    4d5c:	f122                	sd	s0,160(sp)
    4d5e:	ed26                	sd	s1,152(sp)
    4d60:	e94a                	sd	s2,144(sp)
    4d62:	e54e                	sd	s3,136(sp)
    4d64:	e152                	sd	s4,128(sp)
    4d66:	fcd6                	sd	s5,120(sp)
    4d68:	f8da                	sd	s6,112(sp)
    4d6a:	f4de                	sd	s7,104(sp)
    4d6c:	f0e2                	sd	s8,96(sp)
    4d6e:	ece6                	sd	s9,88(sp)
    4d70:	e8ea                	sd	s10,80(sp)
    4d72:	e4ee                	sd	s11,72(sp)
    4d74:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4d76:	00003517          	auipc	a0,0x3
    4d7a:	fa250513          	addi	a0,a0,-94 # 7d18 <malloc+0x2238>
    4d7e:	00001097          	auipc	ra,0x1
    4d82:	ca4080e7          	jalr	-860(ra) # 5a22 <printf>
  for(nfiles = 0; ; nfiles++){
    4d86:	4481                	li	s1,0
    name[0] = 'f';
    4d88:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4d8c:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d90:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d94:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4d96:	00003c97          	auipc	s9,0x3
    4d9a:	f92c8c93          	addi	s9,s9,-110 # 7d28 <malloc+0x2248>
    int total = 0;
    4d9e:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4da0:	00007a17          	auipc	s4,0x7
    4da4:	dd8a0a13          	addi	s4,s4,-552 # bb78 <buf>
    name[0] = 'f';
    4da8:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4dac:	0384c7bb          	divw	a5,s1,s8
    4db0:	0307879b          	addiw	a5,a5,48
    4db4:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4db8:	0384e7bb          	remw	a5,s1,s8
    4dbc:	0377c7bb          	divw	a5,a5,s7
    4dc0:	0307879b          	addiw	a5,a5,48
    4dc4:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4dc8:	0374e7bb          	remw	a5,s1,s7
    4dcc:	0367c7bb          	divw	a5,a5,s6
    4dd0:	0307879b          	addiw	a5,a5,48
    4dd4:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4dd8:	0364e7bb          	remw	a5,s1,s6
    4ddc:	0307879b          	addiw	a5,a5,48
    4de0:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4de4:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4de8:	f5040593          	addi	a1,s0,-176
    4dec:	8566                	mv	a0,s9
    4dee:	00001097          	auipc	ra,0x1
    4df2:	c34080e7          	jalr	-972(ra) # 5a22 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4df6:	20200593          	li	a1,514
    4dfa:	f5040513          	addi	a0,s0,-176
    4dfe:	00001097          	auipc	ra,0x1
    4e02:	8e4080e7          	jalr	-1820(ra) # 56e2 <open>
    4e06:	892a                	mv	s2,a0
    if(fd < 0){
    4e08:	0a055663          	bgez	a0,4eb4 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4e0c:	f5040593          	addi	a1,s0,-176
    4e10:	00003517          	auipc	a0,0x3
    4e14:	f2850513          	addi	a0,a0,-216 # 7d38 <malloc+0x2258>
    4e18:	00001097          	auipc	ra,0x1
    4e1c:	c0a080e7          	jalr	-1014(ra) # 5a22 <printf>
  while(nfiles >= 0){
    4e20:	0604c363          	bltz	s1,4e86 <fsfull+0x12e>
    name[0] = 'f';
    4e24:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4e28:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4e2c:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4e30:	4929                	li	s2,10
  while(nfiles >= 0){
    4e32:	5afd                	li	s5,-1
    name[0] = 'f';
    4e34:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e38:	0344c7bb          	divw	a5,s1,s4
    4e3c:	0307879b          	addiw	a5,a5,48
    4e40:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e44:	0344e7bb          	remw	a5,s1,s4
    4e48:	0337c7bb          	divw	a5,a5,s3
    4e4c:	0307879b          	addiw	a5,a5,48
    4e50:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4e54:	0334e7bb          	remw	a5,s1,s3
    4e58:	0327c7bb          	divw	a5,a5,s2
    4e5c:	0307879b          	addiw	a5,a5,48
    4e60:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e64:	0324e7bb          	remw	a5,s1,s2
    4e68:	0307879b          	addiw	a5,a5,48
    4e6c:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e70:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4e74:	f5040513          	addi	a0,s0,-176
    4e78:	00001097          	auipc	ra,0x1
    4e7c:	87a080e7          	jalr	-1926(ra) # 56f2 <unlink>
    nfiles--;
    4e80:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4e82:	fb5499e3          	bne	s1,s5,4e34 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4e86:	00003517          	auipc	a0,0x3
    4e8a:	ed250513          	addi	a0,a0,-302 # 7d58 <malloc+0x2278>
    4e8e:	00001097          	auipc	ra,0x1
    4e92:	b94080e7          	jalr	-1132(ra) # 5a22 <printf>
}
    4e96:	70aa                	ld	ra,168(sp)
    4e98:	740a                	ld	s0,160(sp)
    4e9a:	64ea                	ld	s1,152(sp)
    4e9c:	694a                	ld	s2,144(sp)
    4e9e:	69aa                	ld	s3,136(sp)
    4ea0:	6a0a                	ld	s4,128(sp)
    4ea2:	7ae6                	ld	s5,120(sp)
    4ea4:	7b46                	ld	s6,112(sp)
    4ea6:	7ba6                	ld	s7,104(sp)
    4ea8:	7c06                	ld	s8,96(sp)
    4eaa:	6ce6                	ld	s9,88(sp)
    4eac:	6d46                	ld	s10,80(sp)
    4eae:	6da6                	ld	s11,72(sp)
    4eb0:	614d                	addi	sp,sp,176
    4eb2:	8082                	ret
    int total = 0;
    4eb4:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4eb6:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4eba:	40000613          	li	a2,1024
    4ebe:	85d2                	mv	a1,s4
    4ec0:	854a                	mv	a0,s2
    4ec2:	00001097          	auipc	ra,0x1
    4ec6:	800080e7          	jalr	-2048(ra) # 56c2 <write>
      if(cc < BSIZE)
    4eca:	00aad563          	bge	s5,a0,4ed4 <fsfull+0x17c>
      total += cc;
    4ece:	00a989bb          	addw	s3,s3,a0
    while(1){
    4ed2:	b7e5                	j	4eba <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4ed4:	85ce                	mv	a1,s3
    4ed6:	00003517          	auipc	a0,0x3
    4eda:	e7250513          	addi	a0,a0,-398 # 7d48 <malloc+0x2268>
    4ede:	00001097          	auipc	ra,0x1
    4ee2:	b44080e7          	jalr	-1212(ra) # 5a22 <printf>
    close(fd);
    4ee6:	854a                	mv	a0,s2
    4ee8:	00000097          	auipc	ra,0x0
    4eec:	7e2080e7          	jalr	2018(ra) # 56ca <close>
    if(total == 0)
    4ef0:	f20988e3          	beqz	s3,4e20 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4ef4:	2485                	addiw	s1,s1,1
    4ef6:	bd4d                	j	4da8 <fsfull+0x50>

0000000000004ef8 <rand>:
{
    4ef8:	1141                	addi	sp,sp,-16
    4efa:	e422                	sd	s0,8(sp)
    4efc:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4efe:	00003717          	auipc	a4,0x3
    4f02:	45270713          	addi	a4,a4,1106 # 8350 <randstate>
    4f06:	6308                	ld	a0,0(a4)
    4f08:	001967b7          	lui	a5,0x196
    4f0c:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187a85>
    4f10:	02f50533          	mul	a0,a0,a5
    4f14:	3c6ef7b7          	lui	a5,0x3c6ef
    4f18:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e07d7>
    4f1c:	953e                	add	a0,a0,a5
    4f1e:	e308                	sd	a0,0(a4)
}
    4f20:	2501                	sext.w	a0,a0
    4f22:	6422                	ld	s0,8(sp)
    4f24:	0141                	addi	sp,sp,16
    4f26:	8082                	ret

0000000000004f28 <badwrite>:
{
    4f28:	7179                	addi	sp,sp,-48
    4f2a:	f406                	sd	ra,40(sp)
    4f2c:	f022                	sd	s0,32(sp)
    4f2e:	ec26                	sd	s1,24(sp)
    4f30:	e84a                	sd	s2,16(sp)
    4f32:	e44e                	sd	s3,8(sp)
    4f34:	e052                	sd	s4,0(sp)
    4f36:	1800                	addi	s0,sp,48
  unlink("junk");
    4f38:	00003517          	auipc	a0,0x3
    4f3c:	e3850513          	addi	a0,a0,-456 # 7d70 <malloc+0x2290>
    4f40:	00000097          	auipc	ra,0x0
    4f44:	7b2080e7          	jalr	1970(ra) # 56f2 <unlink>
    4f48:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4f4c:	00003997          	auipc	s3,0x3
    4f50:	e2498993          	addi	s3,s3,-476 # 7d70 <malloc+0x2290>
    write(fd, (char*)0xffffffffffL, 1);
    4f54:	5a7d                	li	s4,-1
    4f56:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4f5a:	20100593          	li	a1,513
    4f5e:	854e                	mv	a0,s3
    4f60:	00000097          	auipc	ra,0x0
    4f64:	782080e7          	jalr	1922(ra) # 56e2 <open>
    4f68:	84aa                	mv	s1,a0
    if(fd < 0){
    4f6a:	06054b63          	bltz	a0,4fe0 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4f6e:	4605                	li	a2,1
    4f70:	85d2                	mv	a1,s4
    4f72:	00000097          	auipc	ra,0x0
    4f76:	750080e7          	jalr	1872(ra) # 56c2 <write>
    close(fd);
    4f7a:	8526                	mv	a0,s1
    4f7c:	00000097          	auipc	ra,0x0
    4f80:	74e080e7          	jalr	1870(ra) # 56ca <close>
    unlink("junk");
    4f84:	854e                	mv	a0,s3
    4f86:	00000097          	auipc	ra,0x0
    4f8a:	76c080e7          	jalr	1900(ra) # 56f2 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4f8e:	397d                	addiw	s2,s2,-1
    4f90:	fc0915e3          	bnez	s2,4f5a <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4f94:	20100593          	li	a1,513
    4f98:	00003517          	auipc	a0,0x3
    4f9c:	dd850513          	addi	a0,a0,-552 # 7d70 <malloc+0x2290>
    4fa0:	00000097          	auipc	ra,0x0
    4fa4:	742080e7          	jalr	1858(ra) # 56e2 <open>
    4fa8:	84aa                	mv	s1,a0
  if(fd < 0){
    4faa:	04054863          	bltz	a0,4ffa <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4fae:	4605                	li	a2,1
    4fb0:	00001597          	auipc	a1,0x1
    4fb4:	ff058593          	addi	a1,a1,-16 # 5fa0 <malloc+0x4c0>
    4fb8:	00000097          	auipc	ra,0x0
    4fbc:	70a080e7          	jalr	1802(ra) # 56c2 <write>
    4fc0:	4785                	li	a5,1
    4fc2:	04f50963          	beq	a0,a5,5014 <badwrite+0xec>
    printf("write failed\n");
    4fc6:	00003517          	auipc	a0,0x3
    4fca:	dca50513          	addi	a0,a0,-566 # 7d90 <malloc+0x22b0>
    4fce:	00001097          	auipc	ra,0x1
    4fd2:	a54080e7          	jalr	-1452(ra) # 5a22 <printf>
    exit(1);
    4fd6:	4505                	li	a0,1
    4fd8:	00000097          	auipc	ra,0x0
    4fdc:	6ca080e7          	jalr	1738(ra) # 56a2 <exit>
      printf("open junk failed\n");
    4fe0:	00003517          	auipc	a0,0x3
    4fe4:	d9850513          	addi	a0,a0,-616 # 7d78 <malloc+0x2298>
    4fe8:	00001097          	auipc	ra,0x1
    4fec:	a3a080e7          	jalr	-1478(ra) # 5a22 <printf>
      exit(1);
    4ff0:	4505                	li	a0,1
    4ff2:	00000097          	auipc	ra,0x0
    4ff6:	6b0080e7          	jalr	1712(ra) # 56a2 <exit>
    printf("open junk failed\n");
    4ffa:	00003517          	auipc	a0,0x3
    4ffe:	d7e50513          	addi	a0,a0,-642 # 7d78 <malloc+0x2298>
    5002:	00001097          	auipc	ra,0x1
    5006:	a20080e7          	jalr	-1504(ra) # 5a22 <printf>
    exit(1);
    500a:	4505                	li	a0,1
    500c:	00000097          	auipc	ra,0x0
    5010:	696080e7          	jalr	1686(ra) # 56a2 <exit>
  close(fd);
    5014:	8526                	mv	a0,s1
    5016:	00000097          	auipc	ra,0x0
    501a:	6b4080e7          	jalr	1716(ra) # 56ca <close>
  unlink("junk");
    501e:	00003517          	auipc	a0,0x3
    5022:	d5250513          	addi	a0,a0,-686 # 7d70 <malloc+0x2290>
    5026:	00000097          	auipc	ra,0x0
    502a:	6cc080e7          	jalr	1740(ra) # 56f2 <unlink>
  exit(0);
    502e:	4501                	li	a0,0
    5030:	00000097          	auipc	ra,0x0
    5034:	672080e7          	jalr	1650(ra) # 56a2 <exit>

0000000000005038 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5038:	7139                	addi	sp,sp,-64
    503a:	fc06                	sd	ra,56(sp)
    503c:	f822                	sd	s0,48(sp)
    503e:	f426                	sd	s1,40(sp)
    5040:	f04a                	sd	s2,32(sp)
    5042:	ec4e                	sd	s3,24(sp)
    5044:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5046:	fc840513          	addi	a0,s0,-56
    504a:	00000097          	auipc	ra,0x0
    504e:	668080e7          	jalr	1640(ra) # 56b2 <pipe>
    5052:	06054763          	bltz	a0,50c0 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5056:	00000097          	auipc	ra,0x0
    505a:	644080e7          	jalr	1604(ra) # 569a <fork>

  if(pid < 0){
    505e:	06054e63          	bltz	a0,50da <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5062:	ed51                	bnez	a0,50fe <countfree+0xc6>
    close(fds[0]);
    5064:	fc842503          	lw	a0,-56(s0)
    5068:	00000097          	auipc	ra,0x0
    506c:	662080e7          	jalr	1634(ra) # 56ca <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5070:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5072:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5074:	00001997          	auipc	s3,0x1
    5078:	f2c98993          	addi	s3,s3,-212 # 5fa0 <malloc+0x4c0>
      uint64 a = (uint64) sbrk(4096);
    507c:	6505                	lui	a0,0x1
    507e:	00000097          	auipc	ra,0x0
    5082:	6ac080e7          	jalr	1708(ra) # 572a <sbrk>
      if(a == 0xffffffffffffffff){
    5086:	07250763          	beq	a0,s2,50f4 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    508a:	6785                	lui	a5,0x1
    508c:	953e                	add	a0,a0,a5
    508e:	fe950fa3          	sb	s1,-1(a0) # fff <bigdir+0x9b>
      if(write(fds[1], "x", 1) != 1){
    5092:	8626                	mv	a2,s1
    5094:	85ce                	mv	a1,s3
    5096:	fcc42503          	lw	a0,-52(s0)
    509a:	00000097          	auipc	ra,0x0
    509e:	628080e7          	jalr	1576(ra) # 56c2 <write>
    50a2:	fc950de3          	beq	a0,s1,507c <countfree+0x44>
        printf("write() failed in countfree()\n");
    50a6:	00003517          	auipc	a0,0x3
    50aa:	d3a50513          	addi	a0,a0,-710 # 7de0 <malloc+0x2300>
    50ae:	00001097          	auipc	ra,0x1
    50b2:	974080e7          	jalr	-1676(ra) # 5a22 <printf>
        exit(1);
    50b6:	4505                	li	a0,1
    50b8:	00000097          	auipc	ra,0x0
    50bc:	5ea080e7          	jalr	1514(ra) # 56a2 <exit>
    printf("pipe() failed in countfree()\n");
    50c0:	00003517          	auipc	a0,0x3
    50c4:	ce050513          	addi	a0,a0,-800 # 7da0 <malloc+0x22c0>
    50c8:	00001097          	auipc	ra,0x1
    50cc:	95a080e7          	jalr	-1702(ra) # 5a22 <printf>
    exit(1);
    50d0:	4505                	li	a0,1
    50d2:	00000097          	auipc	ra,0x0
    50d6:	5d0080e7          	jalr	1488(ra) # 56a2 <exit>
    printf("fork failed in countfree()\n");
    50da:	00003517          	auipc	a0,0x3
    50de:	ce650513          	addi	a0,a0,-794 # 7dc0 <malloc+0x22e0>
    50e2:	00001097          	auipc	ra,0x1
    50e6:	940080e7          	jalr	-1728(ra) # 5a22 <printf>
    exit(1);
    50ea:	4505                	li	a0,1
    50ec:	00000097          	auipc	ra,0x0
    50f0:	5b6080e7          	jalr	1462(ra) # 56a2 <exit>
      }
    }

    exit(0);
    50f4:	4501                	li	a0,0
    50f6:	00000097          	auipc	ra,0x0
    50fa:	5ac080e7          	jalr	1452(ra) # 56a2 <exit>
  }

  close(fds[1]);
    50fe:	fcc42503          	lw	a0,-52(s0)
    5102:	00000097          	auipc	ra,0x0
    5106:	5c8080e7          	jalr	1480(ra) # 56ca <close>

  int n = 0;
    510a:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    510c:	4605                	li	a2,1
    510e:	fc740593          	addi	a1,s0,-57
    5112:	fc842503          	lw	a0,-56(s0)
    5116:	00000097          	auipc	ra,0x0
    511a:	5a4080e7          	jalr	1444(ra) # 56ba <read>
    if(cc < 0){
    511e:	00054563          	bltz	a0,5128 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5122:	c105                	beqz	a0,5142 <countfree+0x10a>
      break;
    n += 1;
    5124:	2485                	addiw	s1,s1,1
  while(1){
    5126:	b7dd                	j	510c <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5128:	00003517          	auipc	a0,0x3
    512c:	cd850513          	addi	a0,a0,-808 # 7e00 <malloc+0x2320>
    5130:	00001097          	auipc	ra,0x1
    5134:	8f2080e7          	jalr	-1806(ra) # 5a22 <printf>
      exit(1);
    5138:	4505                	li	a0,1
    513a:	00000097          	auipc	ra,0x0
    513e:	568080e7          	jalr	1384(ra) # 56a2 <exit>
  }

  close(fds[0]);
    5142:	fc842503          	lw	a0,-56(s0)
    5146:	00000097          	auipc	ra,0x0
    514a:	584080e7          	jalr	1412(ra) # 56ca <close>
  wait((int*)0);
    514e:	4501                	li	a0,0
    5150:	00000097          	auipc	ra,0x0
    5154:	55a080e7          	jalr	1370(ra) # 56aa <wait>
  
  return n;
}
    5158:	8526                	mv	a0,s1
    515a:	70e2                	ld	ra,56(sp)
    515c:	7442                	ld	s0,48(sp)
    515e:	74a2                	ld	s1,40(sp)
    5160:	7902                	ld	s2,32(sp)
    5162:	69e2                	ld	s3,24(sp)
    5164:	6121                	addi	sp,sp,64
    5166:	8082                	ret

0000000000005168 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5168:	7179                	addi	sp,sp,-48
    516a:	f406                	sd	ra,40(sp)
    516c:	f022                	sd	s0,32(sp)
    516e:	ec26                	sd	s1,24(sp)
    5170:	e84a                	sd	s2,16(sp)
    5172:	1800                	addi	s0,sp,48
    5174:	84aa                	mv	s1,a0
    5176:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5178:	00003517          	auipc	a0,0x3
    517c:	ca850513          	addi	a0,a0,-856 # 7e20 <malloc+0x2340>
    5180:	00001097          	auipc	ra,0x1
    5184:	8a2080e7          	jalr	-1886(ra) # 5a22 <printf>
  if((pid = fork()) < 0) {
    5188:	00000097          	auipc	ra,0x0
    518c:	512080e7          	jalr	1298(ra) # 569a <fork>
    5190:	02054e63          	bltz	a0,51cc <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5194:	c929                	beqz	a0,51e6 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5196:	fdc40513          	addi	a0,s0,-36
    519a:	00000097          	auipc	ra,0x0
    519e:	510080e7          	jalr	1296(ra) # 56aa <wait>
    if(xstatus != 0) 
    51a2:	fdc42783          	lw	a5,-36(s0)
    51a6:	c7b9                	beqz	a5,51f4 <run+0x8c>
      printf("FAILED\n");
    51a8:	00003517          	auipc	a0,0x3
    51ac:	ca050513          	addi	a0,a0,-864 # 7e48 <malloc+0x2368>
    51b0:	00001097          	auipc	ra,0x1
    51b4:	872080e7          	jalr	-1934(ra) # 5a22 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    51b8:	fdc42503          	lw	a0,-36(s0)
  }
}
    51bc:	00153513          	seqz	a0,a0
    51c0:	70a2                	ld	ra,40(sp)
    51c2:	7402                	ld	s0,32(sp)
    51c4:	64e2                	ld	s1,24(sp)
    51c6:	6942                	ld	s2,16(sp)
    51c8:	6145                	addi	sp,sp,48
    51ca:	8082                	ret
    printf("runtest: fork error\n");
    51cc:	00003517          	auipc	a0,0x3
    51d0:	c6450513          	addi	a0,a0,-924 # 7e30 <malloc+0x2350>
    51d4:	00001097          	auipc	ra,0x1
    51d8:	84e080e7          	jalr	-1970(ra) # 5a22 <printf>
    exit(1);
    51dc:	4505                	li	a0,1
    51de:	00000097          	auipc	ra,0x0
    51e2:	4c4080e7          	jalr	1220(ra) # 56a2 <exit>
    f(s);
    51e6:	854a                	mv	a0,s2
    51e8:	9482                	jalr	s1
    exit(0);
    51ea:	4501                	li	a0,0
    51ec:	00000097          	auipc	ra,0x0
    51f0:	4b6080e7          	jalr	1206(ra) # 56a2 <exit>
      printf("OK\n");
    51f4:	00003517          	auipc	a0,0x3
    51f8:	c5c50513          	addi	a0,a0,-932 # 7e50 <malloc+0x2370>
    51fc:	00001097          	auipc	ra,0x1
    5200:	826080e7          	jalr	-2010(ra) # 5a22 <printf>
    5204:	bf55                	j	51b8 <run+0x50>

0000000000005206 <main>:

int
main(int argc, char *argv[])
{
    5206:	c0010113          	addi	sp,sp,-1024
    520a:	3e113c23          	sd	ra,1016(sp)
    520e:	3e813823          	sd	s0,1008(sp)
    5212:	3e913423          	sd	s1,1000(sp)
    5216:	3f213023          	sd	s2,992(sp)
    521a:	3d313c23          	sd	s3,984(sp)
    521e:	3d413823          	sd	s4,976(sp)
    5222:	3d513423          	sd	s5,968(sp)
    5226:	3d613023          	sd	s6,960(sp)
    522a:	40010413          	addi	s0,sp,1024
    522e:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5230:	4789                	li	a5,2
    5232:	08f50763          	beq	a0,a5,52c0 <main+0xba>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5236:	4785                	li	a5,1
  char *justone = 0;
    5238:	4901                	li	s2,0
  } else if(argc > 1){
    523a:	0ca7c163          	blt	a5,a0,52fc <main+0xf6>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    523e:	00003797          	auipc	a5,0x3
    5242:	d2a78793          	addi	a5,a5,-726 # 7f68 <malloc+0x2488>
    5246:	c0040713          	addi	a4,s0,-1024
    524a:	00003817          	auipc	a6,0x3
    524e:	0de80813          	addi	a6,a6,222 # 8328 <malloc+0x2848>
    5252:	6388                	ld	a0,0(a5)
    5254:	678c                	ld	a1,8(a5)
    5256:	6b90                	ld	a2,16(a5)
    5258:	6f94                	ld	a3,24(a5)
    525a:	e308                	sd	a0,0(a4)
    525c:	e70c                	sd	a1,8(a4)
    525e:	eb10                	sd	a2,16(a4)
    5260:	ef14                	sd	a3,24(a4)
    5262:	02078793          	addi	a5,a5,32
    5266:	02070713          	addi	a4,a4,32
    526a:	ff0794e3          	bne	a5,a6,5252 <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    526e:	00003517          	auipc	a0,0x3
    5272:	c9a50513          	addi	a0,a0,-870 # 7f08 <malloc+0x2428>
    5276:	00000097          	auipc	ra,0x0
    527a:	7ac080e7          	jalr	1964(ra) # 5a22 <printf>
  int free0 = countfree();
    527e:	00000097          	auipc	ra,0x0
    5282:	dba080e7          	jalr	-582(ra) # 5038 <countfree>
    5286:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5288:	c0843503          	ld	a0,-1016(s0)
    528c:	c0040493          	addi	s1,s0,-1024
  int fail = 0;
    5290:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5292:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    5294:	e55d                	bnez	a0,5342 <main+0x13c>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    5296:	00000097          	auipc	ra,0x0
    529a:	da2080e7          	jalr	-606(ra) # 5038 <countfree>
    529e:	85aa                	mv	a1,a0
    52a0:	0f455163          	bge	a0,s4,5382 <main+0x17c>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    52a4:	8652                	mv	a2,s4
    52a6:	00003517          	auipc	a0,0x3
    52aa:	c1a50513          	addi	a0,a0,-998 # 7ec0 <malloc+0x23e0>
    52ae:	00000097          	auipc	ra,0x0
    52b2:	774080e7          	jalr	1908(ra) # 5a22 <printf>
    exit(1);
    52b6:	4505                	li	a0,1
    52b8:	00000097          	auipc	ra,0x0
    52bc:	3ea080e7          	jalr	1002(ra) # 56a2 <exit>
    52c0:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    52c2:	00003597          	auipc	a1,0x3
    52c6:	b9658593          	addi	a1,a1,-1130 # 7e58 <malloc+0x2378>
    52ca:	6488                	ld	a0,8(s1)
    52cc:	00000097          	auipc	ra,0x0
    52d0:	184080e7          	jalr	388(ra) # 5450 <strcmp>
    52d4:	10050563          	beqz	a0,53de <main+0x1d8>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    52d8:	00003597          	auipc	a1,0x3
    52dc:	c6858593          	addi	a1,a1,-920 # 7f40 <malloc+0x2460>
    52e0:	6488                	ld	a0,8(s1)
    52e2:	00000097          	auipc	ra,0x0
    52e6:	16e080e7          	jalr	366(ra) # 5450 <strcmp>
    52ea:	c97d                	beqz	a0,53e0 <main+0x1da>
  } else if(argc == 2 && argv[1][0] != '-'){
    52ec:	0084b903          	ld	s2,8(s1)
    52f0:	00094703          	lbu	a4,0(s2)
    52f4:	02d00793          	li	a5,45
    52f8:	f4f713e3          	bne	a4,a5,523e <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    52fc:	00003517          	auipc	a0,0x3
    5300:	b6450513          	addi	a0,a0,-1180 # 7e60 <malloc+0x2380>
    5304:	00000097          	auipc	ra,0x0
    5308:	71e080e7          	jalr	1822(ra) # 5a22 <printf>
    exit(1);
    530c:	4505                	li	a0,1
    530e:	00000097          	auipc	ra,0x0
    5312:	394080e7          	jalr	916(ra) # 56a2 <exit>
          exit(1);
    5316:	4505                	li	a0,1
    5318:	00000097          	auipc	ra,0x0
    531c:	38a080e7          	jalr	906(ra) # 56a2 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5320:	40a905bb          	subw	a1,s2,a0
    5324:	855a                	mv	a0,s6
    5326:	00000097          	auipc	ra,0x0
    532a:	6fc080e7          	jalr	1788(ra) # 5a22 <printf>
        if(continuous != 2)
    532e:	09498463          	beq	s3,s4,53b6 <main+0x1b0>
          exit(1);
    5332:	4505                	li	a0,1
    5334:	00000097          	auipc	ra,0x0
    5338:	36e080e7          	jalr	878(ra) # 56a2 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    533c:	04c1                	addi	s1,s1,16
    533e:	6488                	ld	a0,8(s1)
    5340:	c115                	beqz	a0,5364 <main+0x15e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5342:	00090863          	beqz	s2,5352 <main+0x14c>
    5346:	85ca                	mv	a1,s2
    5348:	00000097          	auipc	ra,0x0
    534c:	108080e7          	jalr	264(ra) # 5450 <strcmp>
    5350:	f575                	bnez	a0,533c <main+0x136>
      if(!run(t->f, t->s))
    5352:	648c                	ld	a1,8(s1)
    5354:	6088                	ld	a0,0(s1)
    5356:	00000097          	auipc	ra,0x0
    535a:	e12080e7          	jalr	-494(ra) # 5168 <run>
    535e:	fd79                	bnez	a0,533c <main+0x136>
        fail = 1;
    5360:	89d6                	mv	s3,s5
    5362:	bfe9                	j	533c <main+0x136>
  if(fail){
    5364:	f20989e3          	beqz	s3,5296 <main+0x90>
    printf("SOME TESTS FAILED\n");
    5368:	00003517          	auipc	a0,0x3
    536c:	b4050513          	addi	a0,a0,-1216 # 7ea8 <malloc+0x23c8>
    5370:	00000097          	auipc	ra,0x0
    5374:	6b2080e7          	jalr	1714(ra) # 5a22 <printf>
    exit(1);
    5378:	4505                	li	a0,1
    537a:	00000097          	auipc	ra,0x0
    537e:	328080e7          	jalr	808(ra) # 56a2 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5382:	00003517          	auipc	a0,0x3
    5386:	b6e50513          	addi	a0,a0,-1170 # 7ef0 <malloc+0x2410>
    538a:	00000097          	auipc	ra,0x0
    538e:	698080e7          	jalr	1688(ra) # 5a22 <printf>
    exit(0);
    5392:	4501                	li	a0,0
    5394:	00000097          	auipc	ra,0x0
    5398:	30e080e7          	jalr	782(ra) # 56a2 <exit>
        printf("SOME TESTS FAILED\n");
    539c:	8556                	mv	a0,s5
    539e:	00000097          	auipc	ra,0x0
    53a2:	684080e7          	jalr	1668(ra) # 5a22 <printf>
        if(continuous != 2)
    53a6:	f74998e3          	bne	s3,s4,5316 <main+0x110>
      int free1 = countfree();
    53aa:	00000097          	auipc	ra,0x0
    53ae:	c8e080e7          	jalr	-882(ra) # 5038 <countfree>
      if(free1 < free0){
    53b2:	f72547e3          	blt	a0,s2,5320 <main+0x11a>
      int free0 = countfree();
    53b6:	00000097          	auipc	ra,0x0
    53ba:	c82080e7          	jalr	-894(ra) # 5038 <countfree>
    53be:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    53c0:	c0843583          	ld	a1,-1016(s0)
    53c4:	d1fd                	beqz	a1,53aa <main+0x1a4>
    53c6:	c0040493          	addi	s1,s0,-1024
        if(!run(t->f, t->s)){
    53ca:	6088                	ld	a0,0(s1)
    53cc:	00000097          	auipc	ra,0x0
    53d0:	d9c080e7          	jalr	-612(ra) # 5168 <run>
    53d4:	d561                	beqz	a0,539c <main+0x196>
      for (struct test *t = tests; t->s != 0; t++) {
    53d6:	04c1                	addi	s1,s1,16
    53d8:	648c                	ld	a1,8(s1)
    53da:	f9e5                	bnez	a1,53ca <main+0x1c4>
    53dc:	b7f9                	j	53aa <main+0x1a4>
    continuous = 1;
    53de:	4985                	li	s3,1
  } tests[] = {
    53e0:	00003797          	auipc	a5,0x3
    53e4:	b8878793          	addi	a5,a5,-1144 # 7f68 <malloc+0x2488>
    53e8:	c0040713          	addi	a4,s0,-1024
    53ec:	00003817          	auipc	a6,0x3
    53f0:	f3c80813          	addi	a6,a6,-196 # 8328 <malloc+0x2848>
    53f4:	6388                	ld	a0,0(a5)
    53f6:	678c                	ld	a1,8(a5)
    53f8:	6b90                	ld	a2,16(a5)
    53fa:	6f94                	ld	a3,24(a5)
    53fc:	e308                	sd	a0,0(a4)
    53fe:	e70c                	sd	a1,8(a4)
    5400:	eb10                	sd	a2,16(a4)
    5402:	ef14                	sd	a3,24(a4)
    5404:	02078793          	addi	a5,a5,32
    5408:	02070713          	addi	a4,a4,32
    540c:	ff0794e3          	bne	a5,a6,53f4 <main+0x1ee>
    printf("continuous usertests starting\n");
    5410:	00003517          	auipc	a0,0x3
    5414:	b1050513          	addi	a0,a0,-1264 # 7f20 <malloc+0x2440>
    5418:	00000097          	auipc	ra,0x0
    541c:	60a080e7          	jalr	1546(ra) # 5a22 <printf>
        printf("SOME TESTS FAILED\n");
    5420:	00003a97          	auipc	s5,0x3
    5424:	a88a8a93          	addi	s5,s5,-1400 # 7ea8 <malloc+0x23c8>
        if(continuous != 2)
    5428:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    542a:	00003b17          	auipc	s6,0x3
    542e:	a5eb0b13          	addi	s6,s6,-1442 # 7e88 <malloc+0x23a8>
    5432:	b751                	j	53b6 <main+0x1b0>

0000000000005434 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    5434:	1141                	addi	sp,sp,-16
    5436:	e422                	sd	s0,8(sp)
    5438:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    543a:	87aa                	mv	a5,a0
    543c:	0585                	addi	a1,a1,1
    543e:	0785                	addi	a5,a5,1
    5440:	fff5c703          	lbu	a4,-1(a1)
    5444:	fee78fa3          	sb	a4,-1(a5)
    5448:	fb75                	bnez	a4,543c <strcpy+0x8>
    ;
  return os;
}
    544a:	6422                	ld	s0,8(sp)
    544c:	0141                	addi	sp,sp,16
    544e:	8082                	ret

0000000000005450 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5450:	1141                	addi	sp,sp,-16
    5452:	e422                	sd	s0,8(sp)
    5454:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5456:	00054783          	lbu	a5,0(a0)
    545a:	cb91                	beqz	a5,546e <strcmp+0x1e>
    545c:	0005c703          	lbu	a4,0(a1)
    5460:	00f71763          	bne	a4,a5,546e <strcmp+0x1e>
    p++, q++;
    5464:	0505                	addi	a0,a0,1
    5466:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5468:	00054783          	lbu	a5,0(a0)
    546c:	fbe5                	bnez	a5,545c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    546e:	0005c503          	lbu	a0,0(a1)
}
    5472:	40a7853b          	subw	a0,a5,a0
    5476:	6422                	ld	s0,8(sp)
    5478:	0141                	addi	sp,sp,16
    547a:	8082                	ret

000000000000547c <strlen>:

uint
strlen(const char *s)
{
    547c:	1141                	addi	sp,sp,-16
    547e:	e422                	sd	s0,8(sp)
    5480:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5482:	00054783          	lbu	a5,0(a0)
    5486:	cf91                	beqz	a5,54a2 <strlen+0x26>
    5488:	0505                	addi	a0,a0,1
    548a:	87aa                	mv	a5,a0
    548c:	4685                	li	a3,1
    548e:	9e89                	subw	a3,a3,a0
    5490:	00f6853b          	addw	a0,a3,a5
    5494:	0785                	addi	a5,a5,1
    5496:	fff7c703          	lbu	a4,-1(a5)
    549a:	fb7d                	bnez	a4,5490 <strlen+0x14>
    ;
  return n;
}
    549c:	6422                	ld	s0,8(sp)
    549e:	0141                	addi	sp,sp,16
    54a0:	8082                	ret
  for(n = 0; s[n]; n++)
    54a2:	4501                	li	a0,0
    54a4:	bfe5                	j	549c <strlen+0x20>

00000000000054a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    54a6:	1141                	addi	sp,sp,-16
    54a8:	e422                	sd	s0,8(sp)
    54aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    54ac:	ca19                	beqz	a2,54c2 <memset+0x1c>
    54ae:	87aa                	mv	a5,a0
    54b0:	1602                	slli	a2,a2,0x20
    54b2:	9201                	srli	a2,a2,0x20
    54b4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    54b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    54bc:	0785                	addi	a5,a5,1
    54be:	fee79de3          	bne	a5,a4,54b8 <memset+0x12>
  }
  return dst;
}
    54c2:	6422                	ld	s0,8(sp)
    54c4:	0141                	addi	sp,sp,16
    54c6:	8082                	ret

00000000000054c8 <strchr>:

char*
strchr(const char *s, char c)
{
    54c8:	1141                	addi	sp,sp,-16
    54ca:	e422                	sd	s0,8(sp)
    54cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
    54ce:	00054783          	lbu	a5,0(a0)
    54d2:	cb99                	beqz	a5,54e8 <strchr+0x20>
    if(*s == c)
    54d4:	00f58763          	beq	a1,a5,54e2 <strchr+0x1a>
  for(; *s; s++)
    54d8:	0505                	addi	a0,a0,1
    54da:	00054783          	lbu	a5,0(a0)
    54de:	fbfd                	bnez	a5,54d4 <strchr+0xc>
      return (char*)s;
  return 0;
    54e0:	4501                	li	a0,0
}
    54e2:	6422                	ld	s0,8(sp)
    54e4:	0141                	addi	sp,sp,16
    54e6:	8082                	ret
  return 0;
    54e8:	4501                	li	a0,0
    54ea:	bfe5                	j	54e2 <strchr+0x1a>

00000000000054ec <gets>:

char*
gets(char *buf, int max)
{
    54ec:	711d                	addi	sp,sp,-96
    54ee:	ec86                	sd	ra,88(sp)
    54f0:	e8a2                	sd	s0,80(sp)
    54f2:	e4a6                	sd	s1,72(sp)
    54f4:	e0ca                	sd	s2,64(sp)
    54f6:	fc4e                	sd	s3,56(sp)
    54f8:	f852                	sd	s4,48(sp)
    54fa:	f456                	sd	s5,40(sp)
    54fc:	f05a                	sd	s6,32(sp)
    54fe:	ec5e                	sd	s7,24(sp)
    5500:	1080                	addi	s0,sp,96
    5502:	8baa                	mv	s7,a0
    5504:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5506:	892a                	mv	s2,a0
    5508:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    550a:	4aa9                	li	s5,10
    550c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    550e:	89a6                	mv	s3,s1
    5510:	2485                	addiw	s1,s1,1
    5512:	0344d863          	bge	s1,s4,5542 <gets+0x56>
    cc = read(0, &c, 1);
    5516:	4605                	li	a2,1
    5518:	faf40593          	addi	a1,s0,-81
    551c:	4501                	li	a0,0
    551e:	00000097          	auipc	ra,0x0
    5522:	19c080e7          	jalr	412(ra) # 56ba <read>
    if(cc < 1)
    5526:	00a05e63          	blez	a0,5542 <gets+0x56>
    buf[i++] = c;
    552a:	faf44783          	lbu	a5,-81(s0)
    552e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5532:	01578763          	beq	a5,s5,5540 <gets+0x54>
    5536:	0905                	addi	s2,s2,1
    5538:	fd679be3          	bne	a5,s6,550e <gets+0x22>
  for(i=0; i+1 < max; ){
    553c:	89a6                	mv	s3,s1
    553e:	a011                	j	5542 <gets+0x56>
    5540:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5542:	99de                	add	s3,s3,s7
    5544:	00098023          	sb	zero,0(s3)
  return buf;
}
    5548:	855e                	mv	a0,s7
    554a:	60e6                	ld	ra,88(sp)
    554c:	6446                	ld	s0,80(sp)
    554e:	64a6                	ld	s1,72(sp)
    5550:	6906                	ld	s2,64(sp)
    5552:	79e2                	ld	s3,56(sp)
    5554:	7a42                	ld	s4,48(sp)
    5556:	7aa2                	ld	s5,40(sp)
    5558:	7b02                	ld	s6,32(sp)
    555a:	6be2                	ld	s7,24(sp)
    555c:	6125                	addi	sp,sp,96
    555e:	8082                	ret

0000000000005560 <stat>:

int
stat(const char *n, struct stat *st)
{
    5560:	1101                	addi	sp,sp,-32
    5562:	ec06                	sd	ra,24(sp)
    5564:	e822                	sd	s0,16(sp)
    5566:	e426                	sd	s1,8(sp)
    5568:	e04a                	sd	s2,0(sp)
    556a:	1000                	addi	s0,sp,32
    556c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    556e:	4581                	li	a1,0
    5570:	00000097          	auipc	ra,0x0
    5574:	172080e7          	jalr	370(ra) # 56e2 <open>
  if(fd < 0)
    5578:	02054563          	bltz	a0,55a2 <stat+0x42>
    557c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    557e:	85ca                	mv	a1,s2
    5580:	00000097          	auipc	ra,0x0
    5584:	17a080e7          	jalr	378(ra) # 56fa <fstat>
    5588:	892a                	mv	s2,a0
  close(fd);
    558a:	8526                	mv	a0,s1
    558c:	00000097          	auipc	ra,0x0
    5590:	13e080e7          	jalr	318(ra) # 56ca <close>
  return r;
}
    5594:	854a                	mv	a0,s2
    5596:	60e2                	ld	ra,24(sp)
    5598:	6442                	ld	s0,16(sp)
    559a:	64a2                	ld	s1,8(sp)
    559c:	6902                	ld	s2,0(sp)
    559e:	6105                	addi	sp,sp,32
    55a0:	8082                	ret
    return -1;
    55a2:	597d                	li	s2,-1
    55a4:	bfc5                	j	5594 <stat+0x34>

00000000000055a6 <atoi>:

int
atoi(const char *s)
{
    55a6:	1141                	addi	sp,sp,-16
    55a8:	e422                	sd	s0,8(sp)
    55aa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    55ac:	00054603          	lbu	a2,0(a0)
    55b0:	fd06079b          	addiw	a5,a2,-48
    55b4:	0ff7f793          	andi	a5,a5,255
    55b8:	4725                	li	a4,9
    55ba:	02f76963          	bltu	a4,a5,55ec <atoi+0x46>
    55be:	86aa                	mv	a3,a0
  n = 0;
    55c0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    55c2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    55c4:	0685                	addi	a3,a3,1
    55c6:	0025179b          	slliw	a5,a0,0x2
    55ca:	9fa9                	addw	a5,a5,a0
    55cc:	0017979b          	slliw	a5,a5,0x1
    55d0:	9fb1                	addw	a5,a5,a2
    55d2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    55d6:	0006c603          	lbu	a2,0(a3)
    55da:	fd06071b          	addiw	a4,a2,-48
    55de:	0ff77713          	andi	a4,a4,255
    55e2:	fee5f1e3          	bgeu	a1,a4,55c4 <atoi+0x1e>
  return n;
}
    55e6:	6422                	ld	s0,8(sp)
    55e8:	0141                	addi	sp,sp,16
    55ea:	8082                	ret
  n = 0;
    55ec:	4501                	li	a0,0
    55ee:	bfe5                	j	55e6 <atoi+0x40>

00000000000055f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    55f0:	1141                	addi	sp,sp,-16
    55f2:	e422                	sd	s0,8(sp)
    55f4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    55f6:	02b57463          	bgeu	a0,a1,561e <memmove+0x2e>
    while(n-- > 0)
    55fa:	00c05f63          	blez	a2,5618 <memmove+0x28>
    55fe:	1602                	slli	a2,a2,0x20
    5600:	9201                	srli	a2,a2,0x20
    5602:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5606:	872a                	mv	a4,a0
      *dst++ = *src++;
    5608:	0585                	addi	a1,a1,1
    560a:	0705                	addi	a4,a4,1
    560c:	fff5c683          	lbu	a3,-1(a1)
    5610:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5614:	fee79ae3          	bne	a5,a4,5608 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5618:	6422                	ld	s0,8(sp)
    561a:	0141                	addi	sp,sp,16
    561c:	8082                	ret
    dst += n;
    561e:	00c50733          	add	a4,a0,a2
    src += n;
    5622:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5624:	fec05ae3          	blez	a2,5618 <memmove+0x28>
    5628:	fff6079b          	addiw	a5,a2,-1
    562c:	1782                	slli	a5,a5,0x20
    562e:	9381                	srli	a5,a5,0x20
    5630:	fff7c793          	not	a5,a5
    5634:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5636:	15fd                	addi	a1,a1,-1
    5638:	177d                	addi	a4,a4,-1
    563a:	0005c683          	lbu	a3,0(a1)
    563e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5642:	fee79ae3          	bne	a5,a4,5636 <memmove+0x46>
    5646:	bfc9                	j	5618 <memmove+0x28>

0000000000005648 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5648:	1141                	addi	sp,sp,-16
    564a:	e422                	sd	s0,8(sp)
    564c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    564e:	ca05                	beqz	a2,567e <memcmp+0x36>
    5650:	fff6069b          	addiw	a3,a2,-1
    5654:	1682                	slli	a3,a3,0x20
    5656:	9281                	srli	a3,a3,0x20
    5658:	0685                	addi	a3,a3,1
    565a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    565c:	00054783          	lbu	a5,0(a0)
    5660:	0005c703          	lbu	a4,0(a1)
    5664:	00e79863          	bne	a5,a4,5674 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5668:	0505                	addi	a0,a0,1
    p2++;
    566a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    566c:	fed518e3          	bne	a0,a3,565c <memcmp+0x14>
  }
  return 0;
    5670:	4501                	li	a0,0
    5672:	a019                	j	5678 <memcmp+0x30>
      return *p1 - *p2;
    5674:	40e7853b          	subw	a0,a5,a4
}
    5678:	6422                	ld	s0,8(sp)
    567a:	0141                	addi	sp,sp,16
    567c:	8082                	ret
  return 0;
    567e:	4501                	li	a0,0
    5680:	bfe5                	j	5678 <memcmp+0x30>

0000000000005682 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5682:	1141                	addi	sp,sp,-16
    5684:	e406                	sd	ra,8(sp)
    5686:	e022                	sd	s0,0(sp)
    5688:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    568a:	00000097          	auipc	ra,0x0
    568e:	f66080e7          	jalr	-154(ra) # 55f0 <memmove>
}
    5692:	60a2                	ld	ra,8(sp)
    5694:	6402                	ld	s0,0(sp)
    5696:	0141                	addi	sp,sp,16
    5698:	8082                	ret

000000000000569a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    569a:	4885                	li	a7,1
 ecall
    569c:	00000073          	ecall
 ret
    56a0:	8082                	ret

00000000000056a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
    56a2:	4889                	li	a7,2
 ecall
    56a4:	00000073          	ecall
 ret
    56a8:	8082                	ret

00000000000056aa <wait>:
.global wait
wait:
 li a7, SYS_wait
    56aa:	488d                	li	a7,3
 ecall
    56ac:	00000073          	ecall
 ret
    56b0:	8082                	ret

00000000000056b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    56b2:	4891                	li	a7,4
 ecall
    56b4:	00000073          	ecall
 ret
    56b8:	8082                	ret

00000000000056ba <read>:
.global read
read:
 li a7, SYS_read
    56ba:	4895                	li	a7,5
 ecall
    56bc:	00000073          	ecall
 ret
    56c0:	8082                	ret

00000000000056c2 <write>:
.global write
write:
 li a7, SYS_write
    56c2:	48c1                	li	a7,16
 ecall
    56c4:	00000073          	ecall
 ret
    56c8:	8082                	ret

00000000000056ca <close>:
.global close
close:
 li a7, SYS_close
    56ca:	48d5                	li	a7,21
 ecall
    56cc:	00000073          	ecall
 ret
    56d0:	8082                	ret

00000000000056d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
    56d2:	4899                	li	a7,6
 ecall
    56d4:	00000073          	ecall
 ret
    56d8:	8082                	ret

00000000000056da <exec>:
.global exec
exec:
 li a7, SYS_exec
    56da:	489d                	li	a7,7
 ecall
    56dc:	00000073          	ecall
 ret
    56e0:	8082                	ret

00000000000056e2 <open>:
.global open
open:
 li a7, SYS_open
    56e2:	48bd                	li	a7,15
 ecall
    56e4:	00000073          	ecall
 ret
    56e8:	8082                	ret

00000000000056ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    56ea:	48c5                	li	a7,17
 ecall
    56ec:	00000073          	ecall
 ret
    56f0:	8082                	ret

00000000000056f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    56f2:	48c9                	li	a7,18
 ecall
    56f4:	00000073          	ecall
 ret
    56f8:	8082                	ret

00000000000056fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    56fa:	48a1                	li	a7,8
 ecall
    56fc:	00000073          	ecall
 ret
    5700:	8082                	ret

0000000000005702 <link>:
.global link
link:
 li a7, SYS_link
    5702:	48cd                	li	a7,19
 ecall
    5704:	00000073          	ecall
 ret
    5708:	8082                	ret

000000000000570a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    570a:	48d1                	li	a7,20
 ecall
    570c:	00000073          	ecall
 ret
    5710:	8082                	ret

0000000000005712 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5712:	48a5                	li	a7,9
 ecall
    5714:	00000073          	ecall
 ret
    5718:	8082                	ret

000000000000571a <dup>:
.global dup
dup:
 li a7, SYS_dup
    571a:	48a9                	li	a7,10
 ecall
    571c:	00000073          	ecall
 ret
    5720:	8082                	ret

0000000000005722 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5722:	48ad                	li	a7,11
 ecall
    5724:	00000073          	ecall
 ret
    5728:	8082                	ret

000000000000572a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    572a:	48b1                	li	a7,12
 ecall
    572c:	00000073          	ecall
 ret
    5730:	8082                	ret

0000000000005732 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5732:	48b5                	li	a7,13
 ecall
    5734:	00000073          	ecall
 ret
    5738:	8082                	ret

000000000000573a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    573a:	48b9                	li	a7,14
 ecall
    573c:	00000073          	ecall
 ret
    5740:	8082                	ret

0000000000005742 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
    5742:	48d9                	li	a7,22
 ecall
    5744:	00000073          	ecall
 ret
    5748:	8082                	ret

000000000000574a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    574a:	1101                	addi	sp,sp,-32
    574c:	ec06                	sd	ra,24(sp)
    574e:	e822                	sd	s0,16(sp)
    5750:	1000                	addi	s0,sp,32
    5752:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5756:	4605                	li	a2,1
    5758:	fef40593          	addi	a1,s0,-17
    575c:	00000097          	auipc	ra,0x0
    5760:	f66080e7          	jalr	-154(ra) # 56c2 <write>
}
    5764:	60e2                	ld	ra,24(sp)
    5766:	6442                	ld	s0,16(sp)
    5768:	6105                	addi	sp,sp,32
    576a:	8082                	ret

000000000000576c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    576c:	7139                	addi	sp,sp,-64
    576e:	fc06                	sd	ra,56(sp)
    5770:	f822                	sd	s0,48(sp)
    5772:	f426                	sd	s1,40(sp)
    5774:	f04a                	sd	s2,32(sp)
    5776:	ec4e                	sd	s3,24(sp)
    5778:	0080                	addi	s0,sp,64
    577a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    577c:	c299                	beqz	a3,5782 <printint+0x16>
    577e:	0805c863          	bltz	a1,580e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5782:	2581                	sext.w	a1,a1
  neg = 0;
    5784:	4881                	li	a7,0
    5786:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    578a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    578c:	2601                	sext.w	a2,a2
    578e:	00003517          	auipc	a0,0x3
    5792:	ba250513          	addi	a0,a0,-1118 # 8330 <digits>
    5796:	883a                	mv	a6,a4
    5798:	2705                	addiw	a4,a4,1
    579a:	02c5f7bb          	remuw	a5,a1,a2
    579e:	1782                	slli	a5,a5,0x20
    57a0:	9381                	srli	a5,a5,0x20
    57a2:	97aa                	add	a5,a5,a0
    57a4:	0007c783          	lbu	a5,0(a5)
    57a8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    57ac:	0005879b          	sext.w	a5,a1
    57b0:	02c5d5bb          	divuw	a1,a1,a2
    57b4:	0685                	addi	a3,a3,1
    57b6:	fec7f0e3          	bgeu	a5,a2,5796 <printint+0x2a>
  if(neg)
    57ba:	00088b63          	beqz	a7,57d0 <printint+0x64>
    buf[i++] = '-';
    57be:	fd040793          	addi	a5,s0,-48
    57c2:	973e                	add	a4,a4,a5
    57c4:	02d00793          	li	a5,45
    57c8:	fef70823          	sb	a5,-16(a4)
    57cc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    57d0:	02e05863          	blez	a4,5800 <printint+0x94>
    57d4:	fc040793          	addi	a5,s0,-64
    57d8:	00e78933          	add	s2,a5,a4
    57dc:	fff78993          	addi	s3,a5,-1
    57e0:	99ba                	add	s3,s3,a4
    57e2:	377d                	addiw	a4,a4,-1
    57e4:	1702                	slli	a4,a4,0x20
    57e6:	9301                	srli	a4,a4,0x20
    57e8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    57ec:	fff94583          	lbu	a1,-1(s2)
    57f0:	8526                	mv	a0,s1
    57f2:	00000097          	auipc	ra,0x0
    57f6:	f58080e7          	jalr	-168(ra) # 574a <putc>
  while(--i >= 0)
    57fa:	197d                	addi	s2,s2,-1
    57fc:	ff3918e3          	bne	s2,s3,57ec <printint+0x80>
}
    5800:	70e2                	ld	ra,56(sp)
    5802:	7442                	ld	s0,48(sp)
    5804:	74a2                	ld	s1,40(sp)
    5806:	7902                	ld	s2,32(sp)
    5808:	69e2                	ld	s3,24(sp)
    580a:	6121                	addi	sp,sp,64
    580c:	8082                	ret
    x = -xx;
    580e:	40b005bb          	negw	a1,a1
    neg = 1;
    5812:	4885                	li	a7,1
    x = -xx;
    5814:	bf8d                	j	5786 <printint+0x1a>

0000000000005816 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5816:	7119                	addi	sp,sp,-128
    5818:	fc86                	sd	ra,120(sp)
    581a:	f8a2                	sd	s0,112(sp)
    581c:	f4a6                	sd	s1,104(sp)
    581e:	f0ca                	sd	s2,96(sp)
    5820:	ecce                	sd	s3,88(sp)
    5822:	e8d2                	sd	s4,80(sp)
    5824:	e4d6                	sd	s5,72(sp)
    5826:	e0da                	sd	s6,64(sp)
    5828:	fc5e                	sd	s7,56(sp)
    582a:	f862                	sd	s8,48(sp)
    582c:	f466                	sd	s9,40(sp)
    582e:	f06a                	sd	s10,32(sp)
    5830:	ec6e                	sd	s11,24(sp)
    5832:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5834:	0005c903          	lbu	s2,0(a1)
    5838:	18090f63          	beqz	s2,59d6 <vprintf+0x1c0>
    583c:	8aaa                	mv	s5,a0
    583e:	8b32                	mv	s6,a2
    5840:	00158493          	addi	s1,a1,1
  state = 0;
    5844:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5846:	02500a13          	li	s4,37
      if(c == 'd'){
    584a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    584e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5852:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5856:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    585a:	00003b97          	auipc	s7,0x3
    585e:	ad6b8b93          	addi	s7,s7,-1322 # 8330 <digits>
    5862:	a839                	j	5880 <vprintf+0x6a>
        putc(fd, c);
    5864:	85ca                	mv	a1,s2
    5866:	8556                	mv	a0,s5
    5868:	00000097          	auipc	ra,0x0
    586c:	ee2080e7          	jalr	-286(ra) # 574a <putc>
    5870:	a019                	j	5876 <vprintf+0x60>
    } else if(state == '%'){
    5872:	01498f63          	beq	s3,s4,5890 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5876:	0485                	addi	s1,s1,1
    5878:	fff4c903          	lbu	s2,-1(s1)
    587c:	14090d63          	beqz	s2,59d6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5880:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5884:	fe0997e3          	bnez	s3,5872 <vprintf+0x5c>
      if(c == '%'){
    5888:	fd479ee3          	bne	a5,s4,5864 <vprintf+0x4e>
        state = '%';
    588c:	89be                	mv	s3,a5
    588e:	b7e5                	j	5876 <vprintf+0x60>
      if(c == 'd'){
    5890:	05878063          	beq	a5,s8,58d0 <vprintf+0xba>
      } else if(c == 'l') {
    5894:	05978c63          	beq	a5,s9,58ec <vprintf+0xd6>
      } else if(c == 'x') {
    5898:	07a78863          	beq	a5,s10,5908 <vprintf+0xf2>
      } else if(c == 'p') {
    589c:	09b78463          	beq	a5,s11,5924 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    58a0:	07300713          	li	a4,115
    58a4:	0ce78663          	beq	a5,a4,5970 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    58a8:	06300713          	li	a4,99
    58ac:	0ee78e63          	beq	a5,a4,59a8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    58b0:	11478863          	beq	a5,s4,59c0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    58b4:	85d2                	mv	a1,s4
    58b6:	8556                	mv	a0,s5
    58b8:	00000097          	auipc	ra,0x0
    58bc:	e92080e7          	jalr	-366(ra) # 574a <putc>
        putc(fd, c);
    58c0:	85ca                	mv	a1,s2
    58c2:	8556                	mv	a0,s5
    58c4:	00000097          	auipc	ra,0x0
    58c8:	e86080e7          	jalr	-378(ra) # 574a <putc>
      }
      state = 0;
    58cc:	4981                	li	s3,0
    58ce:	b765                	j	5876 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    58d0:	008b0913          	addi	s2,s6,8
    58d4:	4685                	li	a3,1
    58d6:	4629                	li	a2,10
    58d8:	000b2583          	lw	a1,0(s6)
    58dc:	8556                	mv	a0,s5
    58de:	00000097          	auipc	ra,0x0
    58e2:	e8e080e7          	jalr	-370(ra) # 576c <printint>
    58e6:	8b4a                	mv	s6,s2
      state = 0;
    58e8:	4981                	li	s3,0
    58ea:	b771                	j	5876 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    58ec:	008b0913          	addi	s2,s6,8
    58f0:	4681                	li	a3,0
    58f2:	4629                	li	a2,10
    58f4:	000b2583          	lw	a1,0(s6)
    58f8:	8556                	mv	a0,s5
    58fa:	00000097          	auipc	ra,0x0
    58fe:	e72080e7          	jalr	-398(ra) # 576c <printint>
    5902:	8b4a                	mv	s6,s2
      state = 0;
    5904:	4981                	li	s3,0
    5906:	bf85                	j	5876 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5908:	008b0913          	addi	s2,s6,8
    590c:	4681                	li	a3,0
    590e:	4641                	li	a2,16
    5910:	000b2583          	lw	a1,0(s6)
    5914:	8556                	mv	a0,s5
    5916:	00000097          	auipc	ra,0x0
    591a:	e56080e7          	jalr	-426(ra) # 576c <printint>
    591e:	8b4a                	mv	s6,s2
      state = 0;
    5920:	4981                	li	s3,0
    5922:	bf91                	j	5876 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5924:	008b0793          	addi	a5,s6,8
    5928:	f8f43423          	sd	a5,-120(s0)
    592c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5930:	03000593          	li	a1,48
    5934:	8556                	mv	a0,s5
    5936:	00000097          	auipc	ra,0x0
    593a:	e14080e7          	jalr	-492(ra) # 574a <putc>
  putc(fd, 'x');
    593e:	85ea                	mv	a1,s10
    5940:	8556                	mv	a0,s5
    5942:	00000097          	auipc	ra,0x0
    5946:	e08080e7          	jalr	-504(ra) # 574a <putc>
    594a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    594c:	03c9d793          	srli	a5,s3,0x3c
    5950:	97de                	add	a5,a5,s7
    5952:	0007c583          	lbu	a1,0(a5)
    5956:	8556                	mv	a0,s5
    5958:	00000097          	auipc	ra,0x0
    595c:	df2080e7          	jalr	-526(ra) # 574a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5960:	0992                	slli	s3,s3,0x4
    5962:	397d                	addiw	s2,s2,-1
    5964:	fe0914e3          	bnez	s2,594c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5968:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    596c:	4981                	li	s3,0
    596e:	b721                	j	5876 <vprintf+0x60>
        s = va_arg(ap, char*);
    5970:	008b0993          	addi	s3,s6,8
    5974:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5978:	02090163          	beqz	s2,599a <vprintf+0x184>
        while(*s != 0){
    597c:	00094583          	lbu	a1,0(s2)
    5980:	c9a1                	beqz	a1,59d0 <vprintf+0x1ba>
          putc(fd, *s);
    5982:	8556                	mv	a0,s5
    5984:	00000097          	auipc	ra,0x0
    5988:	dc6080e7          	jalr	-570(ra) # 574a <putc>
          s++;
    598c:	0905                	addi	s2,s2,1
        while(*s != 0){
    598e:	00094583          	lbu	a1,0(s2)
    5992:	f9e5                	bnez	a1,5982 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5994:	8b4e                	mv	s6,s3
      state = 0;
    5996:	4981                	li	s3,0
    5998:	bdf9                	j	5876 <vprintf+0x60>
          s = "(null)";
    599a:	00003917          	auipc	s2,0x3
    599e:	98e90913          	addi	s2,s2,-1650 # 8328 <malloc+0x2848>
        while(*s != 0){
    59a2:	02800593          	li	a1,40
    59a6:	bff1                	j	5982 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    59a8:	008b0913          	addi	s2,s6,8
    59ac:	000b4583          	lbu	a1,0(s6)
    59b0:	8556                	mv	a0,s5
    59b2:	00000097          	auipc	ra,0x0
    59b6:	d98080e7          	jalr	-616(ra) # 574a <putc>
    59ba:	8b4a                	mv	s6,s2
      state = 0;
    59bc:	4981                	li	s3,0
    59be:	bd65                	j	5876 <vprintf+0x60>
        putc(fd, c);
    59c0:	85d2                	mv	a1,s4
    59c2:	8556                	mv	a0,s5
    59c4:	00000097          	auipc	ra,0x0
    59c8:	d86080e7          	jalr	-634(ra) # 574a <putc>
      state = 0;
    59cc:	4981                	li	s3,0
    59ce:	b565                	j	5876 <vprintf+0x60>
        s = va_arg(ap, char*);
    59d0:	8b4e                	mv	s6,s3
      state = 0;
    59d2:	4981                	li	s3,0
    59d4:	b54d                	j	5876 <vprintf+0x60>
    }
  }
}
    59d6:	70e6                	ld	ra,120(sp)
    59d8:	7446                	ld	s0,112(sp)
    59da:	74a6                	ld	s1,104(sp)
    59dc:	7906                	ld	s2,96(sp)
    59de:	69e6                	ld	s3,88(sp)
    59e0:	6a46                	ld	s4,80(sp)
    59e2:	6aa6                	ld	s5,72(sp)
    59e4:	6b06                	ld	s6,64(sp)
    59e6:	7be2                	ld	s7,56(sp)
    59e8:	7c42                	ld	s8,48(sp)
    59ea:	7ca2                	ld	s9,40(sp)
    59ec:	7d02                	ld	s10,32(sp)
    59ee:	6de2                	ld	s11,24(sp)
    59f0:	6109                	addi	sp,sp,128
    59f2:	8082                	ret

00000000000059f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    59f4:	715d                	addi	sp,sp,-80
    59f6:	ec06                	sd	ra,24(sp)
    59f8:	e822                	sd	s0,16(sp)
    59fa:	1000                	addi	s0,sp,32
    59fc:	e010                	sd	a2,0(s0)
    59fe:	e414                	sd	a3,8(s0)
    5a00:	e818                	sd	a4,16(s0)
    5a02:	ec1c                	sd	a5,24(s0)
    5a04:	03043023          	sd	a6,32(s0)
    5a08:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5a0c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5a10:	8622                	mv	a2,s0
    5a12:	00000097          	auipc	ra,0x0
    5a16:	e04080e7          	jalr	-508(ra) # 5816 <vprintf>
}
    5a1a:	60e2                	ld	ra,24(sp)
    5a1c:	6442                	ld	s0,16(sp)
    5a1e:	6161                	addi	sp,sp,80
    5a20:	8082                	ret

0000000000005a22 <printf>:

void
printf(const char *fmt, ...)
{
    5a22:	711d                	addi	sp,sp,-96
    5a24:	ec06                	sd	ra,24(sp)
    5a26:	e822                	sd	s0,16(sp)
    5a28:	1000                	addi	s0,sp,32
    5a2a:	e40c                	sd	a1,8(s0)
    5a2c:	e810                	sd	a2,16(s0)
    5a2e:	ec14                	sd	a3,24(s0)
    5a30:	f018                	sd	a4,32(s0)
    5a32:	f41c                	sd	a5,40(s0)
    5a34:	03043823          	sd	a6,48(s0)
    5a38:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5a3c:	00840613          	addi	a2,s0,8
    5a40:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5a44:	85aa                	mv	a1,a0
    5a46:	4505                	li	a0,1
    5a48:	00000097          	auipc	ra,0x0
    5a4c:	dce080e7          	jalr	-562(ra) # 5816 <vprintf>
}
    5a50:	60e2                	ld	ra,24(sp)
    5a52:	6442                	ld	s0,16(sp)
    5a54:	6125                	addi	sp,sp,96
    5a56:	8082                	ret

0000000000005a58 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5a58:	1141                	addi	sp,sp,-16
    5a5a:	e422                	sd	s0,8(sp)
    5a5c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5a5e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5a62:	00003797          	auipc	a5,0x3
    5a66:	8f67b783          	ld	a5,-1802(a5) # 8358 <freep>
    5a6a:	a805                	j	5a9a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5a6c:	4618                	lw	a4,8(a2)
    5a6e:	9db9                	addw	a1,a1,a4
    5a70:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5a74:	6398                	ld	a4,0(a5)
    5a76:	6318                	ld	a4,0(a4)
    5a78:	fee53823          	sd	a4,-16(a0)
    5a7c:	a091                	j	5ac0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5a7e:	ff852703          	lw	a4,-8(a0)
    5a82:	9e39                	addw	a2,a2,a4
    5a84:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5a86:	ff053703          	ld	a4,-16(a0)
    5a8a:	e398                	sd	a4,0(a5)
    5a8c:	a099                	j	5ad2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5a8e:	6398                	ld	a4,0(a5)
    5a90:	00e7e463          	bltu	a5,a4,5a98 <free+0x40>
    5a94:	00e6ea63          	bltu	a3,a4,5aa8 <free+0x50>
{
    5a98:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5a9a:	fed7fae3          	bgeu	a5,a3,5a8e <free+0x36>
    5a9e:	6398                	ld	a4,0(a5)
    5aa0:	00e6e463          	bltu	a3,a4,5aa8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5aa4:	fee7eae3          	bltu	a5,a4,5a98 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5aa8:	ff852583          	lw	a1,-8(a0)
    5aac:	6390                	ld	a2,0(a5)
    5aae:	02059713          	slli	a4,a1,0x20
    5ab2:	9301                	srli	a4,a4,0x20
    5ab4:	0712                	slli	a4,a4,0x4
    5ab6:	9736                	add	a4,a4,a3
    5ab8:	fae60ae3          	beq	a2,a4,5a6c <free+0x14>
    bp->s.ptr = p->s.ptr;
    5abc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5ac0:	4790                	lw	a2,8(a5)
    5ac2:	02061713          	slli	a4,a2,0x20
    5ac6:	9301                	srli	a4,a4,0x20
    5ac8:	0712                	slli	a4,a4,0x4
    5aca:	973e                	add	a4,a4,a5
    5acc:	fae689e3          	beq	a3,a4,5a7e <free+0x26>
  } else
    p->s.ptr = bp;
    5ad0:	e394                	sd	a3,0(a5)
  freep = p;
    5ad2:	00003717          	auipc	a4,0x3
    5ad6:	88f73323          	sd	a5,-1914(a4) # 8358 <freep>
}
    5ada:	6422                	ld	s0,8(sp)
    5adc:	0141                	addi	sp,sp,16
    5ade:	8082                	ret

0000000000005ae0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5ae0:	7139                	addi	sp,sp,-64
    5ae2:	fc06                	sd	ra,56(sp)
    5ae4:	f822                	sd	s0,48(sp)
    5ae6:	f426                	sd	s1,40(sp)
    5ae8:	f04a                	sd	s2,32(sp)
    5aea:	ec4e                	sd	s3,24(sp)
    5aec:	e852                	sd	s4,16(sp)
    5aee:	e456                	sd	s5,8(sp)
    5af0:	e05a                	sd	s6,0(sp)
    5af2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5af4:	02051493          	slli	s1,a0,0x20
    5af8:	9081                	srli	s1,s1,0x20
    5afa:	04bd                	addi	s1,s1,15
    5afc:	8091                	srli	s1,s1,0x4
    5afe:	0014899b          	addiw	s3,s1,1
    5b02:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5b04:	00003517          	auipc	a0,0x3
    5b08:	85453503          	ld	a0,-1964(a0) # 8358 <freep>
    5b0c:	c515                	beqz	a0,5b38 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5b0e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5b10:	4798                	lw	a4,8(a5)
    5b12:	02977f63          	bgeu	a4,s1,5b50 <malloc+0x70>
    5b16:	8a4e                	mv	s4,s3
    5b18:	0009871b          	sext.w	a4,s3
    5b1c:	6685                	lui	a3,0x1
    5b1e:	00d77363          	bgeu	a4,a3,5b24 <malloc+0x44>
    5b22:	6a05                	lui	s4,0x1
    5b24:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5b28:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5b2c:	00003917          	auipc	s2,0x3
    5b30:	82c90913          	addi	s2,s2,-2004 # 8358 <freep>
  if(p == (char*)-1)
    5b34:	5afd                	li	s5,-1
    5b36:	a88d                	j	5ba8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5b38:	00009797          	auipc	a5,0x9
    5b3c:	04078793          	addi	a5,a5,64 # eb78 <base>
    5b40:	00003717          	auipc	a4,0x3
    5b44:	80f73c23          	sd	a5,-2024(a4) # 8358 <freep>
    5b48:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5b4a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5b4e:	b7e1                	j	5b16 <malloc+0x36>
      if(p->s.size == nunits)
    5b50:	02e48b63          	beq	s1,a4,5b86 <malloc+0xa6>
        p->s.size -= nunits;
    5b54:	4137073b          	subw	a4,a4,s3
    5b58:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5b5a:	1702                	slli	a4,a4,0x20
    5b5c:	9301                	srli	a4,a4,0x20
    5b5e:	0712                	slli	a4,a4,0x4
    5b60:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5b62:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5b66:	00002717          	auipc	a4,0x2
    5b6a:	7ea73923          	sd	a0,2034(a4) # 8358 <freep>
      return (void*)(p + 1);
    5b6e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5b72:	70e2                	ld	ra,56(sp)
    5b74:	7442                	ld	s0,48(sp)
    5b76:	74a2                	ld	s1,40(sp)
    5b78:	7902                	ld	s2,32(sp)
    5b7a:	69e2                	ld	s3,24(sp)
    5b7c:	6a42                	ld	s4,16(sp)
    5b7e:	6aa2                	ld	s5,8(sp)
    5b80:	6b02                	ld	s6,0(sp)
    5b82:	6121                	addi	sp,sp,64
    5b84:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5b86:	6398                	ld	a4,0(a5)
    5b88:	e118                	sd	a4,0(a0)
    5b8a:	bff1                	j	5b66 <malloc+0x86>
  hp->s.size = nu;
    5b8c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5b90:	0541                	addi	a0,a0,16
    5b92:	00000097          	auipc	ra,0x0
    5b96:	ec6080e7          	jalr	-314(ra) # 5a58 <free>
  return freep;
    5b9a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5b9e:	d971                	beqz	a0,5b72 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5ba0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5ba2:	4798                	lw	a4,8(a5)
    5ba4:	fa9776e3          	bgeu	a4,s1,5b50 <malloc+0x70>
    if(p == freep)
    5ba8:	00093703          	ld	a4,0(s2)
    5bac:	853e                	mv	a0,a5
    5bae:	fef719e3          	bne	a4,a5,5ba0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5bb2:	8552                	mv	a0,s4
    5bb4:	00000097          	auipc	ra,0x0
    5bb8:	b76080e7          	jalr	-1162(ra) # 572a <sbrk>
  if(p == (char*)-1)
    5bbc:	fd5518e3          	bne	a0,s5,5b8c <malloc+0xac>
        return 0;
    5bc0:	4501                	li	a0,0
    5bc2:	bf45                	j	5b72 <malloc+0x92>
