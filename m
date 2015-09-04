From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 5/8] vfs: Remove copy_file_range mountpoint checks
Date: Fri, 4 Sep 2015 16:16:59 -0400
Message-ID: <1441397823-1203-6-git-send-email-Anna.Schumaker@Netapp.com>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441397823-1203-1-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

I still want to do an in-kernel copy even if the files are on different
mountpoints, and NFS has a "server to server" copy that expects two
files on different mountpoints.  Let's have individual filesystems
implement this check instead.

Signed-off-by: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
---
 fs/read_write.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 82c4933..922ca58 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1369,11 +1369,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	    pos_in + len > i_size_read(inode_in))
 		return -EINVAL;
 
-	/* this could be relaxed once a method supports cross-fs copies */
-	if (inode_in->i_sb != inode_out->i_sb ||
-	    file_in->f_path.mnt != file_out->f_path.mnt)
-		return -EXDEV;
-
 	/* forbid ranges in the same file */
 	if (inode_in == inode_out)
 		return -EINVAL;
-- 
2.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
