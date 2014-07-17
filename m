From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC -v2] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 17:38:20 -0400
Message-ID: <1405633100-4889-1-git-send-email-tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, beck@openbsd.org, Theodore Ts'o <tytso@mit.edu>
List-Id: linux-api@vger.kernel.org

The getrandom(2) system call was requested by the LibreSSL Portable
developers.  It is analoguous to the getentropy(2) system call in
OpenBSD.

The rationale of this system call is to provide resiliance against
file descriptor exhaustion attacks, where the attacker consumes all
available file descriptors, forcing the use of the fallback code where
/dev/[u]random is not available.  Since the fallback code is often not
well-tested, it is better to eliminate this potential failure mode
entirely.

The other feature provided by this new system call is the ability to
request randomness from the /dev/urandom entropy pool, but to block
until at least 128 bits of entropy has been accumulated in the
/dev/urandom entropy pool.  Historically, the emphasis in the
/dev/urandom development has been to ensure that urandom pool is
initialized as quickly as possible after system boot, and preferably
before the init scripts start execution.  This is because changing
/dev/urandom reads to block represents an interface change that could
potentially break userspace which is not acceptable.  In practice, on
most x86 desktop and server systems, in general the entropy pool can
be initialized before it is needed (and in modern kernels, we will
printk a warning message if not).  However, on an embedded system,
this may not be hte case.  And so with a new interface, we can provide
this requested functionality of blocking until the urandom pool has
been initialized.  Any userspace program which uses this new
functionality must make sure that if it is used in early boot, that it
will not cause the boot up scripts or other portions of the system
startup to hang indefinitely.

SYNOPSIS
	#include <linux/random.h>

	int getrandom(void *buf, size_t buflen, unsigned int flags);

DESCRIPTION
	The system call getrandom() fills the buffer pointed to by buf
	with up to buflen random bytes which can be used to seed user
	space random number generators (i.e., DRBG's) or for other
	cryptographic processes.  It should not be used Monte Carlo
	simulations or for other probabilistic sampling applications.

	If the GRND_RANDOM flags bit is set, then draw from the
	/dev/random pool instead of the /dev/urandom pool.  The
	/dev/random pool is limited based on the entropy that can be
	obtained from environmental noise, so if there is insufficient
	entropy, the requested number of bytes may not be returned.
	If there is no entropy available at all, getrandom(2) will
	either block, or return an error with errno set to EAGAIN if
	the GRND_NONBLOCK bit is set in flags.

	If the GRND_RANDOM bit is not set, then the /dev/urandom pool
	will be used.  Unlike using read(2) to fetch data from
	/dev/urandom, if the urandom pool has not been sufficiently
	initialized, getrandom(2) will block or return -1 with the
	errno set to EGAIN if the GRND_NONBLOCK bit is set in flags.

	The getentropy(2) system call in OpenBSD can be emulated using
	the following function:

	    int getentropy(void *buf, size_t buflen)
	    {
	            int     ret;

		    ret = getentropy(buf, buflen, 0);
		    return (ret > 0) ? 0 : ret;
	    }

RETURN VALUE
       On success, the number of bytes that was filled in the buf is
       returned.  This may not be all the bytes requested by the
       caller via buflen if insufficient entropy was present in the
       /dev/random pool, or if the system call was interrupted by a
       signal.

       On error, -1 is returned, and errno is set appropriately.

ERRORS
	EINVAL		An invalid flag was passed to getrandom(2)

	EFAULT		buf is outside your accessible address space.

	EAGAIN		The requested entropy was not available, and the
			getentropy(2) would have blocked if GRND_BLOCK flag
			was set.

	EINTR		While blocked waiting for entropy, the call was
			interrupted by a signal handler; see the description
			of how interrupted read(2) calls on "slow" devices
			are handled with and without the SA_RESTART flag
			in the signal(7) man page.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 arch/x86/syscalls/syscall_32.tbl  |  1 +
 arch/x86/syscalls/syscall_64.tbl  |  1 +
 drivers/char/random.c             | 39 +++++++++++++++++++++++++++++++++++++--
 include/linux/syscalls.h          |  3 +++
 include/uapi/asm-generic/unistd.h |  4 +++-
 include/uapi/linux/random.h       |  9 +++++++++
 6 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index d6b8679..f484e39 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -360,3 +360,4 @@
 351	i386	sched_setattr		sys_sched_setattr
 352	i386	sched_getattr		sys_sched_getattr
 353	i386	renameat2		sys_renameat2
+354	i386	getrandom		sys_getrandom
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index ec255a1..6705032 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -323,6 +323,7 @@
 314	common	sched_setattr		sys_sched_setattr
 315	common	sched_getattr		sys_sched_getattr
 316	common	renameat2		sys_renameat2
+317	common	getrandom		sys_getrandom
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/drivers/char/random.c b/drivers/char/random.c
index aa22fe5..3c8429e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -258,6 +258,8 @@
 #include <linux/kmemcheck.h>
 #include <linux/workqueue.h>
 #include <linux/irq.h>
+#include <linux/syscalls.h>
+#include <linux/completion.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
@@ -469,6 +471,8 @@ static struct entropy_store nonblocking_pool = {
 					push_to_pool),
 };
 
+static DECLARE_COMPLETION(urandom_initialized);
+
 static __u32 const twist_table[8] = {
 	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
@@ -657,6 +661,7 @@ retry:
 		r->entropy_total = 0;
 		if (r == &nonblocking_pool) {
 			prandom_reseed_late();
+			complete_all(&urandom_initialized);
 			pr_notice("random: %s pool is initialized\n", r->name);
 		}
 	}
@@ -1355,7 +1360,7 @@ static int arch_random_refill(void)
 }
 
 static ssize_t
-random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+_random_read(int nonblock, char __user *buf, size_t nbytes)
 {
 	ssize_t n;
 
@@ -1379,7 +1384,7 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 		if (arch_random_refill())
 			continue;
 
-		if (file->f_flags & O_NONBLOCK)
+		if (nonblock)
 			return -EAGAIN;
 
 		wait_event_interruptible(random_read_wait,
@@ -1391,6 +1396,12 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 }
 
 static ssize_t
+random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+{
+	return _random_read(file->f_flags & O_NONBLOCK, buf, nbytes);
+}
+
+static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	int ret;
@@ -1533,6 +1544,30 @@ const struct file_operations urandom_fops = {
 	.llseek = noop_llseek,
 };
 
+SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
+		unsigned int, flags)
+{
+	int r;
+
+	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM))
+		return -EINVAL;
+
+	if (count > INT_MAX)
+		count = INT_MAX;
+
+	if (flags & GRND_RANDOM)
+		return _random_read(flags & GRND_NONBLOCK, buf, count);
+	if (flags & GRND_NONBLOCK) {
+		if (!completion_done(&urandom_initialized))
+			return -EAGAIN;
+	} else {
+		r = wait_for_completion_interruptible(&urandom_initialized);
+		if (r)
+			return r;
+	}
+	return urandom_read(NULL, buf, count, NULL);
+}
+
 /***************************************************************
  * Random UUID interface
  *
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b0881a0..cd82f72f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -866,4 +866,7 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
 asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
+asmlinkage long sys_getrandom(char __user * buf, size_t count,
+			      unsigned int flags);
+
 #endif
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 3336406..2926b1d 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -699,9 +699,11 @@ __SYSCALL(__NR_sched_setattr, sys_sched_setattr)
 __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
 #define __NR_renameat2 276
 __SYSCALL(__NR_renameat2, sys_renameat2)
+#define __NR_getrandom 277
+__SYSCALL(__NR_getrandom, sys_getrandom)
 
 #undef __NR_syscalls
-#define __NR_syscalls 277
+#define __NR_syscalls 278
 
 /*
  * All syscalls below here should go away really,
diff --git a/include/uapi/linux/random.h b/include/uapi/linux/random.h
index fff3528..3f93d16 100644
--- a/include/uapi/linux/random.h
+++ b/include/uapi/linux/random.h
@@ -40,4 +40,13 @@ struct rand_pool_info {
 	__u32	buf[0];
 };
 
+/*
+ * Flags for getrandom(2)
+ *
+ * GRND_NONBLOCK	Don't block and return EAGAIN instead
+ * GRND_RANDOM		Use the /dev/random pool instead of /dev/urandom
+ */
+#define GRND_NONBLOCK	0x0001
+#define GRND_RANDOM	0x0002
+
 #endif /* _UAPI_LINUX_RANDOM_H */
-- 
2.0.0
