From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 01/17] y2038: asm-generic: Extend sysvipc data structures
Date: Thu, 19 Apr 2018 17:20:26 +0200
Message-ID: <CAK8P3a196QYoM1egagMuZw4WhiwRiO83Qpj0CxoCeVQBEaj-gw@mail.gmail.com>
References: <20180419143737.606138-1-arnd@arndb.de> <20180419143737.606138-2-arnd@arndb.de>
 <87efjbnswr.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87efjbnswr.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, GNU C Library <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Albert ARIBAUD <albert.aribaud@3adev.fr>, linux-s390 <linux-s390@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, the arch/x86 maintainers <x86@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, James Hogan <jhogan@kernel.org>, Ralf Baechle <ralf@linux-mips.org>, linuxppc-dev <linuxppc-dev@lists.o>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 19, 2018 at 4:59 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
>>
>>  struct msqid64_ds {
>>       struct ipc64_perm msg_perm;
>> +#if __BITS_PER_LONG == 64
>>       __kernel_time_t msg_stime;      /* last msgsnd time */
>> -#if __BITS_PER_LONG != 64
>> -     unsigned long   __unused1;
>> -#endif
>>       __kernel_time_t msg_rtime;      /* last msgrcv time */
>> -#if __BITS_PER_LONG != 64
>> -     unsigned long   __unused2;
>> -#endif
>>       __kernel_time_t msg_ctime;      /* last change time */
>> -#if __BITS_PER_LONG != 64
>> -     unsigned long   __unused3;
>> +#else
>> +     unsigned long   msg_stime;      /* last msgsnd time */
>> +     unsigned long   msg_stime_high;
>> +     unsigned long   msg_rtime;      /* last msgrcv time */
>> +     unsigned long   msg_rtime_high;
>> +     unsigned long   msg_ctime;      /* last change time */
>> +     unsigned long   msg_ctime_high;
>>  #endif
>
> I suspect you want to use __kernel_ulong_t here instead of a raw
> unsigned long.  If nothing else it seems inconsistent to use typedefs
> in one half of the structure and no typedefs in the other half.

Good catch, there is definitely something wrong here, but I think using
__kernel_ulong_t for all members would also be wrong, as that
still changes the layout on x32, which effectively is

struct msqid64_ds {
     ipc64_perm msg_perm;
     u64 msg_stime;
     u32 __unused1;
     /* 32 bit implict padding */
     u64 msg_rtime;
     u32 __unused2;
     /* 32 bit implict padding */
     u64 msg_ctime;
     u32 __unused3;
     /* 32 bit implict padding */
     __kernel_pid_t          shm_cpid;       /* pid of creator */
     __kernel_pid_t          shm_lpid;       /* pid of last operator */
     ....
};

The choices here would be to either use a mix of
__kernel_ulong_t and unsigned long, or taking the x32
version back into arch/x86/include/uapi/asm/ so the
generic version at least makes some sense.

I can't use __kernel_time_t for the lower half on 32-bit
since it really should be unsigned.

        Arnd
