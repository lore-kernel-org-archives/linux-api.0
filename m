From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Thu, 14 Jan 2016 10:10:16 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1601141004590.7127@pobox.suse.cz>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com> <1452281304-28618-5-git-send-email-jeyu@redhat.com> <alpine.LNX.2.00.1601131012340.10011@pobox.suse.cz> <20160113183924.GA980@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160113183924.GA980@packer-debian-8-amd64.digitalocean.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 13 Jan 2016, Jessica Yu wrote:

> +++ Miroslav Benes [13/01/16 10:19 +0100]:
> > On Fri, 8 Jan 2016, Jessica Yu wrote:
> > 
> > >  static int klp_write_object_relocations(struct module *pmod,
> > >  					struct klp_object *obj)
> > >  {
> > > -	int ret = 0;
> > > -	unsigned long val;
> > > -	struct klp_reloc *reloc;
> > > +	int i, len, ret = 0;
> > > +	char *secname;
> > > +	const char *objname;
> > > 
> > >  	if (WARN_ON(!klp_is_object_loaded(obj)))
> > >  		return -EINVAL;
> > > 
> > > -	if (WARN_ON(!obj->relocs))
> > > -		return -EINVAL;
> > > +	objname = klp_is_module(obj) ? obj->name : "vmlinux";
> > > 
> > >  	module_disable_ro(pmod);
> > > +	/* For each klp rela section for this object */
> > > +	for (i = 1; i < pmod->info->hdr->e_shnum; i++) {
> > > +		if (!(pmod->info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH))
> > > +			continue;
> > 
> > One more thing. If the module does not specify it is a live patch module
> > in modinfo (with MODULE_INFO(livepatch, "Y")), but it is a perfect live
> > patch module otherwise (it calls klp_register_patch in its init function),
> > the kernel crashes here. pmod->info is not initialized at all. This should
> > be fixed. Perhaps the easiest would be to call
> > klp_write_object_relocations() in klp_init_object_loaded() only if
> > is_livepatch_module() returns true. Similar to a check for obj->relocs
> > before.
> 
> Hm yes, that's a problem. To remedy this, I think it makes sense to
> require all livepatch modules to identify themselves with the modinfo
> attribute, since it is a very simple requirement. If some module calls
> klp_register_patch() and it does not have the livepatch attribute,
> klp_register_patch() can just return an error. We can call
> is_livepatch_module() at the beginning of klp_register_patch(), and
> proceed only if the check succeeds, since we'll then know that the
> required structures have been properly initialized in the module
> loader. What do you think?

This is similar to what Jiri proposed in his mail. It is up to you. Both 
ways (the warning and the check, or what you propose) are fine.

Miroslav
