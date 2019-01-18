From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 23/29] timex: change syscalls to use struct __kernel_timex
Date: Fri, 18 Jan 2019 17:18:29 +0100
Message-ID: <20190118161835.2259170-24-arnd@arndb.de>
References: <20190118161835.2259170-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.or
List-Id: linux-api@vger.kernel.org

From: Deepa Dinamani <deepa.kernel@gmail.com>

struct timex is not y2038 safe.
Switch all the syscall apis to use y2038 safe __kernel_timex.

Note that sys_adjtimex() does not have a y2038 safe solution.  C libraries
can implement it by calling clock_adjtime(CLOCK_REALTIME, ...).

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h   | 6 +++---
 kernel/time/posix-timers.c | 2 +-
 kernel/time/time.c         | 4 +++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index baa4b70b02d3..09330d5bda0c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -54,7 +54,7 @@ struct __sysctl_args;
 struct sysinfo;
 struct timespec;
 struct timeval;
-struct timex;
+struct __kernel_timex;
 struct timezone;
 struct tms;
 struct utimbuf;
@@ -695,7 +695,7 @@ asmlinkage long sys_gettimeofday(struct timeval __user *tv,
 				struct timezone __user *tz);
 asmlinkage long sys_settimeofday(struct timeval __user *tv,
 				struct timezone __user *tz);
-asmlinkage long sys_adjtimex(struct timex __user *txc_p);
+asmlinkage long sys_adjtimex(struct __kernel_timex __user *txc_p);
 
 /* kernel/timer.c */
 asmlinkage long sys_getpid(void);
@@ -870,7 +870,7 @@ asmlinkage long sys_open_by_handle_at(int mountdirfd,
 				      struct file_handle __user *handle,
 				      int flags);
 asmlinkage long sys_clock_adjtime(clockid_t which_clock,
-				struct timex __user *tx);
+				struct __kernel_timex __user *tx);
 asmlinkage long sys_syncfs(int fd);
 asmlinkage long sys_setns(int fd, int nstype);
 asmlinkage long sys_sendmmsg(int fd, struct mmsghdr __user *msg,
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 2d84b3db1ade..de79f85ae14f 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1060,7 +1060,7 @@ int do_clock_adjtime(const clockid_t which_clock, struct __kernel_timex * ktx)
 }
 
 SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
-		struct timex __user *, utx)
+		struct __kernel_timex __user *, utx)
 {
 	struct __kernel_timex ktx;
 	int err;
diff --git a/kernel/time/time.c b/kernel/time/time.c
index d179d33f639a..78b5c8f1495a 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -263,7 +263,8 @@ COMPAT_SYSCALL_DEFINE2(settimeofday, struct old_timeval32 __user *, tv,
 }
 #endif
 
-SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
+#if !defined(CONFIG_64BIT_TIME) || defined(CONFIG_64BIT)
+SYSCALL_DEFINE1(adjtimex, struct __kernel_timex __user *, txc_p)
 {
 	struct __kernel_timex txc;		/* Local copy of parameter */
 	int ret;
@@ -277,6 +278,7 @@ SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
 	ret = do_adjtimex(&txc);
 	return copy_to_user(txc_p, &txc, sizeof(struct __kernel_timex)) ? -EFAULT : ret;
 }
+#endif
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
 int get_old_timex32(struct __kernel_timex *txc, const struct old_timex32 __user *utp)
-- 
2.20.0
