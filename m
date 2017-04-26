From: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 1/4] syscalls: Restore address limit after a syscall
Date: Wed, 26 Apr 2017 07:09:14 -0700
Message-ID: <CAJcbSZGKknsc6YdwFjd-JHnXA0wjEpU7rCYjJCezQ7bwAxMn1A@mail.gmail.com>
References: <20170410164420.64003-1-thgarnie@google.com> <20170425063305.hwjuxupa37rwe6zj@gmail.com>
 <CAJcbSZH7Y6iBy3T3iWyh_AaFJ+TidP7E9iQEuCbShQrcTKGoyw@mail.gmail.com> <20170426081229.6wnugrs7w3at4xry@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170426081229.6wnugrs7w3at4xry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 26, 2017 at 1:12 AM, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
>> >> +#ifdef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>> >> +/*
>> >> + * This function is called when an architecture specific implementation detected
>> >> + * an invalid address limit. The generic user-mode state checker will finish on
>> >> + * the appropriate BUG_ON.
>> >> + */
>> >> +asmlinkage void address_limit_check_failed(void)
>> >> +{
>> >> +     verify_pre_usermode_state();
>> >> +     panic("address_limit_check_failed called with a valid user-mode state");
>> >
>> > It's very unconstructive to unconditionally panic the system, just because some
>> > kernel code leaked the address limit! Do a warn-once printout and kill the current
>> > task (i.e. don't continue execution), but don't crash everything else!
>>
>> The original change did not crash the kernel for this exact reason.
>> Through reviews, there was an overall agreement that the kernel should
>> not continue in this state.
>
> Ok, I guess we can try that - but the panic message is still pretty misleading:
>
>         panic("address_limit_check_failed called with a valid user-mode state");
>
> ... so it was called with a _valid_ user-mode state, and we crash due to something
> valid? Huh?

Yes the message is accurate but I agree that it is misleading and I
will improve it. The address_limit_check_failed function is called by
assembly code on different architectures once the state was detected
as invalid. Instead of crashing at different places, we redirect to
the generic handler (verify_pre_usermode_state) that will crash on the
appropriate BUG_ON line. The address_limit_check_failed function is
not supposed to comeback, the panic call is just a safe guard.

>
> ( Also, the style rule applies to kernel messages as well: function names should
>   be referred to as "function_name()". )

Will change.

>
> Thanks,
>
>         Ingo



-- 
Thomas
