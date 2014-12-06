From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 2/5] crypto: AF_ALG: add AEAD support
Date: Sat, 06 Dec 2014 21:08:54 +0100
Message-ID: <1677221.HN3xC7fa4q@tachyon.chronox.de>
References: <2105559.EmODblLYuY@tachyon.chronox.de> <20141205154606.GA30180@gondor.apana.org.au> <45756810.oFuGYtKPb9@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <45756810.oFuGYtKPb9@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Am Freitag, 5. Dezember 2014, 22:51:51 schrieb Stephan Mueller:

Hi Herbert,

> > > +static struct proto_ops algif_aead_ops = {
> > > +	.family		=	PF_ALG,
> > > +
> > > +	.connect	=	sock_no_connect,
> > > +	.socketpair	=	sock_no_socketpair,
> > > +	.getname	=	sock_no_getname,
> > > +	.ioctl		=	sock_no_ioctl,
> > > +	.listen		=	sock_no_listen,
> > > +	.shutdown	=	sock_no_shutdown,
> > > +	.getsockopt	=	sock_no_getsockopt,
> > > +	.mmap		=	sock_no_mmap,
> > > +	.bind		=	sock_no_bind,
> > > +	.accept		=	sock_no_accept,
> > > +
> > > +	.release	=	af_alg_release,
> > > +	.sendmsg	=	aead_sendmsg,
> > > +	.sendpage	=	aead_sendpage,
> > > +	.recvmsg	=	aead_recvmsg,
> > > +	.poll		=	aead_poll,
> > > +	.setsockopt	=	aead_setsockopt,
> > 
> > No it should go into the parent setsockopt.  Perhaps add a setsockopt
> > to af_alg_type in order to keep this out of the generic code.
> 
> I was thinking about that for quite a while. My thought for the current
> approach was that the actual cipher operation happens in the child FD (i.e.
> after accept). AAD is delivered to that FD. Therefore, I thought that the
> size of the AAD can be specific to that operational FD.
> 
> If we move it to the parent setsockopt, all child FDs have the same AAD
> size. If you think that this is the right course of action, I can surely
> implement that.
> 
> Would you please be so kind and help me understand when some operations are
> intended for the parent FD and when for the child FD?

While implementing that request, I thought about setting the auth size as part 
of the msg control in sendmsg instead of setsockopt. This would save us a 
system call and thus CPU cycles.

Thus may I propose that instead of using setsockopt,  ALG_SET_AEAD_AUTHSIZE 
should be added to af_alg_cmsg_send the same way as ALG_SET_AEAD_ASSOCLEN.

Along that line, wouldn't it make sense to get rid of the setsockopt in 
general and move even setting the key into the msg control and thus into 
af_alg_cmsg_send? I understand that this is a change to the user space API.

Thanks

-- 
Ciao
Stephan
