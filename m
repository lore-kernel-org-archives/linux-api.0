From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher info
Date: Wed, 19 Nov 2014 02:02:33 +0100
Message-ID: <34547475.R7WC8JFgoJ@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <2688209.3bGZus2TD9@tachyon.chronox.de> <20141118140822.GB12100@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141118140822.GB12100@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, Steffen Klassert <steffen.klassert@secunet.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 18. November 2014, 22:08:23 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Nov 16, 2014 at 03:24:25AM +0100, Stephan Mueller wrote:
> > The AF_ALG interface allows normal cipher (hash, encrypt, decrypt).
> > However, it does not allow user space to obtain the following generic
> > 
> > information about the currently active cipher:
> > 	* block size of the cipher
> > 	
> > 	* IV size of the cipher
> > 	
> > 	* for AEAD, the maximum authentication tag size
> > 
> > The patch adds a getsockopt interface for the symmetric ciphers to
> > answer such information requests from user space.
> > 
> > The kernel crypto API function calls are used to obtain the real data.
> > As all data are simple integer values, the getsockopt handler function
> > uses put_user() to return the integer value to user space in the
> > *optval parameter of getsockopt.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> We already have crypto_user so you should be extending that to
> cover what's missing.

Looking into that, I think nothing is missing -- thanks for the pointer. Thus 
I think I can withdraw that patch and just simply update libkcapi to use that 
user space netlink interface.

Though, I yet have to try using that interface ;-)

I am wondering why cryptouser.h is in include/linux -- shouldn't it be in 
include/uapi/linux? Aren't the definitions in that header file needed for 
userspace to talk to the netlink socket? I guess that is also the reason why I 
do not see the interface API details in /usr/linux on my F21 system.
> 
> PS These paramters should not vary depending on the implementation,
> if they do then one of the implementations must be buggy.
> 
> Cheers,


-- 
Ciao
Stephan
