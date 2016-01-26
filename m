From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/4] crypto: add algif_akcipher user space API
Date: Tue, 26 Jan 2016 19:12:09 +0800
Message-ID: <20160126111209.GA21069@gondor.apana.org.au>
References: <2602093.Yrp6nKrmX6@myon.chronox.de>
 <63219617.tVA5DWIBaO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <63219617.tVA5DWIBaO@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: tadeusz.struk@intel.com, marcel@holtmann.org, dwmw2@infradead.org, linux-api@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 25, 2016 at 10:34:53PM +0100, Stephan Mueller wrote:
> Am Freitag, 18. Dezember 2015, 00:49:57 schrieb Stephan Mueller:
> 
> Hi Herbert,
> 
> [...]
> 
> > Changes v3:
> >  * fix hack in alg_setkey and alg_setsockopt by avoding branches for
> >  setkey and setpubkey as pointed out by Marcel Holtmann
> >  * removal of patch for fixing SGL handling as this is already included
> 
> I have ported the code to 4.5. Shall I wait for comments from you for the 
> current code or shall I post v4 for the current cryptodev tree?

Until the objections in

http://www.gossamer-threads.com/lists/linux/kernel/2333253

are resolved I'm not taking any patches that export akcipher
via algif.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
