From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v2 1/4] syscalls: Restore address limit after a syscall
Date: Thu, 9 Mar 2017 09:41:14 -0800
Message-ID: <CAJcbSZG1WR5QktwEsfe0MCyRW+1gKJg3axM29QkF-=J4qe6uYg@mail.gmail.com>
References: <20170309012456.5631-1-thgarnie@google.com> <20170309084208.ims3ehcnieo7uqew@pd.tnic>
 <CALCETrWE5KzrAC6Os3y0f9CJMnM6znQQSSaexin8CC8JB9q1bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6980-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrWE5KzrAC6Os3y0f9CJMnM6znQQSSaexin8CC8JB9q1bQ@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel
List-Id: linux-api@vger.kernel.org

On Thu, Mar 9, 2017 at 9:27 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Mar 9, 2017 at 12:42 AM, Borislav Petkov <bp@alien8.de> wrote:
>> On Wed, Mar 08, 2017 at 05:24:53PM -0800, Thomas Garnier wrote:
>>> @@ -191,6 +191,22 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>>>       SYSCALL_METADATA(sname, x, __VA_ARGS__)                 \
>>>       __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>>>
>>> +asmlinkage void verify_pre_usermode_state(void);
>>> +
>>> +#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>>> +static inline bool has_user_ds(void) {
>>> +     bool ret = segment_eq(get_fs(), USER_DS);
>>> +     // Prevent re-ordering the call
>>
>> This is not the kernel comments style. Use /* */ instead.
>>
>>> +     barrier();
>>> +     return ret;
>>> +}
>>> +#else
>>> +static inline bool has_user_ds(void) {
>>> +     return false;
>>> +}
>>> +#endif
>>
>> ... and then you could slim down the ifdeffery a bit:
>>
>> static inline bool has_user_ds(void) {
>>         bool ret = false;
>>
>> #ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>>         ret = segment_eq(get_fs(), USER_DS);
>>         /* Prevent re-ordering the call. */
>>         barrier();
>> #endif
>>
>>         return ret;
>> }
>
> I don't like having any kernel configuration in which has_user_ds()
> unconditionally returns false.  Can we put the ifdeffery in the caller
> instead?

I don't like it either to be honest. We could have something like:

#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
#define CHECK_USER_CALLER(_x) bool _x = segment_eq(get_fs(), USER_DS)
#else
#define CHECK_USER_CALLER(_x) bool _x = false
#endif

// In the syscall macro:
CHECK_CALLED_BY_USER(user_caller);

>
> --Andy



-- 
Thomas
