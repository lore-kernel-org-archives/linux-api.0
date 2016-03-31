From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v6 2/5] module: preserve Elf information for livepatch modules
Date: Fri, 01 Apr 2016 09:47:37 +1030
Message-ID: <87zite8cfi.fsf@rustcorp.com.au>
References: <1458691399-20078-1-git-send-email-jeyu@redhat.com> <1458691399-20078-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458691399-20078-3-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org, Jessica Yu <jeyu@redhat.com>
List-Id: linux-api@vger.kernel.org

Jessica Yu <jeyu@redhat.com> writes:
> For livepatch modules, copy Elf section, symbol, and string information
> from the load_info struct in the module loader. Persist copies of the
> original symbol table and string table.
>
> Livepatch manages its own relocation sections in order to reuse module
> loader code to write relocations. Livepatch modules must preserve Elf
> information such as section indices in order to apply livepatch relocation
> sections using the module loader's apply_relocate_add() function.
>
> In order to apply livepatch relocation sections, livepatch modules must
> keep a complete copy of their original symbol table in memory. Normally, a
> stripped down copy of a module's symbol table (containing only "core"
> symbols) is made available through module->core_symtab. But for livepatch
> modules, the symbol table copied into memory on module load must be exactly
> the same as the symbol table produced when the patch module was compiled.
> This is because the relocations in each livepatch relocation section refer
> to their respective symbols with their symbol indices, and the original
> symbol indices (and thus the symtab ordering) must be preserved in order
> for apply_relocate_add() to find the right symbol.
>
> Signed-off-by: Jessica Yu <jeyu@redhat.com>
> Reviewed-by: Miroslav Benes <mbenes@suse.cz>
> ---
>  include/linux/module.h |  25 ++++++++++
>  kernel/module.c        | 125 +++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 147 insertions(+), 3 deletions(-)

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

(I guess that takes precedence over "Reviewed-by", which I did too).

Thanks,
Rusty.

> diff --git a/include/linux/module.h b/include/linux/module.h
> index 2bb0c30..3daf2b3 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -330,6 +330,15 @@ struct mod_kallsyms {
>  	char *strtab;
>  };
>  
> +#ifdef CONFIG_LIVEPATCH
> +struct klp_modinfo {
> +	Elf_Ehdr hdr;
> +	Elf_Shdr *sechdrs;
> +	char *secstrings;
> +	unsigned int symndx;
> +};
> +#endif
> +
>  struct module {
>  	enum module_state state;
>  
> @@ -456,7 +465,11 @@ struct module {
>  #endif
>  
>  #ifdef CONFIG_LIVEPATCH
> +	bool klp; /* Is this a livepatch module? */
>  	bool klp_alive;
> +
> +	/* Elf information */
> +	struct klp_modinfo *klp_info;
>  #endif
>  
>  #ifdef CONFIG_MODULE_UNLOAD
> @@ -630,6 +643,18 @@ static inline bool module_requested_async_probing(struct module *module)
>  	return module && module->async_probe_requested;
>  }
>  
> +#ifdef CONFIG_LIVEPATCH
> +static inline bool is_livepatch_module(struct module *mod)
> +{
> +	return mod->klp;
> +}
> +#else /* !CONFIG_LIVEPATCH */
> +static inline bool is_livepatch_module(struct module *mod)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_LIVEPATCH */
> +
>  #else /* !CONFIG_MODULES... */
>  
>  /* Given an address, look for it in the exception tables. */
> diff --git a/kernel/module.c b/kernel/module.c
> index 041200c..5f71aa6 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1973,6 +1973,83 @@ static void module_enable_nx(const struct module *mod) { }
>  static void module_disable_nx(const struct module *mod) { }
>  #endif
>  
> +#ifdef CONFIG_LIVEPATCH
> +/*
> + * Persist Elf information about a module. Copy the Elf header,
> + * section header table, section string table, and symtab section
> + * index from info to mod->klp_info.
> + */
> +static int copy_module_elf(struct module *mod, struct load_info *info)
> +{
> +	unsigned int size, symndx;
> +	int ret;
> +
> +	size = sizeof(*mod->klp_info);
> +	mod->klp_info = kmalloc(size, GFP_KERNEL);
> +	if (mod->klp_info == NULL)
> +		return -ENOMEM;
> +
> +	/* Elf header */
> +	size = sizeof(mod->klp_info->hdr);
> +	memcpy(&mod->klp_info->hdr, info->hdr, size);
> +
> +	/* Elf section header table */
> +	size = sizeof(*info->sechdrs) * info->hdr->e_shnum;
> +	mod->klp_info->sechdrs = kmalloc(size, GFP_KERNEL);
> +	if (mod->klp_info->sechdrs == NULL) {
> +		ret = -ENOMEM;
> +		goto free_info;
> +	}
> +	memcpy(mod->klp_info->sechdrs, info->sechdrs, size);
> +
> +	/* Elf section name string table */
> +	size = info->sechdrs[info->hdr->e_shstrndx].sh_size;
> +	mod->klp_info->secstrings = kmalloc(size, GFP_KERNEL);
> +	if (mod->klp_info->secstrings == NULL) {
> +		ret = -ENOMEM;
> +		goto free_sechdrs;
> +	}
> +	memcpy(mod->klp_info->secstrings, info->secstrings, size);
> +
> +	/* Elf symbol section index */
> +	symndx = info->index.sym;
> +	mod->klp_info->symndx = symndx;
> +
> +	/*
> +	 * For livepatch modules, core_kallsyms.symtab is a complete
> +	 * copy of the original symbol table. Adjust sh_addr to point
> +	 * to core_kallsyms.symtab since the copy of the symtab in module
> +	 * init memory is freed at the end of do_init_module().
> +	 */
> +	mod->klp_info->sechdrs[symndx].sh_addr = \
> +		(unsigned long) mod->core_kallsyms.symtab;
> +
> +	return 0;
> +
> +free_sechdrs:
> +	kfree(mod->klp_info->sechdrs);
> +free_info:
> +	kfree(mod->klp_info);
> +	return ret;
> +}
> +
> +static void free_module_elf(struct module *mod)
> +{
> +	kfree(mod->klp_info->sechdrs);
> +	kfree(mod->klp_info->secstrings);
> +	kfree(mod->klp_info);
> +}
> +#else /* !CONFIG_LIVEPATCH */
> +static int copy_module_elf(struct module *mod, struct load_info *info)
> +{
> +	return 0;
> +}
> +
> +static void free_module_elf(struct module *mod)
> +{
> +}
> +#endif /* CONFIG_LIVEPATCH */
> +
>  void __weak module_memfree(void *module_region)
>  {
>  	vfree(module_region);
> @@ -2011,6 +2088,9 @@ static void free_module(struct module *mod)
>  	/* Free any allocated parameters. */
>  	destroy_params(mod->kp, mod->num_kp);
>  
> +	if (is_livepatch_module(mod))
> +		free_module_elf(mod);
> +
>  	/* Now we can delete it from the lists */
>  	mutex_lock(&module_mutex);
>  	/* Unlink carefully: kallsyms could be walking list. */
> @@ -2126,6 +2206,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  			       (long)sym[i].st_value);
>  			break;
>  
> +		case SHN_LIVEPATCH:
> +			/* Livepatch symbols are resolved by livepatch */
> +			break;
> +
>  		case SHN_UNDEF:
>  			ksym = resolve_symbol_wait(mod, info, name);
>  			/* Ok if resolved.  */
> @@ -2174,6 +2258,10 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
>  		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
>  			continue;
>  
> +		/* Livepatch relocation sections are applied by livepatch */
> +		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
> +			continue;
> +
>  		if (info->sechdrs[i].sh_type == SHT_REL)
>  			err = apply_relocate(info->sechdrs, info->strtab,
>  					     info->index.sym, i, mod);
> @@ -2469,7 +2557,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
>  
>  	/* Compute total space required for the core symbols' strtab. */
>  	for (ndst = i = 0; i < nsrc; i++) {
> -		if (i == 0 ||
> +		if (i == 0 || is_livepatch_module(mod) ||
>  		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum,
>  				   info->index.pcpu)) {
>  			strtab_size += strlen(&info->strtab[src[i].st_name])+1;
> @@ -2528,7 +2616,7 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
>  	mod->core_kallsyms.strtab = s = mod->core_layout.base + info->stroffs;
>  	src = mod->kallsyms->symtab;
>  	for (ndst = i = 0; i < mod->kallsyms->num_symtab; i++) {
> -		if (i == 0 ||
> +		if (i == 0 || is_livepatch_module(mod) ||
>  		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum,
>  				   info->index.pcpu)) {
>  			dst[ndst] = src[i];
> @@ -2667,6 +2755,26 @@ static int copy_chunked_from_user(void *dst, const void __user *usrc, unsigned l
>  	return 0;
>  }
>  
> +#ifdef CONFIG_LIVEPATCH
> +static int find_livepatch_modinfo(struct module *mod, struct load_info *info)
> +{
> +	mod->klp = get_modinfo(info, "livepatch") ? true : false;
> +
> +	return 0;
> +}
> +#else /* !CONFIG_LIVEPATCH */
> +static int find_livepatch_modinfo(struct module *mod, struct load_info *info)
> +{
> +	if (get_modinfo(info, "livepatch")) {
> +		pr_err("%s: module is marked as livepatch module, but livepatch support is disabled",
> +		       mod->name);
> +		return -ENOEXEC;
> +	}
> +
> +	return 0;
> +}
> +#endif /* CONFIG_LIVEPATCH */
> +
>  /* Sets info->hdr and info->len. */
>  static int copy_module_from_user(const void __user *umod, unsigned long len,
>  				  struct load_info *info)
> @@ -2821,6 +2929,10 @@ static int check_modinfo(struct module *mod, struct load_info *info, int flags)
>  			"is unknown, you have been warned.\n", mod->name);
>  	}
>  
> +	err = find_livepatch_modinfo(mod, info);
> +	if (err)
> +		return err;
> +
>  	/* Set up license info based on the info section */
>  	set_license(mod, get_modinfo(info, "license"));
>  
> @@ -3494,6 +3606,12 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	if (err < 0)
>  		goto coming_cleanup;
>  
> +	if (is_livepatch_module(mod)) {
> +		err = copy_module_elf(mod, info);
> +		if (err < 0)
> +			goto sysfs_cleanup;
> +	}
> +
>  	/* Get rid of temporary copy. */
>  	free_copy(info);
>  
> @@ -3502,11 +3620,12 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  
>  	return do_init_module(mod);
>  
> + sysfs_cleanup:
> +	mod_sysfs_teardown(mod);
>   coming_cleanup:
>  	blocking_notifier_call_chain(&module_notify_list,
>  				     MODULE_STATE_GOING, mod);
>  	klp_module_going(mod);
> -
>   bug_cleanup:
>  	/* module_bug_cleanup needs module_mutex protection */
>  	mutex_lock(&module_mutex);
> -- 
> 2.4.3
