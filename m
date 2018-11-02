From: Andy Lutomirski <luto@kernel.org>
Subject: Re: RFC: userspace exception fixups
Date: Fri, 2 Nov 2018 10:48:38 -0700
Message-ID: <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
References: <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx> <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx> <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102173350.GF7393@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Andrew Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
List-Id: linux-api@vger.kernel.org

On Fri, Nov 2, 2018 at 10:33 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Nov 02, 2018 at 10:13:23AM -0700, Dave Hansen wrote:
> > On 11/2/18 10:06 AM, Sean Christopherson wrote:
> > > On Fri, Nov 02, 2018 at 09:56:44AM -0700, Dave Hansen wrote:
> > >> On 11/2/18 9:30 AM, Sean Christopherson wrote:
> > >>> What if rather than having userspace register an address for fixup, the
> > >>> kernel instead unconditionally does fixup on the ENCLU opcode?
> > >>
> > >> The problem is knowing what to do for the fixup.  If we have a simple
> > >> action to take that's universal, like backing up %RIP, or setting some
> > >> other register state, it's not bad.
> > >
> > > Isn't the EENTER/RESUME behavior universal?  Or am I missing something?
> >
> > Could someone write down all the ways we get in and out of the enclave?
> >
> > I think we always get in from userspace calling EENTER or ERESUME.  We
> > can't ever enter directly from the kernel, like via an IRET from what I
> > understand.
>
> Correct, the only way to get into the enclave is EENTER or ERESUME.
> My understanding is that even SMIs bounce through the AEX target
> before transitioning to SMM.
>
> > We get *out* from exceptions, hardware interrupts, or enclave-explicit
> > EEXITs.  Did I miss any?  Remind me where the hardware lands the control
> > flow in each of those exit cases.
>
> And VMExits.  There are basically two cases: EEXIT and everything else.
> EEXIT is a glorified indirect jump, e.g. %RBX holds the target %RIP.
> Everything else is an Asynchronous Enclave Exit (AEX).  On an AEX, %RIP
> is set to a value specified by EENTER/ERESUME, %RBP and %RSP are
> restored to pre-enclave values and all other registers are loaded with
> synthetic state.  The actual interrupt/exception/VMExit then triggers,
> e.g. the %RIP on the stack for an exception is always the AEX target,
> not the %RIP inside the enclave that actually faulted.

So what exactly happens when an enclave accesses non-enclave memory
and takes a page fault, for example?  The SDM says that the #PF vector
and error code are stored in the SSA frame where the kernel can't see
them.  Is a real #PF then delivered?

I guess that, if the memory in question gets faulted in, then the
kernel resumes exection at the AEP address, which does ERESUME, and
the enclave resumes.  But if the access is bad, then the kernel
delivers a signal (or uses some other new mechanism), and then what
happens?  Is the enclave just considered dead?  Is user code supposed
to EENTER back into the enclave to tell it that it got an error?

This whole mechanism seems very complicated, and it's not clear
exactly what behavior user code wants.
