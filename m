From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v5 5/8] crypto: AF_ALG: add user space interface for RNG
Date: Mon, 22 Dec 2014 22:27:30 +1100
Message-ID: <20141222112730.GB19532@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
 <3380968.kTQNpvjKFa@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3380968.kTQNpvjKFa-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Dec 07, 2014 at 11:23:48PM +0100, Stephan Mueller wrote:
> Allow user space to seed / reset the RNG via a setsockopt.
> 
> This patch reuses alg_setkey to copy data into the kernel. The
> alg_setkey is now used for two mechanisms: setkey and seeding.
> The function is extended by the providing the function pointer
> to the function handling the copied data.
> 
> As the alg_setkey is now usable for more than just setkey, it is renamed
> to alg_setop.

Just call it setkey, there is no harm in treating the seed as a key
is there?

In fact we should have done this from the very start.
crypto_rng_reset should be renamed crypto_rng_setkey.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
