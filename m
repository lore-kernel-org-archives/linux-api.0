From: Trond Myklebust <trond.myklebust@primarydata.com>
Subject: Re: [PATCH RFC] introduce ioctl to completely invalidate page cache
Date: Tue, 7 Oct 2014 15:35:47 -0400
Message-ID: <CAHQdGtTgbrFOnpT9H-MNw=9DbuM=Dc3yUGBt2zjnVB5eaF76Mg@mail.gmail.com>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
	<542DAEAC.8010203@kernel.dk>
	<20141006080659.GA7526@quack.suse.cz>
	<2368A3FCF9F7214298E53C823B0A48EC042405BC@AMSPEX01CL02.citrite.net>
	<2368A3FCF9F7214298E53C823B0A48EC0424106C@AMSPEX01CL02.citrite.net>
	<20141006143019.GG7526@quack.suse.cz>
	<20141007013059.GL2301@dastard>
	<20141007191624.GD30038@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141007191624.GD30038@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Thanos Makatos <thanos.makatos@citrix.com>, Jens Axboe <axboe@kernel.dk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "jlayton@poochiereds.net" <jlayton@poochiereds.net>, "bfields@fieldses.org" <bfields@fieldses.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 7, 2014 at 3:16 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 07-10-14 12:30:59, Dave Chinner wrote:
>> On Mon, Oct 06, 2014 at 04:30:19PM +0200, Jan Kara wrote:
>> > On Mon 06-10-14 11:33:23, Thanos Makatos wrote:
>> > > > > Trond also had a comment that if we extended the ioctl to work for all
>> > > > > inodes (not just blkdev) and allowed some additional flags of what
>> > > > > needs to be invalidated, the new ioctl would be also useful to NFS
>> > > > > userspace - see Trond's email at
>> > > > >
>> > > > > http://www.spinics.net/lists/linux-fsdevel/msg78917.html
>> > > > >
>> > > > > and the following thread. I would prefer to cover that usecase when we
>> > > > > are introducing new invalidation ioctl. Have you considered that Thanos?
>> > > >
>> > > > Sure, though I don't really know how to do it. I'll start by looking at the code
>> > > > flow when someone does " echo 3 > /proc/sys/vm/drop_caches", unless you
>> > > > already have a rough idea how to do that.
>> > >
>> > > I realise I haven't clearly understood what the semantics of this new ioctl
>> > > should be.
>> > >
>> > > My initial goal was to implement an ioctl that would _completely_ invalidate
>> > > the buffer cache of a block device when there is no file-system involved.
>> > > Unless I'm mistaken the patch I posted achieves this goal.
>> >   Yes.
>> >
>> > > We now want to extend this patch to take care of cached metadata, which seems
>> > > to be of particular importance for NFS, and I suspect that this piece of
>> > > functionality will still be applicable to any kind of file-system, correct?
>> >   So most notably they want the ioctl to work not only for block devices
>> > but also for any regular file. That's easily doable - you just call
>> > filemap_write_and_wait() and invalidate_inode_pages2() in the ioctl handler
>> > for regular files.
>> >
>> > Also they wanted to be able to specify a range of a mapping to invalidate -
>> > that's easily doable as well. Finally they wanted a 'flags' argument so you
>> > can additionally ask fs to invalidate also some metadata. How invalidation
>> > is done will be a fs specific thing and for now I guess we don't need to go
>> > into details. NFS guys can sort that out when they decide to implement it.
>> > So in the beginning we can just have u64 flags argument and in
>> > it a single 'INVAL_DATA' flag meaning that invalidation of data in a given
>> > range is requested. Later NFS guys can add further flags.
>>
>> Why do we need a new ioctl to do this? fadvise64() seems like it's
>> the exact fit for "FADV_INVALIDATE_[META]DATA" flags...
>   Well, fadvise() is currently a hint to kernel. In this case we would
> really like the call to do the invalidation and return error if it fails
> for some reason. So I'm not sure fadvise() is a perfect fit. But I wouldn't
> be strongly opposed to it either.
>

fadvise is about giving programs the ability to "announce an intention
to access file data in a specific pattern in the future, thus allowing
the kernel to perform appropriate optimizations" according to the
manpage.

Cache invalidation and revalidation, OTOH, is about ensuring meta/data
consistency between the disk and inode/page cache.

I'm not seeing a perfect match. :-)

-- 
Trond Myklebust

Linux NFS client maintainer, PrimaryData

trond.myklebust@primarydata.com
