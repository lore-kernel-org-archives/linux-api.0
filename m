From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 01/17] y2038: asm-generic: Extend sysvipc data structures
Date: Fri, 20 Apr 2018 10:54:25 +0200
Message-ID: <CAK8P3a3qAoR1afmTTK1CAp1L81dzwtBL+SKj=QMqD=dBr_8oRQ@mail.gmail.com>
References: <20180419143737.606138-1-arnd@arndb.de> <20180419143737.606138-2-arnd@arndb.de>
 <87efjbnswr.fsf@xmission.com> <CAK8P3a196QYoM1egagMuZw4WhiwRiO83Qpj0CxoCeVQBEaj-gw@mail.gmail.com>
 <CAK8P3a2KR+0ZE5jHSmO6pSuiRPH83p75KetuQuHL1atChcTJGA@mail.gmail.com> <87k1t2n8v5.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87k1t2n8v5.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, GNU C Library <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Albert ARIBAUD <albert.aribaud@3adev.fr>, linux-s390 <linux-s390@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, the arch/x86 maintainers <x86@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, James Hogan <jhogan@kernel.org>, Ralf Baechle <ralf@linux-mips.org>, linuxppc-dev <linuxppc-dev@lists.o>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 20, 2018 at 12:12 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
>
>> On Thu, Apr 19, 2018 at 5:20 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Thu, Apr 19, 2018 at 4:59 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>> I suspect you want to use __kernel_ulong_t here instead of a raw
>>>> unsigned long.  If nothing else it seems inconsistent to use typedefs
>>>> in one half of the structure and no typedefs in the other half.
>>>
>>> Good catch, there is definitely something wrong here, but I think using
>>> __kernel_ulong_t for all members would also be wrong, as that
>>> still changes the layout on x32, which effectively is
>>>
>>> struct msqid64_ds {
>>>      ipc64_perm msg_perm;
>>>      u64 msg_stime;
>>>      u32 __unused1;
>>>      /* 32 bit implict padding */
>>>      u64 msg_rtime;
>>>      u32 __unused2;
>>>      /* 32 bit implict padding */
>>>      u64 msg_ctime;
>>>      u32 __unused3;
>>>      /* 32 bit implict padding */
>>>      __kernel_pid_t          shm_cpid;       /* pid of creator */
>>>      __kernel_pid_t          shm_lpid;       /* pid of last operator */
>>>      ....
>>> };
>>>
>>> The choices here would be to either use a mix of
>>> __kernel_ulong_t and unsigned long, or taking the x32
>>> version back into arch/x86/include/uapi/asm/ so the
>>> generic version at least makes some sense.
>>>
>>> I can't use __kernel_time_t for the lower half on 32-bit
>>> since it really should be unsigned.
>>
>> After thinking about it some more, I conclude that the structure is simply
>> incorrect on x32: The __kernel_ulong_t usage was introduced in 2013
>> in commit b9cd5ca22d67 ("uapi: Use __kernel_ulong_t in struct
>> msqid64_ds") and apparently was correct initially as __BITS_PER_LONG
>> evaluated to 64, but it broke with commit f4b4aae18288 ("x86/headers/uapi:
>> Fix __BITS_PER_LONG value for x32 builds") that changed the value
>> of __BITS_PER_LONG and introduced the extra padding in 2015.
>>
>> The same change apparently also broke a lot of other definitions, e.g.
>>
>> $ echo "#include <linux/types.h>" | gcc -mx32 -E -xc - | grep -A3
>> __kernel_size_t
>> typedef unsigned int __kernel_size_t;
>> typedef int __kernel_ssize_t;
>> typedef int __kernel_ptrdiff_t;
>>
>> Those used to be defined as 'unsigned long long' and 'long long'
>> respectively, so now all kernel interfaces using those on x32
>> became incompatible!
>
> Is this just for the uapi header as seen by userspace?  I expect we are
> using the a normal kernel interface with 64bit longs and 64bit pointers
> when we build the kernel.

Yes, that patch shouldn't have changed anything in the kernel, which
continues to be built with __BITS_PER_LONG=64. I haven't
checked the vdso, which is the only bit of the kernel that gets built
with -mx32, but I assume it's fine as well.

> If this is just a header as seen from userspace mess it seems
> unfortunate but fixable.

Right. I'll fix the IPC stuff for this series to make it work with
any value of __BITS_PER_LONG on x32, but I don't plan to
do anything about the rest of x32. The patch that caused the
problem was intended as a bugfix, so we can't just revert it
without first understanding how to properly fix the original bug,
and which other interfaces have now come to rely on
__BITS_PER_LONG=32 for x32.

Adding a few other folks that have been involved in the x32
kernel support or the Debian port in the past. Maybe one of
them is motivated to figure out how to fix this properly.

       Arnd
