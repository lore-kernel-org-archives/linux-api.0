From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: RFC: userspace exception fixups
Date: Fri, 2 Nov 2018 11:27:12 -0700
Message-ID: <20181102182712.GG7393@linux.intel.com>
References: <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx>
 <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com>
 <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com>
 <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com>
 <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 02, 2018 at 10:48:38AM -0700, Andy Lutomirski wrote:
> On Fri, Nov 2, 2018 at 10:33 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, Nov 02, 2018 at 10:13:23AM -0700, Dave Hansen wrote:
> > > On 11/2/18 10:06 AM, Sean Christopherson wrote:
> > > > On Fri, Nov 02, 2018 at 09:56:44AM -0700, Dave Hansen wrote:
> > > >> On 11/2/18 9:30 AM, Sean Christopherson wrote:
> > > >>> What if rather than having userspace register an address for fixup, the
> > > >>> kernel instead unconditionally does fixup on the ENCLU opcode?
> > > >>
> > > >> The problem is knowing what to do for the fixup.  If we have a simple
> > > >> action to take that's universal, like backing up %RIP, or setting some
> > > >> other register state, it's not bad.
> > > >
> > > > Isn't the EENTER/RESUME behavior universal?  Or am I missing something?
> > >
> > > Could someone write down all the ways we get in and out of the enclave?
> > >
> > > I think we always get in from userspace calling EENTER or ERESUME.  We
> > > can't ever enter directly from the kernel, like via an IRET from what I
> > > understand.
> >
> > Correct, the only way to get into the enclave is EENTER or ERESUME.
> > My understanding is that even SMIs bounce through the AEX target
> > before transitioning to SMM.
> >
> > > We get *out* from exceptions, hardware interrupts, or enclave-explicit
> > > EEXITs.  Did I miss any?  Remind me where the hardware lands the control
> > > flow in each of those exit cases.
> >
> > And VMExits.  There are basically two cases: EEXIT and everything else.
> > EEXIT is a glorified indirect jump, e.g. %RBX holds the target %RIP.
> > Everything else is an Asynchronous Enclave Exit (AEX).  On an AEX, %RIP
> > is set to a value specified by EENTER/ERESUME, %RBP and %RSP are
> > restored to pre-enclave values and all other registers are loaded with
> > synthetic state.  The actual interrupt/exception/VMExit then triggers,
> > e.g. the %RIP on the stack for an exception is always the AEX target,
> > not the %RIP inside the enclave that actually faulted.
> 
> So what exactly happens when an enclave accesses non-enclave memory
> and takes a page fault, for example?  The SDM says that the #PF vector
> and error code are stored in the SSA frame where the kernel can't see
> them.  Is a real #PF then delivered?

Yes.  From there kernel's perspective a #PF occurred on the %RIP of the
AEX target.  This holds true for all AEX types, e.g. GUEST_RIP on VMExit
also points at the AEX target.  On an AEX, %RAX, %RBX and %RCX are set
to match the ERESUME parameter.  The idea is for userspace to have an
ENCU at the AEX so that it automatically ERESUMEs the enclave after the
kernel handles the fault.  And the trampoline approach means the ucode
flows for exceptions, interrupts, VMExit, VMEnter, IRET, RSM, etc...
generally don't need to be SGX-aware.  The events themselves just need
to be redirected to the AEX target and then redo the event.

> I guess that, if the memory in question gets faulted in, then the
> kernel resumes exection at the AEP address, which does ERESUME, and
> the enclave resumes.  But if the access is bad, then the kernel
> delivers a signal (or uses some other new mechanism), and then what
> happens?  Is the enclave just considered dead?  Is user code supposed
> to EENTER back into the enclave to tell it that it got an error?

Completely depends on the enclave and its runtime.  A simple enclave
mayy never expect to encounter a bad access or #UD and so its runtime
would probably just kill it.  A test/development enclave might have
its runtime call back into the enclave to dump state on a fatal fault.

Complex runtimes, e.g. libraries that wrap unmodified applications,
will call back into the enclave so that libraries in-enclave fault
handler can decode what went wrong and take action accordingly, e.g.
request CPUID information if unmodified code tried to do CPUID.

> This whole mechanism seems very complicated, and it's not clear
> exactly what behavior user code wants.

No argument there.  That's why I like the approach of dumping the
exception to userspace without trying to do anything intelligent in
the kernel.  Userspace can then do whatever it wants AND we don't
have to worry about mucking with stacks.

One of the hiccups with the VDSO approach is that the enclave may
want to use the untrusted stack, i.e. the stack that has the VDSO's
stack frame.  For example, Intel's SDK uses the untrusted stack to
pass parameters for EEXIT, which means an AEX might occur with what
is effectively a bad stack from the VDSO's perspective.
