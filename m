From: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Thu, 09 Mar 2017 15:04:30 +0100
Message-ID: <1489068270.1026.6.camel@quad>
References: <1488897868.5178.3.camel@quad>
         <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com>
         <1488997111.5155.10.camel@quad>
         <f16cd7f8-f996-cf66-d640-50b0ccee06c7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f16cd7f8-f996-cf66-d640-50b0ccee06c7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2017-03-08 at 16:05 -0500, Carlos O'Donell wrote: 
> On 03/08/2017 01:18 PM, Leonard den Ottolander wrote:
> > Note that 128KiB * 4096 arguments still adds up to 512MiB!!!
> > 
> > If you don't feel the limit of 4096 arguments is sufficient please
> > provide us with an example where that limit is insufficient.
> 
> (a) Justification.
> 
> A good design should not unduly limit what users can do without a good
> justification.

The justification is that the excessive value of the MAX_ARG_STRINGS
allows heap spraying on 32 bit processes. Or more precisely, the fact
that the multiplication of MAX_ARG_STRINGS and MAX_ARG_STRLEN being
equal to or larger than the 2^32 allows heap spraying.

> It is my opinion that it is not enough data to say that a kernel build
> is sufficient to justify a limit that will affect all applications.
> 
> Minimally I'd expect you to run with such a kernel patch through an entire
> distro build cycle to see if anything else breaks.

I don't think that's really necessary. We can argue whether that value
should be a bit bigger, but a limit is necessary to disable the very
serious attack vector that heap spraying is. In any binary, not just
setuid ones. It's a jumping board to launch any attack via the heap
sprayed binary.

> What if 4096 is too much? Why not lower?

Well, building that C7 kernel didn't work with 2048, it choked on a make
file with something like a little over 3000 -o options. I chose 4096 as
it was sufficient for what I considered to be one of the heaviest use
cases.

The problem is that the multiplication of MAX_ARG_STRLEN and
MAX_ARG_STRINGS should stay below 4GiB to disable the heap spraying.

This means that if f.e. both MAX_ARG_STRINGS and MAX_ARG_STRLEN are
65536 the multiplication is 4GiB and heap spraying is possible.

Of course an extra value limiting this multiplier could be added
(MAX_ARG_STRSLEN along the lines of MAX_ARG_PAGES) and used in exec.c to
limit the total amount of reserved memory. This would allow for the
multiplication of MAX_ARG_STRINGS and MAX_ARG_STRLEN to go beyond 2^32.

And it would save a lot of memory because even with my conservative
values the amount of memory reserved for options is still 65536 x 4096 =
256MiB.

> You could try using systemtap
> or dtrace and running a distro start to finish and auditing the mean
> values you see (see (c) for a discussion on ensuring the userspace tooling
> remains correct after this change).

I have not been dtracing for, but I've not encountered any issue with
kernels using MAX_ARG_STRLEN 65536 and MAX_ARG_STRINGS 4096 so far
(running a.o. on this desktop).

> (b) Attack vector.
> 
> The privilege escalation in your example is caused by a fault in a
> setuid application.

The orthogonality of attack vectors seems to be lost on many I speak on
the issue. It means that every vector has to be judged individually.

The fact that the binary in the example is setuid is
orthogonal/irrelevant to the fact that the high value of MAX_ARG_STRINGS
combined with memory leaks in executables option parsing allow heap
spraying. The heap spraying in itself is a very serious vector that
allows launching any attack via the sprayed heap whether or not the
involved binary is setuid. 

> Can we impose stricter limits on setuid binaries instead of on all
> binaries?

Because an zero day can also be launched via a heap sprayed non setuid
binary like pkcheck. 

> In glibc for example we do not allow certain environment variables to
> impact the behaviour of setuid binaries e.g. MALLOC_PERTURB_ env var
> is ignored in secure mode for setuid binaries (which might be used
> for similar heap-spraying).

This is all very nice but it did not block the attack described in the
article I linked. Your solution sounds rather convoluted. With a
sensible value for MAX_ARG_STRINGS all this working around the real
issue is unnecessary: The heap will no longer collide into the stack of
any binary that does not sanitize its argument list. 

> (c) What limit is appropriate?
> 
> No limit is appropriate. Users should be able to use all of their system
> resources to accomplish whatever task they need to get done.

Oh the poor user. So you rather leave the user exposed to attacks that
leverage heap spraying than imposing a limit?

The point is that this value (the multiplication of both really) allows
an adversary to launch any attack in his inventory using a heap sprayed
binary. That is not a situation you want to prolong.

Regards,
Leonard.

-- 
mount -t life -o ro /dev/dna /genetic/research
