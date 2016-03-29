From: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: (mostly) Arch-independent livepatch
Date: Wed, 30 Mar 2016 01:24:08 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1603300122020.3656@cbobk.fhfr.pm>
References: <1458691399-20078-1-git-send-email-jeyu@redhat.com> <20160329211330.GA1253@packer-debian-8-amd64.digitalocean.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160329211330.GA1253-N0bYjD2NfQ6k4hzjq3hgyGTy53QMssKEsp+A89P3RPuQWHG76I6BsA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 29 Mar 2016, Jessica Yu wrote:

> > v6:
> > - Since we hard-code the field widths for the objname and symbol name
> >   for the sscanf() calls, which are supposed to correspond to the values
> >   of MODULE_NAME_LEN and KSYM_NAME_LEN, use BUILD_BUG_ON() to detect when
> >   the values of these constants deviate from the expected values.
> > - Squash the sample livepatch module patch into patch 4
> >   ("livepatch: reuse module loader code to write relocations") so
> >   git bisects don't break
> > - Don't need the klp_buf struct, just use plain char arrays to hold the
> >   output of sscanf(). Also, no need to clear the bufs after every
> >   invocation, as sscanf() takes care to put a null byte at the end of
> >   the bufs.
> > - Fix compiler kbuild errors for the !CONFIG_LIVEPATCH case
> > - Fixed some small module.c nits
> > 
> 
> Pinging Rusty, just in case this thread got buried :-)
> How do the module.c changes look?

Plus there are (admittedly indeed rather small and trivial) changes to 
s390 module loader, so I'd prefer to have Heiko's / Martin's Ack before 
merging this.

Hence, let me piggy back on this ping to Rusty, and let me ping Heiko and 
Martin as well (adding to CC explicitly to make sure this doesn't get lost 
in general noise).

Thanks,

-- 
Jiri Kosina
SUSE Labs
