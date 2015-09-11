From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 5/9] vfs: Copy shouldn't forbid ranges inside the same file
Date: Fri, 11 Sep 2015 16:30:18 -0400
Message-ID: <1442003423-6884-6-git-send-email-Anna.Schumaker@Netapp.com>
References: <1442003423-6884-1-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442003423-6884-1-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is perfectly valid for BTRFS and XFS, so let's leave this up to
filesystems to check.

Signed-off-by: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
---
 fs/read_write.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 38cc251..d32549b 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1371,10 +1371,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	    file_in->f_path.mnt != file_out->f_path.mnt)
 		return -EXDEV;
 
-	/* forbid ranges in the same file */
-	if (inode_in == inode_out)
-		return -EINVAL;
-
 	if (len == 0)
 		return 0;
 
-- 
2.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
