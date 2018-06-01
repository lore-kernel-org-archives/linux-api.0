From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/5] lib/rhashtable: convert param sanitations to WARN_ON
Date: Sat, 2 Jun 2018 00:09:44 +0800
Message-ID: <20180601160944.ji2gsp3pyunlj476@gondor.apana.org.au>
References: <20180601160125.30031-1-dave@stgolabs.net>
 <20180601160125.30031-2-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601160125.30031-2-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 01, 2018 at 09:01:21AM -0700, Davidlohr Bueso wrote:
> For the purpose of making rhashtable_init() unable to fail,
> we can replace the returning -EINVAL with WARN_ONs whenever
> the caller passes bogus parameters during initialization.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  lib/rhashtable.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index 9427b5766134..05a4b1b8b8ce 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -1024,12 +1024,11 @@ int rhashtable_init(struct rhashtable *ht,
>  
>  	size = HASH_DEFAULT_SIZE;
>  
> -	if ((!params->key_len && !params->obj_hashfn) ||
> -	    (params->obj_hashfn && !params->obj_cmpfn))
> -		return -EINVAL;
> +	WARN_ON((!params->key_len && !params->obj_hashfn) ||
> +		(params->obj_hashfn && !params->obj_cmpfn));
>  
> -	if (params->nulls_base && params->nulls_base < (1U << RHT_BASE_SHIFT))
> -		return -EINVAL;
> +	WARN_ON(params->nulls_base &&
> +		params->nulls_base < (1U << RHT_BASE_SHIFT));

I still don't like this.

Yes for your use-case you will never crash and a WARN_ON is fine.
However, rhashtable is used in all sorts of contexts and returning
an error makes sense for quite a number of them.

So if you really want just add the WARN_ON to your own code:

	err = rhashtable_init(...)
	WARN_ON(err);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
