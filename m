From: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 05/13] Split FDPIC "struct elf_prstatus" to "struct elf_fdpic_prstatus"
Date: Mon, 14 Sep 2015 15:50:39 -0700
Message-ID: <1442271047-4908-6-git-send-email-palmer__14478.3117263161$1442271322$gmane$org@dabbelt.com>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442271047-4908-1-git-send-email-palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org, aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 3chas3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org, dave-gkUM19QKKo4@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org, jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a pretty big change that I haven't tested any, which worries
me a lot.  The general idea here is that "struct elf_prstatus" can be
visible to userspace (from <linux/ptrace.h>)

  "
   Generic ptrace interface that exports the architecture specific
   regsets using the corresponding NT_* types (which are also used in
   the core dump).  Please note that the NT_PRSTATUS note type in a
   core dump contains a full 'struct elf_prstatus'. But the
   user_regset for NT_PRSTATUS contains just the elf_gregset_t that is
   the pr_reg field of 'struct elf_prstatus'. For all the other
   user_regset flavors, the user_regset layout and the ELF core dump
   note payload are exactly the same layout.
  "

so it shouldn't have an "#ifdef CONFIG_" in there.

This splits the structure into two different structures, one still
named "struct elf_prstatus", and one for ELF FDPIC that is named
"struct elf_fdpic_prstatus" -- the idea here is that most users are
standard ELF, so that's the name that didn't change.

I tried to fix all the users of "struct elf_prstatus" that should now
be using "struct elf_fdpic_prstatus".  The only testing I did here was
to build a Blackfin defconfig with "struct elf_prstatus" not defined,
and to build an x86 defconfig with "struct elf_fdpic_prstatus" not
defined.

Note that this fails checkpatch.pl with a complaint about wanting open
braces on the same line as struct definitions.  The existing struct
definitions in this file have the brace a line afterwards, so I'm
going to leave this alone.

Signed-off-by: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Andrew Waterman <waterman-aFE07iDfcCIb0cFwG/AQJIdd74u8MsAO@public.gmane.org>
Reviewed-by: Albert Ou <aou-aFE07iDfcCIb0cFwG/AQJIdd74u8MsAO@public.gmane.org>
---
 fs/binfmt_elf_fdpic.c        |  6 +++---
 fs/proc/kcore.c              | 16 ++++++++++++++++
 include/linux/kexec.h        |  4 ++++
 include/uapi/linux/elfcore.h | 37 +++++++++++++++++++++++++++++++++++--
 kernel/kexec_core.c          |  4 ++++
 5 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index d3634bfb7fe1..587bf0466d71 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1323,7 +1323,7 @@ static inline void fill_note(struct memelfnote *note, const char *name, int type
  * fill up all the fields in prstatus from the given task struct, except
  * registers which need to be filled up separately.
  */
-static void fill_prstatus(struct elf_prstatus *prstatus,
+static void fill_prstatus(struct elf_fdpic_prstatus *prstatus,
 			  struct task_struct *p, long signr)
 {
 	prstatus->pr_info.si_signo = prstatus->pr_cursig = signr;
@@ -1406,7 +1406,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 struct elf_thread_status
 {
 	struct list_head list;
-	struct elf_prstatus prstatus;	/* NT_PRSTATUS */
+	struct elf_fdpic_prstatus prstatus;	/* NT_PRSTATUS */
 	elf_fpregset_t fpu;		/* NT_PRFPREG */
 	struct task_struct *thread;
 #ifdef ELF_CORE_COPY_XFPREGS
@@ -1539,7 +1539,7 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 	loff_t offset = 0, dataoff;
 	int numnote;
 	struct memelfnote *notes = NULL;
-	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
+	struct elf_fdpic_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
 	struct elf_prpsinfo *psinfo = NULL;	/* NT_PRPSINFO */
  	LIST_HEAD(thread_list);
  	struct list_head *t;
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 92e6726f6e37..b1edd77ec854 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -90,7 +90,11 @@ static size_t get_kcore_size(int *nphdr, size_t *elf_buflen)
 			(*nphdr + 2)*sizeof(struct elf_phdr) + 
 			3 * ((sizeof(struct elf_note)) +
 			     roundup(sizeof(CORE_STR), 4)) +
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+			roundup(sizeof(struct elf_fdpic_prstatus), 4) +
+#else
 			roundup(sizeof(struct elf_prstatus), 4) +
+#endif
 			roundup(sizeof(struct elf_prpsinfo), 4) +
 			roundup(arch_task_struct_size, 4);
 	*elf_buflen = PAGE_ALIGN(*elf_buflen);
@@ -318,7 +322,11 @@ static char *storenote(struct memelfnote *men, char *bufp)
  */
 static void elf_kcore_store_hdr(char *bufp, int nphdr, int dataoff)
 {
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	struct elf_fdpic_prstatus prstatus;	/* NT_PRSTATUS */
+#else
 	struct elf_prstatus prstatus;	/* NT_PRSTATUS */
+#endif
 	struct elf_prpsinfo prpsinfo;	/* NT_PRPSINFO */
 	struct elf_phdr *nhdr, *phdr;
 	struct elfhdr *elf;
@@ -387,10 +395,18 @@ static void elf_kcore_store_hdr(char *bufp, int nphdr, int dataoff)
 	/* set up the process status */
 	notes[0].name = CORE_STR;
 	notes[0].type = NT_PRSTATUS;
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	notes[0].datasz = sizeof(struct elf_fdpic_prstatus);
+#else
 	notes[0].datasz = sizeof(struct elf_prstatus);
+#endif
 	notes[0].data = &prstatus;
 
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	memset(&prstatus, 0, sizeof(struct elf_fdpic_prstatus));
+#else
 	memset(&prstatus, 0, sizeof(struct elf_prstatus));
+#endif
 
 	nhdr->p_filesz	= notesize(&notes[0]);
 	bufp = storenote(&notes[0], bufp);
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d140b1e9faa7..d9196ccd3781 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -63,7 +63,11 @@
 #define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
 #define KEXEC_CORE_NOTE_NAME "CORE"
 #define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+#define KEXEC_CORE_NOTE_DESC_BYTES ALIGN(sizeof(struct elf_fdpic_prstatus), 4)
+#else
 #define KEXEC_CORE_NOTE_DESC_BYTES ALIGN(sizeof(struct elf_prstatus), 4)
+#endif
 /*
  * The per-cpu notes area is a list of notes terminated by a "NULL"
  * note header.  For kdump, the code in vmcore.c runs in the context
diff --git a/include/uapi/linux/elfcore.h b/include/uapi/linux/elfcore.h
index 569737cfb557..697c52db0227 100644
--- a/include/uapi/linux/elfcore.h
+++ b/include/uapi/linux/elfcore.h
@@ -60,7 +60,40 @@ struct elf_prstatus
 	long	pr_instr;		/* Current instruction */
 #endif
 	elf_gregset_t pr_reg;	/* GP registers */
-#ifdef CONFIG_BINFMT_ELF_FDPIC
+	int pr_fpvalid;		/* True if math co-processor being used.  */
+};
+
+/* Architectures that set CONFIG_BINFMT_ELF_FDPIC use this instead of
+ * "struct elf_prstatus".
+ */
+struct elf_fdpic_prstatus
+{
+#if 0
+	long	pr_flags;	/* XXX Process flags */
+	short	pr_why;		/* XXX Reason for process halt */
+	short	pr_what;	/* XXX More detailed reason */
+#endif
+	struct elf_siginfo pr_info;	/* Info associated with signal */
+	short	pr_cursig;		/* Current signal */
+	unsigned long pr_sigpend;	/* Set of pending signals */
+	unsigned long pr_sighold;	/* Set of held signals */
+#if 0
+	struct sigaltstack pr_altstack;	/* Alternate stack info */
+	struct sigaction pr_action;	/* Signal action for current sig */
+#endif
+	pid_t	pr_pid;
+	pid_t	pr_ppid;
+	pid_t	pr_pgrp;
+	pid_t	pr_sid;
+	struct timeval pr_utime;	/* User time */
+	struct timeval pr_stime;	/* System time */
+	struct timeval pr_cutime;	/* Cumulative user time */
+	struct timeval pr_cstime;	/* Cumulative system time */
+#if 0
+	long	pr_instr;		/* Current instruction */
+#endif
+	elf_gregset_t pr_reg;	/* GP registers */
+
 	/* When using FDPIC, the loadmap addresses need to be communicated
 	 * to GDB in order for GDB to do the necessary relocations.  The
 	 * fields (below) used to communicate this information are placed
@@ -69,7 +102,7 @@ struct elf_prstatus
 	 */
 	unsigned long pr_exec_fdpic_loadmap;
 	unsigned long pr_interp_fdpic_loadmap;
-#endif
+
 	int pr_fpvalid;		/* True if math co-processor being used.  */
 };
 
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 201b45327804..8d2fc707fecf 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -977,7 +977,11 @@ static void final_note(u32 *buf)
 
 void crash_save_cpu(struct pt_regs *regs, int cpu)
 {
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	struct elf_fdpic_prstatus prstatus;
+#else
 	struct elf_prstatus prstatus;
+#endif
 	u32 *buf;
 
 	if ((cpu < 0) || (cpu >= nr_cpu_ids))
-- 
2.4.6
