From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 08/31] aio: implement IOCB_CMD_POLL
Date: Wed, 23 May 2018 01:45:30 +0100
Message-ID: <20180523004530.GG30522@ZenIV.linux.org.uk>
References: <20180522113108.25713-1-hch@lst.de>
 <20180522113108.25713-9-hch@lst.de>
 <20180522220524.GE30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180522220524.GE30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 22, 2018 at 11:05:24PM +0100, Al Viro wrote:
> > +{
> > +	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, poll);
> > +
> > +	fput(req->file);
> > +	aio_complete(iocb, mangle_poll(mask), 0);
> > +}
> 
> Careful.
> 
> > +static int aio_poll_cancel(struct kiocb *iocb)
> > +{
> > +	struct aio_kiocb *aiocb = container_of(iocb, struct aio_kiocb, rw);
> > +	struct poll_iocb *req = &aiocb->poll;
> > +	struct wait_queue_head *head = req->head;
> > +	bool found = false;
> > +
> > +	spin_lock(&head->lock);
> > +	found = __aio_poll_remove(req);
> > +	spin_unlock(&head->lock);
> 
> What's to guarantee that req->head has not been freed by that point?
> Look: wakeup finds ->ctx_lock held, so it leaves the sucker on the
> list, removes it from queue and schedules the call of __aio_poll_complete().
> Which gets executed just as we hit aio_poll_cancel(), starting with fput().
> 
> You really want to do aio_complete() before fput().  That way you know that
> req->wait is alive and well at least until iocb gets removed from the list.

Oh, bugger...

wakeup
	removed from queue
	schedule __aio_poll_complete()

cancel
	grab ctx->lock
	remove from list
work
	aio_complete()
		check if it's in the list
		it isn't, move on to free the sucker
cancel
	call ->ki_cancel()
	BOOM

Looks like we want to call ->ki_cancel() *BEFORE* removing from the list,
as well as doing fput() after aio_complete().  The same ordering, BTW, goes
for aio_read() et.al.

Look:
CPU1:	io_cancel() grabs ->ctx_lock, finds iocb and removes it from the list.
CPU2:	aio_rw_complete() on that iocb.  Since the sucker is not in the list
anymore, we do NOT spin on ->ctx_lock and proceed to free iocb
CPU1:	pass freed iocb to ->ki_cancel().  BOOM.

and if we have fput() done first (in aio_rw_complete()) we are vulnerable to
CPU1:	io_cancel() grabs ->ctx_lock, finds iocb and removes it from the list.
CPU2:	aio_rw_complete() on that iocb. fput() done, opening us to rmmod.
CPU1:	call ->ki_cancel(), which points to freed memory now.  BOOM.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
