From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/10] ceph: use generic_write_sync
Date: Thu,  7 Apr 2016 08:52:02 -0700
Message-ID: <1460044324-5298-9-git-send-email-hch@lst.de>
References: <1460044324-5298-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1460044324-5298-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ceph/file.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index a79f926..4f1dc71 100644
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

