From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/17] y2038: Prepare sched_rr_get_interval for __kernel_timespec
Date: Wed, 25 Apr 2018 18:03:05 +0200
Message-ID: <20180425160311.2718314-12-arnd@arndb.de>
References: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425160311.2718314-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, netdev@vger.kernel.org, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, albert.aribaud@3adev.fr, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
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
index c3d504dbba9c..2619678359ee 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -601,7 +601,7 @@ asmlinkage long sys_sched_yield(void);
 asmlinkage long sys_sched_get_priority_max(int policy);
 asmlinkage long sys_sched_get_priority_min(int policy);
 asmlinkage long sys_sched_rr_get_interval(pid_t pid,
-					struct timespec __user *interval);
+				struct __kernel_timespec __user *interval);
 
 /* kernel/signal.c */
 asmlinkage long sys_restart_syscall(void);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5e10aaeebfcc..1e0afc42975b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5272,7 +5272,7 @@ static int sched_rr_get_interval(pid_t pid, struct timespec64 *t)
  * an error code.
  */
 SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
-		struct timespec __user *, interval)
+		struct __kernel_timespec __user *, interval)
 {
 	struct timespec64 t;
 	int retval = sched_rr_get_interval(pid, &t);
@@ -5283,7 +5283,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 	return retval;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval,
 		       compat_pid_t, pid,
 		       struct compat_timespec __user *, interval)
-- 
2.9.0
