From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 07/30] aio: add delayed cancel support
Date: Wed, 28 Mar 2018 22:34:59 +0100
Message-ID: <20180328213459.GW30522@ZenIV.linux.org.uk>
References: <20180328072926.17131-1-hch@lst.de>
 <20180328072926.17131-8-hch@lst.de>
 <20180328163526.GV30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180328163526.GV30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 28, 2018 at 05:35:26PM +0100, Al Viro wrote:
> On Wed, Mar 28, 2018 at 09:29:03AM +0200, Christoph Hellwig wrote:
> >  static void aio_fsync_work(struct work_struct *work)
> >  {
> >  	struct fsync_iocb *req = container_of(work, struct fsync_iocb, work);
> > +	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, fsync);
> > +	struct file *file = req->file;
> >  	int ret;
> >  
> >  	ret = vfs_fsync(req->file, req->datasync);
> > -	fput(req->file);
> > -	aio_complete(container_of(req, struct aio_kiocb, fsync), ret, 0);
> > +	if (aio_complete(iocb, ret, 0, 0))
> > +		fput(file);
> 
> IDGI.
> 	1) can aio_complete() ever return false here?
> 	2) do we ever have aio_kiocb that would not have an associated
> struct file * that needs to be dropped on successful aio_complete()?  AFAICS,
> rw, fsync and poll variants all have one, and I'm not sure what kind of
> async IO *could* be done without an opened file.

OK, hell with that.  I've tried to play with turning kiocb into a struct with
anon union in it, with poll and fsync parts folded into that sucker and ki_filp
lifted into common part.  Possible, but it's hairy as hell and can be done
afterwards.

However, doing that digging has turned up something really nasty.  Look:
in io_cancel(2) you have 
        spin_lock_irq(&ctx->ctx_lock);
        kiocb = lookup_kiocb(ctx, iocb, key);   
        if (kiocb) {
                if (kiocb->flags & AIO_IOCB_DELAYED_CANCEL) {
                        kiocb->flags |= AIO_IOCB_CANCELLED;
                } else {
                        ret = kiocb_cancel(kiocb);
                        kiocb = NULL;
                }
        }
        spin_unlock_irq(&ctx->ctx_lock);

Now, suppose two threads call io_cancel() on the same aio_poll in progress.
Both hit that code and *both* find the same kiocb.  Sure, the first one
will shortly do
        if (kiocb)
                ret = kiocb_cancel(kiocb);
which will remove it from the list.  Too late, though - you've already dropped
->ctx_lock, letting the second one find it.  Result: two aio_poll_cancel() in
parallel, with resulting double-free and double-fput().

You really need to remove it from the ->active_reqs before dropping the lock.
free_ioctx_users() does it correctly, io_cancel(2) fucks it up.

I'd add something like
struct aio_kiocb *kiocb_cancel_locked(struct aio_kiocb *kiocb)
{
	if (!kiocb)
		return ERR_PTR(-EINVAL);
	if (kiocb->flags & AIO_IOCB_DELAYED_CANCEL) {
		list_del(&kiocb->ki_list);
		kiocb->flags |= AIO_IOCB_CANCELLED;
		return kiocb;
	} else {
		return ERR_PTR(kiocb_cancel(kiocb));
	}
}

with 
        spin_lock_irq(&ctx->ctx_lock);
        while (!list_empty(&ctx->active_reqs)) {
                req = list_first_entry(&ctx->active_reqs,
                                       struct aio_kiocb, ki_list);
		req = kiocb_cancel_locked(req);
		if (!IS_ERR_OR_NULL(req))
                        list_add_tail(&req->ki_list, &list);
        }
        spin_unlock_irq(&ctx->ctx_lock);

in free_ioctx_users() and
        spin_lock_irq(&ctx->ctx_lock);
        kiocb = kiocb_cancel_locked(lookup_kiocb(ctx, iocb, key));
        spin_unlock_irq(&ctx->ctx_lock);
	ret = IS_ERR_OR_NULL(kiocb) ? PTR_ERR(kiocb) : kiocb_cancel(kiocb);
in io_cancel(2)...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
