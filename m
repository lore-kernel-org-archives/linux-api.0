From: Jessica Yu <jeyu@redhat.com>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Thu, 10 Dec 2015 16:33:29 -0500
Message-ID: <20151210213328.GA6553@packer-debian-8-amd64.digitalocean.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-5-git-send-email-jeyu@redhat.com>
 <20151208183844.GC14846@treble.redhat.com>
 <20151209191013.GA25387@packer-debian-8-amd64.digitalocean.com>
 <20151210142830.GA29872@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151210142830.GA29872@treble.redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Josh Poimboeuf [10/12/15 08:28 -0600]:
>On Wed, Dec 09, 2015 at 02:10:14PM -0500, Jessica Yu wrote:
>> +++ Josh Poimboeuf [08/12/15 12:38 -0600]:
>> >>+	/* For each __klp_rela section for this object */
>> >>+	klp_for_each_reloc_sec(obj, reloc_sec) {
>> >>+		relindex = reloc_sec->index;
>> >>+		num_relas = pmod->sechdrs[relindex].sh_size / sizeof(Elf_Rela);
>> >>+		rela = (Elf_Rela *) pmod->sechdrs[relindex].sh_addr;
>> >>+
>> >>+		/* For each rela in this __klp_rela section */
>> >>+		for (i = 0; i < num_relas; i++, rela++) {
>> >>+			sym = symtab + ELF_R_SYM(rela->r_info);
>> >>+			symname = pmod->core_strtab + sym->st_name;
>> >>+
>> >>+			if (sym->st_shndx == SHN_LIVEPATCH) {
>> >>+				if (sym->st_info == 'K')
>> >>+					ret = klp_find_external_symbol(pmod, symname, &addr);
>> >>+				else
>> >>+					ret = klp_find_object_symbol(obj->name, symname, &addr);
>> >>+				if (ret)
>> >>+					return ret;
>> >>+				sym->st_value = addr;
>> >
>> >So I think you're also working on removing the 'external' stuff.  Any
>> >idea how this code will handle that?  Specifically I'm wondering how the
>> >objname and sympos of the rela's symbol will be specified.  Maybe it can
>> >be encoded somehow in one of the symbol fields (st_value)?
>>
>> Thanks for bringing this up. I think we can just encode the symbol's
>> position in kallsyms in the symbol's st_other field. It isn't used
>> anywhere and has size char, which is plenty of bits to represent the
>> small ints.
>
>st_other does seem to at least have some trivial usage in the kernel,
>see print_absolute_symbols() and sym_visibility() in
>arch/x86/tools/relocs.c.  Two of the bits are used to specify the
>"visibility" of a symbol.  Also readelf shows a "Vis" column in the
>symbol table.

Yeah, for x86 it looks like st_other is used only for SHN_ABS symbols
in print_absolute_symbols(). Technically SHN_LIVEPATCH symbols
shouldn't be affected in this case...but despite its sparse usage in the
kernel it does look like using st_other to encode sympos is out of the
question as its meaning is architecture specific..

>> For objname, the simplest solution might be to append ".klp.objname"
>> to the symbol name, and extract out this suffix when resolving the
>> symbol. Another way might be to have st_value contain the index into
>> the strtab (or .kpatch.strings) that contains the objname. Then we'd
>> access the objname just like how we access the symbol's name (strtab +
>> sym->st_name). After we find the objname we can then overwrite
>> st_value with the real address. I think this second method is cleaner.
>> Thoughts?
>
>Yeah, I guess there are a lot of possibilities for ways to encode it.
>
>Personally I think it would be nice if the encoding were something that
>could easily be seen when dumping the symbol table with readelf.  So,
>for example, the objname could be encoded in the symbol name (as you
>suggested), and the sympos could be in st_value.

Sure, that should be doable. So the new process might look like this:

For every livepatch symbol referenced by a rela..

1) Save the sympos encoded in st_value

2) Save the sym_objname that is encoded in the symbol's name with the
'klp' suffix (Just to clarify: the sym_objname specifies the object
in which the symbol lives, and recall that we need this to remove the
need for the "external" flag)

3) Resolve the symbol by using its name (without the klp suffix),
sympos, and sym_objname

4) Set st_value to the found address

>If we do that, it'd probably be good to keep the naming consistent with
>the '__klp_rela_objname.symname' thing.  So something like
>'_klp_sym_objname.symname'.

How about 'symname.klp.objname', and renaming the klp reloc sections
to '.klp.objname.rela.section_name'? Special symbol suffixes and
section names seem to always use '.', so maybe this would look better?
:-) But we can keep the underscores if people like that more. Both
naming methods would work, it is only a matter of preference.

>But... would there be any side effects associated with renaming it?  For
>example, would it cause problems with the s390 PLT?


