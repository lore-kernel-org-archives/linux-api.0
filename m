From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: Review of ptrace Yama ptrace_scope description
Date: Sat, 25 Jun 2016 16:30:07 +0200
Message-ID: <20160625143006.GA24730@pc.thejh.net>
References: <a80772d7-f52a-0943-de24-a0cf8d6b2f7c@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a80772d7-f52a-0943-de24-a0cf8d6b2f7c-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 25, 2016 at 09:30:43AM +0200, Michael Kerrisk (man-pages) wrote:
> Hi Kees,
>=20
> So, last year, I added some documentation to ptrace(2) to describe
> the Yama ptrace_scope file. I don't think I asked you for review
> at the time, but in the light of other changes to the ptrace(2)
> page, it occurred to me that it might be a good idea to ask you
> to check the text below to see if anything is missing or could be
> improved. Might you have a moment for that?
>=20
>    /proc/sys/kernel/yama/ptrace_scope
>        On systems with the Yama Linux Security Module (LSM)  installed
>        (i.e.,  the  kernel  was configured with CONFIG_SECURITY_YAMA),
>        the /proc/sys/kernel/yama/ptrace_scope  file  (available  since
>        Linux  3.4)  can  be  used  to  restrict the ability to trace a
>        process with ptrace(2) (and thus also the ability to use  tools
>        such  as  strace(1) and gdb(1)).  The goal of such restrictions
>        is to prevent attack escalation whereby a  compromised  process
>        can  ptrace-attach  to  other  sensitive processes (e.g., a GPG
>        agent or an SSH session) owned by the user  in  order  to  gain
>        additional credentials and thus expand the scope of the attack.
>=20
>        More precisely, the Yama LSM limits two types of operations:
>=20
>        *  Any   operation   that   performs   a   ptrace  access  mode
>           PTRACE_MODE_ATTACH     check=E2=80=94for      example,      ptr=
ace()
>           PTRACE_ATTACH.   (See the "Ptrace access mode checking" dis=E2=
=80=90
>           cussion above.)
>=20
>        *  ptrace() PTRACE_TRACEME.
>=20
>        A process that has the CAP_SYS_PTRACE capability can update the
>        /proc/sys/kernel/yama/ptrace_scope file with one of the follow=E2=
=80=90
>        ing values:
>=20
>        0 ("classic ptrace permissions")
>               No additional restrictions on  operations  that  perform
>               PTRACE_MODE_ATTACH  checks  (beyond those imposed by the
>               commoncap and other LSMs).
>=20
>               The use of PTRACE_TRACEME is unchanged.
>=20
>        1 ("restricted ptrace") [default value]
>               When   performing   an   operation   that   requires   a
>               PTRACE_MODE_ATTACH  check, the calling process must have
>               a predefined relationship with the target  process.   By
>               default,  the predefined relationship is that the target
>               process must be a child of the caller.
>=20
>               A target process can employ the prctl(2)  PR_SET_PTRACER
>               operation  to declare a different PID that is allowed to
>               perform PTRACE_MODE_ATTACH  operations  on  the  target.
>               See   the   kernel   source   file   Documentation/secu=E2=
=80=90
>               rity/Yama.txt for further details.
>=20
>               The use of PTRACE_TRACEME is unchanged.

(namespaced) CAP_SYS_PTRACE is also sufficient here.


Both here and in the "admin-only attach" case, it is IMO important to
note that creating a user namespace effectively removes the Yama
protection because the owner of a namespace, when accessing its
contents from outside, is relatively capable.

This means that when a process tries to use namespaces to sandbox
itself, it inadvertently makes itself more accessible.

(This could probably be worked around in the kernel, but such a
workaround would likely not be default, but rather opt-in via a new
flag for clone() and unshare() or so.)


>        2 ("admin-only attach")
>               Only processes with the  CAP_SYS_PTRACE  capability  may
>               perform  PTRACE_MODE_ATTACH operations or trace children
>               that employ PTRACE_TRACEME.

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXbpVuAAoJED4KNFJOeCOo9C0QAI1B0KR/hDPRVNIbWClZHiAh
Wk1v/2MbRGWD8cWyHR7kFCZQQF6VotsJ8VP3I23YuqNQEV5EmfWx6rv+cJ7tcSoh
XXlmZ6kvurQhNcCnJtYXoeUs/+bdOoFlWurEWYtLeKTRrXtV3qcQdcHHbyFUWE+/
nRjxuHzGWHCIhstFv5mLQwU7NSLyBECtOOQI5X/e1/3wLOx2VHRmOz3ruX/kwliy
3biHlNm3C0SFUQ9vBKjEvkZgeefdqbadcw2vfQKbsOSXWeV0+cf7CZ4hVUcrAvkn
LZMvkIXrf1zpsoaduuakLOxwL5y9wAqLtzvyGSqATPuXhD/dFjd5MmySZqPfBVff
leJonxee3Kf+YviELyRgI/KlabNJSiJ5N/2EAPZbJD0ID8t9cd8YCITOPvg6WU9P
tAV+ttDa5VTrJ8SRz0QLy2knWf8CdGL1T1+STlVHEhJhd2uHu2YIGhQyXH8/HchM
NFPO5CddOOHOihuOkinxVXJN2hvNeZ7kwnyvn1oZRpxgVm8f81z34zgkz6Ocb8S6
1x1DZF+bH/Hc6xx+uDKrC/H1LN7Dh5LZR5wmpWBxsoBnGDBfdT/C7mBmafga3BAy
HSHvBUv84FBHgwjufYI4hf1YFjwqj7Sx+UOpJth9ayHhSD5qTUxSU6S8IupibRki
YyAut6jmthJstw/n0H+l
=4/g5
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
