From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 23/23] y2038: allow disabling time32 system calls
Date: Fri,  8 Nov 2019 22:12:22 +0100
Message-ID: <20191108211323.1806194-14-arnd@arndb.de>
References: <20191108210236.1296047-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191108210236.1296047-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Christian Brauner <christian@brauner.io>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

At the moment, the compilation of the old time32 system calls depends
purely on the architecture. As systems with new libc based on 64-bit
time_t are getting deployed, even architectures that previously supported
these (notably x86-32 and arm32 but also many others) no longer depend on
them, and removing them from a kernel image results in a smaller kernel
binary, the same way we can leave out many other optional system calls.

More importantly, on an embedded system that needs to keep working
beyond year 2038, any user space program calling these system calls
is likely a bug, so removing them from the kernel image does provide
an extra debugging help for finding broken applications.

I've gone back and forth on hiding this option unless CONFIG_EXPERT
is set. This version leaves it visible based on the logic that
eventually it will be turned off indefinitely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/Kconfig    |  3 ++-
 kernel/sys_ni.c | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 0e1fded2940e..1203955ed4d0 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -797,7 +797,8 @@ config COMPAT_OLD_SIGACTION
 	bool
 
 config COMPAT_32BIT_TIME
-	def_bool !64BIT || COMPAT
+	bool "Provide system calls for 32-bit time_t"
+	default !64BIT || COMPAT
 	help
 	  This enables 32 bit time_t support in addition to 64 bit time_t support.
 	  This is relevant on all 32-bit architectures, and 64-bit architectures
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 34b76895b81e..3b69a560a7ac 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -410,6 +410,29 @@ COND_SYSCALL(send);
 COND_SYSCALL(bdflush);
 COND_SYSCALL(uselib);
 
+/* optional: time32 */
+COND_SYSCALL(time32);
+COND_SYSCALL(stime32);
+COND_SYSCALL(utime32);
+COND_SYSCALL(adjtimex_time32);
+COND_SYSCALL(sched_rr_get_interval_time32);
+COND_SYSCALL(nanosleep_time32);
+COND_SYSCALL(rt_sigtimedwait_time32);
+COND_SYSCALL_COMPAT(rt_sigtimedwait_time32);
+COND_SYSCALL(timer_settime32);
+COND_SYSCALL(timer_gettime32);
+COND_SYSCALL(clock_settime32);
+COND_SYSCALL(clock_gettime32);
+COND_SYSCALL(clock_getres_time32);
+COND_SYSCALL(clock_nanosleep_time32);
+COND_SYSCALL(utimes_time32);
+COND_SYSCALL(futimesat_time32);
+COND_SYSCALL(pselect6_time32);
+COND_SYSCALL_COMPAT(pselect6_time32);
+COND_SYSCALL(ppoll_time32);
+COND_SYSCALL_COMPAT(ppoll_time32);
+COND_SYSCALL(utimensat_time32);
+COND_SYSCALL(clock_adjtime32);
 
 /*
  * The syscalls below are not found in include/uapi/asm-generic/unistd.h
-- 
2.20.0
