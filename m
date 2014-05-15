From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting
 16-bit and 32-bit ports
Date: Thu, 15 May 2014 14:56:46 -0700
Message-ID: <20140515215646.GA16326@cloud>
References: <20140509191914.GA7286@jtriplet-mobl1>
 <9233735.5FfZoZovqP@wuerfel>
 <536D406D.2080508@zytor.com>
 <4366326.1D6xUnlac7@wuerfel>
 <536D46AD.3070608@zytor.com>
 <20140509223837.GB5725@thin>
 <53729873.2030805@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53729873.2030805-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, May 13, 2014 at 03:10:59PM -0700, H. Peter Anvin wrote:
> On 05/09/2014 03:38 PM, Josh Triplett wrote:
> > On Fri, May 09, 2014 at 02:20:45PM -0700, H. Peter Anvin wrote:
> >> On 05/09/2014 02:12 PM, Arnd Bergmann wrote:
> >>>
> >>>> However, if we're going to have these devices I'm wondering if having
> >>>> /dev/portw and /dev/portl (or something like that) might not make sense,
> >>>> rather than requiring a system call per transaction.
> >>>
> >>> Actually the behavior of /dev/port for >1 byte writes seems questionable
> >>> already: There are very few devices on which writing to consecutive
> >>> port numbers makes sense. Normally you just want to write a series
> >>> of bytes (or 16/32 bit words) into the same port number instead,
> >>> as the outsb()/outsw()/outsl() functions do.
> >>>
> >>
> >> Indeed.  I missed the detail that it increments the port index; it is
> >> virtually guaranteed to be bogus.
> > 
> > Exactly.  It might make sense to have ioport8/ioport16/ioport32 devices
> > that accept arbitrary-length reads and writes (divisible by the size)
> > and do the equivalent of the string I/O instructions outs/ins, but for
> > the moment I'd like to add the single device that people always seem to
> > want and can't get from /dev/port.  If someone's doing enough writes
> > that doing a syscall per in/out instruction seems like too much
> > overhead, they can write a real device driver or use ioperm/iopl.
> 
> I really have a problem with the logic "our current interface is wrong,
> so let's introduce another wrong interface which solves a narrow use
> case".  In some ways it would actually be *better* to use an ioctl
> interface on /dev/port in that case...

ioport{8,16,32} seems preferable to an ioctl on /dev/port, but in any
case, I'd be happy to adapt this patch to whatever interface seems
preferable.  I just don't want to let the perfect be the enemy of the
good here; 16-bit and 32-bit port operations are currently completely
impossible via /dev/port, and I'm primarily interested in fixing that,
not necessarily in creating a completely generalized interface for doing
high-performance repeated I/O operations that ought to be in the kernel
anyway.

- Josh Triplett
