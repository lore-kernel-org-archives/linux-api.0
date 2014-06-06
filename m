From: "Maciej W. Rozycki" <macro-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Fri, 6 Jun 2014 10:02:42 +0100 (BST)
Message-ID: <alpine.LFD.2.11.1406060457410.18344@eddie.linux-mips.org>
References: <20140509191914.GA7286@jtriplet-mobl1> <20140510070742.GE6099@debjann.fritz.box> <20140510193246.GA12079@thin> <20140511125006.GA16197@debjann.fritz.box> <20140511210514.GB6056@thin> <alpine.LFD.2.11.1406011101400.30121@eddie.linux-mips.org>
 <538FA4C7.2050206@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <538FA4C7.2050206-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 4 Jun 2014, H. Peter Anvin wrote:

> > Also IIRC PCI-PCI bridges only forward port I/O space accesses 
> > within the low 64kB.
> 
> Not true.

 It must have been an implementation-specific constraint then (e.g. 
DECchip 21050), it's been a while since I looked into it.  Thanks for 
straightening me out.

  Maciej
