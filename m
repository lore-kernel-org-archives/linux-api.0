From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ioctl_getfsmap.2: correct semantics of FMR_OF_LAST flag
Date: Wed, 23 Aug 2017 12:52:25 -0700
Message-ID: <20170823195225.GF4794@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The FMR_OF_LAST flag is applied to the last record in the returned
dataset, which is not necessarily the last record in the filesystem.
Correct the documentation to reflect the actual behavior of both
getfsmap implementations.

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 man2/ioctl_getfsmap.2 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man2/ioctl_getfsmap.2 b/man2/ioctl_getfsmap.2
index 2a3cf06..047a624 100644
--- a/man2/ioctl_getfsmap.2
+++ b/man2/ioctl_getfsmap.2
@@ -225,7 +225,7 @@ The
 field contains a special value instead of an inode number.
 .TP
 .B FMR_OF_LAST
-This is the last record in the filesystem.
+This is the last record in the data set.
 .RE
 .PP
 The
