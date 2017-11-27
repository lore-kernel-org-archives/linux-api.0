From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/3] y2038: elfcore: use __kernel_old_timeval for process times
Date: Mon, 27 Nov 2017 18:00:46 +0100
Message-ID: <20171127170121.634826-2-arnd@arndb.de>
References: <20171127170121.634826-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171127170121.634826-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: y2038@lists.linaro.org, libc-alpha@sourceware.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Albert ARIBAUD <albert.aribaud@3adev.fr>, Arnd Bergmann <arnd@arndb.de>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Denys Vlasenko <dvlasenk@redhat.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Dave Martin <Dave.Martin@arm.com>, Mickael GUENE <mickael.guene@st.com>, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linux-fsdev
List-Id: linux-api@vger.kernel.org

We store elapsed time for a crashed process in struct elf_prstatus using
'timeval' structures. Once glibc starts using 64-bit time_t, this becomes
incompatible with the kernel's idea of timeval since the structure layout
no longer matches on 32-bit architectures.

This changes the definition of the elf_prstatus structure to use
__kernel_old_timeval instead, which is hardcoded to the currently used
binary layout. There is no risk of overflow in y2038 though, because
the time values are all relative times, and can store up to 68 years
of process elapsed time.

There is a risk of applications breaking at build time when they
use the new kernel headers and expect the type to be exactly 'timeval'
rather than a structure that has the same fields as before. Those
applications have to be modified to deal with 64-bit time_t anyway.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/mips/kernel/binfmt_elfn32.c  |  4 ++--
 arch/mips/kernel/binfmt_elfo32.c  |  4 ++--
 arch/parisc/kernel/binfmt_elf32.c |  4 ++--
 fs/binfmt_elf.c                   | 12 ++++++------
 fs/binfmt_elf_fdpic.c             | 12 ++++++------
 fs/compat_binfmt_elf.c            |  4 ++--
 include/uapi/linux/elfcore.h      |  8 ++++----
 7 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/mips/kernel/binfmt_elfn32.c b/arch/mips/kernel/binfmt_elfn32.c
index 89b234844534..2fe2d5573289 100644
--- a/arch/mips/kernel/binfmt_elfn32.c
+++ b/arch/mips/kernel/binfmt_elfn32.c
@@ -100,7 +100,7 @@ jiffies_to_compat_timeval(unsigned long jiffies, struct compat_timeval *value)
 #undef TASK_SIZE
 #define TASK_SIZE TASK_SIZE32
 
-#undef ns_to_timeval
-#define ns_to_timeval ns_to_compat_timeval
+#undef ns_to_kernel_old_timeval
+#define ns_to_kernel_old_timeval ns_to_compat_timeval
 
 #include "../../../fs/binfmt_elf.c"
diff --git a/arch/mips/kernel/binfmt_elfo32.c b/arch/mips/kernel/binfmt_elfo32.c
index a88c59db3d48..d3c37583ef91 100644
--- a/arch/mips/kernel/binfmt_elfo32.c
+++ b/arch/mips/kernel/binfmt_elfo32.c
@@ -103,7 +103,7 @@ jiffies_to_compat_timeval(unsigned long jiffies, struct compat_timeval *value)
 #undef TASK_SIZE
 #define TASK_SIZE TASK_SIZE32
 
-#undef ns_to_timeval
-#define ns_to_timeval ns_to_compat_timeval
+#undef ns_to_kernel_old_timeval
+#define ns_to_kernel_old_timeval ns_to_compat_timeval
 
 #include "../../../fs/binfmt_elf.c"
diff --git a/arch/parisc/kernel/binfmt_elf32.c b/arch/parisc/kernel/binfmt_elf32.c
index 20dfa081ed0b..ad3ea00c64f7 100644
--- a/arch/parisc/kernel/binfmt_elf32.c
+++ b/arch/parisc/kernel/binfmt_elf32.c
@@ -92,7 +92,7 @@ struct elf_prpsinfo32
 	current->thread.map_base = DEFAULT_MAP_BASE32; \
 	current->thread.task_size = DEFAULT_TASK_SIZE32 \
 
-#undef ns_to_timeval
-#define ns_to_timeval ns_to_compat_timeval
+#undef ns_to_kernel_old_timeval
+#define ns_to_kernel_old_timeval ns_to_compat_timeval
 
 #include "../../../fs/binfmt_elf.c"
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 83732fef510d..7ae716db7d99 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1500,18 +1500,18 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		 * group-wide total, not its individual thread total.
 		 */
 		thread_group_cputime(p, &cputime);
-		prstatus->pr_utime = ns_to_timeval(cputime.utime);
-		prstatus->pr_stime = ns_to_timeval(cputime.stime);
+		prstatus->pr_utime = ns_to_kernel_old_timeval(cputime.utime);
+		prstatus->pr_stime = ns_to_kernel_old_timeval(cputime.stime);
 	} else {
 		u64 utime, stime;
 
 		task_cputime(p, &utime, &stime);
-		prstatus->pr_utime = ns_to_timeval(utime);
-		prstatus->pr_stime = ns_to_timeval(stime);
+		prstatus->pr_utime = ns_to_kernel_old_timeval(utime);
+		prstatus->pr_stime = ns_to_kernel_old_timeval(stime);
 	}
 
-	prstatus->pr_cutime = ns_to_timeval(p->signal->cutime);
-	prstatus->pr_cstime = ns_to_timeval(p->signal->cstime);
+	prstatus->pr_cutime = ns_to_kernel_old_timeval(p->signal->cutime);
+	prstatus->pr_cstime = ns_to_kernel_old_timeval(p->signal->cstime);
 }
 
 static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 429326b6e2e7..89717459224b 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1362,17 +1362,17 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		 * group-wide total, not its individual thread total.
 		 */
 		thread_group_cputime(p, &cputime);
-		prstatus->pr_utime = ns_to_timeval(cputime.utime);
-		prstatus->pr_stime = ns_to_timeval(cputime.stime);
+		prstatus->pr_utime = ns_to_kernel_old_timeval(cputime.utime);
+		prstatus->pr_stime = ns_to_kernel_old_timeval(cputime.stime);
 	} else {
 		u64 utime, stime;
 
 		task_cputime(p, &utime, &stime);
-		prstatus->pr_utime = ns_to_timeval(utime);
-		prstatus->pr_stime = ns_to_timeval(stime);
+		prstatus->pr_utime = ns_to_kernel_old_timeval(utime);
+		prstatus->pr_stime = ns_to_kernel_old_timeval(stime);
 	}
-	prstatus->pr_cutime = ns_to_timeval(p->signal->cutime);
-	prstatus->pr_cstime = ns_to_timeval(p->signal->cstime);
+	prstatus->pr_cutime = ns_to_kernel_old_timeval(p->signal->cutime);
+	prstatus->pr_cstime = ns_to_kernel_old_timeval(p->signal->cstime);
 
 	prstatus->pr_exec_fdpic_loadmap = p->mm->context.exec_fdpic_loadmap;
 	prstatus->pr_interp_fdpic_loadmap = p->mm->context.interp_fdpic_loadmap;
diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index 504b3c3539dc..5df608af1306 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -51,8 +51,8 @@
 #define elf_prstatus	compat_elf_prstatus
 #define elf_prpsinfo	compat_elf_prpsinfo
 
-#undef ns_to_timeval
-#define ns_to_timeval ns_to_compat_timeval
+#undef ns_to_kernel_old_timeval
+#define ns_to_kernel_old_timeval ns_to_compat_timeval
 
 /*
  * To use this file, asm/elf.h must define compat_elf_check_arch.
diff --git a/include/uapi/linux/elfcore.h b/include/uapi/linux/elfcore.h
index 0b2c9e16e345..baf03562306d 100644
--- a/include/uapi/linux/elfcore.h
+++ b/include/uapi/linux/elfcore.h
@@ -53,10 +53,10 @@ struct elf_prstatus
 	pid_t	pr_ppid;
 	pid_t	pr_pgrp;
 	pid_t	pr_sid;
-	struct timeval pr_utime;	/* User time */
-	struct timeval pr_stime;	/* System time */
-	struct timeval pr_cutime;	/* Cumulative user time */
-	struct timeval pr_cstime;	/* Cumulative system time */
+	struct __kernel_old_timeval pr_utime;	/* User time */
+	struct __kernel_old_timeval pr_stime;	/* System time */
+	struct __kernel_old_timeval pr_cutime;	/* Cumulative user time */
+	struct __kernel_old_timeval pr_cstime;	/* Cumulative system time */
 #if 0
 	long	pr_instr;		/* Current instruction */
 #endif
-- 
2.9.0
