From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT
 is set for the I/O
Date: Thu, 31 Jan 2019 12:34:44 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1901311223270.3281@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-3-vbabka@suse.cz> <87munii3uj.fsf@oldenburg2.str.redhat.com> <nycvar.YFH.7.76.1901301614501.6626@cbobk.fhfr.pm>
 <87imy5f6ir.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87imy5f6ir.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>
List-Id: linux-api@vger.kernel.org

On Thu, 31 Jan 2019, Florian Weimer wrote:

> >> I think this needs to use a different flag because the semantics are so
> >> much different.  If I understand this change correctly, previously,
> >> RWF_NOWAIT essentially avoided any I/O, and now it does not.
> >
> > It still avoid synchronous I/O, due to this code still being in place:
> >
> >                 if (!PageUptodate(page)) {
> >                         if (iocb->ki_flags & IOCB_NOWAIT) {
> >                                 put_page(page);
> >                                 goto would_block;
> >                         }
> >
> > but goes the would_block path only after initiating asynchronous 
> > readahead.
> 
> But it wouldn't schedule asynchronous readahead before?

It would, that's kind of the whole point.

> I'm worried that something, say PostgreSQL doing a sequential scan, 
> would implement a two-pass approach, first using RWF_NOWAIT to process 
> what's in the kernel page cache, and then read the rest without it.  If 
> RWF_NOWAIT is treated as a prefetch hint, there could be much more read 
> activity, and a lot of it would be pointless because the data might have 
> to be evicted before userspace can use it.

So are you aware of anything already existing, that'd implement this 
semantics? I've quickly grepped https://github.com/postgres/postgres for 
RWF_NOWAIT, and they don't seem to use it at all. RWF_NOWAIT is rather 
new.

The usecase I am aware of is to make sure that the thread doing 
io_submit() doesn't get blocked for too long, because it has other things 
to do quickly in order to avoid starving other sub-threads (and delegate 
the I/O submission to asynchronous context).

-- 
Jiri Kosina
SUSE Labs
