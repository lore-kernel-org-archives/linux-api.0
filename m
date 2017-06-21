From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v10 2/3] arm/syscalls: Check address limit on user-mode
 return
Date: Wed, 21 Jun 2017 10:08:15 +0100
Message-ID: <20170621090815.GC3768@arm.com>
References: <20170615011203.144108-1-thgarnie@google.com>
 <20170615011203.144108-2-thgarnie@google.com>
 <CAGXu5jLR7io8u-M8tqbYW22C+sb2a2wSYLRBqJ_dguT4x+1tsQ@mail.gmail.com>
 <CAJcbSZG8KH7kw5HMP-7HvfHh2RdAfGnOqjOibHr5H42tORRGCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-8725-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <CAJcbSZG8KH7kw5HMP-7HvfHh2RdAfGnOqjOibHr5H42tORRGCw@mail.gmail.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, David Howells <dhowells@redhat.com>, Russell King <linux@armlinux.org.uk>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, Chris Metcalf <cmetcalf@mellanox.com>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 20, 2017 at 01:31:14PM -0700, Thomas Garnier wrote:
> On Tue, Jun 20, 2017 at 1:18 PM, Kees Cook <keescook@chromium.org> wrote:
> > On Wed, Jun 14, 2017 at 6:12 PM, Thomas Garnier <thgarnie@google.com> wrote:
> >> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> >> index eb5cd77bf1d8..e33c32d56193 100644
> >> --- a/arch/arm/kernel/entry-common.S
> >> +++ b/arch/arm/kernel/entry-common.S
> >> @@ -41,7 +41,9 @@ ret_fast_syscall:
> >>   UNWIND(.cantunwind    )
> >>         disable_irq_notrace                     @ disable interrupts
> >>         ldr     r1, [tsk, #TI_FLAGS]            @ re-check for syscall tracing
> >> -       tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
> >> +       tst     r1, #_TIF_SYSCALL_WORK
> >> +       bne     fast_work_pending
> >> +       tst     r1, #_TIF_WORK_MASK
> >
> > (IIUC) MOV32 is 2 cycles (MOVW, MOVT), and each TST above is 1 cycle
> > and each BNE is 1 cycle (when not taken). So:
> >
> > mov32 r2, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
> > tst r1, r2
> > bne fast_work_pending
> >
> > is 4 cycles and tst, bne, tst, bne is also 4 cycles. Would mov32 be
> > more readable (since it keeps the flags together)?
> 
> I guess it would be more readable. Any opinion from the arm folks?

The mov32 sequence is probably better, but statically attributing cycles
on a per instruction basis is pretty futile on modern CPUs.

Will
