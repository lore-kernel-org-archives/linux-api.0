From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v6 00/26] Control-flow Enforcement: Shadow Stack
Date: Mon, 26 Nov 2018 09:38:49 -0800
Message-ID: <35b33f293bc392df71710102f38fa6a40d0bb996.camel@intel.com>
References: <20181119214809.6086-1-yu-cheng.yu@intel.com>
         <CALCETrWLtpfkecfUAXJ64Z5xDeHPJxTQSci+T4RCem7vCqorTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWLtpfkecfUAXJ64Z5xDeHPJxTQSci+T4RCem7vCqorTw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Carlos O'Donell <carlos@redhat.com>, Rich Felker <dalias@libc.org>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H. J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@re>
List-Id: linux-api@vger.kernel.org

On Thu, 2018-11-22 at 08:53 -0800, Andy Lutomirski wrote:
> [cc some more libc folks]
> 
> I have a general question about this patch set:
> 
> If I'm writing a user program, and I write a signal handler, there are
> two things I want to make sure I can still do:
> 
> 1. I want to be able to unwind directly from the signal handler
> without involving sigreturn() -- that is, I want to make sure that
> siglongjmp() works.  How does this work?  Is INCSSP involved?  How

Yes, siglongjmp() works by doing INCSSP.

> exactly does the user program know how much to increment SSP by?  (And
> why on Earth does INCSSP only consider the low 8 bits of its argument?
>  That sounds like a mistake.  Can Intel still fix that?  On the other

GLIBC calculates how many frames to be unwound and breaks into 255 batches when
necessary.

> hand, what happens if you INCSSP off the end of the shadow stack
> entirely?  I assume the next access will fault as long as there's an
> appropriate guard page.)

Yes, that is the case.

> 
> 2. I want to be able to modify the signal context from a signal
> handler such that, when the signal handler returns, it will return to
> a frame higher up on the call stack than where the signal started and
> to a different RIP value.  How can I do this?  I guess I can modify
> the shadow stack with WRSS if WR_SHSTK_EN=1, but how do I tell the
> kernel to kindly skip the frames I want to skip when I do sigreturn()?
> 
> The reason I'm asking #2 is that I think it's time to resurrect my old
> vDSO syscall cancellation helper series here:
> 
> https://lwn.net/Articles/679434/

If tools/testing/selftests/x86/unwind_vdso.c passes, can we say the kernel does
the right thing?  Or do you have other tests that I can run?

> 
> and it's not at all clear to me that __vdso_abort_pending_syscall()
> can work without kernel assistance when CET is enabled.  I want to
> make sure that it can be done, or I want to come up with some other
> way to allow a signal handler to abort a syscall while CET is on.  I
> could probably change __vdso_abort_pending_syscall() to instead point
> RIP to __kernel_vsyscall's epilogue so that we con't change the depth
> of the call stack.  But I could imagine that other user programs might
> engage in similar shenanigans and want to have some way to unwind a
> signal's return context without actually jumping there a la
> siglongjmp().
> 
> Also, what is the intended setting of WR_SHSTK_EN with this patch set applied?

This bit enables WRSS instruction, which writes to kernel SHSTK.  This patch set
uses only WRUSS and WR_SHSTK_EN is not be set.

> 
> (I suppose we could just say that 32-bit processes should not use CET,
> but that seems a bit sad.)

They work in compat mode.  Should anything break, we can fix it.

Yu-cheng
