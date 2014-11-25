From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 4/7] crypto: AF_ALG: add AEAD support
Date: Tue, 25 Nov 2014 22:58:50 +0800
Message-ID: <20141125145850.GD8541@gondor.apana.org.au>
References: <4088013.2O8zCP0xXa@tachyon.chronox.de>
 <2175035.5IWBGpA0Ko@tachyon.chronox.de>
 <20141124142945.GB31469@gondor.apana.org.au>
 <5492722.Cc6uZ9OM2L@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5492722.Cc6uZ9OM2L@tauon>
Sender: linux-crypto-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 24, 2014 at 03:58:34PM +0100, Stephan Mueller wrote:
> Ok. But in the code you see that skcipher is a 100% subset of AEAD. For 
> AEAD, all we need to do in addition to normal symmetric ciphers is to 
> select the AEAD kernel crypto API calls, to locate and use the AD and to 
> ensure we have the right memory size to process the tag.

There is still one fundamental difference between AEAD and ciphers.
Namely that ciphers can operate as you go while AEAD requests must
be done in one lot.  So that should make the AEAD code simpler vs.
ciphers.

I think the best course of action for now is to start with sharing
no code and then chop bits off as we see fit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
