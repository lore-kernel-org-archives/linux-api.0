From: "J. R. Okajima" <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: [PATCH 2/2] LOOP_SET_CAPACITY sector_t may be narrow for bit-shfit
Date: Wed,  7 Jan 2009 15:14:15 +0900
Message-ID: <1231308855-31726-2-git-send-email-hooanon05@yahoo.co.jp>
References: <20090106160414.b165d452.akpm@linux-foundation.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090106160414.b165d452.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tomas-VOkecuvH9Oc@public.gmane.org, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

Fixing the bug pointed out by Andrew Morton, shift loff_t instead of
sector_t since sector_t may be 32-bit.

Signed-off-by: J. R. Okajima <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
---
 drivers/block/loop.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index fcd28a7..eaed1fa 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1171,7 +1171,9 @@ static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
 	if (unlikely(err))
 		goto out;
 	sec = get_capacity(lo->lo_disk);
-	sz = sec << 9;
+	/* the width of sector_t may be narrow for bit-shift */
+	sz = sec;
+	sz <<= 9;
 	mutex_lock(&bdev->bd_mutex);
 	bd_set_size(bdev, sz);
 	mutex_unlock(&bdev->bd_mutex);
-- 
1.5.5.4.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
