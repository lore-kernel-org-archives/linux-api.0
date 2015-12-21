From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: [PATCH v1 4/4] um: Add seccomp support
Date: Mon, 21 Dec 2015 01:03:29 +0100
Message-ID: <1450656209-2676-5-git-send-email-mic@digikod.net>
References: <1450656209-2676-1-git-send-email-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450656209-2676-1-git-send-email-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>, Nicolas Iooss <nicolas.iooss_linux-oWGTIYur0i8@public.gmane.org>, Anton Ivanov <aivanov-43mecJUBy8ZBDgjK7y7TUQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Meredydd Luff <meredydd@senatehouse.o>
List-Id: linux-api@vger.kernel.org

This brings SECCOMP_MODE_STRICT and SECCOMP_MODE_FILTER support through
prctl(2) and seccomp(2) to User-mode Linux for i386 and x86_64
subarchitectures.

secure_computing() is called first in handle_syscall() so that the
syscall emulation will be aborted quickly if matching a seccomp rule.

This is inspired from Meredydd Luff's patch
(https://gerrit.chromium.org/gerrit/21425).

Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 .../features/seccomp/seccomp-filter/arch-support.txt     |  2 +-
 arch/um/Kconfig.common                                   |  1 +
 arch/um/Kconfig.um                                       | 16 ++++++++=
++++++++
 arch/um/include/asm/thread_info.h                        |  2 ++
 arch/um/kernel/skas/syscall.c                            |  9 ++++++++=
+
 5 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/features/seccomp/seccomp-filter/arch-support=
=2Etxt b/Documentation/features/seccomp/seccomp-filter/arch-support.txt
index 76d39d6..4f66ec1 100644
--- a/Documentation/features/seccomp/seccomp-filter/arch-support.txt
+++ b/Documentation/features/seccomp/seccomp-filter/arch-support.txt
@@ -33,7 +33,7 @@
     |          sh: | TODO |
     |       sparc: | TODO |
     |        tile: |  ok  |
-    |          um: | TODO |
+    |          um: |  ok  |
     |   unicore32: | TODO |
     |         x86: |  ok  |
     |      xtensa: | TODO |
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index d195a87..cc00134 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -2,6 +2,7 @@ config UML
 	bool
 	default y
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_UID16
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select GENERIC_IRQ_SHOW
diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index 28a9885..4b2ed58 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -104,3 +104,19 @@ config PGTABLE_LEVELS
 	int
 	default 3 if 3_LEVEL_PGTABLES
 	default 2
+
+config SECCOMP
+	def_bool y
+	prompt "Enable seccomp to safely compute untrusted bytecode"
+	---help---
+	  This kernel feature is useful for number crunching applications
+	  that may need to compute untrusted bytecode during their
+	  execution. By using pipes or other transports made available to
+	  the process as file descriptors supporting the read/write
+	  syscalls, it's possible to isolate those applications in
+	  their own address space using seccomp. Once seccomp is
+	  enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
+	  and the task is only allowed to execute a few safe syscalls
+	  defined by each seccomp mode.
+
+	  If unsure, say Y.
diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/th=
read_info.h
index 53968aa..053baff 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -62,11 +62,13 @@ static inline struct thread_info *current_thread_in=
fo(void)
 #define TIF_SYSCALL_AUDIT	6
 #define TIF_RESTORE_SIGMASK	7
 #define TIF_NOTIFY_RESUME	8
+#define TIF_SECCOMP		9	/* secure computing */
=20
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
=20
 #endif
diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/syscal=
l.c
index 65f0d1a..af567da 100644
--- a/arch/um/kernel/skas/syscall.c
+++ b/arch/um/kernel/skas/syscall.c
@@ -5,6 +5,7 @@
=20
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
+#include <linux/seccomp.h>
 #include <kern_util.h>
 #include <sysdep/ptrace.h>
 #include <sysdep/ptrace_user.h>
@@ -20,6 +21,14 @@ void handle_syscall(struct uml_pt_regs *r)
 	/* Save the syscall register. */
 	UPT_SYSCALL_NR(r) =3D PT_SYSCALL_NR(r->gp);
=20
+	/* Do the secure computing check first; failures should be fast. */
+	if (secure_computing() =3D=3D -1) {
+		/* Do not put secure_computing() into syscall_trace_enter() to
+		 * avoid forced syscall return value.
+		 */
+		return;
+	}
+
 	if (syscall_trace_enter(regs)) {
 		result =3D -ENOSYS;
 		goto out;
--=20
2.6.4
