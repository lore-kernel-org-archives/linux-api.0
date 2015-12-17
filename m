From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: module: s390: keep mod_arch_specific for livepatch modules
Date: Thu, 17 Dec 2015 12:39:28 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1512171235550.28399@pobox.suse.cz>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com> <1448943679-3412-4-git-send-email-jeyu@redhat.com> <alpine.LNX.2.00.1512161257170.25787@pobox.suse.cz> <20151216234828.GB29092@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151216234828.GB29092@packer-debian-8-amd64.digitalocean.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 16 Dec 2015, Jessica Yu wrote:

> +++ Miroslav Benes [16/12/15 13:02 +0100]:
> > On Mon, 30 Nov 2015, Jessica Yu wrote:
> > 
> > > Livepatch needs to utilize the symbol information contained in the
> > > mod_arch_specific struct in order to be able to call the s390
> > > apply_relocate_add() function to apply relocations. Remove the redundant
> > > vfree() in module_finalize() since module_arch_freeing_init() (which also
> > > frees
> > > said structures) is called in do_init_module(). Keep a reference to
> > > syminfo if
> > > the module is a livepatch module and free the structures in
> > > module_arch_cleanup(). If the module isn't a livepatch module, we free the
> > > structures in module_arch_freeing_init() as usual.
> > > 
> > > Signed-off-by: Jessica Yu <jeyu@redhat.com>
> > > ---
> > >  arch/s390/kernel/module.c | 13 +++++++++++--
> > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
> > > index 0c1a679..17a1979 100644
> > > --- a/arch/s390/kernel/module.c
> > > +++ b/arch/s390/kernel/module.c
> > > @@ -51,6 +51,9 @@ void *module_alloc(unsigned long size)
> > > 
> > >  void module_arch_freeing_init(struct module *mod)
> > >  {
> > > +	if (mod->klp)
> > > +		return;
> > > +
> > >  	vfree(mod->arch.syminfo);
> > >  	mod->arch.syminfo = NULL;
> > >  }
> > 
> > Hm, this is problematic. module_arch_freeing_init() is called from
> > module_deallocate() and this is called in the error path in load_module().
> > So if there was an error during load_module() of livepatch module which
> > led to free_modinfo label or behind mod->arch.syminfo would not be freed
> > at all. module_arch_cleanup() is called earlier under
> > free_arch_cleanup.
> 
> Gah. Good catch. How about we add an additional check to see if
> mod->state is MODULE_STATE_LIVE? If so, we can return. This means
> we're coming from do_init_module(). If module_arch_freeing_init() was
> called and the module was in a state other than MODULE_STATE_LIVE
> (UNFORMED, GOING, COMING), we know we need to free. Think that would
> work?

It would I think. module_arch_freeing_init is called thrice.

1. in free_module(). The module is in UNFORMED state so everything is 
fine.

2. in module_deallocate(). The module is not LIVE yet here so ok as well.

3. in do_init_module() and the module is LIVE there.

So yes, you are right, that should work.

Miroslav
