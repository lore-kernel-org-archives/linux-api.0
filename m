From: Daniel Gruss <daniel@gruss.cc>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT is
 set for the I/O
Date: Thu, 31 Jan 2019 13:57:39 +0100
Message-ID: <443c3e0b-f93a-f857-0c95-9e0a1c87e318@gruss.cc>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-3-vbabka@suse.cz>
 <aea9a09a-9d01-fd08-d210-96b94162aba6@gruss.cc>
 <nycvar.YFH.7.76.1901311306570.3281@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <nycvar.YFH.7.76.1901311306570.3281@cbobk.fhfr.pm>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>
List-Id: linux-api@vger.kernel.org

On 1/31/19 1:08 PM, Jiri Kosina wrote:
> On Thu, 31 Jan 2019, Daniel Gruss wrote:
> 
>> If I understood it correctly, this patch just removes the advantages of 
>> preadv2 over mmmap+access for the attacker.
> 
> Which is the desired effect. We are not trying to solve the timing aspect, 
> as I don't think there is a reasonable way to do it, is there?

There are two building blocks to cache attacks, bringing the cache into
a state, and observing a state change, you can mitigate them by breaking
either of these building blocks.

For most attacks the attacker would be interested in observing *when* a
specific victim page is loaded into the page cache rather than observing
whether it is in the page cache right now (it could be there for ages if
the system was not under memory pressure).
So, one could try to prevent interference in the page cache between
attacker and victim -> working set algorithms do that to some extent.
Simpler idea (with more side effects) would be limiting the maximum
share of the page cache per user (or per process, depending on the
threat model)...


Cheers,
Daniel
