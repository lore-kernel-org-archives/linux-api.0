From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 08/10] ceph: use generic_write_sync
Date: Tue, 29 Mar 2016 19:37:32 +0200
Message-ID: <1459273054-13478-9-git-send-email-hch@lst.de>
References: <1459273054-13478-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459273054-13478-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/ceph/file.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ef38f01..9daed9b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1382,12 +1382,11 @@ retry_snap:
 	     ceph_cap_string(got));
 	ceph_put_cap_refs(ci, got);
 
-	if (written >= 0 &&
-	    ((file->f_flags & O_SYNC) || IS_SYNC(file->f_mapping->host) ||
-	     ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_NEARFULL))) {
-		err = vfs_fsync_range(file, pos, pos + written - 1, 1);
-		if (err < 0)
-			written = err;
+	if (written >= 0) {
+		if (ceph_osdmap_flag(osdc->osdmap, CEPH_OSDMAP_NEARFULL))
+			iocb->ki_flags |= IOCB_DSYNC;
+
+		written = generic_write_sync(iocb, written);
 	}
 
 	goto out_unlocked;
-- 
2.1.4
