From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/6] lib/rhashtable: guarantee initial hashtable
 allocation
Date: Wed, 30 May 2018 02:27:46 +0800
Message-ID: <20180529182746.t4b7tsnfma7dupom@gondor.apana.org.au>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-3-dave@stgolabs.net>
 <20180528094956.zaxusqqju3wtbdcz@gondor.apana.org.au>
 <20180529170338.7brp2m2k4gfqwf64@linux-n805>
 <20180529180428.l6yt6ae4oxbgrja6@gondor.apana.org.au>
 <20180529175927.iyea653hpgnow6p2@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529175927.iyea653hpgnow6p2@linux-n805>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Tue, May 29, 2018 at 10:59:27AM -0700, Davidlohr Bueso wrote:
> On Wed, 30 May 2018, Herbert Xu wrote:
> 
> > It doesn't explain it at all.  In fact I don't see why we neeed
> > three attempts, just do the GFP_NOFAIL as the second and final step.
> 
> Second attempt is reduced size only as we don't want to GFP_NOFAIL
> if we can avoid it helping the allocator. We go from an arbitrary
> allocation to the smallest possible allocation, if all that fails
> ok lets use GFP_NOFAIL. I don't know how this is not clear...

That's exactly what you need to explain in the patch or the commit
message.  In fact you still haven't explained it fully.  Why do we
need a second attempt without the GFP_NOFAIL? How does it help the
allocator?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
