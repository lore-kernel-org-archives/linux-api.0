From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v7 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 05 Jan 2015 11:54:13 +0100
Message-ID: <1732600.iOtRA28Mku@tachyon.chronox.de>
References: <6964260.mNa1jtPz7Z@tachyon.chronox.de> <6798882.ly1QjqTYep@tachyon.chronox.de> <20150105105105.GA25517@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150105105105.GA25517@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am Montag, 5. Januar 2015, 21:51:06 schrieb Herbert Xu:

Hi Herbert,

> On Mon, Jan 05, 2015 at 11:46:50AM +0100, Stephan Mueller wrote:
> > The need for that check lies in aead_recvmsg:
> >         /*
> >         
> >          * first chunk of input is AD -- one scatterlist entry is one
> >          page,
> >          * and we process only one scatterlist, the maximum size of AD is
> >          * one page
> >          */
> >         
> >         sg_init_table(&assoc, 1);
> >         sg_set_page(&assoc, sg_page(sg), ctx->aead_assoclen, sg->offset);
> >         aead_request_set_assoc(&ctx->aead_req, &assoc,
> >         ctx->aead_assoclen);
> > 
> > There you see that I only create an sg table with one entry for the AD. If
> > we would allow an arbitrary AD size, I would see the need of a for loop
> > in addition to the one directly beneath this AD scatterlist setting: one
> > for identifying how many sg entries I need to allocate and one for the
> > actual assignment.
> > 
> > As I felt that one page should be sufficient for the AD, I wanted to avoid
> > the extra overhead for another for loop.
> 
> Please remove the limit as otherwise we would never be able to
> add support for this in a future kernel as appliations won't be
> able to rely on it.
> 
> There is no such limit in the kernel interface and we shouldn't
> be adding one here.

Ok, will do.
> 
> Cheers,


-- 
Ciao
Stephan
