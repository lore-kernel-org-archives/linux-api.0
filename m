From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC PATCH RESEND v3 3/3] ptrace: add PTRACE_EVENT_SECCOMP
 support to PTRACE_GET_SYSCALL_INFO
Date: Wed, 28 Nov 2018 15:44:11 +0300
Message-ID: <20181128124411.GA28206@altlinux.org>
References: <20181125022150.46258a20@akathisia>
 <20181125022340.5703400f@akathisia>
 <20181126143524.GB1660@redhat.com>
 <20181127040732.1c9f7965@akathisia>
 <20181127123116.GA13284@redhat.com>
 <20181127232753.GA18755@altlinux.org>
 <20181128123545.GA30395@redhat.com>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1043393917301171378=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181128123545.GA30395-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eugene Syromyatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org


--===============1043393917301171378==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2018 at 01:35:46PM +0100, Oleg Nesterov wrote:
> On 11/28, Dmitry V. Levin wrote:
> >
> > > Just like ptrace_request(PTRACE_LISTEN)
> > > does but you can do this lockless (no need to lock_task_sighand()).
> >
> > Why this can be done lockless?  All other places in that file do
> > the locking,
>=20
> PTRACE_LISTEN too doesn't need lock_task_sighand() to access ->last_sigin=
fo,
> this code predates ptrace_freeze_traced() which ensures that the tracee c=
an't
> go away and clear ->last_siginfo.
>=20
> However, unlike ptrace_get_syscall(), PTRACE_LISTEN needs spin_lock_irq(s=
iglock),
> it modifies ->jobctl and calls signal_wake_up().

What about PTRACE_GETSIGINFO?  Can it also be done lockless because
ptrace_check_attach() has already called ptrace_freeze_traced()?

> > > Of course, debugger can do PTRACE_SETSIGINFO and confuse itself but p=
robably we
> > > do not care?
> >
> > The only potential issue I could think of is whether PTRACE_SETSIGINFO
> > could be used this way to cause an information leak by making
> > PTRACE_GET_SYSCALL_INFO access some unrelated data.
>=20
> Well, afaics ptrace_get_syscall() does nothing "special", debugger can us=
e other
> PTRACE_ requests to get the same info?

I agree.


--=20
ldv

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJb/o2bAAoJEAVFT+BVnCUIhvUQAIITUiL87+l7B5purj2mbkde
iOE/2Upl2PG1jlb+aKB1rQTknLKRPXkprZud8j6327ts1xhKyxkkzHJwiEODo1Eg
DjYSysvUYMKHkZ2erWw4rUD21u3g100pnVKe/nx55ePOgq8HVFHjjuW+1yFCS7AQ
YWPQmnlhCjIRAZjH3N7Qapcp/DdjDPhobziUeKE9lyTQU+Ea7NgH1imDz2yTG3MZ
n+ntMSaFFFz9exMbW3IbEnYSP+0wboJpmUXKLurXYuLF+jXcjWPH1SjDHo2KmNm2
necxBlcveAl8f8IYTOzRwelHG0I/GdHFdLoN7Bcw1gZLPLWYa16zZpdAhrp5xZ5x
zU3+2ABICMEsa3kG17g574F0hotpu2AIVxqkc1aY67O84WboiJaemwA3twoL8WeT
FkxIctOP7qu6H1REgWkxoWrRTcHUfQAWRuh+ehonhCX/GrI1p0ibkKOJkYOJap4M
vXADBKoZQ0kT/FSMRsfye9n+P7Gn3xTUrYCC74s/3X0bI9JhUiUxNCvF/zVlvmD5
dCMIkpGZUlnyyyUHXPPKZtdSghbsvkYSNdsxSPwZDrfgYda/dl1Pk7wCJiEvpOqa
DQEOris9iGq3yhGp4KihLU2OvB6spqr1F0FRdLyyWLkPkr3fTeaFgyyFk1T6Nszf
36mOBoXMlGz/IOrToycg
=4nL6
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--

--===============1043393917301171378==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============1043393917301171378==--
