From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [klibc] kernel/libc uapi changes for y2038
Date: Wed, 27 May 2015 22:19:52 +0200
Message-ID: <2268301.gQGnhXiZzi@wuerfel>
References: <2664016.bYZKg6FQqR@wuerfel> <5565E2AC.3070306@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5565E2AC.3070306-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, klibc-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, cferris-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, enh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 27 May 2015 08:28:44 H. Peter Anvin wrote:
> On 05/18/2015 02:53 AM, Arnd Bergmann wrote:
> > In the patch series I posted recently [1], I introduce new system calls to deal
> > with modified data structures, but left the question open on how these should
> > be best accessed from libc. The patches introduce a new __kernel_time64_t type
> > and based on that five new data structured: struct __kernel_timespec,
> > struct __kernel_itimerspec, struct __kernel_stat, struct __kernel_rusage,
> > and struct __kernel_timex. This works fine for the case when all libc
> > implementations provide their own definitions to user space, but not for
> > the simplest case (e.g. klibc) where the user-visible structures come directly
> > from the kernel uapi headers.
> > 
> > I still don't know what model the various libc developers prefer, so here is
> > an alternative approach, as a patch on top of the previous series:
> > 
> > Now, we rename the original structures to struct __old_kernel_*, and use a
> > macro to define either the __old_kernel_* or the __kernel_* structure name
> > to the name we actually want in user space, based on a __KERNEL_TIME_BITS
> > macro that can be set to either 32 or 64 for 32-bit architectures by
> > the libc. Depending on that macro, the compiler will either see one
> > of these combinations (for each of the five structures):
> > 
> > a) __BITS_PER_LONG == 32 && __KERNEL_TIME_BITS == 32:
> > 
> >    struct timespec              based on 32-bit __kernel_time_t
> >    struct __kernel_timespec     based on 64-bit __kernel_time64_t
> > 
> > b) __BITS_PER_LONG == 64 && __KERNEL_TIME_BITS == 64:
> > 
> >    struct timespec              based on 64-bit __kernel_time_t
> >    struct __kernel_timespec     based on 64-bit __kernel_time64_t
> > 
> > c) __BITS_PER_LONG == 32 && __KERNEL_TIME_BITS == 64:
> > 
> >    struct __old_kernel_timespec based on 32-bit __kernel_time_t
> >    struct timespec              based on 64-bit __kernel_time64_t
> > 
> > Would this work for everyone?  Any alternative suggestions?
> > 
> 
> It seems to work, except I don't really understand why there is a
> difference between (b) and (c).

I tried to keep a) and b) similar, and change nothing other than the
introduction of the extra __kernel_time64_t and __kernel_timespec
here, for the case of __KERNEL_TIME_BITS == __BITS_PER_LONG, in order
to minimize the risk of introducing regressions for existing libc
builds against new kernel headers.

Case c) is the only one that actually changes the existing definitions,
which makes it different from both a) and b).

> I also have no problem just having klibc contain its own definitions of
> these structures, as long as one can prevent the kernel from defining them.

Ok, good to know. If that works for all libc implementations, we
could take a simpler approach and just define __old_kernel_timespec
plus __kernel_timespec but not timespec (and respectively for the
other structures) when __KERNEL_TIME_BITS == 64 is set, and leave
the real user space definitions up to libc (which can then
add the #defines or not if they want to).

	Arnd
