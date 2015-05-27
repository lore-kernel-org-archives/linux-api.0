From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [klibc] kernel/libc uapi changes for y2038
Date: Wed, 27 May 2015 08:28:44 -0700
Message-ID: <5565E2AC.3070306@zytor.com>
References: <2664016.bYZKg6FQqR@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-59383-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <2664016.bYZKg6FQqR@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org
Cc: klibc@zytor.com, libc-alpha@sourceware.org, y2038@lists.linaro.org, musl@lists.openwall.com, linux-kernel@vger.kernel.org, Rich Felker <dalias@libc.org>, cferris@google.com, enh@google.com, "Joseph S. Myers" <joseph@codesourcery.com>
List-Id: linux-api@vger.kernel.org

On 05/18/2015 02:53 AM, Arnd Bergmann wrote:
> In the patch series I posted recently [1], I introduce new system calls to deal
> with modified data structures, but left the question open on how these should
> be best accessed from libc. The patches introduce a new __kernel_time64_t type
> and based on that five new data structured: struct __kernel_timespec,
> struct __kernel_itimerspec, struct __kernel_stat, struct __kernel_rusage,
> and struct __kernel_timex. This works fine for the case when all libc
> implementations provide their own definitions to user space, but not for
> the simplest case (e.g. klibc) where the user-visible structures come directly
> from the kernel uapi headers.
> 
> I still don't know what model the various libc developers prefer, so here is
> an alternative approach, as a patch on top of the previous series:
> 
> Now, we rename the original structures to struct __old_kernel_*, and use a
> macro to define either the __old_kernel_* or the __kernel_* structure name
> to the name we actually want in user space, based on a __KERNEL_TIME_BITS
> macro that can be set to either 32 or 64 for 32-bit architectures by
> the libc. Depending on that macro, the compiler will either see one
> of these combinations (for each of the five structures):
> 
> a) __BITS_PER_LONG == 32 && __KERNEL_TIME_BITS == 32:
> 
>    struct timespec              based on 32-bit __kernel_time_t
>    struct __kernel_timespec     based on 64-bit __kernel_time64_t
> 
> b) __BITS_PER_LONG == 64 && __KERNEL_TIME_BITS == 64:
> 
>    struct timespec              based on 64-bit __kernel_time_t
>    struct __kernel_timespec     based on 64-bit __kernel_time64_t
> 
> c) __BITS_PER_LONG == 32 && __KERNEL_TIME_BITS == 64:
> 
>    struct __old_kernel_timespec based on 32-bit __kernel_time_t
>    struct timespec              based on 64-bit __kernel_time64_t
> 
> Would this work for everyone?  Any alternative suggestions?
> 

It seems to work, except I don't really understand why there is a
difference between (b) and (c).

I also have no problem just having klibc contain its own definitions of
these structures, as long as one can prevent the kernel from defining them.

	-hpa
