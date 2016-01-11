From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH v3 4/6] livepatch: reuse module loader code to write
 relocations
Date: Mon, 11 Jan 2016 17:56:13 +0100
Message-ID: <20160111165613.GL731@pathway.suse.cz>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
 <1452281304-28618-5-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452281304-28618-5-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri 2016-01-08 14:28:22, Jessica Yu wrote:
> Reuse module loader code to write relocations, thereby eliminating the need
> for architecture specific relocation code in livepatch. Namely, we reuse
> apply_relocate_add() in the module loader to write relocations instead of
> duplicating functionality in livepatch's klp_write_module_reloc(). To apply
> relocation sections, remaining SHN_LIVEPATCH symbols referenced by relocs
> are resolved and then apply_relocate_add() is called to apply those
> relocations.
> 
> In addition, remove x86 livepatch relocation code. It is no longer needed
> since symbol resolution and relocation work have been offloaded to module
> loader.
> 
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -204,74 +207,70 @@ static int klp_find_object_symbol(const char *objname, const char *name,
>  	return -EINVAL;
>  }
>  
> -/*
> - * external symbols are located outside the parent object (where the parent
> - * object is either vmlinux or the kmod being patched).
> - */
> -static int klp_find_external_symbol(struct module *pmod, const char *name,
> -				    unsigned long *addr)
> +static int klp_resolve_symbols(Elf_Shdr *relsec, struct module *pmod)
>  {
> -	const struct kernel_symbol *sym;
> +	int i, len, ret = 0;
> +	Elf_Rela *relas;
> +	Elf_Sym *sym;
> +	char *symname, *sym_objname;
>  
> -	/* first, check if it's an exported symbol */
> -	preempt_disable();
> -	sym = find_symbol(name, NULL, NULL, true, true);
> -	if (sym) {
> -		*addr = sym->value;
> -		preempt_enable();
> -		return 0;
> +	relas = (Elf_Rela *) relsec->sh_addr;
> +	/* For each rela in this .klp.rel. section */
> +	for (i = 0; i < relsec->sh_size / sizeof(Elf_Rela); i++) {
> +		sym = pmod->core_symtab + ELF_R_SYM(relas[i].r_info);
> +		symname = pmod->core_strtab + sym->st_name;
> +
> +		len = strcspn(symname + KLP_TAG_LEN, ".");

We should check that len is non-zero. Otherwise, sym_objname might
be empty string and symname might overflow below.

Also we should check that symname really starts with .klp.sym. to
avoid invalid memory access.

> +		sym_objname = strncmp(symname + KLP_TAG_LEN, "vmlinux", len) ?
> +			kstrndup(symname + KLP_TAG_LEN, len, GFP_KERNEL) : NULL;
> +		/* .klp.sym.objname.[symbol_name] */
> +		symname += KLP_TAG_LEN + len + 1;
> +
> +		ret = klp_find_object_symbol(sym_objname, symname,
> +					     KLP_SYMPOS(sym->st_other),
> +					     (unsigned long *) &sym->st_value);
> +		kfree(sym_objname);
> +		if (ret)
> +			return ret;
>  	}
> -	preempt_enable();
>  
> -	/*
> -	 * Check if it's in another .o within the patch module. This also
> -	 * checks that the external symbol is unique.
> -	 */
> -	return klp_find_object_symbol(pmod->name, name, 0, addr);
> +	return ret;
>  }
>  
>  static int klp_write_object_relocations(struct module *pmod,
>  					struct klp_object *obj)
>  {
> -	int ret = 0;
> -	unsigned long val;
> -	struct klp_reloc *reloc;
> +	int i, len, ret = 0;
> +	char *secname;
> +	const char *objname;
>  
>  	if (WARN_ON(!klp_is_object_loaded(obj)))
>  		return -EINVAL;
>  
> -	if (WARN_ON(!obj->relocs))
> -		return -EINVAL;
> +	objname = klp_is_module(obj) ? obj->name : "vmlinux";
>  
>  	module_disable_ro(pmod);
> +	/* For each klp rela section for this object */
> +	for (i = 1; i < pmod->info->hdr->e_shnum; i++) {
> +		if (!(pmod->info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH))
> +			continue;
> +
> +		secname = pmod->info->secstrings + pmod->info->sechdrs[i].sh_name;
> +		/* .klp.rel.[objname].section_name */
> +		len = strcspn(secname + KLP_TAG_LEN, ".");

We should check that secname realy starts with .klp.rel. string
to avoid access out of memmory.

Otherwise, nice work.

Thanks,
Petr.

> +
> +		if (strncmp(objname, secname + KLP_TAG_LEN, len))
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
> +		ret = klp_resolve_symbols(pmod->info->sechdrs + i, pmod);
>  		if (ret)
>  			goto out;
>  
> -		ret = klp_write_module_reloc(pmod, reloc->type, reloc->loc,
> -					     val + reloc->addend);
> -		if (ret) {
> -			pr_err("relocation failed for symbol '%s' at 0x%016lx (%d)\n",
> -			       reloc->name, val, ret);
> +		ret = apply_relocate_add(pmod->info->sechdrs, pmod->core_strtab,
> +					 pmod->info->index.sym, i, pmod);
> +		if (ret)
>  			goto out;
> -		}
>  	}
> -
>  out:
>  	module_enable_ro(pmod);
>  	return ret;
