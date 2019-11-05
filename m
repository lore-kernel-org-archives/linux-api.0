From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH 1/1] userfaultfd: require CAP_SYS_PTRACE for
 UFFD_FEATURE_EVENT_FORK
Date: Wed, 6 Nov 2019 02:59:53 +1100
Message-ID: <20191105155953.3i7fvzm76aublkbi@yavin.dot.cyphar.com>
References: <1572967777-8812-1-git-send-email-rppt@linux.ibm.com>
 <1572967777-8812-2-git-send-email-rppt@linux.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j7e2vn3qawbuf4kk"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1572967777-8812-2-git-send-email-rppt@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Pavel Emelyanov <ovzxemul@gmail.com>, Tim Murray <timmurray@google.com>, linux-api@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org


--j7e2vn3qawbuf4kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-05, Mike Rapoport <rppt@linux.ibm.com> wrote:
> Current implementation of UFFD_FEATURE_EVENT_FORK modifies the file
> descriptor table from the read() implementation of uffd, which may have
> security implications for unprivileged use of the userfaultfd.
>=20
> Limit availability of UFFD_FEATURE_EVENT_FORK only for callers that have
> CAP_SYS_PTRACE.
>=20
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  fs/userfaultfd.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index f9fd18670e22..d99d166fd892 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1834,13 +1834,12 @@ static int userfaultfd_api(struct userfaultfd_ctx=
 *ctx,
>  	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
>  		goto out;
>  	features =3D uffdio_api.features;
> -	if (uffdio_api.api !=3D UFFD_API || (features & ~UFFD_API_FEATURES)) {
> -		memset(&uffdio_api, 0, sizeof(uffdio_api));
> -		if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
> -			goto out;
> -		ret =3D -EINVAL;
> -		goto out;
> -	}
> +	ret =3D -EINVAL;
> +	if (uffdio_api.api !=3D UFFD_API || (features & ~UFFD_API_FEATURES))
> +		goto err_out;
> +	ret =3D -EPERM;
> +	if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
> +		goto err_out;
>  	/* report all available features and ioctls to userland */
>  	uffdio_api.features =3D UFFD_API_FEATURES;
>  	uffdio_api.ioctls =3D UFFD_API_IOCTLS;
> @@ -1853,6 +1852,11 @@ static int userfaultfd_api(struct userfaultfd_ctx =
*ctx,
>  	ret =3D 0;
>  out:
>  	return ret;
> +err_out:
> +	memset(&uffdio_api, 0, sizeof(uffdio_api));
> +	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))

Wouldn't it be simpler to do clear_user()?

> +		ret =3D -EFAULT;
> +	goto out;
>  }
> =20
>  static long userfaultfd_ioctl(struct file *file, unsigned cmd,

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--j7e2vn3qawbuf4kk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXcGcdgAKCRCdlLljIbnQ
EtmWAP0U2MY1jEsu7TOdY/A7q911zdaus5bq2247WlYAOn4eWAEAlHxHE9/GMIb9
2Uajs/uTqNYLhx1hpZCCzmPJS/v5YwA=
=BEI+
-----END PGP SIGNATURE-----

--j7e2vn3qawbuf4kk--
