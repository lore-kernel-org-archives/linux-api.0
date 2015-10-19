From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Mon, 19 Oct 2015 09:14:09 +0200
Message-ID: <1665497.lHEipZEYQl@myon.chronox.de>
References: <1831785.BBs8Hj3CxY@myon.chronox.de> <20151019013230.GA3156@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20151019013230.GA3156@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Am Montag, 19. Oktober 2015, 09:32:30 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Oct 18, 2015 at 12:44:00PM +0200, Stephan Mueller wrote:
> > Hi,
> > 
> > This patch set adds the AF_ALG user space API to externalize the
> > asymmetric cipher API recently added to the kernel crypto API.
> > 
> > The patch set is tested with the user space library of libkcapi [1].
> > Use [1] test/test.sh for a full test run. The test covers the
> 
> > following scenarios:
> Thanks Stephan.  But I would prefer to defer this til after we have
> completed the conversion of current in-kernel users.  This is because
> changing the kernel interface is easy while changing the user-space
> interface is not.

Sure, let us wait.

However, I would suggest that you pull patch 1/5 as this is a bug fix that may 
affect even other users.

-- 
Ciao
Stephan
