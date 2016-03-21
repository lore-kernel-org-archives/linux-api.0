From: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/6] livepatch: reuse module loader code to write
 relocations
Date: Mon, 21 Mar 2016 11:46:51 -0500
Message-ID: <20160321164651.zautqklg7ng3jfbn@treble.redhat.com>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
 <1458157628-8264-5-git-send-email-jeyu@redhat.com>
 <20160321163157.GG19401@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160321163157.GG19401-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 21, 2016 at 05:31:57PM +0100, Petr Mladek wrote:
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 780f00c..2aa20fa 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > +static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
> > +{
> > +	int i, cnt, vmlinux, ret;
> > +	struct klp_buf bufs = {0};
> > +	Elf_Rela *relas;
> > +	Elf_Sym *sym;
> > +	char *symname;
> > +	unsigned long sympos;
> > +
> > +	relas = (Elf_Rela *) relasec->sh_addr;
> > +	/* For each rela in this klp relocation section */
> > +	for (i = 0; i < relasec->sh_size / sizeof(Elf_Rela); i++) {
> > +		sym = pmod->core_kallsyms.symtab + ELF_R_SYM(relas[i].r_info);
> > +		if (sym->st_shndx != SHN_LIVEPATCH)
> > +			return -EINVAL;
> > +
> > +		klp_clear_buf(&bufs);
> > +
> > +		/* Format: .klp.sym.objname.symbol_name,sympos */
> > +		symname = pmod->core_kallsyms.strtab + sym->st_name;
> > +		cnt = sscanf(symname, ".klp.sym.%64[^.].%128[^,],%lu",
> > +			     bufs.objname, bufs.symname, &sympos);
> 
> Note that MODULE_NAME_LEN even is not 64. It is defined by:
> 
> #define MAX_PARAM_PREFIX_LEN (64 - sizeof(unsigned long))
> 
> I strongly suggest to use the proposal from Josh.

Hm, looks like my suggestion to use __stringify(MODULE_NAME_LEN) doesn't
work.  It results in the string "MODULE_NAME_LEN".  Which surprises me:
isn't is supposed to resolve the macro before applying the '#' operation
to it?

I was going to suggest another idea: hard-code it at 63 and then do
something like

  BUILD_BUG_ON(MODULE_NAME_LEN != 64)

But you're right... it's not even 64!

Need to think on this some more...

-- 
Josh
