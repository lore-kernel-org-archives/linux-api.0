From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v1 1/4] um: Fix ptrace GETREGS/SETREGS bugs
Date: Mon, 21 Dec 2015 20:10:54 +0100
Message-ID: <56784EBE.7050403@digikod.net>
References: <1450656209-2676-1-git-send-email-mic@digikod.net>
 <1450656209-2676-2-git-send-email-mic@digikod.net> <567745E3.1030509@nod.at>
 <5677BD23.4060602@digikod.net> <5677BFBD.3090200@nod.at>
 <5677C526.5070803@digikod.net> <5677D0CD.1070602@nod.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="kXJg2g6i7GHL2aMFvhM3opR6obpSXqXMI"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5677D0CD.1070602@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Jeff Dike <jdike@addtoit.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuahkh@osg.samsung.com>, Chris Metcalf <cmetcalf@ezchip.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, James Hogan <james.hogan@imgtec.com>, Thomas Meyer <thomas@m3y3r.de>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Anton Ivanov <aivanov@brocade.com>, linux-doc@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-api@vger.kernel.org, Meredydd Luff <meredydd@senatehouse.org>, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kXJg2g6i7GHL2aMFvhM3opR6obpSXqXMI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On 21/12/2015 11:13, Richard Weinberger wrote:
> Am 21.12.2015 um 10:23 schrieb Micka=C3=ABl Sala=C3=BCn:
>>>>> Doesn't this break the support for changing syscall numbers using P=
TRACE_SETREGS?
>>>>
>>>> The logic is unchanged except updating the UPT_SYSCALL_NR before sys=
call_trace_enter(). I did my last tests with the x86_32 subarchitecture a=
nd all tests (from selftest/seccomp), including PTRACE_SETREGS for syscal=
l numbers tests, passed. However, 2 of this tests still fail for x86_64 (=
only).
>>>
>>> No, the logic is different.
>>> syscall_trace_enter(regs) enters the ptrace() path and here registers=
 can be changed.
>>> Hence "syscall =3D UPT_SYSCALL_NR(r);" will see the old syscall numbe=
r.
>>> UPT_SYSCALL_NR() returns the syscall number before the ptrace() path.=
=2E.
>>
>> The thing is, PTRACE_SETREGS give access to *orig_ax* in the user_regs=
_struct from arch/x86/include/asm/user_*.h and selftest/seccomp only upda=
te this (virtual) register, not the EAX/RAX. Am I missing something?
>=20
> Sorry, meant orig...
>=20
> Please see the attached program. It proves that your patch is breaking =
stuff.
> The test is extracted from UML's selftests.

OK, I found the origin of this misunderstanding. On x86_32, PTRACE_SETREG=
S set regs->syscall when updating orig_eax, which is not the case on x86_=
64, hence the difference of behavior. I fixed this bug in the v2 series. =
The ptsc test and all the seccomp tests pass for 32 and 64 bits!

Where can we find the UML selftests?

Thanks,
 Micka=C3=ABl


--kXJg2g6i7GHL2aMFvhM3opR6obpSXqXMI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJWeE6+AAoJECLe/t9zvWqV/qsH/A5OaD9hOvag5A2XmHPKbjV5
rXQsDLmFUERVcMPRPsbq/FH3ddPBz5S/BAiIx5A6s55oR0xy3I2gMD7NDkciWWEe
3/ncSX6h5t/BNnClwYeFhy6nCKKz6js4OleRV4UDKni1Ar1a3YDeN6fTCMw+lpK9
Tbzl+YUIIYdZ+FuFU29EzYVPEk9PSew2jXB7l5Tqd6FFtz5S9giMqq+oF7DK4noW
WaiCi09pxCCgdlF3VkxrHMw2AjxWbN6+xfnfRpBCwPuHZhjiMbmCo4dmv9SpNYvL
Z8HnSHrI1MCtGlFaP6n4PXBuZHPWfTHEOn7ecsl2gvXTm/N9hqy0hQziDYRZBY0=
=oDjJ
-----END PGP SIGNATURE-----

--kXJg2g6i7GHL2aMFvhM3opR6obpSXqXMI--
