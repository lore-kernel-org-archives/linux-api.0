From: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Tue, 4 Apr 2017 12:21:48 -0700
Message-ID: <CAJcbSZGWX23QTWmM4a_07ui-8Xyz4H2NLj1LXFFbZvnv9tc_XQ@mail.gmail.com>
References: <20170404174727.35478-1-thgarnie@google.com> <20170404174727.35478-2-thgarnie@google.com>
 <05d9c4a7-8acb-5997-1dd6-d534398e6f54@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <05d9c4a7-8acb-5997-1dd6-d534398e6f54-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh
List-Id: linux-api@vger.kernel.org

On Tue, Apr 4, 2017 at 11:27 AM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
> On 04/04/17 10:47, Thomas Garnier wrote:
>> diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
>> index 516593e66bd6..12fa851c7fa8 100644
>> --- a/arch/x86/include/asm/pgtable_64_types.h
>> +++ b/arch/x86/include/asm/pgtable_64_types.h
>> @@ -78,4 +78,15 @@ typedef struct { pteval_t pte; } pte_t;
>>
>>  #define EARLY_DYNAMIC_PAGE_TABLES    64
>>
>> +/*
>> + * User space process size. 47bits minus one guard page.  The guard
>> + * page is necessary on Intel CPUs: if a SYSCALL instruction is at
>> + * the highest possible canonical userspace address, then that
>> + * syscall will enter the kernel with a non-canonical return
>> + * address, and SYSRET will explode dangerously.  We avoid this
>> + * particular problem by preventing anything from being mapped
>> + * at the maximum canonical address.
>> + */
>> +#define TASK_SIZE_MAX        ((_AC(1, UL) << 47) - PAGE_SIZE)
>> +
>>  #endif /* _ASM_X86_PGTABLE_64_DEFS_H */
>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>> index 3cada998a402..e80822582d3e 100644
>> --- a/arch/x86/include/asm/processor.h
>> +++ b/arch/x86/include/asm/processor.h
>> @@ -825,17 +825,6 @@ static inline void spin_lock_prefetch(const void *x)
>>  #define KSTK_ESP(task)               (task_pt_regs(task)->sp)
>>
>>  #else
>> -/*
>> - * User space process size. 47bits minus one guard page.  The guard
>> - * page is necessary on Intel CPUs: if a SYSCALL instruction is at
>> - * the highest possible canonical userspace address, then that
>> - * syscall will enter the kernel with a non-canonical return
>> - * address, and SYSRET will explode dangerously.  We avoid this
>> - * particular problem by preventing anything from being mapped
>> - * at the maximum canonical address.
>> - */
>> -#define TASK_SIZE_MAX        ((1UL << 47) - PAGE_SIZE)
>> -
>>  /* This decides where the kernel will search for a free chunk of vm
>>   * space during mmap's.
>>   */
>>
>
> This should be an entirely separate patch; if nothing else you need to
> explain it in the comments.

I will explain it in the commit message, it should be easier than a
separate patch.

>
> Also, you say this is for "x86", but I still don't see any code for i386
> whatsoever.  Have you verified *all* the i386 and i386-compat paths to
> make sure they go via prepare_exit_to_usermode()?  [Cc: Andy]

I did but I will do it again for the next iteration.

>
> Finally, I can't really believe I'm the only person for whom "Specific
> usage of verity_pre_usermode_state" is completely opaque.

I agree, I will improve it.

>
>         -hpa
>



-- 
Thomas
