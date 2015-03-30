From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache only)
Date: Mon, 30 Mar 2015 19:09:43 -0400
Message-ID: <CANP1eJHs+JaDtWzfEkLF1409Q801Fg56hFCg28iNagN8PZndFA@mail.gmail.com>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<20150327081822.GA28669@infradead.org>
	<20150327013516.8c6788be.akpm@linux-foundation.org>
	<20150327084833.GA7689@infradead.org>
	<20150327020159.eadd0ce1.akpm@linux-foundation.org>
	<20150327155854.GA5548@samba2>
	<20150330073604.GB22229@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150330073604.GB22229@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Allison <jra@samba.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 3:36 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Mar 27, 2015 at 08:58:54AM -0700, Jeremy Allison wrote:
>> The problem with the above is that we can't tell the difference
>> between pread2() returning a short read because the pages are not
>> in cache, or because someone truncated the file. So we need some
>> way to differentiate this.
>
> Is a race vs truncate really that time critical that you can't
> wait for the thread pool to do the second read to notice it?
>
>> My preference from userspace would be for pread2() to return
>> EAGAIN if *all* the data requested is not available (where
>> 'all' can be less than the size requested if the file has
>> been truncated in the meantime).
>
> That is easily implementable, but I can see that for example web apps
> would be happy to get as much as possible.  So if Samba can be ok
> with short reads and only detecting the truncated case in the slow
> path that would make life simpler.  Otherwise we might indeed need two
> flags.

I'm okay with an old or nothing flag. Although I think that would much
more useful with RWF_NONWAIT with pwritev, in applications that don't
want to block while logging (but it's okay to drop low level log
messages). That's a whole different use case in my mind.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
