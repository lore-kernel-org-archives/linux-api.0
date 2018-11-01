From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 1 Nov 2018 21:00:38 +0200 (EET)
Message-ID: <alpine.DEB.2.21.1811012058480.7972@jsakkine-mobl1>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com> <877ehwisaa.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877ehwisaa.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rich Felker <dalias@libc.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>Ingo Molnar <mi>
List-Id: linux-api@vger.kernel.org

On Thu, 1 Nov 2018, Florian Weimer wrote:
> * Andy Lutomirski:
>
>> The basic idea would be to allow libc, or maybe even any library, to
>> register a handler that gets a chance to act on an exception caused by
>> a user instruction before a signal is delivered.  As a straw-man
>> example for how this could work, there could be a new syscall:
>>
>> long register_exception_handler(void (*handler)(int, siginfo_t *, void *));
>>
>> If a handler is registered, then, if a synchronous exception happens
>> (page fault, etc), the kernel would set up an exception frame as usual
>> but, rather than checking for signal handlers, it would just call the
>> registered handler.  That handler is expected to either handle the
>> exception entirely on its own or to call one of two new syscalls to
>> ask for normal signal delivery or to ask to retry the faulting
>> instruction.
>
> Would the exception handler be a per-thread resource?

For SGX purposes it would *need* to be per-thread resource so that the
run-time (not just Intel but any user space support code for SGX) is
able to act on thread that caused this exception inside the enclave.

/Jarkko
