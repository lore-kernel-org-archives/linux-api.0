From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: module: save load_info for livepatch modules
Date: Thu, 12 Nov 2015 17:17:51 -0500
Message-ID: <20151112221750.GA13513@packer-debian-8-amd64.digitalocean.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-3-git-send-email-jeyu@redhat.com>
 <alpine.LNX.2.00.1511111505300.12467@pobox.suse.cz>
 <20151112053228.GD30025@packer-debian-8-amd64.digitalocean.com>
 <20151112102404.GL4431@pathway.suse.cz>
 <alpine.LNX.2.00.1511121400290.9440@pobox.suse.cz>
 <20151112150345.GT2599@pathway.suse.cz>
 <20151112170501.GD4038@treble.hsd1.ky.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151112170501.GD4038-M1RQNqTfbHcHO9+bouH2LOBSVt8DKT+lrE5yTffgRl4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Josh Poimboeuf [12/11/15 11:05 -0600]:
>On Thu, Nov 12, 2015 at 04:03:45PM +0100, Petr Mladek wrote:
>> On Thu 2015-11-12 14:22:28, Miroslav Benes wrote:
>> > On Thu, 12 Nov 2015, Petr Mladek wrote:
>> > > > >Maybe I am missing something but isn't it necessary to call vfree() on
>> > > > >info somewhere in the end?
>> > > >
>> > > > So free_copy() will call vfree(info->hdr), except in livepatch modules
>> > > > we want to keep all the elf section information stored there, so we
>> > > > avoid calling free_copy(), As for the info struct itself, if you look
>> > > > at the init_module and finit_module syscall definitions in
>> > > > kernel/module.c, you will see that info is actually a local function
>> > > > variable, simply passed in to the call to load_module(), and will be
>> > > > automatically deallocated when the syscall returns. :-) No need to
>> > > > explicitly free info.
>> > >
>> > > We still have to free the copied or preserved structures when
>> > > the module is unloaded.
>> >
>> > ...freeing what we allocated. We need to free info->hdr somewhere if not
>> > here and also mod_arch_specific struct where the patch module is removed.
>> > This would unfortunately lead to changes in arch-specific code in
>> > module.c. For example in arch/s390/kernel/module.c there is vfree call on
>> > part of mod_arch_specific in module_finalize. We would call it only if the
>> > flag mentioned above is not set and at the same time we would need to call
>> > it when the patch module is being removed.
>>
>> Sigh, I am afraid that the flag is not enough. IMHO, we need to split
>> the load finalizing functions into two pieces. One will be always
>> called when the module load is finalized. The other part will free
>> the load_info. It will be called either when the load is finalized or
>> when the module is unloaded, depending on if we want to preserve
>> the load_info.
>>
>> Sigh, it is getting complicated. But let's see how it looks in reality.
>
>At the other end of the spectrum, we could do the simplest thing
>possible: _always_ save the data (even if CONFIG_LIVEPATCH is disabled).
>
>(gdb) print sizeof(*info)
>$3 = 96
>(gdb) p sizeof(*info->hdr)
>$4 = 64
>s390 mod_arch_syminfo struct: 24 bytes by my reckoning.
>
>So between info, info->hdr, and s390 mod_arch_syminfo, we're talking
>about 184 bytes on s390 and 160 bytes on x86_64.  That seems like
>peanuts compared to the size of a typical module.  The benefit is that
>the code would be simpler because we don't have any special cases and
>the structs would automatically get freed with the module struct when
>the module gets unloaded.

I think I agree with Josh on this one (except, I would always save
load_info if it is a livepatch module, instead of for every module in the
!CONFIG_LIVEPATCH case, and we can just check modinfo to see if it is
a livepatch module).

If the tradeoff here is between simplicity and readibility of code vs.
saving some extra space (and by the looks of it, not a lot), I think I
would choose having clear code over saving some bytes of memory. Hard
coding checks and edge cases imo might cause confusion and trouble
down the road.
