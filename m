From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v4 1/3] vfs: Define new syscall umask2.
Date: Wed, 13 Apr 2016 20:05:34 +0100
Message-ID: <1460574336-18930-2-git-send-email-rjones@redhat.com>
References: <1460574336-18930-1-git-send-email-rjones@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460574336-18930-1-git-send-email-rjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, josh@joshtriplett.org, xemul@parallels.com, sfr@canb.auug.org.au, milosz@adfin.com, rostedt@goodmis.org, arnd@arndb.de, ebiederm@xmission.com, gorcunov@openvz.org, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org, gorcunov@gmail.com, fw@deneb.enyo.de, walters@verbum.org
List-Id: linux-api@vger.kernel.org

Before this change it was not possible to read the umask of the
current process from a shared library in a way that is safe if the
process uses multiple threads.

Define a variation of the umask system call with a flags parameter.
If flags=0 it behaves like the old umask call.  If flags=UMASK_GET_MASK
it reads the umask of the current process without modifying it.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 include/linux/syscalls.h          |  1 +
 include/uapi/asm-generic/fcntl.h  |  2 ++
 include/uapi/asm-generic/unistd.h |  4 +++-
 kernel/sys.c                      | 18 +++++++++++++++++-
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d795472..939e969 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -659,6 +659,7 @@ asmlinkage long sys_prlimit64(pid_t pid, unsigned int resource,
 				struct rlimit64 __user *old_rlim);
 asmlinkage long sys_getrusage(int who, struct rusage __user *ru);
 asmlinkage long sys_umask(int mask);
+asmlinkage long sys_umask2(int mask, int flags);
 
 asmlinkage long sys_msgget(key_t key, int msgflg);
 asmlinkage long sys_msgsnd(int msqid, struct msgbuf __user *msgp,
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index e063eff..f6c5e5a 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -217,4 +217,6 @@ struct flock64 {
 };
 #endif
 
+#define UMASK_GET_MASK 1	/* umask2 should only return current umask */
+
 #endif /* _ASM_GENERIC_FCNTL_H */
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 2622b33..8a61471 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -717,9 +717,11 @@ __SYSCALL(__NR_membarrier, sys_membarrier)
 __SYSCALL(__NR_mlock2, sys_mlock2)
 #define __NR_copy_file_range 285
 __SYSCALL(__NR_copy_file_range, sys_copy_file_range)
+#define __NR_umask2 286
+__SYSCALL(__NR_umask2, sys_umask2)
 
 #undef __NR_syscalls
-#define __NR_syscalls 286
+#define __NR_syscalls 287
 
 /*
  * All syscalls below here should go away really,
diff --git a/kernel/sys.c b/kernel/sys.c
index cf8ba54..cf60091 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1643,12 +1643,28 @@ COMPAT_SYSCALL_DEFINE2(getrusage, int, who, struct compat_rusage __user *, ru)
 }
 #endif
 
-SYSCALL_DEFINE1(umask, int, mask)
+static int do_umask(int mask, int flags)
 {
+	if (flags & ~UMASK_GET_MASK)
+		return -EINVAL;
+
+	if (flags & UMASK_GET_MASK)
+		return current_umask();
+
 	mask = xchg(&current->fs->umask, mask & S_IRWXUGO);
 	return mask;
 }
 
+SYSCALL_DEFINE1(umask, int, mask)
+{
+	return do_umask(mask, 0);
+}
+
+SYSCALL_DEFINE2(umask2, int, mask, int, flags)
+{
+	return do_umask(mask, flags);
+}
+
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
 	struct fd exe;
-- 
2.7.4
