From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH] selftests: Add tool to generate kselftest tar archive
Date: Thu, 19 Mar 2015 14:57:59 -0600
Message-ID: <1426798679-8676-2-git-send-email-shuahkh@osg.samsung.com>
References: <1426798679-8676-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426798679-8676-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

gen_kselftest_tar.sh tool generates kselftest tar archive. This tool
supports uncompressed tar, gz, bz, and xz compression formats and the
default compression format is gzip. This tool runs kselftest install
tool as its back-end.

Usage:
cd tools/testing/selftests
./gen_kselftest_tar [ tar | targz | tarbz2 | tarxz ]

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/gen_kselftest_tar.sh | 55 ++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100755 tools/testing/selftests/gen_kselftest_tar.sh

diff --git a/tools/testing/selftests/gen_kselftest_tar.sh b/tools/testing/selftests/gen_kselftest_tar.sh
new file mode 100755
index 0000000..17d5bd0
--- /dev/null
+++ b/tools/testing/selftests/gen_kselftest_tar.sh
@@ -0,0 +1,55 @@
+#!/bin/bash
+#
+# gen_kselftest_tar
+# Generate kselftest tarball
+# Author: Shuah Khan <shuahkh@osg.samsung.com>
+# Copyright (C) 2015 Samsung Electronics Co., Ltd.
+
+# This software may be freely redistributed under the terms of the GNU
+# General Public License (GPLv2).
+
+# main
+main()
+{
+	if [ "$#" -eq 0 ]; then
+		echo "$0: Generating default compression gzip"
+		copts="cvzf"
+		ext=".tar.gz"
+	else
+		case "$1" in
+			tar)
+				copts="cvf"
+				ext=".tar"
+				;;
+			targz)
+				copts="cvzf"
+				ext=".tar.gz"
+				;;
+			tarbz2)
+				copts="cvjf"
+				ext=".tar.bz2"
+				;;
+			tarxz)
+				copts="cvJf"
+				ext=".tar.xz"
+				;;
+			*)
+			echo "Unknown tarball format $1"
+			exit 1
+			;;
+	esac
+	fi
+
+	install_dir=./kselftest
+
+# Run install using INSTALL_KSFT_PATH override to generate install
+# directory
+./kselftest_install.sh
+tar $copts kselftest${ext} $install_dir
+echo "Kselftest archive kselftest${ext} created!"
+
+# clean up install directory
+rm -rf kselftest
+}
+
+main "$@"
-- 
2.1.0
