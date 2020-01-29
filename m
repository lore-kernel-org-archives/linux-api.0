From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC PATCH man-pages] link.2: Document new AT_LINK_REPLACE flag
Date: Wed, 29 Jan 2020 00:58:28 -0800
Message-ID: <8480e876e2810afb0485a080ce1cef182f86967f.1580253342.git.osandov__40473.3399789379$1580288328$gmane$org@fb.com>
References: <cover.1580251857.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1580251857.git.osandov-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: kernel-team-b10kYP2dOMg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>

Signed-off-by: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
---
 man2/link.2 | 191 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 191 insertions(+)

diff --git a/man2/link.2 b/man2/link.2
index 649ba00c7..0097e3071 100644
--- a/man2/link.2
+++ b/man2/link.2
@@ -174,6 +174,60 @@ like this:
 linkat(AT_FDCWD, "/proc/self/fd/<fd>", newdirfd,
        newname, AT_SYMLINK_FOLLOW);
 .EE
+.TP
+.BR AT_LINK_REPLACE " (since Linux 5.7)"
+If
+.I newpath
+exists, replace it atomically.
+There is no point at which another process attempting to access
+.I newpath
+will find it missing.
+If
+.I newpath
+exists but the operation fails,
+the original entry specified by
+.I newpath
+will remain in place.
+This does not guarantee data integrity;
+see EXAMPLE below for how to use this for crash-safe file replacement with
+.BR O_TMPFILE .
+.IP
+If
+.I newpath
+is replaced,
+any other hard links referring to the original file are unaffected.
+Open file descriptors for
+.I newpath
+are also unaffected.
+.IP
+.I newpath
+must not be a directory.
+.IP
+If the entry specified by
+.I newpath
+refers to the file specified by
+.I oldpath,
+.BR linkat ()
+does nothing and returns a success status.
+Note that this comparison does not follow mounts on
+.IR newpath .
+.IP
+Otherwise,
+.I newpath
+must not be a mount point in the local namespace.
+If it is a mount point in another namespace and the operation succeeds,
+all mounts are detached from
+.I newpath
+in all namespaces, as is the case for
+.BR rename (2),
+.BR rmdir (2),
+and
+.BR unlink (2).
+.IP
+If
+.I newpath
+refers to a symbolic link,
+the link will be replaced.
 .in
 .PP
 Before kernel 2.6.18, the
@@ -293,10 +347,34 @@ or
 .I newdirfd
 is not a valid file descriptor.
 .TP
+.B EBUSY
+.B AT_LINK_REPLACE
+was specified in
+.IR flags ,
+.I newpath
+does not refer to the file specified by
+.IR oldpath ,
+and
+.I newpath
+is in use by the system
+(for example, it is a mount point in the local namespace).
+.TP
 .B EINVAL
 An invalid flag value was specified in
 .IR flags .
 .TP
+.B EINVAL
+The filesystem does not support one of the flags in
+.IR flags .
+.TP
+.B EISDIR
+.B AT_LINK_REPLACE
+was specified in
+.I flags
+and
+.I newpath
+refers to an existing directory.
+.TP
 .B ENOENT
 .B AT_EMPTY_PATH
 was specified in
@@ -344,6 +422,31 @@ was specified in
 is an empty string, and
 .IR olddirfd
 refers to a directory.
+.TP
+.B EPERM
+.B AT_LINK_REPLACE
+was specified in
+.I flags
+and
+.I newpath
+refers to an immutable or append-only file
+or a file in an immutable or append-only directory.
+(See
+.BR ioctl_iflags (2).)
+.TP
+.BR EPERM " or " EACCES
+.B AT_LINK_REPLACE
+was specified in
+.IR flags ,
+the directory containing
+.I newpath
+has the sticky bit
+.RB ( S_ISVTX )
+set, and the process's effective UID is neither the UID of the file to
+be deleted nor that of the directory containing it, and
+the process is not privileged (Linux: does not have the
+.B CAP_FOWNER
+capability).
 .SH VERSIONS
 .BR linkat ()
 was added to Linux in kernel 2.6.16;
@@ -421,6 +524,94 @@ performs the link creation and dies before it can say so.
 Use
 .BR stat (2)
 to find out if the link got created.
+.SH EXAMPLE
+The following program demonstrates the use of
+.BR linkat ()
+with
+.B AT_LINK_REPLACE
+and
+.BR open (2)
+with
+.B O_TMPFILE
+for crash-safe file replacement.
+.SS Example output
+.in +4n
+.EX
+$ \fBecho bar > foo\fP
+$ \fB./replace foo\fP
+$ \fBcat foo\fP
+hello, world
+.EE
+.in
+.SS Program source (replace.c)
+.EX
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <libgen.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+int
+main(int argc, char *argv[])
+{
+	char *path, *dirc, *basec, *dir, *base;
+	int fd, dirfd;
+
+	if (argc != 2) {
+		fprintf(stderr, "usage: %s PATH\en", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	path = argv[1];
+
+	dirc = strdup(path);
+	basec = strdup(path);
+	if (!dirc || !basec) {
+		perror("strdup");
+		exit(EXIT_FAILURE);
+	}
+	dir = dirname(dirc);
+	base = basename(basec);
+
+	/* Open the parent directory. */
+	dirfd = open(dir, O_DIRECTORY | O_RDONLY);
+	if (dirfd == -1) {
+		perror("open");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Open a temporary file, write data to it, and persist it. */
+	fd = open(dir, O_TMPFILE | O_RDWR, 0644);
+	if (fd == -1) {
+		perror("open");
+		exit(EXIT_FAILURE);
+	}
+	if (write(fd, "hello, world\en", 13) == -1) {
+		perror("write");
+		exit(EXIT_FAILURE);
+	}
+	if (fsync(fd) == -1) {
+		perror("fsync");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Replace the original file and persist the directory. */
+	if (linkat(fd, "", dirfd, base, AT_EMPTY_PATH | AT_LINK_REPLACE) == -1) {
+		perror("linkat");
+		exit(EXIT_FAILURE);
+	}
+	if (fsync(dirfd) == -1) {
+		perror("fsync");
+		exit(EXIT_FAILURE);
+	}
+
+	exit(EXIT_SUCCESS);
+}
+.EE
 .SH SEE ALSO
 .BR ln (1),
 .BR open (2),
-- 
2.25.0
