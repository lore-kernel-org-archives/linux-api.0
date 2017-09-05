From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] pidmap(2)
Date: Tue, 5 Sep 2017 22:05:00 +0300
Message-ID: <20170905190500.GA13746@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>

Implement system call for bulk retrieveing of pids in binary form.

Using /proc is slower than necessary: 3 syscalls + another 3 for each thread +
converting with atoi().

/proc may be not mounted especially in containers. Natural extension of
hidepid=2 efforts is to not mount /proc at all.

It could be used by programs like ps, top or CRIU. Speed increase will
become more drastic once combined with bulk retrieval of process statistics.

Sample program:

#include <stdio.h>
static inline long sys_pidmap(int *pid, unsigned int n, int start)
{
	register long r10 asm ("r10") = 0;
	long rv;
	asm volatile (
		"syscall"
		: "=a" (rv)
		: "0" (333), "D" (pid), "S" (n), "d" (start), "r" (r10)
		: "rcx", "r11", "cc", "memory"
	);
	return rv;
}

int main(void)
{
	int pid[5];
	unsigned int start;
	int n;

	start = 0;
	while ((n = sys_pidmap(pid, sizeof(pid)/sizeof(pid[0]), start)) > 0) {
		int i;

		for (i = 0; i < n; i++) {
			printf(" %u", pid[i]);
		}
		printf("\n");
		start = pid[n - 1] + 1;
	}

	return 0;
}

Signed-off-by: Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>
Signed-off-by: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---

 arch/x86/entry/syscalls/syscall_64.tbl  |    1
 include/linux/syscalls.h                |    4
 kernel/Makefile                         |    2
 kernel/pidmap.c                         |  116 ++++++++++++++
 tools/testing/selftests/Makefile        |    1
 tools/testing/selftests/pidmap/Makefile |    5
 tools/testing/selftests/pidmap/pidmap.c |  263 ++++++++++++++++++++++++++++++++
 7 files changed, 392 insertions(+)

--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -339,6 +339,7 @@
 330	common	pkey_alloc		sys_pkey_alloc
 331	common	pkey_free		sys_pkey_free
 332	common	statx			sys_statx
+333	common	pidmap			sys_pidmap
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -923,4 +923,8 @@ asmlinkage long sys_pkey_free(int pkey);
 asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
 			  unsigned mask, struct statx __user *buffer);
 
+asmlinkage long sys_pidmap(int __user *pids,
+			   unsigned int pids_count,
+			   unsigned int start_pid,
+			   int flags);
 #endif
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,6 +11,8 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o smpboot.o ucount.o
 
+obj-y += pidmap.o
+
 obj-$(CONFIG_MULTIUSER) += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
--- /dev/null
+++ b/kernel/pidmap.c
@@ -0,0 +1,116 @@
+#include <linux/bitops.h>
+#include <linux/cred.h>
+#include <linux/kernel.h>
+#include <linux/pid.h>
+#include <linux/ptrace.h>
+#include <linux/rcupdate.h>
+#include <linux/syscalls.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+
+/**
+ * pidmap - get allocated PIDs
+ * @pids: Destination buffer.
+ * @pids_count: number of elements in the buffer.
+ * @start_pid: PID to start from.
+ * @flags: flags, must be 0.
+ *
+ * Write allocated PIDs to a buffer starting from @start_pid (inclusive).
+ * PIDs are filled from pid namespace of the calling process POV:
+ * unshare(CLONE_NEWPID)+fork+pidmap in child will always return 1/1.
+ *
+ * pidmap(2) hides PIDs inaccessible at /proc mounted with "hide_pid" option.
+ *
+ * Note, pidmap(2) does not guarantee that any of returned PID exists
+ * by the time system call exits.
+ *
+ * Return: number of PIDs written to the buffer or error code otherwise.
+ */
+SYSCALL_DEFINE4(pidmap, int __user *, pids, unsigned int, pids_count,
+		unsigned int, start_pid, int, flags)
+{
+	struct pid_namespace *ns = task_active_pid_ns(current);
+	unsigned int start_page, start_elem;
+	unsigned int last_pos = 0;
+	unsigned int last_set_pid = 0;
+	unsigned long mask;
+	bool has_perms = false;
+	unsigned int i;
+
+	if (flags)
+		return -EINVAL;
+
+	/*
+	 * Pid 0 does not exist, however, corresponding bit is always set in
+	 * ->pidmap[0].page, so we should skip it.
+	 */
+	if (start_pid == 0)
+		start_pid = 1;
+
+	if (start_pid > ns->last_pid)
+		return 0;
+
+	if (ns->hide_pid < HIDEPID_INVISIBLE || in_group_p(ns->pid_gid))
+		has_perms = true;
+
+	start_page = start_pid / BITS_PER_PAGE;
+	start_elem = (start_pid % BITS_PER_PAGE) / BITS_PER_LONG;
+	mask = ~0UL << (start_pid % BITS_PER_LONG);
+
+	for (i = start_page; i < PIDMAP_ENTRIES; i++) {
+		unsigned int j;
+
+		/*
+		 * ->pidmap[].page is set once to a valid pointer,
+		 *  therefore do not take any locks.
+		 */
+		if (ns->pidmap[i].page == NULL)
+			continue;
+
+		for (j = start_elem; j < PAGE_SIZE/sizeof(unsigned long); j++) {
+			unsigned long val;
+
+			val = *((unsigned long *)ns->pidmap[i].page + j);
+			val &= mask;
+			mask = ~0UL;
+			while (val != 0) {
+				struct task_struct *task;
+
+				if (last_pos == pids_count)
+					return last_pos;
+
+				last_set_pid = i * BITS_PER_PAGE +
+					j * BITS_PER_LONG + __ffs(val);
+
+				if (has_perms)
+					goto write;
+
+				rcu_read_lock();
+				task = find_task_by_pid_ns(last_set_pid, ns);
+				if (!task) {
+					rcu_read_unlock();
+					goto next;
+				}
+				if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS)) {
+					rcu_read_unlock();
+					goto next;
+				}
+				rcu_read_unlock();
+write:
+				if (put_user(last_set_pid, pids + last_pos))
+					return -EFAULT;
+				last_pos++;
+				if (last_set_pid == ns->last_pid)
+					return last_pos;
+next:
+				val &= (val - 1);
+			}
+
+		}
+		start_elem = 0;
+	}
+	if (last_set_pid == 0)
+		return 0;
+	else
+		return last_pos;
+}
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -20,6 +20,7 @@ TARGETS += mount
 TARGETS += mqueue
 TARGETS += net
 TARGETS += nsfs
+TARGETS += pidmap
 TARGETS += powerpc
 TARGETS += pstore
 TARGETS += ptrace
--- /dev/null
+++ b/tools/testing/selftests/pidmap/Makefile
@@ -0,0 +1,5 @@
+CFLAGS = -Wall
+
+TEST_GEN_PROGS := pidmap
+
+include ../lib.mk
--- /dev/null
+++ b/tools/testing/selftests/pidmap/pidmap.c
@@ -0,0 +1,263 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/wait.h>
+#include <stdlib.h>
+#include <sched.h>
+#include <dirent.h>
+#include <string.h>
+#include <sys/mount.h>
+#include <signal.h>
+#include "../kselftest_harness.h"
+
+#define SIZE 512
+
+static inline long pidmap(int *pid, unsigned int count, unsigned int start_pid)
+{
+	long ret;
+
+	register long r10 asm("r10") = 0;
+
+	asm volatile ("syscall" : "=a"(ret) :
+		"0"(333), "D"(pid), "S"(count), "d"(start_pid), "r"(r10) :
+		"rcx", "r11", "cc", "memory");
+	return ret;
+}
+
+static int compare(const void *a, const void *b)
+{
+	return *((int *)a) > *((int *)b);
+}
+
+int pidmap_full(int **pid, unsigned int *res_count)
+{
+	int n;
+	int start_pid = 1;
+	*pid = (int *)malloc(SIZE * sizeof(int));
+	*res_count = 0;
+
+	while ((n = pidmap(*pid + *res_count, SIZE, start_pid)) > 0) {
+		*res_count += n;
+		*pid = (int *)realloc(*pid, (*res_count + SIZE) * sizeof(int));
+		start_pid = (*pid)[*res_count - 1] + 1;
+	}
+	return n;
+}
+
+int pidmap_proc(int **pid, unsigned int *n)
+{
+	DIR *dir = opendir("/proc");
+	struct dirent *dirs;
+
+	*n = 0;
+	*pid = NULL;
+
+	while ((dirs = readdir(dir))) {
+		char dname[32] = "";
+		DIR *task_dir;
+
+		if (dirs->d_name[0] < '0' || dirs->d_name[0] > '9')
+			continue;
+
+		strcpy(dname, "/proc/");
+		strcat(dname, dirs->d_name);
+		strcat(dname, "/task");
+		task_dir = opendir(dname);
+
+		if (task_dir) {
+			struct dirent *task_dirs;
+
+			while ((task_dirs = readdir(task_dir))) {
+				if (task_dirs->d_name[0] < '0' ||
+						task_dirs->d_name[0] > '9')
+					continue;
+
+				*pid = (int *)realloc(*pid, (*n + 1) *
+								sizeof(int));
+				if (*pid == NULL)
+					return -1;
+				*(*pid + *n) = atoi(task_dirs->d_name);
+				*n += 1;
+			}
+		} else {
+			*pid = (int *)realloc(*pid, (*n + 1) * sizeof(int));
+			if (*pid == NULL)
+				return -1;
+			*(*pid + *n) = atoi(dirs->d_name);
+			*n += 1;
+		}
+		closedir(task_dir);
+	}
+	closedir(dir);
+	return 0;
+}
+
+TEST(bufsize)
+{
+	int pid[SIZE];
+
+	EXPECT_EQ(0, pidmap(pid, 0, 1));
+}
+
+TEST(get_pid)
+{
+	int pid;
+	int ret;
+
+	ret = pidmap(&pid, 1, getpid());
+	ASSERT_LE(0, ret);
+	EXPECT_EQ(getpid(), pid);
+}
+
+TEST(bad_start)
+{
+	int pid[SIZE];
+
+	ASSERT_LE(0, pidmap(pid, SIZE, -1));
+	ASSERT_LE(0, pidmap(pid, SIZE, ~0U));
+	ASSERT_LE(0, pidmap(pid, SIZE, 0));
+	EXPECT_EQ(1, pid[0]);
+}
+
+TEST(child_pid)
+{
+	pid_t pid = fork();
+
+	if (pid == 0)
+		pause();
+	else {
+		int ret;
+		int result = 0;
+
+		ret = pidmap(&result, 1, pid);
+		EXPECT_LE(0, ret);
+		EXPECT_EQ(pid, result);
+		kill(pid, SIGTERM);
+	}
+}
+
+int write_pidmax(int new_pidmax)
+{
+	char old_pidmax[32];
+	char new[32];
+	int fd = open("/proc/sys/kernel/pid_max", O_RDWR);
+
+	if (read(fd, old_pidmax, 32) <= 0)
+		printf("Read failed\n");
+	lseek(fd, 0, 0);
+	snprintf(new, sizeof(new), "%d", new_pidmax);
+	if (write(fd, new, strlen(new)) <= 0)
+		printf("Write failed\n");
+	close(fd);
+	return atoi(old_pidmax);
+}
+
+void do_forks(unsigned int n)
+{
+	while (n--) {
+		pid_t pid = fork();
+
+		if (pid == 0)
+			exit(0);
+		waitpid(pid, NULL, 0);
+	}
+}
+
+TEST(pid_max)
+{
+	int *pid;
+	unsigned int n;
+	int ret, p;
+	int old_pidmax;
+
+	old_pidmax = write_pidmax(50000);
+
+	do_forks(40000);
+
+	p = fork();
+
+	if (p == 0)
+		pause();
+
+	ret = pidmap_full(&pid, &n);
+
+	EXPECT_LE(0, ret);
+	EXPECT_EQ(p, pid[n - 1]);
+
+	kill(p, SIGKILL);
+	write_pidmax(old_pidmax);
+}
+
+TEST(compare_proc)
+{
+	pid_t pid;
+
+	if (unshare(CLONE_NEWNS | CLONE_NEWPID) == -1)
+		return;
+
+	pid = fork();
+
+	if (pid == 0) {
+		pid_t pid;
+		int i = 0;
+
+		mount("none", "/", NULL, MS_REC | MS_PRIVATE, NULL);
+		mount("none", "/proc", NULL, MS_REC | MS_PRIVATE, NULL);
+		mount("proc", "/proc", "proc",
+			MS_NOSUID | MS_NODEV | MS_NOEXEC, NULL);
+
+		while (i < 150) {
+			i++;
+
+			pid = fork();
+
+			if (pid == -1) {
+				wait(NULL);
+				umount("/proc");
+				return;
+			}
+			if (pid == 0) {
+				pause();
+				return;
+			}
+		}
+
+		int *pids, *pids_proc;
+		unsigned int n = 0;
+		unsigned int n_proc = 0;
+		int ret, ret_proc;
+
+		ret = pidmap_full(&pids, &n);
+
+		ret_proc = pidmap_proc(&pids_proc, &n_proc);
+		qsort(pids_proc, n_proc, sizeof(int), compare);
+
+		EXPECT_LE(0, ret);
+		EXPECT_EQ(n_proc, n);
+
+		if (ret <= 0 || ret_proc <= 0 || n != n_proc) {
+			killpg(0, SIGTERM);
+			wait(NULL);
+			umount("/proc");
+			free(pids);
+			free(pids_proc);
+			return;
+		}
+
+		for (int i = 0; i < n; i++) {
+			EXPECT_EQ(pids_proc[i], pids[i]);
+			if (pids_proc[i] != pids[i])
+				break;
+		}
+		EXPECT_EQ(1, pids[0]);
+
+		free(pids_proc);
+		free(pids);
+		killpg(0, SIGTERM);
+		wait(NULL);
+		umount("/proc");
+	}
+}
+
+TEST_HARNESS_MAIN
