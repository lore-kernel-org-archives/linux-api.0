From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/5] lib/rhashtable: guarantee initial hashtable
 allocation
Date: Mon, 4 Jun 2018 13:46:22 +0200
Message-ID: <20180604114622.GK19202@dhcp22.suse.cz>
References: <20180601160125.30031-1-dave@stgolabs.net>
 <20180601160125.30031-3-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601160125.30031-3-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Fri 01-06-18 09:01:22, Davidlohr Bueso wrote:
[...]
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

Just a heads up. This is not longer needed after
http://lkml.kernel.org/r/20180601115329.27807-1-mhocko@kernel.org
is applied. Moreover it will conflict at that spot.

-- 
Michal Hocko
SUSE Labs
