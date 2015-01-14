From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v10 0/2] crypto: AF_ALG: add AEAD and RNG support
Date: Wed, 14 Jan 2015 16:31:44 +0100
Message-ID: <5006702.rWOQQ5L1VO@tachyon.chronox.de>
References: <5489736.JvWhZNrmuD@tachyon.chronox.de> <20150114094631.GB15294@localhost.localdomain> <20150114110011.GA18099@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20150114110011.GA18099@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Neil Horman <nhorman@tuxdriver.com>, Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, 'LKML' <linux-kernel@vger.kernel.org>, ABI/API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 14. Januar 2015, 22:00:11 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Jan 14, 2015 at 04:46:31AM -0500, Neil Horman wrote:
> > On Wed, Jan 14, 2015 at 04:52:29AM +0100, Stephan Mueller wrote:
> > > Hi,
> > > 
> > > This patch set adds AEAD and RNG support to the AF_ALG interface
> > > exported by the kernel crypto API. By extending AF_ALG with AEAD and RNG
> > > support, all cipher types the kernel crypto API allows access to are
> > > now accessible from userspace.
> > > 
> > >  crypto/Kconfig      |   9 +
> > >  crypto/Makefile     |   1 +
> > >  crypto/algif_aead.c | 680
> > >  ++++++++++++++++++++++++++++++++++++++++++++++++++++ 3 files changed,
> > >  690 insertions(+)
> > >  create mode 100644 crypto/algif_aead.c
> > 
> > Where are the RNG bits?
> 
> They've already been merged.

Please also see my change log for v7:
...
* RNG: patch dropped as it was applied
...

To ensure consistency, I did not change the intro part of my description.

> 
> Cheers,


-- 
Ciao
Stephan
