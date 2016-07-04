From: "Tautschnig, Michael" <tautschn@amazon.co.uk>
Subject: [PATCH] Syscall arguments are unsigned long (full registers)
Date: Mon, 4 Jul 2016 13:52:58 +0000
Message-ID: <A9946D15-1553-417B-BD0C-6C65AA2122B3@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <DD28BFB5DAB7C141BCF539C0ECF7C113@ant.amazon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "x86@kernel.org" <x86@kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jaswinder Singh <jaswinder@infradead.org>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-api@vger.kernel.org

All syscall arguments are passed in as types of the same byte size as
unsigned long (width of full registers). Using a smaller type without a
cast may result in losing bits of information. In all other instances
apart from the ones fixed by the patch the code explicitly introduces
type casts (using, e.g., SYSCALL_DEFINE1).

While goto-cc reported these problems at build time, it is noteworthy
that the calling conventions specified in the System V AMD64 ABI do
ensure that parameters 1-6 are passed via registers, thus there is no
implied risk of misaligned stack access.

Signed-off-by: Michael Tautschnig <tautschn@amazon.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jaswinder Singh <jaswinder@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/syscalls.h | 4 ++--
 arch/x86/kernel/ioport.c        | 2 +-
 arch/x86/kernel/process_64.c    | 2 +-
 include/linux/syscalls.h        | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 91dfcaf..7dc3161 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -17,7 +17,7 @@

 /* Common in X86_32 and X86_64 */
 /* kernel/ioport.c */
-asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
+asmlinkage long sys_ioperm(unsigned long, unsigned long, unsigned long);
 asmlinkage long sys_iopl(unsigned int);

 /* kernel/ldt.c */
@@ -45,7 +45,7 @@ asmlinkage long sys_vm86(unsigned long, unsigned long);

 /* X86_64 only */
 /* kernel/process_64.c */
-asmlinkage long sys_arch_prctl(int, unsigned long);
+asmlinkage long sys_arch_prctl(unsigned long, unsigned long);

 /* kernel/sys_x86_64.c */
 asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 589b319..ae8ce91 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -20,7 +20,7 @@
 /*
  * this changes the io permissions bitmap in the current task.
  */
-asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
+asmlinkage long sys_ioperm(unsigned long from, unsigned long num, unsigned long turn_on)
 {
 	struct thread_struct *t = &current->thread;
 	struct tss_struct *tss;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6e789ca..a4ec3e3 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -585,7 +585,7 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 	return ret;
 }

-long sys_arch_prctl(int code, unsigned long addr)
+long sys_arch_prctl(unsigned long code, unsigned long addr)
 {
 	return do_arch_prctl(current, code, addr);
 }
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d022390..ca3c03d 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -492,7 +492,7 @@ asmlinkage long sys_pipe2(int __user *fildes, int flags);
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
 asmlinkage long sys_dup3(unsigned int oldfd, unsigned int newfd, int flags);
-asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int on);
+asmlinkage long sys_ioperm(unsigned long from, unsigned long num, unsigned long on);
 asmlinkage long sys_ioctl(unsigned int fd, unsigned int cmd,
 				unsigned long arg);
 asmlinkage long sys_flock(unsigned int fd, unsigned int cmd);
--
2.7.3.AMZN
