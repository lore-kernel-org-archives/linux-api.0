From: Jessica Yu <jeyu@redhat.com>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Wed, 13 Jan 2016 22:49:33 -0500
Message-ID: <20160114034933.GB980@packer-debian-8-amd64.digitalocean.com>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
 <1452281304-28618-5-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1601121729480.15984@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1601121729480.15984@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Miroslav Benes <mbenes@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Miroslav Benes [12/01/16 17:40 +0100]:
>
>Hi Jessica,
>
>I walked through the series and it looks really nice. Others have already
>pointed out the issues I also found, so only few minor things below.
>
>First thing, could you copy&paste the information and reasoning from the
>cover letter to the changelogs where appropriate? It is very detailed and
>it would be a pity to lost it.

Thanks Miroslav! I'll do that.

>On Fri, 8 Jan 2016, Jessica Yu wrote:
>
>> diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
>> index 19c099a..7312e25 100644
>> --- a/arch/x86/include/asm/livepatch.h
>> +++ b/arch/x86/include/asm/livepatch.h
>> @@ -33,8 +33,6 @@ static inline int klp_check_compiler_support(void)
>>  #endif
>>  	return 0;
>>  }
>> -int klp_write_module_reloc(struct module *mod, unsigned long type,
>> -			   unsigned long loc, unsigned long value);
>
>You left klp_write_module_reloc() in arch/s390/include/asm/livepatch.h I'm
>afraid. Anyway it would be really great if you managed to test the series
>on s390 somehow. Just to know that all the roadblocks are really gone.

Ah, thanks for catching that. I will also try testing the patchset on
s390x and report back.

>> -/*
>> - * external symbols are located outside the parent object (where the parent
>> - * object is either vmlinux or the kmod being patched).
>> - */
>> -static int klp_find_external_symbol(struct module *pmod, const char *name,
>> -				    unsigned long *addr)
>> +static int klp_resolve_symbols(Elf_Shdr *relsec, struct module *pmod)
>>  {
>> -	const struct kernel_symbol *sym;
>> +	int i, len, ret = 0;
>> +	Elf_Rela *relas;
>> +	Elf_Sym *sym;
>> +	char *symname, *sym_objname;
>>
>> -	/* first, check if it's an exported symbol */
>> -	preempt_disable();
>> -	sym = find_symbol(name, NULL, NULL, true, true);
>> -	if (sym) {
>> -		*addr = sym->value;
>> -		preempt_enable();
>> -		return 0;
>> +	relas = (Elf_Rela *) relsec->sh_addr;
>> +	/* For each rela in this .klp.rel. section */
>> +	for (i = 0; i < relsec->sh_size / sizeof(Elf_Rela); i++) {
>> +		sym = pmod->core_symtab + ELF_R_SYM(relas[i].r_info);
>> +		symname = pmod->core_strtab + sym->st_name;
>
>Maybe it would be better to use pmod->symtab and pmod->strtab everywhere.
>It should be the same, but core_* versions are only helpers used in
>load_module and friends. There is even a comment in
>include/linux/module.h.
>
>	/*
>	 * We keep the symbol and string tables for kallsyms.
>	 * The core_* fields below are temporary, loader-only (they
>	 * could really be discarded after module init).
>	 */
>
>We should respect that.

I admit I'm a bit confused by the comment, I can't seem to find where
core_symtab and core_strtab are purportedly discarded after module
init (perhaps I'm missing something?). IMO it sounds more like it's
describing mod->symtab and mod->strtab instead, because these are in
module init memory and are freed later. In any case, my reason for using
core_symtab is that the original symbol table (mod->symtab) is marked
with INIT_OFFSET_MASK in layout_symtab() (see kernel/module.c), and is
therefore in init memory. This memory is freed near the end of
do_init_module() with do_free_init(). Since core_symtab is in module core
memory, for livepatch modules I simply used core_symtab to hold a
full copy of the symbol table instead of the slimmed down version that
it was originally intended to hold.

Alternatively, we can tweak layout_symtab() to *not* mark the symtab
with INIT_OFFSET_MASK and put it in core memory instead. I think
either way will work, but maybe it is cleaner to do it this way
instead.

Jessica
