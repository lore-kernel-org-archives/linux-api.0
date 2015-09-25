From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 6/9] vfs: Copy should use file_out rather than file_in
Date: Fri, 25 Sep 2015 16:48:12 -0400
Message-ID: <1443214096-12769-7-git-send-email-Anna.Schumaker@Netapp.com>
References: <1443214096-12769-1-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443214096-12769-1-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

The way to think about this is that the destination filesystem reads the
data from the source file and processes it accordingly.  This is
especially important to avoid an infinate loop when doing a "server to
server" copy on NFS.

Signed-off-by: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
---
 fs/read_write.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 8e7cb33..6f74f1f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1355,7 +1355,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (!(file_in->f_mode & FMODE_READ) ||
 	    !(file_out->f_mode & FMODE_WRITE) ||
 	    (file_out->f_flags & O_APPEND) ||
-	    !file_in->f_op || !file_in->f_op->copy_file_range)
+	    !file_out->f_op || !file_out->f_op->copy_file_range)
 		return -EBADF;
 
 	inode_in = file_inode(file_in);
@@ -1378,8 +1378,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
-	ret = file_in->f_op->copy_file_range(file_in, pos_in, file_out, pos_out,
-					     len, flags);
+	ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out, pos_out,
+					      len, flags);
 	if (ret > 0) {
 		fsnotify_access(file_in);
 		add_rchar(current, ret);
-- 
2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
