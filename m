From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for 4.16 07/11] x86: Implement sync_core_before_usermode (v3)
Date: Wed, 17 Jan 2018 10:13:05 -0800
Message-ID: <CALCETrV2Cve1sW=UXHgjTWMKfsiwY5QdeaBnQRZGfpELLKry+A@mail.gmail.com>
References: <20180117165458.13330-1-mathieu.desnoyers@efficios.com>
 <20180117165458.13330-8-mathieu.desnoyers@efficios.com> <CALCETrWqRPsmLY=sTo5YHbWRh3HWjrVQ4FOn-=YfP=4_n98F6w@mail.gmail.com>
 <712464074.4666.1516212636860.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <712464074.4666.1516212636860.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <wi>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 17, 2018 at 10:10 AM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> ----- On Jan 17, 2018, at 12:53 PM, Andy Lutomirski luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
>
>> On Wed, Jan 17, 2018 at 8:54 AM, Mathieu Desnoyers
>> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>>> Ensure that a core serializing instruction is issued before returning to
>>> user-mode. x86 implements return to user-space through sysexit, sysrel,
>>> and sysretq, which are not core serializing.
>>>
>>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>>> Reviewed-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>>> CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>>> CC: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> CC: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>> CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> CC: Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> CC: Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>
>>> CC: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
>>> CC: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>> CC: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
>>> CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
>>> CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> CC: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
>>> CC: Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> CC: Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
>>> CC: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
>>> CC: David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>> CC: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>>> CC: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> ---
>>> Changes since v1:
>>> - Fix prototype of sync_core_before_usermode in generic code (missing
>>>   return type).
>>> - Add linux/processor.h include to sched/core.c.
>>> - Add ARCH_HAS_SYNC_CORE_BEFORE_USERMODE to init/Kconfig.
>>> - Fix linux/processor.h ifdef to target
>>>   CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE rather than
>>>   ARCH_HAS_SYNC_CORE_BEFORE_USERMODE.
>>> - Move empty static inline in processor.h to generic patch.
>>> ---
>>>  arch/x86/Kconfig                 |  1 +
>>>  arch/x86/include/asm/processor.h | 10 ++++++++++
>>>  2 files changed, 11 insertions(+)
>>>
>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>> index 20da391b5f32..0b44c8dd0e95 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -61,6 +61,7 @@ config X86
>>>         select ARCH_HAS_SG_CHAIN
>>>         select ARCH_HAS_STRICT_KERNEL_RWX
>>>         select ARCH_HAS_STRICT_MODULE_RWX
>>> +       select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
>>>         select ARCH_HAS_UBSAN_SANITIZE_ALL
>>>         select ARCH_HAS_ZONE_DEVICE             if X86_64
>>>         select ARCH_HAVE_NMI_SAFE_CMPXCHG
>>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>>> index d3a67fba200a..3257d34dbb40 100644
>>> --- a/arch/x86/include/asm/processor.h
>>> +++ b/arch/x86/include/asm/processor.h
>>> @@ -722,6 +722,16 @@ static inline void sync_core(void)
>>>  #endif
>>>  }
>>>
>>> +/*
>>> + * Ensure that a core serializing instruction is issued before returning
>>> + * to user-mode. x86 implements return to user-space through sysexit,
>>> + * sysrel, and sysretq, which are not core serializing.
>>> + */
>>> +static inline void sync_core_before_usermode(void)
>>> +{
>>
>> /* With PTI, we unconditionally serialize before running user code. */
>> if (static_cpu_has(X86_FEATURE_PTI))
>>  return;
>
> One issue I'm facing with this change is header dependency:
> sync_core_before_usermode() is currently implemented in
> arch/x86/include/asm/processor.h, but arch/x86/include/asm/cpufeature.h
> is needed for static_cpu_has, and it happens to include
> asm/processor.h.
>
> I'm facing a similar issue for adding a (in_irq() || in_nmi()) check.
>
> Should we move sync_core_before_usermode() to a different header, and if
> so, any suggestion ?

tlbflush.h, maybe?

>
> Thanks,
>
> Mathieu
>
>
>
>>
>>> +       sync_core();
>>> +}
>>
>> --Andy
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
