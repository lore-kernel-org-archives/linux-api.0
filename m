From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v3 3/7] mm, slab: allocate off-slab freelists as reclaimable when appropriate
Date: Wed, 18 Jul 2018 15:36:16 +0200
Message-ID: <20180718133620.6205-4-vbabka@suse.cz>
References: <20180718133620.6205-1-vbabka@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718133620.6205-1-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@techsingularity.net>, Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org

In SLAB, OFF_SLAB caches allocate management structures (currently just the
freelist) from kmalloc caches when placement in a slab page together with
objects would lead to suboptimal memory usage. For SLAB_RECLAIM_ACCOUNT caches,
we can allocate the freelists from the newly introduced reclaimable kmalloc
caches, because shrinking the OFF_SLAB cache will in general result to freeing
of the freelists as well. This should improve accounting and anti-fragmentation
a bit.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index 9515798f37b2..99d779ba2b92 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2140,8 +2140,13 @@ int __kmem_cache_create(struct kmem_cache *cachep, slab_flags_t flags)
 #endif
 
 	if (OFF_SLAB(cachep)) {
+		/*
+		 * If this cache is reclaimable, allocate also freelists from
+		 * a reclaimable kmalloc cache.
+		 */
 		cachep->freelist_cache =
-			kmalloc_slab(cachep->freelist_size, 0u);
+			kmalloc_slab(cachep->freelist_size,
+				     cachep->allocflags & __GFP_RECLAIMABLE);
 	}
 
 	err = setup_cpu_cache(cachep, gfp);
-- 
2.18.0
