From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 3/4] signal: support pidctl() with pidfd_send_signal()
Date: Mon, 25 Mar 2019 17:20:51 +0100
Message-ID: <20190325162052.28987-4-christian@brauner.io>
References: <20190325162052.28987-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190325162052.28987-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: jannh@google.com, khlebnikov@yandex-team.ru, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, ebiederm@xmission.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Let pidfd_send_signal() use pidfds retrieved via pidctl(). With this patch
pidfd_send_signal() becomes independent of procfs. This fullfils the
request made when we merged the pidfd_send_signal() patchset. The
pidfd_send_signal() syscall is now always available allowing for it to be
used by users without procfs mounted or even users without procfs support
compiled into the kernel.

Signed-off-by: Christian Brauner <christian@brauner.io>
Reviewed-by: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jann Horn <jannh@google.com
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/signal.c | 20 +++++++++-----------
 kernel/sys_ni.c |  3 ---
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index b7953934aa99..d77183be1677 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3513,7 +3513,6 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
 	return kill_something_info(sig, &info, pid);
 }
 
-#ifdef CONFIG_PROC_FS
 /*
  * Verify that the signaler and signalee either are in the same pid namespace
  * or that the signaler's pid namespace is an ancestor of the signalee's pid
@@ -3521,16 +3520,13 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
  */
 static bool access_pidfd_pidns(struct pid *pid)
 {
+	int ret;
 	struct pid_namespace *active = task_active_pid_ns(current);
 	struct pid_namespace *p = ns_of_pid(pid);
 
-	for (;;) {
-		if (!p)
-			return false;
-		if (p == active)
-			break;
-		p = p->parent;
-	}
+	ret = pidnscmp(active, p);
+	if (ret < 0)
+		return false;
 
 	return true;
 }
@@ -3581,12 +3577,15 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
 	if (flags)
 		return -EINVAL;
 
-	f = fdget_raw(pidfd);
+	f = fdget(pidfd);
 	if (!f.file)
 		return -EBADF;
 
 	/* Is this a pidfd? */
-	pid = tgid_pidfd_to_pid(f.file);
+	if (f.file->f_op == &pidfd_fops)
+		pid = f.file->private_data;
+	else
+		pid = tgid_pidfd_to_pid(f.file);
 	if (IS_ERR(pid)) {
 		ret = PTR_ERR(pid);
 		goto err;
@@ -3625,7 +3624,6 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
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
