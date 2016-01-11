From: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Subject: Re: [RFC PATCH v3 2/6] module: preserve Elf information for livepatch modules
Date: Mon, 11 Jan 2016 11:55:04 +1030
Message-ID: <87oacshpqn.fsf@rustcorp.com.au>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com> <1452281304-28618-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452281304-28618-3-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Jessica,

        Nice patch series.  Minor issues below, but they're really
just nits which can be patched afterwards if you're getting sick of
rebasing :)

> +#ifdef CONFIG_LIVEPATCH
> +/*
> + * copy_module_elf - preserve Elf information about a module
> + *
> + * Copy relevant Elf information from the load_info struct.
> + * Note: not all fields from the original load_info are
> + * copied into mod->info.

This makes me nervous, to have a struct which is half-initialized.

Better would be to have a separate type for this, eg:

struct livepatch_modinfo {
        Elf_Ehdr hdr;
        Elf_Shdr *sechdrs;
        char *secstrings;
        /* FIXME: Which of these do you need? */
        struct {
        	unsigned int sym, str, mod, vers, info, pcpu;
        } index;
};

This also avoids an extra allocation as hdr is no longer a ptr.

> +	/*
> +	 * Update symtab's sh_addr to point to a valid
> +	 * symbol table, as the temporary symtab in module
> +	 * init memory will be freed
> +	 */
> +	mod->info->sechdrs[mod->info->index.sym].sh_addr = (unsigned long)mod->core_symtab;

This comment is a bit misleading: it's actually pointing into the
temporary module copy, which will be discarded.  The init section is
slightly different...

> +#ifdef CONFIG_LIVEPATCH
> +static int check_livepatch_modinfo(struct module *mod, struct load_info *info)
> +{
> +	mod->klp = get_modinfo(info, "livepatch") ? true : false;
> +
> +	return 0;
> +}
> +#else
> +static int check_livepatch_modinfo(struct module *mod, struct load_info *info)
> +{
> +	if (get_modinfo(info, "livepatch"))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +#endif

The term "check" implies no side-effects; I'd usually call this
int find_livepatch_modinfo(), and make sure you use the error code in
the caller:

> +	err = check_livepatch_modinfo(mod, info);
> +	if (err)
> +		return -ENOEXEC;
> +

Thanks,
Rusty.
