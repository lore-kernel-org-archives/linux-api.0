From: arnd@arndb.de
Subject: [RFC 06/17] asm-generic: add a complete signal.h
Date: Mon, 27 Apr 2009 17:01:20 +0200
Message-ID: <20090427150318.207970321@arndb.de>
References: <20090427142010.587518220@arndb.de>
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline; filename=add-generic-signal-h.patch
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, monstr@monstr.eu, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, liqin.chen@sunplusct.com, Sam Ravnborg <sam@ravnborg.org>, Remis Lima Baima <remis.developer@googlemail.com>
List-Id: linux-api@vger.kernel.org

There used to be an asm-generic/signal.h, but not one that
could be used out of the box. This renames the existing file
to asm-generic/signal-defs.h and adds a new asm-generic/signal.h
with common definitions for sigaction and sigaltstack, but
not for the old-style signal handlers.

New architectures should only implement rt-signals and use this
generic header.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
---
 include/asm-generic/Kbuild   |    1 	1 +	0 -	0 !
 include/asm-generic/signal.h |  131 	131 +	0 -	0 !
 2 files changed, 132 insertions(+)

Index: linux-2.6/include/asm-generic/signal.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/signal.h
@@ -0,0 +1,131 @@
+#ifndef __ASM_GENERIC_SIGNAL_H
+#define __ASM_GENERIC_SIGNAL_H
+
+#include <linux/types.h>
+
+#define _NSIG		64
+#define _NSIG_BPW	__BITS_PER_LONG
+#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
+
+#define SIGHUP		 1
+#define SIGINT		 2
+#define SIGQUIT		 3
+#define SIGILL		 4
+#define SIGTRAP		 5
+#define SIGABRT		 6
+#define SIGIOT		 6
+#define SIGBUS		 7
+#define SIGFPE		 8
+#define SIGKILL		 9
+#define SIGUSR1		10
+#define SIGSEGV		11
+#define SIGUSR2		12
+#define SIGPIPE		13
+#define SIGALRM		14
+#define SIGTERM		15
+#define SIGSTKFLT	16
+#define SIGCHLD		17
+#define SIGCONT		18
+#define SIGSTOP		19
+#define SIGTSTP		20
+#define SIGTTIN		21
+#define SIGTTOU		22
+#define SIGURG		23
+#define SIGXCPU		24
+#define SIGXFSZ		25
+#define SIGVTALRM	26
+#define SIGPROF		27
+#define SIGWINCH	28
+#define SIGIO		29
+#define SIGPOLL		SIGIO
+/*
+#define SIGLOST		29
+*/
+#define SIGPWR		30
+#define SIGSYS		31
+#define	SIGUNUSED	31
+
+/* These should not be considered constants from userland.  */
+#define SIGRTMIN	32
+#ifndef SIGRTMAX
+#define SIGRTMAX	_NSIG
+#endif
+
+/*
+ * SA_FLAGS values:
+ *
+ * SA_ONSTACK indicates that a registered stack_t will be used.
+ * SA_RESTART flag to get restarting signals (which were the default long ago)
+ * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
+ * SA_RESETHAND clears the handler when the signal is delivered.
+ * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
+ * SA_NODEFER prevents the current signal from being masked in the handler.
+ *
+ * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
+ * Unix names RESETHAND and NODEFER respectively.
+ */
+#define SA_NOCLDSTOP	0x00000001
+#define SA_NOCLDWAIT	0x00000002
+#define SA_SIGINFO	0x00000004
+#define SA_ONSTACK	0x08000000
+#define SA_RESTART	0x10000000
+#define SA_NODEFER	0x40000000
+#define SA_RESETHAND	0x80000000
+
+#define SA_NOMASK	SA_NODEFER
+#define SA_ONESHOT	SA_RESETHAND
+
+/*
+ * New architectures should not define the obsolete
+ *	SA_RESTORER	0x04000000
+ */
+
+/*
+ * sigaltstack controls
+ */
+#define SS_ONSTACK	1
+#define SS_DISABLE	2
+
+#define MINSIGSTKSZ	2048
+#define SIGSTKSZ	8192
+
+#ifndef __ASSEMBLY__
+typedef struct {
+	unsigned long sig[_NSIG_WORDS];
+} sigset_t;
+
+/* not actually used, but required for linux/syscalls.h */
+typedef unsigned long old_sigset_t;
+
+#include <asm-generic/signal-defs.h>
+
+struct sigaction {
+	__sighandler_t sa_handler;
+	unsigned long sa_flags;
+#ifdef SA_RESTORER
+	__sigrestore_t sa_restorer;
+#endif
+	sigset_t sa_mask;		/* mask last for extensibility */
+};
+
+struct k_sigaction {
+	struct sigaction sa;
+};
+
+typedef struct sigaltstack {
+	void __user *ss_sp;
+	int ss_flags;
+	size_t ss_size;
+} stack_t;
+
+#ifdef __KERNEL__
+
+#include <asm/sigcontext.h>
+#undef __HAVE_ARCH_SIG_BITOPS
+
+#define ptrace_signal_deliver(regs, cookie) do { } while (0)
+
+#endif /* __KERNEL__ */
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_GENERIC_SIGNAL_H */
Index: linux-2.6/include/asm-generic/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-generic/Kbuild
+++ linux-2.6/include/asm-generic/Kbuild
@@ -5,6 +5,7 @@ header-y += ioctl.h
 header-y += mman-common.h
 header-y += poll.h
 header-y += signal-defs.h
+header-y += signal.h
 header-y += statfs.h
 header-y += termios.h
 

-- 
