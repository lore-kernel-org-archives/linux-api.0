From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH v3 2/7] mm, slab/slub: introduce kmalloc-reclaimable
 caches
Date: Mon, 30 Jul 2018 15:41:29 +0000
Message-ID: <01000164ebd9fc22-31811702-8b80-46c2-a249-a1960c37ae01-000000@email.amazonses.com>
References: <20180718133620.6205-1-vbabka@suse.cz> <20180718133620.6205-3-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718133620.6205-3-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@techsingularity.net>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On Wed, 18 Jul 2018, Vlastimil Babka wrote:

> index 4299c59353a1..d89e934e0d8b 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -296,11 +296,12 @@ static inline void __check_heap_object(const void *ptr, unsigned long n,
>                                 (KMALLOC_MIN_SIZE) : 16)
>
>  #define KMALLOC_NORMAL	0
> +#define KMALLOC_RECLAIM	1
>  #ifdef CONFIG_ZONE_DMA
> -#define KMALLOC_DMA	1
> -#define KMALLOC_TYPES	2
> +#define KMALLOC_DMA	2
> +#define KMALLOC_TYPES	3
>  #else
> -#define KMALLOC_TYPES	1
> +#define KMALLOC_TYPES	2
>  #endif

I like enums....

Acked-by: Christoph Lameter <cl@linux.com>
