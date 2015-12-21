From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH v2 1/4] um: Fix ptrace GETREGS/SETREGS bugs
Date: Mon, 21 Dec 2015 20:29:20 +0100
Message-ID: <1450726163-8399-2-git-send-email-mic@digikod.net>
References: <1450726163-8399-1-git-send-email-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450726163-8399-1-git-send-email-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Jonathan Corbet <corbet@lwn.net>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuahkh@osg.samsung.com>, Chris Metcalf <cmetcalf@ezchip.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, James Hogan <james.hogan@imgtec.com>, Thomas Meyer <thomas@m3y3r.de>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Anton Ivanov <aivanov@brocade.com>, linux-doc@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-api@vger.kernel.org, Meredydd Luff <meredydd@senatehouse.o>
List-Id: linux-api@vger.kernel.org

This fix two related bugs:
* PTRACE_GETREGS doesn't get the right orig_ax (syscall) value
* PTRACE_SETREGS can't set the orig_ax value (erased by initial value)

Remove the now useless and error-prone get_syscall().

=46ix inconsistent behavior in the ptrace implementation for i386 when
updating orig_eax automatically update the syscall number as well. This
is now updated in handle_syscall().

Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Thomas Meyer <thomas@m3y3r.de>
Cc: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Anton Ivanov <aivanov@brocade.com>
Cc: Meredydd Luff <meredydd@senatehouse.org>
Cc: David Drysdale <drysdale@google.com>
---
 arch/um/kernel/skas/syscall.c   | 25 ++++++++++++++-----------
 arch/um/os-Linux/skas/process.c |  7 -------
 arch/x86/um/ptrace_32.c         |  8 +++-----
 3 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/syscal=
l.c
index 1683b8e..0d624e0 100644
--- a/arch/um/kernel/skas/syscall.c
+++ b/arch/um/kernel/skas/syscall.c
@@ -7,29 +7,32 @@
 #include <linux/ptrace.h>
 #include <kern_util.h>
 #include <sysdep/ptrace.h>
+#include <sysdep/ptrace_user.h>
 #include <sysdep/syscalls.h>
 #include <os.h>
=20
 void handle_syscall(struct uml_pt_regs *r)
 {
 	struct pt_regs *regs =3D container_of(r, struct pt_regs, regs);
-	long result;
 	int syscall;
=20
-	if (syscall_trace_enter(regs)) {
-		result =3D -ENOSYS;
+	/* Initialize the syscall number and default return value. */
+	UPT_SYSCALL_NR(r) =3D PT_SYSCALL_NR(r->gp);
+	PT_REGS_SET_SYSCALL_RETURN(regs, -ENOSYS);
+
+	if (syscall_trace_enter(regs))
 		goto out;
-	}
=20
-	syscall =3D get_syscall(r);
+	/* Update the syscall number after orig_ax has potentially been updat=
ed
+	 * with ptrace.
+	 */
+	UPT_SYSCALL_NR(r) =3D PT_SYSCALL_NR(r->gp);
+	syscall =3D UPT_SYSCALL_NR(r);
=20
-	if ((syscall > __NR_syscall_max) || syscall < 0)
-		result =3D -ENOSYS;
-	else
-		result =3D EXECUTE_SYSCALL(syscall, regs);
+	if (syscall >=3D 0 && syscall <=3D __NR_syscall_max)
+		PT_REGS_SET_SYSCALL_RETURN(regs,
+				EXECUTE_SYSCALL(syscall, regs));
=20
 out:
-	PT_REGS_SET_SYSCALL_RETURN(regs, result);
-
 	syscall_trace_leave(regs);
 }
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/pr=
ocess.c
index b856c66..23025d6 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -172,13 +172,6 @@ static void handle_trap(int pid, struct uml_pt_reg=
s *regs,
 	handle_syscall(regs);
 }
=20
-int get_syscall(struct uml_pt_regs *regs)
-{
-	UPT_SYSCALL_NR(regs) =3D PT_SYSCALL_NR(regs->gp);
-
-	return UPT_SYSCALL_NR(regs);
-}
-
 extern char __syscall_stub_start[];
=20
 static int userspace_tramp(void *stack)
diff --git a/arch/x86/um/ptrace_32.c b/arch/x86/um/ptrace_32.c
index a29756f..47c78d5 100644
--- a/arch/x86/um/ptrace_32.c
+++ b/arch/x86/um/ptrace_32.c
@@ -68,6 +68,7 @@ static const int reg_offsets[] =3D {
 	[EFL] =3D HOST_EFLAGS,
 	[UESP] =3D HOST_SP,
 	[SS] =3D HOST_SS,
+	[ORIG_EAX] =3D HOST_ORIG_AX,
 };
=20
 int putreg(struct task_struct *child, int regno, unsigned long value)
@@ -83,6 +84,7 @@ int putreg(struct task_struct *child, int regno, unsi=
gned long value)
 	case EAX:
 	case EIP:
 	case UESP:
+	case ORIG_EAX:
 		break;
 	case FS:
 		if (value && (value & 3) !=3D 3)
@@ -108,9 +110,6 @@ int putreg(struct task_struct *child, int regno, un=
signed long value)
 		value &=3D FLAG_MASK;
 		child->thread.regs.regs.gp[HOST_EFLAGS] |=3D value;
 		return 0;
-	case ORIG_EAX:
-		child->thread.regs.regs.syscall =3D value;
-		return 0;
 	default :
 		panic("Bad register in putreg() : %d\n", regno);
 	}
@@ -143,8 +142,6 @@ unsigned long getreg(struct task_struct *child, int=
 regno)
=20
 	regno >>=3D 2;
 	switch (regno) {
-	case ORIG_EAX:
-		return child->thread.regs.regs.syscall;
 	case FS:
 	case GS:
 	case DS:
@@ -163,6 +160,7 @@ unsigned long getreg(struct task_struct *child, int=
 regno)
 	case EDI:
 	case EBP:
 	case EFL:
+	case ORIG_EAX:
 		break;
 	default:
 		panic("Bad register in getreg() : %d\n", regno);
--=20
2.6.4
