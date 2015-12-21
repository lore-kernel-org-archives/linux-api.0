From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v1 1/4] um: Fix ptrace GETREGS/SETREGS bugs
Date: Mon, 21 Dec 2015 09:49:39 +0100
Message-ID: <5677BD23.4060602@digikod.net>
References: <1450656209-2676-1-git-send-email-mic@digikod.net>
 <1450656209-2676-2-git-send-email-mic@digikod.net> <567745E3.1030509@nod.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="vv2hrPjda92gx8Ah22IVpAnE2mvJ0O1Xp"
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <567745E3.1030509@nod.at>
Sender: linux-doc-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Jeff Dike <jdike@addtoit.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuahkh@osg.samsung.com>, Chris Metcalf <cmetcalf@ezchip.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, James Hogan <james.hogan@imgtec.com>, Thomas Meyer <thomas@m3y3r.de>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Anton Ivanov <aivanov@brocade.com>, linux-doc@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-api@vger.kernel.org, Meredydd Luff <meredydd@senatehouse.org>, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vv2hrPjda92gx8Ah22IVpAnE2mvJ0O1Xp
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On 21/12/2015 01:20, Richard Weinberger wrote:
> Am 21.12.2015 um 01:03 schrieb Micka=C3=ABl Sala=C3=BCn:
>> diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/sysca=
ll.c
>> index 1683b8e..65f0d1a 100644
>> --- a/arch/um/kernel/skas/syscall.c
>> +++ b/arch/um/kernel/skas/syscall.c
>> @@ -7,6 +7,7 @@
>>  #include <linux/ptrace.h>
>>  #include <kern_util.h>
>>  #include <sysdep/ptrace.h>
>> +#include <sysdep/ptrace_user.h>
>>  #include <sysdep/syscalls.h>
>>  #include <os.h>
>> =20
>> @@ -16,12 +17,16 @@ void handle_syscall(struct uml_pt_regs *r)
>>  	long result;
>>  	int syscall;
>> =20
>> +	/* Save the syscall register. */
>> +	UPT_SYSCALL_NR(r) =3D PT_SYSCALL_NR(r->gp);
>> +
>>  	if (syscall_trace_enter(regs)) {
>>  		result =3D -ENOSYS;
>>  		goto out;
>>  	}
>> =20
>> -	syscall =3D get_syscall(r);
>> +	/* Get the syscall after being potentially updated with ptrace. */
>> +	syscall =3D UPT_SYSCALL_NR(r);
>=20
> Doesn't this break the support for changing syscall numbers using PTRAC=
E_SETREGS?

The logic is unchanged except updating the UPT_SYSCALL_NR before syscall_=
trace_enter(). I did my last tests with the x86_32 subarchitecture and al=
l tests (from selftest/seccomp), including PTRACE_SETREGS for syscall num=
bers tests, passed. However, 2 of this tests still fail for x86_64 (only)=
=2E

Regards,
 Micka=C3=ABl


--vv2hrPjda92gx8Ah22IVpAnE2mvJ0O1Xp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJWd70sAAoJECLe/t9zvWqVWhUH/3V7nFaCbBL1DM/hGBF6rblo
ZaLx7Wg7tWCdDwgv4HBTgaPANo3l/ljLQYvainozIfhU3wmNIEFZG3wWgDYWYI9P
LYa6wc5VOdlrbKd3AQidwpb4qJB2ONH5thpM9FRZEXYoxYI1eL/zG+Xb4ZvPaklU
RJQbXsvYgP1fjP2n18yRsO3kXmrurFIRduk+Ew+XkHBy2YnGE70YAE5XzmzZTdPQ
aghQdDF0YQcAsCcWd+nDwyIpmVg0QbTiMEA3thHPVAai4V5+Nc81ULDd7VTvGWws
51+iG0XOdU44OryjiCmuJ0zwQgtPGucltxx/8kipsZgf278Z7LttESaW7y7qAlQ=
=A/lB
-----END PGP SIGNATURE-----

--vv2hrPjda92gx8Ah22IVpAnE2mvJ0O1Xp--
