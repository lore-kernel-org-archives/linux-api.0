From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v3 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Mon, 13 Mar 2017 08:53:37 -0700
Message-ID: <CAJcbSZE1RNjycnEhczNbxWHXB8raO-ATdNQvGeqXGaOy6hmmTA@mail.gmail.com>
References: <20170311000501.46607-1-thgarnie@google.com> <20170311000501.46607-2-thgarnie@google.com>
 <20170311094200.GA27700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7017-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170311094200.GA27700@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.g>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 11, 2017 at 1:42 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Ugh, so you call an assembly function just to ... call another function.
>

The verify_pre_usermode_state function is the architecture independent
checker. By default it is added on each syscall handler so calling it
here save code size.

> Plus why is it in assembly to begin with? Is this some older code that got
> written when the x86 entry code was in assembly, and never properly
> converted to C?

I wrote the assembly to make it faster and save a call on each syscall
return. I can just call verify_pre_usermode_state if you prefer.

-- 
Thomas
