From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC PATCH v2] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Thu, 22 Nov 2018 22:15:04 +0300
Message-ID: <20181122191504.GB27204@altlinux.org>
References: <20181121165806.07da7c98@akathisia>
 <CALCETrV3TPCkYyhoLLcikXVeF-RdZUuLTCvKReK3Qb9LSS9Csw@mail.gmail.com>
 <20181121235634.GA14146@altlinux.org>
 <CALCETrXea_uRAqw_srW5CWgOzeM=RubaDbjnxZ=cUMy5Zv1TsA@mail.gmail.com>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3264062746841495755=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <CALCETrXea_uRAqw_srW5CWgOzeM=RubaDbjnxZ=cUMy5Zv1TsA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org


--===============3264062746841495755==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 22, 2018 at 06:55:29AM -0800, Andy Lutomirski wrote:
> On Wed, Nov 21, 2018 at 3:56 PM Dmitry V. Levin wrote:
> > On Wed, Nov 21, 2018 at 02:56:57PM -0800, Andy Lutomirski wrote:
> > > Please cc linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org for future versions.
> > >
> > > On Wed, Nov 21, 2018 at 7:58 AM Elvira Khabirova wrote:
> > > >
> > > > struct ptrace_syscall_info {
> > > >         __u8 op; /* 0 for entry, 1 for exit */
> > >
> > > Can you add proper defines, like:
> > >
> > > #define PTRACE_SYSCALL_ENTRY 0
> > > #define PTRACE_SYSCALL_EXIT 1
> > > #define PTRACE_SYSCALL_SECCOMP 2
> > >
> > > and make seccomp work from the start?  I'd rather we don't merge an
> > > implementation that doesn't work for seccomp and then have to rework
> > > it later.
> >
> > What's the difference between PTRACE_EVENT_SECCOMP and syscall-entry-st=
op
> > with regards to PTRACE_GET_SYSCALL_INFO request?  At least they have the
> > same entry_info to return.
>=20
> I'm not sure there's any material difference.

In that case we don't really need PTRACE_SYSCALL_SECCOMP: op field
describes the structure inside the union to use, not the ptrace stop.

> > As long as implementation (ab)uses ptrace_message to tell one kind of s=
top
> > from another, it can distinguish syscall-entry-stop and syscall-exit-st=
op
> > from each other and from many other kinds of stops, but it cannot
> > distinguish PTRACE_EVENT_SECCOMP from e.g. PTRACE_EVENT_EXIT.
>=20
> Hmm.  PTRACE_GET_SYSCALL_INFO should fail for PTRACE_EVENT_EXIT, I think.

Unless we can change PTRACE_EVENT_SECCOMP to set some higher bits of
ptrace_message (beyond SECCOMP_RET_DATA) which is very unlikely because
it would qualify as an ABI change, this would require an additional field
in struct task_struct because ptrace_message wouldn't be enough
to distinguish PTRACE_EVENT_SECCOMP from PTRACE_EVENT_EXIT.


--=20
ldv

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJb9wA4AAoJEAVFT+BVnCUIVLMP/icSrrhNzO/EyX/hEjQCpTbX
OIG34L3Q21JqPle06kSa08WKJ0xsCsOcnnpEqhEOkdgLiYr78im4j0bY+QZEpWRK
jNcGizVI7DCuELvY23SspHxSEHkPaTpZZT5YyYhH2q00Jzlq1z4rQsT3MngJt7KC
a3W7N/VqyhLASqXUAvxpwBfqzeGb/AoYpsEyON8Yr67MOTeLR3Sh5xY9+NMpMCQx
QWexSPWGcsysbY9P4Om2VUjQpdtX41emK9h202PoLyDz4EDOc7RzwoGXPyhD8BAX
RzUV+/7va5uvBvzCF8VXGtTbEQ7QJREjjE10T1tUlnbXTvC1pEq5oS0im8MQfITB
6xlBdFB5xCIMyNoY6yQLOb3ZZX27a9M02xrDam21t2OopB4Mvb9ul0T8azX792g1
fvTovioaCgE7ZYf+CN9caNhcJx4BKg2NXb/Y0T+nv2QRc053UgrJSYXnDM8+QIA8
gB4/KSV1wKJLsErmCtDuK6BoWfQSo2mY2CpgxilZKfOYw/EdtPzs7FgbiyEgnZ1Q
XpQou0maYn8MXPge1uxerBm4JvXsRm22MvbZe0UZCtmBesvhR2dsyAxpitnkVW6z
s+6myE2pFXIZGY2AlrcKa3ffA9GpYBkbMSEHih4moi27f4C5IPPk0nqtB1KiQXu/
qGGm+zLYM3ZbaeyA2qWp
=grzk
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--

--===============3264062746841495755==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============3264062746841495755==--
