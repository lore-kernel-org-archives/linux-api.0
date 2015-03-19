From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH] selftests: Add kselftest install tool
Date: Thu, 19 Mar 2015 14:57:58 -0600
Message-ID: <1426798679-8676-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

kselftest_install.sh tool installs selftests in default location
which is tools/testing/selftests/kselftest or an user specified
location. This tool invokes back-end selftests install target with
the install location.

Usage:
cd tools/testing/selftests
./kselftest_install.sh [ install_dir ]

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 tools/testing/selftests/kselftest_install.sh | 37 ++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100755 tools/testing/selftests/kselftest_install.sh

diff --git a/tools/testing/selftests/kselftest_install.sh b/tools/testing/selftests/kselftest_install.sh
new file mode 100755
index 0000000..1555fbd
--- /dev/null
+++ b/tools/testing/selftests/kselftest_install.sh
@@ -0,0 +1,37 @@
+#!/bin/bash
+#
+# Kselftest Install
+# Install kselftest tests
+# Author: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
+# Copyright (C) 2015 Samsung Electronics Co., Ltd.
+
+# This software may be freely redistributed under the terms of the GNU
+# General Public License (GPLv2).
+
+install_loc=`pwd`
+
+main()
+{
+	if [ $(basename $install_loc) !=  "selftests" ]; then
+		echo "$0: Please run it in selftests directory ..."
+		exit 1;
+	fi
+	if [ "$#" -eq 0 ]; then
+		echo "$0: Installing in default location - $install_loc ..."
+	elif [ ! -d "$1" ]; then
+		echo "$0: $1 doesn't exist!!"
+		exit 1;
+	else
+		install_loc=$1
+		echo "$0: Installing in specified location - $install_loc ..."
+	fi
+
+	install_dir=$install_loc/kselftest
+
+# Create install directory
+	mkdir -p $install_dir
+# Build tests
+	INSTALL_PATH=$install_dir make install
+}
+
+main "$@"
-- 
2.1.0
