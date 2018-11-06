From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Tue, 06 Nov 2018 13:59:25 -0800
Message-ID: <1541541565.8854.13.camel@intel.com>
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
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
         <1541524750.7839.51.camel@intel.com>
         <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
         <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
         <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
         <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com>
         <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
         <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com>
         <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
         <CALCETrV=iodOQhvXAyjs0TQNbCaFdkhrZqRHvWTnBfo2m0qXpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrV=iodOQhvXAyjs0TQNbCaFdkhrZqRHvWTnBfo2m0qXpA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>
Cc: Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
List-Id: linux-api@vger.kernel.org

On Tue, 2018-11-06 at 13:41 -0800, Andy Lutomirski wrote:
> On Tue, Nov 6, 2018 at 1:07 PM Andy Lutomirski <luto@amacapital.net> wrote:
> > 
> > > 
> > > On Nov 6, 2018, at 1:00 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> > > 
> > > > 
> > > > On 11/6/18 12:12 PM, Andy Lutomirski wrote:
> > > > True, but what if we have a nasty enclave that writes to memory just
> > > > below SP *before* decrementing SP?
> > > Yeah, that would be unfortunate.  If an enclave did this (roughly):
> > > 
> > >    1. EENTER
> > >    2. Hardware sets eenter_hwframe->sp = %sp
> > >    3. Enclave runs... wants to do out-call
> > >    4. Enclave sets up parameters:
> > >        memcpy(&eenter_hwframe->sp[-offset], arg1, size);
> > >        ...
> > >    5. Enclave sets eenter_hwframe->sp -= offset
> > > 
> > > If we got a signal between 4 and 5, we'd clobber the copy of 'arg1' that
> > > was on the stack.  The enclave could easily fix this by moving ->sp first.
> > > 
> > > But, this is one of those "fun" parts of the ABI that I think we need to
> > > talk about.  If we do this, we also basically require that the code
> > > which handles asynchronous exits must *not* write to the stack.  That's
> > > not hard because it's typically just a single ERESUME instruction, but
> > > it *is* a requirement.
> > > 
> > I was assuming that the async exit stuff was completely hidden by the API. The AEP code would decide whether the exit got fixed up by the kernel (which may or may not be easy to tell — can the
> > code even tell without kernel help whether it was, say, an IRQ vs #UD?) and then either do ERESUME or cause sgx_enter_enclave() to return with an appropriate return value.
> > 
> > 
> Sean, how does the current SDK AEX handler decide whether to do
> EENTER, ERESUME, or just bail and consider the enclave dead?  It seems
> like the *CPU* could give a big hint, but I don't see where there is
> any architectural indication of why the AEX code got called or any
> obvious way for the user code to know whether the exit was fixed up by
> the kernel?

The SDK "unconditionally" does ERESUME at the AEP location, but that's
bit misleading because its signal handler may muck with the context's
RIP, e.g. to abort the enclave on a fatal fault.

On an event/exception from within an enclave, the event is immediately
delivered after loading synthetic state and changing RIP to the AEP.
In other words, jamming CPU state is essentially a bunch of vectoring
ucode preamble, but from software's perspective it's a normal event
that happens to point at the AEP instead of somewhere in the enclave.
And because the signals the SDK cares about are all synchronous, the
SDK can simply hardcode ERESUME at the AEP since all of the fault logic
resides in its signal handler.  IRQs and whatnot simply trampoline back
into the enclave.

Userspace can do something funky instead of ERESUME, but only *after*
IRET/RSM/VMRESUME has returned to the AEP location, and in Linux's
case, after the trap handler has run.

Jumping back a bit, how much do we care about preventing userspace
from doing stupid things?  I did a quick POC on the idea of hardcoding
fixup for the ENCLU opcode, and the basic idea checks out.  The code
is fairly minimal and doesn't impact the core functionality of the SDK.
They'd need to redo their trap handling to move it from the signal
handler to inline, but their stack shenanigans won't be any more broken
than they already are.
