From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 1 Nov 2018 12:06:21 -0700
Message-ID: <CAHk-=wjJhdr3JCnGrMKqL-prxYd__kkAspKVYBO3BYYmq2hu4A@mail.gmail.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: luto@kernel.org
Cc: dave.hansen@linux.intel.com, sean.j.christopherson@intel.com, jethro@fortanix.com, jarkko.sakkinen@linux.intel.com, fweimer@redhat.com, linux-api@vger.kernel.org, Jann Horn <jannh@google.com>, x86@kernel.org, linux-arch@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, dalias@libc.org, nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, andriy.shevchenko@linux.intel.com, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, bp@alien8.de
List-Id: linux-api@vger.kernel.org

On Thu, Nov 1, 2018 at 10:53 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> There's been some discussion of adding a vDSO entry point to wrap
> EENTER and do something sensible with the exceptions,

I think that's likely the right thing to do, and would be similar to sysenter.

> The basic idea would be to allow libc, or maybe even any library, to
> register a handler that gets a chance to act on an exception caused by
> a user instruction before a signal is delivered.  As a straw-man
> example for how this could work, there could be a new syscall:
>
> long register_exception_handler(void (*handler)(int, siginfo_t *, void *));

I'm not a huge fan of signals, but the above is an abomination.

It has all the problems of signals _and_ then some.

And it in absolutely no way fixes the problem with libraires. In fact,
it arguably makes it much much worse, since now there's only one
single library that can register it.

Yes yes, maybe a library would then expose _another_ interface to
other libraries and act as some kind of dispatch point, but on the
whole the above is just crazy and fundamentally broken.

If you want to register an exception, you need to make it clear

 (a) which _thread_ the exception registration is valid for

 (b) which _range_ the exception registration is valid for

 (c) which _fault_ the exception registration is valid for (page
fault, div-by-zero, whatever)

 (d) which save area (aka stack) and exception handler point.

Note that (b) might be more than just an exception IP range. It might
well be interesting to register the exception by page fault address
(in addition to code range).

If you do something that does all of (a)-(d), and you allow some
limited number of exception registrations, then maybe. Because at that
point, you have something that is actually actively more powerful than
signal handling is.

But your suggested "just register a broken form of signal handling for
a special case" is just wrong. Don't do it.

              Linus
