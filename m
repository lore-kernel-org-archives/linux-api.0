From: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: module: save load_info for livepatch modules
Date: Mon, 16 Nov 2015 13:21:44 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511161313200.24384@pobox.suse.cz>
References: <1447130755-17383-3-git-send-email-jeyu@redhat.com> <alpine.LNX.2.00.1511111505300.12467@pobox.suse.cz> <20151112053228.GD30025@packer-debian-8-amd64.digitalocean.com> <20151112102404.GL4431@pathway.suse.cz> <alpine.LNX.2.00.1511121400290.9440@pobox.suse.cz>
 <20151112150345.GT2599@pathway.suse.cz> <20151112170501.GD4038@treble.hsd1.ky.comcast.net> <20151112221750.GA13513@packer-debian-8-amd64.digitalocean.com> <alpine.LNX.2.00.1511131304280.15073@pobox.suse.cz> <alpine.LNX.2.00.1511131353300.15073@pobox.suse.cz>
 <20151114020950.GA21414@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151114020950.GA21414-N0bYjD2NfQ6k4hzjq3hgyGTy53QMssKEsp+A89P3RPuQWHG76I6BsA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 13 Nov 2015, Jessica Yu wrote:

> +++ Miroslav Benes [13/11/15 13:56 +0100]:
> > On Fri, 13 Nov 2015, Miroslav Benes wrote:
> > 
> > > I agree this seems like the best approach. So if we preserve
> > > mod_arch_syminfo (in case of s390) we should free it not in
> > > module_finalize, but somewhere in free_module... where
> > > module_arch_cleanup() is called... and also module_arch_freeing_init() is
> > > called there too. And what you find there for s390 is
> > > 
> > > 	vfree(mod->arch.syminfo);
> > > 	mod->arch.syminfo = NULL;
> > > 
> > > Well, it does nothing here, because mod->arch.syminfo is already NULL. It
> > > was freed in module_finalize. So we can even remove this code from
> > > module_finalize and all should be fine. At least for s390.
> > 
> > Which is not true because module_arch_freeing_init is also called from
> > do_init_module, called from load_module. So we should move it to
> > module_arch_cleanup.
> > 
> > That code is like a maze without Ariadne's thread.
> 
> Heh, I agree with that sentiment.
> 
> I am slightly confused about the s390 code, and whether the authors
> originally intended for that double vfree() to happen in both
> module_finalize() and module_arch_freeing_init() (called from
> do_init_module). Seems like a mistake. If module load succeeds,
> do_init_module calls module_arch_freeing_init(). And if load_module
> fails halfway through, both module_deallocate() and free_module() will
> also call module_arch_freeing_init(). 

It seems like the authors are aware of this. At least the authors of 
general module code :). See comment in free_module()

 /* This may be NULL, but that's OK */

It is ok, because vfree checks if the pointer is NULL. 

> I feel like that vfree should
> only happen once in module_arch_freeing_init() and not in
> module_finalize(). If we can remove the double vfree() code from
> module_finalize(), we can copy the mod_arch_specific safely before the
> call to do_init_module().

Yes, I think so.

Miroslav
