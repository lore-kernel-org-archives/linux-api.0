From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Thu, 14 Jan 2016 10:04:11 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1601140958300.7127@pobox.suse.cz>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com> <1452281304-28618-5-git-send-email-jeyu@redhat.com> <alpine.LNX.2.00.1601121729480.15984@pobox.suse.cz> <20160114034933.GB980@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160114034933.GB980@packer-debian-8-amd64.digitalocean.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 13 Jan 2016, Jessica Yu wrote:

> > Maybe it would be better to use pmod->symtab and pmod->strtab everywhere.
> > It should be the same, but core_* versions are only helpers used in
> > load_module and friends. There is even a comment in
> > include/linux/module.h.
> > 
> > 	/*
> > 	 * We keep the symbol and string tables for kallsyms.
> > 	 * The core_* fields below are temporary, loader-only (they
> > 	 * could really be discarded after module init).
> > 	 */
> > 
> > We should respect that.
> 
> I admit I'm a bit confused by the comment, I can't seem to find where
> core_symtab and core_strtab are purportedly discarded after module
> init (perhaps I'm missing something?). IMO it sounds more like it's
> describing mod->symtab and mod->strtab instead, because these are in
> module init memory and are freed later. 

I think it just says that core_* symbols are used as temporary tables 
during module loading. They are not discarded anywhere but they could be 
(and maybe they'll be in the future). So it is better not to depend on 
them.

> In any case, my reason for using
> core_symtab is that the original symbol table (mod->symtab) is marked
> with INIT_OFFSET_MASK in layout_symtab() (see kernel/module.c), and is
> therefore in init memory. This memory is freed near the end of
> do_init_module() with do_free_init(). Since core_symtab is in module core
> memory, for livepatch modules I simply used core_symtab to hold a
> full copy of the symbol table instead of the slimmed down version that
> it was originally intended to hold.

But both mod->symtab and mod->strtab are changed to point to their core_ 
versions right before do_free_init is called in do_init_module. So they 
should be the same. My remark was more of an academic question. I believe 
it is not a functional thing, just the matter of taste. But maybe I am 
missing something.

> Alternatively, we can tweak layout_symtab() to *not* mark the symtab
> with INIT_OFFSET_MASK and put it in core memory instead. I think
> either way will work, but maybe it is cleaner to do it this way
> instead.

Yeah, I wouldn't do this. core_* symbols are ok from functional point of 
view.

Thanks,
Miroslav
