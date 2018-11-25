From: Joey Pabalinas <joeypabalinas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Re: [PATCH RESEND v3 1/3] ptrace: pass type of a syscall-stop in
 ptrace_message
Date: Sat, 24 Nov 2018 20:17:26 -1000
Message-ID: <20181125061726.jtalb5t4tgigzzue@gmail.com>
References: <20181125022150.46258a20@akathisia>
 <20181125022227.55e8caf7@akathisia>
 <20181125015402.glcaw3kghcu4pr22@gmail.com>
 <20181125021059.GA1190@altlinux.org>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1708076510611580316=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181125021059.GA1190-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Cc: Joey Pabalinas <joeypabalinas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Eugene Syromyatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--===============1708076510611580316==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4ktpenoxjmibnb6h"
Content-Disposition: inline


--4ktpenoxjmibnb6h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 25, 2018 at 05:10:59AM +0300, Dmitry V. Levin wrote:
> Given that without this patch the value returned by PTRACE_GETEVENTMSG
> during syscall stop is undefined, we need two different ptrace_message
> values that cannot be set by other ptrace events to enable reliable
> identification of syscall-enter-stop and syscall-exit-stop in userspace:
> if we make PTRACE_GETEVENTMSG return 0 or any other value routinely set by
> other ptrace events, it would be hard for userspace to find out whether
> the kernel implements new semantics or not.

Ah, I see, I agree that definitely makes sense.

--=20
Cheers,
Joey Pabalinas

--4ktpenoxjmibnb6h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEENpTlWU2hUK/KMvHp2rGdfm9DtVIFAlv6PnUACgkQ2rGdfm9D
tVLTKBAAwZqcHYLXU10sq1ZI/dIsYmjVmsCSC7bhuxjAi3cVnkw89BqlbTBfl8s5
bJcVhmPayYWCWE2paglX31lp1DKKtvWiFkbLE2jF601rAYekH69ty5Qvx8DMcrQV
Ar2rnb8KECJE7pf9Fdexpx+FyhaM6wkj04YkysMOSEBbBA5ue4pSA5yIkO142jqw
WRlqYBwYqGkNXWW74Ea8ZNEFPZxMrvBtI2olwqEs99erNGpTcafuchTAhdrKuDKZ
62zQEnD229IDXeLZV5+rbbyT7UiWb2xuw/xcOreCRhd8EArxgvFc5VcuywHTI6DM
nPhWsvw7+XUXHpq406m5mLMq1TJMUwrCw+wQjfmaLvehOm+p16z9F3nsjAvUU/ez
bGbTpgv/315EVtm8nqWl1s6pbBgK9cxnIl1DFmKptWbIl96FlSTCo1cOS4fRUNUC
1pgAUh2sVTxuTdARAmTkfKOmj1WoVnVJ+qke+0j/Knye9poolvZngb0PgaKdEwps
i3Wq3OSv7OUGjwIPlYy3oAblfZpC4mhDe9uV+ytzGWfqJoY4hcyXAVOL6rXHx9ih
XxnxIMd/vpKyc882gzKZ3wc6JOMl2QdJ2nPwb9OeK6qls3csaCHWa9ty4+tnUitk
nbN53QvbmBiGDHJjTa6Tj9Lu40Buguhoipqu38ynV18XuUrKKQQ=
=yO6t
-----END PGP SIGNATURE-----

--4ktpenoxjmibnb6h--

--===============1708076510611580316==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============1708076510611580316==--
