From: Thanos Makatos <thanos.makatos-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH RFC] introduce ioctl to completely invalidate page cache
Date: Fri, 3 Oct 2014 09:25:34 +0000
Message-ID: <2368A3FCF9F7214298E53C823B0A48EC0423DFE3@AMSPEX01CL02.citrite.net>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <542DAEAC.8010203-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jens Axboe' <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org" <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, "jack-AlSwsSmVLrQ@public.gmane.org" <jack-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> > -		fsync_bdev(bdev);
> > -		invalidate_bdev(bdev);
> > +		flush_buffer_cache(bdev);
> > +		if (BLKFLSBUF2 == cmd)
> > +			return invalidate_inode_pages2(
> > +					bdev->bd_inode->i_mapping);
> >  		return 0;
> 
> We're currently ignoring the buffer cache sync and invalidation (which is odd),
> but at least being consistent would be good.
> 
> Might also need a filemap_write_and_wait() to sync before invalidation.

(I've got zero knowledge in this area, so excuse my ignorance!)

Does filemap_write_and_wait() writes back modified, memory-mapped pages? If so, isn't there a race condition? Or have I got it completely wrong?
