From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC PATCH v3 4/6] livepatch: reuse module loader code to write
 relocations
Date: Mon, 11 Jan 2016 14:53:12 -0600
Message-ID: <20160111205312.GA17874@treble.redhat.com>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
 <1452281304-28618-5-git-send-email-jeyu@redhat.com>
 <20160111165613.GL731@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160111165613.GL731@pathway.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 11, 2016 at 05:56:13PM +0100, Petr Mladek wrote:
> On Fri 2016-01-08 14:28:22, Jessica Yu wrote:
> > Reuse module loader code to write relocations, thereby eliminating the need
> > for architecture specific relocation code in livepatch. Namely, we reuse
> > apply_relocate_add() in the module loader to write relocations instead of
> > duplicating functionality in livepatch's klp_write_module_reloc(). To apply
> > relocation sections, remaining SHN_LIVEPATCH symbols referenced by relocs
> > are resolved and then apply_relocate_add() is called to apply those
> > relocations.
> > 
> > In addition, remove x86 livepatch relocation code. It is no longer needed
> > since symbol resolution and relocation work have been offloaded to module
> > loader.
> > 
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -204,74 +207,70 @@ static int klp_find_object_symbol(const char *objname, const char *name,
> >  	return -EINVAL;
> >  }
> >  
> > -/*
> > - * external symbols are located outside the parent object (where the parent
> > - * object is either vmlinux or the kmod being patched).
> > - */
> > -static int klp_find_external_symbol(struct module *pmod, const char *name,
> > -				    unsigned long *addr)
> > +static int klp_resolve_symbols(Elf_Shdr *relsec, struct module *pmod)
> >  {
> > -	const struct kernel_symbol *sym;
> > +	int i, len, ret = 0;
> > +	Elf_Rela *relas;
> > +	Elf_Sym *sym;
> > +	char *symname, *sym_objname;
> >  
> > -	/* first, check if it's an exported symbol */
> > -	preempt_disable();
> > -	sym = find_symbol(name, NULL, NULL, true, true);
> > -	if (sym) {
> > -		*addr = sym->value;
> > -		preempt_enable();
> > -		return 0;
> > +	relas = (Elf_Rela *) relsec->sh_addr;
> > +	/* For each rela in this .klp.rel. section */
> > +	for (i = 0; i < relsec->sh_size / sizeof(Elf_Rela); i++) {
> > +		sym = pmod->core_symtab + ELF_R_SYM(relas[i].r_info);
> > +		symname = pmod->core_strtab + sym->st_name;
> > +
> > +		len = strcspn(symname + KLP_TAG_LEN, ".");
> 
> We should check that len is non-zero. Otherwise, sym_objname might
> be empty string and symname might overflow below.
> 
> Also we should check that symname really starts with .klp.sym. to
> avoid invalid memory access.

It would also be good to check for SHN_LIVEPATCH.

-- 
Josh
