From: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] man2/vmsplice: splice pages from pipe to memory
Date: Mon,  6 Nov 2017 23:34:17 -0800
Message-ID: <20171107073417.23371-1-avagin@openvz.org>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The man page describes that vmsplice can splice pages from
memory to a pipe, but it can work to anonther direction as well.

Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Signed-off-by: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 man2/vmsplice.2 | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/man2/vmsplice.2 b/man2/vmsplice.2
index e3e61cf27..8f48b8809 100644
--- a/man2/vmsplice.2
+++ b/man2/vmsplice.2
@@ -25,7 +25,7 @@
 .\"
 .TH VMSPLICE 2 2014-10-02 "Linux" "Linux Programmer's Manual"
 .SH NAME
-vmsplice \- splice user pages into a pipe
+vmsplice \- splice user pages to/from a pipe
 .SH SYNOPSIS
 .nf
 .BR "#define _GNU_SOURCE" "         /* See feature_test_macros(7) */"
@@ -44,13 +44,25 @@ vmsplice \- splice user pages into a pipe
 .\" the kernel-space one (contrast this to "write()", which copies
 .\" the actual data, and you can thus reuse the buffer immediately
 .\" after a successful write), but that is often easy to do.
-The
+If
+.I fd
+is opened for writting, the
 .BR vmsplice ()
 system call maps
 .I nr_segs
 ranges of user memory described by
 .I iov
 into a pipe.
+.\" commit 6a14b90bb6bc7cd83e2a444bf457a2ea645cbfe7
+If
+.I fd
+is opened for reading, the
+.BR vmsplice ()
+system call fills
+.I nr_segs
+ranges of user memory described by
+.I iov
+from a pipe.
 The file descriptor
 .I fd
 must refer to a pipe.
@@ -70,7 +82,6 @@ struct iovec {
 };
 .in
 .fi
