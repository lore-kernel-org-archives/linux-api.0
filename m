From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v9 1/2] crypto: AF_ALG: add AEAD support
Date: Sun, 11 Jan 2015 17:16:49 +0100
Message-ID: <2521789.meJGi556Ec@tachyon.chronox.de>
References: <41794881.9gBey4al6X@tachyon.chronox.de> <1518783.PStT3Q01B6@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518783.PStT3Q01B6-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Herbert Xu' <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Sonntag, 11. Januar 2015, 04:45:53 schrieb Stephan Mueller:

Hi Herbert,

> +static int aead_accept_parent(void *private, struct sock *sk)
> +{
> +	struct aead_ctx *ctx;
> +	struct alg_sock *ask = alg_sk(sk);
> +	unsigned int len = sizeof(*ctx) + crypto_aead_reqsize(private);
> +	unsigned int ivlen = crypto_aead_ivsize(private);
> +
> +	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +	memset(ctx, 0, len);
> +
> +	ctx->iv = sock_kmalloc(sk, ivlen, GFP_KERNEL);
> +	if (!ctx->iv) {
> +		sock_kfree_s(sk, ctx, len);
> +		return -ENOMEM;
> +	}
> +	memset(ctx->iv, 0, ivlen);
> +
> +	ctx->len = len;
> +	ctx->used = 0;
> +	ctx->more = 0;
> +	ctx->merge = 0;
> +	ctx->enc = 0;
> +	ctx->tsgl.cur = 0;

ctx->trunc = 0;

is missing here.

I would wait with a new patch once you had the chance to review the updates 
and provide comments.

Thanks
-- 
Ciao
Stephan
