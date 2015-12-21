From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH v1 1/4] um: Fix ptrace GETREGS/SETREGS bugs
Date: Mon, 21 Dec 2015 10:23:50 +0100
Message-ID: <5677C526.5070803@digikod.net>
References: <1450656209-2676-1-git-send-email-mic@digikod.net>
 <1450656209-2676-2-git-send-email-mic@digikod.net> <567745E3.1030509@nod.at>
 <5677BD23.4060602@digikod.net> <5677BFBD.3090200@nod.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="4D5nbhGxWpCLo44TQCPe2lxCqdhclsRDj"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5677BFBD.3090200-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>, Nicolas Iooss <nicolas.iooss_linux-oWGTIYur0i8@public.gmane.org>, Anton Ivanov <aivanov-43mecJUBy8ZBDgjK7y7TUQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4D5nbhGxWpCLo44TQCPe2lxCqdhclsRDj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On 21/12/2015 10:00, Richard Weinberger wrote:
> [sending the mail again, Thunderbird crashed :-\]
>=20
> Am 21.12.2015 um 09:49 schrieb Micka=C3=ABl Sala=C3=BCn:
>>
>> On 21/12/2015 01:20, Richard Weinberger wrote:
>>> Am 21.12.2015 um 01:03 schrieb Micka=C3=ABl Sala=C3=BCn:
>>>> diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/sys=
call.c
>>>> index 1683b8e..65f0d1a 100644
>>>> --- a/arch/um/kernel/skas/syscall.c
>>>> +++ b/arch/um/kernel/skas/syscall.c
>>>> @@ -7,6 +7,7 @@
>>>>  #include <linux/ptrace.h>
>>>>  #include <kern_util.h>
>>>>  #include <sysdep/ptrace.h>
>>>> +#include <sysdep/ptrace_user.h>
>>>>  #include <sysdep/syscalls.h>
>>>>  #include <os.h>
>>>> =20
>>>> @@ -16,12 +17,16 @@ void handle_syscall(struct uml_pt_regs *r)
>>>>  	long result;
>>>>  	int syscall;
>>>> =20
>>>> +	/* Save the syscall register. */
>>>> +	UPT_SYSCALL_NR(r) =3D PT_SYSCALL_NR(r->gp);
>>>> +
>>>>  	if (syscall_trace_enter(regs)) {
>>>>  		result =3D -ENOSYS;
>>>>  		goto out;
>>>>  	}
>>>> =20
>>>> -	syscall =3D get_syscall(r);
>>>> +	/* Get the syscall after being potentially updated with ptrace. */=

>>>> +	syscall =3D UPT_SYSCALL_NR(r);
>>>
>>> Doesn't this break the support for changing syscall numbers using PTR=
ACE_SETREGS?
>>
>> The logic is unchanged except updating the UPT_SYSCALL_NR before sysca=
ll_trace_enter(). I did my last tests with the x86_32 subarchitecture and=
 all tests (from selftest/seccomp), including PTRACE_SETREGS for syscall =
numbers tests, passed. However, 2 of this tests still fail for x86_64 (on=
ly).
>=20
> No, the logic is different.
> syscall_trace_enter(regs) enters the ptrace() path and here registers c=
an be changed.
> Hence "syscall =3D UPT_SYSCALL_NR(r);" will see the old syscall number.=

> UPT_SYSCALL_NR() returns the syscall number before the ptrace() path...=


The thing is, PTRACE_SETREGS give access to *orig_ax* in the user_regs_st=
ruct from arch/x86/include/asm/user_*.h and selftest/seccomp only update =
this (virtual) register, not the EAX/RAX. Am I missing something?

 Micka=C3=ABl


--4D5nbhGxWpCLo44TQCPe2lxCqdhclsRDj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJWd8UnAAoJECLe/t9zvWqV4scIAJVJe6FwebC//iEIFe4Kc7hZ
YpXJyMIzjfdALnwqrXZwHaNvT2PtUCTTv9/Us4g/tPm3zNNO0OMl5bWsV7E4UbxV
q084cdNUa9y882fXn6jfLDvO2sA7Z+nh/F7yXqLbRmOmSbR3GmpwmXgjvttEmEIX
gY4Z/CTDY5vPBckArQkg0ikMKQBiNJobi+PNgIsMwfRzdgVzxggd5w/p7Sv1mOTk
/J99QI/SOxt16GcWMhb2RaeM9lAQPiwm1u1qaauIzlaj3G8HXpNX9OBgCiV/fDeI
rsgWSlWIWpqguutExkEq0GOcDPGwteq7Zq8SNtBWX+rJ66z4ey9RHTZP+aM7Jnk=
=Bcug
-----END PGP SIGNATURE-----

--4D5nbhGxWpCLo44TQCPe2lxCqdhclsRDj--
