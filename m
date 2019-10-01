From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring: use __kernel_timespec in timeout ABI
Date: Tue, 1 Oct 2019 09:38:40 -0600
Message-ID: <623e1d27-d3b1-3241-bfd4-eb94ce70da14@kernel.dk>
References: <20190930202055.1748710-1-arnd@arndb.de>
 <8d5d34da-e1f0-1ab5-461e-f3145e52c48a@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8d5d34da-e1f0-1ab5-461e-f3145e52c48a@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Stefan_B=c3=bchler?= <source@stbuehler.de>, Hannes Reinecke <hare@suse.com>, Jackie Liu <liuyun01@kylinos.cn>, Andrew Morton <akpm@linux-foundation.org>, Hristo Venev <hristo@venev.name>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/1/19 8:09 AM, Jens Axboe wrote:
> On 9/30/19 2:20 PM, Arnd Bergmann wrote:
>> All system calls use struct __kernel_timespec instead of the old struct
>> timespec, but this one was just added with the old-style ABI. Change it
>> now to enforce the use of __kernel_timespec, avoiding ABI confusion and
>> the need for compat handlers on 32-bit architectures.
>>
>> Any user space caller will have to use __kernel_timespec now, but this
>> is unambiguous and works for any C library regardless of the time_t
>> definition. A nicer way to specify the timeout would have been a less
>> ambiguous 64-bit nanosecond value, but I suppose it's too late now to
>> change that as this would impact both 32-bit and 64-bit users.
> 
> Thanks for catching that, Arnd. Applied.

On second thought - since there appears to be no good 64-bit timespec
available to userspace, the alternative here is including on in liburing.
That seems kinda crappy in terms of API, so why not just use a 64-bit nsec
value as you suggest? There's on released kernel with this feature yet, so
there's nothing stopping us from just changing the API to be based on
a single 64-bit nanosecond timeout.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dd094b387cab..de3d14fe3025 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1892,16 +1892,13 @@ static int io_timeout(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	unsigned count, req_dist, tail_index;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct list_head *entry;
-	struct timespec ts;
+	u64 timeout;
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->flags || sqe->ioprio || sqe->buf_index || sqe->timeout_flags ||
 	    sqe->len != 1)
 		return -EINVAL;
-	if (copy_from_user(&ts, (void __user *) (unsigned long) sqe->addr,
-	    sizeof(ts)))
-		return -EFAULT;
 
 	/*
 	 * sqe->off holds how many events that need to occur for this
@@ -1932,9 +1929,10 @@ static int io_timeout(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	list_add(&req->list, entry);
 	spin_unlock_irq(&ctx->completion_lock);
 
+	timeout = READ_ONCE(sqe->addr);
 	hrtimer_init(&req->timeout.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	req->timeout.timer.function = io_timeout_fn;
-	hrtimer_start(&req->timeout.timer, timespec_to_ktime(ts),
+	hrtimer_start(&req->timeout.timer, ns_to_ktime(timeout),
 			HRTIMER_MODE_REL);
 	return 0;
 }

-- 
Jens Axboe
