From: David Rientjes <rientjes@google.com>
Subject: Re: [patch] mm, thp: always specify ineligible vmas as nh in smaps
Date: Mon, 24 Sep 2018 12:17:34 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1809241215170.239142@chino.kir.corp.google.com>
References: <alpine.DEB.2.21.1809241054050.224429@chino.kir.corp.google.com> <e2f159f3-5373-dda4-5904-ed24d029de3c@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e2f159f3-5373-dda4-5904-ed24d029de3c@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, Linux-MM layout <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 24 Sep 2018, Vlastimil Babka wrote:

> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -653,13 +653,23 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> >  #endif
> >  #endif /* CONFIG_ARCH_HAS_PKEYS */
> >  	};
> > +	unsigned long flags = vma->vm_flags;
> >  	size_t i;
> >  
> > +	/*
> > +	 * Disabling thp is possible through both MADV_NOHUGEPAGE and
> > +	 * PR_SET_THP_DISABLE.  Both historically used VM_NOHUGEPAGE.  Since
> > +	 * the introduction of MMF_DISABLE_THP, however, userspace needs the
> > +	 * ability to detect vmas where thp is not eligible in the same manner.
> > +	 */
> > +	if (vma->vm_mm && test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
> > +		flags |= VM_NOHUGEPAGE;
> 
> Should it also clear VM_HUGEPAGE? In case MMF_DISABLE_THP overrides a
> madvise(MADV_HUGEPAGE)'d vma? (I expect it does?)
> 

Good point, I think that is should because MMF_DISABLE_THP will override 
VM_HUGEPAGE.  It looks like the Documentation file is still referencing 
both as advise flags and doesn't address PR_SET_THP_DISABLE.  Let me send 
a v2 with a Documentation update and your suggested fix.  Thanks 
Vlastimil!

> > +
> >  	seq_puts(m, "VmFlags: ");
> >  	for (i = 0; i < BITS_PER_LONG; i++) {
> >  		if (!mnemonics[i][0])
> >  			continue;
> > -		if (vma->vm_flags & (1UL << i)) {
> > +		if (flags & (1UL << i)) {
> >  			seq_putc(m, mnemonics[i][0]);
> >  			seq_putc(m, mnemonics[i][1]);
> >  			seq_putc(m, ' ');
> > 
