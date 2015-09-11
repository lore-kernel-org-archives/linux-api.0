From: Anna Schumaker <Anna.Schumaker@netapp.com>
Subject: [PATCH v2 9/9] btrfs: btrfs_copy_file_range() only supports reflinks
Date: Fri, 11 Sep 2015 16:30:22 -0400
Message-ID: <1442003423-6884-10-git-send-email-Anna.Schumaker@Netapp.com>
References: <1442003423-6884-1-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1442003423-6884-1-git-send-email-Anna.Schumaker@Netapp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, zab@zabbo.net, viro@zeniv.linux.org.uk, clm@fb.com, darrick.wong@oracle.com, mtk.manpages@gmail.com, andros@netapp.com, hch@infradead.org
List-Id: linux-api@vger.kernel.org

Reject copies that don't have the COPY_FR_REFLINK flag set.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
---
 fs/btrfs/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4311554..2e14b91 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -44,6 +44,7 @@
 #include <linux/uuid.h>
 #include <linux/btrfs.h>
 #include <linux/uaccess.h>
+#include <linux/copy.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -3848,6 +3849,9 @@ ssize_t btrfs_copy_file_range(struct file *file_in, loff_t pos_in,
 {
 	ssize_t ret;
 
+	if (!(flags & COPY_FR_REFLINK))
+		return -EOPNOTSUPP;
+
 	ret = btrfs_clone_files(file_out, file_in, pos_in, len, pos_out);
 	if (ret == 0)
 		ret = len;
-- 
2.5.1

