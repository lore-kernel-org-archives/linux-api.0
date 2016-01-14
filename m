From: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: Re: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
Date: Thu, 14 Jan 2016 14:02:13 -0500
Message-ID: <1452798133.3306.3.camel@collabora.com>
References: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
	 <1452686611-145620-2-git-send-email-wuchengli@chromium.org>
	 <003f01d14e21$78f7ad40$6ae707c0$@samsung.com>
	 <1452783743.10009.18.camel@collabora.com>
	 <00ac01d14ef0$0702b2f0$150818d0$@samsung.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-brlVbyPf4xej2aoZ8DtX"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00ac01d14ef0$0702b2f0$150818d0$@samsung.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kamil Debski <k.debski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, 'Wu-Cheng Li' <wuchengli-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ao2-qKGr9MkilAE@public.gmane.org, bparrot-l0cyMroinI0@public.gmane.org, 'Andrzej Hajda' <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--=-brlVbyPf4xej2aoZ8DtX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 14 janvier 2016 =C3=A0 18:21 +0100, Kamil Debski a =C3=A9crit=C2=
=A0:
> I had a look into the documentation of MFC. It is possible to force
> two types of a frame to be coded.
> The one is a keyframe, the other is a not coded frame. As I
> understand this is a type of frame that means that image did not
> change from previous frame. I am sure I seen it in an MPEG4 stream in
> a movie trailer. The initial board with the age rating is displayed
> for a couple of seconds and remains static. Thus there is one I-frame=20
> and a number of non-coded frames.
>=20
> That is the reason why the control was implemented in MFC as a menu
> and not a button. Thus the question remains - is it better to leave
> it as a menu, or should there be two (maybe more in the future)
> buttons?

Then I believe we need both. Because with the menu, setting I-Frame, I
would expect to only receive keyframes from now-on. While the useful
feature we are looking for here, is to get the next buffer (or nearby)
to be a keyframe. It's the difference between creating an I-Frame only
stream and requesting a key-frame manually for recovery (RTP use case).
In this end, we should probably take that time to review the features
we have as we need:

- A way to trigger a key frame to be produce
- A way to produce a I-Frame only stream
- A way to set the key-frame distance (in frames) even though this
could possibly be emulated using the trigger.

cheers,
Nicolas
--=-brlVbyPf4xej2aoZ8DtX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaX8LUACgkQcVMCLawGqBy+NgCgz5q9VWw+FIGC6xKtcn0MSEWn
e9AAn0NzyR4+QkHx8o160oqZcv92dGoM
=7kPt
-----END PGP SIGNATURE-----

--=-brlVbyPf4xej2aoZ8DtX--
