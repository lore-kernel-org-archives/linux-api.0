From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: module: save load_info for livepatch modules
Date: Fri, 13 Nov 2015 19:36:19 -0500
Message-ID: <20151114003536.GA14759@packer-debian-8-amd64.digitalocean.com>
References: <1447130755-17383-3-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1511111505300.12467@pobox.suse.cz>
 <20151112053228.GD30025@packer-debian-8-amd64.digitalocean.com>
 <20151112102404.GL4431@pathway.suse.cz>
 <alpine.LNX.2.00.1511121400290.9440@pobox.suse.cz>
 <20151112150345.GT2599@pathway.suse.cz>
 <20151112170501.GD4038@treble.hsd1.ky.comcast.net>
 <20151112221750.GA13513@packer-debian-8-amd64.digitalocean.com>
 <alpine.LNX.2.00.1511131304280.15073@pobox.suse.cz>
 <alpine.LNX.2.00.1511131338510.15073@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1511131338510.15073-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Miroslav Benes [13/11/15 13:46 +0100]:
>On Fri, 13 Nov 2015, Miroslav Benes wrote:
>
>> As for load_info, I don't have a strong opinion whether to keep it for all
>> modules or for livepatch modules only.
>
>I have. We cannot keep it, even for livepatch modules...
>
>In info->hdr there is a temporary copy of the whole module (see
>init_module syscall and the first parts of load_module). In load_module
>a final struct module * is created with parts of info->hdr copied (I'll
>get to that later). So if we saved info->hdr for later purposes we would
>just have two copies of the same module in the memory. The original one
>with !SHF_ALLOC sections and everything in vmalloc area, and the new
>final copy with SHF_ALLOC sections only. This is not good.
>
>If this is correct (and I think it is after some staring into the code) we
>need to do something different. We should build the info we need for
>delayed relocations from the final copy (or refactor the existing
>module code).
>
>The second problem... dynrela sections need to be marked with SHF_ALLOC
>flag, right? Perhaps it would be better not to do it and copy also
>SHF_RELA_LIVEPATCH sections. It is equivalent but not hidden somewhere
>else (in userspace "kpatch-build" tool).

Hm, OK. I understand your concern about leaving a redundant copy of
the module in memory and I agree that we need to do better. I think I
have a solution.

I'm looking at exactly what components we need to make the calls to
apply_relocate_add() work. It's quite simple, I think we only need to
keep the following:

1. A copy of the module's elf section headers i.e. info->sechdrs.
This should be easy to copy. memcpy [info->hdr->e_shnum *
sizeof(Elf_Shdr)] bytes from info->sechdrs. We can maybe put
this in a new field called module->sechdrs.

2. A copy of each __klp_rela section.
If we don't keep info, the current code will discard/not copy the rela
sections over to module core memory since they are !SHF_ALLOC. In
kpatch-build, it is very easy to simply |= the SHF_ALLOC flag with
each __klp_rela section and they will automatically get copied over to
module core memory, and their sh_addr's automatically get reassigned
as well. Thus the klp rela sections will be accessible at
sechdrs[index_of_klpsec].sh_addr. I think this is the easiest solution.

3. A copy of the symbol table. 
Notice that module already has a "symtab" field. In kernels configured
with CONFIG_KALLSYMS, it points to a trimmed down symtab (the
mod->core_symtab) in module core memory. This symtab is not normally
complete; only "core" symbols are kept in it. See add_kallsyms()
(called in post_relocations()) for how core symbols are copied into
this symtab. Then, after the symbols have been copied, module->symtab
is reassigned to point to this core_symtab in do_init_module(). Since
CONFIG_LIVEPATCH requires CONFIG_KALLSYMS, I think we can assume that
mod->symtab will be pointing to mod->core_symtab at the end of the
module load process, since mod->symtab gets assigned to core_symtab in
do_init_module() if CONFIG_KALLSYMS is set.

So for livepatch, what we can do is make sure every symbol in a
livepatch module gets copied into this core symtab. It is important we
keep every symbol since apply_relocate_add() will be using the
original symbol indices. We can implement this by adding a check in
add_kallsyms() to see if we're dealing with a livepatch module. If
yes, just copy all the symbols over.

Then, we will also update Elf_Shdr corresponding to the symbol table
section (sechdrs[symindex].sh_addr) to make sure its sh_addr points to
mod->symtab, so apply_relocate_add() will be able to use it.

4. A copy of mod_arch_specific
I think we discussed this in another email somewhere, but we need to
keep a copy if this somewhere as well. 

So to summarize, keep a copy of sechdrs in module->sechdrs, keep a
copy of mod_arch_specific, mark klp rela sections with SHF_ALLOC,
re-use module->symtab by making sure every symbol gets considered a
"core" symbol and gets copied over. And of course any memory we
allocate (sechdrs, arch stuff) we will free in perhaps free_module()
somewhere.

I haven't implemented it yet but I think it will work, and we don't
need to keep load_info in this scheme. What do you think?

Thanks,
Jessica
