From: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Fri, 17 Mar 2017 14:12:31 +0100
Message-ID: <1489756351.5187.30.camel@quad>
References: <1488897868.5178.3.camel@quad>
         <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com>
         <1488997111.5155.10.camel@quad>
         <f16cd7f8-f996-cf66-d640-50b0ccee06c7@redhat.com>
         <1489068854.1026.14.camel@quad>
         <81d8e14e-e110-4b96-5d45-8bb3b56f4866@redhat.com>
         <1489147810.5038.31.camel@quad>
         <b736f01f-ef0a-56de-bf57-c6d3d74262a4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b736f01f-ef0a-56de-bf57-c6d3d74262a4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2017-03-13 at 20:51 -0400, Carlos O'Donell wrote:
> On 03/10/2017 07:10 AM, Leonard den Ottolander wrote:
> > A whopping gigabyte on 32 bit systems for arguments passed to an
> > executable. That sounds excessive. A use case of "ls *"-ing 128k files
> > with 32 byte names adds up to 4 MiB. That is 16 times what you need to
> > build a kernel. That sounds sufficient don't you think? And again, if
> > not, show us a use case.
> 
> You have already been given use cases.
> 
> * Mail spool directory with millions of files.

That is quite an excessive use case to bring up to counter my effort to
get a serious attack vector, heap spraying, fixed. Also not that ls on
such a directory will work fine, it's only when you start to use
wildcards that you run into limits. Easily fixed by someone with only a
basic knowledge of scripting.

> * Large and complex build system with potentially long paths.

I have given you a concrete example: You can build a kernel on CentOS-7
with a kernel built with these values. You still have not shown a
counter example. Perhaps the build of glibc fails with such values?
Firefox? MySQL/MariaDB?

You keep repeating conjectured arguments to counter my concrete example.
Please provide a real case where a total of 256KiB for command line
arguments breaks anything in real life.

> Artificial limits are always going to cause problems, particularly when
> going from a higher limit to a lower limit.

15 years ago a total of 128KiB arguments was fine. I can imagine we need
a multitude of that by now, but for the use case I present 256KiB seems
plenty.

As I have pointed out all systems use artificial limits everywhere, not
to annoy the user, but to protect the users system against (dangerously)
misbehaving.

> Your present justification is simply that nobody could have use for
> lots of arguments, which is not true, and that heap spraying needs to be
> stopped, which may be right but may not be the place to start.

No, I have presented you a concrete use case that I believe to be at the
top end of what one would need for the total amount of argument data.
You have still not presented a serious counter example.

> You have now been given the expert opinion of Joseph Myers and myself,
> so take that as you will.

Who exactly is the judge of that qualification? Are you trying to
disqualify me by using such terms and applying them to yourselves?

> Deployed existing code stands, and the burden of proof is on _you_ to
> justify changing the code, not on me to justify all the use cases that
> users might have for the current implementation.

The example I have given you
https://googleprojectzero.blogspot.nl/2014/08/the-poisoned-nul-byte-2014-edition.html
clearly illustrates the viability of attacking a system with heap
spraying and its potency as an attack vector.

> Please invite more experts, security or otherwise, to come discuss on
> linux-api, the relative merits of _where_ we should be fixing attacks
> of this kind.

Apparently the amount of people chipping in is more important to you
than the value of the arguments. You being an employee of a large
company will always be able to bring out more people to argue your side
of the argument. That in itself does not make your arguments more valid
though.

The change to split that single value MAX_ARG_PAGES into two
(MAX_ARG_STRINGS & MAX_ARG_STRLEN) when MMU was implemented has not been
justified. It now turns out to have been a dangerous decision as the
multiplication of the two quickly brings us in the danger zone where the
entire heap can be initialized by an attacker (malevolent local user, or
someone cracking f.e. apache running on a 32 bit ABI).

Instead of trying to disqualify me and my arguments with cheap rhetoric
you might run some tests with the value(s) I provided so we can
establish a sensible limit for MAX_ARG_STRINGS * MAX_ARG_STRLEN or its
(to be restored) cap "MAX_ARG_BYTES" and fix the dangerous attack venue
that heap spraying is.

Regards,
Leonard.

-- 
mount -t life -o ro /dev/dna /genetic/research
