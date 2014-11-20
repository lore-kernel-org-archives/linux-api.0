From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher info
Date: Thu, 20 Nov 2014 05:23:23 +0100
Message-ID: <3538055.XH2t7HNEVj@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <1886827.KUDIsNtfuk@tachyon.chronox.de> <20141120041824.GA28612@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141120041824.GA28612-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Steffen Klassert <steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 20. November 2014, 12:18:24 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Nov 20, 2014 at 05:14:49AM +0100, Stephan Mueller wrote:
> > Or we have to patch crypto_user to allow the use of cra_name -- which is
> > currently explicitly disabled.
> 
> In what way is it disabled?

Here is the code:

static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
			 struct nlattr **attrs)
{
...
	if (!p->cru_driver_name[0])
		return -EINVAL;

	alg = crypto_alg_match(p, 1);
	if (!alg)
		return -ENOENT;
...

And crypto_alg_match is implemented as:

static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int 
exact)
{
...
		if (strlen(p->cru_driver_name))
			match = !strcmp(q->cra_driver_name,
					p->cru_driver_name);
		else if (!exact)
			match = !strcmp(q->cra_name, p->cru_name);
...
> 
> Cheers,


-- 
Ciao
Stephan
