From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 09/10] add RWF_DSYNC aand RWF_SYNC
Date: Tue, 29 Mar 2016 13:34:50 -0600
Message-ID: <53D41BC3-65A3-48BB-B2CC-540EBF86A2EC@dilger.ca>
References: <1459273054-13478-1-git-send-email-hch@lst.de> <1459273054-13478-10-git-send-email-hch@lst.de>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2652760C-605D-40E6-A914-3CC5046328F9"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459273054-13478-10-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_2652760C-605D-40E6-A914-3CC5046328F9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 29, 2016, at 11:37 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>=20
> This is the per-I/O equivalent of O_DSYNC and O_SYNC, and very useful =
for
> all kinds of file servers and storage targets.
>=20
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
> fs/read_write.c         | 6 +++++-
> include/uapi/linux/fs.h | 2 ++
> 2 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/read_write.c b/fs/read_write.c
> index cf377cf..3729d8d 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -698,12 +698,16 @@ static ssize_t do_iter_readv_writev(struct file =
*filp, struct iov_iter *iter,
> 	struct kiocb kiocb;
> 	ssize_t ret;
>=20
> -	if (flags & ~RWF_HIPRI)
> +	if (flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))
> 		return -EOPNOTSUPP;
>=20
> 	init_sync_kiocb(&kiocb, filp);
> 	if (flags & RWF_HIPRI)
> 		kiocb.ki_flags |=3D IOCB_HIPRI;
> +	if (flags & RWF_DSYNC)
> +		kiocb.ki_flags |=3D IOCB_DSYNC;
> +	if (flags & RWF_SYNC)
> +		kiocb.ki_flags |=3D (IOCB_DSYNC | IOCB_SYNC);
> 	kiocb.ki_pos =3D *ppos;
>=20
> 	ret =3D fn(&kiocb, iter);
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index a079d50..7f067fe 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -324,5 +324,7 @@ struct fscrypt_policy {
>=20
> /* flags for preadv2/pwritev2: */
> #define RWF_HIPRI			0x00000001 /* high priority =
request, poll if possible */
> +#define RWF_DSYNC			0x00000002 /* per-IO O_DSYNC */
> +#define RWF_SYNC			0x00000002 /* per-IO O_SYNC */

Is it right that both of these flags are defined as "2"?  =46rom the =
code
they look like they should be different values.

Cheers, Andreas






--Apple-Mail=_2652760C-605D-40E6-A914-3CC5046328F9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVvrY2nKl2rkXzB/gAQhsLQ/9F803zuNcf3Ax9hSvbBIZ9Mph+a9L3rTu
mJKYM+y1kzrSosHzNovKPMWkwFt/diqaIPQLj7EjJY78HfgZuhqXSiumryFCcP4V
asCYAJLYX1t//lc4qmhD/iQpe8SgDnU89NQYu4vT27qDByf3Pt+IOTJYXOyYtsQW
80oCI4c62isOLCnG3M5mT309fg6DhBESV784Pwgb4NkCcArG5drOo3e8UP7t4+7E
qopWTTFWHqylKeWRiTxcRK+9iv9HGTEjQBGfJV7Fxb3zK70Bhz3v567SlpnpE+Pl
AWupL40pA5766xoS7v+beMXCfmnpUyIa0K+tKyQLjWCKArvBvmWlQ968SeIQ1nxO
rM57Xq+7M3O4q3ZqqcX/+G+B0LSgIVKLoZJ87wtugyiQVyRIAVliftPCc5wCqqpz
49RcAG2zB+Aq5TNtaBqPRZ92smoMhIl9icKBwn0BaWBelo0mASOKZpw8k34XSGjm
tnb+vdDWEfFncB+CdablFkEcC0VIXW/4Asj03ZGJbPpvnTDheduAjOaibEqJRkh3
upgjhed0/m+JyOI2ZB4AIpqtcmqHIGCxtEiky6KE3V7913/S6+3wwU5QMcfSDgMN
zKwYc0Xe4abZwLnzgDm1YhbVySA9GCcqOOkzhs7tW+ZzLGlstDDlXn9PSjytSgks
KYBiZkgjJDA=
=lJNI
-----END PGP SIGNATURE-----

--Apple-Mail=_2652760C-605D-40E6-A914-3CC5046328F9--
