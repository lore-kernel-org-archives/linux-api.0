From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT is set for the I/O
Date: Thu, 31 Jan 2019 11:47:24 +0100
Message-ID: <87imy5f6ir.fsf@oldenburg2.str.redhat.com>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
        <20190130124420.1834-1-vbabka@suse.cz>
        <20190130124420.1834-3-vbabka@suse.cz>
        <87munii3uj.fsf@oldenburg2.str.redhat.com>
        <nycvar.YFH.7.76.1901301614501.6626@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <nycvar.YFH.7.76.1901301614501.6626@cbobk.fhfr.pm> (Jiri Kosina's
        message of "Wed, 30 Jan 2019 16:15:55 +0100 (CET)")
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>
List-Id: linux-api@vger.kernel.org

* Jiri Kosina:

> On Wed, 30 Jan 2019, Florian Weimer wrote:
>
>> > preadv2(RWF_NOWAIT) can be used to open a side-channel to pagecache
>> > contents, as it reveals metadata about residency of pages in
>> > pagecache.
>> >
>> > If preadv2(RWF_NOWAIT) returns immediately, it provides a clear "page
>> > not resident" information, and vice versa.
>> >
>> > Close that sidechannel by always initiating readahead on the cache if
>> > we encounter a cache miss for preadv2(RWF_NOWAIT); with that in place,
>> > probing the pagecache residency itself will actually populate the
>> > cache, making the sidechannel useless.
>> 
>> I think this needs to use a different flag because the semantics are so
>> much different.  If I understand this change correctly, previously,
>> RWF_NOWAIT essentially avoided any I/O, and now it does not.
>
> It still avoid synchronous I/O, due to this code still being in place:
>
>                 if (!PageUptodate(page)) {
>                         if (iocb->ki_flags & IOCB_NOWAIT) {
>                                 put_page(page);
>                                 goto would_block;
>                         }
>
> but goes the would_block path only after initiating asynchronous 
> readahead.

But it wouldn't schedule asynchronous readahead before?

I'm worried that something, say PostgreSQL doing a sequential scan,
would implement a two-pass approach, first using RWF_NOWAIT to process
what's in the kernel page cache, and then read the rest without it.  If
RWF_NOWAIT is treated as a prefetch hint, there could be much more read
activity, and a lot of it would be pointless because the data might have
to be evicted before userspace can use it.

Thanks,
Florian
