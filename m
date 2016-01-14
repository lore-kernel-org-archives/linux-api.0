From: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: Re: [PATCH v3 0/2] new control V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME
Date: Thu, 14 Jan 2016 10:05:47 -0500
Message-ID: <1452783947.10009.20.camel@collabora.com>
References: <1452783007-80883-1-git-send-email-wuchengli@chromium.org>
Reply-To: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-IqT+0WtcRMglZYlAmQ6U"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452783007-80883-1-git-send-email-wuchengli-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu-Cheng Li <wuchengli-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, k.debski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ao2-qKGr9MkilAE@public.gmane.org, bparrot-l0cyMroinI0@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jtp.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tiffany.lin-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org


--=-IqT+0WtcRMglZYlAmQ6U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 14 janvier 2016 =C3=A0 22:50 +0800, Wu-Cheng Li a =C3=A9crit=C2=A0=
:
> v3 addressed Hans' comment to remove the name of the control in s5p-
> mfc.
>=20
> Wu-Cheng Li (2):
> =C2=A0 v4l: add V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME.

Hans suggested to name it V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.

regards,
Nicolas

> =C2=A0 s5p-mfc: add the support of V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME.
>=20
> =C2=A0Documentation/DocBook/media/v4l/controls.xml |=C2=A0=C2=A08 +++++++=
+
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 12 ++++++++++++
> =C2=A0drivers/media/v4l2-core/v4l2-ctrls.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 ++
> =C2=A0include/uapi/linux/v4l2-controls.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A01 +
> =C2=A04 files changed, 23 insertions(+)
>=20
--=-IqT+0WtcRMglZYlAmQ6U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaXuUwACgkQcVMCLawGqBzXfgCeIz0fR65AvnnGTy11y7FjdcsD
ckgAoJMeBt3p4nG1az9Pwu03ManNkJfj
=sAtU
-----END PGP SIGNATURE-----

--=-IqT+0WtcRMglZYlAmQ6U--
