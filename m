From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
Date: Fri, 15 Jan 2016 12:21:03 -0500
Message-ID: <1452878463.11268.7.camel@collabora.com>
References: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
	 <1452686611-145620-2-git-send-email-wuchengli@chromium.org>
	 <003f01d14e21$78f7ad40$6ae707c0$@samsung.com>
	 <1452783743.10009.18.camel@collabora.com>
	 <00ac01d14ef0$0702b2f0$150818d0$@samsung.com>
	 <1452798133.3306.3.camel@collabora.com>
	 <000301d14fb6$5cdd6370$16982a50$@samsung.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-hz5Y20xuHJP7gARTHNOz"
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <000301d14fb6$5cdd6370$16982a50$@samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Kamil Debski <k.debski@samsung.com>, 'Wu-Cheng Li' <wuchengli@chromium.org>, pawel@osciak.com, mchehab@osg.samsung.com, hverkuil@xs4all.nl, crope@iki.fi, standby24x7@gmail.com, ricardo.ribalda@gmail.com, ao2@ao2.it, bparrot@ti.com, 'Andrzej Hajda' <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--=-hz5Y20xuHJP7gARTHNOz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 15 janvier 2016 =C3=A0 18:01 +0100, Kamil Debski a =C3=A9crit=
=C2=A0:
> I think we had a discussion about this long, long time ago. Should it
> be
> deterministic which frame Is encoded as a key frame? Should it be the
> next queued frame, or the next processed frame? How to achieve this?
> I vaguely remember that we discussed per buffer controls on the
> mailing
> list, but I am not sure where the discussion went from there.

In RTP use cases (and most streaming cases), all we care is that we
have a key-frame produced somewhere nearby after the request. In those
cases we use P frame only stream to reduce the bandwidth and only
request a key frame for recovery. This I believe that most common case.

Many decoders though also offer what they called an "automatic" key
frame mode. In the case of x264, there is also hints you can give to
the encoder about what type of video (film, anime, etc.) so it can
optimize all this. I believe this is very advance and there is no
particular need for it.

>=20
> >=C2=A0
> > - A way to trigger a key frame to be produce
> > - A way to produce a I-Frame only stream
>=20
> This control can be used to do this:
> - V4L2_CID_MPEG_VIDEO_GOP_SIZE (It is not well documented as I can
> see ;) )
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0+ If set to 0 the encoder=
 produces a stream with P only
> frames
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0+ if set to 1 the encoder=
 produces a stream with I only
> frames
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0+ other values indicate t=
he GOP size (I-frame interval)
>=20
> > - A way to set the key-frame distance (in frames) even though this
> could
> > possibly be emulated using the trigger.
>=20
> As described above V4L2_CID_MPEG_VIDEO_GOP_SIZE can be used to
> achieve this.

Great, my memory failed on me, should have checked. This is exactly
what I was thinking. So Wu-Cheng Li patch is really what we need in the
immediate.

regards,
Nicolas
--=-hz5Y20xuHJP7gARTHNOz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaZKn8ACgkQcVMCLawGqBzHcgCeMj4GgiiTplazuQcfomJCmoDM
mvoAn3v60f3q3wxft492QypxDjnseI5Z
=uiT+
-----END PGP SIGNATURE-----

--=-hz5Y20xuHJP7gARTHNOz--
