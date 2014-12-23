From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Date: Tue, 23 Dec 2014 09:14:43 +0100
Message-ID: <101382546.xjTjAHLGAb@tachyon.chronox.de>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de> <3151022.sz5v21Vqeg@tachyon.chronox.de> <20141222112341.GA19532@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141222112341.GA19532@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Am Montag, 22. Dezember 2014, 22:23:41 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Dec 07, 2014 at 11:22:30PM +0100, Stephan Mueller wrote:
> > +static inline bool aead_sufficient_data(struct aead_ctx *ctx)
> > +{
> > +	unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx-
>aead_req));
> > +
> > +	return (ctx->used >= (ctx->aead_assoclen + ctx->enc ? : as ));
> 
> Is this supposed to be
> 
> 	return (ctx->used >= (ctx->aead_assoclen + (ctx->enc ?: as)));

Thanks, will be fixed in the next iteration
> 
> > +static int aead_recvmsg(struct kiocb *unused, struct socket *sock,
> > +			    struct msghdr *msg, size_t ignored, int flags)
> > +{
> 
> ...
> 
> > +	err = -ENOMEM;
> > +	if (!aead_sufficient_data(ctx))
> > +		goto unlock;
> 
> You should just block if there is insufficient input.
> 
I do not concur here due to the following:

- the check aead_readable() immediately before this check implements the 
blocking if we do not have sufficient data *and* more data is to be expected

- this very check for aead_sufficient_data() comes into play if the caller 
does not have more data (i.e. ctx->more is zero). In this case, more data is 
not to be expected and we cannot wait as this would be a deadlock in user 
space.

-- 
Ciao
Stephan
