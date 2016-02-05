From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 00/12] MADV_FREE support
Date: Fri, 5 Feb 2016 11:15:57 +0900
Message-ID: <20160205021557.GA11598@bbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

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
> 

Hello Michael,

Could you review this patch?

Thanks.

>From 203372f901f574e991215fdff6907608ba53f932 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Fri, 5 Feb 2016 11:09:54 +0900
Subject: [PATCH] madvise.2: Add MADV_FREE

Document the MADV_FREE flags added to madvise() in Linux 4.5

Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 man2/madvise.2 | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/man2/madvise.2 b/man2/madvise.2
index c1df67c..4704304 100644
--- a/man2/madvise.2
+++ b/man2/madvise.2
@@ -143,6 +143,25 @@ flag are special memory areas that are not managed
 by the virtual memory subsystem.
 Such pages are typically created by device drivers that
 map the pages into user space.)
+.TP
+.B MADV_FREE " (since Linux 4.5)"
+Application is finished with the given range, so kernel can free
+resources associated with it but the freeing could be delayed until
+memory pressure happens or canceld by write operation by user.
+
+After a successful MADV_FREE operation, user shouldn't expect kernel
+keeps stale data on the page. However, subsequent write of pages
+in the range will succeed and then kernel cannot free those dirtied pages
+so user can always see just written data. If there was no subsequent
+write, kernel can free those clean pages any time. In such case,
+user can see zero-fill-on-demand pages.
+
+Note that, it works only with private anonymous pages (see
+.BR mmap (2)).
+On swapless system, freeing pages in given range happens instantly
+regardless of memory pressure.
+
+
 .\"
 .\" ======================================================================
 .\"
-- 
1.9.1
