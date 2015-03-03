From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH] selftests: Add install, generate tar, and run_kselftest tools
Date: Mon,  2 Mar 2015 21:48:08 -0700
Message-ID: <1425358088-9667-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>, davej@codemonkey.org.uk, mpe@ellerman.id.au
List-Id: linux-api@vger.kernel.org

kselftest_install.sh tool adds support for installing selftests
at user specified location/kselftest. By default this tool
will install selftests in the selftests/kselftest directory.
For example, kselftest_install /tmp will install tests under
/tmp/kselftest

gen_kselftest_tar.sh tool will generate user specified type of
tar archive. Default is .gz

run_kselftest.sh runs all installed selftests.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/gen_kselftest_tar.sh | 55 ++++++++++++++++++++++++
 tools/testing/selftests/kselftest_install.sh | 64 ++++++++++++++++++++++++++++
 tools/testing/selftests/run_kselftest.sh     | 46 ++++++++++++++++++++
 3 files changed, 165 insertions(+)
 create mode 100755 tools/testing/selftests/gen_kselftest_tar.sh
 create mode 100755 tools/testing/selftests/kselftest_install.sh
 create mode 100755 tools/testing/selftests/run_kselftest.sh

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
diff --git a/tools/testing/selftests/kselftest_install.sh b/tools/testing/selftests/kselftest_install.sh
new file mode 100755
index 0000000..8af1c3c
--- /dev/null
+++ b/tools/testing/selftests/kselftest_install.sh
@@ -0,0 +1,64 @@
+#!/bin/bash
+#
+# Kselftest Install
+# Install kselftest tests
+# Author: Shuah Khan <shuahkh@osg.samsung.com>
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
+	install_path=$install_loc/kselftest
+	install_dir=$install_loc/kselftest
+
+# Create install directory
+	mkdir -p $install_dir
+# Build tests
+	make all
+# Installs normal tests and skips special tests and kselftest tools
+# gen_kselftesr_tar.sh and kselftes_install.sh
+# Also skips problematic xxxx* file that gets created when execveat
+# test is built. The file name is too long and resulting in error
+# messages.
+	find `pwd`/* -type d -name rcutorture -prune -o -type f \
+		-executable -print | grep -v 'tar\|install\|xxxx' | \
+		xargs install -t $install_dir
+# Install shell scripts that aren't executables
+	find `pwd`/* -type d -name rcutorture -prune -o -name "*.sh" -print | \
+		grep -v 'tar\|install\|run\|on-off' | \
+		xargs install -t $install_dir
+# Special handling for cpu-hotplug and memory-hotplug .sh with the same name
+	install `pwd`/cpu-hotplug/on-off-test.sh \
+		$install_dir/cpu-on-off-test.sh
+	install `pwd`/memory-hotplug/on-off-test.sh \
+		$install_dir/mem-on-off-test.sh
+# Special handling for scripts without .sh extension
+	install `pwd`/vm/run_vmtests $install_dir
+	install `pwd`/net/run_netsocktests $install_dir
+	install `pwd`/net/run_afpackettests $install_dir
+	install `pwd`/sysctl/common_tests $install_dir
+# Install dependent directories for ftrace and exec tests
+	cp -r `pwd`/ftrace/test.d $install_dir
+	install `pwd`/exec/execveat.denatured $install_dir
+	cp -r `pwd`/exec/subdir $install_dir
+}
+
+main "$@"
diff --git a/tools/testing/selftests/run_kselftest.sh b/tools/testing/selftests/run_kselftest.sh
new file mode 100755
index 0000000..a6d3429
--- /dev/null
+++ b/tools/testing/selftests/run_kselftest.sh
@@ -0,0 +1,46 @@
+#!/bin/bash
+#
+# Run Kselftests
+# Install kselftest tests
+# Author: Shuah Khan <shuahkh@osg.samsung.com>
+# Copyright (C) 2015 Samsung Electronics Co., Ltd.
+
+# This software may be freely redistributed under the terms of the GNU
+
+# Exclude self (run_ksefltest) from test run.
+
+# Exclude dependecies that get run from master scripts
+#    common_tests - called from run_numerictests and run_stringtests
+#    huge* scripts - run from run_vmtests
+#    socket, psock_fanout, and psock_tpacket - run from net tests
+#    create-read and open-unlink - run from efivarfs.sh
+#    execveat.denatured - run from execveat
+# Exclude tests that need special setup or arguments for short runs
+# These are run after the normal tests are run
+#    unprivileged-remount-test
+#    memory-hotplug tests
+
+# Create symlink for execveat
+ln -s -f execveat execveat.symlink
+
+echo "Start Kselftest Run"
+find . -type f -executable -print |
+	grep -v 'common\|denatured\|huge\|mem-on\|run_kselftest\|socket\|psock\|create-read\|open-unlink\|script\|unprivileged' |
+while read -r prog
+do
+	echo "Running $prog ---"
+	./"$prog"
+done
+# Run memory-hotplug test in limited scope
+echo "Running memory hotplug test"
+./mem-on-off-test.sh -r 2
+# Run vm and mount tests
+echo "Running vm test ...."
+./run_vmtests
+echo "Running mount test ...."
+if [ -f /proc/self/uid_map ] ; then ./unprivileged-remount-test ; fi
+
+# Cleanup - execveat test creates temp files which will cause problems
+# when test is re-run
+rm -r -f xxxxx*
+echo "End Kselftest Run"
-- 
2.1.0
