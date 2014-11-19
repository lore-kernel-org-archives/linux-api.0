From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v2 01/10] crypto: AF_ALG: add user space interface for
 AEAD
Date: Wed, 19 Nov 2014 14:45:49 +0800
Message-ID: <20141119064549.GA19918@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2398701.sGeMzIcHaz@tachyon.chronox.de>
 <20141119042704.GA19258@gondor.apana.org.au>
 <12318471.ucMNmAKX0e@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <12318471.ucMNmAKX0e-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 19, 2014 at 07:30:52AM +0100, Stephan Mueller wrote:
> 
> - these AD scatterlist chunks cannot be released after a normal encryption 
> operation. The associated data must be available for multiple operations. So, 
> while plaintext data is still flowing in, we need to keep operating with the 
> same AD.

We don't start an AEAD operation until the entire input has been
received.  Unlike ciphers you cannot process AEAD requests as you
go.

So there is no need to special-case AD chunks since you will have
everything at your disposal before you can feed the request to the
crypto API.

> Thus I am wondering how the rather static nature of the AD can fit with the 
> dynamic nature of the plaintext given the current implementation on how 
> plaintext is handled in the kernel.
> 
> To me, AD in league with an IV considering its rather static nature. Having 
> said that, the IV is also not transported via the plaintext interface, but via 
> a setsockopt. Shouldn't the AD be handled the same way?

AD is not like an IV at all.  An IV is a fixed-size (and small)
input while AD can be of any length.

Think about how this is used in real life.  For IPsec AD is the part
of the packet that we don't encrypt.  So there is nothing fundamentally
different between AD and the plain-text that we do encrypt except
that you don't encrypt it :)

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
