From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4 1/2] ptrace: save the type of syscall-stop in
 ptrace_message
Date: Wed, 28 Nov 2018 18:23:46 +0300
Message-ID: <20181128152346.GG28206@altlinux.org>
References: <20181128130439.GB28206@altlinux.org>
 <20181128130601.GC28206@altlinux.org>
 <20181128134913.GC30395@redhat.com>
 <20181128140533.GF28206@altlinux.org>
 <20181128142006.GE30395@redhat.com>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0669139824845477696=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181128142006.GE30395-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Eugene Syromyatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org


--===============0669139824845477696==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
Content-Disposition: inline


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2018 at 03:20:06PM +0100, Oleg Nesterov wrote:
> On 11/28, Dmitry V. Levin wrote:
> > On Wed, Nov 28, 2018 at 02:49:14PM +0100, Oleg Nesterov wrote:
> > > On 11/28, Dmitry V. Levin wrote:
> > > >
> > > > +/*
> > > > + * These values are stored in task->ptrace_message by tracehook_re=
port_syscall_*
> > > > + * to describe current syscall-stop.
> > > > + *
> > > > + * Values for these constants are chosen so that they do not appear
> > > > + * in task->ptrace_message by other means.
> > > > + */
> > > > +#define PTRACE_EVENTMSG_SYSCALL_ENTRY	0x80000000U
> > > > +#define PTRACE_EVENTMSG_SYSCALL_EXIT	0x90000000U
> > >=20
> > > Again, I do not really understand the comment... Why should we care a=
bout
> > > "do not appear in task->ptrace_message by other means" ?
> > >=20
> > > 2/2 should detect ptrace_report_syscall() case correctly, so we can u=
se any
> > > numbers, say, 1 and 2?
> > >=20
> > > If debugger does PTRACE_GETEVENTMSG it should know how to interpet th=
e value
> > > anyway after wait(status).
> >=20
> > Given that without this patch the value returned by PTRACE_GETEVENTMSG
> > during syscall stop is undefined, we need two different ptrace_message
> > values that cannot be set by other ptrace events to enable reliable
> > identification of syscall-enter-stop and syscall-exit-stop in userspace:
> > if we make PTRACE_GETEVENTMSG return 0 or any other value routinely set=
 by
> > other ptrace events, it would be hard for userspace to find out whether
> > the kernel implements new semantics or not.
>=20
> Hmm, why? Debugger can just do ptrace(PTRACE_GET_SYSCALL_INFO, NULL), if =
it
> returns EIO then it is not implemented?

The debugger that uses PTRACE_GET_SYSCALL_INFO does not need to call
PTRACE_GETEVENTMSG for syscall stops.
My concern here is the PTRACE_GETEVENTMSG interface itself.  If we use
ptrace_message to implement PTRACE_GET_SYSCALL_INFO and expose
PTRACE_EVENTMSG_SYSCALL_{ENTRY,EXIT} for regular PTRACE_GETEVENTMSG users,
it should have clear semantics.


--=20
ldv

--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJb/rMCAAoJEAVFT+BVnCUIgEcP/RcxLjhnkybmCV8dd3Jp12rT
imBkH/MjrC44nXaZTNxoEs5HNRgZcKhuA54TAdpFFhdjfllBNRI7fyiHLjc0rUVx
AWTo1v0IkL0KmYcfV5Caeymp5p8UCpHbeNUrVzRa2BtoU+fDPRAsZ0ABDlNabDEX
Pf2Xt5xx52maOEm/G5Ja7FCdAA4an6si40FPrhFWuQNCSj7yrVx8kNsMV5uxUQ0q
izhhNx0fwO69QjwTaVcjVFYZDh2r+4fCE/dKy2iWS8qulCl0JEVVi/rtdHpfW3X3
Anf1ocMJlzqv7aCJa2q0xWtuBvdhh8/zGeJfa2B3e8davRQ4xjUCwfhpBjRgsejt
XBbkaVuybJltIE8X8kxP0kRxjKoHsmkPiJ0nM4LZUDY3KJhD6lLAN0Dq4oZ71tLp
4nnoHbK3Z3Q7sPiSdjmMPxHk+bA+GF65eY9fOVCJ06WEAWeBXQBbmXJxaz0kODFU
6mKFKpn0UBCxOTsqj4mepGTYMvTjO1qQzm7qTbU3h1nKY//UV25oVFwA2VN4RxlY
KoIfB9DrGB0V7+hMVNwJpcP57doCTJmphIelbHRITa3UvHljhE2xgRsFZw0LOj0V
S9xJ7/7h6EGTMMzyZjZc5h6Wc7blvDWzbdwotw5hWx4RQ70mu/msKmKhmucyTFU0
05kz+92R4JjwqyOhPxUK
=MBSI
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--

--===============0669139824845477696==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============0669139824845477696==--
