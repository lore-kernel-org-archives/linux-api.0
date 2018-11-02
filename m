From: Andy Lutomirski <luto@kernel.org>
Subject: Re: RFC: userspace exception fixups
Date: Fri, 2 Nov 2018 10:16:02 -0700
Message-ID: <CALCETrVW23Hmwj9DeYJ95mGd-_6ZG4obZG+evc2NdXEGud6DBA@mail.gmail.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx> <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx> <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7e14ee0e-ce15-1e88-7ae9-4d0f40cb3d84@fortanix.com>
 <20181102165204.GC7393@linux.intel.com> <dd455b30-b586-bf5b-2195-cf20c1af9890@fortanix.com>
 <CALCETrUo8uwnu3dBVSHVtB_z4uQgW=40grVdZWmTt64Tei6WiQ@mail.gmail.com> <1b87048e-7ed8-14a1-572f-3cd825319f8c@fortanix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1b87048e-7ed8-14a1-572f-3cd825319f8c@fortanix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jethro Beekman <jethro@fortanix.com>
Cc: Andrew Lutomirski <luto@kernel.org>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 2, 2018 at 10:05 AM Jethro Beekman <jethro@fortanix.com> wrote:
>
> On 2018-11-02 10:01, Andy Lutomirski wrote:
> > On Fri, Nov 2, 2018 at 9:56 AM Jethro Beekman <jethro@fortanix.com> wrote:
> >>
> >> On 2018-11-02 09:52, Sean Christopherson wrote:
> >>> On Fri, Nov 02, 2018 at 04:37:10PM +0000, Jethro Beekman wrote:
> >>>> On 2018-11-02 09:30, Sean Christopherson wrote:
> >>>>> ... The intended convention for EENTER is to have an ENCLU at the AEX target ...
> >>>>>
> >>>>> ... to further enforce that the AEX target needs to be ENCLU.
> >>>>
> >>>> Some SGX runtimes may want to use a different AEX target.
> >>>
> >>> To what end?  Userspace gets no indication as to why the AEX occurred.
> >>> And if exceptions are getting transfered to userspace the trampoline
> >>> would effectively be handling only INTR, NMI, #MC and EPC #PF.
> >>>
> >>
> >> Various reasons...
> >>
> >> Userspace may have established an exception handling convention with the
> >> enclave (by setting TCS.NSSA > 1) and may want to call EENTER instead of
> >> ERESUME.
> >>
> >
> > Ugh,
> >
> > I sincerely hope that a future ISA extension lets the kernel return
> > directly back to enclave mode so that AEX events become entirely
> > invisible to user code.
>
> Can you explain how this would work for things like #BR/#DE/#UD that
> need to be fixed up by code running in the enclave before it can be resumed?
>

Sure.  A better enclave entry function would complete in one of two ways:

1. The enclave exited normally.  Some register output would indicate this.

2. The enclave existed due to an exception or interrupt.  The kernel
would be entered directly and notified of what happened.  The kernel
would fix it up if needed (#PF), handle an interrupt (for en enclave
exit due to an interrupt) and reenter the enclave.  If, of the error
is not kernel-fixable-up, it would return back to userspace with some
explanation of what happened.  Kind of like normal user code.

Alternatively, the CPU could directly distinguish between exceptions
that need the enclave's attention (#BR) and those that don't.

The fact that user code is involved in resuming an enclave when a
hardware interrupt occurs is silly IMO.
