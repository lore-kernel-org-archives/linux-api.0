From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH RFC] introduce ioctl to completely invalidate page cache
Date: Mon, 6 Oct 2014 10:06:59 +0200
Message-ID: <20141006080659.GA7526@quack.suse.cz>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <542DAEAC.8010203-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Thanos Makatos <thanos.makatos-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 02-10-14 13:59:40, Jens Axboe wrote:
> On 10/02/2014 10:09 AM, Thanos Makatos wrote:
> > This patch introduces a new ioctl called BLKFLUSHBUFS2, which is pretty
> > similar to BLKFLUSHBUFS except that is also invalidates the page cache.
> > This allows for a complete invalidation of the cached data of a
> > particular block device, which might be useful for cases like
> > synchronising the caches of an iSCSI block device used by multiple
> > hosts.
> > 
> > Signed-off-by: Thanos Makatos <thanos.makatos-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
> > ---
> >  block/compat_ioctl.c    |    1 +
> >  block/ioctl.c           |   13 +++++++++++--
> >  include/uapi/linux/fs.h |    1 +
> >  3 files changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
> > index 18b282c..672388ab 100644
> > --- a/block/compat_ioctl.c
> > +++ b/block/compat_ioctl.c
> > @@ -688,6 +688,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
> >  	case BLKDISCARDZEROES:
> >  		return compat_put_uint(arg, bdev_discard_zeroes_data(bdev));
> >  	case BLKFLSBUF:
> > +	case BLKFLSBUF2:
> >  	case BLKROSET:
> >  	case BLKDISCARD:
> >  	case BLKSECDISCARD:
> > diff --git a/block/ioctl.c b/block/ioctl.c
> > index d6cda81..0c427a7 100644
> > --- a/block/ioctl.c
> > +++ b/block/ioctl.c
> > @@ -268,6 +268,12 @@ static inline int is_unrecognized_ioctl(int ret)
> >  		ret == -ENOIOCTLCMD;
> >  }
> >  
> > +static void flush_buffer_cache(struct block_device *bdev)
> > +{
> > +	fsync_bdev(bdev);
> > +	invalidate_bdev(bdev);
> > +}
> > +
> >  /*
> >   * always keep this in sync with compat_blkdev_ioctl()
> >   */
> > @@ -282,6 +288,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
> >  
> >  	switch(cmd) {
> >  	case BLKFLSBUF:
> > +	case BLKFLSBUF2:
> >  		if (!capable(CAP_SYS_ADMIN))
> >  			return -EACCES;
> >  
> > @@ -289,8 +296,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
> >  		if (!is_unrecognized_ioctl(ret))
> >  			return ret;
> >  
> > -		fsync_bdev(bdev);
> > -		invalidate_bdev(bdev);
> > +		flush_buffer_cache(bdev);
> > +		if (BLKFLSBUF2 == cmd)
> > +			return invalidate_inode_pages2(
> > +					bdev->bd_inode->i_mapping);
> >  		return 0;
> 
> We're currently ignoring the buffer cache sync and invalidation (which
> is odd), but at least being consistent would be good.
  Well, invalidate_bdev() doesn't return anything. And
invalidate_mapping_pages() inside invalidate_bdev() returns only number of
invalidated pages. I don't think there's any value in returning that.

OTOH invalidate_inode_pages2() returns 0 / -EBUSY / other error when
invalidation of some page fails so returning that seems useful.

> Might also need a filemap_write_and_wait() to sync before invalidation.
  That's what fsync_bdev() is doing under the hoods. Sometimes I'm not
sure whether all these wrappers are useful...

Trond also had a comment that if we extended the ioctl to work for all
inodes (not just blkdev) and allowed some additional flags of what needs to
be invalidated, the new ioctl would be also useful to NFS userspace - see
Trond's email at

http://www.spinics.net/lists/linux-fsdevel/msg78917.html

and the following thread. I would prefer to cover that usecase when we are
introducing new invalidation ioctl. Have you considered that Thanos?

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
