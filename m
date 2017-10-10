From: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [1/2,v2] fdmap(2)
Date: Tue, 10 Oct 2017 15:08:06 -0700
Message-ID: <20171010220804.GA30735@outlook.office365.com>
References: <20170924200620.GA24368@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170924200620.GA24368@avx2>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Sep 24, 2017 at 11:06:20PM +0300, Alexey Dobriyan wrote:
> From: Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
> 
> Implement system call for bulk retrieveing of opened descriptors
> in binary form.
> 
> Some daemons could use it to reliably close file descriptors
> before starting. Currently they close everything upto some number
> which formally is not reliable. Other natural users are lsof(1) and CRIU
> (although lsof does so much in /proc that the effect is thoroughly buried).

Hello Alexey,

I am not sure about the idea to add syscalls for all sort of process
attributes. For example, in CRIU we need file descriptors with their
properties, which we currently get from /proc/pid/fdinfo/. How can
this interface be extended to achieve our goal?

Have you seen the task-diag interface what I sent about a year ago?

We had a discussion on the previous kernel summit how to rework
task-diag, so that it can be merged into the upstream kernel.
Unfortunately, I didn't send a summary for this discussion. But it's
better now than never. We decided to do something like this:

1. Add a new syscall readfile(fname, buf, size), which can be
used to read small files without opening a file descriptor. It will be
useful for proc files, configs, etc.

2. bin/text/bin conversion is very slow
 - 65.47% proc_pid_status
  - 20.81% render_sigset_t
   - 18.27% seq_printf
    + 15.77% seq_vprintf
  - 10.65% task_mem
    + 8.78% seq_print
    + 1.02% hugetlb_rep
  + 7.40% seq_printf
so a new interface has to use a binary format and the format of netlink
messages can be used here. It should be possible to extend a file
without breaking backward compatibility.

3. There are a lot of objection to use a netlink sockets out of the network
subsystem. The idea of using a "transaction" file looks weird for many
people, so we decided to add a few files in /proc/pid/. I see
minimum two files. One file contains information about a task, it is
mostly what we have in /proc/pid/status and /proc/pid/stat. Another file
describes a task memory, it is what we have now in /proc/pid/smaps.
Here is one more major idea. All attributes in a file has to be equal in
term of performance, or by other words there should not be attributes,
which significantly affect a generation time of a whole file.

If we look at /proc/pid/smaps, we spend a lot of time to get memory
statistics. This file contains a lot of data and if you read it to get
VmFlags, the kernel will waste your time by generating a useless data
for you.

Here is my slides for this discussion:
https://www.linuxplumbersconf.org/2016/ocw/system/presentations/4599/original/Netlink-issues.pdf

Could you add me into recipients for this sort of patches in a future?

Thanks,
Andrei

> 
> /proc, the only way to learn anything about file descriptors may not be
> available. There is unavoidable overhead associated with instantiating
> 3 dentries and 3 inodes and converting integers to strings and back.
> 
> Benchmark:
> 
> 	N=1<<22 times
> 	4 opened descriptors (0, 1, 2, 3)
> 	opendir+readdir+closedir /proc/self/fd vs fdmap
> 
> 	/proc 8.31 ± 0.37%
> 	fdmap 0.32 ± 0.72%
> 
> 
> FDMAP(2)                   Linux Programmer's Manual                  FDMAP(2)
> 
> NAME
>        fdmap - get open file descriptors of the process
> 
> SYNOPSIS
>        long fdmap(pid_t pid, int *fd, unsigned int nfd, int start, int flags);
> 
> DESCRIPTION
>        fdmap()  writes  open  file  descriptors  of the process into buffer fd
>        starting from the start descriptor. At most nfd elements  are  written.
>        flags argument is reserved and must be zero.
> 
>        If pid is zero, syscall will work with the current process.
> 
> RETURN VALUE
>        On success, number of descriptors written is returned.  On error, -1 is
>        returned, and errno is set appropriately.
> 
> ERRORS
>        ESRCH  No such process.
> 
>        EACCES Permission denied.
> 
>        EFAULT Invalid fd pointer.
> 
>        EINVAL Negative start argument.
> 
> NOTES
>        Glibc does not provide a wrapper for these system call; call  it  using
>        syscall(2).
> 
> EXAMPLE
>        The program below demonstrates fdmap() usage.
> 
>            $ ./a.out $$
>            0 1 2 255
> 
>            $ ./a.out 42</dev/null 1023</dev/null
>            0 1 2 42
>            1023
> 
>    Program source
> 
>        #include <sys/types.h>
>        #include <stdlib.h>
>        #include <stdio.h>
> 
>        static inline long fdmap(int pid, int *fd, unsigned int nfd, unsigned int start, int flags)
>        {
>             register long r10 asm ("r10") = start;
>             register long r8 asm ("r8") = flags;
>             long rv;
>             asm volatile (
>                  "syscall"
>                  : "=a" (rv)
>                  : "0" (333), "D" (pid), "S" (fd), "d" (nfd), "r" (r10), "r" (r8)
>                  : "rcx", "r11", "cc", "memory"
>             );
>             return rv;
>        }
> 
>        int main(int argc, char *argv[])
>        {
>             pid_t pid;
>             int fd[4];
>             unsigned int start;
>             int n;
> 
>             pid = 0;
>             if (argc > 1)
>                  pid = atoi(argv[1]);
> 
>             start = 0;
>             while ((n = fdmap(pid, fd, sizeof(fd)/sizeof(fd[0]), start, 0)) > 0) {
>                  unsigned int i;
> 
>                  for (i = 0; i < n; i++)
>                       printf("%u ", fd[i]);
>                  printf("\n");
> 
>                  start = fd[n - 1] + 1;
>             }
>             return 0;
>        }
> 
> Linux                             2017-09-21                          FDMAP(2)
> 
> Changelog:
> 
> 	CONFIG_PIDMAP option
> 	manpage
> 
> 
> Signed-off-by: Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
> Signed-off-by: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/entry/syscalls/syscall_64.tbl     |   1 +
>  fs/Makefile                                |   2 +
>  fs/fdmap.c                                 | 105 ++++++++++++++++++++
>  include/linux/syscalls.h                   |   2 +
>  init/Kconfig                               |   7 ++
>  kernel/sys_ni.c                            |   2 +
>  tools/testing/selftests/Makefile           |   1 +
>  tools/testing/selftests/fdmap/.gitignore   |   1 +
>  tools/testing/selftests/fdmap/Makefile     |   7 ++
>  tools/testing/selftests/fdmap/fdmap.c      | 112 +++++++++++++++++++++
>  tools/testing/selftests/fdmap/fdmap.h      |  12 +++
>  tools/testing/selftests/fdmap/fdmap_test.c | 153 +++++++++++++++++++++++++++++
>  12 files changed, 405 insertions(+)
>  create mode 100644 fs/fdmap.c
>  create mode 100644 tools/testing/selftests/fdmap/.gitignore
>  create mode 100644 tools/testing/selftests/fdmap/Makefile
>  create mode 100644 tools/testing/selftests/fdmap/fdmap.c
>  create mode 100644 tools/testing/selftests/fdmap/fdmap.h
>  create mode 100644 tools/testing/selftests/fdmap/fdmap_test.c
> 
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
> index 5aef183e2f85..9bfe5f79674f 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -339,6 +339,7 @@
>  330	common	pkey_alloc		sys_pkey_alloc
>  331	common	pkey_free		sys_pkey_free
>  332	common	statx			sys_statx
> +333	common	fdmap			sys_fdmap
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/fs/Makefile b/fs/Makefile
> index 7bbaca9c67b1..27476a66c18e 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -13,6 +13,8 @@ obj-y :=	open.o read_write.o file_table.o super.o \
>  		pnode.o splice.o sync.o utimes.o \
>  		stack.o fs_struct.o statfs.o fs_pin.o nsfs.o
>  
> +obj-$(CONFIG_FDMAP) += fdmap.o
> +
>  ifeq ($(CONFIG_BLOCK),y)
>  obj-y +=	buffer.o block_dev.o direct-io.o mpage.o
>  else
> diff --git a/fs/fdmap.c b/fs/fdmap.c
> new file mode 100644
> index 000000000000..274e6c5b7c9c
> --- /dev/null
> +++ b/fs/fdmap.c
> @@ -0,0 +1,105 @@
> +#include <linux/bitops.h>
> +#include <linux/fdtable.h>
> +#include <linux/rcupdate.h>
> +#include <linux/sched.h>
> +#include <linux/syscalls.h>
> +#include <linux/uaccess.h>
> +
> +/**
> + * fdmap - get opened file descriptors of a process
> + * @pid: the pid of the target process
> + * @fds: allocated userspace buffer
> + * @count: buffer size (in descriptors)
> + * @start_fd: first descriptor to search from (inclusive)
> + * @flags: reserved for future functionality, must be zero
> + *
> + * If @pid is zero then it's current process.
> + * Return: number of descriptors written. An error code otherwise.
> + */
> +SYSCALL_DEFINE5(fdmap, pid_t, pid, int __user *, fds, unsigned int, count,
> +		int, start_fd, int, flags)
> +{
> +	struct task_struct *task;
> +	struct files_struct *files;
> +	unsigned long search_mask;
> +	unsigned int user_index, offset;
> +	int masksize;
> +
> +	if (start_fd < 0 || flags != 0)
> +		return -EINVAL;
> +
> +	if (!pid) {
> +		files = get_files_struct(current);
> +	} else {
> +		rcu_read_lock();
> +		task = find_task_by_vpid(pid);
> +		if (!task) {
> +			rcu_read_unlock();
> +			return -ESRCH;
> +		}
> +		if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
> +			rcu_read_unlock();
> +			return -EACCES;
> +		}
> +		files = get_files_struct(task);
> +		rcu_read_unlock();
> +	}
> +	if (!files)
> +		return 0;
> +
> +	offset = start_fd / BITS_PER_LONG;
> +	search_mask = ULONG_MAX << (start_fd % BITS_PER_LONG);
> +	user_index = 0;
> +#define FDS_BUF_SIZE	(512/sizeof(unsigned long))
> +	masksize = FDS_BUF_SIZE;
> +	while (user_index < count && masksize == FDS_BUF_SIZE) {
> +		unsigned long open_fds[FDS_BUF_SIZE];
> +		struct fdtable *fdt;
> +		unsigned int i;
> +
> +		/*
> +		 * fdt->max_fds can grow, get it every time
> +		 * before copying part into internal buffer.
> +		 */
> +		rcu_read_lock();
> +		fdt = files_fdtable(files);
> +		masksize = fdt->max_fds / 8 - offset * sizeof(long);
> +		if (masksize < 0) {
> +			rcu_read_unlock();
> +			break;
> +		}
> +		masksize = min(masksize, (int)sizeof(open_fds));
> +		memcpy(open_fds, fdt->open_fds + offset, masksize);
> +		rcu_read_unlock();
> +
> +		open_fds[0] &= search_mask;
> +		search_mask = ULONG_MAX;
> +		masksize = (masksize + sizeof(long) - 1) / sizeof(long);
> +		start_fd = offset * BITS_PER_LONG;
> +		/*
> +		 * for_each_set_bit_from() can re-read first word
> +		 * multiple times which is not optimal.
> +		 */
> +		for (i = 0; i < masksize; i++) {
> +			unsigned long mask = open_fds[i];
> +
> +			while (mask) {
> +				unsigned int real_fd = start_fd + __ffs(mask);
> +
> +				if (put_user(real_fd, fds + user_index)) {
> +					put_files_struct(files);
> +					return -EFAULT;
> +				}
> +				if (++user_index >= count)
> +					goto out;
> +				mask &= mask - 1;
> +			}
> +			start_fd += BITS_PER_LONG;
> +		}
> +		offset += FDS_BUF_SIZE;
> +	}
> +out:
> +	put_files_struct(files);
> +
> +	return user_index;
> +}
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 95606a2d556f..d393d844facb 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -936,5 +936,7 @@ asmlinkage long sys_pkey_alloc(unsigned long flags, unsigned long init_val);
>  asmlinkage long sys_pkey_free(int pkey);
>  asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
>  			  unsigned mask, struct statx __user *buffer);
> +asmlinkage long sys_fdmap(pid_t pid, int __user *fds, unsigned int count,
> +			  int start_fd, int flags);
>  
>  #endif
> diff --git a/init/Kconfig b/init/Kconfig
> index 78cb2461012e..952d13b7326d 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1400,6 +1400,13 @@ config MEMBARRIER
>  
>  	  If unsure, say Y.
>  
> +config FDMAP
> +	bool "fdmap() system call" if EXPERT
> +	default y
> +	help
> +	  Enable fdmap() system call that allows to query file descriptors
> +	  in binary form avoiding /proc overhead.
> +
>  config EMBEDDED
>  	bool "Embedded system"
>  	option allnoconfig_y
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index 8acef8576ce9..d61fa27d021e 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -258,3 +258,5 @@ cond_syscall(sys_membarrier);
>  cond_syscall(sys_pkey_mprotect);
>  cond_syscall(sys_pkey_alloc);
>  cond_syscall(sys_pkey_free);
> +
> +cond_syscall(sys_fdmap);
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 26ce4f7168be..e8d63c27c865 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -5,6 +5,7 @@ TARGETS += cpufreq
>  TARGETS += cpu-hotplug
>  TARGETS += efivarfs
>  TARGETS += exec
> +TARGETS += fdmap
>  TARGETS += firmware
>  TARGETS += ftrace
>  TARGETS += futex
> diff --git a/tools/testing/selftests/fdmap/.gitignore b/tools/testing/selftests/fdmap/.gitignore
> new file mode 100644
> index 000000000000..9a9bfdac1cc0
> --- /dev/null
> +++ b/tools/testing/selftests/fdmap/.gitignore
> @@ -0,0 +1 @@
> +fdmap_test
> diff --git a/tools/testing/selftests/fdmap/Makefile b/tools/testing/selftests/fdmap/Makefile
> new file mode 100644
> index 000000000000..bf9f051f4b63
> --- /dev/null
> +++ b/tools/testing/selftests/fdmap/Makefile
> @@ -0,0 +1,7 @@
> +TEST_GEN_PROGS := fdmap_test
> +CFLAGS += -Wall
> +
> +include ../lib.mk
> +
> +$(TEST_GEN_PROGS): fdmap_test.c fdmap.c fdmap.h ../kselftest_harness.h
> +	$(CC) $(CFLAGS) $(LDFLAGS) $< fdmap.c -o $@
> diff --git a/tools/testing/selftests/fdmap/fdmap.c b/tools/testing/selftests/fdmap/fdmap.c
> new file mode 100644
> index 000000000000..66725b0201e0
> --- /dev/null
> +++ b/tools/testing/selftests/fdmap/fdmap.c
> @@ -0,0 +1,112 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <dirent.h>
> +#include <unistd.h>
> +#include <errno.h>
> +#include <sys/types.h>
> +#include "fdmap.h"
> +
> +#define	BUF_SIZE	1024
> +
> +long fdmap(pid_t pid, int *fds, size_t count, int start_fd, int flags)
> +{
> +	register int64_t r10 asm("r10") = start_fd;
> +	register int64_t r8 asm("r8") = flags;
> +	long ret;
> +
> +	asm volatile (
> +		"syscall"
> +		: "=a"(ret)
> +		: "0" (333),
> +		  "D" (pid), "S" (fds), "d" (count), "r" (r10), "r" (r8)
> +		: "rcx", "r11", "cc", "memory"
> +	);
> +	return ret;
> +}
> +
> +int fdmap_full(pid_t pid, int **fds, size_t *n)
> +{
> +	int buf[BUF_SIZE], start_fd = 0;
> +	long ret;
> +
> +	*n = 0;
> +	*fds = NULL;
> +	for (;;) {
> +		int *new_buff;
> +
> +		ret = fdmap(pid, buf, BUF_SIZE, start_fd, 0);
> +		if (ret < 0)
> +			break;
> +		if (!ret)
> +			return 0;
> +
> +		new_buff = realloc(*fds, (*n + ret) * sizeof(int));
> +		if (!new_buff) {
> +			ret = -errno;
> +			break;
> +		}
> +		*fds = new_buff;
> +		memcpy(*fds + *n, buf, ret * sizeof(int));
> +		*n += ret;
> +		start_fd = (*fds)[*n - 1] + 1;
> +	}
> +	free(*fds);
> +	*fds = NULL;
> +	return -ret;
> +}
> +
> +int fdmap_proc(pid_t pid, int **fds, size_t *n)
> +{
> +	char fds_path[20];
> +	int dir_fd = 0;
> +	struct dirent *fd_link;
> +	DIR *fds_dir;
> +
> +	*fds = NULL;
> +	*n = 0;
> +	if (!pid)
> +		strcpy(fds_path, "/proc/self/fd");
> +	else
> +		sprintf(fds_path, "/proc/%d/fd", pid);
> +
> +	fds_dir = opendir(fds_path);
> +	if (!fds_dir)
> +		return errno == ENOENT ? ESRCH : errno;
> +	if (!pid)
> +		dir_fd = dirfd(fds_dir);
> +
> +	while ((fd_link = readdir(fds_dir))) {
> +		if (fd_link->d_name[0] < '0'
> +		    || fd_link->d_name[0] > '9')
> +			continue;
> +		if (*n % BUF_SIZE == 0) {
> +			int *new_buff;
> +
> +			new_buff = realloc(*fds, (*n + BUF_SIZE) * sizeof(int));
> +			if (!new_buff) {
> +				int ret = errno;
> +
> +				free(*fds);
> +				*fds = NULL;
> +				return ret;
> +			}
> +			*fds = new_buff;
> +		}
> +		(*fds)[*n] = atoi(fd_link->d_name);
> +		*n += 1;
> +	}
> +	closedir(fds_dir);
> +
> +	if (!pid) {
> +		size_t i;
> +
> +		for (i = 0; i < *n; i++)
> +			if ((*fds)[i] == dir_fd)
> +				break;
> +		i++;
> +		memmove(*fds + i - 1, *fds + i, (*n - i) * sizeof(int));
> +		(*n)--;
> +	}
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/fdmap/fdmap.h b/tools/testing/selftests/fdmap/fdmap.h
> new file mode 100644
> index 000000000000..c501111b2bbd
> --- /dev/null
> +++ b/tools/testing/selftests/fdmap/fdmap.h
> @@ -0,0 +1,12 @@
> +#ifndef FDMAP_H
> +#define FDMAP_H
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/types.h>
> +
> +long fdmap(pid_t pid, int *fds, size_t count, int start_fd, int flags);
> +int fdmap_full(pid_t pid, int **fds, size_t *n);
> +int fdmap_proc(pid_t pid, int **fds, size_t *n);
> +
> +#endif
> diff --git a/tools/testing/selftests/fdmap/fdmap_test.c b/tools/testing/selftests/fdmap/fdmap_test.c
> new file mode 100644
> index 000000000000..6f448406d96a
> --- /dev/null
> +++ b/tools/testing/selftests/fdmap/fdmap_test.c
> @@ -0,0 +1,153 @@
> +#include <errno.h>
> +#include <syscall.h>
> +#include <sys/time.h>
> +#include <sys/resource.h>
> +#include <limits.h>
> +#include "../kselftest_harness.h"
> +#include "fdmap.h"
> +
> +TEST(efault) {
> +	int ret;
> +
> +	ret = syscall(333, 0, NULL, 20 * sizeof(int), 0, 0);
> +	ASSERT_EQ(-1, ret);
> +	ASSERT_EQ(EFAULT, errno);
> +}
> +
> +TEST(big_start_fd) {
> +	int fds[1];
> +	int ret;
> +
> +	ret = syscall(333, 0, fds, sizeof(int), INT_MAX, 0);
> +	ASSERT_EQ(0, ret);
> +}
> +
> +TEST(einval) {
> +	int ret;
> +
> +	ret = syscall(333, 0, NULL, 0, -1, 0);
> +	ASSERT_EQ(-1, ret);
> +	ASSERT_EQ(EINVAL, errno);
> +
> +	ret = syscall(333, 0, NULL, 0, 0, 1);
> +	ASSERT_EQ(-1, ret);
> +	ASSERT_EQ(EINVAL, errno);
> +}
> +
> +TEST(esrch) {
> +	int fds[1], ret;
> +	pid_t pid;
> +
> +	pid = fork();
> +	ASSERT_NE(-1, pid);
> +	if (!pid)
> +		exit(0);
> +	waitpid(pid, NULL, 0);
> +
> +	ret = syscall(333, pid, fds, sizeof(int), 0, 0);
> +	ASSERT_EQ(-1, ret);
> +	ASSERT_EQ(ESRCH, errno);
> +}
> +
> +TEST(simple) {
> +	int *fds1, *fds2;
> +	size_t size1, size2, i;
> +	int ret1, ret2;
> +
> +	ret1 = fdmap_full(0, &fds1, &size1);
> +	ret2 = fdmap_proc(0, &fds2, &size2);
> +	ASSERT_EQ(ret2, ret1);
> +	ASSERT_EQ(size2, size1);
> +	for (i = 0; i < size1; i++)
> +		ASSERT_EQ(fds2[i], fds1[i]);
> +	free(fds1);
> +	free(fds2);
> +}
> +
> +TEST(init) {
> +	int *fds1, *fds2;
> +	size_t size1, size2, i;
> +	int ret1, ret2;
> +
> +	ret1 = fdmap_full(1, &fds1, &size1);
> +	ret2 = fdmap_proc(1, &fds2, &size2);
> +	ASSERT_EQ(ret2, ret1);
> +	ASSERT_EQ(size2, size1);
> +	for (i = 0; i < size1; i++)
> +		ASSERT_EQ(fds2[i], fds1[i]);
> +	free(fds1);
> +	free(fds2);
> +}
> +
> +TEST(zero) {
> +	int *fds, i;
> +	size_t size;
> +	int ret;
> +
> +	ret = fdmap_proc(0, &fds, &size);
> +	ASSERT_EQ(0, ret);
> +	for (i = 0; i < size; i++)
> +		close(fds[i]);
> +	free(fds);
> +	fds = NULL;
> +
> +	ret = fdmap_full(0, &fds, &size);
> +	ASSERT_EQ(0, ret);
> +	ASSERT_EQ(0, size);
> +}
> +
> +TEST(more_fds) {
> +	int *fds1, *fds2, ret1, ret2;
> +	size_t size1, size2, i;
> +
> +	struct rlimit rlim = {
> +		.rlim_cur = 600000,
> +		.rlim_max = 600000
> +	};
> +	ASSERT_EQ(0, setrlimit(RLIMIT_NOFILE, &rlim));
> +	for (int i = 0; i < 500000; i++)
> +		dup(0);
> +
> +	ret1 = fdmap_full(0, &fds1, &size1);
> +	ret2 = fdmap_proc(0, &fds2, &size2);
> +	ASSERT_EQ(ret2, ret1);
> +	ASSERT_EQ(size2, size1);
> +	for (i = 0; i < size1; i++)
> +		ASSERT_EQ(fds2[i], fds1[i]);
> +	free(fds1);
> +	free(fds2);
> +}
> +
> +TEST(child) {
> +	int pipefd[2];
> +	int *fds1, *fds2, ret1, ret2, i;
> +	size_t size1, size2;
> +	char byte = 0;
> +	pid_t pid;
> +
> +	ASSERT_NE(-1, pipe(pipefd));
> +	pid = fork();
> +	ASSERT_NE(-1, pid);
> +	if (!pid) {
> +		read(pipefd[0], &byte, 1);
> +		close(pipefd[0]);
> +		close(pipefd[1]);
> +		exit(0);
> +	}
> +
> +	ret1 = fdmap_full(0, &fds1, &size1);
> +	ret2 = fdmap_proc(0, &fds2, &size2);
> +	ASSERT_EQ(ret2, ret1);
> +	ASSERT_EQ(size2, size1);
> +	for (i = 0; i < size1; i++)
> +		ASSERT_EQ(fds2[i], fds1[i]);
> +	free(fds1);
> +	free(fds2);
> +
> +	write(pipefd[1], &byte, 1);
> +	close(pipefd[0]);
> +	close(pipefd[1]);
> +	waitpid(pid, NULL, 0);
> +}
> +
> +TEST_HARNESS_MAIN
