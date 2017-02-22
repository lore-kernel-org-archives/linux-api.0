From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCHv3 33/33] mm, x86: introduce PR_SET_MAX_VADDR and
 PR_GET_MAX_VADDR
Date: Wed, 22 Feb 2017 16:04:51 +0300
Message-ID: <20170222130451.GA23555@node.shutemov.name>
References: <20170217141328.164563-1-kirill.shutemov@linux.intel.com>
 <20170217141328.164563-34-kirill.shutemov@linux.intel.com>
 <CA+55aFwgbHxV-Ha2n1H=Z7P6bgcQ3D8aW=fr8ZrQ5OnvZ1vOYg@mail.gmail.com>
 <20170218092133.GA17471@node.shutemov.name>
 <20170220131515.GA9502@node.shutemov.name>
 <0d05ac45-a139-6f8e-f98b-71876fbb509d@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0d05ac45-a139-6f8e-f98b-71876fbb509d-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 21, 2017 at 12:46:55PM -0800, Dave Hansen wrote:
> Let me make sure I'm grokking what you're trying to do here.
> 
> On 02/20/2017 05:15 AM, Kirill A. Shutemov wrote:
> > +/* MPX cannot handle addresses above 47-bits yet. */
> > +unsigned long mpx_unmapped_area_check(unsigned long addr, unsigned long len,
> > +		unsigned long flags)
> > +{
> > +	if (!kernel_managing_mpx_tables(current->mm))
> > +		return addr;
> > +	if (addr + len <= DEFAULT_MAP_WINDOW)
> > +		return addr;
> 
> At this point, we know MPX management is on and the hint is for memory
> above DEFAULT_MAP_WINDOW?

Right.

> > +	if (flags & MAP_FIXED)
> > +		return -ENOMEM;
> 
> ... and if it's a MAP_FIXED request, fail it.

Yep.

> > +	if (len > DEFAULT_MAP_WINDOW)
> > +		return -ENOMEM;
> 
> What is this case for?  If addr+len wraps?

If len is too big to fit into DEFAULT_MAP_WINDOW there's no point in
resetting hint address as we know we can't satisfy it -- fail early.
> 
> > +	/* Look for unmap area within DEFAULT_MAP_WINDOW */
> > +	return 0;
> > +}
> 
> Otherwise, blow away the hint, which we know is high and needs to
> be discarded?

Right.

-- 
 Kirill A. Shutemov
