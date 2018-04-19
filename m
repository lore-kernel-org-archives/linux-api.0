From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v3 01/17] y2038: asm-generic: Extend sysvipc data structures
Date: Thu, 19 Apr 2018 17:12:46 -0500
Message-ID: <87k1t2n8v5.fsf@xmission.com>
References: <20180419143737.606138-1-arnd@arndb.de>
        <20180419143737.606138-2-arnd@arndb.de> <87efjbnswr.fsf@xmission.com>
        <CAK8P3a196QYoM1egagMuZw4WhiwRiO83Qpj0CxoCeVQBEaj-gw@mail.gmail.com>
        <CAK8P3a2KR+0ZE5jHSmO6pSuiRPH83p75KetuQuHL1atChcTJGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2KR+0ZE5jHSmO6pSuiRPH83p75KetuQuHL1atChcTJGA@mail.gmail.com>
        (Arnd Bergmann's message of "Thu, 19 Apr 2018 23:24:36 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, GNU C Library <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Albert ARIBAUD <albert.aribaud@3adev.fr>, linux-s390 <linux-s390@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, the arch/x86 maintainers <x86@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, James Hogan <jhogan@kernel.org>, Ralf Baechle <ralf@linux-mips.org>, linuxppc-dev <linuxppc-dev@lists>
List-Id: linux-api@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Thu, Apr 19, 2018 at 5:20 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Thu, Apr 19, 2018 at 4:59 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> I suspect you want to use __kernel_ulong_t here instead of a raw
>>> unsigned long.  If nothing else it seems inconsistent to use typedefs
>>> in one half of the structure and no typedefs in the other half.
>>
>> Good catch, there is definitely something wrong here, but I think using
>> __kernel_ulong_t for all members would also be wrong, as that
>> still changes the layout on x32, which effectively is
>>
>> struct msqid64_ds {
>>      ipc64_perm msg_perm;
>>      u64 msg_stime;
>>      u32 __unused1;
>>      /* 32 bit implict padding */
>>      u64 msg_rtime;
>>      u32 __unused2;
>>      /* 32 bit implict padding */
>>      u64 msg_ctime;
>>      u32 __unused3;
>>      /* 32 bit implict padding */
>>      __kernel_pid_t          shm_cpid;       /* pid of creator */
>>      __kernel_pid_t          shm_lpid;       /* pid of last operator */
>>      ....
>> };
>>
>> The choices here would be to either use a mix of
>> __kernel_ulong_t and unsigned long, or taking the x32
>> version back into arch/x86/include/uapi/asm/ so the
>> generic version at least makes some sense.
>>
>> I can't use __kernel_time_t for the lower half on 32-bit
>> since it really should be unsigned.
>
> After thinking about it some more, I conclude that the structure is simply
> incorrect on x32: The __kernel_ulong_t usage was introduced in 2013
> in commit b9cd5ca22d67 ("uapi: Use __kernel_ulong_t in struct
> msqid64_ds") and apparently was correct initially as __BITS_PER_LONG
> evaluated to 64, but it broke with commit f4b4aae18288 ("x86/headers/uapi:
> Fix __BITS_PER_LONG value for x32 builds") that changed the value
> of __BITS_PER_LONG and introduced the extra padding in 2015.
>
> The same change apparently also broke a lot of other definitions, e.g.
>
> $ echo "#include <linux/types.h>" | gcc -mx32 -E -xc - | grep -A3
> __kernel_size_t
> typedef unsigned int __kernel_size_t;
> typedef int __kernel_ssize_t;
> typedef int __kernel_ptrdiff_t;
>
> Those used to be defined as 'unsigned long long' and 'long long'
> respectively, so now all kernel interfaces using those on x32
> became incompatible!

That seems like a real mess.

Is this just for the uapi header as seen by userspace?  I expect we are
using the a normal kernel interface with 64bit longs and 64bit pointers
when we build the kernel.

If this is just a header as seen from userspace mess it seems
unfortunate but fixable.

Eric
