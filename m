From: Andy Lutomirski <luto@kernel.org>
Subject: Re: RFC: userspace exception fixups
Date: Tue, 6 Nov 2018 11:02:11 -0800
Message-ID: <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
 <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
 <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
 <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
 <1541518670.7839.31.camel@intel.com> <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
 <1541524750.7839.51.camel@intel.com> <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Andrew Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 6, 2018 at 10:41 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 11/6/18 10:20 AM, Andy Lutomirski wrote:
> > I almost feel like the right solution is to call into SGX on its own
> > private stack or maybe even its own private address space.
>
> Yeah, I had the same gut feeling.  Couldn't the debugger even treat the
> enclave like its own "thread" with its own stack and its own set of
> registers and context?  That seems like a much more workable model than
> trying to weave it together with the EENTER context.

So maybe the API should be, roughly

sgx_exit_reason_t sgx_enter_enclave(pointer_to_enclave, struct
host_state *state);
sgx_exit_reason_t sgx_resume_enclave(same args);

where host_state is something like:

struct host_state {
  unsigned long bp, sp, ax, bx, cx, dx, si, di;
};

and the values in host_state explicitly have nothing to do with the
actual host registers.  So, if you want to use the outcall mechanism,
you'd allocate some memory, point sp to that memory, call
sgx_enter_enclave(), and then read that memory to do the outcall.

Actually implementing this would be distinctly nontrivial, and would
almost certainly need some degree of kernel help to avoid an explosion
when a signal gets delivered while we have host_state.sp loaded into
the actual SP register.  Maybe rseq could help with this?

The ISA here is IMO not well thought through.
