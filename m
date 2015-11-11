From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [RFC PATCH 3/5] livepatch: reuse module loader code to write
 relocations
Date: Wed, 11 Nov 2015 15:30:53 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511111519250.12467@pobox.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com> <1447130755-17383-4-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447130755-17383-4-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 9 Nov 2015, Jessica Yu wrote:

> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 31db7a0..601e892 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -85,7 +85,7 @@ struct klp_reloc {
>  /**
>   * struct klp_object - kernel object structure for live patching
>   * @name:	module name (or NULL for vmlinux)
> - * @relocs:	relocation entries to be applied at load time
> + * @reloc_secs:	relocation sections to be applied at load time
>   * @funcs:	function entries for functions to be patched in the object
>   * @kobj:	kobject for sysfs resources
>   * @mod:	kernel module associated with the patched object
> @@ -95,7 +95,7 @@ struct klp_reloc {
>  struct klp_object {
>  	/* external */
>  	const char *name;
> -	struct klp_reloc *relocs;
> +	struct list_head reloc_secs;
>  	struct klp_func *funcs;

So I guess we don't need klp_reloc anymore. If true, we should really 
start thinking about proper documentation because there are going to be 
plenty of assumptions about a patch module and we need to have it written 
somewhere. Especially how the relocation sections look like.

>  	/* internal */
> @@ -129,6 +129,13 @@ struct klp_patch {
>  #define klp_for_each_func(obj, func) \
>  	for (func = obj->funcs; func->old_name; func++)
>  
> +struct klp_reloc_sec {
> +	unsigned int index;
> +	char *name;
> +	char *objname;
> +	struct list_head list;
> +};

Description of the structure and its members is missing.

> diff --git a/include/linux/module.h b/include/linux/module.h
> index c8680b1..3c34eb8 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -793,9 +793,15 @@ extern int module_sysfs_initialized;
>  #ifdef CONFIG_DEBUG_SET_MODULE_RONX
>  extern void set_all_modules_text_rw(void);
>  extern void set_all_modules_text_ro(void);
> +extern void
> +set_page_attributes(void *start, void *end,
> +		    int (*set)(unsigned long start, int num_pages));
>  #else
>  static inline void set_all_modules_text_rw(void) { }
>  static inline void set_all_modules_text_ro(void) { }
> +static inline void
> +set_page_attributes(void *start, void *end,
> +		    int (*set)(unsigned long start, int num_pages)) { }
>  #endif

This would be solved after Rusty's and Josh's patches get merged, right?

> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 087a8c7..26c419f 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -28,6 +28,8 @@
>  #include <linux/list.h>
>  #include <linux/kallsyms.h>
>  #include <linux/livepatch.h>
> +#include <linux/elf.h>
> +#include <asm/cacheflush.h>
>  
>  /**
>   * struct klp_ops - structure for tracking registered ftrace ops structs
> @@ -281,46 +283,54 @@ static int klp_find_external_symbol(struct module *pmod, const char *name,
>  }
>  
>  static int klp_write_object_relocations(struct module *pmod,
> -					struct klp_object *obj)
> +					struct klp_object *obj,
> +					struct klp_patch *patch)
>  {
> -	int ret;
> -	struct klp_reloc *reloc;
> +	int relindex, num_relas;
> +	int i, ret = 0;
> +	unsigned long addr;
> +	unsigned int bind;
> +	char *symname;
> +	struct klp_reloc_sec *reloc_sec;
> +	struct load_info *info;
> +	Elf_Rela *rela;
> +	Elf_Sym *sym, *symtab;
> +	Elf_Shdr *symsect;
>  
>  	if (WARN_ON(!klp_is_object_loaded(obj)))
>  		return -EINVAL;
>  
> -	if (WARN_ON(!obj->relocs))
> -		return -EINVAL;
> -
> -	for (reloc = obj->relocs; reloc->name; reloc++) {
> -		if (!klp_is_module(obj)) {
> -			ret = klp_verify_vmlinux_symbol(reloc->name,
> -							reloc->val);
> -			if (ret)
> -				return ret;
> -		} else {
> -			/* module, reloc->val needs to be discovered */
> -			if (reloc->external)
> -				ret = klp_find_external_symbol(pmod,
> -							       reloc->name,
> -							       &reloc->val);
> -			else
> -				ret = klp_find_object_symbol(obj->mod->name,
> -							     reloc->name,
> -							     &reloc->val);
> -			if (ret)
> -				return ret;
> -		}
> -		ret = klp_write_module_reloc(pmod, reloc->type, reloc->loc,
> -					     reloc->val + reloc->addend);
> -		if (ret) {
> -			pr_err("relocation failed for symbol '%s' at 0x%016lx (%d)\n",
> -			       reloc->name, reloc->val, ret);
> -			return ret;
> +	info = pmod->info;
> +	symsect = info->sechdrs + info->index.sym;
> +	symtab = (void *)info->hdr + symsect->sh_offset;
> +
> +	/* For each __klp_rela section for this object */
> +	list_for_each_entry(reloc_sec, &obj->reloc_secs, list) {
> +		relindex = reloc_sec->index;
> +		num_relas = info->sechdrs[relindex].sh_size / sizeof(Elf_Rela);
> +		rela = (Elf_Rela *) info->sechdrs[relindex].sh_addr;
> +
> +		/* For each rela in this __klp_rela section */
> +		for (i = 0; i < num_relas; i++, rela++) {
> +			sym = symtab + ELF_R_SYM(rela->r_info);
> +			symname = info->strtab + sym->st_name;
> +			bind = ELF_ST_BIND(sym->st_info);
> +
> +			if (sym->st_shndx == SHN_LIVEPATCH) {
> +				if (bind == STB_LIVEPATCH_EXT)
> +					ret = klp_find_external_symbol(pmod, symname, &addr);
> +				else
> +					ret = klp_find_object_symbol(obj->name, symname, &addr);
> +				if (ret)
> +					return ret;
> +				sym->st_value = addr;
> +			}
>  		}
> +		ret = apply_relocate_add(info->sechdrs, info->strtab,
> +					 info->index.sym, relindex, pmod);
>  	}
>  
> -	return 0;
> +	return ret;
>  }

Looking at this... do we even need reloc_secs in klp_object? Question is 
whether we need more than one dynrela section for an object. If not then 
the binding between klp_reloc_sec and an object is the only relevant thing 
in the structure, be it index or objname. So we can replace the 
list of structures with just the index in klp_object, or get rid of it 
completely and rely on the name of dynrela section be something like 
__klp_rela_{objname}.

You see, we go through elf sections here which were preserved by module 
loader. We even have relevant sections marked with SHF_RELA_LIVEPATCH. So 
maybe all the stuff around klp_reloc_sec is not necessary.

Thoughts?

> @@ -741,12 +751,23 @@ static int klp_init_object_loaded(struct klp_patch *patch,
>  				  struct klp_object *obj)
>  {
>  	struct klp_func *func;
> +	struct module *pmod;
>  	int ret;
>  
> -	if (obj->relocs) {
> -		ret = klp_write_object_relocations(patch->mod, obj);
> +	pmod = patch->mod;
> +
> +	if (!list_empty(&obj->reloc_secs)) {
> +		set_page_attributes(pmod->module_core,
> +				    pmod->module_core + pmod->core_text_size,
> +				    set_memory_rw);
> +
> +		ret = klp_write_object_relocations(pmod, obj, patch);
>  		if (ret)
>  			return ret;
> +
> +		set_page_attributes(pmod->module_core,
> +				    pmod->module_core + pmod->core_text_size,
> +				    set_memory_ro);
>  	}

And this would get solved with different patches as well. I think the 
calls to set_page_attributes() should be hidden in 
klp_write_object_relocations() as it is in Josh's patch IIRC.

Thanks,
Miroslav
