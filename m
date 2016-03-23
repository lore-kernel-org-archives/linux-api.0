From: Jessica Yu <jeyu@redhat.com>
Subject: [PATCH v6 4/5] livepatch: reuse module loader code to write relocations
Date: Tue, 22 Mar 2016 20:03:18 -0400
Message-ID: <1458691399-20078-5-git-send-email-jeyu@redhat.com>
References: <1458691399-20078-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458691399-20078-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org, Jessica Yu <jeyu@redhat.com>
List-Id: linux-api@vger.kernel.org

Reuse module loader code to write relocations, thereby eliminating the need
for architecture specific relocation code in livepatch. Specifically, reuse
the apply_relocate_add() function in the module loader to write relocations
instead of duplicating functionality in livepatch's arch-dependent
klp_write_module_reloc() function.

In order to accomplish this, livepatch modules manage their own relocation
sections (marked with the SHF_RELA_LIVEPATCH section flag) and
livepatch-specific symbols (marked with SHN_LIVEPATCH symbol section
index). To apply livepatch relocation sections, livepatch symbols
referenced by relocs are resolved and then apply_relocate_add() is called
to apply those relocations.

In addition, remove x86 livepatch relocation code and the s390
klp_write_module_reloc() function stub. They are no longer needed since
relocation work has been offloaded to module loader.

Lastly, mark the module as a livepatch module so that the module loader
canappropriately identify and initialize it.

Signed-off-by: Jessica Yu <jeyu@redhat.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/s390/include/asm/livepatch.h    |   7 --
 arch/x86/include/asm/livepatch.h     |   2 -
 arch/x86/kernel/Makefile             |   1 -
 arch/x86/kernel/livepatch.c          |  70 -----------------
 include/linux/livepatch.h            |  20 -----
 kernel/livepatch/core.c              | 148 ++++++++++++++++++++++-------------
 samples/livepatch/livepatch-sample.c |   1 +
 7 files changed, 95 insertions(+), 154 deletions(-)
 delete mode 100644 arch/x86/kernel/livepatch.c

diff --git a/arch/s390/include/asm/livepatch.h b/arch/s390/include/asm/livepatch.h
index d5427c7..2c12137 100644
--- a/arch/s390/include/asm/livepatch.h
+++ b/arch/s390/include/asm/livepatch.h
@@ -24,13 +24,6 @@ static inline int klp_check_compiler_support(void)
 	return 0;
 }
 
-static inline int klp_write_module_reloc(struct module *mod, unsigned long
-		type, unsigned long loc, unsigned long value)
-{
-	/* not supported yet */
-	return -ENOSYS;
-}
-
 static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 {
 	regs->psw.addr = ip;
diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
index 7e68f95..a7f9181 100644
--- a/arch/x86/include/asm/livepatch.h
+++ b/arch/x86/include/asm/livepatch.h
@@ -32,8 +32,6 @@ static inline int klp_check_compiler_support(void)
 #endif
 	return 0;
 }
-int klp_write_module_reloc(struct module *mod, unsigned long type,
-			   unsigned long loc, unsigned long value);
 
 static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 {
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 616ebd2..89f8ade 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -79,7 +79,6 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-y				+= apic/
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
-obj-$(CONFIG_LIVEPATCH)		+= livepatch.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_X86_TSC)		+= trace_clock.o
diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
deleted file mode 100644
index 92fc1a5..0000000
--- a/arch/x86/kernel/livepatch.c
+++ /dev/null
@@ -1,70 +0,0 @@
-/*
- * livepatch.c - x86-specific Kernel Live Patching Core
- *
- * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
- * Copyright (C) 2014 SUSE
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/module.h>
-#include <linux/uaccess.h>
-#include <asm/elf.h>
-#include <asm/livepatch.h>
-
-/**
- * klp_write_module_reloc() - write a relocation in a module
- * @mod:	module in which the section to be modified is found
- * @type:	ELF relocation type (see asm/elf.h)
- * @loc:	address that the relocation should be written to
- * @value:	relocation value (sym address + addend)
- *
- * This function writes a relocation to the specified location for
- * a particular module.
- */
-int klp_write_module_reloc(struct module *mod, unsigned long type,
-			   unsigned long loc, unsigned long value)
-{
-	size_t size = 4;
-	unsigned long val;
-	unsigned long core = (unsigned long)mod->core_layout.base;
-	unsigned long core_size = mod->core_layout.size;
-
-	switch (type) {
-	case R_X86_64_NONE:
-		return 0;
-	case R_X86_64_64:
-		val = value;
-		size = 8;
-		break;
-	case R_X86_64_32:
-		val = (u32)value;
-		break;
-	case R_X86_64_32S:
-		val = (s32)value;
-		break;
-	case R_X86_64_PC32:
-		val = (u32)(value - loc);
-		break;
-	default:
-		/* unsupported relocation type */
-		return -EINVAL;
-	}
-
-	if (loc < core || loc >= core + core_size)
-		/* loc does not point to any symbol inside the module */
-		return -EINVAL;
-
-	return probe_kernel_write((void *)loc, &val, size);
-}
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index bd830d5..0933ca4 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -65,27 +65,8 @@ struct klp_func {
 };
 
 /**
- * struct klp_reloc - relocation structure for live patching
- * @loc:	address where the relocation will be written
- * @sympos:	position in kallsyms to disambiguate symbols (optional)
- * @type:	ELF relocation type
- * @name:	name of the referenced symbol (for lookup/verification)
- * @addend:	offset from the referenced symbol
- * @external:	symbol is either exported or within the live patch module itself
- */
-struct klp_reloc {
-	unsigned long loc;
-	unsigned long sympos;
-	unsigned long type;
-	const char *name;
-	int addend;
-	int external;
-};
-
-/**
  * struct klp_object - kernel object structure for live patching
  * @name:	module name (or NULL for vmlinux)
- * @relocs:	relocation entries to be applied at load time
  * @funcs:	function entries for functions to be patched in the object
  * @kobj:	kobject for sysfs resources
  * @mod:	kernel module associated with the patched object
@@ -95,7 +76,6 @@ struct klp_reloc {
 struct klp_object {
 	/* external */
 	const char *name;
-	struct klp_reloc *relocs;
 	struct klp_func *funcs;
 
 	/* internal */
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index d68fbf6..eb5db6e 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -28,6 +28,8 @@
 #include <linux/list.h>
 #include <linux/kallsyms.h>
 #include <linux/livepatch.h>
+#include <linux/elf.h>
+#include <linux/moduleloader.h>
 #include <asm/cacheflush.h>
 
 /**
@@ -204,75 +206,109 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 	return -EINVAL;
 }
 
-/*
- * external symbols are located outside the parent object (where the parent
- * object is either vmlinux or the kmod being patched).
- */
-static int klp_find_external_symbol(struct module *pmod, const char *name,
-				    unsigned long *addr)
+static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
 {
-	const struct kernel_symbol *sym;
-
-	/* first, check if it's an exported symbol */
-	preempt_disable();
-	sym = find_symbol(name, NULL, NULL, true, true);
-	if (sym) {
-		*addr = sym->value;
-		preempt_enable();
-		return 0;
-	}
-	preempt_enable();
+	int i, cnt, vmlinux, ret;
+	char objname[MODULE_NAME_LEN];
+	char symname[KSYM_NAME_LEN];
+	char *strtab = pmod->core_kallsyms.strtab;
+	Elf_Rela *relas;
+	Elf_Sym *sym;
+	unsigned long sympos, addr;
 
 	/*
-	 * Check if it's in another .o within the patch module. This also
-	 * checks that the external symbol is unique.
+	 * Since the field widths for objname and symname in the sscanf()
+	 * call are hard-coded and correspond to MODULE_NAME_LEN and
+	 * KSYM_NAME_LEN respectively, we must make sure that MODULE_NAME_LEN
+	 * and KSYM_NAME_LEN have the values we expect them to have.
+	 *
+	 * Because the value of MODULE_NAME_LEN can differ among architectures,
+	 * we use the smallest/strictest upper bound possible (56, based on
+	 * the current definition of MODULE_NAME_LEN) to prevent overflows.
 	 */
-	return klp_find_object_symbol(pmod->name, name, 0, addr);
+	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 128);
+
+	relas = (Elf_Rela *) relasec->sh_addr;
+	/* For each rela in this klp relocation section */
+	for (i = 0; i < relasec->sh_size / sizeof(Elf_Rela); i++) {
+		sym = pmod->core_kallsyms.symtab + ELF_R_SYM(relas[i].r_info);
+		if (sym->st_shndx != SHN_LIVEPATCH) {
+			pr_err("symbol %s is not marked as a livepatch symbol",
+			       strtab + sym->st_name);
+			return -EINVAL;
+		}
+
+		/* Format: .klp.sym.objname.symname,sympos */
+		cnt = sscanf(strtab + sym->st_name,
+			     ".klp.sym.%55[^.].%127[^,],%lu",
+			     objname, symname, &sympos);
+		if (cnt != 3) {
+			pr_err("symbol %s has an incorrectly formatted name",
+			       strtab + sym->st_name);
+			return -EINVAL;
+		}
+
+		/* klp_find_object_symbol() treats a NULL objname as vmlinux */
+		vmlinux = !strcmp(objname, "vmlinux");
+		ret = klp_find_object_symbol(vmlinux ? NULL : objname,
+					     symname, sympos, &addr);
+		if (ret)
+			return ret;
+
+		sym->st_value = addr;
+	}
+
+	return 0;
 }
 
 static int klp_write_object_relocations(struct module *pmod,
 					struct klp_object *obj)
 {
-	int ret = 0;
-	unsigned long val;
-	struct klp_reloc *reloc;
+	int i, cnt, ret = 0;
+	const char *objname, *secname;
+	char sec_objname[MODULE_NAME_LEN];
+	Elf_Shdr *sec;
 
 	if (WARN_ON(!klp_is_object_loaded(obj)))
 		return -EINVAL;
 
-	if (WARN_ON(!obj->relocs))
-		return -EINVAL;
+	objname = klp_is_module(obj) ? obj->name : "vmlinux";
 
 	module_disable_ro(pmod);
+	/* For each klp relocation section */
+	for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
+		sec = pmod->klp_info->sechdrs + i;
+		secname = pmod->klp_info->secstrings + sec->sh_name;
+		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
+			continue;
 
-	for (reloc = obj->relocs; reloc->name; reloc++) {
-		/* discover the address of the referenced symbol */
-		if (reloc->external) {
-			if (reloc->sympos > 0) {
-				pr_err("non-zero sympos for external reloc symbol '%s' is not supported\n",
-				       reloc->name);
-				ret = -EINVAL;
-				goto out;
-			}
-			ret = klp_find_external_symbol(pmod, reloc->name, &val);
-		} else
-			ret = klp_find_object_symbol(obj->name,
-						     reloc->name,
-						     reloc->sympos,
-						     &val);
+		/*
+		 * Format: .klp.rela.sec_objname.section_name
+		 * See comment in klp_resolve_symbols() for an explanation
+		 * of the selected field width value.
+		 */
+		cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
+		if (cnt != 1) {
+			pr_err("section %s has an incorrectly formatted name",
+			       secname);
+			ret = -EINVAL;
+			break;
+		}
+
+		if (strcmp(objname, sec_objname))
+			continue;
+
+		ret = klp_resolve_symbols(sec, pmod);
 		if (ret)
-			goto out;
+			break;
 
-		ret = klp_write_module_reloc(pmod, reloc->type, reloc->loc,
-					     val + reloc->addend);
-		if (ret) {
-			pr_err("relocation failed for symbol '%s' at 0x%016lx (%d)\n",
-			       reloc->name, val, ret);
-			goto out;
-		}
+		ret = apply_relocate_add(pmod->klp_info->sechdrs,
+					 pmod->core_kallsyms.strtab,
+					 pmod->klp_info->symndx, i, pmod);
+		if (ret)
+			break;
 	}
 
-out:
 	module_enable_ro(pmod);
 	return ret;
 }
@@ -703,11 +739,9 @@ static int klp_init_object_loaded(struct klp_patch *patch,
 	struct klp_func *func;
 	int ret;
 
-	if (obj->relocs) {
-		ret = klp_write_object_relocations(patch->mod, obj);
-		if (ret)
-			return ret;
-	}
+	ret = klp_write_object_relocations(patch->mod, obj);
+	if (ret)
+		return ret;
 
 	klp_for_each_func(obj, func) {
 		ret = klp_find_object_symbol(obj->name, func->old_name,
@@ -842,6 +876,12 @@ int klp_register_patch(struct klp_patch *patch)
 {
 	int ret;
 
+	if (!is_livepatch_module(patch->mod)) {
+		pr_err("module %s is not marked as a livepatch module",
+		       patch->mod->name);
+		return -EINVAL;
+	}
+
 	if (!klp_initialized())
 		return -ENODEV;
 
diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
index fb8c861..e34f871 100644
--- a/samples/livepatch/livepatch-sample.c
+++ b/samples/livepatch/livepatch-sample.c
@@ -89,3 +89,4 @@ static void livepatch_exit(void)
 module_init(livepatch_init);
 module_exit(livepatch_exit);
 MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
-- 
2.4.3
