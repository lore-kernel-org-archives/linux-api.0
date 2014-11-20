From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher info
Date: Thu, 20 Nov 2014 05:14:49 +0100
Message-ID: <1886827.KUDIsNtfuk@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <16101836.sTaxopCThb@tachyon.chronox.de> <20141120040748.GB28420@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141120040748.GB28420-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Steffen Klassert <steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 20. November 2014, 12:07:48 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Nov 20, 2014 at 05:03:24AM +0100, Stephan Mueller wrote:
> > crypto_user cannot be applied to the currently active cipher that one has
> > open with AF_ALG. For getting information, one has to call crypto_user
> > with the cra_driver_name of a cipher. (Why is that limitation, btw (see
> > crypto_report and the use of cru_driver_name?)
> 
> It doesn't matter because every implementation must supply exactly
> the same parameters as the reference implementation or it's buggy.
> IOW block size, IV size, supported key sizes etc. are intrinsic
> properties of the algorithm and not the implementation.
> 
I totally understand that. But you cannot supply a cra_name to crypto-user to 
get infos of that cipher as it is currently written. You have to use a 
cra_driver_name.

So, when I use a cra_name with AF_ALG, where would I get the cra_driver_name 
from to query the details from crypto_user?

Or we have to patch crypto_user to allow the use of cra_name -- which is 
currently explicitly disabled.

> Cheers,


-- 
Ciao
Stephan
