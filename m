From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/19] compat: remove compat_printk
Date: Wed,  6 May 2015 18:30:08 +0200
Message-ID: <1430929826-318934-2-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <libc-alpha-return-58722-glibc-alpha=m.gmane.org@sourceware.org>
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

After 7e8e385aaf6e ("x86/compat: Remove sys32_vm86_warning"), this
function has become unused, so we can remove it as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat.c            | 14 --------------
 include/linux/compat.h |  1 -
 kernel/sysctl.c        | 10 ----------
 3 files changed, 25 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 6fd272d455e4..7d78cde20fc3 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -54,20 +54,6 @@
 #include <asm/ioctls.h>
 #include "internal.h"
 
-int compat_log = 1;
-
-int compat_printk(const char *fmt, ...)
-{
-	va_list ap;
-	int ret;
-	if (!compat_log)
-		return 0;
-	va_start(ap, fmt);
-	ret = vprintk(fmt, ap);
-	va_end(ap);
-	return ret;
-}
-
 /*
  * Not all architectures have sys_utime, so implement this in terms
  * of sys_utimes.
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ab25814690bc..d533d06146a8 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -424,7 +424,6 @@ asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
 
 asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
 
-extern int compat_printk(const char *fmt, ...);
 extern void sigset_from_compat(sigset_t *set, const compat_sigset_t *compat);
 extern void sigset_to_compat(compat_sigset_t *compat, const sigset_t *set);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2082b1a88fb9..4020ade0ce4d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -105,7 +105,6 @@ extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int pid_max_min, pid_max_max;
 extern int percpu_pagelist_fraction;
-extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifndef CONFIG_MMU
@@ -1043,15 +1042,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &neg_one,
 	},
 #endif
-#ifdef CONFIG_COMPAT
-	{
-		.procname	= "compat-log",
-		.data		= &compat_log,
-		.maxlen		= sizeof (int),
-	 	.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
 #ifdef CONFIG_RT_MUTEXES
 	{
 		.procname	= "max_lock_depth",
-- 
2.1.0.rc2
