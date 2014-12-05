From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 2/5] crypto: AF_ALG: add AEAD support
Date: Fri, 05 Dec 2014 22:51:51 +0100
Message-ID: <45756810.oFuGYtKPb9@tachyon.chronox.de>
References: <2105559.EmODblLYuY@tachyon.chronox.de> <4875720.jRoMDtjHB4@tachyon.chronox.de> <20141205154606.GA30180@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20141205154606.GA30180@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Am Freitag, 5. Dezember 2014, 23:46:06 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Dec 03, 2014 at 08:57:24PM +0100, Stephan Mueller wrote:
> > +	if (ctx->merge) {
> > +		sg = sgl->sg + sgl->cur - 1;
> > +		len = min_t(unsigned long, len,
> > +			    PAGE_SIZE - sg->offset - sg->length);
> > +
> > +		err = memcpy_fromiovec(page_address(sg_page(sg)) +
> > +				       sg->offset + sg->length,
> > +				       msg->msg_iov, len);
> > +		if (err)
> > +			goto unlock;
> > +
> > +		sg->length += len;
> > +		ctx->merge = (sg->offset + sg->length) & (PAGE_SIZE - 1);
> > +
> > +		ctx->used += len;
> > +		copied += len;
> > +		size -= len;
> > +	}
> 
> Any reason why you got rid of the outer loop here? This will cause
> short writes I think.

You are absolutely right. I removed it as I do not have the multiple sgl 
entries. But now as you mentioned it, I still need it if size > 
aead_sndbuf(sk).

This will be fixed in the next installment.
> 
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

I was thinking about that for quite a while. My thought for the current 
approach was that the actual cipher operation happens in the child FD (i.e. 
after accept). AAD is delivered to that FD. Therefore, I thought that the size 
of the AAD can be specific to that operational FD.

If we move it to the parent setsockopt, all child FDs have the same AAD size. 
If you think that this is the right course of action, I can surely implement 
that.

Would you please be so kind and help me understand when some operations are 
intended for the parent FD and when for the child FD?

Thanks
-- 
Ciao
Stephan
