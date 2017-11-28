From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 00/10] posix_clocks: Prepare syscalls for 64 bit time_t conversion
Date: Tue, 28 Nov 2017 15:17:26 +0100
Message-ID: <CAK8P3a26g74UA5J5uQLwdjK3hq+htzjrdTYRKqfy_MawY7st+g@mail.gmail.com>
References: <20171127193037.8711-1-deepa.kernel@gmail.com> <CAK8P3a2pcpQqf_TNGVxLBePBSKYhxD90UN-FjBor4d-dKhAwbQ@mail.gmail.com>
 <CABeXuvrBOSVTNSbEZZMKmuTgWeU_VDqjSZkwGAM+bnPh0-72zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CABeXuvrBOSVTNSbEZZMKmuTgWeU_VDqjSZkwGAM+bnPh0-72zA@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, cohuck@redhat.com, David Miller <davem@davemloft.net>, Helge Deller <deller@gmx.de>, devel@driverdev.osuosl.org, gerald.schaefer@de.ibm.com, gregkh <gregkh@linuxfoundation.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jan Hoeppner <hoeppner@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Julian
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 11:29 PM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>>> I decided against using LEGACY_TIME_SYSCALLS to conditionally compile
>>> legacy time syscalls such as sys_nanosleep because this will need to
>>> enclose compat_sys_nanosleep as well. So, defining it as
>>>
>>> config LEGACY_TIME_SYSCALLS
>>>      def_bool 64BIT || !64BIT_TIME
>>>
>>> will not include compat_sys_nanosleep. We will instead need a new config to
>>> exclusively mark legacy syscalls.
>>
>> Do you mean we would need to do this separately for native and compat
>> syscalls, and have yet another option, like LEGACY_TIME_SYSCALLS
>> and LEGACY_TIME_COMPAT_SYSCALLS, to cover all cases? I would
>> think that CONFIG_COMPAT_32BIT_TIME handles all the compat versions,
>> while CONFIG_LEGACY_TIME_SYSCALLS handles all the native ones.
>
> I meant sys_nanosleep would be covered by LEGACY_TIME_SYSCALLS, but
> compat_sys_nanosleep would be covered by CONFIG_COMPAT_32BIT_TIME
> along with other compat syscalls.
> So, if we define the LEGACY_TIME_SYSCALLS as
>
>
>         "This controls the compilation of the following system calls:
>         time, stime, gettimeofday, settimeofday, adjtimex, nanosleep,
> alarm, getitimer,
>         setitimer, select, utime, utimes, futimesat, and
> {old,new}{l,f,}stat{,64}.
>         These all pass 32-bit time_t arguments on 32-bit architectures and
>         are replaced by other interfaces (e.g. posix timers and clocks, statx).
>         C libraries implementing 64-bit time_t in 32-bit architectures have to
>         implement the handles by wrapping around the newer interfaces.
>         New architectures should not explicitly enable this."
>
> This would not be really true as compat interfaces have nothing to do
> with this config.
>
> I was proposing that we could have LEGACY_TIME_SYSCALLS config, but
> then have all these "deprecated" syscalls be enclosed within this,
> compat or not.
> This will also mean that we will have to come up representing these
> syscalls in the syscall header files.
> This can be a separate patch and this series can be merged as is if
> everyone agrees.

I think doing this separately  would be good, I don't see any interdependency
with the other patches, we just need to decide what we want in the long
run.

I agree my text that you cited doesn't capture the situation correctly,
as this is really about the obsolete system calls that take 64-bit time_t
arguments on architectures that are converted to allow 64-bit time_t
for non-obsolete system calls.

Maybe it's better to just reword this to

      "This controls the compilation of the following system calls:
      time, stime, gettimeofday, settimeofday, adjtimex, nanosleep,
alarm, getitimer,
      setitimer, select, utime, utimes, futimesat, and {old,new}{l,f,}stat{,64}.
      These are all replaced by other interfaces (e.g. posix timers and clocks,
      statx) on architectures that got converted from 32-bit time_t to
64-bit time_t.
      C libraries implementing 64-bit time_t in 32-bit architectures have to
      implement the handles by wrapping around the newer interfaces.
      New architectures should not explicitly enable this."

That would clarify that it's not about the compat system calls, while
also allowing the two options to be set independently.

        Arnd
