From: Florian Weimer <fweimer@redhat.com>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 01 Nov 2018 19:09:17 +0100
Message-ID: <877ehwisaa.fsf@oldenburg.str.redhat.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
        (Andy Lutomirski's message of "Thu, 1 Nov 2018 10:53:40 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rich Felker <dalias@libc.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alie>
List-Id: linux-api@vger.kernel.org

* Andy Lutomirski:

> The basic idea would be to allow libc, or maybe even any library, to
> register a handler that gets a chance to act on an exception caused by
> a user instruction before a signal is delivered.  As a straw-man
> example for how this could work, there could be a new syscall:
>
> long register_exception_handler(void (*handler)(int, siginfo_t *, void *));
>
> If a handler is registered, then, if a synchronous exception happens
> (page fault, etc), the kernel would set up an exception frame as usual
> but, rather than checking for signal handlers, it would just call the
> registered handler.  That handler is expected to either handle the
> exception entirely on its own or to call one of two new syscalls to
> ask for normal signal delivery or to ask to retry the faulting
> instruction.

Would the exception handler be a per-thread resource?

If it is: Would the setup and teardown overhead be prohibitive for many
use cases (at least those do not expect a fault)?

Something peripherally related to this interface: Wrappers for signal
handlers (and not just CPU exceptions).  Ideally, we want to maintain a
flag that indicates whether we are in a signal handler, and save and
restore errno around the installed handler.

> Alternatively, we could do something a lot more like the kernel's
> internal fixups where there's a table in user memory that maps
> potentially faulting instructions to landing pads that handle
> exceptions.

GCC already supports that on most Linux targets.  You can unwind from
synchronously invoked signal handlers if you compile with
-fnon-call-exceptions.

However, it's tough to set up a temporary signal handler to trigger such
unwinding because those aren't per-thread.

> On Windows, you can use SEH to do crazy things like running
> known-buggy code and eating the page faults.  I don't think we want to
> go there.

The original SEH was also a rich target for exploiting vulnerabilities.
That's something we really should avoid as well.

I wonder if it would be possible to tack this function onto rseq.

Thanks,
Florian
