From: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Thu, 9 Mar 2017 09:35:13 -0500
Message-ID: <2222c69b-cee9-dfc9-242f-344eeeaa13f5@redhat.com>
References: <1488897868.5178.3.camel@quad>
 <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com>
 <1488997111.5155.10.camel@quad>
 <f16cd7f8-f996-cf66-d640-50b0ccee06c7@redhat.com>
 <1489068270.1026.6.camel@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489068270.1026.6.camel@quad>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/09/2017 09:04 AM, Leonard den Ottolander wrote:
> On Wed, 2017-03-08 at 16:05 -0500, Carlos O'Donell wrote: 
>> On 03/08/2017 01:18 PM, Leonard den Ottolander wrote:
>>> Note that 128KiB * 4096 arguments still adds up to 512MiB!!!
>>>
>>> If you don't feel the limit of 4096 arguments is sufficient please
>>> provide us with an example where that limit is insufficient.
>>
>> (a) Justification.
>>
>> A good design should not unduly limit what users can do without a good
>> justification.
> 
> The justification is that the excessive value of the MAX_ARG_STRINGS
> allows heap spraying on 32 bit processes. Or more precisely, the fact
> that the multiplication of MAX_ARG_STRINGS and MAX_ARG_STRLEN being
> equal to or larger than the 2^32 allows heap spraying.
> 
>> It is my opinion that it is not enough data to say that a kernel build
>> is sufficient to justify a limit that will affect all applications.
>>
>> Minimally I'd expect you to run with such a kernel patch through an entire
>> distro build cycle to see if anything else breaks.
> 
> I don't think that's really necessary. We can argue whether that value
> should be a bit bigger, but a limit is necessary to disable the very
> serious attack vector that heap spraying is. In any binary, not just
> setuid ones. It's a jumping board to launch any attack via the heap
> sprayed binary.

It is my opinion that your justification is insufficient to limit all
of userspace to the newer more restrictive limit without any remedy
should existing build systems start to fail. One could argue the use of
@file support in the compiler, static linker, and assembler might help,
but that doesn't fix all issues and could be costly to re-architect such
build systems.

We should pursue other avenues to limit the attack vector first.

> Of course an extra value limiting this multiplier could be added
> (MAX_ARG_STRSLEN along the lines of MAX_ARG_PAGES) and used in exec.c to
> limit the total amount of reserved memory. This would allow for the
> multiplication of MAX_ARG_STRINGS and MAX_ARG_STRLEN to go beyond 2^32.

This sounds like a much better option, particularly if as a remedy the
system administrator can control the max pages allowed for this to a
configurable limit.

> I have not been dtracing for, but I've not encountered any issue with
> kernels using MAX_ARG_STRLEN 65536 and MAX_ARG_STRINGS 4096 so far
> (running a.o. on this desktop).

This is insufficient research into the problem to justify lowering
the limit.

>> (c) What limit is appropriate?
>>
>> No limit is appropriate. Users should be able to use all of their system
>> resources to accomplish whatever task they need to get done.
> 
> Oh the poor user. So you rather leave the user exposed to attacks that
> leverage heap spraying than imposing a limit?

There is a balance between keeping large build systems functional and
limiting arguments.

My position is that I would rather harden malloc metadata than limit
argument lengths. Florian Weimer on my team (Red Hat glibc team) is
already looking at this:

https://sourceware.org/ml/libc-alpha/2016-10/msg00531.html

This would force attackers to have to find entirely new ways to attack
the heap metadata.
 
> The point is that this value (the multiplication of both really) allows
> an adversary to launch any attack in his inventory using a heap sprayed
> binary. That is not a situation you want to prolong.

This is hyperbole. You have to take a common sense approach to closing
these attack vectors and balance them against system usability.

-- 
Cheers,
Carlos.
