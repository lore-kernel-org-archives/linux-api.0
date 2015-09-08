From: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] selftests/pstore: add pstore test scripts going with
 reboot
Date: Tue, 08 Sep 2015 20:06:20 +0900
Message-ID: <20150908110620.9783.33823.stgit@arietta>
References: <20150908110615.9783.69477.stgit@arietta>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150908110615.9783.69477.stgit@arietta>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-api@vger.kernel.org

To test pstore in earnest, we have to cause kernel crash and check
pstore filesystem mouted after reboot.

We add two scripts:
 - pstore_crash_test
     This script to cause crash and reboot easily. It is executed by
     'make run_pstore_crash' in selftests.
 - pstore_post_reboot_tests
     This script includes test cases which check pstore's behavior after
     crash and reboot. It is executed together with pstore_tests by
     'make run_tests [-C pstore]' in selftests.

The test cases in pstore_post_reboot_tests are currently following.

- Check pstore backend is registered
- Mount pstore filesystem
- Check dmesg files exist in pstore filesystem
- Check console file exist in pstore filesystem
- Check pmsg file exist in pstore filesystem
- Check dmesg files contain oops end marker
- Check console file contain oops end marker
- Check pmsg file contain the string written before crash
- Remove all files in pstore filesystem

Example usage is following.

...
(kernel crash and reboot)
...
make: Entering directory '/home/root/selftests/pstore'
=== Pstore unit tests (pstore_tests)===
Checking pstore backend is registered ... ok
Checking pstore console is registered ... ok
Checking /dev/pmsg0 exists ... ok
Writing TEST_STRING to /dev/pmsg0 ... ok
selftests: pstore_tests [PASS]
=== Pstore unit tests (pstore_post_reboot_tests)===
Checking pstore backend is registered ... ok
Mounting pstore filesystem ... ok
Checking dmesg files exist in pstore filesystem ... ok
        dmesg-ramoops-0
        dmesg-ramoops-1
Checking console files exist in pstore filesystem ... ok
        console-ramoops-0
Checking pmsg files exist in pstore filesystem ... ok
        pmsg-ramoops-0
Checking dmesg files contains oops end marker
        dmesg-ramoops-0 ... ok
        dmesg-ramoops-1 ... ok
Checking console file contains oops end marker ... ok
Checking pmsg file contains TEST_STRING ... ok
Removing all files in pstore filesystem
        console-ramoops-0 ... ok
        dmesg-ramoops-0 ... ok
        dmesg-ramoops-1 ... ok
        pmsg-ramoops-0 ... ok
selftests: pstore_post_reboot_tests [PASS]
make: Leaving directory '/home/root/selftests/pstore'

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 tools/testing/selftests/pstore/Makefile            |    7 +
 tools/testing/selftests/pstore/common_tests        |    1 
 tools/testing/selftests/pstore/pstore_crash_test   |   27 ++++
 .../selftests/pstore/pstore_post_reboot_tests      |  126 ++++++++++++++++++++
 4 files changed, 159 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/pstore/pstore_crash_test
 create mode 100755 tools/testing/selftests/pstore/pstore_post_reboot_tests

diff --git a/tools/testing/selftests/pstore/Makefile b/tools/testing/selftests/pstore/Makefile
index 40b887d..32c408c 100644
--- a/tools/testing/selftests/pstore/Makefile
+++ b/tools/testing/selftests/pstore/Makefile
@@ -3,10 +3,13 @@
 
 all:
 
-TEST_PROGS := pstore_tests
-TEST_FILES := common_tests
+TEST_PROGS := pstore_tests pstore_post_reboot_tests
+TEST_FILES := common_tests pstore_crash_test
 
 include ../lib.mk
 
+run_crash:
+	@sh pstore_crash_test || echo "pstore_crash_test: [FAIL]"
+
 clean:
 	rm -rf logs/*
diff --git a/tools/testing/selftests/pstore/common_tests b/tools/testing/selftests/pstore/common_tests
index 98611c5..8003760 100755
--- a/tools/testing/selftests/pstore/common_tests
+++ b/tools/testing/selftests/pstore/common_tests
@@ -20,6 +20,7 @@ absdir() { # file_path
 # Parameters
 TOP_DIR=`absdir $0`
 LOG_DIR=$TOP_DIR/logs/`date +%Y%m%d-%H%M%S`/
+REBOOT_FILE=$TOP_DIR/reboot_flag
 TEST_STRING="Testing pstore"
 
 # Preparing logs
diff --git a/tools/testing/selftests/pstore/pstore_crash_test b/tools/testing/selftests/pstore/pstore_crash_test
new file mode 100755
index 0000000..6d0c422
--- /dev/null
+++ b/tools/testing/selftests/pstore/pstore_crash_test
@@ -0,0 +1,27 @@
+#!/bin/sh
+
+# pstore_crash_test - Pstore test shell script which causes crash and reboot
+#
+# Copyright (C) Hitachi Ltd., 2015
+#  Written by Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
+#
+# Released under the terms of the GPL v2.
+
+# exit if pstore backend is not registered
+. ./common_tests
+
+prlog "Causing kernel crash ..."
+
+# enable all functions triggered by sysrq
+echo 1 > /proc/sys/kernel/sysrq
+# setting to reboot in 3 seconds after panic
+echo 3 > /proc/sys/kernel/panic
+# setting to cause panic when oops occurs
+echo 1 > /proc/sys/kernel/panic_on_oops
+
+# create a file as reboot flag
+touch $REBOOT_FILE
+sync
+
+# cause crash
+echo c > /proc/sysrq-trigger
diff --git a/tools/testing/selftests/pstore/pstore_post_reboot_tests b/tools/testing/selftests/pstore/pstore_post_reboot_tests
new file mode 100755
index 0000000..0e33366
--- /dev/null
+++ b/tools/testing/selftests/pstore/pstore_post_reboot_tests
@@ -0,0 +1,126 @@
+#!/bin/sh
+
+# pstore_post_reboot_tests - Check pstore's behavior after crash/reboot
+#
+# Copyright (C) Hitachi Ltd., 2015
+#  Written by Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
+#
+# Released under the terms of the GPL v2.
+
+. ./common_tests
+
+if [ -e $REBOOT_FILE  ]; then
+    rm $REBOOT_FILE
+else
+    prlog "pstore_crash_test has not been executed yet. we skip further tests."
+    exit 0
+fi
+
+prlog -n "Mounting pstore filesystem ... "
+mount_info=`grep pstore /proc/mounts`
+if [ $? -eq 0 ]; then
+    mount_point=`echo ${mount_info} | cut -d' ' -f2 | head -n1`
+    prlog "ok"
+else
+    mount none /sys/fs/pstore -t pstore
+    if [ $? -eq 0 ]; then
+	mount_point=`grep pstore /proc/mounts | cut -d' ' -f2 | head -n1`
+	prlog "ok"
+    else
+	prlog "FAIL"
+	exit 1
+    fi
+fi
+
+cd ${mount_point}
+
+prlog -n "Checking dmesg files exist in pstore filesystem ... "
+if [ -e dmesg-${backend}-0 ]; then
+    prlog "ok"
+    for f in `ls dmesg-${backend}-*`; do
+	prlog -e "\t${f}"
+    done
+else
+    prlog "FAIL"
+    rc=1
+fi
+
+prlog -n "Checking console files exist in pstore filesystem ... "
+if [ -e console-${backend}-0 ]; then
+    prlog "ok"
+    for f in `ls console-${backend}-*`; do
+	prlog -e "\t${f}"
+    done
+else
+    prlog "FAIL"
+    rc=1
+fi
+
+prlog -n "Checking pmsg files exist in pstore filesystem ... "
+if [ -e pmsg-${backend}-0 ]; then
+    prlog "ok"
+    for f in `ls pmsg-${backend}-*`; do
+	prlog -e "\t${f}"
+    done
+else
+    prlog "FAIL"
+    rc=1
+fi
+
+prlog -n "Checking dmesg files contains oops end marker"
+files=`ls dmesg-${backend}-*`
+if [ $? -eq 0 ]; then
+    prlog
+    for f in $files; do
+	prlog -ne "\t${f} ... "
+	grep -q "\---\[ end trace" $f
+	if [ $? -eq 0 ]; then
+	    prlog "ok"
+	else
+	    prlog "FAIL"
+	    rc=1
+	fi
+    done
+else
+    prlog " ... FAIL"
+    rc=1
+fi
+
+prlog -n "Checking console file contains oops end marker ... "
+grep -q "\---\[ end trace" console-${backend}-0
+if [ $? -eq 0 ]; then
+    prlog "ok"
+else
+    prlog "FAIL"
+    rc=1
+fi
+
+prlog -n "Checking pmsg file contains TEST_STRING ... "
+grep -q "${TEST_STRING}" pmsg-${backend}-0
+if [ $? -eq 0 ]; then
+    prlog "ok"
+else
+    prlog "FAIL"
+    rc=1
+fi
+
+prlog -n "Removing all files in pstore filesystem "
+files=`ls *-${backend}-*`
+if [ $? -eq 0 ]; then
+    prlog
+    for f in ${files}; do
+	prlog -ne "\t${f} ... "
+	rm ${f}
+	if [ $? -eq 0 ]; then
+	    prlog "ok"
+	else
+	    prlog "FAIL"
+	    rc=1
+	fi
+    done
+else
+    prlog " ... FAIL"
+    rc=1
+fi
+
+exit $rc
