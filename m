From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCHv5, REBASED 9/9] x86/mm: Allow to have userspace mappings
 above 47-bits
Date: Thu, 18 May 2017 18:19:52 +0300
Message-ID: <20170518151952.jzvz6aeelgx7ifmm@node.shutemov.name>
References: <20170515121218.27610-1-kirill.shutemov@linux.intel.com>
 <20170515121218.27610-10-kirill.shutemov@linux.intel.com>
 <20170518114359.GB25471@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170518114359.GB25471-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, May 18, 2017 at 01:43:59PM +0200, Michal Hocko wrote:
> On Mon 15-05-17 15:12:18, Kirill A. Shutemov wrote:
> [...]
> > @@ -195,6 +207,16 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
> >  	info.length = len;
> >  	info.low_limit = PAGE_SIZE;
> >  	info.high_limit = get_mmap_base(0);
> > +
> > +	/*
> > +	 * If hint address is above DEFAULT_MAP_WINDOW, look for unmapped area
> > +	 * in the full address space.
> > +	 *
> > +	 * !in_compat_syscall() check to avoid high addresses for x32.
> > +	 */
> > +	if (addr > DEFAULT_MAP_WINDOW && !in_compat_syscall())
> > +		info.high_limit += TASK_SIZE_MAX - DEFAULT_MAP_WINDOW;
> > +
> >  	info.align_mask = 0;
> >  	info.align_offset = pgoff << PAGE_SHIFT;
> >  	if (filp) {
> 
> I have two questions/concerns here. The above assumes that any address above
> 1<<47 will use the _whole_ address space. Is this what we want?

Yes, I believe so.

> What if somebody does mmap(1<<52, ...) because he wants to (ab)use 53+
> bits for some other purpose? Shouldn't we cap the high_limit by the
> given address?

This would screw existing semantics of hint address -- "map here if
free, please".

> Another thing would be that 
> 	/* requesting a specific address */
> 	if (addr) {
> 		addr = PAGE_ALIGN(addr);
> 		vma = find_vma(mm, addr);
> 		if (TASK_SIZE - len >= addr &&
> 				(!vma || addr + len <= vma->vm_start))
> 			return addr;
> 	}
> 
> would fail for mmap(-1UL, ...) which is good because we do want to
> fallback to vm_unmapped_area and have randomized address which is
> ensured by your info.high_limit += ... but that wouldn't work for
> mmap(1<<N, ...) where N>47. So the first such mapping won't be
> randomized while others will be. This is quite unexpected I would say.
> So it should be documented at least or maybe we want to skip the above
> shortcut for addr > DEFAULT_MAP_WINDOW altogether.

Again, you're missing existing semantics of hint address. You may have a
reason to set hint address above 47-bit, besides getting access to full
address space.

-- 
 Kirill A. Shutemov
