From: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 01/13] mm: support madvise(MADV_FREE)
Date: Thu, 5 Nov 2015 12:41:20 +0900
Message-ID: <20151105034120.GA502@swordfish>
References: <1446600367-7976-1-git-send-email-minchan@kernel.org>
 <1446600367-7976-2-git-send-email-minchan@kernel.org>
 <20151104021624.GA2476@swordfish>
 <20151104233910.GA7357@bbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151104233910.GA7357@bbox>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Minchan,

On (11/05/15 08:39), Minchan Kim wrote:
[..]
> > 
> > I think it makes sense to update pmd_trans_unstable() and
> > pmd_none_or_trans_huge_or_clear_bad() comments in asm-generic/pgtable.h
> > Because they explicitly mention MADV_DONTNEED only. Just a thought.
> 
> Hmm, When I read comments(but actually I don't understand it 100%), it
> says pmd disappearing from MADV_DONTNEED with mmap_sem read-side
> lock. But MADV_FREE doesn't remove the pmd. So, I don't understand
> what I should add comment. Please suggest if I am missing something.
> 

Hm, sorry, I need to think about it more, probably my comment is irrelevant.
Was fantasizing some stupid use cases like doing MADV_DONTNEED and MADV_FREE
on overlapping addresses from different threads, processes that share mem, etc.

> > > @@ -379,6 +502,14 @@ madvise_vma(struct vm_area_struct *vma, struct vm_area_struct **prev,
> > >  		return madvise_remove(vma, prev, start, end);
> > >  	case MADV_WILLNEED:
> > >  		return madvise_willneed(vma, prev, start, end);
> > > +	case MADV_FREE:
> > > +		/*
> > > +		 * XXX: In this implementation, MADV_FREE works like
> > 		  ^^^^
> > 		XXX
> 
> What does it mean?

not much. just a minor note that there is a 'XXX' in "XXX: In this implementation"
comment.

	-ss
