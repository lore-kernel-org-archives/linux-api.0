From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4 1/2] ptrace: save the type of syscall-stop in
 ptrace_message
Date: Sat, 1 Dec 2018 01:53:50 +0300
Message-ID: <20181130225350.GA8096@altlinux.org>
References: <20181128130439.GB28206@altlinux.org>
 <20181128130601.GC28206@altlinux.org>
 <20181128134913.GC30395@redhat.com>
 <20181128140533.GF28206@altlinux.org>
 <20181128142006.GE30395@redhat.com>
 <20181128152346.GG28206@altlinux.org>
 <20181128221125.GA2800@altlinux.org>
 <20181129144742.GB10645@redhat.com>
 <20181129211044.GA20529@altlinux.org>
 <20181130112920.GD23670@redhat.com>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4213009212606708014=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181130112920.GD23670-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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


--===============4213009212606708014==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 30, 2018 at 12:29:21PM +0100, Oleg Nesterov wrote:
> On 11/30, Dmitry V. Levin wrote:
> > On Thu, Nov 29, 2018 at 03:47:43PM +0100, Oleg Nesterov wrote:
> >
> > > > so that PTRACE_GETEVENTMSG users can easily tell
> > > > whether this new semantics is supported by the kernel or not.
> > >
> > > Yes. And how much this can help? Again, an application can trivially =
detect
> > > if this feature implemented or not, and it should do this anyway if i=
t wants
> > > to (try to) use PTRACE_EVENTMSG_SYSCALL_ENTRY/EXIT ?
> >
> > How an application can easily detect whether this feature is implemente=
d?
>=20
> As I already said, it can just do ptrace(PTRACE_GET_SYSCALL_INFO, NULL) ?
> If it returns -EIO then this feature is not implemented. Any other error
> code (actually EINVAL or EFAULT) means it is implemented.

Fair enough.
We can change PTRACE_EVENTMSG_SYSCALL_ENTRY/EXIT to 1/2 if you like,
and document this trick somewhere.


--=20
ldv

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJcAb9+AAoJEAVFT+BVnCUI5qYP/jM4uf1ITca2zNNi1qDuHHv+
fk42Rqr2J5XTxa+gxMpVXhR3MvBtq6p3NRcWZ04YoFZlD6RGXVhAOjO/qDL/K64B
c3hgDcFVzAQgW4meGcBP6z4sU4jston0a+UAWaCrO5seC95LU+biBO6RMLlmxepw
0VHvczLcpFz9ikBmmOQs+6wfwtJCj56SVsxRSIscw5pJ845zX6+S6vMq4J1t0smC
k7iOgSiJYyPFIMVuhNWqUiqH7viY2H2JTRqBVNy6yBQvxb/Akfcdm6f1qHeJg3x1
NT8pg9Fxri0zRfZ9MnBSGinA3JeGMuMgZvDs5UweUQ4RRAnQkwfXkkJYMm/CmuXb
7V8kUhUNcDoNrYApwEKa5/j+QaNnDQGEGUlRC8GGs1qQM3dW5G5srUU1y0H6gmBb
Wnc+fuHgiJDdqdqlOZH641d/HRx1KplsJ3zHimEMWWk87zlwRlLtnT9zi+J5TWYn
X2bv/MfqunqUvHb5SmMu1nvMxEb9F32MkgfkdYF2bfiie9sv20FdO+m+pXLj0Jk0
BTzw+GpS0oqelTnAk0ZltSOZMXwlU3iJOsPKMzbVz/SEUKq1NGv3vaG4fDHYLsd0
v8fKde54QnKT9lvqTBop/Y38D4neA+c/SlCX9FdLqloScRr8t+oTtoe9DWgWEsA2
VN7U+Tqw8txlfk7X0ALS
=aZFi
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--

--===============4213009212606708014==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============4213009212606708014==--
