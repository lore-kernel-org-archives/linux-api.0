From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 9/8] copy_file_range.2: New page documenting copy_file_range()
Date: Fri, 4 Sep 2015 16:17:03 -0400
Message-ID: <1441397823-1203-10-git-send-email-Anna.Schumaker@Netapp.com>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441397823-1203-1-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

copy_file_range() is a new system call for copying ranges of data
completely in the kernel.  This gives filesystems an opportunity to
implement some kind of "copy acceleration", such as reflinks or
server-side-copy (in the case of NFS).

Signed-off-by: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
---
 man2/copy_file_range.2 | 168 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 168 insertions(+)
 create mode 100644 man2/copy_file_range.2

diff --git a/man2/copy_file_range.2 b/man2/copy_file_range.2
new file mode 100644
index 0000000..4a4cb73
--- /dev/null
+++ b/man2/copy_file_range.2
@@ -0,0 +1,168 @@
+.\"This manpage is Copyright (C) 2015 Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
+.TH COPY 2 2015-8-31 "Linux" "Linux Programmer's Manual"
+.SH NAME
+copy_file_range \- Copy a range of data from one file to another
+.SH SYNOPSIS
+.nf
+.B #include <linux/copy.h>
+.B #include <sys/syscall.h>
+.B #include <unistd.h>
+
+.BI "ssize_t syscall(__NR_copy_file_range, int " fd_in ", loff_t * " off_in ",
+.BI "                int " fd_out ", loff_t * " off_out ", size_t " len ",
+.BI "                unsigned int " flags );
+.fi
+.SH DESCRIPTION
+The
+.BR copy_file_range ()
+system call performs an in-kernel copy between two file descriptors
+without all that tedious mucking about in userspace.
+It copies up to
+.I len
+bytes of data from file descriptor
+.I fd_in
+to file descriptor
+.I fd_out
+at
+.IR off_out .
+The file descriptors must not refer to the same file.
+
+The following semantics apply for
+.IR fd_in ,
+and similar statements apply to
+.IR off_out :
+.IP * 3
+If
+.I off_in
+is NULL, then bytes are read from
+.I fd_in
+starting from the current file offset and the current
+file offset is adjusted appropriately.
+.IP *
+If
+.I off_in
+is not NULL, then
+.I off_in
+must point to a buffer that specifies the starting
+offset where bytes from
+.I fd_in
+will be read.  The current file offset of
+.I fd_in
+is not changed, but
+.I off_in
+is adjusted appropriately.
+.PP
+The default behavior of
+.BR copy_file_range ()
+is filesystem specific, and might result in creating a
+copy-on-write reflink.
+In the event that a given filesystem does not implement
+any form of copy acceleration, the kernel will perform
+a deep copy of the requested range by reading bytes from
+.I fd_in
+and writing them to
+.IR fd_out .
+
+Currently, Linux only supports the following flag:
+.TP 1.9i
+.B COPY_REFLINK
+Only perform the copy if the filesystem can do it as a reflink.
+Do not fall back on performing a deep copy.
+.SH RETURN VALUE
+Upon successful completion,
+.BR copy_file_range ()
+will return the number of bytes copied between files.
+This could be less than the length originally requested.
+
+On error,
+.BR copy_file_range ()
+returns \-1 and
+.I errno
+is set to indicate the error.
+.SH ERRORS
+.TP
+.B EBADF
+One or more file descriptors are not valid,
+or do not have proper read-write mode.
+.TP
+.B EINVAL
+Requested range extends beyond the end of the file;
+.I flags
+argument is set to an invalid value.
+.TP
+.B EOPNOTSUPP
+.B COPY_REFLINK
+was specified in
+.IR flags ,
+but the target filesystem does not support reflinks.
+.TP
+.B EXDEV
+Target filesystem doesn't support cross-filesystem copies.
+.SH VERSIONS
+The
+.BR copy_file_range ()
+system call first appeared in Linux 4.3.
+.SH CONFORMING TO
+The
+.BR copy_file_range ()
+system call is a nonstandard Linux extension.
+.SH EXAMPLE
+.nf
+
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <linux/copy.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+
+int main(int argc, char **argv)
+{
+    int fd_in, fd_out;
+    struct stat stat;
+    loff_t len, ret;
+
+    if (argc != 3) {
+        fprintf(stderr, "Usage: %s <pathname> <pathname>\n", argv[0]);
+        exit(EXIT_FAILURE);
+    }
+
+    fd_in = open(argv[1], O_RDONLY);
+    if (fd_in == -1) {
+        perror("open (argv[1])");
+        exit(EXIT_FAILURE);
+    }
+
+    if (fstat(fd_in, &stat) == -1) {
+        perror("fstat");
+        exit(EXIT_FAILURE);
+    }
+    len = stat.st_size;
+
+    fd_out = open(argv[2], O_WRONLY | O_CREAT, 0644);
+    if (fd_out == -1) {
+        perror("open (argv[2])");
+        exit(EXIT_FAILURE);
+    }
+
+    do {
+        ret = syscall(__NR_copy_file_range, fd_in, NULL,
+                      fd_out, NULL, len, 0);
+        if (ret == -1) {
+            perror("copy_file_range");
+            exit(EXIT_FAILURE);
+        }
+
+        len -= ret;
+    } while (len > 0);
+
+    close(fd_in);
+    close(fd_out);
+    exit(EXIT_SUCCESS);
+}
+.fi
+.SH SEE ALSO
+.BR splice (2)
-- 
2.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
