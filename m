From: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: Re: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
Date: Thu, 14 Jan 2016 10:02:23 -0500
Message-ID: <1452783743.10009.18.camel@collabora.com>
References: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
	 <1452686611-145620-2-git-send-email-wuchengli@chromium.org>
	 <003f01d14e21$78f7ad40$6ae707c0$@samsung.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Eg+JeZ429AGVvJ7by+PN"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <003f01d14e21$78f7ad40$6ae707c0$@samsung.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kamil Debski <k.debski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, 'Wu-Cheng Li' <wuchengli-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ao2-qKGr9MkilAE@public.gmane.org, bparrot-l0cyMroinI0@public.gmane.org
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--=-Eg+JeZ429AGVvJ7by+PN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kamil,

Le mercredi 13 janvier 2016 =C3=A0 17:43 +0100, Kamil Debski a =C3=A9crit=
=C2=A0:
> Good to hear that there are new codecs to use the V4L2 codec API :)
>=20
> My two cents are following - when you add a control that does the same wo=
rk
> as a driver specific control then it would be great if you modified the
> driver that
> uses the specific control to also support the newly added control.
> This way future applications=C2=A0 could use the control you added for bo=
th new
> and
> old drivers.

When i first notice this MFC specific control, I believed it was use to
produce I-Frame only streams (rather then a toggle, to produce one key-
frame on demand). So I wanted to verify the implementation to make sure
what Wu-Cheng is doing make sense. Though, I found that we set:

=C2=A0 ctx->force_frame_type =3D ctrl->val;

And never use that value anywhere else in the driver code. Hopefully
I'm just missing something, but if it's not implemented, maybe it's
better not to expose it. Otherwise, this may lead to hard to find
streaming issues. I do hope we can add this feature though, as it's
very useful feature for real time encoding.

cheers,
Nicolas
--=-Eg+JeZ429AGVvJ7by+PN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaXuH8ACgkQcVMCLawGqByzoQCfRRUJdsWqZxEeG9QiyG0qWmnC
5PwAnjwsg01zeQZNUhu9sQt+hEVza9JX
=2qfj
-----END PGP SIGNATURE-----

--=-Eg+JeZ429AGVvJ7by+PN--
