From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: Documenting ptrace access mode checking
Date: Tue, 21 Jun 2016 22:55:50 +0200
Message-ID: <20160621205550.GA5191@pc.thejh.net>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e335a243-2199-2185-c7b3-fb1c898e9ab4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 21, 2016 at 11:41:16AM +0200, Michael Kerrisk (man-pages) wrote:
> Hi Jann, Stephen, et al.
>=20
> Jann, since you recently committed a patch in this area, and Stephen,
> since you committed 006ebb40d3d much further back in time, I wonder if
> you might help me by reviewing the text below that I propose to add to
> the ptrace(2) man page, in order to document "ptrace access mode=20
> checking" that is performed in various parts of the kernel-user-space
> interface. Of course, I welcome input from anyone else as well.
>=20
> Here's the new ptrace(2) text. Any comments, technical or terminological
> fixes, other improvements, etc. are welcome.

As others have said, I'm surprised about seeing documentation about
kernel-internal constants in manpages - but I think it might be a good
thing to have there, given that people who look at ptrace(2) are likely
to be interested in low-level details.


> [[
>    Ptrace access mode checking
>        Various parts of the kernel-user-space API (not just  ptrace(2)
>        operations), require so-called "ptrace access mode permissions"
>        which are gated  by  Linux  Security  Modules  (LSMs)  such  as
>        SELinux,  Yama,  Smack,  or  the  default  LSM.  Prior to Linux
>        2.6.27, all such checks were of a  single  type.   Since  Linux
>        2.6.27, two access mode levels are distinguished:
>=20
>        PTRACE_MODE_READ
>               For  "read" operations or other operations that are less
>               dangerous, such as: get_robust_list(2); kcmp(2); reading
>               /proc/[pid]/auxv,         /proc/[pid]/environ,        or
>               /proc/[pid]/stat; or readlink(2) of  a  /proc/[pid]/ns/*
>               file.
>=20
>        PTRACE_MODE_ATTACH
>               For  "write"  operations,  or  other operations that are
>               more    dangerous,    such    as:    ptrace    attaching
>               (PTRACE_ATTACH)    to   another   process   or   calling
>               process_vm_writev(2).   (PTRACE_MODE_ATTACH  was  effec=E2=
=80=90
>               tively the default before Linux 2.6.27.)
>=20
>        Since  Linux  4.5, the above access mode checks may be combined

s/may/must/; otherwise __ptrace_may_access() will yell about the kernel
code being broken and deny access.

>        (ORed) with one of the following modifiers:
>=20
>        PTRACE_MODE_FSCREDS
>               Use the caller's filesystem UID  and  GID  (see  creden=E2=
=80=90
>               tials(7)) or effective capabilities for LSM checks.
>=20
>        PTRACE_MODE_REALCREDS
>               Use the caller's real UID and GID or permitted capabili=E2=
=80=90
>               ties for LSM checks.  This was effectively  the  default
>               before Linux 4.5.
>=20
>        Because  combining  one of the credential modifiers with one of
>        the aforementioned access modes is  typical,  some  macros  are
>        defined in the kernel sources for the combinations:
>=20
>        PTRACE_MODE_READ_FSCREDS
>               Defined as PTRACE_MODE_READ | PTRACE_MODE_FSCREDS.
>=20
>        PTRACE_MODE_READ_REALCREDS
>               Defined as PTRACE_MODE_READ | PTRACE_MODE_REALCREDS.
>=20
>        PTRACE_MODE_ATTACH_FSCREDS
>               Defined as PTRACE_MODE_ATTACH | PTRACE_MODE_FSCREDS.
>=20
>        PTRACE_MODE_ATTACH_REALCREDS
>               Defined as PTRACE_MODE_ATTACH | PTRACE_MODE_REALCREDS.
>=20
>        One further modifier can be ORed with the access mode:
>=20
>        PTRACE_MODE_NOAUDIT (since Linux 3.3)
>               Don't audit this access mode check.
>=20
> [I'd quite welcome some text to explain "auditing" here.]
>=20
>        The  algorithm  employed for ptrace access mode checking deter=E2=
=80=90
>        mines whether the calling process is  allowed  to  perform  the
>        corresponding action on the target process, as follows:
>=20
>        1.  If the calling thread and the target thread are in the same
>            thread group, access is always allowed.
>=20
>        2.  If the access mode specifies PTRACE_MODE_FSCREDS, then  for
>            the  check in the next step, employ the caller's filesystem
>            user ID and group ID (see credentials(7));  otherwise  (the
>            access  mode  specifies  PTRACE_MODE_REALCREDS, so) use the
>            caller's real user ID and group ID.

Might want to add a "for historical reasons" or so here.


>        3.  Deny access if neither of the following is true:
>=20
>            =C2=B7 The real, effective, and saved-set user IDs of the targ=
et
>              match  the caller's user ID, and the real, effective, and
>              saved-set group IDs of  the  target  match  the  caller's
>              group ID.
>=20
>            =C2=B7 The caller has the CAP_SYS_PTRACE capability.

Might want to also specify here (like below) that the caller needs to
have the capability relative to the user ns of the target.


>        4.  Deny  access if the target process "dumpable" attribute has
>            a value other than 1 (SUID_DUMP_USER; see the discussion of
>            PR_SET_DUMPABLE  in prctl(2)), and the caller does not have
>            the CAP_SYS_PTRACE capability in the user namespace of  the
>            target process.
>=20
>        5.  The  kernel LSM security_ptrace_access_check() interface is
>            invoked to see if ptrace access is permitted.  The  results
>            depend on the LSM.  The implementation of this interface in
>            the default LSM performs the following steps:

For people who are unaware of how the LSM API works, it might be good to
clarify that the commoncap LSM is *always* invoked; otherwise, it might
give the impression that using another LSM would replace it.
(Also, are there other documents that refer to it as "default LSM"? I
think that that term is slightly confusing.)


>            a) If the access mode  includes  PTRACE_MODE_FSCREDS,  then
>               use the caller's effective capability set in the follow=E2=
=80=90
>               ing  check;  otherwise  (the   access   mode   specifies
>               PTRACE_MODE_REALCREDS,  so)  use  the caller's permitted
>               capability set.
>=20
>            b) Deny access if neither of the following is true:
>=20
>               =C2=B7 The caller's capabilities are a proper superset of t=
he
>                 target process's permitted capabilities.

This also requires the caller and the target to be in the same user
namespace.


>               =C2=B7 The  caller  has  the CAP_SYS_PTRACE capability in t=
he
>                 target process's user namespace.
>=20
>               Note that the default LSM does not  distinguish  between
>               PTRACE_MODE_READ and PTRACE_MODE_ATTACH.
>=20
>        6.  If  access  has  not  been  denied  by any of the preceding
>            steps, then access is allowed.
> ]]
>=20
> There are accompanying changes to various pages that refer to=20
> the new text in ptrace(2), so that, for example, kcmp(2) adds:
>=20
>        Permission  to  employ kcmp() is governed by ptrace access mode
>        PTRACE_MODE_ATTACH_REALCREDS checks against both pid1 and pid2;
>        see ptrace(2).

(Actually, kcmp() just needs READ access - you described that accurately
earlier, but it's wrong here.)


> and proc.5 has additions such as:
>=20
>        /proc/[pid]/auxv (since 2.6.0-test7)
>               ...
>               Permission to access this file is governed by  a  ptrace
>               access    mode   PTRACE_MODE_READ_FSCREDS   check;   see
>               ptrace(2).
>=20
>        /proc/[pid]/cwd
>               ...
>               Permission to dereference  or  read  (readlink(2))  this
>               symbolic  link  is  governed  by  a  ptrace  access mode
>               PTRACE_MODE_READ_FSCREDS check; see ptrace(2).

That sounds great! :)

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXaanWAAoJED4KNFJOeCOo58IP/A5nYKkcC3ondRM+JaVsnHh+
3aFTl9Xb9VjxqB2M/XkULNZ5hEfWLNsQ03L1nZ7GLFu/WdWgBdDsErwxD3jVYfYa
pm4eA7BXqxbd0+frH8A4xYMIK8Gmo5swDNfGWSz3BixN+R8v8WZeOkT6p90zCYSz
+PqMQY6B63v4/iY1TJv1DZSBL8AySyTRrb1gIsGSKbGiWz02+SmONyeZJaB7zWs0
0hSH7ydo3iBjC+3PjrS8jfZSdGz5ZdTUFq1Hiu0bVIazXfNhX7bIF/csCDObMqWy
HIbrUmlqSOsMB6AKzvAB44XznKnWvbKGyeJAmT8NzWt8H6mQ9NT9T4nbJ/NkPBz8
blszxnb88enM10EmzUMoLu370ltNWEYYUb2pqZg6FRt64KsZBtHyn3nozQjBZW8U
8cG/OOosnSPXn3ky8KxMfiSLFeqXounpWkQoABrHj/V9qcOy+o8YrdhvgODNJ8dZ
h09pZnEpPkcq1pMK0i2E/xn80QF7HX/BzP6bDsjxsJqCqQqrw9HzgUHSnBg8+g5z
u1/CM7/mdyiNNFPiZwrTkzuM1tx7MrQynHnvS8f9F8lVUy/QhyxIqg91qzAXrffy
jhlMZc9zKAEIv59Ydx6rgSsrZKT4kzPpkKWRGK1/ElVi5Zece04RyYmS0NXBU7H0
2U7nDZm+71+ZPpZTJhgK
=5dxB
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
