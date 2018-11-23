From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC PATCH v2] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Fri, 23 Nov 2018 07:01:40 +0300
Message-ID: <20181123040139.GB2572@altlinux.org>
References: <20181121165806.07da7c98@akathisia>
 <CALCETrV3TPCkYyhoLLcikXVeF-RdZUuLTCvKReK3Qb9LSS9Csw@mail.gmail.com>
 <20181121235634.GA14146@altlinux.org>
 <CALCETrXea_uRAqw_srW5CWgOzeM=RubaDbjnxZ=cUMy5Zv1TsA@mail.gmail.com>
 <20181122191504.GB27204@altlinux.org>
 <CALCETrXvXzRzoEqwEY_VZ7Vpt-sLwaF+rZPg+y_eG2xyzubXtw@mail.gmail.com>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4901868027629610853=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <CALCETrXvXzRzoEqwEY_VZ7Vpt-sLwaF+rZPg+y_eG2xyzubXtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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


--===============4901868027629610853==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 22, 2018 at 04:19:10PM -0800, Andy Lutomirski wrote:
> On Thu, Nov 22, 2018 at 11:15 AM Dmitry V. Levin <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org> wrote:
> >
> > On Thu, Nov 22, 2018 at 06:55:29AM -0800, Andy Lutomirski wrote:
> > > On Wed, Nov 21, 2018 at 3:56 PM Dmitry V. Levin wrote:
> > > > On Wed, Nov 21, 2018 at 02:56:57PM -0800, Andy Lutomirski wrote:
> > > > > Please cc linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org for future versions.
> > > > >
> > > > > On Wed, Nov 21, 2018 at 7:58 AM Elvira Khabirova wrote:
> > > > > >
> > > > > > struct ptrace_syscall_info {
> > > > > >         __u8 op; /* 0 for entry, 1 for exit */
> > > > >
> > > > > Can you add proper defines, like:
> > > > >
> > > > > #define PTRACE_SYSCALL_ENTRY 0
> > > > > #define PTRACE_SYSCALL_EXIT 1
> > > > > #define PTRACE_SYSCALL_SECCOMP 2
> > > > >
> > > > > and make seccomp work from the start?  I'd rather we don't merge =
an
> > > > > implementation that doesn't work for seccomp and then have to rew=
ork
> > > > > it later.
> > > >
> > > > What's the difference between PTRACE_EVENT_SECCOMP and syscall-entr=
y-stop
> > > > with regards to PTRACE_GET_SYSCALL_INFO request?  At least they hav=
e the
> > > > same entry_info to return.
> > >
> > > I'm not sure there's any material difference.
> >
> > In that case we don't really need PTRACE_SYSCALL_SECCOMP: op field
> > describes the structure inside the union to use, not the ptrace stop.
>=20
> Unless we think the structures might diverge in the future.

If these structures ever diverge, then a seccomp structure will be added
to the union, and a portable userspace code will likely look this way:

#include <linux/ptrace.h>
=2E..
struct ptrace_syscall_info info;
long rc =3D ptrace(PTRACE_GET_SYSCALL_INFO, pid, (void *) sizeof(info), &in=
fo);
=2E..
switch (info.op) {
	case PTRACE_SYSCALL_INFO_ENTRY:
		/* handle info.entry */
	case PTRACE_SYSCALL_INFO_EXIT:
		/* handle info.exit */
#ifdef PTRACE_SYSCALL_INFO_SECCOMP
	case PTRACE_SYSCALL_INFO_SECCOMP:
		/* handle info.seccomp */
#endif
	default:
		/* handle unknown info.op */
}

In other words, it would be better if PTRACE_SYSCALL_INFO_* selector
constants were introduced along with corresponding structures in the
union.


--=20
ldv

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJb93ujAAoJEAVFT+BVnCUI2jsQAIepMxxYXPxMW/R7MJz1eL/2
c5Y/scQkQ/JhQBIk8trAhW6iNwfsVcmVy2JnhkkZ+ZPvsFg1QFTgPMySGWAwlUvo
cHwhy4uGsiQ4gwiZTg1YSleIAQccIsq0+R6+dW2oHu9FuN7S72WfBtNnp+wLHdhH
PsOHpHgfhr6vsUrCOrAzsmMNzhxu8+cgPT04y5dUNCREBrr3uoFKKy/5u7WykLqC
6A8ryanu8QJgM3jQ11N0gp0gds0VSzSDk60n8SHvhxaczqn1SEg40ZKfdQ57d/8F
YBiWm3H5sLCodHYPW2cGpgcqNlTPrSAu1dC+p4rKITi3jdlCw6RUPQQ/vhSghEkE
2ioM+BtE180n7qRL1gMlYTXah34qOvW6FDiFjgp5TmXjbaG3FTn0wC4esCz9bGqJ
MEvYiR6d6a6Ow4cpTL0OF5I1dTfy/HyJZToaiN/iYZ0UQAQamYYn4lx0ZX0NZKWj
KxQXATYMmnR0/6W+uq26VwUs6pE8nNoKe2jR/um2QE/AjZe/zbWikIUrL+3s/dz7
znc4kYzzBIU97vEDSIyElVdH7eUbPDY1+ifNK/U/dAUtHfpcTmVmEt/ToDFAFb+V
v6l1M+u1bGuCr6iL7GXgNHldCfCPFhjsF2QrfU/gAKDiqMkGi15V7/xg11czkQf9
FdOM5gtadWSiVdFuGO1m
=+cWe
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--

--===============4901868027629610853==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============4901868027629610853==--
