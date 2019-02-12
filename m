From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 3/3] mm/mincore: provide mapped status when cached status
 is not allowed
Date: Tue, 12 Feb 2019 04:44:30 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1902120440430.11598@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-4-vbabka@suse.cz> <20190131100907.GS18811@dhcp22.suse.cz> <99ee4d3e-aeb2-0104-22be-b028938e7f88@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <99ee4d3e-aeb2-0104-22be-b028938e7f88@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, Josh Snyder <joshs@netflix.com>
List-Id: linux-api@vger.kernel.org

On Fri, 1 Feb 2019, Vlastimil Babka wrote:

> >> After "mm/mincore: make mincore() more conservative" we sometimes restrict the
> >> information about page cache residency, which we have to do without breaking
> >> existing userspace, if possible. We thus fake the resulting values as 1, which
> >> should be safer than faking them as 0, as there might theoretically exist code
> >> that would try to fault in the page(s) until mincore() returns 1.
> >>
> >> Faking 1 however means that such code would not fault in a page even if it was
> >> not in page cache, with unwanted performance implications. We can improve the
> >> situation by revisting the approach of 574823bfab82 ("Change mincore() to count
> >> "mapped" pages rather than "cached" pages") but only applying it to cases where
> >> page cache residency check is restricted. Thus mincore() will return 0 for an
> >> unmapped page (which may or may not be resident in a pagecache), and 1 after
> >> the process faults it in.
> >>
> >> One potential downside is that mincore() will be again able to recognize when a
> >> previously mapped page was reclaimed. While that might be useful for some
> >> attack scenarios, it's not as crucial as recognizing that somebody else faulted
> >> the page in, and there are also other ways to recognize reclaimed pages anyway.
> > 
> > Is this really worth it? Do we know about any specific usecase that
> > would benefit from this change? TBH I would rather wait for the report
> > than add a hard to evaluate side channel.
> 
> Well it's not that complicated IMHO. Linus said it's worth trying, so
> let's see how he likes the result. The side channel exists anyway as
> long as process can e.g. check if its rss shrinked, and I doubt we are
> going to remove that possibility.

So, where do we go from here?

Either Linus and Andrew like the mincore() return value tweak, or this 
could be further discussed (*). But in either of the cases, I think 
patches 1 and 2 should be at least queued for 5.1.

(*) I'd personally include it as well, as I don't see how it would break 
    anything, it's pretty straightforward, and brings back some sanity to
    mincore() return value.

Thanks,

-- 
Jiri Kosina
SUSE Labs
