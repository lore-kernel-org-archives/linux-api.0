From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v7 4/6] block: loop: prepare for supporing direct IO
Date: Mon, 27 Jul 2015 05:53:33 -0400
Message-ID: <CACVXFVMKycx768HtAJXMgEZNjsQrNm_f3UzW9kUysSHAMM5FPQ@mail.gmail.com>
References: <1437061068-26118-1-git-send-email-ming.lei@canonical.com>
	<1437061068-26118-5-git-send-email-ming.lei@canonical.com>
	<20150727084020.GA28336@infradead.org>
	<CACVXFVOvnVHNtTkt_kiNZu9BuZHZ==EF4y3qXx+Qo=LHoytODQ@mail.gmail.com>
	<20150727094530.GA15507@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150727094530.GA15507-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Justin M. Forbes" <jforbes-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jul 27, 2015 at 5:45 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Mon, Jul 27, 2015 at 05:41:57AM -0400, Ming Lei wrote:
>> > Why the hardcoded value?  I suspect this should be more like:
>> >
>> >         if (dio && inode->i_sb->s_bdev &&
>> >             (lo->lo_offset & (bdev_io_min(inode->i_sb->s_bdev) - 1)) != 0)
>> >                 dio = false;
>>
>> The above can't work if the backing device has a bigger sector size
>> (such as 4K), that is why loop's direct-io requires 512 min_io_size of
>> backing device.
>
> Why doesn't it work?  If the backing device sector size is 4k
> and lo_offset is 0 or a multiple of 4k it should allow direct I/O,
> and my code sniplet will allow that.

Because size has to be 4k aligned too.

And it can't work in the example posted by Dave Chinner:

> I have a 4k sector backing device and a 512 byte sector filesystem
> image. I can't do 512 byte direct IO to the filesystem image, so I
> can't run tools that handle fs images in files using direct Io on
> that file. Create a loop device with the filesystem image, and now I
> can do 512 byte direct IO to the filesystem image, because all that
> direct IO to the filesystem image is now buffered by the loop
> device.
>
> If the loop device does direct io in this situation, the backing
> filesystem rejects direct IO from the loop device because it is not
> sector (4k) sized/aligned. User now swears, shouts and curses you
> from afar.


Thanks,
