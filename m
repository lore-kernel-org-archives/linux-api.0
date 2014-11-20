From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: crypto: user - Allow get request with empty driver name
Date: Thu, 20 Nov 2014 14:02:21 +0100
Message-ID: <1706209.Hbu17X87TM@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <3538055.XH2t7HNEVj@tachyon.chronox.de> <20141120044650.GA28691@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141120044650.GA28691-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Steffen Klassert <steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 20. November 2014, 12:46:50 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Nov 20, 2014 at 05:23:23AM +0100, Stephan Mueller wrote:
> > Here is the code:
> > 
> > static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
> > 
> > 			 struct nlattr **attrs)
> > 
> > {
> > ...
> > 
> > 	if (!p->cru_driver_name[0])
> > 	
> > 		return -EINVAL;
> 
> OK let's fix this.
> 
> crypto: user - Allow get request with empty driver name
> 
> Currently all get requests with an empty driver name fail with
> EINVAL.  Since most users actually want to supply an empty driver
> name this patch removes this check.
> 
> Signed-off-by: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>

Acked-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
> 
> diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> index e2a34fe..0bb30ac 100644
> --- a/crypto/crypto_user.c
> +++ b/crypto/crypto_user.c
> @@ -201,10 +201,7 @@ static int crypto_report(struct sk_buff *in_skb, struct
> nlmsghdr *in_nlh, if (!null_terminated(p->cru_name) ||
> !null_terminated(p->cru_driver_name)) return -EINVAL;
> 
> -	if (!p->cru_driver_name[0])
> -		return -EINVAL;
> -
> -	alg = crypto_alg_match(p, 1);
> +	alg = crypto_alg_match(p, 0);
>  	if (!alg)
>  		return -ENOENT;
> 
> Cheers,


-- 
Ciao
Stephan
