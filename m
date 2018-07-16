From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 11/17] y2038: Prepare sched_rr_get_interval for __kernel_timespec
Date: Mon, 16 Jul 2018 18:10:57 +0200
Message-ID: <20180716161103.16239-12-arnd@arndb.de>
References: <20180716161103.16239-1-arnd@arndb.de>
Return-path: <libc-alpha-return-94327-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20180716161103.16239-1-arnd@arndb.de>
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, hch@infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, albert.aribaud@3adev.fr, netdev@vger.kernel.org, viro@zeniv.linux.org.uk, peterz@infradead.org, dvhart@infradead.org, ebiederm@xmission.com, linux@dominikbrodowski.net, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This is a preparation patch for converting sys_sched_rr_get_interval to
work with 64-bit time_t on 32-bit architectures. The 'interval' argument
is changed to struct __kernel_timespec, which will be redefined using
64-bit time_t in the future. The compat version of the system call in
turn is enabled for compilation with CONFIG_COMPAT_32BIT_TIME so
the individual 32-bit architectures can share the handling of the
traditional argument with 64-bit architectures providing it for their
compat mode.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h | 2 +-
 kernel/sched/core.c      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index fc98024d3b5e..1a22bb4285bf 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -614,7 +614,7 @@ asmlinkage long sys_sched_yield(void);
 asmlinkage long sys_sched_get_priority_max(int policy);
 asmlinkage long sys_sched_get_priority_min(int policy);
 asmlinkage long sys_sched_rr_get_interval(pid_t pid,
-					struct timespec __user *interval);
+				struct __kernel_timespec __user *interval);
 
 /* kernel/signal.c */
 asmlinkage long sys_restart_syscall(void);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5d12eab09429..2deb11269fcb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5265,7 +5265,7 @@ static int sched_rr_get_interval(pid_t pid, struct timespec64 *t)
  * an error code.
  */
 SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
-		struct timespec __user *, interval)
+		struct __kernel_timespec __user *, interval)
 {
 	struct timespec64 t;
 	int retval = sched_rr_get_interval(pid, &t);
@@ -5276,7 +5276,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 	return retval;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval,
 		       compat_pid_t, pid,
 		       struct compat_timespec __user *, interval)
-- 
2.9.0
