From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/2] mm, doc: cleanup and clarify munmap behavior for
 hugetlb memory
Date: Fri, 27 Mar 2015 09:58:47 -0400
Message-ID: <20150327135847.GB10747@akamai.com>
References: <alpine.DEB.2.10.1503261621570.20009@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1503261621570.20009-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joern Engel <joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org>, Jianguo Wu <wujianguo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Mar 2015, David Rientjes wrote:

> munmap(2) of hugetlb memory requires a length that is hugepage aligned,
> otherwise it may fail.  Add this to the documentation.
>=20
> This also cleans up the documentation and separates it into logical
> units: one part refers to MAP_HUGETLB and another part refers to
> requirements for shared memory segments.
>=20
> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---

If this is the route we are going to take, this behavoir needs to be
called out prominently in the mmap/munmap man page.


>  Documentation/vm/hugetlbpage.txt | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>=20
> diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbp=
age.txt
> --- a/Documentation/vm/hugetlbpage.txt
> +++ b/Documentation/vm/hugetlbpage.txt
> @@ -289,15 +289,20 @@ file systems, write system calls are not.
>  Regular chown, chgrp, and chmod commands (with right permissions) could =
be
>  used to change the file attributes on hugetlbfs.
> =20
> -Also, it is important to note that no such mount command is required if =
the
> +Also, it is important to note that no such mount command is required if
>  applications are going to use only shmat/shmget system calls or mmap with
> -MAP_HUGETLB.  Users who wish to use hugetlb page via shared memory segme=
nt
> -should be a member of a supplementary group and system admin needs to
> -configure that gid into /proc/sys/vm/hugetlb_shm_group.  It is possible =
for
> -same or different applications to use any combination of mmaps and shm*
> -calls, though the mount of filesystem will be required for using mmap ca=
lls
> -without MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB=
 see
> -map_hugetlb.c.
> +MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB see map=
_hugetlb
> +below.
> +
> +Users who wish to use hugetlb memory via shared memory segment should be=
 a
> +member of a supplementary group and system admin needs to configure that=
 gid
> +into /proc/sys/vm/hugetlb_shm_group.  It is possible for same or differe=
nt
> +applications to use any combination of mmaps and shm* calls, though the =
mount of
> +filesystem will be required for using mmap calls without MAP_HUGETLB.
> +
> +When using munmap(2) to unmap hugetlb memory, the length specified must =
be
> +hugepage aligned, otherwise it will fail with errno set to EINVAL.
> +
> =20
>  Examples
>  =3D=3D=3D=3D=3D=3D=3D=3D
>=20
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=3Dmailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVFWIXAAoJELbVsDOpoOa9JnAP/j6Rz7l6Od6nv+u/4fBho3Nq
CKvxicBLgsD8ZLJ7Sp9TuJE9aLGMntRY+JylQFAW+YzVbHGW6rlFHepqPyNY2RqT
ITgGv04U0stJYY0RAX6JX5diCzmaIWTaBwBzMAn43wTQSGkGrubo2KrPPNUq8Tof
2oDjIyGO5RuE3/JafG8uhPBwxHDAq8w4d6YjoKkF/aaYSArKq5Jv0QnPEj3osGZu
QKrjyMqHMbBhQzvd9ft27oqThddu9Fyra6WSzp+fTJhav/3KnyLMdj+r9SkRbFjk
WO6CfBSVN8mjOWP8DG0phkYryDJ4aLgkqoUJy5/4f8HspwnFHPYQkEUCcYLjtgzO
V7mc9Gd6xhnVHhEZiaTF4zDo/7YjzIg+DQnQRYsZ9247KRICwFy9/nnCsBjpjodZ
eY9S6bGyHBWYgmxfyzkZtI2UP6o7pUrJJMrzOUUrD893IoXR2VpxJ5GSc3x7qc+h
piA1TgD+4t3bDsYcScQYylQ/hG2eo6LIjYMOuN0QNA7/Cojbro2AY1zQK3rFpGyh
EfRlM3SzlyzC6essdN+0Hr8Au8W51RwhwtPWY0qDazWAtzVVZTChJ1csBKzoR74U
V9v+d4c/BDpFgSTLbIxZKa777N04QUjpZcVyeeBLN+baLWAthMtVt4QJKAsMREkT
39aEgfclx7fwj9Nprzgw
=+UlW
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
