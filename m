From: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Wed, 8 Mar 2017 16:05:38 -0500
Message-ID: <f16cd7f8-f996-cf66-d640-50b0ccee06c7@redhat.com>
References: <1488897868.5178.3.camel@quad>
 <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com>
 <1488997111.5155.10.camel@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488997111.5155.10.camel@quad>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/08/2017 01:18 PM, Leonard den Ottolander wrote:
> On Wed, 2017-03-08 at 12:54 -0500, Carlos O'Donell wrote:
>> In glibc we limit setuid applications, for example sanitizing their
>> environment where it would cause problems or alter behaviour in 
>> unintended ways.
>>
>> Can we avoid imposing a limit on all applications?
> 
> Not imposing a limit - btw, 0x7FFFFFFF *is* a limit albeit a ridiculous
> and dangerously large limit - is a bad idea, because it allows the
> aforementioned "heap-spraying" which is a serious attack vector.
> 
> Note that 128KiB * 4096 arguments still adds up to 512MiB!!!
> 
> If you don't feel the limit of 4096 arguments is sufficient please
> provide us with an example where that limit is insufficient.

(a) Justification.

A good design should not unduly limit what users can do without a good
justification.

It is my opinion that it is not enough data to say that a kernel build
is sufficient to justify a limit that will affect all applications.

Minimally I'd expect you to run with such a kernel patch through an entire
distro build cycle to see if anything else breaks. For example reaching
out to the Fedora or SUSE teams to test the patch in Rawhide or
Tumbleweed.

What if 4096 is too much? Why not lower? You could try using systemtap
or dtrace and running a distro start to finish and auditing the mean
values you see (see (c) for a discussion on ensuring the userspace tooling
remains correct after this change).

(b) Attack vector.

The privilege escalation in your example is caused by a fault in a
setuid application.

Can we impose stricter limits on setuid binaries instead of on all
binaries?

In glibc for example we do not allow certain environment variables to
impact the behaviour of setuid binaries e.g. MALLOC_PERTURB_ env var
is ignored in secure mode for setuid binaries (which might be used
for similar heap-spraying).

Can the kernel similarly enforce a different MAX_ARG_STRINGS for setuid?

(c) What limit is appropriate?

No limit is appropriate. Users should be able to use all of their system
resources to accomplish whatever task they need to get done.

Yes, portable applications have limits e.g. ARG_MAX, sysconf(_SC_ARG_MAX),
xargs --show-limits, getconf ARG_MAX etc. We should make sure that any
limit we set does not conflict with current implementations and standards
conformance.

Yes, limits should be balanced against security issues, and for setuid
binaries I agree, but you propose a blanket limit, which is why I'm asking
the question again: Can we impose stricter limits on setuid binaries
instead of on all binaries?

-- 
Cheers,
Carlos.
