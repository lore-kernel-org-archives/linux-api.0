From: Andrei Vagin <avagin@gmail.com>
Subject: [PATCH RFC] vdso: introduce timens_static_branch
Date: Wed, 27 Mar 2019 11:06:51 -0700
Message-ID: <20190327180651.14495-1-avagin@gmail.com>
References: <20190327175957.GA9309@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327175957.GA9309@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrei Vagin <avagin@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Dmitry Safonov <dima@arista.com>, LKML <linux-kernel@vger.kernel.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, linux-a
List-Id: linux-api@vger.kernel.org

As it has been discussed on timens RFC, adding a new conditional branch
`if (inside_time_ns)` on VDSO for all processes is undesirable.

Addressing those problems, there are two versions of VDSO's .so:
for host tasks (without any penalty) and for processes inside of time
namespace with clk_to_ns() that subtracts offsets from host's time.

This patch introduces timens_static_branch(), which is similar with
static_branch_unlikely.

The timens code in vdso looks like this:

       if (timens_static_branch()) {
               clk_to_ns(clk, ts);
       }

The version of vdso which is compiled from sources will never execute
clk_to_ns(). And then we can patch the 'no-op' in the straight-line
codepath with a 'jump' instruction to the out-of-line true branch and
get the timens version of the vdso library.

Cc: Dmitry Safonov <dima@arista.com>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
---
 arch/x86/entry/vdso/vclock_gettime.c  | 21 ++++++++++++++-------
 arch/x86/entry/vdso/vdso-layout.lds.S |  1 +
 arch/x86/entry/vdso/vdso2c.h          | 11 ++++++++++-
 arch/x86/entry/vdso/vma.c             | 19 +++++++++++++++++++
 arch/x86/include/asm/jump_label.h     | 14 ++++++++++++++
 arch/x86/include/asm/vdso.h           |  1 +
 include/linux/jump_label.h            |  5 +++++
 7 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/arch/x86/entry/vdso/vclock_gettime.c b/arch/x86/entry/vdso/vclock_gettime.c
index cb55bd994497..74de42f1f7d8 100644
--- a/arch/x86/entry/vdso/vclock_gettime.c
+++ b/arch/x86/entry/vdso/vclock_gettime.c
@@ -18,6 +18,7 @@
 #include <asm/msr.h>
 #include <asm/pvclock.h>
 #include <asm/mshyperv.h>
+#include <asm/jump_label.h>
 #include <linux/math64.h>
 #include <linux/time.h>
 #include <linux/kernel.h>
@@ -39,7 +40,7 @@ extern u8 hvclock_page
 	__attribute__((visibility("hidden")));
 #endif
 
-#ifdef BUILD_VDSO_TIME_NS
+#ifdef CONFIG_TIME_NS
 extern u8 timens_page
 	__attribute__((visibility("hidden")));
 #endif
@@ -145,9 +146,9 @@ notrace static inline u64 vgetcyc(int mode)
 	return U64_MAX;
 }
 
+#ifdef CONFIG_TIME_NS
 notrace static __always_inline void clk_to_ns(clockid_t clk, struct timespec *ts)
 {
-#ifdef BUILD_VDSO_TIME_NS
 	struct timens_offsets *timens = (struct timens_offsets *) &timens_page;
 	struct timespec64 *offset64;
 
@@ -173,9 +174,12 @@ notrace static __always_inline void clk_to_ns(clockid_t clk, struct timespec *ts
 		ts->tv_nsec += NSEC_PER_SEC;
 		ts->tv_sec--;
 	}
-
-#endif
 }
+#define _timens_static_branch_unlikely timens_static_branch_unlikely
+#else
+notrace static __always_inline void clk_to_ns(clockid_t clk, struct timespec *ts) {}
+notrace static __always_inline bool _timens_static_branch_unlikely(void) { return false; }
+#endif
 
 notrace static int do_hres(clockid_t clk, struct timespec *ts)
 {
@@ -203,8 +207,9 @@ notrace static int do_hres(clockid_t clk, struct timespec *ts)
 	ts->tv_sec = sec + __iter_div_u64_rem(ns, NSEC_PER_SEC, &ns);
 	ts->tv_nsec = ns;
 
-	clk_to_ns(clk, ts);
-
+	if (_timens_static_branch_unlikely()) {
+		clk_to_ns(clk, ts);
+	}
 	return 0;
 }
 
@@ -219,7 +224,9 @@ notrace static void do_coarse(clockid_t clk, struct timespec *ts)
 		ts->tv_nsec = base->nsec;
 	} while (unlikely(gtod_read_retry(gtod, seq)));
 
-	clk_to_ns(clk, ts);
+	if (_timens_static_branch_unlikely()) {
+		clk_to_ns(clk, ts);
+	}
 }
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
diff --git a/arch/x86/entry/vdso/vdso-layout.lds.S b/arch/x86/entry/vdso/vdso-layout.lds.S
index ba216527e59f..69dbe4821aa5 100644
--- a/arch/x86/entry/vdso/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/vdso-layout.lds.S
@@ -45,6 +45,7 @@ SECTIONS
 	.gnu.version	: { *(.gnu.version) }
 	.gnu.version_d	: { *(.gnu.version_d) }
 	.gnu.version_r	: { *(.gnu.version_r) }
+	__jump_table	: { *(__jump_table) }	:text
 
 	.dynamic	: { *(.dynamic) }		:text	:dynamic
 
diff --git a/arch/x86/entry/vdso/vdso2c.h b/arch/x86/entry/vdso/vdso2c.h
index 660f725a02c1..e4eef5e1c6ac 100644
--- a/arch/x86/entry/vdso/vdso2c.h
+++ b/arch/x86/entry/vdso/vdso2c.h
@@ -16,7 +16,7 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 	unsigned int i, syms_nr;
 	unsigned long j;
 	ELF(Shdr) *symtab_hdr = NULL, *strtab_hdr, *secstrings_hdr,
-		*alt_sec = NULL;
+		*alt_sec = NULL, *jump_table_sec = NULL;
 	ELF(Dyn) *dyn = 0, *dyn_end = 0;
 	const char *secstrings;
 	INT_BITS syms[NSYMS] = {};
@@ -78,6 +78,9 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 		if (!strcmp(secstrings + GET_LE(&sh->sh_name),
 			    ".altinstructions"))
 			alt_sec = sh;
+		if (!strcmp(secstrings + GET_LE(&sh->sh_name),
+			    "__jump_table"))
+			jump_table_sec  = sh;
 	}
 
 	if (!symtab_hdr)
@@ -165,6 +168,12 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 		fprintf(outfile, "\t.alt_len = %lu,\n",
 			(unsigned long)GET_LE(&alt_sec->sh_size));
 	}
+	if (jump_table_sec) {
+		fprintf(outfile, "\t.jump_table = %lu,\n",
+			(unsigned long)GET_LE(&jump_table_sec->sh_offset));
+		fprintf(outfile, "\t.jump_table_len = %lu,\n",
+			(unsigned long)GET_LE(&jump_table_sec->sh_size));
+	}
 	for (i = 0; i < NSYMS; i++) {
 		if (required_syms[i].export && syms[i])
 			fprintf(outfile, "\t.sym_%s = %" PRIi64 ",\n",
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 0b8d9f6f0ce3..5c0e6491aefb 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/ptrace.h>
 #include <linux/time_namespace.h>
+#include <linux/jump_label.h>
 #include <asm/pvclock.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
@@ -38,6 +39,22 @@ static __init int vdso_setup(char *s)
 __setup("vdso=", vdso_setup);
 #endif
 
+#ifdef CONFIG_TIME_NS
+static __init int apply_jump_tables(struct vdso_jump_entry *ent, unsigned long nr)
+{
+	while (nr--) {
+		void *code_addr	= (void *)ent + ent->code;
+		long target_addr = (long) ent->target - (ent->code + JUMP_LABEL_NOP_SIZE);
+		((char *)code_addr)[0] = 0xe9; /* JMP rel32 */
+		*((long *)(code_addr + 1)) = (long)target_addr;
+
+		ent++;
+	}
+
+	return 0;
+}
+#endif
+
 void __init init_vdso_image(struct vdso_image *image)
 {
 	BUG_ON(image->size % PAGE_SIZE != 0);
@@ -51,6 +68,8 @@ void __init init_vdso_image(struct vdso_image *image)
 		return;
 
 	memcpy(image->text_timens, image->text, image->size);
+	apply_jump_tables((struct vdso_jump_entry *)(image->text_timens + image->jump_table),
+			image->jump_table_len / sizeof(struct vdso_jump_entry));
 #endif
 }
 
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 65191ce8e1cf..1784aa49cc82 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -51,6 +51,20 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key, bool
 	return true;
 }
 
+static __always_inline bool timens_static_branch_unlikely(void)
+{
+	asm_volatile_goto("1:\n\t"
+		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 "2: .word 1b - 2b, %l[l_yes] - 2b\n\t"
+		 ".popsection\n\t"
+		 : :  :  : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
+
 #else	/* __ASSEMBLY__ */
 
 .macro STATIC_JUMP_IF_TRUE target, key, def
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 583133446874..883151c3a032 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -16,6 +16,7 @@ struct vdso_image {
 	unsigned long size;   /* Always a multiple of PAGE_SIZE */
 
 	unsigned long alt, alt_len;
+	unsigned long jump_table, jump_table_len;
 
 	long sym_vvar_start;  /* Negative offset to the vvar area */
 
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 3e113a1fa0f1..69854a05d2f2 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -125,6 +125,11 @@ struct jump_entry {
 	long key;	// key may be far away from the core kernel under KASLR
 };
 
+struct vdso_jump_entry {
+	u16 code;
+	u16 target;
+};
+
 static inline unsigned long jump_entry_code(const struct jump_entry *entry)
 {
 	return (unsigned long)&entry->code + entry->code;
-- 
2.20.1
