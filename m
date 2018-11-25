From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH RESEND v3 1/3] ptrace: pass type of a syscall-stop in
 ptrace_message
Date: Sun, 25 Nov 2018 05:10:59 +0300
Message-ID: <20181125021059.GA1190@altlinux.org>
References: <20181125022150.46258a20@akathisia>
 <20181125022227.55e8caf7@akathisia>
 <20181125015402.glcaw3kghcu4pr22@gmail.com>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0735442622834471411=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181125015402.glcaw3kghcu4pr22-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: Joey Pabalinas <joeypabalinas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Eugene Syromyatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--===============0735442622834471411==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 24, 2018 at 03:54:02PM -1000, Joey Pabalinas wrote:
> On Sun, Nov 25, 2018 at 02:22:27AM +0100, Elvira Khabirova wrote:
> > Define two constants, PTRACE_EVENTMSG_SYSCALL_ENTRY and
> > PTRACE_EVENTMSG_SYSCALL_EXIT, and place them in ptrace_message
> > for the duration of syscall-stops.
> > This way ptracers can distinguish syscall-enter-stops
> > from syscall-exit-stops using PTRACE_GETEVENTMSG request.
>=20
> Is there an advantage to using two constants instead of a single
> sys_exit bit (set/unset for syscall-exit-stop/syscall-enter-stop)?

Given that without this patch the value returned by PTRACE_GETEVENTMSG
during syscall stop is undefined, we need two different ptrace_message
values that cannot be set by other ptrace events to enable reliable
identification of syscall-enter-stop and syscall-exit-stop in userspace:
if we make PTRACE_GETEVENTMSG return 0 or any other value routinely set by
other ptrace events, it would be hard for userspace to find out whether
the kernel implements new semantics or not.


--=20
ldv

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJb+gSyAAoJEAVFT+BVnCUI7msP/03Hw0MVgHwFtPiI1I454dg7
cG5xi8aZUwHZM/8tWCiAPtk02ttpXDZR+ReQGMmoRdEBsuvdnhTImGHgU08PjNo/
hR+vTW3cB8hajPBQr2o7+lN2sqRaH/cbaBOdLA31bUz5BNJCrDEASUX64AG8hV5i
yk8DeoHLfw9Ub34PtDz3yJWudSc7irQfBGidpiKmskabRNeaZWKumtTUx36jkOg0
oeYrdOVPEawE7nkE9LlmkzUiidZzaj1gd/ObkazJ/NyCPC7GvS4IEzSu59178NlG
SMiui9AMQkX/3g6S4hY3DQrice4fdYyi6NNnBXhjoePUOjlwYTw7BSA0yNAYSoat
mnMEds03GuaF5T7S5Okdny7ywROMjkj3i+kH3qXupszUPyY3tlHRsqerSQ/xfKoY
+lIVYNxrHseIMfIV+3tHP6R4CxYoaUdxSmYcL29un46KUh8E89p3UHEbHivSeHYV
qccEUnjy5FFwYu6TxFLhIBtCcMnNHZK+IEm/PwlX7sac5/5NE3cLBiMG6oYjGRcg
YzXg3p62Rtrpsd9sVsEtB2fg3wDjsPQIsZSDnksVPYOFwsx+fIOJE8zTcKw1eiW+
W7i4enyWZht6MlIzAoaj4VfVqJ4GM5ZKi/vCyGuIApK/AOZHwPHBhlVotrGcXVq6
o4kgKmniuyFHhcF4armo
=SNPL
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--

--===============0735442622834471411==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============0735442622834471411==--
