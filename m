From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 2/4] lib/rhashtable: guarantee initial hashtable allocation
Date: Thu, 21 Jun 2018 14:28:23 -0700
Message-ID: <20180621212825.3059-3-dave@stgolabs.net>
References: <20180621212825.3059-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621212825.3059-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

rhashtable_init() may fail due to -ENOMEM, thus making the
entire api unusable. This patch removes this scenario,
however unlikely. In order to guarantee memory allocation,
this patch always ends up doing GFP_KERNEL|__GFP_NOFAIL
for both the tbl as well as alloc_bucket_spinlocks().

Upon the first table allocation failure, we shrink the
size to the smallest value that makes sense and retry with
__GFP_NOFAIL semantics. With the defaults, this means that
from 64 buckets, we retry with only 4. Any later issues
regarding performance due to collisions or larger table
resizing (when more memory becomes available) is the least
of our problems.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 lib/rhashtable.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 26c9cd8a985a..411c4041ce83 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -179,10 +179,11 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
 
 	size = nbuckets;
 
-	if (tbl == NULL && gfp != GFP_KERNEL) {
+	if (tbl == NULL && (gfp & ~__GFP_NOFAIL) != GFP_KERNEL) {
 		tbl = nested_bucket_table_alloc(ht, nbuckets, gfp);
 		nbuckets = 0;
 	}
+
 	if (tbl == NULL)
 		return NULL;
 
@@ -1065,9 +1066,16 @@ int rhashtable_init(struct rhashtable *ht,
 		}
 	}
 
+	/*
+	 * This is api initialization and thus we need to guarantee the
+	 * initial rhashtable allocation. Upon failure, retry with the
+	 * smallest possible size with __GFP_NOFAIL semantics.
+	 */
 	tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
-	if (tbl == NULL)
-		return -ENOMEM;
+	if (unlikely(tbl == NULL)) {
+		size = max_t(u16, ht->p.min_size, HASH_MIN_SIZE);
+		tbl = bucket_table_alloc(ht, size, GFP_KERNEL | __GFP_NOFAIL);
+	}
 
 	atomic_set(&ht->nelems, 0);
 
-- 
2.16.4
