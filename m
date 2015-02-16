From: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RESEND 4/12] xfsprog: xfsio: update xfs_io manpage for FALLOC_FL_INSERT_RANGE
Date: Tue, 17 Feb 2015 00:47:51 +0900
Message-ID: <1424101680-3301-5-git-send-email-linkinjeon@gmail.com>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424101680-3301-1-git-send-email-linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Update xfs_io manpage for FALLOC_FL_INSERT_RANGE.

Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 man/man8/xfs_io.8 |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index cf27b99..416206f 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -404,6 +404,11 @@ Call fallocate with FALLOC_FL_COLLAPSE_RANGE flag as described in the
 manual page to de-allocates blocks and eliminates the hole created in this process
 by shifting data blocks into the hole.
 .TP
+.BI finsert " offset length"
+Call fallocate with FALLOC_FL_INSERT_RANGE flag as described in the
+.BR fallocate (2)
+manual page to create the hole by shifting data blocks.
+.TP
 .BI fpunch " offset length"
 Punches (de-allocates) blocks in the file by calling fallocate with 
 the FALLOC_FL_PUNCH_HOLE flag as described in the
-- 
1.7.9.5
