From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: Review of ptrace Yama ptrace_scope description
Date: Tue, 28 Jun 2016 22:50:07 +0200
Message-ID: <20160628205007.GA1419@pc.thejh.net>
References: <a80772d7-f52a-0943-de24-a0cf8d6b2f7c@gmail.com>
 <20160625143006.GA24730@pc.thejh.net>
 <0017835d-c672-02fe-dab8-d1b11c100c24@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0017835d-c672-02fe-dab8-d1b11c100c24-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2016 at 08:11:36AM +0200, Michael Kerrisk (man-pages) wrote:
> Hi Jann,
>=20
> On 06/25/2016 04:30 PM, Jann Horn wrote:
> >On Sat, Jun 25, 2016 at 09:30:43AM +0200, Michael Kerrisk (man-pages) wr=
ote:
> >>Hi Kees,
> >>
> >>So, last year, I added some documentation to ptrace(2) to describe
> >>the Yama ptrace_scope file. I don't think I asked you for review
> >>at the time, but in the light of other changes to the ptrace(2)
> >>page, it occurred to me that it might be a good idea to ask you
> >>to check the text below to see if anything is missing or could be
> >>improved. Might you have a moment for that?
> >>
> >>   /proc/sys/kernel/yama/ptrace_scope
> >>       On systems with the Yama Linux Security Module (LSM)  installed
> >>       (i.e.,  the  kernel  was configured with CONFIG_SECURITY_YAMA),
> >>       the /proc/sys/kernel/yama/ptrace_scope  file  (available  since
> >>       Linux  3.4)  can  be  used  to  restrict the ability to trace a
> >>       process with ptrace(2) (and thus also the ability to use  tools
> >>       such  as  strace(1) and gdb(1)).  The goal of such restrictions
> >>       is to prevent attack escalation whereby a  compromised  process
> >>       can  ptrace-attach  to  other  sensitive processes (e.g., a GPG
> >>       agent or an SSH session) owned by the user  in  order  to  gain
> >>       additional credentials and thus expand the scope of the attack.
> >>
> >>       More precisely, the Yama LSM limits two types of operations:
> >>
> >>       *  Any   operation   that   performs   a   ptrace  access  mode
> >>          PTRACE_MODE_ATTACH     check=E2=80=94for      example,      p=
trace()
> >>          PTRACE_ATTACH.   (See the "Ptrace access mode checking" dis=
=E2=80=90
> >>          cussion above.)
> >>
> >>       *  ptrace() PTRACE_TRACEME.
> >>
> >>       A process that has the CAP_SYS_PTRACE capability can update the
> >>       /proc/sys/kernel/yama/ptrace_scope file with one of the follow=
=E2=80=90
> >>       ing values:
> >>
> >>       0 ("classic ptrace permissions")
> >>              No additional restrictions on  operations  that  perform
> >>              PTRACE_MODE_ATTACH  checks  (beyond those imposed by the
> >>              commoncap and other LSMs).
> >>
> >>              The use of PTRACE_TRACEME is unchanged.
> >>
> >>       1 ("restricted ptrace") [default value]
> >>              When   performing   an   operation   that   requires   a
> >>              PTRACE_MODE_ATTACH  check, the calling process must have
> >>              a predefined relationship with the target  process.   By
> >>              default,  the predefined relationship is that the target
> >>              process must be a child of the caller.
> >>
> >>              A target process can employ the prctl(2)  PR_SET_PTRACER
> >>              operation  to declare a different PID that is allowed to
> >>              perform PTRACE_MODE_ATTACH  operations  on  the  target.
> >>              See   the   kernel   source   file   Documentation/secu=
=E2=80=90
> >>              rity/Yama.txt for further details.
> >>
> >>              The use of PTRACE_TRACEME is unchanged.
> >
> >(namespaced) CAP_SYS_PTRACE is also sufficient here.
> >
> >
> >Both here and in the "admin-only attach" case, it is IMO important to
> >note that creating a user namespace effectively removes the Yama
> >protection because the owner of a namespace, when accessing its
> >contents from outside, is relatively capable.
> >
> >This means that when a process tries to use namespaces to sandbox
> >itself, it inadvertently makes itself more accessible.
> >
> >(This could probably be worked around in the kernel, but such a
> >workaround would likely not be default, but rather opt-in via a new
> >flag for clone() and unshare() or so.)
>=20
> Tanks for catching this!
>=20
> So I've made that section of text:
>=20
>        A  process  that  has the CAP_SYS_PTRACE capability can update the
>        /proc/sys/kernel/yama/ptrace_scope file with one of the  following
>        values:
>=20
>        0 ("classic ptrace permissions")
>               No  additional  restrictions  on  operations  that  perform
>               PTRACE_MODE_ATTACH checks (beyond those imposed by the com=
=E2=80=90
>               moncap and other LSMs).
>=20
>               The use of PTRACE_TRACEME is unchanged.
>=20
>        1 ("restricted ptrace") [default value]
>               When    performing    an    operation   that   requires   a
>               PTRACE_MODE_ATTACH check, the calling process  must  either
>               have the CAP_SYS_PTRACE capability in the user namespace of
>               the target process or it  have  a  predefined  relationship
>               with  the target process.

Nit: The grammar in this sentence seems wrong to me.
s/or it have/or it must have/?

> 		By default, the predefined rela=E2=80=90
>               tionship is that the target process must be a child of  the
>               caller.
>=20
>               A  target  process  can  employ the prctl(2) PR_SET_PTRACER
>               operation to declare a different PID  that  is  allowed  to
>               perform  PTRACE_MODE_ATTACH  operations on the target.  See
>               the kernel source file Documentation/security/Yama.txt  for
>               further details.
>=20
>               The use of PTRACE_TRACEME is unchanged.
>=20
>        2 ("admin-only attach")
>               Only  processes  with  the CAP_SYS_PTRACE capability in the
>               user  namespace  of  the   target   process   may   perform
>               PTRACE_MODE_ATTACH operations or trace children that employ
>               PTRACE_TRACEME.
>=20
>        3 ("no attach")
>               No process may  perform  PTRACE_MODE_ATTACH  operations  or
>               trace children that employ PTRACE_TRACEME.
>=20
>               Once  this value has been written to the file, it cannot be
>               changed.
>=20
>        With respect to values 1 and 2, note that creating a  user  names=
=E2=80=90
>        pace effectively removes the Yama protection, because the owner of
>        a  namespace,  when  accessing  its  members  from  outside,   has
>        CAP_SYS_PTRACE  within  the  namespace.   This  means  that when a
>        process tries to use namespaces to  sandbox  itself,  it  inadver=
=E2=80=90
>        tently weakens the protections offered by the Yama LSM.
>=20
>=20
> Okay?

Sounds good to me. Kees?

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXcuL/AAoJED4KNFJOeCOoqYYP/iCowWOltgeee2dnWBSUrKsU
a+wUjAb54+I1jvyP26CuzYYdBFvZIMRBg/krZeWVYDBJgHpXEnLTv+hIm4q+k/iN
Lm7AFrLcr/U8fwB+dL+9BB6jSPBT7tu68ZqS6eceWGfbWHRxCJyFxUhL/S1/Tosd
m52xxOcBJFKXZJAMlW7NArYzad6C+ndOUtQsufSu2kRFZVlIdRNftYN5d4CpIJJg
oKFYC2yk603Au1NSfADcIvqNm2FP+CHCy6EG0fSOwzxxWgluVX7Qww60VzKa/Yo+
vq66pPpsyjpqoKjoXBBGPibierXUB/uS50I5zFyeJkuVkZUryOL6xEO2cBPgzvUe
MPdxW9FfSLpNUJbNOoZoS3ZFCSNZi5IlThN7yDW81mYKE2YRO4/s2Yi4JXeviDK8
qyir7J3FWK0iQXmnjvEGBGdfIfdJDesP2DsWStcDJR3/k8mpuXZjdTNMrhKSTfKX
rIXTwm6DB+EUA1htxI4Az9sv3hjr26m0ZBTQL+sHekikuA4r4nTVFok8WpKPAvdu
c6cZLnwemsoshEuA8XZBsxtkc6yxKBtD1AieBedf6fG8KkUyxJPE6g4EYPlZNyVJ
18Qg5bjAXK2yivrJ3Vxc8+zF4j6SUWmbSyb7qhCQC5O4j75VtCTAG9NdL6YUKII+
JpT62B3A24CWZmz2AzOe
=xpCd
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
