From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: RFC: userspace exception fixups
Date: Thu, 8 Nov 2018 12:05:42 -0800
Message-ID: <CALCETrUCQbPMfBJVRRg=0apEU=2U2ps74UPTrN8bFqi1k0K4VA@mail.gmail.com>
References: <1541518670.7839.31.camel@intel.com> <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
 <1541524750.7839.51.camel@intel.com> <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com> <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com> <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com> <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
 <20181108195420.GA14715@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181108195420.GA14715@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Andrew Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 8, 2018 at 11:54 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Nov 06, 2018 at 01:07:54PM -0800, Andy Lutomirski wrote:
> >
> >
> > > On Nov 6, 2018, at 1:00 PM, Dave Hansen <dave.hansen@intel.com> wrote=
:
> > >
> > >> On 11/6/18 12:12 PM, Andy Lutomirski wrote:
> > >> True, but what if we have a nasty enclave that writes to memory just
> > >> below SP *before* decrementing SP?
> > >
> > > Yeah, that would be unfortunate.  If an enclave did this (roughly):
> > >
> > >    1. EENTER
> > >    2. Hardware sets eenter_hwframe->sp =3D %sp
> > >    3. Enclave runs... wants to do out-call
> > >    4. Enclave sets up parameters:
> > >        memcpy(&eenter_hwframe->sp[-offset], arg1, size);
> > >        ...
> > >    5. Enclave sets eenter_hwframe->sp -=3D offset
> > >
> > > If we got a signal between 4 and 5, we'd clobber the copy of 'arg1' t=
hat
> > > was on the stack.  The enclave could easily fix this by moving ->sp f=
irst.
> > >
> > > But, this is one of those "fun" parts of the ABI that I think we need=
 to
> > > talk about.  If we do this, we also basically require that the code
> > > which handles asynchronous exits must *not* write to the stack.  That=
's
> > > not hard because it's typically just a single ERESUME instruction, bu=
t
> > > it *is* a requirement.
> > >
> >
> > I was assuming that the async exit stuff was completely hidden by the
> > API.  The AEP code would decide whether the exit got fixed up by the
> > kernel (which may or may not be easy to tell =E2=80=94 can the code eve=
n tell
> > without kernel help whether it was, say, an IRQ vs #UD?) and then eithe=
r
> > do ERESUME or cause sgx_enter_enclave() to return with an appropriate
> > return value.
>
> Ok, SDK folks came up with an idea that would allow them to use vDSO,
> albeit with a bit of ugliness and potentially a ROP-attack issue.
> Definitely some weirdness, but the weirdness is well contained, unlike
> the magic prefix approach.
>
> Provide two enter_enclave() vDSO "functions".  The first is a normal
> function with a normal C interface.  The second is a blob of code that
> is "called" and "returns" via indirect jmp, and can be used by SGX
> runtimes that want to use the untrusted stack for out-calls from the
> enclave.
>
> For the indirect jmp "function", use %rbp to stash the return address
> of the caller (either in %rbp itself or in memory pointed to by %rbp).
> It works because hardware also saves/restores %rbp along with %rsp when
> doing enclave transitions, and the SDK can live with %rbp being
> off-limits.  Fault info is passed via registers.

Hmm.  The idea being that the SDK preserves RBP but not RSP.  That's
not the most terrible thing in the world.  But could the SDK live with
something more like my suggestion where the vDSO supplies a normal
function that takes a struct containing registers that are visible to
the enclave?  This would make it extremely awkward for the enclave to
use the untrusted stack per se, but it would make it quite easy (I
think) for the untrusted part of the SDK to allocate some extra memory
and just tell the enclave that *that* memory is the stack.

AFAFICS we do have two registers that genuinely are preserved: FSBASE
and GSBASE.  Which is a good thing, because otherwise SGX enablement
would currently be a privilege escalation issue due to making GSBASE
writable when it should not be.

This whole thing is a mess.  I'm starting to think that the cleanest
solution would be to provide a way to just tell the kernel that
certain RIP values have exception fixups.
