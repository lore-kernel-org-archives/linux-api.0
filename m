From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v4 4/5] crypto: AF_ALG: add random number generator support
Date: Fri, 05 Dec 2014 23:02:59 +0100
Message-ID: <7181491.MIJ5ay4MmI@tachyon.chronox.de>
References: <2105559.EmODblLYuY@tachyon.chronox.de> <1480776.TeURZV8VLa@tachyon.chronox.de> <20141205155359.GA30224@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141205155359.GA30224-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Freitag, 5. Dezember 2014, 23:53:59 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Dec 03, 2014 at 08:59:01PM +0100, Stephan Mueller wrote:
> > +static int rng_recvmsg(struct kiocb *unused, struct socket *sock,
> > +		       struct msghdr *msg, size_t len, int flags)
> > +{
> > +	struct sock *sk = sock->sk;
> > +	struct alg_sock *ask = alg_sk(sk);
> > +	struct rng_ctx *ctx = ask->private;
> > +	int err = -EFAULT;
> > +
> > +	if (len == 0)
> > +		return 0;
> > +	if (len > MAXSIZE)
> > +		len = MAXSIZE;
> > +
> > +	lock_sock(sk);
> 
> This lock simply protects ctx->result.  Since you're using a
> tiny buffer why not just put it on the stack?

When I developed the DRBG code, I got comments that 128 byte variables shall 
not be on the stack in kernel code.

But if you agree that I can put a 128 byte variable on the stack, I will see 
it done.

> 
> > +		u8 *buf = kmalloc(seedsize, GFP_KERNEL);
> > +		if (!buf)
> > +			goto err;
> > +		get_random_bytes(buf, seedsize);
> > +		ret = crypto_rng_reset(private, buf, len);
> 
> I think you should leave the seeding and the seed to the user.
> Perhaps do it through setsockopt (on the parent socket).

Sure. But please note that the seeding happens only when seedsize > 0. Such 
seeding therefore is not performed for krng, and the DRBG because both seed 
automatically.

Therefore, may I propose the following: We offer a setsockopt for (re)seeding. 
For all RNGs with seedsize > 0, we return EAGAIN for recvmsg until a 
setsockopt for at least seedsize is provided. That would imply that krng and 
DRBG would be usable without seeding from user space.

-- 
Ciao
Stephan
