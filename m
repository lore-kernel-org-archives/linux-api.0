From: Thanos Makatos <thanos.makatos@citrix.com>
Subject: RE: [PATCH RFC] introduce ioctl to completely invalidate page cache
Date: Mon, 6 Oct 2014 11:33:23 +0000
Message-ID: <2368A3FCF9F7214298E53C823B0A48EC0424106C@AMSPEX01CL02.citrite.net>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk> <20141006080659.GA7526@quack.suse.cz>
 <2368A3FCF9F7214298E53C823B0A48EC042405BC@AMSPEX01CL02.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <2368A3FCF9F7214298E53C823B0A48EC042405BC@AMSPEX01CL02.citrite.net>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Thanos Makatos <thanos.makatos@citrix.com>, 'Jan Kara' <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "jlayton@poochiereds.net" <jlayton@poochiereds.net>, "bfields@fieldses.org" <bfields@fieldses.org>
List-Id: linux-api@vger.kernel.org

> > Trond also had a comment that if we extended the ioctl to work for all
> > inodes (not just blkdev) and allowed some additional flags of what
> > needs to be invalidated, the new ioctl would be also useful to NFS
> > userspace - see Trond's email at
> >
> > http://www.spinics.net/lists/linux-fsdevel/msg78917.html
> >
> > and the following thread. I would prefer to cover that usecase when we
> > are introducing new invalidation ioctl. Have you considered that Thanos?
> 
> Sure, though I don't really know how to do it. I'll start by looking at the code
> flow when someone does " echo 3 > /proc/sys/vm/drop_caches", unless you
> already have a rough idea how to do that.

I realise I haven't clearly understood what the semantics of this new ioctl
should be.

My initial goal was to implement an ioctl that would _completely_ invalidate
the buffer cache of a block device when there is no file-system involved.
Unless I'm mistaken the patch I posted achieves this goal.

We now want to extend this patch to take care of cached metadata, which seems
to be of particular importance for NFS, and I suspect that this piece of
functionality will still be applicable to any kind of file-system, correct?

Do we want this new ioctl to do what "echo 3 > /proc/sys/vm/drop_caches" does
but on a more selective basis, which IIUC drops whatever can be dropped, but
may not drop everything? If so, then we should more precisely define this ioctl
as "drop *all* cached data and as much metadata you can, which may not be all
of them". If this is the case, would adding a call to drop_pagecache_sb() on
all super blocks whose .s_bdev equals the block device we're interested in
suffice?
