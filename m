From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 01/10] crypto: AF_ALG: add user space interface for AEAD
Date: Wed, 19 Nov 2014 07:30:52 +0100
Message-ID: <12318471.ucMNmAKX0e@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <2398701.sGeMzIcHaz@tachyon.chronox.de> <20141119042704.GA19258@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141119042704.GA19258-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 19. November 2014, 12:27:04 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Nov 19, 2014 at 05:20:42AM +0100, Stephan Mueller wrote:
> > When looking deeper into skcipher_sendmsg, I see that the input data is
> > copied into the kernel using memcpy_fromiovec. The memory is allocated
> > before the memcpy call by skcipher_alloc_sgl.
> 
> Zero-copy is done through sendpage.

I am slightly at a loss here -- if you could give me a hint on how you think 
it can be implemented, I would be grateful.

Let us assume the AD || plaintext buffer is known to the kernel, either 
through sendpage or sendmsg. The entire buffer is split into chunks of 
scatterlists with ctx->tsgl. After processing one scatterlist from ctx->tsgl, 
that scatterlist is released via skcipher_pull_sgl.

Now, for AD, we need to consider:

- AD can span multiple ctx->tsgl chunks

- these AD scatterlist chunks cannot be released after a normal encryption 
operation. The associated data must be available for multiple operations. So, 
while plaintext data is still flowing in, we need to keep operating with the 
same AD.

Thus I am wondering how the rather static nature of the AD can fit with the 
dynamic nature of the plaintext given the current implementation on how 
plaintext is handled in the kernel.

To me, AD in league with an IV considering its rather static nature. Having 
said that, the IV is also not transported via the plaintext interface, but via 
a setsockopt. Shouldn't the AD be handled the same way?
> 
> Cheers,


-- 
Ciao
Stephan
