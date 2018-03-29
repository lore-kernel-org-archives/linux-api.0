From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/30] aio: add delayed cancel support
Date: Thu, 29 Mar 2018 20:08:31 +0200
Message-ID: <20180329180831.GA15948@lst.de>
References: <20180328072926.17131-1-hch@lst.de> <20180328072926.17131-8-hch@lst.de> <20180328163526.GV30522@ZenIV.linux.org.uk> <20180329085305.GA22215@lst.de> <20180329142506.GX30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180329142506.GX30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 29, 2018 at 03:25:06PM +0100, Al Viro wrote:
> OK.  Let's leave that alone for now.  Re deferred cancels - AFAICS, we *must*
> remove the sucker from ctx->active_reqs before dropping ->ctx_lock.
> 
> As it is, you are creating a io_cancel()/io_cancel() race leading to double
> fput().  It's not that hard to fix; I can do that myself while applying your
> series (as described in previous posting - kiocb_cancel_locked() returning
> NULL or ERR_PTR() in non-deferred case and pointer to aio_kiocb removed from
> ->active_reqs in deferred one) or you could fix it in some other way and
> update your branch.

I think that is the right fix.  Let me resend so that I can test the
result first.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
