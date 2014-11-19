From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher
 info
Date: Wed, 19 Nov 2014 09:05:16 +0800
Message-ID: <20141119010516.GA18238@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2688209.3bGZus2TD9@tachyon.chronox.de>
 <20141118140822.GB12100@gondor.apana.org.au>
 <34547475.R7WC8JFgoJ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <34547475.R7WC8JFgoJ@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 19, 2014 at 02:02:33AM +0100, Stephan Mueller wrote:
>
> I am wondering why cryptouser.h is in include/linux -- shouldn't it be in 
> include/uapi/linux? Aren't the definitions in that header file needed for 
> userspace to talk to the netlink socket? I guess that is also the reason why I 

It should be.  I think crypto_user predates the uapi split so
that's probably why it's in the wrong place.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
