From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 2/5] pidfd: add pidfd_wait()
Date: Wed, 24 Jul 2019 16:46:48 +0200
Message-ID: <20190724144651.28272-3-christian@brauner.io>
References: <20190724144651.28272-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190724144651.28272-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, joel@joelfernandes.org, tglx@linutronix.de, tj@kernel.org, dhowells@redhat.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, cyphar@cyphar.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, kernel-team@android.com, Christian Brauner <christian@brauner.io>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds the pidfd_wait() syscall.

One of the last remaining bits for the pidfd api is to make it possible
to wait on pidfds. With this syscall implemented parts of userspace that
want to use this api can finally switch to managing processes completely
through pidfds if they so desire (cf. [1]).

The pidfd_wait() syscall does not allow scoping of the process
identified by the pidfd, i.e. it explicitly does not try to mirror the
behavior of: wait4(-1), wait4(0), waitid(P_ALL), waitid(P_PGID) etc. It
only allows for semantics equivalent to wait4(pid), waitid(P_PID). Users
that need scoping should rely on pid-based wait*() syscalls for now.

pidfd_wait() allows to specify which changes to wait for. The states to
wait for can be or-ed and are specified in the states argument:
	WEXITED		Wait for children that have terminated.
	WSTOPPED	Wait for children that have been stopped by
			delivery of a signal.
	WCONTINUED	Wait for (previously stopped) children that have
			been resumed by delivery of SIGCONT.
	WUNTRACED	Return if a child has stopped.

The behavior of pidfd_wait() can be further modified by specifying the
following or-able options in the flags argument:
	__WCLONE	Only wait for a process that delivers no signal
			or a different signal than SIGCHLD to the parent
			on termination.
	__WALL		Wait for all children indepedent of whether or
			not they deliver no signal or another signal
			than SIGCHLD to the parent on termination.
			parent
	__WNOTHREAD	Do not wait for children of other threads in the
			same thread-group.
	WNOHANG		Return immediately if no child has exited.
	WNOWAIT		Leave the child in a waitable state.

pidfd_wait() takes an additional siginfo_t argument. If it is non-NULL,
pidfd_wait() will fill in si_pid, si_uid, si_signo, si_status, and
si_code. The si_code field will be set to one of CLD_EXITED, CLD_KILLED,
CLD_DUMPED, CLD_STOPPED, CLD_TRAPPED, or CLD_CONTINUED.
Information about resource usage of the process in question is returned
in the struct rusage argument of pidfd_wait().

On success, pidfd_wait() will return the pid of the process the pidfd
referred to. On failure, a negative error code will be returned.

/* Prior approach */
The first implementation was based on a flag WPIDFD which got added to
the wait*() system calls. However, that involved passing the pidfd
through the pid_t pid argument and do in-kernel type switching based on
the flag which feels like a really unclean solution and overall like a
mishmash of two apis. This is something we luckily have avoided so far
and I think we're better off in the long run if we keep it that way.

/* References */
[1]: https://github.com/systemd/systemd/issues/13101

Signed-off-by: Christian Brauner <christian@brauner.io>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-api@vger.kernel.org
---
 include/linux/pid.h |  5 +++
 kernel/exit.c       | 87 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c       |  8 +++++
 kernel/signal.c     |  7 ++--
 4 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 2a83e434db9d..443cd4108943 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -72,6 +72,11 @@ extern struct pid init_struct_pid;
 
 extern const struct file_operations pidfd_fops;
 
+struct file;
+
+extern struct pid *pidfd_pid(const struct file *file);
+
+
 static inline struct pid *get_pid(struct pid *pid)
 {
 	if (pid)
diff --git a/kernel/exit.c b/kernel/exit.c
index 73392a455b72..8086c76e1959 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1738,3 +1738,90 @@ __weak void abort(void)
 	panic("Oops failed to kill thread");
 }
 EXPORT_SYMBOL(abort);
+
+static int copy_rusage_to_user_any(struct rusage *kru, struct rusage __user *ru)
+{
+#ifdef CONFIG_COMPAT
+	if (in_compat_syscall())
+		return put_compat_rusage(kru, (struct compat_rusage __user *)ru);
+#endif
+	return copy_to_user(ru, kru, sizeof(*kru));
+}
+
+static int copy_siginfo_to_user_any(kernel_siginfo_t *kinfo, siginfo_t *info)
+{
+#ifdef CONFIG_COMPAT
+	if (in_compat_syscall())
+		return copy_siginfo_to_user32(
+			(struct compat_siginfo __user *)info, kinfo);
+#endif
+	return copy_siginfo_to_user(info, kinfo);
+}
+
+SYSCALL_DEFINE6(pidfd_wait, int, pidfd, int __user *, stat_addr,
+		siginfo_t __user *, info, struct rusage __user *, ru,
+		unsigned int, states, unsigned int, flags)
+{
+	long ret;
+	struct fd f;
+	struct pid *pid;
+	struct wait_opts wo;
+	struct rusage kru = {};
+	kernel_siginfo_t kinfo = {
+		.si_signo = 0,
+	};
+
+	if (pidfd < 0)
+		return -EINVAL;
+
+	if (states & ~(WEXITED | WSTOPPED | WCONTINUED | WUNTRACED))
+		return -EINVAL;
+
+	if (!(states & (WEXITED | WSTOPPED | WCONTINUED | WUNTRACED)))
+		return -EINVAL;
+
+	if (flags & ~(__WNOTHREAD | __WCLONE | __WALL | WNOWAIT | WNOHANG))
+		return -EINVAL;
+
+	f = fdget(pidfd);
+	if (!f.file)
+		return -EBADF;
+
+	pid = pidfd_pid(f.file);
+	if (IS_ERR(pid)) {
+		ret = PTR_ERR(pid);
+		goto out_fdput;
+	}
+
+	wo = (struct wait_opts){
+		.wo_type	= PIDTYPE_PID,
+		.wo_pid		= pid,
+		.wo_flags	= states | flags,
+		.wo_info	= info ? &kinfo : NULL,
+		.wo_rusage	= ru ? &kru : NULL,
+	};
+
+	ret = do_wait(&wo);
+	if (ret > 0) {
+		kinfo.si_signo = SIGCHLD;
+
+		if (stat_addr && put_user(wo.wo_stat, stat_addr)) {
+			ret = -EFAULT;
+			goto out_fdput;
+		}
+
+		if (ru && copy_rusage_to_user_any(&kru, ru)) {
+			ret = -EFAULT;
+			goto out_fdput;
+		}
+	} else {
+		kinfo.si_signo = 0;
+	}
+
+	if (info && copy_siginfo_to_user_any(&kinfo, info))
+		ret = -EFAULT;
+
+out_fdput:
+	fdput(f);
+	return ret;
+}
diff --git a/kernel/fork.c b/kernel/fork.c
index d8ae0f1b4148..baaff6570517 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1743,6 +1743,14 @@ const struct file_operations pidfd_fops = {
 #endif
 };
 
+struct pid *pidfd_pid(const struct file *file)
+{
+	if (file->f_op == &pidfd_fops)
+		return file->private_data;
+
+	return ERR_PTR(-EBADF);
+}
+
 static void __delayed_free_task(struct rcu_head *rhp)
 {
 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
diff --git a/kernel/signal.c b/kernel/signal.c
index 91b789dd6e72..2e567f64812f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3672,8 +3672,11 @@ static int copy_siginfo_from_user_any(kernel_siginfo_t *kinfo, siginfo_t *info)
 
 static struct pid *pidfd_to_pid(const struct file *file)
 {
-	if (file->f_op == &pidfd_fops)
-		return file->private_data;
+	struct pid *pid;
+
+	pid = pidfd_pid(file);
+	if (!IS_ERR(pid))
+		return pid;
 
 	return tgid_pidfd_to_pid(file);
 }
-- 
2.22.0
