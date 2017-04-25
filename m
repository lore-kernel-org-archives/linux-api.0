From: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 1/4] syscalls: Restore address limit after a syscall
Date: Tue, 25 Apr 2017 07:12:56 -0700
Message-ID: <CAJcbSZGY3JmZankf+d6=gfg9gBWUoVUkWLDnCzaC81scPm+uBA@mail.gmail.com>
References: <20170410164420.64003-1-thgarnie@google.com> <CAGXu5j+J67zC9tcncacHTDvXKMF3HZuPCivk-Uz4J6h-cEv-qQ@mail.gmail.com>
 <20170425062324.pdpi5v7ypobw74ki@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170425062324.pdpi5v7ypobw74ki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 24, 2017 at 11:23 PM, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>
>> On Mon, Apr 10, 2017 at 9:44 AM, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> > This patch ensures a syscall does not return to user-mode with a kernel
>> > address limit. If that happened, a process can corrupt kernel-mode
>> > memory and elevate privileges.
>> >
>> > For example, it would mitigation this bug:
>> >
>> > - https://bugs.chromium.org/p/project-zero/issues/detail?id=990
>> >
>> > The CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE option is also
>> > added so each architecture can optimize this change.
>> >
>> > Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> > Tested-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>
>> Ingo, I think this series is ready. Can you pull it? (And if not, what
>> should next steps be?)
>
> I have some feedback for other patches in this series, plus for this one as well:
>
>> > +/*
>> > + * Called before coming back to user-mode. Returning to user-mode with an
>> > + * address limit different than USER_DS can allow to overwrite kernel memory.
>> > + */
>> > +static inline void verify_pre_usermode_state(void) {
>> > +       BUG_ON(!segment_eq(get_fs(), USER_DS));
>> > +}
>
> That's not standard kernel coding style.
>
> Also, patch titles should start with a verb - 75% of the series doesn't.

Will fix both.

>
>> > +#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>> > +#define __CHECK_USER_CALLER() \
>> > +       bool user_caller = segment_eq(get_fs(), USER_DS)
>> > +#define __VERIFY_PRE_USERMODE_STATE() \
>> > +       if (user_caller) verify_pre_usermode_state()
>> > +#else
>> > +#define __CHECK_USER_CALLER()
>> > +#define __VERIFY_PRE_USERMODE_STATE()
>> > +asmlinkage void address_limit_check_failed(void);
>> > +#endif
>
>> > +#ifdef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>
> That Kconfig name is way too long.
>
> Plus please don't put logical operations into Kconfig names.
>
>> > +/*
>> > + * This function is called when an architecture specific implementation detected
>> > + * an invalid address limit. The generic user-mode state checker will finish on
>> > + * the appropriate BUG_ON.
>> > + */
>> > +asmlinkage void address_limit_check_failed(void)
>> > +{
>> > +       verify_pre_usermode_state();
>> > +       panic("address_limit_check_failed called with a valid user-mode state");
>> > +}
>> > +#endif
>
> Awful naming all around:
>
>         verify_pre_usermode_state()
>         address_limit_check_failed()
>
> Both names start with very common names that makes one read these again and again.
> (And yes, there's lots of bad names in the kernel, but we should not follow bad
> examples.)
>
> Best practice for such functionality is to use a common prefix that is both easy
> to recognize and easy to skip. For example we could use 'addr_limit_check' as the
> prefix:
>
>         addr_limit_check_failed()
>         addr_limit_check_syscall()
>
> No need to over-specify it that it's a "pre" check - it's obvious from existing
> implementation and should be documented in the function itself for new
> implementations.
>
> Harmonize the Kconfig namespace to the common prefix as well, i.e. use something
> like:
>
>         CONFIG_ADDR_LIMIT_CHECK
>
> No need to add 'ARCH' I think - an architecture that enables this should get it
> unconditionally.
>
> etc.
>
> It's all cobbled together I'm afraid and will need more iterations.

Make sense. Thanks for the feedback.

>
> Thanks,
>
>         Ingo



-- 
Thomas
