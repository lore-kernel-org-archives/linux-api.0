From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Date: Tue, 23 Dec 2014 22:56:26 +1100
Message-ID: <20141223115626.GA31450@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
 <3151022.sz5v21Vqeg@tachyon.chronox.de>
 <20141222112341.GA19532@gondor.apana.org.au>
 <101382546.xjTjAHLGAb@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <101382546.xjTjAHLGAb-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 23, 2014 at 09:14:43AM +0100, Stephan Mueller wrote:
>
> - the check aead_readable() immediately before this check implements the 
> blocking if we do not have sufficient data *and* more data is to be expected

Good point.

In fact AEAD is rather awkward because you need to do everything
in one go.  Perhaps we could adapt our kernel interface to allow
partial AEAD operations?

I want to be very careful before we pin down our user-space
interface since that's something that we cannot easily change
while the kernel interface can be modified at any time.

Thanks,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
