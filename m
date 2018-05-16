From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 22/24] arm64:ilp32: add vdso-ilp32 and use for signal return
Date: Wed, 16 May 2018 11:19:07 +0300
Message-ID: <20180516081910.10067-23-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

From: Philipp Tomsich <philipp.tomsich@theobroma-systems.com>

ILP32 VDSO exports following symbols:
 __kernel_rt_sigreturn;
 __kernel_gettimeofday;
 __kernel_clock_gettime;
 __kernel_clock_getres.

What shared object to use, kernel selects depending on result of
is_ilp32_compat_task() in arch/arm64/kernel/vdso.c, so it substitutes
correct pages and spec.

Adjusted to move the data page before code pages in sync with
commit 601255ae3c98 ("arm64: vdso: move data page before code pages")

Signed-off-by: Philipp Tomsich <philipp.tomsich@theobroma-systems.com>
Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Bamvor Jian Zhang <bamv2005@gmail.com>
---
 arch/arm64/Makefile                           |  3 +
 arch/arm64/include/asm/vdso.h                 |  6 ++
 arch/arm64/kernel/Makefile                    |  1 +
 arch/arm64/kernel/asm-offsets.c               |  7 ++
 arch/arm64/kernel/vdso-ilp32/.gitignore       |  2 +
 arch/arm64/kernel/vdso-ilp32/Makefile         | 82 ++++++++++++++++++
 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S     | 22 +++++
 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S | 84 +++++++++++++++++++
 arch/arm64/kernel/vdso.c                      | 61 ++++++++++++--
 arch/arm64/kernel/vdso/gettimeofday.S         | 20 ++++-
 arch/arm64/kernel/vdso/vdso.S                 |  6 +-
 11 files changed, 280 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm64/kernel/vdso-ilp32/.gitignore
 create mode 100644 arch/arm64/kernel/vdso-ilp32/Makefile
 create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S
 create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index b481b4a7c011..55fb91420ebc 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -160,6 +160,9 @@ archclean:
 prepare: vdso_prepare
 vdso_prepare: prepare0
 	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso include/generated/vdso-offsets.h
+ifeq ($(CONFIG_ARM64_ILP32), y)
+	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso-ilp32 include/generated/vdso-ilp32-offsets.h
+endif
 
 define archhelp
   echo  '* Image.gz      - Compressed kernel image (arch/$(ARCH)/boot/Image.gz)'
diff --git a/arch/arm64/include/asm/vdso.h b/arch/arm64/include/asm/vdso.h
index 839ce0031bd5..33a4e10014aa 100644
--- a/arch/arm64/include/asm/vdso.h
+++ b/arch/arm64/include/asm/vdso.h
@@ -29,6 +29,12 @@
 
 #include <generated/vdso-offsets.h>
 
+#ifdef CONFIG_ARM64_ILP32
+#include <generated/vdso-ilp32-offsets.h>
+#else
+#define vdso_offset_sigtramp_ilp32	({ BUILD_BUG(); 0; })
+#endif
+
 #define VDSO_SYMBOL(base, name)						   \
 ({									   \
 	(void *)(vdso_offset_##name - VDSO_LBASE + (unsigned long)(base)); \
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 27ddf5369f89..6510dad702d0 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -62,6 +62,7 @@ arm64-obj-$(CONFIG_HARDEN_BRANCH_PREDICTOR)	+= bpi.o
 endif
 
 obj-y					+= $(arm64-obj-y) vdso/ probes/
+obj-$(CONFIG_ARM64_ILP32)		+= vdso-ilp32/
 obj-m					+= $(arm64-obj-m)
 head-y					:= head.o
 extra-y					+= $(head-y) vmlinux.lds
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index a416c2333e2f..54c9768dd964 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -124,6 +124,13 @@ int main(void)
   DEFINE(TSPEC_TV_SEC,		offsetof(struct timespec, tv_sec));
   DEFINE(TSPEC_TV_NSEC,		offsetof(struct timespec, tv_nsec));
   BLANK();
+#ifdef CONFIG_COMPAT
+  DEFINE(COMPAT_TVAL_TV_SEC,	offsetof(struct compat_timeval, tv_sec));
+  DEFINE(COMPAT_TVAL_TV_USEC,	offsetof(struct compat_timeval, tv_usec));
+  DEFINE(COMPAT_TSPEC_TV_SEC,	offsetof(struct compat_timespec, tv_sec));
+  DEFINE(COMPAT_TSPEC_TV_NSEC,	offsetof(struct compat_timespec, tv_nsec));
+  BLANK();
+#endif
   DEFINE(TZ_MINWEST,		offsetof(struct timezone, tz_minuteswest));
   DEFINE(TZ_DSTTIME,		offsetof(struct timezone, tz_dsttime));
   BLANK();
diff --git a/arch/arm64/kernel/vdso-ilp32/.gitignore b/arch/arm64/kernel/vdso-ilp32/.gitignore
new file mode 100644
index 000000000000..61806c3fd68b
--- /dev/null
+++ b/arch/arm64/kernel/vdso-ilp32/.gitignore
@@ -0,0 +1,2 @@
+vdso-ilp32.lds
+vdso-ilp32-offsets.h
diff --git a/arch/arm64/kernel/vdso-ilp32/Makefile b/arch/arm64/kernel/vdso-ilp32/Makefile
new file mode 100644
index 000000000000..e372740e43b5
--- /dev/null
+++ b/arch/arm64/kernel/vdso-ilp32/Makefile
@@ -0,0 +1,82 @@
+# SPDX-License-Identifier: GPL-2.0+
+
+#
+# Building a vDSO image for AArch64.
+#
+# Author: Will Deacon <will.deacon@arm.com>
+# Heavily based on the vDSO Makefiles for other archs.
+#
+
+obj-ilp32-vdso := gettimeofday-ilp32.o note-ilp32.o sigreturn-ilp32.o
+
+# Build rules
+targets := $(obj-ilp32-vdso) vdso-ilp32.so vdso-ilp32.so.dbg
+obj-ilp32-vdso := $(addprefix $(obj)/, $(obj-ilp32-vdso))
+
+ccflags-y := -shared -fno-common -fno-builtin
+ccflags-y += -nostdlib -Wl,-soname=linux-ilp32-vdso.so.1 \
+		$(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
+
+# Disable gcov profiling for VDSO code
+GCOV_PROFILE := n
+
+# Workaround for bare-metal (ELF) toolchains that neglect to pass -shared
+# down to collect2, resulting in silent corruption of the vDSO image.
+ccflags-y += -Wl,-shared
+
+obj-y += vdso-ilp32.o
+extra-y += vdso-ilp32.lds
+CPPFLAGS_vdso-ilp32.lds += -P -C -U$(ARCH) -mabi=ilp32
+
+# Force dependency (incbin is bad)
+$(obj)/vdso-ilp32.o : $(obj)/vdso-ilp32.so
+
+# Link rule for the .so file, .lds has to be first
+$(obj)/vdso-ilp32.so.dbg: $(src)/vdso-ilp32.lds $(obj-ilp32-vdso)
+	$(call if_changed,vdso-ilp32ld)
+
+# Strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+# Generate VDSO offsets using helper script
+gen-vdsosym := $(srctree)/$(src)/../vdso/gen_vdso_offsets.sh
+quiet_cmd_vdsosym = VDSOSYM $@
+define cmd_vdsosym
+	$(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@
+endef
+
+include/generated/vdso-ilp32-offsets.h: $(obj)/vdso-ilp32.so.dbg FORCE
+	$(call if_changed,vdsosym)
+
+# Assembly rules for the .S files
+#$(obj-ilp32-vdso): %.o: $(src)/../vdso/$(subst -ilp32,,%.S)
+#	$(call if_changed_dep,vdso-ilp32as)
+
+$(obj)/gettimeofday-ilp32.o: $(src)/../vdso/gettimeofday.S
+	$(call if_changed_dep,vdso-ilp32as)
+
+$(obj)/note-ilp32.o: $(src)/../vdso/note.S
+	$(call if_changed_dep,vdso-ilp32as)
+
+# This one should be fine because ILP32 uses the same generic
+# __NR_rt_sigreturn syscall number.
+$(obj)/sigreturn-ilp32.o: $(src)/../vdso/sigreturn.S
+	$(call if_changed_dep,vdso-ilp32as)
+
+# Actual build commands
+quiet_cmd_vdso-ilp32ld = VDSOILP32L $@
+      cmd_vdso-ilp32ld = $(CC) $(c_flags) -mabi=ilp32  -Wl,-n -Wl,-T $^ -o $@
+quiet_cmd_vdso-ilp32as = VDSOILP32A $@
+      cmd_vdso-ilp32as = $(CC) $(a_flags) -mabi=ilp32 -c -o $@ $<
+
+# Install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+
+vdso-ilp32.so: $(obj)/vdso-ilp32.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+vdso_install: vdso-ilp32.so
diff --git a/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S b/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S
new file mode 100644
index 000000000000..dee65ab79662
--- /dev/null
+++ b/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+/*
+ * Copyright (C) 2012 ARM Limited
+ * Author: Will Deacon <will.deacon@arm.com>
+ */
+
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <linux/const.h>
+#include <asm/page.h>
+
+	__PAGE_ALIGNED_DATA
+
+	.globl vdso_ilp32_start, vdso_ilp32_end
+	.balign PAGE_SIZE
+vdso_ilp32_start:
+	.incbin "arch/arm64/kernel/vdso-ilp32/vdso-ilp32.so"
+	.balign PAGE_SIZE
+vdso_ilp32_end:
+
+	.previous
diff --git a/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S b/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S
new file mode 100644
index 000000000000..9f14666feef7
--- /dev/null
+++ b/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+/*
+ * GNU linker script for the VDSO library.
+ *
+ * Copyright (C) 2012 ARM Limited
+ * Author: Will Deacon <will.deacon@arm.com>
+ * Heavily based on the vDSO linker scripts for other archs.
+ */
+
+#include <linux/const.h>
+#include <asm/page.h>
+#include <asm/vdso.h>
+
+SECTIONS
+{
+	PROVIDE(_vdso_data = . - PAGE_SIZE);
+	. = VDSO_LBASE + SIZEOF_HEADERS;
+
+	.hash		: { *(.hash) }			:text
+	.gnu.hash	: { *(.gnu.hash) }
+	.dynsym		: { *(.dynsym) }
+	.dynstr		: { *(.dynstr) }
+	.gnu.version	: { *(.gnu.version) }
+	.gnu.version_d	: { *(.gnu.version_d) }
+	.gnu.version_r	: { *(.gnu.version_r) }
+
+	.note		: { *(.note.*) }		:text	:note
+
+	. = ALIGN(16);
+
+	.text		: { *(.text*) }			:text	=0xd503201f
+	PROVIDE (__etext = .);
+	PROVIDE (_etext = .);
+	PROVIDE (etext = .);
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+
+	.rodata		: { *(.rodata*) }		:text
+
+	_end = .;
+	PROVIDE(end = .);
+
+	/DISCARD/	: {
+		*(.note.GNU-stack)
+		*(.data .data.* .gnu.linkonce.d.* .sdata*)
+		*(.bss .sbss .dynbss .dynsbss)
+	}
+}
+
+/*
+ * We must supply the ELF program headers explicitly to get just one
+ * PT_LOAD segment, and set the flags explicitly to make segments read-only.
+ */
+PHDRS
+{
+	text		PT_LOAD		FLAGS(5) FILEHDR PHDRS; /* PF_R|PF_X */
+	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
+	note		PT_NOTE		FLAGS(4);		/* PF_R */
+	eh_frame_hdr	PT_GNU_EH_FRAME;
+}
+
+/*
+ * This controls what symbols we export from the DSO.
+ */
+VERSION
+{
+	LINUX_4.12 {
+	global:
+		__kernel_rt_sigreturn;
+		__kernel_gettimeofday;
+		__kernel_clock_gettime;
+		__kernel_clock_getres;
+	local: *;
+	};
+}
+
+/*
+ * Make the sigreturn code visible to the kernel.
+ */
+VDSO_sigtramp_ilp32		= __kernel_rt_sigreturn;
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 440fe2652d4a..a37342ed1503 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -37,8 +37,13 @@
 #include <asm/vdso.h>
 #include <asm/vdso_datapage.h>
 
-extern char vdso_start[], vdso_end[];
-static unsigned long vdso_pages __ro_after_init;
+extern char vdso_lp64_start[], vdso_lp64_end[];
+static unsigned long vdso_lp64_pages __ro_after_init;
+
+#ifdef CONFIG_ARM64_ILP32
+extern char vdso_ilp32_start[], vdso_ilp32_end[];
+static unsigned long vdso_ilp32_pages __ro_after_init;
+#endif
 
 /*
  * The vDSO data page.
@@ -114,7 +119,7 @@ static int vdso_mremap(const struct vm_special_mapping *sm,
 		struct vm_area_struct *new_vma)
 {
 	unsigned long new_size = new_vma->vm_end - new_vma->vm_start;
-	unsigned long vdso_size = vdso_end - vdso_start;
+	unsigned long vdso_size = vdso_lp64_end - vdso_lp64_start;
 
 	if (vdso_size != new_size)
 		return -EINVAL;
@@ -124,7 +129,7 @@ static int vdso_mremap(const struct vm_special_mapping *sm,
 	return 0;
 }
 
-static struct vm_special_mapping vdso_spec[2] __ro_after_init = {
+static struct vm_special_mapping vdso_lp64_spec[2] __ro_after_init = {
 	{
 		.name	= "[vvar]",
 	},
@@ -134,9 +139,23 @@ static struct vm_special_mapping vdso_spec[2] __ro_after_init = {
 	},
 };
 
-static int __init vdso_init(void)
+#ifdef CONFIG_ARM64_ILP32
+static struct vm_special_mapping vdso_ilp32_spec[2] __ro_after_init = {
+	{
+		.name	= "[vvar]",
+	},
+	{
+		.name	= "[vdso]",
+	},
+};
+#endif
+
+static int __init vdso_init(char *vdso_start, char *vdso_end,
+					  unsigned long *vdso_pagesp,
+					  struct vm_special_mapping *vdso_spec)
 {
 	int i;
+	unsigned long vdso_pages;
 	struct page **vdso_pagelist;
 	unsigned long pfn;
 
@@ -146,8 +165,10 @@ static int __init vdso_init(void)
 	}
 
 	vdso_pages = (vdso_end - vdso_start) >> PAGE_SHIFT;
+	*vdso_pagesp = vdso_pages;
 	pr_info("vdso: %ld pages (%ld code @ %p, %ld data @ %p)\n",
-		vdso_pages + 1, vdso_pages, vdso_start, 1L, vdso_data);
+					vdso_pages + 1, vdso_pages,
+					vdso_start, 1L, vdso_data);
 
 	/* Allocate the vDSO pagelist, plus a page for the data. */
 	vdso_pagelist = kcalloc(vdso_pages + 1, sizeof(struct page *),
@@ -170,7 +191,22 @@ static int __init vdso_init(void)
 
 	return 0;
 }
-arch_initcall(vdso_init);
+
+static int __init vdso_lp64_init(void)
+{
+	return vdso_init(vdso_lp64_start, vdso_lp64_end,
+				&vdso_lp64_pages, vdso_lp64_spec);
+}
+arch_initcall(vdso_lp64_init);
+
+#ifdef CONFIG_ARM64_ILP32
+static int __init vdso_ilp32_init(void)
+{
+	return vdso_init(vdso_ilp32_start, vdso_ilp32_end,
+				&vdso_ilp32_pages, vdso_ilp32_spec);
+}
+arch_initcall(vdso_ilp32_init);
+#endif
 
 int arch_setup_additional_pages(struct linux_binprm *bprm,
 				int uses_interp)
@@ -178,8 +214,17 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
 	struct mm_struct *mm = current->mm;
 	unsigned long vdso_base, vdso_text_len, vdso_mapping_len;
 	void *ret;
+	unsigned long pages = vdso_lp64_pages;
+	struct vm_special_mapping *vdso_spec = vdso_lp64_spec;
+
+#ifdef CONFIG_ARM64_ILP32
+	if (is_ilp32_compat_task()) {
+		pages = vdso_ilp32_pages;
+		vdso_spec = vdso_ilp32_spec;
+	}
+#endif
 
-	vdso_text_len = vdso_pages << PAGE_SHIFT;
+	vdso_text_len = pages << PAGE_SHIFT;
 	/* Be sure to map the data page */
 	vdso_mapping_len = vdso_text_len + PAGE_SIZE;
 
diff --git a/arch/arm64/kernel/vdso/gettimeofday.S b/arch/arm64/kernel/vdso/gettimeofday.S
index c39872a7b03c..9aa415098e0e 100644
--- a/arch/arm64/kernel/vdso/gettimeofday.S
+++ b/arch/arm64/kernel/vdso/gettimeofday.S
@@ -25,6 +25,16 @@
 #define NSEC_PER_SEC_LO16	0xca00
 #define NSEC_PER_SEC_HI16	0x3b9a
 
+#ifdef __LP64__
+#define PTR_REG(n)	x##n
+#define OFFSET(n)	n
+#define DELOUSE(n)
+#else
+#define PTR_REG(n)	w##n
+#define OFFSET(n)	COMPAT_##n
+#define DELOUSE(n)	mov     w##n, w##n
+#endif
+
 vdso_data	.req	x6
 seqcnt		.req	w7
 w_tmp		.req	w8
@@ -119,7 +129,7 @@ x_tmp		.req	x8
 	.if \shift == 1
 	lsr	x11, x11, x12
 	.endif
-	stp	x10, x11, [x1, #TSPEC_TV_SEC]
+	stp     PTR_REG(10), PTR_REG(11), [x1, #OFFSET(TSPEC_TV_SEC)]
 	mov	x0, xzr
 	ret
 	.endm
@@ -136,6 +146,8 @@ x_tmp		.req	x8
 /* int __kernel_gettimeofday(struct timeval *tv, struct timezone *tz); */
 ENTRY(__kernel_gettimeofday)
 	.cfi_startproc
+	DELOUSE(0)
+	DELOUSE(1)
 	adr	vdso_data, _vdso_data
 	/* If tv is NULL, skip to the timezone code. */
 	cbz	x0, 2f
@@ -160,7 +172,7 @@ ENTRY(__kernel_gettimeofday)
 	mov	x13, #1000
 	lsl	x13, x13, x12
 	udiv	x11, x11, x13
-	stp	x10, x11, [x0, #TVAL_TV_SEC]
+	stp	PTR_REG(10), PTR_REG(11), [x0, #OFFSET(TVAL_TV_SEC)]
 2:
 	/* If tz is NULL, return 0. */
 	cbz	x1, 3f
@@ -182,6 +194,7 @@ ENDPROC(__kernel_gettimeofday)
 /* int __kernel_clock_gettime(clockid_t clock_id, struct timespec *tp); */
 ENTRY(__kernel_clock_gettime)
 	.cfi_startproc
+	DELOUSE(1)
 	cmp	w0, #JUMPSLOT_MAX
 	b.hi	syscall
 	adr	vdso_data, _vdso_data
@@ -296,6 +309,7 @@ ENDPROC(__kernel_clock_gettime)
 /* int __kernel_clock_getres(clockid_t clock_id, struct timespec *res); */
 ENTRY(__kernel_clock_getres)
 	.cfi_startproc
+	DELOUSE(1)
 	cmp	w0, #CLOCK_REALTIME
 	ccmp	w0, #CLOCK_MONOTONIC, #0x4, ne
 	ccmp	w0, #CLOCK_MONOTONIC_RAW, #0x4, ne
@@ -310,7 +324,7 @@ ENTRY(__kernel_clock_getres)
 	ldr	x2, 6f
 2:
 	cbz	x1, 3f
-	stp	xzr, x2, [x1]
+	stp	PTR_REG(zr), PTR_REG(2), [x1]
 
 3:	/* res == NULL. */
 	mov	w0, wzr
diff --git a/arch/arm64/kernel/vdso/vdso.S b/arch/arm64/kernel/vdso/vdso.S
index 82379a70ef03..a40ae2485430 100644
--- a/arch/arm64/kernel/vdso/vdso.S
+++ b/arch/arm64/kernel/vdso/vdso.S
@@ -21,12 +21,12 @@
 #include <linux/const.h>
 #include <asm/page.h>
 
-	.globl vdso_start, vdso_end
+	.globl vdso_lp64_start, vdso_lp64_end
 	.section .rodata
 	.balign PAGE_SIZE
-vdso_start:
+vdso_lp64_start:
 	.incbin "arch/arm64/kernel/vdso/vdso.so"
 	.balign PAGE_SIZE
-vdso_end:
+vdso_lp64_end:
 
 	.previous
-- 
2.17.0
