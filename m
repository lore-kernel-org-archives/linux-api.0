From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: [PATCH 3/5] nsfs: add ioctl to get an owning user namespace for
 ns file descriptor
Date: Thu, 14 Jul 2016 11:48:00 -0700
Message-ID: <20160714184800.GH4916@odin.tremily.us>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
 <1468520419-28220-4-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zp3hI2lFtssuDgCD"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468520419-28220-4-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--zp3hI2lFtssuDgCD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On Thu, Jul 14, 2016 at 11:20:17AM -0700, Andrey Vagin wrote:
> +int open_related_ns(struct ns_common *ns,
> +		   struct ns_common *(*get_ns)(struct ns_common *ns))
> +{
> +	struct path path =3D {};
> +	struct file *f;
> +	void *err;
> +	int fd;
> +
> +	fd =3D get_unused_fd_flags(O_CLOEXEC);
> +	if (fd < 0)
> +		return fd;
> +
> +	while (1) {
> +		struct ns_common *parent;

I think you want to rename this variable to =E2=80=98relative=E2=80=99 or s=
ome other
more-generic term [1] to echo =E2=80=98related=E2=80=99 in the function nam=
e.

Cheers,
Trevor

[1]: https://github.com/avagin/linux-task-diag/commit/7fad8ff3fc4110bebf092=
0cec2388390b3bd2238#commitcomment-18223391

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--zp3hI2lFtssuDgCD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXh95fAAoJEBBpoQVgXJg1+3AP/1QGu/z51C0vkkPX5b/xqRKq
fpI3zEB1ItkfI57Nm7OmPBE2XkRbjmgOHFWUO9Sjg7ev81V0MhA+KXfsdeuTTQiJ
R87eYnDLhtuxODM6IznVQcs/tMasi2mJxbGpG3mJHhHP/bA2FfyvCHg6C8XtwId9
6To4uanNjNOO28kYq179/gt0THko+wxKFQ1bMqHnK20kgpMLCieQGsXfO4PpI9rz
eHsBhqnH9uMYjM0MrvFIJINq7ARx1ZRRIs0x3UQ6viJH0YjDIqBcbuVBMsA43Gsm
4dPDM7AvJoRDjjD53dMER3I5xExX17D06pxE9zqrsuNBiAk0gUXt0x8BHso/yysd
uth5Y4NZDfjYTGX/6eg4mmrC/Vln0oP5oGKKYV8T10wftvDAAPryEjCm1+PdgV96
5mechFIbWI9O5DeiXrlnHkTkATdl/q0VuTyxAY3FJZsNVRrFNVP7yxm2QPtxv9UP
DWKcKRXtJjG4WgqYDtOxwwiAPkjwtuyqDurJQfWIKPOIo4NJm5CL66tQSnlvOKIW
9mT8T4NrhYPeqBkLvul9oqwSkWg70zGrV3M32wN/mDKpCbLdUDPI0zJBQO+8yUBk
dD0/M8L0SEj54icetTiKMzAGLyvO1YzrNocGecFsQl4Xcx9KJYMojXhU9kxl7XLG
U4iHvqVAKl8qE8utmNiM
=a5h8
-----END PGP SIGNATURE-----

--zp3hI2lFtssuDgCD--
