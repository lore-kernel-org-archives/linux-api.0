From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v17 1/7] mm: support madvise(MADV_FREE)
Date: Mon, 1 Dec 2014 08:56:52 +0900
Message-ID: <20141130235652.GA10333@bbox>
References: <1413799924-17946-1-git-send-email-minchan@kernel.org>
 <1413799924-17946-2-git-send-email-minchan@kernel.org>
 <20141127144725.GB19157@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141127144725.GB19157-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Michal,

On Thu, Nov 27, 2014 at 03:47:25PM +0100, Michal Hocko wrote:
> [Late but I didn't get to this soone - I hope this is still up-to-date
> version]
> 
> On Mon 20-10-14 19:11:58, Minchan Kim wrote:
> > Linux doesn't have an ability to free pages lazy while other OS
> > already have been supported that named by madvise(MADV_FREE).
> > 
> > The gain is clear that kernel can discard freed pages rather than
> > swapping out or OOM if memory pressure happens.
> > 
> > Without memory pressure, freed pages would be reused by userspace
> > without another additional overhead(ex, page fault + allocation
> > + zeroing).
> > 
> > How to work is following as.
> > 
> > When madvise syscall is called, VM clears dirty bit of ptes of
> > the range. If memory pressure happens, VM checks dirty bit of
> > page table and if it found still "clean", it means it's a
> > "lazyfree pages" so VM could discard the page instead of swapping out.
> > Once there was store operation for the page before VM peek a page
> > to reclaim, dirty bit is set so VM can swap out the page instead of
> > discarding.
> 
> Is there any patch for madvise man page? I guess the semantic will be
> same/similar to FreeBSD:
> http://www.freebsd.org/cgi/man.cgi?query=madvise&sektion=2

I postponed because I didn't know when we release the feature into mainline
but I should write down in man page ("MADV_FREE since Linux x.x.x").
However, early posting is not harmful.

Here it goes.
Most of content was copied from FreeBSD man page.

>From 2edd6890f92fa4943ce3c452194479458582d88c Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 1 Dec 2014 08:53:55 +0900
Subject: [PATCH] madvise.2: Document MADV_FREE

Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 man2/madvise.2 | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/man2/madvise.2 b/man2/madvise.2
index 032ead7..33aa936 100644
--- a/man2/madvise.2
+++ b/man2/madvise.2
@@ -265,6 +265,19 @@ file (see
 .BR MADV_DODUMP " (since Linux 3.4)"
 Undo the effect of an earlier
 .BR MADV_DONTDUMP .
+.TP
+.BR MADV_FREE " (since Linux 3.19)"
+Gives the VM system the freedom to free pages, and tells the system that
+information in the specified page range is no longer important.
+This is an efficient way of allowing
+.BR malloc (3)
+to free pages anywhere in the address space, while keeping the address space
+valid. The next time that the page is referenced, the page might be demand
+zeroed, or might contain the data that was there before the MADV_FREE call.
+References made to that address space range will not make the VM system page the
+information back in from backing store until the page is modified again.
+It works only with private anonymous pages (see
+.BR mmap (2)).
 .SH RETURN VALUE
 On success
 .BR madvise ()
-- 
2.0.0


> 
> I guess the changelog should be more specific that this is only for the
> private MAP_ANON mappings (same applies to the patch for man).
> 
> > Firstly, heavy users would be general allocators(ex, jemalloc,
> > tcmalloc and hope glibc supports it) and jemalloc/tcmalloc already
> > have supported the feature for other OS(ex, FreeBSD)
> > 
> [...]
> > 
> > Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> > Cc: Jason Evans <je-b10kYP2dOMg@public.gmane.org>
> > Acked-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Acked-by: Zhang Yanfei <zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> > Acked-by: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> [...]
> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Kind regards,
Minchan Kim
