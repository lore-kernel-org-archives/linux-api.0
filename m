From: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/2] RWF_ODSYNC flag for pwritev2
Date: Thu,  6 Nov 2014 10:44:27 -0500
Message-ID: <ee4674ce06aaabf8bee50b4f0168af8729bc2ef1.1415288353.git.milosz@adfin.com>
References: <cover.1415220890.git.milosz@adfin.com>
 <d2cbc4795f774b521e13ac448d07a1156c6aa04d.1415288353.git.milosz@adfin.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d2cbc4795f774b521e13ac448d07a1156c6aa04d.1415288353.git.milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <d2cbc4795f774b521e13ac448d07a1156c6aa04d.1415288353.git.milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
References: <d2cbc4795f774b521e13ac448d07a1156c6aa04d.1415288353.git.milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Document RWF_ODSYNC flag for pwritev2 as implemented by Christoph Hellwig.

Signed-off-by: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
---
 man2/readv.2 | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/man2/readv.2 b/man2/readv.2
index 31b3870..ff1405c 100644
--- a/man2/readv.2
+++ b/man2/readv.2
@@ -203,6 +203,15 @@ contains a bitwise OR of one or more of the following flags:
 .BR RWF_NONBLOCK " (only " preadv2() " since Linux 3.19)"
 Performs a non-blocking operation for regular files (not sockets) opened in buffered mode (not
 .BR O_DIRECT ")."
+.TP
+.BR RWF_DSYNC " (only " pwritev2() " since Linux 3.19)"
+Write operation will complete according to the requirements of synchronized I/O
+.I data
+integrity completion. This has the same effect on the operation as if the file handle was created by
+.BR open(2)
+with the
+.BR O_DSYNC
+flag.
 
 .SH RETURN VALUE
 On success,
@@ -333,6 +342,7 @@ nwritten = writev(STDOUT_FILENO, iov, 2);
 .fi
 .in
 .SH SEE ALSO
+.BR open(2),
 .BR pread (2),
 .BR read (2),
 .BR write (2)
-- 
1.9.1
