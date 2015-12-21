From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: [PATCH v1 2/4] selftests/seccomp: Remove the need for HAVE_ARCH_TRACEHOOK
Date: Mon, 21 Dec 2015 01:03:27 +0100
Message-ID: <1450656209-2676-3-git-send-email-mic@digikod.net>
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

Some architectures do not implement PTRACE_GETREGSET nor
PTRACE_SETREGSET (required by HAVE_ARCH_TRACEHOOK) but only implement
PTRACE_GETREGS and PTRACE_SETREGS (e.g. User-mode Linux).

This improve seccomp selftest portability for architectures without
HAVE_ARCH_TRACEHOOK support by defining a new trigger HAVE_GETREGS. For
now, this is only enabled for i386 and x86_64 architectures. This is
required to be able to run this tests on User-mode Linux.

Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
