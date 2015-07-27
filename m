From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v7 4/6] block: loop: prepare for supporing direct IO
Date: Tue, 28 Jul 2015 08:06:22 +1000
Message-ID: <20150727220622.GJ3902@dastard>
References: <1437061068-26118-1-git-send-email-ming.lei@canonical.com>
 <1437061068-26118-5-git-send-email-ming.lei@canonical.com>
 <20150727084020.GA28336@infradead.org>
 <CACVXFVOvnVHNtTkt_kiNZu9BuZHZ==EF4y3qXx+Qo=LHoytODQ@mail.gmail.com>
 <20150727094530.GA15507@infradead.org>
 <CACVXFVMKycx768HtAJXMgEZNjsQrNm_f3UzW9kUysSHAMM5FPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVMKycx768HtAJXMgEZNjsQrNm_f3UzW9kUysSHAMM5FPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Justin M. Forbes" <jforbes-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jul 27, 2015 at 05:53:33AM -0400, Ming Lei wrote:
> On Mon, Jul 27, 2015 at 5:45 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > On Mon, Jul 27, 2015 at 05:41:57AM -0400, Ming Lei wrote:
> >> > Why the hardcoded value?  I suspect this should be more like:
> >> >
> >> >         if (dio && inode->i_sb->s_bdev &&
> >> >             (lo->lo_offset & (bdev_io_min(inode->i_sb->s_bdev) - 1)) != 0)
> >> >                 dio = false;
> >>
> >> The above can't work if the backing device has a bigger sector size
> >> (such as 4K), that is why loop's direct-io requires 512 min_io_size of
> >> backing device.
> >
> > Why doesn't it work?  If the backing device sector size is 4k
> > and lo_offset is 0 or a multiple of 4k it should allow direct I/O,
> > and my code sniplet will allow that.
> 
> Because size has to be 4k aligned too.

So check that, too. Any >= 4k block size filesystem should be doing
mostly 4k aligned and sized IO...

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
