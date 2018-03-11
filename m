From: "Tautschnig, Michael" <tautschn@amazon.co.uk>
Subject: [PATCH v2] x86: always use SYSCALL_DEFINE*
Date: Sun, 11 Mar 2018 09:43:37 +0000
Message-ID: <CA5F8E03-A6D6-4FD1-B891-57A290BDF53C@amazon.com>
References: <14A5C8D0-3F9D-486F-A20C-55849D70FC80@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14A5C8D0-3F9D-486F-A20C-55849D70FC80@amazon.com>
Content-Language: en-US
Content-ID: <EADCEAB9B50FFB43AF2CC26836F015FB@amazon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "x86@kernel.org" <x86@kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jaswinder Singh <jaswinder@infradead.org>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-api@vger.kernel.org

All syscall arguments are passed in as types of the same byte size as
unsigned long (width of full registers). Using a smaller type without a
cast may result in losing bits of information. SYSCALL_DEFINE* introduce
adequate type casts. All definitions of syscalls in x86 except for those
patched here have already been using the appropriate SYSCALL_DEFINE*.

Signed-off-by: Michael Tautschnig <tautschn@amazon.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jaswinder Singh <jaswinder@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/ioport.c | 3 ++-
 arch/x86/kernel/signal.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 2f72330..7db3d65 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -23,7 +23,8 @@
 /*
  * this changes the io permissions bitmap in the current task.
  */
-asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn=
_on)
+SYSCALL_DEFINE3(ioperm, unsigned long, from, unsigned long, num, int,
+		turn_on)
 {
 	struct thread_struct *t =3D &current->thread;
 	struct tss_struct *tss;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b9e00e8..40ba242 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -25,6 +25,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/uprobes.h>
 #include <linux/context_tracking.h>
+#include <linux/syscalls.h>

 #include <asm/processor.h>
 #include <asm/ucontext.h>
@@ -601,7 +602,7 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
  * Do a signal return; undo the signal stack.
  */
 #ifdef CONFIG_X86_32
-asmlinkage unsigned long sys_sigreturn(void)
+SYSCALL_DEFINE0(sigreturn)
 {
 	struct pt_regs *regs =3D current_pt_regs();
 	struct sigframe __user *frame;
@@ -633,7 +634,7 @@ asmlinkage unsigned long sys_sigreturn(void)
 }
 #endif /* CONFIG_X86_32 */

-asmlinkage long sys_rt_sigreturn(void)
+SYSCALL_DEFINE0(rt_sigreturn)
 {
 	struct pt_regs *regs =3D current_pt_regs();
 	struct rt_sigframe __user *frame;
--
2.7.3.AMZN



Amazon Web Services UK Limited. Registered in England and Wales with regist=
ration number 08650665 with its registered office at 1 Principal Place, Wor=
ship Street, London, EC2A 2FA, United Kingdom.
