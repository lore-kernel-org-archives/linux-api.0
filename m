From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache only)
Date: Mon, 30 Mar 2015 18:40:16 -0400
Message-ID: <CANP1eJH4BcZ0vgZ6pZdKOd4orEzfKUqjpKXb3m=WMy0mbK+PFA@mail.gmail.com>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<CANP1eJEbDusq_Gda35dGKiacC+2tbvb_bQEEHpi6PmgnNoWDFw@mail.gmail.com>
	<20150327100411.6823b9d7.akpm@linux-foundation.org>
	<20150330074020.GC22229@infradead.org>
	<20150330115414.f7900c7062fe6370cb2aea8d@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150330115414.f7900c7062fe6370cb2aea8d@linux-foundation.org>
Sender: linux-arch-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 2:54 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 30 Mar 2015 00:40:20 -0700 Christoph Hellwig <hch@infradead.org> wrote:
>
>> On Fri, Mar 27, 2015 at 10:04:11AM -0700, Andrew Morton wrote:
>> > mm...  I don't think we should be adding placeholders to the kernel API
>> > to support code which hasn't been written, tested, reviewed, merged,
>> > etc.  It's possible none of this will ever happen and we end up with a
>> > syscall nobody needs or uses.  Plus it's always possible that during
>> > this development we decide the pwrite2() interface needs alteration but
>> > it's too late.
>> >
>> > What would be the downside of deferring pwrite2() until it's all
>> > implemented?
>>
>> It _is_ implemented.  I just decided to submit it separately as Miklos
>> already has to deal with enough bikeshedding for his feature that I
>> don't want to put the burden of dealing with the BS for the one I wrote
>> on him.
>
> afacit the only difference between this pwritev2() and the existing
> pwritev() is that pwritev2() interprets pos==-1 as "current position",
> which duplicates writev()?
>
> Unless I've missed something, there's no point in merging this
> pwritev2() and it would be better to separate this syscall out into a
> pwritev2() patchset which can be considered and merged separately.  For
> the reasons described above.
>

At the LSF/MM session, the agreement form the active participants
(James Bottomley, Ted Tso, Christoph, and I forget the last guy's
name) that we should ship both syscalls in the first patch. Personally
I don't care, but you're the only voice against it.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
