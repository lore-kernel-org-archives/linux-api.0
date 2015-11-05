From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/13] mm: support madvise(MADV_FREE)
Date: Thu, 5 Nov 2015 09:13:48 +0900
Message-ID: <20151105001348.GC7357@bbox>
References: <1446600367-7976-1-git-send-email-minchan@kernel.org>
 <1446600367-7976-2-git-send-email-minchan@kernel.org>
 <CALCETrUuNs=26UQtkU88cKPomx_Bik9mbgUUF9q7Nmh1pQJ4qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUuNs=26UQtkU88cKPomx_Bik9mbgUUF9q7Nmh1pQJ4qg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 03, 2015 at 07:41:35PM -0800, Andy Lutomirski wrote:
> On Nov 3, 2015 5:30 PM, "Minchan Kim" <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > Linux doesn't have an ability to free pages lazy while other OS already
> > have been supported that named by madvise(MADV_FREE).
> >
> > The gain is clear that kernel can discard freed pages rather than swapping
> > out or OOM if memory pressure happens.
> >
> > Without memory pressure, freed pages would be reused by userspace without
> > another additional overhead(ex, page fault + allocation + zeroing).
> >
> 
> [...]
> 
> >
> > How it works:
> >
> > When madvise syscall is called, VM clears dirty bit of ptes of the range.
> > If memory pressure happens, VM checks dirty bit of page table and if it
> > found still "clean", it means it's a "lazyfree pages" so VM could discard
> > the page instead of swapping out.  Once there was store operation for the
> > page before VM peek a page to reclaim, dirty bit is set so VM can swap out
> > the page instead of discarding.
> 
> What happens if you MADV_FREE something that's MAP_SHARED or isn't
> ordinary anonymous memory?  There's a long history of MADV_DONTNEED on
> such mappings causing exploitable problems, and I think it would be
> nice if MADV_FREE were obviously safe.

It filter out VM_LOCKED|VM_HUGETLB|VM_PFNMAP and file-backed vma and MAP_SHARED
with vma_is_anonymous.

> 
> Does this set the write protect bit?

No.

> 
> What happens on architectures without hardware dirty tracking?  For
> that matter, even on architecture with hardware dirty tracking, what
> happens in multithreaded processes that have the dirty TLB state
> cached in a different CPU's TLB?
> 
> Using the dirty bit for these semantics scares me.  This API creates a
> page that can have visible nonzero contents and then can
> asynchronously and magically zero itself thereafter.  That makes me
> nervous.  Could we use the accessed bit instead?  Then the observable

Access bit is used by aging algorithm for reclaim. In addition,
we have supported clear_refs feacture.
IOW, it could be reset anytime so it's hard to use marker for
lazy freeing at the moment.

> semantics would be equivalent to having MADV_FREE either zero the page
> or do nothing, except that it doesn't make up its mind until the next
> read.
> 
> > +                       ptent = pte_mkold(ptent);
> > +                       ptent = pte_mkclean(ptent);
> > +                       set_pte_at(mm, addr, pte, ptent);
> > +                       tlb_remove_tlb_entry(tlb, pte, addr);
> 
> It looks like you are flushing the TLB.  In a multithreaded program,
> that's rather expensive.  Potentially silly question: would it be
> better to just zero the page immediately in a multithreaded program
> and then, when swapping out, check the page is zeroed and, if so, skip
> swapping it out?  That could be done without forcing an IPI.

So, we should monitor all of pages in reclaim patch whether they are
zero or not? It is fatster for allocation side but much slower in
reclaim side. For avoiding that, we should mark something for lazy
freeing page out of page table.

Anyway, it depends on the TLB flush overehead vs memset overhead.
If the hinted range is pretty big and small system(ie, not many core),
memset overhead would't not trivial compared to TLB flush.
Even, some of ARM arches doesn't do IPI to TLB flush so the overhead
would be cheaper.

I don't want to push more optimization in new syscall from the beginning.
It's an optimization and might come better idea once we hear from the
voice of userland folks. Then, it's not too late.
Let's do step by step.

> 
> > +static int madvise_free_single_vma(struct vm_area_struct *vma,
> > +                       unsigned long start_addr, unsigned long end_addr)
> > +{
> > +       unsigned long start, end;
> > +       struct mm_struct *mm = vma->vm_mm;
> > +       struct mmu_gather tlb;
> > +
> > +       if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
> > +               return -EINVAL;
> > +
> > +       /* MADV_FREE works for only anon vma at the moment */
> > +       if (!vma_is_anonymous(vma))
> > +               return -EINVAL;
> 
> Does anything weird happen if it's shared?

Hmm, you mean MAP_SHARED|MAP_ANONYMOUS?
In that case, vma->vm_ops = &shmem_vm_ops so vma_is anonymous should filter it out.

> 
> > +               if (!PageDirty(page) && (flags & TTU_FREE)) {
> > +                       /* It's a freeable page by MADV_FREE */
> > +                       dec_mm_counter(mm, MM_ANONPAGES);
> > +                       goto discard;
> > +               }
> 
> Does something clear TTU_FREE the next time the page gets marked clean?

Sorry, I don't understand. Could you elaborate it more?

> 
> --Andy
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
