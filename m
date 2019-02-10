From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/19] Add io_uring IO interface
Date: Sun, 10 Feb 2019 07:19:08 -0700
Message-ID: <eb713e6b-0fa4-852b-5a94-8e159aea0603@kernel.dk>
References: <20190209211346.26060-1-axboe@kernel.dk>
 <20190209211346.26060-6-axboe@kernel.dk>
 <alpine.DEB.2.21.1902101048100.8784@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <alpine.DEB.2.21.1902101048100.8784@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/10/19 5:03 AM, Thomas Gleixner wrote:
> On Sat, 9 Feb 2019, Jens Axboe wrote:
>> +static void io_commit_cqring(struct io_ring_ctx *ctx)
>> +{
>> +	struct io_cq_ring *ring = ctx->cq_ring;
>> +
>> +	if (ctx->cached_cq_tail != READ_ONCE(ring->r.tail)) {
>> +		/* order cqe stores with ring update */
> 
> This lacks a reference to the matching rmb()
> 
>> +		smp_wmb();
>> +		WRITE_ONCE(ring->r.tail, ctx->cached_cq_tail);
>> +		/* write side barrier of tail update, app has read side */
> 
> That's a bit meager. Can you please document the barriers which are paired
> with user space barriers very elaborate?

Agree, I added a lengthier comment at the top of the file to explain the
relationship between the kernel and application barriers.

Also documented all of them explicitly now, or referenced the top
comment.

>> +		if (READ_ONCE(ring->r.head) != READ_ONCE(ring->r.tail))
>> +			break;
>> +
> 
> There are undocumented smp_wmb()'s in 'io_uring: Add submission polling' as
> well. It's really hard to tell where the corresponding barriers are and
> what they are supposed to order.

Fixed those too.

> Especially the barriers which are paired with user space barriers need some
> careful documentation. What are the side effects if user space is missing a
> barrier? Just user space seing unconsistent data or is there something
> which goes the other way round and might cause havoc in the kernel?

The only side effect is that the application may not proceed as quickly
as it should, if it fails to notice a completion event come in. It'll
lead to it calling io_cqring_wait() ultimately, through a system call,
which will then ensure that it makes progress. But it may not have
needed to do that system call at all, if it used the barriers correctly.

I've also added a reference to the liburing git repo which has examples
of how to do it.

Thanks for your comments!

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
