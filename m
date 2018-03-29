From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 07/30] aio: add delayed cancel support
Date: Thu, 29 Mar 2018 23:35:00 +0100
Message-ID: <20180329223500.GY30522@ZenIV.linux.org.uk>
References: <20180329203328.3248-1-hch@lst.de>
 <20180329203328.3248-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180329203328.3248-8-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 29, 2018 at 10:33:05PM +0200, Christoph Hellwig wrote:
> The upcoming aio poll support would like to be able to complete the
> iocb inline from the cancellation context, but that would cause a
> double lock of ctx_lock with the current locking scheme.  Move the
> cancelation outside the context lock to avoid this reversal, which
> suits the existing usb gadgets users just fine as well (in fact
> both unconditionally disable irqs and thus seem broken without
> this change).
> 
> To make this safe aio_complete needs to check if this call should
> complete the iocb.  If it didn't the callers must not release any
> other resources.

Uh-oh...  What happens to existing users of kiocb_set_cancel_fn() now?
AFAICS, those guys will *not* get aio_kiocb freed at all in case of
io_cancel(2).  Look: we mark them with AIO_IOCB_CANCELLED and
call whatever ->ki_cancel() the driver has set.  Later the damn
thing calls ->ki_complete() (i.e. aio_complete_rw()), which calls
aio_complete(iocb, res, res2, 0) and gets false.  Nothing's freed,
struct file is leaked.

Frankly, the more I look at that, the less I like what you've done
with ->ki_cancel() overloading.  In regular case it's just accelerating
the call of ->ki_complete(), which will do freeing.  Here you have
->ki_cancel() free the damn thing, with the resulting need to play
silly buggers with locking, freeing logics in aio_complete(), etc.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
