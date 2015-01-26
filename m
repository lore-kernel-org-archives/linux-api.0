From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 26 Jan 2015 05:26:33 +0100
Message-ID: <1526868.qaVuSjCOn7@tachyon.chronox.de>
References: <1923793.K38mGRD6eo@tachyon.chronox.de> <6238416.vGUni1CI4i@tachyon.chronox.de> <20150125235550.GB18212@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150125235550.GB18212-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Montag, 26. Januar 2015, 10:55:50 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Jan 21, 2015 at 02:19:17AM +0100, Stephan Mueller wrote:
> > +		/* use the existing memory in an allocated page */
> > +		if (ctx->merge) {
> > +			sg = sgl->sg + sgl->cur - 1;
> > +			len = min_t(unsigned long, len,
> > +				    PAGE_SIZE - sg->offset - sg->length);
> > +			err = memcpy_from_msg(page_address(sg_page(sg)) +
> > +					      sg->offset + sg->length,
> > +					      msg, len);
> > +			if (err)
> > +				goto unlock;
> > +
> > +			sg->length += len;
> > +			ctx->merge = (sg->offset + sg->length) &
> > +				     (PAGE_SIZE - 1);
> > +
> > +			ctx->used += len;
> > +			copied += len;
> > +			size -= len;
> 
> Need to add a continue here to recheck size != 0.

Why would that be needed?

When size is still != 0 (i.e. the existing buffer is completely filled, we 
have still some remaining data), we fall through to the while loop that 
generates a new buffer.

If we add a continue here, we start the next iteration in the outer while loop 
which again checks for the merging of data in an existing buffer. As this 
merging will never happen as we filled that buffer completely in the previous 
loop, we always will fall through to the inner while loop. Thus, not having 
the check for size != 0 is functional identical to having it (besides, it is 
more efficient to not having it). 

Note, this case is triggered in my tests, where I use sendmsg with first a 
small buffer, followed by a large buffer. And I still can send 65536 bytes to 
the kernel.

-- 
Ciao
Stephan
