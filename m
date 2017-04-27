From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v8 1/4] syscalls: Verify address limit before returning to user-mode
Date: Thu, 27 Apr 2017 07:16:41 -0700
Message-ID: <CAJcbSZENjCgn3TNDGzCBBSOXMvbTX8mBO7Trugdb5VRzhxwmHg@mail.gmail.com>
References: <20170426183425.32158-1-thgarnie@google.com> <20170427064917.phwo6yl4v4q43fql@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7611-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170427064917.phwo6yl4v4q43fql@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 26, 2017 at 11:49 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> +
>> +/*
>> + * Called before coming back to user-mode. Returning to user-mode with an
>> + * address limit different than USER_DS can allow to overwrite kernel memory.
>> + */
>> +static inline void addr_limit_check_syscall(void)
>> +{
>> +     BUG_ON(!segment_eq(get_fs(), USER_DS));
>> +}
>> +
>> +#ifndef CONFIG_ADDR_LIMIT_CHECK
>> +#define __CHECK_USERMODE_SYSCALL() \
>> +     bool user_caller = segment_eq(get_fs(), USER_DS)
>> +#define __VERIFY_ADDR_LIMIT() \
>> +     if (user_caller) addr_limit_check_syscall()
>> +#else
>> +#define __CHECK_USERMODE_SYSCALL()
>> +#define __VERIFY_ADDR_LIMIT()
>> +asmlinkage void addr_limit_check_failed(void) __noreturn;
>> +#endif
>
> _Please_ harmonize all the externally exposed names and symbols.
>
> There's no reason for this mismash of names:
>
>         CONFIG_ADDR_LIMIT_CHECK
>
>         __CHECK_USERMODE_SYSCALL
>         __VERIFY_ADDR_LIMIT
>
> When we could just as easily name them consistently, along the existing pattern:
>
>         CONFIG_ADDR_LIMIT_CHECK
>
>         __SYSCALL_ADDR_LIMIT_CHECK
>         __ADDR_LIMIT_CHECK
>
> which should fit into existing nomenclature:
>
>>  #define __SYSCALL_DEFINEx(x, name, ...)                                      \
>
> But even with that fixed, the whole construct still looks pretty weird:
>
>>       {                                                               \
>> -             long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));  \
>> +             long ret;                                               \
>> +             __CHECK_USERMODE_SYSCALL();                             \
>> +             ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));       \
>> +             __ADDR_LIMIT_CHECK();                                   \
>>               __MAP(x,__SC_TEST,__VA_ARGS__);                         \
>>               __PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));       \
>>               return ret;                                             \
>
> I think something like this would be more natural to read:
>
>> +             ADDR_LIMIT_CHECK_PRE();                                 \
>> +             ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));       \
>> +             ADDR_LIMIT_CHECK_POST();                                \
>
> it's a clear pre/post construct. Also note the lack of double underscores.

I think this construct makes more sense because the first macro check
if the syscall was called by user-mode. I will send an update for this
on this thread.

>
> BTW., a further simplification would be:
>
> #ifndef ADDR_LIMIT_CHECK_PRE
> # define ADDR_LIMIT_CHECK_PRE ...
> #endif
>
> This way architectures could override this generic functionality simply by
> defining the helpers. Architectures that don't do that get the generic version.

I don't think architectures need to do that. The optimizations are
embedding the checks on their architecture-specific code to make it
faster and remove the size impact. The pre/post is fine for the rest.

>
> Thanks,
>
>         Ingo



-- 
Thomas
