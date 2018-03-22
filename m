From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 06/28] aio: implement IOCB_CMD_POLL
Date: Thu, 22 Mar 2018 16:52:55 +0000
Message-ID: <20180322165255.GI30522@ZenIV.linux.org.uk>
References: <20180321074032.14211-1-hch@lst.de>
 <20180321074032.14211-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321074032.14211-7-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
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

AFAICS, your wakeup can race with io_cancel(), leading to double fput().
You are checking the "somebody had committed itself to cancelling that
thing" bit outside of ->ctx_lock on the wakeup side, and I don't see
anything to prevent both getting to __aio_poll_complete() on the same
iocb, with obvious results.

I might be missing something subtle in there, but then it would be nice to
have it covered in commit message...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
