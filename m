From: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
Subject: [PATCH v4] selftest: size: Add size test for Linux kernel
Date: Wed, 26 Nov 2014 20:27:23 -0800
Message-ID: <5476A82B.2060903@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


This test shows the amount of memory used by the system.
Note that this is dependent on the user-space that is loaded
when this program runs.  Optimally, this program would be
run as the init program itself.

The program is optimized for size itself, to avoid conflating
its own execution with that of the system software.
The code is compiled statically, with no stdlibs. On my x86_64 system,
this results in a statically linked binary of less than 5K.

Signed-off-by: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
---
Changes from v3:
  - fix copyright string (again!)
  - use __builtin_strlen instead of my own strlen
  - replace main with _start
  - add more human-readable output
  - put libgcc reference into a variable in Makefile

Changes from v2:
  - add return values to print routines
  - add .gitignore file

Changes from v1:
  - use more correct Copyright string in get_size.c

 tools/testing/selftests/Makefile        |   1 +
 tools/testing/selftests/size/.gitignore |   1 +
 tools/testing/selftests/size/Makefile   |  23 +++++++
 tools/testing/selftests/size/get_size.c | 111 ++++++++++++++++++++++++++++++++
 4 files changed, 136 insertions(+)
 create mode 100644 tools/testing/selftests/size/.gitignore
 create mode 100644 tools/testing/selftests/size/Makefile
 create mode 100644 tools/testing/selftests/size/get_size.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 45f145c..fa91aef 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -15,6 +15,7 @@ TARGETS += user
 TARGETS += sysctl
 TARGETS += firmware
 TARGETS += ftrace
+TARGETS += size
 
 TARGETS_HOTPLUG = cpu-hotplug
 TARGETS_HOTPLUG += memory-hotplug
diff --git a/tools/testing/selftests/size/.gitignore b/tools/testing/selftests/size/.gitignore
new file mode 100644
index 0000000..189b781
--- /dev/null
+++ b/tools/testing/selftests/size/.gitignore
@@ -0,0 +1 @@
+get_size
diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
new file mode 100644
index 0000000..1862786
--- /dev/null
+++ b/tools/testing/selftests/size/Makefile
@@ -0,0 +1,23 @@
+#ifndef CC
+	CC = $(CROSS_COMPILE)gcc
+#endif
+
+#ifndef STRIP
+	STRIP = $(CROSS_COMPILE)strip
+#endif
+
+all: get_size
+
+LIBGCC=$(shell $(CC) -print-libgcc-file-name)
+
+get_size: get_size.c
+	$(CC) --static -ffreestanding -nostartfiles \
+		-Wl,--entry=_start get_size.c $(LIBGCC) \
+		-o get_size
+	$(STRIP) -s get_size
+
+run_tests: all
+	./get_size
+
+clean:
+	$(RM) get_size
diff --git a/tools/testing/selftests/size/get_size.c b/tools/testing/selftests/size/get_size.c
new file mode 100644
index 0000000..7e9bbb4
--- /dev/null
+++ b/tools/testing/selftests/size/get_size.c
@@ -0,0 +1,111 @@
+/*
+ * Copyright 2014 Sony Mobile Communications Inc.
+ *
+ * Licensed under the terms of the GNU GPL License version 2
+ *
+ * Selftest for runtime system size
+ *
+ * Prints the amount of RAM that the currently running system is using.
+ *
+ * This program tries to be as small as possible itself, to
+ * avoid perturbing the system memory utilization with its
+ * own execution.  It also attempts to have as few dependencies
+ * on kernel features as possible.
+ *
+ * It should be statically linked, with startup libs avoided.
+ * It uses no library calls, and only the following 3 syscalls:
+ *   sysinfo(), write(), and _exit()
+ *
+ * For output, it avoids printf (which in some C libraries
+ * has large external dependencies) by  implementing it's own
+ * number output and print routines, and using __builtin_strlen()
+ */
+
+#include <sys/sysinfo.h>
+#include <unistd.h>
+
+#define STDOUT_FILENO 1
+
+int print(const char *s)
+{
+	return write(STDOUT_FILENO, s, __builtin_strlen(s));
+}
+
+
+/*
+ * num_to_str - put digits from num into *s, left to right
+ *   do this by dividing the number by powers of 10
+ *   the tricky part is to omit leading zeros
+ *   don't print zeros until we've started printing any numbers at all
+ */
+void num_to_str(unsigned long num, char *s)
+{
+	unsigned long long temp, div;
+	int started;
+
+	temp = num;
+	div = 1000000000000000000LL;
+	started = 0;
+	while (div) {
+		if (temp/div || started) {
+			*s++ = (unsigned char)(temp/div + '0');
+			started = 1;
+		}
+		temp -= (temp/div)*div;
+		div /= 10;
+	}
+	*s = 0;
+}
+
+int print_num(unsigned long num)
+{
+	char num_buf[30];
+
+	num_to_str(num, num_buf);
+	return print(num_buf);
+}
+
+int print_k_value(const char *s, unsigned long num, unsigned long units)
+{
+	unsigned long long temp;
+	int ccode;
+
+	print(s);
+
+	temp = num;
+	temp = (temp * units)/1024;
+	num = temp;
+	ccode = print_num(num);
+	print("\n");
+	return ccode;
+}
+
+/* this program has no main(), as startup libraries are not used */
+void _start(void)
+{
+	int ccode;
+	struct sysinfo info;
+	unsigned long used;
+
+	print("Testing system size.\n");
+	print("1..1\n");
+
+	ccode = sysinfo(&info);
+	if (ccode < 0) {
+		print("not ok 1 get size runtime size\n");
+		print("# could not get sysinfo\n");
+		_exit(ccode);
+	}
+	/* ignore cache complexities for now */
+	used = info.totalram - info.freeram - info.bufferram;
+	print_k_value("ok 1 get runtime memory use # size = ", used,
+		info.mem_unit);
+
+	print("# System runtime memory report (units in Kilobytes):\n");
+	print_k_value("#   Total:  ", info.totalram, info.mem_unit);
+	print_k_value("#   Free:   ", info.freeram, info.mem_unit);
+	print_k_value("#   Buffer: ", info.bufferram, info.mem_unit);
+	print_k_value("#   In use: ", used, info.mem_unit);
+
+	_exit(0);
+}
-- 
1.8.2.2
