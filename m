From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 1/7] mm: support madvise(MADV_FREE)
Date: Tue, 8 Jul 2014 13:45:18 +0900
Message-ID: <20140708044518.GA9824@bbox>
References: <1404694438-10272-1-git-send-email-minchan@kernel.org>
 <1404694438-10272-2-git-send-email-minchan@kernel.org>
 <53BB6B64.1080807@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53BB6B64.1080807-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhang Yanfei <zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Zhang,

On Tue, Jul 08, 2014 at 11:54:12AM +0800, Zhang Yanfei wrote:
> Hi Minchan,
> 
> On 07/07/2014 08:53 AM, Minchan Kim wrote:
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
> > the range. 
> 
> This should be updated because the implementation has been changed.
> It also remove the page from the swapcache if it is.

You're right in current implementation but it's rather one of
implementation technique(ie, it could be changed later) but still
main main logic from MADV_FREE is tightly coupled with pte dirty bit
so I don't feel I added it in description but it would be better to
add it as comment.

Thanks for the review!

> 
> Thank you for your effort!
> 
> -- 
> Thanks.
> Zhang Yanfei
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Kind regards,
Minchan Kim
