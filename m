From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v5 4/6] livepatch: reuse module loader code to write
 relocations
Date: Mon, 21 Mar 2016 14:55:55 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1603211449240.12175@pobox.suse.cz>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com> <1458157628-8264-5-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1458157628-8264-5-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 16 Mar 2016, Jessica Yu wrote:

[...]

> +struct klp_buf {
> +	char symname[KSYM_SYMBOL_LEN];

I think it is better to make this KSYM_NAME_LEN. KSYM_SYMBOL_LEN looks 
like something different and KSYM_NAME_LEN is 128 which you reference 
below.

> +	char objname[MODULE_NAME_LEN];
> +};

[...]

> +static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
> +{
> +	int i, cnt, vmlinux, ret;
> +	struct klp_buf bufs = {0};
> +	Elf_Rela *relas;
> +	Elf_Sym *sym;
> +	char *symname;
> +	unsigned long sympos;
> +
> +	relas = (Elf_Rela *) relasec->sh_addr;
> +	/* For each rela in this klp relocation section */
> +	for (i = 0; i < relasec->sh_size / sizeof(Elf_Rela); i++) {
> +		sym = pmod->core_kallsyms.symtab + ELF_R_SYM(relas[i].r_info);
> +		if (sym->st_shndx != SHN_LIVEPATCH)
> +			return -EINVAL;
> +
> +		klp_clear_buf(&bufs);
> +
> +		/* Format: .klp.sym.objname.symbol_name,sympos */
> +		symname = pmod->core_kallsyms.strtab + sym->st_name;
> +		cnt = sscanf(symname, ".klp.sym.%64[^.].%128[^,],%lu",
> +			     bufs.objname, bufs.symname, &sympos);

It would be really nice to change actual values for their macro 
definitions, but this would be a mess which is not worth it. Anyway 
shouldn't those width modifiers be %63 and %127 to make a room for \0?

> +		if (cnt != 3)
> +			return -EINVAL;
> +
> +		/* klp_find_object_symbol() treats a NULL objname as vmlinux */
> +		vmlinux = !strcmp(bufs.objname, "vmlinux");
> +		ret = klp_find_object_symbol(vmlinux ? NULL : bufs.objname,
> +					     bufs.symname, sympos,
> +					     (unsigned long *) &sym->st_value);
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
> +	return 0;
>  }
>  
>  static int klp_write_object_relocations(struct module *pmod,
>  					struct klp_object *obj)
>  {
> -	int ret = 0;
> -	unsigned long val;
> -	struct klp_reloc *reloc;
> +	int i, cnt, ret = 0;
> +	const char *objname, *secname;
> +	struct klp_buf bufs = {0};
> +	Elf_Shdr *sec;
>  
>  	if (WARN_ON(!klp_is_object_loaded(obj)))
>  		return -EINVAL;
>  
> -	if (WARN_ON(!obj->relocs))
> -		return -EINVAL;
> +	objname = klp_is_module(obj) ? obj->name : "vmlinux";
>  
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
> -		if (ret)
> -			goto out;
> +		klp_clear_buf(&bufs);
>  
> -		ret = klp_write_module_reloc(pmod, reloc->type, reloc->loc,
> -					     val + reloc->addend);
> -		if (ret) {
> -			pr_err("relocation failed for symbol '%s' at 0x%016lx (%d)\n",
> -			       reloc->name, val, ret);
> -			goto out;
> +		/* Check if this klp relocation section belongs to obj */
> +		secname = pmod->klp_info->secstrings + sec->sh_name;
> +		cnt = sscanf(secname, ".klp.rela.%64[^.]", bufs.objname);

Same here.

Otherwise it looks really good (which applies for the whole series), so 
after fixing these nits you can add my

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

Cheers,
Miroslav
