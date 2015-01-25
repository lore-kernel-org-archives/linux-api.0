From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 26 Jan 2015 10:59:08 +1100
Message-ID: <20150125235908.GC18212@gondor.apana.org.au>
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
> +		if (!aead_writable(sk)) {
> +			/* user space sent too much data */
> +			aead_put_sgl(sk);
> +			err = -EMSGSIZE;
> +			goto unlock;
> +		}
> +
> +		/* allocate a new page */
> +		len = min_t(unsigned long, size, aead_sndbuf(sk));
> +		while (len) {
> +			int plen = 0;
> +
> +			if (sgl->cur >= ALG_MAX_PAGES) {
> +				err = -E2BIG;

Should reset the socket just like EMSGSIZE above.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
