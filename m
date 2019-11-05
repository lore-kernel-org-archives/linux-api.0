From: Mohammad Nasirifar <far.nasiri.m@gmail.com>
Subject: [PATCH 1/1] syscalls: Fix references to filenames containing syscall defs
Date: Mon,  4 Nov 2019 21:29:28 -0500
Message-ID: <20191105022928.517526-1-farnasirim@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mohammad Nasirifar <farnasirim@gmail.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Valdis Kletnieks <valdis.kletnieks@vt.edu>
List-Id: linux-api@vger.kernel.org

Fix stale references to files containing syscall definitions in
'include/linux/syscalls.h' and 'include/uapi/asm-generic/unistd.h',
pointing to 'kernel/itimer.c', 'kernel/hrtimer.c', and 'kernel/time.c'.
They are now under 'kernel/time'.

Also definitions of 'getpid', 'getppid', 'getuid', 'geteuid', 'getgid',
'getegid', 'gettid', and 'sysinfo' are now in 'kernel/sys.c'.

To: arnd@arndb.de
To: akpm@linux-foundation.org
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Mohammad Nasirifar <farnasirim@gmail.com>
---
 include/linux/syscalls.h          | 8 ++++----
 include/uapi/asm-generic/unistd.h | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f7c561c4dcdd..1dbefa5e00e5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -584,13 +584,13 @@ asmlinkage long sys_get_robust_list(int pid,
 asmlinkage long sys_set_robust_list(struct robust_list_head __user *head,
 				    size_t len);
 
-/* kernel/hrtimer.c */
+/* kernel/time/hrtimer.c */
 asmlinkage long sys_nanosleep(struct __kernel_timespec __user *rqtp,
 			      struct __kernel_timespec __user *rmtp);
 asmlinkage long sys_nanosleep_time32(struct old_timespec32 __user *rqtp,
 				     struct old_timespec32 __user *rmtp);
 
-/* kernel/itimer.c */
+/* kernel/time/itimer.c */
 asmlinkage long sys_getitimer(int which, struct itimerval __user *value);
 asmlinkage long sys_setitimer(int which,
 				struct itimerval __user *value,
@@ -731,7 +731,7 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
 
-/* kernel/time.c */
+/* kernel/time/time.c */
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
 				struct timezone __user *tz);
 asmlinkage long sys_settimeofday(struct timeval __user *tv,
@@ -739,7 +739,7 @@ asmlinkage long sys_settimeofday(struct timeval __user *tv,
 asmlinkage long sys_adjtimex(struct __kernel_timex __user *txc_p);
 asmlinkage long sys_adjtimex_time32(struct old_timex32 __user *txc_p);
 
-/* kernel/timer.c */
+/* kernel/sys.c */
 asmlinkage long sys_getpid(void);
 asmlinkage long sys_getppid(void);
 asmlinkage long sys_getuid(void);
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 1fc8faa6e973..6423f5fa4b8e 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -328,13 +328,13 @@ __SC_COMP(__NR_set_robust_list, sys_set_robust_list, \
 __SC_COMP(__NR_get_robust_list, sys_get_robust_list, \
 	  compat_sys_get_robust_list)
 
-/* kernel/hrtimer.c */
+/* kernel/time/hrtimer.c */
 #if defined(__ARCH_WANT_TIME32_SYSCALLS) || __BITS_PER_LONG != 32
 #define __NR_nanosleep 101
 __SC_3264(__NR_nanosleep, sys_nanosleep_time32, sys_nanosleep)
 #endif
 
-/* kernel/itimer.c */
+/* kernel/time/itimer.c */
 #define __NR_getitimer 102
 __SC_COMP(__NR_getitimer, sys_getitimer, compat_sys_getitimer)
 #define __NR_setitimer 103
@@ -507,7 +507,7 @@ __SYSCALL(__NR_prctl, sys_prctl)
 #define __NR_getcpu 168
 __SYSCALL(__NR_getcpu, sys_getcpu)
 
-/* kernel/time.c */
+/* kernel/time/time.c */
 #if defined(__ARCH_WANT_TIME32_SYSCALLS) || __BITS_PER_LONG != 32
 #define __NR_gettimeofday 169
 __SC_COMP(__NR_gettimeofday, sys_gettimeofday, compat_sys_gettimeofday)
@@ -517,7 +517,7 @@ __SC_COMP(__NR_settimeofday, sys_settimeofday, compat_sys_settimeofday)
 __SC_3264(__NR_adjtimex, sys_adjtimex_time32, sys_adjtimex)
 #endif
 
-/* kernel/timer.c */
+/* kernel/sys.c */
 #define __NR_getpid 172
 __SYSCALL(__NR_getpid, sys_getpid)
 #define __NR_getppid 173
-- 
2.23.0
