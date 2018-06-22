From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] lib/rhashtable: guarantee initial hashtable
 allocation
Date: Fri, 22 Jun 2018 14:54:07 +0800
Message-ID: <20180622065407.jqi3mvuzsj2jotbt@gondor.apana.org.au>
References: <20180621212825.3059-1-dave@stgolabs.net>
 <20180621212825.3059-3-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180621212825.3059-3-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 21, 2018 at 02:28:23PM -0700, Davidlohr Bueso wrote:
> rhashtable_init() may fail due to -ENOMEM, thus making the
> entire api unusable. This patch removes this scenario,
> however unlikely. In order to guarantee memory allocation,
> this patch always ends up doing GFP_KERNEL|__GFP_NOFAIL
> for both the tbl as well as alloc_bucket_spinlocks().
> 
> Upon the first table allocation failure, we shrink the
> size to the smallest value that makes sense and retry with
> __GFP_NOFAIL semantics. With the defaults, this means that
> from 64 buckets, we retry with only 4. Any later issues
> regarding performance due to collisions or larger table
> resizing (when more memory becomes available) is the least
> of our problems.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
