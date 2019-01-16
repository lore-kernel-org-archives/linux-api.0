From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Wed, 16 Jan 2019 22:41:16 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1901162238310.6626@cbobk.fhfr.pm>
References: <CAHk-=wip2CPrdOwgF0z4n2tsdW7uu+Egtcx9Mxxe3gPfPW_JmQ@mail.gmail.com> <5c3e7de6.1c69fb81.4aebb.3fec@mx.google.com> <CAHk-=wgF9p9xNzZei_-ejGLy1bJf4VS1C5E9_V0kCTEpCkpCTQ@mail.gmail.com> <9E337EA6-7CDA-457B-96C6-E91F83742587@amacapital.net>
 <CAHk-=wjqkbjL2_BwUYxJxJhdadiw6Zx-Yu_mK3E6P7kG3wSGcQ@mail.gmail.com> <20190116054613.GA11670@nautica> <CAHk-=wjVjecbGRcxZUSwoSgAq9ZbMxbA=MOiqDrPgx7_P3xGhg@mail.gmail.com> <nycvar.YFH.7.76.1901161710470.6626@cbobk.fhfr.pm>
 <CAHk-=wgsnWvSsMfoEYzOq6fpahkHWxF3aSJBbVqywLa34OXnLg@mail.gmail.com> <nycvar.YFH.7.76.1901162120000.6626@cbobk.fhfr.pm> <20190116213708.GN6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190116213708.GN6310@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Josh Snyder <joshs@netflix.com>, Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Cyril Hrubis <chrubis@suse.cz>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 16 Jan 2019, Matthew Wilcox wrote:

> > On Thu, 17 Jan 2019, Linus Torvalds wrote:
> > > As I suggested earlier in the thread, the fix for RWF_NOWAIT might be
> > > to just move the test down to after readahead.
> 
> Your patch 3/3 just removes the test.  Am I right in thinking that it
> doesn't need to be *moved* because the existing test after !PageUptodate
> catches it?

Exactly. It just initiates read-ahead for IOCB_NOWAIT cases as well, and 
if it's actually set, it'll be handled by the !PageUpdtodate case.

> Of course, there aren't any tests for RWF_NOWAIT in xfstests.  Are there 
> any in LTP?

Not in the released version AFAIK. I've asked the LTP maintainer (in our 
internal bugzilla) to take care of this thread a few days ago, but not 
sure what came out of it. Adding him (Cyril) to CC.

> Some typos in the commit messages:
> 
> > Another aproach (checking file access permissions in order to decide
> "approach"
> 
> > Subject: [PATCH 2/3] mm/mincore: make mincore() more conservative
> > 
> > The semantics of what mincore() considers to be resident is not completely
> > clearar, but Linux has always (since 2.3.52, which is when mincore() was
> "clear"
> 
> > initially done) treated it as "page is available in page cache".
> > 
> > That's potentially a problem, as that [in]directly exposes meta-information
> > about pagecache / memory mapping state even about memory not strictly belonging
> > to the process executing the syscall, opening possibilities for sidechannel
> > attacks.
> > 
> > Change the semantics of mincore() so that it only reveals pagecache information
> > for non-anonymous mappings that belog to files that the calling process could
> "belong"

Thanks.

-- 
Jiri Kosina
SUSE Labs
