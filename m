From: Steffen Klassert <steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher
 info
Date: Thu, 20 Nov 2014 08:05:52 +0100
Message-ID: <20141120070552.GR6390@secunet.com>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2688209.3bGZus2TD9@tachyon.chronox.de>
 <20141118140822.GB12100@gondor.apana.org.au>
 <16101836.sTaxopCThb@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <16101836.sTaxopCThb-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 20, 2014 at 05:03:24AM +0100, Stephan Mueller wrote:
> Am Dienstag, 18. November 2014, 22:08:23 schrieb Herbert Xu:
> 
> Hi Herbert, Steffen,
> 
> > 
> > We already have crypto_user so you should be extending that to
> > cover what's missing.
> 
> After playing a bit with the interface, I think it falls short supporting 
> AF_ALG in the following way:
> 
> crypto_user cannot be applied to the currently active cipher that one has open 
> with AF_ALG. For getting information, one has to call crypto_user with the 
> cra_driver_name of a cipher. (Why is that limitation, btw (see crypto_report 
> and the use of cru_driver_name?)

crypto_report() was intended to provide informations of one implementation
of a algorithm, so it was required to specify this algorithm exactly with
cru_driver_name.

We could extend crypto_report() to provide informations of the algorithm
with the highest priority that matches cra_name.

Or, we also have crypto_dump_report(). This basically provides informations
on all instantiated algorithms, similar to /proc/crypto. We could extend
this in a way that you can provide a cra_name. Then it can dump out the
informations of all algorithms that match cra_name.
