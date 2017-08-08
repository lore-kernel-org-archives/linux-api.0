From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v06 22/36] uapi linux/reiserfs_xattr.h: use
 __kernel_size_t instead of size_t
Date: Wed, 9 Aug 2017 02:17:11 +0300
Message-ID: <20170808231711.GJ10552@altlinux.org>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-23-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/0U0QBNx7JIUZLHm"
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-23-mikko.rapeli@iki.fi>
Sender: reiserfs-devel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, reiserfs-devel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--/0U0QBNx7JIUZLHm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 06, 2017 at 06:44:13PM +0200, Mikko Rapeli wrote:
> Fixes userspace compilation error:
>=20
> error: unknown type name =E2=80=98size_t=E2=80=99
>   size_t length;
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> Cc: reiserfs-devel@vger.kernel.org
> ---
>  include/uapi/linux/reiserfs_xattr.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/linux/reiserfs_xattr.h b/include/uapi/linux/rei=
serfs_xattr.h
> index 38fdd648be21..af52b38ef783 100644
> --- a/include/uapi/linux/reiserfs_xattr.h
> +++ b/include/uapi/linux/reiserfs_xattr.h
> @@ -18,7 +18,7 @@ struct reiserfs_xattr_header {
>  struct reiserfs_security_handle {
>  	const char *name;
>  	void *value;
> -	size_t length;
> +	__kernel_size_t length;
>  };
> =20
>  #endif  /*  _LINUX_REISERFS_XATTR_H  */

I submitted an alternative fix for this bug some time ago, see
http://lkml.kernel.org/r/20170228005328.GA27363@altlinux.org


--=20
ldv

--/0U0QBNx7JIUZLHm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZikZ3AAoJEAVFT+BVnCUISdcQAPb2hLuWAbJoW++i7xw01QYx
masSmEYuuf3xdgTsvZKWe73utlbsUYRgvtlVp6QjuYtA48LSwXb6YaGUstqbIxPM
AaMkSkB07CSw9Dt0YdIpnmROx/lVGZovHxOzbyPB6+kCh0WzUOg1RReGRBvYT3Zo
elNSaV8swzs4Eed7K9oFothjIzmhCHk4LsKsXzC94RaX/wB0wzgDkD/5jek4Vb3a
Jk+TMErEN5GEXX6/QLWqMoLftwWN6t5AdHUz63eal61kY82xppnnwG45HdQbuDsd
LkgIt5HIP3AFC1i+oebGXrCOgsEp5sjjp1Cj2WOi/LxtKrKZ6XGiXaa1lAjjkXhR
pBH38lUn7H6XnCM4vP0oSz7XzYLB4KZeWcG4ABCDc/drO+uWpL0KdGLkQtRCb4x2
jAeNnWbQaSSfOXXXHKspAX/AzTBo75G4jWriP3qzAS2ve6faHQKmwp0W/MnqEt+s
UKoSk4qGOCoTqWH2U5V91+brcqak2zWndBDmzb46qDmv4vViHRBdqV8tyOzeXYRj
iyyAn151eBEEhcA9lP0U1DpCPQHq4zsjNv7Y63OUnxzpKhoGPHRVCAUVYm1jkmD6
VV6Zt9QkKRRVLaDqqBj6RG3DegoMtLa6+zg390EN47F2YjXtQIX9QQC/JUpoWim6
/Q9J+VcAAv2Lph0UiZTm
=lZv8
-----END PGP SIGNATURE-----

--/0U0QBNx7JIUZLHm--
