From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Wed, 9 Jan 2019 10:25:43 -0800
Message-ID: <CAHk-=wic28fSkwmPbBHZcJ3BGbiftprNy861M53k+=OAB9n0=w@mail.gmail.com>
References: <CAHk-=wg5Kk+r36=jcGBaLUj+gjopjgiW5eyvkdMqvn0jFkD_iQ@mail.gmail.com>
 <CAHk-=wiMQeCEKESWTmm15x79NjEjNwFvjZ=9XenxY7yH8zqa7A@mail.gmail.com>
 <20190106001138.GW6310@bombadil.infradead.org> <CAHk-=wiT=ov+6zYcnw_64ihYf74Amzqs67iVGtJMQq65PxiVYw@mail.gmail.com>
 <CAHk-=wg1A44Roa8C4dmfdXLRLmNysEW36=3R7f+tzZzbcJ2d2g@mail.gmail.com>
 <CAHk-=wiqbKEC5jUXr3ax+oUuiRrp=QMv_ZnUfO-SPv=UNJ-OTw@mail.gmail.com>
 <20190108044336.GB27534@dastard> <CAHk-=wjvzEFQcTGJFh9cyV_MPQftNrjOLon8YMMxaX0G1TLqkg@mail.gmail.com>
 <20190109022430.GE27534@dastard> <nycvar.YFH.7.76.1901090326460.16954@cbobk.fhfr.pm>
 <20190109043906.GF27534@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190109043906.GF27534@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jiri Kosina <jikos@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 8, 2019 at 8:39 PM Dave Chinner <david@fromorbit.com> wrote:
>
> FWIW, I just realised that the easiest, most reliable way to
> invalidate the page cache over a file range is simply to do a
> O_DIRECT read on it.

If that's the case, that's actually an O_DIRECT bug.

It should only invalidate the caches on write.

On reads, it wants to either _flush_ any direct caches before the
read, or just take the data from the caches. At no point is
"invalidate" a valid model.

Of course, I'm not in the least bit shocked if O_DIRECT is buggy like
this. But looking at least at the ext4 routine, the read just does

        ret = filemap_write_and_wait_range(mapping, iocb->ki_pos,

and I don't see any invalidation.

Having read access to a file absolutely should *not* mean that you can
flush caches on it. That's a write op.

Any filesystem that invalidates the caches on read is utterly buggy.

Can you actually point to such a thing? Let's get that fixed, because
it's completely wrong regardless of this whole mincore issue.

               Linus
