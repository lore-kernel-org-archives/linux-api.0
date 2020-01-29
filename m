From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC PATCH xfstests] generic: add smoke test for AT_LINK_REPLACE
Date: Wed, 29 Jan 2020 00:58:27 -0800
Message-ID: <f23621bea2e8d5f919389131b84fa0226b90f502.1580253372.git.osandov__7338.8369449944$1580288328$gmane$org@fb.com>
References: <cover.1580251857.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1580251857.git.osandov-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: kernel-team-b10kYP2dOMg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>

Cc: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
---
 common/rc             |  2 +-
 tests/generic/593     | 97 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/593.out |  6 +++
 tests/generic/group   |  1 +
 4 files changed, 105 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/593
 create mode 100644 tests/generic/593.out

diff --git a/common/rc b/common/rc
index eeac1355..257f65a1 100644
--- a/common/rc
+++ b/common/rc
@@ -2172,7 +2172,7 @@ _require_xfs_io_command()
 		;;
 	"flink")
 		local testlink=$TEST_DIR/$$.link.xfs_io
-		testio=`$XFS_IO_PROG -F -f -c "flink $testlink" $testfile 2>&1`
+		testio=`$XFS_IO_PROG -F -f -c "flink $param $testlink" $testfile 2>&1`
 		rm -f $testlink > /dev/null 2>&1
 		;;
 	"-T")
diff --git a/tests/generic/593 b/tests/generic/593
new file mode 100755
index 00000000..8a9fee02
--- /dev/null
+++ b/tests/generic/593
@@ -0,0 +1,97 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Facebook.  All Rights Reserved.
+#
+# FS QA Test 593
+#
+# Smoke test linkat() with AT_LINK_REPLACE.
+#
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
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_xfs_io_command "-T"
+_require_xfs_io_command "flink" "-f"
+
+same_file() {
+	[[ "$(stat -c '%d %i' "$1")" = "$(stat -c '%d %i' "$2")" ]]
+}
+
+touch "$TEST_DIR/$seq.src"
+touch "$TEST_DIR/$seq.tgt"
+$XFS_IO_PROG -c "flink -f $TEST_DIR/$seq.tgt" "$TEST_DIR/$seq.src"
+same_file "$TEST_DIR/$seq.src" "$TEST_DIR/$seq.tgt" ||
+	echo "Target was not replaced"
+
+# Linking to the same file should be a noop.
+$XFS_IO_PROG -c "flink -f $TEST_DIR/$seq.src" "$TEST_DIR/$seq.src"
+$XFS_IO_PROG -c "flink -f $TEST_DIR/$seq.tgt" "$TEST_DIR/$seq.src"
+same_file "$TEST_DIR/$seq.src" "$TEST_DIR/$seq.tgt" || echo "Target changed?"
+
+# Should work with O_TMPFILE.
+$XFS_IO_PROG -c "flink -f $TEST_DIR/$seq.tgt" -T "$TEST_DIR"
+stat -c '%h' "$TEST_DIR/$seq.tgt"
+same_file "$TEST_DIR/$seq.src" "$TEST_DIR/$seq.tgt" &&
+	echo "Target was not replaced"
+
+# It's okay if the target doesn't exist.
+$XFS_IO_PROG -c "flink -f $TEST_DIR/$seq.tgt2" "$TEST_DIR/$seq.src"
+same_file "$TEST_DIR/$seq.src" "$TEST_DIR/$seq.tgt2" ||
+	echo "Target was not created"
+
+# Can't replace directories.
+mkdir "$TEST_DIR/$seq.dir"
+$XFS_IO_PROG -c "flink -f $TEST_DIR/$seq.dir" "$TEST_DIR/$seq.src"
+cd "$TEST_DIR/$seq.dir"
+$XFS_IO_PROG -c "flink -f ." "$TEST_DIR/$seq.src"
+$XFS_IO_PROG -c "flink -f .." "$TEST_DIR/$seq.src"
+cd - &> /dev/null
+
+# Can't replace local mount points.
+touch "$TEST_DIR/$seq.mnt"
+$MOUNT_PROG --bind "$TEST_DIR/$seq.mnt" "$TEST_DIR/$seq.mnt"
+$XFS_IO_PROG -c "flink -f $TEST_DIR/$seq.mnt" "$TEST_DIR/$seq.src"
+
+# Can replace mount points in other namespaces, though.
+unshare -m \
+	bash -c "$UMOUNT_PROG $TEST_DIR/$seq.mnt; $XFS_IO_PROG -c \"flink -f $TEST_DIR/$seq.mnt\" $TEST_DIR/$seq.src"
+if $UMOUNT_PROG "$TEST_DIR/$seq.mnt" &> /dev/null; then
+	echo "Mount point was not detached"
+fi
+same_file "$TEST_DIR/$seq.src" "$TEST_DIR/$seq.mnt" ||
+	echo "Mount point was not replaced"
+
+# Should replace symlinks, not follow them.
+touch "$TEST_DIR/$seq.symtgt"
+ln -s "$TEST_DIR/$seq.symtgt" "$TEST_DIR/$seq.sym"
+$XFS_IO_PROG -c "flink -f $TEST_DIR/$seq.sym" "$TEST_DIR/$seq.src"
+same_file "$TEST_DIR/$seq.src" "$TEST_DIR/$seq.sym" ||
+	echo "Symlink was not replaced"
+same_file "$TEST_DIR/$seq.src" "$TEST_DIR/$seq.symtgt" &&
+	echo "Symlink target was replaced"
+
+rm -rf "$TEST_DIR/$seq."*
+
+status=0
+exit
diff --git a/tests/generic/593.out b/tests/generic/593.out
new file mode 100644
index 00000000..834c34bf
--- /dev/null
+++ b/tests/generic/593.out
@@ -0,0 +1,6 @@
+QA output created by 593
+1
+flink: Is a directory
+flink: Is a directory
+flink: Is a directory
+flink: Device or resource busy
diff --git a/tests/generic/group b/tests/generic/group
index 6fe62505..0a87efca 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -595,3 +595,4 @@
 590 auto prealloc preallocrw
 591 auto quick rw pipe splice
 592 auto quick encrypt
+593 auto quick hardlink
-- 
2.25.0
