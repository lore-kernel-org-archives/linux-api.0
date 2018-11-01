From: Rich Felker <dalias@libc.org>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 1 Nov 2018 14:30:37 -0400
Message-ID: <20181101183037.GB5150@brightrain.aerifal.cx>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <877ehwisaa.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877ehwisaa.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@al>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 01, 2018 at 07:09:17PM +0100, Florian Weimer wrote:
> * Andy Lutomirski:
> 
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
> > registered handler.  That handler is expected to either handle the
> > exception entirely on its own or to call one of two new syscalls to
> > ask for normal signal delivery or to ask to retry the faulting
> > instruction.
> 
> Would the exception handler be a per-thread resource?
> 
> If it is: Would the setup and teardown overhead be prohibitive for many
> use cases (at least those do not expect a fault)?
> 
> Something peripherally related to this interface: Wrappers for signal
> handlers (and not just CPU exceptions).  Ideally, we want to maintain a
> flag that indicates whether we are in a signal handler, and save and
> restore errno around the installed handler.

I think the right way to make it per-thread AND low-cost would be to
register not the handler, but the (per-thread) address of a
function-pointer object pointing to the handler. Then switching the
handler just requires a single volatile store to thread-local memory,
no syscall.

Rich
