From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: RFC: userspace exception fixups
Date: Tue, 6 Nov 2018 13:07:54 -0800
Message-ID: <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
 <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
 <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
 <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
 <1541518670.7839.31.camel@intel.com> <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
 <1541524750.7839.51.camel@intel.com> <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com> <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com> <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@li>
List-Id: linux-api@vger.kernel.org



> On Nov 6, 2018, at 1:00 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
>> On 11/6/18 12:12 PM, Andy Lutomirski wrote:
>> True, but what if we have a nasty enclave that writes to memory just
>> below SP *before* decrementing SP?
>=20
> Yeah, that would be unfortunate.  If an enclave did this (roughly):
>=20
>    1. EENTER
>    2. Hardware sets eenter_hwframe->sp =3D %sp
>    3. Enclave runs... wants to do out-call
>    4. Enclave sets up parameters:
>        memcpy(&eenter_hwframe->sp[-offset], arg1, size);
>        ...
>    5. Enclave sets eenter_hwframe->sp -=3D offset
>=20
> If we got a signal between 4 and 5, we'd clobber the copy of 'arg1' that
> was on the stack.  The enclave could easily fix this by moving ->sp first.=

>=20
> But, this is one of those "fun" parts of the ABI that I think we need to
> talk about.  If we do this, we also basically require that the code
> which handles asynchronous exits must *not* write to the stack.  That's
> not hard because it's typically just a single ERESUME instruction, but
> it *is* a requirement.
>=20

I was assuming that the async exit stuff was completely hidden by the API. T=
he AEP code would decide whether the exit got fixed up by the kernel (which m=
ay or may not be easy to tell =E2=80=94 can the code even tell without kerne=
l help whether it was, say, an IRQ vs #UD?) and then either do ERESUME or ca=
use sgx_enter_enclave() to return with an appropriate return value.
