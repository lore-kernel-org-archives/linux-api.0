From: Andy Lutomirski <luto@kernel.org>
Subject: Re: RFC: userspace exception fixups
Date: Tue, 6 Nov 2018 17:17:14 -0800
Message-ID: <CALCETrV_sMOeQGRkxoA8KMxEizagB9bD-mB2T-ro3F6O6OX9Xw@mail.gmail.com>
References: <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com> <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com> <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
 <CALCETrV=iodOQhvXAyjs0TQNbCaFdkhrZqRHvWTnBfo2m0qXpA@mail.gmail.com>
 <1541541565.8854.13.camel@intel.com> <7FF4802E-FBC5-4E6D-A8F6-8A65114F18C7@amacapital.net>
 <20181106233515.GB11101@linux.intel.com> <CALCETrVySfV64YN7DWf3rsAxfiugJKsRJCNmEn-AKQ4dPYeG4Q@mail.gmail.com>
 <20181107000235.GC11101@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181107000235.GC11101@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc: Andrew Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 6, 2018 at 4:02 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Nov 06, 2018 at 03:39:48PM -0800, Andy Lutomirski wrote:
> > On Tue, Nov 6, 2018 at 3:35 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Tue, Nov 06, 2018 at 03:00:56PM -0800, Andy Lutomirski wrote:
> > > >
> > > >
> > > > >> On Nov 6, 2018, at 1:59 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > > > >>
> > > > >>> On Tue, 2018-11-06 at 13:41 -0800, Andy Lutomirski wrote:
> > > > >> Sean, how does the current SDK AEX handler decide whether to do
> > > > >> EENTER, ERESUME, or just bail and consider the enclave dead?  It seems
> > > > >> like the *CPU* could give a big hint, but I don't see where there is
> > > > >> any architectural indication of why the AEX code got called or any
> > > > >> obvious way for the user code to know whether the exit was fixed up by
> > > > >> the kernel?
> > > > >
> > > > > The SDK "unconditionally" does ERESUME at the AEP location, but that's
> > > > > bit misleading because its signal handler may muck with the context's
> > > > > RIP, e.g. to abort the enclave on a fatal fault.
> > > > >
> > > > > On an event/exception from within an enclave, the event is immediately
> > > > > delivered after loading synthetic state and changing RIP to the AEP.
> > > > > In other words, jamming CPU state is essentially a bunch of vectoring
> > > > > ucode preamble, but from software's perspective it's a normal event
> > > > > that happens to point at the AEP instead of somewhere in the enclave.
> > > > > And because the signals the SDK cares about are all synchronous, the
> > > > > SDK can simply hardcode ERESUME at the AEP since all of the fault logic
> > > > > resides in its signal handler.  IRQs and whatnot simply trampoline back
> > > > > into the enclave.
> > > > >
> > > > > Userspace can do something funky instead of ERESUME, but only *after*
> > > > > IRET/RSM/VMRESUME has returned to the AEP location, and in Linux's
> > > > > case, after the trap handler has run.
> > > > >
> > > > > Jumping back a bit, how much do we care about preventing userspace
> > > > > from doing stupid things?
> > > >
> > > > My general feeling is that userspace should be allowed to do apparently
> > > > stupid things. For example, as far as the kernel is concerned, Wine and
> > > > DOSEMU are just user programs that do stupid things. Linux generally tries
> > > > to provide a reasonably complete view of architectural behavior. This is
> > > > in contrast to, say, Windows, where IIUC doing an unapproved WRFSBASE May
> > > > cause very odd behavior indeed. So magic fixups that do non-architectural
> > > > things are not so great.
> > >
> > > Sorry if I'm beating a dead horse, but what if we only did fixup on ENCLU
> > > with a specific (ignored) prefix pattern?  I.e. effectively make the magic
> > > fixup opt-in, falling back to signals.  Jamming RIP to skip ENCLU isn't
> > > that far off the architecture, e.g. EENTER stuffs RCX with the next RIP so
> > > that the enclave can EEXIT to immediately after the EENTER location.
> > >
> >
> > How does that even work, though?  On an AEX, RIP points to the ERESUME
> > instruction, not the EENTER instruction, so if we skip it we just end
> > up in lala land.
>
> Userspace would obviously need to be aware of the fixup behavior, but
> it actually works out fairly nicely to have a separate path for ERESUME
> fixup since a fault on EENTER is generally fatal, whereas as a fault on
> ERESUME might be recoverable.
>

Hmm.

>
> do_eenter:
>     mov     tcs, %rbx
>     lea     async_exit, %rcx
>     mov     $EENTER, %rax
>     ENCLU

Or SOME_SILLY_PREFIX ENCLU?

>
> /*
>  * EEXIT or EENTER faulted.  In the latter case, %RAX already holds some
>  * fault indicator, e.g. -EFAULT.
>  */
> eexit_or_eenter_fault:
>     ret

But userspace wants to know whether it was a fault or not.  So I think
we either need two landing pads or we need to hijack a flag bit (are
there any known-zeroed flag bits after EEXIT?) to say whether it was a
fault.  And, if it was a fault, we should give the vector, the
sanitized error code, and possibly CR2.

>
> async_exit:
>     ENCLU

Same prefix here, right?

>
> fixup_handler:
>     <do fault stuff>

This whole thing is a bit odd, but not necessarily a terrible idea.

>
> > How averse would everyone be to making enclave entry be a syscall?
> > The user code would do sys_sgx_enter_enclave(), and the kernel would
> > stash away the register state (vm86()-style), point RIP to the vDSO's
> > ENCLU instruction, point RCX to another vDSO ENCLU instruction, and
> > SYSRET.  The trap handlers would understand what's going on and
> > restore register state accordingly.
>
> Wouldn't that blast away any stack changes made by the enclave?

Yes, but I was imagining that it would stash the registers into the
struct host_state thing I made up :)
