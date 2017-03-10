From: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Fri, 10 Mar 2017 13:10:10 +0100
Message-ID: <1489147810.5038.31.camel@quad>
References: <1488897868.5178.3.camel@quad>
         <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com>
         <1488997111.5155.10.camel@quad>
         <f16cd7f8-f996-cf66-d640-50b0ccee06c7@redhat.com>
         <1489068854.1026.14.camel@quad>
         <81d8e14e-e110-4b96-5d45-8bb3b56f4866@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <81d8e14e-e110-4b96-5d45-8bb3b56f4866-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2017-03-09 at 15:34 -0500, Carlos O'Donell wrote:
> Why not just use MAX_ARG_PAGES?

Well it is really just a name, but MAX_ARG_PAGES is in use for non MMU.
So to avoid name collisions a different name seems appropriate.

> On 03/09/2017 09:14 AM, Leonard den Ottolander wrote:
> > +#define MAX_ARG_STRLEN 65536
> > +#define MAX_ARG_STRINGS 4096
> 
> These should be left untouched at their original values.

They could actually be removed unless something external relies on them.
But not to disturb too much they can stay around without causing issues.

> > +		if (total_bytes > MAX_ARG_STRSLEN)
> 
> Should be PAGE_SIZE * MAX_ARG_PAGES, similar to the !CONFIG_MMU case.

The use of PAGE_SIZE is arbitrary in this case. There is no reason why
the total amount of memory used for arguments should be a multitude of
PAGE_SIZE. Something like MAX_ARG_BYTES is just fine.

As I mentioned above, reusing MAX_ARG_PAGES might not be a good idea as
it might cause collisions with the non MMU case.

> > I've successfully built a kernel on a system with a kernel using above
> > values.
> > 
> > As we have now introduced a safeguard (MAX_ARG_STRSLEN capping the total
> > amount of memory reserved) the values of MAX_ARG_STRLEN and
> > MAX_ARG_STRINGS can be increased beyond where their multiplication
> > reaches 2^32.
> > 
> > So if we really want to support lets say users having directories of
> > 128k files we can now safely set MAX_ARG_STRINGS to 131072 and assuming
> > an average file name length of 32 set MAX_ARG_STRSLEN to 4194304.
> > 
> > Seems a little excessive to me for a default, but it is now safe.

> There is still no justification for the value of MAX_ARG_PAGES though.

The value for MAX_ARG_PAGES was chosen to allow users to specify large
command lines, for example when building a kernel or other large
project, or handling many files in a directory. 131072 bytes (32 pages)
did the trick in most cases 15 years ago. Only in special circumstances
did that value cause trouble, as you can see in the Linux Journal
article I linked.

A value of 262144 bytes (64 pages) causes no obvious problems on my
systems today.

> My objection that build systems will break still stands.

Well, you can keep repeating that argument without showing a use case
where the values I chose cause trouble. It's hard for me to argue
against conjecture.

As I have pointed out I can build a kernel on CentOS-7 with a kernel
using 262144 for MAX_ARG_STRSLEN.

If you have a heavier use case that you want to support then describe
that use case and tell us how much memory it needs for command line
options. I have come up with my values after quite some experimentation.

> The point of memory is to be used.

Not if it is dangerous for the user. Limits are there not to annoy the
user but to protect the user from the system misbehaving.

I would call heap spraying, an attack vector that allows launching any
exploit via the affected (memory leaking) binary as very serious
misbehaviour.

> A reasonable limit might be 1/4 of the virtual address space used for
> argument pages though.

A whopping gigabyte on 32 bit systems for arguments passed to an
executable. That sounds excessive. A use case of "ls *"-ing 128k files
with 32 byte names adds up to 4 MiB. That is 16 times what you need to
build a kernel. That sounds sufficient don't you think? And again, if
not, show us a use case.

Regards,
Leonard.

-- 
mount -t life -o ro /dev/dna /genetic/research
