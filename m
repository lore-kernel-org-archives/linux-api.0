From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Date: Wed, 24 Dec 2014 07:24:01 +1100
Message-ID: <20141223202401.GA2474@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
 <101382546.xjTjAHLGAb@tachyon.chronox.de>
 <20141223115626.GA31450@gondor.apana.org.au>
 <4537021.IXSvIIgcH4@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4537021.IXSvIIgcH4-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 23, 2014 at 03:52:27PM +0100, Stephan Mueller wrote:
> Am Dienstag, 23. Dezember 2014, 22:56:26 schrieb Herbert Xu:
>
> > In fact AEAD is rather awkward because you need to do everything
> > in one go.  Perhaps we could adapt our kernel interface to allow
> > partial AEAD operations?
> 
> 
> I am not sure what you are referring to. The invocation does not need to be in 
> one go. You can have arbitrary number of sendmsg calls. But all input data 
> needs to be supplied before you call recvmsg.

What I mean is that unlike skcipher we cannot precede until we
have the complete input.  So you cannot begin recvmsg until all
input has been sent.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
