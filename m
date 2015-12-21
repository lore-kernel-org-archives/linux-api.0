From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH v1 1/4] um: Fix ptrace GETREGS/SETREGS bugs
Date: Mon, 21 Dec 2015 01:03:26 +0100
Message-ID: <1450656209-2676-2-git-send-email-mic@digikod.net>
References: <1450656209-2676-1-git-send-email-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450656209-2676-1-git-send-email-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Jonathan Corbet <corbet@lwn.net>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuahkh@osg.samsung.com>, Chris Metcalf <cmetcalf@ezchip.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, James Hogan <james.hogan@imgtec.com>, Thomas Meyer <thomas@m3y3r.de>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Anton Ivanov <aivanov@brocade.com>, linux-doc@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-api@vger.kernel.org, Meredydd Luff <meredydd@senatehouse.o>
List-Id: linux-api@vger.kernel.org

This fix two related bugs:
* PTRACE_GETREGS doesn't get the right orig_ax (syscall) value
* PTRACE_SETREGS can't set the orig_ax value (erased by initial value)

Remove the now useless and error-prone get_syscall().

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
Cc: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: user-mode-linux-user@lists.sourceforge.net
Cc: Meredydd Luff <meredydd@senatehouse.org>
Cc: David Drysdale <drysdale@google.com>
---
 arch/um/kernel/skas/syscall.c   | 7 ++++++-
 arch/um/os-Linux/skas/process.c | 7 -------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/syscal=
l.c
index 1683b8e..65f0d1a 100644
--- a/arch/um/kernel/skas/syscall.c
+++ b/arch/um/kernel/skas/syscall.c
@@ -7,6 +7,7 @@
 #include <linux/ptrace.h>
 #include <kern_util.h>
 #include <sysdep/ptrace.h>
+#include <sysdep/ptrace_user.h>
 #include <sysdep/syscalls.h>
 #include <os.h>
=20
@@ -16,12 +17,16 @@ void handle_syscall(struct uml_pt_regs *r)
 	long result;
 	int syscall;
=20
+	/* Save the syscall register. */
+	UPT_SYSCALL_NR(r) =3D PT_SYSCALL_NR(r->gp);
+
 	if (syscall_trace_enter(regs)) {
 		result =3D -ENOSYS;
 		goto out;
 	}
=20
-	syscall =3D get_syscall(r);
+	/* Get the syscall after being potentially updated with ptrace. */
+	syscall =3D UPT_SYSCALL_NR(r);
=20
 	if ((syscall > __NR_syscall_max) || syscall < 0)
 		result =3D -ENOSYS;
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
--=20
2.6.4
