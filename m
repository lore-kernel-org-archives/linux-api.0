From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Fri, 11 Jan 2019 08:44:27 +1100
Message-ID: <20190110214427.GK27534@dastard>
References: <20190108044336.GB27534@dastard>
 <CAHk-=wjvzEFQcTGJFh9cyV_MPQftNrjOLon8YMMxaX0G1TLqkg@mail.gmail.com>
 <20190109022430.GE27534@dastard>
 <nycvar.YFH.7.76.1901090326460.16954@cbobk.fhfr.pm>
 <20190109043906.GF27534@dastard>
 <CAHk-=wic28fSkwmPbBHZcJ3BGbiftprNy861M53k+=OAB9n0=w@mail.gmail.com>
 <20190110004424.GH27534@dastard>
 <CAHk-=wg1jSQ-gq-M3+HeTBbDs1VCjyiwF4gqnnBhHeWizyrigg@mail.gmail.com>
 <CALCETrWxwaBUYMg=aLySJByMgXzuzV4gHS0n6O6Oet2Jm6SAbw@mail.gmail.com>
 <20190110144711.GV6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190110144711.GV6310@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jikos@kernel.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2019 at 06:47:11AM -0800, Matthew Wilcox wrote:
> On Wed, Jan 09, 2019 at 09:26:41PM -0800, Andy Lutomirski wrote:
> > Since direct IO has been brought up, I have a question.  I've wondered
> > for years why direct IO works the way it does.  If I were implementing
> > it from scratch, my first inclination would be to use the page cache
> > instead of fighting it.  To do a single-page direct read, I would look
> > that page up in the page cache (i.e. i_pages these days).  If the page
> > is there, I would do a normal buffered read.  If the page is not
> > there, I would insert a record into i_pages indicating that direct IO
> > is in progress and then I would do the IO into the destination page.
> > If any other read, direct or otherwise, sees a record saying "under
> > direct IO", it would wait.
> 
> OK, you're in the same ballpark I am ;-)  Kent Overstreet pointed out
> that what you want to do here is great for the mixed case, but it's
> pretty inefficient for IOs to files which are wholly uncached.
> 
> So what I'm currently thinking about is an rwsem which works like this:
> 
> O_DIRECT task:
> if i_pages is empty, take rwsem for read, recheck i_pages is empty, do IO,
> drop rwsem.

GUP does page fault on user buffer which is a mmapped region of same
file. page fault sets up for buffered IO, tries to take rwsem for
write, deadlocks.

Most of the schemes we come up with fall down at this point - you
can't hold a lock over gup that is also used in the buffered IO
path. That's why XFS (and now ext4) have the IOLOCK and MMAPLOCK
for truncation serialisation - we can't lock out both read()/write()
and mmap IO paths with the same lock...

> if i_pages is not empty, insert XA_LOCK_ENTRY, when IO complete, wake waitqueue for that (mapping, index).

I assume you really mean add a tag to the entry?

But this means there is no record ofthe direct IO being in flight
except for the rwsem being held across the IO. Even if we did insert
a flag to say "DIO in progress" and not rely on the lock....

> buffered IO:
> if i_pages is empty, take rwsem for write, allocate page, insert page, drop rwsem.
> if i_pages is not empty, look up index, if entry is XA_LOCK_ENTRY sleep on
> waitqueue. otherwise proceed as now.

... we'll sleep on that flags in the page fault and deadlock anyway.

I'm pretty sure we explored this "record DIO state in the radix
tree" 2 or 3 years ago and came to the conclusion that it didn't
work for reasons like the above. i.e. it doesn't solve the problems
we currently have with locking and serialisation between DIO and
mmap...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
