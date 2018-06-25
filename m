From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 1/4] lib/rhashtable: simplify bucket_table_alloc()
Date: Mon, 25 Jun 2018 11:13:14 +0200
Message-ID: <20180625091314.GG28965@dhcp22.suse.cz>
References: <20180621212825.3059-1-dave@stgolabs.net>
 <20180621212825.3059-2-dave@stgolabs.net>
 <20180622181540.5gul4lx5dteqzzk3@linux-r8p5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180622181540.5gul4lx5dteqzzk3@linux-r8p5>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Fri 22-06-18 11:15:40, Davidlohr Bueso wrote:
> As of ce91f6ee5b3 (mm: kvmalloc does not fallback to vmalloc for incompatible gfp flag),
> we can simplify the caller and trust kvzalloc() to just do the right thing. For the
> case of the GFP_ATOMIC context, we can drop the __GFP_NORETRY flag for obvious reasons,
> and for the __GFP_NOWARN case, however, it is changed such that the caller passes the
> flag instead of making bucket_table_alloc() handle it.
> 
> This slightly changes the gfp flags passed on to nested_table_alloc() as it will now
> also use GFP_ATOMIC | __GFP_NOWARN. However, I consider this a positive consequence
> as for the same reasons we want nowarn semantics in bucket_table_alloc().
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
> 
> v2:
> - Changes based on Neil's concerns about keeping nowarn flag.
> - Better changelog.
> 
> 
> lib/rhashtable.c | 7 ++-----
> 1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index 9427b5766134..083f871491a1 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -175,10 +175,7 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
> 	int i;
> 
> 	size = sizeof(*tbl) + nbuckets * sizeof(tbl->buckets[0]);
> -	if (gfp != GFP_KERNEL)
> -		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
> -	else
> -		tbl = kvzalloc(size, gfp);
> +	tbl = kvzalloc(size, gfp);
> 
> 	size = nbuckets;
> 
> @@ -459,7 +456,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
> 
> 	err = -ENOMEM;
> 
> -	new_tbl = bucket_table_alloc(ht, size, GFP_ATOMIC);
> +	new_tbl = bucket_table_alloc(ht, size, GFP_ATOMIC | __GFP_NOWARN);
> 	if (new_tbl == NULL)
> 		goto fail;
> 
> -- 
> 2.16.4

-- 
Michal Hocko
SUSE Labs
