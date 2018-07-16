From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 15/17] y2038: signal: Change rt_sigtimedwait to use __kernel_timespec
Date: Mon, 16 Jul 2018 18:11:01 +0200
Message-ID: <20180716161103.16239-16-arnd@arndb.de>
References: <20180716161103.16239-1-arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716161103.16239-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, hch@infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, albert.aribaud@3adev.fr, netdev@vger.kernel.org, viro@zeniv.linux.org.uk, peterz@infradead.org, dvhart@infradead.org, ebiederm@xmission.com, linux@dominikbrodowski.net, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This changes sys_rt_sigtimedwait() to use get_timespec64(), changing
the timeout type to __kernel_timespec, which will be changed to use
a 64-bit time_t in the future. Since the do_sigtimedwait() core
function changes, we also have to modify the compat version of this
system call in the same way.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h |  2 +-
 kernel/signal.c          | 17 +++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 6871f6901a70..9c1da8752724 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -635,7 +635,7 @@ asmlinkage long sys_rt_sigprocmask(int how, sigset_t __user *set,
 asmlinkage long sys_rt_sigpending(sigset_t __user *set, size_t sigsetsize);
 asmlinkage long sys_rt_sigtimedwait(const sigset_t __user *uthese,
 				siginfo_t __user *uinfo,
-				const struct timespec __user *uts,
+				const struct __kernel_timespec __user *uts,
 				size_t sigsetsize);
 asmlinkage long sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 786bacc60649..0418a499b9f3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3036,7 +3036,7 @@ int copy_siginfo_from_user32(struct siginfo *to,
  *  @ts: upper bound on process time suspension
  */
 static int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
-		    const struct timespec *ts)
+		    const struct timespec64 *ts)
 {
 	ktime_t *to = NULL, timeout = KTIME_MAX;
 	struct task_struct *tsk = current;
@@ -3044,9 +3044,9 @@ static int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
 	int sig, ret = 0;
 
 	if (ts) {
-		if (!timespec_valid(ts))
+		if (!timespec64_valid(ts))
 			return -EINVAL;
-		timeout = timespec_to_ktime(*ts);
+		timeout = timespec64_to_ktime(*ts);
 		to = &timeout;
 	}
 
@@ -3094,11 +3094,12 @@ static int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
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
 
@@ -3110,7 +3111,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 		return -EFAULT;
 
 	if (uts) {
-		if (copy_from_user(&ts, uts, sizeof(ts)))
+		if (get_timespec64(&ts, uts))
 			return -EFAULT;
 	}
 
@@ -3130,7 +3131,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 		struct compat_timespec __user *, uts, compat_size_t, sigsetsize)
 {
 	sigset_t s;
-	struct timespec t;
+	struct timespec64 t;
 	siginfo_t info;
 	long ret;
 
@@ -3141,7 +3142,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 		return -EFAULT;
 
 	if (uts) {
-		if (compat_get_timespec(&t, uts))
+		if (compat_get_timespec64(&t, uts))
 			return -EFAULT;
 	}
 
-- 
2.9.0
