From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Wed, 11 Nov 2015 15:07:33 -0500
Message-ID: <20151111200732.GB30025@packer-debian-8-amd64.digitalocean.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-4-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1511111519250.12467@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1511111519250.12467-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Miroslav Benes [11/11/15 15:30 +0100]:
>On Mon, 9 Nov 2015, Jessica Yu wrote:
>
>> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>> index 31db7a0..601e892 100644
>> --- a/include/linux/livepatch.h
>> +++ b/include/linux/livepatch.h
>> @@ -85,7 +85,7 @@ struct klp_reloc {
>>  /**
>>   * struct klp_object - kernel object structure for live patching
>>   * @name:	module name (or NULL for vmlinux)
>> - * @relocs:	relocation entries to be applied at load time
>> + * @reloc_secs:	relocation sections to be applied at load time
>>   * @funcs:	function entries for functions to be patched in the object
>>   * @kobj:	kobject for sysfs resources
>>   * @mod:	kernel module associated with the patched object
>> @@ -95,7 +95,7 @@ struct klp_reloc {
>>  struct klp_object {
>>  	/* external */
>>  	const char *name;
>> -	struct klp_reloc *relocs;
>> +	struct list_head reloc_secs;
>>  	struct klp_func *funcs;
>
>So I guess we don't need klp_reloc anymore.

Yes, that's correct. I am noticing just now that I forgot to remove
the klp_reloc struct definition from livepatch.h. That change will be
reflected in v2...

>If true, we should really
>start thinking about proper documentation because there are going to be
>plenty of assumptions about a patch module and we need to have it written
>somewhere. Especially how the relocation sections look like.

Agreed. As a first step the patch module format can perhaps be
documented somewhere. Perhaps it's time we create
Documentation/livepatch/? :-)

>>  	/* internal */
>> @@ -129,6 +129,13 @@ struct klp_patch {
>>  #define klp_for_each_func(obj, func) \
>>  	for (func = obj->funcs; func->old_name; func++)
>>
>> +struct klp_reloc_sec {
>> +	unsigned int index;
>> +	char *name;
>> +	char *objname;
>> +	struct list_head list;
>> +};
>
>Description of the structure and its members is missing.
>
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index c8680b1..3c34eb8 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -793,9 +793,15 @@ extern int module_sysfs_initialized;
>>  #ifdef CONFIG_DEBUG_SET_MODULE_RONX
>>  extern void set_all_modules_text_rw(void);
>>  extern void set_all_modules_text_ro(void);
>> +extern void
>> +set_page_attributes(void *start, void *end,
>> +		    int (*set)(unsigned long start, int num_pages));
>>  #else
>>  static inline void set_all_modules_text_rw(void) { }
>>  static inline void set_all_modules_text_ro(void) { }
>> +static inline void
>> +set_page_attributes(void *start, void *end,
>> +		    int (*set)(unsigned long start, int num_pages)) { }
>>  #endif
>
>This would be solved after Rusty's and Josh's patches get merged, right?

Yes, correct. When Josh and Rusty's patches get merged, I'll base
subsequent versions of this patchset on them.

>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index 087a8c7..26c419f 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -28,6 +28,8 @@
>>  #include <linux/list.h>
>>  #include <linux/kallsyms.h>
>>  #include <linux/livepatch.h>
>> +#include <linux/elf.h>
>> +#include <asm/cacheflush.h>
>>
>>  /**
>>   * struct klp_ops - structure for tracking registered ftrace ops structs
>> @@ -281,46 +283,54 @@ static int klp_find_external_symbol(struct module *pmod, const char *name,
>>  }
>>
>>  static int klp_write_object_relocations(struct module *pmod,
>> -					struct klp_object *obj)
>> +					struct klp_object *obj,
>> +					struct klp_patch *patch)
>>  {
>> -	int ret;
>> -	struct klp_reloc *reloc;
>> +	int relindex, num_relas;
>> +	int i, ret = 0;
>> +	unsigned long addr;
>> +	unsigned int bind;
>> +	char *symname;
>> +	struct klp_reloc_sec *reloc_sec;
>> +	struct load_info *info;
>> +	Elf_Rela *rela;
>> +	Elf_Sym *sym, *symtab;
>> +	Elf_Shdr *symsect;
>>
>>  	if (WARN_ON(!klp_is_object_loaded(obj)))
>>  		return -EINVAL;
>>
>> -	if (WARN_ON(!obj->relocs))
>> -		return -EINVAL;
>> -
>> -	for (reloc = obj->relocs; reloc->name; reloc++) {
>> -		if (!klp_is_module(obj)) {
>> -			ret = klp_verify_vmlinux_symbol(reloc->name,
>> -							reloc->val);
>> -			if (ret)
>> -				return ret;
>> -		} else {
>> -			/* module, reloc->val needs to be discovered */
>> -			if (reloc->external)
>> -				ret = klp_find_external_symbol(pmod,
>> -							       reloc->name,
>> -							       &reloc->val);
>> -			else
>> -				ret = klp_find_object_symbol(obj->mod->name,
>> -							     reloc->name,
>> -							     &reloc->val);
>> -			if (ret)
>> -				return ret;
>> -		}
>> -		ret = klp_write_module_reloc(pmod, reloc->type, reloc->loc,
>> -					     reloc->val + reloc->addend);
>> -		if (ret) {
>> -			pr_err("relocation failed for symbol '%s' at 0x%016lx (%d)\n",
>> -			       reloc->name, reloc->val, ret);
>> -			return ret;
>> +	info = pmod->info;
>> +	symsect = info->sechdrs + info->index.sym;
>> +	symtab = (void *)info->hdr + symsect->sh_offset;
>> +
>> +	/* For each __klp_rela section for this object */
>> +	list_for_each_entry(reloc_sec, &obj->reloc_secs, list) {
>> +		relindex = reloc_sec->index;
>> +		num_relas = info->sechdrs[relindex].sh_size / sizeof(Elf_Rela);
>> +		rela = (Elf_Rela *) info->sechdrs[relindex].sh_addr;
>> +
>> +		/* For each rela in this __klp_rela section */
>> +		for (i = 0; i < num_relas; i++, rela++) {
>> +			sym = symtab + ELF_R_SYM(rela->r_info);
>> +			symname = info->strtab + sym->st_name;
>> +			bind = ELF_ST_BIND(sym->st_info);
>> +
>> +			if (sym->st_shndx == SHN_LIVEPATCH) {
>> +				if (bind == STB_LIVEPATCH_EXT)
>> +					ret = klp_find_external_symbol(pmod, symname, &addr);
>> +				else
>> +					ret = klp_find_object_symbol(obj->name, symname, &addr);
>> +				if (ret)
>> +					return ret;
>> +				sym->st_value = addr;
>> +			}
>>  		}
>> +		ret = apply_relocate_add(info->sechdrs, info->strtab,
>> +					 info->index.sym, relindex, pmod);
>>  	}
>>
>> -	return 0;
>> +	return ret;
>>  }
>
>Looking at this... do we even need reloc_secs in klp_object? Question is
>whether we need more than one dynrela section for an object. If not then
>the binding between klp_reloc_sec and an object is the only relevant thing
>in the structure, be it index or objname. So we can replace the
>list of structures with just the index in klp_object, or get rid of it
>completely and rely on the name of dynrela section be something like
>__klp_rela_{objname}.

Hm, you bring up a good point. I think theoretically yes, it is
possible to just have one klp_reloc_sec for each object and therefore
a list is not required (I have not checked yet how difficult it would
be to implement this on the kpatch-build side of things).  However,
considering the final format of the patch module, I think it is
semantically clearer to leave it as a list, and for each object to
possibly have more than one __klp_rela section.

For example, say we are patching two functions in ext4. In my
resulting kpatch module I will have two __klp_rela_ext4 sections, and
they might look like this when we run readelf --sections:

[34] __klp_rela_ext4.text.ext4_attr_store RELA ...
[35] __klp_rela_ext4.text.ext4_attr_show RELA ...

Then these two klp rela sections end up as two elements in the
reloc_secs list for the ext4 patch object. I think this way, we can
better tell which rela is being applied to what function. Might be
easier to understand what's happening from the developer's point of
view.

>You see, we go through elf sections here which were preserved by module
>loader. We even have relevant sections marked with SHF_RELA_LIVEPATCH. So
>maybe all the stuff around klp_reloc_sec is not necessary.
>
>Thoughts?

Ah, so this is where descriptive comments and documentation might have
been useful :-) So I think we will still need to keep the
klp_reloc_sec struct to help the patch module initialize. Though the
name and objname fields aren't used in this patchset, they are used in
the kpatch patch module code [1], where we iterate through each elf
section, find the ones marked with SHF_RELA_LIVEPATCH, set the
klp_reloc_sec's objname (which we find from the "name" field,
formatted as __klp_rela_{objname}.text..). Once we have the objname
set, we can then find the object to attach the reloc_sec to (i.e. add
it to its list of reloc_secs).

Hope that clears some things up.


[1] https://github.com/flaming-toast/kpatch/blob/no_dynrela_redux/kmod/patch/livepatch-patch-hook.c#L213

>> @@ -741,12 +751,23 @@ static int klp_init_object_loaded(struct klp_patch *patch,
>>  				  struct klp_object *obj)
>>  {
>>  	struct klp_func *func;
>> +	struct module *pmod;
>>  	int ret;
>>
>> -	if (obj->relocs) {
>> -		ret = klp_write_object_relocations(patch->mod, obj);
>> +	pmod = patch->mod;
>> +
>> +	if (!list_empty(&obj->reloc_secs)) {
>> +		set_page_attributes(pmod->module_core,
>> +				    pmod->module_core + pmod->core_text_size,
>> +				    set_memory_rw);
>> +
>> +		ret = klp_write_object_relocations(pmod, obj, patch);
>>  		if (ret)
>>  			return ret;
>> +
>> +		set_page_attributes(pmod->module_core,
>> +				    pmod->module_core + pmod->core_text_size,
>> +				    set_memory_ro);
>>  	}
>
>And this would get solved with different patches as well. I think the
>calls to set_page_attributes() should be hidden in
>klp_write_object_relocations() as it is in Josh's patch IIRC.

Yes, when those patches are merged I will switch over to Josh's
functions for setting/unsetting memory ro.

Thanks,
Jessica
