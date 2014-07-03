From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9] mm: support madvise(MADV_FREE)
Date: Thu, 3 Jul 2014 10:03:19 +0900
Message-ID: <20140703010318.GA2939@bbox>
References: <1404174975-22019-1-git-send-email-minchan@kernel.org>
 <20140701145058.GA2084@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140701145058.GA2084-nhfs4B5ZimeFUdmeq17FyvUpdFzICT1y@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Zhang Yanfei <zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Tue, Jul 01, 2014 at 05:50:58PM +0300, Kirill A. Shutemov wrote:
> On Tue, Jul 01, 2014 at 09:36:15AM +0900, Minchan Kim wrote:
> > +	do {
> > +		/*
> > +		 * XXX: We can optimize with supporting Hugepage free
> > +		 * if the range covers.
> > +		 */
> > +		next = pmd_addr_end(addr, end);
> > +		if (pmd_trans_huge(*pmd))
> > +			split_huge_page_pmd(vma, addr, pmd);
> 
> Could you implement proper THP support before upstreaming the feature?
> It shouldn't be a big deal.

Okay, Hope to review.

Thanks for the feedback!

-- 
Kind regards,
Minchan Kim
