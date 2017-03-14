From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v3 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Tue, 14 Mar 2017 09:29:28 -0700
Message-ID: <CAJcbSZEFWzPVfxVzOF5r1yywkgMObxOt8W+1efuTUsv+82FBpg@mail.gmail.com>
References: <20170311000501.46607-1-thgarnie@google.com> <20170311000501.46607-2-thgarnie@google.com>
 <20170311094200.GA27700@gmail.com> <733ed189-6c01-2975-a81a-6fbfe4b7b593@zytor.com>
 <2d9aad2a-a677-40d2-c179-379fb6e9f194@zytor.com> <CAJcbSZG6F3DsiBMjizTbzaccvU5_RKdspU06wQ8yi+JT+EW2Jw@mail.gmail.com>
 <CALCETrVVo4aQosdjfUPBf=JWyVWE_cHavbBKX5Swv_HbV__RNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7025-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrVVo4aQosdjfUPBf=JWyVWE_cHavbBKX5Swv_HbV__RNw@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 14, 2017 at 8:39 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> Even though my name isn't Ingo, Linus keeps trying to get me to be the
> actual maintainer of this file.  :)  How about (sorry about whitespace
> damage):

:D

>
> #ifdef CONFIG_BUG_ON_DATA_CORRUPTION
>        movq    PER_CPU_VAR(current_task), %rax
>        bt $63, TASK_addr_limit(%rax)
>        jc     syscall_return_slowpath
> #endif
>
> Now the kernel is totally unchanged if the config option is off and
> it's fast and simple if the option is on.

I like using bt for fast comparison.

We want to enforce the address limit by default, not only when
CONFIG_BUG_ON_DATA_CORRUPTION is enabled. I tested this one:

/* Check user-mode state on fast path return. */
movq PER_CPU_VAR(current_task), %rax
btq $63, TASK_addr_limit(%rax)
jnc 1f
#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
call syscall_return_slowpath
jmp return_from_SYSCALL_64
#else
movq $TASK_SIZE_MAX, %rcx
movq %rcx, TASK_addr_limit(%rax)
#endif
1:

I saw that syscall_return_slowpath is supposed to be called not jumped
to. I could just call verify_pre_usermode_state that would be about
the same.

If we want to avoid if/def then I guess this one is the best I can think of:

/* Check user-mode state on fast path return. */
movq PER_CPU_VAR(current_task), %rax
btq $63, TASK_addr_limit(%rax)
jnc 1f
call verify_pre_usermode_state
1:

The check is fast and the call will happen only on corruption.

What do you think?

-- 
Thomas
