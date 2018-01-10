From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 26/32] aio: refactor read/write iocb setup
Date: Wed, 10 Jan 2018 16:19:53 -0500
Message-ID: <x49po6h4dja.fsf@segfault.boston.devel.redhat.com>
References: <20180110155853.32348-1-hch@lst.de>
	<20180110155853.32348-27-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180110155853.32348-27-hch@lst.de> (Christoph Hellwig's message
	of "Wed, 10 Jan 2018 16:58:47 +0100")
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Don't reference the kiocb structure from the common aio code, and move
> any use of it into helper specific to the read/write path.  This is in
> preparation for aio_poll support that wants to use the space for different
> fields.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think this all looks okay (making sure everything was still cleaned up
in the error cases was a bit of a chore).  One nit below.

> +static int aio_prep_rw(struct kiocb *req, struct iocb *iocb)
> +{
> +	int ret;
> +
> +	req->ki_filp = fget(iocb->aio_fildes);
> +	if (unlikely(!req->ki_filp))
> +		return -EBADF;
> +	req->ki_complete = aio_complete_rw;
> +	req->ki_flags = 0;

The above assignment seems superfluous...

> +	req->ki_pos = iocb->aio_offset;
> +	req->ki_flags = iocb_flags(req->ki_filp);

because of this.

Acked-by: Jeff Moyer <jmoyer@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
