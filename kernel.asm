
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 33 10 80       	mov    $0x801033f0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 2c 88 10 	movl   $0x8010882c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100049:	e8 14 51 00 00       	call   80105162 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 b0 db 10 80 a4 	movl   $0x8010dba4,0x8010dbb0
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 b4 db 10 80 a4 	movl   $0x8010dba4,0x8010dbb4
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 b4 db 10 80    	mov    0x8010dbb4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c a4 db 10 80 	movl   $0x8010dba4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 b4 db 10 80       	mov    %eax,0x8010dbb4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	b8 a4 db 10 80       	mov    $0x8010dba4,%eax
801000aa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ad:	72 bc                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801000be:	e8 c0 50 00 00       	call   80105183 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c3:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
801000c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cb:	eb 63                	jmp    80100130 <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d0:	8b 40 04             	mov    0x4(%eax),%eax
801000d3:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d6:	75 4f                	jne    80100127 <bget+0x76>
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 08             	mov    0x8(%eax),%eax
801000de:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e1:	75 44                	jne    80100127 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 00                	mov    (%eax),%eax
801000e8:	83 e0 01             	and    $0x1,%eax
801000eb:	85 c0                	test   %eax,%eax
801000ed:	75 23                	jne    80100112 <bget+0x61>
        b->flags |= B_BUSY;
801000ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f2:	8b 00                	mov    (%eax),%eax
801000f4:	89 c2                	mov    %eax,%edx
801000f6:	83 ca 01             	or     $0x1,%edx
801000f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fc:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fe:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100105:	e8 da 50 00 00       	call   801051e4 <release>
        return b;
8010010a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010d:	e9 93 00 00 00       	jmp    801001a5 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100112:	c7 44 24 04 80 c6 10 	movl   $0x8010c680,0x4(%esp)
80100119:	80 
8010011a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011d:	89 04 24             	mov    %eax,(%esp)
80100120:	e8 e6 4c 00 00       	call   80104e0b <sleep>
      goto loop;
80100125:	eb 9c                	jmp    801000c3 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012a:	8b 40 10             	mov    0x10(%eax),%eax
8010012d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100130:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
80100137:	75 94                	jne    801000cd <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100139:	a1 b0 db 10 80       	mov    0x8010dbb0,%eax
8010013e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100141:	eb 4d                	jmp    80100190 <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100146:	8b 00                	mov    (%eax),%eax
80100148:	83 e0 01             	and    $0x1,%eax
8010014b:	85 c0                	test   %eax,%eax
8010014d:	75 38                	jne    80100187 <bget+0xd6>
8010014f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100152:	8b 00                	mov    (%eax),%eax
80100154:	83 e0 04             	and    $0x4,%eax
80100157:	85 c0                	test   %eax,%eax
80100159:	75 2c                	jne    80100187 <bget+0xd6>
      b->dev = dev;
8010015b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015e:	8b 55 08             	mov    0x8(%ebp),%edx
80100161:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100167:	8b 55 0c             	mov    0xc(%ebp),%edx
8010016a:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100170:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010017d:	e8 62 50 00 00       	call   801051e4 <release>
      return b;
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	eb 1e                	jmp    801001a5 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010018a:	8b 40 0c             	mov    0xc(%eax),%eax
8010018d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100190:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
80100197:	75 aa                	jne    80100143 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100199:	c7 04 24 33 88 10 80 	movl   $0x80108833,(%esp)
801001a0:	e8 95 03 00 00       	call   8010053a <panic>
}
801001a5:	c9                   	leave  
801001a6:	c3                   	ret    

801001a7 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a7:	55                   	push   %ebp
801001a8:	89 e5                	mov    %esp,%ebp
801001aa:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b4:	8b 45 08             	mov    0x8(%ebp),%eax
801001b7:	89 04 24             	mov    %eax,(%esp)
801001ba:	e8 f2 fe ff ff       	call   801000b1 <bget>
801001bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c5:	8b 00                	mov    (%eax),%eax
801001c7:	83 e0 02             	and    $0x2,%eax
801001ca:	85 c0                	test   %eax,%eax
801001cc:	75 0b                	jne    801001d9 <bread+0x32>
    iderw(b);
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	89 04 24             	mov    %eax,(%esp)
801001d4:	e8 e5 25 00 00       	call   801027be <iderw>
  return b;
801001d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001dc:	c9                   	leave  
801001dd:	c3                   	ret    

801001de <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001de:	55                   	push   %ebp
801001df:	89 e5                	mov    %esp,%ebp
801001e1:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e4:	8b 45 08             	mov    0x8(%ebp),%eax
801001e7:	8b 00                	mov    (%eax),%eax
801001e9:	83 e0 01             	and    $0x1,%eax
801001ec:	85 c0                	test   %eax,%eax
801001ee:	75 0c                	jne    801001fc <bwrite+0x1e>
    panic("bwrite");
801001f0:	c7 04 24 44 88 10 80 	movl   $0x80108844,(%esp)
801001f7:	e8 3e 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fc:	8b 45 08             	mov    0x8(%ebp),%eax
801001ff:	8b 00                	mov    (%eax),%eax
80100201:	89 c2                	mov    %eax,%edx
80100203:	83 ca 04             	or     $0x4,%edx
80100206:	8b 45 08             	mov    0x8(%ebp),%eax
80100209:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020b:	8b 45 08             	mov    0x8(%ebp),%eax
8010020e:	89 04 24             	mov    %eax,(%esp)
80100211:	e8 a8 25 00 00       	call   801027be <iderw>
}
80100216:	c9                   	leave  
80100217:	c3                   	ret    

80100218 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100218:	55                   	push   %ebp
80100219:	89 e5                	mov    %esp,%ebp
8010021b:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021e:	8b 45 08             	mov    0x8(%ebp),%eax
80100221:	8b 00                	mov    (%eax),%eax
80100223:	83 e0 01             	and    $0x1,%eax
80100226:	85 c0                	test   %eax,%eax
80100228:	75 0c                	jne    80100236 <brelse+0x1e>
    panic("brelse");
8010022a:	c7 04 24 4b 88 10 80 	movl   $0x8010884b,(%esp)
80100231:	e8 04 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100236:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010023d:	e8 41 4f 00 00       	call   80105183 <acquire>

  b->next->prev = b->prev;
80100242:	8b 45 08             	mov    0x8(%ebp),%eax
80100245:	8b 40 10             	mov    0x10(%eax),%eax
80100248:	8b 55 08             	mov    0x8(%ebp),%edx
8010024b:	8b 52 0c             	mov    0xc(%edx),%edx
8010024e:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100251:	8b 45 08             	mov    0x8(%ebp),%eax
80100254:	8b 40 0c             	mov    0xc(%eax),%eax
80100257:	8b 55 08             	mov    0x8(%ebp),%edx
8010025a:	8b 52 10             	mov    0x10(%edx),%edx
8010025d:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100260:	8b 15 b4 db 10 80    	mov    0x8010dbb4,%edx
80100266:	8b 45 08             	mov    0x8(%ebp),%eax
80100269:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	c7 40 0c a4 db 10 80 	movl   $0x8010dba4,0xc(%eax)
  bcache.head.next->prev = b;
80100276:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
8010027b:	8b 55 08             	mov    0x8(%ebp),%edx
8010027e:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	a3 b4 db 10 80       	mov    %eax,0x8010dbb4

  b->flags &= ~B_BUSY;
80100289:	8b 45 08             	mov    0x8(%ebp),%eax
8010028c:	8b 00                	mov    (%eax),%eax
8010028e:	89 c2                	mov    %eax,%edx
80100290:	83 e2 fe             	and    $0xfffffffe,%edx
80100293:	8b 45 08             	mov    0x8(%ebp),%eax
80100296:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100298:	8b 45 08             	mov    0x8(%ebp),%eax
8010029b:	89 04 24             	mov    %eax,(%esp)
8010029e:	e8 ae 4c 00 00       	call   80104f51 <wakeup>

  release(&bcache.lock);
801002a3:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801002aa:	e8 35 4f 00 00       	call   801051e4 <release>
}
801002af:	c9                   	leave  
801002b0:	c3                   	ret    
801002b1:	00 00                	add    %al,(%eax)
	...

801002b4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b4:	55                   	push   %ebp
801002b5:	89 e5                	mov    %esp,%ebp
801002b7:	83 ec 14             	sub    $0x14,%esp
801002ba:	8b 45 08             	mov    0x8(%ebp),%eax
801002bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002c1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c5:	89 c2                	mov    %eax,%edx
801002c7:	ec                   	in     (%dx),%al
801002c8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002cb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cf:	c9                   	leave  
801002d0:	c3                   	ret    

801002d1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002d1:	55                   	push   %ebp
801002d2:	89 e5                	mov    %esp,%ebp
801002d4:	83 ec 08             	sub    $0x8,%esp
801002d7:	8b 55 08             	mov    0x8(%ebp),%edx
801002da:	8b 45 0c             	mov    0xc(%ebp),%eax
801002dd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002e1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002ec:	ee                   	out    %al,(%dx)
}
801002ed:	c9                   	leave  
801002ee:	c3                   	ret    

801002ef <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002ef:	55                   	push   %ebp
801002f0:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002f2:	fa                   	cli    
}
801002f3:	5d                   	pop    %ebp
801002f4:	c3                   	ret    

801002f5 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f5:	55                   	push   %ebp
801002f6:	89 e5                	mov    %esp,%ebp
801002f8:	53                   	push   %ebx
801002f9:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100300:	74 19                	je     8010031b <printint+0x26>
80100302:	8b 45 08             	mov    0x8(%ebp),%eax
80100305:	c1 e8 1f             	shr    $0x1f,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x26>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100319:	eb 06                	jmp    80100321 <printint+0x2c>
    x = -xx;
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  i = 0;
80100321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010032b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100331:	ba 00 00 00 00       	mov    $0x0,%edx
80100336:	f7 f3                	div    %ebx
80100338:	89 d0                	mov    %edx,%eax
8010033a:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100341:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
80100345:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }while((x /= base) != 0);
80100349:	8b 45 0c             	mov    0xc(%ebp),%eax
8010034c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100352:	ba 00 00 00 00       	mov    $0x0,%edx
80100357:	f7 75 d4             	divl   -0x2c(%ebp)
8010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010035d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100361:	75 c5                	jne    80100328 <printint+0x33>

  if(sign)
80100363:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100367:	74 21                	je     8010038a <printint+0x95>
    buf[i++] = '-';
80100369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010036c:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)
80100371:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)

  while(--i >= 0)
80100375:	eb 13                	jmp    8010038a <printint+0x95>
    consputc(buf[i]);
80100377:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010037a:	0f b6 44 05 e0       	movzbl -0x20(%ebp,%eax,1),%eax
8010037f:	0f be c0             	movsbl %al,%eax
80100382:	89 04 24             	mov    %eax,(%esp)
80100385:	e8 c4 03 00 00       	call   8010074e <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
8010038e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100392:	79 e3                	jns    80100377 <printint+0x82>
    consputc(buf[i]);
}
80100394:	83 c4 44             	add    $0x44,%esp
80100397:	5b                   	pop    %ebx
80100398:	5d                   	pop    %ebp
80100399:	c3                   	ret    

8010039a <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
8010039a:	55                   	push   %ebp
8010039b:	89 e5                	mov    %esp,%ebp
8010039d:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a0:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(locking)
801003a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801003ac:	74 0c                	je     801003ba <cprintf+0x20>
    acquire(&cons.lock);
801003ae:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801003b5:	e8 c9 4d 00 00       	call   80105183 <acquire>

  if (fmt == 0)
801003ba:	8b 45 08             	mov    0x8(%ebp),%eax
801003bd:	85 c0                	test   %eax,%eax
801003bf:	75 0c                	jne    801003cd <cprintf+0x33>
    panic("null fmt");
801003c1:	c7 04 24 52 88 10 80 	movl   $0x80108852,(%esp)
801003c8:	e8 6d 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003cd:	8d 45 08             	lea    0x8(%ebp),%eax
801003d0:	83 c0 04             	add    $0x4,%eax
801003d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801003dd:	e9 20 01 00 00       	jmp    80100502 <cprintf+0x168>
    if(c != '%'){
801003e2:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
801003e6:	74 10                	je     801003f8 <cprintf+0x5e>
      consputc(c);
801003e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801003eb:	89 04 24             	mov    %eax,(%esp)
801003ee:	e8 5b 03 00 00       	call   8010074e <consputc>
      continue;
801003f3:	e9 06 01 00 00       	jmp    801004fe <cprintf+0x164>
    }
    c = fmt[++i] & 0xff;
801003f8:	8b 55 08             	mov    0x8(%ebp),%edx
801003fb:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801003ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100402:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100405:	0f b6 00             	movzbl (%eax),%eax
80100408:	0f be c0             	movsbl %al,%eax
8010040b:	25 ff 00 00 00       	and    $0xff,%eax
80100410:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(c == 0)
80100413:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100417:	0f 84 08 01 00 00    	je     80100525 <cprintf+0x18b>
      break;
    switch(c){
8010041d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100420:	83 f8 70             	cmp    $0x70,%eax
80100423:	74 4d                	je     80100472 <cprintf+0xd8>
80100425:	83 f8 70             	cmp    $0x70,%eax
80100428:	7f 13                	jg     8010043d <cprintf+0xa3>
8010042a:	83 f8 25             	cmp    $0x25,%eax
8010042d:	0f 84 a6 00 00 00    	je     801004d9 <cprintf+0x13f>
80100433:	83 f8 64             	cmp    $0x64,%eax
80100436:	74 14                	je     8010044c <cprintf+0xb2>
80100438:	e9 aa 00 00 00       	jmp    801004e7 <cprintf+0x14d>
8010043d:	83 f8 73             	cmp    $0x73,%eax
80100440:	74 53                	je     80100495 <cprintf+0xfb>
80100442:	83 f8 78             	cmp    $0x78,%eax
80100445:	74 2b                	je     80100472 <cprintf+0xd8>
80100447:	e9 9b 00 00 00       	jmp    801004e7 <cprintf+0x14d>
    case 'd':
      printint(*argp++, 10, 1);
8010044c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010044f:	8b 00                	mov    (%eax),%eax
80100451:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100455:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045c:	00 
8010045d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100464:	00 
80100465:	89 04 24             	mov    %eax,(%esp)
80100468:	e8 88 fe ff ff       	call   801002f5 <printint>
      break;
8010046d:	e9 8c 00 00 00       	jmp    801004fe <cprintf+0x164>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100475:	8b 00                	mov    (%eax),%eax
80100477:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100482:	00 
80100483:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048a:	00 
8010048b:	89 04 24             	mov    %eax,(%esp)
8010048e:	e8 62 fe ff ff       	call   801002f5 <printint>
      break;
80100493:	eb 69                	jmp    801004fe <cprintf+0x164>
    case 's':
      if((s = (char*)*argp++) == 0)
80100495:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100498:	8b 00                	mov    (%eax),%eax
8010049a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010049d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801004a1:	0f 94 c0             	sete   %al
801004a4:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004a8:	84 c0                	test   %al,%al
801004aa:	74 20                	je     801004cc <cprintf+0x132>
        s = "(null)";
801004ac:	c7 45 f4 5b 88 10 80 	movl   $0x8010885b,-0xc(%ebp)
      for(; *s; s++)
801004b3:	eb 18                	jmp    801004cd <cprintf+0x133>
        consputc(*s);
801004b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004b8:	0f b6 00             	movzbl (%eax),%eax
801004bb:	0f be c0             	movsbl %al,%eax
801004be:	89 04 24             	mov    %eax,(%esp)
801004c1:	e8 88 02 00 00       	call   8010074e <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801004ca:	eb 01                	jmp    801004cd <cprintf+0x133>
801004cc:	90                   	nop
801004cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004d0:	0f b6 00             	movzbl (%eax),%eax
801004d3:	84 c0                	test   %al,%al
801004d5:	75 de                	jne    801004b5 <cprintf+0x11b>
        consputc(*s);
      break;
801004d7:	eb 25                	jmp    801004fe <cprintf+0x164>
    case '%':
      consputc('%');
801004d9:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e0:	e8 69 02 00 00       	call   8010074e <consputc>
      break;
801004e5:	eb 17                	jmp    801004fe <cprintf+0x164>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004e7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ee:	e8 5b 02 00 00       	call   8010074e <consputc>
      consputc(c);
801004f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801004f6:	89 04 24             	mov    %eax,(%esp)
801004f9:	e8 50 02 00 00       	call   8010074e <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801004fe:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100502:	8b 55 08             	mov    0x8(%ebp),%edx
80100505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100508:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010050b:	0f b6 00             	movzbl (%eax),%eax
8010050e:	0f be c0             	movsbl %al,%eax
80100511:	25 ff 00 00 00       	and    $0xff,%eax
80100516:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100519:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010051d:	0f 85 bf fe ff ff    	jne    801003e2 <cprintf+0x48>
80100523:	eb 01                	jmp    80100526 <cprintf+0x18c>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100525:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x19e>
    release(&cons.lock);
8010052c:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100533:	e8 ac 4c 00 00       	call   801051e4 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 aa fd ff ff       	call   801002ef <cli>
  cons.locking = 0;
80100545:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 62 88 10 80 	movl   $0x80108862,(%esp)
80100566:	e8 2f fe ff ff       	call   8010039a <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 24 fe ff ff       	call   8010039a <cprintf>
  cprintf("\n");
80100576:	c7 04 24 71 88 10 80 	movl   $0x80108871,(%esp)
8010057d:	e8 18 fe ff ff       	call   8010039a <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 9f 4c 00 00       	call   80105233 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 73 88 10 80 	movl   $0x80108873,(%esp)
801005af:	e8 e6 fd ff ff       	call   8010039a <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 ed fc ff ff       	call   801002d1 <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c4 fc ff ff       	call   801002b4 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c4 fc ff ff       	call   801002d1 <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 9b fc ff ff       	call   801002b4 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	89 ca                	mov    %ecx,%edx
80100647:	29 c2                	sub    %eax,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 33                	jmp    80100688 <cgaputc+0xbe>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 24                	jle    80100688 <cgaputc+0xbe>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 1e                	jmp    80100688 <cgaputc+0xbe>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	a1 00 90 10 80       	mov    0x80109000,%eax
8010066f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100672:	01 d2                	add    %edx,%edx
80100674:	8d 14 10             	lea    (%eax,%edx,1),%edx
80100677:	8b 45 08             	mov    0x8(%ebp),%eax
8010067a:	66 25 ff 00          	and    $0xff,%ax
8010067e:	80 cc 07             	or     $0x7,%ah
80100681:	66 89 02             	mov    %ax,(%edx)
80100684:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
80100688:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010068f:	7e 53                	jle    801006e4 <cgaputc+0x11a>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100691:	a1 00 90 10 80       	mov    0x80109000,%eax
80100696:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069c:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a1:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006a8:	00 
801006a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801006ad:	89 04 24             	mov    %eax,(%esp)
801006b0:	e8 f0 4d 00 00       	call   801054a5 <memmove>
    pos -= 80;
801006b5:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006b9:	b8 80 07 00 00       	mov    $0x780,%eax
801006be:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c1:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c4:	a1 00 90 10 80       	mov    0x80109000,%eax
801006c9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006cc:	01 c9                	add    %ecx,%ecx
801006ce:	01 c8                	add    %ecx,%eax
801006d0:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006db:	00 
801006dc:	89 04 24             	mov    %eax,(%esp)
801006df:	e8 ee 4c 00 00       	call   801053d2 <memset>
  }
  
  outb(CRTPORT, 14);
801006e4:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006eb:	00 
801006ec:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f3:	e8 d9 fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT+1, pos>>8);
801006f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fb:	c1 f8 08             	sar    $0x8,%eax
801006fe:	0f b6 c0             	movzbl %al,%eax
80100701:	89 44 24 04          	mov    %eax,0x4(%esp)
80100705:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070c:	e8 c0 fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT, 15);
80100711:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100718:	00 
80100719:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100720:	e8 ac fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT+1, pos);
80100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100728:	0f b6 c0             	movzbl %al,%eax
8010072b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010072f:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100736:	e8 96 fb ff ff       	call   801002d1 <outb>
  crt[pos] = ' ' | 0x0700;
8010073b:	a1 00 90 10 80       	mov    0x80109000,%eax
80100740:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100743:	01 d2                	add    %edx,%edx
80100745:	01 d0                	add    %edx,%eax
80100747:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074c:	c9                   	leave  
8010074d:	c3                   	ret    

8010074e <consputc>:

void
consputc(int c)
{
8010074e:	55                   	push   %ebp
8010074f:	89 e5                	mov    %esp,%ebp
80100751:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100754:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80100759:	85 c0                	test   %eax,%eax
8010075b:	74 07                	je     80100764 <consputc+0x16>
    cli();
8010075d:	e8 8d fb ff ff       	call   801002ef <cli>
    for(;;)
      ;
80100762:	eb fe                	jmp    80100762 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100764:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076b:	75 26                	jne    80100793 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100774:	e8 03 67 00 00       	call   80106e7c <uartputc>
80100779:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100780:	e8 f7 66 00 00       	call   80106e7c <uartputc>
80100785:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078c:	e8 eb 66 00 00       	call   80106e7c <uartputc>
80100791:	eb 0b                	jmp    8010079e <consputc+0x50>
  } else
    uartputc(c);
80100793:	8b 45 08             	mov    0x8(%ebp),%eax
80100796:	89 04 24             	mov    %eax,(%esp)
80100799:	e8 de 66 00 00       	call   80106e7c <uartputc>
  cgaputc(c);
8010079e:	8b 45 08             	mov    0x8(%ebp),%eax
801007a1:	89 04 24             	mov    %eax,(%esp)
801007a4:	e8 21 fe ff ff       	call   801005ca <cgaputc>
}
801007a9:	c9                   	leave  
801007aa:	c3                   	ret    

801007ab <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ab:	55                   	push   %ebp
801007ac:	89 e5                	mov    %esp,%ebp
801007ae:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b1:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
801007b8:	e8 c6 49 00 00       	call   80105183 <acquire>
  while((c = getc()) >= 0){
801007bd:	e9 3e 01 00 00       	jmp    80100900 <consoleintr+0x155>
    switch(c){
801007c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c5:	83 f8 10             	cmp    $0x10,%eax
801007c8:	74 1e                	je     801007e8 <consoleintr+0x3d>
801007ca:	83 f8 10             	cmp    $0x10,%eax
801007cd:	7f 0a                	jg     801007d9 <consoleintr+0x2e>
801007cf:	83 f8 08             	cmp    $0x8,%eax
801007d2:	74 68                	je     8010083c <consoleintr+0x91>
801007d4:	e9 94 00 00 00       	jmp    8010086d <consoleintr+0xc2>
801007d9:	83 f8 15             	cmp    $0x15,%eax
801007dc:	74 2f                	je     8010080d <consoleintr+0x62>
801007de:	83 f8 7f             	cmp    $0x7f,%eax
801007e1:	74 59                	je     8010083c <consoleintr+0x91>
801007e3:	e9 85 00 00 00       	jmp    8010086d <consoleintr+0xc2>
    case C('P'):  // Process listing.
      procdump();
801007e8:	e8 0b 48 00 00       	call   80104ff8 <procdump>
      break;
801007ed:	e9 0e 01 00 00       	jmp    80100900 <consoleintr+0x155>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f2:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801007f7:	83 e8 01             	sub    $0x1,%eax
801007fa:	a3 7c de 10 80       	mov    %eax,0x8010de7c
        consputc(BACKSPACE);
801007ff:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100806:	e8 43 ff ff ff       	call   8010074e <consputc>
8010080b:	eb 01                	jmp    8010080e <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080d:	90                   	nop
8010080e:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
80100814:	a1 78 de 10 80       	mov    0x8010de78,%eax
80100819:	39 c2                	cmp    %eax,%edx
8010081b:	0f 84 db 00 00 00    	je     801008fc <consoleintr+0x151>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100821:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100826:	83 e8 01             	sub    $0x1,%eax
80100829:	83 e0 7f             	and    $0x7f,%eax
8010082c:	0f b6 80 f4 dd 10 80 	movzbl -0x7fef220c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100833:	3c 0a                	cmp    $0xa,%al
80100835:	75 bb                	jne    801007f2 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100837:	e9 c4 00 00 00       	jmp    80100900 <consoleintr+0x155>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083c:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
80100842:	a1 78 de 10 80       	mov    0x8010de78,%eax
80100847:	39 c2                	cmp    %eax,%edx
80100849:	0f 84 b0 00 00 00    	je     801008ff <consoleintr+0x154>
        input.e--;
8010084f:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100854:	83 e8 01             	sub    $0x1,%eax
80100857:	a3 7c de 10 80       	mov    %eax,0x8010de7c
        consputc(BACKSPACE);
8010085c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100863:	e8 e6 fe ff ff       	call   8010074e <consputc>
      }
      break;
80100868:	e9 93 00 00 00       	jmp    80100900 <consoleintr+0x155>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100871:	0f 84 89 00 00 00    	je     80100900 <consoleintr+0x155>
80100877:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
8010087d:	a1 74 de 10 80       	mov    0x8010de74,%eax
80100882:	89 d1                	mov    %edx,%ecx
80100884:	29 c1                	sub    %eax,%ecx
80100886:	89 c8                	mov    %ecx,%eax
80100888:	83 f8 7f             	cmp    $0x7f,%eax
8010088b:	77 73                	ja     80100900 <consoleintr+0x155>
        c = (c == '\r') ? '\n' : c;
8010088d:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
80100891:	74 05                	je     80100898 <consoleintr+0xed>
80100893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100896:	eb 05                	jmp    8010089d <consoleintr+0xf2>
80100898:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008a0:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008a5:	89 c1                	mov    %eax,%ecx
801008a7:	83 e1 7f             	and    $0x7f,%ecx
801008aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008ad:	88 91 f4 dd 10 80    	mov    %dl,-0x7fef220c(%ecx)
801008b3:	83 c0 01             	add    $0x1,%eax
801008b6:	a3 7c de 10 80       	mov    %eax,0x8010de7c
        consputc(c);
801008bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008be:	89 04 24             	mov    %eax,(%esp)
801008c1:	e8 88 fe ff ff       	call   8010074e <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c6:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008ca:	74 18                	je     801008e4 <consoleintr+0x139>
801008cc:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008d0:	74 12                	je     801008e4 <consoleintr+0x139>
801008d2:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008d7:	8b 15 74 de 10 80    	mov    0x8010de74,%edx
801008dd:	83 ea 80             	sub    $0xffffff80,%edx
801008e0:	39 d0                	cmp    %edx,%eax
801008e2:	75 1c                	jne    80100900 <consoleintr+0x155>
          input.w = input.e;
801008e4:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008e9:	a3 78 de 10 80       	mov    %eax,0x8010de78
          wakeup(&input.r);
801008ee:	c7 04 24 74 de 10 80 	movl   $0x8010de74,(%esp)
801008f5:	e8 57 46 00 00       	call   80104f51 <wakeup>
801008fa:	eb 04                	jmp    80100900 <consoleintr+0x155>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008fc:	90                   	nop
801008fd:	eb 01                	jmp    80100900 <consoleintr+0x155>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008ff:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100900:	8b 45 08             	mov    0x8(%ebp),%eax
80100903:	ff d0                	call   *%eax
80100905:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010090c:	0f 89 b0 fe ff ff    	jns    801007c2 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100912:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100919:	e8 c6 48 00 00       	call   801051e4 <release>
}
8010091e:	c9                   	leave  
8010091f:	c3                   	ret    

80100920 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100920:	55                   	push   %ebp
80100921:	89 e5                	mov    %esp,%ebp
80100923:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100926:	8b 45 08             	mov    0x8(%ebp),%eax
80100929:	89 04 24             	mov    %eax,(%esp)
8010092c:	e8 9b 10 00 00       	call   801019cc <iunlock>
  target = n;
80100931:	8b 45 10             	mov    0x10(%ebp),%eax
80100934:	89 45 f0             	mov    %eax,-0x10(%ebp)
  acquire(&input.lock);
80100937:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
8010093e:	e8 40 48 00 00       	call   80105183 <acquire>
  while(n > 0){
80100943:	e9 a8 00 00 00       	jmp    801009f0 <consoleread+0xd0>
    while(input.r == input.w){
      if(proc->killed){
80100948:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094e:	8b 40 24             	mov    0x24(%eax),%eax
80100951:	85 c0                	test   %eax,%eax
80100953:	74 21                	je     80100976 <consoleread+0x56>
        release(&input.lock);
80100955:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
8010095c:	e8 83 48 00 00       	call   801051e4 <release>
        ilock(ip);
80100961:	8b 45 08             	mov    0x8(%ebp),%eax
80100964:	89 04 24             	mov    %eax,(%esp)
80100967:	e8 0f 0f 00 00       	call   8010187b <ilock>
        return -1;
8010096c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100971:	e9 a9 00 00 00       	jmp    80100a1f <consoleread+0xff>
      }
      sleep(&input.r, &input.lock);
80100976:	c7 44 24 04 c0 dd 10 	movl   $0x8010ddc0,0x4(%esp)
8010097d:	80 
8010097e:	c7 04 24 74 de 10 80 	movl   $0x8010de74,(%esp)
80100985:	e8 81 44 00 00       	call   80104e0b <sleep>
8010098a:	eb 01                	jmp    8010098d <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
8010098c:	90                   	nop
8010098d:	8b 15 74 de 10 80    	mov    0x8010de74,%edx
80100993:	a1 78 de 10 80       	mov    0x8010de78,%eax
80100998:	39 c2                	cmp    %eax,%edx
8010099a:	74 ac                	je     80100948 <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
8010099c:	a1 74 de 10 80       	mov    0x8010de74,%eax
801009a1:	89 c2                	mov    %eax,%edx
801009a3:	83 e2 7f             	and    $0x7f,%edx
801009a6:	0f b6 92 f4 dd 10 80 	movzbl -0x7fef220c(%edx),%edx
801009ad:	0f be d2             	movsbl %dl,%edx
801009b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
801009b3:	83 c0 01             	add    $0x1,%eax
801009b6:	a3 74 de 10 80       	mov    %eax,0x8010de74
    if(c == C('D')){  // EOF
801009bb:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801009bf:	75 17                	jne    801009d8 <consoleread+0xb8>
      if(n < target){
801009c1:	8b 45 10             	mov    0x10(%ebp),%eax
801009c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801009c7:	73 2f                	jae    801009f8 <consoleread+0xd8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c9:	a1 74 de 10 80       	mov    0x8010de74,%eax
801009ce:	83 e8 01             	sub    $0x1,%eax
801009d1:	a3 74 de 10 80       	mov    %eax,0x8010de74
      }
      break;
801009d6:	eb 24                	jmp    801009fc <consoleread+0xdc>
    }
    *dst++ = c;
801009d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801009db:	89 c2                	mov    %eax,%edx
801009dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801009e0:	88 10                	mov    %dl,(%eax)
801009e2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
801009e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009ea:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801009ee:	74 0b                	je     801009fb <consoleread+0xdb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f4:	7f 96                	jg     8010098c <consoleread+0x6c>
801009f6:	eb 04                	jmp    801009fc <consoleread+0xdc>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
801009f8:	90                   	nop
801009f9:	eb 01                	jmp    801009fc <consoleread+0xdc>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
801009fb:	90                   	nop
  }
  release(&input.lock);
801009fc:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100a03:	e8 dc 47 00 00       	call   801051e4 <release>
  ilock(ip);
80100a08:	8b 45 08             	mov    0x8(%ebp),%eax
80100a0b:	89 04 24             	mov    %eax,(%esp)
80100a0e:	e8 68 0e 00 00       	call   8010187b <ilock>

  return target - n;
80100a13:	8b 45 10             	mov    0x10(%ebp),%eax
80100a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a19:	89 d1                	mov    %edx,%ecx
80100a1b:	29 c1                	sub    %eax,%ecx
80100a1d:	89 c8                	mov    %ecx,%eax
}
80100a1f:	c9                   	leave  
80100a20:	c3                   	ret    

80100a21 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a21:	55                   	push   %ebp
80100a22:	89 e5                	mov    %esp,%ebp
80100a24:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a27:	8b 45 08             	mov    0x8(%ebp),%eax
80100a2a:	89 04 24             	mov    %eax,(%esp)
80100a2d:	e8 9a 0f 00 00       	call   801019cc <iunlock>
  acquire(&cons.lock);
80100a32:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a39:	e8 45 47 00 00       	call   80105183 <acquire>
  for(i = 0; i < n; i++)
80100a3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a45:	eb 1d                	jmp    80100a64 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a4a:	03 45 0c             	add    0xc(%ebp),%eax
80100a4d:	0f b6 00             	movzbl (%eax),%eax
80100a50:	0f be c0             	movsbl %al,%eax
80100a53:	25 ff 00 00 00       	and    $0xff,%eax
80100a58:	89 04 24             	mov    %eax,(%esp)
80100a5b:	e8 ee fc ff ff       	call   8010074e <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a60:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a67:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a6a:	7c db                	jl     80100a47 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a6c:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a73:	e8 6c 47 00 00       	call   801051e4 <release>
  ilock(ip);
80100a78:	8b 45 08             	mov    0x8(%ebp),%eax
80100a7b:	89 04 24             	mov    %eax,(%esp)
80100a7e:	e8 f8 0d 00 00       	call   8010187b <ilock>

  return n;
80100a83:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a86:	c9                   	leave  
80100a87:	c3                   	ret    

80100a88 <consoleinit>:

void
consoleinit(void)
{
80100a88:	55                   	push   %ebp
80100a89:	89 e5                	mov    %esp,%ebp
80100a8b:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a8e:	c7 44 24 04 77 88 10 	movl   $0x80108877,0x4(%esp)
80100a95:	80 
80100a96:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a9d:	e8 c0 46 00 00       	call   80105162 <initlock>
  initlock(&input.lock, "input");
80100aa2:	c7 44 24 04 7f 88 10 	movl   $0x8010887f,0x4(%esp)
80100aa9:	80 
80100aaa:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100ab1:	e8 ac 46 00 00       	call   80105162 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ab6:	c7 05 2c e8 10 80 21 	movl   $0x80100a21,0x8010e82c
80100abd:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ac0:	c7 05 28 e8 10 80 20 	movl   $0x80100920,0x8010e828
80100ac7:	09 10 80 
  cons.locking = 1;
80100aca:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100ad1:	00 00 00 

  picenable(IRQ_KBD);
80100ad4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100adb:	e8 ad 2f 00 00       	call   80103a8d <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ae0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae7:	00 
80100ae8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aef:	e8 8a 1e 00 00       	call   8010297e <ioapicenable>
}
80100af4:	c9                   	leave  
80100af5:	c3                   	ret    
	...

80100af8 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100af8:	55                   	push   %ebp
80100af9:	89 e5                	mov    %esp,%ebp
80100afb:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b01:	8b 45 08             	mov    0x8(%ebp),%eax
80100b04:	89 04 24             	mov    %eax,(%esp)
80100b07:	e8 17 19 00 00       	call   80102423 <namei>
80100b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100b0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100b13:	75 0a                	jne    80100b1f <exec+0x27>
    return -1;
80100b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1a:	e9 e4 03 00 00       	jmp    80100f03 <exec+0x40b>
  ilock(ip);
80100b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b22:	89 04 24             	mov    %eax,(%esp)
80100b25:	e8 51 0d 00 00       	call   8010187b <ilock>
  pgdir = 0;
80100b2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b31:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b37:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b3e:	00 
80100b3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b46:	00 
80100b47:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b4e:	89 04 24             	mov    %eax,(%esp)
80100b51:	e8 1e 12 00 00       	call   80101d74 <readi>
80100b56:	83 f8 33             	cmp    $0x33,%eax
80100b59:	0f 86 5e 03 00 00    	jbe    80100ebd <exec+0x3c5>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b5f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b65:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6a:	0f 85 50 03 00 00    	jne    80100ec0 <exec+0x3c8>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b70:	e8 4c 74 00 00       	call   80107fc1 <setupkvm>
80100b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100b78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100b7c:	0f 84 41 03 00 00    	je     80100ec3 <exec+0x3cb>
    goto bad;

  // Load program into memory.
  sz = PGSIZE - 1;
80100b82:	c7 45 e4 ff 0f 00 00 	movl   $0xfff,-0x1c(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b89:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80100b90:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b96:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100b99:	e9 ca 00 00 00       	jmp    80100c68 <exec+0x170>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ba1:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100ba7:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bae:	00 
80100baf:	89 54 24 08          	mov    %edx,0x8(%esp)
80100bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100bba:	89 04 24             	mov    %eax,(%esp)
80100bbd:	e8 b2 11 00 00       	call   80101d74 <readi>
80100bc2:	83 f8 20             	cmp    $0x20,%eax
80100bc5:	0f 85 fb 02 00 00    	jne    80100ec6 <exec+0x3ce>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bcb:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bd1:	83 f8 01             	cmp    $0x1,%eax
80100bd4:	0f 85 80 00 00 00    	jne    80100c5a <exec+0x162>
      continue;
    if(ph.memsz < ph.filesz)
80100bda:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100be0:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100be6:	39 c2                	cmp    %eax,%edx
80100be8:	0f 82 db 02 00 00    	jb     80100ec9 <exec+0x3d1>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bee:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bf4:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100bfa:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100bfd:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c04:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100c0b:	89 04 24             	mov    %eax,(%esp)
80100c0e:	e8 82 77 00 00       	call   80108395 <allocuvm>
80100c13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100c16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100c1a:	0f 84 ac 02 00 00    	je     80100ecc <exec+0x3d4>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c20:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c26:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c2c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c32:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c36:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80100c3d:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c41:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100c48:	89 04 24             	mov    %eax,(%esp)
80100c4b:	e8 55 76 00 00       	call   801082a5 <loaduvm>
80100c50:	85 c0                	test   %eax,%eax
80100c52:	0f 88 77 02 00 00    	js     80100ecf <exec+0x3d7>
80100c58:	eb 01                	jmp    80100c5b <exec+0x163>
  sz = PGSIZE - 1;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c5a:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = PGSIZE - 1;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c5b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
80100c5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100c62:	83 c0 20             	add    $0x20,%eax
80100c65:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100c68:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c6f:	0f b7 c0             	movzwl %ax,%eax
80100c72:	3b 45 d8             	cmp    -0x28(%ebp),%eax
80100c75:	0f 8f 23 ff ff ff    	jg     80100b9e <exec+0xa6>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100c7e:	89 04 24             	mov    %eax,(%esp)
80100c81:	e8 7c 0e 00 00       	call   80101b02 <iunlockput>
  ip = 0;
80100c86:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c90:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ca0:	05 00 20 00 00       	add    $0x2000,%eax
80100ca5:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cac:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100cb3:	89 04 24             	mov    %eax,(%esp)
80100cb6:	e8 da 76 00 00       	call   80108395 <allocuvm>
80100cbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100cbe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100cc2:	0f 84 0a 02 00 00    	je     80100ed2 <exec+0x3da>
    goto bad;
  proc->pstack = (uint *)sz;
80100cc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100cd1:	89 50 7c             	mov    %edx,0x7c(%eax)

  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cd7:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100ce3:	89 04 24             	mov    %eax,(%esp)
80100ce6:	e8 ce 78 00 00       	call   801085b9 <clearpteu>

  sp = sz;
80100ceb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cee:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80100cf8:	e9 81 00 00 00       	jmp    80100d7e <exec+0x286>
    if(argc >= MAXARG)
80100cfd:	83 7d e0 1f          	cmpl   $0x1f,-0x20(%ebp)
80100d01:	0f 87 ce 01 00 00    	ja     80100ed5 <exec+0x3dd>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0a:	c1 e0 02             	shl    $0x2,%eax
80100d0d:	03 45 0c             	add    0xc(%ebp),%eax
80100d10:	8b 00                	mov    (%eax),%eax
80100d12:	89 04 24             	mov    %eax,(%esp)
80100d15:	e8 39 49 00 00       	call   80105653 <strlen>
80100d1a:	f7 d0                	not    %eax
80100d1c:	03 45 e8             	add    -0x18(%ebp),%eax
80100d1f:	83 e0 fc             	and    $0xfffffffc,%eax
80100d22:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d25:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d28:	c1 e0 02             	shl    $0x2,%eax
80100d2b:	03 45 0c             	add    0xc(%ebp),%eax
80100d2e:	8b 00                	mov    (%eax),%eax
80100d30:	89 04 24             	mov    %eax,(%esp)
80100d33:	e8 1b 49 00 00       	call   80105653 <strlen>
80100d38:	83 c0 01             	add    $0x1,%eax
80100d3b:	89 c2                	mov    %eax,%edx
80100d3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d40:	c1 e0 02             	shl    $0x2,%eax
80100d43:	03 45 0c             	add    0xc(%ebp),%eax
80100d46:	8b 00                	mov    (%eax),%eax
80100d48:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d4c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d50:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d53:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100d5a:	89 04 24             	mov    %eax,(%esp)
80100d5d:	e8 1c 7a 00 00       	call   8010877e <copyout>
80100d62:	85 c0                	test   %eax,%eax
80100d64:	0f 88 6e 01 00 00    	js     80100ed8 <exec+0x3e0>
      goto bad;
    ustack[3+argc] = sp;
80100d6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d6d:	8d 50 03             	lea    0x3(%eax),%edx
80100d70:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d73:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d7a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80100d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d81:	c1 e0 02             	shl    $0x2,%eax
80100d84:	03 45 0c             	add    0xc(%ebp),%eax
80100d87:	8b 00                	mov    (%eax),%eax
80100d89:	85 c0                	test   %eax,%eax
80100d8b:	0f 85 6c ff ff ff    	jne    80100cfd <exec+0x205>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100d91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d94:	83 c0 03             	add    $0x3,%eax
80100d97:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100d9e:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100da2:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100da9:	ff ff ff 
  ustack[1] = argc;
80100dac:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100daf:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100db5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100db8:	83 c0 01             	add    $0x1,%eax
80100dbb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100dc5:	29 d0                	sub    %edx,%eax
80100dc7:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dd0:	83 c0 04             	add    $0x4,%eax
80100dd3:	c1 e0 02             	shl    $0x2,%eax
80100dd6:	29 45 e8             	sub    %eax,-0x18(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ddc:	83 c0 04             	add    $0x4,%eax
80100ddf:	c1 e0 02             	shl    $0x2,%eax
80100de2:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100de6:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100dec:	89 44 24 08          	mov    %eax,0x8(%esp)
80100df0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100df3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100dfa:	89 04 24             	mov    %eax,(%esp)
80100dfd:	e8 7c 79 00 00       	call   8010877e <copyout>
80100e02:	85 c0                	test   %eax,%eax
80100e04:	0f 88 d1 00 00 00    	js     80100edb <exec+0x3e3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e0a:	8b 45 08             	mov    0x8(%ebp),%eax
80100e0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100e10:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e13:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100e16:	eb 17                	jmp    80100e2f <exec+0x337>
    if(*s == '/')
80100e18:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e1b:	0f b6 00             	movzbl (%eax),%eax
80100e1e:	3c 2f                	cmp    $0x2f,%al
80100e20:	75 09                	jne    80100e2b <exec+0x333>
      last = s+1;
80100e22:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e25:	83 c0 01             	add    $0x1,%eax
80100e28:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e2b:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
80100e2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e32:	0f b6 00             	movzbl (%eax),%eax
80100e35:	84 c0                	test   %al,%al
80100e37:	75 df                	jne    80100e18 <exec+0x320>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e3f:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e42:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e49:	00 
80100e4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e51:	89 14 24             	mov    %edx,(%esp)
80100e54:	e8 ac 47 00 00       	call   80105605 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5f:	8b 40 04             	mov    0x4(%eax),%eax
80100e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->pgdir = pgdir;
80100e65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100e6e:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e71:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100e7a:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e82:	8b 40 18             	mov    0x18(%eax),%eax
80100e85:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100e8b:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100e8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e94:	8b 40 18             	mov    0x18(%eax),%eax
80100e97:	8b 55 e8             	mov    -0x18(%ebp),%edx
80100e9a:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100e9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea3:	89 04 24             	mov    %eax,(%esp)
80100ea6:	e8 08 72 00 00       	call   801080b3 <switchuvm>
  freevm(oldpgdir);
80100eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eae:	89 04 24             	mov    %eax,(%esp)
80100eb1:	e8 75 76 00 00       	call   8010852b <freevm>
  return 0;
80100eb6:	b8 00 00 00 00       	mov    $0x0,%eax
80100ebb:	eb 46                	jmp    80100f03 <exec+0x40b>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100ebd:	90                   	nop
80100ebe:	eb 1c                	jmp    80100edc <exec+0x3e4>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100ec0:	90                   	nop
80100ec1:	eb 19                	jmp    80100edc <exec+0x3e4>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100ec3:	90                   	nop
80100ec4:	eb 16                	jmp    80100edc <exec+0x3e4>

  // Load program into memory.
  sz = PGSIZE - 1;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100ec6:	90                   	nop
80100ec7:	eb 13                	jmp    80100edc <exec+0x3e4>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ec9:	90                   	nop
80100eca:	eb 10                	jmp    80100edc <exec+0x3e4>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ecc:	90                   	nop
80100ecd:	eb 0d                	jmp    80100edc <exec+0x3e4>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100ecf:	90                   	nop
80100ed0:	eb 0a                	jmp    80100edc <exec+0x3e4>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100ed2:	90                   	nop
80100ed3:	eb 07                	jmp    80100edc <exec+0x3e4>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100ed5:	90                   	nop
80100ed6:	eb 04                	jmp    80100edc <exec+0x3e4>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100ed8:	90                   	nop
80100ed9:	eb 01                	jmp    80100edc <exec+0x3e4>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100edb:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100edc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100ee0:	74 0b                	je     80100eed <exec+0x3f5>
    freevm(pgdir);
80100ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100ee5:	89 04 24             	mov    %eax,(%esp)
80100ee8:	e8 3e 76 00 00       	call   8010852b <freevm>
  if(ip)
80100eed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100ef1:	74 0b                	je     80100efe <exec+0x406>
    iunlockput(ip);
80100ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100ef6:	89 04 24             	mov    %eax,(%esp)
80100ef9:	e8 04 0c 00 00       	call   80101b02 <iunlockput>
  return -1;
80100efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f03:	c9                   	leave  
80100f04:	c3                   	ret    
80100f05:	00 00                	add    %al,(%eax)
	...

80100f08 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f08:	55                   	push   %ebp
80100f09:	89 e5                	mov    %esp,%ebp
80100f0b:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f0e:	c7 44 24 04 85 88 10 	movl   $0x80108885,0x4(%esp)
80100f15:	80 
80100f16:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f1d:	e8 40 42 00 00       	call   80105162 <initlock>
}
80100f22:	c9                   	leave  
80100f23:	c3                   	ret    

80100f24 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f24:	55                   	push   %ebp
80100f25:	89 e5                	mov    %esp,%ebp
80100f27:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f2a:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f31:	e8 4d 42 00 00       	call   80105183 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f36:	c7 45 f4 b4 de 10 80 	movl   $0x8010deb4,-0xc(%ebp)
80100f3d:	eb 29                	jmp    80100f68 <filealloc+0x44>
    if(f->ref == 0){
80100f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f42:	8b 40 04             	mov    0x4(%eax),%eax
80100f45:	85 c0                	test   %eax,%eax
80100f47:	75 1b                	jne    80100f64 <filealloc+0x40>
      f->ref = 1;
80100f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f4c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f53:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f5a:	e8 85 42 00 00       	call   801051e4 <release>
      return f;
80100f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f62:	eb 1f                	jmp    80100f83 <filealloc+0x5f>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f64:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f68:	b8 14 e8 10 80       	mov    $0x8010e814,%eax
80100f6d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100f70:	72 cd                	jb     80100f3f <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f72:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f79:	e8 66 42 00 00       	call   801051e4 <release>
  return 0;
80100f7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f83:	c9                   	leave  
80100f84:	c3                   	ret    

80100f85 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f85:	55                   	push   %ebp
80100f86:	89 e5                	mov    %esp,%ebp
80100f88:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f8b:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f92:	e8 ec 41 00 00       	call   80105183 <acquire>
  if(f->ref < 1)
80100f97:	8b 45 08             	mov    0x8(%ebp),%eax
80100f9a:	8b 40 04             	mov    0x4(%eax),%eax
80100f9d:	85 c0                	test   %eax,%eax
80100f9f:	7f 0c                	jg     80100fad <filedup+0x28>
    panic("filedup");
80100fa1:	c7 04 24 8c 88 10 80 	movl   $0x8010888c,(%esp)
80100fa8:	e8 8d f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fad:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb0:	8b 40 04             	mov    0x4(%eax),%eax
80100fb3:	8d 50 01             	lea    0x1(%eax),%edx
80100fb6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb9:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fbc:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100fc3:	e8 1c 42 00 00       	call   801051e4 <release>
  return f;
80100fc8:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fcb:	c9                   	leave  
80100fcc:	c3                   	ret    

80100fcd <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fcd:	55                   	push   %ebp
80100fce:	89 e5                	mov    %esp,%ebp
80100fd0:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fd3:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100fda:	e8 a4 41 00 00       	call   80105183 <acquire>
  if(f->ref < 1)
80100fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe2:	8b 40 04             	mov    0x4(%eax),%eax
80100fe5:	85 c0                	test   %eax,%eax
80100fe7:	7f 0c                	jg     80100ff5 <fileclose+0x28>
    panic("fileclose");
80100fe9:	c7 04 24 94 88 10 80 	movl   $0x80108894,(%esp)
80100ff0:	e8 45 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80100ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff8:	8b 40 04             	mov    0x4(%eax),%eax
80100ffb:	8d 50 ff             	lea    -0x1(%eax),%edx
80100ffe:	8b 45 08             	mov    0x8(%ebp),%eax
80101001:	89 50 04             	mov    %edx,0x4(%eax)
80101004:	8b 45 08             	mov    0x8(%ebp),%eax
80101007:	8b 40 04             	mov    0x4(%eax),%eax
8010100a:	85 c0                	test   %eax,%eax
8010100c:	7e 11                	jle    8010101f <fileclose+0x52>
    release(&ftable.lock);
8010100e:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80101015:	e8 ca 41 00 00       	call   801051e4 <release>
    return;
8010101a:	e9 82 00 00 00       	jmp    801010a1 <fileclose+0xd4>
  }
  ff = *f;
8010101f:	8b 45 08             	mov    0x8(%ebp),%eax
80101022:	8b 10                	mov    (%eax),%edx
80101024:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101027:	8b 50 04             	mov    0x4(%eax),%edx
8010102a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010102d:	8b 50 08             	mov    0x8(%eax),%edx
80101030:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101033:	8b 50 0c             	mov    0xc(%eax),%edx
80101036:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101039:	8b 50 10             	mov    0x10(%eax),%edx
8010103c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010103f:	8b 40 14             	mov    0x14(%eax),%eax
80101042:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101045:	8b 45 08             	mov    0x8(%ebp),%eax
80101048:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010104f:	8b 45 08             	mov    0x8(%ebp),%eax
80101052:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101058:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
8010105f:	e8 80 41 00 00       	call   801051e4 <release>
  
  if(ff.type == FD_PIPE)
80101064:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101067:	83 f8 01             	cmp    $0x1,%eax
8010106a:	75 18                	jne    80101084 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
8010106c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101070:	0f be d0             	movsbl %al,%edx
80101073:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101076:	89 54 24 04          	mov    %edx,0x4(%esp)
8010107a:	89 04 24             	mov    %eax,(%esp)
8010107d:	e8 c5 2c 00 00       	call   80103d47 <pipeclose>
80101082:	eb 1d                	jmp    801010a1 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101084:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101087:	83 f8 02             	cmp    $0x2,%eax
8010108a:	75 15                	jne    801010a1 <fileclose+0xd4>
    begin_trans();
8010108c:	e8 81 21 00 00       	call   80103212 <begin_trans>
    iput(ff.ip);
80101091:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101094:	89 04 24             	mov    %eax,(%esp)
80101097:	e8 95 09 00 00       	call   80101a31 <iput>
    commit_trans();
8010109c:	e8 ba 21 00 00       	call   8010325b <commit_trans>
  }
}
801010a1:	c9                   	leave  
801010a2:	c3                   	ret    

801010a3 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010a3:	55                   	push   %ebp
801010a4:	89 e5                	mov    %esp,%ebp
801010a6:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010a9:	8b 45 08             	mov    0x8(%ebp),%eax
801010ac:	8b 00                	mov    (%eax),%eax
801010ae:	83 f8 02             	cmp    $0x2,%eax
801010b1:	75 38                	jne    801010eb <filestat+0x48>
    ilock(f->ip);
801010b3:	8b 45 08             	mov    0x8(%ebp),%eax
801010b6:	8b 40 10             	mov    0x10(%eax),%eax
801010b9:	89 04 24             	mov    %eax,(%esp)
801010bc:	e8 ba 07 00 00       	call   8010187b <ilock>
    stati(f->ip, st);
801010c1:	8b 45 08             	mov    0x8(%ebp),%eax
801010c4:	8b 40 10             	mov    0x10(%eax),%eax
801010c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801010ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801010ce:	89 04 24             	mov    %eax,(%esp)
801010d1:	e8 59 0c 00 00       	call   80101d2f <stati>
    iunlock(f->ip);
801010d6:	8b 45 08             	mov    0x8(%ebp),%eax
801010d9:	8b 40 10             	mov    0x10(%eax),%eax
801010dc:	89 04 24             	mov    %eax,(%esp)
801010df:	e8 e8 08 00 00       	call   801019cc <iunlock>
    return 0;
801010e4:	b8 00 00 00 00       	mov    $0x0,%eax
801010e9:	eb 05                	jmp    801010f0 <filestat+0x4d>
  }
  return -1;
801010eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010f0:	c9                   	leave  
801010f1:	c3                   	ret    

801010f2 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010f2:	55                   	push   %ebp
801010f3:	89 e5                	mov    %esp,%ebp
801010f5:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010f8:	8b 45 08             	mov    0x8(%ebp),%eax
801010fb:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801010ff:	84 c0                	test   %al,%al
80101101:	75 0a                	jne    8010110d <fileread+0x1b>
    return -1;
80101103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101108:	e9 9f 00 00 00       	jmp    801011ac <fileread+0xba>
  if(f->type == FD_PIPE)
8010110d:	8b 45 08             	mov    0x8(%ebp),%eax
80101110:	8b 00                	mov    (%eax),%eax
80101112:	83 f8 01             	cmp    $0x1,%eax
80101115:	75 1e                	jne    80101135 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101117:	8b 45 08             	mov    0x8(%ebp),%eax
8010111a:	8b 40 0c             	mov    0xc(%eax),%eax
8010111d:	8b 55 10             	mov    0x10(%ebp),%edx
80101120:	89 54 24 08          	mov    %edx,0x8(%esp)
80101124:	8b 55 0c             	mov    0xc(%ebp),%edx
80101127:	89 54 24 04          	mov    %edx,0x4(%esp)
8010112b:	89 04 24             	mov    %eax,(%esp)
8010112e:	e8 96 2d 00 00       	call   80103ec9 <piperead>
80101133:	eb 77                	jmp    801011ac <fileread+0xba>
  if(f->type == FD_INODE){
80101135:	8b 45 08             	mov    0x8(%ebp),%eax
80101138:	8b 00                	mov    (%eax),%eax
8010113a:	83 f8 02             	cmp    $0x2,%eax
8010113d:	75 61                	jne    801011a0 <fileread+0xae>
    ilock(f->ip);
8010113f:	8b 45 08             	mov    0x8(%ebp),%eax
80101142:	8b 40 10             	mov    0x10(%eax),%eax
80101145:	89 04 24             	mov    %eax,(%esp)
80101148:	e8 2e 07 00 00       	call   8010187b <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010114d:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101150:	8b 45 08             	mov    0x8(%ebp),%eax
80101153:	8b 50 14             	mov    0x14(%eax),%edx
80101156:	8b 45 08             	mov    0x8(%ebp),%eax
80101159:	8b 40 10             	mov    0x10(%eax),%eax
8010115c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101160:	89 54 24 08          	mov    %edx,0x8(%esp)
80101164:	8b 55 0c             	mov    0xc(%ebp),%edx
80101167:	89 54 24 04          	mov    %edx,0x4(%esp)
8010116b:	89 04 24             	mov    %eax,(%esp)
8010116e:	e8 01 0c 00 00       	call   80101d74 <readi>
80101173:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101176:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010117a:	7e 11                	jle    8010118d <fileread+0x9b>
      f->off += r;
8010117c:	8b 45 08             	mov    0x8(%ebp),%eax
8010117f:	8b 50 14             	mov    0x14(%eax),%edx
80101182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101185:	01 c2                	add    %eax,%edx
80101187:	8b 45 08             	mov    0x8(%ebp),%eax
8010118a:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010118d:	8b 45 08             	mov    0x8(%ebp),%eax
80101190:	8b 40 10             	mov    0x10(%eax),%eax
80101193:	89 04 24             	mov    %eax,(%esp)
80101196:	e8 31 08 00 00       	call   801019cc <iunlock>
    return r;
8010119b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010119e:	eb 0c                	jmp    801011ac <fileread+0xba>
  }
  panic("fileread");
801011a0:	c7 04 24 9e 88 10 80 	movl   $0x8010889e,(%esp)
801011a7:	e8 8e f3 ff ff       	call   8010053a <panic>
}
801011ac:	c9                   	leave  
801011ad:	c3                   	ret    

801011ae <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011ae:	55                   	push   %ebp
801011af:	89 e5                	mov    %esp,%ebp
801011b1:	53                   	push   %ebx
801011b2:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011b5:	8b 45 08             	mov    0x8(%ebp),%eax
801011b8:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011bc:	84 c0                	test   %al,%al
801011be:	75 0a                	jne    801011ca <filewrite+0x1c>
    return -1;
801011c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011c5:	e9 23 01 00 00       	jmp    801012ed <filewrite+0x13f>
  if(f->type == FD_PIPE)
801011ca:	8b 45 08             	mov    0x8(%ebp),%eax
801011cd:	8b 00                	mov    (%eax),%eax
801011cf:	83 f8 01             	cmp    $0x1,%eax
801011d2:	75 21                	jne    801011f5 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011d4:	8b 45 08             	mov    0x8(%ebp),%eax
801011d7:	8b 40 0c             	mov    0xc(%eax),%eax
801011da:	8b 55 10             	mov    0x10(%ebp),%edx
801011dd:	89 54 24 08          	mov    %edx,0x8(%esp)
801011e1:	8b 55 0c             	mov    0xc(%ebp),%edx
801011e4:	89 54 24 04          	mov    %edx,0x4(%esp)
801011e8:	89 04 24             	mov    %eax,(%esp)
801011eb:	e8 e9 2b 00 00       	call   80103dd9 <pipewrite>
801011f0:	e9 f8 00 00 00       	jmp    801012ed <filewrite+0x13f>
  if(f->type == FD_INODE){
801011f5:	8b 45 08             	mov    0x8(%ebp),%eax
801011f8:	8b 00                	mov    (%eax),%eax
801011fa:	83 f8 02             	cmp    $0x2,%eax
801011fd:	0f 85 de 00 00 00    	jne    801012e1 <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101203:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
8010120a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(i < n){
80101211:	e9 a8 00 00 00       	jmp    801012be <filewrite+0x110>
      int n1 = n - i;
80101216:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101219:	8b 55 10             	mov    0x10(%ebp),%edx
8010121c:	89 d1                	mov    %edx,%ecx
8010121e:	29 c1                	sub    %eax,%ecx
80101220:	89 c8                	mov    %ecx,%eax
80101222:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(n1 > max)
80101225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101228:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010122b:	7e 06                	jle    80101233 <filewrite+0x85>
        n1 = max;
8010122d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101230:	89 45 f4             	mov    %eax,-0xc(%ebp)

      begin_trans();
80101233:	e8 da 1f 00 00       	call   80103212 <begin_trans>
      ilock(f->ip);
80101238:	8b 45 08             	mov    0x8(%ebp),%eax
8010123b:	8b 40 10             	mov    0x10(%eax),%eax
8010123e:	89 04 24             	mov    %eax,(%esp)
80101241:	e8 35 06 00 00       	call   8010187b <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101246:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 48 14             	mov    0x14(%eax),%ecx
8010124f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101252:	89 c2                	mov    %eax,%edx
80101254:	03 55 0c             	add    0xc(%ebp),%edx
80101257:	8b 45 08             	mov    0x8(%ebp),%eax
8010125a:	8b 40 10             	mov    0x10(%eax),%eax
8010125d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80101261:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101265:	89 54 24 04          	mov    %edx,0x4(%esp)
80101269:	89 04 24             	mov    %eax,(%esp)
8010126c:	e8 6f 0c 00 00       	call   80101ee0 <writei>
80101271:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101274:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101278:	7e 11                	jle    8010128b <filewrite+0xdd>
        f->off += r;
8010127a:	8b 45 08             	mov    0x8(%ebp),%eax
8010127d:	8b 50 14             	mov    0x14(%eax),%edx
80101280:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101283:	01 c2                	add    %eax,%edx
80101285:	8b 45 08             	mov    0x8(%ebp),%eax
80101288:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010128b:	8b 45 08             	mov    0x8(%ebp),%eax
8010128e:	8b 40 10             	mov    0x10(%eax),%eax
80101291:	89 04 24             	mov    %eax,(%esp)
80101294:	e8 33 07 00 00       	call   801019cc <iunlock>
      commit_trans();
80101299:	e8 bd 1f 00 00       	call   8010325b <commit_trans>

      if(r < 0)
8010129e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012a2:	78 28                	js     801012cc <filewrite+0x11e>
        break;
      if(r != n1)
801012a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012a7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801012aa:	74 0c                	je     801012b8 <filewrite+0x10a>
        panic("short filewrite");
801012ac:	c7 04 24 a7 88 10 80 	movl   $0x801088a7,(%esp)
801012b3:	e8 82 f2 ff ff       	call   8010053a <panic>
      i += r;
801012b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012bb:	01 45 f0             	add    %eax,-0x10(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012c1:	3b 45 10             	cmp    0x10(%ebp),%eax
801012c4:	0f 8c 4c ff ff ff    	jl     80101216 <filewrite+0x68>
801012ca:	eb 01                	jmp    801012cd <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
801012cc:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012d0:	3b 45 10             	cmp    0x10(%ebp),%eax
801012d3:	75 05                	jne    801012da <filewrite+0x12c>
801012d5:	8b 45 10             	mov    0x10(%ebp),%eax
801012d8:	eb 05                	jmp    801012df <filewrite+0x131>
801012da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012df:	eb 0c                	jmp    801012ed <filewrite+0x13f>
  }
  panic("filewrite");
801012e1:	c7 04 24 b7 88 10 80 	movl   $0x801088b7,(%esp)
801012e8:	e8 4d f2 ff ff       	call   8010053a <panic>
}
801012ed:	83 c4 24             	add    $0x24,%esp
801012f0:	5b                   	pop    %ebx
801012f1:	5d                   	pop    %ebp
801012f2:	c3                   	ret    
	...

801012f4 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012f4:	55                   	push   %ebp
801012f5:	89 e5                	mov    %esp,%ebp
801012f7:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012fa:	8b 45 08             	mov    0x8(%ebp),%eax
801012fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101304:	00 
80101305:	89 04 24             	mov    %eax,(%esp)
80101308:	e8 9a ee ff ff       	call   801001a7 <bread>
8010130d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101313:	83 c0 18             	add    $0x18,%eax
80101316:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010131d:	00 
8010131e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101322:	8b 45 0c             	mov    0xc(%ebp),%eax
80101325:	89 04 24             	mov    %eax,(%esp)
80101328:	e8 78 41 00 00       	call   801054a5 <memmove>
  brelse(bp);
8010132d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101330:	89 04 24             	mov    %eax,(%esp)
80101333:	e8 e0 ee ff ff       	call   80100218 <brelse>
}
80101338:	c9                   	leave  
80101339:	c3                   	ret    

8010133a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010133a:	55                   	push   %ebp
8010133b:	89 e5                	mov    %esp,%ebp
8010133d:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101340:	8b 55 0c             	mov    0xc(%ebp),%edx
80101343:	8b 45 08             	mov    0x8(%ebp),%eax
80101346:	89 54 24 04          	mov    %edx,0x4(%esp)
8010134a:	89 04 24             	mov    %eax,(%esp)
8010134d:	e8 55 ee ff ff       	call   801001a7 <bread>
80101352:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101358:	83 c0 18             	add    $0x18,%eax
8010135b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101362:	00 
80101363:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010136a:	00 
8010136b:	89 04 24             	mov    %eax,(%esp)
8010136e:	e8 5f 40 00 00       	call   801053d2 <memset>
  log_write(bp);
80101373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101376:	89 04 24             	mov    %eax,(%esp)
80101379:	e8 35 1f 00 00       	call   801032b3 <log_write>
  brelse(bp);
8010137e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101381:	89 04 24             	mov    %eax,(%esp)
80101384:	e8 8f ee ff ff       	call   80100218 <brelse>
}
80101389:	c9                   	leave  
8010138a:	c3                   	ret    

8010138b <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010138b:	55                   	push   %ebp
8010138c:	89 e5                	mov    %esp,%ebp
8010138e:	53                   	push   %ebx
8010138f:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101392:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  readsb(dev, &sb);
80101399:	8b 45 08             	mov    0x8(%ebp),%eax
8010139c:	8d 55 d8             	lea    -0x28(%ebp),%edx
8010139f:	89 54 24 04          	mov    %edx,0x4(%esp)
801013a3:	89 04 24             	mov    %eax,(%esp)
801013a6:	e8 49 ff ff ff       	call   801012f4 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
801013b2:	e9 15 01 00 00       	jmp    801014cc <balloc+0x141>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013ba:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013c0:	85 c0                	test   %eax,%eax
801013c2:	0f 48 c2             	cmovs  %edx,%eax
801013c5:	c1 f8 0c             	sar    $0xc,%eax
801013c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013cb:	c1 ea 03             	shr    $0x3,%edx
801013ce:	01 d0                	add    %edx,%eax
801013d0:	83 c0 03             	add    $0x3,%eax
801013d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801013d7:	8b 45 08             	mov    0x8(%ebp),%eax
801013da:	89 04 24             	mov    %eax,(%esp)
801013dd:	e8 c5 ed ff ff       	call   801001a7 <bread>
801013e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801013ec:	e9 aa 00 00 00       	jmp    8010149b <balloc+0x110>
      m = 1 << (bi % 8);
801013f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801013f4:	89 c2                	mov    %eax,%edx
801013f6:	c1 fa 1f             	sar    $0x1f,%edx
801013f9:	c1 ea 1d             	shr    $0x1d,%edx
801013fc:	01 d0                	add    %edx,%eax
801013fe:	83 e0 07             	and    $0x7,%eax
80101401:	29 d0                	sub    %edx,%eax
80101403:	ba 01 00 00 00       	mov    $0x1,%edx
80101408:	89 d3                	mov    %edx,%ebx
8010140a:	89 c1                	mov    %eax,%ecx
8010140c:	d3 e3                	shl    %cl,%ebx
8010140e:	89 d8                	mov    %ebx,%eax
80101410:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101413:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101416:	8d 50 07             	lea    0x7(%eax),%edx
80101419:	85 c0                	test   %eax,%eax
8010141b:	0f 48 c2             	cmovs  %edx,%eax
8010141e:	c1 f8 03             	sar    $0x3,%eax
80101421:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101424:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101429:	0f b6 c0             	movzbl %al,%eax
8010142c:	23 45 f0             	and    -0x10(%ebp),%eax
8010142f:	85 c0                	test   %eax,%eax
80101431:	75 64                	jne    80101497 <balloc+0x10c>
        bp->data[bi/8] |= m;  // Mark block in use.
80101433:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101436:	8d 50 07             	lea    0x7(%eax),%edx
80101439:	85 c0                	test   %eax,%eax
8010143b:	0f 48 c2             	cmovs  %edx,%eax
8010143e:	c1 f8 03             	sar    $0x3,%eax
80101441:	89 c2                	mov    %eax,%edx
80101443:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80101446:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
8010144b:	89 c1                	mov    %eax,%ecx
8010144d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101450:	09 c8                	or     %ecx,%eax
80101452:	89 c1                	mov    %eax,%ecx
80101454:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101457:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
        log_write(bp);
8010145b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010145e:	89 04 24             	mov    %eax,(%esp)
80101461:	e8 4d 1e 00 00       	call   801032b3 <log_write>
        brelse(bp);
80101466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101469:	89 04 24             	mov    %eax,(%esp)
8010146c:	e8 a7 ed ff ff       	call   80100218 <brelse>
        bzero(dev, b + bi);
80101471:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101474:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101477:	01 c2                	add    %eax,%edx
80101479:	8b 45 08             	mov    0x8(%ebp),%eax
8010147c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101480:	89 04 24             	mov    %eax,(%esp)
80101483:	e8 b2 fe ff ff       	call   8010133a <bzero>
        return b + bi;
80101488:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010148b:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010148e:	8d 04 02             	lea    (%edx,%eax,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
80101491:	83 c4 34             	add    $0x34,%esp
80101494:	5b                   	pop    %ebx
80101495:	5d                   	pop    %ebp
80101496:	c3                   	ret    

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101497:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010149b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
801014a2:	7f 16                	jg     801014ba <balloc+0x12f>
801014a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014aa:	8d 04 02             	lea    (%edx,%eax,1),%eax
801014ad:	89 c2                	mov    %eax,%edx
801014af:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014b2:	39 c2                	cmp    %eax,%edx
801014b4:	0f 82 37 ff ff ff    	jb     801013f1 <balloc+0x66>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014bd:	89 04 24             	mov    %eax,(%esp)
801014c0:	e8 53 ed ff ff       	call   80100218 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014c5:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
801014cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014d2:	39 c2                	cmp    %eax,%edx
801014d4:	0f 82 dd fe ff ff    	jb     801013b7 <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014da:	c7 04 24 c1 88 10 80 	movl   $0x801088c1,(%esp)
801014e1:	e8 54 f0 ff ff       	call   8010053a <panic>

801014e6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014e6:	55                   	push   %ebp
801014e7:	89 e5                	mov    %esp,%ebp
801014e9:	53                   	push   %ebx
801014ea:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014ed:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801014f4:	8b 45 08             	mov    0x8(%ebp),%eax
801014f7:	89 04 24             	mov    %eax,(%esp)
801014fa:	e8 f5 fd ff ff       	call   801012f4 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80101502:	89 c2                	mov    %eax,%edx
80101504:	c1 ea 0c             	shr    $0xc,%edx
80101507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010150a:	c1 e8 03             	shr    $0x3,%eax
8010150d:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101510:	8d 50 03             	lea    0x3(%eax),%edx
80101513:	8b 45 08             	mov    0x8(%ebp),%eax
80101516:	89 54 24 04          	mov    %edx,0x4(%esp)
8010151a:	89 04 24             	mov    %eax,(%esp)
8010151d:	e8 85 ec ff ff       	call   801001a7 <bread>
80101522:	89 45 ec             	mov    %eax,-0x14(%ebp)
  bi = b % BPB;
80101525:	8b 45 0c             	mov    0xc(%ebp),%eax
80101528:	25 ff 0f 00 00       	and    $0xfff,%eax
8010152d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101530:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101533:	89 c2                	mov    %eax,%edx
80101535:	c1 fa 1f             	sar    $0x1f,%edx
80101538:	c1 ea 1d             	shr    $0x1d,%edx
8010153b:	01 d0                	add    %edx,%eax
8010153d:	83 e0 07             	and    $0x7,%eax
80101540:	29 d0                	sub    %edx,%eax
80101542:	ba 01 00 00 00       	mov    $0x1,%edx
80101547:	89 d3                	mov    %edx,%ebx
80101549:	89 c1                	mov    %eax,%ecx
8010154b:	d3 e3                	shl    %cl,%ebx
8010154d:	89 d8                	mov    %ebx,%eax
8010154f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101552:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101555:	8d 50 07             	lea    0x7(%eax),%edx
80101558:	85 c0                	test   %eax,%eax
8010155a:	0f 48 c2             	cmovs  %edx,%eax
8010155d:	c1 f8 03             	sar    $0x3,%eax
80101560:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101563:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101568:	0f b6 c0             	movzbl %al,%eax
8010156b:	23 45 f4             	and    -0xc(%ebp),%eax
8010156e:	85 c0                	test   %eax,%eax
80101570:	75 0c                	jne    8010157e <bfree+0x98>
    panic("freeing free block");
80101572:	c7 04 24 d7 88 10 80 	movl   $0x801088d7,(%esp)
80101579:	e8 bc ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
8010157e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101581:	8d 50 07             	lea    0x7(%eax),%edx
80101584:	85 c0                	test   %eax,%eax
80101586:	0f 48 c2             	cmovs  %edx,%eax
80101589:	c1 f8 03             	sar    $0x3,%eax
8010158c:	89 c2                	mov    %eax,%edx
8010158e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101591:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
80101596:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80101599:	f7 d1                	not    %ecx
8010159b:	21 c8                	and    %ecx,%eax
8010159d:	89 c1                	mov    %eax,%ecx
8010159f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015a2:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
  log_write(bp);
801015a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015a9:	89 04 24             	mov    %eax,(%esp)
801015ac:	e8 02 1d 00 00       	call   801032b3 <log_write>
  brelse(bp);
801015b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015b4:	89 04 24             	mov    %eax,(%esp)
801015b7:	e8 5c ec ff ff       	call   80100218 <brelse>
}
801015bc:	83 c4 34             	add    $0x34,%esp
801015bf:	5b                   	pop    %ebx
801015c0:	5d                   	pop    %ebp
801015c1:	c3                   	ret    

801015c2 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015c2:	55                   	push   %ebp
801015c3:	89 e5                	mov    %esp,%ebp
801015c5:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015c8:	c7 44 24 04 ea 88 10 	movl   $0x801088ea,0x4(%esp)
801015cf:	80 
801015d0:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801015d7:	e8 86 3b 00 00       	call   80105162 <initlock>
}
801015dc:	c9                   	leave  
801015dd:	c3                   	ret    

801015de <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015de:	55                   	push   %ebp
801015df:	89 e5                	mov    %esp,%ebp
801015e1:	83 ec 48             	sub    $0x48,%esp
801015e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801015e7:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015eb:	8b 45 08             	mov    0x8(%ebp),%eax
801015ee:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015f1:	89 54 24 04          	mov    %edx,0x4(%esp)
801015f5:	89 04 24             	mov    %eax,(%esp)
801015f8:	e8 f7 fc ff ff       	call   801012f4 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
80101604:	e9 98 00 00 00       	jmp    801016a1 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
80101609:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010160c:	c1 e8 03             	shr    $0x3,%eax
8010160f:	83 c0 02             	add    $0x2,%eax
80101612:	89 44 24 04          	mov    %eax,0x4(%esp)
80101616:	8b 45 08             	mov    0x8(%ebp),%eax
80101619:	89 04 24             	mov    %eax,(%esp)
8010161c:	e8 86 eb ff ff       	call   801001a7 <bread>
80101621:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101624:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101627:	83 c0 18             	add    $0x18,%eax
8010162a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010162d:	83 e2 07             	and    $0x7,%edx
80101630:	c1 e2 06             	shl    $0x6,%edx
80101633:	01 d0                	add    %edx,%eax
80101635:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(dip->type == 0){  // a free inode
80101638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010163b:	0f b7 00             	movzwl (%eax),%eax
8010163e:	66 85 c0             	test   %ax,%ax
80101641:	75 4f                	jne    80101692 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101643:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010164a:	00 
8010164b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101652:	00 
80101653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101656:	89 04 24             	mov    %eax,(%esp)
80101659:	e8 74 3d 00 00       	call   801053d2 <memset>
      dip->type = type;
8010165e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101661:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101665:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101668:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010166b:	89 04 24             	mov    %eax,(%esp)
8010166e:	e8 40 1c 00 00       	call   801032b3 <log_write>
      brelse(bp);
80101673:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101676:	89 04 24             	mov    %eax,(%esp)
80101679:	e8 9a eb ff ff       	call   80100218 <brelse>
      return iget(dev, inum);
8010167e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101681:	89 44 24 04          	mov    %eax,0x4(%esp)
80101685:	8b 45 08             	mov    0x8(%ebp),%eax
80101688:	89 04 24             	mov    %eax,(%esp)
8010168b:	e8 e6 00 00 00       	call   80101776 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101690:	c9                   	leave  
80101691:	c3                   	ret    
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101692:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101695:	89 04 24             	mov    %eax,(%esp)
80101698:	e8 7b eb ff ff       	call   80100218 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
8010169d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801016a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016a7:	39 c2                	cmp    %eax,%edx
801016a9:	0f 82 5a ff ff ff    	jb     80101609 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016af:	c7 04 24 f1 88 10 80 	movl   $0x801088f1,(%esp)
801016b6:	e8 7f ee ff ff       	call   8010053a <panic>

801016bb <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016bb:	55                   	push   %ebp
801016bc:	89 e5                	mov    %esp,%ebp
801016be:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016c1:	8b 45 08             	mov    0x8(%ebp),%eax
801016c4:	8b 40 04             	mov    0x4(%eax),%eax
801016c7:	c1 e8 03             	shr    $0x3,%eax
801016ca:	8d 50 02             	lea    0x2(%eax),%edx
801016cd:	8b 45 08             	mov    0x8(%ebp),%eax
801016d0:	8b 00                	mov    (%eax),%eax
801016d2:	89 54 24 04          	mov    %edx,0x4(%esp)
801016d6:	89 04 24             	mov    %eax,(%esp)
801016d9:	e8 c9 ea ff ff       	call   801001a7 <bread>
801016de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016e4:	83 c0 18             	add    $0x18,%eax
801016e7:	89 c2                	mov    %eax,%edx
801016e9:	8b 45 08             	mov    0x8(%ebp),%eax
801016ec:	8b 40 04             	mov    0x4(%eax),%eax
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 04 02             	lea    (%edx,%eax,1),%eax
801016f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip->type = ip->type;
801016fb:	8b 45 08             	mov    0x8(%ebp),%eax
801016fe:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101705:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101708:	8b 45 08             	mov    0x8(%ebp),%eax
8010170b:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101712:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101716:	8b 45 08             	mov    0x8(%ebp),%eax
80101719:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101720:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101724:	8b 45 08             	mov    0x8(%ebp),%eax
80101727:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010172b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010172e:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101732:	8b 45 08             	mov    0x8(%ebp),%eax
80101735:	8b 50 18             	mov    0x18(%eax),%edx
80101738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010173b:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173e:	8b 45 08             	mov    0x8(%ebp),%eax
80101741:	8d 50 1c             	lea    0x1c(%eax),%edx
80101744:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101747:	83 c0 0c             	add    $0xc,%eax
8010174a:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101751:	00 
80101752:	89 54 24 04          	mov    %edx,0x4(%esp)
80101756:	89 04 24             	mov    %eax,(%esp)
80101759:	e8 47 3d 00 00       	call   801054a5 <memmove>
  log_write(bp);
8010175e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101761:	89 04 24             	mov    %eax,(%esp)
80101764:	e8 4a 1b 00 00       	call   801032b3 <log_write>
  brelse(bp);
80101769:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176c:	89 04 24             	mov    %eax,(%esp)
8010176f:	e8 a4 ea ff ff       	call   80100218 <brelse>
}
80101774:	c9                   	leave  
80101775:	c3                   	ret    

80101776 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101776:	55                   	push   %ebp
80101777:	89 e5                	mov    %esp,%ebp
80101779:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010177c:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101783:	e8 fb 39 00 00       	call   80105183 <acquire>

  // Is the inode already cached?
  empty = 0;
80101788:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010178f:	c7 45 f0 b4 e8 10 80 	movl   $0x8010e8b4,-0x10(%ebp)
80101796:	eb 59                	jmp    801017f1 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101798:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179b:	8b 40 08             	mov    0x8(%eax),%eax
8010179e:	85 c0                	test   %eax,%eax
801017a0:	7e 35                	jle    801017d7 <iget+0x61>
801017a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a5:	8b 00                	mov    (%eax),%eax
801017a7:	3b 45 08             	cmp    0x8(%ebp),%eax
801017aa:	75 2b                	jne    801017d7 <iget+0x61>
801017ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017af:	8b 40 04             	mov    0x4(%eax),%eax
801017b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017b5:	75 20                	jne    801017d7 <iget+0x61>
      ip->ref++;
801017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ba:	8b 40 08             	mov    0x8(%eax),%eax
801017bd:	8d 50 01             	lea    0x1(%eax),%edx
801017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c3:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017c6:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801017cd:	e8 12 3a 00 00       	call   801051e4 <release>
      return ip;
801017d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d5:	eb 70                	jmp    80101847 <iget+0xd1>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801017db:	75 10                	jne    801017ed <iget+0x77>
801017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e0:	8b 40 08             	mov    0x8(%eax),%eax
801017e3:	85 c0                	test   %eax,%eax
801017e5:	75 06                	jne    801017ed <iget+0x77>
      empty = ip;
801017e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ed:	83 45 f0 50          	addl   $0x50,-0x10(%ebp)
801017f1:	b8 54 f8 10 80       	mov    $0x8010f854,%eax
801017f6:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801017f9:	72 9d                	jb     80101798 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801017ff:	75 0c                	jne    8010180d <iget+0x97>
    panic("iget: no inodes");
80101801:	c7 04 24 03 89 10 80 	movl   $0x80108903,(%esp)
80101808:	e8 2d ed ff ff       	call   8010053a <panic>

  ip = empty;
8010180d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101810:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ip->dev = dev;
80101813:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101816:	8b 55 08             	mov    0x8(%ebp),%edx
80101819:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010181b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010181e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101821:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101827:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010182e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101831:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101838:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
8010183f:	e8 a0 39 00 00       	call   801051e4 <release>

  return ip;
80101844:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80101847:	c9                   	leave  
80101848:	c3                   	ret    

80101849 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101849:	55                   	push   %ebp
8010184a:	89 e5                	mov    %esp,%ebp
8010184c:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010184f:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101856:	e8 28 39 00 00       	call   80105183 <acquire>
  ip->ref++;
8010185b:	8b 45 08             	mov    0x8(%ebp),%eax
8010185e:	8b 40 08             	mov    0x8(%eax),%eax
80101861:	8d 50 01             	lea    0x1(%eax),%edx
80101864:	8b 45 08             	mov    0x8(%ebp),%eax
80101867:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010186a:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101871:	e8 6e 39 00 00       	call   801051e4 <release>
  return ip;
80101876:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101879:	c9                   	leave  
8010187a:	c3                   	ret    

8010187b <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010187b:	55                   	push   %ebp
8010187c:	89 e5                	mov    %esp,%ebp
8010187e:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101881:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101885:	74 0a                	je     80101891 <ilock+0x16>
80101887:	8b 45 08             	mov    0x8(%ebp),%eax
8010188a:	8b 40 08             	mov    0x8(%eax),%eax
8010188d:	85 c0                	test   %eax,%eax
8010188f:	7f 0c                	jg     8010189d <ilock+0x22>
    panic("ilock");
80101891:	c7 04 24 13 89 10 80 	movl   $0x80108913,(%esp)
80101898:	e8 9d ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
8010189d:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801018a4:	e8 da 38 00 00       	call   80105183 <acquire>
  while(ip->flags & I_BUSY)
801018a9:	eb 13                	jmp    801018be <ilock+0x43>
    sleep(ip, &icache.lock);
801018ab:	c7 44 24 04 80 e8 10 	movl   $0x8010e880,0x4(%esp)
801018b2:	80 
801018b3:	8b 45 08             	mov    0x8(%ebp),%eax
801018b6:	89 04 24             	mov    %eax,(%esp)
801018b9:	e8 4d 35 00 00       	call   80104e0b <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018be:	8b 45 08             	mov    0x8(%ebp),%eax
801018c1:	8b 40 0c             	mov    0xc(%eax),%eax
801018c4:	83 e0 01             	and    $0x1,%eax
801018c7:	84 c0                	test   %al,%al
801018c9:	75 e0                	jne    801018ab <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018cb:	8b 45 08             	mov    0x8(%ebp),%eax
801018ce:	8b 40 0c             	mov    0xc(%eax),%eax
801018d1:	89 c2                	mov    %eax,%edx
801018d3:	83 ca 01             	or     $0x1,%edx
801018d6:	8b 45 08             	mov    0x8(%ebp),%eax
801018d9:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018dc:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801018e3:	e8 fc 38 00 00       	call   801051e4 <release>

  if(!(ip->flags & I_VALID)){
801018e8:	8b 45 08             	mov    0x8(%ebp),%eax
801018eb:	8b 40 0c             	mov    0xc(%eax),%eax
801018ee:	83 e0 02             	and    $0x2,%eax
801018f1:	85 c0                	test   %eax,%eax
801018f3:	0f 85 d1 00 00 00    	jne    801019ca <ilock+0x14f>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018f9:	8b 45 08             	mov    0x8(%ebp),%eax
801018fc:	8b 40 04             	mov    0x4(%eax),%eax
801018ff:	c1 e8 03             	shr    $0x3,%eax
80101902:	8d 50 02             	lea    0x2(%eax),%edx
80101905:	8b 45 08             	mov    0x8(%ebp),%eax
80101908:	8b 00                	mov    (%eax),%eax
8010190a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010190e:	89 04 24             	mov    %eax,(%esp)
80101911:	e8 91 e8 ff ff       	call   801001a7 <bread>
80101916:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101919:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010191c:	83 c0 18             	add    $0x18,%eax
8010191f:	89 c2                	mov    %eax,%edx
80101921:	8b 45 08             	mov    0x8(%ebp),%eax
80101924:	8b 40 04             	mov    0x4(%eax),%eax
80101927:	83 e0 07             	and    $0x7,%eax
8010192a:	c1 e0 06             	shl    $0x6,%eax
8010192d:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101930:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ip->type = dip->type;
80101933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101936:	0f b7 10             	movzwl (%eax),%edx
80101939:	8b 45 08             	mov    0x8(%ebp),%eax
8010193c:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101943:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101947:	8b 45 08             	mov    0x8(%ebp),%eax
8010194a:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010194e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101951:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101955:	8b 45 08             	mov    0x8(%ebp),%eax
80101958:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
8010195c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195f:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101963:	8b 45 08             	mov    0x8(%ebp),%eax
80101966:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
8010196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196d:	8b 50 08             	mov    0x8(%eax),%edx
80101970:	8b 45 08             	mov    0x8(%ebp),%eax
80101973:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101979:	8d 50 0c             	lea    0xc(%eax),%edx
8010197c:	8b 45 08             	mov    0x8(%ebp),%eax
8010197f:	83 c0 1c             	add    $0x1c,%eax
80101982:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101989:	00 
8010198a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010198e:	89 04 24             	mov    %eax,(%esp)
80101991:	e8 0f 3b 00 00       	call   801054a5 <memmove>
    brelse(bp);
80101996:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101999:	89 04 24             	mov    %eax,(%esp)
8010199c:	e8 77 e8 ff ff       	call   80100218 <brelse>
    ip->flags |= I_VALID;
801019a1:	8b 45 08             	mov    0x8(%ebp),%eax
801019a4:	8b 40 0c             	mov    0xc(%eax),%eax
801019a7:	89 c2                	mov    %eax,%edx
801019a9:	83 ca 02             	or     $0x2,%edx
801019ac:	8b 45 08             	mov    0x8(%ebp),%eax
801019af:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019b2:	8b 45 08             	mov    0x8(%ebp),%eax
801019b5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019b9:	66 85 c0             	test   %ax,%ax
801019bc:	75 0c                	jne    801019ca <ilock+0x14f>
      panic("ilock: no type");
801019be:	c7 04 24 19 89 10 80 	movl   $0x80108919,(%esp)
801019c5:	e8 70 eb ff ff       	call   8010053a <panic>
  }
}
801019ca:	c9                   	leave  
801019cb:	c3                   	ret    

801019cc <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019cc:	55                   	push   %ebp
801019cd:	89 e5                	mov    %esp,%ebp
801019cf:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019d6:	74 17                	je     801019ef <iunlock+0x23>
801019d8:	8b 45 08             	mov    0x8(%ebp),%eax
801019db:	8b 40 0c             	mov    0xc(%eax),%eax
801019de:	83 e0 01             	and    $0x1,%eax
801019e1:	85 c0                	test   %eax,%eax
801019e3:	74 0a                	je     801019ef <iunlock+0x23>
801019e5:	8b 45 08             	mov    0x8(%ebp),%eax
801019e8:	8b 40 08             	mov    0x8(%eax),%eax
801019eb:	85 c0                	test   %eax,%eax
801019ed:	7f 0c                	jg     801019fb <iunlock+0x2f>
    panic("iunlock");
801019ef:	c7 04 24 28 89 10 80 	movl   $0x80108928,(%esp)
801019f6:	e8 3f eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019fb:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101a02:	e8 7c 37 00 00       	call   80105183 <acquire>
  ip->flags &= ~I_BUSY;
80101a07:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a0d:	89 c2                	mov    %eax,%edx
80101a0f:	83 e2 fe             	and    $0xfffffffe,%edx
80101a12:	8b 45 08             	mov    0x8(%ebp),%eax
80101a15:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a18:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1b:	89 04 24             	mov    %eax,(%esp)
80101a1e:	e8 2e 35 00 00       	call   80104f51 <wakeup>
  release(&icache.lock);
80101a23:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101a2a:	e8 b5 37 00 00       	call   801051e4 <release>
}
80101a2f:	c9                   	leave  
80101a30:	c3                   	ret    

80101a31 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a31:	55                   	push   %ebp
80101a32:	89 e5                	mov    %esp,%ebp
80101a34:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a37:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101a3e:	e8 40 37 00 00       	call   80105183 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a43:	8b 45 08             	mov    0x8(%ebp),%eax
80101a46:	8b 40 08             	mov    0x8(%eax),%eax
80101a49:	83 f8 01             	cmp    $0x1,%eax
80101a4c:	0f 85 93 00 00 00    	jne    80101ae5 <iput+0xb4>
80101a52:	8b 45 08             	mov    0x8(%ebp),%eax
80101a55:	8b 40 0c             	mov    0xc(%eax),%eax
80101a58:	83 e0 02             	and    $0x2,%eax
80101a5b:	85 c0                	test   %eax,%eax
80101a5d:	0f 84 82 00 00 00    	je     80101ae5 <iput+0xb4>
80101a63:	8b 45 08             	mov    0x8(%ebp),%eax
80101a66:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a6a:	66 85 c0             	test   %ax,%ax
80101a6d:	75 76                	jne    80101ae5 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a72:	8b 40 0c             	mov    0xc(%eax),%eax
80101a75:	83 e0 01             	and    $0x1,%eax
80101a78:	84 c0                	test   %al,%al
80101a7a:	74 0c                	je     80101a88 <iput+0x57>
      panic("iput busy");
80101a7c:	c7 04 24 30 89 10 80 	movl   $0x80108930,(%esp)
80101a83:	e8 b2 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a88:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a8e:	89 c2                	mov    %eax,%edx
80101a90:	83 ca 01             	or     $0x1,%edx
80101a93:	8b 45 08             	mov    0x8(%ebp),%eax
80101a96:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a99:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101aa0:	e8 3f 37 00 00       	call   801051e4 <release>
    itrunc(ip);
80101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa8:	89 04 24             	mov    %eax,(%esp)
80101aab:	e8 72 01 00 00       	call   80101c22 <itrunc>
    ip->type = 0;
80101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab3:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80101abc:	89 04 24             	mov    %eax,(%esp)
80101abf:	e8 f7 fb ff ff       	call   801016bb <iupdate>
    acquire(&icache.lock);
80101ac4:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101acb:	e8 b3 36 00 00       	call   80105183 <acquire>
    ip->flags = 0;
80101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ada:	8b 45 08             	mov    0x8(%ebp),%eax
80101add:	89 04 24             	mov    %eax,(%esp)
80101ae0:	e8 6c 34 00 00       	call   80104f51 <wakeup>
  }
  ip->ref--;
80101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae8:	8b 40 08             	mov    0x8(%eax),%eax
80101aeb:	8d 50 ff             	lea    -0x1(%eax),%edx
80101aee:	8b 45 08             	mov    0x8(%ebp),%eax
80101af1:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101af4:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101afb:	e8 e4 36 00 00       	call   801051e4 <release>
}
80101b00:	c9                   	leave  
80101b01:	c3                   	ret    

80101b02 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b02:	55                   	push   %ebp
80101b03:	89 e5                	mov    %esp,%ebp
80101b05:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b08:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0b:	89 04 24             	mov    %eax,(%esp)
80101b0e:	e8 b9 fe ff ff       	call   801019cc <iunlock>
  iput(ip);
80101b13:	8b 45 08             	mov    0x8(%ebp),%eax
80101b16:	89 04 24             	mov    %eax,(%esp)
80101b19:	e8 13 ff ff ff       	call   80101a31 <iput>
}
80101b1e:	c9                   	leave  
80101b1f:	c3                   	ret    

80101b20 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	53                   	push   %ebx
80101b24:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b27:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b2b:	77 3e                	ja     80101b6b <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b30:	8b 45 08             	mov    0x8(%ebp),%eax
80101b33:	83 c2 04             	add    $0x4,%edx
80101b36:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101b41:	75 20                	jne    80101b63 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80101b46:	8b 45 08             	mov    0x8(%ebp),%eax
80101b49:	8b 00                	mov    (%eax),%eax
80101b4b:	89 04 24             	mov    %eax,(%esp)
80101b4e:	e8 38 f8 ff ff       	call   8010138b <balloc>
80101b53:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b56:	8b 45 08             	mov    0x8(%ebp),%eax
80101b59:	8d 4b 04             	lea    0x4(%ebx),%ecx
80101b5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101b5f:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101b66:	e9 b1 00 00 00       	jmp    80101c1c <bmap+0xfc>
  }
  bn -= NDIRECT;
80101b6b:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b6f:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b73:	0f 87 97 00 00 00    	ja     80101c10 <bmap+0xf0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b79:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7c:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101b86:	75 19                	jne    80101ba1 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b88:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8b:	8b 00                	mov    (%eax),%eax
80101b8d:	89 04 24             	mov    %eax,(%esp)
80101b90:	e8 f6 f7 ff ff       	call   8010138b <balloc>
80101b95:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b98:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9b:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101b9e:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101ba1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba4:	8b 00                	mov    (%eax),%eax
80101ba6:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101ba9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bad:	89 04 24             	mov    %eax,(%esp)
80101bb0:	e8 f2 e5 ff ff       	call   801001a7 <bread>
80101bb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a = (uint*)bp->data;
80101bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bbb:	83 c0 18             	add    $0x18,%eax
80101bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((addr = a[bn]) == 0){
80101bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bc4:	c1 e0 02             	shl    $0x2,%eax
80101bc7:	03 45 f0             	add    -0x10(%ebp),%eax
80101bca:	8b 00                	mov    (%eax),%eax
80101bcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101bcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101bd3:	75 2b                	jne    80101c00 <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
80101bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bd8:	c1 e0 02             	shl    $0x2,%eax
80101bdb:	89 c3                	mov    %eax,%ebx
80101bdd:	03 5d f0             	add    -0x10(%ebp),%ebx
80101be0:	8b 45 08             	mov    0x8(%ebp),%eax
80101be3:	8b 00                	mov    (%eax),%eax
80101be5:	89 04 24             	mov    %eax,(%esp)
80101be8:	e8 9e f7 ff ff       	call   8010138b <balloc>
80101bed:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101bf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bf3:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bf8:	89 04 24             	mov    %eax,(%esp)
80101bfb:	e8 b3 16 00 00       	call   801032b3 <log_write>
    }
    brelse(bp);
80101c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c03:	89 04 24             	mov    %eax,(%esp)
80101c06:	e8 0d e6 ff ff       	call   80100218 <brelse>
    return addr;
80101c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c0e:	eb 0c                	jmp    80101c1c <bmap+0xfc>
  }

  panic("bmap: out of range");
80101c10:	c7 04 24 3a 89 10 80 	movl   $0x8010893a,(%esp)
80101c17:	e8 1e e9 ff ff       	call   8010053a <panic>
}
80101c1c:	83 c4 24             	add    $0x24,%esp
80101c1f:	5b                   	pop    %ebx
80101c20:	5d                   	pop    %ebp
80101c21:	c3                   	ret    

80101c22 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c22:	55                   	push   %ebp
80101c23:	89 e5                	mov    %esp,%ebp
80101c25:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80101c2f:	eb 44                	jmp    80101c75 <itrunc+0x53>
    if(ip->addrs[i]){
80101c31:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c34:	8b 45 08             	mov    0x8(%ebp),%eax
80101c37:	83 c2 04             	add    $0x4,%edx
80101c3a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c3e:	85 c0                	test   %eax,%eax
80101c40:	74 2f                	je     80101c71 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c42:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c45:	8b 45 08             	mov    0x8(%ebp),%eax
80101c48:	83 c2 04             	add    $0x4,%edx
80101c4b:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c52:	8b 00                	mov    (%eax),%eax
80101c54:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c58:	89 04 24             	mov    %eax,(%esp)
80101c5b:	e8 86 f8 ff ff       	call   801014e6 <bfree>
      ip->addrs[i] = 0;
80101c60:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c63:	8b 45 08             	mov    0x8(%ebp),%eax
80101c66:	83 c2 04             	add    $0x4,%edx
80101c69:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c70:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c71:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80101c75:	83 7d e8 0b          	cmpl   $0xb,-0x18(%ebp)
80101c79:	7e b6                	jle    80101c31 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7e:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	0f 84 8f 00 00 00    	je     80101d18 <itrunc+0xf6>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c89:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8c:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c92:	8b 00                	mov    (%eax),%eax
80101c94:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c98:	89 04 24             	mov    %eax,(%esp)
80101c9b:	e8 07 e5 ff ff       	call   801001a7 <bread>
80101ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca6:	83 c0 18             	add    $0x18,%eax
80101ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101cb3:	eb 2f                	jmp    80101ce4 <itrunc+0xc2>
      if(a[j])
80101cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cb8:	c1 e0 02             	shl    $0x2,%eax
80101cbb:	03 45 f4             	add    -0xc(%ebp),%eax
80101cbe:	8b 00                	mov    (%eax),%eax
80101cc0:	85 c0                	test   %eax,%eax
80101cc2:	74 1c                	je     80101ce0 <itrunc+0xbe>
        bfree(ip->dev, a[j]);
80101cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cc7:	c1 e0 02             	shl    $0x2,%eax
80101cca:	03 45 f4             	add    -0xc(%ebp),%eax
80101ccd:	8b 10                	mov    (%eax),%edx
80101ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd2:	8b 00                	mov    (%eax),%eax
80101cd4:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cd8:	89 04 24             	mov    %eax,(%esp)
80101cdb:	e8 06 f8 ff ff       	call   801014e6 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ce0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80101ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ce7:	83 f8 7f             	cmp    $0x7f,%eax
80101cea:	76 c9                	jbe    80101cb5 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cef:	89 04 24             	mov    %eax,(%esp)
80101cf2:	e8 21 e5 ff ff       	call   80100218 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfa:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101d00:	8b 00                	mov    (%eax),%eax
80101d02:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d06:	89 04 24             	mov    %eax,(%esp)
80101d09:	e8 d8 f7 ff ff       	call   801014e6 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d11:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d18:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1b:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d22:	8b 45 08             	mov    0x8(%ebp),%eax
80101d25:	89 04 24             	mov    %eax,(%esp)
80101d28:	e8 8e f9 ff ff       	call   801016bb <iupdate>
}
80101d2d:	c9                   	leave  
80101d2e:	c3                   	ret    

80101d2f <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d2f:	55                   	push   %ebp
80101d30:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d32:	8b 45 08             	mov    0x8(%ebp),%eax
80101d35:	8b 00                	mov    (%eax),%eax
80101d37:	89 c2                	mov    %eax,%edx
80101d39:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d3c:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d42:	8b 50 04             	mov    0x4(%eax),%edx
80101d45:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d48:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4e:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d52:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d55:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d58:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5b:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d62:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d66:	8b 45 08             	mov    0x8(%ebp),%eax
80101d69:	8b 50 18             	mov    0x18(%eax),%edx
80101d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d6f:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d72:	5d                   	pop    %ebp
80101d73:	c3                   	ret    

80101d74 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d74:	55                   	push   %ebp
80101d75:	89 e5                	mov    %esp,%ebp
80101d77:	53                   	push   %ebx
80101d78:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d82:	66 83 f8 03          	cmp    $0x3,%ax
80101d86:	75 60                	jne    80101de8 <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d88:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d8f:	66 85 c0             	test   %ax,%ax
80101d92:	78 20                	js     80101db4 <readi+0x40>
80101d94:	8b 45 08             	mov    0x8(%ebp),%eax
80101d97:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d9b:	66 83 f8 09          	cmp    $0x9,%ax
80101d9f:	7f 13                	jg     80101db4 <readi+0x40>
80101da1:	8b 45 08             	mov    0x8(%ebp),%eax
80101da4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101da8:	98                   	cwtl   
80101da9:	8b 04 c5 20 e8 10 80 	mov    -0x7fef17e0(,%eax,8),%eax
80101db0:	85 c0                	test   %eax,%eax
80101db2:	75 0a                	jne    80101dbe <readi+0x4a>
      return -1;
80101db4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101db9:	e9 1c 01 00 00       	jmp    80101eda <readi+0x166>
    return devsw[ip->major].read(ip, dst, n);
80101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dc5:	98                   	cwtl   
80101dc6:	8b 14 c5 20 e8 10 80 	mov    -0x7fef17e0(,%eax,8),%edx
80101dcd:	8b 45 14             	mov    0x14(%ebp),%eax
80101dd0:	89 44 24 08          	mov    %eax,0x8(%esp)
80101dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dde:	89 04 24             	mov    %eax,(%esp)
80101de1:	ff d2                	call   *%edx
80101de3:	e9 f2 00 00 00       	jmp    80101eda <readi+0x166>
  }

  if(off > ip->size || off + n < off)
80101de8:	8b 45 08             	mov    0x8(%ebp),%eax
80101deb:	8b 40 18             	mov    0x18(%eax),%eax
80101dee:	3b 45 10             	cmp    0x10(%ebp),%eax
80101df1:	72 0e                	jb     80101e01 <readi+0x8d>
80101df3:	8b 45 14             	mov    0x14(%ebp),%eax
80101df6:	8b 55 10             	mov    0x10(%ebp),%edx
80101df9:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101dfc:	3b 45 10             	cmp    0x10(%ebp),%eax
80101dff:	73 0a                	jae    80101e0b <readi+0x97>
    return -1;
80101e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e06:	e9 cf 00 00 00       	jmp    80101eda <readi+0x166>
  if(off + n > ip->size)
80101e0b:	8b 45 14             	mov    0x14(%ebp),%eax
80101e0e:	8b 55 10             	mov    0x10(%ebp),%edx
80101e11:	01 c2                	add    %eax,%edx
80101e13:	8b 45 08             	mov    0x8(%ebp),%eax
80101e16:	8b 40 18             	mov    0x18(%eax),%eax
80101e19:	39 c2                	cmp    %eax,%edx
80101e1b:	76 0c                	jbe    80101e29 <readi+0xb5>
    n = ip->size - off;
80101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e20:	8b 40 18             	mov    0x18(%eax),%eax
80101e23:	2b 45 10             	sub    0x10(%ebp),%eax
80101e26:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e29:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101e30:	e9 96 00 00 00       	jmp    80101ecb <readi+0x157>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e35:	8b 45 10             	mov    0x10(%ebp),%eax
80101e38:	c1 e8 09             	shr    $0x9,%eax
80101e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e42:	89 04 24             	mov    %eax,(%esp)
80101e45:	e8 d6 fc ff ff       	call   80101b20 <bmap>
80101e4a:	8b 55 08             	mov    0x8(%ebp),%edx
80101e4d:	8b 12                	mov    (%edx),%edx
80101e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e53:	89 14 24             	mov    %edx,(%esp)
80101e56:	e8 4c e3 ff ff       	call   801001a7 <bread>
80101e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e5e:	8b 45 10             	mov    0x10(%ebp),%eax
80101e61:	89 c2                	mov    %eax,%edx
80101e63:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101e69:	b8 00 02 00 00       	mov    $0x200,%eax
80101e6e:	89 c1                	mov    %eax,%ecx
80101e70:	29 d1                	sub    %edx,%ecx
80101e72:	89 ca                	mov    %ecx,%edx
80101e74:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e77:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e7a:	89 cb                	mov    %ecx,%ebx
80101e7c:	29 c3                	sub    %eax,%ebx
80101e7e:	89 d8                	mov    %ebx,%eax
80101e80:	39 c2                	cmp    %eax,%edx
80101e82:	0f 46 c2             	cmovbe %edx,%eax
80101e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e8b:	8d 50 18             	lea    0x18(%eax),%edx
80101e8e:	8b 45 10             	mov    0x10(%ebp),%eax
80101e91:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e96:	01 c2                	add    %eax,%edx
80101e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e9b:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e9f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea6:	89 04 24             	mov    %eax,(%esp)
80101ea9:	e8 f7 35 00 00       	call   801054a5 <memmove>
    brelse(bp);
80101eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eb1:	89 04 24             	mov    %eax,(%esp)
80101eb4:	e8 5f e3 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ebc:	01 45 ec             	add    %eax,-0x14(%ebp)
80101ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec2:	01 45 10             	add    %eax,0x10(%ebp)
80101ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec8:	01 45 0c             	add    %eax,0xc(%ebp)
80101ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ece:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ed1:	0f 82 5e ff ff ff    	jb     80101e35 <readi+0xc1>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ed7:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101eda:	83 c4 24             	add    $0x24,%esp
80101edd:	5b                   	pop    %ebx
80101ede:	5d                   	pop    %ebp
80101edf:	c3                   	ret    

80101ee0 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	53                   	push   %ebx
80101ee4:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ee7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eea:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101eee:	66 83 f8 03          	cmp    $0x3,%ax
80101ef2:	75 60                	jne    80101f54 <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ef4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101efb:	66 85 c0             	test   %ax,%ax
80101efe:	78 20                	js     80101f20 <writei+0x40>
80101f00:	8b 45 08             	mov    0x8(%ebp),%eax
80101f03:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f07:	66 83 f8 09          	cmp    $0x9,%ax
80101f0b:	7f 13                	jg     80101f20 <writei+0x40>
80101f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f10:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f14:	98                   	cwtl   
80101f15:	8b 04 c5 24 e8 10 80 	mov    -0x7fef17dc(,%eax,8),%eax
80101f1c:	85 c0                	test   %eax,%eax
80101f1e:	75 0a                	jne    80101f2a <writei+0x4a>
      return -1;
80101f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f25:	e9 48 01 00 00       	jmp    80102072 <writei+0x192>
    return devsw[ip->major].write(ip, src, n);
80101f2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f31:	98                   	cwtl   
80101f32:	8b 14 c5 24 e8 10 80 	mov    -0x7fef17dc(,%eax,8),%edx
80101f39:	8b 45 14             	mov    0x14(%ebp),%eax
80101f3c:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f40:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f43:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f47:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4a:	89 04 24             	mov    %eax,(%esp)
80101f4d:	ff d2                	call   *%edx
80101f4f:	e9 1e 01 00 00       	jmp    80102072 <writei+0x192>
  }

  if(off > ip->size || off + n < off)
80101f54:	8b 45 08             	mov    0x8(%ebp),%eax
80101f57:	8b 40 18             	mov    0x18(%eax),%eax
80101f5a:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f5d:	72 0e                	jb     80101f6d <writei+0x8d>
80101f5f:	8b 45 14             	mov    0x14(%ebp),%eax
80101f62:	8b 55 10             	mov    0x10(%ebp),%edx
80101f65:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101f68:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f6b:	73 0a                	jae    80101f77 <writei+0x97>
    return -1;
80101f6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f72:	e9 fb 00 00 00       	jmp    80102072 <writei+0x192>
  if(off + n > MAXFILE*BSIZE)
80101f77:	8b 45 14             	mov    0x14(%ebp),%eax
80101f7a:	8b 55 10             	mov    0x10(%ebp),%edx
80101f7d:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101f80:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f85:	76 0a                	jbe    80101f91 <writei+0xb1>
    return -1;
80101f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f8c:	e9 e1 00 00 00       	jmp    80102072 <writei+0x192>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f91:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101f98:	e9 a1 00 00 00       	jmp    8010203e <writei+0x15e>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f9d:	8b 45 10             	mov    0x10(%ebp),%eax
80101fa0:	c1 e8 09             	shr    $0x9,%eax
80101fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101faa:	89 04 24             	mov    %eax,(%esp)
80101fad:	e8 6e fb ff ff       	call   80101b20 <bmap>
80101fb2:	8b 55 08             	mov    0x8(%ebp),%edx
80101fb5:	8b 12                	mov    (%edx),%edx
80101fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fbb:	89 14 24             	mov    %edx,(%esp)
80101fbe:	e8 e4 e1 ff ff       	call   801001a7 <bread>
80101fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc6:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc9:	89 c2                	mov    %eax,%edx
80101fcb:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101fd1:	b8 00 02 00 00       	mov    $0x200,%eax
80101fd6:	89 c1                	mov    %eax,%ecx
80101fd8:	29 d1                	sub    %edx,%ecx
80101fda:	89 ca                	mov    %ecx,%edx
80101fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fdf:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fe2:	89 cb                	mov    %ecx,%ebx
80101fe4:	29 c3                	sub    %eax,%ebx
80101fe6:	89 d8                	mov    %ebx,%eax
80101fe8:	39 c2                	cmp    %eax,%edx
80101fea:	0f 46 c2             	cmovbe %edx,%eax
80101fed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ff3:	8d 50 18             	lea    0x18(%eax),%edx
80101ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80101ff9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ffe:	01 c2                	add    %eax,%edx
80102000:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102003:	89 44 24 08          	mov    %eax,0x8(%esp)
80102007:	8b 45 0c             	mov    0xc(%ebp),%eax
8010200a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010200e:	89 14 24             	mov    %edx,(%esp)
80102011:	e8 8f 34 00 00       	call   801054a5 <memmove>
    log_write(bp);
80102016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102019:	89 04 24             	mov    %eax,(%esp)
8010201c:	e8 92 12 00 00       	call   801032b3 <log_write>
    brelse(bp);
80102021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102024:	89 04 24             	mov    %eax,(%esp)
80102027:	e8 ec e1 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010202f:	01 45 ec             	add    %eax,-0x14(%ebp)
80102032:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102035:	01 45 10             	add    %eax,0x10(%ebp)
80102038:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010203b:	01 45 0c             	add    %eax,0xc(%ebp)
8010203e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102041:	3b 45 14             	cmp    0x14(%ebp),%eax
80102044:	0f 82 53 ff ff ff    	jb     80101f9d <writei+0xbd>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010204a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010204e:	74 1f                	je     8010206f <writei+0x18f>
80102050:	8b 45 08             	mov    0x8(%ebp),%eax
80102053:	8b 40 18             	mov    0x18(%eax),%eax
80102056:	3b 45 10             	cmp    0x10(%ebp),%eax
80102059:	73 14                	jae    8010206f <writei+0x18f>
    ip->size = off;
8010205b:	8b 45 08             	mov    0x8(%ebp),%eax
8010205e:	8b 55 10             	mov    0x10(%ebp),%edx
80102061:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102064:	8b 45 08             	mov    0x8(%ebp),%eax
80102067:	89 04 24             	mov    %eax,(%esp)
8010206a:	e8 4c f6 ff ff       	call   801016bb <iupdate>
  }
  return n;
8010206f:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102072:	83 c4 24             	add    $0x24,%esp
80102075:	5b                   	pop    %ebx
80102076:	5d                   	pop    %ebp
80102077:	c3                   	ret    

80102078 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102078:	55                   	push   %ebp
80102079:	89 e5                	mov    %esp,%ebp
8010207b:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
8010207e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102085:	00 
80102086:	8b 45 0c             	mov    0xc(%ebp),%eax
80102089:	89 44 24 04          	mov    %eax,0x4(%esp)
8010208d:	8b 45 08             	mov    0x8(%ebp),%eax
80102090:	89 04 24             	mov    %eax,(%esp)
80102093:	e8 b5 34 00 00       	call   8010554d <strncmp>
}
80102098:	c9                   	leave  
80102099:	c3                   	ret    

8010209a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010209a:	55                   	push   %ebp
8010209b:	89 e5                	mov    %esp,%ebp
8010209d:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020a0:	8b 45 08             	mov    0x8(%ebp),%eax
801020a3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020a7:	66 83 f8 01          	cmp    $0x1,%ax
801020ab:	74 0c                	je     801020b9 <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020ad:	c7 04 24 4d 89 10 80 	movl   $0x8010894d,(%esp)
801020b4:	e8 81 e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801020c0:	e9 87 00 00 00       	jmp    8010214c <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020c8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020cf:	00 
801020d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801020d3:	89 54 24 08          	mov    %edx,0x8(%esp)
801020d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
801020de:	89 04 24             	mov    %eax,(%esp)
801020e1:	e8 8e fc ff ff       	call   80101d74 <readi>
801020e6:	83 f8 10             	cmp    $0x10,%eax
801020e9:	74 0c                	je     801020f7 <dirlookup+0x5d>
      panic("dirlink read");
801020eb:	c7 04 24 5f 89 10 80 	movl   $0x8010895f,(%esp)
801020f2:	e8 43 e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020f7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020fb:	66 85 c0             	test   %ax,%ax
801020fe:	74 47                	je     80102147 <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
80102100:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102103:	83 c0 02             	add    $0x2,%eax
80102106:	89 44 24 04          	mov    %eax,0x4(%esp)
8010210a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010210d:	89 04 24             	mov    %eax,(%esp)
80102110:	e8 63 ff ff ff       	call   80102078 <namecmp>
80102115:	85 c0                	test   %eax,%eax
80102117:	75 2f                	jne    80102148 <dirlookup+0xae>
      // entry matches path element
      if(poff)
80102119:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010211d:	74 08                	je     80102127 <dirlookup+0x8d>
        *poff = off;
8010211f:	8b 45 10             	mov    0x10(%ebp),%eax
80102122:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102125:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102127:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010212b:	0f b7 c0             	movzwl %ax,%eax
8010212e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return iget(dp->dev, inum);
80102131:	8b 45 08             	mov    0x8(%ebp),%eax
80102134:	8b 00                	mov    (%eax),%eax
80102136:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102139:	89 54 24 04          	mov    %edx,0x4(%esp)
8010213d:	89 04 24             	mov    %eax,(%esp)
80102140:	e8 31 f6 ff ff       	call   80101776 <iget>
80102145:	eb 19                	jmp    80102160 <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102147:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102148:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
8010214c:	8b 45 08             	mov    0x8(%ebp),%eax
8010214f:	8b 40 18             	mov    0x18(%eax),%eax
80102152:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102155:	0f 87 6a ff ff ff    	ja     801020c5 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010215b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102160:	c9                   	leave  
80102161:	c3                   	ret    

80102162 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102162:	55                   	push   %ebp
80102163:	89 e5                	mov    %esp,%ebp
80102165:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102168:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010216f:	00 
80102170:	8b 45 0c             	mov    0xc(%ebp),%eax
80102173:	89 44 24 04          	mov    %eax,0x4(%esp)
80102177:	8b 45 08             	mov    0x8(%ebp),%eax
8010217a:	89 04 24             	mov    %eax,(%esp)
8010217d:	e8 18 ff ff ff       	call   8010209a <dirlookup>
80102182:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102185:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102189:	74 15                	je     801021a0 <dirlink+0x3e>
    iput(ip);
8010218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010218e:	89 04 24             	mov    %eax,(%esp)
80102191:	e8 9b f8 ff ff       	call   80101a31 <iput>
    return -1;
80102196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010219b:	e9 b8 00 00 00       	jmp    80102258 <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801021a7:	eb 44                	jmp    801021ed <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021af:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021b6:	00 
801021b7:	89 54 24 08          	mov    %edx,0x8(%esp)
801021bb:	89 44 24 04          	mov    %eax,0x4(%esp)
801021bf:	8b 45 08             	mov    0x8(%ebp),%eax
801021c2:	89 04 24             	mov    %eax,(%esp)
801021c5:	e8 aa fb ff ff       	call   80101d74 <readi>
801021ca:	83 f8 10             	cmp    $0x10,%eax
801021cd:	74 0c                	je     801021db <dirlink+0x79>
      panic("dirlink read");
801021cf:	c7 04 24 5f 89 10 80 	movl   $0x8010895f,(%esp)
801021d6:	e8 5f e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021db:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021df:	66 85 c0             	test   %ax,%ax
801021e2:	74 18                	je     801021fc <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021e7:	83 c0 10             	add    $0x10,%eax
801021ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021f0:	8b 45 08             	mov    0x8(%ebp),%eax
801021f3:	8b 40 18             	mov    0x18(%eax),%eax
801021f6:	39 c2                	cmp    %eax,%edx
801021f8:	72 af                	jb     801021a9 <dirlink+0x47>
801021fa:	eb 01                	jmp    801021fd <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801021fc:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801021fd:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102204:	00 
80102205:	8b 45 0c             	mov    0xc(%ebp),%eax
80102208:	89 44 24 04          	mov    %eax,0x4(%esp)
8010220c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010220f:	83 c0 02             	add    $0x2,%eax
80102212:	89 04 24             	mov    %eax,(%esp)
80102215:	e8 8b 33 00 00       	call   801055a5 <strncpy>
  de.inum = inum;
8010221a:	8b 45 10             	mov    0x10(%ebp),%eax
8010221d:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102221:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102224:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102227:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010222e:	00 
8010222f:	89 54 24 08          	mov    %edx,0x8(%esp)
80102233:	89 44 24 04          	mov    %eax,0x4(%esp)
80102237:	8b 45 08             	mov    0x8(%ebp),%eax
8010223a:	89 04 24             	mov    %eax,(%esp)
8010223d:	e8 9e fc ff ff       	call   80101ee0 <writei>
80102242:	83 f8 10             	cmp    $0x10,%eax
80102245:	74 0c                	je     80102253 <dirlink+0xf1>
    panic("dirlink");
80102247:	c7 04 24 6c 89 10 80 	movl   $0x8010896c,(%esp)
8010224e:	e8 e7 e2 ff ff       	call   8010053a <panic>
  
  return 0;
80102253:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102258:	c9                   	leave  
80102259:	c3                   	ret    

8010225a <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010225a:	55                   	push   %ebp
8010225b:	89 e5                	mov    %esp,%ebp
8010225d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102260:	eb 04                	jmp    80102266 <skipelem+0xc>
    path++;
80102262:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102266:	8b 45 08             	mov    0x8(%ebp),%eax
80102269:	0f b6 00             	movzbl (%eax),%eax
8010226c:	3c 2f                	cmp    $0x2f,%al
8010226e:	74 f2                	je     80102262 <skipelem+0x8>
    path++;
  if(*path == 0)
80102270:	8b 45 08             	mov    0x8(%ebp),%eax
80102273:	0f b6 00             	movzbl (%eax),%eax
80102276:	84 c0                	test   %al,%al
80102278:	75 0a                	jne    80102284 <skipelem+0x2a>
    return 0;
8010227a:	b8 00 00 00 00       	mov    $0x0,%eax
8010227f:	e9 86 00 00 00       	jmp    8010230a <skipelem+0xb0>
  s = path;
80102284:	8b 45 08             	mov    0x8(%ebp),%eax
80102287:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(*path != '/' && *path != 0)
8010228a:	eb 04                	jmp    80102290 <skipelem+0x36>
    path++;
8010228c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102290:	8b 45 08             	mov    0x8(%ebp),%eax
80102293:	0f b6 00             	movzbl (%eax),%eax
80102296:	3c 2f                	cmp    $0x2f,%al
80102298:	74 0a                	je     801022a4 <skipelem+0x4a>
8010229a:	8b 45 08             	mov    0x8(%ebp),%eax
8010229d:	0f b6 00             	movzbl (%eax),%eax
801022a0:	84 c0                	test   %al,%al
801022a2:	75 e8                	jne    8010228c <skipelem+0x32>
    path++;
  len = path - s;
801022a4:	8b 55 08             	mov    0x8(%ebp),%edx
801022a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022aa:	89 d1                	mov    %edx,%ecx
801022ac:	29 c1                	sub    %eax,%ecx
801022ae:	89 c8                	mov    %ecx,%eax
801022b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(len >= DIRSIZ)
801022b3:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801022b7:	7e 1c                	jle    801022d5 <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
801022b9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022c0:	00 
801022c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801022cb:	89 04 24             	mov    %eax,(%esp)
801022ce:	e8 d2 31 00 00       	call   801054a5 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022d3:	eb 28                	jmp    801022fd <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d8:	89 44 24 08          	mov    %eax,0x8(%esp)
801022dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022df:	89 44 24 04          	mov    %eax,0x4(%esp)
801022e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801022e6:	89 04 24             	mov    %eax,(%esp)
801022e9:	e8 b7 31 00 00       	call   801054a5 <memmove>
    name[len] = 0;
801022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f1:	03 45 0c             	add    0xc(%ebp),%eax
801022f4:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022f7:	eb 04                	jmp    801022fd <skipelem+0xa3>
    path++;
801022f9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102300:	0f b6 00             	movzbl (%eax),%eax
80102303:	3c 2f                	cmp    $0x2f,%al
80102305:	74 f2                	je     801022f9 <skipelem+0x9f>
    path++;
  return path;
80102307:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010230a:	c9                   	leave  
8010230b:	c3                   	ret    

8010230c <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010230c:	55                   	push   %ebp
8010230d:	89 e5                	mov    %esp,%ebp
8010230f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102312:	8b 45 08             	mov    0x8(%ebp),%eax
80102315:	0f b6 00             	movzbl (%eax),%eax
80102318:	3c 2f                	cmp    $0x2f,%al
8010231a:	75 1c                	jne    80102338 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
8010231c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102323:	00 
80102324:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010232b:	e8 46 f4 ff ff       	call   80101776 <iget>
80102330:	89 45 f0             	mov    %eax,-0x10(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102333:	e9 af 00 00 00       	jmp    801023e7 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102338:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010233e:	8b 40 68             	mov    0x68(%eax),%eax
80102341:	89 04 24             	mov    %eax,(%esp)
80102344:	e8 00 f5 ff ff       	call   80101849 <idup>
80102349:	89 45 f0             	mov    %eax,-0x10(%ebp)

  while((path = skipelem(path, name)) != 0){
8010234c:	e9 96 00 00 00       	jmp    801023e7 <namex+0xdb>
    ilock(ip);
80102351:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102354:	89 04 24             	mov    %eax,(%esp)
80102357:	e8 1f f5 ff ff       	call   8010187b <ilock>
    if(ip->type != T_DIR){
8010235c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010235f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102363:	66 83 f8 01          	cmp    $0x1,%ax
80102367:	74 15                	je     8010237e <namex+0x72>
      iunlockput(ip);
80102369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010236c:	89 04 24             	mov    %eax,(%esp)
8010236f:	e8 8e f7 ff ff       	call   80101b02 <iunlockput>
      return 0;
80102374:	b8 00 00 00 00       	mov    $0x0,%eax
80102379:	e9 a3 00 00 00       	jmp    80102421 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
8010237e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102382:	74 1d                	je     801023a1 <namex+0x95>
80102384:	8b 45 08             	mov    0x8(%ebp),%eax
80102387:	0f b6 00             	movzbl (%eax),%eax
8010238a:	84 c0                	test   %al,%al
8010238c:	75 13                	jne    801023a1 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
8010238e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102391:	89 04 24             	mov    %eax,(%esp)
80102394:	e8 33 f6 ff ff       	call   801019cc <iunlock>
      return ip;
80102399:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010239c:	e9 80 00 00 00       	jmp    80102421 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023a8:	00 
801023a9:	8b 45 10             	mov    0x10(%ebp),%eax
801023ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801023b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023b3:	89 04 24             	mov    %eax,(%esp)
801023b6:	e8 df fc ff ff       	call   8010209a <dirlookup>
801023bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801023c2:	75 12                	jne    801023d6 <namex+0xca>
      iunlockput(ip);
801023c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023c7:	89 04 24             	mov    %eax,(%esp)
801023ca:	e8 33 f7 ff ff       	call   80101b02 <iunlockput>
      return 0;
801023cf:	b8 00 00 00 00       	mov    $0x0,%eax
801023d4:	eb 4b                	jmp    80102421 <namex+0x115>
    }
    iunlockput(ip);
801023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023d9:	89 04 24             	mov    %eax,(%esp)
801023dc:	e8 21 f7 ff ff       	call   80101b02 <iunlockput>
    ip = next;
801023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023e7:	8b 45 10             	mov    0x10(%ebp),%eax
801023ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801023ee:	8b 45 08             	mov    0x8(%ebp),%eax
801023f1:	89 04 24             	mov    %eax,(%esp)
801023f4:	e8 61 fe ff ff       	call   8010225a <skipelem>
801023f9:	89 45 08             	mov    %eax,0x8(%ebp)
801023fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102400:	0f 85 4b ff ff ff    	jne    80102351 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102406:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010240a:	74 12                	je     8010241e <namex+0x112>
    iput(ip);
8010240c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010240f:	89 04 24             	mov    %eax,(%esp)
80102412:	e8 1a f6 ff ff       	call   80101a31 <iput>
    return 0;
80102417:	b8 00 00 00 00       	mov    $0x0,%eax
8010241c:	eb 03                	jmp    80102421 <namex+0x115>
  }
  return ip;
8010241e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80102421:	c9                   	leave  
80102422:	c3                   	ret    

80102423 <namei>:

struct inode*
namei(char *path)
{
80102423:	55                   	push   %ebp
80102424:	89 e5                	mov    %esp,%ebp
80102426:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102429:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010242c:	89 44 24 08          	mov    %eax,0x8(%esp)
80102430:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102437:	00 
80102438:	8b 45 08             	mov    0x8(%ebp),%eax
8010243b:	89 04 24             	mov    %eax,(%esp)
8010243e:	e8 c9 fe ff ff       	call   8010230c <namex>
}
80102443:	c9                   	leave  
80102444:	c3                   	ret    

80102445 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102445:	55                   	push   %ebp
80102446:	89 e5                	mov    %esp,%ebp
80102448:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010244b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010244e:	89 44 24 08          	mov    %eax,0x8(%esp)
80102452:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102459:	00 
8010245a:	8b 45 08             	mov    0x8(%ebp),%eax
8010245d:	89 04 24             	mov    %eax,(%esp)
80102460:	e8 a7 fe ff ff       	call   8010230c <namex>
}
80102465:	c9                   	leave  
80102466:	c3                   	ret    
	...

80102468 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102468:	55                   	push   %ebp
80102469:	89 e5                	mov    %esp,%ebp
8010246b:	83 ec 14             	sub    $0x14,%esp
8010246e:	8b 45 08             	mov    0x8(%ebp),%eax
80102471:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102475:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102479:	89 c2                	mov    %eax,%edx
8010247b:	ec                   	in     (%dx),%al
8010247c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010247f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102483:	c9                   	leave  
80102484:	c3                   	ret    

80102485 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102485:	55                   	push   %ebp
80102486:	89 e5                	mov    %esp,%ebp
80102488:	57                   	push   %edi
80102489:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010248a:	8b 55 08             	mov    0x8(%ebp),%edx
8010248d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102490:	8b 45 10             	mov    0x10(%ebp),%eax
80102493:	89 cb                	mov    %ecx,%ebx
80102495:	89 df                	mov    %ebx,%edi
80102497:	89 c1                	mov    %eax,%ecx
80102499:	fc                   	cld    
8010249a:	f3 6d                	rep insl (%dx),%es:(%edi)
8010249c:	89 c8                	mov    %ecx,%eax
8010249e:	89 fb                	mov    %edi,%ebx
801024a0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024a3:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024a6:	5b                   	pop    %ebx
801024a7:	5f                   	pop    %edi
801024a8:	5d                   	pop    %ebp
801024a9:	c3                   	ret    

801024aa <outb>:

static inline void
outb(ushort port, uchar data)
{
801024aa:	55                   	push   %ebp
801024ab:	89 e5                	mov    %esp,%ebp
801024ad:	83 ec 08             	sub    $0x8,%esp
801024b0:	8b 55 08             	mov    0x8(%ebp),%edx
801024b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801024b6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024ba:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024bd:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024c1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024c5:	ee                   	out    %al,(%dx)
}
801024c6:	c9                   	leave  
801024c7:	c3                   	ret    

801024c8 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024c8:	55                   	push   %ebp
801024c9:	89 e5                	mov    %esp,%ebp
801024cb:	56                   	push   %esi
801024cc:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024cd:	8b 55 08             	mov    0x8(%ebp),%edx
801024d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024d3:	8b 45 10             	mov    0x10(%ebp),%eax
801024d6:	89 cb                	mov    %ecx,%ebx
801024d8:	89 de                	mov    %ebx,%esi
801024da:	89 c1                	mov    %eax,%ecx
801024dc:	fc                   	cld    
801024dd:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024df:	89 c8                	mov    %ecx,%eax
801024e1:	89 f3                	mov    %esi,%ebx
801024e3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024e6:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024e9:	5b                   	pop    %ebx
801024ea:	5e                   	pop    %esi
801024eb:	5d                   	pop    %ebp
801024ec:	c3                   	ret    

801024ed <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024ed:	55                   	push   %ebp
801024ee:	89 e5                	mov    %esp,%ebp
801024f0:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024f3:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024fa:	e8 69 ff ff ff       	call   80102468 <inb>
801024ff:	0f b6 c0             	movzbl %al,%eax
80102502:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102505:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102508:	25 c0 00 00 00       	and    $0xc0,%eax
8010250d:	83 f8 40             	cmp    $0x40,%eax
80102510:	75 e1                	jne    801024f3 <idewait+0x6>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102512:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102516:	74 11                	je     80102529 <idewait+0x3c>
80102518:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010251b:	83 e0 21             	and    $0x21,%eax
8010251e:	85 c0                	test   %eax,%eax
80102520:	74 07                	je     80102529 <idewait+0x3c>
    return -1;
80102522:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102527:	eb 05                	jmp    8010252e <idewait+0x41>
  return 0;
80102529:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010252e:	c9                   	leave  
8010252f:	c3                   	ret    

80102530 <ideinit>:

void
ideinit(void)
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102536:	c7 44 24 04 74 89 10 	movl   $0x80108974,0x4(%esp)
8010253d:	80 
8010253e:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102545:	e8 18 2c 00 00       	call   80105162 <initlock>
  picenable(IRQ_IDE);
8010254a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102551:	e8 37 15 00 00       	call   80103a8d <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102556:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
8010255b:	83 e8 01             	sub    $0x1,%eax
8010255e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102562:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102569:	e8 10 04 00 00       	call   8010297e <ioapicenable>
  idewait(0);
8010256e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102575:	e8 73 ff ff ff       	call   801024ed <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010257a:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102581:	00 
80102582:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102589:	e8 1c ff ff ff       	call   801024aa <outb>
  for(i=0; i<1000; i++){
8010258e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102595:	eb 20                	jmp    801025b7 <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102597:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010259e:	e8 c5 fe ff ff       	call   80102468 <inb>
801025a3:	84 c0                	test   %al,%al
801025a5:	74 0c                	je     801025b3 <ideinit+0x83>
      havedisk1 = 1;
801025a7:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
801025ae:	00 00 00 
      break;
801025b1:	eb 0d                	jmp    801025c0 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025b7:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025be:	7e d7                	jle    80102597 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025c0:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025c7:	00 
801025c8:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025cf:	e8 d6 fe ff ff       	call   801024aa <outb>
}
801025d4:	c9                   	leave  
801025d5:	c3                   	ret    

801025d6 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025d6:	55                   	push   %ebp
801025d7:	89 e5                	mov    %esp,%ebp
801025d9:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025e0:	75 0c                	jne    801025ee <idestart+0x18>
    panic("idestart");
801025e2:	c7 04 24 78 89 10 80 	movl   $0x80108978,(%esp)
801025e9:	e8 4c df ff ff       	call   8010053a <panic>

  idewait(0);
801025ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025f5:	e8 f3 fe ff ff       	call   801024ed <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102601:	00 
80102602:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102609:	e8 9c fe ff ff       	call   801024aa <outb>
  outb(0x1f2, 1);  // number of sectors
8010260e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102615:	00 
80102616:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
8010261d:	e8 88 fe ff ff       	call   801024aa <outb>
  outb(0x1f3, b->sector & 0xff);
80102622:	8b 45 08             	mov    0x8(%ebp),%eax
80102625:	8b 40 08             	mov    0x8(%eax),%eax
80102628:	0f b6 c0             	movzbl %al,%eax
8010262b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010262f:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102636:	e8 6f fe ff ff       	call   801024aa <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
8010263b:	8b 45 08             	mov    0x8(%ebp),%eax
8010263e:	8b 40 08             	mov    0x8(%eax),%eax
80102641:	c1 e8 08             	shr    $0x8,%eax
80102644:	0f b6 c0             	movzbl %al,%eax
80102647:	89 44 24 04          	mov    %eax,0x4(%esp)
8010264b:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102652:	e8 53 fe ff ff       	call   801024aa <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102657:	8b 45 08             	mov    0x8(%ebp),%eax
8010265a:	8b 40 08             	mov    0x8(%eax),%eax
8010265d:	c1 e8 10             	shr    $0x10,%eax
80102660:	0f b6 c0             	movzbl %al,%eax
80102663:	89 44 24 04          	mov    %eax,0x4(%esp)
80102667:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
8010266e:	e8 37 fe ff ff       	call   801024aa <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102673:	8b 45 08             	mov    0x8(%ebp),%eax
80102676:	8b 40 04             	mov    0x4(%eax),%eax
80102679:	83 e0 01             	and    $0x1,%eax
8010267c:	89 c2                	mov    %eax,%edx
8010267e:	c1 e2 04             	shl    $0x4,%edx
80102681:	8b 45 08             	mov    0x8(%ebp),%eax
80102684:	8b 40 08             	mov    0x8(%eax),%eax
80102687:	c1 e8 18             	shr    $0x18,%eax
8010268a:	83 e0 0f             	and    $0xf,%eax
8010268d:	09 d0                	or     %edx,%eax
8010268f:	83 c8 e0             	or     $0xffffffe0,%eax
80102692:	0f b6 c0             	movzbl %al,%eax
80102695:	89 44 24 04          	mov    %eax,0x4(%esp)
80102699:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026a0:	e8 05 fe ff ff       	call   801024aa <outb>
  if(b->flags & B_DIRTY){
801026a5:	8b 45 08             	mov    0x8(%ebp),%eax
801026a8:	8b 00                	mov    (%eax),%eax
801026aa:	83 e0 04             	and    $0x4,%eax
801026ad:	85 c0                	test   %eax,%eax
801026af:	74 34                	je     801026e5 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026b1:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026b8:	00 
801026b9:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026c0:	e8 e5 fd ff ff       	call   801024aa <outb>
    outsl(0x1f0, b->data, 512/4);
801026c5:	8b 45 08             	mov    0x8(%ebp),%eax
801026c8:	83 c0 18             	add    $0x18,%eax
801026cb:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026d2:	00 
801026d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801026d7:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026de:	e8 e5 fd ff ff       	call   801024c8 <outsl>
801026e3:	eb 14                	jmp    801026f9 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026e5:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026ec:	00 
801026ed:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026f4:	e8 b1 fd ff ff       	call   801024aa <outb>
  }
}
801026f9:	c9                   	leave  
801026fa:	c3                   	ret    

801026fb <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026fb:	55                   	push   %ebp
801026fc:	89 e5                	mov    %esp,%ebp
801026fe:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102701:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102708:	e8 76 2a 00 00       	call   80105183 <acquire>
  if((b = idequeue) == 0){
8010270d:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102712:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102715:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102719:	75 11                	jne    8010272c <ideintr+0x31>
    release(&idelock);
8010271b:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102722:	e8 bd 2a 00 00       	call   801051e4 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102727:	e9 90 00 00 00       	jmp    801027bc <ideintr+0xc1>
  }
  idequeue = b->qnext;
8010272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010272f:	8b 40 14             	mov    0x14(%eax),%eax
80102732:	a3 54 b6 10 80       	mov    %eax,0x8010b654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010273a:	8b 00                	mov    (%eax),%eax
8010273c:	83 e0 04             	and    $0x4,%eax
8010273f:	85 c0                	test   %eax,%eax
80102741:	75 2e                	jne    80102771 <ideintr+0x76>
80102743:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010274a:	e8 9e fd ff ff       	call   801024ed <idewait>
8010274f:	85 c0                	test   %eax,%eax
80102751:	78 1e                	js     80102771 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102756:	83 c0 18             	add    $0x18,%eax
80102759:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102760:	00 
80102761:	89 44 24 04          	mov    %eax,0x4(%esp)
80102765:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010276c:	e8 14 fd ff ff       	call   80102485 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102774:	8b 00                	mov    (%eax),%eax
80102776:	89 c2                	mov    %eax,%edx
80102778:	83 ca 02             	or     $0x2,%edx
8010277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010277e:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102783:	8b 00                	mov    (%eax),%eax
80102785:	89 c2                	mov    %eax,%edx
80102787:	83 e2 fb             	and    $0xfffffffb,%edx
8010278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010278d:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102792:	89 04 24             	mov    %eax,(%esp)
80102795:	e8 b7 27 00 00       	call   80104f51 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010279a:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010279f:	85 c0                	test   %eax,%eax
801027a1:	74 0d                	je     801027b0 <ideintr+0xb5>
    idestart(idequeue);
801027a3:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801027a8:	89 04 24             	mov    %eax,(%esp)
801027ab:	e8 26 fe ff ff       	call   801025d6 <idestart>

  release(&idelock);
801027b0:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801027b7:	e8 28 2a 00 00       	call   801051e4 <release>
}
801027bc:	c9                   	leave  
801027bd:	c3                   	ret    

801027be <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027be:	55                   	push   %ebp
801027bf:	89 e5                	mov    %esp,%ebp
801027c1:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027c4:	8b 45 08             	mov    0x8(%ebp),%eax
801027c7:	8b 00                	mov    (%eax),%eax
801027c9:	83 e0 01             	and    $0x1,%eax
801027cc:	85 c0                	test   %eax,%eax
801027ce:	75 0c                	jne    801027dc <iderw+0x1e>
    panic("iderw: buf not busy");
801027d0:	c7 04 24 81 89 10 80 	movl   $0x80108981,(%esp)
801027d7:	e8 5e dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027dc:	8b 45 08             	mov    0x8(%ebp),%eax
801027df:	8b 00                	mov    (%eax),%eax
801027e1:	83 e0 06             	and    $0x6,%eax
801027e4:	83 f8 02             	cmp    $0x2,%eax
801027e7:	75 0c                	jne    801027f5 <iderw+0x37>
    panic("iderw: nothing to do");
801027e9:	c7 04 24 95 89 10 80 	movl   $0x80108995,(%esp)
801027f0:	e8 45 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027f5:	8b 45 08             	mov    0x8(%ebp),%eax
801027f8:	8b 40 04             	mov    0x4(%eax),%eax
801027fb:	85 c0                	test   %eax,%eax
801027fd:	74 15                	je     80102814 <iderw+0x56>
801027ff:	a1 58 b6 10 80       	mov    0x8010b658,%eax
80102804:	85 c0                	test   %eax,%eax
80102806:	75 0c                	jne    80102814 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
80102808:	c7 04 24 aa 89 10 80 	movl   $0x801089aa,(%esp)
8010280f:	e8 26 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102814:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010281b:	e8 63 29 00 00       	call   80105183 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102820:	8b 45 08             	mov    0x8(%ebp),%eax
80102823:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010282a:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
80102831:	eb 0b                	jmp    8010283e <iderw+0x80>
80102833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102836:	8b 00                	mov    (%eax),%eax
80102838:	83 c0 14             	add    $0x14,%eax
8010283b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102841:	8b 00                	mov    (%eax),%eax
80102843:	85 c0                	test   %eax,%eax
80102845:	75 ec                	jne    80102833 <iderw+0x75>
    ;
  *pp = b;
80102847:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010284a:	8b 55 08             	mov    0x8(%ebp),%edx
8010284d:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
8010284f:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102854:	3b 45 08             	cmp    0x8(%ebp),%eax
80102857:	75 22                	jne    8010287b <iderw+0xbd>
    idestart(b);
80102859:	8b 45 08             	mov    0x8(%ebp),%eax
8010285c:	89 04 24             	mov    %eax,(%esp)
8010285f:	e8 72 fd ff ff       	call   801025d6 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102864:	eb 16                	jmp    8010287c <iderw+0xbe>
    sleep(b, &idelock);
80102866:	c7 44 24 04 20 b6 10 	movl   $0x8010b620,0x4(%esp)
8010286d:	80 
8010286e:	8b 45 08             	mov    0x8(%ebp),%eax
80102871:	89 04 24             	mov    %eax,(%esp)
80102874:	e8 92 25 00 00       	call   80104e0b <sleep>
80102879:	eb 01                	jmp    8010287c <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010287b:	90                   	nop
8010287c:	8b 45 08             	mov    0x8(%ebp),%eax
8010287f:	8b 00                	mov    (%eax),%eax
80102881:	83 e0 06             	and    $0x6,%eax
80102884:	83 f8 02             	cmp    $0x2,%eax
80102887:	75 dd                	jne    80102866 <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
80102889:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102890:	e8 4f 29 00 00       	call   801051e4 <release>
}
80102895:	c9                   	leave  
80102896:	c3                   	ret    
	...

80102898 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102898:	55                   	push   %ebp
80102899:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010289b:	a1 54 f8 10 80       	mov    0x8010f854,%eax
801028a0:	8b 55 08             	mov    0x8(%ebp),%edx
801028a3:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801028a5:	a1 54 f8 10 80       	mov    0x8010f854,%eax
801028aa:	8b 40 10             	mov    0x10(%eax),%eax
}
801028ad:	5d                   	pop    %ebp
801028ae:	c3                   	ret    

801028af <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028af:	55                   	push   %ebp
801028b0:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028b2:	a1 54 f8 10 80       	mov    0x8010f854,%eax
801028b7:	8b 55 08             	mov    0x8(%ebp),%edx
801028ba:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028bc:	a1 54 f8 10 80       	mov    0x8010f854,%eax
801028c1:	8b 55 0c             	mov    0xc(%ebp),%edx
801028c4:	89 50 10             	mov    %edx,0x10(%eax)
}
801028c7:	5d                   	pop    %ebp
801028c8:	c3                   	ret    

801028c9 <ioapicinit>:

void
ioapicinit(void)
{
801028c9:	55                   	push   %ebp
801028ca:	89 e5                	mov    %esp,%ebp
801028cc:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028cf:	a1 24 f9 10 80       	mov    0x8010f924,%eax
801028d4:	85 c0                	test   %eax,%eax
801028d6:	0f 84 9f 00 00 00    	je     8010297b <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801028dc:	c7 05 54 f8 10 80 00 	movl   $0xfec00000,0x8010f854
801028e3:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028ed:	e8 a6 ff ff ff       	call   80102898 <ioapicread>
801028f2:	c1 e8 10             	shr    $0x10,%eax
801028f5:	25 ff 00 00 00       	and    $0xff,%eax
801028fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102904:	e8 8f ff ff ff       	call   80102898 <ioapicread>
80102909:	c1 e8 18             	shr    $0x18,%eax
8010290c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(id != ioapicid)
8010290f:	0f b6 05 20 f9 10 80 	movzbl 0x8010f920,%eax
80102916:	0f b6 c0             	movzbl %al,%eax
80102919:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010291c:	74 0c                	je     8010292a <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010291e:	c7 04 24 c8 89 10 80 	movl   $0x801089c8,(%esp)
80102925:	e8 70 da ff ff       	call   8010039a <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010292a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80102931:	eb 3e                	jmp    80102971 <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102933:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102936:	83 c0 20             	add    $0x20,%eax
80102939:	0d 00 00 01 00       	or     $0x10000,%eax
8010293e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102941:	83 c2 08             	add    $0x8,%edx
80102944:	01 d2                	add    %edx,%edx
80102946:	89 44 24 04          	mov    %eax,0x4(%esp)
8010294a:	89 14 24             	mov    %edx,(%esp)
8010294d:	e8 5d ff ff ff       	call   801028af <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102952:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102955:	83 c0 08             	add    $0x8,%eax
80102958:	01 c0                	add    %eax,%eax
8010295a:	83 c0 01             	add    $0x1,%eax
8010295d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102964:	00 
80102965:	89 04 24             	mov    %eax,(%esp)
80102968:	e8 42 ff ff ff       	call   801028af <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010296d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80102971:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102974:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102977:	7e ba                	jle    80102933 <ioapicinit+0x6a>
80102979:	eb 01                	jmp    8010297c <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
8010297b:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010297c:	c9                   	leave  
8010297d:	c3                   	ret    

8010297e <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010297e:	55                   	push   %ebp
8010297f:	89 e5                	mov    %esp,%ebp
80102981:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102984:	a1 24 f9 10 80       	mov    0x8010f924,%eax
80102989:	85 c0                	test   %eax,%eax
8010298b:	74 39                	je     801029c6 <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010298d:	8b 45 08             	mov    0x8(%ebp),%eax
80102990:	83 c0 20             	add    $0x20,%eax
80102993:	8b 55 08             	mov    0x8(%ebp),%edx
80102996:	83 c2 08             	add    $0x8,%edx
80102999:	01 d2                	add    %edx,%edx
8010299b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010299f:	89 14 24             	mov    %edx,(%esp)
801029a2:	e8 08 ff ff ff       	call   801028af <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801029aa:	c1 e0 18             	shl    $0x18,%eax
801029ad:	8b 55 08             	mov    0x8(%ebp),%edx
801029b0:	83 c2 08             	add    $0x8,%edx
801029b3:	01 d2                	add    %edx,%edx
801029b5:	83 c2 01             	add    $0x1,%edx
801029b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801029bc:	89 14 24             	mov    %edx,(%esp)
801029bf:	e8 eb fe ff ff       	call   801028af <ioapicwrite>
801029c4:	eb 01                	jmp    801029c7 <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
801029c6:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801029c7:	c9                   	leave  
801029c8:	c3                   	ret    
801029c9:	00 00                	add    %al,(%eax)
	...

801029cc <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029cc:	55                   	push   %ebp
801029cd:	89 e5                	mov    %esp,%ebp
801029cf:	8b 45 08             	mov    0x8(%ebp),%eax
801029d2:	2d 00 00 00 80       	sub    $0x80000000,%eax
801029d7:	5d                   	pop    %ebp
801029d8:	c3                   	ret    

801029d9 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029d9:	55                   	push   %ebp
801029da:	89 e5                	mov    %esp,%ebp
801029dc:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029df:	c7 44 24 04 fa 89 10 	movl   $0x801089fa,0x4(%esp)
801029e6:	80 
801029e7:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
801029ee:	e8 6f 27 00 00       	call   80105162 <initlock>
  kmem.use_lock = 0;
801029f3:	c7 05 94 f8 10 80 00 	movl   $0x0,0x8010f894
801029fa:	00 00 00 
  freerange(vstart, vend);
801029fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a04:	8b 45 08             	mov    0x8(%ebp),%eax
80102a07:	89 04 24             	mov    %eax,(%esp)
80102a0a:	e8 26 00 00 00       	call   80102a35 <freerange>
}
80102a0f:	c9                   	leave  
80102a10:	c3                   	ret    

80102a11 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a11:	55                   	push   %ebp
80102a12:	89 e5                	mov    %esp,%ebp
80102a14:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a17:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a1e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a21:	89 04 24             	mov    %eax,(%esp)
80102a24:	e8 0c 00 00 00       	call   80102a35 <freerange>
  kmem.use_lock = 1;
80102a29:	c7 05 94 f8 10 80 01 	movl   $0x1,0x8010f894
80102a30:	00 00 00 
}
80102a33:	c9                   	leave  
80102a34:	c3                   	ret    

80102a35 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a35:	55                   	push   %ebp
80102a36:	89 e5                	mov    %esp,%ebp
80102a38:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a3e:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a4b:	eb 12                	jmp    80102a5f <freerange+0x2a>
    kfree(p);
80102a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a50:	89 04 24             	mov    %eax,(%esp)
80102a53:	e8 19 00 00 00       	call   80102a71 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a58:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a62:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80102a68:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a6b:	39 c2                	cmp    %eax,%edx
80102a6d:	76 de                	jbe    80102a4d <freerange+0x18>
    kfree(p);
}
80102a6f:	c9                   	leave  
80102a70:	c3                   	ret    

80102a71 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a71:	55                   	push   %ebp
80102a72:	89 e5                	mov    %esp,%ebp
80102a74:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a77:	8b 45 08             	mov    0x8(%ebp),%eax
80102a7a:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a7f:	85 c0                	test   %eax,%eax
80102a81:	75 1b                	jne    80102a9e <kfree+0x2d>
80102a83:	81 7d 08 5c 2a 11 80 	cmpl   $0x80112a5c,0x8(%ebp)
80102a8a:	72 12                	jb     80102a9e <kfree+0x2d>
80102a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a8f:	89 04 24             	mov    %eax,(%esp)
80102a92:	e8 35 ff ff ff       	call   801029cc <v2p>
80102a97:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a9c:	76 0c                	jbe    80102aaa <kfree+0x39>
    panic("kfree");
80102a9e:	c7 04 24 ff 89 10 80 	movl   $0x801089ff,(%esp)
80102aa5:	e8 90 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102aaa:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102ab1:	00 
80102ab2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102ab9:	00 
80102aba:	8b 45 08             	mov    0x8(%ebp),%eax
80102abd:	89 04 24             	mov    %eax,(%esp)
80102ac0:	e8 0d 29 00 00       	call   801053d2 <memset>

  if(kmem.use_lock)
80102ac5:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102aca:	85 c0                	test   %eax,%eax
80102acc:	74 0c                	je     80102ada <kfree+0x69>
    acquire(&kmem.lock);
80102ace:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102ad5:	e8 a9 26 00 00       	call   80105183 <acquire>
  r = (struct run*)v;
80102ada:	8b 45 08             	mov    0x8(%ebp),%eax
80102add:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ae0:	8b 15 98 f8 10 80    	mov    0x8010f898,%edx
80102ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae9:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aee:	a3 98 f8 10 80       	mov    %eax,0x8010f898
  if(kmem.use_lock)
80102af3:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102af8:	85 c0                	test   %eax,%eax
80102afa:	74 0c                	je     80102b08 <kfree+0x97>
    release(&kmem.lock);
80102afc:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102b03:	e8 dc 26 00 00       	call   801051e4 <release>
}
80102b08:	c9                   	leave  
80102b09:	c3                   	ret    

80102b0a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b0a:	55                   	push   %ebp
80102b0b:	89 e5                	mov    %esp,%ebp
80102b0d:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b10:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102b15:	85 c0                	test   %eax,%eax
80102b17:	74 0c                	je     80102b25 <kalloc+0x1b>
    acquire(&kmem.lock);
80102b19:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102b20:	e8 5e 26 00 00       	call   80105183 <acquire>
  r = kmem.freelist;
80102b25:	a1 98 f8 10 80       	mov    0x8010f898,%eax
80102b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b31:	74 0a                	je     80102b3d <kalloc+0x33>
    kmem.freelist = r->next;
80102b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b36:	8b 00                	mov    (%eax),%eax
80102b38:	a3 98 f8 10 80       	mov    %eax,0x8010f898
  if(kmem.use_lock)
80102b3d:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102b42:	85 c0                	test   %eax,%eax
80102b44:	74 0c                	je     80102b52 <kalloc+0x48>
    release(&kmem.lock);
80102b46:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102b4d:	e8 92 26 00 00       	call   801051e4 <release>
  return (char*)r;
80102b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b55:	c9                   	leave  
80102b56:	c3                   	ret    
	...

80102b58 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b58:	55                   	push   %ebp
80102b59:	89 e5                	mov    %esp,%ebp
80102b5b:	83 ec 14             	sub    $0x14,%esp
80102b5e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b61:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b65:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b69:	89 c2                	mov    %eax,%edx
80102b6b:	ec                   	in     (%dx),%al
80102b6c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b6f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b73:	c9                   	leave  
80102b74:	c3                   	ret    

80102b75 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b75:	55                   	push   %ebp
80102b76:	89 e5                	mov    %esp,%ebp
80102b78:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b7b:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b82:	e8 d1 ff ff ff       	call   80102b58 <inb>
80102b87:	0f b6 c0             	movzbl %al,%eax
80102b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b90:	83 e0 01             	and    $0x1,%eax
80102b93:	85 c0                	test   %eax,%eax
80102b95:	75 0a                	jne    80102ba1 <kbdgetc+0x2c>
    return -1;
80102b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b9c:	e9 20 01 00 00       	jmp    80102cc1 <kbdgetc+0x14c>
  data = inb(KBDATAP);
80102ba1:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102ba8:	e8 ab ff ff ff       	call   80102b58 <inb>
80102bad:	0f b6 c0             	movzbl %al,%eax
80102bb0:	89 45 f8             	mov    %eax,-0x8(%ebp)

  if(data == 0xE0){
80102bb3:	81 7d f8 e0 00 00 00 	cmpl   $0xe0,-0x8(%ebp)
80102bba:	75 17                	jne    80102bd3 <kbdgetc+0x5e>
    shift |= E0ESC;
80102bbc:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102bc1:	83 c8 40             	or     $0x40,%eax
80102bc4:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102bc9:	b8 00 00 00 00       	mov    $0x0,%eax
80102bce:	e9 ee 00 00 00       	jmp    80102cc1 <kbdgetc+0x14c>
  } else if(data & 0x80){
80102bd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102bd6:	25 80 00 00 00       	and    $0x80,%eax
80102bdb:	85 c0                	test   %eax,%eax
80102bdd:	74 44                	je     80102c23 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bdf:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102be4:	83 e0 40             	and    $0x40,%eax
80102be7:	85 c0                	test   %eax,%eax
80102be9:	75 08                	jne    80102bf3 <kbdgetc+0x7e>
80102beb:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102bee:	83 e0 7f             	and    $0x7f,%eax
80102bf1:	eb 03                	jmp    80102bf6 <kbdgetc+0x81>
80102bf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102bf6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bf9:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102bfc:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102c03:	83 c8 40             	or     $0x40,%eax
80102c06:	0f b6 c0             	movzbl %al,%eax
80102c09:	f7 d0                	not    %eax
80102c0b:	89 c2                	mov    %eax,%edx
80102c0d:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c12:	21 d0                	and    %edx,%eax
80102c14:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102c19:	b8 00 00 00 00       	mov    $0x0,%eax
80102c1e:	e9 9e 00 00 00       	jmp    80102cc1 <kbdgetc+0x14c>
  } else if(shift & E0ESC){
80102c23:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c28:	83 e0 40             	and    $0x40,%eax
80102c2b:	85 c0                	test   %eax,%eax
80102c2d:	74 14                	je     80102c43 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c2f:	81 4d f8 80 00 00 00 	orl    $0x80,-0x8(%ebp)
    shift &= ~E0ESC;
80102c36:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c3b:	83 e0 bf             	and    $0xffffffbf,%eax
80102c3e:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c46:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102c4d:	0f b6 d0             	movzbl %al,%edx
80102c50:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c55:	09 d0                	or     %edx,%eax
80102c57:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102c5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c5f:	0f b6 80 20 91 10 80 	movzbl -0x7fef6ee0(%eax),%eax
80102c66:	0f b6 d0             	movzbl %al,%edx
80102c69:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c6e:	31 d0                	xor    %edx,%eax
80102c70:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c75:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c7a:	83 e0 03             	and    $0x3,%eax
80102c7d:	8b 04 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%eax
80102c84:	03 45 f8             	add    -0x8(%ebp),%eax
80102c87:	0f b6 00             	movzbl (%eax),%eax
80102c8a:	0f b6 c0             	movzbl %al,%eax
80102c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(shift & CAPSLOCK){
80102c90:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c95:	83 e0 08             	and    $0x8,%eax
80102c98:	85 c0                	test   %eax,%eax
80102c9a:	74 22                	je     80102cbe <kbdgetc+0x149>
    if('a' <= c && c <= 'z')
80102c9c:	83 7d fc 60          	cmpl   $0x60,-0x4(%ebp)
80102ca0:	76 0c                	jbe    80102cae <kbdgetc+0x139>
80102ca2:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%ebp)
80102ca6:	77 06                	ja     80102cae <kbdgetc+0x139>
      c += 'A' - 'a';
80102ca8:	83 6d fc 20          	subl   $0x20,-0x4(%ebp)

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
80102cac:	eb 10                	jmp    80102cbe <kbdgetc+0x149>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102cae:	83 7d fc 40          	cmpl   $0x40,-0x4(%ebp)
80102cb2:	76 0a                	jbe    80102cbe <kbdgetc+0x149>
80102cb4:	83 7d fc 5a          	cmpl   $0x5a,-0x4(%ebp)
80102cb8:	77 04                	ja     80102cbe <kbdgetc+0x149>
      c += 'a' - 'A';
80102cba:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
  }
  return c;
80102cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102cc1:	c9                   	leave  
80102cc2:	c3                   	ret    

80102cc3 <kbdintr>:

void
kbdintr(void)
{
80102cc3:	55                   	push   %ebp
80102cc4:	89 e5                	mov    %esp,%ebp
80102cc6:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102cc9:	c7 04 24 75 2b 10 80 	movl   $0x80102b75,(%esp)
80102cd0:	e8 d6 da ff ff       	call   801007ab <consoleintr>
}
80102cd5:	c9                   	leave  
80102cd6:	c3                   	ret    
	...

80102cd8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102cd8:	55                   	push   %ebp
80102cd9:	89 e5                	mov    %esp,%ebp
80102cdb:	83 ec 08             	sub    $0x8,%esp
80102cde:	8b 55 08             	mov    0x8(%ebp),%edx
80102ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ce4:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102ce8:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ceb:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cef:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cf3:	ee                   	out    %al,(%dx)
}
80102cf4:	c9                   	leave  
80102cf5:	c3                   	ret    

80102cf6 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102cf6:	55                   	push   %ebp
80102cf7:	89 e5                	mov    %esp,%ebp
80102cf9:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102cfc:	9c                   	pushf  
80102cfd:	58                   	pop    %eax
80102cfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d04:	c9                   	leave  
80102d05:	c3                   	ret    

80102d06 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d06:	55                   	push   %ebp
80102d07:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d09:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102d0e:	8b 55 08             	mov    0x8(%ebp),%edx
80102d11:	c1 e2 02             	shl    $0x2,%edx
80102d14:	8d 14 10             	lea    (%eax,%edx,1),%edx
80102d17:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d1a:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d1c:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102d21:	83 c0 20             	add    $0x20,%eax
80102d24:	8b 00                	mov    (%eax),%eax
}
80102d26:	5d                   	pop    %ebp
80102d27:	c3                   	ret    

80102d28 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d28:	55                   	push   %ebp
80102d29:	89 e5                	mov    %esp,%ebp
80102d2b:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d2e:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102d33:	85 c0                	test   %eax,%eax
80102d35:	0f 84 46 01 00 00    	je     80102e81 <lapicinit+0x159>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d3b:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d42:	00 
80102d43:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d4a:	e8 b7 ff ff ff       	call   80102d06 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d4f:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d56:	00 
80102d57:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d5e:	e8 a3 ff ff ff       	call   80102d06 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d63:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d6a:	00 
80102d6b:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d72:	e8 8f ff ff ff       	call   80102d06 <lapicw>
  lapicw(TICR, 10000000); 
80102d77:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d7e:	00 
80102d7f:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d86:	e8 7b ff ff ff       	call   80102d06 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d8b:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d92:	00 
80102d93:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102d9a:	e8 67 ff ff ff       	call   80102d06 <lapicw>
  lapicw(LINT1, MASKED);
80102d9f:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102da6:	00 
80102da7:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102dae:	e8 53 ff ff ff       	call   80102d06 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102db3:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102db8:	83 c0 30             	add    $0x30,%eax
80102dbb:	8b 00                	mov    (%eax),%eax
80102dbd:	c1 e8 10             	shr    $0x10,%eax
80102dc0:	25 ff 00 00 00       	and    $0xff,%eax
80102dc5:	83 f8 03             	cmp    $0x3,%eax
80102dc8:	76 14                	jbe    80102dde <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102dca:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dd1:	00 
80102dd2:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102dd9:	e8 28 ff ff ff       	call   80102d06 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102dde:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102de5:	00 
80102de6:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102ded:	e8 14 ff ff ff       	call   80102d06 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102df2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102df9:	00 
80102dfa:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e01:	e8 00 ff ff ff       	call   80102d06 <lapicw>
  lapicw(ESR, 0);
80102e06:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e0d:	00 
80102e0e:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e15:	e8 ec fe ff ff       	call   80102d06 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e21:	00 
80102e22:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e29:	e8 d8 fe ff ff       	call   80102d06 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e2e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e35:	00 
80102e36:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e3d:	e8 c4 fe ff ff       	call   80102d06 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e42:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e49:	00 
80102e4a:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e51:	e8 b0 fe ff ff       	call   80102d06 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e56:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102e5b:	05 00 03 00 00       	add    $0x300,%eax
80102e60:	8b 00                	mov    (%eax),%eax
80102e62:	25 00 10 00 00       	and    $0x1000,%eax
80102e67:	85 c0                	test   %eax,%eax
80102e69:	75 eb                	jne    80102e56 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e72:	00 
80102e73:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e7a:	e8 87 fe ff ff       	call   80102d06 <lapicw>
80102e7f:	eb 01                	jmp    80102e82 <lapicinit+0x15a>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102e81:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102e82:	c9                   	leave  
80102e83:	c3                   	ret    

80102e84 <cpunum>:

int
cpunum(void)
{
80102e84:	55                   	push   %ebp
80102e85:	89 e5                	mov    %esp,%ebp
80102e87:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e8a:	e8 67 fe ff ff       	call   80102cf6 <readeflags>
80102e8f:	25 00 02 00 00       	and    $0x200,%eax
80102e94:	85 c0                	test   %eax,%eax
80102e96:	74 29                	je     80102ec1 <cpunum+0x3d>
    static int n;
    if(n++ == 0)
80102e98:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80102e9d:	85 c0                	test   %eax,%eax
80102e9f:	0f 94 c2             	sete   %dl
80102ea2:	83 c0 01             	add    $0x1,%eax
80102ea5:	a3 60 b6 10 80       	mov    %eax,0x8010b660
80102eaa:	84 d2                	test   %dl,%dl
80102eac:	74 13                	je     80102ec1 <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
80102eae:	8b 45 04             	mov    0x4(%ebp),%eax
80102eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80102eb5:	c7 04 24 08 8a 10 80 	movl   $0x80108a08,(%esp)
80102ebc:	e8 d9 d4 ff ff       	call   8010039a <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102ec1:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102ec6:	85 c0                	test   %eax,%eax
80102ec8:	74 0f                	je     80102ed9 <cpunum+0x55>
    return lapic[ID]>>24;
80102eca:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102ecf:	83 c0 20             	add    $0x20,%eax
80102ed2:	8b 00                	mov    (%eax),%eax
80102ed4:	c1 e8 18             	shr    $0x18,%eax
80102ed7:	eb 05                	jmp    80102ede <cpunum+0x5a>
  return 0;
80102ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ede:	c9                   	leave  
80102edf:	c3                   	ret    

80102ee0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102ee6:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102eeb:	85 c0                	test   %eax,%eax
80102eed:	74 14                	je     80102f03 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102eef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ef6:	00 
80102ef7:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102efe:	e8 03 fe ff ff       	call   80102d06 <lapicw>
}
80102f03:	c9                   	leave  
80102f04:	c3                   	ret    

80102f05 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f05:	55                   	push   %ebp
80102f06:	89 e5                	mov    %esp,%ebp
}
80102f08:	5d                   	pop    %ebp
80102f09:	c3                   	ret    

80102f0a <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f0a:	55                   	push   %ebp
80102f0b:	89 e5                	mov    %esp,%ebp
80102f0d:	83 ec 1c             	sub    $0x1c,%esp
80102f10:	8b 45 08             	mov    0x8(%ebp),%eax
80102f13:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102f16:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f1d:	00 
80102f1e:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f25:	e8 ae fd ff ff       	call   80102cd8 <outb>
  outb(IO_RTC+1, 0x0A);
80102f2a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f31:	00 
80102f32:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f39:	e8 9a fd ff ff       	call   80102cd8 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f3e:	c7 45 fc 67 04 00 80 	movl   $0x80000467,-0x4(%ebp)
  wrv[0] = 0;
80102f45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f48:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f50:	8d 50 02             	lea    0x2(%eax),%edx
80102f53:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f56:	c1 e8 04             	shr    $0x4,%eax
80102f59:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f5c:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f60:	c1 e0 18             	shl    $0x18,%eax
80102f63:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f67:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f6e:	e8 93 fd ff ff       	call   80102d06 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f73:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f7a:	00 
80102f7b:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f82:	e8 7f fd ff ff       	call   80102d06 <lapicw>
  microdelay(200);
80102f87:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f8e:	e8 72 ff ff ff       	call   80102f05 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f93:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f9a:	00 
80102f9b:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fa2:	e8 5f fd ff ff       	call   80102d06 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fa7:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fae:	e8 52 ff ff ff       	call   80102f05 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fb3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80102fba:	eb 40                	jmp    80102ffc <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fbc:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fc0:	c1 e0 18             	shl    $0x18,%eax
80102fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fc7:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fce:	e8 33 fd ff ff       	call   80102d06 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fd6:	c1 e8 0c             	shr    $0xc,%eax
80102fd9:	80 cc 06             	or     $0x6,%ah
80102fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fe0:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fe7:	e8 1a fd ff ff       	call   80102d06 <lapicw>
    microdelay(200);
80102fec:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102ff3:	e8 0d ff ff ff       	call   80102f05 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102ff8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80102ffc:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
80103000:	7e ba                	jle    80102fbc <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103002:	c9                   	leave  
80103003:	c3                   	ret    

80103004 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80103004:	55                   	push   %ebp
80103005:	89 e5                	mov    %esp,%ebp
80103007:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
8010300a:	90                   	nop
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010300b:	c7 44 24 04 34 8a 10 	movl   $0x80108a34,0x4(%esp)
80103012:	80 
80103013:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010301a:	e8 43 21 00 00       	call   80105162 <initlock>
  readsb(ROOTDEV, &sb);
8010301f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103022:	89 44 24 04          	mov    %eax,0x4(%esp)
80103026:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010302d:	e8 c2 e2 ff ff       	call   801012f4 <readsb>
  log.start = sb.size - sb.nlog;
80103032:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103035:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103038:	89 d1                	mov    %edx,%ecx
8010303a:	29 c1                	sub    %eax,%ecx
8010303c:	89 c8                	mov    %ecx,%eax
8010303e:	a3 d4 f8 10 80       	mov    %eax,0x8010f8d4
  log.size = sb.nlog;
80103043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103046:	a3 d8 f8 10 80       	mov    %eax,0x8010f8d8
  log.dev = ROOTDEV;
8010304b:	c7 05 e0 f8 10 80 01 	movl   $0x1,0x8010f8e0
80103052:	00 00 00 
  recover_from_log();
80103055:	e8 97 01 00 00       	call   801031f1 <recover_from_log>
}
8010305a:	c9                   	leave  
8010305b:	c3                   	ret    

8010305c <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010305c:	55                   	push   %ebp
8010305d:	89 e5                	mov    %esp,%ebp
8010305f:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103062:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80103069:	e9 89 00 00 00       	jmp    801030f7 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010306e:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
80103073:	03 45 ec             	add    -0x14(%ebp),%eax
80103076:	83 c0 01             	add    $0x1,%eax
80103079:	89 c2                	mov    %eax,%edx
8010307b:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
80103080:	89 54 24 04          	mov    %edx,0x4(%esp)
80103084:	89 04 24             	mov    %eax,(%esp)
80103087:	e8 1b d1 ff ff       	call   801001a7 <bread>
8010308c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010308f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103092:	83 c0 10             	add    $0x10,%eax
80103095:	8b 04 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%eax
8010309c:	89 c2                	mov    %eax,%edx
8010309e:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
801030a3:	89 54 24 04          	mov    %edx,0x4(%esp)
801030a7:	89 04 24             	mov    %eax,(%esp)
801030aa:	e8 f8 d0 ff ff       	call   801001a7 <bread>
801030af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030b5:	8d 50 18             	lea    0x18(%eax),%edx
801030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030bb:	83 c0 18             	add    $0x18,%eax
801030be:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801030c5:	00 
801030c6:	89 54 24 04          	mov    %edx,0x4(%esp)
801030ca:	89 04 24             	mov    %eax,(%esp)
801030cd:	e8 d3 23 00 00       	call   801054a5 <memmove>
    bwrite(dbuf);  // write dst to disk
801030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030d5:	89 04 24             	mov    %eax,(%esp)
801030d8:	e8 01 d1 ff ff       	call   801001de <bwrite>
    brelse(lbuf); 
801030dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030e0:	89 04 24             	mov    %eax,(%esp)
801030e3:	e8 30 d1 ff ff       	call   80100218 <brelse>
    brelse(dbuf);
801030e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030eb:	89 04 24             	mov    %eax,(%esp)
801030ee:	e8 25 d1 ff ff       	call   80100218 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030f3:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801030f7:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801030fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801030ff:	0f 8f 69 ff ff ff    	jg     8010306e <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103105:	c9                   	leave  
80103106:	c3                   	ret    

80103107 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103107:	55                   	push   %ebp
80103108:	89 e5                	mov    %esp,%ebp
8010310a:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010310d:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
80103112:	89 c2                	mov    %eax,%edx
80103114:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
80103119:	89 54 24 04          	mov    %edx,0x4(%esp)
8010311d:	89 04 24             	mov    %eax,(%esp)
80103120:	e8 82 d0 ff ff       	call   801001a7 <bread>
80103125:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103128:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010312b:	83 c0 18             	add    $0x18,%eax
8010312e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  log.lh.n = lh->n;
80103131:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103134:	8b 00                	mov    (%eax),%eax
80103136:	a3 e4 f8 10 80       	mov    %eax,0x8010f8e4
  for (i = 0; i < log.lh.n; i++) {
8010313b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103142:	eb 1b                	jmp    8010315f <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103144:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103147:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010314a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010314d:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103151:	8d 51 10             	lea    0x10(%ecx),%edx
80103154:	89 04 95 a8 f8 10 80 	mov    %eax,-0x7fef0758(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010315b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010315f:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103164:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103167:	7f db                	jg     80103144 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103169:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010316c:	89 04 24             	mov    %eax,(%esp)
8010316f:	e8 a4 d0 ff ff       	call   80100218 <brelse>
}
80103174:	c9                   	leave  
80103175:	c3                   	ret    

80103176 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103176:	55                   	push   %ebp
80103177:	89 e5                	mov    %esp,%ebp
80103179:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010317c:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
80103181:	89 c2                	mov    %eax,%edx
80103183:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
80103188:	89 54 24 04          	mov    %edx,0x4(%esp)
8010318c:	89 04 24             	mov    %eax,(%esp)
8010318f:	e8 13 d0 ff ff       	call   801001a7 <bread>
80103194:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103197:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010319a:	83 c0 18             	add    $0x18,%eax
8010319d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  hb->n = log.lh.n;
801031a0:	8b 15 e4 f8 10 80    	mov    0x8010f8e4,%edx
801031a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a9:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801031ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031b2:	eb 1b                	jmp    801031cf <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801031b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031ba:	83 c0 10             	add    $0x10,%eax
801031bd:	8b 0c 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%ecx
801031c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031c7:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031cf:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801031d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031d7:	7f db                	jg     801031b4 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801031d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031dc:	89 04 24             	mov    %eax,(%esp)
801031df:	e8 fa cf ff ff       	call   801001de <bwrite>
  brelse(buf);
801031e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031e7:	89 04 24             	mov    %eax,(%esp)
801031ea:	e8 29 d0 ff ff       	call   80100218 <brelse>
}
801031ef:	c9                   	leave  
801031f0:	c3                   	ret    

801031f1 <recover_from_log>:

static void
recover_from_log(void)
{
801031f1:	55                   	push   %ebp
801031f2:	89 e5                	mov    %esp,%ebp
801031f4:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801031f7:	e8 0b ff ff ff       	call   80103107 <read_head>
  install_trans(); // if committed, copy from log to disk
801031fc:	e8 5b fe ff ff       	call   8010305c <install_trans>
  log.lh.n = 0;
80103201:	c7 05 e4 f8 10 80 00 	movl   $0x0,0x8010f8e4
80103208:	00 00 00 
  write_head(); // clear the log
8010320b:	e8 66 ff ff ff       	call   80103176 <write_head>
}
80103210:	c9                   	leave  
80103211:	c3                   	ret    

80103212 <begin_trans>:

void
begin_trans(void)
{
80103212:	55                   	push   %ebp
80103213:	89 e5                	mov    %esp,%ebp
80103215:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103218:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010321f:	e8 5f 1f 00 00       	call   80105183 <acquire>
  while (log.busy) {
80103224:	eb 14                	jmp    8010323a <begin_trans+0x28>
    sleep(&log, &log.lock);
80103226:	c7 44 24 04 a0 f8 10 	movl   $0x8010f8a0,0x4(%esp)
8010322d:	80 
8010322e:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80103235:	e8 d1 1b 00 00       	call   80104e0b <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
8010323a:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
8010323f:	85 c0                	test   %eax,%eax
80103241:	75 e3                	jne    80103226 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
80103243:	c7 05 dc f8 10 80 01 	movl   $0x1,0x8010f8dc
8010324a:	00 00 00 
  release(&log.lock);
8010324d:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80103254:	e8 8b 1f 00 00       	call   801051e4 <release>
}
80103259:	c9                   	leave  
8010325a:	c3                   	ret    

8010325b <commit_trans>:

void
commit_trans(void)
{
8010325b:	55                   	push   %ebp
8010325c:	89 e5                	mov    %esp,%ebp
8010325e:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
80103261:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103266:	85 c0                	test   %eax,%eax
80103268:	7e 19                	jle    80103283 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
8010326a:	e8 07 ff ff ff       	call   80103176 <write_head>
    install_trans(); // Now install writes to home locations
8010326f:	e8 e8 fd ff ff       	call   8010305c <install_trans>
    log.lh.n = 0; 
80103274:	c7 05 e4 f8 10 80 00 	movl   $0x0,0x8010f8e4
8010327b:	00 00 00 
    write_head();    // Erase the transaction from the log
8010327e:	e8 f3 fe ff ff       	call   80103176 <write_head>
  }
  
  acquire(&log.lock);
80103283:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010328a:	e8 f4 1e 00 00       	call   80105183 <acquire>
  log.busy = 0;
8010328f:	c7 05 dc f8 10 80 00 	movl   $0x0,0x8010f8dc
80103296:	00 00 00 
  wakeup(&log);
80103299:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801032a0:	e8 ac 1c 00 00       	call   80104f51 <wakeup>
  release(&log.lock);
801032a5:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801032ac:	e8 33 1f 00 00       	call   801051e4 <release>
}
801032b1:	c9                   	leave  
801032b2:	c3                   	ret    

801032b3 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032b3:	55                   	push   %ebp
801032b4:	89 e5                	mov    %esp,%ebp
801032b6:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032b9:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801032be:	83 f8 09             	cmp    $0x9,%eax
801032c1:	7f 12                	jg     801032d5 <log_write+0x22>
801032c3:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801032c8:	8b 15 d8 f8 10 80    	mov    0x8010f8d8,%edx
801032ce:	83 ea 01             	sub    $0x1,%edx
801032d1:	39 d0                	cmp    %edx,%eax
801032d3:	7c 0c                	jl     801032e1 <log_write+0x2e>
    panic("too big a transaction");
801032d5:	c7 04 24 38 8a 10 80 	movl   $0x80108a38,(%esp)
801032dc:	e8 59 d2 ff ff       	call   8010053a <panic>
  if (!log.busy)
801032e1:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
801032e6:	85 c0                	test   %eax,%eax
801032e8:	75 0c                	jne    801032f6 <log_write+0x43>
    panic("write outside of trans");
801032ea:	c7 04 24 4e 8a 10 80 	movl   $0x80108a4e,(%esp)
801032f1:	e8 44 d2 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
801032f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801032fd:	eb 1d                	jmp    8010331c <log_write+0x69>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103302:	83 c0 10             	add    $0x10,%eax
80103305:	8b 04 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%eax
8010330c:	89 c2                	mov    %eax,%edx
8010330e:	8b 45 08             	mov    0x8(%ebp),%eax
80103311:	8b 40 08             	mov    0x8(%eax),%eax
80103314:	39 c2                	cmp    %eax,%edx
80103316:	74 10                	je     80103328 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103318:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010331c:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103321:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103324:	7f d9                	jg     801032ff <log_write+0x4c>
80103326:	eb 01                	jmp    80103329 <log_write+0x76>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
80103328:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103329:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010332c:	8b 45 08             	mov    0x8(%ebp),%eax
8010332f:	8b 40 08             	mov    0x8(%eax),%eax
80103332:	83 c2 10             	add    $0x10,%edx
80103335:	89 04 95 a8 f8 10 80 	mov    %eax,-0x7fef0758(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
8010333c:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
80103341:	03 45 f0             	add    -0x10(%ebp),%eax
80103344:	83 c0 01             	add    $0x1,%eax
80103347:	89 c2                	mov    %eax,%edx
80103349:	8b 45 08             	mov    0x8(%ebp),%eax
8010334c:	8b 40 04             	mov    0x4(%eax),%eax
8010334f:	89 54 24 04          	mov    %edx,0x4(%esp)
80103353:	89 04 24             	mov    %eax,(%esp)
80103356:	e8 4c ce ff ff       	call   801001a7 <bread>
8010335b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
8010335e:	8b 45 08             	mov    0x8(%ebp),%eax
80103361:	8d 50 18             	lea    0x18(%eax),%edx
80103364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103367:	83 c0 18             	add    $0x18,%eax
8010336a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103371:	00 
80103372:	89 54 24 04          	mov    %edx,0x4(%esp)
80103376:	89 04 24             	mov    %eax,(%esp)
80103379:	e8 27 21 00 00       	call   801054a5 <memmove>
  bwrite(lbuf);
8010337e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103381:	89 04 24             	mov    %eax,(%esp)
80103384:	e8 55 ce ff ff       	call   801001de <bwrite>
  brelse(lbuf);
80103389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010338c:	89 04 24             	mov    %eax,(%esp)
8010338f:	e8 84 ce ff ff       	call   80100218 <brelse>
  if (i == log.lh.n)
80103394:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103399:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010339c:	75 0d                	jne    801033ab <log_write+0xf8>
    log.lh.n++;
8010339e:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801033a3:	83 c0 01             	add    $0x1,%eax
801033a6:	a3 e4 f8 10 80       	mov    %eax,0x8010f8e4
  b->flags |= B_DIRTY; // XXX prevent eviction
801033ab:	8b 45 08             	mov    0x8(%ebp),%eax
801033ae:	8b 00                	mov    (%eax),%eax
801033b0:	89 c2                	mov    %eax,%edx
801033b2:	83 ca 04             	or     $0x4,%edx
801033b5:	8b 45 08             	mov    0x8(%ebp),%eax
801033b8:	89 10                	mov    %edx,(%eax)
}
801033ba:	c9                   	leave  
801033bb:	c3                   	ret    

801033bc <v2p>:
801033bc:	55                   	push   %ebp
801033bd:	89 e5                	mov    %esp,%ebp
801033bf:	8b 45 08             	mov    0x8(%ebp),%eax
801033c2:	2d 00 00 00 80       	sub    $0x80000000,%eax
801033c7:	5d                   	pop    %ebp
801033c8:	c3                   	ret    

801033c9 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801033c9:	55                   	push   %ebp
801033ca:	89 e5                	mov    %esp,%ebp
801033cc:	8b 45 08             	mov    0x8(%ebp),%eax
801033cf:	2d 00 00 00 80       	sub    $0x80000000,%eax
801033d4:	5d                   	pop    %ebp
801033d5:	c3                   	ret    

801033d6 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801033d6:	55                   	push   %ebp
801033d7:	89 e5                	mov    %esp,%ebp
801033d9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033dc:	8b 55 08             	mov    0x8(%ebp),%edx
801033df:	8b 45 0c             	mov    0xc(%ebp),%eax
801033e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801033e5:	f0 87 02             	lock xchg %eax,(%edx)
801033e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801033eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801033ee:	c9                   	leave  
801033ef:	c3                   	ret    

801033f0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	83 e4 f0             	and    $0xfffffff0,%esp
801033f6:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033f9:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103400:	80 
80103401:	c7 04 24 5c 2a 11 80 	movl   $0x80112a5c,(%esp)
80103408:	e8 cc f5 ff ff       	call   801029d9 <kinit1>
  kvmalloc();      // kernel page table
8010340d:	e8 6d 4c 00 00       	call   8010807f <kvmalloc>
  mpinit();        // collect info about this machine
80103412:	e8 45 04 00 00       	call   8010385c <mpinit>
  lapicinit();
80103417:	e8 0c f9 ff ff       	call   80102d28 <lapicinit>
  seginit();       // set up segments
8010341c:	e8 00 46 00 00       	call   80107a21 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103421:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103427:	0f b6 00             	movzbl (%eax),%eax
8010342a:	0f b6 c0             	movzbl %al,%eax
8010342d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103431:	c7 04 24 65 8a 10 80 	movl   $0x80108a65,(%esp)
80103438:	e8 5d cf ff ff       	call   8010039a <cprintf>
  picinit();       // interrupt controller
8010343d:	e8 80 06 00 00       	call   80103ac2 <picinit>
  ioapicinit();    // another interrupt controller
80103442:	e8 82 f4 ff ff       	call   801028c9 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103447:	e8 3c d6 ff ff       	call   80100a88 <consoleinit>
  uartinit();      // serial port
8010344c:	e8 1a 39 00 00       	call   80106d6b <uartinit>
  pinit();         // process table
80103451:	e8 03 0c 00 00       	call   80104059 <pinit>
  tvinit();        // trap vectors
80103456:	e8 c3 34 00 00       	call   8010691e <tvinit>
  binit();         // buffer cache
8010345b:	e8 d4 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103460:	e8 a3 da ff ff       	call   80100f08 <fileinit>
  iinit();         // inode cache
80103465:	e8 58 e1 ff ff       	call   801015c2 <iinit>
  ideinit();       // disk
8010346a:	e8 c1 f0 ff ff       	call   80102530 <ideinit>
  if(!ismp)
8010346f:	a1 24 f9 10 80       	mov    0x8010f924,%eax
80103474:	85 c0                	test   %eax,%eax
80103476:	75 05                	jne    8010347d <main+0x8d>
    timerinit();   // uniprocessor timer
80103478:	e8 e9 33 00 00       	call   80106866 <timerinit>
  startothers();   // start other processors
8010347d:	e8 7f 00 00 00       	call   80103501 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103482:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103489:	8e 
8010348a:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103491:	e8 7b f5 ff ff       	call   80102a11 <kinit2>
  userinit();      // first user process
80103496:	e8 f1 0c 00 00       	call   8010418c <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
8010349b:	e8 1a 00 00 00       	call   801034ba <mpmain>

801034a0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801034a6:	e8 eb 4b 00 00       	call   80108096 <switchkvm>
  seginit();
801034ab:	e8 71 45 00 00       	call   80107a21 <seginit>
  lapicinit();
801034b0:	e8 73 f8 ff ff       	call   80102d28 <lapicinit>
  mpmain();
801034b5:	e8 00 00 00 00       	call   801034ba <mpmain>

801034ba <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034ba:	55                   	push   %ebp
801034bb:	89 e5                	mov    %esp,%ebp
801034bd:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801034c0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034c6:	0f b6 00             	movzbl (%eax),%eax
801034c9:	0f b6 c0             	movzbl %al,%eax
801034cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801034d0:	c7 04 24 7c 8a 10 80 	movl   $0x80108a7c,(%esp)
801034d7:	e8 be ce ff ff       	call   8010039a <cprintf>
  idtinit();       // load idt register
801034dc:	e8 ad 35 00 00       	call   80106a8e <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034e1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034e7:	05 a8 00 00 00       	add    $0xa8,%eax
801034ec:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034f3:	00 
801034f4:	89 04 24             	mov    %eax,(%esp)
801034f7:	e8 da fe ff ff       	call   801033d6 <xchg>
  scheduler();     // start running processes
801034fc:	e8 6d 15 00 00       	call   80104a6e <scheduler>

80103501 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103501:	55                   	push   %ebp
80103502:	89 e5                	mov    %esp,%ebp
80103504:	53                   	push   %ebx
80103505:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103508:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
8010350f:	e8 b5 fe ff ff       	call   801033c9 <p2v>
80103514:	89 45 ec             	mov    %eax,-0x14(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103517:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010351c:	89 44 24 08          	mov    %eax,0x8(%esp)
80103520:	c7 44 24 04 2c b5 10 	movl   $0x8010b52c,0x4(%esp)
80103527:	80 
80103528:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010352b:	89 04 24             	mov    %eax,(%esp)
8010352e:	e8 72 1f 00 00       	call   801054a5 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103533:	c7 45 f0 40 f9 10 80 	movl   $0x8010f940,-0x10(%ebp)
8010353a:	e9 85 00 00 00       	jmp    801035c4 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
8010353f:	e8 40 f9 ff ff       	call   80102e84 <cpunum>
80103544:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010354a:	05 40 f9 10 80       	add    $0x8010f940,%eax
8010354f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103552:	74 68                	je     801035bc <startothers+0xbb>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103554:	e8 b1 f5 ff ff       	call   80102b0a <kalloc>
80103559:	89 45 f4             	mov    %eax,-0xc(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010355c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010355f:	83 e8 04             	sub    $0x4,%eax
80103562:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103565:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010356b:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010356d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103570:	83 e8 08             	sub    $0x8,%eax
80103573:	c7 00 a0 34 10 80    	movl   $0x801034a0,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103579:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010357c:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010357f:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
80103586:	e8 31 fe ff ff       	call   801033bc <v2p>
8010358b:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010358d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103590:	89 04 24             	mov    %eax,(%esp)
80103593:	e8 24 fe ff ff       	call   801033bc <v2p>
80103598:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010359b:	0f b6 12             	movzbl (%edx),%edx
8010359e:	0f b6 d2             	movzbl %dl,%edx
801035a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801035a5:	89 14 24             	mov    %edx,(%esp)
801035a8:	e8 5d f9 ff ff       	call   80102f0a <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035b0:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801035b6:	85 c0                	test   %eax,%eax
801035b8:	74 f3                	je     801035ad <startothers+0xac>
801035ba:	eb 01                	jmp    801035bd <startothers+0xbc>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801035bc:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801035bd:	81 45 f0 bc 00 00 00 	addl   $0xbc,-0x10(%ebp)
801035c4:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801035c9:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035cf:	05 40 f9 10 80       	add    $0x8010f940,%eax
801035d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801035d7:	0f 87 62 ff ff ff    	ja     8010353f <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801035dd:	83 c4 24             	add    $0x24,%esp
801035e0:	5b                   	pop    %ebx
801035e1:	5d                   	pop    %ebp
801035e2:	c3                   	ret    
	...

801035e4 <p2v>:
801035e4:	55                   	push   %ebp
801035e5:	89 e5                	mov    %esp,%ebp
801035e7:	8b 45 08             	mov    0x8(%ebp),%eax
801035ea:	2d 00 00 00 80       	sub    $0x80000000,%eax
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    

801035f1 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801035f1:	55                   	push   %ebp
801035f2:	89 e5                	mov    %esp,%ebp
801035f4:	83 ec 14             	sub    $0x14,%esp
801035f7:	8b 45 08             	mov    0x8(%ebp),%eax
801035fa:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035fe:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103602:	89 c2                	mov    %eax,%edx
80103604:	ec                   	in     (%dx),%al
80103605:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103608:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010360c:	c9                   	leave  
8010360d:	c3                   	ret    

8010360e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010360e:	55                   	push   %ebp
8010360f:	89 e5                	mov    %esp,%ebp
80103611:	83 ec 08             	sub    $0x8,%esp
80103614:	8b 55 08             	mov    0x8(%ebp),%edx
80103617:	8b 45 0c             	mov    0xc(%ebp),%eax
8010361a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010361e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103621:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103625:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103629:	ee                   	out    %al,(%dx)
}
8010362a:	c9                   	leave  
8010362b:	c3                   	ret    

8010362c <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
8010362c:	55                   	push   %ebp
8010362d:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
8010362f:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80103634:	89 c2                	mov    %eax,%edx
80103636:	b8 40 f9 10 80       	mov    $0x8010f940,%eax
8010363b:	89 d1                	mov    %edx,%ecx
8010363d:	29 c1                	sub    %eax,%ecx
8010363f:	89 c8                	mov    %ecx,%eax
80103641:	c1 f8 02             	sar    $0x2,%eax
80103644:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
8010364a:	5d                   	pop    %ebp
8010364b:	c3                   	ret    

8010364c <sum>:

static uchar
sum(uchar *addr, int len)
{
8010364c:	55                   	push   %ebp
8010364d:	89 e5                	mov    %esp,%ebp
8010364f:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103652:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(i=0; i<len; i++)
80103659:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80103660:	eb 13                	jmp    80103675 <sum+0x29>
    sum += addr[i];
80103662:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103665:	03 45 08             	add    0x8(%ebp),%eax
80103668:	0f b6 00             	movzbl (%eax),%eax
8010366b:	0f b6 c0             	movzbl %al,%eax
8010366e:	01 45 fc             	add    %eax,-0x4(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103671:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80103675:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103678:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010367b:	7c e5                	jl     80103662 <sum+0x16>
    sum += addr[i];
  return sum;
8010367d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103680:	c9                   	leave  
80103681:	c3                   	ret    

80103682 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103682:	55                   	push   %ebp
80103683:	89 e5                	mov    %esp,%ebp
80103685:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103688:	8b 45 08             	mov    0x8(%ebp),%eax
8010368b:	89 04 24             	mov    %eax,(%esp)
8010368e:	e8 51 ff ff ff       	call   801035e4 <p2v>
80103693:	89 45 f4             	mov    %eax,-0xc(%ebp)
  e = addr+len;
80103696:	8b 45 0c             	mov    0xc(%ebp),%eax
80103699:	03 45 f4             	add    -0xc(%ebp),%eax
8010369c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
8010369f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801036a5:	eb 3f                	jmp    801036e6 <mpsearch1+0x64>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036a7:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801036ae:	00 
801036af:	c7 44 24 04 90 8a 10 	movl   $0x80108a90,0x4(%esp)
801036b6:	80 
801036b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036ba:	89 04 24             	mov    %eax,(%esp)
801036bd:	e8 87 1d 00 00       	call   80105449 <memcmp>
801036c2:	85 c0                	test   %eax,%eax
801036c4:	75 1c                	jne    801036e2 <mpsearch1+0x60>
801036c6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801036cd:	00 
801036ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036d1:	89 04 24             	mov    %eax,(%esp)
801036d4:	e8 73 ff ff ff       	call   8010364c <sum>
801036d9:	84 c0                	test   %al,%al
801036db:	75 05                	jne    801036e2 <mpsearch1+0x60>
      return (struct mp*)p;
801036dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036e0:	eb 11                	jmp    801036f3 <mpsearch1+0x71>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801036e2:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
801036e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801036ec:	72 b9                	jb     801036a7 <mpsearch1+0x25>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801036ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801036f3:	c9                   	leave  
801036f4:	c3                   	ret    

801036f5 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801036f5:	55                   	push   %ebp
801036f6:	89 e5                	mov    %esp,%ebp
801036f8:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801036fb:	c7 45 ec 00 04 00 80 	movl   $0x80000400,-0x14(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103702:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103705:	83 c0 0f             	add    $0xf,%eax
80103708:	0f b6 00             	movzbl (%eax),%eax
8010370b:	0f b6 c0             	movzbl %al,%eax
8010370e:	89 c2                	mov    %eax,%edx
80103710:	c1 e2 08             	shl    $0x8,%edx
80103713:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103716:	83 c0 0e             	add    $0xe,%eax
80103719:	0f b6 00             	movzbl (%eax),%eax
8010371c:	0f b6 c0             	movzbl %al,%eax
8010371f:	09 d0                	or     %edx,%eax
80103721:	c1 e0 04             	shl    $0x4,%eax
80103724:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103727:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010372b:	74 21                	je     8010374e <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
8010372d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103734:	00 
80103735:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103738:	89 04 24             	mov    %eax,(%esp)
8010373b:	e8 42 ff ff ff       	call   80103682 <mpsearch1>
80103740:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103747:	74 50                	je     80103799 <mpsearch+0xa4>
      return mp;
80103749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010374c:	eb 5f                	jmp    801037ad <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
8010374e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103751:	83 c0 14             	add    $0x14,%eax
80103754:	0f b6 00             	movzbl (%eax),%eax
80103757:	0f b6 c0             	movzbl %al,%eax
8010375a:	89 c2                	mov    %eax,%edx
8010375c:	c1 e2 08             	shl    $0x8,%edx
8010375f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103762:	83 c0 13             	add    $0x13,%eax
80103765:	0f b6 00             	movzbl (%eax),%eax
80103768:	0f b6 c0             	movzbl %al,%eax
8010376b:	09 d0                	or     %edx,%eax
8010376d:	c1 e0 0a             	shl    $0xa,%eax
80103770:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103773:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103776:	2d 00 04 00 00       	sub    $0x400,%eax
8010377b:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103782:	00 
80103783:	89 04 24             	mov    %eax,(%esp)
80103786:	e8 f7 fe ff ff       	call   80103682 <mpsearch1>
8010378b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010378e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103792:	74 05                	je     80103799 <mpsearch+0xa4>
      return mp;
80103794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103797:	eb 14                	jmp    801037ad <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103799:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801037a0:	00 
801037a1:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
801037a8:	e8 d5 fe ff ff       	call   80103682 <mpsearch1>
}
801037ad:	c9                   	leave  
801037ae:	c3                   	ret    

801037af <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037af:	55                   	push   %ebp
801037b0:	89 e5                	mov    %esp,%ebp
801037b2:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037b5:	e8 3b ff ff ff       	call   801036f5 <mpsearch>
801037ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037c1:	74 0a                	je     801037cd <mpconfig+0x1e>
801037c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037c6:	8b 40 04             	mov    0x4(%eax),%eax
801037c9:	85 c0                	test   %eax,%eax
801037cb:	75 0a                	jne    801037d7 <mpconfig+0x28>
    return 0;
801037cd:	b8 00 00 00 00       	mov    $0x0,%eax
801037d2:	e9 83 00 00 00       	jmp    8010385a <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801037d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037da:	8b 40 04             	mov    0x4(%eax),%eax
801037dd:	89 04 24             	mov    %eax,(%esp)
801037e0:	e8 ff fd ff ff       	call   801035e4 <p2v>
801037e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037e8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801037ef:	00 
801037f0:	c7 44 24 04 95 8a 10 	movl   $0x80108a95,0x4(%esp)
801037f7:	80 
801037f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037fb:	89 04 24             	mov    %eax,(%esp)
801037fe:	e8 46 1c 00 00       	call   80105449 <memcmp>
80103803:	85 c0                	test   %eax,%eax
80103805:	74 07                	je     8010380e <mpconfig+0x5f>
    return 0;
80103807:	b8 00 00 00 00       	mov    $0x0,%eax
8010380c:	eb 4c                	jmp    8010385a <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
8010380e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103811:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103815:	3c 01                	cmp    $0x1,%al
80103817:	74 12                	je     8010382b <mpconfig+0x7c>
80103819:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010381c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103820:	3c 04                	cmp    $0x4,%al
80103822:	74 07                	je     8010382b <mpconfig+0x7c>
    return 0;
80103824:	b8 00 00 00 00       	mov    $0x0,%eax
80103829:	eb 2f                	jmp    8010385a <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
8010382b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010382e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103832:	0f b7 d0             	movzwl %ax,%edx
80103835:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103838:	89 54 24 04          	mov    %edx,0x4(%esp)
8010383c:	89 04 24             	mov    %eax,(%esp)
8010383f:	e8 08 fe ff ff       	call   8010364c <sum>
80103844:	84 c0                	test   %al,%al
80103846:	74 07                	je     8010384f <mpconfig+0xa0>
    return 0;
80103848:	b8 00 00 00 00       	mov    $0x0,%eax
8010384d:	eb 0b                	jmp    8010385a <mpconfig+0xab>
  *pmp = mp;
8010384f:	8b 45 08             	mov    0x8(%ebp),%eax
80103852:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103855:	89 10                	mov    %edx,(%eax)
  return conf;
80103857:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010385a:	c9                   	leave  
8010385b:	c3                   	ret    

8010385c <mpinit>:

void
mpinit(void)
{
8010385c:	55                   	push   %ebp
8010385d:	89 e5                	mov    %esp,%ebp
8010385f:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103862:	c7 05 64 b6 10 80 40 	movl   $0x8010f940,0x8010b664
80103869:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
8010386c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010386f:	89 04 24             	mov    %eax,(%esp)
80103872:	e8 38 ff ff ff       	call   801037af <mpconfig>
80103877:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010387a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010387e:	0f 84 9d 01 00 00    	je     80103a21 <mpinit+0x1c5>
    return;
  ismp = 1;
80103884:	c7 05 24 f9 10 80 01 	movl   $0x1,0x8010f924
8010388b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010388e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103891:	8b 40 24             	mov    0x24(%eax),%eax
80103894:	a3 9c f8 10 80       	mov    %eax,0x8010f89c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103899:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010389c:	83 c0 2c             	add    $0x2c,%eax
8010389f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801038a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038a8:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801038ac:	0f b7 c0             	movzwl %ax,%eax
801038af:	8d 04 02             	lea    (%edx,%eax,1),%eax
801038b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
801038b5:	e9 f2 00 00 00       	jmp    801039ac <mpinit+0x150>
    switch(*p){
801038ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801038bd:	0f b6 00             	movzbl (%eax),%eax
801038c0:	0f b6 c0             	movzbl %al,%eax
801038c3:	83 f8 04             	cmp    $0x4,%eax
801038c6:	0f 87 bd 00 00 00    	ja     80103989 <mpinit+0x12d>
801038cc:	8b 04 85 d8 8a 10 80 	mov    -0x7fef7528(,%eax,4),%eax
801038d3:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801038d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(ncpu != proc->apicid){
801038db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038de:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038e2:	0f b6 d0             	movzbl %al,%edx
801038e5:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801038ea:	39 c2                	cmp    %eax,%edx
801038ec:	74 2d                	je     8010391b <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801038ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038f1:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038f5:	0f b6 d0             	movzbl %al,%edx
801038f8:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801038fd:	89 54 24 08          	mov    %edx,0x8(%esp)
80103901:	89 44 24 04          	mov    %eax,0x4(%esp)
80103905:	c7 04 24 9a 8a 10 80 	movl   $0x80108a9a,(%esp)
8010390c:	e8 89 ca ff ff       	call   8010039a <cprintf>
        ismp = 0;
80103911:	c7 05 24 f9 10 80 00 	movl   $0x0,0x8010f924
80103918:	00 00 00 
      }
      if(proc->flags & MPBOOT)
8010391b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010391e:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103922:	0f b6 c0             	movzbl %al,%eax
80103925:	83 e0 02             	and    $0x2,%eax
80103928:	85 c0                	test   %eax,%eax
8010392a:	74 15                	je     80103941 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
8010392c:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
80103931:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103937:	05 40 f9 10 80       	add    $0x8010f940,%eax
8010393c:	a3 64 b6 10 80       	mov    %eax,0x8010b664
      cpus[ncpu].id = ncpu;
80103941:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
80103946:	8b 15 20 ff 10 80    	mov    0x8010ff20,%edx
8010394c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103952:	88 90 40 f9 10 80    	mov    %dl,-0x7fef06c0(%eax)
      ncpu++;
80103958:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
8010395d:	83 c0 01             	add    $0x1,%eax
80103960:	a3 20 ff 10 80       	mov    %eax,0x8010ff20
      p += sizeof(struct mpproc);
80103965:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
      continue;
80103969:	eb 41                	jmp    801039ac <mpinit+0x150>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010396b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010396e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      ioapicid = ioapic->apicno;
80103971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103974:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103978:	a2 20 f9 10 80       	mov    %al,0x8010f920
      p += sizeof(struct mpioapic);
8010397d:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
80103981:	eb 29                	jmp    801039ac <mpinit+0x150>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103983:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
80103987:	eb 23                	jmp    801039ac <mpinit+0x150>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103989:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010398c:	0f b6 00             	movzbl (%eax),%eax
8010398f:	0f b6 c0             	movzbl %al,%eax
80103992:	89 44 24 04          	mov    %eax,0x4(%esp)
80103996:	c7 04 24 b8 8a 10 80 	movl   $0x80108ab8,(%esp)
8010399d:	e8 f8 c9 ff ff       	call   8010039a <cprintf>
      ismp = 0;
801039a2:	c7 05 24 f9 10 80 00 	movl   $0x0,0x8010f924
801039a9:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039af:	3b 45 e8             	cmp    -0x18(%ebp),%eax
801039b2:	0f 82 02 ff ff ff    	jb     801038ba <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801039b8:	a1 24 f9 10 80       	mov    0x8010f924,%eax
801039bd:	85 c0                	test   %eax,%eax
801039bf:	75 1d                	jne    801039de <mpinit+0x182>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039c1:	c7 05 20 ff 10 80 01 	movl   $0x1,0x8010ff20
801039c8:	00 00 00 
    lapic = 0;
801039cb:	c7 05 9c f8 10 80 00 	movl   $0x0,0x8010f89c
801039d2:	00 00 00 
    ioapicid = 0;
801039d5:	c6 05 20 f9 10 80 00 	movb   $0x0,0x8010f920
    return;
801039dc:	eb 44                	jmp    80103a22 <mpinit+0x1c6>
  }

  if(mp->imcrp){
801039de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801039e1:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801039e5:	84 c0                	test   %al,%al
801039e7:	74 39                	je     80103a22 <mpinit+0x1c6>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801039e9:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
801039f0:	00 
801039f1:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
801039f8:	e8 11 fc ff ff       	call   8010360e <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039fd:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a04:	e8 e8 fb ff ff       	call   801035f1 <inb>
80103a09:	83 c8 01             	or     $0x1,%eax
80103a0c:	0f b6 c0             	movzbl %al,%eax
80103a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a13:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a1a:	e8 ef fb ff ff       	call   8010360e <outb>
80103a1f:	eb 01                	jmp    80103a22 <mpinit+0x1c6>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103a21:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103a22:	c9                   	leave  
80103a23:	c3                   	ret    

80103a24 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	83 ec 08             	sub    $0x8,%esp
80103a2a:	8b 55 08             	mov    0x8(%ebp),%edx
80103a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a30:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a34:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a37:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a3b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a3f:	ee                   	out    %al,(%dx)
}
80103a40:	c9                   	leave  
80103a41:	c3                   	ret    

80103a42 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a42:	55                   	push   %ebp
80103a43:	89 e5                	mov    %esp,%ebp
80103a45:	83 ec 0c             	sub    $0xc,%esp
80103a48:	8b 45 08             	mov    0x8(%ebp),%eax
80103a4b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a4f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a53:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103a59:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a5d:	0f b6 c0             	movzbl %al,%eax
80103a60:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a64:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a6b:	e8 b4 ff ff ff       	call   80103a24 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103a70:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a74:	66 c1 e8 08          	shr    $0x8,%ax
80103a78:	0f b6 c0             	movzbl %al,%eax
80103a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a7f:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103a86:	e8 99 ff ff ff       	call   80103a24 <outb>
}
80103a8b:	c9                   	leave  
80103a8c:	c3                   	ret    

80103a8d <picenable>:

void
picenable(int irq)
{
80103a8d:	55                   	push   %ebp
80103a8e:	89 e5                	mov    %esp,%ebp
80103a90:	53                   	push   %ebx
80103a91:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103a94:	8b 45 08             	mov    0x8(%ebp),%eax
80103a97:	ba 01 00 00 00       	mov    $0x1,%edx
80103a9c:	89 d3                	mov    %edx,%ebx
80103a9e:	89 c1                	mov    %eax,%ecx
80103aa0:	d3 e3                	shl    %cl,%ebx
80103aa2:	89 d8                	mov    %ebx,%eax
80103aa4:	89 c2                	mov    %eax,%edx
80103aa6:	f7 d2                	not    %edx
80103aa8:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103aaf:	21 d0                	and    %edx,%eax
80103ab1:	0f b7 c0             	movzwl %ax,%eax
80103ab4:	89 04 24             	mov    %eax,(%esp)
80103ab7:	e8 86 ff ff ff       	call   80103a42 <picsetmask>
}
80103abc:	83 c4 04             	add    $0x4,%esp
80103abf:	5b                   	pop    %ebx
80103ac0:	5d                   	pop    %ebp
80103ac1:	c3                   	ret    

80103ac2 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ac2:	55                   	push   %ebp
80103ac3:	89 e5                	mov    %esp,%ebp
80103ac5:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ac8:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103acf:	00 
80103ad0:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ad7:	e8 48 ff ff ff       	call   80103a24 <outb>
  outb(IO_PIC2+1, 0xFF);
80103adc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ae3:	00 
80103ae4:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103aeb:	e8 34 ff ff ff       	call   80103a24 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103af0:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103af7:	00 
80103af8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103aff:	e8 20 ff ff ff       	call   80103a24 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103b04:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103b0b:	00 
80103b0c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b13:	e8 0c ff ff ff       	call   80103a24 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b18:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b1f:	00 
80103b20:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b27:	e8 f8 fe ff ff       	call   80103a24 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b2c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b33:	00 
80103b34:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b3b:	e8 e4 fe ff ff       	call   80103a24 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b40:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b47:	00 
80103b48:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b4f:	e8 d0 fe ff ff       	call   80103a24 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b54:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b5b:	00 
80103b5c:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b63:	e8 bc fe ff ff       	call   80103a24 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b68:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b6f:	00 
80103b70:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b77:	e8 a8 fe ff ff       	call   80103a24 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103b7c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b83:	00 
80103b84:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b8b:	e8 94 fe ff ff       	call   80103a24 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103b90:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103b97:	00 
80103b98:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b9f:	e8 80 fe ff ff       	call   80103a24 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103ba4:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bab:	00 
80103bac:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bb3:	e8 6c fe ff ff       	call   80103a24 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103bb8:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bbf:	00 
80103bc0:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bc7:	e8 58 fe ff ff       	call   80103a24 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103bcc:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bd3:	00 
80103bd4:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bdb:	e8 44 fe ff ff       	call   80103a24 <outb>

  if(irqmask != 0xFFFF)
80103be0:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103be7:	66 83 f8 ff          	cmp    $0xffffffff,%ax
80103beb:	74 12                	je     80103bff <picinit+0x13d>
    picsetmask(irqmask);
80103bed:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103bf4:	0f b7 c0             	movzwl %ax,%eax
80103bf7:	89 04 24             	mov    %eax,(%esp)
80103bfa:	e8 43 fe ff ff       	call   80103a42 <picsetmask>
}
80103bff:	c9                   	leave  
80103c00:	c3                   	ret    
80103c01:	00 00                	add    %al,(%eax)
	...

80103c04 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c04:	55                   	push   %ebp
80103c05:	89 e5                	mov    %esp,%ebp
80103c07:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103c0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c11:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c1d:	8b 10                	mov    (%eax),%edx
80103c1f:	8b 45 08             	mov    0x8(%ebp),%eax
80103c22:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c24:	e8 fb d2 ff ff       	call   80100f24 <filealloc>
80103c29:	8b 55 08             	mov    0x8(%ebp),%edx
80103c2c:	89 02                	mov    %eax,(%edx)
80103c2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103c31:	8b 00                	mov    (%eax),%eax
80103c33:	85 c0                	test   %eax,%eax
80103c35:	0f 84 c8 00 00 00    	je     80103d03 <pipealloc+0xff>
80103c3b:	e8 e4 d2 ff ff       	call   80100f24 <filealloc>
80103c40:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c43:	89 02                	mov    %eax,(%edx)
80103c45:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c48:	8b 00                	mov    (%eax),%eax
80103c4a:	85 c0                	test   %eax,%eax
80103c4c:	0f 84 b1 00 00 00    	je     80103d03 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c52:	e8 b3 ee ff ff       	call   80102b0a <kalloc>
80103c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c5e:	0f 84 9e 00 00 00    	je     80103d02 <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c67:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c6e:	00 00 00 
  p->writeopen = 1;
80103c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c74:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c7b:	00 00 00 
  p->nwrite = 0;
80103c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c81:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c88:	00 00 00 
  p->nread = 0;
80103c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c8e:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c95:	00 00 00 
  initlock(&p->lock, "pipe");
80103c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c9b:	c7 44 24 04 ec 8a 10 	movl   $0x80108aec,0x4(%esp)
80103ca2:	80 
80103ca3:	89 04 24             	mov    %eax,(%esp)
80103ca6:	e8 b7 14 00 00       	call   80105162 <initlock>
  (*f0)->type = FD_PIPE;
80103cab:	8b 45 08             	mov    0x8(%ebp),%eax
80103cae:	8b 00                	mov    (%eax),%eax
80103cb0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb9:	8b 00                	mov    (%eax),%eax
80103cbb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103cbf:	8b 45 08             	mov    0x8(%ebp),%eax
80103cc2:	8b 00                	mov    (%eax),%eax
80103cc4:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ccb:	8b 00                	mov    (%eax),%eax
80103ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cd0:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cd6:	8b 00                	mov    (%eax),%eax
80103cd8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103cde:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ce1:	8b 00                	mov    (%eax),%eax
80103ce3:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cea:	8b 00                	mov    (%eax),%eax
80103cec:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cf3:	8b 00                	mov    (%eax),%eax
80103cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cf8:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103cfb:	b8 00 00 00 00       	mov    $0x0,%eax
80103d00:	eb 43                	jmp    80103d45 <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103d02:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d07:	74 0b                	je     80103d14 <pipealloc+0x110>
    kfree((char*)p);
80103d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d0c:	89 04 24             	mov    %eax,(%esp)
80103d0f:	e8 5d ed ff ff       	call   80102a71 <kfree>
  if(*f0)
80103d14:	8b 45 08             	mov    0x8(%ebp),%eax
80103d17:	8b 00                	mov    (%eax),%eax
80103d19:	85 c0                	test   %eax,%eax
80103d1b:	74 0d                	je     80103d2a <pipealloc+0x126>
    fileclose(*f0);
80103d1d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d20:	8b 00                	mov    (%eax),%eax
80103d22:	89 04 24             	mov    %eax,(%esp)
80103d25:	e8 a3 d2 ff ff       	call   80100fcd <fileclose>
  if(*f1)
80103d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d2d:	8b 00                	mov    (%eax),%eax
80103d2f:	85 c0                	test   %eax,%eax
80103d31:	74 0d                	je     80103d40 <pipealloc+0x13c>
    fileclose(*f1);
80103d33:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d36:	8b 00                	mov    (%eax),%eax
80103d38:	89 04 24             	mov    %eax,(%esp)
80103d3b:	e8 8d d2 ff ff       	call   80100fcd <fileclose>
  return -1;
80103d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d45:	c9                   	leave  
80103d46:	c3                   	ret    

80103d47 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d47:	55                   	push   %ebp
80103d48:	89 e5                	mov    %esp,%ebp
80103d4a:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d4d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d50:	89 04 24             	mov    %eax,(%esp)
80103d53:	e8 2b 14 00 00       	call   80105183 <acquire>
  if(writable){
80103d58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d5c:	74 1f                	je     80103d7d <pipeclose+0x36>
    p->writeopen = 0;
80103d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103d61:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d68:	00 00 00 
    wakeup(&p->nread);
80103d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6e:	05 34 02 00 00       	add    $0x234,%eax
80103d73:	89 04 24             	mov    %eax,(%esp)
80103d76:	e8 d6 11 00 00       	call   80104f51 <wakeup>
80103d7b:	eb 1d                	jmp    80103d9a <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d80:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103d87:	00 00 00 
    wakeup(&p->nwrite);
80103d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8d:	05 38 02 00 00       	add    $0x238,%eax
80103d92:	89 04 24             	mov    %eax,(%esp)
80103d95:	e8 b7 11 00 00       	call   80104f51 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9d:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103da3:	85 c0                	test   %eax,%eax
80103da5:	75 25                	jne    80103dcc <pipeclose+0x85>
80103da7:	8b 45 08             	mov    0x8(%ebp),%eax
80103daa:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103db0:	85 c0                	test   %eax,%eax
80103db2:	75 18                	jne    80103dcc <pipeclose+0x85>
    release(&p->lock);
80103db4:	8b 45 08             	mov    0x8(%ebp),%eax
80103db7:	89 04 24             	mov    %eax,(%esp)
80103dba:	e8 25 14 00 00       	call   801051e4 <release>
    kfree((char*)p);
80103dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc2:	89 04 24             	mov    %eax,(%esp)
80103dc5:	e8 a7 ec ff ff       	call   80102a71 <kfree>
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dca:	eb 0b                	jmp    80103dd7 <pipeclose+0x90>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80103dcf:	89 04 24             	mov    %eax,(%esp)
80103dd2:	e8 0d 14 00 00       	call   801051e4 <release>
}
80103dd7:	c9                   	leave  
80103dd8:	c3                   	ret    

80103dd9 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103dd9:	55                   	push   %ebp
80103dda:	89 e5                	mov    %esp,%ebp
80103ddc:	53                   	push   %ebx
80103ddd:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103de0:	8b 45 08             	mov    0x8(%ebp),%eax
80103de3:	89 04 24             	mov    %eax,(%esp)
80103de6:	e8 98 13 00 00       	call   80105183 <acquire>
  for(i = 0; i < n; i++){
80103deb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103df2:	e9 a6 00 00 00       	jmp    80103e9d <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103df7:	8b 45 08             	mov    0x8(%ebp),%eax
80103dfa:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e00:	85 c0                	test   %eax,%eax
80103e02:	74 0d                	je     80103e11 <pipewrite+0x38>
80103e04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e0a:	8b 40 24             	mov    0x24(%eax),%eax
80103e0d:	85 c0                	test   %eax,%eax
80103e0f:	74 15                	je     80103e26 <pipewrite+0x4d>
        release(&p->lock);
80103e11:	8b 45 08             	mov    0x8(%ebp),%eax
80103e14:	89 04 24             	mov    %eax,(%esp)
80103e17:	e8 c8 13 00 00       	call   801051e4 <release>
        return -1;
80103e1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e21:	e9 9d 00 00 00       	jmp    80103ec3 <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e26:	8b 45 08             	mov    0x8(%ebp),%eax
80103e29:	05 34 02 00 00       	add    $0x234,%eax
80103e2e:	89 04 24             	mov    %eax,(%esp)
80103e31:	e8 1b 11 00 00       	call   80104f51 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e36:	8b 45 08             	mov    0x8(%ebp),%eax
80103e39:	8b 55 08             	mov    0x8(%ebp),%edx
80103e3c:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e42:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e46:	89 14 24             	mov    %edx,(%esp)
80103e49:	e8 bd 0f 00 00       	call   80104e0b <sleep>
80103e4e:	eb 01                	jmp    80103e51 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e50:	90                   	nop
80103e51:	8b 45 08             	mov    0x8(%ebp),%eax
80103e54:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e5a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e5d:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e63:	05 00 02 00 00       	add    $0x200,%eax
80103e68:	39 c2                	cmp    %eax,%edx
80103e6a:	74 8b                	je     80103df7 <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e6c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e75:	89 c3                	mov    %eax,%ebx
80103e77:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103e7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e80:	03 55 0c             	add    0xc(%ebp),%edx
80103e83:	0f b6 0a             	movzbl (%edx),%ecx
80103e86:	8b 55 08             	mov    0x8(%ebp),%edx
80103e89:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103e8d:	8d 50 01             	lea    0x1(%eax),%edx
80103e90:	8b 45 08             	mov    0x8(%ebp),%eax
80103e93:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103e99:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ea0:	3b 45 10             	cmp    0x10(%ebp),%eax
80103ea3:	7c ab                	jl     80103e50 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ea5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea8:	05 34 02 00 00       	add    $0x234,%eax
80103ead:	89 04 24             	mov    %eax,(%esp)
80103eb0:	e8 9c 10 00 00       	call   80104f51 <wakeup>
  release(&p->lock);
80103eb5:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb8:	89 04 24             	mov    %eax,(%esp)
80103ebb:	e8 24 13 00 00       	call   801051e4 <release>
  return n;
80103ec0:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103ec3:	83 c4 24             	add    $0x24,%esp
80103ec6:	5b                   	pop    %ebx
80103ec7:	5d                   	pop    %ebp
80103ec8:	c3                   	ret    

80103ec9 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ec9:	55                   	push   %ebp
80103eca:	89 e5                	mov    %esp,%ebp
80103ecc:	53                   	push   %ebx
80103ecd:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed3:	89 04 24             	mov    %eax,(%esp)
80103ed6:	e8 a8 12 00 00       	call   80105183 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103edb:	eb 3a                	jmp    80103f17 <piperead+0x4e>
    if(proc->killed){
80103edd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ee3:	8b 40 24             	mov    0x24(%eax),%eax
80103ee6:	85 c0                	test   %eax,%eax
80103ee8:	74 15                	je     80103eff <piperead+0x36>
      release(&p->lock);
80103eea:	8b 45 08             	mov    0x8(%ebp),%eax
80103eed:	89 04 24             	mov    %eax,(%esp)
80103ef0:	e8 ef 12 00 00       	call   801051e4 <release>
      return -1;
80103ef5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103efa:	e9 b6 00 00 00       	jmp    80103fb5 <piperead+0xec>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103eff:	8b 45 08             	mov    0x8(%ebp),%eax
80103f02:	8b 55 08             	mov    0x8(%ebp),%edx
80103f05:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f0f:	89 14 24             	mov    %edx,(%esp)
80103f12:	e8 f4 0e 00 00       	call   80104e0b <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f17:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f20:	8b 45 08             	mov    0x8(%ebp),%eax
80103f23:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f29:	39 c2                	cmp    %eax,%edx
80103f2b:	75 0d                	jne    80103f3a <piperead+0x71>
80103f2d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f30:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f36:	85 c0                	test   %eax,%eax
80103f38:	75 a3                	jne    80103edd <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f41:	eb 49                	jmp    80103f8c <piperead+0xc3>
    if(p->nread == p->nwrite)
80103f43:	8b 45 08             	mov    0x8(%ebp),%eax
80103f46:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f4c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f55:	39 c2                	cmp    %eax,%edx
80103f57:	74 3d                	je     80103f96 <piperead+0xcd>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f5c:	89 c2                	mov    %eax,%edx
80103f5e:	03 55 0c             	add    0xc(%ebp),%edx
80103f61:	8b 45 08             	mov    0x8(%ebp),%eax
80103f64:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f6a:	89 c3                	mov    %eax,%ebx
80103f6c:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103f72:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103f75:	0f b6 4c 19 34       	movzbl 0x34(%ecx,%ebx,1),%ecx
80103f7a:	88 0a                	mov    %cl,(%edx)
80103f7c:	8d 50 01             	lea    0x1(%eax),%edx
80103f7f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f82:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f88:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f8f:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f92:	7c af                	jl     80103f43 <piperead+0x7a>
80103f94:	eb 01                	jmp    80103f97 <piperead+0xce>
    if(p->nread == p->nwrite)
      break;
80103f96:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f97:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9a:	05 38 02 00 00       	add    $0x238,%eax
80103f9f:	89 04 24             	mov    %eax,(%esp)
80103fa2:	e8 aa 0f 00 00       	call   80104f51 <wakeup>
  release(&p->lock);
80103fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80103faa:	89 04 24             	mov    %eax,(%esp)
80103fad:	e8 32 12 00 00       	call   801051e4 <release>
  return i;
80103fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103fb5:	83 c4 24             	add    $0x24,%esp
80103fb8:	5b                   	pop    %ebx
80103fb9:	5d                   	pop    %ebp
80103fba:	c3                   	ret    
	...

80103fbc <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103fbc:	55                   	push   %ebp
80103fbd:	89 e5                	mov    %esp,%ebp
80103fbf:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fc2:	9c                   	pushf  
80103fc3:	58                   	pop    %eax
80103fc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103fca:	c9                   	leave  
80103fcb:	c3                   	ret    

80103fcc <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80103fcc:	55                   	push   %ebp
80103fcd:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103fcf:	fb                   	sti    
}
80103fd0:	5d                   	pop    %ebp
80103fd1:	c3                   	ret    

80103fd2 <memcop>:

static void wakeup1(void *chan);

    void*
memcop(void *dst, void *src, uint n)
{
80103fd2:	55                   	push   %ebp
80103fd3:	89 e5                	mov    %esp,%ebp
80103fd5:	83 ec 10             	sub    $0x10,%esp
    const char *s;
    char *d;

    s = src;
80103fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    d = dst;
80103fde:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if(s < d && s + n > d){
80103fe4:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103fe7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80103fea:	73 55                	jae    80104041 <memcop+0x6f>
80103fec:	8b 45 10             	mov    0x10(%ebp),%eax
80103fef:	8b 55 f8             	mov    -0x8(%ebp),%edx
80103ff2:	8d 04 02             	lea    (%edx,%eax,1),%eax
80103ff5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80103ff8:	76 4a                	jbe    80104044 <memcop+0x72>
        s += n;
80103ffa:	8b 45 10             	mov    0x10(%ebp),%eax
80103ffd:	01 45 f8             	add    %eax,-0x8(%ebp)
        d += n;
80104000:	8b 45 10             	mov    0x10(%ebp),%eax
80104003:	01 45 fc             	add    %eax,-0x4(%ebp)
        while(n-- > 0)
80104006:	eb 13                	jmp    8010401b <memcop+0x49>
            *--d = *--s;
80104008:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010400c:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104010:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104013:	0f b6 10             	movzbl (%eax),%edx
80104016:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104019:	88 10                	mov    %dl,(%eax)
    s = src;
    d = dst;
    if(s < d && s + n > d){
        s += n;
        d += n;
        while(n-- > 0)
8010401b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010401f:	0f 95 c0             	setne  %al
80104022:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104026:	84 c0                	test   %al,%al
80104028:	75 de                	jne    80104008 <memcop+0x36>
    const char *s;
    char *d;

    s = src;
    d = dst;
    if(s < d && s + n > d){
8010402a:	eb 28                	jmp    80104054 <memcop+0x82>
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
            *d++ = *s++;
8010402c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010402f:	0f b6 10             	movzbl (%eax),%edx
80104032:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104035:	88 10                	mov    %dl,(%eax)
80104037:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010403b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010403f:	eb 04                	jmp    80104045 <memcop+0x73>
        s += n;
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
80104041:	90                   	nop
80104042:	eb 01                	jmp    80104045 <memcop+0x73>
80104044:	90                   	nop
80104045:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104049:	0f 95 c0             	setne  %al
8010404c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104050:	84 c0                	test   %al,%al
80104052:	75 d8                	jne    8010402c <memcop+0x5a>
            *d++ = *s++;

    return dst;
80104054:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104057:	c9                   	leave  
80104058:	c3                   	ret    

80104059 <pinit>:


    void
pinit(void)
{
80104059:	55                   	push   %ebp
8010405a:	89 e5                	mov    %esp,%ebp
8010405c:	83 ec 18             	sub    $0x18,%esp
    initlock(&ptable.lock, "ptable");
8010405f:	c7 44 24 04 f4 8a 10 	movl   $0x80108af4,0x4(%esp)
80104066:	80 
80104067:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
8010406e:	e8 ef 10 00 00       	call   80105162 <initlock>
    initlock(&tylock, "yeildlock");
80104073:	c7 44 24 04 fb 8a 10 	movl   $0x80108afb,0x4(%esp)
8010407a:	80 
8010407b:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104082:	e8 db 10 00 00       	call   80105162 <initlock>
}
80104087:	c9                   	leave  
80104088:	c3                   	ret    

80104089 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
80104089:	55                   	push   %ebp
8010408a:	89 e5                	mov    %esp,%ebp
8010408c:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
8010408f:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104096:	e8 e8 10 00 00       	call   80105183 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010409b:	c7 45 f0 b4 ff 10 80 	movl   $0x8010ffb4,-0x10(%ebp)
801040a2:	eb 11                	jmp    801040b5 <allocproc+0x2c>
        if(p->state == UNUSED)
801040a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040a7:	8b 40 0c             	mov    0xc(%eax),%eax
801040aa:	85 c0                	test   %eax,%eax
801040ac:	74 27                	je     801040d5 <allocproc+0x4c>
{
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ae:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
801040b5:	b8 b4 21 11 80       	mov    $0x801121b4,%eax
801040ba:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801040bd:	72 e5                	jb     801040a4 <allocproc+0x1b>
        if(p->state == UNUSED)
            goto found;
    release(&ptable.lock);
801040bf:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
801040c6:	e8 19 11 00 00       	call   801051e4 <release>
    return 0;
801040cb:	b8 00 00 00 00       	mov    $0x0,%eax
801040d0:	e9 b5 00 00 00       	jmp    8010418a <allocproc+0x101>
    char *sp;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->state == UNUSED)
            goto found;
801040d5:	90                   	nop
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
801040d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040d9:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    p->pid = nextpid++;
801040e0:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801040e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040e8:	89 42 10             	mov    %eax,0x10(%edx)
801040eb:	83 c0 01             	add    $0x1,%eax
801040ee:	a3 04 b0 10 80       	mov    %eax,0x8010b004
    release(&ptable.lock);
801040f3:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
801040fa:	e8 e5 10 00 00       	call   801051e4 <release>

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
801040ff:	e8 06 ea ff ff       	call   80102b0a <kalloc>
80104104:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104107:	89 42 08             	mov    %eax,0x8(%edx)
8010410a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010410d:	8b 40 08             	mov    0x8(%eax),%eax
80104110:	85 c0                	test   %eax,%eax
80104112:	75 11                	jne    80104125 <allocproc+0x9c>
        p->state = UNUSED;
80104114:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104117:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return 0;
8010411e:	b8 00 00 00 00       	mov    $0x0,%eax
80104123:	eb 65                	jmp    8010418a <allocproc+0x101>
    }
    sp = p->kstack + KSTACKSIZE;
80104125:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104128:	8b 40 08             	mov    0x8(%eax),%eax
8010412b:	05 00 10 00 00       	add    $0x1000,%eax
80104130:	89 45 f4             	mov    %eax,-0xc(%ebp)

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80104133:	83 6d f4 4c          	subl   $0x4c,-0xc(%ebp)
    p->tf = (struct trapframe*)sp;
80104137:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010413a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010413d:	89 50 18             	mov    %edx,0x18(%eax)

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
80104140:	83 6d f4 04          	subl   $0x4,-0xc(%ebp)
    *(uint*)sp = (uint)trapret;
80104144:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104147:	ba d8 68 10 80       	mov    $0x801068d8,%edx
8010414c:	89 10                	mov    %edx,(%eax)

    sp -= sizeof *p->context;
8010414e:	83 6d f4 14          	subl   $0x14,-0xc(%ebp)
    p->context = (struct context*)sp;
80104152:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104155:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104158:	89 50 1c             	mov    %edx,0x1c(%eax)
    memset(p->context, 0, sizeof *p->context);
8010415b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010415e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104161:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104168:	00 
80104169:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104170:	00 
80104171:	89 04 24             	mov    %eax,(%esp)
80104174:	e8 59 12 00 00       	call   801053d2 <memset>
    p->context->eip = (uint)forkret;
80104179:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010417c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010417f:	ba df 4d 10 80       	mov    $0x80104ddf,%edx
80104184:	89 50 10             	mov    %edx,0x10(%eax)

    return p;
80104187:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010418a:	c9                   	leave  
8010418b:	c3                   	ret    

8010418c <userinit>:

//PAGEBREAK: 32
// Set up first user process.
    void
userinit(void)
{
8010418c:	55                   	push   %ebp
8010418d:	89 e5                	mov    %esp,%ebp
8010418f:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
80104192:	e8 f2 fe ff ff       	call   80104089 <allocproc>
80104197:	89 45 f4             	mov    %eax,-0xc(%ebp)
    initproc = p;
8010419a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419d:	a3 68 b6 10 80       	mov    %eax,0x8010b668
    if((p->pgdir = setupkvm()) == 0)
801041a2:	e8 1a 3e 00 00       	call   80107fc1 <setupkvm>
801041a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041aa:	89 42 04             	mov    %eax,0x4(%edx)
801041ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b0:	8b 40 04             	mov    0x4(%eax),%eax
801041b3:	85 c0                	test   %eax,%eax
801041b5:	75 0c                	jne    801041c3 <userinit+0x37>
        panic("userinit: out of memory?");
801041b7:	c7 04 24 05 8b 10 80 	movl   $0x80108b05,(%esp)
801041be:	e8 77 c3 ff ff       	call   8010053a <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801041c3:	ba 2c 00 00 00       	mov    $0x2c,%edx
801041c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041cb:	8b 40 04             	mov    0x4(%eax),%eax
801041ce:	89 54 24 08          	mov    %edx,0x8(%esp)
801041d2:	c7 44 24 04 00 b5 10 	movl   $0x8010b500,0x4(%esp)
801041d9:	80 
801041da:	89 04 24             	mov    %eax,(%esp)
801041dd:	e8 38 40 00 00       	call   8010821a <inituvm>
    p->sz = PGSIZE;
801041e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e5:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
    memset(p->tf, 0, sizeof(*p->tf));
801041eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ee:	8b 40 18             	mov    0x18(%eax),%eax
801041f1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801041f8:	00 
801041f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104200:	00 
80104201:	89 04 24             	mov    %eax,(%esp)
80104204:	e8 c9 11 00 00       	call   801053d2 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010420c:	8b 40 18             	mov    0x18(%eax),%eax
8010420f:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104215:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104218:	8b 40 18             	mov    0x18(%eax),%eax
8010421b:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
    p->tf->es = p->tf->ds;
80104221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104224:	8b 40 18             	mov    0x18(%eax),%eax
80104227:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010422a:	8b 52 18             	mov    0x18(%edx),%edx
8010422d:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104231:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80104235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104238:	8b 40 18             	mov    0x18(%eax),%eax
8010423b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010423e:	8b 52 18             	mov    0x18(%edx),%edx
80104241:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104245:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80104249:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424c:	8b 40 18             	mov    0x18(%eax),%eax
8010424f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80104256:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104259:	8b 40 18             	mov    0x18(%eax),%eax
8010425c:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80104263:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104266:	8b 40 18             	mov    0x18(%eax),%eax
80104269:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
80104270:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104273:	83 c0 6c             	add    $0x6c,%eax
80104276:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010427d:	00 
8010427e:	c7 44 24 04 1e 8b 10 	movl   $0x80108b1e,0x4(%esp)
80104285:	80 
80104286:	89 04 24             	mov    %eax,(%esp)
80104289:	e8 77 13 00 00       	call   80105605 <safestrcpy>
    p->cwd = namei("/");
8010428e:	c7 04 24 27 8b 10 80 	movl   $0x80108b27,(%esp)
80104295:	e8 89 e1 ff ff       	call   80102423 <namei>
8010429a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010429d:	89 42 68             	mov    %eax,0x68(%edx)

    p->state = RUNNABLE;
801042a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801042aa:	c9                   	leave  
801042ab:	c3                   	ret    

801042ac <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
    int
growproc(int n)
{
801042ac:	55                   	push   %ebp
801042ad:	89 e5                	mov    %esp,%ebp
801042af:	83 ec 28             	sub    $0x28,%esp
    uint sz;

    sz = proc->sz;
801042b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042b8:	8b 00                	mov    (%eax),%eax
801042ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(n > 0){
801042bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801042c1:	7e 34                	jle    801042f7 <growproc+0x4b>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801042c3:	8b 45 08             	mov    0x8(%ebp),%eax
801042c6:	89 c2                	mov    %eax,%edx
801042c8:	03 55 f4             	add    -0xc(%ebp),%edx
801042cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042d1:	8b 40 04             	mov    0x4(%eax),%eax
801042d4:	89 54 24 08          	mov    %edx,0x8(%esp)
801042d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042db:	89 54 24 04          	mov    %edx,0x4(%esp)
801042df:	89 04 24             	mov    %eax,(%esp)
801042e2:	e8 ae 40 00 00       	call   80108395 <allocuvm>
801042e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042ee:	75 41                	jne    80104331 <growproc+0x85>
            return -1;
801042f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042f5:	eb 58                	jmp    8010434f <growproc+0xa3>
    } else if(n < 0){
801042f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801042fb:	79 34                	jns    80104331 <growproc+0x85>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801042fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104300:	89 c2                	mov    %eax,%edx
80104302:	03 55 f4             	add    -0xc(%ebp),%edx
80104305:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010430b:	8b 40 04             	mov    0x4(%eax),%eax
8010430e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104312:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104315:	89 54 24 04          	mov    %edx,0x4(%esp)
80104319:	89 04 24             	mov    %eax,(%esp)
8010431c:	e8 4e 41 00 00       	call   8010846f <deallocuvm>
80104321:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104328:	75 07                	jne    80104331 <growproc+0x85>
            return -1;
8010432a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010432f:	eb 1e                	jmp    8010434f <growproc+0xa3>
    }
    proc->sz = sz;
80104331:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104337:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010433a:	89 10                	mov    %edx,(%eax)
    switchuvm(proc);
8010433c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104342:	89 04 24             	mov    %eax,(%esp)
80104345:	e8 69 3d 00 00       	call   801080b3 <switchuvm>
    return 0;
8010434a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010434f:	c9                   	leave  
80104350:	c3                   	ret    

80104351 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
    int
fork(void)
{
80104351:	55                   	push   %ebp
80104352:	89 e5                	mov    %esp,%ebp
80104354:	57                   	push   %edi
80104355:	56                   	push   %esi
80104356:	53                   	push   %ebx
80104357:	83 ec 2c             	sub    $0x2c,%esp
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0)
8010435a:	e8 2a fd ff ff       	call   80104089 <allocproc>
8010435f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104362:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80104366:	75 0a                	jne    80104372 <fork+0x21>
        return -1;
80104368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010436d:	e9 47 01 00 00       	jmp    801044b9 <fork+0x168>

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104372:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104378:	8b 10                	mov    (%eax),%edx
8010437a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104380:	8b 40 04             	mov    0x4(%eax),%eax
80104383:	89 54 24 04          	mov    %edx,0x4(%esp)
80104387:	89 04 24             	mov    %eax,(%esp)
8010438a:	e8 70 42 00 00       	call   801085ff <copyuvm>
8010438f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104392:	89 42 04             	mov    %eax,0x4(%edx)
80104395:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104398:	8b 40 04             	mov    0x4(%eax),%eax
8010439b:	85 c0                	test   %eax,%eax
8010439d:	75 2c                	jne    801043cb <fork+0x7a>
        kfree(np->kstack);
8010439f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043a2:	8b 40 08             	mov    0x8(%eax),%eax
801043a5:	89 04 24             	mov    %eax,(%esp)
801043a8:	e8 c4 e6 ff ff       	call   80102a71 <kfree>
        np->kstack = 0;
801043ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043b0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        np->state = UNUSED;
801043b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043ba:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return -1;
801043c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043c6:	e9 ee 00 00 00       	jmp    801044b9 <fork+0x168>
    }
    np->sz = proc->sz;
801043cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043d1:	8b 10                	mov    (%eax),%edx
801043d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043d6:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
801043d8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801043df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043e2:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
801043e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043e8:	8b 50 18             	mov    0x18(%eax),%edx
801043eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043f1:	8b 40 18             	mov    0x18(%eax),%eax
801043f4:	89 c3                	mov    %eax,%ebx
801043f6:	b8 13 00 00 00       	mov    $0x13,%eax
801043fb:	89 d7                	mov    %edx,%edi
801043fd:	89 de                	mov    %ebx,%esi
801043ff:	89 c1                	mov    %eax,%ecx
80104401:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 0;
80104403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104406:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010440d:	00 00 00 

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80104410:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104413:	8b 40 18             	mov    0x18(%eax),%eax
80104416:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    for(i = 0; i < NOFILE; i++)
8010441d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80104424:	eb 3d                	jmp    80104463 <fork+0x112>
        if(proc->ofile[i])
80104426:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010442c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010442f:	83 c2 08             	add    $0x8,%edx
80104432:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104436:	85 c0                	test   %eax,%eax
80104438:	74 25                	je     8010445f <fork+0x10e>
            np->ofile[i] = filedup(proc->ofile[i]);
8010443a:	8b 5d dc             	mov    -0x24(%ebp),%ebx
8010443d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104443:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104446:	83 c2 08             	add    $0x8,%edx
80104449:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010444d:	89 04 24             	mov    %eax,(%esp)
80104450:	e8 30 cb ff ff       	call   80100f85 <filedup>
80104455:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104458:	8d 4b 08             	lea    0x8(%ebx),%ecx
8010445b:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
    np->isthread = 0;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
8010445f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80104463:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
80104467:	7e bd                	jle    80104426 <fork+0xd5>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
80104469:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010446f:	8b 40 68             	mov    0x68(%eax),%eax
80104472:	89 04 24             	mov    %eax,(%esp)
80104475:	e8 cf d3 ff ff       	call   80101849 <idup>
8010447a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010447d:	89 42 68             	mov    %eax,0x68(%edx)

    pid = np->pid;
80104480:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104483:	8b 40 10             	mov    0x10(%eax),%eax
80104486:	89 45 e0             	mov    %eax,-0x20(%ebp)
    np->state = RUNNABLE;
80104489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010448c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    safestrcpy(np->name, proc->name, sizeof(proc->name));
80104493:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104499:	8d 50 6c             	lea    0x6c(%eax),%edx
8010449c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010449f:	83 c0 6c             	add    $0x6c,%eax
801044a2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801044a9:	00 
801044aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801044ae:	89 04 24             	mov    %eax,(%esp)
801044b1:	e8 4f 11 00 00       	call   80105605 <safestrcpy>
    return pid;
801044b6:	8b 45 e0             	mov    -0x20(%ebp),%eax

}
801044b9:	83 c4 2c             	add    $0x2c,%esp
801044bc:	5b                   	pop    %ebx
801044bd:	5e                   	pop    %esi
801044be:	5f                   	pop    %edi
801044bf:	5d                   	pop    %ebp
801044c0:	c3                   	ret    

801044c1 <clone>:

//creat a new process but used parent pgdir. 
int clone(int stack, int size, int routine, int arg){ 
801044c1:	55                   	push   %ebp
801044c2:	89 e5                	mov    %esp,%ebp
801044c4:	57                   	push   %edi
801044c5:	56                   	push   %esi
801044c6:	53                   	push   %ebx
801044c7:	81 ec bc 00 00 00    	sub    $0xbc,%esp
    int i, pid;
    struct proc *np;

    //cprintf("in clone\n");
    // Allocate process.
    if((np = allocproc()) == 0)
801044cd:	e8 b7 fb ff ff       	call   80104089 <allocproc>
801044d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
801044d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801044d9:	75 0a                	jne    801044e5 <clone+0x24>
        return -1;
801044db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044e0:	e9 f4 01 00 00       	jmp    801046d9 <clone+0x218>
    if((stack % PGSIZE) != 0 || stack == 0 || routine == 0)
801044e5:	8b 45 08             	mov    0x8(%ebp),%eax
801044e8:	25 ff 0f 00 00       	and    $0xfff,%eax
801044ed:	85 c0                	test   %eax,%eax
801044ef:	75 0c                	jne    801044fd <clone+0x3c>
801044f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801044f5:	74 06                	je     801044fd <clone+0x3c>
801044f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801044fb:	75 0a                	jne    80104507 <clone+0x46>
        return -1;
801044fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104502:	e9 d2 01 00 00       	jmp    801046d9 <clone+0x218>

    np->pgdir = proc->pgdir;
80104507:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010450d:	8b 50 04             	mov    0x4(%eax),%edx
80104510:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104513:	89 50 04             	mov    %edx,0x4(%eax)
    np->sz = proc->sz;
80104516:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010451c:	8b 10                	mov    (%eax),%edx
8010451e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104521:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
80104523:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010452a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010452d:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
80104530:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104533:	8b 50 18             	mov    0x18(%eax),%edx
80104536:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010453c:	8b 40 18             	mov    0x18(%eax),%eax
8010453f:	89 c3                	mov    %eax,%ebx
80104541:	b8 13 00 00 00       	mov    $0x13,%eax
80104546:	89 d7                	mov    %edx,%edi
80104548:	89 de                	mov    %ebx,%esi
8010454a:	89 c1                	mov    %eax,%ecx
8010454c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 1;
8010454e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104551:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
80104558:	00 00 00 
    pid = np->pid;
8010455b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010455e:	8b 40 10             	mov    0x10(%eax),%eax
80104561:	89 45 d8             	mov    %eax,-0x28(%ebp)

    struct proc *pp;
    pp = proc;
80104564:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010456a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(pp->isthread == 1){
8010456d:	eb 09                	jmp    80104578 <clone+0xb7>
        pp = pp->parent;
8010456f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104572:	8b 40 14             	mov    0x14(%eax),%eax
80104575:	89 45 e0             	mov    %eax,-0x20(%ebp)
    np->isthread = 1;
    pid = np->pid;

    struct proc *pp;
    pp = proc;
    while(pp->isthread == 1){
80104578:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010457b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104581:	83 f8 01             	cmp    $0x1,%eax
80104584:	74 e9                	je     8010456f <clone+0xae>
        pp = pp->parent;
    }
    np->parent = pp;
80104586:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104589:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010458c:	89 50 14             	mov    %edx,0x14(%eax)
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
8010458f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
80104596:	eb 3d                	jmp    801045d5 <clone+0x114>
        if(proc->ofile[i])
80104598:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010459e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801045a1:	83 c2 08             	add    $0x8,%edx
801045a4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045a8:	85 c0                	test   %eax,%eax
801045aa:	74 25                	je     801045d1 <clone+0x110>
            np->ofile[i] = filedup(proc->ofile[i]);
801045ac:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
801045af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801045b8:	83 c2 08             	add    $0x8,%edx
801045bb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045bf:	89 04 24             	mov    %eax,(%esp)
801045c2:	e8 be c9 ff ff       	call   80100f85 <filedup>
801045c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
801045ca:	8d 4b 08             	lea    0x8(%ebx),%ecx
801045cd:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
        pp = pp->parent;
    }
    np->parent = pp;
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
801045d1:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801045d5:	83 7d d4 0f          	cmpl   $0xf,-0x2c(%ebp)
801045d9:	7e bd                	jle    80104598 <clone+0xd7>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
801045db:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045de:	8b 40 18             	mov    0x18(%eax),%eax
801045e1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

   
    uint ustack[MAXARG];
    uint sp = stack + PGSIZE;
801045e8:	8b 45 08             	mov    0x8(%ebp),%eax
801045eb:	05 00 10 00 00       	add    $0x1000,%eax
801045f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
//


//modify here <<<<<

    np->tf->ebp = sp;
801045f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045f6:	8b 40 18             	mov    0x18(%eax),%eax
801045f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045fc:	89 50 08             	mov    %edx,0x8(%eax)
    ustack[0] = 0xffffffff;
801045ff:	c7 85 54 ff ff ff ff 	movl   $0xffffffff,-0xac(%ebp)
80104606:	ff ff ff 
    ustack[1] = arg;
80104609:	8b 45 14             	mov    0x14(%ebp),%eax
8010460c:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
    sp -= 8;
80104612:	83 6d e4 08          	subl   $0x8,-0x1c(%ebp)
    if(copyout(np->pgdir,sp,ustack,8)<0){
80104616:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104619:	8b 40 04             	mov    0x4(%eax),%eax
8010461c:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
80104623:	00 
80104624:	8d 95 54 ff ff ff    	lea    -0xac(%ebp),%edx
8010462a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010462e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104631:	89 54 24 04          	mov    %edx,0x4(%esp)
80104635:	89 04 24             	mov    %eax,(%esp)
80104638:	e8 41 41 00 00       	call   8010877e <copyout>
8010463d:	85 c0                	test   %eax,%eax
8010463f:	79 16                	jns    80104657 <clone+0x196>
        cprintf("push arg fails\n");
80104641:	c7 04 24 29 8b 10 80 	movl   $0x80108b29,(%esp)
80104648:	e8 4d bd ff ff       	call   8010039a <cprintf>
        return -1;
8010464d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104652:	e9 82 00 00 00       	jmp    801046d9 <clone+0x218>
    }

    np->tf->eip = routine;
80104657:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010465a:	8b 40 18             	mov    0x18(%eax),%eax
8010465d:	8b 55 10             	mov    0x10(%ebp),%edx
80104660:	89 50 38             	mov    %edx,0x38(%eax)
    np->tf->esp = sp;
80104663:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104666:	8b 40 18             	mov    0x18(%eax),%eax
80104669:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010466c:	89 50 44             	mov    %edx,0x44(%eax)
    np->cwd = idup(proc->cwd);
8010466f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104675:	8b 40 68             	mov    0x68(%eax),%eax
80104678:	89 04 24             	mov    %eax,(%esp)
8010467b:	e8 c9 d1 ff ff       	call   80101849 <idup>
80104680:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104683:	89 42 68             	mov    %eax,0x68(%edx)

    switchuvm(np);
80104686:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104689:	89 04 24             	mov    %eax,(%esp)
8010468c:	e8 22 3a 00 00       	call   801080b3 <switchuvm>

     acquire(&ptable.lock);
80104691:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104698:	e8 e6 0a 00 00       	call   80105183 <acquire>
    np->state = RUNNABLE;
8010469d:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046a0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
     release(&ptable.lock);
801046a7:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
801046ae:	e8 31 0b 00 00       	call   801051e4 <release>
    safestrcpy(np->name, proc->name, sizeof(proc->name));
801046b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b9:	8d 50 6c             	lea    0x6c(%eax),%edx
801046bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046bf:	83 c0 6c             	add    $0x6c,%eax
801046c2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801046c9:	00 
801046ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801046ce:	89 04 24             	mov    %eax,(%esp)
801046d1:	e8 2f 0f 00 00       	call   80105605 <safestrcpy>


    return pid;
801046d6:	8b 45 d8             	mov    -0x28(%ebp),%eax

}
801046d9:	81 c4 bc 00 00 00    	add    $0xbc,%esp
801046df:	5b                   	pop    %ebx
801046e0:	5e                   	pop    %esi
801046e1:	5f                   	pop    %edi
801046e2:	5d                   	pop    %ebp
801046e3:	c3                   	ret    

801046e4 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
    void
exit(void)
{
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int fd;

    if(proc == initproc)
801046ea:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801046f1:	a1 68 b6 10 80       	mov    0x8010b668,%eax
801046f6:	39 c2                	cmp    %eax,%edx
801046f8:	75 0c                	jne    80104706 <exit+0x22>
        panic("init exiting");
801046fa:	c7 04 24 39 8b 10 80 	movl   $0x80108b39,(%esp)
80104701:	e8 34 be ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104706:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010470d:	eb 44                	jmp    80104753 <exit+0x6f>
        if(proc->ofile[fd]){
8010470f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104715:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104718:	83 c2 08             	add    $0x8,%edx
8010471b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010471f:	85 c0                	test   %eax,%eax
80104721:	74 2c                	je     8010474f <exit+0x6b>
            fileclose(proc->ofile[fd]);
80104723:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104729:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010472c:	83 c2 08             	add    $0x8,%edx
8010472f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104733:	89 04 24             	mov    %eax,(%esp)
80104736:	e8 92 c8 ff ff       	call   80100fcd <fileclose>
            proc->ofile[fd] = 0;
8010473b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104741:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104744:	83 c2 08             	add    $0x8,%edx
80104747:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010474e:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
8010474f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104753:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104757:	7e b6                	jle    8010470f <exit+0x2b>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    iput(proc->cwd);
80104759:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010475f:	8b 40 68             	mov    0x68(%eax),%eax
80104762:	89 04 24             	mov    %eax,(%esp)
80104765:	e8 c7 d2 ff ff       	call   80101a31 <iput>
    proc->cwd = 0;
8010476a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104770:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104777:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
8010477e:	e8 00 0a 00 00       	call   80105183 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104783:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104789:	8b 40 14             	mov    0x14(%eax),%eax
8010478c:	89 04 24             	mov    %eax,(%esp)
8010478f:	e8 12 07 00 00       	call   80104ea6 <wakeup1>

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104794:	c7 45 f0 b4 ff 10 80 	movl   $0x8010ffb4,-0x10(%ebp)
8010479b:	eb 3b                	jmp    801047d8 <exit+0xf4>
        if(p->parent == proc){
8010479d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047a0:	8b 50 14             	mov    0x14(%eax),%edx
801047a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a9:	39 c2                	cmp    %eax,%edx
801047ab:	75 24                	jne    801047d1 <exit+0xed>
            p->parent = initproc;
801047ad:	8b 15 68 b6 10 80    	mov    0x8010b668,%edx
801047b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047b6:	89 50 14             	mov    %edx,0x14(%eax)
            if(p->state == ZOMBIE)
801047b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047bc:	8b 40 0c             	mov    0xc(%eax),%eax
801047bf:	83 f8 05             	cmp    $0x5,%eax
801047c2:	75 0d                	jne    801047d1 <exit+0xed>
                wakeup1(initproc);
801047c4:	a1 68 b6 10 80       	mov    0x8010b668,%eax
801047c9:	89 04 24             	mov    %eax,(%esp)
801047cc:	e8 d5 06 00 00       	call   80104ea6 <wakeup1>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047d1:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
801047d8:	b8 b4 21 11 80       	mov    $0x801121b4,%eax
801047dd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801047e0:	72 bb                	jb     8010479d <exit+0xb9>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
801047e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047e8:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
801047ef:	e8 17 03 00 00       	call   80104b0b <sched>
    panic("zombie exit");
801047f4:	c7 04 24 46 8b 10 80 	movl   $0x80108b46,(%esp)
801047fb:	e8 3a bd ff ff       	call   8010053a <panic>

80104800 <texit>:
}
    void
texit(void)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	83 ec 28             	sub    $0x28,%esp
    //  struct proc *p;
    int fd;

    if(proc == initproc)
80104806:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010480d:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104812:	39 c2                	cmp    %eax,%edx
80104814:	75 0c                	jne    80104822 <texit+0x22>
        panic("init exiting");
80104816:	c7 04 24 39 8b 10 80 	movl   $0x80108b39,(%esp)
8010481d:	e8 18 bd ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104822:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104829:	eb 44                	jmp    8010486f <texit+0x6f>
        if(proc->ofile[fd]){
8010482b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104831:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104834:	83 c2 08             	add    $0x8,%edx
80104837:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010483b:	85 c0                	test   %eax,%eax
8010483d:	74 2c                	je     8010486b <texit+0x6b>
            fileclose(proc->ofile[fd]);
8010483f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104845:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104848:	83 c2 08             	add    $0x8,%edx
8010484b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010484f:	89 04 24             	mov    %eax,(%esp)
80104852:	e8 76 c7 ff ff       	call   80100fcd <fileclose>
            proc->ofile[fd] = 0;
80104857:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010485d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104860:	83 c2 08             	add    $0x8,%edx
80104863:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010486a:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
8010486b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010486f:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104873:	7e b6                	jle    8010482b <texit+0x2b>
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }
    iput(proc->cwd);
80104875:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010487b:	8b 40 68             	mov    0x68(%eax),%eax
8010487e:	89 04 24             	mov    %eax,(%esp)
80104881:	e8 ab d1 ff ff       	call   80101a31 <iput>
    proc->cwd = 0;
80104886:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010488c:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104893:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
8010489a:	e8 e4 08 00 00       	call   80105183 <acquire>
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
8010489f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a5:	8b 40 14             	mov    0x14(%eax),%eax
801048a8:	89 04 24             	mov    %eax,(%esp)
801048ab:	e8 f6 05 00 00       	call   80104ea6 <wakeup1>
    release(&ptable.lock);
801048b0:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
801048b7:	e8 28 09 00 00       	call   801051e4 <release>
		acquire(&tylock);
801048bc:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801048c3:	e8 bb 08 00 00       	call   80105183 <acquire>
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048c8:	c7 45 f4 b4 ff 10 80 	movl   $0x8010ffb4,-0xc(%ebp)
801048cf:	eb 3c                	jmp    8010490d <texit+0x10d>
      if(p->isthread == 1 && p->state == SLEEPING && p->isYielding == 1){
801048d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d4:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801048da:	83 f8 01             	cmp    $0x1,%eax
801048dd:	75 27                	jne    80104906 <texit+0x106>
801048df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e2:	8b 40 0c             	mov    0xc(%eax),%eax
801048e5:	83 f8 02             	cmp    $0x2,%eax
801048e8:	75 1c                	jne    80104906 <texit+0x106>
801048ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ed:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801048f3:	83 f8 01             	cmp    $0x1,%eax
801048f6:	75 0e                	jne    80104906 <texit+0x106>
        twakeup(p->pid);
801048f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048fb:	8b 40 10             	mov    0x10(%eax),%eax
801048fe:	89 04 24             	mov    %eax,(%esp)
80104901:	e8 e2 05 00 00       	call   80104ee8 <twakeup>
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
    release(&ptable.lock);
		acquire(&tylock);
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104906:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
8010490d:	b8 b4 21 11 80       	mov    $0x801121b4,%eax
80104912:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104915:	72 ba                	jb     801048d1 <texit+0xd1>
      if(p->isthread == 1 && p->state == SLEEPING && p->isYielding == 1){
        twakeup(p->pid);
      }
    }
    release(&tylock);
80104917:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
8010491e:	e8 c1 08 00 00       	call   801051e4 <release>
    acquire(&ptable.lock);
80104923:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
8010492a:	e8 54 08 00 00       	call   80105183 <acquire>
    //      if(p->state == ZOMBIE)
    //        wakeup1(initproc);
    //    }
    //  }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
8010492f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104935:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
8010493c:	e8 ca 01 00 00       	call   80104b0b <sched>
    panic("zombie exit");
80104941:	c7 04 24 46 8b 10 80 	movl   $0x80108b46,(%esp)
80104948:	e8 ed bb ff ff       	call   8010053a <panic>

8010494d <wait>:
}
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
    int
wait(void)
{
8010494d:	55                   	push   %ebp
8010494e:	89 e5                	mov    %esp,%ebp
80104950:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
80104953:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
8010495a:	e8 24 08 00 00       	call   80105183 <acquire>
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
8010495f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104966:	c7 45 ec b4 ff 10 80 	movl   $0x8010ffb4,-0x14(%ebp)
8010496d:	e9 ab 00 00 00       	jmp    80104a1d <wait+0xd0>
        //    if(p->parent != proc && p->isthread ==1)
            if(p->parent != proc) 
80104972:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104975:	8b 50 14             	mov    0x14(%eax),%edx
80104978:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497e:	39 c2                	cmp    %eax,%edx
80104980:	0f 85 8f 00 00 00    	jne    80104a15 <wait+0xc8>
                continue;
            havekids = 1;
80104986:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if(p->state == ZOMBIE){
8010498d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104990:	8b 40 0c             	mov    0xc(%eax),%eax
80104993:	83 f8 05             	cmp    $0x5,%eax
80104996:	75 7e                	jne    80104a16 <wait+0xc9>
                // Found one.
                pid = p->pid;
80104998:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010499b:	8b 40 10             	mov    0x10(%eax),%eax
8010499e:	89 45 f4             	mov    %eax,-0xc(%ebp)
                kfree(p->kstack);
801049a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049a4:	8b 40 08             	mov    0x8(%eax),%eax
801049a7:	89 04 24             	mov    %eax,(%esp)
801049aa:	e8 c2 e0 ff ff       	call   80102a71 <kfree>
                p->kstack = 0;
801049af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                if(p->isthread != 1){
801049b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049bc:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801049c2:	83 f8 01             	cmp    $0x1,%eax
801049c5:	74 0e                	je     801049d5 <wait+0x88>
                    freevm(p->pgdir);
801049c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ca:	8b 40 04             	mov    0x4(%eax),%eax
801049cd:	89 04 24             	mov    %eax,(%esp)
801049d0:	e8 56 3b 00 00       	call   8010852b <freevm>
                }
                p->state = UNUSED;
801049d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                p->pid = 0;
801049df:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049e2:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
801049e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ec:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
801049f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049f6:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
801049fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049fd:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                release(&ptable.lock);
80104a04:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104a0b:	e8 d4 07 00 00       	call   801051e4 <release>
                return pid;
80104a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a13:	eb 57                	jmp    80104a6c <wait+0x11f>
        // Scan through table looking for zombie children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        //    if(p->parent != proc && p->isthread ==1)
            if(p->parent != proc) 
                continue;
80104a15:	90                   	nop

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a16:	81 45 ec 88 00 00 00 	addl   $0x88,-0x14(%ebp)
80104a1d:	b8 b4 21 11 80       	mov    $0x801121b4,%eax
80104a22:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104a25:	0f 82 47 ff ff ff    	jb     80104972 <wait+0x25>
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
80104a2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a2f:	74 0d                	je     80104a3e <wait+0xf1>
80104a31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a37:	8b 40 24             	mov    0x24(%eax),%eax
80104a3a:	85 c0                	test   %eax,%eax
80104a3c:	74 13                	je     80104a51 <wait+0x104>
            release(&ptable.lock);
80104a3e:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104a45:	e8 9a 07 00 00       	call   801051e4 <release>
            return -1;
80104a4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a4f:	eb 1b                	jmp    80104a6c <wait+0x11f>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a51:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a57:	c7 44 24 04 80 ff 10 	movl   $0x8010ff80,0x4(%esp)
80104a5e:	80 
80104a5f:	89 04 24             	mov    %eax,(%esp)
80104a62:	e8 a4 03 00 00       	call   80104e0b <sleep>
    }
80104a67:	e9 f3 fe ff ff       	jmp    8010495f <wait+0x12>
}
80104a6c:	c9                   	leave  
80104a6d:	c3                   	ret    

80104a6e <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
    void
scheduler(void)
{
80104a6e:	55                   	push   %ebp
80104a6f:	89 e5                	mov    %esp,%ebp
80104a71:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    for(;;){
        // Enable interrupts on this processor.
        sti();
80104a74:	e8 53 f5 ff ff       	call   80103fcc <sti>

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80104a79:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104a80:	e8 fe 06 00 00       	call   80105183 <acquire>
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a85:	c7 45 f4 b4 ff 10 80 	movl   $0x8010ffb4,-0xc(%ebp)
80104a8c:	eb 62                	jmp    80104af0 <scheduler+0x82>
            if(p->state != RUNNABLE)
80104a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a91:	8b 40 0c             	mov    0xc(%eax),%eax
80104a94:	83 f8 03             	cmp    $0x3,%eax
80104a97:	75 4f                	jne    80104ae8 <scheduler+0x7a>
                continue;

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            proc = p;
80104a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a9c:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
            switchuvm(p);
80104aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa5:	89 04 24             	mov    %eax,(%esp)
80104aa8:	e8 06 36 00 00       	call   801080b3 <switchuvm>
            p->state = RUNNING;
80104aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab0:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
            swtch(&cpu->scheduler, proc->context);
80104ab7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104abd:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ac0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104ac7:	83 c2 04             	add    $0x4,%edx
80104aca:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ace:	89 14 24             	mov    %edx,(%esp)
80104ad1:	e8 a2 0b 00 00       	call   80105678 <swtch>
            switchkvm();
80104ad6:	e8 bb 35 00 00       	call   80108096 <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
80104adb:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104ae2:	00 00 00 00 
80104ae6:	eb 01                	jmp    80104ae9 <scheduler+0x7b>

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            if(p->state != RUNNABLE)
                continue;
80104ae8:	90                   	nop
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ae9:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104af0:	b8 b4 21 11 80       	mov    $0x801121b4,%eax
80104af5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104af8:	72 94                	jb     80104a8e <scheduler+0x20>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
        }
        release(&ptable.lock);
80104afa:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104b01:	e8 de 06 00 00       	call   801051e4 <release>

    }
80104b06:	e9 69 ff ff ff       	jmp    80104a74 <scheduler+0x6>

80104b0b <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
    void
sched(void)
{
80104b0b:	55                   	push   %ebp
80104b0c:	89 e5                	mov    %esp,%ebp
80104b0e:	83 ec 28             	sub    $0x28,%esp
    int intena;

    if(!holding(&ptable.lock))
80104b11:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104b18:	e8 85 07 00 00       	call   801052a2 <holding>
80104b1d:	85 c0                	test   %eax,%eax
80104b1f:	75 0c                	jne    80104b2d <sched+0x22>
        panic("sched ptable.lock");
80104b21:	c7 04 24 52 8b 10 80 	movl   $0x80108b52,(%esp)
80104b28:	e8 0d ba ff ff       	call   8010053a <panic>
    if(cpu->ncli != 1){
80104b2d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b33:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b39:	83 f8 01             	cmp    $0x1,%eax
80104b3c:	74 35                	je     80104b73 <sched+0x68>
        cprintf("current proc %d\n cpu->ncli %d\n",proc->pid,cpu->ncli);
80104b3e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b44:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104b4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b50:	8b 40 10             	mov    0x10(%eax),%eax
80104b53:	89 54 24 08          	mov    %edx,0x8(%esp)
80104b57:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b5b:	c7 04 24 64 8b 10 80 	movl   $0x80108b64,(%esp)
80104b62:	e8 33 b8 ff ff       	call   8010039a <cprintf>
        panic("sched locks");
80104b67:	c7 04 24 83 8b 10 80 	movl   $0x80108b83,(%esp)
80104b6e:	e8 c7 b9 ff ff       	call   8010053a <panic>
    }
    if(proc->state == RUNNING)
80104b73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b79:	8b 40 0c             	mov    0xc(%eax),%eax
80104b7c:	83 f8 04             	cmp    $0x4,%eax
80104b7f:	75 0c                	jne    80104b8d <sched+0x82>
        panic("sched running");
80104b81:	c7 04 24 8f 8b 10 80 	movl   $0x80108b8f,(%esp)
80104b88:	e8 ad b9 ff ff       	call   8010053a <panic>
    if(readeflags()&FL_IF)
80104b8d:	e8 2a f4 ff ff       	call   80103fbc <readeflags>
80104b92:	25 00 02 00 00       	and    $0x200,%eax
80104b97:	85 c0                	test   %eax,%eax
80104b99:	74 0c                	je     80104ba7 <sched+0x9c>
        panic("sched interruptible");
80104b9b:	c7 04 24 9d 8b 10 80 	movl   $0x80108b9d,(%esp)
80104ba2:	e8 93 b9 ff ff       	call   8010053a <panic>
    intena = cpu->intena;
80104ba7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bad:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    swtch(&proc->context, cpu->scheduler);
80104bb6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bbc:	8b 40 04             	mov    0x4(%eax),%eax
80104bbf:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104bc6:	83 c2 1c             	add    $0x1c,%edx
80104bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bcd:	89 14 24             	mov    %edx,(%esp)
80104bd0:	e8 a3 0a 00 00       	call   80105678 <swtch>
    cpu->intena = intena;
80104bd5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bde:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104be4:	c9                   	leave  
80104be5:	c3                   	ret    

80104be6 <yield>:

// Give up the CPU for one scheduling round.
    void
yield(void)
{
80104be6:	55                   	push   %ebp
80104be7:	89 e5                	mov    %esp,%ebp
80104be9:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104bec:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104bf3:	e8 8b 05 00 00       	call   80105183 <acquire>
    proc->state = RUNNABLE;
80104bf8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bfe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    sched();
80104c05:	e8 01 ff ff ff       	call   80104b0b <sched>
    release(&ptable.lock);
80104c0a:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104c11:	e8 ce 05 00 00       	call   801051e4 <release>
}
80104c16:	c9                   	leave  
80104c17:	c3                   	ret    

80104c18 <thread_yield>:

void thread_yield(void){
80104c18:	55                   	push   %ebp
80104c19:	89 e5                	mov    %esp,%ebp
80104c1b:	83 ec 28             	sub    $0x28,%esp
	cprintf("Got here\n");
80104c1e:	c7 04 24 b1 8b 10 80 	movl   $0x80108bb1,(%esp)
80104c25:	e8 70 b7 ff ff       	call   8010039a <cprintf>
	acquire(&tylock);
80104c2a:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104c31:	e8 4d 05 00 00       	call   80105183 <acquire>
  int i = -1;
80104c36:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  struct proc *p;
  struct proc *w = 0;
80104c3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c44:	c7 45 f0 b4 ff 10 80 	movl   $0x8010ffb4,-0x10(%ebp)
80104c4b:	eb 6f                	jmp    80104cbc <thread_yield+0xa4>
    if(p->isthread == 1 && p->state != SLEEPING){
80104c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c50:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104c56:	83 f8 01             	cmp    $0x1,%eax
80104c59:	75 1d                	jne    80104c78 <thread_yield+0x60>
80104c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c5e:	8b 40 0c             	mov    0xc(%eax),%eax
80104c61:	83 f8 02             	cmp    $0x2,%eax
80104c64:	74 12                	je     80104c78 <thread_yield+0x60>
			cprintf("Here too 1\n");
80104c66:	c7 04 24 bb 8b 10 80 	movl   $0x80108bbb,(%esp)
80104c6d:	e8 28 b7 ff ff       	call   8010039a <cprintf>
      i++;
80104c72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
	acquire(&tylock);
  int i = -1;
  struct proc *p;
  struct proc *w = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->isthread == 1 && p->state != SLEEPING){
80104c76:	eb 3d                	jmp    80104cb5 <thread_yield+0x9d>
			cprintf("Here too 1\n");
      i++;
    }
    else if(p->isthread == 1 && p->state == SLEEPING && p->isYielding == 1){
80104c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c7b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104c81:	83 f8 01             	cmp    $0x1,%eax
80104c84:	75 2f                	jne    80104cb5 <thread_yield+0x9d>
80104c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c89:	8b 40 0c             	mov    0xc(%eax),%eax
80104c8c:	83 f8 02             	cmp    $0x2,%eax
80104c8f:	75 24                	jne    80104cb5 <thread_yield+0x9d>
80104c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c94:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104c9a:	83 f8 01             	cmp    $0x1,%eax
80104c9d:	75 16                	jne    80104cb5 <thread_yield+0x9d>
			cprintf("Here too 2\n");
80104c9f:	c7 04 24 c7 8b 10 80 	movl   $0x80108bc7,(%esp)
80104ca6:	e8 ef b6 ff ff       	call   8010039a <cprintf>
      w = p;
80104cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
      i++;
80104cb1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
	cprintf("Got here\n");
	acquire(&tylock);
  int i = -1;
  struct proc *p;
  struct proc *w = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cb5:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
80104cbc:	b8 b4 21 11 80       	mov    $0x801121b4,%eax
80104cc1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104cc4:	72 87                	jb     80104c4d <thread_yield+0x35>
			cprintf("Here too 2\n");
      w = p;
      i++;
    }
  }
  if(w != 0){
80104cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104cca:	0f 84 8c 00 00 00    	je     80104d5c <thread_yield+0x144>
		cprintf("Waking up\n");
80104cd0:	c7 04 24 d3 8b 10 80 	movl   $0x80108bd3,(%esp)
80104cd7:	e8 be b6 ff ff       	call   8010039a <cprintf>
		twakeup(w->pid);
80104cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cdf:	8b 40 10             	mov    0x10(%eax),%eax
80104ce2:	89 04 24             	mov    %eax,(%esp)
80104ce5:	e8 fe 01 00 00       	call   80104ee8 <twakeup>
    cprintf("Going to sleep\n");
80104cea:	c7 04 24 de 8b 10 80 	movl   $0x80108bde,(%esp)
80104cf1:	e8 a4 b6 ff ff       	call   8010039a <cprintf>
		acquire(&ptable.lock);
80104cf6:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104cfd:	e8 81 04 00 00       	call   80105183 <acquire>
    proc->isYielding = 1;
80104d02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d08:	c7 80 84 00 00 00 01 	movl   $0x1,0x84(%eax)
80104d0f:	00 00 00 
    release(&ptable.lock);
80104d12:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104d19:	e8 c6 04 00 00       	call   801051e4 <release>
    release(&tylock);
80104d1e:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104d25:	e8 ba 04 00 00       	call   801051e4 <release>
    tsleep();
80104d2a:	e8 c6 03 00 00       	call   801050f5 <tsleep>
    acquire(&ptable.lock);
80104d2f:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104d36:	e8 48 04 00 00       	call   80105183 <acquire>
    proc->isYielding = 0;
80104d3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d41:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104d48:	00 00 00 
    release(&ptable.lock);
80104d4b:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104d52:	e8 8d 04 00 00       	call   801051e4 <release>
80104d57:	e9 81 00 00 00       	jmp    80104ddd <thread_yield+0x1c5>
	}
  else if(i > 0){
80104d5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80104d60:	7e 6f                	jle    80104dd1 <thread_yield+0x1b9>
		cprintf("Going to sleep\n");
80104d62:	c7 04 24 de 8b 10 80 	movl   $0x80108bde,(%esp)
80104d69:	e8 2c b6 ff ff       	call   8010039a <cprintf>
		acquire(&ptable.lock);
80104d6e:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104d75:	e8 09 04 00 00       	call   80105183 <acquire>
    proc->isYielding = 1;
80104d7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d80:	c7 80 84 00 00 00 01 	movl   $0x1,0x84(%eax)
80104d87:	00 00 00 
    release(&ptable.lock);
80104d8a:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104d91:	e8 4e 04 00 00       	call   801051e4 <release>
    release(&tylock);
80104d96:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104d9d:	e8 42 04 00 00       	call   801051e4 <release>
    tsleep();
80104da2:	e8 4e 03 00 00       	call   801050f5 <tsleep>
    acquire(&ptable.lock);
80104da7:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104dae:	e8 d0 03 00 00       	call   80105183 <acquire>
    proc->isYielding = 0;
80104db3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104db9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104dc0:	00 00 00 
    release(&ptable.lock);
80104dc3:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104dca:	e8 15 04 00 00       	call   801051e4 <release>
80104dcf:	eb 0c                	jmp    80104ddd <thread_yield+0x1c5>
  }
  else
		release(&tylock);
80104dd1:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104dd8:	e8 07 04 00 00       	call   801051e4 <release>
}
80104ddd:	c9                   	leave  
80104dde:	c3                   	ret    

80104ddf <forkret>:
// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
    void
forkret(void)
{
80104ddf:	55                   	push   %ebp
80104de0:	89 e5                	mov    %esp,%ebp
80104de2:	83 ec 18             	sub    $0x18,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80104de5:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104dec:	e8 f3 03 00 00       	call   801051e4 <release>

    if (first) {
80104df1:	a1 20 b0 10 80       	mov    0x8010b020,%eax
80104df6:	85 c0                	test   %eax,%eax
80104df8:	74 0f                	je     80104e09 <forkret+0x2a>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
80104dfa:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
80104e01:	00 00 00 
        initlog();
80104e04:	e8 fb e1 ff ff       	call   80103004 <initlog>
    }

    // Return to "caller", actually trapret (see allocproc).
}
80104e09:	c9                   	leave  
80104e0a:	c3                   	ret    

80104e0b <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
80104e0b:	55                   	push   %ebp
80104e0c:	89 e5                	mov    %esp,%ebp
80104e0e:	83 ec 18             	sub    $0x18,%esp
    if(proc == 0)
80104e11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e17:	85 c0                	test   %eax,%eax
80104e19:	75 0c                	jne    80104e27 <sleep+0x1c>
        panic("sleep");
80104e1b:	c7 04 24 ee 8b 10 80 	movl   $0x80108bee,(%esp)
80104e22:	e8 13 b7 ff ff       	call   8010053a <panic>

    if(lk == 0)
80104e27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e2b:	75 0c                	jne    80104e39 <sleep+0x2e>
        panic("sleep without lk");
80104e2d:	c7 04 24 f4 8b 10 80 	movl   $0x80108bf4,(%esp)
80104e34:	e8 01 b7 ff ff       	call   8010053a <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){  //DOC: sleeplock0
80104e39:	81 7d 0c 80 ff 10 80 	cmpl   $0x8010ff80,0xc(%ebp)
80104e40:	74 17                	je     80104e59 <sleep+0x4e>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104e42:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104e49:	e8 35 03 00 00       	call   80105183 <acquire>
        release(lk);
80104e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e51:	89 04 24             	mov    %eax,(%esp)
80104e54:	e8 8b 03 00 00       	call   801051e4 <release>
    }

    // Go to sleep.
    proc->chan = chan;
80104e59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e5f:	8b 55 08             	mov    0x8(%ebp),%edx
80104e62:	89 50 20             	mov    %edx,0x20(%eax)
    proc->state = SLEEPING;
80104e65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e6b:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    sched();
80104e72:	e8 94 fc ff ff       	call   80104b0b <sched>

    // Tidy up.
    proc->chan = 0;
80104e77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
80104e84:	81 7d 0c 80 ff 10 80 	cmpl   $0x8010ff80,0xc(%ebp)
80104e8b:	74 17                	je     80104ea4 <sleep+0x99>
        release(&ptable.lock);
80104e8d:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104e94:	e8 4b 03 00 00       	call   801051e4 <release>
        acquire(lk);
80104e99:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e9c:	89 04 24             	mov    %eax,(%esp)
80104e9f:	e8 df 02 00 00       	call   80105183 <acquire>
    }
}
80104ea4:	c9                   	leave  
80104ea5:	c3                   	ret    

80104ea6 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
    static void
wakeup1(void *chan)
{
80104ea6:	55                   	push   %ebp
80104ea7:	89 e5                	mov    %esp,%ebp
80104ea9:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104eac:	c7 45 fc b4 ff 10 80 	movl   $0x8010ffb4,-0x4(%ebp)
80104eb3:	eb 27                	jmp    80104edc <wakeup1+0x36>
        if(p->state == SLEEPING && p->chan == chan)
80104eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104eb8:	8b 40 0c             	mov    0xc(%eax),%eax
80104ebb:	83 f8 02             	cmp    $0x2,%eax
80104ebe:	75 15                	jne    80104ed5 <wakeup1+0x2f>
80104ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ec3:	8b 40 20             	mov    0x20(%eax),%eax
80104ec6:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ec9:	75 0a                	jne    80104ed5 <wakeup1+0x2f>
            p->state = RUNNABLE;
80104ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ece:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ed5:	81 45 fc 88 00 00 00 	addl   $0x88,-0x4(%ebp)
80104edc:	b8 b4 21 11 80       	mov    $0x801121b4,%eax
80104ee1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80104ee4:	72 cf                	jb     80104eb5 <wakeup1+0xf>
        if(p->state == SLEEPING && p->chan == chan)
            p->state = RUNNABLE;
}
80104ee6:	c9                   	leave  
80104ee7:	c3                   	ret    

80104ee8 <twakeup>:

void 
twakeup(int tid){
80104ee8:	55                   	push   %ebp
80104ee9:	89 e5                	mov    %esp,%ebp
80104eeb:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    acquire(&ptable.lock);
80104eee:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104ef5:	e8 89 02 00 00       	call   80105183 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104efa:	c7 45 f4 b4 ff 10 80 	movl   $0x8010ffb4,-0xc(%ebp)
80104f01:	eb 36                	jmp    80104f39 <twakeup+0x51>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
80104f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f06:	8b 40 0c             	mov    0xc(%eax),%eax
80104f09:	83 f8 02             	cmp    $0x2,%eax
80104f0c:	75 24                	jne    80104f32 <twakeup+0x4a>
80104f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f11:	8b 40 10             	mov    0x10(%eax),%eax
80104f14:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f17:	75 19                	jne    80104f32 <twakeup+0x4a>
80104f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f1c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104f22:	83 f8 01             	cmp    $0x1,%eax
80104f25:	75 0b                	jne    80104f32 <twakeup+0x4a>
            wakeup1(p);
80104f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2a:	89 04 24             	mov    %eax,(%esp)
80104f2d:	e8 74 ff ff ff       	call   80104ea6 <wakeup1>

void 
twakeup(int tid){
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f32:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104f39:	b8 b4 21 11 80       	mov    $0x801121b4,%eax
80104f3e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104f41:	72 c0                	jb     80104f03 <twakeup+0x1b>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
            wakeup1(p);
        }
    }
    release(&ptable.lock);
80104f43:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104f4a:	e8 95 02 00 00       	call   801051e4 <release>
}
80104f4f:	c9                   	leave  
80104f50:	c3                   	ret    

80104f51 <wakeup>:

// Wake up all processes sleeping on chan.
    void
wakeup(void *chan)
{
80104f51:	55                   	push   %ebp
80104f52:	89 e5                	mov    %esp,%ebp
80104f54:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);
80104f57:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104f5e:	e8 20 02 00 00       	call   80105183 <acquire>
    wakeup1(chan);
80104f63:	8b 45 08             	mov    0x8(%ebp),%eax
80104f66:	89 04 24             	mov    %eax,(%esp)
80104f69:	e8 38 ff ff ff       	call   80104ea6 <wakeup1>
    release(&ptable.lock);
80104f6e:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104f75:	e8 6a 02 00 00       	call   801051e4 <release>
}
80104f7a:	c9                   	leave  
80104f7b:	c3                   	ret    

80104f7c <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
    int
kill(int pid)
{
80104f7c:	55                   	push   %ebp
80104f7d:	89 e5                	mov    %esp,%ebp
80104f7f:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    acquire(&ptable.lock);
80104f82:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104f89:	e8 f5 01 00 00       	call   80105183 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f8e:	c7 45 f4 b4 ff 10 80 	movl   $0x8010ffb4,-0xc(%ebp)
80104f95:	eb 44                	jmp    80104fdb <kill+0x5f>
        if(p->pid == pid){
80104f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f9a:	8b 40 10             	mov    0x10(%eax),%eax
80104f9d:	3b 45 08             	cmp    0x8(%ebp),%eax
80104fa0:	75 32                	jne    80104fd4 <kill+0x58>
            p->killed = 1;
80104fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
80104fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104faf:	8b 40 0c             	mov    0xc(%eax),%eax
80104fb2:	83 f8 02             	cmp    $0x2,%eax
80104fb5:	75 0a                	jne    80104fc1 <kill+0x45>
                p->state = RUNNABLE;
80104fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fba:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104fc1:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104fc8:	e8 17 02 00 00       	call   801051e4 <release>
            return 0;
80104fcd:	b8 00 00 00 00       	mov    $0x0,%eax
80104fd2:	eb 22                	jmp    80104ff6 <kill+0x7a>
kill(int pid)
{
    struct proc *p;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fd4:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104fdb:	b8 b4 21 11 80       	mov    $0x801121b4,%eax
80104fe0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104fe3:	72 b2                	jb     80104f97 <kill+0x1b>
                p->state = RUNNABLE;
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80104fe5:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80104fec:	e8 f3 01 00 00       	call   801051e4 <release>
    return -1;
80104ff1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ff6:	c9                   	leave  
80104ff7:	c3                   	ret    

80104ff8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
    void
procdump(void)
{
80104ff8:	55                   	push   %ebp
80104ff9:	89 e5                	mov    %esp,%ebp
80104ffb:	83 ec 58             	sub    $0x58,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ffe:	c7 45 f0 b4 ff 10 80 	movl   $0x8010ffb4,-0x10(%ebp)
80105005:	e9 db 00 00 00       	jmp    801050e5 <procdump+0xed>
        if(p->state == UNUSED)
8010500a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010500d:	8b 40 0c             	mov    0xc(%eax),%eax
80105010:	85 c0                	test   %eax,%eax
80105012:	0f 84 c5 00 00 00    	je     801050dd <procdump+0xe5>
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105018:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010501b:	8b 40 0c             	mov    0xc(%eax),%eax
8010501e:	83 f8 05             	cmp    $0x5,%eax
80105021:	77 23                	ja     80105046 <procdump+0x4e>
80105023:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105026:	8b 40 0c             	mov    0xc(%eax),%eax
80105029:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80105030:	85 c0                	test   %eax,%eax
80105032:	74 12                	je     80105046 <procdump+0x4e>
            state = states[p->state];
80105034:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105037:	8b 40 0c             	mov    0xc(%eax),%eax
8010503a:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80105041:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105044:	eb 07                	jmp    8010504d <procdump+0x55>
            state = states[p->state];
        else
            state = "???";
80105046:	c7 45 f4 05 8c 10 80 	movl   $0x80108c05,-0xc(%ebp)
        cprintf("%d %s %s", p->pid, state, p->name);
8010504d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105050:	8d 50 6c             	lea    0x6c(%eax),%edx
80105053:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105056:	8b 40 10             	mov    0x10(%eax),%eax
80105059:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010505d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105060:	89 54 24 08          	mov    %edx,0x8(%esp)
80105064:	89 44 24 04          	mov    %eax,0x4(%esp)
80105068:	c7 04 24 09 8c 10 80 	movl   $0x80108c09,(%esp)
8010506f:	e8 26 b3 ff ff       	call   8010039a <cprintf>
        if(p->state == SLEEPING){
80105074:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105077:	8b 40 0c             	mov    0xc(%eax),%eax
8010507a:	83 f8 02             	cmp    $0x2,%eax
8010507d:	75 50                	jne    801050cf <procdump+0xd7>
            getcallerpcs((uint*)p->context->ebp+2, pc);
8010507f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105082:	8b 40 1c             	mov    0x1c(%eax),%eax
80105085:	8b 40 0c             	mov    0xc(%eax),%eax
80105088:	83 c0 08             	add    $0x8,%eax
8010508b:	8d 55 c4             	lea    -0x3c(%ebp),%edx
8010508e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105092:	89 04 24             	mov    %eax,(%esp)
80105095:	e8 99 01 00 00       	call   80105233 <getcallerpcs>
            for(i=0; i<10 && pc[i] != 0; i++)
8010509a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801050a1:	eb 1b                	jmp    801050be <procdump+0xc6>
                cprintf(" %p", pc[i]);
801050a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050a6:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801050ae:	c7 04 24 12 8c 10 80 	movl   $0x80108c12,(%esp)
801050b5:	e8 e0 b2 ff ff       	call   8010039a <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
801050ba:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801050be:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
801050c2:	7f 0b                	jg     801050cf <procdump+0xd7>
801050c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050c7:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050cb:	85 c0                	test   %eax,%eax
801050cd:	75 d4                	jne    801050a3 <procdump+0xab>
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
801050cf:	c7 04 24 16 8c 10 80 	movl   $0x80108c16,(%esp)
801050d6:	e8 bf b2 ff ff       	call   8010039a <cprintf>
801050db:	eb 01                	jmp    801050de <procdump+0xe6>
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
801050dd:	90                   	nop
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050de:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
801050e5:	b8 b4 21 11 80       	mov    $0x801121b4,%eax
801050ea:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801050ed:	0f 82 17 ff ff ff    	jb     8010500a <procdump+0x12>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
801050f3:	c9                   	leave  
801050f4:	c3                   	ret    

801050f5 <tsleep>:

void tsleep(void){
801050f5:	55                   	push   %ebp
801050f6:	89 e5                	mov    %esp,%ebp
801050f8:	83 ec 18             	sub    $0x18,%esp
    
    acquire(&ptable.lock); 
801050fb:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80105102:	e8 7c 00 00 00       	call   80105183 <acquire>
    sleep(proc, &ptable.lock);
80105107:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010510d:	c7 44 24 04 80 ff 10 	movl   $0x8010ff80,0x4(%esp)
80105114:	80 
80105115:	89 04 24             	mov    %eax,(%esp)
80105118:	e8 ee fc ff ff       	call   80104e0b <sleep>
    release(&ptable.lock);
8010511d:	c7 04 24 80 ff 10 80 	movl   $0x8010ff80,(%esp)
80105124:	e8 bb 00 00 00       	call   801051e4 <release>

}
80105129:	c9                   	leave  
8010512a:	c3                   	ret    
	...

8010512c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010512c:	55                   	push   %ebp
8010512d:	89 e5                	mov    %esp,%ebp
8010512f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105132:	9c                   	pushf  
80105133:	58                   	pop    %eax
80105134:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105137:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010513a:	c9                   	leave  
8010513b:	c3                   	ret    

8010513c <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010513c:	55                   	push   %ebp
8010513d:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010513f:	fa                   	cli    
}
80105140:	5d                   	pop    %ebp
80105141:	c3                   	ret    

80105142 <sti>:

static inline void
sti(void)
{
80105142:	55                   	push   %ebp
80105143:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105145:	fb                   	sti    
}
80105146:	5d                   	pop    %ebp
80105147:	c3                   	ret    

80105148 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105148:	55                   	push   %ebp
80105149:	89 e5                	mov    %esp,%ebp
8010514b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010514e:	8b 55 08             	mov    0x8(%ebp),%edx
80105151:	8b 45 0c             	mov    0xc(%ebp),%eax
80105154:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105157:	f0 87 02             	lock xchg %eax,(%edx)
8010515a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010515d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105160:	c9                   	leave  
80105161:	c3                   	ret    

80105162 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105162:	55                   	push   %ebp
80105163:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105165:	8b 45 08             	mov    0x8(%ebp),%eax
80105168:	8b 55 0c             	mov    0xc(%ebp),%edx
8010516b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010516e:	8b 45 08             	mov    0x8(%ebp),%eax
80105171:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105177:	8b 45 08             	mov    0x8(%ebp),%eax
8010517a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105181:	5d                   	pop    %ebp
80105182:	c3                   	ret    

80105183 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105183:	55                   	push   %ebp
80105184:	89 e5                	mov    %esp,%ebp
80105186:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105189:	e8 3e 01 00 00       	call   801052cc <pushcli>
  if(holding(lk))
8010518e:	8b 45 08             	mov    0x8(%ebp),%eax
80105191:	89 04 24             	mov    %eax,(%esp)
80105194:	e8 09 01 00 00       	call   801052a2 <holding>
80105199:	85 c0                	test   %eax,%eax
8010519b:	74 0c                	je     801051a9 <acquire+0x26>
    panic("acquire");
8010519d:	c7 04 24 42 8c 10 80 	movl   $0x80108c42,(%esp)
801051a4:	e8 91 b3 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801051a9:	8b 45 08             	mov    0x8(%ebp),%eax
801051ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801051b3:	00 
801051b4:	89 04 24             	mov    %eax,(%esp)
801051b7:	e8 8c ff ff ff       	call   80105148 <xchg>
801051bc:	85 c0                	test   %eax,%eax
801051be:	75 e9                	jne    801051a9 <acquire+0x26>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801051c0:	8b 45 08             	mov    0x8(%ebp),%eax
801051c3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801051ca:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801051cd:	8b 45 08             	mov    0x8(%ebp),%eax
801051d0:	83 c0 0c             	add    $0xc,%eax
801051d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801051d7:	8d 45 08             	lea    0x8(%ebp),%eax
801051da:	89 04 24             	mov    %eax,(%esp)
801051dd:	e8 51 00 00 00       	call   80105233 <getcallerpcs>
}
801051e2:	c9                   	leave  
801051e3:	c3                   	ret    

801051e4 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
801051ea:	8b 45 08             	mov    0x8(%ebp),%eax
801051ed:	89 04 24             	mov    %eax,(%esp)
801051f0:	e8 ad 00 00 00       	call   801052a2 <holding>
801051f5:	85 c0                	test   %eax,%eax
801051f7:	75 0c                	jne    80105205 <release+0x21>
    panic("release");
801051f9:	c7 04 24 4a 8c 10 80 	movl   $0x80108c4a,(%esp)
80105200:	e8 35 b3 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80105205:	8b 45 08             	mov    0x8(%ebp),%eax
80105208:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010520f:	8b 45 08             	mov    0x8(%ebp),%eax
80105212:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105219:	8b 45 08             	mov    0x8(%ebp),%eax
8010521c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105223:	00 
80105224:	89 04 24             	mov    %eax,(%esp)
80105227:	e8 1c ff ff ff       	call   80105148 <xchg>

  popcli();
8010522c:	e8 e3 00 00 00       	call   80105314 <popcli>
}
80105231:	c9                   	leave  
80105232:	c3                   	ret    

80105233 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105233:	55                   	push   %ebp
80105234:	89 e5                	mov    %esp,%ebp
80105236:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105239:	8b 45 08             	mov    0x8(%ebp),%eax
8010523c:	83 e8 08             	sub    $0x8,%eax
8010523f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(i = 0; i < 10; i++){
80105242:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105249:	eb 34                	jmp    8010527f <getcallerpcs+0x4c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010524b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
8010524f:	74 49                	je     8010529a <getcallerpcs+0x67>
80105251:	81 7d f8 ff ff ff 7f 	cmpl   $0x7fffffff,-0x8(%ebp)
80105258:	76 40                	jbe    8010529a <getcallerpcs+0x67>
8010525a:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
8010525e:	74 3a                	je     8010529a <getcallerpcs+0x67>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105260:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105263:	c1 e0 02             	shl    $0x2,%eax
80105266:	03 45 0c             	add    0xc(%ebp),%eax
80105269:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010526c:	83 c2 04             	add    $0x4,%edx
8010526f:	8b 12                	mov    (%edx),%edx
80105271:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
80105273:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105276:	8b 00                	mov    (%eax),%eax
80105278:	89 45 f8             	mov    %eax,-0x8(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010527b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010527f:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80105283:	7e c6                	jle    8010524b <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105285:	eb 13                	jmp    8010529a <getcallerpcs+0x67>
    pcs[i] = 0;
80105287:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010528a:	c1 e0 02             	shl    $0x2,%eax
8010528d:	03 45 0c             	add    0xc(%ebp),%eax
80105290:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105296:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010529a:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
8010529e:	7e e7                	jle    80105287 <getcallerpcs+0x54>
    pcs[i] = 0;
}
801052a0:	c9                   	leave  
801052a1:	c3                   	ret    

801052a2 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801052a2:	55                   	push   %ebp
801052a3:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801052a5:	8b 45 08             	mov    0x8(%ebp),%eax
801052a8:	8b 00                	mov    (%eax),%eax
801052aa:	85 c0                	test   %eax,%eax
801052ac:	74 17                	je     801052c5 <holding+0x23>
801052ae:	8b 45 08             	mov    0x8(%ebp),%eax
801052b1:	8b 50 08             	mov    0x8(%eax),%edx
801052b4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052ba:	39 c2                	cmp    %eax,%edx
801052bc:	75 07                	jne    801052c5 <holding+0x23>
801052be:	b8 01 00 00 00       	mov    $0x1,%eax
801052c3:	eb 05                	jmp    801052ca <holding+0x28>
801052c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052ca:	5d                   	pop    %ebp
801052cb:	c3                   	ret    

801052cc <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801052cc:	55                   	push   %ebp
801052cd:	89 e5                	mov    %esp,%ebp
801052cf:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801052d2:	e8 55 fe ff ff       	call   8010512c <readeflags>
801052d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801052da:	e8 5d fe ff ff       	call   8010513c <cli>
  if(cpu->ncli++ == 0)
801052df:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052e5:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801052eb:	85 d2                	test   %edx,%edx
801052ed:	0f 94 c1             	sete   %cl
801052f0:	83 c2 01             	add    $0x1,%edx
801052f3:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801052f9:	84 c9                	test   %cl,%cl
801052fb:	74 15                	je     80105312 <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
801052fd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105303:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105306:	81 e2 00 02 00 00    	and    $0x200,%edx
8010530c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105312:	c9                   	leave  
80105313:	c3                   	ret    

80105314 <popcli>:

void
popcli(void)
{
80105314:	55                   	push   %ebp
80105315:	89 e5                	mov    %esp,%ebp
80105317:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010531a:	e8 0d fe ff ff       	call   8010512c <readeflags>
8010531f:	25 00 02 00 00       	and    $0x200,%eax
80105324:	85 c0                	test   %eax,%eax
80105326:	74 0c                	je     80105334 <popcli+0x20>
    panic("popcli - interruptible");
80105328:	c7 04 24 52 8c 10 80 	movl   $0x80108c52,(%esp)
8010532f:	e8 06 b2 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80105334:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010533a:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105340:	83 ea 01             	sub    $0x1,%edx
80105343:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105349:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010534f:	85 c0                	test   %eax,%eax
80105351:	79 0c                	jns    8010535f <popcli+0x4b>
    panic("popcli");
80105353:	c7 04 24 69 8c 10 80 	movl   $0x80108c69,(%esp)
8010535a:	e8 db b1 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010535f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105365:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010536b:	85 c0                	test   %eax,%eax
8010536d:	75 15                	jne    80105384 <popcli+0x70>
8010536f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105375:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010537b:	85 c0                	test   %eax,%eax
8010537d:	74 05                	je     80105384 <popcli+0x70>
    sti();
8010537f:	e8 be fd ff ff       	call   80105142 <sti>
}
80105384:	c9                   	leave  
80105385:	c3                   	ret    
	...

80105388 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105388:	55                   	push   %ebp
80105389:	89 e5                	mov    %esp,%ebp
8010538b:	57                   	push   %edi
8010538c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010538d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105390:	8b 55 10             	mov    0x10(%ebp),%edx
80105393:	8b 45 0c             	mov    0xc(%ebp),%eax
80105396:	89 cb                	mov    %ecx,%ebx
80105398:	89 df                	mov    %ebx,%edi
8010539a:	89 d1                	mov    %edx,%ecx
8010539c:	fc                   	cld    
8010539d:	f3 aa                	rep stos %al,%es:(%edi)
8010539f:	89 ca                	mov    %ecx,%edx
801053a1:	89 fb                	mov    %edi,%ebx
801053a3:	89 5d 08             	mov    %ebx,0x8(%ebp)
801053a6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801053a9:	5b                   	pop    %ebx
801053aa:	5f                   	pop    %edi
801053ab:	5d                   	pop    %ebp
801053ac:	c3                   	ret    

801053ad <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801053ad:	55                   	push   %ebp
801053ae:	89 e5                	mov    %esp,%ebp
801053b0:	57                   	push   %edi
801053b1:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801053b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053b5:	8b 55 10             	mov    0x10(%ebp),%edx
801053b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801053bb:	89 cb                	mov    %ecx,%ebx
801053bd:	89 df                	mov    %ebx,%edi
801053bf:	89 d1                	mov    %edx,%ecx
801053c1:	fc                   	cld    
801053c2:	f3 ab                	rep stos %eax,%es:(%edi)
801053c4:	89 ca                	mov    %ecx,%edx
801053c6:	89 fb                	mov    %edi,%ebx
801053c8:	89 5d 08             	mov    %ebx,0x8(%ebp)
801053cb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801053ce:	5b                   	pop    %ebx
801053cf:	5f                   	pop    %edi
801053d0:	5d                   	pop    %ebp
801053d1:	c3                   	ret    

801053d2 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801053d2:	55                   	push   %ebp
801053d3:	89 e5                	mov    %esp,%ebp
801053d5:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801053d8:	8b 45 08             	mov    0x8(%ebp),%eax
801053db:	83 e0 03             	and    $0x3,%eax
801053de:	85 c0                	test   %eax,%eax
801053e0:	75 49                	jne    8010542b <memset+0x59>
801053e2:	8b 45 10             	mov    0x10(%ebp),%eax
801053e5:	83 e0 03             	and    $0x3,%eax
801053e8:	85 c0                	test   %eax,%eax
801053ea:	75 3f                	jne    8010542b <memset+0x59>
    c &= 0xFF;
801053ec:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801053f3:	8b 45 10             	mov    0x10(%ebp),%eax
801053f6:	c1 e8 02             	shr    $0x2,%eax
801053f9:	89 c2                	mov    %eax,%edx
801053fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801053fe:	89 c1                	mov    %eax,%ecx
80105400:	c1 e1 18             	shl    $0x18,%ecx
80105403:	8b 45 0c             	mov    0xc(%ebp),%eax
80105406:	c1 e0 10             	shl    $0x10,%eax
80105409:	09 c1                	or     %eax,%ecx
8010540b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010540e:	c1 e0 08             	shl    $0x8,%eax
80105411:	09 c8                	or     %ecx,%eax
80105413:	0b 45 0c             	or     0xc(%ebp),%eax
80105416:	89 54 24 08          	mov    %edx,0x8(%esp)
8010541a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010541e:	8b 45 08             	mov    0x8(%ebp),%eax
80105421:	89 04 24             	mov    %eax,(%esp)
80105424:	e8 84 ff ff ff       	call   801053ad <stosl>
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
80105429:	eb 19                	jmp    80105444 <memset+0x72>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
8010542b:	8b 45 10             	mov    0x10(%ebp),%eax
8010542e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105432:	8b 45 0c             	mov    0xc(%ebp),%eax
80105435:	89 44 24 04          	mov    %eax,0x4(%esp)
80105439:	8b 45 08             	mov    0x8(%ebp),%eax
8010543c:	89 04 24             	mov    %eax,(%esp)
8010543f:	e8 44 ff ff ff       	call   80105388 <stosb>
  return dst;
80105444:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105447:	c9                   	leave  
80105448:	c3                   	ret    

80105449 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105449:	55                   	push   %ebp
8010544a:	89 e5                	mov    %esp,%ebp
8010544c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010544f:	8b 45 08             	mov    0x8(%ebp),%eax
80105452:	89 45 f8             	mov    %eax,-0x8(%ebp)
  s2 = v2;
80105455:	8b 45 0c             	mov    0xc(%ebp),%eax
80105458:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0){
8010545b:	eb 32                	jmp    8010548f <memcmp+0x46>
    if(*s1 != *s2)
8010545d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105460:	0f b6 10             	movzbl (%eax),%edx
80105463:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105466:	0f b6 00             	movzbl (%eax),%eax
80105469:	38 c2                	cmp    %al,%dl
8010546b:	74 1a                	je     80105487 <memcmp+0x3e>
      return *s1 - *s2;
8010546d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105470:	0f b6 00             	movzbl (%eax),%eax
80105473:	0f b6 d0             	movzbl %al,%edx
80105476:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105479:	0f b6 00             	movzbl (%eax),%eax
8010547c:	0f b6 c0             	movzbl %al,%eax
8010547f:	89 d1                	mov    %edx,%ecx
80105481:	29 c1                	sub    %eax,%ecx
80105483:	89 c8                	mov    %ecx,%eax
80105485:	eb 1c                	jmp    801054a3 <memcmp+0x5a>
    s1++, s2++;
80105487:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010548b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010548f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105493:	0f 95 c0             	setne  %al
80105496:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010549a:	84 c0                	test   %al,%al
8010549c:	75 bf                	jne    8010545d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010549e:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054a3:	c9                   	leave  
801054a4:	c3                   	ret    

801054a5 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801054a5:	55                   	push   %ebp
801054a6:	89 e5                	mov    %esp,%ebp
801054a8:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801054ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
  d = dst;
801054b1:	8b 45 08             	mov    0x8(%ebp),%eax
801054b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(s < d && s + n > d){
801054b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
801054bd:	73 55                	jae    80105514 <memmove+0x6f>
801054bf:	8b 45 10             	mov    0x10(%ebp),%eax
801054c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
801054c5:	8d 04 02             	lea    (%edx,%eax,1),%eax
801054c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
801054cb:	76 4a                	jbe    80105517 <memmove+0x72>
    s += n;
801054cd:	8b 45 10             	mov    0x10(%ebp),%eax
801054d0:	01 45 f8             	add    %eax,-0x8(%ebp)
    d += n;
801054d3:	8b 45 10             	mov    0x10(%ebp),%eax
801054d6:	01 45 fc             	add    %eax,-0x4(%ebp)
    while(n-- > 0)
801054d9:	eb 13                	jmp    801054ee <memmove+0x49>
      *--d = *--s;
801054db:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801054df:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801054e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054e6:	0f b6 10             	movzbl (%eax),%edx
801054e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054ec:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801054ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054f2:	0f 95 c0             	setne  %al
801054f5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801054f9:	84 c0                	test   %al,%al
801054fb:	75 de                	jne    801054db <memmove+0x36>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801054fd:	eb 28                	jmp    80105527 <memmove+0x82>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801054ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105502:	0f b6 10             	movzbl (%eax),%edx
80105505:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105508:	88 10                	mov    %dl,(%eax)
8010550a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010550e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105512:	eb 04                	jmp    80105518 <memmove+0x73>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105514:	90                   	nop
80105515:	eb 01                	jmp    80105518 <memmove+0x73>
80105517:	90                   	nop
80105518:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010551c:	0f 95 c0             	setne  %al
8010551f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105523:	84 c0                	test   %al,%al
80105525:	75 d8                	jne    801054ff <memmove+0x5a>
      *d++ = *s++;

  return dst;
80105527:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010552a:	c9                   	leave  
8010552b:	c3                   	ret    

8010552c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010552c:	55                   	push   %ebp
8010552d:	89 e5                	mov    %esp,%ebp
8010552f:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105532:	8b 45 10             	mov    0x10(%ebp),%eax
80105535:	89 44 24 08          	mov    %eax,0x8(%esp)
80105539:	8b 45 0c             	mov    0xc(%ebp),%eax
8010553c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105540:	8b 45 08             	mov    0x8(%ebp),%eax
80105543:	89 04 24             	mov    %eax,(%esp)
80105546:	e8 5a ff ff ff       	call   801054a5 <memmove>
}
8010554b:	c9                   	leave  
8010554c:	c3                   	ret    

8010554d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010554d:	55                   	push   %ebp
8010554e:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105550:	eb 0c                	jmp    8010555e <strncmp+0x11>
    n--, p++, q++;
80105552:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105556:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010555a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010555e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105562:	74 1a                	je     8010557e <strncmp+0x31>
80105564:	8b 45 08             	mov    0x8(%ebp),%eax
80105567:	0f b6 00             	movzbl (%eax),%eax
8010556a:	84 c0                	test   %al,%al
8010556c:	74 10                	je     8010557e <strncmp+0x31>
8010556e:	8b 45 08             	mov    0x8(%ebp),%eax
80105571:	0f b6 10             	movzbl (%eax),%edx
80105574:	8b 45 0c             	mov    0xc(%ebp),%eax
80105577:	0f b6 00             	movzbl (%eax),%eax
8010557a:	38 c2                	cmp    %al,%dl
8010557c:	74 d4                	je     80105552 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010557e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105582:	75 07                	jne    8010558b <strncmp+0x3e>
    return 0;
80105584:	b8 00 00 00 00       	mov    $0x0,%eax
80105589:	eb 18                	jmp    801055a3 <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
8010558b:	8b 45 08             	mov    0x8(%ebp),%eax
8010558e:	0f b6 00             	movzbl (%eax),%eax
80105591:	0f b6 d0             	movzbl %al,%edx
80105594:	8b 45 0c             	mov    0xc(%ebp),%eax
80105597:	0f b6 00             	movzbl (%eax),%eax
8010559a:	0f b6 c0             	movzbl %al,%eax
8010559d:	89 d1                	mov    %edx,%ecx
8010559f:	29 c1                	sub    %eax,%ecx
801055a1:	89 c8                	mov    %ecx,%eax
}
801055a3:	5d                   	pop    %ebp
801055a4:	c3                   	ret    

801055a5 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801055a5:	55                   	push   %ebp
801055a6:	89 e5                	mov    %esp,%ebp
801055a8:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801055ab:	8b 45 08             	mov    0x8(%ebp),%eax
801055ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801055b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055b5:	0f 9f c0             	setg   %al
801055b8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801055bc:	84 c0                	test   %al,%al
801055be:	74 30                	je     801055f0 <strncpy+0x4b>
801055c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801055c3:	0f b6 10             	movzbl (%eax),%edx
801055c6:	8b 45 08             	mov    0x8(%ebp),%eax
801055c9:	88 10                	mov    %dl,(%eax)
801055cb:	8b 45 08             	mov    0x8(%ebp),%eax
801055ce:	0f b6 00             	movzbl (%eax),%eax
801055d1:	84 c0                	test   %al,%al
801055d3:	0f 95 c0             	setne  %al
801055d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801055da:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801055de:	84 c0                	test   %al,%al
801055e0:	75 cf                	jne    801055b1 <strncpy+0xc>
    ;
  while(n-- > 0)
801055e2:	eb 0d                	jmp    801055f1 <strncpy+0x4c>
    *s++ = 0;
801055e4:	8b 45 08             	mov    0x8(%ebp),%eax
801055e7:	c6 00 00             	movb   $0x0,(%eax)
801055ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801055ee:	eb 01                	jmp    801055f1 <strncpy+0x4c>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801055f0:	90                   	nop
801055f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055f5:	0f 9f c0             	setg   %al
801055f8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801055fc:	84 c0                	test   %al,%al
801055fe:	75 e4                	jne    801055e4 <strncpy+0x3f>
    *s++ = 0;
  return os;
80105600:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105603:	c9                   	leave  
80105604:	c3                   	ret    

80105605 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105605:	55                   	push   %ebp
80105606:	89 e5                	mov    %esp,%ebp
80105608:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010560b:	8b 45 08             	mov    0x8(%ebp),%eax
8010560e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105611:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105615:	7f 05                	jg     8010561c <safestrcpy+0x17>
    return os;
80105617:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010561a:	eb 35                	jmp    80105651 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
8010561c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105620:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105624:	7e 22                	jle    80105648 <safestrcpy+0x43>
80105626:	8b 45 0c             	mov    0xc(%ebp),%eax
80105629:	0f b6 10             	movzbl (%eax),%edx
8010562c:	8b 45 08             	mov    0x8(%ebp),%eax
8010562f:	88 10                	mov    %dl,(%eax)
80105631:	8b 45 08             	mov    0x8(%ebp),%eax
80105634:	0f b6 00             	movzbl (%eax),%eax
80105637:	84 c0                	test   %al,%al
80105639:	0f 95 c0             	setne  %al
8010563c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105640:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105644:	84 c0                	test   %al,%al
80105646:	75 d4                	jne    8010561c <safestrcpy+0x17>
    ;
  *s = 0;
80105648:	8b 45 08             	mov    0x8(%ebp),%eax
8010564b:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010564e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105651:	c9                   	leave  
80105652:	c3                   	ret    

80105653 <strlen>:

int
strlen(const char *s)
{
80105653:	55                   	push   %ebp
80105654:	89 e5                	mov    %esp,%ebp
80105656:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105659:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105660:	eb 04                	jmp    80105666 <strlen+0x13>
80105662:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105666:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105669:	03 45 08             	add    0x8(%ebp),%eax
8010566c:	0f b6 00             	movzbl (%eax),%eax
8010566f:	84 c0                	test   %al,%al
80105671:	75 ef                	jne    80105662 <strlen+0xf>
    ;
  return n;
80105673:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105676:	c9                   	leave  
80105677:	c3                   	ret    

80105678 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105678:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010567c:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105680:	55                   	push   %ebp
  pushl %ebx
80105681:	53                   	push   %ebx
  pushl %esi
80105682:	56                   	push   %esi
  pushl %edi
80105683:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105684:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105686:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105688:	5f                   	pop    %edi
  popl %esi
80105689:	5e                   	pop    %esi
  popl %ebx
8010568a:	5b                   	pop    %ebx
  popl %ebp
8010568b:	5d                   	pop    %ebp
  ret
8010568c:	c3                   	ret    
8010568d:	00 00                	add    %al,(%eax)
	...

80105690 <fetchint>:
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105699:	8b 00                	mov    (%eax),%eax
8010569b:	3b 45 08             	cmp    0x8(%ebp),%eax
8010569e:	76 12                	jbe    801056b2 <fetchint+0x22>
801056a0:	8b 45 08             	mov    0x8(%ebp),%eax
801056a3:	8d 50 04             	lea    0x4(%eax),%edx
801056a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056ac:	8b 00                	mov    (%eax),%eax
801056ae:	39 c2                	cmp    %eax,%edx
801056b0:	76 07                	jbe    801056b9 <fetchint+0x29>
801056b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b7:	eb 0f                	jmp    801056c8 <fetchint+0x38>
801056b9:	8b 45 08             	mov    0x8(%ebp),%eax
801056bc:	8b 10                	mov    (%eax),%edx
801056be:	8b 45 0c             	mov    0xc(%ebp),%eax
801056c1:	89 10                	mov    %edx,(%eax)
801056c3:	b8 00 00 00 00       	mov    $0x0,%eax
801056c8:	5d                   	pop    %ebp
801056c9:	c3                   	ret    

801056ca <fetchstr>:
801056ca:	55                   	push   %ebp
801056cb:	89 e5                	mov    %esp,%ebp
801056cd:	83 ec 10             	sub    $0x10,%esp
801056d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056d6:	8b 00                	mov    (%eax),%eax
801056d8:	3b 45 08             	cmp    0x8(%ebp),%eax
801056db:	77 07                	ja     801056e4 <fetchstr+0x1a>
801056dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e2:	eb 48                	jmp    8010572c <fetchstr+0x62>
801056e4:	8b 55 08             	mov    0x8(%ebp),%edx
801056e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ea:	89 10                	mov    %edx,(%eax)
801056ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056f2:	8b 00                	mov    (%eax),%eax
801056f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
801056f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801056fa:	8b 00                	mov    (%eax),%eax
801056fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
801056ff:	eb 1e                	jmp    8010571f <fetchstr+0x55>
80105701:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105704:	0f b6 00             	movzbl (%eax),%eax
80105707:	84 c0                	test   %al,%al
80105709:	75 10                	jne    8010571b <fetchstr+0x51>
8010570b:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010570e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105711:	8b 00                	mov    (%eax),%eax
80105713:	89 d1                	mov    %edx,%ecx
80105715:	29 c1                	sub    %eax,%ecx
80105717:	89 c8                	mov    %ecx,%eax
80105719:	eb 11                	jmp    8010572c <fetchstr+0x62>
8010571b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010571f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105722:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105725:	72 da                	jb     80105701 <fetchstr+0x37>
80105727:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572c:	c9                   	leave  
8010572d:	c3                   	ret    

8010572e <argint>:
8010572e:	55                   	push   %ebp
8010572f:	89 e5                	mov    %esp,%ebp
80105731:	83 ec 08             	sub    $0x8,%esp
80105734:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010573a:	8b 40 18             	mov    0x18(%eax),%eax
8010573d:	8b 50 44             	mov    0x44(%eax),%edx
80105740:	8b 45 08             	mov    0x8(%ebp),%eax
80105743:	c1 e0 02             	shl    $0x2,%eax
80105746:	8d 04 02             	lea    (%edx,%eax,1),%eax
80105749:	8d 50 04             	lea    0x4(%eax),%edx
8010574c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010574f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105753:	89 14 24             	mov    %edx,(%esp)
80105756:	e8 35 ff ff ff       	call   80105690 <fetchint>
8010575b:	c9                   	leave  
8010575c:	c3                   	ret    

8010575d <argptr>:
8010575d:	55                   	push   %ebp
8010575e:	89 e5                	mov    %esp,%ebp
80105760:	83 ec 18             	sub    $0x18,%esp
80105763:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105766:	89 44 24 04          	mov    %eax,0x4(%esp)
8010576a:	8b 45 08             	mov    0x8(%ebp),%eax
8010576d:	89 04 24             	mov    %eax,(%esp)
80105770:	e8 b9 ff ff ff       	call   8010572e <argint>
80105775:	85 c0                	test   %eax,%eax
80105777:	79 07                	jns    80105780 <argptr+0x23>
80105779:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577e:	eb 3d                	jmp    801057bd <argptr+0x60>
80105780:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105783:	89 c2                	mov    %eax,%edx
80105785:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010578b:	8b 00                	mov    (%eax),%eax
8010578d:	39 c2                	cmp    %eax,%edx
8010578f:	73 16                	jae    801057a7 <argptr+0x4a>
80105791:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105794:	89 c2                	mov    %eax,%edx
80105796:	8b 45 10             	mov    0x10(%ebp),%eax
80105799:	01 c2                	add    %eax,%edx
8010579b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057a1:	8b 00                	mov    (%eax),%eax
801057a3:	39 c2                	cmp    %eax,%edx
801057a5:	76 07                	jbe    801057ae <argptr+0x51>
801057a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ac:	eb 0f                	jmp    801057bd <argptr+0x60>
801057ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057b1:	89 c2                	mov    %eax,%edx
801057b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801057b6:	89 10                	mov    %edx,(%eax)
801057b8:	b8 00 00 00 00       	mov    $0x0,%eax
801057bd:	c9                   	leave  
801057be:	c3                   	ret    

801057bf <argstr>:
801057bf:	55                   	push   %ebp
801057c0:	89 e5                	mov    %esp,%ebp
801057c2:	83 ec 18             	sub    $0x18,%esp
801057c5:	8d 45 fc             	lea    -0x4(%ebp),%eax
801057c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801057cc:	8b 45 08             	mov    0x8(%ebp),%eax
801057cf:	89 04 24             	mov    %eax,(%esp)
801057d2:	e8 57 ff ff ff       	call   8010572e <argint>
801057d7:	85 c0                	test   %eax,%eax
801057d9:	79 07                	jns    801057e2 <argstr+0x23>
801057db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e0:	eb 12                	jmp    801057f4 <argstr+0x35>
801057e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057e5:	8b 55 0c             	mov    0xc(%ebp),%edx
801057e8:	89 54 24 04          	mov    %edx,0x4(%esp)
801057ec:	89 04 24             	mov    %eax,(%esp)
801057ef:	e8 d6 fe ff ff       	call   801056ca <fetchstr>
801057f4:	c9                   	leave  
801057f5:	c3                   	ret    

801057f6 <syscall>:
801057f6:	55                   	push   %ebp
801057f7:	89 e5                	mov    %esp,%ebp
801057f9:	53                   	push   %ebx
801057fa:	83 ec 24             	sub    $0x24,%esp
801057fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105803:	8b 40 18             	mov    0x18(%eax),%eax
80105806:	8b 40 1c             	mov    0x1c(%eax),%eax
80105809:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010580c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105810:	7e 30                	jle    80105842 <syscall+0x4c>
80105812:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105815:	83 f8 1a             	cmp    $0x1a,%eax
80105818:	77 28                	ja     80105842 <syscall+0x4c>
8010581a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010581d:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105824:	85 c0                	test   %eax,%eax
80105826:	74 1a                	je     80105842 <syscall+0x4c>
80105828:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010582e:	8b 58 18             	mov    0x18(%eax),%ebx
80105831:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105834:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010583b:	ff d0                	call   *%eax
8010583d:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105840:	eb 3d                	jmp    8010587f <syscall+0x89>
80105842:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105848:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010584b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105851:	8b 40 10             	mov    0x10(%eax),%eax
80105854:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105857:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010585b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010585f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105863:	c7 04 24 70 8c 10 80 	movl   $0x80108c70,(%esp)
8010586a:	e8 2b ab ff ff       	call   8010039a <cprintf>
8010586f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105875:	8b 40 18             	mov    0x18(%eax),%eax
80105878:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010587f:	83 c4 24             	add    $0x24,%esp
80105882:	5b                   	pop    %ebx
80105883:	5d                   	pop    %ebp
80105884:	c3                   	ret    
80105885:	00 00                	add    %al,(%eax)
	...

80105888 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105888:	55                   	push   %ebp
80105889:	89 e5                	mov    %esp,%ebp
8010588b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010588e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105891:	89 44 24 04          	mov    %eax,0x4(%esp)
80105895:	8b 45 08             	mov    0x8(%ebp),%eax
80105898:	89 04 24             	mov    %eax,(%esp)
8010589b:	e8 8e fe ff ff       	call   8010572e <argint>
801058a0:	85 c0                	test   %eax,%eax
801058a2:	79 07                	jns    801058ab <argfd+0x23>
    return -1;
801058a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a9:	eb 50                	jmp    801058fb <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801058ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ae:	85 c0                	test   %eax,%eax
801058b0:	78 21                	js     801058d3 <argfd+0x4b>
801058b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b5:	83 f8 0f             	cmp    $0xf,%eax
801058b8:	7f 19                	jg     801058d3 <argfd+0x4b>
801058ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058c3:	83 c2 08             	add    $0x8,%edx
801058c6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801058ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058d1:	75 07                	jne    801058da <argfd+0x52>
    return -1;
801058d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d8:	eb 21                	jmp    801058fb <argfd+0x73>
  if(pfd)
801058da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801058de:	74 08                	je     801058e8 <argfd+0x60>
    *pfd = fd;
801058e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801058e6:	89 10                	mov    %edx,(%eax)
  if(pf)
801058e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058ec:	74 08                	je     801058f6 <argfd+0x6e>
    *pf = f;
801058ee:	8b 45 10             	mov    0x10(%ebp),%eax
801058f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058f4:	89 10                	mov    %edx,(%eax)
  return 0;
801058f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058fb:	c9                   	leave  
801058fc:	c3                   	ret    

801058fd <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801058fd:	55                   	push   %ebp
801058fe:	89 e5                	mov    %esp,%ebp
80105900:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105903:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010590a:	eb 30                	jmp    8010593c <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
8010590c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105912:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105915:	83 c2 08             	add    $0x8,%edx
80105918:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010591c:	85 c0                	test   %eax,%eax
8010591e:	75 18                	jne    80105938 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105920:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105926:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105929:	8d 4a 08             	lea    0x8(%edx),%ecx
8010592c:	8b 55 08             	mov    0x8(%ebp),%edx
8010592f:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105933:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105936:	eb 0f                	jmp    80105947 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105938:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010593c:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105940:	7e ca                	jle    8010590c <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105942:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105947:	c9                   	leave  
80105948:	c3                   	ret    

80105949 <sys_dup>:

int
sys_dup(void)
{
80105949:	55                   	push   %ebp
8010594a:	89 e5                	mov    %esp,%ebp
8010594c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010594f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105952:	89 44 24 08          	mov    %eax,0x8(%esp)
80105956:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010595d:	00 
8010595e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105965:	e8 1e ff ff ff       	call   80105888 <argfd>
8010596a:	85 c0                	test   %eax,%eax
8010596c:	79 07                	jns    80105975 <sys_dup+0x2c>
    return -1;
8010596e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105973:	eb 29                	jmp    8010599e <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105975:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105978:	89 04 24             	mov    %eax,(%esp)
8010597b:	e8 7d ff ff ff       	call   801058fd <fdalloc>
80105980:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105983:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105987:	79 07                	jns    80105990 <sys_dup+0x47>
    return -1;
80105989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598e:	eb 0e                	jmp    8010599e <sys_dup+0x55>
  filedup(f);
80105990:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105993:	89 04 24             	mov    %eax,(%esp)
80105996:	e8 ea b5 ff ff       	call   80100f85 <filedup>
  return fd;
8010599b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010599e:	c9                   	leave  
8010599f:	c3                   	ret    

801059a0 <sys_read>:

int
sys_read(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059a9:	89 44 24 08          	mov    %eax,0x8(%esp)
801059ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059b4:	00 
801059b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059bc:	e8 c7 fe ff ff       	call   80105888 <argfd>
801059c1:	85 c0                	test   %eax,%eax
801059c3:	78 35                	js     801059fa <sys_read+0x5a>
801059c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801059cc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801059d3:	e8 56 fd ff ff       	call   8010572e <argint>
801059d8:	85 c0                	test   %eax,%eax
801059da:	78 1e                	js     801059fa <sys_read+0x5a>
801059dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059df:	89 44 24 08          	mov    %eax,0x8(%esp)
801059e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801059ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801059f1:	e8 67 fd ff ff       	call   8010575d <argptr>
801059f6:	85 c0                	test   %eax,%eax
801059f8:	79 07                	jns    80105a01 <sys_read+0x61>
    return -1;
801059fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ff:	eb 19                	jmp    80105a1a <sys_read+0x7a>
  return fileread(f, p, n);
80105a01:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105a04:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105a0e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a12:	89 04 24             	mov    %eax,(%esp)
80105a15:	e8 d8 b6 ff ff       	call   801010f2 <fileread>
}
80105a1a:	c9                   	leave  
80105a1b:	c3                   	ret    

80105a1c <sys_write>:

int
sys_write(void)
{
80105a1c:	55                   	push   %ebp
80105a1d:	89 e5                	mov    %esp,%ebp
80105a1f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a22:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a25:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a29:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a30:	00 
80105a31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a38:	e8 4b fe ff ff       	call   80105888 <argfd>
80105a3d:	85 c0                	test   %eax,%eax
80105a3f:	78 35                	js     80105a76 <sys_write+0x5a>
80105a41:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a44:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a48:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105a4f:	e8 da fc ff ff       	call   8010572e <argint>
80105a54:	85 c0                	test   %eax,%eax
80105a56:	78 1e                	js     80105a76 <sys_write+0x5a>
80105a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a5b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a5f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a62:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a66:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a6d:	e8 eb fc ff ff       	call   8010575d <argptr>
80105a72:	85 c0                	test   %eax,%eax
80105a74:	79 07                	jns    80105a7d <sys_write+0x61>
    return -1;
80105a76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7b:	eb 19                	jmp    80105a96 <sys_write+0x7a>
  return filewrite(f, p, n);
80105a7d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105a80:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a86:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105a8a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a8e:	89 04 24             	mov    %eax,(%esp)
80105a91:	e8 18 b7 ff ff       	call   801011ae <filewrite>
}
80105a96:	c9                   	leave  
80105a97:	c3                   	ret    

80105a98 <sys_close>:

int
sys_close(void)
{
80105a98:	55                   	push   %ebp
80105a99:	89 e5                	mov    %esp,%ebp
80105a9b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105a9e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105aa1:	89 44 24 08          	mov    %eax,0x8(%esp)
80105aa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ab3:	e8 d0 fd ff ff       	call   80105888 <argfd>
80105ab8:	85 c0                	test   %eax,%eax
80105aba:	79 07                	jns    80105ac3 <sys_close+0x2b>
    return -1;
80105abc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac1:	eb 24                	jmp    80105ae7 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105ac3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105acc:	83 c2 08             	add    $0x8,%edx
80105acf:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105ad6:	00 
  fileclose(f);
80105ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ada:	89 04 24             	mov    %eax,(%esp)
80105add:	e8 eb b4 ff ff       	call   80100fcd <fileclose>
  return 0;
80105ae2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ae7:	c9                   	leave  
80105ae8:	c3                   	ret    

80105ae9 <sys_fstat>:

int
sys_fstat(void)
{
80105ae9:	55                   	push   %ebp
80105aea:	89 e5                	mov    %esp,%ebp
80105aec:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105aef:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105af2:	89 44 24 08          	mov    %eax,0x8(%esp)
80105af6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105afd:	00 
80105afe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b05:	e8 7e fd ff ff       	call   80105888 <argfd>
80105b0a:	85 c0                	test   %eax,%eax
80105b0c:	78 1f                	js     80105b2d <sys_fstat+0x44>
80105b0e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b11:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105b18:	00 
80105b19:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b24:	e8 34 fc ff ff       	call   8010575d <argptr>
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	79 07                	jns    80105b34 <sys_fstat+0x4b>
    return -1;
80105b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b32:	eb 12                	jmp    80105b46 <sys_fstat+0x5d>
  return filestat(f, st);
80105b34:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b3a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b3e:	89 04 24             	mov    %eax,(%esp)
80105b41:	e8 5d b5 ff ff       	call   801010a3 <filestat>
}
80105b46:	c9                   	leave  
80105b47:	c3                   	ret    

80105b48 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105b48:	55                   	push   %ebp
80105b49:	89 e5                	mov    %esp,%ebp
80105b4b:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b4e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105b51:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b5c:	e8 5e fc ff ff       	call   801057bf <argstr>
80105b61:	85 c0                	test   %eax,%eax
80105b63:	78 17                	js     80105b7c <sys_link+0x34>
80105b65:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105b68:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b73:	e8 47 fc ff ff       	call   801057bf <argstr>
80105b78:	85 c0                	test   %eax,%eax
80105b7a:	79 0a                	jns    80105b86 <sys_link+0x3e>
    return -1;
80105b7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b81:	e9 3c 01 00 00       	jmp    80105cc2 <sys_link+0x17a>
  if((ip = namei(old)) == 0)
80105b86:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105b89:	89 04 24             	mov    %eax,(%esp)
80105b8c:	e8 92 c8 ff ff       	call   80102423 <namei>
80105b91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b98:	75 0a                	jne    80105ba4 <sys_link+0x5c>
    return -1;
80105b9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9f:	e9 1e 01 00 00       	jmp    80105cc2 <sys_link+0x17a>

  begin_trans();
80105ba4:	e8 69 d6 ff ff       	call   80103212 <begin_trans>

  ilock(ip);
80105ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bac:	89 04 24             	mov    %eax,(%esp)
80105baf:	e8 c7 bc ff ff       	call   8010187b <ilock>
  if(ip->type == T_DIR){
80105bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105bbb:	66 83 f8 01          	cmp    $0x1,%ax
80105bbf:	75 1a                	jne    80105bdb <sys_link+0x93>
    iunlockput(ip);
80105bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc4:	89 04 24             	mov    %eax,(%esp)
80105bc7:	e8 36 bf ff ff       	call   80101b02 <iunlockput>
    commit_trans();
80105bcc:	e8 8a d6 ff ff       	call   8010325b <commit_trans>
    return -1;
80105bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd6:	e9 e7 00 00 00       	jmp    80105cc2 <sys_link+0x17a>
  }

  ip->nlink++;
80105bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bde:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105be2:	8d 50 01             	lea    0x1(%eax),%edx
80105be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be8:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bef:	89 04 24             	mov    %eax,(%esp)
80105bf2:	e8 c4 ba ff ff       	call   801016bb <iupdate>
  iunlock(ip);
80105bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bfa:	89 04 24             	mov    %eax,(%esp)
80105bfd:	e8 ca bd ff ff       	call   801019cc <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105c02:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c05:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105c08:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c0c:	89 04 24             	mov    %eax,(%esp)
80105c0f:	e8 31 c8 ff ff       	call   80102445 <nameiparent>
80105c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c1b:	74 68                	je     80105c85 <sys_link+0x13d>
    goto bad;
  ilock(dp);
80105c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c20:	89 04 24             	mov    %eax,(%esp)
80105c23:	e8 53 bc ff ff       	call   8010187b <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c2b:	8b 10                	mov    (%eax),%edx
80105c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c30:	8b 00                	mov    (%eax),%eax
80105c32:	39 c2                	cmp    %eax,%edx
80105c34:	75 20                	jne    80105c56 <sys_link+0x10e>
80105c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c39:	8b 40 04             	mov    0x4(%eax),%eax
80105c3c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c40:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105c43:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c4a:	89 04 24             	mov    %eax,(%esp)
80105c4d:	e8 10 c5 ff ff       	call   80102162 <dirlink>
80105c52:	85 c0                	test   %eax,%eax
80105c54:	79 0d                	jns    80105c63 <sys_link+0x11b>
    iunlockput(dp);
80105c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c59:	89 04 24             	mov    %eax,(%esp)
80105c5c:	e8 a1 be ff ff       	call   80101b02 <iunlockput>
    goto bad;
80105c61:	eb 23                	jmp    80105c86 <sys_link+0x13e>
  }
  iunlockput(dp);
80105c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c66:	89 04 24             	mov    %eax,(%esp)
80105c69:	e8 94 be ff ff       	call   80101b02 <iunlockput>
  iput(ip);
80105c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c71:	89 04 24             	mov    %eax,(%esp)
80105c74:	e8 b8 bd ff ff       	call   80101a31 <iput>

  commit_trans();
80105c79:	e8 dd d5 ff ff       	call   8010325b <commit_trans>

  return 0;
80105c7e:	b8 00 00 00 00       	mov    $0x0,%eax
80105c83:	eb 3d                	jmp    80105cc2 <sys_link+0x17a>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105c85:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
80105c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c89:	89 04 24             	mov    %eax,(%esp)
80105c8c:	e8 ea bb ff ff       	call   8010187b <ilock>
  ip->nlink--;
80105c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c94:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c98:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca5:	89 04 24             	mov    %eax,(%esp)
80105ca8:	e8 0e ba ff ff       	call   801016bb <iupdate>
  iunlockput(ip);
80105cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb0:	89 04 24             	mov    %eax,(%esp)
80105cb3:	e8 4a be ff ff       	call   80101b02 <iunlockput>
  commit_trans();
80105cb8:	e8 9e d5 ff ff       	call   8010325b <commit_trans>
  return -1;
80105cbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc2:	c9                   	leave  
80105cc3:	c3                   	ret    

80105cc4 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105cc4:	55                   	push   %ebp
80105cc5:	89 e5                	mov    %esp,%ebp
80105cc7:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105cca:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105cd1:	eb 4b                	jmp    80105d1e <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cd6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cd9:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105ce0:	00 
80105ce1:	89 54 24 08          	mov    %edx,0x8(%esp)
80105ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80105cec:	89 04 24             	mov    %eax,(%esp)
80105cef:	e8 80 c0 ff ff       	call   80101d74 <readi>
80105cf4:	83 f8 10             	cmp    $0x10,%eax
80105cf7:	74 0c                	je     80105d05 <isdirempty+0x41>
      panic("isdirempty: readi");
80105cf9:	c7 04 24 8c 8c 10 80 	movl   $0x80108c8c,(%esp)
80105d00:	e8 35 a8 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105d05:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105d09:	66 85 c0             	test   %ax,%ax
80105d0c:	74 07                	je     80105d15 <isdirempty+0x51>
      return 0;
80105d0e:	b8 00 00 00 00       	mov    $0x0,%eax
80105d13:	eb 1b                	jmp    80105d30 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d18:	83 c0 10             	add    $0x10,%eax
80105d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d21:	8b 45 08             	mov    0x8(%ebp),%eax
80105d24:	8b 40 18             	mov    0x18(%eax),%eax
80105d27:	39 c2                	cmp    %eax,%edx
80105d29:	72 a8                	jb     80105cd3 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105d2b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d30:	c9                   	leave  
80105d31:	c3                   	ret    

80105d32 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105d32:	55                   	push   %ebp
80105d33:	89 e5                	mov    %esp,%ebp
80105d35:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105d38:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d3f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d46:	e8 74 fa ff ff       	call   801057bf <argstr>
80105d4b:	85 c0                	test   %eax,%eax
80105d4d:	79 0a                	jns    80105d59 <sys_unlink+0x27>
    return -1;
80105d4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d54:	e9 aa 01 00 00       	jmp    80105f03 <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105d59:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105d5c:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105d5f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d63:	89 04 24             	mov    %eax,(%esp)
80105d66:	e8 da c6 ff ff       	call   80102445 <nameiparent>
80105d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d72:	75 0a                	jne    80105d7e <sys_unlink+0x4c>
    return -1;
80105d74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d79:	e9 85 01 00 00       	jmp    80105f03 <sys_unlink+0x1d1>

  begin_trans();
80105d7e:	e8 8f d4 ff ff       	call   80103212 <begin_trans>

  ilock(dp);
80105d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d86:	89 04 24             	mov    %eax,(%esp)
80105d89:	e8 ed ba ff ff       	call   8010187b <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105d8e:	c7 44 24 04 9e 8c 10 	movl   $0x80108c9e,0x4(%esp)
80105d95:	80 
80105d96:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d99:	89 04 24             	mov    %eax,(%esp)
80105d9c:	e8 d7 c2 ff ff       	call   80102078 <namecmp>
80105da1:	85 c0                	test   %eax,%eax
80105da3:	0f 84 45 01 00 00    	je     80105eee <sys_unlink+0x1bc>
80105da9:	c7 44 24 04 a0 8c 10 	movl   $0x80108ca0,0x4(%esp)
80105db0:	80 
80105db1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105db4:	89 04 24             	mov    %eax,(%esp)
80105db7:	e8 bc c2 ff ff       	call   80102078 <namecmp>
80105dbc:	85 c0                	test   %eax,%eax
80105dbe:	0f 84 2a 01 00 00    	je     80105eee <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105dc4:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105dc7:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dcb:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105dce:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd5:	89 04 24             	mov    %eax,(%esp)
80105dd8:	e8 bd c2 ff ff       	call   8010209a <dirlookup>
80105ddd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105de0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105de4:	0f 84 03 01 00 00    	je     80105eed <sys_unlink+0x1bb>
    goto bad;
  ilock(ip);
80105dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ded:	89 04 24             	mov    %eax,(%esp)
80105df0:	e8 86 ba ff ff       	call   8010187b <ilock>

  if(ip->nlink < 1)
80105df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105dfc:	66 85 c0             	test   %ax,%ax
80105dff:	7f 0c                	jg     80105e0d <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
80105e01:	c7 04 24 a3 8c 10 80 	movl   $0x80108ca3,(%esp)
80105e08:	e8 2d a7 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e10:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e14:	66 83 f8 01          	cmp    $0x1,%ax
80105e18:	75 1f                	jne    80105e39 <sys_unlink+0x107>
80105e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e1d:	89 04 24             	mov    %eax,(%esp)
80105e20:	e8 9f fe ff ff       	call   80105cc4 <isdirempty>
80105e25:	85 c0                	test   %eax,%eax
80105e27:	75 10                	jne    80105e39 <sys_unlink+0x107>
    iunlockput(ip);
80105e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e2c:	89 04 24             	mov    %eax,(%esp)
80105e2f:	e8 ce bc ff ff       	call   80101b02 <iunlockput>
    goto bad;
80105e34:	e9 b5 00 00 00       	jmp    80105eee <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80105e39:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105e40:	00 
80105e41:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e48:	00 
80105e49:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e4c:	89 04 24             	mov    %eax,(%esp)
80105e4f:	e8 7e f5 ff ff       	call   801053d2 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e54:	8b 55 c8             	mov    -0x38(%ebp),%edx
80105e57:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e5a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105e61:	00 
80105e62:	89 54 24 08          	mov    %edx,0x8(%esp)
80105e66:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e6d:	89 04 24             	mov    %eax,(%esp)
80105e70:	e8 6b c0 ff ff       	call   80101ee0 <writei>
80105e75:	83 f8 10             	cmp    $0x10,%eax
80105e78:	74 0c                	je     80105e86 <sys_unlink+0x154>
    panic("unlink: writei");
80105e7a:	c7 04 24 b5 8c 10 80 	movl   $0x80108cb5,(%esp)
80105e81:	e8 b4 a6 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e89:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e8d:	66 83 f8 01          	cmp    $0x1,%ax
80105e91:	75 1c                	jne    80105eaf <sys_unlink+0x17d>
    dp->nlink--;
80105e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e96:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e9a:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea0:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea7:	89 04 24             	mov    %eax,(%esp)
80105eaa:	e8 0c b8 ff ff       	call   801016bb <iupdate>
  }
  iunlockput(dp);
80105eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb2:	89 04 24             	mov    %eax,(%esp)
80105eb5:	e8 48 bc ff ff       	call   80101b02 <iunlockput>

  ip->nlink--;
80105eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ebd:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec7:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ece:	89 04 24             	mov    %eax,(%esp)
80105ed1:	e8 e5 b7 ff ff       	call   801016bb <iupdate>
  iunlockput(ip);
80105ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed9:	89 04 24             	mov    %eax,(%esp)
80105edc:	e8 21 bc ff ff       	call   80101b02 <iunlockput>

  commit_trans();
80105ee1:	e8 75 d3 ff ff       	call   8010325b <commit_trans>

  return 0;
80105ee6:	b8 00 00 00 00       	mov    $0x0,%eax
80105eeb:	eb 16                	jmp    80105f03 <sys_unlink+0x1d1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105eed:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
80105eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef1:	89 04 24             	mov    %eax,(%esp)
80105ef4:	e8 09 bc ff ff       	call   80101b02 <iunlockput>
  commit_trans();
80105ef9:	e8 5d d3 ff ff       	call   8010325b <commit_trans>
  return -1;
80105efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f03:	c9                   	leave  
80105f04:	c3                   	ret    

80105f05 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105f05:	55                   	push   %ebp
80105f06:	89 e5                	mov    %esp,%ebp
80105f08:	83 ec 48             	sub    $0x48,%esp
80105f0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105f0e:	8b 55 10             	mov    0x10(%ebp),%edx
80105f11:	8b 45 14             	mov    0x14(%ebp),%eax
80105f14:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105f18:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105f1c:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105f20:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f23:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f27:	8b 45 08             	mov    0x8(%ebp),%eax
80105f2a:	89 04 24             	mov    %eax,(%esp)
80105f2d:	e8 13 c5 ff ff       	call   80102445 <nameiparent>
80105f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f39:	75 0a                	jne    80105f45 <create+0x40>
    return 0;
80105f3b:	b8 00 00 00 00       	mov    $0x0,%eax
80105f40:	e9 7e 01 00 00       	jmp    801060c3 <create+0x1be>
  ilock(dp);
80105f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f48:	89 04 24             	mov    %eax,(%esp)
80105f4b:	e8 2b b9 ff ff       	call   8010187b <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105f50:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f53:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f57:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f61:	89 04 24             	mov    %eax,(%esp)
80105f64:	e8 31 c1 ff ff       	call   8010209a <dirlookup>
80105f69:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f70:	74 47                	je     80105fb9 <create+0xb4>
    iunlockput(dp);
80105f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f75:	89 04 24             	mov    %eax,(%esp)
80105f78:	e8 85 bb ff ff       	call   80101b02 <iunlockput>
    ilock(ip);
80105f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f80:	89 04 24             	mov    %eax,(%esp)
80105f83:	e8 f3 b8 ff ff       	call   8010187b <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105f88:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105f8d:	75 15                	jne    80105fa4 <create+0x9f>
80105f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f92:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f96:	66 83 f8 02          	cmp    $0x2,%ax
80105f9a:	75 08                	jne    80105fa4 <create+0x9f>
      return ip;
80105f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f9f:	e9 1f 01 00 00       	jmp    801060c3 <create+0x1be>
    iunlockput(ip);
80105fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa7:	89 04 24             	mov    %eax,(%esp)
80105faa:	e8 53 bb ff ff       	call   80101b02 <iunlockput>
    return 0;
80105faf:	b8 00 00 00 00       	mov    $0x0,%eax
80105fb4:	e9 0a 01 00 00       	jmp    801060c3 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105fb9:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc0:	8b 00                	mov    (%eax),%eax
80105fc2:	89 54 24 04          	mov    %edx,0x4(%esp)
80105fc6:	89 04 24             	mov    %eax,(%esp)
80105fc9:	e8 10 b6 ff ff       	call   801015de <ialloc>
80105fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fd5:	75 0c                	jne    80105fe3 <create+0xde>
    panic("create: ialloc");
80105fd7:	c7 04 24 c4 8c 10 80 	movl   $0x80108cc4,(%esp)
80105fde:	e8 57 a5 ff ff       	call   8010053a <panic>

  ilock(ip);
80105fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe6:	89 04 24             	mov    %eax,(%esp)
80105fe9:	e8 8d b8 ff ff       	call   8010187b <ilock>
  ip->major = major;
80105fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff1:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105ff5:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ffc:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106000:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106004:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106007:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010600d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106010:	89 04 24             	mov    %eax,(%esp)
80106013:	e8 a3 b6 ff ff       	call   801016bb <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80106018:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010601d:	75 6a                	jne    80106089 <create+0x184>
    dp->nlink++;  // for ".."
8010601f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106022:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106026:	8d 50 01             	lea    0x1(%eax),%edx
80106029:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010602c:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106030:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106033:	89 04 24             	mov    %eax,(%esp)
80106036:	e8 80 b6 ff ff       	call   801016bb <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010603b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603e:	8b 40 04             	mov    0x4(%eax),%eax
80106041:	89 44 24 08          	mov    %eax,0x8(%esp)
80106045:	c7 44 24 04 9e 8c 10 	movl   $0x80108c9e,0x4(%esp)
8010604c:	80 
8010604d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106050:	89 04 24             	mov    %eax,(%esp)
80106053:	e8 0a c1 ff ff       	call   80102162 <dirlink>
80106058:	85 c0                	test   %eax,%eax
8010605a:	78 21                	js     8010607d <create+0x178>
8010605c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010605f:	8b 40 04             	mov    0x4(%eax),%eax
80106062:	89 44 24 08          	mov    %eax,0x8(%esp)
80106066:	c7 44 24 04 a0 8c 10 	movl   $0x80108ca0,0x4(%esp)
8010606d:	80 
8010606e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106071:	89 04 24             	mov    %eax,(%esp)
80106074:	e8 e9 c0 ff ff       	call   80102162 <dirlink>
80106079:	85 c0                	test   %eax,%eax
8010607b:	79 0c                	jns    80106089 <create+0x184>
      panic("create dots");
8010607d:	c7 04 24 d3 8c 10 80 	movl   $0x80108cd3,(%esp)
80106084:	e8 b1 a4 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106089:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010608c:	8b 40 04             	mov    0x4(%eax),%eax
8010608f:	89 44 24 08          	mov    %eax,0x8(%esp)
80106093:	8d 45 de             	lea    -0x22(%ebp),%eax
80106096:	89 44 24 04          	mov    %eax,0x4(%esp)
8010609a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609d:	89 04 24             	mov    %eax,(%esp)
801060a0:	e8 bd c0 ff ff       	call   80102162 <dirlink>
801060a5:	85 c0                	test   %eax,%eax
801060a7:	79 0c                	jns    801060b5 <create+0x1b0>
    panic("create: dirlink");
801060a9:	c7 04 24 df 8c 10 80 	movl   $0x80108cdf,(%esp)
801060b0:	e8 85 a4 ff ff       	call   8010053a <panic>

  iunlockput(dp);
801060b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b8:	89 04 24             	mov    %eax,(%esp)
801060bb:	e8 42 ba ff ff       	call   80101b02 <iunlockput>

  return ip;
801060c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801060c3:	c9                   	leave  
801060c4:	c3                   	ret    

801060c5 <sys_open>:

int
sys_open(void)
{
801060c5:	55                   	push   %ebp
801060c6:	89 e5                	mov    %esp,%ebp
801060c8:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801060cb:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801060d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060d9:	e8 e1 f6 ff ff       	call   801057bf <argstr>
801060de:	85 c0                	test   %eax,%eax
801060e0:	78 17                	js     801060f9 <sys_open+0x34>
801060e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801060e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060f0:	e8 39 f6 ff ff       	call   8010572e <argint>
801060f5:	85 c0                	test   %eax,%eax
801060f7:	79 0a                	jns    80106103 <sys_open+0x3e>
    return -1;
801060f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060fe:	e9 46 01 00 00       	jmp    80106249 <sys_open+0x184>
  if(omode & O_CREATE){
80106103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106106:	25 00 02 00 00       	and    $0x200,%eax
8010610b:	85 c0                	test   %eax,%eax
8010610d:	74 40                	je     8010614f <sys_open+0x8a>
    begin_trans();
8010610f:	e8 fe d0 ff ff       	call   80103212 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80106114:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106117:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010611e:	00 
8010611f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106126:	00 
80106127:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010612e:	00 
8010612f:	89 04 24             	mov    %eax,(%esp)
80106132:	e8 ce fd ff ff       	call   80105f05 <create>
80106137:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
8010613a:	e8 1c d1 ff ff       	call   8010325b <commit_trans>
    if(ip == 0)
8010613f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106143:	75 5c                	jne    801061a1 <sys_open+0xdc>
      return -1;
80106145:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010614a:	e9 fa 00 00 00       	jmp    80106249 <sys_open+0x184>
  } else {
    if((ip = namei(path)) == 0)
8010614f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106152:	89 04 24             	mov    %eax,(%esp)
80106155:	e8 c9 c2 ff ff       	call   80102423 <namei>
8010615a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010615d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106161:	75 0a                	jne    8010616d <sys_open+0xa8>
      return -1;
80106163:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106168:	e9 dc 00 00 00       	jmp    80106249 <sys_open+0x184>
    ilock(ip);
8010616d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106170:	89 04 24             	mov    %eax,(%esp)
80106173:	e8 03 b7 ff ff       	call   8010187b <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010617b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010617f:	66 83 f8 01          	cmp    $0x1,%ax
80106183:	75 1c                	jne    801061a1 <sys_open+0xdc>
80106185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106188:	85 c0                	test   %eax,%eax
8010618a:	74 15                	je     801061a1 <sys_open+0xdc>
      iunlockput(ip);
8010618c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010618f:	89 04 24             	mov    %eax,(%esp)
80106192:	e8 6b b9 ff ff       	call   80101b02 <iunlockput>
      return -1;
80106197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010619c:	e9 a8 00 00 00       	jmp    80106249 <sys_open+0x184>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801061a1:	e8 7e ad ff ff       	call   80100f24 <filealloc>
801061a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061ad:	74 14                	je     801061c3 <sys_open+0xfe>
801061af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061b2:	89 04 24             	mov    %eax,(%esp)
801061b5:	e8 43 f7 ff ff       	call   801058fd <fdalloc>
801061ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
801061bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801061c1:	79 23                	jns    801061e6 <sys_open+0x121>
    if(f)
801061c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061c7:	74 0b                	je     801061d4 <sys_open+0x10f>
      fileclose(f);
801061c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061cc:	89 04 24             	mov    %eax,(%esp)
801061cf:	e8 f9 ad ff ff       	call   80100fcd <fileclose>
    iunlockput(ip);
801061d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d7:	89 04 24             	mov    %eax,(%esp)
801061da:	e8 23 b9 ff ff       	call   80101b02 <iunlockput>
    return -1;
801061df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061e4:	eb 63                	jmp    80106249 <sys_open+0x184>
  }
  iunlock(ip);
801061e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e9:	89 04 24             	mov    %eax,(%esp)
801061ec:	e8 db b7 ff ff       	call   801019cc <iunlock>

  f->type = FD_INODE;
801061f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061f4:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801061fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106200:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106203:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106206:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010620d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106210:	83 e0 01             	and    $0x1,%eax
80106213:	85 c0                	test   %eax,%eax
80106215:	0f 94 c2             	sete   %dl
80106218:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010621b:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010621e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106221:	83 e0 01             	and    $0x1,%eax
80106224:	84 c0                	test   %al,%al
80106226:	75 0a                	jne    80106232 <sys_open+0x16d>
80106228:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010622b:	83 e0 02             	and    $0x2,%eax
8010622e:	85 c0                	test   %eax,%eax
80106230:	74 07                	je     80106239 <sys_open+0x174>
80106232:	b8 01 00 00 00       	mov    $0x1,%eax
80106237:	eb 05                	jmp    8010623e <sys_open+0x179>
80106239:	b8 00 00 00 00       	mov    $0x0,%eax
8010623e:	89 c2                	mov    %eax,%edx
80106240:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106243:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106246:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106249:	c9                   	leave  
8010624a:	c3                   	ret    

8010624b <sys_mkdir>:

int
sys_mkdir(void)
{
8010624b:	55                   	push   %ebp
8010624c:	89 e5                	mov    %esp,%ebp
8010624e:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80106251:	e8 bc cf ff ff       	call   80103212 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106256:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106259:	89 44 24 04          	mov    %eax,0x4(%esp)
8010625d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106264:	e8 56 f5 ff ff       	call   801057bf <argstr>
80106269:	85 c0                	test   %eax,%eax
8010626b:	78 2c                	js     80106299 <sys_mkdir+0x4e>
8010626d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106270:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106277:	00 
80106278:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010627f:	00 
80106280:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106287:	00 
80106288:	89 04 24             	mov    %eax,(%esp)
8010628b:	e8 75 fc ff ff       	call   80105f05 <create>
80106290:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106293:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106297:	75 0c                	jne    801062a5 <sys_mkdir+0x5a>
    commit_trans();
80106299:	e8 bd cf ff ff       	call   8010325b <commit_trans>
    return -1;
8010629e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a3:	eb 15                	jmp    801062ba <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801062a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062a8:	89 04 24             	mov    %eax,(%esp)
801062ab:	e8 52 b8 ff ff       	call   80101b02 <iunlockput>
  commit_trans();
801062b0:	e8 a6 cf ff ff       	call   8010325b <commit_trans>
  return 0;
801062b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062ba:	c9                   	leave  
801062bb:	c3                   	ret    

801062bc <sys_mknod>:

int
sys_mknod(void)
{
801062bc:	55                   	push   %ebp
801062bd:	89 e5                	mov    %esp,%ebp
801062bf:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
801062c2:	e8 4b cf ff ff       	call   80103212 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
801062c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801062ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062d5:	e8 e5 f4 ff ff       	call   801057bf <argstr>
801062da:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062e1:	78 5e                	js     80106341 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
801062e3:	8d 45 e8             	lea    -0x18(%ebp),%eax
801062e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801062ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801062f1:	e8 38 f4 ff ff       	call   8010572e <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
801062f6:	85 c0                	test   %eax,%eax
801062f8:	78 47                	js     80106341 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801062fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80106301:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106308:	e8 21 f4 ff ff       	call   8010572e <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
8010630d:	85 c0                	test   %eax,%eax
8010630f:	78 30                	js     80106341 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106311:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106314:	0f bf c8             	movswl %ax,%ecx
80106317:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010631a:	0f bf d0             	movswl %ax,%edx
8010631d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106320:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106324:	89 54 24 08          	mov    %edx,0x8(%esp)
80106328:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010632f:	00 
80106330:	89 04 24             	mov    %eax,(%esp)
80106333:	e8 cd fb ff ff       	call   80105f05 <create>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80106338:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010633b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010633f:	75 0c                	jne    8010634d <sys_mknod+0x91>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80106341:	e8 15 cf ff ff       	call   8010325b <commit_trans>
    return -1;
80106346:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010634b:	eb 15                	jmp    80106362 <sys_mknod+0xa6>
  }
  iunlockput(ip);
8010634d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106350:	89 04 24             	mov    %eax,(%esp)
80106353:	e8 aa b7 ff ff       	call   80101b02 <iunlockput>
  commit_trans();
80106358:	e8 fe ce ff ff       	call   8010325b <commit_trans>
  return 0;
8010635d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106362:	c9                   	leave  
80106363:	c3                   	ret    

80106364 <sys_chdir>:

int
sys_chdir(void)
{
80106364:	55                   	push   %ebp
80106365:	89 e5                	mov    %esp,%ebp
80106367:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
8010636a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010636d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106371:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106378:	e8 42 f4 ff ff       	call   801057bf <argstr>
8010637d:	85 c0                	test   %eax,%eax
8010637f:	78 14                	js     80106395 <sys_chdir+0x31>
80106381:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106384:	89 04 24             	mov    %eax,(%esp)
80106387:	e8 97 c0 ff ff       	call   80102423 <namei>
8010638c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010638f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106393:	75 07                	jne    8010639c <sys_chdir+0x38>
    return -1;
80106395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010639a:	eb 57                	jmp    801063f3 <sys_chdir+0x8f>
  ilock(ip);
8010639c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639f:	89 04 24             	mov    %eax,(%esp)
801063a2:	e8 d4 b4 ff ff       	call   8010187b <ilock>
  if(ip->type != T_DIR){
801063a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063aa:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801063ae:	66 83 f8 01          	cmp    $0x1,%ax
801063b2:	74 12                	je     801063c6 <sys_chdir+0x62>
    iunlockput(ip);
801063b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b7:	89 04 24             	mov    %eax,(%esp)
801063ba:	e8 43 b7 ff ff       	call   80101b02 <iunlockput>
    return -1;
801063bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063c4:	eb 2d                	jmp    801063f3 <sys_chdir+0x8f>
  }
  iunlock(ip);
801063c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c9:	89 04 24             	mov    %eax,(%esp)
801063cc:	e8 fb b5 ff ff       	call   801019cc <iunlock>
  iput(proc->cwd);
801063d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063d7:	8b 40 68             	mov    0x68(%eax),%eax
801063da:	89 04 24             	mov    %eax,(%esp)
801063dd:	e8 4f b6 ff ff       	call   80101a31 <iput>
  proc->cwd = ip;
801063e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063eb:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801063ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063f3:	c9                   	leave  
801063f4:	c3                   	ret    

801063f5 <sys_exec>:

int
sys_exec(void)
{
801063f5:	55                   	push   %ebp
801063f6:	89 e5                	mov    %esp,%ebp
801063f8:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801063fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106401:	89 44 24 04          	mov    %eax,0x4(%esp)
80106405:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010640c:	e8 ae f3 ff ff       	call   801057bf <argstr>
80106411:	85 c0                	test   %eax,%eax
80106413:	78 1a                	js     8010642f <sys_exec+0x3a>
80106415:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010641b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010641f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106426:	e8 03 f3 ff ff       	call   8010572e <argint>
8010642b:	85 c0                	test   %eax,%eax
8010642d:	79 0a                	jns    80106439 <sys_exec+0x44>
    return -1;
8010642f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106434:	e9 cd 00 00 00       	jmp    80106506 <sys_exec+0x111>
  }
  memset(argv, 0, sizeof(argv));
80106439:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106440:	00 
80106441:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106448:	00 
80106449:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010644f:	89 04 24             	mov    %eax,(%esp)
80106452:	e8 7b ef ff ff       	call   801053d2 <memset>
  for(i=0;; i++){
80106457:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010645e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106461:	83 f8 1f             	cmp    $0x1f,%eax
80106464:	76 0a                	jbe    80106470 <sys_exec+0x7b>
      return -1;
80106466:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010646b:	e9 96 00 00 00       	jmp    80106506 <sys_exec+0x111>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106470:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106476:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106479:	c1 e2 02             	shl    $0x2,%edx
8010647c:	89 d1                	mov    %edx,%ecx
8010647e:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
80106484:	8d 14 11             	lea    (%ecx,%edx,1),%edx
80106487:	89 44 24 04          	mov    %eax,0x4(%esp)
8010648b:	89 14 24             	mov    %edx,(%esp)
8010648e:	e8 fd f1 ff ff       	call   80105690 <fetchint>
80106493:	85 c0                	test   %eax,%eax
80106495:	79 07                	jns    8010649e <sys_exec+0xa9>
      return -1;
80106497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649c:	eb 68                	jmp    80106506 <sys_exec+0x111>
    if(uarg == 0){
8010649e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801064a4:	85 c0                	test   %eax,%eax
801064a6:	75 26                	jne    801064ce <sys_exec+0xd9>
      argv[i] = 0;
801064a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ab:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801064b2:	00 00 00 00 
      break;
801064b6:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801064b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ba:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801064c0:	89 54 24 04          	mov    %edx,0x4(%esp)
801064c4:	89 04 24             	mov    %eax,(%esp)
801064c7:	e8 2c a6 ff ff       	call   80100af8 <exec>
801064cc:	eb 38                	jmp    80106506 <sys_exec+0x111>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801064ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801064d8:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801064de:	01 d0                	add    %edx,%eax
801064e0:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
801064e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801064ea:	89 14 24             	mov    %edx,(%esp)
801064ed:	e8 d8 f1 ff ff       	call   801056ca <fetchstr>
801064f2:	85 c0                	test   %eax,%eax
801064f4:	79 07                	jns    801064fd <sys_exec+0x108>
      return -1;
801064f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064fb:	eb 09                	jmp    80106506 <sys_exec+0x111>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801064fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106501:	e9 58 ff ff ff       	jmp    8010645e <sys_exec+0x69>
  return exec(path, argv);
}
80106506:	c9                   	leave  
80106507:	c3                   	ret    

80106508 <sys_pipe>:

int
sys_pipe(void)
{
80106508:	55                   	push   %ebp
80106509:	89 e5                	mov    %esp,%ebp
8010650b:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010650e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106511:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106518:	00 
80106519:	89 44 24 04          	mov    %eax,0x4(%esp)
8010651d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106524:	e8 34 f2 ff ff       	call   8010575d <argptr>
80106529:	85 c0                	test   %eax,%eax
8010652b:	79 0a                	jns    80106537 <sys_pipe+0x2f>
    return -1;
8010652d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106532:	e9 9b 00 00 00       	jmp    801065d2 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106537:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010653a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010653e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106541:	89 04 24             	mov    %eax,(%esp)
80106544:	e8 bb d6 ff ff       	call   80103c04 <pipealloc>
80106549:	85 c0                	test   %eax,%eax
8010654b:	79 07                	jns    80106554 <sys_pipe+0x4c>
    return -1;
8010654d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106552:	eb 7e                	jmp    801065d2 <sys_pipe+0xca>
  fd0 = -1;
80106554:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010655b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010655e:	89 04 24             	mov    %eax,(%esp)
80106561:	e8 97 f3 ff ff       	call   801058fd <fdalloc>
80106566:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106569:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010656d:	78 14                	js     80106583 <sys_pipe+0x7b>
8010656f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106572:	89 04 24             	mov    %eax,(%esp)
80106575:	e8 83 f3 ff ff       	call   801058fd <fdalloc>
8010657a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010657d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106581:	79 37                	jns    801065ba <sys_pipe+0xb2>
    if(fd0 >= 0)
80106583:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106587:	78 14                	js     8010659d <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106589:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010658f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106592:	83 c2 08             	add    $0x8,%edx
80106595:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010659c:	00 
    fileclose(rf);
8010659d:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065a0:	89 04 24             	mov    %eax,(%esp)
801065a3:	e8 25 aa ff ff       	call   80100fcd <fileclose>
    fileclose(wf);
801065a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065ab:	89 04 24             	mov    %eax,(%esp)
801065ae:	e8 1a aa ff ff       	call   80100fcd <fileclose>
    return -1;
801065b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065b8:	eb 18                	jmp    801065d2 <sys_pipe+0xca>
  }
  fd[0] = fd0;
801065ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801065bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801065c0:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801065c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801065c5:	8d 50 04             	lea    0x4(%eax),%edx
801065c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065cb:	89 02                	mov    %eax,(%edx)
  return 0;
801065cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065d2:	c9                   	leave  
801065d3:	c3                   	ret    

801065d4 <sys_thread_yield>:

void sys_thread_yield(void){
801065d4:	55                   	push   %ebp
801065d5:	89 e5                	mov    %esp,%ebp
801065d7:	83 ec 08             	sub    $0x8,%esp
  thread_yield();
801065da:	e8 39 e6 ff ff       	call   80104c18 <thread_yield>
}
801065df:	c9                   	leave  
801065e0:	c3                   	ret    
801065e1:	00 00                	add    %al,(%eax)
	...

801065e4 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801065e4:	55                   	push   %ebp
801065e5:	89 e5                	mov    %esp,%ebp
801065e7:	83 ec 08             	sub    $0x8,%esp
  return fork();
801065ea:	e8 62 dd ff ff       	call   80104351 <fork>
}
801065ef:	c9                   	leave  
801065f0:	c3                   	ret    

801065f1 <sys_clone>:

int
sys_clone(){
801065f1:	55                   	push   %ebp
801065f2:	89 e5                	mov    %esp,%ebp
801065f4:	53                   	push   %ebx
801065f5:	83 ec 24             	sub    $0x24,%esp
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
801065f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801065ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106606:	e8 23 f1 ff ff       	call   8010572e <argint>
8010660b:	85 c0                	test   %eax,%eax
8010660d:	78 4c                	js     8010665b <sys_clone+0x6a>
8010660f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106612:	85 c0                	test   %eax,%eax
80106614:	7e 45                	jle    8010665b <sys_clone+0x6a>
80106616:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106619:	89 44 24 04          	mov    %eax,0x4(%esp)
8010661d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106624:	e8 05 f1 ff ff       	call   8010572e <argint>
80106629:	85 c0                	test   %eax,%eax
8010662b:	78 2e                	js     8010665b <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
8010662d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106630:	89 44 24 04          	mov    %eax,0x4(%esp)
80106634:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010663b:	e8 ee f0 ff ff       	call   8010572e <argint>
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
80106640:	85 c0                	test   %eax,%eax
80106642:	78 17                	js     8010665b <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
80106644:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106647:	89 44 24 04          	mov    %eax,0x4(%esp)
8010664b:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
80106652:	e8 d7 f0 ff ff       	call   8010572e <argint>
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
80106657:	85 c0                	test   %eax,%eax
80106659:	79 07                	jns    80106662 <sys_clone+0x71>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
        return -1;
8010665b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106660:	eb 20                	jmp    80106682 <sys_clone+0x91>
    }
    return clone(stack,size,routine,arg);
80106662:	8b 5d e8             	mov    -0x18(%ebp),%ebx
80106665:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106668:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010666b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010666e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106672:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106676:	89 54 24 04          	mov    %edx,0x4(%esp)
8010667a:	89 04 24             	mov    %eax,(%esp)
8010667d:	e8 3f de ff ff       	call   801044c1 <clone>
}
80106682:	83 c4 24             	add    $0x24,%esp
80106685:	5b                   	pop    %ebx
80106686:	5d                   	pop    %ebp
80106687:	c3                   	ret    

80106688 <sys_exit>:

int
sys_exit(void)
{
80106688:	55                   	push   %ebp
80106689:	89 e5                	mov    %esp,%ebp
8010668b:	83 ec 08             	sub    $0x8,%esp
  exit();
8010668e:	e8 51 e0 ff ff       	call   801046e4 <exit>
  return 0;  // not reached
80106693:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106698:	c9                   	leave  
80106699:	c3                   	ret    

8010669a <sys_texit>:

int
sys_texit(void)
{
8010669a:	55                   	push   %ebp
8010669b:	89 e5                	mov    %esp,%ebp
8010669d:	83 ec 08             	sub    $0x8,%esp
    texit();
801066a0:	e8 5b e1 ff ff       	call   80104800 <texit>
    return 0;
801066a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066aa:	c9                   	leave  
801066ab:	c3                   	ret    

801066ac <sys_wait>:

int
sys_wait(void)
{
801066ac:	55                   	push   %ebp
801066ad:	89 e5                	mov    %esp,%ebp
801066af:	83 ec 08             	sub    $0x8,%esp
  return wait();
801066b2:	e8 96 e2 ff ff       	call   8010494d <wait>
}
801066b7:	c9                   	leave  
801066b8:	c3                   	ret    

801066b9 <sys_kill>:

int
sys_kill(void)
{
801066b9:	55                   	push   %ebp
801066ba:	89 e5                	mov    %esp,%ebp
801066bc:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801066bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801066c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066cd:	e8 5c f0 ff ff       	call   8010572e <argint>
801066d2:	85 c0                	test   %eax,%eax
801066d4:	79 07                	jns    801066dd <sys_kill+0x24>
    return -1;
801066d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066db:	eb 0b                	jmp    801066e8 <sys_kill+0x2f>
  return kill(pid);
801066dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e0:	89 04 24             	mov    %eax,(%esp)
801066e3:	e8 94 e8 ff ff       	call   80104f7c <kill>
}
801066e8:	c9                   	leave  
801066e9:	c3                   	ret    

801066ea <sys_getpid>:

int
sys_getpid(void)
{
801066ea:	55                   	push   %ebp
801066eb:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801066ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066f3:	8b 40 10             	mov    0x10(%eax),%eax
}
801066f6:	5d                   	pop    %ebp
801066f7:	c3                   	ret    

801066f8 <sys_sbrk>:

int
sys_sbrk(void)
{
801066f8:	55                   	push   %ebp
801066f9:	89 e5                	mov    %esp,%ebp
801066fb:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801066fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106701:	89 44 24 04          	mov    %eax,0x4(%esp)
80106705:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010670c:	e8 1d f0 ff ff       	call   8010572e <argint>
80106711:	85 c0                	test   %eax,%eax
80106713:	79 07                	jns    8010671c <sys_sbrk+0x24>
    return -1;
80106715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671a:	eb 24                	jmp    80106740 <sys_sbrk+0x48>
  addr = proc->sz;
8010671c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106722:	8b 00                	mov    (%eax),%eax
80106724:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106727:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010672a:	89 04 24             	mov    %eax,(%esp)
8010672d:	e8 7a db ff ff       	call   801042ac <growproc>
80106732:	85 c0                	test   %eax,%eax
80106734:	79 07                	jns    8010673d <sys_sbrk+0x45>
    return -1;
80106736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010673b:	eb 03                	jmp    80106740 <sys_sbrk+0x48>
  return addr;
8010673d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106740:	c9                   	leave  
80106741:	c3                   	ret    

80106742 <sys_sleep>:

int
sys_sleep(void)
{
80106742:	55                   	push   %ebp
80106743:	89 e5                	mov    %esp,%ebp
80106745:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106748:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010674b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010674f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106756:	e8 d3 ef ff ff       	call   8010572e <argint>
8010675b:	85 c0                	test   %eax,%eax
8010675d:	79 07                	jns    80106766 <sys_sleep+0x24>
    return -1;
8010675f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106764:	eb 6c                	jmp    801067d2 <sys_sleep+0x90>
  acquire(&tickslock);
80106766:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
8010676d:	e8 11 ea ff ff       	call   80105183 <acquire>
  ticks0 = ticks;
80106772:	a1 00 2a 11 80       	mov    0x80112a00,%eax
80106777:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010677a:	eb 34                	jmp    801067b0 <sys_sleep+0x6e>
    if(proc->killed){
8010677c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106782:	8b 40 24             	mov    0x24(%eax),%eax
80106785:	85 c0                	test   %eax,%eax
80106787:	74 13                	je     8010679c <sys_sleep+0x5a>
      release(&tickslock);
80106789:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
80106790:	e8 4f ea ff ff       	call   801051e4 <release>
      return -1;
80106795:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010679a:	eb 36                	jmp    801067d2 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
8010679c:	c7 44 24 04 c0 21 11 	movl   $0x801121c0,0x4(%esp)
801067a3:	80 
801067a4:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
801067ab:	e8 5b e6 ff ff       	call   80104e0b <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801067b0:	a1 00 2a 11 80       	mov    0x80112a00,%eax
801067b5:	89 c2                	mov    %eax,%edx
801067b7:	2b 55 f4             	sub    -0xc(%ebp),%edx
801067ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067bd:	39 c2                	cmp    %eax,%edx
801067bf:	72 bb                	jb     8010677c <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801067c1:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
801067c8:	e8 17 ea ff ff       	call   801051e4 <release>
  return 0;
801067cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067d2:	c9                   	leave  
801067d3:	c3                   	ret    

801067d4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801067d4:	55                   	push   %ebp
801067d5:	89 e5                	mov    %esp,%ebp
801067d7:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
801067da:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
801067e1:	e8 9d e9 ff ff       	call   80105183 <acquire>
  xticks = ticks;
801067e6:	a1 00 2a 11 80       	mov    0x80112a00,%eax
801067eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801067ee:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
801067f5:	e8 ea e9 ff ff       	call   801051e4 <release>
  return xticks;
801067fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801067fd:	c9                   	leave  
801067fe:	c3                   	ret    

801067ff <sys_tsleep>:

int
sys_tsleep(void)
{
801067ff:	55                   	push   %ebp
80106800:	89 e5                	mov    %esp,%ebp
80106802:	83 ec 08             	sub    $0x8,%esp
    tsleep();
80106805:	e8 eb e8 ff ff       	call   801050f5 <tsleep>
    return 0;
8010680a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010680f:	c9                   	leave  
80106810:	c3                   	ret    

80106811 <sys_twakeup>:

int 
sys_twakeup(void)
{
80106811:	55                   	push   %ebp
80106812:	89 e5                	mov    %esp,%ebp
80106814:	83 ec 28             	sub    $0x28,%esp
    int tid;
    if(argint(0,&tid) < 0){
80106817:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010681a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010681e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106825:	e8 04 ef ff ff       	call   8010572e <argint>
8010682a:	85 c0                	test   %eax,%eax
8010682c:	79 07                	jns    80106835 <sys_twakeup+0x24>
        return -1;
8010682e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106833:	eb 10                	jmp    80106845 <sys_twakeup+0x34>
    }
        twakeup(tid);
80106835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106838:	89 04 24             	mov    %eax,(%esp)
8010683b:	e8 a8 e6 ff ff       	call   80104ee8 <twakeup>
        return 0;
80106840:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106845:	c9                   	leave  
80106846:	c3                   	ret    
	...

80106848 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106848:	55                   	push   %ebp
80106849:	89 e5                	mov    %esp,%ebp
8010684b:	83 ec 08             	sub    $0x8,%esp
8010684e:	8b 55 08             	mov    0x8(%ebp),%edx
80106851:	8b 45 0c             	mov    0xc(%ebp),%eax
80106854:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106858:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010685b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010685f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106863:	ee                   	out    %al,(%dx)
}
80106864:	c9                   	leave  
80106865:	c3                   	ret    

80106866 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106866:	55                   	push   %ebp
80106867:	89 e5                	mov    %esp,%ebp
80106869:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010686c:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106873:	00 
80106874:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
8010687b:	e8 c8 ff ff ff       	call   80106848 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106880:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106887:	00 
80106888:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010688f:	e8 b4 ff ff ff       	call   80106848 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106894:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
8010689b:	00 
8010689c:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801068a3:	e8 a0 ff ff ff       	call   80106848 <outb>
  picenable(IRQ_TIMER);
801068a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068af:	e8 d9 d1 ff ff       	call   80103a8d <picenable>
}
801068b4:	c9                   	leave  
801068b5:	c3                   	ret    
	...

801068b8 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801068b8:	1e                   	push   %ds
  pushl %es
801068b9:	06                   	push   %es
  pushl %fs
801068ba:	0f a0                	push   %fs
  pushl %gs
801068bc:	0f a8                	push   %gs
  pushal
801068be:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801068bf:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801068c3:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801068c5:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801068c7:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801068cb:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801068cd:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801068cf:	54                   	push   %esp
  call trap
801068d0:	e8 d5 01 00 00       	call   80106aaa <trap>
  addl $4, %esp
801068d5:	83 c4 04             	add    $0x4,%esp

801068d8 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801068d8:	61                   	popa   
  popl %gs
801068d9:	0f a9                	pop    %gs
  popl %fs
801068db:	0f a1                	pop    %fs
  popl %es
801068dd:	07                   	pop    %es
  popl %ds
801068de:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801068df:	83 c4 08             	add    $0x8,%esp
  iret
801068e2:	cf                   	iret   
	...

801068e4 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801068e4:	55                   	push   %ebp
801068e5:	89 e5                	mov    %esp,%ebp
801068e7:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801068ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801068ed:	83 e8 01             	sub    $0x1,%eax
801068f0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801068f4:	8b 45 08             	mov    0x8(%ebp),%eax
801068f7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801068fb:	8b 45 08             	mov    0x8(%ebp),%eax
801068fe:	c1 e8 10             	shr    $0x10,%eax
80106901:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106905:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106908:	0f 01 18             	lidtl  (%eax)
}
8010690b:	c9                   	leave  
8010690c:	c3                   	ret    

8010690d <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010690d:	55                   	push   %ebp
8010690e:	89 e5                	mov    %esp,%ebp
80106910:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106913:	0f 20 d0             	mov    %cr2,%eax
80106916:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106919:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010691c:	c9                   	leave  
8010691d:	c3                   	ret    

8010691e <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010691e:	55                   	push   %ebp
8010691f:	89 e5                	mov    %esp,%ebp
80106921:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106924:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010692b:	e9 bf 00 00 00       	jmp    801069ef <tvinit+0xd1>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106933:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106936:	8b 14 95 ac b0 10 80 	mov    -0x7fef4f54(,%edx,4),%edx
8010693d:	66 89 14 c5 00 22 11 	mov    %dx,-0x7feede00(,%eax,8)
80106944:	80 
80106945:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106948:	66 c7 04 c5 02 22 11 	movw   $0x8,-0x7feeddfe(,%eax,8)
8010694f:	80 08 00 
80106952:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106955:	0f b6 14 c5 04 22 11 	movzbl -0x7feeddfc(,%eax,8),%edx
8010695c:	80 
8010695d:	83 e2 e0             	and    $0xffffffe0,%edx
80106960:	88 14 c5 04 22 11 80 	mov    %dl,-0x7feeddfc(,%eax,8)
80106967:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010696a:	0f b6 14 c5 04 22 11 	movzbl -0x7feeddfc(,%eax,8),%edx
80106971:	80 
80106972:	83 e2 1f             	and    $0x1f,%edx
80106975:	88 14 c5 04 22 11 80 	mov    %dl,-0x7feeddfc(,%eax,8)
8010697c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010697f:	0f b6 14 c5 05 22 11 	movzbl -0x7feeddfb(,%eax,8),%edx
80106986:	80 
80106987:	83 e2 f0             	and    $0xfffffff0,%edx
8010698a:	83 ca 0e             	or     $0xe,%edx
8010698d:	88 14 c5 05 22 11 80 	mov    %dl,-0x7feeddfb(,%eax,8)
80106994:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106997:	0f b6 14 c5 05 22 11 	movzbl -0x7feeddfb(,%eax,8),%edx
8010699e:	80 
8010699f:	83 e2 ef             	and    $0xffffffef,%edx
801069a2:	88 14 c5 05 22 11 80 	mov    %dl,-0x7feeddfb(,%eax,8)
801069a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069ac:	0f b6 14 c5 05 22 11 	movzbl -0x7feeddfb(,%eax,8),%edx
801069b3:	80 
801069b4:	83 e2 9f             	and    $0xffffff9f,%edx
801069b7:	88 14 c5 05 22 11 80 	mov    %dl,-0x7feeddfb(,%eax,8)
801069be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069c1:	0f b6 14 c5 05 22 11 	movzbl -0x7feeddfb(,%eax,8),%edx
801069c8:	80 
801069c9:	83 ca 80             	or     $0xffffff80,%edx
801069cc:	88 14 c5 05 22 11 80 	mov    %dl,-0x7feeddfb(,%eax,8)
801069d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069d9:	8b 14 95 ac b0 10 80 	mov    -0x7fef4f54(,%edx,4),%edx
801069e0:	c1 ea 10             	shr    $0x10,%edx
801069e3:	66 89 14 c5 06 22 11 	mov    %dx,-0x7feeddfa(,%eax,8)
801069ea:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801069eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801069ef:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801069f6:	0f 8e 34 ff ff ff    	jle    80106930 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801069fc:	a1 ac b1 10 80       	mov    0x8010b1ac,%eax
80106a01:	66 a3 00 24 11 80    	mov    %ax,0x80112400
80106a07:	66 c7 05 02 24 11 80 	movw   $0x8,0x80112402
80106a0e:	08 00 
80106a10:	0f b6 05 04 24 11 80 	movzbl 0x80112404,%eax
80106a17:	83 e0 e0             	and    $0xffffffe0,%eax
80106a1a:	a2 04 24 11 80       	mov    %al,0x80112404
80106a1f:	0f b6 05 04 24 11 80 	movzbl 0x80112404,%eax
80106a26:	83 e0 1f             	and    $0x1f,%eax
80106a29:	a2 04 24 11 80       	mov    %al,0x80112404
80106a2e:	0f b6 05 05 24 11 80 	movzbl 0x80112405,%eax
80106a35:	83 c8 0f             	or     $0xf,%eax
80106a38:	a2 05 24 11 80       	mov    %al,0x80112405
80106a3d:	0f b6 05 05 24 11 80 	movzbl 0x80112405,%eax
80106a44:	83 e0 ef             	and    $0xffffffef,%eax
80106a47:	a2 05 24 11 80       	mov    %al,0x80112405
80106a4c:	0f b6 05 05 24 11 80 	movzbl 0x80112405,%eax
80106a53:	83 c8 60             	or     $0x60,%eax
80106a56:	a2 05 24 11 80       	mov    %al,0x80112405
80106a5b:	0f b6 05 05 24 11 80 	movzbl 0x80112405,%eax
80106a62:	83 c8 80             	or     $0xffffff80,%eax
80106a65:	a2 05 24 11 80       	mov    %al,0x80112405
80106a6a:	a1 ac b1 10 80       	mov    0x8010b1ac,%eax
80106a6f:	c1 e8 10             	shr    $0x10,%eax
80106a72:	66 a3 06 24 11 80    	mov    %ax,0x80112406
  
  initlock(&tickslock, "time");
80106a78:	c7 44 24 04 f0 8c 10 	movl   $0x80108cf0,0x4(%esp)
80106a7f:	80 
80106a80:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
80106a87:	e8 d6 e6 ff ff       	call   80105162 <initlock>
}
80106a8c:	c9                   	leave  
80106a8d:	c3                   	ret    

80106a8e <idtinit>:

void
idtinit(void)
{
80106a8e:	55                   	push   %ebp
80106a8f:	89 e5                	mov    %esp,%ebp
80106a91:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106a94:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106a9b:	00 
80106a9c:	c7 04 24 00 22 11 80 	movl   $0x80112200,(%esp)
80106aa3:	e8 3c fe ff ff       	call   801068e4 <lidt>
}
80106aa8:	c9                   	leave  
80106aa9:	c3                   	ret    

80106aaa <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106aaa:	55                   	push   %ebp
80106aab:	89 e5                	mov    %esp,%ebp
80106aad:	57                   	push   %edi
80106aae:	56                   	push   %esi
80106aaf:	53                   	push   %ebx
80106ab0:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106ab3:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab6:	8b 40 30             	mov    0x30(%eax),%eax
80106ab9:	83 f8 40             	cmp    $0x40,%eax
80106abc:	75 3e                	jne    80106afc <trap+0x52>
    if(proc->killed)
80106abe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ac4:	8b 40 24             	mov    0x24(%eax),%eax
80106ac7:	85 c0                	test   %eax,%eax
80106ac9:	74 05                	je     80106ad0 <trap+0x26>
      exit();
80106acb:	e8 14 dc ff ff       	call   801046e4 <exit>
    proc->tf = tf;
80106ad0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ad6:	8b 55 08             	mov    0x8(%ebp),%edx
80106ad9:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106adc:	e8 15 ed ff ff       	call   801057f6 <syscall>
    if(proc->killed)
80106ae1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ae7:	8b 40 24             	mov    0x24(%eax),%eax
80106aea:	85 c0                	test   %eax,%eax
80106aec:	0f 84 34 02 00 00    	je     80106d26 <trap+0x27c>
      exit();
80106af2:	e8 ed db ff ff       	call   801046e4 <exit>
    return;
80106af7:	e9 2b 02 00 00       	jmp    80106d27 <trap+0x27d>
  }

  switch(tf->trapno){
80106afc:	8b 45 08             	mov    0x8(%ebp),%eax
80106aff:	8b 40 30             	mov    0x30(%eax),%eax
80106b02:	83 e8 20             	sub    $0x20,%eax
80106b05:	83 f8 1f             	cmp    $0x1f,%eax
80106b08:	0f 87 bc 00 00 00    	ja     80106bca <trap+0x120>
80106b0e:	8b 04 85 98 8d 10 80 	mov    -0x7fef7268(,%eax,4),%eax
80106b15:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106b17:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b1d:	0f b6 00             	movzbl (%eax),%eax
80106b20:	84 c0                	test   %al,%al
80106b22:	75 31                	jne    80106b55 <trap+0xab>
      acquire(&tickslock);
80106b24:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
80106b2b:	e8 53 e6 ff ff       	call   80105183 <acquire>
      ticks++;
80106b30:	a1 00 2a 11 80       	mov    0x80112a00,%eax
80106b35:	83 c0 01             	add    $0x1,%eax
80106b38:	a3 00 2a 11 80       	mov    %eax,0x80112a00
      wakeup(&ticks);
80106b3d:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80106b44:	e8 08 e4 ff ff       	call   80104f51 <wakeup>
      release(&tickslock);
80106b49:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
80106b50:	e8 8f e6 ff ff       	call   801051e4 <release>
    }
    lapiceoi();
80106b55:	e8 86 c3 ff ff       	call   80102ee0 <lapiceoi>
    break;
80106b5a:	e9 41 01 00 00       	jmp    80106ca0 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106b5f:	e8 97 bb ff ff       	call   801026fb <ideintr>
    lapiceoi();
80106b64:	e8 77 c3 ff ff       	call   80102ee0 <lapiceoi>
    break;
80106b69:	e9 32 01 00 00       	jmp    80106ca0 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106b6e:	e8 50 c1 ff ff       	call   80102cc3 <kbdintr>
    lapiceoi();
80106b73:	e8 68 c3 ff ff       	call   80102ee0 <lapiceoi>
    break;
80106b78:	e9 23 01 00 00       	jmp    80106ca0 <trap+0x1f6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106b7d:	e8 9d 03 00 00       	call   80106f1f <uartintr>
    lapiceoi();
80106b82:	e8 59 c3 ff ff       	call   80102ee0 <lapiceoi>
    break;
80106b87:	e9 14 01 00 00       	jmp    80106ca0 <trap+0x1f6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b8f:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106b92:	8b 45 08             	mov    0x8(%ebp),%eax
80106b95:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b99:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106b9c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ba2:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ba5:	0f b6 c0             	movzbl %al,%eax
80106ba8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106bac:	89 54 24 08          	mov    %edx,0x8(%esp)
80106bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bb4:	c7 04 24 f8 8c 10 80 	movl   $0x80108cf8,(%esp)
80106bbb:	e8 da 97 ff ff       	call   8010039a <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106bc0:	e8 1b c3 ff ff       	call   80102ee0 <lapiceoi>
    break;
80106bc5:	e9 d6 00 00 00       	jmp    80106ca0 <trap+0x1f6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106bca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bd0:	85 c0                	test   %eax,%eax
80106bd2:	74 11                	je     80106be5 <trap+0x13b>
80106bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80106bd7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106bdb:	0f b7 c0             	movzwl %ax,%eax
80106bde:	83 e0 03             	and    $0x3,%eax
80106be1:	85 c0                	test   %eax,%eax
80106be3:	75 46                	jne    80106c2b <trap+0x181>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106be5:	e8 23 fd ff ff       	call   8010690d <rcr2>
80106bea:	8b 55 08             	mov    0x8(%ebp),%edx
80106bed:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106bf0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106bf7:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106bfa:	0f b6 ca             	movzbl %dl,%ecx
80106bfd:	8b 55 08             	mov    0x8(%ebp),%edx
80106c00:	8b 52 30             	mov    0x30(%edx),%edx
80106c03:	89 44 24 10          	mov    %eax,0x10(%esp)
80106c07:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106c0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106c0f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106c13:	c7 04 24 1c 8d 10 80 	movl   $0x80108d1c,(%esp)
80106c1a:	e8 7b 97 ff ff       	call   8010039a <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106c1f:	c7 04 24 4e 8d 10 80 	movl   $0x80108d4e,(%esp)
80106c26:	e8 0f 99 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c2b:	e8 dd fc ff ff       	call   8010690d <rcr2>
80106c30:	89 c2                	mov    %eax,%edx
80106c32:	8b 45 08             	mov    0x8(%ebp),%eax
80106c35:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106c38:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c3e:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c41:	0f b6 f0             	movzbl %al,%esi
80106c44:	8b 45 08             	mov    0x8(%ebp),%eax
80106c47:	8b 58 34             	mov    0x34(%eax),%ebx
80106c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c4d:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106c50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c56:	83 c0 6c             	add    $0x6c,%eax
80106c59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106c5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c62:	8b 40 10             	mov    0x10(%eax),%eax
80106c65:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106c69:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106c6d:	89 74 24 14          	mov    %esi,0x14(%esp)
80106c71:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106c75:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106c79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c7c:	89 54 24 08          	mov    %edx,0x8(%esp)
80106c80:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c84:	c7 04 24 54 8d 10 80 	movl   $0x80108d54,(%esp)
80106c8b:	e8 0a 97 ff ff       	call   8010039a <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106c90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c96:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106c9d:	eb 01                	jmp    80106ca0 <trap+0x1f6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106c9f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106ca0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ca6:	85 c0                	test   %eax,%eax
80106ca8:	74 24                	je     80106cce <trap+0x224>
80106caa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cb0:	8b 40 24             	mov    0x24(%eax),%eax
80106cb3:	85 c0                	test   %eax,%eax
80106cb5:	74 17                	je     80106cce <trap+0x224>
80106cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80106cba:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106cbe:	0f b7 c0             	movzwl %ax,%eax
80106cc1:	83 e0 03             	and    $0x3,%eax
80106cc4:	83 f8 03             	cmp    $0x3,%eax
80106cc7:	75 05                	jne    80106cce <trap+0x224>
    exit();
80106cc9:	e8 16 da ff ff       	call   801046e4 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106cce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cd4:	85 c0                	test   %eax,%eax
80106cd6:	74 1e                	je     80106cf6 <trap+0x24c>
80106cd8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cde:	8b 40 0c             	mov    0xc(%eax),%eax
80106ce1:	83 f8 04             	cmp    $0x4,%eax
80106ce4:	75 10                	jne    80106cf6 <trap+0x24c>
80106ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce9:	8b 40 30             	mov    0x30(%eax),%eax
80106cec:	83 f8 20             	cmp    $0x20,%eax
80106cef:	75 05                	jne    80106cf6 <trap+0x24c>
    yield();
80106cf1:	e8 f0 de ff ff       	call   80104be6 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106cf6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cfc:	85 c0                	test   %eax,%eax
80106cfe:	74 27                	je     80106d27 <trap+0x27d>
80106d00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d06:	8b 40 24             	mov    0x24(%eax),%eax
80106d09:	85 c0                	test   %eax,%eax
80106d0b:	74 1a                	je     80106d27 <trap+0x27d>
80106d0d:	8b 45 08             	mov    0x8(%ebp),%eax
80106d10:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106d14:	0f b7 c0             	movzwl %ax,%eax
80106d17:	83 e0 03             	and    $0x3,%eax
80106d1a:	83 f8 03             	cmp    $0x3,%eax
80106d1d:	75 08                	jne    80106d27 <trap+0x27d>
    exit();
80106d1f:	e8 c0 d9 ff ff       	call   801046e4 <exit>
80106d24:	eb 01                	jmp    80106d27 <trap+0x27d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106d26:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106d27:	83 c4 3c             	add    $0x3c,%esp
80106d2a:	5b                   	pop    %ebx
80106d2b:	5e                   	pop    %esi
80106d2c:	5f                   	pop    %edi
80106d2d:	5d                   	pop    %ebp
80106d2e:	c3                   	ret    
	...

80106d30 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	83 ec 14             	sub    $0x14,%esp
80106d36:	8b 45 08             	mov    0x8(%ebp),%eax
80106d39:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d3d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106d41:	89 c2                	mov    %eax,%edx
80106d43:	ec                   	in     (%dx),%al
80106d44:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106d47:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106d4b:	c9                   	leave  
80106d4c:	c3                   	ret    

80106d4d <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106d4d:	55                   	push   %ebp
80106d4e:	89 e5                	mov    %esp,%ebp
80106d50:	83 ec 08             	sub    $0x8,%esp
80106d53:	8b 55 08             	mov    0x8(%ebp),%edx
80106d56:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d59:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106d5d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d60:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106d64:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106d68:	ee                   	out    %al,(%dx)
}
80106d69:	c9                   	leave  
80106d6a:	c3                   	ret    

80106d6b <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106d6b:	55                   	push   %ebp
80106d6c:	89 e5                	mov    %esp,%ebp
80106d6e:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106d71:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106d78:	00 
80106d79:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106d80:	e8 c8 ff ff ff       	call   80106d4d <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106d85:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106d8c:	00 
80106d8d:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106d94:	e8 b4 ff ff ff       	call   80106d4d <outb>
  outb(COM1+0, 115200/9600);
80106d99:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106da0:	00 
80106da1:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106da8:	e8 a0 ff ff ff       	call   80106d4d <outb>
  outb(COM1+1, 0);
80106dad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106db4:	00 
80106db5:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106dbc:	e8 8c ff ff ff       	call   80106d4d <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106dc1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106dc8:	00 
80106dc9:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106dd0:	e8 78 ff ff ff       	call   80106d4d <outb>
  outb(COM1+4, 0);
80106dd5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ddc:	00 
80106ddd:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106de4:	e8 64 ff ff ff       	call   80106d4d <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106de9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106df0:	00 
80106df1:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106df8:	e8 50 ff ff ff       	call   80106d4d <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106dfd:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106e04:	e8 27 ff ff ff       	call   80106d30 <inb>
80106e09:	3c ff                	cmp    $0xff,%al
80106e0b:	74 6c                	je     80106e79 <uartinit+0x10e>
    return;
  uart = 1;
80106e0d:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106e14:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106e17:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106e1e:	e8 0d ff ff ff       	call   80106d30 <inb>
  inb(COM1+0);
80106e23:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106e2a:	e8 01 ff ff ff       	call   80106d30 <inb>
  picenable(IRQ_COM1);
80106e2f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106e36:	e8 52 cc ff ff       	call   80103a8d <picenable>
  ioapicenable(IRQ_COM1, 0);
80106e3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e42:	00 
80106e43:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106e4a:	e8 2f bb ff ff       	call   8010297e <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106e4f:	c7 45 f4 18 8e 10 80 	movl   $0x80108e18,-0xc(%ebp)
80106e56:	eb 15                	jmp    80106e6d <uartinit+0x102>
    uartputc(*p);
80106e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e5b:	0f b6 00             	movzbl (%eax),%eax
80106e5e:	0f be c0             	movsbl %al,%eax
80106e61:	89 04 24             	mov    %eax,(%esp)
80106e64:	e8 13 00 00 00       	call   80106e7c <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106e69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e70:	0f b6 00             	movzbl (%eax),%eax
80106e73:	84 c0                	test   %al,%al
80106e75:	75 e1                	jne    80106e58 <uartinit+0xed>
80106e77:	eb 01                	jmp    80106e7a <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106e79:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106e7a:	c9                   	leave  
80106e7b:	c3                   	ret    

80106e7c <uartputc>:

void
uartputc(int c)
{
80106e7c:	55                   	push   %ebp
80106e7d:	89 e5                	mov    %esp,%ebp
80106e7f:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106e82:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106e87:	85 c0                	test   %eax,%eax
80106e89:	74 4d                	je     80106ed8 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106e8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106e92:	eb 10                	jmp    80106ea4 <uartputc+0x28>
    microdelay(10);
80106e94:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106e9b:	e8 65 c0 ff ff       	call   80102f05 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ea0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106ea4:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106ea8:	7f 16                	jg     80106ec0 <uartputc+0x44>
80106eaa:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106eb1:	e8 7a fe ff ff       	call   80106d30 <inb>
80106eb6:	0f b6 c0             	movzbl %al,%eax
80106eb9:	83 e0 20             	and    $0x20,%eax
80106ebc:	85 c0                	test   %eax,%eax
80106ebe:	74 d4                	je     80106e94 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ec3:	0f b6 c0             	movzbl %al,%eax
80106ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106eca:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106ed1:	e8 77 fe ff ff       	call   80106d4d <outb>
80106ed6:	eb 01                	jmp    80106ed9 <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106ed8:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106ed9:	c9                   	leave  
80106eda:	c3                   	ret    

80106edb <uartgetc>:

static int
uartgetc(void)
{
80106edb:	55                   	push   %ebp
80106edc:	89 e5                	mov    %esp,%ebp
80106ede:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106ee1:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106ee6:	85 c0                	test   %eax,%eax
80106ee8:	75 07                	jne    80106ef1 <uartgetc+0x16>
    return -1;
80106eea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106eef:	eb 2c                	jmp    80106f1d <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106ef1:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106ef8:	e8 33 fe ff ff       	call   80106d30 <inb>
80106efd:	0f b6 c0             	movzbl %al,%eax
80106f00:	83 e0 01             	and    $0x1,%eax
80106f03:	85 c0                	test   %eax,%eax
80106f05:	75 07                	jne    80106f0e <uartgetc+0x33>
    return -1;
80106f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f0c:	eb 0f                	jmp    80106f1d <uartgetc+0x42>
  return inb(COM1+0);
80106f0e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106f15:	e8 16 fe ff ff       	call   80106d30 <inb>
80106f1a:	0f b6 c0             	movzbl %al,%eax
}
80106f1d:	c9                   	leave  
80106f1e:	c3                   	ret    

80106f1f <uartintr>:

void
uartintr(void)
{
80106f1f:	55                   	push   %ebp
80106f20:	89 e5                	mov    %esp,%ebp
80106f22:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106f25:	c7 04 24 db 6e 10 80 	movl   $0x80106edb,(%esp)
80106f2c:	e8 7a 98 ff ff       	call   801007ab <consoleintr>
}
80106f31:	c9                   	leave  
80106f32:	c3                   	ret    
	...

80106f34 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106f34:	6a 00                	push   $0x0
  pushl $0
80106f36:	6a 00                	push   $0x0
  jmp alltraps
80106f38:	e9 7b f9 ff ff       	jmp    801068b8 <alltraps>

80106f3d <vector1>:
.globl vector1
vector1:
  pushl $0
80106f3d:	6a 00                	push   $0x0
  pushl $1
80106f3f:	6a 01                	push   $0x1
  jmp alltraps
80106f41:	e9 72 f9 ff ff       	jmp    801068b8 <alltraps>

80106f46 <vector2>:
.globl vector2
vector2:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $2
80106f48:	6a 02                	push   $0x2
  jmp alltraps
80106f4a:	e9 69 f9 ff ff       	jmp    801068b8 <alltraps>

80106f4f <vector3>:
.globl vector3
vector3:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $3
80106f51:	6a 03                	push   $0x3
  jmp alltraps
80106f53:	e9 60 f9 ff ff       	jmp    801068b8 <alltraps>

80106f58 <vector4>:
.globl vector4
vector4:
  pushl $0
80106f58:	6a 00                	push   $0x0
  pushl $4
80106f5a:	6a 04                	push   $0x4
  jmp alltraps
80106f5c:	e9 57 f9 ff ff       	jmp    801068b8 <alltraps>

80106f61 <vector5>:
.globl vector5
vector5:
  pushl $0
80106f61:	6a 00                	push   $0x0
  pushl $5
80106f63:	6a 05                	push   $0x5
  jmp alltraps
80106f65:	e9 4e f9 ff ff       	jmp    801068b8 <alltraps>

80106f6a <vector6>:
.globl vector6
vector6:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $6
80106f6c:	6a 06                	push   $0x6
  jmp alltraps
80106f6e:	e9 45 f9 ff ff       	jmp    801068b8 <alltraps>

80106f73 <vector7>:
.globl vector7
vector7:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $7
80106f75:	6a 07                	push   $0x7
  jmp alltraps
80106f77:	e9 3c f9 ff ff       	jmp    801068b8 <alltraps>

80106f7c <vector8>:
.globl vector8
vector8:
  pushl $8
80106f7c:	6a 08                	push   $0x8
  jmp alltraps
80106f7e:	e9 35 f9 ff ff       	jmp    801068b8 <alltraps>

80106f83 <vector9>:
.globl vector9
vector9:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $9
80106f85:	6a 09                	push   $0x9
  jmp alltraps
80106f87:	e9 2c f9 ff ff       	jmp    801068b8 <alltraps>

80106f8c <vector10>:
.globl vector10
vector10:
  pushl $10
80106f8c:	6a 0a                	push   $0xa
  jmp alltraps
80106f8e:	e9 25 f9 ff ff       	jmp    801068b8 <alltraps>

80106f93 <vector11>:
.globl vector11
vector11:
  pushl $11
80106f93:	6a 0b                	push   $0xb
  jmp alltraps
80106f95:	e9 1e f9 ff ff       	jmp    801068b8 <alltraps>

80106f9a <vector12>:
.globl vector12
vector12:
  pushl $12
80106f9a:	6a 0c                	push   $0xc
  jmp alltraps
80106f9c:	e9 17 f9 ff ff       	jmp    801068b8 <alltraps>

80106fa1 <vector13>:
.globl vector13
vector13:
  pushl $13
80106fa1:	6a 0d                	push   $0xd
  jmp alltraps
80106fa3:	e9 10 f9 ff ff       	jmp    801068b8 <alltraps>

80106fa8 <vector14>:
.globl vector14
vector14:
  pushl $14
80106fa8:	6a 0e                	push   $0xe
  jmp alltraps
80106faa:	e9 09 f9 ff ff       	jmp    801068b8 <alltraps>

80106faf <vector15>:
.globl vector15
vector15:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $15
80106fb1:	6a 0f                	push   $0xf
  jmp alltraps
80106fb3:	e9 00 f9 ff ff       	jmp    801068b8 <alltraps>

80106fb8 <vector16>:
.globl vector16
vector16:
  pushl $0
80106fb8:	6a 00                	push   $0x0
  pushl $16
80106fba:	6a 10                	push   $0x10
  jmp alltraps
80106fbc:	e9 f7 f8 ff ff       	jmp    801068b8 <alltraps>

80106fc1 <vector17>:
.globl vector17
vector17:
  pushl $17
80106fc1:	6a 11                	push   $0x11
  jmp alltraps
80106fc3:	e9 f0 f8 ff ff       	jmp    801068b8 <alltraps>

80106fc8 <vector18>:
.globl vector18
vector18:
  pushl $0
80106fc8:	6a 00                	push   $0x0
  pushl $18
80106fca:	6a 12                	push   $0x12
  jmp alltraps
80106fcc:	e9 e7 f8 ff ff       	jmp    801068b8 <alltraps>

80106fd1 <vector19>:
.globl vector19
vector19:
  pushl $0
80106fd1:	6a 00                	push   $0x0
  pushl $19
80106fd3:	6a 13                	push   $0x13
  jmp alltraps
80106fd5:	e9 de f8 ff ff       	jmp    801068b8 <alltraps>

80106fda <vector20>:
.globl vector20
vector20:
  pushl $0
80106fda:	6a 00                	push   $0x0
  pushl $20
80106fdc:	6a 14                	push   $0x14
  jmp alltraps
80106fde:	e9 d5 f8 ff ff       	jmp    801068b8 <alltraps>

80106fe3 <vector21>:
.globl vector21
vector21:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $21
80106fe5:	6a 15                	push   $0x15
  jmp alltraps
80106fe7:	e9 cc f8 ff ff       	jmp    801068b8 <alltraps>

80106fec <vector22>:
.globl vector22
vector22:
  pushl $0
80106fec:	6a 00                	push   $0x0
  pushl $22
80106fee:	6a 16                	push   $0x16
  jmp alltraps
80106ff0:	e9 c3 f8 ff ff       	jmp    801068b8 <alltraps>

80106ff5 <vector23>:
.globl vector23
vector23:
  pushl $0
80106ff5:	6a 00                	push   $0x0
  pushl $23
80106ff7:	6a 17                	push   $0x17
  jmp alltraps
80106ff9:	e9 ba f8 ff ff       	jmp    801068b8 <alltraps>

80106ffe <vector24>:
.globl vector24
vector24:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $24
80107000:	6a 18                	push   $0x18
  jmp alltraps
80107002:	e9 b1 f8 ff ff       	jmp    801068b8 <alltraps>

80107007 <vector25>:
.globl vector25
vector25:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $25
80107009:	6a 19                	push   $0x19
  jmp alltraps
8010700b:	e9 a8 f8 ff ff       	jmp    801068b8 <alltraps>

80107010 <vector26>:
.globl vector26
vector26:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $26
80107012:	6a 1a                	push   $0x1a
  jmp alltraps
80107014:	e9 9f f8 ff ff       	jmp    801068b8 <alltraps>

80107019 <vector27>:
.globl vector27
vector27:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $27
8010701b:	6a 1b                	push   $0x1b
  jmp alltraps
8010701d:	e9 96 f8 ff ff       	jmp    801068b8 <alltraps>

80107022 <vector28>:
.globl vector28
vector28:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $28
80107024:	6a 1c                	push   $0x1c
  jmp alltraps
80107026:	e9 8d f8 ff ff       	jmp    801068b8 <alltraps>

8010702b <vector29>:
.globl vector29
vector29:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $29
8010702d:	6a 1d                	push   $0x1d
  jmp alltraps
8010702f:	e9 84 f8 ff ff       	jmp    801068b8 <alltraps>

80107034 <vector30>:
.globl vector30
vector30:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $30
80107036:	6a 1e                	push   $0x1e
  jmp alltraps
80107038:	e9 7b f8 ff ff       	jmp    801068b8 <alltraps>

8010703d <vector31>:
.globl vector31
vector31:
  pushl $0
8010703d:	6a 00                	push   $0x0
  pushl $31
8010703f:	6a 1f                	push   $0x1f
  jmp alltraps
80107041:	e9 72 f8 ff ff       	jmp    801068b8 <alltraps>

80107046 <vector32>:
.globl vector32
vector32:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $32
80107048:	6a 20                	push   $0x20
  jmp alltraps
8010704a:	e9 69 f8 ff ff       	jmp    801068b8 <alltraps>

8010704f <vector33>:
.globl vector33
vector33:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $33
80107051:	6a 21                	push   $0x21
  jmp alltraps
80107053:	e9 60 f8 ff ff       	jmp    801068b8 <alltraps>

80107058 <vector34>:
.globl vector34
vector34:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $34
8010705a:	6a 22                	push   $0x22
  jmp alltraps
8010705c:	e9 57 f8 ff ff       	jmp    801068b8 <alltraps>

80107061 <vector35>:
.globl vector35
vector35:
  pushl $0
80107061:	6a 00                	push   $0x0
  pushl $35
80107063:	6a 23                	push   $0x23
  jmp alltraps
80107065:	e9 4e f8 ff ff       	jmp    801068b8 <alltraps>

8010706a <vector36>:
.globl vector36
vector36:
  pushl $0
8010706a:	6a 00                	push   $0x0
  pushl $36
8010706c:	6a 24                	push   $0x24
  jmp alltraps
8010706e:	e9 45 f8 ff ff       	jmp    801068b8 <alltraps>

80107073 <vector37>:
.globl vector37
vector37:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $37
80107075:	6a 25                	push   $0x25
  jmp alltraps
80107077:	e9 3c f8 ff ff       	jmp    801068b8 <alltraps>

8010707c <vector38>:
.globl vector38
vector38:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $38
8010707e:	6a 26                	push   $0x26
  jmp alltraps
80107080:	e9 33 f8 ff ff       	jmp    801068b8 <alltraps>

80107085 <vector39>:
.globl vector39
vector39:
  pushl $0
80107085:	6a 00                	push   $0x0
  pushl $39
80107087:	6a 27                	push   $0x27
  jmp alltraps
80107089:	e9 2a f8 ff ff       	jmp    801068b8 <alltraps>

8010708e <vector40>:
.globl vector40
vector40:
  pushl $0
8010708e:	6a 00                	push   $0x0
  pushl $40
80107090:	6a 28                	push   $0x28
  jmp alltraps
80107092:	e9 21 f8 ff ff       	jmp    801068b8 <alltraps>

80107097 <vector41>:
.globl vector41
vector41:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $41
80107099:	6a 29                	push   $0x29
  jmp alltraps
8010709b:	e9 18 f8 ff ff       	jmp    801068b8 <alltraps>

801070a0 <vector42>:
.globl vector42
vector42:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $42
801070a2:	6a 2a                	push   $0x2a
  jmp alltraps
801070a4:	e9 0f f8 ff ff       	jmp    801068b8 <alltraps>

801070a9 <vector43>:
.globl vector43
vector43:
  pushl $0
801070a9:	6a 00                	push   $0x0
  pushl $43
801070ab:	6a 2b                	push   $0x2b
  jmp alltraps
801070ad:	e9 06 f8 ff ff       	jmp    801068b8 <alltraps>

801070b2 <vector44>:
.globl vector44
vector44:
  pushl $0
801070b2:	6a 00                	push   $0x0
  pushl $44
801070b4:	6a 2c                	push   $0x2c
  jmp alltraps
801070b6:	e9 fd f7 ff ff       	jmp    801068b8 <alltraps>

801070bb <vector45>:
.globl vector45
vector45:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $45
801070bd:	6a 2d                	push   $0x2d
  jmp alltraps
801070bf:	e9 f4 f7 ff ff       	jmp    801068b8 <alltraps>

801070c4 <vector46>:
.globl vector46
vector46:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $46
801070c6:	6a 2e                	push   $0x2e
  jmp alltraps
801070c8:	e9 eb f7 ff ff       	jmp    801068b8 <alltraps>

801070cd <vector47>:
.globl vector47
vector47:
  pushl $0
801070cd:	6a 00                	push   $0x0
  pushl $47
801070cf:	6a 2f                	push   $0x2f
  jmp alltraps
801070d1:	e9 e2 f7 ff ff       	jmp    801068b8 <alltraps>

801070d6 <vector48>:
.globl vector48
vector48:
  pushl $0
801070d6:	6a 00                	push   $0x0
  pushl $48
801070d8:	6a 30                	push   $0x30
  jmp alltraps
801070da:	e9 d9 f7 ff ff       	jmp    801068b8 <alltraps>

801070df <vector49>:
.globl vector49
vector49:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $49
801070e1:	6a 31                	push   $0x31
  jmp alltraps
801070e3:	e9 d0 f7 ff ff       	jmp    801068b8 <alltraps>

801070e8 <vector50>:
.globl vector50
vector50:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $50
801070ea:	6a 32                	push   $0x32
  jmp alltraps
801070ec:	e9 c7 f7 ff ff       	jmp    801068b8 <alltraps>

801070f1 <vector51>:
.globl vector51
vector51:
  pushl $0
801070f1:	6a 00                	push   $0x0
  pushl $51
801070f3:	6a 33                	push   $0x33
  jmp alltraps
801070f5:	e9 be f7 ff ff       	jmp    801068b8 <alltraps>

801070fa <vector52>:
.globl vector52
vector52:
  pushl $0
801070fa:	6a 00                	push   $0x0
  pushl $52
801070fc:	6a 34                	push   $0x34
  jmp alltraps
801070fe:	e9 b5 f7 ff ff       	jmp    801068b8 <alltraps>

80107103 <vector53>:
.globl vector53
vector53:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $53
80107105:	6a 35                	push   $0x35
  jmp alltraps
80107107:	e9 ac f7 ff ff       	jmp    801068b8 <alltraps>

8010710c <vector54>:
.globl vector54
vector54:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $54
8010710e:	6a 36                	push   $0x36
  jmp alltraps
80107110:	e9 a3 f7 ff ff       	jmp    801068b8 <alltraps>

80107115 <vector55>:
.globl vector55
vector55:
  pushl $0
80107115:	6a 00                	push   $0x0
  pushl $55
80107117:	6a 37                	push   $0x37
  jmp alltraps
80107119:	e9 9a f7 ff ff       	jmp    801068b8 <alltraps>

8010711e <vector56>:
.globl vector56
vector56:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $56
80107120:	6a 38                	push   $0x38
  jmp alltraps
80107122:	e9 91 f7 ff ff       	jmp    801068b8 <alltraps>

80107127 <vector57>:
.globl vector57
vector57:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $57
80107129:	6a 39                	push   $0x39
  jmp alltraps
8010712b:	e9 88 f7 ff ff       	jmp    801068b8 <alltraps>

80107130 <vector58>:
.globl vector58
vector58:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $58
80107132:	6a 3a                	push   $0x3a
  jmp alltraps
80107134:	e9 7f f7 ff ff       	jmp    801068b8 <alltraps>

80107139 <vector59>:
.globl vector59
vector59:
  pushl $0
80107139:	6a 00                	push   $0x0
  pushl $59
8010713b:	6a 3b                	push   $0x3b
  jmp alltraps
8010713d:	e9 76 f7 ff ff       	jmp    801068b8 <alltraps>

80107142 <vector60>:
.globl vector60
vector60:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $60
80107144:	6a 3c                	push   $0x3c
  jmp alltraps
80107146:	e9 6d f7 ff ff       	jmp    801068b8 <alltraps>

8010714b <vector61>:
.globl vector61
vector61:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $61
8010714d:	6a 3d                	push   $0x3d
  jmp alltraps
8010714f:	e9 64 f7 ff ff       	jmp    801068b8 <alltraps>

80107154 <vector62>:
.globl vector62
vector62:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $62
80107156:	6a 3e                	push   $0x3e
  jmp alltraps
80107158:	e9 5b f7 ff ff       	jmp    801068b8 <alltraps>

8010715d <vector63>:
.globl vector63
vector63:
  pushl $0
8010715d:	6a 00                	push   $0x0
  pushl $63
8010715f:	6a 3f                	push   $0x3f
  jmp alltraps
80107161:	e9 52 f7 ff ff       	jmp    801068b8 <alltraps>

80107166 <vector64>:
.globl vector64
vector64:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $64
80107168:	6a 40                	push   $0x40
  jmp alltraps
8010716a:	e9 49 f7 ff ff       	jmp    801068b8 <alltraps>

8010716f <vector65>:
.globl vector65
vector65:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $65
80107171:	6a 41                	push   $0x41
  jmp alltraps
80107173:	e9 40 f7 ff ff       	jmp    801068b8 <alltraps>

80107178 <vector66>:
.globl vector66
vector66:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $66
8010717a:	6a 42                	push   $0x42
  jmp alltraps
8010717c:	e9 37 f7 ff ff       	jmp    801068b8 <alltraps>

80107181 <vector67>:
.globl vector67
vector67:
  pushl $0
80107181:	6a 00                	push   $0x0
  pushl $67
80107183:	6a 43                	push   $0x43
  jmp alltraps
80107185:	e9 2e f7 ff ff       	jmp    801068b8 <alltraps>

8010718a <vector68>:
.globl vector68
vector68:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $68
8010718c:	6a 44                	push   $0x44
  jmp alltraps
8010718e:	e9 25 f7 ff ff       	jmp    801068b8 <alltraps>

80107193 <vector69>:
.globl vector69
vector69:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $69
80107195:	6a 45                	push   $0x45
  jmp alltraps
80107197:	e9 1c f7 ff ff       	jmp    801068b8 <alltraps>

8010719c <vector70>:
.globl vector70
vector70:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $70
8010719e:	6a 46                	push   $0x46
  jmp alltraps
801071a0:	e9 13 f7 ff ff       	jmp    801068b8 <alltraps>

801071a5 <vector71>:
.globl vector71
vector71:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $71
801071a7:	6a 47                	push   $0x47
  jmp alltraps
801071a9:	e9 0a f7 ff ff       	jmp    801068b8 <alltraps>

801071ae <vector72>:
.globl vector72
vector72:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $72
801071b0:	6a 48                	push   $0x48
  jmp alltraps
801071b2:	e9 01 f7 ff ff       	jmp    801068b8 <alltraps>

801071b7 <vector73>:
.globl vector73
vector73:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $73
801071b9:	6a 49                	push   $0x49
  jmp alltraps
801071bb:	e9 f8 f6 ff ff       	jmp    801068b8 <alltraps>

801071c0 <vector74>:
.globl vector74
vector74:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $74
801071c2:	6a 4a                	push   $0x4a
  jmp alltraps
801071c4:	e9 ef f6 ff ff       	jmp    801068b8 <alltraps>

801071c9 <vector75>:
.globl vector75
vector75:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $75
801071cb:	6a 4b                	push   $0x4b
  jmp alltraps
801071cd:	e9 e6 f6 ff ff       	jmp    801068b8 <alltraps>

801071d2 <vector76>:
.globl vector76
vector76:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $76
801071d4:	6a 4c                	push   $0x4c
  jmp alltraps
801071d6:	e9 dd f6 ff ff       	jmp    801068b8 <alltraps>

801071db <vector77>:
.globl vector77
vector77:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $77
801071dd:	6a 4d                	push   $0x4d
  jmp alltraps
801071df:	e9 d4 f6 ff ff       	jmp    801068b8 <alltraps>

801071e4 <vector78>:
.globl vector78
vector78:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $78
801071e6:	6a 4e                	push   $0x4e
  jmp alltraps
801071e8:	e9 cb f6 ff ff       	jmp    801068b8 <alltraps>

801071ed <vector79>:
.globl vector79
vector79:
  pushl $0
801071ed:	6a 00                	push   $0x0
  pushl $79
801071ef:	6a 4f                	push   $0x4f
  jmp alltraps
801071f1:	e9 c2 f6 ff ff       	jmp    801068b8 <alltraps>

801071f6 <vector80>:
.globl vector80
vector80:
  pushl $0
801071f6:	6a 00                	push   $0x0
  pushl $80
801071f8:	6a 50                	push   $0x50
  jmp alltraps
801071fa:	e9 b9 f6 ff ff       	jmp    801068b8 <alltraps>

801071ff <vector81>:
.globl vector81
vector81:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $81
80107201:	6a 51                	push   $0x51
  jmp alltraps
80107203:	e9 b0 f6 ff ff       	jmp    801068b8 <alltraps>

80107208 <vector82>:
.globl vector82
vector82:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $82
8010720a:	6a 52                	push   $0x52
  jmp alltraps
8010720c:	e9 a7 f6 ff ff       	jmp    801068b8 <alltraps>

80107211 <vector83>:
.globl vector83
vector83:
  pushl $0
80107211:	6a 00                	push   $0x0
  pushl $83
80107213:	6a 53                	push   $0x53
  jmp alltraps
80107215:	e9 9e f6 ff ff       	jmp    801068b8 <alltraps>

8010721a <vector84>:
.globl vector84
vector84:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $84
8010721c:	6a 54                	push   $0x54
  jmp alltraps
8010721e:	e9 95 f6 ff ff       	jmp    801068b8 <alltraps>

80107223 <vector85>:
.globl vector85
vector85:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $85
80107225:	6a 55                	push   $0x55
  jmp alltraps
80107227:	e9 8c f6 ff ff       	jmp    801068b8 <alltraps>

8010722c <vector86>:
.globl vector86
vector86:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $86
8010722e:	6a 56                	push   $0x56
  jmp alltraps
80107230:	e9 83 f6 ff ff       	jmp    801068b8 <alltraps>

80107235 <vector87>:
.globl vector87
vector87:
  pushl $0
80107235:	6a 00                	push   $0x0
  pushl $87
80107237:	6a 57                	push   $0x57
  jmp alltraps
80107239:	e9 7a f6 ff ff       	jmp    801068b8 <alltraps>

8010723e <vector88>:
.globl vector88
vector88:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $88
80107240:	6a 58                	push   $0x58
  jmp alltraps
80107242:	e9 71 f6 ff ff       	jmp    801068b8 <alltraps>

80107247 <vector89>:
.globl vector89
vector89:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $89
80107249:	6a 59                	push   $0x59
  jmp alltraps
8010724b:	e9 68 f6 ff ff       	jmp    801068b8 <alltraps>

80107250 <vector90>:
.globl vector90
vector90:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $90
80107252:	6a 5a                	push   $0x5a
  jmp alltraps
80107254:	e9 5f f6 ff ff       	jmp    801068b8 <alltraps>

80107259 <vector91>:
.globl vector91
vector91:
  pushl $0
80107259:	6a 00                	push   $0x0
  pushl $91
8010725b:	6a 5b                	push   $0x5b
  jmp alltraps
8010725d:	e9 56 f6 ff ff       	jmp    801068b8 <alltraps>

80107262 <vector92>:
.globl vector92
vector92:
  pushl $0
80107262:	6a 00                	push   $0x0
  pushl $92
80107264:	6a 5c                	push   $0x5c
  jmp alltraps
80107266:	e9 4d f6 ff ff       	jmp    801068b8 <alltraps>

8010726b <vector93>:
.globl vector93
vector93:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $93
8010726d:	6a 5d                	push   $0x5d
  jmp alltraps
8010726f:	e9 44 f6 ff ff       	jmp    801068b8 <alltraps>

80107274 <vector94>:
.globl vector94
vector94:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $94
80107276:	6a 5e                	push   $0x5e
  jmp alltraps
80107278:	e9 3b f6 ff ff       	jmp    801068b8 <alltraps>

8010727d <vector95>:
.globl vector95
vector95:
  pushl $0
8010727d:	6a 00                	push   $0x0
  pushl $95
8010727f:	6a 5f                	push   $0x5f
  jmp alltraps
80107281:	e9 32 f6 ff ff       	jmp    801068b8 <alltraps>

80107286 <vector96>:
.globl vector96
vector96:
  pushl $0
80107286:	6a 00                	push   $0x0
  pushl $96
80107288:	6a 60                	push   $0x60
  jmp alltraps
8010728a:	e9 29 f6 ff ff       	jmp    801068b8 <alltraps>

8010728f <vector97>:
.globl vector97
vector97:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $97
80107291:	6a 61                	push   $0x61
  jmp alltraps
80107293:	e9 20 f6 ff ff       	jmp    801068b8 <alltraps>

80107298 <vector98>:
.globl vector98
vector98:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $98
8010729a:	6a 62                	push   $0x62
  jmp alltraps
8010729c:	e9 17 f6 ff ff       	jmp    801068b8 <alltraps>

801072a1 <vector99>:
.globl vector99
vector99:
  pushl $0
801072a1:	6a 00                	push   $0x0
  pushl $99
801072a3:	6a 63                	push   $0x63
  jmp alltraps
801072a5:	e9 0e f6 ff ff       	jmp    801068b8 <alltraps>

801072aa <vector100>:
.globl vector100
vector100:
  pushl $0
801072aa:	6a 00                	push   $0x0
  pushl $100
801072ac:	6a 64                	push   $0x64
  jmp alltraps
801072ae:	e9 05 f6 ff ff       	jmp    801068b8 <alltraps>

801072b3 <vector101>:
.globl vector101
vector101:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $101
801072b5:	6a 65                	push   $0x65
  jmp alltraps
801072b7:	e9 fc f5 ff ff       	jmp    801068b8 <alltraps>

801072bc <vector102>:
.globl vector102
vector102:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $102
801072be:	6a 66                	push   $0x66
  jmp alltraps
801072c0:	e9 f3 f5 ff ff       	jmp    801068b8 <alltraps>

801072c5 <vector103>:
.globl vector103
vector103:
  pushl $0
801072c5:	6a 00                	push   $0x0
  pushl $103
801072c7:	6a 67                	push   $0x67
  jmp alltraps
801072c9:	e9 ea f5 ff ff       	jmp    801068b8 <alltraps>

801072ce <vector104>:
.globl vector104
vector104:
  pushl $0
801072ce:	6a 00                	push   $0x0
  pushl $104
801072d0:	6a 68                	push   $0x68
  jmp alltraps
801072d2:	e9 e1 f5 ff ff       	jmp    801068b8 <alltraps>

801072d7 <vector105>:
.globl vector105
vector105:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $105
801072d9:	6a 69                	push   $0x69
  jmp alltraps
801072db:	e9 d8 f5 ff ff       	jmp    801068b8 <alltraps>

801072e0 <vector106>:
.globl vector106
vector106:
  pushl $0
801072e0:	6a 00                	push   $0x0
  pushl $106
801072e2:	6a 6a                	push   $0x6a
  jmp alltraps
801072e4:	e9 cf f5 ff ff       	jmp    801068b8 <alltraps>

801072e9 <vector107>:
.globl vector107
vector107:
  pushl $0
801072e9:	6a 00                	push   $0x0
  pushl $107
801072eb:	6a 6b                	push   $0x6b
  jmp alltraps
801072ed:	e9 c6 f5 ff ff       	jmp    801068b8 <alltraps>

801072f2 <vector108>:
.globl vector108
vector108:
  pushl $0
801072f2:	6a 00                	push   $0x0
  pushl $108
801072f4:	6a 6c                	push   $0x6c
  jmp alltraps
801072f6:	e9 bd f5 ff ff       	jmp    801068b8 <alltraps>

801072fb <vector109>:
.globl vector109
vector109:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $109
801072fd:	6a 6d                	push   $0x6d
  jmp alltraps
801072ff:	e9 b4 f5 ff ff       	jmp    801068b8 <alltraps>

80107304 <vector110>:
.globl vector110
vector110:
  pushl $0
80107304:	6a 00                	push   $0x0
  pushl $110
80107306:	6a 6e                	push   $0x6e
  jmp alltraps
80107308:	e9 ab f5 ff ff       	jmp    801068b8 <alltraps>

8010730d <vector111>:
.globl vector111
vector111:
  pushl $0
8010730d:	6a 00                	push   $0x0
  pushl $111
8010730f:	6a 6f                	push   $0x6f
  jmp alltraps
80107311:	e9 a2 f5 ff ff       	jmp    801068b8 <alltraps>

80107316 <vector112>:
.globl vector112
vector112:
  pushl $0
80107316:	6a 00                	push   $0x0
  pushl $112
80107318:	6a 70                	push   $0x70
  jmp alltraps
8010731a:	e9 99 f5 ff ff       	jmp    801068b8 <alltraps>

8010731f <vector113>:
.globl vector113
vector113:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $113
80107321:	6a 71                	push   $0x71
  jmp alltraps
80107323:	e9 90 f5 ff ff       	jmp    801068b8 <alltraps>

80107328 <vector114>:
.globl vector114
vector114:
  pushl $0
80107328:	6a 00                	push   $0x0
  pushl $114
8010732a:	6a 72                	push   $0x72
  jmp alltraps
8010732c:	e9 87 f5 ff ff       	jmp    801068b8 <alltraps>

80107331 <vector115>:
.globl vector115
vector115:
  pushl $0
80107331:	6a 00                	push   $0x0
  pushl $115
80107333:	6a 73                	push   $0x73
  jmp alltraps
80107335:	e9 7e f5 ff ff       	jmp    801068b8 <alltraps>

8010733a <vector116>:
.globl vector116
vector116:
  pushl $0
8010733a:	6a 00                	push   $0x0
  pushl $116
8010733c:	6a 74                	push   $0x74
  jmp alltraps
8010733e:	e9 75 f5 ff ff       	jmp    801068b8 <alltraps>

80107343 <vector117>:
.globl vector117
vector117:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $117
80107345:	6a 75                	push   $0x75
  jmp alltraps
80107347:	e9 6c f5 ff ff       	jmp    801068b8 <alltraps>

8010734c <vector118>:
.globl vector118
vector118:
  pushl $0
8010734c:	6a 00                	push   $0x0
  pushl $118
8010734e:	6a 76                	push   $0x76
  jmp alltraps
80107350:	e9 63 f5 ff ff       	jmp    801068b8 <alltraps>

80107355 <vector119>:
.globl vector119
vector119:
  pushl $0
80107355:	6a 00                	push   $0x0
  pushl $119
80107357:	6a 77                	push   $0x77
  jmp alltraps
80107359:	e9 5a f5 ff ff       	jmp    801068b8 <alltraps>

8010735e <vector120>:
.globl vector120
vector120:
  pushl $0
8010735e:	6a 00                	push   $0x0
  pushl $120
80107360:	6a 78                	push   $0x78
  jmp alltraps
80107362:	e9 51 f5 ff ff       	jmp    801068b8 <alltraps>

80107367 <vector121>:
.globl vector121
vector121:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $121
80107369:	6a 79                	push   $0x79
  jmp alltraps
8010736b:	e9 48 f5 ff ff       	jmp    801068b8 <alltraps>

80107370 <vector122>:
.globl vector122
vector122:
  pushl $0
80107370:	6a 00                	push   $0x0
  pushl $122
80107372:	6a 7a                	push   $0x7a
  jmp alltraps
80107374:	e9 3f f5 ff ff       	jmp    801068b8 <alltraps>

80107379 <vector123>:
.globl vector123
vector123:
  pushl $0
80107379:	6a 00                	push   $0x0
  pushl $123
8010737b:	6a 7b                	push   $0x7b
  jmp alltraps
8010737d:	e9 36 f5 ff ff       	jmp    801068b8 <alltraps>

80107382 <vector124>:
.globl vector124
vector124:
  pushl $0
80107382:	6a 00                	push   $0x0
  pushl $124
80107384:	6a 7c                	push   $0x7c
  jmp alltraps
80107386:	e9 2d f5 ff ff       	jmp    801068b8 <alltraps>

8010738b <vector125>:
.globl vector125
vector125:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $125
8010738d:	6a 7d                	push   $0x7d
  jmp alltraps
8010738f:	e9 24 f5 ff ff       	jmp    801068b8 <alltraps>

80107394 <vector126>:
.globl vector126
vector126:
  pushl $0
80107394:	6a 00                	push   $0x0
  pushl $126
80107396:	6a 7e                	push   $0x7e
  jmp alltraps
80107398:	e9 1b f5 ff ff       	jmp    801068b8 <alltraps>

8010739d <vector127>:
.globl vector127
vector127:
  pushl $0
8010739d:	6a 00                	push   $0x0
  pushl $127
8010739f:	6a 7f                	push   $0x7f
  jmp alltraps
801073a1:	e9 12 f5 ff ff       	jmp    801068b8 <alltraps>

801073a6 <vector128>:
.globl vector128
vector128:
  pushl $0
801073a6:	6a 00                	push   $0x0
  pushl $128
801073a8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801073ad:	e9 06 f5 ff ff       	jmp    801068b8 <alltraps>

801073b2 <vector129>:
.globl vector129
vector129:
  pushl $0
801073b2:	6a 00                	push   $0x0
  pushl $129
801073b4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801073b9:	e9 fa f4 ff ff       	jmp    801068b8 <alltraps>

801073be <vector130>:
.globl vector130
vector130:
  pushl $0
801073be:	6a 00                	push   $0x0
  pushl $130
801073c0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801073c5:	e9 ee f4 ff ff       	jmp    801068b8 <alltraps>

801073ca <vector131>:
.globl vector131
vector131:
  pushl $0
801073ca:	6a 00                	push   $0x0
  pushl $131
801073cc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801073d1:	e9 e2 f4 ff ff       	jmp    801068b8 <alltraps>

801073d6 <vector132>:
.globl vector132
vector132:
  pushl $0
801073d6:	6a 00                	push   $0x0
  pushl $132
801073d8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801073dd:	e9 d6 f4 ff ff       	jmp    801068b8 <alltraps>

801073e2 <vector133>:
.globl vector133
vector133:
  pushl $0
801073e2:	6a 00                	push   $0x0
  pushl $133
801073e4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801073e9:	e9 ca f4 ff ff       	jmp    801068b8 <alltraps>

801073ee <vector134>:
.globl vector134
vector134:
  pushl $0
801073ee:	6a 00                	push   $0x0
  pushl $134
801073f0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801073f5:	e9 be f4 ff ff       	jmp    801068b8 <alltraps>

801073fa <vector135>:
.globl vector135
vector135:
  pushl $0
801073fa:	6a 00                	push   $0x0
  pushl $135
801073fc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107401:	e9 b2 f4 ff ff       	jmp    801068b8 <alltraps>

80107406 <vector136>:
.globl vector136
vector136:
  pushl $0
80107406:	6a 00                	push   $0x0
  pushl $136
80107408:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010740d:	e9 a6 f4 ff ff       	jmp    801068b8 <alltraps>

80107412 <vector137>:
.globl vector137
vector137:
  pushl $0
80107412:	6a 00                	push   $0x0
  pushl $137
80107414:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107419:	e9 9a f4 ff ff       	jmp    801068b8 <alltraps>

8010741e <vector138>:
.globl vector138
vector138:
  pushl $0
8010741e:	6a 00                	push   $0x0
  pushl $138
80107420:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107425:	e9 8e f4 ff ff       	jmp    801068b8 <alltraps>

8010742a <vector139>:
.globl vector139
vector139:
  pushl $0
8010742a:	6a 00                	push   $0x0
  pushl $139
8010742c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107431:	e9 82 f4 ff ff       	jmp    801068b8 <alltraps>

80107436 <vector140>:
.globl vector140
vector140:
  pushl $0
80107436:	6a 00                	push   $0x0
  pushl $140
80107438:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010743d:	e9 76 f4 ff ff       	jmp    801068b8 <alltraps>

80107442 <vector141>:
.globl vector141
vector141:
  pushl $0
80107442:	6a 00                	push   $0x0
  pushl $141
80107444:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107449:	e9 6a f4 ff ff       	jmp    801068b8 <alltraps>

8010744e <vector142>:
.globl vector142
vector142:
  pushl $0
8010744e:	6a 00                	push   $0x0
  pushl $142
80107450:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107455:	e9 5e f4 ff ff       	jmp    801068b8 <alltraps>

8010745a <vector143>:
.globl vector143
vector143:
  pushl $0
8010745a:	6a 00                	push   $0x0
  pushl $143
8010745c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107461:	e9 52 f4 ff ff       	jmp    801068b8 <alltraps>

80107466 <vector144>:
.globl vector144
vector144:
  pushl $0
80107466:	6a 00                	push   $0x0
  pushl $144
80107468:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010746d:	e9 46 f4 ff ff       	jmp    801068b8 <alltraps>

80107472 <vector145>:
.globl vector145
vector145:
  pushl $0
80107472:	6a 00                	push   $0x0
  pushl $145
80107474:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107479:	e9 3a f4 ff ff       	jmp    801068b8 <alltraps>

8010747e <vector146>:
.globl vector146
vector146:
  pushl $0
8010747e:	6a 00                	push   $0x0
  pushl $146
80107480:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107485:	e9 2e f4 ff ff       	jmp    801068b8 <alltraps>

8010748a <vector147>:
.globl vector147
vector147:
  pushl $0
8010748a:	6a 00                	push   $0x0
  pushl $147
8010748c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107491:	e9 22 f4 ff ff       	jmp    801068b8 <alltraps>

80107496 <vector148>:
.globl vector148
vector148:
  pushl $0
80107496:	6a 00                	push   $0x0
  pushl $148
80107498:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010749d:	e9 16 f4 ff ff       	jmp    801068b8 <alltraps>

801074a2 <vector149>:
.globl vector149
vector149:
  pushl $0
801074a2:	6a 00                	push   $0x0
  pushl $149
801074a4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801074a9:	e9 0a f4 ff ff       	jmp    801068b8 <alltraps>

801074ae <vector150>:
.globl vector150
vector150:
  pushl $0
801074ae:	6a 00                	push   $0x0
  pushl $150
801074b0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801074b5:	e9 fe f3 ff ff       	jmp    801068b8 <alltraps>

801074ba <vector151>:
.globl vector151
vector151:
  pushl $0
801074ba:	6a 00                	push   $0x0
  pushl $151
801074bc:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801074c1:	e9 f2 f3 ff ff       	jmp    801068b8 <alltraps>

801074c6 <vector152>:
.globl vector152
vector152:
  pushl $0
801074c6:	6a 00                	push   $0x0
  pushl $152
801074c8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801074cd:	e9 e6 f3 ff ff       	jmp    801068b8 <alltraps>

801074d2 <vector153>:
.globl vector153
vector153:
  pushl $0
801074d2:	6a 00                	push   $0x0
  pushl $153
801074d4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801074d9:	e9 da f3 ff ff       	jmp    801068b8 <alltraps>

801074de <vector154>:
.globl vector154
vector154:
  pushl $0
801074de:	6a 00                	push   $0x0
  pushl $154
801074e0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801074e5:	e9 ce f3 ff ff       	jmp    801068b8 <alltraps>

801074ea <vector155>:
.globl vector155
vector155:
  pushl $0
801074ea:	6a 00                	push   $0x0
  pushl $155
801074ec:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801074f1:	e9 c2 f3 ff ff       	jmp    801068b8 <alltraps>

801074f6 <vector156>:
.globl vector156
vector156:
  pushl $0
801074f6:	6a 00                	push   $0x0
  pushl $156
801074f8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801074fd:	e9 b6 f3 ff ff       	jmp    801068b8 <alltraps>

80107502 <vector157>:
.globl vector157
vector157:
  pushl $0
80107502:	6a 00                	push   $0x0
  pushl $157
80107504:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107509:	e9 aa f3 ff ff       	jmp    801068b8 <alltraps>

8010750e <vector158>:
.globl vector158
vector158:
  pushl $0
8010750e:	6a 00                	push   $0x0
  pushl $158
80107510:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107515:	e9 9e f3 ff ff       	jmp    801068b8 <alltraps>

8010751a <vector159>:
.globl vector159
vector159:
  pushl $0
8010751a:	6a 00                	push   $0x0
  pushl $159
8010751c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107521:	e9 92 f3 ff ff       	jmp    801068b8 <alltraps>

80107526 <vector160>:
.globl vector160
vector160:
  pushl $0
80107526:	6a 00                	push   $0x0
  pushl $160
80107528:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010752d:	e9 86 f3 ff ff       	jmp    801068b8 <alltraps>

80107532 <vector161>:
.globl vector161
vector161:
  pushl $0
80107532:	6a 00                	push   $0x0
  pushl $161
80107534:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107539:	e9 7a f3 ff ff       	jmp    801068b8 <alltraps>

8010753e <vector162>:
.globl vector162
vector162:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $162
80107540:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107545:	e9 6e f3 ff ff       	jmp    801068b8 <alltraps>

8010754a <vector163>:
.globl vector163
vector163:
  pushl $0
8010754a:	6a 00                	push   $0x0
  pushl $163
8010754c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107551:	e9 62 f3 ff ff       	jmp    801068b8 <alltraps>

80107556 <vector164>:
.globl vector164
vector164:
  pushl $0
80107556:	6a 00                	push   $0x0
  pushl $164
80107558:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010755d:	e9 56 f3 ff ff       	jmp    801068b8 <alltraps>

80107562 <vector165>:
.globl vector165
vector165:
  pushl $0
80107562:	6a 00                	push   $0x0
  pushl $165
80107564:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107569:	e9 4a f3 ff ff       	jmp    801068b8 <alltraps>

8010756e <vector166>:
.globl vector166
vector166:
  pushl $0
8010756e:	6a 00                	push   $0x0
  pushl $166
80107570:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107575:	e9 3e f3 ff ff       	jmp    801068b8 <alltraps>

8010757a <vector167>:
.globl vector167
vector167:
  pushl $0
8010757a:	6a 00                	push   $0x0
  pushl $167
8010757c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107581:	e9 32 f3 ff ff       	jmp    801068b8 <alltraps>

80107586 <vector168>:
.globl vector168
vector168:
  pushl $0
80107586:	6a 00                	push   $0x0
  pushl $168
80107588:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010758d:	e9 26 f3 ff ff       	jmp    801068b8 <alltraps>

80107592 <vector169>:
.globl vector169
vector169:
  pushl $0
80107592:	6a 00                	push   $0x0
  pushl $169
80107594:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107599:	e9 1a f3 ff ff       	jmp    801068b8 <alltraps>

8010759e <vector170>:
.globl vector170
vector170:
  pushl $0
8010759e:	6a 00                	push   $0x0
  pushl $170
801075a0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801075a5:	e9 0e f3 ff ff       	jmp    801068b8 <alltraps>

801075aa <vector171>:
.globl vector171
vector171:
  pushl $0
801075aa:	6a 00                	push   $0x0
  pushl $171
801075ac:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801075b1:	e9 02 f3 ff ff       	jmp    801068b8 <alltraps>

801075b6 <vector172>:
.globl vector172
vector172:
  pushl $0
801075b6:	6a 00                	push   $0x0
  pushl $172
801075b8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801075bd:	e9 f6 f2 ff ff       	jmp    801068b8 <alltraps>

801075c2 <vector173>:
.globl vector173
vector173:
  pushl $0
801075c2:	6a 00                	push   $0x0
  pushl $173
801075c4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801075c9:	e9 ea f2 ff ff       	jmp    801068b8 <alltraps>

801075ce <vector174>:
.globl vector174
vector174:
  pushl $0
801075ce:	6a 00                	push   $0x0
  pushl $174
801075d0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801075d5:	e9 de f2 ff ff       	jmp    801068b8 <alltraps>

801075da <vector175>:
.globl vector175
vector175:
  pushl $0
801075da:	6a 00                	push   $0x0
  pushl $175
801075dc:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801075e1:	e9 d2 f2 ff ff       	jmp    801068b8 <alltraps>

801075e6 <vector176>:
.globl vector176
vector176:
  pushl $0
801075e6:	6a 00                	push   $0x0
  pushl $176
801075e8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801075ed:	e9 c6 f2 ff ff       	jmp    801068b8 <alltraps>

801075f2 <vector177>:
.globl vector177
vector177:
  pushl $0
801075f2:	6a 00                	push   $0x0
  pushl $177
801075f4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801075f9:	e9 ba f2 ff ff       	jmp    801068b8 <alltraps>

801075fe <vector178>:
.globl vector178
vector178:
  pushl $0
801075fe:	6a 00                	push   $0x0
  pushl $178
80107600:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107605:	e9 ae f2 ff ff       	jmp    801068b8 <alltraps>

8010760a <vector179>:
.globl vector179
vector179:
  pushl $0
8010760a:	6a 00                	push   $0x0
  pushl $179
8010760c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107611:	e9 a2 f2 ff ff       	jmp    801068b8 <alltraps>

80107616 <vector180>:
.globl vector180
vector180:
  pushl $0
80107616:	6a 00                	push   $0x0
  pushl $180
80107618:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010761d:	e9 96 f2 ff ff       	jmp    801068b8 <alltraps>

80107622 <vector181>:
.globl vector181
vector181:
  pushl $0
80107622:	6a 00                	push   $0x0
  pushl $181
80107624:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107629:	e9 8a f2 ff ff       	jmp    801068b8 <alltraps>

8010762e <vector182>:
.globl vector182
vector182:
  pushl $0
8010762e:	6a 00                	push   $0x0
  pushl $182
80107630:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107635:	e9 7e f2 ff ff       	jmp    801068b8 <alltraps>

8010763a <vector183>:
.globl vector183
vector183:
  pushl $0
8010763a:	6a 00                	push   $0x0
  pushl $183
8010763c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107641:	e9 72 f2 ff ff       	jmp    801068b8 <alltraps>

80107646 <vector184>:
.globl vector184
vector184:
  pushl $0
80107646:	6a 00                	push   $0x0
  pushl $184
80107648:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010764d:	e9 66 f2 ff ff       	jmp    801068b8 <alltraps>

80107652 <vector185>:
.globl vector185
vector185:
  pushl $0
80107652:	6a 00                	push   $0x0
  pushl $185
80107654:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107659:	e9 5a f2 ff ff       	jmp    801068b8 <alltraps>

8010765e <vector186>:
.globl vector186
vector186:
  pushl $0
8010765e:	6a 00                	push   $0x0
  pushl $186
80107660:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107665:	e9 4e f2 ff ff       	jmp    801068b8 <alltraps>

8010766a <vector187>:
.globl vector187
vector187:
  pushl $0
8010766a:	6a 00                	push   $0x0
  pushl $187
8010766c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107671:	e9 42 f2 ff ff       	jmp    801068b8 <alltraps>

80107676 <vector188>:
.globl vector188
vector188:
  pushl $0
80107676:	6a 00                	push   $0x0
  pushl $188
80107678:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010767d:	e9 36 f2 ff ff       	jmp    801068b8 <alltraps>

80107682 <vector189>:
.globl vector189
vector189:
  pushl $0
80107682:	6a 00                	push   $0x0
  pushl $189
80107684:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107689:	e9 2a f2 ff ff       	jmp    801068b8 <alltraps>

8010768e <vector190>:
.globl vector190
vector190:
  pushl $0
8010768e:	6a 00                	push   $0x0
  pushl $190
80107690:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107695:	e9 1e f2 ff ff       	jmp    801068b8 <alltraps>

8010769a <vector191>:
.globl vector191
vector191:
  pushl $0
8010769a:	6a 00                	push   $0x0
  pushl $191
8010769c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801076a1:	e9 12 f2 ff ff       	jmp    801068b8 <alltraps>

801076a6 <vector192>:
.globl vector192
vector192:
  pushl $0
801076a6:	6a 00                	push   $0x0
  pushl $192
801076a8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801076ad:	e9 06 f2 ff ff       	jmp    801068b8 <alltraps>

801076b2 <vector193>:
.globl vector193
vector193:
  pushl $0
801076b2:	6a 00                	push   $0x0
  pushl $193
801076b4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801076b9:	e9 fa f1 ff ff       	jmp    801068b8 <alltraps>

801076be <vector194>:
.globl vector194
vector194:
  pushl $0
801076be:	6a 00                	push   $0x0
  pushl $194
801076c0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801076c5:	e9 ee f1 ff ff       	jmp    801068b8 <alltraps>

801076ca <vector195>:
.globl vector195
vector195:
  pushl $0
801076ca:	6a 00                	push   $0x0
  pushl $195
801076cc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801076d1:	e9 e2 f1 ff ff       	jmp    801068b8 <alltraps>

801076d6 <vector196>:
.globl vector196
vector196:
  pushl $0
801076d6:	6a 00                	push   $0x0
  pushl $196
801076d8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801076dd:	e9 d6 f1 ff ff       	jmp    801068b8 <alltraps>

801076e2 <vector197>:
.globl vector197
vector197:
  pushl $0
801076e2:	6a 00                	push   $0x0
  pushl $197
801076e4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801076e9:	e9 ca f1 ff ff       	jmp    801068b8 <alltraps>

801076ee <vector198>:
.globl vector198
vector198:
  pushl $0
801076ee:	6a 00                	push   $0x0
  pushl $198
801076f0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801076f5:	e9 be f1 ff ff       	jmp    801068b8 <alltraps>

801076fa <vector199>:
.globl vector199
vector199:
  pushl $0
801076fa:	6a 00                	push   $0x0
  pushl $199
801076fc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107701:	e9 b2 f1 ff ff       	jmp    801068b8 <alltraps>

80107706 <vector200>:
.globl vector200
vector200:
  pushl $0
80107706:	6a 00                	push   $0x0
  pushl $200
80107708:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010770d:	e9 a6 f1 ff ff       	jmp    801068b8 <alltraps>

80107712 <vector201>:
.globl vector201
vector201:
  pushl $0
80107712:	6a 00                	push   $0x0
  pushl $201
80107714:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107719:	e9 9a f1 ff ff       	jmp    801068b8 <alltraps>

8010771e <vector202>:
.globl vector202
vector202:
  pushl $0
8010771e:	6a 00                	push   $0x0
  pushl $202
80107720:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107725:	e9 8e f1 ff ff       	jmp    801068b8 <alltraps>

8010772a <vector203>:
.globl vector203
vector203:
  pushl $0
8010772a:	6a 00                	push   $0x0
  pushl $203
8010772c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107731:	e9 82 f1 ff ff       	jmp    801068b8 <alltraps>

80107736 <vector204>:
.globl vector204
vector204:
  pushl $0
80107736:	6a 00                	push   $0x0
  pushl $204
80107738:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010773d:	e9 76 f1 ff ff       	jmp    801068b8 <alltraps>

80107742 <vector205>:
.globl vector205
vector205:
  pushl $0
80107742:	6a 00                	push   $0x0
  pushl $205
80107744:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107749:	e9 6a f1 ff ff       	jmp    801068b8 <alltraps>

8010774e <vector206>:
.globl vector206
vector206:
  pushl $0
8010774e:	6a 00                	push   $0x0
  pushl $206
80107750:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107755:	e9 5e f1 ff ff       	jmp    801068b8 <alltraps>

8010775a <vector207>:
.globl vector207
vector207:
  pushl $0
8010775a:	6a 00                	push   $0x0
  pushl $207
8010775c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107761:	e9 52 f1 ff ff       	jmp    801068b8 <alltraps>

80107766 <vector208>:
.globl vector208
vector208:
  pushl $0
80107766:	6a 00                	push   $0x0
  pushl $208
80107768:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010776d:	e9 46 f1 ff ff       	jmp    801068b8 <alltraps>

80107772 <vector209>:
.globl vector209
vector209:
  pushl $0
80107772:	6a 00                	push   $0x0
  pushl $209
80107774:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107779:	e9 3a f1 ff ff       	jmp    801068b8 <alltraps>

8010777e <vector210>:
.globl vector210
vector210:
  pushl $0
8010777e:	6a 00                	push   $0x0
  pushl $210
80107780:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107785:	e9 2e f1 ff ff       	jmp    801068b8 <alltraps>

8010778a <vector211>:
.globl vector211
vector211:
  pushl $0
8010778a:	6a 00                	push   $0x0
  pushl $211
8010778c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107791:	e9 22 f1 ff ff       	jmp    801068b8 <alltraps>

80107796 <vector212>:
.globl vector212
vector212:
  pushl $0
80107796:	6a 00                	push   $0x0
  pushl $212
80107798:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010779d:	e9 16 f1 ff ff       	jmp    801068b8 <alltraps>

801077a2 <vector213>:
.globl vector213
vector213:
  pushl $0
801077a2:	6a 00                	push   $0x0
  pushl $213
801077a4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801077a9:	e9 0a f1 ff ff       	jmp    801068b8 <alltraps>

801077ae <vector214>:
.globl vector214
vector214:
  pushl $0
801077ae:	6a 00                	push   $0x0
  pushl $214
801077b0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801077b5:	e9 fe f0 ff ff       	jmp    801068b8 <alltraps>

801077ba <vector215>:
.globl vector215
vector215:
  pushl $0
801077ba:	6a 00                	push   $0x0
  pushl $215
801077bc:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801077c1:	e9 f2 f0 ff ff       	jmp    801068b8 <alltraps>

801077c6 <vector216>:
.globl vector216
vector216:
  pushl $0
801077c6:	6a 00                	push   $0x0
  pushl $216
801077c8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801077cd:	e9 e6 f0 ff ff       	jmp    801068b8 <alltraps>

801077d2 <vector217>:
.globl vector217
vector217:
  pushl $0
801077d2:	6a 00                	push   $0x0
  pushl $217
801077d4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801077d9:	e9 da f0 ff ff       	jmp    801068b8 <alltraps>

801077de <vector218>:
.globl vector218
vector218:
  pushl $0
801077de:	6a 00                	push   $0x0
  pushl $218
801077e0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801077e5:	e9 ce f0 ff ff       	jmp    801068b8 <alltraps>

801077ea <vector219>:
.globl vector219
vector219:
  pushl $0
801077ea:	6a 00                	push   $0x0
  pushl $219
801077ec:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801077f1:	e9 c2 f0 ff ff       	jmp    801068b8 <alltraps>

801077f6 <vector220>:
.globl vector220
vector220:
  pushl $0
801077f6:	6a 00                	push   $0x0
  pushl $220
801077f8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801077fd:	e9 b6 f0 ff ff       	jmp    801068b8 <alltraps>

80107802 <vector221>:
.globl vector221
vector221:
  pushl $0
80107802:	6a 00                	push   $0x0
  pushl $221
80107804:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107809:	e9 aa f0 ff ff       	jmp    801068b8 <alltraps>

8010780e <vector222>:
.globl vector222
vector222:
  pushl $0
8010780e:	6a 00                	push   $0x0
  pushl $222
80107810:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107815:	e9 9e f0 ff ff       	jmp    801068b8 <alltraps>

8010781a <vector223>:
.globl vector223
vector223:
  pushl $0
8010781a:	6a 00                	push   $0x0
  pushl $223
8010781c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107821:	e9 92 f0 ff ff       	jmp    801068b8 <alltraps>

80107826 <vector224>:
.globl vector224
vector224:
  pushl $0
80107826:	6a 00                	push   $0x0
  pushl $224
80107828:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010782d:	e9 86 f0 ff ff       	jmp    801068b8 <alltraps>

80107832 <vector225>:
.globl vector225
vector225:
  pushl $0
80107832:	6a 00                	push   $0x0
  pushl $225
80107834:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107839:	e9 7a f0 ff ff       	jmp    801068b8 <alltraps>

8010783e <vector226>:
.globl vector226
vector226:
  pushl $0
8010783e:	6a 00                	push   $0x0
  pushl $226
80107840:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107845:	e9 6e f0 ff ff       	jmp    801068b8 <alltraps>

8010784a <vector227>:
.globl vector227
vector227:
  pushl $0
8010784a:	6a 00                	push   $0x0
  pushl $227
8010784c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107851:	e9 62 f0 ff ff       	jmp    801068b8 <alltraps>

80107856 <vector228>:
.globl vector228
vector228:
  pushl $0
80107856:	6a 00                	push   $0x0
  pushl $228
80107858:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010785d:	e9 56 f0 ff ff       	jmp    801068b8 <alltraps>

80107862 <vector229>:
.globl vector229
vector229:
  pushl $0
80107862:	6a 00                	push   $0x0
  pushl $229
80107864:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107869:	e9 4a f0 ff ff       	jmp    801068b8 <alltraps>

8010786e <vector230>:
.globl vector230
vector230:
  pushl $0
8010786e:	6a 00                	push   $0x0
  pushl $230
80107870:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107875:	e9 3e f0 ff ff       	jmp    801068b8 <alltraps>

8010787a <vector231>:
.globl vector231
vector231:
  pushl $0
8010787a:	6a 00                	push   $0x0
  pushl $231
8010787c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107881:	e9 32 f0 ff ff       	jmp    801068b8 <alltraps>

80107886 <vector232>:
.globl vector232
vector232:
  pushl $0
80107886:	6a 00                	push   $0x0
  pushl $232
80107888:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010788d:	e9 26 f0 ff ff       	jmp    801068b8 <alltraps>

80107892 <vector233>:
.globl vector233
vector233:
  pushl $0
80107892:	6a 00                	push   $0x0
  pushl $233
80107894:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107899:	e9 1a f0 ff ff       	jmp    801068b8 <alltraps>

8010789e <vector234>:
.globl vector234
vector234:
  pushl $0
8010789e:	6a 00                	push   $0x0
  pushl $234
801078a0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801078a5:	e9 0e f0 ff ff       	jmp    801068b8 <alltraps>

801078aa <vector235>:
.globl vector235
vector235:
  pushl $0
801078aa:	6a 00                	push   $0x0
  pushl $235
801078ac:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801078b1:	e9 02 f0 ff ff       	jmp    801068b8 <alltraps>

801078b6 <vector236>:
.globl vector236
vector236:
  pushl $0
801078b6:	6a 00                	push   $0x0
  pushl $236
801078b8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801078bd:	e9 f6 ef ff ff       	jmp    801068b8 <alltraps>

801078c2 <vector237>:
.globl vector237
vector237:
  pushl $0
801078c2:	6a 00                	push   $0x0
  pushl $237
801078c4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801078c9:	e9 ea ef ff ff       	jmp    801068b8 <alltraps>

801078ce <vector238>:
.globl vector238
vector238:
  pushl $0
801078ce:	6a 00                	push   $0x0
  pushl $238
801078d0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801078d5:	e9 de ef ff ff       	jmp    801068b8 <alltraps>

801078da <vector239>:
.globl vector239
vector239:
  pushl $0
801078da:	6a 00                	push   $0x0
  pushl $239
801078dc:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801078e1:	e9 d2 ef ff ff       	jmp    801068b8 <alltraps>

801078e6 <vector240>:
.globl vector240
vector240:
  pushl $0
801078e6:	6a 00                	push   $0x0
  pushl $240
801078e8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801078ed:	e9 c6 ef ff ff       	jmp    801068b8 <alltraps>

801078f2 <vector241>:
.globl vector241
vector241:
  pushl $0
801078f2:	6a 00                	push   $0x0
  pushl $241
801078f4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801078f9:	e9 ba ef ff ff       	jmp    801068b8 <alltraps>

801078fe <vector242>:
.globl vector242
vector242:
  pushl $0
801078fe:	6a 00                	push   $0x0
  pushl $242
80107900:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107905:	e9 ae ef ff ff       	jmp    801068b8 <alltraps>

8010790a <vector243>:
.globl vector243
vector243:
  pushl $0
8010790a:	6a 00                	push   $0x0
  pushl $243
8010790c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107911:	e9 a2 ef ff ff       	jmp    801068b8 <alltraps>

80107916 <vector244>:
.globl vector244
vector244:
  pushl $0
80107916:	6a 00                	push   $0x0
  pushl $244
80107918:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010791d:	e9 96 ef ff ff       	jmp    801068b8 <alltraps>

80107922 <vector245>:
.globl vector245
vector245:
  pushl $0
80107922:	6a 00                	push   $0x0
  pushl $245
80107924:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107929:	e9 8a ef ff ff       	jmp    801068b8 <alltraps>

8010792e <vector246>:
.globl vector246
vector246:
  pushl $0
8010792e:	6a 00                	push   $0x0
  pushl $246
80107930:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107935:	e9 7e ef ff ff       	jmp    801068b8 <alltraps>

8010793a <vector247>:
.globl vector247
vector247:
  pushl $0
8010793a:	6a 00                	push   $0x0
  pushl $247
8010793c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107941:	e9 72 ef ff ff       	jmp    801068b8 <alltraps>

80107946 <vector248>:
.globl vector248
vector248:
  pushl $0
80107946:	6a 00                	push   $0x0
  pushl $248
80107948:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010794d:	e9 66 ef ff ff       	jmp    801068b8 <alltraps>

80107952 <vector249>:
.globl vector249
vector249:
  pushl $0
80107952:	6a 00                	push   $0x0
  pushl $249
80107954:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107959:	e9 5a ef ff ff       	jmp    801068b8 <alltraps>

8010795e <vector250>:
.globl vector250
vector250:
  pushl $0
8010795e:	6a 00                	push   $0x0
  pushl $250
80107960:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107965:	e9 4e ef ff ff       	jmp    801068b8 <alltraps>

8010796a <vector251>:
.globl vector251
vector251:
  pushl $0
8010796a:	6a 00                	push   $0x0
  pushl $251
8010796c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107971:	e9 42 ef ff ff       	jmp    801068b8 <alltraps>

80107976 <vector252>:
.globl vector252
vector252:
  pushl $0
80107976:	6a 00                	push   $0x0
  pushl $252
80107978:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010797d:	e9 36 ef ff ff       	jmp    801068b8 <alltraps>

80107982 <vector253>:
.globl vector253
vector253:
  pushl $0
80107982:	6a 00                	push   $0x0
  pushl $253
80107984:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107989:	e9 2a ef ff ff       	jmp    801068b8 <alltraps>

8010798e <vector254>:
.globl vector254
vector254:
  pushl $0
8010798e:	6a 00                	push   $0x0
  pushl $254
80107990:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107995:	e9 1e ef ff ff       	jmp    801068b8 <alltraps>

8010799a <vector255>:
.globl vector255
vector255:
  pushl $0
8010799a:	6a 00                	push   $0x0
  pushl $255
8010799c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801079a1:	e9 12 ef ff ff       	jmp    801068b8 <alltraps>
	...

801079a8 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801079a8:	55                   	push   %ebp
801079a9:	89 e5                	mov    %esp,%ebp
801079ab:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801079ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801079b1:	83 e8 01             	sub    $0x1,%eax
801079b4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801079b8:	8b 45 08             	mov    0x8(%ebp),%eax
801079bb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801079bf:	8b 45 08             	mov    0x8(%ebp),%eax
801079c2:	c1 e8 10             	shr    $0x10,%eax
801079c5:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801079c9:	8d 45 fa             	lea    -0x6(%ebp),%eax
801079cc:	0f 01 10             	lgdtl  (%eax)
}
801079cf:	c9                   	leave  
801079d0:	c3                   	ret    

801079d1 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801079d1:	55                   	push   %ebp
801079d2:	89 e5                	mov    %esp,%ebp
801079d4:	83 ec 04             	sub    $0x4,%esp
801079d7:	8b 45 08             	mov    0x8(%ebp),%eax
801079da:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801079de:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801079e2:	0f 00 d8             	ltr    %ax
}
801079e5:	c9                   	leave  
801079e6:	c3                   	ret    

801079e7 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801079e7:	55                   	push   %ebp
801079e8:	89 e5                	mov    %esp,%ebp
801079ea:	83 ec 04             	sub    $0x4,%esp
801079ed:	8b 45 08             	mov    0x8(%ebp),%eax
801079f0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801079f4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801079f8:	8e e8                	mov    %eax,%gs
}
801079fa:	c9                   	leave  
801079fb:	c3                   	ret    

801079fc <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801079fc:	55                   	push   %ebp
801079fd:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801079ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107a02:	0f 22 d8             	mov    %eax,%cr3
}
80107a05:	5d                   	pop    %ebp
80107a06:	c3                   	ret    

80107a07 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107a07:	55                   	push   %ebp
80107a08:	89 e5                	mov    %esp,%ebp
80107a0a:	8b 45 08             	mov    0x8(%ebp),%eax
80107a0d:	2d 00 00 00 80       	sub    $0x80000000,%eax
80107a12:	5d                   	pop    %ebp
80107a13:	c3                   	ret    

80107a14 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107a14:	55                   	push   %ebp
80107a15:	89 e5                	mov    %esp,%ebp
80107a17:	8b 45 08             	mov    0x8(%ebp),%eax
80107a1a:	2d 00 00 00 80       	sub    $0x80000000,%eax
80107a1f:	5d                   	pop    %ebp
80107a20:	c3                   	ret    

80107a21 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107a21:	55                   	push   %ebp
80107a22:	89 e5                	mov    %esp,%ebp
80107a24:	53                   	push   %ebx
80107a25:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107a28:	e8 57 b4 ff ff       	call   80102e84 <cpunum>
80107a2d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107a33:	05 40 f9 10 80       	add    $0x8010f940,%eax
80107a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3e:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a47:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a50:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a57:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a5b:	83 e2 f0             	and    $0xfffffff0,%edx
80107a5e:	83 ca 0a             	or     $0xa,%edx
80107a61:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a67:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a6b:	83 ca 10             	or     $0x10,%edx
80107a6e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a74:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a78:	83 e2 9f             	and    $0xffffff9f,%edx
80107a7b:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a81:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a85:	83 ca 80             	or     $0xffffff80,%edx
80107a88:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a92:	83 ca 0f             	or     $0xf,%edx
80107a95:	88 50 7e             	mov    %dl,0x7e(%eax)
80107a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a9f:	83 e2 ef             	and    $0xffffffef,%edx
80107aa2:	88 50 7e             	mov    %dl,0x7e(%eax)
80107aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107aac:	83 e2 df             	and    $0xffffffdf,%edx
80107aaf:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ab9:	83 ca 40             	or     $0x40,%edx
80107abc:	88 50 7e             	mov    %dl,0x7e(%eax)
80107abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ac6:	83 ca 80             	or     $0xffffff80,%edx
80107ac9:	88 50 7e             	mov    %dl,0x7e(%eax)
80107acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107acf:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad6:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107add:	ff ff 
80107adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae2:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107ae9:	00 00 
80107aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aee:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107aff:	83 e2 f0             	and    $0xfffffff0,%edx
80107b02:	83 ca 02             	or     $0x2,%edx
80107b05:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b15:	83 ca 10             	or     $0x10,%edx
80107b18:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b21:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b28:	83 e2 9f             	and    $0xffffff9f,%edx
80107b2b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b34:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b3b:	83 ca 80             	or     $0xffffff80,%edx
80107b3e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b47:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b4e:	83 ca 0f             	or     $0xf,%edx
80107b51:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b5a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b61:	83 e2 ef             	and    $0xffffffef,%edx
80107b64:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b74:	83 e2 df             	and    $0xffffffdf,%edx
80107b77:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b80:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b87:	83 ca 40             	or     $0x40,%edx
80107b8a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b93:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b9a:	83 ca 80             	or     $0xffffff80,%edx
80107b9d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba6:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb0:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107bb7:	ff ff 
80107bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bbc:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107bc3:	00 00 
80107bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc8:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107bd9:	83 e2 f0             	and    $0xfffffff0,%edx
80107bdc:	83 ca 0a             	or     $0xa,%edx
80107bdf:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be8:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107bef:	83 ca 10             	or     $0x10,%edx
80107bf2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bfb:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107c02:	83 ca 60             	or     $0x60,%edx
80107c05:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c0e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107c15:	83 ca 80             	or     $0xffffff80,%edx
80107c18:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c21:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c28:	83 ca 0f             	or     $0xf,%edx
80107c2b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c34:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c3b:	83 e2 ef             	and    $0xffffffef,%edx
80107c3e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c47:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c4e:	83 e2 df             	and    $0xffffffdf,%edx
80107c51:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c61:	83 ca 40             	or     $0x40,%edx
80107c64:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c74:	83 ca 80             	or     $0xffffff80,%edx
80107c77:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c80:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8a:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107c91:	ff ff 
80107c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c96:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107c9d:	00 00 
80107c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca2:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cac:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cb3:	83 e2 f0             	and    $0xfffffff0,%edx
80107cb6:	83 ca 02             	or     $0x2,%edx
80107cb9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc2:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cc9:	83 ca 10             	or     $0x10,%edx
80107ccc:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cdc:	83 ca 60             	or     $0x60,%edx
80107cdf:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cef:	83 ca 80             	or     $0xffffff80,%edx
80107cf2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cfb:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d02:	83 ca 0f             	or     $0xf,%edx
80107d05:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d15:	83 e2 ef             	and    $0xffffffef,%edx
80107d18:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d21:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d28:	83 e2 df             	and    $0xffffffdf,%edx
80107d2b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d34:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d3b:	83 ca 40             	or     $0x40,%edx
80107d3e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d47:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d4e:	83 ca 80             	or     $0xffffff80,%edx
80107d51:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d64:	05 b4 00 00 00       	add    $0xb4,%eax
80107d69:	89 c3                	mov    %eax,%ebx
80107d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6e:	05 b4 00 00 00       	add    $0xb4,%eax
80107d73:	c1 e8 10             	shr    $0x10,%eax
80107d76:	89 c1                	mov    %eax,%ecx
80107d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7b:	05 b4 00 00 00       	add    $0xb4,%eax
80107d80:	c1 e8 18             	shr    $0x18,%eax
80107d83:	89 c2                	mov    %eax,%edx
80107d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d88:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107d8f:	00 00 
80107d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d94:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9e:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da7:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107dae:	83 e1 f0             	and    $0xfffffff0,%ecx
80107db1:	83 c9 02             	or     $0x2,%ecx
80107db4:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dbd:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107dc4:	83 c9 10             	or     $0x10,%ecx
80107dc7:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd0:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107dd7:	83 e1 9f             	and    $0xffffff9f,%ecx
80107dda:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de3:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107dea:	83 c9 80             	or     $0xffffff80,%ecx
80107ded:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df6:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107dfd:	83 e1 f0             	and    $0xfffffff0,%ecx
80107e00:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e09:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107e10:	83 e1 ef             	and    $0xffffffef,%ecx
80107e13:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1c:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107e23:	83 e1 df             	and    $0xffffffdf,%ecx
80107e26:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e2f:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107e36:	83 c9 40             	or     $0x40,%ecx
80107e39:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e42:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107e49:	83 c9 80             	or     $0xffffff80,%ecx
80107e4c:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e55:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5e:	83 c0 70             	add    $0x70,%eax
80107e61:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107e68:	00 
80107e69:	89 04 24             	mov    %eax,(%esp)
80107e6c:	e8 37 fb ff ff       	call   801079a8 <lgdt>
  loadgs(SEG_KCPU << 3);
80107e71:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107e78:	e8 6a fb ff ff       	call   801079e7 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e80:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107e86:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107e8d:	00 00 00 00 
}
80107e91:	83 c4 24             	add    $0x24,%esp
80107e94:	5b                   	pop    %ebx
80107e95:	5d                   	pop    %ebp
80107e96:	c3                   	ret    

80107e97 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107e97:	55                   	push   %ebp
80107e98:	89 e5                	mov    %esp,%ebp
80107e9a:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ea0:	c1 e8 16             	shr    $0x16,%eax
80107ea3:	c1 e0 02             	shl    $0x2,%eax
80107ea6:	03 45 08             	add    0x8(%ebp),%eax
80107ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107eaf:	8b 00                	mov    (%eax),%eax
80107eb1:	83 e0 01             	and    $0x1,%eax
80107eb4:	84 c0                	test   %al,%al
80107eb6:	74 17                	je     80107ecf <walkpgdir+0x38>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ebb:	8b 00                	mov    (%eax),%eax
80107ebd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ec2:	89 04 24             	mov    %eax,(%esp)
80107ec5:	e8 4a fb ff ff       	call   80107a14 <p2v>
80107eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ecd:	eb 4b                	jmp    80107f1a <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107ed3:	74 0e                	je     80107ee3 <walkpgdir+0x4c>
80107ed5:	e8 30 ac ff ff       	call   80102b0a <kalloc>
80107eda:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107edd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ee1:	75 07                	jne    80107eea <walkpgdir+0x53>
      return 0;
80107ee3:	b8 00 00 00 00       	mov    $0x0,%eax
80107ee8:	eb 41                	jmp    80107f2b <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107eea:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ef1:	00 
80107ef2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ef9:	00 
80107efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efd:	89 04 24             	mov    %eax,(%esp)
80107f00:	e8 cd d4 ff ff       	call   801053d2 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f08:	89 04 24             	mov    %eax,(%esp)
80107f0b:	e8 f7 fa ff ff       	call   80107a07 <v2p>
80107f10:	89 c2                	mov    %eax,%edx
80107f12:	83 ca 07             	or     $0x7,%edx
80107f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f18:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f1d:	c1 e8 0c             	shr    $0xc,%eax
80107f20:	25 ff 03 00 00       	and    $0x3ff,%eax
80107f25:	c1 e0 02             	shl    $0x2,%eax
80107f28:	03 45 f4             	add    -0xc(%ebp),%eax
}
80107f2b:	c9                   	leave  
80107f2c:	c3                   	ret    

80107f2d <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107f2d:	55                   	push   %ebp
80107f2e:	89 e5                	mov    %esp,%ebp
80107f30:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107f33:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f41:	03 45 10             	add    0x10(%ebp),%eax
80107f44:	83 e8 01             	sub    $0x1,%eax
80107f47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107f4f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107f56:	00 
80107f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f5e:	8b 45 08             	mov    0x8(%ebp),%eax
80107f61:	89 04 24             	mov    %eax,(%esp)
80107f64:	e8 2e ff ff ff       	call   80107e97 <walkpgdir>
80107f69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107f6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107f70:	75 07                	jne    80107f79 <mappages+0x4c>
      return -1;
80107f72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f77:	eb 46                	jmp    80107fbf <mappages+0x92>
    if(*pte & PTE_P)
80107f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7c:	8b 00                	mov    (%eax),%eax
80107f7e:	83 e0 01             	and    $0x1,%eax
80107f81:	84 c0                	test   %al,%al
80107f83:	74 0c                	je     80107f91 <mappages+0x64>
      panic("remap");
80107f85:	c7 04 24 20 8e 10 80 	movl   $0x80108e20,(%esp)
80107f8c:	e8 a9 85 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80107f91:	8b 45 18             	mov    0x18(%ebp),%eax
80107f94:	0b 45 14             	or     0x14(%ebp),%eax
80107f97:	89 c2                	mov    %eax,%edx
80107f99:	83 ca 01             	or     $0x1,%edx
80107f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9f:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fa4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107fa7:	74 10                	je     80107fb9 <mappages+0x8c>
      break;
    a += PGSIZE;
80107fa9:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
    pa += PGSIZE;
80107fb0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107fb7:	eb 96                	jmp    80107f4f <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107fb9:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107fba:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fbf:	c9                   	leave  
80107fc0:	c3                   	ret    

80107fc1 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107fc1:	55                   	push   %ebp
80107fc2:	89 e5                	mov    %esp,%ebp
80107fc4:	53                   	push   %ebx
80107fc5:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107fc8:	e8 3d ab ff ff       	call   80102b0a <kalloc>
80107fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107fd4:	75 0a                	jne    80107fe0 <setupkvm+0x1f>
    return 0;
80107fd6:	b8 00 00 00 00       	mov    $0x0,%eax
80107fdb:	e9 99 00 00 00       	jmp    80108079 <setupkvm+0xb8>
  memset(pgdir, 0, PGSIZE);
80107fe0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107fe7:	00 
80107fe8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107fef:	00 
80107ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ff3:	89 04 24             	mov    %eax,(%esp)
80107ff6:	e8 d7 d3 ff ff       	call   801053d2 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107ffb:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80108002:	e8 0d fa ff ff       	call   80107a14 <p2v>
80108007:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010800c:	76 0c                	jbe    8010801a <setupkvm+0x59>
    panic("PHYSTOP too high");
8010800e:	c7 04 24 26 8e 10 80 	movl   $0x80108e26,(%esp)
80108015:	e8 20 85 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010801a:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80108021:	eb 49                	jmp    8010806c <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108026:	8b 48 0c             	mov    0xc(%eax),%ecx
80108029:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802c:	8b 50 04             	mov    0x4(%eax),%edx
8010802f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108032:	8b 58 08             	mov    0x8(%eax),%ebx
80108035:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108038:	8b 40 04             	mov    0x4(%eax),%eax
8010803b:	29 c3                	sub    %eax,%ebx
8010803d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108040:	8b 00                	mov    (%eax),%eax
80108042:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80108046:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010804a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010804e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108052:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108055:	89 04 24             	mov    %eax,(%esp)
80108058:	e8 d0 fe ff ff       	call   80107f2d <mappages>
8010805d:	85 c0                	test   %eax,%eax
8010805f:	79 07                	jns    80108068 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108061:	b8 00 00 00 00       	mov    $0x0,%eax
80108066:	eb 11                	jmp    80108079 <setupkvm+0xb8>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108068:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010806c:	b8 00 b5 10 80       	mov    $0x8010b500,%eax
80108071:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80108074:	72 ad                	jb     80108023 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108076:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108079:	83 c4 34             	add    $0x34,%esp
8010807c:	5b                   	pop    %ebx
8010807d:	5d                   	pop    %ebp
8010807e:	c3                   	ret    

8010807f <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010807f:	55                   	push   %ebp
80108080:	89 e5                	mov    %esp,%ebp
80108082:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108085:	e8 37 ff ff ff       	call   80107fc1 <setupkvm>
8010808a:	a3 58 2a 11 80       	mov    %eax,0x80112a58
  switchkvm();
8010808f:	e8 02 00 00 00       	call   80108096 <switchkvm>
}
80108094:	c9                   	leave  
80108095:	c3                   	ret    

80108096 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108096:	55                   	push   %ebp
80108097:	89 e5                	mov    %esp,%ebp
80108099:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010809c:	a1 58 2a 11 80       	mov    0x80112a58,%eax
801080a1:	89 04 24             	mov    %eax,(%esp)
801080a4:	e8 5e f9 ff ff       	call   80107a07 <v2p>
801080a9:	89 04 24             	mov    %eax,(%esp)
801080ac:	e8 4b f9 ff ff       	call   801079fc <lcr3>
}
801080b1:	c9                   	leave  
801080b2:	c3                   	ret    

801080b3 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801080b3:	55                   	push   %ebp
801080b4:	89 e5                	mov    %esp,%ebp
801080b6:	53                   	push   %ebx
801080b7:	83 ec 14             	sub    $0x14,%esp
  pushcli();
801080ba:	e8 0d d2 ff ff       	call   801052cc <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801080bf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801080c5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801080cc:	83 c2 08             	add    $0x8,%edx
801080cf:	89 d3                	mov    %edx,%ebx
801080d1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801080d8:	83 c2 08             	add    $0x8,%edx
801080db:	c1 ea 10             	shr    $0x10,%edx
801080de:	89 d1                	mov    %edx,%ecx
801080e0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801080e7:	83 c2 08             	add    $0x8,%edx
801080ea:	c1 ea 18             	shr    $0x18,%edx
801080ed:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801080f4:	67 00 
801080f6:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
801080fd:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80108103:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010810a:	83 e1 f0             	and    $0xfffffff0,%ecx
8010810d:	83 c9 09             	or     $0x9,%ecx
80108110:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108116:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010811d:	83 c9 10             	or     $0x10,%ecx
80108120:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108126:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010812d:	83 e1 9f             	and    $0xffffff9f,%ecx
80108130:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108136:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010813d:	83 c9 80             	or     $0xffffff80,%ecx
80108140:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108146:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010814d:	83 e1 f0             	and    $0xfffffff0,%ecx
80108150:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108156:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010815d:	83 e1 ef             	and    $0xffffffef,%ecx
80108160:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108166:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010816d:	83 e1 df             	and    $0xffffffdf,%ecx
80108170:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108176:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010817d:	83 c9 40             	or     $0x40,%ecx
80108180:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108186:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010818d:	83 e1 7f             	and    $0x7f,%ecx
80108190:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108196:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010819c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081a2:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801081a9:	83 e2 ef             	and    $0xffffffef,%edx
801081ac:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801081b2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081b8:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801081be:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081c4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801081cb:	8b 52 08             	mov    0x8(%edx),%edx
801081ce:	81 c2 00 10 00 00    	add    $0x1000,%edx
801081d4:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801081d7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801081de:	e8 ee f7 ff ff       	call   801079d1 <ltr>
  if(p->pgdir == 0)
801081e3:	8b 45 08             	mov    0x8(%ebp),%eax
801081e6:	8b 40 04             	mov    0x4(%eax),%eax
801081e9:	85 c0                	test   %eax,%eax
801081eb:	75 0c                	jne    801081f9 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
801081ed:	c7 04 24 37 8e 10 80 	movl   $0x80108e37,(%esp)
801081f4:	e8 41 83 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801081f9:	8b 45 08             	mov    0x8(%ebp),%eax
801081fc:	8b 40 04             	mov    0x4(%eax),%eax
801081ff:	89 04 24             	mov    %eax,(%esp)
80108202:	e8 00 f8 ff ff       	call   80107a07 <v2p>
80108207:	89 04 24             	mov    %eax,(%esp)
8010820a:	e8 ed f7 ff ff       	call   801079fc <lcr3>
  popcli();
8010820f:	e8 00 d1 ff ff       	call   80105314 <popcli>
}
80108214:	83 c4 14             	add    $0x14,%esp
80108217:	5b                   	pop    %ebx
80108218:	5d                   	pop    %ebp
80108219:	c3                   	ret    

8010821a <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010821a:	55                   	push   %ebp
8010821b:	89 e5                	mov    %esp,%ebp
8010821d:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108220:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108227:	76 0c                	jbe    80108235 <inituvm+0x1b>
    panic("inituvm: more than a page");
80108229:	c7 04 24 4b 8e 10 80 	movl   $0x80108e4b,(%esp)
80108230:	e8 05 83 ff ff       	call   8010053a <panic>
  mem = kalloc();
80108235:	e8 d0 a8 ff ff       	call   80102b0a <kalloc>
8010823a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010823d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108244:	00 
80108245:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010824c:	00 
8010824d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108250:	89 04 24             	mov    %eax,(%esp)
80108253:	e8 7a d1 ff ff       	call   801053d2 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108258:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825b:	89 04 24             	mov    %eax,(%esp)
8010825e:	e8 a4 f7 ff ff       	call   80107a07 <v2p>
80108263:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010826a:	00 
8010826b:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010826f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108276:	00 
80108277:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010827e:	00 
8010827f:	8b 45 08             	mov    0x8(%ebp),%eax
80108282:	89 04 24             	mov    %eax,(%esp)
80108285:	e8 a3 fc ff ff       	call   80107f2d <mappages>
  memmove(mem, init, sz);
8010828a:	8b 45 10             	mov    0x10(%ebp),%eax
8010828d:	89 44 24 08          	mov    %eax,0x8(%esp)
80108291:	8b 45 0c             	mov    0xc(%ebp),%eax
80108294:	89 44 24 04          	mov    %eax,0x4(%esp)
80108298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010829b:	89 04 24             	mov    %eax,(%esp)
8010829e:	e8 02 d2 ff ff       	call   801054a5 <memmove>
}
801082a3:	c9                   	leave  
801082a4:	c3                   	ret    

801082a5 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801082a5:	55                   	push   %ebp
801082a6:	89 e5                	mov    %esp,%ebp
801082a8:	53                   	push   %ebx
801082a9:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801082ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801082af:	25 ff 0f 00 00       	and    $0xfff,%eax
801082b4:	85 c0                	test   %eax,%eax
801082b6:	74 0c                	je     801082c4 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801082b8:	c7 04 24 68 8e 10 80 	movl   $0x80108e68,(%esp)
801082bf:	e8 76 82 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
801082c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
801082cb:	e9 ae 00 00 00       	jmp    8010837e <loaduvm+0xd9>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801082d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801082d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801082d6:	8d 04 02             	lea    (%edx,%eax,1),%eax
801082d9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801082e0:	00 
801082e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801082e5:	8b 45 08             	mov    0x8(%ebp),%eax
801082e8:	89 04 24             	mov    %eax,(%esp)
801082eb:	e8 a7 fb ff ff       	call   80107e97 <walkpgdir>
801082f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801082f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801082f7:	75 0c                	jne    80108305 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801082f9:	c7 04 24 8b 8e 10 80 	movl   $0x80108e8b,(%esp)
80108300:	e8 35 82 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108308:	8b 00                	mov    (%eax),%eax
8010830a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010830f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(sz - i < PGSIZE)
80108312:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108315:	8b 55 18             	mov    0x18(%ebp),%edx
80108318:	89 d1                	mov    %edx,%ecx
8010831a:	29 c1                	sub    %eax,%ecx
8010831c:	89 c8                	mov    %ecx,%eax
8010831e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108323:	77 11                	ja     80108336 <loaduvm+0x91>
      n = sz - i;
80108325:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108328:	8b 55 18             	mov    0x18(%ebp),%edx
8010832b:	89 d1                	mov    %edx,%ecx
8010832d:	29 c1                	sub    %eax,%ecx
8010832f:	89 c8                	mov    %ecx,%eax
80108331:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108334:	eb 07                	jmp    8010833d <loaduvm+0x98>
    else
      n = PGSIZE;
80108336:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010833d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108340:	8b 55 14             	mov    0x14(%ebp),%edx
80108343:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108346:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108349:	89 04 24             	mov    %eax,(%esp)
8010834c:	e8 c3 f6 ff ff       	call   80107a14 <p2v>
80108351:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108354:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108358:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010835c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108360:	8b 45 10             	mov    0x10(%ebp),%eax
80108363:	89 04 24             	mov    %eax,(%esp)
80108366:	e8 09 9a ff ff       	call   80101d74 <readi>
8010836b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010836e:	74 07                	je     80108377 <loaduvm+0xd2>
      return -1;
80108370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108375:	eb 18                	jmp    8010838f <loaduvm+0xea>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108377:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
8010837e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108381:	3b 45 18             	cmp    0x18(%ebp),%eax
80108384:	0f 82 46 ff ff ff    	jb     801082d0 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010838a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010838f:	83 c4 24             	add    $0x24,%esp
80108392:	5b                   	pop    %ebx
80108393:	5d                   	pop    %ebp
80108394:	c3                   	ret    

80108395 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108395:	55                   	push   %ebp
80108396:	89 e5                	mov    %esp,%ebp
80108398:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010839b:	8b 45 10             	mov    0x10(%ebp),%eax
8010839e:	85 c0                	test   %eax,%eax
801083a0:	79 0a                	jns    801083ac <allocuvm+0x17>
    return 0;
801083a2:	b8 00 00 00 00       	mov    $0x0,%eax
801083a7:	e9 c1 00 00 00       	jmp    8010846d <allocuvm+0xd8>
  if(newsz < oldsz)
801083ac:	8b 45 10             	mov    0x10(%ebp),%eax
801083af:	3b 45 0c             	cmp    0xc(%ebp),%eax
801083b2:	73 08                	jae    801083bc <allocuvm+0x27>
    return oldsz;
801083b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801083b7:	e9 b1 00 00 00       	jmp    8010846d <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
801083bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801083bf:	05 ff 0f 00 00       	add    $0xfff,%eax
801083c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801083cc:	e9 8d 00 00 00       	jmp    8010845e <allocuvm+0xc9>
    mem = kalloc();
801083d1:	e8 34 a7 ff ff       	call   80102b0a <kalloc>
801083d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801083d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801083dd:	75 2c                	jne    8010840b <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801083df:	c7 04 24 a9 8e 10 80 	movl   $0x80108ea9,(%esp)
801083e6:	e8 af 7f ff ff       	call   8010039a <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801083eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801083ee:	89 44 24 08          	mov    %eax,0x8(%esp)
801083f2:	8b 45 10             	mov    0x10(%ebp),%eax
801083f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801083f9:	8b 45 08             	mov    0x8(%ebp),%eax
801083fc:	89 04 24             	mov    %eax,(%esp)
801083ff:	e8 6b 00 00 00       	call   8010846f <deallocuvm>
      return 0;
80108404:	b8 00 00 00 00       	mov    $0x0,%eax
80108409:	eb 62                	jmp    8010846d <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
8010840b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108412:	00 
80108413:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010841a:	00 
8010841b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010841e:	89 04 24             	mov    %eax,(%esp)
80108421:	e8 ac cf ff ff       	call   801053d2 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108426:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108429:	89 04 24             	mov    %eax,(%esp)
8010842c:	e8 d6 f5 ff ff       	call   80107a07 <v2p>
80108431:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108434:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010843b:	00 
8010843c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108440:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108447:	00 
80108448:	89 54 24 04          	mov    %edx,0x4(%esp)
8010844c:	8b 45 08             	mov    0x8(%ebp),%eax
8010844f:	89 04 24             	mov    %eax,(%esp)
80108452:	e8 d6 fa ff ff       	call   80107f2d <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108457:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010845e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108461:	3b 45 10             	cmp    0x10(%ebp),%eax
80108464:	0f 82 67 ff ff ff    	jb     801083d1 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010846a:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010846d:	c9                   	leave  
8010846e:	c3                   	ret    

8010846f <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010846f:	55                   	push   %ebp
80108470:	89 e5                	mov    %esp,%ebp
80108472:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108475:	8b 45 10             	mov    0x10(%ebp),%eax
80108478:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010847b:	72 08                	jb     80108485 <deallocuvm+0x16>
    return oldsz;
8010847d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108480:	e9 a4 00 00 00       	jmp    80108529 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80108485:	8b 45 10             	mov    0x10(%ebp),%eax
80108488:	05 ff 0f 00 00       	add    $0xfff,%eax
8010848d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108492:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108495:	e9 80 00 00 00       	jmp    8010851a <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010849a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010849d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801084a4:	00 
801084a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801084a9:	8b 45 08             	mov    0x8(%ebp),%eax
801084ac:	89 04 24             	mov    %eax,(%esp)
801084af:	e8 e3 f9 ff ff       	call   80107e97 <walkpgdir>
801084b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(!pte)
801084b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801084bb:	75 09                	jne    801084c6 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
801084bd:	81 45 ec 00 f0 3f 00 	addl   $0x3ff000,-0x14(%ebp)
801084c4:	eb 4d                	jmp    80108513 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
801084c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801084c9:	8b 00                	mov    (%eax),%eax
801084cb:	83 e0 01             	and    $0x1,%eax
801084ce:	84 c0                	test   %al,%al
801084d0:	74 41                	je     80108513 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801084d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801084d5:	8b 00                	mov    (%eax),%eax
801084d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(pa == 0)
801084df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084e3:	75 0c                	jne    801084f1 <deallocuvm+0x82>
        panic("kfree");
801084e5:	c7 04 24 c1 8e 10 80 	movl   $0x80108ec1,(%esp)
801084ec:	e8 49 80 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
801084f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084f4:	89 04 24             	mov    %eax,(%esp)
801084f7:	e8 18 f5 ff ff       	call   80107a14 <p2v>
801084fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
801084ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108502:	89 04 24             	mov    %eax,(%esp)
80108505:	e8 67 a5 ff ff       	call   80102a71 <kfree>
      *pte = 0;
8010850a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010850d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108513:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
8010851a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010851d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108520:	0f 82 74 ff ff ff    	jb     8010849a <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108526:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108529:	c9                   	leave  
8010852a:	c3                   	ret    

8010852b <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010852b:	55                   	push   %ebp
8010852c:	89 e5                	mov    %esp,%ebp
8010852e:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108531:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108535:	75 0c                	jne    80108543 <freevm+0x18>
    panic("freevm: no pgdir");
80108537:	c7 04 24 c7 8e 10 80 	movl   $0x80108ec7,(%esp)
8010853e:	e8 f7 7f ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108543:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010854a:	00 
8010854b:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108552:	80 
80108553:	8b 45 08             	mov    0x8(%ebp),%eax
80108556:	89 04 24             	mov    %eax,(%esp)
80108559:	e8 11 ff ff ff       	call   8010846f <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010855e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108565:	eb 3c                	jmp    801085a3 <freevm+0x78>
    if(pgdir[i] & PTE_P){
80108567:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010856a:	c1 e0 02             	shl    $0x2,%eax
8010856d:	03 45 08             	add    0x8(%ebp),%eax
80108570:	8b 00                	mov    (%eax),%eax
80108572:	83 e0 01             	and    $0x1,%eax
80108575:	84 c0                	test   %al,%al
80108577:	74 26                	je     8010859f <freevm+0x74>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108579:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010857c:	c1 e0 02             	shl    $0x2,%eax
8010857f:	03 45 08             	add    0x8(%ebp),%eax
80108582:	8b 00                	mov    (%eax),%eax
80108584:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108589:	89 04 24             	mov    %eax,(%esp)
8010858c:	e8 83 f4 ff ff       	call   80107a14 <p2v>
80108591:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
80108594:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108597:	89 04 24             	mov    %eax,(%esp)
8010859a:	e8 d2 a4 ff ff       	call   80102a71 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010859f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801085a3:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
801085aa:	76 bb                	jbe    80108567 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801085ac:	8b 45 08             	mov    0x8(%ebp),%eax
801085af:	89 04 24             	mov    %eax,(%esp)
801085b2:	e8 ba a4 ff ff       	call   80102a71 <kfree>
}
801085b7:	c9                   	leave  
801085b8:	c3                   	ret    

801085b9 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801085b9:	55                   	push   %ebp
801085ba:	89 e5                	mov    %esp,%ebp
801085bc:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801085bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801085c6:	00 
801085c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801085ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801085ce:	8b 45 08             	mov    0x8(%ebp),%eax
801085d1:	89 04 24             	mov    %eax,(%esp)
801085d4:	e8 be f8 ff ff       	call   80107e97 <walkpgdir>
801085d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801085dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801085e0:	75 0c                	jne    801085ee <clearpteu+0x35>
    panic("clearpteu");
801085e2:	c7 04 24 d8 8e 10 80 	movl   $0x80108ed8,(%esp)
801085e9:	e8 4c 7f ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
801085ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f1:	8b 00                	mov    (%eax),%eax
801085f3:	89 c2                	mov    %eax,%edx
801085f5:	83 e2 fb             	and    $0xfffffffb,%edx
801085f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085fb:	89 10                	mov    %edx,(%eax)
}
801085fd:	c9                   	leave  
801085fe:	c3                   	ret    

801085ff <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801085ff:	55                   	push   %ebp
80108600:	89 e5                	mov    %esp,%ebp
80108602:	53                   	push   %ebx
80108603:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108606:	e8 b6 f9 ff ff       	call   80107fc1 <setupkvm>
8010860b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010860e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108612:	75 0a                	jne    8010861e <copyuvm+0x1f>
    return 0;
80108614:	b8 00 00 00 00       	mov    $0x0,%eax
80108619:	e9 fd 00 00 00       	jmp    8010871b <copyuvm+0x11c>
  for(i = PGSIZE; i < sz; i += PGSIZE){
8010861e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
80108625:	e9 cc 00 00 00       	jmp    801086f6 <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010862a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010862d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108634:	00 
80108635:	89 44 24 04          	mov    %eax,0x4(%esp)
80108639:	8b 45 08             	mov    0x8(%ebp),%eax
8010863c:	89 04 24             	mov    %eax,(%esp)
8010863f:	e8 53 f8 ff ff       	call   80107e97 <walkpgdir>
80108644:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108647:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010864b:	75 0c                	jne    80108659 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
8010864d:	c7 04 24 e2 8e 10 80 	movl   $0x80108ee2,(%esp)
80108654:	e8 e1 7e ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80108659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010865c:	8b 00                	mov    (%eax),%eax
8010865e:	83 e0 01             	and    $0x1,%eax
80108661:	85 c0                	test   %eax,%eax
80108663:	75 0c                	jne    80108671 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108665:	c7 04 24 fc 8e 10 80 	movl   $0x80108efc,(%esp)
8010866c:	e8 c9 7e ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108674:	8b 00                	mov    (%eax),%eax
80108676:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010867b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010867e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108681:	8b 00                	mov    (%eax),%eax
80108683:	25 ff 0f 00 00       	and    $0xfff,%eax
80108688:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mem = kalloc()) == 0)
8010868b:	e8 7a a4 ff ff       	call   80102b0a <kalloc>
80108690:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108693:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108697:	74 6e                	je     80108707 <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108699:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010869c:	89 04 24             	mov    %eax,(%esp)
8010869f:	e8 70 f3 ff ff       	call   80107a14 <p2v>
801086a4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801086ab:	00 
801086ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801086b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086b3:	89 04 24             	mov    %eax,(%esp)
801086b6:	e8 ea cd ff ff       	call   801054a5 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801086bb:	8b 5d f0             	mov    -0x10(%ebp),%ebx
801086be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086c1:	89 04 24             	mov    %eax,(%esp)
801086c4:	e8 3e f3 ff ff       	call   80107a07 <v2p>
801086c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801086cc:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801086d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
801086d4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801086db:	00 
801086dc:	89 54 24 04          	mov    %edx,0x4(%esp)
801086e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801086e3:	89 04 24             	mov    %eax,(%esp)
801086e6:	e8 42 f8 ff ff       	call   80107f2d <mappages>
801086eb:	85 c0                	test   %eax,%eax
801086ed:	78 1b                	js     8010870a <copyuvm+0x10b>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = PGSIZE; i < sz; i += PGSIZE){
801086ef:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
801086f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086f9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086fc:	0f 82 28 ff ff ff    	jb     8010862a <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108702:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108705:	eb 14                	jmp    8010871b <copyuvm+0x11c>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108707:	90                   	nop
80108708:	eb 01                	jmp    8010870b <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010870a:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010870b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010870e:	89 04 24             	mov    %eax,(%esp)
80108711:	e8 15 fe ff ff       	call   8010852b <freevm>
  return 0;
80108716:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010871b:	83 c4 44             	add    $0x44,%esp
8010871e:	5b                   	pop    %ebx
8010871f:	5d                   	pop    %ebp
80108720:	c3                   	ret    

80108721 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108721:	55                   	push   %ebp
80108722:	89 e5                	mov    %esp,%ebp
80108724:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108727:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010872e:	00 
8010872f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108732:	89 44 24 04          	mov    %eax,0x4(%esp)
80108736:	8b 45 08             	mov    0x8(%ebp),%eax
80108739:	89 04 24             	mov    %eax,(%esp)
8010873c:	e8 56 f7 ff ff       	call   80107e97 <walkpgdir>
80108741:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108744:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108747:	8b 00                	mov    (%eax),%eax
80108749:	83 e0 01             	and    $0x1,%eax
8010874c:	85 c0                	test   %eax,%eax
8010874e:	75 07                	jne    80108757 <uva2ka+0x36>
    return 0;
80108750:	b8 00 00 00 00       	mov    $0x0,%eax
80108755:	eb 25                	jmp    8010877c <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010875a:	8b 00                	mov    (%eax),%eax
8010875c:	83 e0 04             	and    $0x4,%eax
8010875f:	85 c0                	test   %eax,%eax
80108761:	75 07                	jne    8010876a <uva2ka+0x49>
    return 0;
80108763:	b8 00 00 00 00       	mov    $0x0,%eax
80108768:	eb 12                	jmp    8010877c <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
8010876a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010876d:	8b 00                	mov    (%eax),%eax
8010876f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108774:	89 04 24             	mov    %eax,(%esp)
80108777:	e8 98 f2 ff ff       	call   80107a14 <p2v>
}
8010877c:	c9                   	leave  
8010877d:	c3                   	ret    

8010877e <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010877e:	55                   	push   %ebp
8010877f:	89 e5                	mov    %esp,%ebp
80108781:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108784:	8b 45 10             	mov    0x10(%ebp),%eax
80108787:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(len > 0){
8010878a:	e9 8b 00 00 00       	jmp    8010881a <copyout+0x9c>
    va0 = (uint)PGROUNDDOWN(va);
8010878f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108792:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108797:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010879a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010879d:	89 44 24 04          	mov    %eax,0x4(%esp)
801087a1:	8b 45 08             	mov    0x8(%ebp),%eax
801087a4:	89 04 24             	mov    %eax,(%esp)
801087a7:	e8 75 ff ff ff       	call   80108721 <uva2ka>
801087ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pa0 == 0)
801087af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087b3:	75 07                	jne    801087bc <copyout+0x3e>
      return -1;
801087b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087ba:	eb 6d                	jmp    80108829 <copyout+0xab>
    n = PGSIZE - (va - va0);
801087bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801087bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801087c2:	89 d1                	mov    %edx,%ecx
801087c4:	29 c1                	sub    %eax,%ecx
801087c6:	89 c8                	mov    %ecx,%eax
801087c8:	05 00 10 00 00       	add    $0x1000,%eax
801087cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801087d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087d3:	3b 45 14             	cmp    0x14(%ebp),%eax
801087d6:	76 06                	jbe    801087de <copyout+0x60>
      n = len;
801087d8:	8b 45 14             	mov    0x14(%ebp),%eax
801087db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801087de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e1:	8b 55 0c             	mov    0xc(%ebp),%edx
801087e4:	89 d1                	mov    %edx,%ecx
801087e6:	29 c1                	sub    %eax,%ecx
801087e8:	89 c8                	mov    %ecx,%eax
801087ea:	03 45 ec             	add    -0x14(%ebp),%eax
801087ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
801087f0:	89 54 24 08          	mov    %edx,0x8(%esp)
801087f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801087f7:	89 54 24 04          	mov    %edx,0x4(%esp)
801087fb:	89 04 24             	mov    %eax,(%esp)
801087fe:	e8 a2 cc ff ff       	call   801054a5 <memmove>
    len -= n;
80108803:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108806:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108809:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010880c:	01 45 e8             	add    %eax,-0x18(%ebp)
    va = va0 + PGSIZE;
8010880f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108812:	05 00 10 00 00       	add    $0x1000,%eax
80108817:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010881a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010881e:	0f 85 6b ff ff ff    	jne    8010878f <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108824:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108829:	c9                   	leave  
8010882a:	c3                   	ret    
