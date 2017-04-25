From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: Revised statx(2) man page for review
Date: Tue, 25 Apr 2017 23:06:56 +0300
Message-ID: <20170425200656.GA30045@altlinux.org>
References: <f3ef2be8-dfa5-e1dd-2315-d787a2a2acc3@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f3ef2be8-dfa5-e1dd-2315-d787a2a2acc3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 25, 2017 at 01:14:26PM +0200, Michael Kerrisk (man-pages) wrote:
[...]
>        The file timestamps are structures of the following type:
>=20
>            struct statx_timestamp {
>                __s64 tv_sec;    /* Seconds since the Epoch (UNIX time) */
>                __s32 tv_nsec;   /* Nanoseconds before or since tv_sec */
>            };

Nanoseconds since tv_sec.  The "before tv_sec" is not implemented yet
and I hope nobody is going to implement it for the reasons I mentioned
in https://marc.info/?i=3D20170422192743.GA17005%40altlinux.org


--=20
ldv

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJY/6xgAAoJEAVFT+BVnCUI6gUQANbFnmJrlBxoyc3Pky+EZYhU
KQc+8x2zSjpEIH1g2rKl/8FBkPAkQ4UkQibxoSl5rJNqtPT6HatMdfK58u6Gmqk4
De1HQnNlrPJUVECBgePOlghcD47TIfWvM5U4ie0UhWMPycZ3T8RbpF301+edctcX
ApmzE8npKe1uKUe2+M8DFwQ3MR7QXdqRC0HRCh7d5I+VNQie70aqgtGF92zj9z6e
/bC+uaFKQ03e5s9CJ8Vvs47y7oxkB9fQgDmlW3ydMY9p4FUWdkdXF9eN9mN8ReEA
b/YVNEOlUCnMgcGac2fTZWkSo9bpAJRaR1YUN4IAXZND6epU4XHUPMlAcPNPR057
ihc/5UPwyn3GzE6iUuSE+2WO+X0/OwHonbSCTrUhUERrAM+XNQnmhJKHD60mm5pK
fA7PeJkVYAFb5Ue60YBdYhsTwPlX2wTyR0n+mpCxIIW4GNJHFBUMFxRIFI7Qnqor
IeKgOLmPrtt36hOqRbOCk0AnZ+9buqVxNay7RAZGKHbcJRkK+FOMZC9va5JzqetB
1Xuyshtbxz7NOAxHCjkacgsOhQuZBwRW1AywJiPPZXnEQMGRCibHc7kRVZ+q+B4Q
HsPSeXhUvAtoQX6dVAnuVM2d5hQxls2oOcsTCJe2u1u14cFEnsmuzOolOc9pM/SV
t2BT9ZfMpMCSPSFQZS3L
=AAkm
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
