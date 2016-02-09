From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH v4 2/6] module: preserve Elf information for
 livepatch modules
Date: Tue, 9 Feb 2016 09:44:43 +0100
Message-ID: <20160209084443.GA12548@pathway.suse.cz>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
 <1454548271-24923-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454548271-24923-3-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 2016-02-03 20:11:07, Jessica Yu wrote:
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
> diff --git a/kernel/module.c b/kernel/module.c
> index 71c77ed..9c16eb2 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3222,6 +3331,12 @@ static noinline int do_init_module(struct module *mod)
>  	 */
>  	current->flags &= ~PF_USED_ASYNC;
>  
> +#ifdef CONFIG_KALLSYMS
> +	/* Make symtab and strtab available prior to module init call */
> +	mod->num_symtab = mod->core_num_syms;
> +	mod->symtab = mod->core_symtab;
> +	mod->strtab = mod->core_strtab;
> +#endif

This should be done with module_mutex. Otherwise, it looks racy
at least against module_kallsyms_on_each_symbol().

BTW: I wonder why even the original code is not racy
for example against module_get_kallsym. It is called
without the mutex. This code sets the number of entries
before the pointer to the entries.

Note that the module is in the list even in the UNFORMED state.


>  	do_mod_ctors(mod);
>  	/* Start the module */
>  	if (mod->init != NULL)
> @@ -3266,11 +3381,6 @@ static noinline int do_init_module(struct module *mod)
>  	/* Drop initial reference. */
>  	module_put(mod);
>  	trim_init_extable(mod);
> -#ifdef CONFIG_KALLSYMS
> -	mod->num_symtab = mod->core_num_syms;
> -	mod->symtab = mod->core_symtab;
> -	mod->strtab = mod->core_strtab;
> -#endif
>  	mod_tree_remove_init(mod);
>  	disable_ro_nx(&mod->init_layout);
>  	module_arch_freeing_init(mod);

In each case, it was called with the mutex here.

Best Regards,
Petr
