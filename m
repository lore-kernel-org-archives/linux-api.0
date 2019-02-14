From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] generic: add a test for AT_UTIME_BTIME
Date: Thu, 14 Feb 2019 02:00:14 -0800
Message-ID: <c0d9cb0b181db011a3068fb96bb85e732f508b73.1550138186.git.osandov@fb.com>
References: <cover.1550136164.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc: kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Test that on filesystems supporting btime, the timestamp is updated as
expected.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 common/rc             | 14 ++++++++++
 tests/generic/526     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/526.out | 14 ++++++++++
 tests/generic/group   |  1 +
 4 files changed, 93 insertions(+)
 create mode 100755 tests/generic/526
 create mode 100644 tests/generic/526.out

diff --git a/common/rc b/common/rc
index b8ed1776..d2f43a21 100644
--- a/common/rc
+++ b/common/rc
@@ -3843,6 +3843,20 @@ _require_btime()
 	rm -f $TEST_DIR/test_creation_time
 }
 
+_require_utime_btime()
+{
+	_require_btime
+	_require_xfs_io_command utimes
+	testio=`$XFS_IO_PROG -f -c "utimes 0 0 0 0 0 0" "$TEST_DIR/$$.xfs_io" 2>&1`
+	echo $testio | grep -q "expected 4 arguments" && \
+		_notrun "xfs_io utimes btime support is missing"
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "updating inode creation time not supported by this filesystem"
+	echo $testio | grep -q "Invalid" && \
+		_notrun "updating inode creation time not supported by this kernel"
+	rm -f $testfile > /dev/null 2>&1
+}
+
 _require_scratch_btime()
 {
 	_require_scratch
diff --git a/tests/generic/526 b/tests/generic/526
new file mode 100755
index 00000000..c2e47a27
--- /dev/null
+++ b/tests/generic/526
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Omar Sandoval.  All Rights Reserved.
+#
+# FS QA Test 526
+#
+# Test basic AT_UTIME_BTIME functionality.
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
+	rm -f "$TEST_DIR/$$"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_utime_btime
+
+SEC=683153828
+UTIME_NOW=$(((1 << 30) - 1))
+UTIME_OMIT=$(((1 << 30) - 2))
+
+touch "$TEST_DIR/$$"
+
+echo "Set btime"
+$XFS_IO_PROG -c "utimes 0 $UTIME_OMIT 0 $UTIME_OMIT $SEC 0" "$TEST_DIR/$$"
+$XFS_IO_PROG -c 'statx -r' "$TEST_DIR/$$" | grep btime
+
+echo "Set atime and mtime"
+$XFS_IO_PROG -c "utimes 0 $UTIME_NOW 0 $UTIME_NOW" "$TEST_DIR/$$"
+$XFS_IO_PROG -c 'statx -r' "$TEST_DIR/$$" | grep btime
+
+echo "Omit btime"
+$XFS_IO_PROG -c "utimes 0 $UTIME_NOW 0 $UTIME_NOW 0 $UTIME_OMIT" "$TEST_DIR/$$"
+$XFS_IO_PROG -c 'statx -r' "$TEST_DIR/$$" | grep btime
+
+echo "Cycle mount"
+_test_cycle_mount
+$XFS_IO_PROG -c 'statx -r' "$TEST_DIR/$$" | grep btime
+
+echo "Set btime to now"
+$XFS_IO_PROG -c "utimes 0 $UTIME_OMIT 0 $UTIME_OMIT 0 $UTIME_NOW" "$TEST_DIR/$$"
+# The timestamp changed, so this shouldn't output anything.
+$XFS_IO_PROG -c 'statx -r' "$TEST_DIR/$$" | grep -w "$SEC"
+
+status=0
+exit
diff --git a/tests/generic/526.out b/tests/generic/526.out
new file mode 100644
index 00000000..f9ec18e9
--- /dev/null
+++ b/tests/generic/526.out
@@ -0,0 +1,14 @@
+QA output created by 526
+Set btime
+stat.btime.tv_sec = 683153828
+stat.btime.tv_nsec = 0
+Set atime and mtime
+stat.btime.tv_sec = 683153828
+stat.btime.tv_nsec = 0
+Omit btime
+stat.btime.tv_sec = 683153828
+stat.btime.tv_nsec = 0
+Cycle mount
+stat.btime.tv_sec = 683153828
+stat.btime.tv_nsec = 0
+Set btime to now
diff --git a/tests/generic/group b/tests/generic/group
index cfd003d3..2e0203fc 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -528,3 +528,4 @@
 523 auto quick attr
 524 auto quick
 525 auto quick rw
+526 auto quick
-- 
2.20.1
