From: Jessica Yu <jeyu@redhat.com>
Subject: Re: module: save load_info for livepatch modules
Date: Thu, 12 Nov 2015 00:33:12 -0500
Message-ID: <20151112053228.GD30025@packer-debian-8-amd64.digitalocean.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-3-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1511111505300.12467@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1511111505300.12467@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Miroslav Benes <mbenes@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Miroslav Benes [11/11/15 15:17 +0100]:
>On Mon, 9 Nov 2015, Jessica Yu wrote:
>
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index 3a19c79..c8680b1 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>
>[...]
>
>> +#ifdef CONFIG_LIVEPATCH
>> +extern void klp_prepare_patch_module(struct module *mod,
>> +				     struct load_info *info);
>> +extern int
>> +apply_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
>> +		   unsigned int symindex, unsigned int relsec,
>> +		   struct module *me);
>> +#endif
>> +
>>  #else /* !CONFIG_MODULES... */
>
>apply_relocate_add() is already in include/linux/moduleloader.h (guarded
>by CONFIG_MODULES_USE_ELF_RELA), so maybe we can just include that where
>we need it. As for the klp_prepare_patch_module() wouldn't it be better to
>have it in our livepatch.h and include that in kernel/module.c?

Yeah, Petr pointed this out as well :-) I will just include
moduleloader.h for the apply_relocate_add() declaration.

It also looks like we have some disagreement over where to put
klp_prepare_patch_module(), either in livepatch/core.c (and add the
function declaration in livepatch.h, and have module.c include
livepatch.h) or in kernel/module.c, keeping the
klp_prepare_patch_module() declaration in module.h. Maybe Rusty can
provide some input.

>>  /* Given an address, look for it in the exception tables. */
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index 6e53441..087a8c7 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -1001,6 +1001,23 @@ static struct notifier_block klp_module_nb = {
>>  	.priority = INT_MIN+1, /* called late but before ftrace notifier */
>>  };
>>
>> +/*
>> + * Save necessary information from info in order to be able to
>> + * patch modules that might be loaded later
>> + */
>> +void klp_prepare_patch_module(struct module *mod, struct load_info *info)
>> +{
>> +	Elf_Shdr *symsect;
>> +
>> +	symsect = info->sechdrs + info->index.sym;
>> +	/* update sh_addr to point to symtab */
>> +	symsect->sh_addr = (unsigned long)info->hdr + symsect->sh_offset;
>> +
>> +	mod->info = kzalloc(sizeof(*info), GFP_KERNEL);
>> +	memcpy(mod->info, info, sizeof(*info));
>> +
>> +}
>
>What about arch-specific 'struct mod_arch_specific'? We need to preserve
>it somewhere as well for s390x and other non-x86 architectures.

Ah! Thank you for catching this, I overlooked this important detail.
Yes, we do need to save the arch-specific struct. We would be in
trouble for s390 relocs if we didn't. I am trying to think of a way to
save this information for s390, since s390's module_finalize() frees
mod->arch.syminfo, which we definitely need in order for the call to
apply_relocate_add() to work. Maybe we can add an extra call right
before module_finalize() that will do some livepatch-specific
processing and copy this information (this would be in
post_relocation() in kernel/module.c). Perhaps this patchset cannot be
entirely free of arch-specific code after all :-( Still thinking.

>> +#ifdef CONFIG_LIVEPATCH
>> +	/*
>> +	 * Save sechdrs, indices, and other data from info
>> +	 * in order to patch to-be-loaded modules.
>> +	 * Do not call free_copy() for livepatch modules.
>> +	 */
>> +	if (get_modinfo((struct load_info *)info, "livepatch"))
>> +		klp_prepare_patch_module(mod, info);
>> +	else
>> +		free_copy(info);
>> +#else
>>  	/* Get rid of temporary copy. */
>>  	free_copy(info);
>> +#endif
>
>Maybe I am missing something but isn't it necessary to call vfree() on
>info somewhere in the end?

So free_copy() will call vfree(info->hdr), except in livepatch modules
we want to keep all the elf section information stored there, so we
avoid calling free_copy(), As for the info struct itself, if you look
at the init_module and finit_module syscall definitions in
kernel/module.c, you will see that info is actually a local function
variable, simply passed in to the call to load_module(), and will be
automatically deallocated when the syscall returns. :-) No need to
explicitly free info.

Thanks for the comments,
Jessica
