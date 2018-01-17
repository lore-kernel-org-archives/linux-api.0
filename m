From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for 4.16 07/11] x86: Implement sync_core_before_usermode (v3)
Date: Wed, 17 Jan 2018 15:37:58 -0800
Message-ID: <CALCETrUVhb0LkVP++h5Vibd+iN3g2kfQJJFL1reucvG=v-3QSw@mail.gmail.com>
References: <20180117165458.13330-1-mathieu.desnoyers@efficios.com>
 <20180117165458.13330-8-mathieu.desnoyers@efficios.com> <CALCETrWqRPsmLY=sTo5YHbWRh3HWjrVQ4FOn-=YfP=4_n98F6w@mail.gmail.com>
 <712464074.4666.1516212636860.JavaMail.zimbra@efficios.com>
 <CALCETrV2Cve1sW=UXHgjTWMKfsiwY5QdeaBnQRZGfpELLKry+A@mail.gmail.com> <80094124.4887.1516231532603.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <80094124.4887.1516231532603.JavaMail.zimbra@efficios.com>
Sender: linux-arch-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, maged michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, "Russell King, ARM Linux" <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <wi>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 17, 2018 at 3:25 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> ----- On Jan 17, 2018, at 1:13 PM, Andy Lutomirski luto@kernel.org wrote:
>
>> On Wed, Jan 17, 2018 at 10:10 AM, Mathieu Desnoyers
>> <mathieu.desnoyers@efficios.com> wrote:
>>> ----- On Jan 17, 2018, at 12:53 PM, Andy Lutomirski luto@kernel.org wrote:
>>>
>>>> On Wed, Jan 17, 2018 at 8:54 AM, Mathieu Desnoyers
>>>> <mathieu.desnoyers@efficios.com> wrote:
>>>>> Ensure that a core serializing instruction is issued before returning to
>>>>> user-mode. x86 implements return to user-space through sysexit, sysrel,
>>>>> and sysretq, which are not core serializing.
>>>>>
>>>>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>>>> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
>>>>> CC: Peter Zijlstra <peterz@infradead.org>
>>>>> CC: Andy Lutomirski <luto@kernel.org>
>>>>> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>>>> CC: Boqun Feng <boqun.feng@gmail.com>
>>>>> CC: Andrew Hunter <ahh@google.com>
>>>>> CC: Maged Michael <maged.michael@gmail.com>
>>>>> CC: Avi Kivity <avi@scylladb.com>
>>>>> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>>>> CC: Paul Mackerras <paulus@samba.org>
>>>>> CC: Michael Ellerman <mpe@ellerman.id.au>
>>>>> CC: Dave Watson <davejwatson@fb.com>
>>>>> CC: Ingo Molnar <mingo@redhat.com>
>>>>> CC: "H. Peter Anvin" <hpa@zytor.com>
>>>>> CC: Andrea Parri <parri.andrea@gmail.com>
>>>>> CC: Russell King <linux@armlinux.org.uk>
>>>>> CC: Greg Hackmann <ghackmann@google.com>
>>>>> CC: Will Deacon <will.deacon@arm.com>
>>>>> CC: David Sehr <sehr@google.com>
>>>>> CC: Linus Torvalds <torvalds@linux-foundation.org>
>>>>> CC: x86@kernel.org
>>>>> CC: linux-arch@vger.kernel.org
>>>>> ---
>>>>> Changes since v1:
>>>>> - Fix prototype of sync_core_before_usermode in generic code (missing
>>>>>   return type).
>>>>> - Add linux/processor.h include to sched/core.c.
>>>>> - Add ARCH_HAS_SYNC_CORE_BEFORE_USERMODE to init/Kconfig.
>>>>> - Fix linux/processor.h ifdef to target
>>>>>   CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE rather than
>>>>>   ARCH_HAS_SYNC_CORE_BEFORE_USERMODE.
>>>>> - Move empty static inline in processor.h to generic patch.
>>>>> ---
>>>>>  arch/x86/Kconfig                 |  1 +
>>>>>  arch/x86/include/asm/processor.h | 10 ++++++++++
>>>>>  2 files changed, 11 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>>> index 20da391b5f32..0b44c8dd0e95 100644
>>>>> --- a/arch/x86/Kconfig
>>>>> +++ b/arch/x86/Kconfig
>>>>> @@ -61,6 +61,7 @@ config X86
>>>>>         select ARCH_HAS_SG_CHAIN
>>>>>         select ARCH_HAS_STRICT_KERNEL_RWX
>>>>>         select ARCH_HAS_STRICT_MODULE_RWX
>>>>> +       select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
>>>>>         select ARCH_HAS_UBSAN_SANITIZE_ALL
>>>>>         select ARCH_HAS_ZONE_DEVICE             if X86_64
>>>>>         select ARCH_HAVE_NMI_SAFE_CMPXCHG
>>>>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>>>>> index d3a67fba200a..3257d34dbb40 100644
>>>>> --- a/arch/x86/include/asm/processor.h
>>>>> +++ b/arch/x86/include/asm/processor.h
>>>>> @@ -722,6 +722,16 @@ static inline void sync_core(void)
>>>>>  #endif
>>>>>  }
>>>>>
>>>>> +/*
>>>>> + * Ensure that a core serializing instruction is issued before returning
>>>>> + * to user-mode. x86 implements return to user-space through sysexit,
>>>>> + * sysrel, and sysretq, which are not core serializing.
>>>>> + */
>>>>> +static inline void sync_core_before_usermode(void)
>>>>> +{
>>>>
>>>> /* With PTI, we unconditionally serialize before running user code. */
>>>> if (static_cpu_has(X86_FEATURE_PTI))
>>>>  return;
>>>
>>> One issue I'm facing with this change is header dependency:
>>> sync_core_before_usermode() is currently implemented in
>>> arch/x86/include/asm/processor.h, but arch/x86/include/asm/cpufeature.h
>>> is needed for static_cpu_has, and it happens to include
>>> asm/processor.h.
>>>
>>> I'm facing a similar issue for adding a (in_irq() || in_nmi()) check.
>>>
>>> Should we move sync_core_before_usermode() to a different header, and if
>>> so, any suggestion ?
>>
>> tlbflush.h, maybe?
>
> Core serialization seems to be unrelated to TLB flushing though.
>
> I'm considering to create those new header files:
>
> include/asm-generic/sync_core.h (empty function)
> arch/x86/include/asm/sync_core.h
>
> for the sync_core_before_usermode() static inlines. Any better idea ?

Seems reasonable to me.  Or maybe switch_to.h.
