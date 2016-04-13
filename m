From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v3 1/2] vfs: Define new syscall getumask.
Date: Wed, 13 Apr 2016 14:57:56 +0100
Message-ID: <1460555877-12950-2-git-send-email-rjones@redhat.com>
References: <1460555877-12950-1-git-send-email-rjones@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460555877-12950-1-git-send-email-rjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, josh@joshtriplett.org, xemul@parallels.com, sfr@canb.auug.org.au, milosz@adfin.com, rostedt@goodmis.org, arnd@arndb.de, ebiederm@xmission.com, gorcunov@openvz.org, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org, gorcunov@gmail.com, fw@deneb.enyo.de
List-Id: linux-api@vger.kernel.org

Define a system call for reading the current umask value.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 include/linux/syscalls.h          | 1 +
 include/uapi/asm-generic/unistd.h | 4 +++-
 kernel/sys.c                      | 5 +++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d795472..e96e88f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -659,6 +659,7 @@ asmlinkage long sys_prlimit64(pid_t pid, unsigned int resource,
 				struct rlimit64 __user *old_rlim);
 asmlinkage long sys_getrusage(int who, struct rusage __user *ru);
 asmlinkage long sys_umask(int mask);
+asmlinkage long sys_getumask(void);
 
 asmlinkage long sys_msgget(key_t key, int msgflg);
 asmlinkage long sys_msgsnd(int msqid, struct msgbuf __user *msgp,
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 2622b33..e59e880 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -717,9 +717,11 @@ __SYSCALL(__NR_membarrier, sys_membarrier)
 __SYSCALL(__NR_mlock2, sys_mlock2)
 #define __NR_copy_file_range 285
 __SYSCALL(__NR_copy_file_range, sys_copy_file_range)
+#define __NR_getumask 286
+__SYSCALL(__NR_getumask, sys_getumask)
 
 #undef __NR_syscalls
-#define __NR_syscalls 286
+#define __NR_syscalls 287
 
 /*
  * All syscalls below here should go away really,
diff --git a/kernel/sys.c b/kernel/sys.c
index cf8ba54..9db526c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1649,6 +1649,11 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
+SYSCALL_DEFINE0(getumask)
+{
+	return current_umask();
+}
+
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
 	struct fd exe;
-- 
2.7.4
