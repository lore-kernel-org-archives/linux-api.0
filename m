From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 5/6] signal: Distinguish between kernel_siginfo and siginfo
Date: Tue, 25 Sep 2018 19:19:05 +0200
Message-ID: <20180925171906.19683-5-ebiederm@xmission.com>
References: <87h8idv6nw.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87h8idv6nw.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Linus recently observed that if we did not worry about the padding
member in struct siginfo it is only about 48 bytes, and 48 bytes is
much nicer than 128 bytes for allocating on the stack and copying
around in the kernel.

The obvious thing of only adding the padding when userspace is
including siginfo.h won't work as there are sigframe definitions in
the kernel that embed struct siginfo.

So split siginfo in two; kernel_siginfo and siginfo.  Keeping the
traditional name for the userspace definition.  While the version that
is used internally to the kernel and ultimately will not be padded to
128 bytes is called kernel_siginfo.

The definition of struct kernel_siginfo I have put in include/signal_types.h

A set of buildtime checks has been added to verify the two structures have
the same field offsets.

To make it easy to verify the change kernel_siginfo retains the same
size as siginfo.  The reduction in size comes in a following change.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/include/asm/compat.h |   2 +-
 drivers/usb/core/devio.c      |   4 +-
 fs/binfmt_elf.c               |   6 +-
 fs/coredump.c                 |   2 +-
 fs/fcntl.c                    |   2 +-
 fs/signalfd.c                 |   6 +-
 include/linux/binfmts.h       |   2 +-
 include/linux/compat.h        |   4 +-
 include/linux/coredump.h      |   4 +-
 include/linux/lsm_hooks.h     |   4 +-
 include/linux/posix-timers.h  |   2 +-
 include/linux/ptrace.h        |   2 +-
 include/linux/sched.h         |   2 +-
 include/linux/sched/signal.h  |  18 ++--
 include/linux/security.h      |   6 +-
 include/linux/signal.h        |  15 ++--
 include/linux/signal_types.h  |  11 ++-
 include/trace/events/signal.h |   4 +-
 ipc/mqueue.c                  |   2 +-
 kernel/ptrace.c               |  10 +--
 kernel/seccomp.c              |   6 +-
 kernel/signal.c               | 151 ++++++++++++++++++++++------------
 kernel/time/posix-timers.c    |   2 +-
 security/apparmor/lsm.c       |   2 +-
 security/security.c           |   2 +-
 security/selinux/hooks.c      |   2 +-
 security/smack/smack_lsm.c    |   2 +-
 27 files changed, 165 insertions(+), 110 deletions(-)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index fb97cf7c4137..a0f46bdd9f24 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -240,6 +240,6 @@ static inline bool in_compat_syscall(void)
 
 struct compat_siginfo;
 int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
-		const siginfo_t *from, bool x32_ABI);
+		const kernel_siginfo_t *from, bool x32_ABI);
 
 #endif /* _ASM_X86_COMPAT_H */
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 6ce77b33da61..c260ea8808b0 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -582,7 +582,7 @@ static void async_completed(struct urb *urb)
 {
 	struct async *as = urb->context;
 	struct usb_dev_state *ps = as->ps;
-	struct siginfo sinfo;
+	struct kernel_siginfo sinfo;
 	struct pid *pid = NULL;
 	const struct cred *cred = NULL;
 	unsigned long flags;
@@ -2599,7 +2599,7 @@ const struct file_operations usbdev_file_operations = {
 static void usbdev_remove(struct usb_device *udev)
 {
 	struct usb_dev_state *ps;
-	struct siginfo sinfo;
+	struct kernel_siginfo sinfo;
 
 	while (!list_empty(&udev->filelist)) {
 		ps = list_entry(udev->filelist.next, struct usb_dev_state, list);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index efae2fb0930a..54207327f98f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1580,7 +1580,7 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
 }
 
 static void fill_siginfo_note(struct memelfnote *note, user_siginfo_t *csigdata,
-		const siginfo_t *siginfo)
+		const kernel_siginfo_t *siginfo)
 {
 	mm_segment_t old_fs = get_fs();
 	set_fs(KERNEL_DS);
@@ -1782,7 +1782,7 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  const siginfo_t *siginfo, struct pt_regs *regs)
+			  const kernel_siginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct task_struct *dump_task = current;
 	const struct user_regset_view *view = task_user_regset_view(dump_task);
@@ -2031,7 +2031,7 @@ static int elf_note_info_init(struct elf_note_info *info)
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  const siginfo_t *siginfo, struct pt_regs *regs)
+			  const kernel_siginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct list_head *t;
 	struct core_thread *ct;
diff --git a/fs/coredump.c b/fs/coredump.c
index 1e2c87acac9b..e42e17e55bfd 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -536,7 +536,7 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	return err;
 }
 
-void do_coredump(const siginfo_t *siginfo)
+void do_coredump(const kernel_siginfo_t *siginfo)
 {
 	struct core_state core_state;
 	struct core_name cn;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 4137d96534a6..083185174c6d 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -735,7 +735,7 @@ static void send_sigio_to_task(struct task_struct *p,
 		return;
 
 	switch (signum) {
-		siginfo_t si;
+		kernel_siginfo_t si;
 		default:
 			/* Queue a rt signal with the appropriate fd as its
 			   value.  We use SI_SIGIO as the source, not 
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 4fcd1498acf5..757afc7c5895 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -79,7 +79,7 @@ static __poll_t signalfd_poll(struct file *file, poll_table *wait)
  * Copied from copy_siginfo_to_user() in kernel/signal.c
  */
 static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
-			     siginfo_t const *kinfo)
+			     kernel_siginfo_t const *kinfo)
 {
 	struct signalfd_siginfo new;
 
@@ -163,7 +163,7 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 	return sizeof(*uinfo);
 }
 
-static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
+static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info,
 				int nonblock)
 {
 	ssize_t ret;
@@ -215,7 +215,7 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 	struct signalfd_siginfo __user *siginfo;
 	int nonblock = file->f_flags & O_NONBLOCK;
 	ssize_t ret, total = 0;
-	siginfo_t info;
+	kernel_siginfo_t info;
 
 	count /= sizeof(struct signalfd_siginfo);
 	if (!count)
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index c05f24fac4f6..e9f5fe69df31 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -78,7 +78,7 @@ struct linux_binprm {
 
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
-	const siginfo_t *siginfo;
+	const kernel_siginfo_t *siginfo;
 	struct pt_regs *regs;
 	struct file *file;
 	unsigned long limit;
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 1a3c4f37e908..4565d65b1776 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -452,8 +452,8 @@ long compat_get_bitmap(unsigned long *mask, const compat_ulong_t __user *umask,
 		       unsigned long bitmap_size);
 long compat_put_bitmap(compat_ulong_t __user *umask, unsigned long *mask,
 		       unsigned long bitmap_size);
-int copy_siginfo_from_user32(siginfo_t *to, const struct compat_siginfo __user *from);
-int copy_siginfo_to_user32(struct compat_siginfo __user *to, const siginfo_t *from);
+int copy_siginfo_from_user32(kernel_siginfo_t *to, const struct compat_siginfo __user *from);
+int copy_siginfo_to_user32(struct compat_siginfo __user *to, const kernel_siginfo_t *from);
 int get_compat_sigevent(struct sigevent *event,
 		const struct compat_sigevent __user *u_event);
 
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 207aed96a5b7..abf4b4e65dbb 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -17,9 +17,9 @@ extern int dump_emit(struct coredump_params *cprm, const void *addr, int nr);
 extern int dump_align(struct coredump_params *cprm, int align);
 extern void dump_truncate(struct coredump_params *cprm);
 #ifdef CONFIG_COREDUMP
-extern void do_coredump(const siginfo_t *siginfo);
+extern void do_coredump(const kernel_siginfo_t *siginfo);
 #else
-static inline void do_coredump(const siginfo_t *siginfo) {}
+static inline void do_coredump(const kernel_siginfo_t *siginfo) {}
 #endif
 
 #endif /* _LINUX_COREDUMP_H */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 97a020c616ad..bb40f6d34163 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -672,7 +672,7 @@
  *	Return 0 if permission is granted.
  * @task_kill:
  *	Check permission before sending signal @sig to @p.  @info can be NULL,
- *	the constant 1, or a pointer to a siginfo structure.  If @info is 1 or
+ *	the constant 1, or a pointer to a kernel_siginfo structure.  If @info is 1 or
  *	SI_FROMKERNEL(info) is true, then the signal should be viewed as coming
  *	from the kernel and should typically be permitted.
  *	SIGIO signals are handled separately by the send_sigiotask hook in
@@ -1606,7 +1606,7 @@ union security_list_options {
 	int (*task_setscheduler)(struct task_struct *p);
 	int (*task_getscheduler)(struct task_struct *p);
 	int (*task_movememory)(struct task_struct *p);
-	int (*task_kill)(struct task_struct *p, struct siginfo *info,
+	int (*task_kill)(struct task_struct *p, struct kernel_siginfo *info,
 				int sig, const struct cred *cred);
 	int (*task_prctl)(int option, unsigned long arg2, unsigned long arg3,
 				unsigned long arg4, unsigned long arg5);
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index ee7e987ea1b4..e96581ca7c9d 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -126,5 +126,5 @@ void set_process_cpu_timer(struct task_struct *task, unsigned int clock_idx,
 
 void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new);
 
-void posixtimer_rearm(struct siginfo *info);
+void posixtimer_rearm(struct kernel_siginfo *info);
 #endif
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 1de2235511c8..d19a795100da 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -341,7 +341,7 @@ extern void user_single_step_report(struct pt_regs *regs);
 #else
 static inline void user_single_step_report(struct pt_regs *regs)
 {
-	siginfo_t info;
+	kernel_siginfo_t info;
 	clear_siginfo(&info);
 	info.si_signo = SIGTRAP;
 	info.si_errno = 0;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 977cb57d7bc9..2ba88082e1ef 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -960,7 +960,7 @@ struct task_struct {
 
 	/* Ptrace state: */
 	unsigned long			ptrace_message;
-	siginfo_t			*last_siginfo;
+	kernel_siginfo_t		*last_siginfo;
 
 	struct task_io_accounting	ioac;
 #ifdef CONFIG_TASK_XACCT
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 9e07f3521549..13789d10a50e 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -270,12 +270,12 @@ static inline int signal_group_exit(const struct signal_struct *sig)
 extern void flush_signals(struct task_struct *);
 extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
-extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
+extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, kernel_siginfo_t *info);
 
 static inline int kernel_dequeue_signal(void)
 {
 	struct task_struct *tsk = current;
-	siginfo_t __info;
+	kernel_siginfo_t __info;
 	int ret;
 
 	spin_lock_irq(&tsk->sighand->siglock);
@@ -322,12 +322,12 @@ int force_sig_pkuerr(void __user *addr, u32 pkey);
 
 int force_sig_ptrace_errno_trap(int errno, void __user *addr);
 
-extern int send_sig_info(int, struct siginfo *, struct task_struct *);
+extern int send_sig_info(int, struct kernel_siginfo *, struct task_struct *);
 extern void force_sigsegv(int sig, struct task_struct *p);
-extern int force_sig_info(int, struct siginfo *, struct task_struct *);
-extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
-extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
-extern int kill_pid_info_as_cred(int, struct siginfo *, struct pid *,
+extern int force_sig_info(int, struct kernel_siginfo *, struct task_struct *);
+extern int __kill_pgrp_info(int sig, struct kernel_siginfo *info, struct pid *pgrp);
+extern int kill_pid_info(int sig, struct kernel_siginfo *info, struct pid *pid);
+extern int kill_pid_info_as_cred(int, struct kernel_siginfo *, struct pid *,
 				const struct cred *);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
@@ -475,8 +475,8 @@ static inline int kill_cad_pid(int sig, int priv)
 }
 
 /* These can be the second arg to send_sig_info/send_group_sig_info.  */
-#define SEND_SIG_NOINFO ((struct siginfo *) 0)
-#define SEND_SIG_PRIV	((struct siginfo *) 1)
+#define SEND_SIG_NOINFO ((struct kernel_siginfo *) 0)
+#define SEND_SIG_PRIV	((struct kernel_siginfo *) 1)
 
 /*
  * True if we are on the alternate signal stack.
diff --git a/include/linux/security.h b/include/linux/security.h
index 75f4156c84d7..d170a5b031f3 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -35,7 +35,7 @@
 struct linux_binprm;
 struct cred;
 struct rlimit;
-struct siginfo;
+struct kernel_siginfo;
 struct sembuf;
 struct kern_ipc_perm;
 struct audit_context;
@@ -361,7 +361,7 @@ int security_task_setrlimit(struct task_struct *p, unsigned int resource,
 int security_task_setscheduler(struct task_struct *p);
 int security_task_getscheduler(struct task_struct *p);
 int security_task_movememory(struct task_struct *p);
-int security_task_kill(struct task_struct *p, struct siginfo *info,
+int security_task_kill(struct task_struct *p, struct kernel_siginfo *info,
 			int sig, const struct cred *cred);
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
@@ -1020,7 +1020,7 @@ static inline int security_task_movememory(struct task_struct *p)
 }
 
 static inline int security_task_kill(struct task_struct *p,
-				     struct siginfo *info, int sig,
+				     struct kernel_siginfo *info, int sig,
 				     const struct cred *cred)
 {
 	return 0;
diff --git a/include/linux/signal.h b/include/linux/signal.h
index de94c159bfb0..70031b10b918 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -11,18 +11,19 @@ struct task_struct;
 /* for sysctl */
 extern int print_fatal_signals;
 
-static inline void copy_siginfo(struct siginfo *to, const struct siginfo *from)
+static inline void copy_siginfo(kernel_siginfo_t *to,
+				const kernel_siginfo_t *from)
 {
 	memcpy(to, from, sizeof(*to));
 }
 
-static inline void clear_siginfo(struct siginfo *info)
+static inline void clear_siginfo(kernel_siginfo_t *info)
 {
 	memset(info, 0, sizeof(*info));
 }
 
-int copy_siginfo_to_user(struct siginfo __user *to, const struct siginfo *from);
-int copy_siginfo_from_user(struct siginfo *to, const struct siginfo __user *from);
+int copy_siginfo_to_user(siginfo_t __user *to, const kernel_siginfo_t *from);
+int copy_siginfo_from_user(kernel_siginfo_t *to, const siginfo_t __user *from);
 
 enum siginfo_layout {
 	SIL_KILL,
@@ -258,11 +259,11 @@ struct pt_regs;
 enum pid_type;
 
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
-extern int do_send_sig_info(int sig, struct siginfo *info,
+extern int do_send_sig_info(int sig, struct kernel_siginfo *info,
 				struct task_struct *p, enum pid_type type);
-extern int group_send_sig_info(int sig, struct siginfo *info,
+extern int group_send_sig_info(int sig, struct kernel_siginfo *info,
 			       struct task_struct *p, enum pid_type type);
-extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
+extern int __group_send_sig_info(int, struct kernel_siginfo *, struct task_struct *);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
diff --git a/include/linux/signal_types.h b/include/linux/signal_types.h
index 222ae696000b..2a40a9c5e4ad 100644
--- a/include/linux/signal_types.h
+++ b/include/linux/signal_types.h
@@ -9,6 +9,13 @@
 #include <linux/list.h>
 #include <uapi/linux/signal.h>
 
+typedef struct kernel_siginfo {
+	union {
+		__SIGINFO;
+		int _si_pad[SI_MAX_SIZE/sizeof(int)];
+	};
+} kernel_siginfo_t;
+
 /*
  * Real Time signals may be queued.
  */
@@ -16,7 +23,7 @@
 struct sigqueue {
 	struct list_head list;
 	int flags;
-	siginfo_t info;
+	kernel_siginfo_t info;
 	struct user_struct *user;
 };
 
@@ -60,7 +67,7 @@ struct old_sigaction {
 
 struct ksignal {
 	struct k_sigaction ka;
-	siginfo_t info;
+	kernel_siginfo_t info;
 	int sig;
 };
 
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 3deeed50ffd0..1db7e4b07c01 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -49,7 +49,7 @@ enum {
  */
 TRACE_EVENT(signal_generate,
 
-	TP_PROTO(int sig, struct siginfo *info, struct task_struct *task,
+	TP_PROTO(int sig, struct kernel_siginfo *info, struct task_struct *task,
 			int group, int result),
 
 	TP_ARGS(sig, info, task, group, result),
@@ -95,7 +95,7 @@ TRACE_EVENT(signal_generate,
  */
 TRACE_EVENT(signal_deliver,
 
-	TP_PROTO(int sig, struct siginfo *info, struct k_sigaction *ka),
+	TP_PROTO(int sig, struct kernel_siginfo *info, struct k_sigaction *ka),
 
 	TP_ARGS(sig, info, ka),
 
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c0d58f390c3b..cc41de3b8deb 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -655,7 +655,7 @@ static void __do_notify(struct mqueue_inode_info *info)
 	 * synchronously. */
 	if (info->notify_owner &&
 	    info->attr.mq_curmsgs == 1) {
-		struct siginfo sig_i;
+		struct kernel_siginfo sig_i;
 		switch (info->notify.sigev_notify) {
 		case SIGEV_NONE:
 			break;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index a807ff5cc1a9..c2cee9db5204 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -651,7 +651,7 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 	return 0;
 }
 
-static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
+static int ptrace_getsiginfo(struct task_struct *child, kernel_siginfo_t *info)
 {
 	unsigned long flags;
 	int error = -ESRCH;
@@ -667,7 +667,7 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 	return error;
 }
 
-static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
+static int ptrace_setsiginfo(struct task_struct *child, const kernel_siginfo_t *info)
 {
 	unsigned long flags;
 	int error = -ESRCH;
@@ -709,7 +709,7 @@ static int ptrace_peek_siginfo(struct task_struct *child,
 		pending = &child->pending;
 
 	for (i = 0; i < arg.nr; ) {
-		siginfo_t info;
+		kernel_siginfo_t info;
 		s32 off = arg.off + i;
 
 		spin_lock_irq(&child->sighand->siglock);
@@ -885,7 +885,7 @@ int ptrace_request(struct task_struct *child, long request,
 {
 	bool seized = child->ptrace & PT_SEIZED;
 	int ret = -EIO;
-	siginfo_t siginfo, *si;
+	kernel_siginfo_t siginfo, *si;
 	void __user *datavp = (void __user *) data;
 	unsigned long __user *datalp = datavp;
 	unsigned long flags;
@@ -1180,7 +1180,7 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 {
 	compat_ulong_t __user *datap = compat_ptr(data);
 	compat_ulong_t word;
-	siginfo_t siginfo;
+	kernel_siginfo_t siginfo;
 	int ret;
 
 	switch (request) {
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index fd023ac24e10..4d7809cdd27d 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -522,7 +522,7 @@ void put_seccomp_filter(struct task_struct *tsk)
 	__put_seccomp_filter(tsk->seccomp.filter);
 }
 
-static void seccomp_init_siginfo(siginfo_t *info, int syscall, int reason)
+static void seccomp_init_siginfo(kernel_siginfo_t *info, int syscall, int reason)
 {
 	clear_siginfo(info);
 	info->si_signo = SIGSYS;
@@ -542,7 +542,7 @@ static void seccomp_init_siginfo(siginfo_t *info, int syscall, int reason)
  */
 static void seccomp_send_sigsys(int syscall, int reason)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 	seccomp_init_siginfo(&info, syscall, reason);
 	force_sig_info(SIGSYS, &info, current);
 }
@@ -747,7 +747,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 		/* Dump core only if this is the last remaining thread. */
 		if (action == SECCOMP_RET_KILL_PROCESS ||
 		    get_nr_threads(current) == 1) {
-			siginfo_t info;
+			kernel_siginfo_t info;
 
 			/* Show the original registers in the dump. */
 			syscall_rollback(current, task_pt_regs(current));
diff --git a/kernel/signal.c b/kernel/signal.c
index c0e289e62d77..161cad4e448c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -549,7 +549,7 @@ bool unhandled_signal(struct task_struct *tsk, int sig)
 	return !tsk->ptrace;
 }
 
-static void collect_signal(int sig, struct sigpending *list, siginfo_t *info,
+static void collect_signal(int sig, struct sigpending *list, kernel_siginfo_t *info,
 			   bool *resched_timer)
 {
 	struct sigqueue *q, *first = NULL;
@@ -595,7 +595,7 @@ static void collect_signal(int sig, struct sigpending *list, siginfo_t *info,
 }
 
 static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
-			siginfo_t *info, bool *resched_timer)
+			kernel_siginfo_t *info, bool *resched_timer)
 {
 	int sig = next_signal(pending, mask);
 
@@ -610,7 +610,7 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
  *
  * All callers have to hold the siglock.
  */
-int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+int dequeue_signal(struct task_struct *tsk, sigset_t *mask, kernel_siginfo_t *info)
 {
 	bool resched_timer = false;
 	int signr;
@@ -737,12 +737,12 @@ static void flush_sigqueue_mask(sigset_t *mask, struct sigpending *s)
 	}
 }
 
-static inline int is_si_special(const struct siginfo *info)
+static inline int is_si_special(const struct kernel_siginfo *info)
 {
 	return info <= SEND_SIG_PRIV;
 }
 
-static inline bool si_fromuser(const struct siginfo *info)
+static inline bool si_fromuser(const struct kernel_siginfo *info)
 {
 	return info == SEND_SIG_NOINFO ||
 		(!is_si_special(info) && SI_FROMUSER(info));
@@ -767,7 +767,7 @@ static bool kill_ok_by_cred(struct task_struct *t)
  * Bad permissions for sending the signal
  * - the caller must hold the RCU read lock
  */
-static int check_kill_permission(int sig, struct siginfo *info,
+static int check_kill_permission(int sig, struct kernel_siginfo *info,
 				 struct task_struct *t)
 {
 	struct pid *sid;
@@ -1010,7 +1010,7 @@ static inline bool legacy_queue(struct sigpending *signals, int sig)
 }
 
 #ifdef CONFIG_USER_NS
-static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_struct *t)
+static inline void userns_fixup_signal_uid(struct kernel_siginfo *info, struct task_struct *t)
 {
 	if (current_user_ns() == task_cred_xxx(t, user_ns))
 		return;
@@ -1024,13 +1024,13 @@ static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_str
 	rcu_read_unlock();
 }
 #else
-static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_struct *t)
+static inline void userns_fixup_signal_uid(struct kernel_siginfo *info, struct task_struct *t)
 {
 	return;
 }
 #endif
 
-static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
+static int __send_signal(int sig, struct kernel_siginfo *info, struct task_struct *t,
 			enum pid_type type, int from_ancestor_ns)
 {
 	struct sigpending *pending;
@@ -1150,7 +1150,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	return ret;
 }
 
-static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
+static int send_signal(int sig, struct kernel_siginfo *info, struct task_struct *t,
 			enum pid_type type)
 {
 	int from_ancestor_ns = 0;
@@ -1197,12 +1197,12 @@ static int __init setup_print_fatal_signals(char *str)
 __setup("print-fatal-signals=", setup_print_fatal_signals);
 
 int
-__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
+__group_send_sig_info(int sig, struct kernel_siginfo *info, struct task_struct *p)
 {
 	return send_signal(sig, info, p, PIDTYPE_TGID);
 }
 
-int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
+int do_send_sig_info(int sig, struct kernel_siginfo *info, struct task_struct *p,
 			enum pid_type type)
 {
 	unsigned long flags;
@@ -1228,7 +1228,7 @@ int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
  * that is why we also clear SIGNAL_UNKILLABLE.
  */
 int
-force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
+force_sig_info(int sig, struct kernel_siginfo *info, struct task_struct *t)
 {
 	unsigned long int flags;
 	int ret, blocked, ignored;
@@ -1316,8 +1316,8 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 /*
  * send signal info to all the members of a group
  */
-int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
-			enum pid_type type)
+int group_send_sig_info(int sig, struct kernel_siginfo *info,
+			struct task_struct *p, enum pid_type type)
 {
 	int ret;
 
@@ -1336,7 +1336,7 @@ int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
  * control characters do (^C, ^Z etc)
  * - the caller must hold at least a readlock on tasklist_lock
  */
-int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp)
+int __kill_pgrp_info(int sig, struct kernel_siginfo *info, struct pid *pgrp)
 {
 	struct task_struct *p = NULL;
 	int retval, success;
@@ -1351,7 +1351,7 @@ int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp)
 	return success ? 0 : retval;
 }
 
-int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
+int kill_pid_info(int sig, struct kernel_siginfo *info, struct pid *pid)
 {
 	int error = -ESRCH;
 	struct task_struct *p;
@@ -1373,7 +1373,7 @@ int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 	}
 }
 
-static int kill_proc_info(int sig, struct siginfo *info, pid_t pid)
+static int kill_proc_info(int sig, struct kernel_siginfo *info, pid_t pid)
 {
 	int error;
 	rcu_read_lock();
@@ -1394,7 +1394,7 @@ static inline bool kill_as_cred_perm(const struct cred *cred,
 }
 
 /* like kill_pid_info(), but doesn't use uid/euid of "current" */
-int kill_pid_info_as_cred(int sig, struct siginfo *info, struct pid *pid,
+int kill_pid_info_as_cred(int sig, struct kernel_siginfo *info, struct pid *pid,
 			 const struct cred *cred)
 {
 	int ret = -EINVAL;
@@ -1438,7 +1438,7 @@ EXPORT_SYMBOL_GPL(kill_pid_info_as_cred);
  * is probably wrong.  Should make it like BSD or SYSV.
  */
 
-static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
+static int kill_something_info(int sig, struct kernel_siginfo *info, pid_t pid)
 {
 	int ret;
 
@@ -1482,7 +1482,7 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
  * These are for backward compatibility with the rest of the kernel source.
  */
 
-int send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
+int send_sig_info(int sig, struct kernel_siginfo *info, struct task_struct *p)
 {
 	/*
 	 * Make sure legacy kernel users don't send in bad values
@@ -1533,7 +1533,7 @@ int force_sig_fault(int sig, int code, void __user *addr
 	___ARCH_SI_IA64(int imm, unsigned int flags, unsigned long isr)
 	, struct task_struct *t)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 
 	clear_siginfo(&info);
 	info.si_signo = sig;
@@ -1556,7 +1556,7 @@ int send_sig_fault(int sig, int code, void __user *addr
 	___ARCH_SI_IA64(int imm, unsigned int flags, unsigned long isr)
 	, struct task_struct *t)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 
 	clear_siginfo(&info);
 	info.si_signo = sig;
@@ -1576,7 +1576,7 @@ int send_sig_fault(int sig, int code, void __user *addr
 
 int force_sig_mceerr(int code, void __user *addr, short lsb, struct task_struct *t)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 
 	WARN_ON((code != BUS_MCEERR_AO) && (code != BUS_MCEERR_AR));
 	clear_siginfo(&info);
@@ -1590,7 +1590,7 @@ int force_sig_mceerr(int code, void __user *addr, short lsb, struct task_struct
 
 int send_sig_mceerr(int code, void __user *addr, short lsb, struct task_struct *t)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 
 	WARN_ON((code != BUS_MCEERR_AO) && (code != BUS_MCEERR_AR));
 	clear_siginfo(&info);
@@ -1605,7 +1605,7 @@ EXPORT_SYMBOL(send_sig_mceerr);
 
 int force_sig_bnderr(void __user *addr, void __user *lower, void __user *upper)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 
 	clear_siginfo(&info);
 	info.si_signo = SIGSEGV;
@@ -1620,7 +1620,7 @@ int force_sig_bnderr(void __user *addr, void __user *lower, void __user *upper)
 #ifdef SEGV_PKUERR
 int force_sig_pkuerr(void __user *addr, u32 pkey)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 
 	clear_siginfo(&info);
 	info.si_signo = SIGSEGV;
@@ -1637,7 +1637,7 @@ int force_sig_pkuerr(void __user *addr, u32 pkey)
  */
 int force_sig_ptrace_errno_trap(int errno, void __user *addr)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 
 	clear_siginfo(&info);
 	info.si_signo = SIGTRAP;
@@ -1766,7 +1766,7 @@ int send_sigqueue(struct sigqueue *q, struct pid *pid, enum pid_type type)
  */
 bool do_notify_parent(struct task_struct *tsk, int sig)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 	unsigned long flags;
 	struct sighand_struct *psig;
 	bool autoreap = false;
@@ -1871,7 +1871,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 static void do_notify_parent_cldstop(struct task_struct *tsk,
 				     bool for_ptracer, int why)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 	unsigned long flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
@@ -1971,7 +1971,7 @@ static bool sigkill_pending(struct task_struct *tsk)
  * If we actually decide not to stop at all because the tracer
  * is gone, we keep current->exit_code unless clear_code.
  */
-static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
+static void ptrace_stop(int exit_code, int why, int clear_code, kernel_siginfo_t *info)
 	__releases(&current->sighand->siglock)
 	__acquires(&current->sighand->siglock)
 {
@@ -2108,7 +2108,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 
 static void ptrace_do_notify(int signr, int exit_code, int why)
 {
-	siginfo_t info;
+	kernel_siginfo_t info;
 
 	clear_siginfo(&info);
 	info.si_signo = signr;
@@ -2289,7 +2289,7 @@ static void do_jobctl_trap(void)
 	}
 }
 
-static int ptrace_signal(int signr, siginfo_t *info)
+static int ptrace_signal(int signr, kernel_siginfo_t *info)
 {
 	/*
 	 * We do not check sig_kernel_stop(signr) but set this marker
@@ -2889,14 +2889,14 @@ enum siginfo_layout siginfo_layout(int sig, int si_code)
 	return layout;
 }
 
-int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
+int copy_siginfo_to_user(siginfo_t __user *to, const kernel_siginfo_t *from)
 {
-	if (copy_to_user(to, from , sizeof(struct siginfo)))
+	if (copy_to_user(to, from , sizeof(struct kernel_siginfo)))
 		return -EFAULT;
 	return 0;
 }
 
-int copy_siginfo_from_user(siginfo_t *to, const siginfo_t __user *from)
+int copy_siginfo_from_user(kernel_siginfo_t *to, const siginfo_t __user *from)
 {
 	if (copy_from_user(to, from, sizeof(struct siginfo)))
 		return -EFAULT;
@@ -2905,13 +2905,13 @@ int copy_siginfo_from_user(siginfo_t *to, const siginfo_t __user *from)
 
 #ifdef CONFIG_COMPAT
 int copy_siginfo_to_user32(struct compat_siginfo __user *to,
-			   const struct siginfo *from)
+			   const struct kernel_siginfo *from)
 #if defined(CONFIG_X86_X32_ABI) || defined(CONFIG_IA32_EMULATION)
 {
 	return __copy_siginfo_to_user32(to, from, in_x32_syscall());
 }
 int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
-			     const struct siginfo *from, bool x32_ABI)
+			     const struct kernel_siginfo *from, bool x32_ABI)
 #endif
 {
 	struct compat_siginfo new;
@@ -2995,7 +2995,7 @@ int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
 	return 0;
 }
 
-int copy_siginfo_from_user32(struct siginfo *to,
+int copy_siginfo_from_user32(struct kernel_siginfo *to,
 			     const struct compat_siginfo __user *ufrom)
 {
 	struct compat_siginfo from;
@@ -3085,7 +3085,7 @@ int copy_siginfo_from_user32(struct siginfo *to,
  *  @info: if non-null, the signal's siginfo is returned here
  *  @ts: upper bound on process time suspension
  */
-static int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
+static int do_sigtimedwait(const sigset_t *which, kernel_siginfo_t *info,
 		    const struct timespec *ts)
 {
 	ktime_t *to = NULL, timeout = KTIME_MAX;
@@ -3149,7 +3149,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 {
 	sigset_t these;
 	struct timespec ts;
-	siginfo_t info;
+	kernel_siginfo_t info;
 	int ret;
 
 	/* XXX: Don't preclude handling different sized sigset_t's.  */
@@ -3181,7 +3181,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 {
 	sigset_t s;
 	struct timespec t;
-	siginfo_t info;
+	kernel_siginfo_t info;
 	long ret;
 
 	if (sigsetsize != sizeof(sigset_t))
@@ -3213,7 +3213,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
  */
 SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 
 	clear_siginfo(&info);
 	info.si_signo = sig;
@@ -3226,7 +3226,7 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
 }
 
 static int
-do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
+do_send_specific(pid_t tgid, pid_t pid, int sig, struct kernel_siginfo *info)
 {
 	struct task_struct *p;
 	int error = -ESRCH;
@@ -3257,7 +3257,7 @@ do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
 
 static int do_tkill(pid_t tgid, pid_t pid, int sig)
 {
-	struct siginfo info;
+	struct kernel_siginfo info;
 
 	clear_siginfo(&info);
 	info.si_signo = sig;
@@ -3304,7 +3304,7 @@ SYSCALL_DEFINE2(tkill, pid_t, pid, int, sig)
 	return do_tkill(0, pid, sig);
 }
 
-static int do_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t *info)
+static int do_rt_sigqueueinfo(pid_t pid, int sig, kernel_siginfo_t *info)
 {
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
@@ -3329,7 +3329,7 @@ static int do_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t *info)
 SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 		siginfo_t __user *, uinfo)
 {
-	siginfo_t info;
+	kernel_siginfo_t info;
 	int ret = copy_siginfo_from_user(&info, uinfo);
 	if (unlikely(ret))
 		return ret;
@@ -3342,7 +3342,7 @@ COMPAT_SYSCALL_DEFINE3(rt_sigqueueinfo,
 			int, sig,
 			struct compat_siginfo __user *, uinfo)
 {
-	siginfo_t info;
+	kernel_siginfo_t info;
 	int ret = copy_siginfo_from_user32(&info, uinfo);
 	if (unlikely(ret))
 		return ret;
@@ -3350,7 +3350,7 @@ COMPAT_SYSCALL_DEFINE3(rt_sigqueueinfo,
 }
 #endif
 
-static int do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
+static int do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, kernel_siginfo_t *info)
 {
 	/* This is only valid for single tasks */
 	if (pid <= 0 || tgid <= 0)
@@ -3372,7 +3372,7 @@ static int do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
 SYSCALL_DEFINE4(rt_tgsigqueueinfo, pid_t, tgid, pid_t, pid, int, sig,
 		siginfo_t __user *, uinfo)
 {
-	siginfo_t info;
+	kernel_siginfo_t info;
 	int ret = copy_siginfo_from_user(&info, uinfo);
 	if (unlikely(ret))
 		return ret;
@@ -3386,7 +3386,7 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo,
 			int, sig,
 			struct compat_siginfo __user *, uinfo)
 {
-	siginfo_t info;
+	kernel_siginfo_t info;
 	int ret = copy_siginfo_from_user32(&info, uinfo);
 	if (unlikely(ret))
 		return ret;
@@ -3968,10 +3968,57 @@ __weak const char *arch_vma_name(struct vm_area_struct *vma)
 	return NULL;
 }
 
-void __init signals_init(void)
+static inline void siginfo_buildtime_checks(void)
 {
 	BUILD_BUG_ON(sizeof(struct siginfo) != SI_MAX_SIZE);
 
+	/* Verify the offsets in the two siginfos match */
+#define CHECK_OFFSET(field) \
+	BUILD_BUG_ON(offsetof(siginfo_t, field) != offsetof(kernel_siginfo_t, field))
+
+	/* kill */
+	CHECK_OFFSET(si_pid);
+	CHECK_OFFSET(si_uid);
+
+	/* timer */
+	CHECK_OFFSET(si_tid);
+	CHECK_OFFSET(si_overrun);
+	CHECK_OFFSET(si_value);
+
+	/* rt */
+	CHECK_OFFSET(si_pid);
+	CHECK_OFFSET(si_uid);
+	CHECK_OFFSET(si_value);
+
+	/* sigchld */
+	CHECK_OFFSET(si_pid);
+	CHECK_OFFSET(si_uid);
+	CHECK_OFFSET(si_status);
+	CHECK_OFFSET(si_utime);
+	CHECK_OFFSET(si_stime);
+
+	/* sigfault */
+	CHECK_OFFSET(si_addr);
+	CHECK_OFFSET(si_addr_lsb);
+	CHECK_OFFSET(si_lower);
+	CHECK_OFFSET(si_upper);
+	CHECK_OFFSET(si_pkey);
+
+	/* sigpoll */
+	CHECK_OFFSET(si_band);
+	CHECK_OFFSET(si_fd);
+
+	/* sigsys */
+	CHECK_OFFSET(si_call_addr);
+	CHECK_OFFSET(si_syscall);
+	CHECK_OFFSET(si_arch);
+#undef CHECK_OFFSET
+}
+
+void __init signals_init(void)
+{
+	siginfo_buildtime_checks();
+
 	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
 }
 
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 4b9127e95430..eabb4c22728d 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -308,7 +308,7 @@ static void common_hrtimer_rearm(struct k_itimer *timr)
  * To protect against the timer going away while the interrupt is queued,
  * we require that the it_requeue_pending flag be set.
  */
-void posixtimer_rearm(struct siginfo *info)
+void posixtimer_rearm(struct kernel_siginfo *info)
 {
 	struct k_itimer *timr;
 	unsigned long flags;
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 8b8b70620bbe..cbcb8ba51142 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -732,7 +732,7 @@ static int apparmor_task_setrlimit(struct task_struct *task,
 	return error;
 }
 
-static int apparmor_task_kill(struct task_struct *target, struct siginfo *info,
+static int apparmor_task_kill(struct task_struct *target, struct kernel_siginfo *info,
 			      int sig, const struct cred *cred)
 {
 	struct aa_label *cl, *tl;
diff --git a/security/security.c b/security/security.c
index 736e78da1ab9..0d504fceda8b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1147,7 +1147,7 @@ int security_task_movememory(struct task_struct *p)
 	return call_int_hook(task_movememory, 0, p);
 }
 
-int security_task_kill(struct task_struct *p, struct siginfo *info,
+int security_task_kill(struct task_struct *p, struct kernel_siginfo *info,
 			int sig, const struct cred *cred)
 {
 	return call_int_hook(task_kill, 0, p, info, sig, cred);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ad9a9b8e9979..1b500b4c78a7 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4186,7 +4186,7 @@ static int selinux_task_movememory(struct task_struct *p)
 			    PROCESS__SETSCHED, NULL);
 }
 
-static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
+static int selinux_task_kill(struct task_struct *p, struct kernel_siginfo *info,
 				int sig, const struct cred *cred)
 {
 	u32 secid;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 340fc30ad85d..025de76af1db 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2251,7 +2251,7 @@ static int smack_task_movememory(struct task_struct *p)
  * Return 0 if write access is permitted
  *
  */
-static int smack_task_kill(struct task_struct *p, struct siginfo *info,
+static int smack_task_kill(struct task_struct *p, struct kernel_siginfo *info,
 			   int sig, const struct cred *cred)
 {
 	struct smk_audit_info ad;
-- 
2.17.1
