From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv3 xfstests 2/3] generic: test openat and new O_BENEATH flag
Date: Mon,  9 Mar 2015 14:00:11 +0000
Message-ID: <1425909612-28034-3-git-send-email-drysdale@google.com>
References: <1425909612-28034-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425909612-28034-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Test basic openat(2) behaviour.

Test that if O_BENEATH flag is set, openat() will only
open paths that have no .. component and do not start
with /.  Symlinks are also checked for the same restrictions.

Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 .gitignore            |   1 +
 common/openat         |  61 ++++++++++++++++++++++++++++++
 src/Makefile          |   3 +-
 src/openat.c          | 100 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/151     |  89 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/151.out |   9 +++++
 tests/generic/152     | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/152.out |  23 ++++++++++++
 tests/generic/group   |   2 +
 9 files changed, 388 insertions(+), 1 deletion(-)
 create mode 100644 common/openat
 create mode 100644 src/openat.c
 create mode 100755 tests/generic/151
 create mode 100644 tests/generic/151.out
 create mode 100755 tests/generic/152
 create mode 100644 tests/generic/152.out

diff --git a/.gitignore b/.gitignore
index 2c9d640..6ea79ee 100644
--- a/.gitignore
+++ b/.gitignore
@@ -109,6 +109,7 @@
 /src/cloner
 /src/renameat2
 /src/t_rename_overwrite
+/src/openat

 # dmapi/ binaries
 /dmapi/src/common/cmd/read_invis
diff --git a/common/openat b/common/openat
new file mode 100644
index 0000000..8f04457
--- /dev/null
+++ b/common/openat
@@ -0,0 +1,61 @@
+######
+#
+# openat helpers
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Google, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+#
+# Setup a collection of files to be opened.
+#
+_openat_setup()
+{
+	local dir=$1
+
+	mkdir -p $dir/subdir
+	echo 0123456789 > $dir/topfile
+	echo 0123456789 > $dir/subdir/bottomfile
+
+	ln -s subdir/bottomfile $dir/symlinkdown
+	ln -s ../topfile $dir/subdir/symlinkup
+	ln -s $dir/topfile $dir/subdir/symlinkout
+	ln -s bottomfile  $dir/subdir/symlinkin
+}
+
+#
+# Check whether the openat wrapper program is available
+#
+_requires_openat()
+{
+	OPENAT_PROG=$here/src/openat
+        _require_command $OPENAT_PROG
+}
+
+#
+# This checks whether the O_BENEATH flag is supported by the openat syscall
+#
+_requires_o_beneath()
+{
+	# Kernels that don't support O_BENEATH will silently accept it, so
+	# check for O_BENEATH behavior: attempting to open an absolute
+	# path should fail with EPERM.
+	$OPENAT_PROG -t -b $TEST_DIR
+	if [ $? -ne 0 ]; then
+		_notrun "kernel doesn't support O_BENEATH flag in openat syscall"
+	fi
+}
diff --git a/src/Makefile b/src/Makefile
index 4781736..d9f0508 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -11,7 +11,8 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	devzero feature alloc fault fstest t_access_root \
 	godown resvtest writemod makeextents itrash rename \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
-	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite
+	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
+	openat

 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/openat.c b/src/openat.c
new file mode 100644
index 0000000..06e77c6
--- /dev/null
+++ b/src/openat.c
@@ -0,0 +1,100 @@
+/*
+ * Copyright (c) 2014 Google, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * This is a trivial wrapper around the openat syscall.
+ */
+
+#include "global.h"
+
+#if !defined(O_BENEATH)
+#if defined(__x86_64__) || defined(__i386__)
+#define O_BENEATH	040000000
+#endif
+#endif
+
+void usage(const char *progname)
+{
+	fprintf(stderr, "Usage: %s [-f dirname] [-b] [-n] [-t] <file>\n",
+		progname);
+	fprintf(stderr,"    -f dirname : use this dir for dfd\n");
+	fprintf(stderr,"    -b         : open with O_BENEATH\n");
+	fprintf(stderr,"    -n         : open with O_NOFOLLOW\n");
+	fprintf(stderr,"    -t         : test for expected EPERM failure\n");
+	fprintf(stderr,"    -h         : show this usage message\n");
+	exit(1);
+}
+
+int main(int argc, char *argv[])
+{
+	int dfd = AT_FDCWD;
+	const char *path = NULL;
+	int flags = O_RDONLY;
+	int test = 0;
+	const char *progname;
+	int opt;
+	int fd;
+
+	progname = strrchr(argv[0], '/');
+	progname = (progname ? progname + 1 : argv[0]);
+
+	while ((opt = getopt(argc, argv, "f:bnth")) != EOF) {
+		switch (opt) {
+		case 'f':
+			dfd = open(optarg, O_RDONLY);
+			if (dfd < 0) {
+				perror("Failed to open -f argument");
+				exit(1);
+			}
+			break;
+		case 'b':
+#ifdef O_BENEATH
+			flags |= O_BENEATH;
+#else
+			printf("O_BENEATH flag unavailable");
+			exit(1);
+#endif
+			break;
+		case 'n':
+			flags |= O_NOFOLLOW;
+			break;
+		case 't':
+			test = 1;
+			break;
+		case 'h':
+		default:
+			usage(progname);
+		}
+	}
+	if (argc - optind != 1)
+		usage(progname);
+	path = argv[optind];
+
+	/* Perform the openat operation */
+	fd = openat(dfd, path, flags);
+
+	if (fd >= 0) {
+		close(fd);
+		return test;
+	} else {
+		if (test) {
+			return (errno != EPERM);
+		} else {
+			perror("");
+			return 1;
+		}
+	}
+}
diff --git a/tests/generic/151 b/tests/generic/151
new file mode 100755
index 0000000..26584f4
--- /dev/null
+++ b/tests/generic/151
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. generic/039
+#
+# Check openat system call
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Google, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/openat
+
+_supported_fs generic
+_supported_os Linux
+
+_require_test
+_requires_openat
+_require_test_symlinks
+
+# real QA test starts here
+
+openat_dir=$TEST_DIR/$$
+rm -rf $openat_dir
+mkdir -p $openat_dir
+_openat_setup $openat_dir
+cd $openat_dir
+
+echo "normal behavior, AT_FDCWD"
+$OPENAT_PROG topfile
+$OPENAT_PROG subdir/bottomfile
+$OPENAT_PROG $openat_dir/topfile
+$OPENAT_PROG $openat_dir/subdir/bottomfile
+
+echo "normal behavior, dfd to main dir"
+$OPENAT_PROG -f $openat_dir topfile
+$OPENAT_PROG -f $openat_dir subdir/bottomfile
+$OPENAT_PROG -f $openat_dir subdir/../topfile
+
+echo "normal behavior, dfd to subdir"
+$OPENAT_PROG -f $openat_dir/subdir ../topfile
+$OPENAT_PROG -f $openat_dir/subdir bottomfile
+$OPENAT_PROG -f $openat_dir/subdir ../subdir/bottomfile
+$OPENAT_PROG -f $openat_dir/subdir symlinkup
+$OPENAT_PROG -f $openat_dir/subdir symlinkout
+
+echo "normal behavior, absolute path"
+$OPENAT_PROG $openat_dir/topfile
+$OPENAT_PROG -f $openat_dir $openat_dir/topfile
+$OPENAT_PROG -f $openat_dir/subdir $openat_dir/topfile
+
+echo "normal behavior, non-existent file (ENOENT)"
+$OPENAT_PROG bogus
+$OPENAT_PROG -f $openat_dir bogus
+$OPENAT_PROG -f $openat_dir/subdir bogus
+
+# success, all done
+status=0
+exit
+
diff --git a/tests/generic/151.out b/tests/generic/151.out
new file mode 100644
index 0000000..dc1168c
--- /dev/null
+++ b/tests/generic/151.out
@@ -0,0 +1,9 @@
+QA output created by 151
+normal behavior, AT_FDCWD
+normal behavior, dfd to main dir
+normal behavior, dfd to subdir
+normal behavior, absolute path
+normal behavior, non-existent file (ENOENT)
+No such file or directory
+No such file or directory
+No such file or directory
diff --git a/tests/generic/152 b/tests/generic/152
new file mode 100755
index 0000000..f5ccb25
--- /dev/null
+++ b/tests/generic/152
@@ -0,0 +1,101 @@
+#! /bin/bash
+# FS QA Test No. generic/040
+#
+# Check O_BENEATH argument to openat system call
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Google, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/openat
+
+_supported_fs generic
+_supported_os Linux
+
+_require_test
+_requires_openat
+_requires_o_beneath
+_require_test_symlinks
+
+# real QA test starts here
+
+openat_dir=$TEST_DIR/$$
+rm -rf $openat_dir
+mkdir -p $openat_dir
+_openat_setup $openat_dir
+cd $openat_dir
+
+echo "Test O_BENEATH:"
+$OPENAT_PROG -b topfile
+$OPENAT_PROG -b subdir/bottomfile
+
+$OPENAT_PROG -b -f $openat_dir topfile
+$OPENAT_PROG -b -f $openat_dir subdir/bottomfile
+$OPENAT_PROG -b -f $openat_dir/subdir bottomfile
+$OPENAT_PROG -b -f $openat_dir/subdir .
+
+echo "  Symlinks without .. or leading / are OK"
+$OPENAT_PROG -b -f $openat_dir symlinkdown
+$OPENAT_PROG -b -f $openat_dir subdir/symlinkin
+$OPENAT_PROG -b -f $openat_dir/subdir symlinkin
+
+echo "  ...unless of course we specify O_NOFOLLOW (ELOOP)"
+$OPENAT_PROG -b -n -f $openat_dir symlinkdown
+$OPENAT_PROG -b -n -f $openat_dir subdir/symlinkin
+$OPENAT_PROG -b -n -f $openat_dir/subdir symlinkin
+
+echo "  Can't open paths with .. in them (EPERM)"
+$OPENAT_PROG -b -f $openat_dir subdir/../topfile
+$OPENAT_PROG -b -f $openat_dir/subdir ../topfile
+$OPENAT_PROG -b -f $openat_dir/subdir ../subdir/bottomfile
+$OPENAT_PROG -b -f $openat_dir/subdir ..
+
+echo "  Can't open paths starting with / (EPERM)"
+$OPENAT_PROG -b $openat_dir/topfile
+$OPENAT_PROG -b -f $openat_dir $openat_dir/topfile
+$OPENAT_PROG -b -f $openat_dir/subdir $openat_dir/topfile
+
+echo "  Can't sneak around constraints with symlinks (EPERM)"
+$OPENAT_PROG -b -f $openat_dir/subdir symlinkup
+$OPENAT_PROG -b -f $openat_dir/subdir symlinkout
+$OPENAT_PROG -b -f $openat_dir/subdir ../symlinkdown
+$OPENAT_PROG -b -f $openat_dir subdir/symlinkup
+
+echo "  Can't open files below pre-resolved symlinks in /proc"
+$OPENAT_PROG -b -f /proc/self root/etc/passwd
+
+# success, all done
+status=0
+exit
+
diff --git a/tests/generic/152.out b/tests/generic/152.out
new file mode 100644
index 0000000..57d9f50
--- /dev/null
+++ b/tests/generic/152.out
@@ -0,0 +1,23 @@
+QA output created by 152
+Test O_BENEATH:
+  Symlinks without .. or leading / are OK
+  ...unless of course we specify O_NOFOLLOW (ELOOP)
+Too many levels of symbolic links
+Too many levels of symbolic links
+Too many levels of symbolic links
+  Can't open paths with .. in them (EPERM)
+Operation not permitted
+Operation not permitted
+Operation not permitted
+Operation not permitted
+  Can't open paths starting with / (EPERM)
+Operation not permitted
+Operation not permitted
+Operation not permitted
+  Can't sneak around constraints with symlinks (EPERM)
+Operation not permitted
+Operation not permitted
+Operation not permitted
+Operation not permitted
+  Can't open files below pre-resolved symlinks in /proc
+Operation not permitted
diff --git a/tests/generic/group b/tests/generic/group
index f2eb87a..030a076 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -96,6 +96,8 @@
 133 rw auto
 135 metadata auto quick
 141 rw auto quick
+151 metadata auto quick
+152 metadata auto quick
 169 rw metadata auto quick
 184 metadata auto quick
 192 atime auto
--
1.9.1
