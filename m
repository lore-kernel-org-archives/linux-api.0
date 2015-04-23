From: Sri Jayaramappa <sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2] Test compaction of mlocked memory
Date: Thu, 23 Apr 2015 14:21:41 -0400
Message-ID: <1429813301-27216-1-git-send-email-sjayaram@akamai.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Sri Jayaramappa <sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Commit commit 5bbe3547aa3b ("mm: allow compaction of unevictable pages")
introduced a sysctl that allows userspace to enable scanning of locked
pages for compaction.  This patch introduces a new test which fragments
main memory and attempts to allocate a number of huge pages to exercise
this compaction logic.

Tested on machines with up to 32 GB RAM. With the patch a much larger
number of huge pages can be allocated than on the kernel without the
patch.

Example output:
On a machine with 16 GB RAM:
sudo make run_tests vm
...
-----------------------
running compaction_test
-----------------------
No of huge pages allocated = 3834
[PASS]
...

Signed-off-by: Sri Jayaramappa <sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
---
Changes in V2:
BINARIES in the Makefile is now one value per line.

The return value of read/write is checked against the number of
expected bytes wherever we know the number ahead in time.

Increased the threshold to 1/3 instead of 1/4 of memory to be allocated
as huge pages.

Corrected spelling "initial".
Removed a redundant variable.

 tools/testing/selftests/vm/Makefile          |    9 +-
 tools/testing/selftests/vm/compaction_test.c |  225 ++++++++++++++++++++++++++
 tools/testing/selftests/vm/run_vmtests       |   12 ++
 3 files changed, 244 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/vm/compaction_test.c

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index a5ce953..f6afc9e 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,8 +1,13 @@
 # Makefile for vm selftests

 CFLAGS = -Wall
-BINARIES = hugepage-mmap hugepage-shm map_hugetlb thuge-gen hugetlbfstest
-BINARIES += transhuge-stress
+BINARIES = compaction_test
+BINARIES += hugepage-mmap
+BINARIES += hugepage-shm
+BINARIES += hugetlbfstest
+BINARIES += map_hugetlb
+BINARIES += thuge-gen
+BINARIES += transhuge-stress

 all: $(BINARIES)
 %: %.c
diff --git a/tools/testing/selftests/vm/compaction_test.c b/tools/testing/selftests/vm/compaction_test.c
new file mode 100644
index 0000000..82d0ba6
--- /dev/null
+++ b/tools/testing/selftests/vm/compaction_test.c
@@ -0,0 +1,225 @@
+/*
+ *
+ * A test for the patch "Allow compaction of unevictable pages".
+ * With this patch we should be able to allocate at least 1/4
+ * of RAM in huge pages. Without the patch much less is
+ * allocated.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <sys/resource.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <unistd.h>
+#include <string.h>
+
+#define MAP_SIZE 1048576
+
+struct map_list {
+	void *map;
+	struct map_list *next;
+};
+
+int read_memory_info(unsigned long *memfree, unsigned long *hugepagesize)
+{
+	char  buffer[256] = {0};
+	char *cmd = "cat /proc/meminfo | grep -i memfree | grep -o '[0-9]*'";
+	FILE *cmdfile = popen(cmd, "r");
+
+	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
+		perror("Failed to read meminfo\n");
+		return -1;
+	}
+
+	pclose(cmdfile);
+
+	*memfree = atoll(buffer);
+	cmd = "cat /proc/meminfo | grep -i hugepagesize | grep -o '[0-9]*'";
+	cmdfile = popen(cmd, "r");
+
+	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
+		perror("Failed to read meminfo\n");
+		return -1;
+	}
+
+	pclose(cmdfile);
+	*hugepagesize = atoll(buffer);
+
+	return 0;
+}
+
+int prereq(void)
+{
+	char allowed;
+	int fd;
+
+	fd = open("/proc/sys/vm/compact_unevictable_allowed",
+		  O_RDONLY | O_NONBLOCK);
+	if (fd < 0) {
+		perror("Failed to open\n"
+		       "/proc/sys/vm/compact_unevictable_allowed\n");
+		return -1;
+	}
+
+	if (read(fd, &allowed, sizeof(char)) != sizeof(char)) {
+		perror("Failed to read from\n"
+		       "/proc/sys/vm/compact_unevictable_allowed\n");
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+	if (allowed == '1')
+		return 0;
+
+	return -1;
+}
+
+int check_compaction(unsigned long mem_free, unsigned int hugepage_size)
+{
+	int fd;
+	int compaction_index = 0;
+	char initial_nr_hugepages[10] = {0};
+	char nr_hugepages[10] = {0};
+
+	/* We want to test with 80% of available memory. Else, OOM killer comes
+	   in to play */
+	mem_free = mem_free * 0.8;
+
+	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
+	if (fd < 0) {
+		perror("Failed to open /proc/sys/vm/nr_hugepages");
+		return -1;
+	}
+
+	if (read(fd, initial_nr_hugepages, sizeof(initial_nr_hugepages)) <= 0) {
+		perror("Failed to read from /proc/sys/vm/nr_hugepages");
+		goto close_fd;
+	}
+
+	/* Start with the initial condition of 0 huge pages*/
+	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
+		perror("Failed to write to /proc/sys/vm/nr_hugepages\n");
+		goto close_fd;
+	}
+
+	lseek(fd, 0, SEEK_SET);
+
+	/* Request a large number of huge pages. The Kernel will allocate
+	   as much as it can */
+	if (write(fd, "100000", (6*sizeof(char))) != (6*sizeof(char))) {
+		perror("Failed to write to /proc/sys/vm/nr_hugepages\n");
+		goto close_fd;
+	}
+
+	lseek(fd, 0, SEEK_SET);
+
+	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
+		perror("Failed to read from /proc/sys/vm/nr_hugepages\n");
+		goto close_fd;
+	}
+
+	/* We should have been able to request at least 1/3 rd of the memory in
+	   huge pages */
+	compaction_index = mem_free/(atoi(nr_hugepages) * hugepage_size);
+
+	if (compaction_index > 3) {
+		printf("No of huge pages allocated = %d\n",
+		       (atoi(nr_hugepages)));
+		fprintf(stderr, "ERROR: Less that 1/%d of memory is available\n"
+			"as huge pages\n", compaction_index);
+		goto close_fd;
+	}
+
+	printf("No of huge pages allocated = %d\n",
+	       (atoi(nr_hugepages)));
+
+	if (write(fd, initial_nr_hugepages, sizeof(initial_nr_hugepages))
+	    != strlen(initial_nr_hugepages)) {
+		perror("Failed to write to /proc/sys/vm/nr_hugepages\n");
+		goto close_fd;
+	}
+
+	close(fd);
+	return 0;
+
+ close_fd:
+	close(fd);
+	printf("Not OK. Compaction test failed.");
+	return -1;
+}
+
+
+int main(int argc, char **argv)
+{
+	struct rlimit lim;
+	struct map_list *list, *entry;
+	size_t page_size, i;
+	void *map = NULL;
+	unsigned long mem_free = 0;
+	unsigned long hugepage_size = 0;
+	unsigned long mem_fragmentable = 0;
+
+	if (prereq() != 0) {
+		printf("Either the sysctl compact_unevictable_allowed is not\n"
+		       "set to 1 or couldn't read the proc file.\n"
+		       "Skipping the test\n");
+		return 0;
+	}
+
+	lim.rlim_cur = RLIM_INFINITY;
+	lim.rlim_max = RLIM_INFINITY;
+	if (setrlimit(RLIMIT_MEMLOCK, &lim)) {
+		perror("Failed to set rlimit:\n");
+		return -1;
+	}
+
+	page_size = getpagesize();
+
+	list = NULL;
+
+	if (read_memory_info(&mem_free, &hugepage_size) != 0) {
+		printf("ERROR: Cannot read meminfo\n");
+		return -1;
+	}
+
+	mem_fragmentable = mem_free * 0.8 / 1024;
+
+	while (mem_fragmentable > 0) {
+		map = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE,
+			   MAP_ANONYMOUS | MAP_PRIVATE | MAP_LOCKED, -1, 0);
+		if (map == MAP_FAILED)
+			break;
+
+		entry = malloc(sizeof(struct map_list));
+		if (!entry) {
+			munmap(map, MAP_SIZE);
+			break;
+		}
+		entry->map = map;
+		entry->next = list;
+		list = entry;
+
+		/* Write something (in this case the address of the map) to
+		 * ensure that KSM can't merge the mapped pages
+		 */
+		for (i = 0; i < MAP_SIZE; i += page_size)
+			*(unsigned long *)(map + i) = (unsigned long)map + i;
+
+		mem_fragmentable--;
+	}
+
+	for (entry = list; entry != NULL; entry = entry->next) {
+		munmap(entry->map, MAP_SIZE);
+		if (!entry->next)
+			break;
+		entry = entry->next;
+	}
+
+	if (check_compaction(mem_free, hugepage_size) == 0)
+		return 0;
+
+	return -1;
+}
diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selftests/vm/run_vmtests
index c87b681..49ece11 100755
--- a/tools/testing/selftests/vm/run_vmtests
+++ b/tools/testing/selftests/vm/run_vmtests
@@ -90,4 +90,16 @@ fi
 umount $mnt
 rm -rf $mnt
 echo $nr_hugepgs > /proc/sys/vm/nr_hugepages
+
+echo "-----------------------"
+echo "running compaction_test"
+echo "-----------------------"
+./compaction_test
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
 exit $exitcode
--
1.7.9.5
