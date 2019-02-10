From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 05/19] Add io_uring IO interface
Date: Sun, 10 Feb 2019 13:03:14 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1902101048100.8784@nanos.tec.linutronix.de>
References: <20190209211346.26060-1-axboe@kernel.dk> <20190209211346.26060-6-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190209211346.26060-6-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On Sat, 9 Feb 2019, Jens Axboe wrote:
> +static void io_commit_cqring(struct io_ring_ctx *ctx)
> +{
> +	struct io_cq_ring *ring = ctx->cq_ring;
> +
> +	if (ctx->cached_cq_tail != READ_ONCE(ring->r.tail)) {
> +		/* order cqe stores with ring update */

This lacks a reference to the matching rmb()

> +		smp_wmb();
> +		WRITE_ONCE(ring->r.tail, ctx->cached_cq_tail);
> +		/* write side barrier of tail update, app has read side */

That's a bit meager. Can you please document the barriers which are paired
with user space barriers very elaborate?

> +		smp_wmb();
> +
> +		if (wq_has_sleeper(&ctx->cq_wait)) {
> +			wake_up_interruptible(&ctx->cq_wait);
> +			kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
> +		}
> +	}
> +}
> +
> +static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
> +{
> +	struct io_cq_ring *ring = ctx->cq_ring;
> +	unsigned tail;
> +
> +	tail = ctx->cached_cq_tail;
> +	smp_rmb();

Undocumented barrier

> +	if (tail + 1 == READ_ONCE(ring->r.head))
> +		return NULL;

> +static void io_commit_sqring(struct io_ring_ctx *ctx)
> +{
> +	struct io_sq_ring *ring = ctx->sq_ring;
> +
> +	if (ctx->cached_sq_head != READ_ONCE(ring->r.head)) {
> +		WRITE_ONCE(ring->r.head, ctx->cached_sq_head);
> +		/* write side barrier of head update, app has read side */

See above.

> +		smp_wmb();
> +	}
> +}


> +static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
> +{
> +	struct io_sq_ring *ring = ctx->sq_ring;
> +	unsigned head;
> +
> +	/*
> +	 * The cached sq head (or cq tail) serves two purposes:
> +	 *
> +	 * 1) allows us to batch the cost of updating the user visible
> +	 *    head updates.
> +	 * 2) allows the kernel side to track the head on its own, even
> +	 *    though the application is the one updating it.
> +	 */
> +	head = ctx->cached_sq_head;
> +	smp_rmb();

Undocumented barrier

> +	if (head == READ_ONCE(ring->r.tail))
> +		return false;
> +
> +	head = READ_ONCE(ring->array[head & ctx->sq_mask]);
> +	if (head < ctx->sq_entries) {
> +		s->index = head;
> +		s->sqe = &ctx->sq_sqes[head];
> +		ctx->cached_sq_head++;
> +		return true;
> +	}
> +
> +	/* drop invalid entries */
> +	ctx->cached_sq_head++;
> +	ring->dropped++;
> +	smp_wmb();

Undocumented barrier

> +	return false;
> +}
> +

> +static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
> +			  const sigset_t __user *sig, size_t sigsz)
> +{
> +	struct io_cq_ring *ring = ctx->cq_ring;
> +	sigset_t ksigmask, sigsaved;
> +	DEFINE_WAIT(wait);
> +	int ret = 0;
> +
> +	smp_rmb();
> +	if (READ_ONCE(ring->r.head) != READ_ONCE(ring->r.tail))
> +		return 0;
> +	if (!min_events)
> +		return 0;
> +
> +	if (sig) {
> +		ret = set_user_sigmask(sig, &ksigmask, &sigsaved, sigsz);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	do {
> +		prepare_to_wait(&ctx->wait, &wait, TASK_INTERRUPTIBLE);
> +
> +		ret = 0;
> +		smp_rmb();

Undocumented barrier

> +		if (READ_ONCE(ring->r.head) != READ_ONCE(ring->r.tail))
> +			break;
> +

There are undocumented smp_wmb()'s in 'io_uring: Add submission polling' as
well. It's really hard to tell where the corresponding barriers are and
what they are supposed to order.

Especially the barriers which are paired with user space barriers need some
careful documentation. What are the side effects if user space is missing a
barrier? Just user space seing unconsistent data or is there something
which goes the other way round and might cause havoc in the kernel?

Thanks,

	tglx

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
