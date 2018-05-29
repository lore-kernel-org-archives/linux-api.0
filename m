From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/6] lib/rhashtable: guarantee initial hashtable
 allocation
Date: Tue, 29 May 2018 10:59:27 -0700
Message-ID: <20180529175927.iyea653hpgnow6p2@linux-n805>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-3-dave@stgolabs.net>
 <20180528094956.zaxusqqju3wtbdcz@gondor.apana.org.au>
 <20180529170338.7brp2m2k4gfqwf64@linux-n805>
 <20180529180428.l6yt6ae4oxbgrja6@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529180428.l6yt6ae4oxbgrja6@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Wed, 30 May 2018, Herbert Xu wrote:

>It doesn't explain it at all.  In fact I don't see why we neeed
>three attempts, just do the GFP_NOFAIL as the second and final step.

Second attempt is reduced size only as we don't want to GFP_NOFAIL
if we can avoid it helping the allocator. We go from an arbitrary
allocation to the smallest possible allocation, if all that fails
ok lets use GFP_NOFAIL. I don't know how this is not clear...

Thanks,
Davidlohr
