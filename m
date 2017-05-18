From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv5, REBASED 9/9] x86/mm: Allow to have userspace mappings
 above 47-bits
Date: Thu, 18 May 2017 19:13:30 +0200
Message-ID: <20170518171330.GA30148@dhcp22.suse.cz>
References: <20170515121218.27610-1-kirill.shutemov@linux.intel.com>
 <20170515121218.27610-10-kirill.shutemov@linux.intel.com>
 <20170518114359.GB25471@dhcp22.suse.cz>
 <20170518151952.jzvz6aeelgx7ifmm@node.shutemov.name>
 <20170518152736.GA18333@dhcp22.suse.cz>
 <20170518154135.zekuqls6almevrjt@node.shutemov.name>
 <20170518155003.GB18333@dhcp22.suse.cz>
 <20170518155914.GC18333@dhcp22.suse.cz>
 <20170518162255.l55tm5qbmnvvsgba@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170518162255.l55tm5qbmnvvsgba-sVvlyX1904swdBt8bTSxpkEMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 18-05-17 19:22:55, Kirill A. Shutemov wrote:
> On Thu, May 18, 2017 at 05:59:14PM +0200, Michal Hocko wrote:
[...]
> > I basically mean something like the following
> > ---
> > diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
> > index 74d1587b181d..d6f66ff02d0a 100644
> > --- a/arch/x86/kernel/sys_x86_64.c
> > +++ b/arch/x86/kernel/sys_x86_64.c
> > @@ -195,7 +195,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
> >  		goto bottomup;
> >  
> >  	/* requesting a specific address */
> > -	if (addr) {
> > +	if (addr && addr <= DEFAULT_MAP_WINDOW) {
> >  		addr = PAGE_ALIGN(addr);
> >  		vma = find_vma(mm, addr);
> >  		if (TASK_SIZE - len >= addr &&
> > @@ -215,7 +215,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
> >  	 * !in_compat_syscall() check to avoid high addresses for x32.
> >  	 */
> >  	if (addr > DEFAULT_MAP_WINDOW && !in_compat_syscall())
> > -		info.high_limit += TASK_SIZE_MAX - DEFAULT_MAP_WINDOW;
> > +		info.high_limit += min(TASK_SIZE_MAX, address) - DEFAULT_MAP_WINDOW;
> >  
> >  	info.align_mask = 0;
> >  	info.align_offset = pgoff << PAGE_SHIFT;
> 
> You try to stretch the interface too far. With the patch you propose we
> have totally different behaviour wrt hint address if it below and above
> 47-bits:
> 
>  * <= 47-bits: allocate VM [addr; addr + len - 1], if free;

unless I am missing something fundamental here this is not how it works.
We just map a different range if the requested one is not free (in
absence of MAP_FIXED). And we do that in top->down direction so this is
already how it works. And you _do_ rely on the same thing when allowing
larger than 47b except you start from the top of the supported address
space. So how exactly is your new behavior any different and more clear?

Say you would do
	mmap(1<<48, ...) # you will get 1<<48
	mmap(1<<48, ...) # you will get something below TASK_SIZE_MAX

>  * > 47-bits: allocate VM anywhere under addr;
> 
> Sorry, no. That's ugly.
> 
> If you feel that we need to guarantee that bits above certain limit are
> unused, introduce new interface. We have enough logic encoded in hint
> address already.

-- 
Michal Hocko
SUSE Labs
