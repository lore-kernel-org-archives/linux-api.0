From: Jann Horn <jannh@google.com>
Subject: Re: RFC: userspace exception fixups
Date: Sat, 3 Nov 2018 00:36:36 +0100
Message-ID: <CAG48ez2J9wRNDs0vhNVvVG4swjF8cA5n4T0vQnKixdPCaXVpHQ@mail.gmail.com>
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
 <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
 <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
 <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: sean.j.christopherson@intel.com, Dave Hansen <dave.hansen@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, dalias@libc.org, Dave Hansen <dave.hansen@linux.intel.com>, jethro@fortanix.com, jarkko.sakkinen@linux.intel.com, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, andriy.shevchenko@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, carlos@redhat.com, adhemerval.zane
List-Id: linux-api@vger.kernel.org

On Sat, Nov 3, 2018 at 12:32 AM Andy Lutomirski <luto@kernel.org> wrote:
> On Fri, Nov 2, 2018 at 4:28 PM Jann Horn <jannh@google.com> wrote:
> > On Fri, Nov 2, 2018 at 11:04 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > > On Fri, Nov 02, 2018 at 08:02:23PM +0100, Jann Horn wrote:
> > > > On Fri, Nov 2, 2018 at 7:27 PM Sean Christopherson
> > > > <sean.j.christopherson@intel.com> wrote:
> > > > > On Fri, Nov 02, 2018 at 10:48:38AM -0700, Andy Lutomirski wrote:
> > > > > > This whole mechanism seems very complicated, and it's not clear
> > > > > > exactly what behavior user code wants.
> > > > >
> > > > > No argument there.  That's why I like the approach of dumping the
> > > > > exception to userspace without trying to do anything intelligent in
> > > > > the kernel.  Userspace can then do whatever it wants AND we don't
> > > > > have to worry about mucking with stacks.
> > > > >
> > > > > One of the hiccups with the VDSO approach is that the enclave may
> > > > > want to use the untrusted stack, i.e. the stack that has the VDSO's
> > > > > stack frame.  For example, Intel's SDK uses the untrusted stack to
> > > > > pass parameters for EEXIT, which means an AEX might occur with what
> > > > > is effectively a bad stack from the VDSO's perspective.
> > > >
> > > > What exactly does "uses the untrusted stack to pass parameters for
> > > > EEXIT" mean? I guess you're saying that the enclave is writing to
> > > > RSP+[0...some_positive_offset], and the written data needs to be
> > > > visible to the code outside the enclave afterwards?
> > >
> > > As is, they actually do it the other way around, i.e. negative offsets
> > > relative to the untrusted %RSP.  Going into the enclave there is no
> > > reserved space on the stack.  The SDK uses EEXIT like a function call,
> > > i.e. pushing parameters on the stack and making an call outside of the
> > > enclave, hence the name out-call.  This allows the SDK to handle any
> > > reasonable out-call without a priori knowledge of the application's
> > > maximum out-call "size".
> >
> > But presumably this is bounded to be at most 128 bytes (the red zone
> > size), right? Otherwise this would be incompatible with
> > non-sigaltstack signal delivery.
>
>
> I think Sean is saying that the enclave also updates RSP.

Ah, bleh, of course.
