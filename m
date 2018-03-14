From: "Tautschnig, Michael" <tautschn@amazon.co.uk>
Subject: [PATCH] x86/sigreturn: use SYSCALL_DEFINE0
Date: Wed, 14 Mar 2018 09:41:42 +0000
Message-ID: <9C9981F4-0E5E-42A7-8788-70F3DEAD258D@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <BBB771763136B645B98AA59E70099F0B@amazon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "x86@kernel.org" <x86@kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jaswinder Singh <jaswinder@infradead.org>, Andi Kleen <ak@linux.intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

All definitions of syscalls in x86 except for those patched here have
already been using the appropriate SYSCALL_DEFINE*.

Signed-off-by: Michael Tautschnig <tautschn@amazon.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jaswinder Singh <jaswinder@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
---
 arch/x86/kernel/signal.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
