From: Amanieu d'Antras <amanieu@gmail.com>
Subject: [PATCH v2 02/20] compat: Add generic copy_siginfo_{to,from}_user32
Date: Thu,  5 Nov 2015 00:50:21 +0000
Message-ID: <1446684640-4112-3-git-send-email-amanieu@gmail.com>
References: <1446684640-4112-1-git-send-email-amanieu@gmail.com>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1446684640-4112-1-git-send-email-amanieu@gmail.com>
Sender: sparclinux-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Amanieu d'Antras <amanieu@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "David S. Miller" <davem@davemloft.net>, Chris Metcalf <cmetcalf@ezchip.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, sparclinux@vger.
List-Id: linux-api@vger.kernel.org

These routines try to match the behavior of native 32-bit kernels
as closely as possible. They will replace architecture-specific
versions that are missing support for some fields and have various
bugs that cause behavior to diverge from that of a 32-bit kernel.

The only problematic situation is when sending a si_ptr from a
32-bit process to a 64-bit process or vice-versa, but this has
never worked correctly in the past anyways.

One thing to note is that, because the size of the siginfo_t union
differs between 32-bit and 64-bit systems, we need to stash the
last 4 bytes of the union in the 4 bytes of padding between the
64-bit union and the initial 3 siginfo_t members.

Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
---
 arch/arm64/include/asm/compat.h    |   2 +
 arch/mips/include/asm/compat.h     |   2 +
 arch/parisc/include/asm/compat.h   |   2 +
 arch/powerpc/include/asm/compat.h  |   2 +
 arch/s390/include/asm/compat.h     |   2 +
 arch/sparc/include/asm/compat.h    |   2 +
 arch/tile/include/asm/compat.h     |   2 +
 arch/x86/include/asm/compat.h      |   2 +
 include/uapi/asm-generic/siginfo.h |   1 +
 kernel/compat.c                    | 224 +++++++++++++++++++++++++++++++++++++
 kernel/signal.c                    |  12 +-
 11 files changed, 248 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index ff4e294..5eae749 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -156,6 +156,8 @@ typedef union compat_sigval {
 } compat_sigval_t;
 
 #define HAVE_ARCH_COMPAT_SIGINFO_T
+#define HAVE_ARCH_COPY_SIGINFO_TO_USER32
+#define HAVE_ARCH_COPY_SIGINFO_FROM_USER32
 
 typedef struct compat_siginfo {
 	int si_signo;
diff --git a/arch/mips/include/asm/compat.h b/arch/mips/include/asm/compat.h
index 5f1f816..1e5ba38 100644
--- a/arch/mips/include/asm/compat.h
+++ b/arch/mips/include/asm/compat.h
@@ -131,6 +131,8 @@ typedef union compat_sigval {
 } compat_sigval_t;
 
 #define HAVE_ARCH_COMPAT_SIGINFO_T
+#define HAVE_ARCH_COPY_SIGINFO_TO_USER32
+#define HAVE_ARCH_COPY_SIGINFO_FROM_USER32
 #define SI_PAD_SIZE32	(128/sizeof(int) - 3)
 
 typedef struct compat_siginfo {
diff --git a/arch/parisc/include/asm/compat.h b/arch/parisc/include/asm/compat.h
index e0be05f..46a0a8a 100644
--- a/arch/parisc/include/asm/compat.h
+++ b/arch/parisc/include/asm/compat.h
@@ -135,6 +135,8 @@ typedef union compat_sigval {
 } compat_sigval_t;
 
 #define HAVE_ARCH_COMPAT_SIGINFO_T
+#define HAVE_ARCH_COPY_SIGINFO_TO_USER32
+#define HAVE_ARCH_COPY_SIGINFO_FROM_USER32
 
 typedef struct compat_siginfo {
 	int si_signo;
diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index 75b25ff..cdc8638 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -125,6 +125,8 @@ typedef union compat_sigval {
 } compat_sigval_t;
 
 #define HAVE_ARCH_COMPAT_SIGINFO_T
+#define HAVE_ARCH_COPY_SIGINFO_TO_USER32
+#define HAVE_ARCH_COPY_SIGINFO_FROM_USER32
 #define SI_PAD_SIZE32	(128/sizeof(int) - 3)
 
 typedef struct compat_siginfo {
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index ac73ac7..497af62 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -193,6 +193,8 @@ typedef union compat_sigval {
 } compat_sigval_t;
 
 #define HAVE_ARCH_COMPAT_SIGINFO_T
+#define HAVE_ARCH_COPY_SIGINFO_TO_USER32
+#define HAVE_ARCH_COPY_SIGINFO_FROM_USER32
 
 typedef struct compat_siginfo {
 	int	si_signo;
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index 0c80f59..9357014 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -154,6 +154,8 @@ typedef union compat_sigval {
 } compat_sigval_t;
 
 #define HAVE_ARCH_COMPAT_SIGINFO_T
+#define HAVE_ARCH_COPY_SIGINFO_TO_USER32
+#define HAVE_ARCH_COPY_SIGINFO_FROM_USER32
 #define SI_PAD_SIZE32	(128/sizeof(int) - 3)
 
 typedef struct compat_siginfo {
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index f9bba8d..e0c61da 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -116,6 +116,8 @@ typedef union compat_sigval {
 } compat_sigval_t;
 
 #define HAVE_ARCH_COMPAT_SIGINFO_T
+#define HAVE_ARCH_COPY_SIGINFO_TO_USER32
+#define HAVE_ARCH_COPY_SIGINFO_FROM_USER32
 #define COMPAT_SI_PAD_SIZE	(128/sizeof(int) - 3)
 
 typedef struct compat_siginfo {
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 69176b4..c6b58b1 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -131,6 +131,8 @@ typedef union compat_sigval {
 } compat_sigval_t;
 
 #define HAVE_ARCH_COMPAT_SIGINFO_T
+#define HAVE_ARCH_COPY_SIGINFO_TO_USER32
+#define HAVE_ARCH_COPY_SIGINFO_FROM_USER32
 
 typedef struct compat_siginfo {
 	int si_signo;
diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index 1e35520..cc8d95e 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -49,6 +49,7 @@ typedef struct siginfo {
 	int si_signo;
 	int si_errno;
 	int si_code;
+	int _pad2[__ARCH_SI_PREAMBLE_SIZE / sizeof(int) - 3];
 
 	union {
 		int _pad[SI_PAD_SIZE];
diff --git a/kernel/compat.c b/kernel/compat.c
index 333d364..644da25 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -1174,3 +1174,227 @@ void __user *compat_alloc_user_space(unsigned long len)
 	return ptr;
 }
 EXPORT_SYMBOL_GPL(compat_alloc_user_space);
+
+#ifndef HAVE_ARCH_COPY_SIGINFO_TO_USER32
+int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
+{
+	int err, si_code;
+
+	if (!access_ok(VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
+		return -EFAULT;
+
+	/*
+	 * Get the user-visible si_code by hiding the top 16 bits if this is a
+	 * kernel-generated signal.
+	 */
+	si_code = from->si_code < 0 ? from->si_code : (short)from->si_code;
+
+	/*
+	 * If you change siginfo_t structure, please be sure that
+	 * all these functions are fixed accordingly:
+	 * copy_siginfo_to_user
+	 * copy_siginfo_to_user32
+	 * copy_siginfo_from_user32
+	 * signalfd_copyinfo
+	 * They should never copy any pad contained in the structure
+	 * to avoid security leaks, but must copy the generic
+	 * 3 ints plus the relevant union member.
+	 */
+	err = __put_user(from->si_signo, &to->si_signo);
+	err |= __put_user(from->si_errno, &to->si_errno);
+	err |= __put_user(si_code, &to->si_code);
+	if (from->si_code < 0) {
+		/*
+		 * Copy the tail bytes of the union from the padding, see the
+		 * comment in copy_siginfo_from_user32. Note that this padding
+		 * is always initialized when si_code < 0.
+		 */
+		BUILD_BUG_ON(sizeof(to->_sifields._pad) !=
+			sizeof(from->_sifields._pad) + sizeof(from->_pad2));
+		err |= __copy_to_user(to->_sifields._pad, from->_sifields._pad,
+			sizeof(from->_sifields._pad)) ? -EFAULT : 0;
+		err |= __copy_to_user(to->_sifields._pad + SI_PAD_SIZE,
+			from->_pad2, sizeof(from->_pad2)) ? -EFAULT : 0;
+		return err;
+	}
+	switch (from->si_code & __SI_MASK) {
+	case __SI_KILL:
+		err |= __put_user(from->si_pid, &to->si_pid);
+		err |= __put_user(from->si_uid, &to->si_uid);
+		break;
+	case __SI_TIMER:
+		err |= __put_user(from->si_tid, &to->si_tid);
+		err |= __put_user(from->si_overrun, &to->si_overrun);
+		/*
+		 * Get the sigval from si_int, which matches the convention
+		 * used in get_compat_sigevent.
+		 */
+		err |= __put_user(from->si_int, &to->si_int);
+		break;
+	case __SI_POLL:
+		err |= __put_user(from->si_band, &to->si_band);
+		err |= __put_user(from->si_fd, &to->si_fd);
+		break;
+	case __SI_FAULT:
+		err |= __put_user(ptr_to_compat(from->si_addr), &to->si_addr);
+#ifdef __ARCH_SI_TRAPNO
+		err |= __put_user(from->si_trapno, &to->si_trapno);
+#endif
+#ifdef BUS_MCEERR_AO
+		/*
+		 * Other callers might not initialize the si_lsb field,
+		 * so check explicitly for the right codes here.
+		 */
+		if (from->si_signo == SIGBUS &&
+		    (from->si_code == BUS_MCEERR_AR ||
+		     from->si_code == BUS_MCEERR_AO))
+			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
+#endif
+#ifdef SEGV_BNDERR
+		if (from->si_signo == SIGSEGV && from->si_code == SEGV_BNDERR) {
+			err |= __put_user(ptr_to_compat(from->si_lower),
+				&to->si_lower);
+			err |= __put_user(ptr_to_compat(from->si_upper),
+				&to->si_upper);
+		}
+#endif
+		break;
+	case __SI_CHLD:
+		err |= __put_user(from->si_pid, &to->si_pid);
+		err |= __put_user(from->si_uid, &to->si_uid);
+		err |= __put_user(from->si_status, &to->si_status);
+		err |= __put_user(from->si_utime, &to->si_utime);
+		err |= __put_user(from->si_stime, &to->si_stime);
+		break;
+	case __SI_RT: /* This is not generated by the kernel as of now. */
+	case __SI_MESGQ: /* But this is */
+		err |= __put_user(from->si_pid, &to->si_pid);
+		err |= __put_user(from->si_uid, &to->si_uid);
+		/*
+		 * Get the sigval from si_int, which matches the convention
+		 * used in get_compat_sigevent.
+		 */
+		err |= __put_user(from->si_int, &to->si_int);
+		break;
+#ifdef __ARCH_SIGSYS
+	case __SI_SYS:
+		err |= __put_user(ptr_to_compat(from->si_call_addr),
+			&to->si_call_addr);
+		err |= __put_user(from->si_syscall, &to->si_syscall);
+		err |= __put_user(from->si_arch, &to->si_arch);
+		break;
+#endif
+	default: /* this is just in case for now ... */
+		err |= __put_user(from->si_pid, &to->si_pid);
+		err |= __put_user(from->si_uid, &to->si_uid);
+		break;
+	}
+	return err;
+}
+#endif
+
+#ifndef HAVE_ARCH_COPY_SIGINFO_FROM_USER32
+int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
+{
+	int err;
+	compat_uptr_t ptr32;
+
+	if (!access_ok(VERIFY_READ, from, sizeof(compat_siginfo_t)))
+		return -EFAULT;
+
+	/*
+	 * If you change siginfo_t structure, please be sure that
+	 * all these functions are fixed accordingly:
+	 * copy_siginfo_to_user
+	 * copy_siginfo_to_user32
+	 * copy_siginfo_from_user32
+	 * signalfd_copyinfo
+	 * They should never copy any pad contained in the structure
+	 * to avoid security leaks, but must copy the generic
+	 * 3 ints plus the relevant union member.
+	 */
+	err = __get_user(to->si_signo, &from->si_signo);
+	err |= __get_user(to->si_errno, &from->si_errno);
+	err |= __get_user(to->si_code, &from->si_code);
+	if (to->si_code < 0) {
+		/*
+		 * Note that the compat union may be larger than the normal one
+		 * due to alignment. We work around this by copying any data
+		 * that doesn't fit in the normal union into the padding before
+		 * the union.
+		 */
+		BUILD_BUG_ON(sizeof(to->_sifields._pad) + sizeof(to->_pad2) !=
+			sizeof(from->_sifields._pad));
+		err |= __copy_from_user(to->_sifields._pad,
+			from->_sifields._pad,
+			sizeof(to->_sifields._pad)) ? -EFAULT : 0;
+		err |= __copy_from_user(to->_pad2,
+			from->_sifields._pad + SI_PAD_SIZE, sizeof(to->_pad2))
+			? -EFAULT : 0;
+		return err;
+	}
+	switch (to->si_code & __SI_MASK) {
+	case __SI_KILL:
+		err |= __get_user(to->si_pid, &from->si_pid);
+		err |= __get_user(to->si_uid, &from->si_uid);
+		break;
+	case __SI_TIMER:
+		err |= __get_user(to->si_tid, &from->si_tid);
+		err |= __get_user(to->si_overrun, &from->si_overrun);
+		/*
+		 * Put the sigval in si_int, which matches the convention
+		 * used in get_compat_sigevent.
+		 */
+		to->si_ptr = NULL; /* Avoid uninitialized bits in the union */
+		err |= __get_user(to->si_int, &from->si_int);
+		break;
+	case __SI_POLL:
+		err |= __get_user(to->si_band, &from->si_band);
+		err |= __get_user(to->si_fd, &from->si_fd);
+		break;
+	case __SI_FAULT:
+		err |= __get_user(ptr32, &from->si_addr);
+		to->si_addr = compat_ptr(ptr32);
+#ifdef __ARCH_SI_TRAPNO
+		err |= __get_user(to->si_trapno, &from->si_trapno);
+#endif
+		err |= __get_user(to->si_addr_lsb, &from->si_addr_lsb);
+		err |= __get_user(ptr32, &from->si_lower);
+		to->si_lower = compat_ptr(ptr32);
+		err |= __get_user(ptr32, &from->si_upper);
+		to->si_upper = compat_ptr(ptr32);
+		break;
+	case __SI_CHLD:
+		err |= __get_user(to->si_pid, &from->si_pid);
+		err |= __get_user(to->si_uid, &from->si_uid);
+		err |= __get_user(to->si_status, &from->si_status);
+		err |= __get_user(to->si_utime, &from->si_utime);
+		err |= __get_user(to->si_stime, &from->si_stime);
+		break;
+	case __SI_RT: /* This is not generated by the kernel as of now. */
+	case __SI_MESGQ: /* But this is */
+		err |= __get_user(to->si_pid, &from->si_pid);
+		err |= __get_user(to->si_uid, &from->si_uid);
+		/*
+		 * Put the sigval in si_int, which matches the convention
+		 * used in get_compat_sigevent.
+		 */
+		to->si_ptr = NULL; /* Avoid uninitialized bits in the union */
+		err |= __get_user(to->si_int, &from->si_int);
+		break;
+#ifdef __ARCH_SIGSYS
+	case __SI_SYS:
+		err |= __get_user(ptr32, &from->si_call_addr);
+		to->si_call_addr = compat_ptr(ptr32);
+		err |= __get_user(to->si_syscall, &from->si_syscall);
+		err |= __get_user(to->si_arch, &from->si_arch);
+		break;
+#endif
+	default: /* this is just in case for now ... */
+		err |= __get_user(to->si_pid, &from->si_pid);
+		err |= __get_user(to->si_uid, &from->si_uid);
+		break;
+	}
+	return err;
+}
+#endif
diff --git a/kernel/signal.c b/kernel/signal.c
index 0f6bbbe..873e8e2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2713,11 +2713,13 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 		return __copy_to_user(to, from, sizeof(siginfo_t))
 			? -EFAULT : 0;
 	/*
-	 * If you change siginfo_t structure, please be sure
-	 * this code is fixed accordingly.
-	 * Please remember to update the signalfd_copyinfo() function
-	 * inside fs/signalfd.c too, in case siginfo_t changes.
-	 * It should never copy any pad contained in the structure
+	 * If you change siginfo_t structure, please be sure that
+	 * all these functions are fixed accordingly:
+	 * copy_siginfo_to_user
+	 * copy_siginfo_to_user32
+	 * copy_siginfo_from_user32
+	 * signalfd_copyinfo
+	 * They should never copy any pad contained in the structure
 	 * to avoid security leaks, but must copy the generic
 	 * 3 ints plus the relevant union member.
 	 */
-- 
2.6.2

