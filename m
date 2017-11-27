From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 00/10] posix_clocks: Prepare syscalls for 64 bit time_t conversion
Date: Mon, 27 Nov 2017 22:58:36 +0100
Message-ID: <CAK8P3a2pcpQqf_TNGVxLBePBSKYhxD90UN-FjBor4d-dKhAwbQ@mail.gmail.com>
References: <20171127193037.8711-1-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171127193037.8711-1-deepa.kernel@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, cohuck@redhat.com, David Miller <davem@davemloft.net>, Helge Deller <deller@gmx.de>, devel@driverdev.osuosl.org, gerald.schaefer@de.ibm.com, gregkh <gregkh@linuxfoundation.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jan Hoeppner <hoeppner@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Julian
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 8:30 PM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> The series is a preparation series for individual architectures
> to use 64 bit time_t syscalls in compat and 32 bit emulation modes.
>
> This is a follow up to the series Arnd Bergmann posted:
> https://sourceware.org/ml/libc-alpha/2015-05/msg00070.html [1]
>
> Big picture is as per the lwn article:
> https://lwn.net/Articles/643234/ [2]
>
> The series is directed at converting posix clock syscalls:
> clock_gettime, clock_settime, clock_getres and clock_nanosleep
> to use a new data structure __kernel_timespec at syscall boundaries.
> __kernel_timespec maintains 64 bit time_t across all execution modes.
>
> vdso will be handled as part of each architecture when they enable
> support for 64 bit time_t.
>
> The compat syscalls are repurposed to provide backward compatibility
> by using them as native syscalls as well for 32 bit architectures.
> They will continue to use timespec at syscall boundaries.
>
> CONFIG_64_BIT_TIME controls whether the syscalls use __kernel_timespec
> or timespec at syscall boundaries.
>
> The series does the following:
> 1. Enable compat syscalls on 32 bit architectures.
> 2. Add a new __kernel_timespec type to be used as the data structure
>    for all the new syscalls.
> 3. Add new config CONFIG_64BIT_TIME(intead of the CONFIG_COMPAT_TIME in
>    [1] and [2] to switch to new definition of __kernel_timespec. It is
>    the same as struct timespec otherwise.
> 4. Add new CONFIG_32BIT_TIME to conditionally compile compat syscalls.
>
> * Changes since v1:
>  * Introduce CONFIG_32BIT_TIME
>  * Fixed zeroing out of higher order bits of tv_nsec
>  * Included Arnd's changes to fix up use of compat headers

Very nice. I think it would be good to get this into linux-next soon so we
can build on top of this. I have submitted most other y2038 patches today
that don't depend on either this or one of my other patches.

There is one patch that I want to do but haven't imlpemented yet, to merge
get_timespec64() and compat_get_timespec() into one function that
take a bunch of flags (check nanosecond, nano/microsecond,
zero upper half of nanoseconds, 32-bit or 64-bit wide), since I found
a few functions that need more than one of these, and they don't
all need the same combinations. My patch will certainly conflict
with yours, as your touch the same functions, but that's fine.

If you end up doing another version of the series though, it might
be better to move the compat accessors into kernel/time/time.c
along with the native functions, that should make it easier to
consolidate them later.

> I decided against using LEGACY_TIME_SYSCALLS to conditionally compile
> legacy time syscalls such as sys_nanosleep because this will need to
> enclose compat_sys_nanosleep as well. So, defining it as
>
> config LEGACY_TIME_SYSCALLS
>      def_bool 64BIT || !64BIT_TIME
>
> will not include compat_sys_nanosleep. We will instead need a new config to
> exclusively mark legacy syscalls.

Do you mean we would need to do this separately for native and compat
syscalls, and have yet another option, like LEGACY_TIME_SYSCALLS
and LEGACY_TIME_COMPAT_SYSCALLS, to cover all cases? I would
think that CONFIG_COMPAT_32BIT_TIME handles all the compat versions,
while CONFIG_LEGACY_TIME_SYSCALLS handles all the native ones.

       Arnd
