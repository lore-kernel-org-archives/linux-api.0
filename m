From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: module: preserve Elf information for livepatch modules
Date: Tue, 22 Mar 2016 13:57:01 -0400
Message-ID: <20160322175700.GA30747@packer-debian-8-amd64.digitalocean.com>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
 <1458157628-8264-3-git-send-email-jeyu@redhat.com>
 <20160321140631.z6scycsxz6fhsjvg@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160321140631.z6scycsxz6fhsjvg-8wJ5/zUtDR0XGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Josh Poimboeuf [21/03/16 09:06 -0500]:
>On Wed, Mar 16, 2016 at 03:47:04PM -0400, Jessica Yu wrote:
>> For livepatch modules, copy Elf section, symbol, and string information
>> from the load_info struct in the module loader. Persist copies of the
>> original symbol table and string table.
>>
>> Livepatch manages its own relocation sections in order to reuse module
>> loader code to write relocations. Livepatch modules must preserve Elf
>> information such as section indices in order to apply livepatch relocation
>> sections using the module loader's apply_relocate_add() function.
>>
>> In order to apply livepatch relocation sections, livepatch modules must
>> keep a complete copy of their original symbol table in memory. Normally, a
>> stripped down copy of a module's symbol table (containing only "core"
>> symbols) is made available through module->core_symtab. But for livepatch
>> modules, the symbol table copied into memory on module load must be exactly
>> the same as the symbol table produced when the patch module was compiled.
>> This is because the relocations in each livepatch relocation section refer
>> to their respective symbols with their symbol indices, and the original
>> symbol indices (and thus the symtab ordering) must be preserved in order
>> for apply_relocate_add() to find the right symbol.
>>
>> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  include/linux/module.h |  25 ++++++++++
>>  kernel/module.c        | 123 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 146 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index 2bb0c30..3daf2b3 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -330,6 +330,15 @@ struct mod_kallsyms {
>>  	char *strtab;
>>  };
>>
>> +#ifdef CONFIG_LIVEPATCH
>> +struct klp_modinfo {
>> +	Elf_Ehdr hdr;
>> +	Elf_Shdr *sechdrs;
>> +	char *secstrings;
>> +	unsigned int symndx;
>> +};
>> +#endif
>> +
>>  struct module {
>>  	enum module_state state;
>>
>> @@ -456,7 +465,11 @@ struct module {
>>  #endif
>>
>>  #ifdef CONFIG_LIVEPATCH
>> +	bool klp; /* Is this a livepatch module? */
>>  	bool klp_alive;
>> +
>> +	/* Elf information */
>> +	struct klp_modinfo *klp_info;
>>  #endif
>>
>>  #ifdef CONFIG_MODULE_UNLOAD
>> @@ -630,6 +643,18 @@ static inline bool module_requested_async_probing(struct module *module)
>>  	return module && module->async_probe_requested;
>>  }
>>
>> +#ifdef CONFIG_LIVEPATCH
>> +static inline bool is_livepatch_module(struct module *mod)
>> +{
>> +	return mod->klp;
>> +}
>> +#else /* !CONFIG_LIVEPATCH */
>> +static inline bool is_livepatch_module(struct module *mod)
>> +{
>> +	return false;
>> +}
>> +#endif /* CONFIG_LIVEPATCH */
>> +
>>  #else /* !CONFIG_MODULES... */
>>
>>  /* Given an address, look for it in the exception tables. */
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 87cfeb2..80b7fd9 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -1971,6 +1971,82 @@ static void module_enable_nx(const struct module *mod) { }
>>  static void module_disable_nx(const struct module *mod) { }
>>  #endif
>>
>> +#ifdef CONFIG_LIVEPATCH
>> +/*
>> + * Persist Elf information about a module. Copy the Elf header,
>> + * section header table, section string table, and symtab section
>> + * index from info to mod->klp_info.
>> + */
>> +static int copy_module_elf(struct module *mod, struct load_info *info)
>> +{
>> +	unsigned int size, symndx;
>> +	int ret;
>> +
>> +	size = sizeof(*mod->klp_info);
>> +	mod->klp_info = kmalloc(size, GFP_KERNEL);
>> +	if (mod->klp_info == NULL)
>> +		return -ENOMEM;
>> +
>> +	/* Elf header */
>> +	size = sizeof(Elf_Ehdr);
>> +	memcpy(&mod->klp_info->hdr, info->hdr, size);
>> +
>> +	/* Elf section header table */
>> +	size = sizeof(Elf_Shdr) * info->hdr->e_shnum;
>> +	mod->klp_info->sechdrs = kmalloc(size, GFP_KERNEL);
>> +	if (mod->klp_info->sechdrs == NULL) {
>> +		ret = -ENOMEM;
>> +		goto free_info;
>> +	}
>> +	memcpy(mod->klp_info->sechdrs, info->sechdrs, size);
>> +
>> +	/* Elf section name string table */
>> +	size = info->sechdrs[info->hdr->e_shstrndx].sh_size;
>> +	mod->klp_info->secstrings = kmalloc(size, GFP_KERNEL);
>> +	if (mod->klp_info->secstrings == NULL) {
>> +		ret = -ENOMEM;
>> +		goto free_sechdrs;
>> +	}
>> +	memcpy(mod->klp_info->secstrings, info->secstrings, size);
>> +
>> +	/* Elf symbol section index */
>> +	symndx = info->index.sym;
>> +	mod->klp_info->symndx = symndx;

>
>nit: The 'symndx' local variable is superfluous.
>

The symndx variable is just there to keep the line below from reaching
an ugly length (although it is already quite long...)

>> +	mod->klp_info->sechdrs[symndx].sh_addr = (unsigned long) mod->core_kallsyms.symtab;
