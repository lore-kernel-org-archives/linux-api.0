From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v4 2/5] crypto: AF_ALG: add AEAD support
Date: Sun, 7 Dec 2014 07:28:23 +0800
Message-ID: <20141206232823.GB6409@gondor.apana.org.au>
References: <2105559.EmODblLYuY@tachyon.chronox.de>
 <4875720.jRoMDtjHB4@tachyon.chronox.de>
 <20141205154606.GA30180@gondor.apana.org.au>
 <45756810.oFuGYtKPb9@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <45756810.oFuGYtKPb9-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Dec 05, 2014 at 10:51:51PM +0100, Stephan Mueller wrote:
>
> Would you please be so kind and help me understand when some operations are 
> intended for the parent FD and when for the child FD?

If it changes the tfm it goes in the parent FD otherwise it's the
child FD.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
