From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/8] mm: free swp_entry in madvise_free
Date: Tue, 3 Nov 2015 09:53:17 +0900
Message-ID: <20151103005317.GE17906@bbox>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
 <1446188504-28023-5-git-send-email-minchan@kernel.org>
 <20151030122814.GA23627@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151030122814.GA23627-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 30, 2015 at 01:28:14PM +0100, Michal Hocko wrote:
> On Fri 30-10-15 16:01:40, Minchan Kim wrote:
> > When I test below piece of code with 12 processes(ie, 512M * 12 = 6G
> > consume) on my (3G ram + 12 cpu + 8G swap, the madvise_free is siginficat
> > slower (ie, 2x times) than madvise_dontneed.
> > 
> > loop = 5;
> > mmap(512M);
> > while (loop--) {
> >         memset(512M);
> >         madvise(MADV_FREE or MADV_DONTNEED);
> > }
> > 
> > The reason is lots of swapin.
> > 
> > 1) dontneed: 1,612 swapin
> > 2) madvfree: 879,585 swapin
> > 
> > If we find hinted pages were already swapped out when syscall is called,
> > it's pointless to keep the swapped-out pages in pte.
> > Instead, let's free the cold page because swapin is more expensive
> > than (alloc page + zeroing).
> > 
> > With this patch, it reduced swapin from 879,585 to 1,878 so elapsed time
> > 
> > 1) dontneed: 6.10user 233.50system 0:50.44elapsed
> > 2) madvfree: 6.03user 401.17system 1:30.67elapsed
> > 2) madvfree + below patch: 6.70user 339.14system 1:04.45elapsed
> > 
> > Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Yes this makes a lot of sense.
> 
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> 
> One nit below.
> 
> > ---
> >  mm/madvise.c | 26 +++++++++++++++++++++++++-
> >  1 file changed, 25 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 640311704e31..663bd9fa0ae0 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -270,6 +270,8 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
> >  	spinlock_t *ptl;
> >  	pte_t *pte, ptent;
> >  	struct page *page;
> > +	swp_entry_t entry;
> 
> This could go into !pte_present if block

Sure, I fixed.
