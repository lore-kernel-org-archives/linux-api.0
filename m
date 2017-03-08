From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v1 3/4] arm/syscalls: Specific usage of verify_pre_usermode_state
Date: Wed, 8 Mar 2017 14:33:47 -0800
Message-ID: <CAJcbSZFCKVVQAXu2WGojnjHmJp05sRCQQpv=dCSTYjezE+aeeQ@mail.gmail.com>
References: <20170308213844.131877-1-thgarnie@google.com> <20170308213844.131877-3-thgarnie@google.com>
 <alpine.LFD.2.20.1703082256480.23532@knanqh.ubzr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6940-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <alpine.LFD.2.20.1703082256480.23532@knanqh.ubzr>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-api@vger.kernel.org

Make sense, as discussed on patch number one, I will write custom
assembly for each architecture when BUG_ON is not required. I will try
to use macros to make it easier to read.

On Wed, Mar 8, 2017 at 2:05 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Wed, 8 Mar 2017, Thomas Garnier wrote:
>
>> Implement specific usage of verify_pre_usermode_state for user-mode
>> returns for arm.
>> ---
>> Based on next-20170308
>> ---
>>  arch/arm/Kconfig               | 1 +
>>  arch/arm/kernel/entry-common.S | 5 +++++
>>  2 files changed, 6 insertions(+)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 0d4e71b42c77..704fd8f197fa 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -12,6 +12,7 @@ config ARM
>>       select ARCH_HAVE_CUSTOM_GPIO_H
>>       select ARCH_HAS_GCOV_PROFILE_ALL
>>       select ARCH_MIGHT_HAVE_PC_PARPORT
>> +     select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>>       select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
>>       select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT if CPU_V7
>>       select ARCH_SUPPORTS_ATOMIC_RMW
>> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
>> index eb5cd77bf1d8..80cfdc7fabde 100644
>> --- a/arch/arm/kernel/entry-common.S
>> +++ b/arch/arm/kernel/entry-common.S
>> @@ -39,6 +39,9 @@
>>  ret_fast_syscall:
>>   UNWIND(.fnstart     )
>>   UNWIND(.cantunwind  )
>> +     push    {r0}                            @ save returned r0
>> +     bl      verify_pre_usermode_state
>> +     pop     {r0}                            @ restore r0
>>       disable_irq_notrace                     @ disable interrupts
>>       ldr     r1, [tsk, #TI_FLAGS]            @ re-check for syscall tracing
>>       tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
>
> This feature is configurable, right?
>
> Here the branch overhead is imposed even if the feature is configured
> out. You should consider conditionally defining a macro like some other
> features do.
>
> Furthermore I think we still support old toolchains that don't know what
> push and pop mean. You should use the legacy syntax instead.
>
>
> Nicolas



-- 
Thomas
