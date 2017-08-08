From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v06 21/36] uapi linux/kexec.h: use __kernel_size_t
 instead of size_t
Date: Wed, 9 Aug 2017 02:15:43 +0300
Message-ID: <20170808231543.GI10552@altlinux.org>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-22-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EdRE1UL8d3mMOE6m"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-22-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kexec@lists.infradead.org, Eric Biederman <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org


--EdRE1UL8d3mMOE6m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 06, 2017 at 06:44:12PM +0200, Mikko Rapeli wrote:
> Fixes userspace compilation error:
>=20
> error: unknown type name =E2=80=98size_t=E2=80=99
>   size_t bufsz;
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> Cc: kexec@lists.infradead.org
> Cc: Eric Biederman <ebiederm@xmission.com>
> ---
>  include/uapi/linux/kexec.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
> index aae5ebf2022b..f964d83b2757 100644
> --- a/include/uapi/linux/kexec.h
> +++ b/include/uapi/linux/kexec.h
> @@ -51,9 +51,9 @@
>   */
>  struct kexec_segment {
>  	const void *buf;
> -	size_t bufsz;
> +	__kernel_size_t bufsz;
>  	const void *mem;
> -	size_t memsz;
> +	__kernel_size_t memsz;

No, this is definitely wrong as it breaks x32.
I submitted an alternative fix some time ago, see
http://lkml.kernel.org/r/20170222224646.GC14311@altlinux.org


--=20
ldv

--EdRE1UL8d3mMOE6m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZikYfAAoJEAVFT+BVnCUIbJEQAJPIhObJR8FtF+0auQcqWs5d
IFJ4kWNvoV6E0t7HtyUIdPbZB8qp/VIyhqr7dT500N+7bveKxo/vDRu3MyxtrJLA
NjxZU32MZxknpUSBkXvYYQA/wOz+t76BF+88OWwP+mb29gXa7vMqkKOTcaWA6oaZ
n58xrbs0wfbHnVAcu2gBrcJY4Cib7648Q6Oen3qyQ11zjv2yU80jlQYURzosaU/j
v7YphGBj0cwYCzb2Uyg+VfL5Vr/zPFV9uwaNb+tKNhyjZnE7Kn6LXi9rS+DB/y3C
87Ryd6zYjldeGfbTr/sQitWDwE+8CVM2qLMH92q4QbFnP3S5n9zyIGyiP1gZVJGr
RcNjFcXTOsO4wGo2hgBS4tqZn+0kRI5ueSYvs4QHgtwq3Mqo19//Gkh8VLoeb6uI
3s8vBFMLDzuhlI1X4Rm6jLp8Rg91+KBTpyXVwY8YNYH/iiKJeJ/1PKpFH7FUsenR
FrKp1KpcNwIhlcc9ryeR3xrRWMAoIEZUel92M0HWntzD8XHA0j9PjZ17N9AyVvxV
fErdbapH26098JgkOFngphKV+lSEM0rIy1wugZB/G1xBJhwD4DwtEyn8y+6P0x2M
uYvhJbYYMn/KfMWDwCPMIDSEyyb5WQkNchnb8I8OWuQn0mEToXsic1g6d8Q2f7sx
9DKlCqV9yH+IC5RKeBws
=gP8P
-----END PGP SIGNATURE-----

--EdRE1UL8d3mMOE6m--
