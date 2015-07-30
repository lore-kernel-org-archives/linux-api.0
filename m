From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH] userfaultfd: register syscall numbers for x86 32bit and x86-64 64bit
Date: Thu, 30 Jul 2015 17:34:27 +0200
Message-ID: <1438270467-13324-1-git-send-email-aarcange@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, "\\\"H. Peter Anvin\\\"" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Eric B Munson <emunson@akamai.com>, Pavel Emelyanov <xemul@parallels.com>, "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>
List-Id: linux-api@vger.kernel.org

This registers the official numbers of the userfaultfd syscall for x86
32bit and x86-64 64bit. This registration allows to ship kernels in
production using these two syscall numbers for userfaultfd.

Acked-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/entry/syscalls/syscall_32.tbl | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl | 1 +
 include/linux/syscalls.h               | 1 +
 kernel/sys_ni.c                        | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 25e3cf1..178c5c2 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -380,3 +380,4 @@
 371	i386	recvfrom		sys_recvfrom			compat_sys_recvfrom
 372	i386	recvmsg			sys_recvmsg			compat_sys_recvmsg
 373	i386	shutdown		sys_shutdown
+374	i386	userfaultfd		sys_userfaultfd
\ No newline at end of file
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 9ef32d5..81c4906 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -329,6 +329,7 @@
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
+323	common	userfaultfd		sys_userfaultfd
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b45c45b..0800131 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -810,6 +810,7 @@ asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_eventfd2(unsigned int count, int flags);
 asmlinkage long sys_memfd_create(const char __user *uname_ptr, unsigned int flags);
+asmlinkage long sys_userfaultfd(int flags);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 asmlinkage long sys_old_readdir(unsigned int, struct old_linux_dirent __user *, unsigned int);
 asmlinkage long sys_pselect6(int, fd_set __user *, fd_set __user *,
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 7995ef5..8b3e10ea 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -218,6 +218,7 @@ cond_syscall(compat_sys_timerfd_gettime);
 cond_syscall(sys_eventfd);
 cond_syscall(sys_eventfd2);
 cond_syscall(sys_memfd_create);
+cond_syscall(sys_userfaultfd);
 
 /* performance counters: */
 cond_syscall(sys_perf_event_open);
