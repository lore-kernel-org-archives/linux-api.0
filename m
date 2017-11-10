From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 05/10] x86: Introduce
 sync_core_before_usermode
Date: Fri, 10 Nov 2017 22:20:30 +0000 (UTC)
Message-ID: <1007217384.13056.1510352430448.JavaMail.zimbra@efficios.com>
References: <20171110213717.12457-1-mathieu.desnoyers@efficios.com> <20171110213717.12457-6-mathieu.desnoyers@efficios.com> <CALCETrWV+bgUPoS7NqVYhoi7hOyvsfoWw5CnyMrkYz=HYznmXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWV+bgUPoS7NqVYhoi7hOyvsfoWw5CnyMrkYz=HYznmXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David
List-Id: linux-api@vger.kernel.org

----- On Nov 10, 2017, at 5:02 PM, Andy Lutomirski luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

> On Fri, Nov 10, 2017 at 1:37 PM, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> Introduce an architecture function that ensures the current CPU
>> issues a core serializing instruction before returning to usermode.
>>
>> This is needed to fix an existing core serialization bug on
>> thread migration, and also needed by the membarrier "sync_core" command.
>>
>> Architectures defining the sync_core_before_usermode() static inline
>> need to define ARCH_HAS_SYNC_CORE_BEFORE_USERMODE.
>>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> CC: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> CC: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> CC: Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> CC: Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>
>> CC: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
>> CC: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> CC: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
>> CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
>> CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> CC: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
>> CC: Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> CC: Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
>> CC: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
>> CC: David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> CC: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>> CC: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>>  arch/x86/Kconfig                 |  1 +
>>  arch/x86/include/asm/processor.h | 10 ++++++++++
>>  include/linux/processor.h        |  6 ++++++
>>  3 files changed, 17 insertions(+)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 01f78c1d40b5..54fbb8960d94 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -62,6 +62,7 @@ config X86
>>         select ARCH_HAS_SG_CHAIN
>>         select ARCH_HAS_STRICT_KERNEL_RWX
>>         select ARCH_HAS_STRICT_MODULE_RWX
>> +       select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
>>         select ARCH_HAS_UBSAN_SANITIZE_ALL
>>         select ARCH_HAS_ZONE_DEVICE             if X86_64
>>         select ARCH_HAVE_NMI_SAFE_CMPXCHG
>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>> index bdac19ab2488..6ce996a7c730 100644
>> --- a/arch/x86/include/asm/processor.h
>> +++ b/arch/x86/include/asm/processor.h
>> @@ -706,6 +706,16 @@ static inline void sync_core(void)
>>  #endif
>>  }
>>
>> +/*
>> + * Ensure that a core serializing instruction is issued before returning
>> + * to user-mode. x86 implements return to user-space through sysexit and
>> + * sysretq, which are not core serializing.
>> + */
>> +static inline void sync_core_before_usermode(void)
>> +{
>> +       sync_core();
>> +}
> 
> Make this if (!in_interrupt()) sync_core(); please.  We can optimize
> it better later on.

Sure, done. It will be part of the next version of that patch.

Thanks!

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
