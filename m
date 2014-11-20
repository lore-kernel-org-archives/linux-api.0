From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: user - Allow get request with empty driver name
Date: Thu, 20 Nov 2014 14:10 +0100
Message-ID: <2283056.kKnMJs7Bfg@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <20141120044650.GA28691@gondor.apana.org.au> <1706209.Hbu17X87TM@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <1706209.Hbu17X87TM@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 20. November 2014, 14:02:21 schrieb Stephan Mueller:

Hi Stephan,

> Am Donnerstag, 20. November 2014, 12:46:50 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Thu, Nov 20, 2014 at 05:23:23AM +0100, Stephan Mueller wrote:
> > > Here is the code:
> > > 
> > > static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr
> > > *in_nlh,
> > > 
> > > 			 struct nlattr **attrs)
> > > 
> > > {
> > > ...
> > > 
> > > 	if (!p->cru_driver_name[0])
> > > 	
> > > 		return -EINVAL;
> > 
> > OK let's fix this.
> > 
> > crypto: user - Allow get request with empty driver name
> > 
> > Currently all get requests with an empty driver name fail with
> > EINVAL.  Since most users actually want to supply an empty driver
> > name this patch removes this check.
> > 
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Acked-by: Stephan Mueller <smueller@chronox.de>

Although I acked the patch, it just occurred that your change modifies the 
user space interface such that you now cannot use a driver name any more.
> 
> > diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> > index e2a34fe..0bb30ac 100644
> > --- a/crypto/crypto_user.c
> > +++ b/crypto/crypto_user.c
> > @@ -201,10 +201,7 @@ static int crypto_report(struct sk_buff *in_skb,
> > struct nlmsghdr *in_nlh, if (!null_terminated(p->cru_name) ||
> > !null_terminated(p->cru_driver_name)) return -EINVAL;
> > 
> > -	if (!p->cru_driver_name[0])
> > -		return -EINVAL;
> > -
> > -	alg = crypto_alg_match(p, 1);
> > +	alg = crypto_alg_match(p, 0);

What about the following

if (p->cru_driver_name[0]
	alg = crypto_alg_match(p, 1);
else
	alg = crypto_alg_match(p, 0);

> > 
> >  	if (!alg)
> >  	
> >  		return -ENOENT;
> > 
> > Cheers,


-- 
Ciao
Stephan
