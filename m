From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 08/31] aio: implement IOCB_CMD_POLL
Date: Wed, 23 May 2018 01:49:04 +0100
Message-ID: <20180523004904.GH30522@ZenIV.linux.org.uk>
References: <20180522113108.25713-1-hch@lst.de>
 <20180522113108.25713-9-hch@lst.de>
 <20180522220524.GE30522@ZenIV.linux.org.uk>
 <20180523004530.GG30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180523004530.GG30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 23, 2018 at 01:45:30AM +0100, Al Viro wrote:

> Oh, bugger...
> 
> wakeup
> 	removed from queue
> 	schedule __aio_poll_complete()
> 
> cancel
> 	grab ctx->lock
> 	remove from list
> work
> 	aio_complete()
> 		check if it's in the list
> 		it isn't, move on to free the sucker
> cancel
> 	call ->ki_cancel()
> 	BOOM
> 
> Looks like we want to call ->ki_cancel() *BEFORE* removing from the list,
> as well as doing fput() after aio_complete().  The same ordering, BTW, goes
> for aio_read() et.al.
> 
> Look:
> CPU1:	io_cancel() grabs ->ctx_lock, finds iocb and removes it from the list.
> CPU2:	aio_rw_complete() on that iocb.  Since the sucker is not in the list
> anymore, we do NOT spin on ->ctx_lock and proceed to free iocb
> CPU1:	pass freed iocb to ->ki_cancel().  BOOM.

BTW, it seems that the mainline is vulnerable to this one.  I might be
missing something, but...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
