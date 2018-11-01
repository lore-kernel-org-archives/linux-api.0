From: Rich Felker <dalias@libc.org>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 1 Nov 2018 14:52:25 -0400
Message-ID: <20181101185225.GC5150@brightrain.aerifal.cx>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, sean.j.christopherson@intel.com, jethro@fortanix.com, jarkko.sakkinen@linux.intel.com, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, andriy.shevchenko@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, carlos@redhat.com, adhemerval.zanella@linaro.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 01, 2018 at 07:33:33PM +0100, Jann Horn wrote:
> > but I'm
> > wondering if a more general mechanism would be helpful.
> >
> > The basic idea would be to allow libc, or maybe even any library, to
> > register a handler that gets a chance to act on an exception caused by
> > a user instruction before a signal is delivered.  As a straw-man
> > example for how this could work, there could be a new syscall:
> >
> > long register_exception_handler(void (*handler)(int, siginfo_t *, void *));
> >
> > If a handler is registered, then, if a synchronous exception happens
> > (page fault, etc), the kernel would set up an exception frame as usual
> > but, rather than checking for signal handlers, it would just call the
> > registered handler.
> 
> > That handler is expected to either handle the
> > exception entirely on its own or to call one of two new syscalls to
> > ask for normal signal delivery
> 
> If you do it this way, these exception handlers would have to chain,

There's no need to chain if the handler is specific to the context
where the fault happens. You just replace the handler with the one
relevant to the code you're about to run before you run it.

> > or to ask to retry the faulting instruction.
> 
> Why would that have to be a syscall? For signal handlers registered
> with SA_NODEFER, you can basically leave the signal handler with a
> longjmp, right?

longjmp needs a jmp_buf; it can't return to the faulting instruction.
Normally (though this is not defined) signal handlers return to the
faulting instruction if they return, but if returning from the
exception handler meant passing through to the signal disposition,
a different mechanism would be needed to signal that you want to retry
the faulting instruction.

Rich
