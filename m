From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Fri, 11 Jan 2019 12:47:28 +1100
Message-ID: <20190111014728.GL27534@dastard>
References: <CAHk-=wiqbKEC5jUXr3ax+oUuiRrp=QMv_ZnUfO-SPv=UNJ-OTw@mail.gmail.com>
 <20190108044336.GB27534@dastard>
 <CAHk-=wjvzEFQcTGJFh9cyV_MPQftNrjOLon8YMMxaX0G1TLqkg@mail.gmail.com>
 <20190109022430.GE27534@dastard>
 <nycvar.YFH.7.76.1901090326460.16954@cbobk.fhfr.pm>
 <20190109043906.GF27534@dastard>
 <CAHk-=wic28fSkwmPbBHZcJ3BGbiftprNy861M53k+=OAB9n0=w@mail.gmail.com>
 <20190110004424.GH27534@dastard>
 <CAHk-=wg1jSQ-gq-M3+HeTBbDs1VCjyiwF4gqnnBhHeWizyrigg@mail.gmail.com>
 <CALCETrWxwaBUYMg=aLySJByMgXzuzV4gHS0n6O6Oet2Jm6SAbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWxwaBUYMg=aLySJByMgXzuzV4gHS0n6O6Oet2Jm6SAbw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jikos@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 09, 2019 at 09:26:41PM -0800, Andy Lutomirski wrote:
> Since direct IO has been brought up, I have a question.  I've wondered
> for years why direct IO works the way it does.  If I were implementing
> it from scratch, my first inclination would be to use the page cache
> instead of fighting it.  To do a single-page direct read, I would look
> that page up in the page cache (i.e. i_pages these days).  If the page
> is there, I would do a normal buffered read.  If the page is not

Therein lies the problem. Copying data is prohibitively expensive,
and that's the primary reason for O_DIRECT existing.  i.e. O_DIRECT
is a low-overhead, zero-copy data movement interface.

The moment we switch from using CPU to dispatch IO to copying data,
performance goes down because we will be unable to keep storage
pipelines full.  IOWs, any rework of O_DIRECT that involves copying
data is a non-starter.

But let's bring this back to the issue at hand - observability of
page cache residency of file pages. If th epage is caceh resident,
then it will have a latency of copying that data out of the page
(i.e. very low latency). If the page is not resident, then it will
do IO and take much, much longer to complete. i.e. we have clear
timing differences between cachce hit and cache miss IO.  This is
exactly the timing information needed for observing page cache
residency.

We need to work out how to make page cache residency less
observable, not add new, near perfect observation mechanisms that
third parties can easily exploit...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
