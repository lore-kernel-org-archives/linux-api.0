From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v8 1/2] crypto: AF_ALG: add AEAD support
Date: Thu, 8 Jan 2015 22:09:31 +1100
Message-ID: <20150108110931.GA8568@gondor.apana.org.au>
References: <33040723.pAXIT3fl8h@tachyon.chronox.de>
 <6260799.4x68Msg3Li@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6260799.4x68Msg3Li-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 07, 2015 at 04:51:38PM +0100, Stephan Mueller wrote:
>
> +		if (!aead_writable(sk)) {
> +			/*
> +			 * If there is more data to be expected, but we cannot
> +			 * write more data, forcefully define that we do not
> +			 * expect more data to invoke the AEAD operation. This
> +			 * prevents a deadlock in user space.
> +			 */
> +			ctx->more = 0;

We should return EMSGSIZE here.  Also we should clear out the
existing data so that the socket may be reused again.

> +	ctx->more = msg->msg_flags & MSG_MORE;
> +	if (!ctx->more && !aead_sufficient_data(ctx))
> +		err = -EINVAL;

Ditto, we should discard the data that's queued up.  Also perhaps
use EBADMSG instead of EINVAL.

> +	/*
> +	 * Require exactly one IOV block as the AEAD operation is a one shot
> +	 * due to the authentication tag.
> +	 */
> +	if (msg->msg_iter.nr_segs != 1)
> +		return -ENOMSG;

Why does the receive buffer have to be contiguous?

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
