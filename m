From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 3/6] lib/bucket_locks: use kvmalloc_array()
Date: Thu, 24 May 2018 14:11:32 -0700
Message-ID: <20180524211135.27760-4-dave@stgolabs.net>
References: <20180524211135.27760-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524211135.27760-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

For some reason we don't use this call, but we rely just
fine on kmalloc_array(). Make both consistent.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 lib/bucket_locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/bucket_locks.c b/lib/bucket_locks.c
index 266a97c5708b..75fe7386756f 100644
--- a/lib/bucket_locks.c
+++ b/lib/bucket_locks.c
@@ -31,7 +31,7 @@ int alloc_bucket_spinlocks(spinlock_t **locks, unsigned int *locks_mask,
 
 	if (sizeof(spinlock_t) != 0) {
 		if (gfpflags_allow_blocking(gfp))
-			tlocks = kvmalloc(size * sizeof(spinlock_t), gfp);
+			tlocks = kvmalloc_array(size, sizeof(spinlock_t), gfp);
 		else
 			tlocks = kmalloc_array(size, sizeof(spinlock_t), gfp);
 		if (!tlocks)
-- 
2.13.6
