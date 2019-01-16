From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Wed, 16 Jan 2019 17:00:25 +1200
Message-ID: <CAHk-=wgF9p9xNzZei_-ejGLy1bJf4VS1C5E9_V0kCTEpCkpCTQ@mail.gmail.com>
References: <20190108044336.GB27534@dastard> <CAHk-=wjvzEFQcTGJFh9cyV_MPQftNrjOLon8YMMxaX0G1TLqkg@mail.gmail.com>
 <20190109022430.GE27534@dastard> <nycvar.YFH.7.76.1901090326460.16954@cbobk.fhfr.pm>
 <20190109043906.GF27534@dastard> <CAHk-=wic28fSkwmPbBHZcJ3BGbiftprNy861M53k+=OAB9n0=w@mail.gmail.com>
 <20190110004424.GH27534@dastard> <CAHk-=wg1jSQ-gq-M3+HeTBbDs1VCjyiwF4gqnnBhHeWizyrigg@mail.gmail.com>
 <20190110070355.GJ27534@dastard> <CAHk-=wigwXV_G-V1VxLs6BAvVkvW5=Oj+xrNHxE_7yxEVwoe3w@mail.gmail.com>
 <20190110122442.GA21216@nautica> <CAHk-=wip2CPrdOwgF0z4n2tsdW7uu+Egtcx9Mxxe3gPfPW_JmQ@mail.gmail.com>
 <5c3e7de6.1c69fb81.4aebb.3fec@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5c3e7de6.1c69fb81.4aebb.3fec@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Snyder <joshs@netflix.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>, Dave Chinner <david@fromorbit.com>, Jiri Kosina <jikos@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 16, 2019 at 12:42 PM Josh Snyder <joshs@netflix.com> wrote:
>
> For Netflix, losing accurate information from the mincore syscall would
> lengthen database cluster maintenance operations from days to months.  We
> rely on cross-process mincore to migrate the contents of a page cache from
> machine to machine, and across reboots.

Ok, this is the kind of feedback we need, and means I guess we can't
just use the mapping existence for mincore.

The two other ways that we considered were:

 (a) owner of the file gets to know cache information for that file.

 (b) having the fd opened *writably* gets you cache residency information.

Sadly, taking a look at happycache, you open the file read-only, so
(b) doesn't work.

Judging just from the source code, I can't tell how the user ownership
works. Any input on that?

And if you're not the owner of the file, do you have another
suggestion for that "Yes, I have the right to see what's in-core for
this file". Because the problem is literally that if it's some random
read-only system file, the kernel shouldn't leak access patterns to
it..

                     Linus
