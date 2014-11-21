From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: crypto: user - Allow get request with empty driver name
Date: Fri, 21 Nov 2014 10:31:31 +0800
Message-ID: <20141121023131.GA3873@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2283056.kKnMJs7Bfg@tachyon.chronox.de>
 <20141120134029.GA31411@gondor.apana.org.au>
 <6655976.jRkjMUZ19x@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6655976.jRkjMUZ19x-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Steffen Klassert <steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 20, 2014 at 05:08:42PM +0100, Stephan Mueller wrote:
> Am Donnerstag, 20. November 2014, 21:40:29 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Thu, Nov 20, 2014 at 02:10:00PM +0100, Stephan Mueller wrote:
> > > What about the following
> > > 
> > > if (p->cru_driver_name[0]
> 
> If the driver name is not empty
> > > 
> > > 	alg = crypto_alg_match(p, 1);
> 
> Do an exact match using the driver name
> > > 
> > > else
> > > 
> > > 	alg = crypto_alg_match(p, 0);
> 
> Otherise use the generic name for a fuzzy match.
> > 
> > If cru_driver_name is not empty then exact will never be used, no?
> 
> If the code suggestion does not follow my words outlined above, I want my 
> words to be considered ;-)
> 
> Yet, I am unsure where the code deviates from my words.

No I am asking how is this different from my patch?

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
