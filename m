From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v12 1/2] crypto: AF_ALG: add AEAD support
Date: Fri, 27 Feb 2015 22:49:44 +1300
Message-ID: <20150227094944.GA29071@gondor.apana.org.au>
References: <1681008.mocmysOoQU@tachyon.chronox.de>
 <2035690.30evPElJOm@tachyon.chronox.de>
 <7821728.KTX1G67VgF@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7821728.KTX1G67VgF@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: 'Quentin Gouchet' <quentin.gouchet@gmail.com>, Daniel Borkmann <dborkman@redhat.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, 'Linux API' <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 05, 2015 at 04:10:58PM +0100, Stephan Mueller wrote:
> Am Donnerstag, 29. Januar 2015, 21:24:45 schrieb Stephan Mueller:
> 
> Hi Herbert,
> 
> > This patch adds the AEAD support for AF_ALG.
> > 
> > The implementation is based on algif_skcipher, but contains heavy
> > modifications to streamline the interface for AEAD uses.
> > 
> > To use AEAD, the user space consumer has to use the salg_type named
> > "aead".
> 
> I just saw Al Viro's patch to use the iov_iter API in algif_skcipher.c. I 
> looked at it but lacked documentation for using it properly. Now I have a 
> template that I will incorporate into algif_aead.c

Please resubmit once you have done this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
