From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Date: Fri, 26 Dec 2014 07:28:31 +1100
Message-ID: <20141225202830.GA18794@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
 <4537021.IXSvIIgcH4@tachyon.chronox.de>
 <20141223202401.GA2474@gondor.apana.org.au>
 <2159528.zCJB0y2Cap@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2159528.zCJB0y2Cap-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 24, 2014 at 09:54:33AM +0100, Stephan Mueller wrote:
> 
> That is right, but isn't that the nature of AEAD ciphers in general? Even if 
> you are in the kernel, you need to have all scatter lists together for one 
> invocation of the AEAD cipher.

It's actually only the nature of certain algorithms like CCM which
requires the total length to start the operation.  Most AEAD
algorithms can be implemented in a way that allows piecemeal
operation.  However, as the only users of AEAD is IPsec, it's
probably not worth adding more complexity for now.

So let's proceed with your current solution.

Thanks,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
