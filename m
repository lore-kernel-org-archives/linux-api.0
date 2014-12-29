From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v6 1/4] crypto: AF_ALG: add AEAD support
Date: Mon, 29 Dec 2014 21:33:19 +1100
Message-ID: <20141229103319.GB13334@gondor.apana.org.au>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de>
 <5002301.TQO37u96dE@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5002301.TQO37u96dE-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 25, 2014 at 11:01:47PM +0100, Stephan Mueller wrote:
>
> +	err = -ENOMEM;

This should be EINVAL.

> +	if (!aead_sufficient_data(ctx))
> +		goto unlock;

So we're checking two things here, one that we have enough data
for AD and two we have the authentication tag.  The latter is
redundant as the underlying implementation should be able to cope
with short input so we should only check the assoclen here.

Also this check should be moved to the sendmsg side as that'll
make it more obvious as to what went wrong.

PS we should add a length check for missing/partial auth tags
to crypto_aead_decrypt.  We can then remove such checks from
individual implementations.

Thanks,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
