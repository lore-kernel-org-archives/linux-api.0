From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: semantics of rhashtable and sysvipc
Date: Thu, 24 May 2018 10:07:00 -0700
Message-ID: <20180524170700.wblnybinjzx5rwky@linux-n805>
References: <20180523172500.anfvmjtumww65ief@linux-n805>
 <CA+55aFwAtfiMa22-OFGf1dNR8CNzSKjjLLj5UL-HqgapV7Tf1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwAtfiMa22-OFGf1dNR8CNzSKjjLLj5UL-HqgapV7Tf1A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 23 May 2018, Linus Torvalds wrote:

>One option is to make rhashtable_alloc() shrink the allocation and try
>again if it fails, and then you *can* do __GFP_NOFAIL eventually.

The below attempts to implements this, along with converting the EINVAL cases
to WARN_ON().

I've refactored bucket_table_alloc() to add a 'retry' param which always
ends up doing GFP_KERNEL|__GFP_NOFAIL for both the tbl as well as
alloc_bucket_spinlocks(). I've arbitrarily shrunk the size in half upon
initial allocation failure. So we default from 64 to 32 buckets, and if
the user is hinting at larger nelems, we simply disregard that and retry
with 32. Similarly, smaller values are also cut in half.

In addition, I think we can also get rid of explicitly passing the gfp flags
to bucket_table_alloc() (we only do GFP_KERNEL or GFP_ATOMIC), and leave it
up to __bucket_table_alloc() by adding a new bucket_table_alloc_noblock() or
something for GFP_ATOMIC.

>
>In fact, it can validly be argued that rhashtable_init() is just buggy
>as-is. The whole *point* olf that function is to size things appropriately,
>and returning -ENOMEM obviously means that it didn't do its job.

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 9427b5766134..e86a396aebcf 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -166,16 +166,21 @@ static struct bucket_table *nested_bucket_table_alloc(struct rhashtable *ht,
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
-	if (gfp != GFP_KERNEL)
+	if (retry) {
+		gfp |= __GFP_NOFAIL;
+		tbl = kzalloc(size, gfp);
+	}
+
+	else if (gfp != GFP_KERNEL)
 		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
 	else
 		tbl = kvzalloc(size, gfp);
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
@@ -1024,12 +1043,11 @@ int rhashtable_init(struct rhashtable *ht,
 
 	size = HASH_DEFAULT_SIZE;
 
-	if ((!params->key_len && !params->obj_hashfn) ||
-	    (params->obj_hashfn && !params->obj_cmpfn))
-		return -EINVAL;
+	WARN_ON((!params->key_len && !params->obj_hashfn) ||
+		(params->obj_hashfn && !params->obj_cmpfn));
 
-	if (params->nulls_base && params->nulls_base < (1U << RHT_BASE_SHIFT))
-		return -EINVAL;
+	WARN_ON(params->nulls_base &&
+		params->nulls_base < (1U << RHT_BASE_SHIFT));
 
 	memset(ht, 0, sizeof(*ht));
 	mutex_init(&ht->mutex);
@@ -1068,9 +1086,23 @@ int rhashtable_init(struct rhashtable *ht,
 		}
 	}
 
+	/*
+	 * This is api initialization. We need to guarantee the initial
+	 * rhashtable allocation. Upon failure, retry with a smaller size,
+	 * otherwise we exhaust our options with __GFP_NOFAIL.
+	 *
+	 * The size of the table is shrunk to at least half the original
+	 * value. Users that use large nelem_hint values are lowered to 32
+	 * buckets.
+	 */
 	tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
-	if (tbl == NULL)
-		return -ENOMEM;
+	if (unlikely(tbl == NULL)) {
+		size = min(size, HASH_DEFAULT_SIZE) / 2;
+
+		tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
+		if (tbl == NULL)
+			tbl = bucket_table_alloc_retry(ht, size, GFP_KERNEL);
+	}
 
 	atomic_set(&ht->nelems, 0);
 
