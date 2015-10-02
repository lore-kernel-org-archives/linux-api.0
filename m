From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH v2 2/2] selftests/pstore: add pstore test scripts going with
 reboot
Date: Fri, 02 Oct 2015 20:46:41 +0900
Message-ID: <20151002114641.20957.60082.stgit@arietta>
References: <20151002114637.20957.61769.stgit@arietta>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151002114637.20957.61769.stgit@arietta>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>, Shuah Khan <shuahkh@osg.samsung.com>, Mark Salyzyn <salyzyn@android.com>, Colin Cross <ccross@android.com>, Seiji Aguchi <seiji.aguchi.tr@hitachi.com>
List-Id: linux-api@vger.kernel.org

To test pstore in earnest, we have to cause kernel crash and check
pstore filesystem after reboot.

We add two scripts:
 - pstore_crash_test
     This script causes kernel crash and reboot. It is executed by
     'make run_pstore_crash' in selftests. It can also be used with kdump.
 - pstore_post_reboot_tests
     This script includes test cases which check pstore's behavior after
     crash and reboot. It is executed together with pstore_tests by
     'make run_tests [-C pstore]' in selftests.

The test cases in pstore_post_reboot_tests are currently following.

- Check pstore backend is registered
- Mount pstore filesystem
- Check dmesg/console/pmsg files exist in pstore filesystem
- Check dmesg/console files contain oops end marker
- Check pmsg file properly keeps the content written before crash
- Remove all files in pstore filesystem

Example usage is following.

  (before reboot)
  # cd /path/to/selftests
  # make run_tests -C pstore
  === Pstore unit tests (pstore_tests) ===
  UUID=b49b02cf-b0c2-4309-be43-b08c3971e37f
  ...
  selftests: pstore_tests [PASS]
  === Pstore unit tests (pstore_post_reboot_tests) ===
  UUID=953eb1bc-8e03-48d7-b27a-6552b24c5b7e
  Checking pstore backend is registered ... ok
          backend=ramoops
          cmdline=console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootwait mem=768M ramoops.mem_address=0x30000000 ramoops.mem_size=0x10000
  pstore_crash_test has not been executed yet. we skip further tests.
  selftests: pstore_post_reboot_tests [PASS]

  # make run_pstore_crash
  === Pstore unit tests (pstore_crash_test) ===
  UUID=93c8972d-1466-430b-8c4a-28d8681e74c6
  Checking pstore backend is registered ... ok
          backend=ramoops
          cmdline=console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootwait mem=768M ramoops.mem_address=0x30000000 ramoops.mem_size=0x10000
  Causing kernel crash ...
  (kernel crash and reboot)
  ...

  (after reboot)
  # make run_tests -C pstore
  === Pstore unit tests (pstore_tests) ===
  UUID=8e511e77-2285-499f-8bc0-900d9af1fbcc
  ...
  selftests: pstore_tests [PASS]
  === Pstore unit tests (pstore_post_reboot_tests) ===
  UUID=2dcc2132-4f3c-45aa-a38f-3b54bff8cef1
  Checking pstore backend is registered ... ok
          backend=ramoops
          cmdline=console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootwait mem=768M ramoops.mem_address=0x30000000 ramoops.mem_size=0x10000
  Mounting pstore filesystem ... ok
  Checking dmesg files exist in pstore filesystem ... ok
          dmesg-ramoops-0
          dmesg-ramoops-1
  Checking console files exist in pstore filesystem ... ok
          console-ramoops-0
  Checking pmsg files exist in pstore filesystem ... ok
          pmsg-ramoops-0
  Checking dmesg files contain oops end marker
          dmesg-ramoops-0 ... ok
          dmesg-ramoops-1 ... ok
  Checking console file contains oops end marker ... ok
  Checking pmsg file properly keeps the content written before crash ... ok
  Removing all files in pstore filesystem
          console-ramoops-0 ... ok
          dmesg-ramoops-0 ... ok
          dmesg-ramoops-1 ... ok
          pmsg-ramoops-0 ... ok
  selftests: pstore_post_reboot_tests [PASS]

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Salyzyn <salyzyn@android.com>
Cc: Seiji Aguchi <seiji.aguchi.tr@hitachi.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org
---
 tools/testing/selftests/Makefile                   |    3 +
 tools/testing/selftests/pstore/Makefile            |    7 +-
 tools/testing/selftests/pstore/common_tests        |   28 +++++++
 tools/testing/selftests/pstore/pstore_crash_test   |   30 ++++++++
 .../selftests/pstore/pstore_post_reboot_tests      |   77 ++++++++++++++++++++
 5 files changed, 143 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/pstore/pstore_crash_test
 create mode 100755 tools/testing/selftests/pstore/pstore_post_reboot_tests

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 1a8fb99..2458288 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -66,6 +66,9 @@ clean_hotplug:
 		make -C $$TARGET clean; \
 	done;
 
+run_pstore_crash:
+	make -C pstore run_crash
+
 INSTALL_PATH ?= install
 INSTALL_PATH := $(abspath $(INSTALL_PATH))
 ALL_SCRIPT := $(INSTALL_PATH)/run_kselftest.sh
diff --git a/tools/testing/selftests/pstore/Makefile b/tools/testing/selftests/pstore/Makefile
index 48623f7..bd7abe2 100644
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
+	@sh pstore_crash_test || { echo "pstore_crash_test: [FAIL]"; exit 1; }
+
 clean:
 	rm -rf logs/* *uuid
diff --git a/tools/testing/selftests/pstore/common_tests b/tools/testing/selftests/pstore/common_tests
index b1c3757..3ea64d7 100755
--- a/tools/testing/selftests/pstore/common_tests
+++ b/tools/testing/selftests/pstore/common_tests
@@ -26,11 +26,39 @@ show_result() { # result_value
     fi
 }
 
+check_files_exist() { # type of pstorefs file
+    if [ -e ${1}-${backend}-0 ]; then
+	prlog "ok"
+	for f in `ls ${1}-${backend}-*`; do
+            prlog -e "\t${f}"
+	done
+    else
+	prlog "FAIL"
+	rc=1
+    fi
+}
+
+operate_files() { # tested value, files, operation
+    if [ $1 -eq 0 ]; then
+	prlog
+	for f in $2; do
+	    prlog -ne "\t${f} ... "
+	    # execute operation
+	    $3 $f
+	    show_result $?
+	done
+    else
+	prlog " ... FAIL"
+	rc=1
+    fi
+}
+
 # Parameters
 TEST_STRING_PATTERN="Testing pstore: uuid="
 UUID=`cat /proc/sys/kernel/random/uuid`
 TOP_DIR=`absdir $0`
 LOG_DIR=$TOP_DIR/logs/`date +%Y%m%d-%H%M%S`_${UUID}/
+REBOOT_FLAG=$TOP_DIR/reboot_flag
 
 # Preparing logs
 LOG_FILE=$LOG_DIR/`basename $0`.log
diff --git a/tools/testing/selftests/pstore/pstore_crash_test b/tools/testing/selftests/pstore/pstore_crash_test
new file mode 100755
index 0000000..1a4afe5
--- /dev/null
+++ b/tools/testing/selftests/pstore/pstore_crash_test
@@ -0,0 +1,30 @@
+#!/bin/sh
+
+# pstore_crash_test - Pstore test shell script which causes crash and reboot
+#
+# Copyright (C) Hitachi Ltd., 2015
+#  Written by Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
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
+
+# save uuid file by different name because next test execution will replace it.
+mv $TOP_DIR/uuid $TOP_DIR/prev_uuid
+
+# create a file as reboot flag
+touch $REBOOT_FLAG
+sync
+
+# cause crash
+# Note: If you use kdump and want to see kmesg-* files after reboot, you should
+#       specify 'crash_kexec_post_notifiers' in 1st kernel's cmdline.
+echo c > /proc/sysrq-trigger
diff --git a/tools/testing/selftests/pstore/pstore_post_reboot_tests b/tools/testing/selftests/pstore/pstore_post_reboot_tests
new file mode 100755
index 0000000..6ccb154
--- /dev/null
+++ b/tools/testing/selftests/pstore/pstore_post_reboot_tests
@@ -0,0 +1,77 @@
+#!/bin/sh
+
+# pstore_post_reboot_tests - Check pstore's behavior after crash/reboot
+#
+# Copyright (C) Hitachi Ltd., 2015
+#  Written by Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
+#
+# Released under the terms of the GPL v2.
+
+. ./common_tests
+
+if [ -e $REBOOT_FLAG  ]; then
+    rm $REBOOT_FLAG
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
+check_files_exist dmesg
+
+prlog -n "Checking console files exist in pstore filesystem ... "
+check_files_exist console
+
+prlog -n "Checking pmsg files exist in pstore filesystem ... "
+check_files_exist pmsg
+
+prlog -n "Checking dmesg files contain oops end marker"
+grep_end_trace() {
+    grep -q "\---\[ end trace" $1
+}
+files=`ls dmesg-${backend}-*`
+operate_files $? "$files" grep_end_trace
+
+prlog -n "Checking console file contains oops end marker ... "
+grep -q "\---\[ end trace" console-${backend}-0
+show_result $?
+
+prlog -n "Checking pmsg file properly keeps the content written before crash ... "
+prev_uuid=`cat $TOP_DIR/prev_uuid`
+if [ $? -eq 0 ]; then
+    nr_matched=`grep -c "$TEST_STRING_PATTERN" pmsg-${backend}-0`
+    if [ $nr_matched -eq 1 ]; then
+	grep -q "$TEST_STRING_PATTERN"$prev_uuid pmsg-${backend}-0
+	show_result $?
+    else
+	prlog "FAIL"
+	rc=1
+    fi
+else
+    prlog "FAIL"
+    rc=1
+fi
+
+prlog -n "Removing all files in pstore filesystem "
+files=`ls *-${backend}-*`
+operate_files $? "$files" rm
+
+exit $rc
