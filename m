From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v4 1/2] ptrace: save the type of syscall-stop in
 ptrace_message
Date: Wed, 28 Nov 2018 17:05:34 +0300
Message-ID: <20181128140533.GF28206@altlinux.org>
References: <20181128130439.GB28206@altlinux.org>
 <20181128130601.GC28206@altlinux.org>
 <20181128134913.GC30395@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128134913.GC30395@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Michael Ellerman <mpe@ellerman.id.au>, Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromyatnikov <esyr@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2018 at 02:49:14PM +0100, Oleg Nesterov wrote:
> On 11/28, Dmitry V. Levin wrote:
> >
> > +/*
> > + * These values are stored in task->ptrace_message by tracehook_report=
_syscall_*
> > + * to describe current syscall-stop.
> > + *
> > + * Values for these constants are chosen so that they do not appear
> > + * in task->ptrace_message by other means.
> > + */
> > +#define PTRACE_EVENTMSG_SYSCALL_ENTRY	0x80000000U
> > +#define PTRACE_EVENTMSG_SYSCALL_EXIT	0x90000000U
>=20
> Again, I do not really understand the comment... Why should we care about
> "do not appear in task->ptrace_message by other means" ?
>=20
> 2/2 should detect ptrace_report_syscall() case correctly, so we can use a=
ny
> numbers, say, 1 and 2?
>=20
> If debugger does PTRACE_GETEVENTMSG it should know how to interpet the va=
lue
> anyway after wait(status).

Given that without this patch the value returned by PTRACE_GETEVENTMSG
during syscall stop is undefined, we need two different ptrace_message
values that cannot be set by other ptrace events to enable reliable
identification of syscall-enter-stop and syscall-exit-stop in userspace:
if we make PTRACE_GETEVENTMSG return 0 or any other value routinely set by
other ptrace events, it would be hard for userspace to find out whether
the kernel implements new semantics or not.


--=20
ldv

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJb/qCtAAoJEAVFT+BVnCUIEhwQAKJdFyub/g1MiChePC6/doKw
3R41RLr2rNHq7EMe4G3u/ZLFX1RXgPV8mXXBozZHlJAK8R8a79FISLxfgyyYaMK6
z+nZSMt3U3ywttpZ7Td3A58WdSeAcKQZCHKcjfoaOCujCl7J1WO2ZbNZ1hHO5UWA
725bJbs8JAn0Q3SHKhCGZg46ROBaMpuBwGhibG783JvWIP9Wnj04DhMiusnyG3Vn
nS2+lGYJbFV3djf/QRsunhq+qdfgxRiFmUxxEMUbl9vMTd+JWP8PNo8gSdLmanwt
6TZr/2NwtJECwM6EZ/ly4URA7g/UFJbO4eYjTLLQ1nMzsryILOD4MTasp4KC7obU
mgXHajuCEPGeyKzm1uCx+88MK6eYJcpDVHj1ZlRG9wVZyk4I7d12FH09ZIaGPE6O
EpGBx9V5SqPug2hHt4hxImsY6gc+Q0tiZ2+Y41mcMiEqwxXAbItsEzeaC0v3imBg
6MSEV0DKR27QHPKSxKAfYmYDX2FTf7G/2Z8ou9iek2l5ksgoMGWnaf0oz4IS7F4s
HTTPi2hbUFo5jGJ2NtDWJ1mPMTL+IC/e8HZBn2VXwDkyH9i1F2AHEGvr2LEHYkTK
e75UUbQHuHSvoZIYegJUNDCh1DySjd0I4KJgvOHIfpO1CrkxvQGf+yo7hPt1mvWy
4n28NTgun7bbHxWzaa1w
=ABO2
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
