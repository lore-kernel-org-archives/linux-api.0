From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4 1/2] ptrace: save the type of syscall-stop in
 ptrace_message
Date: Fri, 30 Nov 2018 00:10:44 +0300
Message-ID: <20181129211044.GA20529@altlinux.org>
References: <20181128130439.GB28206@altlinux.org>
 <20181128130601.GC28206@altlinux.org>
 <20181128134913.GC30395@redhat.com>
 <20181128140533.GF28206@altlinux.org>
 <20181128142006.GE30395@redhat.com>
 <20181128152346.GG28206@altlinux.org>
 <20181128221125.GA2800@altlinux.org>
 <20181129144742.GB10645@redhat.com>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3785414735189063392=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181129144742.GB10645-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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


--===============3785414735189063392==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2018 at 03:47:43PM +0100, Oleg Nesterov wrote:
> On 11/29, Dmitry V. Levin wrote:
> >
> > 2. Document these values
>=20
> sure, they should be documented and live in include/uapi/,
>=20
> > chosen to avoid collisions with ptrace_message values
> > set by other ptrace events
>=20
> this is what I can't understand. But to clarify, I don't really care and
> won't argue.
>=20
> If an application wants to use PTRACE_GETEVENTMSG to distinguish entry/ex=
it
> (without PTRACE_GET_SYSCALL_INFO) it needs to do wait(status) and check s=
tatus
> anyway, otherwise PTRACE_GETEVENTMSG is simply pointless (wrt syscall ent=
ry/
> exit). So we do not care if PTRACE_EVENTMSG_SYSCALL_ENTRY conflicts with,=
 say,
> SECCOMP_RET_DATA.

Yes, once the application has verified that the kernel implements this
feature, there is no risk of collision.

> > so that PTRACE_GETEVENTMSG users can easily tell
> > whether this new semantics is supported by the kernel or not.
>=20
> Yes. And how much this can help? Again, an application can trivially dete=
ct
> if this feature implemented or not, and it should do this anyway if it wa=
nts
> to (try to) use PTRACE_EVENTMSG_SYSCALL_ENTRY/EXIT ?

How an application can easily detect whether this feature is implemented?
By invoking PTRACE_GETEVENTMSG after the first syscall stop reported by
wait and checking whether the returned value is either
PTRACE_EVENTMSG_SYSCALL_ENTRY or PTRACE_EVENTMSG_SYSCALL_EXIT.

So the question is, how can this value be equal to one of these constants
when this feature is not implemented?  Can a value saved to ptrace_message
earlier by one of ptrace events be equal to one of these constants?

Imagine an application attaches to already existing process, enables
PTRACE_O_TRACESECCOMP, and a PTRACE_EVENT_SECCOMP arrives with
ptrace_message set to 1.  If this application then exits and a new invocati=
on
of the same application attaches to the same process, it will very likely s=
ee
this 1 returned by PTRACE_GETEVENTMSG if the feature is not implemented
in the kernel.

To avoid that kind of collisions, kernel should use different ptrace_message
values for syscall stops.

> Again, I won't reallly argue. But if you insist that these values must
> be unique then you probably need to add
>=20
> 	BUILD_BUG_ON(PTRACE_EVENTMSG_SYSCALL_ENTRY <=3D PID_MAX_LIMIT);

Yes, it's a good idea.  What is the proper place for this check?


--=20
ldv

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJcAFXTAAoJEAVFT+BVnCUIq0EP/iPv5CJspwW70RTZ8yEMA722
hBqt/Nr57H6ry+3rj41yT5z7uoDkeKRvupl/gsShs0cnTUzGJxVT3sTdraf1tvC4
XF4lhCP5qJCBBllgohfFTFoxutALmVmuW1yr6xxhIBH+d3XC2eq4oOQnr/sPYFk4
dL7mvqSs78W6w3m3/od1l0cOnjxBGXKJZBR6xw5XousawvCR6cI8xX2wEWW/QFRo
WE8eDeXFJ0c85RfAWIztAcHi7JjxsSdEJXzl2s3Oz33kZR9GWmiF2ZburlENr5zR
QovCw2pv3KjNg/ijcim2trDTV4ij5LoSLMXnNXuWAqA38guQLAm5E9Wp+vLrb7xb
IRxIcT6K70l6ovcgzQBSOkxUzaQrTgBPua2hXXfC9yf8ls/pSI5VDCsEAX7DVRpn
zOphlMBbXtLopeQk9gHKG1TVluTHKAbu6D7+dPlTIOKwM2EMEBqVw07FQ1oToGK8
yWR11PvsmAa0RxjZHwOLQ00xfxaCbX6Wlk7OnNCVlR+ORS1BdW14tb7Hi0jJyG96
Eo3SqXVE3hMHFAZpPa4mO9q7RcN+O6UCRTVRii13X3Y0LClsCt1HqMXDT/9pHWJx
j15cFYcT8EwyP2TTu0fOS+g+sY1G000DNXNB6KQZh4518TH+VIGeZnOjwHpdk6Up
WW/+LWj82BIPeOgjAMDC
=dQ4k
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--

--===============3785414735189063392==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============3785414735189063392==--
