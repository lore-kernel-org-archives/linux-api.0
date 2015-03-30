From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache only)
Date: Mon, 30 Mar 2015 18:35:39 -0400
Message-ID: <CANP1eJE1ztbfFbxUgStMcPCp7ajGjOZLHHpdG+rN9eLW6YjgYA@mail.gmail.com>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<20150327081822.GA28669@infradead.org>
	<20150327013516.8c6788be.akpm@linux-foundation.org>
	<20150327084833.GA7689@infradead.org>
	<20150327020159.eadd0ce1.akpm@linux-foundation.org>
	<20150327155854.GA5548@samba2>
	<20150330073604.GB22229@infradead.org>
	<20150330132625.52b1250527ca3dcda79e349e@linux-foundation.org>
	<20150330203227.GA4987@samba2>
	<20150330133758.d2788f6de72f121170ff0301@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150330133758.d2788f6de72f121170ff0301@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Allison <jra@samba.org>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 4:37 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 30 Mar 2015 13:32:27 -0700 Jeremy Allison <jra@samba.org> wrote:
>
>> On Mon, Mar 30, 2015 at 01:26:25PM -0700, Andrew Morton wrote:
>> >
>> > cons:
>> >
>> > d) fincore() is more expensive
>> >
>> > e) fincore() will very occasionally block
>>
>> The above is the killer for Samba. If fincore
>> returns true but when we schedule the pread
>> we block, we're hosed.
>>
>> Once we block, we're done serving clients on the main
>> thread until this returns. That can cause unpredictable
>> response times which can cause client timeouts.
>>
>> A fincore+pread solution that blocks is simply unsafe
>> to use for us. We'll have to stay with the threadpool :-(.
>
> Finally.  Thanks ;)
>
> This implies that the samba main thread also has to avoid any memory
> allocations both direct and within syscall and pagefault - those will
> occasionally exhibit similar worse-case latency. Is this done now?
>
>

It's entirely possible to have an application with a low / semi static
working set, and leave lots of free memory for the kernel especially
for the page cache. For example the Google want to minimize malloc().
So in tcmalloc() they grab large chunks and rarely release it to back
to the OS, in fact old version never shrank it. So you can entirely
avoid stalls in malloc() for many workloads.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
