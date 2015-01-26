From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 26 Jan 2015 05:35:07 +0100
Message-ID: <13294516.zBBDkdi9pn@tachyon.chronox.de>
References: <1923793.K38mGRD6eo@tachyon.chronox.de> <6238416.vGUni1CI4i@tachyon.chronox.de> <20150126000631.GA18350@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150126000631.GA18350-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Montag, 26. Januar 2015, 11:06:31 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Jan 21, 2015 at 02:19:17AM +0100, Stephan Mueller wrote:
> > +	/*
> > +	 * Require exactly one IOV block as the AEAD operation is a one shot
> > +	 * due to the authentication tag.
> > +	 */
> > +	if (msg->msg_iter.nr_segs != 1)
> > +		return -ENOMSG;
> 
> Why does limit exist? The fact that you have to do it in one go does
> not limit the number of receive IOVs, at least not to one.

It seems I have misunderstood you in the last discussion.

in the last discussion [1] I tried to explain why I did not consider multiple 
IOVs. In the reply to my answer [2] I seem to have understood that the current 
implementation is fine.

So, shall I now implement the multiple IOVs approach outlined in [1]? If yes, 
how many IOVs shall I consider?
> 
> Cheers,

[1] http://www.spinics.net/lists/linux-crypto/msg12861.html

[2] http://www.spinics.net/lists/linux-crypto/msg12935.html
-- 
Ciao
Stephan
