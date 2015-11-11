From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [RFC PATCH 2/5] module: save load_info for livepatch modules
Date: Wed, 11 Nov 2015 15:17:15 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511111505300.12467@pobox.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com> <1447130755-17383-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447130755-17383-3-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 9 Nov 2015, Jessica Yu wrote:

> diff --git a/include/linux/module.h b/include/linux/module.h
> index 3a19c79..c8680b1 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h

[...]

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

apply_relocate_add() is already in include/linux/moduleloader.h (guarded 
by CONFIG_MODULES_USE_ELF_RELA), so maybe we can just include that where 
we need it. As for the klp_prepare_patch_module() wouldn't it be better to 
have it in our livepatch.h and include that in kernel/module.c?

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

What about arch-specific 'struct mod_arch_specific'? We need to preserve 
it somewhere as well for s390x and other non-x86 architectures.

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

Maybe I am missing something but isn't it necessary to call vfree() on 
info somewhere in the end?

Regards,
Miroslav
