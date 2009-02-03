From: Russell King <rmk-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: + preadv-pwritev-add-preadv-and-pwritev-system-calls.patch added to -mm tree
Date: Tue, 3 Feb 2009 17:15:59 +0000
Message-ID: <20090203171559.GA20898@flint.arm.linux.org.uk>
References: <200902022135.n12LZa1a010673@imap1.linux-foundation.org> <49876A91.4000705@zytor.com> <49881904.30705@redhat.com> <498879B3.8030002@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <498879B3.8030002-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mm-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 03, 2009 at 09:06:59AM -0800, H. Peter Anvin wrote:
> Gerd Hoffmann wrote:
> > H. Peter Anvin wrote:
> >> akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
> >>> This prototype has one problem though: On 32bit archs is the (64bit)
> >>> offset argument unaligned, which the syscall ABI of several archs doesn't
> >>> allow to do.  At least s390 needs a wrapper in glibc to handle this.  As
> >>> we'll need a wrappers in glibc anyway I've decided to push problem to
> >>> glibc entriely and use a syscall prototype which works without
> >>> arch-specific wrappers inside the kernel: The offset argument is
> >>> explicitly splitted into two 32bit values.
> >> That rather sucks.  It'd be cleaner to just shuffle the argument order.
> > 
> > That was discussed too.  Doesn't solve the problem that you need some
> > wrap-o-magic in glibc (this time to swap arguments instead of splitting
> > the offset).  And is has the drawback that it is confusing to have
> > different argument ordering at application and syscall level (think
> > strace).  Check the archives for the details.
> > 
> 
> A pointer would help.
> 
> I would say that different argument order in strace is a lot better than
> having an argument completely mangled, which is what one gets with this
> as proposed.
> 
> All in all, I think it is WRONG to make sane architectures suffer for
> what broken architectures have to do, and we should implement this the
> sane way without any shuffling, splitting, or other braindamage.

Disagree.  What is better: having _one_ _common_ argument order in the
syscall interface, or having architectures end up doing their own thing?

Think about your strace argument - you're effectively requiring strace
to know that on architecture X, the syscall argument order is X1, but
on architecture Y, that same syscall has argument order Y1, and maybe
architecture Z, it's again a different order Z1.

That _adds_ complexity to strace - rather than having one ordering to
deal with for a syscall, it now has three different random orders.

That's completely insane.  With one _common_ ordering, at least strace
has the possibility of cleanly sorting it out.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
