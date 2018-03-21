From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 06/28] aio: implement IOCB_CMD_POLL
Date: Wed, 21 Mar 2018 10:09:54 +0100
Message-ID: <20180321090954.GF14085@kroah.com>
References: <20180321074032.14211-1-hch@lst.de>
 <20180321074032.14211-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321074032.14211-7-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 08:40:10AM +0100, Christoph Hellwig wrote:
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
> Acked-by: Jeff Moyer <jmoyer@redhat.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
