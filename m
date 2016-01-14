From: Jessica Yu <jeyu@redhat.com>
Subject: Re: module: preserve Elf information for livepatch modules
Date: Wed, 13 Jan 2016 23:47:19 -0500
Message-ID: <20160114044718.GC980@packer-debian-8-amd64.digitalocean.com>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
 <1452281304-28618-3-git-send-email-jeyu@redhat.com>
 <87oacshpqn.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87oacshpqn.fsf@rustcorp.com.au>
Sender: linux-doc-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Rusty Russell [11/01/16 11:55 +1030]:
>Hi Jessica,
>
>        Nice patch series.  Minor issues below, but they're really
>just nits which can be patched afterwards if you're getting sick of
>rebasing :)

Thanks Rusty!

>> +#ifdef CONFIG_LIVEPATCH
>> +/*
>> + * copy_module_elf - preserve Elf information about a module
>> + *
>> + * Copy relevant Elf information from the load_info struct.
>> + * Note: not all fields from the original load_info are
>> + * copied into mod->info.
>
>This makes me nervous, to have a struct which is half-initialized.
>
>Better would be to have a separate type for this, eg:
>
>struct livepatch_modinfo {
>        Elf_Ehdr hdr;
>        Elf_Shdr *sechdrs;
>        char *secstrings;
>        /* FIXME: Which of these do you need? */
>        struct {
>        	unsigned int sym, str, mod, vers, info, pcpu;
>        } index;
>};
>
>This also avoids an extra allocation as hdr is no longer a ptr.

Sure, sounds good.

>> +	/*
>> +	 * Update symtab's sh_addr to point to a valid
>> +	 * symbol table, as the temporary symtab in module
>> +	 * init memory will be freed
>> +	 */
>> +	mod->info->sechdrs[mod->info->index.sym].sh_addr = (unsigned long)mod->core_symtab;
>
>This comment is a bit misleading: it's actually pointing into the
>temporary module copy, which will be discarded.  The init section is
>slightly different...

Ah, perhaps I'm misunderstanding something..

Since copy_module_elf() is called after move_module(), my
understanding is that all the section sh_addr's should be pointing
to either module core memory or module init memory (instead of the
initial temporary copy of the module in info->hdr). Since the symbol
table section is marked with INIT_OFFSET_MASK, it will reside in
module init memory (and freed near the end of do_init_module()),
which is why I am updating the sh_addr here to point to core_symtab
instead. For livepatch modules, the core_symtab will be a complete
copy of the symbol table instead of the slimmed down version. Please
correct me if my understanding is incorrect.

Thanks for the patch review,
Jessica
