From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE
Date: Wed, 13 Jan 2016 10:02:42 -0500
Message-ID: <1452697362.3605.8.camel@collabora.com>
References: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-vKIMJy40P+XVrjRqkvNp"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu-Cheng Li <wuchengli@chromium.org>, pawel@osciak.com, mchehab@osg.samsung.com, hverkuil@xs4all.nl, k.debski@samsung.com, crope@iki.fi, standby24x7@gmail.com, ricardo.ribalda@gmail.com, ao2@ao2.it, bparrot@ti.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--=-vKIMJy40P+XVrjRqkvNp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 13 janvier 2016 =C3=A0 20:03 +0800, Wu-Cheng Li a =C3=A9crit=C2=
=A0:
> Some drivers also need a control like
> V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE to force an encoder frame
> type. This patch adds a general V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
>=20
> This control only affects the next queued buffer. There's no need to
> clear the value after requesting an I frame. But all controls are set
> in v4l2_ctrl_handler_setup. So a default DISABLED value is required.
> Basically this control is like V4L2_CTRL_TYPE_BUTTON with parameters.
> How to prevent a control from being set in v4l2_ctrl_handler_setup so
> DISABLED value is not needed? Does it make sense not to set a control
> if it is EXECUTE_ON_WRITE?

I don't like the way it's implemented. I don't know any decoder that
have a frame type forcing feature other they I-Frame. It would be much
more natural to use a toggle button control (and add more controls for
other types when needed) then trying to merge hypothetical toggles into
something that manually need to be set and disabled.

>=20
> Wu-Cheng Li (1):
> =C2=A0 v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
>=20
> =C2=A0Documentation/DocBook/media/v4l/controls.xml | 23
> +++++++++++++++++++++++
> =C2=A0drivers/media/v4l2-core/v4l2-ctrls.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0| 13 +++++++++++++
> =C2=A0include/uapi/linux/v4l2-controls.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A05 +++++
> =C2=A03 files changed, 41 insertions(+)
>=20
--=-vKIMJy40P+XVrjRqkvNp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaWZxIACgkQcVMCLawGqBzOdACfahCCdLWKlusD7vegK9V1pmXh
k7cAn20j2ILRehu+ZQFTnualQZ2iSi0V
=9G5v
-----END PGP SIGNATURE-----

--=-vKIMJy40P+XVrjRqkvNp--
