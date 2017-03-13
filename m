From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Mon, 13 Mar 2017 14:48:15 -0700
Message-ID: <201703132148.v2DLmNa7028340@mail.zytor.com>
References: <20170311000501.46607-1-thgarnie@google.com> <20170311000501.46607-2-thgarnie@google.com> <20170311094200.GA27700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170311094200.GA27700-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?ISO-8859-1?Q?Ren=E9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Nicolas Pitre <nicolas.pitre-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Stultz <john.stult>
List-Id: linux-api@vger.kernel.org

<skinsbursky-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>,Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>,Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>,Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,He Chen <he.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>,Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>,Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>,"David A . Long" <dave.long-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>,Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,linux-
 s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
From: hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Message-ID: <BB78ABF9-382E-43E8-BAC6-1EA6416A30DB-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>

On March 11, 2017 1:42:00 AM PST, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>* Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
>> Implement specific usage of verify_pre_usermode_state for user-mode
>> returns for x86.
>> ---
>> Based on next-20170308
>> ---
>>  arch/x86/Kconfig                        |  1 +
>>  arch/x86/entry/common.c                 |  3 +++
>>  arch/x86/entry/entry_64.S               | 19 +++++++++++++++++++
>>  arch/x86/include/asm/pgtable_64_types.h | 11 +++++++++++
>>  arch/x86/include/asm/processor.h        | 11 -----------
>>  5 files changed, 34 insertions(+), 11 deletions(-)
>> 
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 005df7c825f5..6d48e18e6f09 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -63,6 +63,7 @@ config X86
>>  	select ARCH_MIGHT_HAVE_ACPI_PDC		if ACPI
>>  	select ARCH_MIGHT_HAVE_PC_PARPORT
>>  	select ARCH_MIGHT_HAVE_PC_SERIO
>> +	select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>>  	select ARCH_SUPPORTS_ATOMIC_RMW
>>  	select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
>>  	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
>> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
>> index 370c42c7f046..525edbb77f03 100644
>> --- a/arch/x86/entry/common.c
>> +++ b/arch/x86/entry/common.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/context_tracking.h>
>>  #include <linux/user-return-notifier.h>
>>  #include <linux/uprobes.h>
>> +#include <linux/syscalls.h>
>>  
>>  #include <asm/desc.h>
>>  #include <asm/traps.h>
>> @@ -180,6 +181,8 @@ __visible inline void
>prepare_exit_to_usermode(struct pt_regs *regs)
>>  	struct thread_info *ti = current_thread_info();
>>  	u32 cached_flags;
>>  
>> +	verify_pre_usermode_state();
>> +
>>  	if (IS_ENABLED(CONFIG_PROVE_LOCKING) && WARN_ON(!irqs_disabled()))
>>  		local_irq_disable();
>>  
>> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
>> index d2b2a2948ffe..04db589be466 100644
>> --- a/arch/x86/entry/entry_64.S
>> +++ b/arch/x86/entry/entry_64.S
>> @@ -218,6 +218,25 @@ entry_SYSCALL_64_fastpath:
>>  	testl	$_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
>>  	jnz	1f
>>  
>> +	/*
>> +	 * Check user-mode state on fast path return, the same check is
>done
>> +	 * under the slow path through syscall_return_slowpath.
>> +	 */
>> +#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
>> +	call	verify_pre_usermode_state
>> +#else
>> +	/*
>> +	 * Similar to set_fs(USER_DS) in verify_pre_usermode_state without
>a
>> +	 * warning.
>> +	 */
>> +	movq	PER_CPU_VAR(current_task), %rax
>> +	movq	$TASK_SIZE_MAX, %rcx
>> +	cmp	%rcx, TASK_addr_limit(%rax)
>> +	jz	1f
>> +	movq	%rcx, TASK_addr_limit(%rax)
>> +1:
>> +#endif
>> +
>>  	LOCKDEP_SYS_EXIT
>>  	TRACE_IRQS_ON		/* user mode is traced as IRQs on */
>>  	movq	RIP(%rsp), %rcx
>
>Ugh, so you call an assembly function just to ... call another
>function.
>
>Plus why is it in assembly to begin with? Is this some older code that
>got
>written when the x86 entry code was in assembly, and never properly
>converted to C?
>
>Thanks,
>
>	Ingo

The code does a compare to jump around a store.  It would be much cleaner and faster to simply clobber the value unconditionally.  If there is a test it should be to avoid the function call, not (only) the assignment.
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
