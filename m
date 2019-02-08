From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Fri, 8 Feb 2019 12:17:34 +0000
Message-ID: <bfd383aa-24fb-35ae-eef5-545ab0f493c7@gmail.com>
References: <20190207195552.22770-1-axboe@kernel.dk>
 <20190207195552.22770-14-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190207195552.22770-14-axboe@kernel.dk>
Content-Language: en-GB
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 07/02/2019 19:55, Jens Axboe wrote:
> We normally have to fget/fput for each IO we do on a file. Even with
> the batching we do, the cost of the atomic inc/dec of the file usage
> count adds up.
>
> This adds IORING_REGISTER_FILES, and IORING_UNREGISTER_FILES opcodes
> for the io_uring_register(2) system call. The arguments passed in must
> be an array of __s32 holding file descriptors, and nr_args should hold
> the number of file descriptors the application wishes to pin for the
> duration of the io_uring context (or until IORING_UNREGISTER_FILES is
> called).
>
> When used, the application must set IOSQE_FIXED_FILE in the sqe->flags
> member. Then, instead of setting sqe->fd to the real fd, it sets sqe->fd
> to the index in the array passed in to IORING_REGISTER_FILES.
>
> Files are automatically unregistered when the io_uring context is
> torn down. An application need only unregister if it wishes to
> register a new set of fds.
>
> Signed-off-by: Jens Axboe<axboe@kernel.dk>
> ---
>   fs/io_uring.c                 | 207 +++++++++++++++++++++++++++++-----
>   include/net/af_unix.h         |   1 +
>   include/uapi/linux/io_uring.h |   9 +-
>   net/unix/af_unix.c            |   2 +-
>   4 files changed, 188 insertions(+), 31 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 9d6233dc35ca..f2550efec60d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -29,6 +29,7 @@
>   #include <linux/net.h>
>   #include <net/sock.h>
>   #include <net/af_unix.h>
> +#include <net/scm.h>
>   #include <linux/anon_inodes.h>
>   #include <linux/sched/mm.h>
>   #include <linux/uaccess.h>
> @@ -101,6 +102,13 @@ struct io_ring_ctx {
>   		struct fasync_struct	*cq_fasync;
>   	} ____cacheline_aligned_in_smp;
>   
> +	/*
> +	 * If used, fixed file set. Writers must ensure that ->refs is dead,
> +	 * readers must ensure that ->refs is alive as long as the file* is
> +	 * used. Only updated through io_uring_register(2).
> +	 */
> +	struct scm_fp_list	*user_files;
> +
>   	/* if used, fixed mapped user buffers */
>   	unsigned		nr_user_bufs;
>   	struct io_mapped_ubuf	*user_bufs;
> @@ -148,6 +156,7 @@ struct io_kiocb {
>   	unsigned int		flags;
>   #define REQ_F_FORCE_NONBLOCK	1	/* inline submission attempt */
>   #define REQ_F_IOPOLL_COMPLETED	2	/* polled IO has completed */
> +#define REQ_F_FIXED_FILE	4	/* ctx owns file */
>   	u64			user_data;
>   	u64			error;
>   

> +static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
> +{
> +#if defined(CONFIG_NET)
> +	if (ctx->ring_sock) {
> +		struct sock *sock = ctx->ring_sock->sk;
> +		struct sk_buff *skb;
> +
> +		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
> +			kfree_skb(skb);
> +	}
> +#else
> +	int i;
> +
> +	for (i = 0; i < ctx->user_files->count; i++)
> +		fput(ctx->user_files->fp[i]);
> +
> +	kfree(ctx->user_files);
> +#endif
> +}
> +
> +static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
> +{
> +	if (!ctx->user_files)
> +		return -ENXIO;
> +
> +	__io_sqe_files_unregister(ctx);
> +	ctx->user_files = NULL;
> +	return 0;
> +}
> +
> +static int io_sqe_files_scm(struct io_ring_ctx *ctx)
> +{
> +#if defined(CONFIG_NET)
> +	struct scm_fp_list *fpl = ctx->user_files;
> +	struct sk_buff *skb;
> +	int i;
> +
> +	skb =  __alloc_skb(0, GFP_KERNEL, 0, NUMA_NO_NODE);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	skb->sk = ctx->ring_sock->sk;
> +	skb->destructor = unix_destruct_scm;
> +
> +	fpl->user = get_uid(ctx->user);
> +	for (i = 0; i < fpl->count; i++) {
> +		get_file(fpl->fp[i]);
> +		unix_inflight(fpl->user, fpl->fp[i]);
> +		fput(fpl->fp[i]);
> +	}
> +
> +	UNIXCB(skb).fp = fpl;
> +	skb_queue_head(&ctx->ring_sock->sk->sk_receive_queue, skb);

This code sounds elegant if you know about the existence of unix_gc(), 
but quite mysterious if you don't.  (E.g. why "inflight"?)  Could we 
have a brief comment, to comfort mortal readers on their journey?

/* A message on a unix socket can hold a reference to a file. This can 
cause a reference cycle. So there is a garbage collector for unix 
sockets, which we hook into here. */

I think this is bypassing too_many_unix_fds() though?  I understood that 
was intended to bound kernel memory allocation, at least in principle.

> +#endif

Also, this code relies on CONFIG_NET.  To handle the case where 
CONFIG_NET is not enabled, don't you still need to forbid registering an 
io_uring fd ?

> +	return 0;
> +}
> +
> +static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
> +				 unsigned nr_args)
> +{
> +	__s32 __user *fds = (__s32 __user *) arg;
> +	struct scm_fp_list *fpl;
> +	int fd, ret = 0;
> +	unsigned i;
> +
> +	if (ctx->user_files)
> +		return -EBUSY;
> +	if (!nr_args || nr_args > SCM_MAX_FD)
> +		return -EINVAL;
> +
> +	fpl = kzalloc(sizeof(*ctx->user_files), GFP_KERNEL);
> +	if (!fpl)
> +		return -ENOMEM;
> +	fpl->max = nr_args;
> +
> +	for (i = 0; i < nr_args; i++) {
> +		ret = -EFAULT;
> +		if (copy_from_user(&fd, &fds[i], sizeof(fd)))
> +			break;
> +
> +		fpl->fp[i] = fget(fd);
> +
> +		ret = -EBADF;
> +		if (!fpl->fp[i])
> +			break;
> +		fpl->count++;
> +		ret = 0;
> +	}
> +
> +	ctx->user_files = fpl;
> +	if (!ret)
> +		ret = io_sqe_files_scm(ctx);
> +	if (ret)
> +		io_sqe_files_unregister(ctx);
> +
> +	return ret;
> +}
> +
>   static int io_sq_offload_start(struct io_ring_ctx *ctx)
>   {
>   	int ret;
> @@ -1520,14 +1658,16 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
>   		destroy_workqueue(ctx->sqo_wq);
>   	if (ctx->sqo_mm)
>   		mmdrop(ctx->sqo_mm);
> +
> +	io_iopoll_reap_events(ctx);
> +	io_sqe_buffer_unregister(ctx);
> +	io_sqe_files_unregister(ctx);
> +
>   #if defined(CONFIG_NET)
>   	if (ctx->ring_sock)
>   		sock_release(ctx->ring_sock);
>   #endif
>   
> -	io_iopoll_reap_events(ctx);
> -	io_sqe_buffer_unregister(ctx);
> -
>   	io_mem_free(ctx->sq_ring);
>   	io_mem_free(ctx->sq_sqes);
>   	io_mem_free(ctx->cq_ring);
> @@ -1885,6 +2025,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>   			break;
>   		ret = io_sqe_buffer_unregister(ctx);
>   		break;
> +	case IORING_REGISTER_FILES:
> +		ret = io_sqe_files_register(ctx, arg, nr_args);
> +		break;
> +	case IORING_UNREGISTER_FILES:
> +		ret = -EINVAL;
> +		if (arg || nr_args)
> +			break;
> +		ret = io_sqe_files_unregister(ctx);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		break;

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
