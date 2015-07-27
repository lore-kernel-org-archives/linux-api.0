From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v7 4/6] block: loop: prepare for supporing direct IO
Date: Mon, 27 Jul 2015 05:41:57 -0400
Message-ID: <CACVXFVOvnVHNtTkt_kiNZu9BuZHZ==EF4y3qXx+Qo=LHoytODQ@mail.gmail.com>
References: <1437061068-26118-1-git-send-email-ming.lei@canonical.com>
	<1437061068-26118-5-git-send-email-ming.lei@canonical.com>
	<20150727084020.GA28336@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150727084020.GA28336-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Justin M. Forbes" <jforbes-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jul 27, 2015 at 4:40 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> +     /*
>> +      * loop block's logical block size is 512, now
>> +      * we support direct I/O only if the backing
>> +      * block devices' minimize I/O size is 512 and
>> +      * the offset is aligned with 512.
>> +      */
>> +     if (dio) {
>> +             if (inode->i_sb->s_bdev &&
>> +                     bdev_io_min(inode->i_sb->s_bdev) == 512 &&
>> +                     !(lo->lo_offset & 511))
>
> Why the hardcoded value?  I suspect this should be more like:
>
>         if (dio && inode->i_sb->s_bdev &&
>             (lo->lo_offset & (bdev_io_min(inode->i_sb->s_bdev) - 1)) != 0)
>                 dio = false;

The above can't work if the backing device has a bigger sector size
(such as 4K), that is why loop's direct-io requires 512 min_io_size of
backing device.

>
>> +     blk_mq_freeze_queue(lo->lo_queue);
>> +     lo->use_dio = use_dio;
>> +     if (use_dio)
>> +             lo->lo_flags |= LO_FLAGS_DIRECT_IO;
>> +     else
>> +             lo->lo_flags &= ~LO_FLAGS_DIRECT_IO;
>> +     blk_mq_unfreeze_queue(lo->lo_queue);
>
> Locking?

__loop_update_dio() is only called inside ioctl path, so
mutex of lo->lo_ctl_mutex has been held already.

Thanks,
