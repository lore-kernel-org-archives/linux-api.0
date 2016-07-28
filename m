From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] vfs: cap dedupe request structure size at PAGE_SIZE
Date: Thu, 28 Jul 2016 11:35:34 -0700
Message-ID: <20160728183534.GB15753@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Kirill A. Shutemov reports that the kernel doesn't try to cap dest_count
in any way, and uses the number to allocate kernel memory.  This causes
high order allocation warnings in the kernel log if someone passes in a
big enough value.  We should clamp the allocation at PAGE_SIZE to avoid
stressing the VM.

The two existing users of the dedupe ioctl never send more than 120
requests, so we can safely clamp dest_range at PAGE_SIZE, because with
4k pages we can handle up to 127 dedupe candidates.  Given the max
extent length of 16MB, we can end up doing 2GB of IO which is plenty.

Reported-by: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index db3d033..57409a7 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -582,6 +582,10 @@ static int ioctl_file_dedupe_range(struct file *file, void __user *arg)
 	}
 
 	size = offsetof(struct file_dedupe_range __user, info[count]);
+	if (size > PAGE_SIZE) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	same = memdup_user(argp, size);
 	if (IS_ERR(same)) {
