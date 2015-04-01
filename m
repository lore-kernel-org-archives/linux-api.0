From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH] selftests: Change memory on-off-test.sh name to be unique
Date: Tue, 31 Mar 2015 18:10:59 -0600
Message-ID: <1427847059-9353-1-git-send-email-shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, mpe@ellerman.id.au
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

cpu and memory hotplug scripts use the same name. Change
memory on-off-test.sh to mem-on-off-test.sh.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/memory-hotplug/Makefile    |   6 +-
 .../selftests/memory-hotplug/mem-on-off-test.sh    | 238 +++++++++++++++++++++
 .../selftests/memory-hotplug/on-off-test.sh        | 238 ---------------------
 3 files changed, 241 insertions(+), 241 deletions(-)
 create mode 100755 tools/testing/selftests/memory-hotplug/mem-on-off-test.sh
 delete mode 100755 tools/testing/selftests/memory-hotplug/on-off-test.sh

diff --git a/tools/testing/selftests/memory-hotplug/Makefile b/tools/testing/selftests/memory-hotplug/Makefile
index 598a1f6..afb2624 100644
--- a/tools/testing/selftests/memory-hotplug/Makefile
+++ b/tools/testing/selftests/memory-hotplug/Makefile
@@ -2,11 +2,11 @@ all:
 
 include ../lib.mk
 
-TEST_PROGS := on-off-test.sh
-override RUN_TESTS := ./on-off-test.sh -r 2 || echo "selftests: memory-hotplug [FAIL]"
+TEST_PROGS := mem-on-off-test.sh
+override RUN_TESTS := ./mem-on-off-test.sh -r 2 || echo "selftests: memory-hotplug [FAIL]"
 override EMIT_TESTS := echo "$(RUN_TESTS)"
 
 run_full_test:
-	@/bin/bash ./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
+	@/bin/bash ./mem-on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
 
 clean:
diff --git a/tools/testing/selftests/memory-hotplug/mem-on-off-test.sh b/tools/testing/selftests/memory-hotplug/mem-on-off-test.sh
new file mode 100755
index 0000000..6cddde0
--- /dev/null
+++ b/tools/testing/selftests/memory-hotplug/mem-on-off-test.sh
@@ -0,0 +1,238 @@
+#!/bin/bash
+
+SYSFS=
+
+prerequisite()
+{
+	msg="skip all tests:"
+
+	if [ $UID != 0 ]; then
+		echo $msg must be run as root >&2
+		exit 0
+	fi
+
+	SYSFS=`mount -t sysfs | head -1 | awk '{ print $3 }'`
+
+	if [ ! -d "$SYSFS" ]; then
+		echo $msg sysfs is not mounted >&2
+		exit 0
+	fi
+
+	if ! ls $SYSFS/devices/system/memory/memory* > /dev/null 2>&1; then
+		echo $msg memory hotplug is not supported >&2
+		exit 0
+	fi
+}
+
+#
+# list all hot-pluggable memory
+#
+hotpluggable_memory()
+{
+	local state=${1:-.\*}
+
+	for memory in $SYSFS/devices/system/memory/memory*; do
+		if grep -q 1 $memory/removable &&
+		   grep -q $state $memory/state; then
+			echo ${memory##/*/memory}
+		fi
+	done
+}
+
+hotplaggable_offline_memory()
+{
+	hotpluggable_memory offline
+}
+
+hotpluggable_online_memory()
+{
+	hotpluggable_memory online
+}
+
+memory_is_online()
+{
+	grep -q online $SYSFS/devices/system/memory/memory$1/state
+}
+
+memory_is_offline()
+{
+	grep -q offline $SYSFS/devices/system/memory/memory$1/state
+}
+
+online_memory()
+{
+	echo online > $SYSFS/devices/system/memory/memory$1/state
+}
+
+offline_memory()
+{
+	echo offline > $SYSFS/devices/system/memory/memory$1/state
+}
+
+online_memory_expect_success()
+{
+	local memory=$1
+
+	if ! online_memory $memory; then
+		echo $FUNCNAME $memory: unexpected fail >&2
+	elif ! memory_is_online $memory; then
+		echo $FUNCNAME $memory: unexpected offline >&2
+	fi
+}
+
+online_memory_expect_fail()
+{
+	local memory=$1
+
+	if online_memory $memory 2> /dev/null; then
+		echo $FUNCNAME $memory: unexpected success >&2
+	elif ! memory_is_offline $memory; then
+		echo $FUNCNAME $memory: unexpected online >&2
+	fi
+}
+
+offline_memory_expect_success()
+{
+	local memory=$1
+
+	if ! offline_memory $memory; then
+		echo $FUNCNAME $memory: unexpected fail >&2
+	elif ! memory_is_offline $memory; then
+		echo $FUNCNAME $memory: unexpected offline >&2
+	fi
+}
+
+offline_memory_expect_fail()
+{
+	local memory=$1
+
+	if offline_memory $memory 2> /dev/null; then
+		echo $FUNCNAME $memory: unexpected success >&2
+	elif ! memory_is_online $memory; then
+		echo $FUNCNAME $memory: unexpected offline >&2
+	fi
+}
+
+error=-12
+priority=0
+ratio=10
+
+while getopts e:hp:r: opt; do
+	case $opt in
+	e)
+		error=$OPTARG
+		;;
+	h)
+		echo "Usage $0 [ -e errno ] [ -p notifier-priority ] [ -r percent-of-memory-to-offline ]"
+		exit
+		;;
+	p)
+		priority=$OPTARG
+		;;
+	r)
+		ratio=$OPTARG
+		;;
+	esac
+done
+
+if ! [ "$error" -ge -4095 -a "$error" -lt 0 ]; then
+	echo "error code must be -4095 <= errno < 0" >&2
+	exit 1
+fi
+
+prerequisite
+
+echo "Test scope: $ratio% hotplug memory"
+echo -e "\t online all hotplug memory in offline state"
+echo -e "\t offline $ratio% hotplug memory in online state"
+echo -e "\t online all hotplug memory in offline state"
+
+#
+# Online all hot-pluggable memory
+#
+for memory in `hotplaggable_offline_memory`; do
+	echo offline-online $memory
+	online_memory_expect_success $memory
+done
+
+#
+# Offline $ratio percent of hot-pluggable memory
+#
+for memory in `hotpluggable_online_memory`; do
+	if [ $((RANDOM % 100)) -lt $ratio ]; then
+		echo online-offline $memory
+		offline_memory_expect_success $memory
+	fi
+done
+
+#
+# Online all hot-pluggable memory again
+#
+for memory in `hotplaggable_offline_memory`; do
+	echo offline-online $memory
+	online_memory_expect_success $memory
+done
+
+#
+# Test with memory notifier error injection
+#
+
+DEBUGFS=`mount -t debugfs | head -1 | awk '{ print $3 }'`
+NOTIFIER_ERR_INJECT_DIR=$DEBUGFS/notifier-error-inject/memory
+
+prerequisite_extra()
+{
+	msg="skip extra tests:"
+
+	/sbin/modprobe -q -r memory-notifier-error-inject
+	/sbin/modprobe -q memory-notifier-error-inject priority=$priority
+
+	if [ ! -d "$DEBUGFS" ]; then
+		echo $msg debugfs is not mounted >&2
+		exit 0
+	fi
+
+	if [ ! -d $NOTIFIER_ERR_INJECT_DIR ]; then
+		echo $msg memory-notifier-error-inject module is not available >&2
+		exit 0
+	fi
+}
+
+prerequisite_extra
+
+#
+# Offline $ratio percent of hot-pluggable memory
+#
+echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_OFFLINE/error
+for memory in `hotpluggable_online_memory`; do
+	if [ $((RANDOM % 100)) -lt $ratio ]; then
+		offline_memory_expect_success $memory
+	fi
+done
+
+#
+# Test memory hot-add error handling (offline => online)
+#
+echo $error > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_ONLINE/error
+for memory in `hotplaggable_offline_memory`; do
+	online_memory_expect_fail $memory
+done
+
+#
+# Online all hot-pluggable memory
+#
+echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_ONLINE/error
+for memory in `hotplaggable_offline_memory`; do
+	online_memory_expect_success $memory
+done
+
+#
+# Test memory hot-remove error handling (online => offline)
+#
+echo $error > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_OFFLINE/error
+for memory in `hotpluggable_online_memory`; do
+	offline_memory_expect_fail $memory
+done
+
+echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_OFFLINE/error
+/sbin/modprobe -q -r memory-notifier-error-inject
diff --git a/tools/testing/selftests/memory-hotplug/on-off-test.sh b/tools/testing/selftests/memory-hotplug/on-off-test.sh
deleted file mode 100755
index 6cddde0..0000000
--- a/tools/testing/selftests/memory-hotplug/on-off-test.sh
+++ /dev/null
@@ -1,238 +0,0 @@
-#!/bin/bash
-
-SYSFS=
-
-prerequisite()
-{
-	msg="skip all tests:"
-
-	if [ $UID != 0 ]; then
-		echo $msg must be run as root >&2
-		exit 0
-	fi
-
-	SYSFS=`mount -t sysfs | head -1 | awk '{ print $3 }'`
-
-	if [ ! -d "$SYSFS" ]; then
-		echo $msg sysfs is not mounted >&2
-		exit 0
-	fi
-
-	if ! ls $SYSFS/devices/system/memory/memory* > /dev/null 2>&1; then
-		echo $msg memory hotplug is not supported >&2
-		exit 0
-	fi
-}
-
-#
-# list all hot-pluggable memory
-#
-hotpluggable_memory()
-{
-	local state=${1:-.\*}
-
-	for memory in $SYSFS/devices/system/memory/memory*; do
-		if grep -q 1 $memory/removable &&
-		   grep -q $state $memory/state; then
-			echo ${memory##/*/memory}
-		fi
-	done
-}
-
-hotplaggable_offline_memory()
-{
-	hotpluggable_memory offline
-}
-
-hotpluggable_online_memory()
-{
-	hotpluggable_memory online
-}
-
-memory_is_online()
-{
-	grep -q online $SYSFS/devices/system/memory/memory$1/state
-}
-
-memory_is_offline()
-{
-	grep -q offline $SYSFS/devices/system/memory/memory$1/state
-}
-
-online_memory()
-{
-	echo online > $SYSFS/devices/system/memory/memory$1/state
-}
-
-offline_memory()
-{
-	echo offline > $SYSFS/devices/system/memory/memory$1/state
-}
-
-online_memory_expect_success()
-{
-	local memory=$1
-
-	if ! online_memory $memory; then
-		echo $FUNCNAME $memory: unexpected fail >&2
-	elif ! memory_is_online $memory; then
-		echo $FUNCNAME $memory: unexpected offline >&2
-	fi
-}
-
-online_memory_expect_fail()
-{
-	local memory=$1
-
-	if online_memory $memory 2> /dev/null; then
-		echo $FUNCNAME $memory: unexpected success >&2
-	elif ! memory_is_offline $memory; then
-		echo $FUNCNAME $memory: unexpected online >&2
-	fi
-}
-
-offline_memory_expect_success()
-{
-	local memory=$1
-
-	if ! offline_memory $memory; then
-		echo $FUNCNAME $memory: unexpected fail >&2
-	elif ! memory_is_offline $memory; then
-		echo $FUNCNAME $memory: unexpected offline >&2
-	fi
-}
-
-offline_memory_expect_fail()
-{
-	local memory=$1
-
-	if offline_memory $memory 2> /dev/null; then
-		echo $FUNCNAME $memory: unexpected success >&2
-	elif ! memory_is_online $memory; then
-		echo $FUNCNAME $memory: unexpected offline >&2
-	fi
-}
-
-error=-12
-priority=0
-ratio=10
-
-while getopts e:hp:r: opt; do
-	case $opt in
-	e)
-		error=$OPTARG
-		;;
-	h)
-		echo "Usage $0 [ -e errno ] [ -p notifier-priority ] [ -r percent-of-memory-to-offline ]"
-		exit
-		;;
-	p)
-		priority=$OPTARG
-		;;
-	r)
-		ratio=$OPTARG
-		;;
-	esac
-done
-
-if ! [ "$error" -ge -4095 -a "$error" -lt 0 ]; then
-	echo "error code must be -4095 <= errno < 0" >&2
-	exit 1
-fi
-
-prerequisite
-
-echo "Test scope: $ratio% hotplug memory"
-echo -e "\t online all hotplug memory in offline state"
-echo -e "\t offline $ratio% hotplug memory in online state"
-echo -e "\t online all hotplug memory in offline state"
-
-#
-# Online all hot-pluggable memory
-#
-for memory in `hotplaggable_offline_memory`; do
-	echo offline-online $memory
-	online_memory_expect_success $memory
-done
-
-#
-# Offline $ratio percent of hot-pluggable memory
-#
-for memory in `hotpluggable_online_memory`; do
-	if [ $((RANDOM % 100)) -lt $ratio ]; then
-		echo online-offline $memory
-		offline_memory_expect_success $memory
-	fi
-done
-
-#
-# Online all hot-pluggable memory again
-#
-for memory in `hotplaggable_offline_memory`; do
-	echo offline-online $memory
-	online_memory_expect_success $memory
-done
-
-#
-# Test with memory notifier error injection
-#
-
-DEBUGFS=`mount -t debugfs | head -1 | awk '{ print $3 }'`
-NOTIFIER_ERR_INJECT_DIR=$DEBUGFS/notifier-error-inject/memory
-
-prerequisite_extra()
-{
-	msg="skip extra tests:"
-
-	/sbin/modprobe -q -r memory-notifier-error-inject
-	/sbin/modprobe -q memory-notifier-error-inject priority=$priority
-
-	if [ ! -d "$DEBUGFS" ]; then
-		echo $msg debugfs is not mounted >&2
-		exit 0
-	fi
-
-	if [ ! -d $NOTIFIER_ERR_INJECT_DIR ]; then
-		echo $msg memory-notifier-error-inject module is not available >&2
-		exit 0
-	fi
-}
-
-prerequisite_extra
-
-#
-# Offline $ratio percent of hot-pluggable memory
-#
-echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_OFFLINE/error
-for memory in `hotpluggable_online_memory`; do
-	if [ $((RANDOM % 100)) -lt $ratio ]; then
-		offline_memory_expect_success $memory
-	fi
-done
-
-#
-# Test memory hot-add error handling (offline => online)
-#
-echo $error > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_ONLINE/error
-for memory in `hotplaggable_offline_memory`; do
-	online_memory_expect_fail $memory
-done
-
-#
-# Online all hot-pluggable memory
-#
-echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_ONLINE/error
-for memory in `hotplaggable_offline_memory`; do
-	online_memory_expect_success $memory
-done
-
-#
-# Test memory hot-remove error handling (online => offline)
-#
-echo $error > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_OFFLINE/error
-for memory in `hotpluggable_online_memory`; do
-	offline_memory_expect_fail $memory
-done
-
-echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/MEM_GOING_OFFLINE/error
-/sbin/modprobe -q -r memory-notifier-error-inject
-- 
2.1.0
