From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache only)
Date: Fri, 27 Mar 2015 12:38:48 -0400
Message-ID: <CANP1eJEjn-N9MRhwfXahLO8E=H60zE-GaF4X2VdaxrBM1_xy3Q@mail.gmail.com>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<20150327081822.GA28669@infradead.org>
	<20150327013516.8c6788be.akpm@linux-foundation.org>
	<20150327084833.GA7689@infradead.org>
	<20150327020159.eadd0ce1.akpm@linux-foundation.org>
	<20150327155854.GA5548@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20150327155854.GA5548@samba2>
Sender: owner-linux-aio@kvack.org
To: Jeremy Allison <jra@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 27, 2015 at 11:58 AM, Jeremy Allison <jra@samba.org> wrote:
> On Fri, Mar 27, 2015 at 02:01:59AM -0700, Andrew Morton wrote:
>> On Fri, 27 Mar 2015 01:48:33 -0700 Christoph Hellwig <hch@infradead.org> wrote:
>>
>> > On Fri, Mar 27, 2015 at 01:35:16AM -0700, Andrew Morton wrote:
>> > > fincore() doesn't have to be ugly.  Please address the design issues I
>> > > raised.  How is pread2() useful to the class of applications which
>> > > cannot proceed until all data is available?
>> >
>> > It actually makes them work correctly?  preadv2( ..., DONTWAIT) will
>> > return -EGAIN, which causes them to bounce to the threadpool where
>> > they call preadv(...).
>>
>> (I assume you mean RWF_NONBLOCK)
>>
>> That isn't how pread2() works.  If the leading one or more pages are
>> uptodate, pread2() will return a partial read.  Now what?  Either the
>> application reads the same data a second time via the worker thread
>> (dumb, but it will usually be a rare case)
>
> The problem with the above is that we can't tell the difference
> between pread2() returning a short read because the pages are not
> in cache, or because someone truncated the file. So we need some
> way to differentiate this.
>
> My preference from userspace would be for pread2() to return
> EAGAIN if *all* the data requested is not available (where
> 'all' can be less than the size requested if the file has
> been truncated in the meantime).
>
> So:
>
> ret = pread2(fd, buf, size_wanted, RWF_NONBLOCK)
>
> if (ret == -1) {
>         if (errno == EAGAIN) {
>                 goto threadpool...
>         }
>         .. real error..
> }
>
> if (ret == size_wanted) {
>         .. normal read, file not truncated...
> }
>
> if (ret < size_wanted) {
>         .. file was truncated..
> }
>
> The thing I want to avoid is the case where
> ret < size_wanted means only part of the file
> is in cache.

I very much like the short read behavior. It lets you overlap some CPU
work partial data (like TLS and then sticking it network output
buffer) with waiting for the test of the data (enequed in the thread
pool).

Short reads are the current behavior, if you call preadv2 a second
time around at EOF it'll return 0 instead of EWOULDBLOCK today. I
actually test for this in the preadv2 test in xfstest here:
https://github.com/mtanski/xfstests/commit/688db24c292999c81ee17caf2b61fe8cf7bb3cd6#diff-114416ea98ce29dde3b5b3d145afbd2bR81.

There's one caveat, that it's possible to get EWOULDBLOCK when reading
at end of file if the file metadata is not paged in.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
