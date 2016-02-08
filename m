From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [RFC PATCH v4 4/6] livepatch: reuse module loader code to write
 relocations
Date: Mon, 8 Feb 2016 16:05:38 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1602081554320.12964@pobox.suse.cz>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com> <1454548271-24923-5-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1454548271-24923-5-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org


Hi,

several minor things and nits below. Otherwise it is ok.

On Wed, 3 Feb 2016, Jessica Yu wrote:

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

strcspn() returns size_t, so we can check only for 0

if (!len)
	return -EINVAL

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

Same here.

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

This is really a nitpick, but you have a comment about mandatory format of 
the name here in klp_check_symbol_format().

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

You don't check if section_name part is non-empty.

[...]

> +/* .klp.sym.[objname].symbol_name,sympos */
> +static int klp_get_sym_objname(char *s, char **result)
> +{

Do we need result to be a double-pointer? If I am not mistaken just 'char 
*result' could be sufficient. You check the return value, so result could 
be NULL or objname as found. No?

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

According to CodingStyle there should be curly braces even for else 
branch.

> +	return 0;
> +}
> +
> +/* .klp.sym.objname.[symbol_name],sympos */
> +static int klp_get_symbol_name(char *s, char **result)

Same here.

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

[...]
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

I wonder if 'break;' instead of 'goto out;' would generate 
different/better/more readable code. Anyway out label is not necessary and 
we can achieve the same with break. It is up to you though.

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

Same thing with break instead of all gotos.

Thanks,
Miroslav
