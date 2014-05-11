From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Sun, 11 May 2014 14:05:19 -0700
Message-ID: <20140511210514.GB6056@thin>
References: <20140509191914.GA7286@jtriplet-mobl1>
 <20140510070742.GE6099@debjann.fritz.box>
 <20140510193246.GA12079@thin>
 <20140511125006.GA16197@debjann.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140511125006.GA16197-7cfQGs147y6a6lf8Wg2v7Z5kstrrjoWp@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, May 11, 2014 at 02:50:06PM +0200, Jann Horn wrote:
> On Sat, May 10, 2014 at 12:32:46PM -0700, Josh Triplett wrote:
> > On Sat, May 10, 2014 at 09:07:42AM +0200, Jann Horn wrote:
> > > On Fri, May 09, 2014 at 12:19:16PM -0700, Josh Triplett wrote:
> > > > +	if (port > 65535)
> > > > +		return 0;
> > > > +	switch (count) {
> > > [...]
> > > > +	case 4:
> > > > +		if (__put_user(inl(port), buf) < 0)
> > > > +			return -EFAULT;
> > > 
> > > What if I attempt a four-byte read at 65535? That would access four
> > > out-of-bounds bytes, right?
> > 
> > No, it would do an ind instruction on port 65535.
> 
> Yes, on x86. What about other architectures?

That's a good point; on architectures that map I/O to memory, this
device should check port+count rather than port.  Is there a reliable
#define that identifies architectures with that property, other than
CONFIG_X86?

- Josh Triplett
