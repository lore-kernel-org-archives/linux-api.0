From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Thu, 10 Jan 2019 14:11:01 -0800
Message-ID: <CAHk-=wip2CPrdOwgF0z4n2tsdW7uu+Egtcx9Mxxe3gPfPW_JmQ@mail.gmail.com>
References: <20190108044336.GB27534@dastard> <CAHk-=wjvzEFQcTGJFh9cyV_MPQftNrjOLon8YMMxaX0G1TLqkg@mail.gmail.com>
 <20190109022430.GE27534@dastard> <nycvar.YFH.7.76.1901090326460.16954@cbobk.fhfr.pm>
 <20190109043906.GF27534@dastard> <CAHk-=wic28fSkwmPbBHZcJ3BGbiftprNy861M53k+=OAB9n0=w@mail.gmail.com>
 <20190110004424.GH27534@dastard> <CAHk-=wg1jSQ-gq-M3+HeTBbDs1VCjyiwF4gqnnBhHeWizyrigg@mail.gmail.com>
 <20190110070355.GJ27534@dastard> <CAHk-=wigwXV_G-V1VxLs6BAvVkvW5=Oj+xrNHxE_7yxEVwoe3w@mail.gmail.com>
 <20190110122442.GA21216@nautica>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190110122442.GA21216@nautica>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Dave Chinner <david@fromorbit.com>, Jiri Kosina <jikos@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2019 at 4:25 AM Dominique Martinet
<asmadeus@codewreck.org> wrote:
>
> Linus Torvalds wrote on Thu, Jan 10, 2019:
> > (Except, of course, if somebody actually notices outside of tests.
> > Which may well happen and just force us to revert that commit. But
> > that's a separate issue entirely).
>
> Both Dave and I pointed at a couple of utilities that break with
> this. nocache can arguably work with the new behaviour but will behave
> differently; vmtouch on the other hand is no longer able to display
> what's in cache or not - people use that for example to "warm up" a
> container in page cache based on how it appears after it had been
> running for a while is a pretty valid usecase to me.

So honestly, the main reason I'm loath to revert is that yes, we know
of theoretical differences, but they seem to all be
performance-related.

It would be really good to hear numbers. Is the warm-up optimization
something that changes things from 3ms to 3.5ms? Or does it change
things from 3ms to half a second?

Because Dave is absolutely correct that mincore() isn't really even
all that interesting an information leak if you can do the same with
RWF_NOWAIT. But the other side of that same coin is that if we're not
able to block mincore() sanely, then there's no point at looking at
RWF_NOWAIT either.

And we *can* do sane things about RWF_NOWAIT. For example, we could
start async IO on RWF_NOWAIT, and suddenly it would go from "probe the
page cache" to "probe and fill", and be much harder to use as an
attack vector..

Do we want to do that? Maybe, maybe not. But if mincore() can't be
fixed, there's no point in even trying.

Now, if the mincore() change results in a big performance hit for
people who use it as a heuristic for filling caches etc, then
reverting the trial balloon is obviously something we must do, but at
that point I'd also like to know which load it was that cared so much,
and just what it did. Because we did have an alternate patch that just
said "was the file writably opened, then we can do the page cache
probing". But at least one user (fincore) didn't do even that.

So right now, I consider the mincore change to be a "try to probe the
state of mincore users", and we haven't really gotten a lot of
information back yet.

              Linus
