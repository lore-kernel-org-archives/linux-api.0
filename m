From: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v4 4/6] livepatch: reuse module loader code to write
 relocations
Date: Mon, 8 Feb 2016 14:26:06 -0600
Message-ID: <20160208202606.GD23106@treble.redhat.com>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
 <1454548271-24923-5-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454548271-24923-5-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Feb 03, 2016 at 08:11:09PM -0500, Jessica Yu wrote:
> Reuse module loader code to write relocations, thereby eliminating the need
> for architecture specific relocation code in livepatch. Specifically, reuse
> the apply_relocate_add() function in the module loader to write relocations
> instead of duplicating functionality in livepatch's arch-dependent
> klp_write_module_reloc() function.
> 
> In order to accomplish this, livepatch modules manage their own relocation
> sections (marked with the SHF_RELA_LIVEPATCH section flag) and
> livepatch-specific symbols (marked with SHN_LIVEPATCH symbol section
> index). To apply livepatch relocation sections, livepatch symbols
> referenced by relocs are resolved and then apply_relocate_add() is called
> to apply those relocations.
> 
> In addition, remove x86 livepatch relocation code and the s390
> klp_write_module_reloc() function stub. They are no longer needed since
> relocation work has been offloaded to module loader.
> 
> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/s390/include/asm/livepatch.h |   7 -
>  arch/x86/include/asm/livepatch.h  |   2 -
>  arch/x86/kernel/Makefile          |   1 -
>  arch/x86/kernel/livepatch.c       |  70 ----------
>  include/linux/livepatch.h         |  30 ++--
>  kernel/livepatch/core.c           | 283 ++++++++++++++++++++++++++++++--------
>  6 files changed, 238 insertions(+), 155 deletions(-)
>  delete mode 100644 arch/x86/kernel/livepatch.c
> 
> diff --git a/arch/s390/include/asm/livepatch.h b/arch/s390/include/asm/livepatch.h
> index a52b6cc..350a751 100644
> --- a/arch/s390/include/asm/livepatch.h
> +++ b/arch/s390/include/asm/livepatch.h
> @@ -25,13 +25,6 @@ static inline int klp_check_compiler_support(void)
>  	return 0;
>  }
>  
> -static inline int klp_write_module_reloc(struct module *mod, unsigned long
> -		type, unsigned long loc, unsigned long value)
> -{
> -	/* not supported yet */
> -	return -ENOSYS;
> -}
> -
>  static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
>  {
>  	regs->psw.addr = ip;
> diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
> index e795f52..d7c2b57 100644
> --- a/arch/x86/include/asm/livepatch.h
> +++ b/arch/x86/include/asm/livepatch.h
> @@ -33,8 +33,6 @@ static inline int klp_check_compiler_support(void)
>  #endif
>  	return 0;
>  }
> -int klp_write_module_reloc(struct module *mod, unsigned long type,
> -			   unsigned long loc, unsigned long value);
>  
>  static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
>  {
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index b1b78ff..c5e9a5c 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -67,7 +67,6 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
>  obj-y				+= apic/
>  obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
>  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
> -obj-$(CONFIG_LIVEPATCH)		+= livepatch.o
>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
>  obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
>  obj-$(CONFIG_X86_TSC)		+= trace_clock.o
> diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
> deleted file mode 100644
> index 92fc1a5..0000000
> --- a/arch/x86/kernel/livepatch.c
> +++ /dev/null
> @@ -1,70 +0,0 @@
> -/*
> - * livepatch.c - x86-specific Kernel Live Patching Core
> - *
> - * Copyright (C) 2014 Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> - * Copyright (C) 2014 SUSE
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see <http://www.gnu.org/licenses/>.
> - */
> -
> -#include <linux/module.h>
> -#include <linux/uaccess.h>
> -#include <asm/elf.h>
> -#include <asm/livepatch.h>
> -
> -/**
> - * klp_write_module_reloc() - write a relocation in a module
> - * @mod:	module in which the section to be modified is found
> - * @type:	ELF relocation type (see asm/elf.h)
> - * @loc:	address that the relocation should be written to
> - * @value:	relocation value (sym address + addend)
> - *
> - * This function writes a relocation to the specified location for
> - * a particular module.
> - */
> -int klp_write_module_reloc(struct module *mod, unsigned long type,
> -			   unsigned long loc, unsigned long value)
> -{
> -	size_t size = 4;
> -	unsigned long val;
> -	unsigned long core = (unsigned long)mod->core_layout.base;
> -	unsigned long core_size = mod->core_layout.size;
> -
> -	switch (type) {
> -	case R_X86_64_NONE:
> -		return 0;
> -	case R_X86_64_64:
> -		val = value;
> -		size = 8;
> -		break;
> -	case R_X86_64_32:
> -		val = (u32)value;
> -		break;
> -	case R_X86_64_32S:
> -		val = (s32)value;
> -		break;
> -	case R_X86_64_PC32:
> -		val = (u32)(value - loc);
> -		break;
> -	default:
> -		/* unsupported relocation type */
> -		return -EINVAL;
> -	}
> -
> -	if (loc < core || loc >= core + core_size)
> -		/* loc does not point to any symbol inside the module */
> -		return -EINVAL;
> -
> -	return probe_kernel_write((void *)loc, &val, size);
> -}
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index fdd5f1c..1a40a72 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -65,27 +65,8 @@ struct klp_func {
>  };
>  
>  /**
> - * struct klp_reloc - relocation structure for live patching
> - * @loc:	address where the relocation will be written
> - * @sympos:	position in kallsyms to disambiguate symbols (optional)
> - * @type:	ELF relocation type
> - * @name:	name of the referenced symbol (for lookup/verification)
> - * @addend:	offset from the referenced symbol
> - * @external:	symbol is either exported or within the live patch module itself
> - */
> -struct klp_reloc {
> -	unsigned long loc;
> -	unsigned long sympos;
> -	unsigned long type;
> -	const char *name;
> -	int addend;
> -	int external;
> -};
> -
> -/**
>   * struct klp_object - kernel object structure for live patching
>   * @name:	module name (or NULL for vmlinux)
> - * @relocs:	relocation entries to be applied at load time
>   * @funcs:	function entries for functions to be patched in the object
>   * @kobj:	kobject for sysfs resources
>   * @mod:	kernel module associated with the patched object
> @@ -95,7 +76,6 @@ struct klp_reloc {
>  struct klp_object {
>  	/* external */
>  	const char *name;
> -	struct klp_reloc *relocs;
>  	struct klp_func *funcs;
>  
>  	/* internal */
> @@ -123,6 +103,16 @@ struct klp_patch {
>  	enum klp_state state;
>  };
>  
> +/*
> + * Livepatch symbol and relocation section prefixes:
> + * ".klp.rela." for relocation sections
> + * ".klp.sym." for livepatch symbols
> + */
> +#define KLP_SYM_PREFIX ".klp.sym."
> +#define KLP_SYM_PREFIX_LEN 9
> +#define KLP_RELASEC_PREFIX ".klp.rela."
> +#define KLP_RELASEC_PREFIX_LEN 10
> +
>  #define klp_for_each_object(patch, obj) \
>  	for (obj = patch->objs; obj->funcs; obj++)
>  
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 7aa975d..c1fe57c 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -28,6 +28,9 @@
>  #include <linux/list.h>
>  #include <linux/kallsyms.h>
>  #include <linux/livepatch.h>
> +#include <linux/elf.h>
> +#include <linux/string.h>
> +#include <linux/moduleloader.h>
>  #include <asm/cacheflush.h>
>  
>  /**
> @@ -87,6 +90,166 @@ static bool klp_is_object_loaded(struct klp_object *obj)
>  	return !obj->name || obj->mod;
>  }
>  
> +/*
> + * Check if a livepatch symbol is formatted properly.
> + *
> + * See Documentation/livepatch/module-elf-format.txt for a
> + * detailed outline of requirements.
> + */
> +static int klp_check_symbol_format(struct module *pmod, Elf_Sym *sym)
> +{
> +	size_t len;
> +	char *s, *objname, *symname;
> +
> +	if (sym->st_shndx != SHN_LIVEPATCH)
> +		return -EINVAL;
> +
> +	/*
> +	 * Livepatch symbol names must follow this format:
> +	 * .klp.sym.objname.symbol_name,sympos
> +	 */
> +	s = pmod->strtab + sym->st_name;
> +	/* [.klp.sym.]objname.symbol_name,sympos */
> +	if (!s || strncmp(s, KLP_SYM_PREFIX, KLP_SYM_PREFIX_LEN))
> +		return -EINVAL;
> +
> +	/* .klp.sym.[objname].symbol_name,sympos */
> +	objname = s + KLP_SYM_PREFIX_LEN;
> +	len = strcspn(objname, ".");
> +	if (!(len > 0))
> +		return -EINVAL;
> +
> +	/* .klp.sym.objname.symbol_name,[sympos] */
> +	if (!strchr(s, ','))
> +		return -EINVAL;
> +
> +	/* .klp.sym.objname.[symbol_name],sympos */
> +	symname = objname + len + 1;
> +	len = strcspn(symname, ",");
> +	if (!(len > 0))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/*
> + * Check if a livepatch relocation section is formatted properly.
> + *
> + * See Documentation/livepatch/module-elf-format.txt for a
> + * detailed outline of requirements.
> + */
> +static int klp_check_relasec_format(struct module *pmod, Elf_Shdr *relasec)
> +{
> +	char *secname;
> +	size_t len;
> +
> +	secname = pmod->klp_info->secstrings + relasec->sh_name;
> +	/* [.klp.rela.]objname.section_name */
> +	if (!secname || strncmp(secname, KLP_RELASEC_PREFIX,
> +				KLP_RELASEC_PREFIX_LEN))
> +		return -EINVAL;
> +
> +	/* .klp.rela.[objname].section_name */
> +	len = strcspn(secname + KLP_RELASEC_PREFIX_LEN, ".");
> +	if (!(len > 0))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/*
> + * Check if obj->name matches the objname encoded in the rela
> + * section name (.klp.rela.[objname].section_name)
> + *
> + * Must pass klp_check_relasec_format() before calling this.
> + */
> +static bool klp_relasec_matches_object(struct module *pmod, Elf_Shdr *relasec,
> +				       struct klp_object *obj)
> +{
> +	size_t len;
> +	const char *obj_objname, *sec_objname, *secname;
> +
> +	secname = pmod->klp_info->secstrings + relasec->sh_name;
> +	/* .klp.rela.[objname].section_name */
> +	sec_objname = secname + KLP_RELASEC_PREFIX_LEN;
> +	obj_objname = klp_is_module(obj) ? obj->name : "vmlinux";
> +
> +	/* Get length of the objname encoded in the section name */
> +	len = strcspn(sec_objname, ".");
> +
> +	if (strlen(obj_objname) != len)
> +		return false;
> +
> +	return strncmp(sec_objname, obj_objname, len) ? false : true;
> +}
> +
> +/*
> + * klp_get_* helper functions
> + *
> + * klp_get_* functions extract different components of the name
> + * of a livepatch symbol. The full symbol name from the strtab
> + * is passed in as parameter @s, and @result is filled in with
> + * the extracted component.
> + *
> + * These functions assume a correctly formatted symbol and the
> + * klp_check_symbol_format() test *must* pass before calling any
> + * of these functions.
> + */
> +
> +/* .klp.sym.[objname].symbol_name,sympos */
> +static int klp_get_sym_objname(char *s, char **result)
> +{
> +	size_t len;
> +	char *objname, *objname_start;
> +
> +	/* .klp.sym.[objname].symbol_name,sympos */
> +	objname_start = s + KLP_SYM_PREFIX_LEN;
> +	len = strcspn(objname_start, ".");
> +	objname = kstrndup(objname_start, len, GFP_KERNEL);
> +	if (objname == NULL)
> +		return -ENOMEM;
> +
> +	/* klp_find_object_symbol() treats NULL as vmlinux */
> +	if (!strcmp(objname, "vmlinux")) {
> +		*result = NULL;
> +		kfree(objname);
> +	} else
> +		*result = objname;
> +
> +	return 0;
> +}
> +
> +/* .klp.sym.objname.[symbol_name],sympos */
> +static int klp_get_symbol_name(char *s, char **result)
> +{
> +	size_t len;
> +	char *objname, *symname;
> +
> +	/* .klp.sym.[objname].symbol_name,sympos */
> +	objname = s + KLP_SYM_PREFIX_LEN;
> +	len = strcspn(objname, ".");
> +
> +	/* .klp.sym.objname.[symbol_name],sympos */
> +	symname = objname + len + 1;
> +	len = strcspn(symname, ",");
> +
> +	*result = kstrndup(symname, len, GFP_KERNEL);
> +	if (*result == NULL)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +/* .klp.sym.objname.symbol_name,[sympos] */
> +static int klp_get_sympos(char *s, unsigned long *result)
> +{
> +	char *sympos;
> +
> +	/* .klp.sym.symbol_name,[sympos] */
> +	sympos = strchr(s, ',') + 1;
> +	return kstrtol(sympos, 10, result);
> +}
> +
>  /* sets obj->mod if object is not vmlinux and module is found */
>  static void klp_find_object_module(struct klp_object *obj)
>  {

I think all the above string parsing code could be replaced with a
couple of sscanf() calls.

For example:

	char objname[64], symname[256];

	ret = sscanf(s, ".klp.sym.%63[^.].%255[^,],%u", objname, symname, &sympos);
	if (ret < 3)
		// string doesn't match expected format

That would be much simpler.

Only problem is, the kernel version of sscanf() doesn't seem to support
the '[' conversion specifier.  At least not yet ;-)  Adding support for
that would be a win-win: less code overall, and the addition of a useful
scanf feature which could be used by other code.

> @@ -204,74 +367,83 @@ static int klp_find_object_symbol(const char *objname, const char *name,
>  	return -EINVAL;
>  }
>  
> -/*
> - * external symbols are located outside the parent object (where the parent
> - * object is either vmlinux or the kmod being patched).
> - */
> -static int klp_find_external_symbol(struct module *pmod, const char *name,
> -				    unsigned long *addr)
> +static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
>  {
> -	const struct kernel_symbol *sym;
> -
> -	/* first, check if it's an exported symbol */
> -	preempt_disable();
> -	sym = find_symbol(name, NULL, NULL, true, true);
> -	if (sym) {
> -		*addr = sym->value;
> -		preempt_enable();
> -		return 0;
> +	int i, ret = 0;
> +	Elf_Rela *relas;
> +	Elf_Sym *sym;
> +	char *s, *symbol_name, *sym_objname;
> +	unsigned long sympos;
> +
> +	relas = (Elf_Rela *) relasec->sh_addr;
> +	/* For each rela in this .klp.rela. section */
> +	for (i = 0; i < relasec->sh_size / sizeof(Elf_Rela); i++) {
> +		sym = pmod->symtab + ELF_R_SYM(relas[i].r_info);
> +
> +		/* Check if the symbol is formatted correctly */
> +		ret = klp_check_symbol_format(pmod, sym);
> +		if (ret)
> +			goto out;
> +		/* Format: .klp.sym.objname.symbol_name,sympos */
> +		s = pmod->strtab + sym->st_name;
> +		ret = klp_get_symbol_name(s, &symbol_name);
> +		if (ret)
> +			goto out;
> +		ret = klp_get_sym_objname(s, &sym_objname);
> +		if (ret)
> +			goto free_symbol_name;
> +		ret = klp_get_sympos(s, &sympos);
> +		if (ret)
> +			goto free_objname;

IMO whitespace after all the gotos would help with readability.

Also, since the "out" label is just a return, the "goto out"'s can all
just be replaced with returns.

> +
> +		ret = klp_find_object_symbol(sym_objname, symbol_name, sympos,
> +					     (unsigned long *) &sym->st_value);
> +free_objname:
> +		kfree(sym_objname);
> +free_symbol_name:
> +		kfree(symbol_name);
> +		if (ret)
> +			goto out;
>  	}
> -	preempt_enable();
> -
> -	/*
> -	 * Check if it's in another .o within the patch module. This also
> -	 * checks that the external symbol is unique.
> -	 */
> -	return klp_find_object_symbol(pmod->name, name, 0, addr);
> +out:
> +	return ret;
>  }
>  
>  static int klp_write_object_relocations(struct module *pmod,
>  					struct klp_object *obj)
>  {
> -	int ret = 0;
> -	unsigned long val;
> -	struct klp_reloc *reloc;
> +	int i, ret = 0;
> +	Elf_Shdr *sec;
>  
>  	if (WARN_ON(!klp_is_object_loaded(obj)))
>  		return -EINVAL;
>  
> -	if (WARN_ON(!obj->relocs))
> -		return -EINVAL;
> -
>  	module_disable_ro(pmod);
> +	/* For each klp relocation section */
> +	for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
> +		sec = pmod->klp_info->sechdrs + i;
> +		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
> +			continue;
>  
> -	for (reloc = obj->relocs; reloc->name; reloc++) {
> -		/* discover the address of the referenced symbol */
> -		if (reloc->external) {
> -			if (reloc->sympos > 0) {
> -				pr_err("non-zero sympos for external reloc symbol '%s' is not supported\n",
> -				       reloc->name);
> -				ret = -EINVAL;
> -				goto out;
> -			}
> -			ret = klp_find_external_symbol(pmod, reloc->name, &val);
> -		} else
> -			ret = klp_find_object_symbol(obj->name,
> -						     reloc->name,
> -						     reloc->sympos,
> -						     &val);
> +		/* Check if the klp section is formatted correctly */
> +		ret = klp_check_relasec_format(pmod, sec);

I think this code is self-evident and the comment isn't needed.

>  		if (ret)
>  			goto out;
>  
> -		ret = klp_write_module_reloc(pmod, reloc->type, reloc->loc,
> -					     val + reloc->addend);
> -		if (ret) {
> -			pr_err("relocation failed for symbol '%s' at 0x%016lx (%d)\n",
> -			       reloc->name, val, ret);
> +		/* Check if the klp section belongs to obj */
> +		if (!klp_relasec_matches_object(pmod, sec, obj))
> +			continue;
> +
> +		/* Resolve all livepatch syms referenced in this rela section */
> +		ret = klp_resolve_symbols(sec, pmod);
> +		if (ret)
>  			goto out;
> -		}
> -	}
>  
> +		ret = apply_relocate_add(pmod->klp_info->sechdrs, pmod->strtab,
> +					 pmod->klp_info->symndx, i, pmod);
> +		if (ret)
> +			goto out;
> +	}
>  out:
>  	module_enable_ro(pmod);
>  	return ret;
> @@ -703,11 +875,9 @@ static int klp_init_object_loaded(struct klp_patch *patch,
>  	struct klp_func *func;
>  	int ret;
>  
> -	if (obj->relocs) {
> -		ret = klp_write_object_relocations(patch->mod, obj);
> -		if (ret)
> -			return ret;
> -	}
> +	ret = klp_write_object_relocations(patch->mod, obj);
> +	if (ret)
> +		return ret;
>  
>  	klp_for_each_func(obj, func) {
>  		ret = klp_find_object_symbol(obj->name, func->old_name,
> @@ -842,6 +1012,9 @@ int klp_register_patch(struct klp_patch *patch)
>  {
>  	int ret;
>  
> +	if (!is_livepatch_module(patch->mod))
> +		return -EINVAL;
> +
>  	if (!klp_initialized())
>  		return -ENODEV;
>  
> -- 
> 2.4.3
> 

-- 
Josh
