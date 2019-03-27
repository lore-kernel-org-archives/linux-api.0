From: Andrei Vagin <avagin@gmail.com>
Subject: [PATCH RFC] x86/asm: Introduce static_retcall(s)
Date: Wed, 27 Mar 2019 11:06:30 -0700
Message-ID: <20190327180630.14366-1-avagin@gmail.com>
References: <20190327175957.GA9309@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327175957.GA9309@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Safonov <dima@arista.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, LKML <linux-kernel@vger.kernel.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

Provide framework to overwrite tail call in a function with return.

XXX: split vdso/generic part

Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
---
 arch/x86/entry/vdso/vclock_gettime.c  | 19 ++++++----
 arch/x86/entry/vdso/vdso-layout.lds.S |  1 +
 arch/x86/entry/vdso/vdso2c.h          | 11 +++++-
 arch/x86/entry/vdso/vma.c             | 22 +++++++++++
 arch/x86/include/asm/static_retcall.h | 54 +++++++++++++++++++++++++++
 arch/x86/include/asm/vdso.h           |  1 +
 6 files changed, 99 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/include/asm/static_retcall.h

diff --git a/arch/x86/entry/vdso/vclock_gettime.c b/arch/x86/entry/vdso/vclock_gettime.c
index cb55bd994497..9416f1ee6b73 100644
--- a/arch/x86/entry/vdso/vclock_gettime.c
+++ b/arch/x86/entry/vdso/vclock_gettime.c
@@ -18,6 +18,7 @@
 #include <asm/msr.h>
 #include <asm/pvclock.h>
 #include <asm/mshyperv.h>
+#include <asm/static_retcall.h>
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
 
@@ -173,9 +174,13 @@ notrace static __always_inline void clk_to_ns(clockid_t clk, struct timespec *ts
 		ts->tv_nsec += NSEC_PER_SEC;
 		ts->tv_sec--;
 	}
-
-#endif
 }
+#define _static_retcall static_retcall
+#define _static_retcall_int static_retcall_int
+#else
+#define _static_retcall(...)
+#define _static_retcall_int(...)
+#endif
 
 notrace static int do_hres(clockid_t clk, struct timespec *ts)
 {
@@ -203,9 +208,7 @@ notrace static int do_hres(clockid_t clk, struct timespec *ts)
 	ts->tv_sec = sec + __iter_div_u64_rem(ns, NSEC_PER_SEC, &ns);
 	ts->tv_nsec = ns;
 
-	clk_to_ns(clk, ts);
-
-	return 0;
+	_static_retcall_int(0, clk_to_ns, clk, ts);
 }
 
 notrace static void do_coarse(clockid_t clk, struct timespec *ts)
@@ -219,7 +222,7 @@ notrace static void do_coarse(clockid_t clk, struct timespec *ts)
 		ts->tv_nsec = base->nsec;
 	} while (unlikely(gtod_read_retry(gtod, seq)));
 
-	clk_to_ns(clk, ts);
+	_static_retcall(clk_to_ns, clk, ts);
 }
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
diff --git a/arch/x86/entry/vdso/vdso-layout.lds.S b/arch/x86/entry/vdso/vdso-layout.lds.S
index ba216527e59f..075cae6f33bf 100644
--- a/arch/x86/entry/vdso/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/vdso-layout.lds.S
@@ -45,6 +45,7 @@ SECTIONS
 	.gnu.version	: { *(.gnu.version) }
 	.gnu.version_d	: { *(.gnu.version_d) }
 	.gnu.version_r	: { *(.gnu.version_r) }
+	__retcall_table	: { *(__retcall_table) }	:text
 
 	.dynamic	: { *(.dynamic) }		:text	:dynamic
 
diff --git a/arch/x86/entry/vdso/vdso2c.h b/arch/x86/entry/vdso/vdso2c.h
index 660f725a02c1..ae91567fd567 100644
--- a/arch/x86/entry/vdso/vdso2c.h
+++ b/arch/x86/entry/vdso/vdso2c.h
@@ -16,7 +16,7 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 	unsigned int i, syms_nr;
 	unsigned long j;
 	ELF(Shdr) *symtab_hdr = NULL, *strtab_hdr, *secstrings_hdr,
-		*alt_sec = NULL;
+		*alt_sec = NULL, *retcall_sec = NULL;
 	ELF(Dyn) *dyn = 0, *dyn_end = 0;
 	const char *secstrings;
 	INT_BITS syms[NSYMS] = {};
@@ -78,6 +78,9 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 		if (!strcmp(secstrings + GET_LE(&sh->sh_name),
 			    ".altinstructions"))
 			alt_sec = sh;
+		if (!strcmp(secstrings + GET_LE(&sh->sh_name),
+			    "__retcall_table"))
+			retcall_sec  = sh;
 	}
 
 	if (!symtab_hdr)
@@ -165,6 +168,12 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 		fprintf(outfile, "\t.alt_len = %lu,\n",
 			(unsigned long)GET_LE(&alt_sec->sh_size));
 	}
+	if (retcall_sec) {
+		fprintf(outfile, "\t.retcall = %lu,\n",
+			(unsigned long)GET_LE(&retcall_sec->sh_offset));
+		fprintf(outfile, "\t.retcall_len = %lu,\n",
+			(unsigned long)GET_LE(&retcall_sec->sh_size));
+	}
 	for (i = 0; i < NSYMS; i++) {
 		if (required_syms[i].export && syms[i])
 			fprintf(outfile, "\t.sym_%s = %" PRIi64 ",\n",
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 0b8d9f6f0ce3..b4ea7a2ebfed 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -25,6 +25,7 @@
 #include <asm/cpufeature.h>
 #include <asm/mshyperv.h>
 #include <asm/page.h>
+#include <asm/static_retcall.h>
 #include <asm/tlb.h>
 
 #if defined(CONFIG_X86_64)
@@ -38,6 +39,25 @@ static __init int vdso_setup(char *s)
 __setup("vdso=", vdso_setup);
 #endif
 
+static __init int apply_retcalls(struct retcall_entry *ent, unsigned long nr)
+{
+	while (nr--) {
+		void *call_addr	= (void *)ent + ent->call;
+		void *ret_addr	= (void *)ent + ent->ret;
+		size_t ret_sz	= ent->out - ent->ret;
+
+		if (WARN_ON(ret_sz > PAGE_SIZE))
+			goto next;
+
+		memcpy(call_addr, ret_addr, ret_sz);
+
+next:
+		ent++;
+	}
+
+	return 0;
+}
+
 void __init init_vdso_image(struct vdso_image *image)
 {
 	BUG_ON(image->size % PAGE_SIZE != 0);
@@ -51,6 +71,8 @@ void __init init_vdso_image(struct vdso_image *image)
 		return;
 
 	memcpy(image->text_timens, image->text, image->size);
+	apply_retcalls((struct retcall_entry *)(image->text + image->retcall),
+			image->retcall_len / sizeof(struct retcall_entry));
 #endif
 }
 
diff --git a/arch/x86/include/asm/static_retcall.h b/arch/x86/include/asm/static_retcall.h
new file mode 100644
index 000000000000..fdb13795b74d
--- /dev/null
+++ b/arch/x86/include/asm/static_retcall.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Copyright (C) 2019  Dmitry Safonov, Andrey Vagin
+ */
+
+#ifndef _ASM_X86_STATIC_RETCALL_H
+#define _ASM_X86_STATIC_RETCALL_H
+
+struct retcall_entry {
+	u16 call;
+	u16 ret;
+	u16 out;
+};
+
+#define static_retcall(func, ...)					\
+	do {								\
+		asm_volatile_goto(					\
+			".pushsection __retcall_table, \"aw\" \n\t"	\
+			"2: .word %l[l_call] - 2b\n\t"			\
+			".word %l[l_return] - 2b\n\t"			\
+			".word %l[l_out] - 2b\n\t"			\
+			".popsection"					\
+			: : : : l_call, l_return, l_out);		\
+l_call:									\
+		func(__VA_ARGS__);					\
+l_return:								\
+		return;							\
+		annotate_reachable();					\
+l_out:									\
+		nop();							\
+		return;							\
+	} while(0)
+
+#define static_retcall_int(ret, func, ...)				\
+	do {								\
+		asm_volatile_goto(					\
+			".pushsection __retcall_table, \"aw\" \n\t"	\
+			_ASM_ALIGN "\n\t"				\
+			"2: .word %l[l_call] - 2b\n\t"			\
+			".word %l[l_return] - 2b\n\t"			\
+			".word %l[l_out] - 2b\n\t"			\
+			".popsection"					\
+			: : : : l_call, l_return, l_out);		\
+l_call:									\
+		func(__VA_ARGS__);					\
+l_return:								\
+		return ret;						\
+		annotate_reachable();					\
+l_out:									\
+		nop();							\
+		return ret;						\
+	} while(0)
+
+#endif
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 583133446874..acdf70bf814b 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -16,6 +16,7 @@ struct vdso_image {
 	unsigned long size;   /* Always a multiple of PAGE_SIZE */
 
 	unsigned long alt, alt_len;
+	unsigned long retcall, retcall_len;
 
 	long sym_vvar_start;  /* Negative offset to the vvar area */
 
-- 
2.20.1
