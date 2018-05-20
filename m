From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 10/32] aio: implement IOCB_CMD_POLL
Date: Sun, 20 May 2018 08:33:39 +0100
Message-ID: <20180520073332.GA30522@ZenIV.linux.org.uk>
References: <20180515194833.6906-1-hch@lst.de>
 <20180515194833.6906-11-hch@lst.de>
 <20180520053219.GZ30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180520053219.GZ30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, May 20, 2018 at 06:32:25AM +0100, Al Viro wrote:
> > +	spin_lock_irqsave(&ctx->ctx_lock, flags);
> > +	list_add_tail(&aiocb->ki_list, &ctx->delayed_cancel_reqs);
> > +	spin_unlock(&ctx->ctx_lock);
> 
> ... and io_cancel(2) comes, finds it and inhume^Wcompletes it, leaving us to...
> 
> > +	spin_lock(&req->head->lock);
> 
> ... get buggered on attempt to dereference a pointer fetched from freed and
> reused object.

FWIW, how painful would it be to pull the following trick:
	* insert into wait queue under ->ctx_lock
	* have wakeup do schedule_work() with aio_complete() done from that
	* have ->ki_cancel() grab queue lock, remove from queue and use
the same schedule_work()

That way you'd get ->ki_cancel() with the same semantics as originally for
everything - "ask politely to finish ASAP", and called in the same locking
environment for everyone - under ->ctx_lock, that is.  queue lock nests
inside ->ctx_lock; no magical flags, etc.

The cost is schedule_work() for each async poll-related completion as you
have for fsync.  I don't know whether that's too costly or not; it certainly
simplifies the things, but whether it's OK performance-wise...

Comments?

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
