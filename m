From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 17/23] y2038: time: avoid timespec usage in settimeofday()
Date: Fri,  8 Nov 2019 22:12:16 +0100
Message-ID: <20191108211323.1806194-8-arnd@arndb.de>
References: <20191108210236.1296047-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191108210236.1296047-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Deepa Dinamani <deepa.kernel@gmail.com>, Christian Brauner <christian@brauner.io>, Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>, Corey Minyard <cminyard@mvista.com>, zhengbin <zhengbin13@huawei.com>, Li RongQing <lirongqing@baidu.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The compat_get_timeval() and timeval_valid() interfaces
are deprecated and getting removed along with the definition
of struct timeval itself.

Change the two implementations of the settimeofday()
system call to open-code these helpers and completely
avoid references to timeval.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h |  2 +-
 kernel/time/time.c       | 20 +++++++++-----------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e665920fa359..d0391cc2dae9 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -734,7 +734,7 @@ asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct g
 /* kernel/time.c */
 asmlinkage long sys_gettimeofday(struct __kernel_old_timeval __user *tv,
 				struct timezone __user *tz);
-asmlinkage long sys_settimeofday(struct timeval __user *tv,
+asmlinkage long sys_settimeofday(struct __kernel_old_timeval __user *tv,
 				struct timezone __user *tz);
 asmlinkage long sys_adjtimex(struct __kernel_timex __user *txc_p);
 asmlinkage long sys_adjtimex_time32(struct old_timex32 __user *txc_p);
diff --git a/kernel/time/time.c b/kernel/time/time.c
index bc114f0be8f1..6bfbe640fd3b 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -196,22 +196,21 @@ int do_sys_settimeofday64(const struct timespec64 *tv, const struct timezone *tz
 	return 0;
 }
 
-SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
+SYSCALL_DEFINE2(settimeofday, struct __kernel_old_timeval __user *, tv,
 		struct timezone __user *, tz)
 {
 	struct timespec64 new_ts;
-	struct timeval user_tv;
 	struct timezone new_tz;
 
 	if (tv) {
-		if (copy_from_user(&user_tv, tv, sizeof(*tv)))
+		if (get_user(new_ts.tv_sec, &tv->tv_sec) ||
+		    get_user(new_ts.tv_nsec, &tv->tv_usec))
 			return -EFAULT;
 
-		if (!timeval_valid(&user_tv))
+		if (tv->tv_usec > USEC_PER_SEC)
 			return -EINVAL;
 
-		new_ts.tv_sec = user_tv.tv_sec;
-		new_ts.tv_nsec = user_tv.tv_usec * NSEC_PER_USEC;
+		new_ts.tv_nsec *= NSEC_PER_USEC;
 	}
 	if (tz) {
 		if (copy_from_user(&new_tz, tz, sizeof(*tz)))
@@ -245,18 +244,17 @@ COMPAT_SYSCALL_DEFINE2(settimeofday, struct old_timeval32 __user *, tv,
 		       struct timezone __user *, tz)
 {
 	struct timespec64 new_ts;
-	struct timeval user_tv;
 	struct timezone new_tz;
 
 	if (tv) {
-		if (compat_get_timeval(&user_tv, tv))
+		if (get_user(new_ts.tv_sec, &tv->tv_sec) ||
+		    get_user(new_ts.tv_nsec, &tv->tv_usec))
 			return -EFAULT;
 
-		if (!timeval_valid(&user_tv))
+		if (new_ts.tv_nsec > USEC_PER_SEC)
 			return -EINVAL;
 
-		new_ts.tv_sec = user_tv.tv_sec;
-		new_ts.tv_nsec = user_tv.tv_usec * NSEC_PER_USEC;
+		new_ts.tv_nsec *= NSEC_PER_USEC;
 	}
 	if (tz) {
 		if (copy_from_user(&new_tz, tz, sizeof(*tz)))
-- 
2.20.0
