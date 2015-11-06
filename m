From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH v14 04/22] vfs: Make the inode passed to inode_change_ok non-const
Date: Fri, 6 Nov 2015 14:04:07 -0700
Message-ID: <A1B39E8C-4904-48D8-9CE6-2A464A5D476D@dilger.ca>
References: <1446723580-3747-1-git-send-email-agruenba@redhat.com> <1446723580-3747-5-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C50AB9E3-D3AC-4D52-99DF-74EAB42E7D8D"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446723580-3747-5-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_C50AB9E3-D3AC-4D52-99DF-74EAB42E7D8D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Nov 5, 2015, at 4:39 AM, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>=20
> We will need to call iop->permission and iop->get_acl from
> inode_change_ok() for additional permission checks, and both take a
> non-const inode.

Seems unfortunate that those functions cannot themselves be changed to
take a const struct inode, but it doesn't look possible.

Reviewed-by: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>

> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> fs/attr.c          | 2 +-
> include/linux/fs.h | 2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/attr.c b/fs/attr.c
> index 6530ced..328be71 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -28,7 +28,7 @@
>  * Should be called as the first thing in ->setattr implementations,
>  * possibly after taking additional locks.
>  */
> -int inode_change_ok(const struct inode *inode, struct iattr *attr)
> +int inode_change_ok(struct inode *inode, struct iattr *attr)
> {
> 	unsigned int ia_valid =3D attr->ia_valid;
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 402acd7..aab32c8 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2871,7 +2871,7 @@ extern int buffer_migrate_page(struct =
address_space *,
> #define buffer_migrate_page NULL
> #endif
>=20
> -extern int inode_change_ok(const struct inode *, struct iattr *);
> +extern int inode_change_ok(struct inode *, struct iattr *);
> extern int inode_newsize_ok(const struct inode *, loff_t offset);
> extern void setattr_copy(struct inode *inode, const struct iattr =
*attr);
>=20
> --
> 2.5.0
>=20


Cheers, Andreas






--Apple-Mail=_C50AB9E3-D3AC-4D52-99DF-74EAB42E7D8D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVj0Vx3Kl2rkXzB/gAQjYHQ/+L9LDlXVXWGi/GhDrCiBpnUWSkDNUm3a+
Vwxf/j2ZpsEZpgjz/sjgi+c189DNa1ZhpRe6M9kUYIQqofiHfYS+Yx3GpDvyCzUo
qmXtDGSPMRzsOjMNlx9NPoQULPutHRWJcKvHTXypQHGl3qbezEFvbUfP47l0trqQ
xir5U2N4z13p2ipJTq2Y7FstNqOgNU/xiF+BUeFlFDS5S8K6gXQVsAwhOHBpzRMp
A5v60jIbYtP5MmRiKDSbrEQLQte1g4rIlKklWIsjAmTbK98CRc8f3eb4V+DXYzNp
rjoTsY8H2XoJJeYmFe9/+CxVI/ICOoaCSRRZ9aV9hkff1gz2CifXM5kGy4WWO3Md
puhLHUJIUNhmSqWJEsDCJOegOS7XlrnrFLscv4VkCpse7UM9kMtn/ZtJABzQItfk
5DQ4OCoR9u2tXJlyVG8XWHiKzpNYL0ehDeYlIagguHgir0bM5lj4cji3vmoCGDZS
lU5vGydGX6nR8zeaTuPgGULObDEPOEi1jlDcyuSQz9VIhqTfuNgNPoZibZDhSYoH
zb6T3pNiV4peHzRZ1E8Pi/pZ7yVEdtuKQWSP34QyDjspnANm1panb7MtIEo09TIk
GPwEePLgLRlsrnD1bl1BhuZ4eby+yLYJp2c/AZnovrI4d7Wp1IQc4k9LFR5qB0ai
2AwZOWhuDpg=
=SiKg
-----END PGP SIGNATURE-----

--Apple-Mail=_C50AB9E3-D3AC-4D52-99DF-74EAB42E7D8D--
