From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [RFC] syscalls: Restore address limit after a syscall
Date: Thu, 9 Feb 2017 15:41:58 -0800
Message-ID: <CAJcbSZHv7w5jYQ2AZ-g4Kc0mX0jRRbHCKwFKx1EFuOAby1yxXA@mail.gmail.com>
References: <20170209183358.103094-1-thgarnie@google.com> <CAGXu5j+hyXxpyU1R+BeL9RwPhT6HSNE0c_b7MP_V0rYSAepYFw@mail.gmail.com>
 <CALCETrWrbDnka=aqzQ5+7WN2N6RwFsQb7smcnjQMsjov+y=dTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6442-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrWrbDnka=aqzQ5+7WN2N6RwFsQb7smcnjQMsjov+y=dTQ@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Stephen Bates <stephen.bates@pmcs.com>, Jeff Moyer <jmoyer@redhat.com>, Milosz Tanski <milosz@adfin.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 9, 2017 at 3:05 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Feb 9, 2017 at 11:31 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Feb 9, 2017 at 10:33 AM, Thomas Garnier <thgarnie@google.com> wrote:
>>> This patch prevents a syscall to modify the address limit of the
>>> caller. The address limit is kept by the syscall wrapper and restored
>>> just after the syscall ends.
>>>
>>> For example, it would mitigation this bug:
>>>
>>> - https://bugs.chromium.org/p/project-zero/issues/detail?id=990
>>>
>>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>>> ---
>>> Based on next-20170209
>>> ---
>>>  include/linux/syscalls.h | 5 ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>>> index 91a740f6b884..a1b6a62a9849 100644
>>> --- a/include/linux/syscalls.h
>>> +++ b/include/linux/syscalls.h
>>> @@ -198,7 +198,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>>>         asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));      \
>>>         asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))       \
>>>         {                                                               \
>>> -               long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));  \
>>> +               long ret;                                               \
>>> +               mm_segment_t fs = get_fs();                             \
>>> +               ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));       \
>>> +               set_fs(fs);                                             \
>>>                 __MAP(x,__SC_TEST,__VA_ARGS__);                         \
>>>                 __PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));       \
>>>                 return ret;                                             \
>>> --
>>> 2.11.0.483.g087da7b7c-goog
>>>
>>
>> I have a memory of Andy looking at this before, and there was some
>> problem with how a bunch of compat code would set fs and then re-call
>> the syscall... but I can't quite find the conversation. Andy, do you
>> remember the details?
>>
>> This seems like an entirely reasonable thing to enforce for syscalls,
>> though I'm sure there's a gotcha somewhere. :)
>
> This sounds vaguely familiar, but that's about all.
>
> Anyway, it seems reasonable that the SyS_foobar wrappers are genuinely
> only used for syscalls and not for other things, so the code should
> *work*.  That being said, I think there's room for several
> improvements.
>
> 1. Why save the old "fs" value?  For that matter, why restore it?
> IOW, I'd rather see BUG_ON(get_fs() != USER_DS) at the end.
>

I guess that make sense in the wrapper.

> 2. I'd rather see the mechanism be more general.  If we had, effectively:
>
> asmlinkage long SyS_foo(...) {
>   sys_foo();
>   verify_pre_usermode_state();
> }
>
> and let verify_pre_usermode_state() potentially do more things, we'd
> get a more flexible mechanism.  On arches like x86_32, we could save a
> decent amount of code size by moving verify_pre_usermode_state() into
> prepare_exit_to_usermode(), but that would have to be a per-arch
> opt-in.  x86_64 probably would *not* select this due to the fast path
> (or it would do it in asm.  hmm.).
>

I will look into that. I like this design better.

> 3. If this thing gets factored out, then arch code can call it for
> non-syscall entries, too.
>

Yes, it makes sense.

> 4. Can we make this configurable?
>
>
> For x86, a nice implementation might be:
>
> select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>
> ... in prepare_exit_to_usermode():
>
> verify_pre_usermode_state();  // right at the beginning
>
> ... in the asm syscall fast path:
>
> #ifdef CONFIG_VERIFY_PRE_USERMODE_STATE
> call verify_pre_usermode_staet
> #endif
>
> (or just inline the interesting bit)
>

So by default it is in the wrapper. If selected, an architecture can
disable the wrapper put it in the best places. Understood correctly?

> --Andy



-- 
Thomas
