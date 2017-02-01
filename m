From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] prctl: implement PR_GET_ENDIAN for all architectures
Date: Wed, 1 Feb 2017 14:03:22 -0800
Message-ID: <20170201140322.b469641861861caf8cf6da48@linux-foundation.org>
References: <20170128111310.GA13389@ls3530.fritz.box>
        <20170131162624.5a85ec47c6ee22e5cc03c4eb@linux-foundation.org>
        <7c60f97a-4b63-5eff-e837-186f9a31c5a2@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7c60f97a-4b63-5eff-e837-186f9a31c5a2-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 1 Feb 2017 20:47:06 +0100 Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org> wrote:

> Hi Andrew,
> 
> On 01.02.2017 01:26, Andrew Morton wrote:
> > On Sat, 28 Jan 2017 12:13:10 +0100 Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org> wrote:
> > 
> >> The prctl(PR_GET_ENDIAN) syscall was added to Kernel 2.6.18, but
> >> implemented for PowerPC only.
> >> This trivial patch adds support for this syscall for all other architectures.
> > 
> > Seems reasonable.  I guess.
> 
> Heck, I did forgot but I submitted a similar patch 8 years ago:
> http://www.serverphorums.com/read.php?12,51902
> 
> > Why is this needed?
> 
> It's not actually needed beside the trivial reason of providing an interface
> not just for one single architecture.
> 
> After reading the discussion from 2009 again, I'm fine if 
> you would simply drop the patch. The decision up to you.

Can't decide.  I guess that moving it into the kernel will, over time,
eliminate some irritating ifdefs from userspace code.

The implementation itself is a bit half-assed.  The put_user() in
arch/powerpc/kernel/process.c:get_endian() should be moved into
kernel/sys.c.  So the arch code only does the "what endianness am I"
function and common code copies that out to userspace.
