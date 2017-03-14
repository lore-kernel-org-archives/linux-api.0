From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v3 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Tue, 14 Mar 2017 09:51:55 -0700
Message-ID: <CAJcbSZGjos1K9qvQWPTpr4COEcnW6Sn_jo7hCezGbh-BhPAH7w@mail.gmail.com>
References: <20170311000501.46607-1-thgarnie@google.com> <20170311000501.46607-2-thgarnie@google.com>
 <20170311094200.GA27700@gmail.com> <733ed189-6c01-2975-a81a-6fbfe4b7b593@zytor.com>
 <2d9aad2a-a677-40d2-c179-379fb6e9f194@zytor.com> <CAJcbSZG6F3DsiBMjizTbzaccvU5_RKdspU06wQ8yi+JT+EW2Jw@mail.gmail.com>
 <CALCETrVVo4aQosdjfUPBf=JWyVWE_cHavbBKX5Swv_HbV__RNw@mail.gmail.com>
 <CAJcbSZEFWzPVfxVzOF5r1yywkgMObxOt8W+1efuTUsv+82FBpg@mail.gmail.com> <7389c6e7-87dc-ea0d-5b2a-7925b8c8d33e@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7028-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <7389c6e7-87dc-ea0d-5b2a-7925b8c8d33e@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 14, 2017 at 9:44 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/14/17 09:29, Thomas Garnier wrote:
>>
>> We want to enforce the address limit by default, not only when
>> CONFIG_BUG_ON_DATA_CORRUPTION is enabled. I tested this one:
>>
>> /* Check user-mode state on fast path return. */
>> movq PER_CPU_VAR(current_task), %rax
>> btq $63, TASK_addr_limit(%rax)
>> jnc 1f
>> #ifdef CONFIG_BUG_ON_DATA_CORRUPTION
>> call syscall_return_slowpath
>> jmp return_from_SYSCALL_64
>> #else
>> movq $TASK_SIZE_MAX, %rcx
>> movq %rcx, TASK_addr_limit(%rax)
>> #endif
>> 1:
>>
>> I saw that syscall_return_slowpath is supposed to be called not jumped
>> to. I could just call verify_pre_usermode_state that would be about
>> the same.
>
> I wanted to comment on that thing: why on earth isn't
> verify_pre_usermode_state() an inline?  Making it an out-of-line
> function adds pointless extra overhead to the C code when we are talking
> about a few instructions.

Because outside of arch specific implementation it is called by each
syscall handler. it will increase the code size a lot.

>
> Second, you never do a branch-around to handle an exceptional condition
> on the fast path: you jump *out of line* to handle the special
> condition; a forward branch is preferred since it is slightly more
> likely to be predicted not taken.
>
> Now, I finally had a chance to actually look at the full file (I was
> preoccupied yesterday), and am a bit disappointed, to say the least.
>
> First of all, the jump target you need is only a handful of instructions
> further down the code path; you need to do *exactly* that is done when
> the test of _TIF_ALLWORK_MASK right above is tested!  Not only that, but
> you already have PER_CPU_VAR(current_task) in %r11 just ready to be
> used!  This was all in the three instructions immediately prior to the
> code you modified...

Correct.

>
> So, all you'd need would be:
>
>         movq $TASK_SIZE_MAX, %rcx
>         cmpq %rcx, TASK_addr_limit(%r11)
>         jne 1f
>
> We even get a short jump instruction!
>
> (Using bt saves one more instruction, but see previous caveats about it.)

Okay that seems fair to me. Andy what do you think? (Given you
suggested the bt). Ingo?

Thanks for the feedback.

>
>         -hpa
>
>
>
>



-- 
Thomas
