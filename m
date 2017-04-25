From: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 1/4] syscalls: Restore address limit after a syscall
Date: Tue, 25 Apr 2017 07:18:35 -0700
Message-ID: <CAJcbSZH7Y6iBy3T3iWyh_AaFJ+TidP7E9iQEuCbShQrcTKGoyw@mail.gmail.com>
References: <20170410164420.64003-1-thgarnie@google.com> <20170425063305.hwjuxupa37rwe6zj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170425063305.hwjuxupa37rwe6zj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 24, 2017 at 11:33 PM, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
>> This patch ensures a syscall does not return to user-mode with a kernel
>> address limit. If that happened, a process can corrupt kernel-mode
>> memory and elevate privileges.
>
> Don't start changelogs with 'This patch' - it's obvious that we are talking about
> this patch. Writing:
>
>    Ensure that a syscall does not return to user-mode with a kernel address limit.
>    If that happens, a process can corrupt kernel-mode memory and elevate
>    privileges.
>
> also note the spelling fix I did. (There's another spelling error elsewhere in
> this changelog as well.)

I will take your change and go over other commits.

>
> Please read changelogs!
>
>> For example, it would mitigation this bug:
>>
>> - https://bugs.chromium.org/p/project-zero/issues/detail?id=990
>>
>> The CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE option is also
>> added so each architecture can optimize this change.
>
> As I pointed it out in my previous reply this Kconfig name is awfully long - but
> it should have been obvious when this changelog was written ...
>
>> Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Tested-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> ---
>> Based on next-20170410
>> ---
>>  arch/s390/Kconfig        |  1 +
>>  include/linux/syscalls.h | 26 +++++++++++++++++++++++++-
>>  init/Kconfig             |  6 ++++++
>>  kernel/sys.c             | 13 +++++++++++++
>>  4 files changed, 45 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
>> index d25435d94b6e..489a0cc6e46b 100644
>> --- a/arch/s390/Kconfig
>> +++ b/arch/s390/Kconfig
>> @@ -103,6 +103,7 @@ config S390
>>       select ARCH_INLINE_WRITE_UNLOCK_BH
>>       select ARCH_INLINE_WRITE_UNLOCK_IRQ
>>       select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
>> +     select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>>       select ARCH_SAVE_PAGE_KEYS if HIBERNATION
>>       select ARCH_SUPPORTS_ATOMIC_RMW
>>       select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index 980c3c9b06f8..801a7a74fe28 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -191,6 +191,27 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>>       SYSCALL_METADATA(sname, x, __VA_ARGS__)                 \
>>       __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>>
>> +
>> +/*
>> + * Called before coming back to user-mode. Returning to user-mode with an
>> + * address limit different than USER_DS can allow to overwrite kernel memory.
>> + */
>> +static inline void verify_pre_usermode_state(void) {
>> +     BUG_ON(!segment_eq(get_fs(), USER_DS));
>> +}
>
> Non-standard coding style.
>
>> +
>> +#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>> +#define __CHECK_USER_CALLER() \
>> +     bool user_caller = segment_eq(get_fs(), USER_DS)
>> +#define __VERIFY_PRE_USERMODE_STATE() \
>> +     if (user_caller) verify_pre_usermode_state()
>> +#else
>> +#define __CHECK_USER_CALLER()
>> +#define __VERIFY_PRE_USERMODE_STATE()
>> +asmlinkage void address_limit_check_failed(void);
>> +#endif
>> +
>> +
>>  #define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
>>  #define __SYSCALL_DEFINEx(x, name, ...)                                      \
>>       asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))       \
>> @@ -199,7 +220,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>>       asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));      \
>>       asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))       \
>>       {                                                               \
>> -             long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));  \
>> +             long ret;                                               \
>> +             __CHECK_USER_CALLER();                                  \
>> +             ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));       \
>> +             __VERIFY_PRE_USERMODE_STATE();                          \
>>               __MAP(x,__SC_TEST,__VA_ARGS__);                         \
>>               __PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));       \
>>               return ret;                                             \
>
> BTW., the '__VERIFY_PRE_USERMODE_STATE()' name is highly misleading: the 'pre'
> prefix suggests that this is done before a system call - while it's done
> afterwards.
>
> The solution is to not try to specify the exact call placement in the name, just
> describe the functionality (and harmonize along the common prefix).

Yes, I think BEFORE would have made more sense but things are getting
really long so I am fine with your proposal in the previous thread.

>
>> +config ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>> +     bool
>> +     help
>> +       Disable the generic pre-usermode state verification. Allow each
>> +       architecture to optimize how and when the verification is done.
>> +
>
> Please name the Kconfig symbols something like this:
>
>         CONFIG_ADDR_LIMIT_CHECK
>         CONFIG_ADDR_LIMIT_CHECK_ARCH
>
> or so, which tells us whether the check is done by the architecture code, without
> breaking the col80 limit with a single Kconfig name.
>
> BTW:
>
>> +#ifdef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>> +/*
>> + * This function is called when an architecture specific implementation detected
>> + * an invalid address limit. The generic user-mode state checker will finish on
>> + * the appropriate BUG_ON.
>> + */
>> +asmlinkage void address_limit_check_failed(void)
>> +{
>> +     verify_pre_usermode_state();
>> +     panic("address_limit_check_failed called with a valid user-mode state");
>
> It's very unconstructive to unconditionally panic the system, just because some
> kernel code leaked the address limit! Do a warn-once printout and kill the current
> task (i.e. don't continue execution), but don't crash everything else!

The original change did not crash the kernel for this exact reason.
Through reviews, there was an overall agreement that the kernel should
not continue in this state.

>
> Thanks,
>
>         Ingo



-- 
Thomas
