From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v6 1/4] crypto: AF_ALG: add AEAD support
Date: Tue, 30 Dec 2014 04:33:41 +1100
Message-ID: <20141229173340.GA15790@gondor.apana.org.au>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de>
 <5002301.TQO37u96dE@tachyon.chronox.de>
 <20141229103319.GB13334@gondor.apana.org.au>
 <29582980.qoHS2EjmLy@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <29582980.qoHS2EjmLy-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Dec 29, 2014 at 04:05:40PM +0100, Stephan Mueller wrote:
>
> This would mean that the check must stay in recvmsg as only here we know that 
> the caller wants data to be processed.

On the send side you would do the check when MSG_MORE is unset.
On the receive side you should stop waiting only when ctx->more
is false and the send-side check succeeded.

Perhaps rename ctx->more to ctx->done and then you can use it
to indicate to the receive side that we're ready and have valid
data for it.  The receive side can then simply wait for ctx->done
to become true.

> > PS we should add a length check for missing/partial auth tags
> > to crypto_aead_decrypt.  We can then remove such checks from
> > individual implementations.
> 
> I agree in full here. Shall I create such a patch together with the AEAD 
> AF_ALG interface, or can we merge the AEAD without that patch now and create a 
> separate patch later?

We should at least add a check in crypto_aead_decrypt first so as
to guarantee nothing slips through.

Thanks,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
