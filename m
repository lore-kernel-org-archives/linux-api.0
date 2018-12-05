From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v3] signal: add procfd_send_signal() syscall
Date: Wed, 05 Dec 2018 12:10:55 -0600
Message-ID: <87bm5zondc.fsf@xmission.com>
References: <20181205092203.14105-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181205092203.14105-1-christian@brauner.io> (Christian
        Brauner's message of "Wed, 5 Dec 2018 10:22:03 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Christian Brauner <christian@brauner.io> writes:

> The kill() syscall operates on process identifiers (pid). After a process
> has exited its pid can be reused by another process. If a caller sends a
> signal to a reused pid it will end up signaling the wrong process. This
> issue has often surfaced and there has been a push [1] to address this
> problem.
>
> This patch uses file descriptors (fd) from proc/<pid> as stable handles on
> struct pid. Even if a pid is recycled the handle will not change. The fd
> can be used to send signals to the process it refers to.
> Thus, the new syscall procfd_send_signal() is introduced to solve this
> problem. Instead of pids it operates on process fds (procfd).
>
> /* prototype and argument /*
> long procfd_send_signal(int fd, int sig, siginfo_t *info, unsigned int flags);
>
> In addition to the procfd and signal argument it takes an additional
> siginfo_t and flags argument. If the siginfo_t argument is NULL then
> procfd_send_signal() behaves like kill(). If it is not NULL
> procfd_send_signal() behaves like rt_sigqueueinfo().
> The flags argument is added to allow for future extensions of this syscall.
> It currently needs to be passed as 0. Failing to do so will cause EINVAL.
>
> /* procfd_send_signal() replaces multiple pid-based syscalls */
> The procfd_send_signal() syscall currently takes on the job of the
> following syscalls that operate on pids:
> - kill(2)
> - rt_sigqueueinfo(2)
> The syscall is defined in such a way that it can also operate on thread fds
> instead of process fds. In a future patchset I will extend it to operate on
> procfds from /proc/<pid>/task/<tid> at which point it will additionally
> take on the job of:
> - tgkill(2)
> - rt_tgsigqueueinfo(2)
> Right now this is intentionally left out to keep this patchset as simple as
> possible (cf. [4]). If a procfd of /proc/<pid>/task/<tid> is passed
> EOPNOTSUPP will be returned to give userspace a way to detect when I add
> support for such procfds {cf. [10]).
>
> /* naming */
> The name procfd_send_signal() was chosen to reflect the fact that it takes
> on the job of multiple syscalls. It is intentional that the name is not
> reminiscent of neither kill(2) nor rt_sigqueueinfo(2). Not the fomer
> because it might imply that procfd_send_signal() is only a replacement for
> kill(2) and not the latter because it is a hazzle to remember the correct
> spelling (especially for non-native speakers) and because it is not
> descriptive enough of what the syscall actually does. The name
> "procfd_send_signal" makes it very clear that its job is to send signals.
>
> /* O_PATH file descriptors */
> procfds opened as O_PATH fds cannot be used to send signals to a process
> (cf. [2]). Signaling processes through procfds is the equivalent of writing
> to a file. Thus, this is not an operation that operates "purely at the
> file descriptor level" as required by the open(2) manpage.
>
> /* zombies */
> Zombies can be signaled just as any other process. No special error will be
> reported since a zombie state is an unreliable state (cf. [3]).
>
> /* cross-namespace signals */
> The patch currently enforces that the signaler and signalee either are in
> the same pid namespace or that the signaler's pid namespace is an ancestor
> of the signalee's pid namespace. This is done for the sake of simplicity
> and because it is unclear to what values certain members of struct
> siginfo_t would need to be set to (cf. [5], [6]).
>
> /* compat syscalls */
> It became clear that we would like to avoid adding compat syscalls (cf.
> [7]). The compat syscall handling is now done in kernel/signal.c itself by
> adding __copy_siginfo_from_user_generic() which lets us avoid compat
> syscalls (cf. [8]).
> With upcoming rework for syscall handling things might improve even further
> (cf. [11]).
> This patch was tested on x64 and x86.
>
> /* userspace usage */
> An asciinema recording for the basic functionality can be found under [9].
> With this patch a process can be killed via:
>
>  #define _GNU_SOURCE
>  #include <errno.h>
>  #include <fcntl.h>
>  #include <signal.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
>  #include <sys/stat.h>
>  #include <sys/syscall.h>
>  #include <sys/types.h>
>  #include <unistd.h>
>
>  static inline int do_procfd_send_signal(int procfd, int sig, siginfo_t *info,
>                                          unsigned int flags)
>  {
>  #ifdef __NR_procfd_send_signal
>          return syscall(__NR_procfd_send_signal, procfd, sig, info, flags);
>  #else
>          return -ENOSYS;
>  #endif
>  }
>
>  int main(int argc, char *argv[])
>  {
>          int fd, ret, saved_errno, sig;
>
>          if (argc < 3)
>                  exit(EXIT_FAILURE);
>
>          fd = open(argv[1], O_DIRECTORY | O_CLOEXEC);
>          if (fd < 0) {
>                  printf("%s - Failed to open \"%s\"\n", strerror(errno), argv[1]);
>                  exit(EXIT_FAILURE);
>          }
>
>          sig = atoi(argv[2]);
>
>          printf("Sending signal %d to process %s\n", sig, argv[1]);
>          ret = do_procfd_send_signal(fd, sig, NULL, 0);
>
>          saved_errno = errno;
>          close(fd);
>          errno = saved_errno;
>
>          if (ret < 0) {
>                  printf("%s - Failed to send signal %d to process %s\n",
>                         strerror(errno), sig, argv[1]);
>                  exit(EXIT_FAILURE);
>          }
>
>          exit(EXIT_SUCCESS);
>  }
>
> [1]:  https://lkml.org/lkml/2018/11/18/130
> [2]:  https://lore.kernel.org/lkml/874lbtjvtd.fsf@oldenburg2.str.redhat.com/
> [3]:  https://lore.kernel.org/lkml/20181204132604.aspfupwjgjx6fhva@brauner.io/
> [4]:  https://lore.kernel.org/lkml/20181203180224.fkvw4kajtbvru2ku@brauner.io/
> [5]:  https://lore.kernel.org/lkml/20181121213946.GA10795@mail.hallyn.com/
> [6]:  https://lore.kernel.org/lkml/20181120103111.etlqp7zop34v6nv4@brauner.io/
> [7]:  https://lore.kernel.org/lkml/36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net/
> [8]:  https://lore.kernel.org/lkml/87tvjxp8pc.fsf@xmission.com/
> [9]:  https://asciinema.org/a/X1J8eGhe3vCfBE2b9TXtTaSJ7
> [10]: https://lore.kernel.org/lkml/20181203180224.fkvw4kajtbvru2ku@brauner.io/
> [11]: https://lore.kernel.org/lkml/F53D6D38-3521-4C20-9034-5AF447DF62FF@amacapital.net/
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge Hallyn <serge@hallyn.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Andy Lutomirsky <luto@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Florian Weimer <fweimer@redhat.com>
> Signed-off-by: Christian Brauner <christian@brauner.io>
> ---
> Changelog:
> v3:
> - add __copy_siginfo_from_user_generic() to avoid adding compat syscalls
> - s/procfd_signal/procfd_send_signal/g
> - change type of flags argument from int to unsigned int
> - add comment about what happens to zombies
> - add proc_is_tid_procfd()
> - return EOPNOTSUPP when /proc/<pid>/task/<tid> fd is passed so userspace
>   has a way of knowing that tidfds are not supported currently.
> v2:
> - define __NR_procfd_signal in unistd.h
> - wire up compat syscall
> - s/proc_is_procfd/proc_is_tgid_procfd/g
> - provide stubs when CONFIG_PROC_FS=n
> - move proc_pid() to linux/proc_fs.h header
> - use proc_pid() to grab struct pid from /proc/<pid> fd
> v1:
> - patch introduced
> ---
>  arch/x86/entry/syscalls/syscall_32.tbl |   1 +
>  arch/x86/entry/syscalls/syscall_64.tbl |   1 +
>  fs/proc/base.c                         |  17 +++-
>  fs/proc/internal.h                     |   5 -
>  include/linux/proc_fs.h                |  18 ++++
>  include/linux/syscalls.h               |   3 +
>  include/uapi/asm-generic/unistd.h      |   4 +-
>  kernel/signal.c                        | 127 +++++++++++++++++++++++--
>  8 files changed, 163 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
> index 3cf7b533b3d1..9ab0477d6dc3 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> @@ -398,3 +398,4 @@
>  384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
>  385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevents
>  386	i386	rseq			sys_rseq			__ia32_sys_rseq
> +387	i386	procfd_send_signal	sys_procfd_send_signal		__ia32_sys_procfd_send_signal
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
> index f0b1709a5ffb..6d22b1130ed0 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -343,6 +343,7 @@
>  332	common	statx			__x64_sys_statx
>  333	common	io_pgetevents		__x64_sys_io_pgetevents
>  334	common	rseq			__x64_sys_rseq
> +335	common	procfd_send_signal	__x64_sys_procfd_send_signal
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index ce3465479447..906647d51f6d 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -716,7 +716,10 @@ static int proc_pid_permission(struct inode *inode, int mask)
>  	return generic_permission(inode, mask);
>  }
>  
> -
> +struct pid *proc_pid(const struct inode *inode)
> +{
> +	return PROC_I(inode)->pid;
> +}
>  
>  static const struct inode_operations proc_def_inode_operations = {
>  	.setattr	= proc_setattr,
> @@ -3038,6 +3041,12 @@ static const struct file_operations proc_tgid_base_operations = {
>  	.llseek		= generic_file_llseek,
>  };
>  
> +bool proc_is_tgid_procfd(const struct file *file)
> +{
> +	return d_is_dir(file->f_path.dentry) &&
> +	       (file->f_op == &proc_tgid_base_operations);
> +}
> +
>  static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
>  {
>  	return proc_pident_lookup(dir, dentry,
> @@ -3422,6 +3431,12 @@ static const struct file_operations proc_tid_base_operations = {
>  	.llseek		= generic_file_llseek,
>  };
>  
> +bool proc_is_tid_procfd(const struct file *file)
> +{
> +	return d_is_dir(file->f_path.dentry) &&
> +	       (file->f_op == &proc_tid_base_operations);
> +}
> +
>  static const struct inode_operations proc_tid_base_inode_operations = {
>  	.lookup		= proc_tid_base_lookup,
>  	.getattr	= pid_getattr,
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 5185d7f6a51e..eb69afba83f3 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -113,11 +113,6 @@ static inline void *__PDE_DATA(const struct inode *inode)
>  	return PDE(inode)->data;
>  }
>  
> -static inline struct pid *proc_pid(const struct inode *inode)
> -{
> -	return PROC_I(inode)->pid;
> -}
> -
>  static inline struct task_struct *get_proc_task(const struct inode *inode)
>  {
>  	return get_pid_task(proc_pid(inode), PIDTYPE_PID);
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index d0e1f1522a78..ebc0e0ca5256 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -73,6 +73,9 @@ struct proc_dir_entry *proc_create_net_single_write(const char *name, umode_t mo
>  						    int (*show)(struct seq_file *, void *),
>  						    proc_write_t write,
>  						    void *data);
> +extern bool proc_is_tgid_procfd(const struct file *file);
> +extern bool proc_is_tid_procfd(const struct file *file);
> +extern struct pid *proc_pid(const struct inode *inode);
>  
>  #else /* CONFIG_PROC_FS */
>  
> @@ -114,6 +117,21 @@ static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *p
>  #define proc_create_net(name, mode, parent, state_size, ops) ({NULL;})
>  #define proc_create_net_single(name, mode, parent, show, data) ({NULL;})
>  
> +static inline bool proc_is_tgid_procfd(const struct file *file)
> +{
> +	return false;
> +}
> +
> +static inline bool proc_is_tid_procfd(const struct file *file)
> +{
> +	return false;
> +}
> +
> +static inline struct pid *proc_pid(const struct inode *inode)
> +{
> +	return NULL;
> +}
> +
>  #endif /* CONFIG_PROC_FS */
>  
>  struct net;
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 2ac3d13a915b..b3a02c6780d0 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -907,6 +907,9 @@ asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
>  			  unsigned mask, struct statx __user *buffer);
>  asmlinkage long sys_rseq(struct rseq __user *rseq, uint32_t rseq_len,
>  			 int flags, uint32_t sig);
> +asmlinkage long sys_procfd_send_signal(int procfd, int sig,
> +				       siginfo_t __user *info,
> +				       unsigned int flags);
>  
>  /*
>   * Architecture-specific system calls
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index 538546edbfbd..b409ee26f8e9 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -738,9 +738,11 @@ __SYSCALL(__NR_statx,     sys_statx)
>  __SC_COMP(__NR_io_pgetevents, sys_io_pgetevents, compat_sys_io_pgetevents)
>  #define __NR_rseq 293
>  __SYSCALL(__NR_rseq, sys_rseq)
> +#define __NR_procfd_send_signal 294
> +__SYSCALL(__NR_procfd_send_signal, sys_procfd_send_signal)
>  
>  #undef __NR_syscalls
> -#define __NR_syscalls 294
> +#define __NR_syscalls 295
>  
>  /*
>   * 32 bit systems traditionally used different
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 9a32bc2088c9..79a7e0396b0f 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -19,7 +19,9 @@
>  #include <linux/sched/task.h>
>  #include <linux/sched/task_stack.h>
>  #include <linux/sched/cputime.h>
> +#include <linux/file.h>
>  #include <linux/fs.h>
> +#include <linux/proc_fs.h>
>  #include <linux/tty.h>
>  #include <linux/binfmts.h>
>  #include <linux/coredump.h>
> @@ -3286,6 +3288,16 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
>  }
>  #endif
>  
> +static inline void prepare_kill_siginfo(int sig, struct kernel_siginfo *info)
> +{
> +	clear_siginfo(info);
> +	info->si_signo = sig;
> +	info->si_errno = 0;
> +	info->si_code = SI_USER;
> +	info->si_pid = task_tgid_vnr(current);
> +	info->si_uid = from_kuid_munged(current_user_ns(), current_uid());
> +}
> +
>  /**
>   *  sys_kill - send a signal to a process
>   *  @pid: the PID of the process
> @@ -3295,16 +3307,119 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
>  {
>  	struct kernel_siginfo info;
>  
> -	clear_siginfo(&info);
> -	info.si_signo = sig;
> -	info.si_errno = 0;
> -	info.si_code = SI_USER;
> -	info.si_pid = task_tgid_vnr(current);
> -	info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
> +	prepare_kill_siginfo(sig, &info);
>  
>  	return kill_something_info(sig, &info, pid);
>  }
>  
> +/*
> + * Verify that the signaler and signalee either are in the same pid namespace
> + * or that the signaler's pid namespace is an ancestor of the signalee's pid
> + * namespace.
> + */
> +static bool may_signal_procfd(struct pid *pid)
> +{
> +	struct pid_namespace *active = task_active_pid_ns(current);
> +	struct pid_namespace *p = ns_of_pid(pid);
> +
> +	for (;;) {
> +		if (!p)
> +			return false;
> +		if (p == active)
> +			break;
> +		p = p->parent;
> +	}
> +
> +	return true;
> +}
> +
> +static int __copy_siginfo_from_user_generic(int signo, kernel_siginfo_t *kinfo,
> +					    siginfo_t *info)
Ugh.  _generic is a poor fit here.  In the kernel _generic tends to be
for the default helper function for a set of operations.

A suffix like _any or anything that implemies you can be a compat or not
a compat syscall would be better.

> +{
> +#ifdef CONFIG_COMPAT
> +	/*
> +	 * Avoid hooking up compat syscalls and instead handle necessary
> +	 * conversions here.
> +	 */
> +	if (in_compat_syscall())
> +		return __copy_siginfo_from_user32(
> +			signo, kinfo, (struct compat_siginfo __user *)info);
> +#endif
> +	return __copy_siginfo_from_user(signo, kinfo, info);
> +}

Let me be very clear.  __copy_siginfo_from_user exists because of a bug
in the original implementation of rt_sigqueueinfo.  It should not gain
any new callers.  It only exists because there is userspace that is
confirmed to care.

If you must take a separate signal parameter please verify
"signo == si_signo" and fail if they do not match.

> +/**
> + *  sys_procfd_send_signal - send a signal to a process through a process file
> + *                           descriptor
> + *  @procfd: the file descriptor of the process

There is a subtle naming and semantic issue here that needs to be
addressed.
- Are you only going to support processes?
  If so procfd is fine, otherwise another name needs to be chosen.

- Do you want to embed what will get signaled into the file descriptor?

- Are you about pids?  In which case a pid type needs to be added to the
  parameters so you can send to sessions, pgrps, processes, and threads.

This is important to get right so that people can know how to use this
system call.


> + *  @sig:    signal to be sent
> + *  @info:   the signal info
> + *  @flags:  future flags to be passed
> + *
> + *  Return: 0 on success, negative errno on failure
> + */
> +SYSCALL_DEFINE4(procfd_send_signal, int, procfd, int, sig,
> +		siginfo_t __user *, info, unsigned int, flags)
> +{
> +	int ret;
> +	struct fd f;
> +	struct pid *pid;
> +	kernel_siginfo_t kinfo;
> +
> +	/* Enforce flags be set to 0 until we add an extension. */
> +	if (flags)
> +		return -EINVAL;
> +
> +	f = fdget_raw(procfd);
> +	if (!f.file)
> +		return -EBADF;
> +
> +	/*
> +	 * Give userspace a way to detect whether /proc/<pid>/task/<tid> fds
> +	 * are supported.
> +	 */
> +	ret = -EOPNOTSUPP;
> +	if (proc_is_tid_procfd(f.file))
> +		goto err;

	-EBADF is the proper error code.

> +	/* Is this a procfd? */
> +	ret = -EINVAL;
> +	if (!proc_is_tgid_procfd(f.file))
> +		goto err;

	-EBADF is the proper error code.

> +	/* Without CONFIG_PROC_FS proc_pid() returns NULL. */
> +	pid = proc_pid(file_inode(f.file));
> +	if (!pid)
> +		goto err;

Perhaps you want to fold the proc_pid into the proc_is_tgid_procfd call.

> +	if (!may_signal_procfd(pid))
> +		goto err;
> +
> +	if (info) {
> +		ret = __copy_siginfo_from_user_generic(sig, &kinfo, info);
> +		if (unlikely(ret))
> +			goto err;
> +
> +		/*
> +		 * Not even root can pretend to send signals from the kernel.
> +		 * Nor can they impersonate a kill()/tgkill(), which adds
> +		 * source info.
> +		 */
> +		ret = -EPERM;
> +		if ((kinfo.si_code >= 0 || kinfo.si_code == SI_TKILL) &&
> +		    (task_pid(current) != pid))
> +			goto err;
> +	} else {
> +		prepare_kill_siginfo(sig, &kinfo);
> +	}

I think I would just make the section above say:

	ret = copy_siginfo_from_user_any(
> +
> +	ret = kill_pid_info(sig, &kinfo, pid);
> +
> +err:
> +	fdput(f);
> +	return ret;
> +}
> +
>  static int
>  do_send_specific(pid_t tgid, pid_t pid, int sig, struct kernel_siginfo *info)
>  {
