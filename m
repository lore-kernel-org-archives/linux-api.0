From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v7 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 5 Jan 2015 21:31:59 +1100
Message-ID: <20150105103159.GA24878@gondor.apana.org.au>
References: <6964260.mNa1jtPz7Z@tachyon.chronox.de>
 <1609020.xcc11L81HZ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1609020.xcc11L81HZ-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 02, 2015 at 03:41:33PM +0100, Stephan Mueller wrote:
>
> +		if (!con.aead_assoclen)
> +			return -EINVAL;

AD being zero should be fine.

> +		/* aead_recvmsg limits the maximum AD size to one page */
> +		if (con.aead_assoclen > PAGE_SIZE)
> +			return -E2BIG;

I don't see any need to limit the size of the AD.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
