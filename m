From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/19] y2038: add compat handling for sys_semtimedop
Date: Wed,  6 May 2015 18:30:20 +0200
Message-ID: <1430929826-318934-14-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <libc-alpha-return-58714-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <1430929826-318934-1-git-send-email-arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This moves the compat_sys_semtimedop function to ipc/sem.c so it
can be shared with 32-bit architectures efficiently. Instead of
copying the timespec back to user space, we take a shortcut and
pass the jiffies value to the low-level implementation directly.

The native sys_semtimedop() function is modified to take a
__kernel_timespec structure, which will be based on a 64-bit
time_t in the future.

There is a small API change here: if multiple errors are present,
and the timespec argument is invalid (bad pointer or bad tv_nsec),
we now return that error before checking any of the other
error conditions. If that is a problem, we need a more sophisticated
approach.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h |  2 +-
 ipc/compat.c             | 10 --------
 ipc/sem.c                | 60 ++++++++++++++++++++++++++++++++++--------------
 ipc/syscall.c            |  7 ++++++
 4 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f3fdc312627b..c2a70a8f907d 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -665,7 +665,7 @@ asmlinkage long sys_semop(int semid, struct sembuf __user *sops,
 asmlinkage long sys_semctl(int semid, int semnum, int cmd, unsigned long arg);
 asmlinkage long sys_semtimedop(int semid, struct sembuf __user *sops,
 				unsigned nsops,
-				const struct timespec __user *timeout);
+				const struct __kernel_timespec __user *timeout);
 asmlinkage long sys_shmat(int shmid, char __user *shmaddr, int shmflg);
 asmlinkage long sys_shmget(key_t key, size_t size, int flag);
 asmlinkage long sys_shmdt(char __user *shmaddr);
diff --git a/ipc/compat.c b/ipc/compat.c
index 9b3c85f8a538..2bbdb093d1be 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -745,13 +745,3 @@ COMPAT_SYSCALL_DEFINE3(shmctl, int, first, int, second, void __user *, uptr)
 	}
 	return err;
 }
-
-COMPAT_SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsems,
-		       unsigned, nsops,
-		       const struct compat_timespec __user *, timeout)
-{
-	struct timespec __user *ts64;
-	if (compat_convert_timespec(&ts64, timeout))
-		return -EFAULT;
-	return sys_semtimedop(semid, tsems, nsops, ts64);
-}
diff --git a/ipc/sem.c b/ipc/sem.c
index d1a6edd17eba..a6ff6754651c 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -72,6 +72,7 @@
  *   The worst-case behavior is nevertheless O(N^2) for N wakeups.
  */
 
+#include <linux/compat.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
@@ -1779,8 +1780,9 @@ static int get_queue_result(struct sem_queue *q)
 	return error;
 }
 
-SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
-		unsigned, nsops, const struct timespec __user *, timeout)
+static long semtimedop(int semid, struct sembuf __user * tsops,
+		       unsigned nsops, unsigned long jiffies_left,
+		       bool timeout)
 {
 	int error = -EINVAL;
 	struct sem_array *sma;
@@ -1789,7 +1791,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	struct sem_undo *un;
 	int undos = 0, alter = 0, max, locknum;
 	struct sem_queue queue;
-	unsigned long jiffies_left = 0;
 	struct ipc_namespace *ns;
 	struct list_head tasks;
 
@@ -1808,19 +1809,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		error =  -EFAULT;
 		goto out_free;
 	}
-	if (timeout) {
-		struct timespec _timeout;
-		if (copy_from_user(&_timeout, timeout, sizeof(*timeout))) {
-			error = -EFAULT;
-			goto out_free;
-		}
-		if (_timeout.tv_sec < 0 || _timeout.tv_nsec < 0 ||
-			_timeout.tv_nsec >= 1000000000L) {
-			error = -EINVAL;
-			goto out_free;
-		}
-		jiffies_left = timespec_to_jiffies(&_timeout);
-	}
 	max = 0;
 	for (sop = sops; sop < sops + nsops; sop++) {
 		if (sop->sem_num >= max)
@@ -2014,10 +2002,48 @@ out_free:
 	return error;
 }
 
+SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
+		unsigned, nsops,
+		const struct __kernel_timespec  __user *, timeout)
+{
+	unsigned long jiffies_left = 0;
+
+	if (timeout) {
+		struct timespec64 _timeout;
+		if (get_timespec64(&_timeout, timeout))
+			return -EFAULT;
+		if (_timeout.tv_sec < 0 || _timeout.tv_nsec < 0 ||
+			_timeout.tv_nsec >= 1000000000L)
+			return -EINVAL;
+		jiffies_left = nsecs_to_jiffies(timespec64_to_ns(&_timeout));
+	}
+	return semtimedop(semid, tsops, nsops, jiffies_left, timeout);
+}
+
+#ifdef CONFIG_COMPAT_TIME
+COMPAT_SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
+		unsigned, nsops,
+		const struct compat_timespec  __user *, timeout)
+{
+	unsigned long jiffies_left = 0;
+
+	if (timeout) {
+		struct timespec64 _timeout;
+		if (compat_get_timespec64(&_timeout, timeout))
+			return -EFAULT;
+		if (_timeout.tv_sec < 0 || _timeout.tv_nsec < 0 ||
+			_timeout.tv_nsec >= 1000000000L)
+			return -EINVAL;
+		jiffies_left = nsecs_to_jiffies(timespec64_to_ns(&_timeout));
+	}
+	return semtimedop(semid, tsops, nsops, jiffies_left, timeout);
+}
+#endif
+
 SYSCALL_DEFINE3(semop, int, semid, struct sembuf __user *, tsops,
 		unsigned, nsops)
 {
-	return sys_semtimedop(semid, tsops, nsops, NULL);
+	return semtimedop(semid, tsops, nsops, 0, 0);
 }
 
 /* If CLONE_SYSVSEM is set, establish sharing of SEM_UNDO state between
diff --git a/ipc/syscall.c b/ipc/syscall.c
index 52429489cde0..d7b17355d870 100644
--- a/ipc/syscall.c
+++ b/ipc/syscall.c
@@ -7,6 +7,7 @@
 #include <linux/unistd.h>
 
 #ifdef __ARCH_WANT_SYS_IPC
+#include <linux/compat_time.h>
 #include <linux/errno.h>
 #include <linux/ipc.h>
 #include <linux/shm.h>
@@ -26,9 +27,15 @@ SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, unsigned long, second,
 		return sys_semtimedop(first, (struct sembuf __user *)ptr,
 				      second, NULL);
 	case SEMTIMEDOP:
+#if defined(CONFIG_ARCH_HAS_COMPAT_TIME) && !defined(CONFIG_64BIT)
+		return compat_sys_semtimedop(first, (struct sembuf __user *)ptr,
+					     second,
+					     (const struct compat_timespec __user *)fifth);
+#else
 		return sys_semtimedop(first, (struct sembuf __user *)ptr,
 				      second,
 				      (const struct timespec __user *)fifth);
+#endif
 
 	case SEMGET:
 		return sys_semget(first, second, third);
-- 
2.1.0.rc2
