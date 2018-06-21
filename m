From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 1/4] lib/rhashtable: simplify bucket_table_alloc()
Date: Thu, 21 Jun 2018 14:28:22 -0700
Message-ID: <20180621212825.3059-2-dave@stgolabs.net>
References: <20180621212825.3059-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621212825.3059-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

As of ce91f6ee5 (mm: kvmalloc does not fallback to vmalloc for incompatible gfp flag),
we can simplify the caller and trust kvzalloc() to just do the right thing.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 lib/rhashtable.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 9427b5766134..26c9cd8a985a 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -175,10 +175,7 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
 	int i;
 
 	size = sizeof(*tbl) + nbuckets * sizeof(tbl->buckets[0]);
-	if (gfp != GFP_KERNEL)
-		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
-	else
-		tbl = kvzalloc(size, gfp);
+	tbl = kvzalloc(size, gfp);
 
 	size = nbuckets;
 
-- 
2.16.4
