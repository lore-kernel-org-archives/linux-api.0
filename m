From: Andy Lutomirski <luto@kernel.org>
Subject: Re: RFC: userspace exception fixups
Date: Wed, 7 Nov 2018 13:33:24 -0800
Message-ID: <CALCETrUh4TkgTPjoaLaT-TjD9JuPhPrLbpGdB8C95R0a+rexww@mail.gmail.com>
References: <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
 <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
 <1541518670.7839.31.camel@intel.com> <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
 <1541524750.7839.51.camel@intel.com> <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com> <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <20181106231730.GR5150@brightrain.aerifal.cx> <20181106232616.GA11101@linux.intel.com>
 <20181107212758.GU5150@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181107212758.GU5150@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Andrew Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas
List-Id: linux-api@vger.kernel.org

On Wed, Nov 7, 2018 at 1:28 PM Rich Felker <dalias@libc.org> wrote:
>
> On Tue, Nov 06, 2018 at 03:26:16PM -0800, Sean Christopherson wrote:
> > On Tue, Nov 06, 2018 at 06:17:30PM -0500, Rich Felker wrote:
> > > On Tue, Nov 06, 2018 at 11:02:11AM -0800, Andy Lutomirski wrote:
> > > > On Tue, Nov 6, 2018 at 10:41 AM Dave Hansen <dave.hansen@intel.com> wrote:
> > > > >
> > > > > On 11/6/18 10:20 AM, Andy Lutomirski wrote:
> > > > > > I almost feel like the right solution is to call into SGX on its own
> > > > > > private stack or maybe even its own private address space.
> > > > >
> > > > > Yeah, I had the same gut feeling.  Couldn't the debugger even treat the
> > > > > enclave like its own "thread" with its own stack and its own set of
> > > > > registers and context?  That seems like a much more workable model than
> > > > > trying to weave it together with the EENTER context.
> > > >
> > > > So maybe the API should be, roughly
> > > >
> > > > sgx_exit_reason_t sgx_enter_enclave(pointer_to_enclave, struct
> > > > host_state *state);
> > > > sgx_exit_reason_t sgx_resume_enclave(same args);
> > > >
> > > > where host_state is something like:
> > > >
> > > > struct host_state {
> > > >   unsigned long bp, sp, ax, bx, cx, dx, si, di;
> > > > };
> > > >
> > > > and the values in host_state explicitly have nothing to do with the
> > > > actual host registers.  So, if you want to use the outcall mechanism,
> > > > you'd allocate some memory, point sp to that memory, call
> > > > sgx_enter_enclave(), and then read that memory to do the outcall.
> > > >
> > > > Actually implementing this would be distinctly nontrivial, and would
> > > > almost certainly need some degree of kernel help to avoid an explosion
> > > > when a signal gets delivered while we have host_state.sp loaded into
> > > > the actual SP register.  Maybe rseq could help with this?
> > > >
> > > > The ISA here is IMO not well thought through.
> > >
> > > Maybe I'm mistaken about some fundamentals here, but my understanding
> > > of SGX is that the whole point is that the host application and the
> > > code running in the enclave are mutually adversarial towards one
> > > another. Do any or all of the proposed protocols here account for this
> > > and fully protect the host application from malicious code in the
> > > enclave? It seems that having control over the register file on exit
> > > from the enclave is fundamentally problematic but I assume there must
> > > be some way I'm missing that this is fixed up.
> >
> > SGX provides protections for the enclave but not the other way around.
> > The kernel has all of its normal non-SGX protections in place, but the
> > enclave can certainly wreak havoc on its userspace process.  The basic
> > design idea is that the enclave is a specialized .so that gets extra
> > security protections but is still effectively part of the overall
> > application, e.g. it has full access to its host userspace process'
> > virtual memory.
>
> In that case it seems like the only way to use SGX that's not a gaping
> security hole is to run the SGX enclave in its own fully-seccomp (or
> equivalent) process, with no host application in the same address
> space. Since the host application can't see the contents of the
> enclave to make any determination of whether it's safe to run, running
> it in the same address space only makes sense if the cpu provides
> protection against unwanted accesses to the host's memory from the
> enclave -- and according to you, it doesn't.
>

I think the theory is that the enclave is shipped with the host application.

That being said, a way to run the enclave in an address space that has
basically nothing else (except an ENCLU instruction as a trampoline)
would be quite nice.
