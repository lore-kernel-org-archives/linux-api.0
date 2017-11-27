From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH v2 00/10] posix_clocks: Prepare syscalls for 64 bit time_t conversion
Date: Mon, 27 Nov 2017 14:29:59 -0800
Message-ID: <CABeXuvrBOSVTNSbEZZMKmuTgWeU_VDqjSZkwGAM+bnPh0-72zA@mail.gmail.com>
References: <20171127193037.8711-1-deepa.kernel@gmail.com> <CAK8P3a2pcpQqf_TNGVxLBePBSKYhxD90UN-FjBor4d-dKhAwbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2pcpQqf_TNGVxLBePBSKYhxD90UN-FjBor4d-dKhAwbQ@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, cohuck@redhat.com, David Miller <davem@davemloft.net>, Helge Deller <deller@gmx.de>, devel@driverdev.osuosl.org, gerald.schaefer@de.ibm.com, gregkh <gregkh@linuxfoundation.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jan Hoeppner <hoeppner@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Julian
List-Id: linux-api@vger.kernel.org

>> I decided against using LEGACY_TIME_SYSCALLS to conditionally compile
>> legacy time syscalls such as sys_nanosleep because this will need to
>> enclose compat_sys_nanosleep as well. So, defining it as
>>
>> config LEGACY_TIME_SYSCALLS
>>      def_bool 64BIT || !64BIT_TIME
>>
>> will not include compat_sys_nanosleep. We will instead need a new config to
>> exclusively mark legacy syscalls.
>
> Do you mean we would need to do this separately for native and compat
> syscalls, and have yet another option, like LEGACY_TIME_SYSCALLS
> and LEGACY_TIME_COMPAT_SYSCALLS, to cover all cases? I would
> think that CONFIG_COMPAT_32BIT_TIME handles all the compat versions,
> while CONFIG_LEGACY_TIME_SYSCALLS handles all the native ones.

I meant sys_nanosleep would be covered by LEGACY_TIME_SYSCALLS, but
compat_sys_nanosleep would be covered by CONFIG_COMPAT_32BIT_TIME
along with other compat syscalls.
So, if we define the LEGACY_TIME_SYSCALLS as


        "This controls the compilation of the following system calls:
        time, stime, gettimeofday, settimeofday, adjtimex, nanosleep,
alarm, getitimer,
        setitimer, select, utime, utimes, futimesat, and
{old,new}{l,f,}stat{,64}.
        These all pass 32-bit time_t arguments on 32-bit architectures and
        are replaced by other interfaces (e.g. posix timers and clocks, statx).
        C libraries implementing 64-bit time_t in 32-bit architectures have to
        implement the handles by wrapping around the newer interfaces.
        New architectures should not explicitly enable this."

This would not be really true as compat interfaces have nothing to do
with this config.

I was proposing that we could have LEGACY_TIME_SYSCALLS config, but
then have all these "deprecated" syscalls be enclosed within this,
compat or not.
This will also mean that we will have to come up representing these
syscalls in the syscall header files.
This can be a separate patch and this series can be merged as is if
everyone agrees.

-Deepa
