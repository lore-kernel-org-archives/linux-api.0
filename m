From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Wed, 11 Nov 2015 13:27:18 -0500
Message-ID: <20151111182718.GA30025@packer-debian-8-amd64.digitalocean.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-4-git-send-email-jeyu@redhat.com>
 <20151111152256.GP2599@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151111152256.GP2599-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Petr Mladek [11/11/15 16:22 +0100]:
>On Mon 2015-11-09 23:45:53, Jessica Yu wrote:
>> Reuse module loader code to write relocations, thereby eliminating the
>> need for architecture specific code in livepatch. Namely, we reuse
>> apply_relocate_add() in the module loader to write relocs instead of
>> duplicating functionality in livepatch's klp_write_module_reloc(). To
>> apply relocation sections, remaining SHN_LIVEPATCH symbols referenced by
>> relocs are resolved and then apply_relocate_add() is called to apply
>> those relocations.
>>
>> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  include/linux/livepatch.h | 11 ++++--
>>  include/linux/module.h    |  6 ++++
>>  kernel/livepatch/core.c   | 89 +++++++++++++++++++++++++++++------------------
>>  3 files changed, 70 insertions(+), 36 deletions(-)
>>
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
>[...]
>
>> +
>> +	/* For each __klp_rela section for this object */
>> +	list_for_each_entry(reloc_sec, &obj->reloc_secs, list) {
>
>Who, when, and how will define reloc_secs, please?
>
>I guess that it is just an optimization. It helps to avoid going
>through all elf sections of all livepatch modules. Therefore, I think
>that we might fill this when the livepatch module is loaded. But
>I do not see the code for this.

Thanks for bringing this up, I admit that from this patchset it is
unclear where and how the reloc_secs list is built. 

Basically, the patch module code is expected to build the reloc_secs
list for each object that is being patched. For example in kpatch, the
patch module generates this list in patch_init(). Like you guessed, it
does go through all the elf sections of the patch module to find the
reloc sections marked SHF_RELA_LIVEPATCH. We are able to access these
sections through module->info, which is set up for livepatch modules
before the module loader calls do_init_module() (and hence before
patch_init(), See patch 2/5).
See below for an example of how the reloc_secs list might be built: 
https://github.com/flaming-toast/kpatch/blob/no_dynrela_redux/kmod/patch/livepatch-patch-hook.c#L213

Once the patch module has built this list, it is good to go for use in
livepatch core. All livepatch has to do then is to iterate though the
list, resolve any outstanding symbols, and call apply_relocate_add(),
as shown in this patch.

Miroslav mentioned in another email that we should start thinking
about including documentation about this, including the expected patch
module format. So perhaps v2 should include some documentation about
this whole process somewhere.

Please let me know if anything else is unclear.

Thanks,

Jessica
