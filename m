From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 16/18] io_uring: add support for IORING_OP_POLL
Date: Thu, 7 Feb 2019 15:18:27 -0700
Message-ID: <1e93d14c-0d9d-5c88-7bdc-fc59461f4e65@kernel.dk>
References: <20190207195552.22770-1-axboe@kernel.dk>
 <20190207195552.22770-17-axboe@kernel.dk>
 <x497eeb5jtq.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x497eeb5jtq.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/7/19 3:12 PM, Jeff Moyer wrote:
> Hi, Jens,
> 
>> +static int io_poll_add(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> +{
> 
> [...]
> 
>> +	/* one for removal from waitqueue, one for this function */
>> +	refcount_set(&req->refs, 2);
>> +
>> +	mask = vfs_poll(poll->file, &ipt.pt) & poll->events;
>> +	if (unlikely(!poll->head)) {
>> +		/* we did not manage to set up a waitqueue, done */
>> +		goto out;
>> +	}
>> +
>> +	spin_lock_irq(&ctx->completion_lock);
>> +	spin_lock(&poll->head->lock);
>> +	if (poll->woken) {
>> +		/* wake_up context handles the rest */
>> +		mask = 0;
>> +		ipt.error = 0;
>> +	} else if (mask || ipt.error) {
>> +		/* if we get an error or a mask we are done */
>> +		WARN_ON_ONCE(list_empty(&poll->wait.entry));
>> +		list_del_init(&poll->wait.entry);
>> +	} else {
>> +		/* actually waiting for an event */
>> +		list_add_tail(&req->list, &ctx->cancel_list);
>> +	}
>> +	spin_unlock(&poll->head->lock);
>> +	spin_unlock_irq(&ctx->completion_lock);
>> +
>> +out:
>> +	if (unlikely(ipt.error)) {
>> +		if (!(flags & IOSQE_FIXED_FILE))
>> +			fput(poll->file);
>> +		return ipt.error;
>> +	}
> 
> You need to drop the reference count on the req inside that if block.

Ah good point, because it's elevated. Fixed, thanks Jeff.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
