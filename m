From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v7 1/4] syscalls: Restore address limit after a syscall
Date: Wed, 26 Apr 2017 10:12:29 +0200
Message-ID: <20170426081229.6wnugrs7w3at4xry@gmail.com>
References: <20170410164420.64003-1-thgarnie@google.com>
 <20170425063305.hwjuxupa37rwe6zj@gmail.com>
 <CAJcbSZH7Y6iBy3T3iWyh_AaFJ+TidP7E9iQEuCbShQrcTKGoyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-7590-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJcbSZH7Y6iBy3T3iWyh_AaFJ+TidP7E9iQEuCbShQrcTKGoyw@mail.gmail.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christia
List-Id: linux-api@vger.kernel.org


* Thomas Garnier <thgarnie@google.com> wrote:

> >> +#ifdef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
> >> +/*
> >> + * This function is called when an architecture specific implementation detected
> >> + * an invalid address limit. The generic user-mode state checker will finish on
> >> + * the appropriate BUG_ON.
> >> + */
> >> +asmlinkage void address_limit_check_failed(void)
> >> +{
> >> +     verify_pre_usermode_state();
> >> +     panic("address_limit_check_failed called with a valid user-mode state");
> >
> > It's very unconstructive to unconditionally panic the system, just because some
> > kernel code leaked the address limit! Do a warn-once printout and kill the current
> > task (i.e. don't continue execution), but don't crash everything else!
> 
> The original change did not crash the kernel for this exact reason.
> Through reviews, there was an overall agreement that the kernel should
> not continue in this state.

Ok, I guess we can try that - but the panic message is still pretty misleading:

	panic("address_limit_check_failed called with a valid user-mode state");

... so it was called with a _valid_ user-mode state, and we crash due to something 
valid? Huh?

( Also, the style rule applies to kernel messages as well: function names should 
  be referred to as "function_name()". )

Thanks,

	Ingo
