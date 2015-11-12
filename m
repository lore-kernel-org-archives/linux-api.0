From: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: samples: livepatch: init reloc list and mark as klp module
Date: Thu, 12 Nov 2015 11:44:50 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511121140240.9440@pobox.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com> <1447130755-17383-5-git-send-email-jeyu@redhat.com> <20151111154249.GQ2599@pathway.suse.cz> <20151112060249.GA5841@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151112060249.GA5841-N0bYjD2NfQ6k4hzjq3hgyGTy53QMssKEsp+A89P3RPuQWHG76I6BsA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 12 Nov 2015, Jessica Yu wrote:

> +++ Petr Mladek [11/11/15 16:42 +0100]:
> > On Mon 2015-11-09 23:45:54, Jessica Yu wrote:
> > > Intialize the list of relocation sections in the sample
> > > klp_object (even if the list will be empty in this case).
> > > Also mark module as a livepatch module so that the module
> > > loader can appropriately initialize it.
> > > 
> > > Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  samples/livepatch/livepatch-sample.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/samples/livepatch/livepatch-sample.c
> > > b/samples/livepatch/livepatch-sample.c
> > > index fb8c861..2ef9345 100644
> > > --- a/samples/livepatch/livepatch-sample.c
> > > +++ b/samples/livepatch/livepatch-sample.c
> > > @@ -89,3 +90,4 @@ static void livepatch_exit(void)
> > >  module_init(livepatch_init);
> > >  module_exit(livepatch_exit);
> > >  MODULE_LICENSE("GPL");
> > > +MODULE_INFO(livepatch, "Y");
> > 
> > This looks a bit error prone. I wonder if we could detect this
> > information another way. For example, by a check for the
> > livepatch-related elf sections. If it is missing,
> > we do not need to preserve struct load_info even
> > when it is a livepatch.
> 
> Yeah, I agree that it is unnecessary for a livepatch module without
> reloc secs to keep a copy of the load_info struct. My justification
> for using MODULE_INFO is that I was trying to be consistent with the
> way how other module "characteristics" are checked in the module
> loader. For example, if the module came from the staging tree, the
> module loader simply checks get_modinfo(info, "staging")). If the
> module is a livepatch module, we check get_modinfo(info,
> "livepatch")). I also thought that it might be useful additional
> information for the user to be able to issue the modinfo command on a
> module to see if it's a livepatch module or not (but maybe this
> information won't be so useful after all, that's quite subjective).

Yup, in my opinion this is a good way to do it. We already impose quite a 
lot on a patch module and this does not make a big difference. Easy 
identification of a patch module is good bonus as well.

> But if we want to do a more thorough check, we could, like you said,
> check for the livepatch-related elf sections before copying load_info.

I wouldn't do that. It could be even more error prone.

I'd like to think that we can live with load_info struct even for patch 
modules which do not use relocations. Don't know.

Miroslav
