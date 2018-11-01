From: Andy Lutomirski <luto@kernel.org>
Subject: RFC: userspace exception fixups
Date: Thu, 1 Nov 2018 10:53:40 -0700
Message-ID: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rich Felker <dalias@libc.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

Hi all-

The people working on SGX enablement are grappling with a somewhat
annoying issue: the x86 EENTER instruction is used from user code and
can, as part of its normal-ish operation, raise an exception.  It is
also highly likely to be used from a library, and signal handling in
libraries is unpleasant at best.

There's been some discussion of adding a vDSO entry point to wrap
EENTER and do something sensible with the exceptions, but I'm
wondering if a more general mechanism would be helpful.

The basic idea would be to allow libc, or maybe even any library, to
register a handler that gets a chance to act on an exception caused by
a user instruction before a signal is delivered.  As a straw-man
example for how this could work, there could be a new syscall:

long register_exception_handler(void (*handler)(int, siginfo_t *, void *));

If a handler is registered, then, if a synchronous exception happens
(page fault, etc), the kernel would set up an exception frame as usual
but, rather than checking for signal handlers, it would just call the
registered handler.  That handler is expected to either handle the
exception entirely on its own or to call one of two new syscalls to
ask for normal signal delivery or to ask to retry the faulting
instruction.

Alternatively, we could do something a lot more like the kernel's
internal fixups where there's a table in user memory that maps
potentially faulting instructions to landing pads that handle
exceptions.

Do you think this would be useful?  Here are some use cases that I
think are valid:

(a) Enter an SGX enclave and handle errors.  There would be two
instructions that would need special handling: EENTER and ERESUME.

(b) Do some math and catch division by zero.  I think it would be a
bad idea to have user code call a function and say that it wants to
handle *any* division by zero, but having certain specified division
instructions have special handling seems entirely reasonable.

(c) Ditto for floating point errors.

(d) Try an instruction and see if it gets #UD.

(e) Run a bunch of code and handle page faults to a given address
range by faulting something in.  This is not like the others, in that
a handler wants to handle a range of target addresses, not
instructions.  And userfaultfd is plausibly a better solution anyway.

(f) Run NaCl-like sandboxed code where the code can cause page faults
to certain mapped-but-intentionally-not-present ranges and those need
to be handled.

On Windows, you can use SEH to do crazy things like running
known-buggy code and eating the page faults.  I don't think we want to
go there.

All of this makes me think that the right solution is to have a way to
register fault handlers for instructions to cover (a) - (d) and to
treat (e) and (f) as something else entirely if there's enough demand.

--Andy
