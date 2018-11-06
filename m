From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: RFC: userspace exception fixups
Date: Tue, 6 Nov 2018 08:57:35 -0800
Message-ID: <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com> <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com> <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com> <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com> <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com> <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com> <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com> <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com> <1541518670.7839.31.camel@intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541518670.7839.31.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Dave Hansen <dave.hansen@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
List-Id: linux-api@vger.kernel.org



> On Nov 6, 2018, at 7:37 AM, Sean Christopherson <sean.j.christopherson@int=
el.com> wrote:
>=20
>> On Fri, 2018-11-02 at 16:32 -0700, Andy Lutomirski wrote:
>>> On Fri, Nov 2, 2018 at 4:28 PM Jann Horn <jannh@google.com> wrote:
>>>=20
>>>=20
>>> On Fri, Nov 2, 2018 at 11:04 PM Sean Christopherson
>>> <sean.j.christopherson@intel.com> wrote:
>>>>=20
>>>>> On Fri, Nov 02, 2018 at 08:02:23PM +0100, Jann Horn wrote:
>>>>>=20
>>>>> On Fri, Nov 2, 2018 at 7:27 PM Sean Christopherson
>>>>> <sean.j.christopherson@intel.com> wrote:
>>>>>>=20
>>>>>>> On Fri, Nov 02, 2018 at 10:48:38AM -0700, Andy Lutomirski wrote:
>>>>>>>=20
>>>>>>> This whole mechanism seems very complicated, and it's not clear
>>>>>>> exactly what behavior user code wants.
>>>>>> No argument there.  That's why I like the approach of dumping the
>>>>>> exception to userspace without trying to do anything intelligent in
>>>>>> the kernel.  Userspace can then do whatever it wants AND we don't
>>>>>> have to worry about mucking with stacks.
>>>>>>=20
>>>>>> One of the hiccups with the VDSO approach is that the enclave may
>>>>>> want to use the untrusted stack, i.e. the stack that has the VDSO's
>>>>>> stack frame.  For example, Intel's SDK uses the untrusted stack to
>>>>>> pass parameters for EEXIT, which means an AEX might occur with what
>>>>>> is effectively a bad stack from the VDSO's perspective.
>>>>> What exactly does "uses the untrusted stack to pass parameters for
>>>>> EEXIT" mean? I guess you're saying that the enclave is writing to
>>>>> RSP+[0...some_positive_offset], and the written data needs to be
>>>>> visible to the code outside the enclave afterwards?
>>>> As is, they actually do it the other way around, i.e. negative offsets
>>>> relative to the untrusted %RSP.  Going into the enclave there is no
>>>> reserved space on the stack.  The SDK uses EEXIT like a function call,
>>>> i.e. pushing parameters on the stack and making an call outside of the
>>>> enclave, hence the name out-call.  This allows the SDK to handle any
>>>> reasonable out-call without a priori knowledge of the application's
>>>> maximum out-call "size".
>>> But presumably this is bounded to be at most 128 bytes (the red zone
>>> size), right? Otherwise this would be incompatible with
>>> non-sigaltstack signal delivery.
>>=20
>> I think Sean is saying that the enclave also updates RSP.
>=20
> Yeah, the enclave saves/restores RSP from/to the current save state area.
>=20
>> One might reasonably wonder how the SDX knows the offset from RSP to
>> the function ID.  Presumably using RBP?
>=20
> Here's pseudocode for how the SDK uses the untrusted stack, minus a
> bunch of error checking and gory details.
>=20
> The function ID and a pointer to a marshalling struct are passed to
> the untrusted runtime via normal register params, e.g. RDI and RSI.
> The marshalling struct is what's actually allocated on the untrusted
> stack, like alloca() but more complex and explicit.  The marshalling
> struct size is not artificially restricted by the SDK, e.g. AFAIK it
> could span multiple 4k pages.
>=20
>=20
> int sgx_out_call(const unsigned int func_index, void *marshalling_struct)
> {
>    struct sgx_encl_tls *tls =3D get_encl_tls();
>=20
>    %RBP =3D tls->save_state_area[SSA_RBP];
>    %RSP =3D tls->save_state_area[SSA_RSP];
>    %RDI =3D func_index;
>    %RSI =3D marshalling_struct;
>=20
>    EEXIT
>=20
>    /* magic elsewhere to get back here on an EENTER(OUT_CALL_RETURN) */
>    return %RAX
> }
>=20
> void *sgx_alloc_untrusted_stack(size_t size)
> {
>    struct sgx_encl_tls *tls =3D get_encl_tls();
>    struct sgx_out_call_context *context;
>    void *tmp;
>=20
>    /* create a frame on the trusted stack to hold the out-call context */
>    tls->trusted_stack -=3D sizeof(struct sgx_out_call_context);
>=20
>    /* save the untrusted %RSP into the out-call context */
>    context =3D (struct sgx_out_call_context *)tls->trusted_stack;
>    context->untrusted_stack =3D tls->save_state_area[SSA_RSP];
>=20
>    /* allocate space on the untrusted stack */
>    tmp =3D (void *)(tls->save_state_area[SSA_RSP] - size);
>    tls->save_state_area[SSA_RSP] =3D tmp;
>=20
>    return tmp;
> }
>=20
> void sgx_pop_untrusted_stack(void)
> {
>    struct sgx_encl_tls *tls =3D get_encl_tls();
>    struct sgx_out_call_context *context;
>=20
>    /* retrieve the current out-call context from the trusted stack */
>    context =3D (struct sgx_out_call_context *)tls->trusted_stack;
>=20
>    /* restore untrusted %RSP */
>    tls->save_state_area[SSA_RSP] =3D context->untrusted_stack;
>=20
>    /* pop the out-call context frame */
>    tls->trusted_stack +=3D sizeof(struct sgx_out_call_context);
> }
>=20
> int sgx_main(void)
> {
>    struct my_out_call_struct *params;
>=20
>    params =3D sgx_alloc_untrusted_stack(sizeof(*params));
>=20
>    params->0..N =3D XYZ;
>=20
>    ret =3D sgx_out_call(DO_WORK, params);
>=20
>    sgx_pop_untrusted_stack();
>=20
>    return ret;
> }

So I guess the non-enclave code basically can=E2=80=99t trust its stack poin=
ter because of these shenanigans. And the AEP code has to live with the fact=
 that its RSP is basically arbitrary and probably can=E2=80=99t even be unwo=
und by a debugger?  And the EENTER code has to deal with the fact that its r=
ed zone can be blatantly violated by the enclave?

I=E2=80=99m assuming it=E2=80=99s way too late for the SGX SDK to be changed=
 to use a normal RPC mechanism? I=E2=80=99m a bit disappointed that enclaves=
 can even manipulate outside state like this. I assume Intel had some reason=
 for making it possible, but still.=
