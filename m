From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH 7/8] crypto: AF_ALG: add random number generator support
Date: Wed, 12 Nov 2014 17:54:23 +0100
Message-ID: <9137675.ZTbqvCU5Bi@tachyon.chronox.de>
References: <4738444.A2vZX1nNCo@tachyon.chronox.de> <1914037.Wy7EiDNG7B@tachyon.chronox.de> <546387B8.9050601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546387B8.9050601-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 12. November 2014, 17:15:52 schrieb Daniel Borkmann:

Hi Daniel,

thanks for the comments.

> On 11/12/2014 08:05 AM, Stephan Mueller wrote:
> > This patch adds the random number generator support for AF_ALG.
> > 
> > A random number generator's purpose is to generate data without
> > requiring the caller to provide any data. Therefore, the AF_ALG
> > interface handler for RNGs only implements a callback handler for
> > recvmsg.
> 
> ...
> 
> > +static int rng_recvmsg(struct kiocb *unused, struct socket *sock,
> > +		       struct msghdr *msg, size_t len, int flags)
> > +{
> > +	struct sock *sk = sock->sk;
> > +	struct alg_sock *ask = alg_sk(sk);
> > +	struct rng_ctx *ctx = ask->private;
> > +	int err = -EFAULT;
> > +
> > +	if (0 == len)
> 
> if (len == 0)
> 	...
> 
> [And also other places.]
> 
> We don't use Yoda condition style in the kernel.

Well, there is a very good reason for using the approach I have: we all have 
done the error of forgetting the second = sign.

In my case, the compiler will complain and we fix the error right away.

In your case, nobody is complaining but we introduced a nasty, potentially 
hard to debug error. Thus, I very much like to keep my version just to be on 
the safe side.

Note, there was even a backdoor I have seen where the missing 2nd equal sign 
introduced a privilege escalation.

Therefore, my standard coding practice is to have a fixed value on the left 
side and the variable on the right side of any comparison.
> 
> > +		return 0;
> > +	if (MAXSIZE < len)
> > +		len = MAXSIZE;
> > +
> > +	lock_sock(sk);
> > +	len = crypto_rng_get_bytes(ctx->drng, ctx->result, len);
> > +	if (0 > len)
> > +		goto unlock;
> > +
> > +	err = memcpy_toiovec(msg->msg_iov, ctx->result, len);
> > +	memset(ctx->result, 0, err);
> > +
> 
> This looks buggy.
> 
> If copy_to_user() fails from within memcpy_toiovec(), we call memset()
> with a negative return value which is interpreted as size_t and thus
> causes a buffer overflow writing beyond ctx->result, no?
> 
> If it succeeds, we call memset(ctx->result, 0, 0) .....

Right, good catch, I have to add a catch for negative error here.

> 
> > +unlock:
> > +	release_sock(sk);
> > +
> > +	return err ? err : len;
> > +}
> > +
> > +static struct proto_ops algif_rng_ops = {
> > +	.family		=	PF_ALG,
> > +
> > +	.connect	=	sock_no_connect,
> > +	.socketpair	=	sock_no_socketpair,
> > +	.getname	=	sock_no_getname,
> > +	.ioctl		=	sock_no_ioctl,
> > +	.listen		=	sock_no_listen,
> > +	.shutdown	=	sock_no_shutdown,
> > +	.getsockopt	=	sock_no_getsockopt,
> > +	.mmap		=	sock_no_mmap,
> > +	.bind		=	sock_no_bind,
> > +	.accept		=	sock_no_accept,
> > +	.setsockopt	=	sock_no_setsockopt,
> > +	.poll		=	sock_no_poll,
> > +	.sendmsg	=	sock_no_sendmsg,
> > +	.sendpage	=	sock_no_sendpage,
> > +
> > +	.release	=	af_alg_release,
> > +	.recvmsg	=	rng_recvmsg,
> > +};
> > +
> > +static void *rng_bind(const char *name, u32 type, u32 mask)
> > +{
> > +	return crypto_alloc_rng(name, type, mask);
> > +}
> > +
> > +static void rng_release(void *private)
> > +{
> > +	crypto_free_rng(private);
> > +}
> > +
> > +static void rng_sock_destruct(struct sock *sk)
> > +{
> > +	struct alg_sock *ask = alg_sk(sk);
> > +	struct rng_ctx *ctx = ask->private;
> > +
> > +	memset(ctx->result, 0, MAXSIZE);
> 
> memset(ctx->result, 0, sizeof(ctx->result));

Ok, if this is desired, fine with me.
> 
> > +	sock_kfree_s(sk, ctx, ctx->len);
> > +	af_alg_release_parent(sk);
> > +}
> > +
> > +static int rng_accept_parent(void *private, struct sock *sk)
> > +{
> > +	struct rng_ctx *ctx;
> > +	struct alg_sock *ask = alg_sk(sk);
> > +	unsigned int len = sizeof(*ctx);
> > +	int seedsize = crypto_rng_seedsize(private);
> > +	int ret = -ENOMEM;
> > +
> > +	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
> > +	if (!ctx)
> > +		return -ENOMEM;
> > +	memset(ctx->result, 0, MAXSIZE);
> 
> Ditto...

Will do.

> 
> > +	ctx->len = len;
> > +
> > +	if (seedsize) {
> > +		u8 *buf = kmalloc(seedsize, GFP_KERNEL);
> > +		if (!buf)
> > +			goto err;
> > +		get_random_bytes(buf, seedsize);
> > +		ret = crypto_rng_reset(private, buf, len);
> > +		kzfree(buf);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ciao
Stephan
