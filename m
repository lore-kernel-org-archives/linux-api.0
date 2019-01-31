From: Daniel Gruss <daniel@gruss.cc>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT is
 set for the I/O
Date: Thu, 31 Jan 2019 13:04:16 +0100
Message-ID: <aea9a09a-9d01-fd08-d210-96b94162aba6@gruss.cc>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-3-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190130124420.1834-3-vbabka@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Jiri Kosina <jkosina@suse.cz>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Jiri Kosina <jikos@kernel.org>
List-Id: linux-api@vger.kernel.org

On 1/30/19 1:44 PM, Vlastimil Babka wrote:
> Close that sidechannel by always initiating readahead on the cache if we
> encounter a cache miss for preadv2(RWF_NOWAIT); with that in place, probing
> the pagecache residency itself will actually populate the cache, making the
> sidechannel useless.

I fear this does not really close the side channel. You can time the
preadv2 function and infer which path it took, so you just bring it down
to the same as using mmap and timing accesses.
If I understood it correctly, this patch just removes the advantages of
preadv2 over mmmap+access for the attacker.


Cheers,
Daniel
