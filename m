From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC PATCH RESEND v3 3/3] ptrace: add PTRACE_EVENT_SECCOMP
 support to PTRACE_GET_SYSCALL_INFO
Date: Tue, 27 Nov 2018 06:21:09 +0300
Message-ID: <20181127032108.GA4154@altlinux.org>
References: <20181127040732.1c9f7965@akathisia>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0399909169279958558=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181127040732.1c9f7965@akathisia>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: Elvira Khabirova <lineprinter-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Eugene Syromyatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org


--===============0399909169279958558==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27, 2018 at 04:07:32AM +0100, Elvira Khabirova wrote:
> On Mon, 26 Nov 2018 15:35:24 +0100, Oleg Nesterov wrote:
> > On 11/25, Elvira Khabirova wrote:
> > >
> > > Extend PTRACE_GET_SYSCALL_INFO to support PTRACE_EVENT_SECCOMP stops.
> > > The information returned is the same as for syscall-enter-stops. =20
> >=20
> > Oh, this is not nice ;) there must be a better option, I hope... Plus
> >=20
> > Can't ptrace_get_syscall() check
> >=20
> > 	child->exit_code =3D=3D (PTRACE_EVENT_SECCOMP << 8) | SIGTRAP;
> >=20
> > to detect the PTRACE_EVENT_SECCOMP case?
>=20
> Nope; looks like exit_code is zeroed after wait().

It's explicitly reset to zero in wait_task_stopped() unless WNOWAIT wait
option is set.  When strace requests PTRACE_GET_SYSCALL_INFO after
wait4(), child->exit_code is already set to zero.


--=20
ldv

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJb/LgkAAoJEAVFT+BVnCUIKhoP/i5BX4tsokC30O4I3zGET2SV
7GDu6jbhCAYRFoXe7xNoRPQvSh8gfAziWHb6IExqHxdrqf7kj8jjrQS/bNGN/X/h
FBRNUJrRcXVKgQagnSIU1jJ30W8WtdDz5C21O7IF9MOSouqqLNvmsKxpPmLap472
1xp7cYszGVKw0KBc8MVCazWc+YjdTP1ws9Gfc2MfOmlZ3RVq4eEkBTylmKc5fo+X
UbZCp04VdN2QrdlpPNQZlyjz/Fyz1gC70Sr+hsQKh2P4ZQhBq4/p511J115l52+y
+/5bzT17NdTKRrt5R9UhXSyKiPT+24Sar5SyvCRXAdFbtcZHZk0AzbC9kExa1P+a
I0kN2YPdOlUckpKV5LX63dgQfDtSGWit46dSqHJcG9dSI2lF3kTnbpDOS13tdlsd
a+LobSdZUuVnAujQ+uouYF5+i6xtoj4AANEzhUk0w5xTwMG3gDzItiiVdjGukf4z
UHcLgaRAK8TOpm5fXpB3zzqzaza12f10EHFCK+YZQNBUlzS2x6QcDnsbc/Mfhzbz
/ph9RgedCKK2q1r1Ctz4Mr5lln5J4bQWIpf2tejraiPe/Nk3Vz6jEYUGpsTBcSWd
CndSGYHcXxXwmR8Bi39mT6isn6NSWYUOkM6oTI4KN4n9cSbGWY3tLVtxkL/yUQcP
hRzqjz5vbmXEbhytAi1V
=dIFr
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--

--===============0399909169279958558==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============0399909169279958558==--
