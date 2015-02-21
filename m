From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v10 9/12] xfstests: generic/064: Test multiple fallocate insert/collapse range calls
Date: Sun, 22 Feb 2015 00:45:51 +0900
Message-ID: <1424533554-28024-10-git-send-email-linkinjeon@gmail.com>
References: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: david@fromorbit.com, tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, bfoster@redhat.com, mtk.manpages@gmail.com, linux-man@vger.kernel.org, linux-api@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>
List-Id: linux-api@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This testcase(064) tries to test finsert range a single alternate block
multiple times and test merge code of collase range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/064     |   95 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/064.out |    2 ++
 tests/generic/group   |    1 +
 3 files changed, 98 insertions(+)
 create mode 100644 tests/generic/064
 create mode 100644 tests/generic/064.out

diff --git a/tests/generic/064 b/tests/generic/064
new file mode 100644
index 0000000..760539a
--- /dev/null
+++ b/tests/generic/064
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. generic/064
+#
+# Test multiple fallocate insert/collapse range calls on same file.
+# Call insert range a single alternate block multiple times until the file
+# is left with 100 extents and as much number of extents. And Call collapse
+# range about the previously inserted ranges to test merge code of collapse
+# range. Also check for data integrity and file system consistency.
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Samsung Electronics.  All Rights Reserved.
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
+#
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
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "fcollapse"
+src=$SCRATCH_MNT/testfile
+dest=$SCRATCH_MNT/testfile.dest
+BLOCKS=100
+BSIZE=`get_block_size $SCRATCH_MNT`
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount || _fail "mount failed"
+length=$(($BLOCKS * $BSIZE))
+
+# Write file
+_do "$XFS_IO_PROG -f -c \"pwrite 0 $length\" -c fsync $src"
+cp $src $dest
+extent_before=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
+
+# Insert alternate blocks
+for (( j=0; j < $(($BLOCKS/2)); j++ )); do
+	offset=$((($j*$BSIZE)*2))
+	_do "$XFS_IO_PROG -c \"finsert $offset $BSIZE\" $dest"
+done
+
+# Check if 100 extents are present
+$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
+
+_check_scratch_fs
+if [ $? -ne 0 ]; then
+	status=1
+	exit
+fi
+
+# Collapse alternate blocks
+for (( j=0; j < $(($BLOCKS/2)); j++ )); do
+	offset=$((($j*$BSIZE)))
+	_do "$XFS_IO_PROG -c \"fcollapse $offset $BSIZE\" $dest"
+done
+
+extent_after=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
+if [ $extent_before -ne $extent_after ]; then
+	echo "extents mismatched before = $extent_before after = $extent_after"
+fi
+
+# compare original file and test file.
+cmp $src $dest || _fail "file bytes check failed"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/064.out b/tests/generic/064.out
new file mode 100644
index 0000000..b217df5
--- /dev/null
+++ b/tests/generic/064.out
@@ -0,0 +1,2 @@
+QA output created by 064
+100
diff --git a/tests/generic/group b/tests/generic/group
index f7f7978..1bd4c33 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -66,6 +66,7 @@
 061 auto quick prealloc
 062 attr udf auto quick
 063 auto quick prealloc
+064 auto quick prealloc
 068 other auto freeze dangerous stress
 069 rw udf auto quick
 070 attr udf auto quick stress
-- 
1.7.9.5
