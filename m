From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] tools, testing, add test for intel_pstate driver
Date: Wed, 18 Nov 2015 12:04:48 -0500
Message-ID: <1447866288-8125-1-git-send-email-prarit@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This test used the cpupower utility to set the cpu frequency from the
maximum turbo value to the minimum supported value in steps of 100 MHz.

The results are displayed in a table which indicate the "Target" state,
or the requested frequency in MHz, the Actual frequency, as read from
/proc/cpuinfo, the difference between the Target and Actual frequencies,
and the value of MSR 0x199 (MSR_IA32_PERF_CTL) which indicates what
pstate the cpu is in, and the value of
/sys/devices/system/cpu/intel_pstate/max_perf_pct X maximum turbo state

Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/intel_pstate/Makefile |   15 ++++
 tools/testing/selftests/intel_pstate/aperf.c  |   80 +++++++++++++++++
 tools/testing/selftests/intel_pstate/msr.c    |   39 +++++++++
 tools/testing/selftests/intel_pstate/run.sh   |  113 +++++++++++++++++++++++++
 4 files changed, 247 insertions(+)
 create mode 100644 tools/testing/selftests/intel_pstate/Makefile
 create mode 100644 tools/testing/selftests/intel_pstate/aperf.c
 create mode 100644 tools/testing/selftests/intel_pstate/msr.c
 create mode 100755 tools/testing/selftests/intel_pstate/run.sh

diff --git a/tools/testing/selftests/intel_pstate/Makefile b/tools/testing/selftests/intel_pstate/Makefile
new file mode 100644
index 0000000..f5f1a28
--- /dev/null
+++ b/tools/testing/selftests/intel_pstate/Makefile
@@ -0,0 +1,15 @@
+CC := $(CROSS_COMPILE)gcc
+CFLAGS := $(CFLAGS) -Wall -D_GNU_SOURCE
+LDFLAGS := $(LDFLAGS) -lm
+
+TARGETS := msr aperf
+
+TEST_PROGS := $(TARGETS) run.sh
+
+.PHONY: all clean
+all: $(TARGETS)
+
+$(TARGETS): $(HEADERS)
+
+clean:
+	rm -f $(TARGETS)
diff --git a/tools/testing/selftests/intel_pstate/aperf.c b/tools/testing/selftests/intel_pstate/aperf.c
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
+	if (argc != 2) {
+		usage(argv[0]);
+		return 1;
+	}
+
+	errno = 0;
+	cpu = strtol(argv[1], (char **) NULL, 10);
+
+	if (errno) {
+		usage(argv[0]);
+		return 1;
+	}
+
+	sprintf(msr_file_name, "/dev/cpu/%d/msr", cpu);
+	fd = open(msr_file_name, O_RDONLY);
+
+	if (fd == -1) {
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
+	for (i=0; i<0x8fffffff; i++) {
+		sqrt(i);
+	}
+
+	ftime(&after);
+	pread(fd, &new_tsc,  sizeof(new_tsc), 0x10);
+	pread(fd, &new_aperf,  sizeof(new_mperf), 0xe7);
+	pread(fd, &new_mperf,  sizeof(new_aperf), 0xe8);
+
+	tsc = new_tsc-old_tsc;
+	aperf = new_aperf-old_aperf;
+	mperf = new_mperf-old_mperf;
+
+	start = before.time*1000 + before.millitm;
+	finish = after.time*1000 + after.millitm;
+	total = finish - start;
+
+	printf("runTime: %4.2f\n", 1.0*total/1000);
+	printf("freq: %7.0f\n", tsc / (1.0*aperf / (1.0 * mperf)) / total);
+	return 0;
+}
diff --git a/tools/testing/selftests/intel_pstate/msr.c b/tools/testing/selftests/intel_pstate/msr.c
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
+	if (argc != 2)
+		return 1;
+
+	errno = 0;
+	cpu = strtol(argv[1], (char **) NULL, 10);
+
+	if (errno)
+		return 1;
+
+	sprintf(msr_file_name, "/dev/cpu/%d/msr", cpu);
+	fd = open(msr_file_name, O_RDONLY);
+
+	if (fd == -1) {
+		perror("Failed to open");
+		return 1;
+	}
+
+	pread(fd, &msr,  sizeof(msr), 0x199);
+
+	printf("msr 0x199: 0x%llx\n", msr);
+	return 0;
+}
diff --git a/tools/testing/selftests/intel_pstate/run.sh b/tools/testing/selftests/intel_pstate/run.sh
new file mode 100755
index 0000000..bdaf37e
--- /dev/null
+++ b/tools/testing/selftests/intel_pstate/run.sh
@@ -0,0 +1,113 @@
+#!/bin/bash
+#
+# This test runs on Intel x86 based hardware which support the intel_pstate
+# driver.  The test checks the frequency settings from the maximum turbo
+# state to the minimum supported frequency, in decrements of 100MHz.  The
+# test runs the aperf.c program to put load on each processor.
+#
+# The results are displayed in a table which indicate the "Target" state,
+# or the requested frequency in MHz, the Actual frequency, as read from
+# /proc/cpuinfo, the difference between the Target and Actual frequencies,
+# and the value of MSR 0x199 (MSR_IA32_PERF_CTL) which indicates what
+# pstate the cpu is in, and the value of
+# /sys/devices/system/cpu/intel_pstate/max_perf_pct X maximum turbo state
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
+# and the test will error out in those cases.  The result.X file can be checked
+# for consistency and modified to remove the extra MHz values.  The result.X
+# files can be re-evaluated by setting EVALUATE_ONLY to 1 below.
+
+EVALUATE_ONLY=0
+
+max_cpus=$(($(nproc)-1))
+
+# compile programs
+gcc -o aperf aperf.c -lm
+[ $? -ne 0 ] && echo "Problem compiling aperf.c." && exit 1
+gcc -o msr msr.c -lm
+[ $? -ne 0 ] && echo "Problem compiling msr.c." && exit 1
+
+function run_test () {
+
+	file_ext=$1
+	for cpu in `seq 0 $max_cpus`
+	do
+		echo "launching aperf load on $cpu"
+		./aperf $cpu &
+	done
+
+	echo "sleeping for 5 seconds"
+	sleep 5
+	num_freqs=$(cat /proc/cpuinfo | grep MHz | sort -u | wc -l)
+	if [ $num_freqs -le 2 ]; then
+		cat /proc/cpuinfo | grep MHz | sort -u | tail -1 > /tmp/result.$1
+	else
+		cat /proc/cpuinfo | grep MHz | sort -u > /tmp/result.$1
+	fi
+	./msr 0 >> /tmp/result.$1
+
+	max_perf_pct=$(cat /sys/devices/system/cpu/intel_pstate/max_perf_pct)
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
+_mkt_freq=$(cat /proc/cpuinfo | grep -m 1 "model name" | awk '{print $NF}')
+_mkt_freq=$(echo $_mkt_freq | tr -d [:alpha:][:punct:])
+mkt_freq=${_mkt_freq}0
+
+# Get the ranges from cpupower
+_min_freq=$(cpupower frequency-info -l | tail -1 | awk ' { print $1 } ')
+min_freq=$(($_min_freq / 1000))
+_max_freq=$(cpupower frequency-info -l | tail -1 | awk ' { print $2 } ')
+max_freq=$(($_max_freq / 1000))
+
+
+for freq in `seq $max_freq -100 $min_freq`
+do
+	echo "Setting maximum frequency to $freq"
+	cpupower frequency-set -g powersave --max=${freq}MHz >& /dev/null
+	[ $EVALUATE_ONLY -eq 0 ] && run_test $freq
+done
+
+echo "=============================================================================="
+
+echo "The marketing frequency of the cpu is $mkt_freq MHz"
+echo "The maximum frequency of the cpu is $max_freq MHz"
+echo "The minimum frequency of the cpu is $min_freq MHz"
+
+cpupower frequency-set -g powersave --max=${max_freq}MHz >& /dev/null
+
+# make a pretty table
+echo "Target      Actual      Difference     MSR(0x199)     max_perf_pct"
+for freq in `seq $max_freq -100 $min_freq`
+do
+	result_freq=$(cat /tmp/result.${freq} | grep "cpu MHz" | awk ' { print $4 } ' | awk -F "." ' { print $1 } ')
+	msr=$(cat /tmp/result.${freq} | grep "msr" | awk ' { print $3 } ')
+	max_perf_pct=$(cat /tmp/result.${freq} | grep "max_perf_pct" | awk ' { print $2 } ' )
+	if [ $result_freq -eq $freq ]; then
+		echo " $freq        $result_freq             0          $msr         $(($max_perf_pct*3300))"
+	else
+		echo " $freq        $result_freq          $(($result_freq-$freq))          $msr          $(($max_perf_pct*$max_freq))"
+	fi
+done
+exit 0
-- 
1.7.9.3
