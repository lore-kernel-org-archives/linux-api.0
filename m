From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ioctl_ficlonerange.2: mention a subtlety with length == 0
Date: Thu, 14 Jul 2016 11:11:11 -0700
Message-ID: <20160714181111.GC5215@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

I forgot to document that passing length == 0 to clonerange actually
makes it clone all the way to EOF, so do that now.

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 man2/ioctl_ficlonerange.2 |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/man2/ioctl_ficlonerange.2 b/man2/ioctl_ficlonerange.2
index d1da3e6..c4715d0 100644
--- a/man2/ioctl_ficlonerange.2
+++ b/man2/ioctl_ficlonerange.2
@@ -59,6 +59,9 @@ into the file
 at offset
 .IR dest_offset ",
 provided that both are files.
+If
+.IR src_length
+is zero, the ioctl reflinks to the end of the source file.
 This information is conveyed in a structure of
 the following form:
 .in +4n
