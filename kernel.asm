
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
    # Turn on page size extension for 4Mbyte pages
    movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
    orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
    movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
    # Set page directory
    movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
    movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
    # Turn on paging.
    movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
    orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
    movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

    # Set up the stack pointer.
    movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 85 11 80       	mov    $0x80118550,%esp

    # Jump to main(), and switch to executing at
    # high addresses. The indirect call is needed because
    # the assembler produces a PC-relative instruction
    # for a direct jump.
    mov $main, %eax
8010002d:	b8 60 35 10 80       	mov    $0x80103560,%eax
    jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
    // Linked list of all buffers, through prev/next.
    // head.next is most recently used.
    struct buf head;
} bcache;

void binit(void) {
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx
    initlock(&bcache.lock, "bcache");

    // Create linked list of buffers
    bcache.head.prev = &bcache.head;
    bcache.head.next = &bcache.head;
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
void binit(void) {
80100049:	83 ec 0c             	sub    $0xc,%esp
    initlock(&bcache.lock, "bcache");
8010004c:	68 00 7b 10 80       	push   $0x80107b00
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 b5 48 00 00       	call   80104910 <initlock>
    bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 dc 0c 11 80       	mov    $0x80110cdc,%eax
    bcache.head.prev = &bcache.head;
80100063:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
8010006a:	0c 11 80 
    bcache.head.next = &bcache.head;
8010006d:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
80100074:	0c 11 80 
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
        b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
        b->prev = &bcache.head;
        initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
        b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
        initsleeplock(&b->lock, "buffer");
80100092:	68 07 7b 10 80       	push   $0x80107b07
80100097:	50                   	push   %eax
80100098:	e8 43 47 00 00       	call   801047e0 <initsleeplock>
        bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
        bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
        bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000b6:	81 fb 80 0a 11 80    	cmp    $0x80110a80,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
    }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
    panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.

struct buf*bread(uint dev, uint blockno) {
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
    acquire(&bcache.lock);
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 f7 49 00 00       	call   80104ae0 <acquire>
    for (b = bcache.head.next; b != &bcache.head; b = b->next) {
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
        if (b->dev == dev && b->blockno == blockno) {
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
            b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
            release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
    for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
        if (b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
            b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
            b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
            b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
            b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
            release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 19 49 00 00       	call   80104a80 <release>
            acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 46 00 00       	call   80104820 <acquiresleep>
            return b;
80100172:	83 c4 10             	add    $0x10,%esp
    struct buf *b;

    b = bget(dev, blockno);
    if ((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
        iderw(b);
    }
    return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 26 00 00       	call   801027e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
    panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 7b 10 80       	push   $0x80107b0e
801001a6:	e8 d5 02 00 00       	call   80100480 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.

void bwrite(struct buf *b) {
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!holdingsleep(&b->lock)) {
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 fd 46 00 00       	call   801048c0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
        panic("bwrite");
    }
    b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
    iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
    iderw(b);
801001d4:	e9 07 26 00 00       	jmp    801027e0 <iderw>
        panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 7b 10 80       	push   $0x80107b1f
801001e1:	e8 9a 02 00 00       	call   80100480 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.

void brelse(struct buf *b) {
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!holdingsleep(&b->lock)) {
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 46 00 00       	call   801048c0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
        panic("brelse");
    }

    releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 46 00 00       	call   80104880 <releasesleep>

    acquire(&bcache.lock);
80100214:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021b:	e8 c0 48 00 00       	call   80104ae0 <acquire>
    b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
    if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
    b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
    if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
        // no one is waiting for it.
        b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
        b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
        b->next = bcache.head.next;
80100242:	a1 30 0d 11 80       	mov    0x80110d30,%eax
        b->prev = &bcache.head;
80100247:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
        b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
        bcache.head.next->prev = b;
80100251:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
        bcache.head.next = b;
80100259:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
    }

    release(&bcache.lock);
8010025f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
    release(&bcache.lock);
8010026c:	e9 0f 48 00 00       	jmp    80104a80 <release>
        panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 7b 10 80       	push   $0x80107b26
80100279:	e8 02 02 00 00       	call   80100480 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
    if (doprocdump) {
        procdump();  // now call procdump() wo. cons.lock held
    }
}

int consoleread(struct inode *ip, char *dst, int n) {
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
    uint target;
    int c;

    iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
    target = n;
80100292:	89 df                	mov    %ebx,%edi
    iunlock(ip);
80100294:	e8 47 18 00 00       	call   80101ae0 <iunlock>
    acquire(&cons.lock);
80100299:	c7 04 24 a0 1f 11 80 	movl   $0x80111fa0,(%esp)
801002a0:	e8 3b 48 00 00       	call   80104ae0 <acquire>
    while (n > 0) {
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
        while (input.r == input.w) {
801002b0:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002b5:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
            if (myproc()->killed) {
                release(&cons.lock);
                ilock(ip);
                return -1;
            }
            sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 a0 1f 11 80       	push   $0x80111fa0
801002c8:	68 c0 0f 11 80       	push   $0x80110fc0
801002cd:	e8 ae 42 00 00       	call   80104580 <sleep>
        while (input.r == input.w) {
801002d2:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
            if (myproc()->killed) {
801002e2:	e8 c9 3b 00 00       	call   80103eb0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
                release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 a0 1f 11 80       	push   $0x80111fa0
801002f6:	e8 85 47 00 00       	call   80104a80 <release>
                ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 fc 16 00 00       	call   80101a00 <ilock>
                return -1;
80100304:	83 c4 10             	add    $0x10,%esp
    }
    release(&cons.lock);
    ilock(ip);

    return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
                return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 40 0f 11 80 	movsbl -0x7feef0c0(%edx),%ecx
        if (c == C('D')) { // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
        *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
        --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
        *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
        if (c == '\n') {
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
    release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 a0 1f 11 80       	push   $0x80111fa0
8010034c:	e8 2f 47 00 00       	call   80104a80 <release>
    ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 a6 16 00 00       	call   80101a00 <ilock>
    return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
            if (n < target) {
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
                input.r--;
8010036d:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <gethardwarecursorposition>:
int gethardwarecursorposition() {
80100380:	55                   	push   %ebp
                  "d" (port), "0" (addr), "1" (cnt) :
                  "memory", "cc");
}

static inline void outb(ushort port, uchar data) {
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100381:	b8 0e 00 00 00       	mov    $0xe,%eax
80100386:	89 e5                	mov    %esp,%ebp
80100388:	56                   	push   %esi
80100389:	be d4 03 00 00       	mov    $0x3d4,%esi
8010038e:	53                   	push   %ebx
8010038f:	89 f2                	mov    %esi,%edx
80100391:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100392:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100397:	89 da                	mov    %ebx,%edx
80100399:	ec                   	in     (%dx),%al
	position = inb(CRTPORT + 1) << 8;
8010039a:	0f b6 c8             	movzbl %al,%ecx
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010039d:	89 f2                	mov    %esi,%edx
8010039f:	b8 0f 00 00 00       	mov    $0xf,%eax
801003a4:	c1 e1 08             	shl    $0x8,%ecx
801003a7:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801003a8:	89 da                	mov    %ebx,%edx
801003aa:	ec                   	in     (%dx),%al
	position |= inb(CRTPORT + 1);
801003ab:	0f b6 c0             	movzbl %al,%eax
}
801003ae:	5b                   	pop    %ebx
801003af:	5e                   	pop    %esi
	position |= inb(CRTPORT + 1);
801003b0:	09 c8                	or     %ecx,%eax
}
801003b2:	5d                   	pop    %ebp
801003b3:	c3                   	ret    
801003b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003bf:	90                   	nop

801003c0 <grabscreentobuffer>:
void grabscreentobuffer() {
801003c0:	55                   	push   %ebp
801003c1:	89 e5                	mov    %esp,%ebp
801003c3:	56                   	push   %esi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801003c4:	be d4 03 00 00       	mov    $0x3d4,%esi
801003c9:	53                   	push   %ebx
	memmove(&consbuffer.videobuffer[0], crt, sizeof(ushort) * 80 * 25);
801003ca:	83 ec 04             	sub    $0x4,%esp
801003cd:	68 a0 0f 00 00       	push   $0xfa0
801003d2:	68 00 80 0b 80       	push   $0x800b8000
801003d7:	68 e0 0f 11 80       	push   $0x80110fe0
801003dc:	e8 5f 48 00 00       	call   80104c40 <memmove>
801003e1:	b8 0e 00 00 00       	mov    $0xe,%eax
801003e6:	89 f2                	mov    %esi,%edx
801003e8:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801003e9:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003ee:	89 da                	mov    %ebx,%edx
801003f0:	ec                   	in     (%dx),%al
	position = inb(CRTPORT + 1) << 8;
801003f1:	0f b6 c8             	movzbl %al,%ecx
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801003f4:	89 f2                	mov    %esi,%edx
801003f6:	b8 0f 00 00 00       	mov    $0xf,%eax
801003fb:	c1 e1 08             	shl    $0x8,%ecx
801003fe:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801003ff:	89 da                	mov    %ebx,%edx
80100401:	ec                   	in     (%dx),%al
	position |= inb(CRTPORT + 1);
80100402:	0f b6 c0             	movzbl %al,%eax
}
80100405:	83 c4 10             	add    $0x10,%esp
    textdisplayed = 0;
80100408:	c7 05 00 90 10 80 00 	movl   $0x0,0x80109000
8010040f:	00 00 00 
	position |= inb(CRTPORT + 1);
80100412:	09 c8                	or     %ecx,%eax
80100414:	a3 80 1f 11 80       	mov    %eax,0x80111f80
}
80100419:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010041c:	5b                   	pop    %ebx
8010041d:	5e                   	pop    %esi
8010041e:	5d                   	pop    %ebp
8010041f:	c3                   	ret    

80100420 <outputbuffertoscreen>:
void outputbuffertoscreen() {
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	56                   	push   %esi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100424:	be d4 03 00 00       	mov    $0x3d4,%esi
80100429:	53                   	push   %ebx
	memmove(crt, &consbuffer.videobuffer[0], sizeof(ushort) * 80 * 25);
8010042a:	83 ec 04             	sub    $0x4,%esp
8010042d:	68 a0 0f 00 00       	push   $0xfa0
80100432:	68 e0 0f 11 80       	push   $0x80110fe0
80100437:	68 00 80 0b 80       	push   $0x800b8000
8010043c:	e8 ff 47 00 00       	call   80104c40 <memmove>
	sethardwarecursorposition(consbuffer.cursorposition);
80100441:	8b 0d 80 1f 11 80    	mov    0x80111f80,%ecx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 f2                	mov    %esi,%edx
8010044e:	ee                   	out    %al,(%dx)
8010044f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
	outb(CRTPORT + 1, (position >> 8) & 0xFF);
80100454:	89 c8                	mov    %ecx,%eax
80100456:	c1 f8 08             	sar    $0x8,%eax
80100459:	89 da                	mov    %ebx,%edx
8010045b:	ee                   	out    %al,(%dx)
8010045c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100461:	89 f2                	mov    %esi,%edx
80100463:	ee                   	out    %al,(%dx)
80100464:	89 c8                	mov    %ecx,%eax
80100466:	89 da                	mov    %ebx,%edx
80100468:	ee                   	out    %al,(%dx)
    textdisplayed = 1;
80100469:	c7 05 00 90 10 80 01 	movl   $0x1,0x80109000
80100470:	00 00 00 
}
80100473:	83 c4 10             	add    $0x10,%esp
80100476:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100479:	5b                   	pop    %ebx
8010047a:	5e                   	pop    %esi
8010047b:	5d                   	pop    %ebp
8010047c:	c3                   	ret    
8010047d:	8d 76 00             	lea    0x0(%esi),%esi

80100480 <panic>:
void panic(char *s) {
80100480:	55                   	push   %ebp
80100481:	89 e5                	mov    %esp,%ebp
80100483:	56                   	push   %esi
80100484:	53                   	push   %ebx
80100485:	83 ec 30             	sub    $0x30,%esp
static inline void loadgs(ushort v)  {
    asm volatile ("movw %0, %%gs" : : "r" (v));
}

static inline void cli(void) {
    asm volatile ("cli");
80100488:	fa                   	cli    
    cons.locking = 0;
80100489:	c7 05 d4 1f 11 80 00 	movl   $0x0,0x80111fd4
80100490:	00 00 00 
    getcallerpcs(&s, pcs);
80100493:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100496:	8d 75 f8             	lea    -0x8(%ebp),%esi
    cprintf("lapicid %d: panic: ", lapicid());
80100499:	e8 52 29 00 00       	call   80102df0 <lapicid>
8010049e:	83 ec 08             	sub    $0x8,%esp
801004a1:	50                   	push   %eax
801004a2:	68 2d 7b 10 80       	push   $0x80107b2d
801004a7:	e8 34 03 00 00       	call   801007e0 <cprintf>
    cprintf(s);
801004ac:	58                   	pop    %eax
801004ad:	ff 75 08             	push   0x8(%ebp)
801004b0:	e8 2b 03 00 00       	call   801007e0 <cprintf>
    cprintf("\n");
801004b5:	c7 04 24 6b 84 10 80 	movl   $0x8010846b,(%esp)
801004bc:	e8 1f 03 00 00       	call   801007e0 <cprintf>
    getcallerpcs(&s, pcs);
801004c1:	8d 45 08             	lea    0x8(%ebp),%eax
801004c4:	5a                   	pop    %edx
801004c5:	59                   	pop    %ecx
801004c6:	53                   	push   %ebx
801004c7:	50                   	push   %eax
801004c8:	e8 63 44 00 00       	call   80104930 <getcallerpcs>
    for (i = 0; i < 10; i++) {
801004cd:	83 c4 10             	add    $0x10,%esp
        cprintf(" %p", pcs[i]);
801004d0:	83 ec 08             	sub    $0x8,%esp
801004d3:	ff 33                	push   (%ebx)
    for (i = 0; i < 10; i++) {
801004d5:	83 c3 04             	add    $0x4,%ebx
        cprintf(" %p", pcs[i]);
801004d8:	68 41 7b 10 80       	push   $0x80107b41
801004dd:	e8 fe 02 00 00       	call   801007e0 <cprintf>
    for (i = 0; i < 10; i++) {
801004e2:	83 c4 10             	add    $0x10,%esp
801004e5:	39 f3                	cmp    %esi,%ebx
801004e7:	75 e7                	jne    801004d0 <panic+0x50>
    panicked = 1; // freeze other CPU
801004e9:	c7 05 d8 1f 11 80 01 	movl   $0x1,0x80111fd8
801004f0:	00 00 00 
    for (;;) {
801004f3:	eb fe                	jmp    801004f3 <panic+0x73>
801004f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100500 <consputc.part.0>:
void consputc(int c) {
80100500:	55                   	push   %ebp
80100501:	89 e5                	mov    %esp,%ebp
80100503:	57                   	push   %edi
80100504:	56                   	push   %esi
80100505:	53                   	push   %ebx
80100506:	89 c3                	mov    %eax,%ebx
80100508:	83 ec 1c             	sub    $0x1c,%esp
    if (c == BACKSPACE) {
8010050b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100510:	0f 84 02 01 00 00    	je     80100618 <consputc.part.0+0x118>
        uartputc(c);
80100516:	83 ec 0c             	sub    $0xc,%esp
80100519:	50                   	push   %eax
8010051a:	e8 11 5d 00 00       	call   80106230 <uartputc>
8010051f:	83 c4 10             	add    $0x10,%esp
    if (textdisplayed == 0) {
80100522:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100528:	85 c9                	test   %ecx,%ecx
8010052a:	0f 85 80 00 00 00    	jne    801005b0 <consputc.part.0+0xb0>
        pos = consbuffer.cursorposition;
80100530:	a1 80 1f 11 80       	mov    0x80111f80,%eax
        videomemory = &consbuffer.videobuffer[0];
80100535:	bf e0 0f 11 80       	mov    $0x80110fe0,%edi
        pos = consbuffer.cursorposition;
8010053a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (c == '\n') {
8010053d:	83 fb 0a             	cmp    $0xa,%ebx
80100540:	0f 84 aa 00 00 00    	je     801005f0 <consputc.part.0+0xf0>
    else if (c == BACKSPACE) {
80100546:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010054c:	74 52                	je     801005a0 <consputc.part.0+0xa0>
        videomemory[pos++] = (c & 0xff) | 0x0700;  // black on white
8010054e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100551:	0f b6 db             	movzbl %bl,%ebx
80100554:	80 cf 07             	or     $0x7,%bh
80100557:	66 89 1c 47          	mov    %bx,(%edi,%eax,2)
8010055b:	8d 70 01             	lea    0x1(%eax),%esi
    if (pos < 0 || pos > 25 * 80) {
8010055e:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100564:	0f 87 54 01 00 00    	ja     801006be <consputc.part.0+0x1be>
    if ((pos / 80) >= 24) { // Scroll up.
8010056a:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100570:	0f 8f 0a 01 00 00    	jg     80100680 <consputc.part.0+0x180>
    videomemory[pos] = ' ' | 0x0700;
80100576:	8d 1c 77             	lea    (%edi,%esi,2),%ebx
    if (textdisplayed == 1) {
80100579:	83 f9 01             	cmp    $0x1,%ecx
8010057c:	0f 84 c6 00 00 00    	je     80100648 <consputc.part.0+0x148>
    videomemory[pos] = ' ' | 0x0700;
80100582:	b8 20 07 00 00       	mov    $0x720,%eax
        consbuffer.cursorposition = pos;
80100587:	89 35 80 1f 11 80    	mov    %esi,0x80111f80
    videomemory[pos] = ' ' | 0x0700;
8010058d:	66 89 03             	mov    %ax,(%ebx)
}
80100590:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100593:	5b                   	pop    %ebx
80100594:	5e                   	pop    %esi
80100595:	5f                   	pop    %edi
80100596:	5d                   	pop    %ebp
80100597:	c3                   	ret    
80100598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059f:	90                   	nop
            --pos;
801005a0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801005a3:	31 c0                	xor    %eax,%eax
801005a5:	85 f6                	test   %esi,%esi
801005a7:	0f 9f c0             	setg   %al
801005aa:	29 c6                	sub    %eax,%esi
801005ac:	eb b0                	jmp    8010055e <consputc.part.0+0x5e>
801005ae:	66 90                	xchg   %ax,%ax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801005b0:	bf d4 03 00 00       	mov    $0x3d4,%edi
801005b5:	b8 0e 00 00 00       	mov    $0xe,%eax
801005ba:	89 fa                	mov    %edi,%edx
801005bc:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801005bd:	be d5 03 00 00       	mov    $0x3d5,%esi
801005c2:	89 f2                	mov    %esi,%edx
801005c4:	ec                   	in     (%dx),%al
	position = inb(CRTPORT + 1) << 8;
801005c5:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801005c8:	89 fa                	mov    %edi,%edx
801005ca:	c1 e0 08             	shl    $0x8,%eax
801005cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801005d0:	b8 0f 00 00 00       	mov    $0xf,%eax
801005d5:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801005d6:	89 f2                	mov    %esi,%edx
801005d8:	ec                   	in     (%dx),%al
	position |= inb(CRTPORT + 1);
801005d9:	0f b6 c0             	movzbl %al,%eax
801005dc:	0b 45 e4             	or     -0x1c(%ebp),%eax
        videomemory = crt;
801005df:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
	position |= inb(CRTPORT + 1);
801005e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (c == '\n') {
801005e7:	83 fb 0a             	cmp    $0xa,%ebx
801005ea:	0f 85 56 ff ff ff    	jne    80100546 <consputc.part.0+0x46>
        pos += 80 - pos % 80;
801005f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801005f3:	ba 67 66 66 66       	mov    $0x66666667,%edx
801005f8:	f7 ea                	imul   %edx
801005fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801005fd:	c1 f8 1f             	sar    $0x1f,%eax
80100600:	c1 fa 05             	sar    $0x5,%edx
80100603:	29 c2                	sub    %eax,%edx
80100605:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100608:	c1 e0 04             	shl    $0x4,%eax
8010060b:	8d 70 50             	lea    0x50(%eax),%esi
8010060e:	e9 4b ff ff ff       	jmp    8010055e <consputc.part.0+0x5e>
80100613:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100617:	90                   	nop
        uartputc('\b');
80100618:	83 ec 0c             	sub    $0xc,%esp
8010061b:	6a 08                	push   $0x8
8010061d:	e8 0e 5c 00 00       	call   80106230 <uartputc>
        uartputc(' ');
80100622:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100629:	e8 02 5c 00 00       	call   80106230 <uartputc>
        uartputc('\b');
8010062e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100635:	e8 f6 5b 00 00       	call   80106230 <uartputc>
8010063a:	83 c4 10             	add    $0x10,%esp
8010063d:	e9 e0 fe ff ff       	jmp    80100522 <consputc.part.0+0x22>
80100642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100648:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010064d:	b8 0e 00 00 00       	mov    $0xe,%eax
80100652:	89 fa                	mov    %edi,%edx
80100654:	ee                   	out    %al,(%dx)
80100655:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
	outb(CRTPORT + 1, (position >> 8) & 0xFF);
8010065a:	89 f0                	mov    %esi,%eax
8010065c:	c1 f8 08             	sar    $0x8,%eax
8010065f:	89 ca                	mov    %ecx,%edx
80100661:	ee                   	out    %al,(%dx)
80100662:	b8 0f 00 00 00       	mov    $0xf,%eax
80100667:	89 fa                	mov    %edi,%edx
80100669:	ee                   	out    %al,(%dx)
8010066a:	89 f0                	mov    %esi,%eax
8010066c:	89 ca                	mov    %ecx,%edx
8010066e:	ee                   	out    %al,(%dx)
    videomemory[pos] = ' ' | 0x0700;
8010066f:	b8 20 07 00 00       	mov    $0x720,%eax
80100674:	66 89 03             	mov    %ax,(%ebx)
}
80100677:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010067a:	5b                   	pop    %ebx
8010067b:	5e                   	pop    %esi
8010067c:	5f                   	pop    %edi
8010067d:	5d                   	pop    %ebp
8010067e:	c3                   	ret    
8010067f:	90                   	nop
        memmove(videomemory, videomemory + 80, sizeof(videomemory[0]) * 23 * 80);
80100680:	83 ec 04             	sub    $0x4,%esp
80100683:	8d 87 a0 00 00 00    	lea    0xa0(%edi),%eax
        pos -= 80;
80100689:	83 ee 50             	sub    $0x50,%esi
        memmove(videomemory, videomemory + 80, sizeof(videomemory[0]) * 23 * 80);
8010068c:	68 60 0e 00 00       	push   $0xe60
        memset(videomemory + pos, 0, sizeof(videomemory[0]) * (24 * 80 - pos));
80100691:	8d 1c 77             	lea    (%edi,%esi,2),%ebx
        memmove(videomemory, videomemory + 80, sizeof(videomemory[0]) * 23 * 80);
80100694:	50                   	push   %eax
80100695:	57                   	push   %edi
80100696:	e8 a5 45 00 00       	call   80104c40 <memmove>
        memset(videomemory + pos, 0, sizeof(videomemory[0]) * (24 * 80 - pos));
8010069b:	b8 80 07 00 00       	mov    $0x780,%eax
801006a0:	83 c4 0c             	add    $0xc,%esp
801006a3:	29 f0                	sub    %esi,%eax
801006a5:	01 c0                	add    %eax,%eax
801006a7:	50                   	push   %eax
801006a8:	6a 00                	push   $0x0
801006aa:	53                   	push   %ebx
801006ab:	e8 f0 44 00 00       	call   80104ba0 <memset>
    if (textdisplayed == 1) {
801006b0:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
801006b6:	83 c4 10             	add    $0x10,%esp
801006b9:	e9 bb fe ff ff       	jmp    80100579 <consputc.part.0+0x79>
        panic("pos under/overflow");
801006be:	83 ec 0c             	sub    $0xc,%esp
801006c1:	68 45 7b 10 80       	push   $0x80107b45
801006c6:	e8 b5 fd ff ff       	call   80100480 <panic>
801006cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006cf:	90                   	nop

801006d0 <consolewrite>:

int consolewrite(struct inode *ip, char *buf, int n) {
801006d0:	55                   	push   %ebp
801006d1:	89 e5                	mov    %esp,%ebp
801006d3:	57                   	push   %edi
801006d4:	56                   	push   %esi
801006d5:	53                   	push   %ebx
801006d6:	83 ec 18             	sub    $0x18,%esp
    int i;

    iunlock(ip);
801006d9:	ff 75 08             	push   0x8(%ebp)
int consolewrite(struct inode *ip, char *buf, int n) {
801006dc:	8b 75 10             	mov    0x10(%ebp),%esi
    iunlock(ip);
801006df:	e8 fc 13 00 00       	call   80101ae0 <iunlock>
    acquire(&cons.lock);
801006e4:	c7 04 24 a0 1f 11 80 	movl   $0x80111fa0,(%esp)
801006eb:	e8 f0 43 00 00       	call   80104ae0 <acquire>
    for (i = 0; i < n; i++) {
801006f0:	83 c4 10             	add    $0x10,%esp
801006f3:	85 f6                	test   %esi,%esi
801006f5:	7e 25                	jle    8010071c <consolewrite+0x4c>
801006f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801006fa:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
    if (panicked) {
801006fd:	8b 15 d8 1f 11 80    	mov    0x80111fd8,%edx
        consputc(buf[i] & 0xff);
80100703:	0f b6 03             	movzbl (%ebx),%eax
    if (panicked) {
80100706:	85 d2                	test   %edx,%edx
80100708:	74 06                	je     80100710 <consolewrite+0x40>
    asm volatile ("cli");
8010070a:	fa                   	cli    
        for (;;) {
8010070b:	eb fe                	jmp    8010070b <consolewrite+0x3b>
8010070d:	8d 76 00             	lea    0x0(%esi),%esi
80100710:	e8 eb fd ff ff       	call   80100500 <consputc.part.0>
    for (i = 0; i < n; i++) {
80100715:	83 c3 01             	add    $0x1,%ebx
80100718:	39 df                	cmp    %ebx,%edi
8010071a:	75 e1                	jne    801006fd <consolewrite+0x2d>
    }
    release(&cons.lock);
8010071c:	83 ec 0c             	sub    $0xc,%esp
8010071f:	68 a0 1f 11 80       	push   $0x80111fa0
80100724:	e8 57 43 00 00       	call   80104a80 <release>
    ilock(ip);
80100729:	58                   	pop    %eax
8010072a:	ff 75 08             	push   0x8(%ebp)
8010072d:	e8 ce 12 00 00       	call   80101a00 <ilock>

    return n;
}
80100732:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100735:	89 f0                	mov    %esi,%eax
80100737:	5b                   	pop    %ebx
80100738:	5e                   	pop    %esi
80100739:	5f                   	pop    %edi
8010073a:	5d                   	pop    %ebp
8010073b:	c3                   	ret    
8010073c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100740 <printint>:
static void printint(int xx, int base, int sign) {
80100740:	55                   	push   %ebp
80100741:	89 e5                	mov    %esp,%ebp
80100743:	57                   	push   %edi
80100744:	56                   	push   %esi
80100745:	53                   	push   %ebx
80100746:	83 ec 2c             	sub    $0x2c,%esp
80100749:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010074c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    if (sign && (sign = xx < 0)) {
8010074f:	85 c9                	test   %ecx,%ecx
80100751:	74 04                	je     80100757 <printint+0x17>
80100753:	85 c0                	test   %eax,%eax
80100755:	78 6d                	js     801007c4 <printint+0x84>
        x = xx;
80100757:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010075e:	89 c1                	mov    %eax,%ecx
    i = 0;
80100760:	31 db                	xor    %ebx,%ebx
80100762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        buf[i++] = digits[x % base];
80100768:	89 c8                	mov    %ecx,%eax
8010076a:	31 d2                	xor    %edx,%edx
8010076c:	89 de                	mov    %ebx,%esi
8010076e:	89 cf                	mov    %ecx,%edi
80100770:	f7 75 d4             	divl   -0x2c(%ebp)
80100773:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100776:	0f b6 92 70 7b 10 80 	movzbl -0x7fef8490(%edx),%edx
    while ((x /= base) != 0);
8010077d:	89 c1                	mov    %eax,%ecx
        buf[i++] = digits[x % base];
8010077f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
    while ((x /= base) != 0);
80100783:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100786:	73 e0                	jae    80100768 <printint+0x28>
    if (sign) {
80100788:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010078b:	85 c9                	test   %ecx,%ecx
8010078d:	74 0c                	je     8010079b <printint+0x5b>
        buf[i++] = '-';
8010078f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
        buf[i++] = digits[x % base];
80100794:	89 de                	mov    %ebx,%esi
        buf[i++] = '-';
80100796:	ba 2d 00 00 00       	mov    $0x2d,%edx
    while (--i >= 0) {
8010079b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010079f:	0f be c2             	movsbl %dl,%eax
    if (panicked) {
801007a2:	8b 15 d8 1f 11 80    	mov    0x80111fd8,%edx
801007a8:	85 d2                	test   %edx,%edx
801007aa:	74 04                	je     801007b0 <printint+0x70>
801007ac:	fa                   	cli    
        for (;;) {
801007ad:	eb fe                	jmp    801007ad <printint+0x6d>
801007af:	90                   	nop
801007b0:	e8 4b fd ff ff       	call   80100500 <consputc.part.0>
    while (--i >= 0) {
801007b5:	8d 45 d7             	lea    -0x29(%ebp),%eax
801007b8:	39 c3                	cmp    %eax,%ebx
801007ba:	74 0e                	je     801007ca <printint+0x8a>
        consputc(buf[i]);
801007bc:	0f be 03             	movsbl (%ebx),%eax
801007bf:	83 eb 01             	sub    $0x1,%ebx
801007c2:	eb de                	jmp    801007a2 <printint+0x62>
        x = -xx;
801007c4:	f7 d8                	neg    %eax
801007c6:	89 c1                	mov    %eax,%ecx
801007c8:	eb 96                	jmp    80100760 <printint+0x20>
}
801007ca:	83 c4 2c             	add    $0x2c,%esp
801007cd:	5b                   	pop    %ebx
801007ce:	5e                   	pop    %esi
801007cf:	5f                   	pop    %edi
801007d0:	5d                   	pop    %ebp
801007d1:	c3                   	ret    
801007d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801007e0 <cprintf>:
void cprintf(char *fmt, ...) {
801007e0:	55                   	push   %ebp
801007e1:	89 e5                	mov    %esp,%ebp
801007e3:	57                   	push   %edi
801007e4:	56                   	push   %esi
801007e5:	53                   	push   %ebx
801007e6:	83 ec 1c             	sub    $0x1c,%esp
    locking = cons.locking;
801007e9:	a1 d4 1f 11 80       	mov    0x80111fd4,%eax
801007ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (locking) {
801007f1:	85 c0                	test   %eax,%eax
801007f3:	0f 85 27 01 00 00    	jne    80100920 <cprintf+0x140>
    if (fmt == 0) {
801007f9:	8b 75 08             	mov    0x8(%ebp),%esi
801007fc:	85 f6                	test   %esi,%esi
801007fe:	0f 84 ac 01 00 00    	je     801009b0 <cprintf+0x1d0>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100804:	0f b6 06             	movzbl (%esi),%eax
    argp = (uint*)(void*)(&fmt + 1);
80100807:	8d 7d 0c             	lea    0xc(%ebp),%edi
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
8010080a:	31 db                	xor    %ebx,%ebx
8010080c:	85 c0                	test   %eax,%eax
8010080e:	74 56                	je     80100866 <cprintf+0x86>
        if (c != '%') {
80100810:	83 f8 25             	cmp    $0x25,%eax
80100813:	0f 85 cf 00 00 00    	jne    801008e8 <cprintf+0x108>
        c = fmt[++i] & 0xff;
80100819:	83 c3 01             	add    $0x1,%ebx
8010081c:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
        if (c == 0) {
80100820:	85 d2                	test   %edx,%edx
80100822:	74 42                	je     80100866 <cprintf+0x86>
        switch (c) {
80100824:	83 fa 70             	cmp    $0x70,%edx
80100827:	0f 84 90 00 00 00    	je     801008bd <cprintf+0xdd>
8010082d:	7f 51                	jg     80100880 <cprintf+0xa0>
8010082f:	83 fa 25             	cmp    $0x25,%edx
80100832:	0f 84 c0 00 00 00    	je     801008f8 <cprintf+0x118>
80100838:	83 fa 64             	cmp    $0x64,%edx
8010083b:	0f 85 f4 00 00 00    	jne    80100935 <cprintf+0x155>
                printint(*argp++, 10, 1);
80100841:	8d 47 04             	lea    0x4(%edi),%eax
80100844:	b9 01 00 00 00       	mov    $0x1,%ecx
80100849:	ba 0a 00 00 00       	mov    $0xa,%edx
8010084e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100851:	8b 07                	mov    (%edi),%eax
80100853:	e8 e8 fe ff ff       	call   80100740 <printint>
80100858:	8b 7d e0             	mov    -0x20(%ebp),%edi
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
8010085b:	83 c3 01             	add    $0x1,%ebx
8010085e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100862:	85 c0                	test   %eax,%eax
80100864:	75 aa                	jne    80100810 <cprintf+0x30>
    if (locking) {
80100866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100869:	85 c0                	test   %eax,%eax
8010086b:	0f 85 22 01 00 00    	jne    80100993 <cprintf+0x1b3>
}
80100871:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100874:	5b                   	pop    %ebx
80100875:	5e                   	pop    %esi
80100876:	5f                   	pop    %edi
80100877:	5d                   	pop    %ebp
80100878:	c3                   	ret    
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        switch (c) {
80100880:	83 fa 73             	cmp    $0x73,%edx
80100883:	75 33                	jne    801008b8 <cprintf+0xd8>
                if ((s = (char*)*argp++) == 0) {
80100885:	8d 47 04             	lea    0x4(%edi),%eax
80100888:	8b 3f                	mov    (%edi),%edi
8010088a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010088d:	85 ff                	test   %edi,%edi
8010088f:	0f 84 e3 00 00 00    	je     80100978 <cprintf+0x198>
                for (; *s; s++) {
80100895:	0f be 07             	movsbl (%edi),%eax
80100898:	84 c0                	test   %al,%al
8010089a:	0f 84 08 01 00 00    	je     801009a8 <cprintf+0x1c8>
    if (panicked) {
801008a0:	8b 15 d8 1f 11 80    	mov    0x80111fd8,%edx
801008a6:	85 d2                	test   %edx,%edx
801008a8:	0f 84 b2 00 00 00    	je     80100960 <cprintf+0x180>
801008ae:	fa                   	cli    
        for (;;) {
801008af:	eb fe                	jmp    801008af <cprintf+0xcf>
801008b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        switch (c) {
801008b8:	83 fa 78             	cmp    $0x78,%edx
801008bb:	75 78                	jne    80100935 <cprintf+0x155>
                printint(*argp++, 16, 0);
801008bd:	8d 47 04             	lea    0x4(%edi),%eax
801008c0:	31 c9                	xor    %ecx,%ecx
801008c2:	ba 10 00 00 00       	mov    $0x10,%edx
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801008c7:	83 c3 01             	add    $0x1,%ebx
                printint(*argp++, 16, 0);
801008ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
801008cd:	8b 07                	mov    (%edi),%eax
801008cf:	e8 6c fe ff ff       	call   80100740 <printint>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801008d4:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
                printint(*argp++, 16, 0);
801008d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801008db:	85 c0                	test   %eax,%eax
801008dd:	0f 85 2d ff ff ff    	jne    80100810 <cprintf+0x30>
801008e3:	eb 81                	jmp    80100866 <cprintf+0x86>
801008e5:	8d 76 00             	lea    0x0(%esi),%esi
    if (panicked) {
801008e8:	8b 0d d8 1f 11 80    	mov    0x80111fd8,%ecx
801008ee:	85 c9                	test   %ecx,%ecx
801008f0:	74 14                	je     80100906 <cprintf+0x126>
801008f2:	fa                   	cli    
        for (;;) {
801008f3:	eb fe                	jmp    801008f3 <cprintf+0x113>
801008f5:	8d 76 00             	lea    0x0(%esi),%esi
    if (panicked) {
801008f8:	a1 d8 1f 11 80       	mov    0x80111fd8,%eax
801008fd:	85 c0                	test   %eax,%eax
801008ff:	75 6c                	jne    8010096d <cprintf+0x18d>
80100901:	b8 25 00 00 00       	mov    $0x25,%eax
80100906:	e8 f5 fb ff ff       	call   80100500 <consputc.part.0>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
8010090b:	83 c3 01             	add    $0x1,%ebx
8010090e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100912:	85 c0                	test   %eax,%eax
80100914:	0f 85 f6 fe ff ff    	jne    80100810 <cprintf+0x30>
8010091a:	e9 47 ff ff ff       	jmp    80100866 <cprintf+0x86>
8010091f:	90                   	nop
        acquire(&cons.lock);
80100920:	83 ec 0c             	sub    $0xc,%esp
80100923:	68 a0 1f 11 80       	push   $0x80111fa0
80100928:	e8 b3 41 00 00       	call   80104ae0 <acquire>
8010092d:	83 c4 10             	add    $0x10,%esp
80100930:	e9 c4 fe ff ff       	jmp    801007f9 <cprintf+0x19>
    if (panicked) {
80100935:	8b 0d d8 1f 11 80    	mov    0x80111fd8,%ecx
8010093b:	85 c9                	test   %ecx,%ecx
8010093d:	75 31                	jne    80100970 <cprintf+0x190>
8010093f:	b8 25 00 00 00       	mov    $0x25,%eax
80100944:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100947:	e8 b4 fb ff ff       	call   80100500 <consputc.part.0>
8010094c:	8b 15 d8 1f 11 80    	mov    0x80111fd8,%edx
80100952:	85 d2                	test   %edx,%edx
80100954:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100957:	74 2e                	je     80100987 <cprintf+0x1a7>
80100959:	fa                   	cli    
        for (;;) {
8010095a:	eb fe                	jmp    8010095a <cprintf+0x17a>
8010095c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100960:	e8 9b fb ff ff       	call   80100500 <consputc.part.0>
                for (; *s; s++) {
80100965:	83 c7 01             	add    $0x1,%edi
80100968:	e9 28 ff ff ff       	jmp    80100895 <cprintf+0xb5>
8010096d:	fa                   	cli    
        for (;;) {
8010096e:	eb fe                	jmp    8010096e <cprintf+0x18e>
80100970:	fa                   	cli    
80100971:	eb fe                	jmp    80100971 <cprintf+0x191>
80100973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100977:	90                   	nop
                    s = "(null)";
80100978:	bf 58 7b 10 80       	mov    $0x80107b58,%edi
                for (; *s; s++) {
8010097d:	b8 28 00 00 00       	mov    $0x28,%eax
80100982:	e9 19 ff ff ff       	jmp    801008a0 <cprintf+0xc0>
80100987:	89 d0                	mov    %edx,%eax
80100989:	e8 72 fb ff ff       	call   80100500 <consputc.part.0>
8010098e:	e9 c8 fe ff ff       	jmp    8010085b <cprintf+0x7b>
        release(&cons.lock);
80100993:	83 ec 0c             	sub    $0xc,%esp
80100996:	68 a0 1f 11 80       	push   $0x80111fa0
8010099b:	e8 e0 40 00 00       	call   80104a80 <release>
801009a0:	83 c4 10             	add    $0x10,%esp
}
801009a3:	e9 c9 fe ff ff       	jmp    80100871 <cprintf+0x91>
                if ((s = (char*)*argp++) == 0) {
801009a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801009ab:	e9 ab fe ff ff       	jmp    8010085b <cprintf+0x7b>
        panic("null fmt");
801009b0:	83 ec 0c             	sub    $0xc,%esp
801009b3:	68 5f 7b 10 80       	push   $0x80107b5f
801009b8:	e8 c3 fa ff ff       	call   80100480 <panic>
801009bd:	8d 76 00             	lea    0x0(%esi),%esi

801009c0 <consoleget>:
int consoleget(void) {
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 24             	sub    $0x24,%esp
    acquire(&cons.lock);
801009c6:	68 a0 1f 11 80       	push   $0x80111fa0
801009cb:	e8 10 41 00 00       	call   80104ae0 <acquire>
    while ((c = kbdgetc()) <= 0) {
801009d0:	83 c4 10             	add    $0x10,%esp
801009d3:	eb 05                	jmp    801009da <consoleget+0x1a>
801009d5:	8d 76 00             	lea    0x0(%esi),%esi
        if (c == 0) {
801009d8:	74 26                	je     80100a00 <consoleget+0x40>
    while ((c = kbdgetc()) <= 0) {
801009da:	e8 11 22 00 00       	call   80102bf0 <kbdgetc>
801009df:	85 c0                	test   %eax,%eax
801009e1:	7e f5                	jle    801009d8 <consoleget+0x18>
    release(&cons.lock);
801009e3:	83 ec 0c             	sub    $0xc,%esp
801009e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801009e9:	68 a0 1f 11 80       	push   $0x80111fa0
801009ee:	e8 8d 40 00 00       	call   80104a80 <release>
}
801009f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801009f6:	c9                   	leave  
801009f7:	c3                   	ret    
801009f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009ff:	90                   	nop
            c = kbdgetc();
80100a00:	e8 eb 21 00 00       	call   80102bf0 <kbdgetc>
80100a05:	eb d3                	jmp    801009da <consoleget+0x1a>
80100a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a0e:	66 90                	xchg   %ax,%ax

80100a10 <consoleintr>:
void consoleintr(int (*getc)(void)) {
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
    int c, doprocdump = 0;
80100a15:	31 f6                	xor    %esi,%esi
void consoleintr(int (*getc)(void)) {
80100a17:	53                   	push   %ebx
80100a18:	83 ec 18             	sub    $0x18,%esp
80100a1b:	8b 7d 08             	mov    0x8(%ebp),%edi
    acquire(&cons.lock);
80100a1e:	68 a0 1f 11 80       	push   $0x80111fa0
80100a23:	e8 b8 40 00 00       	call   80104ae0 <acquire>
    while ((c = getc()) >= 0) {
80100a28:	83 c4 10             	add    $0x10,%esp
80100a2b:	eb 1a                	jmp    80100a47 <consoleintr+0x37>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi
        switch (c) {
80100a30:	83 fb 08             	cmp    $0x8,%ebx
80100a33:	0f 84 d7 00 00 00    	je     80100b10 <consoleintr+0x100>
80100a39:	83 fb 10             	cmp    $0x10,%ebx
80100a3c:	0f 85 32 01 00 00    	jne    80100b74 <consoleintr+0x164>
80100a42:	be 01 00 00 00       	mov    $0x1,%esi
    while ((c = getc()) >= 0) {
80100a47:	ff d7                	call   *%edi
80100a49:	89 c3                	mov    %eax,%ebx
80100a4b:	85 c0                	test   %eax,%eax
80100a4d:	0f 88 05 01 00 00    	js     80100b58 <consoleintr+0x148>
        switch (c) {
80100a53:	83 fb 15             	cmp    $0x15,%ebx
80100a56:	74 78                	je     80100ad0 <consoleintr+0xc0>
80100a58:	7e d6                	jle    80100a30 <consoleintr+0x20>
80100a5a:	83 fb 7f             	cmp    $0x7f,%ebx
80100a5d:	0f 84 ad 00 00 00    	je     80100b10 <consoleintr+0x100>
                if (c != 0 && input.e - input.r < INPUT_BUF) {
80100a63:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100a68:	89 c2                	mov    %eax,%edx
80100a6a:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
80100a70:	83 fa 7f             	cmp    $0x7f,%edx
80100a73:	77 d2                	ja     80100a47 <consoleintr+0x37>
                    input.buf[input.e++ % INPUT_BUF] = c;
80100a75:	8d 48 01             	lea    0x1(%eax),%ecx
    if (panicked) {
80100a78:	8b 15 d8 1f 11 80    	mov    0x80111fd8,%edx
                    input.buf[input.e++ % INPUT_BUF] = c;
80100a7e:	83 e0 7f             	and    $0x7f,%eax
80100a81:	89 0d c8 0f 11 80    	mov    %ecx,0x80110fc8
                    c = (c == '\r') ? '\n' : c;
80100a87:	83 fb 0d             	cmp    $0xd,%ebx
80100a8a:	0f 84 13 01 00 00    	je     80100ba3 <consoleintr+0x193>
                    input.buf[input.e++ % INPUT_BUF] = c;
80100a90:	88 98 40 0f 11 80    	mov    %bl,-0x7feef0c0(%eax)
    if (panicked) {
80100a96:	85 d2                	test   %edx,%edx
80100a98:	0f 85 10 01 00 00    	jne    80100bae <consoleintr+0x19e>
80100a9e:	89 d8                	mov    %ebx,%eax
80100aa0:	e8 5b fa ff ff       	call   80100500 <consputc.part.0>
                    if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF) {
80100aa5:	83 fb 0a             	cmp    $0xa,%ebx
80100aa8:	0f 84 14 01 00 00    	je     80100bc2 <consoleintr+0x1b2>
80100aae:	83 fb 04             	cmp    $0x4,%ebx
80100ab1:	0f 84 0b 01 00 00    	je     80100bc2 <consoleintr+0x1b2>
80100ab7:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
80100abc:	83 e8 80             	sub    $0xffffff80,%eax
80100abf:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100ac5:	75 80                	jne    80100a47 <consoleintr+0x37>
80100ac7:	e9 fb 00 00 00       	jmp    80100bc7 <consoleintr+0x1b7>
80100acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                while (input.e != input.w &&
80100ad0:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100ad5:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100adb:	0f 84 66 ff ff ff    	je     80100a47 <consoleintr+0x37>
                       input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
80100ae1:	83 e8 01             	sub    $0x1,%eax
80100ae4:	89 c2                	mov    %eax,%edx
80100ae6:	83 e2 7f             	and    $0x7f,%edx
                while (input.e != input.w &&
80100ae9:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
80100af0:	0f 84 51 ff ff ff    	je     80100a47 <consoleintr+0x37>
    if (panicked) {
80100af6:	8b 15 d8 1f 11 80    	mov    0x80111fd8,%edx
                    input.e--;
80100afc:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
    if (panicked) {
80100b01:	85 d2                	test   %edx,%edx
80100b03:	74 33                	je     80100b38 <consoleintr+0x128>
80100b05:	fa                   	cli    
        for (;;) {
80100b06:	eb fe                	jmp    80100b06 <consoleintr+0xf6>
80100b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b0f:	90                   	nop
                if (input.e != input.w) {
80100b10:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100b15:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100b1b:	0f 84 26 ff ff ff    	je     80100a47 <consoleintr+0x37>
                    input.e--;
80100b21:	83 e8 01             	sub    $0x1,%eax
80100b24:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
    if (panicked) {
80100b29:	a1 d8 1f 11 80       	mov    0x80111fd8,%eax
80100b2e:	85 c0                	test   %eax,%eax
80100b30:	74 56                	je     80100b88 <consoleintr+0x178>
80100b32:	fa                   	cli    
        for (;;) {
80100b33:	eb fe                	jmp    80100b33 <consoleintr+0x123>
80100b35:	8d 76 00             	lea    0x0(%esi),%esi
80100b38:	b8 00 01 00 00       	mov    $0x100,%eax
80100b3d:	e8 be f9 ff ff       	call   80100500 <consputc.part.0>
                while (input.e != input.w &&
80100b42:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100b47:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100b4d:	75 92                	jne    80100ae1 <consoleintr+0xd1>
80100b4f:	e9 f3 fe ff ff       	jmp    80100a47 <consoleintr+0x37>
80100b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100b58:	83 ec 0c             	sub    $0xc,%esp
80100b5b:	68 a0 1f 11 80       	push   $0x80111fa0
80100b60:	e8 1b 3f 00 00       	call   80104a80 <release>
    if (doprocdump) {
80100b65:	83 c4 10             	add    $0x10,%esp
80100b68:	85 f6                	test   %esi,%esi
80100b6a:	75 2b                	jne    80100b97 <consoleintr+0x187>
}
80100b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b6f:	5b                   	pop    %ebx
80100b70:	5e                   	pop    %esi
80100b71:	5f                   	pop    %edi
80100b72:	5d                   	pop    %ebp
80100b73:	c3                   	ret    
                if (c != 0 && input.e - input.r < INPUT_BUF) {
80100b74:	85 db                	test   %ebx,%ebx
80100b76:	0f 84 cb fe ff ff    	je     80100a47 <consoleintr+0x37>
80100b7c:	e9 e2 fe ff ff       	jmp    80100a63 <consoleintr+0x53>
80100b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b88:	b8 00 01 00 00       	mov    $0x100,%eax
80100b8d:	e8 6e f9 ff ff       	call   80100500 <consputc.part.0>
80100b92:	e9 b0 fe ff ff       	jmp    80100a47 <consoleintr+0x37>
}
80100b97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b9a:	5b                   	pop    %ebx
80100b9b:	5e                   	pop    %esi
80100b9c:	5f                   	pop    %edi
80100b9d:	5d                   	pop    %ebp
        procdump();  // now call procdump() wo. cons.lock held
80100b9e:	e9 7d 3b 00 00       	jmp    80104720 <procdump>
                    input.buf[input.e++ % INPUT_BUF] = c;
80100ba3:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
    if (panicked) {
80100baa:	85 d2                	test   %edx,%edx
80100bac:	74 0a                	je     80100bb8 <consoleintr+0x1a8>
80100bae:	fa                   	cli    
        for (;;) {
80100baf:	eb fe                	jmp    80100baf <consoleintr+0x19f>
80100bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bb8:	b8 0a 00 00 00       	mov    $0xa,%eax
80100bbd:	e8 3e f9 ff ff       	call   80100500 <consputc.part.0>
                        input.w = input.e;
80100bc2:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
                        wakeup(&input.r);
80100bc7:	83 ec 0c             	sub    $0xc,%esp
                        input.w = input.e;
80100bca:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
                        wakeup(&input.r);
80100bcf:	68 c0 0f 11 80       	push   $0x80110fc0
80100bd4:	e8 67 3a 00 00       	call   80104640 <wakeup>
80100bd9:	83 c4 10             	add    $0x10,%esp
80100bdc:	e9 66 fe ff ff       	jmp    80100a47 <consoleintr+0x37>
80100be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bef:	90                   	nop

80100bf0 <consoleinit>:

void consoleinit(void) {
80100bf0:	55                   	push   %ebp
80100bf1:	89 e5                	mov    %esp,%ebp
80100bf3:	83 ec 10             	sub    $0x10,%esp
    initlock(&cons.lock, "console");
80100bf6:	68 68 7b 10 80       	push   $0x80107b68
80100bfb:	68 a0 1f 11 80       	push   $0x80111fa0
80100c00:	e8 0b 3d 00 00       	call   80104910 <initlock>

    devsw[CONSOLE].write = consolewrite;
    devsw[CONSOLE].read = consoleread;
    cons.locking = 1;

    ioapicenable(IRQ_KBD, 0);
80100c05:	58                   	pop    %eax
80100c06:	5a                   	pop    %edx
80100c07:	6a 00                	push   $0x0
80100c09:	6a 01                	push   $0x1
    devsw[CONSOLE].write = consolewrite;
80100c0b:	c7 05 8c 29 11 80 d0 	movl   $0x801006d0,0x8011298c
80100c12:	06 10 80 
    devsw[CONSOLE].read = consoleread;
80100c15:	c7 05 88 29 11 80 80 	movl   $0x80100280,0x80112988
80100c1c:	02 10 80 
    cons.locking = 1;
80100c1f:	c7 05 d4 1f 11 80 01 	movl   $0x1,0x80111fd4
80100c26:	00 00 00 
    ioapicenable(IRQ_KBD, 0);
80100c29:	e8 52 1d 00 00       	call   80102980 <ioapicenable>
}
80100c2e:	83 c4 10             	add    $0x10,%esp
80100c31:	c9                   	leave  
80100c32:	c3                   	ret    
80100c33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100c40 <acquireconslock>:

void acquireconslock(void) {
80100c40:	55                   	push   %ebp
80100c41:	89 e5                	mov    %esp,%ebp
80100c43:	83 ec 14             	sub    $0x14,%esp
    acquire(&cons.lock);
80100c46:	68 a0 1f 11 80       	push   $0x80111fa0
80100c4b:	e8 90 3e 00 00       	call   80104ae0 <acquire>
}
80100c50:	83 c4 10             	add    $0x10,%esp
80100c53:	c9                   	leave  
80100c54:	c3                   	ret    
80100c55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100c60 <releaseconslock>:

void releaseconslock(void) {
80100c60:	55                   	push   %ebp
80100c61:	89 e5                	mov    %esp,%ebp
80100c63:	83 ec 14             	sub    $0x14,%esp
     release(&cons.lock);
80100c66:	68 a0 1f 11 80       	push   $0x80111fa0
80100c6b:	e8 10 3e 00 00       	call   80104a80 <release>
80100c70:	83 c4 10             	add    $0x10,%esp
80100c73:	c9                   	leave  
80100c74:	c3                   	ret    
80100c75:	66 90                	xchg   %ax,%ax
80100c77:	66 90                	xchg   %ax,%ax
80100c79:	66 90                	xchg   %ax,%ax
80100c7b:	66 90                	xchg   %ax,%ax
80100c7d:	66 90                	xchg   %ax,%ax
80100c7f:	90                   	nop

80100c80 <cleanupexec>:
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

void cleanupexec(pde_t * pgdir, struct inode *ip) {
80100c80:	55                   	push   %ebp
80100c81:	89 e5                	mov    %esp,%ebp
80100c83:	53                   	push   %ebx
80100c84:	83 ec 04             	sub    $0x4,%esp
80100c87:	8b 45 08             	mov    0x8(%ebp),%eax
80100c8a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (pgdir) {
80100c8d:	85 c0                	test   %eax,%eax
80100c8f:	74 0c                	je     80100c9d <cleanupexec+0x1d>
        freevm(pgdir);
80100c91:	83 ec 0c             	sub    $0xc,%esp
80100c94:	50                   	push   %eax
80100c95:	e8 66 6a 00 00       	call   80107700 <freevm>
80100c9a:	83 c4 10             	add    $0x10,%esp
    }
    if (ip) {
80100c9d:	85 db                	test   %ebx,%ebx
80100c9f:	74 1f                	je     80100cc0 <cleanupexec+0x40>
        iunlockput(ip);
80100ca1:	83 ec 0c             	sub    $0xc,%esp
80100ca4:	53                   	push   %ebx
80100ca5:	e8 e6 0f 00 00       	call   80101c90 <iunlockput>
        end_op();
    }    
}
80100caa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        end_op();
80100cad:	83 c4 10             	add    $0x10,%esp
}
80100cb0:	c9                   	leave  
        end_op();
80100cb1:	e9 1a 26 00 00       	jmp    801032d0 <end_op>
80100cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cbd:	8d 76 00             	lea    0x0(%esi),%esi
}
80100cc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cc3:	c9                   	leave  
80100cc4:	c3                   	ret    
80100cc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100cd0 <exec>:

int exec(char *path, char **argv) {
80100cd0:	55                   	push   %ebp
80100cd1:	89 e5                	mov    %esp,%ebp
80100cd3:	57                   	push   %edi
80100cd4:	56                   	push   %esi
80100cd5:	53                   	push   %ebx
80100cd6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
    uint argc, sz, sp, ustack[3 + MAXARG + 1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
80100cdc:	e8 cf 31 00 00       	call   80103eb0 <myproc>
80100ce1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

    begin_op();
80100ce7:	e8 74 25 00 00       	call   80103260 <begin_op>

    if ((ip = namei(path)) == 0) {
80100cec:	83 ec 0c             	sub    $0xc,%esp
80100cef:	ff 75 08             	push   0x8(%ebp)
80100cf2:	e8 29 16 00 00       	call   80102320 <namei>
80100cf7:	83 c4 10             	add    $0x10,%esp
80100cfa:	85 c0                	test   %eax,%eax
80100cfc:	0f 84 49 03 00 00    	je     8010104b <exec+0x37b>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
80100d02:	83 ec 0c             	sub    $0xc,%esp
80100d05:	89 c7                	mov    %eax,%edi
80100d07:	50                   	push   %eax
80100d08:	e8 f3 0c 00 00       	call   80101a00 <ilock>
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf)) {
80100d0d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100d13:	6a 34                	push   $0x34
80100d15:	6a 00                	push   $0x0
80100d17:	50                   	push   %eax
80100d18:	57                   	push   %edi
80100d19:	e8 f2 0f 00 00       	call   80101d10 <readi>
80100d1e:	83 c4 20             	add    $0x20,%esp
80100d21:	83 f8 34             	cmp    $0x34,%eax
80100d24:	0f 85 d6 02 00 00    	jne    80101000 <exec+0x330>
        cleanupexec(pgdir, ip);
        return -1;
    }
    if (elf.magic != ELF_MAGIC) {
80100d2a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100d31:	45 4c 46 
80100d34:	0f 85 c6 02 00 00    	jne    80101000 <exec+0x330>
        cleanupexec(pgdir, ip);
        return -1;        
    }

    if ((pgdir = setupkvm()) == 0) {
80100d3a:	e8 41 6a 00 00       	call   80107780 <setupkvm>
80100d3f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100d45:	85 c0                	test   %eax,%eax
80100d47:	0f 84 b3 02 00 00    	je     80101000 <exec+0x330>
        return -1;    
    }

    // Load program into memory.
    sz = 0;
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100d4d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100d54:	00 
80100d55:	8b 9d 40 ff ff ff    	mov    -0xc0(%ebp),%ebx
80100d5b:	0f 84 ba 02 00 00    	je     8010101b <exec+0x34b>
    sz = 0;
80100d61:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100d68:	00 00 00 
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100d6b:	31 f6                	xor    %esi,%esi
80100d6d:	e9 8c 00 00 00       	jmp    80100dfe <exec+0x12e>
80100d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph)) {
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (ph.type != ELF_PROG_LOAD) {
80100d78:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100d7f:	75 6c                	jne    80100ded <exec+0x11d>
            continue;
        }
        if (ph.memsz < ph.filesz) {
80100d81:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100d87:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100d8d:	0f 82 87 00 00 00    	jb     80100e1a <exec+0x14a>
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (ph.vaddr + ph.memsz < ph.vaddr) {
80100d93:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100d99:	72 7f                	jb     80100e1a <exec+0x14a>
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0) {
80100d9b:	83 ec 04             	sub    $0x4,%esp
80100d9e:	50                   	push   %eax
80100d9f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100da5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dab:	e8 f0 67 00 00       	call   801075a0 <allocuvm>
80100db0:	83 c4 10             	add    $0x10,%esp
80100db3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100db9:	85 c0                	test   %eax,%eax
80100dbb:	74 5d                	je     80100e1a <exec+0x14a>
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (ph.vaddr % PGSIZE != 0) {
80100dbd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100dc3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100dc8:	75 50                	jne    80100e1a <exec+0x14a>
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0) {
80100dca:	83 ec 0c             	sub    $0xc,%esp
80100dcd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100dd3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100dd9:	57                   	push   %edi
80100dda:	50                   	push   %eax
80100ddb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100de1:	e8 ca 66 00 00       	call   801074b0 <loaduvm>
80100de6:	83 c4 20             	add    $0x20,%esp
80100de9:	85 c0                	test   %eax,%eax
80100deb:	78 2d                	js     80100e1a <exec+0x14a>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100ded:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100df4:	83 c6 01             	add    $0x1,%esi
80100df7:	83 c3 20             	add    $0x20,%ebx
80100dfa:	39 f0                	cmp    %esi,%eax
80100dfc:	7e 4a                	jle    80100e48 <exec+0x178>
        if (readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph)) {
80100dfe:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100e04:	6a 20                	push   $0x20
80100e06:	53                   	push   %ebx
80100e07:	50                   	push   %eax
80100e08:	57                   	push   %edi
80100e09:	e8 02 0f 00 00       	call   80101d10 <readi>
80100e0e:	83 c4 10             	add    $0x10,%esp
80100e11:	83 f8 20             	cmp    $0x20,%eax
80100e14:	0f 84 5e ff ff ff    	je     80100d78 <exec+0xa8>
        freevm(pgdir);
80100e1a:	83 ec 0c             	sub    $0xc,%esp
80100e1d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e23:	e8 d8 68 00 00       	call   80107700 <freevm>
        iunlockput(ip);
80100e28:	89 3c 24             	mov    %edi,(%esp)
80100e2b:	e8 60 0e 00 00       	call   80101c90 <iunlockput>
        end_op();
80100e30:	e8 9b 24 00 00       	call   801032d0 <end_op>
}
80100e35:	83 c4 10             	add    $0x10,%esp
            cleanupexec(pgdir, ip);
            return -1;    
80100e38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    curproc->tf->eip = elf.entry;  // main
    curproc->tf->esp = sp;
    switchuvm(curproc);
    freevm(oldpgdir);
    return 0;
}
80100e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e40:	5b                   	pop    %ebx
80100e41:	5e                   	pop    %esi
80100e42:	5f                   	pop    %edi
80100e43:	5d                   	pop    %ebp
80100e44:	c3                   	ret    
80100e45:	8d 76 00             	lea    0x0(%esi),%esi
    sz = PGROUNDUP(sz);
80100e48:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100e4e:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100e54:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0) {
80100e5a:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
    iunlockput(ip);
80100e60:	83 ec 0c             	sub    $0xc,%esp
80100e63:	57                   	push   %edi
80100e64:	e8 27 0e 00 00       	call   80101c90 <iunlockput>
    end_op();
80100e69:	e8 62 24 00 00       	call   801032d0 <end_op>
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0) {
80100e6e:	83 c4 0c             	add    $0xc,%esp
80100e71:	53                   	push   %ebx
80100e72:	56                   	push   %esi
80100e73:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e79:	e8 22 67 00 00       	call   801075a0 <allocuvm>
80100e7e:	83 c4 10             	add    $0x10,%esp
80100e81:	89 c7                	mov    %eax,%edi
80100e83:	85 c0                	test   %eax,%eax
80100e85:	0f 84 87 00 00 00    	je     80100f12 <exec+0x242>
    clearpteu(pgdir, (char*)(sz - 2 * PGSIZE));
80100e8b:	83 ec 08             	sub    $0x8,%esp
80100e8e:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
    for (argc = 0; argv[argc]; argc++) {
80100e94:	89 fb                	mov    %edi,%ebx
80100e96:	31 f6                	xor    %esi,%esi
    clearpteu(pgdir, (char*)(sz - 2 * PGSIZE));
80100e98:	50                   	push   %eax
80100e99:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e9f:	e8 7c 69 00 00       	call   80107820 <clearpteu>
    for (argc = 0; argv[argc]; argc++) {
80100ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ea7:	83 c4 10             	add    $0x10,%esp
80100eaa:	8b 08                	mov    (%eax),%ecx
80100eac:	85 c9                	test   %ecx,%ecx
80100eae:	0f 84 73 01 00 00    	je     80101027 <exec+0x357>
80100eb4:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100eba:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ebd:	eb 1f                	jmp    80100ede <exec+0x20e>
80100ebf:	90                   	nop
80100ec0:	8d 46 01             	lea    0x1(%esi),%eax
        ustack[3 + argc] = sp;
80100ec3:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100eca:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    for (argc = 0; argv[argc]; argc++) {
80100ed0:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80100ed3:	85 c9                	test   %ecx,%ecx
80100ed5:	74 59                	je     80100f30 <exec+0x260>
        if (argc >= MAXARG) {
80100ed7:	83 f8 20             	cmp    $0x20,%eax
80100eda:	74 36                	je     80100f12 <exec+0x242>
80100edc:	89 c6                	mov    %eax,%esi
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ede:	83 ec 0c             	sub    $0xc,%esp
80100ee1:	51                   	push   %ecx
80100ee2:	e8 b9 3e 00 00       	call   80104da0 <strlen>
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) {
80100ee7:	5a                   	pop    %edx
80100ee8:	ff 34 b7             	push   (%edi,%esi,4)
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100eeb:	29 c3                	sub    %eax,%ebx
80100eed:	83 eb 01             	sub    $0x1,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) {
80100ef0:	e8 ab 3e 00 00       	call   80104da0 <strlen>
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ef5:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) {
80100ef8:	83 c0 01             	add    $0x1,%eax
80100efb:	50                   	push   %eax
80100efc:	ff 34 b7             	push   (%edi,%esi,4)
80100eff:	53                   	push   %ebx
80100f00:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100f06:	e8 05 6b 00 00       	call   80107a10 <copyout>
80100f0b:	83 c4 20             	add    $0x20,%esp
80100f0e:	85 c0                	test   %eax,%eax
80100f10:	79 ae                	jns    80100ec0 <exec+0x1f0>
        freevm(pgdir);
80100f12:	83 ec 0c             	sub    $0xc,%esp
80100f15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100f1b:	e8 e0 67 00 00       	call   80107700 <freevm>
}
80100f20:	83 c4 10             	add    $0x10,%esp
}
80100f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;    
80100f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f2b:	5b                   	pop    %ebx
80100f2c:	5e                   	pop    %esi
80100f2d:	5f                   	pop    %edi
80100f2e:	5d                   	pop    %ebp
80100f2f:	c3                   	ret    
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100f30:	8d 0c b5 08 00 00 00 	lea    0x8(,%esi,4),%ecx
    ustack[3 + argc] = 0;
80100f37:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100f3d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f43:	8d 46 04             	lea    0x4(%esi),%eax
    sp -= (3 + argc + 1) * 4;
80100f46:	8d 71 0c             	lea    0xc(%ecx),%esi
    ustack[3 + argc] = 0;
80100f49:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100f50:	00 00 00 00 
    ustack[1] = argc;
80100f54:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80100f5a:	56                   	push   %esi
    ustack[1] = argc;
80100f5b:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100f61:	89 d8                	mov    %ebx,%eax
    sp -= (3 + argc + 1) * 4;
80100f63:	29 f3                	sub    %esi,%ebx
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80100f65:	52                   	push   %edx
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100f66:	29 c8                	sub    %ecx,%eax
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80100f68:	53                   	push   %ebx
80100f69:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
    ustack[0] = 0xffffffff;  // fake return PC
80100f6f:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100f76:	ff ff ff 
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100f79:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80100f7f:	e8 8c 6a 00 00       	call   80107a10 <copyout>
80100f84:	83 c4 10             	add    $0x10,%esp
80100f87:	85 c0                	test   %eax,%eax
80100f89:	0f 88 db 00 00 00    	js     8010106a <exec+0x39a>
    for (last = s = path; *s; s++) {
80100f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80100f92:	8b 55 08             	mov    0x8(%ebp),%edx
80100f95:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100f98:	0f b6 00             	movzbl (%eax),%eax
80100f9b:	84 c0                	test   %al,%al
80100f9d:	74 10                	je     80100faf <exec+0x2df>
80100f9f:	90                   	nop
            last = s + 1;
80100fa0:	83 c1 01             	add    $0x1,%ecx
80100fa3:	3c 2f                	cmp    $0x2f,%al
    for (last = s = path; *s; s++) {
80100fa5:	0f b6 01             	movzbl (%ecx),%eax
            last = s + 1;
80100fa8:	0f 44 d1             	cmove  %ecx,%edx
    for (last = s = path; *s; s++) {
80100fab:	84 c0                	test   %al,%al
80100fad:	75 f1                	jne    80100fa0 <exec+0x2d0>
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80100faf:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100fb5:	83 ec 04             	sub    $0x4,%esp
80100fb8:	6a 10                	push   $0x10
80100fba:	8d 46 6c             	lea    0x6c(%esi),%eax
80100fbd:	52                   	push   %edx
80100fbe:	50                   	push   %eax
80100fbf:	e8 9c 3d 00 00       	call   80104d60 <safestrcpy>
    curproc->pgdir = pgdir;
80100fc4:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
    oldpgdir = curproc->pgdir;
80100fca:	89 f1                	mov    %esi,%ecx
80100fcc:	8b 76 04             	mov    0x4(%esi),%esi
    curproc->tf->eip = elf.entry;  // main
80100fcf:	8b 41 18             	mov    0x18(%ecx),%eax
    curproc->sz = sz;
80100fd2:	89 39                	mov    %edi,(%ecx)
    curproc->pgdir = pgdir;
80100fd4:	89 51 04             	mov    %edx,0x4(%ecx)
    curproc->tf->eip = elf.entry;  // main
80100fd7:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100fdd:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
80100fe0:	8b 41 18             	mov    0x18(%ecx),%eax
80100fe3:	89 58 44             	mov    %ebx,0x44(%eax)
    switchuvm(curproc);
80100fe6:	89 0c 24             	mov    %ecx,(%esp)
80100fe9:	e8 32 63 00 00       	call   80107320 <switchuvm>
    freevm(oldpgdir);
80100fee:	89 34 24             	mov    %esi,(%esp)
80100ff1:	e8 0a 67 00 00       	call   80107700 <freevm>
    return 0;
80100ff6:	83 c4 10             	add    $0x10,%esp
80100ff9:	31 c0                	xor    %eax,%eax
80100ffb:	e9 3d fe ff ff       	jmp    80100e3d <exec+0x16d>
        iunlockput(ip);
80101000:	83 ec 0c             	sub    $0xc,%esp
80101003:	57                   	push   %edi
80101004:	e8 87 0c 00 00       	call   80101c90 <iunlockput>
        end_op();
80101009:	e8 c2 22 00 00       	call   801032d0 <end_op>
}
8010100e:	83 c4 10             	add    $0x10,%esp
        return -1;    
80101011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101016:	e9 22 fe ff ff       	jmp    80100e3d <exec+0x16d>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
8010101b:	bb 00 20 00 00       	mov    $0x2000,%ebx
80101020:	31 f6                	xor    %esi,%esi
80101022:	e9 39 fe ff ff       	jmp    80100e60 <exec+0x190>
    for (argc = 0; argv[argc]; argc++) {
80101027:	be 10 00 00 00       	mov    $0x10,%esi
8010102c:	b9 04 00 00 00       	mov    $0x4,%ecx
80101031:	b8 03 00 00 00       	mov    $0x3,%eax
80101036:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
8010103d:	00 00 00 
80101040:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101046:	e9 fe fe ff ff       	jmp    80100f49 <exec+0x279>
        end_op();
8010104b:	e8 80 22 00 00       	call   801032d0 <end_op>
        cprintf("exec: fail\n");
80101050:	83 ec 0c             	sub    $0xc,%esp
80101053:	68 81 7b 10 80       	push   $0x80107b81
80101058:	e8 83 f7 ff ff       	call   801007e0 <cprintf>
        return -1;
8010105d:	83 c4 10             	add    $0x10,%esp
80101060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101065:	e9 d3 fd ff ff       	jmp    80100e3d <exec+0x16d>
        cleanupexec(pgdir, ip);
8010106a:	50                   	push   %eax
8010106b:	50                   	push   %eax
8010106c:	6a 00                	push   $0x0
8010106e:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101074:	e8 07 fc ff ff       	call   80100c80 <cleanupexec>
        return -1;    
80101079:	83 c4 10             	add    $0x10,%esp
8010107c:	83 c8 ff             	or     $0xffffffff,%eax
8010107f:	e9 b9 fd ff ff       	jmp    80100e3d <exec+0x16d>
80101084:	66 90                	xchg   %ax,%ax
80101086:	66 90                	xchg   %ax,%ax
80101088:	66 90                	xchg   %ax,%ax
8010108a:	66 90                	xchg   %ax,%ax
8010108c:	66 90                	xchg   %ax,%ax
8010108e:	66 90                	xchg   %ax,%ax

80101090 <fileinit>:
struct {
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void) {
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	83 ec 10             	sub    $0x10,%esp
    initlock(&ftable.lock, "ftable");
80101096:	68 8d 7b 10 80       	push   $0x80107b8d
8010109b:	68 e0 1f 11 80       	push   $0x80111fe0
801010a0:	e8 6b 38 00 00       	call   80104910 <initlock>
}
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	c9                   	leave  
801010a9:	c3                   	ret    
801010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010b0 <filealloc>:

// Allocate a file structure.
struct file* filealloc(void) {
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	53                   	push   %ebx
    struct file *f;

    acquire(&ftable.lock);
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
801010b4:	bb 14 20 11 80       	mov    $0x80112014,%ebx
struct file* filealloc(void) {
801010b9:	83 ec 10             	sub    $0x10,%esp
    acquire(&ftable.lock);
801010bc:	68 e0 1f 11 80       	push   $0x80111fe0
801010c1:	e8 1a 3a 00 00       	call   80104ae0 <acquire>
801010c6:	83 c4 10             	add    $0x10,%esp
801010c9:	eb 10                	jmp    801010db <filealloc+0x2b>
801010cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010cf:	90                   	nop
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
801010d0:	83 c3 18             	add    $0x18,%ebx
801010d3:	81 fb 74 29 11 80    	cmp    $0x80112974,%ebx
801010d9:	74 25                	je     80101100 <filealloc+0x50>
        if (f->ref == 0) {
801010db:	8b 43 04             	mov    0x4(%ebx),%eax
801010de:	85 c0                	test   %eax,%eax
801010e0:	75 ee                	jne    801010d0 <filealloc+0x20>
            f->ref = 1;
            release(&ftable.lock);
801010e2:	83 ec 0c             	sub    $0xc,%esp
            f->ref = 1;
801010e5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
            release(&ftable.lock);
801010ec:	68 e0 1f 11 80       	push   $0x80111fe0
801010f1:	e8 8a 39 00 00       	call   80104a80 <release>
            return f;
        }
    }
    release(&ftable.lock);
    return 0;
}
801010f6:	89 d8                	mov    %ebx,%eax
            return f;
801010f8:	83 c4 10             	add    $0x10,%esp
}
801010fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010fe:	c9                   	leave  
801010ff:	c3                   	ret    
    release(&ftable.lock);
80101100:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80101103:	31 db                	xor    %ebx,%ebx
    release(&ftable.lock);
80101105:	68 e0 1f 11 80       	push   $0x80111fe0
8010110a:	e8 71 39 00 00       	call   80104a80 <release>
}
8010110f:	89 d8                	mov    %ebx,%eax
    return 0;
80101111:	83 c4 10             	add    $0x10,%esp
}
80101114:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101117:	c9                   	leave  
80101118:	c3                   	ret    
80101119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101120 <filedup>:

// Increment ref count for file f.
struct file* filedup(struct file *f) {
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	53                   	push   %ebx
80101124:	83 ec 10             	sub    $0x10,%esp
80101127:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ftable.lock);
8010112a:	68 e0 1f 11 80       	push   $0x80111fe0
8010112f:	e8 ac 39 00 00       	call   80104ae0 <acquire>
    if (f->ref < 1) {
80101134:	8b 43 04             	mov    0x4(%ebx),%eax
80101137:	83 c4 10             	add    $0x10,%esp
8010113a:	85 c0                	test   %eax,%eax
8010113c:	7e 1a                	jle    80101158 <filedup+0x38>
        panic("filedup");
    }
    f->ref++;
8010113e:	83 c0 01             	add    $0x1,%eax
    release(&ftable.lock);
80101141:	83 ec 0c             	sub    $0xc,%esp
    f->ref++;
80101144:	89 43 04             	mov    %eax,0x4(%ebx)
    release(&ftable.lock);
80101147:	68 e0 1f 11 80       	push   $0x80111fe0
8010114c:	e8 2f 39 00 00       	call   80104a80 <release>
    return f;
}
80101151:	89 d8                	mov    %ebx,%eax
80101153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101156:	c9                   	leave  
80101157:	c3                   	ret    
        panic("filedup");
80101158:	83 ec 0c             	sub    $0xc,%esp
8010115b:	68 94 7b 10 80       	push   $0x80107b94
80101160:	e8 1b f3 ff ff       	call   80100480 <panic>
80101165:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101170 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	57                   	push   %edi
80101174:	56                   	push   %esi
80101175:	53                   	push   %ebx
80101176:	83 ec 28             	sub    $0x28,%esp
80101179:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct file ff;

    acquire(&ftable.lock);
8010117c:	68 e0 1f 11 80       	push   $0x80111fe0
80101181:	e8 5a 39 00 00       	call   80104ae0 <acquire>
    if (f->ref < 1) {
80101186:	8b 53 04             	mov    0x4(%ebx),%edx
80101189:	83 c4 10             	add    $0x10,%esp
8010118c:	85 d2                	test   %edx,%edx
8010118e:	0f 8e a5 00 00 00    	jle    80101239 <fileclose+0xc9>
        panic("fileclose");
    }
    if (--f->ref > 0) {
80101194:	83 ea 01             	sub    $0x1,%edx
80101197:	89 53 04             	mov    %edx,0x4(%ebx)
8010119a:	75 44                	jne    801011e0 <fileclose+0x70>
        release(&ftable.lock);
        return;
    }
    ff = *f;
8010119c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
    f->ref = 0;
    f->type = FD_NONE;
    release(&ftable.lock);
801011a0:	83 ec 0c             	sub    $0xc,%esp
    ff = *f;
801011a3:	8b 3b                	mov    (%ebx),%edi
    f->type = FD_NONE;
801011a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    ff = *f;
801011ab:	8b 73 0c             	mov    0xc(%ebx),%esi
801011ae:	88 45 e7             	mov    %al,-0x19(%ebp)
801011b1:	8b 43 10             	mov    0x10(%ebx),%eax
    release(&ftable.lock);
801011b4:	68 e0 1f 11 80       	push   $0x80111fe0
    ff = *f;
801011b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    release(&ftable.lock);
801011bc:	e8 bf 38 00 00       	call   80104a80 <release>

    if (ff.type == FD_PIPE) {
801011c1:	83 c4 10             	add    $0x10,%esp
801011c4:	83 ff 01             	cmp    $0x1,%edi
801011c7:	74 57                	je     80101220 <fileclose+0xb0>
        pipeclose(ff.pipe, ff.writable);
    }
    else if (ff.type == FD_INODE) {
801011c9:	83 ff 02             	cmp    $0x2,%edi
801011cc:	74 2a                	je     801011f8 <fileclose+0x88>
        begin_op();
        iput(ff.ip);
        end_op();
    }
}
801011ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d1:	5b                   	pop    %ebx
801011d2:	5e                   	pop    %esi
801011d3:	5f                   	pop    %edi
801011d4:	5d                   	pop    %ebp
801011d5:	c3                   	ret    
801011d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011dd:	8d 76 00             	lea    0x0(%esi),%esi
        release(&ftable.lock);
801011e0:	c7 45 08 e0 1f 11 80 	movl   $0x80111fe0,0x8(%ebp)
}
801011e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ea:	5b                   	pop    %ebx
801011eb:	5e                   	pop    %esi
801011ec:	5f                   	pop    %edi
801011ed:	5d                   	pop    %ebp
        release(&ftable.lock);
801011ee:	e9 8d 38 00 00       	jmp    80104a80 <release>
801011f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011f7:	90                   	nop
        begin_op();
801011f8:	e8 63 20 00 00       	call   80103260 <begin_op>
        iput(ff.ip);
801011fd:	83 ec 0c             	sub    $0xc,%esp
80101200:	ff 75 e0             	push   -0x20(%ebp)
80101203:	e8 28 09 00 00       	call   80101b30 <iput>
        end_op();
80101208:	83 c4 10             	add    $0x10,%esp
}
8010120b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120e:	5b                   	pop    %ebx
8010120f:	5e                   	pop    %esi
80101210:	5f                   	pop    %edi
80101211:	5d                   	pop    %ebp
        end_op();
80101212:	e9 b9 20 00 00       	jmp    801032d0 <end_op>
80101217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010121e:	66 90                	xchg   %ax,%ax
        pipeclose(ff.pipe, ff.writable);
80101220:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101224:	83 ec 08             	sub    $0x8,%esp
80101227:	53                   	push   %ebx
80101228:	56                   	push   %esi
80101229:	e8 42 28 00 00       	call   80103a70 <pipeclose>
8010122e:	83 c4 10             	add    $0x10,%esp
}
80101231:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101234:	5b                   	pop    %ebx
80101235:	5e                   	pop    %esi
80101236:	5f                   	pop    %edi
80101237:	5d                   	pop    %ebp
80101238:	c3                   	ret    
        panic("fileclose");
80101239:	83 ec 0c             	sub    $0xc,%esp
8010123c:	68 9c 7b 10 80       	push   $0x80107b9c
80101241:	e8 3a f2 ff ff       	call   80100480 <panic>
80101246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010124d:	8d 76 00             	lea    0x0(%esi),%esi

80101250 <filestat>:

// Get metadata about file f.
int filestat(struct file *f, struct stat *st) {
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	53                   	push   %ebx
80101254:	83 ec 04             	sub    $0x4,%esp
80101257:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (f->type == FD_INODE) {
8010125a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010125d:	75 31                	jne    80101290 <filestat+0x40>
        ilock(f->ip);
8010125f:	83 ec 0c             	sub    $0xc,%esp
80101262:	ff 73 10             	push   0x10(%ebx)
80101265:	e8 96 07 00 00       	call   80101a00 <ilock>
        stati(f->ip, st);
8010126a:	58                   	pop    %eax
8010126b:	5a                   	pop    %edx
8010126c:	ff 75 0c             	push   0xc(%ebp)
8010126f:	ff 73 10             	push   0x10(%ebx)
80101272:	e8 69 0a 00 00       	call   80101ce0 <stati>
        iunlock(f->ip);
80101277:	59                   	pop    %ecx
80101278:	ff 73 10             	push   0x10(%ebx)
8010127b:	e8 60 08 00 00       	call   80101ae0 <iunlock>
        return 0;
    }
    return -1;
}
80101280:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        return 0;
80101283:	83 c4 10             	add    $0x10,%esp
80101286:	31 c0                	xor    %eax,%eax
}
80101288:	c9                   	leave  
80101289:	c3                   	ret    
8010128a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101290:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80101293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101298:	c9                   	leave  
80101299:	c3                   	ret    
8010129a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801012a0 <fileread>:

// Read from file f.
int fileread(struct file *f, char *addr, int n) {
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	56                   	push   %esi
801012a5:	53                   	push   %ebx
801012a6:	83 ec 0c             	sub    $0xc,%esp
801012a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801012ac:	8b 75 0c             	mov    0xc(%ebp),%esi
801012af:	8b 7d 10             	mov    0x10(%ebp),%edi
    int r;

    if (f->readable == 0) {
801012b2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801012b6:	74 60                	je     80101318 <fileread+0x78>
        return -1;
    }
    if (f->type == FD_PIPE) {
801012b8:	8b 03                	mov    (%ebx),%eax
801012ba:	83 f8 01             	cmp    $0x1,%eax
801012bd:	74 41                	je     80101300 <fileread+0x60>
        return piperead(f->pipe, addr, n);
    }
    if (f->type == FD_INODE) {
801012bf:	83 f8 02             	cmp    $0x2,%eax
801012c2:	75 5b                	jne    8010131f <fileread+0x7f>
        ilock(f->ip);
801012c4:	83 ec 0c             	sub    $0xc,%esp
801012c7:	ff 73 10             	push   0x10(%ebx)
801012ca:	e8 31 07 00 00       	call   80101a00 <ilock>
        if ((r = readi(f->ip, addr, f->off, n)) > 0) {
801012cf:	57                   	push   %edi
801012d0:	ff 73 14             	push   0x14(%ebx)
801012d3:	56                   	push   %esi
801012d4:	ff 73 10             	push   0x10(%ebx)
801012d7:	e8 34 0a 00 00       	call   80101d10 <readi>
801012dc:	83 c4 20             	add    $0x20,%esp
801012df:	89 c6                	mov    %eax,%esi
801012e1:	85 c0                	test   %eax,%eax
801012e3:	7e 03                	jle    801012e8 <fileread+0x48>
            f->off += r;
801012e5:	01 43 14             	add    %eax,0x14(%ebx)
        }
        iunlock(f->ip);
801012e8:	83 ec 0c             	sub    $0xc,%esp
801012eb:	ff 73 10             	push   0x10(%ebx)
801012ee:	e8 ed 07 00 00       	call   80101ae0 <iunlock>
        return r;
801012f3:	83 c4 10             	add    $0x10,%esp
    }
    panic("fileread");
}
801012f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012f9:	89 f0                	mov    %esi,%eax
801012fb:	5b                   	pop    %ebx
801012fc:	5e                   	pop    %esi
801012fd:	5f                   	pop    %edi
801012fe:	5d                   	pop    %ebp
801012ff:	c3                   	ret    
        return piperead(f->pipe, addr, n);
80101300:	8b 43 0c             	mov    0xc(%ebx),%eax
80101303:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101306:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101309:	5b                   	pop    %ebx
8010130a:	5e                   	pop    %esi
8010130b:	5f                   	pop    %edi
8010130c:	5d                   	pop    %ebp
        return piperead(f->pipe, addr, n);
8010130d:	e9 fe 28 00 00       	jmp    80103c10 <piperead>
80101312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80101318:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010131d:	eb d7                	jmp    801012f6 <fileread+0x56>
    panic("fileread");
8010131f:	83 ec 0c             	sub    $0xc,%esp
80101322:	68 a6 7b 10 80       	push   $0x80107ba6
80101327:	e8 54 f1 ff ff       	call   80100480 <panic>
8010132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101330 <filewrite>:


// Write to file f.
int filewrite(struct file *f, char *addr, int n) {
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	57                   	push   %edi
80101334:	56                   	push   %esi
80101335:	53                   	push   %ebx
80101336:	83 ec 1c             	sub    $0x1c,%esp
80101339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010133c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010133f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101342:	8b 45 10             	mov    0x10(%ebp),%eax
    int r;

    if (f->writable == 0) {
80101345:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
int filewrite(struct file *f, char *addr, int n) {
80101349:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (f->writable == 0) {
8010134c:	0f 84 bd 00 00 00    	je     8010140f <filewrite+0xdf>
        return -1;
    }
    if (f->type == FD_PIPE) {
80101352:	8b 03                	mov    (%ebx),%eax
80101354:	83 f8 01             	cmp    $0x1,%eax
80101357:	0f 84 bf 00 00 00    	je     8010141c <filewrite+0xec>
        return pipewrite(f->pipe, addr, n);
    }
    if (f->type == FD_INODE) {
8010135d:	83 f8 02             	cmp    $0x2,%eax
80101360:	0f 85 c8 00 00 00    	jne    8010142e <filewrite+0xfe>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * 512;
        int i = 0;
        while (i < n) {
80101366:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        int i = 0;
80101369:	31 f6                	xor    %esi,%esi
        while (i < n) {
8010136b:	85 c0                	test   %eax,%eax
8010136d:	7f 30                	jg     8010139f <filewrite+0x6f>
8010136f:	e9 94 00 00 00       	jmp    80101408 <filewrite+0xd8>
80101374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            }

            begin_op();
            ilock(f->ip);
            if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) {
                f->off += r;
80101378:	01 43 14             	add    %eax,0x14(%ebx)
            }
            iunlock(f->ip);
8010137b:	83 ec 0c             	sub    $0xc,%esp
8010137e:	ff 73 10             	push   0x10(%ebx)
                f->off += r;
80101381:	89 45 e0             	mov    %eax,-0x20(%ebp)
            iunlock(f->ip);
80101384:	e8 57 07 00 00       	call   80101ae0 <iunlock>
            end_op();
80101389:	e8 42 1f 00 00       	call   801032d0 <end_op>

            if (r < 0) {
                break;
            }
            if (r != n1) {
8010138e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101391:	83 c4 10             	add    $0x10,%esp
80101394:	39 c7                	cmp    %eax,%edi
80101396:	75 5c                	jne    801013f4 <filewrite+0xc4>
                panic("short filewrite");
            }
            i += r;
80101398:	01 fe                	add    %edi,%esi
        while (i < n) {
8010139a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010139d:	7e 69                	jle    80101408 <filewrite+0xd8>
            int n1 = n - i;
8010139f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801013a2:	b8 00 06 00 00       	mov    $0x600,%eax
801013a7:	29 f7                	sub    %esi,%edi
801013a9:	39 c7                	cmp    %eax,%edi
801013ab:	0f 4f f8             	cmovg  %eax,%edi
            begin_op();
801013ae:	e8 ad 1e 00 00       	call   80103260 <begin_op>
            ilock(f->ip);
801013b3:	83 ec 0c             	sub    $0xc,%esp
801013b6:	ff 73 10             	push   0x10(%ebx)
801013b9:	e8 42 06 00 00       	call   80101a00 <ilock>
            if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) {
801013be:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013c1:	57                   	push   %edi
801013c2:	ff 73 14             	push   0x14(%ebx)
801013c5:	01 f0                	add    %esi,%eax
801013c7:	50                   	push   %eax
801013c8:	ff 73 10             	push   0x10(%ebx)
801013cb:	e8 40 0a 00 00       	call   80101e10 <writei>
801013d0:	83 c4 20             	add    $0x20,%esp
801013d3:	85 c0                	test   %eax,%eax
801013d5:	7f a1                	jg     80101378 <filewrite+0x48>
            iunlock(f->ip);
801013d7:	83 ec 0c             	sub    $0xc,%esp
801013da:	ff 73 10             	push   0x10(%ebx)
801013dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801013e0:	e8 fb 06 00 00       	call   80101ae0 <iunlock>
            end_op();
801013e5:	e8 e6 1e 00 00       	call   801032d0 <end_op>
            if (r < 0) {
801013ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801013ed:	83 c4 10             	add    $0x10,%esp
801013f0:	85 c0                	test   %eax,%eax
801013f2:	75 1b                	jne    8010140f <filewrite+0xdf>
                panic("short filewrite");
801013f4:	83 ec 0c             	sub    $0xc,%esp
801013f7:	68 af 7b 10 80       	push   $0x80107baf
801013fc:	e8 7f f0 ff ff       	call   80100480 <panic>
80101401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
        return i == n ? n : -1;
80101408:	89 f0                	mov    %esi,%eax
8010140a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010140d:	74 05                	je     80101414 <filewrite+0xe4>
8010140f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    panic("filewrite");
}
80101414:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101417:	5b                   	pop    %ebx
80101418:	5e                   	pop    %esi
80101419:	5f                   	pop    %edi
8010141a:	5d                   	pop    %ebp
8010141b:	c3                   	ret    
        return pipewrite(f->pipe, addr, n);
8010141c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010141f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101422:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101425:	5b                   	pop    %ebx
80101426:	5e                   	pop    %esi
80101427:	5f                   	pop    %edi
80101428:	5d                   	pop    %ebp
        return pipewrite(f->pipe, addr, n);
80101429:	e9 e2 26 00 00       	jmp    80103b10 <pipewrite>
    panic("filewrite");
8010142e:	83 ec 0c             	sub    $0xc,%esp
80101431:	68 b5 7b 10 80       	push   $0x80107bb5
80101436:	e8 45 f0 ff ff       	call   80100480 <panic>
8010143b:	66 90                	xchg   %ax,%ax
8010143d:	66 90                	xchg   %ax,%ax
8010143f:	90                   	nop

80101440 <bfree>:
    }
    panic("balloc: out of blocks");
}

// Free a disk block.
static void bfree(int dev, uint b) {
80101440:	55                   	push   %ebp
80101441:	89 c1                	mov    %eax,%ecx
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
80101443:	89 d0                	mov    %edx,%eax
80101445:	c1 e8 0c             	shr    $0xc,%eax
80101448:	03 05 4c 46 11 80    	add    0x8011464c,%eax
static void bfree(int dev, uint b) {
8010144e:	89 e5                	mov    %esp,%ebp
80101450:	56                   	push   %esi
80101451:	53                   	push   %ebx
80101452:	89 d3                	mov    %edx,%ebx
    bp = bread(dev, BBLOCK(b, sb));
80101454:	83 ec 08             	sub    $0x8,%esp
80101457:	50                   	push   %eax
80101458:	51                   	push   %ecx
80101459:	e8 72 ec ff ff       	call   801000d0 <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
8010145e:	89 d9                	mov    %ebx,%ecx
    if ((bp->data[bi / 8] & m) == 0) {
80101460:	c1 fb 03             	sar    $0x3,%ebx
80101463:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, BBLOCK(b, sb));
80101466:	89 c6                	mov    %eax,%esi
    m = 1 << (bi % 8);
80101468:	83 e1 07             	and    $0x7,%ecx
8010146b:	b8 01 00 00 00       	mov    $0x1,%eax
    if ((bp->data[bi / 8] & m) == 0) {
80101470:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
    m = 1 << (bi % 8);
80101476:	d3 e0                	shl    %cl,%eax
    if ((bp->data[bi / 8] & m) == 0) {
80101478:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010147d:	85 c1                	test   %eax,%ecx
8010147f:	74 23                	je     801014a4 <bfree+0x64>
        panic("freeing free block");
    }
    bp->data[bi / 8] &= ~m;
80101481:	f7 d0                	not    %eax
    log_write(bp);
80101483:	83 ec 0c             	sub    $0xc,%esp
    bp->data[bi / 8] &= ~m;
80101486:	21 c8                	and    %ecx,%eax
80101488:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
    log_write(bp);
8010148c:	56                   	push   %esi
8010148d:	e8 ae 1f 00 00       	call   80103440 <log_write>
    brelse(bp);
80101492:	89 34 24             	mov    %esi,(%esp)
80101495:	e8 56 ed ff ff       	call   801001f0 <brelse>
}
8010149a:	83 c4 10             	add    $0x10,%esp
8010149d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014a0:	5b                   	pop    %ebx
801014a1:	5e                   	pop    %esi
801014a2:	5d                   	pop    %ebp
801014a3:	c3                   	ret    
        panic("freeing free block");
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	68 bf 7b 10 80       	push   $0x80107bbf
801014ac:	e8 cf ef ff ff       	call   80100480 <panic>
801014b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014bf:	90                   	nop

801014c0 <balloc>:
static uint balloc(uint dev) {
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	57                   	push   %edi
801014c4:	56                   	push   %esi
801014c5:	53                   	push   %ebx
801014c6:	83 ec 1c             	sub    $0x1c,%esp
    for (b = 0; b < sb.size; b += BPB) {
801014c9:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx
static uint balloc(uint dev) {
801014cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
    for (b = 0; b < sb.size; b += BPB) {
801014d2:	85 c9                	test   %ecx,%ecx
801014d4:	0f 84 87 00 00 00    	je     80101561 <balloc+0xa1>
801014da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
        bp = bread(dev, BBLOCK(b, sb));
801014e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801014e4:	83 ec 08             	sub    $0x8,%esp
801014e7:	89 f0                	mov    %esi,%eax
801014e9:	c1 f8 0c             	sar    $0xc,%eax
801014ec:	03 05 4c 46 11 80    	add    0x8011464c,%eax
801014f2:	50                   	push   %eax
801014f3:	ff 75 d8             	push   -0x28(%ebp)
801014f6:	e8 d5 eb ff ff       	call   801000d0 <bread>
801014fb:	83 c4 10             	add    $0x10,%esp
801014fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
80101501:	a1 34 46 11 80       	mov    0x80114634,%eax
80101506:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101509:	31 c0                	xor    %eax,%eax
8010150b:	eb 2f                	jmp    8010153c <balloc+0x7c>
8010150d:	8d 76 00             	lea    0x0(%esi),%esi
            m = 1 << (bi % 8);
80101510:	89 c1                	mov    %eax,%ecx
80101512:	bb 01 00 00 00       	mov    $0x1,%ebx
            if ((bp->data[bi / 8] & m) == 0) { // Is block free?
80101517:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            m = 1 << (bi % 8);
8010151a:	83 e1 07             	and    $0x7,%ecx
8010151d:	d3 e3                	shl    %cl,%ebx
            if ((bp->data[bi / 8] & m) == 0) { // Is block free?
8010151f:	89 c1                	mov    %eax,%ecx
80101521:	c1 f9 03             	sar    $0x3,%ecx
80101524:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101529:	89 fa                	mov    %edi,%edx
8010152b:	85 df                	test   %ebx,%edi
8010152d:	74 41                	je     80101570 <balloc+0xb0>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
8010152f:	83 c0 01             	add    $0x1,%eax
80101532:	83 c6 01             	add    $0x1,%esi
80101535:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010153a:	74 05                	je     80101541 <balloc+0x81>
8010153c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010153f:	77 cf                	ja     80101510 <balloc+0x50>
        brelse(bp);
80101541:	83 ec 0c             	sub    $0xc,%esp
80101544:	ff 75 e4             	push   -0x1c(%ebp)
80101547:	e8 a4 ec ff ff       	call   801001f0 <brelse>
    for (b = 0; b < sb.size; b += BPB) {
8010154c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101553:	83 c4 10             	add    $0x10,%esp
80101556:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101559:	39 05 34 46 11 80    	cmp    %eax,0x80114634
8010155f:	77 80                	ja     801014e1 <balloc+0x21>
    panic("balloc: out of blocks");
80101561:	83 ec 0c             	sub    $0xc,%esp
80101564:	68 d2 7b 10 80       	push   $0x80107bd2
80101569:	e8 12 ef ff ff       	call   80100480 <panic>
8010156e:	66 90                	xchg   %ax,%ax
                bp->data[bi / 8] |= m;  // Mark block in use.
80101570:	8b 7d e4             	mov    -0x1c(%ebp),%edi
                log_write(bp);
80101573:	83 ec 0c             	sub    $0xc,%esp
                bp->data[bi / 8] |= m;  // Mark block in use.
80101576:	09 da                	or     %ebx,%edx
80101578:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
                log_write(bp);
8010157c:	57                   	push   %edi
8010157d:	e8 be 1e 00 00       	call   80103440 <log_write>
                brelse(bp);
80101582:	89 3c 24             	mov    %edi,(%esp)
80101585:	e8 66 ec ff ff       	call   801001f0 <brelse>
    bp = bread(dev, bno);
8010158a:	58                   	pop    %eax
8010158b:	5a                   	pop    %edx
8010158c:	56                   	push   %esi
8010158d:	ff 75 d8             	push   -0x28(%ebp)
80101590:	e8 3b eb ff ff       	call   801000d0 <bread>
    memset(bp->data, 0, BSIZE);
80101595:	83 c4 0c             	add    $0xc,%esp
    bp = bread(dev, bno);
80101598:	89 c3                	mov    %eax,%ebx
    memset(bp->data, 0, BSIZE);
8010159a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010159d:	68 00 02 00 00       	push   $0x200
801015a2:	6a 00                	push   $0x0
801015a4:	50                   	push   %eax
801015a5:	e8 f6 35 00 00       	call   80104ba0 <memset>
    log_write(bp);
801015aa:	89 1c 24             	mov    %ebx,(%esp)
801015ad:	e8 8e 1e 00 00       	call   80103440 <log_write>
    brelse(bp);
801015b2:	89 1c 24             	mov    %ebx,(%esp)
801015b5:	e8 36 ec ff ff       	call   801001f0 <brelse>
}
801015ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015bd:	89 f0                	mov    %esi,%eax
801015bf:	5b                   	pop    %ebx
801015c0:	5e                   	pop    %esi
801015c1:	5f                   	pop    %edi
801015c2:	5d                   	pop    %ebp
801015c3:	c3                   	ret    
801015c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015cf:	90                   	nop

801015d0 <iget>:
}

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode* iget(uint dev, uint inum) {
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	57                   	push   %edi
801015d4:	89 c7                	mov    %eax,%edi
801015d6:	56                   	push   %esi
    struct inode *ip, *empty;

    acquire(&icache.lock);

    // Is the inode already cached?
    empty = 0;
801015d7:	31 f6                	xor    %esi,%esi
static struct inode* iget(uint dev, uint inum) {
801015d9:	53                   	push   %ebx
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
801015da:	bb 14 2a 11 80       	mov    $0x80112a14,%ebx
static struct inode* iget(uint dev, uint inum) {
801015df:	83 ec 28             	sub    $0x28,%esp
801015e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    acquire(&icache.lock);
801015e5:	68 e0 29 11 80       	push   $0x801129e0
801015ea:	e8 f1 34 00 00       	call   80104ae0 <acquire>
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
801015ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    acquire(&icache.lock);
801015f2:	83 c4 10             	add    $0x10,%esp
801015f5:	eb 1b                	jmp    80101612 <iget+0x42>
801015f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015fe:	66 90                	xchg   %ax,%ax
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
80101600:	39 3b                	cmp    %edi,(%ebx)
80101602:	74 6c                	je     80101670 <iget+0xa0>
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101604:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010160a:	81 fb 34 46 11 80    	cmp    $0x80114634,%ebx
80101610:	73 26                	jae    80101638 <iget+0x68>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
80101612:	8b 43 08             	mov    0x8(%ebx),%eax
80101615:	85 c0                	test   %eax,%eax
80101617:	7f e7                	jg     80101600 <iget+0x30>
            ip->ref++;
            release(&icache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) {  // Remember empty slot.
80101619:	85 f6                	test   %esi,%esi
8010161b:	75 e7                	jne    80101604 <iget+0x34>
8010161d:	85 c0                	test   %eax,%eax
8010161f:	75 76                	jne    80101697 <iget+0xc7>
80101621:	89 de                	mov    %ebx,%esi
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101623:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101629:	81 fb 34 46 11 80    	cmp    $0x80114634,%ebx
8010162f:	72 e1                	jb     80101612 <iget+0x42>
80101631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            empty = ip;
        }
    }

    // Recycle an inode cache entry.
    if (empty == 0) {
80101638:	85 f6                	test   %esi,%esi
8010163a:	74 79                	je     801016b5 <iget+0xe5>
    ip = empty;
    ip->dev = dev;
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    release(&icache.lock);
8010163c:	83 ec 0c             	sub    $0xc,%esp
    ip->dev = dev;
8010163f:	89 3e                	mov    %edi,(%esi)
    ip->inum = inum;
80101641:	89 56 04             	mov    %edx,0x4(%esi)
    ip->ref = 1;
80101644:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    ip->valid = 0;
8010164b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
    release(&icache.lock);
80101652:	68 e0 29 11 80       	push   $0x801129e0
80101657:	e8 24 34 00 00       	call   80104a80 <release>

    return ip;
8010165c:	83 c4 10             	add    $0x10,%esp
}
8010165f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101662:	89 f0                	mov    %esi,%eax
80101664:	5b                   	pop    %ebx
80101665:	5e                   	pop    %esi
80101666:	5f                   	pop    %edi
80101667:	5d                   	pop    %ebp
80101668:	c3                   	ret    
80101669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
80101670:	39 53 04             	cmp    %edx,0x4(%ebx)
80101673:	75 8f                	jne    80101604 <iget+0x34>
            release(&icache.lock);
80101675:	83 ec 0c             	sub    $0xc,%esp
            ip->ref++;
80101678:	83 c0 01             	add    $0x1,%eax
            return ip;
8010167b:	89 de                	mov    %ebx,%esi
            release(&icache.lock);
8010167d:	68 e0 29 11 80       	push   $0x801129e0
            ip->ref++;
80101682:	89 43 08             	mov    %eax,0x8(%ebx)
            release(&icache.lock);
80101685:	e8 f6 33 00 00       	call   80104a80 <release>
            return ip;
8010168a:	83 c4 10             	add    $0x10,%esp
}
8010168d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101690:	89 f0                	mov    %esi,%eax
80101692:	5b                   	pop    %ebx
80101693:	5e                   	pop    %esi
80101694:	5f                   	pop    %edi
80101695:	5d                   	pop    %ebp
80101696:	c3                   	ret    
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101697:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010169d:	81 fb 34 46 11 80    	cmp    $0x80114634,%ebx
801016a3:	73 10                	jae    801016b5 <iget+0xe5>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
801016a5:	8b 43 08             	mov    0x8(%ebx),%eax
801016a8:	85 c0                	test   %eax,%eax
801016aa:	0f 8f 50 ff ff ff    	jg     80101600 <iget+0x30>
801016b0:	e9 68 ff ff ff       	jmp    8010161d <iget+0x4d>
        panic("iget: no inodes");
801016b5:	83 ec 0c             	sub    $0xc,%esp
801016b8:	68 e8 7b 10 80       	push   $0x80107be8
801016bd:	e8 be ed ff ff       	call   80100480 <panic>
801016c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801016d0 <bmap>:
// are listed in ip->addrs[].  The next NINDIRECT blocks are
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint bmap(struct inode *ip, uint bn) {
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	57                   	push   %edi
801016d4:	56                   	push   %esi
801016d5:	89 c6                	mov    %eax,%esi
801016d7:	53                   	push   %ebx
801016d8:	83 ec 1c             	sub    $0x1c,%esp
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT) {
801016db:	83 fa 0b             	cmp    $0xb,%edx
801016de:	0f 86 8c 00 00 00    	jbe    80101770 <bmap+0xa0>
        if ((addr = ip->addrs[bn]) == 0) {
            ip->addrs[bn] = addr = balloc(ip->dev);
        }
        return addr;
    }
    bn -= NDIRECT;
801016e4:	8d 5a f4             	lea    -0xc(%edx),%ebx

    if (bn < NINDIRECT) {
801016e7:	83 fb 7f             	cmp    $0x7f,%ebx
801016ea:	0f 87 a2 00 00 00    	ja     80101792 <bmap+0xc2>
        // Load indirect block, allocating if necessary.
        if ((addr = ip->addrs[NDIRECT]) == 0) {
801016f0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801016f6:	85 c0                	test   %eax,%eax
801016f8:	74 5e                	je     80101758 <bmap+0x88>
            ip->addrs[NDIRECT] = addr = balloc(ip->dev);
        }
        bp = bread(ip->dev, addr);
801016fa:	83 ec 08             	sub    $0x8,%esp
801016fd:	50                   	push   %eax
801016fe:	ff 36                	push   (%esi)
80101700:	e8 cb e9 ff ff       	call   801000d0 <bread>
        a = (uint*)bp->data;
        if ((addr = a[bn]) == 0) {
80101705:	83 c4 10             	add    $0x10,%esp
80101708:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
        bp = bread(ip->dev, addr);
8010170c:	89 c2                	mov    %eax,%edx
        if ((addr = a[bn]) == 0) {
8010170e:	8b 3b                	mov    (%ebx),%edi
80101710:	85 ff                	test   %edi,%edi
80101712:	74 1c                	je     80101730 <bmap+0x60>
            a[bn] = addr = balloc(ip->dev);
            log_write(bp);
        }
        brelse(bp);
80101714:	83 ec 0c             	sub    $0xc,%esp
80101717:	52                   	push   %edx
80101718:	e8 d3 ea ff ff       	call   801001f0 <brelse>
8010171d:	83 c4 10             	add    $0x10,%esp
        return addr;
    }

    panic("bmap: out of range");
}
80101720:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101723:	89 f8                	mov    %edi,%eax
80101725:	5b                   	pop    %ebx
80101726:	5e                   	pop    %esi
80101727:	5f                   	pop    %edi
80101728:	5d                   	pop    %ebp
80101729:	c3                   	ret    
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101730:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            a[bn] = addr = balloc(ip->dev);
80101733:	8b 06                	mov    (%esi),%eax
80101735:	e8 86 fd ff ff       	call   801014c0 <balloc>
            log_write(bp);
8010173a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010173d:	83 ec 0c             	sub    $0xc,%esp
            a[bn] = addr = balloc(ip->dev);
80101740:	89 03                	mov    %eax,(%ebx)
80101742:	89 c7                	mov    %eax,%edi
            log_write(bp);
80101744:	52                   	push   %edx
80101745:	e8 f6 1c 00 00       	call   80103440 <log_write>
8010174a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010174d:	83 c4 10             	add    $0x10,%esp
80101750:	eb c2                	jmp    80101714 <bmap+0x44>
80101752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101758:	8b 06                	mov    (%esi),%eax
8010175a:	e8 61 fd ff ff       	call   801014c0 <balloc>
8010175f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101765:	eb 93                	jmp    801016fa <bmap+0x2a>
80101767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010176e:	66 90                	xchg   %ax,%ax
        if ((addr = ip->addrs[bn]) == 0) {
80101770:	8d 5a 14             	lea    0x14(%edx),%ebx
80101773:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101777:	85 ff                	test   %edi,%edi
80101779:	75 a5                	jne    80101720 <bmap+0x50>
            ip->addrs[bn] = addr = balloc(ip->dev);
8010177b:	8b 00                	mov    (%eax),%eax
8010177d:	e8 3e fd ff ff       	call   801014c0 <balloc>
80101782:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101786:	89 c7                	mov    %eax,%edi
}
80101788:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010178b:	5b                   	pop    %ebx
8010178c:	89 f8                	mov    %edi,%eax
8010178e:	5e                   	pop    %esi
8010178f:	5f                   	pop    %edi
80101790:	5d                   	pop    %ebp
80101791:	c3                   	ret    
    panic("bmap: out of range");
80101792:	83 ec 0c             	sub    $0xc,%esp
80101795:	68 f8 7b 10 80       	push   $0x80107bf8
8010179a:	e8 e1 ec ff ff       	call   80100480 <panic>
8010179f:	90                   	nop

801017a0 <readsb>:
void readsb(int dev, struct superblock *sb) {
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 75 0c             	mov    0xc(%ebp),%esi
    bp = bread(dev, 1);
801017a8:	83 ec 08             	sub    $0x8,%esp
801017ab:	6a 01                	push   $0x1
801017ad:	ff 75 08             	push   0x8(%ebp)
801017b0:	e8 1b e9 ff ff       	call   801000d0 <bread>
    memmove(sb, bp->data, sizeof(*sb));
801017b5:	83 c4 0c             	add    $0xc,%esp
    bp = bread(dev, 1);
801017b8:	89 c3                	mov    %eax,%ebx
    memmove(sb, bp->data, sizeof(*sb));
801017ba:	8d 40 5c             	lea    0x5c(%eax),%eax
801017bd:	6a 1c                	push   $0x1c
801017bf:	50                   	push   %eax
801017c0:	56                   	push   %esi
801017c1:	e8 7a 34 00 00       	call   80104c40 <memmove>
    brelse(bp);
801017c6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801017c9:	83 c4 10             	add    $0x10,%esp
}
801017cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017cf:	5b                   	pop    %ebx
801017d0:	5e                   	pop    %esi
801017d1:	5d                   	pop    %ebp
    brelse(bp);
801017d2:	e9 19 ea ff ff       	jmp    801001f0 <brelse>
801017d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017de:	66 90                	xchg   %ax,%ax

801017e0 <iinit>:
void iinit(int dev) {
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	53                   	push   %ebx
801017e4:	bb 20 2a 11 80       	mov    $0x80112a20,%ebx
801017e9:	83 ec 0c             	sub    $0xc,%esp
    initlock(&icache.lock, "icache");
801017ec:	68 0b 7c 10 80       	push   $0x80107c0b
801017f1:	68 e0 29 11 80       	push   $0x801129e0
801017f6:	e8 15 31 00 00       	call   80104910 <initlock>
    for (i = 0; i < NINODE; i++) {
801017fb:	83 c4 10             	add    $0x10,%esp
801017fe:	66 90                	xchg   %ax,%ax
        initsleeplock(&icache.inode[i].lock, "inode");
80101800:	83 ec 08             	sub    $0x8,%esp
80101803:	68 12 7c 10 80       	push   $0x80107c12
80101808:	53                   	push   %ebx
    for (i = 0; i < NINODE; i++) {
80101809:	81 c3 90 00 00 00    	add    $0x90,%ebx
        initsleeplock(&icache.inode[i].lock, "inode");
8010180f:	e8 cc 2f 00 00       	call   801047e0 <initsleeplock>
    for (i = 0; i < NINODE; i++) {
80101814:	83 c4 10             	add    $0x10,%esp
80101817:	81 fb 40 46 11 80    	cmp    $0x80114640,%ebx
8010181d:	75 e1                	jne    80101800 <iinit+0x20>
    bp = bread(dev, 1);
8010181f:	83 ec 08             	sub    $0x8,%esp
80101822:	6a 01                	push   $0x1
80101824:	ff 75 08             	push   0x8(%ebp)
80101827:	e8 a4 e8 ff ff       	call   801000d0 <bread>
    memmove(sb, bp->data, sizeof(*sb));
8010182c:	83 c4 0c             	add    $0xc,%esp
    bp = bread(dev, 1);
8010182f:	89 c3                	mov    %eax,%ebx
    memmove(sb, bp->data, sizeof(*sb));
80101831:	8d 40 5c             	lea    0x5c(%eax),%eax
80101834:	6a 1c                	push   $0x1c
80101836:	50                   	push   %eax
80101837:	68 34 46 11 80       	push   $0x80114634
8010183c:	e8 ff 33 00 00       	call   80104c40 <memmove>
    brelse(bp);
80101841:	89 1c 24             	mov    %ebx,(%esp)
80101844:	e8 a7 e9 ff ff       	call   801001f0 <brelse>
    cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101849:	ff 35 4c 46 11 80    	push   0x8011464c
8010184f:	ff 35 48 46 11 80    	push   0x80114648
80101855:	ff 35 44 46 11 80    	push   0x80114644
8010185b:	ff 35 40 46 11 80    	push   0x80114640
80101861:	ff 35 3c 46 11 80    	push   0x8011463c
80101867:	ff 35 38 46 11 80    	push   0x80114638
8010186d:	ff 35 34 46 11 80    	push   0x80114634
80101873:	68 78 7c 10 80       	push   $0x80107c78
80101878:	e8 63 ef ff ff       	call   801007e0 <cprintf>
}
8010187d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101880:	83 c4 30             	add    $0x30,%esp
80101883:	c9                   	leave  
80101884:	c3                   	ret    
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <ialloc>:
struct inode* ialloc(uint dev, short type) {
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	57                   	push   %edi
80101894:	56                   	push   %esi
80101895:	53                   	push   %ebx
80101896:	83 ec 1c             	sub    $0x1c,%esp
80101899:	8b 45 0c             	mov    0xc(%ebp),%eax
    for (inum = 1; inum < sb.ninodes; inum++) {
8010189c:	83 3d 3c 46 11 80 01 	cmpl   $0x1,0x8011463c
struct inode* ialloc(uint dev, short type) {
801018a3:	8b 75 08             	mov    0x8(%ebp),%esi
801018a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (inum = 1; inum < sb.ninodes; inum++) {
801018a9:	0f 86 91 00 00 00    	jbe    80101940 <ialloc+0xb0>
801018af:	bf 01 00 00 00       	mov    $0x1,%edi
801018b4:	eb 21                	jmp    801018d7 <ialloc+0x47>
801018b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bd:	8d 76 00             	lea    0x0(%esi),%esi
        brelse(bp);
801018c0:	83 ec 0c             	sub    $0xc,%esp
    for (inum = 1; inum < sb.ninodes; inum++) {
801018c3:	83 c7 01             	add    $0x1,%edi
        brelse(bp);
801018c6:	53                   	push   %ebx
801018c7:	e8 24 e9 ff ff       	call   801001f0 <brelse>
    for (inum = 1; inum < sb.ninodes; inum++) {
801018cc:	83 c4 10             	add    $0x10,%esp
801018cf:	3b 3d 3c 46 11 80    	cmp    0x8011463c,%edi
801018d5:	73 69                	jae    80101940 <ialloc+0xb0>
        bp = bread(dev, IBLOCK(inum, sb));
801018d7:	89 f8                	mov    %edi,%eax
801018d9:	83 ec 08             	sub    $0x8,%esp
801018dc:	c1 e8 03             	shr    $0x3,%eax
801018df:	03 05 48 46 11 80    	add    0x80114648,%eax
801018e5:	50                   	push   %eax
801018e6:	56                   	push   %esi
801018e7:	e8 e4 e7 ff ff       	call   801000d0 <bread>
        if (dip->type == 0) { // a free inode
801018ec:	83 c4 10             	add    $0x10,%esp
        bp = bread(dev, IBLOCK(inum, sb));
801018ef:	89 c3                	mov    %eax,%ebx
        dip = (struct dinode*)bp->data + inum % IPB;
801018f1:	89 f8                	mov    %edi,%eax
801018f3:	83 e0 07             	and    $0x7,%eax
801018f6:	c1 e0 06             	shl    $0x6,%eax
801018f9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
        if (dip->type == 0) { // a free inode
801018fd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101901:	75 bd                	jne    801018c0 <ialloc+0x30>
            memset(dip, 0, sizeof(*dip));
80101903:	83 ec 04             	sub    $0x4,%esp
80101906:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101909:	6a 40                	push   $0x40
8010190b:	6a 00                	push   $0x0
8010190d:	51                   	push   %ecx
8010190e:	e8 8d 32 00 00       	call   80104ba0 <memset>
            dip->type = type;
80101913:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101917:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010191a:	66 89 01             	mov    %ax,(%ecx)
            log_write(bp);   // mark it allocated on the disk
8010191d:	89 1c 24             	mov    %ebx,(%esp)
80101920:	e8 1b 1b 00 00       	call   80103440 <log_write>
            brelse(bp);
80101925:	89 1c 24             	mov    %ebx,(%esp)
80101928:	e8 c3 e8 ff ff       	call   801001f0 <brelse>
            return iget(dev, inum);
8010192d:	83 c4 10             	add    $0x10,%esp
}
80101930:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return iget(dev, inum);
80101933:	89 fa                	mov    %edi,%edx
}
80101935:	5b                   	pop    %ebx
            return iget(dev, inum);
80101936:	89 f0                	mov    %esi,%eax
}
80101938:	5e                   	pop    %esi
80101939:	5f                   	pop    %edi
8010193a:	5d                   	pop    %ebp
            return iget(dev, inum);
8010193b:	e9 90 fc ff ff       	jmp    801015d0 <iget>
    panic("ialloc: no inodes");
80101940:	83 ec 0c             	sub    $0xc,%esp
80101943:	68 18 7c 10 80       	push   $0x80107c18
80101948:	e8 33 eb ff ff       	call   80100480 <panic>
8010194d:	8d 76 00             	lea    0x0(%esi),%esi

80101950 <iupdate>:
void iupdate(struct inode *ip) {
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	56                   	push   %esi
80101954:	53                   	push   %ebx
80101955:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101958:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010195b:	83 c3 5c             	add    $0x5c,%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010195e:	83 ec 08             	sub    $0x8,%esp
80101961:	c1 e8 03             	shr    $0x3,%eax
80101964:	03 05 48 46 11 80    	add    0x80114648,%eax
8010196a:	50                   	push   %eax
8010196b:	ff 73 a4             	push   -0x5c(%ebx)
8010196e:	e8 5d e7 ff ff       	call   801000d0 <bread>
    dip->type = ip->type;
80101973:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101977:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010197a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum % IPB;
8010197c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010197f:	83 e0 07             	and    $0x7,%eax
80101982:	c1 e0 06             	shl    $0x6,%eax
80101985:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    dip->type = ip->type;
80101989:	66 89 10             	mov    %dx,(%eax)
    dip->major = ip->major;
8010198c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101990:	83 c0 0c             	add    $0xc,%eax
    dip->major = ip->major;
80101993:	66 89 50 f6          	mov    %dx,-0xa(%eax)
    dip->minor = ip->minor;
80101997:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010199b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
    dip->nlink = ip->nlink;
8010199f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801019a3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
    dip->size = ip->size;
801019a7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801019aa:	89 50 fc             	mov    %edx,-0x4(%eax)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019ad:	6a 34                	push   $0x34
801019af:	53                   	push   %ebx
801019b0:	50                   	push   %eax
801019b1:	e8 8a 32 00 00       	call   80104c40 <memmove>
    log_write(bp);
801019b6:	89 34 24             	mov    %esi,(%esp)
801019b9:	e8 82 1a 00 00       	call   80103440 <log_write>
    brelse(bp);
801019be:	89 75 08             	mov    %esi,0x8(%ebp)
801019c1:	83 c4 10             	add    $0x10,%esp
}
801019c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019c7:	5b                   	pop    %ebx
801019c8:	5e                   	pop    %esi
801019c9:	5d                   	pop    %ebp
    brelse(bp);
801019ca:	e9 21 e8 ff ff       	jmp    801001f0 <brelse>
801019cf:	90                   	nop

801019d0 <idup>:
struct inode* idup(struct inode *ip) {
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	53                   	push   %ebx
801019d4:	83 ec 10             	sub    $0x10,%esp
801019d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&icache.lock);
801019da:	68 e0 29 11 80       	push   $0x801129e0
801019df:	e8 fc 30 00 00       	call   80104ae0 <acquire>
    ip->ref++;
801019e4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
    release(&icache.lock);
801019e8:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
801019ef:	e8 8c 30 00 00       	call   80104a80 <release>
}
801019f4:	89 d8                	mov    %ebx,%eax
801019f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019f9:	c9                   	leave  
801019fa:	c3                   	ret    
801019fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019ff:	90                   	nop

80101a00 <ilock>:
void ilock(struct inode *ip) {
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	56                   	push   %esi
80101a04:	53                   	push   %ebx
80101a05:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || ip->ref < 1) {
80101a08:	85 db                	test   %ebx,%ebx
80101a0a:	0f 84 b7 00 00 00    	je     80101ac7 <ilock+0xc7>
80101a10:	8b 53 08             	mov    0x8(%ebx),%edx
80101a13:	85 d2                	test   %edx,%edx
80101a15:	0f 8e ac 00 00 00    	jle    80101ac7 <ilock+0xc7>
    acquiresleep(&ip->lock);
80101a1b:	83 ec 0c             	sub    $0xc,%esp
80101a1e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101a21:	50                   	push   %eax
80101a22:	e8 f9 2d 00 00       	call   80104820 <acquiresleep>
    if (ip->valid == 0) {
80101a27:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	85 c0                	test   %eax,%eax
80101a2f:	74 0f                	je     80101a40 <ilock+0x40>
}
80101a31:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a34:	5b                   	pop    %ebx
80101a35:	5e                   	pop    %esi
80101a36:	5d                   	pop    %ebp
80101a37:	c3                   	ret    
80101a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a3f:	90                   	nop
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a40:	8b 43 04             	mov    0x4(%ebx),%eax
80101a43:	83 ec 08             	sub    $0x8,%esp
80101a46:	c1 e8 03             	shr    $0x3,%eax
80101a49:	03 05 48 46 11 80    	add    0x80114648,%eax
80101a4f:	50                   	push   %eax
80101a50:	ff 33                	push   (%ebx)
80101a52:	e8 79 e6 ff ff       	call   801000d0 <bread>
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a57:	83 c4 0c             	add    $0xc,%esp
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a5a:	89 c6                	mov    %eax,%esi
        dip = (struct dinode*)bp->data + ip->inum % IPB;
80101a5c:	8b 43 04             	mov    0x4(%ebx),%eax
80101a5f:	83 e0 07             	and    $0x7,%eax
80101a62:	c1 e0 06             	shl    $0x6,%eax
80101a65:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
        ip->type = dip->type;
80101a69:	0f b7 10             	movzwl (%eax),%edx
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a6c:	83 c0 0c             	add    $0xc,%eax
        ip->type = dip->type;
80101a6f:	66 89 53 50          	mov    %dx,0x50(%ebx)
        ip->major = dip->major;
80101a73:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101a77:	66 89 53 52          	mov    %dx,0x52(%ebx)
        ip->minor = dip->minor;
80101a7b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101a7f:	66 89 53 54          	mov    %dx,0x54(%ebx)
        ip->nlink = dip->nlink;
80101a83:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101a87:	66 89 53 56          	mov    %dx,0x56(%ebx)
        ip->size = dip->size;
80101a8b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101a8e:	89 53 58             	mov    %edx,0x58(%ebx)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a91:	6a 34                	push   $0x34
80101a93:	50                   	push   %eax
80101a94:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101a97:	50                   	push   %eax
80101a98:	e8 a3 31 00 00       	call   80104c40 <memmove>
        brelse(bp);
80101a9d:	89 34 24             	mov    %esi,(%esp)
80101aa0:	e8 4b e7 ff ff       	call   801001f0 <brelse>
        if (ip->type == 0) {
80101aa5:	83 c4 10             	add    $0x10,%esp
80101aa8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
        ip->valid = 1;
80101aad:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
        if (ip->type == 0) {
80101ab4:	0f 85 77 ff ff ff    	jne    80101a31 <ilock+0x31>
            panic("ilock: no type");
80101aba:	83 ec 0c             	sub    $0xc,%esp
80101abd:	68 30 7c 10 80       	push   $0x80107c30
80101ac2:	e8 b9 e9 ff ff       	call   80100480 <panic>
        panic("ilock");
80101ac7:	83 ec 0c             	sub    $0xc,%esp
80101aca:	68 2a 7c 10 80       	push   $0x80107c2a
80101acf:	e8 ac e9 ff ff       	call   80100480 <panic>
80101ad4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101adf:	90                   	nop

80101ae0 <iunlock>:
void iunlock(struct inode *ip) {
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	56                   	push   %esi
80101ae4:	53                   	push   %ebx
80101ae5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) {
80101ae8:	85 db                	test   %ebx,%ebx
80101aea:	74 28                	je     80101b14 <iunlock+0x34>
80101aec:	83 ec 0c             	sub    $0xc,%esp
80101aef:	8d 73 0c             	lea    0xc(%ebx),%esi
80101af2:	56                   	push   %esi
80101af3:	e8 c8 2d 00 00       	call   801048c0 <holdingsleep>
80101af8:	83 c4 10             	add    $0x10,%esp
80101afb:	85 c0                	test   %eax,%eax
80101afd:	74 15                	je     80101b14 <iunlock+0x34>
80101aff:	8b 43 08             	mov    0x8(%ebx),%eax
80101b02:	85 c0                	test   %eax,%eax
80101b04:	7e 0e                	jle    80101b14 <iunlock+0x34>
    releasesleep(&ip->lock);
80101b06:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101b09:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b0c:	5b                   	pop    %ebx
80101b0d:	5e                   	pop    %esi
80101b0e:	5d                   	pop    %ebp
    releasesleep(&ip->lock);
80101b0f:	e9 6c 2d 00 00       	jmp    80104880 <releasesleep>
        panic("iunlock");
80101b14:	83 ec 0c             	sub    $0xc,%esp
80101b17:	68 3f 7c 10 80       	push   $0x80107c3f
80101b1c:	e8 5f e9 ff ff       	call   80100480 <panic>
80101b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b2f:	90                   	nop

80101b30 <iput>:
void iput(struct inode *ip) {
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	57                   	push   %edi
80101b34:	56                   	push   %esi
80101b35:	53                   	push   %ebx
80101b36:	83 ec 28             	sub    $0x28,%esp
80101b39:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquiresleep(&ip->lock);
80101b3c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101b3f:	57                   	push   %edi
80101b40:	e8 db 2c 00 00       	call   80104820 <acquiresleep>
    if (ip->valid && ip->nlink == 0) {
80101b45:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101b48:	83 c4 10             	add    $0x10,%esp
80101b4b:	85 d2                	test   %edx,%edx
80101b4d:	74 07                	je     80101b56 <iput+0x26>
80101b4f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101b54:	74 32                	je     80101b88 <iput+0x58>
    releasesleep(&ip->lock);
80101b56:	83 ec 0c             	sub    $0xc,%esp
80101b59:	57                   	push   %edi
80101b5a:	e8 21 2d 00 00       	call   80104880 <releasesleep>
    acquire(&icache.lock);
80101b5f:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
80101b66:	e8 75 2f 00 00       	call   80104ae0 <acquire>
    ip->ref--;
80101b6b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
    release(&icache.lock);
80101b6f:	83 c4 10             	add    $0x10,%esp
80101b72:	c7 45 08 e0 29 11 80 	movl   $0x801129e0,0x8(%ebp)
}
80101b79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7c:	5b                   	pop    %ebx
80101b7d:	5e                   	pop    %esi
80101b7e:	5f                   	pop    %edi
80101b7f:	5d                   	pop    %ebp
    release(&icache.lock);
80101b80:	e9 fb 2e 00 00       	jmp    80104a80 <release>
80101b85:	8d 76 00             	lea    0x0(%esi),%esi
        acquire(&icache.lock);
80101b88:	83 ec 0c             	sub    $0xc,%esp
80101b8b:	68 e0 29 11 80       	push   $0x801129e0
80101b90:	e8 4b 2f 00 00       	call   80104ae0 <acquire>
        int r = ip->ref;
80101b95:	8b 73 08             	mov    0x8(%ebx),%esi
        release(&icache.lock);
80101b98:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
80101b9f:	e8 dc 2e 00 00       	call   80104a80 <release>
        if (r == 1) {
80101ba4:	83 c4 10             	add    $0x10,%esp
80101ba7:	83 fe 01             	cmp    $0x1,%esi
80101baa:	75 aa                	jne    80101b56 <iput+0x26>
80101bac:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101bb2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101bb5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101bb8:	89 cf                	mov    %ecx,%edi
80101bba:	eb 0b                	jmp    80101bc7 <iput+0x97>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void itrunc(struct inode *ip) {
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++) {
80101bc0:	83 c6 04             	add    $0x4,%esi
80101bc3:	39 fe                	cmp    %edi,%esi
80101bc5:	74 19                	je     80101be0 <iput+0xb0>
        if (ip->addrs[i]) {
80101bc7:	8b 16                	mov    (%esi),%edx
80101bc9:	85 d2                	test   %edx,%edx
80101bcb:	74 f3                	je     80101bc0 <iput+0x90>
            bfree(ip->dev, ip->addrs[i]);
80101bcd:	8b 03                	mov    (%ebx),%eax
80101bcf:	e8 6c f8 ff ff       	call   80101440 <bfree>
            ip->addrs[i] = 0;
80101bd4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101bda:	eb e4                	jmp    80101bc0 <iput+0x90>
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        }
    }

    if (ip->addrs[NDIRECT]) {
80101be0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101be6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101be9:	85 c0                	test   %eax,%eax
80101beb:	75 2d                	jne    80101c1a <iput+0xea>
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    iupdate(ip);
80101bed:	83 ec 0c             	sub    $0xc,%esp
    ip->size = 0;
80101bf0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    iupdate(ip);
80101bf7:	53                   	push   %ebx
80101bf8:	e8 53 fd ff ff       	call   80101950 <iupdate>
            ip->type = 0;
80101bfd:	31 c0                	xor    %eax,%eax
80101bff:	66 89 43 50          	mov    %ax,0x50(%ebx)
            iupdate(ip);
80101c03:	89 1c 24             	mov    %ebx,(%esp)
80101c06:	e8 45 fd ff ff       	call   80101950 <iupdate>
            ip->valid = 0;
80101c0b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	e9 3c ff ff ff       	jmp    80101b56 <iput+0x26>
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c1a:	83 ec 08             	sub    $0x8,%esp
80101c1d:	50                   	push   %eax
80101c1e:	ff 33                	push   (%ebx)
80101c20:	e8 ab e4 ff ff       	call   801000d0 <bread>
80101c25:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c28:	83 c4 10             	add    $0x10,%esp
80101c2b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101c31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < NINDIRECT; j++) {
80101c34:	8d 70 5c             	lea    0x5c(%eax),%esi
80101c37:	89 cf                	mov    %ecx,%edi
80101c39:	eb 0c                	jmp    80101c47 <iput+0x117>
80101c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c3f:	90                   	nop
80101c40:	83 c6 04             	add    $0x4,%esi
80101c43:	39 f7                	cmp    %esi,%edi
80101c45:	74 0f                	je     80101c56 <iput+0x126>
            if (a[j]) {
80101c47:	8b 16                	mov    (%esi),%edx
80101c49:	85 d2                	test   %edx,%edx
80101c4b:	74 f3                	je     80101c40 <iput+0x110>
                bfree(ip->dev, a[j]);
80101c4d:	8b 03                	mov    (%ebx),%eax
80101c4f:	e8 ec f7 ff ff       	call   80101440 <bfree>
80101c54:	eb ea                	jmp    80101c40 <iput+0x110>
        brelse(bp);
80101c56:	83 ec 0c             	sub    $0xc,%esp
80101c59:	ff 75 e4             	push   -0x1c(%ebp)
80101c5c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c5f:	e8 8c e5 ff ff       	call   801001f0 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
80101c64:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101c6a:	8b 03                	mov    (%ebx),%eax
80101c6c:	e8 cf f7 ff ff       	call   80101440 <bfree>
        ip->addrs[NDIRECT] = 0;
80101c71:	83 c4 10             	add    $0x10,%esp
80101c74:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101c7b:	00 00 00 
80101c7e:	e9 6a ff ff ff       	jmp    80101bed <iput+0xbd>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <iunlockput>:
void iunlockput(struct inode *ip) {
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	56                   	push   %esi
80101c94:	53                   	push   %ebx
80101c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) {
80101c98:	85 db                	test   %ebx,%ebx
80101c9a:	74 34                	je     80101cd0 <iunlockput+0x40>
80101c9c:	83 ec 0c             	sub    $0xc,%esp
80101c9f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ca2:	56                   	push   %esi
80101ca3:	e8 18 2c 00 00       	call   801048c0 <holdingsleep>
80101ca8:	83 c4 10             	add    $0x10,%esp
80101cab:	85 c0                	test   %eax,%eax
80101cad:	74 21                	je     80101cd0 <iunlockput+0x40>
80101caf:	8b 43 08             	mov    0x8(%ebx),%eax
80101cb2:	85 c0                	test   %eax,%eax
80101cb4:	7e 1a                	jle    80101cd0 <iunlockput+0x40>
    releasesleep(&ip->lock);
80101cb6:	83 ec 0c             	sub    $0xc,%esp
80101cb9:	56                   	push   %esi
80101cba:	e8 c1 2b 00 00       	call   80104880 <releasesleep>
    iput(ip);
80101cbf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101cc2:	83 c4 10             	add    $0x10,%esp
}
80101cc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101cc8:	5b                   	pop    %ebx
80101cc9:	5e                   	pop    %esi
80101cca:	5d                   	pop    %ebp
    iput(ip);
80101ccb:	e9 60 fe ff ff       	jmp    80101b30 <iput>
        panic("iunlock");
80101cd0:	83 ec 0c             	sub    $0xc,%esp
80101cd3:	68 3f 7c 10 80       	push   $0x80107c3f
80101cd8:	e8 a3 e7 ff ff       	call   80100480 <panic>
80101cdd:	8d 76 00             	lea    0x0(%esi),%esi

80101ce0 <stati>:
}

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
    st->dev = ip->dev;
80101ce9:	8b 0a                	mov    (%edx),%ecx
80101ceb:	89 48 04             	mov    %ecx,0x4(%eax)
    st->ino = ip->inum;
80101cee:	8b 4a 04             	mov    0x4(%edx),%ecx
80101cf1:	89 48 08             	mov    %ecx,0x8(%eax)
    st->type = ip->type;
80101cf4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101cf8:	66 89 08             	mov    %cx,(%eax)
    st->nlink = ip->nlink;
80101cfb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101cff:	66 89 48 0c          	mov    %cx,0xc(%eax)
    st->size = ip->size;
80101d03:	8b 52 58             	mov    0x58(%edx),%edx
80101d06:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d09:	5d                   	pop    %ebp
80101d0a:	c3                   	ret    
80101d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d0f:	90                   	nop

80101d10 <readi>:


// Read data from inode.
// Caller must hold ip->lock.
int readi(struct inode *ip, char *dst, uint off, uint n) {
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	57                   	push   %edi
80101d14:	56                   	push   %esi
80101d15:	53                   	push   %ebx
80101d16:	83 ec 1c             	sub    $0x1c,%esp
80101d19:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1f:	8b 75 10             	mov    0x10(%ebp),%esi
80101d22:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d25:	8b 7d 14             	mov    0x14(%ebp),%edi
    uint tot, m;
    struct buf *bp;

    if (ip->type == T_DEV) {
80101d28:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
int readi(struct inode *ip, char *dst, uint off, uint n) {
80101d2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d30:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    if (ip->type == T_DEV) {
80101d33:	0f 84 a7 00 00 00    	je     80101de0 <readi+0xd0>
            return -1;
        }
        return devsw[ip->major].read(ip, dst, n);
    }

    if (off > ip->size || off + n < off) {
80101d39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d3c:	8b 40 58             	mov    0x58(%eax),%eax
80101d3f:	39 c6                	cmp    %eax,%esi
80101d41:	0f 87 ba 00 00 00    	ja     80101e01 <readi+0xf1>
80101d47:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101d4a:	31 c9                	xor    %ecx,%ecx
80101d4c:	89 da                	mov    %ebx,%edx
80101d4e:	01 f2                	add    %esi,%edx
80101d50:	0f 92 c1             	setb   %cl
80101d53:	89 cf                	mov    %ecx,%edi
80101d55:	0f 82 a6 00 00 00    	jb     80101e01 <readi+0xf1>
        return -1;
    }
    if (off + n > ip->size) {
        n = ip->size - off;
80101d5b:	89 c1                	mov    %eax,%ecx
80101d5d:	29 f1                	sub    %esi,%ecx
80101d5f:	39 d0                	cmp    %edx,%eax
80101d61:	0f 43 cb             	cmovae %ebx,%ecx
80101d64:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    }

    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101d67:	85 c9                	test   %ecx,%ecx
80101d69:	74 67                	je     80101dd2 <readi+0xc2>
80101d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101d70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101d73:	89 f2                	mov    %esi,%edx
80101d75:	c1 ea 09             	shr    $0x9,%edx
80101d78:	89 d8                	mov    %ebx,%eax
80101d7a:	e8 51 f9 ff ff       	call   801016d0 <bmap>
80101d7f:	83 ec 08             	sub    $0x8,%esp
80101d82:	50                   	push   %eax
80101d83:	ff 33                	push   (%ebx)
80101d85:	e8 46 e3 ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
80101d8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101d8d:	b9 00 02 00 00       	mov    $0x200,%ecx
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101d92:	89 c2                	mov    %eax,%edx
        m = min(n - tot, BSIZE - off % BSIZE);
80101d94:	89 f0                	mov    %esi,%eax
80101d96:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d9b:	29 fb                	sub    %edi,%ebx
        memmove(dst, bp->data + off % BSIZE, m);
80101d9d:	89 55 dc             	mov    %edx,-0x24(%ebp)
        m = min(n - tot, BSIZE - off % BSIZE);
80101da0:	29 c1                	sub    %eax,%ecx
        memmove(dst, bp->data + off % BSIZE, m);
80101da2:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
        m = min(n - tot, BSIZE - off % BSIZE);
80101da6:	39 d9                	cmp    %ebx,%ecx
80101da8:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(dst, bp->data + off % BSIZE, m);
80101dab:	83 c4 0c             	add    $0xc,%esp
80101dae:	53                   	push   %ebx
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101daf:	01 df                	add    %ebx,%edi
80101db1:	01 de                	add    %ebx,%esi
        memmove(dst, bp->data + off % BSIZE, m);
80101db3:	50                   	push   %eax
80101db4:	ff 75 e0             	push   -0x20(%ebp)
80101db7:	e8 84 2e 00 00       	call   80104c40 <memmove>
        brelse(bp);
80101dbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dbf:	89 14 24             	mov    %edx,(%esp)
80101dc2:	e8 29 e4 ff ff       	call   801001f0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101dc7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101dca:	83 c4 10             	add    $0x10,%esp
80101dcd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101dd0:	77 9e                	ja     80101d70 <readi+0x60>
    }
    return n;
80101dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101dd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd8:	5b                   	pop    %ebx
80101dd9:	5e                   	pop    %esi
80101dda:	5f                   	pop    %edi
80101ddb:	5d                   	pop    %ebp
80101ddc:	c3                   	ret    
80101ddd:	8d 76 00             	lea    0x0(%esi),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read) {
80101de0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101de4:	66 83 f8 09          	cmp    $0x9,%ax
80101de8:	77 17                	ja     80101e01 <readi+0xf1>
80101dea:	8b 04 c5 80 29 11 80 	mov    -0x7feed680(,%eax,8),%eax
80101df1:	85 c0                	test   %eax,%eax
80101df3:	74 0c                	je     80101e01 <readi+0xf1>
        return devsw[ip->major].read(ip, dst, n);
80101df5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101df8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5f                   	pop    %edi
80101dfe:	5d                   	pop    %ebp
        return devsw[ip->major].read(ip, dst, n);
80101dff:	ff e0                	jmp    *%eax
            return -1;
80101e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e06:	eb cd                	jmp    80101dd5 <readi+0xc5>
80101e08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e0f:	90                   	nop

80101e10 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int writei(struct inode *ip, char *src, uint off, uint n) {
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 1c             	sub    $0x1c,%esp
80101e19:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e1f:	8b 55 14             	mov    0x14(%ebp),%edx
    uint tot, m;
    struct buf *bp;

    if (ip->type == T_DEV) {
80101e22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
int writei(struct inode *ip, char *src, uint off, uint n) {
80101e27:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101e2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101e30:	89 55 e0             	mov    %edx,-0x20(%ebp)
    if (ip->type == T_DEV) {
80101e33:	0f 84 b7 00 00 00    	je     80101ef0 <writei+0xe0>
            return -1;
        }
        return devsw[ip->major].write(ip, src, n);
    }

    if (off > ip->size || off + n < off) {
80101e39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e3f:	0f 87 e7 00 00 00    	ja     80101f2c <writei+0x11c>
80101e45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e48:	31 d2                	xor    %edx,%edx
80101e4a:	89 f8                	mov    %edi,%eax
80101e4c:	01 f0                	add    %esi,%eax
80101e4e:	0f 92 c2             	setb   %dl
        return -1;
    }
    if (off + n > MAXFILE * BSIZE) {
80101e51:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e56:	0f 87 d0 00 00 00    	ja     80101f2c <writei+0x11c>
80101e5c:	85 d2                	test   %edx,%edx
80101e5e:	0f 85 c8 00 00 00    	jne    80101f2c <writei+0x11c>
        return -1;
    }

    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101e64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101e6b:	85 ff                	test   %edi,%edi
80101e6d:	74 72                	je     80101ee1 <writei+0xd1>
80101e6f:	90                   	nop
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101e70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101e73:	89 f2                	mov    %esi,%edx
80101e75:	c1 ea 09             	shr    $0x9,%edx
80101e78:	89 f8                	mov    %edi,%eax
80101e7a:	e8 51 f8 ff ff       	call   801016d0 <bmap>
80101e7f:	83 ec 08             	sub    $0x8,%esp
80101e82:	50                   	push   %eax
80101e83:	ff 37                	push   (%edi)
80101e85:	e8 46 e2 ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
80101e8a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e8f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101e92:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101e95:	89 c7                	mov    %eax,%edi
        m = min(n - tot, BSIZE - off % BSIZE);
80101e97:	89 f0                	mov    %esi,%eax
80101e99:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e9e:	29 c1                	sub    %eax,%ecx
        memmove(bp->data + off % BSIZE, src, m);
80101ea0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
        m = min(n - tot, BSIZE - off % BSIZE);
80101ea4:	39 d9                	cmp    %ebx,%ecx
80101ea6:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(bp->data + off % BSIZE, src, m);
80101ea9:	83 c4 0c             	add    $0xc,%esp
80101eac:	53                   	push   %ebx
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101ead:	01 de                	add    %ebx,%esi
        memmove(bp->data + off % BSIZE, src, m);
80101eaf:	ff 75 dc             	push   -0x24(%ebp)
80101eb2:	50                   	push   %eax
80101eb3:	e8 88 2d 00 00       	call   80104c40 <memmove>
        log_write(bp);
80101eb8:	89 3c 24             	mov    %edi,(%esp)
80101ebb:	e8 80 15 00 00       	call   80103440 <log_write>
        brelse(bp);
80101ec0:	89 3c 24             	mov    %edi,(%esp)
80101ec3:	e8 28 e3 ff ff       	call   801001f0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101ec8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ecb:	83 c4 10             	add    $0x10,%esp
80101ece:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ed1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ed4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ed7:	77 97                	ja     80101e70 <writei+0x60>
    }

    if (n > 0 && off > ip->size) {
80101ed9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101edc:	3b 70 58             	cmp    0x58(%eax),%esi
80101edf:	77 37                	ja     80101f18 <writei+0x108>
        ip->size = off;
        iupdate(ip);
    }
    return n;
80101ee1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee7:	5b                   	pop    %ebx
80101ee8:	5e                   	pop    %esi
80101ee9:	5f                   	pop    %edi
80101eea:	5d                   	pop    %ebp
80101eeb:	c3                   	ret    
80101eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write) {
80101ef0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ef4:	66 83 f8 09          	cmp    $0x9,%ax
80101ef8:	77 32                	ja     80101f2c <writei+0x11c>
80101efa:	8b 04 c5 84 29 11 80 	mov    -0x7feed67c(,%eax,8),%eax
80101f01:	85 c0                	test   %eax,%eax
80101f03:	74 27                	je     80101f2c <writei+0x11c>
        return devsw[ip->major].write(ip, src, n);
80101f05:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0b:	5b                   	pop    %ebx
80101f0c:	5e                   	pop    %esi
80101f0d:	5f                   	pop    %edi
80101f0e:	5d                   	pop    %ebp
        return devsw[ip->major].write(ip, src, n);
80101f0f:	ff e0                	jmp    *%eax
80101f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        ip->size = off;
80101f18:	8b 45 d8             	mov    -0x28(%ebp),%eax
        iupdate(ip);
80101f1b:	83 ec 0c             	sub    $0xc,%esp
        ip->size = off;
80101f1e:	89 70 58             	mov    %esi,0x58(%eax)
        iupdate(ip);
80101f21:	50                   	push   %eax
80101f22:	e8 29 fa ff ff       	call   80101950 <iupdate>
80101f27:	83 c4 10             	add    $0x10,%esp
80101f2a:	eb b5                	jmp    80101ee1 <writei+0xd1>
            return -1;
80101f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f31:	eb b1                	jmp    80101ee4 <writei+0xd4>
80101f33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f40 <namecmp>:


// Directories

int namecmp(const char *s, const char *t) {
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	83 ec 0c             	sub    $0xc,%esp
    return strncmp(s, t, DIRSIZ);
80101f46:	6a 0e                	push   $0xe
80101f48:	ff 75 0c             	push   0xc(%ebp)
80101f4b:	ff 75 08             	push   0x8(%ebp)
80101f4e:	e8 5d 2d 00 00       	call   80104cb0 <strncmp>
}
80101f53:	c9                   	leave  
80101f54:	c3                   	ret    
80101f55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode* dirlookup(struct inode *dp, char *name, uint *poff) {
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	57                   	push   %edi
80101f64:	56                   	push   %esi
80101f65:	53                   	push   %ebx
80101f66:	83 ec 1c             	sub    $0x1c,%esp
80101f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR) {
80101f6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101f71:	0f 85 85 00 00 00    	jne    80101ffc <dirlookup+0x9c>
        panic("dirlookup not DIR");
    }

    for (off = 0; off < dp->size; off += sizeof(de)) {
80101f77:	8b 53 58             	mov    0x58(%ebx),%edx
80101f7a:	31 ff                	xor    %edi,%edi
80101f7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f7f:	85 d2                	test   %edx,%edx
80101f81:	74 3e                	je     80101fc1 <dirlookup+0x61>
80101f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f87:	90                   	nop
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80101f88:	6a 10                	push   $0x10
80101f8a:	57                   	push   %edi
80101f8b:	56                   	push   %esi
80101f8c:	53                   	push   %ebx
80101f8d:	e8 7e fd ff ff       	call   80101d10 <readi>
80101f92:	83 c4 10             	add    $0x10,%esp
80101f95:	83 f8 10             	cmp    $0x10,%eax
80101f98:	75 55                	jne    80101fef <dirlookup+0x8f>
            panic("dirlookup read");
        }
        if (de.inum == 0) {
80101f9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f9f:	74 18                	je     80101fb9 <dirlookup+0x59>
    return strncmp(s, t, DIRSIZ);
80101fa1:	83 ec 04             	sub    $0x4,%esp
80101fa4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fa7:	6a 0e                	push   $0xe
80101fa9:	50                   	push   %eax
80101faa:	ff 75 0c             	push   0xc(%ebp)
80101fad:	e8 fe 2c 00 00       	call   80104cb0 <strncmp>
            continue;
        }
        if (namecmp(name, de.name) == 0) {
80101fb2:	83 c4 10             	add    $0x10,%esp
80101fb5:	85 c0                	test   %eax,%eax
80101fb7:	74 17                	je     80101fd0 <dirlookup+0x70>
    for (off = 0; off < dp->size; off += sizeof(de)) {
80101fb9:	83 c7 10             	add    $0x10,%edi
80101fbc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fbf:	72 c7                	jb     80101f88 <dirlookup+0x28>
            return iget(dp->dev, inum);
        }
    }

    return 0;
}
80101fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80101fc4:	31 c0                	xor    %eax,%eax
}
80101fc6:	5b                   	pop    %ebx
80101fc7:	5e                   	pop    %esi
80101fc8:	5f                   	pop    %edi
80101fc9:	5d                   	pop    %ebp
80101fca:	c3                   	ret    
80101fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fcf:	90                   	nop
            if (poff) {
80101fd0:	8b 45 10             	mov    0x10(%ebp),%eax
80101fd3:	85 c0                	test   %eax,%eax
80101fd5:	74 05                	je     80101fdc <dirlookup+0x7c>
                *poff = off;
80101fd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101fda:	89 38                	mov    %edi,(%eax)
            inum = de.inum;
80101fdc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
            return iget(dp->dev, inum);
80101fe0:	8b 03                	mov    (%ebx),%eax
80101fe2:	e8 e9 f5 ff ff       	call   801015d0 <iget>
}
80101fe7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fea:	5b                   	pop    %ebx
80101feb:	5e                   	pop    %esi
80101fec:	5f                   	pop    %edi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
            panic("dirlookup read");
80101fef:	83 ec 0c             	sub    $0xc,%esp
80101ff2:	68 59 7c 10 80       	push   $0x80107c59
80101ff7:	e8 84 e4 ff ff       	call   80100480 <panic>
        panic("dirlookup not DIR");
80101ffc:	83 ec 0c             	sub    $0xc,%esp
80101fff:	68 47 7c 10 80       	push   $0x80107c47
80102004:	e8 77 e4 ff ff       	call   80100480 <panic>
80102009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102010 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode* namex(char *path, int nameiparent, char *name)                     {
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	57                   	push   %edi
80102014:	56                   	push   %esi
80102015:	53                   	push   %ebx
80102016:	89 c3                	mov    %eax,%ebx
80102018:	83 ec 1c             	sub    $0x1c,%esp
    struct inode *ip, *next;

    if (*path == '/') {
8010201b:	80 38 2f             	cmpb   $0x2f,(%eax)
static struct inode* namex(char *path, int nameiparent, char *name)                     {
8010201e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102021:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    if (*path == '/') {
80102024:	0f 84 64 01 00 00    	je     8010218e <namex+0x17e>
        ip = iget(ROOTDEV, ROOTINO);
    }
    else {
        ip = idup(myproc()->cwd);
8010202a:	e8 81 1e 00 00       	call   80103eb0 <myproc>
    acquire(&icache.lock);
8010202f:	83 ec 0c             	sub    $0xc,%esp
        ip = idup(myproc()->cwd);
80102032:	8b 70 68             	mov    0x68(%eax),%esi
    acquire(&icache.lock);
80102035:	68 e0 29 11 80       	push   $0x801129e0
8010203a:	e8 a1 2a 00 00       	call   80104ae0 <acquire>
    ip->ref++;
8010203f:	83 46 08 01          	addl   $0x1,0x8(%esi)
    release(&icache.lock);
80102043:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
8010204a:	e8 31 2a 00 00       	call   80104a80 <release>
8010204f:	83 c4 10             	add    $0x10,%esp
80102052:	eb 07                	jmp    8010205b <namex+0x4b>
80102054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        path++;
80102058:	83 c3 01             	add    $0x1,%ebx
    while (*path == '/') {
8010205b:	0f b6 03             	movzbl (%ebx),%eax
8010205e:	3c 2f                	cmp    $0x2f,%al
80102060:	74 f6                	je     80102058 <namex+0x48>
    if (*path == 0) {
80102062:	84 c0                	test   %al,%al
80102064:	0f 84 06 01 00 00    	je     80102170 <namex+0x160>
    while (*path != '/' && *path != 0) {
8010206a:	0f b6 03             	movzbl (%ebx),%eax
8010206d:	84 c0                	test   %al,%al
8010206f:	0f 84 10 01 00 00    	je     80102185 <namex+0x175>
80102075:	89 df                	mov    %ebx,%edi
80102077:	3c 2f                	cmp    $0x2f,%al
80102079:	0f 84 06 01 00 00    	je     80102185 <namex+0x175>
8010207f:	90                   	nop
80102080:	0f b6 47 01          	movzbl 0x1(%edi),%eax
        path++;
80102084:	83 c7 01             	add    $0x1,%edi
    while (*path != '/' && *path != 0) {
80102087:	3c 2f                	cmp    $0x2f,%al
80102089:	74 04                	je     8010208f <namex+0x7f>
8010208b:	84 c0                	test   %al,%al
8010208d:	75 f1                	jne    80102080 <namex+0x70>
    len = path - s;
8010208f:	89 f8                	mov    %edi,%eax
80102091:	29 d8                	sub    %ebx,%eax
    if (len >= DIRSIZ) {
80102093:	83 f8 0d             	cmp    $0xd,%eax
80102096:	0f 8e ac 00 00 00    	jle    80102148 <namex+0x138>
        memmove(name, s, DIRSIZ);
8010209c:	83 ec 04             	sub    $0x4,%esp
8010209f:	6a 0e                	push   $0xe
801020a1:	53                   	push   %ebx
        path++;
801020a2:	89 fb                	mov    %edi,%ebx
        memmove(name, s, DIRSIZ);
801020a4:	ff 75 e4             	push   -0x1c(%ebp)
801020a7:	e8 94 2b 00 00       	call   80104c40 <memmove>
801020ac:	83 c4 10             	add    $0x10,%esp
    while (*path == '/') {
801020af:	80 3f 2f             	cmpb   $0x2f,(%edi)
801020b2:	75 0c                	jne    801020c0 <namex+0xb0>
801020b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        path++;
801020b8:	83 c3 01             	add    $0x1,%ebx
    while (*path == '/') {
801020bb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801020be:	74 f8                	je     801020b8 <namex+0xa8>
    }

    while ((path = skipelem(path, name)) != 0) {
        ilock(ip);
801020c0:	83 ec 0c             	sub    $0xc,%esp
801020c3:	56                   	push   %esi
801020c4:	e8 37 f9 ff ff       	call   80101a00 <ilock>
        if (ip->type != T_DIR) {
801020c9:	83 c4 10             	add    $0x10,%esp
801020cc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801020d1:	0f 85 cd 00 00 00    	jne    801021a4 <namex+0x194>
            iunlockput(ip);
            return 0;
        }
        if (nameiparent && *path == '\0') {
801020d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801020da:	85 c0                	test   %eax,%eax
801020dc:	74 09                	je     801020e7 <namex+0xd7>
801020de:	80 3b 00             	cmpb   $0x0,(%ebx)
801020e1:	0f 84 22 01 00 00    	je     80102209 <namex+0x1f9>
            // Stop one level early.
            iunlock(ip);
            return ip;
        }
        if ((next = dirlookup(ip, name, 0)) == 0) {
801020e7:	83 ec 04             	sub    $0x4,%esp
801020ea:	6a 00                	push   $0x0
801020ec:	ff 75 e4             	push   -0x1c(%ebp)
801020ef:	56                   	push   %esi
801020f0:	e8 6b fe ff ff       	call   80101f60 <dirlookup>
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) {
801020f5:	8d 56 0c             	lea    0xc(%esi),%edx
        if ((next = dirlookup(ip, name, 0)) == 0) {
801020f8:	83 c4 10             	add    $0x10,%esp
801020fb:	89 c7                	mov    %eax,%edi
801020fd:	85 c0                	test   %eax,%eax
801020ff:	0f 84 e1 00 00 00    	je     801021e6 <namex+0x1d6>
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) {
80102105:	83 ec 0c             	sub    $0xc,%esp
80102108:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010210b:	52                   	push   %edx
8010210c:	e8 af 27 00 00       	call   801048c0 <holdingsleep>
80102111:	83 c4 10             	add    $0x10,%esp
80102114:	85 c0                	test   %eax,%eax
80102116:	0f 84 30 01 00 00    	je     8010224c <namex+0x23c>
8010211c:	8b 56 08             	mov    0x8(%esi),%edx
8010211f:	85 d2                	test   %edx,%edx
80102121:	0f 8e 25 01 00 00    	jle    8010224c <namex+0x23c>
    releasesleep(&ip->lock);
80102127:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010212a:	83 ec 0c             	sub    $0xc,%esp
8010212d:	52                   	push   %edx
8010212e:	e8 4d 27 00 00       	call   80104880 <releasesleep>
    iput(ip);
80102133:	89 34 24             	mov    %esi,(%esp)
80102136:	89 fe                	mov    %edi,%esi
80102138:	e8 f3 f9 ff ff       	call   80101b30 <iput>
8010213d:	83 c4 10             	add    $0x10,%esp
80102140:	e9 16 ff ff ff       	jmp    8010205b <namex+0x4b>
80102145:	8d 76 00             	lea    0x0(%esi),%esi
        name[len] = 0;
80102148:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010214b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
        memmove(name, s, len);
8010214e:	83 ec 04             	sub    $0x4,%esp
80102151:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102154:	50                   	push   %eax
80102155:	53                   	push   %ebx
        name[len] = 0;
80102156:	89 fb                	mov    %edi,%ebx
        memmove(name, s, len);
80102158:	ff 75 e4             	push   -0x1c(%ebp)
8010215b:	e8 e0 2a 00 00       	call   80104c40 <memmove>
        name[len] = 0;
80102160:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102163:	83 c4 10             	add    $0x10,%esp
80102166:	c6 02 00             	movb   $0x0,(%edx)
80102169:	e9 41 ff ff ff       	jmp    801020af <namex+0x9f>
8010216e:	66 90                	xchg   %ax,%ax
            return 0;
        }
        iunlockput(ip);
        ip = next;
    }
    if (nameiparent) {
80102170:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102173:	85 c0                	test   %eax,%eax
80102175:	0f 85 be 00 00 00    	jne    80102239 <namex+0x229>
        iput(ip);
        return 0;
    }
    return ip;
}
8010217b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217e:	89 f0                	mov    %esi,%eax
80102180:	5b                   	pop    %ebx
80102181:	5e                   	pop    %esi
80102182:	5f                   	pop    %edi
80102183:	5d                   	pop    %ebp
80102184:	c3                   	ret    
    while (*path != '/' && *path != 0) {
80102185:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102188:	89 df                	mov    %ebx,%edi
8010218a:	31 c0                	xor    %eax,%eax
8010218c:	eb c0                	jmp    8010214e <namex+0x13e>
        ip = iget(ROOTDEV, ROOTINO);
8010218e:	ba 01 00 00 00       	mov    $0x1,%edx
80102193:	b8 01 00 00 00       	mov    $0x1,%eax
80102198:	e8 33 f4 ff ff       	call   801015d0 <iget>
8010219d:	89 c6                	mov    %eax,%esi
8010219f:	e9 b7 fe ff ff       	jmp    8010205b <namex+0x4b>
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) {
801021a4:	83 ec 0c             	sub    $0xc,%esp
801021a7:	8d 5e 0c             	lea    0xc(%esi),%ebx
801021aa:	53                   	push   %ebx
801021ab:	e8 10 27 00 00       	call   801048c0 <holdingsleep>
801021b0:	83 c4 10             	add    $0x10,%esp
801021b3:	85 c0                	test   %eax,%eax
801021b5:	0f 84 91 00 00 00    	je     8010224c <namex+0x23c>
801021bb:	8b 46 08             	mov    0x8(%esi),%eax
801021be:	85 c0                	test   %eax,%eax
801021c0:	0f 8e 86 00 00 00    	jle    8010224c <namex+0x23c>
    releasesleep(&ip->lock);
801021c6:	83 ec 0c             	sub    $0xc,%esp
801021c9:	53                   	push   %ebx
801021ca:	e8 b1 26 00 00       	call   80104880 <releasesleep>
    iput(ip);
801021cf:	89 34 24             	mov    %esi,(%esp)
            return 0;
801021d2:	31 f6                	xor    %esi,%esi
    iput(ip);
801021d4:	e8 57 f9 ff ff       	call   80101b30 <iput>
            return 0;
801021d9:	83 c4 10             	add    $0x10,%esp
}
801021dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021df:	89 f0                	mov    %esi,%eax
801021e1:	5b                   	pop    %ebx
801021e2:	5e                   	pop    %esi
801021e3:	5f                   	pop    %edi
801021e4:	5d                   	pop    %ebp
801021e5:	c3                   	ret    
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) {
801021e6:	83 ec 0c             	sub    $0xc,%esp
801021e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801021ec:	52                   	push   %edx
801021ed:	e8 ce 26 00 00       	call   801048c0 <holdingsleep>
801021f2:	83 c4 10             	add    $0x10,%esp
801021f5:	85 c0                	test   %eax,%eax
801021f7:	74 53                	je     8010224c <namex+0x23c>
801021f9:	8b 4e 08             	mov    0x8(%esi),%ecx
801021fc:	85 c9                	test   %ecx,%ecx
801021fe:	7e 4c                	jle    8010224c <namex+0x23c>
    releasesleep(&ip->lock);
80102200:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102203:	83 ec 0c             	sub    $0xc,%esp
80102206:	52                   	push   %edx
80102207:	eb c1                	jmp    801021ca <namex+0x1ba>
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) {
80102209:	83 ec 0c             	sub    $0xc,%esp
8010220c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010220f:	53                   	push   %ebx
80102210:	e8 ab 26 00 00       	call   801048c0 <holdingsleep>
80102215:	83 c4 10             	add    $0x10,%esp
80102218:	85 c0                	test   %eax,%eax
8010221a:	74 30                	je     8010224c <namex+0x23c>
8010221c:	8b 7e 08             	mov    0x8(%esi),%edi
8010221f:	85 ff                	test   %edi,%edi
80102221:	7e 29                	jle    8010224c <namex+0x23c>
    releasesleep(&ip->lock);
80102223:	83 ec 0c             	sub    $0xc,%esp
80102226:	53                   	push   %ebx
80102227:	e8 54 26 00 00       	call   80104880 <releasesleep>
}
8010222c:	83 c4 10             	add    $0x10,%esp
}
8010222f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102232:	89 f0                	mov    %esi,%eax
80102234:	5b                   	pop    %ebx
80102235:	5e                   	pop    %esi
80102236:	5f                   	pop    %edi
80102237:	5d                   	pop    %ebp
80102238:	c3                   	ret    
        iput(ip);
80102239:	83 ec 0c             	sub    $0xc,%esp
8010223c:	56                   	push   %esi
        return 0;
8010223d:	31 f6                	xor    %esi,%esi
        iput(ip);
8010223f:	e8 ec f8 ff ff       	call   80101b30 <iput>
        return 0;
80102244:	83 c4 10             	add    $0x10,%esp
80102247:	e9 2f ff ff ff       	jmp    8010217b <namex+0x16b>
        panic("iunlock");
8010224c:	83 ec 0c             	sub    $0xc,%esp
8010224f:	68 3f 7c 10 80       	push   $0x80107c3f
80102254:	e8 27 e2 ff ff       	call   80100480 <panic>
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102260 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	57                   	push   %edi
80102264:	56                   	push   %esi
80102265:	53                   	push   %ebx
80102266:	83 ec 20             	sub    $0x20,%esp
80102269:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if ((ip = dirlookup(dp, name, 0)) != 0) {
8010226c:	6a 00                	push   $0x0
8010226e:	ff 75 0c             	push   0xc(%ebp)
80102271:	53                   	push   %ebx
80102272:	e8 e9 fc ff ff       	call   80101f60 <dirlookup>
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	85 c0                	test   %eax,%eax
8010227c:	75 67                	jne    801022e5 <dirlink+0x85>
    for (off = 0; off < dp->size; off += sizeof(de)) {
8010227e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102281:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102284:	85 ff                	test   %edi,%edi
80102286:	74 29                	je     801022b1 <dirlink+0x51>
80102288:	31 ff                	xor    %edi,%edi
8010228a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010228d:	eb 09                	jmp    80102298 <dirlink+0x38>
8010228f:	90                   	nop
80102290:	83 c7 10             	add    $0x10,%edi
80102293:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102296:	73 19                	jae    801022b1 <dirlink+0x51>
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80102298:	6a 10                	push   $0x10
8010229a:	57                   	push   %edi
8010229b:	56                   	push   %esi
8010229c:	53                   	push   %ebx
8010229d:	e8 6e fa ff ff       	call   80101d10 <readi>
801022a2:	83 c4 10             	add    $0x10,%esp
801022a5:	83 f8 10             	cmp    $0x10,%eax
801022a8:	75 4e                	jne    801022f8 <dirlink+0x98>
        if (de.inum == 0) {
801022aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801022af:	75 df                	jne    80102290 <dirlink+0x30>
    strncpy(de.name, name, DIRSIZ);
801022b1:	83 ec 04             	sub    $0x4,%esp
801022b4:	8d 45 da             	lea    -0x26(%ebp),%eax
801022b7:	6a 0e                	push   $0xe
801022b9:	ff 75 0c             	push   0xc(%ebp)
801022bc:	50                   	push   %eax
801022bd:	e8 3e 2a 00 00       	call   80104d00 <strncpy>
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
801022c2:	6a 10                	push   $0x10
    de.inum = inum;
801022c4:	8b 45 10             	mov    0x10(%ebp),%eax
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
801022c7:	57                   	push   %edi
801022c8:	56                   	push   %esi
801022c9:	53                   	push   %ebx
    de.inum = inum;
801022ca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
801022ce:	e8 3d fb ff ff       	call   80101e10 <writei>
801022d3:	83 c4 20             	add    $0x20,%esp
801022d6:	83 f8 10             	cmp    $0x10,%eax
801022d9:	75 2a                	jne    80102305 <dirlink+0xa5>
    return 0;
801022db:	31 c0                	xor    %eax,%eax
}
801022dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e0:	5b                   	pop    %ebx
801022e1:	5e                   	pop    %esi
801022e2:	5f                   	pop    %edi
801022e3:	5d                   	pop    %ebp
801022e4:	c3                   	ret    
        iput(ip);
801022e5:	83 ec 0c             	sub    $0xc,%esp
801022e8:	50                   	push   %eax
801022e9:	e8 42 f8 ff ff       	call   80101b30 <iput>
        return -1;
801022ee:	83 c4 10             	add    $0x10,%esp
801022f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022f6:	eb e5                	jmp    801022dd <dirlink+0x7d>
            panic("dirlink read");
801022f8:	83 ec 0c             	sub    $0xc,%esp
801022fb:	68 68 7c 10 80       	push   $0x80107c68
80102300:	e8 7b e1 ff ff       	call   80100480 <panic>
        panic("dirlink");
80102305:	83 ec 0c             	sub    $0xc,%esp
80102308:	68 52 82 10 80       	push   $0x80108252
8010230d:	e8 6e e1 ff ff       	call   80100480 <panic>
80102312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102320 <namei>:

struct inode* namei(char *path) {
80102320:	55                   	push   %ebp
    char name[DIRSIZ];
    return namex(path, 0, name);
80102321:	31 d2                	xor    %edx,%edx
struct inode* namei(char *path) {
80102323:	89 e5                	mov    %esp,%ebp
80102325:	83 ec 18             	sub    $0x18,%esp
    return namex(path, 0, name);
80102328:	8b 45 08             	mov    0x8(%ebp),%eax
8010232b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010232e:	e8 dd fc ff ff       	call   80102010 <namex>
}
80102333:	c9                   	leave  
80102334:	c3                   	ret    
80102335:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102340 <nameiparent>:

struct inode*nameiparent(char *path, char *name) {
80102340:	55                   	push   %ebp
    return namex(path, 1, name);
80102341:	ba 01 00 00 00       	mov    $0x1,%edx
struct inode*nameiparent(char *path, char *name) {
80102346:	89 e5                	mov    %esp,%ebp
    return namex(path, 1, name);
80102348:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010234b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010234e:	5d                   	pop    %ebp
    return namex(path, 1, name);
8010234f:	e9 bc fc ff ff       	jmp    80102010 <namex>
80102354:	66 90                	xchg   %ax,%ax
80102356:	66 90                	xchg   %ax,%ax
80102358:	66 90                	xchg   %ax,%ax
8010235a:	66 90                	xchg   %ax,%ax
8010235c:	66 90                	xchg   %ax,%ax
8010235e:	66 90                	xchg   %ax,%ax

80102360 <clear320x200x256>:
	int colour;			// Brush colour
	int isPressed;      // is Drawing
	
} brushinfo;;

void clear320x200x256() {
80102360:	b8 00 00 0a 00       	mov    $0xa0000,%eax
80102365:	8d 76 00             	lea    0x0(%esi),%esi

	unsigned short* video_memory = (unsigned short*)0xA0000;

	int i;
	for (i=0; i<sizeof(cons_videobuffer.videobuffer); ++i){
		video_memory[i]=0;
80102368:	31 d2                	xor    %edx,%edx
	for (i=0; i<sizeof(cons_videobuffer.videobuffer); ++i){
8010236a:	83 c0 02             	add    $0x2,%eax
		video_memory[i]=0;
8010236d:	66 89 50 fe          	mov    %dx,-0x2(%eax)
	for (i=0; i<sizeof(cons_videobuffer.videobuffer); ++i){
80102371:	3d 00 e8 0d 00       	cmp    $0xde800,%eax
80102376:	75 f0                	jne    80102368 <clear320x200x256+0x8>
	}

	return;

}
80102378:	c3                   	ret    
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102380 <sys_setpixel>:


int sys_setpixel(void) {
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	83 ec 20             	sub    $0x20,%esp
	int uX;
	int uY;

	if (argint(1, &uX) < 0 || argint(2, &uY) < 0) {
80102386:	8d 45 f0             	lea    -0x10(%ebp),%eax
80102389:	50                   	push   %eax
8010238a:	6a 01                	push   $0x1
8010238c:	e8 cf 2a 00 00       	call   80104e60 <argint>
80102391:	83 c4 10             	add    $0x10,%esp
80102394:	85 c0                	test   %eax,%eax
80102396:	78 38                	js     801023d0 <sys_setpixel+0x50>
80102398:	83 ec 08             	sub    $0x8,%esp
8010239b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010239e:	50                   	push   %eax
8010239f:	6a 02                	push   $0x2
801023a1:	e8 ba 2a 00 00       	call   80104e60 <argint>
801023a6:	83 c4 10             	add    $0x10,%esp
801023a9:	85 c0                	test   %eax,%eax
801023ab:	78 23                	js     801023d0 <sys_setpixel+0x50>
		return -1;
	}

	unsigned short *video_memory = (unsigned short*)0xA0000;
	int index = uY * 320 + uX;
801023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
	video_memory[index] = brushinfo.colour;
801023b0:	8b 15 58 46 11 80    	mov    0x80114658,%edx
801023b6:	8d 04 80             	lea    (%eax,%eax,4),%eax
801023b9:	c1 e0 06             	shl    $0x6,%eax
801023bc:	03 45 f0             	add    -0x10(%ebp),%eax
801023bf:	66 89 94 00 00 00 0a 	mov    %dx,0xa0000(%eax,%eax,1)
801023c6:	00 


	return 1;
801023c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
801023cc:	c9                   	leave  
801023cd:	c3                   	ret    
801023ce:	66 90                	xchg   %ax,%ax
801023d0:	c9                   	leave  
		return -1;
801023d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801023d6:	c3                   	ret    
801023d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023de:	66 90                	xchg   %ax,%ax

801023e0 <sys_moveto>:

int sys_moveto(void) {
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	83 ec 20             	sub    $0x20,%esp
	int uX;
	int uY;

	if (argint(1, &uX) < 0 || argint(2, &uY) < 0) {
801023e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801023e9:	50                   	push   %eax
801023ea:	6a 01                	push   $0x1
801023ec:	e8 6f 2a 00 00       	call   80104e60 <argint>
801023f1:	83 c4 10             	add    $0x10,%esp
801023f4:	85 c0                	test   %eax,%eax
801023f6:	78 30                	js     80102428 <sys_moveto+0x48>
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801023fe:	50                   	push   %eax
801023ff:	6a 02                	push   $0x2
80102401:	e8 5a 2a 00 00       	call   80104e60 <argint>
80102406:	83 c4 10             	add    $0x10,%esp
80102409:	85 c0                	test   %eax,%eax
8010240b:	78 1b                	js     80102428 <sys_moveto+0x48>
		return -1;
	}
	brushinfo.x = uX;
8010240d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102410:	a3 50 46 11 80       	mov    %eax,0x80114650
	brushinfo.y = uY;
80102415:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102418:	a3 54 46 11 80       	mov    %eax,0x80114654
	

	return 1;
8010241d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80102422:	c9                   	leave  
80102423:	c3                   	ret    
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102428:	c9                   	leave  
		return -1;
80102429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010242e:	c3                   	ret    
8010242f:	90                   	nop

80102430 <sys_lineto>:

int sys_lineto(void) {
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	57                   	push   %edi
80102434:	56                   	push   %esi
	brushinfo.colour = 15;

	int uX;
	int uY;

	if (argint(1, &uX) < 0 || argint(2, &uY) < 0) {
80102435:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_lineto(void) {
80102438:	53                   	push   %ebx
80102439:	83 ec 24             	sub    $0x24,%esp
	brushinfo.colour = 15;
8010243c:	c7 05 58 46 11 80 0f 	movl   $0xf,0x80114658
80102443:	00 00 00 
	if (argint(1, &uX) < 0 || argint(2, &uY) < 0) {
80102446:	50                   	push   %eax
80102447:	6a 01                	push   $0x1
80102449:	e8 12 2a 00 00       	call   80104e60 <argint>
8010244e:	83 c4 10             	add    $0x10,%esp
80102451:	85 c0                	test   %eax,%eax
80102453:	0f 88 df 00 00 00    	js     80102538 <sys_lineto+0x108>
80102459:	83 ec 08             	sub    $0x8,%esp
8010245c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010245f:	50                   	push   %eax
80102460:	6a 02                	push   $0x2
80102462:	e8 f9 29 00 00       	call   80104e60 <argint>
80102467:	83 c4 10             	add    $0x10,%esp
8010246a:	85 c0                	test   %eax,%eax
8010246c:	0f 88 c6 00 00 00    	js     80102538 <sys_lineto+0x108>
		return -1;
	}
	brushinfo.isPressed = 1;

	if (uX < brushinfo.x){	
80102472:	8b 3d 50 46 11 80    	mov    0x80114650,%edi
80102478:	8b 55 e0             	mov    -0x20(%ebp),%edx
			for (int i = uX - brushinfo.x; i<=brushinfo.x; i++) {
				video_memory[uY * 320 + uX] = 15;
8010247b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	if (uX < brushinfo.x){	
8010247e:	39 d7                	cmp    %edx,%edi
80102480:	0f 8e 0a 01 00 00    	jle    80102590 <sys_lineto+0x160>
			for (int i = uX - brushinfo.x; i<=brushinfo.x; i++) {
80102486:	89 d6                	mov    %edx,%esi
80102488:	29 fe                	sub    %edi,%esi
8010248a:	39 f7                	cmp    %esi,%edi
8010248c:	7c 3a                	jl     801024c8 <sys_lineto+0x98>
				video_memory[uY * 320 + uX] = 15;
8010248e:	8d 1c 89             	lea    (%ecx,%ecx,4),%ebx
80102491:	c1 e3 06             	shl    $0x6,%ebx
80102494:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
80102497:	01 fa                	add    %edi,%edx
80102499:	8d 9c 1a 01 00 05 00 	lea    0x50001(%edx,%ebx,1),%ebx
801024a0:	8d 84 00 00 00 0a 00 	lea    0xa0000(%eax,%eax,1),%eax
801024a7:	29 f3                	sub    %esi,%ebx
801024a9:	01 db                	add    %ebx,%ebx
801024ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024af:	90                   	nop
801024b0:	bf 0f 00 00 00       	mov    $0xf,%edi
			for (int i = uX - brushinfo.x; i<=brushinfo.x; i++) {
801024b5:	83 c0 02             	add    $0x2,%eax
				video_memory[uY * 320 + uX] = 15;
801024b8:	66 89 78 fe          	mov    %di,-0x2(%eax)
			for (int i = uX - brushinfo.x; i<=brushinfo.x; i++) {
801024bc:	39 d8                	cmp    %ebx,%eax
801024be:	75 f0                	jne    801024b0 <sys_lineto+0x80>
				uX++;
801024c0:	83 c2 01             	add    $0x1,%edx
801024c3:	29 f2                	sub    %esi,%edx
801024c5:	89 55 e0             	mov    %edx,-0x20(%ebp)
				video_memory[uY * 320 + uX] = 15;
				uX--;
			}
	}
	
	if (uY <= brushinfo.y){	
801024c8:	8b 15 54 46 11 80    	mov    0x80114654,%edx
801024ce:	39 ca                	cmp    %ecx,%edx
801024d0:	7c 76                	jl     80102548 <sys_lineto+0x118>
			for (int i = uY - brushinfo.y; i<=brushinfo.y; i++) {
801024d2:	89 cb                	mov    %ecx,%ebx
801024d4:	29 d3                	sub    %edx,%ebx
801024d6:	39 da                	cmp    %ebx,%edx
801024d8:	7c 43                	jl     8010251d <sys_lineto+0xed>
801024da:	01 ca                	add    %ecx,%edx
				video_memory[uY * 320 + uX] = 15;
801024dc:	8b 75 e0             	mov    -0x20(%ebp),%esi
801024df:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
801024e2:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
801024e5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801024e8:	c1 e0 06             	shl    $0x6,%eax
801024eb:	c1 e1 06             	shl    $0x6,%ecx
801024ee:	c1 e2 06             	shl    $0x6,%edx
801024f1:	01 f0                	add    %esi,%eax
801024f3:	8d 94 16 40 01 05 00 	lea    0x50140(%esi,%edx,1),%edx
801024fa:	8d 84 00 00 00 0a 00 	lea    0xa0000(%eax,%eax,1),%eax
80102501:	29 ca                	sub    %ecx,%edx
80102503:	01 d2                	add    %edx,%edx
80102505:	8d 76 00             	lea    0x0(%esi),%esi
80102508:	bb 0f 00 00 00       	mov    $0xf,%ebx
			for (int i = uY - brushinfo.y; i<=brushinfo.y; i++) {
8010250d:	05 80 02 00 00       	add    $0x280,%eax
				video_memory[uY * 320 + uX] = 15;
80102512:	66 89 98 80 fd ff ff 	mov    %bx,-0x280(%eax)
			for (int i = uY - brushinfo.y; i<=brushinfo.y; i++) {
80102519:	39 c2                	cmp    %eax,%edx
8010251b:	75 eb                	jne    80102508 <sys_lineto+0xd8>
		for (int i = uY + brushinfo.y; i>=brushinfo.y; i--) {
				video_memory[uY * 320 + uX] = 15;
				uY--;
			}
	}
	brushinfo.isPressed = 0;
8010251d:	c7 05 5c 46 11 80 00 	movl   $0x0,0x8011465c
80102524:	00 00 00 

	return 1;
80102527:	b8 01 00 00 00       	mov    $0x1,%eax

8010252c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010252f:	5b                   	pop    %ebx
80102530:	5e                   	pop    %esi
80102531:	5f                   	pop    %edi
80102532:	5d                   	pop    %ebp
80102533:	c3                   	ret    
80102534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102538:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return -1;
8010253b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102540:	5b                   	pop    %ebx
80102541:	5e                   	pop    %esi
80102542:	5f                   	pop    %edi
80102543:	5d                   	pop    %ebp
80102544:	c3                   	ret    
80102545:	8d 76 00             	lea    0x0(%esi),%esi
		for (int i = uY + brushinfo.y; i>=brushinfo.y; i--) {
80102548:	85 c9                	test   %ecx,%ecx
8010254a:	78 d1                	js     8010251d <sys_lineto+0xed>
				video_memory[uY * 320 + uX] = 15;
8010254c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010254f:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
80102552:	c1 e0 06             	shl    $0x6,%eax
80102555:	01 d0                	add    %edx,%eax
80102557:	8d 94 12 80 fd 09 00 	lea    0x9fd80(%edx,%edx,1),%edx
8010255e:	8d 84 00 00 00 0a 00 	lea    0xa0000(%eax,%eax,1),%eax
80102565:	8d 76 00             	lea    0x0(%esi),%esi
80102568:	b9 0f 00 00 00       	mov    $0xf,%ecx
		for (int i = uY + brushinfo.y; i>=brushinfo.y; i--) {
8010256d:	2d 80 02 00 00       	sub    $0x280,%eax
				video_memory[uY * 320 + uX] = 15;
80102572:	66 89 88 80 02 00 00 	mov    %cx,0x280(%eax)
		for (int i = uY + brushinfo.y; i>=brushinfo.y; i--) {
80102579:	39 d0                	cmp    %edx,%eax
8010257b:	75 eb                	jne    80102568 <sys_lineto+0x138>
	brushinfo.isPressed = 0;
8010257d:	c7 05 5c 46 11 80 00 	movl   $0x0,0x8011465c
80102584:	00 00 00 
	return 1;
80102587:	b8 01 00 00 00       	mov    $0x1,%eax
8010258c:	eb 9e                	jmp    8010252c <sys_lineto+0xfc>
8010258e:	66 90                	xchg   %ax,%ax
		for (int i = uX + brushinfo.x; i>=brushinfo.x; i--) {
80102590:	8d 04 17             	lea    (%edi,%edx,1),%eax
80102593:	39 c7                	cmp    %eax,%edi
80102595:	0f 8f 2d ff ff ff    	jg     801024c8 <sys_lineto+0x98>
				video_memory[uY * 320 + uX] = 15;
8010259b:	8d 1c 89             	lea    (%ecx,%ecx,4),%ebx
8010259e:	c1 e3 06             	shl    $0x6,%ebx
801025a1:	01 da                	add    %ebx,%edx
801025a3:	8d 84 12 00 00 0a 00 	lea    0xa0000(%edx,%edx,1),%eax
801025aa:	8d 94 1b fe ff 09 00 	lea    0x9fffe(%ebx,%ebx,1),%edx
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025b8:	be 0f 00 00 00       	mov    $0xf,%esi
		for (int i = uX + brushinfo.x; i>=brushinfo.x; i--) {
801025bd:	83 e8 02             	sub    $0x2,%eax
				video_memory[uY * 320 + uX] = 15;
801025c0:	66 89 70 02          	mov    %si,0x2(%eax)
		for (int i = uX + brushinfo.x; i>=brushinfo.x; i--) {
801025c4:	39 d0                	cmp    %edx,%eax
801025c6:	75 f0                	jne    801025b8 <sys_lineto+0x188>
801025c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
801025cf:	e9 f4 fe ff ff       	jmp    801024c8 <sys_lineto+0x98>
801025d4:	66 90                	xchg   %ax,%ax
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <idestart>:
    // Switch back to disk 0.
    outb(0x1f6, 0xe0 | (0 << 4));
}

// Start the request for b.  Caller must hold idelock.
static void idestart(struct buf *b) {
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	57                   	push   %edi
801025e4:	56                   	push   %esi
801025e5:	53                   	push   %ebx
801025e6:	83 ec 0c             	sub    $0xc,%esp
    if (b == 0) {
801025e9:	85 c0                	test   %eax,%eax
801025eb:	0f 84 b4 00 00 00    	je     801026a5 <idestart+0xc5>
        panic("idestart");
    }
    if (b->blockno >= FSSIZE) {
801025f1:	8b 70 08             	mov    0x8(%eax),%esi
801025f4:	89 c3                	mov    %eax,%ebx
801025f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801025fc:	0f 87 96 00 00 00    	ja     80102698 <idestart+0xb8>
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102602:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260e:	66 90                	xchg   %ax,%ax
80102610:	89 ca                	mov    %ecx,%edx
80102612:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
80102613:	83 e0 c0             	and    $0xffffffc0,%eax
80102616:	3c 40                	cmp    $0x40,%al
80102618:	75 f6                	jne    80102610 <idestart+0x30>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010261a:	31 ff                	xor    %edi,%edi
8010261c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102621:	89 f8                	mov    %edi,%eax
80102623:	ee                   	out    %al,(%dx)
80102624:	b8 01 00 00 00       	mov    $0x1,%eax
80102629:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010262e:	ee                   	out    %al,(%dx)
8010262f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102634:	89 f0                	mov    %esi,%eax
80102636:	ee                   	out    %al,(%dx)

    idewait(0);
    outb(0x3f6, 0);  // generate interrupt
    outb(0x1f2, sector_per_block);  // number of sectors
    outb(0x1f3, sector & 0xff);
    outb(0x1f4, (sector >> 8) & 0xff);
80102637:	89 f0                	mov    %esi,%eax
80102639:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010263e:	c1 f8 08             	sar    $0x8,%eax
80102641:	ee                   	out    %al,(%dx)
80102642:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102647:	89 f8                	mov    %edi,%eax
80102649:	ee                   	out    %al,(%dx)
    outb(0x1f5, (sector >> 16) & 0xff);
    outb(0x1f6, 0xe0 | ((b->dev & 1) << 4) | ((sector >> 24) & 0x0f));
8010264a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010264e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102653:	c1 e0 04             	shl    $0x4,%eax
80102656:	83 e0 10             	and    $0x10,%eax
80102659:	83 c8 e0             	or     $0xffffffe0,%eax
8010265c:	ee                   	out    %al,(%dx)
    if (b->flags & B_DIRTY) {
8010265d:	f6 03 04             	testb  $0x4,(%ebx)
80102660:	75 16                	jne    80102678 <idestart+0x98>
80102662:	b8 20 00 00 00       	mov    $0x20,%eax
80102667:	89 ca                	mov    %ecx,%edx
80102669:	ee                   	out    %al,(%dx)
        outsl(0x1f0, b->data, BSIZE / 4);
    }
    else {
        outb(0x1f7, read_cmd);
    }
}
8010266a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010266d:	5b                   	pop    %ebx
8010266e:	5e                   	pop    %esi
8010266f:	5f                   	pop    %edi
80102670:	5d                   	pop    %ebp
80102671:	c3                   	ret    
80102672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102678:	b8 30 00 00 00       	mov    $0x30,%eax
8010267d:	89 ca                	mov    %ecx,%edx
8010267f:	ee                   	out    %al,(%dx)
    asm volatile ("cld; rep outsl" :
80102680:	b9 80 00 00 00       	mov    $0x80,%ecx
        outsl(0x1f0, b->data, BSIZE / 4);
80102685:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102688:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010268d:	fc                   	cld    
8010268e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102690:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102693:	5b                   	pop    %ebx
80102694:	5e                   	pop    %esi
80102695:	5f                   	pop    %edi
80102696:	5d                   	pop    %ebp
80102697:	c3                   	ret    
        panic("incorrect blockno");
80102698:	83 ec 0c             	sub    $0xc,%esp
8010269b:	68 d4 7c 10 80       	push   $0x80107cd4
801026a0:	e8 db dd ff ff       	call   80100480 <panic>
        panic("idestart");
801026a5:	83 ec 0c             	sub    $0xc,%esp
801026a8:	68 cb 7c 10 80       	push   $0x80107ccb
801026ad:	e8 ce dd ff ff       	call   80100480 <panic>
801026b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801026c0 <ideinit>:
void ideinit(void) {
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	83 ec 10             	sub    $0x10,%esp
    initlock(&idelock, "ide");
801026c6:	68 e6 7c 10 80       	push   $0x80107ce6
801026cb:	68 80 46 11 80       	push   $0x80114680
801026d0:	e8 3b 22 00 00       	call   80104910 <initlock>
    ioapicenable(IRQ_IDE, ncpu - 1);
801026d5:	58                   	pop    %eax
801026d6:	a1 04 48 11 80       	mov    0x80114804,%eax
801026db:	5a                   	pop    %edx
801026dc:	83 e8 01             	sub    $0x1,%eax
801026df:	50                   	push   %eax
801026e0:	6a 0e                	push   $0xe
801026e2:	e8 99 02 00 00       	call   80102980 <ioapicenable>
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
801026e7:	83 c4 10             	add    $0x10,%esp
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801026ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026ef:	90                   	nop
801026f0:	ec                   	in     (%dx),%al
801026f1:	83 e0 c0             	and    $0xffffffc0,%eax
801026f4:	3c 40                	cmp    $0x40,%al
801026f6:	75 f8                	jne    801026f0 <ideinit+0x30>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801026f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801026fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102702:	ee                   	out    %al,(%dx)
80102703:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102708:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010270d:	eb 06                	jmp    80102715 <ideinit+0x55>
8010270f:	90                   	nop
    for (i = 0; i < 1000; i++) {
80102710:	83 e9 01             	sub    $0x1,%ecx
80102713:	74 0f                	je     80102724 <ideinit+0x64>
80102715:	ec                   	in     (%dx),%al
        if (inb(0x1f7) != 0) {
80102716:	84 c0                	test   %al,%al
80102718:	74 f6                	je     80102710 <ideinit+0x50>
            havedisk1 = 1;
8010271a:	c7 05 60 46 11 80 01 	movl   $0x1,0x80114660
80102721:	00 00 00 
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102724:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102729:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010272e:	ee                   	out    %al,(%dx)
}
8010272f:	c9                   	leave  
80102730:	c3                   	ret    
80102731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273f:	90                   	nop

80102740 <ideintr>:

// Interrupt handler.
void ideintr(void) {
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	57                   	push   %edi
80102744:	56                   	push   %esi
80102745:	53                   	push   %ebx
80102746:	83 ec 18             	sub    $0x18,%esp
    struct buf *b;

    // First queued buffer is the active request.
    acquire(&idelock);
80102749:	68 80 46 11 80       	push   $0x80114680
8010274e:	e8 8d 23 00 00       	call   80104ae0 <acquire>

    if ((b = idequeue) == 0) {
80102753:	8b 1d 64 46 11 80    	mov    0x80114664,%ebx
80102759:	83 c4 10             	add    $0x10,%esp
8010275c:	85 db                	test   %ebx,%ebx
8010275e:	74 63                	je     801027c3 <ideintr+0x83>
        release(&idelock);
        return;
    }
    idequeue = b->qnext;
80102760:	8b 43 58             	mov    0x58(%ebx),%eax
80102763:	a3 64 46 11 80       	mov    %eax,0x80114664

    // Read data if needed.
    if (!(b->flags & B_DIRTY) && idewait(1) >= 0) {
80102768:	8b 33                	mov    (%ebx),%esi
8010276a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102770:	75 2f                	jne    801027a1 <ideintr+0x61>
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102772:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
80102780:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
80102781:	89 c1                	mov    %eax,%ecx
80102783:	83 e1 c0             	and    $0xffffffc0,%ecx
80102786:	80 f9 40             	cmp    $0x40,%cl
80102789:	75 f5                	jne    80102780 <ideintr+0x40>
    if (checkerr && (r & (IDE_DF | IDE_ERR)) != 0) {
8010278b:	a8 21                	test   $0x21,%al
8010278d:	75 12                	jne    801027a1 <ideintr+0x61>
        insl(0x1f0, b->data, BSIZE / 4);
8010278f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
    asm volatile ("cld; rep insl" :
80102792:	b9 80 00 00 00       	mov    $0x80,%ecx
80102797:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010279c:	fc                   	cld    
8010279d:	f3 6d                	rep insl (%dx),%es:(%edi)
    }

    // Wake process waiting for this buf.
    b->flags |= B_VALID;
8010279f:	8b 33                	mov    (%ebx),%esi
    b->flags &= ~B_DIRTY;
801027a1:	83 e6 fb             	and    $0xfffffffb,%esi
    wakeup(b);
801027a4:	83 ec 0c             	sub    $0xc,%esp
    b->flags &= ~B_DIRTY;
801027a7:	83 ce 02             	or     $0x2,%esi
801027aa:	89 33                	mov    %esi,(%ebx)
    wakeup(b);
801027ac:	53                   	push   %ebx
801027ad:	e8 8e 1e 00 00       	call   80104640 <wakeup>

    // Start disk on next buf in queue.
    if (idequeue != 0) {
801027b2:	a1 64 46 11 80       	mov    0x80114664,%eax
801027b7:	83 c4 10             	add    $0x10,%esp
801027ba:	85 c0                	test   %eax,%eax
801027bc:	74 05                	je     801027c3 <ideintr+0x83>
        idestart(idequeue);
801027be:	e8 1d fe ff ff       	call   801025e0 <idestart>
        release(&idelock);
801027c3:	83 ec 0c             	sub    $0xc,%esp
801027c6:	68 80 46 11 80       	push   $0x80114680
801027cb:	e8 b0 22 00 00       	call   80104a80 <release>
    }

    release(&idelock);
}
801027d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027d3:	5b                   	pop    %ebx
801027d4:	5e                   	pop    %esi
801027d5:	5f                   	pop    %edi
801027d6:	5d                   	pop    %ebp
801027d7:	c3                   	ret    
801027d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027df:	90                   	nop

801027e0 <iderw>:


// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void iderw(struct buf *b) {
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	53                   	push   %ebx
801027e4:	83 ec 10             	sub    $0x10,%esp
801027e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct buf **pp;

    if (!holdingsleep(&b->lock)) {
801027ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801027ed:	50                   	push   %eax
801027ee:	e8 cd 20 00 00       	call   801048c0 <holdingsleep>
801027f3:	83 c4 10             	add    $0x10,%esp
801027f6:	85 c0                	test   %eax,%eax
801027f8:	0f 84 c3 00 00 00    	je     801028c1 <iderw+0xe1>
        panic("iderw: buf not locked");
    }
    if ((b->flags & (B_VALID | B_DIRTY)) == B_VALID) {
801027fe:	8b 03                	mov    (%ebx),%eax
80102800:	83 e0 06             	and    $0x6,%eax
80102803:	83 f8 02             	cmp    $0x2,%eax
80102806:	0f 84 a8 00 00 00    	je     801028b4 <iderw+0xd4>
        panic("iderw: nothing to do");
    }
    if (b->dev != 0 && !havedisk1) {
8010280c:	8b 53 04             	mov    0x4(%ebx),%edx
8010280f:	85 d2                	test   %edx,%edx
80102811:	74 0d                	je     80102820 <iderw+0x40>
80102813:	a1 60 46 11 80       	mov    0x80114660,%eax
80102818:	85 c0                	test   %eax,%eax
8010281a:	0f 84 87 00 00 00    	je     801028a7 <iderw+0xc7>
        panic("iderw: ide disk 1 not present");
    }

    acquire(&idelock);  //DOC:acquire-lock
80102820:	83 ec 0c             	sub    $0xc,%esp
80102823:	68 80 46 11 80       	push   $0x80114680
80102828:	e8 b3 22 00 00       	call   80104ae0 <acquire>

    // Append b to idequeue.
    b->qnext = 0;
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
8010282d:	a1 64 46 11 80       	mov    0x80114664,%eax
    b->qnext = 0;
80102832:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
80102839:	83 c4 10             	add    $0x10,%esp
8010283c:	85 c0                	test   %eax,%eax
8010283e:	74 60                	je     801028a0 <iderw+0xc0>
80102840:	89 c2                	mov    %eax,%edx
80102842:	8b 40 58             	mov    0x58(%eax),%eax
80102845:	85 c0                	test   %eax,%eax
80102847:	75 f7                	jne    80102840 <iderw+0x60>
80102849:	83 c2 58             	add    $0x58,%edx
        ;
    }
    *pp = b;
8010284c:	89 1a                	mov    %ebx,(%edx)

    // Start disk if necessary.
    if (idequeue == b) {
8010284e:	39 1d 64 46 11 80    	cmp    %ebx,0x80114664
80102854:	74 3a                	je     80102890 <iderw+0xb0>
        idestart(b);
    }

    // Wait for request to finish.
    while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
80102856:	8b 03                	mov    (%ebx),%eax
80102858:	83 e0 06             	and    $0x6,%eax
8010285b:	83 f8 02             	cmp    $0x2,%eax
8010285e:	74 1b                	je     8010287b <iderw+0x9b>
        sleep(b, &idelock);
80102860:	83 ec 08             	sub    $0x8,%esp
80102863:	68 80 46 11 80       	push   $0x80114680
80102868:	53                   	push   %ebx
80102869:	e8 12 1d 00 00       	call   80104580 <sleep>
    while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
8010286e:	8b 03                	mov    (%ebx),%eax
80102870:	83 c4 10             	add    $0x10,%esp
80102873:	83 e0 06             	and    $0x6,%eax
80102876:	83 f8 02             	cmp    $0x2,%eax
80102879:	75 e5                	jne    80102860 <iderw+0x80>
    }

    release(&idelock);
8010287b:	c7 45 08 80 46 11 80 	movl   $0x80114680,0x8(%ebp)
}
80102882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102885:	c9                   	leave  
    release(&idelock);
80102886:	e9 f5 21 00 00       	jmp    80104a80 <release>
8010288b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010288f:	90                   	nop
        idestart(b);
80102890:	89 d8                	mov    %ebx,%eax
80102892:	e8 49 fd ff ff       	call   801025e0 <idestart>
80102897:	eb bd                	jmp    80102856 <iderw+0x76>
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
801028a0:	ba 64 46 11 80       	mov    $0x80114664,%edx
801028a5:	eb a5                	jmp    8010284c <iderw+0x6c>
        panic("iderw: ide disk 1 not present");
801028a7:	83 ec 0c             	sub    $0xc,%esp
801028aa:	68 15 7d 10 80       	push   $0x80107d15
801028af:	e8 cc db ff ff       	call   80100480 <panic>
        panic("iderw: nothing to do");
801028b4:	83 ec 0c             	sub    $0xc,%esp
801028b7:	68 00 7d 10 80       	push   $0x80107d00
801028bc:	e8 bf db ff ff       	call   80100480 <panic>
        panic("iderw: buf not locked");
801028c1:	83 ec 0c             	sub    $0xc,%esp
801028c4:	68 ea 7c 10 80       	push   $0x80107cea
801028c9:	e8 b2 db ff ff       	call   80100480 <panic>
801028ce:	66 90                	xchg   %ax,%ax

801028d0 <ioapicinit>:
static void ioapicwrite(int reg, uint data) {
    ioapic->reg = reg;
    ioapic->data = data;
}

void ioapicinit(void) {
801028d0:	55                   	push   %ebp
    int i, id, maxintr;

    ioapic = (volatile struct ioapic*)IOAPIC;
801028d1:	c7 05 b4 46 11 80 00 	movl   $0xfec00000,0x801146b4
801028d8:	00 c0 fe 
void ioapicinit(void) {
801028db:	89 e5                	mov    %esp,%ebp
801028dd:	56                   	push   %esi
801028de:	53                   	push   %ebx
    ioapic->reg = reg;
801028df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801028e6:	00 00 00 
    return ioapic->data;
801028e9:	8b 15 b4 46 11 80    	mov    0x801146b4,%edx
801028ef:	8b 72 10             	mov    0x10(%edx),%esi
    ioapic->reg = reg;
801028f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    return ioapic->data;
801028f8:	8b 0d b4 46 11 80    	mov    0x801146b4,%ecx
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
    id = ioapicread(REG_ID) >> 24;
    if (id != ioapicid) {
801028fe:	0f b6 15 00 48 11 80 	movzbl 0x80114800,%edx
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102905:	c1 ee 10             	shr    $0x10,%esi
80102908:	89 f0                	mov    %esi,%eax
8010290a:	0f b6 f0             	movzbl %al,%esi
    return ioapic->data;
8010290d:	8b 41 10             	mov    0x10(%ecx),%eax
    id = ioapicread(REG_ID) >> 24;
80102910:	c1 e8 18             	shr    $0x18,%eax
    if (id != ioapicid) {
80102913:	39 c2                	cmp    %eax,%edx
80102915:	74 16                	je     8010292d <ioapicinit+0x5d>
        cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102917:	83 ec 0c             	sub    $0xc,%esp
8010291a:	68 34 7d 10 80       	push   $0x80107d34
8010291f:	e8 bc de ff ff       	call   801007e0 <cprintf>
    ioapic->reg = reg;
80102924:	8b 0d b4 46 11 80    	mov    0x801146b4,%ecx
8010292a:	83 c4 10             	add    $0x10,%esp
8010292d:	83 c6 21             	add    $0x21,%esi
void ioapicinit(void) {
80102930:	ba 10 00 00 00       	mov    $0x10,%edx
80102935:	b8 20 00 00 00       	mov    $0x20,%eax
8010293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ioapic->reg = reg;
80102940:	89 11                	mov    %edx,(%ecx)
    }

    // Mark all interrupts edge-triggered, active high, disabled,
    // and not routed to any CPUs.
    for (i = 0; i <= maxintr; i++) {
        ioapicwrite(REG_TABLE + 2 * i, INT_DISABLED | (T_IRQ0 + i));
80102942:	89 c3                	mov    %eax,%ebx
    ioapic->data = data;
80102944:	8b 0d b4 46 11 80    	mov    0x801146b4,%ecx
    for (i = 0; i <= maxintr; i++) {
8010294a:	83 c0 01             	add    $0x1,%eax
        ioapicwrite(REG_TABLE + 2 * i, INT_DISABLED | (T_IRQ0 + i));
8010294d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
    ioapic->data = data;
80102953:	89 59 10             	mov    %ebx,0x10(%ecx)
    ioapic->reg = reg;
80102956:	8d 5a 01             	lea    0x1(%edx),%ebx
    for (i = 0; i <= maxintr; i++) {
80102959:	83 c2 02             	add    $0x2,%edx
    ioapic->reg = reg;
8010295c:	89 19                	mov    %ebx,(%ecx)
    ioapic->data = data;
8010295e:	8b 0d b4 46 11 80    	mov    0x801146b4,%ecx
80102964:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
    for (i = 0; i <= maxintr; i++) {
8010296b:	39 f0                	cmp    %esi,%eax
8010296d:	75 d1                	jne    80102940 <ioapicinit+0x70>
        ioapicwrite(REG_TABLE + 2 * i + 1, 0);
    }
}
8010296f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102972:	5b                   	pop    %ebx
80102973:	5e                   	pop    %esi
80102974:	5d                   	pop    %ebp
80102975:	c3                   	ret    
80102976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297d:	8d 76 00             	lea    0x0(%esi),%esi

80102980 <ioapicenable>:

void ioapicenable(int irq, int cpunum) {
80102980:	55                   	push   %ebp
    ioapic->reg = reg;
80102981:	8b 0d b4 46 11 80    	mov    0x801146b4,%ecx
void ioapicenable(int irq, int cpunum) {
80102987:	89 e5                	mov    %esp,%ebp
80102989:	8b 45 08             	mov    0x8(%ebp),%eax
    // Mark interrupt edge-triggered, active high,
    // enabled, and routed to the given cpunum,
    // which happens to be that cpu's APIC ID.
    ioapicwrite(REG_TABLE + 2 * irq, T_IRQ0 + irq);
8010298c:	8d 50 20             	lea    0x20(%eax),%edx
8010298f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
    ioapic->reg = reg;
80102993:	89 01                	mov    %eax,(%ecx)
    ioapic->data = data;
80102995:	8b 0d b4 46 11 80    	mov    0x801146b4,%ecx
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
8010299b:	83 c0 01             	add    $0x1,%eax
    ioapic->data = data;
8010299e:	89 51 10             	mov    %edx,0x10(%ecx)
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
801029a1:	8b 55 0c             	mov    0xc(%ebp),%edx
    ioapic->reg = reg;
801029a4:	89 01                	mov    %eax,(%ecx)
    ioapic->data = data;
801029a6:	a1 b4 46 11 80       	mov    0x801146b4,%eax
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
801029ab:	c1 e2 18             	shl    $0x18,%edx
    ioapic->data = data;
801029ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801029b1:	5d                   	pop    %ebp
801029b2:	c3                   	ret    
801029b3:	66 90                	xchg   %ax,%ax
801029b5:	66 90                	xchg   %ax,%ax
801029b7:	66 90                	xchg   %ax,%ax
801029b9:	66 90                	xchg   %ax,%ax
801029bb:	66 90                	xchg   %ax,%ax
801029bd:	66 90                	xchg   %ax,%ax
801029bf:	90                   	nop

801029c0 <kfree>:

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(char *v) {
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
801029c3:	53                   	push   %ebx
801029c4:	83 ec 04             	sub    $0x4,%esp
801029c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct run *r;

    if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP) {
801029ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801029d0:	75 76                	jne    80102a48 <kfree+0x88>
801029d2:	81 fb 50 85 11 80    	cmp    $0x80118550,%ebx
801029d8:	72 6e                	jb     80102a48 <kfree+0x88>
801029da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801029e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801029e5:	77 61                	ja     80102a48 <kfree+0x88>
        panic("kfree");
    }

    // Fill with junk to catch dangling refs.
    memset(v, 1, PGSIZE);
801029e7:	83 ec 04             	sub    $0x4,%esp
801029ea:	68 00 10 00 00       	push   $0x1000
801029ef:	6a 01                	push   $0x1
801029f1:	53                   	push   %ebx
801029f2:	e8 a9 21 00 00       	call   80104ba0 <memset>

    if (kmem.use_lock) {
801029f7:	8b 15 f4 46 11 80    	mov    0x801146f4,%edx
801029fd:	83 c4 10             	add    $0x10,%esp
80102a00:	85 d2                	test   %edx,%edx
80102a02:	75 1c                	jne    80102a20 <kfree+0x60>
        acquire(&kmem.lock);
    }
    r = (struct run*)v;
    r->next = kmem.freelist;
80102a04:	a1 f8 46 11 80       	mov    0x801146f8,%eax
80102a09:	89 03                	mov    %eax,(%ebx)
    kmem.freelist = r;
    if (kmem.use_lock) {
80102a0b:	a1 f4 46 11 80       	mov    0x801146f4,%eax
    kmem.freelist = r;
80102a10:	89 1d f8 46 11 80    	mov    %ebx,0x801146f8
    if (kmem.use_lock) {
80102a16:	85 c0                	test   %eax,%eax
80102a18:	75 1e                	jne    80102a38 <kfree+0x78>
        release(&kmem.lock);
    }
}
80102a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a1d:	c9                   	leave  
80102a1e:	c3                   	ret    
80102a1f:	90                   	nop
        acquire(&kmem.lock);
80102a20:	83 ec 0c             	sub    $0xc,%esp
80102a23:	68 c0 46 11 80       	push   $0x801146c0
80102a28:	e8 b3 20 00 00       	call   80104ae0 <acquire>
80102a2d:	83 c4 10             	add    $0x10,%esp
80102a30:	eb d2                	jmp    80102a04 <kfree+0x44>
80102a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        release(&kmem.lock);
80102a38:	c7 45 08 c0 46 11 80 	movl   $0x801146c0,0x8(%ebp)
}
80102a3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a42:	c9                   	leave  
        release(&kmem.lock);
80102a43:	e9 38 20 00 00       	jmp    80104a80 <release>
        panic("kfree");
80102a48:	83 ec 0c             	sub    $0xc,%esp
80102a4b:	68 66 7d 10 80       	push   $0x80107d66
80102a50:	e8 2b da ff ff       	call   80100480 <panic>
80102a55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a60 <freerange>:
void freerange(void *vstart, void *vend) {
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	56                   	push   %esi
    p = (char*)PGROUNDUP((uint)vstart);
80102a64:	8b 45 08             	mov    0x8(%ebp),%eax
void freerange(void *vstart, void *vend) {
80102a67:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a6a:	53                   	push   %ebx
    p = (char*)PGROUNDUP((uint)vstart);
80102a6b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a71:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102a77:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a7d:	39 de                	cmp    %ebx,%esi
80102a7f:	72 23                	jb     80102aa4 <freerange+0x44>
80102a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p);
80102a88:	83 ec 0c             	sub    $0xc,%esp
80102a8b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102a91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
80102a97:	50                   	push   %eax
80102a98:	e8 23 ff ff ff       	call   801029c0 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102a9d:	83 c4 10             	add    $0x10,%esp
80102aa0:	39 f3                	cmp    %esi,%ebx
80102aa2:	76 e4                	jbe    80102a88 <freerange+0x28>
}
80102aa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102aa7:	5b                   	pop    %ebx
80102aa8:	5e                   	pop    %esi
80102aa9:	5d                   	pop    %ebp
80102aaa:	c3                   	ret    
80102aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aaf:	90                   	nop

80102ab0 <kinit2>:
void kinit2(void *vstart, void *vend) {
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	56                   	push   %esi
    p = (char*)PGROUNDUP((uint)vstart);
80102ab4:	8b 45 08             	mov    0x8(%ebp),%eax
void kinit2(void *vstart, void *vend) {
80102ab7:	8b 75 0c             	mov    0xc(%ebp),%esi
80102aba:	53                   	push   %ebx
    p = (char*)PGROUNDUP((uint)vstart);
80102abb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ac1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102ac7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102acd:	39 de                	cmp    %ebx,%esi
80102acf:	72 23                	jb     80102af4 <kinit2+0x44>
80102ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p);
80102ad8:	83 ec 0c             	sub    $0xc,%esp
80102adb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102ae1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
80102ae7:	50                   	push   %eax
80102ae8:	e8 d3 fe ff ff       	call   801029c0 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102aed:	83 c4 10             	add    $0x10,%esp
80102af0:	39 de                	cmp    %ebx,%esi
80102af2:	73 e4                	jae    80102ad8 <kinit2+0x28>
    kmem.use_lock = 1;
80102af4:	c7 05 f4 46 11 80 01 	movl   $0x1,0x801146f4
80102afb:	00 00 00 
}
80102afe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b01:	5b                   	pop    %ebx
80102b02:	5e                   	pop    %esi
80102b03:	5d                   	pop    %ebp
80102b04:	c3                   	ret    
80102b05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <kinit1>:
void kinit1(void *vstart, void *vend) {
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	56                   	push   %esi
80102b14:	53                   	push   %ebx
80102b15:	8b 75 0c             	mov    0xc(%ebp),%esi
    initlock(&kmem.lock, "kmem");
80102b18:	83 ec 08             	sub    $0x8,%esp
80102b1b:	68 6c 7d 10 80       	push   $0x80107d6c
80102b20:	68 c0 46 11 80       	push   $0x801146c0
80102b25:	e8 e6 1d 00 00       	call   80104910 <initlock>
    p = (char*)PGROUNDUP((uint)vstart);
80102b2a:	8b 45 08             	mov    0x8(%ebp),%eax
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102b2d:	83 c4 10             	add    $0x10,%esp
    kmem.use_lock = 0;
80102b30:	c7 05 f4 46 11 80 00 	movl   $0x0,0x801146f4
80102b37:	00 00 00 
    p = (char*)PGROUNDUP((uint)vstart);
80102b3a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b40:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102b46:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b4c:	39 de                	cmp    %ebx,%esi
80102b4e:	72 1c                	jb     80102b6c <kinit1+0x5c>
        kfree(p);
80102b50:	83 ec 0c             	sub    $0xc,%esp
80102b53:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102b59:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
80102b5f:	50                   	push   %eax
80102b60:	e8 5b fe ff ff       	call   801029c0 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102b65:	83 c4 10             	add    $0x10,%esp
80102b68:	39 de                	cmp    %ebx,%esi
80102b6a:	73 e4                	jae    80102b50 <kinit1+0x40>
}
80102b6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b6f:	5b                   	pop    %ebx
80102b70:	5e                   	pop    %esi
80102b71:	5d                   	pop    %ebp
80102b72:	c3                   	ret    
80102b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b80 <kalloc>:
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char* kalloc(void)  {
    struct run *r;

    if (kmem.use_lock) {
80102b80:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102b85:	85 c0                	test   %eax,%eax
80102b87:	75 1f                	jne    80102ba8 <kalloc+0x28>
        acquire(&kmem.lock);
    }
    r = kmem.freelist;
80102b89:	a1 f8 46 11 80       	mov    0x801146f8,%eax
    if (r) {
80102b8e:	85 c0                	test   %eax,%eax
80102b90:	74 0e                	je     80102ba0 <kalloc+0x20>
        kmem.freelist = r->next;
80102b92:	8b 10                	mov    (%eax),%edx
80102b94:	89 15 f8 46 11 80    	mov    %edx,0x801146f8
    }
    if (kmem.use_lock) {
80102b9a:	c3                   	ret    
80102b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b9f:	90                   	nop
        release(&kmem.lock);
    }
    return (char*)r;
}
80102ba0:	c3                   	ret    
80102ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
char* kalloc(void)  {
80102ba8:	55                   	push   %ebp
80102ba9:	89 e5                	mov    %esp,%ebp
80102bab:	83 ec 24             	sub    $0x24,%esp
        acquire(&kmem.lock);
80102bae:	68 c0 46 11 80       	push   $0x801146c0
80102bb3:	e8 28 1f 00 00       	call   80104ae0 <acquire>
    r = kmem.freelist;
80102bb8:	a1 f8 46 11 80       	mov    0x801146f8,%eax
    if (kmem.use_lock) {
80102bbd:	8b 15 f4 46 11 80    	mov    0x801146f4,%edx
    if (r) {
80102bc3:	83 c4 10             	add    $0x10,%esp
80102bc6:	85 c0                	test   %eax,%eax
80102bc8:	74 08                	je     80102bd2 <kalloc+0x52>
        kmem.freelist = r->next;
80102bca:	8b 08                	mov    (%eax),%ecx
80102bcc:	89 0d f8 46 11 80    	mov    %ecx,0x801146f8
    if (kmem.use_lock) {
80102bd2:	85 d2                	test   %edx,%edx
80102bd4:	74 16                	je     80102bec <kalloc+0x6c>
        release(&kmem.lock);
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102bdc:	68 c0 46 11 80       	push   $0x801146c0
80102be1:	e8 9a 1e 00 00       	call   80104a80 <release>
    return (char*)r;
80102be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
        release(&kmem.lock);
80102be9:	83 c4 10             	add    $0x10,%esp
}
80102bec:	c9                   	leave  
80102bed:	c3                   	ret    
80102bee:	66 90                	xchg   %ax,%ax

80102bf0 <kbdgetc>:
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102bf0:	ba 64 00 00 00       	mov    $0x64,%edx
80102bf5:	ec                   	in     (%dx),%al
        normalmap, shiftmap, ctlmap, ctlmap
    };
    uint st, data, c;

    st = inb(KBSTATP);
    if ((st & KBS_DIB) == 0) {
80102bf6:	a8 01                	test   $0x1,%al
80102bf8:	0f 84 c2 00 00 00    	je     80102cc0 <kbdgetc+0xd0>
int kbdgetc(void) {
80102bfe:	55                   	push   %ebp
80102bff:	ba 60 00 00 00       	mov    $0x60,%edx
80102c04:	89 e5                	mov    %esp,%ebp
80102c06:	53                   	push   %ebx
80102c07:	ec                   	in     (%dx),%al
        return -1;
    }
    data = inb(KBDATAP);

    if (data == 0xE0) {
        shift |= E0ESC;
80102c08:	8b 1d fc 46 11 80    	mov    0x801146fc,%ebx
    data = inb(KBDATAP);
80102c0e:	0f b6 c8             	movzbl %al,%ecx
    if (data == 0xE0) {
80102c11:	3c e0                	cmp    $0xe0,%al
80102c13:	74 5b                	je     80102c70 <kbdgetc+0x80>
        return 0;
    }
    else if (data & 0x80) {
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
80102c15:	89 da                	mov    %ebx,%edx
80102c17:	83 e2 40             	and    $0x40,%edx
    else if (data & 0x80) {
80102c1a:	84 c0                	test   %al,%al
80102c1c:	78 62                	js     80102c80 <kbdgetc+0x90>
        shift &= ~(shiftcode[data] | E0ESC);
        return 0;
    }
    else if (shift & E0ESC) {
80102c1e:	85 d2                	test   %edx,%edx
80102c20:	74 09                	je     80102c2b <kbdgetc+0x3b>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
80102c22:	83 c8 80             	or     $0xffffff80,%eax
        shift &= ~E0ESC;
80102c25:	83 e3 bf             	and    $0xffffffbf,%ebx
        data |= 0x80;
80102c28:	0f b6 c8             	movzbl %al,%ecx
    }

    shift |= shiftcode[data];
80102c2b:	0f b6 91 a0 7e 10 80 	movzbl -0x7fef8160(%ecx),%edx
    shift ^= togglecode[data];
80102c32:	0f b6 81 a0 7d 10 80 	movzbl -0x7fef8260(%ecx),%eax
    shift |= shiftcode[data];
80102c39:	09 da                	or     %ebx,%edx
    shift ^= togglecode[data];
80102c3b:	31 c2                	xor    %eax,%edx
    c = charcode[shift & (CTL | SHIFT)][data];
80102c3d:	89 d0                	mov    %edx,%eax
    shift ^= togglecode[data];
80102c3f:	89 15 fc 46 11 80    	mov    %edx,0x801146fc
    c = charcode[shift & (CTL | SHIFT)][data];
80102c45:	83 e0 03             	and    $0x3,%eax
    if (shift & CAPSLOCK) {
80102c48:	83 e2 08             	and    $0x8,%edx
    c = charcode[shift & (CTL | SHIFT)][data];
80102c4b:	8b 04 85 80 7d 10 80 	mov    -0x7fef8280(,%eax,4),%eax
80102c52:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
    if (shift & CAPSLOCK) {
80102c56:	74 0b                	je     80102c63 <kbdgetc+0x73>
        if ('a' <= c && c <= 'z') {
80102c58:	8d 50 9f             	lea    -0x61(%eax),%edx
80102c5b:	83 fa 19             	cmp    $0x19,%edx
80102c5e:	77 48                	ja     80102ca8 <kbdgetc+0xb8>
            c += 'A' - 'a';
80102c60:	83 e8 20             	sub    $0x20,%eax
        else if ('A' <= c && c <= 'Z') {
            c += 'a' - 'A';
        }
    }
    return c;
}
80102c63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c66:	c9                   	leave  
80102c67:	c3                   	ret    
80102c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop
        shift |= E0ESC;
80102c70:	83 cb 40             	or     $0x40,%ebx
        return 0;
80102c73:	31 c0                	xor    %eax,%eax
        shift |= E0ESC;
80102c75:	89 1d fc 46 11 80    	mov    %ebx,0x801146fc
}
80102c7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c7e:	c9                   	leave  
80102c7f:	c3                   	ret    
        data = (shift & E0ESC ? data : data & 0x7F);
80102c80:	83 e0 7f             	and    $0x7f,%eax
80102c83:	85 d2                	test   %edx,%edx
80102c85:	0f 44 c8             	cmove  %eax,%ecx
        shift &= ~(shiftcode[data] | E0ESC);
80102c88:	0f b6 81 a0 7e 10 80 	movzbl -0x7fef8160(%ecx),%eax
80102c8f:	83 c8 40             	or     $0x40,%eax
80102c92:	0f b6 c0             	movzbl %al,%eax
80102c95:	f7 d0                	not    %eax
80102c97:	21 d8                	and    %ebx,%eax
}
80102c99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        shift &= ~(shiftcode[data] | E0ESC);
80102c9c:	a3 fc 46 11 80       	mov    %eax,0x801146fc
        return 0;
80102ca1:	31 c0                	xor    %eax,%eax
}
80102ca3:	c9                   	leave  
80102ca4:	c3                   	ret    
80102ca5:	8d 76 00             	lea    0x0(%esi),%esi
        else if ('A' <= c && c <= 'Z') {
80102ca8:	8d 48 bf             	lea    -0x41(%eax),%ecx
            c += 'a' - 'A';
80102cab:	8d 50 20             	lea    0x20(%eax),%edx
}
80102cae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb1:	c9                   	leave  
            c += 'a' - 'A';
80102cb2:	83 f9 1a             	cmp    $0x1a,%ecx
80102cb5:	0f 42 c2             	cmovb  %edx,%eax
}
80102cb8:	c3                   	ret    
80102cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80102cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102cc5:	c3                   	ret    
80102cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ccd:	8d 76 00             	lea    0x0(%esi),%esi

80102cd0 <kbdintr>:

void kbdintr(void) {
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	83 ec 14             	sub    $0x14,%esp
    consoleintr(kbdgetc);
80102cd6:	68 f0 2b 10 80       	push   $0x80102bf0
80102cdb:	e8 30 dd ff ff       	call   80100a10 <consoleintr>
}
80102ce0:	83 c4 10             	add    $0x10,%esp
80102ce3:	c9                   	leave  
80102ce4:	c3                   	ret    
80102ce5:	66 90                	xchg   %ax,%ax
80102ce7:	66 90                	xchg   %ax,%ax
80102ce9:	66 90                	xchg   %ax,%ax
80102ceb:	66 90                	xchg   %ax,%ax
80102ced:	66 90                	xchg   %ax,%ax
80102cef:	90                   	nop

80102cf0 <lapicinit>:
    lapic[index] = value;
    lapic[ID];  // wait for write to finish, by reading
}

void lapicinit(void) {
    if (!lapic) {
80102cf0:	a1 00 47 11 80       	mov    0x80114700,%eax
80102cf5:	85 c0                	test   %eax,%eax
80102cf7:	0f 84 cb 00 00 00    	je     80102dc8 <lapicinit+0xd8>
    lapic[index] = value;
80102cfd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102d04:	01 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d07:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d0a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102d11:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d14:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d17:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102d1e:	00 02 00 
    lapic[ID];  // wait for write to finish, by reading
80102d21:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d24:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102d2b:	96 98 00 
    lapic[ID];  // wait for write to finish, by reading
80102d2e:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d31:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102d38:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
80102d3b:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d3e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102d45:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
80102d48:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(LINT0, MASKED);
    lapicw(LINT1, MASKED);

    // Disable performance counter overflow interrupts
    // on machines that provide that interrupt entry.
    if (((lapic[VER] >> 16) & 0xFF) >= 4) {
80102d4b:	8b 50 30             	mov    0x30(%eax),%edx
80102d4e:	c1 ea 10             	shr    $0x10,%edx
80102d51:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102d57:	75 77                	jne    80102dd0 <lapicinit+0xe0>
    lapic[index] = value;
80102d59:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102d60:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d63:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d66:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d6d:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d70:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d73:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d7a:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d7d:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d80:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d87:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d8a:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d8d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d94:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d97:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d9a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102da1:	85 08 00 
    lapic[ID];  // wait for write to finish, by reading
80102da4:	8b 50 20             	mov    0x20(%eax),%edx
80102da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dae:	66 90                	xchg   %ax,%ax
    lapicw(EOI, 0);

    // Send an Init Level De-Assert to synchronise arbitration ID's.
    lapicw(ICRHI, 0);
    lapicw(ICRLO, BCAST | INIT | LEVEL);
    while (lapic[ICRLO] & DELIVS) {
80102db0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102db6:	80 e6 10             	and    $0x10,%dh
80102db9:	75 f5                	jne    80102db0 <lapicinit+0xc0>
    lapic[index] = value;
80102dbb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102dc2:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102dc5:	8b 40 20             	mov    0x20(%eax),%eax
        ;
    }

    // Enable interrupts on the APIC (but not on the processor).
    lapicw(TPR, 0);
}
80102dc8:	c3                   	ret    
80102dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapic[index] = value;
80102dd0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102dd7:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
80102dda:	8b 50 20             	mov    0x20(%eax),%edx
}
80102ddd:	e9 77 ff ff ff       	jmp    80102d59 <lapicinit+0x69>
80102de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102df0 <lapicid>:

int lapicid(void) {
    if (!lapic) {
80102df0:	a1 00 47 11 80       	mov    0x80114700,%eax
80102df5:	85 c0                	test   %eax,%eax
80102df7:	74 07                	je     80102e00 <lapicid+0x10>
        return 0;
    }
    return lapic[ID] >> 24;
80102df9:	8b 40 20             	mov    0x20(%eax),%eax
80102dfc:	c1 e8 18             	shr    $0x18,%eax
80102dff:	c3                   	ret    
        return 0;
80102e00:	31 c0                	xor    %eax,%eax
}
80102e02:	c3                   	ret    
80102e03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e10 <lapiceoi>:

// Acknowledge interrupt.
void lapiceoi(void) {
    if (lapic) {
80102e10:	a1 00 47 11 80       	mov    0x80114700,%eax
80102e15:	85 c0                	test   %eax,%eax
80102e17:	74 0d                	je     80102e26 <lapiceoi+0x16>
    lapic[index] = value;
80102e19:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e20:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102e23:	8b 40 20             	mov    0x20(%eax),%eax
        lapicw(EOI, 0);
    }
}
80102e26:	c3                   	ret    
80102e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e2e:	66 90                	xchg   %ax,%ax

80102e30 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void microdelay(int us) {
}
80102e30:	c3                   	ret    
80102e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e3f:	90                   	nop

80102e40 <lapicstartap>:
#define CMOS_PORT    0x70
#define CMOS_RETURN  0x71

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void lapicstartap(uchar apicid, uint addr)      {
80102e40:	55                   	push   %ebp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102e41:	b8 0f 00 00 00       	mov    $0xf,%eax
80102e46:	ba 70 00 00 00       	mov    $0x70,%edx
80102e4b:	89 e5                	mov    %esp,%ebp
80102e4d:	53                   	push   %ebx
80102e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102e51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e54:	ee                   	out    %al,(%dx)
80102e55:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e5a:	ba 71 00 00 00       	mov    $0x71,%edx
80102e5f:	ee                   	out    %al,(%dx)
    // and the warm reset vector (DWORD based at 40:67) to point at
    // the AP startup code prior to the [universal startup algorithm]."
    outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
    outb(CMOS_PORT + 1, 0x0A);
    wrv = (ushort*)P2V((0x40 << 4 | 0x67));  // Warm reset vector
    wrv[0] = 0;
80102e60:	31 c0                	xor    %eax,%eax
    wrv[1] = addr >> 4;

    // "Universal startup algorithm."
    // Send INIT (level-triggered) interrupt to reset other CPU.
    lapicw(ICRHI, apicid << 24);
80102e62:	c1 e3 18             	shl    $0x18,%ebx
    wrv[0] = 0;
80102e65:	66 a3 67 04 00 80    	mov    %ax,0x80000467
    wrv[1] = addr >> 4;
80102e6b:	89 c8                	mov    %ecx,%eax
    // when it is in the halted state due to an INIT.  So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one.  Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapicw(ICRHI, apicid << 24);
        lapicw(ICRLO, STARTUP | (addr >> 12));
80102e6d:	c1 e9 0c             	shr    $0xc,%ecx
    lapicw(ICRHI, apicid << 24);
80102e70:	89 da                	mov    %ebx,%edx
    wrv[1] = addr >> 4;
80102e72:	c1 e8 04             	shr    $0x4,%eax
        lapicw(ICRLO, STARTUP | (addr >> 12));
80102e75:	80 cd 06             	or     $0x6,%ch
    wrv[1] = addr >> 4;
80102e78:	66 a3 69 04 00 80    	mov    %ax,0x80000469
    lapic[index] = value;
80102e7e:	a1 00 47 11 80       	mov    0x80114700,%eax
80102e83:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102e89:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102e8c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e93:	c5 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102e96:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102e99:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ea0:	85 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102ea3:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102ea6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102eac:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102eaf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102eb5:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102eb8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102ebe:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102ec1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102ec7:	8b 40 20             	mov    0x20(%eax),%eax
        microdelay(200);
    }
}
80102eca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ecd:	c9                   	leave  
80102ece:	c3                   	ret    
80102ecf:	90                   	nop

80102ed0 <cmostime>:
    r->month  = cmos_read(MONTH);
    r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r) {
80102ed0:	55                   	push   %ebp
80102ed1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ed6:	ba 70 00 00 00       	mov    $0x70,%edx
80102edb:	89 e5                	mov    %esp,%ebp
80102edd:	57                   	push   %edi
80102ede:	56                   	push   %esi
80102edf:	53                   	push   %ebx
80102ee0:	83 ec 4c             	sub    $0x4c,%esp
80102ee3:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102ee4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ee9:	ec                   	in     (%dx),%al
    struct rtcdate t1, t2;
    int sb, bcd;

    sb = cmos_read(CMOS_STATB);

    bcd = (sb & (1 << 2)) == 0;
80102eea:	83 e0 04             	and    $0x4,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102eed:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ef2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ef5:	8d 76 00             	lea    0x0(%esi),%esi
80102ef8:	31 c0                	xor    %eax,%eax
80102efa:	89 da                	mov    %ebx,%edx
80102efc:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102efd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102f02:	89 ca                	mov    %ecx,%edx
80102f04:	ec                   	in     (%dx),%al
80102f05:	88 45 b7             	mov    %al,-0x49(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f08:	89 da                	mov    %ebx,%edx
80102f0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102f0f:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f10:	89 ca                	mov    %ecx,%edx
80102f12:	ec                   	in     (%dx),%al
80102f13:	88 45 b6             	mov    %al,-0x4a(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f16:	89 da                	mov    %ebx,%edx
80102f18:	b8 04 00 00 00       	mov    $0x4,%eax
80102f1d:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f1e:	89 ca                	mov    %ecx,%edx
80102f20:	ec                   	in     (%dx),%al
80102f21:	88 45 b5             	mov    %al,-0x4b(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f24:	89 da                	mov    %ebx,%edx
80102f26:	b8 07 00 00 00       	mov    $0x7,%eax
80102f2b:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f2c:	89 ca                	mov    %ecx,%edx
80102f2e:	ec                   	in     (%dx),%al
80102f2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f32:	89 da                	mov    %ebx,%edx
80102f34:	b8 08 00 00 00       	mov    $0x8,%eax
80102f39:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f3a:	89 ca                	mov    %ecx,%edx
80102f3c:	ec                   	in     (%dx),%al
80102f3d:	89 c7                	mov    %eax,%edi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f3f:	89 da                	mov    %ebx,%edx
80102f41:	b8 09 00 00 00       	mov    $0x9,%eax
80102f46:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f47:	89 ca                	mov    %ecx,%edx
80102f49:	ec                   	in     (%dx),%al
80102f4a:	89 c6                	mov    %eax,%esi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f4c:	89 da                	mov    %ebx,%edx
80102f4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f53:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f54:	89 ca                	mov    %ecx,%edx
80102f56:	ec                   	in     (%dx),%al

    // make sure CMOS doesn't modify time while we read it
    for (;;) {
        fill_rtcdate(&t1);
        if (cmos_read(CMOS_STATA) & CMOS_UIP) {
80102f57:	84 c0                	test   %al,%al
80102f59:	78 9d                	js     80102ef8 <cmostime+0x28>
    return inb(CMOS_RETURN);
80102f5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102f5f:	89 fa                	mov    %edi,%edx
80102f61:	0f b6 fa             	movzbl %dl,%edi
80102f64:	89 f2                	mov    %esi,%edx
80102f66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f6d:	0f b6 f2             	movzbl %dl,%esi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f70:	89 da                	mov    %ebx,%edx
80102f72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102f75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102f7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f89:	31 c0                	xor    %eax,%eax
80102f8b:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f8c:	89 ca                	mov    %ecx,%edx
80102f8e:	ec                   	in     (%dx),%al
80102f8f:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f92:	89 da                	mov    %ebx,%edx
80102f94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f97:	b8 02 00 00 00       	mov    $0x2,%eax
80102f9c:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f9d:	89 ca                	mov    %ecx,%edx
80102f9f:	ec                   	in     (%dx),%al
80102fa0:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102fa3:	89 da                	mov    %ebx,%edx
80102fa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102fa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102fad:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102fae:	89 ca                	mov    %ecx,%edx
80102fb0:	ec                   	in     (%dx),%al
80102fb1:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102fb4:	89 da                	mov    %ebx,%edx
80102fb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102fb9:	b8 07 00 00 00       	mov    $0x7,%eax
80102fbe:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102fbf:	89 ca                	mov    %ecx,%edx
80102fc1:	ec                   	in     (%dx),%al
80102fc2:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102fc5:	89 da                	mov    %ebx,%edx
80102fc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102fca:	b8 08 00 00 00       	mov    $0x8,%eax
80102fcf:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102fd0:	89 ca                	mov    %ecx,%edx
80102fd2:	ec                   	in     (%dx),%al
80102fd3:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102fd6:	89 da                	mov    %ebx,%edx
80102fd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102fdb:	b8 09 00 00 00       	mov    $0x9,%eax
80102fe0:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102fe1:	89 ca                	mov    %ecx,%edx
80102fe3:	ec                   	in     (%dx),%al
80102fe4:	0f b6 c0             	movzbl %al,%eax
            continue;
        }
        fill_rtcdate(&t2);
        if (memcmp(&t1, &t2, sizeof(t1)) == 0) {
80102fe7:	83 ec 04             	sub    $0x4,%esp
    return inb(CMOS_RETURN);
80102fea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (memcmp(&t1, &t2, sizeof(t1)) == 0) {
80102fed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ff0:	6a 18                	push   $0x18
80102ff2:	50                   	push   %eax
80102ff3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ff6:	50                   	push   %eax
80102ff7:	e8 f4 1b 00 00       	call   80104bf0 <memcmp>
80102ffc:	83 c4 10             	add    $0x10,%esp
80102fff:	85 c0                	test   %eax,%eax
80103001:	0f 85 f1 fe ff ff    	jne    80102ef8 <cmostime+0x28>
            break;
        }
    }

    // convert
    if (bcd) {
80103007:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010300b:	75 78                	jne    80103085 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
        CONV(second);
8010300d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103010:	89 c2                	mov    %eax,%edx
80103012:	83 e0 0f             	and    $0xf,%eax
80103015:	c1 ea 04             	shr    $0x4,%edx
80103018:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010301b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010301e:	89 45 b8             	mov    %eax,-0x48(%ebp)
        CONV(minute);
80103021:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103024:	89 c2                	mov    %eax,%edx
80103026:	83 e0 0f             	and    $0xf,%eax
80103029:	c1 ea 04             	shr    $0x4,%edx
8010302c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010302f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103032:	89 45 bc             	mov    %eax,-0x44(%ebp)
        CONV(hour  );
80103035:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103038:	89 c2                	mov    %eax,%edx
8010303a:	83 e0 0f             	and    $0xf,%eax
8010303d:	c1 ea 04             	shr    $0x4,%edx
80103040:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103043:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103046:	89 45 c0             	mov    %eax,-0x40(%ebp)
        CONV(day   );
80103049:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010304c:	89 c2                	mov    %eax,%edx
8010304e:	83 e0 0f             	and    $0xf,%eax
80103051:	c1 ea 04             	shr    $0x4,%edx
80103054:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103057:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010305a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        CONV(month );
8010305d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103060:	89 c2                	mov    %eax,%edx
80103062:	83 e0 0f             	and    $0xf,%eax
80103065:	c1 ea 04             	shr    $0x4,%edx
80103068:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010306b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010306e:	89 45 c8             	mov    %eax,-0x38(%ebp)
        CONV(year  );
80103071:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103074:	89 c2                	mov    %eax,%edx
80103076:	83 e0 0f             	and    $0xf,%eax
80103079:	c1 ea 04             	shr    $0x4,%edx
8010307c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010307f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103082:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
    }

    *r = t1;
80103085:	8b 75 08             	mov    0x8(%ebp),%esi
80103088:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010308b:	89 06                	mov    %eax,(%esi)
8010308d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103090:	89 46 04             	mov    %eax,0x4(%esi)
80103093:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103096:	89 46 08             	mov    %eax,0x8(%esi)
80103099:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010309c:	89 46 0c             	mov    %eax,0xc(%esi)
8010309f:	8b 45 c8             	mov    -0x38(%ebp),%eax
801030a2:	89 46 10             	mov    %eax,0x10(%esi)
801030a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801030a8:	89 46 14             	mov    %eax,0x14(%esi)
    r->year += 2000;
801030ab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801030b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030b5:	5b                   	pop    %ebx
801030b6:	5e                   	pop    %esi
801030b7:	5f                   	pop    %edi
801030b8:	5d                   	pop    %ebp
801030b9:	c3                   	ret    
801030ba:	66 90                	xchg   %ax,%ax
801030bc:	66 90                	xchg   %ax,%ax
801030be:	66 90                	xchg   %ax,%ax

801030c0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030c0:	8b 0d 68 47 11 80    	mov    0x80114768,%ecx
801030c6:	85 c9                	test   %ecx,%ecx
801030c8:	0f 8e 8a 00 00 00    	jle    80103158 <install_trans+0x98>
{
801030ce:	55                   	push   %ebp
801030cf:	89 e5                	mov    %esp,%ebp
801030d1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801030d2:	31 ff                	xor    %edi,%edi
{
801030d4:	56                   	push   %esi
801030d5:	53                   	push   %ebx
801030d6:	83 ec 0c             	sub    $0xc,%esp
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801030e0:	a1 54 47 11 80       	mov    0x80114754,%eax
801030e5:	83 ec 08             	sub    $0x8,%esp
801030e8:	01 f8                	add    %edi,%eax
801030ea:	83 c0 01             	add    $0x1,%eax
801030ed:	50                   	push   %eax
801030ee:	ff 35 64 47 11 80    	push   0x80114764
801030f4:	e8 d7 cf ff ff       	call   801000d0 <bread>
801030f9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030fb:	58                   	pop    %eax
801030fc:	5a                   	pop    %edx
801030fd:	ff 34 bd 6c 47 11 80 	push   -0x7feeb894(,%edi,4)
80103104:	ff 35 64 47 11 80    	push   0x80114764
  for (tail = 0; tail < log.lh.n; tail++) {
8010310a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010310d:	e8 be cf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103112:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103115:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103117:	8d 46 5c             	lea    0x5c(%esi),%eax
8010311a:	68 00 02 00 00       	push   $0x200
8010311f:	50                   	push   %eax
80103120:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103123:	50                   	push   %eax
80103124:	e8 17 1b 00 00       	call   80104c40 <memmove>
    bwrite(dbuf);  // write dst to disk
80103129:	89 1c 24             	mov    %ebx,(%esp)
8010312c:	e8 7f d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103131:	89 34 24             	mov    %esi,(%esp)
80103134:	e8 b7 d0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103139:	89 1c 24             	mov    %ebx,(%esp)
8010313c:	e8 af d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103141:	83 c4 10             	add    $0x10,%esp
80103144:	39 3d 68 47 11 80    	cmp    %edi,0x80114768
8010314a:	7f 94                	jg     801030e0 <install_trans+0x20>
  }
}
8010314c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010314f:	5b                   	pop    %ebx
80103150:	5e                   	pop    %esi
80103151:	5f                   	pop    %edi
80103152:	5d                   	pop    %ebp
80103153:	c3                   	ret    
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103158:	c3                   	ret    
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103160 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	53                   	push   %ebx
80103164:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103167:	ff 35 54 47 11 80    	push   0x80114754
8010316d:	ff 35 64 47 11 80    	push   0x80114764
80103173:	e8 58 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103178:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010317b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010317d:	a1 68 47 11 80       	mov    0x80114768,%eax
80103182:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103185:	85 c0                	test   %eax,%eax
80103187:	7e 19                	jle    801031a2 <write_head+0x42>
80103189:	31 d2                	xor    %edx,%edx
8010318b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103190:	8b 0c 95 6c 47 11 80 	mov    -0x7feeb894(,%edx,4),%ecx
80103197:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010319b:	83 c2 01             	add    $0x1,%edx
8010319e:	39 d0                	cmp    %edx,%eax
801031a0:	75 ee                	jne    80103190 <write_head+0x30>
  }
  bwrite(buf);
801031a2:	83 ec 0c             	sub    $0xc,%esp
801031a5:	53                   	push   %ebx
801031a6:	e8 05 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801031ab:	89 1c 24             	mov    %ebx,(%esp)
801031ae:	e8 3d d0 ff ff       	call   801001f0 <brelse>
}
801031b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031b6:	83 c4 10             	add    $0x10,%esp
801031b9:	c9                   	leave  
801031ba:	c3                   	ret    
801031bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031bf:	90                   	nop

801031c0 <initlog>:
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	53                   	push   %ebx
801031c4:	83 ec 2c             	sub    $0x2c,%esp
801031c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801031ca:	68 a0 7f 10 80       	push   $0x80107fa0
801031cf:	68 20 47 11 80       	push   $0x80114720
801031d4:	e8 37 17 00 00       	call   80104910 <initlock>
  readsb(dev, &sb);
801031d9:	58                   	pop    %eax
801031da:	8d 45 dc             	lea    -0x24(%ebp),%eax
801031dd:	5a                   	pop    %edx
801031de:	50                   	push   %eax
801031df:	53                   	push   %ebx
801031e0:	e8 bb e5 ff ff       	call   801017a0 <readsb>
  log.start = sb.logstart;
801031e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801031e8:	59                   	pop    %ecx
  log.dev = dev;
801031e9:	89 1d 64 47 11 80    	mov    %ebx,0x80114764
  log.size = sb.nlog;
801031ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801031f2:	a3 54 47 11 80       	mov    %eax,0x80114754
  log.size = sb.nlog;
801031f7:	89 15 58 47 11 80    	mov    %edx,0x80114758
  struct buf *buf = bread(log.dev, log.start);
801031fd:	5a                   	pop    %edx
801031fe:	50                   	push   %eax
801031ff:	53                   	push   %ebx
80103200:	e8 cb ce ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103205:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103208:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010320b:	89 1d 68 47 11 80    	mov    %ebx,0x80114768
  for (i = 0; i < log.lh.n; i++) {
80103211:	85 db                	test   %ebx,%ebx
80103213:	7e 1d                	jle    80103232 <initlog+0x72>
80103215:	31 d2                	xor    %edx,%edx
80103217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80103220:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103224:	89 0c 95 6c 47 11 80 	mov    %ecx,-0x7feeb894(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010322b:	83 c2 01             	add    $0x1,%edx
8010322e:	39 d3                	cmp    %edx,%ebx
80103230:	75 ee                	jne    80103220 <initlog+0x60>
  brelse(buf);
80103232:	83 ec 0c             	sub    $0xc,%esp
80103235:	50                   	push   %eax
80103236:	e8 b5 cf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010323b:	e8 80 fe ff ff       	call   801030c0 <install_trans>
  log.lh.n = 0;
80103240:	c7 05 68 47 11 80 00 	movl   $0x0,0x80114768
80103247:	00 00 00 
  write_head(); // clear the log
8010324a:	e8 11 ff ff ff       	call   80103160 <write_head>
}
8010324f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103252:	83 c4 10             	add    $0x10,%esp
80103255:	c9                   	leave  
80103256:	c3                   	ret    
80103257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010325e:	66 90                	xchg   %ax,%ax

80103260 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103266:	68 20 47 11 80       	push   $0x80114720
8010326b:	e8 70 18 00 00       	call   80104ae0 <acquire>
80103270:	83 c4 10             	add    $0x10,%esp
80103273:	eb 18                	jmp    8010328d <begin_op+0x2d>
80103275:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103278:	83 ec 08             	sub    $0x8,%esp
8010327b:	68 20 47 11 80       	push   $0x80114720
80103280:	68 20 47 11 80       	push   $0x80114720
80103285:	e8 f6 12 00 00       	call   80104580 <sleep>
8010328a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010328d:	a1 60 47 11 80       	mov    0x80114760,%eax
80103292:	85 c0                	test   %eax,%eax
80103294:	75 e2                	jne    80103278 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103296:	a1 5c 47 11 80       	mov    0x8011475c,%eax
8010329b:	8b 15 68 47 11 80    	mov    0x80114768,%edx
801032a1:	83 c0 01             	add    $0x1,%eax
801032a4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801032a7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801032aa:	83 fa 1e             	cmp    $0x1e,%edx
801032ad:	7f c9                	jg     80103278 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801032af:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801032b2:	a3 5c 47 11 80       	mov    %eax,0x8011475c
      release(&log.lock);
801032b7:	68 20 47 11 80       	push   $0x80114720
801032bc:	e8 bf 17 00 00       	call   80104a80 <release>
      break;
    }
  }
}
801032c1:	83 c4 10             	add    $0x10,%esp
801032c4:	c9                   	leave  
801032c5:	c3                   	ret    
801032c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032cd:	8d 76 00             	lea    0x0(%esi),%esi

801032d0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	57                   	push   %edi
801032d4:	56                   	push   %esi
801032d5:	53                   	push   %ebx
801032d6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801032d9:	68 20 47 11 80       	push   $0x80114720
801032de:	e8 fd 17 00 00       	call   80104ae0 <acquire>
  log.outstanding -= 1;
801032e3:	a1 5c 47 11 80       	mov    0x8011475c,%eax
  if(log.committing)
801032e8:	8b 35 60 47 11 80    	mov    0x80114760,%esi
801032ee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801032f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801032f4:	89 1d 5c 47 11 80    	mov    %ebx,0x8011475c
  if(log.committing)
801032fa:	85 f6                	test   %esi,%esi
801032fc:	0f 85 22 01 00 00    	jne    80103424 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103302:	85 db                	test   %ebx,%ebx
80103304:	0f 85 f6 00 00 00    	jne    80103400 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010330a:	c7 05 60 47 11 80 01 	movl   $0x1,0x80114760
80103311:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103314:	83 ec 0c             	sub    $0xc,%esp
80103317:	68 20 47 11 80       	push   $0x80114720
8010331c:	e8 5f 17 00 00       	call   80104a80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103321:	8b 0d 68 47 11 80    	mov    0x80114768,%ecx
80103327:	83 c4 10             	add    $0x10,%esp
8010332a:	85 c9                	test   %ecx,%ecx
8010332c:	7f 42                	jg     80103370 <end_op+0xa0>
    acquire(&log.lock);
8010332e:	83 ec 0c             	sub    $0xc,%esp
80103331:	68 20 47 11 80       	push   $0x80114720
80103336:	e8 a5 17 00 00       	call   80104ae0 <acquire>
    wakeup(&log);
8010333b:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
    log.committing = 0;
80103342:	c7 05 60 47 11 80 00 	movl   $0x0,0x80114760
80103349:	00 00 00 
    wakeup(&log);
8010334c:	e8 ef 12 00 00       	call   80104640 <wakeup>
    release(&log.lock);
80103351:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80103358:	e8 23 17 00 00       	call   80104a80 <release>
8010335d:	83 c4 10             	add    $0x10,%esp
}
80103360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103363:	5b                   	pop    %ebx
80103364:	5e                   	pop    %esi
80103365:	5f                   	pop    %edi
80103366:	5d                   	pop    %ebp
80103367:	c3                   	ret    
80103368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103370:	a1 54 47 11 80       	mov    0x80114754,%eax
80103375:	83 ec 08             	sub    $0x8,%esp
80103378:	01 d8                	add    %ebx,%eax
8010337a:	83 c0 01             	add    $0x1,%eax
8010337d:	50                   	push   %eax
8010337e:	ff 35 64 47 11 80    	push   0x80114764
80103384:	e8 47 cd ff ff       	call   801000d0 <bread>
80103389:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010338b:	58                   	pop    %eax
8010338c:	5a                   	pop    %edx
8010338d:	ff 34 9d 6c 47 11 80 	push   -0x7feeb894(,%ebx,4)
80103394:	ff 35 64 47 11 80    	push   0x80114764
  for (tail = 0; tail < log.lh.n; tail++) {
8010339a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010339d:	e8 2e cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801033a2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801033a5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801033a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801033aa:	68 00 02 00 00       	push   $0x200
801033af:	50                   	push   %eax
801033b0:	8d 46 5c             	lea    0x5c(%esi),%eax
801033b3:	50                   	push   %eax
801033b4:	e8 87 18 00 00       	call   80104c40 <memmove>
    bwrite(to);  // write the log
801033b9:	89 34 24             	mov    %esi,(%esp)
801033bc:	e8 ef cd ff ff       	call   801001b0 <bwrite>
    brelse(from);
801033c1:	89 3c 24             	mov    %edi,(%esp)
801033c4:	e8 27 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
801033c9:	89 34 24             	mov    %esi,(%esp)
801033cc:	e8 1f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801033d1:	83 c4 10             	add    $0x10,%esp
801033d4:	3b 1d 68 47 11 80    	cmp    0x80114768,%ebx
801033da:	7c 94                	jl     80103370 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801033dc:	e8 7f fd ff ff       	call   80103160 <write_head>
    install_trans(); // Now install writes to home locations
801033e1:	e8 da fc ff ff       	call   801030c0 <install_trans>
    log.lh.n = 0;
801033e6:	c7 05 68 47 11 80 00 	movl   $0x0,0x80114768
801033ed:	00 00 00 
    write_head();    // Erase the transaction from the log
801033f0:	e8 6b fd ff ff       	call   80103160 <write_head>
801033f5:	e9 34 ff ff ff       	jmp    8010332e <end_op+0x5e>
801033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	68 20 47 11 80       	push   $0x80114720
80103408:	e8 33 12 00 00       	call   80104640 <wakeup>
  release(&log.lock);
8010340d:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80103414:	e8 67 16 00 00       	call   80104a80 <release>
80103419:	83 c4 10             	add    $0x10,%esp
}
8010341c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010341f:	5b                   	pop    %ebx
80103420:	5e                   	pop    %esi
80103421:	5f                   	pop    %edi
80103422:	5d                   	pop    %ebp
80103423:	c3                   	ret    
    panic("log.committing");
80103424:	83 ec 0c             	sub    $0xc,%esp
80103427:	68 a4 7f 10 80       	push   $0x80107fa4
8010342c:	e8 4f d0 ff ff       	call   80100480 <panic>
80103431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010343f:	90                   	nop

80103440 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	53                   	push   %ebx
80103444:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103447:	8b 15 68 47 11 80    	mov    0x80114768,%edx
{
8010344d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103450:	83 fa 1d             	cmp    $0x1d,%edx
80103453:	0f 8f 85 00 00 00    	jg     801034de <log_write+0x9e>
80103459:	a1 58 47 11 80       	mov    0x80114758,%eax
8010345e:	83 e8 01             	sub    $0x1,%eax
80103461:	39 c2                	cmp    %eax,%edx
80103463:	7d 79                	jge    801034de <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103465:	a1 5c 47 11 80       	mov    0x8011475c,%eax
8010346a:	85 c0                	test   %eax,%eax
8010346c:	7e 7d                	jle    801034eb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010346e:	83 ec 0c             	sub    $0xc,%esp
80103471:	68 20 47 11 80       	push   $0x80114720
80103476:	e8 65 16 00 00       	call   80104ae0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010347b:	8b 15 68 47 11 80    	mov    0x80114768,%edx
80103481:	83 c4 10             	add    $0x10,%esp
80103484:	85 d2                	test   %edx,%edx
80103486:	7e 4a                	jle    801034d2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103488:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010348b:	31 c0                	xor    %eax,%eax
8010348d:	eb 08                	jmp    80103497 <log_write+0x57>
8010348f:	90                   	nop
80103490:	83 c0 01             	add    $0x1,%eax
80103493:	39 c2                	cmp    %eax,%edx
80103495:	74 29                	je     801034c0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103497:	39 0c 85 6c 47 11 80 	cmp    %ecx,-0x7feeb894(,%eax,4)
8010349e:	75 f0                	jne    80103490 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801034a0:	89 0c 85 6c 47 11 80 	mov    %ecx,-0x7feeb894(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801034a7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801034aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801034ad:	c7 45 08 20 47 11 80 	movl   $0x80114720,0x8(%ebp)
}
801034b4:	c9                   	leave  
  release(&log.lock);
801034b5:	e9 c6 15 00 00       	jmp    80104a80 <release>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801034c0:	89 0c 95 6c 47 11 80 	mov    %ecx,-0x7feeb894(,%edx,4)
    log.lh.n++;
801034c7:	83 c2 01             	add    $0x1,%edx
801034ca:	89 15 68 47 11 80    	mov    %edx,0x80114768
801034d0:	eb d5                	jmp    801034a7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801034d2:	8b 43 08             	mov    0x8(%ebx),%eax
801034d5:	a3 6c 47 11 80       	mov    %eax,0x8011476c
  if (i == log.lh.n)
801034da:	75 cb                	jne    801034a7 <log_write+0x67>
801034dc:	eb e9                	jmp    801034c7 <log_write+0x87>
    panic("too big a transaction");
801034de:	83 ec 0c             	sub    $0xc,%esp
801034e1:	68 b3 7f 10 80       	push   $0x80107fb3
801034e6:	e8 95 cf ff ff       	call   80100480 <panic>
    panic("log_write outside of trans");
801034eb:	83 ec 0c             	sub    $0xc,%esp
801034ee:	68 c9 7f 10 80       	push   $0x80107fc9
801034f3:	e8 88 cf ff ff       	call   80100480 <panic>
801034f8:	66 90                	xchg   %ax,%ax
801034fa:	66 90                	xchg   %ax,%ax
801034fc:	66 90                	xchg   %ax,%ax
801034fe:	66 90                	xchg   %ax,%ax

80103500 <mpmain>:
    lapicinit();
    mpmain();
}

// Common CPU setup code.
static void mpmain(void) {
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	53                   	push   %ebx
80103504:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103507:	e8 84 09 00 00       	call   80103e90 <cpuid>
8010350c:	89 c3                	mov    %eax,%ebx
8010350e:	e8 7d 09 00 00       	call   80103e90 <cpuid>
80103513:	83 ec 04             	sub    $0x4,%esp
80103516:	53                   	push   %ebx
80103517:	50                   	push   %eax
80103518:	68 e4 7f 10 80       	push   $0x80107fe4
8010351d:	e8 be d2 ff ff       	call   801007e0 <cprintf>
    idtinit();       // load idt register
80103522:	e8 39 29 00 00       	call   80105e60 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103527:	e8 04 09 00 00       	call   80103e30 <mycpu>
8010352c:	89 c2                	mov    %eax,%edx

static inline uint xchg(volatile uint *addr, uint newval) {
    uint result;

    // The + in "+m" denotes a read-modify-write operand.
    asm volatile ("lock; xchgl %0, %1" :
8010352e:	b8 01 00 00 00       	mov    $0x1,%eax
80103533:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
8010353a:	e8 31 0c 00 00       	call   80104170 <scheduler>
8010353f:	90                   	nop

80103540 <mpenter>:
static void mpenter(void)  {
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	83 ec 08             	sub    $0x8,%esp
    switchkvm();
80103546:	e8 c5 3d 00 00       	call   80107310 <switchkvm>
    seginit();
8010354b:	e8 30 3d 00 00       	call   80107280 <seginit>
    lapicinit();
80103550:	e8 9b f7 ff ff       	call   80102cf0 <lapicinit>
    mpmain();
80103555:	e8 a6 ff ff ff       	call   80103500 <mpmain>
8010355a:	66 90                	xchg   %ax,%ax
8010355c:	66 90                	xchg   %ax,%ax
8010355e:	66 90                	xchg   %ax,%ax

80103560 <main>:
int main(void) {
80103560:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103564:	83 e4 f0             	and    $0xfffffff0,%esp
80103567:	ff 71 fc             	push   -0x4(%ecx)
8010356a:	55                   	push   %ebp
8010356b:	89 e5                	mov    %esp,%ebp
8010356d:	53                   	push   %ebx
8010356e:	51                   	push   %ecx
    kinit1(end, P2V(4 * 1024 * 1024)); // phys page allocator
8010356f:	83 ec 08             	sub    $0x8,%esp
80103572:	68 00 00 40 80       	push   $0x80400000
80103577:	68 50 85 11 80       	push   $0x80118550
8010357c:	e8 8f f5 ff ff       	call   80102b10 <kinit1>
    kvmalloc();      // kernel page table
80103581:	e8 7a 42 00 00       	call   80107800 <kvmalloc>
    mpinit();        // detect other processors
80103586:	e8 85 01 00 00       	call   80103710 <mpinit>
    lapicinit();     // interrupt controller
8010358b:	e8 60 f7 ff ff       	call   80102cf0 <lapicinit>
    seginit();       // segment descriptors
80103590:	e8 eb 3c 00 00       	call   80107280 <seginit>
    picinit();       // disable pic
80103595:	e8 76 03 00 00       	call   80103910 <picinit>
    ioapicinit();    // another interrupt controller
8010359a:	e8 31 f3 ff ff       	call   801028d0 <ioapicinit>
    consoleinit();   // console hardware
8010359f:	e8 4c d6 ff ff       	call   80100bf0 <consoleinit>
    uartinit();      // serial port
801035a4:	e8 a7 2b 00 00       	call   80106150 <uartinit>
    pinit();         // process table
801035a9:	e8 62 08 00 00       	call   80103e10 <pinit>
    tvinit();        // trap vectors
801035ae:	e8 2d 28 00 00       	call   80105de0 <tvinit>
    binit();         // buffer cache
801035b3:	e8 88 ca ff ff       	call   80100040 <binit>
    fileinit();      // file table
801035b8:	e8 d3 da ff ff       	call   80101090 <fileinit>
    ideinit();       // disk
801035bd:	e8 fe f0 ff ff       	call   801026c0 <ideinit>

    // Write entry code to unused memory at 0x7000.
    // The linker has placed the image of entryother.S in
    // _binary_entryother_start.
    code = P2V(0x7000);
    memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801035c2:	83 c4 0c             	add    $0xc,%esp
801035c5:	68 7a 00 00 00       	push   $0x7a
801035ca:	68 4c c5 10 80       	push   $0x8010c54c
801035cf:	68 00 70 00 80       	push   $0x80007000
801035d4:	e8 67 16 00 00       	call   80104c40 <memmove>

    for (c = cpus; c < cpus + ncpu; c++) {
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	69 05 04 48 11 80 b0 	imul   $0xb0,0x80114804,%eax
801035e3:	00 00 00 
801035e6:	05 20 48 11 80       	add    $0x80114820,%eax
801035eb:	3d 20 48 11 80       	cmp    $0x80114820,%eax
801035f0:	76 7e                	jbe    80103670 <main+0x110>
801035f2:	bb 20 48 11 80       	mov    $0x80114820,%ebx
801035f7:	eb 20                	jmp    80103619 <main+0xb9>
801035f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103600:	69 05 04 48 11 80 b0 	imul   $0xb0,0x80114804,%eax
80103607:	00 00 00 
8010360a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103610:	05 20 48 11 80       	add    $0x80114820,%eax
80103615:	39 c3                	cmp    %eax,%ebx
80103617:	73 57                	jae    80103670 <main+0x110>
        if (c == mycpu()) { // We've started already.
80103619:	e8 12 08 00 00       	call   80103e30 <mycpu>
8010361e:	39 c3                	cmp    %eax,%ebx
80103620:	74 de                	je     80103600 <main+0xa0>
        }

        // Tell entryother.S what stack to use, where to enter, and what
        // pgdir to use. We cannot use kpgdir yet, because the AP processor
        // is running in low  memory, so we use entrypgdir for the APs too.
        stack = kalloc();
80103622:	e8 59 f5 ff ff       	call   80102b80 <kalloc>
        *(void**)(code - 4) = stack + KSTACKSIZE;
        *(void(**)(void))(code - 8) = mpenter;
        *(int**)(code - 12) = (void *) V2P(entrypgdir);

        lapicstartap(c->apicid, V2P(code));
80103627:	83 ec 08             	sub    $0x8,%esp
        *(void(**)(void))(code - 8) = mpenter;
8010362a:	c7 05 f8 6f 00 80 40 	movl   $0x80103540,0x80006ff8
80103631:	35 10 80 
        *(int**)(code - 12) = (void *) V2P(entrypgdir);
80103634:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010363b:	a0 10 00 
        *(void**)(code - 4) = stack + KSTACKSIZE;
8010363e:	05 00 10 00 00       	add    $0x1000,%eax
80103643:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
        lapicstartap(c->apicid, V2P(code));
80103648:	0f b6 03             	movzbl (%ebx),%eax
8010364b:	68 00 70 00 00       	push   $0x7000
80103650:	50                   	push   %eax
80103651:	e8 ea f7 ff ff       	call   80102e40 <lapicstartap>

        // wait for cpu to finish mpmain()
        while (c->started == 0) {
80103656:	83 c4 10             	add    $0x10,%esp
80103659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103660:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103666:	85 c0                	test   %eax,%eax
80103668:	74 f6                	je     80103660 <main+0x100>
8010366a:	eb 94                	jmp    80103600 <main+0xa0>
8010366c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80103670:	83 ec 08             	sub    $0x8,%esp
80103673:	68 00 00 00 8e       	push   $0x8e000000
80103678:	68 00 00 40 80       	push   $0x80400000
8010367d:	e8 2e f4 ff ff       	call   80102ab0 <kinit2>
    userinit();      // first user process
80103682:	e8 59 08 00 00       	call   80103ee0 <userinit>
    mpmain();        // finish this processor's setup
80103687:	e8 74 fe ff ff       	call   80103500 <mpmain>
8010368c:	66 90                	xchg   %ax,%ax
8010368e:	66 90                	xchg   %ax,%ax

80103690 <mpsearch1>:
    }
    return sum;
}

// Look for an MP structure in the len bytes at addr.
static struct mp*mpsearch1(uint a, int len) {
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
    uchar *e, *p, *addr;

    addr = P2V(a);
80103695:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
static struct mp*mpsearch1(uint a, int len) {
8010369b:	53                   	push   %ebx
    e = addr + len;
8010369c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
static struct mp*mpsearch1(uint a, int len) {
8010369f:	83 ec 0c             	sub    $0xc,%esp
    for (p = addr; p < e; p += sizeof(struct mp)) {
801036a2:	39 de                	cmp    %ebx,%esi
801036a4:	72 10                	jb     801036b6 <mpsearch1+0x26>
801036a6:	eb 50                	jmp    801036f8 <mpsearch1+0x68>
801036a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036af:	90                   	nop
801036b0:	89 fe                	mov    %edi,%esi
801036b2:	39 fb                	cmp    %edi,%ebx
801036b4:	76 42                	jbe    801036f8 <mpsearch1+0x68>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) {
801036b6:	83 ec 04             	sub    $0x4,%esp
801036b9:	8d 7e 10             	lea    0x10(%esi),%edi
801036bc:	6a 04                	push   $0x4
801036be:	68 f8 7f 10 80       	push   $0x80107ff8
801036c3:	56                   	push   %esi
801036c4:	e8 27 15 00 00       	call   80104bf0 <memcmp>
801036c9:	83 c4 10             	add    $0x10,%esp
801036cc:	85 c0                	test   %eax,%eax
801036ce:	75 e0                	jne    801036b0 <mpsearch1+0x20>
801036d0:	89 f2                	mov    %esi,%edx
801036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sum += addr[i];
801036d8:	0f b6 0a             	movzbl (%edx),%ecx
    for (i = 0; i < len; i++) {
801036db:	83 c2 01             	add    $0x1,%edx
        sum += addr[i];
801036de:	01 c8                	add    %ecx,%eax
    for (i = 0; i < len; i++) {
801036e0:	39 fa                	cmp    %edi,%edx
801036e2:	75 f4                	jne    801036d8 <mpsearch1+0x48>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) {
801036e4:	84 c0                	test   %al,%al
801036e6:	75 c8                	jne    801036b0 <mpsearch1+0x20>
            return (struct mp*)p;
        }
    }
    return 0;
}
801036e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036eb:	89 f0                	mov    %esi,%eax
801036ed:	5b                   	pop    %ebx
801036ee:	5e                   	pop    %esi
801036ef:	5f                   	pop    %edi
801036f0:	5d                   	pop    %ebp
801036f1:	c3                   	ret    
801036f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801036fb:	31 f6                	xor    %esi,%esi
}
801036fd:	5b                   	pop    %ebx
801036fe:	89 f0                	mov    %esi,%eax
80103700:	5e                   	pop    %esi
80103701:	5f                   	pop    %edi
80103702:	5d                   	pop    %ebp
80103703:	c3                   	ret    
80103704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010370b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010370f:	90                   	nop

80103710 <mpinit>:
    }
    *pmp = mp;
    return conf;
}

void mpinit(void) {
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	57                   	push   %edi
80103714:	56                   	push   %esi
80103715:	53                   	push   %ebx
80103716:	83 ec 1c             	sub    $0x1c,%esp
    if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
80103719:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103720:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103727:	c1 e0 08             	shl    $0x8,%eax
8010372a:	09 d0                	or     %edx,%eax
8010372c:	c1 e0 04             	shl    $0x4,%eax
8010372f:	75 1b                	jne    8010374c <mpinit+0x3c>
        p = ((bda[0x14] << 8) | bda[0x13]) * 1024;
80103731:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103738:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010373f:	c1 e0 08             	shl    $0x8,%eax
80103742:	09 d0                	or     %edx,%eax
80103744:	c1 e0 0a             	shl    $0xa,%eax
        if ((mp = mpsearch1(p - 1024, 1024))) {
80103747:	2d 00 04 00 00       	sub    $0x400,%eax
        if ((mp = mpsearch1(p, 1024))) {
8010374c:	ba 00 04 00 00       	mov    $0x400,%edx
80103751:	e8 3a ff ff ff       	call   80103690 <mpsearch1>
80103756:	89 c3                	mov    %eax,%ebx
80103758:	85 c0                	test   %eax,%eax
8010375a:	0f 84 40 01 00 00    	je     801038a0 <mpinit+0x190>
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0) {
80103760:	8b 73 04             	mov    0x4(%ebx),%esi
80103763:	85 f6                	test   %esi,%esi
80103765:	0f 84 25 01 00 00    	je     80103890 <mpinit+0x180>
    if (memcmp(conf, "PCMP", 4) != 0) {
8010376b:	83 ec 04             	sub    $0x4,%esp
    conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010376e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
    if (memcmp(conf, "PCMP", 4) != 0) {
80103774:	6a 04                	push   $0x4
80103776:	68 fd 7f 10 80       	push   $0x80107ffd
8010377b:	50                   	push   %eax
    conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010377c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (memcmp(conf, "PCMP", 4) != 0) {
8010377f:	e8 6c 14 00 00       	call   80104bf0 <memcmp>
80103784:	83 c4 10             	add    $0x10,%esp
80103787:	85 c0                	test   %eax,%eax
80103789:	0f 85 01 01 00 00    	jne    80103890 <mpinit+0x180>
    if (conf->version != 1 && conf->version != 4) {
8010378f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103796:	3c 01                	cmp    $0x1,%al
80103798:	74 08                	je     801037a2 <mpinit+0x92>
8010379a:	3c 04                	cmp    $0x4,%al
8010379c:	0f 85 ee 00 00 00    	jne    80103890 <mpinit+0x180>
    if (sum((uchar*)conf, conf->length) != 0) {
801037a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
    for (i = 0; i < len; i++) {
801037a9:	66 85 d2             	test   %dx,%dx
801037ac:	74 22                	je     801037d0 <mpinit+0xc0>
801037ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801037b1:	89 f0                	mov    %esi,%eax
    sum = 0;
801037b3:	31 d2                	xor    %edx,%edx
801037b5:	8d 76 00             	lea    0x0(%esi),%esi
        sum += addr[i];
801037b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
    for (i = 0; i < len; i++) {
801037bf:	83 c0 01             	add    $0x1,%eax
        sum += addr[i];
801037c2:	01 ca                	add    %ecx,%edx
    for (i = 0; i < len; i++) {
801037c4:	39 c7                	cmp    %eax,%edi
801037c6:	75 f0                	jne    801037b8 <mpinit+0xa8>
    if (sum((uchar*)conf, conf->length) != 0) {
801037c8:	84 d2                	test   %dl,%dl
801037ca:	0f 85 c0 00 00 00    	jne    80103890 <mpinit+0x180>

    if ((conf = mpconfig(&mp)) == 0) {
        panic("Expect to run on an SMP");
    }
    ismp = 1;
    lapic = (uint*)conf->lapicaddr;
801037d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801037d6:	a3 00 47 11 80       	mov    %eax,0x80114700
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
801037db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801037e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
    ismp = 1;
801037e8:	be 01 00 00 00       	mov    $0x1,%esi
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
801037ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801037f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801037f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037f7:	90                   	nop
801037f8:	39 d0                	cmp    %edx,%eax
801037fa:	73 15                	jae    80103811 <mpinit+0x101>
        switch (*p) {
801037fc:	0f b6 08             	movzbl (%eax),%ecx
801037ff:	80 f9 02             	cmp    $0x2,%cl
80103802:	74 4c                	je     80103850 <mpinit+0x140>
80103804:	77 3a                	ja     80103840 <mpinit+0x130>
80103806:	84 c9                	test   %cl,%cl
80103808:	74 56                	je     80103860 <mpinit+0x150>
                p += sizeof(struct mpioapic);
                continue;
            case MPBUS:
            case MPIOINTR:
            case MPLINTR:
                p += 8;
8010380a:	83 c0 08             	add    $0x8,%eax
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
8010380d:	39 d0                	cmp    %edx,%eax
8010380f:	72 eb                	jb     801037fc <mpinit+0xec>
            default:
                ismp = 0;
                break;
        }
    }
    if (!ismp) {
80103811:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103814:	85 f6                	test   %esi,%esi
80103816:	0f 84 d9 00 00 00    	je     801038f5 <mpinit+0x1e5>
        panic("Didn't find a suitable machine");
    }

    if (mp->imcrp) {
8010381c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103820:	74 15                	je     80103837 <mpinit+0x127>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80103822:	b8 70 00 00 00       	mov    $0x70,%eax
80103827:	ba 22 00 00 00       	mov    $0x22,%edx
8010382c:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010382d:	ba 23 00 00 00       	mov    $0x23,%edx
80103832:	ec                   	in     (%dx),%al
        // Bochs doesn't support IMCR, so this doesn't run on Bochs.
        // But it would on real hardware.
        outb(0x22, 0x70);   // Select IMCR
        outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103833:	83 c8 01             	or     $0x1,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80103836:	ee                   	out    %al,(%dx)
    }
}
80103837:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010383a:	5b                   	pop    %ebx
8010383b:	5e                   	pop    %esi
8010383c:	5f                   	pop    %edi
8010383d:	5d                   	pop    %ebp
8010383e:	c3                   	ret    
8010383f:	90                   	nop
        switch (*p) {
80103840:	83 e9 03             	sub    $0x3,%ecx
80103843:	80 f9 01             	cmp    $0x1,%cl
80103846:	76 c2                	jbe    8010380a <mpinit+0xfa>
80103848:	31 f6                	xor    %esi,%esi
8010384a:	eb ac                	jmp    801037f8 <mpinit+0xe8>
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                ioapicid = ioapic->apicno;
80103850:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
                p += sizeof(struct mpioapic);
80103854:	83 c0 08             	add    $0x8,%eax
                ioapicid = ioapic->apicno;
80103857:	88 0d 00 48 11 80    	mov    %cl,0x80114800
                continue;
8010385d:	eb 99                	jmp    801037f8 <mpinit+0xe8>
8010385f:	90                   	nop
                if (ncpu < NCPU) {
80103860:	8b 0d 04 48 11 80    	mov    0x80114804,%ecx
80103866:	83 f9 07             	cmp    $0x7,%ecx
80103869:	7f 19                	jg     80103884 <mpinit+0x174>
                    cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010386b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103871:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
                    ncpu++;
80103875:	83 c1 01             	add    $0x1,%ecx
80103878:	89 0d 04 48 11 80    	mov    %ecx,0x80114804
                    cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010387e:	88 9f 20 48 11 80    	mov    %bl,-0x7feeb7e0(%edi)
                p += sizeof(struct mpproc);
80103884:	83 c0 14             	add    $0x14,%eax
                continue;
80103887:	e9 6c ff ff ff       	jmp    801037f8 <mpinit+0xe8>
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        panic("Expect to run on an SMP");
80103890:	83 ec 0c             	sub    $0xc,%esp
80103893:	68 02 80 10 80       	push   $0x80108002
80103898:	e8 e3 cb ff ff       	call   80100480 <panic>
8010389d:	8d 76 00             	lea    0x0(%esi),%esi
void mpinit(void) {
801038a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801038a5:	eb 13                	jmp    801038ba <mpinit+0x1aa>
801038a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ae:	66 90                	xchg   %ax,%ax
    for (p = addr; p < e; p += sizeof(struct mp)) {
801038b0:	89 f3                	mov    %esi,%ebx
801038b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801038b8:	74 d6                	je     80103890 <mpinit+0x180>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) {
801038ba:	83 ec 04             	sub    $0x4,%esp
801038bd:	8d 73 10             	lea    0x10(%ebx),%esi
801038c0:	6a 04                	push   $0x4
801038c2:	68 f8 7f 10 80       	push   $0x80107ff8
801038c7:	53                   	push   %ebx
801038c8:	e8 23 13 00 00       	call   80104bf0 <memcmp>
801038cd:	83 c4 10             	add    $0x10,%esp
801038d0:	85 c0                	test   %eax,%eax
801038d2:	75 dc                	jne    801038b0 <mpinit+0x1a0>
801038d4:	89 da                	mov    %ebx,%edx
801038d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038dd:	8d 76 00             	lea    0x0(%esi),%esi
        sum += addr[i];
801038e0:	0f b6 0a             	movzbl (%edx),%ecx
    for (i = 0; i < len; i++) {
801038e3:	83 c2 01             	add    $0x1,%edx
        sum += addr[i];
801038e6:	01 c8                	add    %ecx,%eax
    for (i = 0; i < len; i++) {
801038e8:	39 d6                	cmp    %edx,%esi
801038ea:	75 f4                	jne    801038e0 <mpinit+0x1d0>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) {
801038ec:	84 c0                	test   %al,%al
801038ee:	75 c0                	jne    801038b0 <mpinit+0x1a0>
801038f0:	e9 6b fe ff ff       	jmp    80103760 <mpinit+0x50>
        panic("Didn't find a suitable machine");
801038f5:	83 ec 0c             	sub    $0xc,%esp
801038f8:	68 1c 80 10 80       	push   $0x8010801c
801038fd:	e8 7e cb ff ff       	call   80100480 <panic>
80103902:	66 90                	xchg   %ax,%ax
80103904:	66 90                	xchg   %ax,%ax
80103906:	66 90                	xchg   %ax,%ax
80103908:	66 90                	xchg   %ax,%ax
8010390a:	66 90                	xchg   %ax,%ax
8010390c:	66 90                	xchg   %ax,%ax
8010390e:	66 90                	xchg   %ax,%ax

80103910 <picinit>:
80103910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103915:	ba 21 00 00 00       	mov    $0x21,%edx
8010391a:	ee                   	out    %al,(%dx)
8010391b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103920:	ee                   	out    %al,(%dx)
// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void picinit(void) {
    // mask all interrupts
    outb(IO_PIC1 + 1, 0xFF);
    outb(IO_PIC2 + 1, 0xFF);
}
80103921:	c3                   	ret    
80103922:	66 90                	xchg   %ax,%ax
80103924:	66 90                	xchg   %ax,%ax
80103926:	66 90                	xchg   %ax,%ax
80103928:	66 90                	xchg   %ax,%ax
8010392a:	66 90                	xchg   %ax,%ax
8010392c:	66 90                	xchg   %ax,%ax
8010392e:	66 90                	xchg   %ax,%ax

80103930 <cleanuppipealloc>:
    uint nwrite;    // number of bytes written
    int readopen;   // read fd is still open
    int writeopen;  // write fd is still open
};

void cleanuppipealloc(struct pipe *p, struct file **f0, struct file **f1) {
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	56                   	push   %esi
80103934:	8b 45 08             	mov    0x8(%ebp),%eax
80103937:	8b 75 0c             	mov    0xc(%ebp),%esi
8010393a:	53                   	push   %ebx
8010393b:	8b 5d 10             	mov    0x10(%ebp),%ebx
     if (p) {
8010393e:	85 c0                	test   %eax,%eax
80103940:	74 0c                	je     8010394e <cleanuppipealloc+0x1e>
        kfree((char*)p);
80103942:	83 ec 0c             	sub    $0xc,%esp
80103945:	50                   	push   %eax
80103946:	e8 75 f0 ff ff       	call   801029c0 <kfree>
8010394b:	83 c4 10             	add    $0x10,%esp
    }
    if (*f0) {
8010394e:	8b 06                	mov    (%esi),%eax
80103950:	85 c0                	test   %eax,%eax
80103952:	74 0c                	je     80103960 <cleanuppipealloc+0x30>
        fileclose(*f0);
80103954:	83 ec 0c             	sub    $0xc,%esp
80103957:	50                   	push   %eax
80103958:	e8 13 d8 ff ff       	call   80101170 <fileclose>
8010395d:	83 c4 10             	add    $0x10,%esp
    }
    if (*f1) {
80103960:	8b 03                	mov    (%ebx),%eax
80103962:	85 c0                	test   %eax,%eax
80103964:	74 12                	je     80103978 <cleanuppipealloc+0x48>
        fileclose(*f1);
80103966:	89 45 08             	mov    %eax,0x8(%ebp)
    }   
}
80103969:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010396c:	5b                   	pop    %ebx
8010396d:	5e                   	pop    %esi
8010396e:	5d                   	pop    %ebp
        fileclose(*f1);
8010396f:	e9 fc d7 ff ff       	jmp    80101170 <fileclose>
80103974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80103978:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010397b:	5b                   	pop    %ebx
8010397c:	5e                   	pop    %esi
8010397d:	5d                   	pop    %ebp
8010397e:	c3                   	ret    
8010397f:	90                   	nop

80103980 <pipealloc>:

int pipealloc(struct file **f0, struct file **f1) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	53                   	push   %ebx
80103986:	83 ec 0c             	sub    $0xc,%esp
80103989:	8b 75 08             	mov    0x8(%ebp),%esi
8010398c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    struct pipe *p;

    p = 0;
    *f0 = *f1 = 0;
8010398f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103995:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) {
8010399b:	e8 10 d7 ff ff       	call   801010b0 <filealloc>
801039a0:	89 06                	mov    %eax,(%esi)
801039a2:	85 c0                	test   %eax,%eax
801039a4:	0f 84 a5 00 00 00    	je     80103a4f <pipealloc+0xcf>
801039aa:	e8 01 d7 ff ff       	call   801010b0 <filealloc>
801039af:	89 07                	mov    %eax,(%edi)
801039b1:	85 c0                	test   %eax,%eax
801039b3:	0f 84 84 00 00 00    	je     80103a3d <pipealloc+0xbd>
        cleanuppipealloc(p, f0, f1);
        return -1;
    }
    if ((p = (struct pipe*)kalloc()) == 0) {
801039b9:	e8 c2 f1 ff ff       	call   80102b80 <kalloc>
801039be:	89 c3                	mov    %eax,%ebx
801039c0:	85 c0                	test   %eax,%eax
801039c2:	0f 84 a0 00 00 00    	je     80103a68 <pipealloc+0xe8>
        cleanuppipealloc(p, f0, f1);
        return -1;
    }
    p->readopen = 1;
801039c8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801039cf:	00 00 00 
    p->writeopen = 1;
    p->nwrite = 0;
    p->nread = 0;
    initlock(&p->lock, "pipe");
801039d2:	83 ec 08             	sub    $0x8,%esp
    p->writeopen = 1;
801039d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801039dc:	00 00 00 
    p->nwrite = 0;
801039df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801039e6:	00 00 00 
    p->nread = 0;
801039e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801039f0:	00 00 00 
    initlock(&p->lock, "pipe");
801039f3:	68 3b 80 10 80       	push   $0x8010803b
801039f8:	50                   	push   %eax
801039f9:	e8 12 0f 00 00       	call   80104910 <initlock>
    (*f0)->type = FD_PIPE;
801039fe:	8b 06                	mov    (%esi),%eax
    (*f0)->pipe = p;
    (*f1)->type = FD_PIPE;
    (*f1)->readable = 0;
    (*f1)->writable = 1;
    (*f1)->pipe = p;
    return 0;
80103a00:	83 c4 10             	add    $0x10,%esp
    (*f0)->type = FD_PIPE;
80103a03:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    (*f0)->readable = 1;
80103a09:	8b 06                	mov    (%esi),%eax
80103a0b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
    (*f0)->writable = 0;
80103a0f:	8b 06                	mov    (%esi),%eax
80103a11:	c6 40 09 00          	movb   $0x0,0x9(%eax)
    (*f0)->pipe = p;
80103a15:	8b 06                	mov    (%esi),%eax
80103a17:	89 58 0c             	mov    %ebx,0xc(%eax)
    (*f1)->type = FD_PIPE;
80103a1a:	8b 07                	mov    (%edi),%eax
80103a1c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    (*f1)->readable = 0;
80103a22:	8b 07                	mov    (%edi),%eax
80103a24:	c6 40 08 00          	movb   $0x0,0x8(%eax)
    (*f1)->writable = 1;
80103a28:	8b 07                	mov    (%edi),%eax
80103a2a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
    (*f1)->pipe = p;
80103a2e:	8b 07                	mov    (%edi),%eax
80103a30:	89 58 0c             	mov    %ebx,0xc(%eax)
    return 0;
80103a33:	31 c0                	xor    %eax,%eax
}
80103a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a38:	5b                   	pop    %ebx
80103a39:	5e                   	pop    %esi
80103a3a:	5f                   	pop    %edi
80103a3b:	5d                   	pop    %ebp
80103a3c:	c3                   	ret    
    if (*f0) {
80103a3d:	8b 06                	mov    (%esi),%eax
80103a3f:	85 c0                	test   %eax,%eax
80103a41:	74 1e                	je     80103a61 <pipealloc+0xe1>
        fileclose(*f0);
80103a43:	83 ec 0c             	sub    $0xc,%esp
80103a46:	50                   	push   %eax
80103a47:	e8 24 d7 ff ff       	call   80101170 <fileclose>
80103a4c:	83 c4 10             	add    $0x10,%esp
    if (*f1) {
80103a4f:	8b 07                	mov    (%edi),%eax
80103a51:	85 c0                	test   %eax,%eax
80103a53:	74 0c                	je     80103a61 <pipealloc+0xe1>
        fileclose(*f1);
80103a55:	83 ec 0c             	sub    $0xc,%esp
80103a58:	50                   	push   %eax
80103a59:	e8 12 d7 ff ff       	call   80101170 <fileclose>
80103a5e:	83 c4 10             	add    $0x10,%esp
        return -1;
80103a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a66:	eb cd                	jmp    80103a35 <pipealloc+0xb5>
    if (*f0) {
80103a68:	8b 06                	mov    (%esi),%eax
80103a6a:	85 c0                	test   %eax,%eax
80103a6c:	75 d5                	jne    80103a43 <pipealloc+0xc3>
80103a6e:	eb df                	jmp    80103a4f <pipealloc+0xcf>

80103a70 <pipeclose>:

void pipeclose(struct pipe *p, int writable) {
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	56                   	push   %esi
80103a74:	53                   	push   %ebx
80103a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a78:	8b 75 0c             	mov    0xc(%ebp),%esi
    acquire(&p->lock);
80103a7b:	83 ec 0c             	sub    $0xc,%esp
80103a7e:	53                   	push   %ebx
80103a7f:	e8 5c 10 00 00       	call   80104ae0 <acquire>
    if (writable) {
80103a84:	83 c4 10             	add    $0x10,%esp
80103a87:	85 f6                	test   %esi,%esi
80103a89:	74 65                	je     80103af0 <pipeclose+0x80>
        p->writeopen = 0;
        wakeup(&p->nread);
80103a8b:	83 ec 0c             	sub    $0xc,%esp
80103a8e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
        p->writeopen = 0;
80103a94:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103a9b:	00 00 00 
        wakeup(&p->nread);
80103a9e:	50                   	push   %eax
80103a9f:	e8 9c 0b 00 00       	call   80104640 <wakeup>
80103aa4:	83 c4 10             	add    $0x10,%esp
    }
    else {
        p->readopen = 0;
        wakeup(&p->nwrite);
    }
    if (p->readopen == 0 && p->writeopen == 0) {
80103aa7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103aad:	85 d2                	test   %edx,%edx
80103aaf:	75 0a                	jne    80103abb <pipeclose+0x4b>
80103ab1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103ab7:	85 c0                	test   %eax,%eax
80103ab9:	74 15                	je     80103ad0 <pipeclose+0x60>
        release(&p->lock);
        kfree((char*)p);
    }
    else {
        release(&p->lock);
80103abb:	89 5d 08             	mov    %ebx,0x8(%ebp)
    }
}
80103abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac1:	5b                   	pop    %ebx
80103ac2:	5e                   	pop    %esi
80103ac3:	5d                   	pop    %ebp
        release(&p->lock);
80103ac4:	e9 b7 0f 00 00       	jmp    80104a80 <release>
80103ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        release(&p->lock);
80103ad0:	83 ec 0c             	sub    $0xc,%esp
80103ad3:	53                   	push   %ebx
80103ad4:	e8 a7 0f 00 00       	call   80104a80 <release>
        kfree((char*)p);
80103ad9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103adc:	83 c4 10             	add    $0x10,%esp
}
80103adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae2:	5b                   	pop    %ebx
80103ae3:	5e                   	pop    %esi
80103ae4:	5d                   	pop    %ebp
        kfree((char*)p);
80103ae5:	e9 d6 ee ff ff       	jmp    801029c0 <kfree>
80103aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        wakeup(&p->nwrite);
80103af0:	83 ec 0c             	sub    $0xc,%esp
80103af3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
        p->readopen = 0;
80103af9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103b00:	00 00 00 
        wakeup(&p->nwrite);
80103b03:	50                   	push   %eax
80103b04:	e8 37 0b 00 00       	call   80104640 <wakeup>
80103b09:	83 c4 10             	add    $0x10,%esp
80103b0c:	eb 99                	jmp    80103aa7 <pipeclose+0x37>
80103b0e:	66 90                	xchg   %ax,%ax

80103b10 <pipewrite>:

int pipewrite(struct pipe *p, char *addr, int n) {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 28             	sub    $0x28,%esp
80103b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int i;

    acquire(&p->lock);
80103b1c:	53                   	push   %ebx
80103b1d:	e8 be 0f 00 00       	call   80104ae0 <acquire>
    for (i = 0; i < n; i++) {
80103b22:	8b 45 10             	mov    0x10(%ebp),%eax
80103b25:	83 c4 10             	add    $0x10,%esp
80103b28:	85 c0                	test   %eax,%eax
80103b2a:	0f 8e c0 00 00 00    	jle    80103bf0 <pipewrite+0xe0>
80103b30:	8b 45 0c             	mov    0xc(%ebp),%eax
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
80103b33:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
            if (p->readopen == 0 || myproc()->killed) {
                release(&p->lock);
                return -1;
            }
            wakeup(&p->nread);
80103b39:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103b3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b42:	03 45 10             	add    0x10(%ebp),%eax
80103b45:	89 45 e0             	mov    %eax,-0x20(%ebp)
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
80103b48:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
            sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b4e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
80103b54:	89 ca                	mov    %ecx,%edx
80103b56:	05 00 02 00 00       	add    $0x200,%eax
80103b5b:	39 c1                	cmp    %eax,%ecx
80103b5d:	74 3f                	je     80103b9e <pipewrite+0x8e>
80103b5f:	eb 67                	jmp    80103bc8 <pipewrite+0xb8>
80103b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (p->readopen == 0 || myproc()->killed) {
80103b68:	e8 43 03 00 00       	call   80103eb0 <myproc>
80103b6d:	8b 48 24             	mov    0x24(%eax),%ecx
80103b70:	85 c9                	test   %ecx,%ecx
80103b72:	75 34                	jne    80103ba8 <pipewrite+0x98>
            wakeup(&p->nread);
80103b74:	83 ec 0c             	sub    $0xc,%esp
80103b77:	57                   	push   %edi
80103b78:	e8 c3 0a 00 00       	call   80104640 <wakeup>
            sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b7d:	58                   	pop    %eax
80103b7e:	5a                   	pop    %edx
80103b7f:	53                   	push   %ebx
80103b80:	56                   	push   %esi
80103b81:	e8 fa 09 00 00       	call   80104580 <sleep>
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
80103b86:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103b8c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103b92:	83 c4 10             	add    $0x10,%esp
80103b95:	05 00 02 00 00       	add    $0x200,%eax
80103b9a:	39 c2                	cmp    %eax,%edx
80103b9c:	75 2a                	jne    80103bc8 <pipewrite+0xb8>
            if (p->readopen == 0 || myproc()->killed) {
80103b9e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	75 c0                	jne    80103b68 <pipewrite+0x58>
                release(&p->lock);
80103ba8:	83 ec 0c             	sub    $0xc,%esp
80103bab:	53                   	push   %ebx
80103bac:	e8 cf 0e 00 00       	call   80104a80 <release>
                return -1;
80103bb1:	83 c4 10             	add    $0x10,%esp
80103bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
    }
    wakeup(&p->nread);  //DOC: pipewrite-wakeup1
    release(&p->lock);
    return n;
}
80103bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bbc:	5b                   	pop    %ebx
80103bbd:	5e                   	pop    %esi
80103bbe:	5f                   	pop    %edi
80103bbf:	5d                   	pop    %ebp
80103bc0:	c3                   	ret    
80103bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103bc8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103bcb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103bce:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103bd4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103bda:	0f b6 06             	movzbl (%esi),%eax
    for (i = 0; i < n; i++) {
80103bdd:	83 c6 01             	add    $0x1,%esi
80103be0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103be3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
    for (i = 0; i < n; i++) {
80103be7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103bea:	0f 85 58 ff ff ff    	jne    80103b48 <pipewrite+0x38>
    wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103bf0:	83 ec 0c             	sub    $0xc,%esp
80103bf3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103bf9:	50                   	push   %eax
80103bfa:	e8 41 0a 00 00       	call   80104640 <wakeup>
    release(&p->lock);
80103bff:	89 1c 24             	mov    %ebx,(%esp)
80103c02:	e8 79 0e 00 00       	call   80104a80 <release>
    return n;
80103c07:	8b 45 10             	mov    0x10(%ebp),%eax
80103c0a:	83 c4 10             	add    $0x10,%esp
80103c0d:	eb aa                	jmp    80103bb9 <pipewrite+0xa9>
80103c0f:	90                   	nop

80103c10 <piperead>:

int piperead(struct pipe *p, char *addr, int n)     {
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	57                   	push   %edi
80103c14:	56                   	push   %esi
80103c15:	53                   	push   %ebx
80103c16:	83 ec 18             	sub    $0x18,%esp
80103c19:	8b 75 08             	mov    0x8(%ebp),%esi
80103c1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    int i;

    acquire(&p->lock);
80103c1f:	56                   	push   %esi
80103c20:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103c26:	e8 b5 0e 00 00       	call   80104ae0 <acquire>
    while (p->nread == p->nwrite && p->writeopen) { //DOC: pipe-empty
80103c2b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c31:	83 c4 10             	add    $0x10,%esp
80103c34:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103c3a:	74 2f                	je     80103c6b <piperead+0x5b>
80103c3c:	eb 37                	jmp    80103c75 <piperead+0x65>
80103c3e:	66 90                	xchg   %ax,%ax
        if (myproc()->killed) {
80103c40:	e8 6b 02 00 00       	call   80103eb0 <myproc>
80103c45:	8b 48 24             	mov    0x24(%eax),%ecx
80103c48:	85 c9                	test   %ecx,%ecx
80103c4a:	0f 85 80 00 00 00    	jne    80103cd0 <piperead+0xc0>
            release(&p->lock);
            return -1;
        }
        sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103c50:	83 ec 08             	sub    $0x8,%esp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
80103c55:	e8 26 09 00 00       	call   80104580 <sleep>
    while (p->nread == p->nwrite && p->writeopen) { //DOC: pipe-empty
80103c5a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103c60:	83 c4 10             	add    $0x10,%esp
80103c63:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103c69:	75 0a                	jne    80103c75 <piperead+0x65>
80103c6b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103c71:	85 c0                	test   %eax,%eax
80103c73:	75 cb                	jne    80103c40 <piperead+0x30>
    }
    for (i = 0; i < n; i++) {  //DOC: piperead-copy
80103c75:	8b 55 10             	mov    0x10(%ebp),%edx
80103c78:	31 db                	xor    %ebx,%ebx
80103c7a:	85 d2                	test   %edx,%edx
80103c7c:	7f 20                	jg     80103c9e <piperead+0x8e>
80103c7e:	eb 2c                	jmp    80103cac <piperead+0x9c>
        if (p->nread == p->nwrite) {
            break;
        }
        addr[i] = p->data[p->nread++ % PIPESIZE];
80103c80:	8d 48 01             	lea    0x1(%eax),%ecx
80103c83:	25 ff 01 00 00       	and    $0x1ff,%eax
80103c88:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103c8e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103c93:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    for (i = 0; i < n; i++) {  //DOC: piperead-copy
80103c96:	83 c3 01             	add    $0x1,%ebx
80103c99:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c9c:	74 0e                	je     80103cac <piperead+0x9c>
        if (p->nread == p->nwrite) {
80103c9e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ca4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103caa:	75 d4                	jne    80103c80 <piperead+0x70>
    }
    wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103cac:	83 ec 0c             	sub    $0xc,%esp
80103caf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103cb5:	50                   	push   %eax
80103cb6:	e8 85 09 00 00       	call   80104640 <wakeup>
    release(&p->lock);
80103cbb:	89 34 24             	mov    %esi,(%esp)
80103cbe:	e8 bd 0d 00 00       	call   80104a80 <release>
    return i;
80103cc3:	83 c4 10             	add    $0x10,%esp
}
80103cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cc9:	89 d8                	mov    %ebx,%eax
80103ccb:	5b                   	pop    %ebx
80103ccc:	5e                   	pop    %esi
80103ccd:	5f                   	pop    %edi
80103cce:	5d                   	pop    %ebp
80103ccf:	c3                   	ret    
            release(&p->lock);
80103cd0:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80103cd3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
            release(&p->lock);
80103cd8:	56                   	push   %esi
80103cd9:	e8 a2 0d 00 00       	call   80104a80 <release>
            return -1;
80103cde:	83 c4 10             	add    $0x10,%esp
}
80103ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ce4:	89 d8                	mov    %ebx,%eax
80103ce6:	5b                   	pop    %ebx
80103ce7:	5e                   	pop    %esi
80103ce8:	5f                   	pop    %edi
80103ce9:	5d                   	pop    %ebp
80103cea:	c3                   	ret    
80103ceb:	66 90                	xchg   %ax,%ax
80103ced:	66 90                	xchg   %ax,%ax
80103cef:	90                   	nop

80103cf0 <allocproc>:

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc* allocproc(void) {
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	53                   	push   %ebx
    char *sp;
    int found = 0;

    acquire(&ptable.lock);

    p = ptable.proc;
80103cf4:	bb d4 4d 11 80       	mov    $0x80114dd4,%ebx
static struct proc* allocproc(void) {
80103cf9:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
80103cfc:	68 a0 4d 11 80       	push   $0x80114da0
80103d01:	e8 da 0d 00 00       	call   80104ae0 <acquire>
80103d06:	83 c4 10             	add    $0x10,%esp
    while (p < &ptable.proc[NPROC] && !found) {
        if (p->state == UNUSED) {
80103d09:	8b 43 0c             	mov    0xc(%ebx),%eax
80103d0c:	85 c0                	test   %eax,%eax
80103d0e:	74 28                	je     80103d38 <allocproc+0x48>
            found = 1;
        }
        else {
            p++;
80103d10:	83 c3 7c             	add    $0x7c,%ebx
    while (p < &ptable.proc[NPROC] && !found) {
80103d13:	81 fb d4 6c 11 80    	cmp    $0x80116cd4,%ebx
80103d19:	75 ee                	jne    80103d09 <allocproc+0x19>
        }
       
    }
    if (!found) {    
        release(&ptable.lock);
80103d1b:	83 ec 0c             	sub    $0xc,%esp
        return 0;
80103d1e:	31 db                	xor    %ebx,%ebx
        release(&ptable.lock);
80103d20:	68 a0 4d 11 80       	push   $0x80114da0
80103d25:	e8 56 0d 00 00       	call   80104a80 <release>
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    return p;
}
80103d2a:	89 d8                	mov    %ebx,%eax
        return 0;
80103d2c:	83 c4 10             	add    $0x10,%esp
}
80103d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d32:	c9                   	leave  
80103d33:	c3                   	ret    
80103d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->pid = nextpid++;
80103d38:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    release(&ptable.lock);
80103d3d:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
80103d40:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
80103d47:	89 43 10             	mov    %eax,0x10(%ebx)
80103d4a:	8d 50 01             	lea    0x1(%eax),%edx
    release(&ptable.lock);
80103d4d:	68 a0 4d 11 80       	push   $0x80114da0
    p->pid = nextpid++;
80103d52:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    release(&ptable.lock);
80103d58:	e8 23 0d 00 00       	call   80104a80 <release>
    if ((p->kstack = kalloc()) == 0) {
80103d5d:	e8 1e ee ff ff       	call   80102b80 <kalloc>
80103d62:	83 c4 10             	add    $0x10,%esp
80103d65:	89 43 08             	mov    %eax,0x8(%ebx)
80103d68:	85 c0                	test   %eax,%eax
80103d6a:	74 3c                	je     80103da8 <allocproc+0xb8>
    sp -= sizeof *p->tf;
80103d6c:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(p->context, 0, sizeof *p->context);
80103d72:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103d75:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103d7a:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint*)sp = (uint)trapret;
80103d7d:	c7 40 14 d2 5d 10 80 	movl   $0x80105dd2,0x14(%eax)
    p->context = (struct context*)sp;
80103d84:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103d87:	6a 14                	push   $0x14
80103d89:	6a 00                	push   $0x0
80103d8b:	50                   	push   %eax
80103d8c:	e8 0f 0e 00 00       	call   80104ba0 <memset>
    p->context->eip = (uint)forkret;
80103d91:	8b 43 1c             	mov    0x1c(%ebx),%eax
    return p;
80103d94:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
80103d97:	c7 40 10 c0 3d 10 80 	movl   $0x80103dc0,0x10(%eax)
}
80103d9e:	89 d8                	mov    %ebx,%eax
80103da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103da3:	c9                   	leave  
80103da4:	c3                   	ret    
80103da5:	8d 76 00             	lea    0x0(%esi),%esi
        p->state = UNUSED;
80103da8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103daf:	31 db                	xor    %ebx,%ebx
}
80103db1:	89 d8                	mov    %ebx,%eax
80103db3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103db6:	c9                   	leave  
80103db7:	c3                   	ret    
80103db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dbf:	90                   	nop

80103dc0 <forkret>:
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103dc6:	68 a0 4d 11 80       	push   $0x80114da0
80103dcb:	e8 b0 0c 00 00       	call   80104a80 <release>

    if (first) {
80103dd0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103dd5:	83 c4 10             	add    $0x10,%esp
80103dd8:	85 c0                	test   %eax,%eax
80103dda:	75 04                	jne    80103de0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103ddc:	c9                   	leave  
80103ddd:	c3                   	ret    
80103dde:	66 90                	xchg   %ax,%ax
        first = 0;
80103de0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103de7:	00 00 00 
        iinit(ROOTDEV);
80103dea:	83 ec 0c             	sub    $0xc,%esp
80103ded:	6a 01                	push   $0x1
80103def:	e8 ec d9 ff ff       	call   801017e0 <iinit>
        initlog(ROOTDEV);
80103df4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103dfb:	e8 c0 f3 ff ff       	call   801031c0 <initlog>
}
80103e00:	83 c4 10             	add    $0x10,%esp
80103e03:	c9                   	leave  
80103e04:	c3                   	ret    
80103e05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e10 <pinit>:
void pinit(void) {
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103e16:	68 40 80 10 80       	push   $0x80108040
80103e1b:	68 a0 4d 11 80       	push   $0x80114da0
80103e20:	e8 eb 0a 00 00       	call   80104910 <initlock>
}
80103e25:	83 c4 10             	add    $0x10,%esp
80103e28:	c9                   	leave  
80103e29:	c3                   	ret    
80103e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e30 <mycpu>:
struct cpu*mycpu(void)  {
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
80103e35:	9c                   	pushf  
80103e36:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
80103e37:	f6 c4 02             	test   $0x2,%ah
80103e3a:	75 46                	jne    80103e82 <mycpu+0x52>
    apicid = lapicid();
80103e3c:	e8 af ef ff ff       	call   80102df0 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103e41:	8b 35 04 48 11 80    	mov    0x80114804,%esi
80103e47:	85 f6                	test   %esi,%esi
80103e49:	7e 2a                	jle    80103e75 <mycpu+0x45>
80103e4b:	31 d2                	xor    %edx,%edx
80103e4d:	eb 08                	jmp    80103e57 <mycpu+0x27>
80103e4f:	90                   	nop
80103e50:	83 c2 01             	add    $0x1,%edx
80103e53:	39 f2                	cmp    %esi,%edx
80103e55:	74 1e                	je     80103e75 <mycpu+0x45>
        if (cpus[i].apicid == apicid) {
80103e57:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103e5d:	0f b6 99 20 48 11 80 	movzbl -0x7feeb7e0(%ecx),%ebx
80103e64:	39 c3                	cmp    %eax,%ebx
80103e66:	75 e8                	jne    80103e50 <mycpu+0x20>
}
80103e68:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return &cpus[i];
80103e6b:	8d 81 20 48 11 80    	lea    -0x7feeb7e0(%ecx),%eax
}
80103e71:	5b                   	pop    %ebx
80103e72:	5e                   	pop    %esi
80103e73:	5d                   	pop    %ebp
80103e74:	c3                   	ret    
    panic("unknown apicid\n");
80103e75:	83 ec 0c             	sub    $0xc,%esp
80103e78:	68 47 80 10 80       	push   $0x80108047
80103e7d:	e8 fe c5 ff ff       	call   80100480 <panic>
        panic("mycpu called with interrupts enabled\n");
80103e82:	83 ec 0c             	sub    $0xc,%esp
80103e85:	68 24 81 10 80       	push   $0x80108124
80103e8a:	e8 f1 c5 ff ff       	call   80100480 <panic>
80103e8f:	90                   	nop

80103e90 <cpuid>:
int cpuid() {
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103e96:	e8 95 ff ff ff       	call   80103e30 <mycpu>
}
80103e9b:	c9                   	leave  
    return mycpu() - cpus;
80103e9c:	2d 20 48 11 80       	sub    $0x80114820,%eax
80103ea1:	c1 f8 04             	sar    $0x4,%eax
80103ea4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103eaa:	c3                   	ret    
80103eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eaf:	90                   	nop

80103eb0 <myproc>:
struct proc*myproc(void)  {
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103eb7:	e8 d4 0a 00 00       	call   80104990 <pushcli>
    c = mycpu();
80103ebc:	e8 6f ff ff ff       	call   80103e30 <mycpu>
    p = c->proc;
80103ec1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ec7:	e8 14 0b 00 00       	call   801049e0 <popcli>
}
80103ecc:	89 d8                	mov    %ebx,%eax
80103ece:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed1:	c9                   	leave  
80103ed2:	c3                   	ret    
80103ed3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ee0 <userinit>:
void userinit(void) {
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	53                   	push   %ebx
80103ee4:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80103ee7:	e8 04 fe ff ff       	call   80103cf0 <allocproc>
80103eec:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103eee:	a3 d4 6c 11 80       	mov    %eax,0x80116cd4
    if ((p->pgdir = setupkvm()) == 0) {
80103ef3:	e8 88 38 00 00       	call   80107780 <setupkvm>
80103ef8:	89 43 04             	mov    %eax,0x4(%ebx)
80103efb:	85 c0                	test   %eax,%eax
80103efd:	0f 84 bd 00 00 00    	je     80103fc0 <userinit+0xe0>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f03:	83 ec 04             	sub    $0x4,%esp
80103f06:	68 2c 00 00 00       	push   $0x2c
80103f0b:	68 20 c5 10 80       	push   $0x8010c520
80103f10:	50                   	push   %eax
80103f11:	e8 1a 35 00 00       	call   80107430 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103f16:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103f19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103f1f:	6a 4c                	push   $0x4c
80103f21:	6a 00                	push   $0x0
80103f23:	ff 73 18             	push   0x18(%ebx)
80103f26:	e8 75 0c 00 00       	call   80104ba0 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103f2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103f33:	83 c4 0c             	add    $0xc,%esp
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f36:	b9 23 00 00 00       	mov    $0x23,%ecx
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103f46:	8b 43 18             	mov    0x18(%ebx),%eax
80103f49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f4d:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103f51:	8b 43 18             	mov    0x18(%ebx),%eax
80103f54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f58:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103f5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103f5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103f66:	8b 43 18             	mov    0x18(%ebx),%eax
80103f69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103f70:	8b 43 18             	mov    0x18(%ebx),%eax
80103f73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103f7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f7d:	6a 10                	push   $0x10
80103f7f:	68 70 80 10 80       	push   $0x80108070
80103f84:	50                   	push   %eax
80103f85:	e8 d6 0d 00 00       	call   80104d60 <safestrcpy>
    p->cwd = namei("/");
80103f8a:	c7 04 24 79 80 10 80 	movl   $0x80108079,(%esp)
80103f91:	e8 8a e3 ff ff       	call   80102320 <namei>
80103f96:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103f99:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
80103fa0:	e8 3b 0b 00 00       	call   80104ae0 <acquire>
    p->state = RUNNABLE;
80103fa5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103fac:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
80103fb3:	e8 c8 0a 00 00       	call   80104a80 <release>
}
80103fb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fbb:	83 c4 10             	add    $0x10,%esp
80103fbe:	c9                   	leave  
80103fbf:	c3                   	ret    
        panic("userinit: out of memory?");
80103fc0:	83 ec 0c             	sub    $0xc,%esp
80103fc3:	68 57 80 10 80       	push   $0x80108057
80103fc8:	e8 b3 c4 ff ff       	call   80100480 <panic>
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi

80103fd0 <growproc>:
int growproc(int n) {
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
80103fd5:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103fd8:	e8 b3 09 00 00       	call   80104990 <pushcli>
    c = mycpu();
80103fdd:	e8 4e fe ff ff       	call   80103e30 <mycpu>
    p = c->proc;
80103fe2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103fe8:	e8 f3 09 00 00       	call   801049e0 <popcli>
    sz = curproc->sz;
80103fed:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103fef:	85 f6                	test   %esi,%esi
80103ff1:	7f 1d                	jg     80104010 <growproc+0x40>
    else if (n < 0) {
80103ff3:	75 3b                	jne    80104030 <growproc+0x60>
    switchuvm(curproc);
80103ff5:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103ff8:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103ffa:	53                   	push   %ebx
80103ffb:	e8 20 33 00 00       	call   80107320 <switchuvm>
    return 0;
80104000:	83 c4 10             	add    $0x10,%esp
80104003:	31 c0                	xor    %eax,%eax
}
80104005:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104008:	5b                   	pop    %ebx
80104009:	5e                   	pop    %esi
8010400a:	5d                   	pop    %ebp
8010400b:	c3                   	ret    
8010400c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0) {
80104010:	83 ec 04             	sub    $0x4,%esp
80104013:	01 c6                	add    %eax,%esi
80104015:	56                   	push   %esi
80104016:	50                   	push   %eax
80104017:	ff 73 04             	push   0x4(%ebx)
8010401a:	e8 81 35 00 00       	call   801075a0 <allocuvm>
8010401f:	83 c4 10             	add    $0x10,%esp
80104022:	85 c0                	test   %eax,%eax
80104024:	75 cf                	jne    80103ff5 <growproc+0x25>
            return -1;
80104026:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010402b:	eb d8                	jmp    80104005 <growproc+0x35>
8010402d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0) {
80104030:	83 ec 04             	sub    $0x4,%esp
80104033:	01 c6                	add    %eax,%esi
80104035:	56                   	push   %esi
80104036:	50                   	push   %eax
80104037:	ff 73 04             	push   0x4(%ebx)
8010403a:	e8 91 36 00 00       	call   801076d0 <deallocuvm>
8010403f:	83 c4 10             	add    $0x10,%esp
80104042:	85 c0                	test   %eax,%eax
80104044:	75 af                	jne    80103ff5 <growproc+0x25>
80104046:	eb de                	jmp    80104026 <growproc+0x56>
80104048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010404f:	90                   	nop

80104050 <fork>:
int fork(void) {
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80104059:	e8 32 09 00 00       	call   80104990 <pushcli>
    c = mycpu();
8010405e:	e8 cd fd ff ff       	call   80103e30 <mycpu>
    p = c->proc;
80104063:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104069:	e8 72 09 00 00       	call   801049e0 <popcli>
    if ((np = allocproc()) == 0) {
8010406e:	e8 7d fc ff ff       	call   80103cf0 <allocproc>
80104073:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104076:	85 c0                	test   %eax,%eax
80104078:	0f 84 b7 00 00 00    	je     80104135 <fork+0xe5>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
8010407e:	83 ec 08             	sub    $0x8,%esp
80104081:	ff 33                	push   (%ebx)
80104083:	89 c7                	mov    %eax,%edi
80104085:	ff 73 04             	push   0x4(%ebx)
80104088:	e8 e3 37 00 00       	call   80107870 <copyuvm>
8010408d:	83 c4 10             	add    $0x10,%esp
80104090:	89 47 04             	mov    %eax,0x4(%edi)
80104093:	85 c0                	test   %eax,%eax
80104095:	0f 84 a1 00 00 00    	je     8010413c <fork+0xec>
    np->sz = curproc->sz;
8010409b:	8b 03                	mov    (%ebx),%eax
8010409d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040a0:	89 01                	mov    %eax,(%ecx)
    *np->tf = *curproc->tf;
801040a2:	8b 79 18             	mov    0x18(%ecx),%edi
    np->parent = curproc;
801040a5:	89 c8                	mov    %ecx,%eax
801040a7:	89 59 14             	mov    %ebx,0x14(%ecx)
    *np->tf = *curproc->tf;
801040aa:	b9 13 00 00 00       	mov    $0x13,%ecx
801040af:	8b 73 18             	mov    0x18(%ebx),%esi
801040b2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++) {
801040b4:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
801040b6:	8b 40 18             	mov    0x18(%eax),%eax
801040b9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        if (curproc->ofile[i]) {
801040c0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801040c4:	85 c0                	test   %eax,%eax
801040c6:	74 13                	je     801040db <fork+0x8b>
            np->ofile[i] = filedup(curproc->ofile[i]);
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	50                   	push   %eax
801040cc:	e8 4f d0 ff ff       	call   80101120 <filedup>
801040d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040d4:	83 c4 10             	add    $0x10,%esp
801040d7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++) {
801040db:	83 c6 01             	add    $0x1,%esi
801040de:	83 fe 10             	cmp    $0x10,%esi
801040e1:	75 dd                	jne    801040c0 <fork+0x70>
    np->cwd = idup(curproc->cwd);
801040e3:	83 ec 0c             	sub    $0xc,%esp
801040e6:	ff 73 68             	push   0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040e9:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
801040ec:	e8 df d8 ff ff       	call   801019d0 <idup>
801040f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040f4:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
801040f7:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040fa:	8d 47 6c             	lea    0x6c(%edi),%eax
801040fd:	6a 10                	push   $0x10
801040ff:	53                   	push   %ebx
80104100:	50                   	push   %eax
80104101:	e8 5a 0c 00 00       	call   80104d60 <safestrcpy>
    pid = np->pid;
80104106:	8b 5f 10             	mov    0x10(%edi),%ebx
    acquire(&ptable.lock);
80104109:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
80104110:	e8 cb 09 00 00       	call   80104ae0 <acquire>
    np->state = RUNNABLE;
80104115:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
8010411c:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
80104123:	e8 58 09 00 00       	call   80104a80 <release>
    return pid;
80104128:	83 c4 10             	add    $0x10,%esp
}
8010412b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010412e:	89 d8                	mov    %ebx,%eax
80104130:	5b                   	pop    %ebx
80104131:	5e                   	pop    %esi
80104132:	5f                   	pop    %edi
80104133:	5d                   	pop    %ebp
80104134:	c3                   	ret    
        return -1;
80104135:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010413a:	eb ef                	jmp    8010412b <fork+0xdb>
        kfree(np->kstack);
8010413c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010413f:	83 ec 0c             	sub    $0xc,%esp
80104142:	ff 73 08             	push   0x8(%ebx)
80104145:	e8 76 e8 ff ff       	call   801029c0 <kfree>
        np->kstack = 0;
8010414a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        return -1;
80104151:	83 c4 10             	add    $0x10,%esp
        np->state = UNUSED;
80104154:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
8010415b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104160:	eb c9                	jmp    8010412b <fork+0xdb>
80104162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104170 <scheduler>:
void scheduler(void) {
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	57                   	push   %edi
80104174:	56                   	push   %esi
80104175:	53                   	push   %ebx
80104176:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
80104179:	e8 b2 fc ff ff       	call   80103e30 <mycpu>
    c->proc = 0;
8010417e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104185:	00 00 00 
    struct cpu *c = mycpu();
80104188:	89 c6                	mov    %eax,%esi
    c->proc = 0;
8010418a:	8d 78 04             	lea    0x4(%eax),%edi
8010418d:	8d 76 00             	lea    0x0(%esi),%esi
    asm volatile ("sti");
80104190:	fb                   	sti    
        acquire(&ptable.lock);
80104191:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104194:	bb d4 4d 11 80       	mov    $0x80114dd4,%ebx
        acquire(&ptable.lock);
80104199:	68 a0 4d 11 80       	push   $0x80114da0
8010419e:	e8 3d 09 00 00       	call   80104ae0 <acquire>
801041a3:	83 c4 10             	add    $0x10,%esp
801041a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ad:	8d 76 00             	lea    0x0(%esi),%esi
            if (p->state != RUNNABLE) {
801041b0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041b4:	75 33                	jne    801041e9 <scheduler+0x79>
            switchuvm(p);
801041b6:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
801041b9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
801041bf:	53                   	push   %ebx
801041c0:	e8 5b 31 00 00       	call   80107320 <switchuvm>
            swtch(&(c->scheduler), p->context);
801041c5:	58                   	pop    %eax
801041c6:	5a                   	pop    %edx
801041c7:	ff 73 1c             	push   0x1c(%ebx)
801041ca:	57                   	push   %edi
            p->state = RUNNING;
801041cb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
801041d2:	e8 e4 0b 00 00       	call   80104dbb <swtch>
            switchkvm();
801041d7:	e8 34 31 00 00       	call   80107310 <switchkvm>
            c->proc = 0;
801041dc:	83 c4 10             	add    $0x10,%esp
801041df:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801041e6:	00 00 00 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041e9:	83 c3 7c             	add    $0x7c,%ebx
801041ec:	81 fb d4 6c 11 80    	cmp    $0x80116cd4,%ebx
801041f2:	75 bc                	jne    801041b0 <scheduler+0x40>
        release(&ptable.lock);
801041f4:	83 ec 0c             	sub    $0xc,%esp
801041f7:	68 a0 4d 11 80       	push   $0x80114da0
801041fc:	e8 7f 08 00 00       	call   80104a80 <release>
        sti();
80104201:	83 c4 10             	add    $0x10,%esp
80104204:	eb 8a                	jmp    80104190 <scheduler+0x20>
80104206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420d:	8d 76 00             	lea    0x0(%esi),%esi

80104210 <sched>:
void sched(void) {
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	56                   	push   %esi
80104214:	53                   	push   %ebx
    pushcli();
80104215:	e8 76 07 00 00       	call   80104990 <pushcli>
    c = mycpu();
8010421a:	e8 11 fc ff ff       	call   80103e30 <mycpu>
    p = c->proc;
8010421f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104225:	e8 b6 07 00 00       	call   801049e0 <popcli>
    if (!holding(&ptable.lock)) {
8010422a:	83 ec 0c             	sub    $0xc,%esp
8010422d:	68 a0 4d 11 80       	push   $0x80114da0
80104232:	e8 09 08 00 00       	call   80104a40 <holding>
80104237:	83 c4 10             	add    $0x10,%esp
8010423a:	85 c0                	test   %eax,%eax
8010423c:	74 4f                	je     8010428d <sched+0x7d>
    if (mycpu()->ncli != 1) {
8010423e:	e8 ed fb ff ff       	call   80103e30 <mycpu>
80104243:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010424a:	75 68                	jne    801042b4 <sched+0xa4>
    if (p->state == RUNNING) {
8010424c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104250:	74 55                	je     801042a7 <sched+0x97>
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
80104252:	9c                   	pushf  
80104253:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
80104254:	f6 c4 02             	test   $0x2,%ah
80104257:	75 41                	jne    8010429a <sched+0x8a>
    intena = mycpu()->intena;
80104259:	e8 d2 fb ff ff       	call   80103e30 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
8010425e:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
80104261:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
80104267:	e8 c4 fb ff ff       	call   80103e30 <mycpu>
8010426c:	83 ec 08             	sub    $0x8,%esp
8010426f:	ff 70 04             	push   0x4(%eax)
80104272:	53                   	push   %ebx
80104273:	e8 43 0b 00 00       	call   80104dbb <swtch>
    mycpu()->intena = intena;
80104278:	e8 b3 fb ff ff       	call   80103e30 <mycpu>
}
8010427d:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80104280:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104286:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104289:	5b                   	pop    %ebx
8010428a:	5e                   	pop    %esi
8010428b:	5d                   	pop    %ebp
8010428c:	c3                   	ret    
        panic("sched ptable.lock");
8010428d:	83 ec 0c             	sub    $0xc,%esp
80104290:	68 7b 80 10 80       	push   $0x8010807b
80104295:	e8 e6 c1 ff ff       	call   80100480 <panic>
        panic("sched interruptible");
8010429a:	83 ec 0c             	sub    $0xc,%esp
8010429d:	68 a7 80 10 80       	push   $0x801080a7
801042a2:	e8 d9 c1 ff ff       	call   80100480 <panic>
        panic("sched running");
801042a7:	83 ec 0c             	sub    $0xc,%esp
801042aa:	68 99 80 10 80       	push   $0x80108099
801042af:	e8 cc c1 ff ff       	call   80100480 <panic>
        panic("sched locks");
801042b4:	83 ec 0c             	sub    $0xc,%esp
801042b7:	68 8d 80 10 80       	push   $0x8010808d
801042bc:	e8 bf c1 ff ff       	call   80100480 <panic>
801042c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042cf:	90                   	nop

801042d0 <exit>:
void exit(void)  {
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	57                   	push   %edi
801042d4:	56                   	push   %esi
801042d5:	53                   	push   %ebx
801042d6:	83 ec 0c             	sub    $0xc,%esp
    struct proc *curproc = myproc();
801042d9:	e8 d2 fb ff ff       	call   80103eb0 <myproc>
    if (curproc == initproc) {
801042de:	39 05 d4 6c 11 80    	cmp    %eax,0x80116cd4
801042e4:	0f 84 fd 00 00 00    	je     801043e7 <exit+0x117>
801042ea:	89 c3                	mov    %eax,%ebx
801042ec:	8d 70 28             	lea    0x28(%eax),%esi
801042ef:	8d 78 68             	lea    0x68(%eax),%edi
801042f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (curproc->ofile[fd]) {
801042f8:	8b 06                	mov    (%esi),%eax
801042fa:	85 c0                	test   %eax,%eax
801042fc:	74 12                	je     80104310 <exit+0x40>
            fileclose(curproc->ofile[fd]);
801042fe:	83 ec 0c             	sub    $0xc,%esp
80104301:	50                   	push   %eax
80104302:	e8 69 ce ff ff       	call   80101170 <fileclose>
            curproc->ofile[fd] = 0;
80104307:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010430d:	83 c4 10             	add    $0x10,%esp
    for (fd = 0; fd < NOFILE; fd++) {
80104310:	83 c6 04             	add    $0x4,%esi
80104313:	39 f7                	cmp    %esi,%edi
80104315:	75 e1                	jne    801042f8 <exit+0x28>
    begin_op();
80104317:	e8 44 ef ff ff       	call   80103260 <begin_op>
    iput(curproc->cwd);
8010431c:	83 ec 0c             	sub    $0xc,%esp
8010431f:	ff 73 68             	push   0x68(%ebx)
80104322:	e8 09 d8 ff ff       	call   80101b30 <iput>
    end_op();
80104327:	e8 a4 ef ff ff       	call   801032d0 <end_op>
    curproc->cwd = 0;
8010432c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
    acquire(&ptable.lock);
80104333:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
8010433a:	e8 a1 07 00 00       	call   80104ae0 <acquire>
    wakeup1(curproc->parent);
8010433f:	8b 53 14             	mov    0x14(%ebx),%edx
80104342:	83 c4 10             	add    $0x10,%esp
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104345:	b8 d4 4d 11 80       	mov    $0x80114dd4,%eax
8010434a:	eb 0e                	jmp    8010435a <exit+0x8a>
8010434c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104350:	83 c0 7c             	add    $0x7c,%eax
80104353:	3d d4 6c 11 80       	cmp    $0x80116cd4,%eax
80104358:	74 1c                	je     80104376 <exit+0xa6>
        if (p->state == SLEEPING && p->chan == chan) {
8010435a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010435e:	75 f0                	jne    80104350 <exit+0x80>
80104360:	3b 50 20             	cmp    0x20(%eax),%edx
80104363:	75 eb                	jne    80104350 <exit+0x80>
            p->state = RUNNABLE;
80104365:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010436c:	83 c0 7c             	add    $0x7c,%eax
8010436f:	3d d4 6c 11 80       	cmp    $0x80116cd4,%eax
80104374:	75 e4                	jne    8010435a <exit+0x8a>
            p->parent = initproc;
80104376:	8b 0d d4 6c 11 80    	mov    0x80116cd4,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010437c:	ba d4 4d 11 80       	mov    $0x80114dd4,%edx
80104381:	eb 10                	jmp    80104393 <exit+0xc3>
80104383:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104387:	90                   	nop
80104388:	83 c2 7c             	add    $0x7c,%edx
8010438b:	81 fa d4 6c 11 80    	cmp    $0x80116cd4,%edx
80104391:	74 3b                	je     801043ce <exit+0xfe>
        if (p->parent == curproc) {
80104393:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104396:	75 f0                	jne    80104388 <exit+0xb8>
            if (p->state == ZOMBIE) {
80104398:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
8010439c:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE) {
8010439f:	75 e7                	jne    80104388 <exit+0xb8>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043a1:	b8 d4 4d 11 80       	mov    $0x80114dd4,%eax
801043a6:	eb 12                	jmp    801043ba <exit+0xea>
801043a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043af:	90                   	nop
801043b0:	83 c0 7c             	add    $0x7c,%eax
801043b3:	3d d4 6c 11 80       	cmp    $0x80116cd4,%eax
801043b8:	74 ce                	je     80104388 <exit+0xb8>
        if (p->state == SLEEPING && p->chan == chan) {
801043ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043be:	75 f0                	jne    801043b0 <exit+0xe0>
801043c0:	3b 48 20             	cmp    0x20(%eax),%ecx
801043c3:	75 eb                	jne    801043b0 <exit+0xe0>
            p->state = RUNNABLE;
801043c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801043cc:	eb e2                	jmp    801043b0 <exit+0xe0>
    curproc->state = ZOMBIE;
801043ce:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
    sched();
801043d5:	e8 36 fe ff ff       	call   80104210 <sched>
    panic("zombie exit");
801043da:	83 ec 0c             	sub    $0xc,%esp
801043dd:	68 c8 80 10 80       	push   $0x801080c8
801043e2:	e8 99 c0 ff ff       	call   80100480 <panic>
        panic("init exiting");
801043e7:	83 ec 0c             	sub    $0xc,%esp
801043ea:	68 bb 80 10 80       	push   $0x801080bb
801043ef:	e8 8c c0 ff ff       	call   80100480 <panic>
801043f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043ff:	90                   	nop

80104400 <wait>:
int wait(void) {
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	56                   	push   %esi
80104404:	53                   	push   %ebx
    pushcli();
80104405:	e8 86 05 00 00       	call   80104990 <pushcli>
    c = mycpu();
8010440a:	e8 21 fa ff ff       	call   80103e30 <mycpu>
    p = c->proc;
8010440f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104415:	e8 c6 05 00 00       	call   801049e0 <popcli>
    acquire(&ptable.lock);
8010441a:	83 ec 0c             	sub    $0xc,%esp
8010441d:	68 a0 4d 11 80       	push   $0x80114da0
80104422:	e8 b9 06 00 00       	call   80104ae0 <acquire>
80104427:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
8010442a:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010442c:	bb d4 4d 11 80       	mov    $0x80114dd4,%ebx
80104431:	eb 10                	jmp    80104443 <wait+0x43>
80104433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104437:	90                   	nop
80104438:	83 c3 7c             	add    $0x7c,%ebx
8010443b:	81 fb d4 6c 11 80    	cmp    $0x80116cd4,%ebx
80104441:	74 1b                	je     8010445e <wait+0x5e>
            if (p->parent != curproc) {
80104443:	39 73 14             	cmp    %esi,0x14(%ebx)
80104446:	75 f0                	jne    80104438 <wait+0x38>
            if (p->state == ZOMBIE) {
80104448:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010444c:	74 62                	je     801044b0 <wait+0xb0>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010444e:	83 c3 7c             	add    $0x7c,%ebx
            havekids = 1;
80104451:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104456:	81 fb d4 6c 11 80    	cmp    $0x80116cd4,%ebx
8010445c:	75 e5                	jne    80104443 <wait+0x43>
        if (!havekids || curproc->killed) {
8010445e:	85 c0                	test   %eax,%eax
80104460:	0f 84 a0 00 00 00    	je     80104506 <wait+0x106>
80104466:	8b 46 24             	mov    0x24(%esi),%eax
80104469:	85 c0                	test   %eax,%eax
8010446b:	0f 85 95 00 00 00    	jne    80104506 <wait+0x106>
    pushcli();
80104471:	e8 1a 05 00 00       	call   80104990 <pushcli>
    c = mycpu();
80104476:	e8 b5 f9 ff ff       	call   80103e30 <mycpu>
    p = c->proc;
8010447b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104481:	e8 5a 05 00 00       	call   801049e0 <popcli>
    if (p == 0) {
80104486:	85 db                	test   %ebx,%ebx
80104488:	0f 84 8f 00 00 00    	je     8010451d <wait+0x11d>
    p->chan = chan;
8010448e:	89 73 20             	mov    %esi,0x20(%ebx)
    p->state = SLEEPING;
80104491:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104498:	e8 73 fd ff ff       	call   80104210 <sched>
    p->chan = 0;
8010449d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801044a4:	eb 84                	jmp    8010442a <wait+0x2a>
801044a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
                kfree(p->kstack);
801044b0:	83 ec 0c             	sub    $0xc,%esp
                pid = p->pid;
801044b3:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
801044b6:	ff 73 08             	push   0x8(%ebx)
801044b9:	e8 02 e5 ff ff       	call   801029c0 <kfree>
                p->kstack = 0;
801044be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
801044c5:	5a                   	pop    %edx
801044c6:	ff 73 04             	push   0x4(%ebx)
801044c9:	e8 32 32 00 00       	call   80107700 <freevm>
                p->pid = 0;
801044ce:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
801044d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
801044dc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
801044e0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
801044e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
801044ee:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
801044f5:	e8 86 05 00 00       	call   80104a80 <release>
                return pid;
801044fa:	83 c4 10             	add    $0x10,%esp
}
801044fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104500:	89 f0                	mov    %esi,%eax
80104502:	5b                   	pop    %ebx
80104503:	5e                   	pop    %esi
80104504:	5d                   	pop    %ebp
80104505:	c3                   	ret    
            release(&ptable.lock);
80104506:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104509:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
8010450e:	68 a0 4d 11 80       	push   $0x80114da0
80104513:	e8 68 05 00 00       	call   80104a80 <release>
            return -1;
80104518:	83 c4 10             	add    $0x10,%esp
8010451b:	eb e0                	jmp    801044fd <wait+0xfd>
        panic("sleep");
8010451d:	83 ec 0c             	sub    $0xc,%esp
80104520:	68 d4 80 10 80       	push   $0x801080d4
80104525:	e8 56 bf ff ff       	call   80100480 <panic>
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104530 <yield>:
void yield(void)      {
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104537:	68 a0 4d 11 80       	push   $0x80114da0
8010453c:	e8 9f 05 00 00       	call   80104ae0 <acquire>
    pushcli();
80104541:	e8 4a 04 00 00       	call   80104990 <pushcli>
    c = mycpu();
80104546:	e8 e5 f8 ff ff       	call   80103e30 <mycpu>
    p = c->proc;
8010454b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104551:	e8 8a 04 00 00       	call   801049e0 <popcli>
    myproc()->state = RUNNABLE;
80104556:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
8010455d:	e8 ae fc ff ff       	call   80104210 <sched>
    release(&ptable.lock);
80104562:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
80104569:	e8 12 05 00 00       	call   80104a80 <release>
}
8010456e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104571:	83 c4 10             	add    $0x10,%esp
80104574:	c9                   	leave  
80104575:	c3                   	ret    
80104576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457d:	8d 76 00             	lea    0x0(%esi),%esi

80104580 <sleep>:
void sleep(void *chan, struct spinlock *lk)  {
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	57                   	push   %edi
80104584:	56                   	push   %esi
80104585:	53                   	push   %ebx
80104586:	83 ec 0c             	sub    $0xc,%esp
80104589:	8b 7d 08             	mov    0x8(%ebp),%edi
8010458c:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
8010458f:	e8 fc 03 00 00       	call   80104990 <pushcli>
    c = mycpu();
80104594:	e8 97 f8 ff ff       	call   80103e30 <mycpu>
    p = c->proc;
80104599:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010459f:	e8 3c 04 00 00       	call   801049e0 <popcli>
    if (p == 0) {
801045a4:	85 db                	test   %ebx,%ebx
801045a6:	0f 84 87 00 00 00    	je     80104633 <sleep+0xb3>
    if (lk == 0) {
801045ac:	85 f6                	test   %esi,%esi
801045ae:	74 76                	je     80104626 <sleep+0xa6>
    if (lk != &ptable.lock) { //DOC: sleeplock0
801045b0:	81 fe a0 4d 11 80    	cmp    $0x80114da0,%esi
801045b6:	74 50                	je     80104608 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	68 a0 4d 11 80       	push   $0x80114da0
801045c0:	e8 1b 05 00 00       	call   80104ae0 <acquire>
        release(lk);
801045c5:	89 34 24             	mov    %esi,(%esp)
801045c8:	e8 b3 04 00 00       	call   80104a80 <release>
    p->chan = chan;
801045cd:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
801045d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
801045d7:	e8 34 fc ff ff       	call   80104210 <sched>
    p->chan = 0;
801045dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
801045e3:	c7 04 24 a0 4d 11 80 	movl   $0x80114da0,(%esp)
801045ea:	e8 91 04 00 00       	call   80104a80 <release>
        acquire(lk);
801045ef:	89 75 08             	mov    %esi,0x8(%ebp)
801045f2:	83 c4 10             	add    $0x10,%esp
}
801045f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045f8:	5b                   	pop    %ebx
801045f9:	5e                   	pop    %esi
801045fa:	5f                   	pop    %edi
801045fb:	5d                   	pop    %ebp
        acquire(lk);
801045fc:	e9 df 04 00 00       	jmp    80104ae0 <acquire>
80104601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104608:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010460b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104612:	e8 f9 fb ff ff       	call   80104210 <sched>
    p->chan = 0;
80104617:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010461e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104621:	5b                   	pop    %ebx
80104622:	5e                   	pop    %esi
80104623:	5f                   	pop    %edi
80104624:	5d                   	pop    %ebp
80104625:	c3                   	ret    
        panic("sleep without lk");
80104626:	83 ec 0c             	sub    $0xc,%esp
80104629:	68 da 80 10 80       	push   $0x801080da
8010462e:	e8 4d be ff ff       	call   80100480 <panic>
        panic("sleep");
80104633:	83 ec 0c             	sub    $0xc,%esp
80104636:	68 d4 80 10 80       	push   $0x801080d4
8010463b:	e8 40 be ff ff       	call   80100480 <panic>

80104640 <wakeup>:
        }
    }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan) {
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	53                   	push   %ebx
80104644:	83 ec 10             	sub    $0x10,%esp
80104647:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010464a:	68 a0 4d 11 80       	push   $0x80114da0
8010464f:	e8 8c 04 00 00       	call   80104ae0 <acquire>
80104654:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104657:	b8 d4 4d 11 80       	mov    $0x80114dd4,%eax
8010465c:	eb 0c                	jmp    8010466a <wakeup+0x2a>
8010465e:	66 90                	xchg   %ax,%ax
80104660:	83 c0 7c             	add    $0x7c,%eax
80104663:	3d d4 6c 11 80       	cmp    $0x80116cd4,%eax
80104668:	74 1c                	je     80104686 <wakeup+0x46>
        if (p->state == SLEEPING && p->chan == chan) {
8010466a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010466e:	75 f0                	jne    80104660 <wakeup+0x20>
80104670:	3b 58 20             	cmp    0x20(%eax),%ebx
80104673:	75 eb                	jne    80104660 <wakeup+0x20>
            p->state = RUNNABLE;
80104675:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010467c:	83 c0 7c             	add    $0x7c,%eax
8010467f:	3d d4 6c 11 80       	cmp    $0x80116cd4,%eax
80104684:	75 e4                	jne    8010466a <wakeup+0x2a>
    wakeup1(chan);
    release(&ptable.lock);
80104686:	c7 45 08 a0 4d 11 80 	movl   $0x80114da0,0x8(%ebp)
}
8010468d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104690:	c9                   	leave  
    release(&ptable.lock);
80104691:	e9 ea 03 00 00       	jmp    80104a80 <release>
80104696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469d:	8d 76 00             	lea    0x0(%esi),%esi

801046a0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 10             	sub    $0x10,%esp
801046a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
801046aa:	68 a0 4d 11 80       	push   $0x80114da0
801046af:	e8 2c 04 00 00       	call   80104ae0 <acquire>
801046b4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801046b7:	b8 d4 4d 11 80       	mov    $0x80114dd4,%eax
801046bc:	eb 0c                	jmp    801046ca <kill+0x2a>
801046be:	66 90                	xchg   %ax,%ax
801046c0:	83 c0 7c             	add    $0x7c,%eax
801046c3:	3d d4 6c 11 80       	cmp    $0x80116cd4,%eax
801046c8:	74 36                	je     80104700 <kill+0x60>
        if (p->pid == pid) {
801046ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801046cd:	75 f1                	jne    801046c0 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING) {
801046cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
801046d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING) {
801046da:	75 07                	jne    801046e3 <kill+0x43>
                p->state = RUNNABLE;
801046dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            }
            release(&ptable.lock);
801046e3:	83 ec 0c             	sub    $0xc,%esp
801046e6:	68 a0 4d 11 80       	push   $0x80114da0
801046eb:	e8 90 03 00 00       	call   80104a80 <release>
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}
801046f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return 0;
801046f3:	83 c4 10             	add    $0x10,%esp
801046f6:	31 c0                	xor    %eax,%eax
}
801046f8:	c9                   	leave  
801046f9:	c3                   	ret    
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
80104700:	83 ec 0c             	sub    $0xc,%esp
80104703:	68 a0 4d 11 80       	push   $0x80114da0
80104708:	e8 73 03 00 00       	call   80104a80 <release>
}
8010470d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104710:	83 c4 10             	add    $0x10,%esp
80104713:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104718:	c9                   	leave  
80104719:	c3                   	ret    
8010471a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104720 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	57                   	push   %edi
80104724:	56                   	push   %esi
80104725:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104728:	53                   	push   %ebx
80104729:	bb 40 4e 11 80       	mov    $0x80114e40,%ebx
8010472e:	83 ec 3c             	sub    $0x3c,%esp
80104731:	eb 24                	jmp    80104757 <procdump+0x37>
80104733:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104737:	90                   	nop
            getcallerpcs((uint*)p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++) {
                cprintf(" %p", pc[i]);
            }
        }
        cprintf("\n");
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	68 6b 84 10 80       	push   $0x8010846b
80104740:	e8 9b c0 ff ff       	call   801007e0 <cprintf>
80104745:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104748:	83 c3 7c             	add    $0x7c,%ebx
8010474b:	81 fb 40 6d 11 80    	cmp    $0x80116d40,%ebx
80104751:	0f 84 81 00 00 00    	je     801047d8 <procdump+0xb8>
        if (p->state == UNUSED) {
80104757:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010475a:	85 c0                	test   %eax,%eax
8010475c:	74 ea                	je     80104748 <procdump+0x28>
            state = "???";
8010475e:	ba eb 80 10 80       	mov    $0x801080eb,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state]) {
80104763:	83 f8 05             	cmp    $0x5,%eax
80104766:	77 11                	ja     80104779 <procdump+0x59>
80104768:	8b 14 85 4c 81 10 80 	mov    -0x7fef7eb4(,%eax,4),%edx
            state = "???";
8010476f:	b8 eb 80 10 80       	mov    $0x801080eb,%eax
80104774:	85 d2                	test   %edx,%edx
80104776:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
80104779:	53                   	push   %ebx
8010477a:	52                   	push   %edx
8010477b:	ff 73 a4             	push   -0x5c(%ebx)
8010477e:	68 ef 80 10 80       	push   $0x801080ef
80104783:	e8 58 c0 ff ff       	call   801007e0 <cprintf>
        if (p->state == SLEEPING) {
80104788:	83 c4 10             	add    $0x10,%esp
8010478b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010478f:	75 a7                	jne    80104738 <procdump+0x18>
            getcallerpcs((uint*)p->context->ebp + 2, pc);
80104791:	83 ec 08             	sub    $0x8,%esp
80104794:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104797:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010479a:	50                   	push   %eax
8010479b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010479e:	8b 40 0c             	mov    0xc(%eax),%eax
801047a1:	83 c0 08             	add    $0x8,%eax
801047a4:	50                   	push   %eax
801047a5:	e8 86 01 00 00       	call   80104930 <getcallerpcs>
            for (i = 0; i < 10 && pc[i] != 0; i++) {
801047aa:	83 c4 10             	add    $0x10,%esp
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
801047b0:	8b 17                	mov    (%edi),%edx
801047b2:	85 d2                	test   %edx,%edx
801047b4:	74 82                	je     80104738 <procdump+0x18>
                cprintf(" %p", pc[i]);
801047b6:	83 ec 08             	sub    $0x8,%esp
            for (i = 0; i < 10 && pc[i] != 0; i++) {
801047b9:	83 c7 04             	add    $0x4,%edi
                cprintf(" %p", pc[i]);
801047bc:	52                   	push   %edx
801047bd:	68 41 7b 10 80       	push   $0x80107b41
801047c2:	e8 19 c0 ff ff       	call   801007e0 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++) {
801047c7:	83 c4 10             	add    $0x10,%esp
801047ca:	39 fe                	cmp    %edi,%esi
801047cc:	75 e2                	jne    801047b0 <procdump+0x90>
801047ce:	e9 65 ff ff ff       	jmp    80104738 <procdump+0x18>
801047d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047d7:	90                   	nop
    }
}
801047d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047db:	5b                   	pop    %ebx
801047dc:	5e                   	pop    %esi
801047dd:	5f                   	pop    %edi
801047de:	5d                   	pop    %ebp
801047df:	c3                   	ret    

801047e0 <initsleeplock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock *lk, char *name) {
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	83 ec 0c             	sub    $0xc,%esp
801047e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    initlock(&lk->lk, "sleep lock");
801047ea:	68 64 81 10 80       	push   $0x80108164
801047ef:	8d 43 04             	lea    0x4(%ebx),%eax
801047f2:	50                   	push   %eax
801047f3:	e8 18 01 00 00       	call   80104910 <initlock>
    lk->name = name;
801047f8:	8b 45 0c             	mov    0xc(%ebp),%eax
    lk->locked = 0;
801047fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
}
80104801:	83 c4 10             	add    $0x10,%esp
    lk->pid = 0;
80104804:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    lk->name = name;
8010480b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010480e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104811:	c9                   	leave  
80104812:	c3                   	ret    
80104813:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104820 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&lk->lk);
80104828:	8d 73 04             	lea    0x4(%ebx),%esi
8010482b:	83 ec 0c             	sub    $0xc,%esp
8010482e:	56                   	push   %esi
8010482f:	e8 ac 02 00 00       	call   80104ae0 <acquire>
    while (lk->locked) {
80104834:	8b 13                	mov    (%ebx),%edx
80104836:	83 c4 10             	add    $0x10,%esp
80104839:	85 d2                	test   %edx,%edx
8010483b:	74 16                	je     80104853 <acquiresleep+0x33>
8010483d:	8d 76 00             	lea    0x0(%esi),%esi
        sleep(lk, &lk->lk);
80104840:	83 ec 08             	sub    $0x8,%esp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
80104845:	e8 36 fd ff ff       	call   80104580 <sleep>
    while (lk->locked) {
8010484a:	8b 03                	mov    (%ebx),%eax
8010484c:	83 c4 10             	add    $0x10,%esp
8010484f:	85 c0                	test   %eax,%eax
80104851:	75 ed                	jne    80104840 <acquiresleep+0x20>
    }
    lk->locked = 1;
80104853:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    lk->pid = myproc()->pid;
80104859:	e8 52 f6 ff ff       	call   80103eb0 <myproc>
8010485e:	8b 40 10             	mov    0x10(%eax),%eax
80104861:	89 43 3c             	mov    %eax,0x3c(%ebx)
    release(&lk->lk);
80104864:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104867:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010486a:	5b                   	pop    %ebx
8010486b:	5e                   	pop    %esi
8010486c:	5d                   	pop    %ebp
    release(&lk->lk);
8010486d:	e9 0e 02 00 00       	jmp    80104a80 <release>
80104872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104880 <releasesleep>:

void releasesleep(struct sleeplock *lk) {
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
80104885:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&lk->lk);
80104888:	8d 73 04             	lea    0x4(%ebx),%esi
8010488b:	83 ec 0c             	sub    $0xc,%esp
8010488e:	56                   	push   %esi
8010488f:	e8 4c 02 00 00       	call   80104ae0 <acquire>
    lk->locked = 0;
80104894:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
8010489a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    wakeup(lk);
801048a1:	89 1c 24             	mov    %ebx,(%esp)
801048a4:	e8 97 fd ff ff       	call   80104640 <wakeup>
    release(&lk->lk);
801048a9:	89 75 08             	mov    %esi,0x8(%ebp)
801048ac:	83 c4 10             	add    $0x10,%esp
}
801048af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b2:	5b                   	pop    %ebx
801048b3:	5e                   	pop    %esi
801048b4:	5d                   	pop    %ebp
    release(&lk->lk);
801048b5:	e9 c6 01 00 00       	jmp    80104a80 <release>
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048c0 <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	57                   	push   %edi
801048c4:	31 ff                	xor    %edi,%edi
801048c6:	56                   	push   %esi
801048c7:	53                   	push   %ebx
801048c8:	83 ec 18             	sub    $0x18,%esp
801048cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int r;

    acquire(&lk->lk);
801048ce:	8d 73 04             	lea    0x4(%ebx),%esi
801048d1:	56                   	push   %esi
801048d2:	e8 09 02 00 00       	call   80104ae0 <acquire>
    r = lk->locked && (lk->pid == myproc()->pid);
801048d7:	8b 03                	mov    (%ebx),%eax
801048d9:	83 c4 10             	add    $0x10,%esp
801048dc:	85 c0                	test   %eax,%eax
801048de:	75 18                	jne    801048f8 <holdingsleep+0x38>
    release(&lk->lk);
801048e0:	83 ec 0c             	sub    $0xc,%esp
801048e3:	56                   	push   %esi
801048e4:	e8 97 01 00 00       	call   80104a80 <release>
    return r;
}
801048e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048ec:	89 f8                	mov    %edi,%eax
801048ee:	5b                   	pop    %ebx
801048ef:	5e                   	pop    %esi
801048f0:	5f                   	pop    %edi
801048f1:	5d                   	pop    %ebp
801048f2:	c3                   	ret    
801048f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048f7:	90                   	nop
    r = lk->locked && (lk->pid == myproc()->pid);
801048f8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801048fb:	e8 b0 f5 ff ff       	call   80103eb0 <myproc>
80104900:	39 58 10             	cmp    %ebx,0x10(%eax)
80104903:	0f 94 c0             	sete   %al
80104906:	0f b6 c0             	movzbl %al,%eax
80104909:	89 c7                	mov    %eax,%edi
8010490b:	eb d3                	jmp    801048e0 <holdingsleep+0x20>
8010490d:	66 90                	xchg   %ax,%ax
8010490f:	90                   	nop

80104910 <initlock>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

void initlock(struct spinlock *lk, char *name) {
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	8b 45 08             	mov    0x8(%ebp),%eax
    lk->name = name;
80104916:	8b 55 0c             	mov    0xc(%ebp),%edx
    lk->locked = 0;
80104919:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    lk->name = name;
8010491f:	89 50 04             	mov    %edx,0x4(%eax)
    lk->cpu = 0;
80104922:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104929:	5d                   	pop    %ebp
8010492a:	c3                   	ret    
8010492b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010492f:	90                   	nop

80104930 <getcallerpcs>:

    popcli();
}

// Record the current call stack in pcs[] by following the %ebp chain.
void getcallerpcs(void *v, uint pcs[]) {
80104930:	55                   	push   %ebp
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for (i = 0; i < 10; i++) {
80104931:	31 d2                	xor    %edx,%edx
void getcallerpcs(void *v, uint pcs[]) {
80104933:	89 e5                	mov    %esp,%ebp
80104935:	53                   	push   %ebx
    ebp = (uint*)v - 2;
80104936:	8b 45 08             	mov    0x8(%ebp),%eax
void getcallerpcs(void *v, uint pcs[]) {
80104939:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    ebp = (uint*)v - 2;
8010493c:	83 e8 08             	sub    $0x8,%eax
    for (i = 0; i < 10; i++) {
8010493f:	90                   	nop
        if (ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff) {
80104940:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104946:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010494c:	77 1a                	ja     80104968 <getcallerpcs+0x38>
            break;
        }
        pcs[i] = ebp[1];     // saved %eip
8010494e:	8b 58 04             	mov    0x4(%eax),%ebx
80104951:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    for (i = 0; i < 10; i++) {
80104954:	83 c2 01             	add    $0x1,%edx
        ebp = (uint*)ebp[0]; // saved %ebp
80104957:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < 10; i++) {
80104959:	83 fa 0a             	cmp    $0xa,%edx
8010495c:	75 e2                	jne    80104940 <getcallerpcs+0x10>
    }
    for (; i < 10; i++) {
        pcs[i] = 0;
    }
}
8010495e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104961:	c9                   	leave  
80104962:	c3                   	ret    
80104963:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104967:	90                   	nop
    for (; i < 10; i++) {
80104968:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010496b:	8d 51 28             	lea    0x28(%ecx),%edx
8010496e:	66 90                	xchg   %ax,%ax
        pcs[i] = 0;
80104970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (; i < 10; i++) {
80104976:	83 c0 04             	add    $0x4,%eax
80104979:	39 d0                	cmp    %edx,%eax
8010497b:	75 f3                	jne    80104970 <getcallerpcs+0x40>
}
8010497d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104980:	c9                   	leave  
80104981:	c3                   	ret    
80104982:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104990 <pushcli>:

// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void pushcli(void)      {
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	83 ec 04             	sub    $0x4,%esp
80104997:	9c                   	pushf  
80104998:	5b                   	pop    %ebx
    asm volatile ("cli");
80104999:	fa                   	cli    
    int eflags;

    eflags = readeflags();
    cli();
    if (mycpu()->ncli == 0) {
8010499a:	e8 91 f4 ff ff       	call   80103e30 <mycpu>
8010499f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049a5:	85 c0                	test   %eax,%eax
801049a7:	74 17                	je     801049c0 <pushcli+0x30>
        mycpu()->intena = eflags & FL_IF;
    }
    mycpu()->ncli += 1;
801049a9:	e8 82 f4 ff ff       	call   80103e30 <mycpu>
801049ae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b8:	c9                   	leave  
801049b9:	c3                   	ret    
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        mycpu()->intena = eflags & FL_IF;
801049c0:	e8 6b f4 ff ff       	call   80103e30 <mycpu>
801049c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801049cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801049d1:	eb d6                	jmp    801049a9 <pushcli+0x19>
801049d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049e0 <popcli>:

void popcli(void)      {
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	83 ec 08             	sub    $0x8,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
801049e6:	9c                   	pushf  
801049e7:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
801049e8:	f6 c4 02             	test   $0x2,%ah
801049eb:	75 35                	jne    80104a22 <popcli+0x42>
        panic("popcli - interruptible");
    }
    if (--mycpu()->ncli < 0) {
801049ed:	e8 3e f4 ff ff       	call   80103e30 <mycpu>
801049f2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801049f9:	78 34                	js     80104a2f <popcli+0x4f>
        panic("popcli");
    }
    if (mycpu()->ncli == 0 && mycpu()->intena) {
801049fb:	e8 30 f4 ff ff       	call   80103e30 <mycpu>
80104a00:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a06:	85 d2                	test   %edx,%edx
80104a08:	74 06                	je     80104a10 <popcli+0x30>
        sti();
    }
}
80104a0a:	c9                   	leave  
80104a0b:	c3                   	ret    
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (mycpu()->ncli == 0 && mycpu()->intena) {
80104a10:	e8 1b f4 ff ff       	call   80103e30 <mycpu>
80104a15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a1b:	85 c0                	test   %eax,%eax
80104a1d:	74 eb                	je     80104a0a <popcli+0x2a>
    asm volatile ("sti");
80104a1f:	fb                   	sti    
}
80104a20:	c9                   	leave  
80104a21:	c3                   	ret    
        panic("popcli - interruptible");
80104a22:	83 ec 0c             	sub    $0xc,%esp
80104a25:	68 6f 81 10 80       	push   $0x8010816f
80104a2a:	e8 51 ba ff ff       	call   80100480 <panic>
        panic("popcli");
80104a2f:	83 ec 0c             	sub    $0xc,%esp
80104a32:	68 86 81 10 80       	push   $0x80108186
80104a37:	e8 44 ba ff ff       	call   80100480 <panic>
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a40 <holding>:
int holding(struct spinlock *lock) {
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
80104a45:	8b 75 08             	mov    0x8(%ebp),%esi
80104a48:	31 db                	xor    %ebx,%ebx
    pushcli();
80104a4a:	e8 41 ff ff ff       	call   80104990 <pushcli>
    r = lock->locked && lock->cpu == mycpu();
80104a4f:	8b 06                	mov    (%esi),%eax
80104a51:	85 c0                	test   %eax,%eax
80104a53:	75 0b                	jne    80104a60 <holding+0x20>
    popcli();
80104a55:	e8 86 ff ff ff       	call   801049e0 <popcli>
}
80104a5a:	89 d8                	mov    %ebx,%eax
80104a5c:	5b                   	pop    %ebx
80104a5d:	5e                   	pop    %esi
80104a5e:	5d                   	pop    %ebp
80104a5f:	c3                   	ret    
    r = lock->locked && lock->cpu == mycpu();
80104a60:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a63:	e8 c8 f3 ff ff       	call   80103e30 <mycpu>
80104a68:	39 c3                	cmp    %eax,%ebx
80104a6a:	0f 94 c3             	sete   %bl
    popcli();
80104a6d:	e8 6e ff ff ff       	call   801049e0 <popcli>
    r = lock->locked && lock->cpu == mycpu();
80104a72:	0f b6 db             	movzbl %bl,%ebx
}
80104a75:	89 d8                	mov    %ebx,%eax
80104a77:	5b                   	pop    %ebx
80104a78:	5e                   	pop    %esi
80104a79:	5d                   	pop    %ebp
80104a7a:	c3                   	ret    
80104a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a7f:	90                   	nop

80104a80 <release>:
void release(struct spinlock *lk) {
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
80104a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
    pushcli();
80104a88:	e8 03 ff ff ff       	call   80104990 <pushcli>
    r = lock->locked && lock->cpu == mycpu();
80104a8d:	8b 03                	mov    (%ebx),%eax
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	75 15                	jne    80104aa8 <release+0x28>
    popcli();
80104a93:	e8 48 ff ff ff       	call   801049e0 <popcli>
        panic("release");
80104a98:	83 ec 0c             	sub    $0xc,%esp
80104a9b:	68 8d 81 10 80       	push   $0x8010818d
80104aa0:	e8 db b9 ff ff       	call   80100480 <panic>
80104aa5:	8d 76 00             	lea    0x0(%esi),%esi
    r = lock->locked && lock->cpu == mycpu();
80104aa8:	8b 73 08             	mov    0x8(%ebx),%esi
80104aab:	e8 80 f3 ff ff       	call   80103e30 <mycpu>
80104ab0:	39 c6                	cmp    %eax,%esi
80104ab2:	75 df                	jne    80104a93 <release+0x13>
    popcli();
80104ab4:	e8 27 ff ff ff       	call   801049e0 <popcli>
    lk->pcs[0] = 0;
80104ab9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    lk->cpu = 0;
80104ac0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    __sync_synchronize();
80104ac7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    asm volatile ("movl $0, %0" : "+m" (lk->locked) :);
80104acc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ad5:	5b                   	pop    %ebx
80104ad6:	5e                   	pop    %esi
80104ad7:	5d                   	pop    %ebp
    popcli();
80104ad8:	e9 03 ff ff ff       	jmp    801049e0 <popcli>
80104add:	8d 76 00             	lea    0x0(%esi),%esi

80104ae0 <acquire>:
void acquire(struct spinlock *lk) {
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
    pushcli(); // disable interrupts to avoid deadlock.
80104ae7:	e8 a4 fe ff ff       	call   80104990 <pushcli>
    if (holding(lk)) {
80104aec:	8b 5d 08             	mov    0x8(%ebp),%ebx
    pushcli();
80104aef:	e8 9c fe ff ff       	call   80104990 <pushcli>
    r = lock->locked && lock->cpu == mycpu();
80104af4:	8b 03                	mov    (%ebx),%eax
80104af6:	85 c0                	test   %eax,%eax
80104af8:	75 7e                	jne    80104b78 <acquire+0x98>
    popcli();
80104afa:	e8 e1 fe ff ff       	call   801049e0 <popcli>
    asm volatile ("lock; xchgl %0, %1" :
80104aff:	b9 01 00 00 00       	mov    $0x1,%ecx
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while (xchg(&lk->locked, 1) != 0) {
80104b08:	8b 55 08             	mov    0x8(%ebp),%edx
80104b0b:	89 c8                	mov    %ecx,%eax
80104b0d:	f0 87 02             	lock xchg %eax,(%edx)
80104b10:	85 c0                	test   %eax,%eax
80104b12:	75 f4                	jne    80104b08 <acquire+0x28>
    __sync_synchronize();
80104b14:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    lk->cpu = mycpu();
80104b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b1c:	e8 0f f3 ff ff       	call   80103e30 <mycpu>
    getcallerpcs(&lk, lk->pcs);
80104b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
    ebp = (uint*)v - 2;
80104b24:	89 ea                	mov    %ebp,%edx
    lk->cpu = mycpu();
80104b26:	89 43 08             	mov    %eax,0x8(%ebx)
    for (i = 0; i < 10; i++) {
80104b29:	31 c0                	xor    %eax,%eax
80104b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b2f:	90                   	nop
        if (ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff) {
80104b30:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104b36:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b3c:	77 1a                	ja     80104b58 <acquire+0x78>
        pcs[i] = ebp[1];     // saved %eip
80104b3e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104b41:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
    for (i = 0; i < 10; i++) {
80104b45:	83 c0 01             	add    $0x1,%eax
        ebp = (uint*)ebp[0]; // saved %ebp
80104b48:	8b 12                	mov    (%edx),%edx
    for (i = 0; i < 10; i++) {
80104b4a:	83 f8 0a             	cmp    $0xa,%eax
80104b4d:	75 e1                	jne    80104b30 <acquire+0x50>
}
80104b4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b52:	c9                   	leave  
80104b53:	c3                   	ret    
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (; i < 10; i++) {
80104b58:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104b5c:	8d 51 34             	lea    0x34(%ecx),%edx
80104b5f:	90                   	nop
        pcs[i] = 0;
80104b60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (; i < 10; i++) {
80104b66:	83 c0 04             	add    $0x4,%eax
80104b69:	39 c2                	cmp    %eax,%edx
80104b6b:	75 f3                	jne    80104b60 <acquire+0x80>
}
80104b6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b70:	c9                   	leave  
80104b71:	c3                   	ret    
80104b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    r = lock->locked && lock->cpu == mycpu();
80104b78:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104b7b:	e8 b0 f2 ff ff       	call   80103e30 <mycpu>
80104b80:	39 c3                	cmp    %eax,%ebx
80104b82:	0f 85 72 ff ff ff    	jne    80104afa <acquire+0x1a>
    popcli();
80104b88:	e8 53 fe ff ff       	call   801049e0 <popcli>
        panic("acquire");
80104b8d:	83 ec 0c             	sub    $0xc,%esp
80104b90:	68 95 81 10 80       	push   $0x80108195
80104b95:	e8 e6 b8 ff ff       	call   80100480 <panic>
80104b9a:	66 90                	xchg   %ax,%ax
80104b9c:	66 90                	xchg   %ax,%ax
80104b9e:	66 90                	xchg   %ax,%ax

80104ba0 <memset>:
#include "types.h"
#include "x86.h"

void* memset(void *dst, int c, uint n) {
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ba7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104baa:	53                   	push   %ebx
80104bab:	8b 45 0c             	mov    0xc(%ebp),%eax
    if ((int)dst % 4 == 0 && n % 4 == 0) {
80104bae:	89 d7                	mov    %edx,%edi
80104bb0:	09 cf                	or     %ecx,%edi
80104bb2:	83 e7 03             	and    $0x3,%edi
80104bb5:	75 29                	jne    80104be0 <memset+0x40>
        c &= 0xFF;
80104bb7:	0f b6 f8             	movzbl %al,%edi
        stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
80104bba:	c1 e0 18             	shl    $0x18,%eax
80104bbd:	89 fb                	mov    %edi,%ebx
80104bbf:	c1 e9 02             	shr    $0x2,%ecx
80104bc2:	c1 e3 10             	shl    $0x10,%ebx
80104bc5:	09 d8                	or     %ebx,%eax
80104bc7:	09 f8                	or     %edi,%eax
80104bc9:	c1 e7 08             	shl    $0x8,%edi
80104bcc:	09 f8                	or     %edi,%eax
    asm volatile ("cld; rep stosl" :
80104bce:	89 d7                	mov    %edx,%edi
80104bd0:	fc                   	cld    
80104bd1:	f3 ab                	rep stos %eax,%es:(%edi)
    }
    else {
        stosb(dst, c, n);
    }
    return dst;
}
80104bd3:	5b                   	pop    %ebx
80104bd4:	89 d0                	mov    %edx,%eax
80104bd6:	5f                   	pop    %edi
80104bd7:	5d                   	pop    %ebp
80104bd8:	c3                   	ret    
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    asm volatile ("cld; rep stosb" :
80104be0:	89 d7                	mov    %edx,%edi
80104be2:	fc                   	cld    
80104be3:	f3 aa                	rep stos %al,%es:(%edi)
80104be5:	5b                   	pop    %ebx
80104be6:	89 d0                	mov    %edx,%eax
80104be8:	5f                   	pop    %edi
80104be9:	5d                   	pop    %ebp
80104bea:	c3                   	ret    
80104beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bef:	90                   	nop

80104bf0 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	8b 75 10             	mov    0x10(%ebp),%esi
80104bf7:	8b 55 08             	mov    0x8(%ebp),%edx
80104bfa:	53                   	push   %ebx
80104bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
    const uchar *s1, *s2;

    s1 = v1;
    s2 = v2;
    while (n-- > 0) {
80104bfe:	85 f6                	test   %esi,%esi
80104c00:	74 2e                	je     80104c30 <memcmp+0x40>
80104c02:	01 c6                	add    %eax,%esi
80104c04:	eb 14                	jmp    80104c1a <memcmp+0x2a>
80104c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
        if (*s1 != *s2) {
            return *s1 - *s2;
        }
        s1++, s2++;
80104c10:	83 c0 01             	add    $0x1,%eax
80104c13:	83 c2 01             	add    $0x1,%edx
    while (n-- > 0) {
80104c16:	39 f0                	cmp    %esi,%eax
80104c18:	74 16                	je     80104c30 <memcmp+0x40>
        if (*s1 != *s2) {
80104c1a:	0f b6 0a             	movzbl (%edx),%ecx
80104c1d:	0f b6 18             	movzbl (%eax),%ebx
80104c20:	38 d9                	cmp    %bl,%cl
80104c22:	74 ec                	je     80104c10 <memcmp+0x20>
            return *s1 - *s2;
80104c24:	0f b6 c1             	movzbl %cl,%eax
80104c27:	29 d8                	sub    %ebx,%eax
    }

    return 0;
}
80104c29:	5b                   	pop    %ebx
80104c2a:	5e                   	pop    %esi
80104c2b:	5d                   	pop    %ebp
80104c2c:	c3                   	ret    
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
80104c30:	5b                   	pop    %ebx
    return 0;
80104c31:	31 c0                	xor    %eax,%eax
}
80104c33:	5e                   	pop    %esi
80104c34:	5d                   	pop    %ebp
80104c35:	c3                   	ret    
80104c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi

80104c40 <memmove>:

void* memmove(void *dst, const void *src, uint n) {
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	57                   	push   %edi
80104c44:	8b 55 08             	mov    0x8(%ebp),%edx
80104c47:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c4a:	56                   	push   %esi
80104c4b:	8b 75 0c             	mov    0xc(%ebp),%esi
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
80104c4e:	39 d6                	cmp    %edx,%esi
80104c50:	73 26                	jae    80104c78 <memmove+0x38>
80104c52:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104c55:	39 fa                	cmp    %edi,%edx
80104c57:	73 1f                	jae    80104c78 <memmove+0x38>
80104c59:	8d 41 ff             	lea    -0x1(%ecx),%eax
        s += n;
        d += n;
        while (n-- > 0) {
80104c5c:	85 c9                	test   %ecx,%ecx
80104c5e:	74 0c                	je     80104c6c <memmove+0x2c>
            *--d = *--s;
80104c60:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c64:	88 0c 02             	mov    %cl,(%edx,%eax,1)
        while (n-- > 0) {
80104c67:	83 e8 01             	sub    $0x1,%eax
80104c6a:	73 f4                	jae    80104c60 <memmove+0x20>
            *d++ = *s++;
        }
    }

    return dst;
}
80104c6c:	5e                   	pop    %esi
80104c6d:	89 d0                	mov    %edx,%eax
80104c6f:	5f                   	pop    %edi
80104c70:	5d                   	pop    %ebp
80104c71:	c3                   	ret    
80104c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        while (n-- > 0) {
80104c78:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104c7b:	89 d7                	mov    %edx,%edi
80104c7d:	85 c9                	test   %ecx,%ecx
80104c7f:	74 eb                	je     80104c6c <memmove+0x2c>
80104c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            *d++ = *s++;
80104c88:	a4                   	movsb  %ds:(%esi),%es:(%edi)
        while (n-- > 0) {
80104c89:	39 c6                	cmp    %eax,%esi
80104c8b:	75 fb                	jne    80104c88 <memmove+0x48>
}
80104c8d:	5e                   	pop    %esi
80104c8e:	89 d0                	mov    %edx,%eax
80104c90:	5f                   	pop    %edi
80104c91:	5d                   	pop    %ebp
80104c92:	c3                   	ret    
80104c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ca0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void* memcpy(void *dst, const void *src, uint n) {
    return memmove(dst, src, n);
80104ca0:	eb 9e                	jmp    80104c40 <memmove>
80104ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cb0 <strncmp>:
}

int strncmp(const char *p, const char *q, uint n) {
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	8b 75 10             	mov    0x10(%ebp),%esi
80104cb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cba:	53                   	push   %ebx
80104cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
    while (n > 0 && *p && *p == *q) {
80104cbe:	85 f6                	test   %esi,%esi
80104cc0:	74 2e                	je     80104cf0 <strncmp+0x40>
80104cc2:	01 d6                	add    %edx,%esi
80104cc4:	eb 18                	jmp    80104cde <strncmp+0x2e>
80104cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
80104cd0:	38 d8                	cmp    %bl,%al
80104cd2:	75 14                	jne    80104ce8 <strncmp+0x38>
        n--, p++, q++;
80104cd4:	83 c2 01             	add    $0x1,%edx
80104cd7:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q) {
80104cda:	39 f2                	cmp    %esi,%edx
80104cdc:	74 12                	je     80104cf0 <strncmp+0x40>
80104cde:	0f b6 01             	movzbl (%ecx),%eax
80104ce1:	0f b6 1a             	movzbl (%edx),%ebx
80104ce4:	84 c0                	test   %al,%al
80104ce6:	75 e8                	jne    80104cd0 <strncmp+0x20>
    }
    if (n == 0) {
        return 0;
    }
    return (uchar) * p - (uchar) * q;
80104ce8:	29 d8                	sub    %ebx,%eax
}
80104cea:	5b                   	pop    %ebx
80104ceb:	5e                   	pop    %esi
80104cec:	5d                   	pop    %ebp
80104ced:	c3                   	ret    
80104cee:	66 90                	xchg   %ax,%ax
80104cf0:	5b                   	pop    %ebx
        return 0;
80104cf1:	31 c0                	xor    %eax,%eax
}
80104cf3:	5e                   	pop    %esi
80104cf4:	5d                   	pop    %ebp
80104cf5:	c3                   	ret    
80104cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi

80104d00 <strncpy>:

char* strncpy(char *s, const char *t, int n) {
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
80104d05:	8b 75 08             	mov    0x8(%ebp),%esi
80104d08:	53                   	push   %ebx
80104d09:	8b 4d 10             	mov    0x10(%ebp),%ecx
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0) {
80104d0c:	89 f0                	mov    %esi,%eax
80104d0e:	eb 15                	jmp    80104d25 <strncpy+0x25>
80104d10:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d14:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104d17:	83 c0 01             	add    $0x1,%eax
80104d1a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104d1e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104d21:	84 d2                	test   %dl,%dl
80104d23:	74 09                	je     80104d2e <strncpy+0x2e>
80104d25:	89 cb                	mov    %ecx,%ebx
80104d27:	83 e9 01             	sub    $0x1,%ecx
80104d2a:	85 db                	test   %ebx,%ebx
80104d2c:	7f e2                	jg     80104d10 <strncpy+0x10>
        ;
    }
    while (n-- > 0) {
80104d2e:	89 c2                	mov    %eax,%edx
80104d30:	85 c9                	test   %ecx,%ecx
80104d32:	7e 17                	jle    80104d4b <strncpy+0x4b>
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        *s++ = 0;
80104d38:	83 c2 01             	add    $0x1,%edx
80104d3b:	89 c1                	mov    %eax,%ecx
80104d3d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
    while (n-- > 0) {
80104d41:	29 d1                	sub    %edx,%ecx
80104d43:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104d47:	85 c9                	test   %ecx,%ecx
80104d49:	7f ed                	jg     80104d38 <strncpy+0x38>
    }
    return os;
}
80104d4b:	5b                   	pop    %ebx
80104d4c:	89 f0                	mov    %esi,%eax
80104d4e:	5e                   	pop    %esi
80104d4f:	5f                   	pop    %edi
80104d50:	5d                   	pop    %ebp
80104d51:	c3                   	ret    
80104d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char* safestrcpy(char *s, const char *t, int n) {
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	8b 55 10             	mov    0x10(%ebp),%edx
80104d67:	8b 75 08             	mov    0x8(%ebp),%esi
80104d6a:	53                   	push   %ebx
80104d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
    char *os;

    os = s;
    if (n <= 0) {
80104d6e:	85 d2                	test   %edx,%edx
80104d70:	7e 25                	jle    80104d97 <safestrcpy+0x37>
80104d72:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104d76:	89 f2                	mov    %esi,%edx
80104d78:	eb 16                	jmp    80104d90 <safestrcpy+0x30>
80104d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return os;
    }
    while (--n > 0 && (*s++ = *t++) != 0) {
80104d80:	0f b6 08             	movzbl (%eax),%ecx
80104d83:	83 c0 01             	add    $0x1,%eax
80104d86:	83 c2 01             	add    $0x1,%edx
80104d89:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d8c:	84 c9                	test   %cl,%cl
80104d8e:	74 04                	je     80104d94 <safestrcpy+0x34>
80104d90:	39 d8                	cmp    %ebx,%eax
80104d92:	75 ec                	jne    80104d80 <safestrcpy+0x20>
        ;
    }
    *s = 0;
80104d94:	c6 02 00             	movb   $0x0,(%edx)
    return os;
}
80104d97:	89 f0                	mov    %esi,%eax
80104d99:	5b                   	pop    %ebx
80104d9a:	5e                   	pop    %esi
80104d9b:	5d                   	pop    %ebp
80104d9c:	c3                   	ret    
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi

80104da0 <strlen>:

int strlen(const char *s) {
80104da0:	55                   	push   %ebp
    int n;

    for (n = 0; s[n]; n++) {
80104da1:	31 c0                	xor    %eax,%eax
int strlen(const char *s) {
80104da3:	89 e5                	mov    %esp,%ebp
80104da5:	8b 55 08             	mov    0x8(%ebp),%edx
    for (n = 0; s[n]; n++) {
80104da8:	80 3a 00             	cmpb   $0x0,(%edx)
80104dab:	74 0c                	je     80104db9 <strlen+0x19>
80104dad:	8d 76 00             	lea    0x0(%esi),%esi
80104db0:	83 c0 01             	add    $0x1,%eax
80104db3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104db7:	75 f7                	jne    80104db0 <strlen+0x10>
        ;
    }
    return n;
}
80104db9:	5d                   	pop    %ebp
80104dba:	c3                   	ret    

80104dbb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
    movl 4(%esp), %eax
80104dbb:	8b 44 24 04          	mov    0x4(%esp),%eax
    movl 8(%esp), %edx
80104dbf:	8b 54 24 08          	mov    0x8(%esp),%edx

    # Save old callee-saved registers
    pushl %ebp
80104dc3:	55                   	push   %ebp
    pushl %ebx
80104dc4:	53                   	push   %ebx
    pushl %esi
80104dc5:	56                   	push   %esi
    pushl %edi
80104dc6:	57                   	push   %edi

    # Switch stacks
    movl %esp, (%eax)
80104dc7:	89 20                	mov    %esp,(%eax)
    movl %edx, %esp
80104dc9:	89 d4                	mov    %edx,%esp

    # Load new callee-saved registers
    popl %edi
80104dcb:	5f                   	pop    %edi
    popl %esi
80104dcc:	5e                   	pop    %esi
    popl %ebx
80104dcd:	5b                   	pop    %ebx
    popl %ebp
80104dce:	5d                   	pop    %ebp
    ret
80104dcf:	c3                   	ret    

80104dd0 <fetchint>:
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)  {
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	53                   	push   %ebx
80104dd4:	83 ec 04             	sub    $0x4,%esp
80104dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
80104dda:	e8 d1 f0 ff ff       	call   80103eb0 <myproc>

    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
80104ddf:	8b 00                	mov    (%eax),%eax
80104de1:	39 d8                	cmp    %ebx,%eax
80104de3:	76 1b                	jbe    80104e00 <fetchint+0x30>
80104de5:	8d 53 04             	lea    0x4(%ebx),%edx
80104de8:	39 d0                	cmp    %edx,%eax
80104dea:	72 14                	jb     80104e00 <fetchint+0x30>
        return -1;
    }
    *ip = *(int*)(addr);
80104dec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104def:	8b 13                	mov    (%ebx),%edx
80104df1:	89 10                	mov    %edx,(%eax)
    return 0;
80104df3:	31 c0                	xor    %eax,%eax
}
80104df5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104df8:	c9                   	leave  
80104df9:	c3                   	ret    
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80104e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e05:	eb ee                	jmp    80104df5 <fetchint+0x25>
80104e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0e:	66 90                	xchg   %ax,%ax

80104e10 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp) {
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	53                   	push   %ebx
80104e14:	83 ec 04             	sub    $0x4,%esp
80104e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc *curproc = myproc();
80104e1a:	e8 91 f0 ff ff       	call   80103eb0 <myproc>

    if (addr >= curproc->sz) {
80104e1f:	39 18                	cmp    %ebx,(%eax)
80104e21:	76 2d                	jbe    80104e50 <fetchstr+0x40>
        return -1;
    }
    *pp = (char*)addr;
80104e23:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e26:	89 1a                	mov    %ebx,(%edx)
    ep = (char*)curproc->sz;
80104e28:	8b 10                	mov    (%eax),%edx
    for (s = *pp; s < ep; s++) {
80104e2a:	39 d3                	cmp    %edx,%ebx
80104e2c:	73 22                	jae    80104e50 <fetchstr+0x40>
80104e2e:	89 d8                	mov    %ebx,%eax
80104e30:	eb 0d                	jmp    80104e3f <fetchstr+0x2f>
80104e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e38:	83 c0 01             	add    $0x1,%eax
80104e3b:	39 c2                	cmp    %eax,%edx
80104e3d:	76 11                	jbe    80104e50 <fetchstr+0x40>
        if (*s == 0) {
80104e3f:	80 38 00             	cmpb   $0x0,(%eax)
80104e42:	75 f4                	jne    80104e38 <fetchstr+0x28>
            return s - *pp;
80104e44:	29 d8                	sub    %ebx,%eax
        }
    }
    return -1;
}
80104e46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e49:	c9                   	leave  
80104e4a:	c3                   	ret    
80104e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e4f:	90                   	nop
80104e50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        return -1;
80104e53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e58:	c9                   	leave  
80104e59:	c3                   	ret    
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e60 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip) {
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104e65:	e8 46 f0 ff ff       	call   80103eb0 <myproc>
80104e6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104e6d:	8b 40 18             	mov    0x18(%eax),%eax
80104e70:	8b 40 44             	mov    0x44(%eax),%eax
80104e73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc *curproc = myproc();
80104e76:	e8 35 f0 ff ff       	call   80103eb0 <myproc>
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104e7b:	8d 73 04             	lea    0x4(%ebx),%esi
    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
80104e7e:	8b 00                	mov    (%eax),%eax
80104e80:	39 c6                	cmp    %eax,%esi
80104e82:	73 1c                	jae    80104ea0 <argint+0x40>
80104e84:	8d 53 08             	lea    0x8(%ebx),%edx
80104e87:	39 d0                	cmp    %edx,%eax
80104e89:	72 15                	jb     80104ea0 <argint+0x40>
    *ip = *(int*)(addr);
80104e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e8e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e91:	89 10                	mov    %edx,(%eax)
    return 0;
80104e93:	31 c0                	xor    %eax,%eax
}
80104e95:	5b                   	pop    %ebx
80104e96:	5e                   	pop    %esi
80104e97:	5d                   	pop    %ebp
80104e98:	c3                   	ret    
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80104ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104ea5:	eb ee                	jmp    80104e95 <argint+0x35>
80104ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eae:	66 90                	xchg   %ax,%ax

80104eb0 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size) {
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	57                   	push   %edi
80104eb4:	56                   	push   %esi
80104eb5:	53                   	push   %ebx
80104eb6:	83 ec 0c             	sub    $0xc,%esp
    int i;
    struct proc *curproc = myproc();
80104eb9:	e8 f2 ef ff ff       	call   80103eb0 <myproc>
80104ebe:	89 c6                	mov    %eax,%esi
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104ec0:	e8 eb ef ff ff       	call   80103eb0 <myproc>
80104ec5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ec8:	8b 40 18             	mov    0x18(%eax),%eax
80104ecb:	8b 40 44             	mov    0x44(%eax),%eax
80104ece:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc *curproc = myproc();
80104ed1:	e8 da ef ff ff       	call   80103eb0 <myproc>
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104ed6:	8d 7b 04             	lea    0x4(%ebx),%edi
    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
80104ed9:	8b 00                	mov    (%eax),%eax
80104edb:	39 c7                	cmp    %eax,%edi
80104edd:	73 31                	jae    80104f10 <argptr+0x60>
80104edf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ee2:	39 c8                	cmp    %ecx,%eax
80104ee4:	72 2a                	jb     80104f10 <argptr+0x60>

    if (argint(n, &i) < 0) {
        return -1;
    }
    if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz) {
80104ee6:	8b 55 10             	mov    0x10(%ebp),%edx
    *ip = *(int*)(addr);
80104ee9:	8b 43 04             	mov    0x4(%ebx),%eax
    if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz) {
80104eec:	85 d2                	test   %edx,%edx
80104eee:	78 20                	js     80104f10 <argptr+0x60>
80104ef0:	8b 16                	mov    (%esi),%edx
80104ef2:	39 c2                	cmp    %eax,%edx
80104ef4:	76 1a                	jbe    80104f10 <argptr+0x60>
80104ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ef9:	01 c3                	add    %eax,%ebx
80104efb:	39 da                	cmp    %ebx,%edx
80104efd:	72 11                	jb     80104f10 <argptr+0x60>
        return -1;
    }
    *pp = (char*)i;
80104eff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f02:	89 02                	mov    %eax,(%edx)
    return 0;
80104f04:	31 c0                	xor    %eax,%eax
}
80104f06:	83 c4 0c             	add    $0xc,%esp
80104f09:	5b                   	pop    %ebx
80104f0a:	5e                   	pop    %esi
80104f0b:	5f                   	pop    %edi
80104f0c:	5d                   	pop    %ebp
80104f0d:	c3                   	ret    
80104f0e:	66 90                	xchg   %ax,%ax
        return -1;
80104f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f15:	eb ef                	jmp    80104f06 <argptr+0x56>
80104f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1e:	66 90                	xchg   %ax,%ax

80104f20 <argstr>:

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp) {
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104f25:	e8 86 ef ff ff       	call   80103eb0 <myproc>
80104f2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f2d:	8b 40 18             	mov    0x18(%eax),%eax
80104f30:	8b 40 44             	mov    0x44(%eax),%eax
80104f33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc *curproc = myproc();
80104f36:	e8 75 ef ff ff       	call   80103eb0 <myproc>
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104f3b:	8d 73 04             	lea    0x4(%ebx),%esi
    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
80104f3e:	8b 00                	mov    (%eax),%eax
80104f40:	39 c6                	cmp    %eax,%esi
80104f42:	73 44                	jae    80104f88 <argstr+0x68>
80104f44:	8d 53 08             	lea    0x8(%ebx),%edx
80104f47:	39 d0                	cmp    %edx,%eax
80104f49:	72 3d                	jb     80104f88 <argstr+0x68>
    *ip = *(int*)(addr);
80104f4b:	8b 5b 04             	mov    0x4(%ebx),%ebx
    struct proc *curproc = myproc();
80104f4e:	e8 5d ef ff ff       	call   80103eb0 <myproc>
    if (addr >= curproc->sz) {
80104f53:	3b 18                	cmp    (%eax),%ebx
80104f55:	73 31                	jae    80104f88 <argstr+0x68>
    *pp = (char*)addr;
80104f57:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f5a:	89 1a                	mov    %ebx,(%edx)
    ep = (char*)curproc->sz;
80104f5c:	8b 10                	mov    (%eax),%edx
    for (s = *pp; s < ep; s++) {
80104f5e:	39 d3                	cmp    %edx,%ebx
80104f60:	73 26                	jae    80104f88 <argstr+0x68>
80104f62:	89 d8                	mov    %ebx,%eax
80104f64:	eb 11                	jmp    80104f77 <argstr+0x57>
80104f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
80104f70:	83 c0 01             	add    $0x1,%eax
80104f73:	39 c2                	cmp    %eax,%edx
80104f75:	76 11                	jbe    80104f88 <argstr+0x68>
        if (*s == 0) {
80104f77:	80 38 00             	cmpb   $0x0,(%eax)
80104f7a:	75 f4                	jne    80104f70 <argstr+0x50>
            return s - *pp;
80104f7c:	29 d8                	sub    %ebx,%eax
    int addr;
    if (argint(n, &addr) < 0) {
        return -1;
    }
    return fetchstr(addr, pp);
}
80104f7e:	5b                   	pop    %ebx
80104f7f:	5e                   	pop    %esi
80104f80:	5d                   	pop    %ebp
80104f81:	c3                   	ret    
80104f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f88:	5b                   	pop    %ebx
        return -1;
80104f89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f8e:	5e                   	pop    %esi
80104f8f:	5d                   	pop    %ebp
80104f90:	c3                   	ret    
80104f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9f:	90                   	nop

80104fa0 <syscall>:

void syscall(void) {
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	53                   	push   %ebx
80104fa4:	83 ec 04             	sub    $0x4,%esp
    int num;
    struct proc *curproc = myproc();
80104fa7:	e8 04 ef ff ff       	call   80103eb0 <myproc>
80104fac:	89 c3                	mov    %eax,%ebx

    num = curproc->tf->eax;
80104fae:	8b 40 18             	mov    0x18(%eax),%eax
80104fb1:	8b 40 1c             	mov    0x1c(%eax),%eax
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104fb4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104fb7:	83 fa 19             	cmp    $0x19,%edx
80104fba:	77 24                	ja     80104fe0 <syscall+0x40>
80104fbc:	8b 14 85 c0 81 10 80 	mov    -0x7fef7e40(,%eax,4),%edx
80104fc3:	85 d2                	test   %edx,%edx
80104fc5:	74 19                	je     80104fe0 <syscall+0x40>
        curproc->tf->eax = syscalls[num]();
80104fc7:	ff d2                	call   *%edx
80104fc9:	89 c2                	mov    %eax,%edx
80104fcb:	8b 43 18             	mov    0x18(%ebx),%eax
80104fce:	89 50 1c             	mov    %edx,0x1c(%eax)
    else {
        cprintf("%d %s: unknown sys call %d\n",
                curproc->pid, curproc->name, num);
        curproc->tf->eax = -1;
    }
}
80104fd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fd4:	c9                   	leave  
80104fd5:	c3                   	ret    
80104fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
        cprintf("%d %s: unknown sys call %d\n",
80104fe0:	50                   	push   %eax
                curproc->pid, curproc->name, num);
80104fe1:	8d 43 6c             	lea    0x6c(%ebx),%eax
        cprintf("%d %s: unknown sys call %d\n",
80104fe4:	50                   	push   %eax
80104fe5:	ff 73 10             	push   0x10(%ebx)
80104fe8:	68 9d 81 10 80       	push   $0x8010819d
80104fed:	e8 ee b7 ff ff       	call   801007e0 <cprintf>
        curproc->tf->eax = -1;
80104ff2:	8b 43 18             	mov    0x18(%ebx),%eax
80104ff5:	83 c4 10             	add    $0x10,%esp
80104ff8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104fff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105002:	c9                   	leave  
80105003:	c3                   	ret    
80105004:	66 90                	xchg   %ax,%ax
80105006:	66 90                	xchg   %ax,%ax
80105008:	66 90                	xchg   %ax,%ax
8010500a:	66 90                	xchg   %ax,%ax
8010500c:	66 90                	xchg   %ax,%ax
8010500e:	66 90                	xchg   %ax,%ax

80105010 <create>:
    end_op();

    return 0;
}

static struct inode* create(char *path, short type, short major, short minor)  {
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	57                   	push   %edi
80105014:	56                   	push   %esi
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0) {
80105015:	8d 7d da             	lea    -0x26(%ebp),%edi
static struct inode* create(char *path, short type, short major, short minor)  {
80105018:	53                   	push   %ebx
80105019:	83 ec 34             	sub    $0x34,%esp
8010501c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010501f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if ((dp = nameiparent(path, name)) == 0) {
80105022:	57                   	push   %edi
80105023:	50                   	push   %eax
static struct inode* create(char *path, short type, short major, short minor)  {
80105024:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105027:	89 4d cc             	mov    %ecx,-0x34(%ebp)
    if ((dp = nameiparent(path, name)) == 0) {
8010502a:	e8 11 d3 ff ff       	call   80102340 <nameiparent>
8010502f:	83 c4 10             	add    $0x10,%esp
80105032:	85 c0                	test   %eax,%eax
80105034:	0f 84 46 01 00 00    	je     80105180 <create+0x170>
        return 0;
    }
    ilock(dp);
8010503a:	83 ec 0c             	sub    $0xc,%esp
8010503d:	89 c3                	mov    %eax,%ebx
8010503f:	50                   	push   %eax
80105040:	e8 bb c9 ff ff       	call   80101a00 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0) {
80105045:	83 c4 0c             	add    $0xc,%esp
80105048:	6a 00                	push   $0x0
8010504a:	57                   	push   %edi
8010504b:	53                   	push   %ebx
8010504c:	e8 0f cf ff ff       	call   80101f60 <dirlookup>
80105051:	83 c4 10             	add    $0x10,%esp
80105054:	89 c6                	mov    %eax,%esi
80105056:	85 c0                	test   %eax,%eax
80105058:	74 56                	je     801050b0 <create+0xa0>
        iunlockput(dp);
8010505a:	83 ec 0c             	sub    $0xc,%esp
8010505d:	53                   	push   %ebx
8010505e:	e8 2d cc ff ff       	call   80101c90 <iunlockput>
        ilock(ip);
80105063:	89 34 24             	mov    %esi,(%esp)
80105066:	e8 95 c9 ff ff       	call   80101a00 <ilock>
        if (type == T_FILE && ip->type == T_FILE) {
8010506b:	83 c4 10             	add    $0x10,%esp
8010506e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105073:	75 1b                	jne    80105090 <create+0x80>
80105075:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010507a:	75 14                	jne    80105090 <create+0x80>
    }

    iunlockput(dp);

    return ip;
}
8010507c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010507f:	89 f0                	mov    %esi,%eax
80105081:	5b                   	pop    %ebx
80105082:	5e                   	pop    %esi
80105083:	5f                   	pop    %edi
80105084:	5d                   	pop    %ebp
80105085:	c3                   	ret    
80105086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
        iunlockput(ip);
80105090:	83 ec 0c             	sub    $0xc,%esp
80105093:	56                   	push   %esi
        return 0;
80105094:	31 f6                	xor    %esi,%esi
        iunlockput(ip);
80105096:	e8 f5 cb ff ff       	call   80101c90 <iunlockput>
        return 0;
8010509b:	83 c4 10             	add    $0x10,%esp
}
8010509e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050a1:	89 f0                	mov    %esi,%eax
801050a3:	5b                   	pop    %ebx
801050a4:	5e                   	pop    %esi
801050a5:	5f                   	pop    %edi
801050a6:	5d                   	pop    %ebp
801050a7:	c3                   	ret    
801050a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050af:	90                   	nop
    if ((ip = ialloc(dp->dev, type)) == 0) {
801050b0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801050b4:	83 ec 08             	sub    $0x8,%esp
801050b7:	50                   	push   %eax
801050b8:	ff 33                	push   (%ebx)
801050ba:	e8 d1 c7 ff ff       	call   80101890 <ialloc>
801050bf:	83 c4 10             	add    $0x10,%esp
801050c2:	89 c6                	mov    %eax,%esi
801050c4:	85 c0                	test   %eax,%eax
801050c6:	0f 84 cd 00 00 00    	je     80105199 <create+0x189>
    ilock(ip);
801050cc:	83 ec 0c             	sub    $0xc,%esp
801050cf:	50                   	push   %eax
801050d0:	e8 2b c9 ff ff       	call   80101a00 <ilock>
    ip->major = major;
801050d5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801050d9:	66 89 46 52          	mov    %ax,0x52(%esi)
    ip->minor = minor;
801050dd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801050e1:	66 89 46 54          	mov    %ax,0x54(%esi)
    ip->nlink = 1;
801050e5:	b8 01 00 00 00       	mov    $0x1,%eax
801050ea:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(ip);
801050ee:	89 34 24             	mov    %esi,(%esp)
801050f1:	e8 5a c8 ff ff       	call   80101950 <iupdate>
    if (type == T_DIR) { // Create . and .. entries.
801050f6:	83 c4 10             	add    $0x10,%esp
801050f9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801050fe:	74 30                	je     80105130 <create+0x120>
    if (dirlink(dp, name, ip->inum) < 0) {
80105100:	83 ec 04             	sub    $0x4,%esp
80105103:	ff 76 04             	push   0x4(%esi)
80105106:	57                   	push   %edi
80105107:	53                   	push   %ebx
80105108:	e8 53 d1 ff ff       	call   80102260 <dirlink>
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	85 c0                	test   %eax,%eax
80105112:	78 78                	js     8010518c <create+0x17c>
    iunlockput(dp);
80105114:	83 ec 0c             	sub    $0xc,%esp
80105117:	53                   	push   %ebx
80105118:	e8 73 cb ff ff       	call   80101c90 <iunlockput>
    return ip;
8010511d:	83 c4 10             	add    $0x10,%esp
}
80105120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105123:	89 f0                	mov    %esi,%eax
80105125:	5b                   	pop    %ebx
80105126:	5e                   	pop    %esi
80105127:	5f                   	pop    %edi
80105128:	5d                   	pop    %ebp
80105129:	c3                   	ret    
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        iupdate(dp);
80105130:	83 ec 0c             	sub    $0xc,%esp
        dp->nlink++;  // for ".."
80105133:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
        iupdate(dp);
80105138:	53                   	push   %ebx
80105139:	e8 12 c8 ff ff       	call   80101950 <iupdate>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0) {
8010513e:	83 c4 0c             	add    $0xc,%esp
80105141:	ff 76 04             	push   0x4(%esi)
80105144:	68 48 82 10 80       	push   $0x80108248
80105149:	56                   	push   %esi
8010514a:	e8 11 d1 ff ff       	call   80102260 <dirlink>
8010514f:	83 c4 10             	add    $0x10,%esp
80105152:	85 c0                	test   %eax,%eax
80105154:	78 18                	js     8010516e <create+0x15e>
80105156:	83 ec 04             	sub    $0x4,%esp
80105159:	ff 73 04             	push   0x4(%ebx)
8010515c:	68 47 82 10 80       	push   $0x80108247
80105161:	56                   	push   %esi
80105162:	e8 f9 d0 ff ff       	call   80102260 <dirlink>
80105167:	83 c4 10             	add    $0x10,%esp
8010516a:	85 c0                	test   %eax,%eax
8010516c:	79 92                	jns    80105100 <create+0xf0>
            panic("create dots");
8010516e:	83 ec 0c             	sub    $0xc,%esp
80105171:	68 3b 82 10 80       	push   $0x8010823b
80105176:	e8 05 b3 ff ff       	call   80100480 <panic>
8010517b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010517f:	90                   	nop
}
80105180:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
80105183:	31 f6                	xor    %esi,%esi
}
80105185:	5b                   	pop    %ebx
80105186:	89 f0                	mov    %esi,%eax
80105188:	5e                   	pop    %esi
80105189:	5f                   	pop    %edi
8010518a:	5d                   	pop    %ebp
8010518b:	c3                   	ret    
        panic("create: dirlink");
8010518c:	83 ec 0c             	sub    $0xc,%esp
8010518f:	68 4a 82 10 80       	push   $0x8010824a
80105194:	e8 e7 b2 ff ff       	call   80100480 <panic>
        panic("create: ialloc");
80105199:	83 ec 0c             	sub    $0xc,%esp
8010519c:	68 2c 82 10 80       	push   $0x8010822c
801051a1:	e8 da b2 ff ff       	call   80100480 <panic>
801051a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ad:	8d 76 00             	lea    0x0(%esi),%esi

801051b0 <sys_dup>:
int sys_dup(void) {
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	56                   	push   %esi
801051b4:	53                   	push   %ebx
    if (argint(n, &fd) < 0) {
801051b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_dup(void) {
801051b8:	83 ec 18             	sub    $0x18,%esp
    if (argint(n, &fd) < 0) {
801051bb:	50                   	push   %eax
801051bc:	6a 00                	push   $0x0
801051be:	e8 9d fc ff ff       	call   80104e60 <argint>
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	85 c0                	test   %eax,%eax
801051c8:	78 36                	js     80105200 <sys_dup+0x50>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) {
801051ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051ce:	77 30                	ja     80105200 <sys_dup+0x50>
801051d0:	e8 db ec ff ff       	call   80103eb0 <myproc>
801051d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801051dc:	85 f6                	test   %esi,%esi
801051de:	74 20                	je     80105200 <sys_dup+0x50>
    struct proc *curproc = myproc();
801051e0:	e8 cb ec ff ff       	call   80103eb0 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
801051e5:	31 db                	xor    %ebx,%ebx
801051e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ee:	66 90                	xchg   %ax,%ax
        if (curproc->ofile[fd] == 0) {
801051f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051f4:	85 d2                	test   %edx,%edx
801051f6:	74 18                	je     80105210 <sys_dup+0x60>
    for (fd = 0; fd < NOFILE; fd++) {
801051f8:	83 c3 01             	add    $0x1,%ebx
801051fb:	83 fb 10             	cmp    $0x10,%ebx
801051fe:	75 f0                	jne    801051f0 <sys_dup+0x40>
}
80105200:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return -1;
80105203:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105208:	89 d8                	mov    %ebx,%eax
8010520a:	5b                   	pop    %ebx
8010520b:	5e                   	pop    %esi
8010520c:	5d                   	pop    %ebp
8010520d:	c3                   	ret    
8010520e:	66 90                	xchg   %ax,%ax
    filedup(f);
80105210:	83 ec 0c             	sub    $0xc,%esp
            curproc->ofile[fd] = f;
80105213:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    filedup(f);
80105217:	56                   	push   %esi
80105218:	e8 03 bf ff ff       	call   80101120 <filedup>
    return fd;
8010521d:	83 c4 10             	add    $0x10,%esp
}
80105220:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105223:	89 d8                	mov    %ebx,%eax
80105225:	5b                   	pop    %ebx
80105226:	5e                   	pop    %esi
80105227:	5d                   	pop    %ebp
80105228:	c3                   	ret    
80105229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105230 <sys_read>:
int sys_read(void) {
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	56                   	push   %esi
80105234:	53                   	push   %ebx
    if (argint(n, &fd) < 0) {
80105235:	8d 5d f4             	lea    -0xc(%ebp),%ebx
int sys_read(void) {
80105238:	83 ec 18             	sub    $0x18,%esp
    if (argint(n, &fd) < 0) {
8010523b:	53                   	push   %ebx
8010523c:	6a 00                	push   $0x0
8010523e:	e8 1d fc ff ff       	call   80104e60 <argint>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	85 c0                	test   %eax,%eax
80105248:	78 5e                	js     801052a8 <sys_read+0x78>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) {
8010524a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010524e:	77 58                	ja     801052a8 <sys_read+0x78>
80105250:	e8 5b ec ff ff       	call   80103eb0 <myproc>
80105255:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105258:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010525c:	85 f6                	test   %esi,%esi
8010525e:	74 48                	je     801052a8 <sys_read+0x78>
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
80105260:	83 ec 08             	sub    $0x8,%esp
80105263:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105266:	50                   	push   %eax
80105267:	6a 02                	push   $0x2
80105269:	e8 f2 fb ff ff       	call   80104e60 <argint>
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	85 c0                	test   %eax,%eax
80105273:	78 33                	js     801052a8 <sys_read+0x78>
80105275:	83 ec 04             	sub    $0x4,%esp
80105278:	ff 75 f0             	push   -0x10(%ebp)
8010527b:	53                   	push   %ebx
8010527c:	6a 01                	push   $0x1
8010527e:	e8 2d fc ff ff       	call   80104eb0 <argptr>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	78 1e                	js     801052a8 <sys_read+0x78>
    return fileread(f, p, n);
8010528a:	83 ec 04             	sub    $0x4,%esp
8010528d:	ff 75 f0             	push   -0x10(%ebp)
80105290:	ff 75 f4             	push   -0xc(%ebp)
80105293:	56                   	push   %esi
80105294:	e8 07 c0 ff ff       	call   801012a0 <fileread>
80105299:	83 c4 10             	add    $0x10,%esp
}
8010529c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010529f:	5b                   	pop    %ebx
801052a0:	5e                   	pop    %esi
801052a1:	5d                   	pop    %ebp
801052a2:	c3                   	ret    
801052a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052a7:	90                   	nop
        return -1;
801052a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ad:	eb ed                	jmp    8010529c <sys_read+0x6c>
801052af:	90                   	nop

801052b0 <sys_write>:
int sys_write(void) {
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	56                   	push   %esi
801052b4:	53                   	push   %ebx
    if (argint(n, &fd) < 0) {
801052b5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
int sys_write(void) {
801052b8:	83 ec 18             	sub    $0x18,%esp
    if (argint(n, &fd) < 0) {
801052bb:	53                   	push   %ebx
801052bc:	6a 00                	push   $0x0
801052be:	e8 9d fb ff ff       	call   80104e60 <argint>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	85 c0                	test   %eax,%eax
801052c8:	78 5e                	js     80105328 <sys_write+0x78>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) {
801052ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052ce:	77 58                	ja     80105328 <sys_write+0x78>
801052d0:	e8 db eb ff ff       	call   80103eb0 <myproc>
801052d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801052dc:	85 f6                	test   %esi,%esi
801052de:	74 48                	je     80105328 <sys_write+0x78>
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
801052e0:	83 ec 08             	sub    $0x8,%esp
801052e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052e6:	50                   	push   %eax
801052e7:	6a 02                	push   $0x2
801052e9:	e8 72 fb ff ff       	call   80104e60 <argint>
801052ee:	83 c4 10             	add    $0x10,%esp
801052f1:	85 c0                	test   %eax,%eax
801052f3:	78 33                	js     80105328 <sys_write+0x78>
801052f5:	83 ec 04             	sub    $0x4,%esp
801052f8:	ff 75 f0             	push   -0x10(%ebp)
801052fb:	53                   	push   %ebx
801052fc:	6a 01                	push   $0x1
801052fe:	e8 ad fb ff ff       	call   80104eb0 <argptr>
80105303:	83 c4 10             	add    $0x10,%esp
80105306:	85 c0                	test   %eax,%eax
80105308:	78 1e                	js     80105328 <sys_write+0x78>
    return filewrite(f, p, n);
8010530a:	83 ec 04             	sub    $0x4,%esp
8010530d:	ff 75 f0             	push   -0x10(%ebp)
80105310:	ff 75 f4             	push   -0xc(%ebp)
80105313:	56                   	push   %esi
80105314:	e8 17 c0 ff ff       	call   80101330 <filewrite>
80105319:	83 c4 10             	add    $0x10,%esp
}
8010531c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010531f:	5b                   	pop    %ebx
80105320:	5e                   	pop    %esi
80105321:	5d                   	pop    %ebp
80105322:	c3                   	ret    
80105323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105327:	90                   	nop
        return -1;
80105328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532d:	eb ed                	jmp    8010531c <sys_write+0x6c>
8010532f:	90                   	nop

80105330 <sys_close>:
int sys_close(void) {
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	56                   	push   %esi
80105334:	53                   	push   %ebx
    if (argint(n, &fd) < 0) {
80105335:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_close(void) {
80105338:	83 ec 18             	sub    $0x18,%esp
    if (argint(n, &fd) < 0) {
8010533b:	50                   	push   %eax
8010533c:	6a 00                	push   $0x0
8010533e:	e8 1d fb ff ff       	call   80104e60 <argint>
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	85 c0                	test   %eax,%eax
80105348:	78 3e                	js     80105388 <sys_close+0x58>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) {
8010534a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010534e:	77 38                	ja     80105388 <sys_close+0x58>
80105350:	e8 5b eb ff ff       	call   80103eb0 <myproc>
80105355:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105358:	8d 5a 08             	lea    0x8(%edx),%ebx
8010535b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010535f:	85 f6                	test   %esi,%esi
80105361:	74 25                	je     80105388 <sys_close+0x58>
    myproc()->ofile[fd] = 0;
80105363:	e8 48 eb ff ff       	call   80103eb0 <myproc>
    fileclose(f);
80105368:	83 ec 0c             	sub    $0xc,%esp
    myproc()->ofile[fd] = 0;
8010536b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105372:	00 
    fileclose(f);
80105373:	56                   	push   %esi
80105374:	e8 f7 bd ff ff       	call   80101170 <fileclose>
    return 0;
80105379:	83 c4 10             	add    $0x10,%esp
8010537c:	31 c0                	xor    %eax,%eax
}
8010537e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105381:	5b                   	pop    %ebx
80105382:	5e                   	pop    %esi
80105383:	5d                   	pop    %ebp
80105384:	c3                   	ret    
80105385:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80105388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538d:	eb ef                	jmp    8010537e <sys_close+0x4e>
8010538f:	90                   	nop

80105390 <sys_fstat>:
int sys_fstat(void) {
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	56                   	push   %esi
80105394:	53                   	push   %ebx
    if (argint(n, &fd) < 0) {
80105395:	8d 5d f4             	lea    -0xc(%ebp),%ebx
int sys_fstat(void) {
80105398:	83 ec 18             	sub    $0x18,%esp
    if (argint(n, &fd) < 0) {
8010539b:	53                   	push   %ebx
8010539c:	6a 00                	push   $0x0
8010539e:	e8 bd fa ff ff       	call   80104e60 <argint>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	78 46                	js     801053f0 <sys_fstat+0x60>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) {
801053aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053ae:	77 40                	ja     801053f0 <sys_fstat+0x60>
801053b0:	e8 fb ea ff ff       	call   80103eb0 <myproc>
801053b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801053bc:	85 f6                	test   %esi,%esi
801053be:	74 30                	je     801053f0 <sys_fstat+0x60>
    if (argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0) {
801053c0:	83 ec 04             	sub    $0x4,%esp
801053c3:	6a 14                	push   $0x14
801053c5:	53                   	push   %ebx
801053c6:	6a 01                	push   $0x1
801053c8:	e8 e3 fa ff ff       	call   80104eb0 <argptr>
801053cd:	83 c4 10             	add    $0x10,%esp
801053d0:	85 c0                	test   %eax,%eax
801053d2:	78 1c                	js     801053f0 <sys_fstat+0x60>
    return filestat(f, st);
801053d4:	83 ec 08             	sub    $0x8,%esp
801053d7:	ff 75 f4             	push   -0xc(%ebp)
801053da:	56                   	push   %esi
801053db:	e8 70 be ff ff       	call   80101250 <filestat>
801053e0:	83 c4 10             	add    $0x10,%esp
}
801053e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053e6:	5b                   	pop    %ebx
801053e7:	5e                   	pop    %esi
801053e8:	5d                   	pop    %ebp
801053e9:	c3                   	ret    
801053ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
801053f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f5:	eb ec                	jmp    801053e3 <sys_fstat+0x53>
801053f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fe:	66 90                	xchg   %ax,%ax

80105400 <cleanupsyslink>:
void cleanupsyslink(struct inode * ip) {
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	53                   	push   %ebx
80105404:	83 ec 10             	sub    $0x10,%esp
80105407:	8b 5d 08             	mov    0x8(%ebp),%ebx
    ilock(ip);
8010540a:	53                   	push   %ebx
8010540b:	e8 f0 c5 ff ff       	call   80101a00 <ilock>
    ip->nlink--;
80105410:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
    iupdate(ip);
80105415:	89 1c 24             	mov    %ebx,(%esp)
80105418:	e8 33 c5 ff ff       	call   80101950 <iupdate>
    iunlockput(ip);
8010541d:	89 1c 24             	mov    %ebx,(%esp)
80105420:	e8 6b c8 ff ff       	call   80101c90 <iunlockput>
}
80105425:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    end_op();
80105428:	83 c4 10             	add    $0x10,%esp
}
8010542b:	c9                   	leave  
    end_op();
8010542c:	e9 9f de ff ff       	jmp    801032d0 <end_op>
80105431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543f:	90                   	nop

80105440 <sys_link>:
int sys_link(void) {
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
    if (argstr(0, &old) < 0 || argstr(1, &new) < 0) {
80105445:	8d 45 d4             	lea    -0x2c(%ebp),%eax
int sys_link(void) {
80105448:	53                   	push   %ebx
80105449:	83 ec 34             	sub    $0x34,%esp
    if (argstr(0, &old) < 0 || argstr(1, &new) < 0) {
8010544c:	50                   	push   %eax
8010544d:	6a 00                	push   $0x0
8010544f:	e8 cc fa ff ff       	call   80104f20 <argstr>
80105454:	83 c4 10             	add    $0x10,%esp
80105457:	85 c0                	test   %eax,%eax
80105459:	0f 88 ff 00 00 00    	js     8010555e <sys_link+0x11e>
8010545f:	83 ec 08             	sub    $0x8,%esp
80105462:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105465:	50                   	push   %eax
80105466:	6a 01                	push   $0x1
80105468:	e8 b3 fa ff ff       	call   80104f20 <argstr>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	0f 88 e6 00 00 00    	js     8010555e <sys_link+0x11e>
    begin_op();
80105478:	e8 e3 dd ff ff       	call   80103260 <begin_op>
    if ((ip = namei(old)) == 0) {
8010547d:	83 ec 0c             	sub    $0xc,%esp
80105480:	ff 75 d4             	push   -0x2c(%ebp)
80105483:	e8 98 ce ff ff       	call   80102320 <namei>
80105488:	83 c4 10             	add    $0x10,%esp
8010548b:	89 c3                	mov    %eax,%ebx
8010548d:	85 c0                	test   %eax,%eax
8010548f:	0f 84 e8 00 00 00    	je     8010557d <sys_link+0x13d>
    ilock(ip);
80105495:	83 ec 0c             	sub    $0xc,%esp
80105498:	50                   	push   %eax
80105499:	e8 62 c5 ff ff       	call   80101a00 <ilock>
    if (ip->type == T_DIR) {
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a6:	0f 84 b9 00 00 00    	je     80105565 <sys_link+0x125>
    iupdate(ip);
801054ac:	83 ec 0c             	sub    $0xc,%esp
    ip->nlink++;
801054af:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    if ((dp = nameiparent(new, name)) == 0) {
801054b4:	8d 7d da             	lea    -0x26(%ebp),%edi
    iupdate(ip);
801054b7:	53                   	push   %ebx
801054b8:	e8 93 c4 ff ff       	call   80101950 <iupdate>
    iunlock(ip);
801054bd:	89 1c 24             	mov    %ebx,(%esp)
801054c0:	e8 1b c6 ff ff       	call   80101ae0 <iunlock>
    if ((dp = nameiparent(new, name)) == 0) {
801054c5:	58                   	pop    %eax
801054c6:	5a                   	pop    %edx
801054c7:	57                   	push   %edi
801054c8:	ff 75 d0             	push   -0x30(%ebp)
801054cb:	e8 70 ce ff ff       	call   80102340 <nameiparent>
801054d0:	83 c4 10             	add    $0x10,%esp
801054d3:	89 c6                	mov    %eax,%esi
801054d5:	85 c0                	test   %eax,%eax
801054d7:	0f 84 ac 00 00 00    	je     80105589 <sys_link+0x149>
    ilock(dp);
801054dd:	83 ec 0c             	sub    $0xc,%esp
801054e0:	50                   	push   %eax
801054e1:	e8 1a c5 ff ff       	call   80101a00 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
801054e6:	8b 03                	mov    (%ebx),%eax
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	39 06                	cmp    %eax,(%esi)
801054ed:	75 41                	jne    80105530 <sys_link+0xf0>
801054ef:	83 ec 04             	sub    $0x4,%esp
801054f2:	ff 73 04             	push   0x4(%ebx)
801054f5:	57                   	push   %edi
801054f6:	56                   	push   %esi
801054f7:	e8 64 cd ff ff       	call   80102260 <dirlink>
801054fc:	83 c4 10             	add    $0x10,%esp
801054ff:	85 c0                	test   %eax,%eax
80105501:	78 2d                	js     80105530 <sys_link+0xf0>
    iunlockput(dp);
80105503:	83 ec 0c             	sub    $0xc,%esp
80105506:	56                   	push   %esi
80105507:	e8 84 c7 ff ff       	call   80101c90 <iunlockput>
    iput(ip);
8010550c:	89 1c 24             	mov    %ebx,(%esp)
8010550f:	e8 1c c6 ff ff       	call   80101b30 <iput>
    end_op();
80105514:	e8 b7 dd ff ff       	call   801032d0 <end_op>
    return 0;
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	31 c0                	xor    %eax,%eax
}
8010551e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105521:	5b                   	pop    %ebx
80105522:	5e                   	pop    %esi
80105523:	5f                   	pop    %edi
80105524:	5d                   	pop    %ebp
80105525:	c3                   	ret    
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
        iunlockput(dp);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	56                   	push   %esi
80105534:	e8 57 c7 ff ff       	call   80101c90 <iunlockput>
    ilock(ip);
80105539:	89 1c 24             	mov    %ebx,(%esp)
8010553c:	e8 bf c4 ff ff       	call   80101a00 <ilock>
    ip->nlink--;
80105541:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
    iupdate(ip);
80105546:	89 1c 24             	mov    %ebx,(%esp)
80105549:	e8 02 c4 ff ff       	call   80101950 <iupdate>
    iunlockput(ip);
8010554e:	89 1c 24             	mov    %ebx,(%esp)
80105551:	e8 3a c7 ff ff       	call   80101c90 <iunlockput>
    end_op();
80105556:	e8 75 dd ff ff       	call   801032d0 <end_op>
}
8010555b:	83 c4 10             	add    $0x10,%esp
        return -1;
8010555e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105563:	eb b9                	jmp    8010551e <sys_link+0xde>
        iunlockput(ip);
80105565:	83 ec 0c             	sub    $0xc,%esp
80105568:	53                   	push   %ebx
80105569:	e8 22 c7 ff ff       	call   80101c90 <iunlockput>
        end_op();
8010556e:	e8 5d dd ff ff       	call   801032d0 <end_op>
        return -1;
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557b:	eb a1                	jmp    8010551e <sys_link+0xde>
        end_op();
8010557d:	e8 4e dd ff ff       	call   801032d0 <end_op>
        return -1;
80105582:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105587:	eb 95                	jmp    8010551e <sys_link+0xde>
    ilock(ip);
80105589:	83 ec 0c             	sub    $0xc,%esp
8010558c:	53                   	push   %ebx
8010558d:	eb ad                	jmp    8010553c <sys_link+0xfc>
8010558f:	90                   	nop

80105590 <sys_unlink>:
int sys_unlink(void) {
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
    if (argstr(0, &path) < 0) {
80105595:	8d 45 c0             	lea    -0x40(%ebp),%eax
int sys_unlink(void) {
80105598:	53                   	push   %ebx
80105599:	83 ec 54             	sub    $0x54,%esp
    if (argstr(0, &path) < 0) {
8010559c:	50                   	push   %eax
8010559d:	6a 00                	push   $0x0
8010559f:	e8 7c f9 ff ff       	call   80104f20 <argstr>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	85 c0                	test   %eax,%eax
801055a9:	0f 88 4c 01 00 00    	js     801056fb <sys_unlink+0x16b>
    begin_op();
801055af:	e8 ac dc ff ff       	call   80103260 <begin_op>
    if ((dp = nameiparent(path, name)) == 0) {
801055b4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801055b7:	83 ec 08             	sub    $0x8,%esp
801055ba:	53                   	push   %ebx
801055bb:	ff 75 c0             	push   -0x40(%ebp)
801055be:	e8 7d cd ff ff       	call   80102340 <nameiparent>
801055c3:	83 c4 10             	add    $0x10,%esp
801055c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801055c9:	85 c0                	test   %eax,%eax
801055cb:	0f 84 55 01 00 00    	je     80105726 <sys_unlink+0x196>
    ilock(dp);
801055d1:	83 ec 0c             	sub    $0xc,%esp
801055d4:	ff 75 b4             	push   -0x4c(%ebp)
801055d7:	e8 24 c4 ff ff       	call   80101a00 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) {
801055dc:	5a                   	pop    %edx
801055dd:	59                   	pop    %ecx
801055de:	68 48 82 10 80       	push   $0x80108248
801055e3:	53                   	push   %ebx
801055e4:	e8 57 c9 ff ff       	call   80101f40 <namecmp>
801055e9:	83 c4 10             	add    $0x10,%esp
801055ec:	85 c0                	test   %eax,%eax
801055ee:	0f 84 2d 01 00 00    	je     80105721 <sys_unlink+0x191>
801055f4:	83 ec 08             	sub    $0x8,%esp
801055f7:	68 47 82 10 80       	push   $0x80108247
801055fc:	53                   	push   %ebx
801055fd:	e8 3e c9 ff ff       	call   80101f40 <namecmp>
80105602:	83 c4 10             	add    $0x10,%esp
80105605:	85 c0                	test   %eax,%eax
80105607:	0f 84 14 01 00 00    	je     80105721 <sys_unlink+0x191>
    if ((ip = dirlookup(dp, name, &off)) == 0) {
8010560d:	83 ec 04             	sub    $0x4,%esp
80105610:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105613:	50                   	push   %eax
80105614:	53                   	push   %ebx
80105615:	ff 75 b4             	push   -0x4c(%ebp)
80105618:	e8 43 c9 ff ff       	call   80101f60 <dirlookup>
8010561d:	83 c4 10             	add    $0x10,%esp
80105620:	89 c3                	mov    %eax,%ebx
80105622:	85 c0                	test   %eax,%eax
80105624:	0f 84 f7 00 00 00    	je     80105721 <sys_unlink+0x191>
    ilock(ip);
8010562a:	83 ec 0c             	sub    $0xc,%esp
8010562d:	50                   	push   %eax
8010562e:	e8 cd c3 ff ff       	call   80101a00 <ilock>
    if (ip->nlink < 1) {
80105633:	83 c4 10             	add    $0x10,%esp
80105636:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010563b:	0f 8e 01 01 00 00    	jle    80105742 <sys_unlink+0x1b2>
    if (ip->type == T_DIR && !isdirempty(ip)) {
80105641:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105646:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105649:	74 65                	je     801056b0 <sys_unlink+0x120>
    memset(&de, 0, sizeof(de));
8010564b:	83 ec 04             	sub    $0x4,%esp
8010564e:	6a 10                	push   $0x10
80105650:	6a 00                	push   $0x0
80105652:	57                   	push   %edi
80105653:	e8 48 f5 ff ff       	call   80104ba0 <memset>
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80105658:	6a 10                	push   $0x10
8010565a:	ff 75 c4             	push   -0x3c(%ebp)
8010565d:	57                   	push   %edi
8010565e:	ff 75 b4             	push   -0x4c(%ebp)
80105661:	e8 aa c7 ff ff       	call   80101e10 <writei>
80105666:	83 c4 20             	add    $0x20,%esp
80105669:	83 f8 10             	cmp    $0x10,%eax
8010566c:	0f 85 dd 00 00 00    	jne    8010574f <sys_unlink+0x1bf>
    if (ip->type == T_DIR) {
80105672:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105677:	0f 84 8b 00 00 00    	je     80105708 <sys_unlink+0x178>
    iunlockput(dp);
8010567d:	83 ec 0c             	sub    $0xc,%esp
80105680:	ff 75 b4             	push   -0x4c(%ebp)
80105683:	e8 08 c6 ff ff       	call   80101c90 <iunlockput>
    ip->nlink--;
80105688:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
    iupdate(ip);
8010568d:	89 1c 24             	mov    %ebx,(%esp)
80105690:	e8 bb c2 ff ff       	call   80101950 <iupdate>
    iunlockput(ip);
80105695:	89 1c 24             	mov    %ebx,(%esp)
80105698:	e8 f3 c5 ff ff       	call   80101c90 <iunlockput>
    end_op();
8010569d:	e8 2e dc ff ff       	call   801032d0 <end_op>
    return 0;
801056a2:	83 c4 10             	add    $0x10,%esp
801056a5:	31 c0                	xor    %eax,%eax
}
801056a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056aa:	5b                   	pop    %ebx
801056ab:	5e                   	pop    %esi
801056ac:	5f                   	pop    %edi
801056ad:	5d                   	pop    %ebp
801056ae:	c3                   	ret    
801056af:	90                   	nop
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
801056b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801056b4:	76 95                	jbe    8010564b <sys_unlink+0xbb>
801056b6:	be 20 00 00 00       	mov    $0x20,%esi
801056bb:	eb 0b                	jmp    801056c8 <sys_unlink+0x138>
801056bd:	8d 76 00             	lea    0x0(%esi),%esi
801056c0:	83 c6 10             	add    $0x10,%esi
801056c3:	39 73 58             	cmp    %esi,0x58(%ebx)
801056c6:	76 83                	jbe    8010564b <sys_unlink+0xbb>
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
801056c8:	6a 10                	push   $0x10
801056ca:	56                   	push   %esi
801056cb:	57                   	push   %edi
801056cc:	53                   	push   %ebx
801056cd:	e8 3e c6 ff ff       	call   80101d10 <readi>
801056d2:	83 c4 10             	add    $0x10,%esp
801056d5:	83 f8 10             	cmp    $0x10,%eax
801056d8:	75 5b                	jne    80105735 <sys_unlink+0x1a5>
        if (de.inum != 0) {
801056da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056df:	74 df                	je     801056c0 <sys_unlink+0x130>
        iunlockput(ip);
801056e1:	83 ec 0c             	sub    $0xc,%esp
801056e4:	53                   	push   %ebx
801056e5:	e8 a6 c5 ff ff       	call   80101c90 <iunlockput>
        iunlockput(dp);
801056ea:	58                   	pop    %eax
801056eb:	ff 75 b4             	push   -0x4c(%ebp)
801056ee:	e8 9d c5 ff ff       	call   80101c90 <iunlockput>
        end_op();
801056f3:	e8 d8 db ff ff       	call   801032d0 <end_op>
        return -1;       
801056f8:	83 c4 10             	add    $0x10,%esp
801056fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105700:	eb a5                	jmp    801056a7 <sys_unlink+0x117>
80105702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        dp->nlink--;
80105708:	8b 45 b4             	mov    -0x4c(%ebp),%eax
        iupdate(dp);
8010570b:	83 ec 0c             	sub    $0xc,%esp
        dp->nlink--;
8010570e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
        iupdate(dp);
80105713:	50                   	push   %eax
80105714:	e8 37 c2 ff ff       	call   80101950 <iupdate>
80105719:	83 c4 10             	add    $0x10,%esp
8010571c:	e9 5c ff ff ff       	jmp    8010567d <sys_unlink+0xed>
        iunlockput(dp);
80105721:	83 ec 0c             	sub    $0xc,%esp
80105724:	eb c5                	jmp    801056eb <sys_unlink+0x15b>
        end_op();
80105726:	e8 a5 db ff ff       	call   801032d0 <end_op>
        return -1;
8010572b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105730:	e9 72 ff ff ff       	jmp    801056a7 <sys_unlink+0x117>
            panic("isdirempty: readi");
80105735:	83 ec 0c             	sub    $0xc,%esp
80105738:	68 6c 82 10 80       	push   $0x8010826c
8010573d:	e8 3e ad ff ff       	call   80100480 <panic>
        panic("unlink: nlink < 1");
80105742:	83 ec 0c             	sub    $0xc,%esp
80105745:	68 5a 82 10 80       	push   $0x8010825a
8010574a:	e8 31 ad ff ff       	call   80100480 <panic>
        panic("unlink: writei");
8010574f:	83 ec 0c             	sub    $0xc,%esp
80105752:	68 7e 82 10 80       	push   $0x8010827e
80105757:	e8 24 ad ff ff       	call   80100480 <panic>
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105760 <sys_open>:

int sys_open(void) {
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	57                   	push   %edi
80105764:	56                   	push   %esi
    char *path;
    int fd, omode;
    struct file *f;
    struct inode *ip;

    if (argstr(0, &path) < 0 || argint(1, &omode) < 0) {
80105765:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_open(void) {
80105768:	53                   	push   %ebx
80105769:	83 ec 24             	sub    $0x24,%esp
    if (argstr(0, &path) < 0 || argint(1, &omode) < 0) {
8010576c:	50                   	push   %eax
8010576d:	6a 00                	push   $0x0
8010576f:	e8 ac f7 ff ff       	call   80104f20 <argstr>
80105774:	83 c4 10             	add    $0x10,%esp
80105777:	85 c0                	test   %eax,%eax
80105779:	0f 88 8e 00 00 00    	js     8010580d <sys_open+0xad>
8010577f:	83 ec 08             	sub    $0x8,%esp
80105782:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105785:	50                   	push   %eax
80105786:	6a 01                	push   $0x1
80105788:	e8 d3 f6 ff ff       	call   80104e60 <argint>
8010578d:	83 c4 10             	add    $0x10,%esp
80105790:	85 c0                	test   %eax,%eax
80105792:	78 79                	js     8010580d <sys_open+0xad>
        return -1;
    }

    begin_op();
80105794:	e8 c7 da ff ff       	call   80103260 <begin_op>

    if (omode & O_CREATE) {
80105799:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010579d:	75 79                	jne    80105818 <sys_open+0xb8>
            end_op();
            return -1;
        }
    }
    else {
        if ((ip = namei(path)) == 0) {
8010579f:	83 ec 0c             	sub    $0xc,%esp
801057a2:	ff 75 e0             	push   -0x20(%ebp)
801057a5:	e8 76 cb ff ff       	call   80102320 <namei>
801057aa:	83 c4 10             	add    $0x10,%esp
801057ad:	89 c6                	mov    %eax,%esi
801057af:	85 c0                	test   %eax,%eax
801057b1:	0f 84 7e 00 00 00    	je     80105835 <sys_open+0xd5>
            end_op();
            return -1;
        }
        ilock(ip);
801057b7:	83 ec 0c             	sub    $0xc,%esp
801057ba:	50                   	push   %eax
801057bb:	e8 40 c2 ff ff       	call   80101a00 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY) {
801057c0:	83 c4 10             	add    $0x10,%esp
801057c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057c8:	0f 84 c2 00 00 00    	je     80105890 <sys_open+0x130>
            end_op();
            return -1;
        }
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
801057ce:	e8 dd b8 ff ff       	call   801010b0 <filealloc>
801057d3:	89 c7                	mov    %eax,%edi
801057d5:	85 c0                	test   %eax,%eax
801057d7:	74 23                	je     801057fc <sys_open+0x9c>
    struct proc *curproc = myproc();
801057d9:	e8 d2 e6 ff ff       	call   80103eb0 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
801057de:	31 db                	xor    %ebx,%ebx
        if (curproc->ofile[fd] == 0) {
801057e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057e4:	85 d2                	test   %edx,%edx
801057e6:	74 60                	je     80105848 <sys_open+0xe8>
    for (fd = 0; fd < NOFILE; fd++) {
801057e8:	83 c3 01             	add    $0x1,%ebx
801057eb:	83 fb 10             	cmp    $0x10,%ebx
801057ee:	75 f0                	jne    801057e0 <sys_open+0x80>
        if (f) {
            fileclose(f);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	57                   	push   %edi
801057f4:	e8 77 b9 ff ff       	call   80101170 <fileclose>
801057f9:	83 c4 10             	add    $0x10,%esp
        }
        iunlockput(ip);
801057fc:	83 ec 0c             	sub    $0xc,%esp
801057ff:	56                   	push   %esi
80105800:	e8 8b c4 ff ff       	call   80101c90 <iunlockput>
        end_op();
80105805:	e8 c6 da ff ff       	call   801032d0 <end_op>
        return -1;
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105812:	eb 6d                	jmp    80105881 <sys_open+0x121>
80105814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ip = create(path, T_FILE, 0, 0);
80105818:	83 ec 0c             	sub    $0xc,%esp
8010581b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010581e:	31 c9                	xor    %ecx,%ecx
80105820:	ba 02 00 00 00       	mov    $0x2,%edx
80105825:	6a 00                	push   $0x0
80105827:	e8 e4 f7 ff ff       	call   80105010 <create>
        if (ip == 0) {
8010582c:	83 c4 10             	add    $0x10,%esp
        ip = create(path, T_FILE, 0, 0);
8010582f:	89 c6                	mov    %eax,%esi
        if (ip == 0) {
80105831:	85 c0                	test   %eax,%eax
80105833:	75 99                	jne    801057ce <sys_open+0x6e>
            end_op();
80105835:	e8 96 da ff ff       	call   801032d0 <end_op>
            return -1;
8010583a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010583f:	eb 40                	jmp    80105881 <sys_open+0x121>
80105841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    iunlock(ip);
80105848:	83 ec 0c             	sub    $0xc,%esp
            curproc->ofile[fd] = f;
8010584b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
    iunlock(ip);
8010584f:	56                   	push   %esi
80105850:	e8 8b c2 ff ff       	call   80101ae0 <iunlock>
    end_op();
80105855:	e8 76 da ff ff       	call   801032d0 <end_op>

    f->type = FD_INODE;
8010585a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
    f->ip = ip;
    f->off = 0;
    f->readable = !(omode & O_WRONLY);
80105860:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105863:	83 c4 10             	add    $0x10,%esp
    f->ip = ip;
80105866:	89 77 10             	mov    %esi,0x10(%edi)
    f->readable = !(omode & O_WRONLY);
80105869:	89 d0                	mov    %edx,%eax
    f->off = 0;
8010586b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    f->readable = !(omode & O_WRONLY);
80105872:	f7 d0                	not    %eax
80105874:	83 e0 01             	and    $0x1,%eax
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105877:	83 e2 03             	and    $0x3,%edx
    f->readable = !(omode & O_WRONLY);
8010587a:	88 47 08             	mov    %al,0x8(%edi)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010587d:	0f 95 47 09          	setne  0x9(%edi)
    return fd;
}
80105881:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105884:	89 d8                	mov    %ebx,%eax
80105886:	5b                   	pop    %ebx
80105887:	5e                   	pop    %esi
80105888:	5f                   	pop    %edi
80105889:	5d                   	pop    %ebp
8010588a:	c3                   	ret    
8010588b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010588f:	90                   	nop
        if (ip->type == T_DIR && omode != O_RDONLY) {
80105890:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105893:	85 c9                	test   %ecx,%ecx
80105895:	0f 84 33 ff ff ff    	je     801057ce <sys_open+0x6e>
8010589b:	e9 5c ff ff ff       	jmp    801057fc <sys_open+0x9c>

801058a0 <sys_mkdir>:

int sys_mkdir(void) {
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 18             	sub    $0x18,%esp
    char *path;
    struct inode *ip;

    begin_op();
801058a6:	e8 b5 d9 ff ff       	call   80103260 <begin_op>
    if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
801058ab:	83 ec 08             	sub    $0x8,%esp
801058ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058b1:	50                   	push   %eax
801058b2:	6a 00                	push   $0x0
801058b4:	e8 67 f6 ff ff       	call   80104f20 <argstr>
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	85 c0                	test   %eax,%eax
801058be:	78 30                	js     801058f0 <sys_mkdir+0x50>
801058c0:	83 ec 0c             	sub    $0xc,%esp
801058c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c6:	31 c9                	xor    %ecx,%ecx
801058c8:	ba 01 00 00 00       	mov    $0x1,%edx
801058cd:	6a 00                	push   $0x0
801058cf:	e8 3c f7 ff ff       	call   80105010 <create>
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	85 c0                	test   %eax,%eax
801058d9:	74 15                	je     801058f0 <sys_mkdir+0x50>
        end_op();
        return -1;
    }
    iunlockput(ip);
801058db:	83 ec 0c             	sub    $0xc,%esp
801058de:	50                   	push   %eax
801058df:	e8 ac c3 ff ff       	call   80101c90 <iunlockput>
    end_op();
801058e4:	e8 e7 d9 ff ff       	call   801032d0 <end_op>
    return 0;
801058e9:	83 c4 10             	add    $0x10,%esp
801058ec:	31 c0                	xor    %eax,%eax
}
801058ee:	c9                   	leave  
801058ef:	c3                   	ret    
        end_op();
801058f0:	e8 db d9 ff ff       	call   801032d0 <end_op>
        return -1;
801058f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058fa:	c9                   	leave  
801058fb:	c3                   	ret    
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_mknod>:

int sys_mknod(void) {
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 18             	sub    $0x18,%esp
    struct inode *ip;
    char *path;
    int major, minor;

    begin_op();
80105906:	e8 55 d9 ff ff       	call   80103260 <begin_op>
    if ((argstr(0, &path)) < 0 ||
8010590b:	83 ec 08             	sub    $0x8,%esp
8010590e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105911:	50                   	push   %eax
80105912:	6a 00                	push   $0x0
80105914:	e8 07 f6 ff ff       	call   80104f20 <argstr>
80105919:	83 c4 10             	add    $0x10,%esp
8010591c:	85 c0                	test   %eax,%eax
8010591e:	78 60                	js     80105980 <sys_mknod+0x80>
        argint(1, &major) < 0 ||
80105920:	83 ec 08             	sub    $0x8,%esp
80105923:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105926:	50                   	push   %eax
80105927:	6a 01                	push   $0x1
80105929:	e8 32 f5 ff ff       	call   80104e60 <argint>
    if ((argstr(0, &path)) < 0 ||
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	85 c0                	test   %eax,%eax
80105933:	78 4b                	js     80105980 <sys_mknod+0x80>
        argint(2, &minor) < 0 ||
80105935:	83 ec 08             	sub    $0x8,%esp
80105938:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010593b:	50                   	push   %eax
8010593c:	6a 02                	push   $0x2
8010593e:	e8 1d f5 ff ff       	call   80104e60 <argint>
        argint(1, &major) < 0 ||
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	85 c0                	test   %eax,%eax
80105948:	78 36                	js     80105980 <sys_mknod+0x80>
        (ip = create(path, T_DEV, major, minor)) == 0) {
8010594a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010594e:	83 ec 0c             	sub    $0xc,%esp
80105951:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105955:	ba 03 00 00 00       	mov    $0x3,%edx
8010595a:	50                   	push   %eax
8010595b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010595e:	e8 ad f6 ff ff       	call   80105010 <create>
        argint(2, &minor) < 0 ||
80105963:	83 c4 10             	add    $0x10,%esp
80105966:	85 c0                	test   %eax,%eax
80105968:	74 16                	je     80105980 <sys_mknod+0x80>
        end_op();
        return -1;
    }
    iunlockput(ip);
8010596a:	83 ec 0c             	sub    $0xc,%esp
8010596d:	50                   	push   %eax
8010596e:	e8 1d c3 ff ff       	call   80101c90 <iunlockput>
    end_op();
80105973:	e8 58 d9 ff ff       	call   801032d0 <end_op>
    return 0;
80105978:	83 c4 10             	add    $0x10,%esp
8010597b:	31 c0                	xor    %eax,%eax
}
8010597d:	c9                   	leave  
8010597e:	c3                   	ret    
8010597f:	90                   	nop
        end_op();
80105980:	e8 4b d9 ff ff       	call   801032d0 <end_op>
        return -1;
80105985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010598a:	c9                   	leave  
8010598b:	c3                   	ret    
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105990 <sys_chdir>:

int sys_chdir(void) {
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	56                   	push   %esi
80105994:	53                   	push   %ebx
80105995:	83 ec 10             	sub    $0x10,%esp
    char *path;
    struct inode *ip;
    struct proc *curproc = myproc();
80105998:	e8 13 e5 ff ff       	call   80103eb0 <myproc>
8010599d:	89 c6                	mov    %eax,%esi

    begin_op();
8010599f:	e8 bc d8 ff ff       	call   80103260 <begin_op>
    if (argstr(0, &path) < 0 || (ip = namei(path)) == 0) {
801059a4:	83 ec 08             	sub    $0x8,%esp
801059a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059aa:	50                   	push   %eax
801059ab:	6a 00                	push   $0x0
801059ad:	e8 6e f5 ff ff       	call   80104f20 <argstr>
801059b2:	83 c4 10             	add    $0x10,%esp
801059b5:	85 c0                	test   %eax,%eax
801059b7:	78 77                	js     80105a30 <sys_chdir+0xa0>
801059b9:	83 ec 0c             	sub    $0xc,%esp
801059bc:	ff 75 f4             	push   -0xc(%ebp)
801059bf:	e8 5c c9 ff ff       	call   80102320 <namei>
801059c4:	83 c4 10             	add    $0x10,%esp
801059c7:	89 c3                	mov    %eax,%ebx
801059c9:	85 c0                	test   %eax,%eax
801059cb:	74 63                	je     80105a30 <sys_chdir+0xa0>
        end_op();
        return -1;
    }
    ilock(ip);
801059cd:	83 ec 0c             	sub    $0xc,%esp
801059d0:	50                   	push   %eax
801059d1:	e8 2a c0 ff ff       	call   80101a00 <ilock>
    if (ip->type != T_DIR) {
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059de:	75 30                	jne    80105a10 <sys_chdir+0x80>
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	53                   	push   %ebx
801059e4:	e8 f7 c0 ff ff       	call   80101ae0 <iunlock>
    iput(curproc->cwd);
801059e9:	58                   	pop    %eax
801059ea:	ff 76 68             	push   0x68(%esi)
801059ed:	e8 3e c1 ff ff       	call   80101b30 <iput>
    end_op();
801059f2:	e8 d9 d8 ff ff       	call   801032d0 <end_op>
    curproc->cwd = ip;
801059f7:	89 5e 68             	mov    %ebx,0x68(%esi)
    return 0;
801059fa:	83 c4 10             	add    $0x10,%esp
801059fd:	31 c0                	xor    %eax,%eax
}
801059ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a02:	5b                   	pop    %ebx
80105a03:	5e                   	pop    %esi
80105a04:	5d                   	pop    %ebp
80105a05:	c3                   	ret    
80105a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0d:	8d 76 00             	lea    0x0(%esi),%esi
        iunlockput(ip);
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	53                   	push   %ebx
80105a14:	e8 77 c2 ff ff       	call   80101c90 <iunlockput>
        end_op();
80105a19:	e8 b2 d8 ff ff       	call   801032d0 <end_op>
        return -1;
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a26:	eb d7                	jmp    801059ff <sys_chdir+0x6f>
80105a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2f:	90                   	nop
        end_op();
80105a30:	e8 9b d8 ff ff       	call   801032d0 <end_op>
        return -1;
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3a:	eb c3                	jmp    801059ff <sys_chdir+0x6f>
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_exec>:

int sys_exec(void) {
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	56                   	push   %esi
    char *path, *argv[MAXARG];
    int i;
    uint uargv, uarg;

    if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
80105a45:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
int sys_exec(void) {
80105a4b:	53                   	push   %ebx
80105a4c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
    if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
80105a52:	50                   	push   %eax
80105a53:	6a 00                	push   $0x0
80105a55:	e8 c6 f4 ff ff       	call   80104f20 <argstr>
80105a5a:	83 c4 10             	add    $0x10,%esp
80105a5d:	85 c0                	test   %eax,%eax
80105a5f:	0f 88 87 00 00 00    	js     80105aec <sys_exec+0xac>
80105a65:	83 ec 08             	sub    $0x8,%esp
80105a68:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a6e:	50                   	push   %eax
80105a6f:	6a 01                	push   $0x1
80105a71:	e8 ea f3 ff ff       	call   80104e60 <argint>
80105a76:	83 c4 10             	add    $0x10,%esp
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	78 6f                	js     80105aec <sys_exec+0xac>
        return -1;
    }
    memset(argv, 0, sizeof(argv));
80105a7d:	83 ec 04             	sub    $0x4,%esp
80105a80:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
    for (i = 0;; i++) {
80105a86:	31 db                	xor    %ebx,%ebx
    memset(argv, 0, sizeof(argv));
80105a88:	68 80 00 00 00       	push   $0x80
80105a8d:	6a 00                	push   $0x0
80105a8f:	56                   	push   %esi
80105a90:	e8 0b f1 ff ff       	call   80104ba0 <memset>
80105a95:	83 c4 10             	add    $0x10,%esp
80105a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop
        if (i >= NELEM(argv)) {
            return -1;
        }
        if (fetchint(uargv + 4 * i, (int*)&uarg) < 0) {
80105aa0:	83 ec 08             	sub    $0x8,%esp
80105aa3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105aa9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105ab0:	50                   	push   %eax
80105ab1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105ab7:	01 f8                	add    %edi,%eax
80105ab9:	50                   	push   %eax
80105aba:	e8 11 f3 ff ff       	call   80104dd0 <fetchint>
80105abf:	83 c4 10             	add    $0x10,%esp
80105ac2:	85 c0                	test   %eax,%eax
80105ac4:	78 26                	js     80105aec <sys_exec+0xac>
            return -1;
        }
        if (uarg == 0) {
80105ac6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105acc:	85 c0                	test   %eax,%eax
80105ace:	74 30                	je     80105b00 <sys_exec+0xc0>
            argv[i] = 0;
            break;
        }
        if (fetchstr(uarg, &argv[i]) < 0) {
80105ad0:	83 ec 08             	sub    $0x8,%esp
80105ad3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105ad6:	52                   	push   %edx
80105ad7:	50                   	push   %eax
80105ad8:	e8 33 f3 ff ff       	call   80104e10 <fetchstr>
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	85 c0                	test   %eax,%eax
80105ae2:	78 08                	js     80105aec <sys_exec+0xac>
    for (i = 0;; i++) {
80105ae4:	83 c3 01             	add    $0x1,%ebx
        if (i >= NELEM(argv)) {
80105ae7:	83 fb 20             	cmp    $0x20,%ebx
80105aea:	75 b4                	jne    80105aa0 <sys_exec+0x60>
            return -1;
        }
    }
    return exec(path, argv);
}
80105aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80105aef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af4:	5b                   	pop    %ebx
80105af5:	5e                   	pop    %esi
80105af6:	5f                   	pop    %edi
80105af7:	5d                   	pop    %ebp
80105af8:	c3                   	ret    
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            argv[i] = 0;
80105b00:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b07:	00 00 00 00 
    return exec(path, argv);
80105b0b:	83 ec 08             	sub    $0x8,%esp
80105b0e:	56                   	push   %esi
80105b0f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105b15:	e8 b6 b1 ff ff       	call   80100cd0 <exec>
80105b1a:	83 c4 10             	add    $0x10,%esp
}
80105b1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b20:	5b                   	pop    %ebx
80105b21:	5e                   	pop    %esi
80105b22:	5f                   	pop    %edi
80105b23:	5d                   	pop    %ebp
80105b24:	c3                   	ret    
80105b25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b30 <sys_pipe>:

int sys_pipe(void) {
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	57                   	push   %edi
80105b34:	56                   	push   %esi
    int *fd;
    struct file *rf, *wf;
    int fd0, fd1;

    if (argptr(0, (void*)&fd, 2 * sizeof(fd[0])) < 0) {
80105b35:	8d 45 dc             	lea    -0x24(%ebp),%eax
int sys_pipe(void) {
80105b38:	53                   	push   %ebx
80105b39:	83 ec 20             	sub    $0x20,%esp
    if (argptr(0, (void*)&fd, 2 * sizeof(fd[0])) < 0) {
80105b3c:	6a 08                	push   $0x8
80105b3e:	50                   	push   %eax
80105b3f:	6a 00                	push   $0x0
80105b41:	e8 6a f3 ff ff       	call   80104eb0 <argptr>
80105b46:	83 c4 10             	add    $0x10,%esp
80105b49:	85 c0                	test   %eax,%eax
80105b4b:	78 4a                	js     80105b97 <sys_pipe+0x67>
        return -1;
    }
    if (pipealloc(&rf, &wf) < 0) {
80105b4d:	83 ec 08             	sub    $0x8,%esp
80105b50:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b53:	50                   	push   %eax
80105b54:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b57:	50                   	push   %eax
80105b58:	e8 23 de ff ff       	call   80103980 <pipealloc>
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	85 c0                	test   %eax,%eax
80105b62:	78 33                	js     80105b97 <sys_pipe+0x67>
        return -1;
    }
    fd0 = -1;
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80105b64:	8b 7d e0             	mov    -0x20(%ebp),%edi
    for (fd = 0; fd < NOFILE; fd++) {
80105b67:	31 db                	xor    %ebx,%ebx
    struct proc *curproc = myproc();
80105b69:	e8 42 e3 ff ff       	call   80103eb0 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
80105b6e:	66 90                	xchg   %ax,%ax
        if (curproc->ofile[fd] == 0) {
80105b70:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b74:	85 f6                	test   %esi,%esi
80105b76:	74 28                	je     80105ba0 <sys_pipe+0x70>
    for (fd = 0; fd < NOFILE; fd++) {
80105b78:	83 c3 01             	add    $0x1,%ebx
80105b7b:	83 fb 10             	cmp    $0x10,%ebx
80105b7e:	75 f0                	jne    80105b70 <sys_pipe+0x40>
        if (fd0 >= 0) {
            myproc()->ofile[fd0] = 0;
        }
        fileclose(rf);
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	ff 75 e0             	push   -0x20(%ebp)
80105b86:	e8 e5 b5 ff ff       	call   80101170 <fileclose>
        fileclose(wf);
80105b8b:	58                   	pop    %eax
80105b8c:	ff 75 e4             	push   -0x1c(%ebp)
80105b8f:	e8 dc b5 ff ff       	call   80101170 <fileclose>
        return -1;
80105b94:	83 c4 10             	add    $0x10,%esp
80105b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9c:	eb 53                	jmp    80105bf1 <sys_pipe+0xc1>
80105b9e:	66 90                	xchg   %ax,%ax
            curproc->ofile[fd] = f;
80105ba0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ba3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80105ba7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    struct proc *curproc = myproc();
80105baa:	e8 01 e3 ff ff       	call   80103eb0 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
80105baf:	31 d2                	xor    %edx,%edx
80105bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[fd] == 0) {
80105bb8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105bbc:	85 c9                	test   %ecx,%ecx
80105bbe:	74 20                	je     80105be0 <sys_pipe+0xb0>
    for (fd = 0; fd < NOFILE; fd++) {
80105bc0:	83 c2 01             	add    $0x1,%edx
80105bc3:	83 fa 10             	cmp    $0x10,%edx
80105bc6:	75 f0                	jne    80105bb8 <sys_pipe+0x88>
            myproc()->ofile[fd0] = 0;
80105bc8:	e8 e3 e2 ff ff       	call   80103eb0 <myproc>
80105bcd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105bd4:	00 
80105bd5:	eb a9                	jmp    80105b80 <sys_pipe+0x50>
80105bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bde:	66 90                	xchg   %ax,%ax
            curproc->ofile[fd] = f;
80105be0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
    }
    fd[0] = fd0;
80105be4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105be7:	89 18                	mov    %ebx,(%eax)
    fd[1] = fd1;
80105be9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bec:	89 50 04             	mov    %edx,0x4(%eax)
    return 0;
80105bef:	31 c0                	xor    %eax,%eax
}
80105bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bf4:	5b                   	pop    %ebx
80105bf5:	5e                   	pop    %esi
80105bf6:	5f                   	pop    %edi
80105bf7:	5d                   	pop    %ebp
80105bf8:	c3                   	ret    
80105bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_getch>:

int sys_getch(void) {
    return consoleget();
80105c00:	e9 bb ad ff ff       	jmp    801009c0 <consoleget>
80105c05:	66 90                	xchg   %ax,%ax
80105c07:	66 90                	xchg   %ax,%ax
80105c09:	66 90                	xchg   %ax,%ax
80105c0b:	66 90                	xchg   %ax,%ax
80105c0d:	66 90                	xchg   %ax,%ax
80105c0f:	90                   	nop

80105c10 <sys_fork>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void) {
    return fork();
80105c10:	e9 3b e4 ff ff       	jmp    80104050 <fork>
80105c15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c20 <sys_exit>:
}

int sys_exit(void) {
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	83 ec 08             	sub    $0x8,%esp
    exit();
80105c26:	e8 a5 e6 ff ff       	call   801042d0 <exit>
    return 0;  // not reached
}
80105c2b:	31 c0                	xor    %eax,%eax
80105c2d:	c9                   	leave  
80105c2e:	c3                   	ret    
80105c2f:	90                   	nop

80105c30 <sys_wait>:

int sys_wait(void) {
    return wait();
80105c30:	e9 cb e7 ff ff       	jmp    80104400 <wait>
80105c35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c40 <sys_kill>:
}

int sys_kill(void) {
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	83 ec 20             	sub    $0x20,%esp
    int pid;

    if (argint(0, &pid) < 0) {
80105c46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c49:	50                   	push   %eax
80105c4a:	6a 00                	push   $0x0
80105c4c:	e8 0f f2 ff ff       	call   80104e60 <argint>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	85 c0                	test   %eax,%eax
80105c56:	78 18                	js     80105c70 <sys_kill+0x30>
        return -1;
    }
    return kill(pid);
80105c58:	83 ec 0c             	sub    $0xc,%esp
80105c5b:	ff 75 f4             	push   -0xc(%ebp)
80105c5e:	e8 3d ea ff ff       	call   801046a0 <kill>
80105c63:	83 c4 10             	add    $0x10,%esp
}
80105c66:	c9                   	leave  
80105c67:	c3                   	ret    
80105c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6f:	90                   	nop
80105c70:	c9                   	leave  
        return -1;
80105c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c76:	c3                   	ret    
80105c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7e:	66 90                	xchg   %ax,%ax

80105c80 <sys_getpid>:

int sys_getpid(void) {
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80105c86:	e8 25 e2 ff ff       	call   80103eb0 <myproc>
80105c8b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c8e:	c9                   	leave  
80105c8f:	c3                   	ret    

80105c90 <sys_sbrk>:

int sys_sbrk(void) {
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	53                   	push   %ebx
    int addr;
    int n;

    if (argint(0, &n) < 0) {
80105c94:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sbrk(void) {
80105c97:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0) {
80105c9a:	50                   	push   %eax
80105c9b:	6a 00                	push   $0x0
80105c9d:	e8 be f1 ff ff       	call   80104e60 <argint>
80105ca2:	83 c4 10             	add    $0x10,%esp
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	78 27                	js     80105cd0 <sys_sbrk+0x40>
        return -1;
    }
    addr = myproc()->sz;
80105ca9:	e8 02 e2 ff ff       	call   80103eb0 <myproc>
    if (growproc(n) < 0) {
80105cae:	83 ec 0c             	sub    $0xc,%esp
    addr = myproc()->sz;
80105cb1:	8b 18                	mov    (%eax),%ebx
    if (growproc(n) < 0) {
80105cb3:	ff 75 f4             	push   -0xc(%ebp)
80105cb6:	e8 15 e3 ff ff       	call   80103fd0 <growproc>
80105cbb:	83 c4 10             	add    $0x10,%esp
80105cbe:	85 c0                	test   %eax,%eax
80105cc0:	78 0e                	js     80105cd0 <sys_sbrk+0x40>
        return -1;
    }
    return addr;
}
80105cc2:	89 d8                	mov    %ebx,%eax
80105cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cc7:	c9                   	leave  
80105cc8:	c3                   	ret    
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105cd0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cd5:	eb eb                	jmp    80105cc2 <sys_sbrk+0x32>
80105cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cde:	66 90                	xchg   %ax,%ax

80105ce0 <sys_sleep>:

int sys_sleep(void) {
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	53                   	push   %ebx
    int n;
    uint ticks0;

    if (argint(0, &n) < 0) {
80105ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
80105ce7:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0) {
80105cea:	50                   	push   %eax
80105ceb:	6a 00                	push   $0x0
80105ced:	e8 6e f1 ff ff       	call   80104e60 <argint>
80105cf2:	83 c4 10             	add    $0x10,%esp
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	0f 88 8a 00 00 00    	js     80105d87 <sys_sleep+0xa7>
        return -1;
    }
    acquire(&tickslock);
80105cfd:	83 ec 0c             	sub    $0xc,%esp
80105d00:	68 00 6d 11 80       	push   $0x80116d00
80105d05:	e8 d6 ed ff ff       	call   80104ae0 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
80105d0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    ticks0 = ticks;
80105d0d:	8b 1d e0 6c 11 80    	mov    0x80116ce0,%ebx
    while (ticks - ticks0 < n) {
80105d13:	83 c4 10             	add    $0x10,%esp
80105d16:	85 d2                	test   %edx,%edx
80105d18:	75 27                	jne    80105d41 <sys_sleep+0x61>
80105d1a:	eb 54                	jmp    80105d70 <sys_sleep+0x90>
80105d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80105d20:	83 ec 08             	sub    $0x8,%esp
80105d23:	68 00 6d 11 80       	push   $0x80116d00
80105d28:	68 e0 6c 11 80       	push   $0x80116ce0
80105d2d:	e8 4e e8 ff ff       	call   80104580 <sleep>
    while (ticks - ticks0 < n) {
80105d32:	a1 e0 6c 11 80       	mov    0x80116ce0,%eax
80105d37:	83 c4 10             	add    $0x10,%esp
80105d3a:	29 d8                	sub    %ebx,%eax
80105d3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d3f:	73 2f                	jae    80105d70 <sys_sleep+0x90>
        if (myproc()->killed) {
80105d41:	e8 6a e1 ff ff       	call   80103eb0 <myproc>
80105d46:	8b 40 24             	mov    0x24(%eax),%eax
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	74 d3                	je     80105d20 <sys_sleep+0x40>
            release(&tickslock);
80105d4d:	83 ec 0c             	sub    $0xc,%esp
80105d50:	68 00 6d 11 80       	push   $0x80116d00
80105d55:	e8 26 ed ff ff       	call   80104a80 <release>
    }
    release(&tickslock);
    return 0;
}
80105d5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return -1;
80105d5d:	83 c4 10             	add    $0x10,%esp
80105d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d65:	c9                   	leave  
80105d66:	c3                   	ret    
80105d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6e:	66 90                	xchg   %ax,%ax
    release(&tickslock);
80105d70:	83 ec 0c             	sub    $0xc,%esp
80105d73:	68 00 6d 11 80       	push   $0x80116d00
80105d78:	e8 03 ed ff ff       	call   80104a80 <release>
    return 0;
80105d7d:	83 c4 10             	add    $0x10,%esp
80105d80:	31 c0                	xor    %eax,%eax
}
80105d82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d85:	c9                   	leave  
80105d86:	c3                   	ret    
        return -1;
80105d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d8c:	eb f4                	jmp    80105d82 <sys_sleep+0xa2>
80105d8e:	66 90                	xchg   %ax,%ax

80105d90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	53                   	push   %ebx
80105d94:	83 ec 10             	sub    $0x10,%esp
    uint xticks;

    acquire(&tickslock);
80105d97:	68 00 6d 11 80       	push   $0x80116d00
80105d9c:	e8 3f ed ff ff       	call   80104ae0 <acquire>
    xticks = ticks;
80105da1:	8b 1d e0 6c 11 80    	mov    0x80116ce0,%ebx
    release(&tickslock);
80105da7:	c7 04 24 00 6d 11 80 	movl   $0x80116d00,(%esp)
80105dae:	e8 cd ec ff ff       	call   80104a80 <release>
    return xticks;
}
80105db3:	89 d8                	mov    %ebx,%eax
80105db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105db8:	c9                   	leave  
80105db9:	c3                   	ret    

80105dba <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
    pushl %ds
80105dba:	1e                   	push   %ds
    pushl %es
80105dbb:	06                   	push   %es
    pushl %fs
80105dbc:	0f a0                	push   %fs
    pushl %gs
80105dbe:	0f a8                	push   %gs
    pushal
80105dc0:	60                   	pusha  
  
    # Set up data segments.
    movw $(SEG_KDATA<<3), %ax
80105dc1:	66 b8 10 00          	mov    $0x10,%ax
    movw %ax, %ds
80105dc5:	8e d8                	mov    %eax,%ds
    movw %ax, %es
80105dc7:	8e c0                	mov    %eax,%es

    # Call trap(tf), where tf=%esp
    pushl %esp
80105dc9:	54                   	push   %esp
    call trap
80105dca:	e8 c1 00 00 00       	call   80105e90 <trap>
    addl $4, %esp
80105dcf:	83 c4 04             	add    $0x4,%esp

80105dd2 <trapret>:

    # Return falls through to trapret...
.globl trapret
trapret:
    popal
80105dd2:	61                   	popa   
    popl %gs
80105dd3:	0f a9                	pop    %gs
    popl %fs
80105dd5:	0f a1                	pop    %fs
    popl %es
80105dd7:	07                   	pop    %es
    popl %ds
80105dd8:	1f                   	pop    %ds
    addl $0x8, %esp  # trapno and errcode
80105dd9:	83 c4 08             	add    $0x8,%esp
    iret
80105ddc:	cf                   	iret   
80105ddd:	66 90                	xchg   %ax,%ax
80105ddf:	90                   	nop

80105de0 <tvinit>:
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
80105de0:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) {
80105de1:	31 c0                	xor    %eax,%eax
void tvinit(void) {
80105de3:	89 e5                	mov    %esp,%ebp
80105de5:	83 ec 08             	sub    $0x8,%esp
80105de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop
        SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105df0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105df7:	c7 04 c5 42 6d 11 80 	movl   $0x8e000008,-0x7fee92be(,%eax,8)
80105dfe:	08 00 00 8e 
80105e02:	66 89 14 c5 40 6d 11 	mov    %dx,-0x7fee92c0(,%eax,8)
80105e09:	80 
80105e0a:	c1 ea 10             	shr    $0x10,%edx
80105e0d:	66 89 14 c5 46 6d 11 	mov    %dx,-0x7fee92ba(,%eax,8)
80105e14:	80 
    for (i = 0; i < 256; i++) {
80105e15:	83 c0 01             	add    $0x1,%eax
80105e18:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e1d:	75 d1                	jne    80105df0 <tvinit+0x10>
    }
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

    initlock(&tickslock, "time");
80105e1f:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105e22:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105e27:	c7 05 42 6f 11 80 08 	movl   $0xef000008,0x80116f42
80105e2e:	00 00 ef 
    initlock(&tickslock, "time");
80105e31:	68 8d 82 10 80       	push   $0x8010828d
80105e36:	68 00 6d 11 80       	push   $0x80116d00
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105e3b:	66 a3 40 6f 11 80    	mov    %ax,0x80116f40
80105e41:	c1 e8 10             	shr    $0x10,%eax
80105e44:	66 a3 46 6f 11 80    	mov    %ax,0x80116f46
    initlock(&tickslock, "time");
80105e4a:	e8 c1 ea ff ff       	call   80104910 <initlock>
}
80105e4f:	83 c4 10             	add    $0x10,%esp
80105e52:	c9                   	leave  
80105e53:	c3                   	ret    
80105e54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e5f:	90                   	nop

80105e60 <idtinit>:

void idtinit(void) {
80105e60:	55                   	push   %ebp
    pd[0] = size - 1;
80105e61:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e66:	89 e5                	mov    %esp,%ebp
80105e68:	83 ec 10             	sub    $0x10,%esp
80105e6b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    pd[1] = (uint)p;
80105e6f:	b8 40 6d 11 80       	mov    $0x80116d40,%eax
80105e74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    pd[2] = (uint)p >> 16;
80105e78:	c1 e8 10             	shr    $0x10,%eax
80105e7b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    asm volatile ("lidt (%0)" : : "r" (pd));
80105e7f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e82:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80105e85:	c9                   	leave  
80105e86:	c3                   	ret    
80105e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8e:	66 90                	xchg   %ax,%ax

80105e90 <trap>:

void trap(struct trapframe *tf) {
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	57                   	push   %edi
80105e94:	56                   	push   %esi
80105e95:	53                   	push   %ebx
80105e96:	83 ec 1c             	sub    $0x1c,%esp
80105e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (tf->trapno == T_SYSCALL) {
80105e9c:	8b 43 30             	mov    0x30(%ebx),%eax
80105e9f:	83 f8 40             	cmp    $0x40,%eax
80105ea2:	0f 84 68 01 00 00    	je     80106010 <trap+0x180>
            exit();
        }
        return;
    }

    switch (tf->trapno) {
80105ea8:	83 e8 20             	sub    $0x20,%eax
80105eab:	83 f8 1f             	cmp    $0x1f,%eax
80105eae:	0f 87 8c 00 00 00    	ja     80105f40 <trap+0xb0>
80105eb4:	ff 24 85 34 83 10 80 	jmp    *-0x7fef7ccc(,%eax,4)
80105ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ebf:	90                   	nop
                release(&tickslock);
            }
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE:
            ideintr();
80105ec0:	e8 7b c8 ff ff       	call   80102740 <ideintr>
            lapiceoi();
80105ec5:	e8 46 cf ff ff       	call   80102e10 <lapiceoi>
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105eca:	e8 e1 df ff ff       	call   80103eb0 <myproc>
80105ecf:	85 c0                	test   %eax,%eax
80105ed1:	74 1d                	je     80105ef0 <trap+0x60>
80105ed3:	e8 d8 df ff ff       	call   80103eb0 <myproc>
80105ed8:	8b 50 24             	mov    0x24(%eax),%edx
80105edb:	85 d2                	test   %edx,%edx
80105edd:	74 11                	je     80105ef0 <trap+0x60>
80105edf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ee3:	83 e0 03             	and    $0x3,%eax
80105ee6:	66 83 f8 03          	cmp    $0x3,%ax
80105eea:	0f 84 e8 01 00 00    	je     801060d8 <trap+0x248>
        exit();
    }

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80105ef0:	e8 bb df ff ff       	call   80103eb0 <myproc>
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	74 0f                	je     80105f08 <trap+0x78>
80105ef9:	e8 b2 df ff ff       	call   80103eb0 <myproc>
80105efe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f02:	0f 84 b8 00 00 00    	je     80105fc0 <trap+0x130>
        tf->trapno == T_IRQ0 + IRQ_TIMER) {
        yield();
    }

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105f08:	e8 a3 df ff ff       	call   80103eb0 <myproc>
80105f0d:	85 c0                	test   %eax,%eax
80105f0f:	74 1d                	je     80105f2e <trap+0x9e>
80105f11:	e8 9a df ff ff       	call   80103eb0 <myproc>
80105f16:	8b 40 24             	mov    0x24(%eax),%eax
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	74 11                	je     80105f2e <trap+0x9e>
80105f1d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f21:	83 e0 03             	and    $0x3,%eax
80105f24:	66 83 f8 03          	cmp    $0x3,%ax
80105f28:	0f 84 0f 01 00 00    	je     8010603d <trap+0x1ad>
        exit();
    }
}
80105f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f31:	5b                   	pop    %ebx
80105f32:	5e                   	pop    %esi
80105f33:	5f                   	pop    %edi
80105f34:	5d                   	pop    %ebp
80105f35:	c3                   	ret    
80105f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3d:	8d 76 00             	lea    0x0(%esi),%esi
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80105f40:	e8 6b df ff ff       	call   80103eb0 <myproc>
80105f45:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f48:	85 c0                	test   %eax,%eax
80105f4a:	0f 84 a2 01 00 00    	je     801060f2 <trap+0x262>
80105f50:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105f54:	0f 84 98 01 00 00    	je     801060f2 <trap+0x262>
    return result;
}

static inline uint rcr2(void) {
    uint val;
    asm volatile ("movl %%cr2,%0" : "=r" (val));
80105f5a:	0f 20 d1             	mov    %cr2,%ecx
80105f5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f60:	e8 2b df ff ff       	call   80103e90 <cpuid>
80105f65:	8b 73 30             	mov    0x30(%ebx),%esi
80105f68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f6b:	8b 43 34             	mov    0x34(%ebx),%eax
80105f6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    myproc()->pid, myproc()->name, tf->trapno,
80105f71:	e8 3a df ff ff       	call   80103eb0 <myproc>
80105f76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f79:	e8 32 df ff ff       	call   80103eb0 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f84:	51                   	push   %ecx
80105f85:	57                   	push   %edi
80105f86:	52                   	push   %edx
80105f87:	ff 75 e4             	push   -0x1c(%ebp)
80105f8a:	56                   	push   %esi
                    myproc()->pid, myproc()->name, tf->trapno,
80105f8b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105f8e:	83 c6 6c             	add    $0x6c,%esi
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f91:	56                   	push   %esi
80105f92:	ff 70 10             	push   0x10(%eax)
80105f95:	68 f0 82 10 80       	push   $0x801082f0
80105f9a:	e8 41 a8 ff ff       	call   801007e0 <cprintf>
            myproc()->killed = 1;
80105f9f:	83 c4 20             	add    $0x20,%esp
80105fa2:	e8 09 df ff ff       	call   80103eb0 <myproc>
80105fa7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105fae:	e8 fd de ff ff       	call   80103eb0 <myproc>
80105fb3:	85 c0                	test   %eax,%eax
80105fb5:	0f 85 18 ff ff ff    	jne    80105ed3 <trap+0x43>
80105fbb:	e9 30 ff ff ff       	jmp    80105ef0 <trap+0x60>
    if (myproc() && myproc()->state == RUNNING &&
80105fc0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105fc4:	0f 85 3e ff ff ff    	jne    80105f08 <trap+0x78>
        yield();
80105fca:	e8 61 e5 ff ff       	call   80104530 <yield>
80105fcf:	e9 34 ff ff ff       	jmp    80105f08 <trap+0x78>
80105fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105fd8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105fdb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105fdf:	e8 ac de ff ff       	call   80103e90 <cpuid>
80105fe4:	57                   	push   %edi
80105fe5:	56                   	push   %esi
80105fe6:	50                   	push   %eax
80105fe7:	68 98 82 10 80       	push   $0x80108298
80105fec:	e8 ef a7 ff ff       	call   801007e0 <cprintf>
            lapiceoi();
80105ff1:	e8 1a ce ff ff       	call   80102e10 <lapiceoi>
            break;
80105ff6:	83 c4 10             	add    $0x10,%esp
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105ff9:	e8 b2 de ff ff       	call   80103eb0 <myproc>
80105ffe:	85 c0                	test   %eax,%eax
80106000:	0f 85 cd fe ff ff    	jne    80105ed3 <trap+0x43>
80106006:	e9 e5 fe ff ff       	jmp    80105ef0 <trap+0x60>
8010600b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010600f:	90                   	nop
        if (myproc()->killed) {
80106010:	e8 9b de ff ff       	call   80103eb0 <myproc>
80106015:	8b 70 24             	mov    0x24(%eax),%esi
80106018:	85 f6                	test   %esi,%esi
8010601a:	0f 85 c8 00 00 00    	jne    801060e8 <trap+0x258>
        myproc()->tf = tf;
80106020:	e8 8b de ff ff       	call   80103eb0 <myproc>
80106025:	89 58 18             	mov    %ebx,0x18(%eax)
        syscall();
80106028:	e8 73 ef ff ff       	call   80104fa0 <syscall>
        if (myproc()->killed) {
8010602d:	e8 7e de ff ff       	call   80103eb0 <myproc>
80106032:	8b 48 24             	mov    0x24(%eax),%ecx
80106035:	85 c9                	test   %ecx,%ecx
80106037:	0f 84 f1 fe ff ff    	je     80105f2e <trap+0x9e>
}
8010603d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106040:	5b                   	pop    %ebx
80106041:	5e                   	pop    %esi
80106042:	5f                   	pop    %edi
80106043:	5d                   	pop    %ebp
            exit();
80106044:	e9 87 e2 ff ff       	jmp    801042d0 <exit>
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            uartintr();
80106050:	e8 3b 02 00 00       	call   80106290 <uartintr>
            lapiceoi();
80106055:	e8 b6 cd ff ff       	call   80102e10 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
8010605a:	e8 51 de ff ff       	call   80103eb0 <myproc>
8010605f:	85 c0                	test   %eax,%eax
80106061:	0f 85 6c fe ff ff    	jne    80105ed3 <trap+0x43>
80106067:	e9 84 fe ff ff       	jmp    80105ef0 <trap+0x60>
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80106070:	e8 5b cc ff ff       	call   80102cd0 <kbdintr>
            lapiceoi();
80106075:	e8 96 cd ff ff       	call   80102e10 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
8010607a:	e8 31 de ff ff       	call   80103eb0 <myproc>
8010607f:	85 c0                	test   %eax,%eax
80106081:	0f 85 4c fe ff ff    	jne    80105ed3 <trap+0x43>
80106087:	e9 64 fe ff ff       	jmp    80105ef0 <trap+0x60>
8010608c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            if (cpuid() == 0) {
80106090:	e8 fb dd ff ff       	call   80103e90 <cpuid>
80106095:	85 c0                	test   %eax,%eax
80106097:	0f 85 28 fe ff ff    	jne    80105ec5 <trap+0x35>
                acquire(&tickslock);
8010609d:	83 ec 0c             	sub    $0xc,%esp
801060a0:	68 00 6d 11 80       	push   $0x80116d00
801060a5:	e8 36 ea ff ff       	call   80104ae0 <acquire>
                wakeup(&ticks);
801060aa:	c7 04 24 e0 6c 11 80 	movl   $0x80116ce0,(%esp)
                ticks++;
801060b1:	83 05 e0 6c 11 80 01 	addl   $0x1,0x80116ce0
                wakeup(&ticks);
801060b8:	e8 83 e5 ff ff       	call   80104640 <wakeup>
                release(&tickslock);
801060bd:	c7 04 24 00 6d 11 80 	movl   $0x80116d00,(%esp)
801060c4:	e8 b7 e9 ff ff       	call   80104a80 <release>
801060c9:	83 c4 10             	add    $0x10,%esp
            lapiceoi();
801060cc:	e9 f4 fd ff ff       	jmp    80105ec5 <trap+0x35>
801060d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        exit();
801060d8:	e8 f3 e1 ff ff       	call   801042d0 <exit>
801060dd:	e9 0e fe ff ff       	jmp    80105ef0 <trap+0x60>
801060e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            exit();
801060e8:	e8 e3 e1 ff ff       	call   801042d0 <exit>
801060ed:	e9 2e ff ff ff       	jmp    80106020 <trap+0x190>
801060f2:	0f 20 d6             	mov    %cr2,%esi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060f5:	e8 96 dd ff ff       	call   80103e90 <cpuid>
801060fa:	83 ec 0c             	sub    $0xc,%esp
801060fd:	56                   	push   %esi
801060fe:	57                   	push   %edi
801060ff:	50                   	push   %eax
80106100:	ff 73 30             	push   0x30(%ebx)
80106103:	68 bc 82 10 80       	push   $0x801082bc
80106108:	e8 d3 a6 ff ff       	call   801007e0 <cprintf>
                panic("trap");
8010610d:	83 c4 14             	add    $0x14,%esp
80106110:	68 92 82 10 80       	push   $0x80108292
80106115:	e8 66 a3 ff ff       	call   80100480 <panic>
8010611a:	66 90                	xchg   %ax,%ax
8010611c:	66 90                	xchg   %ax,%ax
8010611e:	66 90                	xchg   %ax,%ax

80106120 <uartgetc>:
    }
    outb(COM1 + 0, c);
}

static int uartgetc(void)            {
    if (!uart) {
80106120:	a1 40 75 11 80       	mov    0x80117540,%eax
80106125:	85 c0                	test   %eax,%eax
80106127:	74 17                	je     80106140 <uartgetc+0x20>
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106129:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010612e:	ec                   	in     (%dx),%al
        return -1;
    }
    if (!(inb(COM1 + 5) & 0x01)) {
8010612f:	a8 01                	test   $0x1,%al
80106131:	74 0d                	je     80106140 <uartgetc+0x20>
80106133:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106138:	ec                   	in     (%dx),%al
        return -1;
    }
    return inb(COM1 + 0);
80106139:	0f b6 c0             	movzbl %al,%eax
8010613c:	c3                   	ret    
8010613d:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106145:	c3                   	ret    
80106146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614d:	8d 76 00             	lea    0x0(%esi),%esi

80106150 <uartinit>:
void uartinit(void) {
80106150:	55                   	push   %ebp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106151:	31 c9                	xor    %ecx,%ecx
80106153:	89 c8                	mov    %ecx,%eax
80106155:	89 e5                	mov    %esp,%ebp
80106157:	57                   	push   %edi
80106158:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010615d:	56                   	push   %esi
8010615e:	89 fa                	mov    %edi,%edx
80106160:	53                   	push   %ebx
80106161:	83 ec 1c             	sub    $0x1c,%esp
80106164:	ee                   	out    %al,(%dx)
80106165:	be fb 03 00 00       	mov    $0x3fb,%esi
8010616a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010616f:	89 f2                	mov    %esi,%edx
80106171:	ee                   	out    %al,(%dx)
80106172:	b8 0c 00 00 00       	mov    $0xc,%eax
80106177:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010617c:	ee                   	out    %al,(%dx)
8010617d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106182:	89 c8                	mov    %ecx,%eax
80106184:	89 da                	mov    %ebx,%edx
80106186:	ee                   	out    %al,(%dx)
80106187:	b8 03 00 00 00       	mov    $0x3,%eax
8010618c:	89 f2                	mov    %esi,%edx
8010618e:	ee                   	out    %al,(%dx)
8010618f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106194:	89 c8                	mov    %ecx,%eax
80106196:	ee                   	out    %al,(%dx)
80106197:	b8 01 00 00 00       	mov    $0x1,%eax
8010619c:	89 da                	mov    %ebx,%edx
8010619e:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010619f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061a4:	ec                   	in     (%dx),%al
    if (inb(COM1 + 5) == 0xFF) {
801061a5:	3c ff                	cmp    $0xff,%al
801061a7:	74 78                	je     80106221 <uartinit+0xd1>
    uart = 1;
801061a9:	c7 05 40 75 11 80 01 	movl   $0x1,0x80117540
801061b0:	00 00 00 
801061b3:	89 fa                	mov    %edi,%edx
801061b5:	ec                   	in     (%dx),%al
801061b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061bb:	ec                   	in     (%dx),%al
    ioapicenable(IRQ_COM1, 0);
801061bc:	83 ec 08             	sub    $0x8,%esp
    for (p = "xv6...\n"; *p; p++) {
801061bf:	bf b4 83 10 80       	mov    $0x801083b4,%edi
801061c4:	be fd 03 00 00       	mov    $0x3fd,%esi
    ioapicenable(IRQ_COM1, 0);
801061c9:	6a 00                	push   $0x0
801061cb:	6a 04                	push   $0x4
801061cd:	e8 ae c7 ff ff       	call   80102980 <ioapicenable>
    for (p = "xv6...\n"; *p; p++) {
801061d2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
    ioapicenable(IRQ_COM1, 0);
801061d6:	83 c4 10             	add    $0x10,%esp
801061d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (!uart) {
801061e0:	a1 40 75 11 80       	mov    0x80117540,%eax
801061e5:	bb 80 00 00 00       	mov    $0x80,%ebx
801061ea:	85 c0                	test   %eax,%eax
801061ec:	75 14                	jne    80106202 <uartinit+0xb2>
801061ee:	eb 23                	jmp    80106213 <uartinit+0xc3>
        microdelay(10);
801061f0:	83 ec 0c             	sub    $0xc,%esp
801061f3:	6a 0a                	push   $0xa
801061f5:	e8 36 cc ff ff       	call   80102e30 <microdelay>
    for (i = 0; i < 128 && !(inb(COM1 + 5) & 0x20); i++) {
801061fa:	83 c4 10             	add    $0x10,%esp
801061fd:	83 eb 01             	sub    $0x1,%ebx
80106200:	74 07                	je     80106209 <uartinit+0xb9>
80106202:	89 f2                	mov    %esi,%edx
80106204:	ec                   	in     (%dx),%al
80106205:	a8 20                	test   $0x20,%al
80106207:	74 e7                	je     801061f0 <uartinit+0xa0>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106209:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010620d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106212:	ee                   	out    %al,(%dx)
    for (p = "xv6...\n"; *p; p++) {
80106213:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106217:	83 c7 01             	add    $0x1,%edi
8010621a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010621d:	84 c0                	test   %al,%al
8010621f:	75 bf                	jne    801061e0 <uartinit+0x90>
}
80106221:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106224:	5b                   	pop    %ebx
80106225:	5e                   	pop    %esi
80106226:	5f                   	pop    %edi
80106227:	5d                   	pop    %ebp
80106228:	c3                   	ret    
80106229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106230 <uartputc>:
    if (!uart) {
80106230:	a1 40 75 11 80       	mov    0x80117540,%eax
80106235:	85 c0                	test   %eax,%eax
80106237:	74 47                	je     80106280 <uartputc+0x50>
void uartputc(int c) {
80106239:	55                   	push   %ebp
8010623a:	89 e5                	mov    %esp,%ebp
8010623c:	56                   	push   %esi
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010623d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106242:	53                   	push   %ebx
80106243:	bb 80 00 00 00       	mov    $0x80,%ebx
80106248:	eb 18                	jmp    80106262 <uartputc+0x32>
8010624a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        microdelay(10);
80106250:	83 ec 0c             	sub    $0xc,%esp
80106253:	6a 0a                	push   $0xa
80106255:	e8 d6 cb ff ff       	call   80102e30 <microdelay>
    for (i = 0; i < 128 && !(inb(COM1 + 5) & 0x20); i++) {
8010625a:	83 c4 10             	add    $0x10,%esp
8010625d:	83 eb 01             	sub    $0x1,%ebx
80106260:	74 07                	je     80106269 <uartputc+0x39>
80106262:	89 f2                	mov    %esi,%edx
80106264:	ec                   	in     (%dx),%al
80106265:	a8 20                	test   $0x20,%al
80106267:	74 e7                	je     80106250 <uartputc+0x20>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106269:	8b 45 08             	mov    0x8(%ebp),%eax
8010626c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106271:	ee                   	out    %al,(%dx)
}
80106272:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106275:	5b                   	pop    %ebx
80106276:	5e                   	pop    %esi
80106277:	5d                   	pop    %ebp
80106278:	c3                   	ret    
80106279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106280:	c3                   	ret    
80106281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010628f:	90                   	nop

80106290 <uartintr>:

void uartintr(void) {
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	83 ec 14             	sub    $0x14,%esp
    consoleintr(uartgetc);
80106296:	68 20 61 10 80       	push   $0x80106120
8010629b:	e8 70 a7 ff ff       	call   80100a10 <consoleintr>
}
801062a0:	83 c4 10             	add    $0x10,%esp
801062a3:	c9                   	leave  
801062a4:	c3                   	ret    

801062a5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $0
801062a7:	6a 00                	push   $0x0
  jmp alltraps
801062a9:	e9 0c fb ff ff       	jmp    80105dba <alltraps>

801062ae <vector1>:
.globl vector1
vector1:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $1
801062b0:	6a 01                	push   $0x1
  jmp alltraps
801062b2:	e9 03 fb ff ff       	jmp    80105dba <alltraps>

801062b7 <vector2>:
.globl vector2
vector2:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $2
801062b9:	6a 02                	push   $0x2
  jmp alltraps
801062bb:	e9 fa fa ff ff       	jmp    80105dba <alltraps>

801062c0 <vector3>:
.globl vector3
vector3:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $3
801062c2:	6a 03                	push   $0x3
  jmp alltraps
801062c4:	e9 f1 fa ff ff       	jmp    80105dba <alltraps>

801062c9 <vector4>:
.globl vector4
vector4:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $4
801062cb:	6a 04                	push   $0x4
  jmp alltraps
801062cd:	e9 e8 fa ff ff       	jmp    80105dba <alltraps>

801062d2 <vector5>:
.globl vector5
vector5:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $5
801062d4:	6a 05                	push   $0x5
  jmp alltraps
801062d6:	e9 df fa ff ff       	jmp    80105dba <alltraps>

801062db <vector6>:
.globl vector6
vector6:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $6
801062dd:	6a 06                	push   $0x6
  jmp alltraps
801062df:	e9 d6 fa ff ff       	jmp    80105dba <alltraps>

801062e4 <vector7>:
.globl vector7
vector7:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $7
801062e6:	6a 07                	push   $0x7
  jmp alltraps
801062e8:	e9 cd fa ff ff       	jmp    80105dba <alltraps>

801062ed <vector8>:
.globl vector8
vector8:
  pushl $8
801062ed:	6a 08                	push   $0x8
  jmp alltraps
801062ef:	e9 c6 fa ff ff       	jmp    80105dba <alltraps>

801062f4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $9
801062f6:	6a 09                	push   $0x9
  jmp alltraps
801062f8:	e9 bd fa ff ff       	jmp    80105dba <alltraps>

801062fd <vector10>:
.globl vector10
vector10:
  pushl $10
801062fd:	6a 0a                	push   $0xa
  jmp alltraps
801062ff:	e9 b6 fa ff ff       	jmp    80105dba <alltraps>

80106304 <vector11>:
.globl vector11
vector11:
  pushl $11
80106304:	6a 0b                	push   $0xb
  jmp alltraps
80106306:	e9 af fa ff ff       	jmp    80105dba <alltraps>

8010630b <vector12>:
.globl vector12
vector12:
  pushl $12
8010630b:	6a 0c                	push   $0xc
  jmp alltraps
8010630d:	e9 a8 fa ff ff       	jmp    80105dba <alltraps>

80106312 <vector13>:
.globl vector13
vector13:
  pushl $13
80106312:	6a 0d                	push   $0xd
  jmp alltraps
80106314:	e9 a1 fa ff ff       	jmp    80105dba <alltraps>

80106319 <vector14>:
.globl vector14
vector14:
  pushl $14
80106319:	6a 0e                	push   $0xe
  jmp alltraps
8010631b:	e9 9a fa ff ff       	jmp    80105dba <alltraps>

80106320 <vector15>:
.globl vector15
vector15:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $15
80106322:	6a 0f                	push   $0xf
  jmp alltraps
80106324:	e9 91 fa ff ff       	jmp    80105dba <alltraps>

80106329 <vector16>:
.globl vector16
vector16:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $16
8010632b:	6a 10                	push   $0x10
  jmp alltraps
8010632d:	e9 88 fa ff ff       	jmp    80105dba <alltraps>

80106332 <vector17>:
.globl vector17
vector17:
  pushl $17
80106332:	6a 11                	push   $0x11
  jmp alltraps
80106334:	e9 81 fa ff ff       	jmp    80105dba <alltraps>

80106339 <vector18>:
.globl vector18
vector18:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $18
8010633b:	6a 12                	push   $0x12
  jmp alltraps
8010633d:	e9 78 fa ff ff       	jmp    80105dba <alltraps>

80106342 <vector19>:
.globl vector19
vector19:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $19
80106344:	6a 13                	push   $0x13
  jmp alltraps
80106346:	e9 6f fa ff ff       	jmp    80105dba <alltraps>

8010634b <vector20>:
.globl vector20
vector20:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $20
8010634d:	6a 14                	push   $0x14
  jmp alltraps
8010634f:	e9 66 fa ff ff       	jmp    80105dba <alltraps>

80106354 <vector21>:
.globl vector21
vector21:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $21
80106356:	6a 15                	push   $0x15
  jmp alltraps
80106358:	e9 5d fa ff ff       	jmp    80105dba <alltraps>

8010635d <vector22>:
.globl vector22
vector22:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $22
8010635f:	6a 16                	push   $0x16
  jmp alltraps
80106361:	e9 54 fa ff ff       	jmp    80105dba <alltraps>

80106366 <vector23>:
.globl vector23
vector23:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $23
80106368:	6a 17                	push   $0x17
  jmp alltraps
8010636a:	e9 4b fa ff ff       	jmp    80105dba <alltraps>

8010636f <vector24>:
.globl vector24
vector24:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $24
80106371:	6a 18                	push   $0x18
  jmp alltraps
80106373:	e9 42 fa ff ff       	jmp    80105dba <alltraps>

80106378 <vector25>:
.globl vector25
vector25:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $25
8010637a:	6a 19                	push   $0x19
  jmp alltraps
8010637c:	e9 39 fa ff ff       	jmp    80105dba <alltraps>

80106381 <vector26>:
.globl vector26
vector26:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $26
80106383:	6a 1a                	push   $0x1a
  jmp alltraps
80106385:	e9 30 fa ff ff       	jmp    80105dba <alltraps>

8010638a <vector27>:
.globl vector27
vector27:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $27
8010638c:	6a 1b                	push   $0x1b
  jmp alltraps
8010638e:	e9 27 fa ff ff       	jmp    80105dba <alltraps>

80106393 <vector28>:
.globl vector28
vector28:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $28
80106395:	6a 1c                	push   $0x1c
  jmp alltraps
80106397:	e9 1e fa ff ff       	jmp    80105dba <alltraps>

8010639c <vector29>:
.globl vector29
vector29:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $29
8010639e:	6a 1d                	push   $0x1d
  jmp alltraps
801063a0:	e9 15 fa ff ff       	jmp    80105dba <alltraps>

801063a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $30
801063a7:	6a 1e                	push   $0x1e
  jmp alltraps
801063a9:	e9 0c fa ff ff       	jmp    80105dba <alltraps>

801063ae <vector31>:
.globl vector31
vector31:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $31
801063b0:	6a 1f                	push   $0x1f
  jmp alltraps
801063b2:	e9 03 fa ff ff       	jmp    80105dba <alltraps>

801063b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $32
801063b9:	6a 20                	push   $0x20
  jmp alltraps
801063bb:	e9 fa f9 ff ff       	jmp    80105dba <alltraps>

801063c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $33
801063c2:	6a 21                	push   $0x21
  jmp alltraps
801063c4:	e9 f1 f9 ff ff       	jmp    80105dba <alltraps>

801063c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $34
801063cb:	6a 22                	push   $0x22
  jmp alltraps
801063cd:	e9 e8 f9 ff ff       	jmp    80105dba <alltraps>

801063d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $35
801063d4:	6a 23                	push   $0x23
  jmp alltraps
801063d6:	e9 df f9 ff ff       	jmp    80105dba <alltraps>

801063db <vector36>:
.globl vector36
vector36:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $36
801063dd:	6a 24                	push   $0x24
  jmp alltraps
801063df:	e9 d6 f9 ff ff       	jmp    80105dba <alltraps>

801063e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $37
801063e6:	6a 25                	push   $0x25
  jmp alltraps
801063e8:	e9 cd f9 ff ff       	jmp    80105dba <alltraps>

801063ed <vector38>:
.globl vector38
vector38:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $38
801063ef:	6a 26                	push   $0x26
  jmp alltraps
801063f1:	e9 c4 f9 ff ff       	jmp    80105dba <alltraps>

801063f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $39
801063f8:	6a 27                	push   $0x27
  jmp alltraps
801063fa:	e9 bb f9 ff ff       	jmp    80105dba <alltraps>

801063ff <vector40>:
.globl vector40
vector40:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $40
80106401:	6a 28                	push   $0x28
  jmp alltraps
80106403:	e9 b2 f9 ff ff       	jmp    80105dba <alltraps>

80106408 <vector41>:
.globl vector41
vector41:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $41
8010640a:	6a 29                	push   $0x29
  jmp alltraps
8010640c:	e9 a9 f9 ff ff       	jmp    80105dba <alltraps>

80106411 <vector42>:
.globl vector42
vector42:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $42
80106413:	6a 2a                	push   $0x2a
  jmp alltraps
80106415:	e9 a0 f9 ff ff       	jmp    80105dba <alltraps>

8010641a <vector43>:
.globl vector43
vector43:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $43
8010641c:	6a 2b                	push   $0x2b
  jmp alltraps
8010641e:	e9 97 f9 ff ff       	jmp    80105dba <alltraps>

80106423 <vector44>:
.globl vector44
vector44:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $44
80106425:	6a 2c                	push   $0x2c
  jmp alltraps
80106427:	e9 8e f9 ff ff       	jmp    80105dba <alltraps>

8010642c <vector45>:
.globl vector45
vector45:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $45
8010642e:	6a 2d                	push   $0x2d
  jmp alltraps
80106430:	e9 85 f9 ff ff       	jmp    80105dba <alltraps>

80106435 <vector46>:
.globl vector46
vector46:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $46
80106437:	6a 2e                	push   $0x2e
  jmp alltraps
80106439:	e9 7c f9 ff ff       	jmp    80105dba <alltraps>

8010643e <vector47>:
.globl vector47
vector47:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $47
80106440:	6a 2f                	push   $0x2f
  jmp alltraps
80106442:	e9 73 f9 ff ff       	jmp    80105dba <alltraps>

80106447 <vector48>:
.globl vector48
vector48:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $48
80106449:	6a 30                	push   $0x30
  jmp alltraps
8010644b:	e9 6a f9 ff ff       	jmp    80105dba <alltraps>

80106450 <vector49>:
.globl vector49
vector49:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $49
80106452:	6a 31                	push   $0x31
  jmp alltraps
80106454:	e9 61 f9 ff ff       	jmp    80105dba <alltraps>

80106459 <vector50>:
.globl vector50
vector50:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $50
8010645b:	6a 32                	push   $0x32
  jmp alltraps
8010645d:	e9 58 f9 ff ff       	jmp    80105dba <alltraps>

80106462 <vector51>:
.globl vector51
vector51:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $51
80106464:	6a 33                	push   $0x33
  jmp alltraps
80106466:	e9 4f f9 ff ff       	jmp    80105dba <alltraps>

8010646b <vector52>:
.globl vector52
vector52:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $52
8010646d:	6a 34                	push   $0x34
  jmp alltraps
8010646f:	e9 46 f9 ff ff       	jmp    80105dba <alltraps>

80106474 <vector53>:
.globl vector53
vector53:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $53
80106476:	6a 35                	push   $0x35
  jmp alltraps
80106478:	e9 3d f9 ff ff       	jmp    80105dba <alltraps>

8010647d <vector54>:
.globl vector54
vector54:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $54
8010647f:	6a 36                	push   $0x36
  jmp alltraps
80106481:	e9 34 f9 ff ff       	jmp    80105dba <alltraps>

80106486 <vector55>:
.globl vector55
vector55:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $55
80106488:	6a 37                	push   $0x37
  jmp alltraps
8010648a:	e9 2b f9 ff ff       	jmp    80105dba <alltraps>

8010648f <vector56>:
.globl vector56
vector56:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $56
80106491:	6a 38                	push   $0x38
  jmp alltraps
80106493:	e9 22 f9 ff ff       	jmp    80105dba <alltraps>

80106498 <vector57>:
.globl vector57
vector57:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $57
8010649a:	6a 39                	push   $0x39
  jmp alltraps
8010649c:	e9 19 f9 ff ff       	jmp    80105dba <alltraps>

801064a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $58
801064a3:	6a 3a                	push   $0x3a
  jmp alltraps
801064a5:	e9 10 f9 ff ff       	jmp    80105dba <alltraps>

801064aa <vector59>:
.globl vector59
vector59:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $59
801064ac:	6a 3b                	push   $0x3b
  jmp alltraps
801064ae:	e9 07 f9 ff ff       	jmp    80105dba <alltraps>

801064b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $60
801064b5:	6a 3c                	push   $0x3c
  jmp alltraps
801064b7:	e9 fe f8 ff ff       	jmp    80105dba <alltraps>

801064bc <vector61>:
.globl vector61
vector61:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $61
801064be:	6a 3d                	push   $0x3d
  jmp alltraps
801064c0:	e9 f5 f8 ff ff       	jmp    80105dba <alltraps>

801064c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $62
801064c7:	6a 3e                	push   $0x3e
  jmp alltraps
801064c9:	e9 ec f8 ff ff       	jmp    80105dba <alltraps>

801064ce <vector63>:
.globl vector63
vector63:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $63
801064d0:	6a 3f                	push   $0x3f
  jmp alltraps
801064d2:	e9 e3 f8 ff ff       	jmp    80105dba <alltraps>

801064d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $64
801064d9:	6a 40                	push   $0x40
  jmp alltraps
801064db:	e9 da f8 ff ff       	jmp    80105dba <alltraps>

801064e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $65
801064e2:	6a 41                	push   $0x41
  jmp alltraps
801064e4:	e9 d1 f8 ff ff       	jmp    80105dba <alltraps>

801064e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $66
801064eb:	6a 42                	push   $0x42
  jmp alltraps
801064ed:	e9 c8 f8 ff ff       	jmp    80105dba <alltraps>

801064f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $67
801064f4:	6a 43                	push   $0x43
  jmp alltraps
801064f6:	e9 bf f8 ff ff       	jmp    80105dba <alltraps>

801064fb <vector68>:
.globl vector68
vector68:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $68
801064fd:	6a 44                	push   $0x44
  jmp alltraps
801064ff:	e9 b6 f8 ff ff       	jmp    80105dba <alltraps>

80106504 <vector69>:
.globl vector69
vector69:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $69
80106506:	6a 45                	push   $0x45
  jmp alltraps
80106508:	e9 ad f8 ff ff       	jmp    80105dba <alltraps>

8010650d <vector70>:
.globl vector70
vector70:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $70
8010650f:	6a 46                	push   $0x46
  jmp alltraps
80106511:	e9 a4 f8 ff ff       	jmp    80105dba <alltraps>

80106516 <vector71>:
.globl vector71
vector71:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $71
80106518:	6a 47                	push   $0x47
  jmp alltraps
8010651a:	e9 9b f8 ff ff       	jmp    80105dba <alltraps>

8010651f <vector72>:
.globl vector72
vector72:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $72
80106521:	6a 48                	push   $0x48
  jmp alltraps
80106523:	e9 92 f8 ff ff       	jmp    80105dba <alltraps>

80106528 <vector73>:
.globl vector73
vector73:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $73
8010652a:	6a 49                	push   $0x49
  jmp alltraps
8010652c:	e9 89 f8 ff ff       	jmp    80105dba <alltraps>

80106531 <vector74>:
.globl vector74
vector74:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $74
80106533:	6a 4a                	push   $0x4a
  jmp alltraps
80106535:	e9 80 f8 ff ff       	jmp    80105dba <alltraps>

8010653a <vector75>:
.globl vector75
vector75:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $75
8010653c:	6a 4b                	push   $0x4b
  jmp alltraps
8010653e:	e9 77 f8 ff ff       	jmp    80105dba <alltraps>

80106543 <vector76>:
.globl vector76
vector76:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $76
80106545:	6a 4c                	push   $0x4c
  jmp alltraps
80106547:	e9 6e f8 ff ff       	jmp    80105dba <alltraps>

8010654c <vector77>:
.globl vector77
vector77:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $77
8010654e:	6a 4d                	push   $0x4d
  jmp alltraps
80106550:	e9 65 f8 ff ff       	jmp    80105dba <alltraps>

80106555 <vector78>:
.globl vector78
vector78:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $78
80106557:	6a 4e                	push   $0x4e
  jmp alltraps
80106559:	e9 5c f8 ff ff       	jmp    80105dba <alltraps>

8010655e <vector79>:
.globl vector79
vector79:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $79
80106560:	6a 4f                	push   $0x4f
  jmp alltraps
80106562:	e9 53 f8 ff ff       	jmp    80105dba <alltraps>

80106567 <vector80>:
.globl vector80
vector80:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $80
80106569:	6a 50                	push   $0x50
  jmp alltraps
8010656b:	e9 4a f8 ff ff       	jmp    80105dba <alltraps>

80106570 <vector81>:
.globl vector81
vector81:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $81
80106572:	6a 51                	push   $0x51
  jmp alltraps
80106574:	e9 41 f8 ff ff       	jmp    80105dba <alltraps>

80106579 <vector82>:
.globl vector82
vector82:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $82
8010657b:	6a 52                	push   $0x52
  jmp alltraps
8010657d:	e9 38 f8 ff ff       	jmp    80105dba <alltraps>

80106582 <vector83>:
.globl vector83
vector83:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $83
80106584:	6a 53                	push   $0x53
  jmp alltraps
80106586:	e9 2f f8 ff ff       	jmp    80105dba <alltraps>

8010658b <vector84>:
.globl vector84
vector84:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $84
8010658d:	6a 54                	push   $0x54
  jmp alltraps
8010658f:	e9 26 f8 ff ff       	jmp    80105dba <alltraps>

80106594 <vector85>:
.globl vector85
vector85:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $85
80106596:	6a 55                	push   $0x55
  jmp alltraps
80106598:	e9 1d f8 ff ff       	jmp    80105dba <alltraps>

8010659d <vector86>:
.globl vector86
vector86:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $86
8010659f:	6a 56                	push   $0x56
  jmp alltraps
801065a1:	e9 14 f8 ff ff       	jmp    80105dba <alltraps>

801065a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $87
801065a8:	6a 57                	push   $0x57
  jmp alltraps
801065aa:	e9 0b f8 ff ff       	jmp    80105dba <alltraps>

801065af <vector88>:
.globl vector88
vector88:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $88
801065b1:	6a 58                	push   $0x58
  jmp alltraps
801065b3:	e9 02 f8 ff ff       	jmp    80105dba <alltraps>

801065b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $89
801065ba:	6a 59                	push   $0x59
  jmp alltraps
801065bc:	e9 f9 f7 ff ff       	jmp    80105dba <alltraps>

801065c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $90
801065c3:	6a 5a                	push   $0x5a
  jmp alltraps
801065c5:	e9 f0 f7 ff ff       	jmp    80105dba <alltraps>

801065ca <vector91>:
.globl vector91
vector91:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $91
801065cc:	6a 5b                	push   $0x5b
  jmp alltraps
801065ce:	e9 e7 f7 ff ff       	jmp    80105dba <alltraps>

801065d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $92
801065d5:	6a 5c                	push   $0x5c
  jmp alltraps
801065d7:	e9 de f7 ff ff       	jmp    80105dba <alltraps>

801065dc <vector93>:
.globl vector93
vector93:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $93
801065de:	6a 5d                	push   $0x5d
  jmp alltraps
801065e0:	e9 d5 f7 ff ff       	jmp    80105dba <alltraps>

801065e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $94
801065e7:	6a 5e                	push   $0x5e
  jmp alltraps
801065e9:	e9 cc f7 ff ff       	jmp    80105dba <alltraps>

801065ee <vector95>:
.globl vector95
vector95:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $95
801065f0:	6a 5f                	push   $0x5f
  jmp alltraps
801065f2:	e9 c3 f7 ff ff       	jmp    80105dba <alltraps>

801065f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $96
801065f9:	6a 60                	push   $0x60
  jmp alltraps
801065fb:	e9 ba f7 ff ff       	jmp    80105dba <alltraps>

80106600 <vector97>:
.globl vector97
vector97:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $97
80106602:	6a 61                	push   $0x61
  jmp alltraps
80106604:	e9 b1 f7 ff ff       	jmp    80105dba <alltraps>

80106609 <vector98>:
.globl vector98
vector98:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $98
8010660b:	6a 62                	push   $0x62
  jmp alltraps
8010660d:	e9 a8 f7 ff ff       	jmp    80105dba <alltraps>

80106612 <vector99>:
.globl vector99
vector99:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $99
80106614:	6a 63                	push   $0x63
  jmp alltraps
80106616:	e9 9f f7 ff ff       	jmp    80105dba <alltraps>

8010661b <vector100>:
.globl vector100
vector100:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $100
8010661d:	6a 64                	push   $0x64
  jmp alltraps
8010661f:	e9 96 f7 ff ff       	jmp    80105dba <alltraps>

80106624 <vector101>:
.globl vector101
vector101:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $101
80106626:	6a 65                	push   $0x65
  jmp alltraps
80106628:	e9 8d f7 ff ff       	jmp    80105dba <alltraps>

8010662d <vector102>:
.globl vector102
vector102:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $102
8010662f:	6a 66                	push   $0x66
  jmp alltraps
80106631:	e9 84 f7 ff ff       	jmp    80105dba <alltraps>

80106636 <vector103>:
.globl vector103
vector103:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $103
80106638:	6a 67                	push   $0x67
  jmp alltraps
8010663a:	e9 7b f7 ff ff       	jmp    80105dba <alltraps>

8010663f <vector104>:
.globl vector104
vector104:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $104
80106641:	6a 68                	push   $0x68
  jmp alltraps
80106643:	e9 72 f7 ff ff       	jmp    80105dba <alltraps>

80106648 <vector105>:
.globl vector105
vector105:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $105
8010664a:	6a 69                	push   $0x69
  jmp alltraps
8010664c:	e9 69 f7 ff ff       	jmp    80105dba <alltraps>

80106651 <vector106>:
.globl vector106
vector106:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $106
80106653:	6a 6a                	push   $0x6a
  jmp alltraps
80106655:	e9 60 f7 ff ff       	jmp    80105dba <alltraps>

8010665a <vector107>:
.globl vector107
vector107:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $107
8010665c:	6a 6b                	push   $0x6b
  jmp alltraps
8010665e:	e9 57 f7 ff ff       	jmp    80105dba <alltraps>

80106663 <vector108>:
.globl vector108
vector108:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $108
80106665:	6a 6c                	push   $0x6c
  jmp alltraps
80106667:	e9 4e f7 ff ff       	jmp    80105dba <alltraps>

8010666c <vector109>:
.globl vector109
vector109:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $109
8010666e:	6a 6d                	push   $0x6d
  jmp alltraps
80106670:	e9 45 f7 ff ff       	jmp    80105dba <alltraps>

80106675 <vector110>:
.globl vector110
vector110:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $110
80106677:	6a 6e                	push   $0x6e
  jmp alltraps
80106679:	e9 3c f7 ff ff       	jmp    80105dba <alltraps>

8010667e <vector111>:
.globl vector111
vector111:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $111
80106680:	6a 6f                	push   $0x6f
  jmp alltraps
80106682:	e9 33 f7 ff ff       	jmp    80105dba <alltraps>

80106687 <vector112>:
.globl vector112
vector112:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $112
80106689:	6a 70                	push   $0x70
  jmp alltraps
8010668b:	e9 2a f7 ff ff       	jmp    80105dba <alltraps>

80106690 <vector113>:
.globl vector113
vector113:
  pushl $0
80106690:	6a 00                	push   $0x0
  pushl $113
80106692:	6a 71                	push   $0x71
  jmp alltraps
80106694:	e9 21 f7 ff ff       	jmp    80105dba <alltraps>

80106699 <vector114>:
.globl vector114
vector114:
  pushl $0
80106699:	6a 00                	push   $0x0
  pushl $114
8010669b:	6a 72                	push   $0x72
  jmp alltraps
8010669d:	e9 18 f7 ff ff       	jmp    80105dba <alltraps>

801066a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $115
801066a4:	6a 73                	push   $0x73
  jmp alltraps
801066a6:	e9 0f f7 ff ff       	jmp    80105dba <alltraps>

801066ab <vector116>:
.globl vector116
vector116:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $116
801066ad:	6a 74                	push   $0x74
  jmp alltraps
801066af:	e9 06 f7 ff ff       	jmp    80105dba <alltraps>

801066b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801066b4:	6a 00                	push   $0x0
  pushl $117
801066b6:	6a 75                	push   $0x75
  jmp alltraps
801066b8:	e9 fd f6 ff ff       	jmp    80105dba <alltraps>

801066bd <vector118>:
.globl vector118
vector118:
  pushl $0
801066bd:	6a 00                	push   $0x0
  pushl $118
801066bf:	6a 76                	push   $0x76
  jmp alltraps
801066c1:	e9 f4 f6 ff ff       	jmp    80105dba <alltraps>

801066c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $119
801066c8:	6a 77                	push   $0x77
  jmp alltraps
801066ca:	e9 eb f6 ff ff       	jmp    80105dba <alltraps>

801066cf <vector120>:
.globl vector120
vector120:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $120
801066d1:	6a 78                	push   $0x78
  jmp alltraps
801066d3:	e9 e2 f6 ff ff       	jmp    80105dba <alltraps>

801066d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801066d8:	6a 00                	push   $0x0
  pushl $121
801066da:	6a 79                	push   $0x79
  jmp alltraps
801066dc:	e9 d9 f6 ff ff       	jmp    80105dba <alltraps>

801066e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801066e1:	6a 00                	push   $0x0
  pushl $122
801066e3:	6a 7a                	push   $0x7a
  jmp alltraps
801066e5:	e9 d0 f6 ff ff       	jmp    80105dba <alltraps>

801066ea <vector123>:
.globl vector123
vector123:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $123
801066ec:	6a 7b                	push   $0x7b
  jmp alltraps
801066ee:	e9 c7 f6 ff ff       	jmp    80105dba <alltraps>

801066f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $124
801066f5:	6a 7c                	push   $0x7c
  jmp alltraps
801066f7:	e9 be f6 ff ff       	jmp    80105dba <alltraps>

801066fc <vector125>:
.globl vector125
vector125:
  pushl $0
801066fc:	6a 00                	push   $0x0
  pushl $125
801066fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106700:	e9 b5 f6 ff ff       	jmp    80105dba <alltraps>

80106705 <vector126>:
.globl vector126
vector126:
  pushl $0
80106705:	6a 00                	push   $0x0
  pushl $126
80106707:	6a 7e                	push   $0x7e
  jmp alltraps
80106709:	e9 ac f6 ff ff       	jmp    80105dba <alltraps>

8010670e <vector127>:
.globl vector127
vector127:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $127
80106710:	6a 7f                	push   $0x7f
  jmp alltraps
80106712:	e9 a3 f6 ff ff       	jmp    80105dba <alltraps>

80106717 <vector128>:
.globl vector128
vector128:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $128
80106719:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010671e:	e9 97 f6 ff ff       	jmp    80105dba <alltraps>

80106723 <vector129>:
.globl vector129
vector129:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $129
80106725:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010672a:	e9 8b f6 ff ff       	jmp    80105dba <alltraps>

8010672f <vector130>:
.globl vector130
vector130:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $130
80106731:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106736:	e9 7f f6 ff ff       	jmp    80105dba <alltraps>

8010673b <vector131>:
.globl vector131
vector131:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $131
8010673d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106742:	e9 73 f6 ff ff       	jmp    80105dba <alltraps>

80106747 <vector132>:
.globl vector132
vector132:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $132
80106749:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010674e:	e9 67 f6 ff ff       	jmp    80105dba <alltraps>

80106753 <vector133>:
.globl vector133
vector133:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $133
80106755:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010675a:	e9 5b f6 ff ff       	jmp    80105dba <alltraps>

8010675f <vector134>:
.globl vector134
vector134:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $134
80106761:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106766:	e9 4f f6 ff ff       	jmp    80105dba <alltraps>

8010676b <vector135>:
.globl vector135
vector135:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $135
8010676d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106772:	e9 43 f6 ff ff       	jmp    80105dba <alltraps>

80106777 <vector136>:
.globl vector136
vector136:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $136
80106779:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010677e:	e9 37 f6 ff ff       	jmp    80105dba <alltraps>

80106783 <vector137>:
.globl vector137
vector137:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $137
80106785:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010678a:	e9 2b f6 ff ff       	jmp    80105dba <alltraps>

8010678f <vector138>:
.globl vector138
vector138:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $138
80106791:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106796:	e9 1f f6 ff ff       	jmp    80105dba <alltraps>

8010679b <vector139>:
.globl vector139
vector139:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $139
8010679d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801067a2:	e9 13 f6 ff ff       	jmp    80105dba <alltraps>

801067a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $140
801067a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801067ae:	e9 07 f6 ff ff       	jmp    80105dba <alltraps>

801067b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $141
801067b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801067ba:	e9 fb f5 ff ff       	jmp    80105dba <alltraps>

801067bf <vector142>:
.globl vector142
vector142:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $142
801067c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801067c6:	e9 ef f5 ff ff       	jmp    80105dba <alltraps>

801067cb <vector143>:
.globl vector143
vector143:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $143
801067cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801067d2:	e9 e3 f5 ff ff       	jmp    80105dba <alltraps>

801067d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $144
801067d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801067de:	e9 d7 f5 ff ff       	jmp    80105dba <alltraps>

801067e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $145
801067e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801067ea:	e9 cb f5 ff ff       	jmp    80105dba <alltraps>

801067ef <vector146>:
.globl vector146
vector146:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $146
801067f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067f6:	e9 bf f5 ff ff       	jmp    80105dba <alltraps>

801067fb <vector147>:
.globl vector147
vector147:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $147
801067fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106802:	e9 b3 f5 ff ff       	jmp    80105dba <alltraps>

80106807 <vector148>:
.globl vector148
vector148:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $148
80106809:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010680e:	e9 a7 f5 ff ff       	jmp    80105dba <alltraps>

80106813 <vector149>:
.globl vector149
vector149:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $149
80106815:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010681a:	e9 9b f5 ff ff       	jmp    80105dba <alltraps>

8010681f <vector150>:
.globl vector150
vector150:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $150
80106821:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106826:	e9 8f f5 ff ff       	jmp    80105dba <alltraps>

8010682b <vector151>:
.globl vector151
vector151:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $151
8010682d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106832:	e9 83 f5 ff ff       	jmp    80105dba <alltraps>

80106837 <vector152>:
.globl vector152
vector152:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $152
80106839:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010683e:	e9 77 f5 ff ff       	jmp    80105dba <alltraps>

80106843 <vector153>:
.globl vector153
vector153:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $153
80106845:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010684a:	e9 6b f5 ff ff       	jmp    80105dba <alltraps>

8010684f <vector154>:
.globl vector154
vector154:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $154
80106851:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106856:	e9 5f f5 ff ff       	jmp    80105dba <alltraps>

8010685b <vector155>:
.globl vector155
vector155:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $155
8010685d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106862:	e9 53 f5 ff ff       	jmp    80105dba <alltraps>

80106867 <vector156>:
.globl vector156
vector156:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $156
80106869:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010686e:	e9 47 f5 ff ff       	jmp    80105dba <alltraps>

80106873 <vector157>:
.globl vector157
vector157:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $157
80106875:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010687a:	e9 3b f5 ff ff       	jmp    80105dba <alltraps>

8010687f <vector158>:
.globl vector158
vector158:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $158
80106881:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106886:	e9 2f f5 ff ff       	jmp    80105dba <alltraps>

8010688b <vector159>:
.globl vector159
vector159:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $159
8010688d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106892:	e9 23 f5 ff ff       	jmp    80105dba <alltraps>

80106897 <vector160>:
.globl vector160
vector160:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $160
80106899:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010689e:	e9 17 f5 ff ff       	jmp    80105dba <alltraps>

801068a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $161
801068a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801068aa:	e9 0b f5 ff ff       	jmp    80105dba <alltraps>

801068af <vector162>:
.globl vector162
vector162:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $162
801068b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801068b6:	e9 ff f4 ff ff       	jmp    80105dba <alltraps>

801068bb <vector163>:
.globl vector163
vector163:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $163
801068bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801068c2:	e9 f3 f4 ff ff       	jmp    80105dba <alltraps>

801068c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $164
801068c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801068ce:	e9 e7 f4 ff ff       	jmp    80105dba <alltraps>

801068d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $165
801068d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801068da:	e9 db f4 ff ff       	jmp    80105dba <alltraps>

801068df <vector166>:
.globl vector166
vector166:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $166
801068e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801068e6:	e9 cf f4 ff ff       	jmp    80105dba <alltraps>

801068eb <vector167>:
.globl vector167
vector167:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $167
801068ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068f2:	e9 c3 f4 ff ff       	jmp    80105dba <alltraps>

801068f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $168
801068f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068fe:	e9 b7 f4 ff ff       	jmp    80105dba <alltraps>

80106903 <vector169>:
.globl vector169
vector169:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $169
80106905:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010690a:	e9 ab f4 ff ff       	jmp    80105dba <alltraps>

8010690f <vector170>:
.globl vector170
vector170:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $170
80106911:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106916:	e9 9f f4 ff ff       	jmp    80105dba <alltraps>

8010691b <vector171>:
.globl vector171
vector171:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $171
8010691d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106922:	e9 93 f4 ff ff       	jmp    80105dba <alltraps>

80106927 <vector172>:
.globl vector172
vector172:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $172
80106929:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010692e:	e9 87 f4 ff ff       	jmp    80105dba <alltraps>

80106933 <vector173>:
.globl vector173
vector173:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $173
80106935:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010693a:	e9 7b f4 ff ff       	jmp    80105dba <alltraps>

8010693f <vector174>:
.globl vector174
vector174:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $174
80106941:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106946:	e9 6f f4 ff ff       	jmp    80105dba <alltraps>

8010694b <vector175>:
.globl vector175
vector175:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $175
8010694d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106952:	e9 63 f4 ff ff       	jmp    80105dba <alltraps>

80106957 <vector176>:
.globl vector176
vector176:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $176
80106959:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010695e:	e9 57 f4 ff ff       	jmp    80105dba <alltraps>

80106963 <vector177>:
.globl vector177
vector177:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $177
80106965:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010696a:	e9 4b f4 ff ff       	jmp    80105dba <alltraps>

8010696f <vector178>:
.globl vector178
vector178:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $178
80106971:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106976:	e9 3f f4 ff ff       	jmp    80105dba <alltraps>

8010697b <vector179>:
.globl vector179
vector179:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $179
8010697d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106982:	e9 33 f4 ff ff       	jmp    80105dba <alltraps>

80106987 <vector180>:
.globl vector180
vector180:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $180
80106989:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010698e:	e9 27 f4 ff ff       	jmp    80105dba <alltraps>

80106993 <vector181>:
.globl vector181
vector181:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $181
80106995:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010699a:	e9 1b f4 ff ff       	jmp    80105dba <alltraps>

8010699f <vector182>:
.globl vector182
vector182:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $182
801069a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801069a6:	e9 0f f4 ff ff       	jmp    80105dba <alltraps>

801069ab <vector183>:
.globl vector183
vector183:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $183
801069ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801069b2:	e9 03 f4 ff ff       	jmp    80105dba <alltraps>

801069b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $184
801069b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801069be:	e9 f7 f3 ff ff       	jmp    80105dba <alltraps>

801069c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $185
801069c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801069ca:	e9 eb f3 ff ff       	jmp    80105dba <alltraps>

801069cf <vector186>:
.globl vector186
vector186:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $186
801069d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801069d6:	e9 df f3 ff ff       	jmp    80105dba <alltraps>

801069db <vector187>:
.globl vector187
vector187:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $187
801069dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801069e2:	e9 d3 f3 ff ff       	jmp    80105dba <alltraps>

801069e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $188
801069e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801069ee:	e9 c7 f3 ff ff       	jmp    80105dba <alltraps>

801069f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $189
801069f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069fa:	e9 bb f3 ff ff       	jmp    80105dba <alltraps>

801069ff <vector190>:
.globl vector190
vector190:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $190
80106a01:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a06:	e9 af f3 ff ff       	jmp    80105dba <alltraps>

80106a0b <vector191>:
.globl vector191
vector191:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $191
80106a0d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106a12:	e9 a3 f3 ff ff       	jmp    80105dba <alltraps>

80106a17 <vector192>:
.globl vector192
vector192:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $192
80106a19:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106a1e:	e9 97 f3 ff ff       	jmp    80105dba <alltraps>

80106a23 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $193
80106a25:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a2a:	e9 8b f3 ff ff       	jmp    80105dba <alltraps>

80106a2f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $194
80106a31:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a36:	e9 7f f3 ff ff       	jmp    80105dba <alltraps>

80106a3b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $195
80106a3d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a42:	e9 73 f3 ff ff       	jmp    80105dba <alltraps>

80106a47 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $196
80106a49:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a4e:	e9 67 f3 ff ff       	jmp    80105dba <alltraps>

80106a53 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $197
80106a55:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a5a:	e9 5b f3 ff ff       	jmp    80105dba <alltraps>

80106a5f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $198
80106a61:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a66:	e9 4f f3 ff ff       	jmp    80105dba <alltraps>

80106a6b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $199
80106a6d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a72:	e9 43 f3 ff ff       	jmp    80105dba <alltraps>

80106a77 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $200
80106a79:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a7e:	e9 37 f3 ff ff       	jmp    80105dba <alltraps>

80106a83 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $201
80106a85:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a8a:	e9 2b f3 ff ff       	jmp    80105dba <alltraps>

80106a8f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $202
80106a91:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a96:	e9 1f f3 ff ff       	jmp    80105dba <alltraps>

80106a9b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $203
80106a9d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106aa2:	e9 13 f3 ff ff       	jmp    80105dba <alltraps>

80106aa7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $204
80106aa9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106aae:	e9 07 f3 ff ff       	jmp    80105dba <alltraps>

80106ab3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $205
80106ab5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106aba:	e9 fb f2 ff ff       	jmp    80105dba <alltraps>

80106abf <vector206>:
.globl vector206
vector206:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $206
80106ac1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ac6:	e9 ef f2 ff ff       	jmp    80105dba <alltraps>

80106acb <vector207>:
.globl vector207
vector207:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $207
80106acd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ad2:	e9 e3 f2 ff ff       	jmp    80105dba <alltraps>

80106ad7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $208
80106ad9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ade:	e9 d7 f2 ff ff       	jmp    80105dba <alltraps>

80106ae3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $209
80106ae5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106aea:	e9 cb f2 ff ff       	jmp    80105dba <alltraps>

80106aef <vector210>:
.globl vector210
vector210:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $210
80106af1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106af6:	e9 bf f2 ff ff       	jmp    80105dba <alltraps>

80106afb <vector211>:
.globl vector211
vector211:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $211
80106afd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b02:	e9 b3 f2 ff ff       	jmp    80105dba <alltraps>

80106b07 <vector212>:
.globl vector212
vector212:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $212
80106b09:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106b0e:	e9 a7 f2 ff ff       	jmp    80105dba <alltraps>

80106b13 <vector213>:
.globl vector213
vector213:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $213
80106b15:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106b1a:	e9 9b f2 ff ff       	jmp    80105dba <alltraps>

80106b1f <vector214>:
.globl vector214
vector214:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $214
80106b21:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b26:	e9 8f f2 ff ff       	jmp    80105dba <alltraps>

80106b2b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $215
80106b2d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b32:	e9 83 f2 ff ff       	jmp    80105dba <alltraps>

80106b37 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $216
80106b39:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b3e:	e9 77 f2 ff ff       	jmp    80105dba <alltraps>

80106b43 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $217
80106b45:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b4a:	e9 6b f2 ff ff       	jmp    80105dba <alltraps>

80106b4f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $218
80106b51:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b56:	e9 5f f2 ff ff       	jmp    80105dba <alltraps>

80106b5b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $219
80106b5d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b62:	e9 53 f2 ff ff       	jmp    80105dba <alltraps>

80106b67 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $220
80106b69:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b6e:	e9 47 f2 ff ff       	jmp    80105dba <alltraps>

80106b73 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $221
80106b75:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b7a:	e9 3b f2 ff ff       	jmp    80105dba <alltraps>

80106b7f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $222
80106b81:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b86:	e9 2f f2 ff ff       	jmp    80105dba <alltraps>

80106b8b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $223
80106b8d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b92:	e9 23 f2 ff ff       	jmp    80105dba <alltraps>

80106b97 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $224
80106b99:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b9e:	e9 17 f2 ff ff       	jmp    80105dba <alltraps>

80106ba3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $225
80106ba5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106baa:	e9 0b f2 ff ff       	jmp    80105dba <alltraps>

80106baf <vector226>:
.globl vector226
vector226:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $226
80106bb1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106bb6:	e9 ff f1 ff ff       	jmp    80105dba <alltraps>

80106bbb <vector227>:
.globl vector227
vector227:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $227
80106bbd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106bc2:	e9 f3 f1 ff ff       	jmp    80105dba <alltraps>

80106bc7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $228
80106bc9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106bce:	e9 e7 f1 ff ff       	jmp    80105dba <alltraps>

80106bd3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $229
80106bd5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106bda:	e9 db f1 ff ff       	jmp    80105dba <alltraps>

80106bdf <vector230>:
.globl vector230
vector230:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $230
80106be1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106be6:	e9 cf f1 ff ff       	jmp    80105dba <alltraps>

80106beb <vector231>:
.globl vector231
vector231:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $231
80106bed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106bf2:	e9 c3 f1 ff ff       	jmp    80105dba <alltraps>

80106bf7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $232
80106bf9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bfe:	e9 b7 f1 ff ff       	jmp    80105dba <alltraps>

80106c03 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $233
80106c05:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c0a:	e9 ab f1 ff ff       	jmp    80105dba <alltraps>

80106c0f <vector234>:
.globl vector234
vector234:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $234
80106c11:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106c16:	e9 9f f1 ff ff       	jmp    80105dba <alltraps>

80106c1b <vector235>:
.globl vector235
vector235:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $235
80106c1d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c22:	e9 93 f1 ff ff       	jmp    80105dba <alltraps>

80106c27 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $236
80106c29:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c2e:	e9 87 f1 ff ff       	jmp    80105dba <alltraps>

80106c33 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $237
80106c35:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c3a:	e9 7b f1 ff ff       	jmp    80105dba <alltraps>

80106c3f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $238
80106c41:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c46:	e9 6f f1 ff ff       	jmp    80105dba <alltraps>

80106c4b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $239
80106c4d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c52:	e9 63 f1 ff ff       	jmp    80105dba <alltraps>

80106c57 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $240
80106c59:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c5e:	e9 57 f1 ff ff       	jmp    80105dba <alltraps>

80106c63 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $241
80106c65:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c6a:	e9 4b f1 ff ff       	jmp    80105dba <alltraps>

80106c6f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $242
80106c71:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c76:	e9 3f f1 ff ff       	jmp    80105dba <alltraps>

80106c7b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $243
80106c7d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c82:	e9 33 f1 ff ff       	jmp    80105dba <alltraps>

80106c87 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $244
80106c89:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c8e:	e9 27 f1 ff ff       	jmp    80105dba <alltraps>

80106c93 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $245
80106c95:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c9a:	e9 1b f1 ff ff       	jmp    80105dba <alltraps>

80106c9f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $246
80106ca1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ca6:	e9 0f f1 ff ff       	jmp    80105dba <alltraps>

80106cab <vector247>:
.globl vector247
vector247:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $247
80106cad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106cb2:	e9 03 f1 ff ff       	jmp    80105dba <alltraps>

80106cb7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $248
80106cb9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106cbe:	e9 f7 f0 ff ff       	jmp    80105dba <alltraps>

80106cc3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $249
80106cc5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106cca:	e9 eb f0 ff ff       	jmp    80105dba <alltraps>

80106ccf <vector250>:
.globl vector250
vector250:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $250
80106cd1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106cd6:	e9 df f0 ff ff       	jmp    80105dba <alltraps>

80106cdb <vector251>:
.globl vector251
vector251:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $251
80106cdd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ce2:	e9 d3 f0 ff ff       	jmp    80105dba <alltraps>

80106ce7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $252
80106ce9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106cee:	e9 c7 f0 ff ff       	jmp    80105dba <alltraps>

80106cf3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $253
80106cf5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106cfa:	e9 bb f0 ff ff       	jmp    80105dba <alltraps>

80106cff <vector254>:
.globl vector254
vector254:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $254
80106d01:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d06:	e9 af f0 ff ff       	jmp    80105dba <alltraps>

80106d0b <vector255>:
.globl vector255
vector255:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $255
80106d0d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106d12:	e9 a3 f0 ff ff       	jmp    80105dba <alltraps>
80106d17:	66 90                	xchg   %ax,%ax
80106d19:	66 90                	xchg   %ax,%ax
80106d1b:	66 90                	xchg   %ax,%ax
80106d1d:	66 90                	xchg   %ax,%ax
80106d1f:	90                   	nop

80106d20 <writevgaregisters>:
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

// Write the specified values to the VGA registers

void writevgaregisters(uchar * regs) {
80106d20:	55                   	push   %ebp
80106d21:	ba c2 03 00 00       	mov    $0x3c2,%edx
80106d26:	89 e5                	mov    %esp,%ebp
80106d28:	57                   	push   %edi
80106d29:	56                   	push   %esi
80106d2a:	53                   	push   %ebx
80106d2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106d2e:	0f b6 03             	movzbl (%ebx),%eax
80106d31:	ee                   	out    %al,(%dx)

	/* write MISCELLANEOUS reg */
	outb(VGA_MISC_WRITE, *regs);
	regs++;
	/* write SEQUENCER regs */
	for (i = 0; i < VGA_NUM_SEQ_REGS; i++) {
80106d32:	31 c9                	xor    %ecx,%ecx
80106d34:	bf c4 03 00 00       	mov    $0x3c4,%edi
80106d39:	be c5 03 00 00       	mov    $0x3c5,%esi
80106d3e:	89 c8                	mov    %ecx,%eax
80106d40:	89 fa                	mov    %edi,%edx
80106d42:	ee                   	out    %al,(%dx)
80106d43:	0f b6 44 0b 01       	movzbl 0x1(%ebx,%ecx,1),%eax
80106d48:	89 f2                	mov    %esi,%edx
80106d4a:	ee                   	out    %al,(%dx)
80106d4b:	83 c1 01             	add    $0x1,%ecx
80106d4e:	83 f9 05             	cmp    $0x5,%ecx
80106d51:	75 eb                	jne    80106d3e <writevgaregisters+0x1e>
80106d53:	be d4 03 00 00       	mov    $0x3d4,%esi
80106d58:	b8 03 00 00 00       	mov    $0x3,%eax
80106d5d:	89 f2                	mov    %esi,%edx
80106d5f:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106d60:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80106d65:	89 ca                	mov    %ecx,%edx
80106d67:	ec                   	in     (%dx),%al
		outb(VGA_SEQ_DATA, *regs);
		regs++;
	}
	/* Unlock CRTC registers */
	outb(VGA_CRTC_INDEX, 0x03);
	outb(VGA_CRTC_DATA, inb(VGA_CRTC_DATA) | 0x80);
80106d68:	83 c8 80             	or     $0xffffff80,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106d6b:	ee                   	out    %al,(%dx)
80106d6c:	b8 11 00 00 00       	mov    $0x11,%eax
80106d71:	89 f2                	mov    %esi,%edx
80106d73:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106d74:	89 ca                	mov    %ecx,%edx
80106d76:	ec                   	in     (%dx),%al
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106d77:	83 e0 7f             	and    $0x7f,%eax
80106d7a:	ee                   	out    %al,(%dx)
	outb(VGA_CRTC_INDEX, 0x11);
	outb(VGA_CRTC_DATA, inb(VGA_CRTC_DATA) & ~0x80);
	/* Make sure they remain unlocked */
	regs[0x03] |= 0x80;
80106d7b:	80 4b 09 80          	orb    $0x80,0x9(%ebx)
	regs[0x11] &= ~0x80;
	/* write CRTC regs */
	for (i = 0; i < VGA_NUM_CRTC_REGS; i++)	{
80106d7f:	31 c9                	xor    %ecx,%ecx
80106d81:	bf d4 03 00 00       	mov    $0x3d4,%edi
80106d86:	be d5 03 00 00       	mov    $0x3d5,%esi
	regs[0x11] &= ~0x80;
80106d8b:	80 63 17 7f          	andb   $0x7f,0x17(%ebx)
	for (i = 0; i < VGA_NUM_CRTC_REGS; i++)	{
80106d8f:	90                   	nop
80106d90:	89 c8                	mov    %ecx,%eax
80106d92:	89 fa                	mov    %edi,%edx
80106d94:	ee                   	out    %al,(%dx)
80106d95:	0f b6 44 0b 06       	movzbl 0x6(%ebx,%ecx,1),%eax
80106d9a:	89 f2                	mov    %esi,%edx
80106d9c:	ee                   	out    %al,(%dx)
80106d9d:	83 c1 01             	add    $0x1,%ecx
80106da0:	83 f9 19             	cmp    $0x19,%ecx
80106da3:	75 eb                	jne    80106d90 <writevgaregisters+0x70>
		outb(VGA_CRTC_INDEX, i);
		outb(VGA_CRTC_DATA, *regs);
		regs++;
	}
	/* write GRAPHICS CONTROLLER regs */
	for (i = 0; i < VGA_NUM_GC_REGS; i++) {
80106da5:	31 c9                	xor    %ecx,%ecx
80106da7:	bf ce 03 00 00       	mov    $0x3ce,%edi
80106dac:	be cf 03 00 00       	mov    $0x3cf,%esi
80106db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106db8:	89 c8                	mov    %ecx,%eax
80106dba:	89 fa                	mov    %edi,%edx
80106dbc:	ee                   	out    %al,(%dx)
80106dbd:	0f b6 44 0b 1f       	movzbl 0x1f(%ebx,%ecx,1),%eax
80106dc2:	89 f2                	mov    %esi,%edx
80106dc4:	ee                   	out    %al,(%dx)
80106dc5:	83 c1 01             	add    $0x1,%ecx
80106dc8:	83 f9 09             	cmp    $0x9,%ecx
80106dcb:	75 eb                	jne    80106db8 <writevgaregisters+0x98>
		outb(VGA_GC_INDEX, i);
		outb(VGA_GC_DATA, *regs);
		regs++;
	}
	/* write ATTRIBUTE CONTROLLER regs */
	for (i = 0; i < VGA_NUM_AC_REGS; i++) {
80106dcd:	31 c9                	xor    %ecx,%ecx
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106dcf:	bf da 03 00 00       	mov    $0x3da,%edi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106dd4:	be c0 03 00 00       	mov    $0x3c0,%esi
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106de0:	89 fa                	mov    %edi,%edx
80106de2:	ec                   	in     (%dx),%al
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106de3:	89 c8                	mov    %ecx,%eax
80106de5:	89 f2                	mov    %esi,%edx
80106de7:	ee                   	out    %al,(%dx)
80106de8:	0f b6 44 0b 28       	movzbl 0x28(%ebx,%ecx,1),%eax
80106ded:	ee                   	out    %al,(%dx)
80106dee:	83 c1 01             	add    $0x1,%ecx
80106df1:	83 f9 15             	cmp    $0x15,%ecx
80106df4:	75 ea                	jne    80106de0 <writevgaregisters+0xc0>
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106df6:	89 fa                	mov    %edi,%edx
80106df8:	ec                   	in     (%dx),%al
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106df9:	b8 20 00 00 00       	mov    $0x20,%eax
80106dfe:	89 f2                	mov    %esi,%edx
80106e00:	ee                   	out    %al,(%dx)
		regs++;
	}
	/* lock 16-color palette and unblank display */
	(void)inb(VGA_INSTAT_READ);
	outb(VGA_AC_INDEX, 0x20);
}
80106e01:	5b                   	pop    %ebx
80106e02:	5e                   	pop    %esi
80106e03:	5f                   	pop    %edi
80106e04:	5d                   	pop    %ebp
80106e05:	c3                   	ret    
80106e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e0d:	8d 76 00             	lea    0x0(%esi),%esi

80106e10 <setplane>:

// Set video plane.  
//
// On entry, plane must be set to a value between 0 and 3

void setplane(uchar plane) {
80106e10:	55                   	push   %ebp
80106e11:	b8 04 00 00 00       	mov    $0x4,%eax
80106e16:	ba ce 03 00 00       	mov    $0x3ce,%edx
80106e1b:	89 e5                	mov    %esp,%ebp
	uchar planeMask;

	plane &= 3;
80106e1d:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
80106e21:	83 e1 03             	and    $0x3,%ecx
80106e24:	ee                   	out    %al,(%dx)
80106e25:	ba cf 03 00 00       	mov    $0x3cf,%edx
80106e2a:	89 c8                	mov    %ecx,%eax
80106e2c:	ee                   	out    %al,(%dx)
80106e2d:	b8 02 00 00 00       	mov    $0x2,%eax
80106e32:	ba c4 03 00 00       	mov    $0x3c4,%edx
80106e37:	ee                   	out    %al,(%dx)
	planeMask = 1 << plane;
80106e38:	b8 01 00 00 00       	mov    $0x1,%eax
80106e3d:	ba c5 03 00 00       	mov    $0x3c5,%edx
80106e42:	d3 e0                	shl    %cl,%eax
80106e44:	ee                   	out    %al,(%dx)
	outb(VGA_GC_INDEX, 4);
	outb(VGA_GC_DATA, plane);
	// Set write plane 
	outb(VGA_SEQ_INDEX, 2);
	outb(VGA_SEQ_DATA, planeMask);
}
80106e45:	5d                   	pop    %ebp
80106e46:	c3                   	ret    
80106e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e4e:	66 90                	xchg   %ax,%ax

80106e50 <getframebufferBase>:
80106e50:	b8 06 00 00 00       	mov    $0x6,%eax
80106e55:	ba ce 03 00 00       	mov    $0x3ce,%edx
80106e5a:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106e5b:	ba cf 03 00 00       	mov    $0x3cf,%edx
80106e60:	ec                   	in     (%dx),%al
	uchar* base;
	uchar plane;

	outb(VGA_GC_INDEX, 6);
	plane = inb(VGA_GC_DATA);
	plane >>= 2;
80106e61:	c0 e8 02             	shr    $0x2,%al
	plane &= 3;
	switch (plane) {
80106e64:	ba 00 00 0b 80       	mov    $0x800b0000,%edx
	plane &= 3;
80106e69:	83 e0 03             	and    $0x3,%eax
	switch (plane) {
80106e6c:	3c 02                	cmp    $0x2,%al
80106e6e:	74 0f                	je     80106e7f <getframebufferBase+0x2f>
		case 2:
			base = (uchar*)P2V(0xB0000);
			break;

		case 3:
			base = (uchar*)P2V(0xB8000);
80106e70:	3c 03                	cmp    $0x3,%al
80106e72:	ba 00 00 0a 80       	mov    $0x800a0000,%edx
80106e77:	b8 00 80 0b 80       	mov    $0x800b8000,%eax
80106e7c:	0f 44 d0             	cmove  %eax,%edx
			break;
	}
	return base;
}
80106e7f:	89 d0                	mov    %edx,%eax
80106e81:	c3                   	ret    
80106e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <writefont>:


void writefont(uchar * fontBuffer, unsigned int fontHeight)
{
80106e90:	55                   	push   %ebp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106e91:	b8 02 00 00 00       	mov    $0x2,%eax
80106e96:	ba c4 03 00 00       	mov    $0x3c4,%edx
80106e9b:	89 e5                	mov    %esp,%ebp
80106e9d:	57                   	push   %edi
80106e9e:	56                   	push   %esi
80106e9f:	53                   	push   %ebx
80106ea0:	83 ec 1c             	sub    $0x1c,%esp
80106ea3:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106ea6:	8b 75 0c             	mov    0xc(%ebp),%esi
80106ea9:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106eaa:	ba c5 03 00 00       	mov    $0x3c5,%edx
80106eaf:	ec                   	in     (%dx),%al
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106eb0:	ba c4 03 00 00       	mov    $0x3c4,%edx
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106eb5:	88 45 e7             	mov    %al,-0x19(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106eb8:	b8 04 00 00 00       	mov    $0x4,%eax
80106ebd:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106ebe:	ba c5 03 00 00       	mov    $0x3c5,%edx
80106ec3:	ec                   	in     (%dx),%al
	outb(VGA_SEQ_INDEX, 2);
	seq2 = inb(VGA_SEQ_DATA);

	outb(VGA_SEQ_INDEX, 4);
	seq4 = inb(VGA_SEQ_DATA);
	outb(VGA_SEQ_DATA, seq4 | 0x04);
80106ec4:	89 c1                	mov    %eax,%ecx
80106ec6:	88 45 e6             	mov    %al,-0x1a(%ebp)
80106ec9:	83 c9 04             	or     $0x4,%ecx
80106ecc:	89 c8                	mov    %ecx,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106ece:	ee                   	out    %al,(%dx)
80106ecf:	bf ce 03 00 00       	mov    $0x3ce,%edi
80106ed4:	b8 04 00 00 00       	mov    $0x4,%eax
80106ed9:	89 fa                	mov    %edi,%edx
80106edb:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106edc:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
80106ee1:	89 ca                	mov    %ecx,%edx
80106ee3:	ec                   	in     (%dx),%al
80106ee4:	88 45 e5             	mov    %al,-0x1b(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106ee7:	89 fa                	mov    %edi,%edx
80106ee9:	b8 05 00 00 00       	mov    $0x5,%eax
80106eee:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106eef:	89 ca                	mov    %ecx,%edx
80106ef1:	ec                   	in     (%dx),%al
80106ef2:	88 45 e4             	mov    %al,-0x1c(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106ef5:	83 e0 ef             	and    $0xffffffef,%eax
80106ef8:	ee                   	out    %al,(%dx)
80106ef9:	b8 06 00 00 00       	mov    $0x6,%eax
80106efe:	89 fa                	mov    %edi,%edx
80106f00:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80106f01:	89 ca                	mov    %ecx,%edx
80106f03:	ec                   	in     (%dx),%al
80106f04:	88 45 e3             	mov    %al,-0x1d(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106f07:	83 e0 fd             	and    $0xfffffffd,%eax
80106f0a:	ee                   	out    %al,(%dx)
80106f0b:	b8 04 00 00 00       	mov    $0x4,%eax
80106f10:	89 fa                	mov    %edi,%edx
80106f12:	ee                   	out    %al,(%dx)
80106f13:	b8 02 00 00 00       	mov    $0x2,%eax
80106f18:	89 ca                	mov    %ecx,%edx
80106f1a:	ee                   	out    %al,(%dx)
80106f1b:	ba c4 03 00 00       	mov    $0x3c4,%edx
80106f20:	ee                   	out    %al,(%dx)
80106f21:	b8 04 00 00 00       	mov    $0x4,%eax
80106f26:	ba c5 03 00 00       	mov    $0x3c5,%edx
80106f2b:	ee                   	out    %al,(%dx)
	gc6 = inb(VGA_GC_DATA);
	outb(VGA_GC_DATA, gc6 & ~0x02);
	
	setplane(2);
	// Write font to video memory
	fontBase = (uchar*)P2V(0xB8000); 
80106f2c:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
80106f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (i = 0; i < 256; i++) {
		memmove((ushort*)fontBase, fontBuffer, fontHeight);
80106f38:	83 ec 04             	sub    $0x4,%esp
80106f3b:	56                   	push   %esi
80106f3c:	53                   	push   %ebx
		fontBase += 32;
		fontBuffer += fontHeight;
80106f3d:	01 f3                	add    %esi,%ebx
		memmove((ushort*)fontBase, fontBuffer, fontHeight);
80106f3f:	57                   	push   %edi
		fontBase += 32;
80106f40:	83 c7 20             	add    $0x20,%edi
		memmove((ushort*)fontBase, fontBuffer, fontHeight);
80106f43:	e8 f8 dc ff ff       	call   80104c40 <memmove>
	for (i = 0; i < 256; i++) {
80106f48:	83 c4 10             	add    $0x10,%esp
80106f4b:	81 ff 00 a0 0b 80    	cmp    $0x800ba000,%edi
80106f51:	75 e5                	jne    80106f38 <writefont+0xa8>
80106f53:	be c4 03 00 00       	mov    $0x3c4,%esi
80106f58:	b8 02 00 00 00       	mov    $0x2,%eax
80106f5d:	89 f2                	mov    %esi,%edx
80106f5f:	ee                   	out    %al,(%dx)
80106f60:	bb c5 03 00 00       	mov    $0x3c5,%ebx
80106f65:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106f69:	89 da                	mov    %ebx,%edx
80106f6b:	ee                   	out    %al,(%dx)
80106f6c:	b9 04 00 00 00       	mov    $0x4,%ecx
80106f71:	89 f2                	mov    %esi,%edx
80106f73:	89 c8                	mov    %ecx,%eax
80106f75:	ee                   	out    %al,(%dx)
80106f76:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
80106f7a:	89 da                	mov    %ebx,%edx
80106f7c:	ee                   	out    %al,(%dx)
80106f7d:	bb ce 03 00 00       	mov    $0x3ce,%ebx
80106f82:	89 c8                	mov    %ecx,%eax
80106f84:	89 da                	mov    %ebx,%edx
80106f86:	ee                   	out    %al,(%dx)
80106f87:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
80106f8c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
80106f90:	89 ca                	mov    %ecx,%edx
80106f92:	ee                   	out    %al,(%dx)
80106f93:	b8 05 00 00 00       	mov    $0x5,%eax
80106f98:	89 da                	mov    %ebx,%edx
80106f9a:	ee                   	out    %al,(%dx)
80106f9b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80106f9f:	89 ca                	mov    %ecx,%edx
80106fa1:	ee                   	out    %al,(%dx)
80106fa2:	b8 06 00 00 00       	mov    $0x6,%eax
80106fa7:	89 da                	mov    %ebx,%edx
80106fa9:	ee                   	out    %al,(%dx)
80106faa:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
80106fae:	89 ca                	mov    %ecx,%edx
80106fb0:	ee                   	out    %al,(%dx)
	outb(VGA_GC_DATA, gc4);
	outb(VGA_GC_INDEX, 5);
	outb(VGA_GC_DATA, gc5);
	outb(VGA_GC_INDEX, 6);
	outb(VGA_GC_DATA, gc6);
}
80106fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb4:	5b                   	pop    %ebx
80106fb5:	5e                   	pop    %esi
80106fb6:	5f                   	pop    %edi
80106fb7:	5d                   	pop    %ebp
80106fb8:	c3                   	ret    
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fc0 <videosetmode>:
//    13h : Graphics mode: 320x200 resolution. 256 colours.
//
// Returns: 0 if mode selected successfully, -1 if invalid mode requested.
//

int	videosetmode(uchar mode) {
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	31 f6                	xor    %esi,%esi
80106fc7:	53                   	push   %ebx
80106fc8:	83 ec 0c             	sub    $0xc,%esp
	releaseconslock();
	return returnValue;
}

uchar getcurrentvideomode() {
	return currentVideoMode;
80106fcb:	0f b6 3d dd c4 10 80 	movzbl 0x8010c4dd,%edi
int	videosetmode(uchar mode) {
80106fd2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (currentmode == mode) {
80106fd5:	89 f8                	mov    %edi,%eax
80106fd7:	38 d8                	cmp    %bl,%al
80106fd9:	74 28                	je     80107003 <videosetmode+0x43>
	acquireconslock();
80106fdb:	e8 60 9c ff ff       	call   80100c40 <acquireconslock>
	if (currentmode == 0x03) {
80106fe0:	89 f8                	mov    %edi,%eax
80106fe2:	3c 03                	cmp    $0x3,%al
80106fe4:	0f 84 96 00 00 00    	je     80107080 <videosetmode+0xc0>
	switch (mode)
80106fea:	80 fb 12             	cmp    $0x12,%bl
80106fed:	74 71                	je     80107060 <videosetmode+0xa0>
80106fef:	80 fb 13             	cmp    $0x13,%bl
80106ff2:	74 4c                	je     80107040 <videosetmode+0x80>
80106ff4:	be ff ff ff ff       	mov    $0xffffffff,%esi
80106ff9:	80 fb 03             	cmp    $0x3,%bl
80106ffc:	74 12                	je     80107010 <videosetmode+0x50>
	releaseconslock();
80106ffe:	e8 5d 9c ff ff       	call   80100c60 <releaseconslock>
}
80107003:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107006:	89 f0                	mov    %esi,%eax
80107008:	5b                   	pop    %ebx
80107009:	5e                   	pop    %esi
8010700a:	5f                   	pop    %edi
8010700b:	5d                   	pop    %ebp
8010700c:	c3                   	ret    
8010700d:	8d 76 00             	lea    0x0(%esi),%esi
			writevgaregisters(registers_80x25_text);
80107010:	83 ec 0c             	sub    $0xc,%esp
	int returnValue = 0;
80107013:	31 f6                	xor    %esi,%esi
			writevgaregisters(registers_80x25_text);
80107015:	68 a0 c4 10 80       	push   $0x8010c4a0
8010701a:	e8 01 fd ff ff       	call   80106d20 <writevgaregisters>
			writefont(font_8x16, 16);
8010701f:	58                   	pop    %eax
80107020:	5a                   	pop    %edx
80107021:	6a 10                	push   $0x10
80107023:	68 20 b4 10 80       	push   $0x8010b420
80107028:	e8 63 fe ff ff       	call   80106e90 <writefont>
			currentVideoMode = 0x03;
8010702d:	c6 05 dd c4 10 80 03 	movb   $0x3,0x8010c4dd
			outputbuffertoscreen();
80107034:	e8 e7 93 ff ff       	call   80100420 <outputbuffertoscreen>
			break;
80107039:	83 c4 10             	add    $0x10,%esp
8010703c:	eb c0                	jmp    80106ffe <videosetmode+0x3e>
8010703e:	66 90                	xchg   %ax,%ax
			writevgaregisters(registers_320x200x256);
80107040:	83 ec 0c             	sub    $0xc,%esp
	int returnValue = 0;
80107043:	31 f6                	xor    %esi,%esi
			writevgaregisters(registers_320x200x256);
80107045:	68 60 c4 10 80       	push   $0x8010c460
8010704a:	e8 d1 fc ff ff       	call   80106d20 <writevgaregisters>
			currentVideoMode = 0x13;
8010704f:	c6 05 dd c4 10 80 13 	movb   $0x13,0x8010c4dd
			clear320x200x256();
80107056:	e8 05 b3 ff ff       	call   80102360 <clear320x200x256>
			break;
8010705b:	83 c4 10             	add    $0x10,%esp
8010705e:	eb 9e                	jmp    80106ffe <videosetmode+0x3e>
			writevgaregisters(registers_640x480x16);
80107060:	83 ec 0c             	sub    $0xc,%esp
	int returnValue = 0;
80107063:	31 f6                	xor    %esi,%esi
			writevgaregisters(registers_640x480x16);
80107065:	68 20 c4 10 80       	push   $0x8010c420
8010706a:	e8 b1 fc ff ff       	call   80106d20 <writevgaregisters>
			currentVideoMode = 0x12;
8010706f:	c6 05 dd c4 10 80 12 	movb   $0x12,0x8010c4dd
			break;
80107076:	83 c4 10             	add    $0x10,%esp
80107079:	eb 83                	jmp    80106ffe <videosetmode+0x3e>
8010707b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010707f:	90                   	nop
		grabscreentobuffer();
80107080:	e8 3b 93 ff ff       	call   801003c0 <grabscreentobuffer>
80107085:	e9 60 ff ff ff       	jmp    80106fea <videosetmode+0x2a>
8010708a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107090 <getcurrentvideomode>:
}
80107090:	0f b6 05 dd c4 10 80 	movzbl 0x8010c4dd,%eax
80107097:	c3                   	ret    
80107098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709f:	90                   	nop

801070a0 <sys_setvideomode>:

// System call to set video mode

int sys_setvideomode(void) {
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	83 ec 20             	sub    $0x20,%esp
	int mode;

	if (argint(0, &mode) < 0) {
801070a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070a9:	50                   	push   %eax
801070aa:	6a 00                	push   $0x0
801070ac:	e8 af dd ff ff       	call   80104e60 <argint>
801070b1:	83 c4 10             	add    $0x10,%esp
801070b4:	85 c0                	test   %eax,%eax
801070b6:	78 18                	js     801070d0 <sys_setvideomode+0x30>
		return -1;
	}
	return videosetmode(mode);
801070b8:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
801070bc:	83 ec 0c             	sub    $0xc,%esp
801070bf:	50                   	push   %eax
801070c0:	e8 fb fe ff ff       	call   80106fc0 <videosetmode>
801070c5:	83 c4 10             	add    $0x10,%esp
801070c8:	c9                   	leave  
801070c9:	c3                   	ret    
801070ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070d0:	c9                   	leave  
		return -1;
801070d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070d6:	c3                   	ret    
801070d7:	66 90                	xchg   %ax,%ax
801070d9:	66 90                	xchg   %ax,%ax
801070db:	66 90                	xchg   %ax,%ax
801070dd:	66 90                	xchg   %ax,%ax
801070df:	90                   	nop

801070e0 <deallocuvm.part.0>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx

    if (newsz >= oldsz) {
        return oldsz;
    }

    a = PGROUNDUP(newsz);
801070e6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801070ec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
801070f2:	83 ec 1c             	sub    $0x1c,%esp
801070f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    for (; a  < oldsz; a += PGSIZE) {
801070f8:	39 d3                	cmp    %edx,%ebx
801070fa:	73 49                	jae    80107145 <deallocuvm.part.0+0x65>
801070fc:	89 c7                	mov    %eax,%edi
801070fe:	eb 0c                	jmp    8010710c <deallocuvm.part.0+0x2c>
        pte = walkpgdir(pgdir, (char*)a, 0);
        if (!pte) {
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107100:	83 c0 01             	add    $0x1,%eax
80107103:	c1 e0 16             	shl    $0x16,%eax
80107106:	89 c3                	mov    %eax,%ebx
    for (; a  < oldsz; a += PGSIZE) {
80107108:	39 da                	cmp    %ebx,%edx
8010710a:	76 39                	jbe    80107145 <deallocuvm.part.0+0x65>
    pde = &pgdir[PDX(va)];
8010710c:	89 d8                	mov    %ebx,%eax
8010710e:	c1 e8 16             	shr    $0x16,%eax
    if (*pde & PTE_P) {
80107111:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107114:	f6 c1 01             	test   $0x1,%cl
80107117:	74 e7                	je     80107100 <deallocuvm.part.0+0x20>
    return &pgtab[PTX(va)];
80107119:	89 de                	mov    %ebx,%esi
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010711b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
    return &pgtab[PTX(va)];
80107121:	c1 ee 0a             	shr    $0xa,%esi
80107124:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010712a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
        if (!pte) {
80107131:	85 f6                	test   %esi,%esi
80107133:	74 cb                	je     80107100 <deallocuvm.part.0+0x20>
        }
        else if ((*pte & PTE_P) != 0) {
80107135:	8b 06                	mov    (%esi),%eax
80107137:	a8 01                	test   $0x1,%al
80107139:	75 15                	jne    80107150 <deallocuvm.part.0+0x70>
    for (; a  < oldsz; a += PGSIZE) {
8010713b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107141:	39 da                	cmp    %ebx,%edx
80107143:	77 c7                	ja     8010710c <deallocuvm.part.0+0x2c>
            kfree(v);
            *pte = 0;
        }
    }
    return newsz;
}
80107145:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010714b:	5b                   	pop    %ebx
8010714c:	5e                   	pop    %esi
8010714d:	5f                   	pop    %edi
8010714e:	5d                   	pop    %ebp
8010714f:	c3                   	ret    
            if (pa == 0) {
80107150:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107155:	74 25                	je     8010717c <deallocuvm.part.0+0x9c>
            kfree(v);
80107157:	83 ec 0c             	sub    $0xc,%esp
            char *v = P2V(pa);
8010715a:	05 00 00 00 80       	add    $0x80000000,%eax
8010715f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (; a  < oldsz; a += PGSIZE) {
80107162:	81 c3 00 10 00 00    	add    $0x1000,%ebx
            kfree(v);
80107168:	50                   	push   %eax
80107169:	e8 52 b8 ff ff       	call   801029c0 <kfree>
            *pte = 0;
8010716e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    for (; a  < oldsz; a += PGSIZE) {
80107174:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107177:	83 c4 10             	add    $0x10,%esp
8010717a:	eb 8c                	jmp    80107108 <deallocuvm.part.0+0x28>
                panic("kfree");
8010717c:	83 ec 0c             	sub    $0xc,%esp
8010717f:	68 66 7d 10 80       	push   $0x80107d66
80107184:	e8 f7 92 ff ff       	call   80100480 <panic>
80107189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107190 <mappages>:
static int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	53                   	push   %ebx
    a = (char*)PGROUNDDOWN((uint)va);
80107196:	89 d3                	mov    %edx,%ebx
80107198:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
static int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
8010719e:	83 ec 1c             	sub    $0x1c,%esp
801071a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071a4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801071a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
801071b0:	8b 45 08             	mov    0x8(%ebp),%eax
801071b3:	29 d8                	sub    %ebx,%eax
801071b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071b8:	eb 3d                	jmp    801071f7 <mappages+0x67>
801071ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return &pgtab[PTX(va)];
801071c0:	89 da                	mov    %ebx,%edx
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return &pgtab[PTX(va)];
801071c7:	c1 ea 0a             	shr    $0xa,%edx
801071ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
        if ((pte = walkpgdir(pgdir, a, 1)) == 0) {
801071d7:	85 c0                	test   %eax,%eax
801071d9:	74 75                	je     80107250 <mappages+0xc0>
        if (*pte & PTE_P) {
801071db:	f6 00 01             	testb  $0x1,(%eax)
801071de:	0f 85 86 00 00 00    	jne    8010726a <mappages+0xda>
        *pte = pa | perm | PTE_P;
801071e4:	0b 75 0c             	or     0xc(%ebp),%esi
801071e7:	83 ce 01             	or     $0x1,%esi
801071ea:	89 30                	mov    %esi,(%eax)
        if (a == last) {
801071ec:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801071ef:	74 6f                	je     80107260 <mappages+0xd0>
        a += PGSIZE;
801071f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    for (;;) {
801071f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
    pde = &pgdir[PDX(va)];
801071fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071fd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107200:	89 d8                	mov    %ebx,%eax
80107202:	c1 e8 16             	shr    $0x16,%eax
80107205:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
    if (*pde & PTE_P) {
80107208:	8b 07                	mov    (%edi),%eax
8010720a:	a8 01                	test   $0x1,%al
8010720c:	75 b2                	jne    801071c0 <mappages+0x30>
        if (!alloc || (pgtab = (pte_t*)kalloc()) == 0) {
8010720e:	e8 6d b9 ff ff       	call   80102b80 <kalloc>
80107213:	85 c0                	test   %eax,%eax
80107215:	74 39                	je     80107250 <mappages+0xc0>
        memset(pgtab, 0, PGSIZE);
80107217:	83 ec 04             	sub    $0x4,%esp
8010721a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010721d:	68 00 10 00 00       	push   $0x1000
80107222:	6a 00                	push   $0x0
80107224:	50                   	push   %eax
80107225:	e8 76 d9 ff ff       	call   80104ba0 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010722a:	8b 55 d8             	mov    -0x28(%ebp),%edx
    return &pgtab[PTX(va)];
8010722d:	83 c4 10             	add    $0x10,%esp
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107230:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107236:	83 c8 07             	or     $0x7,%eax
80107239:	89 07                	mov    %eax,(%edi)
    return &pgtab[PTX(va)];
8010723b:	89 d8                	mov    %ebx,%eax
8010723d:	c1 e8 0a             	shr    $0xa,%eax
80107240:	25 fc 0f 00 00       	and    $0xffc,%eax
80107245:	01 d0                	add    %edx,%eax
80107247:	eb 92                	jmp    801071db <mappages+0x4b>
80107249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107250:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107253:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107258:	5b                   	pop    %ebx
80107259:	5e                   	pop    %esi
8010725a:	5f                   	pop    %edi
8010725b:	5d                   	pop    %ebp
8010725c:	c3                   	ret    
8010725d:	8d 76 00             	lea    0x0(%esi),%esi
80107260:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107263:	31 c0                	xor    %eax,%eax
}
80107265:	5b                   	pop    %ebx
80107266:	5e                   	pop    %esi
80107267:	5f                   	pop    %edi
80107268:	5d                   	pop    %ebp
80107269:	c3                   	ret    
            panic("remap");
8010726a:	83 ec 0c             	sub    $0xc,%esp
8010726d:	68 bc 83 10 80       	push   $0x801083bc
80107272:	e8 09 92 ff ff       	call   80100480 <panic>
80107277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010727e:	66 90                	xchg   %ax,%ax

80107280 <seginit>:
void seginit(void) {
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	83 ec 18             	sub    $0x18,%esp
    c = &cpus[cpuid()];
80107286:	e8 05 cc ff ff       	call   80103e90 <cpuid>
    pd[0] = size - 1;
8010728b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107290:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107296:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010729a:	c7 80 98 48 11 80 ff 	movl   $0xffff,-0x7feeb768(%eax)
801072a1:	ff 00 00 
801072a4:	c7 80 9c 48 11 80 00 	movl   $0xcf9a00,-0x7feeb764(%eax)
801072ab:	9a cf 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801072ae:	c7 80 a0 48 11 80 ff 	movl   $0xffff,-0x7feeb760(%eax)
801072b5:	ff 00 00 
801072b8:	c7 80 a4 48 11 80 00 	movl   $0xcf9200,-0x7feeb75c(%eax)
801072bf:	92 cf 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
801072c2:	c7 80 a8 48 11 80 ff 	movl   $0xffff,-0x7feeb758(%eax)
801072c9:	ff 00 00 
801072cc:	c7 80 ac 48 11 80 00 	movl   $0xcffa00,-0x7feeb754(%eax)
801072d3:	fa cf 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072d6:	c7 80 b0 48 11 80 ff 	movl   $0xffff,-0x7feeb750(%eax)
801072dd:	ff 00 00 
801072e0:	c7 80 b4 48 11 80 00 	movl   $0xcff200,-0x7feeb74c(%eax)
801072e7:	f2 cf 00 
    lgdt(c->gdt, sizeof(c->gdt));
801072ea:	05 90 48 11 80       	add    $0x80114890,%eax
    pd[1] = (uint)p;
801072ef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    pd[2] = (uint)p >> 16;
801072f3:	c1 e8 10             	shr    $0x10,%eax
801072f6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    asm volatile ("lgdt (%0)" : : "r" (pd));
801072fa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072fd:	0f 01 10             	lgdtl  (%eax)
}
80107300:	c9                   	leave  
80107301:	c3                   	ret    
80107302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107310 <switchkvm>:
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107310:	a1 44 75 11 80       	mov    0x80117544,%eax
80107315:	05 00 00 00 80       	add    $0x80000000,%eax
    return val;
}

static inline void lcr3(uint val) {
    asm volatile ("movl %0,%%cr3" : : "r" (val));
8010731a:	0f 22 d8             	mov    %eax,%cr3
}
8010731d:	c3                   	ret    
8010731e:	66 90                	xchg   %ax,%ax

80107320 <switchuvm>:
void switchuvm(struct proc *p) {
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 1c             	sub    $0x1c,%esp
80107329:	8b 75 08             	mov    0x8(%ebp),%esi
    if (p == 0) {
8010732c:	85 f6                	test   %esi,%esi
8010732e:	0f 84 cb 00 00 00    	je     801073ff <switchuvm+0xdf>
    if (p->kstack == 0) {
80107334:	8b 46 08             	mov    0x8(%esi),%eax
80107337:	85 c0                	test   %eax,%eax
80107339:	0f 84 da 00 00 00    	je     80107419 <switchuvm+0xf9>
    if (p->pgdir == 0) {
8010733f:	8b 46 04             	mov    0x4(%esi),%eax
80107342:	85 c0                	test   %eax,%eax
80107344:	0f 84 c2 00 00 00    	je     8010740c <switchuvm+0xec>
    pushcli();
8010734a:	e8 41 d6 ff ff       	call   80104990 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010734f:	e8 dc ca ff ff       	call   80103e30 <mycpu>
80107354:	89 c3                	mov    %eax,%ebx
80107356:	e8 d5 ca ff ff       	call   80103e30 <mycpu>
8010735b:	89 c7                	mov    %eax,%edi
8010735d:	e8 ce ca ff ff       	call   80103e30 <mycpu>
80107362:	83 c7 08             	add    $0x8,%edi
80107365:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107368:	e8 c3 ca ff ff       	call   80103e30 <mycpu>
8010736d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107370:	ba 67 00 00 00       	mov    $0x67,%edx
80107375:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010737c:	83 c0 08             	add    $0x8,%eax
8010737f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80107386:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010738b:	83 c1 08             	add    $0x8,%ecx
8010738e:	c1 e8 18             	shr    $0x18,%eax
80107391:	c1 e9 10             	shr    $0x10,%ecx
80107394:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010739a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801073a0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801073a5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
801073ac:	bb 10 00 00 00       	mov    $0x10,%ebx
    mycpu()->gdt[SEG_TSS].s = 0;
801073b1:	e8 7a ca ff ff       	call   80103e30 <mycpu>
801073b6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
801073bd:	e8 6e ca ff ff       	call   80103e30 <mycpu>
801073c2:	66 89 58 10          	mov    %bx,0x10(%eax)
    mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073c6:	8b 5e 08             	mov    0x8(%esi),%ebx
801073c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073cf:	e8 5c ca ff ff       	call   80103e30 <mycpu>
801073d4:	89 58 0c             	mov    %ebx,0xc(%eax)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
801073d7:	e8 54 ca ff ff       	call   80103e30 <mycpu>
801073dc:	66 89 78 6e          	mov    %di,0x6e(%eax)
    asm volatile ("ltr %0" : : "r" (sel));
801073e0:	b8 28 00 00 00       	mov    $0x28,%eax
801073e5:	0f 00 d8             	ltr    %ax
    lcr3(V2P(p->pgdir));  // switch to process's address space
801073e8:	8b 46 04             	mov    0x4(%esi),%eax
801073eb:	05 00 00 00 80       	add    $0x80000000,%eax
    asm volatile ("movl %0,%%cr3" : : "r" (val));
801073f0:	0f 22 d8             	mov    %eax,%cr3
}
801073f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073f6:	5b                   	pop    %ebx
801073f7:	5e                   	pop    %esi
801073f8:	5f                   	pop    %edi
801073f9:	5d                   	pop    %ebp
    popcli();
801073fa:	e9 e1 d5 ff ff       	jmp    801049e0 <popcli>
        panic("switchuvm: no process");
801073ff:	83 ec 0c             	sub    $0xc,%esp
80107402:	68 c2 83 10 80       	push   $0x801083c2
80107407:	e8 74 90 ff ff       	call   80100480 <panic>
        panic("switchuvm: no pgdir");
8010740c:	83 ec 0c             	sub    $0xc,%esp
8010740f:	68 ed 83 10 80       	push   $0x801083ed
80107414:	e8 67 90 ff ff       	call   80100480 <panic>
        panic("switchuvm: no kstack");
80107419:	83 ec 0c             	sub    $0xc,%esp
8010741c:	68 d8 83 10 80       	push   $0x801083d8
80107421:	e8 5a 90 ff ff       	call   80100480 <panic>
80107426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010742d:	8d 76 00             	lea    0x0(%esi),%esi

80107430 <inituvm>:
void inituvm(pde_t *pgdir, char *init, uint sz) {
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	53                   	push   %ebx
80107436:	83 ec 1c             	sub    $0x1c,%esp
80107439:	8b 45 0c             	mov    0xc(%ebp),%eax
8010743c:	8b 75 10             	mov    0x10(%ebp),%esi
8010743f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (sz >= PGSIZE) {
80107445:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010744b:	77 4b                	ja     80107498 <inituvm+0x68>
    mem = kalloc();
8010744d:	e8 2e b7 ff ff       	call   80102b80 <kalloc>
    memset(mem, 0, PGSIZE);
80107452:	83 ec 04             	sub    $0x4,%esp
80107455:	68 00 10 00 00       	push   $0x1000
    mem = kalloc();
8010745a:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
8010745c:	6a 00                	push   $0x0
8010745e:	50                   	push   %eax
8010745f:	e8 3c d7 ff ff       	call   80104ba0 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107464:	58                   	pop    %eax
80107465:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010746b:	5a                   	pop    %edx
8010746c:	6a 06                	push   $0x6
8010746e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107473:	31 d2                	xor    %edx,%edx
80107475:	50                   	push   %eax
80107476:	89 f8                	mov    %edi,%eax
80107478:	e8 13 fd ff ff       	call   80107190 <mappages>
    memmove(mem, init, sz);
8010747d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107480:	89 75 10             	mov    %esi,0x10(%ebp)
80107483:	83 c4 10             	add    $0x10,%esp
80107486:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107489:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010748c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010748f:	5b                   	pop    %ebx
80107490:	5e                   	pop    %esi
80107491:	5f                   	pop    %edi
80107492:	5d                   	pop    %ebp
    memmove(mem, init, sz);
80107493:	e9 a8 d7 ff ff       	jmp    80104c40 <memmove>
        panic("inituvm: more than a page");
80107498:	83 ec 0c             	sub    $0xc,%esp
8010749b:	68 01 84 10 80       	push   $0x80108401
801074a0:	e8 db 8f ff ff       	call   80100480 <panic>
801074a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801074b0 <loaduvm>:
int loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
801074b6:	83 ec 1c             	sub    $0x1c,%esp
801074b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801074bc:	8b 75 18             	mov    0x18(%ebp),%esi
    if ((uint) addr % PGSIZE != 0) {
801074bf:	a9 ff 0f 00 00       	test   $0xfff,%eax
801074c4:	0f 85 bb 00 00 00    	jne    80107585 <loaduvm+0xd5>
    for (i = 0; i < sz; i += PGSIZE) {
801074ca:	01 f0                	add    %esi,%eax
801074cc:	89 f3                	mov    %esi,%ebx
801074ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (readi(ip, P2V(pa), offset + i, n) != n) {
801074d1:	8b 45 14             	mov    0x14(%ebp),%eax
801074d4:	01 f0                	add    %esi,%eax
801074d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (i = 0; i < sz; i += PGSIZE) {
801074d9:	85 f6                	test   %esi,%esi
801074db:	0f 84 87 00 00 00    	je     80107568 <loaduvm+0xb8>
801074e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pde = &pgdir[PDX(va)];
801074e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if (*pde & PTE_P) {
801074eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801074ee:	29 d8                	sub    %ebx,%eax
    pde = &pgdir[PDX(va)];
801074f0:	89 c2                	mov    %eax,%edx
801074f2:	c1 ea 16             	shr    $0x16,%edx
    if (*pde & PTE_P) {
801074f5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801074f8:	f6 c2 01             	test   $0x1,%dl
801074fb:	75 13                	jne    80107510 <loaduvm+0x60>
            panic("loaduvm: address should exist");
801074fd:	83 ec 0c             	sub    $0xc,%esp
80107500:	68 1b 84 10 80       	push   $0x8010841b
80107505:	e8 76 8f ff ff       	call   80100480 <panic>
8010750a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return &pgtab[PTX(va)];
80107510:	c1 e8 0a             	shr    $0xa,%eax
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107513:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    return &pgtab[PTX(va)];
80107519:	25 fc 0f 00 00       	and    $0xffc,%eax
8010751e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0) {
80107525:	85 c0                	test   %eax,%eax
80107527:	74 d4                	je     801074fd <loaduvm+0x4d>
        pa = PTE_ADDR(*pte);
80107529:	8b 00                	mov    (%eax),%eax
        if (readi(ip, P2V(pa), offset + i, n) != n) {
8010752b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        if (sz - i < PGSIZE) {
8010752e:	bf 00 10 00 00       	mov    $0x1000,%edi
        pa = PTE_ADDR(*pte);
80107533:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (sz - i < PGSIZE) {
80107538:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010753e:	0f 46 fb             	cmovbe %ebx,%edi
        if (readi(ip, P2V(pa), offset + i, n) != n) {
80107541:	29 d9                	sub    %ebx,%ecx
80107543:	05 00 00 00 80       	add    $0x80000000,%eax
80107548:	57                   	push   %edi
80107549:	51                   	push   %ecx
8010754a:	50                   	push   %eax
8010754b:	ff 75 10             	push   0x10(%ebp)
8010754e:	e8 bd a7 ff ff       	call   80101d10 <readi>
80107553:	83 c4 10             	add    $0x10,%esp
80107556:	39 f8                	cmp    %edi,%eax
80107558:	75 1e                	jne    80107578 <loaduvm+0xc8>
    for (i = 0; i < sz; i += PGSIZE) {
8010755a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107560:	89 f0                	mov    %esi,%eax
80107562:	29 d8                	sub    %ebx,%eax
80107564:	39 c6                	cmp    %eax,%esi
80107566:	77 80                	ja     801074e8 <loaduvm+0x38>
}
80107568:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010756b:	31 c0                	xor    %eax,%eax
}
8010756d:	5b                   	pop    %ebx
8010756e:	5e                   	pop    %esi
8010756f:	5f                   	pop    %edi
80107570:	5d                   	pop    %ebp
80107571:	c3                   	ret    
80107572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107578:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
8010757b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107580:	5b                   	pop    %ebx
80107581:	5e                   	pop    %esi
80107582:	5f                   	pop    %edi
80107583:	5d                   	pop    %ebp
80107584:	c3                   	ret    
        panic("loaduvm: addr must be page aligned");
80107585:	83 ec 0c             	sub    $0xc,%esp
80107588:	68 bc 84 10 80       	push   $0x801084bc
8010758d:	e8 ee 8e ff ff       	call   80100480 <panic>
80107592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075a0 <allocuvm>:
int allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 1c             	sub    $0x1c,%esp
    if (newsz >= KERNBASE) {
801075a9:	8b 45 10             	mov    0x10(%ebp),%eax
int allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
801075ac:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (newsz >= KERNBASE) {
801075af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075b2:	85 c0                	test   %eax,%eax
801075b4:	0f 88 b6 00 00 00    	js     80107670 <allocuvm+0xd0>
    if (newsz < oldsz) {
801075ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
        return oldsz;
801075bd:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (newsz < oldsz) {
801075c0:	0f 82 9a 00 00 00    	jb     80107660 <allocuvm+0xc0>
    a = PGROUNDUP(oldsz);
801075c6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075cc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    for (; a < newsz; a += PGSIZE) {
801075d2:	39 75 10             	cmp    %esi,0x10(%ebp)
801075d5:	77 44                	ja     8010761b <allocuvm+0x7b>
801075d7:	e9 87 00 00 00       	jmp    80107663 <allocuvm+0xc3>
801075dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        memset(mem, 0, PGSIZE);
801075e0:	83 ec 04             	sub    $0x4,%esp
801075e3:	68 00 10 00 00       	push   $0x1000
801075e8:	6a 00                	push   $0x0
801075ea:	50                   	push   %eax
801075eb:	e8 b0 d5 ff ff       	call   80104ba0 <memset>
        if (mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
801075f0:	58                   	pop    %eax
801075f1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075f7:	5a                   	pop    %edx
801075f8:	6a 06                	push   $0x6
801075fa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075ff:	89 f2                	mov    %esi,%edx
80107601:	50                   	push   %eax
80107602:	89 f8                	mov    %edi,%eax
80107604:	e8 87 fb ff ff       	call   80107190 <mappages>
80107609:	83 c4 10             	add    $0x10,%esp
8010760c:	85 c0                	test   %eax,%eax
8010760e:	78 78                	js     80107688 <allocuvm+0xe8>
    for (; a < newsz; a += PGSIZE) {
80107610:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107616:	39 75 10             	cmp    %esi,0x10(%ebp)
80107619:	76 48                	jbe    80107663 <allocuvm+0xc3>
        mem = kalloc();
8010761b:	e8 60 b5 ff ff       	call   80102b80 <kalloc>
80107620:	89 c3                	mov    %eax,%ebx
        if (mem == 0) {
80107622:	85 c0                	test   %eax,%eax
80107624:	75 ba                	jne    801075e0 <allocuvm+0x40>
            cprintf("allocuvm out of memory\n");
80107626:	83 ec 0c             	sub    $0xc,%esp
80107629:	68 39 84 10 80       	push   $0x80108439
8010762e:	e8 ad 91 ff ff       	call   801007e0 <cprintf>
    if (newsz >= oldsz) {
80107633:	8b 45 0c             	mov    0xc(%ebp),%eax
80107636:	83 c4 10             	add    $0x10,%esp
80107639:	39 45 10             	cmp    %eax,0x10(%ebp)
8010763c:	74 32                	je     80107670 <allocuvm+0xd0>
8010763e:	8b 55 10             	mov    0x10(%ebp),%edx
80107641:	89 c1                	mov    %eax,%ecx
80107643:	89 f8                	mov    %edi,%eax
80107645:	e8 96 fa ff ff       	call   801070e0 <deallocuvm.part.0>
            return 0;
8010764a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107651:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107654:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107657:	5b                   	pop    %ebx
80107658:	5e                   	pop    %esi
80107659:	5f                   	pop    %edi
8010765a:	5d                   	pop    %ebp
8010765b:	c3                   	ret    
8010765c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return oldsz;
80107660:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107666:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107669:	5b                   	pop    %ebx
8010766a:	5e                   	pop    %esi
8010766b:	5f                   	pop    %edi
8010766c:	5d                   	pop    %ebp
8010766d:	c3                   	ret    
8010766e:	66 90                	xchg   %ax,%ax
        return 0;
80107670:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010767a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010767d:	5b                   	pop    %ebx
8010767e:	5e                   	pop    %esi
8010767f:	5f                   	pop    %edi
80107680:	5d                   	pop    %ebp
80107681:	c3                   	ret    
80107682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            cprintf("allocuvm out of memory (2)\n");
80107688:	83 ec 0c             	sub    $0xc,%esp
8010768b:	68 51 84 10 80       	push   $0x80108451
80107690:	e8 4b 91 ff ff       	call   801007e0 <cprintf>
    if (newsz >= oldsz) {
80107695:	8b 45 0c             	mov    0xc(%ebp),%eax
80107698:	83 c4 10             	add    $0x10,%esp
8010769b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010769e:	74 0c                	je     801076ac <allocuvm+0x10c>
801076a0:	8b 55 10             	mov    0x10(%ebp),%edx
801076a3:	89 c1                	mov    %eax,%ecx
801076a5:	89 f8                	mov    %edi,%eax
801076a7:	e8 34 fa ff ff       	call   801070e0 <deallocuvm.part.0>
            kfree(mem);
801076ac:	83 ec 0c             	sub    $0xc,%esp
801076af:	53                   	push   %ebx
801076b0:	e8 0b b3 ff ff       	call   801029c0 <kfree>
            return 0;
801076b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801076bc:	83 c4 10             	add    $0x10,%esp
}
801076bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076c5:	5b                   	pop    %ebx
801076c6:	5e                   	pop    %esi
801076c7:	5f                   	pop    %edi
801076c8:	5d                   	pop    %ebp
801076c9:	c3                   	ret    
801076ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076d0 <deallocuvm>:
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801076d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801076d9:	8b 45 08             	mov    0x8(%ebp),%eax
    if (newsz >= oldsz) {
801076dc:	39 d1                	cmp    %edx,%ecx
801076de:	73 10                	jae    801076f0 <deallocuvm+0x20>
}
801076e0:	5d                   	pop    %ebp
801076e1:	e9 fa f9 ff ff       	jmp    801070e0 <deallocuvm.part.0>
801076e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ed:	8d 76 00             	lea    0x0(%esi),%esi
801076f0:	89 d0                	mov    %edx,%eax
801076f2:	5d                   	pop    %ebp
801076f3:	c3                   	ret    
801076f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076ff:	90                   	nop

80107700 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir) {
80107700:	55                   	push   %ebp
80107701:	89 e5                	mov    %esp,%ebp
80107703:	57                   	push   %edi
80107704:	56                   	push   %esi
80107705:	53                   	push   %ebx
80107706:	83 ec 0c             	sub    $0xc,%esp
80107709:	8b 75 08             	mov    0x8(%ebp),%esi
    uint i;

    if (pgdir == 0) {
8010770c:	85 f6                	test   %esi,%esi
8010770e:	74 59                	je     80107769 <freevm+0x69>
    if (newsz >= oldsz) {
80107710:	31 c9                	xor    %ecx,%ecx
80107712:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107717:	89 f0                	mov    %esi,%eax
80107719:	89 f3                	mov    %esi,%ebx
8010771b:	e8 c0 f9 ff ff       	call   801070e0 <deallocuvm.part.0>
        panic("freevm: no pgdir");
    }
    deallocuvm(pgdir, KERNBASE, 0);
    for (i = 0; i < NPDENTRIES; i++) {
80107720:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107726:	eb 0f                	jmp    80107737 <freevm+0x37>
80107728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010772f:	90                   	nop
80107730:	83 c3 04             	add    $0x4,%ebx
80107733:	39 df                	cmp    %ebx,%edi
80107735:	74 23                	je     8010775a <freevm+0x5a>
        if (pgdir[i] & PTE_P) {
80107737:	8b 03                	mov    (%ebx),%eax
80107739:	a8 01                	test   $0x1,%al
8010773b:	74 f3                	je     80107730 <freevm+0x30>
            char * v = P2V(PTE_ADDR(pgdir[i]));
8010773d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            kfree(v);
80107742:	83 ec 0c             	sub    $0xc,%esp
    for (i = 0; i < NPDENTRIES; i++) {
80107745:	83 c3 04             	add    $0x4,%ebx
            char * v = P2V(PTE_ADDR(pgdir[i]));
80107748:	05 00 00 00 80       	add    $0x80000000,%eax
            kfree(v);
8010774d:	50                   	push   %eax
8010774e:	e8 6d b2 ff ff       	call   801029c0 <kfree>
80107753:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NPDENTRIES; i++) {
80107756:	39 df                	cmp    %ebx,%edi
80107758:	75 dd                	jne    80107737 <freevm+0x37>
        }
    }
    kfree((char*)pgdir);
8010775a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010775d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107760:	5b                   	pop    %ebx
80107761:	5e                   	pop    %esi
80107762:	5f                   	pop    %edi
80107763:	5d                   	pop    %ebp
    kfree((char*)pgdir);
80107764:	e9 57 b2 ff ff       	jmp    801029c0 <kfree>
        panic("freevm: no pgdir");
80107769:	83 ec 0c             	sub    $0xc,%esp
8010776c:	68 6d 84 10 80       	push   $0x8010846d
80107771:	e8 0a 8d ff ff       	call   80100480 <panic>
80107776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010777d:	8d 76 00             	lea    0x0(%esi),%esi

80107780 <setupkvm>:
pde_t*setupkvm(void) {
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	56                   	push   %esi
80107784:	53                   	push   %ebx
    if ((pgdir = (pde_t*)kalloc()) == 0) {
80107785:	e8 f6 b3 ff ff       	call   80102b80 <kalloc>
8010778a:	89 c6                	mov    %eax,%esi
8010778c:	85 c0                	test   %eax,%eax
8010778e:	74 42                	je     801077d2 <setupkvm+0x52>
    memset(pgdir, 0, PGSIZE);
80107790:	83 ec 04             	sub    $0x4,%esp
    for (k = kmap; k < &kmap[NELEM(kmap)]; k++) {
80107793:	bb e0 c4 10 80       	mov    $0x8010c4e0,%ebx
    memset(pgdir, 0, PGSIZE);
80107798:	68 00 10 00 00       	push   $0x1000
8010779d:	6a 00                	push   $0x0
8010779f:	50                   	push   %eax
801077a0:	e8 fb d3 ff ff       	call   80104ba0 <memset>
801077a5:	83 c4 10             	add    $0x10,%esp
                     (uint)k->phys_start, k->perm) < 0) {
801077a8:	8b 43 04             	mov    0x4(%ebx),%eax
        if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077ab:	83 ec 08             	sub    $0x8,%esp
801077ae:	8b 4b 08             	mov    0x8(%ebx),%ecx
801077b1:	ff 73 0c             	push   0xc(%ebx)
801077b4:	8b 13                	mov    (%ebx),%edx
801077b6:	50                   	push   %eax
801077b7:	29 c1                	sub    %eax,%ecx
801077b9:	89 f0                	mov    %esi,%eax
801077bb:	e8 d0 f9 ff ff       	call   80107190 <mappages>
801077c0:	83 c4 10             	add    $0x10,%esp
801077c3:	85 c0                	test   %eax,%eax
801077c5:	78 19                	js     801077e0 <setupkvm+0x60>
    for (k = kmap; k < &kmap[NELEM(kmap)]; k++) {
801077c7:	83 c3 10             	add    $0x10,%ebx
801077ca:	81 fb 20 c5 10 80    	cmp    $0x8010c520,%ebx
801077d0:	75 d6                	jne    801077a8 <setupkvm+0x28>
}
801077d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077d5:	89 f0                	mov    %esi,%eax
801077d7:	5b                   	pop    %ebx
801077d8:	5e                   	pop    %esi
801077d9:	5d                   	pop    %ebp
801077da:	c3                   	ret    
801077db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077df:	90                   	nop
            freevm(pgdir);
801077e0:	83 ec 0c             	sub    $0xc,%esp
801077e3:	56                   	push   %esi
            return 0;
801077e4:	31 f6                	xor    %esi,%esi
            freevm(pgdir);
801077e6:	e8 15 ff ff ff       	call   80107700 <freevm>
            return 0;
801077eb:	83 c4 10             	add    $0x10,%esp
}
801077ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077f1:	89 f0                	mov    %esi,%eax
801077f3:	5b                   	pop    %ebx
801077f4:	5e                   	pop    %esi
801077f5:	5d                   	pop    %ebp
801077f6:	c3                   	ret    
801077f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077fe:	66 90                	xchg   %ax,%ax

80107800 <kvmalloc>:
void kvmalloc(void)  {
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
80107806:	e8 75 ff ff ff       	call   80107780 <setupkvm>
8010780b:	a3 44 75 11 80       	mov    %eax,0x80117544
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107810:	05 00 00 00 80       	add    $0x80000000,%eax
80107815:	0f 22 d8             	mov    %eax,%cr3
}
80107818:	c9                   	leave  
80107819:	c3                   	ret    
8010781a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107820 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva) {
80107820:	55                   	push   %ebp
80107821:	89 e5                	mov    %esp,%ebp
80107823:	83 ec 08             	sub    $0x8,%esp
80107826:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (*pde & PTE_P) {
80107829:	8b 55 08             	mov    0x8(%ebp),%edx
    pde = &pgdir[PDX(va)];
8010782c:	89 c1                	mov    %eax,%ecx
8010782e:	c1 e9 16             	shr    $0x16,%ecx
    if (*pde & PTE_P) {
80107831:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107834:	f6 c2 01             	test   $0x1,%dl
80107837:	75 17                	jne    80107850 <clearpteu+0x30>
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
    if (pte == 0) {
        panic("clearpteu");
80107839:	83 ec 0c             	sub    $0xc,%esp
8010783c:	68 7e 84 10 80       	push   $0x8010847e
80107841:	e8 3a 8c ff ff       	call   80100480 <panic>
80107846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010784d:	8d 76 00             	lea    0x0(%esi),%esi
    return &pgtab[PTX(va)];
80107850:	c1 e8 0a             	shr    $0xa,%eax
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107853:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    return &pgtab[PTX(va)];
80107859:	25 fc 0f 00 00       	and    $0xffc,%eax
8010785e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if (pte == 0) {
80107865:	85 c0                	test   %eax,%eax
80107867:	74 d0                	je     80107839 <clearpteu+0x19>
    }
    *pte &= ~PTE_U;
80107869:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010786c:	c9                   	leave  
8010786d:	c3                   	ret    
8010786e:	66 90                	xchg   %ax,%ax

80107870 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t* copyuvm(pde_t *pgdir, uint sz) {
80107870:	55                   	push   %ebp
80107871:	89 e5                	mov    %esp,%ebp
80107873:	57                   	push   %edi
80107874:	56                   	push   %esi
80107875:	53                   	push   %ebx
80107876:	83 ec 1c             	sub    $0x1c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0) {
80107879:	e8 02 ff ff ff       	call   80107780 <setupkvm>
8010787e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107881:	85 c0                	test   %eax,%eax
80107883:	0f 84 bd 00 00 00    	je     80107946 <copyuvm+0xd6>
        return 0;
    }
    for (i = 0; i < sz; i += PGSIZE) {
80107889:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010788c:	85 db                	test   %ebx,%ebx
8010788e:	0f 84 b2 00 00 00    	je     80107946 <copyuvm+0xd6>
80107894:	31 f6                	xor    %esi,%esi
80107896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010789d:	8d 76 00             	lea    0x0(%esi),%esi
    if (*pde & PTE_P) {
801078a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
    pde = &pgdir[PDX(va)];
801078a3:	89 f0                	mov    %esi,%eax
801078a5:	c1 e8 16             	shr    $0x16,%eax
    if (*pde & PTE_P) {
801078a8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801078ab:	a8 01                	test   $0x1,%al
801078ad:	75 11                	jne    801078c0 <copyuvm+0x50>
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0) {
            panic("copyuvm: pte should exist");
801078af:	83 ec 0c             	sub    $0xc,%esp
801078b2:	68 88 84 10 80       	push   $0x80108488
801078b7:	e8 c4 8b ff ff       	call   80100480 <panic>
801078bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return &pgtab[PTX(va)];
801078c0:	89 f2                	mov    %esi,%edx
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return &pgtab[PTX(va)];
801078c7:	c1 ea 0a             	shr    $0xa,%edx
801078ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801078d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0) {
801078d7:	85 c0                	test   %eax,%eax
801078d9:	74 d4                	je     801078af <copyuvm+0x3f>
        }
        if (!(*pte & PTE_P)) {
801078db:	8b 00                	mov    (%eax),%eax
801078dd:	a8 01                	test   $0x1,%al
801078df:	0f 84 c2 00 00 00    	je     801079a7 <copyuvm+0x137>
            panic("copyuvm: page not present");
        }
        pa = PTE_ADDR(*pte);
801078e5:	89 c7                	mov    %eax,%edi
        flags = PTE_FLAGS(*pte);
801078e7:	25 ff 0f 00 00       	and    $0xfff,%eax
801078ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        pa = PTE_ADDR(*pte);
801078ef:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        if ((mem = kalloc()) == 0) {
801078f5:	e8 86 b2 ff ff       	call   80102b80 <kalloc>
801078fa:	89 c3                	mov    %eax,%ebx
801078fc:	85 c0                	test   %eax,%eax
801078fe:	74 58                	je     80107958 <copyuvm+0xe8>
            freevm(d);
            return 0;
        }
        memmove(mem, (char*)P2V(pa), PGSIZE);
80107900:	83 ec 04             	sub    $0x4,%esp
80107903:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107909:	68 00 10 00 00       	push   $0x1000
8010790e:	57                   	push   %edi
8010790f:	50                   	push   %eax
80107910:	e8 2b d3 ff ff       	call   80104c40 <memmove>
        if (mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107915:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010791b:	5a                   	pop    %edx
8010791c:	59                   	pop    %ecx
8010791d:	ff 75 e4             	push   -0x1c(%ebp)
80107920:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107925:	89 f2                	mov    %esi,%edx
80107927:	50                   	push   %eax
80107928:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010792b:	e8 60 f8 ff ff       	call   80107190 <mappages>
80107930:	83 c4 10             	add    $0x10,%esp
80107933:	85 c0                	test   %eax,%eax
80107935:	78 49                	js     80107980 <copyuvm+0x110>
    for (i = 0; i < sz; i += PGSIZE) {
80107937:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010793d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107940:	0f 87 5a ff ff ff    	ja     801078a0 <copyuvm+0x30>
            freevm(d);
            return 0;
        }
    }
    return d;
}
80107946:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107949:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010794c:	5b                   	pop    %ebx
8010794d:	5e                   	pop    %esi
8010794e:	5f                   	pop    %edi
8010794f:	5d                   	pop    %ebp
80107950:	c3                   	ret    
80107951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            freevm(d);
80107958:	83 ec 0c             	sub    $0xc,%esp
8010795b:	ff 75 e0             	push   -0x20(%ebp)
8010795e:	e8 9d fd ff ff       	call   80107700 <freevm>
            return 0;
80107963:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010796a:	83 c4 10             	add    $0x10,%esp
}
8010796d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107973:	5b                   	pop    %ebx
80107974:	5e                   	pop    %esi
80107975:	5f                   	pop    %edi
80107976:	5d                   	pop    %ebp
80107977:	c3                   	ret    
80107978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010797f:	90                   	nop
            kfree(mem);
80107980:	83 ec 0c             	sub    $0xc,%esp
80107983:	53                   	push   %ebx
80107984:	e8 37 b0 ff ff       	call   801029c0 <kfree>
            freevm(d);
80107989:	58                   	pop    %eax
8010798a:	ff 75 e0             	push   -0x20(%ebp)
8010798d:	e8 6e fd ff ff       	call   80107700 <freevm>
            return 0;
80107992:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107999:	83 c4 10             	add    $0x10,%esp
}
8010799c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010799f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079a2:	5b                   	pop    %ebx
801079a3:	5e                   	pop    %esi
801079a4:	5f                   	pop    %edi
801079a5:	5d                   	pop    %ebp
801079a6:	c3                   	ret    
            panic("copyuvm: page not present");
801079a7:	83 ec 0c             	sub    $0xc,%esp
801079aa:	68 a2 84 10 80       	push   $0x801084a2
801079af:	e8 cc 8a ff ff       	call   80100480 <panic>
801079b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079bf:	90                   	nop

801079c0 <uva2ka>:


// Map user virtual address to kernel address.
char*uva2ka(pde_t *pgdir, char *uva)      {
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (*pde & PTE_P) {
801079c6:	8b 55 08             	mov    0x8(%ebp),%edx
    pde = &pgdir[PDX(va)];
801079c9:	89 c1                	mov    %eax,%ecx
801079cb:	c1 e9 16             	shr    $0x16,%ecx
    if (*pde & PTE_P) {
801079ce:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801079d1:	f6 c2 01             	test   $0x1,%dl
801079d4:	0f 84 00 01 00 00    	je     80107ada <uva2ka.cold>
    return &pgtab[PTX(va)];
801079da:	c1 e8 0c             	shr    $0xc,%eax
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079dd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    }
    if ((*pte & PTE_U) == 0) {
        return 0;
    }
    return (char*)P2V(PTE_ADDR(*pte));
}
801079e3:	5d                   	pop    %ebp
    return &pgtab[PTX(va)];
801079e4:	25 ff 03 00 00       	and    $0x3ff,%eax
    if ((*pte & PTE_P) == 0) {
801079e9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
    if ((*pte & PTE_U) == 0) {
801079f0:	89 c2                	mov    %eax,%edx
    return (char*)P2V(PTE_ADDR(*pte));
801079f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((*pte & PTE_U) == 0) {
801079f7:	83 e2 05             	and    $0x5,%edx
    return (char*)P2V(PTE_ADDR(*pte));
801079fa:	05 00 00 00 80       	add    $0x80000000,%eax
801079ff:	83 fa 05             	cmp    $0x5,%edx
80107a02:	ba 00 00 00 00       	mov    $0x0,%edx
80107a07:	0f 45 c2             	cmovne %edx,%eax
}
80107a0a:	c3                   	ret    
80107a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a0f:	90                   	nop

80107a10 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)     {
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	57                   	push   %edi
80107a14:	56                   	push   %esi
80107a15:	53                   	push   %ebx
80107a16:	83 ec 0c             	sub    $0xc,%esp
80107a19:	8b 75 14             	mov    0x14(%ebp),%esi
80107a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a1f:	8b 55 10             	mov    0x10(%ebp),%edx
    char *buf, *pa0;
    uint n, va0;

    buf = (char*)p;
    while (len > 0) {
80107a22:	85 f6                	test   %esi,%esi
80107a24:	75 51                	jne    80107a77 <copyout+0x67>
80107a26:	e9 a5 00 00 00       	jmp    80107ad0 <copyout+0xc0>
80107a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a2f:	90                   	nop
    return (char*)P2V(PTE_ADDR(*pte));
80107a30:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107a36:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
        va0 = (uint)PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char*)va0);
        if (pa0 == 0) {
80107a3c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107a42:	74 75                	je     80107ab9 <copyout+0xa9>
            return -1;
        }
        n = PGSIZE - (va - va0);
80107a44:	89 fb                	mov    %edi,%ebx
        if (n > len) {
            n = len;
        }
        memmove(pa0 + (va - va0), buf, n);
80107a46:	89 55 10             	mov    %edx,0x10(%ebp)
        n = PGSIZE - (va - va0);
80107a49:	29 c3                	sub    %eax,%ebx
80107a4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a51:	39 f3                	cmp    %esi,%ebx
80107a53:	0f 47 de             	cmova  %esi,%ebx
        memmove(pa0 + (va - va0), buf, n);
80107a56:	29 f8                	sub    %edi,%eax
80107a58:	83 ec 04             	sub    $0x4,%esp
80107a5b:	01 c1                	add    %eax,%ecx
80107a5d:	53                   	push   %ebx
80107a5e:	52                   	push   %edx
80107a5f:	51                   	push   %ecx
80107a60:	e8 db d1 ff ff       	call   80104c40 <memmove>
        len -= n;
        buf += n;
80107a65:	8b 55 10             	mov    0x10(%ebp),%edx
        va = va0 + PGSIZE;
80107a68:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
    while (len > 0) {
80107a6e:	83 c4 10             	add    $0x10,%esp
        buf += n;
80107a71:	01 da                	add    %ebx,%edx
    while (len > 0) {
80107a73:	29 de                	sub    %ebx,%esi
80107a75:	74 59                	je     80107ad0 <copyout+0xc0>
    if (*pde & PTE_P) {
80107a77:	8b 5d 08             	mov    0x8(%ebp),%ebx
    pde = &pgdir[PDX(va)];
80107a7a:	89 c1                	mov    %eax,%ecx
        va0 = (uint)PGROUNDDOWN(va);
80107a7c:	89 c7                	mov    %eax,%edi
    pde = &pgdir[PDX(va)];
80107a7e:	c1 e9 16             	shr    $0x16,%ecx
        va0 = (uint)PGROUNDDOWN(va);
80107a81:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if (*pde & PTE_P) {
80107a87:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107a8a:	f6 c1 01             	test   $0x1,%cl
80107a8d:	0f 84 4e 00 00 00    	je     80107ae1 <copyout.cold>
    return &pgtab[PTX(va)];
80107a93:	89 fb                	mov    %edi,%ebx
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a95:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
    return &pgtab[PTX(va)];
80107a9b:	c1 eb 0c             	shr    $0xc,%ebx
80107a9e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
    if ((*pte & PTE_P) == 0) {
80107aa4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
    if ((*pte & PTE_U) == 0) {
80107aab:	89 d9                	mov    %ebx,%ecx
80107aad:	83 e1 05             	and    $0x5,%ecx
80107ab0:	83 f9 05             	cmp    $0x5,%ecx
80107ab3:	0f 84 77 ff ff ff    	je     80107a30 <copyout+0x20>
    }
    return 0;
}
80107ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107abc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ac1:	5b                   	pop    %ebx
80107ac2:	5e                   	pop    %esi
80107ac3:	5f                   	pop    %edi
80107ac4:	5d                   	pop    %ebp
80107ac5:	c3                   	ret    
80107ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107acd:	8d 76 00             	lea    0x0(%esi),%esi
80107ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107ad3:	31 c0                	xor    %eax,%eax
}
80107ad5:	5b                   	pop    %ebx
80107ad6:	5e                   	pop    %esi
80107ad7:	5f                   	pop    %edi
80107ad8:	5d                   	pop    %ebp
80107ad9:	c3                   	ret    

80107ada <uva2ka.cold>:
    if ((*pte & PTE_P) == 0) {
80107ada:	a1 00 00 00 00       	mov    0x0,%eax
80107adf:	0f 0b                	ud2    

80107ae1 <copyout.cold>:
80107ae1:	a1 00 00 00 00       	mov    0x0,%eax
80107ae6:	0f 0b                	ud2    
