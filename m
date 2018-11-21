From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC PATCH v2] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Thu, 22 Nov 2018 02:56:34 +0300
Message-ID: <20181121235634.GA14146@altlinux.org>
References: <20181121165806.07da7c98@akathisia>
 <CALCETrV3TPCkYyhoLLcikXVeF-RdZUuLTCvKReK3Qb9LSS9Csw@mail.gmail.com>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0604242701946963456=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <CALCETrV3TPCkYyhoLLcikXVeF-RdZUuLTCvKReK3Qb9LSS9Csw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org


--===============0604242701946963456==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2018 at 02:56:57PM -0800, Andy Lutomirski wrote:
> Please cc linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org for future versions.
>=20
> On Wed, Nov 21, 2018 at 7:58 AM Elvira Khabirova wrote:
> >
> > struct ptrace_syscall_info {
> >         __u8 op; /* 0 for entry, 1 for exit */
>=20
> Can you add proper defines, like:
>=20
> #define PTRACE_SYSCALL_ENTRY 0
> #define PTRACE_SYSCALL_EXIT 1
> #define PTRACE_SYSCALL_SECCOMP 2
>=20
> and make seccomp work from the start?  I'd rather we don't merge an
> implementation that doesn't work for seccomp and then have to rework
> it later.

What's the difference between PTRACE_EVENT_SECCOMP and syscall-entry-stop
with regards to PTRACE_GET_SYSCALL_INFO request?  At least they have the
same entry_info to return.

As long as implementation (ab)uses ptrace_message to tell one kind of stop
=66rom another, it can distinguish syscall-entry-stop and syscall-exit-stop
=66rom each other and from many other kinds of stops, but it cannot
distinguish PTRACE_EVENT_SECCOMP from e.g. PTRACE_EVENT_EXIT.

> >         __u8 __pad0[7];
> >         union {
> >                 struct {
> >                         __s32 nr;
>=20
> __u64 please.  Syscall numbers are, as a practical matter, 64 bits.
> Admittedly, the actual effects of setting the high bits are unclear,
> and seccomp has issues with it, but let's not perpetuate the problem.

I agree.  Although the implementation uses syscall_get_nr()
which returns int, this could potentially be fixed in the future.

> >                         __u32 arch;
> >                         __u64 instruction_pointer;
> >                         __u64 args[6];
> >                 } entry_info;
> >                 struct {
> >                         __s64 rval;
> >                         __u8 is_error;
> >                         __u8 __pad1[7];
> >                 } exit_info;
> >         };
> > };
>=20
> Should seccomp events use entry_info or should they just literally
> supply seccomp_data?

It certainly can use entry_info.
I'd prefer to avoid using in uapi/linux/ptrace.h those types
that are defined in uapi/linux/seccomp.h.


--=20
ldv

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJb9fCyAAoJEAVFT+BVnCUIR/MQAJiLtswHGxTJiT5szLMr+w0i
xrJIC9YutOPbqmk6AJYwu9qnuZnQrrIxbR11pFBBoObd2FXDyio51mgZSG9X1jzl
gumMCzMp0dr5yLyXOtKQGXzu6V35Qii3Nm+WGcfKaoTrFG+TgKj9tv38c14WWKlP
BaU9m6tqzJP8ocSzyi4rsRHpSfz3VlQlhtEYq+CMwFh7eRwQCgrkWn4tsIkk74yM
WFZwOALee1MbkgYpfAd6vy/PbNKgzN2K0RZTb4QCMXEQDLl25Xe+jJxiYiC9Ds+R
ODKLyL+mC+dQRiX1zxW5FORefZo8aRes900ENC5uZNDvEpzKzJ6Vo0udzqvYb12D
9bz3MyaL9CYd/El+WyTT6Sg160G5OPCIz5c+NKYA3tpp1BKz0CNyoX8X3JcG4ppn
FOZDFFlzl7M8uftC8eGj7hlczo9SZzSaHyQXXy7E/StlVw1LJ5higIkCTvF5U88e
wPW1+gQqP/LvEh4JlcI6O0gtDQAgHrPMxN5oipvcYQecwsFnzeH7z8DNvhr+v6+3
XW0Wr16hGrhbEdmyKkobhYeXeMrgTymSo4zeub39eW3SIBE5sBPFlgUVteRifsky
qinwVKlsrfdCIVuftnQpjjU3VSPtAwooZZnRhgVJR99A9idK+R8KEHvM7S7XcpMu
G9ExcYaNb7MbUET5Q+a/
=c4dx
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--

--===============0604242701946963456==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============0604242701946963456==--
