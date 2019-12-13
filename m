From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 23/24] y2038: rename itimerval to __kernel_old_itimerval
Date: Fri, 13 Dec 2019 21:53:51 +0100
Message-ID: <20191213205417.3871055-14-arnd@arndb.de>
References: <20191213204936.3643476-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191213204936.3643476-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <christian@brauner.io>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Deepa Dinamani <deepa.kernel@gmail.com>, "David S. Miller" <davem@davemloft.net>, Frederic Weisbecker <frederic@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Take the renaming of timeval and timespec one level further,
also renaming itimerval to __kernel_old_itimerval, to avoid
namespace conflicts with the user-space structure that may
use 64-bit time_t members.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h        |  9 ++++-----
 include/uapi/linux/time_types.h |  5 +++++
 kernel/time/itimer.c            | 18 +++++++++---------
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d0391cc2dae9..27245fec2a8a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -16,8 +16,7 @@ struct inode;
 struct iocb;
 struct io_event;
 struct iovec;
-struct itimerspec;
-struct itimerval;
+struct __kernel_old_itimerval;
 struct kexec_segment;
 struct linux_dirent;
 struct linux_dirent64;
@@ -591,10 +590,10 @@ asmlinkage long sys_nanosleep_time32(struct old_timespec32 __user *rqtp,
 				     struct old_timespec32 __user *rmtp);
 
 /* kernel/itimer.c */
-asmlinkage long sys_getitimer(int which, struct itimerval __user *value);
+asmlinkage long sys_getitimer(int which, struct __kernel_old_itimerval __user *value);
 asmlinkage long sys_setitimer(int which,
-				struct itimerval __user *value,
-				struct itimerval __user *ovalue);
+				struct __kernel_old_itimerval __user *value,
+				struct __kernel_old_itimerval __user *ovalue);
 
 /* kernel/kexec.c */
 asmlinkage long sys_kexec_load(unsigned long entry, unsigned long nr_segments,
diff --git a/include/uapi/linux/time_types.h b/include/uapi/linux/time_types.h
index 074e391d73a1..bcc0002115d3 100644
--- a/include/uapi/linux/time_types.h
+++ b/include/uapi/linux/time_types.h
@@ -33,6 +33,11 @@ struct __kernel_old_timespec {
 	long			tv_nsec;	/* nanoseconds */
 };
 
+struct __kernel_old_itimerval {
+	struct __kernel_old_timeval it_interval;/* timer interval */
+	struct __kernel_old_timeval it_value;	/* current value */
+};
+
 struct __kernel_sock_timeval {
 	__s64 tv_sec;
 	__s64 tv_usec;
diff --git a/kernel/time/itimer.c b/kernel/time/itimer.c
index 9e59c9ea92aa..ca4e6d57d68b 100644
--- a/kernel/time/itimer.c
+++ b/kernel/time/itimer.c
@@ -97,20 +97,20 @@ static int do_getitimer(int which, struct itimerspec64 *value)
 	return 0;
 }
 
-static int put_itimerval(struct itimerval __user *o,
+static int put_itimerval(struct __kernel_old_itimerval __user *o,
 			 const struct itimerspec64 *i)
 {
-	struct itimerval v;
+	struct __kernel_old_itimerval v;
 
 	v.it_interval.tv_sec = i->it_interval.tv_sec;
 	v.it_interval.tv_usec = i->it_interval.tv_nsec / NSEC_PER_USEC;
 	v.it_value.tv_sec = i->it_value.tv_sec;
 	v.it_value.tv_usec = i->it_value.tv_nsec / NSEC_PER_USEC;
-	return copy_to_user(o, &v, sizeof(struct itimerval)) ? -EFAULT : 0;
+	return copy_to_user(o, &v, sizeof(struct __kernel_old_itimerval)) ? -EFAULT : 0;
 }
 
 
-SYSCALL_DEFINE2(getitimer, int, which, struct itimerval __user *, value)
+SYSCALL_DEFINE2(getitimer, int, which, struct __kernel_old_itimerval __user *, value)
 {
 	struct itimerspec64 get_buffer;
 	int error = do_getitimer(which, &get_buffer);
@@ -314,11 +314,11 @@ SYSCALL_DEFINE1(alarm, unsigned int, seconds)
 
 #endif
 
-static int get_itimerval(struct itimerspec64 *o, const struct itimerval __user *i)
+static int get_itimerval(struct itimerspec64 *o, const struct __kernel_old_itimerval __user *i)
 {
-	struct itimerval v;
+	struct __kernel_old_itimerval v;
 
-	if (copy_from_user(&v, i, sizeof(struct itimerval)))
+	if (copy_from_user(&v, i, sizeof(struct __kernel_old_itimerval)))
 		return -EFAULT;
 
 	/* Validate the timevals in value. */
@@ -333,8 +333,8 @@ static int get_itimerval(struct itimerspec64 *o, const struct itimerval __user *
 	return 0;
 }
 
-SYSCALL_DEFINE3(setitimer, int, which, struct itimerval __user *, value,
-		struct itimerval __user *, ovalue)
+SYSCALL_DEFINE3(setitimer, int, which, struct __kernel_old_itimerval __user *, value,
+		struct __kernel_old_itimerval __user *, ovalue)
 {
 	struct itimerspec64 set_buffer, get_buffer;
 	int error;
-- 
2.20.0
