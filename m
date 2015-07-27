From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 4/6] block: loop: prepare for supporing direct IO
Date: Mon, 27 Jul 2015 02:45:30 -0700
Message-ID: <20150727094530.GA15507@infradead.org>
References: <1437061068-26118-1-git-send-email-ming.lei@canonical.com>
 <1437061068-26118-5-git-send-email-ming.lei@canonical.com>
 <20150727084020.GA28336@infradead.org>
 <CACVXFVOvnVHNtTkt_kiNZu9BuZHZ==EF4y3qXx+Qo=LHoytODQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVOvnVHNtTkt_kiNZu9BuZHZ==EF4y3qXx+Qo=LHoytODQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Justin M. Forbes" <jforbes@fedoraproject.org>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jul 27, 2015 at 05:41:57AM -0400, Ming Lei wrote:
> > Why the hardcoded value?  I suspect this should be more like:
> >
> >         if (dio && inode->i_sb->s_bdev &&
> >             (lo->lo_offset & (bdev_io_min(inode->i_sb->s_bdev) - 1)) != 0)
> >                 dio = false;
> 
> The above can't work if the backing device has a bigger sector size
> (such as 4K), that is why loop's direct-io requires 512 min_io_size of
> backing device.

Why doesn't it work?  If the backing device sector size is 4k
and lo_offset is 0 or a multiple of 4k it should allow direct I/O,
and my code sniplet will allow that.
