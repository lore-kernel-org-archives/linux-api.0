From: akpm@linux-foundation.org
Subject: + mmfork-introduce-madv_wipeonfork.patch added to -mm tree
Date: Tue, 15 Aug 2017 15:52:35 -0700
Message-ID: <59937b33.ciCYy+JUPcxPm+RN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
To: riel@redhat.com, colm@allcosts.net, dave.hansen@intel.com, fweimer@redhat.com, hpa@zytor.com, keescook@chromium.org, kirill@shutemov.name, linux-api@vger.kernel.org, luto@amacapital.net, mike.kravetz@oracle.com, mingo@kernel.org, tglx@linutronix.de, wad@chromium.org, willy@infradead.org, mm-commits@vger.kernel.org
List-Id: linux-api@vger.kernel.org


The patch titled
     Subject: mm,fork: introduce MADV_WIPEONFORK
has been added to the -mm tree.  Its filename is
     mmfork-introduce-madv_wipeonfork.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmfork-introduce-madv_wipeonfork.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmfork-introduce-madv_wipeonfork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm,fork: introduce MADV_WIPEONFORK

Introduce MADV_WIPEONFORK semantics, which result in a VMA being empty in
the child process after fork.  This differs from MADV_DONTFORK in one
important way.

If a child process accesses memory that was MADV_WIPEONFORK, it will get
zeroes.  The address ranges are still valid, they are just empty.

If a child process accesses memory that was MADV_DONTFORK, it will get a
segmentation fault, since those address ranges are no longer valid in the
child after fork.

Since MADV_DONTFORK also seems to be used to allow very large programs to
fork in systems with strict memory overcommit restrictions, changing the
semantics of MADV_DONTFORK might break existing programs.

MADV_WIPEONFORK only works on private, anonymous VMAs.

The use case is libraries that store or cache information, and want to
know that they need to regenerate it in the child process after fork.

Examples of this would be:
- systemd/pulseaudio API checks (fail after fork)
  (replacing a getpid check, which is too slow without a PID cache)
- PKCS#11 API reinitialization check (mandated by specification)
- glibc's upcoming PRNG (reseed after fork)
- OpenSSL PRNG (reseed after fork)

The security benefits of a forking server having a re-inialized PRNG in
every child process are pretty obvious.  However, due to libraries having
all kinds of internal state, and programs getting compiled with many
different versions of each library, it is unreasonable to expect calling
programs to re-initialize everything manually after fork.

A further complication is the proliferation of clone flags, programs
bypassing glibc's functions to call clone directly, and programs calling
unshare, causing the glibc pthread_atfork hook to not get called.

It would be better to have the kernel take care of this automatically.

The patch also adds MADV_KEEPONFORK, to undo the effects of a prior
MADV_WIPEONFORK.

This is similar to the OpenBSD minherit syscall with MAP_INHERIT_ZERO:

    https://man.openbsd.org/minherit.2

Link: http://lkml.kernel.org/r/20170811212829.29186-3-riel@redhat.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Florian Weimer <fweimer@redhat.com>
Reported-by: Colm MacCártaigh <colm@allcosts.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Drewry <wad@chromium.org>
Cc: <linux-api@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h     |    3 +++
 arch/mips/include/uapi/asm/mman.h      |    3 +++
 arch/parisc/include/uapi/asm/mman.h    |    3 +++
 arch/xtensa/include/uapi/asm/mman.h    |    3 +++
 fs/proc/task_mmu.c                     |    1 +
 include/linux/mm.h                     |    2 +-
 include/trace/events/mmflags.h         |    8 +-------
 include/uapi/asm-generic/mman-common.h |    3 +++
 kernel/fork.c                          |   10 ++++++++--
 mm/madvise.c                           |   13 +++++++++++++
 10 files changed, 39 insertions(+), 10 deletions(-)

diff -puN arch/alpha/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -64,6 +64,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
+#define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
+#define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/mips/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -91,6 +91,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
+#define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
+#define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/parisc/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -60,6 +60,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
 
+#define MADV_WIPEONFORK 71		/* Zero memory on fork, child only */
+#define MADV_KEEPONFORK 72		/* Undo MADV_WIPEONFORK */
+
 /* compatibility flags */
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
diff -puN arch/xtensa/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mmfork-introduce-madv_wipeonfork
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -103,6 +103,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
+#define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
+#define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN fs/proc/task_mmu.c~mmfork-introduce-madv_wipeonfork fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mmfork-introduce-madv_wipeonfork
+++ a/fs/proc/task_mmu.c
@@ -664,6 +664,7 @@ static void show_smap_vma_flags(struct s
 		[ilog2(VM_NORESERVE)]	= "nr",
 		[ilog2(VM_HUGETLB)]	= "ht",
 		[ilog2(VM_ARCH_1)]	= "ar",
+		[ilog2(VM_WIPEONFORK)]	= "wf",
 		[ilog2(VM_DONTDUMP)]	= "dd",
 #ifdef CONFIG_MEM_SOFT_DIRTY
 		[ilog2(VM_SOFTDIRTY)]	= "sd",
diff -puN include/linux/mm.h~mmfork-introduce-madv_wipeonfork include/linux/mm.h
--- a/include/linux/mm.h~mmfork-introduce-madv_wipeonfork
+++ a/include/linux/mm.h
@@ -189,7 +189,7 @@ extern unsigned int kobjsize(const void
 #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
-#define VM_ARCH_2	0x02000000
+#define VM_WIPEONFORK	0x02000000	/* Wipe VMA contents in child. */
 #define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
diff -puN include/trace/events/mmflags.h~mmfork-introduce-madv_wipeonfork include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~mmfork-introduce-madv_wipeonfork
+++ a/include/trace/events/mmflags.h
@@ -124,12 +124,6 @@ IF_HAVE_PG_IDLE(PG_idle,		"idle"		)
 #define __VM_ARCH_SPECIFIC_1 {VM_ARCH_1,	"arch_1"	}
 #endif
 
-#if defined(CONFIG_X86)
-#define __VM_ARCH_SPECIFIC_2 {VM_MPX,		"mpx"		}
-#else
-#define __VM_ARCH_SPECIFIC_2 {VM_ARCH_2,	"arch_2"	}
-#endif
-
 #ifdef CONFIG_MEM_SOFT_DIRTY
 #define IF_HAVE_VM_SOFTDIRTY(flag,name) {flag, name },
 #else
@@ -161,7 +155,7 @@ IF_HAVE_PG_IDLE(PG_idle,		"idle"		)
 	{VM_NORESERVE,			"noreserve"	},		\
 	{VM_HUGETLB,			"hugetlb"	},		\
 	__VM_ARCH_SPECIFIC_1				,		\
-	__VM_ARCH_SPECIFIC_2				,		\
+	{VM_WIPEONFORK,			"wipeonfork"	},		\
 	{VM_DONTDUMP,			"dontdump"	},		\
 IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 	{VM_MIXEDMAP,			"mixedmap"	},		\
diff -puN include/uapi/asm-generic/mman-common.h~mmfork-introduce-madv_wipeonfork include/uapi/asm-generic/mman-common.h
--- a/include/uapi/asm-generic/mman-common.h~mmfork-introduce-madv_wipeonfork
+++ a/include/uapi/asm-generic/mman-common.h
@@ -58,6 +58,9 @@
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_DONTDUMP flag */
 
+#define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
+#define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN kernel/fork.c~mmfork-introduce-madv_wipeonfork kernel/fork.c
--- a/kernel/fork.c~mmfork-introduce-madv_wipeonfork
+++ a/kernel/fork.c
@@ -654,7 +654,12 @@ static __latent_entropy int dup_mmap(str
 		retval = dup_userfaultfd(tmp, &uf);
 		if (retval)
 			goto fail_nomem_anon_vma_fork;
-		if (anon_vma_fork(tmp, mpnt))
+		if (tmp->vm_flags & VM_WIPEONFORK) {
+			/* VM_WIPEONFORK gets a clean slate in the child. */
+			tmp->anon_vma = NULL;
+			if (anon_vma_prepare(tmp))
+				goto fail_nomem_anon_vma_fork;
+		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
 		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
 		tmp->vm_next = tmp->vm_prev = NULL;
@@ -698,7 +703,8 @@ static __latent_entropy int dup_mmap(str
 		rb_parent = &tmp->vm_rb;
 
 		mm->map_count++;
-		retval = copy_page_range(mm, oldmm, mpnt);
+		if (!(tmp->vm_flags & VM_WIPEONFORK))
+			retval = copy_page_range(mm, oldmm, mpnt);
 
 		if (tmp->vm_ops && tmp->vm_ops->open)
 			tmp->vm_ops->open(tmp);
diff -puN mm/madvise.c~mmfork-introduce-madv_wipeonfork mm/madvise.c
--- a/mm/madvise.c~mmfork-introduce-madv_wipeonfork
+++ a/mm/madvise.c
@@ -80,6 +80,17 @@ static long madvise_behavior(struct vm_a
 		}
 		new_flags &= ~VM_DONTCOPY;
 		break;
+	case MADV_WIPEONFORK:
+		/* MADV_WIPEONFORK is only supported on anonymous memory. */
+		if (vma->vm_file || vma->vm_flags & VM_SHARED) {
+			error = -EINVAL;
+			goto out;
+		}
+		new_flags |= VM_WIPEONFORK;
+		break;
+	case MADV_KEEPONFORK:
+		new_flags &= ~VM_WIPEONFORK;
+		break;
 	case MADV_DONTDUMP:
 		new_flags |= VM_DONTDUMP;
 		break;
@@ -690,6 +701,8 @@ madvise_behavior_valid(int behavior)
 #endif
 	case MADV_DONTDUMP:
 	case MADV_DODUMP:
+	case MADV_WIPEONFORK:
+	case MADV_KEEPONFORK:
 #ifdef CONFIG_MEMORY_FAILURE
 	case MADV_SOFT_OFFLINE:
 	case MADV_HWPOISON:
_

Patches currently in -mm which might be from riel@redhat.com are

x86mpx-make-mpx-depend-on-x86-64-to-free-up-vma-flag.patch
mmfork-introduce-madv_wipeonfork.patch

