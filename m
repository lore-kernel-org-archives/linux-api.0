From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v2 1/4] syscalls: Restore address limit after a syscall
Date: Thu, 9 Mar 2017 07:54:40 -0800
Message-ID: <CAJcbSZHQnS+THRy3B+OmZAotjC4CW-giv+i+YJKF36wOgSZtYQ@mail.gmail.com>
References: <20170309012456.5631-1-thgarnie@google.com> <20170309120955.GA6320@leverpostej>
 <20170309134456.GI21222@n2100.armlinux.org.uk> <20170309152144.GA11966@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6971-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170309152144.GA11966@leverpostej>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 9, 2017 at 7:21 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Thu, Mar 09, 2017 at 01:44:56PM +0000, Russell King - ARM Linux wrote:
>> On Thu, Mar 09, 2017 at 12:09:55PM +0000, Mark Rutland wrote:
>> > On Wed, Mar 08, 2017 at 05:24:53PM -0800, Thomas Garnier wrote:
>
>> > It would be simpler to wrap the call entirely, e.g. have:
>> >
>> > #ifdef CONFIG_WHATEVER
>> > static inline void verify_pre_usermode_state(void)
>> > {
>> >     if (segment_eq(get_fs(), USER_DS))
>> >             __verify_pre_usermode_state();
>> > }
>> > #else
>> > static inline void verify_pre_usermode_state(void) { }
>> > #endif
>>
>> That's utterly pointless - you've missed a detail.
>>
>> > > @@ -199,7 +215,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>> > >   asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));      \
>> > >   asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))       \
>> > >   {                                                               \
>> > > +         bool user_caller = has_user_ds();                       \
>> > >           long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));  \
>> > > +         if (user_caller)                                        \
>> > > +                 verify_pre_usermode_state();                    \
>> >
>> > ... then we can unconditionally use verify_pre_usermode_state() here ...
>>
>> Look at this closely.  has_user_ds() is called _before_ the syscall code
>> is invoked.  It's checking what conditions the syscall was entered from.
>> If the syscall was entered with the user segment selected, then we run
>> a check on the system state _after_ the syscall code has returned.
>
> Indeed; I clearly did not consider this correctly.
>
> Sorry for the noise.
>

No problem, I missed that reply so discard my question on the email
few seconds ago.

> Thanks,
> Mark.



-- 
Thomas
