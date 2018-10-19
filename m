From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 1/5] orangefs: fix request_mask misuse
Date: Fri, 19 Oct 2018 08:27:05 -0600
Message-ID: <9D62CF17-A2F8-43A2-A054-AF281FD96C13@dilger.ca>
References: <20181019122049.27121-1-mszeredi@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_88902FA3-F33A-4B04-8242-4DAE6FB12E7B";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019122049.27121-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>, Mike Marshall <hubcap@omnibond.com>
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_88902FA3-F33A-4B04-8242-4DAE6FB12E7B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 19, 2018, at 6:20 AM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>=20
> Orangefs only handles STATX_BASIC_STATS in its getattr implementation, =
so
> mask off all other flags.  Not doing so results in statx(2) forcing a
> refresh of cached attributes on any other requested flag (i.e. =
STATX_BTIME
> currently) due to the following test in orangefs_inode_getattr():
>=20
> (request_mask & orangefs_inode->getattr_mask) =3D=3D request_mask
>=20
> Also clean up gratuitous uses of STATX_ALL.
>=20
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Reviewed-by: Martin Brandenburg <martin@omnibond.com>
> Cc: Mike Marshall <hubcap@omnibond.com>
> ---
> fs/orangefs/inode.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index 31932879b716..bd7f15a831dc 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -256,7 +256,8 @@ int orangefs_getattr(const struct path *path, =
struct kstat *stat,
> 		     "orangefs_getattr: called on %pd\n",
> 		     path->dentry);
>=20
> -	ret =3D orangefs_inode_getattr(inode, 0, 0, request_mask);
> +	ret =3D orangefs_inode_getattr(inode, 0, 0,
> +				     request_mask & STATX_BASIC_STATS);

Does it make sense to mask this off at the caller, rather than within
orangefs_inode_getattr()?  Otherwise, orangefs_inode_getattr() will
never see additional stats passed in, even if it is enhanced to return
other values.

Cheers, Andreas






--Apple-Mail=_88902FA3-F33A-4B04-8242-4DAE6FB12E7B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlvJ6boACgkQcqXauRfM
H+BRUA/+KhZhIkycQtUFCDFyXS4zsczmZn2BdFLg687vdfLzgFrQSMAbsJVLYgbe
8pRDYrgDn305iymYbOx323GuEtAqjRUaKOV7viS8ugFFGwgIuB5xTDttcWfW60Ib
VVNhXo+jDvcOjDplUaEI3yEMCohcgTIQiJ0HD7WS8JtbjYc5FWPrJ05Au86I+rtW
pq8Z0rEzF7rzowimnlLPzu6dvMuMisYo3sNI6Ypp1qRwX6m5imzmr6J5dEziVigi
LNrSDiEwR37eXKbQEaMJj0185o6j9Pdh2D3d5I1ha6HG2RGNUy666xXklvBn8uAn
xEKvt54jj4uWgUG+7ASC+C1GrVTUIeHryGYP3PvhRXXwOOC+VxHqVcmZVZbaSVYz
7nlR7VnCqa/pqMeAboB1YpG5CasiqcSj7Id7DFhXOLKuAT9SeaeyWl1hEcr/C+pM
sHJWlB/ByY2E0cTOf9tSITmWkYptq7XKiJ7NygZgalqtxaG4nM7NQX7Pbv8HD8Sr
bro5pm2cPrOARAXP5mrSL/sPg+HPzo0ONH2i0YL/holVk0tiUSlkMQnGcEFFNX+R
uBvybTYKauR75pmn5tvB/LZ30v3RSCAgjfMuFIyopjv5xn0kkQ/X6fhvHmXRqgIl
nPaSS/Urqzin6DUB7G3fdgLOuiy6kcbvm4WQ669YU4gc4Va8chw=
=p4EX
-----END PGP SIGNATURE-----

--Apple-Mail=_88902FA3-F33A-4B04-8242-4DAE6FB12E7B--
