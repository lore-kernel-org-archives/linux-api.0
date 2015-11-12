From: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: module: save load_info for livepatch modules
Date: Thu, 12 Nov 2015 14:22:28 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511121400290.9440@pobox.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com> <1447130755-17383-3-git-send-email-jeyu@redhat.com> <alpine.LNX.2.00.1511111505300.12467@pobox.suse.cz> <20151112053228.GD30025@packer-debian-8-amd64.digitalocean.com>
 <20151112102404.GL4431@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151112102404.GL4431-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 12 Nov 2015, Petr Mladek wrote:

> On Thu 2015-11-12 00:33:12, Jessica Yu wrote:
> > +++ Miroslav Benes [11/11/15 15:17 +0100]:
> > >On Mon, 9 Nov 2015, Jessica Yu wrote:
> > >
> > >>diff --git a/include/linux/module.h b/include/linux/module.h
> > >>index 3a19c79..c8680b1 100644
> > >>--- a/include/linux/module.h
> > >>+++ b/include/linux/module.h
> > >
> > >[...]
> > >
> > >>+#ifdef CONFIG_LIVEPATCH
> > >>+extern void klp_prepare_patch_module(struct module *mod,
> > >>+				     struct load_info *info);
> > >>+extern int
> > >>+apply_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
> > >>+		   unsigned int symindex, unsigned int relsec,
> > >>+		   struct module *me);
> > >>+#endif
> > >>+
> > >> #else /* !CONFIG_MODULES... */
> > >
> > >apply_relocate_add() is already in include/linux/moduleloader.h (guarded
> > >by CONFIG_MODULES_USE_ELF_RELA), so maybe we can just include that where
> > >we need it. As for the klp_prepare_patch_module() wouldn't it be better to
> > >have it in our livepatch.h and include that in kernel/module.c?
> > 
> > Yeah, Petr pointed this out as well :-) I will just include
> > moduleloader.h for the apply_relocate_add() declaration.
> > 
> > It also looks like we have some disagreement over where to put
> > klp_prepare_patch_module(), either in livepatch/core.c (and add the
> > function declaration in livepatch.h, and have module.c include
> > livepatch.h) or in kernel/module.c, keeping the
> > klp_prepare_patch_module() declaration in module.h. Maybe Rusty can
> > provide some input.

Yes, there are several ways how to do it. Maybe the best would be some 
generic way in kernel/module.c. I am not sure if there will be another 
user of this in the future but nevertheless. It would also allow us to 
somehow solve the issues mentioned below. Thus, klp_prepare_patch_module 
is inappropriate name and it should be for example just preserve_load_info 
(or more general if needed) and it should be in kernel/module.c.

> > >> /* Given an address, look for it in the exception tables. */
> > >>diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > >>index 6e53441..087a8c7 100644
> > >>--- a/kernel/livepatch/core.c
> > >>+++ b/kernel/livepatch/core.c
> > >>@@ -1001,6 +1001,23 @@ static struct notifier_block klp_module_nb = {
> > >> 	.priority = INT_MIN+1, /* called late but before ftrace notifier */
> > >> };
> > >>
> > >>+/*
> > >>+ * Save necessary information from info in order to be able to
> > >>+ * patch modules that might be loaded later
> > >>+ */
> > >>+void klp_prepare_patch_module(struct module *mod, struct load_info *info)
> > >>+{
> > >>+	Elf_Shdr *symsect;
> > >>+
> > >>+	symsect = info->sechdrs + info->index.sym;
> > >>+	/* update sh_addr to point to symtab */
> > >>+	symsect->sh_addr = (unsigned long)info->hdr + symsect->sh_offset;
> > >>+
> > >>+	mod->info = kzalloc(sizeof(*info), GFP_KERNEL);
> > >>+	memcpy(mod->info, info, sizeof(*info));
> > >>+
> > >>+}
> > >
> > >What about arch-specific 'struct mod_arch_specific'? We need to preserve
> > >it somewhere as well for s390x and other non-x86 architectures.
> > 
> > Ah! Thank you for catching this, I overlooked this important detail.
> > Yes, we do need to save the arch-specific struct. We would be in
> > trouble for s390 relocs if we didn't. I am trying to think of a way to
> > save this information for s390, since s390's module_finalize() frees
> > mod->arch.syminfo, which we definitely need in order for the call to
> > apply_relocate_add() to work. Maybe we can add an extra call right
> > before module_finalize() that will do some livepatch-specific
> > processing and copy this information (this would be in
> > post_relocation() in kernel/module.c). Perhaps this patchset cannot be
> > entirely free of arch-specific code after all :-( Still thinking.

Well, mod_arch_specific is defined as each architecture needs. So for x86 
it is empty. It is arch-agnostic in this way and we can deal with it as 
"a black box". We just need it not to be freed in module_finalize. And...

> I think about adding a flag somewhere, e.g. mod->preserve_relocs.
> It might be set in simplify_symbols() when SHN_LIVEPATCH is found.
> It might be checked when freeing the needed structures in both
> the generic and arch-specific code.

...that is the reason why some sort of flag seems to be necessary. It 
could be set when livepatch is set in modinfo. We would use it for 
preserving both load_info and mod_arch_specific struct (in some form) and 
for...

> > >>+#ifdef CONFIG_LIVEPATCH
> > >>+	/*
> > >>+	 * Save sechdrs, indices, and other data from info
> > >>+	 * in order to patch to-be-loaded modules.
> > >>+	 * Do not call free_copy() for livepatch modules.
> > >>+	 */
> > >>+	if (get_modinfo((struct load_info *)info, "livepatch"))
> > >>+		klp_prepare_patch_module(mod, info);
> > >>+	else
> > >>+		free_copy(info);
> > >>+#else
> > >> 	/* Get rid of temporary copy. */
> > >> 	free_copy(info);
> > >>+#endif
> > >
> > >Maybe I am missing something but isn't it necessary to call vfree() on
> > >info somewhere in the end?
> > 
> > So free_copy() will call vfree(info->hdr), except in livepatch modules
> > we want to keep all the elf section information stored there, so we
> > avoid calling free_copy(), As for the info struct itself, if you look
> > at the init_module and finit_module syscall definitions in
> > kernel/module.c, you will see that info is actually a local function
> > variable, simply passed in to the call to load_module(), and will be
> > automatically deallocated when the syscall returns. :-) No need to
> > explicitly free info.
> 
> We still have to free the copied or preserved structures when
> the module is unloaded.

...freeing what we allocated. We need to free info->hdr somewhere if not 
here and also mod_arch_specific struct where the patch module is removed. 
This would unfortunately lead to changes in arch-specific code in 
module.c. For example in arch/s390/kernel/module.c there is vfree call on 
part of mod_arch_specific in module_finalize. We would call it only if the 
flag mentioned above is not set and at the same time we would need to call 
it when the patch module is being removed.

Hm, this is (again) getting complicated and ugly. Is there someone who can 
simplify things? Josh? :)

Miroslav
