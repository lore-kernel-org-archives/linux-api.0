From: "Maciej W. Rozycki" <macro-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Sun, 1 Jun 2014 11:35:10 +0100 (BST)
Message-ID: <alpine.LFD.2.11.1406011101400.30121@eddie.linux-mips.org>
References: <20140509191914.GA7286@jtriplet-mobl1> <20140510070742.GE6099@debjann.fritz.box> <20140510193246.GA12079@thin> <20140511125006.GA16197@debjann.fritz.box> <20140511210514.GB6056@thin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140511210514.GB6056@thin>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, 11 May 2014, Josh Triplett wrote:

> > > > What if I attempt a four-byte read at 65535? That would access four
> > > > out-of-bounds bytes, right?
> > > 
> > > No, it would do an ind instruction on port 65535.
> > 
> > Yes, on x86. What about other architectures?
> 
> That's a good point; on architectures that map I/O to memory, this
> device should check port+count rather than port.  Is there a reliable
> #define that identifies architectures with that property, other than
> CONFIG_X86?

 FWIW, on x86 an IND from 65535 will be split into two separate bus read 
cycles, e.g. on a 32-bit data bus one at 0xfffc with only the MSB enabled 
and another one with the three LSB enabled (64-bit buses will address the 
first cycle at 0xfff8, etc.).  Data obtained from these cycles is then 
merged appropriately before writing to the destination.  The address put 
on the bus for the second cycle is implementation-specific as are all 
accesses beyond 0xffff so it might be 0x10000 or it might be 0.

 If implementing unaligned port I/O on non-x86 targets I think it would be 
most reasonable to wrap the out-of-range part around back to 0 before 
merging data obtained this way.  The range supported can of course be 
different to what x86 supports and may be specific e.g. to the PCI host 
bridge (its port I/O space forwarding window size).  Systems with peer 
bridges may have multiple port I/O spaces too, this is one reason to have 
the size of the port I/O space extended beyond 64kB; address bits from #16 
up can then be used to select the intended host bridge to forward the 
access to.  Also IIRC PCI-PCI bridges only forward port I/O space accesses 
within the low 64kB.

 Most easily unaligned port I/O may not be supported at all by our kernel 
device, even on x86.  I think it would actually be reasonable to do, I 
have yet to hear of a piece of hardware that has any use for unaligned 
port I/O.

  Maciej
