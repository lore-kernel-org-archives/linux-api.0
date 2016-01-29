From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 00/12] MADV_FREE support
Date: Fri, 29 Jan 2016 16:32:36 +0900
Message-ID: <20160129073236.GC30072@bbox>
References: <1448865583-2446-1-git-send-email-minchan@kernel.org>
 <56A9C049.7010508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56A9C049.7010508-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Michael,

On Thu, Jan 28, 2016 at 08:16:25AM +0100, Michael Kerrisk (man-pages) wrote:
> Hello Minchan,
> 
> On 11/30/2015 07:39 AM, Minchan Kim wrote:
> > In v4, Andrew wanted to settle in old basic MADV_FREE and introduces
> > new stuffs(ie, lazyfree LRU, swapless support and lazyfreeness) later
> > so this version doesn't include them.
> > 
> > I have been tested it on mmotm-2015-11-25-17-08 with additional
> > patch[1] from Kirill to prevent BUG_ON which he didn't send to
> > linux-mm yet as formal patch. With it, I couldn't find any
> > problem so far.
> > 
> > Note that this version is based on THP refcount redesign so
> > I needed some modification on MADV_FREE because split_huge_pmd
> > doesn't split a THP page any more and pmd_trans_huge(pmd) is not
> > enough to guarantee the page is not THP page.
> > As well, for MAVD_FREE lazy-split, THP split should respect
> > pmd's dirtiness rather than marking ptes of all subpages dirty
> > unconditionally. Please, review last patch in this patchset.
> 
> Now that MADV_FREE has been merged, would you be willing to write
> patch to the madvise(2) man page that describes the semantics, 
> noes limitations and restrictions, and (ideally) has some sentences
> describing use cases?

I will try next week.
Thanks for the heads up.

> 
> Thanks,
> 
> Michael
> 
> 
> > 	mm: don't split THP page when syscall is called
> > 
> > [1] https://lkml.org/lkml/2015/11/17/134
> > 
> > git: git://git.kernel.org/pub/scm/linux/kernel/git/minchan/linux.git
> > branch: mm/madv_free-v4.4-rc2-mmotm-2015-11-25-17-08-v5r2
> > 
> > In this stage, I don't think we need to write man page.
> > It could be done after solid policy and implementation.
> > 
> >  * Change from v4
> >    * drop lazyfree LRU
> >    * drop swapless support
> >    * drop lazyfreeness
> >    * rebase on recent mmotom with THP refcount redesign
> > 
> >  * Change from v3
> >    * some bug fix
> >    * code refactoring
> >    * lazyfree reclaim logic change
> >    * reordering patch
> > 
> >  * Change from v2
> >    * vm_lazyfreeness tuning knob
> >    * add new LRU list - Johannes, Shaohua
> >    * support swapless - Johannes
> > 
> >  * Change from v1
> >    * Don't do unnecessary TLB flush - Shaohua
> >    * Added Acked-by - Hugh, Michal
> >    * Merge deactivate_page and deactivate_file_page
> >    * Add pmd_dirty/pmd_mkclean patches for several arches
> >    * Add lazy THP split patch
> >    * Drop zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org - Delivery Failure
> > 
> > Chen Gang (1):
> >   arch: uapi: asm: mman.h: Let MADV_FREE have same value for all
> >     architectures
> > 
> > Minchan Kim (11):
> >   mm: support madvise(MADV_FREE)
> >   mm: define MADV_FREE for some arches
> >   mm: free swp_entry in madvise_free
> >   mm: move lazily freed pages to inactive list
> >   mm: mark stable page dirty in KSM
> >   x86: add pmd_[dirty|mkclean] for THP
> >   sparc: add pmd_[dirty|mkclean] for THP
> >   powerpc: add pmd_[dirty|mkclean] for THP
> >   arm: add pmd_mkclean for THP
> >   arm64: add pmd_mkclean for THP
> >   mm: don't split THP page when syscall is called
> > 
> >  arch/alpha/include/uapi/asm/mman.h       |   2 +
> >  arch/arm/include/asm/pgtable-3level.h    |   1 +
> >  arch/arm64/include/asm/pgtable.h         |   1 +
> >  arch/mips/include/uapi/asm/mman.h        |   2 +
> >  arch/parisc/include/uapi/asm/mman.h      |   2 +
> >  arch/powerpc/include/asm/pgtable-ppc64.h |   2 +
> >  arch/sparc/include/asm/pgtable_64.h      |   9 ++
> >  arch/x86/include/asm/pgtable.h           |   5 +
> >  arch/xtensa/include/uapi/asm/mman.h      |   2 +
> >  include/linux/huge_mm.h                  |   3 +
> >  include/linux/rmap.h                     |   1 +
> >  include/linux/swap.h                     |   1 +
> >  include/linux/vm_event_item.h            |   1 +
> >  include/uapi/asm-generic/mman-common.h   |   1 +
> >  mm/huge_memory.c                         |  87 +++++++++++++-
> >  mm/ksm.c                                 |   6 +
> >  mm/madvise.c                             | 199 +++++++++++++++++++++++++++++++
> >  mm/rmap.c                                |   8 ++
> >  mm/swap.c                                |  44 +++++++
> >  mm/swap_state.c                          |   5 +-
> >  mm/vmscan.c                              |  10 +-
> >  mm/vmstat.c                              |   1 +
> >  22 files changed, 383 insertions(+), 10 deletions(-)
> > 
> 
> 
> -- 
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
