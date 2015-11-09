From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] Kselftest update for 4.4-rc1
Date: Mon, 9 Nov 2015 10:22:48 -0700
Message-ID: <5640D668.2050209@osg.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000800090800090504070007"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------000800090800090504070007
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi Linus,

Please pull the update for 4.4-rc1. This 12 patch update for
4.4-rc1 consists of a new pstore test and fixes to existing
tests. diff attached.

thanks,
-- Shuah

----------------------------------------------------------------------

The following changes since commit 25cb62b76430a91cc6195f902e61c2cb84ade622:

  Linux 4.3-rc5 (2015-10-11 11:09:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-4.4-rc1

for you to fetch changes up to 3b5bab390181968e403886a45c70f9c13b5b6d29:

  selftests: breakpoint: Actually build it (2015-11-03 16:55:08 -0700)

----------------------------------------------------------------
linux-kselftest-4.4-rc1

This 12 patch update for 4.4-rc1 consists of a new pstore
test and fixes to existing tests.

----------------------------------------------------------------
Ben Hutchings (6):
      selftests: Add missing #include directives
      selftests: memfd: Stop unnecessary rebuilds
      selftests: kprobe: Choose an always-defined function to probe
      selftests: Make scripts executable
      selftests: vm: Try harder to allocate huge pages
      selftests: breakpoint: Actually build it

Chunyan Zhang (1):
      selftests: memfd_test: Revised STACK_SIZE to make it 16-byte aligned

Hiraku Toyooka (2):
      selftests/pstore: add pstore test script for pre-reboot
      selftests/pstore: add pstore test scripts going with reboot

Kees Cook (1):
      selftests/seccomp: build and pass on arm64

Robert Sesek (1):
      selftests/seccomp: Be more precise with syscall arguments.

Yuan Sun (1):
      selftests: add .gitignore for efivarfs

 tools/testing/selftests/Makefile                   |   4 +
 tools/testing/selftests/breakpoints/Makefile       |   2 +-
 tools/testing/selftests/efivarfs/.gitignore        |   2 +
 .../ftrace/test.d/kprobe/add_and_remove.tc         |   2 +-
 .../selftests/ftrace/test.d/kprobe/busy_check.tc   |   2 +-
 .../selftests/ftrace/test.d/kprobe/kprobe_args.tc  |   2 +-
 .../ftrace/test.d/kprobe/kprobe_ftrace.tc          |  14 +--
 .../ftrace/test.d/kprobe/kretprobe_args.tc         |   2 +-
tools/testing/selftests/memfd/Makefile             |  12 +--
 tools/testing/selftests/memfd/memfd_test.c         |   3 +-
 tools/testing/selftests/memfd/run_fuse_test.sh     |   0
 tools/testing/selftests/mqueue/mq_open_tests.c     |   1 +
 tools/testing/selftests/mqueue/mq_perf_tests.c     |   1 +
 tools/testing/selftests/pstore/Makefile            |  15 +++
 tools/testing/selftests/pstore/common_tests        |  83 +++++++++++++++
 tools/testing/selftests/pstore/pstore_crash_test   |  30 ++++++
 .../selftests/pstore/pstore_post_reboot_tests      |  77 ++++++++++++++
 tools/testing/selftests/pstore/pstore_tests        |  30 ++++++
 tools/testing/selftests/seccomp/seccomp_bpf.c      | 117
+++++++++++++++------
 .../selftests/static_keys/test_static_keys.sh      |   0
 tools/testing/selftests/timers/nanosleep.c         |   1 +
 tools/testing/selftests/vm/run_vmtests             |  15 ++-
 22 files changed, 362 insertions(+), 53 deletions(-)
 create mode 100644 tools/testing/selftests/efivarfs/.gitignore
 mode change 100644 => 100755 tools/testing/selftests/memfd/run_fuse_test.sh
 create mode 100644 tools/testing/selftests/pstore/Makefile
 create mode 100755 tools/testing/selftests/pstore/common_tests
 create mode 100755 tools/testing/selftests/pstore/pstore_crash_test
 create mode 100755 tools/testing/selftests/pstore/pstore_post_reboot_tests
 create mode 100755 tools/testing/selftests/pstore/pstore_tests
 mode change 100644 => 100755
tools/testing/selftests/static_keys/test_static_keys.sh

--------------------------------------------------------------------------

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978

--------------000800090800090504070007
Content-Type: text/x-diff;
 name="4.4-rc1_kselftest_upate.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="4.4-rc1_kselftest_upate.diff"

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/M=
akefile
index cfe1213..2458288 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -13,6 +13,7 @@ TARGETS +=3D mount
 TARGETS +=3D mqueue
 TARGETS +=3D net
 TARGETS +=3D powerpc
+TARGETS +=3D pstore
 TARGETS +=3D ptrace
 TARGETS +=3D seccomp
 TARGETS +=3D size
@@ -65,6 +66,9 @@ clean_hotplug:
 		make -C $$TARGET clean; \
 	done;
=20
+run_pstore_crash:
+	make -C pstore run_crash
+
 INSTALL_PATH ?=3D install
 INSTALL_PATH :=3D $(abspath $(INSTALL_PATH))
 ALL_SCRIPT :=3D $(INSTALL_PATH)/run_kselftest.sh
diff --git a/tools/testing/selftests/breakpoints/Makefile b/tools/testing=
/selftests/breakpoints/Makefile
index d27108b..c0d9570 100644
--- a/tools/testing/selftests/breakpoints/Makefile
+++ b/tools/testing/selftests/breakpoints/Makefile
@@ -6,7 +6,7 @@ ifeq ($(ARCH),x86)
 TEST_PROGS :=3D breakpoint_test
 endif
=20
-all:
+all: $(TEST_PROGS)
=20
 include ../lib.mk
=20
diff --git a/tools/testing/selftests/efivarfs/.gitignore b/tools/testing/=
selftests/efivarfs/.gitignore
new file mode 100644
index 0000000..3361849
--- /dev/null
+++ b/tools/testing/selftests/efivarfs/.gitignore
@@ -0,0 +1,2 @@
+create-read
+open-unlink
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.=
tc b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
index a5a4262..c3843ed 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
@@ -5,7 +5,7 @@
=20
 echo 0 > events/enable
 echo > kprobe_events
-echo p:myevent do_fork > kprobe_events
+echo p:myevent _do_fork > kprobe_events
 grep myevent kprobe_events
 test -d events/kprobes/myevent
 echo > kprobe_events
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc b=
/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
index d8c7bb6..74507db 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
@@ -5,7 +5,7 @@
=20
 echo 0 > events/enable
 echo > kprobe_events
-echo p:myevent do_fork > kprobe_events
+echo p:myevent _do_fork > kprobe_events
 test -d events/kprobes/myevent
 echo 1 > events/kprobes/myevent/enable
 echo > kprobe_events && exit 1 # this must fail
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc =
b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
index c45ee27..64949d4 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
@@ -5,7 +5,7 @@
=20
 echo 0 > events/enable
 echo > kprobe_events
-echo 'p:testprobe do_fork $stack $stack0 +0($stack)' > kprobe_events
+echo 'p:testprobe _do_fork $stack $stack0 +0($stack)' > kprobe_events
 grep testprobe kprobe_events
 test -d events/kprobes/testprobe
 echo 1 > events/kprobes/testprobe/enable
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.t=
c b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
index ab41d2b..d6f2f49 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
@@ -6,31 +6,31 @@ grep function available_tracers || exit_unsupported # t=
his is configurable
=20
 # prepare
 echo nop > current_tracer
-echo do_fork > set_ftrace_filter
+echo _do_fork > set_ftrace_filter
 echo 0 > events/enable
 echo > kprobe_events
-echo 'p:testprobe do_fork' > kprobe_events
+echo 'p:testprobe _do_fork' > kprobe_events
=20
 # kprobe on / ftrace off
 echo 1 > events/kprobes/testprobe/enable
 echo > trace
 ( echo "forked")
 grep testprobe trace
-! grep 'do_fork <-' trace
+! grep '_do_fork <-' trace
=20
 # kprobe on / ftrace on
 echo function > current_tracer
 echo > trace
 ( echo "forked")
 grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
=20
 # kprobe off / ftrace on
 echo 0 > events/kprobes/testprobe/enable
 echo > trace
 ( echo "forked")
 ! grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
=20
 # kprobe on / ftrace on
 echo 1 > events/kprobes/testprobe/enable
@@ -38,14 +38,14 @@ echo function > current_tracer
 echo > trace
 ( echo "forked")
 grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
=20
 # kprobe on / ftrace off
 echo nop > current_tracer
 echo > trace
 ( echo "forked")
 grep testprobe trace
-! grep 'do_fork <-' trace
+! grep '_do_fork <-' trace
=20
 # cleanup
 echo nop > current_tracer
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.=
tc b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
index 3171798..0d09546 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
@@ -5,7 +5,7 @@
=20
 echo 0 > events/enable
 echo > kprobe_events
-echo 'r:testprobe2 do_fork $retval' > kprobe_events
+echo 'r:testprobe2 _do_fork $retval' > kprobe_events
 grep testprobe2 kprobe_events
 test -d events/kprobes/testprobe2
 echo 1 > events/kprobes/testprobe2/enable
diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selft=
ests/memfd/Makefile
index 3e7eb79..fd396ac 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -4,16 +4,16 @@ CFLAGS +=3D -I../../../../include/uapi/
 CFLAGS +=3D -I../../../../include/
 CFLAGS +=3D -I../../../../usr/include/
=20
-all:
-	$(CC) $(CFLAGS) memfd_test.c -o memfd_test
-
 TEST_PROGS :=3D memfd_test
=20
+all: $(TEST_PROGS)
+
 include ../lib.mk
=20
-build_fuse:
-	$(CC) $(CFLAGS) fuse_mnt.c `pkg-config fuse --cflags --libs` -o fuse_mn=
t
-	$(CC) $(CFLAGS) fuse_test.c -o fuse_test
+build_fuse: fuse_mnt fuse_test
+
+fuse_mnt.o: CFLAGS +=3D $(shell pkg-config fuse --cflags)
+fuse_mnt: LDFLAGS +=3D $(shell pkg-config fuse --libs)
=20
 run_fuse: build_fuse
 	@./run_fuse_test.sh || echo "fuse_test: [FAIL]"
diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/s=
elftests/memfd/memfd_test.c
index 0b9eafb..2654689 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -15,10 +15,11 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/syscall.h>
+#include <sys/wait.h>
 #include <unistd.h>
=20
 #define MFD_DEF_SIZE 8192
-#define STACK_SIZE 65535
+#define STACK_SIZE 65536
=20
 static int sys_memfd_create(const char *name,
 			    unsigned int flags)
diff --git a/tools/testing/selftests/memfd/run_fuse_test.sh b/tools/testi=
ng/selftests/memfd/run_fuse_test.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/mqueue/mq_open_tests.c b/tools/testi=
ng/selftests/mqueue/mq_open_tests.c
index 9c1a5d35..e0a74bd 100644
--- a/tools/testing/selftests/mqueue/mq_open_tests.c
+++ b/tools/testing/selftests/mqueue/mq_open_tests.c
@@ -31,6 +31,7 @@
 #include <sys/resource.h>
 #include <sys/stat.h>
 #include <mqueue.h>
+#include <error.h>
=20
 static char *usage =3D
 "Usage:\n"
diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/testi=
ng/selftests/mqueue/mq_perf_tests.c
index 8519e9e..8188f72 100644
--- a/tools/testing/selftests/mqueue/mq_perf_tests.c
+++ b/tools/testing/selftests/mqueue/mq_perf_tests.c
@@ -37,6 +37,7 @@
 #include <sys/stat.h>
 #include <mqueue.h>
 #include <popt.h>
+#include <error.h>
=20
 static char *usage =3D
 "Usage:\n"
diff --git a/tools/testing/selftests/pstore/Makefile b/tools/testing/self=
tests/pstore/Makefile
new file mode 100644
index 0000000..bd7abe2
--- /dev/null
+++ b/tools/testing/selftests/pstore/Makefile
@@ -0,0 +1,15 @@
+# Makefile for pstore selftests.
+# Expects pstore backend is registered.
+
+all:
+
+TEST_PROGS :=3D pstore_tests pstore_post_reboot_tests
+TEST_FILES :=3D common_tests pstore_crash_test
+
+include ../lib.mk
+
+run_crash:
+	@sh pstore_crash_test || { echo "pstore_crash_test: [FAIL]"; exit 1; }
+
+clean:
+	rm -rf logs/* *uuid
diff --git a/tools/testing/selftests/pstore/common_tests b/tools/testing/=
selftests/pstore/common_tests
new file mode 100755
index 0000000..3ea64d7
--- /dev/null
+++ b/tools/testing/selftests/pstore/common_tests
@@ -0,0 +1,83 @@
+#!/bin/sh
+
+# common_tests - Shell script commonly used by pstore test scripts
+#
+# Copyright (C) Hitachi Ltd., 2015
+#  Written by Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
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
+	rc=3D1
+    fi
+}
+
+check_files_exist() { # type of pstorefs file
+    if [ -e ${1}-${backend}-0 ]; then
+	prlog "ok"
+	for f in `ls ${1}-${backend}-*`; do
+            prlog -e "\t${f}"
+	done
+    else
+	prlog "FAIL"
+	rc=3D1
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
+	rc=3D1
+    fi
+}
+
+# Parameters
+TEST_STRING_PATTERN=3D"Testing pstore: uuid=3D"
+UUID=3D`cat /proc/sys/kernel/random/uuid`
+TOP_DIR=3D`absdir $0`
+LOG_DIR=3D$TOP_DIR/logs/`date +%Y%m%d-%H%M%S`_${UUID}/
+REBOOT_FLAG=3D$TOP_DIR/reboot_flag
+
+# Preparing logs
+LOG_FILE=3D$LOG_DIR/`basename $0`.log
+mkdir -p $LOG_DIR || errexit "Failed to make a log directory: $LOG_DIR"
+date > $LOG_FILE
+prlog() { # messages
+    /bin/echo "$@" | tee -a $LOG_FILE
+}
+
+# Starting tests
+rc=3D0
+prlog "=3D=3D=3D Pstore unit tests (`basename $0`) =3D=3D=3D"
+prlog "UUID=3D"$UUID
+
+prlog -n "Checking pstore backend is registered ... "
+backend=3D`cat /sys/module/pstore/parameters/backend`
+show_result $?
+prlog -e "\tbackend=3D${backend}"
+prlog -e "\tcmdline=3D`cat /proc/cmdline`"
+if [ $rc -ne 0 ]; then
+    exit 1
+fi
diff --git a/tools/testing/selftests/pstore/pstore_crash_test b/tools/tes=
ting/selftests/pstore/pstore_crash_test
new file mode 100755
index 0000000..1a4afe5
--- /dev/null
+++ b/tools/testing/selftests/pstore/pstore_crash_test
@@ -0,0 +1,30 @@
+#!/bin/sh
+
+# pstore_crash_test - Pstore test shell script which causes crash and re=
boot
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
+
+# save uuid file by different name because next test execution will repl=
ace it.
+mv $TOP_DIR/uuid $TOP_DIR/prev_uuid
+
+# create a file as reboot flag
+touch $REBOOT_FLAG
+sync
+
+# cause crash
+# Note: If you use kdump and want to see kmesg-* files after reboot, you=
 should
+#       specify 'crash_kexec_post_notifiers' in 1st kernel's cmdline.
+echo c > /proc/sysrq-trigger
diff --git a/tools/testing/selftests/pstore/pstore_post_reboot_tests b/to=
ols/testing/selftests/pstore/pstore_post_reboot_tests
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
+#  Written by Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
+#
+# Released under the terms of the GPL v2.
+
+. ./common_tests
+
+if [ -e $REBOOT_FLAG  ]; then
+    rm $REBOOT_FLAG
+else
+    prlog "pstore_crash_test has not been executed yet. we skip further =
tests."
+    exit 0
+fi
+
+prlog -n "Mounting pstore filesystem ... "
+mount_info=3D`grep pstore /proc/mounts`
+if [ $? -eq 0 ]; then
+    mount_point=3D`echo ${mount_info} | cut -d' ' -f2 | head -n1`
+    prlog "ok"
+else
+    mount none /sys/fs/pstore -t pstore
+    if [ $? -eq 0 ]; then
+	mount_point=3D`grep pstore /proc/mounts | cut -d' ' -f2 | head -n1`
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
+files=3D`ls dmesg-${backend}-*`
+operate_files $? "$files" grep_end_trace
+
+prlog -n "Checking console file contains oops end marker ... "
+grep -q "\---\[ end trace" console-${backend}-0
+show_result $?
+
+prlog -n "Checking pmsg file properly keeps the content written before c=
rash ... "
+prev_uuid=3D`cat $TOP_DIR/prev_uuid`
+if [ $? -eq 0 ]; then
+    nr_matched=3D`grep -c "$TEST_STRING_PATTERN" pmsg-${backend}-0`
+    if [ $nr_matched -eq 1 ]; then
+	grep -q "$TEST_STRING_PATTERN"$prev_uuid pmsg-${backend}-0
+	show_result $?
+    else
+	prlog "FAIL"
+	rc=3D1
+    fi
+else
+    prlog "FAIL"
+    rc=3D1
+fi
+
+prlog -n "Removing all files in pstore filesystem "
+files=3D`ls *-${backend}-*`
+operate_files $? "$files" rm
+
+exit $rc
diff --git a/tools/testing/selftests/pstore/pstore_tests b/tools/testing/=
selftests/pstore/pstore_tests
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
+#  Written by Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
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
+    rc=3D1
+fi
+
+exit $rc
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testin=
g/selftests/seccomp/seccomp_bpf.c
index 770f47a..e38cc54 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -19,15 +19,19 @@
 #include <linux/prctl.h>
 #include <linux/ptrace.h>
 #include <linux/seccomp.h>
-#include <poll.h>
 #include <pthread.h>
 #include <semaphore.h>
 #include <signal.h>
 #include <stddef.h>
 #include <stdbool.h>
 #include <string.h>
+#include <time.h>
 #include <linux/elf.h>
 #include <sys/uio.h>
+#include <sys/utsname.h>
+#include <sys/fcntl.h>
+#include <sys/mman.h>
+#include <sys/times.h>
=20
 #define _GNU_SOURCE
 #include <unistd.h>
@@ -428,14 +432,16 @@ TEST_SIGNAL(KILL_one, SIGSYS)
=20
 TEST_SIGNAL(KILL_one_arg_one, SIGSYS)
 {
+	void *fatal_address;
 	struct sock_filter filter[] =3D {
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
 			offsetof(struct seccomp_data, nr)),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 1, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_times, 1, 0),
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
 		/* Only both with lower 32-bit for now. */
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS, syscall_arg(0)),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0x0C0FFEE, 0, 1),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K,
+			(unsigned long)&fatal_address, 0, 1),
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
 	};
@@ -445,7 +451,8 @@ TEST_SIGNAL(KILL_one_arg_one, SIGSYS)
 	};
 	long ret;
 	pid_t parent =3D getppid();
-	pid_t pid =3D getpid();
+	struct tms timebuf;
+	clock_t clock =3D times(&timebuf);
=20
 	ret =3D prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
 	ASSERT_EQ(0, ret);
@@ -454,17 +461,22 @@ TEST_SIGNAL(KILL_one_arg_one, SIGSYS)
 	ASSERT_EQ(0, ret);
=20
 	EXPECT_EQ(parent, syscall(__NR_getppid));
-	EXPECT_EQ(pid, syscall(__NR_getpid));
-	/* getpid() should never return. */
-	EXPECT_EQ(0, syscall(__NR_getpid, 0x0C0FFEE));
+	EXPECT_LE(clock, syscall(__NR_times, &timebuf));
+	/* times() should never return. */
+	EXPECT_EQ(0, syscall(__NR_times, &fatal_address));
 }
=20
 TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
 {
+#ifndef __NR_mmap2
+	int sysno =3D __NR_mmap;
+#else
+	int sysno =3D __NR_mmap2;
+#endif
 	struct sock_filter filter[] =3D {
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
 			offsetof(struct seccomp_data, nr)),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 1, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, sysno, 1, 0),
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
 		/* Only both with lower 32-bit for now. */
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS, syscall_arg(5)),
@@ -478,7 +490,8 @@ TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
 	};
 	long ret;
 	pid_t parent =3D getppid();
-	pid_t pid =3D getpid();
+	int fd;
+	void *map1, *map2;
=20
 	ret =3D prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
 	ASSERT_EQ(0, ret);
@@ -486,10 +499,22 @@ TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
 	ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
 	ASSERT_EQ(0, ret);
=20
+	fd =3D open("/dev/zero", O_RDONLY);
+	ASSERT_NE(-1, fd);
+
 	EXPECT_EQ(parent, syscall(__NR_getppid));
-	EXPECT_EQ(pid, syscall(__NR_getpid));
-	/* getpid() should never return. */
-	EXPECT_EQ(0, syscall(__NR_getpid, 1, 2, 3, 4, 5, 0x0C0FFEE));
+	map1 =3D (void *)syscall(sysno,
+		NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd, PAGE_SIZE);
+	EXPECT_NE(MAP_FAILED, map1);
+	/* mmap2() should never return. */
+	map2 =3D (void *)syscall(sysno,
+		 NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd, 0x0C0FFEE);
+	EXPECT_EQ(MAP_FAILED, map2);
+
+	/* The test failed, so clean up the resources. */
+	munmap(map1, PAGE_SIZE);
+	munmap(map2, PAGE_SIZE);
+	close(fd);
 }
=20
 /* TODO(wad) add 64-bit versus 32-bit arg tests. */
@@ -1247,8 +1272,8 @@ void change_syscall(struct __test_metadata *_metada=
ta,
 	ret =3D ptrace(PTRACE_GETREGSET, tracee, NT_PRSTATUS, &iov);
 	EXPECT_EQ(0, ret);
=20
-#if defined(__x86_64__) || defined(__i386__) || defined(__aarch64__) || =
\
-    defined(__powerpc__) || defined(__s390__)
+#if defined(__x86_64__) || defined(__i386__) || defined(__powerpc__) || =
\
+    defined(__s390__)
 	{
 		regs.SYSCALL_NUM =3D syscall;
 	}
@@ -1262,6 +1287,18 @@ void change_syscall(struct __test_metadata *_metad=
ata,
 		EXPECT_EQ(0, ret);
 	}
=20
+#elif defined(__aarch64__)
+# ifndef NT_ARM_SYSTEM_CALL
+#  define NT_ARM_SYSTEM_CALL 0x404
+# endif
+	{
+		iov.iov_base =3D &syscall;
+		iov.iov_len =3D sizeof(syscall);
+		ret =3D ptrace(PTRACE_SETREGSET, tracee, NT_ARM_SYSTEM_CALL,
+			     &iov);
+		EXPECT_EQ(0, ret);
+	}
+
 #else
 	ASSERT_EQ(1, 0) {
 		TH_LOG("How is the syscall changed on this architecture?");
@@ -1272,6 +1309,8 @@ void change_syscall(struct __test_metadata *_metada=
ta,
 	if (syscall =3D=3D -1)
 		regs.SYSCALL_RET =3D 1;
=20
+	iov.iov_base =3D &regs;
+	iov.iov_len =3D sizeof(regs);
 	ret =3D ptrace(PTRACE_SETREGSET, tracee, NT_PRSTATUS, &iov);
 	EXPECT_EQ(0, ret);
 }
@@ -2005,20 +2044,25 @@ TEST(syscall_restart)
 		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 5, 0),
 		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_exit, 4, 0),
 		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_rt_sigreturn, 3, 0),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_poll, 4, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_nanosleep, 4, 0),
 		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_restart_syscall, 4, 0),
=20
 		/* Allow __NR_write for easy logging. */
 		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_write, 0, 1),
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
-		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE|0x100), /* poll */
-		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE|0x200), /* restart */
+		/* The nanosleep jump target. */
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE|0x100),
+		/* The restart_syscall jump target. */
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE|0x200),
 	};
 	struct sock_fprog prog =3D {
 		.len =3D (unsigned short)ARRAY_SIZE(filter),
 		.filter =3D filter,
 	};
+#if defined(__arm__)
+	struct utsname utsbuf;
+#endif
=20
 	ASSERT_EQ(0, pipe(pipefd));
=20
@@ -2027,10 +2071,7 @@ TEST(syscall_restart)
 	if (child_pid =3D=3D 0) {
 		/* Child uses EXPECT not ASSERT to deliver status correctly. */
 		char buf =3D ' ';
-		struct pollfd fds =3D {
-			.fd =3D pipefd[0],
-			.events =3D POLLIN,
-		};
+		struct timespec timeout =3D { };
=20
 		/* Attach parent as tracer and stop. */
 		EXPECT_EQ(0, ptrace(PTRACE_TRACEME));
@@ -2054,10 +2095,11 @@ TEST(syscall_restart)
 			TH_LOG("Failed to get sync data from read()");
 		}
=20
-		/* Start poll to be interrupted. */
+		/* Start nanosleep to be interrupted. */
+		timeout.tv_sec =3D 1;
 		errno =3D 0;
-		EXPECT_EQ(1, poll(&fds, 1, -1)) {
-			TH_LOG("Call to poll() failed (errno %d)", errno);
+		EXPECT_EQ(0, nanosleep(&timeout, NULL)) {
+			TH_LOG("Call to nanosleep() failed (errno %d)", errno);
 		}
=20
 		/* Read final sync from parent. */
@@ -2082,14 +2124,14 @@ TEST(syscall_restart)
 	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
 	ASSERT_EQ(1, write(pipefd[1], ".", 1));
=20
-	/* Wait for poll() to start. */
+	/* Wait for nanosleep() to start. */
 	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
 	ASSERT_EQ(true, WIFSTOPPED(status));
 	ASSERT_EQ(SIGTRAP, WSTOPSIG(status));
 	ASSERT_EQ(PTRACE_EVENT_SECCOMP, (status >> 16));
 	ASSERT_EQ(0, ptrace(PTRACE_GETEVENTMSG, child_pid, NULL, &msg));
 	ASSERT_EQ(0x100, msg);
-	EXPECT_EQ(__NR_poll, get_syscall(_metadata, child_pid));
+	EXPECT_EQ(__NR_nanosleep, get_syscall(_metadata, child_pid));
=20
 	/* Might as well check siginfo for sanity while we're here. */
 	ASSERT_EQ(0, ptrace(PTRACE_GETSIGINFO, child_pid, NULL, &info));
@@ -2100,7 +2142,7 @@ TEST(syscall_restart)
 	/* Verify signal delivery came from child (seccomp-triggered). */
 	EXPECT_EQ(child_pid, info.si_pid);
=20
-	/* Interrupt poll with SIGSTOP (which we'll need to handle). */
+	/* Interrupt nanosleep with SIGSTOP (which we'll need to handle). */
 	ASSERT_EQ(0, kill(child_pid, SIGSTOP));
 	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
 	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
@@ -2110,7 +2152,7 @@ TEST(syscall_restart)
 	ASSERT_EQ(0, ptrace(PTRACE_GETSIGINFO, child_pid, NULL, &info));
 	EXPECT_EQ(getpid(), info.si_pid);
=20
-	/* Restart poll with SIGCONT, which triggers restart_syscall. */
+	/* Restart nanosleep with SIGCONT, which triggers restart_syscall. */
 	ASSERT_EQ(0, kill(child_pid, SIGCONT));
 	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
 	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
@@ -2124,16 +2166,25 @@ TEST(syscall_restart)
 	ASSERT_EQ(SIGTRAP, WSTOPSIG(status));
 	ASSERT_EQ(PTRACE_EVENT_SECCOMP, (status >> 16));
 	ASSERT_EQ(0, ptrace(PTRACE_GETEVENTMSG, child_pid, NULL, &msg));
+
 	ASSERT_EQ(0x200, msg);
 	ret =3D get_syscall(_metadata, child_pid);
 #if defined(__arm__)
-	/* FIXME: ARM does not expose true syscall in registers. */
-	EXPECT_EQ(__NR_poll, ret);
-#else
-	EXPECT_EQ(__NR_restart_syscall, ret);
+	/*
+	 * FIXME:
+	 * - native ARM registers do NOT expose true syscall.
+	 * - compat ARM registers on ARM64 DO expose true syscall.
+	 */
+	ASSERT_EQ(0, uname(&utsbuf));
+	if (strncmp(utsbuf.machine, "arm", 3) =3D=3D 0) {
+		EXPECT_EQ(__NR_nanosleep, ret);
+	} else
 #endif
+	{
+		EXPECT_EQ(__NR_restart_syscall, ret);
+	}
=20
-	/* Write again to end poll. */
+	/* Write again to end test. */
 	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
 	ASSERT_EQ(1, write(pipefd[1], "!", 1));
 	EXPECT_EQ(0, close(pipefd[1]));
diff --git a/tools/testing/selftests/static_keys/test_static_keys.sh b/to=
ols/testing/selftests/static_keys/test_static_keys.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/timers/nanosleep.c b/tools/testing/s=
elftests/timers/nanosleep.c
index 8a3c29d..ff942ff 100644
--- a/tools/testing/selftests/timers/nanosleep.c
+++ b/tools/testing/selftests/timers/nanosleep.c
@@ -19,6 +19,7 @@
  *   GNU General Public License for more details.
  */
=20
+#include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selft=
ests/vm/run_vmtests
index 9179ce8..97ed1b2 100755
--- a/tools/testing/selftests/vm/run_vmtests
+++ b/tools/testing/selftests/vm/run_vmtests
@@ -20,13 +20,26 @@ done < /proc/meminfo
 if [ -n "$freepgs" ] && [ -n "$pgsize" ]; then
 	nr_hugepgs=3D`cat /proc/sys/vm/nr_hugepages`
 	needpgs=3D`expr $needmem / $pgsize`
-	if [ $freepgs -lt $needpgs ]; then
+	tries=3D2
+	while [ $tries -gt 0 ] && [ $freepgs -lt $needpgs ]; do
 		lackpgs=3D$(( $needpgs - $freepgs ))
+		echo 3 > /proc/sys/vm/drop_caches
 		echo $(( $lackpgs + $nr_hugepgs )) > /proc/sys/vm/nr_hugepages
 		if [ $? -ne 0 ]; then
 			echo "Please run this test as root"
 			exit 1
 		fi
+		while read name size unit; do
+			if [ "$name" =3D "HugePages_Free:" ]; then
+				freepgs=3D$size
+			fi
+		done < /proc/meminfo
+		tries=3D$((tries - 1))
+	done
+	if [ $freepgs -lt $needpgs ]; then
+		printf "Not enough huge pages available (%d < %d)\n" \
+		       $freepgs $needpgs
+		exit 1
 	fi
 else
 	echo "no hugetlbfs support in kernel?"

--------------000800090800090504070007--
