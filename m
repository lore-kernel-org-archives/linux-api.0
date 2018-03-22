From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 7/9] aio: add delayed cancel support
Date: Thu, 22 Mar 2018 16:33:56 +0000
Message-ID: <20180322163356.GG30522@ZenIV.linux.org.uk>
References: <20180321073232.13366-1-hch@lst.de>
 <20180321073232.13366-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321073232.13366-8-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 08:32:30AM +0100, Christoph Hellwig wrote:
> The upcoming aio poll support would like to be able to complete the
> iocb inline from the cancellation context, but that would cause
> a lock order reversal.  Add support for optionally moving the cancelation
> outside the context lock to avoid this reversal.

Ouch...  Seeing that you've just taken out cmpxchg loop out of kiocb_cancel()
with "serialized on ->ctx_lock" for explanation of safety...  Let me check
the aio_poll side of it; this commit might be better off in the poll series,
*if* it is actually correct.

What's to prevent double completions there?  Suppose we have iocb sitting on
the wait queue; cancellation callback set, so's "delayed cancel" flag.

Now, somebody tries to cancel the fucker on CPU1.  With ctx->lock held the
sucker is found on the list and, just as we mark it "cancelled", driver sends
a wakeup, executing (on CPU2) aio_poll_wake(), calling aio_complete_poll()
(without ctx->lock, so no exclusion with io_cancel(2) on CPU1), which checks
AIO_IOCB_CANCELLED and does not notice the flag being set on CPU1, then
proceeds to __aio_complete_poll() and fput() in there.

In the meanwhile, CPU1 has taken the sucker off the list, dropped the    
lock and called kiocb_cancel() on it.  Now we get aio_poll_cancel()
and __aio_complete_poll() on CPU1, with *another* fput().

What am I missing here that would prevent such a race?

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
