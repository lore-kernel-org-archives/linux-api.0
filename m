From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: module: save load_info for livepatch modules
Date: Fri, 13 Nov 2015 14:07:52 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511131402450.15073@pobox.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com> <1447130755-17383-3-git-send-email-jeyu@redhat.com> <20151111143152.GG4431@pathway.suse.cz> <20151112044407.GC30025@packer-debian-8-amd64.digitalocean.com> <20151112100548.GK4431@pathway.suse.cz>
 <alpine.LNX.2.00.1511121518080.9440@pobox.suse.cz> <20151113063547.GC13513@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151113063547.GC13513@packer-debian-8-amd64.digitalocean.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 13 Nov 2015, Jessica Yu wrote:

> +++ Miroslav Benes [12/11/15 15:19 +0100]:
> > On Thu, 12 Nov 2015, Petr Mladek wrote:
> > 
> > > On Wed 2015-11-11 23:44:08, Jessica Yu wrote:
> > > > +++ Petr Mladek [11/11/15 15:31 +0100]:
> > > > >On Mon 2015-11-09 23:45:52, Jessica Yu wrote:
> > > > >>diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > > > >>index 6e53441..087a8c7 100644
> > > > >>--- a/kernel/livepatch/core.c
> > > > >>+++ b/kernel/livepatch/core.c
> > > > >>@@ -1001,6 +1001,23 @@ static struct notifier_block klp_module_nb = {
> > > > >> 	.priority = INT_MIN+1, /* called late but before ftrace
> > > notifier */
> > > > >> };
> > > > >>
> > > > >>+/*
> > > > >>+ * Save necessary information from info in order to be able to
> > > > >>+ * patch modules that might be loaded later
> > > > >>+ */
> > > > >>+void klp_prepare_patch_module(struct module *mod, struct load_info
> > > *info)
> > > > >>+{
> > > > >>+	Elf_Shdr *symsect;
> > > > >>+
> > > > >>+	symsect = info->sechdrs + info->index.sym;
> > > > >>+	/* update sh_addr to point to symtab */
> > > > >>+	symsect->sh_addr = (unsigned long)info->hdr +
> > > symsect->sh_offset;
> > > > >
> > > > >Is livepatch the only user of this value? By other words, is this safe?
> > > >
> > > > I think it is safe to say yes. klp_prepare_patch_module() is only
> > > > called at the very end of load_module(), right before
> > > > do_init_module(). Normally, at that point, info->hdr will have already
> > > > been freed by free_copy() along with the elf section information
> > > > associated with it. But if we have a livepatch module, we don't free.
> > > > So we should be the very last user, and there should be nobody
> > > > utilizing the memory associated with the load_info struct anymore at
> > > > that point.
> > > 
> > > I see. It looks safe at this point. But still I wonder if it would be
> > > possible to calculate this later in the livepatch code. It will allow
> > > to potentially use the info structure also by other subsystem.
> > > 
> > > BTW: Where is "sh_addr" value used, please? I see it used only
> > > in the third patch as info->sechdrs[relindex].sh_addr. But it is
> > > an array. I am not sure if it is the same variable.
> > 
> > Jessica, why do we need to update sh_addr for symtab? It is not clear to
> > me.
> 
> Ah, I definitely need to make that comment a lot more informative.
> Will make sure to add that in v2. 
> So, the sh_addr field tells us where a certain section is in memory.
> Here, we need to update the symbol table section's sh_addr because if
> we don't, it will eventually point to freed module init memory, which
> is freed in do_init_module(). Let me explain what happens.
> 
> At the beginning of load_module(), the sh_addr fields of each section
> initially point to the vmalloc'd memory within info->hdr (which is
> allocated in copy_module_from_{fd,user}() in module.c). The sh_addr's
> are first assigned in rewrite_section_headers(), called from
> setup_load_info(). These sh_addr's initially just point to an offset
> within info->hdr depending on each section's sh_offset.
> 
> However, in move_module(), where we layout and allocate the memory
> where the module will finally reside, these sh_addr's will get
> reassigned. For the symtab section's sh_addr, it gets reassigned to
> module init memory. (In layout_symtab(), you'll see that the symtab
> section gets marked with INIT_OFFSET_MASK, which indicates that it
> will get an address in init memory when the sh_addr's get reassigned
> in move_module()). Thus the symbol table that simplify_symbols() uses
> is actually in init memory, and will be freed later in
> do_init_module().
> 
> info->hdr is just a temporary holding place for module elf section
> data in memory. Normally, we would get rid of info->hdr and free the
> memory associated with it at the end of the module loading process
> (via free_copy()). But in this patchset, we save all the original elf
> section information because we need it (along with the original
> symtab) in order to make the call to apply_relocate_add(). If you look
> at apply_relocate_add() for x86, s390, etc you'll see that it expects
> a symbol table at the symbol section's sh_addr field (basically, an
> array of Elf_Sym's). This is why we fix up the sh_addr of the symtab
> section to point back to the memory associated with info->hdr (and not
> module init memory). I hope that makes sense.

Great explanation. Thanks.

Only info->hdr makes me worried. See my other mail.

Miroslav
