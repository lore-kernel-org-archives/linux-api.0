From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Date: Mon, 22 Dec 2014 22:23:41 +1100
Message-ID: <20141222112341.GA19532@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
 <3151022.sz5v21Vqeg@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3151022.sz5v21Vqeg@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Dec 07, 2014 at 11:22:30PM +0100, Stephan Mueller wrote:
>
> +static inline bool aead_sufficient_data(struct aead_ctx *ctx)
> +{
> +	unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx->aead_req));
> +
> +	return (ctx->used >= (ctx->aead_assoclen + ctx->enc ? : as ));

Is this supposed to be

	return (ctx->used >= (ctx->aead_assoclen + (ctx->enc ?: as)));

> +static int aead_recvmsg(struct kiocb *unused, struct socket *sock,
> +			    struct msghdr *msg, size_t ignored, int flags)
> +{

...

> +	err = -ENOMEM;
> +	if (!aead_sufficient_data(ctx))
> +		goto unlock;

You should just block if there is insufficient input.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
