From: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: module: save load_info for livepatch modules
Date: Thu, 12 Nov 2015 15:19:32 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511121518080.9440@pobox.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com> <1447130755-17383-3-git-send-email-jeyu@redhat.com> <20151111143152.GG4431@pathway.suse.cz> <20151112044407.GC30025@packer-debian-8-amd64.digitalocean.com>
 <20151112100548.GK4431@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151112100548.GK4431-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 12 Nov 2015, Petr Mladek wrote:

> On Wed 2015-11-11 23:44:08, Jessica Yu wrote:
> > +++ Petr Mladek [11/11/15 15:31 +0100]:
> > >On Mon 2015-11-09 23:45:52, Jessica Yu wrote:
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
> > >
> > >Is livepatch the only user of this value? By other words, is this safe?
> > 
> > I think it is safe to say yes. klp_prepare_patch_module() is only
> > called at the very end of load_module(), right before
> > do_init_module(). Normally, at that point, info->hdr will have already
> > been freed by free_copy() along with the elf section information
> > associated with it. But if we have a livepatch module, we don't free.
> > So we should be the very last user, and there should be nobody
> > utilizing the memory associated with the load_info struct anymore at
> > that point.
> 
> I see. It looks safe at this point. But still I wonder if it would be
> possible to calculate this later in the livepatch code. It will allow
> to potentially use the info structure also by other subsystem.
> 
> BTW: Where is "sh_addr" value used, please? I see it used only
> in the third patch as info->sechdrs[relindex].sh_addr. But it is
> an array. I am not sure if it is the same variable.

Jessica, why do we need to update sh_addr for symtab? It is not clear to 
me.

Miroslav
