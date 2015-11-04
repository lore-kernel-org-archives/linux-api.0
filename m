From: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] livepatch: old_name.number scheme in livepatch sysfs
 directory
Date: Wed, 4 Nov 2015 10:52:52 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511041047200.5621@pobox.suse.cz>
References: <20151102203241.GF27488@treble.redhat.com> <1446505187-28970-1-git-send-email-chris.j.arges@canonical.com> <alpine.LNX.2.00.1511031146070.6257@pobox.suse.cz> <20151103145843.GH27488@treble.redhat.com> <alpine.LNX.2.00.1511031705340.6257@pobox.suse.cz>
 <20151103165058.GM27488@treble.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151103165058.GM27488-8wJ5/zUtDR0XGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 3 Nov 2015, Josh Poimboeuf wrote:

> On Tue, Nov 03, 2015 at 05:09:48PM +0100, Miroslav Benes wrote:
> > On Tue, 3 Nov 2015, Josh Poimboeuf wrote:
> > 
> > > On Tue, Nov 03, 2015 at 11:52:08AM +0100, Miroslav Benes wrote:
> > > > 
> > > > There is a problem which I missed before. klp_init_func() is called before 
> > > > klp_find_verify_func_addr() in klp_init_object(). This means that 
> > > > func->old_addr is either not verified yet or worse it is still 0. This 
> > > > means that klp_get_func_pos_callback() never returns 1 and is thus called 
> > > > on each symbol. So if you for example patched cmdline_proc_show the 
> > > > resulting directory in sysfs would be called cmdline_proc_show,1 because 
> > > > addr is never matched. Had old_addr been specified the name would have 
> > > > been probably correct, but not for sure.
> > > > 
> > > > This should be fixed as well.
> > > 
> > > Even worse, klp_init_func() can be called even if the object hasn't been
> > > loaded.  In that case there's no way to know what the value of n is, and
> > > therefore no way to reliably create the sysfs entry.
> > 
> > Ah, right.
> > 
> > > Should we create "func,n" in klp_init_object_loaded() instead of
> > > klp_init_func()?
> > 
> > So that the function entries in sysfs would be created only when the 
> > object is loaded? Well, why not, but in that case it could easily confuse 
> > the user.
> 
> Maybe, but I think it would be fine if we document it.  It should only
> be relied on by tools, anyway.

Agreed.

> > Object entry would be empty for not loaded object. I would not 
> > dare to propose to remove such object entries. It would make things worse. 
> 
> Why would removing an empty object entry make things worse?

I think it all comes down to a question whether the sysfs entries say what 
a patch is capable to patch or what this patch is currently patching in 
the system. I am inclined to the former so the removal would make me 
nervous. But I am not against the second approach. We are still in testing 
mode as far as sysfs is concerned so we can try even harsh changes and see 
how it's gonna go.

> > So maybe we could introduce an attribute in sysfs object entry which would 
> > say if the object is loaded or not. Or something like that.
> 
> Hm, I'm not sure I see how this would help.

Hopefully I cleared this up with the above.

Miroslav
