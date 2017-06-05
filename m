From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] utimensat: immutable flag returns -EPERM
Date: Mon,  5 Jun 2017 09:18:27 -0500
Message-ID: <20170605141827.21420-1-rgoldwyn@suse.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jstancek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chrubis-AlSwsSmVLrQ@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, pgajdos-IBi9RG/b67k@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>

Linux kernel commit 337684a1746f "fs: return EPERM on immutable inode"
changed (nd unified the return value of the utimensat(2) from -EACCES
to -EPERM in case of an immutable flag. Modify the man page to
reflect the same.

The entire discussion of returning the correct return value is at:
http://lists.linux.it/pipermail/ltp/2017-January/003424.html

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
---
 man2/utimensat.2 | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/man2/utimensat.2 b/man2/utimensat.2
index f77d0b42a..c0bdf8808 100644
--- a/man2/utimensat.2
+++ b/man2/utimensat.2
@@ -238,10 +238,7 @@ or both
 .I tv_nsec
 values are
 .BR UTIME_NOW ,
-and either:
-.RS
-.IP * 3
-the effective user ID of the caller does not match
+and the effective user ID of the caller does not match
 the owner of the file,
 the caller does not have write access to the file,
 and the caller is not privileged
@@ -249,7 +246,7 @@ and the caller is not privileged
 .B CAP_FOWNER
 or the
 .B CAP_DAC_OVERRIDE
-capability); or,
+capability).
 .\" But Linux 2.6.22 was broken here.
 .\" Traditionally, utime()/utimes() gives the error EACCES for the case
 .\" where the timestamp pointer argument is NULL (i.e., set both timestamps
@@ -271,9 +268,6 @@ capability); or,
 .\" and the permissions of the directory to which
 .\" .I fd
 .\" refers do not allow searches.
-.IP *
-the file is marked immutable (see
-.BR chattr (1)).
 .\" EXT2_IMMUTABLE_FL and similar flags for other filesystems.
 .RE
 .TP
-- 
2.12.3
