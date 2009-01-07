From: "J. R. Okajima" <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: [PATCH 1/2] security check for LOOP_SET_CAPACITY
Date: Wed,  7 Jan 2009 15:14:14 +0900
Message-ID: <1231308855-31726-1-git-send-email-hooanon05@yahoo.co.jp>
References: <20090106160414.b165d452.akpm@linux-foundation.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090106160414.b165d452.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tomas-VOkecuvH9Oc@public.gmane.org, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

Respoding the comment from Linus Torvalds, LOOP_SET_CAPACITY now
requires the device file to be opened for write or CAP_SYS_ADMIN.

Signed-off-by: J. R. Okajima <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
---
 drivers/block/loop.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 80e523e..fcd28a7 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1210,7 +1210,9 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
 		break;
 	case LOOP_SET_CAPACITY:
-		err = loop_set_capacity(lo, bdev);
+		err = -EPERM;
+		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+			err = loop_set_capacity(lo, bdev);
 		break;
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
-- 
1.5.5.4.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
