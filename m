From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/2] pidmap(2)
Date: Sun, 24 Sep 2017 23:08:22 +0300
Message-ID: <20170924200822.GB24368@avx2>
References: <20170924200620.GA24368@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170924200620.GA24368@avx2>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org, Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>

Implement system call for bulk retrieveing of pids in binary form.

Using /proc is slower than necessary: 3 syscalls + another 3 for each thread +
converting with atoi() + instantiating dentries and inodes.

/proc may be not mounted especially in containers. Natural extension of
hidepid=2 efforts is to not mount /proc at all.

It could be used by programs like ps, top or CRIU. Speed increase will
become more drastic once combined with bulk retrieval of process statistics.

Benchmark:

	N=1<<16 times
	~130 processes (~250 task_structs) on a regular desktop system
	opendir + readdir + closedir /proc + the same for every /proc/$PID/task
	(roughly what htop(1) does) vs pidmap

	/proc 16.80 ± 0.73%
	pidmap 0.06 ± 0.31%

PIDMAP_* flags are modelled after /proc/task_diag patchset.


PIDMAP(2)                  Linux Programmer's Manual                 PIDMAP(2)

NAME
       pidmap - get allocated PIDs

SYNOPSIS
       long pidmap(pid_t pid, int *pids, unsigned int count , unsigned int start, int flags);

DESCRIPTION
       The system call pidmap(2) writes process IDs in buffer pointed by pids.
       At most count pids are written. The pid argument specifies  process  ID
       in  several  values in flags.  If pid equals to zero, syscall will work
       with current process.  The argument start depends on  the  flags.   The
       argument  flags  must include one of the following modes: PIDMAP_TASKS,
       PIDMAP_PROC, PIDMAP_CHILDREN, or PIDMAP_THREADS.  For PIDMAP_TASKS  and
       PIDMAP_PROC exists optional PIDMAP_IGNORE_KTHREADS flag.

       PIDs  are  filled  from  pid  namespace  of  the  calling  process POV:
       unshare(CLONE_NEWPID) + fork + pidmap in child will always return 1/1.

       pidmap(2) hides  PIDs  inaccessible  at  /proc  mounted  with  hide_pid
       option.

       Note,  pidmap(2)  does not guarantee that any of returned PID exists by
       the time system call exists.

       Full list of flags and options is below:

       PIDMAP_TASKS
              Get PIDs of all tasks, including  threads  starting  from  start
              inclusive. First argument pid will be ignored.

       PIDMAP_PROC
              Get  all  process IDs starting from start inclusive. First argu‐
              ment pid will be ignored.

       PIDMAP_CHILDREN
              Get children IDs of  the  process  specified  by  pid  argument.
              start  argument  specifies  number  of  children to skip in this
              case.

       PIDMAP_THREADS
              Get threads IDs of the process specified by pid argument.  start
              argument specifies number of threads to skip in this case.

       PIDMAP_IGNORE_KTHREADS
              Ignore  kernel  threads.  Optional  and  will  be  ignored  with
              PIDMAP_CHILDREN and PIDMAP_THREADS flags.

RETURN VALUE
       On success, number of PIDs read is returned. Otherwise, error  code  is
       returned.

ERRORS
       ESRCH  No such process.

       EACCES Permission denied.

       EFAULT Invalid pids pointer.

       EINVAL Invalid flags value.

NOTES
       Glibc  does  not  provide a wrapper for this system call; call it using
       syscall(2).

EXAMPLE
       #include <stdio.h>
       #include <linux/pidmap.h>

       static inline long pidmap(int pid, int *pids, unsigned int n, unsigned int start, int flags)
       {
               register long r10 asm("r10") = start;
               register long r8 asm("r8") = flags;
               long ret;
               asm volatile (
                       "syscall"
                       : "=a" (ret)
                       : "0" (334), "D" (pid), "S" (pids), "d" (n), "r" (r10), "r" (r8)
                       : "rcx", "r11", "cc", "memory"
               );
               return ret;
       }

       int main(void)
       {
               int pids[5];
               unsigned int start;
               unsigned int i;
               int n;

               start = 0;
               while ((n = pidmap(0, pids, sizeof(pids)/sizeof(pids[0]),
                            start, PIDMAP_PROC | PIDMAP_IGNORE_KTHREADS)) > 0) {

                       for (i = 0; i < n; i++)
                               printf("%d ", pids[i]);
                       printf("\n");

                       start = pids[n - 1] + 1;
               }
               return 0;
       }

Linux                             2017-09-21                         PIDMAP(2)

Changelog:

	CONFIG_PIDMAP option
	PIDMAP_* options
	PIDMAP_IGNORE_KTHREADS
	manpage

Signed-off-by: Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>
Signed-off-by: Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
Signed-off-by: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 arch/x86/entry/syscalls/syscall_64.tbl    |   1 +
 include/linux/syscalls.h                  |   5 +
 include/uapi/linux/pidmap.h               |  10 +
 init/Kconfig                              |   7 +
 kernel/Makefile                           |   2 +
 kernel/pidmap.c                           | 287 ++++++++++++++++++++++++++++
 kernel/sys_ni.c                           |   1 +
 tools/testing/selftests/Makefile          |   1 +
 tools/testing/selftests/pidmap/.gitignore |   1 +
 tools/testing/selftests/pidmap/Makefile   |   5 +
 tools/testing/selftests/pidmap/pidmap.c   | 298 ++++++++++++++++++++++++++++++
 tools/testing/selftests/pidmap/pidmap.h   |   1 +
 12 files changed, 619 insertions(+)
 create mode 100644 include/uapi/linux/pidmap.h
 create mode 100644 kernel/pidmap.c
 create mode 100644 tools/testing/selftests/pidmap/.gitignore
 create mode 100644 tools/testing/selftests/pidmap/Makefile
 create mode 100644 tools/testing/selftests/pidmap/pidmap.c
 create mode 120000 tools/testing/selftests/pidmap/pidmap.h

diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 9bfe5f79674f..8ce611f14969 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -340,6 +340,7 @@
 331	common	pkey_free		sys_pkey_free
 332	common	statx			sys_statx
 333	common	fdmap			sys_fdmap
+334	common	pidmap			sys_pidmap
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d393d844facb..cc1ef71dbb4a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -939,4 +939,9 @@ asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
 asmlinkage long sys_fdmap(pid_t pid, int __user *fds, unsigned int count,
 			  int start_fd, int flags);
 
+asmlinkage long sys_pidmap(pid_t pid,
+			   int __user *pids,
+			   unsigned int pids_count,
+			   unsigned int start_pid,
+			   int flags);
 #endif
diff --git a/include/uapi/linux/pidmap.h b/include/uapi/linux/pidmap.h
new file mode 100644
index 000000000000..75a7557c22eb
--- /dev/null
+++ b/include/uapi/linux/pidmap.h
@@ -0,0 +1,10 @@
+#ifndef _UAPI_LINUX_PIDMAP_H
+#define _UAPI_LINUX_PIDMAP_H
+
+#define PIDMAP_TASKS	1
+#define PIDMAP_PROC	2
+#define PIDMAP_CHILDREN	3
+#define PIDMAP_THREADS	4
+#define PIDMAP_IGNORE_KTHREADS	(1 << 30)
+
+#endif /* _UAPI_LINUX_PIDMAP_H */
diff --git a/init/Kconfig b/init/Kconfig
index 952d13b7326d..163155e0cfb4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1407,6 +1407,13 @@ config FDMAP
 	  Enable fdmap() system call that allows to query file descriptors
 	  in binary form avoiding /proc overhead.
 
+config PIDMAP
+	bool "pidmap() system call" if EXPERT
+	default y
+	help
+	  Enable pidmap() system call that allows to query PIDs in binary form
+	  avoiding /proc overhead.
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
diff --git a/kernel/Makefile b/kernel/Makefile
index ed470aac53da..f8833e5b27e5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,6 +11,8 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o smpboot.o ucount.o
 
+obj-$(CONFIG_PIDMAP) += pidmap.o
+
 obj-$(CONFIG_MODULES) += kmod.o
 obj-$(CONFIG_MULTIUSER) += groups.o
 
diff --git a/kernel/pidmap.c b/kernel/pidmap.c
new file mode 100644
index 000000000000..0392bc6935b6
--- /dev/null
+++ b/kernel/pidmap.c
@@ -0,0 +1,287 @@
+#include <linux/bitops.h>
+#include <linux/cred.h>
+#include <linux/kernel.h>
+#include <linux/pid.h>
+#include <linux/ptrace.h>
+#include <linux/rcupdate.h>
+#include <linux/syscalls.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/pidmap.h>
+
+#define PIDMAP_PARAM	(~PIDMAP_IGNORE_KTHREADS)
+
+static inline bool pidmap_perm(const struct pid_namespace *pid_ns)
+{
+	return pid_ns->hide_pid < HIDEPID_INVISIBLE || in_group_p(pid_ns->pid_gid);
+}
+
+static bool skip_task(struct task_struct *task, bool has_perms, int flags)
+{
+	int param = flags & PIDMAP_PARAM;
+
+	if (!task)
+		return true;
+	if (!has_perms && !ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
+		return true;
+	if ((flags & PIDMAP_IGNORE_KTHREADS) && (task->flags & PF_KTHREAD))
+		return true;
+	if (param == PIDMAP_PROC && !thread_group_leader(task))
+		return true;
+	return false;
+}
+
+static long pidmap_tasks(int __user *pids, unsigned int count,
+		  unsigned int start, int flags)
+{
+	struct pid_namespace *pid_ns = task_active_pid_ns(current);
+	unsigned int start_page, start_elem;
+	unsigned int last_pos = 0;
+	unsigned int last_set_pid = 0;
+	unsigned long mask;
+	bool has_perms;
+	unsigned int i;
+
+	/*
+	 * Pid 0 does not exist, however, corresponding bit is always set in
+	 * ->pidmap[0].page, so we should skip it.
+	 */
+	if (start == 0)
+		start = 1;
+
+	if (start > pid_ns->last_pid)
+		return 0;
+
+	has_perms = pidmap_perm(pid_ns);
+
+	start_page = start / BITS_PER_PAGE;
+	start_elem = (start % BITS_PER_PAGE) / BITS_PER_LONG;
+	mask = ~0UL << (start % BITS_PER_LONG);
+
+	for (i = start_page; i < PIDMAP_ENTRIES; i++) {
+		unsigned int j;
+
+		/*
+		 * ->pidmap[].page is set once to a valid pointer,
+		 *  therefore do not take any locks.
+		 */
+		if (!pid_ns->pidmap[i].page)
+			continue;
+
+		for (j = start_elem; j < PAGE_SIZE/sizeof(unsigned long); j++) {
+			unsigned long val;
+
+			val = *((unsigned long *)pid_ns->pidmap[i].page + j);
+			val &= mask;
+			mask = ~0UL;
+			while (val != 0) {
+				struct task_struct *task;
+
+				if (last_pos == count)
+					return last_pos;
+
+				last_set_pid = i * BITS_PER_PAGE +
+					j * BITS_PER_LONG + __ffs(val);
+
+				rcu_read_lock();
+				task = find_task_by_pid_ns(last_set_pid, pid_ns);
+				if (skip_task(task, has_perms, flags)) {
+					rcu_read_unlock();
+					goto next;
+				}
+				rcu_read_unlock();
+
+				if (put_user(last_set_pid, pids + last_pos))
+					return -EFAULT;
+				last_pos++;
+				if (last_set_pid == pid_ns->last_pid)
+					return last_pos;
+next:
+				val &= (val - 1);
+			}
+		}
+		start_elem = 0;
+	}
+	if (last_set_pid == 0)
+		return 0;
+	else
+		return last_pos;
+}
+
+static struct task_struct *pidmap_get_task(pid_t pid, bool *has_perms)
+{
+	struct pid_namespace *pid_ns;
+	struct task_struct *task;
+
+	if (pid == 0) {
+		*has_perms = true;
+		return current;
+	}
+
+	pid_ns = task_active_pid_ns(current);
+	task = find_task_by_pid_ns(pid, pid_ns);
+	if (!task)
+		return ERR_PTR(-ESRCH);
+	*has_perms = pidmap_perm(pid_ns);
+	if (!*has_perms && !ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
+		return ERR_PTR(-EACCES);
+	return task;
+}
+
+static long pidmap_children(pid_t pid, int __user *upid,
+			    unsigned int count, unsigned int start)
+{
+	struct task_struct *task, *child;
+	bool has_perms;
+	int pids[64];
+	unsigned int i;
+	unsigned int ret;
+
+	rcu_read_lock();
+	task = pidmap_get_task(pid, &has_perms);
+	if (IS_ERR(task)) {
+		rcu_read_unlock();
+		return PTR_ERR(task);
+	}
+
+	i = 0;
+	ret = 0;
+	list_for_each_entry(child, &task->children, sibling) {
+		if (start) {
+			start--;
+			continue;
+		}
+
+		if (!has_perms &&
+		    !ptrace_may_access(child, PTRACE_MODE_READ_FSCREDS))
+			continue;
+
+		pids[i++] = child->tgid;
+		if (i >= ARRAY_SIZE(pids)) {
+			get_task_struct(task);
+			get_task_struct(child);
+			rcu_read_unlock();
+
+			if (copy_to_user(upid, pids, i * sizeof(int))) {
+				put_task_struct(child);
+				put_task_struct(task);
+				return -EFAULT;
+			}
+			upid += i;
+			ret += i;
+			i = 0;
+
+			rcu_read_lock();
+			put_task_struct(child);
+			put_task_struct(task);
+
+			if (!pid_alive(task) || !pid_alive(child))
+				break;
+		}
+		if (--count == 0)
+			break;
+	}
+	rcu_read_unlock();
+	if (i > 0) {
+		if (copy_to_user(upid, pids, i * sizeof(int)))
+			return -EFAULT;
+		ret += i;
+	}
+	return ret;
+}
+
+static long pidmap_threads(pid_t pid, int __user *upid,
+			   unsigned int count, unsigned int start)
+{
+	struct task_struct *task, *thread;
+	bool has_perms;
+	int pids[64];
+	unsigned int i;
+	unsigned int ret;
+
+	rcu_read_lock();
+	task = pidmap_get_task(pid, &has_perms);
+	if (IS_ERR(task)) {
+		rcu_read_unlock();
+		return PTR_ERR(task);
+	}
+
+	i = 0;
+	ret = 0;
+	for_each_thread(task, thread) {
+		if (start) {
+			start--;
+			continue;
+		}
+
+		pids[i++] = thread->pid;
+		if (i >= ARRAY_SIZE(pids)) {
+			get_task_struct(task);
+			get_task_struct(thread);
+			rcu_read_unlock();
+
+			if (copy_to_user(upid, pids, i * sizeof(int))) {
+				put_task_struct(thread);
+				put_task_struct(task);
+				return -EFAULT;
+			}
+			upid += i;
+			ret += i;
+			i = 0;
+
+			rcu_read_lock();
+			put_task_struct(thread);
+			put_task_struct(task);
+
+			if (!pid_alive(task) || !pid_alive(thread))
+				break;
+		}
+		if (--count == 0)
+			break;
+	}
+	rcu_read_unlock();
+	if (i > 0) {
+		if (copy_to_user(upid, pids, i * sizeof(int)))
+			return -EFAULT;
+		ret += i;
+	}
+	return ret;
+}
+
+/**
+ * pidmap - get allocated PIDs
+ * @pids: destination buffer.
+ * @count: number of elements in the buffer.
+ * @start: PID to start from or PIDs number already readed.
+ * @flags: flags.
+ *
+ * Write allocated PIDs to a buffer. @start specifies PID to start from
+ * with PIDMAP_TASKS or PIDMAP_PROC flags, or number of PIDs already
+ * readed otherwise.
+ *
+ * PIDs are filled from pid namespace of the calling process POV:
+ * unshare(CLONE_NEWPID)+fork+pidmap in child will always return 1/1.
+ *
+ * pidmap(2) hides PIDs inaccessible at /proc mounted with "hidepid" option.
+ *
+ * Note, pidmap(2) does not guarantee that any of returned PID exists
+ * by the time system call exits.
+ *
+ * Return: number of PIDs written to the buffer or error code otherwise.
+ */
+SYSCALL_DEFINE5(pidmap, pid_t, pid, int __user *, pids,
+		unsigned int, count, unsigned int, start, int, flags)
+{
+	int param = flags & PIDMAP_PARAM;
+
+	switch (param) {
+	case PIDMAP_TASKS:
+	case PIDMAP_PROC:
+		return pidmap_tasks(pids, count, start, flags);
+	case PIDMAP_CHILDREN:
+		return pidmap_children(pid, pids, count, start);
+	case PIDMAP_THREADS:
+		return pidmap_threads(pid, pids, count, start);
+	}
+	return -EINVAL;
+}
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index d61fa27d021e..a600d458c1d9 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -260,3 +260,4 @@ cond_syscall(sys_pkey_alloc);
 cond_syscall(sys_pkey_free);
 
 cond_syscall(sys_fdmap);
+cond_syscall(sys_pidmap);
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index e8d63c27c865..4d1443a83121 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -21,6 +21,7 @@ TARGETS += mount
 TARGETS += mqueue
 TARGETS += net
 TARGETS += nsfs
+TARGETS += pidmap
 TARGETS += powerpc
 TARGETS += pstore
 TARGETS += ptrace
diff --git a/tools/testing/selftests/pidmap/.gitignore b/tools/testing/selftests/pidmap/.gitignore
new file mode 100644
index 000000000000..a762199f2637
--- /dev/null
+++ b/tools/testing/selftests/pidmap/.gitignore
@@ -0,0 +1 @@
+pidmap
diff --git a/tools/testing/selftests/pidmap/Makefile b/tools/testing/selftests/pidmap/Makefile
new file mode 100644
index 000000000000..3deae4ef7295
--- /dev/null
+++ b/tools/testing/selftests/pidmap/Makefile
@@ -0,0 +1,5 @@
+CFLAGS = -Wall
+
+TEST_GEN_PROGS := pidmap
+
+include ../lib.mk
diff --git a/tools/testing/selftests/pidmap/pidmap.c b/tools/testing/selftests/pidmap/pidmap.c
new file mode 100644
index 000000000000..76a9ec57d466
--- /dev/null
+++ b/tools/testing/selftests/pidmap/pidmap.c
@@ -0,0 +1,298 @@
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
+#include <assert.h>
+#include "pidmap.h"
+#include "../kselftest_harness.h"
+
+#define SIZE 512
+
+static inline long pidmap(pid_t pid, int *pids, unsigned int count,
+			  unsigned int start_pid, int flags)
+{
+	long ret;
+
+	register long r10 asm("r10") = start_pid;
+	register long r8 asm("r8") = flags;
+
+	asm volatile ("syscall" : "=a"(ret) :
+		"0"(334), "D"(pid), "S"(pids), "d"(count), "r"(r10), "r"(r8) :
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
+	while ((n = pidmap(0, *pid + *res_count, SIZE, start_pid,
+			   PIDMAP_TASKS)) > 0) {
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
+	EXPECT_EQ(0, pidmap(0, pid, 0, 1, PIDMAP_TASKS));
+}
+
+TEST(get_pid)
+{
+	int pid;
+	int ret;
+
+	ret = pidmap(0, &pid, 1, getpid(), PIDMAP_TASKS);
+	ASSERT_LE(0, ret);
+	EXPECT_EQ(getpid(), pid);
+}
+
+TEST(bad_start)
+{
+	int pid[SIZE];
+
+	ASSERT_LE(0, pidmap(0, pid, SIZE, -1, PIDMAP_TASKS));
+	ASSERT_LE(0, pidmap(0, pid, SIZE, ~0U, PIDMAP_TASKS));
+	ASSERT_LE(0, pidmap(0, pid, SIZE, 0, PIDMAP_TASKS));
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
+		ret = pidmap(0, &result, 1, pid, PIDMAP_TASKS);
+		EXPECT_LE(0, ret);
+		EXPECT_EQ(pid, result);
+		kill(pid, SIGTERM);
+	}
+}
+
+TEST(pidmap_children_flag)
+{
+	int real_pids[SIZE], pids[SIZE];
+	int i;
+
+	for (i = 0; i < SIZE; i++) {
+		pid_t pid = fork();
+		if (!pid) {
+			pause();
+			exit(0);
+		} else if (pid < 0) {
+			perror("fork");
+			exit(1);
+		}
+		real_pids[i] = pid;
+	}
+
+	ASSERT_EQ(SIZE, pidmap(0, pids, SIZE, 0, PIDMAP_CHILDREN));
+	for (i = 0; i < SIZE; i++) {
+		ASSERT_EQ(real_pids[i], pids[i]);
+		kill(real_pids[i], SIGKILL);
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
+	kill(p, SIGKILL);
+
+	EXPECT_LE(0, ret);
+	EXPECT_LE(1, n);
+	if (ret < 0 || n <= 0)
+		goto exit;
+	EXPECT_EQ(p, pid[n - 1]);
+exit:
+	write_pidmax(old_pidmax);
+}
+
+void sigquit_h(int sig)
+{
+	assert(sig == SIGQUIT);
+	if (getgid() != getpid())
+		exit(0);
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
+		pid_t p;
+		int i = 0;
+
+		signal(SIGQUIT, sigquit_h);
+
+		mount("none", "/", NULL, MS_REC | MS_PRIVATE, NULL);
+		mount("none", "/proc", NULL, MS_REC | MS_PRIVATE, NULL);
+		mount("proc", "/proc", "proc",
+			MS_NOSUID | MS_NODEV | MS_NOEXEC, NULL);
+
+		while (i < 150) {
+			i++;
+
+			p = fork();
+
+			if (p == -1) {
+				umount("/proc");
+				return;
+			}
+			if (p == 0) {
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
+		if (ret < 0 || ret_proc < 0)
+			goto exit;
+
+		EXPECT_EQ(n_proc, n);
+		if (n != n_proc)
+			goto exit;
+
+		for (int i = 0; i < n; i++) {
+			EXPECT_EQ(pids_proc[i], pids[i]);
+			if (pids_proc[i] != pids[i])
+				break;
+		}
+exit:
+		free(pids_proc);
+		free(pids);
+		umount("/proc");
+		kill(-getpid(), SIGQUIT);
+	}
+	wait(NULL);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/pidmap/pidmap.h b/tools/testing/selftests/pidmap/pidmap.h
new file mode 120000
index 000000000000..3abbde34fee9
--- /dev/null
+++ b/tools/testing/selftests/pidmap/pidmap.h
@@ -0,0 +1 @@
+../../../../include/uapi/linux/pidmap.h
\ No newline at end of file
