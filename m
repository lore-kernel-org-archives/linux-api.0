From: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Thu, 12 Nov 2015 16:27:01 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511121601370.9440@pobox.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com> <1447130755-17383-4-git-send-email-jeyu@redhat.com> <alpine.LNX.2.00.1511111519250.12467@pobox.suse.cz> <20151111200732.GB30025@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151111200732.GB30025-N0bYjD2NfQ6k4hzjq3hgyGTy53QMssKEsp+A89P3RPuQWHG76I6BsA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 11 Nov 2015, Jessica Yu wrote:

> +++ Miroslav Benes [11/11/15 15:30 +0100]:
> > On Mon, 9 Nov 2015, Jessica Yu wrote:
> >
> > So I guess we don't need klp_reloc anymore.
> 
> Yes, that's correct. I am noticing just now that I forgot to remove
> the klp_reloc struct definition from livepatch.h. That change will be
> reflected in v2...
> 
> > If true, we should really
> > start thinking about proper documentation because there are going to be
> > plenty of assumptions about a patch module and we need to have it written
> > somewhere. Especially how the relocation sections look like.
> 
> Agreed. As a first step the patch module format can perhaps be
> documented somewhere. Perhaps it's time we create
> Documentation/livepatch/? :-)

Yes, I think so.

> > > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > > index 087a8c7..26c419f 100644
> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -28,6 +28,8 @@
> > >  #include <linux/list.h>
> > >  #include <linux/kallsyms.h>
> > >  #include <linux/livepatch.h>
> > > +#include <linux/elf.h>
> > > +#include <asm/cacheflush.h>
> > > 
> > >  /**
> > >   * struct klp_ops - structure for tracking registered ftrace ops structs
> > > @@ -281,46 +283,54 @@ static int klp_find_external_symbol(struct module
> > > *pmod, const char *name,
> > >  }
> > > 
> > >  static int klp_write_object_relocations(struct module *pmod,
> > > -					struct klp_object *obj)
> > > +					struct klp_object *obj,
> > > +					struct klp_patch *patch)
> > >  {
> > > -	int ret;
> > > -	struct klp_reloc *reloc;
> > > +	int relindex, num_relas;
> > > +	int i, ret = 0;
> > > +	unsigned long addr;
> > > +	unsigned int bind;
> > > +	char *symname;
> > > +	struct klp_reloc_sec *reloc_sec;
> > > +	struct load_info *info;
> > > +	Elf_Rela *rela;
> > > +	Elf_Sym *sym, *symtab;
> > > +	Elf_Shdr *symsect;
> > > 
> > >  	if (WARN_ON(!klp_is_object_loaded(obj)))
> > >  		return -EINVAL;
> > > 
> > > -	if (WARN_ON(!obj->relocs))
> > > -		return -EINVAL;
> > > -
> > > -	for (reloc = obj->relocs; reloc->name; reloc++) {
> > > -		if (!klp_is_module(obj)) {
> > > -			ret = klp_verify_vmlinux_symbol(reloc->name,
> > > -							reloc->val);
> > > -			if (ret)
> > > -				return ret;
> > > -		} else {
> > > -			/* module, reloc->val needs to be discovered */
> > > -			if (reloc->external)
> > > -				ret = klp_find_external_symbol(pmod,
> > > -							       reloc->name,
> > > -							       &reloc->val);
> > > -			else
> > > -				ret = klp_find_object_symbol(obj->mod->name,
> > > -							     reloc->name,
> > > -							     &reloc->val);
> > > -			if (ret)
> > > -				return ret;
> > > -		}
> > > -		ret = klp_write_module_reloc(pmod, reloc->type, reloc->loc,
> > > -					     reloc->val + reloc->addend);
> > > -		if (ret) {
> > > -			pr_err("relocation failed for symbol '%s' at 0x%016lx
> > > (%d)\n",
> > > -			       reloc->name, reloc->val, ret);
> > > -			return ret;
> > > +	info = pmod->info;
> > > +	symsect = info->sechdrs + info->index.sym;
> > > +	symtab = (void *)info->hdr + symsect->sh_offset;
> > > +
> > > +	/* For each __klp_rela section for this object */
> > > +	list_for_each_entry(reloc_sec, &obj->reloc_secs, list) {
> > > +		relindex = reloc_sec->index;
> > > +		num_relas = info->sechdrs[relindex].sh_size /
> > > sizeof(Elf_Rela);
> > > +		rela = (Elf_Rela *) info->sechdrs[relindex].sh_addr;
> > > +
> > > +		/* For each rela in this __klp_rela section */
> > > +		for (i = 0; i < num_relas; i++, rela++) {
> > > +			sym = symtab + ELF_R_SYM(rela->r_info);
> > > +			symname = info->strtab + sym->st_name;
> > > +			bind = ELF_ST_BIND(sym->st_info);
> > > +
> > > +			if (sym->st_shndx == SHN_LIVEPATCH) {
> > > +				if (bind == STB_LIVEPATCH_EXT)
> > > +					ret = klp_find_external_symbol(pmod,
> > > symname, &addr);
> > > +				else
> > > +					ret =
> > > klp_find_object_symbol(obj->name, symname, &addr);
> > > +				if (ret)
> > > +					return ret;
> > > +				sym->st_value = addr;
> > > +			}
> > >  		}
> > > +		ret = apply_relocate_add(info->sechdrs, info->strtab,
> > > +					 info->index.sym, relindex, pmod);
> > >  	}
> > > 
> > > -	return 0;
> > > +	return ret;
> > >  }
> > 
> > Looking at this... do we even need reloc_secs in klp_object? Question is
> > whether we need more than one dynrela section for an object. If not then
> > the binding between klp_reloc_sec and an object is the only relevant thing
> > in the structure, be it index or objname. So we can replace the
> > list of structures with just the index in klp_object, or get rid of it
> > completely and rely on the name of dynrela section be something like
> > __klp_rela_{objname}.
> 
> Hm, you bring up a good point. I think theoretically yes, it is
> possible to just have one klp_reloc_sec for each object and therefore
> a list is not required (I have not checked yet how difficult it would
> be to implement this on the kpatch-build side of things).  However,
> considering the final format of the patch module, I think it is
> semantically clearer to leave it as a list, and for each object to
> possibly have more than one __klp_rela section.
> 
> For example, say we are patching two functions in ext4. In my
> resulting kpatch module I will have two __klp_rela_ext4 sections, and
> they might look like this when we run readelf --sections:
> 
> [34] __klp_rela_ext4.text.ext4_attr_store RELA ...
> [35] __klp_rela_ext4.text.ext4_attr_show RELA ...
> 
> Then these two klp rela sections end up as two elements in the
> reloc_secs list for the ext4 patch object. I think this way, we can
> better tell which rela is being applied to what function. Might be
> easier to understand what's happening from the developer's point of
> view.
> 
> > You see, we go through elf sections here which were preserved by module
> > loader. We even have relevant sections marked with SHF_RELA_LIVEPATCH. So
> > maybe all the stuff around klp_reloc_sec is not necessary.
> > 
> > Thoughts?
> 
> Ah, so this is where descriptive comments and documentation might have
> been useful :-) So I think we will still need to keep the
> klp_reloc_sec struct to help the patch module initialize. Though the
> name and objname fields aren't used in this patchset, they are used in
> the kpatch patch module code [1], where we iterate through each elf
> section, find the ones marked with SHF_RELA_LIVEPATCH, set the
> klp_reloc_sec's objname (which we find from the "name" field,
> formatted as __klp_rela_{objname}.text..). Once we have the objname
> set, we can then find the object to attach the reloc_sec to (i.e. add
> it to its list of reloc_secs).
> 
> Hope that clears some things up.

Ok, I'll try to explain myself and it is gonna be long. I'll try to 
describe how we deal with dynrelas in klp today, how you use it in kpatch 
(and this is the place where my knowledge can be wrong or obsolete), what 
you propose and what I'd like to propose.

1. First let's look on what we have now.

We have a patch module in which there is a section with all dynrelas 
needed to be resolved (it was like this in kpatch some time ago and maybe 
it is different now so just have a patience, I'll get to it). In the init 
function of the module kpatch builds all the relevant info from dynrela 
section. It goes through it, creates an array of klp_reloc for each object 
and includes each dynrela record with an objname to the array of 
klp_object with that objname. Later when we need to apply relocations for 
patched object we just go through the list (array) of its dynrelas in 
klp_object and call our arch-specific klp_write_module_reloc().

Now this was probably changed in kpatch and you do not have one dynrela 
section but one dynrela section for each patched function. Is that 
correct? (and can you tell us what the reason for the change was? It might 
be crucial because I might be missing something.). Which leads us to your 
proposal...

2. So we have several dynrela section for one patched object. During init 
function in a patch module kpatch once again builds needed structures from 
these sections. Now they are called klp_reloc_sec and contain different 
kind of info. There is no val, loc and such, only name of the symbol, 
objname and index to dynrela section in ELF. So when you need to write 
relocations for the patched object you go through all relevant dynrela 
sections (because they are stored in the klp_object), all dynrela records 
in each section and you resolve the undefined symbols. All needed info is 
stored in ELF. Then you just call apply_relocate_add().

3. I propose to go one step further. I think we don't need klp_reloc_sec 
if there is only one dynrela section for patched object (and I currently 
cannot see why this is not possible. It is possible even with one dynrela 
section for whole patch module, that is for all patched objects.).

In my proposal there would be nothing done in init function of the patched 
module (albeit some optimization mentioned later). When you call 
klp_write_object_relocations you would go through all ELF section and find 
the relevant one for the object (it is marked with SHF_RELA_LIVEPATCH and 
objname is in the name of the section. It is the same thing you do in 2. 
in the init function.). Then you go through all dynrela records in the 
section, you do the same things which you do in the proposed patch above, 
and call apply_relocate_add.

Now it would be crazy to go through all sections each time 
klp_write_object_relocations is called (maybe it does not even matter but 
nevertheless). So klp_object could have an index to its ELF dynrela 
section. This index can be retrieved in the init function the same way you 
do all the stuff with klp_reloc_sec.

If you insisted on more than one dynrela section for a patched object we 
could have an array of indices there. Or whatever.

It is almost the same as your proposal but in my opinion somewhat nicer. 
We just use the info stored in ELF directly without unnecessary middle 
layer (== klp_reloc_sec).

Does it make sense? I hope it does. Would it work?

Miroslav
