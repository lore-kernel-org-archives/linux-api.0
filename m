From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 26/32] aio: refactor read/write iocb setup
Date: Thu, 11 Jan 2018 14:38:32 +0100
Message-ID: <20180111133832.GA5854@lst.de>
References: <20180110155853.32348-1-hch@lst.de> <20180110155853.32348-27-hch@lst.de> <x49po6h4dja.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <x49po6h4dja.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 10, 2018 at 04:19:53PM -0500, Jeff Moyer wrote:
> > +static int aio_prep_rw(struct kiocb *req, struct iocb *iocb)
> > +{
> > +	int ret;
> > +
> > +	req->ki_filp = fget(iocb->aio_fildes);
> > +	if (unlikely(!req->ki_filp))
> > +		return -EBADF;
> > +	req->ki_complete = aio_complete_rw;
> > +	req->ki_flags = 0;
> 
> The above assignment seems superfluous...

Thanks, fixed.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
