From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher info
Date: Thu, 20 Nov 2014 05:03:24 +0100
Message-ID: <16101836.sTaxopCThb@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <2688209.3bGZus2TD9@tachyon.chronox.de> <20141118140822.GB12100@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141118140822.GB12100-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, Steffen Klassert <steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 18. November 2014, 22:08:23 schrieb Herbert Xu:

Hi Herbert, Steffen,

> On Sun, Nov 16, 2014 at 03:24:25AM +0100, Stephan Mueller wrote:
> > The AF_ALG interface allows normal cipher (hash, encrypt, decrypt).
> > However, it does not allow user space to obtain the following generic
> > 
> > information about the currently active cipher:
> > 	* block size of the cipher
> > 	
> > 	* IV size of the cipher
> > 	
> > 	* for AEAD, the maximum authentication tag size
> > 
> > The patch adds a getsockopt interface for the symmetric ciphers to
> > answer such information requests from user space.
> > 
> > The kernel crypto API function calls are used to obtain the real data.
> > As all data are simple integer values, the getsockopt handler function
> > uses put_user() to return the integer value to user space in the
> > *optval parameter of getsockopt.
> > 
> > Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
> 
> We already have crypto_user so you should be extending that to
> cover what's missing.

After playing a bit with the interface, I think it falls short supporting 
AF_ALG in the following way:

crypto_user cannot be applied to the currently active cipher that one has open 
with AF_ALG. For getting information, one has to call crypto_user with the 
cra_driver_name of a cipher. (Why is that limitation, btw (see crypto_report 
and the use of cru_driver_name?)

When we open AF_ALG with the typical approach of simply a cra_name, you have 
no idea which cipher is selected. User space has no way to obtain the 
information on which particular cipher implementation is used with 
crypto_user.

That means, to use crypto_user, we would first have to translate a cra_name 
into a cra_driver_name. Granted, any cra_driver_name for the given cra_name 
would work. But how would such a resolution be implemented? The only way would 
be via /proc/crypto. But that file does not contain all cipher / block 
chaining permutations. For example, ccm(aes) is not listed in /proc/crypto at 
all (even after using it via the kernel crypto API -- i.e. there is an 
accessible ccm(aes) implementation). Therefore, there is no way to resolve 
ccm(aes) to a cra_driver_name. 

Btw: is there an example that uses that interface? The ordering of data 
structures in the netlink message is not really clear from looking at the 
code.
> 
> PS These paramters should not vary depending on the implementation,
> if they do then one of the implementations must be buggy.
> 
> Cheers,


-- 
Ciao
Stephan
