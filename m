From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 14/36] aio: implement IOCB_CMD_POLL
Date: Wed, 24 Jan 2018 14:24:13 -0500
Message-ID: <x49mv13ys9u.fsf@segfault.boston.devel.redhat.com>
References: <20180122201243.31610-1-hch@lst.de>
	<20180122201243.31610-15-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180122201243.31610-15-hch@lst.de> (Christoph Hellwig's message
	of "Mon, 22 Jan 2018 21:12:21 +0100")
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Simple one-shot poll through the io_submit() interface.  To poll for
> a file descriptor the application should submit an iocb of type
> IOCB_CMD_POLL.  It will poll the fd for the events specified in the
> the first 32 bits of the aio_buf field of the iocb.
>
> Unlike poll or epoll without EPOLLONESHOT this interface always works
> in one shot mode, that is once the iocb is completed, it will have to be
> resubmitted.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Jeff Moyer <jmoyer@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
