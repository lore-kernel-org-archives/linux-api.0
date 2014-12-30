From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 1/4] crypto: AF_ALG: add AEAD support
Date: Tue, 30 Dec 2014 22:30:28 +0100
Message-ID: <2502404.xd4K6Vrf3P@tachyon.chronox.de>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de> <29582980.qoHS2EjmLy@tachyon.chronox.de> <20141229173340.GA15790@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20141229173340.GA15790@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Am Dienstag, 30. Dezember 2014, 04:33:41 schrieb Herbert Xu:

Hi Herbert,

> On Mon, Dec 29, 2014 at 04:05:40PM +0100, Stephan Mueller wrote:
> > This would mean that the check must stay in recvmsg as only here we know
> > that the caller wants data to be processed.
> 
> On the send side you would do the check when MSG_MORE is unset.
> On the receive side you should stop waiting only when ctx->more
> is false and the send-side check succeeded.
> 
> Perhaps rename ctx->more to ctx->done and then you can use it
> to indicate to the receive side that we're ready and have valid
> data for it.  The receive side can then simply wait for ctx->done
> to become true.

I followed your advise and changed the sleep to wait for !ctx->more. Together 
with the patch suggested below that was just released, I removed aead_readable 
and aead_sufficient_data.

Though, I did not rename ctx->more to ctx->done due to the following:

- other AF_ALG implementations use ctx->more -- to aid code reviewers, I want 
to keep the logic as close together as possible

- I do not want to negate the check for MSG_MORE -- at least for me, negating 
flags always twists my mind when reading code.

The patch will come shortly after I tested all thoroughly.
> 
> > > PS we should add a length check for missing/partial auth tags
> > > to crypto_aead_decrypt.  We can then remove such checks from
> > > individual implementations.
> > 
> > I agree in full here. Shall I create such a patch together with the AEAD
> > AF_ALG interface, or can we merge the AEAD without that patch now and
> > create a separate patch later?
> 
> We should at least add a check in crypto_aead_decrypt first so as
> to guarantee nothing slips through.
> 
> Thanks,


-- 
Ciao
Stephan
