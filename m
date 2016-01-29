From: Kees Cook <keescook@chromium.org>
Subject: [RFC][PATCH] seccomp: add SECCOMP_RET_ACK for non-fatal SIGSYS
Date: Thu, 28 Jan 2016 17:06:51 -0800
Message-ID: <20160129010651.GA13228@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-doc-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: jeffv@google.com, Andy Lutomirski <luto@amacapital.net>, oleg@redhat.com, Will Drewry <wad@chromium.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Tracing processes for syscall usage can be done one step at a time with
SECCOMP_RET_TRAP, but this will block the syscall. Alternatively, using
a ptrace manager to handle SECCOMP_RET_TRACE returns can be used but is
heavy weight and depends on the ptrace infrastructure. A light-weight
method to learn syscalls is needed, which can reuse the existing delivery
of SIGSYS but without skipping the syscall. This is implemented as
SECCOMP_RET_ACK which is as permissive as SECCOMP_RET_ALLOW but delivers
SIGSYS after syscall completion, as long as the SECCOMP_RET_DATA is
non-zero. A signal handler can install a new rule for each syscall as
they are signaled with SECCOMP_RET_DATA set to 0 to disable reporting
for that syscall in the future (which is required for restarting syscalls
that are signal-sensitive like nanosleep).

Registers from the signal will reflect registers after the syscall returns
rather than before. Signal-sensitive syscalls will trigger EINTR, so they
must be whitelisted before they are resumed. Not allowing the sigreturn
syscall (and likely prctl to whitelist) will make using SECCOMP_RET_ACK
useless.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
I don't like the name SECCOMP_RET_ACK, and SECCOMP_RET_ALLOW_SIGSYS
seems too long. SECCOMP_RET_RAISE? SECCOMP_RET_SIGSYS?
---
 Documentation/prctl/seccomp_filter.txt | 16 ++++++++++++++++
 include/uapi/linux/seccomp.h           |  1 +
 kernel/seccomp.c                       |  5 +++++
 3 files changed, 22 insertions(+)

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
index 1e469ef75778..847da72d94f4 100644
--- a/Documentation/prctl/seccomp_filter.txt
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -138,6 +138,22 @@ SECCOMP_RET_TRACE:
 	allow use of ptrace, even of other sandboxed processes, without
 	extreme care; ptracers can use this mechanism to escape.)
 
+SECCOMP_RET_ACK:
+	When the SECCOMP_RET_DATA portion is 0, this is the same
+	as SECCOMP_RET_ALLOW. When non-zero, this is the same as
+	SECCOMP_RET_TRAP except the syscall is executed normally
+	and register contents will show the state after the syscall.
+
+	For syscalls that are sensitive to pending signals, the
+	raised signal will interrupt the syscall. If these syscalls
+	are restarted immediately, they will loop forever. Users of
+	SECCOMP_RET_ACK need to add a new filter for each syscall
+	that sets a zero SECCOMP_RET_DATA to disable these kinds of
+	syscalls if they are not explicitly whitelisted to being with.
+
+	Whitelisting sigreturn (and likely prctl) is needed to use
+	SECCOMP_RET_ACK in a meaningful way.
+
 SECCOMP_RET_ALLOW:
 	Results in the system call being executed.
 
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 0f238a43ff1e..285cd3a04052 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -29,6 +29,7 @@
 #define SECCOMP_RET_TRAP	0x00030000U /* disallow and force a SIGSYS */
 #define SECCOMP_RET_ERRNO	0x00050000U /* returns an errno */
 #define SECCOMP_RET_TRACE	0x7ff00000U /* pass to a tracer or disallow */
+#define SECCOMP_RET_ACK		0x7ffc0000U /* allow and send SIGSYS */
 #define SECCOMP_RET_ALLOW	0x7fff0000U /* allow */
 
 /* Masks for the return value sections. */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 580ac2d4024f..6eefbb2060d8 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -608,6 +608,11 @@ static u32 __seccomp_phase1_filter(int this_syscall, struct seccomp_data *sd)
 	case SECCOMP_RET_TRACE:
 		return filter_ret;  /* Save the rest for phase 2. */
 
+	case SECCOMP_RET_ACK:
+		/* Post SIGSYS on syscall return, with 16 bits of data. */
+		if (data)
+			seccomp_send_sigsys(this_syscall, data);
+		/* Fall through. */
 	case SECCOMP_RET_ALLOW:
 		return SECCOMP_PHASE1_OK;
 
-- 
2.6.3


-- 
Kees Cook
Chrome OS & Brillo Security
