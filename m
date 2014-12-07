From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v4 2/5] crypto: AF_ALG: add AEAD support
Date: Sun, 07 Dec 2014 13:56:18 +0100
Message-ID: <7942347.xfhvIblSTf@tachyon.chronox.de>
References: <2105559.EmODblLYuY@tachyon.chronox.de> <4875720.jRoMDtjHB4@tachyon.chronox.de> <20141205154606.GA30180@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141205154606.GA30180-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Freitag, 5. Dezember 2014, 23:46:06 schrieb Herbert Xu:

Hi Herbert,

> > +static struct proto_ops algif_aead_ops = {
> > +	.family		=	PF_ALG,
> > +
> > +	.connect	=	sock_no_connect,
> > +	.socketpair	=	sock_no_socketpair,
> > +	.getname	=	sock_no_getname,
> > +	.ioctl		=	sock_no_ioctl,
> > +	.listen		=	sock_no_listen,
> > +	.shutdown	=	sock_no_shutdown,
> > +	.getsockopt	=	sock_no_getsockopt,
> > +	.mmap		=	sock_no_mmap,
> > +	.bind		=	sock_no_bind,
> > +	.accept		=	sock_no_accept,
> > +
> > +	.release	=	af_alg_release,
> > +	.sendmsg	=	aead_sendmsg,
> > +	.sendpage	=	aead_sendpage,
> > +	.recvmsg	=	aead_recvmsg,
> > +	.poll		=	aead_poll,
> > +	.setsockopt	=	aead_setsockopt,
> 
> No it should go into the parent setsockopt.  Perhaps add a setsockopt
> to af_alg_type in order to keep this out of the generic code.

What about adding a setauthsize to af_alg_type that is called from the parent 
setsockopt? I would like to keep all user space interfaces as close together 
as possible. With a new setsockopt callback, I fear that user space interface 
handling may be scattered around.

Currently I am simply thinking about the following:

partent setsockopt:

        case ALG_SET_AEAD_AUTHSIZE:
                if (sock->state == SS_CONNECTED)
                        goto unlock;
                if (!type->setauthsize)
                        goto unlock;
                err = type->setauthsize(ask->private, optlen);

af_alg_type:

int (*setauthsize)(void *private, unsigned int authsize);

-- 
Ciao
Stephan
