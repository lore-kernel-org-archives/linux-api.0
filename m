From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [GIT PULL] Kselftest updates from 4.5-rc1
Date: Fri, 15 Jan 2016 13:34:24 -0700
Message-ID: <569957D0.4080405@osg.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070800080308030701080602"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "shuahkhan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shuahkhan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------070800080308030701080602
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi Linus,

Please pull the following update for 4.5-rc1.
diff attached.

Thanks,
-- Shuah

-------------------------------------------------------------
The following changes since commit 8005c49d9aea74d382f474ce11afbbc7d7130bec:

  Linux 4.4-rc1 (2015-11-15 17:00:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/linux-kselftest-4.5-rc1

for you to fetch changes up to 1b1fe542b6f010cf6bc7e1c92805e1c0e133e007:

  selftests: firmware: add empty string and async tests (2016-01-07
14:41:07 -0700)

----------------------------------------------------------------
linux-kselftest-4.5-rc1

This 14 patch update:

- adds a new test for intel_pstate driver
- adds empty string and async test cases to
  firmware class tests
- fixes and cleans up several existing tests

----------------------------------------------------------------
Bamvor Jian Zhang (3):
      selftests/capabilities: clean up for Makefile
      selftests/capabilities: actually test it
      selftest/ipc: actually test it

Brian Norris (5):
      test: firmware_class: report errors properly on failure
      test: firmware_class: use kstrndup() where appropriate
      test: firmware_class: add asynchronous request trigger
      firmware: actually return NULL on failed request_firmware_nowait()
      selftests: firmware: add empty string and async tests

Kees Cook (1):
      selftests/seccomp: fix 32-bit build warnings

Prarit Bhargava (1):
      tools, testing, add test for intel_pstate driver

Yuan Sun (4):
      update .gitignore in selftests/vm
      update .gitignore in selftests/timers
      add ptrace/.gitignore
      add breakpoints/.gitignore

 drivers/base/firmware_class.c                     |   8 +-
 lib/test_firmware.c                               |  79 ++++++++++++++-
 tools/testing/selftests/Makefile                  |   2 +
 tools/testing/selftests/breakpoints/.gitignore    |   1 +
 tools/testing/selftests/capabilities/Makefile     |  21 ++--
 tools/testing/selftests/firmware/fw_filesystem.sh |  29 +++++-
 tools/testing/selftests/intel_pstate/Makefile     |  15 +++
 tools/testing/selftests/intel_pstate/aperf.c      |  80 +++++++++++++++
 tools/testing/selftests/intel_pstate/msr.c        |  39 ++++++++
 tools/testing/selftests/intel_pstate/run.sh       | 113
++++++++++++++++++++++
 tools/testing/selftests/ptrace/.gitignore         |   1 +
 tools/testing/selftests/seccomp/test_harness.h    |   5 +-
 tools/testing/selftests/timers/.gitignore         |   1 +
 tools/testing/selftests/vm/.gitignore             |   5 +
 14 files changed, 376 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/breakpoints/.gitignore
 create mode 100644 tools/testing/selftests/intel_pstate/Makefile
 create mode 100644 tools/testing/selftests/intel_pstate/aperf.c
 create mode 100644 tools/testing/selftests/intel_pstate/msr.c
 create mode 100755 tools/testing/selftests/intel_pstate/run.sh
 create mode 100644 tools/testing/selftests/ptrace/.gitignore

--------------------------------------------------------------------


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978

--------------070800080308030701080602
Content-Type: text/x-diff;
 name="4.5-rc1_pull_req.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="4.5-rc1_pull_req.diff"

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.=
c
index 8524450..b9250e5 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1118,15 +1118,17 @@ static int
 _request_firmware(const struct firmware **firmware_p, const char *name,
 		  struct device *device, unsigned int opt_flags)
 {
-	struct firmware *fw;
+	struct firmware *fw =3D NULL;
 	long timeout;
 	int ret;
=20
 	if (!firmware_p)
 		return -EINVAL;
=20
-	if (!name || name[0] =3D=3D '\0')
-		return -EINVAL;
+	if (!name || name[0] =3D=3D '\0') {
+		ret =3D -EINVAL;
+		goto out;
+	}
=20
 	ret =3D _request_firmware_prepare(&fw, name, device);
 	if (ret <=3D 0) /* error or already assigned */
diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 86374c1..a3e8ec3 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/printk.h>
+#include <linux/completion.h>
 #include <linux/firmware.h>
 #include <linux/device.h>
 #include <linux/fs.h>
@@ -54,10 +55,9 @@ static ssize_t trigger_request_store(struct device *de=
v,
 	int rc;
 	char *name;
=20
-	name =3D kzalloc(count + 1, GFP_KERNEL);
+	name =3D kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
 		return -ENOSPC;
-	memcpy(name, buf, count);
=20
 	pr_info("loading '%s'\n", name);
=20
@@ -65,17 +65,73 @@ static ssize_t trigger_request_store(struct device *d=
ev,
 	release_firmware(test_firmware);
 	test_firmware =3D NULL;
 	rc =3D request_firmware(&test_firmware, name, dev);
-	if (rc)
+	if (rc) {
 		pr_info("load of '%s' failed: %d\n", name, rc);
-	pr_info("loaded: %zu\n", test_firmware ? test_firmware->size : 0);
+		goto out;
+	}
+	pr_info("loaded: %zu\n", test_firmware->size);
+	rc =3D count;
+
+out:
 	mutex_unlock(&test_fw_mutex);
=20
 	kfree(name);
=20
-	return count;
+	return rc;
 }
 static DEVICE_ATTR_WO(trigger_request);
=20
+static DECLARE_COMPLETION(async_fw_done);
+
+static void trigger_async_request_cb(const struct firmware *fw, void *co=
ntext)
+{
+	test_firmware =3D fw;
+	complete(&async_fw_done);
+}
+
+static ssize_t trigger_async_request_store(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	int rc;
+	char *name;
+
+	name =3D kstrndup(buf, count, GFP_KERNEL);
+	if (!name)
+		return -ENOSPC;
+
+	pr_info("loading '%s'\n", name);
+
+	mutex_lock(&test_fw_mutex);
+	release_firmware(test_firmware);
+	test_firmware =3D NULL;
+	rc =3D request_firmware_nowait(THIS_MODULE, 1, name, dev, GFP_KERNEL,
+				     NULL, trigger_async_request_cb);
+	if (rc) {
+		pr_info("async load of '%s' failed: %d\n", name, rc);
+		kfree(name);
+		goto out;
+	}
+	/* Free 'name' ASAP, to test for race conditions */
+	kfree(name);
+
+	wait_for_completion(&async_fw_done);
+
+	if (test_firmware) {
+		pr_info("loaded: %zu\n", test_firmware->size);
+		rc =3D count;
+	} else {
+		pr_err("failed to async load firmware\n");
+		rc =3D -ENODEV;
+	}
+
+out:
+	mutex_unlock(&test_fw_mutex);
+
+	return rc;
+}
+static DEVICE_ATTR_WO(trigger_async_request);
+
 static int __init test_firmware_init(void)
 {
 	int rc;
@@ -92,9 +148,20 @@ static int __init test_firmware_init(void)
 		goto dereg;
 	}
=20
+	rc =3D device_create_file(test_fw_misc_device.this_device,
+				&dev_attr_trigger_async_request);
+	if (rc) {
+		pr_err("could not create async sysfs interface: %d\n", rc);
+		goto remove_file;
+	}
+
 	pr_warn("interface ready\n");
=20
 	return 0;
+
+remove_file:
+	device_remove_file(test_fw_misc_device.this_device,
+			   &dev_attr_trigger_async_request);
 dereg:
 	misc_deregister(&test_fw_misc_device);
 	return rc;
@@ -106,6 +173,8 @@ static void __exit test_firmware_exit(void)
 {
 	release_firmware(test_firmware);
 	device_remove_file(test_fw_misc_device.this_device,
+			   &dev_attr_trigger_async_request);
+	device_remove_file(test_fw_misc_device.this_device,
 			   &dev_attr_trigger_request);
 	misc_deregister(&test_fw_misc_device);
 	pr_warn("removed interface\n");
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/M=
akefile
index c8edff6..b04afc3 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -1,10 +1,12 @@
 TARGETS =3D breakpoints
+TARGETS +=3D capabilities
 TARGETS +=3D cpu-hotplug
 TARGETS +=3D efivarfs
 TARGETS +=3D exec
 TARGETS +=3D firmware
 TARGETS +=3D ftrace
 TARGETS +=3D futex
+TARGETS +=3D ipc
 TARGETS +=3D kcmp
 TARGETS +=3D lib
 TARGETS +=3D membarrier
diff --git a/tools/testing/selftests/breakpoints/.gitignore b/tools/testi=
ng/selftests/breakpoints/.gitignore
new file mode 100644
index 0000000..9b3193d0
--- /dev/null
+++ b/tools/testing/selftests/breakpoints/.gitignore
@@ -0,0 +1 @@
+breakpoint_test
diff --git a/tools/testing/selftests/capabilities/Makefile b/tools/testin=
g/selftests/capabilities/Makefile
index 8c8f0c1..008602a 100644
--- a/tools/testing/selftests/capabilities/Makefile
+++ b/tools/testing/selftests/capabilities/Makefile
@@ -1,18 +1,15 @@
-all:
-
-include ../lib.mk
-
-.PHONY: all clean
-
-TARGETS :=3D validate_cap test_execve
+TEST_FILES :=3D validate_cap
 TEST_PROGS :=3D test_execve
=20
-CFLAGS :=3D -O2 -g -std=3Dgnu99 -Wall -lcap-ng
+BINARIES :=3D $(TEST_FILES) $(TEST_PROGS)
=20
-all: $(TARGETS)
+CFLAGS +=3D -O2 -g -std=3Dgnu99 -Wall
+LDLIBS +=3D -lcap-ng -lrt -ldl
+
+all: $(BINARIES)
=20
 clean:
-	$(RM) $(TARGETS)
+	$(RM) $(BINARIES)
+
+include ../lib.mk
=20
-$(TARGETS): %: %.c
-	$(CC) -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
diff --git a/tools/testing/selftests/firmware/fw_filesystem.sh b/tools/te=
sting/selftests/firmware/fw_filesystem.sh
index c4366dc..5c495ad 100755
--- a/tools/testing/selftests/firmware/fw_filesystem.sh
+++ b/tools/testing/selftests/firmware/fw_filesystem.sh
@@ -48,8 +48,21 @@ echo "ABCD0123" >"$FW"
=20
 NAME=3D$(basename "$FW")
=20
+if printf '\000' >"$DIR"/trigger_request; then
+	echo "$0: empty filename should not succeed" >&2
+	exit 1
+fi
+
+if printf '\000' >"$DIR"/trigger_async_request; then
+	echo "$0: empty filename should not succeed (async)" >&2
+	exit 1
+fi
+
 # Request a firmware that doesn't exist, it should fail.
-echo -n "nope-$NAME" >"$DIR"/trigger_request
+if echo -n "nope-$NAME" >"$DIR"/trigger_request; then
+	echo "$0: firmware shouldn't have loaded" >&2
+	exit 1
+fi
 if diff -q "$FW" /dev/test_firmware >/dev/null ; then
 	echo "$0: firmware was not expected to match" >&2
 	exit 1
@@ -74,4 +87,18 @@ else
 	echo "$0: filesystem loading works"
 fi
=20
+# Try the asynchronous version too
+if ! echo -n "$NAME" >"$DIR"/trigger_async_request ; then
+	echo "$0: could not trigger async request" >&2
+	exit 1
+fi
+
+# Verify the contents are what we expect.
+if ! diff -q "$FW" /dev/test_firmware >/dev/null ; then
+	echo "$0: firmware was not loaded (async)" >&2
+	exit 1
+else
+	echo "$0: async filesystem loading works"
+fi
+
 exit 0
diff --git a/tools/testing/selftests/intel_pstate/Makefile b/tools/testin=
g/selftests/intel_pstate/Makefile
new file mode 100644
index 0000000..f5f1a28
--- /dev/null
+++ b/tools/testing/selftests/intel_pstate/Makefile
@@ -0,0 +1,15 @@
+CC :=3D $(CROSS_COMPILE)gcc
+CFLAGS :=3D $(CFLAGS) -Wall -D_GNU_SOURCE
+LDFLAGS :=3D $(LDFLAGS) -lm
+
+TARGETS :=3D msr aperf
+
+TEST_PROGS :=3D $(TARGETS) run.sh
+
+.PHONY: all clean
+all: $(TARGETS)
+
+$(TARGETS): $(HEADERS)
+
+clean:
+	rm -f $(TARGETS)
diff --git a/tools/testing/selftests/intel_pstate/aperf.c b/tools/testing=
/selftests/intel_pstate/aperf.c
new file mode 100644
index 0000000..6046e18
--- /dev/null
+++ b/tools/testing/selftests/intel_pstate/aperf.c
@@ -0,0 +1,80 @@
+#include <math.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/timeb.h>
+#include <sched.h>
+#include <errno.h>
+
+void usage(char *name) {
+	printf ("Usage: %s cpunum\n", name);
+}
+
+int main(int argc, char **argv) {
+	int i, cpu, fd;
+	char msr_file_name[64];
+	long long tsc, old_tsc, new_tsc;
+	long long aperf, old_aperf, new_aperf;
+	long long mperf, old_mperf, new_mperf;
+	struct timeb before, after;
+	long long int start, finish, total;
+	cpu_set_t cpuset;
+
+	if (argc !=3D 2) {
+		usage(argv[0]);
+		return 1;
+	}
+
+	errno =3D 0;
+	cpu =3D strtol(argv[1], (char **) NULL, 10);
+
+	if (errno) {
+		usage(argv[0]);
+		return 1;
+	}
+
+	sprintf(msr_file_name, "/dev/cpu/%d/msr", cpu);
+	fd =3D open(msr_file_name, O_RDONLY);
+
+	if (fd =3D=3D -1) {
+		perror("Failed to open");
+		return 1;
+	}
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(cpu, &cpuset);
+
+	if (sched_setaffinity(0, sizeof(cpu_set_t), &cpuset)) {
+		perror("Failed to set cpu affinity");
+		return 1;
+	}
+
+	ftime(&before);
+	pread(fd, &old_tsc,  sizeof(old_tsc), 0x10);
+	pread(fd, &old_aperf,  sizeof(old_mperf), 0xe7);
+	pread(fd, &old_mperf,  sizeof(old_aperf), 0xe8);
+
+	for (i=3D0; i<0x8fffffff; i++) {
+		sqrt(i);
+	}
+
+	ftime(&after);
+	pread(fd, &new_tsc,  sizeof(new_tsc), 0x10);
+	pread(fd, &new_aperf,  sizeof(new_mperf), 0xe7);
+	pread(fd, &new_mperf,  sizeof(new_aperf), 0xe8);
+
+	tsc =3D new_tsc-old_tsc;
+	aperf =3D new_aperf-old_aperf;
+	mperf =3D new_mperf-old_mperf;
+
+	start =3D before.time*1000 + before.millitm;
+	finish =3D after.time*1000 + after.millitm;
+	total =3D finish - start;
+
+	printf("runTime: %4.2f\n", 1.0*total/1000);
+	printf("freq: %7.0f\n", tsc / (1.0*aperf / (1.0 * mperf)) / total);
+	return 0;
+}
diff --git a/tools/testing/selftests/intel_pstate/msr.c b/tools/testing/s=
elftests/intel_pstate/msr.c
new file mode 100644
index 0000000..abbbfc8
--- /dev/null
+++ b/tools/testing/selftests/intel_pstate/msr.c
@@ -0,0 +1,39 @@
+#include <math.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/timeb.h>
+#include <sched.h>
+#include <errno.h>
+
+
+int main(int argc, char **argv) {
+	int cpu, fd;
+	long long msr;
+	char msr_file_name[64];
+
+	if (argc !=3D 2)
+		return 1;
+
+	errno =3D 0;
+	cpu =3D strtol(argv[1], (char **) NULL, 10);
+
+	if (errno)
+		return 1;
+
+	sprintf(msr_file_name, "/dev/cpu/%d/msr", cpu);
+	fd =3D open(msr_file_name, O_RDONLY);
+
+	if (fd =3D=3D -1) {
+		perror("Failed to open");
+		return 1;
+	}
+
+	pread(fd, &msr,  sizeof(msr), 0x199);
+
+	printf("msr 0x199: 0x%llx\n", msr);
+	return 0;
+}
diff --git a/tools/testing/selftests/intel_pstate/run.sh b/tools/testing/=
selftests/intel_pstate/run.sh
new file mode 100755
index 0000000..bdaf37e
--- /dev/null
+++ b/tools/testing/selftests/intel_pstate/run.sh
@@ -0,0 +1,113 @@
+#!/bin/bash
+#
+# This test runs on Intel x86 based hardware which support the intel_pst=
ate
+# driver.  The test checks the frequency settings from the maximum turbo=

+# state to the minimum supported frequency, in decrements of 100MHz.  Th=
e
+# test runs the aperf.c program to put load on each processor.
+#
+# The results are displayed in a table which indicate the "Target" state=
,
+# or the requested frequency in MHz, the Actual frequency, as read from
+# /proc/cpuinfo, the difference between the Target and Actual frequencie=
s,
+# and the value of MSR 0x199 (MSR_IA32_PERF_CTL) which indicates what
+# pstate the cpu is in, and the value of
+# /sys/devices/system/cpu/intel_pstate/max_perf_pct X maximum turbo stat=
e
+#
+# Notes: In some cases several frequency values may be placed in the
+# /tmp/result.X files.  This is done on purpose in order to catch cases
+# where the pstate driver may not be working at all.  There is the case
+# where, for example, several "similar" frequencies are in the file:
+#
+#
+#/tmp/result.3100:1:cpu MHz              : 2899.980
+#/tmp/result.3100:2:cpu MHz              : 2900.000
+#/tmp/result.3100:3:msr 0x199: 0x1e00
+#/tmp/result.3100:4:max_perf_pct 94
+#
+# and the test will error out in those cases.  The result.X file can be =
checked
+# for consistency and modified to remove the extra MHz values.  The resu=
lt.X
+# files can be re-evaluated by setting EVALUATE_ONLY to 1 below.
+
+EVALUATE_ONLY=3D0
+
+max_cpus=3D$(($(nproc)-1))
+
+# compile programs
+gcc -o aperf aperf.c -lm
+[ $? -ne 0 ] && echo "Problem compiling aperf.c." && exit 1
+gcc -o msr msr.c -lm
+[ $? -ne 0 ] && echo "Problem compiling msr.c." && exit 1
+
+function run_test () {
+
+	file_ext=3D$1
+	for cpu in `seq 0 $max_cpus`
+	do
+		echo "launching aperf load on $cpu"
+		./aperf $cpu &
+	done
+
+	echo "sleeping for 5 seconds"
+	sleep 5
+	num_freqs=3D$(cat /proc/cpuinfo | grep MHz | sort -u | wc -l)
+	if [ $num_freqs -le 2 ]; then
+		cat /proc/cpuinfo | grep MHz | sort -u | tail -1 > /tmp/result.$1
+	else
+		cat /proc/cpuinfo | grep MHz | sort -u > /tmp/result.$1
+	fi
+	./msr 0 >> /tmp/result.$1
+
+	max_perf_pct=3D$(cat /sys/devices/system/cpu/intel_pstate/max_perf_pct)=

+	echo "max_perf_pct $max_perf_pct" >> /tmp/result.$1
+
+	for job in `jobs -p`
+	do
+		echo "waiting for job id $job"
+		wait $job
+	done
+}
+
+#
+# MAIN (ALL UNITS IN MHZ)
+#
+
+# Get the marketing frequency
+_mkt_freq=3D$(cat /proc/cpuinfo | grep -m 1 "model name" | awk '{print $=
NF}')
+_mkt_freq=3D$(echo $_mkt_freq | tr -d [:alpha:][:punct:])
+mkt_freq=3D${_mkt_freq}0
+
+# Get the ranges from cpupower
+_min_freq=3D$(cpupower frequency-info -l | tail -1 | awk ' { print $1 } =
')
+min_freq=3D$(($_min_freq / 1000))
+_max_freq=3D$(cpupower frequency-info -l | tail -1 | awk ' { print $2 } =
')
+max_freq=3D$(($_max_freq / 1000))
+
+
+for freq in `seq $max_freq -100 $min_freq`
+do
+	echo "Setting maximum frequency to $freq"
+	cpupower frequency-set -g powersave --max=3D${freq}MHz >& /dev/null
+	[ $EVALUATE_ONLY -eq 0 ] && run_test $freq
+done
+
+echo "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D"
+
+echo "The marketing frequency of the cpu is $mkt_freq MHz"
+echo "The maximum frequency of the cpu is $max_freq MHz"
+echo "The minimum frequency of the cpu is $min_freq MHz"
+
+cpupower frequency-set -g powersave --max=3D${max_freq}MHz >& /dev/null
+
+# make a pretty table
+echo "Target      Actual      Difference     MSR(0x199)     max_perf_pct=
"
+for freq in `seq $max_freq -100 $min_freq`
+do
+	result_freq=3D$(cat /tmp/result.${freq} | grep "cpu MHz" | awk ' { prin=
t $4 } ' | awk -F "." ' { print $1 } ')
+	msr=3D$(cat /tmp/result.${freq} | grep "msr" | awk ' { print $3 } ')
+	max_perf_pct=3D$(cat /tmp/result.${freq} | grep "max_perf_pct" | awk ' =
{ print $2 } ' )
+	if [ $result_freq -eq $freq ]; then
+		echo " $freq        $result_freq             0          $msr         $=
(($max_perf_pct*3300))"
+	else
+		echo " $freq        $result_freq          $(($result_freq-$freq))     =
     $msr          $(($max_perf_pct*$max_freq))"
+	fi
+done
+exit 0
diff --git a/tools/testing/selftests/ptrace/.gitignore b/tools/testing/se=
lftests/ptrace/.gitignore
new file mode 100644
index 0000000..b3e59d4
--- /dev/null
+++ b/tools/testing/selftests/ptrace/.gitignore
@@ -0,0 +1 @@
+peeksiginfo
diff --git a/tools/testing/selftests/seccomp/test_harness.h b/tools/testi=
ng/selftests/seccomp/test_harness.h
index fb28416..a786c69 100644
--- a/tools/testing/selftests/seccomp/test_harness.h
+++ b/tools/testing/selftests/seccomp/test_harness.h
@@ -42,6 +42,7 @@
 #define TEST_HARNESS_H_
=20
 #define _GNU_SOURCE
+#include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -370,8 +371,8 @@
 	__typeof__(_expected) __exp =3D (_expected); \
 	__typeof__(_seen) __seen =3D (_seen); \
 	if (!(__exp _t __seen)) { \
-		unsigned long long __exp_print =3D (unsigned long long)__exp; \
-		unsigned long long __seen_print =3D (unsigned long long)__seen; \
+		unsigned long long __exp_print =3D (uintptr_t)__exp; \
+		unsigned long long __seen_print =3D (uintptr_t)__seen; \
 		__TH_LOG("Expected %s (%llu) %s %s (%llu)", \
 			 #_expected, __exp_print, #_t, \
 			 #_seen, __seen_print); \
diff --git a/tools/testing/selftests/timers/.gitignore b/tools/testing/se=
lftests/timers/.gitignore
index ced9981..68f3fc7 100644
--- a/tools/testing/selftests/timers/.gitignore
+++ b/tools/testing/selftests/timers/.gitignore
@@ -16,3 +16,4 @@ set-timer-lat
 skew_consistency
 threadtest
 valid-adjtimex
+adjtick
diff --git a/tools/testing/selftests/vm/.gitignore b/tools/testing/selfte=
sts/vm/.gitignore
index ff1bb16..a937a9d 100644
--- a/tools/testing/selftests/vm/.gitignore
+++ b/tools/testing/selftests/vm/.gitignore
@@ -2,3 +2,8 @@ hugepage-mmap
 hugepage-shm
 map_hugetlb
 thuge-gen
+compaction_test
+mlock2-tests
+on-fault-limit
+transhuge-stress
+userfaultfd

--------------070800080308030701080602--
