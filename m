From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v06 19/36] uapi linux/omapfb.h: use __kernel_size_t
 instead of size_t
Date: Wed, 9 Aug 2017 02:11:58 +0300
Message-ID: <20170808231158.GH10552@altlinux.org>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-20-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6lXr1rPCNTf1w0X8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-20-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-omap@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>
List-Id: linux-api@vger.kernel.org


--6lXr1rPCNTf1w0X8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 06, 2017 at 06:44:10PM +0200, Mikko Rapeli wrote:
> Fixes userspace compilation error:
>=20
> error: unknown type name =E2=80=98size_t=E2=80=99
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> Cc: linux-omap@vger.kernel.org
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
> ---
>  include/uapi/linux/omapfb.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/linux/omapfb.h b/include/uapi/linux/omapfb.h
> index 7c97bc00ac6d..b637a924618f 100644
> --- a/include/uapi/linux/omapfb.h
> +++ b/include/uapi/linux/omapfb.h
> @@ -181,7 +181,7 @@ struct omapfb_memory_read {
>  	__u16 y;
>  	__u16 w;
>  	__u16 h;
> -	size_t buffer_size;
> +	__kernel_size_t buffer_size;
>  	void __user *buffer;
>  };

You generally cannot replace size_t with __kernel_size_t in a header that
affects x32, but this case is really bad one: the kernel treats
struct omapfb_memory_read.buffer_size as __kernel_size_t, while
x32 userspace treats it as size_t.  As result, the offset of
struct omapfb_memory_read.buffer on x32 is different between the kernel
and userspace.

In other words, the whole thing seems to be totally broken on x32 already
and it's not important whether you use __kernel_size_t or
__kernel_uapi_size_t as a type of struct omapfb_memory_read.buffer_size.

This deserves a word in the commit message, though.


--=20
ldv

--6lXr1rPCNTf1w0X8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZikU+AAoJEAVFT+BVnCUI/MUQAIxLaUcxieTdqI2PjFLjEEXY
SCzgrtplrDXoOXhbh7H8B2N63Jtf7zQNyUveyKaWNX8jyzH3GpCDCrh8JOy39bGk
nrrhOVCo9fo4ryc6jtyoZm6c6BapzvrxP6POvgliFvnjXmjJJn0JysHGDEf/eEtG
rY5Xn9PIB4dSgVJ3VlzeihkCotSFhZMN78PFExwsP0vzJaCO3hGOxACTJ4J9+gp+
7nOmN9G4vYQDoNDhJ1SdXWH9Ar8Wn1R2jTYmGyj2YIZp+jKdvW+f8eRFmIWnablA
EG3UFovXXA+Ax1LgWcCJ5DlyqeeQE+34IT3YDubNwDjjy6n6vs1Hv4ipHe2id35d
zc07SDGSxTwJCV0vZoO0UEQYRv20yQ8E5auuYP0h47fNyzuJF9UX7Ai97X3k7RQa
KoqdlPIW0Xg5CIyVYBfqZ2mGZukYXmzcM5F622/0vJ5q+8yUFMACpR9EuX2CW3TY
2kHxpp2GVDVNHNmlVD/VDimqB7qZdQQE+fWPATxkuYJpGD23b1Z6UcvmurxH0gS7
0wZf2jRtr1tlFIpVDZOJMIaQHD5keerx4C5VZPkJx0mn9IBs3AmKmAGL/01JA8OU
57gTj7hrHym9JlBVrsWEfmWQhEOrHch1pXqLLwuPr+lVpuj3ZOP9RzKHuL39/uNj
cREUz55q+f9RZc+WuqLq
=O5MJ
-----END PGP SIGNATURE-----

--6lXr1rPCNTf1w0X8--
