From: Thanos Makatos <thanos.makatos@citrix.com>
Subject: RE: [PATCH RFC] introduce ioctl to completely invalidate page cache
Date: Mon, 6 Oct 2014 15:21:10 +0000
Message-ID: <2368A3FCF9F7214298E53C823B0A48EC04241BC4@AMSPEX01CL02.citrite.net>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk> <20141006080659.GA7526@quack.suse.cz>
 <2368A3FCF9F7214298E53C823B0A48EC042405BC@AMSPEX01CL02.citrite.net>
 <2368A3FCF9F7214298E53C823B0A48EC0424106C@AMSPEX01CL02.citrite.net>
 <20141006143019.GG7526@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20141006143019.GG7526@quack.suse.cz>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: 'Jan Kara' <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "jlayton@poochiereds.net" <jlayton@poochiereds.net>, "bfields@fieldses.org" <bfields@fieldses.org>
List-Id: linux-api@vger.kernel.org

Thanks, Jan, it's much clearer now what I need to do.

>   So most notably they want the ioctl to work not only for block devices but also for any regular file. That's easily doable - you just call
> filemap_write_and_wait() and invalidate_inode_pages2() in the ioctl handler for regular files.

All right, so I need to find out how I can direct the new ioctl to
file-systems as well. I thought that I could get away with it by simply looking
at which file-systems have the same block device as the one to which the ioctl
is directed, but IIUC this doesn't make sense as NFS doesn't use a block device
at all.

> Also they wanted to be able to specify a range of a mapping to invalidate -
> that's easily doable as well. Finally they wanted a 'flags' argument so you can
> additionally ask fs to invalidate also some metadata. How invalidation is done
> will be a fs specific thing and for now I guess we don't need to go into
> details. NFS guys can sort that out when they decide to implement it.

So after I've figured out how to direct this new ioctl to a file-system, I need
to understand out how to invalidate a specific range of data. I will gracefully
fail metadata invalidation operations with EOPNOTSUPP or ENOSYS.

> So in the beginning we can just have u64 flags argument and in it a single
> 'INVAL_DATA' flag meaning that invalidation of data in a given range is
> requested. Later NFS guys can add further flags.

OK that I can do.

I suppose we'll always fail metadata invalidation operations when the target
of the ioctl is a block device.

Thanks
