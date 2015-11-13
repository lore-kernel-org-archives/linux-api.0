From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: module: save load_info for livepatch modules
Date: Fri, 13 Nov 2015 03:20:20 -0500
Message-ID: <20151113082020.GF13513@packer-debian-8-amd64.digitalocean.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-3-git-send-email-jeyu@redhat.com>
 <20151111143152.GG4431@pathway.suse.cz>
 <20151112044407.GC30025@packer-debian-8-amd64.digitalocean.com>
 <20151112100548.GK4431@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151112100548.GK4431-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Petr Mladek [12/11/15 11:05 +0100]:
>On Wed 2015-11-11 23:44:08, Jessica Yu wrote:
>> +++ Petr Mladek [11/11/15 15:31 +0100]:
>> >On Mon 2015-11-09 23:45:52, Jessica Yu wrote:
>> >>diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> >>index 6e53441..087a8c7 100644
>> >>--- a/kernel/livepatch/core.c
>> >>+++ b/kernel/livepatch/core.c
>> >>@@ -1001,6 +1001,23 @@ static struct notifier_block klp_module_nb = {
>> >> 	.priority = INT_MIN+1, /* called late but before ftrace notifier */
>> >> };
>> >>
>> >>+/*
>> >>+ * Save necessary information from info in order to be able to
>> >>+ * patch modules that might be loaded later
>> >>+ */
>> >>+void klp_prepare_patch_module(struct module *mod, struct load_info *info)
>> >>+{
>> >>+	Elf_Shdr *symsect;
>> >>+
>> >>+	symsect = info->sechdrs + info->index.sym;
>> >>+	/* update sh_addr to point to symtab */
>> >>+	symsect->sh_addr = (unsigned long)info->hdr + symsect->sh_offset;
>> >
>> >Is livepatch the only user of this value? By other words, is this safe?
>>
>> I think it is safe to say yes. klp_prepare_patch_module() is only
>> called at the very end of load_module(), right before
>> do_init_module(). Normally, at that point, info->hdr will have already
>> been freed by free_copy() along with the elf section information
>> associated with it. But if we have a livepatch module, we don't free.
>> So we should be the very last user, and there should be nobody
>> utilizing the memory associated with the load_info struct anymore at
>> that point.
>
>I see. It looks safe at this point. But still I wonder if it would be
>possible to calculate this later in the livepatch code. It will allow
>to potentially use the info structure also by other subsystem.

We can technically reassign sh_addr later in livepatch somewhere, yes,
I'd have to think more about where it'd make the most sense to do
this. Maybe in patch_init? It just seemed at the time a bit clearer to
do it in klp_prepare_patch_module() (soon to be called
copy_module_info() probably).

>BTW: Where is "sh_addr" value used, please? I see it used only
>in the third patch as info->sechdrs[relindex].sh_addr. But it is
>an array. I am not sure if it is the same variable.

I will add a more informative comment in the code, see my reply to
Miroslav.

>
>> >>+	mod->info = kzalloc(sizeof(*info), GFP_KERNEL);
>> >>+	memcpy(mod->info, info, sizeof(*info));
>> >>+
>> >>+}
>> >
>> >It is strange that this funtion is defined in livepatch/core.c
>> >but declared in module.h. I would move the definition to
>> >module.c.
>>
>> Right, I was trying to keep all the livepatch-related functions
>> together in livepatch/core.c. but I can move it to module.c if it
>> makes more sense/Rusty doesn't object to it :-)
>
>Sure. I think that we could use some generic name, e.g. copy_module_info().
>
>> >> static int __init klp_init(void)
>> >> {
>> >> 	int ret;
>> >>diff --git a/kernel/module.c b/kernel/module.c
>> >>index 8f051a1..8ae3ca5 100644
>> >>--- a/kernel/module.c
>> >>+++ b/kernel/module.c
>> >>@@ -2137,6 +2123,11 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>> >> 			       (long)sym[i].st_value);
>> >> 			break;
>> >>
>> >>+#ifdef CONFIG_LIVEPATCH
>> >>+		case SHN_LIVEPATCH:
>> >>+			break;
>> >>+#endif
>> >
>> >IMHO, even a kernel compiled without CONFIG_LIVEPATCH should handle livepatch
>> >modules with grace. It means to reject loading.
>>
>> I think even right now, without considering this patchset, we don't
>> reject modules "gracefully" when we load a livepatch module without
>> CONFIG_LIVEPATCH. The module loader will complain and reject the
>> livepatch module, saying something like "Unknown symbol
>> klp_register_patch." This behavior is the same with or without
>> this patch series applied. If we want to add a bit more logic to
>> gracefully reject patch modules, perhaps that should be a different
>> patch altogether, as I think it is unrelated to the goal of this one :-)
>
>Yup, the module load would fail anyway because of the missing symbol.
>But I think that we should fail on the first error occurence.
>
>In each case, IMHO, we should not do the "default:" action for this
>section even when complied without CONFIG_LIVEPATCH.

See comment below -- 

>
>> >> 		case SHN_UNDEF:
>> >> 			ksym = resolve_symbol_wait(mod, info, name);
>> >> 			/* Ok if resolved.  */
>> >>@@ -2185,6 +2176,11 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
>> >> 		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
>> >> 			continue;
>> >>
>> >>+#ifdef CONFIG_LIVEPATCH
>> >>+		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
>> >>+			continue;
>> >>+#endif
>
>I guess that if we do not trigger the error above, and do
>not have the check here, we will try to call apply_relocate() below.
>I guess that it will fail. If we are lucky it will print "Unknown
>relocation". I think that we could do better.

For the loading of livepatch modules in !CONFIG_LIVEPATCH kernels, we
should probably gracefully reject it in the beginning of load_module()
(so that MODULE_INFO flag might come in handy here after all). If it's
a livepatch module && !CONFIG_LIVEPATCH, reject it. Then we wouldn't
even call apply_relocations() here, we wouldn't run into the
possibility of this check falling through, nor would
simplify_symbols() be even called.

>> >>+
>> >> 		if (info->sechdrs[i].sh_type == SHT_REL)
>> >> 			err = apply_relocate(info->sechdrs, info->strtab,
>> >> 					     info->index.sym, i, mod);
>> >>@@ -3530,8 +3526,20 @@ static int load_module(struct load_info *info, const char __user *uargs,
>> >> 	if (err < 0)
>> >> 		goto bug_cleanup;
>> >>
>> >>+#ifdef CONFIG_LIVEPATCH
>> >>+	/*
>> >>+	 * Save sechdrs, indices, and other data from info
>> >>+	 * in order to patch to-be-loaded modules.
>> >>+	 * Do not call free_copy() for livepatch modules.
>> >>+	 */
>> >>+	if (get_modinfo((struct load_info *)info, "livepatch"))
>> >>+		klp_prepare_patch_module(mod, info);
>> >>+	else
>> >>+		free_copy(info);
>> >>+#else
>> >
>> >I would move this #else one line above and get rid of the
>> >double free_copy(info); But it is a matter of taste.
>>
>> Maybe I'm missing something, but I think we do need the double
>> free_copy(), because in the CONFIG_LIVEPATCH case, we still want to
>> call free_copy() for non-livepatch modules. And we want to avoid
>> calling free_copy() for livepatch modules (hence the extra else).
>
>Ah, this was just a cosmetic change. I meant to use something like:
>
>#ifdef CONFIG_LIVEPATCH
>	/*
>	 * Save sechdrs, indices, and other data from info
>	 * in order to patch to-be-loaded modules.
>	 * Do not call free_copy() for livepatch modules.
>	 */
>	if (get_modinfo((struct load_info *)info, "livepatch"))
>		klp_prepare_patch_module(mod, info);
>	else
>#endif
>		/* Get rid of temporary copy. */
>		free_copy(info);
>

Oh OK, so that's what you meant. :-)

Thanks,
Jessica
