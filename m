From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v7 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 5 Jan 2015 21:51:06 +1100
Message-ID: <20150105105105.GA25517@gondor.apana.org.au>
References: <6964260.mNa1jtPz7Z@tachyon.chronox.de>
 <1609020.xcc11L81HZ@tachyon.chronox.de>
 <20150105103159.GA24878@gondor.apana.org.au>
 <6798882.ly1QjqTYep@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6798882.ly1QjqTYep-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 05, 2015 at 11:46:50AM +0100, Stephan Mueller wrote:
> 
> The need for that check lies in aead_recvmsg:
> 
>         /*
>          * first chunk of input is AD -- one scatterlist entry is one page,
>          * and we process only one scatterlist, the maximum size of AD is
>          * one page
>          */
>         sg_init_table(&assoc, 1);
>         sg_set_page(&assoc, sg_page(sg), ctx->aead_assoclen, sg->offset);
>         aead_request_set_assoc(&ctx->aead_req, &assoc, ctx->aead_assoclen);
> 
> There you see that I only create an sg table with one entry for the AD. If we 
> would allow an arbitrary AD size, I would see the need of a for loop in 
> addition to the one directly beneath this AD scatterlist setting: one for 
> identifying how many sg entries I need to allocate and one for the actual 
> assignment.
> 
> As I felt that one page should be sufficient for the AD, I wanted to avoid the 
> extra overhead for another for loop.

Please remove the limit as otherwise we would never be able to
add support for this in a future kernel as appliations won't be
able to rely on it.

There is no such limit in the kernel interface and we shouldn't
be adding one here.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
