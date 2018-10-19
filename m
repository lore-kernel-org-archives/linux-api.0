From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/3] statx: add STATX_ATTRIBUTES flag
Date: Thu, 18 Oct 2018 19:48:51 -0600
Message-ID: <73E53F58-4A7C-4561-9914-2927B40AC42D@dilger.ca>
References: <20181018131125.6303-1-mszeredi@redhat.com>
 <20181018131125.6303-3-mszeredi@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_04301E5E-5050-44E0-9024-0BAD36DEC7C5";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018131125.6303-3-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_04301E5E-5050-44E0-9024-0BAD36DEC7C5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 18, 2018, at 7:11 AM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>=20
> FUSE will want to know if stx_attributes is interesting or not, =
because
> there's a non-zero cost of retreiving it.
>=20
> This is more of a "want" flag, since stx_attributes_mask already =
indicates
> whether we "got" stx_attributes or not.  So for now we can just deal =
with
> this flag in the generic code.
>=20
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/stat.c                       | 3 +++
> include/uapi/linux/stat.h       | 1 +
> samples/statx/test-statx.c      | 2 +-
> tools/include/uapi/linux/stat.h | 1 +
> 4 files changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/stat.c b/fs/stat.c
> index 8d297a279991..6bf86d57e2e3 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -535,6 +535,9 @@ cp_statx(const struct kstat *stat, struct statx =
__user *buffer)
> 	tmp.stx_size =3D stat->size;
> 	tmp.stx_blocks =3D stat->blocks;
> 	tmp.stx_attributes_mask =3D stat->attributes_mask;
> +	/* Having anything in attributes_mask means attributes are =
valid. */
> +	if (tmp.stx_attributes_mask)
> +		tmp.stx_mask |=3D STATX_ATTRIBUTES;
> 	tmp.stx_atime.tv_sec =3D stat->atime.tv_sec;
> 	tmp.stx_atime.tv_nsec =3D stat->atime.tv_nsec;
> 	tmp.stx_btime.tv_sec =3D stat->btime.tv_sec;
> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> index 370f09d92fa6..aef0aba5dfe7 100644
> --- a/include/uapi/linux/stat.h
> +++ b/include/uapi/linux/stat.h
> @@ -148,6 +148,7 @@ struct statx {
> #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks =
*/
> #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the =
normal stat struct */
> #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
> +#define STATX_ATTRIBUTES	0x00001000U	/* Want/got =
stx_attributes */
>=20
> #define STATX__RESERVED		0x80000000U	/* Reserved for =
future struct statx expansion */
>=20
> diff --git a/samples/statx/test-statx.c b/samples/statx/test-statx.c
> index e354048dea3c..deef9a68ff68 100644
> --- a/samples/statx/test-statx.c
> +++ b/samples/statx/test-statx.c
> @@ -211,7 +211,7 @@ int main(int argc, char **argv)
> 	struct statx stx;
> 	int ret, raw =3D 0, atflag =3D AT_SYMLINK_NOFOLLOW;
>=20
> -	unsigned int mask =3D STATX_BASIC_STATS | STATX_BTIME;
> +	unsigned int mask =3D STATX_BASIC_STATS | STATX_BTIME | =
STATX_ATTRIBUTES;
>=20
> 	for (argv++; *argv; argv++) {
> 		if (strcmp(*argv, "-F") =3D=3D 0) {
> diff --git a/tools/include/uapi/linux/stat.h =
b/tools/include/uapi/linux/stat.h
> index 370f09d92fa6..aef0aba5dfe7 100644
> --- a/tools/include/uapi/linux/stat.h
> +++ b/tools/include/uapi/linux/stat.h
> @@ -148,6 +148,7 @@ struct statx {
> #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks =
*/
> #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the =
normal stat struct */
> #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
> +#define STATX_ATTRIBUTES	0x00001000U	/* Want/got =
stx_attributes */
>=20
> #define STATX__RESERVED		0x80000000U	/* Reserved for =
future struct statx expansion */
>=20
> --
> 2.14.3
>=20


Cheers, Andreas






--Apple-Mail=_04301E5E-5050-44E0-9024-0BAD36DEC7C5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlvJOAMACgkQcqXauRfM
H+CGEA//dRmcs6WP6YXW/fyi8nTtTvN6SjwvM86nYXjJP3botYXUp2WsWHOuBLhd
NyBuP/kPIc4F24A8ld2M3GyZ/qUpxrBldkRyDEpCeWMRlQiUhNTfKRGVG4Eqe2Vt
mrHCFnDbPjpfnaSz73HJlYDyVOkMWHFJo8fxeB6jbsz2tUCtWn3v0qquqckKn4EY
PjQZXorihHxkpqcdXQS9NxosOXBA01g9uIdJJ1FYtnooJQqZEa1dS40KB3o8gx6c
Z0Y4MRpkUfospRRqChUd080/emmQ284KQAHyOGm0LItXF8hi9CIXaPprtImFsZid
buaaBx447dB59izkj11FVfqk8PJx+ww939kY51TtHjx2gVSIcz9O+5gCGyxlssXI
cR7rEjqCjsc85aJ00v9vFRxXbSZg3rNyPeersnm02Sp+FQLHOw7gIv33TCTCUMqS
y1AR2IBAYmSxX/mgj5P+a86KyA8tmy7FkjTL6StlciXLgEqtADKmWes8ySb+PUFo
UtKiQDgqoFBrynWsSWNKHgX7R7pdqLtxyDf7itM7XIUrKXuQb6R0zuKI2TifXSbT
sUsMUTpPLHYDbi7+H5UfwPu4zHUquS9+bRX8EFzU2TqWbVloQIEsm+FNzTpbzX6j
cmX7RwO8gBM1RVVmkgfhewwdUH6z1THpE/kpg6D4yPpVOjfNs34=
=Scy1
-----END PGP SIGNATURE-----

--Apple-Mail=_04301E5E-5050-44E0-9024-0BAD36DEC7C5--
