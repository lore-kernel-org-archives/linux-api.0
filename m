From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Wed, 9 Dec 2015 14:10:14 -0500
Message-ID: <20151209191013.GA25387@packer-debian-8-amd64.digitalocean.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-5-git-send-email-jeyu@redhat.com>
 <20151208183844.GC14846@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208183844.GC14846-8wJ5/zUtDR0XGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Josh Poimboeuf [08/12/15 12:38 -0600]:
>On Mon, Nov 30, 2015 at 11:21:17PM -0500, Jessica Yu wrote:
>> Reuse module loader code to write relocations, thereby eliminating the need
>> for architecture specific relocation code in livepatch. Namely, we reuse
>> apply_relocate_add() in the module loader to write relocations instead of
>> duplicating functionality in livepatch's klp_write_module_reloc(). To apply
>> relocation sections, remaining SHN_LIVEPATCH symbols referenced by relocs
>> are resolved and then apply_relocate_add() is called to apply those
>> relocations.
>>
>> In addition, remove x86 livepatch relocation code. It is no longer needed
>> since symbol resolution and relocation work have been offloaded to module
>> loader.
>>
>> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  arch/x86/include/asm/livepatch.h |  2 -
>>  arch/x86/kernel/Makefile         |  1 -
>>  arch/x86/kernel/livepatch.c      | 91 --------------------------------------
>>  include/linux/livepatch.h        | 30 ++++++-------
>>  include/linux/module.h           |  6 +++
>>  kernel/livepatch/core.c          | 94 ++++++++++++++++++++++------------------
>>  6 files changed, 70 insertions(+), 154 deletions(-)
>>  delete mode 100644 arch/x86/kernel/livepatch.c
>>
>> diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
>> index 19c099a..7312e25 100644
>> --- a/arch/x86/include/asm/livepatch.h
>> +++ b/arch/x86/include/asm/livepatch.h
>> @@ -33,8 +33,6 @@ static inline int klp_check_compiler_support(void)
>>  #endif
>>  	return 0;
>>  }
>> -int klp_write_module_reloc(struct module *mod, unsigned long type,
>> -			   unsigned long loc, unsigned long value);
>>
>>  static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
>>  {
>> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
>> index b1b78ff..c5e9a5c 100644
>> --- a/arch/x86/kernel/Makefile
>> +++ b/arch/x86/kernel/Makefile
>> @@ -67,7 +67,6 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
>>  obj-y				+= apic/
>>  obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
>>  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
>> -obj-$(CONFIG_LIVEPATCH)		+= livepatch.o
>>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
>>  obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
>>  obj-$(CONFIG_X86_TSC)		+= trace_clock.o
>> diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
>> deleted file mode 100644
>> index d1d35cc..0000000
>> --- a/arch/x86/kernel/livepatch.c
>> +++ /dev/null
>> @@ -1,91 +0,0 @@
>> -/*
>> - * livepatch.c - x86-specific Kernel Live Patching Core
>> - *
>> - * Copyright (C) 2014 Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> - * Copyright (C) 2014 SUSE
>> - *
>> - * This program is free software; you can redistribute it and/or
>> - * modify it under the terms of the GNU General Public License
>> - * as published by the Free Software Foundation; either version 2
>> - * of the License, or (at your option) any later version.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - * You should have received a copy of the GNU General Public License
>> - * along with this program; if not, see <http://www.gnu.org/licenses/>.
>> - */
>> -
>> -#include <linux/module.h>
>> -#include <linux/uaccess.h>
>> -#include <asm/cacheflush.h>
>> -#include <asm/page_types.h>
>> -#include <asm/elf.h>
>> -#include <asm/livepatch.h>
>> -
>> -/**
>> - * klp_write_module_reloc() - write a relocation in a module
>> - * @mod:	module in which the section to be modified is found
>> - * @type:	ELF relocation type (see asm/elf.h)
>> - * @loc:	address that the relocation should be written to
>> - * @value:	relocation value (sym address + addend)
>> - *
>> - * This function writes a relocation to the specified location for
>> - * a particular module.
>> - */
>> -int klp_write_module_reloc(struct module *mod, unsigned long type,
>> -			   unsigned long loc, unsigned long value)
>> -{
>> -	int ret, numpages, size = 4;
>> -	bool readonly;
>> -	unsigned long val;
>> -	unsigned long core = (unsigned long)mod->module_core;
>> -	unsigned long core_size = mod->core_size;
>> -
>> -	switch (type) {
>> -	case R_X86_64_NONE:
>> -		return 0;
>> -	case R_X86_64_64:
>> -		val = value;
>> -		size = 8;
>> -		break;
>> -	case R_X86_64_32:
>> -		val = (u32)value;
>> -		break;
>> -	case R_X86_64_32S:
>> -		val = (s32)value;
>> -		break;
>> -	case R_X86_64_PC32:
>> -		val = (u32)(value - loc);
>> -		break;
>> -	default:
>> -		/* unsupported relocation type */
>> -		return -EINVAL;
>> -	}
>> -
>> -	if (loc < core || loc >= core + core_size)
>> -		/* loc does not point to any symbol inside the module */
>> -		return -EINVAL;
>> -
>> -	readonly = false;
>> -
>> -#ifdef CONFIG_DEBUG_SET_MODULE_RONX
>> -	if (loc < core + mod->core_ro_size)
>> -		readonly = true;
>> -#endif
>> -
>> -	/* determine if the relocation spans a page boundary */
>> -	numpages = ((loc & PAGE_MASK) == ((loc + size) & PAGE_MASK)) ? 1 : 2;
>> -
>> -	if (readonly)
>> -		set_memory_rw(loc & PAGE_MASK, numpages);
>> -
>> -	ret = probe_kernel_write((void *)loc, &val, size);
>> -
>> -	if (readonly)
>> -		set_memory_ro(loc & PAGE_MASK, numpages);
>> -
>> -	return ret;
>> -}
>> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>> index 31db7a0..54f62a6 100644
>> --- a/include/linux/livepatch.h
>> +++ b/include/linux/livepatch.h
>> @@ -64,28 +64,21 @@ struct klp_func {
>>  };
>>
>>  /**
>> - * struct klp_reloc - relocation structure for live patching
>> - * @loc:	address where the relocation will be written
>> - * @val:	address of the referenced symbol (optional,
>> - *		vmlinux	patches only)
>> - * @type:	ELF relocation type
>> - * @name:	name of the referenced symbol (for lookup/verification)
>> - * @addend:	offset from the referenced symbol
>> - * @external:	symbol is either exported or within the live patch module itself
>> + * struct klp_reloc_sec - relocation section struct for live patching
>> + * @index:	Elf section index of the relocation section
>> + * @name:	name of the relocation section
>> + * @objname:	name of the object associated with the klp reloc section
>>   */
>> -struct klp_reloc {
>> -	unsigned long loc;
>> -	unsigned long val;
>> -	unsigned long type;
>> -	const char *name;
>> -	int addend;
>> -	int external;
>> +struct klp_reloc_sec {
>> +	unsigned int index;
>> +	char *name;
>> +	char *objname;
>>  };
>>
>>  /**
>>   * struct klp_object - kernel object structure for live patching
>>   * @name:	module name (or NULL for vmlinux)
>> - * @relocs:	relocation entries to be applied at load time
>> + * @reloc_secs:	relocation sections to be applied at load time
>>   * @funcs:	function entries for functions to be patched in the object
>>   * @kobj:	kobject for sysfs resources
>>   * @mod:	kernel module associated with the patched object
>> @@ -95,7 +88,7 @@ struct klp_reloc {
>>  struct klp_object {
>>  	/* external */
>>  	const char *name;
>> -	struct klp_reloc *relocs;
>> +	struct klp_reloc_sec *reloc_secs;
>
>There was a lot of discussion for v1, so I'm not sure, but I thought we
>ended up deciding to get rid of the klp_reloc_sec struct?  Instead I
>think the symbol table can be walked directly looking for klp rela
>sections?
>
>The benefits of doing so would be to make the interface simpler -- no
>need to "cache" the section metadata when it's already easily and
>quickly available in the module struct elf section headers.

Ah, I might have interpreted the conclusions of that last discussion
incorrectly.

In that case, I think I can just get rid of my klp_for_each_reloc_sec
macro as well as the lreloc scaffolding code from kpatch. The only
potentially "ugly" part of this change is that I'll have to move the
string parsing stuff here to extract the objname of the __klp_rela
section (which may not actually look that bad, we'll see how that
turns out).

>>  	struct klp_func *funcs;
>>
>>  	/* internal */
>> @@ -129,6 +122,9 @@ struct klp_patch {
>>  #define klp_for_each_func(obj, func) \
>>  	for (func = obj->funcs; func->old_name; func++)
>>
>> +#define klp_for_each_reloc_sec(obj, reloc_sec) \
>> +	for (reloc_sec = obj->reloc_secs; reloc_sec->name; reloc_sec++)
>> +
>>  int klp_register_patch(struct klp_patch *);
>>  int klp_unregister_patch(struct klp_patch *);
>>  int klp_enable_patch(struct klp_patch *);
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index 9b46256..ea61147 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -777,9 +777,15 @@ extern int module_sysfs_initialized;
>>  #ifdef CONFIG_DEBUG_SET_MODULE_RONX
>>  extern void set_all_modules_text_rw(void);
>>  extern void set_all_modules_text_ro(void);
>> +extern void
>> +set_page_attributes(void *start, void *end,
>> +		    int (*set)(unsigned long start, int num_pages));
>>  #else
>>  static inline void set_all_modules_text_rw(void) { }
>>  static inline void set_all_modules_text_ro(void) { }
>> +static inline void
>> +set_page_attributes(void *start, void *end,
>> +		    int (*set)(unsigned long start, int num_pages)) { }
>>  #endif
>>
>>  #ifdef CONFIG_GENERIC_BUG
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index db545cb..17b7278 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -28,6 +28,9 @@
>>  #include <linux/list.h>
>>  #include <linux/kallsyms.h>
>>  #include <linux/livepatch.h>
>> +#include <linux/elf.h>
>> +#include <asm/cacheflush.h>
>> +#include <linux/moduleloader.h>
>>
>>  /**
>>   * struct klp_ops - structure for tracking registered ftrace ops structs
>> @@ -281,52 +284,48 @@ static int klp_find_external_symbol(struct module *pmod, const char *name,
>>  }
>>
>>  static int klp_write_object_relocations(struct module *pmod,
>> -					struct klp_object *obj)
>> +					struct klp_object *obj,
>> +					struct klp_patch *patch)
>>  {
>> -	int ret;
>> -	struct klp_reloc *reloc;
>> +	int relindex, num_relas;
>> +	int i, ret = 0;
>> +	unsigned long addr;
>> +	char *symname;
>> +	struct klp_reloc_sec *reloc_sec;
>> +	Elf_Rela *rela;
>> +	Elf_Sym *sym, *symtab;
>>
>>  	if (WARN_ON(!klp_is_object_loaded(obj)))
>>  		return -EINVAL;
>>
>> -	if (WARN_ON(!obj->relocs))
>> -		return -EINVAL;
>> -
>> -	for (reloc = obj->relocs; reloc->name; reloc++) {
>> -		if (!klp_is_module(obj)) {
>> -
>> -#if defined(CONFIG_RANDOMIZE_BASE)
>> -			/* If KASLR has been enabled, adjust old value accordingly */
>> -			if (kaslr_enabled())
>> -				reloc->val += kaslr_offset();
>> -#endif
>> -			ret = klp_verify_vmlinux_symbol(reloc->name,
>> -							reloc->val);
>> -			if (ret)
>> -				return ret;
>> -		} else {
>> -			/* module, reloc->val needs to be discovered */
>> -			if (reloc->external)
>> -				ret = klp_find_external_symbol(pmod,
>> -							       reloc->name,
>> -							       &reloc->val);
>> -			else
>> -				ret = klp_find_object_symbol(obj->mod->name,
>> -							     reloc->name,
>> -							     &reloc->val);
>> -			if (ret)
>> -				return ret;
>> -		}
>> -		ret = klp_write_module_reloc(pmod, reloc->type, reloc->loc,
>> -					     reloc->val + reloc->addend);
>> -		if (ret) {
>> -			pr_err("relocation failed for symbol '%s' at 0x%016lx (%d)\n",
>> -			       reloc->name, reloc->val, ret);
>> -			return ret;
>> +	symtab = (void *)pmod->core_symtab;
>> +
>> +	/* For each __klp_rela section for this object */
>> +	klp_for_each_reloc_sec(obj, reloc_sec) {
>> +		relindex = reloc_sec->index;
>> +		num_relas = pmod->sechdrs[relindex].sh_size / sizeof(Elf_Rela);
>> +		rela = (Elf_Rela *) pmod->sechdrs[relindex].sh_addr;
>> +
>> +		/* For each rela in this __klp_rela section */
>> +		for (i = 0; i < num_relas; i++, rela++) {
>> +			sym = symtab + ELF_R_SYM(rela->r_info);
>> +			symname = pmod->core_strtab + sym->st_name;
>> +
>> +			if (sym->st_shndx == SHN_LIVEPATCH) {
>> +				if (sym->st_info == 'K')
>> +					ret = klp_find_external_symbol(pmod, symname, &addr);
>> +				else
>> +					ret = klp_find_object_symbol(obj->name, symname, &addr);
>> +				if (ret)
>> +					return ret;
>> +				sym->st_value = addr;
>
>So I think you're also working on removing the 'external' stuff.  Any
>idea how this code will handle that?  Specifically I'm wondering how the
>objname and sympos of the rela's symbol will be specified.  Maybe it can
>be encoded somehow in one of the symbol fields (st_value)?

Thanks for bringing this up. I think we can just encode the symbol's
position in kallsyms in the symbol's st_other field. It isn't used
anywhere and has size char, which is plenty of bits to represent the
small ints.

For objname, the simplest solution might be to append ".klp.objname"
to the symbol name, and extract out this suffix when resolving the
symbol. Another way might be to have st_value contain the index into
the strtab (or .kpatch.strings) that contains the objname. Then we'd
access the objname just like how we access the symbol's name (strtab +
sym->st_name). After we find the objname we can then overwrite
st_value with the real address. I think this second method is cleaner.
Thoughts?

>> +			}
>>  		}
>> +		ret = apply_relocate_add(pmod->sechdrs, pmod->core_strtab,
>> +					 pmod->index.sym, relindex, pmod);
>>  	}
>>
>> -	return 0;
>> +	return ret;
>>  }
>>
>>  static void notrace klp_ftrace_handler(unsigned long ip,
>> @@ -747,13 +746,22 @@ static int klp_init_object_loaded(struct klp_patch *patch,
>>  				  struct klp_object *obj)
>>  {
>>  	struct klp_func *func;
>> +	struct module *pmod;
>>  	int ret;
>>
>> -	if (obj->relocs) {
>> -		ret = klp_write_object_relocations(patch->mod, obj);
>> -		if (ret)
>> -			return ret;
>> -	}
>> +	pmod = patch->mod;
>> +
>> +	set_page_attributes(pmod->module_core,
>> +			    pmod->module_core + pmod->core_text_size,
>> +			    set_memory_rw);
>> +
>> +	ret = klp_write_object_relocations(pmod, obj, patch);
>> +	if (ret)
>> +		return ret;
>> +
>> +	set_page_attributes(pmod->module_core,
>> +			    pmod->module_core + pmod->core_text_size,
>> +			    set_memory_ro);
>>
>>  	klp_for_each_func(obj, func) {
>>  		ret = klp_find_verify_func_addr(obj, func);
>> --
>> 2.4.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe live-patching" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>-- 
>Josh
