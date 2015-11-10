From: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] livepatch: old_name,number scheme in livepatch sysfs
 directory
Date: Tue, 10 Nov 2015 07:40:14 -0600
Message-ID: <20151110134014.GA3163@treble.redhat.com>
References: <20151105155656.GD28254@treble.redhat.com>
 <1447085770-11729-1-git-send-email-chris.j.arges@canonical.com>
 <20151109205608.GC3914@treble.redhat.com>
 <564125BE.2090604@canonical.com>
 <20151110045434.GB18117@treble.hsd1.ky.comcast.net>
 <alpine.LNX.2.00.1511100944120.16914@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1511100944120.16914-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 10, 2015 at 09:49:09AM +0100, Miroslav Benes wrote:
> On Mon, 9 Nov 2015, Josh Poimboeuf wrote:
> 
> > On Mon, Nov 09, 2015 at 05:01:18PM -0600, Chris J Arges wrote:
> > > On 11/09/2015 02:56 PM, Josh Poimboeuf wrote:
> > > > I'd recommend splitting this up into two separate patches:
> > > > 
> > > > 1. introduce old_sympos
> > > > 2. change the sysfs interface
> > > > 
> > > > On Mon, Nov 09, 2015 at 10:16:05AM -0600, Chris J Arges wrote:
> > > >> In cases of duplicate symbols in vmlinux, old_sympos will be used to
> > > >> disambiguate instead of old_addr. Normally old_sympos will be 0, and
> > > >> default to only returning the first found instance of that symbol. If an
> > > >> incorrect symbol position is specified then livepatching will fail.
> > > > 
> > > > In the case of old_sympos == 0, instead of just returning the first
> > > > symbol it finds, I think it should ensure that the symbol is unique.  As
> > > > Miroslav suggested:
> > > > 
> > > >   0 - default, preserve more or less current behaviour. If the symbol is 
> > > >       unique there is no problem. If it is not the patching would fail.
> > > >   1, 2, ... - occurrence of the symbol in kallsyms.
> > > >   
> > > >   The advantage is that if the user does not care and is certain that the 
> > > >   symbol is unique he doesn't have to do anything. If the symbol is not 
> > > >   unique he still has means how to solve it.
> > > > 
> > > 
> > > So one part that will be confusing here is as follows.
> > > 
> > > If '0' is specified for old_sympos, should the symbol be 'func_name,0'
> > > or 'func_name,1' provided we have a unique symbol? We could also default
> > > to 'what the user provides', but this seems odd.
> > 
> > I don't feel strongly either way, but I think using the same number the
> > user provides is fine, since it makes the sysfs interface consistent
> > with the old_sympos usage.
> 
> I think it should be func_name,1 even if '0' is specified and the symbol 
> is unique. Because if we say that 1, 2, ... is the occurrence of the 
> symbol in kallsyms it should stay that way everywhere. Hence for 
> old_sympos == 0 it is func_name,1 in sysfs; for 1 it is still func_name,1; 
> for 2 it is func_name,2 and so on.
> 
> And I'd add this to sysfs documentation.

That makes sense, sounds fine to me.

-- 
Josh
