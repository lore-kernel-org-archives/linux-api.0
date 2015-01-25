From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 26 Jan 2015 10:54:30 +1100
Message-ID: <20150125235430.GA18212@gondor.apana.org.au>
References: <1923793.K38mGRD6eo@tachyon.chronox.de>
 <6238416.vGUni1CI4i@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6238416.vGUni1CI4i@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 21, 2015 at 02:19:17AM +0100, Stephan Mueller wrote:
>
> +static void aead_data_wakeup(struct sock *sk)
> +{
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct aead_ctx *ctx = ask->private;
> +	struct socket_wq *wq;
> +
> +	if (ctx->more)
> +		return;

You should also check for ctx->used here.  This can be called after
a zero-sized write.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
