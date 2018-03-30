From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/30] aio: add delayed cancel support
Date: Fri, 30 Mar 2018 09:14:08 +0200
Message-ID: <20180330071408.GB17095@lst.de>
References: <20180329203328.3248-1-hch@lst.de> <20180329203328.3248-8-hch@lst.de> <20180329223500.GY30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180329223500.GY30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 29, 2018 at 11:35:00PM +0100, Al Viro wrote:
> Uh-oh...  What happens to existing users of kiocb_set_cancel_fn() now?
> AFAICS, those guys will *not* get aio_kiocb freed at all in case of
> io_cancel(2).  Look: we mark them with AIO_IOCB_CANCELLED and
> call whatever ->ki_cancel() the driver has set.  Later the damn
> thing calls ->ki_complete() (i.e. aio_complete_rw()), which calls
> aio_complete(iocb, res, res2, 0) and gets false.  Nothing's freed,
> struct file is leaked.

True, we'd need a complete call from it.

> Frankly, the more I look at that, the less I like what you've done
> with ->ki_cancel() overloading.  In regular case it's just accelerating
> the call of ->ki_complete(), which will do freeing.  Here you have
> ->ki_cancel() free the damn thing, with the resulting need to play
> silly buggers with locking, freeing logics in aio_complete(), etc.

I don't really like it all that much either, but I also think the
current model is pretty broken - called under spinlock with irqs
disabled is not even what the current users expect.  Second issue
with the existing ki_cancel is that kiocb_set_cancel_fn operates
on a kiocb, but expects that to be embedded in an aio_kiocb, which
might not always be the case, althought in-kernel I/O is unlikely to
be used on them.  And based on all of these I bet gadget aio cancel
is basically untested.

Anyway, I guess splitting poll direct cancel out in a way that doesn't
overload ->ki_cancel might be a good idea.  It all is inside aio.c
so simply switching on the opcode similar to the submission path
might be one option, or having separate methods.  Moving ki_cancel
to kiocb would also solve above mismatch issue.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
