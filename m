From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Date: Wed, 24 Dec 2014 09:54:33 +0100
Message-ID: <2159528.zCJB0y2Cap@tachyon.chronox.de>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de> <4537021.IXSvIIgcH4@tachyon.chronox.de> <20141223202401.GA2474@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141223202401.GA2474-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 24. Dezember 2014, 07:24:01 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Dec 23, 2014 at 03:52:27PM +0100, Stephan Mueller wrote:
> > Am Dienstag, 23. Dezember 2014, 22:56:26 schrieb Herbert Xu:
> > > In fact AEAD is rather awkward because you need to do everything
> > > in one go.  Perhaps we could adapt our kernel interface to allow
> > > partial AEAD operations?
> > 
> > I am not sure what you are referring to. The invocation does not need to
> > be in one go. You can have arbitrary number of sendmsg calls. But all
> > input data needs to be supplied before you call recvmsg.
> 
> What I mean is that unlike skcipher we cannot precede until we
> have the complete input.  So you cannot begin recvmsg until all
> input has been sent.

That is right, but isn't that the nature of AEAD ciphers in general? Even if 
you are in the kernel, you need to have all scatter lists together for one 
invocation of the AEAD cipher.

In case of a threaded application, the recvmsg does not start until all data 
is in, marked with the missing MSG_MORE -- see aead_readable.

All we can do is allow the user to use multiple system calls to collect all 
data before the AEAD operation takes place.

Or do you see another way on how to invoke the AEAD operation in a different 
manner?

The only item that I see that could be made better is the output side: 
currently the code allows only one and exactly one iovec to point to the 
output buffer. I would like to allow multiple iovec buffers that are filled 
with the output of one invocation of the AEAD operation. However, to avoid 
making a kernel-internal scratch buffer, I would need to somehow link the 
kernel-internal scatter lists with the iovec buffers. That only works when 
walking the iovec lists first and call af_alg_make_sg with every iovec entry 
and create the kernel-internal scatterlist representation. That is followed by 
the AEAD operation on the scatterlist.

If we agree on walking the iovec list first, then the question arises how many 
iovec list entries we allow at max. Is 16 entries a sensible value?

-- 
Ciao
Stephan
