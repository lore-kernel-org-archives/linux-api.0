From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: RFC: userspace exception fixups
Date: Tue, 6 Nov 2018 12:12:17 -0800
Message-ID: <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
 <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
 <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
 <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
 <1541518670.7839.31.camel@intel.com> <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
 <1541524750.7839.51.camel@intel.com> <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com> <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@li>
List-Id: linux-api@vger.kernel.org



> On Nov 6, 2018, at 11:22 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
>> On 11/6/18 11:02 AM, Andy Lutomirski wrote:
>>> On Tue, Nov 6, 2018 at 10:41 AM Dave Hansen <dave.hansen@intel.com> wrot=
e:
>>>=20
>>>> On 11/6/18 10:20 AM, Andy Lutomirski wrote:
>>>> I almost feel like the right solution is to call into SGX on its own
>>>> private stack or maybe even its own private address space.
>>>=20
>>> Yeah, I had the same gut feeling.  Couldn't the debugger even treat the
>>> enclave like its own "thread" with its own stack and its own set of
>>> registers and context?  That seems like a much more workable model than
>>> trying to weave it together with the EENTER context.
>>=20
>> So maybe the API should be, roughly
>>=20
>> sgx_exit_reason_t sgx_enter_enclave(pointer_to_enclave, struct
>> host_state *state);
>> sgx_exit_reason_t sgx_resume_enclave(same args);
>>=20
>> where host_state is something like:
>>=20
>> struct host_state {
>>  unsigned long bp, sp, ax, bx, cx, dx, si, di;
>> };
>>=20
>> and the values in host_state explicitly have nothing to do with the
>> actual host registers.  So, if you want to use the outcall mechanism,
>> you'd allocate some memory, point sp to that memory, call
>> sgx_enter_enclave(), and then read that memory to do the outcall.
>=20
> Ah, so instead of the enclave rudely "hijacking" the EENTER context, we
> have it nicely return and nicely _hint_ to the calling context what it
> would like to do.  Then, the EENTER context can make a controlled
> transition over to the requested context.

Exactly. And existing enclaves keep working =E2=80=94 their rudeness is just=
 magically translated into a hint!

>=20
>> Actually implementing this would be distinctly nontrivial, and would
>> almost certainly need some degree of kernel help to avoid an explosion
>> when a signal gets delivered while we have host_state.sp loaded into
>> the actual SP register.  Maybe rseq could help with this?
>=20
> As long as the memory pointed to by host_state.sp is valid and can hold
> the signal frame (grows down without clobbering anything), what goes
> boom?  The signal handling would push a signal frame and call the
> handler.  It would have a shallow-looking stack, but the handler could
> just do its normal business and return from the signal where the frame
> would get popped and continue with %rsp=3Dhost_state.sp, blissfully
> unaware of the signal ever having happened.

True, but what if we have a nasty enclave that writes to memory just below S=
P *before* decrementing SP?

I suspect that rseq really can be used for this with only minimal-ish modifi=
cations.  Or we could stick this in the vDSO with some appropriate fixups in=
 the kernel.=
