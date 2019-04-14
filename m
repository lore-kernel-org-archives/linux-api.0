From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 3/4] signal: support CLONE_PIDFD with pidfd_send_signal
Date: Sun, 14 Apr 2019 22:14:35 +0200
Message-ID: <20190414201436.19502-4-christian@brauner.io>
References: <20190414201436.19502-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190414201436.19502-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Let pidfd_send_signal() use pidfds retrieved via CLONE_PIDFD. With this
patch pidfd_send_signal() becomes independent of procfs. This fullfils the
request made when we merged the pidfd_send_signal() patchset. The
pidfd_send_signal() syscall is now always available allowing for it to be
used by users without procfs mounted or even users without procfs support
compiled into the kernel.

Signed-off-by: Christian Brauner <christian@brauner.io>
Signed-off-by: Jann Horn <jann@thejh.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/signal.c | 14 ++++++++++----
 kernel/sys_ni.c |  3 ---
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index f98448cf2def..cd83cc376767 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3513,7 +3513,6 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
 	return kill_something_info(sig, &info, pid);
 }
 
-#ifdef CONFIG_PROC_FS
 /*
  * Verify that the signaler and signalee either are in the same pid namespace
  * or that the signaler's pid namespace is an ancestor of the signalee's pid
@@ -3550,6 +3549,14 @@ static int copy_siginfo_from_user_any(kernel_siginfo_t *kinfo, siginfo_t *info)
 	return copy_siginfo_from_user(kinfo, info);
 }
 
+static struct pid *pidfd_to_pid(const struct file *file)
+{
+	if (file->f_op == &pidfd_fops)
+		return file->private_data;
+
+	return tgid_pidfd_to_pid(file);
+}
+
 /**
  * sys_pidfd_send_signal - send a signal to a process through a task file
  *                          descriptor
@@ -3581,12 +3588,12 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
 	if (flags)
 		return -EINVAL;
 
-	f = fdget_raw(pidfd);
+	f = fdget(pidfd);
 	if (!f.file)
 		return -EBADF;
 
 	/* Is this a pidfd? */
-	pid = tgid_pidfd_to_pid(f.file);
+	pid = pidfd_to_pid(f.file);
 	if (IS_ERR(pid)) {
 		ret = PTR_ERR(pid);
 		goto err;
@@ -3620,7 +3627,6 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
 	fdput(f);
 	return ret;
 }
-#endif /* CONFIG_PROC_FS */
 
 static int
 do_send_specific(pid_t tgid, pid_t pid, int sig, struct kernel_siginfo *info)
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index d21f4befaea4..4d9ae5ea6caf 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -167,9 +167,6 @@ COND_SYSCALL(syslog);
 
 /* kernel/sched/core.c */
 
-/* kernel/signal.c */
-COND_SYSCALL(pidfd_send_signal);
-
 /* kernel/sys.c */
 COND_SYSCALL(setregid);
 COND_SYSCALL(setgid);
-- 
2.21.0
