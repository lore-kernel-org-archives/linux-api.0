From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT is set for the I/O
Date: Wed, 30 Jan 2019 16:04:36 +0100
Message-ID: <87munii3uj.fsf@oldenburg2.str.redhat.com>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
        <20190130124420.1834-1-vbabka@suse.cz>
        <20190130124420.1834-3-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190130124420.1834-3-vbabka@suse.cz> (Vlastimil Babka's message
        of "Wed, 30 Jan 2019 13:44:19 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Jiri Kosina <jkosina@suse.cz>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, Jiri Kosina <jikos@kernel.org>
List-Id: linux-api@vger.kernel.org

* Vlastimil Babka:

> preadv2(RWF_NOWAIT) can be used to open a side-channel to pagecache
> contents, as it reveals metadata about residency of pages in
> pagecache.
>
> If preadv2(RWF_NOWAIT) returns immediately, it provides a clear "page
> not resident" information, and vice versa.
>
> Close that sidechannel by always initiating readahead on the cache if
> we encounter a cache miss for preadv2(RWF_NOWAIT); with that in place,
> probing the pagecache residency itself will actually populate the
> cache, making the sidechannel useless.

I think this needs to use a different flag because the semantics are so
much different.  If I understand this change correctly, previously,
RWF_NOWAIT essentially avoided any I/O, and now it does not.

Thanks,
Florian
