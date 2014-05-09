From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit and 32-bit ports
Date: Fri, 09 May 2014 23:12:51 +0200
Message-ID: <4366326.1D6xUnlac7@wuerfel>
References: <20140509191914.GA7286@jtriplet-mobl1> <9233735.5FfZoZovqP@wuerfel> <536D406D.2080508@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <536D406D.2080508@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Friday 09 May 2014 13:54:05 H. Peter Anvin wrote:
> On 05/09/2014 12:58 PM, Arnd Bergmann wrote:
> > On Friday 09 May 2014 12:19:16 Josh Triplett wrote:
> > 
> >> +    if (!access_ok(VERIFY_WRITE, buf, count))
> >> +            return -EFAULT;
> >> +    if (port > 65535)
> >> +            return 0;
> > 
> > This should probably test against IO_SPACE_LIMIT, which may be zero,
> > something larger than 65536 or even ULONG_MAX, depending on the
> > architecture.
> > 
> > In cases where this IO_SPACE_LIMIT is zero or ULONG_MAX, we should
> > probably disallow access completely. The former case is for architectures
> > that don't have any I/O ports, the other is either a mistake, or is
> > used when inb is defined as readb, and the port numbers are just virtual
> > addresses.
> > 
> 
> PCI supports a 32-bit I/O address space, so if the architecture permits
> it, having a 32-bit I/O space is perfectly legitimate.

Right, but on all 32-bit architectures other than x86, the I/O ports
are mapped into physical memory addresses, which means you can't
map all of the I/O space into the CPU address space. On 64-bit
architectures you can, but then it's UINT_MAX, not ULONG_MAX.

There is also the theoretical case of machines mapping a window
of I/O addresses with portnumber==phys_addr as we normally do
for PCI memory space, but I haven't seen anyone actually do that.
Practically every PCI implementation (if they have I/O space at all)
maps a small number of ports (65536 or 1048576 mostly) starting at
port number zero to a fixed physical CPU address.

> It is worth noting that /dev/port has the same problem.

Right. We should fix that, too.

> However, if we're going to have these devices I'm wondering if having
> /dev/portw and /dev/portl (or something like that) might not make sense,
> rather than requiring a system call per transaction.

Actually the behavior of /dev/port for >1 byte writes seems questionable
already: There are very few devices on which writing to consecutive
port numbers makes sense. Normally you just want to write a series
of bytes (or 16/32 bit words) into the same port number instead,
as the outsb()/outsw()/outsl() functions do.

	Arnd
