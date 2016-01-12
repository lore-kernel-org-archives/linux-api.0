From: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH v3 4/6] livepatch: reuse module loader code to write
 relocations
Date: Tue, 12 Jan 2016 17:40:06 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1601121729480.15984@pobox.suse.cz>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com> <1452281304-28618-5-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452281304-28618-5-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Hi Jessica,

I walked through the series and it looks really nice. Others have already 
pointed out the issues I also found, so only few minor things below.

First thing, could you copy&paste the information and reasoning from the 
cover letter to the changelogs where appropriate? It is very detailed and 
it would be a pity to lost it.

On Fri, 8 Jan 2016, Jessica Yu wrote:

> diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
> index 19c099a..7312e25 100644
> --- a/arch/x86/include/asm/livepatch.h
> +++ b/arch/x86/include/asm/livepatch.h
> @@ -33,8 +33,6 @@ static inline int klp_check_compiler_support(void)
>  #endif
>  	return 0;
>  }
> -int klp_write_module_reloc(struct module *mod, unsigned long type,
> -			   unsigned long loc, unsigned long value);

You left klp_write_module_reloc() in arch/s390/include/asm/livepatch.h I'm 
afraid. Anyway it would be really great if you managed to test the series 
on s390 somehow. Just to know that all the roadblocks are really gone.

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

Maybe it would be better to use pmod->symtab and pmod->strtab everywhere. 
It should be the same, but core_* versions are only helpers used in 
load_module and friends. There is even a comment in 
include/linux/module.h.

	/*
	 * We keep the symbol and string tables for kallsyms.
	 * The core_* fields below are temporary, loader-only (they
	 * could really be discarded after module init).
	 */

We should respect that.

Thanks,
Miroslav
