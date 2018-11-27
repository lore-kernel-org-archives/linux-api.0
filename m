From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC PATCH RESEND v3 3/3] ptrace: add PTRACE_EVENT_SECCOMP
 support to PTRACE_GET_SYSCALL_INFO
Date: Wed, 28 Nov 2018 02:27:53 +0300
Message-ID: <20181127232753.GA18755@altlinux.org>
References: <20181125022150.46258a20@akathisia>
 <20181125022340.5703400f@akathisia>
 <20181126143524.GB1660@redhat.com>
 <20181127040732.1c9f7965@akathisia>
 <20181127123116.GA13284@redhat.com>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5750018454802890952=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181127123116.GA13284-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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


--===============5750018454802890952==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27, 2018 at 01:31:17PM +0100, Oleg Nesterov wrote:
> On 11/27, Elvira Khabirova wrote:
> > On Mon, 26 Nov 2018 15:35:24 +0100, Oleg Nesterov wrote:
> > > On 11/25, Elvira Khabirova wrote:
> > > >
> > > > Extend PTRACE_GET_SYSCALL_INFO to support PTRACE_EVENT_SECCOMP stop=
s.
> > > > The information returned is the same as for syscall-enter-stops.
> > >
> > > Oh, this is not nice ;) there must be a better option, I hope... Plus
> > >
> > >
> > > Can't ptrace_get_syscall() check
> > >
> > > 	child->exit_code =3D=3D (PTRACE_EVENT_SECCOMP << 8) | SIGTRAP;
> > >
> > > to detect the PTRACE_EVENT_SECCOMP case?
> >
> > Nope; looks like exit_code is zeroed after wait().
>=20
> Yes, thanks for correcting me,
>=20
> but we can use child->last_siginfo->si_code.

Yes, this approach works, thanks!

> Just like ptrace_request(PTRACE_LISTEN)
> does but you can do this lockless (no need to lock_task_sighand()).

Why this can be done lockless?  All other places in that file do
the locking, so I'd rather add a comment in the new code.

> And if we require that the user of ptrace_get_syscall() should also use T=
RACESYSGOOD
> then ptrace_get_syscall() can probably do something like
>=20
> 	int entry;
>=20
> 	if (!child->last_siginfo)
> 		return -EINVAL;
> 	else if (child->last_siginfo->si_code =3D=3D (PTRACE_EVENT_SECCOMP << 8)=
 | SIGTRAP)
> 		entry =3D 1;
> 	else if (child->last_siginfo->si_code =3D=3D SIGTRAP | 0x80)
> 		entry =3D child->ptrace_message =3D=3D PTRACE_EVENTMSG_SYSCALL_ENTRY;
> 	else
> 		return -EINVAL;
>=20
> and this way PTRACE_EVENTMSG_SYSCALL_ENTRY/EXIT can't confict with seccom=
p or
> anything else.
>=20
> No?
>=20
> Of course, debugger can do PTRACE_SETSIGINFO and confuse itself but proba=
bly we
> do not care?

The only potential issue I could think of is whether PTRACE_SETSIGINFO
could be used this way to cause an information leak by making
PTRACE_GET_SYSCALL_INFO access some unrelated data.


--=20
ldv

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJb/dL4AAoJEAVFT+BVnCUIF/MQAMC9+XrGx9ayW2qY4YB/NhyN
Y45xc4uPFby1DPp0rzogf2SJ0A8A5j6TH1uDXNg4yDEh8o0Ov4oTKqbeKl6PorM1
jf0zk2rENykAdZX503kaI5HWMgddR7q1q8XyjsyDL1FUwQtBito+pbC5cr82hfkY
96UqJmm8XlbRbDIkZkuGE8SAnTbEufBg2eY9RvamuBKsOSbqN+03kP9ThQ2Ecen4
6dgdnX00hpCL3HFCjXbymjmKZGoY4hAVpKpZK76W6yaIXaBnaJ/OGC8n638Hw43Q
9Tt2FDgslQDYJyeBuL+GuW6IznUp38EG4g6iHZLL1UHZUMVYdKgQcdaOsd3lXY25
89Z7dnBcQz0P3K1Jmgc/GgZzO0xeCsEATuVWzdNPj09mMok0b++nHFnD5Yeb9nDt
ndAiE9h6RnpHy2aYma05SLH7nd7CpcEbC8GIR5pMUd3F+QzPX2QNTC1S9QLNqByf
4RelqJB88Rj44NBGKWW83+I+zhpCGpsrwU4Fn8c2kLgHzZFuWwROjP5RYE0nV40Y
qhP1irq1PcWg9V6OY0T6wxPV2Tfa8tuvxCxVSZ35YhrTqbgKMYxfyjk3MyUJs7FG
qUH+ntArYQ2NiAeSQsU8WGD8yONDiBEJbF9EeqAApUvJTcuIRoj/xyOBiaQi7uDi
S0KILWIMBBkcuXJR9Hmp
=F6Fd
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--

--===============5750018454802890952==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============5750018454802890952==--
