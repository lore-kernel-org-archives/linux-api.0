From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: RFC: userspace exception fixups
Date: Tue, 6 Nov 2018 10:20:27 -0800
Message-ID: <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com> <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com> <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com> <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com> <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com> <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com> <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com> <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com> <1541518670.7839.31.camel@intel.com> <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@a
 macapital.net> <1541524750.7839.51.camel@intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541524750.7839.51.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Dave Hansen <dave.hansen@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com, npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
List-Id: linux-api@vger.kernel.org




> On Nov 6, 2018, at 9:19 AM, Sean Christopherson <sean.j.christopherson@int=
el.com> wrote:
>=20
>> On Tue, 2018-11-06 at 08:57 -0800, Andy Lutomirski wrote:
>>=20
>> So I guess the non-enclave code basically can=E2=80=99t trust its stack p=
ointer
>> because of these shenanigans. And the AEP code has to live with the fact
>> that its RSP is basically arbitrary and probably can=E2=80=99t even be un=
wound
>> by a debugger?
>=20
> The SDK provides a Python GDB plugin to hook into the out-call flow and
> do more stack shenanigans.  =46rom what I can tell it's fudging the stack
> to make it look like a normal stack frame so the debugger can do it's
> thing.
>=20
>> And the EENTER code has to deal with the fact that its red zone can be
>> blatantly violated by the enclave?
>=20
> That's my understanding of things.  So yeah, if it wasn't obvious before,
> the trusted and untrusted parts of the SDK are very tightly coupled.

Yuck. Just how far does this right coupling go?  If there are enclaves that p=
lay with, say, FSBASE or GSBASE, we=E2=80=99re going to start having problem=
s. And the SGX handling of PKRU is complicated at best.

I almost feel like the right solution is to call into SGX on its own private=
 stack or maybe even its own private address space.=20=
