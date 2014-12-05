From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 4/5] crypto: AF_ALG: add random number generator
 support
Date: Fri, 5 Dec 2014 23:53:59 +0800
Message-ID: <20141205155359.GA30224@gondor.apana.org.au>
References: <2105559.EmODblLYuY@tachyon.chronox.de>
 <1480776.TeURZV8VLa@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1480776.TeURZV8VLa@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 03, 2014 at 08:59:01PM +0100, Stephan Mueller wrote:
>
> +static int rng_recvmsg(struct kiocb *unused, struct socket *sock,
> +		       struct msghdr *msg, size_t len, int flags)
> +{
> +	struct sock *sk = sock->sk;
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct rng_ctx *ctx = ask->private;
> +	int err = -EFAULT;
> +
> +	if (len == 0)
> +		return 0;
> +	if (len > MAXSIZE)
> +		len = MAXSIZE;
> +
> +	lock_sock(sk);

This lock simply protects ctx->result.  Since you're using a
tiny buffer why not just put it on the stack?

> +		u8 *buf = kmalloc(seedsize, GFP_KERNEL);
> +		if (!buf)
> +			goto err;
> +		get_random_bytes(buf, seedsize);
> +		ret = crypto_rng_reset(private, buf, len);

I think you should leave the seeding and the seed to the user.
Perhaps do it through setsockopt (on the parent socket).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
