From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 5/5] lib/test_rhashtable: rhashtable_init() can no longer fail
Date: Fri,  1 Jun 2018 09:01:25 -0700
Message-ID: <20180601160125.30031-6-dave@stgolabs.net>
References: <20180601160125.30031-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601160125.30031-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

Update the test module as such.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 lib/test_rhashtable.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
index f4000c137dbe..a894eb0407f0 100644
--- a/lib/test_rhashtable.c
+++ b/lib/test_rhashtable.c
@@ -182,11 +182,7 @@ static void test_bucket_stats(struct rhashtable *ht, unsigned int entries)
 	struct rhashtable_iter hti;
 	struct rhash_head *pos;
 
-	err = rhashtable_walk_init(ht, &hti, GFP_KERNEL);
-	if (err) {
-		pr_warn("Test failed: allocation error");
-		return;
-	}
+	rhashtable_walk_init(ht, &hti, GFP_KERNEL);
 
 	rhashtable_walk_start(&hti);
 
-- 
2.16.3
