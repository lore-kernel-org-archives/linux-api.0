From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 4/9] vfs: Copy should check len after file open mode
Date: Wed, 30 Sep 2015 13:26:48 -0400
Message-ID: <1443634014-3026-5-git-send-email-Anna.Schumaker@Netapp.com>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443634014-3026-1-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

I don't think it makes sense to report that a copy succeeded if the
files aren't open properly.

Signed-off-by: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Reviewed-by: David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>
---
 fs/read_write.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index dd10750..f3d6c48 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1345,9 +1345,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (flags)
 		return -EINVAL;
 
-	if (len == 0)
-		return 0;
-
 	/* copy_file_range allows full ssize_t len, ignoring MAX_RW_COUNT  */
 	ret = rw_verify_area(READ, file_in, &pos_in, len);
 	if (ret >= 0)
@@ -1378,6 +1375,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (inode_in == inode_out)
 		return -EINVAL;
 
+	if (len == 0)
+		return 0;
+
 	ret = mnt_want_write_file(file_out);
 	if (ret)
 		return ret;
-- 
2.6.0
