From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: user - Allow get request with empty driver name
Date: Thu, 20 Nov 2014 17:08:42 +0100
Message-ID: <6655976.jRkjMUZ19x@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <2283056.kKnMJs7Bfg@tachyon.chronox.de> <20141120134029.GA31411@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20141120134029.GA31411@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 20. November 2014, 21:40:29 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Nov 20, 2014 at 02:10:00PM +0100, Stephan Mueller wrote:
> > What about the following
> > 
> > if (p->cru_driver_name[0]

If the driver name is not empty
> > 
> > 	alg = crypto_alg_match(p, 1);

Do an exact match using the driver name
> > 
> > else
> > 
> > 	alg = crypto_alg_match(p, 0);

Otherise use the generic name for a fuzzy match.
> 
> If cru_driver_name is not empty then exact will never be used, no?

If the code suggestion does not follow my words outlined above, I want my 
words to be considered ;-)

Yet, I am unsure where the code deviates from my words.

> 
> Cheers,


-- 
Ciao
Stephan
