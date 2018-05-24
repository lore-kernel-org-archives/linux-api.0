From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 2/6] lib/rhashtable: guarantee initial hashtable allocation
Date: Thu, 24 May 2018 14:11:31 -0700
Message-ID: <20180524211135.27760-3-dave@stgolabs.net>
References: <20180524211135.27760-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524211135.27760-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

rhashtable_init() may fail due to -ENOMEM, thus making the
entire api unusable. This patch removes this scenario,
however unlikely. In order to guarantee memory allocation,
this patch refactors bucket_table_alloc() to add a 'retry'
parameter which always ends up doing GFP_KERNEL|__GFP_NOFAIL
for both the tbl as well as alloc_bucket_spinlocks().

So upon the first table allocation failure, we shrink the
size to the smallest value that makes sense and retry the alloc
with the same semantics. If we fail again, then we force the
call with __GFP_NOFAIL. With the defaults, this means that from
64 buckets, we retry with only 4. Any later issues regarding
performance due to collisions or larger table resizing (when
more memory becomes available) is the last of our problems.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 lib/rhashtable.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 05a4b1b8b8ce..28f28602e2f5 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -166,15 +166,20 @@ static struct bucket_table *nested_bucket_table_alloc(struct rhashtable *ht,
 	return tbl;
 }
 
-static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
-					       size_t nbuckets,
-					       gfp_t gfp)
+static struct bucket_table *__bucket_table_alloc(struct rhashtable *ht,
+						 size_t nbuckets,
+						 gfp_t gfp, bool retry)
 {
 	struct bucket_table *tbl = NULL;
 	size_t size, max_locks;
 	int i;
 
 	size = sizeof(*tbl) + nbuckets * sizeof(tbl->buckets[0]);
+	if (retry) {
+		gfp |= __GFP_NOFAIL;
+		tbl = kzalloc(size, gfp);
+	} /* fall-through */
+
 	if (gfp != GFP_KERNEL)
 		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
 	else
@@ -211,6 +216,20 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
 	return tbl;
 }
 
+static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
+					       size_t nbuckets,
+					       gfp_t gfp)
+{
+	return __bucket_table_alloc(ht, nbuckets, gfp, false);
+}
+
+static struct bucket_table *bucket_table_alloc_retry(struct rhashtable *ht,
+						     size_t nbuckets,
+						     gfp_t gfp)
+{
+	return __bucket_table_alloc(ht, nbuckets, gfp, true);
+}
+
 static struct bucket_table *rhashtable_last_table(struct rhashtable *ht,
 						  struct bucket_table *tbl)
 {
@@ -1067,9 +1086,20 @@ int rhashtable_init(struct rhashtable *ht,
 		}
 	}
 
+	/*
+	 * This is api initialization and thus we need to guarantee the
+	 * initial rhashtable allocation. Upon failure, retry with a
+	 * smallest possible size, otherwise we exhaust our options with
+	 * __GFP_NOFAIL.
+	 */
 	tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
-	if (tbl == NULL)
-		return -ENOMEM;
+	if (unlikely(tbl == NULL)) {
+		size = HASH_MIN_SIZE;
+
+		tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
+		if (tbl == NULL)
+			tbl = bucket_table_alloc_retry(ht, size, GFP_KERNEL);
+	}
 
 	atomic_set(&ht->nelems, 0);
 
-- 
2.13.6
