From: Florian Weimer <fweimer@redhat.com>
Subject: [PATCH] mm, x86: pkeys: Introduce PKEY_ALLOC_SIGNALINHERIT and change
 signal semantics
Date: Wed, 3 Jan 2018 13:31:25 +0100
Message-ID: <360ef254-48bc-aee6-70f9-858f773b8693@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------63FE4E7AB35B75B5A148D63E"
Return-path: <owner-linux-mm@kvack.org>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: linux-mm <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, linux-x86_64@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, x86@kernel.org, Dave Hansen <dave.hansen@intel.com>, Ram Pai <linuxram@us.ibm.com>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------63FE4E7AB35B75B5A148D63E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

This patch is based on the previous discussion (pkeys: Support setting 
access rights for signal handlers):

   https://marc.info/?t=151285426000001

It aligns the signal semantics of the x86 implementation with the 
upcoming POWER implementation, and defines a new flag, so that 
applications can detect which semantics the kernel uses.

A change in this area is needed to make memory protection keys usable 
for protecting the GOT in the dynamic linker.

(Feel free to replace the trigraphs in the commit message before 
committing, or to remove the program altogether.)

Thanks,
Florian

--------------63FE4E7AB35B75B5A148D63E
Content-Type: text/x-patch;
 name="pkeys-signalinherit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pkeys-signalinherit.patch"

>From 123906b83b4914aee61169af0fa7c8d6372cb8a4 Mon Sep 17 00:00:00 2001
From: Florian Weimer <fweimer@redhat.com>
Date: Wed, 3 Jan 2018 06:03:03 -0500
Subject: [PATCH] pkeys: Introduce PKEY_ALLOC_SIGNALINHERIT and change signal
 semantics

pkeys support for IBM POWER intends to inherited the access rights of
the current thread in signal handlers.  The advantage is that this
preserves access to memory regions associated with non-default keys,
enabling additional usage scenarios for memory protection keys which
currently do not work on x86 due to the unconditional reset to the
(configurable) default key in signal handlers.

Consequently, this commit updates the x86 implementation to preserve
the PKRU register value of the interrupted context in signal handlers.
If a key is allocated successfully with the PKEY_ALLOC_SIGNALINHERIT
flag, the application can assume this signal inheritance behavior.

This change does not affect the init_pkru optimization because if the
thread's PKRU register is zero due to the init_pkru setting, it will
remain zero in the signal handler through inheritance from the
interrupted context.

After this change, this program:

??=include <sys/syscall.h>
??=include <unistd.h>
??=include <stdio.h>
??=include <err.h>
??=include <signal.h>

??=define PKEY_ALLOC_SIGNALINHERIT 1
??=define PKEY_DISABLE_ACCESS 1
??=define PKEY_DISABLE_WRITE 2

static inline unsigned int
pkey_read (void)
{
  unsigned int result;
  __asm__ volatile (".byte 0x0f, 0x01, 0xee"
                    : "=a" (result) : "c" (0) : "rdx");
  return result;
}

static void
print_pkru (const char *where)
{
  printf ("PKRU (%s): %08x\n", where, pkey_read ());
}

static void
sigusr1 (int signo)
{
  print_pkru ("signal handler");
}

int
main (void)
{
  if (signal (SIGUSR1, sigusr1) == SIG_ERR)
    err (1, "signal");
  print_pkru ("main");
  raise (SIGUSR1);

  puts ("allocating key 1");
  int key1 = syscall (SYS_pkey_alloc, PKEY_ALLOC_SIGNALINHERIT, 0);
  if (key1 < 0)
    err (1, "pkey_alloc");
  print_pkru ("main");
  raise (SIGUSR1);

  puts ("allocating key 2");
  int key2 = syscall (SYS_pkey_alloc, PKEY_ALLOC_SIGNALINHERIT,
                      PKEY_DISABLE_ACCESS);
  if (key2 < 0)
    err (1, "pkey_alloc");
  print_pkru ("main");
  raise (SIGUSR1);

  puts ("allocating key 3");
  int key3 = syscall (SYS_pkey_alloc, PKEY_ALLOC_SIGNALINHERIT,
                      PKEY_DISABLE_WRITE);
  if (key3 < 0)
    err (1, "pkey_alloc");
  print_pkru ("main");
  raise (SIGUSR1);

  return 0;
}

should print:

PKRU (main): 55555554
PKRU (signal handler): 55555554
allocating key 1
PKRU (main): 55555550
PKRU (signal handler): 55555550
allocating key 2
PKRU (main): 55555550
PKRU (signal handler): 55555550
allocating key 3
PKRU (main): 55555590
PKRU (signal handler): 55555590

That is, the PKRU register value in the signal handler matches that of
the main thread, even if the access rights have been changed from the
system default.

Signed-off-by: Florian Weimer <fweimer@redhat.com>
---
 Documentation/x86/protection-keys.txt         |  9 ++++-
 arch/alpha/include/uapi/asm/mman.h            |  2 ++
 arch/mips/include/uapi/asm/mman.h             |  2 ++
 arch/parisc/include/uapi/asm/mman.h           |  2 ++
 arch/x86/include/asm/fpu/internal.h           |  1 +
 arch/x86/kernel/fpu/core.c                    | 47 +++++++++++++++++++++------
 arch/x86/kernel/signal.c                      |  2 +-
 arch/xtensa/include/uapi/asm/mman.h           |  2 ++
 include/uapi/asm-generic/mman-common.h        |  2 ++
 mm/mprotect.c                                 | 12 +++++--
 tools/include/uapi/asm-generic/mman-common.h  |  2 ++
 tools/testing/selftests/x86/protection_keys.c |  2 ++
 12 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/Documentation/x86/protection-keys.txt b/Documentation/x86/protection-keys.txt
index ecb0d2d..d46d8e50 100644
--- a/Documentation/x86/protection-keys.txt
+++ b/Documentation/x86/protection-keys.txt
@@ -39,11 +39,18 @@ with a key.  In this example WRPKRU is wrapped by a C function
 called pkey_set().
 
 	int real_prot = PROT_READ|PROT_WRITE;
-	pkey = pkey_alloc(0, PKEY_DISABLE_WRITE);
+	pkey = pkey_alloc(PKEY_ALLOC_SIGNALINHERIT, PKEY_DISABLE_WRITE);
 	ptr = mmap(NULL, PAGE_SIZE, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
 	ret = pkey_mprotect(ptr, PAGE_SIZE, real_prot, pkey);
 	... application runs here
 
+The PKEY_ALLOC_SIGNALINHERIT flag ensures the that key allocation
+fails if the kernel does not support access rights inheritance for
+signal handlers.  (Some kernel versions implement different semantics
+where signal handlers execute not with the access rights of the
+interrupted thread, but with some unspecified system default access
+rights.)
+
 Now, if the application needs to update the data at 'ptr', it can
 gain access, do the update, then remove its write access:
 
diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
index 2dbdf59..eb9432f 100644
--- a/arch/alpha/include/uapi/asm/mman.h
+++ b/arch/alpha/include/uapi/asm/mman.h
@@ -72,6 +72,8 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+#define PKEY_ALLOC_SIGNALINHERIT 0x1
+
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
diff --git a/arch/mips/include/uapi/asm/mman.h b/arch/mips/include/uapi/asm/mman.h
index 606e02c..cb7c09e 100644
--- a/arch/mips/include/uapi/asm/mman.h
+++ b/arch/mips/include/uapi/asm/mman.h
@@ -99,6 +99,8 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+#define PKEY_ALLOC_SIGNALINHERIT 0x1
+
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
index 80510ba..0a0b770 100644
--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -69,6 +69,8 @@
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
 
+#define PKEY_ALLOC_SIGNALINHERIT 0x1
+
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index a38bf5a..a87e99f7 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -33,6 +33,7 @@
 extern void fpu__drop(struct fpu *fpu);
 extern int  fpu__copy(struct fpu *dst_fpu, struct fpu *src_fpu);
 extern void fpu__clear(struct fpu *fpu);
+extern void fpu__clear_signal(struct fpu *fpu);
 extern int  fpu__exception_code(struct fpu *fpu, int trap_nr);
 extern int  dump_fpu(struct pt_regs *ptregs, struct user_i387_struct *fpstate);
 
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index f92a659..a3b3048 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -370,21 +370,16 @@ static inline void copy_init_fpstate_to_fpregs(void)
 		copy_kernel_to_fxregs(&init_fpstate.fxsave);
 	else
 		copy_kernel_to_fregs(&init_fpstate.fsave);
-
-	if (boot_cpu_has(X86_FEATURE_OSPKE))
-		copy_init_pkru_to_fpregs();
 }
 
-/*
- * Clear the FPU state back to init state.
- *
- * Called by sys_execve(), by the signal handler code and by various
- * error paths.
- */
-void fpu__clear(struct fpu *fpu)
+static void __fpu_clear(struct fpu *fpu, bool for_signal)
 {
+	u32 pkru;
+
 	WARN_ON_FPU(fpu != &current->thread.fpu); /* Almost certainly an anomaly */
 
+	if (for_signal)
+		pkru = read_pkru();
 	fpu__drop(fpu);
 
 	/*
@@ -395,11 +390,43 @@ void fpu__clear(struct fpu *fpu)
 		fpu__initialize(fpu);
 		user_fpu_begin();
 		copy_init_fpstate_to_fpregs();
+		if (boot_cpu_has(X86_FEATURE_OSPKE)) {
+			/* A signal handler inherits the original PKRU
+			 * value of the interrupted thread.
+			 */
+			if (for_signal)
+				__write_pkru(pkru);
+			else
+				copy_init_pkru_to_fpregs();
+		}
 		preempt_enable();
 	}
 }
 
 /*
+ * Clear the FPU state back to init state.
+ *
+ * Called by sys_execve(), the signal handler return code, and by
+ * various error paths.
+ */
+void fpu__clear(struct fpu *fpu)
+{
+	return __fpu_clear(fpu, false);
+}
+
+/*
+ * Prepare the FPU for invoking a signal handler.
+ *
+ * This is like fpu__clear(), but some CPU registers are inherited
+ * from the current thread and not restored to their initial values,
+ * to match behavior on other architectures.
+ */
+void fpu__clear_signal(struct fpu *fpu)
+{
+	return __fpu_clear(fpu, true);
+}
+
+/*
  * x87 math exception handling:
  */
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b9e00e8..4263f18 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -757,7 +757,7 @@ static inline int is_x32_frame(struct ksignal *ksig)
 		 * Ensure the signal handler starts with the new fpu state.
 		 */
 		if (fpu->initialized)
-			fpu__clear(fpu);
+			fpu__clear_signal(fpu);
 	}
 	signal_setup_done(failed, ksig, stepping);
 }
diff --git a/arch/xtensa/include/uapi/asm/mman.h b/arch/xtensa/include/uapi/asm/mman.h
index 3e9d01a..39af4a5 100644
--- a/arch/xtensa/include/uapi/asm/mman.h
+++ b/arch/xtensa/include/uapi/asm/mman.h
@@ -111,6 +111,8 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+#define PKEY_ALLOC_SIGNALINHERIT 0x1
+
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index f8b134f..e215442 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -66,6 +66,8 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+#define PKEY_ALLOC_SIGNALINHERIT 0x1
+
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
diff --git a/mm/mprotect.c b/mm/mprotect.c
index ec39f73..e30fc60 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -523,14 +523,21 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 	return do_mprotect_pkey(start, len, prot, pkey);
 }
 
+#define PKEY_ALLOC_FLAGS ((unsigned long) (PKEY_ALLOC_SIGNALINHERIT))
+
 SYSCALL_DEFINE2(pkey_alloc, unsigned long, flags, unsigned long, init_val)
 {
 	int pkey;
 	int ret;
 
-	/* No flags supported yet. */
-	if (flags)
+	/* Check for unsupported flags. No further action for
+	 * PKEY_ALLOC_SIGNALINHERIT is required; this flag merely
+	 * provides a way for applications to detect that allocated
+	 * keys support inheriting access rights in signal handler.
+	 */
+	if (flags & ~PKEY_ALLOC_FLAGS)
 		return -EINVAL;
+
 	/* check for unsupported init values */
 	if (init_val & ~PKEY_ACCESS_MASK)
 		return -EINVAL;
@@ -547,6 +554,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 		mm_pkey_free(current->mm, pkey);
 		goto out;
 	}
+
 	ret = pkey;
 out:
 	up_write(&current->mm->mmap_sem);
diff --git a/tools/include/uapi/asm-generic/mman-common.h b/tools/include/uapi/asm-generic/mman-common.h
index f8b134f..e215442 100644
--- a/tools/include/uapi/asm-generic/mman-common.h
+++ b/tools/include/uapi/asm-generic/mman-common.h
@@ -66,6 +66,8 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+#define PKEY_ALLOC_SIGNALINHERIT 0x1
+
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
 #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
diff --git a/tools/testing/selftests/x86/protection_keys.c b/tools/testing/selftests/x86/protection_keys.c
index bc1b073..bee6db2 100644
--- a/tools/testing/selftests/x86/protection_keys.c
+++ b/tools/testing/selftests/x86/protection_keys.c
@@ -421,6 +421,8 @@ void dumpit(char *f)
 	close(fd);
 }
 
+#define PKEY_ALLOC_SIGNALINHERIT 0x1
+
 #define PKEY_DISABLE_ACCESS    0x1
 #define PKEY_DISABLE_WRITE     0x2
 
-- 
1.8.3.1


--------------63FE4E7AB35B75B5A148D63E--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
