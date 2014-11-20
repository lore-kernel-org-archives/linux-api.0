From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: crypto: user - Allow get request with empty driver name
Date: Thu, 20 Nov 2014 14:07:33 +0100
Message-ID: <6473728.hPvPq1YETa@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <20141120074526.GB29544@gondor.apana.org.au> <20141120080406.GV6390@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141120080406.GV6390-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steffen Klassert <steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 20. November 2014, 09:04:06 schrieb Steffen Klassert:

Hi Steffen,

> On Thu, Nov 20, 2014 at 03:45:26PM +0800, Herbert Xu wrote:
> > On Thu, Nov 20, 2014 at 08:11:42AM +0100, Steffen Klassert wrote:
> > > I think this is not sufficient, crypto_alg_match() will now return the
> > > first algorithm in crypto_alg_list that matches cra_name. We would need
> > > to extend crypto_alg_match() to return the algorithm with the highest
> > > priority in that case.
> > 
> > It doesn't really matter because all implementations must provide
> > exactly the same set of parameters for a given algorithm so it's
> > good enough for what Stephan wants to do.
> 
> Ok, I see.
> 
> > But yes an interface to grab the highest priority algorithm would
> > be useful too so patches are welcome :)
> 
> Should be not too hard to return the highest priority algorithm
> instead of the first match with the existing interface, I'll see
> what I can do.

I think that for the purpose of using crypto-user in an AF_ALG scenario, even 
searching for the highest priporty will not necessarily give you the reference 
to the cipher used in AF_ALG. In the time between AF_ALG initialized a cipher 
and the time crypto-user is called, a new driver could register that may have 
even a higher priority than the one driver currently active for AF_ALG.

Therefore, from my perspective of AF_ALG and considering that all drivers of 
the same name should be identical, I would not suggest add more code to 
resolve the highest priority as I do not see the value of it.

-- 
Ciao
Stephan
