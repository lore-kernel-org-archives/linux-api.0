From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH v2 2/4] selftests/seccomp: Remove the need for HAVE_ARCH_TRACEHOOK
Date: Mon, 21 Dec 2015 20:29:21 +0100
Message-ID: <1450726163-8399-3-git-send-email-mic@digikod.net>
References: <1450726163-8399-1-git-send-email-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1450726163-8399-1-git-send-email-mic@digikod.net>
Sender: linux-doc-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Jonathan Corbet <corbet@lwn.net>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuahkh@osg.samsung.com>, Chris Metcalf <cmetcalf@ezchip.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, James Hogan <james.hogan@imgtec.com>, Thomas Meyer <thomas@m3y3r.de>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Anton Ivanov <aivanov@brocade.com>, linux-doc@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-api@vger.kernel.org, Meredydd Luff <meredydd@senatehouse.o>
List-Id: linux-api@vger.kernel.org

Some architectures do not implement PTRACE_GETREGSET nor
PTRACE_SETREGSET (required by HAVE_ARCH_TRACEHOOK) but only implement
PTRACE_GETREGS and PTRACE_SETREGS (e.g. User-mode Linux).

This improve seccomp selftest portability for architectures without
HAVE_ARCH_TRACEHOOK support by defining a new trigger HAVE_GETREGS. For
now, this is only enabled for i386 and x86_64 architectures. This is
required to be able to run this tests on User-mode Linux.

Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Meredydd Luff <meredydd@senatehouse.org>
Cc: David Drysdale <drysdale@google.com>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 27 +++++++++++++++++++=
+++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/test=
ing/selftests/seccomp/seccomp_bpf.c
index 882fe83..b9453b8 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1246,11 +1246,24 @@ TEST_F(TRACE_poke, getpid_runs_normally)
 # error "Do not know how to find your architecture's registers and sys=
calls"
 #endif
=20
+/* Use PTRACE_GETREGS and PTRACE_SETREGS when available. This is usefu=
l for
+ * architectures without HAVE_ARCH_TRACEHOOK (e.g. User-mode Linux).
+ */
+#if defined(__x86_64__) || defined(__i386__)
+#define HAVE_GETREGS
+#endif
+
 /* Architecture-specific syscall fetching routine. */
 int get_syscall(struct __test_metadata *_metadata, pid_t tracee)
 {
-	struct iovec iov;
 	ARCH_REGS regs;
+#ifdef HAVE_GETREGS
+	EXPECT_EQ(0, ptrace(PTRACE_GETREGS, tracee, 0, &regs)) {
+		TH_LOG("PTRACE_GETREGS failed");
+		return -1;
+	}
+#else
+	struct iovec iov;
=20
 	iov.iov_base =3D &regs;
 	iov.iov_len =3D sizeof(regs);
@@ -1258,6 +1271,7 @@ int get_syscall(struct __test_metadata *_metadata=
, pid_t tracee)
 		TH_LOG("PTRACE_GETREGSET failed");
 		return -1;
 	}
+#endif
=20
 	return regs.SYSCALL_NUM;
 }
@@ -1266,13 +1280,16 @@ int get_syscall(struct __test_metadata *_metada=
ta, pid_t tracee)
 void change_syscall(struct __test_metadata *_metadata,
 		    pid_t tracee, int syscall)
 {
-	struct iovec iov;
 	int ret;
 	ARCH_REGS regs;
-
+#ifdef HAVE_GETREGS
+	ret =3D ptrace(PTRACE_GETREGS, tracee, 0, &regs);
+#else
+	struct iovec iov;
 	iov.iov_base =3D &regs;
 	iov.iov_len =3D sizeof(regs);
 	ret =3D ptrace(PTRACE_GETREGSET, tracee, NT_PRSTATUS, &iov);
+#endif
 	EXPECT_EQ(0, ret);
=20
 #if defined(__x86_64__) || defined(__i386__) || defined(__powerpc__) |=
| \
@@ -1312,9 +1329,13 @@ void change_syscall(struct __test_metadata *_met=
adata,
 	if (syscall =3D=3D -1)
 		regs.SYSCALL_RET =3D 1;
=20
+#ifdef HAVE_GETREGS
+	ret =3D ptrace(PTRACE_SETREGS, tracee, 0, &regs);
+#else
 	iov.iov_base =3D &regs;
 	iov.iov_len =3D sizeof(regs);
 	ret =3D ptrace(PTRACE_SETREGSET, tracee, NT_PRSTATUS, &iov);
+#endif
 	EXPECT_EQ(0, ret);
 }
=20
--=20
2.6.4

