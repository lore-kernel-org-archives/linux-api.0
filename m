From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 2/5] lib/rhashtable: guarantee initial hashtable allocation
Date: Fri,  1 Jun 2018 09:01:22 -0700
Message-ID: <20180601160125.30031-3-dave@stgolabs.net>
References: <20180601160125.30031-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601160125.30031-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

rhashtable_init() may fail due to -ENOMEM, thus making the
entire api unusable. This patch removes this scenario,
however unlikely. In order to guarantee memory allocation,
this patch always ends up doing GFP_KERNEL|__GFP_NOFAIL
for both the tbl as well as alloc_bucket_spinlocks().

Upon the first table allocation failure, we shrink the
size to the smallest value that makes sense retry with
__GFP_NOFAIL semantics. With the defaults, this means that
from 64 buckets, we retry with only 4. Any later issues
regarding performance due to collisions or larger table
resizing (when more memory becomes available) is the last
of our problems.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 lib/rhashtable.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 05a4b1b8b8ce..ae17da6f0c75 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -175,7 +175,7 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
 	int i;
 
 	size = sizeof(*tbl) + nbuckets * sizeof(tbl->buckets[0]);
-	if (gfp != GFP_KERNEL)
+	if ((gfp & ~__GFP_NOFAIL) != GFP_KERNEL)
 		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
 	else
 		tbl = kvzalloc(size, gfp);
@@ -1067,9 +1067,16 @@ int rhashtable_init(struct rhashtable *ht,
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
+		size = min_t(u16, ht->p.min_size, HASH_MIN_SIZE);
+		tbl = bucket_table_alloc(ht, size, GFP_KERNEL | __GFP_NOFAIL);
+	}
 
 	atomic_set(&ht->nelems, 0);
 
-- 
2.16.3
