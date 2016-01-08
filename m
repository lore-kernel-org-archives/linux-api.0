From: Jessica Yu <jeyu@redhat.com>
Subject: [RFC PATCH v3 4/6] livepatch: reuse module loader code to write relocations
Date: Fri,  8 Jan 2016 14:28:22 -0500
Message-ID: <1452281304-28618-5-git-send-email-jeyu@redhat.com>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Reuse module loader code to write relocations, thereby eliminating the need
for architecture specific relocation code in livepatch. Namely, we reuse
apply_relocate_add() in the module loader to write relocations instead of
duplicating functionality in livepatch's klp_write_module_reloc(). To apply
relocation sections, remaining SHN_LIVEPATCH symbols referenced by relocs
are resolved and then apply_relocate_add() is called to apply those
relocations.

In addition, remove x86 livepatch relocation code. It is no longer needed
since symbol resolution and relocation work have been offloaded to module
loader.

Signed-off-by: Jessica Yu <jeyu@redhat.com>
---
 arch/x86/include/asm/livepatch.h |   2 -
 arch/x86/kernel/Makefile         |   1 -
 arch/x86/kernel/livepatch.c      |  70 ---------------------------
 include/linux/livepatch.h        |  33 +++++--------
 kernel/livepatch/core.c          | 101 +++++++++++++++++++--------------------
 5 files changed, 62 insertions(+), 145 deletions(-)
 delete mode 100644 arch/x86/kernel/livepatch.c

diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
index 19c099a..7312e25 100644
--- a/arch/x86/include/asm/livepatch.h
+++ b/arch/x86/include/asm/livepatch.h
@@ -33,8 +33,6 @@ static inline int klp_check_compiler_support(void)
 #endif
 	return 0;
 }
-int klp_write_module_reloc(struct module *mod, unsigned long type,
-			   unsigned long loc, unsigned long value);
 
 static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 {
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index b1b78ff..c5e9a5c 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -67,7 +67,6 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
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
index a882865..2f12ce7 100644
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
@@ -123,6 +103,19 @@ struct klp_patch {
 	enum klp_state state;
 };
 
+/*
+ * Livepatch-specific symbols and relocation
+ * sections are prefixed with a tag:
+ * .klp.rel. for relocation sections
+ * .klp.sym. for livepatch symbols
+ */
+#define KLP_TAG_LEN 9
+/*
+ * Livepatch-specific bits for specifying symbol
+ * positions in the Elf_Sym st_other field
+ */
+#define KLP_SYMPOS(o) (o >> 2) & 0xff
+
 #define klp_for_each_object(patch, obj) \
 	for (obj = patch->objs; obj->funcs; obj++)
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index bc2c85c..64536a4 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -28,6 +28,9 @@
 #include <linux/list.h>
 #include <linux/kallsyms.h>
 #include <linux/livepatch.h>
+#include <linux/elf.h>
+#include <linux/string.h>
+#include <linux/moduleloader.h>
 #include <asm/cacheflush.h>
 
 /**
@@ -204,74 +207,70 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 	return -EINVAL;
 }
 
-/*
- * external symbols are located outside the parent object (where the parent
- * object is either vmlinux or the kmod being patched).
- */
-static int klp_find_external_symbol(struct module *pmod, const char *name,
-				    unsigned long *addr)
+static int klp_resolve_symbols(Elf_Shdr *relsec, struct module *pmod)
 {
-	const struct kernel_symbol *sym;
+	int i, len, ret = 0;
+	Elf_Rela *relas;
+	Elf_Sym *sym;
+	char *symname, *sym_objname;
 
-	/* first, check if it's an exported symbol */
-	preempt_disable();
-	sym = find_symbol(name, NULL, NULL, true, true);
-	if (sym) {
-		*addr = sym->value;
-		preempt_enable();
-		return 0;
+	relas = (Elf_Rela *) relsec->sh_addr;
+	/* For each rela in this .klp.rel. section */
+	for (i = 0; i < relsec->sh_size / sizeof(Elf_Rela); i++) {
+		sym = pmod->core_symtab + ELF_R_SYM(relas[i].r_info);
+		symname = pmod->core_strtab + sym->st_name;
+
+		len = strcspn(symname + KLP_TAG_LEN, ".");
+		sym_objname = strncmp(symname + KLP_TAG_LEN, "vmlinux", len) ?
+			kstrndup(symname + KLP_TAG_LEN, len, GFP_KERNEL) : NULL;
+		/* .klp.sym.objname.[symbol_name] */
+		symname += KLP_TAG_LEN + len + 1;
+
+		ret = klp_find_object_symbol(sym_objname, symname,
+					     KLP_SYMPOS(sym->st_other),
+					     (unsigned long *) &sym->st_value);
+		kfree(sym_objname);
+		if (ret)
+			return ret;
 	}
-	preempt_enable();
 
-	/*
-	 * Check if it's in another .o within the patch module. This also
-	 * checks that the external symbol is unique.
-	 */
-	return klp_find_object_symbol(pmod->name, name, 0, addr);
+	return ret;
 }
 
 static int klp_write_object_relocations(struct module *pmod,
 					struct klp_object *obj)
 {
-	int ret = 0;
-	unsigned long val;
-	struct klp_reloc *reloc;
+	int i, len, ret = 0;
+	char *secname;
+	const char *objname;
 
 	if (WARN_ON(!klp_is_object_loaded(obj)))
 		return -EINVAL;
 
-	if (WARN_ON(!obj->relocs))
-		return -EINVAL;
+	objname = klp_is_module(obj) ? obj->name : "vmlinux";
 
 	module_disable_ro(pmod);
+	/* For each klp rela section for this object */
+	for (i = 1; i < pmod->info->hdr->e_shnum; i++) {
+		if (!(pmod->info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH))
+			continue;
+
+		secname = pmod->info->secstrings + pmod->info->sechdrs[i].sh_name;
+		/* .klp.rel.[objname].section_name */
+		len = strcspn(secname + KLP_TAG_LEN, ".");
+
+		if (strncmp(objname, secname + KLP_TAG_LEN, len))
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
+		ret = klp_resolve_symbols(pmod->info->sechdrs + i, pmod);
 		if (ret)
 			goto out;
 
-		ret = klp_write_module_reloc(pmod, reloc->type, reloc->loc,
-					     val + reloc->addend);
-		if (ret) {
-			pr_err("relocation failed for symbol '%s' at 0x%016lx (%d)\n",
-			       reloc->name, val, ret);
+		ret = apply_relocate_add(pmod->info->sechdrs, pmod->core_strtab,
+					 pmod->info->index.sym, i, pmod);
+		if (ret)
 			goto out;
-		}
 	}
-
 out:
 	module_enable_ro(pmod);
 	return ret;
@@ -703,11 +702,9 @@ static int klp_init_object_loaded(struct klp_patch *patch,
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
-- 
2.4.3
