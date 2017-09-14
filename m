From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [patch v2] madvise.2: Add MADV_WIPEONFORK documentation
Date: Thu, 14 Sep 2017 15:05:46 -0400
Message-ID: <20170914150546.74ad3a9a@cuia.usersys.redhat.com>
References: <20170914130040.6faabb18@cuia.usersys.redhat.com>
        <CAAF6GDdnY2AmzKx+t4ffCFxJ+RZS++4tmWvoazdVNVSYjra_WA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAF6GDdnY2AmzKx+t4ffCFxJ+RZS++4tmWvoazdVNVSYjra_WA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colm =?UTF-8?B?TWFjQ8OhcnRoYWlnaA==?= <colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

v2: implement the improvements suggested by Colm, and add
    Colm's text to the fork.2 man page
    (Colm, I have added a signed-off-by in your name - is that ok?)

Add MADV_WIPEONFORK and MADV_KEEPONFORK documentation to
madvise.2.  The new functionality was recently merged by
Linus, and should be in the 4.14 kernel.

While documenting what EINVAL means for MADV_WIPEONFORK,
I realized that MADV_FREE has the same thing going on,
so I documented EINVAL for both in the ERRORS section.

This patch documents the following kernel commit:

commit d2cd9ede6e193dd7d88b6d27399e96229a551b19
Author: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Wed Sep 6 16:25:15 2017 -0700

    mm,fork: introduce MADV_WIPEONFORK

Signed-off-by: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Colm MacCárthaigh <colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org>

diff --git a/man2/fork.2 b/man2/fork.2
index b5af58ca08c0..b11e750e3876 100644
--- a/man2/fork.2
+++ b/man2/fork.2
@@ -140,6 +140,12 @@ Memory mappings that have been marked with the
 flag are not inherited across a
 .BR fork ().
 .IP *
+Memory in mappings that have been marked with the
+.BR madvise (2)
+.B MADV_WIPEONFORK
+flag is zeroed in the child after a
+.BR fork ().
+.IP *
 The termination signal of the child is always
 .B SIGCHLD
 (see
diff --git a/man2/madvise.2 b/man2/madvise.2
index dfb31b63dba3..bb0ac469c509 100644
--- a/man2/madvise.2
+++ b/man2/madvise.2
@@ -31,6 +31,9 @@
 .\" 2010-06-19, Andi Kleen, Add documentation of MADV_SOFT_OFFLINE.
 .\" 2011-09-18, Doug Goldstein <cardoe-VPKZcK2rSRzQT0dZR+AlfA@public.gmane.org>
 .\"     Document MADV_HUGEPAGE and MADV_NOHUGEPAGE
+.\" 2017-09-14, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+.\"     Document MADV_WIPEONFORK and MADV_KEEPONFORK
+.\" commit d2cd9ede6e193dd7d88b6d27399e96229a551b19
 .\"
 .TH MADVISE 2 2017-07-13 "Linux" "Linux Programmer's Manual"
 .SH NAME
@@ -405,6 +408,22 @@ can be applied only to private anonymous pages (see
 .BR mmap (2)).
 On a swapless system, freeing pages in a given range happens instantly,
 regardless of memory pressure.
+.TP
+.BR MADV_WIPEONFORK " (since Linux 4.14)"
+Present the child process with zero-filled memory in this range after a
+.BR fork (2).
+This is useful for per-process data in forking servers that should be
+re-initialized in the child process after a fork, for example PRNG seeds,
+cryptographic secrets, etc.
+.IP
+The
+.B MADV_WIPEONFORK
+operation can only be applied to private anonymous pages (see
+.BR mmap (2)).
+.TP
+.BR MADV_KEEPONFORK " (since Linux 4.14)"
+Undo the effect of an earlier
+.BR MADV_WIPEONFORK .
 .SH RETURN VALUE
 On success,
 .BR madvise ()
@@ -457,6 +476,18 @@ or
 but the kernel was not configured with
 .BR CONFIG_KSM .
 .TP
+.B EINVAL
+.I advice
+is
+.BR MADV_FREE
+or
+.BR MADV_WIPEONFORK
+but the specified address range includes file, Huge TLB,
+.BR MAP_SHARED ,
+or
+.BR VM_PFNMAP
+ranges.
+.TP
 .B EIO
 (for
 .BR MADV_WILLNEED )
