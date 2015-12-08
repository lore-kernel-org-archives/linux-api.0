From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC PATCH v2 2/6] module: preserve Elf information for
 livepatch modules
Date: Tue, 8 Dec 2015 12:32:12 -0600
Message-ID: <20151208183212.GB14846@treble.redhat.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448943679-3412-3-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 30, 2015 at 11:21:15PM -0500, Jessica Yu wrote:
> For livepatch modules, copy Elf section, symbol, and string information
> from the load_info struct in the module loader.
> 
> Livepatch uses special relocation sections in order to be able to patch
> modules that are not yet loaded, as well as apply patches to the kernel
> when the addresses of symbols cannot be determined at compile time (for
> example, when kaslr is enabled). Livepatch modules must preserve Elf
> information such as section indices in order to apply the remaining
> relocation sections at the appropriate time (i.e. when the target module
> loads).
> 
> Signed-off-by: Jessica Yu <jeyu@redhat.com>
> ---
>  include/linux/module.h |  9 +++++
>  kernel/module.c        | 98 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 105 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 3a19c79..9b46256 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -425,6 +425,14 @@ struct module {
>  
>  	/* Notes attributes */
>  	struct module_notes_attrs *notes_attrs;
> +
> +	/* Elf information (optionally saved) */
> +	Elf_Ehdr *hdr;

I would rename "hdr" to "elf_hdr" to make its purpose clearer.

> +	Elf_Shdr *sechdrs;
> +	char *secstrings;

Probably a good idea to add underscores to the names ("sec_hdrs" and
"sec_strings") to be consistent with most of the other fields in the
struct.

> +	struct {
> +		unsigned int sym, str, mod, vers, info, pcpu;
> +	} index;

I might be contradicting myself from what I said before.  But I'm
thinking we should put all these fields inside a CONFIG_LIVEPATCH ifdef.
Then below, there could be two versions of copy_module_elf(), the real
one for LIVEPATCH and and an empty one for !LIVEPATCH.  And the same
story for free_module_elf().

>  #endif
>  
>  	/* The command line arguments (may be mangled).  People like
> @@ -461,6 +469,7 @@ struct module {
>  #endif
>  
>  #ifdef CONFIG_LIVEPATCH
> +	bool klp; /* Is this a livepatch module? */
>  	bool klp_alive;
>  #endif
>  
> diff --git a/kernel/module.c b/kernel/module.c
> index 8f051a1..433c2d6 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1984,6 +1984,13 @@ static void unset_module_core_ro_nx(struct module *mod) { }
>  static void unset_module_init_ro_nx(struct module *mod) { }
>  #endif
>  
> +static void free_module_elf(struct module *mod)
> +{
> +	kfree(mod->hdr);
> +	kfree(mod->sechdrs);
> +	kfree(mod->secstrings);
> +}
> +
>  void __weak module_memfree(void *module_region)
>  {
>  	vfree(module_region);
> @@ -2022,6 +2029,9 @@ static void free_module(struct module *mod)
>  	/* Free any allocated parameters. */
>  	destroy_params(mod->kp, mod->num_kp);
>  
> +	/* Free Elf information if it was saved */
> +	free_module_elf(mod);
> +
>  	/* Now we can delete it from the lists */
>  	mutex_lock(&module_mutex);
>  	/* Unlink carefully: kallsyms could be walking list. */
> @@ -2137,6 +2147,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  			       (long)sym[i].st_value);
>  			break;
>  
> +		case SHN_LIVEPATCH:
> +			/* klp symbols are resolved by livepatch */
> +			break;
> +
>  		case SHN_UNDEF:
>  			ksym = resolve_symbol_wait(mod, info, name);
>  			/* Ok if resolved.  */
> @@ -2185,6 +2199,10 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
>  		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
>  			continue;
>  
> +		/* klp relocation sections are applied by livepatch */
> +		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
> +			continue;
> +
>  		if (info->sechdrs[i].sh_type == SHT_REL)
>  			err = apply_relocate(info->sechdrs, info->strtab,
>  					     info->index.sym, i, mod);
> @@ -2393,6 +2411,11 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
>  {
>  	const Elf_Shdr *sechdrs = info->sechdrs;
>  
> +	if (ELF_ST_BIND(sym->st_info) == STB_LIVEPATCH_EXT)
> +		return 'K';
> +	if (sym->st_shndx == SHN_LIVEPATCH)
> +		return 'k';
> +
>  	if (ELF_ST_BIND(sym->st_info) == STB_WEAK) {
>  		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT)
>  			return 'v';
> @@ -2475,7 +2498,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
>  
>  	/* Compute total space required for the core symbols' strtab. */
>  	for (ndst = i = 0; i < nsrc; i++) {
> -		if (i == 0 ||
> +		if (i == 0 || mod->klp ||
>  		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
>  			strtab_size += strlen(&info->strtab[src[i].st_name])+1;
>  			ndst++;

Instead of accessing mod->klp directly, how about an
'is_livepatch_module(mod)' function.  There could be two versions, with
the !LIVEPATCH version always returning false and the LIVEPATCH version
checking mod->klp.  Then mod->klp itself can stay inside the LIVEPATCH
ifdef in the module struct.

> @@ -2517,7 +2540,7 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
>  	mod->core_strtab = s = mod->module_core + info->stroffs;
>  	src = mod->symtab;
>  	for (ndst = i = 0; i < mod->num_symtab; i++) {
> -		if (i == 0 ||
> +		if (i == 0 || mod->klp ||
>  		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
>  			dst[ndst] = src[i];
>  			dst[ndst++].st_name = s - mod->core_strtab;
> @@ -2638,6 +2661,64 @@ static int elf_header_check(struct load_info *info)
>  	return 0;
>  }
>  
> +/*
> + * copy_module_elf - preserve Elf information about a module
> + */
> +static int copy_module_elf(struct module *mod, struct load_info *info)
> +{
> +	unsigned int size;
> +	int ret = 0;

No need to initialize ret to zero here since it's never used
uninitalized.

> +	Elf_Shdr *symsect;
> +
> +	/* Elf header */
> +	size = sizeof(Elf_Ehdr);
> +	mod->hdr = kzalloc(size, GFP_KERNEL);

No need to zero the memory here with kzalloc() since it will all be
memcpy()'d anyway.  kmalloc() can be used instead (and the same for the
other kzalloc()s below).

> +	if (mod->hdr == NULL) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	memcpy(mod->hdr, info->hdr, size);
> +
> +	/* Elf section header table */
> +	size = sizeof(Elf_Shdr) * info->hdr->e_shnum;
> +	mod->sechdrs = kzalloc(size, GFP_KERNEL);
> +	if (mod->sechdrs == NULL) {
> +		ret = -ENOMEM;
> +		goto free_hdr;
> +	}
> +	memcpy(mod->sechdrs, info->sechdrs, size);
> +
> +	/* Elf section name string table */
> +	size = info->sechdrs[info->hdr->e_shstrndx].sh_size;
> +	mod->secstrings = kzalloc(size, GFP_KERNEL);
> +	if (mod->secstrings == NULL) {
> +		ret = -ENOMEM;
> +		goto free_sechdrs;
> +	}
> +	memcpy(mod->secstrings, info->secstrings, size);
> +
> +	/* Elf section indices */
> +	memcpy(&mod->index, &info->index, sizeof(info->index));
> +
> +	/*
> +	 * Update symtab's sh_addr to point to a valid
> +	 * symbol table, as the temporary symtab in module
> +	 * init memory will be freed
> +	 */
> +	symsect = mod->sechdrs + mod->index.sym;
> +	symsect->sh_addr = (unsigned long)mod->core_symtab;
> +
> +	return ret;
> +
> +free_sechdrs:
> +	kfree(mod->sechdrs);
> +free_hdr:
> +	kfree(mod->hdr);
> +out:
> +	return ret;
> +}
> +
> +
>  #define COPY_CHUNK_SIZE (16*PAGE_SIZE)
>  
>  static int copy_chunked_from_user(void *dst, const void __user *usrc, unsigned long len)
> @@ -2866,6 +2947,9 @@ static int check_modinfo(struct module *mod, struct load_info *info, int flags)
>  			"is unknown, you have been warned.\n", mod->name);
>  	}
>  
> +	if (get_modinfo(info, "livepatch"))
> +		mod->klp = true;
> +

Similar to the is_livepatch_module() function I suggested, this can be
put in a function so that mod->klp can be abstracted away for the
!LIVEPATCH case.  Maybe there should be a check_livepatch_modinfo()
function:

1. the !LIVEPATCH version of the function could return an error if
modinfo has "livepatch"

2. the LIVEPATCH version could simply set mod->klp = true.

>  	/* Set up license info based on the info section */
>  	set_license(mod, get_modinfo(info, "license"));
>  
> @@ -3530,6 +3614,16 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	if (err < 0)
>  		goto bug_cleanup;
>  
> +	/*
> +	 * Save sechdrs, indices, and other data from info
> +	 * in order to patch to-be-loaded modules.
> +	 * Do not call free_copy() for livepatch modules.

I think the last line of this comment isn't right, since free_copy() is
called below regardless.

> +	 */
> +	if (mod->klp)
> +		err = copy_module_elf(mod, info);
> +	if (err < 0)
> +		goto bug_cleanup;

Not strictly necessary, but I think it would be a little cleaner to only
check the err if copy_module_elf() was called.

> +
>  	/* Get rid of temporary copy. */
>  	free_copy(info);

-- 
Josh
