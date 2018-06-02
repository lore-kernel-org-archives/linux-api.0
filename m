From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/5] lib/rhashtable: guarantee initial hashtable
 allocation
Date: Sat, 2 Jun 2018 12:41:50 +0800
Message-ID: <20180602044150.xpazuhpxbwt37xmu@gondor.apana.org.au>
References: <20180601160125.30031-1-dave@stgolabs.net>
 <20180601160125.30031-3-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601160125.30031-3-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 01, 2018 at 09:01:22AM -0700, Davidlohr Bueso wrote:
>
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index 05a4b1b8b8ce..ae17da6f0c75 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -175,7 +175,7 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
>  	int i;
>  
>  	size = sizeof(*tbl) + nbuckets * sizeof(tbl->buckets[0]);
> -	if (gfp != GFP_KERNEL)
> +	if ((gfp & ~__GFP_NOFAIL) != GFP_KERNEL)
>  		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
>  	else
>  		tbl = kvzalloc(size, gfp);

There's another GFP_KERNEL check in this function that needs the
same treatment.

> @@ -1067,9 +1067,16 @@ int rhashtable_init(struct rhashtable *ht,
>  		}
>  	}
>  
> +	/*
> +	 * This is api initialization and thus we need to guarantee the
> +	 * initial rhashtable allocation. Upon failure, retry with the
> +	 * smallest possible size with __GFP_NOFAIL semantics.
> +	 */
>  	tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
> -	if (tbl == NULL)
> -		return -ENOMEM;
> +	if (unlikely(tbl == NULL)) {
> +		size = min_t(u16, ht->p.min_size, HASH_MIN_SIZE);

You mean max_t?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
