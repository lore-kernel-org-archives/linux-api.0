From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 06/10] crypto: AF_ALG: make setkey optional
Date: Wed, 19 Nov 2014 03:36:45 +0100
Message-ID: <9023565.IShqyyQhGs@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <2196615.OgfUNzPKdf@tachyon.chronox.de> <20141118141013.GC12100@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141118141013.GC12100@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 18. November 2014, 22:10:13 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Nov 16, 2014 at 03:26:58AM +0100, Stephan Mueller wrote:
> > The current AF_ALG implementation requires that a userspace interface
> > implementation must provide a callback for setkey. Such a call is not
> > appliable to random number generators.
> > 
> > To prepare AF_ALG for the addition of a random number generator user
> > space interface, this function callback invocation is made optional.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> Did you actually try this? AFAICS setkey is already optional.

You are correct. I tested the kernel without my patch and the setkey on the 
RNG handle is rejected. I now also see the check already present in the 
alg_setkey function.

This patch will be removed from a new patchset.
> 
> Cheers,


-- 
Ciao
Stephan
