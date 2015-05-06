From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 16/19] y2038: use __kernel_timespec in sys_rt_sigtimedwait
Date: Wed,  6 May 2015 18:30:23 +0200
Message-ID: <1430929826-318934-17-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This is a straightforward conversion of the native and compat
sys_rt_sigtimedwait functions to use __kernel_timespec, so
32-bit user space can pass a 64-bit time_t into the native
syscall and use the compat syscall for the traditional 32-bit
time_t.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/signal.h   |  3 ++-
 include/linux/syscalls.h |  2 +-
 kernel/compat.c          | 10 +++++-----
 kernel/signal.c          | 13 +++++++------
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index ab1e0392b5ac..31970d22f6c1 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -2,6 +2,7 @@
 #define _LINUX_SIGNAL_H
 
 #include <linux/list.h>
+#include <linux/time.h>
 #include <linux/bug.h>
 #include <uapi/linux/signal.h>
 
@@ -234,7 +235,7 @@ extern int do_send_sig_info(int sig, struct siginfo *info,
 extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
 extern int do_sigtimedwait(const sigset_t *, siginfo_t *,
-				const struct timespec *);
+				const struct timespec64 *);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index c3f15b5a9b79..017aa1c970e6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -365,7 +365,7 @@ asmlinkage long sys_rt_sigprocmask(int how, sigset_t __user *set,
 asmlinkage long sys_rt_sigpending(sigset_t __user *set, size_t sigsetsize);
 asmlinkage long sys_rt_sigtimedwait(const sigset_t __user *uthese,
 				siginfo_t __user *uinfo,
-				const struct timespec __user *uts,
+				const struct __kernel_timespec __user *uts,
 				size_t sigsetsize);
 asmlinkage long sys_rt_tgsigqueueinfo(pid_t tgid, pid_t  pid, int sig,
 		siginfo_t __user *uinfo);
diff --git a/kernel/compat.c b/kernel/compat.c
index d8d0a4711cc7..ec09c6e1d594 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -1081,7 +1081,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 {
 	compat_sigset_t s32;
 	sigset_t s;
-	struct timespec t;
+	struct timespec64 t;
 	siginfo_t info;
 	long ret;
 
@@ -1093,7 +1093,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 	sigset_from_compat(&s, &s32);
 
 	if (uts) {
-		if (compat_get_timespec(&t, uts))
+		if (compat_get_timespec64(&t, uts))
 			return -EFAULT;
 	}
 
@@ -1115,7 +1115,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, sigset_t __user *, uthese,
 		struct compat_timespec __user *, uts, size_t, sigsetsize)
 {
 	sigset_t s;
-	struct timespec t;
+	struct timespec64 t;
 	siginfo_t info;
 	long ret;
 
@@ -1125,7 +1125,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, sigset_t __user *, uthese,
 	if (copy_from_user(&s, uthese, sizeof(sigset_t)))
 		return -EFAULT;
 	if (uts) {
-		if (compat_get_timespec(&t, uts))
+		if (compat_get_timespec64(&t, uts))
 			return -EFAULT;
 	}
 
@@ -1147,7 +1147,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait_time64, compat_sigset_t __user *, uthese,
 {
 	compat_sigset_t s32;
 	sigset_t s;
-	struct timespec t;
+	struct timespec64 t;
 	siginfo_t info;
 	long ret;
 
diff --git a/kernel/signal.c b/kernel/signal.c
index d51c5ddd855c..1f12483ddf9a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2798,7 +2798,7 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
  *  @ts: upper bound on process time suspension
  */
 int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
-			const struct timespec *ts)
+			const struct timespec64 *ts)
 {
 	struct task_struct *tsk = current;
 	long timeout = MAX_SCHEDULE_TIMEOUT;
@@ -2806,9 +2806,9 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
 	int sig;
 
 	if (ts) {
-		if (!timespec_valid(ts))
+		if (!timespec64_valid(ts))
 			return -EINVAL;
-		timeout = timespec_to_jiffies(ts);
+		timeout = timespec64_to_jiffies(ts);
 		/*
 		 * We can be close to the next tick, add another one
 		 * to ensure we will wait at least the time asked for.
@@ -2860,11 +2860,12 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
  *  @sigsetsize: size of sigset_t type
  */
 SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
-		siginfo_t __user *, uinfo, const struct timespec __user *, uts,
+		siginfo_t __user *, uinfo,
+		const struct __kernel_timespec __user *, uts,
 		size_t, sigsetsize)
 {
 	sigset_t these;
-	struct timespec ts;
+	struct timespec64 ts;
 	siginfo_t info;
 	int ret;
 
@@ -2872,7 +2873,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 	if (sigsetsize != sizeof(sigset_t))
 		return -EINVAL;
 
-	if (copy_from_user(&these, uthese, sizeof(these)))
+	if (get_timespec64(&ts, uts))
 		return -EFAULT;
 
 	if (uts) {
-- 
2.1.0.rc2
