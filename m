From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Tue, 06 Nov 2018 09:19:10 -0800
Message-ID: <1541524750.7839.51.camel@intel.com>
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
         <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
         <20181102163034.GB7393@linux.intel.com>
         <7050972d-a874-dc08-3214-93e81181da60@intel.com>
         <20181102170627.GD7393@linux.intel.com>
         <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
         <20181102173350.GF7393@linux.intel.com>
         <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
         <20181102182712.GG7393@linux.intel.com>
         <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
         <20181102220437.GI7393@linux.intel.com>
         <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
         <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
         <1541518670.7839.31.camel@intel.com>
         <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Dave Hansen <dave.hansen@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
List-Id: linux-api@vger.kernel.org

On Tue, 2018-11-06 at 08:57 -0800, Andy Lutomirski wrote:
>
> So I guess the non-enclave code basically can’t trust its stack pointer
> because of these shenanigans. And the AEP code has to live with the fact
> that its RSP is basically arbitrary and probably can’t even be unwound
> by a debugger?

The SDK provides a Python GDB plugin to hook into the out-call flow and
do more stack shenanigans.  From what I can tell it's fudging the stack
to make it look like a normal stack frame so the debugger can do it's
thing.

> And the EENTER code has to deal with the fact that its red zone can be
> blatantly violated by the enclave?

That's my understanding of things.  So yeah, if it wasn't obvious before,
the trusted and untrusted parts of the SDK are very tightly coupled.
