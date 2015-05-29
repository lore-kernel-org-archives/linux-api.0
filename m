From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: [RESEND PATCH 3/3] Add tests for lock on fault
Date: Fri, 29 May 2015 10:13:28 -0400
Message-ID: <1432908808-31150-4-git-send-email-emunson@akamai.com>
References: <1432908808-31150-1-git-send-email-emunson@akamai.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432908808-31150-1-git-send-email-emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Test the mmap() flag, the mlockall() flag, and ensure that mlock limits
are respected.  Note that the limit test needs to be run a normal user.

Signed-off-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 tools/testing/selftests/vm/Makefile         |   8 +-
 tools/testing/selftests/vm/lock-on-fault.c  | 145 ++++++++++++++++++++++++++++
 tools/testing/selftests/vm/on-fault-limit.c |  47 +++++++++
 tools/testing/selftests/vm/run_vmtests      |  23 +++++
 4 files changed, 222 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/vm/lock-on-fault.c
 create mode 100644 tools/testing/selftests/vm/on-fault-limit.c

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index a5ce953..32f3d20 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,7 +1,13 @@
 # Makefile for vm selftests
 
 CFLAGS = -Wall
-BINARIES = hugepage-mmap hugepage-shm map_hugetlb thuge-gen hugetlbfstest
+BINARIES = hugepage-mmap
+BINARIES += hugepage-shm
+BINARIES += hugetlbfstest
+BINARIES += lock-on-fault
+BINARIES += map_hugetlb
+BINARIES += on-fault-limit
+BINARIES += thuge-gen
 BINARIES += transhuge-stress
 
 all: $(BINARIES)
diff --git a/tools/testing/selftests/vm/lock-on-fault.c b/tools/testing/selftests/vm/lock-on-fault.c
new file mode 100644
index 0000000..e6a9688
--- /dev/null
+++ b/tools/testing/selftests/vm/lock-on-fault.c
@@ -0,0 +1,145 @@
+#include <sys/mman.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+
+#ifndef MCL_ON_FAULT
+#define MCL_ON_FAULT 4
+#endif
+
+#define PRESENT_BIT	0x8000000000000000
+#define PFN_MASK	0x007FFFFFFFFFFFFF
+#define UNEVICTABLE_BIT	(1UL << 18)
+
+static int check_pageflags(void *map)
+{
+	FILE *file;
+	unsigned long pfn1;
+	unsigned long pfn2;
+	unsigned long offset1;
+	unsigned long offset2;
+	int ret = 1;
+
+	file = fopen("/proc/self/pagemap", "r");
+	if (!file) {
+		perror("fopen");
+		return ret;
+	}
+	offset1 = (unsigned long)map / getpagesize() * sizeof(unsigned long);
+	offset2 = ((unsigned long)map + getpagesize()) / getpagesize() * sizeof(unsigned long);
+	if (fseek(file, offset1, SEEK_SET)) {
+		perror("fseek");
+		goto out;
+	}
+
+	if (fread(&pfn1, sizeof(unsigned long), 1, file) != 1) {
+		perror("fread");
+		goto out;
+	}
+
+	if (fseek(file, offset2, SEEK_SET)) {
+		perror("fseek");
+		goto out;
+	}
+
+	if (fread(&pfn2, sizeof(unsigned long), 1, file) != 1) {
+		perror("fread");
+		goto out;
+	}
+
+	/* pfn2 should not be present */
+	if (pfn2 & PRESENT_BIT) {
+		printf("page map says 0x%lx\n", pfn2);
+		printf("present is    0x%lx\n", PRESENT_BIT);
+		goto out;
+	}
+
+	/* pfn1 should be present */
+	if ((pfn1 & PRESENT_BIT) == 0) {
+		printf("page map says 0x%lx\n", pfn1);
+		printf("present is    0x%lx\n", PRESENT_BIT);
+		goto out;
+	}
+
+	pfn1 &= PFN_MASK;
+	fclose(file);
+	file = fopen("/proc/kpageflags", "r");
+	if (!file) {
+		perror("fopen");
+		munmap(map, 2 * getpagesize());
+		return ret;
+	}
+
+	if (fseek(file, pfn1 * sizeof(unsigned long), SEEK_SET)) {
+		perror("fseek");
+		goto out;
+	}
+
+	if (fread(&pfn2, sizeof(unsigned long), 1, file) != 1) {
+		perror("fread");
+		goto out;
+	}
+
+	/* pfn2 now contains the entry from kpageflags for the first page, the
+	 * unevictable bit should be set */
+	if ((pfn2 & UNEVICTABLE_BIT) == 0) {
+		printf("kpageflags says 0x%lx\n", pfn2);
+		printf("unevictable is  0x%lx\n", UNEVICTABLE_BIT);
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	fclose(file);
+	return ret;
+}
+
+static int test_mmap(int flags)
+{
+	int ret = 1;
+	void *map;
+
+	map = mmap(NULL, 2 * getpagesize(), PROT_READ | PROT_WRITE, flags, 0, 0);
+	if (map == MAP_FAILED) {
+		perror("mmap()");
+		return ret;
+	}
+
+	/* Write something into the first page to ensure it is present */
+	*(char *)map = 1;
+
+	ret = check_pageflags(map);
+
+	munmap(map, 2 * getpagesize());
+	return ret;
+}
+
+static int test_mlockall(void)
+{
+	int ret = 1;
+
+	if (mlockall(MCL_ON_FAULT)) {
+		perror("mlockall");
+		return ret;
+	}
+
+	ret = test_mmap(MAP_PRIVATE | MAP_ANONYMOUS);
+	munlockall();
+	return ret;
+}
+
+#ifndef MAP_LOCKONFAULT
+#define MAP_LOCKONFAULT (MAP_HUGETLB << 1)
+#endif
+
+int main(int argc, char **argv)
+{
+	int ret = 0;
+
+	ret += test_mmap(MAP_PRIVATE | MAP_ANONYMOUS | MAP_LOCKONFAULT);
+	ret += test_mlockall();
+	return ret;
+}
diff --git a/tools/testing/selftests/vm/on-fault-limit.c b/tools/testing/selftests/vm/on-fault-limit.c
new file mode 100644
index 0000000..bd70078
--- /dev/null
+++ b/tools/testing/selftests/vm/on-fault-limit.c
@@ -0,0 +1,47 @@
+#include <sys/mman.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+
+#ifndef MCL_ON_FAULT
+#define MCL_ON_FAULT 4
+#endif
+
+static int test_limit(void)
+{
+	int ret = 1;
+	struct rlimit lims;
+	void *map;
+
+	if (getrlimit(RLIMIT_MEMLOCK, &lims)) {
+		perror("getrlimit");
+		return ret;
+	}
+
+	if (mlockall(MCL_ON_FAULT)) {
+		perror("mlockall");
+		return ret;
+	}
+
+	map = mmap(NULL, 2 * lims.rlim_max, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, 0, 0);
+	if (map != MAP_FAILED)
+		printf("mmap should have failed, but didn't\n");
+	else {
+		ret = 0;
+		munmap(map, 2 * lims.rlim_max);
+	}
+
+	munlockall();
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	int ret = 0;
+
+	ret += test_limit();
+	return ret;
+}
diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selftests/vm/run_vmtests
index c87b681..c1aecce 100755
--- a/tools/testing/selftests/vm/run_vmtests
+++ b/tools/testing/selftests/vm/run_vmtests
@@ -90,4 +90,27 @@ fi
 umount $mnt
 rm -rf $mnt
 echo $nr_hugepgs > /proc/sys/vm/nr_hugepages
+
+echo "--------------------"
+echo "running lock-on-fault"
+echo "--------------------"
+./lock-on-fault
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
+echo "--------------------"
+echo "running on-fault-limit"
+echo "--------------------"
+sudo -u nobody ./on-fault-limit
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
 exit $exitcode
-- 
1.9.1
