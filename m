From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9] mm: support madvise(MADV_FREE)
Date: Fri, 4 Jul 2014 15:41:02 +0900
Message-ID: <20140704064102.GH2939@bbox>
References: <1404174975-22019-1-git-send-email-minchan@kernel.org>
 <20140701145058.GA2084@node.dhcp.inet.fi>
 <20140703010318.GA2939@bbox>
 <20140703072954.GC2939@bbox>
 <20140703102901.322bfdb0@mschwide>
 <20140703083729.GE2939@bbox>
 <20140703180100.5f24a139@mschwide>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140703180100.5f24a139@mschwide>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Zhang Yanfei <zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux390-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, Gerald Schaefer <gerald.schaefer-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Thu, Jul 03, 2014 at 06:01:00PM +0200, Martin Schwidefsky wrote:
> On Thu, 3 Jul 2014 17:37:29 +0900
> Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > Hello,
> > 
> > On Thu, Jul 03, 2014 at 10:29:01AM +0200, Martin Schwidefsky wrote:
> > > On Thu, 3 Jul 2014 16:29:54 +0900
> > > Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > 
> > > > Hello,
> > > > 
> > > > On Thu, Jul 03, 2014 at 10:03:19AM +0900, Minchan Kim wrote:
> > > > > Hello,
> > > > > 
> > > > > On Tue, Jul 01, 2014 at 05:50:58PM +0300, Kirill A. Shutemov wrote:
> > > > > > On Tue, Jul 01, 2014 at 09:36:15AM +0900, Minchan Kim wrote:
> > > > > > > +	do {
> > > > > > > +		/*
> > > > > > > +		 * XXX: We can optimize with supporting Hugepage free
> > > > > > > +		 * if the range covers.
> > > > > > > +		 */
> > > > > > > +		next = pmd_addr_end(addr, end);
> > > > > > > +		if (pmd_trans_huge(*pmd))
> > > > > > > +			split_huge_page_pmd(vma, addr, pmd);
> > > > > > 
> > > > > > Could you implement proper THP support before upstreaming the feature?
> > > > > > It shouldn't be a big deal.
> > > > > 
> > > > > Okay, Hope to review.
> > > > > 
> > > > > Thanks for the feedback!
> > > > > 
> > > > 
> > > > I tried to implement it but had a issue.
> > > > 
> > > > I need pmd_mkold, pmd_mkclean for MADV_FREE operation and pmd_dirty for
> > > > page_referenced. When I investigate all of arches supported THP,
> > > > it's not a big deal but s390 is not sure to me who has no idea of
> > > > soft tracking of s390 by storage key instead of page table information.
> > > > Cced s390 maintainer. Hope to help.
> > > 
> > > Storage key for dirty and referenced tracking is a thing of the past.
> > > The current code for s390 uses software tracking for dirty and referenced.
> > > There is one catch though, for ptes the software implementation covers
> > > dirty and referenced bit but for pmds only referenced bit is available.
> > > The reason is that there is no free bit left in the pmd entry for the
> > > software dirty bit.
> > 
> > Thanks for the quick reply.
> > 
> > >  
> > > > So, if there isn't any help from s390, I should introduce
> > > > HAVE_ARCH_THP_MADVFREE to disable MADV_FREE support of THP in s390 but
> > > > not want to introduce such new config.
> > > 
> > > Why is the dirty bit for pmds needed for the MADV_FREE implementation?
> > 
> > MADV_FREE semantic want it.
> > 
> > When madvise syscall is called, VM clears dirty bit of ptes of
> > the range. If memory pressure happens, VM checks dirty bit of
> > page table and if it found still "clean", it means it's a
> > "lazyfree pages" so VM could discard the page instead of swapping out.
> > Once there was store operation for the page before VM peek a page
> > to reclaim, dirty bit is set so VM can swap out the page instead of
> > discarding to keep up-to-date contents.
> > 
> > If it's hard on s390, maybe we could use just reference bit
> > instead of dirty bit to check recent access but it might change
> > semantic a bit with other OSes. :(
> 
> Just discussed this with Gerald and we found a trick how we can add
> a dirty bit to the pmd entries. That will be a non-trivial patch but
> we can do it. Until that time you could just define pmd_dirty to 
> always return true and the code should "work" in the sense that it
> does not break anything.

Will work.
I will post a patch when I finish the work.
Hope to review.
Thanks for your advise!

> 
> -- 
> blue skies,
>    Martin.
> 
> "Reality continues to ruin my life." - Calvin.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Kind regards,
Minchan Kim
