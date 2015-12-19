From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/9] vfs: wire up compat ioctl for CLONE/CLONE_RANGE
Date: Sat, 19 Dec 2015 00:55:52 -0800
Message-ID: <20151219085552.12478.82706.stgit@birch.djwong.org>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151219085505.12478.71157.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/compat_ioctl.c |    4 ++++
 fs/read_write.c   |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index dcf2653..70d4b10 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1580,6 +1580,10 @@ COMPAT_SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd,
 		goto out_fput;
 #endif
 
+	case FICLONE:
+	case FICLONERANGE:
+		goto do_ioctl;
+
 	case FIBMAP:
 	case FIGETBSZ:
 	case FIONREAD:
diff --git a/fs/read_write.c b/fs/read_write.c
index 6395c733..0713e28 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1489,7 +1489,7 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
-		return -EOPNOTSUPP;
+		return -EINVAL;
 
 	if (!(file_in->f_mode & FMODE_READ) ||
 	    !(file_out->f_mode & FMODE_WRITE) ||
