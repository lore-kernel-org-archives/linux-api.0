From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Sat, 15 Dec 2018 07:30:43 -0800
Message-ID: <FB9A08ED-7D37-44C1-86D1-25E3711E3837@amacapital.net>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com> <6577ac4f-524c-37f4-a4d0-6eb94ec7d9a5@schoebel-theuer.de> <CALCETrV0fVLZKG6JrOvzvOzP06UxhZW=LbHpPXbonoeFdPJB1A@mail.gmail.com> <35905587-2d7b-c0ab-e081-2b938d60e881@schoebel-theuer.de> <54449048-a057-5005-1b50-b884628643eb@schoebel-theuer.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54449048-a057-5005-1b50-b884628643eb@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org



> On Dec 14, 2018, at 11:41 PM, Thomas Schoebel-Theuer <tst@schoebel-theuer.=
de> wrote:
>=20
>> On 12/14/18 22:41, Thomas Sch=C3=B6bel-Theuer wrote:
>>> On 12/14/18 22:24, Andy Lutomirski wrote:
>>>=20
>>> I'm talking about x32, which is a different beast.
>>>=20
>>=20
>> So from my viewpoint the mentioned roadmap / timing requirements will rem=
ain the same, whatever you are dropping.
>>=20
>> Enterprise-critical use cases will probably need to be migrated to KVM/qe=
mu together with their old kernel versions, anyway (because the original har=
dware will be no longer available in a few decades).
>>=20
>=20
> Here is a systematic approach to the problem.
>=20

This is way off topic. Let=E2=80=99s not discuss it on this thread, please.
