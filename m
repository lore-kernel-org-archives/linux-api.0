From: John Stultz <john.stultz@linaro.org>
Subject: Re: [Y2038] kernel/libc uapi changes for y2038
Date: Tue, 19 May 2015 10:54:45 -0700
Message-ID: <CALAqxLXmT4t845qN3WAQ1Hz=v=KcT7vkFO92Xm=DfyeNWm6YmA@mail.gmail.com>
References: <2664016.bYZKg6FQqR@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <libc-alpha-return-59028-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <2664016.bYZKg6FQqR@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux API <linux-api@vger.kernel.org>, klibc@zytor.com, libc-alpha@sourceware.org, y2038 Mailman List <y2038@lists.linaro.org>, musl@lists.openwall.com, lkml <linux-kernel@vger.kernel.org>, Rich Felker <dalias@libc.org>, cferris@google.com, Elliott Hughes <enh@google.com>, "Joseph S. Myers" <joseph@codesourcery.com>
List-Id: linux-api@vger.kernel.org

On Mon, May 18, 2015 at 2:53 AM, Arnd Bergmann <arnd@arndb.de> wrote:
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
>         Arnd
>
> [1] http://git.kernel.org/cgit/linux/kernel/git/arnd/playground.git/log/?h=y2038-syscalls
>     https://lwn.net/Articles/643407/
>
> diff --git a/include/uapi/asm-generic/bitsperlong.h b/include/uapi/asm-generic/bitsperlong.h
> index 23e6c416b85f..ecdaf4f77f35 100644
> --- a/include/uapi/asm-generic/bitsperlong.h
> +++ b/include/uapi/asm-generic/bitsperlong.h
> @@ -12,4 +12,13 @@
>  #define __BITS_PER_LONG 32
>  #endif
>
> +/*
> + * Traditionally we define defines 'time_t' as 'long', but we need to
> + * migrate to a 64-bit type until 2038. This one is designed to be
> + * overridden by user space if it's prepared to handle 64-bit time_t.
> + */
> +#ifndef __KERNEL_TIME_BITS
> +#define __KERNEL_TIME_BITS __BITS_PER_LONG
> +#endif
> +
>  #endif /* _UAPI__ASM_GENERIC_BITS_PER_LONG */
> diff --git a/include/uapi/asm-generic/kernel_stat.h b/include/uapi/asm-generic/kernel_stat.h
> index d1db22583046..3693496c78aa 100644
> --- a/include/uapi/asm-generic/kernel_stat.h
> +++ b/include/uapi/asm-generic/kernel_stat.h
> @@ -1,6 +1,14 @@
>  #ifndef __ASM_GENERIC_KERNEL_STAT_H
>  #define __ASM_GENERIC_KERNEL_STAT_H
>
> +#include <asm/bitsperlong.h>
> +
> +#if __KERNEL_TIME_BITS == 32 || __BITS_PER_LONG == 64
> +#define __old_kernel_stat2 stat
> +#else
> +#define __kernel_stat stat
> +#endif
> +
>  /*
>   * The new structure that works on both 32-bit and 64-bit and survives y2038
>   * The layout matches 'struct stat' from asm-generic/stat.h on 64-bit
> diff --git a/include/uapi/asm-generic/stat.h b/include/uapi/asm-generic/stat.h
> index 64c32ba7c1a9..f66b28b96c8d 100644
> --- a/include/uapi/asm-generic/stat.h
> +++ b/include/uapi/asm-generic/stat.h
> @@ -22,7 +22,7 @@
>
>  #define STAT_HAVE_NSEC 1
>
> -struct stat {
> +struct __old_kernel_stat2 {
>         unsigned long   st_dev;         /* Device.  */
>         unsigned long   st_ino;         /* File serial number.  */
>         unsigned int    st_mode;        /* File mode.  */
> diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
> index c4f3ba44db00..9a3876cc4436 100644
> --- a/include/uapi/linux/resource.h
> +++ b/include/uapi/linux/resource.h
> @@ -3,10 +3,16 @@
>
>  #include <linux/time.h>
>  #include <linux/types.h>
> +#include <asm/bitsperlong.h>
>
>  /*
>   * Resource control/accounting header file for linux
>   */
> +#if __KERNEL_TIME_BITS == 32 || __BITS_PER_LONG == 64
> +#define __old_kernel_rusage rusage
> +#else
> +#define __kernel_rusage rusage
> +#endif

This all looks ok to me. Though I wonder if it would be cleaner to
have all these conditional definitions in one header, rather then
littered about in a ton of files.

I'm torn because having the definitions close to the underlying
structure helps folks reading through the code, but it still seems a
little bit messy.

thanks
-john
