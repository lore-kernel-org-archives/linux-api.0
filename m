From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v5 4/6] livepatch: reuse module loader code to write
 relocations
Date: Mon, 21 Mar 2016 17:31:57 +0100
Message-ID: <20160321163157.GG19401@pathway.suse.cz>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
 <1458157628-8264-5-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458157628-8264-5-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 2016-03-16 15:47:06, Jessica Yu wrote:
> Reuse module loader code to write relocations, thereby eliminating the need
> for architecture specific relocation code in livepatch. Specifically, reuse
> the apply_relocate_add() function in the module loader to write relocations
> instead of duplicating functionality in livepatch's arch-dependent
> klp_write_module_reloc() function.
> 
> In order to accomplish this, livepatch modules manage their own relocation
> sections (marked with the SHF_RELA_LIVEPATCH section flag) and
> livepatch-specific symbols (marked with SHN_LIVEPATCH symbol section
> index). To apply livepatch relocation sections, livepatch symbols
> referenced by relocs are resolved and then apply_relocate_add() is called
> to apply those relocations.
> 
> In addition, remove x86 livepatch relocation code and the s390
> klp_write_module_reloc() function stub. They are no longer needed since
> relocation work has been offloaded to module loader.

Most of the problems were covered by Mirek and Josh. I agree with
them. Please read two more comments below.

> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 780f00c..2aa20fa 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
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

Note that MODULE_NAME_LEN even is not 64. It is defined by:

#define MAX_PARAM_PREFIX_LEN (64 - sizeof(unsigned long))

I strongly suggest to use the proposal from Josh.


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

[...]
> @@ -842,6 +867,9 @@ int klp_register_patch(struct klp_patch *patch)
>  {
>  	int ret;
>  
> +	if (!is_livepatch_module(patch->mod))
> +		return -EINVAL;
> +

This breaks bisectability if livepatch-sample is used. Please, merge
the 5th patch here or move it before this one.

Best Regards,
Petr
