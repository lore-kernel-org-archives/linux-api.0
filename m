From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 2/6] module: preserve Elf information for livepatch
 modules
Date: Mon, 21 Mar 2016 17:50:42 +0100
Message-ID: <20160321165042.GH19401@pathway.suse.cz>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
 <1458157628-8264-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458157628-8264-3-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 2016-03-16 15:47:04, Jessica Yu wrote:
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
> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1971,6 +1971,82 @@ static void module_enable_nx(const struct module *mod) { }
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
> +	size = sizeof(Elf_Ehdr);

It seems that you are going to do one more respin. Please, use
the size of the struct member here:

	size = sizeof(mod->klp_info->hdr);

> +	memcpy(&mod->klp_info->hdr, info->hdr, size);
> +
> +	/* Elf section header table */
> +	size = sizeof(Elf_Shdr) * info->hdr->e_shnum;

and here

    size = sizeof(*info->sechdrs) * info->hdr->e_shnum;

> +	mod->klp_info->sechdrs = kmalloc(size, GFP_KERNEL);
> +	if (mod->klp_info->sechdrs == NULL) {
> +		ret = -ENOMEM;
> +		goto free_info;
> +	}
> +	memcpy(mod->klp_info->sechdrs, info->sechdrs, size);

Best Regards,
Petr
