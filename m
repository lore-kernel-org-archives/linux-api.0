From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Wed, 16 Dec 2015 13:59:30 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1512161342140.25787@pobox.suse.cz>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com> <1448943679-3412-5-git-send-email-jeyu@redhat.com> <20151208183844.GC14846@treble.redhat.com> <20151209191013.GA25387@packer-debian-8-amd64.digitalocean.com>
 <20151216054048.GA28258@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20151216054048.GA28258@packer-debian-8-amd64.digitalocean.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 16 Dec 2015, Jessica Yu wrote:

> +++ Jessica Yu [09/12/15 14:10 -0500]:
> > +++ Josh Poimboeuf [08/12/15 12:38 -0600]:
> > > 
> > > There was a lot of discussion for v1, so I'm not sure, but I thought we
> > > ended up deciding to get rid of the klp_reloc_sec struct?  Instead I
> > > think the symbol table can be walked directly looking for klp rela
> > > sections?
> > > 
> > > The benefits of doing so would be to make the interface simpler -- no
> > > need to "cache" the section metadata when it's already easily and
> > > quickly available in the module struct elf section headers.
> > 
> > Ah, I might have interpreted the conclusions of that last discussion
> > incorrectly.
> > 
> > In that case, I think I can just get rid of my klp_for_each_reloc_sec
> > macro as well as the lreloc scaffolding code from kpatch. The only
> > potentially "ugly" part of this change is that I'll have to move the
> > string parsing stuff here to extract the objname of the __klp_rela
> > section (which may not actually look that bad, we'll see how that
> > turns out).

Yes, that was a conclusion we made. At least I thought so :)

> Turns out the string parsing stuff, even with the help of lib/string.c,
> doesn't
> look very pretty. As I'm working on v3, I'm starting to think having
> klp_write_object_relocations() loop simply through all the elf sections might
> not be a good idea. Let me explain.

Hm, I still think it is worth it...

> I don't like the amount of string manipulation code that would potentially
> come
> with this change. Even with a string as simple as ".klp.rela.objname", we'll
> end up with a bunch of kstrdup's/kmalloc's and kfree's (unless we modify and
> chop the section name string in place, which I don't think we should do) that
> are going to be required at every iteration of the loop, all just to be able
> to
> call strcmp() and see if we're dealing with a klp rela section that belongs to
> the object in question. This also leads to more complicated error handling.

But this shouldn't be much different from what init function of the patch 
module does now, right? You have a klp_extract_objname() which I thought 
could be moved right to livepatch code.

> In v1, the string parsing was done only *once* for each klp rela section in
> the
> patch module code, and each klp rela section is sorted into their respective
> object with the reloc_secs list. Then all klp_write_object_relocations() had
> to
> do is iterate over object->reloc_secs. The tradeoff here is the addition of
> another struct (klp_reloc_sec), but that is not nearly as bad as string
> parsing, which is imo way more error prone and is unnecessary extra work.

If it is a problem (and Josh thought it was not if I recall correctly) we 
can cache indices to relevant rela sections in klp_object as we discussed 
in v1.
 
> Here's some pseudocode to help visualize the potential issues:
> 
> function klp_write_object_relocations(..,struct klp_object *obj,..) {
>    for each section in mod->sechdrs { // iterate through all elf sections, no
> more obj->reloc_secs list
>        if not a klp rela section
>            continue;
>        sec_objname = extract_objname_from_section(section);  //
> .klp.rela.[objname].sectionname
>        if (strcmp(sec_objname, obj->name)) { // this klp rela section doesn't
> belong to this object
>            kfree(sec_objname);
>            continue;
>        }
> 
>      for each rela in this klp rela section {
>         sym = symtab + ELF_R_SYM(rela->r_info);
>         sym_objname = extract_objname_from_symbol(sym) //
> symname.klp.[objname]

This is because of 'external' stuff, right?

>         if (!sym_objname)
>             goto handle_error; // calls kfree(sec_objname);
>         symname = extract_symname_from_symbol(sym); // [symname].klp.objname

Can't we use a method from the patch? That is 

symname = pmod->core_strtab + sym->st_name;

>         if (!symname)
>             goto handle_error; // calls kfree(sec_objname);
>         ret = klp_find_object_symbol(sym_objname, symname, &addr)
>         if (ret)
>             goto handle_error2; // calls kfree(symname), then
> kfree(sec_objname)
> 
> ...etc., you get the idea how messy that is getting, and we haven't even
> reached the call to apply_relocate_add() yet.
> 
> So I personally think it is better to keep the old v1 way for applying the klp
> reloc secs. The sections are still named ".klp.rela.objname" but the parsing
> is
> done once in the patch module code and used only to build the patch
> scaffolding
> structure.
> 
> In order to avoid adding any additional string parsing code in v3, I no longer
> thing we should rename livepatch symbols to include the symbol objname (i.e.
> 'symbol.klp.objname'). Recall that this change is for getting rid of external
> dynrelas. Instead of parsing the symbol name, we could just encode 1) the
> sympos and 2) the index into the .kpatch.strings strtab (that contains the
> sym_objname) in sym->st_value. We define two masks (KLP_MASK_SYMPOS,
> KLP_MASK_OBJNAME) that extract these values. st_value has either a 32 bit or
> 64
> bit size, both of which are big enough sizes for the sympos and string table
> index. One perk we lose is being able to see which object a symbol belongs to
> in readelf, but then again we didn't have this benefit to begin with in
> v1 nor v2 (where we didn't know the symbol's object and had to use
> klp_find_external_symbol anyway), so I wouldn't say it's a loss.

Just a note. This would lead to another assumption about a patch 
module... .kpatch.strings. I suspect 'external' symbols are kpatch 
specific (I think I did not deal with it while working on relocations for 
kgraft. But I am not sure now. I haven't finished it too.), but let's try 
to make it "generic".

> Apologies for the super long explanations, but I think avoiding string parsing
> in livepatch core code will make the relocation code much more succinct and
> easier to read. Any objections or thoughts on all this?

My main argument is that the work needs to be done somewhere and there is 
no reason why not do it right in the kernel and not in patch modules. The 
code should be more or less the same and we'd get rid of unnecessary 
layers (klp_reloc_sec) as Josh pointed out.

Miroslav
