From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 1/6] lib/rhashtable: convert param sanitations to WARN_ON
Date: Thu, 24 May 2018 14:11:30 -0700
Message-ID: <20180524211135.27760-2-dave@stgolabs.net>
References: <20180524211135.27760-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524211135.27760-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

For the purpose of making rhashtable_init() unable to fail,
we can replace the returning -EINVAL with WARN_ONs whenever
the caller passes bogus parameters during initialization.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 lib/rhashtable.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 9427b5766134..05a4b1b8b8ce 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -1024,12 +1024,11 @@ int rhashtable_init(struct rhashtable *ht,
 
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
-- 
2.13.6
