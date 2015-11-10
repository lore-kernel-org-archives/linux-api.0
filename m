From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v3] livepatch: old_name,number scheme in livepatch sysfs
 directory
Date: Tue, 10 Nov 2015 09:49:09 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511100944120.16914@pobox.suse.cz>
References: <20151105155656.GD28254@treble.redhat.com> <1447085770-11729-1-git-send-email-chris.j.arges@canonical.com> <20151109205608.GC3914@treble.redhat.com> <564125BE.2090604@canonical.com> <20151110045434.GB18117@treble.hsd1.ky.comcast.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151110045434.GB18117@treble.hsd1.ky.comcast.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Chris J Arges <chris.j.arges@canonical.com>, live-patching@vger.kernel.org, jeyu@redhat.com, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 9 Nov 2015, Josh Poimboeuf wrote:

> On Mon, Nov 09, 2015 at 05:01:18PM -0600, Chris J Arges wrote:
> > On 11/09/2015 02:56 PM, Josh Poimboeuf wrote:
> > > I'd recommend splitting this up into two separate patches:
> > > 
> > > 1. introduce old_sympos
> > > 2. change the sysfs interface
> > > 
> > > On Mon, Nov 09, 2015 at 10:16:05AM -0600, Chris J Arges wrote:
> > >> In cases of duplicate symbols in vmlinux, old_sympos will be used to
> > >> disambiguate instead of old_addr. Normally old_sympos will be 0, and
> > >> default to only returning the first found instance of that symbol. If an
> > >> incorrect symbol position is specified then livepatching will fail.
> > > 
> > > In the case of old_sympos == 0, instead of just returning the first
> > > symbol it finds, I think it should ensure that the symbol is unique.  As
> > > Miroslav suggested:
> > > 
> > >   0 - default, preserve more or less current behaviour. If the symbol is 
> > >       unique there is no problem. If it is not the patching would fail.
> > >   1, 2, ... - occurrence of the symbol in kallsyms.
> > >   
> > >   The advantage is that if the user does not care and is certain that the 
> > >   symbol is unique he doesn't have to do anything. If the symbol is not 
> > >   unique he still has means how to solve it.
> > > 
> > 
> > So one part that will be confusing here is as follows.
> > 
> > If '0' is specified for old_sympos, should the symbol be 'func_name,0'
> > or 'func_name,1' provided we have a unique symbol? We could also default
> > to 'what the user provides', but this seems odd.
> 
> I don't feel strongly either way, but I think using the same number the
> user provides is fine, since it makes the sysfs interface consistent
> with the old_sympos usage.

I think it should be func_name,1 even if '0' is specified and the symbol 
is unique. Because if we say that 1, 2, ... is the occurrence of the 
symbol in kallsyms it should stay that way everywhere. Hence for 
old_sympos == 0 it is func_name,1 in sysfs; for 1 it is still func_name,1; 
for 2 it is func_name,2 and so on.

And I'd add this to sysfs documentation.

> > Another option would be to use no postfix when 0 is given, and only
> > introduce the ',n' postfix if old_sympos is > 0.
> 
> IMO always having a suffix is good, as it makes parsing less surprising
> and less error-prone.

Agreed.

> > >>  static int klp_write_object_relocations(struct module *pmod,
> > >> @@ -307,7 +318,7 @@ static int klp_write_object_relocations(struct module *pmod,
> > >>  			else
> > >>  				ret = klp_find_object_symbol(obj->mod->name,
> > >>  							     reloc->name,
> > >> -							     &reloc->val);
> > >> +							     &reloc->val, 0);
> > > 
> > > I think it would be a good idea to also add old_sympos to klp_reloc so
> > > the relocation code is consistent with the klp_func symbol addressing.
> > >
> > 
> > So you are thinking as an optional external field as well? I'll have to
> > look at this a bit more but makes sense to me.
> 
> Yeah, the semantics would be the same as klp_func.old_sympos.  We could
> add a new klp_reloc.sympos and make klp_reloc.val a private field.

Agreed as well.

Miroslav
