From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH v2 1/2] selftests/pstore: add pstore test script for
 pre-reboot
Date: Fri, 02 Oct 2015 20:46:39 +0900
Message-ID: <20151002114639.20957.61229.stgit@arietta>
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

The pstore_tests script includes test cases which check pstore's
behavior before crash (and reboot).

The test cases are currently following.

- Check pstore backend is registered
- Check pstore console is registered
- Check /dev/pmsg0 exists
- Write unique string to /dev/pmsg0

The unique string written to /dev/pmsg includes UUID. The UUID is also
left in 'uuid' file in order to enable us to check if the pmsg keeps the
string correctly after reboot.

Example usage is following.

  # cd /path/to/selftests
  # make run_tests -C pstore (or just .pstore/pstore_tests)
  make: Entering directory '/path/to/selftests/pstore'
  === Pstore unit tests (pstore_tests) ===
  UUID=b49b02cf-b0c2-4309-be43-b08c3971e37f
  Checking pstore backend is registered ... ok
          backend=ramoops
          cmdline=console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootwait mem=768M ramoops.mem_address=0x30000000 ramoops.mem_size=0x10000
  Checking pstore console is registered ... ok
  Checking /dev/pmsg0 exists ... ok
  Writing unique string to /dev/pmsg0 ... ok
  selftests: pstore_tests [PASS]
  make: Leaving directory '/path/to/selftests/pstore'

We can also see test logs later.

  # cat pstore/logs/20151001-072718_b49b02cf-b0c2-4309-be43-b08c3971e37f/pstore_tests.log
  Thu Oct  1 07:27:18 UTC 2015
  === Pstore unit tests (pstore_tests) ===
  UUID=b49b02cf-b0c2-4309-be43-b08c3971e37f
  Checking pstore backend is registered ... ok
          backend=ramoops
          cmdline=console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootwait mem=768M ramoops.mem_address=0x30000000 ramoops.mem_size=0x10000
  Checking pstore console is registered ... ok
  Checking /dev/pmsg0 exists ... ok
  Writing unique string to /dev/pmsg0 ... ok

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
 tools/testing/selftests/Makefile            |    1 
 tools/testing/selftests/pstore/Makefile     |   12 ++++++
 tools/testing/selftests/pstore/common_tests |   55 +++++++++++++++++++++++++++
 tools/testing/selftests/pstore/pstore_tests |   30 +++++++++++++++
 4 files changed, 98 insertions(+)
 create mode 100644 tools/testing/selftests/pstore/Makefile
 create mode 100755 tools/testing/selftests/pstore/common_tests
 create mode 100755 tools/testing/selftests/pstore/pstore_tests

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index cfe1213..1a8fb99 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -13,6 +13,7 @@ TARGETS += mount
 TARGETS += mqueue
 TARGETS += net
 TARGETS += powerpc
+TARGETS += pstore
 TARGETS += ptrace
 TARGETS += seccomp
 TARGETS += size
diff --git a/tools/testing/selftests/pstore/Makefile b/tools/testing/selftests/pstore/Makefile
new file mode 100644
index 0000000..48623f7
--- /dev/null
+++ b/tools/testing/selftests/pstore/Makefile
@@ -0,0 +1,12 @@
+# Makefile for pstore selftests.
+# Expects pstore backend is registered.
+
+all:
+
+TEST_PROGS := pstore_tests
+TEST_FILES := common_tests
+
+include ../lib.mk
+
+clean:
+	rm -rf logs/* *uuid
diff --git a/tools/testing/selftests/pstore/common_tests b/tools/testing/selftests/pstore/common_tests
new file mode 100755
index 0000000..b1c3757
--- /dev/null
+++ b/tools/testing/selftests/pstore/common_tests
@@ -0,0 +1,55 @@
+#!/bin/sh
+
+# common_tests - Shell script commonly used by pstore test scripts
+#
+# Copyright (C) Hitachi Ltd., 2015
+#  Written by Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
+#
+# Released under the terms of the GPL v2.
+
+# Utilities
+errexit() { # message
+    echo "Error: $1" 1>&2
+    exit 1
+}
+
+absdir() { # file_path
+    (cd `dirname $1`; pwd)
+}
+
+show_result() { # result_value
+    if [ $1 -eq 0 ]; then
+	prlog "ok"
+    else
+	prlog "FAIL"
+	rc=1
+    fi
+}
+
+# Parameters
+TEST_STRING_PATTERN="Testing pstore: uuid="
+UUID=`cat /proc/sys/kernel/random/uuid`
+TOP_DIR=`absdir $0`
+LOG_DIR=$TOP_DIR/logs/`date +%Y%m%d-%H%M%S`_${UUID}/
+
+# Preparing logs
+LOG_FILE=$LOG_DIR/`basename $0`.log
+mkdir -p $LOG_DIR || errexit "Failed to make a log directory: $LOG_DIR"
+date > $LOG_FILE
+prlog() { # messages
+    /bin/echo "$@" | tee -a $LOG_FILE
+}
+
+# Starting tests
+rc=0
+prlog "=== Pstore unit tests (`basename $0`) ==="
+prlog "UUID="$UUID
+
+prlog -n "Checking pstore backend is registered ... "
+backend=`cat /sys/module/pstore/parameters/backend`
+show_result $?
+prlog -e "\tbackend=${backend}"
+prlog -e "\tcmdline=`cat /proc/cmdline`"
+if [ $rc -ne 0 ]; then
+    exit 1
+fi
diff --git a/tools/testing/selftests/pstore/pstore_tests b/tools/testing/selftests/pstore/pstore_tests
new file mode 100755
index 0000000..f25d2a3
--- /dev/null
+++ b/tools/testing/selftests/pstore/pstore_tests
@@ -0,0 +1,30 @@
+#!/bin/sh
+
+# pstore_tests - Check pstore's behavior before crash/reboot
+#
+# Copyright (C) Hitachi Ltd., 2015
+#  Written by Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
+#
+# Released under the terms of the GPL v2.
+
+. ./common_tests
+
+prlog -n "Checking pstore console is registered ... "
+dmesg | grep -q "console \[pstore"
+show_result $?
+
+prlog -n "Checking /dev/pmsg0 exists ... "
+test -e /dev/pmsg0
+show_result $?
+
+prlog -n "Writing unique string to /dev/pmsg0 ... "
+if [ -e "/dev/pmsg0" ]; then
+    echo "${TEST_STRING_PATTERN}""$UUID" > /dev/pmsg0
+    show_result $?
+    echo "$UUID" > $TOP_DIR/uuid
+else
+    prlog "FAIL"
+    rc=1
+fi
+
+exit $rc
