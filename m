From: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v2 4/6] livepatch: reuse module loader code to write
 relocations
Date: Thu, 10 Dec 2015 15:12:32 -0600
Message-ID: <20151210211232.GB4934@treble.redhat.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-5-git-send-email-jeyu@redhat.com>
 <20151210142032.GA2399@huangminfeis-MacBook-Pro.local>
 <alpine.LNX.2.00.1512102055180.9922@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1512102055180.9922-YHPUNQjx9ReKbouaWp301Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Minfei Huang <mnfhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 10, 2015 at 08:56:27PM +0100, Jiri Kosina wrote:
> On Thu, 10 Dec 2015, Minfei Huang wrote:
> 
> > > +	klp_for_each_reloc_sec(obj, reloc_sec) {
> > > +		relindex = reloc_sec->index;
> > > +		num_relas = pmod->sechdrs[relindex].sh_size / sizeof(Elf_Rela);
> > > +		rela = (Elf_Rela *) pmod->sechdrs[relindex].sh_addr;
> > > +
> > > +		/* For each rela in this __klp_rela section */
> > > +		for (i = 0; i < num_relas; i++, rela++) {
> > > +			sym = symtab + ELF_R_SYM(rela->r_info);
> > > +			symname = pmod->core_strtab + sym->st_name;
> > > +
> > > +			if (sym->st_shndx == SHN_LIVEPATCH) {
> > > +				if (sym->st_info == 'K')
> > > +					ret = klp_find_external_symbol(pmod, symname, &addr);
> > > +				else
> > > +					ret = klp_find_object_symbol(obj->name, symname, &addr);
> > > +				if (ret)
> > > +					return ret;
> > > +				sym->st_value = addr;
> > > +			}
> > >  		}
> > > +		ret = apply_relocate_add(pmod->sechdrs, pmod->core_strtab,
> > > +					 pmod->index.sym, relindex, pmod);
> > 
> > It is more appropiate to test the ret.
> 
> And if error is encountered ... then you'd propose to do what?
> 
> The code is correct as is; the return value is propagated properly to 
> caller, and all the existing callers have proper error handling.

apply_relocate_add() is called from inside a loop, so if there's an
error, it should return immediately instead of continuing the next
iteration.

-- 
Josh
