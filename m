From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 26 Jan 2015 15:41:14 +1100
Message-ID: <20150126044114.GA21056@gondor.apana.org.au>
References: <1923793.K38mGRD6eo@tachyon.chronox.de>
 <1526868.qaVuSjCOn7@tachyon.chronox.de>
 <20150126043218.GA20911@gondor.apana.org.au>
 <1793732.EQDAUxrRn5@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1793732.EQDAUxrRn5@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 26, 2015 at 05:39:27AM +0100, Stephan Mueller wrote:
>
> But does it really matter if we consider size == 0 or != at this point? In 
> case size == 0, the len calculation before the inner while loop will return 0. 
Of course it matters because you may die due to the aead_writable
check.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
