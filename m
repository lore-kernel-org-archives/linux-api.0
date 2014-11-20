From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: user - Allow get request with empty driver name
Date: Thu, 20 Nov 2014 15:45:26 +0800
Message-ID: <20141120074526.GB29544@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <1886827.KUDIsNtfuk@tachyon.chronox.de>
 <20141120041824.GA28612@gondor.apana.org.au>
 <3538055.XH2t7HNEVj@tachyon.chronox.de>
 <20141120044650.GA28691@gondor.apana.org.au>
 <20141120071141.GS6390@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141120071141.GS6390@secunet.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Stephan Mueller <smueller@chronox.de>, Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 20, 2014 at 08:11:42AM +0100, Steffen Klassert wrote:
>
> I think this is not sufficient, crypto_alg_match() will now return the first
> algorithm in crypto_alg_list that matches cra_name. We would need to extend
> crypto_alg_match() to return the algorithm with the highest priority in that
> case.

It doesn't really matter because all implementations must provide
exactly the same set of parameters for a given algorithm so it's
good enough for what Stephan wants to do.

But yes an interface to grab the highest priority algorithm would
be useful too so patches are welcome :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
