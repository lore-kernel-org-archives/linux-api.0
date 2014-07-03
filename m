From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v9] mm: support madvise(MADV_FREE)
Date: Thu, 3 Jul 2014 16:29:54 +0900
Message-ID: <20140703072954.GC2939@bbox>
References: <1404174975-22019-1-git-send-email-minchan@kernel.org>
 <20140701145058.GA2084@node.dhcp.inet.fi>
 <20140703010318.GA2939@bbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140703010318.GA2939@bbox>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-Id: linux-api@vger.kernel.org

Hello,

On Thu, Jul 03, 2014 at 10:03:19AM +0900, Minchan Kim wrote:
> Hello,
> 
> On Tue, Jul 01, 2014 at 05:50:58PM +0300, Kirill A. Shutemov wrote:
> > On Tue, Jul 01, 2014 at 09:36:15AM +0900, Minchan Kim wrote:
> > > +	do {
> > > +		/*
> > > +		 * XXX: We can optimize with supporting Hugepage free
> > > +		 * if the range covers.
> > > +		 */
> > > +		next = pmd_addr_end(addr, end);
> > > +		if (pmd_trans_huge(*pmd))
> > > +			split_huge_page_pmd(vma, addr, pmd);
> > 
> > Could you implement proper THP support before upstreaming the feature?
> > It shouldn't be a big deal.
> 
> Okay, Hope to review.
> 
> Thanks for the feedback!
> 

I tried to implement it but had a issue.

I need pmd_mkold, pmd_mkclean for MADV_FREE operation and pmd_dirty for
page_referenced. When I investigate all of arches supported THP,
it's not a big deal but s390 is not sure to me who has no idea of
soft tracking of s390 by storage key instead of page table information.
Cced s390 maintainer. Hope to help.

So, if there isn't any help from s390, I should introduce
HAVE_ARCH_THP_MADVFREE to disable MADV_FREE support of THP in s390 but
not want to introduce such new config.

At least, jemalloc case, it's hard to play with THP because it has
some metadata in the head of chunk so normally it doesn't free 2M
entirely. I guess other allocator works with similar approach
so not sure it's worth in this stage.

Do you have any workload to use MADV_FREE with THP?
so do you really want to support THP MADV_FREE now?

-- 
Kind regards,
Minchan Kim

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
