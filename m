From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] introduce ioctl to completely invalidate page cache
Date: Mon, 6 Oct 2014 16:30:19 +0200
Message-ID: <20141006143019.GG7526@quack.suse.cz>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk>
 <20141006080659.GA7526@quack.suse.cz>
 <2368A3FCF9F7214298E53C823B0A48EC042405BC@AMSPEX01CL02.citrite.net>
 <2368A3FCF9F7214298E53C823B0A48EC0424106C@AMSPEX01CL02.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2368A3FCF9F7214298E53C823B0A48EC0424106C@AMSPEX01CL02.citrite.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Thanos Makatos <thanos.makatos@citrix.com>
Cc: 'Jan Kara' <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "jlayton@poochiereds.net" <jlayton@poochiereds.net>, "bfields@fieldses.org" <bfields@fieldses.org>
List-Id: linux-api@vger.kernel.org

On Mon 06-10-14 11:33:23, Thanos Makatos wrote:
> > > Trond also had a comment that if we extended the ioctl to work for all
> > > inodes (not just blkdev) and allowed some additional flags of what
> > > needs to be invalidated, the new ioctl would be also useful to NFS
> > > userspace - see Trond's email at
> > >
> > > http://www.spinics.net/lists/linux-fsdevel/msg78917.html
> > >
> > > and the following thread. I would prefer to cover that usecase when we
> > > are introducing new invalidation ioctl. Have you considered that Thanos?
> > 
> > Sure, though I don't really know how to do it. I'll start by looking at the code
> > flow when someone does " echo 3 > /proc/sys/vm/drop_caches", unless you
> > already have a rough idea how to do that.
> 
> I realise I haven't clearly understood what the semantics of this new ioctl
> should be.
> 
> My initial goal was to implement an ioctl that would _completely_ invalidate
> the buffer cache of a block device when there is no file-system involved.
> Unless I'm mistaken the patch I posted achieves this goal.
  Yes.

> We now want to extend this patch to take care of cached metadata, which seems
> to be of particular importance for NFS, and I suspect that this piece of
> functionality will still be applicable to any kind of file-system, correct?
  So most notably they want the ioctl to work not only for block devices
but also for any regular file. That's easily doable - you just call
filemap_write_and_wait() and invalidate_inode_pages2() in the ioctl handler
for regular files.

Also they wanted to be able to specify a range of a mapping to invalidate -
that's easily doable as well. Finally they wanted a 'flags' argument so you
can additionally ask fs to invalidate also some metadata. How invalidation
is done will be a fs specific thing and for now I guess we don't need to go
into details. NFS guys can sort that out when they decide to implement it.
So in the beginning we can just have u64 flags argument and in
it a single 'INVAL_DATA' flag meaning that invalidation of data in a given
range is requested. Later NFS guys can add further flags.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
