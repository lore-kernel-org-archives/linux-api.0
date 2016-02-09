From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH v4 2/6] module: preserve Elf information for
 livepatch modules
Date: Tue, 9 Feb 2016 13:31:48 +0100
Message-ID: <20160209123148.GB12548@pathway.suse.cz>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
 <1454548271-24923-3-git-send-email-jeyu@redhat.com>
 <20160209084443.GA12548@pathway.suse.cz>
 <alpine.LNX.2.00.1602091131510.22727@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1602091131510.22727-YHPUNQjx9ReKbouaWp301Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 2016-02-09 11:33:07, Jiri Kosina wrote:
> On Tue, 9 Feb 2016, Petr Mladek wrote:
> 
> > > +#ifdef CONFIG_KALLSYMS
> > > +	/* Make symtab and strtab available prior to module init call */
> > > +	mod->num_symtab = mod->core_num_syms;
> > > +	mod->symtab = mod->core_symtab;
> > > +	mod->strtab = mod->core_strtab;
> > > +#endif
> > 
> > This should be done with module_mutex. Otherwise, it looks racy at least 
> > against module_kallsyms_on_each_symbol().
> 
> Hmm, if this is the case, the comment describing the locking rules for 
> module_mutex should be updated.
> 
> > BTW: I wonder why even the original code is not racy for example against 
> > module_get_kallsym. It is called without the mutex. This code sets the 
> > number of entries before the pointer to the entries.
> > 
> > Note that the module is in the list even in the UNFORMED state.
> 
> module_kallsyms_on_each_symbol() gives up in such case though.

The problem is that we set the three values above in the COMMING
state. They were even set in the LIVE state before this patch.

IMHO, we should reorder the writes and add a write barrier.


#ifdef CONFIG_KALLSYMS
	/* Make symtab and strtab available prior to module init call */
	mod->strtab = mod->core_strtab;
	mod->symtab = mod->core_symtab;
	/* Tables must be availabe before the number is set */
	smp_wmb();
	mod->num_symtab = mod->core_num_syms;
#endif


Then we should add the corresponding read barrier to
the read functions that are protected only by
the disabled preeption. For example:


static unsigned long mod_find_symname(struct module *mod, const char *name)
{
	unsigned int i;

	for (i = 0; i < mod->num_symtab; i++)
		/* Make sure that tables are set for the read num_symtab */
		smp_rmb();
		if (strcmp(name, mod->strtab+mod->symtab[i].st_name) == 0 &&
		    mod->symtab[i].st_info != 'U')
			return mod->symtab[i].st_value;
	return 0;
}


Or am I too paranoid, please?

Best Regards,
Petr
