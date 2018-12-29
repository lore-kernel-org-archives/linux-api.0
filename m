From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v6 1/2] signal: add pidfd_send_signal() syscall
Date: Sat, 29 Dec 2018 23:27:55 +0100
Message-ID: <20181229222756.30027-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, keescook@chromium.org, akpm@linux-foundation.org
Cc: jannh@google.com, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org, ebiederm@xmission.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

The kill() syscall operates on process identifiers (pid). After a process
has exited its pid can be reused by another process. If a caller sends a
signal to a reused pid it will end up signaling the wrong process. This
issue has often surfaced and there has been a push to address this problem [1].

This patch uses file descriptors (fd) from proc/<pid> as stable handles on
struct pid. Even if a pid is recycled the handle will not change. The fd
can be used to send signals to the process it refers to.
Thus, the new syscall pidfd_send_signal() is introduced to solve this
problem. Instead of pids it operates on process fds (pidfd).

/* prototype and argument /*
long pidfd_send_signal(int pidfd, int sig, siginfo_t *info, unsigned int flags);

In addition to the pidfd and signal argument it takes an additional
siginfo_t and flags argument. If the siginfo_t argument is NULL then
pidfd_send_signal() is equivalent to kill(<positive-pid>, <signal>). If it
is not NULL pidfd_send_signal() is equivalent to rt_sigqueueinfo().
The flags argument is added to allow for future extensions of this syscall.
It currently needs to be passed as 0. Failing to do so will cause EINVAL.

/* pidfd_send_signal() replaces multiple pid-based syscalls */
The pidfd_send_signal() syscall currently takes on the job of
rt_sigqueueinfo(2) and parts of the functionality of kill(2), Namely, when a
positive pid is passed to kill(2). It will however be possible to also
replace tgkill(2) and rt_tgsigqueueinfo(2) if this syscall is extended.

/* sending signals to threads (tid) and process groups (pgid) */
Specifically, the pidfd_send_signal() syscall does currently not operate on
process groups or threads. This is left for future extensions.
In order to extend the syscall to allow sending signal to threads and
process groups appropriately named flags (e.g. PIDFD_TYPE_PGID, and
PIDFD_TYPE_TID) should be added. This implies that the flags argument will
determine what is signaled and not the file descriptor itself. Put in other
words, grouping in this api is a property of the flags argument not a
property of the file descriptor (cf. [13]). Clarification for this has been
requested by Eric (cf. [19]).
When appropriate extensions through the flags argument are added then
pidfd_send_signal() can additionally replace the part of kill(2) which
operates on process groups as well as the tgkill(2) and
rt_tgsigqueueinfo(2) syscalls.
How such an extension could be implemented has been very roughly sketched
in [14], [15], and [16]. However, this should not be taken as a commitment
to a particular implementation. There might be better ways to do it.
Right now this is intentionally left out to keep this patchset as simple as
possible (cf. [4]). For example, if a pidfd for a tid from
/proc/<pid>/task/<tid> is passed EOPNOTSUPP will be returned to give
userspace a way to detect when I add support for signaling to threads (cf. [10]).

/* naming */
The syscall had various names throughout iterations of this patchset:
- procfd_signal()
- procfd_send_signal()
- taskfd_send_signal()
In the last round of reviews it was pointed out that given that if the
flags argument decides the scope of the signal instead of different types
of fds it might make sense to either settle for "procfd_" or "pidfd_" as
prefix. The community was willing to accept either (cf. [17] and [18]).
Given that one developer expressed strong preference for the "pidfd_"
prefix (cf. [13] and with other developers less opinionated about the name
we should settle for "pidfd_" to avoid further bikeshedding.

The  "_send_signal" suffix was chosen to reflect the fact that the syscall
takes on the job of multiple syscalls. It is therefore intentional that the
name is not reminiscent of neither kill(2) nor rt_sigqueueinfo(2). Not the
fomer because it might imply that pidfd_send_signal() is a replacement for
kill(2), and not the latter because it is a hassle to remember the correct
spelling - especially for non-native speakers - and because it is not
descriptive enough of what the syscall actually does. The name
"pidfd_send_signal" makes it very clear that its job is to send signals.

/* zombies */
Zombies can be signaled just as any other process. No special error will be
reported since a zombie state is an unreliable state (cf. [3]). However,
this can be added as an extension through the @flags argument if the need
ever arises.

/* cross-namespace signals */
The patch currently enforces that the signaler and signalee either are in
the same pid namespace or that the signaler's pid namespace is an ancestor
of the signalee's pid namespace. This is done for the sake of simplicity
and because it is unclear to what values certain members of struct
siginfo_t would need to be set to (cf. [5], [6]).

/* compat syscalls */
It became clear that we would like to avoid adding compat syscalls
(cf. [7]).  The compat syscall handling is now done in kernel/signal.c
itself by adding __copy_siginfo_from_user_generic() which lets us avoid
compat syscalls (cf. [8]). It should be noted that the addition of
__copy_siginfo_from_user_any() is caused by a bug in the original
implementation of rt_sigqueueinfo(2) (cf. 12).
With upcoming rework for syscall handling things might improve
significantly (cf. [11]) and __copy_siginfo_from_user_any() will not gain
any additional callers.

/* testing */
This patch was tested on x64 and x86.

/* userspace usage */
An asciinema recording for the basic functionality can be found under [9].
With this patch a process can be killed via:

 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
 #include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <sys/stat.h>
 #include <sys/syscall.h>
 #include <sys/types.h>
 #include <unistd.h>

 static inline int do_pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
                                         unsigned int flags)
 {
 #ifdef __NR_pidfd_send_signal
         return syscall(__NR_pidfd_send_signal, pidfd, sig, info, flags);
 #else
         return -ENOSYS;
 #endif
 }

 int main(int argc, char *argv[])
 {
         int fd, ret, saved_errno, sig;

         if (argc < 3)
                 exit(EXIT_FAILURE);

         fd = open(argv[1], O_DIRECTORY | O_CLOEXEC);
         if (fd < 0) {
                 printf("%s - Failed to open \"%s\"\n", strerror(errno), argv[1]);
                 exit(EXIT_FAILURE);
         }

         sig = atoi(argv[2]);

         printf("Sending signal %d to process %s\n", sig, argv[1]);
         ret = do_pidfd_send_signal(fd, sig, NULL, 0);

         saved_errno = errno;
         close(fd);
         errno = saved_errno;

         if (ret < 0) {
                 printf("%s - Failed to send signal %d to process %s\n",
                        strerror(errno), sig, argv[1]);
                 exit(EXIT_FAILURE);
         }

         exit(EXIT_SUCCESS);
 }

/* Q&A
 * Given that it seems the same questions get asked again by people who are
 * late to the party it makes sense to add a Q&A section to the commit
 * message so it's hopefully easier to avoid duplicate threads.
 *
 * For the sake of progress please consider these arguments settled unless
 * there is a new point that desperately needs to be addressed. Please make
 * sure to check the links to the threads in this commit message whether
 * this has not already been covered.
 */
Q-01: (Florian Weimer [20], Andrew Morton [21])
      What happens when the target process has exited?
A-01: Sending the signal will fail with ESRCH (cf. [22]).

Q-02:  (Andrew Morton [21])
       Is the task_struct pinned by the fd?
A-02:  No. A reference to struct pid is kept. struct pid - as far as I
       understand - was created exactly for the reason to not require to
       pin struct task_struct (cf. [22]).

Q-03: (Andrew Morton [21])
      Does the entire procfs directory remain visible? Just one entry
      within it?
A-03: The same thing that happens right now when you hold a file descriptor
      to /proc/<pid> open (cf. [22]).

Q-04: (Andrew Morton [21])
      Does the pid remain reserved?
A-04: No. This patchset guarantees a stable handle not that pids are not
      recycled (cf. [22]).

Q-05: (Andrew Morton [21])
      Do attempts to signal that fd return errors?
A-05: See {Q,A}-01.

Q-06: (Andrew Morton [22])
      Is there a cleaner way of obtaining the fd? Another syscall perhaps.
A-06: Userspace can already trivially retrieve file descriptors from procfs
      so this is something that we will need to support anyway. Hence,
      there's no immediate need to add another syscalls just to make
      pidfd_send_signal() not dependent on the presence of procfs. However,
      adding a syscalls to get such file descriptors is planned for a
      future patchset (cf. [22]).

Q-07: (Andrew Morton [21] and others)
      This fd-for-a-process sounds like a handy thing and people may well
      think up other uses for it in the future, probably unrelated to
      signals. Are the code and the interface designed to permit such
      future applications?
A-07: Yes (cf. [22]).

Q-08: (Andrew Morton [21] and others)
      Now I think about it, why a new syscall? This thing is looking
      rather like an ioctl?
A-08: This has been extensively discussed. It was agreed that a syscall is
      preferred for a variety or reasons. Here are just a few taken from
      prior threads. Syscalls are safer than ioctl()s especially when
      signaling to fds. Processes are a core kernel concept so a syscall
      seems more appropriate. The layout of the syscall with its four
      arguments would require the addition of a custom struct for the
      ioctl() thereby causing at least the same amount or even more
      complexity for userspace than a simple syscall. The new syscall will
      replace multiple other pid-based syscalls (see description above).
      The file-descriptors-for-processes concept introduced with this
      syscall will be extended with other syscalls in the future. See also
      [22], [23] and various other threads already linked in here.

Q-09: (Florian Weimer [24])
      What happens if you use the new interface with an O_PATH descriptor?
A-09:
      pidfds opened as O_PATH fds cannot be used to send signals to a
      process (cf. [2]). Signaling processes through pidfds is the
      equivalent of writing to a file. Thus, this is not an operation that
      operates "purely at the file descriptor level" as required by the
      open(2) manpage. See also [4].

/* References */
[1]:  https://lore.kernel.org/lkml/20181029221037.87724-1-dancol@google.com/
[2]:  https://lore.kernel.org/lkml/874lbtjvtd.fsf@oldenburg2.str.redhat.com/
[3]:  https://lore.kernel.org/lkml/20181204132604.aspfupwjgjx6fhva@brauner.io/
[4]:  https://lore.kernel.org/lkml/20181203180224.fkvw4kajtbvru2ku@brauner.io/
[5]:  https://lore.kernel.org/lkml/20181121213946.GA10795@mail.hallyn.com/
[6]:  https://lore.kernel.org/lkml/20181120103111.etlqp7zop34v6nv4@brauner.io/
[7]:  https://lore.kernel.org/lkml/36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net/
[8]:  https://lore.kernel.org/lkml/87tvjxp8pc.fsf@xmission.com/
[9]:  https://asciinema.org/a/IQjuCHew6bnq1cr78yuMv16cy
[10]: https://lore.kernel.org/lkml/20181203180224.fkvw4kajtbvru2ku@brauner.io/
[11]: https://lore.kernel.org/lkml/F53D6D38-3521-4C20-9034-5AF447DF62FF@amacapital.net/
[12]: https://lore.kernel.org/lkml/87zhtjn8ck.fsf@xmission.com/
[13]: https://lore.kernel.org/lkml/871s6u9z6u.fsf@xmission.com/
[14]: https://lore.kernel.org/lkml/20181206231742.xxi4ghn24z4h2qki@brauner.io/
[15]: https://lore.kernel.org/lkml/20181207003124.GA11160@mail.hallyn.com/
[16]: https://lore.kernel.org/lkml/20181207015423.4miorx43l3qhppfz@brauner.io/
[17]: https://lore.kernel.org/lkml/CAGXu5jL8PciZAXvOvCeCU3wKUEB_dU-O3q0tDw4uB_ojMvDEew@mail.gmail.com/
[18]: https://lore.kernel.org/lkml/20181206222746.GB9224@mail.hallyn.com/
[19]: https://lore.kernel.org/lkml/20181208054059.19813-1-christian@brauner.io/
[20]: https://lore.kernel.org/lkml/8736rebl9s.fsf@oldenburg.str.redhat.com/
[21]: https://lore.kernel.org/lkml/20181228152012.dbf0508c2508138efc5f2bbe@linux-foundation.org/
[22]: https://lore.kernel.org/lkml/20181228233725.722tdfgijxcssg76@brauner.io/
[23]: https://lwn.net/Articles/773459/
[24]: https://lore.kernel.org/lkml/8736rebl9s.fsf@oldenburg.str.redhat.com/

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jann Horn <jannh@google.com>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Christian Brauner <christian@brauner.io>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Aleksa Sarai <cyphar@cyphar.com>
---
/* Changelog */
v6:
- Given that it seems the same questions get asked multiple times it made
  sense to add a Q&A section to the commit message so it's hopefully easier
  to avoid duplicate threads.
- Since we settled on adding flags when extending the syscalls to allow
  signaling to threads and process groups it doesn't make sense anymore to
  report EOPNOTSUPP when a file descriptor to /proc/<pid>/task/<tid> is
  passed. This means we can also remove the tgid_pidfd_to_pid() helper from
  proc_fs.h and simplify the code. We will now always return EBADF when a
  file descriptor is passed that does not refer to /proc/<pid>.
- add CONFIG_PROC_FS ifdefs for pidfd_send_signal() and add
  COND_SYSCALL(pidfd_send_signal) definition as suggested by Andrew Morgan
  in [changelog-1].
v5:
- s/may_signal_taskfd/access_taskfd_pidns/g
- make it clear that process grouping is a property of the @flags argument
  Eric has argued that he would like to know when we add thread and process
  group signal support whether grouping will be a property of the file
  descriptor or the flag argument and he would oppose this until a
  commitment has been made. It seems that the cleanest strategy is to make
  grouping a property of the @flags argument.
  He also argued that in this case the prefix of the syscall should be
  "pidfd_" (cf. https://lore.kernel.org/lkml/871s6u9z6u.fsf@xmission.com/).
- use "pidfd_" as prefix for the syscall since grouping will be a property
  of the @flags argument
- substantial rewrite of the commit message to reflect the discussion
v4:
- updated asciinema to use "taskfd_" prefix
- s/procfd_send_signal/taskfd_send_signal/g
- s/proc_is_tgid_procfd/tgid_taskfd_to_pid/b
- s/proc_is_tid_procfd/tid_taskfd_to_pid/b
- s/__copy_siginfo_from_user_generic/__copy_siginfo_from_user_any/g
- make it clear that __copy_siginfo_from_user_any() is a workaround caused
  by a bug in the original implementation of rt_sigqueueinfo()
- when spoofing signals turn them into regular kill signals if si_code is
  set to SI_USER
- make proc_is_t{g}id_procfd() return struct pid to allow proc_pid() to
  stay private to fs/proc/
v3:
- add __copy_siginfo_from_user_generic() to avoid adding compat syscalls
- s/procfd_signal/procfd_send_signal/g
- change type of flags argument from int to unsigned int
- add comment about what happens to zombies
- add proc_is_tid_procfd()
- return EOPNOTSUPP when /proc/<pid>/task/<tid> fd is passed so userspace
  has a way of knowing that tidfds are not supported currently.
v2:
- define __NR_procfd_signal in unistd.h
- wire up compat syscall
- s/proc_is_procfd/proc_is_tgid_procfd/g
- provide stubs when CONFIG_PROC_FS=n
- move proc_pid() to linux/proc_fs.h header
- use proc_pid() to grab struct pid from /proc/<pid> fd
v1:
- patch introduced

/* Changelog references */
[changelog-1]: https://lore.kernel.org/lkml/20181228152012.dbf0508c2508138efc5f2bbe@linux-foundation.org/
---
 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 fs/proc/base.c                         |   9 ++
 include/linux/proc_fs.h                |   6 ++
 include/linux/syscalls.h               |   3 +
 include/uapi/asm-generic/unistd.h      |   4 +-
 kernel/signal.c                        | 133 +++++++++++++++++++++++--
 kernel/sys_ni.c                        |   1 +
 8 files changed, 151 insertions(+), 7 deletions(-)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 3cf7b533b3d1..6804c1e84b36 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -398,3 +398,4 @@
 384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
 385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevents
 386	i386	rseq			sys_rseq			__ia32_sys_rseq
+387	i386	pidfd_send_signal	sys_pidfd_send_signal		__ia32_sys_pidfd_send_signal
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index f0b1709a5ffb..aa4b858fa0f1 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -343,6 +343,7 @@
 332	common	statx			__x64_sys_statx
 333	common	io_pgetevents		__x64_sys_io_pgetevents
 334	common	rseq			__x64_sys_rseq
+335	common	pidfd_send_signal	__x64_sys_pidfd_send_signal
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/proc/base.c b/fs/proc/base.c
index ce3465479447..9b812b777faa 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3038,6 +3038,15 @@ static const struct file_operations proc_tgid_base_operations = {
 	.llseek		= generic_file_llseek,
 };
 
+struct pid *tgid_pidfd_to_pid(const struct file *file)
+{
+	if (!d_is_dir(file->f_path.dentry) ||
+	    (file->f_op != &proc_tgid_base_operations))
+		return ERR_PTR(-EBADF);
+
+	return proc_pid(file_inode(file));
+}
+
 static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
 	return proc_pident_lookup(dir, dentry,
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index d0e1f1522a78..52a283ba0465 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -73,6 +73,7 @@ struct proc_dir_entry *proc_create_net_single_write(const char *name, umode_t mo
 						    int (*show)(struct seq_file *, void *),
 						    proc_write_t write,
 						    void *data);
+extern struct pid *tgid_pidfd_to_pid(const struct file *file);
 
 #else /* CONFIG_PROC_FS */
 
@@ -114,6 +115,11 @@ static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *p
 #define proc_create_net(name, mode, parent, state_size, ops) ({NULL;})
 #define proc_create_net_single(name, mode, parent, show, data) ({NULL;})
 
+static inline struct pid *tgid_pidfd_to_pid(const struct file *file)
+{
+	return ERR_PTR(-EBADF);
+}
+
 #endif /* CONFIG_PROC_FS */
 
 struct net;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 2ac3d13a915b..fd85b9045a9f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -907,6 +907,9 @@ asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
 			  unsigned mask, struct statx __user *buffer);
 asmlinkage long sys_rseq(struct rseq __user *rseq, uint32_t rseq_len,
 			 int flags, uint32_t sig);
+asmlinkage long sys_pidfd_send_signal(int pidfd, int sig,
+				       siginfo_t __user *info,
+				       unsigned int flags);
 
 /*
  * Architecture-specific system calls
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index d90127298f12..b77538af7aca 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -740,9 +740,11 @@ __SC_COMP(__NR_io_pgetevents, sys_io_pgetevents, compat_sys_io_pgetevents)
 __SYSCALL(__NR_rseq, sys_rseq)
 #define __NR_kexec_file_load 294
 __SYSCALL(__NR_kexec_file_load,     sys_kexec_file_load)
+#define __NR_pidfd_send_signal 295
+__SYSCALL(__NR_pidfd_send_signal, sys_pidfd_send_signal)
 
 #undef __NR_syscalls
-#define __NR_syscalls 295
+#define __NR_syscalls 296
 
 /*
  * 32 bit systems traditionally used different
diff --git a/kernel/signal.c b/kernel/signal.c
index 9a32bc2088c9..a108368905c7 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -19,7 +19,9 @@
 #include <linux/sched/task.h>
 #include <linux/sched/task_stack.h>
 #include <linux/sched/cputime.h>
+#include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/proc_fs.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
 #include <linux/coredump.h>
@@ -3286,6 +3288,16 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 }
 #endif
 
+static inline void prepare_kill_siginfo(int sig, struct kernel_siginfo *info)
+{
+	clear_siginfo(info);
+	info->si_signo = sig;
+	info->si_errno = 0;
+	info->si_code = SI_USER;
+	info->si_pid = task_tgid_vnr(current);
+	info->si_uid = from_kuid_munged(current_user_ns(), current_uid());
+}
+
 /**
  *  sys_kill - send a signal to a process
  *  @pid: the PID of the process
@@ -3295,16 +3307,125 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
 {
 	struct kernel_siginfo info;
 
-	clear_siginfo(&info);
-	info.si_signo = sig;
-	info.si_errno = 0;
-	info.si_code = SI_USER;
-	info.si_pid = task_tgid_vnr(current);
-	info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
+	prepare_kill_siginfo(sig, &info);
 
 	return kill_something_info(sig, &info, pid);
 }
 
+#ifdef CONFIG_PROC_FS
+/*
+ * Verify that the signaler and signalee either are in the same pid namespace
+ * or that the signaler's pid namespace is an ancestor of the signalee's pid
+ * namespace.
+ */
+static bool access_pidfd_pidns(struct pid *pid)
+{
+	struct pid_namespace *active = task_active_pid_ns(current);
+	struct pid_namespace *p = ns_of_pid(pid);
+
+	for (;;) {
+		if (!p)
+			return false;
+		if (p == active)
+			break;
+		p = p->parent;
+	}
+
+	return true;
+}
+
+static int copy_siginfo_from_user_any(kernel_siginfo_t *kinfo, siginfo_t *info)
+{
+#ifdef CONFIG_COMPAT
+	/*
+	 * Avoid hooking up compat syscalls and instead handle necessary
+	 * conversions here. Note, this is a stop-gap measure and should not be
+	 * considered a generic solution.
+	 */
+	if (in_compat_syscall())
+		return copy_siginfo_from_user32(
+			kinfo, (struct compat_siginfo __user *)info);
+#endif
+	return copy_siginfo_from_user(kinfo, info);
+}
+
+/**
+ * sys_pidfd_send_signal - send a signal to a process through a task file
+ *                          descriptor
+ * @pidfd:  the file descriptor of the process
+ * @sig:    signal to be sent
+ * @info:   the signal info
+ * @flags:  future flags to be passed
+ *
+ * The syscall currently only signals via PIDTYPE_PID which covers
+ * kill(<positive-pid>, <signal>. It does not signal threads or process
+ * groups.
+ * In order to extend the syscall to threads and process groups the @flags
+ * argument should be used. In essence, the @flags argument will determine
+ * what is signaled and not the file descriptor itself. Put in other words,
+ * grouping is a property of the flags argument not a property of the file
+ * descriptor.
+ *
+ * Return: 0 on success, negative errno on failure
+ */
+SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
+		siginfo_t __user *, info, unsigned int, flags)
+{
+	int ret;
+	struct fd f;
+	struct pid *pid;
+	kernel_siginfo_t kinfo;
+
+	/* Enforce flags be set to 0 until we add an extension. */
+	if (flags)
+		return -EINVAL;
+
+	f = fdget_raw(pidfd);
+	if (!f.file)
+		return -EBADF;
+
+	/* Is this a pidfd? */
+	pid = tgid_pidfd_to_pid(f.file);
+	if (IS_ERR(pid)) {
+		ret = PTR_ERR(pid);
+		goto err;
+	}
+
+	ret = -EINVAL;
+	if (!access_pidfd_pidns(pid))
+		goto err;
+
+	if (info) {
+		ret = copy_siginfo_from_user_any(&kinfo, info);
+		if (unlikely(ret))
+			goto err;
+
+		ret = -EINVAL;
+		if (unlikely(sig != kinfo.si_signo))
+			goto err;
+
+		if ((task_pid(current) != pid) &&
+		    (kinfo.si_code >= 0 || kinfo.si_code == SI_TKILL)) {
+			/* Only allow sending arbitrary signals to yourself. */
+			ret = -EPERM;
+			if (kinfo.si_code != SI_USER)
+				goto err;
+
+			/* Turn this into a regular kill signal. */
+			prepare_kill_siginfo(sig, &kinfo);
+		}
+	} else {
+		prepare_kill_siginfo(sig, &kinfo);
+	}
+
+	ret = kill_pid_info(sig, &kinfo, pid);
+
+err:
+	fdput(f);
+	return ret;
+}
+#endif /* CONFIG_PROC_FS */
+
 static int
 do_send_specific(pid_t tgid, pid_t pid, int sig, struct kernel_siginfo *info)
 {
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index df556175be50..e0af0a166bac 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -163,6 +163,7 @@ COND_SYSCALL(syslog);
 /* kernel/sched/core.c */
 
 /* kernel/signal.c */
+COND_SYSCALL(pidfd_send_signal);
 
 /* kernel/sys.c */
 COND_SYSCALL(setregid);
-- 
2.19.1
