From: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 2/5] module: save load_info for livepatch modules
Date: Thu, 12 Nov 2015 11:21:59 -0600
Message-ID: <20151112172159.GF4038@treble.hsd1.ky.comcast.net>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447130755-17383-3-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 09, 2015 at 11:45:52PM -0500, Jessica Yu wrote:
> In livepatch modules, preserve section, symbol, string information from
> the load_info struct in the module loader. This information is used to
> patch modules that are not loaded in memory yet; specifically it is used
> to resolve remaining symbols and write relocations when the target
> module loads.
> 
> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/module.h  | 25 +++++++++++++++++++++++++
>  kernel/livepatch/core.c | 17 +++++++++++++++++
>  kernel/module.c         | 36 ++++++++++++++++++++++--------------
>  3 files changed, 64 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 3a19c79..c8680b1 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -36,6 +36,20 @@ struct modversion_info {
>  	char name[MODULE_NAME_LEN];
>  };
>  
> +struct load_info {
> +	Elf_Ehdr *hdr;
> +	unsigned long len;
> +	Elf_Shdr *sechdrs;
> +	char *secstrings, *strtab;
> +	unsigned long symoffs, stroffs;
> +	struct _ddebug *debug;
> +	unsigned int num_debug;
> +	bool sig_ok;
> +	struct {
> +		unsigned int sym, str, mod, vers, info, pcpu;
> +	} index;
> +};
> +
>  struct module;
>  
>  struct module_kobject {
> @@ -462,6 +476,8 @@ struct module {
>  
>  #ifdef CONFIG_LIVEPATCH
>  	bool klp_alive;
> +	/* save info to patch to-be-loaded modules */
> +	struct load_info *info;
>  #endif
>  
>  #ifdef CONFIG_MODULE_UNLOAD
> @@ -635,6 +651,15 @@ static inline bool module_requested_async_probing(struct module *module)
>  	return module && module->async_probe_requested;
>  }
>  
> +#ifdef CONFIG_LIVEPATCH
> +extern void klp_prepare_patch_module(struct module *mod,
> +				     struct load_info *info);
> +extern int
> +apply_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
> +		   unsigned int symindex, unsigned int relsec,
> +		   struct module *me);
> +#endif
> +
>  #else /* !CONFIG_MODULES... */
>  
>  /* Given an address, look for it in the exception tables. */
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 6e53441..087a8c7 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -1001,6 +1001,23 @@ static struct notifier_block klp_module_nb = {
>  	.priority = INT_MIN+1, /* called late but before ftrace notifier */
>  };
>  
> +/*
> + * Save necessary information from info in order to be able to
> + * patch modules that might be loaded later
> + */
> +void klp_prepare_patch_module(struct module *mod, struct load_info *info)
> +{
> +	Elf_Shdr *symsect;
> +
> +	symsect = info->sechdrs + info->index.sym;
> +	/* update sh_addr to point to symtab */
> +	symsect->sh_addr = (unsigned long)info->hdr + symsect->sh_offset;
> +
> +	mod->info = kzalloc(sizeof(*info), GFP_KERNEL);
> +	memcpy(mod->info, info, sizeof(*info));
> +
> +}
> +
>  static int __init klp_init(void)
>  {
>  	int ret;
> diff --git a/kernel/module.c b/kernel/module.c
> index 8f051a1..8ae3ca5 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -318,20 +318,6 @@ int unregister_module_notifier(struct notifier_block *nb)
>  }
>  EXPORT_SYMBOL(unregister_module_notifier);
>  
> -struct load_info {
> -	Elf_Ehdr *hdr;
> -	unsigned long len;
> -	Elf_Shdr *sechdrs;
> -	char *secstrings, *strtab;
> -	unsigned long symoffs, stroffs;
> -	struct _ddebug *debug;
> -	unsigned int num_debug;
> -	bool sig_ok;
> -	struct {
> -		unsigned int sym, str, mod, vers, info, pcpu;
> -	} index;
> -};
> -
>  /* We require a truly strong try_module_get(): 0 means failure due to
>     ongoing or failed initialization etc. */
>  static inline int strong_try_module_get(struct module *mod)
> @@ -2137,6 +2123,11 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  			       (long)sym[i].st_value);
>  			break;
>  
> +#ifdef CONFIG_LIVEPATCH
> +		case SHN_LIVEPATCH:
> +			break;
> +#endif
> +

It would be good to add a short comment here stating that livepatch
symbols are resolved later by the klp code.

>  		case SHN_UNDEF:
>  			ksym = resolve_symbol_wait(mod, info, name);
>  			/* Ok if resolved.  */
> @@ -2185,6 +2176,11 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
>  		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
>  			continue;
>  
> +#ifdef CONFIG_LIVEPATCH
> +		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
> +			continue;
> +#endif
> +

Same here, a short comment stating that livepatch relocations are
applied later by klp code.

>  		if (info->sechdrs[i].sh_type == SHT_REL)
>  			err = apply_relocate(info->sechdrs, info->strtab,
>  					     info->index.sym, i, mod);
> @@ -3530,8 +3526,20 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	if (err < 0)
>  		goto bug_cleanup;
>  
> +#ifdef CONFIG_LIVEPATCH
> +	/*
> +	 * Save sechdrs, indices, and other data from info
> +	 * in order to patch to-be-loaded modules.
> +	 * Do not call free_copy() for livepatch modules.
> +	 */
> +	if (get_modinfo((struct load_info *)info, "livepatch"))
> +		klp_prepare_patch_module(mod, info);
> +	else
> +		free_copy(info);
> +#else
>  	/* Get rid of temporary copy. */
>  	free_copy(info);
> +#endif
>  
>  	/* Done! */
>  	trace_module_load(mod);
> -- 
> 2.4.3
> 

-- 
Josh
