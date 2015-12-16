From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Wed, 16 Dec 2015 00:40:48 -0500
Message-ID: <20151216054048.GA28258@packer-debian-8-amd64.digitalocean.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-5-git-send-email-jeyu@redhat.com>
 <20151208183844.GC14846@treble.redhat.com>
 <20151209191013.GA25387@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151209191013.GA25387-N0bYjD2NfQ6k4hzjq3hgyGTy53QMssKEsp+A89P3RPuQWHG76I6BsA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Jessica Yu [09/12/15 14:10 -0500]:
>+++ Josh Poimboeuf [08/12/15 12:38 -0600]:
>>On Mon, Nov 30, 2015 at 11:21:17PM -0500, Jessica Yu wrote:
>>>Reuse module loader code to write relocations, thereby eliminating the need
>>>for architecture specific relocation code in livepatch. Namely, we reuse
>>>apply_relocate_add() in the module loader to write relocations instead of
>>>duplicating functionality in livepatch's klp_write_module_reloc(). To apply
>>>relocation sections, remaining SHN_LIVEPATCH symbols referenced by relocs
>>>are resolved and then apply_relocate_add() is called to apply those
>>>relocations.
>>>
>>>In addition, remove x86 livepatch relocation code. It is no longer needed
>>>since symbol resolution and relocation work have been offloaded to module
>>>loader.
>>>
>>>Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>---
>>> arch/x86/include/asm/livepatch.h |  2 -
>>> arch/x86/kernel/Makefile         |  1 -
>>> arch/x86/kernel/livepatch.c      | 91 --------------------------------------
>>> include/linux/livepatch.h        | 30 ++++++-------
>>> include/linux/module.h           |  6 +++
>>> kernel/livepatch/core.c          | 94 ++++++++++++++++++++++------------------
>>> 6 files changed, 70 insertions(+), 154 deletions(-)
>>> delete mode 100644 arch/x86/kernel/livepatch.c
>>>
>>>diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
>>>index 19c099a..7312e25 100644
>>>--- a/arch/x86/include/asm/livepatch.h
>>>+++ b/arch/x86/include/asm/livepatch.h
>>>@@ -33,8 +33,6 @@ static inline int klp_check_compiler_support(void)
>>> #endif
>>> 	return 0;
>>> }
>>>-int klp_write_module_reloc(struct module *mod, unsigned long type,
>>>-			   unsigned long loc, unsigned long value);
>>>
>>> static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
>>> {
>>>diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
>>>index b1b78ff..c5e9a5c 100644
>>>--- a/arch/x86/kernel/Makefile
>>>+++ b/arch/x86/kernel/Makefile
>>>@@ -67,7 +67,6 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
>>> obj-y				+= apic/
>>> obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
>>> obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
>>>-obj-$(CONFIG_LIVEPATCH)		+= livepatch.o
>>> obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
>>> obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
>>> obj-$(CONFIG_X86_TSC)		+= trace_clock.o
>>>diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
>>>deleted file mode 100644
>>>index d1d35cc..0000000
>>>--- a/arch/x86/kernel/livepatch.c
>>>+++ /dev/null
>>>@@ -1,91 +0,0 @@
>>>-/*
>>>- * livepatch.c - x86-specific Kernel Live Patching Core
>>>- *
>>>- * Copyright (C) 2014 Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>- * Copyright (C) 2014 SUSE
>>>- *
>>>- * This program is free software; you can redistribute it and/or
>>>- * modify it under the terms of the GNU General Public License
>>>- * as published by the Free Software Foundation; either version 2
>>>- * of the License, or (at your option) any later version.
>>>- *
>>>- * This program is distributed in the hope that it will be useful,
>>>- * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>- * GNU General Public License for more details.
>>>- *
>>>- * You should have received a copy of the GNU General Public License
>>>- * along with this program; if not, see <http://www.gnu.org/licenses/>.
>>>- */
>>>-
>>>-#include <linux/module.h>
>>>-#include <linux/uaccess.h>
>>>-#include <asm/cacheflush.h>
>>>-#include <asm/page_types.h>
>>>-#include <asm/elf.h>
>>>-#include <asm/livepatch.h>
>>>-
>>>-/**
>>>- * klp_write_module_reloc() - write a relocation in a module
>>>- * @mod:	module in which the section to be modified is found
>>>- * @type:	ELF relocation type (see asm/elf.h)
>>>- * @loc:	address that the relocation should be written to
>>>- * @value:	relocation value (sym address + addend)
>>>- *
>>>- * This function writes a relocation to the specified location for
>>>- * a particular module.
>>>- */
>>>-int klp_write_module_reloc(struct module *mod, unsigned long type,
>>>-			   unsigned long loc, unsigned long value)
>>>-{
>>>-	int ret, numpages, size = 4;
>>>-	bool readonly;
>>>-	unsigned long val;
>>>-	unsigned long core = (unsigned long)mod->module_core;
>>>-	unsigned long core_size = mod->core_size;
>>>-
>>>-	switch (type) {
>>>-	case R_X86_64_NONE:
>>>-		return 0;
>>>-	case R_X86_64_64:
>>>-		val = value;
>>>-		size = 8;
>>>-		break;
>>>-	case R_X86_64_32:
>>>-		val = (u32)value;
>>>-		break;
>>>-	case R_X86_64_32S:
>>>-		val = (s32)value;
>>>-		break;
>>>-	case R_X86_64_PC32:
>>>-		val = (u32)(value - loc);
>>>-		break;
>>>-	default:
>>>-		/* unsupported relocation type */
>>>-		return -EINVAL;
>>>-	}
>>>-
>>>-	if (loc < core || loc >= core + core_size)
>>>-		/* loc does not point to any symbol inside the module */
>>>-		return -EINVAL;
>>>-
>>>-	readonly = false;
>>>-
>>>-#ifdef CONFIG_DEBUG_SET_MODULE_RONX
>>>-	if (loc < core + mod->core_ro_size)
>>>-		readonly = true;
>>>-#endif
>>>-
>>>-	/* determine if the relocation spans a page boundary */
>>>-	numpages = ((loc & PAGE_MASK) == ((loc + size) & PAGE_MASK)) ? 1 : 2;
>>>-
>>>-	if (readonly)
>>>-		set_memory_rw(loc & PAGE_MASK, numpages);
>>>-
>>>-	ret = probe_kernel_write((void *)loc, &val, size);
>>>-
>>>-	if (readonly)
>>>-		set_memory_ro(loc & PAGE_MASK, numpages);
>>>-
>>>-	return ret;
>>>-}
>>>diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>>>index 31db7a0..54f62a6 100644
>>>--- a/include/linux/livepatch.h
>>>+++ b/include/linux/livepatch.h
>>>@@ -64,28 +64,21 @@ struct klp_func {
>>> };
>>>
>>> /**
>>>- * struct klp_reloc - relocation structure for live patching
>>>- * @loc:	address where the relocation will be written
>>>- * @val:	address of the referenced symbol (optional,
>>>- *		vmlinux	patches only)
>>>- * @type:	ELF relocation type
>>>- * @name:	name of the referenced symbol (for lookup/verification)
>>>- * @addend:	offset from the referenced symbol
>>>- * @external:	symbol is either exported or within the live patch module itself
>>>+ * struct klp_reloc_sec - relocation section struct for live patching
>>>+ * @index:	Elf section index of the relocation section
>>>+ * @name:	name of the relocation section
>>>+ * @objname:	name of the object associated with the klp reloc section
>>>  */
>>>-struct klp_reloc {
>>>-	unsigned long loc;
>>>-	unsigned long val;
>>>-	unsigned long type;
>>>-	const char *name;
>>>-	int addend;
>>>-	int external;
>>>+struct klp_reloc_sec {
>>>+	unsigned int index;
>>>+	char *name;
>>>+	char *objname;
>>> };
>>>
>>> /**
>>>  * struct klp_object - kernel object structure for live patching
>>>  * @name:	module name (or NULL for vmlinux)
>>>- * @relocs:	relocation entries to be applied at load time
>>>+ * @reloc_secs:	relocation sections to be applied at load time
>>>  * @funcs:	function entries for functions to be patched in the object
>>>  * @kobj:	kobject for sysfs resources
>>>  * @mod:	kernel module associated with the patched object
>>>@@ -95,7 +88,7 @@ struct klp_reloc {
>>> struct klp_object {
>>> 	/* external */
>>> 	const char *name;
>>>-	struct klp_reloc *relocs;
>>>+	struct klp_reloc_sec *reloc_secs;
>>
>>There was a lot of discussion for v1, so I'm not sure, but I thought we
>>ended up deciding to get rid of the klp_reloc_sec struct?  Instead I
>>think the symbol table can be walked directly looking for klp rela
>>sections?
>>
>>The benefits of doing so would be to make the interface simpler -- no
>>need to "cache" the section metadata when it's already easily and
>>quickly available in the module struct elf section headers.
>
>Ah, I might have interpreted the conclusions of that last discussion
>incorrectly.
>
>In that case, I think I can just get rid of my klp_for_each_reloc_sec
>macro as well as the lreloc scaffolding code from kpatch. The only
>potentially "ugly" part of this change is that I'll have to move the
>string parsing stuff here to extract the objname of the __klp_rela
>section (which may not actually look that bad, we'll see how that
>turns out).

Turns out the string parsing stuff, even with the help of lib/string.c, doesn't
look very pretty. As I'm working on v3, I'm starting to think having
klp_write_object_relocations() loop simply through all the elf sections might
not be a good idea. Let me explain.

I don't like the amount of string manipulation code that would potentially come
with this change. Even with a string as simple as ".klp.rela.objname", we'll
end up with a bunch of kstrdup's/kmalloc's and kfree's (unless we modify and
chop the section name string in place, which I don't think we should do) that
are going to be required at every iteration of the loop, all just to be able to
call strcmp() and see if we're dealing with a klp rela section that belongs to
the object in question. This also leads to more complicated error handling.

In v1, the string parsing was done only *once* for each klp rela section in the
patch module code, and each klp rela section is sorted into their respective
object with the reloc_secs list. Then all klp_write_object_relocations() had to
do is iterate over object->reloc_secs. The tradeoff here is the addition of
another struct (klp_reloc_sec), but that is not nearly as bad as string
parsing, which is imo way more error prone and is unnecessary extra work.

Here's some pseudocode to help visualize the potential issues:

function klp_write_object_relocations(..,struct klp_object *obj,..) {
    for each section in mod->sechdrs { // iterate through all elf sections, no more obj->reloc_secs list
        if not a klp rela section
            continue;
        sec_objname = extract_objname_from_section(section);  // .klp.rela.[objname].sectionname
        if (strcmp(sec_objname, obj->name)) { // this klp rela section doesn't belong to this object
            kfree(sec_objname);
            continue;
        }

      for each rela in this klp rela section {
         sym = symtab + ELF_R_SYM(rela->r_info);
         sym_objname = extract_objname_from_symbol(sym) // symname.klp.[objname]
         if (!sym_objname)
             goto handle_error; // calls kfree(sec_objname);
         symname = extract_symname_from_symbol(sym); // [symname].klp.objname
         if (!symname)
             goto handle_error; // calls kfree(sec_objname);
         ret = klp_find_object_symbol(sym_objname, symname, &addr)
         if (ret)
             goto handle_error2; // calls kfree(symname), then kfree(sec_objname)

...etc., you get the idea how messy that is getting, and we haven't even
reached the call to apply_relocate_add() yet.

So I personally think it is better to keep the old v1 way for applying the klp
reloc secs. The sections are still named ".klp.rela.objname" but the parsing is
done once in the patch module code and used only to build the patch scaffolding
structure.

In order to avoid adding any additional string parsing code in v3, I no longer
thing we should rename livepatch symbols to include the symbol objname (i.e.
'symbol.klp.objname'). Recall that this change is for getting rid of external
dynrelas. Instead of parsing the symbol name, we could just encode 1) the
sympos and 2) the index into the .kpatch.strings strtab (that contains the
sym_objname) in sym->st_value. We define two masks (KLP_MASK_SYMPOS,
KLP_MASK_OBJNAME) that extract these values. st_value has either a 32 bit or 64
bit size, both of which are big enough sizes for the sympos and string table
index. One perk we lose is being able to see which object a symbol belongs to
in readelf, but then again we didn't have this benefit to begin with in
v1 nor v2 (where we didn't know the symbol's object and had to use
klp_find_external_symbol anyway), so I wouldn't say it's a loss.

Apologies for the super long explanations, but I think avoiding string parsing
in livepatch core code will make the relocation code much more succinct and
easier to read. Any objections or thoughts on all this?

Thanks,
Jessica
