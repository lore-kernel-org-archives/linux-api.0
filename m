From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [RFC PATCH v3 4/6] livepatch: reuse module loader code to write
 relocations
Date: Wed, 13 Jan 2016 10:31:10 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1601131030380.3402@cbobk.fhfr.pm>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com> <1452281304-28618-5-git-send-email-jeyu@redhat.com> <alpine.LNX.2.00.1601131012340.10011@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1601131012340.10011@pobox.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
To: Miroslav Benes <mbenes@suse.cz>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 13 Jan 2016, Miroslav Benes wrote:

> >  {
> > -	int ret = 0;
> > -	unsigned long val;
> > -	struct klp_reloc *reloc;
> > +	int i, len, ret = 0;
> > +	char *secname;
> > +	const char *objname;
> >  
> >  	if (WARN_ON(!klp_is_object_loaded(obj)))
> >  		return -EINVAL;
> >  
> > -	if (WARN_ON(!obj->relocs))
> > -		return -EINVAL;
> > +	objname = klp_is_module(obj) ? obj->name : "vmlinux";
> >  
> >  	module_disable_ro(pmod);
> > +	/* For each klp rela section for this object */
> > +	for (i = 1; i < pmod->info->hdr->e_shnum; i++) {
> > +		if (!(pmod->info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH))
> > +			continue;
> 
> One more thing. If the module does not specify it is a live patch module 
> in modinfo (with MODULE_INFO(livepatch, "Y")), but it is a perfect live 
> patch module otherwise (it calls klp_register_patch in its init function), 

Side note: I think we should at least issue some light warning in such 
case anyway.

-- 
Jiri Kosina
SUSE Labs

