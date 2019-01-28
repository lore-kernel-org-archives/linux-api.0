From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Mon, 28 Jan 2019 09:26:42 -0700
Message-ID: <42a5b12b-8d3a-2495-ad53-6a6fdd4504c6@kernel.dk>
References: <20190123153536.7081-1-axboe@kernel.dk>
 <20190123153536.7081-6-axboe@kernel.dk> <20190128145700.GA9795@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190128145700.GA9795@lst.de>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-block@vger.kernel.org, jmoyer@redhat.com, avi@scylladb.com, linux-api@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 1/28/19 7:57 AM, Christoph Hellwig wrote:
> [please make sure linux-api and linux-man are CCed on new syscalls
> so that we get API experts to review them]

I already did review with Arnd on those parts, I'll add linux-api and
linux-man for the next posting.

>> io_uring_enter(fd, to_submit, min_complete, flags)
>> 	Initiates IO against the rings mapped to this fd, or waits for
>> 	them to complete, or both. The behavior is controlled by the
>> 	parameters passed in. If 'to_submit' is non-zero, then we'll
>> 	try and submit new IO. If IORING_ENTER_GETEVENTS is set, the
>> 	kernel will wait for 'min_complete' events, if they aren't
>> 	already available. It's valid to set IORING_ENTER_GETEVENTS
>> 	and 'min_complete' == 0 at the same time, this allows the
>> 	kernel to return already completed events without waiting
>> 	for them. This is useful only for polling, as for IRQ
>> 	driven IO, the application can just check the CQ ring
>> 	without entering the kernel.
> 
> Especially with poll support now in the series, don't we need a ѕigmask
> argument similar to pselect/ppoll/io_pgetevents now to deal with signal
> blocking during waiting for events?

I guess we do.

>> +struct sqe_submit {
>> +	const struct io_uring_sqe *sqe;
>> +	unsigned index;
>> +};
> 
> Can you make sure all the structs use tab indentation for their
> field names?  Maybe even the same for all structs just to be nice
> to my eyes?

Sure, fixed.

>> +static int io_import_iovec(struct io_ring_ctx *ctx, int rw,
>> +			   const struct io_uring_sqe *sqe,
>> +			   struct iovec **iovec, struct iov_iter *iter)
>> +{
>> +	void __user *buf = u64_to_user_ptr(sqe->addr);
>> +
>> +#ifdef CONFIG_COMPAT
>> +	if (ctx->compat)
>> +		return compat_import_iovec(rw, buf, sqe->len, UIO_FASTIOV,
>> +						iovec, iter);
>> +#endif
> 
> I think we can just check in_compat_syscall() here, which means we
> can kill the ->compat member, and the separate compat version of the
> setup syscall.

Good point, I'll switch to using that so we don't have to track it.

>> +/*
>> + * IORING_OP_NOP just posts a completion event, nothing else.
>> + */
>> +static int io_nop(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +
>> +	__io_cqring_add_event(ctx, sqe->user_data, 0, 0);
> 
> Can you explain why not taking the completion lock is safe here?  And
> why we want to have such a somewhat dangerous special case just for the
> no-op benchmarking aid?

Was going to say it's safe because we always fill the ring inside the
ring mutex, but that won't work if we intermingle with non-polled IO.
I'll switch it to using the normal locked variant.

>> +static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
>> +{
>> +	struct io_sq_ring *ring = ctx->sq_ring;
>> +	unsigned head;
>> +
>> +	head = ctx->cached_sq_head;
>> +	smp_rmb();
>> +	if (head == READ_ONCE(ring->r.tail))
>> +		return false;
> 
> Do we really need to optimize the sq_head == tail case so much? Or
> am I missing why we are using the cached sq head case here?  Maybe
> add some more comments for a start.

It basically serves two purposes:

1) When we grab multiple events, only have to update the actual ring
   tail once. This is a big deal, especially on archs where the barriers
   are more expensive.

2) It means the kernel tracks the sq tail and cq head, instead of
   completely relying on the application. This seems a much saner
   choice.

>> +static int __io_uring_enter(struct io_ring_ctx *ctx, unsigned to_submit,
>> +			    unsigned min_complete, unsigned flags)
>> +{
>> +	int ret = 0;
>> +
>> +	if (to_submit) {
>> +		ret = io_ring_submit(ctx, to_submit);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +	if (flags & IORING_ENTER_GETEVENTS) {
>> +		int get_ret;
>> +
>> +		if (!ret && to_submit)
>> +			min_complete = 0;
> 
> Why do we have this special case?  Does it need some documentation?

At least for polled IO, if we don't submit what we were asked to, then
we can't reliably poll for the passed in number of events. The
min_complete from the application could very well include the
expectation that to_submit were submitted as well.

I'll add a comment.

>> +
>> +		get_ret = io_cqring_wait(ctx, min_complete);
>> +		if (get_ret < 0 && !ret)
>> +			ret = get_ret;
>> +	}
>> +
>> +	return ret;
> 
> Maybe using different names and slightly different semantics for the
> return values would clear some of this up?
> 
> 	if (to_submit) {
> 		submitted = io_ring_submit(ctx, to_submit);
> 		if (submitted < 0)
> 			return submitted;
> 	}
> 	if (flags & IORING_ENTER_GETEVENTS) {
> 		...
> 		ret = io_cqring_wait(ctx, min_complete);
> 	}
> 
> 	return submitted ? submitted : ret;

That would probably make it more readable, I'll make this change.

>> +static int io_sq_offload_start(struct io_ring_ctx *ctx)
> 
>> +static void io_sq_offload_stop(struct io_ring_ctx *ctx)
> 
> Can we just merge these two functions into the callers?  Currently
> the flow is a little odd with these helpers that don't seem to be
> too clear about their responsibilities.

In the initial patch I agree, but with the later thread addition, I like
having it in a separate helper. At least for the start, the top side is
more trivial.

>> +static void io_free_scq_urings(struct io_ring_ctx *ctx)
>> +{
>> +	if (ctx->sq_ring) {
>> +		page_frag_free(ctx->sq_ring);
>> +		ctx->sq_ring = NULL;
>> +	}
>> +	if (ctx->sq_sqes) {
>> +		page_frag_free(ctx->sq_sqes);
>> +		ctx->sq_sqes = NULL;
>> +	}
>> +	if (ctx->cq_ring) {
>> +		page_frag_free(ctx->cq_ring);
>> +		ctx->cq_ring = NULL;
>> +	}
> 
> Why is this using the page_frag helpers?  Also the callers just free
> these ctx structure, so there isn't much of a point zeroing them out.

Why not use the page frag helpers? No point in open-coding it. I can
kill the zeroing, double call would be a bug anyway.

> Also I'd be tempted to open code the freeing in io_allocate_scq_urings
> instead of caling the helper, which would avoid the NULL checks and
> make the error handling code a little more obvious.

OK

>> +	if (mutex_trylock(&ctx->uring_lock)) {
>> +		ret = __io_uring_enter(ctx, to_submit, min_complete, flags);
> 
> do we even need the separate __io_uring_enter helper?

I like having it nicely separated.

>> +static void io_fill_offsets(struct io_uring_params *p)
> 
> Do we really need this as a separate helper?

That does seem pointless, folded in.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
