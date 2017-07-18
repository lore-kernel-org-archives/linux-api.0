From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 7/7] signal: Remove kernel interal si_code magic
Date: Tue, 18 Jul 2017 09:06:51 -0500
Message-ID: <20170718140651.15973-7-ebiederm@xmission.com>
References: <87o9shg7t7.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87o9shg7t7.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

struct siginfo is a union and the kernel since 2.4 has been hiding a union
tag in the high 16bits of si_code using the values:
__SI_KILL
__SI_TIMER
__SI_POLL
__SI_FAULT
__SI_CHLD
__SI_RT
__SI_MESGQ
__SI_SYS

While this looks plausible on the surface, in practice this situation has
not worked well.

- Injected positive signals are not copied to user space properly
  unless they have these magic high bits set.

- Injected positive signals are not reported properly by signalfd
  unless they have these magic high bits set.

- These kernel internal values leaked to userspace via ptrace_peek_siginfo

- It was possible to inject these kernel internal values and cause the
  the kernel to misbehave.

- Kernel developers got confused and expected these kernel internal values
  in userspace in kernel self tests.

- Kernel developers got confused and set si_code to __SI_FAULT which
  is SI_USER in userspace which causes userspace to think an ordinary user
  sent the signal and that it was not kernel generated.

- The values make it impossible to reorganize the code to transform
  siginfo_copy_to_user into a plain copy_to_user.  As si_code must
  be massaged before being passed to userspace.

So remove these kernel internal si codes and make the kernel code simpler
and more maintainable.

To replace these kernel internal magic si_codes introduce the helper
function siginfo_layout, that takes a signal number and an si_code and
computes which union member of siginfo is being used.  Have
siginfo_layout return an enumeration so that gcc will have enough
information to warn if a switch statement does not handle all of union
members.

A couple of architectures have a messed up ABI that defines signal
specific duplications of SI_USER which causes more special cases in
siginfo_layout than I would like.  The good news is only problem
architectures pay the cost.

Update all of the code that used the previous magic __SI_ values to
use the new SIL_ values and to call siginfo_layout to get those
values.  Escept where not all of the cases are handled remove the
defaults in the switch statements so that if a new case is missed in
the future the lack will show up at compile time.

Modify the code that copies siginfo si_code to userspace to just copy
the value and not cast si_code to a short first.  The high bits are no
longer used to hold a magic union member.

Fixup the siginfo header files to stop including the __SI_ values in
their constants and for the headers that were missing it to properly
update the number of si_codes for each signal type.

The fixes to copy_siginfo_from_user32 implementations has the
interesting property that several of them perviously should never have
worked as the __SI_ values they depended up where kernel internal.
With that dependency gone those implementations should work much
better.

The idea of not passing the __SI_ values out to userspace and then
not reinserting them has been tested with criu and criu worked without
changes.

Ref: 2.4.0-test1
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 arch/alpha/include/uapi/asm/siginfo.h    |   4 +-
 arch/arm64/kernel/signal32.c             |  23 +++----
 arch/blackfin/include/uapi/asm/siginfo.h |  30 +++++---
 arch/frv/include/uapi/asm/siginfo.h      |   2 +-
 arch/ia64/include/uapi/asm/siginfo.h     |  20 +++---
 arch/ia64/kernel/signal.c                |  17 +++--
 arch/mips/include/uapi/asm/siginfo.h     |   6 +-
 arch/mips/kernel/signal32.c              |  19 +++--
 arch/parisc/kernel/signal32.c            |  31 ++++-----
 arch/powerpc/kernel/signal_32.c          |  20 +++---
 arch/s390/kernel/compat_signal.c         |  32 ++++-----
 arch/sparc/include/uapi/asm/siginfo.h    |   4 +-
 arch/sparc/kernel/signal32.c             |  16 ++---
 arch/tile/include/uapi/asm/siginfo.h     |   4 +-
 arch/tile/kernel/compat_signal.c         |  18 +++--
 arch/tile/kernel/traps.c                 |   2 +-
 arch/x86/kernel/signal_compat.c          |  21 +++---
 fs/signalfd.c                            |  22 +++---
 include/linux/signal.h                   |  14 ++++
 include/uapi/asm-generic/siginfo.h       | 115 +++++++++++++------------------
 kernel/exit.c                            |   4 +-
 kernel/ptrace.c                          |   6 +-
 kernel/signal.c                          |  72 ++++++++++++++-----
 23 files changed, 257 insertions(+), 245 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/siginfo.h b/arch/alpha/include/uapi/asm/siginfo.h
index 972f547d9e41..70494d1d8f29 100644
--- a/arch/alpha/include/uapi/asm/siginfo.h
+++ b/arch/alpha/include/uapi/asm/siginfo.h
@@ -10,14 +10,14 @@
  * SIGFPE si_codes
  */
 #ifdef __KERNEL__
-#define FPE_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
+#define FPE_FIXME	0	/* Broken dup of SI_USER */
 #endif /* __KERNEL__ */
 
 /*
  * SIGTRAP si_codes
  */
 #ifdef __KERNEL__
-#define TRAP_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
+#define TRAP_FIXME	0	/* Broken dup of SI_USER */
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index c747a0fc5d7d..9b95a935c21d 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -142,25 +142,25 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
 	 */
 	err = __put_user(from->si_signo, &to->si_signo);
 	err |= __put_user(from->si_errno, &to->si_errno);
-	err |= __put_user((short)from->si_code, &to->si_code);
+	err |= __put_user(from->si_code, &to->si_code);
 	if (from->si_code < 0)
 		err |= __copy_to_user(&to->_sifields._pad, &from->_sifields._pad,
 				      SI_PAD_SIZE);
-	else switch (from->si_code & __SI_MASK) {
-	case __SI_KILL:
+	else switch (siginfo_layout(from->si_signo, from->si_code)) {
+	case SIL_KILL:
 		err |= __put_user(from->si_pid, &to->si_pid);
 		err |= __put_user(from->si_uid, &to->si_uid);
 		break;
-	case __SI_TIMER:
+	case SIL_TIMER:
 		 err |= __put_user(from->si_tid, &to->si_tid);
 		 err |= __put_user(from->si_overrun, &to->si_overrun);
 		 err |= __put_user(from->si_int, &to->si_int);
 		break;
-	case __SI_POLL:
+	case SIL_POLL:
 		err |= __put_user(from->si_band, &to->si_band);
 		err |= __put_user(from->si_fd, &to->si_fd);
 		break;
-	case __SI_FAULT:
+	case SIL_FAULT:
 		err |= __put_user((compat_uptr_t)(unsigned long)from->si_addr,
 				  &to->si_addr);
 #ifdef BUS_MCEERR_AO
@@ -173,29 +173,24 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
 			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
 #endif
 		break;
-	case __SI_CHLD:
+	case SIL_CHLD:
 		err |= __put_user(from->si_pid, &to->si_pid);
 		err |= __put_user(from->si_uid, &to->si_uid);
 		err |= __put_user(from->si_status, &to->si_status);
 		err |= __put_user(from->si_utime, &to->si_utime);
 		err |= __put_user(from->si_stime, &to->si_stime);
 		break;
-	case __SI_RT: /* This is not generated by the kernel as of now. */
-	case __SI_MESGQ: /* But this is */
+	case SIL_RT:
 		err |= __put_user(from->si_pid, &to->si_pid);
 		err |= __put_user(from->si_uid, &to->si_uid);
 		err |= __put_user(from->si_int, &to->si_int);
 		break;
-	case __SI_SYS:
+	case SIL_SYS:
 		err |= __put_user((compat_uptr_t)(unsigned long)
 				from->si_call_addr, &to->si_call_addr);
 		err |= __put_user(from->si_syscall, &to->si_syscall);
 		err |= __put_user(from->si_arch, &to->si_arch);
 		break;
-	default: /* this is just in case for now ... */
-		err |= __put_user(from->si_pid, &to->si_pid);
-		err |= __put_user(from->si_uid, &to->si_uid);
-		break;
 	}
 	return err;
 }
diff --git a/arch/blackfin/include/uapi/asm/siginfo.h b/arch/blackfin/include/uapi/asm/siginfo.h
index c72f4e6e386f..79dfe3979123 100644
--- a/arch/blackfin/include/uapi/asm/siginfo.h
+++ b/arch/blackfin/include/uapi/asm/siginfo.h
@@ -14,28 +14,36 @@
 
 #define si_uid16	_sifields._kill._uid
 
-#define ILL_ILLPARAOP	(__SI_FAULT|2)	/* illegal opcode combine ********** */
-#define ILL_ILLEXCPT	(__SI_FAULT|4)	/* unrecoverable exception ********** */
-#define ILL_CPLB_VI	(__SI_FAULT|9)	/* D/I CPLB protect violation ******** */
-#define ILL_CPLB_MISS	(__SI_FAULT|10)	/* D/I CPLB miss ******** */
-#define ILL_CPLB_MULHIT	(__SI_FAULT|11)	/* D/I CPLB multiple hit ******** */
+#define ILL_ILLPARAOP	2	/* illegal opcode combine ********** */
+#define ILL_ILLEXCPT	4	/* unrecoverable exception ********** */
+#define ILL_CPLB_VI	9	/* D/I CPLB protect violation ******** */
+#define ILL_CPLB_MISS	10	/* D/I CPLB miss ******** */
+#define ILL_CPLB_MULHIT	11	/* D/I CPLB multiple hit ******** */
+#undef NSIGILL
+#define NSIGILL         11
 
 /*
  * SIGBUS si_codes
  */
-#define BUS_OPFETCH	(__SI_FAULT|4)	/* error from instruction fetch ******** */
+#define BUS_OPFETCH	4	/* error from instruction fetch ******** */
+#undef NSIGBUS
+#define NSIGBUS		4
 
 /*
  * SIGTRAP si_codes
  */
-#define TRAP_STEP	(__SI_FAULT|1)	/* single-step breakpoint************* */
-#define TRAP_TRACEFLOW	(__SI_FAULT|2)	/* trace buffer overflow ************* */
-#define TRAP_WATCHPT	(__SI_FAULT|3)	/* watchpoint match      ************* */
-#define TRAP_ILLTRAP	(__SI_FAULT|4)	/* illegal trap          ************* */
+#define TRAP_STEP	1	/* single-step breakpoint************* */
+#define TRAP_TRACEFLOW	2	/* trace buffer overflow ************* */
+#define TRAP_WATCHPT	3	/* watchpoint match      ************* */
+#define TRAP_ILLTRAP	4	/* illegal trap          ************* */
+#undef NSIGTRAP
+#define NSIGTRAP	4
 
 /*
  * SIGSEGV si_codes
  */
-#define SEGV_STACKFLOW	(__SI_FAULT|3)	/* stack overflow */
+#define SEGV_STACKFLOW	3	/* stack overflow */
+#undef NSIGSEGV
+#define NSIGSEGV	3
 
 #endif /* _UAPI_BFIN_SIGINFO_H */
diff --git a/arch/frv/include/uapi/asm/siginfo.h b/arch/frv/include/uapi/asm/siginfo.h
index d3fd1ca45653..f55d9e0e9068 100644
--- a/arch/frv/include/uapi/asm/siginfo.h
+++ b/arch/frv/include/uapi/asm/siginfo.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 #include <asm-generic/siginfo.h>
 
-#define FPE_MDAOVF	(__SI_FAULT|9)	/* media overflow */
+#define FPE_MDAOVF	9	/* media overflow */
 #undef NSIGFPE
 #define NSIGFPE		9
 
diff --git a/arch/ia64/include/uapi/asm/siginfo.h b/arch/ia64/include/uapi/asm/siginfo.h
index 3282f8b992fc..33389fc36f23 100644
--- a/arch/ia64/include/uapi/asm/siginfo.h
+++ b/arch/ia64/include/uapi/asm/siginfo.h
@@ -98,9 +98,9 @@ typedef struct siginfo {
 /*
  * SIGILL si_codes
  */
-#define ILL_BADIADDR	(__SI_FAULT|9)	/* unimplemented instruction address */
-#define __ILL_BREAK	(__SI_FAULT|10)	/* illegal break */
-#define __ILL_BNDMOD	(__SI_FAULT|11)	/* bundle-update (modification) in progress */
+#define ILL_BADIADDR	9	/* unimplemented instruction address */
+#define __ILL_BREAK	10	/* illegal break */
+#define __ILL_BNDMOD	11	/* bundle-update (modification) in progress */
 #undef NSIGILL
 #define NSIGILL		11
 
@@ -108,20 +108,20 @@ typedef struct siginfo {
  * SIGFPE si_codes
  */
 #ifdef __KERNEL__
-#define FPE_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
+#define FPE_FIXME	0	/* Broken dup of SI_USER */
 #endif /* __KERNEL__ */
-#define __FPE_DECOVF	(__SI_FAULT|9)	/* decimal overflow */
-#define __FPE_DECDIV	(__SI_FAULT|10)	/* decimal division by zero */
-#define __FPE_DECERR	(__SI_FAULT|11)	/* packed decimal error */
-#define __FPE_INVASC	(__SI_FAULT|12)	/* invalid ASCII digit */
-#define __FPE_INVDEC	(__SI_FAULT|13)	/* invalid decimal digit */
+#define __FPE_DECOVF	9	/* decimal overflow */
+#define __FPE_DECDIV	10	/* decimal division by zero */
+#define __FPE_DECERR	11	/* packed decimal error */
+#define __FPE_INVASC	12	/* invalid ASCII digit */
+#define __FPE_INVDEC	13	/* invalid decimal digit */
 #undef NSIGFPE
 #define NSIGFPE		13
 
 /*
  * SIGSEGV si_codes
  */
-#define __SEGV_PSTKOVF	(__SI_FAULT|4)	/* paragraph stack overflow */
+#define __SEGV_PSTKOVF	4	/* paragraph stack overflow */
 #undef NSIGSEGV
 #define NSIGSEGV	4
 
diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 5db52c6813c4..6146d53b6ad7 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -124,31 +124,30 @@ copy_siginfo_to_user (siginfo_t __user *to, const siginfo_t *from)
 		 */
 		err = __put_user(from->si_signo, &to->si_signo);
 		err |= __put_user(from->si_errno, &to->si_errno);
-		err |= __put_user((short)from->si_code, &to->si_code);
-		switch (from->si_code >> 16) {
-		      case __SI_FAULT >> 16:
+		err |= __put_user(from->si_code, &to->si_code);
+		switch (siginfo_layout(from->si_signo, from->si_code)) {
+		      case SIL_FAULT:
 			err |= __put_user(from->si_flags, &to->si_flags);
 			err |= __put_user(from->si_isr, &to->si_isr);
-		      case __SI_POLL >> 16:
+		      case SIL_POLL:
 			err |= __put_user(from->si_addr, &to->si_addr);
 			err |= __put_user(from->si_imm, &to->si_imm);
 			break;
-		      case __SI_TIMER >> 16:
+		      case SIL_TIMER:
 			err |= __put_user(from->si_tid, &to->si_tid);
 			err |= __put_user(from->si_overrun, &to->si_overrun);
 			err |= __put_user(from->si_ptr, &to->si_ptr);
 			break;
-		      case __SI_RT >> 16:	/* Not generated by the kernel as of now.  */
-		      case __SI_MESGQ >> 16:
+		      case SIL_RT:
 			err |= __put_user(from->si_uid, &to->si_uid);
 			err |= __put_user(from->si_pid, &to->si_pid);
 			err |= __put_user(from->si_ptr, &to->si_ptr);
 			break;
-		      case __SI_CHLD >> 16:
+		      case SIL_CHLD:
 			err |= __put_user(from->si_utime, &to->si_utime);
 			err |= __put_user(from->si_stime, &to->si_stime);
 			err |= __put_user(from->si_status, &to->si_status);
-		      default:
+		      case SIL_KILL:
 			err |= __put_user(from->si_uid, &to->si_uid);
 			err |= __put_user(from->si_pid, &to->si_pid);
 			break;
diff --git a/arch/mips/include/uapi/asm/siginfo.h b/arch/mips/include/uapi/asm/siginfo.h
index 9becfd102132..22a86d84a504 100644
--- a/arch/mips/include/uapi/asm/siginfo.h
+++ b/arch/mips/include/uapi/asm/siginfo.h
@@ -120,14 +120,14 @@ typedef struct siginfo {
 #undef SI_TIMER
 #undef SI_MESGQ
 #define SI_ASYNCIO	-2	/* sent by AIO completion */
-#define SI_TIMER __SI_CODE(__SI_TIMER, -3) /* sent by timer expiration */
-#define SI_MESGQ __SI_CODE(__SI_MESGQ, -4) /* sent by real time mesq state change */
+#define SI_TIMER	-3	/* sent by timer expiration */
+#define SI_MESGQ	-4	/* sent by real time mesq state change */
 
 /*
  * SIGFPE si_codes
  */
 #ifdef __KERNEL__
-#define FPE_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
+#define FPE_FIXME	0	/* Broken dup of SI_USER */
 #endif /* __KERNEL__ */
 
 #endif /* _UAPI_ASM_SIGINFO_H */
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index 84165f2b31ff..cf5c7c05e5a3 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -93,38 +93,37 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
 	   at the same time.  */
 	err = __put_user(from->si_signo, &to->si_signo);
 	err |= __put_user(from->si_errno, &to->si_errno);
-	err |= __put_user((short)from->si_code, &to->si_code);
+	err |= __put_user(from->si_code, &to->si_code);
 	if (from->si_code < 0)
 		err |= __copy_to_user(&to->_sifields._pad, &from->_sifields._pad, SI_PAD_SIZE);
 	else {
-		switch (from->si_code >> 16) {
-		case __SI_TIMER >> 16:
+		switch (siginfo_layout(from->si_signo, from->si_code)) {
+		case SIL_TIMER:
 			err |= __put_user(from->si_tid, &to->si_tid);
 			err |= __put_user(from->si_overrun, &to->si_overrun);
 			err |= __put_user(from->si_int, &to->si_int);
 			break;
-		case __SI_CHLD >> 16:
+		case SIL_CHLD:
 			err |= __put_user(from->si_utime, &to->si_utime);
 			err |= __put_user(from->si_stime, &to->si_stime);
 			err |= __put_user(from->si_status, &to->si_status);
-		default:
+		case SIL_KILL:
 			err |= __put_user(from->si_pid, &to->si_pid);
 			err |= __put_user(from->si_uid, &to->si_uid);
 			break;
-		case __SI_FAULT >> 16:
+		case SIL_FAULT:
 			err |= __put_user((unsigned long)from->si_addr, &to->si_addr);
 			break;
-		case __SI_POLL >> 16:
+		case SIL_POLL:
 			err |= __put_user(from->si_band, &to->si_band);
 			err |= __put_user(from->si_fd, &to->si_fd);
 			break;
-		case __SI_RT >> 16: /* This is not generated by the kernel as of now.  */
-		case __SI_MESGQ >> 16:
+		case SIL_RT:
 			err |= __put_user(from->si_pid, &to->si_pid);
 			err |= __put_user(from->si_uid, &to->si_uid);
 			err |= __put_user(from->si_int, &to->si_int);
 			break;
-		case __SI_SYS >> 16:
+		case SIL_SYS:
 			err |= __copy_to_user(&to->si_call_addr, &from->si_call_addr,
 					      sizeof(compat_uptr_t));
 			err |= __put_user(from->si_syscall, &to->si_syscall);
diff --git a/arch/parisc/kernel/signal32.c b/arch/parisc/kernel/signal32.c
index 70aaabb8b3cb..9e0cb6a577d6 100644
--- a/arch/parisc/kernel/signal32.c
+++ b/arch/parisc/kernel/signal32.c
@@ -290,25 +290,25 @@ copy_siginfo_from_user32 (siginfo_t *to, compat_siginfo_t __user *from)
 	if (to->si_code < 0)
 		err |= __copy_from_user(&to->_sifields._pad, &from->_sifields._pad, SI_PAD_SIZE);
 	else {
-		switch (to->si_code >> 16) {
-		      case __SI_CHLD >> 16:
+		switch (siginfo_layout(to->si_signo, to->si_code)) {
+		      case SIL_CHLD:
 			err |= __get_user(to->si_utime, &from->si_utime);
 			err |= __get_user(to->si_stime, &from->si_stime);
 			err |= __get_user(to->si_status, &from->si_status);
 		      default:
+		      case SIL_KILL:
 			err |= __get_user(to->si_pid, &from->si_pid);
 			err |= __get_user(to->si_uid, &from->si_uid);
 			break;
-		      case __SI_FAULT >> 16:
+		      case SIL_FAULT:
 			err |= __get_user(addr, &from->si_addr);
 			to->si_addr = compat_ptr(addr);
 			break;
-		      case __SI_POLL >> 16:
+		      case SIL_POLL:
 			err |= __get_user(to->si_band, &from->si_band);
 			err |= __get_user(to->si_fd, &from->si_fd);
 			break;
-		      case __SI_RT >> 16: /* This is not generated by the kernel as of now.  */
-		      case __SI_MESGQ >> 16:
+		      case SIL_RT:
 			err |= __get_user(to->si_pid, &from->si_pid);
 			err |= __get_user(to->si_uid, &from->si_uid);
 			err |= __get_user(to->si_int, &from->si_int);
@@ -337,41 +337,40 @@ copy_siginfo_to_user32 (compat_siginfo_t __user *to, const siginfo_t *from)
 	   at the same time.  */
 	err = __put_user(from->si_signo, &to->si_signo);
 	err |= __put_user(from->si_errno, &to->si_errno);
-	err |= __put_user((short)from->si_code, &to->si_code);
+	err |= __put_user(from->si_code, &to->si_code);
 	if (from->si_code < 0)
 		err |= __copy_to_user(&to->_sifields._pad, &from->_sifields._pad, SI_PAD_SIZE);
 	else {
-		switch (from->si_code >> 16) {
-		case __SI_CHLD >> 16:
+		switch (siginfo_layout(from->si_signo, from->si_code)) {
+		case SIL_CHLD:
 			err |= __put_user(from->si_utime, &to->si_utime);
 			err |= __put_user(from->si_stime, &to->si_stime);
 			err |= __put_user(from->si_status, &to->si_status);
-		default:
+		case SIL_KILL:
 			err |= __put_user(from->si_pid, &to->si_pid);
 			err |= __put_user(from->si_uid, &to->si_uid);
 			break;
-		case __SI_FAULT >> 16:
+		case SIL_FAULT:
 			addr = ptr_to_compat(from->si_addr);
 			err |= __put_user(addr, &to->si_addr);
 			break;
-		case __SI_POLL >> 16:
+		case SIL_POLL:
 			err |= __put_user(from->si_band, &to->si_band);
 			err |= __put_user(from->si_fd, &to->si_fd);
 			break;
-		case __SI_TIMER >> 16:
+		case SIL_TIMER:
 			err |= __put_user(from->si_tid, &to->si_tid);
 			err |= __put_user(from->si_overrun, &to->si_overrun);
 			val = (compat_int_t)from->si_int;
 			err |= __put_user(val, &to->si_int);
 			break;
-		case __SI_RT >> 16:	/* Not generated by the kernel as of now.  */
-		case __SI_MESGQ >> 16:
+		case SIL_RT:
 			err |= __put_user(from->si_uid, &to->si_uid);
 			err |= __put_user(from->si_pid, &to->si_pid);
 			val = (compat_int_t)from->si_int;
 			err |= __put_user(val, &to->si_int);
 			break;
-		case __SI_SYS >> 16:
+		case SIL_SYS:
 			err |= __put_user(ptr_to_compat(from->si_call_addr), &to->si_call_addr);
 			err |= __put_user(from->si_syscall, &to->si_syscall);
 			err |= __put_user(from->si_arch, &to->si_arch);
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 97bb1385e771..92fb1c8dbbd8 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -913,42 +913,40 @@ int copy_siginfo_to_user32(struct compat_siginfo __user *d, const siginfo_t *s)
 	 */
 	err = __put_user(s->si_signo, &d->si_signo);
 	err |= __put_user(s->si_errno, &d->si_errno);
-	err |= __put_user((short)s->si_code, &d->si_code);
+	err |= __put_user(s->si_code, &d->si_code);
 	if (s->si_code < 0)
 		err |= __copy_to_user(&d->_sifields._pad, &s->_sifields._pad,
 				      SI_PAD_SIZE32);
-	else switch(s->si_code >> 16) {
-	case __SI_CHLD >> 16:
+	else switch(siginfo_layout(s->si_signo, s->si_code)) {
+	case SIL_CHLD:
 		err |= __put_user(s->si_pid, &d->si_pid);
 		err |= __put_user(s->si_uid, &d->si_uid);
 		err |= __put_user(s->si_utime, &d->si_utime);
 		err |= __put_user(s->si_stime, &d->si_stime);
 		err |= __put_user(s->si_status, &d->si_status);
 		break;
-	case __SI_FAULT >> 16:
+	case SIL_FAULT:
 		err |= __put_user((unsigned int)(unsigned long)s->si_addr,
 				  &d->si_addr);
 		break;
-	case __SI_POLL >> 16:
+	case SIL_POLL:
 		err |= __put_user(s->si_band, &d->si_band);
 		err |= __put_user(s->si_fd, &d->si_fd);
 		break;
-	case __SI_TIMER >> 16:
+	case SIL_TIMER:
 		err |= __put_user(s->si_tid, &d->si_tid);
 		err |= __put_user(s->si_overrun, &d->si_overrun);
 		err |= __put_user(s->si_int, &d->si_int);
 		break;
-	case __SI_SYS >> 16:
+	case SIL_SYS:
 		err |= __put_user(ptr_to_compat(s->si_call_addr), &d->si_call_addr);
 		err |= __put_user(s->si_syscall, &d->si_syscall);
 		err |= __put_user(s->si_arch, &d->si_arch);
 		break;
-	case __SI_RT >> 16: /* This is not generated by the kernel as of now.  */
-	case __SI_MESGQ >> 16:
+	case SIL_RT:
 		err |= __put_user(s->si_int, &d->si_int);
 		/* fallthrough */
-	case __SI_KILL >> 16:
-	default:
+	case SIL_KILL:
 		err |= __put_user(s->si_pid, &d->si_pid);
 		err |= __put_user(s->si_uid, &d->si_uid);
 		break;
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index c620049c61f2..f549c4657376 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -75,35 +75,34 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
 	   at the same time.  */
 	err = __put_user(from->si_signo, &to->si_signo);
 	err |= __put_user(from->si_errno, &to->si_errno);
-	err |= __put_user((short)from->si_code, &to->si_code);
+	err |= __put_user(from->si_code, &to->si_code);
 	if (from->si_code < 0)
 		err |= __copy_to_user(&to->_sifields._pad, &from->_sifields._pad, SI_PAD_SIZE);
 	else {
-		switch (from->si_code >> 16) {
-		case __SI_RT >> 16: /* This is not generated by the kernel as of now.  */
-		case __SI_MESGQ >> 16:
+		switch (siginfo_layout(from->si_signo, from->si_code)) {
+		case SIL_RT:
 			err |= __put_user(from->si_int, &to->si_int);
 			/* fallthrough */
-		case __SI_KILL >> 16:
+		case SIL_KILL:
 			err |= __put_user(from->si_pid, &to->si_pid);
 			err |= __put_user(from->si_uid, &to->si_uid);
 			break;
-		case __SI_CHLD >> 16:
+		case SIL_CHLD:
 			err |= __put_user(from->si_pid, &to->si_pid);
 			err |= __put_user(from->si_uid, &to->si_uid);
 			err |= __put_user(from->si_utime, &to->si_utime);
 			err |= __put_user(from->si_stime, &to->si_stime);
 			err |= __put_user(from->si_status, &to->si_status);
 			break;
-		case __SI_FAULT >> 16:
+		case SIL_FAULT:
 			err |= __put_user((unsigned long) from->si_addr,
 					  &to->si_addr);
 			break;
-		case __SI_POLL >> 16:
+		case SIL_POLL:
 			err |= __put_user(from->si_band, &to->si_band);
 			err |= __put_user(from->si_fd, &to->si_fd);
 			break;
-		case __SI_TIMER >> 16:
+		case SIL_TIMER:
 			err |= __put_user(from->si_tid, &to->si_tid);
 			err |= __put_user(from->si_overrun, &to->si_overrun);
 			err |= __put_user(from->si_int, &to->si_int);
@@ -127,32 +126,31 @@ int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 	if (to->si_code < 0)
 		err |= __copy_from_user(&to->_sifields._pad, &from->_sifields._pad, SI_PAD_SIZE);
 	else {
-		switch (to->si_code >> 16) {
-		case __SI_RT >> 16: /* This is not generated by the kernel as of now.  */
-		case __SI_MESGQ >> 16:
+		switch (siginfo_layout(to->si_signo, to->si_code)) {
+		case SIL_RT:
 			err |= __get_user(to->si_int, &from->si_int);
 			/* fallthrough */
-		case __SI_KILL >> 16:
+		case SIL_KILL:
 			err |= __get_user(to->si_pid, &from->si_pid);
 			err |= __get_user(to->si_uid, &from->si_uid);
 			break;
-		case __SI_CHLD >> 16:
+		case SIL_CHLD:
 			err |= __get_user(to->si_pid, &from->si_pid);
 			err |= __get_user(to->si_uid, &from->si_uid);
 			err |= __get_user(to->si_utime, &from->si_utime);
 			err |= __get_user(to->si_stime, &from->si_stime);
 			err |= __get_user(to->si_status, &from->si_status);
 			break;
-		case __SI_FAULT >> 16:
+		case SIL_FAULT:
 			err |= __get_user(tmp, &from->si_addr);
 			to->si_addr = (void __force __user *)
 				(u64) (tmp & PSW32_ADDR_INSN);
 			break;
-		case __SI_POLL >> 16:
+		case SIL_POLL:
 			err |= __get_user(to->si_band, &from->si_band);
 			err |= __get_user(to->si_fd, &from->si_fd);
 			break;
-		case __SI_TIMER >> 16:
+		case SIL_TIMER:
 			err |= __get_user(to->si_tid, &from->si_tid);
 			err |= __get_user(to->si_overrun, &from->si_overrun);
 			err |= __get_user(to->si_int, &from->si_int);
diff --git a/arch/sparc/include/uapi/asm/siginfo.h b/arch/sparc/include/uapi/asm/siginfo.h
index da2126e0c536..157f46fe374f 100644
--- a/arch/sparc/include/uapi/asm/siginfo.h
+++ b/arch/sparc/include/uapi/asm/siginfo.h
@@ -20,13 +20,13 @@
  * SIGFPE si_codes
  */
 #ifdef __KERNEL__
-#define FPE_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
+#define FPE_FIXME	0	/* Broken dup of SI_USER */
 #endif /* __KERNEL__ */
 
 /*
  * SIGEMT si_codes
  */
-#define EMT_TAGOVF	(__SI_FAULT|1)	/* tag overflow */
+#define EMT_TAGOVF	1	/* tag overflow */
 #define NSIGEMT		1
 
 #endif /* _UAPI__SPARC_SIGINFO_H */
diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index b4096bb665b2..0e4c08c45a37 100644
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -85,34 +85,34 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
 	   at the same time.  */
 	err = __put_user(from->si_signo, &to->si_signo);
 	err |= __put_user(from->si_errno, &to->si_errno);
-	err |= __put_user((short)from->si_code, &to->si_code);
+	err |= __put_user(from->si_code, &to->si_code);
 	if (from->si_code < 0)
 		err |= __copy_to_user(&to->_sifields._pad, &from->_sifields._pad, SI_PAD_SIZE);
 	else {
-		switch (from->si_code >> 16) {
-		case __SI_TIMER >> 16:
+		switch (siginfo_layout(from->si_signo, from->si_code)) {
+		case SIL_TIMER:
 			err |= __put_user(from->si_tid, &to->si_tid);
 			err |= __put_user(from->si_overrun, &to->si_overrun);
 			err |= __put_user(from->si_int, &to->si_int);
 			break;
-		case __SI_CHLD >> 16:
+		case SIL_CHLD:
 			err |= __put_user(from->si_utime, &to->si_utime);
 			err |= __put_user(from->si_stime, &to->si_stime);
 			err |= __put_user(from->si_status, &to->si_status);
 		default:
+		case SIL_KILL:
 			err |= __put_user(from->si_pid, &to->si_pid);
 			err |= __put_user(from->si_uid, &to->si_uid);
 			break;
-		case __SI_FAULT >> 16:
+		case SIL_FAULT:
 			err |= __put_user(from->si_trapno, &to->si_trapno);
 			err |= __put_user((unsigned long)from->si_addr, &to->si_addr);
 			break;
-		case __SI_POLL >> 16:
+		case SIL_POLL:
 			err |= __put_user(from->si_band, &to->si_band);
 			err |= __put_user(from->si_fd, &to->si_fd);
 			break;
-		case __SI_RT >> 16: /* This is not generated by the kernel as of now.  */
-		case __SI_MESGQ >> 16:
+		case SIL_RT:
 			err |= __put_user(from->si_pid, &to->si_pid);
 			err |= __put_user(from->si_uid, &to->si_uid);
 			err |= __put_user(from->si_int, &to->si_int);
diff --git a/arch/tile/include/uapi/asm/siginfo.h b/arch/tile/include/uapi/asm/siginfo.h
index 56d661bb010b..e83f931aa1f0 100644
--- a/arch/tile/include/uapi/asm/siginfo.h
+++ b/arch/tile/include/uapi/asm/siginfo.h
@@ -26,8 +26,8 @@
 /*
  * Additional Tile-specific SIGILL si_codes
  */
-#define ILL_DBLFLT	(__SI_FAULT|9)	/* double fault */
-#define ILL_HARDWALL	(__SI_FAULT|10)	/* user networks hardwall violation */
+#define ILL_DBLFLT	9	/* double fault */
+#define ILL_HARDWALL	10	/* user networks hardwall violation */
 #undef NSIGILL
 #define NSIGILL		10
 
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index 0e863f1ee08c..971d87a1d8cf 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -64,7 +64,7 @@ int copy_siginfo_to_user32(struct compat_siginfo __user *to, const siginfo_t *fr
 	   3 ints plus the relevant union member.  */
 	err = __put_user(from->si_signo, &to->si_signo);
 	err |= __put_user(from->si_errno, &to->si_errno);
-	err |= __put_user((short)from->si_code, &to->si_code);
+	err |= __put_user(from->si_code, &to->si_code);
 
 	if (from->si_code < 0) {
 		err |= __put_user(from->si_pid, &to->si_pid);
@@ -77,28 +77,26 @@ int copy_siginfo_to_user32(struct compat_siginfo __user *to, const siginfo_t *fr
 		 */
 		err |= __put_user(from->_sifields._pad[0],
 				  &to->_sifields._pad[0]);
-		switch (from->si_code >> 16) {
-		case __SI_FAULT >> 16:
+		switch (siginfo_layout(from->si_signo, from->si_code)) {
+		case SIL_FAULT:
 			break;
-		case __SI_CHLD >> 16:
+		case SIL_CHLD:
 			err |= __put_user(from->si_utime, &to->si_utime);
 			err |= __put_user(from->si_stime, &to->si_stime);
 			err |= __put_user(from->si_status, &to->si_status);
 			/* FALL THROUGH */
 		default:
-		case __SI_KILL >> 16:
+		case SIL_KILL:
 			err |= __put_user(from->si_uid, &to->si_uid);
 			break;
-		case __SI_POLL >> 16:
+		case SIL_POLL:
 			err |= __put_user(from->si_fd, &to->si_fd);
 			break;
-		case __SI_TIMER >> 16:
+		case SIL_TIMER:
 			err |= __put_user(from->si_overrun, &to->si_overrun);
 			err |= __put_user(from->si_int, &to->si_int);
 			break;
-			 /* This is not generated by the kernel as of now.  */
-		case __SI_RT >> 16:
-		case __SI_MESGQ >> 16:
+		case SIL_RT:
 			err |= __put_user(from->si_uid, &to->si_uid);
 			err |= __put_user(from->si_int, &to->si_int);
 			break;
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 54804866f238..9b08c6055f15 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -188,7 +188,7 @@ static int special_ill(tile_bundle_bits bundle, int *sigp, int *codep)
 
 	/* Make it the requested signal. */
 	*sigp = sig;
-	*codep = code | __SI_FAULT;
+	*codep = code;
 	return 1;
 }
 
diff --git a/arch/x86/kernel/signal_compat.c b/arch/x86/kernel/signal_compat.c
index 71beb28600d4..ab9feb5887b1 100644
--- a/arch/x86/kernel/signal_compat.c
+++ b/arch/x86/kernel/signal_compat.c
@@ -129,7 +129,7 @@ int __copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from,
 		   3 ints plus the relevant union member.  */
 		put_user_ex(from->si_signo, &to->si_signo);
 		put_user_ex(from->si_errno, &to->si_errno);
-		put_user_ex((short)from->si_code, &to->si_code);
+		put_user_ex(from->si_code, &to->si_code);
 
 		if (from->si_code < 0) {
 			put_user_ex(from->si_pid, &to->si_pid);
@@ -142,8 +142,8 @@ int __copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from,
 			 */
 			put_user_ex(from->_sifields._pad[0],
 					  &to->_sifields._pad[0]);
-			switch (from->si_code >> 16) {
-			case __SI_FAULT >> 16:
+			switch (siginfo_layout(from->si_signo, from->si_code)) {
+			case SIL_FAULT:
 				if (from->si_signo == SIGBUS &&
 				    (from->si_code == BUS_MCEERR_AR ||
 				     from->si_code == BUS_MCEERR_AO))
@@ -160,11 +160,11 @@ int __copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from,
 						put_user_ex(from->si_pkey, &to->si_pkey);
 				}
 				break;
-			case __SI_SYS >> 16:
+			case SIL_SYS:
 				put_user_ex(from->si_syscall, &to->si_syscall);
 				put_user_ex(from->si_arch, &to->si_arch);
 				break;
-			case __SI_CHLD >> 16:
+			case SIL_CHLD:
 				if (!x32_ABI) {
 					put_user_ex(from->si_utime, &to->si_utime);
 					put_user_ex(from->si_stime, &to->si_stime);
@@ -174,21 +174,18 @@ int __copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from,
 				}
 				put_user_ex(from->si_status, &to->si_status);
 				/* FALL THROUGH */
-			default:
-			case __SI_KILL >> 16:
+			case SIL_KILL:
 				put_user_ex(from->si_uid, &to->si_uid);
 				break;
-			case __SI_POLL >> 16:
+			case SIL_POLL:
 				put_user_ex(from->si_fd, &to->si_fd);
 				break;
-			case __SI_TIMER >> 16:
+			case SIL_TIMER:
 				put_user_ex(from->si_overrun, &to->si_overrun);
 				put_user_ex(ptr_to_compat(from->si_ptr),
 					    &to->si_ptr);
 				break;
-				 /* This is not generated by the kernel as of now.  */
-			case __SI_RT >> 16:
-			case __SI_MESGQ >> 16:
+			case SIL_RT:
 				put_user_ex(from->si_uid, &to->si_uid);
 				put_user_ex(from->si_int, &to->si_int);
 				break;
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 593b022ac11b..d2c434112f42 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -95,23 +95,23 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 	 */
 	err |= __put_user(kinfo->si_signo, &uinfo->ssi_signo);
 	err |= __put_user(kinfo->si_errno, &uinfo->ssi_errno);
-	err |= __put_user((short) kinfo->si_code, &uinfo->ssi_code);
-	switch (kinfo->si_code & __SI_MASK) {
-	case __SI_KILL:
+	err |= __put_user(kinfo->si_code, &uinfo->ssi_code);
+	switch (siginfo_layout(kinfo->si_signo, kinfo->si_code)) {
+	case SIL_KILL:
 		err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
 		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
 		break;
-	case __SI_TIMER:
+	case SIL_TIMER:
 		 err |= __put_user(kinfo->si_tid, &uinfo->ssi_tid);
 		 err |= __put_user(kinfo->si_overrun, &uinfo->ssi_overrun);
 		 err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
 		 err |= __put_user(kinfo->si_int, &uinfo->ssi_int);
 		break;
-	case __SI_POLL:
+	case SIL_POLL:
 		err |= __put_user(kinfo->si_band, &uinfo->ssi_band);
 		err |= __put_user(kinfo->si_fd, &uinfo->ssi_fd);
 		break;
-	case __SI_FAULT:
+	case SIL_FAULT:
 		err |= __put_user((long) kinfo->si_addr, &uinfo->ssi_addr);
 #ifdef __ARCH_SI_TRAPNO
 		err |= __put_user(kinfo->si_trapno, &uinfo->ssi_trapno);
@@ -128,20 +128,14 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 					  &uinfo->ssi_addr_lsb);
 #endif
 		break;
-	case __SI_CHLD:
+	case SIL_CHLD:
 		err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
 		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
 		err |= __put_user(kinfo->si_status, &uinfo->ssi_status);
 		err |= __put_user(kinfo->si_utime, &uinfo->ssi_utime);
 		err |= __put_user(kinfo->si_stime, &uinfo->ssi_stime);
 		break;
-	case __SI_RT: /* This is not generated by the kernel as of now. */
-	case __SI_MESGQ: /* But this is */
-		err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
-		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
-		err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
-		err |= __put_user(kinfo->si_int, &uinfo->ssi_int);
-		break;
+	case SIL_RT:
 	default:
 		/*
 		 * This case catches also the signals queued by sigqueue().
diff --git a/include/linux/signal.h b/include/linux/signal.h
index c97cc20369c0..38564e3e54c7 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -21,6 +21,20 @@ static inline void copy_siginfo(struct siginfo *to, struct siginfo *from)
 
 int copy_siginfo_to_user(struct siginfo __user *to, const struct siginfo *from);
 
+enum siginfo_layout {
+	SIL_KILL,
+	SIL_TIMER,
+	SIL_POLL,
+	SIL_FAULT,
+	SIL_CHLD,
+	SIL_RT,
+#ifdef __ARCH_SIGSYS
+	SIL_SYS,
+#endif
+};
+
+enum siginfo_layout siginfo_layout(int sig, int si_code);
+
 /*
  * Define some primitives to manipulate sigset_t.
  */
diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index 9e956ea94d57..e5aa6794cea4 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -151,29 +151,6 @@ typedef struct siginfo {
 #define si_arch		_sifields._sigsys._arch
 #endif
 
-#ifdef __KERNEL__
-#define __SI_MASK	0xffff0000u
-#define __SI_KILL	(0 << 16)
-#define __SI_TIMER	(1 << 16)
-#define __SI_POLL	(2 << 16)
-#define __SI_FAULT	(3 << 16)
-#define __SI_CHLD	(4 << 16)
-#define __SI_RT		(5 << 16)
-#define __SI_MESGQ	(6 << 16)
-#define __SI_SYS	(7 << 16)
-#define __SI_CODE(T,N)	((T) | ((N) & 0xffff))
-#else /* __KERNEL__ */
-#define __SI_KILL	0
-#define __SI_TIMER	0
-#define __SI_POLL	0
-#define __SI_FAULT	0
-#define __SI_CHLD	0
-#define __SI_RT		0
-#define __SI_MESGQ	0
-#define __SI_SYS	0
-#define __SI_CODE(T,N)	(N)
-#endif /* __KERNEL__ */
-
 /*
  * si_code values
  * Digital reserves positive values for kernel-generated signals.
@@ -181,10 +158,10 @@ typedef struct siginfo {
 #define SI_USER		0		/* sent by kill, sigsend, raise */
 #define SI_KERNEL	0x80		/* sent by the kernel from somewhere */
 #define SI_QUEUE	-1		/* sent by sigqueue */
-#define SI_TIMER __SI_CODE(__SI_TIMER,-2) /* sent by timer expiration */
-#define SI_MESGQ __SI_CODE(__SI_MESGQ,-3) /* sent by real time mesq state change */
+#define SI_TIMER	-2		/* sent by timer expiration */
+#define SI_MESGQ	-3		/* sent by real time mesq state change */
 #define SI_ASYNCIO	-4		/* sent by AIO completion */
-#define SI_SIGIO __SI_CODE(__SI_POLL,-5) /* sent by queued SIGIO */
+#define SI_SIGIO	-5		/* sent by queued SIGIO */
 #define SI_TKILL	-6		/* sent by tkill system call */
 #define SI_DETHREAD	-7		/* sent by execve() killing subsidiary threads */
 
@@ -194,86 +171,86 @@ typedef struct siginfo {
 /*
  * SIGILL si_codes
  */
-#define ILL_ILLOPC	(__SI_FAULT|1)	/* illegal opcode */
-#define ILL_ILLOPN	(__SI_FAULT|2)	/* illegal operand */
-#define ILL_ILLADR	(__SI_FAULT|3)	/* illegal addressing mode */
-#define ILL_ILLTRP	(__SI_FAULT|4)	/* illegal trap */
-#define ILL_PRVOPC	(__SI_FAULT|5)	/* privileged opcode */
-#define ILL_PRVREG	(__SI_FAULT|6)	/* privileged register */
-#define ILL_COPROC	(__SI_FAULT|7)	/* coprocessor error */
-#define ILL_BADSTK	(__SI_FAULT|8)	/* internal stack error */
+#define ILL_ILLOPC	1	/* illegal opcode */
+#define ILL_ILLOPN	2	/* illegal operand */
+#define ILL_ILLADR	3	/* illegal addressing mode */
+#define ILL_ILLTRP	4	/* illegal trap */
+#define ILL_PRVOPC	5	/* privileged opcode */
+#define ILL_PRVREG	6	/* privileged register */
+#define ILL_COPROC	7	/* coprocessor error */
+#define ILL_BADSTK	8	/* internal stack error */
 #define NSIGILL		8
 
 /*
  * SIGFPE si_codes
  */
-#define FPE_INTDIV	(__SI_FAULT|1)	/* integer divide by zero */
-#define FPE_INTOVF	(__SI_FAULT|2)	/* integer overflow */
-#define FPE_FLTDIV	(__SI_FAULT|3)	/* floating point divide by zero */
-#define FPE_FLTOVF	(__SI_FAULT|4)	/* floating point overflow */
-#define FPE_FLTUND	(__SI_FAULT|5)	/* floating point underflow */
-#define FPE_FLTRES	(__SI_FAULT|6)	/* floating point inexact result */
-#define FPE_FLTINV	(__SI_FAULT|7)	/* floating point invalid operation */
-#define FPE_FLTSUB	(__SI_FAULT|8)	/* subscript out of range */
+#define FPE_INTDIV	1	/* integer divide by zero */
+#define FPE_INTOVF	2	/* integer overflow */
+#define FPE_FLTDIV	3	/* floating point divide by zero */
+#define FPE_FLTOVF	4	/* floating point overflow */
+#define FPE_FLTUND	5	/* floating point underflow */
+#define FPE_FLTRES	6	/* floating point inexact result */
+#define FPE_FLTINV	7	/* floating point invalid operation */
+#define FPE_FLTSUB	8	/* subscript out of range */
 #define NSIGFPE		8
 
 /*
  * SIGSEGV si_codes
  */
-#define SEGV_MAPERR	(__SI_FAULT|1)	/* address not mapped to object */
-#define SEGV_ACCERR	(__SI_FAULT|2)	/* invalid permissions for mapped object */
-#define SEGV_BNDERR	(__SI_FAULT|3)  /* failed address bound checks */
-#define SEGV_PKUERR	(__SI_FAULT|4)  /* failed protection key checks */
+#define SEGV_MAPERR	1	/* address not mapped to object */
+#define SEGV_ACCERR	2	/* invalid permissions for mapped object */
+#define SEGV_BNDERR	3	/* failed address bound checks */
+#define SEGV_PKUERR	4	/* failed protection key checks */
 #define NSIGSEGV	4
 
 /*
  * SIGBUS si_codes
  */
-#define BUS_ADRALN	(__SI_FAULT|1)	/* invalid address alignment */
-#define BUS_ADRERR	(__SI_FAULT|2)	/* non-existent physical address */
-#define BUS_OBJERR	(__SI_FAULT|3)	/* object specific hardware error */
+#define BUS_ADRALN	1	/* invalid address alignment */
+#define BUS_ADRERR	2	/* non-existent physical address */
+#define BUS_OBJERR	3	/* object specific hardware error */
 /* hardware memory error consumed on a machine check: action required */
-#define BUS_MCEERR_AR	(__SI_FAULT|4)
+#define BUS_MCEERR_AR	4
 /* hardware memory error detected in process but not consumed: action optional*/
-#define BUS_MCEERR_AO	(__SI_FAULT|5)
+#define BUS_MCEERR_AO	5
 #define NSIGBUS		5
 
 /*
  * SIGTRAP si_codes
  */
-#define TRAP_BRKPT	(__SI_FAULT|1)	/* process breakpoint */
-#define TRAP_TRACE	(__SI_FAULT|2)	/* process trace trap */
-#define TRAP_BRANCH     (__SI_FAULT|3)  /* process taken branch trap */
-#define TRAP_HWBKPT     (__SI_FAULT|4)  /* hardware breakpoint/watchpoint */
+#define TRAP_BRKPT	1	/* process breakpoint */
+#define TRAP_TRACE	2	/* process trace trap */
+#define TRAP_BRANCH     3	/* process taken branch trap */
+#define TRAP_HWBKPT     4	/* hardware breakpoint/watchpoint */
 #define NSIGTRAP	4
 
 /*
  * SIGCHLD si_codes
  */
-#define CLD_EXITED	(__SI_CHLD|1)	/* child has exited */
-#define CLD_KILLED	(__SI_CHLD|2)	/* child was killed */
-#define CLD_DUMPED	(__SI_CHLD|3)	/* child terminated abnormally */
-#define CLD_TRAPPED	(__SI_CHLD|4)	/* traced child has trapped */
-#define CLD_STOPPED	(__SI_CHLD|5)	/* child has stopped */
-#define CLD_CONTINUED	(__SI_CHLD|6)	/* stopped child has continued */
+#define CLD_EXITED	1	/* child has exited */
+#define CLD_KILLED	2	/* child was killed */
+#define CLD_DUMPED	3	/* child terminated abnormally */
+#define CLD_TRAPPED	4	/* traced child has trapped */
+#define CLD_STOPPED	5	/* child has stopped */
+#define CLD_CONTINUED	6	/* stopped child has continued */
 #define NSIGCHLD	6
 
 /*
  * SIGPOLL (or any other signal without signal specific si_codes) si_codes
  */
-#define POLL_IN		(__SI_POLL|1)	/* data input available */
-#define POLL_OUT	(__SI_POLL|2)	/* output buffers available */
-#define POLL_MSG	(__SI_POLL|3)	/* input message available */
-#define POLL_ERR	(__SI_POLL|4)	/* i/o error */
-#define POLL_PRI	(__SI_POLL|5)	/* high priority input available */
-#define POLL_HUP	(__SI_POLL|6)	/* device disconnected */
+#define POLL_IN		1	/* data input available */
+#define POLL_OUT	2	/* output buffers available */
+#define POLL_MSG	3	/* input message available */
+#define POLL_ERR	4	/* i/o error */
+#define POLL_PRI	5	/* high priority input available */
+#define POLL_HUP	6	/* device disconnected */
 #define NSIGPOLL	6
 
 /*
  * SIGSYS si_codes
  */
-#define SYS_SECCOMP		(__SI_SYS|1)	/* seccomp triggered */
-#define NSIGSYS	1
+#define SYS_SECCOMP	1	/* seccomp triggered */
+#define NSIGSYS		1
 
 /*
  * sigevent definitions
diff --git a/kernel/exit.c b/kernel/exit.c
index c5548faa9f37..c8f23613df5b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1616,7 +1616,7 @@ SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
 	user_access_begin();
 	unsafe_put_user(signo, &infop->si_signo, Efault);
 	unsafe_put_user(0, &infop->si_errno, Efault);
-	unsafe_put_user((short)info.cause, &infop->si_code, Efault);
+	unsafe_put_user(info.cause, &infop->si_code, Efault);
 	unsafe_put_user(info.pid, &infop->si_pid, Efault);
 	unsafe_put_user(info.uid, &infop->si_uid, Efault);
 	unsafe_put_user(info.status, &infop->si_status, Efault);
@@ -1742,7 +1742,7 @@ COMPAT_SYSCALL_DEFINE5(waitid,
 	user_access_begin();
 	unsafe_put_user(signo, &infop->si_signo, Efault);
 	unsafe_put_user(0, &infop->si_errno, Efault);
-	unsafe_put_user((short)info.cause, &infop->si_code, Efault);
+	unsafe_put_user(info.cause, &infop->si_code, Efault);
 	unsafe_put_user(info.pid, &infop->si_pid, Efault);
 	unsafe_put_user(info.uid, &infop->si_uid, Efault);
 	unsafe_put_user(info.status, &infop->si_status, Efault);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 60f356d91060..84b1367935e4 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -728,8 +728,7 @@ static int ptrace_peek_siginfo(struct task_struct *child,
 		if (unlikely(in_compat_syscall())) {
 			compat_siginfo_t __user *uinfo = compat_ptr(data);
 
-			if (copy_siginfo_to_user32(uinfo, &info) ||
-			    __put_user(info.si_code, &uinfo->si_code)) {
+			if (copy_siginfo_to_user32(uinfo, &info)) {
 				ret = -EFAULT;
 				break;
 			}
@@ -739,8 +738,7 @@ static int ptrace_peek_siginfo(struct task_struct *child,
 		{
 			siginfo_t __user *uinfo = (siginfo_t __user *) data;
 
-			if (copy_siginfo_to_user(uinfo, &info) ||
-			    __put_user(info.si_code, &uinfo->si_code)) {
+			if (copy_siginfo_to_user(uinfo, &info)) {
 				ret = -EFAULT;
 				break;
 			}
diff --git a/kernel/signal.c b/kernel/signal.c
index caed9133ae52..6bd53c8189f0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2682,6 +2682,51 @@ COMPAT_SYSCALL_DEFINE2(rt_sigpending, compat_sigset_t __user *, uset,
 }
 #endif
 
+enum siginfo_layout siginfo_layout(int sig, int si_code)
+{
+	enum siginfo_layout layout = SIL_KILL;
+	if ((si_code > SI_USER) && (si_code < SI_KERNEL)) {
+		static const struct {
+			unsigned char limit, layout;
+		} filter[] = {
+			[SIGILL]  = { NSIGILL,  SIL_FAULT },
+			[SIGFPE]  = { NSIGFPE,  SIL_FAULT },
+			[SIGSEGV] = { NSIGSEGV, SIL_FAULT },
+			[SIGBUS]  = { NSIGBUS,  SIL_FAULT },
+			[SIGTRAP] = { NSIGTRAP, SIL_FAULT },
+#if defined(SIGMET) && defined(NSIGEMT)
+			[SIGEMT]  = { NSIGEMT,  SIL_FAULT },
+#endif
+			[SIGCHLD] = { NSIGCHLD, SIL_CHLD },
+			[SIGPOLL] = { NSIGPOLL, SIL_POLL },
+#ifdef __ARCH_SIGSYS
+			[SIGSYS]  = { NSIGSYS,  SIL_SYS },
+#endif
+		};
+		if ((sig < ARRAY_SIZE(filter)) && (si_code <= filter[sig].limit))
+			layout = filter[sig].layout;
+		else if (si_code <= NSIGPOLL)
+			layout = SIL_POLL;
+	} else {
+		if (si_code == SI_TIMER)
+			layout = SIL_TIMER;
+		else if (si_code == SI_SIGIO)
+			layout = SIL_POLL;
+		else if (si_code < 0)
+			layout = SIL_RT;
+		/* Tests to support buggy kernel ABIs */
+#ifdef TRAP_FIXME
+		if ((sig == SIGTRAP) && (si_code == TRAP_FIXME))
+			layout = SIL_FAULT;
+#endif
+#ifdef FPE_FIXME
+		if ((sig == SIGFPE) && (si_code == FPE_FIXME))
+			layout = SIL_FAULT;
+#endif
+	}
+	return layout;
+}
+
 #ifndef HAVE_ARCH_COPY_SIGINFO_TO_USER
 
 int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
@@ -2704,22 +2749,20 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 	 */
 	err = __put_user(from->si_signo, &to->si_signo);
 	err |= __put_user(from->si_errno, &to->si_errno);
-	err |= __put_user((short)from->si_code, &to->si_code);
-	switch (from->si_code & __SI_MASK) {
-	case __SI_KILL:
+	err |= __put_user(from->si_code, &to->si_code);
+	switch (siginfo_layout(from->si_signo, from->si_code)) {
+	case SIL_KILL:
 		err |= __put_user(from->si_pid, &to->si_pid);
 		err |= __put_user(from->si_uid, &to->si_uid);
 		break;
-	case __SI_TIMER:
-		 err |= __put_user(from->si_tid, &to->si_tid);
-		 err |= __put_user(from->si_overrun, &to->si_overrun);
-		 err |= __put_user(from->si_ptr, &to->si_ptr);
+	case SIL_TIMER:
+		/* Unreached SI_TIMER is negative */
 		break;
-	case __SI_POLL:
+	case SIL_POLL:
 		err |= __put_user(from->si_band, &to->si_band);
 		err |= __put_user(from->si_fd, &to->si_fd);
 		break;
-	case __SI_FAULT:
+	case SIL_FAULT:
 		err |= __put_user(from->si_addr, &to->si_addr);
 #ifdef __ARCH_SI_TRAPNO
 		err |= __put_user(from->si_trapno, &to->si_trapno);
@@ -2744,30 +2787,25 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 			err |= __put_user(from->si_pkey, &to->si_pkey);
 #endif
 		break;
-	case __SI_CHLD:
+	case SIL_CHLD:
 		err |= __put_user(from->si_pid, &to->si_pid);
 		err |= __put_user(from->si_uid, &to->si_uid);
 		err |= __put_user(from->si_status, &to->si_status);
 		err |= __put_user(from->si_utime, &to->si_utime);
 		err |= __put_user(from->si_stime, &to->si_stime);
 		break;
-	case __SI_RT: /* This is not generated by the kernel as of now. */
-	case __SI_MESGQ: /* But this is */
+	case SIL_RT:
 		err |= __put_user(from->si_pid, &to->si_pid);
 		err |= __put_user(from->si_uid, &to->si_uid);
 		err |= __put_user(from->si_ptr, &to->si_ptr);
 		break;
 #ifdef __ARCH_SIGSYS
-	case __SI_SYS:
+	case SIL_SYS:
 		err |= __put_user(from->si_call_addr, &to->si_call_addr);
 		err |= __put_user(from->si_syscall, &to->si_syscall);
 		err |= __put_user(from->si_arch, &to->si_arch);
 		break;
 #endif
-	default: /* this is just in case for now ... */
-		err |= __put_user(from->si_pid, &to->si_pid);
-		err |= __put_user(from->si_uid, &to->si_uid);
-		break;
 	}
 	return err;
 }
-- 
2.10.1
