
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	85013103          	ld	sp,-1968(sp) # 80008850 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	fee70713          	addi	a4,a4,-18 # 80009040 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	f8c78793          	addi	a5,a5,-116 # 80005ff0 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	e0078793          	addi	a5,a5,-512 # 80000eae <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  timerinit();
    800000d8:	00000097          	auipc	ra,0x0
    800000dc:	f44080e7          	jalr	-188(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000e0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e8:	30200073          	mret
}
    800000ec:	60a2                	ld	ra,8(sp)
    800000ee:	6402                	ld	s0,0(sp)
    800000f0:	0141                	addi	sp,sp,16
    800000f2:	8082                	ret

00000000800000f4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000f4:	715d                	addi	sp,sp,-80
    800000f6:	e486                	sd	ra,72(sp)
    800000f8:	e0a2                	sd	s0,64(sp)
    800000fa:	fc26                	sd	s1,56(sp)
    800000fc:	f84a                	sd	s2,48(sp)
    800000fe:	f44e                	sd	s3,40(sp)
    80000100:	f052                	sd	s4,32(sp)
    80000102:	ec56                	sd	s5,24(sp)
    80000104:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000106:	04c05663          	blez	a2,80000152 <consolewrite+0x5e>
    8000010a:	8a2a                	mv	s4,a0
    8000010c:	84ae                	mv	s1,a1
    8000010e:	89b2                	mv	s3,a2
    80000110:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000112:	5afd                	li	s5,-1
    80000114:	4685                	li	a3,1
    80000116:	8626                	mv	a2,s1
    80000118:	85d2                	mv	a1,s4
    8000011a:	fbf40513          	addi	a0,s0,-65
    8000011e:	00002097          	auipc	ra,0x2
    80000122:	35c080e7          	jalr	860(ra) # 8000247a <either_copyin>
    80000126:	01550c63          	beq	a0,s5,8000013e <consolewrite+0x4a>
      break;
    uartputc(c);
    8000012a:	fbf44503          	lbu	a0,-65(s0)
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	77a080e7          	jalr	1914(ra) # 800008a8 <uartputc>
  for(i = 0; i < n; i++){
    80000136:	2905                	addiw	s2,s2,1
    80000138:	0485                	addi	s1,s1,1
    8000013a:	fd299de3          	bne	s3,s2,80000114 <consolewrite+0x20>
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60a6                	ld	ra,72(sp)
    80000142:	6406                	ld	s0,64(sp)
    80000144:	74e2                	ld	s1,56(sp)
    80000146:	7942                	ld	s2,48(sp)
    80000148:	79a2                	ld	s3,40(sp)
    8000014a:	7a02                	ld	s4,32(sp)
    8000014c:	6ae2                	ld	s5,24(sp)
    8000014e:	6161                	addi	sp,sp,80
    80000150:	8082                	ret
  for(i = 0; i < n; i++){
    80000152:	4901                	li	s2,0
    80000154:	b7ed                	j	8000013e <consolewrite+0x4a>

0000000080000156 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000156:	7159                	addi	sp,sp,-112
    80000158:	f486                	sd	ra,104(sp)
    8000015a:	f0a2                	sd	s0,96(sp)
    8000015c:	eca6                	sd	s1,88(sp)
    8000015e:	e8ca                	sd	s2,80(sp)
    80000160:	e4ce                	sd	s3,72(sp)
    80000162:	e0d2                	sd	s4,64(sp)
    80000164:	fc56                	sd	s5,56(sp)
    80000166:	f85a                	sd	s6,48(sp)
    80000168:	f45e                	sd	s7,40(sp)
    8000016a:	f062                	sd	s8,32(sp)
    8000016c:	ec66                	sd	s9,24(sp)
    8000016e:	e86a                	sd	s10,16(sp)
    80000170:	1880                	addi	s0,sp,112
    80000172:	8aaa                	mv	s5,a0
    80000174:	8a2e                	mv	s4,a1
    80000176:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000178:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000017c:	00011517          	auipc	a0,0x11
    80000180:	00450513          	addi	a0,a0,4 # 80011180 <cons>
    80000184:	00001097          	auipc	ra,0x1
    80000188:	a3e080e7          	jalr	-1474(ra) # 80000bc2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000018c:	00011497          	auipc	s1,0x11
    80000190:	ff448493          	addi	s1,s1,-12 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000194:	00011917          	auipc	s2,0x11
    80000198:	08490913          	addi	s2,s2,132 # 80011218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000019c:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000019e:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001a0:	4ca9                	li	s9,10
  while(n > 0){
    800001a2:	07305863          	blez	s3,80000212 <consoleread+0xbc>
    while(cons.r == cons.w){
    800001a6:	0984a783          	lw	a5,152(s1)
    800001aa:	09c4a703          	lw	a4,156(s1)
    800001ae:	02f71463          	bne	a4,a5,800001d6 <consoleread+0x80>
      if(myproc()->killed){
    800001b2:	00002097          	auipc	ra,0x2
    800001b6:	80e080e7          	jalr	-2034(ra) # 800019c0 <myproc>
    800001ba:	551c                	lw	a5,40(a0)
    800001bc:	e7b5                	bnez	a5,80000228 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001be:	85a6                	mv	a1,s1
    800001c0:	854a                	mv	a0,s2
    800001c2:	00002097          	auipc	ra,0x2
    800001c6:	ebe080e7          	jalr	-322(ra) # 80002080 <sleep>
    while(cons.r == cons.w){
    800001ca:	0984a783          	lw	a5,152(s1)
    800001ce:	09c4a703          	lw	a4,156(s1)
    800001d2:	fef700e3          	beq	a4,a5,800001b2 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001d6:	0017871b          	addiw	a4,a5,1
    800001da:	08e4ac23          	sw	a4,152(s1)
    800001de:	07f7f713          	andi	a4,a5,127
    800001e2:	9726                	add	a4,a4,s1
    800001e4:	01874703          	lbu	a4,24(a4)
    800001e8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001ec:	077d0563          	beq	s10,s7,80000256 <consoleread+0x100>
    cbuf = c;
    800001f0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001f4:	4685                	li	a3,1
    800001f6:	f9f40613          	addi	a2,s0,-97
    800001fa:	85d2                	mv	a1,s4
    800001fc:	8556                	mv	a0,s5
    800001fe:	00002097          	auipc	ra,0x2
    80000202:	226080e7          	jalr	550(ra) # 80002424 <either_copyout>
    80000206:	01850663          	beq	a0,s8,80000212 <consoleread+0xbc>
    dst++;
    8000020a:	0a05                	addi	s4,s4,1
    --n;
    8000020c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000020e:	f99d1ae3          	bne	s10,s9,800001a2 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000212:	00011517          	auipc	a0,0x11
    80000216:	f6e50513          	addi	a0,a0,-146 # 80011180 <cons>
    8000021a:	00001097          	auipc	ra,0x1
    8000021e:	a5c080e7          	jalr	-1444(ra) # 80000c76 <release>

  return target - n;
    80000222:	413b053b          	subw	a0,s6,s3
    80000226:	a811                	j	8000023a <consoleread+0xe4>
        release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	f5850513          	addi	a0,a0,-168 # 80011180 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	a46080e7          	jalr	-1466(ra) # 80000c76 <release>
        return -1;
    80000238:	557d                	li	a0,-1
}
    8000023a:	70a6                	ld	ra,104(sp)
    8000023c:	7406                	ld	s0,96(sp)
    8000023e:	64e6                	ld	s1,88(sp)
    80000240:	6946                	ld	s2,80(sp)
    80000242:	69a6                	ld	s3,72(sp)
    80000244:	6a06                	ld	s4,64(sp)
    80000246:	7ae2                	ld	s5,56(sp)
    80000248:	7b42                	ld	s6,48(sp)
    8000024a:	7ba2                	ld	s7,40(sp)
    8000024c:	7c02                	ld	s8,32(sp)
    8000024e:	6ce2                	ld	s9,24(sp)
    80000250:	6d42                	ld	s10,16(sp)
    80000252:	6165                	addi	sp,sp,112
    80000254:	8082                	ret
      if(n < target){
    80000256:	0009871b          	sext.w	a4,s3
    8000025a:	fb677ce3          	bgeu	a4,s6,80000212 <consoleread+0xbc>
        cons.r--;
    8000025e:	00011717          	auipc	a4,0x11
    80000262:	faf72d23          	sw	a5,-70(a4) # 80011218 <cons+0x98>
    80000266:	b775                	j	80000212 <consoleread+0xbc>

0000000080000268 <consputc>:
{
    80000268:	1141                	addi	sp,sp,-16
    8000026a:	e406                	sd	ra,8(sp)
    8000026c:	e022                	sd	s0,0(sp)
    8000026e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000270:	10000793          	li	a5,256
    80000274:	00f50a63          	beq	a0,a5,80000288 <consputc+0x20>
    uartputc_sync(c);
    80000278:	00000097          	auipc	ra,0x0
    8000027c:	55e080e7          	jalr	1374(ra) # 800007d6 <uartputc_sync>
}
    80000280:	60a2                	ld	ra,8(sp)
    80000282:	6402                	ld	s0,0(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000288:	4521                	li	a0,8
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	54c080e7          	jalr	1356(ra) # 800007d6 <uartputc_sync>
    80000292:	02000513          	li	a0,32
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	540080e7          	jalr	1344(ra) # 800007d6 <uartputc_sync>
    8000029e:	4521                	li	a0,8
    800002a0:	00000097          	auipc	ra,0x0
    800002a4:	536080e7          	jalr	1334(ra) # 800007d6 <uartputc_sync>
    800002a8:	bfe1                	j	80000280 <consputc+0x18>

00000000800002aa <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002aa:	1101                	addi	sp,sp,-32
    800002ac:	ec06                	sd	ra,24(sp)
    800002ae:	e822                	sd	s0,16(sp)
    800002b0:	e426                	sd	s1,8(sp)
    800002b2:	e04a                	sd	s2,0(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00011517          	auipc	a0,0x11
    800002bc:	ec850513          	addi	a0,a0,-312 # 80011180 <cons>
    800002c0:	00001097          	auipc	ra,0x1
    800002c4:	902080e7          	jalr	-1790(ra) # 80000bc2 <acquire>

  switch(c){
    800002c8:	47d5                	li	a5,21
    800002ca:	0af48663          	beq	s1,a5,80000376 <consoleintr+0xcc>
    800002ce:	0297ca63          	blt	a5,s1,80000302 <consoleintr+0x58>
    800002d2:	47a1                	li	a5,8
    800002d4:	0ef48763          	beq	s1,a5,800003c2 <consoleintr+0x118>
    800002d8:	47c1                	li	a5,16
    800002da:	10f49a63          	bne	s1,a5,800003ee <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002de:	00002097          	auipc	ra,0x2
    800002e2:	1f2080e7          	jalr	498(ra) # 800024d0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002e6:	00011517          	auipc	a0,0x11
    800002ea:	e9a50513          	addi	a0,a0,-358 # 80011180 <cons>
    800002ee:	00001097          	auipc	ra,0x1
    800002f2:	988080e7          	jalr	-1656(ra) # 80000c76 <release>
}
    800002f6:	60e2                	ld	ra,24(sp)
    800002f8:	6442                	ld	s0,16(sp)
    800002fa:	64a2                	ld	s1,8(sp)
    800002fc:	6902                	ld	s2,0(sp)
    800002fe:	6105                	addi	sp,sp,32
    80000300:	8082                	ret
  switch(c){
    80000302:	07f00793          	li	a5,127
    80000306:	0af48e63          	beq	s1,a5,800003c2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000030a:	00011717          	auipc	a4,0x11
    8000030e:	e7670713          	addi	a4,a4,-394 # 80011180 <cons>
    80000312:	0a072783          	lw	a5,160(a4)
    80000316:	09872703          	lw	a4,152(a4)
    8000031a:	9f99                	subw	a5,a5,a4
    8000031c:	07f00713          	li	a4,127
    80000320:	fcf763e3          	bltu	a4,a5,800002e6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000324:	47b5                	li	a5,13
    80000326:	0cf48763          	beq	s1,a5,800003f4 <consoleintr+0x14a>
      consputc(c);
    8000032a:	8526                	mv	a0,s1
    8000032c:	00000097          	auipc	ra,0x0
    80000330:	f3c080e7          	jalr	-196(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000334:	00011797          	auipc	a5,0x11
    80000338:	e4c78793          	addi	a5,a5,-436 # 80011180 <cons>
    8000033c:	0a07a703          	lw	a4,160(a5)
    80000340:	0017069b          	addiw	a3,a4,1
    80000344:	0006861b          	sext.w	a2,a3
    80000348:	0ad7a023          	sw	a3,160(a5)
    8000034c:	07f77713          	andi	a4,a4,127
    80000350:	97ba                	add	a5,a5,a4
    80000352:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000356:	47a9                	li	a5,10
    80000358:	0cf48563          	beq	s1,a5,80000422 <consoleintr+0x178>
    8000035c:	4791                	li	a5,4
    8000035e:	0cf48263          	beq	s1,a5,80000422 <consoleintr+0x178>
    80000362:	00011797          	auipc	a5,0x11
    80000366:	eb67a783          	lw	a5,-330(a5) # 80011218 <cons+0x98>
    8000036a:	0807879b          	addiw	a5,a5,128
    8000036e:	f6f61ce3          	bne	a2,a5,800002e6 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000372:	863e                	mv	a2,a5
    80000374:	a07d                	j	80000422 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000376:	00011717          	auipc	a4,0x11
    8000037a:	e0a70713          	addi	a4,a4,-502 # 80011180 <cons>
    8000037e:	0a072783          	lw	a5,160(a4)
    80000382:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000386:	00011497          	auipc	s1,0x11
    8000038a:	dfa48493          	addi	s1,s1,-518 # 80011180 <cons>
    while(cons.e != cons.w &&
    8000038e:	4929                	li	s2,10
    80000390:	f4f70be3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000394:	37fd                	addiw	a5,a5,-1
    80000396:	07f7f713          	andi	a4,a5,127
    8000039a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000039c:	01874703          	lbu	a4,24(a4)
    800003a0:	f52703e3          	beq	a4,s2,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003a4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003a8:	10000513          	li	a0,256
    800003ac:	00000097          	auipc	ra,0x0
    800003b0:	ebc080e7          	jalr	-324(ra) # 80000268 <consputc>
    while(cons.e != cons.w &&
    800003b4:	0a04a783          	lw	a5,160(s1)
    800003b8:	09c4a703          	lw	a4,156(s1)
    800003bc:	fcf71ce3          	bne	a4,a5,80000394 <consoleintr+0xea>
    800003c0:	b71d                	j	800002e6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003c2:	00011717          	auipc	a4,0x11
    800003c6:	dbe70713          	addi	a4,a4,-578 # 80011180 <cons>
    800003ca:	0a072783          	lw	a5,160(a4)
    800003ce:	09c72703          	lw	a4,156(a4)
    800003d2:	f0f70ae3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003d6:	37fd                	addiw	a5,a5,-1
    800003d8:	00011717          	auipc	a4,0x11
    800003dc:	e4f72423          	sw	a5,-440(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    800003e0:	10000513          	li	a0,256
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	e84080e7          	jalr	-380(ra) # 80000268 <consputc>
    800003ec:	bded                	j	800002e6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800003ee:	ee048ce3          	beqz	s1,800002e6 <consoleintr+0x3c>
    800003f2:	bf21                	j	8000030a <consoleintr+0x60>
      consputc(c);
    800003f4:	4529                	li	a0,10
    800003f6:	00000097          	auipc	ra,0x0
    800003fa:	e72080e7          	jalr	-398(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800003fe:	00011797          	auipc	a5,0x11
    80000402:	d8278793          	addi	a5,a5,-638 # 80011180 <cons>
    80000406:	0a07a703          	lw	a4,160(a5)
    8000040a:	0017069b          	addiw	a3,a4,1
    8000040e:	0006861b          	sext.w	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	00011797          	auipc	a5,0x11
    80000426:	dec7ad23          	sw	a2,-518(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	00011517          	auipc	a0,0x11
    8000042e:	dee50513          	addi	a0,a0,-530 # 80011218 <cons+0x98>
    80000432:	00002097          	auipc	ra,0x2
    80000436:	dda080e7          	jalr	-550(ra) # 8000220c <wakeup>
    8000043a:	b575                	j	800002e6 <consoleintr+0x3c>

000000008000043c <consoleinit>:

void
consoleinit(void)
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e406                	sd	ra,8(sp)
    80000440:	e022                	sd	s0,0(sp)
    80000442:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000444:	00008597          	auipc	a1,0x8
    80000448:	bcc58593          	addi	a1,a1,-1076 # 80008010 <etext+0x10>
    8000044c:	00011517          	auipc	a0,0x11
    80000450:	d3450513          	addi	a0,a0,-716 # 80011180 <cons>
    80000454:	00000097          	auipc	ra,0x0
    80000458:	6de080e7          	jalr	1758(ra) # 80000b32 <initlock>

  uartinit();
    8000045c:	00000097          	auipc	ra,0x0
    80000460:	32a080e7          	jalr	810(ra) # 80000786 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000464:	00021797          	auipc	a5,0x21
    80000468:	eb478793          	addi	a5,a5,-332 # 80021318 <devsw>
    8000046c:	00000717          	auipc	a4,0x0
    80000470:	cea70713          	addi	a4,a4,-790 # 80000156 <consoleread>
    80000474:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000476:	00000717          	auipc	a4,0x0
    8000047a:	c7e70713          	addi	a4,a4,-898 # 800000f4 <consolewrite>
    8000047e:	ef98                	sd	a4,24(a5)
}
    80000480:	60a2                	ld	ra,8(sp)
    80000482:	6402                	ld	s0,0(sp)
    80000484:	0141                	addi	sp,sp,16
    80000486:	8082                	ret

0000000080000488 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000488:	7179                	addi	sp,sp,-48
    8000048a:	f406                	sd	ra,40(sp)
    8000048c:	f022                	sd	s0,32(sp)
    8000048e:	ec26                	sd	s1,24(sp)
    80000490:	e84a                	sd	s2,16(sp)
    80000492:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000494:	c219                	beqz	a2,8000049a <printint+0x12>
    80000496:	08054663          	bltz	a0,80000522 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    8000049a:	2501                	sext.w	a0,a0
    8000049c:	4881                	li	a7,0
    8000049e:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004a2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004a4:	2581                	sext.w	a1,a1
    800004a6:	00008617          	auipc	a2,0x8
    800004aa:	b9a60613          	addi	a2,a2,-1126 # 80008040 <digits>
    800004ae:	883a                	mv	a6,a4
    800004b0:	2705                	addiw	a4,a4,1
    800004b2:	02b577bb          	remuw	a5,a0,a1
    800004b6:	1782                	slli	a5,a5,0x20
    800004b8:	9381                	srli	a5,a5,0x20
    800004ba:	97b2                	add	a5,a5,a2
    800004bc:	0007c783          	lbu	a5,0(a5)
    800004c0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004c4:	0005079b          	sext.w	a5,a0
    800004c8:	02b5553b          	divuw	a0,a0,a1
    800004cc:	0685                	addi	a3,a3,1
    800004ce:	feb7f0e3          	bgeu	a5,a1,800004ae <printint+0x26>

  if(sign)
    800004d2:	00088b63          	beqz	a7,800004e8 <printint+0x60>
    buf[i++] = '-';
    800004d6:	fe040793          	addi	a5,s0,-32
    800004da:	973e                	add	a4,a4,a5
    800004dc:	02d00793          	li	a5,45
    800004e0:	fef70823          	sb	a5,-16(a4)
    800004e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004e8:	02e05763          	blez	a4,80000516 <printint+0x8e>
    800004ec:	fd040793          	addi	a5,s0,-48
    800004f0:	00e784b3          	add	s1,a5,a4
    800004f4:	fff78913          	addi	s2,a5,-1
    800004f8:	993a                	add	s2,s2,a4
    800004fa:	377d                	addiw	a4,a4,-1
    800004fc:	1702                	slli	a4,a4,0x20
    800004fe:	9301                	srli	a4,a4,0x20
    80000500:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000504:	fff4c503          	lbu	a0,-1(s1)
    80000508:	00000097          	auipc	ra,0x0
    8000050c:	d60080e7          	jalr	-672(ra) # 80000268 <consputc>
  while(--i >= 0)
    80000510:	14fd                	addi	s1,s1,-1
    80000512:	ff2499e3          	bne	s1,s2,80000504 <printint+0x7c>
}
    80000516:	70a2                	ld	ra,40(sp)
    80000518:	7402                	ld	s0,32(sp)
    8000051a:	64e2                	ld	s1,24(sp)
    8000051c:	6942                	ld	s2,16(sp)
    8000051e:	6145                	addi	sp,sp,48
    80000520:	8082                	ret
    x = -xx;
    80000522:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000526:	4885                	li	a7,1
    x = -xx;
    80000528:	bf9d                	j	8000049e <printint+0x16>

000000008000052a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000052a:	1101                	addi	sp,sp,-32
    8000052c:	ec06                	sd	ra,24(sp)
    8000052e:	e822                	sd	s0,16(sp)
    80000530:	e426                	sd	s1,8(sp)
    80000532:	1000                	addi	s0,sp,32
    80000534:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000536:	00011797          	auipc	a5,0x11
    8000053a:	d007a523          	sw	zero,-758(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000053e:	00008517          	auipc	a0,0x8
    80000542:	ada50513          	addi	a0,a0,-1318 # 80008018 <etext+0x18>
    80000546:	00000097          	auipc	ra,0x0
    8000054a:	02e080e7          	jalr	46(ra) # 80000574 <printf>
  printf(s);
    8000054e:	8526                	mv	a0,s1
    80000550:	00000097          	auipc	ra,0x0
    80000554:	024080e7          	jalr	36(ra) # 80000574 <printf>
  printf("\n");
    80000558:	00008517          	auipc	a0,0x8
    8000055c:	b7050513          	addi	a0,a0,-1168 # 800080c8 <digits+0x88>
    80000560:	00000097          	auipc	ra,0x0
    80000564:	014080e7          	jalr	20(ra) # 80000574 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000568:	4785                	li	a5,1
    8000056a:	00009717          	auipc	a4,0x9
    8000056e:	a8f72b23          	sw	a5,-1386(a4) # 80009000 <panicked>
  for(;;)
    80000572:	a001                	j	80000572 <panic+0x48>

0000000080000574 <printf>:
{
    80000574:	7131                	addi	sp,sp,-192
    80000576:	fc86                	sd	ra,120(sp)
    80000578:	f8a2                	sd	s0,112(sp)
    8000057a:	f4a6                	sd	s1,104(sp)
    8000057c:	f0ca                	sd	s2,96(sp)
    8000057e:	ecce                	sd	s3,88(sp)
    80000580:	e8d2                	sd	s4,80(sp)
    80000582:	e4d6                	sd	s5,72(sp)
    80000584:	e0da                	sd	s6,64(sp)
    80000586:	fc5e                	sd	s7,56(sp)
    80000588:	f862                	sd	s8,48(sp)
    8000058a:	f466                	sd	s9,40(sp)
    8000058c:	f06a                	sd	s10,32(sp)
    8000058e:	ec6e                	sd	s11,24(sp)
    80000590:	0100                	addi	s0,sp,128
    80000592:	8a2a                	mv	s4,a0
    80000594:	e40c                	sd	a1,8(s0)
    80000596:	e810                	sd	a2,16(s0)
    80000598:	ec14                	sd	a3,24(s0)
    8000059a:	f018                	sd	a4,32(s0)
    8000059c:	f41c                	sd	a5,40(s0)
    8000059e:	03043823          	sd	a6,48(s0)
    800005a2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005a6:	00011d97          	auipc	s11,0x11
    800005aa:	c9adad83          	lw	s11,-870(s11) # 80011240 <pr+0x18>
  if(locking)
    800005ae:	020d9b63          	bnez	s11,800005e4 <printf+0x70>
  if (fmt == 0)
    800005b2:	040a0263          	beqz	s4,800005f6 <printf+0x82>
  va_start(ap, fmt);
    800005b6:	00840793          	addi	a5,s0,8
    800005ba:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005be:	000a4503          	lbu	a0,0(s4)
    800005c2:	14050f63          	beqz	a0,80000720 <printf+0x1ac>
    800005c6:	4981                	li	s3,0
    if(c != '%'){
    800005c8:	02500a93          	li	s5,37
    switch(c){
    800005cc:	07000b93          	li	s7,112
  consputc('x');
    800005d0:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005d2:	00008b17          	auipc	s6,0x8
    800005d6:	a6eb0b13          	addi	s6,s6,-1426 # 80008040 <digits>
    switch(c){
    800005da:	07300c93          	li	s9,115
    800005de:	06400c13          	li	s8,100
    800005e2:	a82d                	j	8000061c <printf+0xa8>
    acquire(&pr.lock);
    800005e4:	00011517          	auipc	a0,0x11
    800005e8:	c4450513          	addi	a0,a0,-956 # 80011228 <pr>
    800005ec:	00000097          	auipc	ra,0x0
    800005f0:	5d6080e7          	jalr	1494(ra) # 80000bc2 <acquire>
    800005f4:	bf7d                	j	800005b2 <printf+0x3e>
    panic("null fmt");
    800005f6:	00008517          	auipc	a0,0x8
    800005fa:	a3250513          	addi	a0,a0,-1486 # 80008028 <etext+0x28>
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	f2c080e7          	jalr	-212(ra) # 8000052a <panic>
      consputc(c);
    80000606:	00000097          	auipc	ra,0x0
    8000060a:	c62080e7          	jalr	-926(ra) # 80000268 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000060e:	2985                	addiw	s3,s3,1
    80000610:	013a07b3          	add	a5,s4,s3
    80000614:	0007c503          	lbu	a0,0(a5)
    80000618:	10050463          	beqz	a0,80000720 <printf+0x1ac>
    if(c != '%'){
    8000061c:	ff5515e3          	bne	a0,s5,80000606 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000620:	2985                	addiw	s3,s3,1
    80000622:	013a07b3          	add	a5,s4,s3
    80000626:	0007c783          	lbu	a5,0(a5)
    8000062a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000062e:	cbed                	beqz	a5,80000720 <printf+0x1ac>
    switch(c){
    80000630:	05778a63          	beq	a5,s7,80000684 <printf+0x110>
    80000634:	02fbf663          	bgeu	s7,a5,80000660 <printf+0xec>
    80000638:	09978863          	beq	a5,s9,800006c8 <printf+0x154>
    8000063c:	07800713          	li	a4,120
    80000640:	0ce79563          	bne	a5,a4,8000070a <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	85ea                	mv	a1,s10
    80000654:	4388                	lw	a0,0(a5)
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	e32080e7          	jalr	-462(ra) # 80000488 <printint>
      break;
    8000065e:	bf45                	j	8000060e <printf+0x9a>
    switch(c){
    80000660:	09578f63          	beq	a5,s5,800006fe <printf+0x18a>
    80000664:	0b879363          	bne	a5,s8,8000070a <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000668:	f8843783          	ld	a5,-120(s0)
    8000066c:	00878713          	addi	a4,a5,8
    80000670:	f8e43423          	sd	a4,-120(s0)
    80000674:	4605                	li	a2,1
    80000676:	45a9                	li	a1,10
    80000678:	4388                	lw	a0,0(a5)
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	e0e080e7          	jalr	-498(ra) # 80000488 <printint>
      break;
    80000682:	b771                	j	8000060e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000684:	f8843783          	ld	a5,-120(s0)
    80000688:	00878713          	addi	a4,a5,8
    8000068c:	f8e43423          	sd	a4,-120(s0)
    80000690:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000694:	03000513          	li	a0,48
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	bd0080e7          	jalr	-1072(ra) # 80000268 <consputc>
  consputc('x');
    800006a0:	07800513          	li	a0,120
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	bc4080e7          	jalr	-1084(ra) # 80000268 <consputc>
    800006ac:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ae:	03c95793          	srli	a5,s2,0x3c
    800006b2:	97da                	add	a5,a5,s6
    800006b4:	0007c503          	lbu	a0,0(a5)
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bb0080e7          	jalr	-1104(ra) # 80000268 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006c0:	0912                	slli	s2,s2,0x4
    800006c2:	34fd                	addiw	s1,s1,-1
    800006c4:	f4ed                	bnez	s1,800006ae <printf+0x13a>
    800006c6:	b7a1                	j	8000060e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006c8:	f8843783          	ld	a5,-120(s0)
    800006cc:	00878713          	addi	a4,a5,8
    800006d0:	f8e43423          	sd	a4,-120(s0)
    800006d4:	6384                	ld	s1,0(a5)
    800006d6:	cc89                	beqz	s1,800006f0 <printf+0x17c>
      for(; *s; s++)
    800006d8:	0004c503          	lbu	a0,0(s1)
    800006dc:	d90d                	beqz	a0,8000060e <printf+0x9a>
        consputc(*s);
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	b8a080e7          	jalr	-1142(ra) # 80000268 <consputc>
      for(; *s; s++)
    800006e6:	0485                	addi	s1,s1,1
    800006e8:	0004c503          	lbu	a0,0(s1)
    800006ec:	f96d                	bnez	a0,800006de <printf+0x16a>
    800006ee:	b705                	j	8000060e <printf+0x9a>
        s = "(null)";
    800006f0:	00008497          	auipc	s1,0x8
    800006f4:	93048493          	addi	s1,s1,-1744 # 80008020 <etext+0x20>
      for(; *s; s++)
    800006f8:	02800513          	li	a0,40
    800006fc:	b7cd                	j	800006de <printf+0x16a>
      consputc('%');
    800006fe:	8556                	mv	a0,s5
    80000700:	00000097          	auipc	ra,0x0
    80000704:	b68080e7          	jalr	-1176(ra) # 80000268 <consputc>
      break;
    80000708:	b719                	j	8000060e <printf+0x9a>
      consputc('%');
    8000070a:	8556                	mv	a0,s5
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	b5c080e7          	jalr	-1188(ra) # 80000268 <consputc>
      consputc(c);
    80000714:	8526                	mv	a0,s1
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b52080e7          	jalr	-1198(ra) # 80000268 <consputc>
      break;
    8000071e:	bdc5                	j	8000060e <printf+0x9a>
  if(locking)
    80000720:	020d9163          	bnez	s11,80000742 <printf+0x1ce>
}
    80000724:	70e6                	ld	ra,120(sp)
    80000726:	7446                	ld	s0,112(sp)
    80000728:	74a6                	ld	s1,104(sp)
    8000072a:	7906                	ld	s2,96(sp)
    8000072c:	69e6                	ld	s3,88(sp)
    8000072e:	6a46                	ld	s4,80(sp)
    80000730:	6aa6                	ld	s5,72(sp)
    80000732:	6b06                	ld	s6,64(sp)
    80000734:	7be2                	ld	s7,56(sp)
    80000736:	7c42                	ld	s8,48(sp)
    80000738:	7ca2                	ld	s9,40(sp)
    8000073a:	7d02                	ld	s10,32(sp)
    8000073c:	6de2                	ld	s11,24(sp)
    8000073e:	6129                	addi	sp,sp,192
    80000740:	8082                	ret
    release(&pr.lock);
    80000742:	00011517          	auipc	a0,0x11
    80000746:	ae650513          	addi	a0,a0,-1306 # 80011228 <pr>
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	52c080e7          	jalr	1324(ra) # 80000c76 <release>
}
    80000752:	bfc9                	j	80000724 <printf+0x1b0>

0000000080000754 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000754:	1101                	addi	sp,sp,-32
    80000756:	ec06                	sd	ra,24(sp)
    80000758:	e822                	sd	s0,16(sp)
    8000075a:	e426                	sd	s1,8(sp)
    8000075c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000075e:	00011497          	auipc	s1,0x11
    80000762:	aca48493          	addi	s1,s1,-1334 # 80011228 <pr>
    80000766:	00008597          	auipc	a1,0x8
    8000076a:	8d258593          	addi	a1,a1,-1838 # 80008038 <etext+0x38>
    8000076e:	8526                	mv	a0,s1
    80000770:	00000097          	auipc	ra,0x0
    80000774:	3c2080e7          	jalr	962(ra) # 80000b32 <initlock>
  pr.locking = 1;
    80000778:	4785                	li	a5,1
    8000077a:	cc9c                	sw	a5,24(s1)
}
    8000077c:	60e2                	ld	ra,24(sp)
    8000077e:	6442                	ld	s0,16(sp)
    80000780:	64a2                	ld	s1,8(sp)
    80000782:	6105                	addi	sp,sp,32
    80000784:	8082                	ret

0000000080000786 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000786:	1141                	addi	sp,sp,-16
    80000788:	e406                	sd	ra,8(sp)
    8000078a:	e022                	sd	s0,0(sp)
    8000078c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000078e:	100007b7          	lui	a5,0x10000
    80000792:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000796:	f8000713          	li	a4,-128
    8000079a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000079e:	470d                	li	a4,3
    800007a0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007a4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007a8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007ac:	469d                	li	a3,7
    800007ae:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007b2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007b6:	00008597          	auipc	a1,0x8
    800007ba:	8a258593          	addi	a1,a1,-1886 # 80008058 <digits+0x18>
    800007be:	00011517          	auipc	a0,0x11
    800007c2:	a8a50513          	addi	a0,a0,-1398 # 80011248 <uart_tx_lock>
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	36c080e7          	jalr	876(ra) # 80000b32 <initlock>
}
    800007ce:	60a2                	ld	ra,8(sp)
    800007d0:	6402                	ld	s0,0(sp)
    800007d2:	0141                	addi	sp,sp,16
    800007d4:	8082                	ret

00000000800007d6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
    800007e0:	84aa                	mv	s1,a0
  push_off();
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	394080e7          	jalr	916(ra) # 80000b76 <push_off>

  if(panicked){
    800007ea:	00009797          	auipc	a5,0x9
    800007ee:	8167a783          	lw	a5,-2026(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007f2:	10000737          	lui	a4,0x10000
  if(panicked){
    800007f6:	c391                	beqz	a5,800007fa <uartputc_sync+0x24>
    for(;;)
    800007f8:	a001                	j	800007f8 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007fa:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007fe:	0207f793          	andi	a5,a5,32
    80000802:	dfe5                	beqz	a5,800007fa <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000804:	0ff4f513          	andi	a0,s1,255
    80000808:	100007b7          	lui	a5,0x10000
    8000080c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000810:	00000097          	auipc	ra,0x0
    80000814:	406080e7          	jalr	1030(ra) # 80000c16 <pop_off>
}
    80000818:	60e2                	ld	ra,24(sp)
    8000081a:	6442                	ld	s0,16(sp)
    8000081c:	64a2                	ld	s1,8(sp)
    8000081e:	6105                	addi	sp,sp,32
    80000820:	8082                	ret

0000000080000822 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000822:	00008797          	auipc	a5,0x8
    80000826:	7e67b783          	ld	a5,2022(a5) # 80009008 <uart_tx_r>
    8000082a:	00008717          	auipc	a4,0x8
    8000082e:	7e673703          	ld	a4,2022(a4) # 80009010 <uart_tx_w>
    80000832:	06f70a63          	beq	a4,a5,800008a6 <uartstart+0x84>
{
    80000836:	7139                	addi	sp,sp,-64
    80000838:	fc06                	sd	ra,56(sp)
    8000083a:	f822                	sd	s0,48(sp)
    8000083c:	f426                	sd	s1,40(sp)
    8000083e:	f04a                	sd	s2,32(sp)
    80000840:	ec4e                	sd	s3,24(sp)
    80000842:	e852                	sd	s4,16(sp)
    80000844:	e456                	sd	s5,8(sp)
    80000846:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000848:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000084c:	00011a17          	auipc	s4,0x11
    80000850:	9fca0a13          	addi	s4,s4,-1540 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    80000854:	00008497          	auipc	s1,0x8
    80000858:	7b448493          	addi	s1,s1,1972 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000085c:	00008997          	auipc	s3,0x8
    80000860:	7b498993          	addi	s3,s3,1972 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000864:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000868:	02077713          	andi	a4,a4,32
    8000086c:	c705                	beqz	a4,80000894 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000086e:	01f7f713          	andi	a4,a5,31
    80000872:	9752                	add	a4,a4,s4
    80000874:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000878:	0785                	addi	a5,a5,1
    8000087a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000087c:	8526                	mv	a0,s1
    8000087e:	00002097          	auipc	ra,0x2
    80000882:	98e080e7          	jalr	-1650(ra) # 8000220c <wakeup>
    
    WriteReg(THR, c);
    80000886:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000088a:	609c                	ld	a5,0(s1)
    8000088c:	0009b703          	ld	a4,0(s3)
    80000890:	fcf71ae3          	bne	a4,a5,80000864 <uartstart+0x42>
  }
}
    80000894:	70e2                	ld	ra,56(sp)
    80000896:	7442                	ld	s0,48(sp)
    80000898:	74a2                	ld	s1,40(sp)
    8000089a:	7902                	ld	s2,32(sp)
    8000089c:	69e2                	ld	s3,24(sp)
    8000089e:	6a42                	ld	s4,16(sp)
    800008a0:	6aa2                	ld	s5,8(sp)
    800008a2:	6121                	addi	sp,sp,64
    800008a4:	8082                	ret
    800008a6:	8082                	ret

00000000800008a8 <uartputc>:
{
    800008a8:	7179                	addi	sp,sp,-48
    800008aa:	f406                	sd	ra,40(sp)
    800008ac:	f022                	sd	s0,32(sp)
    800008ae:	ec26                	sd	s1,24(sp)
    800008b0:	e84a                	sd	s2,16(sp)
    800008b2:	e44e                	sd	s3,8(sp)
    800008b4:	e052                	sd	s4,0(sp)
    800008b6:	1800                	addi	s0,sp,48
    800008b8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ba:	00011517          	auipc	a0,0x11
    800008be:	98e50513          	addi	a0,a0,-1650 # 80011248 <uart_tx_lock>
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	300080e7          	jalr	768(ra) # 80000bc2 <acquire>
  if(panicked){
    800008ca:	00008797          	auipc	a5,0x8
    800008ce:	7367a783          	lw	a5,1846(a5) # 80009000 <panicked>
    800008d2:	c391                	beqz	a5,800008d6 <uartputc+0x2e>
    for(;;)
    800008d4:	a001                	j	800008d4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008d6:	00008717          	auipc	a4,0x8
    800008da:	73a73703          	ld	a4,1850(a4) # 80009010 <uart_tx_w>
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	72a7b783          	ld	a5,1834(a5) # 80009008 <uart_tx_r>
    800008e6:	02078793          	addi	a5,a5,32
    800008ea:	02e79b63          	bne	a5,a4,80000920 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800008ee:	00011997          	auipc	s3,0x11
    800008f2:	95a98993          	addi	s3,s3,-1702 # 80011248 <uart_tx_lock>
    800008f6:	00008497          	auipc	s1,0x8
    800008fa:	71248493          	addi	s1,s1,1810 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008fe:	00008917          	auipc	s2,0x8
    80000902:	71290913          	addi	s2,s2,1810 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000906:	85ce                	mv	a1,s3
    80000908:	8526                	mv	a0,s1
    8000090a:	00001097          	auipc	ra,0x1
    8000090e:	776080e7          	jalr	1910(ra) # 80002080 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000912:	00093703          	ld	a4,0(s2)
    80000916:	609c                	ld	a5,0(s1)
    80000918:	02078793          	addi	a5,a5,32
    8000091c:	fee785e3          	beq	a5,a4,80000906 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000920:	00011497          	auipc	s1,0x11
    80000924:	92848493          	addi	s1,s1,-1752 # 80011248 <uart_tx_lock>
    80000928:	01f77793          	andi	a5,a4,31
    8000092c:	97a6                	add	a5,a5,s1
    8000092e:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000932:	0705                	addi	a4,a4,1
    80000934:	00008797          	auipc	a5,0x8
    80000938:	6ce7be23          	sd	a4,1756(a5) # 80009010 <uart_tx_w>
      uartstart();
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	ee6080e7          	jalr	-282(ra) # 80000822 <uartstart>
      release(&uart_tx_lock);
    80000944:	8526                	mv	a0,s1
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	330080e7          	jalr	816(ra) # 80000c76 <release>
}
    8000094e:	70a2                	ld	ra,40(sp)
    80000950:	7402                	ld	s0,32(sp)
    80000952:	64e2                	ld	s1,24(sp)
    80000954:	6942                	ld	s2,16(sp)
    80000956:	69a2                	ld	s3,8(sp)
    80000958:	6a02                	ld	s4,0(sp)
    8000095a:	6145                	addi	sp,sp,48
    8000095c:	8082                	ret

000000008000095e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000095e:	1141                	addi	sp,sp,-16
    80000960:	e422                	sd	s0,8(sp)
    80000962:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000964:	100007b7          	lui	a5,0x10000
    80000968:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000096c:	8b85                	andi	a5,a5,1
    8000096e:	cb91                	beqz	a5,80000982 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000970:	100007b7          	lui	a5,0x10000
    80000974:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000978:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000097c:	6422                	ld	s0,8(sp)
    8000097e:	0141                	addi	sp,sp,16
    80000980:	8082                	ret
    return -1;
    80000982:	557d                	li	a0,-1
    80000984:	bfe5                	j	8000097c <uartgetc+0x1e>

0000000080000986 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000986:	1101                	addi	sp,sp,-32
    80000988:	ec06                	sd	ra,24(sp)
    8000098a:	e822                	sd	s0,16(sp)
    8000098c:	e426                	sd	s1,8(sp)
    8000098e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000990:	54fd                	li	s1,-1
    80000992:	a029                	j	8000099c <uartintr+0x16>
      break;
    consoleintr(c);
    80000994:	00000097          	auipc	ra,0x0
    80000998:	916080e7          	jalr	-1770(ra) # 800002aa <consoleintr>
    int c = uartgetc();
    8000099c:	00000097          	auipc	ra,0x0
    800009a0:	fc2080e7          	jalr	-62(ra) # 8000095e <uartgetc>
    if(c == -1)
    800009a4:	fe9518e3          	bne	a0,s1,80000994 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009a8:	00011497          	auipc	s1,0x11
    800009ac:	8a048493          	addi	s1,s1,-1888 # 80011248 <uart_tx_lock>
    800009b0:	8526                	mv	a0,s1
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	210080e7          	jalr	528(ra) # 80000bc2 <acquire>
  uartstart();
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	e68080e7          	jalr	-408(ra) # 80000822 <uartstart>
  release(&uart_tx_lock);
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	2b2080e7          	jalr	690(ra) # 80000c76 <release>
}
    800009cc:	60e2                	ld	ra,24(sp)
    800009ce:	6442                	ld	s0,16(sp)
    800009d0:	64a2                	ld	s1,8(sp)
    800009d2:	6105                	addi	sp,sp,32
    800009d4:	8082                	ret

00000000800009d6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	e04a                	sd	s2,0(sp)
    800009e0:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009e2:	03451793          	slli	a5,a0,0x34
    800009e6:	ebb9                	bnez	a5,80000a3c <kfree+0x66>
    800009e8:	84aa                	mv	s1,a0
    800009ea:	00025797          	auipc	a5,0x25
    800009ee:	61678793          	addi	a5,a5,1558 # 80026000 <end>
    800009f2:	04f56563          	bltu	a0,a5,80000a3c <kfree+0x66>
    800009f6:	47c5                	li	a5,17
    800009f8:	07ee                	slli	a5,a5,0x1b
    800009fa:	04f57163          	bgeu	a0,a5,80000a3c <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800009fe:	6605                	lui	a2,0x1
    80000a00:	4585                	li	a1,1
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	2bc080e7          	jalr	700(ra) # 80000cbe <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a0a:	00011917          	auipc	s2,0x11
    80000a0e:	87690913          	addi	s2,s2,-1930 # 80011280 <kmem>
    80000a12:	854a                	mv	a0,s2
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	1ae080e7          	jalr	430(ra) # 80000bc2 <acquire>
  r->next = kmem.freelist;
    80000a1c:	01893783          	ld	a5,24(s2)
    80000a20:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a22:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a26:	854a                	mv	a0,s2
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	24e080e7          	jalr	590(ra) # 80000c76 <release>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6902                	ld	s2,0(sp)
    80000a38:	6105                	addi	sp,sp,32
    80000a3a:	8082                	ret
    panic("kfree");
    80000a3c:	00007517          	auipc	a0,0x7
    80000a40:	62450513          	addi	a0,a0,1572 # 80008060 <digits+0x20>
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	ae6080e7          	jalr	-1306(ra) # 8000052a <panic>

0000000080000a4c <freerange>:
{
    80000a4c:	7179                	addi	sp,sp,-48
    80000a4e:	f406                	sd	ra,40(sp)
    80000a50:	f022                	sd	s0,32(sp)
    80000a52:	ec26                	sd	s1,24(sp)
    80000a54:	e84a                	sd	s2,16(sp)
    80000a56:	e44e                	sd	s3,8(sp)
    80000a58:	e052                	sd	s4,0(sp)
    80000a5a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a5c:	6785                	lui	a5,0x1
    80000a5e:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a62:	94aa                	add	s1,s1,a0
    80000a64:	757d                	lui	a0,0xfffff
    80000a66:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a68:	94be                	add	s1,s1,a5
    80000a6a:	0095ee63          	bltu	a1,s1,80000a86 <freerange+0x3a>
    80000a6e:	892e                	mv	s2,a1
    kfree(p);
    80000a70:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a72:	6985                	lui	s3,0x1
    kfree(p);
    80000a74:	01448533          	add	a0,s1,s4
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	f5e080e7          	jalr	-162(ra) # 800009d6 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	94ce                	add	s1,s1,s3
    80000a82:	fe9979e3          	bgeu	s2,s1,80000a74 <freerange+0x28>
}
    80000a86:	70a2                	ld	ra,40(sp)
    80000a88:	7402                	ld	s0,32(sp)
    80000a8a:	64e2                	ld	s1,24(sp)
    80000a8c:	6942                	ld	s2,16(sp)
    80000a8e:	69a2                	ld	s3,8(sp)
    80000a90:	6a02                	ld	s4,0(sp)
    80000a92:	6145                	addi	sp,sp,48
    80000a94:	8082                	ret

0000000080000a96 <kinit>:
{
    80000a96:	1141                	addi	sp,sp,-16
    80000a98:	e406                	sd	ra,8(sp)
    80000a9a:	e022                	sd	s0,0(sp)
    80000a9c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a9e:	00007597          	auipc	a1,0x7
    80000aa2:	5ca58593          	addi	a1,a1,1482 # 80008068 <digits+0x28>
    80000aa6:	00010517          	auipc	a0,0x10
    80000aaa:	7da50513          	addi	a0,a0,2010 # 80011280 <kmem>
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	084080e7          	jalr	132(ra) # 80000b32 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab6:	45c5                	li	a1,17
    80000ab8:	05ee                	slli	a1,a1,0x1b
    80000aba:	00025517          	auipc	a0,0x25
    80000abe:	54650513          	addi	a0,a0,1350 # 80026000 <end>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	f8a080e7          	jalr	-118(ra) # 80000a4c <freerange>
}
    80000aca:	60a2                	ld	ra,8(sp)
    80000acc:	6402                	ld	s0,0(sp)
    80000ace:	0141                	addi	sp,sp,16
    80000ad0:	8082                	ret

0000000080000ad2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ad2:	1101                	addi	sp,sp,-32
    80000ad4:	ec06                	sd	ra,24(sp)
    80000ad6:	e822                	sd	s0,16(sp)
    80000ad8:	e426                	sd	s1,8(sp)
    80000ada:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000adc:	00010497          	auipc	s1,0x10
    80000ae0:	7a448493          	addi	s1,s1,1956 # 80011280 <kmem>
    80000ae4:	8526                	mv	a0,s1
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	0dc080e7          	jalr	220(ra) # 80000bc2 <acquire>
  r = kmem.freelist;
    80000aee:	6c84                	ld	s1,24(s1)
  if(r)
    80000af0:	c885                	beqz	s1,80000b20 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000af2:	609c                	ld	a5,0(s1)
    80000af4:	00010517          	auipc	a0,0x10
    80000af8:	78c50513          	addi	a0,a0,1932 # 80011280 <kmem>
    80000afc:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	178080e7          	jalr	376(ra) # 80000c76 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b06:	6605                	lui	a2,0x1
    80000b08:	4595                	li	a1,5
    80000b0a:	8526                	mv	a0,s1
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	1b2080e7          	jalr	434(ra) # 80000cbe <memset>
  return (void*)r;
}
    80000b14:	8526                	mv	a0,s1
    80000b16:	60e2                	ld	ra,24(sp)
    80000b18:	6442                	ld	s0,16(sp)
    80000b1a:	64a2                	ld	s1,8(sp)
    80000b1c:	6105                	addi	sp,sp,32
    80000b1e:	8082                	ret
  release(&kmem.lock);
    80000b20:	00010517          	auipc	a0,0x10
    80000b24:	76050513          	addi	a0,a0,1888 # 80011280 <kmem>
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	14e080e7          	jalr	334(ra) # 80000c76 <release>
  if(r)
    80000b30:	b7d5                	j	80000b14 <kalloc+0x42>

0000000080000b32 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b32:	1141                	addi	sp,sp,-16
    80000b34:	e422                	sd	s0,8(sp)
    80000b36:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b38:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b3a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b3e:	00053823          	sd	zero,16(a0)
}
    80000b42:	6422                	ld	s0,8(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret

0000000080000b48 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b48:	411c                	lw	a5,0(a0)
    80000b4a:	e399                	bnez	a5,80000b50 <holding+0x8>
    80000b4c:	4501                	li	a0,0
  return r;
}
    80000b4e:	8082                	ret
{
    80000b50:	1101                	addi	sp,sp,-32
    80000b52:	ec06                	sd	ra,24(sp)
    80000b54:	e822                	sd	s0,16(sp)
    80000b56:	e426                	sd	s1,8(sp)
    80000b58:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b5a:	6904                	ld	s1,16(a0)
    80000b5c:	00001097          	auipc	ra,0x1
    80000b60:	e48080e7          	jalr	-440(ra) # 800019a4 <mycpu>
    80000b64:	40a48533          	sub	a0,s1,a0
    80000b68:	00153513          	seqz	a0,a0
}
    80000b6c:	60e2                	ld	ra,24(sp)
    80000b6e:	6442                	ld	s0,16(sp)
    80000b70:	64a2                	ld	s1,8(sp)
    80000b72:	6105                	addi	sp,sp,32
    80000b74:	8082                	ret

0000000080000b76 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b76:	1101                	addi	sp,sp,-32
    80000b78:	ec06                	sd	ra,24(sp)
    80000b7a:	e822                	sd	s0,16(sp)
    80000b7c:	e426                	sd	s1,8(sp)
    80000b7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b80:	100024f3          	csrr	s1,sstatus
    80000b84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b8a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b8e:	00001097          	auipc	ra,0x1
    80000b92:	e16080e7          	jalr	-490(ra) # 800019a4 <mycpu>
    80000b96:	5d3c                	lw	a5,120(a0)
    80000b98:	cf89                	beqz	a5,80000bb2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b9a:	00001097          	auipc	ra,0x1
    80000b9e:	e0a080e7          	jalr	-502(ra) # 800019a4 <mycpu>
    80000ba2:	5d3c                	lw	a5,120(a0)
    80000ba4:	2785                	addiw	a5,a5,1
    80000ba6:	dd3c                	sw	a5,120(a0)
}
    80000ba8:	60e2                	ld	ra,24(sp)
    80000baa:	6442                	ld	s0,16(sp)
    80000bac:	64a2                	ld	s1,8(sp)
    80000bae:	6105                	addi	sp,sp,32
    80000bb0:	8082                	ret
    mycpu()->intena = old;
    80000bb2:	00001097          	auipc	ra,0x1
    80000bb6:	df2080e7          	jalr	-526(ra) # 800019a4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bba:	8085                	srli	s1,s1,0x1
    80000bbc:	8885                	andi	s1,s1,1
    80000bbe:	dd64                	sw	s1,124(a0)
    80000bc0:	bfe9                	j	80000b9a <push_off+0x24>

0000000080000bc2 <acquire>:
{
    80000bc2:	1101                	addi	sp,sp,-32
    80000bc4:	ec06                	sd	ra,24(sp)
    80000bc6:	e822                	sd	s0,16(sp)
    80000bc8:	e426                	sd	s1,8(sp)
    80000bca:	1000                	addi	s0,sp,32
    80000bcc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bce:	00000097          	auipc	ra,0x0
    80000bd2:	fa8080e7          	jalr	-88(ra) # 80000b76 <push_off>
  if(holding(lk))
    80000bd6:	8526                	mv	a0,s1
    80000bd8:	00000097          	auipc	ra,0x0
    80000bdc:	f70080e7          	jalr	-144(ra) # 80000b48 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be0:	4705                	li	a4,1
  if(holding(lk))
    80000be2:	e115                	bnez	a0,80000c06 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be4:	87ba                	mv	a5,a4
    80000be6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bea:	2781                	sext.w	a5,a5
    80000bec:	ffe5                	bnez	a5,80000be4 <acquire+0x22>
  __sync_synchronize();
    80000bee:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bf2:	00001097          	auipc	ra,0x1
    80000bf6:	db2080e7          	jalr	-590(ra) # 800019a4 <mycpu>
    80000bfa:	e888                	sd	a0,16(s1)
}
    80000bfc:	60e2                	ld	ra,24(sp)
    80000bfe:	6442                	ld	s0,16(sp)
    80000c00:	64a2                	ld	s1,8(sp)
    80000c02:	6105                	addi	sp,sp,32
    80000c04:	8082                	ret
    panic("acquire");
    80000c06:	00007517          	auipc	a0,0x7
    80000c0a:	46a50513          	addi	a0,a0,1130 # 80008070 <digits+0x30>
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	91c080e7          	jalr	-1764(ra) # 8000052a <panic>

0000000080000c16 <pop_off>:

void
pop_off(void)
{
    80000c16:	1141                	addi	sp,sp,-16
    80000c18:	e406                	sd	ra,8(sp)
    80000c1a:	e022                	sd	s0,0(sp)
    80000c1c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c1e:	00001097          	auipc	ra,0x1
    80000c22:	d86080e7          	jalr	-634(ra) # 800019a4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c26:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c2a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c2c:	e78d                	bnez	a5,80000c56 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c2e:	5d3c                	lw	a5,120(a0)
    80000c30:	02f05b63          	blez	a5,80000c66 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c34:	37fd                	addiw	a5,a5,-1
    80000c36:	0007871b          	sext.w	a4,a5
    80000c3a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c3c:	eb09                	bnez	a4,80000c4e <pop_off+0x38>
    80000c3e:	5d7c                	lw	a5,124(a0)
    80000c40:	c799                	beqz	a5,80000c4e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c42:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c46:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c4a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c4e:	60a2                	ld	ra,8(sp)
    80000c50:	6402                	ld	s0,0(sp)
    80000c52:	0141                	addi	sp,sp,16
    80000c54:	8082                	ret
    panic("pop_off - interruptible");
    80000c56:	00007517          	auipc	a0,0x7
    80000c5a:	42250513          	addi	a0,a0,1058 # 80008078 <digits+0x38>
    80000c5e:	00000097          	auipc	ra,0x0
    80000c62:	8cc080e7          	jalr	-1844(ra) # 8000052a <panic>
    panic("pop_off");
    80000c66:	00007517          	auipc	a0,0x7
    80000c6a:	42a50513          	addi	a0,a0,1066 # 80008090 <digits+0x50>
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	8bc080e7          	jalr	-1860(ra) # 8000052a <panic>

0000000080000c76 <release>:
{
    80000c76:	1101                	addi	sp,sp,-32
    80000c78:	ec06                	sd	ra,24(sp)
    80000c7a:	e822                	sd	s0,16(sp)
    80000c7c:	e426                	sd	s1,8(sp)
    80000c7e:	1000                	addi	s0,sp,32
    80000c80:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	ec6080e7          	jalr	-314(ra) # 80000b48 <holding>
    80000c8a:	c115                	beqz	a0,80000cae <release+0x38>
  lk->cpu = 0;
    80000c8c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c90:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c94:	0f50000f          	fence	iorw,ow
    80000c98:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	f7a080e7          	jalr	-134(ra) # 80000c16 <pop_off>
}
    80000ca4:	60e2                	ld	ra,24(sp)
    80000ca6:	6442                	ld	s0,16(sp)
    80000ca8:	64a2                	ld	s1,8(sp)
    80000caa:	6105                	addi	sp,sp,32
    80000cac:	8082                	ret
    panic("release");
    80000cae:	00007517          	auipc	a0,0x7
    80000cb2:	3ea50513          	addi	a0,a0,1002 # 80008098 <digits+0x58>
    80000cb6:	00000097          	auipc	ra,0x0
    80000cba:	874080e7          	jalr	-1932(ra) # 8000052a <panic>

0000000080000cbe <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cbe:	1141                	addi	sp,sp,-16
    80000cc0:	e422                	sd	s0,8(sp)
    80000cc2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cc4:	ca19                	beqz	a2,80000cda <memset+0x1c>
    80000cc6:	87aa                	mv	a5,a0
    80000cc8:	1602                	slli	a2,a2,0x20
    80000cca:	9201                	srli	a2,a2,0x20
    80000ccc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cd0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cd4:	0785                	addi	a5,a5,1
    80000cd6:	fee79de3          	bne	a5,a4,80000cd0 <memset+0x12>
  }
  return dst;
}
    80000cda:	6422                	ld	s0,8(sp)
    80000cdc:	0141                	addi	sp,sp,16
    80000cde:	8082                	ret

0000000080000ce0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000ce0:	1141                	addi	sp,sp,-16
    80000ce2:	e422                	sd	s0,8(sp)
    80000ce4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000ce6:	ca05                	beqz	a2,80000d16 <memcmp+0x36>
    80000ce8:	fff6069b          	addiw	a3,a2,-1
    80000cec:	1682                	slli	a3,a3,0x20
    80000cee:	9281                	srli	a3,a3,0x20
    80000cf0:	0685                	addi	a3,a3,1
    80000cf2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cf4:	00054783          	lbu	a5,0(a0)
    80000cf8:	0005c703          	lbu	a4,0(a1)
    80000cfc:	00e79863          	bne	a5,a4,80000d0c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d00:	0505                	addi	a0,a0,1
    80000d02:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d04:	fed518e3          	bne	a0,a3,80000cf4 <memcmp+0x14>
  }

  return 0;
    80000d08:	4501                	li	a0,0
    80000d0a:	a019                	j	80000d10 <memcmp+0x30>
      return *s1 - *s2;
    80000d0c:	40e7853b          	subw	a0,a5,a4
}
    80000d10:	6422                	ld	s0,8(sp)
    80000d12:	0141                	addi	sp,sp,16
    80000d14:	8082                	ret
  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	bfe5                	j	80000d10 <memcmp+0x30>

0000000080000d1a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d1a:	1141                	addi	sp,sp,-16
    80000d1c:	e422                	sd	s0,8(sp)
    80000d1e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d20:	02a5e563          	bltu	a1,a0,80000d4a <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d24:	fff6069b          	addiw	a3,a2,-1
    80000d28:	ce11                	beqz	a2,80000d44 <memmove+0x2a>
    80000d2a:	1682                	slli	a3,a3,0x20
    80000d2c:	9281                	srli	a3,a3,0x20
    80000d2e:	0685                	addi	a3,a3,1
    80000d30:	96ae                	add	a3,a3,a1
    80000d32:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d34:	0585                	addi	a1,a1,1
    80000d36:	0785                	addi	a5,a5,1
    80000d38:	fff5c703          	lbu	a4,-1(a1)
    80000d3c:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d40:	fed59ae3          	bne	a1,a3,80000d34 <memmove+0x1a>

  return dst;
}
    80000d44:	6422                	ld	s0,8(sp)
    80000d46:	0141                	addi	sp,sp,16
    80000d48:	8082                	ret
  if(s < d && s + n > d){
    80000d4a:	02061713          	slli	a4,a2,0x20
    80000d4e:	9301                	srli	a4,a4,0x20
    80000d50:	00e587b3          	add	a5,a1,a4
    80000d54:	fcf578e3          	bgeu	a0,a5,80000d24 <memmove+0xa>
    d += n;
    80000d58:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d5a:	fff6069b          	addiw	a3,a2,-1
    80000d5e:	d27d                	beqz	a2,80000d44 <memmove+0x2a>
    80000d60:	02069613          	slli	a2,a3,0x20
    80000d64:	9201                	srli	a2,a2,0x20
    80000d66:	fff64613          	not	a2,a2
    80000d6a:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000d6c:	17fd                	addi	a5,a5,-1
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	0007c683          	lbu	a3,0(a5)
    80000d74:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000d78:	fef61ae3          	bne	a2,a5,80000d6c <memmove+0x52>
    80000d7c:	b7e1                	j	80000d44 <memmove+0x2a>

0000000080000d7e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d7e:	1141                	addi	sp,sp,-16
    80000d80:	e406                	sd	ra,8(sp)
    80000d82:	e022                	sd	s0,0(sp)
    80000d84:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	f94080e7          	jalr	-108(ra) # 80000d1a <memmove>
}
    80000d8e:	60a2                	ld	ra,8(sp)
    80000d90:	6402                	ld	s0,0(sp)
    80000d92:	0141                	addi	sp,sp,16
    80000d94:	8082                	ret

0000000080000d96 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d96:	1141                	addi	sp,sp,-16
    80000d98:	e422                	sd	s0,8(sp)
    80000d9a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9c:	ce11                	beqz	a2,80000db8 <strncmp+0x22>
    80000d9e:	00054783          	lbu	a5,0(a0)
    80000da2:	cf89                	beqz	a5,80000dbc <strncmp+0x26>
    80000da4:	0005c703          	lbu	a4,0(a1)
    80000da8:	00f71a63          	bne	a4,a5,80000dbc <strncmp+0x26>
    n--, p++, q++;
    80000dac:	367d                	addiw	a2,a2,-1
    80000dae:	0505                	addi	a0,a0,1
    80000db0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db2:	f675                	bnez	a2,80000d9e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db4:	4501                	li	a0,0
    80000db6:	a809                	j	80000dc8 <strncmp+0x32>
    80000db8:	4501                	li	a0,0
    80000dba:	a039                	j	80000dc8 <strncmp+0x32>
  if(n == 0)
    80000dbc:	ca09                	beqz	a2,80000dce <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dbe:	00054503          	lbu	a0,0(a0)
    80000dc2:	0005c783          	lbu	a5,0(a1)
    80000dc6:	9d1d                	subw	a0,a0,a5
}
    80000dc8:	6422                	ld	s0,8(sp)
    80000dca:	0141                	addi	sp,sp,16
    80000dcc:	8082                	ret
    return 0;
    80000dce:	4501                	li	a0,0
    80000dd0:	bfe5                	j	80000dc8 <strncmp+0x32>

0000000080000dd2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd2:	1141                	addi	sp,sp,-16
    80000dd4:	e422                	sd	s0,8(sp)
    80000dd6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd8:	872a                	mv	a4,a0
    80000dda:	8832                	mv	a6,a2
    80000ddc:	367d                	addiw	a2,a2,-1
    80000dde:	01005963          	blez	a6,80000df0 <strncpy+0x1e>
    80000de2:	0705                	addi	a4,a4,1
    80000de4:	0005c783          	lbu	a5,0(a1)
    80000de8:	fef70fa3          	sb	a5,-1(a4)
    80000dec:	0585                	addi	a1,a1,1
    80000dee:	f7f5                	bnez	a5,80000dda <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df0:	86ba                	mv	a3,a4
    80000df2:	00c05c63          	blez	a2,80000e0a <strncpy+0x38>
    *s++ = 0;
    80000df6:	0685                	addi	a3,a3,1
    80000df8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000dfc:	fff6c793          	not	a5,a3
    80000e00:	9fb9                	addw	a5,a5,a4
    80000e02:	010787bb          	addw	a5,a5,a6
    80000e06:	fef048e3          	bgtz	a5,80000df6 <strncpy+0x24>
  return os;
}
    80000e0a:	6422                	ld	s0,8(sp)
    80000e0c:	0141                	addi	sp,sp,16
    80000e0e:	8082                	ret

0000000080000e10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e10:	1141                	addi	sp,sp,-16
    80000e12:	e422                	sd	s0,8(sp)
    80000e14:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e16:	02c05363          	blez	a2,80000e3c <safestrcpy+0x2c>
    80000e1a:	fff6069b          	addiw	a3,a2,-1
    80000e1e:	1682                	slli	a3,a3,0x20
    80000e20:	9281                	srli	a3,a3,0x20
    80000e22:	96ae                	add	a3,a3,a1
    80000e24:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e26:	00d58963          	beq	a1,a3,80000e38 <safestrcpy+0x28>
    80000e2a:	0585                	addi	a1,a1,1
    80000e2c:	0785                	addi	a5,a5,1
    80000e2e:	fff5c703          	lbu	a4,-1(a1)
    80000e32:	fee78fa3          	sb	a4,-1(a5)
    80000e36:	fb65                	bnez	a4,80000e26 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e38:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e3c:	6422                	ld	s0,8(sp)
    80000e3e:	0141                	addi	sp,sp,16
    80000e40:	8082                	ret

0000000080000e42 <strlen>:

int
strlen(const char *s)
{
    80000e42:	1141                	addi	sp,sp,-16
    80000e44:	e422                	sd	s0,8(sp)
    80000e46:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e48:	00054783          	lbu	a5,0(a0)
    80000e4c:	cf91                	beqz	a5,80000e68 <strlen+0x26>
    80000e4e:	0505                	addi	a0,a0,1
    80000e50:	87aa                	mv	a5,a0
    80000e52:	4685                	li	a3,1
    80000e54:	9e89                	subw	a3,a3,a0
    80000e56:	00f6853b          	addw	a0,a3,a5
    80000e5a:	0785                	addi	a5,a5,1
    80000e5c:	fff7c703          	lbu	a4,-1(a5)
    80000e60:	fb7d                	bnez	a4,80000e56 <strlen+0x14>
    ;
  return n;
}
    80000e62:	6422                	ld	s0,8(sp)
    80000e64:	0141                	addi	sp,sp,16
    80000e66:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e68:	4501                	li	a0,0
    80000e6a:	bfe5                	j	80000e62 <strlen+0x20>

0000000080000e6c <strcat>:

char* 
strcat(char* destination, const char* source)
{
    80000e6c:	1101                	addi	sp,sp,-32
    80000e6e:	ec06                	sd	ra,24(sp)
    80000e70:	e822                	sd	s0,16(sp)
    80000e72:	e426                	sd	s1,8(sp)
    80000e74:	e04a                	sd	s2,0(sp)
    80000e76:	1000                	addi	s0,sp,32
    80000e78:	892a                	mv	s2,a0
    80000e7a:	84ae                	mv	s1,a1
  char* ptr = destination + strlen(destination);
    80000e7c:	00000097          	auipc	ra,0x0
    80000e80:	fc6080e7          	jalr	-58(ra) # 80000e42 <strlen>
    80000e84:	00a907b3          	add	a5,s2,a0

  while (*source != '\0')
    80000e88:	0004c703          	lbu	a4,0(s1)
    80000e8c:	cb01                	beqz	a4,80000e9c <strcat+0x30>
    *ptr++ = *source++;
    80000e8e:	0485                	addi	s1,s1,1
    80000e90:	0785                	addi	a5,a5,1
    80000e92:	fee78fa3          	sb	a4,-1(a5)
  while (*source != '\0')
    80000e96:	0004c703          	lbu	a4,0(s1)
    80000e9a:	fb75                	bnez	a4,80000e8e <strcat+0x22>

  *ptr = '\0';
    80000e9c:	00078023          	sb	zero,0(a5)

  return destination;
}
    80000ea0:	854a                	mv	a0,s2
    80000ea2:	60e2                	ld	ra,24(sp)
    80000ea4:	6442                	ld	s0,16(sp)
    80000ea6:	64a2                	ld	s1,8(sp)
    80000ea8:	6902                	ld	s2,0(sp)
    80000eaa:	6105                	addi	sp,sp,32
    80000eac:	8082                	ret

0000000080000eae <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eae:	1141                	addi	sp,sp,-16
    80000eb0:	e406                	sd	ra,8(sp)
    80000eb2:	e022                	sd	s0,0(sp)
    80000eb4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eb6:	00001097          	auipc	ra,0x1
    80000eba:	ade080e7          	jalr	-1314(ra) # 80001994 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ebe:	00008717          	auipc	a4,0x8
    80000ec2:	15a70713          	addi	a4,a4,346 # 80009018 <started>
  if(cpuid() == 0){
    80000ec6:	c139                	beqz	a0,80000f0c <main+0x5e>
    while(started == 0)
    80000ec8:	431c                	lw	a5,0(a4)
    80000eca:	2781                	sext.w	a5,a5
    80000ecc:	dff5                	beqz	a5,80000ec8 <main+0x1a>
      ;
    __sync_synchronize();
    80000ece:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ed2:	00001097          	auipc	ra,0x1
    80000ed6:	ac2080e7          	jalr	-1342(ra) # 80001994 <cpuid>
    80000eda:	85aa                	mv	a1,a0
    80000edc:	00007517          	auipc	a0,0x7
    80000ee0:	1dc50513          	addi	a0,a0,476 # 800080b8 <digits+0x78>
    80000ee4:	fffff097          	auipc	ra,0xfffff
    80000ee8:	690080e7          	jalr	1680(ra) # 80000574 <printf>
    kvminithart();    // turn on paging
    80000eec:	00000097          	auipc	ra,0x0
    80000ef0:	0d8080e7          	jalr	216(ra) # 80000fc4 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ef4:	00001097          	auipc	ra,0x1
    80000ef8:	71c080e7          	jalr	1820(ra) # 80002610 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000efc:	00005097          	auipc	ra,0x5
    80000f00:	134080e7          	jalr	308(ra) # 80006030 <plicinithart>
  }

  scheduler();        
    80000f04:	00001097          	auipc	ra,0x1
    80000f08:	fca080e7          	jalr	-54(ra) # 80001ece <scheduler>
    consoleinit();
    80000f0c:	fffff097          	auipc	ra,0xfffff
    80000f10:	530080e7          	jalr	1328(ra) # 8000043c <consoleinit>
    printfinit();
    80000f14:	00000097          	auipc	ra,0x0
    80000f18:	840080e7          	jalr	-1984(ra) # 80000754 <printfinit>
    printf("\n");
    80000f1c:	00007517          	auipc	a0,0x7
    80000f20:	1ac50513          	addi	a0,a0,428 # 800080c8 <digits+0x88>
    80000f24:	fffff097          	auipc	ra,0xfffff
    80000f28:	650080e7          	jalr	1616(ra) # 80000574 <printf>
    printf("xv6 kernel is booting\n");
    80000f2c:	00007517          	auipc	a0,0x7
    80000f30:	17450513          	addi	a0,a0,372 # 800080a0 <digits+0x60>
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	640080e7          	jalr	1600(ra) # 80000574 <printf>
    printf("\n");
    80000f3c:	00007517          	auipc	a0,0x7
    80000f40:	18c50513          	addi	a0,a0,396 # 800080c8 <digits+0x88>
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	630080e7          	jalr	1584(ra) # 80000574 <printf>
    kinit();         // physical page allocator
    80000f4c:	00000097          	auipc	ra,0x0
    80000f50:	b4a080e7          	jalr	-1206(ra) # 80000a96 <kinit>
    kvminit();       // create kernel page table
    80000f54:	00000097          	auipc	ra,0x0
    80000f58:	310080e7          	jalr	784(ra) # 80001264 <kvminit>
    kvminithart();   // turn on paging
    80000f5c:	00000097          	auipc	ra,0x0
    80000f60:	068080e7          	jalr	104(ra) # 80000fc4 <kvminithart>
    procinit();      // process table
    80000f64:	00001097          	auipc	ra,0x1
    80000f68:	980080e7          	jalr	-1664(ra) # 800018e4 <procinit>
    trapinit();      // trap vectors
    80000f6c:	00001097          	auipc	ra,0x1
    80000f70:	67c080e7          	jalr	1660(ra) # 800025e8 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f74:	00001097          	auipc	ra,0x1
    80000f78:	69c080e7          	jalr	1692(ra) # 80002610 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f7c:	00005097          	auipc	ra,0x5
    80000f80:	09e080e7          	jalr	158(ra) # 8000601a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f84:	00005097          	auipc	ra,0x5
    80000f88:	0ac080e7          	jalr	172(ra) # 80006030 <plicinithart>
    binit();         // buffer cache
    80000f8c:	00002097          	auipc	ra,0x2
    80000f90:	dc4080e7          	jalr	-572(ra) # 80002d50 <binit>
    iinit();         // inode cache
    80000f94:	00002097          	auipc	ra,0x2
    80000f98:	5e6080e7          	jalr	1510(ra) # 8000357a <iinit>
    fileinit();      // file table
    80000f9c:	00003097          	auipc	ra,0x3
    80000fa0:	762080e7          	jalr	1890(ra) # 800046fe <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fa4:	00005097          	auipc	ra,0x5
    80000fa8:	1ae080e7          	jalr	430(ra) # 80006152 <virtio_disk_init>
    userinit();      // first user process
    80000fac:	00001097          	auipc	ra,0x1
    80000fb0:	cec080e7          	jalr	-788(ra) # 80001c98 <userinit>
    __sync_synchronize();
    80000fb4:	0ff0000f          	fence
    started = 1;
    80000fb8:	4785                	li	a5,1
    80000fba:	00008717          	auipc	a4,0x8
    80000fbe:	04f72f23          	sw	a5,94(a4) # 80009018 <started>
    80000fc2:	b789                	j	80000f04 <main+0x56>

0000000080000fc4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fc4:	1141                	addi	sp,sp,-16
    80000fc6:	e422                	sd	s0,8(sp)
    80000fc8:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000fca:	00008797          	auipc	a5,0x8
    80000fce:	0567b783          	ld	a5,86(a5) # 80009020 <kernel_pagetable>
    80000fd2:	83b1                	srli	a5,a5,0xc
    80000fd4:	577d                	li	a4,-1
    80000fd6:	177e                	slli	a4,a4,0x3f
    80000fd8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fda:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fde:	12000073          	sfence.vma
  sfence_vma();
}
    80000fe2:	6422                	ld	s0,8(sp)
    80000fe4:	0141                	addi	sp,sp,16
    80000fe6:	8082                	ret

0000000080000fe8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fe8:	7139                	addi	sp,sp,-64
    80000fea:	fc06                	sd	ra,56(sp)
    80000fec:	f822                	sd	s0,48(sp)
    80000fee:	f426                	sd	s1,40(sp)
    80000ff0:	f04a                	sd	s2,32(sp)
    80000ff2:	ec4e                	sd	s3,24(sp)
    80000ff4:	e852                	sd	s4,16(sp)
    80000ff6:	e456                	sd	s5,8(sp)
    80000ff8:	e05a                	sd	s6,0(sp)
    80000ffa:	0080                	addi	s0,sp,64
    80000ffc:	84aa                	mv	s1,a0
    80000ffe:	89ae                	mv	s3,a1
    80001000:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001002:	57fd                	li	a5,-1
    80001004:	83e9                	srli	a5,a5,0x1a
    80001006:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001008:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000100a:	04b7f263          	bgeu	a5,a1,8000104e <walk+0x66>
    panic("walk");
    8000100e:	00007517          	auipc	a0,0x7
    80001012:	0c250513          	addi	a0,a0,194 # 800080d0 <digits+0x90>
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	514080e7          	jalr	1300(ra) # 8000052a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000101e:	060a8663          	beqz	s5,8000108a <walk+0xa2>
    80001022:	00000097          	auipc	ra,0x0
    80001026:	ab0080e7          	jalr	-1360(ra) # 80000ad2 <kalloc>
    8000102a:	84aa                	mv	s1,a0
    8000102c:	c529                	beqz	a0,80001076 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000102e:	6605                	lui	a2,0x1
    80001030:	4581                	li	a1,0
    80001032:	00000097          	auipc	ra,0x0
    80001036:	c8c080e7          	jalr	-884(ra) # 80000cbe <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000103a:	00c4d793          	srli	a5,s1,0xc
    8000103e:	07aa                	slli	a5,a5,0xa
    80001040:	0017e793          	ori	a5,a5,1
    80001044:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001048:	3a5d                	addiw	s4,s4,-9
    8000104a:	036a0063          	beq	s4,s6,8000106a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000104e:	0149d933          	srl	s2,s3,s4
    80001052:	1ff97913          	andi	s2,s2,511
    80001056:	090e                	slli	s2,s2,0x3
    80001058:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000105a:	00093483          	ld	s1,0(s2)
    8000105e:	0014f793          	andi	a5,s1,1
    80001062:	dfd5                	beqz	a5,8000101e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001064:	80a9                	srli	s1,s1,0xa
    80001066:	04b2                	slli	s1,s1,0xc
    80001068:	b7c5                	j	80001048 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000106a:	00c9d513          	srli	a0,s3,0xc
    8000106e:	1ff57513          	andi	a0,a0,511
    80001072:	050e                	slli	a0,a0,0x3
    80001074:	9526                	add	a0,a0,s1
}
    80001076:	70e2                	ld	ra,56(sp)
    80001078:	7442                	ld	s0,48(sp)
    8000107a:	74a2                	ld	s1,40(sp)
    8000107c:	7902                	ld	s2,32(sp)
    8000107e:	69e2                	ld	s3,24(sp)
    80001080:	6a42                	ld	s4,16(sp)
    80001082:	6aa2                	ld	s5,8(sp)
    80001084:	6b02                	ld	s6,0(sp)
    80001086:	6121                	addi	sp,sp,64
    80001088:	8082                	ret
        return 0;
    8000108a:	4501                	li	a0,0
    8000108c:	b7ed                	j	80001076 <walk+0x8e>

000000008000108e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000108e:	57fd                	li	a5,-1
    80001090:	83e9                	srli	a5,a5,0x1a
    80001092:	00b7f463          	bgeu	a5,a1,8000109a <walkaddr+0xc>
    return 0;
    80001096:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001098:	8082                	ret
{
    8000109a:	1141                	addi	sp,sp,-16
    8000109c:	e406                	sd	ra,8(sp)
    8000109e:	e022                	sd	s0,0(sp)
    800010a0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010a2:	4601                	li	a2,0
    800010a4:	00000097          	auipc	ra,0x0
    800010a8:	f44080e7          	jalr	-188(ra) # 80000fe8 <walk>
  if(pte == 0)
    800010ac:	c105                	beqz	a0,800010cc <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010ae:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010b0:	0117f693          	andi	a3,a5,17
    800010b4:	4745                	li	a4,17
    return 0;
    800010b6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010b8:	00e68663          	beq	a3,a4,800010c4 <walkaddr+0x36>
}
    800010bc:	60a2                	ld	ra,8(sp)
    800010be:	6402                	ld	s0,0(sp)
    800010c0:	0141                	addi	sp,sp,16
    800010c2:	8082                	ret
  pa = PTE2PA(*pte);
    800010c4:	00a7d513          	srli	a0,a5,0xa
    800010c8:	0532                	slli	a0,a0,0xc
  return pa;
    800010ca:	bfcd                	j	800010bc <walkaddr+0x2e>
    return 0;
    800010cc:	4501                	li	a0,0
    800010ce:	b7fd                	j	800010bc <walkaddr+0x2e>

00000000800010d0 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010d0:	715d                	addi	sp,sp,-80
    800010d2:	e486                	sd	ra,72(sp)
    800010d4:	e0a2                	sd	s0,64(sp)
    800010d6:	fc26                	sd	s1,56(sp)
    800010d8:	f84a                	sd	s2,48(sp)
    800010da:	f44e                	sd	s3,40(sp)
    800010dc:	f052                	sd	s4,32(sp)
    800010de:	ec56                	sd	s5,24(sp)
    800010e0:	e85a                	sd	s6,16(sp)
    800010e2:	e45e                	sd	s7,8(sp)
    800010e4:	0880                	addi	s0,sp,80
    800010e6:	8aaa                	mv	s5,a0
    800010e8:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010ea:	777d                	lui	a4,0xfffff
    800010ec:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010f0:	167d                	addi	a2,a2,-1
    800010f2:	00b609b3          	add	s3,a2,a1
    800010f6:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010fa:	893e                	mv	s2,a5
    800010fc:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001100:	6b85                	lui	s7,0x1
    80001102:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001106:	4605                	li	a2,1
    80001108:	85ca                	mv	a1,s2
    8000110a:	8556                	mv	a0,s5
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	edc080e7          	jalr	-292(ra) # 80000fe8 <walk>
    80001114:	c51d                	beqz	a0,80001142 <mappages+0x72>
    if(*pte & PTE_V)
    80001116:	611c                	ld	a5,0(a0)
    80001118:	8b85                	andi	a5,a5,1
    8000111a:	ef81                	bnez	a5,80001132 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000111c:	80b1                	srli	s1,s1,0xc
    8000111e:	04aa                	slli	s1,s1,0xa
    80001120:	0164e4b3          	or	s1,s1,s6
    80001124:	0014e493          	ori	s1,s1,1
    80001128:	e104                	sd	s1,0(a0)
    if(a == last)
    8000112a:	03390863          	beq	s2,s3,8000115a <mappages+0x8a>
    a += PGSIZE;
    8000112e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001130:	bfc9                	j	80001102 <mappages+0x32>
      panic("remap");
    80001132:	00007517          	auipc	a0,0x7
    80001136:	fa650513          	addi	a0,a0,-90 # 800080d8 <digits+0x98>
    8000113a:	fffff097          	auipc	ra,0xfffff
    8000113e:	3f0080e7          	jalr	1008(ra) # 8000052a <panic>
      return -1;
    80001142:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001144:	60a6                	ld	ra,72(sp)
    80001146:	6406                	ld	s0,64(sp)
    80001148:	74e2                	ld	s1,56(sp)
    8000114a:	7942                	ld	s2,48(sp)
    8000114c:	79a2                	ld	s3,40(sp)
    8000114e:	7a02                	ld	s4,32(sp)
    80001150:	6ae2                	ld	s5,24(sp)
    80001152:	6b42                	ld	s6,16(sp)
    80001154:	6ba2                	ld	s7,8(sp)
    80001156:	6161                	addi	sp,sp,80
    80001158:	8082                	ret
  return 0;
    8000115a:	4501                	li	a0,0
    8000115c:	b7e5                	j	80001144 <mappages+0x74>

000000008000115e <kvmmap>:
{
    8000115e:	1141                	addi	sp,sp,-16
    80001160:	e406                	sd	ra,8(sp)
    80001162:	e022                	sd	s0,0(sp)
    80001164:	0800                	addi	s0,sp,16
    80001166:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001168:	86b2                	mv	a3,a2
    8000116a:	863e                	mv	a2,a5
    8000116c:	00000097          	auipc	ra,0x0
    80001170:	f64080e7          	jalr	-156(ra) # 800010d0 <mappages>
    80001174:	e509                	bnez	a0,8000117e <kvmmap+0x20>
}
    80001176:	60a2                	ld	ra,8(sp)
    80001178:	6402                	ld	s0,0(sp)
    8000117a:	0141                	addi	sp,sp,16
    8000117c:	8082                	ret
    panic("kvmmap");
    8000117e:	00007517          	auipc	a0,0x7
    80001182:	f6250513          	addi	a0,a0,-158 # 800080e0 <digits+0xa0>
    80001186:	fffff097          	auipc	ra,0xfffff
    8000118a:	3a4080e7          	jalr	932(ra) # 8000052a <panic>

000000008000118e <kvmmake>:
{
    8000118e:	1101                	addi	sp,sp,-32
    80001190:	ec06                	sd	ra,24(sp)
    80001192:	e822                	sd	s0,16(sp)
    80001194:	e426                	sd	s1,8(sp)
    80001196:	e04a                	sd	s2,0(sp)
    80001198:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000119a:	00000097          	auipc	ra,0x0
    8000119e:	938080e7          	jalr	-1736(ra) # 80000ad2 <kalloc>
    800011a2:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011a4:	6605                	lui	a2,0x1
    800011a6:	4581                	li	a1,0
    800011a8:	00000097          	auipc	ra,0x0
    800011ac:	b16080e7          	jalr	-1258(ra) # 80000cbe <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011b0:	4719                	li	a4,6
    800011b2:	6685                	lui	a3,0x1
    800011b4:	10000637          	lui	a2,0x10000
    800011b8:	100005b7          	lui	a1,0x10000
    800011bc:	8526                	mv	a0,s1
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	fa0080e7          	jalr	-96(ra) # 8000115e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011c6:	4719                	li	a4,6
    800011c8:	6685                	lui	a3,0x1
    800011ca:	10001637          	lui	a2,0x10001
    800011ce:	100015b7          	lui	a1,0x10001
    800011d2:	8526                	mv	a0,s1
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	f8a080e7          	jalr	-118(ra) # 8000115e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011dc:	4719                	li	a4,6
    800011de:	004006b7          	lui	a3,0x400
    800011e2:	0c000637          	lui	a2,0xc000
    800011e6:	0c0005b7          	lui	a1,0xc000
    800011ea:	8526                	mv	a0,s1
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	f72080e7          	jalr	-142(ra) # 8000115e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011f4:	00007917          	auipc	s2,0x7
    800011f8:	e0c90913          	addi	s2,s2,-500 # 80008000 <etext>
    800011fc:	4729                	li	a4,10
    800011fe:	80007697          	auipc	a3,0x80007
    80001202:	e0268693          	addi	a3,a3,-510 # 8000 <_entry-0x7fff8000>
    80001206:	4605                	li	a2,1
    80001208:	067e                	slli	a2,a2,0x1f
    8000120a:	85b2                	mv	a1,a2
    8000120c:	8526                	mv	a0,s1
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	f50080e7          	jalr	-176(ra) # 8000115e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001216:	4719                	li	a4,6
    80001218:	46c5                	li	a3,17
    8000121a:	06ee                	slli	a3,a3,0x1b
    8000121c:	412686b3          	sub	a3,a3,s2
    80001220:	864a                	mv	a2,s2
    80001222:	85ca                	mv	a1,s2
    80001224:	8526                	mv	a0,s1
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	f38080e7          	jalr	-200(ra) # 8000115e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000122e:	4729                	li	a4,10
    80001230:	6685                	lui	a3,0x1
    80001232:	00006617          	auipc	a2,0x6
    80001236:	dce60613          	addi	a2,a2,-562 # 80007000 <_trampoline>
    8000123a:	040005b7          	lui	a1,0x4000
    8000123e:	15fd                	addi	a1,a1,-1
    80001240:	05b2                	slli	a1,a1,0xc
    80001242:	8526                	mv	a0,s1
    80001244:	00000097          	auipc	ra,0x0
    80001248:	f1a080e7          	jalr	-230(ra) # 8000115e <kvmmap>
  proc_mapstacks(kpgtbl);
    8000124c:	8526                	mv	a0,s1
    8000124e:	00000097          	auipc	ra,0x0
    80001252:	600080e7          	jalr	1536(ra) # 8000184e <proc_mapstacks>
}
    80001256:	8526                	mv	a0,s1
    80001258:	60e2                	ld	ra,24(sp)
    8000125a:	6442                	ld	s0,16(sp)
    8000125c:	64a2                	ld	s1,8(sp)
    8000125e:	6902                	ld	s2,0(sp)
    80001260:	6105                	addi	sp,sp,32
    80001262:	8082                	ret

0000000080001264 <kvminit>:
{
    80001264:	1141                	addi	sp,sp,-16
    80001266:	e406                	sd	ra,8(sp)
    80001268:	e022                	sd	s0,0(sp)
    8000126a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	f22080e7          	jalr	-222(ra) # 8000118e <kvmmake>
    80001274:	00008797          	auipc	a5,0x8
    80001278:	daa7b623          	sd	a0,-596(a5) # 80009020 <kernel_pagetable>
}
    8000127c:	60a2                	ld	ra,8(sp)
    8000127e:	6402                	ld	s0,0(sp)
    80001280:	0141                	addi	sp,sp,16
    80001282:	8082                	ret

0000000080001284 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001284:	715d                	addi	sp,sp,-80
    80001286:	e486                	sd	ra,72(sp)
    80001288:	e0a2                	sd	s0,64(sp)
    8000128a:	fc26                	sd	s1,56(sp)
    8000128c:	f84a                	sd	s2,48(sp)
    8000128e:	f44e                	sd	s3,40(sp)
    80001290:	f052                	sd	s4,32(sp)
    80001292:	ec56                	sd	s5,24(sp)
    80001294:	e85a                	sd	s6,16(sp)
    80001296:	e45e                	sd	s7,8(sp)
    80001298:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000129a:	03459793          	slli	a5,a1,0x34
    8000129e:	e795                	bnez	a5,800012ca <uvmunmap+0x46>
    800012a0:	8a2a                	mv	s4,a0
    800012a2:	892e                	mv	s2,a1
    800012a4:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012a6:	0632                	slli	a2,a2,0xc
    800012a8:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012ac:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012ae:	6b05                	lui	s6,0x1
    800012b0:	0735e263          	bltu	a1,s3,80001314 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012b4:	60a6                	ld	ra,72(sp)
    800012b6:	6406                	ld	s0,64(sp)
    800012b8:	74e2                	ld	s1,56(sp)
    800012ba:	7942                	ld	s2,48(sp)
    800012bc:	79a2                	ld	s3,40(sp)
    800012be:	7a02                	ld	s4,32(sp)
    800012c0:	6ae2                	ld	s5,24(sp)
    800012c2:	6b42                	ld	s6,16(sp)
    800012c4:	6ba2                	ld	s7,8(sp)
    800012c6:	6161                	addi	sp,sp,80
    800012c8:	8082                	ret
    panic("uvmunmap: not aligned");
    800012ca:	00007517          	auipc	a0,0x7
    800012ce:	e1e50513          	addi	a0,a0,-482 # 800080e8 <digits+0xa8>
    800012d2:	fffff097          	auipc	ra,0xfffff
    800012d6:	258080e7          	jalr	600(ra) # 8000052a <panic>
      panic("uvmunmap: walk");
    800012da:	00007517          	auipc	a0,0x7
    800012de:	e2650513          	addi	a0,a0,-474 # 80008100 <digits+0xc0>
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	248080e7          	jalr	584(ra) # 8000052a <panic>
      panic("uvmunmap: not mapped");
    800012ea:	00007517          	auipc	a0,0x7
    800012ee:	e2650513          	addi	a0,a0,-474 # 80008110 <digits+0xd0>
    800012f2:	fffff097          	auipc	ra,0xfffff
    800012f6:	238080e7          	jalr	568(ra) # 8000052a <panic>
      panic("uvmunmap: not a leaf");
    800012fa:	00007517          	auipc	a0,0x7
    800012fe:	e2e50513          	addi	a0,a0,-466 # 80008128 <digits+0xe8>
    80001302:	fffff097          	auipc	ra,0xfffff
    80001306:	228080e7          	jalr	552(ra) # 8000052a <panic>
    *pte = 0;
    8000130a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000130e:	995a                	add	s2,s2,s6
    80001310:	fb3972e3          	bgeu	s2,s3,800012b4 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001314:	4601                	li	a2,0
    80001316:	85ca                	mv	a1,s2
    80001318:	8552                	mv	a0,s4
    8000131a:	00000097          	auipc	ra,0x0
    8000131e:	cce080e7          	jalr	-818(ra) # 80000fe8 <walk>
    80001322:	84aa                	mv	s1,a0
    80001324:	d95d                	beqz	a0,800012da <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001326:	6108                	ld	a0,0(a0)
    80001328:	00157793          	andi	a5,a0,1
    8000132c:	dfdd                	beqz	a5,800012ea <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000132e:	3ff57793          	andi	a5,a0,1023
    80001332:	fd7784e3          	beq	a5,s7,800012fa <uvmunmap+0x76>
    if(do_free){
    80001336:	fc0a8ae3          	beqz	s5,8000130a <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000133a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000133c:	0532                	slli	a0,a0,0xc
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	698080e7          	jalr	1688(ra) # 800009d6 <kfree>
    80001346:	b7d1                	j	8000130a <uvmunmap+0x86>

0000000080001348 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001348:	1101                	addi	sp,sp,-32
    8000134a:	ec06                	sd	ra,24(sp)
    8000134c:	e822                	sd	s0,16(sp)
    8000134e:	e426                	sd	s1,8(sp)
    80001350:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001352:	fffff097          	auipc	ra,0xfffff
    80001356:	780080e7          	jalr	1920(ra) # 80000ad2 <kalloc>
    8000135a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000135c:	c519                	beqz	a0,8000136a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000135e:	6605                	lui	a2,0x1
    80001360:	4581                	li	a1,0
    80001362:	00000097          	auipc	ra,0x0
    80001366:	95c080e7          	jalr	-1700(ra) # 80000cbe <memset>
  return pagetable;
}
    8000136a:	8526                	mv	a0,s1
    8000136c:	60e2                	ld	ra,24(sp)
    8000136e:	6442                	ld	s0,16(sp)
    80001370:	64a2                	ld	s1,8(sp)
    80001372:	6105                	addi	sp,sp,32
    80001374:	8082                	ret

0000000080001376 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001376:	7179                	addi	sp,sp,-48
    80001378:	f406                	sd	ra,40(sp)
    8000137a:	f022                	sd	s0,32(sp)
    8000137c:	ec26                	sd	s1,24(sp)
    8000137e:	e84a                	sd	s2,16(sp)
    80001380:	e44e                	sd	s3,8(sp)
    80001382:	e052                	sd	s4,0(sp)
    80001384:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001386:	6785                	lui	a5,0x1
    80001388:	04f67863          	bgeu	a2,a5,800013d8 <uvminit+0x62>
    8000138c:	8a2a                	mv	s4,a0
    8000138e:	89ae                	mv	s3,a1
    80001390:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001392:	fffff097          	auipc	ra,0xfffff
    80001396:	740080e7          	jalr	1856(ra) # 80000ad2 <kalloc>
    8000139a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000139c:	6605                	lui	a2,0x1
    8000139e:	4581                	li	a1,0
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	91e080e7          	jalr	-1762(ra) # 80000cbe <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013a8:	4779                	li	a4,30
    800013aa:	86ca                	mv	a3,s2
    800013ac:	6605                	lui	a2,0x1
    800013ae:	4581                	li	a1,0
    800013b0:	8552                	mv	a0,s4
    800013b2:	00000097          	auipc	ra,0x0
    800013b6:	d1e080e7          	jalr	-738(ra) # 800010d0 <mappages>
  memmove(mem, src, sz);
    800013ba:	8626                	mv	a2,s1
    800013bc:	85ce                	mv	a1,s3
    800013be:	854a                	mv	a0,s2
    800013c0:	00000097          	auipc	ra,0x0
    800013c4:	95a080e7          	jalr	-1702(ra) # 80000d1a <memmove>
}
    800013c8:	70a2                	ld	ra,40(sp)
    800013ca:	7402                	ld	s0,32(sp)
    800013cc:	64e2                	ld	s1,24(sp)
    800013ce:	6942                	ld	s2,16(sp)
    800013d0:	69a2                	ld	s3,8(sp)
    800013d2:	6a02                	ld	s4,0(sp)
    800013d4:	6145                	addi	sp,sp,48
    800013d6:	8082                	ret
    panic("inituvm: more than a page");
    800013d8:	00007517          	auipc	a0,0x7
    800013dc:	d6850513          	addi	a0,a0,-664 # 80008140 <digits+0x100>
    800013e0:	fffff097          	auipc	ra,0xfffff
    800013e4:	14a080e7          	jalr	330(ra) # 8000052a <panic>

00000000800013e8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013e8:	1101                	addi	sp,sp,-32
    800013ea:	ec06                	sd	ra,24(sp)
    800013ec:	e822                	sd	s0,16(sp)
    800013ee:	e426                	sd	s1,8(sp)
    800013f0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013f2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013f4:	00b67d63          	bgeu	a2,a1,8000140e <uvmdealloc+0x26>
    800013f8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013fa:	6785                	lui	a5,0x1
    800013fc:	17fd                	addi	a5,a5,-1
    800013fe:	00f60733          	add	a4,a2,a5
    80001402:	767d                	lui	a2,0xfffff
    80001404:	8f71                	and	a4,a4,a2
    80001406:	97ae                	add	a5,a5,a1
    80001408:	8ff1                	and	a5,a5,a2
    8000140a:	00f76863          	bltu	a4,a5,8000141a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000140e:	8526                	mv	a0,s1
    80001410:	60e2                	ld	ra,24(sp)
    80001412:	6442                	ld	s0,16(sp)
    80001414:	64a2                	ld	s1,8(sp)
    80001416:	6105                	addi	sp,sp,32
    80001418:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000141a:	8f99                	sub	a5,a5,a4
    8000141c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000141e:	4685                	li	a3,1
    80001420:	0007861b          	sext.w	a2,a5
    80001424:	85ba                	mv	a1,a4
    80001426:	00000097          	auipc	ra,0x0
    8000142a:	e5e080e7          	jalr	-418(ra) # 80001284 <uvmunmap>
    8000142e:	b7c5                	j	8000140e <uvmdealloc+0x26>

0000000080001430 <uvmalloc>:
  if(newsz < oldsz)
    80001430:	0ab66163          	bltu	a2,a1,800014d2 <uvmalloc+0xa2>
{
    80001434:	7139                	addi	sp,sp,-64
    80001436:	fc06                	sd	ra,56(sp)
    80001438:	f822                	sd	s0,48(sp)
    8000143a:	f426                	sd	s1,40(sp)
    8000143c:	f04a                	sd	s2,32(sp)
    8000143e:	ec4e                	sd	s3,24(sp)
    80001440:	e852                	sd	s4,16(sp)
    80001442:	e456                	sd	s5,8(sp)
    80001444:	0080                	addi	s0,sp,64
    80001446:	8aaa                	mv	s5,a0
    80001448:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000144a:	6985                	lui	s3,0x1
    8000144c:	19fd                	addi	s3,s3,-1
    8000144e:	95ce                	add	a1,a1,s3
    80001450:	79fd                	lui	s3,0xfffff
    80001452:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001456:	08c9f063          	bgeu	s3,a2,800014d6 <uvmalloc+0xa6>
    8000145a:	894e                	mv	s2,s3
    mem = kalloc();
    8000145c:	fffff097          	auipc	ra,0xfffff
    80001460:	676080e7          	jalr	1654(ra) # 80000ad2 <kalloc>
    80001464:	84aa                	mv	s1,a0
    if(mem == 0){
    80001466:	c51d                	beqz	a0,80001494 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001468:	6605                	lui	a2,0x1
    8000146a:	4581                	li	a1,0
    8000146c:	00000097          	auipc	ra,0x0
    80001470:	852080e7          	jalr	-1966(ra) # 80000cbe <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001474:	4779                	li	a4,30
    80001476:	86a6                	mv	a3,s1
    80001478:	6605                	lui	a2,0x1
    8000147a:	85ca                	mv	a1,s2
    8000147c:	8556                	mv	a0,s5
    8000147e:	00000097          	auipc	ra,0x0
    80001482:	c52080e7          	jalr	-942(ra) # 800010d0 <mappages>
    80001486:	e905                	bnez	a0,800014b6 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001488:	6785                	lui	a5,0x1
    8000148a:	993e                	add	s2,s2,a5
    8000148c:	fd4968e3          	bltu	s2,s4,8000145c <uvmalloc+0x2c>
  return newsz;
    80001490:	8552                	mv	a0,s4
    80001492:	a809                	j	800014a4 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001494:	864e                	mv	a2,s3
    80001496:	85ca                	mv	a1,s2
    80001498:	8556                	mv	a0,s5
    8000149a:	00000097          	auipc	ra,0x0
    8000149e:	f4e080e7          	jalr	-178(ra) # 800013e8 <uvmdealloc>
      return 0;
    800014a2:	4501                	li	a0,0
}
    800014a4:	70e2                	ld	ra,56(sp)
    800014a6:	7442                	ld	s0,48(sp)
    800014a8:	74a2                	ld	s1,40(sp)
    800014aa:	7902                	ld	s2,32(sp)
    800014ac:	69e2                	ld	s3,24(sp)
    800014ae:	6a42                	ld	s4,16(sp)
    800014b0:	6aa2                	ld	s5,8(sp)
    800014b2:	6121                	addi	sp,sp,64
    800014b4:	8082                	ret
      kfree(mem);
    800014b6:	8526                	mv	a0,s1
    800014b8:	fffff097          	auipc	ra,0xfffff
    800014bc:	51e080e7          	jalr	1310(ra) # 800009d6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014c0:	864e                	mv	a2,s3
    800014c2:	85ca                	mv	a1,s2
    800014c4:	8556                	mv	a0,s5
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	f22080e7          	jalr	-222(ra) # 800013e8 <uvmdealloc>
      return 0;
    800014ce:	4501                	li	a0,0
    800014d0:	bfd1                	j	800014a4 <uvmalloc+0x74>
    return oldsz;
    800014d2:	852e                	mv	a0,a1
}
    800014d4:	8082                	ret
  return newsz;
    800014d6:	8532                	mv	a0,a2
    800014d8:	b7f1                	j	800014a4 <uvmalloc+0x74>

00000000800014da <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014da:	7179                	addi	sp,sp,-48
    800014dc:	f406                	sd	ra,40(sp)
    800014de:	f022                	sd	s0,32(sp)
    800014e0:	ec26                	sd	s1,24(sp)
    800014e2:	e84a                	sd	s2,16(sp)
    800014e4:	e44e                	sd	s3,8(sp)
    800014e6:	e052                	sd	s4,0(sp)
    800014e8:	1800                	addi	s0,sp,48
    800014ea:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014ec:	84aa                	mv	s1,a0
    800014ee:	6905                	lui	s2,0x1
    800014f0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014f2:	4985                	li	s3,1
    800014f4:	a821                	j	8000150c <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014f6:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014f8:	0532                	slli	a0,a0,0xc
    800014fa:	00000097          	auipc	ra,0x0
    800014fe:	fe0080e7          	jalr	-32(ra) # 800014da <freewalk>
      pagetable[i] = 0;
    80001502:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001506:	04a1                	addi	s1,s1,8
    80001508:	03248163          	beq	s1,s2,8000152a <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000150c:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000150e:	00f57793          	andi	a5,a0,15
    80001512:	ff3782e3          	beq	a5,s3,800014f6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001516:	8905                	andi	a0,a0,1
    80001518:	d57d                	beqz	a0,80001506 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000151a:	00007517          	auipc	a0,0x7
    8000151e:	c4650513          	addi	a0,a0,-954 # 80008160 <digits+0x120>
    80001522:	fffff097          	auipc	ra,0xfffff
    80001526:	008080e7          	jalr	8(ra) # 8000052a <panic>
    }
  }
  kfree((void*)pagetable);
    8000152a:	8552                	mv	a0,s4
    8000152c:	fffff097          	auipc	ra,0xfffff
    80001530:	4aa080e7          	jalr	1194(ra) # 800009d6 <kfree>
}
    80001534:	70a2                	ld	ra,40(sp)
    80001536:	7402                	ld	s0,32(sp)
    80001538:	64e2                	ld	s1,24(sp)
    8000153a:	6942                	ld	s2,16(sp)
    8000153c:	69a2                	ld	s3,8(sp)
    8000153e:	6a02                	ld	s4,0(sp)
    80001540:	6145                	addi	sp,sp,48
    80001542:	8082                	ret

0000000080001544 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001544:	1101                	addi	sp,sp,-32
    80001546:	ec06                	sd	ra,24(sp)
    80001548:	e822                	sd	s0,16(sp)
    8000154a:	e426                	sd	s1,8(sp)
    8000154c:	1000                	addi	s0,sp,32
    8000154e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001550:	e999                	bnez	a1,80001566 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001552:	8526                	mv	a0,s1
    80001554:	00000097          	auipc	ra,0x0
    80001558:	f86080e7          	jalr	-122(ra) # 800014da <freewalk>
}
    8000155c:	60e2                	ld	ra,24(sp)
    8000155e:	6442                	ld	s0,16(sp)
    80001560:	64a2                	ld	s1,8(sp)
    80001562:	6105                	addi	sp,sp,32
    80001564:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001566:	6605                	lui	a2,0x1
    80001568:	167d                	addi	a2,a2,-1
    8000156a:	962e                	add	a2,a2,a1
    8000156c:	4685                	li	a3,1
    8000156e:	8231                	srli	a2,a2,0xc
    80001570:	4581                	li	a1,0
    80001572:	00000097          	auipc	ra,0x0
    80001576:	d12080e7          	jalr	-750(ra) # 80001284 <uvmunmap>
    8000157a:	bfe1                	j	80001552 <uvmfree+0xe>

000000008000157c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000157c:	c679                	beqz	a2,8000164a <uvmcopy+0xce>
{
    8000157e:	715d                	addi	sp,sp,-80
    80001580:	e486                	sd	ra,72(sp)
    80001582:	e0a2                	sd	s0,64(sp)
    80001584:	fc26                	sd	s1,56(sp)
    80001586:	f84a                	sd	s2,48(sp)
    80001588:	f44e                	sd	s3,40(sp)
    8000158a:	f052                	sd	s4,32(sp)
    8000158c:	ec56                	sd	s5,24(sp)
    8000158e:	e85a                	sd	s6,16(sp)
    80001590:	e45e                	sd	s7,8(sp)
    80001592:	0880                	addi	s0,sp,80
    80001594:	8b2a                	mv	s6,a0
    80001596:	8aae                	mv	s5,a1
    80001598:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000159a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000159c:	4601                	li	a2,0
    8000159e:	85ce                	mv	a1,s3
    800015a0:	855a                	mv	a0,s6
    800015a2:	00000097          	auipc	ra,0x0
    800015a6:	a46080e7          	jalr	-1466(ra) # 80000fe8 <walk>
    800015aa:	c531                	beqz	a0,800015f6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800015ac:	6118                	ld	a4,0(a0)
    800015ae:	00177793          	andi	a5,a4,1
    800015b2:	cbb1                	beqz	a5,80001606 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015b4:	00a75593          	srli	a1,a4,0xa
    800015b8:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015bc:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015c0:	fffff097          	auipc	ra,0xfffff
    800015c4:	512080e7          	jalr	1298(ra) # 80000ad2 <kalloc>
    800015c8:	892a                	mv	s2,a0
    800015ca:	c939                	beqz	a0,80001620 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015cc:	6605                	lui	a2,0x1
    800015ce:	85de                	mv	a1,s7
    800015d0:	fffff097          	auipc	ra,0xfffff
    800015d4:	74a080e7          	jalr	1866(ra) # 80000d1a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015d8:	8726                	mv	a4,s1
    800015da:	86ca                	mv	a3,s2
    800015dc:	6605                	lui	a2,0x1
    800015de:	85ce                	mv	a1,s3
    800015e0:	8556                	mv	a0,s5
    800015e2:	00000097          	auipc	ra,0x0
    800015e6:	aee080e7          	jalr	-1298(ra) # 800010d0 <mappages>
    800015ea:	e515                	bnez	a0,80001616 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015ec:	6785                	lui	a5,0x1
    800015ee:	99be                	add	s3,s3,a5
    800015f0:	fb49e6e3          	bltu	s3,s4,8000159c <uvmcopy+0x20>
    800015f4:	a081                	j	80001634 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015f6:	00007517          	auipc	a0,0x7
    800015fa:	b7a50513          	addi	a0,a0,-1158 # 80008170 <digits+0x130>
    800015fe:	fffff097          	auipc	ra,0xfffff
    80001602:	f2c080e7          	jalr	-212(ra) # 8000052a <panic>
      panic("uvmcopy: page not present");
    80001606:	00007517          	auipc	a0,0x7
    8000160a:	b8a50513          	addi	a0,a0,-1142 # 80008190 <digits+0x150>
    8000160e:	fffff097          	auipc	ra,0xfffff
    80001612:	f1c080e7          	jalr	-228(ra) # 8000052a <panic>
      kfree(mem);
    80001616:	854a                	mv	a0,s2
    80001618:	fffff097          	auipc	ra,0xfffff
    8000161c:	3be080e7          	jalr	958(ra) # 800009d6 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001620:	4685                	li	a3,1
    80001622:	00c9d613          	srli	a2,s3,0xc
    80001626:	4581                	li	a1,0
    80001628:	8556                	mv	a0,s5
    8000162a:	00000097          	auipc	ra,0x0
    8000162e:	c5a080e7          	jalr	-934(ra) # 80001284 <uvmunmap>
  return -1;
    80001632:	557d                	li	a0,-1
}
    80001634:	60a6                	ld	ra,72(sp)
    80001636:	6406                	ld	s0,64(sp)
    80001638:	74e2                	ld	s1,56(sp)
    8000163a:	7942                	ld	s2,48(sp)
    8000163c:	79a2                	ld	s3,40(sp)
    8000163e:	7a02                	ld	s4,32(sp)
    80001640:	6ae2                	ld	s5,24(sp)
    80001642:	6b42                	ld	s6,16(sp)
    80001644:	6ba2                	ld	s7,8(sp)
    80001646:	6161                	addi	sp,sp,80
    80001648:	8082                	ret
  return 0;
    8000164a:	4501                	li	a0,0
}
    8000164c:	8082                	ret

000000008000164e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000164e:	1141                	addi	sp,sp,-16
    80001650:	e406                	sd	ra,8(sp)
    80001652:	e022                	sd	s0,0(sp)
    80001654:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001656:	4601                	li	a2,0
    80001658:	00000097          	auipc	ra,0x0
    8000165c:	990080e7          	jalr	-1648(ra) # 80000fe8 <walk>
  if(pte == 0)
    80001660:	c901                	beqz	a0,80001670 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001662:	611c                	ld	a5,0(a0)
    80001664:	9bbd                	andi	a5,a5,-17
    80001666:	e11c                	sd	a5,0(a0)
}
    80001668:	60a2                	ld	ra,8(sp)
    8000166a:	6402                	ld	s0,0(sp)
    8000166c:	0141                	addi	sp,sp,16
    8000166e:	8082                	ret
    panic("uvmclear");
    80001670:	00007517          	auipc	a0,0x7
    80001674:	b4050513          	addi	a0,a0,-1216 # 800081b0 <digits+0x170>
    80001678:	fffff097          	auipc	ra,0xfffff
    8000167c:	eb2080e7          	jalr	-334(ra) # 8000052a <panic>

0000000080001680 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001680:	c6bd                	beqz	a3,800016ee <copyout+0x6e>
{
    80001682:	715d                	addi	sp,sp,-80
    80001684:	e486                	sd	ra,72(sp)
    80001686:	e0a2                	sd	s0,64(sp)
    80001688:	fc26                	sd	s1,56(sp)
    8000168a:	f84a                	sd	s2,48(sp)
    8000168c:	f44e                	sd	s3,40(sp)
    8000168e:	f052                	sd	s4,32(sp)
    80001690:	ec56                	sd	s5,24(sp)
    80001692:	e85a                	sd	s6,16(sp)
    80001694:	e45e                	sd	s7,8(sp)
    80001696:	e062                	sd	s8,0(sp)
    80001698:	0880                	addi	s0,sp,80
    8000169a:	8b2a                	mv	s6,a0
    8000169c:	8c2e                	mv	s8,a1
    8000169e:	8a32                	mv	s4,a2
    800016a0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800016a2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800016a4:	6a85                	lui	s5,0x1
    800016a6:	a015                	j	800016ca <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016a8:	9562                	add	a0,a0,s8
    800016aa:	0004861b          	sext.w	a2,s1
    800016ae:	85d2                	mv	a1,s4
    800016b0:	41250533          	sub	a0,a0,s2
    800016b4:	fffff097          	auipc	ra,0xfffff
    800016b8:	666080e7          	jalr	1638(ra) # 80000d1a <memmove>

    len -= n;
    800016bc:	409989b3          	sub	s3,s3,s1
    src += n;
    800016c0:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016c2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016c6:	02098263          	beqz	s3,800016ea <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016ca:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016ce:	85ca                	mv	a1,s2
    800016d0:	855a                	mv	a0,s6
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	9bc080e7          	jalr	-1604(ra) # 8000108e <walkaddr>
    if(pa0 == 0)
    800016da:	cd01                	beqz	a0,800016f2 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016dc:	418904b3          	sub	s1,s2,s8
    800016e0:	94d6                	add	s1,s1,s5
    if(n > len)
    800016e2:	fc99f3e3          	bgeu	s3,s1,800016a8 <copyout+0x28>
    800016e6:	84ce                	mv	s1,s3
    800016e8:	b7c1                	j	800016a8 <copyout+0x28>
  }
  return 0;
    800016ea:	4501                	li	a0,0
    800016ec:	a021                	j	800016f4 <copyout+0x74>
    800016ee:	4501                	li	a0,0
}
    800016f0:	8082                	ret
      return -1;
    800016f2:	557d                	li	a0,-1
}
    800016f4:	60a6                	ld	ra,72(sp)
    800016f6:	6406                	ld	s0,64(sp)
    800016f8:	74e2                	ld	s1,56(sp)
    800016fa:	7942                	ld	s2,48(sp)
    800016fc:	79a2                	ld	s3,40(sp)
    800016fe:	7a02                	ld	s4,32(sp)
    80001700:	6ae2                	ld	s5,24(sp)
    80001702:	6b42                	ld	s6,16(sp)
    80001704:	6ba2                	ld	s7,8(sp)
    80001706:	6c02                	ld	s8,0(sp)
    80001708:	6161                	addi	sp,sp,80
    8000170a:	8082                	ret

000000008000170c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000170c:	caa5                	beqz	a3,8000177c <copyin+0x70>
{
    8000170e:	715d                	addi	sp,sp,-80
    80001710:	e486                	sd	ra,72(sp)
    80001712:	e0a2                	sd	s0,64(sp)
    80001714:	fc26                	sd	s1,56(sp)
    80001716:	f84a                	sd	s2,48(sp)
    80001718:	f44e                	sd	s3,40(sp)
    8000171a:	f052                	sd	s4,32(sp)
    8000171c:	ec56                	sd	s5,24(sp)
    8000171e:	e85a                	sd	s6,16(sp)
    80001720:	e45e                	sd	s7,8(sp)
    80001722:	e062                	sd	s8,0(sp)
    80001724:	0880                	addi	s0,sp,80
    80001726:	8b2a                	mv	s6,a0
    80001728:	8a2e                	mv	s4,a1
    8000172a:	8c32                	mv	s8,a2
    8000172c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000172e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001730:	6a85                	lui	s5,0x1
    80001732:	a01d                	j	80001758 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001734:	018505b3          	add	a1,a0,s8
    80001738:	0004861b          	sext.w	a2,s1
    8000173c:	412585b3          	sub	a1,a1,s2
    80001740:	8552                	mv	a0,s4
    80001742:	fffff097          	auipc	ra,0xfffff
    80001746:	5d8080e7          	jalr	1496(ra) # 80000d1a <memmove>

    len -= n;
    8000174a:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000174e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001750:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001754:	02098263          	beqz	s3,80001778 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001758:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000175c:	85ca                	mv	a1,s2
    8000175e:	855a                	mv	a0,s6
    80001760:	00000097          	auipc	ra,0x0
    80001764:	92e080e7          	jalr	-1746(ra) # 8000108e <walkaddr>
    if(pa0 == 0)
    80001768:	cd01                	beqz	a0,80001780 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000176a:	418904b3          	sub	s1,s2,s8
    8000176e:	94d6                	add	s1,s1,s5
    if(n > len)
    80001770:	fc99f2e3          	bgeu	s3,s1,80001734 <copyin+0x28>
    80001774:	84ce                	mv	s1,s3
    80001776:	bf7d                	j	80001734 <copyin+0x28>
  }
  return 0;
    80001778:	4501                	li	a0,0
    8000177a:	a021                	j	80001782 <copyin+0x76>
    8000177c:	4501                	li	a0,0
}
    8000177e:	8082                	ret
      return -1;
    80001780:	557d                	li	a0,-1
}
    80001782:	60a6                	ld	ra,72(sp)
    80001784:	6406                	ld	s0,64(sp)
    80001786:	74e2                	ld	s1,56(sp)
    80001788:	7942                	ld	s2,48(sp)
    8000178a:	79a2                	ld	s3,40(sp)
    8000178c:	7a02                	ld	s4,32(sp)
    8000178e:	6ae2                	ld	s5,24(sp)
    80001790:	6b42                	ld	s6,16(sp)
    80001792:	6ba2                	ld	s7,8(sp)
    80001794:	6c02                	ld	s8,0(sp)
    80001796:	6161                	addi	sp,sp,80
    80001798:	8082                	ret

000000008000179a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000179a:	c6c5                	beqz	a3,80001842 <copyinstr+0xa8>
{
    8000179c:	715d                	addi	sp,sp,-80
    8000179e:	e486                	sd	ra,72(sp)
    800017a0:	e0a2                	sd	s0,64(sp)
    800017a2:	fc26                	sd	s1,56(sp)
    800017a4:	f84a                	sd	s2,48(sp)
    800017a6:	f44e                	sd	s3,40(sp)
    800017a8:	f052                	sd	s4,32(sp)
    800017aa:	ec56                	sd	s5,24(sp)
    800017ac:	e85a                	sd	s6,16(sp)
    800017ae:	e45e                	sd	s7,8(sp)
    800017b0:	0880                	addi	s0,sp,80
    800017b2:	8a2a                	mv	s4,a0
    800017b4:	8b2e                	mv	s6,a1
    800017b6:	8bb2                	mv	s7,a2
    800017b8:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017ba:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017bc:	6985                	lui	s3,0x1
    800017be:	a035                	j	800017ea <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017c0:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017c4:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017c6:	0017b793          	seqz	a5,a5
    800017ca:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017ce:	60a6                	ld	ra,72(sp)
    800017d0:	6406                	ld	s0,64(sp)
    800017d2:	74e2                	ld	s1,56(sp)
    800017d4:	7942                	ld	s2,48(sp)
    800017d6:	79a2                	ld	s3,40(sp)
    800017d8:	7a02                	ld	s4,32(sp)
    800017da:	6ae2                	ld	s5,24(sp)
    800017dc:	6b42                	ld	s6,16(sp)
    800017de:	6ba2                	ld	s7,8(sp)
    800017e0:	6161                	addi	sp,sp,80
    800017e2:	8082                	ret
    srcva = va0 + PGSIZE;
    800017e4:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017e8:	c8a9                	beqz	s1,8000183a <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017ea:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017ee:	85ca                	mv	a1,s2
    800017f0:	8552                	mv	a0,s4
    800017f2:	00000097          	auipc	ra,0x0
    800017f6:	89c080e7          	jalr	-1892(ra) # 8000108e <walkaddr>
    if(pa0 == 0)
    800017fa:	c131                	beqz	a0,8000183e <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017fc:	41790833          	sub	a6,s2,s7
    80001800:	984e                	add	a6,a6,s3
    if(n > max)
    80001802:	0104f363          	bgeu	s1,a6,80001808 <copyinstr+0x6e>
    80001806:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001808:	955e                	add	a0,a0,s7
    8000180a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    8000180e:	fc080be3          	beqz	a6,800017e4 <copyinstr+0x4a>
    80001812:	985a                	add	a6,a6,s6
    80001814:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001816:	41650633          	sub	a2,a0,s6
    8000181a:	14fd                	addi	s1,s1,-1
    8000181c:	9b26                	add	s6,s6,s1
    8000181e:	00f60733          	add	a4,a2,a5
    80001822:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    80001826:	df49                	beqz	a4,800017c0 <copyinstr+0x26>
        *dst = *p;
    80001828:	00e78023          	sb	a4,0(a5)
      --max;
    8000182c:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001830:	0785                	addi	a5,a5,1
    while(n > 0){
    80001832:	ff0796e3          	bne	a5,a6,8000181e <copyinstr+0x84>
      dst++;
    80001836:	8b42                	mv	s6,a6
    80001838:	b775                	j	800017e4 <copyinstr+0x4a>
    8000183a:	4781                	li	a5,0
    8000183c:	b769                	j	800017c6 <copyinstr+0x2c>
      return -1;
    8000183e:	557d                	li	a0,-1
    80001840:	b779                	j	800017ce <copyinstr+0x34>
  int got_null = 0;
    80001842:	4781                	li	a5,0
  if(got_null){
    80001844:	0017b793          	seqz	a5,a5
    80001848:	40f00533          	neg	a0,a5
}
    8000184c:	8082                	ret

000000008000184e <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    8000184e:	7139                	addi	sp,sp,-64
    80001850:	fc06                	sd	ra,56(sp)
    80001852:	f822                	sd	s0,48(sp)
    80001854:	f426                	sd	s1,40(sp)
    80001856:	f04a                	sd	s2,32(sp)
    80001858:	ec4e                	sd	s3,24(sp)
    8000185a:	e852                	sd	s4,16(sp)
    8000185c:	e456                	sd	s5,8(sp)
    8000185e:	e05a                	sd	s6,0(sp)
    80001860:	0080                	addi	s0,sp,64
    80001862:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001864:	00010497          	auipc	s1,0x10
    80001868:	e6c48493          	addi	s1,s1,-404 # 800116d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000186c:	8b26                	mv	s6,s1
    8000186e:	00006a97          	auipc	s5,0x6
    80001872:	792a8a93          	addi	s5,s5,1938 # 80008000 <etext>
    80001876:	04000937          	lui	s2,0x4000
    8000187a:	197d                	addi	s2,s2,-1
    8000187c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000187e:	00016a17          	auipc	s4,0x16
    80001882:	852a0a13          	addi	s4,s4,-1966 # 800170d0 <tickslock>
    char *pa = kalloc();
    80001886:	fffff097          	auipc	ra,0xfffff
    8000188a:	24c080e7          	jalr	588(ra) # 80000ad2 <kalloc>
    8000188e:	862a                	mv	a2,a0
    if(pa == 0)
    80001890:	c131                	beqz	a0,800018d4 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001892:	416485b3          	sub	a1,s1,s6
    80001896:	858d                	srai	a1,a1,0x3
    80001898:	000ab783          	ld	a5,0(s5)
    8000189c:	02f585b3          	mul	a1,a1,a5
    800018a0:	2585                	addiw	a1,a1,1
    800018a2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018a6:	4719                	li	a4,6
    800018a8:	6685                	lui	a3,0x1
    800018aa:	40b905b3          	sub	a1,s2,a1
    800018ae:	854e                	mv	a0,s3
    800018b0:	00000097          	auipc	ra,0x0
    800018b4:	8ae080e7          	jalr	-1874(ra) # 8000115e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018b8:	16848493          	addi	s1,s1,360
    800018bc:	fd4495e3          	bne	s1,s4,80001886 <proc_mapstacks+0x38>
  }
}
    800018c0:	70e2                	ld	ra,56(sp)
    800018c2:	7442                	ld	s0,48(sp)
    800018c4:	74a2                	ld	s1,40(sp)
    800018c6:	7902                	ld	s2,32(sp)
    800018c8:	69e2                	ld	s3,24(sp)
    800018ca:	6a42                	ld	s4,16(sp)
    800018cc:	6aa2                	ld	s5,8(sp)
    800018ce:	6b02                	ld	s6,0(sp)
    800018d0:	6121                	addi	sp,sp,64
    800018d2:	8082                	ret
      panic("kalloc");
    800018d4:	00007517          	auipc	a0,0x7
    800018d8:	8ec50513          	addi	a0,a0,-1812 # 800081c0 <digits+0x180>
    800018dc:	fffff097          	auipc	ra,0xfffff
    800018e0:	c4e080e7          	jalr	-946(ra) # 8000052a <panic>

00000000800018e4 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    800018e4:	7139                	addi	sp,sp,-64
    800018e6:	fc06                	sd	ra,56(sp)
    800018e8:	f822                	sd	s0,48(sp)
    800018ea:	f426                	sd	s1,40(sp)
    800018ec:	f04a                	sd	s2,32(sp)
    800018ee:	ec4e                	sd	s3,24(sp)
    800018f0:	e852                	sd	s4,16(sp)
    800018f2:	e456                	sd	s5,8(sp)
    800018f4:	e05a                	sd	s6,0(sp)
    800018f6:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018f8:	00007597          	auipc	a1,0x7
    800018fc:	8d058593          	addi	a1,a1,-1840 # 800081c8 <digits+0x188>
    80001900:	00010517          	auipc	a0,0x10
    80001904:	9a050513          	addi	a0,a0,-1632 # 800112a0 <pid_lock>
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	22a080e7          	jalr	554(ra) # 80000b32 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001910:	00007597          	auipc	a1,0x7
    80001914:	8c058593          	addi	a1,a1,-1856 # 800081d0 <digits+0x190>
    80001918:	00010517          	auipc	a0,0x10
    8000191c:	9a050513          	addi	a0,a0,-1632 # 800112b8 <wait_lock>
    80001920:	fffff097          	auipc	ra,0xfffff
    80001924:	212080e7          	jalr	530(ra) # 80000b32 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001928:	00010497          	auipc	s1,0x10
    8000192c:	da848493          	addi	s1,s1,-600 # 800116d0 <proc>
      initlock(&p->lock, "proc");
    80001930:	00007b17          	auipc	s6,0x7
    80001934:	8b0b0b13          	addi	s6,s6,-1872 # 800081e0 <digits+0x1a0>
      p->kstack = KSTACK((int) (p - proc));
    80001938:	8aa6                	mv	s5,s1
    8000193a:	00006a17          	auipc	s4,0x6
    8000193e:	6c6a0a13          	addi	s4,s4,1734 # 80008000 <etext>
    80001942:	04000937          	lui	s2,0x4000
    80001946:	197d                	addi	s2,s2,-1
    80001948:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000194a:	00015997          	auipc	s3,0x15
    8000194e:	78698993          	addi	s3,s3,1926 # 800170d0 <tickslock>
      initlock(&p->lock, "proc");
    80001952:	85da                	mv	a1,s6
    80001954:	8526                	mv	a0,s1
    80001956:	fffff097          	auipc	ra,0xfffff
    8000195a:	1dc080e7          	jalr	476(ra) # 80000b32 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    8000195e:	415487b3          	sub	a5,s1,s5
    80001962:	878d                	srai	a5,a5,0x3
    80001964:	000a3703          	ld	a4,0(s4)
    80001968:	02e787b3          	mul	a5,a5,a4
    8000196c:	2785                	addiw	a5,a5,1
    8000196e:	00d7979b          	slliw	a5,a5,0xd
    80001972:	40f907b3          	sub	a5,s2,a5
    80001976:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001978:	16848493          	addi	s1,s1,360
    8000197c:	fd349be3          	bne	s1,s3,80001952 <procinit+0x6e>
  }
}
    80001980:	70e2                	ld	ra,56(sp)
    80001982:	7442                	ld	s0,48(sp)
    80001984:	74a2                	ld	s1,40(sp)
    80001986:	7902                	ld	s2,32(sp)
    80001988:	69e2                	ld	s3,24(sp)
    8000198a:	6a42                	ld	s4,16(sp)
    8000198c:	6aa2                	ld	s5,8(sp)
    8000198e:	6b02                	ld	s6,0(sp)
    80001990:	6121                	addi	sp,sp,64
    80001992:	8082                	ret

0000000080001994 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001994:	1141                	addi	sp,sp,-16
    80001996:	e422                	sd	s0,8(sp)
    80001998:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000199a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000199c:	2501                	sext.w	a0,a0
    8000199e:	6422                	ld	s0,8(sp)
    800019a0:	0141                	addi	sp,sp,16
    800019a2:	8082                	ret

00000000800019a4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    800019a4:	1141                	addi	sp,sp,-16
    800019a6:	e422                	sd	s0,8(sp)
    800019a8:	0800                	addi	s0,sp,16
    800019aa:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800019ac:	2781                	sext.w	a5,a5
    800019ae:	079e                	slli	a5,a5,0x7
  return c;
}
    800019b0:	00010517          	auipc	a0,0x10
    800019b4:	92050513          	addi	a0,a0,-1760 # 800112d0 <cpus>
    800019b8:	953e                	add	a0,a0,a5
    800019ba:	6422                	ld	s0,8(sp)
    800019bc:	0141                	addi	sp,sp,16
    800019be:	8082                	ret

00000000800019c0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    800019c0:	1101                	addi	sp,sp,-32
    800019c2:	ec06                	sd	ra,24(sp)
    800019c4:	e822                	sd	s0,16(sp)
    800019c6:	e426                	sd	s1,8(sp)
    800019c8:	1000                	addi	s0,sp,32
  push_off();
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	1ac080e7          	jalr	428(ra) # 80000b76 <push_off>
    800019d2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019d4:	2781                	sext.w	a5,a5
    800019d6:	079e                	slli	a5,a5,0x7
    800019d8:	00010717          	auipc	a4,0x10
    800019dc:	8c870713          	addi	a4,a4,-1848 # 800112a0 <pid_lock>
    800019e0:	97ba                	add	a5,a5,a4
    800019e2:	7b84                	ld	s1,48(a5)
  pop_off();
    800019e4:	fffff097          	auipc	ra,0xfffff
    800019e8:	232080e7          	jalr	562(ra) # 80000c16 <pop_off>
  return p;
}
    800019ec:	8526                	mv	a0,s1
    800019ee:	60e2                	ld	ra,24(sp)
    800019f0:	6442                	ld	s0,16(sp)
    800019f2:	64a2                	ld	s1,8(sp)
    800019f4:	6105                	addi	sp,sp,32
    800019f6:	8082                	ret

00000000800019f8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019f8:	1141                	addi	sp,sp,-16
    800019fa:	e406                	sd	ra,8(sp)
    800019fc:	e022                	sd	s0,0(sp)
    800019fe:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a00:	00000097          	auipc	ra,0x0
    80001a04:	fc0080e7          	jalr	-64(ra) # 800019c0 <myproc>
    80001a08:	fffff097          	auipc	ra,0xfffff
    80001a0c:	26e080e7          	jalr	622(ra) # 80000c76 <release>

  if (first) {
    80001a10:	00007797          	auipc	a5,0x7
    80001a14:	df07a783          	lw	a5,-528(a5) # 80008800 <first.1>
    80001a18:	eb89                	bnez	a5,80001a2a <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a1a:	00001097          	auipc	ra,0x1
    80001a1e:	c0e080e7          	jalr	-1010(ra) # 80002628 <usertrapret>
}
    80001a22:	60a2                	ld	ra,8(sp)
    80001a24:	6402                	ld	s0,0(sp)
    80001a26:	0141                	addi	sp,sp,16
    80001a28:	8082                	ret
    first = 0;
    80001a2a:	00007797          	auipc	a5,0x7
    80001a2e:	dc07ab23          	sw	zero,-554(a5) # 80008800 <first.1>
    fsinit(ROOTDEV);
    80001a32:	4505                	li	a0,1
    80001a34:	00002097          	auipc	ra,0x2
    80001a38:	ac6080e7          	jalr	-1338(ra) # 800034fa <fsinit>
    80001a3c:	bff9                	j	80001a1a <forkret+0x22>

0000000080001a3e <allocpid>:
allocpid() {
    80001a3e:	1101                	addi	sp,sp,-32
    80001a40:	ec06                	sd	ra,24(sp)
    80001a42:	e822                	sd	s0,16(sp)
    80001a44:	e426                	sd	s1,8(sp)
    80001a46:	e04a                	sd	s2,0(sp)
    80001a48:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a4a:	00010917          	auipc	s2,0x10
    80001a4e:	85690913          	addi	s2,s2,-1962 # 800112a0 <pid_lock>
    80001a52:	854a                	mv	a0,s2
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	16e080e7          	jalr	366(ra) # 80000bc2 <acquire>
  pid = nextpid;
    80001a5c:	00007797          	auipc	a5,0x7
    80001a60:	da878793          	addi	a5,a5,-600 # 80008804 <nextpid>
    80001a64:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a66:	0014871b          	addiw	a4,s1,1
    80001a6a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a6c:	854a                	mv	a0,s2
    80001a6e:	fffff097          	auipc	ra,0xfffff
    80001a72:	208080e7          	jalr	520(ra) # 80000c76 <release>
}
    80001a76:	8526                	mv	a0,s1
    80001a78:	60e2                	ld	ra,24(sp)
    80001a7a:	6442                	ld	s0,16(sp)
    80001a7c:	64a2                	ld	s1,8(sp)
    80001a7e:	6902                	ld	s2,0(sp)
    80001a80:	6105                	addi	sp,sp,32
    80001a82:	8082                	ret

0000000080001a84 <proc_pagetable>:
{
    80001a84:	1101                	addi	sp,sp,-32
    80001a86:	ec06                	sd	ra,24(sp)
    80001a88:	e822                	sd	s0,16(sp)
    80001a8a:	e426                	sd	s1,8(sp)
    80001a8c:	e04a                	sd	s2,0(sp)
    80001a8e:	1000                	addi	s0,sp,32
    80001a90:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a92:	00000097          	auipc	ra,0x0
    80001a96:	8b6080e7          	jalr	-1866(ra) # 80001348 <uvmcreate>
    80001a9a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a9c:	c121                	beqz	a0,80001adc <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a9e:	4729                	li	a4,10
    80001aa0:	00005697          	auipc	a3,0x5
    80001aa4:	56068693          	addi	a3,a3,1376 # 80007000 <_trampoline>
    80001aa8:	6605                	lui	a2,0x1
    80001aaa:	040005b7          	lui	a1,0x4000
    80001aae:	15fd                	addi	a1,a1,-1
    80001ab0:	05b2                	slli	a1,a1,0xc
    80001ab2:	fffff097          	auipc	ra,0xfffff
    80001ab6:	61e080e7          	jalr	1566(ra) # 800010d0 <mappages>
    80001aba:	02054863          	bltz	a0,80001aea <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001abe:	4719                	li	a4,6
    80001ac0:	05893683          	ld	a3,88(s2)
    80001ac4:	6605                	lui	a2,0x1
    80001ac6:	020005b7          	lui	a1,0x2000
    80001aca:	15fd                	addi	a1,a1,-1
    80001acc:	05b6                	slli	a1,a1,0xd
    80001ace:	8526                	mv	a0,s1
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	600080e7          	jalr	1536(ra) # 800010d0 <mappages>
    80001ad8:	02054163          	bltz	a0,80001afa <proc_pagetable+0x76>
}
    80001adc:	8526                	mv	a0,s1
    80001ade:	60e2                	ld	ra,24(sp)
    80001ae0:	6442                	ld	s0,16(sp)
    80001ae2:	64a2                	ld	s1,8(sp)
    80001ae4:	6902                	ld	s2,0(sp)
    80001ae6:	6105                	addi	sp,sp,32
    80001ae8:	8082                	ret
    uvmfree(pagetable, 0);
    80001aea:	4581                	li	a1,0
    80001aec:	8526                	mv	a0,s1
    80001aee:	00000097          	auipc	ra,0x0
    80001af2:	a56080e7          	jalr	-1450(ra) # 80001544 <uvmfree>
    return 0;
    80001af6:	4481                	li	s1,0
    80001af8:	b7d5                	j	80001adc <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001afa:	4681                	li	a3,0
    80001afc:	4605                	li	a2,1
    80001afe:	040005b7          	lui	a1,0x4000
    80001b02:	15fd                	addi	a1,a1,-1
    80001b04:	05b2                	slli	a1,a1,0xc
    80001b06:	8526                	mv	a0,s1
    80001b08:	fffff097          	auipc	ra,0xfffff
    80001b0c:	77c080e7          	jalr	1916(ra) # 80001284 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b10:	4581                	li	a1,0
    80001b12:	8526                	mv	a0,s1
    80001b14:	00000097          	auipc	ra,0x0
    80001b18:	a30080e7          	jalr	-1488(ra) # 80001544 <uvmfree>
    return 0;
    80001b1c:	4481                	li	s1,0
    80001b1e:	bf7d                	j	80001adc <proc_pagetable+0x58>

0000000080001b20 <proc_freepagetable>:
{
    80001b20:	1101                	addi	sp,sp,-32
    80001b22:	ec06                	sd	ra,24(sp)
    80001b24:	e822                	sd	s0,16(sp)
    80001b26:	e426                	sd	s1,8(sp)
    80001b28:	e04a                	sd	s2,0(sp)
    80001b2a:	1000                	addi	s0,sp,32
    80001b2c:	84aa                	mv	s1,a0
    80001b2e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b30:	4681                	li	a3,0
    80001b32:	4605                	li	a2,1
    80001b34:	040005b7          	lui	a1,0x4000
    80001b38:	15fd                	addi	a1,a1,-1
    80001b3a:	05b2                	slli	a1,a1,0xc
    80001b3c:	fffff097          	auipc	ra,0xfffff
    80001b40:	748080e7          	jalr	1864(ra) # 80001284 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b44:	4681                	li	a3,0
    80001b46:	4605                	li	a2,1
    80001b48:	020005b7          	lui	a1,0x2000
    80001b4c:	15fd                	addi	a1,a1,-1
    80001b4e:	05b6                	slli	a1,a1,0xd
    80001b50:	8526                	mv	a0,s1
    80001b52:	fffff097          	auipc	ra,0xfffff
    80001b56:	732080e7          	jalr	1842(ra) # 80001284 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b5a:	85ca                	mv	a1,s2
    80001b5c:	8526                	mv	a0,s1
    80001b5e:	00000097          	auipc	ra,0x0
    80001b62:	9e6080e7          	jalr	-1562(ra) # 80001544 <uvmfree>
}
    80001b66:	60e2                	ld	ra,24(sp)
    80001b68:	6442                	ld	s0,16(sp)
    80001b6a:	64a2                	ld	s1,8(sp)
    80001b6c:	6902                	ld	s2,0(sp)
    80001b6e:	6105                	addi	sp,sp,32
    80001b70:	8082                	ret

0000000080001b72 <freeproc>:
{
    80001b72:	1101                	addi	sp,sp,-32
    80001b74:	ec06                	sd	ra,24(sp)
    80001b76:	e822                	sd	s0,16(sp)
    80001b78:	e426                	sd	s1,8(sp)
    80001b7a:	1000                	addi	s0,sp,32
    80001b7c:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b7e:	6d28                	ld	a0,88(a0)
    80001b80:	c509                	beqz	a0,80001b8a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	e54080e7          	jalr	-428(ra) # 800009d6 <kfree>
  p->trapframe = 0;
    80001b8a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b8e:	68a8                	ld	a0,80(s1)
    80001b90:	c511                	beqz	a0,80001b9c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b92:	64ac                	ld	a1,72(s1)
    80001b94:	00000097          	auipc	ra,0x0
    80001b98:	f8c080e7          	jalr	-116(ra) # 80001b20 <proc_freepagetable>
  p->pagetable = 0;
    80001b9c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ba0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001ba4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ba8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001bac:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001bb0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001bb4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001bb8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001bbc:	0004ac23          	sw	zero,24(s1)
}
    80001bc0:	60e2                	ld	ra,24(sp)
    80001bc2:	6442                	ld	s0,16(sp)
    80001bc4:	64a2                	ld	s1,8(sp)
    80001bc6:	6105                	addi	sp,sp,32
    80001bc8:	8082                	ret

0000000080001bca <allocproc>:
{
    80001bca:	1101                	addi	sp,sp,-32
    80001bcc:	ec06                	sd	ra,24(sp)
    80001bce:	e822                	sd	s0,16(sp)
    80001bd0:	e426                	sd	s1,8(sp)
    80001bd2:	e04a                	sd	s2,0(sp)
    80001bd4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bd6:	00010497          	auipc	s1,0x10
    80001bda:	afa48493          	addi	s1,s1,-1286 # 800116d0 <proc>
    80001bde:	00015917          	auipc	s2,0x15
    80001be2:	4f290913          	addi	s2,s2,1266 # 800170d0 <tickslock>
    acquire(&p->lock);
    80001be6:	8526                	mv	a0,s1
    80001be8:	fffff097          	auipc	ra,0xfffff
    80001bec:	fda080e7          	jalr	-38(ra) # 80000bc2 <acquire>
    if(p->state == UNUSED) {
    80001bf0:	4c9c                	lw	a5,24(s1)
    80001bf2:	cf81                	beqz	a5,80001c0a <allocproc+0x40>
      release(&p->lock);
    80001bf4:	8526                	mv	a0,s1
    80001bf6:	fffff097          	auipc	ra,0xfffff
    80001bfa:	080080e7          	jalr	128(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bfe:	16848493          	addi	s1,s1,360
    80001c02:	ff2492e3          	bne	s1,s2,80001be6 <allocproc+0x1c>
  return 0;
    80001c06:	4481                	li	s1,0
    80001c08:	a889                	j	80001c5a <allocproc+0x90>
  p->pid = allocpid();
    80001c0a:	00000097          	auipc	ra,0x0
    80001c0e:	e34080e7          	jalr	-460(ra) # 80001a3e <allocpid>
    80001c12:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c14:	4785                	li	a5,1
    80001c16:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	eba080e7          	jalr	-326(ra) # 80000ad2 <kalloc>
    80001c20:	892a                	mv	s2,a0
    80001c22:	eca8                	sd	a0,88(s1)
    80001c24:	c131                	beqz	a0,80001c68 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001c26:	8526                	mv	a0,s1
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	e5c080e7          	jalr	-420(ra) # 80001a84 <proc_pagetable>
    80001c30:	892a                	mv	s2,a0
    80001c32:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c34:	c531                	beqz	a0,80001c80 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001c36:	07000613          	li	a2,112
    80001c3a:	4581                	li	a1,0
    80001c3c:	06048513          	addi	a0,s1,96
    80001c40:	fffff097          	auipc	ra,0xfffff
    80001c44:	07e080e7          	jalr	126(ra) # 80000cbe <memset>
  p->context.ra = (uint64)forkret;
    80001c48:	00000797          	auipc	a5,0x0
    80001c4c:	db078793          	addi	a5,a5,-592 # 800019f8 <forkret>
    80001c50:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c52:	60bc                	ld	a5,64(s1)
    80001c54:	6705                	lui	a4,0x1
    80001c56:	97ba                	add	a5,a5,a4
    80001c58:	f4bc                	sd	a5,104(s1)
}
    80001c5a:	8526                	mv	a0,s1
    80001c5c:	60e2                	ld	ra,24(sp)
    80001c5e:	6442                	ld	s0,16(sp)
    80001c60:	64a2                	ld	s1,8(sp)
    80001c62:	6902                	ld	s2,0(sp)
    80001c64:	6105                	addi	sp,sp,32
    80001c66:	8082                	ret
    freeproc(p);
    80001c68:	8526                	mv	a0,s1
    80001c6a:	00000097          	auipc	ra,0x0
    80001c6e:	f08080e7          	jalr	-248(ra) # 80001b72 <freeproc>
    release(&p->lock);
    80001c72:	8526                	mv	a0,s1
    80001c74:	fffff097          	auipc	ra,0xfffff
    80001c78:	002080e7          	jalr	2(ra) # 80000c76 <release>
    return 0;
    80001c7c:	84ca                	mv	s1,s2
    80001c7e:	bff1                	j	80001c5a <allocproc+0x90>
    freeproc(p);
    80001c80:	8526                	mv	a0,s1
    80001c82:	00000097          	auipc	ra,0x0
    80001c86:	ef0080e7          	jalr	-272(ra) # 80001b72 <freeproc>
    release(&p->lock);
    80001c8a:	8526                	mv	a0,s1
    80001c8c:	fffff097          	auipc	ra,0xfffff
    80001c90:	fea080e7          	jalr	-22(ra) # 80000c76 <release>
    return 0;
    80001c94:	84ca                	mv	s1,s2
    80001c96:	b7d1                	j	80001c5a <allocproc+0x90>

0000000080001c98 <userinit>:
{
    80001c98:	1101                	addi	sp,sp,-32
    80001c9a:	ec06                	sd	ra,24(sp)
    80001c9c:	e822                	sd	s0,16(sp)
    80001c9e:	e426                	sd	s1,8(sp)
    80001ca0:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ca2:	00000097          	auipc	ra,0x0
    80001ca6:	f28080e7          	jalr	-216(ra) # 80001bca <allocproc>
    80001caa:	84aa                	mv	s1,a0
  initproc = p;
    80001cac:	00007797          	auipc	a5,0x7
    80001cb0:	36a7be23          	sd	a0,892(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cb4:	03400613          	li	a2,52
    80001cb8:	00007597          	auipc	a1,0x7
    80001cbc:	b5858593          	addi	a1,a1,-1192 # 80008810 <initcode>
    80001cc0:	6928                	ld	a0,80(a0)
    80001cc2:	fffff097          	auipc	ra,0xfffff
    80001cc6:	6b4080e7          	jalr	1716(ra) # 80001376 <uvminit>
  p->sz = PGSIZE;
    80001cca:	6785                	lui	a5,0x1
    80001ccc:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cce:	6cb8                	ld	a4,88(s1)
    80001cd0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cd4:	6cb8                	ld	a4,88(s1)
    80001cd6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cd8:	4641                	li	a2,16
    80001cda:	00006597          	auipc	a1,0x6
    80001cde:	50e58593          	addi	a1,a1,1294 # 800081e8 <digits+0x1a8>
    80001ce2:	15848513          	addi	a0,s1,344
    80001ce6:	fffff097          	auipc	ra,0xfffff
    80001cea:	12a080e7          	jalr	298(ra) # 80000e10 <safestrcpy>
  p->cwd = namei("/");
    80001cee:	00006517          	auipc	a0,0x6
    80001cf2:	50a50513          	addi	a0,a0,1290 # 800081f8 <digits+0x1b8>
    80001cf6:	00002097          	auipc	ra,0x2
    80001cfa:	404080e7          	jalr	1028(ra) # 800040fa <namei>
    80001cfe:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d02:	478d                	li	a5,3
    80001d04:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d06:	8526                	mv	a0,s1
    80001d08:	fffff097          	auipc	ra,0xfffff
    80001d0c:	f6e080e7          	jalr	-146(ra) # 80000c76 <release>
}
    80001d10:	60e2                	ld	ra,24(sp)
    80001d12:	6442                	ld	s0,16(sp)
    80001d14:	64a2                	ld	s1,8(sp)
    80001d16:	6105                	addi	sp,sp,32
    80001d18:	8082                	ret

0000000080001d1a <growproc>:
{
    80001d1a:	1101                	addi	sp,sp,-32
    80001d1c:	ec06                	sd	ra,24(sp)
    80001d1e:	e822                	sd	s0,16(sp)
    80001d20:	e426                	sd	s1,8(sp)
    80001d22:	e04a                	sd	s2,0(sp)
    80001d24:	1000                	addi	s0,sp,32
    80001d26:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d28:	00000097          	auipc	ra,0x0
    80001d2c:	c98080e7          	jalr	-872(ra) # 800019c0 <myproc>
    80001d30:	892a                	mv	s2,a0
  sz = p->sz;
    80001d32:	652c                	ld	a1,72(a0)
    80001d34:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001d38:	00904f63          	bgtz	s1,80001d56 <growproc+0x3c>
  } else if(n < 0){
    80001d3c:	0204cc63          	bltz	s1,80001d74 <growproc+0x5a>
  p->sz = sz;
    80001d40:	1602                	slli	a2,a2,0x20
    80001d42:	9201                	srli	a2,a2,0x20
    80001d44:	04c93423          	sd	a2,72(s2)
  return 0;
    80001d48:	4501                	li	a0,0
}
    80001d4a:	60e2                	ld	ra,24(sp)
    80001d4c:	6442                	ld	s0,16(sp)
    80001d4e:	64a2                	ld	s1,8(sp)
    80001d50:	6902                	ld	s2,0(sp)
    80001d52:	6105                	addi	sp,sp,32
    80001d54:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d56:	9e25                	addw	a2,a2,s1
    80001d58:	1602                	slli	a2,a2,0x20
    80001d5a:	9201                	srli	a2,a2,0x20
    80001d5c:	1582                	slli	a1,a1,0x20
    80001d5e:	9181                	srli	a1,a1,0x20
    80001d60:	6928                	ld	a0,80(a0)
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	6ce080e7          	jalr	1742(ra) # 80001430 <uvmalloc>
    80001d6a:	0005061b          	sext.w	a2,a0
    80001d6e:	fa69                	bnez	a2,80001d40 <growproc+0x26>
      return -1;
    80001d70:	557d                	li	a0,-1
    80001d72:	bfe1                	j	80001d4a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d74:	9e25                	addw	a2,a2,s1
    80001d76:	1602                	slli	a2,a2,0x20
    80001d78:	9201                	srli	a2,a2,0x20
    80001d7a:	1582                	slli	a1,a1,0x20
    80001d7c:	9181                	srli	a1,a1,0x20
    80001d7e:	6928                	ld	a0,80(a0)
    80001d80:	fffff097          	auipc	ra,0xfffff
    80001d84:	668080e7          	jalr	1640(ra) # 800013e8 <uvmdealloc>
    80001d88:	0005061b          	sext.w	a2,a0
    80001d8c:	bf55                	j	80001d40 <growproc+0x26>

0000000080001d8e <fork>:
{
    80001d8e:	7139                	addi	sp,sp,-64
    80001d90:	fc06                	sd	ra,56(sp)
    80001d92:	f822                	sd	s0,48(sp)
    80001d94:	f426                	sd	s1,40(sp)
    80001d96:	f04a                	sd	s2,32(sp)
    80001d98:	ec4e                	sd	s3,24(sp)
    80001d9a:	e852                	sd	s4,16(sp)
    80001d9c:	e456                	sd	s5,8(sp)
    80001d9e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	c20080e7          	jalr	-992(ra) # 800019c0 <myproc>
    80001da8:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001daa:	00000097          	auipc	ra,0x0
    80001dae:	e20080e7          	jalr	-480(ra) # 80001bca <allocproc>
    80001db2:	10050c63          	beqz	a0,80001eca <fork+0x13c>
    80001db6:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001db8:	048ab603          	ld	a2,72(s5)
    80001dbc:	692c                	ld	a1,80(a0)
    80001dbe:	050ab503          	ld	a0,80(s5)
    80001dc2:	fffff097          	auipc	ra,0xfffff
    80001dc6:	7ba080e7          	jalr	1978(ra) # 8000157c <uvmcopy>
    80001dca:	04054863          	bltz	a0,80001e1a <fork+0x8c>
  np->sz = p->sz;
    80001dce:	048ab783          	ld	a5,72(s5)
    80001dd2:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001dd6:	058ab683          	ld	a3,88(s5)
    80001dda:	87b6                	mv	a5,a3
    80001ddc:	058a3703          	ld	a4,88(s4)
    80001de0:	12068693          	addi	a3,a3,288
    80001de4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001de8:	6788                	ld	a0,8(a5)
    80001dea:	6b8c                	ld	a1,16(a5)
    80001dec:	6f90                	ld	a2,24(a5)
    80001dee:	01073023          	sd	a6,0(a4)
    80001df2:	e708                	sd	a0,8(a4)
    80001df4:	eb0c                	sd	a1,16(a4)
    80001df6:	ef10                	sd	a2,24(a4)
    80001df8:	02078793          	addi	a5,a5,32
    80001dfc:	02070713          	addi	a4,a4,32
    80001e00:	fed792e3          	bne	a5,a3,80001de4 <fork+0x56>
  np->trapframe->a0 = 0;
    80001e04:	058a3783          	ld	a5,88(s4)
    80001e08:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e0c:	0d0a8493          	addi	s1,s5,208
    80001e10:	0d0a0913          	addi	s2,s4,208
    80001e14:	150a8993          	addi	s3,s5,336
    80001e18:	a00d                	j	80001e3a <fork+0xac>
    freeproc(np);
    80001e1a:	8552                	mv	a0,s4
    80001e1c:	00000097          	auipc	ra,0x0
    80001e20:	d56080e7          	jalr	-682(ra) # 80001b72 <freeproc>
    release(&np->lock);
    80001e24:	8552                	mv	a0,s4
    80001e26:	fffff097          	auipc	ra,0xfffff
    80001e2a:	e50080e7          	jalr	-432(ra) # 80000c76 <release>
    return -1;
    80001e2e:	597d                	li	s2,-1
    80001e30:	a059                	j	80001eb6 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001e32:	04a1                	addi	s1,s1,8
    80001e34:	0921                	addi	s2,s2,8
    80001e36:	01348b63          	beq	s1,s3,80001e4c <fork+0xbe>
    if(p->ofile[i])
    80001e3a:	6088                	ld	a0,0(s1)
    80001e3c:	d97d                	beqz	a0,80001e32 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e3e:	00003097          	auipc	ra,0x3
    80001e42:	952080e7          	jalr	-1710(ra) # 80004790 <filedup>
    80001e46:	00a93023          	sd	a0,0(s2)
    80001e4a:	b7e5                	j	80001e32 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e4c:	150ab503          	ld	a0,336(s5)
    80001e50:	00002097          	auipc	ra,0x2
    80001e54:	8e4080e7          	jalr	-1820(ra) # 80003734 <idup>
    80001e58:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e5c:	4641                	li	a2,16
    80001e5e:	158a8593          	addi	a1,s5,344
    80001e62:	158a0513          	addi	a0,s4,344
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	faa080e7          	jalr	-86(ra) # 80000e10 <safestrcpy>
  pid = np->pid;
    80001e6e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e72:	8552                	mv	a0,s4
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	e02080e7          	jalr	-510(ra) # 80000c76 <release>
  acquire(&wait_lock);
    80001e7c:	0000f497          	auipc	s1,0xf
    80001e80:	43c48493          	addi	s1,s1,1084 # 800112b8 <wait_lock>
    80001e84:	8526                	mv	a0,s1
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	d3c080e7          	jalr	-708(ra) # 80000bc2 <acquire>
  np->parent = p;
    80001e8e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001e92:	8526                	mv	a0,s1
    80001e94:	fffff097          	auipc	ra,0xfffff
    80001e98:	de2080e7          	jalr	-542(ra) # 80000c76 <release>
  acquire(&np->lock);
    80001e9c:	8552                	mv	a0,s4
    80001e9e:	fffff097          	auipc	ra,0xfffff
    80001ea2:	d24080e7          	jalr	-732(ra) # 80000bc2 <acquire>
  np->state = RUNNABLE;
    80001ea6:	478d                	li	a5,3
    80001ea8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001eac:	8552                	mv	a0,s4
    80001eae:	fffff097          	auipc	ra,0xfffff
    80001eb2:	dc8080e7          	jalr	-568(ra) # 80000c76 <release>
}
    80001eb6:	854a                	mv	a0,s2
    80001eb8:	70e2                	ld	ra,56(sp)
    80001eba:	7442                	ld	s0,48(sp)
    80001ebc:	74a2                	ld	s1,40(sp)
    80001ebe:	7902                	ld	s2,32(sp)
    80001ec0:	69e2                	ld	s3,24(sp)
    80001ec2:	6a42                	ld	s4,16(sp)
    80001ec4:	6aa2                	ld	s5,8(sp)
    80001ec6:	6121                	addi	sp,sp,64
    80001ec8:	8082                	ret
    return -1;
    80001eca:	597d                	li	s2,-1
    80001ecc:	b7ed                	j	80001eb6 <fork+0x128>

0000000080001ece <scheduler>:
{
    80001ece:	7139                	addi	sp,sp,-64
    80001ed0:	fc06                	sd	ra,56(sp)
    80001ed2:	f822                	sd	s0,48(sp)
    80001ed4:	f426                	sd	s1,40(sp)
    80001ed6:	f04a                	sd	s2,32(sp)
    80001ed8:	ec4e                	sd	s3,24(sp)
    80001eda:	e852                	sd	s4,16(sp)
    80001edc:	e456                	sd	s5,8(sp)
    80001ede:	e05a                	sd	s6,0(sp)
    80001ee0:	0080                	addi	s0,sp,64
    80001ee2:	8792                	mv	a5,tp
  int id = r_tp();
    80001ee4:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ee6:	00779a93          	slli	s5,a5,0x7
    80001eea:	0000f717          	auipc	a4,0xf
    80001eee:	3b670713          	addi	a4,a4,950 # 800112a0 <pid_lock>
    80001ef2:	9756                	add	a4,a4,s5
    80001ef4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ef8:	0000f717          	auipc	a4,0xf
    80001efc:	3e070713          	addi	a4,a4,992 # 800112d8 <cpus+0x8>
    80001f00:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001f02:	498d                	li	s3,3
        p->state = RUNNING;
    80001f04:	4b11                	li	s6,4
        c->proc = p;
    80001f06:	079e                	slli	a5,a5,0x7
    80001f08:	0000fa17          	auipc	s4,0xf
    80001f0c:	398a0a13          	addi	s4,s4,920 # 800112a0 <pid_lock>
    80001f10:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f12:	00015917          	auipc	s2,0x15
    80001f16:	1be90913          	addi	s2,s2,446 # 800170d0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f1a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f1e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f22:	10079073          	csrw	sstatus,a5
    80001f26:	0000f497          	auipc	s1,0xf
    80001f2a:	7aa48493          	addi	s1,s1,1962 # 800116d0 <proc>
    80001f2e:	a811                	j	80001f42 <scheduler+0x74>
      release(&p->lock);
    80001f30:	8526                	mv	a0,s1
    80001f32:	fffff097          	auipc	ra,0xfffff
    80001f36:	d44080e7          	jalr	-700(ra) # 80000c76 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f3a:	16848493          	addi	s1,s1,360
    80001f3e:	fd248ee3          	beq	s1,s2,80001f1a <scheduler+0x4c>
      acquire(&p->lock);
    80001f42:	8526                	mv	a0,s1
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	c7e080e7          	jalr	-898(ra) # 80000bc2 <acquire>
      if(p->state == RUNNABLE) {
    80001f4c:	4c9c                	lw	a5,24(s1)
    80001f4e:	ff3791e3          	bne	a5,s3,80001f30 <scheduler+0x62>
        p->state = RUNNING;
    80001f52:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f56:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001f5a:	06048593          	addi	a1,s1,96
    80001f5e:	8556                	mv	a0,s5
    80001f60:	00000097          	auipc	ra,0x0
    80001f64:	61e080e7          	jalr	1566(ra) # 8000257e <swtch>
        c->proc = 0;
    80001f68:	020a3823          	sd	zero,48(s4)
    80001f6c:	b7d1                	j	80001f30 <scheduler+0x62>

0000000080001f6e <sched>:
{
    80001f6e:	7179                	addi	sp,sp,-48
    80001f70:	f406                	sd	ra,40(sp)
    80001f72:	f022                	sd	s0,32(sp)
    80001f74:	ec26                	sd	s1,24(sp)
    80001f76:	e84a                	sd	s2,16(sp)
    80001f78:	e44e                	sd	s3,8(sp)
    80001f7a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f7c:	00000097          	auipc	ra,0x0
    80001f80:	a44080e7          	jalr	-1468(ra) # 800019c0 <myproc>
    80001f84:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	bc2080e7          	jalr	-1086(ra) # 80000b48 <holding>
    80001f8e:	c93d                	beqz	a0,80002004 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f90:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f92:	2781                	sext.w	a5,a5
    80001f94:	079e                	slli	a5,a5,0x7
    80001f96:	0000f717          	auipc	a4,0xf
    80001f9a:	30a70713          	addi	a4,a4,778 # 800112a0 <pid_lock>
    80001f9e:	97ba                	add	a5,a5,a4
    80001fa0:	0a87a703          	lw	a4,168(a5)
    80001fa4:	4785                	li	a5,1
    80001fa6:	06f71763          	bne	a4,a5,80002014 <sched+0xa6>
  if(p->state == RUNNING)
    80001faa:	4c98                	lw	a4,24(s1)
    80001fac:	4791                	li	a5,4
    80001fae:	06f70b63          	beq	a4,a5,80002024 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fb2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fb6:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001fb8:	efb5                	bnez	a5,80002034 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fba:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001fbc:	0000f917          	auipc	s2,0xf
    80001fc0:	2e490913          	addi	s2,s2,740 # 800112a0 <pid_lock>
    80001fc4:	2781                	sext.w	a5,a5
    80001fc6:	079e                	slli	a5,a5,0x7
    80001fc8:	97ca                	add	a5,a5,s2
    80001fca:	0ac7a983          	lw	s3,172(a5)
    80001fce:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001fd0:	2781                	sext.w	a5,a5
    80001fd2:	079e                	slli	a5,a5,0x7
    80001fd4:	0000f597          	auipc	a1,0xf
    80001fd8:	30458593          	addi	a1,a1,772 # 800112d8 <cpus+0x8>
    80001fdc:	95be                	add	a1,a1,a5
    80001fde:	06048513          	addi	a0,s1,96
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	59c080e7          	jalr	1436(ra) # 8000257e <swtch>
    80001fea:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001fec:	2781                	sext.w	a5,a5
    80001fee:	079e                	slli	a5,a5,0x7
    80001ff0:	97ca                	add	a5,a5,s2
    80001ff2:	0b37a623          	sw	s3,172(a5)
}
    80001ff6:	70a2                	ld	ra,40(sp)
    80001ff8:	7402                	ld	s0,32(sp)
    80001ffa:	64e2                	ld	s1,24(sp)
    80001ffc:	6942                	ld	s2,16(sp)
    80001ffe:	69a2                	ld	s3,8(sp)
    80002000:	6145                	addi	sp,sp,48
    80002002:	8082                	ret
    panic("sched p->lock");
    80002004:	00006517          	auipc	a0,0x6
    80002008:	1fc50513          	addi	a0,a0,508 # 80008200 <digits+0x1c0>
    8000200c:	ffffe097          	auipc	ra,0xffffe
    80002010:	51e080e7          	jalr	1310(ra) # 8000052a <panic>
    panic("sched locks");
    80002014:	00006517          	auipc	a0,0x6
    80002018:	1fc50513          	addi	a0,a0,508 # 80008210 <digits+0x1d0>
    8000201c:	ffffe097          	auipc	ra,0xffffe
    80002020:	50e080e7          	jalr	1294(ra) # 8000052a <panic>
    panic("sched running");
    80002024:	00006517          	auipc	a0,0x6
    80002028:	1fc50513          	addi	a0,a0,508 # 80008220 <digits+0x1e0>
    8000202c:	ffffe097          	auipc	ra,0xffffe
    80002030:	4fe080e7          	jalr	1278(ra) # 8000052a <panic>
    panic("sched interruptible");
    80002034:	00006517          	auipc	a0,0x6
    80002038:	1fc50513          	addi	a0,a0,508 # 80008230 <digits+0x1f0>
    8000203c:	ffffe097          	auipc	ra,0xffffe
    80002040:	4ee080e7          	jalr	1262(ra) # 8000052a <panic>

0000000080002044 <yield>:
{
    80002044:	1101                	addi	sp,sp,-32
    80002046:	ec06                	sd	ra,24(sp)
    80002048:	e822                	sd	s0,16(sp)
    8000204a:	e426                	sd	s1,8(sp)
    8000204c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	972080e7          	jalr	-1678(ra) # 800019c0 <myproc>
    80002056:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	b6a080e7          	jalr	-1174(ra) # 80000bc2 <acquire>
  p->state = RUNNABLE;
    80002060:	478d                	li	a5,3
    80002062:	cc9c                	sw	a5,24(s1)
  sched();
    80002064:	00000097          	auipc	ra,0x0
    80002068:	f0a080e7          	jalr	-246(ra) # 80001f6e <sched>
  release(&p->lock);
    8000206c:	8526                	mv	a0,s1
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	c08080e7          	jalr	-1016(ra) # 80000c76 <release>
}
    80002076:	60e2                	ld	ra,24(sp)
    80002078:	6442                	ld	s0,16(sp)
    8000207a:	64a2                	ld	s1,8(sp)
    8000207c:	6105                	addi	sp,sp,32
    8000207e:	8082                	ret

0000000080002080 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002080:	7179                	addi	sp,sp,-48
    80002082:	f406                	sd	ra,40(sp)
    80002084:	f022                	sd	s0,32(sp)
    80002086:	ec26                	sd	s1,24(sp)
    80002088:	e84a                	sd	s2,16(sp)
    8000208a:	e44e                	sd	s3,8(sp)
    8000208c:	1800                	addi	s0,sp,48
    8000208e:	89aa                	mv	s3,a0
    80002090:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002092:	00000097          	auipc	ra,0x0
    80002096:	92e080e7          	jalr	-1746(ra) # 800019c0 <myproc>
    8000209a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	b26080e7          	jalr	-1242(ra) # 80000bc2 <acquire>
  release(lk);
    800020a4:	854a                	mv	a0,s2
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	bd0080e7          	jalr	-1072(ra) # 80000c76 <release>

  // Go to sleep.
  p->chan = chan;
    800020ae:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800020b2:	4789                	li	a5,2
    800020b4:	cc9c                	sw	a5,24(s1)

  sched();
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	eb8080e7          	jalr	-328(ra) # 80001f6e <sched>

  // Tidy up.
  p->chan = 0;
    800020be:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800020c2:	8526                	mv	a0,s1
    800020c4:	fffff097          	auipc	ra,0xfffff
    800020c8:	bb2080e7          	jalr	-1102(ra) # 80000c76 <release>
  acquire(lk);
    800020cc:	854a                	mv	a0,s2
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	af4080e7          	jalr	-1292(ra) # 80000bc2 <acquire>
}
    800020d6:	70a2                	ld	ra,40(sp)
    800020d8:	7402                	ld	s0,32(sp)
    800020da:	64e2                	ld	s1,24(sp)
    800020dc:	6942                	ld	s2,16(sp)
    800020de:	69a2                	ld	s3,8(sp)
    800020e0:	6145                	addi	sp,sp,48
    800020e2:	8082                	ret

00000000800020e4 <wait>:
{
    800020e4:	715d                	addi	sp,sp,-80
    800020e6:	e486                	sd	ra,72(sp)
    800020e8:	e0a2                	sd	s0,64(sp)
    800020ea:	fc26                	sd	s1,56(sp)
    800020ec:	f84a                	sd	s2,48(sp)
    800020ee:	f44e                	sd	s3,40(sp)
    800020f0:	f052                	sd	s4,32(sp)
    800020f2:	ec56                	sd	s5,24(sp)
    800020f4:	e85a                	sd	s6,16(sp)
    800020f6:	e45e                	sd	s7,8(sp)
    800020f8:	e062                	sd	s8,0(sp)
    800020fa:	0880                	addi	s0,sp,80
    800020fc:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800020fe:	00000097          	auipc	ra,0x0
    80002102:	8c2080e7          	jalr	-1854(ra) # 800019c0 <myproc>
    80002106:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002108:	0000f517          	auipc	a0,0xf
    8000210c:	1b050513          	addi	a0,a0,432 # 800112b8 <wait_lock>
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	ab2080e7          	jalr	-1358(ra) # 80000bc2 <acquire>
    havekids = 0;
    80002118:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000211a:	4a15                	li	s4,5
        havekids = 1;
    8000211c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000211e:	00015997          	auipc	s3,0x15
    80002122:	fb298993          	addi	s3,s3,-78 # 800170d0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002126:	0000fc17          	auipc	s8,0xf
    8000212a:	192c0c13          	addi	s8,s8,402 # 800112b8 <wait_lock>
    havekids = 0;
    8000212e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002130:	0000f497          	auipc	s1,0xf
    80002134:	5a048493          	addi	s1,s1,1440 # 800116d0 <proc>
    80002138:	a0bd                	j	800021a6 <wait+0xc2>
          pid = np->pid;
    8000213a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000213e:	000b0e63          	beqz	s6,8000215a <wait+0x76>
    80002142:	4691                	li	a3,4
    80002144:	02c48613          	addi	a2,s1,44
    80002148:	85da                	mv	a1,s6
    8000214a:	05093503          	ld	a0,80(s2)
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	532080e7          	jalr	1330(ra) # 80001680 <copyout>
    80002156:	02054563          	bltz	a0,80002180 <wait+0x9c>
          freeproc(np);
    8000215a:	8526                	mv	a0,s1
    8000215c:	00000097          	auipc	ra,0x0
    80002160:	a16080e7          	jalr	-1514(ra) # 80001b72 <freeproc>
          release(&np->lock);
    80002164:	8526                	mv	a0,s1
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	b10080e7          	jalr	-1264(ra) # 80000c76 <release>
          release(&wait_lock);
    8000216e:	0000f517          	auipc	a0,0xf
    80002172:	14a50513          	addi	a0,a0,330 # 800112b8 <wait_lock>
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	b00080e7          	jalr	-1280(ra) # 80000c76 <release>
          return pid;
    8000217e:	a09d                	j	800021e4 <wait+0x100>
            release(&np->lock);
    80002180:	8526                	mv	a0,s1
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	af4080e7          	jalr	-1292(ra) # 80000c76 <release>
            release(&wait_lock);
    8000218a:	0000f517          	auipc	a0,0xf
    8000218e:	12e50513          	addi	a0,a0,302 # 800112b8 <wait_lock>
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	ae4080e7          	jalr	-1308(ra) # 80000c76 <release>
            return -1;
    8000219a:	59fd                	li	s3,-1
    8000219c:	a0a1                	j	800021e4 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000219e:	16848493          	addi	s1,s1,360
    800021a2:	03348463          	beq	s1,s3,800021ca <wait+0xe6>
      if(np->parent == p){
    800021a6:	7c9c                	ld	a5,56(s1)
    800021a8:	ff279be3          	bne	a5,s2,8000219e <wait+0xba>
        acquire(&np->lock);
    800021ac:	8526                	mv	a0,s1
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	a14080e7          	jalr	-1516(ra) # 80000bc2 <acquire>
        if(np->state == ZOMBIE){
    800021b6:	4c9c                	lw	a5,24(s1)
    800021b8:	f94781e3          	beq	a5,s4,8000213a <wait+0x56>
        release(&np->lock);
    800021bc:	8526                	mv	a0,s1
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	ab8080e7          	jalr	-1352(ra) # 80000c76 <release>
        havekids = 1;
    800021c6:	8756                	mv	a4,s5
    800021c8:	bfd9                	j	8000219e <wait+0xba>
    if(!havekids || p->killed){
    800021ca:	c701                	beqz	a4,800021d2 <wait+0xee>
    800021cc:	02892783          	lw	a5,40(s2)
    800021d0:	c79d                	beqz	a5,800021fe <wait+0x11a>
      release(&wait_lock);
    800021d2:	0000f517          	auipc	a0,0xf
    800021d6:	0e650513          	addi	a0,a0,230 # 800112b8 <wait_lock>
    800021da:	fffff097          	auipc	ra,0xfffff
    800021de:	a9c080e7          	jalr	-1380(ra) # 80000c76 <release>
      return -1;
    800021e2:	59fd                	li	s3,-1
}
    800021e4:	854e                	mv	a0,s3
    800021e6:	60a6                	ld	ra,72(sp)
    800021e8:	6406                	ld	s0,64(sp)
    800021ea:	74e2                	ld	s1,56(sp)
    800021ec:	7942                	ld	s2,48(sp)
    800021ee:	79a2                	ld	s3,40(sp)
    800021f0:	7a02                	ld	s4,32(sp)
    800021f2:	6ae2                	ld	s5,24(sp)
    800021f4:	6b42                	ld	s6,16(sp)
    800021f6:	6ba2                	ld	s7,8(sp)
    800021f8:	6c02                	ld	s8,0(sp)
    800021fa:	6161                	addi	sp,sp,80
    800021fc:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021fe:	85e2                	mv	a1,s8
    80002200:	854a                	mv	a0,s2
    80002202:	00000097          	auipc	ra,0x0
    80002206:	e7e080e7          	jalr	-386(ra) # 80002080 <sleep>
    havekids = 0;
    8000220a:	b715                	j	8000212e <wait+0x4a>

000000008000220c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000220c:	7139                	addi	sp,sp,-64
    8000220e:	fc06                	sd	ra,56(sp)
    80002210:	f822                	sd	s0,48(sp)
    80002212:	f426                	sd	s1,40(sp)
    80002214:	f04a                	sd	s2,32(sp)
    80002216:	ec4e                	sd	s3,24(sp)
    80002218:	e852                	sd	s4,16(sp)
    8000221a:	e456                	sd	s5,8(sp)
    8000221c:	0080                	addi	s0,sp,64
    8000221e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002220:	0000f497          	auipc	s1,0xf
    80002224:	4b048493          	addi	s1,s1,1200 # 800116d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002228:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000222a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000222c:	00015917          	auipc	s2,0x15
    80002230:	ea490913          	addi	s2,s2,-348 # 800170d0 <tickslock>
    80002234:	a811                	j	80002248 <wakeup+0x3c>
      }
      release(&p->lock);
    80002236:	8526                	mv	a0,s1
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	a3e080e7          	jalr	-1474(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002240:	16848493          	addi	s1,s1,360
    80002244:	03248663          	beq	s1,s2,80002270 <wakeup+0x64>
    if(p != myproc()){
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	778080e7          	jalr	1912(ra) # 800019c0 <myproc>
    80002250:	fea488e3          	beq	s1,a0,80002240 <wakeup+0x34>
      acquire(&p->lock);
    80002254:	8526                	mv	a0,s1
    80002256:	fffff097          	auipc	ra,0xfffff
    8000225a:	96c080e7          	jalr	-1684(ra) # 80000bc2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000225e:	4c9c                	lw	a5,24(s1)
    80002260:	fd379be3          	bne	a5,s3,80002236 <wakeup+0x2a>
    80002264:	709c                	ld	a5,32(s1)
    80002266:	fd4798e3          	bne	a5,s4,80002236 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000226a:	0154ac23          	sw	s5,24(s1)
    8000226e:	b7e1                	j	80002236 <wakeup+0x2a>
    }
  }
}
    80002270:	70e2                	ld	ra,56(sp)
    80002272:	7442                	ld	s0,48(sp)
    80002274:	74a2                	ld	s1,40(sp)
    80002276:	7902                	ld	s2,32(sp)
    80002278:	69e2                	ld	s3,24(sp)
    8000227a:	6a42                	ld	s4,16(sp)
    8000227c:	6aa2                	ld	s5,8(sp)
    8000227e:	6121                	addi	sp,sp,64
    80002280:	8082                	ret

0000000080002282 <reparent>:
{
    80002282:	7179                	addi	sp,sp,-48
    80002284:	f406                	sd	ra,40(sp)
    80002286:	f022                	sd	s0,32(sp)
    80002288:	ec26                	sd	s1,24(sp)
    8000228a:	e84a                	sd	s2,16(sp)
    8000228c:	e44e                	sd	s3,8(sp)
    8000228e:	e052                	sd	s4,0(sp)
    80002290:	1800                	addi	s0,sp,48
    80002292:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002294:	0000f497          	auipc	s1,0xf
    80002298:	43c48493          	addi	s1,s1,1084 # 800116d0 <proc>
      pp->parent = initproc;
    8000229c:	00007a17          	auipc	s4,0x7
    800022a0:	d8ca0a13          	addi	s4,s4,-628 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022a4:	00015997          	auipc	s3,0x15
    800022a8:	e2c98993          	addi	s3,s3,-468 # 800170d0 <tickslock>
    800022ac:	a029                	j	800022b6 <reparent+0x34>
    800022ae:	16848493          	addi	s1,s1,360
    800022b2:	01348d63          	beq	s1,s3,800022cc <reparent+0x4a>
    if(pp->parent == p){
    800022b6:	7c9c                	ld	a5,56(s1)
    800022b8:	ff279be3          	bne	a5,s2,800022ae <reparent+0x2c>
      pp->parent = initproc;
    800022bc:	000a3503          	ld	a0,0(s4)
    800022c0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800022c2:	00000097          	auipc	ra,0x0
    800022c6:	f4a080e7          	jalr	-182(ra) # 8000220c <wakeup>
    800022ca:	b7d5                	j	800022ae <reparent+0x2c>
}
    800022cc:	70a2                	ld	ra,40(sp)
    800022ce:	7402                	ld	s0,32(sp)
    800022d0:	64e2                	ld	s1,24(sp)
    800022d2:	6942                	ld	s2,16(sp)
    800022d4:	69a2                	ld	s3,8(sp)
    800022d6:	6a02                	ld	s4,0(sp)
    800022d8:	6145                	addi	sp,sp,48
    800022da:	8082                	ret

00000000800022dc <exit>:
{
    800022dc:	7179                	addi	sp,sp,-48
    800022de:	f406                	sd	ra,40(sp)
    800022e0:	f022                	sd	s0,32(sp)
    800022e2:	ec26                	sd	s1,24(sp)
    800022e4:	e84a                	sd	s2,16(sp)
    800022e6:	e44e                	sd	s3,8(sp)
    800022e8:	e052                	sd	s4,0(sp)
    800022ea:	1800                	addi	s0,sp,48
    800022ec:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	6d2080e7          	jalr	1746(ra) # 800019c0 <myproc>
    800022f6:	89aa                	mv	s3,a0
  if(p == initproc)
    800022f8:	00007797          	auipc	a5,0x7
    800022fc:	d307b783          	ld	a5,-720(a5) # 80009028 <initproc>
    80002300:	0d050493          	addi	s1,a0,208
    80002304:	15050913          	addi	s2,a0,336
    80002308:	02a79363          	bne	a5,a0,8000232e <exit+0x52>
    panic("init exiting");
    8000230c:	00006517          	auipc	a0,0x6
    80002310:	f3c50513          	addi	a0,a0,-196 # 80008248 <digits+0x208>
    80002314:	ffffe097          	auipc	ra,0xffffe
    80002318:	216080e7          	jalr	534(ra) # 8000052a <panic>
      fileclose(f);
    8000231c:	00002097          	auipc	ra,0x2
    80002320:	4c6080e7          	jalr	1222(ra) # 800047e2 <fileclose>
      p->ofile[fd] = 0;
    80002324:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002328:	04a1                	addi	s1,s1,8
    8000232a:	01248563          	beq	s1,s2,80002334 <exit+0x58>
    if(p->ofile[fd]){
    8000232e:	6088                	ld	a0,0(s1)
    80002330:	f575                	bnez	a0,8000231c <exit+0x40>
    80002332:	bfdd                	j	80002328 <exit+0x4c>
  begin_op();
    80002334:	00002097          	auipc	ra,0x2
    80002338:	fe2080e7          	jalr	-30(ra) # 80004316 <begin_op>
  iput(p->cwd);
    8000233c:	1509b503          	ld	a0,336(s3)
    80002340:	00001097          	auipc	ra,0x1
    80002344:	6f4080e7          	jalr	1780(ra) # 80003a34 <iput>
  end_op();
    80002348:	00002097          	auipc	ra,0x2
    8000234c:	04e080e7          	jalr	78(ra) # 80004396 <end_op>
  p->cwd = 0;
    80002350:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002354:	0000f497          	auipc	s1,0xf
    80002358:	f6448493          	addi	s1,s1,-156 # 800112b8 <wait_lock>
    8000235c:	8526                	mv	a0,s1
    8000235e:	fffff097          	auipc	ra,0xfffff
    80002362:	864080e7          	jalr	-1948(ra) # 80000bc2 <acquire>
  reparent(p);
    80002366:	854e                	mv	a0,s3
    80002368:	00000097          	auipc	ra,0x0
    8000236c:	f1a080e7          	jalr	-230(ra) # 80002282 <reparent>
  wakeup(p->parent);
    80002370:	0389b503          	ld	a0,56(s3)
    80002374:	00000097          	auipc	ra,0x0
    80002378:	e98080e7          	jalr	-360(ra) # 8000220c <wakeup>
  acquire(&p->lock);
    8000237c:	854e                	mv	a0,s3
    8000237e:	fffff097          	auipc	ra,0xfffff
    80002382:	844080e7          	jalr	-1980(ra) # 80000bc2 <acquire>
  p->xstate = status;
    80002386:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000238a:	4795                	li	a5,5
    8000238c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002390:	8526                	mv	a0,s1
    80002392:	fffff097          	auipc	ra,0xfffff
    80002396:	8e4080e7          	jalr	-1820(ra) # 80000c76 <release>
  sched();
    8000239a:	00000097          	auipc	ra,0x0
    8000239e:	bd4080e7          	jalr	-1068(ra) # 80001f6e <sched>
  panic("zombie exit");
    800023a2:	00006517          	auipc	a0,0x6
    800023a6:	eb650513          	addi	a0,a0,-330 # 80008258 <digits+0x218>
    800023aa:	ffffe097          	auipc	ra,0xffffe
    800023ae:	180080e7          	jalr	384(ra) # 8000052a <panic>

00000000800023b2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023b2:	7179                	addi	sp,sp,-48
    800023b4:	f406                	sd	ra,40(sp)
    800023b6:	f022                	sd	s0,32(sp)
    800023b8:	ec26                	sd	s1,24(sp)
    800023ba:	e84a                	sd	s2,16(sp)
    800023bc:	e44e                	sd	s3,8(sp)
    800023be:	1800                	addi	s0,sp,48
    800023c0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023c2:	0000f497          	auipc	s1,0xf
    800023c6:	30e48493          	addi	s1,s1,782 # 800116d0 <proc>
    800023ca:	00015997          	auipc	s3,0x15
    800023ce:	d0698993          	addi	s3,s3,-762 # 800170d0 <tickslock>
    acquire(&p->lock);
    800023d2:	8526                	mv	a0,s1
    800023d4:	ffffe097          	auipc	ra,0xffffe
    800023d8:	7ee080e7          	jalr	2030(ra) # 80000bc2 <acquire>
    if(p->pid == pid){
    800023dc:	589c                	lw	a5,48(s1)
    800023de:	01278d63          	beq	a5,s2,800023f8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023e2:	8526                	mv	a0,s1
    800023e4:	fffff097          	auipc	ra,0xfffff
    800023e8:	892080e7          	jalr	-1902(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800023ec:	16848493          	addi	s1,s1,360
    800023f0:	ff3491e3          	bne	s1,s3,800023d2 <kill+0x20>
  }
  return -1;
    800023f4:	557d                	li	a0,-1
    800023f6:	a829                	j	80002410 <kill+0x5e>
      p->killed = 1;
    800023f8:	4785                	li	a5,1
    800023fa:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800023fc:	4c98                	lw	a4,24(s1)
    800023fe:	4789                	li	a5,2
    80002400:	00f70f63          	beq	a4,a5,8000241e <kill+0x6c>
      release(&p->lock);
    80002404:	8526                	mv	a0,s1
    80002406:	fffff097          	auipc	ra,0xfffff
    8000240a:	870080e7          	jalr	-1936(ra) # 80000c76 <release>
      return 0;
    8000240e:	4501                	li	a0,0
}
    80002410:	70a2                	ld	ra,40(sp)
    80002412:	7402                	ld	s0,32(sp)
    80002414:	64e2                	ld	s1,24(sp)
    80002416:	6942                	ld	s2,16(sp)
    80002418:	69a2                	ld	s3,8(sp)
    8000241a:	6145                	addi	sp,sp,48
    8000241c:	8082                	ret
        p->state = RUNNABLE;
    8000241e:	478d                	li	a5,3
    80002420:	cc9c                	sw	a5,24(s1)
    80002422:	b7cd                	j	80002404 <kill+0x52>

0000000080002424 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002424:	7179                	addi	sp,sp,-48
    80002426:	f406                	sd	ra,40(sp)
    80002428:	f022                	sd	s0,32(sp)
    8000242a:	ec26                	sd	s1,24(sp)
    8000242c:	e84a                	sd	s2,16(sp)
    8000242e:	e44e                	sd	s3,8(sp)
    80002430:	e052                	sd	s4,0(sp)
    80002432:	1800                	addi	s0,sp,48
    80002434:	84aa                	mv	s1,a0
    80002436:	892e                	mv	s2,a1
    80002438:	89b2                	mv	s3,a2
    8000243a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000243c:	fffff097          	auipc	ra,0xfffff
    80002440:	584080e7          	jalr	1412(ra) # 800019c0 <myproc>
  if(user_dst){
    80002444:	c08d                	beqz	s1,80002466 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002446:	86d2                	mv	a3,s4
    80002448:	864e                	mv	a2,s3
    8000244a:	85ca                	mv	a1,s2
    8000244c:	6928                	ld	a0,80(a0)
    8000244e:	fffff097          	auipc	ra,0xfffff
    80002452:	232080e7          	jalr	562(ra) # 80001680 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002456:	70a2                	ld	ra,40(sp)
    80002458:	7402                	ld	s0,32(sp)
    8000245a:	64e2                	ld	s1,24(sp)
    8000245c:	6942                	ld	s2,16(sp)
    8000245e:	69a2                	ld	s3,8(sp)
    80002460:	6a02                	ld	s4,0(sp)
    80002462:	6145                	addi	sp,sp,48
    80002464:	8082                	ret
    memmove((char *)dst, src, len);
    80002466:	000a061b          	sext.w	a2,s4
    8000246a:	85ce                	mv	a1,s3
    8000246c:	854a                	mv	a0,s2
    8000246e:	fffff097          	auipc	ra,0xfffff
    80002472:	8ac080e7          	jalr	-1876(ra) # 80000d1a <memmove>
    return 0;
    80002476:	8526                	mv	a0,s1
    80002478:	bff9                	j	80002456 <either_copyout+0x32>

000000008000247a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000247a:	7179                	addi	sp,sp,-48
    8000247c:	f406                	sd	ra,40(sp)
    8000247e:	f022                	sd	s0,32(sp)
    80002480:	ec26                	sd	s1,24(sp)
    80002482:	e84a                	sd	s2,16(sp)
    80002484:	e44e                	sd	s3,8(sp)
    80002486:	e052                	sd	s4,0(sp)
    80002488:	1800                	addi	s0,sp,48
    8000248a:	892a                	mv	s2,a0
    8000248c:	84ae                	mv	s1,a1
    8000248e:	89b2                	mv	s3,a2
    80002490:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002492:	fffff097          	auipc	ra,0xfffff
    80002496:	52e080e7          	jalr	1326(ra) # 800019c0 <myproc>
  if(user_src){
    8000249a:	c08d                	beqz	s1,800024bc <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000249c:	86d2                	mv	a3,s4
    8000249e:	864e                	mv	a2,s3
    800024a0:	85ca                	mv	a1,s2
    800024a2:	6928                	ld	a0,80(a0)
    800024a4:	fffff097          	auipc	ra,0xfffff
    800024a8:	268080e7          	jalr	616(ra) # 8000170c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024ac:	70a2                	ld	ra,40(sp)
    800024ae:	7402                	ld	s0,32(sp)
    800024b0:	64e2                	ld	s1,24(sp)
    800024b2:	6942                	ld	s2,16(sp)
    800024b4:	69a2                	ld	s3,8(sp)
    800024b6:	6a02                	ld	s4,0(sp)
    800024b8:	6145                	addi	sp,sp,48
    800024ba:	8082                	ret
    memmove(dst, (char*)src, len);
    800024bc:	000a061b          	sext.w	a2,s4
    800024c0:	85ce                	mv	a1,s3
    800024c2:	854a                	mv	a0,s2
    800024c4:	fffff097          	auipc	ra,0xfffff
    800024c8:	856080e7          	jalr	-1962(ra) # 80000d1a <memmove>
    return 0;
    800024cc:	8526                	mv	a0,s1
    800024ce:	bff9                	j	800024ac <either_copyin+0x32>

00000000800024d0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800024d0:	715d                	addi	sp,sp,-80
    800024d2:	e486                	sd	ra,72(sp)
    800024d4:	e0a2                	sd	s0,64(sp)
    800024d6:	fc26                	sd	s1,56(sp)
    800024d8:	f84a                	sd	s2,48(sp)
    800024da:	f44e                	sd	s3,40(sp)
    800024dc:	f052                	sd	s4,32(sp)
    800024de:	ec56                	sd	s5,24(sp)
    800024e0:	e85a                	sd	s6,16(sp)
    800024e2:	e45e                	sd	s7,8(sp)
    800024e4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800024e6:	00006517          	auipc	a0,0x6
    800024ea:	be250513          	addi	a0,a0,-1054 # 800080c8 <digits+0x88>
    800024ee:	ffffe097          	auipc	ra,0xffffe
    800024f2:	086080e7          	jalr	134(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800024f6:	0000f497          	auipc	s1,0xf
    800024fa:	33248493          	addi	s1,s1,818 # 80011828 <proc+0x158>
    800024fe:	00015917          	auipc	s2,0x15
    80002502:	d2a90913          	addi	s2,s2,-726 # 80017228 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002506:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002508:	00006997          	auipc	s3,0x6
    8000250c:	d6098993          	addi	s3,s3,-672 # 80008268 <digits+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80002510:	00006a97          	auipc	s5,0x6
    80002514:	d60a8a93          	addi	s5,s5,-672 # 80008270 <digits+0x230>
    printf("\n");
    80002518:	00006a17          	auipc	s4,0x6
    8000251c:	bb0a0a13          	addi	s4,s4,-1104 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002520:	00006b97          	auipc	s7,0x6
    80002524:	d88b8b93          	addi	s7,s7,-632 # 800082a8 <states.0>
    80002528:	a00d                	j	8000254a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000252a:	ed86a583          	lw	a1,-296(a3)
    8000252e:	8556                	mv	a0,s5
    80002530:	ffffe097          	auipc	ra,0xffffe
    80002534:	044080e7          	jalr	68(ra) # 80000574 <printf>
    printf("\n");
    80002538:	8552                	mv	a0,s4
    8000253a:	ffffe097          	auipc	ra,0xffffe
    8000253e:	03a080e7          	jalr	58(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002542:	16848493          	addi	s1,s1,360
    80002546:	03248163          	beq	s1,s2,80002568 <procdump+0x98>
    if(p->state == UNUSED)
    8000254a:	86a6                	mv	a3,s1
    8000254c:	ec04a783          	lw	a5,-320(s1)
    80002550:	dbed                	beqz	a5,80002542 <procdump+0x72>
      state = "???";
    80002552:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002554:	fcfb6be3          	bltu	s6,a5,8000252a <procdump+0x5a>
    80002558:	1782                	slli	a5,a5,0x20
    8000255a:	9381                	srli	a5,a5,0x20
    8000255c:	078e                	slli	a5,a5,0x3
    8000255e:	97de                	add	a5,a5,s7
    80002560:	6390                	ld	a2,0(a5)
    80002562:	f661                	bnez	a2,8000252a <procdump+0x5a>
      state = "???";
    80002564:	864e                	mv	a2,s3
    80002566:	b7d1                	j	8000252a <procdump+0x5a>
  }
}
    80002568:	60a6                	ld	ra,72(sp)
    8000256a:	6406                	ld	s0,64(sp)
    8000256c:	74e2                	ld	s1,56(sp)
    8000256e:	7942                	ld	s2,48(sp)
    80002570:	79a2                	ld	s3,40(sp)
    80002572:	7a02                	ld	s4,32(sp)
    80002574:	6ae2                	ld	s5,24(sp)
    80002576:	6b42                	ld	s6,16(sp)
    80002578:	6ba2                	ld	s7,8(sp)
    8000257a:	6161                	addi	sp,sp,80
    8000257c:	8082                	ret

000000008000257e <swtch>:
    8000257e:	00153023          	sd	ra,0(a0)
    80002582:	00253423          	sd	sp,8(a0)
    80002586:	e900                	sd	s0,16(a0)
    80002588:	ed04                	sd	s1,24(a0)
    8000258a:	03253023          	sd	s2,32(a0)
    8000258e:	03353423          	sd	s3,40(a0)
    80002592:	03453823          	sd	s4,48(a0)
    80002596:	03553c23          	sd	s5,56(a0)
    8000259a:	05653023          	sd	s6,64(a0)
    8000259e:	05753423          	sd	s7,72(a0)
    800025a2:	05853823          	sd	s8,80(a0)
    800025a6:	05953c23          	sd	s9,88(a0)
    800025aa:	07a53023          	sd	s10,96(a0)
    800025ae:	07b53423          	sd	s11,104(a0)
    800025b2:	0005b083          	ld	ra,0(a1)
    800025b6:	0085b103          	ld	sp,8(a1)
    800025ba:	6980                	ld	s0,16(a1)
    800025bc:	6d84                	ld	s1,24(a1)
    800025be:	0205b903          	ld	s2,32(a1)
    800025c2:	0285b983          	ld	s3,40(a1)
    800025c6:	0305ba03          	ld	s4,48(a1)
    800025ca:	0385ba83          	ld	s5,56(a1)
    800025ce:	0405bb03          	ld	s6,64(a1)
    800025d2:	0485bb83          	ld	s7,72(a1)
    800025d6:	0505bc03          	ld	s8,80(a1)
    800025da:	0585bc83          	ld	s9,88(a1)
    800025de:	0605bd03          	ld	s10,96(a1)
    800025e2:	0685bd83          	ld	s11,104(a1)
    800025e6:	8082                	ret

00000000800025e8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800025e8:	1141                	addi	sp,sp,-16
    800025ea:	e406                	sd	ra,8(sp)
    800025ec:	e022                	sd	s0,0(sp)
    800025ee:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800025f0:	00006597          	auipc	a1,0x6
    800025f4:	ce858593          	addi	a1,a1,-792 # 800082d8 <states.0+0x30>
    800025f8:	00015517          	auipc	a0,0x15
    800025fc:	ad850513          	addi	a0,a0,-1320 # 800170d0 <tickslock>
    80002600:	ffffe097          	auipc	ra,0xffffe
    80002604:	532080e7          	jalr	1330(ra) # 80000b32 <initlock>
}
    80002608:	60a2                	ld	ra,8(sp)
    8000260a:	6402                	ld	s0,0(sp)
    8000260c:	0141                	addi	sp,sp,16
    8000260e:	8082                	ret

0000000080002610 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002610:	1141                	addi	sp,sp,-16
    80002612:	e422                	sd	s0,8(sp)
    80002614:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002616:	00004797          	auipc	a5,0x4
    8000261a:	94a78793          	addi	a5,a5,-1718 # 80005f60 <kernelvec>
    8000261e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002622:	6422                	ld	s0,8(sp)
    80002624:	0141                	addi	sp,sp,16
    80002626:	8082                	ret

0000000080002628 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002628:	1141                	addi	sp,sp,-16
    8000262a:	e406                	sd	ra,8(sp)
    8000262c:	e022                	sd	s0,0(sp)
    8000262e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002630:	fffff097          	auipc	ra,0xfffff
    80002634:	390080e7          	jalr	912(ra) # 800019c0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002638:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000263c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000263e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002642:	00005617          	auipc	a2,0x5
    80002646:	9be60613          	addi	a2,a2,-1602 # 80007000 <_trampoline>
    8000264a:	00005697          	auipc	a3,0x5
    8000264e:	9b668693          	addi	a3,a3,-1610 # 80007000 <_trampoline>
    80002652:	8e91                	sub	a3,a3,a2
    80002654:	040007b7          	lui	a5,0x4000
    80002658:	17fd                	addi	a5,a5,-1
    8000265a:	07b2                	slli	a5,a5,0xc
    8000265c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000265e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002662:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002664:	180026f3          	csrr	a3,satp
    80002668:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000266a:	6d38                	ld	a4,88(a0)
    8000266c:	6134                	ld	a3,64(a0)
    8000266e:	6585                	lui	a1,0x1
    80002670:	96ae                	add	a3,a3,a1
    80002672:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002674:	6d38                	ld	a4,88(a0)
    80002676:	00000697          	auipc	a3,0x0
    8000267a:	13868693          	addi	a3,a3,312 # 800027ae <usertrap>
    8000267e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002680:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002682:	8692                	mv	a3,tp
    80002684:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002686:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000268a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000268e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002692:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002696:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002698:	6f18                	ld	a4,24(a4)
    8000269a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000269e:	692c                	ld	a1,80(a0)
    800026a0:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800026a2:	00005717          	auipc	a4,0x5
    800026a6:	9ee70713          	addi	a4,a4,-1554 # 80007090 <userret>
    800026aa:	8f11                	sub	a4,a4,a2
    800026ac:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800026ae:	577d                	li	a4,-1
    800026b0:	177e                	slli	a4,a4,0x3f
    800026b2:	8dd9                	or	a1,a1,a4
    800026b4:	02000537          	lui	a0,0x2000
    800026b8:	157d                	addi	a0,a0,-1
    800026ba:	0536                	slli	a0,a0,0xd
    800026bc:	9782                	jalr	a5
}
    800026be:	60a2                	ld	ra,8(sp)
    800026c0:	6402                	ld	s0,0(sp)
    800026c2:	0141                	addi	sp,sp,16
    800026c4:	8082                	ret

00000000800026c6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026c6:	1101                	addi	sp,sp,-32
    800026c8:	ec06                	sd	ra,24(sp)
    800026ca:	e822                	sd	s0,16(sp)
    800026cc:	e426                	sd	s1,8(sp)
    800026ce:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800026d0:	00015497          	auipc	s1,0x15
    800026d4:	a0048493          	addi	s1,s1,-1536 # 800170d0 <tickslock>
    800026d8:	8526                	mv	a0,s1
    800026da:	ffffe097          	auipc	ra,0xffffe
    800026de:	4e8080e7          	jalr	1256(ra) # 80000bc2 <acquire>
  ticks++;
    800026e2:	00007517          	auipc	a0,0x7
    800026e6:	94e50513          	addi	a0,a0,-1714 # 80009030 <ticks>
    800026ea:	411c                	lw	a5,0(a0)
    800026ec:	2785                	addiw	a5,a5,1
    800026ee:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800026f0:	00000097          	auipc	ra,0x0
    800026f4:	b1c080e7          	jalr	-1252(ra) # 8000220c <wakeup>
  release(&tickslock);
    800026f8:	8526                	mv	a0,s1
    800026fa:	ffffe097          	auipc	ra,0xffffe
    800026fe:	57c080e7          	jalr	1404(ra) # 80000c76 <release>
}
    80002702:	60e2                	ld	ra,24(sp)
    80002704:	6442                	ld	s0,16(sp)
    80002706:	64a2                	ld	s1,8(sp)
    80002708:	6105                	addi	sp,sp,32
    8000270a:	8082                	ret

000000008000270c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000270c:	1101                	addi	sp,sp,-32
    8000270e:	ec06                	sd	ra,24(sp)
    80002710:	e822                	sd	s0,16(sp)
    80002712:	e426                	sd	s1,8(sp)
    80002714:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002716:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000271a:	00074d63          	bltz	a4,80002734 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    8000271e:	57fd                	li	a5,-1
    80002720:	17fe                	slli	a5,a5,0x3f
    80002722:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002724:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002726:	06f70363          	beq	a4,a5,8000278c <devintr+0x80>
  }
}
    8000272a:	60e2                	ld	ra,24(sp)
    8000272c:	6442                	ld	s0,16(sp)
    8000272e:	64a2                	ld	s1,8(sp)
    80002730:	6105                	addi	sp,sp,32
    80002732:	8082                	ret
     (scause & 0xff) == 9){
    80002734:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002738:	46a5                	li	a3,9
    8000273a:	fed792e3          	bne	a5,a3,8000271e <devintr+0x12>
    int irq = plic_claim();
    8000273e:	00004097          	auipc	ra,0x4
    80002742:	92a080e7          	jalr	-1750(ra) # 80006068 <plic_claim>
    80002746:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002748:	47a9                	li	a5,10
    8000274a:	02f50763          	beq	a0,a5,80002778 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    8000274e:	4785                	li	a5,1
    80002750:	02f50963          	beq	a0,a5,80002782 <devintr+0x76>
    return 1;
    80002754:	4505                	li	a0,1
    } else if(irq){
    80002756:	d8f1                	beqz	s1,8000272a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002758:	85a6                	mv	a1,s1
    8000275a:	00006517          	auipc	a0,0x6
    8000275e:	b8650513          	addi	a0,a0,-1146 # 800082e0 <states.0+0x38>
    80002762:	ffffe097          	auipc	ra,0xffffe
    80002766:	e12080e7          	jalr	-494(ra) # 80000574 <printf>
      plic_complete(irq);
    8000276a:	8526                	mv	a0,s1
    8000276c:	00004097          	auipc	ra,0x4
    80002770:	920080e7          	jalr	-1760(ra) # 8000608c <plic_complete>
    return 1;
    80002774:	4505                	li	a0,1
    80002776:	bf55                	j	8000272a <devintr+0x1e>
      uartintr();
    80002778:	ffffe097          	auipc	ra,0xffffe
    8000277c:	20e080e7          	jalr	526(ra) # 80000986 <uartintr>
    80002780:	b7ed                	j	8000276a <devintr+0x5e>
      virtio_disk_intr();
    80002782:	00004097          	auipc	ra,0x4
    80002786:	d9c080e7          	jalr	-612(ra) # 8000651e <virtio_disk_intr>
    8000278a:	b7c5                	j	8000276a <devintr+0x5e>
    if(cpuid() == 0){
    8000278c:	fffff097          	auipc	ra,0xfffff
    80002790:	208080e7          	jalr	520(ra) # 80001994 <cpuid>
    80002794:	c901                	beqz	a0,800027a4 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002796:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000279a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000279c:	14479073          	csrw	sip,a5
    return 2;
    800027a0:	4509                	li	a0,2
    800027a2:	b761                	j	8000272a <devintr+0x1e>
      clockintr();
    800027a4:	00000097          	auipc	ra,0x0
    800027a8:	f22080e7          	jalr	-222(ra) # 800026c6 <clockintr>
    800027ac:	b7ed                	j	80002796 <devintr+0x8a>

00000000800027ae <usertrap>:
{
    800027ae:	1101                	addi	sp,sp,-32
    800027b0:	ec06                	sd	ra,24(sp)
    800027b2:	e822                	sd	s0,16(sp)
    800027b4:	e426                	sd	s1,8(sp)
    800027b6:	e04a                	sd	s2,0(sp)
    800027b8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ba:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027be:	1007f793          	andi	a5,a5,256
    800027c2:	e3ad                	bnez	a5,80002824 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027c4:	00003797          	auipc	a5,0x3
    800027c8:	79c78793          	addi	a5,a5,1948 # 80005f60 <kernelvec>
    800027cc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027d0:	fffff097          	auipc	ra,0xfffff
    800027d4:	1f0080e7          	jalr	496(ra) # 800019c0 <myproc>
    800027d8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800027da:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027dc:	14102773          	csrr	a4,sepc
    800027e0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027e2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800027e6:	47a1                	li	a5,8
    800027e8:	04f71c63          	bne	a4,a5,80002840 <usertrap+0x92>
    if(p->killed)
    800027ec:	551c                	lw	a5,40(a0)
    800027ee:	e3b9                	bnez	a5,80002834 <usertrap+0x86>
    p->trapframe->epc += 4;
    800027f0:	6cb8                	ld	a4,88(s1)
    800027f2:	6f1c                	ld	a5,24(a4)
    800027f4:	0791                	addi	a5,a5,4
    800027f6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800027fc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002800:	10079073          	csrw	sstatus,a5
    syscall();
    80002804:	00000097          	auipc	ra,0x0
    80002808:	2e0080e7          	jalr	736(ra) # 80002ae4 <syscall>
  if(p->killed)
    8000280c:	549c                	lw	a5,40(s1)
    8000280e:	ebc1                	bnez	a5,8000289e <usertrap+0xf0>
  usertrapret();
    80002810:	00000097          	auipc	ra,0x0
    80002814:	e18080e7          	jalr	-488(ra) # 80002628 <usertrapret>
}
    80002818:	60e2                	ld	ra,24(sp)
    8000281a:	6442                	ld	s0,16(sp)
    8000281c:	64a2                	ld	s1,8(sp)
    8000281e:	6902                	ld	s2,0(sp)
    80002820:	6105                	addi	sp,sp,32
    80002822:	8082                	ret
    panic("usertrap: not from user mode");
    80002824:	00006517          	auipc	a0,0x6
    80002828:	adc50513          	addi	a0,a0,-1316 # 80008300 <states.0+0x58>
    8000282c:	ffffe097          	auipc	ra,0xffffe
    80002830:	cfe080e7          	jalr	-770(ra) # 8000052a <panic>
      exit(-1);
    80002834:	557d                	li	a0,-1
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	aa6080e7          	jalr	-1370(ra) # 800022dc <exit>
    8000283e:	bf4d                	j	800027f0 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002840:	00000097          	auipc	ra,0x0
    80002844:	ecc080e7          	jalr	-308(ra) # 8000270c <devintr>
    80002848:	892a                	mv	s2,a0
    8000284a:	c501                	beqz	a0,80002852 <usertrap+0xa4>
  if(p->killed)
    8000284c:	549c                	lw	a5,40(s1)
    8000284e:	c3a1                	beqz	a5,8000288e <usertrap+0xe0>
    80002850:	a815                	j	80002884 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002852:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002856:	5890                	lw	a2,48(s1)
    80002858:	00006517          	auipc	a0,0x6
    8000285c:	ac850513          	addi	a0,a0,-1336 # 80008320 <states.0+0x78>
    80002860:	ffffe097          	auipc	ra,0xffffe
    80002864:	d14080e7          	jalr	-748(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002868:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000286c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002870:	00006517          	auipc	a0,0x6
    80002874:	ae050513          	addi	a0,a0,-1312 # 80008350 <states.0+0xa8>
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	cfc080e7          	jalr	-772(ra) # 80000574 <printf>
    p->killed = 1;
    80002880:	4785                	li	a5,1
    80002882:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002884:	557d                	li	a0,-1
    80002886:	00000097          	auipc	ra,0x0
    8000288a:	a56080e7          	jalr	-1450(ra) # 800022dc <exit>
  if(which_dev == 2)
    8000288e:	4789                	li	a5,2
    80002890:	f8f910e3          	bne	s2,a5,80002810 <usertrap+0x62>
    yield();
    80002894:	fffff097          	auipc	ra,0xfffff
    80002898:	7b0080e7          	jalr	1968(ra) # 80002044 <yield>
    8000289c:	bf95                	j	80002810 <usertrap+0x62>
  int which_dev = 0;
    8000289e:	4901                	li	s2,0
    800028a0:	b7d5                	j	80002884 <usertrap+0xd6>

00000000800028a2 <kerneltrap>:
{
    800028a2:	7179                	addi	sp,sp,-48
    800028a4:	f406                	sd	ra,40(sp)
    800028a6:	f022                	sd	s0,32(sp)
    800028a8:	ec26                	sd	s1,24(sp)
    800028aa:	e84a                	sd	s2,16(sp)
    800028ac:	e44e                	sd	s3,8(sp)
    800028ae:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028b0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028b4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028b8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800028bc:	1004f793          	andi	a5,s1,256
    800028c0:	cb85                	beqz	a5,800028f0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028c2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800028c6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800028c8:	ef85                	bnez	a5,80002900 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800028ca:	00000097          	auipc	ra,0x0
    800028ce:	e42080e7          	jalr	-446(ra) # 8000270c <devintr>
    800028d2:	cd1d                	beqz	a0,80002910 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800028d4:	4789                	li	a5,2
    800028d6:	06f50a63          	beq	a0,a5,8000294a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028da:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028de:	10049073          	csrw	sstatus,s1
}
    800028e2:	70a2                	ld	ra,40(sp)
    800028e4:	7402                	ld	s0,32(sp)
    800028e6:	64e2                	ld	s1,24(sp)
    800028e8:	6942                	ld	s2,16(sp)
    800028ea:	69a2                	ld	s3,8(sp)
    800028ec:	6145                	addi	sp,sp,48
    800028ee:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800028f0:	00006517          	auipc	a0,0x6
    800028f4:	a8050513          	addi	a0,a0,-1408 # 80008370 <states.0+0xc8>
    800028f8:	ffffe097          	auipc	ra,0xffffe
    800028fc:	c32080e7          	jalr	-974(ra) # 8000052a <panic>
    panic("kerneltrap: interrupts enabled");
    80002900:	00006517          	auipc	a0,0x6
    80002904:	a9850513          	addi	a0,a0,-1384 # 80008398 <states.0+0xf0>
    80002908:	ffffe097          	auipc	ra,0xffffe
    8000290c:	c22080e7          	jalr	-990(ra) # 8000052a <panic>
    printf("scause %p\n", scause);
    80002910:	85ce                	mv	a1,s3
    80002912:	00006517          	auipc	a0,0x6
    80002916:	aa650513          	addi	a0,a0,-1370 # 800083b8 <states.0+0x110>
    8000291a:	ffffe097          	auipc	ra,0xffffe
    8000291e:	c5a080e7          	jalr	-934(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002922:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002926:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000292a:	00006517          	auipc	a0,0x6
    8000292e:	a9e50513          	addi	a0,a0,-1378 # 800083c8 <states.0+0x120>
    80002932:	ffffe097          	auipc	ra,0xffffe
    80002936:	c42080e7          	jalr	-958(ra) # 80000574 <printf>
    panic("kerneltrap");
    8000293a:	00006517          	auipc	a0,0x6
    8000293e:	aa650513          	addi	a0,a0,-1370 # 800083e0 <states.0+0x138>
    80002942:	ffffe097          	auipc	ra,0xffffe
    80002946:	be8080e7          	jalr	-1048(ra) # 8000052a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000294a:	fffff097          	auipc	ra,0xfffff
    8000294e:	076080e7          	jalr	118(ra) # 800019c0 <myproc>
    80002952:	d541                	beqz	a0,800028da <kerneltrap+0x38>
    80002954:	fffff097          	auipc	ra,0xfffff
    80002958:	06c080e7          	jalr	108(ra) # 800019c0 <myproc>
    8000295c:	4d18                	lw	a4,24(a0)
    8000295e:	4791                	li	a5,4
    80002960:	f6f71de3          	bne	a4,a5,800028da <kerneltrap+0x38>
    yield();
    80002964:	fffff097          	auipc	ra,0xfffff
    80002968:	6e0080e7          	jalr	1760(ra) # 80002044 <yield>
    8000296c:	b7bd                	j	800028da <kerneltrap+0x38>

000000008000296e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000296e:	1101                	addi	sp,sp,-32
    80002970:	ec06                	sd	ra,24(sp)
    80002972:	e822                	sd	s0,16(sp)
    80002974:	e426                	sd	s1,8(sp)
    80002976:	1000                	addi	s0,sp,32
    80002978:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000297a:	fffff097          	auipc	ra,0xfffff
    8000297e:	046080e7          	jalr	70(ra) # 800019c0 <myproc>
  switch (n) {
    80002982:	4795                	li	a5,5
    80002984:	0497e163          	bltu	a5,s1,800029c6 <argraw+0x58>
    80002988:	048a                	slli	s1,s1,0x2
    8000298a:	00006717          	auipc	a4,0x6
    8000298e:	a8e70713          	addi	a4,a4,-1394 # 80008418 <states.0+0x170>
    80002992:	94ba                	add	s1,s1,a4
    80002994:	409c                	lw	a5,0(s1)
    80002996:	97ba                	add	a5,a5,a4
    80002998:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000299a:	6d3c                	ld	a5,88(a0)
    8000299c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000299e:	60e2                	ld	ra,24(sp)
    800029a0:	6442                	ld	s0,16(sp)
    800029a2:	64a2                	ld	s1,8(sp)
    800029a4:	6105                	addi	sp,sp,32
    800029a6:	8082                	ret
    return p->trapframe->a1;
    800029a8:	6d3c                	ld	a5,88(a0)
    800029aa:	7fa8                	ld	a0,120(a5)
    800029ac:	bfcd                	j	8000299e <argraw+0x30>
    return p->trapframe->a2;
    800029ae:	6d3c                	ld	a5,88(a0)
    800029b0:	63c8                	ld	a0,128(a5)
    800029b2:	b7f5                	j	8000299e <argraw+0x30>
    return p->trapframe->a3;
    800029b4:	6d3c                	ld	a5,88(a0)
    800029b6:	67c8                	ld	a0,136(a5)
    800029b8:	b7dd                	j	8000299e <argraw+0x30>
    return p->trapframe->a4;
    800029ba:	6d3c                	ld	a5,88(a0)
    800029bc:	6bc8                	ld	a0,144(a5)
    800029be:	b7c5                	j	8000299e <argraw+0x30>
    return p->trapframe->a5;
    800029c0:	6d3c                	ld	a5,88(a0)
    800029c2:	6fc8                	ld	a0,152(a5)
    800029c4:	bfe9                	j	8000299e <argraw+0x30>
  panic("argraw");
    800029c6:	00006517          	auipc	a0,0x6
    800029ca:	a2a50513          	addi	a0,a0,-1494 # 800083f0 <states.0+0x148>
    800029ce:	ffffe097          	auipc	ra,0xffffe
    800029d2:	b5c080e7          	jalr	-1188(ra) # 8000052a <panic>

00000000800029d6 <fetchaddr>:
{
    800029d6:	1101                	addi	sp,sp,-32
    800029d8:	ec06                	sd	ra,24(sp)
    800029da:	e822                	sd	s0,16(sp)
    800029dc:	e426                	sd	s1,8(sp)
    800029de:	e04a                	sd	s2,0(sp)
    800029e0:	1000                	addi	s0,sp,32
    800029e2:	84aa                	mv	s1,a0
    800029e4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800029e6:	fffff097          	auipc	ra,0xfffff
    800029ea:	fda080e7          	jalr	-38(ra) # 800019c0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800029ee:	653c                	ld	a5,72(a0)
    800029f0:	02f4f863          	bgeu	s1,a5,80002a20 <fetchaddr+0x4a>
    800029f4:	00848713          	addi	a4,s1,8
    800029f8:	02e7e663          	bltu	a5,a4,80002a24 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800029fc:	46a1                	li	a3,8
    800029fe:	8626                	mv	a2,s1
    80002a00:	85ca                	mv	a1,s2
    80002a02:	6928                	ld	a0,80(a0)
    80002a04:	fffff097          	auipc	ra,0xfffff
    80002a08:	d08080e7          	jalr	-760(ra) # 8000170c <copyin>
    80002a0c:	00a03533          	snez	a0,a0
    80002a10:	40a00533          	neg	a0,a0
}
    80002a14:	60e2                	ld	ra,24(sp)
    80002a16:	6442                	ld	s0,16(sp)
    80002a18:	64a2                	ld	s1,8(sp)
    80002a1a:	6902                	ld	s2,0(sp)
    80002a1c:	6105                	addi	sp,sp,32
    80002a1e:	8082                	ret
    return -1;
    80002a20:	557d                	li	a0,-1
    80002a22:	bfcd                	j	80002a14 <fetchaddr+0x3e>
    80002a24:	557d                	li	a0,-1
    80002a26:	b7fd                	j	80002a14 <fetchaddr+0x3e>

0000000080002a28 <fetchstr>:
{
    80002a28:	7179                	addi	sp,sp,-48
    80002a2a:	f406                	sd	ra,40(sp)
    80002a2c:	f022                	sd	s0,32(sp)
    80002a2e:	ec26                	sd	s1,24(sp)
    80002a30:	e84a                	sd	s2,16(sp)
    80002a32:	e44e                	sd	s3,8(sp)
    80002a34:	1800                	addi	s0,sp,48
    80002a36:	892a                	mv	s2,a0
    80002a38:	84ae                	mv	s1,a1
    80002a3a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a3c:	fffff097          	auipc	ra,0xfffff
    80002a40:	f84080e7          	jalr	-124(ra) # 800019c0 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002a44:	86ce                	mv	a3,s3
    80002a46:	864a                	mv	a2,s2
    80002a48:	85a6                	mv	a1,s1
    80002a4a:	6928                	ld	a0,80(a0)
    80002a4c:	fffff097          	auipc	ra,0xfffff
    80002a50:	d4e080e7          	jalr	-690(ra) # 8000179a <copyinstr>
  if(err < 0)
    80002a54:	00054763          	bltz	a0,80002a62 <fetchstr+0x3a>
  return strlen(buf);
    80002a58:	8526                	mv	a0,s1
    80002a5a:	ffffe097          	auipc	ra,0xffffe
    80002a5e:	3e8080e7          	jalr	1000(ra) # 80000e42 <strlen>
}
    80002a62:	70a2                	ld	ra,40(sp)
    80002a64:	7402                	ld	s0,32(sp)
    80002a66:	64e2                	ld	s1,24(sp)
    80002a68:	6942                	ld	s2,16(sp)
    80002a6a:	69a2                	ld	s3,8(sp)
    80002a6c:	6145                	addi	sp,sp,48
    80002a6e:	8082                	ret

0000000080002a70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002a70:	1101                	addi	sp,sp,-32
    80002a72:	ec06                	sd	ra,24(sp)
    80002a74:	e822                	sd	s0,16(sp)
    80002a76:	e426                	sd	s1,8(sp)
    80002a78:	1000                	addi	s0,sp,32
    80002a7a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a7c:	00000097          	auipc	ra,0x0
    80002a80:	ef2080e7          	jalr	-270(ra) # 8000296e <argraw>
    80002a84:	c088                	sw	a0,0(s1)
  return 0;
}
    80002a86:	4501                	li	a0,0
    80002a88:	60e2                	ld	ra,24(sp)
    80002a8a:	6442                	ld	s0,16(sp)
    80002a8c:	64a2                	ld	s1,8(sp)
    80002a8e:	6105                	addi	sp,sp,32
    80002a90:	8082                	ret

0000000080002a92 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002a92:	1101                	addi	sp,sp,-32
    80002a94:	ec06                	sd	ra,24(sp)
    80002a96:	e822                	sd	s0,16(sp)
    80002a98:	e426                	sd	s1,8(sp)
    80002a9a:	1000                	addi	s0,sp,32
    80002a9c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a9e:	00000097          	auipc	ra,0x0
    80002aa2:	ed0080e7          	jalr	-304(ra) # 8000296e <argraw>
    80002aa6:	e088                	sd	a0,0(s1)
  return 0;
}
    80002aa8:	4501                	li	a0,0
    80002aaa:	60e2                	ld	ra,24(sp)
    80002aac:	6442                	ld	s0,16(sp)
    80002aae:	64a2                	ld	s1,8(sp)
    80002ab0:	6105                	addi	sp,sp,32
    80002ab2:	8082                	ret

0000000080002ab4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002ab4:	1101                	addi	sp,sp,-32
    80002ab6:	ec06                	sd	ra,24(sp)
    80002ab8:	e822                	sd	s0,16(sp)
    80002aba:	e426                	sd	s1,8(sp)
    80002abc:	e04a                	sd	s2,0(sp)
    80002abe:	1000                	addi	s0,sp,32
    80002ac0:	84ae                	mv	s1,a1
    80002ac2:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	eaa080e7          	jalr	-342(ra) # 8000296e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002acc:	864a                	mv	a2,s2
    80002ace:	85a6                	mv	a1,s1
    80002ad0:	00000097          	auipc	ra,0x0
    80002ad4:	f58080e7          	jalr	-168(ra) # 80002a28 <fetchstr>
}
    80002ad8:	60e2                	ld	ra,24(sp)
    80002ada:	6442                	ld	s0,16(sp)
    80002adc:	64a2                	ld	s1,8(sp)
    80002ade:	6902                	ld	s2,0(sp)
    80002ae0:	6105                	addi	sp,sp,32
    80002ae2:	8082                	ret

0000000080002ae4 <syscall>:
[SYS_symlink]   sys_symlink,
};

void
syscall(void)
{
    80002ae4:	1101                	addi	sp,sp,-32
    80002ae6:	ec06                	sd	ra,24(sp)
    80002ae8:	e822                	sd	s0,16(sp)
    80002aea:	e426                	sd	s1,8(sp)
    80002aec:	e04a                	sd	s2,0(sp)
    80002aee:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002af0:	fffff097          	auipc	ra,0xfffff
    80002af4:	ed0080e7          	jalr	-304(ra) # 800019c0 <myproc>
    80002af8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002afa:	05853903          	ld	s2,88(a0)
    80002afe:	0a893783          	ld	a5,168(s2)
    80002b02:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b06:	37fd                	addiw	a5,a5,-1
    80002b08:	4755                	li	a4,21
    80002b0a:	00f76f63          	bltu	a4,a5,80002b28 <syscall+0x44>
    80002b0e:	00369713          	slli	a4,a3,0x3
    80002b12:	00006797          	auipc	a5,0x6
    80002b16:	91e78793          	addi	a5,a5,-1762 # 80008430 <syscalls>
    80002b1a:	97ba                	add	a5,a5,a4
    80002b1c:	639c                	ld	a5,0(a5)
    80002b1e:	c789                	beqz	a5,80002b28 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002b20:	9782                	jalr	a5
    80002b22:	06a93823          	sd	a0,112(s2)
    80002b26:	a839                	j	80002b44 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b28:	15848613          	addi	a2,s1,344
    80002b2c:	588c                	lw	a1,48(s1)
    80002b2e:	00006517          	auipc	a0,0x6
    80002b32:	8ca50513          	addi	a0,a0,-1846 # 800083f8 <states.0+0x150>
    80002b36:	ffffe097          	auipc	ra,0xffffe
    80002b3a:	a3e080e7          	jalr	-1474(ra) # 80000574 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b3e:	6cbc                	ld	a5,88(s1)
    80002b40:	577d                	li	a4,-1
    80002b42:	fbb8                	sd	a4,112(a5)
  }
}
    80002b44:	60e2                	ld	ra,24(sp)
    80002b46:	6442                	ld	s0,16(sp)
    80002b48:	64a2                	ld	s1,8(sp)
    80002b4a:	6902                	ld	s2,0(sp)
    80002b4c:	6105                	addi	sp,sp,32
    80002b4e:	8082                	ret

0000000080002b50 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002b50:	1101                	addi	sp,sp,-32
    80002b52:	ec06                	sd	ra,24(sp)
    80002b54:	e822                	sd	s0,16(sp)
    80002b56:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002b58:	fec40593          	addi	a1,s0,-20
    80002b5c:	4501                	li	a0,0
    80002b5e:	00000097          	auipc	ra,0x0
    80002b62:	f12080e7          	jalr	-238(ra) # 80002a70 <argint>
    return -1;
    80002b66:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002b68:	00054963          	bltz	a0,80002b7a <sys_exit+0x2a>
  exit(n);
    80002b6c:	fec42503          	lw	a0,-20(s0)
    80002b70:	fffff097          	auipc	ra,0xfffff
    80002b74:	76c080e7          	jalr	1900(ra) # 800022dc <exit>
  return 0;  // not reached
    80002b78:	4781                	li	a5,0
}
    80002b7a:	853e                	mv	a0,a5
    80002b7c:	60e2                	ld	ra,24(sp)
    80002b7e:	6442                	ld	s0,16(sp)
    80002b80:	6105                	addi	sp,sp,32
    80002b82:	8082                	ret

0000000080002b84 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002b84:	1141                	addi	sp,sp,-16
    80002b86:	e406                	sd	ra,8(sp)
    80002b88:	e022                	sd	s0,0(sp)
    80002b8a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002b8c:	fffff097          	auipc	ra,0xfffff
    80002b90:	e34080e7          	jalr	-460(ra) # 800019c0 <myproc>
}
    80002b94:	5908                	lw	a0,48(a0)
    80002b96:	60a2                	ld	ra,8(sp)
    80002b98:	6402                	ld	s0,0(sp)
    80002b9a:	0141                	addi	sp,sp,16
    80002b9c:	8082                	ret

0000000080002b9e <sys_fork>:

uint64
sys_fork(void)
{
    80002b9e:	1141                	addi	sp,sp,-16
    80002ba0:	e406                	sd	ra,8(sp)
    80002ba2:	e022                	sd	s0,0(sp)
    80002ba4:	0800                	addi	s0,sp,16
  return fork();
    80002ba6:	fffff097          	auipc	ra,0xfffff
    80002baa:	1e8080e7          	jalr	488(ra) # 80001d8e <fork>
}
    80002bae:	60a2                	ld	ra,8(sp)
    80002bb0:	6402                	ld	s0,0(sp)
    80002bb2:	0141                	addi	sp,sp,16
    80002bb4:	8082                	ret

0000000080002bb6 <sys_wait>:

uint64
sys_wait(void)
{
    80002bb6:	1101                	addi	sp,sp,-32
    80002bb8:	ec06                	sd	ra,24(sp)
    80002bba:	e822                	sd	s0,16(sp)
    80002bbc:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002bbe:	fe840593          	addi	a1,s0,-24
    80002bc2:	4501                	li	a0,0
    80002bc4:	00000097          	auipc	ra,0x0
    80002bc8:	ece080e7          	jalr	-306(ra) # 80002a92 <argaddr>
    80002bcc:	87aa                	mv	a5,a0
    return -1;
    80002bce:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002bd0:	0007c863          	bltz	a5,80002be0 <sys_wait+0x2a>
  return wait(p);
    80002bd4:	fe843503          	ld	a0,-24(s0)
    80002bd8:	fffff097          	auipc	ra,0xfffff
    80002bdc:	50c080e7          	jalr	1292(ra) # 800020e4 <wait>
}
    80002be0:	60e2                	ld	ra,24(sp)
    80002be2:	6442                	ld	s0,16(sp)
    80002be4:	6105                	addi	sp,sp,32
    80002be6:	8082                	ret

0000000080002be8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002be8:	7179                	addi	sp,sp,-48
    80002bea:	f406                	sd	ra,40(sp)
    80002bec:	f022                	sd	s0,32(sp)
    80002bee:	ec26                	sd	s1,24(sp)
    80002bf0:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002bf2:	fdc40593          	addi	a1,s0,-36
    80002bf6:	4501                	li	a0,0
    80002bf8:	00000097          	auipc	ra,0x0
    80002bfc:	e78080e7          	jalr	-392(ra) # 80002a70 <argint>
    return -1;
    80002c00:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002c02:	00054f63          	bltz	a0,80002c20 <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002c06:	fffff097          	auipc	ra,0xfffff
    80002c0a:	dba080e7          	jalr	-582(ra) # 800019c0 <myproc>
    80002c0e:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002c10:	fdc42503          	lw	a0,-36(s0)
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	106080e7          	jalr	262(ra) # 80001d1a <growproc>
    80002c1c:	00054863          	bltz	a0,80002c2c <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002c20:	8526                	mv	a0,s1
    80002c22:	70a2                	ld	ra,40(sp)
    80002c24:	7402                	ld	s0,32(sp)
    80002c26:	64e2                	ld	s1,24(sp)
    80002c28:	6145                	addi	sp,sp,48
    80002c2a:	8082                	ret
    return -1;
    80002c2c:	54fd                	li	s1,-1
    80002c2e:	bfcd                	j	80002c20 <sys_sbrk+0x38>

0000000080002c30 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c30:	7139                	addi	sp,sp,-64
    80002c32:	fc06                	sd	ra,56(sp)
    80002c34:	f822                	sd	s0,48(sp)
    80002c36:	f426                	sd	s1,40(sp)
    80002c38:	f04a                	sd	s2,32(sp)
    80002c3a:	ec4e                	sd	s3,24(sp)
    80002c3c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002c3e:	fcc40593          	addi	a1,s0,-52
    80002c42:	4501                	li	a0,0
    80002c44:	00000097          	auipc	ra,0x0
    80002c48:	e2c080e7          	jalr	-468(ra) # 80002a70 <argint>
    return -1;
    80002c4c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c4e:	06054563          	bltz	a0,80002cb8 <sys_sleep+0x88>
  acquire(&tickslock);
    80002c52:	00014517          	auipc	a0,0x14
    80002c56:	47e50513          	addi	a0,a0,1150 # 800170d0 <tickslock>
    80002c5a:	ffffe097          	auipc	ra,0xffffe
    80002c5e:	f68080e7          	jalr	-152(ra) # 80000bc2 <acquire>
  ticks0 = ticks;
    80002c62:	00006917          	auipc	s2,0x6
    80002c66:	3ce92903          	lw	s2,974(s2) # 80009030 <ticks>
  while(ticks - ticks0 < n){
    80002c6a:	fcc42783          	lw	a5,-52(s0)
    80002c6e:	cf85                	beqz	a5,80002ca6 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c70:	00014997          	auipc	s3,0x14
    80002c74:	46098993          	addi	s3,s3,1120 # 800170d0 <tickslock>
    80002c78:	00006497          	auipc	s1,0x6
    80002c7c:	3b848493          	addi	s1,s1,952 # 80009030 <ticks>
    if(myproc()->killed){
    80002c80:	fffff097          	auipc	ra,0xfffff
    80002c84:	d40080e7          	jalr	-704(ra) # 800019c0 <myproc>
    80002c88:	551c                	lw	a5,40(a0)
    80002c8a:	ef9d                	bnez	a5,80002cc8 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002c8c:	85ce                	mv	a1,s3
    80002c8e:	8526                	mv	a0,s1
    80002c90:	fffff097          	auipc	ra,0xfffff
    80002c94:	3f0080e7          	jalr	1008(ra) # 80002080 <sleep>
  while(ticks - ticks0 < n){
    80002c98:	409c                	lw	a5,0(s1)
    80002c9a:	412787bb          	subw	a5,a5,s2
    80002c9e:	fcc42703          	lw	a4,-52(s0)
    80002ca2:	fce7efe3          	bltu	a5,a4,80002c80 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002ca6:	00014517          	auipc	a0,0x14
    80002caa:	42a50513          	addi	a0,a0,1066 # 800170d0 <tickslock>
    80002cae:	ffffe097          	auipc	ra,0xffffe
    80002cb2:	fc8080e7          	jalr	-56(ra) # 80000c76 <release>
  return 0;
    80002cb6:	4781                	li	a5,0
}
    80002cb8:	853e                	mv	a0,a5
    80002cba:	70e2                	ld	ra,56(sp)
    80002cbc:	7442                	ld	s0,48(sp)
    80002cbe:	74a2                	ld	s1,40(sp)
    80002cc0:	7902                	ld	s2,32(sp)
    80002cc2:	69e2                	ld	s3,24(sp)
    80002cc4:	6121                	addi	sp,sp,64
    80002cc6:	8082                	ret
      release(&tickslock);
    80002cc8:	00014517          	auipc	a0,0x14
    80002ccc:	40850513          	addi	a0,a0,1032 # 800170d0 <tickslock>
    80002cd0:	ffffe097          	auipc	ra,0xffffe
    80002cd4:	fa6080e7          	jalr	-90(ra) # 80000c76 <release>
      return -1;
    80002cd8:	57fd                	li	a5,-1
    80002cda:	bff9                	j	80002cb8 <sys_sleep+0x88>

0000000080002cdc <sys_kill>:

uint64
sys_kill(void)
{
    80002cdc:	1101                	addi	sp,sp,-32
    80002cde:	ec06                	sd	ra,24(sp)
    80002ce0:	e822                	sd	s0,16(sp)
    80002ce2:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002ce4:	fec40593          	addi	a1,s0,-20
    80002ce8:	4501                	li	a0,0
    80002cea:	00000097          	auipc	ra,0x0
    80002cee:	d86080e7          	jalr	-634(ra) # 80002a70 <argint>
    80002cf2:	87aa                	mv	a5,a0
    return -1;
    80002cf4:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002cf6:	0007c863          	bltz	a5,80002d06 <sys_kill+0x2a>
  return kill(pid);
    80002cfa:	fec42503          	lw	a0,-20(s0)
    80002cfe:	fffff097          	auipc	ra,0xfffff
    80002d02:	6b4080e7          	jalr	1716(ra) # 800023b2 <kill>
}
    80002d06:	60e2                	ld	ra,24(sp)
    80002d08:	6442                	ld	s0,16(sp)
    80002d0a:	6105                	addi	sp,sp,32
    80002d0c:	8082                	ret

0000000080002d0e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d0e:	1101                	addi	sp,sp,-32
    80002d10:	ec06                	sd	ra,24(sp)
    80002d12:	e822                	sd	s0,16(sp)
    80002d14:	e426                	sd	s1,8(sp)
    80002d16:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d18:	00014517          	auipc	a0,0x14
    80002d1c:	3b850513          	addi	a0,a0,952 # 800170d0 <tickslock>
    80002d20:	ffffe097          	auipc	ra,0xffffe
    80002d24:	ea2080e7          	jalr	-350(ra) # 80000bc2 <acquire>
  xticks = ticks;
    80002d28:	00006497          	auipc	s1,0x6
    80002d2c:	3084a483          	lw	s1,776(s1) # 80009030 <ticks>
  release(&tickslock);
    80002d30:	00014517          	auipc	a0,0x14
    80002d34:	3a050513          	addi	a0,a0,928 # 800170d0 <tickslock>
    80002d38:	ffffe097          	auipc	ra,0xffffe
    80002d3c:	f3e080e7          	jalr	-194(ra) # 80000c76 <release>
  return xticks;
}
    80002d40:	02049513          	slli	a0,s1,0x20
    80002d44:	9101                	srli	a0,a0,0x20
    80002d46:	60e2                	ld	ra,24(sp)
    80002d48:	6442                	ld	s0,16(sp)
    80002d4a:	64a2                	ld	s1,8(sp)
    80002d4c:	6105                	addi	sp,sp,32
    80002d4e:	8082                	ret

0000000080002d50 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d50:	7179                	addi	sp,sp,-48
    80002d52:	f406                	sd	ra,40(sp)
    80002d54:	f022                	sd	s0,32(sp)
    80002d56:	ec26                	sd	s1,24(sp)
    80002d58:	e84a                	sd	s2,16(sp)
    80002d5a:	e44e                	sd	s3,8(sp)
    80002d5c:	e052                	sd	s4,0(sp)
    80002d5e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d60:	00005597          	auipc	a1,0x5
    80002d64:	78858593          	addi	a1,a1,1928 # 800084e8 <syscalls+0xb8>
    80002d68:	00014517          	auipc	a0,0x14
    80002d6c:	38050513          	addi	a0,a0,896 # 800170e8 <bcache>
    80002d70:	ffffe097          	auipc	ra,0xffffe
    80002d74:	dc2080e7          	jalr	-574(ra) # 80000b32 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d78:	0001c797          	auipc	a5,0x1c
    80002d7c:	37078793          	addi	a5,a5,880 # 8001f0e8 <bcache+0x8000>
    80002d80:	0001c717          	auipc	a4,0x1c
    80002d84:	5d070713          	addi	a4,a4,1488 # 8001f350 <bcache+0x8268>
    80002d88:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002d8c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d90:	00014497          	auipc	s1,0x14
    80002d94:	37048493          	addi	s1,s1,880 # 80017100 <bcache+0x18>
    b->next = bcache.head.next;
    80002d98:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002d9a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002d9c:	00005a17          	auipc	s4,0x5
    80002da0:	754a0a13          	addi	s4,s4,1876 # 800084f0 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002da4:	2b893783          	ld	a5,696(s2)
    80002da8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002daa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002dae:	85d2                	mv	a1,s4
    80002db0:	01048513          	addi	a0,s1,16
    80002db4:	00002097          	auipc	ra,0x2
    80002db8:	820080e7          	jalr	-2016(ra) # 800045d4 <initsleeplock>
    bcache.head.next->prev = b;
    80002dbc:	2b893783          	ld	a5,696(s2)
    80002dc0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002dc2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002dc6:	45848493          	addi	s1,s1,1112
    80002dca:	fd349de3          	bne	s1,s3,80002da4 <binit+0x54>
  }
}
    80002dce:	70a2                	ld	ra,40(sp)
    80002dd0:	7402                	ld	s0,32(sp)
    80002dd2:	64e2                	ld	s1,24(sp)
    80002dd4:	6942                	ld	s2,16(sp)
    80002dd6:	69a2                	ld	s3,8(sp)
    80002dd8:	6a02                	ld	s4,0(sp)
    80002dda:	6145                	addi	sp,sp,48
    80002ddc:	8082                	ret

0000000080002dde <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002dde:	7179                	addi	sp,sp,-48
    80002de0:	f406                	sd	ra,40(sp)
    80002de2:	f022                	sd	s0,32(sp)
    80002de4:	ec26                	sd	s1,24(sp)
    80002de6:	e84a                	sd	s2,16(sp)
    80002de8:	e44e                	sd	s3,8(sp)
    80002dea:	1800                	addi	s0,sp,48
    80002dec:	892a                	mv	s2,a0
    80002dee:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002df0:	00014517          	auipc	a0,0x14
    80002df4:	2f850513          	addi	a0,a0,760 # 800170e8 <bcache>
    80002df8:	ffffe097          	auipc	ra,0xffffe
    80002dfc:	dca080e7          	jalr	-566(ra) # 80000bc2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002e00:	0001c497          	auipc	s1,0x1c
    80002e04:	5a04b483          	ld	s1,1440(s1) # 8001f3a0 <bcache+0x82b8>
    80002e08:	0001c797          	auipc	a5,0x1c
    80002e0c:	54878793          	addi	a5,a5,1352 # 8001f350 <bcache+0x8268>
    80002e10:	02f48f63          	beq	s1,a5,80002e4e <bread+0x70>
    80002e14:	873e                	mv	a4,a5
    80002e16:	a021                	j	80002e1e <bread+0x40>
    80002e18:	68a4                	ld	s1,80(s1)
    80002e1a:	02e48a63          	beq	s1,a4,80002e4e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002e1e:	449c                	lw	a5,8(s1)
    80002e20:	ff279ce3          	bne	a5,s2,80002e18 <bread+0x3a>
    80002e24:	44dc                	lw	a5,12(s1)
    80002e26:	ff3799e3          	bne	a5,s3,80002e18 <bread+0x3a>
      b->refcnt++;
    80002e2a:	40bc                	lw	a5,64(s1)
    80002e2c:	2785                	addiw	a5,a5,1
    80002e2e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e30:	00014517          	auipc	a0,0x14
    80002e34:	2b850513          	addi	a0,a0,696 # 800170e8 <bcache>
    80002e38:	ffffe097          	auipc	ra,0xffffe
    80002e3c:	e3e080e7          	jalr	-450(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    80002e40:	01048513          	addi	a0,s1,16
    80002e44:	00001097          	auipc	ra,0x1
    80002e48:	7ca080e7          	jalr	1994(ra) # 8000460e <acquiresleep>
      return b;
    80002e4c:	a8b9                	j	80002eaa <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e4e:	0001c497          	auipc	s1,0x1c
    80002e52:	54a4b483          	ld	s1,1354(s1) # 8001f398 <bcache+0x82b0>
    80002e56:	0001c797          	auipc	a5,0x1c
    80002e5a:	4fa78793          	addi	a5,a5,1274 # 8001f350 <bcache+0x8268>
    80002e5e:	00f48863          	beq	s1,a5,80002e6e <bread+0x90>
    80002e62:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e64:	40bc                	lw	a5,64(s1)
    80002e66:	cf81                	beqz	a5,80002e7e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e68:	64a4                	ld	s1,72(s1)
    80002e6a:	fee49de3          	bne	s1,a4,80002e64 <bread+0x86>
  panic("bget: no buffers");
    80002e6e:	00005517          	auipc	a0,0x5
    80002e72:	68a50513          	addi	a0,a0,1674 # 800084f8 <syscalls+0xc8>
    80002e76:	ffffd097          	auipc	ra,0xffffd
    80002e7a:	6b4080e7          	jalr	1716(ra) # 8000052a <panic>
      b->dev = dev;
    80002e7e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e82:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e86:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002e8a:	4785                	li	a5,1
    80002e8c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e8e:	00014517          	auipc	a0,0x14
    80002e92:	25a50513          	addi	a0,a0,602 # 800170e8 <bcache>
    80002e96:	ffffe097          	auipc	ra,0xffffe
    80002e9a:	de0080e7          	jalr	-544(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    80002e9e:	01048513          	addi	a0,s1,16
    80002ea2:	00001097          	auipc	ra,0x1
    80002ea6:	76c080e7          	jalr	1900(ra) # 8000460e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002eaa:	409c                	lw	a5,0(s1)
    80002eac:	cb89                	beqz	a5,80002ebe <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002eae:	8526                	mv	a0,s1
    80002eb0:	70a2                	ld	ra,40(sp)
    80002eb2:	7402                	ld	s0,32(sp)
    80002eb4:	64e2                	ld	s1,24(sp)
    80002eb6:	6942                	ld	s2,16(sp)
    80002eb8:	69a2                	ld	s3,8(sp)
    80002eba:	6145                	addi	sp,sp,48
    80002ebc:	8082                	ret
    virtio_disk_rw(b, 0);
    80002ebe:	4581                	li	a1,0
    80002ec0:	8526                	mv	a0,s1
    80002ec2:	00003097          	auipc	ra,0x3
    80002ec6:	3d4080e7          	jalr	980(ra) # 80006296 <virtio_disk_rw>
    b->valid = 1;
    80002eca:	4785                	li	a5,1
    80002ecc:	c09c                	sw	a5,0(s1)
  return b;
    80002ece:	b7c5                	j	80002eae <bread+0xd0>

0000000080002ed0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002ed0:	1101                	addi	sp,sp,-32
    80002ed2:	ec06                	sd	ra,24(sp)
    80002ed4:	e822                	sd	s0,16(sp)
    80002ed6:	e426                	sd	s1,8(sp)
    80002ed8:	1000                	addi	s0,sp,32
    80002eda:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002edc:	0541                	addi	a0,a0,16
    80002ede:	00001097          	auipc	ra,0x1
    80002ee2:	7ca080e7          	jalr	1994(ra) # 800046a8 <holdingsleep>
    80002ee6:	cd01                	beqz	a0,80002efe <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002ee8:	4585                	li	a1,1
    80002eea:	8526                	mv	a0,s1
    80002eec:	00003097          	auipc	ra,0x3
    80002ef0:	3aa080e7          	jalr	938(ra) # 80006296 <virtio_disk_rw>
}
    80002ef4:	60e2                	ld	ra,24(sp)
    80002ef6:	6442                	ld	s0,16(sp)
    80002ef8:	64a2                	ld	s1,8(sp)
    80002efa:	6105                	addi	sp,sp,32
    80002efc:	8082                	ret
    panic("bwrite");
    80002efe:	00005517          	auipc	a0,0x5
    80002f02:	61250513          	addi	a0,a0,1554 # 80008510 <syscalls+0xe0>
    80002f06:	ffffd097          	auipc	ra,0xffffd
    80002f0a:	624080e7          	jalr	1572(ra) # 8000052a <panic>

0000000080002f0e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f0e:	1101                	addi	sp,sp,-32
    80002f10:	ec06                	sd	ra,24(sp)
    80002f12:	e822                	sd	s0,16(sp)
    80002f14:	e426                	sd	s1,8(sp)
    80002f16:	e04a                	sd	s2,0(sp)
    80002f18:	1000                	addi	s0,sp,32
    80002f1a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f1c:	01050913          	addi	s2,a0,16
    80002f20:	854a                	mv	a0,s2
    80002f22:	00001097          	auipc	ra,0x1
    80002f26:	786080e7          	jalr	1926(ra) # 800046a8 <holdingsleep>
    80002f2a:	c92d                	beqz	a0,80002f9c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002f2c:	854a                	mv	a0,s2
    80002f2e:	00001097          	auipc	ra,0x1
    80002f32:	736080e7          	jalr	1846(ra) # 80004664 <releasesleep>

  acquire(&bcache.lock);
    80002f36:	00014517          	auipc	a0,0x14
    80002f3a:	1b250513          	addi	a0,a0,434 # 800170e8 <bcache>
    80002f3e:	ffffe097          	auipc	ra,0xffffe
    80002f42:	c84080e7          	jalr	-892(ra) # 80000bc2 <acquire>
  b->refcnt--;
    80002f46:	40bc                	lw	a5,64(s1)
    80002f48:	37fd                	addiw	a5,a5,-1
    80002f4a:	0007871b          	sext.w	a4,a5
    80002f4e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f50:	eb05                	bnez	a4,80002f80 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f52:	68bc                	ld	a5,80(s1)
    80002f54:	64b8                	ld	a4,72(s1)
    80002f56:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002f58:	64bc                	ld	a5,72(s1)
    80002f5a:	68b8                	ld	a4,80(s1)
    80002f5c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f5e:	0001c797          	auipc	a5,0x1c
    80002f62:	18a78793          	addi	a5,a5,394 # 8001f0e8 <bcache+0x8000>
    80002f66:	2b87b703          	ld	a4,696(a5)
    80002f6a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f6c:	0001c717          	auipc	a4,0x1c
    80002f70:	3e470713          	addi	a4,a4,996 # 8001f350 <bcache+0x8268>
    80002f74:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f76:	2b87b703          	ld	a4,696(a5)
    80002f7a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f7c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002f80:	00014517          	auipc	a0,0x14
    80002f84:	16850513          	addi	a0,a0,360 # 800170e8 <bcache>
    80002f88:	ffffe097          	auipc	ra,0xffffe
    80002f8c:	cee080e7          	jalr	-786(ra) # 80000c76 <release>
}
    80002f90:	60e2                	ld	ra,24(sp)
    80002f92:	6442                	ld	s0,16(sp)
    80002f94:	64a2                	ld	s1,8(sp)
    80002f96:	6902                	ld	s2,0(sp)
    80002f98:	6105                	addi	sp,sp,32
    80002f9a:	8082                	ret
    panic("brelse");
    80002f9c:	00005517          	auipc	a0,0x5
    80002fa0:	57c50513          	addi	a0,a0,1404 # 80008518 <syscalls+0xe8>
    80002fa4:	ffffd097          	auipc	ra,0xffffd
    80002fa8:	586080e7          	jalr	1414(ra) # 8000052a <panic>

0000000080002fac <bpin>:

void
bpin(struct buf *b) {
    80002fac:	1101                	addi	sp,sp,-32
    80002fae:	ec06                	sd	ra,24(sp)
    80002fb0:	e822                	sd	s0,16(sp)
    80002fb2:	e426                	sd	s1,8(sp)
    80002fb4:	1000                	addi	s0,sp,32
    80002fb6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fb8:	00014517          	auipc	a0,0x14
    80002fbc:	13050513          	addi	a0,a0,304 # 800170e8 <bcache>
    80002fc0:	ffffe097          	auipc	ra,0xffffe
    80002fc4:	c02080e7          	jalr	-1022(ra) # 80000bc2 <acquire>
  b->refcnt++;
    80002fc8:	40bc                	lw	a5,64(s1)
    80002fca:	2785                	addiw	a5,a5,1
    80002fcc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fce:	00014517          	auipc	a0,0x14
    80002fd2:	11a50513          	addi	a0,a0,282 # 800170e8 <bcache>
    80002fd6:	ffffe097          	auipc	ra,0xffffe
    80002fda:	ca0080e7          	jalr	-864(ra) # 80000c76 <release>
}
    80002fde:	60e2                	ld	ra,24(sp)
    80002fe0:	6442                	ld	s0,16(sp)
    80002fe2:	64a2                	ld	s1,8(sp)
    80002fe4:	6105                	addi	sp,sp,32
    80002fe6:	8082                	ret

0000000080002fe8 <bunpin>:

void
bunpin(struct buf *b) {
    80002fe8:	1101                	addi	sp,sp,-32
    80002fea:	ec06                	sd	ra,24(sp)
    80002fec:	e822                	sd	s0,16(sp)
    80002fee:	e426                	sd	s1,8(sp)
    80002ff0:	1000                	addi	s0,sp,32
    80002ff2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002ff4:	00014517          	auipc	a0,0x14
    80002ff8:	0f450513          	addi	a0,a0,244 # 800170e8 <bcache>
    80002ffc:	ffffe097          	auipc	ra,0xffffe
    80003000:	bc6080e7          	jalr	-1082(ra) # 80000bc2 <acquire>
  b->refcnt--;
    80003004:	40bc                	lw	a5,64(s1)
    80003006:	37fd                	addiw	a5,a5,-1
    80003008:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000300a:	00014517          	auipc	a0,0x14
    8000300e:	0de50513          	addi	a0,a0,222 # 800170e8 <bcache>
    80003012:	ffffe097          	auipc	ra,0xffffe
    80003016:	c64080e7          	jalr	-924(ra) # 80000c76 <release>
}
    8000301a:	60e2                	ld	ra,24(sp)
    8000301c:	6442                	ld	s0,16(sp)
    8000301e:	64a2                	ld	s1,8(sp)
    80003020:	6105                	addi	sp,sp,32
    80003022:	8082                	ret

0000000080003024 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003024:	1101                	addi	sp,sp,-32
    80003026:	ec06                	sd	ra,24(sp)
    80003028:	e822                	sd	s0,16(sp)
    8000302a:	e426                	sd	s1,8(sp)
    8000302c:	e04a                	sd	s2,0(sp)
    8000302e:	1000                	addi	s0,sp,32
    80003030:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003032:	00d5d59b          	srliw	a1,a1,0xd
    80003036:	0001c797          	auipc	a5,0x1c
    8000303a:	78e7a783          	lw	a5,1934(a5) # 8001f7c4 <sb+0x1c>
    8000303e:	9dbd                	addw	a1,a1,a5
    80003040:	00000097          	auipc	ra,0x0
    80003044:	d9e080e7          	jalr	-610(ra) # 80002dde <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003048:	0074f713          	andi	a4,s1,7
    8000304c:	4785                	li	a5,1
    8000304e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003052:	14ce                	slli	s1,s1,0x33
    80003054:	90d9                	srli	s1,s1,0x36
    80003056:	00950733          	add	a4,a0,s1
    8000305a:	05874703          	lbu	a4,88(a4)
    8000305e:	00e7f6b3          	and	a3,a5,a4
    80003062:	c69d                	beqz	a3,80003090 <bfree+0x6c>
    80003064:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003066:	94aa                	add	s1,s1,a0
    80003068:	fff7c793          	not	a5,a5
    8000306c:	8ff9                	and	a5,a5,a4
    8000306e:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003072:	00001097          	auipc	ra,0x1
    80003076:	47c080e7          	jalr	1148(ra) # 800044ee <log_write>
  brelse(bp);
    8000307a:	854a                	mv	a0,s2
    8000307c:	00000097          	auipc	ra,0x0
    80003080:	e92080e7          	jalr	-366(ra) # 80002f0e <brelse>
}
    80003084:	60e2                	ld	ra,24(sp)
    80003086:	6442                	ld	s0,16(sp)
    80003088:	64a2                	ld	s1,8(sp)
    8000308a:	6902                	ld	s2,0(sp)
    8000308c:	6105                	addi	sp,sp,32
    8000308e:	8082                	ret
    panic("freeing free block");
    80003090:	00005517          	auipc	a0,0x5
    80003094:	49050513          	addi	a0,a0,1168 # 80008520 <syscalls+0xf0>
    80003098:	ffffd097          	auipc	ra,0xffffd
    8000309c:	492080e7          	jalr	1170(ra) # 8000052a <panic>

00000000800030a0 <balloc>:
{
    800030a0:	711d                	addi	sp,sp,-96
    800030a2:	ec86                	sd	ra,88(sp)
    800030a4:	e8a2                	sd	s0,80(sp)
    800030a6:	e4a6                	sd	s1,72(sp)
    800030a8:	e0ca                	sd	s2,64(sp)
    800030aa:	fc4e                	sd	s3,56(sp)
    800030ac:	f852                	sd	s4,48(sp)
    800030ae:	f456                	sd	s5,40(sp)
    800030b0:	f05a                	sd	s6,32(sp)
    800030b2:	ec5e                	sd	s7,24(sp)
    800030b4:	e862                	sd	s8,16(sp)
    800030b6:	e466                	sd	s9,8(sp)
    800030b8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800030ba:	0001c797          	auipc	a5,0x1c
    800030be:	6f27a783          	lw	a5,1778(a5) # 8001f7ac <sb+0x4>
    800030c2:	cbd1                	beqz	a5,80003156 <balloc+0xb6>
    800030c4:	8baa                	mv	s7,a0
    800030c6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030c8:	0001cb17          	auipc	s6,0x1c
    800030cc:	6e0b0b13          	addi	s6,s6,1760 # 8001f7a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030d0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800030d2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030d4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800030d6:	6c89                	lui	s9,0x2
    800030d8:	a831                	j	800030f4 <balloc+0x54>
    brelse(bp);
    800030da:	854a                	mv	a0,s2
    800030dc:	00000097          	auipc	ra,0x0
    800030e0:	e32080e7          	jalr	-462(ra) # 80002f0e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800030e4:	015c87bb          	addw	a5,s9,s5
    800030e8:	00078a9b          	sext.w	s5,a5
    800030ec:	004b2703          	lw	a4,4(s6)
    800030f0:	06eaf363          	bgeu	s5,a4,80003156 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800030f4:	41fad79b          	sraiw	a5,s5,0x1f
    800030f8:	0137d79b          	srliw	a5,a5,0x13
    800030fc:	015787bb          	addw	a5,a5,s5
    80003100:	40d7d79b          	sraiw	a5,a5,0xd
    80003104:	01cb2583          	lw	a1,28(s6)
    80003108:	9dbd                	addw	a1,a1,a5
    8000310a:	855e                	mv	a0,s7
    8000310c:	00000097          	auipc	ra,0x0
    80003110:	cd2080e7          	jalr	-814(ra) # 80002dde <bread>
    80003114:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003116:	004b2503          	lw	a0,4(s6)
    8000311a:	000a849b          	sext.w	s1,s5
    8000311e:	8662                	mv	a2,s8
    80003120:	faa4fde3          	bgeu	s1,a0,800030da <balloc+0x3a>
      m = 1 << (bi % 8);
    80003124:	41f6579b          	sraiw	a5,a2,0x1f
    80003128:	01d7d69b          	srliw	a3,a5,0x1d
    8000312c:	00c6873b          	addw	a4,a3,a2
    80003130:	00777793          	andi	a5,a4,7
    80003134:	9f95                	subw	a5,a5,a3
    80003136:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000313a:	4037571b          	sraiw	a4,a4,0x3
    8000313e:	00e906b3          	add	a3,s2,a4
    80003142:	0586c683          	lbu	a3,88(a3)
    80003146:	00d7f5b3          	and	a1,a5,a3
    8000314a:	cd91                	beqz	a1,80003166 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000314c:	2605                	addiw	a2,a2,1
    8000314e:	2485                	addiw	s1,s1,1
    80003150:	fd4618e3          	bne	a2,s4,80003120 <balloc+0x80>
    80003154:	b759                	j	800030da <balloc+0x3a>
  panic("balloc: out of blocks");
    80003156:	00005517          	auipc	a0,0x5
    8000315a:	3e250513          	addi	a0,a0,994 # 80008538 <syscalls+0x108>
    8000315e:	ffffd097          	auipc	ra,0xffffd
    80003162:	3cc080e7          	jalr	972(ra) # 8000052a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003166:	974a                	add	a4,a4,s2
    80003168:	8fd5                	or	a5,a5,a3
    8000316a:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000316e:	854a                	mv	a0,s2
    80003170:	00001097          	auipc	ra,0x1
    80003174:	37e080e7          	jalr	894(ra) # 800044ee <log_write>
        brelse(bp);
    80003178:	854a                	mv	a0,s2
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	d94080e7          	jalr	-620(ra) # 80002f0e <brelse>
  bp = bread(dev, bno);
    80003182:	85a6                	mv	a1,s1
    80003184:	855e                	mv	a0,s7
    80003186:	00000097          	auipc	ra,0x0
    8000318a:	c58080e7          	jalr	-936(ra) # 80002dde <bread>
    8000318e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003190:	40000613          	li	a2,1024
    80003194:	4581                	li	a1,0
    80003196:	05850513          	addi	a0,a0,88
    8000319a:	ffffe097          	auipc	ra,0xffffe
    8000319e:	b24080e7          	jalr	-1244(ra) # 80000cbe <memset>
  log_write(bp);
    800031a2:	854a                	mv	a0,s2
    800031a4:	00001097          	auipc	ra,0x1
    800031a8:	34a080e7          	jalr	842(ra) # 800044ee <log_write>
  brelse(bp);
    800031ac:	854a                	mv	a0,s2
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	d60080e7          	jalr	-672(ra) # 80002f0e <brelse>
}
    800031b6:	8526                	mv	a0,s1
    800031b8:	60e6                	ld	ra,88(sp)
    800031ba:	6446                	ld	s0,80(sp)
    800031bc:	64a6                	ld	s1,72(sp)
    800031be:	6906                	ld	s2,64(sp)
    800031c0:	79e2                	ld	s3,56(sp)
    800031c2:	7a42                	ld	s4,48(sp)
    800031c4:	7aa2                	ld	s5,40(sp)
    800031c6:	7b02                	ld	s6,32(sp)
    800031c8:	6be2                	ld	s7,24(sp)
    800031ca:	6c42                	ld	s8,16(sp)
    800031cc:	6ca2                	ld	s9,8(sp)
    800031ce:	6125                	addi	sp,sp,96
    800031d0:	8082                	ret

00000000800031d2 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800031d2:	7139                	addi	sp,sp,-64
    800031d4:	fc06                	sd	ra,56(sp)
    800031d6:	f822                	sd	s0,48(sp)
    800031d8:	f426                	sd	s1,40(sp)
    800031da:	f04a                	sd	s2,32(sp)
    800031dc:	ec4e                	sd	s3,24(sp)
    800031de:	e852                	sd	s4,16(sp)
    800031e0:	e456                	sd	s5,8(sp)
    800031e2:	0080                	addi	s0,sp,64
    800031e4:	892a                	mv	s2,a0
  // so that it can handle doubly indrect inode.
  //printf("max blocks %d", MAXFILE);
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800031e6:	47a9                	li	a5,10
    800031e8:	0ab7f563          	bgeu	a5,a1,80003292 <bmap+0xc0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800031ec:	ff55849b          	addiw	s1,a1,-11
    800031f0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT - 4){
    800031f4:	0fb00793          	li	a5,251
    800031f8:	0ce7f063          	bgeu	a5,a4,800032b8 <bmap+0xe6>
      log_write(bp);
    }
    brelse(bp);
    return addr;
  }
  bn -= NINDIRECT-4;
    800031fc:	ef95849b          	addiw	s1,a1,-263
    80003200:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT*4){
    80003204:	3ff00793          	li	a5,1023
    80003208:	10e7fb63          	bgeu	a5,a4,8000331e <bmap+0x14c>
    }
    brelse(bp);

    return addr;
  }
  bn -= NINDIRECT*4;
    8000320c:	af95849b          	addiw	s1,a1,-1287
    80003210:	0004871b          	sext.w	a4,s1

  if(bn < NININDIRECT){
    80003214:	67c1                	lui	a5,0x10
    80003216:	20f77c63          	bgeu	a4,a5,8000342e <bmap+0x25c>
    // Load first indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT+1]) == 0)
    8000321a:	08052583          	lw	a1,128(a0)
    8000321e:	1a058e63          	beqz	a1,800033da <bmap+0x208>
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);

    bp = bread(ip->dev, addr);
    80003222:	00092503          	lw	a0,0(s2)
    80003226:	00000097          	auipc	ra,0x0
    8000322a:	bb8080e7          	jalr	-1096(ra) # 80002dde <bread>
    8000322e:	89aa                	mv	s3,a0
    a = (uint*)bp->data;
    80003230:	05850a13          	addi	s4,a0,88
    if((addr = a[bn/256]) == 0){
    80003234:	0084d79b          	srliw	a5,s1,0x8
    80003238:	078a                	slli	a5,a5,0x2
    8000323a:	9a3e                	add	s4,s4,a5
    8000323c:	000a2a83          	lw	s5,0(s4) # 2000 <_entry-0x7fffe000>
    80003240:	1a0a8763          	beqz	s5,800033ee <bmap+0x21c>
      a[bn/256] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003244:	854e                	mv	a0,s3
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	cc8080e7          	jalr	-824(ra) # 80002f0e <brelse>

    bp = bread(ip->dev, addr);
    8000324e:	85d6                	mv	a1,s5
    80003250:	00092503          	lw	a0,0(s2)
    80003254:	00000097          	auipc	ra,0x0
    80003258:	b8a080e7          	jalr	-1142(ra) # 80002dde <bread>
    8000325c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000325e:	05850793          	addi	a5,a0,88
    if((addr = a[bn%256]) == 0){
    80003262:	0ff4f593          	andi	a1,s1,255
    80003266:	058a                	slli	a1,a1,0x2
    80003268:	00b784b3          	add	s1,a5,a1
    8000326c:	0004a983          	lw	s3,0(s1)
    80003270:	18098f63          	beqz	s3,8000340e <bmap+0x23c>
      a[bn%256] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003274:	8552                	mv	a0,s4
    80003276:	00000097          	auipc	ra,0x0
    8000327a:	c98080e7          	jalr	-872(ra) # 80002f0e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000327e:	854e                	mv	a0,s3
    80003280:	70e2                	ld	ra,56(sp)
    80003282:	7442                	ld	s0,48(sp)
    80003284:	74a2                	ld	s1,40(sp)
    80003286:	7902                	ld	s2,32(sp)
    80003288:	69e2                	ld	s3,24(sp)
    8000328a:	6a42                	ld	s4,16(sp)
    8000328c:	6aa2                	ld	s5,8(sp)
    8000328e:	6121                	addi	sp,sp,64
    80003290:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003292:	02059493          	slli	s1,a1,0x20
    80003296:	9081                	srli	s1,s1,0x20
    80003298:	048a                	slli	s1,s1,0x2
    8000329a:	94aa                	add	s1,s1,a0
    8000329c:	0504a983          	lw	s3,80(s1)
    800032a0:	fc099fe3          	bnez	s3,8000327e <bmap+0xac>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800032a4:	4108                	lw	a0,0(a0)
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	dfa080e7          	jalr	-518(ra) # 800030a0 <balloc>
    800032ae:	0005099b          	sext.w	s3,a0
    800032b2:	0534a823          	sw	s3,80(s1)
    800032b6:	b7e1                	j	8000327e <bmap+0xac>
    if((addr = ip->addrs[NDIRECT]) == 0)
    800032b8:	5d6c                	lw	a1,124(a0)
    800032ba:	c985                	beqz	a1,800032ea <bmap+0x118>
    bp = bread(ip->dev, addr);
    800032bc:	00092503          	lw	a0,0(s2)
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	b1e080e7          	jalr	-1250(ra) # 80002dde <bread>
    800032c8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800032ca:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800032ce:	1482                	slli	s1,s1,0x20
    800032d0:	9081                	srli	s1,s1,0x20
    800032d2:	048a                	slli	s1,s1,0x2
    800032d4:	94be                	add	s1,s1,a5
    800032d6:	0004a983          	lw	s3,0(s1)
    800032da:	02098263          	beqz	s3,800032fe <bmap+0x12c>
    brelse(bp);
    800032de:	8552                	mv	a0,s4
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	c2e080e7          	jalr	-978(ra) # 80002f0e <brelse>
    return addr;
    800032e8:	bf59                	j	8000327e <bmap+0xac>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800032ea:	4108                	lw	a0,0(a0)
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	db4080e7          	jalr	-588(ra) # 800030a0 <balloc>
    800032f4:	0005059b          	sext.w	a1,a0
    800032f8:	06b92e23          	sw	a1,124(s2)
    800032fc:	b7c1                	j	800032bc <bmap+0xea>
      a[bn] = addr = balloc(ip->dev);
    800032fe:	00092503          	lw	a0,0(s2)
    80003302:	00000097          	auipc	ra,0x0
    80003306:	d9e080e7          	jalr	-610(ra) # 800030a0 <balloc>
    8000330a:	0005099b          	sext.w	s3,a0
    8000330e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003312:	8552                	mv	a0,s4
    80003314:	00001097          	auipc	ra,0x1
    80003318:	1da080e7          	jalr	474(ra) # 800044ee <log_write>
    8000331c:	b7c9                	j	800032de <bmap+0x10c>
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000331e:	5d6c                	lw	a1,124(a0)
    80003320:	c1bd                	beqz	a1,80003386 <bmap+0x1b4>
    bp = bread(ip->dev, addr);
    80003322:	00092503          	lw	a0,0(s2)
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	ab8080e7          	jalr	-1352(ra) # 80002dde <bread>
    8000332e:	89aa                	mv	s3,a0
    a = (uint*)bp->data;
    80003330:	05850a13          	addi	s4,a0,88
    if((addr = a[bn/256 + 252]) == 0){
    80003334:	0084d79b          	srliw	a5,s1,0x8
    80003338:	0fc7879b          	addiw	a5,a5,252
    8000333c:	1782                	slli	a5,a5,0x20
    8000333e:	9381                	srli	a5,a5,0x20
    80003340:	078a                	slli	a5,a5,0x2
    80003342:	9a3e                	add	s4,s4,a5
    80003344:	000a2a83          	lw	s5,0(s4)
    80003348:	040a8963          	beqz	s5,8000339a <bmap+0x1c8>
    brelse(bp);
    8000334c:	854e                	mv	a0,s3
    8000334e:	00000097          	auipc	ra,0x0
    80003352:	bc0080e7          	jalr	-1088(ra) # 80002f0e <brelse>
    bp = bread(ip->dev, addr);
    80003356:	85d6                	mv	a1,s5
    80003358:	00092503          	lw	a0,0(s2)
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	a82080e7          	jalr	-1406(ra) # 80002dde <bread>
    80003364:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003366:	05850793          	addi	a5,a0,88
    if((addr = a[bn%256]) == 0){
    8000336a:	0ff4f493          	andi	s1,s1,255
    8000336e:	048a                	slli	s1,s1,0x2
    80003370:	94be                	add	s1,s1,a5
    80003372:	0004a983          	lw	s3,0(s1)
    80003376:	04098263          	beqz	s3,800033ba <bmap+0x1e8>
    brelse(bp);
    8000337a:	8552                	mv	a0,s4
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	b92080e7          	jalr	-1134(ra) # 80002f0e <brelse>
    return addr;
    80003384:	bded                	j	8000327e <bmap+0xac>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003386:	4108                	lw	a0,0(a0)
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	d18080e7          	jalr	-744(ra) # 800030a0 <balloc>
    80003390:	0005059b          	sext.w	a1,a0
    80003394:	06b92e23          	sw	a1,124(s2)
    80003398:	b769                	j	80003322 <bmap+0x150>
      a[bn/256 + 252] = addr = balloc(ip->dev);
    8000339a:	00092503          	lw	a0,0(s2)
    8000339e:	00000097          	auipc	ra,0x0
    800033a2:	d02080e7          	jalr	-766(ra) # 800030a0 <balloc>
    800033a6:	00050a9b          	sext.w	s5,a0
    800033aa:	015a2023          	sw	s5,0(s4)
      log_write(bp);
    800033ae:	854e                	mv	a0,s3
    800033b0:	00001097          	auipc	ra,0x1
    800033b4:	13e080e7          	jalr	318(ra) # 800044ee <log_write>
    800033b8:	bf51                	j	8000334c <bmap+0x17a>
      a[bn%256] = addr = balloc(ip->dev);
    800033ba:	00092503          	lw	a0,0(s2)
    800033be:	00000097          	auipc	ra,0x0
    800033c2:	ce2080e7          	jalr	-798(ra) # 800030a0 <balloc>
    800033c6:	0005099b          	sext.w	s3,a0
    800033ca:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800033ce:	8552                	mv	a0,s4
    800033d0:	00001097          	auipc	ra,0x1
    800033d4:	11e080e7          	jalr	286(ra) # 800044ee <log_write>
    800033d8:	b74d                	j	8000337a <bmap+0x1a8>
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    800033da:	4108                	lw	a0,0(a0)
    800033dc:	00000097          	auipc	ra,0x0
    800033e0:	cc4080e7          	jalr	-828(ra) # 800030a0 <balloc>
    800033e4:	0005059b          	sext.w	a1,a0
    800033e8:	08b92023          	sw	a1,128(s2)
    800033ec:	bd1d                	j	80003222 <bmap+0x50>
      a[bn/256] = addr = balloc(ip->dev);
    800033ee:	00092503          	lw	a0,0(s2)
    800033f2:	00000097          	auipc	ra,0x0
    800033f6:	cae080e7          	jalr	-850(ra) # 800030a0 <balloc>
    800033fa:	00050a9b          	sext.w	s5,a0
    800033fe:	015a2023          	sw	s5,0(s4)
      log_write(bp);
    80003402:	854e                	mv	a0,s3
    80003404:	00001097          	auipc	ra,0x1
    80003408:	0ea080e7          	jalr	234(ra) # 800044ee <log_write>
    8000340c:	bd25                	j	80003244 <bmap+0x72>
      a[bn%256] = addr = balloc(ip->dev);
    8000340e:	00092503          	lw	a0,0(s2)
    80003412:	00000097          	auipc	ra,0x0
    80003416:	c8e080e7          	jalr	-882(ra) # 800030a0 <balloc>
    8000341a:	0005099b          	sext.w	s3,a0
    8000341e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003422:	8552                	mv	a0,s4
    80003424:	00001097          	auipc	ra,0x1
    80003428:	0ca080e7          	jalr	202(ra) # 800044ee <log_write>
    8000342c:	b5a1                	j	80003274 <bmap+0xa2>
  panic("bmap: out of range");
    8000342e:	00005517          	auipc	a0,0x5
    80003432:	12250513          	addi	a0,a0,290 # 80008550 <syscalls+0x120>
    80003436:	ffffd097          	auipc	ra,0xffffd
    8000343a:	0f4080e7          	jalr	244(ra) # 8000052a <panic>

000000008000343e <iget>:
{
    8000343e:	7179                	addi	sp,sp,-48
    80003440:	f406                	sd	ra,40(sp)
    80003442:	f022                	sd	s0,32(sp)
    80003444:	ec26                	sd	s1,24(sp)
    80003446:	e84a                	sd	s2,16(sp)
    80003448:	e44e                	sd	s3,8(sp)
    8000344a:	e052                	sd	s4,0(sp)
    8000344c:	1800                	addi	s0,sp,48
    8000344e:	89aa                	mv	s3,a0
    80003450:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003452:	0001c517          	auipc	a0,0x1c
    80003456:	37650513          	addi	a0,a0,886 # 8001f7c8 <itable>
    8000345a:	ffffd097          	auipc	ra,0xffffd
    8000345e:	768080e7          	jalr	1896(ra) # 80000bc2 <acquire>
  empty = 0;
    80003462:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003464:	0001c497          	auipc	s1,0x1c
    80003468:	37c48493          	addi	s1,s1,892 # 8001f7e0 <itable+0x18>
    8000346c:	0001e697          	auipc	a3,0x1e
    80003470:	e0468693          	addi	a3,a3,-508 # 80021270 <log>
    80003474:	a039                	j	80003482 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003476:	02090b63          	beqz	s2,800034ac <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000347a:	08848493          	addi	s1,s1,136
    8000347e:	02d48a63          	beq	s1,a3,800034b2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003482:	449c                	lw	a5,8(s1)
    80003484:	fef059e3          	blez	a5,80003476 <iget+0x38>
    80003488:	4098                	lw	a4,0(s1)
    8000348a:	ff3716e3          	bne	a4,s3,80003476 <iget+0x38>
    8000348e:	40d8                	lw	a4,4(s1)
    80003490:	ff4713e3          	bne	a4,s4,80003476 <iget+0x38>
      ip->ref++;
    80003494:	2785                	addiw	a5,a5,1
    80003496:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003498:	0001c517          	auipc	a0,0x1c
    8000349c:	33050513          	addi	a0,a0,816 # 8001f7c8 <itable>
    800034a0:	ffffd097          	auipc	ra,0xffffd
    800034a4:	7d6080e7          	jalr	2006(ra) # 80000c76 <release>
      return ip;
    800034a8:	8926                	mv	s2,s1
    800034aa:	a03d                	j	800034d8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034ac:	f7f9                	bnez	a5,8000347a <iget+0x3c>
    800034ae:	8926                	mv	s2,s1
    800034b0:	b7e9                	j	8000347a <iget+0x3c>
  if(empty == 0)
    800034b2:	02090c63          	beqz	s2,800034ea <iget+0xac>
  ip->dev = dev;
    800034b6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800034ba:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800034be:	4785                	li	a5,1
    800034c0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800034c4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800034c8:	0001c517          	auipc	a0,0x1c
    800034cc:	30050513          	addi	a0,a0,768 # 8001f7c8 <itable>
    800034d0:	ffffd097          	auipc	ra,0xffffd
    800034d4:	7a6080e7          	jalr	1958(ra) # 80000c76 <release>
}
    800034d8:	854a                	mv	a0,s2
    800034da:	70a2                	ld	ra,40(sp)
    800034dc:	7402                	ld	s0,32(sp)
    800034de:	64e2                	ld	s1,24(sp)
    800034e0:	6942                	ld	s2,16(sp)
    800034e2:	69a2                	ld	s3,8(sp)
    800034e4:	6a02                	ld	s4,0(sp)
    800034e6:	6145                	addi	sp,sp,48
    800034e8:	8082                	ret
    panic("iget: no inodes");
    800034ea:	00005517          	auipc	a0,0x5
    800034ee:	07e50513          	addi	a0,a0,126 # 80008568 <syscalls+0x138>
    800034f2:	ffffd097          	auipc	ra,0xffffd
    800034f6:	038080e7          	jalr	56(ra) # 8000052a <panic>

00000000800034fa <fsinit>:
fsinit(int dev) {
    800034fa:	7179                	addi	sp,sp,-48
    800034fc:	f406                	sd	ra,40(sp)
    800034fe:	f022                	sd	s0,32(sp)
    80003500:	ec26                	sd	s1,24(sp)
    80003502:	e84a                	sd	s2,16(sp)
    80003504:	e44e                	sd	s3,8(sp)
    80003506:	1800                	addi	s0,sp,48
    80003508:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000350a:	4585                	li	a1,1
    8000350c:	00000097          	auipc	ra,0x0
    80003510:	8d2080e7          	jalr	-1838(ra) # 80002dde <bread>
    80003514:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003516:	0001c997          	auipc	s3,0x1c
    8000351a:	29298993          	addi	s3,s3,658 # 8001f7a8 <sb>
    8000351e:	02000613          	li	a2,32
    80003522:	05850593          	addi	a1,a0,88
    80003526:	854e                	mv	a0,s3
    80003528:	ffffd097          	auipc	ra,0xffffd
    8000352c:	7f2080e7          	jalr	2034(ra) # 80000d1a <memmove>
  brelse(bp);
    80003530:	8526                	mv	a0,s1
    80003532:	00000097          	auipc	ra,0x0
    80003536:	9dc080e7          	jalr	-1572(ra) # 80002f0e <brelse>
  if(sb.magic != FSMAGIC)
    8000353a:	0009a703          	lw	a4,0(s3)
    8000353e:	102037b7          	lui	a5,0x10203
    80003542:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003546:	02f71263          	bne	a4,a5,8000356a <fsinit+0x70>
  initlog(dev, &sb);
    8000354a:	0001c597          	auipc	a1,0x1c
    8000354e:	25e58593          	addi	a1,a1,606 # 8001f7a8 <sb>
    80003552:	854a                	mv	a0,s2
    80003554:	00001097          	auipc	ra,0x1
    80003558:	d1e080e7          	jalr	-738(ra) # 80004272 <initlog>
}
    8000355c:	70a2                	ld	ra,40(sp)
    8000355e:	7402                	ld	s0,32(sp)
    80003560:	64e2                	ld	s1,24(sp)
    80003562:	6942                	ld	s2,16(sp)
    80003564:	69a2                	ld	s3,8(sp)
    80003566:	6145                	addi	sp,sp,48
    80003568:	8082                	ret
    panic("invalid file system");
    8000356a:	00005517          	auipc	a0,0x5
    8000356e:	00e50513          	addi	a0,a0,14 # 80008578 <syscalls+0x148>
    80003572:	ffffd097          	auipc	ra,0xffffd
    80003576:	fb8080e7          	jalr	-72(ra) # 8000052a <panic>

000000008000357a <iinit>:
{
    8000357a:	7179                	addi	sp,sp,-48
    8000357c:	f406                	sd	ra,40(sp)
    8000357e:	f022                	sd	s0,32(sp)
    80003580:	ec26                	sd	s1,24(sp)
    80003582:	e84a                	sd	s2,16(sp)
    80003584:	e44e                	sd	s3,8(sp)
    80003586:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003588:	00005597          	auipc	a1,0x5
    8000358c:	00858593          	addi	a1,a1,8 # 80008590 <syscalls+0x160>
    80003590:	0001c517          	auipc	a0,0x1c
    80003594:	23850513          	addi	a0,a0,568 # 8001f7c8 <itable>
    80003598:	ffffd097          	auipc	ra,0xffffd
    8000359c:	59a080e7          	jalr	1434(ra) # 80000b32 <initlock>
  for(i = 0; i < NINODE; i++) {
    800035a0:	0001c497          	auipc	s1,0x1c
    800035a4:	25048493          	addi	s1,s1,592 # 8001f7f0 <itable+0x28>
    800035a8:	0001e997          	auipc	s3,0x1e
    800035ac:	cd898993          	addi	s3,s3,-808 # 80021280 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800035b0:	00005917          	auipc	s2,0x5
    800035b4:	fe890913          	addi	s2,s2,-24 # 80008598 <syscalls+0x168>
    800035b8:	85ca                	mv	a1,s2
    800035ba:	8526                	mv	a0,s1
    800035bc:	00001097          	auipc	ra,0x1
    800035c0:	018080e7          	jalr	24(ra) # 800045d4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800035c4:	08848493          	addi	s1,s1,136
    800035c8:	ff3498e3          	bne	s1,s3,800035b8 <iinit+0x3e>
}
    800035cc:	70a2                	ld	ra,40(sp)
    800035ce:	7402                	ld	s0,32(sp)
    800035d0:	64e2                	ld	s1,24(sp)
    800035d2:	6942                	ld	s2,16(sp)
    800035d4:	69a2                	ld	s3,8(sp)
    800035d6:	6145                	addi	sp,sp,48
    800035d8:	8082                	ret

00000000800035da <ialloc>:
{
    800035da:	715d                	addi	sp,sp,-80
    800035dc:	e486                	sd	ra,72(sp)
    800035de:	e0a2                	sd	s0,64(sp)
    800035e0:	fc26                	sd	s1,56(sp)
    800035e2:	f84a                	sd	s2,48(sp)
    800035e4:	f44e                	sd	s3,40(sp)
    800035e6:	f052                	sd	s4,32(sp)
    800035e8:	ec56                	sd	s5,24(sp)
    800035ea:	e85a                	sd	s6,16(sp)
    800035ec:	e45e                	sd	s7,8(sp)
    800035ee:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800035f0:	0001c717          	auipc	a4,0x1c
    800035f4:	1c472703          	lw	a4,452(a4) # 8001f7b4 <sb+0xc>
    800035f8:	4785                	li	a5,1
    800035fa:	04e7fa63          	bgeu	a5,a4,8000364e <ialloc+0x74>
    800035fe:	8aaa                	mv	s5,a0
    80003600:	8bae                	mv	s7,a1
    80003602:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003604:	0001ca17          	auipc	s4,0x1c
    80003608:	1a4a0a13          	addi	s4,s4,420 # 8001f7a8 <sb>
    8000360c:	00048b1b          	sext.w	s6,s1
    80003610:	0044d793          	srli	a5,s1,0x4
    80003614:	018a2583          	lw	a1,24(s4)
    80003618:	9dbd                	addw	a1,a1,a5
    8000361a:	8556                	mv	a0,s5
    8000361c:	fffff097          	auipc	ra,0xfffff
    80003620:	7c2080e7          	jalr	1986(ra) # 80002dde <bread>
    80003624:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003626:	05850993          	addi	s3,a0,88
    8000362a:	00f4f793          	andi	a5,s1,15
    8000362e:	079a                	slli	a5,a5,0x6
    80003630:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003632:	00099783          	lh	a5,0(s3)
    80003636:	c785                	beqz	a5,8000365e <ialloc+0x84>
    brelse(bp);
    80003638:	00000097          	auipc	ra,0x0
    8000363c:	8d6080e7          	jalr	-1834(ra) # 80002f0e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003640:	0485                	addi	s1,s1,1
    80003642:	00ca2703          	lw	a4,12(s4)
    80003646:	0004879b          	sext.w	a5,s1
    8000364a:	fce7e1e3          	bltu	a5,a4,8000360c <ialloc+0x32>
  panic("ialloc: no inodes");
    8000364e:	00005517          	auipc	a0,0x5
    80003652:	f5250513          	addi	a0,a0,-174 # 800085a0 <syscalls+0x170>
    80003656:	ffffd097          	auipc	ra,0xffffd
    8000365a:	ed4080e7          	jalr	-300(ra) # 8000052a <panic>
      memset(dip, 0, sizeof(*dip));
    8000365e:	04000613          	li	a2,64
    80003662:	4581                	li	a1,0
    80003664:	854e                	mv	a0,s3
    80003666:	ffffd097          	auipc	ra,0xffffd
    8000366a:	658080e7          	jalr	1624(ra) # 80000cbe <memset>
      dip->type = type;
    8000366e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003672:	854a                	mv	a0,s2
    80003674:	00001097          	auipc	ra,0x1
    80003678:	e7a080e7          	jalr	-390(ra) # 800044ee <log_write>
      brelse(bp);
    8000367c:	854a                	mv	a0,s2
    8000367e:	00000097          	auipc	ra,0x0
    80003682:	890080e7          	jalr	-1904(ra) # 80002f0e <brelse>
      return iget(dev, inum);
    80003686:	85da                	mv	a1,s6
    80003688:	8556                	mv	a0,s5
    8000368a:	00000097          	auipc	ra,0x0
    8000368e:	db4080e7          	jalr	-588(ra) # 8000343e <iget>
}
    80003692:	60a6                	ld	ra,72(sp)
    80003694:	6406                	ld	s0,64(sp)
    80003696:	74e2                	ld	s1,56(sp)
    80003698:	7942                	ld	s2,48(sp)
    8000369a:	79a2                	ld	s3,40(sp)
    8000369c:	7a02                	ld	s4,32(sp)
    8000369e:	6ae2                	ld	s5,24(sp)
    800036a0:	6b42                	ld	s6,16(sp)
    800036a2:	6ba2                	ld	s7,8(sp)
    800036a4:	6161                	addi	sp,sp,80
    800036a6:	8082                	ret

00000000800036a8 <iupdate>:
{
    800036a8:	1101                	addi	sp,sp,-32
    800036aa:	ec06                	sd	ra,24(sp)
    800036ac:	e822                	sd	s0,16(sp)
    800036ae:	e426                	sd	s1,8(sp)
    800036b0:	e04a                	sd	s2,0(sp)
    800036b2:	1000                	addi	s0,sp,32
    800036b4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800036b6:	415c                	lw	a5,4(a0)
    800036b8:	0047d79b          	srliw	a5,a5,0x4
    800036bc:	0001c597          	auipc	a1,0x1c
    800036c0:	1045a583          	lw	a1,260(a1) # 8001f7c0 <sb+0x18>
    800036c4:	9dbd                	addw	a1,a1,a5
    800036c6:	4108                	lw	a0,0(a0)
    800036c8:	fffff097          	auipc	ra,0xfffff
    800036cc:	716080e7          	jalr	1814(ra) # 80002dde <bread>
    800036d0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800036d2:	05850793          	addi	a5,a0,88
    800036d6:	40c8                	lw	a0,4(s1)
    800036d8:	893d                	andi	a0,a0,15
    800036da:	051a                	slli	a0,a0,0x6
    800036dc:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800036de:	04449703          	lh	a4,68(s1)
    800036e2:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800036e6:	04649703          	lh	a4,70(s1)
    800036ea:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800036ee:	04849703          	lh	a4,72(s1)
    800036f2:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800036f6:	04a49703          	lh	a4,74(s1)
    800036fa:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800036fe:	44f8                	lw	a4,76(s1)
    80003700:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003702:	03400613          	li	a2,52
    80003706:	05048593          	addi	a1,s1,80
    8000370a:	0531                	addi	a0,a0,12
    8000370c:	ffffd097          	auipc	ra,0xffffd
    80003710:	60e080e7          	jalr	1550(ra) # 80000d1a <memmove>
  log_write(bp);
    80003714:	854a                	mv	a0,s2
    80003716:	00001097          	auipc	ra,0x1
    8000371a:	dd8080e7          	jalr	-552(ra) # 800044ee <log_write>
  brelse(bp);
    8000371e:	854a                	mv	a0,s2
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	7ee080e7          	jalr	2030(ra) # 80002f0e <brelse>
}
    80003728:	60e2                	ld	ra,24(sp)
    8000372a:	6442                	ld	s0,16(sp)
    8000372c:	64a2                	ld	s1,8(sp)
    8000372e:	6902                	ld	s2,0(sp)
    80003730:	6105                	addi	sp,sp,32
    80003732:	8082                	ret

0000000080003734 <idup>:
{
    80003734:	1101                	addi	sp,sp,-32
    80003736:	ec06                	sd	ra,24(sp)
    80003738:	e822                	sd	s0,16(sp)
    8000373a:	e426                	sd	s1,8(sp)
    8000373c:	1000                	addi	s0,sp,32
    8000373e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003740:	0001c517          	auipc	a0,0x1c
    80003744:	08850513          	addi	a0,a0,136 # 8001f7c8 <itable>
    80003748:	ffffd097          	auipc	ra,0xffffd
    8000374c:	47a080e7          	jalr	1146(ra) # 80000bc2 <acquire>
  ip->ref++;
    80003750:	449c                	lw	a5,8(s1)
    80003752:	2785                	addiw	a5,a5,1
    80003754:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003756:	0001c517          	auipc	a0,0x1c
    8000375a:	07250513          	addi	a0,a0,114 # 8001f7c8 <itable>
    8000375e:	ffffd097          	auipc	ra,0xffffd
    80003762:	518080e7          	jalr	1304(ra) # 80000c76 <release>
}
    80003766:	8526                	mv	a0,s1
    80003768:	60e2                	ld	ra,24(sp)
    8000376a:	6442                	ld	s0,16(sp)
    8000376c:	64a2                	ld	s1,8(sp)
    8000376e:	6105                	addi	sp,sp,32
    80003770:	8082                	ret

0000000080003772 <ilock>:
{
    80003772:	1101                	addi	sp,sp,-32
    80003774:	ec06                	sd	ra,24(sp)
    80003776:	e822                	sd	s0,16(sp)
    80003778:	e426                	sd	s1,8(sp)
    8000377a:	e04a                	sd	s2,0(sp)
    8000377c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000377e:	c115                	beqz	a0,800037a2 <ilock+0x30>
    80003780:	84aa                	mv	s1,a0
    80003782:	451c                	lw	a5,8(a0)
    80003784:	00f05f63          	blez	a5,800037a2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003788:	0541                	addi	a0,a0,16
    8000378a:	00001097          	auipc	ra,0x1
    8000378e:	e84080e7          	jalr	-380(ra) # 8000460e <acquiresleep>
  if(ip->valid == 0){
    80003792:	40bc                	lw	a5,64(s1)
    80003794:	cf99                	beqz	a5,800037b2 <ilock+0x40>
}
    80003796:	60e2                	ld	ra,24(sp)
    80003798:	6442                	ld	s0,16(sp)
    8000379a:	64a2                	ld	s1,8(sp)
    8000379c:	6902                	ld	s2,0(sp)
    8000379e:	6105                	addi	sp,sp,32
    800037a0:	8082                	ret
    panic("ilock");
    800037a2:	00005517          	auipc	a0,0x5
    800037a6:	e1650513          	addi	a0,a0,-490 # 800085b8 <syscalls+0x188>
    800037aa:	ffffd097          	auipc	ra,0xffffd
    800037ae:	d80080e7          	jalr	-640(ra) # 8000052a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037b2:	40dc                	lw	a5,4(s1)
    800037b4:	0047d79b          	srliw	a5,a5,0x4
    800037b8:	0001c597          	auipc	a1,0x1c
    800037bc:	0085a583          	lw	a1,8(a1) # 8001f7c0 <sb+0x18>
    800037c0:	9dbd                	addw	a1,a1,a5
    800037c2:	4088                	lw	a0,0(s1)
    800037c4:	fffff097          	auipc	ra,0xfffff
    800037c8:	61a080e7          	jalr	1562(ra) # 80002dde <bread>
    800037cc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037ce:	05850593          	addi	a1,a0,88
    800037d2:	40dc                	lw	a5,4(s1)
    800037d4:	8bbd                	andi	a5,a5,15
    800037d6:	079a                	slli	a5,a5,0x6
    800037d8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800037da:	00059783          	lh	a5,0(a1)
    800037de:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800037e2:	00259783          	lh	a5,2(a1)
    800037e6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800037ea:	00459783          	lh	a5,4(a1)
    800037ee:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800037f2:	00659783          	lh	a5,6(a1)
    800037f6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800037fa:	459c                	lw	a5,8(a1)
    800037fc:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800037fe:	03400613          	li	a2,52
    80003802:	05b1                	addi	a1,a1,12
    80003804:	05048513          	addi	a0,s1,80
    80003808:	ffffd097          	auipc	ra,0xffffd
    8000380c:	512080e7          	jalr	1298(ra) # 80000d1a <memmove>
    brelse(bp);
    80003810:	854a                	mv	a0,s2
    80003812:	fffff097          	auipc	ra,0xfffff
    80003816:	6fc080e7          	jalr	1788(ra) # 80002f0e <brelse>
    ip->valid = 1;
    8000381a:	4785                	li	a5,1
    8000381c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000381e:	04449783          	lh	a5,68(s1)
    80003822:	fbb5                	bnez	a5,80003796 <ilock+0x24>
      panic("ilock: no type");
    80003824:	00005517          	auipc	a0,0x5
    80003828:	d9c50513          	addi	a0,a0,-612 # 800085c0 <syscalls+0x190>
    8000382c:	ffffd097          	auipc	ra,0xffffd
    80003830:	cfe080e7          	jalr	-770(ra) # 8000052a <panic>

0000000080003834 <iunlock>:
{
    80003834:	1101                	addi	sp,sp,-32
    80003836:	ec06                	sd	ra,24(sp)
    80003838:	e822                	sd	s0,16(sp)
    8000383a:	e426                	sd	s1,8(sp)
    8000383c:	e04a                	sd	s2,0(sp)
    8000383e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003840:	c905                	beqz	a0,80003870 <iunlock+0x3c>
    80003842:	84aa                	mv	s1,a0
    80003844:	01050913          	addi	s2,a0,16
    80003848:	854a                	mv	a0,s2
    8000384a:	00001097          	auipc	ra,0x1
    8000384e:	e5e080e7          	jalr	-418(ra) # 800046a8 <holdingsleep>
    80003852:	cd19                	beqz	a0,80003870 <iunlock+0x3c>
    80003854:	449c                	lw	a5,8(s1)
    80003856:	00f05d63          	blez	a5,80003870 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000385a:	854a                	mv	a0,s2
    8000385c:	00001097          	auipc	ra,0x1
    80003860:	e08080e7          	jalr	-504(ra) # 80004664 <releasesleep>
}
    80003864:	60e2                	ld	ra,24(sp)
    80003866:	6442                	ld	s0,16(sp)
    80003868:	64a2                	ld	s1,8(sp)
    8000386a:	6902                	ld	s2,0(sp)
    8000386c:	6105                	addi	sp,sp,32
    8000386e:	8082                	ret
    panic("iunlock");
    80003870:	00005517          	auipc	a0,0x5
    80003874:	d6050513          	addi	a0,a0,-672 # 800085d0 <syscalls+0x1a0>
    80003878:	ffffd097          	auipc	ra,0xffffd
    8000387c:	cb2080e7          	jalr	-846(ra) # 8000052a <panic>

0000000080003880 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003880:	715d                	addi	sp,sp,-80
    80003882:	e486                	sd	ra,72(sp)
    80003884:	e0a2                	sd	s0,64(sp)
    80003886:	fc26                	sd	s1,56(sp)
    80003888:	f84a                	sd	s2,48(sp)
    8000388a:	f44e                	sd	s3,40(sp)
    8000388c:	f052                	sd	s4,32(sp)
    8000388e:	ec56                	sd	s5,24(sp)
    80003890:	e85a                	sd	s6,16(sp)
    80003892:	e45e                	sd	s7,8(sp)
    80003894:	e062                	sd	s8,0(sp)
    80003896:	0880                	addi	s0,sp,80
    80003898:	89aa                	mv	s3,a0
  // so that it can handle doubly indrect inode.
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000389a:	05050493          	addi	s1,a0,80
    8000389e:	07c50913          	addi	s2,a0,124
    800038a2:	a021                	j	800038aa <itrunc+0x2a>
    800038a4:	0491                	addi	s1,s1,4
    800038a6:	01248d63          	beq	s1,s2,800038c0 <itrunc+0x40>
    if(ip->addrs[i]){
    800038aa:	408c                	lw	a1,0(s1)
    800038ac:	dde5                	beqz	a1,800038a4 <itrunc+0x24>
      bfree(ip->dev, ip->addrs[i]);
    800038ae:	0009a503          	lw	a0,0(s3)
    800038b2:	fffff097          	auipc	ra,0xfffff
    800038b6:	772080e7          	jalr	1906(ra) # 80003024 <bfree>
      ip->addrs[i] = 0;
    800038ba:	0004a023          	sw	zero,0(s1)
    800038be:	b7dd                	j	800038a4 <itrunc+0x24>
    }
  }

  if(ip->addrs[NDIRECT]){
    800038c0:	07c9a583          	lw	a1,124(s3)
    800038c4:	e59d                	bnez	a1,800038f2 <itrunc+0x72>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  if(ip->addrs[NDIRECT+1]){
    800038c6:	0809a583          	lw	a1,128(s3)
    800038ca:	ede9                	bnez	a1,800039a4 <itrunc+0x124>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    ip->addrs[NDIRECT+1] = 0;
  }

  ip->size = 0;
    800038cc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800038d0:	854e                	mv	a0,s3
    800038d2:	00000097          	auipc	ra,0x0
    800038d6:	dd6080e7          	jalr	-554(ra) # 800036a8 <iupdate>
}
    800038da:	60a6                	ld	ra,72(sp)
    800038dc:	6406                	ld	s0,64(sp)
    800038de:	74e2                	ld	s1,56(sp)
    800038e0:	7942                	ld	s2,48(sp)
    800038e2:	79a2                	ld	s3,40(sp)
    800038e4:	7a02                	ld	s4,32(sp)
    800038e6:	6ae2                	ld	s5,24(sp)
    800038e8:	6b42                	ld	s6,16(sp)
    800038ea:	6ba2                	ld	s7,8(sp)
    800038ec:	6c02                	ld	s8,0(sp)
    800038ee:	6161                	addi	sp,sp,80
    800038f0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038f2:	0009a503          	lw	a0,0(s3)
    800038f6:	fffff097          	auipc	ra,0xfffff
    800038fa:	4e8080e7          	jalr	1256(ra) # 80002dde <bread>
    800038fe:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT-4; j++){
    80003900:	05850493          	addi	s1,a0,88
    80003904:	44850913          	addi	s2,a0,1096
    80003908:	a021                	j	80003910 <itrunc+0x90>
    8000390a:	0491                	addi	s1,s1,4
    8000390c:	01248b63          	beq	s1,s2,80003922 <itrunc+0xa2>
      if(a[j])
    80003910:	408c                	lw	a1,0(s1)
    80003912:	dde5                	beqz	a1,8000390a <itrunc+0x8a>
        bfree(ip->dev, a[j]);
    80003914:	0009a503          	lw	a0,0(s3)
    80003918:	fffff097          	auipc	ra,0xfffff
    8000391c:	70c080e7          	jalr	1804(ra) # 80003024 <bfree>
    80003920:	b7ed                	j	8000390a <itrunc+0x8a>
    80003922:	448a8a13          	addi	s4,s5,1096
    80003926:	458a8b93          	addi	s7,s5,1112
      if(a[j+252]){
    8000392a:	8c52                	mv	s8,s4
    8000392c:	000a2583          	lw	a1,0(s4)
    80003930:	e585                	bnez	a1,80003958 <itrunc+0xd8>
    for(j = 0; j < 4; j++){
    80003932:	0a11                	addi	s4,s4,4
    80003934:	ff7a1be3          	bne	s4,s7,8000392a <itrunc+0xaa>
    brelse(bp);
    80003938:	8556                	mv	a0,s5
    8000393a:	fffff097          	auipc	ra,0xfffff
    8000393e:	5d4080e7          	jalr	1492(ra) # 80002f0e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003942:	07c9a583          	lw	a1,124(s3)
    80003946:	0009a503          	lw	a0,0(s3)
    8000394a:	fffff097          	auipc	ra,0xfffff
    8000394e:	6da080e7          	jalr	1754(ra) # 80003024 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003952:	0609ae23          	sw	zero,124(s3)
    80003956:	bf85                	j	800038c6 <itrunc+0x46>
        struct buf *bbp = bread(ip->dev, a[j+252]);
    80003958:	0009a503          	lw	a0,0(s3)
    8000395c:	fffff097          	auipc	ra,0xfffff
    80003960:	482080e7          	jalr	1154(ra) # 80002dde <bread>
    80003964:	8b2a                	mv	s6,a0
        for(int k=0; k < 256; k++){
    80003966:	05850493          	addi	s1,a0,88
    8000396a:	45850913          	addi	s2,a0,1112
    8000396e:	a021                	j	80003976 <itrunc+0xf6>
    80003970:	0491                	addi	s1,s1,4
    80003972:	01248b63          	beq	s1,s2,80003988 <itrunc+0x108>
          if(b[k])
    80003976:	408c                	lw	a1,0(s1)
    80003978:	dde5                	beqz	a1,80003970 <itrunc+0xf0>
            bfree(ip->dev, b[k]);
    8000397a:	0009a503          	lw	a0,0(s3)
    8000397e:	fffff097          	auipc	ra,0xfffff
    80003982:	6a6080e7          	jalr	1702(ra) # 80003024 <bfree>
    80003986:	b7ed                	j	80003970 <itrunc+0xf0>
        brelse(bbp);
    80003988:	855a                	mv	a0,s6
    8000398a:	fffff097          	auipc	ra,0xfffff
    8000398e:	584080e7          	jalr	1412(ra) # 80002f0e <brelse>
        bfree(ip->dev, a[j+252]);
    80003992:	000c2583          	lw	a1,0(s8)
    80003996:	0009a503          	lw	a0,0(s3)
    8000399a:	fffff097          	auipc	ra,0xfffff
    8000399e:	68a080e7          	jalr	1674(ra) # 80003024 <bfree>
    800039a2:	bf41                	j	80003932 <itrunc+0xb2>
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
    800039a4:	0009a503          	lw	a0,0(s3)
    800039a8:	fffff097          	auipc	ra,0xfffff
    800039ac:	436080e7          	jalr	1078(ra) # 80002dde <bread>
    800039b0:	8c2a                	mv	s8,a0
    for(j = 0; j < 256; j++){
    800039b2:	05850a13          	addi	s4,a0,88
    800039b6:	45850b13          	addi	s6,a0,1112
    800039ba:	a82d                	j	800039f4 <itrunc+0x174>
        for(int k=0; k < 256; k++){
    800039bc:	0491                	addi	s1,s1,4
    800039be:	00990b63          	beq	s2,s1,800039d4 <itrunc+0x154>
          if(b[k])
    800039c2:	408c                	lw	a1,0(s1)
    800039c4:	dde5                	beqz	a1,800039bc <itrunc+0x13c>
            bfree(ip->dev, b[k]);
    800039c6:	0009a503          	lw	a0,0(s3)
    800039ca:	fffff097          	auipc	ra,0xfffff
    800039ce:	65a080e7          	jalr	1626(ra) # 80003024 <bfree>
    800039d2:	b7ed                	j	800039bc <itrunc+0x13c>
        brelse(bbp);
    800039d4:	855e                	mv	a0,s7
    800039d6:	fffff097          	auipc	ra,0xfffff
    800039da:	538080e7          	jalr	1336(ra) # 80002f0e <brelse>
        bfree(ip->dev, a[j]);
    800039de:	000aa583          	lw	a1,0(s5)
    800039e2:	0009a503          	lw	a0,0(s3)
    800039e6:	fffff097          	auipc	ra,0xfffff
    800039ea:	63e080e7          	jalr	1598(ra) # 80003024 <bfree>
    for(j = 0; j < 256; j++){
    800039ee:	0a11                	addi	s4,s4,4
    800039f0:	036a0263          	beq	s4,s6,80003a14 <itrunc+0x194>
      if(a[j]){
    800039f4:	8ad2                	mv	s5,s4
    800039f6:	000a2583          	lw	a1,0(s4)
    800039fa:	d9f5                	beqz	a1,800039ee <itrunc+0x16e>
        struct buf *bbp = bread(ip->dev, a[j]);
    800039fc:	0009a503          	lw	a0,0(s3)
    80003a00:	fffff097          	auipc	ra,0xfffff
    80003a04:	3de080e7          	jalr	990(ra) # 80002dde <bread>
    80003a08:	8baa                	mv	s7,a0
        for(int k=0; k < 256; k++){
    80003a0a:	05850493          	addi	s1,a0,88
    80003a0e:	45850913          	addi	s2,a0,1112
    80003a12:	bf45                	j	800039c2 <itrunc+0x142>
    brelse(bp);
    80003a14:	8562                	mv	a0,s8
    80003a16:	fffff097          	auipc	ra,0xfffff
    80003a1a:	4f8080e7          	jalr	1272(ra) # 80002f0e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    80003a1e:	0809a583          	lw	a1,128(s3)
    80003a22:	0009a503          	lw	a0,0(s3)
    80003a26:	fffff097          	auipc	ra,0xfffff
    80003a2a:	5fe080e7          	jalr	1534(ra) # 80003024 <bfree>
    ip->addrs[NDIRECT+1] = 0;
    80003a2e:	0809a023          	sw	zero,128(s3)
    80003a32:	bd69                	j	800038cc <itrunc+0x4c>

0000000080003a34 <iput>:
{
    80003a34:	1101                	addi	sp,sp,-32
    80003a36:	ec06                	sd	ra,24(sp)
    80003a38:	e822                	sd	s0,16(sp)
    80003a3a:	e426                	sd	s1,8(sp)
    80003a3c:	e04a                	sd	s2,0(sp)
    80003a3e:	1000                	addi	s0,sp,32
    80003a40:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a42:	0001c517          	auipc	a0,0x1c
    80003a46:	d8650513          	addi	a0,a0,-634 # 8001f7c8 <itable>
    80003a4a:	ffffd097          	auipc	ra,0xffffd
    80003a4e:	178080e7          	jalr	376(ra) # 80000bc2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a52:	4498                	lw	a4,8(s1)
    80003a54:	4785                	li	a5,1
    80003a56:	02f70363          	beq	a4,a5,80003a7c <iput+0x48>
  ip->ref--;
    80003a5a:	449c                	lw	a5,8(s1)
    80003a5c:	37fd                	addiw	a5,a5,-1
    80003a5e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a60:	0001c517          	auipc	a0,0x1c
    80003a64:	d6850513          	addi	a0,a0,-664 # 8001f7c8 <itable>
    80003a68:	ffffd097          	auipc	ra,0xffffd
    80003a6c:	20e080e7          	jalr	526(ra) # 80000c76 <release>
}
    80003a70:	60e2                	ld	ra,24(sp)
    80003a72:	6442                	ld	s0,16(sp)
    80003a74:	64a2                	ld	s1,8(sp)
    80003a76:	6902                	ld	s2,0(sp)
    80003a78:	6105                	addi	sp,sp,32
    80003a7a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a7c:	40bc                	lw	a5,64(s1)
    80003a7e:	dff1                	beqz	a5,80003a5a <iput+0x26>
    80003a80:	04a49783          	lh	a5,74(s1)
    80003a84:	fbf9                	bnez	a5,80003a5a <iput+0x26>
    acquiresleep(&ip->lock);
    80003a86:	01048913          	addi	s2,s1,16
    80003a8a:	854a                	mv	a0,s2
    80003a8c:	00001097          	auipc	ra,0x1
    80003a90:	b82080e7          	jalr	-1150(ra) # 8000460e <acquiresleep>
    release(&itable.lock);
    80003a94:	0001c517          	auipc	a0,0x1c
    80003a98:	d3450513          	addi	a0,a0,-716 # 8001f7c8 <itable>
    80003a9c:	ffffd097          	auipc	ra,0xffffd
    80003aa0:	1da080e7          	jalr	474(ra) # 80000c76 <release>
    itrunc(ip);
    80003aa4:	8526                	mv	a0,s1
    80003aa6:	00000097          	auipc	ra,0x0
    80003aaa:	dda080e7          	jalr	-550(ra) # 80003880 <itrunc>
    ip->type = 0;
    80003aae:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003ab2:	8526                	mv	a0,s1
    80003ab4:	00000097          	auipc	ra,0x0
    80003ab8:	bf4080e7          	jalr	-1036(ra) # 800036a8 <iupdate>
    ip->valid = 0;
    80003abc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003ac0:	854a                	mv	a0,s2
    80003ac2:	00001097          	auipc	ra,0x1
    80003ac6:	ba2080e7          	jalr	-1118(ra) # 80004664 <releasesleep>
    acquire(&itable.lock);
    80003aca:	0001c517          	auipc	a0,0x1c
    80003ace:	cfe50513          	addi	a0,a0,-770 # 8001f7c8 <itable>
    80003ad2:	ffffd097          	auipc	ra,0xffffd
    80003ad6:	0f0080e7          	jalr	240(ra) # 80000bc2 <acquire>
    80003ada:	b741                	j	80003a5a <iput+0x26>

0000000080003adc <iunlockput>:
{
    80003adc:	1101                	addi	sp,sp,-32
    80003ade:	ec06                	sd	ra,24(sp)
    80003ae0:	e822                	sd	s0,16(sp)
    80003ae2:	e426                	sd	s1,8(sp)
    80003ae4:	1000                	addi	s0,sp,32
    80003ae6:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ae8:	00000097          	auipc	ra,0x0
    80003aec:	d4c080e7          	jalr	-692(ra) # 80003834 <iunlock>
  iput(ip);
    80003af0:	8526                	mv	a0,s1
    80003af2:	00000097          	auipc	ra,0x0
    80003af6:	f42080e7          	jalr	-190(ra) # 80003a34 <iput>
}
    80003afa:	60e2                	ld	ra,24(sp)
    80003afc:	6442                	ld	s0,16(sp)
    80003afe:	64a2                	ld	s1,8(sp)
    80003b00:	6105                	addi	sp,sp,32
    80003b02:	8082                	ret

0000000080003b04 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003b04:	1141                	addi	sp,sp,-16
    80003b06:	e422                	sd	s0,8(sp)
    80003b08:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003b0a:	411c                	lw	a5,0(a0)
    80003b0c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003b0e:	415c                	lw	a5,4(a0)
    80003b10:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003b12:	04451783          	lh	a5,68(a0)
    80003b16:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003b1a:	04a51783          	lh	a5,74(a0)
    80003b1e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003b22:	04c56783          	lwu	a5,76(a0)
    80003b26:	e99c                	sd	a5,16(a1)
}
    80003b28:	6422                	ld	s0,8(sp)
    80003b2a:	0141                	addi	sp,sp,16
    80003b2c:	8082                	ret

0000000080003b2e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b2e:	457c                	lw	a5,76(a0)
    80003b30:	0ed7e963          	bltu	a5,a3,80003c22 <readi+0xf4>
{
    80003b34:	7159                	addi	sp,sp,-112
    80003b36:	f486                	sd	ra,104(sp)
    80003b38:	f0a2                	sd	s0,96(sp)
    80003b3a:	eca6                	sd	s1,88(sp)
    80003b3c:	e8ca                	sd	s2,80(sp)
    80003b3e:	e4ce                	sd	s3,72(sp)
    80003b40:	e0d2                	sd	s4,64(sp)
    80003b42:	fc56                	sd	s5,56(sp)
    80003b44:	f85a                	sd	s6,48(sp)
    80003b46:	f45e                	sd	s7,40(sp)
    80003b48:	f062                	sd	s8,32(sp)
    80003b4a:	ec66                	sd	s9,24(sp)
    80003b4c:	e86a                	sd	s10,16(sp)
    80003b4e:	e46e                	sd	s11,8(sp)
    80003b50:	1880                	addi	s0,sp,112
    80003b52:	8baa                	mv	s7,a0
    80003b54:	8c2e                	mv	s8,a1
    80003b56:	8ab2                	mv	s5,a2
    80003b58:	84b6                	mv	s1,a3
    80003b5a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b5c:	9f35                	addw	a4,a4,a3
    return 0;
    80003b5e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003b60:	0ad76063          	bltu	a4,a3,80003c00 <readi+0xd2>
  if(off + n > ip->size)
    80003b64:	00e7f463          	bgeu	a5,a4,80003b6c <readi+0x3e>
    n = ip->size - off;
    80003b68:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b6c:	0a0b0963          	beqz	s6,80003c1e <readi+0xf0>
    80003b70:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b72:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003b76:	5cfd                	li	s9,-1
    80003b78:	a82d                	j	80003bb2 <readi+0x84>
    80003b7a:	020a1d93          	slli	s11,s4,0x20
    80003b7e:	020ddd93          	srli	s11,s11,0x20
    80003b82:	05890793          	addi	a5,s2,88
    80003b86:	86ee                	mv	a3,s11
    80003b88:	963e                	add	a2,a2,a5
    80003b8a:	85d6                	mv	a1,s5
    80003b8c:	8562                	mv	a0,s8
    80003b8e:	fffff097          	auipc	ra,0xfffff
    80003b92:	896080e7          	jalr	-1898(ra) # 80002424 <either_copyout>
    80003b96:	05950d63          	beq	a0,s9,80003bf0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003b9a:	854a                	mv	a0,s2
    80003b9c:	fffff097          	auipc	ra,0xfffff
    80003ba0:	372080e7          	jalr	882(ra) # 80002f0e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ba4:	013a09bb          	addw	s3,s4,s3
    80003ba8:	009a04bb          	addw	s1,s4,s1
    80003bac:	9aee                	add	s5,s5,s11
    80003bae:	0569f763          	bgeu	s3,s6,80003bfc <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003bb2:	000ba903          	lw	s2,0(s7)
    80003bb6:	00a4d59b          	srliw	a1,s1,0xa
    80003bba:	855e                	mv	a0,s7
    80003bbc:	fffff097          	auipc	ra,0xfffff
    80003bc0:	616080e7          	jalr	1558(ra) # 800031d2 <bmap>
    80003bc4:	0005059b          	sext.w	a1,a0
    80003bc8:	854a                	mv	a0,s2
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	214080e7          	jalr	532(ra) # 80002dde <bread>
    80003bd2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bd4:	3ff4f613          	andi	a2,s1,1023
    80003bd8:	40cd07bb          	subw	a5,s10,a2
    80003bdc:	413b073b          	subw	a4,s6,s3
    80003be0:	8a3e                	mv	s4,a5
    80003be2:	2781                	sext.w	a5,a5
    80003be4:	0007069b          	sext.w	a3,a4
    80003be8:	f8f6f9e3          	bgeu	a3,a5,80003b7a <readi+0x4c>
    80003bec:	8a3a                	mv	s4,a4
    80003bee:	b771                	j	80003b7a <readi+0x4c>
      brelse(bp);
    80003bf0:	854a                	mv	a0,s2
    80003bf2:	fffff097          	auipc	ra,0xfffff
    80003bf6:	31c080e7          	jalr	796(ra) # 80002f0e <brelse>
      tot = -1;
    80003bfa:	59fd                	li	s3,-1
  }
  return tot;
    80003bfc:	0009851b          	sext.w	a0,s3
}
    80003c00:	70a6                	ld	ra,104(sp)
    80003c02:	7406                	ld	s0,96(sp)
    80003c04:	64e6                	ld	s1,88(sp)
    80003c06:	6946                	ld	s2,80(sp)
    80003c08:	69a6                	ld	s3,72(sp)
    80003c0a:	6a06                	ld	s4,64(sp)
    80003c0c:	7ae2                	ld	s5,56(sp)
    80003c0e:	7b42                	ld	s6,48(sp)
    80003c10:	7ba2                	ld	s7,40(sp)
    80003c12:	7c02                	ld	s8,32(sp)
    80003c14:	6ce2                	ld	s9,24(sp)
    80003c16:	6d42                	ld	s10,16(sp)
    80003c18:	6da2                	ld	s11,8(sp)
    80003c1a:	6165                	addi	sp,sp,112
    80003c1c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c1e:	89da                	mv	s3,s6
    80003c20:	bff1                	j	80003bfc <readi+0xce>
    return 0;
    80003c22:	4501                	li	a0,0
}
    80003c24:	8082                	ret

0000000080003c26 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c26:	457c                	lw	a5,76(a0)
    80003c28:	10d7e963          	bltu	a5,a3,80003d3a <writei+0x114>
{
    80003c2c:	7159                	addi	sp,sp,-112
    80003c2e:	f486                	sd	ra,104(sp)
    80003c30:	f0a2                	sd	s0,96(sp)
    80003c32:	eca6                	sd	s1,88(sp)
    80003c34:	e8ca                	sd	s2,80(sp)
    80003c36:	e4ce                	sd	s3,72(sp)
    80003c38:	e0d2                	sd	s4,64(sp)
    80003c3a:	fc56                	sd	s5,56(sp)
    80003c3c:	f85a                	sd	s6,48(sp)
    80003c3e:	f45e                	sd	s7,40(sp)
    80003c40:	f062                	sd	s8,32(sp)
    80003c42:	ec66                	sd	s9,24(sp)
    80003c44:	e86a                	sd	s10,16(sp)
    80003c46:	e46e                	sd	s11,8(sp)
    80003c48:	1880                	addi	s0,sp,112
    80003c4a:	8b2a                	mv	s6,a0
    80003c4c:	8c2e                	mv	s8,a1
    80003c4e:	8ab2                	mv	s5,a2
    80003c50:	8936                	mv	s2,a3
    80003c52:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003c54:	9f35                	addw	a4,a4,a3
    80003c56:	0ed76463          	bltu	a4,a3,80003d3e <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003c5a:	041427b7          	lui	a5,0x4142
    80003c5e:	c0078793          	addi	a5,a5,-1024 # 4141c00 <_entry-0x7bebe400>
    80003c62:	0ee7e063          	bltu	a5,a4,80003d42 <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c66:	0c0b8863          	beqz	s7,80003d36 <writei+0x110>
    80003c6a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c6c:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003c70:	5cfd                	li	s9,-1
    80003c72:	a091                	j	80003cb6 <writei+0x90>
    80003c74:	02099d93          	slli	s11,s3,0x20
    80003c78:	020ddd93          	srli	s11,s11,0x20
    80003c7c:	05848793          	addi	a5,s1,88
    80003c80:	86ee                	mv	a3,s11
    80003c82:	8656                	mv	a2,s5
    80003c84:	85e2                	mv	a1,s8
    80003c86:	953e                	add	a0,a0,a5
    80003c88:	ffffe097          	auipc	ra,0xffffe
    80003c8c:	7f2080e7          	jalr	2034(ra) # 8000247a <either_copyin>
    80003c90:	07950263          	beq	a0,s9,80003cf4 <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003c94:	8526                	mv	a0,s1
    80003c96:	00001097          	auipc	ra,0x1
    80003c9a:	858080e7          	jalr	-1960(ra) # 800044ee <log_write>
    brelse(bp);
    80003c9e:	8526                	mv	a0,s1
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	26e080e7          	jalr	622(ra) # 80002f0e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ca8:	01498a3b          	addw	s4,s3,s4
    80003cac:	0129893b          	addw	s2,s3,s2
    80003cb0:	9aee                	add	s5,s5,s11
    80003cb2:	057a7663          	bgeu	s4,s7,80003cfe <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003cb6:	000b2483          	lw	s1,0(s6)
    80003cba:	00a9559b          	srliw	a1,s2,0xa
    80003cbe:	855a                	mv	a0,s6
    80003cc0:	fffff097          	auipc	ra,0xfffff
    80003cc4:	512080e7          	jalr	1298(ra) # 800031d2 <bmap>
    80003cc8:	0005059b          	sext.w	a1,a0
    80003ccc:	8526                	mv	a0,s1
    80003cce:	fffff097          	auipc	ra,0xfffff
    80003cd2:	110080e7          	jalr	272(ra) # 80002dde <bread>
    80003cd6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003cd8:	3ff97513          	andi	a0,s2,1023
    80003cdc:	40ad07bb          	subw	a5,s10,a0
    80003ce0:	414b873b          	subw	a4,s7,s4
    80003ce4:	89be                	mv	s3,a5
    80003ce6:	2781                	sext.w	a5,a5
    80003ce8:	0007069b          	sext.w	a3,a4
    80003cec:	f8f6f4e3          	bgeu	a3,a5,80003c74 <writei+0x4e>
    80003cf0:	89ba                	mv	s3,a4
    80003cf2:	b749                	j	80003c74 <writei+0x4e>
      brelse(bp);
    80003cf4:	8526                	mv	a0,s1
    80003cf6:	fffff097          	auipc	ra,0xfffff
    80003cfa:	218080e7          	jalr	536(ra) # 80002f0e <brelse>
  }

  if(off > ip->size)
    80003cfe:	04cb2783          	lw	a5,76(s6)
    80003d02:	0127f463          	bgeu	a5,s2,80003d0a <writei+0xe4>
    ip->size = off;
    80003d06:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003d0a:	855a                	mv	a0,s6
    80003d0c:	00000097          	auipc	ra,0x0
    80003d10:	99c080e7          	jalr	-1636(ra) # 800036a8 <iupdate>

  return tot;
    80003d14:	000a051b          	sext.w	a0,s4
}
    80003d18:	70a6                	ld	ra,104(sp)
    80003d1a:	7406                	ld	s0,96(sp)
    80003d1c:	64e6                	ld	s1,88(sp)
    80003d1e:	6946                	ld	s2,80(sp)
    80003d20:	69a6                	ld	s3,72(sp)
    80003d22:	6a06                	ld	s4,64(sp)
    80003d24:	7ae2                	ld	s5,56(sp)
    80003d26:	7b42                	ld	s6,48(sp)
    80003d28:	7ba2                	ld	s7,40(sp)
    80003d2a:	7c02                	ld	s8,32(sp)
    80003d2c:	6ce2                	ld	s9,24(sp)
    80003d2e:	6d42                	ld	s10,16(sp)
    80003d30:	6da2                	ld	s11,8(sp)
    80003d32:	6165                	addi	sp,sp,112
    80003d34:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d36:	8a5e                	mv	s4,s7
    80003d38:	bfc9                	j	80003d0a <writei+0xe4>
    return -1;
    80003d3a:	557d                	li	a0,-1
}
    80003d3c:	8082                	ret
    return -1;
    80003d3e:	557d                	li	a0,-1
    80003d40:	bfe1                	j	80003d18 <writei+0xf2>
    return -1;
    80003d42:	557d                	li	a0,-1
    80003d44:	bfd1                	j	80003d18 <writei+0xf2>

0000000080003d46 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003d46:	1141                	addi	sp,sp,-16
    80003d48:	e406                	sd	ra,8(sp)
    80003d4a:	e022                	sd	s0,0(sp)
    80003d4c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003d4e:	4639                	li	a2,14
    80003d50:	ffffd097          	auipc	ra,0xffffd
    80003d54:	046080e7          	jalr	70(ra) # 80000d96 <strncmp>
}
    80003d58:	60a2                	ld	ra,8(sp)
    80003d5a:	6402                	ld	s0,0(sp)
    80003d5c:	0141                	addi	sp,sp,16
    80003d5e:	8082                	ret

0000000080003d60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003d60:	7139                	addi	sp,sp,-64
    80003d62:	fc06                	sd	ra,56(sp)
    80003d64:	f822                	sd	s0,48(sp)
    80003d66:	f426                	sd	s1,40(sp)
    80003d68:	f04a                	sd	s2,32(sp)
    80003d6a:	ec4e                	sd	s3,24(sp)
    80003d6c:	e852                	sd	s4,16(sp)
    80003d6e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003d70:	04451703          	lh	a4,68(a0)
    80003d74:	4785                	li	a5,1
    80003d76:	00f71a63          	bne	a4,a5,80003d8a <dirlookup+0x2a>
    80003d7a:	892a                	mv	s2,a0
    80003d7c:	89ae                	mv	s3,a1
    80003d7e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d80:	457c                	lw	a5,76(a0)
    80003d82:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003d84:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d86:	e79d                	bnez	a5,80003db4 <dirlookup+0x54>
    80003d88:	a8a5                	j	80003e00 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003d8a:	00005517          	auipc	a0,0x5
    80003d8e:	84e50513          	addi	a0,a0,-1970 # 800085d8 <syscalls+0x1a8>
    80003d92:	ffffc097          	auipc	ra,0xffffc
    80003d96:	798080e7          	jalr	1944(ra) # 8000052a <panic>
      panic("dirlookup read");
    80003d9a:	00005517          	auipc	a0,0x5
    80003d9e:	85650513          	addi	a0,a0,-1962 # 800085f0 <syscalls+0x1c0>
    80003da2:	ffffc097          	auipc	ra,0xffffc
    80003da6:	788080e7          	jalr	1928(ra) # 8000052a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003daa:	24c1                	addiw	s1,s1,16
    80003dac:	04c92783          	lw	a5,76(s2)
    80003db0:	04f4f763          	bgeu	s1,a5,80003dfe <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003db4:	4741                	li	a4,16
    80003db6:	86a6                	mv	a3,s1
    80003db8:	fc040613          	addi	a2,s0,-64
    80003dbc:	4581                	li	a1,0
    80003dbe:	854a                	mv	a0,s2
    80003dc0:	00000097          	auipc	ra,0x0
    80003dc4:	d6e080e7          	jalr	-658(ra) # 80003b2e <readi>
    80003dc8:	47c1                	li	a5,16
    80003dca:	fcf518e3          	bne	a0,a5,80003d9a <dirlookup+0x3a>
    if(de.inum == 0)
    80003dce:	fc045783          	lhu	a5,-64(s0)
    80003dd2:	dfe1                	beqz	a5,80003daa <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003dd4:	fc240593          	addi	a1,s0,-62
    80003dd8:	854e                	mv	a0,s3
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	f6c080e7          	jalr	-148(ra) # 80003d46 <namecmp>
    80003de2:	f561                	bnez	a0,80003daa <dirlookup+0x4a>
      if(poff)
    80003de4:	000a0463          	beqz	s4,80003dec <dirlookup+0x8c>
        *poff = off;
    80003de8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003dec:	fc045583          	lhu	a1,-64(s0)
    80003df0:	00092503          	lw	a0,0(s2)
    80003df4:	fffff097          	auipc	ra,0xfffff
    80003df8:	64a080e7          	jalr	1610(ra) # 8000343e <iget>
    80003dfc:	a011                	j	80003e00 <dirlookup+0xa0>
  return 0;
    80003dfe:	4501                	li	a0,0
}
    80003e00:	70e2                	ld	ra,56(sp)
    80003e02:	7442                	ld	s0,48(sp)
    80003e04:	74a2                	ld	s1,40(sp)
    80003e06:	7902                	ld	s2,32(sp)
    80003e08:	69e2                	ld	s3,24(sp)
    80003e0a:	6a42                	ld	s4,16(sp)
    80003e0c:	6121                	addi	sp,sp,64
    80003e0e:	8082                	ret

0000000080003e10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003e10:	7109                	addi	sp,sp,-384
    80003e12:	fe86                	sd	ra,376(sp)
    80003e14:	faa2                	sd	s0,368(sp)
    80003e16:	f6a6                	sd	s1,360(sp)
    80003e18:	f2ca                	sd	s2,352(sp)
    80003e1a:	eece                	sd	s3,344(sp)
    80003e1c:	ead2                	sd	s4,336(sp)
    80003e1e:	e6d6                	sd	s5,328(sp)
    80003e20:	e2da                	sd	s6,320(sp)
    80003e22:	fe5e                	sd	s7,312(sp)
    80003e24:	fa62                	sd	s8,304(sp)
    80003e26:	f666                	sd	s9,296(sp)
    80003e28:	f26a                	sd	s10,288(sp)
    80003e2a:	ee6e                	sd	s11,280(sp)
    80003e2c:	0300                	addi	s0,sp,384
    80003e2e:	84aa                	mv	s1,a0
    80003e30:	e8a43423          	sd	a0,-376(s0)
    80003e34:	8b2e                	mv	s6,a1
    80003e36:	8ab2                	mv	s5,a2
  // Modify this function to deal with symbolic links to directories.
  struct inode *ip, *next;
  //struct inode *fip = 0;
  char* org = path;
  char copy[MAXPATH];
  memmove(copy, path, MAXPATH);
    80003e38:	08000613          	li	a2,128
    80003e3c:	85aa                	mv	a1,a0
    80003e3e:	f1040513          	addi	a0,s0,-240
    80003e42:	ffffd097          	auipc	ra,0xffffd
    80003e46:	ed8080e7          	jalr	-296(ra) # 80000d1a <memmove>
  int depth = 0;
  
  if(*path == '/')
    80003e4a:	0004c703          	lbu	a4,0(s1)
    80003e4e:	02f00793          	li	a5,47
    80003e52:	02f70763          	beq	a4,a5,80003e80 <namex+0x70>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003e56:	ffffe097          	auipc	ra,0xffffe
    80003e5a:	b6a080e7          	jalr	-1174(ra) # 800019c0 <myproc>
    80003e5e:	15053503          	ld	a0,336(a0)
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	8d2080e7          	jalr	-1838(ra) # 80003734 <idup>
    80003e6a:	8a2a                	mv	s4,a0
      brelse(b);

      strcat(org1, "/");
      strcat(org1, path);
      strncpy(org, org1, MAXPATH);
      path = org;
    80003e6c:	e8843483          	ld	s1,-376(s0)
    80003e70:	4b81                	li	s7,0
  while(*path == '/')
    80003e72:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003e76:	4db5                	li	s11,13
  while((path = skipelem(path, name)) != 0 && depth < 21){
    80003e78:	4cd1                	li	s9,20
    if(ip->type != T_DIR){
    80003e7a:	4c05                	li	s8,1
    if(ip->type == T_SYMLINK && *path != '\0') {
    80003e7c:	4d11                	li	s10,4
    80003e7e:	aa25                	j	80003fb6 <namex+0x1a6>
    ip = iget(ROOTDEV, ROOTINO);
    80003e80:	4585                	li	a1,1
    80003e82:	4505                	li	a0,1
    80003e84:	fffff097          	auipc	ra,0xfffff
    80003e88:	5ba080e7          	jalr	1466(ra) # 8000343e <iget>
    80003e8c:	8a2a                	mv	s4,a0
    80003e8e:	bff9                	j	80003e6c <namex+0x5c>
      iunlockput(ip);
    80003e90:	8552                	mv	a0,s4
    80003e92:	00000097          	auipc	ra,0x0
    80003e96:	c4a080e7          	jalr	-950(ra) # 80003adc <iunlockput>
      return 0;
    80003e9a:	4a01                	li	s4,0
    80003e9c:	a295                	j	80004000 <namex+0x1f0>
      iunlock(ip);
    80003e9e:	8552                	mv	a0,s4
    80003ea0:	00000097          	auipc	ra,0x0
    80003ea4:	994080e7          	jalr	-1644(ra) # 80003834 <iunlock>
      return ip;
    80003ea8:	aaa1                	j	80004000 <namex+0x1f0>
      iunlockput(ip);
    80003eaa:	8552                	mv	a0,s4
    80003eac:	00000097          	auipc	ra,0x0
    80003eb0:	c30080e7          	jalr	-976(ra) # 80003adc <iunlockput>
      return 0;
    80003eb4:	8a4e                	mv	s4,s3
    80003eb6:	a2a9                	j	80004000 <namex+0x1f0>
    if(ip->type == T_SYMLINK && *path != '\0') {
    80003eb8:	0004c783          	lbu	a5,0(s1)
    80003ebc:	cfe5                	beqz	a5,80003fb4 <namex+0x1a4>
      struct buf *b = bread(ip->dev, ip->addrs[0]);
    80003ebe:	0509a583          	lw	a1,80(s3)
    80003ec2:	0009a503          	lw	a0,0(s3)
    80003ec6:	fffff097          	auipc	ra,0xfffff
    80003eca:	f18080e7          	jalr	-232(ra) # 80002dde <bread>
    80003ece:	8a2a                	mv	s4,a0
      memmove(org1, b->data, MAXPATH);
    80003ed0:	08000613          	li	a2,128
    80003ed4:	05850593          	addi	a1,a0,88
    80003ed8:	e9040513          	addi	a0,s0,-368
    80003edc:	ffffd097          	auipc	ra,0xffffd
    80003ee0:	e3e080e7          	jalr	-450(ra) # 80000d1a <memmove>
      brelse(b);
    80003ee4:	8552                	mv	a0,s4
    80003ee6:	fffff097          	auipc	ra,0xfffff
    80003eea:	028080e7          	jalr	40(ra) # 80002f0e <brelse>
      strcat(org1, "/");
    80003eee:	00004597          	auipc	a1,0x4
    80003ef2:	30a58593          	addi	a1,a1,778 # 800081f8 <digits+0x1b8>
    80003ef6:	e9040513          	addi	a0,s0,-368
    80003efa:	ffffd097          	auipc	ra,0xffffd
    80003efe:	f72080e7          	jalr	-142(ra) # 80000e6c <strcat>
      strcat(org1, path);
    80003f02:	85a6                	mv	a1,s1
    80003f04:	e9040513          	addi	a0,s0,-368
    80003f08:	ffffd097          	auipc	ra,0xffffd
    80003f0c:	f64080e7          	jalr	-156(ra) # 80000e6c <strcat>
      strncpy(org, org1, MAXPATH);
    80003f10:	08000613          	li	a2,128
    80003f14:	e9040593          	addi	a1,s0,-368
    80003f18:	e8843483          	ld	s1,-376(s0)
    80003f1c:	8526                	mv	a0,s1
    80003f1e:	ffffd097          	auipc	ra,0xffffd
    80003f22:	eb4080e7          	jalr	-332(ra) # 80000dd2 <strncpy>

      if(*path == '/')
    80003f26:	0004c783          	lbu	a5,0(s1)
    80003f2a:	01278663          	beq	a5,s2,80003f36 <namex+0x126>
        ip = iget(ROOTDEV, ROOTINO);

      depth++;
    80003f2e:	2b85                	addiw	s7,s7,1
      path = org;
    80003f30:	e8843483          	ld	s1,-376(s0)
    80003f34:	a041                	j	80003fb4 <namex+0x1a4>
        ip = iget(ROOTDEV, ROOTINO);
    80003f36:	85e2                	mv	a1,s8
    80003f38:	8562                	mv	a0,s8
    80003f3a:	fffff097          	auipc	ra,0xfffff
    80003f3e:	504080e7          	jalr	1284(ra) # 8000343e <iget>
    80003f42:	89aa                	mv	s3,a0
    80003f44:	b7ed                	j	80003f2e <namex+0x11e>
  len = path - s;
    80003f46:	40b48633          	sub	a2,s1,a1
    80003f4a:	0006099b          	sext.w	s3,a2
  if(len >= DIRSIZ)
    80003f4e:	093dda63          	bge	s11,s3,80003fe2 <namex+0x1d2>
    memmove(name, s, DIRSIZ);
    80003f52:	4639                	li	a2,14
    80003f54:	8556                	mv	a0,s5
    80003f56:	ffffd097          	auipc	ra,0xffffd
    80003f5a:	dc4080e7          	jalr	-572(ra) # 80000d1a <memmove>
  while(*path == '/')
    80003f5e:	0004c783          	lbu	a5,0(s1)
    80003f62:	01279763          	bne	a5,s2,80003f70 <namex+0x160>
    path++;
    80003f66:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003f68:	0004c783          	lbu	a5,0(s1)
    80003f6c:	ff278de3          	beq	a5,s2,80003f66 <namex+0x156>
  while((path = skipelem(path, name)) != 0 && depth < 21){
    80003f70:	0b7cc863          	blt	s9,s7,80004020 <namex+0x210>
    ilock(ip);
    80003f74:	8552                	mv	a0,s4
    80003f76:	fffff097          	auipc	ra,0xfffff
    80003f7a:	7fc080e7          	jalr	2044(ra) # 80003772 <ilock>
    if(ip->type != T_DIR){
    80003f7e:	044a1783          	lh	a5,68(s4)
    80003f82:	f18797e3          	bne	a5,s8,80003e90 <namex+0x80>
    if(nameiparent && *path == '\0'){
    80003f86:	000b0563          	beqz	s6,80003f90 <namex+0x180>
    80003f8a:	0004c783          	lbu	a5,0(s1)
    80003f8e:	db81                	beqz	a5,80003e9e <namex+0x8e>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003f90:	4601                	li	a2,0
    80003f92:	85d6                	mv	a1,s5
    80003f94:	8552                	mv	a0,s4
    80003f96:	00000097          	auipc	ra,0x0
    80003f9a:	dca080e7          	jalr	-566(ra) # 80003d60 <dirlookup>
    80003f9e:	89aa                	mv	s3,a0
    80003fa0:	d509                	beqz	a0,80003eaa <namex+0x9a>
    iunlockput(ip);
    80003fa2:	8552                	mv	a0,s4
    80003fa4:	00000097          	auipc	ra,0x0
    80003fa8:	b38080e7          	jalr	-1224(ra) # 80003adc <iunlockput>
    if(ip->type == T_SYMLINK && *path != '\0') {
    80003fac:	04499783          	lh	a5,68(s3)
    80003fb0:	f1a784e3          	beq	a5,s10,80003eb8 <namex+0xa8>
      path = org;
    80003fb4:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003fb6:	0004c783          	lbu	a5,0(s1)
    80003fba:	07279a63          	bne	a5,s2,8000402e <namex+0x21e>
    path++;
    80003fbe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003fc0:	0004c783          	lbu	a5,0(s1)
    80003fc4:	ff278de3          	beq	a5,s2,80003fbe <namex+0x1ae>
  if(*path == 0)
    80003fc8:	c79d                	beqz	a5,80003ff6 <namex+0x1e6>
    path++;
    80003fca:	85a6                	mv	a1,s1
  len = path - s;
    80003fcc:	4981                	li	s3,0
    80003fce:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003fd0:	01278963          	beq	a5,s2,80003fe2 <namex+0x1d2>
    80003fd4:	dbad                	beqz	a5,80003f46 <namex+0x136>
    path++;
    80003fd6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003fd8:	0004c783          	lbu	a5,0(s1)
    80003fdc:	ff279ce3          	bne	a5,s2,80003fd4 <namex+0x1c4>
    80003fe0:	b79d                	j	80003f46 <namex+0x136>
    memmove(name, s, len);
    80003fe2:	2601                	sext.w	a2,a2
    80003fe4:	8556                	mv	a0,s5
    80003fe6:	ffffd097          	auipc	ra,0xffffd
    80003fea:	d34080e7          	jalr	-716(ra) # 80000d1a <memmove>
    name[len] = 0;
    80003fee:	99d6                	add	s3,s3,s5
    80003ff0:	00098023          	sb	zero,0(s3)
    80003ff4:	b7ad                	j	80003f5e <namex+0x14e>
    */

  //printf("%s    %s\n", path, name);
  }

  if(nameiparent || depth >= 20){
    80003ff6:	020b1563          	bnez	s6,80004020 <namex+0x210>
    80003ffa:	47cd                	li	a5,19
    80003ffc:	0377c263          	blt	a5,s7,80004020 <namex+0x210>
    return 0;
  }

  //printf("finish\n");
  return ip;
}
    80004000:	8552                	mv	a0,s4
    80004002:	70f6                	ld	ra,376(sp)
    80004004:	7456                	ld	s0,368(sp)
    80004006:	74b6                	ld	s1,360(sp)
    80004008:	7916                	ld	s2,352(sp)
    8000400a:	69f6                	ld	s3,344(sp)
    8000400c:	6a56                	ld	s4,336(sp)
    8000400e:	6ab6                	ld	s5,328(sp)
    80004010:	6b16                	ld	s6,320(sp)
    80004012:	7bf2                	ld	s7,312(sp)
    80004014:	7c52                	ld	s8,304(sp)
    80004016:	7cb2                	ld	s9,296(sp)
    80004018:	7d12                	ld	s10,288(sp)
    8000401a:	6df2                	ld	s11,280(sp)
    8000401c:	6119                	addi	sp,sp,384
    8000401e:	8082                	ret
    iput(ip);
    80004020:	8552                	mv	a0,s4
    80004022:	00000097          	auipc	ra,0x0
    80004026:	a12080e7          	jalr	-1518(ra) # 80003a34 <iput>
    return 0;
    8000402a:	4a01                	li	s4,0
    8000402c:	bfd1                	j	80004000 <namex+0x1f0>
  if(*path == 0)
    8000402e:	d7e1                	beqz	a5,80003ff6 <namex+0x1e6>
  while(*path != '/' && *path != 0)
    80004030:	0004c783          	lbu	a5,0(s1)
    80004034:	85a6                	mv	a1,s1
    80004036:	bf79                	j	80003fd4 <namex+0x1c4>

0000000080004038 <dirlink>:
{
    80004038:	7139                	addi	sp,sp,-64
    8000403a:	fc06                	sd	ra,56(sp)
    8000403c:	f822                	sd	s0,48(sp)
    8000403e:	f426                	sd	s1,40(sp)
    80004040:	f04a                	sd	s2,32(sp)
    80004042:	ec4e                	sd	s3,24(sp)
    80004044:	e852                	sd	s4,16(sp)
    80004046:	0080                	addi	s0,sp,64
    80004048:	892a                	mv	s2,a0
    8000404a:	8a2e                	mv	s4,a1
    8000404c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000404e:	4601                	li	a2,0
    80004050:	00000097          	auipc	ra,0x0
    80004054:	d10080e7          	jalr	-752(ra) # 80003d60 <dirlookup>
    80004058:	e93d                	bnez	a0,800040ce <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000405a:	04c92483          	lw	s1,76(s2)
    8000405e:	c49d                	beqz	s1,8000408c <dirlink+0x54>
    80004060:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004062:	4741                	li	a4,16
    80004064:	86a6                	mv	a3,s1
    80004066:	fc040613          	addi	a2,s0,-64
    8000406a:	4581                	li	a1,0
    8000406c:	854a                	mv	a0,s2
    8000406e:	00000097          	auipc	ra,0x0
    80004072:	ac0080e7          	jalr	-1344(ra) # 80003b2e <readi>
    80004076:	47c1                	li	a5,16
    80004078:	06f51163          	bne	a0,a5,800040da <dirlink+0xa2>
    if(de.inum == 0)
    8000407c:	fc045783          	lhu	a5,-64(s0)
    80004080:	c791                	beqz	a5,8000408c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004082:	24c1                	addiw	s1,s1,16
    80004084:	04c92783          	lw	a5,76(s2)
    80004088:	fcf4ede3          	bltu	s1,a5,80004062 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000408c:	4639                	li	a2,14
    8000408e:	85d2                	mv	a1,s4
    80004090:	fc240513          	addi	a0,s0,-62
    80004094:	ffffd097          	auipc	ra,0xffffd
    80004098:	d3e080e7          	jalr	-706(ra) # 80000dd2 <strncpy>
  de.inum = inum;
    8000409c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040a0:	4741                	li	a4,16
    800040a2:	86a6                	mv	a3,s1
    800040a4:	fc040613          	addi	a2,s0,-64
    800040a8:	4581                	li	a1,0
    800040aa:	854a                	mv	a0,s2
    800040ac:	00000097          	auipc	ra,0x0
    800040b0:	b7a080e7          	jalr	-1158(ra) # 80003c26 <writei>
    800040b4:	872a                	mv	a4,a0
    800040b6:	47c1                	li	a5,16
  return 0;
    800040b8:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040ba:	02f71863          	bne	a4,a5,800040ea <dirlink+0xb2>
}
    800040be:	70e2                	ld	ra,56(sp)
    800040c0:	7442                	ld	s0,48(sp)
    800040c2:	74a2                	ld	s1,40(sp)
    800040c4:	7902                	ld	s2,32(sp)
    800040c6:	69e2                	ld	s3,24(sp)
    800040c8:	6a42                	ld	s4,16(sp)
    800040ca:	6121                	addi	sp,sp,64
    800040cc:	8082                	ret
    iput(ip);
    800040ce:	00000097          	auipc	ra,0x0
    800040d2:	966080e7          	jalr	-1690(ra) # 80003a34 <iput>
    return -1;
    800040d6:	557d                	li	a0,-1
    800040d8:	b7dd                	j	800040be <dirlink+0x86>
      panic("dirlink read");
    800040da:	00004517          	auipc	a0,0x4
    800040de:	52650513          	addi	a0,a0,1318 # 80008600 <syscalls+0x1d0>
    800040e2:	ffffc097          	auipc	ra,0xffffc
    800040e6:	448080e7          	jalr	1096(ra) # 8000052a <panic>
    panic("dirlink");
    800040ea:	00004517          	auipc	a0,0x4
    800040ee:	62650513          	addi	a0,a0,1574 # 80008710 <syscalls+0x2e0>
    800040f2:	ffffc097          	auipc	ra,0xffffc
    800040f6:	438080e7          	jalr	1080(ra) # 8000052a <panic>

00000000800040fa <namei>:

struct inode*
namei(char *path)
{
    800040fa:	1101                	addi	sp,sp,-32
    800040fc:	ec06                	sd	ra,24(sp)
    800040fe:	e822                	sd	s0,16(sp)
    80004100:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004102:	fe040613          	addi	a2,s0,-32
    80004106:	4581                	li	a1,0
    80004108:	00000097          	auipc	ra,0x0
    8000410c:	d08080e7          	jalr	-760(ra) # 80003e10 <namex>
}
    80004110:	60e2                	ld	ra,24(sp)
    80004112:	6442                	ld	s0,16(sp)
    80004114:	6105                	addi	sp,sp,32
    80004116:	8082                	ret

0000000080004118 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004118:	1141                	addi	sp,sp,-16
    8000411a:	e406                	sd	ra,8(sp)
    8000411c:	e022                	sd	s0,0(sp)
    8000411e:	0800                	addi	s0,sp,16
    80004120:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004122:	4585                	li	a1,1
    80004124:	00000097          	auipc	ra,0x0
    80004128:	cec080e7          	jalr	-788(ra) # 80003e10 <namex>
}
    8000412c:	60a2                	ld	ra,8(sp)
    8000412e:	6402                	ld	s0,0(sp)
    80004130:	0141                	addi	sp,sp,16
    80004132:	8082                	ret

0000000080004134 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004134:	1101                	addi	sp,sp,-32
    80004136:	ec06                	sd	ra,24(sp)
    80004138:	e822                	sd	s0,16(sp)
    8000413a:	e426                	sd	s1,8(sp)
    8000413c:	e04a                	sd	s2,0(sp)
    8000413e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004140:	0001d917          	auipc	s2,0x1d
    80004144:	13090913          	addi	s2,s2,304 # 80021270 <log>
    80004148:	01892583          	lw	a1,24(s2)
    8000414c:	02892503          	lw	a0,40(s2)
    80004150:	fffff097          	auipc	ra,0xfffff
    80004154:	c8e080e7          	jalr	-882(ra) # 80002dde <bread>
    80004158:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000415a:	02c92683          	lw	a3,44(s2)
    8000415e:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004160:	02d05763          	blez	a3,8000418e <write_head+0x5a>
    80004164:	0001d797          	auipc	a5,0x1d
    80004168:	13c78793          	addi	a5,a5,316 # 800212a0 <log+0x30>
    8000416c:	05c50713          	addi	a4,a0,92
    80004170:	36fd                	addiw	a3,a3,-1
    80004172:	1682                	slli	a3,a3,0x20
    80004174:	9281                	srli	a3,a3,0x20
    80004176:	068a                	slli	a3,a3,0x2
    80004178:	0001d617          	auipc	a2,0x1d
    8000417c:	12c60613          	addi	a2,a2,300 # 800212a4 <log+0x34>
    80004180:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004182:	4390                	lw	a2,0(a5)
    80004184:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004186:	0791                	addi	a5,a5,4
    80004188:	0711                	addi	a4,a4,4
    8000418a:	fed79ce3          	bne	a5,a3,80004182 <write_head+0x4e>
  }
  bwrite(buf);
    8000418e:	8526                	mv	a0,s1
    80004190:	fffff097          	auipc	ra,0xfffff
    80004194:	d40080e7          	jalr	-704(ra) # 80002ed0 <bwrite>
  brelse(buf);
    80004198:	8526                	mv	a0,s1
    8000419a:	fffff097          	auipc	ra,0xfffff
    8000419e:	d74080e7          	jalr	-652(ra) # 80002f0e <brelse>
}
    800041a2:	60e2                	ld	ra,24(sp)
    800041a4:	6442                	ld	s0,16(sp)
    800041a6:	64a2                	ld	s1,8(sp)
    800041a8:	6902                	ld	s2,0(sp)
    800041aa:	6105                	addi	sp,sp,32
    800041ac:	8082                	ret

00000000800041ae <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800041ae:	0001d797          	auipc	a5,0x1d
    800041b2:	0ee7a783          	lw	a5,238(a5) # 8002129c <log+0x2c>
    800041b6:	0af05d63          	blez	a5,80004270 <install_trans+0xc2>
{
    800041ba:	7139                	addi	sp,sp,-64
    800041bc:	fc06                	sd	ra,56(sp)
    800041be:	f822                	sd	s0,48(sp)
    800041c0:	f426                	sd	s1,40(sp)
    800041c2:	f04a                	sd	s2,32(sp)
    800041c4:	ec4e                	sd	s3,24(sp)
    800041c6:	e852                	sd	s4,16(sp)
    800041c8:	e456                	sd	s5,8(sp)
    800041ca:	e05a                	sd	s6,0(sp)
    800041cc:	0080                	addi	s0,sp,64
    800041ce:	8b2a                	mv	s6,a0
    800041d0:	0001da97          	auipc	s5,0x1d
    800041d4:	0d0a8a93          	addi	s5,s5,208 # 800212a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800041d8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800041da:	0001d997          	auipc	s3,0x1d
    800041de:	09698993          	addi	s3,s3,150 # 80021270 <log>
    800041e2:	a00d                	j	80004204 <install_trans+0x56>
    brelse(lbuf);
    800041e4:	854a                	mv	a0,s2
    800041e6:	fffff097          	auipc	ra,0xfffff
    800041ea:	d28080e7          	jalr	-728(ra) # 80002f0e <brelse>
    brelse(dbuf);
    800041ee:	8526                	mv	a0,s1
    800041f0:	fffff097          	auipc	ra,0xfffff
    800041f4:	d1e080e7          	jalr	-738(ra) # 80002f0e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800041f8:	2a05                	addiw	s4,s4,1
    800041fa:	0a91                	addi	s5,s5,4
    800041fc:	02c9a783          	lw	a5,44(s3)
    80004200:	04fa5e63          	bge	s4,a5,8000425c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004204:	0189a583          	lw	a1,24(s3)
    80004208:	014585bb          	addw	a1,a1,s4
    8000420c:	2585                	addiw	a1,a1,1
    8000420e:	0289a503          	lw	a0,40(s3)
    80004212:	fffff097          	auipc	ra,0xfffff
    80004216:	bcc080e7          	jalr	-1076(ra) # 80002dde <bread>
    8000421a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000421c:	000aa583          	lw	a1,0(s5)
    80004220:	0289a503          	lw	a0,40(s3)
    80004224:	fffff097          	auipc	ra,0xfffff
    80004228:	bba080e7          	jalr	-1094(ra) # 80002dde <bread>
    8000422c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000422e:	40000613          	li	a2,1024
    80004232:	05890593          	addi	a1,s2,88
    80004236:	05850513          	addi	a0,a0,88
    8000423a:	ffffd097          	auipc	ra,0xffffd
    8000423e:	ae0080e7          	jalr	-1312(ra) # 80000d1a <memmove>
    bwrite(dbuf);  // write dst to disk
    80004242:	8526                	mv	a0,s1
    80004244:	fffff097          	auipc	ra,0xfffff
    80004248:	c8c080e7          	jalr	-884(ra) # 80002ed0 <bwrite>
    if(recovering == 0)
    8000424c:	f80b1ce3          	bnez	s6,800041e4 <install_trans+0x36>
      bunpin(dbuf);
    80004250:	8526                	mv	a0,s1
    80004252:	fffff097          	auipc	ra,0xfffff
    80004256:	d96080e7          	jalr	-618(ra) # 80002fe8 <bunpin>
    8000425a:	b769                	j	800041e4 <install_trans+0x36>
}
    8000425c:	70e2                	ld	ra,56(sp)
    8000425e:	7442                	ld	s0,48(sp)
    80004260:	74a2                	ld	s1,40(sp)
    80004262:	7902                	ld	s2,32(sp)
    80004264:	69e2                	ld	s3,24(sp)
    80004266:	6a42                	ld	s4,16(sp)
    80004268:	6aa2                	ld	s5,8(sp)
    8000426a:	6b02                	ld	s6,0(sp)
    8000426c:	6121                	addi	sp,sp,64
    8000426e:	8082                	ret
    80004270:	8082                	ret

0000000080004272 <initlog>:
{
    80004272:	7179                	addi	sp,sp,-48
    80004274:	f406                	sd	ra,40(sp)
    80004276:	f022                	sd	s0,32(sp)
    80004278:	ec26                	sd	s1,24(sp)
    8000427a:	e84a                	sd	s2,16(sp)
    8000427c:	e44e                	sd	s3,8(sp)
    8000427e:	1800                	addi	s0,sp,48
    80004280:	892a                	mv	s2,a0
    80004282:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004284:	0001d497          	auipc	s1,0x1d
    80004288:	fec48493          	addi	s1,s1,-20 # 80021270 <log>
    8000428c:	00004597          	auipc	a1,0x4
    80004290:	38458593          	addi	a1,a1,900 # 80008610 <syscalls+0x1e0>
    80004294:	8526                	mv	a0,s1
    80004296:	ffffd097          	auipc	ra,0xffffd
    8000429a:	89c080e7          	jalr	-1892(ra) # 80000b32 <initlock>
  log.start = sb->logstart;
    8000429e:	0149a583          	lw	a1,20(s3)
    800042a2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800042a4:	0109a783          	lw	a5,16(s3)
    800042a8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800042aa:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800042ae:	854a                	mv	a0,s2
    800042b0:	fffff097          	auipc	ra,0xfffff
    800042b4:	b2e080e7          	jalr	-1234(ra) # 80002dde <bread>
  log.lh.n = lh->n;
    800042b8:	4d34                	lw	a3,88(a0)
    800042ba:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800042bc:	02d05563          	blez	a3,800042e6 <initlog+0x74>
    800042c0:	05c50793          	addi	a5,a0,92
    800042c4:	0001d717          	auipc	a4,0x1d
    800042c8:	fdc70713          	addi	a4,a4,-36 # 800212a0 <log+0x30>
    800042cc:	36fd                	addiw	a3,a3,-1
    800042ce:	1682                	slli	a3,a3,0x20
    800042d0:	9281                	srli	a3,a3,0x20
    800042d2:	068a                	slli	a3,a3,0x2
    800042d4:	06050613          	addi	a2,a0,96
    800042d8:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800042da:	4390                	lw	a2,0(a5)
    800042dc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800042de:	0791                	addi	a5,a5,4
    800042e0:	0711                	addi	a4,a4,4
    800042e2:	fed79ce3          	bne	a5,a3,800042da <initlog+0x68>
  brelse(buf);
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	c28080e7          	jalr	-984(ra) # 80002f0e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800042ee:	4505                	li	a0,1
    800042f0:	00000097          	auipc	ra,0x0
    800042f4:	ebe080e7          	jalr	-322(ra) # 800041ae <install_trans>
  log.lh.n = 0;
    800042f8:	0001d797          	auipc	a5,0x1d
    800042fc:	fa07a223          	sw	zero,-92(a5) # 8002129c <log+0x2c>
  write_head(); // clear the log
    80004300:	00000097          	auipc	ra,0x0
    80004304:	e34080e7          	jalr	-460(ra) # 80004134 <write_head>
}
    80004308:	70a2                	ld	ra,40(sp)
    8000430a:	7402                	ld	s0,32(sp)
    8000430c:	64e2                	ld	s1,24(sp)
    8000430e:	6942                	ld	s2,16(sp)
    80004310:	69a2                	ld	s3,8(sp)
    80004312:	6145                	addi	sp,sp,48
    80004314:	8082                	ret

0000000080004316 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004316:	1101                	addi	sp,sp,-32
    80004318:	ec06                	sd	ra,24(sp)
    8000431a:	e822                	sd	s0,16(sp)
    8000431c:	e426                	sd	s1,8(sp)
    8000431e:	e04a                	sd	s2,0(sp)
    80004320:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004322:	0001d517          	auipc	a0,0x1d
    80004326:	f4e50513          	addi	a0,a0,-178 # 80021270 <log>
    8000432a:	ffffd097          	auipc	ra,0xffffd
    8000432e:	898080e7          	jalr	-1896(ra) # 80000bc2 <acquire>
  while(1){
    if(log.committing){
    80004332:	0001d497          	auipc	s1,0x1d
    80004336:	f3e48493          	addi	s1,s1,-194 # 80021270 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000433a:	4979                	li	s2,30
    8000433c:	a039                	j	8000434a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000433e:	85a6                	mv	a1,s1
    80004340:	8526                	mv	a0,s1
    80004342:	ffffe097          	auipc	ra,0xffffe
    80004346:	d3e080e7          	jalr	-706(ra) # 80002080 <sleep>
    if(log.committing){
    8000434a:	50dc                	lw	a5,36(s1)
    8000434c:	fbed                	bnez	a5,8000433e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000434e:	509c                	lw	a5,32(s1)
    80004350:	0017871b          	addiw	a4,a5,1
    80004354:	0007069b          	sext.w	a3,a4
    80004358:	0027179b          	slliw	a5,a4,0x2
    8000435c:	9fb9                	addw	a5,a5,a4
    8000435e:	0017979b          	slliw	a5,a5,0x1
    80004362:	54d8                	lw	a4,44(s1)
    80004364:	9fb9                	addw	a5,a5,a4
    80004366:	00f95963          	bge	s2,a5,80004378 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000436a:	85a6                	mv	a1,s1
    8000436c:	8526                	mv	a0,s1
    8000436e:	ffffe097          	auipc	ra,0xffffe
    80004372:	d12080e7          	jalr	-750(ra) # 80002080 <sleep>
    80004376:	bfd1                	j	8000434a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004378:	0001d517          	auipc	a0,0x1d
    8000437c:	ef850513          	addi	a0,a0,-264 # 80021270 <log>
    80004380:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004382:	ffffd097          	auipc	ra,0xffffd
    80004386:	8f4080e7          	jalr	-1804(ra) # 80000c76 <release>
      break;
    }
  }
}
    8000438a:	60e2                	ld	ra,24(sp)
    8000438c:	6442                	ld	s0,16(sp)
    8000438e:	64a2                	ld	s1,8(sp)
    80004390:	6902                	ld	s2,0(sp)
    80004392:	6105                	addi	sp,sp,32
    80004394:	8082                	ret

0000000080004396 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004396:	7139                	addi	sp,sp,-64
    80004398:	fc06                	sd	ra,56(sp)
    8000439a:	f822                	sd	s0,48(sp)
    8000439c:	f426                	sd	s1,40(sp)
    8000439e:	f04a                	sd	s2,32(sp)
    800043a0:	ec4e                	sd	s3,24(sp)
    800043a2:	e852                	sd	s4,16(sp)
    800043a4:	e456                	sd	s5,8(sp)
    800043a6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800043a8:	0001d497          	auipc	s1,0x1d
    800043ac:	ec848493          	addi	s1,s1,-312 # 80021270 <log>
    800043b0:	8526                	mv	a0,s1
    800043b2:	ffffd097          	auipc	ra,0xffffd
    800043b6:	810080e7          	jalr	-2032(ra) # 80000bc2 <acquire>
  log.outstanding -= 1;
    800043ba:	509c                	lw	a5,32(s1)
    800043bc:	37fd                	addiw	a5,a5,-1
    800043be:	0007891b          	sext.w	s2,a5
    800043c2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800043c4:	50dc                	lw	a5,36(s1)
    800043c6:	e7b9                	bnez	a5,80004414 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800043c8:	04091e63          	bnez	s2,80004424 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800043cc:	0001d497          	auipc	s1,0x1d
    800043d0:	ea448493          	addi	s1,s1,-348 # 80021270 <log>
    800043d4:	4785                	li	a5,1
    800043d6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800043d8:	8526                	mv	a0,s1
    800043da:	ffffd097          	auipc	ra,0xffffd
    800043de:	89c080e7          	jalr	-1892(ra) # 80000c76 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800043e2:	54dc                	lw	a5,44(s1)
    800043e4:	06f04763          	bgtz	a5,80004452 <end_op+0xbc>
    acquire(&log.lock);
    800043e8:	0001d497          	auipc	s1,0x1d
    800043ec:	e8848493          	addi	s1,s1,-376 # 80021270 <log>
    800043f0:	8526                	mv	a0,s1
    800043f2:	ffffc097          	auipc	ra,0xffffc
    800043f6:	7d0080e7          	jalr	2000(ra) # 80000bc2 <acquire>
    log.committing = 0;
    800043fa:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800043fe:	8526                	mv	a0,s1
    80004400:	ffffe097          	auipc	ra,0xffffe
    80004404:	e0c080e7          	jalr	-500(ra) # 8000220c <wakeup>
    release(&log.lock);
    80004408:	8526                	mv	a0,s1
    8000440a:	ffffd097          	auipc	ra,0xffffd
    8000440e:	86c080e7          	jalr	-1940(ra) # 80000c76 <release>
}
    80004412:	a03d                	j	80004440 <end_op+0xaa>
    panic("log.committing");
    80004414:	00004517          	auipc	a0,0x4
    80004418:	20450513          	addi	a0,a0,516 # 80008618 <syscalls+0x1e8>
    8000441c:	ffffc097          	auipc	ra,0xffffc
    80004420:	10e080e7          	jalr	270(ra) # 8000052a <panic>
    wakeup(&log);
    80004424:	0001d497          	auipc	s1,0x1d
    80004428:	e4c48493          	addi	s1,s1,-436 # 80021270 <log>
    8000442c:	8526                	mv	a0,s1
    8000442e:	ffffe097          	auipc	ra,0xffffe
    80004432:	dde080e7          	jalr	-546(ra) # 8000220c <wakeup>
  release(&log.lock);
    80004436:	8526                	mv	a0,s1
    80004438:	ffffd097          	auipc	ra,0xffffd
    8000443c:	83e080e7          	jalr	-1986(ra) # 80000c76 <release>
}
    80004440:	70e2                	ld	ra,56(sp)
    80004442:	7442                	ld	s0,48(sp)
    80004444:	74a2                	ld	s1,40(sp)
    80004446:	7902                	ld	s2,32(sp)
    80004448:	69e2                	ld	s3,24(sp)
    8000444a:	6a42                	ld	s4,16(sp)
    8000444c:	6aa2                	ld	s5,8(sp)
    8000444e:	6121                	addi	sp,sp,64
    80004450:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004452:	0001da97          	auipc	s5,0x1d
    80004456:	e4ea8a93          	addi	s5,s5,-434 # 800212a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000445a:	0001da17          	auipc	s4,0x1d
    8000445e:	e16a0a13          	addi	s4,s4,-490 # 80021270 <log>
    80004462:	018a2583          	lw	a1,24(s4)
    80004466:	012585bb          	addw	a1,a1,s2
    8000446a:	2585                	addiw	a1,a1,1
    8000446c:	028a2503          	lw	a0,40(s4)
    80004470:	fffff097          	auipc	ra,0xfffff
    80004474:	96e080e7          	jalr	-1682(ra) # 80002dde <bread>
    80004478:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000447a:	000aa583          	lw	a1,0(s5)
    8000447e:	028a2503          	lw	a0,40(s4)
    80004482:	fffff097          	auipc	ra,0xfffff
    80004486:	95c080e7          	jalr	-1700(ra) # 80002dde <bread>
    8000448a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000448c:	40000613          	li	a2,1024
    80004490:	05850593          	addi	a1,a0,88
    80004494:	05848513          	addi	a0,s1,88
    80004498:	ffffd097          	auipc	ra,0xffffd
    8000449c:	882080e7          	jalr	-1918(ra) # 80000d1a <memmove>
    bwrite(to);  // write the log
    800044a0:	8526                	mv	a0,s1
    800044a2:	fffff097          	auipc	ra,0xfffff
    800044a6:	a2e080e7          	jalr	-1490(ra) # 80002ed0 <bwrite>
    brelse(from);
    800044aa:	854e                	mv	a0,s3
    800044ac:	fffff097          	auipc	ra,0xfffff
    800044b0:	a62080e7          	jalr	-1438(ra) # 80002f0e <brelse>
    brelse(to);
    800044b4:	8526                	mv	a0,s1
    800044b6:	fffff097          	auipc	ra,0xfffff
    800044ba:	a58080e7          	jalr	-1448(ra) # 80002f0e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044be:	2905                	addiw	s2,s2,1
    800044c0:	0a91                	addi	s5,s5,4
    800044c2:	02ca2783          	lw	a5,44(s4)
    800044c6:	f8f94ee3          	blt	s2,a5,80004462 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800044ca:	00000097          	auipc	ra,0x0
    800044ce:	c6a080e7          	jalr	-918(ra) # 80004134 <write_head>
    install_trans(0); // Now install writes to home locations
    800044d2:	4501                	li	a0,0
    800044d4:	00000097          	auipc	ra,0x0
    800044d8:	cda080e7          	jalr	-806(ra) # 800041ae <install_trans>
    log.lh.n = 0;
    800044dc:	0001d797          	auipc	a5,0x1d
    800044e0:	dc07a023          	sw	zero,-576(a5) # 8002129c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800044e4:	00000097          	auipc	ra,0x0
    800044e8:	c50080e7          	jalr	-944(ra) # 80004134 <write_head>
    800044ec:	bdf5                	j	800043e8 <end_op+0x52>

00000000800044ee <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800044ee:	1101                	addi	sp,sp,-32
    800044f0:	ec06                	sd	ra,24(sp)
    800044f2:	e822                	sd	s0,16(sp)
    800044f4:	e426                	sd	s1,8(sp)
    800044f6:	e04a                	sd	s2,0(sp)
    800044f8:	1000                	addi	s0,sp,32
    800044fa:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800044fc:	0001d917          	auipc	s2,0x1d
    80004500:	d7490913          	addi	s2,s2,-652 # 80021270 <log>
    80004504:	854a                	mv	a0,s2
    80004506:	ffffc097          	auipc	ra,0xffffc
    8000450a:	6bc080e7          	jalr	1724(ra) # 80000bc2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000450e:	02c92603          	lw	a2,44(s2)
    80004512:	47f5                	li	a5,29
    80004514:	06c7c563          	blt	a5,a2,8000457e <log_write+0x90>
    80004518:	0001d797          	auipc	a5,0x1d
    8000451c:	d747a783          	lw	a5,-652(a5) # 8002128c <log+0x1c>
    80004520:	37fd                	addiw	a5,a5,-1
    80004522:	04f65e63          	bge	a2,a5,8000457e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004526:	0001d797          	auipc	a5,0x1d
    8000452a:	d6a7a783          	lw	a5,-662(a5) # 80021290 <log+0x20>
    8000452e:	06f05063          	blez	a5,8000458e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004532:	4781                	li	a5,0
    80004534:	06c05563          	blez	a2,8000459e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004538:	44cc                	lw	a1,12(s1)
    8000453a:	0001d717          	auipc	a4,0x1d
    8000453e:	d6670713          	addi	a4,a4,-666 # 800212a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004542:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004544:	4314                	lw	a3,0(a4)
    80004546:	04b68c63          	beq	a3,a1,8000459e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000454a:	2785                	addiw	a5,a5,1
    8000454c:	0711                	addi	a4,a4,4
    8000454e:	fef61be3          	bne	a2,a5,80004544 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004552:	0621                	addi	a2,a2,8
    80004554:	060a                	slli	a2,a2,0x2
    80004556:	0001d797          	auipc	a5,0x1d
    8000455a:	d1a78793          	addi	a5,a5,-742 # 80021270 <log>
    8000455e:	963e                	add	a2,a2,a5
    80004560:	44dc                	lw	a5,12(s1)
    80004562:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004564:	8526                	mv	a0,s1
    80004566:	fffff097          	auipc	ra,0xfffff
    8000456a:	a46080e7          	jalr	-1466(ra) # 80002fac <bpin>
    log.lh.n++;
    8000456e:	0001d717          	auipc	a4,0x1d
    80004572:	d0270713          	addi	a4,a4,-766 # 80021270 <log>
    80004576:	575c                	lw	a5,44(a4)
    80004578:	2785                	addiw	a5,a5,1
    8000457a:	d75c                	sw	a5,44(a4)
    8000457c:	a835                	j	800045b8 <log_write+0xca>
    panic("too big a transaction");
    8000457e:	00004517          	auipc	a0,0x4
    80004582:	0aa50513          	addi	a0,a0,170 # 80008628 <syscalls+0x1f8>
    80004586:	ffffc097          	auipc	ra,0xffffc
    8000458a:	fa4080e7          	jalr	-92(ra) # 8000052a <panic>
    panic("log_write outside of trans");
    8000458e:	00004517          	auipc	a0,0x4
    80004592:	0b250513          	addi	a0,a0,178 # 80008640 <syscalls+0x210>
    80004596:	ffffc097          	auipc	ra,0xffffc
    8000459a:	f94080e7          	jalr	-108(ra) # 8000052a <panic>
  log.lh.block[i] = b->blockno;
    8000459e:	00878713          	addi	a4,a5,8
    800045a2:	00271693          	slli	a3,a4,0x2
    800045a6:	0001d717          	auipc	a4,0x1d
    800045aa:	cca70713          	addi	a4,a4,-822 # 80021270 <log>
    800045ae:	9736                	add	a4,a4,a3
    800045b0:	44d4                	lw	a3,12(s1)
    800045b2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800045b4:	faf608e3          	beq	a2,a5,80004564 <log_write+0x76>
  }
  release(&log.lock);
    800045b8:	0001d517          	auipc	a0,0x1d
    800045bc:	cb850513          	addi	a0,a0,-840 # 80021270 <log>
    800045c0:	ffffc097          	auipc	ra,0xffffc
    800045c4:	6b6080e7          	jalr	1718(ra) # 80000c76 <release>
}
    800045c8:	60e2                	ld	ra,24(sp)
    800045ca:	6442                	ld	s0,16(sp)
    800045cc:	64a2                	ld	s1,8(sp)
    800045ce:	6902                	ld	s2,0(sp)
    800045d0:	6105                	addi	sp,sp,32
    800045d2:	8082                	ret

00000000800045d4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800045d4:	1101                	addi	sp,sp,-32
    800045d6:	ec06                	sd	ra,24(sp)
    800045d8:	e822                	sd	s0,16(sp)
    800045da:	e426                	sd	s1,8(sp)
    800045dc:	e04a                	sd	s2,0(sp)
    800045de:	1000                	addi	s0,sp,32
    800045e0:	84aa                	mv	s1,a0
    800045e2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800045e4:	00004597          	auipc	a1,0x4
    800045e8:	07c58593          	addi	a1,a1,124 # 80008660 <syscalls+0x230>
    800045ec:	0521                	addi	a0,a0,8
    800045ee:	ffffc097          	auipc	ra,0xffffc
    800045f2:	544080e7          	jalr	1348(ra) # 80000b32 <initlock>
  lk->name = name;
    800045f6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800045fa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800045fe:	0204a423          	sw	zero,40(s1)
}
    80004602:	60e2                	ld	ra,24(sp)
    80004604:	6442                	ld	s0,16(sp)
    80004606:	64a2                	ld	s1,8(sp)
    80004608:	6902                	ld	s2,0(sp)
    8000460a:	6105                	addi	sp,sp,32
    8000460c:	8082                	ret

000000008000460e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000460e:	1101                	addi	sp,sp,-32
    80004610:	ec06                	sd	ra,24(sp)
    80004612:	e822                	sd	s0,16(sp)
    80004614:	e426                	sd	s1,8(sp)
    80004616:	e04a                	sd	s2,0(sp)
    80004618:	1000                	addi	s0,sp,32
    8000461a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000461c:	00850913          	addi	s2,a0,8
    80004620:	854a                	mv	a0,s2
    80004622:	ffffc097          	auipc	ra,0xffffc
    80004626:	5a0080e7          	jalr	1440(ra) # 80000bc2 <acquire>
  while (lk->locked) {
    8000462a:	409c                	lw	a5,0(s1)
    8000462c:	cb89                	beqz	a5,8000463e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000462e:	85ca                	mv	a1,s2
    80004630:	8526                	mv	a0,s1
    80004632:	ffffe097          	auipc	ra,0xffffe
    80004636:	a4e080e7          	jalr	-1458(ra) # 80002080 <sleep>
  while (lk->locked) {
    8000463a:	409c                	lw	a5,0(s1)
    8000463c:	fbed                	bnez	a5,8000462e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000463e:	4785                	li	a5,1
    80004640:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004642:	ffffd097          	auipc	ra,0xffffd
    80004646:	37e080e7          	jalr	894(ra) # 800019c0 <myproc>
    8000464a:	591c                	lw	a5,48(a0)
    8000464c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000464e:	854a                	mv	a0,s2
    80004650:	ffffc097          	auipc	ra,0xffffc
    80004654:	626080e7          	jalr	1574(ra) # 80000c76 <release>
}
    80004658:	60e2                	ld	ra,24(sp)
    8000465a:	6442                	ld	s0,16(sp)
    8000465c:	64a2                	ld	s1,8(sp)
    8000465e:	6902                	ld	s2,0(sp)
    80004660:	6105                	addi	sp,sp,32
    80004662:	8082                	ret

0000000080004664 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004664:	1101                	addi	sp,sp,-32
    80004666:	ec06                	sd	ra,24(sp)
    80004668:	e822                	sd	s0,16(sp)
    8000466a:	e426                	sd	s1,8(sp)
    8000466c:	e04a                	sd	s2,0(sp)
    8000466e:	1000                	addi	s0,sp,32
    80004670:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004672:	00850913          	addi	s2,a0,8
    80004676:	854a                	mv	a0,s2
    80004678:	ffffc097          	auipc	ra,0xffffc
    8000467c:	54a080e7          	jalr	1354(ra) # 80000bc2 <acquire>
  lk->locked = 0;
    80004680:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004684:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004688:	8526                	mv	a0,s1
    8000468a:	ffffe097          	auipc	ra,0xffffe
    8000468e:	b82080e7          	jalr	-1150(ra) # 8000220c <wakeup>
  release(&lk->lk);
    80004692:	854a                	mv	a0,s2
    80004694:	ffffc097          	auipc	ra,0xffffc
    80004698:	5e2080e7          	jalr	1506(ra) # 80000c76 <release>
}
    8000469c:	60e2                	ld	ra,24(sp)
    8000469e:	6442                	ld	s0,16(sp)
    800046a0:	64a2                	ld	s1,8(sp)
    800046a2:	6902                	ld	s2,0(sp)
    800046a4:	6105                	addi	sp,sp,32
    800046a6:	8082                	ret

00000000800046a8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800046a8:	7179                	addi	sp,sp,-48
    800046aa:	f406                	sd	ra,40(sp)
    800046ac:	f022                	sd	s0,32(sp)
    800046ae:	ec26                	sd	s1,24(sp)
    800046b0:	e84a                	sd	s2,16(sp)
    800046b2:	e44e                	sd	s3,8(sp)
    800046b4:	1800                	addi	s0,sp,48
    800046b6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800046b8:	00850913          	addi	s2,a0,8
    800046bc:	854a                	mv	a0,s2
    800046be:	ffffc097          	auipc	ra,0xffffc
    800046c2:	504080e7          	jalr	1284(ra) # 80000bc2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800046c6:	409c                	lw	a5,0(s1)
    800046c8:	ef99                	bnez	a5,800046e6 <holdingsleep+0x3e>
    800046ca:	4481                	li	s1,0
  release(&lk->lk);
    800046cc:	854a                	mv	a0,s2
    800046ce:	ffffc097          	auipc	ra,0xffffc
    800046d2:	5a8080e7          	jalr	1448(ra) # 80000c76 <release>
  return r;
}
    800046d6:	8526                	mv	a0,s1
    800046d8:	70a2                	ld	ra,40(sp)
    800046da:	7402                	ld	s0,32(sp)
    800046dc:	64e2                	ld	s1,24(sp)
    800046de:	6942                	ld	s2,16(sp)
    800046e0:	69a2                	ld	s3,8(sp)
    800046e2:	6145                	addi	sp,sp,48
    800046e4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800046e6:	0284a983          	lw	s3,40(s1)
    800046ea:	ffffd097          	auipc	ra,0xffffd
    800046ee:	2d6080e7          	jalr	726(ra) # 800019c0 <myproc>
    800046f2:	5904                	lw	s1,48(a0)
    800046f4:	413484b3          	sub	s1,s1,s3
    800046f8:	0014b493          	seqz	s1,s1
    800046fc:	bfc1                	j	800046cc <holdingsleep+0x24>

00000000800046fe <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800046fe:	1141                	addi	sp,sp,-16
    80004700:	e406                	sd	ra,8(sp)
    80004702:	e022                	sd	s0,0(sp)
    80004704:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004706:	00004597          	auipc	a1,0x4
    8000470a:	f6a58593          	addi	a1,a1,-150 # 80008670 <syscalls+0x240>
    8000470e:	0001d517          	auipc	a0,0x1d
    80004712:	caa50513          	addi	a0,a0,-854 # 800213b8 <ftable>
    80004716:	ffffc097          	auipc	ra,0xffffc
    8000471a:	41c080e7          	jalr	1052(ra) # 80000b32 <initlock>
}
    8000471e:	60a2                	ld	ra,8(sp)
    80004720:	6402                	ld	s0,0(sp)
    80004722:	0141                	addi	sp,sp,16
    80004724:	8082                	ret

0000000080004726 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004726:	1101                	addi	sp,sp,-32
    80004728:	ec06                	sd	ra,24(sp)
    8000472a:	e822                	sd	s0,16(sp)
    8000472c:	e426                	sd	s1,8(sp)
    8000472e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004730:	0001d517          	auipc	a0,0x1d
    80004734:	c8850513          	addi	a0,a0,-888 # 800213b8 <ftable>
    80004738:	ffffc097          	auipc	ra,0xffffc
    8000473c:	48a080e7          	jalr	1162(ra) # 80000bc2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004740:	0001d497          	auipc	s1,0x1d
    80004744:	c9048493          	addi	s1,s1,-880 # 800213d0 <ftable+0x18>
    80004748:	0001e717          	auipc	a4,0x1e
    8000474c:	c2870713          	addi	a4,a4,-984 # 80022370 <ftable+0xfb8>
    if(f->ref == 0){
    80004750:	40dc                	lw	a5,4(s1)
    80004752:	cf99                	beqz	a5,80004770 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004754:	02848493          	addi	s1,s1,40
    80004758:	fee49ce3          	bne	s1,a4,80004750 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000475c:	0001d517          	auipc	a0,0x1d
    80004760:	c5c50513          	addi	a0,a0,-932 # 800213b8 <ftable>
    80004764:	ffffc097          	auipc	ra,0xffffc
    80004768:	512080e7          	jalr	1298(ra) # 80000c76 <release>
  return 0;
    8000476c:	4481                	li	s1,0
    8000476e:	a819                	j	80004784 <filealloc+0x5e>
      f->ref = 1;
    80004770:	4785                	li	a5,1
    80004772:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004774:	0001d517          	auipc	a0,0x1d
    80004778:	c4450513          	addi	a0,a0,-956 # 800213b8 <ftable>
    8000477c:	ffffc097          	auipc	ra,0xffffc
    80004780:	4fa080e7          	jalr	1274(ra) # 80000c76 <release>
}
    80004784:	8526                	mv	a0,s1
    80004786:	60e2                	ld	ra,24(sp)
    80004788:	6442                	ld	s0,16(sp)
    8000478a:	64a2                	ld	s1,8(sp)
    8000478c:	6105                	addi	sp,sp,32
    8000478e:	8082                	ret

0000000080004790 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004790:	1101                	addi	sp,sp,-32
    80004792:	ec06                	sd	ra,24(sp)
    80004794:	e822                	sd	s0,16(sp)
    80004796:	e426                	sd	s1,8(sp)
    80004798:	1000                	addi	s0,sp,32
    8000479a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000479c:	0001d517          	auipc	a0,0x1d
    800047a0:	c1c50513          	addi	a0,a0,-996 # 800213b8 <ftable>
    800047a4:	ffffc097          	auipc	ra,0xffffc
    800047a8:	41e080e7          	jalr	1054(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    800047ac:	40dc                	lw	a5,4(s1)
    800047ae:	02f05263          	blez	a5,800047d2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800047b2:	2785                	addiw	a5,a5,1
    800047b4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800047b6:	0001d517          	auipc	a0,0x1d
    800047ba:	c0250513          	addi	a0,a0,-1022 # 800213b8 <ftable>
    800047be:	ffffc097          	auipc	ra,0xffffc
    800047c2:	4b8080e7          	jalr	1208(ra) # 80000c76 <release>
  return f;
}
    800047c6:	8526                	mv	a0,s1
    800047c8:	60e2                	ld	ra,24(sp)
    800047ca:	6442                	ld	s0,16(sp)
    800047cc:	64a2                	ld	s1,8(sp)
    800047ce:	6105                	addi	sp,sp,32
    800047d0:	8082                	ret
    panic("filedup");
    800047d2:	00004517          	auipc	a0,0x4
    800047d6:	ea650513          	addi	a0,a0,-346 # 80008678 <syscalls+0x248>
    800047da:	ffffc097          	auipc	ra,0xffffc
    800047de:	d50080e7          	jalr	-688(ra) # 8000052a <panic>

00000000800047e2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800047e2:	7139                	addi	sp,sp,-64
    800047e4:	fc06                	sd	ra,56(sp)
    800047e6:	f822                	sd	s0,48(sp)
    800047e8:	f426                	sd	s1,40(sp)
    800047ea:	f04a                	sd	s2,32(sp)
    800047ec:	ec4e                	sd	s3,24(sp)
    800047ee:	e852                	sd	s4,16(sp)
    800047f0:	e456                	sd	s5,8(sp)
    800047f2:	0080                	addi	s0,sp,64
    800047f4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800047f6:	0001d517          	auipc	a0,0x1d
    800047fa:	bc250513          	addi	a0,a0,-1086 # 800213b8 <ftable>
    800047fe:	ffffc097          	auipc	ra,0xffffc
    80004802:	3c4080e7          	jalr	964(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    80004806:	40dc                	lw	a5,4(s1)
    80004808:	06f05163          	blez	a5,8000486a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000480c:	37fd                	addiw	a5,a5,-1
    8000480e:	0007871b          	sext.w	a4,a5
    80004812:	c0dc                	sw	a5,4(s1)
    80004814:	06e04363          	bgtz	a4,8000487a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004818:	0004a903          	lw	s2,0(s1)
    8000481c:	0094ca83          	lbu	s5,9(s1)
    80004820:	0104ba03          	ld	s4,16(s1)
    80004824:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004828:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000482c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004830:	0001d517          	auipc	a0,0x1d
    80004834:	b8850513          	addi	a0,a0,-1144 # 800213b8 <ftable>
    80004838:	ffffc097          	auipc	ra,0xffffc
    8000483c:	43e080e7          	jalr	1086(ra) # 80000c76 <release>

  if(ff.type == FD_PIPE){
    80004840:	4785                	li	a5,1
    80004842:	04f90d63          	beq	s2,a5,8000489c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004846:	3979                	addiw	s2,s2,-2
    80004848:	4785                	li	a5,1
    8000484a:	0527e063          	bltu	a5,s2,8000488a <fileclose+0xa8>
    begin_op();
    8000484e:	00000097          	auipc	ra,0x0
    80004852:	ac8080e7          	jalr	-1336(ra) # 80004316 <begin_op>
    iput(ff.ip);
    80004856:	854e                	mv	a0,s3
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	1dc080e7          	jalr	476(ra) # 80003a34 <iput>
    end_op();
    80004860:	00000097          	auipc	ra,0x0
    80004864:	b36080e7          	jalr	-1226(ra) # 80004396 <end_op>
    80004868:	a00d                	j	8000488a <fileclose+0xa8>
    panic("fileclose");
    8000486a:	00004517          	auipc	a0,0x4
    8000486e:	e1650513          	addi	a0,a0,-490 # 80008680 <syscalls+0x250>
    80004872:	ffffc097          	auipc	ra,0xffffc
    80004876:	cb8080e7          	jalr	-840(ra) # 8000052a <panic>
    release(&ftable.lock);
    8000487a:	0001d517          	auipc	a0,0x1d
    8000487e:	b3e50513          	addi	a0,a0,-1218 # 800213b8 <ftable>
    80004882:	ffffc097          	auipc	ra,0xffffc
    80004886:	3f4080e7          	jalr	1012(ra) # 80000c76 <release>
  }
}
    8000488a:	70e2                	ld	ra,56(sp)
    8000488c:	7442                	ld	s0,48(sp)
    8000488e:	74a2                	ld	s1,40(sp)
    80004890:	7902                	ld	s2,32(sp)
    80004892:	69e2                	ld	s3,24(sp)
    80004894:	6a42                	ld	s4,16(sp)
    80004896:	6aa2                	ld	s5,8(sp)
    80004898:	6121                	addi	sp,sp,64
    8000489a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000489c:	85d6                	mv	a1,s5
    8000489e:	8552                	mv	a0,s4
    800048a0:	00000097          	auipc	ra,0x0
    800048a4:	34c080e7          	jalr	844(ra) # 80004bec <pipeclose>
    800048a8:	b7cd                	j	8000488a <fileclose+0xa8>

00000000800048aa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800048aa:	715d                	addi	sp,sp,-80
    800048ac:	e486                	sd	ra,72(sp)
    800048ae:	e0a2                	sd	s0,64(sp)
    800048b0:	fc26                	sd	s1,56(sp)
    800048b2:	f84a                	sd	s2,48(sp)
    800048b4:	f44e                	sd	s3,40(sp)
    800048b6:	0880                	addi	s0,sp,80
    800048b8:	84aa                	mv	s1,a0
    800048ba:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800048bc:	ffffd097          	auipc	ra,0xffffd
    800048c0:	104080e7          	jalr	260(ra) # 800019c0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800048c4:	409c                	lw	a5,0(s1)
    800048c6:	37f9                	addiw	a5,a5,-2
    800048c8:	4705                	li	a4,1
    800048ca:	04f76763          	bltu	a4,a5,80004918 <filestat+0x6e>
    800048ce:	892a                	mv	s2,a0
    ilock(f->ip);
    800048d0:	6c88                	ld	a0,24(s1)
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	ea0080e7          	jalr	-352(ra) # 80003772 <ilock>
    stati(f->ip, &st);
    800048da:	fb840593          	addi	a1,s0,-72
    800048de:	6c88                	ld	a0,24(s1)
    800048e0:	fffff097          	auipc	ra,0xfffff
    800048e4:	224080e7          	jalr	548(ra) # 80003b04 <stati>
    iunlock(f->ip);
    800048e8:	6c88                	ld	a0,24(s1)
    800048ea:	fffff097          	auipc	ra,0xfffff
    800048ee:	f4a080e7          	jalr	-182(ra) # 80003834 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800048f2:	46e1                	li	a3,24
    800048f4:	fb840613          	addi	a2,s0,-72
    800048f8:	85ce                	mv	a1,s3
    800048fa:	05093503          	ld	a0,80(s2)
    800048fe:	ffffd097          	auipc	ra,0xffffd
    80004902:	d82080e7          	jalr	-638(ra) # 80001680 <copyout>
    80004906:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000490a:	60a6                	ld	ra,72(sp)
    8000490c:	6406                	ld	s0,64(sp)
    8000490e:	74e2                	ld	s1,56(sp)
    80004910:	7942                	ld	s2,48(sp)
    80004912:	79a2                	ld	s3,40(sp)
    80004914:	6161                	addi	sp,sp,80
    80004916:	8082                	ret
  return -1;
    80004918:	557d                	li	a0,-1
    8000491a:	bfc5                	j	8000490a <filestat+0x60>

000000008000491c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000491c:	7179                	addi	sp,sp,-48
    8000491e:	f406                	sd	ra,40(sp)
    80004920:	f022                	sd	s0,32(sp)
    80004922:	ec26                	sd	s1,24(sp)
    80004924:	e84a                	sd	s2,16(sp)
    80004926:	e44e                	sd	s3,8(sp)
    80004928:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000492a:	00854783          	lbu	a5,8(a0)
    8000492e:	c3d5                	beqz	a5,800049d2 <fileread+0xb6>
    80004930:	84aa                	mv	s1,a0
    80004932:	89ae                	mv	s3,a1
    80004934:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004936:	411c                	lw	a5,0(a0)
    80004938:	4705                	li	a4,1
    8000493a:	04e78963          	beq	a5,a4,8000498c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000493e:	470d                	li	a4,3
    80004940:	04e78d63          	beq	a5,a4,8000499a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004944:	4709                	li	a4,2
    80004946:	06e79e63          	bne	a5,a4,800049c2 <fileread+0xa6>
    ilock(f->ip);
    8000494a:	6d08                	ld	a0,24(a0)
    8000494c:	fffff097          	auipc	ra,0xfffff
    80004950:	e26080e7          	jalr	-474(ra) # 80003772 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004954:	874a                	mv	a4,s2
    80004956:	5094                	lw	a3,32(s1)
    80004958:	864e                	mv	a2,s3
    8000495a:	4585                	li	a1,1
    8000495c:	6c88                	ld	a0,24(s1)
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	1d0080e7          	jalr	464(ra) # 80003b2e <readi>
    80004966:	892a                	mv	s2,a0
    80004968:	00a05563          	blez	a0,80004972 <fileread+0x56>
      f->off += r;
    8000496c:	509c                	lw	a5,32(s1)
    8000496e:	9fa9                	addw	a5,a5,a0
    80004970:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004972:	6c88                	ld	a0,24(s1)
    80004974:	fffff097          	auipc	ra,0xfffff
    80004978:	ec0080e7          	jalr	-320(ra) # 80003834 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000497c:	854a                	mv	a0,s2
    8000497e:	70a2                	ld	ra,40(sp)
    80004980:	7402                	ld	s0,32(sp)
    80004982:	64e2                	ld	s1,24(sp)
    80004984:	6942                	ld	s2,16(sp)
    80004986:	69a2                	ld	s3,8(sp)
    80004988:	6145                	addi	sp,sp,48
    8000498a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000498c:	6908                	ld	a0,16(a0)
    8000498e:	00000097          	auipc	ra,0x0
    80004992:	3c0080e7          	jalr	960(ra) # 80004d4e <piperead>
    80004996:	892a                	mv	s2,a0
    80004998:	b7d5                	j	8000497c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000499a:	02451783          	lh	a5,36(a0)
    8000499e:	03079693          	slli	a3,a5,0x30
    800049a2:	92c1                	srli	a3,a3,0x30
    800049a4:	4725                	li	a4,9
    800049a6:	02d76863          	bltu	a4,a3,800049d6 <fileread+0xba>
    800049aa:	0792                	slli	a5,a5,0x4
    800049ac:	0001d717          	auipc	a4,0x1d
    800049b0:	96c70713          	addi	a4,a4,-1684 # 80021318 <devsw>
    800049b4:	97ba                	add	a5,a5,a4
    800049b6:	639c                	ld	a5,0(a5)
    800049b8:	c38d                	beqz	a5,800049da <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800049ba:	4505                	li	a0,1
    800049bc:	9782                	jalr	a5
    800049be:	892a                	mv	s2,a0
    800049c0:	bf75                	j	8000497c <fileread+0x60>
    panic("fileread");
    800049c2:	00004517          	auipc	a0,0x4
    800049c6:	cce50513          	addi	a0,a0,-818 # 80008690 <syscalls+0x260>
    800049ca:	ffffc097          	auipc	ra,0xffffc
    800049ce:	b60080e7          	jalr	-1184(ra) # 8000052a <panic>
    return -1;
    800049d2:	597d                	li	s2,-1
    800049d4:	b765                	j	8000497c <fileread+0x60>
      return -1;
    800049d6:	597d                	li	s2,-1
    800049d8:	b755                	j	8000497c <fileread+0x60>
    800049da:	597d                	li	s2,-1
    800049dc:	b745                	j	8000497c <fileread+0x60>

00000000800049de <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800049de:	715d                	addi	sp,sp,-80
    800049e0:	e486                	sd	ra,72(sp)
    800049e2:	e0a2                	sd	s0,64(sp)
    800049e4:	fc26                	sd	s1,56(sp)
    800049e6:	f84a                	sd	s2,48(sp)
    800049e8:	f44e                	sd	s3,40(sp)
    800049ea:	f052                	sd	s4,32(sp)
    800049ec:	ec56                	sd	s5,24(sp)
    800049ee:	e85a                	sd	s6,16(sp)
    800049f0:	e45e                	sd	s7,8(sp)
    800049f2:	e062                	sd	s8,0(sp)
    800049f4:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800049f6:	00954783          	lbu	a5,9(a0)
    800049fa:	10078663          	beqz	a5,80004b06 <filewrite+0x128>
    800049fe:	892a                	mv	s2,a0
    80004a00:	8aae                	mv	s5,a1
    80004a02:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a04:	411c                	lw	a5,0(a0)
    80004a06:	4705                	li	a4,1
    80004a08:	02e78263          	beq	a5,a4,80004a2c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a0c:	470d                	li	a4,3
    80004a0e:	02e78663          	beq	a5,a4,80004a3a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004a12:	4709                	li	a4,2
    80004a14:	0ee79163          	bne	a5,a4,80004af6 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004a18:	0ac05d63          	blez	a2,80004ad2 <filewrite+0xf4>
    int i = 0;
    80004a1c:	4981                	li	s3,0
    80004a1e:	6b05                	lui	s6,0x1
    80004a20:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004a24:	6b85                	lui	s7,0x1
    80004a26:	c00b8b9b          	addiw	s7,s7,-1024
    80004a2a:	a861                	j	80004ac2 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004a2c:	6908                	ld	a0,16(a0)
    80004a2e:	00000097          	auipc	ra,0x0
    80004a32:	22e080e7          	jalr	558(ra) # 80004c5c <pipewrite>
    80004a36:	8a2a                	mv	s4,a0
    80004a38:	a045                	j	80004ad8 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004a3a:	02451783          	lh	a5,36(a0)
    80004a3e:	03079693          	slli	a3,a5,0x30
    80004a42:	92c1                	srli	a3,a3,0x30
    80004a44:	4725                	li	a4,9
    80004a46:	0cd76263          	bltu	a4,a3,80004b0a <filewrite+0x12c>
    80004a4a:	0792                	slli	a5,a5,0x4
    80004a4c:	0001d717          	auipc	a4,0x1d
    80004a50:	8cc70713          	addi	a4,a4,-1844 # 80021318 <devsw>
    80004a54:	97ba                	add	a5,a5,a4
    80004a56:	679c                	ld	a5,8(a5)
    80004a58:	cbdd                	beqz	a5,80004b0e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004a5a:	4505                	li	a0,1
    80004a5c:	9782                	jalr	a5
    80004a5e:	8a2a                	mv	s4,a0
    80004a60:	a8a5                	j	80004ad8 <filewrite+0xfa>
    80004a62:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004a66:	00000097          	auipc	ra,0x0
    80004a6a:	8b0080e7          	jalr	-1872(ra) # 80004316 <begin_op>
      ilock(f->ip);
    80004a6e:	01893503          	ld	a0,24(s2)
    80004a72:	fffff097          	auipc	ra,0xfffff
    80004a76:	d00080e7          	jalr	-768(ra) # 80003772 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004a7a:	8762                	mv	a4,s8
    80004a7c:	02092683          	lw	a3,32(s2)
    80004a80:	01598633          	add	a2,s3,s5
    80004a84:	4585                	li	a1,1
    80004a86:	01893503          	ld	a0,24(s2)
    80004a8a:	fffff097          	auipc	ra,0xfffff
    80004a8e:	19c080e7          	jalr	412(ra) # 80003c26 <writei>
    80004a92:	84aa                	mv	s1,a0
    80004a94:	00a05763          	blez	a0,80004aa2 <filewrite+0xc4>
        f->off += r;
    80004a98:	02092783          	lw	a5,32(s2)
    80004a9c:	9fa9                	addw	a5,a5,a0
    80004a9e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004aa2:	01893503          	ld	a0,24(s2)
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	d8e080e7          	jalr	-626(ra) # 80003834 <iunlock>
      end_op();
    80004aae:	00000097          	auipc	ra,0x0
    80004ab2:	8e8080e7          	jalr	-1816(ra) # 80004396 <end_op>

      if(r != n1){
    80004ab6:	009c1f63          	bne	s8,s1,80004ad4 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004aba:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004abe:	0149db63          	bge	s3,s4,80004ad4 <filewrite+0xf6>
      int n1 = n - i;
    80004ac2:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004ac6:	84be                	mv	s1,a5
    80004ac8:	2781                	sext.w	a5,a5
    80004aca:	f8fb5ce3          	bge	s6,a5,80004a62 <filewrite+0x84>
    80004ace:	84de                	mv	s1,s7
    80004ad0:	bf49                	j	80004a62 <filewrite+0x84>
    int i = 0;
    80004ad2:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004ad4:	013a1f63          	bne	s4,s3,80004af2 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004ad8:	8552                	mv	a0,s4
    80004ada:	60a6                	ld	ra,72(sp)
    80004adc:	6406                	ld	s0,64(sp)
    80004ade:	74e2                	ld	s1,56(sp)
    80004ae0:	7942                	ld	s2,48(sp)
    80004ae2:	79a2                	ld	s3,40(sp)
    80004ae4:	7a02                	ld	s4,32(sp)
    80004ae6:	6ae2                	ld	s5,24(sp)
    80004ae8:	6b42                	ld	s6,16(sp)
    80004aea:	6ba2                	ld	s7,8(sp)
    80004aec:	6c02                	ld	s8,0(sp)
    80004aee:	6161                	addi	sp,sp,80
    80004af0:	8082                	ret
    ret = (i == n ? n : -1);
    80004af2:	5a7d                	li	s4,-1
    80004af4:	b7d5                	j	80004ad8 <filewrite+0xfa>
    panic("filewrite");
    80004af6:	00004517          	auipc	a0,0x4
    80004afa:	baa50513          	addi	a0,a0,-1110 # 800086a0 <syscalls+0x270>
    80004afe:	ffffc097          	auipc	ra,0xffffc
    80004b02:	a2c080e7          	jalr	-1492(ra) # 8000052a <panic>
    return -1;
    80004b06:	5a7d                	li	s4,-1
    80004b08:	bfc1                	j	80004ad8 <filewrite+0xfa>
      return -1;
    80004b0a:	5a7d                	li	s4,-1
    80004b0c:	b7f1                	j	80004ad8 <filewrite+0xfa>
    80004b0e:	5a7d                	li	s4,-1
    80004b10:	b7e1                	j	80004ad8 <filewrite+0xfa>

0000000080004b12 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004b12:	7179                	addi	sp,sp,-48
    80004b14:	f406                	sd	ra,40(sp)
    80004b16:	f022                	sd	s0,32(sp)
    80004b18:	ec26                	sd	s1,24(sp)
    80004b1a:	e84a                	sd	s2,16(sp)
    80004b1c:	e44e                	sd	s3,8(sp)
    80004b1e:	e052                	sd	s4,0(sp)
    80004b20:	1800                	addi	s0,sp,48
    80004b22:	84aa                	mv	s1,a0
    80004b24:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004b26:	0005b023          	sd	zero,0(a1)
    80004b2a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004b2e:	00000097          	auipc	ra,0x0
    80004b32:	bf8080e7          	jalr	-1032(ra) # 80004726 <filealloc>
    80004b36:	e088                	sd	a0,0(s1)
    80004b38:	c551                	beqz	a0,80004bc4 <pipealloc+0xb2>
    80004b3a:	00000097          	auipc	ra,0x0
    80004b3e:	bec080e7          	jalr	-1044(ra) # 80004726 <filealloc>
    80004b42:	00aa3023          	sd	a0,0(s4)
    80004b46:	c92d                	beqz	a0,80004bb8 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004b48:	ffffc097          	auipc	ra,0xffffc
    80004b4c:	f8a080e7          	jalr	-118(ra) # 80000ad2 <kalloc>
    80004b50:	892a                	mv	s2,a0
    80004b52:	c125                	beqz	a0,80004bb2 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004b54:	4985                	li	s3,1
    80004b56:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004b5a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004b5e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004b62:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004b66:	00004597          	auipc	a1,0x4
    80004b6a:	b4a58593          	addi	a1,a1,-1206 # 800086b0 <syscalls+0x280>
    80004b6e:	ffffc097          	auipc	ra,0xffffc
    80004b72:	fc4080e7          	jalr	-60(ra) # 80000b32 <initlock>
  (*f0)->type = FD_PIPE;
    80004b76:	609c                	ld	a5,0(s1)
    80004b78:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004b7c:	609c                	ld	a5,0(s1)
    80004b7e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004b82:	609c                	ld	a5,0(s1)
    80004b84:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004b88:	609c                	ld	a5,0(s1)
    80004b8a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004b8e:	000a3783          	ld	a5,0(s4)
    80004b92:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004b96:	000a3783          	ld	a5,0(s4)
    80004b9a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004b9e:	000a3783          	ld	a5,0(s4)
    80004ba2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004ba6:	000a3783          	ld	a5,0(s4)
    80004baa:	0127b823          	sd	s2,16(a5)
  return 0;
    80004bae:	4501                	li	a0,0
    80004bb0:	a025                	j	80004bd8 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004bb2:	6088                	ld	a0,0(s1)
    80004bb4:	e501                	bnez	a0,80004bbc <pipealloc+0xaa>
    80004bb6:	a039                	j	80004bc4 <pipealloc+0xb2>
    80004bb8:	6088                	ld	a0,0(s1)
    80004bba:	c51d                	beqz	a0,80004be8 <pipealloc+0xd6>
    fileclose(*f0);
    80004bbc:	00000097          	auipc	ra,0x0
    80004bc0:	c26080e7          	jalr	-986(ra) # 800047e2 <fileclose>
  if(*f1)
    80004bc4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004bc8:	557d                	li	a0,-1
  if(*f1)
    80004bca:	c799                	beqz	a5,80004bd8 <pipealloc+0xc6>
    fileclose(*f1);
    80004bcc:	853e                	mv	a0,a5
    80004bce:	00000097          	auipc	ra,0x0
    80004bd2:	c14080e7          	jalr	-1004(ra) # 800047e2 <fileclose>
  return -1;
    80004bd6:	557d                	li	a0,-1
}
    80004bd8:	70a2                	ld	ra,40(sp)
    80004bda:	7402                	ld	s0,32(sp)
    80004bdc:	64e2                	ld	s1,24(sp)
    80004bde:	6942                	ld	s2,16(sp)
    80004be0:	69a2                	ld	s3,8(sp)
    80004be2:	6a02                	ld	s4,0(sp)
    80004be4:	6145                	addi	sp,sp,48
    80004be6:	8082                	ret
  return -1;
    80004be8:	557d                	li	a0,-1
    80004bea:	b7fd                	j	80004bd8 <pipealloc+0xc6>

0000000080004bec <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004bec:	1101                	addi	sp,sp,-32
    80004bee:	ec06                	sd	ra,24(sp)
    80004bf0:	e822                	sd	s0,16(sp)
    80004bf2:	e426                	sd	s1,8(sp)
    80004bf4:	e04a                	sd	s2,0(sp)
    80004bf6:	1000                	addi	s0,sp,32
    80004bf8:	84aa                	mv	s1,a0
    80004bfa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004bfc:	ffffc097          	auipc	ra,0xffffc
    80004c00:	fc6080e7          	jalr	-58(ra) # 80000bc2 <acquire>
  if(writable){
    80004c04:	02090d63          	beqz	s2,80004c3e <pipeclose+0x52>
    pi->writeopen = 0;
    80004c08:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004c0c:	21848513          	addi	a0,s1,536
    80004c10:	ffffd097          	auipc	ra,0xffffd
    80004c14:	5fc080e7          	jalr	1532(ra) # 8000220c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004c18:	2204b783          	ld	a5,544(s1)
    80004c1c:	eb95                	bnez	a5,80004c50 <pipeclose+0x64>
    release(&pi->lock);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffc097          	auipc	ra,0xffffc
    80004c24:	056080e7          	jalr	86(ra) # 80000c76 <release>
    kfree((char*)pi);
    80004c28:	8526                	mv	a0,s1
    80004c2a:	ffffc097          	auipc	ra,0xffffc
    80004c2e:	dac080e7          	jalr	-596(ra) # 800009d6 <kfree>
  } else
    release(&pi->lock);
}
    80004c32:	60e2                	ld	ra,24(sp)
    80004c34:	6442                	ld	s0,16(sp)
    80004c36:	64a2                	ld	s1,8(sp)
    80004c38:	6902                	ld	s2,0(sp)
    80004c3a:	6105                	addi	sp,sp,32
    80004c3c:	8082                	ret
    pi->readopen = 0;
    80004c3e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004c42:	21c48513          	addi	a0,s1,540
    80004c46:	ffffd097          	auipc	ra,0xffffd
    80004c4a:	5c6080e7          	jalr	1478(ra) # 8000220c <wakeup>
    80004c4e:	b7e9                	j	80004c18 <pipeclose+0x2c>
    release(&pi->lock);
    80004c50:	8526                	mv	a0,s1
    80004c52:	ffffc097          	auipc	ra,0xffffc
    80004c56:	024080e7          	jalr	36(ra) # 80000c76 <release>
}
    80004c5a:	bfe1                	j	80004c32 <pipeclose+0x46>

0000000080004c5c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004c5c:	711d                	addi	sp,sp,-96
    80004c5e:	ec86                	sd	ra,88(sp)
    80004c60:	e8a2                	sd	s0,80(sp)
    80004c62:	e4a6                	sd	s1,72(sp)
    80004c64:	e0ca                	sd	s2,64(sp)
    80004c66:	fc4e                	sd	s3,56(sp)
    80004c68:	f852                	sd	s4,48(sp)
    80004c6a:	f456                	sd	s5,40(sp)
    80004c6c:	f05a                	sd	s6,32(sp)
    80004c6e:	ec5e                	sd	s7,24(sp)
    80004c70:	e862                	sd	s8,16(sp)
    80004c72:	1080                	addi	s0,sp,96
    80004c74:	84aa                	mv	s1,a0
    80004c76:	8aae                	mv	s5,a1
    80004c78:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004c7a:	ffffd097          	auipc	ra,0xffffd
    80004c7e:	d46080e7          	jalr	-698(ra) # 800019c0 <myproc>
    80004c82:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004c84:	8526                	mv	a0,s1
    80004c86:	ffffc097          	auipc	ra,0xffffc
    80004c8a:	f3c080e7          	jalr	-196(ra) # 80000bc2 <acquire>
  while(i < n){
    80004c8e:	0b405363          	blez	s4,80004d34 <pipewrite+0xd8>
  int i = 0;
    80004c92:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c94:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004c96:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004c9a:	21c48b93          	addi	s7,s1,540
    80004c9e:	a089                	j	80004ce0 <pipewrite+0x84>
      release(&pi->lock);
    80004ca0:	8526                	mv	a0,s1
    80004ca2:	ffffc097          	auipc	ra,0xffffc
    80004ca6:	fd4080e7          	jalr	-44(ra) # 80000c76 <release>
      return -1;
    80004caa:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004cac:	854a                	mv	a0,s2
    80004cae:	60e6                	ld	ra,88(sp)
    80004cb0:	6446                	ld	s0,80(sp)
    80004cb2:	64a6                	ld	s1,72(sp)
    80004cb4:	6906                	ld	s2,64(sp)
    80004cb6:	79e2                	ld	s3,56(sp)
    80004cb8:	7a42                	ld	s4,48(sp)
    80004cba:	7aa2                	ld	s5,40(sp)
    80004cbc:	7b02                	ld	s6,32(sp)
    80004cbe:	6be2                	ld	s7,24(sp)
    80004cc0:	6c42                	ld	s8,16(sp)
    80004cc2:	6125                	addi	sp,sp,96
    80004cc4:	8082                	ret
      wakeup(&pi->nread);
    80004cc6:	8562                	mv	a0,s8
    80004cc8:	ffffd097          	auipc	ra,0xffffd
    80004ccc:	544080e7          	jalr	1348(ra) # 8000220c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004cd0:	85a6                	mv	a1,s1
    80004cd2:	855e                	mv	a0,s7
    80004cd4:	ffffd097          	auipc	ra,0xffffd
    80004cd8:	3ac080e7          	jalr	940(ra) # 80002080 <sleep>
  while(i < n){
    80004cdc:	05495d63          	bge	s2,s4,80004d36 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004ce0:	2204a783          	lw	a5,544(s1)
    80004ce4:	dfd5                	beqz	a5,80004ca0 <pipewrite+0x44>
    80004ce6:	0289a783          	lw	a5,40(s3)
    80004cea:	fbdd                	bnez	a5,80004ca0 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004cec:	2184a783          	lw	a5,536(s1)
    80004cf0:	21c4a703          	lw	a4,540(s1)
    80004cf4:	2007879b          	addiw	a5,a5,512
    80004cf8:	fcf707e3          	beq	a4,a5,80004cc6 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004cfc:	4685                	li	a3,1
    80004cfe:	01590633          	add	a2,s2,s5
    80004d02:	faf40593          	addi	a1,s0,-81
    80004d06:	0509b503          	ld	a0,80(s3)
    80004d0a:	ffffd097          	auipc	ra,0xffffd
    80004d0e:	a02080e7          	jalr	-1534(ra) # 8000170c <copyin>
    80004d12:	03650263          	beq	a0,s6,80004d36 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004d16:	21c4a783          	lw	a5,540(s1)
    80004d1a:	0017871b          	addiw	a4,a5,1
    80004d1e:	20e4ae23          	sw	a4,540(s1)
    80004d22:	1ff7f793          	andi	a5,a5,511
    80004d26:	97a6                	add	a5,a5,s1
    80004d28:	faf44703          	lbu	a4,-81(s0)
    80004d2c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004d30:	2905                	addiw	s2,s2,1
    80004d32:	b76d                	j	80004cdc <pipewrite+0x80>
  int i = 0;
    80004d34:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004d36:	21848513          	addi	a0,s1,536
    80004d3a:	ffffd097          	auipc	ra,0xffffd
    80004d3e:	4d2080e7          	jalr	1234(ra) # 8000220c <wakeup>
  release(&pi->lock);
    80004d42:	8526                	mv	a0,s1
    80004d44:	ffffc097          	auipc	ra,0xffffc
    80004d48:	f32080e7          	jalr	-206(ra) # 80000c76 <release>
  return i;
    80004d4c:	b785                	j	80004cac <pipewrite+0x50>

0000000080004d4e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004d4e:	715d                	addi	sp,sp,-80
    80004d50:	e486                	sd	ra,72(sp)
    80004d52:	e0a2                	sd	s0,64(sp)
    80004d54:	fc26                	sd	s1,56(sp)
    80004d56:	f84a                	sd	s2,48(sp)
    80004d58:	f44e                	sd	s3,40(sp)
    80004d5a:	f052                	sd	s4,32(sp)
    80004d5c:	ec56                	sd	s5,24(sp)
    80004d5e:	e85a                	sd	s6,16(sp)
    80004d60:	0880                	addi	s0,sp,80
    80004d62:	84aa                	mv	s1,a0
    80004d64:	892e                	mv	s2,a1
    80004d66:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004d68:	ffffd097          	auipc	ra,0xffffd
    80004d6c:	c58080e7          	jalr	-936(ra) # 800019c0 <myproc>
    80004d70:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004d72:	8526                	mv	a0,s1
    80004d74:	ffffc097          	auipc	ra,0xffffc
    80004d78:	e4e080e7          	jalr	-434(ra) # 80000bc2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d7c:	2184a703          	lw	a4,536(s1)
    80004d80:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004d84:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d88:	02f71463          	bne	a4,a5,80004db0 <piperead+0x62>
    80004d8c:	2244a783          	lw	a5,548(s1)
    80004d90:	c385                	beqz	a5,80004db0 <piperead+0x62>
    if(pr->killed){
    80004d92:	028a2783          	lw	a5,40(s4)
    80004d96:	ebc1                	bnez	a5,80004e26 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004d98:	85a6                	mv	a1,s1
    80004d9a:	854e                	mv	a0,s3
    80004d9c:	ffffd097          	auipc	ra,0xffffd
    80004da0:	2e4080e7          	jalr	740(ra) # 80002080 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004da4:	2184a703          	lw	a4,536(s1)
    80004da8:	21c4a783          	lw	a5,540(s1)
    80004dac:	fef700e3          	beq	a4,a5,80004d8c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004db0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004db2:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004db4:	05505363          	blez	s5,80004dfa <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004db8:	2184a783          	lw	a5,536(s1)
    80004dbc:	21c4a703          	lw	a4,540(s1)
    80004dc0:	02f70d63          	beq	a4,a5,80004dfa <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004dc4:	0017871b          	addiw	a4,a5,1
    80004dc8:	20e4ac23          	sw	a4,536(s1)
    80004dcc:	1ff7f793          	andi	a5,a5,511
    80004dd0:	97a6                	add	a5,a5,s1
    80004dd2:	0187c783          	lbu	a5,24(a5)
    80004dd6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004dda:	4685                	li	a3,1
    80004ddc:	fbf40613          	addi	a2,s0,-65
    80004de0:	85ca                	mv	a1,s2
    80004de2:	050a3503          	ld	a0,80(s4)
    80004de6:	ffffd097          	auipc	ra,0xffffd
    80004dea:	89a080e7          	jalr	-1894(ra) # 80001680 <copyout>
    80004dee:	01650663          	beq	a0,s6,80004dfa <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004df2:	2985                	addiw	s3,s3,1
    80004df4:	0905                	addi	s2,s2,1
    80004df6:	fd3a91e3          	bne	s5,s3,80004db8 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004dfa:	21c48513          	addi	a0,s1,540
    80004dfe:	ffffd097          	auipc	ra,0xffffd
    80004e02:	40e080e7          	jalr	1038(ra) # 8000220c <wakeup>
  release(&pi->lock);
    80004e06:	8526                	mv	a0,s1
    80004e08:	ffffc097          	auipc	ra,0xffffc
    80004e0c:	e6e080e7          	jalr	-402(ra) # 80000c76 <release>
  return i;
}
    80004e10:	854e                	mv	a0,s3
    80004e12:	60a6                	ld	ra,72(sp)
    80004e14:	6406                	ld	s0,64(sp)
    80004e16:	74e2                	ld	s1,56(sp)
    80004e18:	7942                	ld	s2,48(sp)
    80004e1a:	79a2                	ld	s3,40(sp)
    80004e1c:	7a02                	ld	s4,32(sp)
    80004e1e:	6ae2                	ld	s5,24(sp)
    80004e20:	6b42                	ld	s6,16(sp)
    80004e22:	6161                	addi	sp,sp,80
    80004e24:	8082                	ret
      release(&pi->lock);
    80004e26:	8526                	mv	a0,s1
    80004e28:	ffffc097          	auipc	ra,0xffffc
    80004e2c:	e4e080e7          	jalr	-434(ra) # 80000c76 <release>
      return -1;
    80004e30:	59fd                	li	s3,-1
    80004e32:	bff9                	j	80004e10 <piperead+0xc2>

0000000080004e34 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004e34:	de010113          	addi	sp,sp,-544
    80004e38:	20113c23          	sd	ra,536(sp)
    80004e3c:	20813823          	sd	s0,528(sp)
    80004e40:	20913423          	sd	s1,520(sp)
    80004e44:	21213023          	sd	s2,512(sp)
    80004e48:	ffce                	sd	s3,504(sp)
    80004e4a:	fbd2                	sd	s4,496(sp)
    80004e4c:	f7d6                	sd	s5,488(sp)
    80004e4e:	f3da                	sd	s6,480(sp)
    80004e50:	efde                	sd	s7,472(sp)
    80004e52:	ebe2                	sd	s8,464(sp)
    80004e54:	e7e6                	sd	s9,456(sp)
    80004e56:	e3ea                	sd	s10,448(sp)
    80004e58:	ff6e                	sd	s11,440(sp)
    80004e5a:	1400                	addi	s0,sp,544
    80004e5c:	892a                	mv	s2,a0
    80004e5e:	dea43423          	sd	a0,-536(s0)
    80004e62:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004e66:	ffffd097          	auipc	ra,0xffffd
    80004e6a:	b5a080e7          	jalr	-1190(ra) # 800019c0 <myproc>
    80004e6e:	84aa                	mv	s1,a0

  begin_op();
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	4a6080e7          	jalr	1190(ra) # 80004316 <begin_op>

  if((ip = namei(path)) == 0){
    80004e78:	854a                	mv	a0,s2
    80004e7a:	fffff097          	auipc	ra,0xfffff
    80004e7e:	280080e7          	jalr	640(ra) # 800040fa <namei>
    80004e82:	c93d                	beqz	a0,80004ef8 <exec+0xc4>
    80004e84:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	8ec080e7          	jalr	-1812(ra) # 80003772 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004e8e:	04000713          	li	a4,64
    80004e92:	4681                	li	a3,0
    80004e94:	e4840613          	addi	a2,s0,-440
    80004e98:	4581                	li	a1,0
    80004e9a:	8556                	mv	a0,s5
    80004e9c:	fffff097          	auipc	ra,0xfffff
    80004ea0:	c92080e7          	jalr	-878(ra) # 80003b2e <readi>
    80004ea4:	04000793          	li	a5,64
    80004ea8:	00f51a63          	bne	a0,a5,80004ebc <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004eac:	e4842703          	lw	a4,-440(s0)
    80004eb0:	464c47b7          	lui	a5,0x464c4
    80004eb4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004eb8:	04f70663          	beq	a4,a5,80004f04 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004ebc:	8556                	mv	a0,s5
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	c1e080e7          	jalr	-994(ra) # 80003adc <iunlockput>
    end_op();
    80004ec6:	fffff097          	auipc	ra,0xfffff
    80004eca:	4d0080e7          	jalr	1232(ra) # 80004396 <end_op>
  }
  return -1;
    80004ece:	557d                	li	a0,-1
}
    80004ed0:	21813083          	ld	ra,536(sp)
    80004ed4:	21013403          	ld	s0,528(sp)
    80004ed8:	20813483          	ld	s1,520(sp)
    80004edc:	20013903          	ld	s2,512(sp)
    80004ee0:	79fe                	ld	s3,504(sp)
    80004ee2:	7a5e                	ld	s4,496(sp)
    80004ee4:	7abe                	ld	s5,488(sp)
    80004ee6:	7b1e                	ld	s6,480(sp)
    80004ee8:	6bfe                	ld	s7,472(sp)
    80004eea:	6c5e                	ld	s8,464(sp)
    80004eec:	6cbe                	ld	s9,456(sp)
    80004eee:	6d1e                	ld	s10,448(sp)
    80004ef0:	7dfa                	ld	s11,440(sp)
    80004ef2:	22010113          	addi	sp,sp,544
    80004ef6:	8082                	ret
    end_op();
    80004ef8:	fffff097          	auipc	ra,0xfffff
    80004efc:	49e080e7          	jalr	1182(ra) # 80004396 <end_op>
    return -1;
    80004f00:	557d                	li	a0,-1
    80004f02:	b7f9                	j	80004ed0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004f04:	8526                	mv	a0,s1
    80004f06:	ffffd097          	auipc	ra,0xffffd
    80004f0a:	b7e080e7          	jalr	-1154(ra) # 80001a84 <proc_pagetable>
    80004f0e:	8b2a                	mv	s6,a0
    80004f10:	d555                	beqz	a0,80004ebc <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f12:	e6842783          	lw	a5,-408(s0)
    80004f16:	e8045703          	lhu	a4,-384(s0)
    80004f1a:	c735                	beqz	a4,80004f86 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004f1c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f1e:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004f22:	6a05                	lui	s4,0x1
    80004f24:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004f28:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004f2c:	6d85                	lui	s11,0x1
    80004f2e:	7d7d                	lui	s10,0xfffff
    80004f30:	ac1d                	j	80005166 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004f32:	00003517          	auipc	a0,0x3
    80004f36:	78650513          	addi	a0,a0,1926 # 800086b8 <syscalls+0x288>
    80004f3a:	ffffb097          	auipc	ra,0xffffb
    80004f3e:	5f0080e7          	jalr	1520(ra) # 8000052a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004f42:	874a                	mv	a4,s2
    80004f44:	009c86bb          	addw	a3,s9,s1
    80004f48:	4581                	li	a1,0
    80004f4a:	8556                	mv	a0,s5
    80004f4c:	fffff097          	auipc	ra,0xfffff
    80004f50:	be2080e7          	jalr	-1054(ra) # 80003b2e <readi>
    80004f54:	2501                	sext.w	a0,a0
    80004f56:	1aa91863          	bne	s2,a0,80005106 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004f5a:	009d84bb          	addw	s1,s11,s1
    80004f5e:	013d09bb          	addw	s3,s10,s3
    80004f62:	1f74f263          	bgeu	s1,s7,80005146 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004f66:	02049593          	slli	a1,s1,0x20
    80004f6a:	9181                	srli	a1,a1,0x20
    80004f6c:	95e2                	add	a1,a1,s8
    80004f6e:	855a                	mv	a0,s6
    80004f70:	ffffc097          	auipc	ra,0xffffc
    80004f74:	11e080e7          	jalr	286(ra) # 8000108e <walkaddr>
    80004f78:	862a                	mv	a2,a0
    if(pa == 0)
    80004f7a:	dd45                	beqz	a0,80004f32 <exec+0xfe>
      n = PGSIZE;
    80004f7c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004f7e:	fd49f2e3          	bgeu	s3,s4,80004f42 <exec+0x10e>
      n = sz - i;
    80004f82:	894e                	mv	s2,s3
    80004f84:	bf7d                	j	80004f42 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004f86:	4481                	li	s1,0
  iunlockput(ip);
    80004f88:	8556                	mv	a0,s5
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	b52080e7          	jalr	-1198(ra) # 80003adc <iunlockput>
  end_op();
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	404080e7          	jalr	1028(ra) # 80004396 <end_op>
  p = myproc();
    80004f9a:	ffffd097          	auipc	ra,0xffffd
    80004f9e:	a26080e7          	jalr	-1498(ra) # 800019c0 <myproc>
    80004fa2:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004fa4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004fa8:	6785                	lui	a5,0x1
    80004faa:	17fd                	addi	a5,a5,-1
    80004fac:	94be                	add	s1,s1,a5
    80004fae:	77fd                	lui	a5,0xfffff
    80004fb0:	8fe5                	and	a5,a5,s1
    80004fb2:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004fb6:	6609                	lui	a2,0x2
    80004fb8:	963e                	add	a2,a2,a5
    80004fba:	85be                	mv	a1,a5
    80004fbc:	855a                	mv	a0,s6
    80004fbe:	ffffc097          	auipc	ra,0xffffc
    80004fc2:	472080e7          	jalr	1138(ra) # 80001430 <uvmalloc>
    80004fc6:	8c2a                	mv	s8,a0
  ip = 0;
    80004fc8:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004fca:	12050e63          	beqz	a0,80005106 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004fce:	75f9                	lui	a1,0xffffe
    80004fd0:	95aa                	add	a1,a1,a0
    80004fd2:	855a                	mv	a0,s6
    80004fd4:	ffffc097          	auipc	ra,0xffffc
    80004fd8:	67a080e7          	jalr	1658(ra) # 8000164e <uvmclear>
  stackbase = sp - PGSIZE;
    80004fdc:	7afd                	lui	s5,0xfffff
    80004fde:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004fe0:	df043783          	ld	a5,-528(s0)
    80004fe4:	6388                	ld	a0,0(a5)
    80004fe6:	c925                	beqz	a0,80005056 <exec+0x222>
    80004fe8:	e8840993          	addi	s3,s0,-376
    80004fec:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004ff0:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004ff2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004ff4:	ffffc097          	auipc	ra,0xffffc
    80004ff8:	e4e080e7          	jalr	-434(ra) # 80000e42 <strlen>
    80004ffc:	0015079b          	addiw	a5,a0,1
    80005000:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005004:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005008:	13596363          	bltu	s2,s5,8000512e <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000500c:	df043d83          	ld	s11,-528(s0)
    80005010:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005014:	8552                	mv	a0,s4
    80005016:	ffffc097          	auipc	ra,0xffffc
    8000501a:	e2c080e7          	jalr	-468(ra) # 80000e42 <strlen>
    8000501e:	0015069b          	addiw	a3,a0,1
    80005022:	8652                	mv	a2,s4
    80005024:	85ca                	mv	a1,s2
    80005026:	855a                	mv	a0,s6
    80005028:	ffffc097          	auipc	ra,0xffffc
    8000502c:	658080e7          	jalr	1624(ra) # 80001680 <copyout>
    80005030:	10054363          	bltz	a0,80005136 <exec+0x302>
    ustack[argc] = sp;
    80005034:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005038:	0485                	addi	s1,s1,1
    8000503a:	008d8793          	addi	a5,s11,8
    8000503e:	def43823          	sd	a5,-528(s0)
    80005042:	008db503          	ld	a0,8(s11)
    80005046:	c911                	beqz	a0,8000505a <exec+0x226>
    if(argc >= MAXARG)
    80005048:	09a1                	addi	s3,s3,8
    8000504a:	fb3c95e3          	bne	s9,s3,80004ff4 <exec+0x1c0>
  sz = sz1;
    8000504e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005052:	4a81                	li	s5,0
    80005054:	a84d                	j	80005106 <exec+0x2d2>
  sp = sz;
    80005056:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005058:	4481                	li	s1,0
  ustack[argc] = 0;
    8000505a:	00349793          	slli	a5,s1,0x3
    8000505e:	f9040713          	addi	a4,s0,-112
    80005062:	97ba                	add	a5,a5,a4
    80005064:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
  sp -= (argc+1) * sizeof(uint64);
    80005068:	00148693          	addi	a3,s1,1
    8000506c:	068e                	slli	a3,a3,0x3
    8000506e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005072:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005076:	01597663          	bgeu	s2,s5,80005082 <exec+0x24e>
  sz = sz1;
    8000507a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000507e:	4a81                	li	s5,0
    80005080:	a059                	j	80005106 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005082:	e8840613          	addi	a2,s0,-376
    80005086:	85ca                	mv	a1,s2
    80005088:	855a                	mv	a0,s6
    8000508a:	ffffc097          	auipc	ra,0xffffc
    8000508e:	5f6080e7          	jalr	1526(ra) # 80001680 <copyout>
    80005092:	0a054663          	bltz	a0,8000513e <exec+0x30a>
  p->trapframe->a1 = sp;
    80005096:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    8000509a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000509e:	de843783          	ld	a5,-536(s0)
    800050a2:	0007c703          	lbu	a4,0(a5)
    800050a6:	cf11                	beqz	a4,800050c2 <exec+0x28e>
    800050a8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800050aa:	02f00693          	li	a3,47
    800050ae:	a039                	j	800050bc <exec+0x288>
      last = s+1;
    800050b0:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800050b4:	0785                	addi	a5,a5,1
    800050b6:	fff7c703          	lbu	a4,-1(a5)
    800050ba:	c701                	beqz	a4,800050c2 <exec+0x28e>
    if(*s == '/')
    800050bc:	fed71ce3          	bne	a4,a3,800050b4 <exec+0x280>
    800050c0:	bfc5                	j	800050b0 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800050c2:	4641                	li	a2,16
    800050c4:	de843583          	ld	a1,-536(s0)
    800050c8:	158b8513          	addi	a0,s7,344
    800050cc:	ffffc097          	auipc	ra,0xffffc
    800050d0:	d44080e7          	jalr	-700(ra) # 80000e10 <safestrcpy>
  oldpagetable = p->pagetable;
    800050d4:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800050d8:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800050dc:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800050e0:	058bb783          	ld	a5,88(s7)
    800050e4:	e6043703          	ld	a4,-416(s0)
    800050e8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800050ea:	058bb783          	ld	a5,88(s7)
    800050ee:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800050f2:	85ea                	mv	a1,s10
    800050f4:	ffffd097          	auipc	ra,0xffffd
    800050f8:	a2c080e7          	jalr	-1492(ra) # 80001b20 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800050fc:	0004851b          	sext.w	a0,s1
    80005100:	bbc1                	j	80004ed0 <exec+0x9c>
    80005102:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005106:	df843583          	ld	a1,-520(s0)
    8000510a:	855a                	mv	a0,s6
    8000510c:	ffffd097          	auipc	ra,0xffffd
    80005110:	a14080e7          	jalr	-1516(ra) # 80001b20 <proc_freepagetable>
  if(ip){
    80005114:	da0a94e3          	bnez	s5,80004ebc <exec+0x88>
  return -1;
    80005118:	557d                	li	a0,-1
    8000511a:	bb5d                	j	80004ed0 <exec+0x9c>
    8000511c:	de943c23          	sd	s1,-520(s0)
    80005120:	b7dd                	j	80005106 <exec+0x2d2>
    80005122:	de943c23          	sd	s1,-520(s0)
    80005126:	b7c5                	j	80005106 <exec+0x2d2>
    80005128:	de943c23          	sd	s1,-520(s0)
    8000512c:	bfe9                	j	80005106 <exec+0x2d2>
  sz = sz1;
    8000512e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005132:	4a81                	li	s5,0
    80005134:	bfc9                	j	80005106 <exec+0x2d2>
  sz = sz1;
    80005136:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000513a:	4a81                	li	s5,0
    8000513c:	b7e9                	j	80005106 <exec+0x2d2>
  sz = sz1;
    8000513e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005142:	4a81                	li	s5,0
    80005144:	b7c9                	j	80005106 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005146:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000514a:	e0843783          	ld	a5,-504(s0)
    8000514e:	0017869b          	addiw	a3,a5,1
    80005152:	e0d43423          	sd	a3,-504(s0)
    80005156:	e0043783          	ld	a5,-512(s0)
    8000515a:	0387879b          	addiw	a5,a5,56
    8000515e:	e8045703          	lhu	a4,-384(s0)
    80005162:	e2e6d3e3          	bge	a3,a4,80004f88 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005166:	2781                	sext.w	a5,a5
    80005168:	e0f43023          	sd	a5,-512(s0)
    8000516c:	03800713          	li	a4,56
    80005170:	86be                	mv	a3,a5
    80005172:	e1040613          	addi	a2,s0,-496
    80005176:	4581                	li	a1,0
    80005178:	8556                	mv	a0,s5
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	9b4080e7          	jalr	-1612(ra) # 80003b2e <readi>
    80005182:	03800793          	li	a5,56
    80005186:	f6f51ee3          	bne	a0,a5,80005102 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000518a:	e1042783          	lw	a5,-496(s0)
    8000518e:	4705                	li	a4,1
    80005190:	fae79de3          	bne	a5,a4,8000514a <exec+0x316>
    if(ph.memsz < ph.filesz)
    80005194:	e3843603          	ld	a2,-456(s0)
    80005198:	e3043783          	ld	a5,-464(s0)
    8000519c:	f8f660e3          	bltu	a2,a5,8000511c <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800051a0:	e2043783          	ld	a5,-480(s0)
    800051a4:	963e                	add	a2,a2,a5
    800051a6:	f6f66ee3          	bltu	a2,a5,80005122 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800051aa:	85a6                	mv	a1,s1
    800051ac:	855a                	mv	a0,s6
    800051ae:	ffffc097          	auipc	ra,0xffffc
    800051b2:	282080e7          	jalr	642(ra) # 80001430 <uvmalloc>
    800051b6:	dea43c23          	sd	a0,-520(s0)
    800051ba:	d53d                	beqz	a0,80005128 <exec+0x2f4>
    if(ph.vaddr % PGSIZE != 0)
    800051bc:	e2043c03          	ld	s8,-480(s0)
    800051c0:	de043783          	ld	a5,-544(s0)
    800051c4:	00fc77b3          	and	a5,s8,a5
    800051c8:	ff9d                	bnez	a5,80005106 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800051ca:	e1842c83          	lw	s9,-488(s0)
    800051ce:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800051d2:	f60b8ae3          	beqz	s7,80005146 <exec+0x312>
    800051d6:	89de                	mv	s3,s7
    800051d8:	4481                	li	s1,0
    800051da:	b371                	j	80004f66 <exec+0x132>

00000000800051dc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800051dc:	7179                	addi	sp,sp,-48
    800051de:	f406                	sd	ra,40(sp)
    800051e0:	f022                	sd	s0,32(sp)
    800051e2:	ec26                	sd	s1,24(sp)
    800051e4:	e84a                	sd	s2,16(sp)
    800051e6:	1800                	addi	s0,sp,48
    800051e8:	892e                	mv	s2,a1
    800051ea:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800051ec:	fdc40593          	addi	a1,s0,-36
    800051f0:	ffffe097          	auipc	ra,0xffffe
    800051f4:	880080e7          	jalr	-1920(ra) # 80002a70 <argint>
    800051f8:	04054063          	bltz	a0,80005238 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800051fc:	fdc42703          	lw	a4,-36(s0)
    80005200:	47bd                	li	a5,15
    80005202:	02e7ed63          	bltu	a5,a4,8000523c <argfd+0x60>
    80005206:	ffffc097          	auipc	ra,0xffffc
    8000520a:	7ba080e7          	jalr	1978(ra) # 800019c0 <myproc>
    8000520e:	fdc42703          	lw	a4,-36(s0)
    80005212:	01a70793          	addi	a5,a4,26
    80005216:	078e                	slli	a5,a5,0x3
    80005218:	953e                	add	a0,a0,a5
    8000521a:	611c                	ld	a5,0(a0)
    8000521c:	c395                	beqz	a5,80005240 <argfd+0x64>
    return -1;
  if(pfd)
    8000521e:	00090463          	beqz	s2,80005226 <argfd+0x4a>
    *pfd = fd;
    80005222:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005226:	4501                	li	a0,0
  if(pf)
    80005228:	c091                	beqz	s1,8000522c <argfd+0x50>
    *pf = f;
    8000522a:	e09c                	sd	a5,0(s1)
}
    8000522c:	70a2                	ld	ra,40(sp)
    8000522e:	7402                	ld	s0,32(sp)
    80005230:	64e2                	ld	s1,24(sp)
    80005232:	6942                	ld	s2,16(sp)
    80005234:	6145                	addi	sp,sp,48
    80005236:	8082                	ret
    return -1;
    80005238:	557d                	li	a0,-1
    8000523a:	bfcd                	j	8000522c <argfd+0x50>
    return -1;
    8000523c:	557d                	li	a0,-1
    8000523e:	b7fd                	j	8000522c <argfd+0x50>
    80005240:	557d                	li	a0,-1
    80005242:	b7ed                	j	8000522c <argfd+0x50>

0000000080005244 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005244:	1101                	addi	sp,sp,-32
    80005246:	ec06                	sd	ra,24(sp)
    80005248:	e822                	sd	s0,16(sp)
    8000524a:	e426                	sd	s1,8(sp)
    8000524c:	1000                	addi	s0,sp,32
    8000524e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005250:	ffffc097          	auipc	ra,0xffffc
    80005254:	770080e7          	jalr	1904(ra) # 800019c0 <myproc>
    80005258:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000525a:	0d050793          	addi	a5,a0,208
    8000525e:	4501                	li	a0,0
    80005260:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005262:	6398                	ld	a4,0(a5)
    80005264:	cb19                	beqz	a4,8000527a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005266:	2505                	addiw	a0,a0,1
    80005268:	07a1                	addi	a5,a5,8
    8000526a:	fed51ce3          	bne	a0,a3,80005262 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000526e:	557d                	li	a0,-1
}
    80005270:	60e2                	ld	ra,24(sp)
    80005272:	6442                	ld	s0,16(sp)
    80005274:	64a2                	ld	s1,8(sp)
    80005276:	6105                	addi	sp,sp,32
    80005278:	8082                	ret
      p->ofile[fd] = f;
    8000527a:	01a50793          	addi	a5,a0,26
    8000527e:	078e                	slli	a5,a5,0x3
    80005280:	963e                	add	a2,a2,a5
    80005282:	e204                	sd	s1,0(a2)
      return fd;
    80005284:	b7f5                	j	80005270 <fdalloc+0x2c>

0000000080005286 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005286:	715d                	addi	sp,sp,-80
    80005288:	e486                	sd	ra,72(sp)
    8000528a:	e0a2                	sd	s0,64(sp)
    8000528c:	fc26                	sd	s1,56(sp)
    8000528e:	f84a                	sd	s2,48(sp)
    80005290:	f44e                	sd	s3,40(sp)
    80005292:	f052                	sd	s4,32(sp)
    80005294:	ec56                	sd	s5,24(sp)
    80005296:	0880                	addi	s0,sp,80
    80005298:	89ae                	mv	s3,a1
    8000529a:	8ab2                	mv	s5,a2
    8000529c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000529e:	fb040593          	addi	a1,s0,-80
    800052a2:	fffff097          	auipc	ra,0xfffff
    800052a6:	e76080e7          	jalr	-394(ra) # 80004118 <nameiparent>
    800052aa:	892a                	mv	s2,a0
    800052ac:	12050e63          	beqz	a0,800053e8 <create+0x162>
    return 0;

  ilock(dp);
    800052b0:	ffffe097          	auipc	ra,0xffffe
    800052b4:	4c2080e7          	jalr	1218(ra) # 80003772 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800052b8:	4601                	li	a2,0
    800052ba:	fb040593          	addi	a1,s0,-80
    800052be:	854a                	mv	a0,s2
    800052c0:	fffff097          	auipc	ra,0xfffff
    800052c4:	aa0080e7          	jalr	-1376(ra) # 80003d60 <dirlookup>
    800052c8:	84aa                	mv	s1,a0
    800052ca:	c921                	beqz	a0,8000531a <create+0x94>
    iunlockput(dp);
    800052cc:	854a                	mv	a0,s2
    800052ce:	fffff097          	auipc	ra,0xfffff
    800052d2:	80e080e7          	jalr	-2034(ra) # 80003adc <iunlockput>
    ilock(ip);
    800052d6:	8526                	mv	a0,s1
    800052d8:	ffffe097          	auipc	ra,0xffffe
    800052dc:	49a080e7          	jalr	1178(ra) # 80003772 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800052e0:	2981                	sext.w	s3,s3
    800052e2:	4789                	li	a5,2
    800052e4:	02f99463          	bne	s3,a5,8000530c <create+0x86>
    800052e8:	0444d783          	lhu	a5,68(s1)
    800052ec:	37f9                	addiw	a5,a5,-2
    800052ee:	17c2                	slli	a5,a5,0x30
    800052f0:	93c1                	srli	a5,a5,0x30
    800052f2:	4705                	li	a4,1
    800052f4:	00f76c63          	bltu	a4,a5,8000530c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800052f8:	8526                	mv	a0,s1
    800052fa:	60a6                	ld	ra,72(sp)
    800052fc:	6406                	ld	s0,64(sp)
    800052fe:	74e2                	ld	s1,56(sp)
    80005300:	7942                	ld	s2,48(sp)
    80005302:	79a2                	ld	s3,40(sp)
    80005304:	7a02                	ld	s4,32(sp)
    80005306:	6ae2                	ld	s5,24(sp)
    80005308:	6161                	addi	sp,sp,80
    8000530a:	8082                	ret
    iunlockput(ip);
    8000530c:	8526                	mv	a0,s1
    8000530e:	ffffe097          	auipc	ra,0xffffe
    80005312:	7ce080e7          	jalr	1998(ra) # 80003adc <iunlockput>
    return 0;
    80005316:	4481                	li	s1,0
    80005318:	b7c5                	j	800052f8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000531a:	85ce                	mv	a1,s3
    8000531c:	00092503          	lw	a0,0(s2)
    80005320:	ffffe097          	auipc	ra,0xffffe
    80005324:	2ba080e7          	jalr	698(ra) # 800035da <ialloc>
    80005328:	84aa                	mv	s1,a0
    8000532a:	c521                	beqz	a0,80005372 <create+0xec>
  ilock(ip);
    8000532c:	ffffe097          	auipc	ra,0xffffe
    80005330:	446080e7          	jalr	1094(ra) # 80003772 <ilock>
  ip->major = major;
    80005334:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005338:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000533c:	4a05                	li	s4,1
    8000533e:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005342:	8526                	mv	a0,s1
    80005344:	ffffe097          	auipc	ra,0xffffe
    80005348:	364080e7          	jalr	868(ra) # 800036a8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000534c:	2981                	sext.w	s3,s3
    8000534e:	03498a63          	beq	s3,s4,80005382 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005352:	40d0                	lw	a2,4(s1)
    80005354:	fb040593          	addi	a1,s0,-80
    80005358:	854a                	mv	a0,s2
    8000535a:	fffff097          	auipc	ra,0xfffff
    8000535e:	cde080e7          	jalr	-802(ra) # 80004038 <dirlink>
    80005362:	06054b63          	bltz	a0,800053d8 <create+0x152>
  iunlockput(dp);
    80005366:	854a                	mv	a0,s2
    80005368:	ffffe097          	auipc	ra,0xffffe
    8000536c:	774080e7          	jalr	1908(ra) # 80003adc <iunlockput>
  return ip;
    80005370:	b761                	j	800052f8 <create+0x72>
    panic("create: ialloc");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	36650513          	addi	a0,a0,870 # 800086d8 <syscalls+0x2a8>
    8000537a:	ffffb097          	auipc	ra,0xffffb
    8000537e:	1b0080e7          	jalr	432(ra) # 8000052a <panic>
    dp->nlink++;  // for ".."
    80005382:	04a95783          	lhu	a5,74(s2)
    80005386:	2785                	addiw	a5,a5,1
    80005388:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000538c:	854a                	mv	a0,s2
    8000538e:	ffffe097          	auipc	ra,0xffffe
    80005392:	31a080e7          	jalr	794(ra) # 800036a8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005396:	40d0                	lw	a2,4(s1)
    80005398:	00003597          	auipc	a1,0x3
    8000539c:	35058593          	addi	a1,a1,848 # 800086e8 <syscalls+0x2b8>
    800053a0:	8526                	mv	a0,s1
    800053a2:	fffff097          	auipc	ra,0xfffff
    800053a6:	c96080e7          	jalr	-874(ra) # 80004038 <dirlink>
    800053aa:	00054f63          	bltz	a0,800053c8 <create+0x142>
    800053ae:	00492603          	lw	a2,4(s2)
    800053b2:	00003597          	auipc	a1,0x3
    800053b6:	33e58593          	addi	a1,a1,830 # 800086f0 <syscalls+0x2c0>
    800053ba:	8526                	mv	a0,s1
    800053bc:	fffff097          	auipc	ra,0xfffff
    800053c0:	c7c080e7          	jalr	-900(ra) # 80004038 <dirlink>
    800053c4:	f80557e3          	bgez	a0,80005352 <create+0xcc>
      panic("create dots");
    800053c8:	00003517          	auipc	a0,0x3
    800053cc:	33050513          	addi	a0,a0,816 # 800086f8 <syscalls+0x2c8>
    800053d0:	ffffb097          	auipc	ra,0xffffb
    800053d4:	15a080e7          	jalr	346(ra) # 8000052a <panic>
    panic("create: dirlink");
    800053d8:	00003517          	auipc	a0,0x3
    800053dc:	33050513          	addi	a0,a0,816 # 80008708 <syscalls+0x2d8>
    800053e0:	ffffb097          	auipc	ra,0xffffb
    800053e4:	14a080e7          	jalr	330(ra) # 8000052a <panic>
    return 0;
    800053e8:	84aa                	mv	s1,a0
    800053ea:	b739                	j	800052f8 <create+0x72>

00000000800053ec <sys_dup>:
{
    800053ec:	7179                	addi	sp,sp,-48
    800053ee:	f406                	sd	ra,40(sp)
    800053f0:	f022                	sd	s0,32(sp)
    800053f2:	ec26                	sd	s1,24(sp)
    800053f4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800053f6:	fd840613          	addi	a2,s0,-40
    800053fa:	4581                	li	a1,0
    800053fc:	4501                	li	a0,0
    800053fe:	00000097          	auipc	ra,0x0
    80005402:	dde080e7          	jalr	-546(ra) # 800051dc <argfd>
    return -1;
    80005406:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005408:	02054363          	bltz	a0,8000542e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000540c:	fd843503          	ld	a0,-40(s0)
    80005410:	00000097          	auipc	ra,0x0
    80005414:	e34080e7          	jalr	-460(ra) # 80005244 <fdalloc>
    80005418:	84aa                	mv	s1,a0
    return -1;
    8000541a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000541c:	00054963          	bltz	a0,8000542e <sys_dup+0x42>
  filedup(f);
    80005420:	fd843503          	ld	a0,-40(s0)
    80005424:	fffff097          	auipc	ra,0xfffff
    80005428:	36c080e7          	jalr	876(ra) # 80004790 <filedup>
  return fd;
    8000542c:	87a6                	mv	a5,s1
}
    8000542e:	853e                	mv	a0,a5
    80005430:	70a2                	ld	ra,40(sp)
    80005432:	7402                	ld	s0,32(sp)
    80005434:	64e2                	ld	s1,24(sp)
    80005436:	6145                	addi	sp,sp,48
    80005438:	8082                	ret

000000008000543a <sys_read>:
{
    8000543a:	7179                	addi	sp,sp,-48
    8000543c:	f406                	sd	ra,40(sp)
    8000543e:	f022                	sd	s0,32(sp)
    80005440:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005442:	fe840613          	addi	a2,s0,-24
    80005446:	4581                	li	a1,0
    80005448:	4501                	li	a0,0
    8000544a:	00000097          	auipc	ra,0x0
    8000544e:	d92080e7          	jalr	-622(ra) # 800051dc <argfd>
    return -1;
    80005452:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005454:	04054163          	bltz	a0,80005496 <sys_read+0x5c>
    80005458:	fe440593          	addi	a1,s0,-28
    8000545c:	4509                	li	a0,2
    8000545e:	ffffd097          	auipc	ra,0xffffd
    80005462:	612080e7          	jalr	1554(ra) # 80002a70 <argint>
    return -1;
    80005466:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005468:	02054763          	bltz	a0,80005496 <sys_read+0x5c>
    8000546c:	fd840593          	addi	a1,s0,-40
    80005470:	4505                	li	a0,1
    80005472:	ffffd097          	auipc	ra,0xffffd
    80005476:	620080e7          	jalr	1568(ra) # 80002a92 <argaddr>
    return -1;
    8000547a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000547c:	00054d63          	bltz	a0,80005496 <sys_read+0x5c>
  return fileread(f, p, n);
    80005480:	fe442603          	lw	a2,-28(s0)
    80005484:	fd843583          	ld	a1,-40(s0)
    80005488:	fe843503          	ld	a0,-24(s0)
    8000548c:	fffff097          	auipc	ra,0xfffff
    80005490:	490080e7          	jalr	1168(ra) # 8000491c <fileread>
    80005494:	87aa                	mv	a5,a0
}
    80005496:	853e                	mv	a0,a5
    80005498:	70a2                	ld	ra,40(sp)
    8000549a:	7402                	ld	s0,32(sp)
    8000549c:	6145                	addi	sp,sp,48
    8000549e:	8082                	ret

00000000800054a0 <sys_write>:
{
    800054a0:	7179                	addi	sp,sp,-48
    800054a2:	f406                	sd	ra,40(sp)
    800054a4:	f022                	sd	s0,32(sp)
    800054a6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054a8:	fe840613          	addi	a2,s0,-24
    800054ac:	4581                	li	a1,0
    800054ae:	4501                	li	a0,0
    800054b0:	00000097          	auipc	ra,0x0
    800054b4:	d2c080e7          	jalr	-724(ra) # 800051dc <argfd>
    return -1;
    800054b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054ba:	04054163          	bltz	a0,800054fc <sys_write+0x5c>
    800054be:	fe440593          	addi	a1,s0,-28
    800054c2:	4509                	li	a0,2
    800054c4:	ffffd097          	auipc	ra,0xffffd
    800054c8:	5ac080e7          	jalr	1452(ra) # 80002a70 <argint>
    return -1;
    800054cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054ce:	02054763          	bltz	a0,800054fc <sys_write+0x5c>
    800054d2:	fd840593          	addi	a1,s0,-40
    800054d6:	4505                	li	a0,1
    800054d8:	ffffd097          	auipc	ra,0xffffd
    800054dc:	5ba080e7          	jalr	1466(ra) # 80002a92 <argaddr>
    return -1;
    800054e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054e2:	00054d63          	bltz	a0,800054fc <sys_write+0x5c>
  return filewrite(f, p, n);
    800054e6:	fe442603          	lw	a2,-28(s0)
    800054ea:	fd843583          	ld	a1,-40(s0)
    800054ee:	fe843503          	ld	a0,-24(s0)
    800054f2:	fffff097          	auipc	ra,0xfffff
    800054f6:	4ec080e7          	jalr	1260(ra) # 800049de <filewrite>
    800054fa:	87aa                	mv	a5,a0
}
    800054fc:	853e                	mv	a0,a5
    800054fe:	70a2                	ld	ra,40(sp)
    80005500:	7402                	ld	s0,32(sp)
    80005502:	6145                	addi	sp,sp,48
    80005504:	8082                	ret

0000000080005506 <sys_close>:
{
    80005506:	1101                	addi	sp,sp,-32
    80005508:	ec06                	sd	ra,24(sp)
    8000550a:	e822                	sd	s0,16(sp)
    8000550c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000550e:	fe040613          	addi	a2,s0,-32
    80005512:	fec40593          	addi	a1,s0,-20
    80005516:	4501                	li	a0,0
    80005518:	00000097          	auipc	ra,0x0
    8000551c:	cc4080e7          	jalr	-828(ra) # 800051dc <argfd>
    return -1;
    80005520:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005522:	02054463          	bltz	a0,8000554a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005526:	ffffc097          	auipc	ra,0xffffc
    8000552a:	49a080e7          	jalr	1178(ra) # 800019c0 <myproc>
    8000552e:	fec42783          	lw	a5,-20(s0)
    80005532:	07e9                	addi	a5,a5,26
    80005534:	078e                	slli	a5,a5,0x3
    80005536:	97aa                	add	a5,a5,a0
    80005538:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000553c:	fe043503          	ld	a0,-32(s0)
    80005540:	fffff097          	auipc	ra,0xfffff
    80005544:	2a2080e7          	jalr	674(ra) # 800047e2 <fileclose>
  return 0;
    80005548:	4781                	li	a5,0
}
    8000554a:	853e                	mv	a0,a5
    8000554c:	60e2                	ld	ra,24(sp)
    8000554e:	6442                	ld	s0,16(sp)
    80005550:	6105                	addi	sp,sp,32
    80005552:	8082                	ret

0000000080005554 <sys_fstat>:
{
    80005554:	1101                	addi	sp,sp,-32
    80005556:	ec06                	sd	ra,24(sp)
    80005558:	e822                	sd	s0,16(sp)
    8000555a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000555c:	fe840613          	addi	a2,s0,-24
    80005560:	4581                	li	a1,0
    80005562:	4501                	li	a0,0
    80005564:	00000097          	auipc	ra,0x0
    80005568:	c78080e7          	jalr	-904(ra) # 800051dc <argfd>
    return -1;
    8000556c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000556e:	02054563          	bltz	a0,80005598 <sys_fstat+0x44>
    80005572:	fe040593          	addi	a1,s0,-32
    80005576:	4505                	li	a0,1
    80005578:	ffffd097          	auipc	ra,0xffffd
    8000557c:	51a080e7          	jalr	1306(ra) # 80002a92 <argaddr>
    return -1;
    80005580:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005582:	00054b63          	bltz	a0,80005598 <sys_fstat+0x44>
  return filestat(f, st);
    80005586:	fe043583          	ld	a1,-32(s0)
    8000558a:	fe843503          	ld	a0,-24(s0)
    8000558e:	fffff097          	auipc	ra,0xfffff
    80005592:	31c080e7          	jalr	796(ra) # 800048aa <filestat>
    80005596:	87aa                	mv	a5,a0
}
    80005598:	853e                	mv	a0,a5
    8000559a:	60e2                	ld	ra,24(sp)
    8000559c:	6442                	ld	s0,16(sp)
    8000559e:	6105                	addi	sp,sp,32
    800055a0:	8082                	ret

00000000800055a2 <sys_link>:
{
    800055a2:	7169                	addi	sp,sp,-304
    800055a4:	f606                	sd	ra,296(sp)
    800055a6:	f222                	sd	s0,288(sp)
    800055a8:	ee26                	sd	s1,280(sp)
    800055aa:	ea4a                	sd	s2,272(sp)
    800055ac:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055ae:	08000613          	li	a2,128
    800055b2:	ed040593          	addi	a1,s0,-304
    800055b6:	4501                	li	a0,0
    800055b8:	ffffd097          	auipc	ra,0xffffd
    800055bc:	4fc080e7          	jalr	1276(ra) # 80002ab4 <argstr>
    return -1;
    800055c0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055c2:	10054e63          	bltz	a0,800056de <sys_link+0x13c>
    800055c6:	08000613          	li	a2,128
    800055ca:	f5040593          	addi	a1,s0,-176
    800055ce:	4505                	li	a0,1
    800055d0:	ffffd097          	auipc	ra,0xffffd
    800055d4:	4e4080e7          	jalr	1252(ra) # 80002ab4 <argstr>
    return -1;
    800055d8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055da:	10054263          	bltz	a0,800056de <sys_link+0x13c>
  begin_op();
    800055de:	fffff097          	auipc	ra,0xfffff
    800055e2:	d38080e7          	jalr	-712(ra) # 80004316 <begin_op>
  if((ip = namei(old)) == 0){
    800055e6:	ed040513          	addi	a0,s0,-304
    800055ea:	fffff097          	auipc	ra,0xfffff
    800055ee:	b10080e7          	jalr	-1264(ra) # 800040fa <namei>
    800055f2:	84aa                	mv	s1,a0
    800055f4:	c551                	beqz	a0,80005680 <sys_link+0xde>
  ilock(ip);
    800055f6:	ffffe097          	auipc	ra,0xffffe
    800055fa:	17c080e7          	jalr	380(ra) # 80003772 <ilock>
  if(ip->type == T_DIR){
    800055fe:	04449703          	lh	a4,68(s1)
    80005602:	4785                	li	a5,1
    80005604:	08f70463          	beq	a4,a5,8000568c <sys_link+0xea>
  ip->nlink++;
    80005608:	04a4d783          	lhu	a5,74(s1)
    8000560c:	2785                	addiw	a5,a5,1
    8000560e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005612:	8526                	mv	a0,s1
    80005614:	ffffe097          	auipc	ra,0xffffe
    80005618:	094080e7          	jalr	148(ra) # 800036a8 <iupdate>
  iunlock(ip);
    8000561c:	8526                	mv	a0,s1
    8000561e:	ffffe097          	auipc	ra,0xffffe
    80005622:	216080e7          	jalr	534(ra) # 80003834 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005626:	fd040593          	addi	a1,s0,-48
    8000562a:	f5040513          	addi	a0,s0,-176
    8000562e:	fffff097          	auipc	ra,0xfffff
    80005632:	aea080e7          	jalr	-1302(ra) # 80004118 <nameiparent>
    80005636:	892a                	mv	s2,a0
    80005638:	c935                	beqz	a0,800056ac <sys_link+0x10a>
  ilock(dp);
    8000563a:	ffffe097          	auipc	ra,0xffffe
    8000563e:	138080e7          	jalr	312(ra) # 80003772 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005642:	00092703          	lw	a4,0(s2)
    80005646:	409c                	lw	a5,0(s1)
    80005648:	04f71d63          	bne	a4,a5,800056a2 <sys_link+0x100>
    8000564c:	40d0                	lw	a2,4(s1)
    8000564e:	fd040593          	addi	a1,s0,-48
    80005652:	854a                	mv	a0,s2
    80005654:	fffff097          	auipc	ra,0xfffff
    80005658:	9e4080e7          	jalr	-1564(ra) # 80004038 <dirlink>
    8000565c:	04054363          	bltz	a0,800056a2 <sys_link+0x100>
  iunlockput(dp);
    80005660:	854a                	mv	a0,s2
    80005662:	ffffe097          	auipc	ra,0xffffe
    80005666:	47a080e7          	jalr	1146(ra) # 80003adc <iunlockput>
  iput(ip);
    8000566a:	8526                	mv	a0,s1
    8000566c:	ffffe097          	auipc	ra,0xffffe
    80005670:	3c8080e7          	jalr	968(ra) # 80003a34 <iput>
  end_op();
    80005674:	fffff097          	auipc	ra,0xfffff
    80005678:	d22080e7          	jalr	-734(ra) # 80004396 <end_op>
  return 0;
    8000567c:	4781                	li	a5,0
    8000567e:	a085                	j	800056de <sys_link+0x13c>
    end_op();
    80005680:	fffff097          	auipc	ra,0xfffff
    80005684:	d16080e7          	jalr	-746(ra) # 80004396 <end_op>
    return -1;
    80005688:	57fd                	li	a5,-1
    8000568a:	a891                	j	800056de <sys_link+0x13c>
    iunlockput(ip);
    8000568c:	8526                	mv	a0,s1
    8000568e:	ffffe097          	auipc	ra,0xffffe
    80005692:	44e080e7          	jalr	1102(ra) # 80003adc <iunlockput>
    end_op();
    80005696:	fffff097          	auipc	ra,0xfffff
    8000569a:	d00080e7          	jalr	-768(ra) # 80004396 <end_op>
    return -1;
    8000569e:	57fd                	li	a5,-1
    800056a0:	a83d                	j	800056de <sys_link+0x13c>
    iunlockput(dp);
    800056a2:	854a                	mv	a0,s2
    800056a4:	ffffe097          	auipc	ra,0xffffe
    800056a8:	438080e7          	jalr	1080(ra) # 80003adc <iunlockput>
  ilock(ip);
    800056ac:	8526                	mv	a0,s1
    800056ae:	ffffe097          	auipc	ra,0xffffe
    800056b2:	0c4080e7          	jalr	196(ra) # 80003772 <ilock>
  ip->nlink--;
    800056b6:	04a4d783          	lhu	a5,74(s1)
    800056ba:	37fd                	addiw	a5,a5,-1
    800056bc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800056c0:	8526                	mv	a0,s1
    800056c2:	ffffe097          	auipc	ra,0xffffe
    800056c6:	fe6080e7          	jalr	-26(ra) # 800036a8 <iupdate>
  iunlockput(ip);
    800056ca:	8526                	mv	a0,s1
    800056cc:	ffffe097          	auipc	ra,0xffffe
    800056d0:	410080e7          	jalr	1040(ra) # 80003adc <iunlockput>
  end_op();
    800056d4:	fffff097          	auipc	ra,0xfffff
    800056d8:	cc2080e7          	jalr	-830(ra) # 80004396 <end_op>
  return -1;
    800056dc:	57fd                	li	a5,-1
}
    800056de:	853e                	mv	a0,a5
    800056e0:	70b2                	ld	ra,296(sp)
    800056e2:	7412                	ld	s0,288(sp)
    800056e4:	64f2                	ld	s1,280(sp)
    800056e6:	6952                	ld	s2,272(sp)
    800056e8:	6155                	addi	sp,sp,304
    800056ea:	8082                	ret

00000000800056ec <sys_unlink>:
{
    800056ec:	7151                	addi	sp,sp,-240
    800056ee:	f586                	sd	ra,232(sp)
    800056f0:	f1a2                	sd	s0,224(sp)
    800056f2:	eda6                	sd	s1,216(sp)
    800056f4:	e9ca                	sd	s2,208(sp)
    800056f6:	e5ce                	sd	s3,200(sp)
    800056f8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800056fa:	08000613          	li	a2,128
    800056fe:	f3040593          	addi	a1,s0,-208
    80005702:	4501                	li	a0,0
    80005704:	ffffd097          	auipc	ra,0xffffd
    80005708:	3b0080e7          	jalr	944(ra) # 80002ab4 <argstr>
    8000570c:	18054163          	bltz	a0,8000588e <sys_unlink+0x1a2>
  begin_op();
    80005710:	fffff097          	auipc	ra,0xfffff
    80005714:	c06080e7          	jalr	-1018(ra) # 80004316 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005718:	fb040593          	addi	a1,s0,-80
    8000571c:	f3040513          	addi	a0,s0,-208
    80005720:	fffff097          	auipc	ra,0xfffff
    80005724:	9f8080e7          	jalr	-1544(ra) # 80004118 <nameiparent>
    80005728:	84aa                	mv	s1,a0
    8000572a:	c979                	beqz	a0,80005800 <sys_unlink+0x114>
  ilock(dp);
    8000572c:	ffffe097          	auipc	ra,0xffffe
    80005730:	046080e7          	jalr	70(ra) # 80003772 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005734:	00003597          	auipc	a1,0x3
    80005738:	fb458593          	addi	a1,a1,-76 # 800086e8 <syscalls+0x2b8>
    8000573c:	fb040513          	addi	a0,s0,-80
    80005740:	ffffe097          	auipc	ra,0xffffe
    80005744:	606080e7          	jalr	1542(ra) # 80003d46 <namecmp>
    80005748:	14050a63          	beqz	a0,8000589c <sys_unlink+0x1b0>
    8000574c:	00003597          	auipc	a1,0x3
    80005750:	fa458593          	addi	a1,a1,-92 # 800086f0 <syscalls+0x2c0>
    80005754:	fb040513          	addi	a0,s0,-80
    80005758:	ffffe097          	auipc	ra,0xffffe
    8000575c:	5ee080e7          	jalr	1518(ra) # 80003d46 <namecmp>
    80005760:	12050e63          	beqz	a0,8000589c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005764:	f2c40613          	addi	a2,s0,-212
    80005768:	fb040593          	addi	a1,s0,-80
    8000576c:	8526                	mv	a0,s1
    8000576e:	ffffe097          	auipc	ra,0xffffe
    80005772:	5f2080e7          	jalr	1522(ra) # 80003d60 <dirlookup>
    80005776:	892a                	mv	s2,a0
    80005778:	12050263          	beqz	a0,8000589c <sys_unlink+0x1b0>
  ilock(ip);
    8000577c:	ffffe097          	auipc	ra,0xffffe
    80005780:	ff6080e7          	jalr	-10(ra) # 80003772 <ilock>
  if(ip->nlink < 1)
    80005784:	04a91783          	lh	a5,74(s2)
    80005788:	08f05263          	blez	a5,8000580c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000578c:	04491703          	lh	a4,68(s2)
    80005790:	4785                	li	a5,1
    80005792:	08f70563          	beq	a4,a5,8000581c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005796:	4641                	li	a2,16
    80005798:	4581                	li	a1,0
    8000579a:	fc040513          	addi	a0,s0,-64
    8000579e:	ffffb097          	auipc	ra,0xffffb
    800057a2:	520080e7          	jalr	1312(ra) # 80000cbe <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800057a6:	4741                	li	a4,16
    800057a8:	f2c42683          	lw	a3,-212(s0)
    800057ac:	fc040613          	addi	a2,s0,-64
    800057b0:	4581                	li	a1,0
    800057b2:	8526                	mv	a0,s1
    800057b4:	ffffe097          	auipc	ra,0xffffe
    800057b8:	472080e7          	jalr	1138(ra) # 80003c26 <writei>
    800057bc:	47c1                	li	a5,16
    800057be:	0af51563          	bne	a0,a5,80005868 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800057c2:	04491703          	lh	a4,68(s2)
    800057c6:	4785                	li	a5,1
    800057c8:	0af70863          	beq	a4,a5,80005878 <sys_unlink+0x18c>
  iunlockput(dp);
    800057cc:	8526                	mv	a0,s1
    800057ce:	ffffe097          	auipc	ra,0xffffe
    800057d2:	30e080e7          	jalr	782(ra) # 80003adc <iunlockput>
  ip->nlink--;
    800057d6:	04a95783          	lhu	a5,74(s2)
    800057da:	37fd                	addiw	a5,a5,-1
    800057dc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800057e0:	854a                	mv	a0,s2
    800057e2:	ffffe097          	auipc	ra,0xffffe
    800057e6:	ec6080e7          	jalr	-314(ra) # 800036a8 <iupdate>
  iunlockput(ip);
    800057ea:	854a                	mv	a0,s2
    800057ec:	ffffe097          	auipc	ra,0xffffe
    800057f0:	2f0080e7          	jalr	752(ra) # 80003adc <iunlockput>
  end_op();
    800057f4:	fffff097          	auipc	ra,0xfffff
    800057f8:	ba2080e7          	jalr	-1118(ra) # 80004396 <end_op>
  return 0;
    800057fc:	4501                	li	a0,0
    800057fe:	a84d                	j	800058b0 <sys_unlink+0x1c4>
    end_op();
    80005800:	fffff097          	auipc	ra,0xfffff
    80005804:	b96080e7          	jalr	-1130(ra) # 80004396 <end_op>
    return -1;
    80005808:	557d                	li	a0,-1
    8000580a:	a05d                	j	800058b0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000580c:	00003517          	auipc	a0,0x3
    80005810:	f0c50513          	addi	a0,a0,-244 # 80008718 <syscalls+0x2e8>
    80005814:	ffffb097          	auipc	ra,0xffffb
    80005818:	d16080e7          	jalr	-746(ra) # 8000052a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000581c:	04c92703          	lw	a4,76(s2)
    80005820:	02000793          	li	a5,32
    80005824:	f6e7f9e3          	bgeu	a5,a4,80005796 <sys_unlink+0xaa>
    80005828:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000582c:	4741                	li	a4,16
    8000582e:	86ce                	mv	a3,s3
    80005830:	f1840613          	addi	a2,s0,-232
    80005834:	4581                	li	a1,0
    80005836:	854a                	mv	a0,s2
    80005838:	ffffe097          	auipc	ra,0xffffe
    8000583c:	2f6080e7          	jalr	758(ra) # 80003b2e <readi>
    80005840:	47c1                	li	a5,16
    80005842:	00f51b63          	bne	a0,a5,80005858 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005846:	f1845783          	lhu	a5,-232(s0)
    8000584a:	e7a1                	bnez	a5,80005892 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000584c:	29c1                	addiw	s3,s3,16
    8000584e:	04c92783          	lw	a5,76(s2)
    80005852:	fcf9ede3          	bltu	s3,a5,8000582c <sys_unlink+0x140>
    80005856:	b781                	j	80005796 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005858:	00003517          	auipc	a0,0x3
    8000585c:	ed850513          	addi	a0,a0,-296 # 80008730 <syscalls+0x300>
    80005860:	ffffb097          	auipc	ra,0xffffb
    80005864:	cca080e7          	jalr	-822(ra) # 8000052a <panic>
    panic("unlink: writei");
    80005868:	00003517          	auipc	a0,0x3
    8000586c:	ee050513          	addi	a0,a0,-288 # 80008748 <syscalls+0x318>
    80005870:	ffffb097          	auipc	ra,0xffffb
    80005874:	cba080e7          	jalr	-838(ra) # 8000052a <panic>
    dp->nlink--;
    80005878:	04a4d783          	lhu	a5,74(s1)
    8000587c:	37fd                	addiw	a5,a5,-1
    8000587e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005882:	8526                	mv	a0,s1
    80005884:	ffffe097          	auipc	ra,0xffffe
    80005888:	e24080e7          	jalr	-476(ra) # 800036a8 <iupdate>
    8000588c:	b781                	j	800057cc <sys_unlink+0xe0>
    return -1;
    8000588e:	557d                	li	a0,-1
    80005890:	a005                	j	800058b0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005892:	854a                	mv	a0,s2
    80005894:	ffffe097          	auipc	ra,0xffffe
    80005898:	248080e7          	jalr	584(ra) # 80003adc <iunlockput>
  iunlockput(dp);
    8000589c:	8526                	mv	a0,s1
    8000589e:	ffffe097          	auipc	ra,0xffffe
    800058a2:	23e080e7          	jalr	574(ra) # 80003adc <iunlockput>
  end_op();
    800058a6:	fffff097          	auipc	ra,0xfffff
    800058aa:	af0080e7          	jalr	-1296(ra) # 80004396 <end_op>
  return -1;
    800058ae:	557d                	li	a0,-1
}
    800058b0:	70ae                	ld	ra,232(sp)
    800058b2:	740e                	ld	s0,224(sp)
    800058b4:	64ee                	ld	s1,216(sp)
    800058b6:	694e                	ld	s2,208(sp)
    800058b8:	69ae                	ld	s3,200(sp)
    800058ba:	616d                	addi	sp,sp,240
    800058bc:	8082                	ret

00000000800058be <sys_open>:

uint64
sys_open(void)
{
    800058be:	7155                	addi	sp,sp,-208
    800058c0:	e586                	sd	ra,200(sp)
    800058c2:	e1a2                	sd	s0,192(sp)
    800058c4:	fd26                	sd	s1,184(sp)
    800058c6:	f94a                	sd	s2,176(sp)
    800058c8:	f54e                	sd	s3,168(sp)
    800058ca:	f152                	sd	s4,160(sp)
    800058cc:	ed56                	sd	s5,152(sp)
    800058ce:	0980                	addi	s0,sp,208
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800058d0:	08000613          	li	a2,128
    800058d4:	f4040593          	addi	a1,s0,-192
    800058d8:	4501                	li	a0,0
    800058da:	ffffd097          	auipc	ra,0xffffd
    800058de:	1da080e7          	jalr	474(ra) # 80002ab4 <argstr>
    return -1;
    800058e2:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800058e4:	12054c63          	bltz	a0,80005a1c <sys_open+0x15e>
    800058e8:	f3c40593          	addi	a1,s0,-196
    800058ec:	4505                	li	a0,1
    800058ee:	ffffd097          	auipc	ra,0xffffd
    800058f2:	182080e7          	jalr	386(ra) # 80002a70 <argint>
    800058f6:	12054363          	bltz	a0,80005a1c <sys_open+0x15e>

  begin_op();
    800058fa:	fffff097          	auipc	ra,0xfffff
    800058fe:	a1c080e7          	jalr	-1508(ra) # 80004316 <begin_op>


  if(omode & O_CREATE){
    80005902:	f3c42983          	lw	s3,-196(s0)
    80005906:	2009f793          	andi	a5,s3,512
    8000590a:	efa5                	bnez	a5,80005982 <sys_open+0xc4>
      end_op();
      return -1;
    }
  } else {
    // check if it is symbolic link
    if((omode & O_NOFOLLOW) == 0) {
    8000590c:	0049f993          	andi	s3,s3,4
    80005910:	14099363          	bnez	s3,80005a56 <sys_open+0x198>
          end_op();
          return -1;
        }
        ilock(ip);

        if(ip->type == T_SYMLINK) {
    80005914:	4a11                	li	s4,4
      while (depth < 21) {
    80005916:	4ad5                	li	s5,21
        if((ip = namei(path)) == 0){
    80005918:	f4040513          	addi	a0,s0,-192
    8000591c:	ffffe097          	auipc	ra,0xffffe
    80005920:	7de080e7          	jalr	2014(ra) # 800040fa <namei>
    80005924:	84aa                	mv	s1,a0
    80005926:	10050a63          	beqz	a0,80005a3a <sys_open+0x17c>
        ilock(ip);
    8000592a:	ffffe097          	auipc	ra,0xffffe
    8000592e:	e48080e7          	jalr	-440(ra) # 80003772 <ilock>
        if(ip->type == T_SYMLINK) {
    80005932:	04449783          	lh	a5,68(s1)
    80005936:	11479863          	bne	a5,s4,80005a46 <sys_open+0x188>
          struct buf *b = bread(ip->dev, ip->addrs[0]);
    8000593a:	48ac                	lw	a1,80(s1)
    8000593c:	4088                	lw	a0,0(s1)
    8000593e:	ffffd097          	auipc	ra,0xffffd
    80005942:	4a0080e7          	jalr	1184(ra) # 80002dde <bread>
    80005946:	892a                	mv	s2,a0
          memmove(path, b->data, MAXPATH);
    80005948:	08000613          	li	a2,128
    8000594c:	05850593          	addi	a1,a0,88
    80005950:	f4040513          	addi	a0,s0,-192
    80005954:	ffffb097          	auipc	ra,0xffffb
    80005958:	3c6080e7          	jalr	966(ra) # 80000d1a <memmove>
          brelse(b);
    8000595c:	854a                	mv	a0,s2
    8000595e:	ffffd097          	auipc	ra,0xffffd
    80005962:	5b0080e7          	jalr	1456(ra) # 80002f0e <brelse>
        else {
          iunlockput(ip);
          break;
        }

        iunlockput(ip);
    80005966:	8526                	mv	a0,s1
    80005968:	ffffe097          	auipc	ra,0xffffe
    8000596c:	174080e7          	jalr	372(ra) # 80003adc <iunlockput>
        depth++;
    80005970:	2985                	addiw	s3,s3,1
      while (depth < 21) {
    80005972:	fb5993e3          	bne	s3,s5,80005918 <sys_open+0x5a>
      }

      if(depth >= 20){
        end_op();
    80005976:	fffff097          	auipc	ra,0xfffff
    8000597a:	a20080e7          	jalr	-1504(ra) # 80004396 <end_op>
        return -1;
    8000597e:	54fd                	li	s1,-1
    80005980:	a871                	j	80005a1c <sys_open+0x15e>
    ip = create(path, T_FILE, 0, 0);
    80005982:	4681                	li	a3,0
    80005984:	4601                	li	a2,0
    80005986:	4589                	li	a1,2
    80005988:	f4040513          	addi	a0,s0,-192
    8000598c:	00000097          	auipc	ra,0x0
    80005990:	8fa080e7          	jalr	-1798(ra) # 80005286 <create>
    80005994:	892a                	mv	s2,a0
    if(ip == 0){
    80005996:	cd49                	beqz	a0,80005a30 <sys_open+0x172>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005998:	04491703          	lh	a4,68(s2)
    8000599c:	478d                	li	a5,3
    8000599e:	00f71763          	bne	a4,a5,800059ac <sys_open+0xee>
    800059a2:	04695703          	lhu	a4,70(s2)
    800059a6:	47a5                	li	a5,9
    800059a8:	0ee7ec63          	bltu	a5,a4,80005aa0 <sys_open+0x1e2>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800059ac:	fffff097          	auipc	ra,0xfffff
    800059b0:	d7a080e7          	jalr	-646(ra) # 80004726 <filealloc>
    800059b4:	89aa                	mv	s3,a0
    800059b6:	12050263          	beqz	a0,80005ada <sys_open+0x21c>
    800059ba:	00000097          	auipc	ra,0x0
    800059be:	88a080e7          	jalr	-1910(ra) # 80005244 <fdalloc>
    800059c2:	84aa                	mv	s1,a0
    800059c4:	10054663          	bltz	a0,80005ad0 <sys_open+0x212>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800059c8:	04491703          	lh	a4,68(s2)
    800059cc:	478d                	li	a5,3
    800059ce:	0ef70463          	beq	a4,a5,80005ab6 <sys_open+0x1f8>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800059d2:	4789                	li	a5,2
    800059d4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800059d8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800059dc:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800059e0:	f3c42783          	lw	a5,-196(s0)
    800059e4:	0017c713          	xori	a4,a5,1
    800059e8:	8b05                	andi	a4,a4,1
    800059ea:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800059ee:	0037f713          	andi	a4,a5,3
    800059f2:	00e03733          	snez	a4,a4
    800059f6:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800059fa:	4007f793          	andi	a5,a5,1024
    800059fe:	c791                	beqz	a5,80005a0a <sys_open+0x14c>
    80005a00:	04491703          	lh	a4,68(s2)
    80005a04:	4789                	li	a5,2
    80005a06:	0af70f63          	beq	a4,a5,80005ac4 <sys_open+0x206>
    itrunc(ip);
  }

  iunlock(ip);
    80005a0a:	854a                	mv	a0,s2
    80005a0c:	ffffe097          	auipc	ra,0xffffe
    80005a10:	e28080e7          	jalr	-472(ra) # 80003834 <iunlock>
  end_op();
    80005a14:	fffff097          	auipc	ra,0xfffff
    80005a18:	982080e7          	jalr	-1662(ra) # 80004396 <end_op>

  return fd;
}
    80005a1c:	8526                	mv	a0,s1
    80005a1e:	60ae                	ld	ra,200(sp)
    80005a20:	640e                	ld	s0,192(sp)
    80005a22:	74ea                	ld	s1,184(sp)
    80005a24:	794a                	ld	s2,176(sp)
    80005a26:	79aa                	ld	s3,168(sp)
    80005a28:	7a0a                	ld	s4,160(sp)
    80005a2a:	6aea                	ld	s5,152(sp)
    80005a2c:	6169                	addi	sp,sp,208
    80005a2e:	8082                	ret
      end_op();
    80005a30:	fffff097          	auipc	ra,0xfffff
    80005a34:	966080e7          	jalr	-1690(ra) # 80004396 <end_op>
      return -1;
    80005a38:	b7d5                	j	80005a1c <sys_open+0x15e>
          end_op();
    80005a3a:	fffff097          	auipc	ra,0xfffff
    80005a3e:	95c080e7          	jalr	-1700(ra) # 80004396 <end_op>
          return -1;
    80005a42:	54fd                	li	s1,-1
    80005a44:	bfe1                	j	80005a1c <sys_open+0x15e>
          iunlockput(ip);
    80005a46:	8526                	mv	a0,s1
    80005a48:	ffffe097          	auipc	ra,0xffffe
    80005a4c:	094080e7          	jalr	148(ra) # 80003adc <iunlockput>
      if(depth >= 20){
    80005a50:	47cd                	li	a5,19
    80005a52:	f337c2e3          	blt	a5,s3,80005976 <sys_open+0xb8>
    if((ip = namei(path)) == 0){
    80005a56:	f4040513          	addi	a0,s0,-192
    80005a5a:	ffffe097          	auipc	ra,0xffffe
    80005a5e:	6a0080e7          	jalr	1696(ra) # 800040fa <namei>
    80005a62:	892a                	mv	s2,a0
    80005a64:	c905                	beqz	a0,80005a94 <sys_open+0x1d6>
    ilock(ip);
    80005a66:	ffffe097          	auipc	ra,0xffffe
    80005a6a:	d0c080e7          	jalr	-756(ra) # 80003772 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005a6e:	04491703          	lh	a4,68(s2)
    80005a72:	4785                	li	a5,1
    80005a74:	f2f712e3          	bne	a4,a5,80005998 <sys_open+0xda>
    80005a78:	f3c42783          	lw	a5,-196(s0)
    80005a7c:	db85                	beqz	a5,800059ac <sys_open+0xee>
      iunlockput(ip);
    80005a7e:	854a                	mv	a0,s2
    80005a80:	ffffe097          	auipc	ra,0xffffe
    80005a84:	05c080e7          	jalr	92(ra) # 80003adc <iunlockput>
      end_op();
    80005a88:	fffff097          	auipc	ra,0xfffff
    80005a8c:	90e080e7          	jalr	-1778(ra) # 80004396 <end_op>
      return -1;
    80005a90:	54fd                	li	s1,-1
    80005a92:	b769                	j	80005a1c <sys_open+0x15e>
      end_op();
    80005a94:	fffff097          	auipc	ra,0xfffff
    80005a98:	902080e7          	jalr	-1790(ra) # 80004396 <end_op>
      return -1;
    80005a9c:	54fd                	li	s1,-1
    80005a9e:	bfbd                	j	80005a1c <sys_open+0x15e>
    iunlockput(ip);
    80005aa0:	854a                	mv	a0,s2
    80005aa2:	ffffe097          	auipc	ra,0xffffe
    80005aa6:	03a080e7          	jalr	58(ra) # 80003adc <iunlockput>
    end_op();
    80005aaa:	fffff097          	auipc	ra,0xfffff
    80005aae:	8ec080e7          	jalr	-1812(ra) # 80004396 <end_op>
    return -1;
    80005ab2:	54fd                	li	s1,-1
    80005ab4:	b7a5                	j	80005a1c <sys_open+0x15e>
    f->type = FD_DEVICE;
    80005ab6:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005aba:	04691783          	lh	a5,70(s2)
    80005abe:	02f99223          	sh	a5,36(s3)
    80005ac2:	bf29                	j	800059dc <sys_open+0x11e>
    itrunc(ip);
    80005ac4:	854a                	mv	a0,s2
    80005ac6:	ffffe097          	auipc	ra,0xffffe
    80005aca:	dba080e7          	jalr	-582(ra) # 80003880 <itrunc>
    80005ace:	bf35                	j	80005a0a <sys_open+0x14c>
      fileclose(f);
    80005ad0:	854e                	mv	a0,s3
    80005ad2:	fffff097          	auipc	ra,0xfffff
    80005ad6:	d10080e7          	jalr	-752(ra) # 800047e2 <fileclose>
    iunlockput(ip);
    80005ada:	854a                	mv	a0,s2
    80005adc:	ffffe097          	auipc	ra,0xffffe
    80005ae0:	000080e7          	jalr	ra # 80003adc <iunlockput>
    end_op();
    80005ae4:	fffff097          	auipc	ra,0xfffff
    80005ae8:	8b2080e7          	jalr	-1870(ra) # 80004396 <end_op>
    return -1;
    80005aec:	54fd                	li	s1,-1
    80005aee:	b73d                	j	80005a1c <sys_open+0x15e>

0000000080005af0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005af0:	7175                	addi	sp,sp,-144
    80005af2:	e506                	sd	ra,136(sp)
    80005af4:	e122                	sd	s0,128(sp)
    80005af6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005af8:	fffff097          	auipc	ra,0xfffff
    80005afc:	81e080e7          	jalr	-2018(ra) # 80004316 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005b00:	08000613          	li	a2,128
    80005b04:	f7040593          	addi	a1,s0,-144
    80005b08:	4501                	li	a0,0
    80005b0a:	ffffd097          	auipc	ra,0xffffd
    80005b0e:	faa080e7          	jalr	-86(ra) # 80002ab4 <argstr>
    80005b12:	02054963          	bltz	a0,80005b44 <sys_mkdir+0x54>
    80005b16:	4681                	li	a3,0
    80005b18:	4601                	li	a2,0
    80005b1a:	4585                	li	a1,1
    80005b1c:	f7040513          	addi	a0,s0,-144
    80005b20:	fffff097          	auipc	ra,0xfffff
    80005b24:	766080e7          	jalr	1894(ra) # 80005286 <create>
    80005b28:	cd11                	beqz	a0,80005b44 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b2a:	ffffe097          	auipc	ra,0xffffe
    80005b2e:	fb2080e7          	jalr	-78(ra) # 80003adc <iunlockput>
  end_op();
    80005b32:	fffff097          	auipc	ra,0xfffff
    80005b36:	864080e7          	jalr	-1948(ra) # 80004396 <end_op>
  return 0;
    80005b3a:	4501                	li	a0,0
}
    80005b3c:	60aa                	ld	ra,136(sp)
    80005b3e:	640a                	ld	s0,128(sp)
    80005b40:	6149                	addi	sp,sp,144
    80005b42:	8082                	ret
    end_op();
    80005b44:	fffff097          	auipc	ra,0xfffff
    80005b48:	852080e7          	jalr	-1966(ra) # 80004396 <end_op>
    return -1;
    80005b4c:	557d                	li	a0,-1
    80005b4e:	b7fd                	j	80005b3c <sys_mkdir+0x4c>

0000000080005b50 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005b50:	7135                	addi	sp,sp,-160
    80005b52:	ed06                	sd	ra,152(sp)
    80005b54:	e922                	sd	s0,144(sp)
    80005b56:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005b58:	ffffe097          	auipc	ra,0xffffe
    80005b5c:	7be080e7          	jalr	1982(ra) # 80004316 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b60:	08000613          	li	a2,128
    80005b64:	f7040593          	addi	a1,s0,-144
    80005b68:	4501                	li	a0,0
    80005b6a:	ffffd097          	auipc	ra,0xffffd
    80005b6e:	f4a080e7          	jalr	-182(ra) # 80002ab4 <argstr>
    80005b72:	04054a63          	bltz	a0,80005bc6 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005b76:	f6c40593          	addi	a1,s0,-148
    80005b7a:	4505                	li	a0,1
    80005b7c:	ffffd097          	auipc	ra,0xffffd
    80005b80:	ef4080e7          	jalr	-268(ra) # 80002a70 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b84:	04054163          	bltz	a0,80005bc6 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005b88:	f6840593          	addi	a1,s0,-152
    80005b8c:	4509                	li	a0,2
    80005b8e:	ffffd097          	auipc	ra,0xffffd
    80005b92:	ee2080e7          	jalr	-286(ra) # 80002a70 <argint>
     argint(1, &major) < 0 ||
    80005b96:	02054863          	bltz	a0,80005bc6 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005b9a:	f6841683          	lh	a3,-152(s0)
    80005b9e:	f6c41603          	lh	a2,-148(s0)
    80005ba2:	458d                	li	a1,3
    80005ba4:	f7040513          	addi	a0,s0,-144
    80005ba8:	fffff097          	auipc	ra,0xfffff
    80005bac:	6de080e7          	jalr	1758(ra) # 80005286 <create>
     argint(2, &minor) < 0 ||
    80005bb0:	c919                	beqz	a0,80005bc6 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005bb2:	ffffe097          	auipc	ra,0xffffe
    80005bb6:	f2a080e7          	jalr	-214(ra) # 80003adc <iunlockput>
  end_op();
    80005bba:	ffffe097          	auipc	ra,0xffffe
    80005bbe:	7dc080e7          	jalr	2012(ra) # 80004396 <end_op>
  return 0;
    80005bc2:	4501                	li	a0,0
    80005bc4:	a031                	j	80005bd0 <sys_mknod+0x80>
    end_op();
    80005bc6:	ffffe097          	auipc	ra,0xffffe
    80005bca:	7d0080e7          	jalr	2000(ra) # 80004396 <end_op>
    return -1;
    80005bce:	557d                	li	a0,-1
}
    80005bd0:	60ea                	ld	ra,152(sp)
    80005bd2:	644a                	ld	s0,144(sp)
    80005bd4:	610d                	addi	sp,sp,160
    80005bd6:	8082                	ret

0000000080005bd8 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005bd8:	7135                	addi	sp,sp,-160
    80005bda:	ed06                	sd	ra,152(sp)
    80005bdc:	e922                	sd	s0,144(sp)
    80005bde:	e526                	sd	s1,136(sp)
    80005be0:	e14a                	sd	s2,128(sp)
    80005be2:	1100                	addi	s0,sp,160
  // You can modify this to cd into a symbolic link
  // The modification may not be necessary,
  // depending on you implementation.
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005be4:	ffffc097          	auipc	ra,0xffffc
    80005be8:	ddc080e7          	jalr	-548(ra) # 800019c0 <myproc>
    80005bec:	892a                	mv	s2,a0
  
  begin_op();
    80005bee:	ffffe097          	auipc	ra,0xffffe
    80005bf2:	728080e7          	jalr	1832(ra) # 80004316 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005bf6:	08000613          	li	a2,128
    80005bfa:	f6040593          	addi	a1,s0,-160
    80005bfe:	4501                	li	a0,0
    80005c00:	ffffd097          	auipc	ra,0xffffd
    80005c04:	eb4080e7          	jalr	-332(ra) # 80002ab4 <argstr>
    80005c08:	04054b63          	bltz	a0,80005c5e <sys_chdir+0x86>
    80005c0c:	f6040513          	addi	a0,s0,-160
    80005c10:	ffffe097          	auipc	ra,0xffffe
    80005c14:	4ea080e7          	jalr	1258(ra) # 800040fa <namei>
    80005c18:	84aa                	mv	s1,a0
    80005c1a:	c131                	beqz	a0,80005c5e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005c1c:	ffffe097          	auipc	ra,0xffffe
    80005c20:	b56080e7          	jalr	-1194(ra) # 80003772 <ilock>
  // check type
  if(ip->type != T_DIR){
    80005c24:	04449703          	lh	a4,68(s1)
    80005c28:	4785                	li	a5,1
    80005c2a:	04f71063          	bne	a4,a5,80005c6a <sys_chdir+0x92>
      memmove(path, b->data, MAXPATH);
      brelse(b);
  }
  */

  iunlock(ip);
    80005c2e:	8526                	mv	a0,s1
    80005c30:	ffffe097          	auipc	ra,0xffffe
    80005c34:	c04080e7          	jalr	-1020(ra) # 80003834 <iunlock>
  iput(p->cwd);
    80005c38:	15093503          	ld	a0,336(s2)
    80005c3c:	ffffe097          	auipc	ra,0xffffe
    80005c40:	df8080e7          	jalr	-520(ra) # 80003a34 <iput>
  end_op();
    80005c44:	ffffe097          	auipc	ra,0xffffe
    80005c48:	752080e7          	jalr	1874(ra) # 80004396 <end_op>
  p->cwd = ip;
    80005c4c:	14993823          	sd	s1,336(s2)
  return 0;
    80005c50:	4501                	li	a0,0
}
    80005c52:	60ea                	ld	ra,152(sp)
    80005c54:	644a                	ld	s0,144(sp)
    80005c56:	64aa                	ld	s1,136(sp)
    80005c58:	690a                	ld	s2,128(sp)
    80005c5a:	610d                	addi	sp,sp,160
    80005c5c:	8082                	ret
    end_op();
    80005c5e:	ffffe097          	auipc	ra,0xffffe
    80005c62:	738080e7          	jalr	1848(ra) # 80004396 <end_op>
    return -1;
    80005c66:	557d                	li	a0,-1
    80005c68:	b7ed                	j	80005c52 <sys_chdir+0x7a>
    iunlockput(ip);
    80005c6a:	8526                	mv	a0,s1
    80005c6c:	ffffe097          	auipc	ra,0xffffe
    80005c70:	e70080e7          	jalr	-400(ra) # 80003adc <iunlockput>
    end_op();
    80005c74:	ffffe097          	auipc	ra,0xffffe
    80005c78:	722080e7          	jalr	1826(ra) # 80004396 <end_op>
    return -1;
    80005c7c:	557d                	li	a0,-1
    80005c7e:	bfd1                	j	80005c52 <sys_chdir+0x7a>

0000000080005c80 <sys_exec>:

uint64
sys_exec(void)
{
    80005c80:	7145                	addi	sp,sp,-464
    80005c82:	e786                	sd	ra,456(sp)
    80005c84:	e3a2                	sd	s0,448(sp)
    80005c86:	ff26                	sd	s1,440(sp)
    80005c88:	fb4a                	sd	s2,432(sp)
    80005c8a:	f74e                	sd	s3,424(sp)
    80005c8c:	f352                	sd	s4,416(sp)
    80005c8e:	ef56                	sd	s5,408(sp)
    80005c90:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005c92:	08000613          	li	a2,128
    80005c96:	f4040593          	addi	a1,s0,-192
    80005c9a:	4501                	li	a0,0
    80005c9c:	ffffd097          	auipc	ra,0xffffd
    80005ca0:	e18080e7          	jalr	-488(ra) # 80002ab4 <argstr>
    return -1;
    80005ca4:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005ca6:	0c054a63          	bltz	a0,80005d7a <sys_exec+0xfa>
    80005caa:	e3840593          	addi	a1,s0,-456
    80005cae:	4505                	li	a0,1
    80005cb0:	ffffd097          	auipc	ra,0xffffd
    80005cb4:	de2080e7          	jalr	-542(ra) # 80002a92 <argaddr>
    80005cb8:	0c054163          	bltz	a0,80005d7a <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005cbc:	10000613          	li	a2,256
    80005cc0:	4581                	li	a1,0
    80005cc2:	e4040513          	addi	a0,s0,-448
    80005cc6:	ffffb097          	auipc	ra,0xffffb
    80005cca:	ff8080e7          	jalr	-8(ra) # 80000cbe <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005cce:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005cd2:	89a6                	mv	s3,s1
    80005cd4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005cd6:	02000a13          	li	s4,32
    80005cda:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005cde:	00391793          	slli	a5,s2,0x3
    80005ce2:	e3040593          	addi	a1,s0,-464
    80005ce6:	e3843503          	ld	a0,-456(s0)
    80005cea:	953e                	add	a0,a0,a5
    80005cec:	ffffd097          	auipc	ra,0xffffd
    80005cf0:	cea080e7          	jalr	-790(ra) # 800029d6 <fetchaddr>
    80005cf4:	02054a63          	bltz	a0,80005d28 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005cf8:	e3043783          	ld	a5,-464(s0)
    80005cfc:	c3b9                	beqz	a5,80005d42 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005cfe:	ffffb097          	auipc	ra,0xffffb
    80005d02:	dd4080e7          	jalr	-556(ra) # 80000ad2 <kalloc>
    80005d06:	85aa                	mv	a1,a0
    80005d08:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005d0c:	cd11                	beqz	a0,80005d28 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005d0e:	6605                	lui	a2,0x1
    80005d10:	e3043503          	ld	a0,-464(s0)
    80005d14:	ffffd097          	auipc	ra,0xffffd
    80005d18:	d14080e7          	jalr	-748(ra) # 80002a28 <fetchstr>
    80005d1c:	00054663          	bltz	a0,80005d28 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005d20:	0905                	addi	s2,s2,1
    80005d22:	09a1                	addi	s3,s3,8
    80005d24:	fb491be3          	bne	s2,s4,80005cda <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d28:	10048913          	addi	s2,s1,256
    80005d2c:	6088                	ld	a0,0(s1)
    80005d2e:	c529                	beqz	a0,80005d78 <sys_exec+0xf8>
    kfree(argv[i]);
    80005d30:	ffffb097          	auipc	ra,0xffffb
    80005d34:	ca6080e7          	jalr	-858(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d38:	04a1                	addi	s1,s1,8
    80005d3a:	ff2499e3          	bne	s1,s2,80005d2c <sys_exec+0xac>
  return -1;
    80005d3e:	597d                	li	s2,-1
    80005d40:	a82d                	j	80005d7a <sys_exec+0xfa>
      argv[i] = 0;
    80005d42:	0a8e                	slli	s5,s5,0x3
    80005d44:	fc040793          	addi	a5,s0,-64
    80005d48:	9abe                	add	s5,s5,a5
    80005d4a:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e80>
  int ret = exec(path, argv);
    80005d4e:	e4040593          	addi	a1,s0,-448
    80005d52:	f4040513          	addi	a0,s0,-192
    80005d56:	fffff097          	auipc	ra,0xfffff
    80005d5a:	0de080e7          	jalr	222(ra) # 80004e34 <exec>
    80005d5e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d60:	10048993          	addi	s3,s1,256
    80005d64:	6088                	ld	a0,0(s1)
    80005d66:	c911                	beqz	a0,80005d7a <sys_exec+0xfa>
    kfree(argv[i]);
    80005d68:	ffffb097          	auipc	ra,0xffffb
    80005d6c:	c6e080e7          	jalr	-914(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d70:	04a1                	addi	s1,s1,8
    80005d72:	ff3499e3          	bne	s1,s3,80005d64 <sys_exec+0xe4>
    80005d76:	a011                	j	80005d7a <sys_exec+0xfa>
  return -1;
    80005d78:	597d                	li	s2,-1
}
    80005d7a:	854a                	mv	a0,s2
    80005d7c:	60be                	ld	ra,456(sp)
    80005d7e:	641e                	ld	s0,448(sp)
    80005d80:	74fa                	ld	s1,440(sp)
    80005d82:	795a                	ld	s2,432(sp)
    80005d84:	79ba                	ld	s3,424(sp)
    80005d86:	7a1a                	ld	s4,416(sp)
    80005d88:	6afa                	ld	s5,408(sp)
    80005d8a:	6179                	addi	sp,sp,464
    80005d8c:	8082                	ret

0000000080005d8e <sys_pipe>:

uint64
sys_pipe(void)
{
    80005d8e:	7139                	addi	sp,sp,-64
    80005d90:	fc06                	sd	ra,56(sp)
    80005d92:	f822                	sd	s0,48(sp)
    80005d94:	f426                	sd	s1,40(sp)
    80005d96:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005d98:	ffffc097          	auipc	ra,0xffffc
    80005d9c:	c28080e7          	jalr	-984(ra) # 800019c0 <myproc>
    80005da0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005da2:	fd840593          	addi	a1,s0,-40
    80005da6:	4501                	li	a0,0
    80005da8:	ffffd097          	auipc	ra,0xffffd
    80005dac:	cea080e7          	jalr	-790(ra) # 80002a92 <argaddr>
    return -1;
    80005db0:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005db2:	0e054063          	bltz	a0,80005e92 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005db6:	fc840593          	addi	a1,s0,-56
    80005dba:	fd040513          	addi	a0,s0,-48
    80005dbe:	fffff097          	auipc	ra,0xfffff
    80005dc2:	d54080e7          	jalr	-684(ra) # 80004b12 <pipealloc>
    return -1;
    80005dc6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005dc8:	0c054563          	bltz	a0,80005e92 <sys_pipe+0x104>
  fd0 = -1;
    80005dcc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005dd0:	fd043503          	ld	a0,-48(s0)
    80005dd4:	fffff097          	auipc	ra,0xfffff
    80005dd8:	470080e7          	jalr	1136(ra) # 80005244 <fdalloc>
    80005ddc:	fca42223          	sw	a0,-60(s0)
    80005de0:	08054c63          	bltz	a0,80005e78 <sys_pipe+0xea>
    80005de4:	fc843503          	ld	a0,-56(s0)
    80005de8:	fffff097          	auipc	ra,0xfffff
    80005dec:	45c080e7          	jalr	1116(ra) # 80005244 <fdalloc>
    80005df0:	fca42023          	sw	a0,-64(s0)
    80005df4:	06054863          	bltz	a0,80005e64 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005df8:	4691                	li	a3,4
    80005dfa:	fc440613          	addi	a2,s0,-60
    80005dfe:	fd843583          	ld	a1,-40(s0)
    80005e02:	68a8                	ld	a0,80(s1)
    80005e04:	ffffc097          	auipc	ra,0xffffc
    80005e08:	87c080e7          	jalr	-1924(ra) # 80001680 <copyout>
    80005e0c:	02054063          	bltz	a0,80005e2c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005e10:	4691                	li	a3,4
    80005e12:	fc040613          	addi	a2,s0,-64
    80005e16:	fd843583          	ld	a1,-40(s0)
    80005e1a:	0591                	addi	a1,a1,4
    80005e1c:	68a8                	ld	a0,80(s1)
    80005e1e:	ffffc097          	auipc	ra,0xffffc
    80005e22:	862080e7          	jalr	-1950(ra) # 80001680 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005e26:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e28:	06055563          	bgez	a0,80005e92 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005e2c:	fc442783          	lw	a5,-60(s0)
    80005e30:	07e9                	addi	a5,a5,26
    80005e32:	078e                	slli	a5,a5,0x3
    80005e34:	97a6                	add	a5,a5,s1
    80005e36:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005e3a:	fc042503          	lw	a0,-64(s0)
    80005e3e:	0569                	addi	a0,a0,26
    80005e40:	050e                	slli	a0,a0,0x3
    80005e42:	9526                	add	a0,a0,s1
    80005e44:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005e48:	fd043503          	ld	a0,-48(s0)
    80005e4c:	fffff097          	auipc	ra,0xfffff
    80005e50:	996080e7          	jalr	-1642(ra) # 800047e2 <fileclose>
    fileclose(wf);
    80005e54:	fc843503          	ld	a0,-56(s0)
    80005e58:	fffff097          	auipc	ra,0xfffff
    80005e5c:	98a080e7          	jalr	-1654(ra) # 800047e2 <fileclose>
    return -1;
    80005e60:	57fd                	li	a5,-1
    80005e62:	a805                	j	80005e92 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005e64:	fc442783          	lw	a5,-60(s0)
    80005e68:	0007c863          	bltz	a5,80005e78 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005e6c:	01a78513          	addi	a0,a5,26
    80005e70:	050e                	slli	a0,a0,0x3
    80005e72:	9526                	add	a0,a0,s1
    80005e74:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005e78:	fd043503          	ld	a0,-48(s0)
    80005e7c:	fffff097          	auipc	ra,0xfffff
    80005e80:	966080e7          	jalr	-1690(ra) # 800047e2 <fileclose>
    fileclose(wf);
    80005e84:	fc843503          	ld	a0,-56(s0)
    80005e88:	fffff097          	auipc	ra,0xfffff
    80005e8c:	95a080e7          	jalr	-1702(ra) # 800047e2 <fileclose>
    return -1;
    80005e90:	57fd                	li	a5,-1
}
    80005e92:	853e                	mv	a0,a5
    80005e94:	70e2                	ld	ra,56(sp)
    80005e96:	7442                	ld	s0,48(sp)
    80005e98:	74a2                	ld	s1,40(sp)
    80005e9a:	6121                	addi	sp,sp,64
    80005e9c:	8082                	ret

0000000080005e9e <sys_symlink>:

uint64
sys_symlink(void)
{
    80005e9e:	712d                	addi	sp,sp,-288
    80005ea0:	ee06                	sd	ra,280(sp)
    80005ea2:	ea22                	sd	s0,272(sp)
    80005ea4:	e626                	sd	s1,264(sp)
    80005ea6:	1200                	addi	s0,sp,288
  // TODO: symbolic link
  // You should implement this symlink system call.
  char target[MAXPATH], path[MAXPATH];
  struct inode *ip;

  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005ea8:	08000613          	li	a2,128
    80005eac:	f6040593          	addi	a1,s0,-160
    80005eb0:	4501                	li	a0,0
    80005eb2:	ffffd097          	auipc	ra,0xffffd
    80005eb6:	c02080e7          	jalr	-1022(ra) # 80002ab4 <argstr>
    return -1;
    80005eba:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005ebc:	06054563          	bltz	a0,80005f26 <sys_symlink+0x88>
    80005ec0:	08000613          	li	a2,128
    80005ec4:	ee040593          	addi	a1,s0,-288
    80005ec8:	4505                	li	a0,1
    80005eca:	ffffd097          	auipc	ra,0xffffd
    80005ece:	bea080e7          	jalr	-1046(ra) # 80002ab4 <argstr>
    return -1;
    80005ed2:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005ed4:	04054963          	bltz	a0,80005f26 <sys_symlink+0x88>
  
  begin_op();
    80005ed8:	ffffe097          	auipc	ra,0xffffe
    80005edc:	43e080e7          	jalr	1086(ra) # 80004316 <begin_op>

  // create symbolic link
  ip = create(path, T_SYMLINK , 0, 0);
    80005ee0:	4681                	li	a3,0
    80005ee2:	4601                	li	a2,0
    80005ee4:	4591                	li	a1,4
    80005ee6:	ee040513          	addi	a0,s0,-288
    80005eea:	fffff097          	auipc	ra,0xfffff
    80005eee:	39c080e7          	jalr	924(ra) # 80005286 <create>
    80005ef2:	84aa                	mv	s1,a0
  if(ip == 0){
    80005ef4:	cd1d                	beqz	a0,80005f32 <sys_symlink+0x94>
    end_op();
    return -1;
  }

  if(writei(ip, 0, (uint64)target, 0, MAXPATH) != MAXPATH) {
    80005ef6:	08000713          	li	a4,128
    80005efa:	4681                	li	a3,0
    80005efc:	f6040613          	addi	a2,s0,-160
    80005f00:	4581                	li	a1,0
    80005f02:	ffffe097          	auipc	ra,0xffffe
    80005f06:	d24080e7          	jalr	-732(ra) # 80003c26 <writei>
    80005f0a:	08000793          	li	a5,128
    80005f0e:	02f51863          	bne	a0,a5,80005f3e <sys_symlink+0xa0>
    iunlockput(ip);
    end_op();
    return -1;
  }

  iunlockput(ip);
    80005f12:	8526                	mv	a0,s1
    80005f14:	ffffe097          	auipc	ra,0xffffe
    80005f18:	bc8080e7          	jalr	-1080(ra) # 80003adc <iunlockput>

  end_op();
    80005f1c:	ffffe097          	auipc	ra,0xffffe
    80005f20:	47a080e7          	jalr	1146(ra) # 80004396 <end_op>
  return 0;
    80005f24:	4781                	li	a5,0
}
    80005f26:	853e                	mv	a0,a5
    80005f28:	60f2                	ld	ra,280(sp)
    80005f2a:	6452                	ld	s0,272(sp)
    80005f2c:	64b2                	ld	s1,264(sp)
    80005f2e:	6115                	addi	sp,sp,288
    80005f30:	8082                	ret
    end_op();
    80005f32:	ffffe097          	auipc	ra,0xffffe
    80005f36:	464080e7          	jalr	1124(ra) # 80004396 <end_op>
    return -1;
    80005f3a:	57fd                	li	a5,-1
    80005f3c:	b7ed                	j	80005f26 <sys_symlink+0x88>
    iunlockput(ip);
    80005f3e:	8526                	mv	a0,s1
    80005f40:	ffffe097          	auipc	ra,0xffffe
    80005f44:	b9c080e7          	jalr	-1124(ra) # 80003adc <iunlockput>
    end_op();
    80005f48:	ffffe097          	auipc	ra,0xffffe
    80005f4c:	44e080e7          	jalr	1102(ra) # 80004396 <end_op>
    return -1;
    80005f50:	57fd                	li	a5,-1
    80005f52:	bfd1                	j	80005f26 <sys_symlink+0x88>
	...

0000000080005f60 <kernelvec>:
    80005f60:	7111                	addi	sp,sp,-256
    80005f62:	e006                	sd	ra,0(sp)
    80005f64:	e40a                	sd	sp,8(sp)
    80005f66:	e80e                	sd	gp,16(sp)
    80005f68:	ec12                	sd	tp,24(sp)
    80005f6a:	f016                	sd	t0,32(sp)
    80005f6c:	f41a                	sd	t1,40(sp)
    80005f6e:	f81e                	sd	t2,48(sp)
    80005f70:	fc22                	sd	s0,56(sp)
    80005f72:	e0a6                	sd	s1,64(sp)
    80005f74:	e4aa                	sd	a0,72(sp)
    80005f76:	e8ae                	sd	a1,80(sp)
    80005f78:	ecb2                	sd	a2,88(sp)
    80005f7a:	f0b6                	sd	a3,96(sp)
    80005f7c:	f4ba                	sd	a4,104(sp)
    80005f7e:	f8be                	sd	a5,112(sp)
    80005f80:	fcc2                	sd	a6,120(sp)
    80005f82:	e146                	sd	a7,128(sp)
    80005f84:	e54a                	sd	s2,136(sp)
    80005f86:	e94e                	sd	s3,144(sp)
    80005f88:	ed52                	sd	s4,152(sp)
    80005f8a:	f156                	sd	s5,160(sp)
    80005f8c:	f55a                	sd	s6,168(sp)
    80005f8e:	f95e                	sd	s7,176(sp)
    80005f90:	fd62                	sd	s8,184(sp)
    80005f92:	e1e6                	sd	s9,192(sp)
    80005f94:	e5ea                	sd	s10,200(sp)
    80005f96:	e9ee                	sd	s11,208(sp)
    80005f98:	edf2                	sd	t3,216(sp)
    80005f9a:	f1f6                	sd	t4,224(sp)
    80005f9c:	f5fa                	sd	t5,232(sp)
    80005f9e:	f9fe                	sd	t6,240(sp)
    80005fa0:	903fc0ef          	jal	ra,800028a2 <kerneltrap>
    80005fa4:	6082                	ld	ra,0(sp)
    80005fa6:	6122                	ld	sp,8(sp)
    80005fa8:	61c2                	ld	gp,16(sp)
    80005faa:	7282                	ld	t0,32(sp)
    80005fac:	7322                	ld	t1,40(sp)
    80005fae:	73c2                	ld	t2,48(sp)
    80005fb0:	7462                	ld	s0,56(sp)
    80005fb2:	6486                	ld	s1,64(sp)
    80005fb4:	6526                	ld	a0,72(sp)
    80005fb6:	65c6                	ld	a1,80(sp)
    80005fb8:	6666                	ld	a2,88(sp)
    80005fba:	7686                	ld	a3,96(sp)
    80005fbc:	7726                	ld	a4,104(sp)
    80005fbe:	77c6                	ld	a5,112(sp)
    80005fc0:	7866                	ld	a6,120(sp)
    80005fc2:	688a                	ld	a7,128(sp)
    80005fc4:	692a                	ld	s2,136(sp)
    80005fc6:	69ca                	ld	s3,144(sp)
    80005fc8:	6a6a                	ld	s4,152(sp)
    80005fca:	7a8a                	ld	s5,160(sp)
    80005fcc:	7b2a                	ld	s6,168(sp)
    80005fce:	7bca                	ld	s7,176(sp)
    80005fd0:	7c6a                	ld	s8,184(sp)
    80005fd2:	6c8e                	ld	s9,192(sp)
    80005fd4:	6d2e                	ld	s10,200(sp)
    80005fd6:	6dce                	ld	s11,208(sp)
    80005fd8:	6e6e                	ld	t3,216(sp)
    80005fda:	7e8e                	ld	t4,224(sp)
    80005fdc:	7f2e                	ld	t5,232(sp)
    80005fde:	7fce                	ld	t6,240(sp)
    80005fe0:	6111                	addi	sp,sp,256
    80005fe2:	10200073          	sret
    80005fe6:	00000013          	nop
    80005fea:	00000013          	nop
    80005fee:	0001                	nop

0000000080005ff0 <timervec>:
    80005ff0:	34051573          	csrrw	a0,mscratch,a0
    80005ff4:	e10c                	sd	a1,0(a0)
    80005ff6:	e510                	sd	a2,8(a0)
    80005ff8:	e914                	sd	a3,16(a0)
    80005ffa:	6d0c                	ld	a1,24(a0)
    80005ffc:	7110                	ld	a2,32(a0)
    80005ffe:	6194                	ld	a3,0(a1)
    80006000:	96b2                	add	a3,a3,a2
    80006002:	e194                	sd	a3,0(a1)
    80006004:	4589                	li	a1,2
    80006006:	14459073          	csrw	sip,a1
    8000600a:	6914                	ld	a3,16(a0)
    8000600c:	6510                	ld	a2,8(a0)
    8000600e:	610c                	ld	a1,0(a0)
    80006010:	34051573          	csrrw	a0,mscratch,a0
    80006014:	30200073          	mret
	...

000000008000601a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000601a:	1141                	addi	sp,sp,-16
    8000601c:	e422                	sd	s0,8(sp)
    8000601e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006020:	0c0007b7          	lui	a5,0xc000
    80006024:	4705                	li	a4,1
    80006026:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006028:	c3d8                	sw	a4,4(a5)
}
    8000602a:	6422                	ld	s0,8(sp)
    8000602c:	0141                	addi	sp,sp,16
    8000602e:	8082                	ret

0000000080006030 <plicinithart>:

void
plicinithart(void)
{
    80006030:	1141                	addi	sp,sp,-16
    80006032:	e406                	sd	ra,8(sp)
    80006034:	e022                	sd	s0,0(sp)
    80006036:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006038:	ffffc097          	auipc	ra,0xffffc
    8000603c:	95c080e7          	jalr	-1700(ra) # 80001994 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006040:	0085171b          	slliw	a4,a0,0x8
    80006044:	0c0027b7          	lui	a5,0xc002
    80006048:	97ba                	add	a5,a5,a4
    8000604a:	40200713          	li	a4,1026
    8000604e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006052:	00d5151b          	slliw	a0,a0,0xd
    80006056:	0c2017b7          	lui	a5,0xc201
    8000605a:	953e                	add	a0,a0,a5
    8000605c:	00052023          	sw	zero,0(a0)
}
    80006060:	60a2                	ld	ra,8(sp)
    80006062:	6402                	ld	s0,0(sp)
    80006064:	0141                	addi	sp,sp,16
    80006066:	8082                	ret

0000000080006068 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006068:	1141                	addi	sp,sp,-16
    8000606a:	e406                	sd	ra,8(sp)
    8000606c:	e022                	sd	s0,0(sp)
    8000606e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006070:	ffffc097          	auipc	ra,0xffffc
    80006074:	924080e7          	jalr	-1756(ra) # 80001994 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006078:	00d5179b          	slliw	a5,a0,0xd
    8000607c:	0c201537          	lui	a0,0xc201
    80006080:	953e                	add	a0,a0,a5
  return irq;
}
    80006082:	4148                	lw	a0,4(a0)
    80006084:	60a2                	ld	ra,8(sp)
    80006086:	6402                	ld	s0,0(sp)
    80006088:	0141                	addi	sp,sp,16
    8000608a:	8082                	ret

000000008000608c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000608c:	1101                	addi	sp,sp,-32
    8000608e:	ec06                	sd	ra,24(sp)
    80006090:	e822                	sd	s0,16(sp)
    80006092:	e426                	sd	s1,8(sp)
    80006094:	1000                	addi	s0,sp,32
    80006096:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006098:	ffffc097          	auipc	ra,0xffffc
    8000609c:	8fc080e7          	jalr	-1796(ra) # 80001994 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800060a0:	00d5151b          	slliw	a0,a0,0xd
    800060a4:	0c2017b7          	lui	a5,0xc201
    800060a8:	97aa                	add	a5,a5,a0
    800060aa:	c3c4                	sw	s1,4(a5)
}
    800060ac:	60e2                	ld	ra,24(sp)
    800060ae:	6442                	ld	s0,16(sp)
    800060b0:	64a2                	ld	s1,8(sp)
    800060b2:	6105                	addi	sp,sp,32
    800060b4:	8082                	ret

00000000800060b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800060b6:	1141                	addi	sp,sp,-16
    800060b8:	e406                	sd	ra,8(sp)
    800060ba:	e022                	sd	s0,0(sp)
    800060bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800060be:	479d                	li	a5,7
    800060c0:	06a7c963          	blt	a5,a0,80006132 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800060c4:	0001d797          	auipc	a5,0x1d
    800060c8:	f3c78793          	addi	a5,a5,-196 # 80023000 <disk>
    800060cc:	00a78733          	add	a4,a5,a0
    800060d0:	6789                	lui	a5,0x2
    800060d2:	97ba                	add	a5,a5,a4
    800060d4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800060d8:	e7ad                	bnez	a5,80006142 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800060da:	00451793          	slli	a5,a0,0x4
    800060de:	0001f717          	auipc	a4,0x1f
    800060e2:	f2270713          	addi	a4,a4,-222 # 80025000 <disk+0x2000>
    800060e6:	6314                	ld	a3,0(a4)
    800060e8:	96be                	add	a3,a3,a5
    800060ea:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800060ee:	6314                	ld	a3,0(a4)
    800060f0:	96be                	add	a3,a3,a5
    800060f2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800060f6:	6314                	ld	a3,0(a4)
    800060f8:	96be                	add	a3,a3,a5
    800060fa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800060fe:	6318                	ld	a4,0(a4)
    80006100:	97ba                	add	a5,a5,a4
    80006102:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006106:	0001d797          	auipc	a5,0x1d
    8000610a:	efa78793          	addi	a5,a5,-262 # 80023000 <disk>
    8000610e:	97aa                	add	a5,a5,a0
    80006110:	6509                	lui	a0,0x2
    80006112:	953e                	add	a0,a0,a5
    80006114:	4785                	li	a5,1
    80006116:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000611a:	0001f517          	auipc	a0,0x1f
    8000611e:	efe50513          	addi	a0,a0,-258 # 80025018 <disk+0x2018>
    80006122:	ffffc097          	auipc	ra,0xffffc
    80006126:	0ea080e7          	jalr	234(ra) # 8000220c <wakeup>
}
    8000612a:	60a2                	ld	ra,8(sp)
    8000612c:	6402                	ld	s0,0(sp)
    8000612e:	0141                	addi	sp,sp,16
    80006130:	8082                	ret
    panic("free_desc 1");
    80006132:	00002517          	auipc	a0,0x2
    80006136:	62650513          	addi	a0,a0,1574 # 80008758 <syscalls+0x328>
    8000613a:	ffffa097          	auipc	ra,0xffffa
    8000613e:	3f0080e7          	jalr	1008(ra) # 8000052a <panic>
    panic("free_desc 2");
    80006142:	00002517          	auipc	a0,0x2
    80006146:	62650513          	addi	a0,a0,1574 # 80008768 <syscalls+0x338>
    8000614a:	ffffa097          	auipc	ra,0xffffa
    8000614e:	3e0080e7          	jalr	992(ra) # 8000052a <panic>

0000000080006152 <virtio_disk_init>:
{
    80006152:	1101                	addi	sp,sp,-32
    80006154:	ec06                	sd	ra,24(sp)
    80006156:	e822                	sd	s0,16(sp)
    80006158:	e426                	sd	s1,8(sp)
    8000615a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000615c:	00002597          	auipc	a1,0x2
    80006160:	61c58593          	addi	a1,a1,1564 # 80008778 <syscalls+0x348>
    80006164:	0001f517          	auipc	a0,0x1f
    80006168:	fc450513          	addi	a0,a0,-60 # 80025128 <disk+0x2128>
    8000616c:	ffffb097          	auipc	ra,0xffffb
    80006170:	9c6080e7          	jalr	-1594(ra) # 80000b32 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006174:	100017b7          	lui	a5,0x10001
    80006178:	4398                	lw	a4,0(a5)
    8000617a:	2701                	sext.w	a4,a4
    8000617c:	747277b7          	lui	a5,0x74727
    80006180:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006184:	0ef71163          	bne	a4,a5,80006266 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006188:	100017b7          	lui	a5,0x10001
    8000618c:	43dc                	lw	a5,4(a5)
    8000618e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006190:	4705                	li	a4,1
    80006192:	0ce79a63          	bne	a5,a4,80006266 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006196:	100017b7          	lui	a5,0x10001
    8000619a:	479c                	lw	a5,8(a5)
    8000619c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000619e:	4709                	li	a4,2
    800061a0:	0ce79363          	bne	a5,a4,80006266 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800061a4:	100017b7          	lui	a5,0x10001
    800061a8:	47d8                	lw	a4,12(a5)
    800061aa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800061ac:	554d47b7          	lui	a5,0x554d4
    800061b0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800061b4:	0af71963          	bne	a4,a5,80006266 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800061b8:	100017b7          	lui	a5,0x10001
    800061bc:	4705                	li	a4,1
    800061be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061c0:	470d                	li	a4,3
    800061c2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800061c4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800061c6:	c7ffe737          	lui	a4,0xc7ffe
    800061ca:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    800061ce:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800061d0:	2701                	sext.w	a4,a4
    800061d2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061d4:	472d                	li	a4,11
    800061d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061d8:	473d                	li	a4,15
    800061da:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800061dc:	6705                	lui	a4,0x1
    800061de:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800061e0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800061e4:	5bdc                	lw	a5,52(a5)
    800061e6:	2781                	sext.w	a5,a5
  if(max == 0)
    800061e8:	c7d9                	beqz	a5,80006276 <virtio_disk_init+0x124>
  if(max < NUM)
    800061ea:	471d                	li	a4,7
    800061ec:	08f77d63          	bgeu	a4,a5,80006286 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800061f0:	100014b7          	lui	s1,0x10001
    800061f4:	47a1                	li	a5,8
    800061f6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800061f8:	6609                	lui	a2,0x2
    800061fa:	4581                	li	a1,0
    800061fc:	0001d517          	auipc	a0,0x1d
    80006200:	e0450513          	addi	a0,a0,-508 # 80023000 <disk>
    80006204:	ffffb097          	auipc	ra,0xffffb
    80006208:	aba080e7          	jalr	-1350(ra) # 80000cbe <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000620c:	0001d717          	auipc	a4,0x1d
    80006210:	df470713          	addi	a4,a4,-524 # 80023000 <disk>
    80006214:	00c75793          	srli	a5,a4,0xc
    80006218:	2781                	sext.w	a5,a5
    8000621a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000621c:	0001f797          	auipc	a5,0x1f
    80006220:	de478793          	addi	a5,a5,-540 # 80025000 <disk+0x2000>
    80006224:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006226:	0001d717          	auipc	a4,0x1d
    8000622a:	e5a70713          	addi	a4,a4,-422 # 80023080 <disk+0x80>
    8000622e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006230:	0001e717          	auipc	a4,0x1e
    80006234:	dd070713          	addi	a4,a4,-560 # 80024000 <disk+0x1000>
    80006238:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000623a:	4705                	li	a4,1
    8000623c:	00e78c23          	sb	a4,24(a5)
    80006240:	00e78ca3          	sb	a4,25(a5)
    80006244:	00e78d23          	sb	a4,26(a5)
    80006248:	00e78da3          	sb	a4,27(a5)
    8000624c:	00e78e23          	sb	a4,28(a5)
    80006250:	00e78ea3          	sb	a4,29(a5)
    80006254:	00e78f23          	sb	a4,30(a5)
    80006258:	00e78fa3          	sb	a4,31(a5)
}
    8000625c:	60e2                	ld	ra,24(sp)
    8000625e:	6442                	ld	s0,16(sp)
    80006260:	64a2                	ld	s1,8(sp)
    80006262:	6105                	addi	sp,sp,32
    80006264:	8082                	ret
    panic("could not find virtio disk");
    80006266:	00002517          	auipc	a0,0x2
    8000626a:	52250513          	addi	a0,a0,1314 # 80008788 <syscalls+0x358>
    8000626e:	ffffa097          	auipc	ra,0xffffa
    80006272:	2bc080e7          	jalr	700(ra) # 8000052a <panic>
    panic("virtio disk has no queue 0");
    80006276:	00002517          	auipc	a0,0x2
    8000627a:	53250513          	addi	a0,a0,1330 # 800087a8 <syscalls+0x378>
    8000627e:	ffffa097          	auipc	ra,0xffffa
    80006282:	2ac080e7          	jalr	684(ra) # 8000052a <panic>
    panic("virtio disk max queue too short");
    80006286:	00002517          	auipc	a0,0x2
    8000628a:	54250513          	addi	a0,a0,1346 # 800087c8 <syscalls+0x398>
    8000628e:	ffffa097          	auipc	ra,0xffffa
    80006292:	29c080e7          	jalr	668(ra) # 8000052a <panic>

0000000080006296 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006296:	7119                	addi	sp,sp,-128
    80006298:	fc86                	sd	ra,120(sp)
    8000629a:	f8a2                	sd	s0,112(sp)
    8000629c:	f4a6                	sd	s1,104(sp)
    8000629e:	f0ca                	sd	s2,96(sp)
    800062a0:	ecce                	sd	s3,88(sp)
    800062a2:	e8d2                	sd	s4,80(sp)
    800062a4:	e4d6                	sd	s5,72(sp)
    800062a6:	e0da                	sd	s6,64(sp)
    800062a8:	fc5e                	sd	s7,56(sp)
    800062aa:	f862                	sd	s8,48(sp)
    800062ac:	f466                	sd	s9,40(sp)
    800062ae:	f06a                	sd	s10,32(sp)
    800062b0:	ec6e                	sd	s11,24(sp)
    800062b2:	0100                	addi	s0,sp,128
    800062b4:	8aaa                	mv	s5,a0
    800062b6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800062b8:	00c52c83          	lw	s9,12(a0)
    800062bc:	001c9c9b          	slliw	s9,s9,0x1
    800062c0:	1c82                	slli	s9,s9,0x20
    800062c2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800062c6:	0001f517          	auipc	a0,0x1f
    800062ca:	e6250513          	addi	a0,a0,-414 # 80025128 <disk+0x2128>
    800062ce:	ffffb097          	auipc	ra,0xffffb
    800062d2:	8f4080e7          	jalr	-1804(ra) # 80000bc2 <acquire>
  for(int i = 0; i < 3; i++){
    800062d6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800062d8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800062da:	0001dc17          	auipc	s8,0x1d
    800062de:	d26c0c13          	addi	s8,s8,-730 # 80023000 <disk>
    800062e2:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800062e4:	4b0d                	li	s6,3
    800062e6:	a0ad                	j	80006350 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800062e8:	00fc0733          	add	a4,s8,a5
    800062ec:	975e                	add	a4,a4,s7
    800062ee:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800062f2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800062f4:	0207c563          	bltz	a5,8000631e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800062f8:	2905                	addiw	s2,s2,1
    800062fa:	0611                	addi	a2,a2,4
    800062fc:	19690d63          	beq	s2,s6,80006496 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006300:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006302:	0001f717          	auipc	a4,0x1f
    80006306:	d1670713          	addi	a4,a4,-746 # 80025018 <disk+0x2018>
    8000630a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000630c:	00074683          	lbu	a3,0(a4)
    80006310:	fee1                	bnez	a3,800062e8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006312:	2785                	addiw	a5,a5,1
    80006314:	0705                	addi	a4,a4,1
    80006316:	fe979be3          	bne	a5,s1,8000630c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000631a:	57fd                	li	a5,-1
    8000631c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000631e:	01205d63          	blez	s2,80006338 <virtio_disk_rw+0xa2>
    80006322:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006324:	000a2503          	lw	a0,0(s4)
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	d8e080e7          	jalr	-626(ra) # 800060b6 <free_desc>
      for(int j = 0; j < i; j++)
    80006330:	2d85                	addiw	s11,s11,1
    80006332:	0a11                	addi	s4,s4,4
    80006334:	ffb918e3          	bne	s2,s11,80006324 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006338:	0001f597          	auipc	a1,0x1f
    8000633c:	df058593          	addi	a1,a1,-528 # 80025128 <disk+0x2128>
    80006340:	0001f517          	auipc	a0,0x1f
    80006344:	cd850513          	addi	a0,a0,-808 # 80025018 <disk+0x2018>
    80006348:	ffffc097          	auipc	ra,0xffffc
    8000634c:	d38080e7          	jalr	-712(ra) # 80002080 <sleep>
  for(int i = 0; i < 3; i++){
    80006350:	f8040a13          	addi	s4,s0,-128
{
    80006354:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006356:	894e                	mv	s2,s3
    80006358:	b765                	j	80006300 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000635a:	0001f697          	auipc	a3,0x1f
    8000635e:	ca66b683          	ld	a3,-858(a3) # 80025000 <disk+0x2000>
    80006362:	96ba                	add	a3,a3,a4
    80006364:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006368:	0001d817          	auipc	a6,0x1d
    8000636c:	c9880813          	addi	a6,a6,-872 # 80023000 <disk>
    80006370:	0001f697          	auipc	a3,0x1f
    80006374:	c9068693          	addi	a3,a3,-880 # 80025000 <disk+0x2000>
    80006378:	6290                	ld	a2,0(a3)
    8000637a:	963a                	add	a2,a2,a4
    8000637c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006380:	0015e593          	ori	a1,a1,1
    80006384:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006388:	f8842603          	lw	a2,-120(s0)
    8000638c:	628c                	ld	a1,0(a3)
    8000638e:	972e                	add	a4,a4,a1
    80006390:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006394:	20050593          	addi	a1,a0,512
    80006398:	0592                	slli	a1,a1,0x4
    8000639a:	95c2                	add	a1,a1,a6
    8000639c:	577d                	li	a4,-1
    8000639e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800063a2:	00461713          	slli	a4,a2,0x4
    800063a6:	6290                	ld	a2,0(a3)
    800063a8:	963a                	add	a2,a2,a4
    800063aa:	03078793          	addi	a5,a5,48
    800063ae:	97c2                	add	a5,a5,a6
    800063b0:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800063b2:	629c                	ld	a5,0(a3)
    800063b4:	97ba                	add	a5,a5,a4
    800063b6:	4605                	li	a2,1
    800063b8:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800063ba:	629c                	ld	a5,0(a3)
    800063bc:	97ba                	add	a5,a5,a4
    800063be:	4809                	li	a6,2
    800063c0:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800063c4:	629c                	ld	a5,0(a3)
    800063c6:	973e                	add	a4,a4,a5
    800063c8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800063cc:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800063d0:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800063d4:	6698                	ld	a4,8(a3)
    800063d6:	00275783          	lhu	a5,2(a4)
    800063da:	8b9d                	andi	a5,a5,7
    800063dc:	0786                	slli	a5,a5,0x1
    800063de:	97ba                	add	a5,a5,a4
    800063e0:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    800063e4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800063e8:	6698                	ld	a4,8(a3)
    800063ea:	00275783          	lhu	a5,2(a4)
    800063ee:	2785                	addiw	a5,a5,1
    800063f0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800063f4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800063f8:	100017b7          	lui	a5,0x10001
    800063fc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006400:	004aa783          	lw	a5,4(s5)
    80006404:	02c79163          	bne	a5,a2,80006426 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80006408:	0001f917          	auipc	s2,0x1f
    8000640c:	d2090913          	addi	s2,s2,-736 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    80006410:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006412:	85ca                	mv	a1,s2
    80006414:	8556                	mv	a0,s5
    80006416:	ffffc097          	auipc	ra,0xffffc
    8000641a:	c6a080e7          	jalr	-918(ra) # 80002080 <sleep>
  while(b->disk == 1) {
    8000641e:	004aa783          	lw	a5,4(s5)
    80006422:	fe9788e3          	beq	a5,s1,80006412 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006426:	f8042903          	lw	s2,-128(s0)
    8000642a:	20090793          	addi	a5,s2,512
    8000642e:	00479713          	slli	a4,a5,0x4
    80006432:	0001d797          	auipc	a5,0x1d
    80006436:	bce78793          	addi	a5,a5,-1074 # 80023000 <disk>
    8000643a:	97ba                	add	a5,a5,a4
    8000643c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80006440:	0001f997          	auipc	s3,0x1f
    80006444:	bc098993          	addi	s3,s3,-1088 # 80025000 <disk+0x2000>
    80006448:	00491713          	slli	a4,s2,0x4
    8000644c:	0009b783          	ld	a5,0(s3)
    80006450:	97ba                	add	a5,a5,a4
    80006452:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006456:	854a                	mv	a0,s2
    80006458:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000645c:	00000097          	auipc	ra,0x0
    80006460:	c5a080e7          	jalr	-934(ra) # 800060b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006464:	8885                	andi	s1,s1,1
    80006466:	f0ed                	bnez	s1,80006448 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006468:	0001f517          	auipc	a0,0x1f
    8000646c:	cc050513          	addi	a0,a0,-832 # 80025128 <disk+0x2128>
    80006470:	ffffb097          	auipc	ra,0xffffb
    80006474:	806080e7          	jalr	-2042(ra) # 80000c76 <release>
}
    80006478:	70e6                	ld	ra,120(sp)
    8000647a:	7446                	ld	s0,112(sp)
    8000647c:	74a6                	ld	s1,104(sp)
    8000647e:	7906                	ld	s2,96(sp)
    80006480:	69e6                	ld	s3,88(sp)
    80006482:	6a46                	ld	s4,80(sp)
    80006484:	6aa6                	ld	s5,72(sp)
    80006486:	6b06                	ld	s6,64(sp)
    80006488:	7be2                	ld	s7,56(sp)
    8000648a:	7c42                	ld	s8,48(sp)
    8000648c:	7ca2                	ld	s9,40(sp)
    8000648e:	7d02                	ld	s10,32(sp)
    80006490:	6de2                	ld	s11,24(sp)
    80006492:	6109                	addi	sp,sp,128
    80006494:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006496:	f8042503          	lw	a0,-128(s0)
    8000649a:	20050793          	addi	a5,a0,512
    8000649e:	0792                	slli	a5,a5,0x4
  if(write)
    800064a0:	0001d817          	auipc	a6,0x1d
    800064a4:	b6080813          	addi	a6,a6,-1184 # 80023000 <disk>
    800064a8:	00f80733          	add	a4,a6,a5
    800064ac:	01a036b3          	snez	a3,s10
    800064b0:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800064b4:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800064b8:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800064bc:	7679                	lui	a2,0xffffe
    800064be:	963e                	add	a2,a2,a5
    800064c0:	0001f697          	auipc	a3,0x1f
    800064c4:	b4068693          	addi	a3,a3,-1216 # 80025000 <disk+0x2000>
    800064c8:	6298                	ld	a4,0(a3)
    800064ca:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800064cc:	0a878593          	addi	a1,a5,168
    800064d0:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800064d2:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800064d4:	6298                	ld	a4,0(a3)
    800064d6:	9732                	add	a4,a4,a2
    800064d8:	45c1                	li	a1,16
    800064da:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800064dc:	6298                	ld	a4,0(a3)
    800064de:	9732                	add	a4,a4,a2
    800064e0:	4585                	li	a1,1
    800064e2:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800064e6:	f8442703          	lw	a4,-124(s0)
    800064ea:	628c                	ld	a1,0(a3)
    800064ec:	962e                	add	a2,a2,a1
    800064ee:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd800e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800064f2:	0712                	slli	a4,a4,0x4
    800064f4:	6290                	ld	a2,0(a3)
    800064f6:	963a                	add	a2,a2,a4
    800064f8:	058a8593          	addi	a1,s5,88
    800064fc:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800064fe:	6294                	ld	a3,0(a3)
    80006500:	96ba                	add	a3,a3,a4
    80006502:	40000613          	li	a2,1024
    80006506:	c690                	sw	a2,8(a3)
  if(write)
    80006508:	e40d19e3          	bnez	s10,8000635a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000650c:	0001f697          	auipc	a3,0x1f
    80006510:	af46b683          	ld	a3,-1292(a3) # 80025000 <disk+0x2000>
    80006514:	96ba                	add	a3,a3,a4
    80006516:	4609                	li	a2,2
    80006518:	00c69623          	sh	a2,12(a3)
    8000651c:	b5b1                	j	80006368 <virtio_disk_rw+0xd2>

000000008000651e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000651e:	1101                	addi	sp,sp,-32
    80006520:	ec06                	sd	ra,24(sp)
    80006522:	e822                	sd	s0,16(sp)
    80006524:	e426                	sd	s1,8(sp)
    80006526:	e04a                	sd	s2,0(sp)
    80006528:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000652a:	0001f517          	auipc	a0,0x1f
    8000652e:	bfe50513          	addi	a0,a0,-1026 # 80025128 <disk+0x2128>
    80006532:	ffffa097          	auipc	ra,0xffffa
    80006536:	690080e7          	jalr	1680(ra) # 80000bc2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000653a:	10001737          	lui	a4,0x10001
    8000653e:	533c                	lw	a5,96(a4)
    80006540:	8b8d                	andi	a5,a5,3
    80006542:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006544:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006548:	0001f797          	auipc	a5,0x1f
    8000654c:	ab878793          	addi	a5,a5,-1352 # 80025000 <disk+0x2000>
    80006550:	6b94                	ld	a3,16(a5)
    80006552:	0207d703          	lhu	a4,32(a5)
    80006556:	0026d783          	lhu	a5,2(a3)
    8000655a:	06f70163          	beq	a4,a5,800065bc <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000655e:	0001d917          	auipc	s2,0x1d
    80006562:	aa290913          	addi	s2,s2,-1374 # 80023000 <disk>
    80006566:	0001f497          	auipc	s1,0x1f
    8000656a:	a9a48493          	addi	s1,s1,-1382 # 80025000 <disk+0x2000>
    __sync_synchronize();
    8000656e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006572:	6898                	ld	a4,16(s1)
    80006574:	0204d783          	lhu	a5,32(s1)
    80006578:	8b9d                	andi	a5,a5,7
    8000657a:	078e                	slli	a5,a5,0x3
    8000657c:	97ba                	add	a5,a5,a4
    8000657e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006580:	20078713          	addi	a4,a5,512
    80006584:	0712                	slli	a4,a4,0x4
    80006586:	974a                	add	a4,a4,s2
    80006588:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000658c:	e731                	bnez	a4,800065d8 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000658e:	20078793          	addi	a5,a5,512
    80006592:	0792                	slli	a5,a5,0x4
    80006594:	97ca                	add	a5,a5,s2
    80006596:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006598:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000659c:	ffffc097          	auipc	ra,0xffffc
    800065a0:	c70080e7          	jalr	-912(ra) # 8000220c <wakeup>

    disk.used_idx += 1;
    800065a4:	0204d783          	lhu	a5,32(s1)
    800065a8:	2785                	addiw	a5,a5,1
    800065aa:	17c2                	slli	a5,a5,0x30
    800065ac:	93c1                	srli	a5,a5,0x30
    800065ae:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800065b2:	6898                	ld	a4,16(s1)
    800065b4:	00275703          	lhu	a4,2(a4)
    800065b8:	faf71be3          	bne	a4,a5,8000656e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800065bc:	0001f517          	auipc	a0,0x1f
    800065c0:	b6c50513          	addi	a0,a0,-1172 # 80025128 <disk+0x2128>
    800065c4:	ffffa097          	auipc	ra,0xffffa
    800065c8:	6b2080e7          	jalr	1714(ra) # 80000c76 <release>
}
    800065cc:	60e2                	ld	ra,24(sp)
    800065ce:	6442                	ld	s0,16(sp)
    800065d0:	64a2                	ld	s1,8(sp)
    800065d2:	6902                	ld	s2,0(sp)
    800065d4:	6105                	addi	sp,sp,32
    800065d6:	8082                	ret
      panic("virtio_disk_intr status");
    800065d8:	00002517          	auipc	a0,0x2
    800065dc:	21050513          	addi	a0,a0,528 # 800087e8 <syscalls+0x3b8>
    800065e0:	ffffa097          	auipc	ra,0xffffa
    800065e4:	f4a080e7          	jalr	-182(ra) # 8000052a <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
