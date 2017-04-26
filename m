From: "G. Branden Robinson" <g.branden.robinson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Revised statx(2) man page for review
Date: Wed, 26 Apr 2017 06:43:33 -0400
Message-ID: <20170426104331.nxfk5gopskaklpmj@crack.deadbeast.net>
References: <f3ef2be8-dfa5-e1dd-2315-d787a2a2acc3@gmail.com>
 <20170425200656.GA30045@altlinux.org>
 <864d7dbb-9fa7-deb2-e379-8d99a6e8c2aa@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wx5kkx3prx75hroi"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <864d7dbb-9fa7-deb2-e379-8d99a6e8c2aa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--wx5kkx3prx75hroi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

At 2017-04-26T07:42:12+0200, Michael Kerrisk (man-pages) wrote:
> On 04/25/2017 10:06 PM, Dmitry V. Levin wrote:
> > On Tue, Apr 25, 2017 at 01:14:26PM +0200, Michael Kerrisk (man-pages) w=
rote:
> > [...]
> >>        The file timestamps are structures of the following type:
> >>
> >>            struct statx_timestamp {
> >>                __s64 tv_sec;    /* Seconds since the Epoch (UNIX time)=
 */
> >>                __s32 tv_nsec;   /* Nanoseconds before or since tv_sec =
*/
> >>            };
> >=20
> > Nanoseconds since tv_sec.  The "before tv_sec" is not implemented yet
> > and I hope nobody is going to implement it for the reasons I mentioned
> > in https://marc.info/?i=3D20170422192743.GA17005%40altlinux.org
>=20
> Thanks Dmitry. Fixed.

If you give a programmer a signed type, he or she will cheerfully stuff
negative values into it, perhaps to carry out-of-band information as
with IEEE NaNs and tagged pointers.

The user should be admonished against using the full range of the type
in any case ([0, 1e9 - 1]).

Regards,
Branden

--wx5kkx3prx75hroi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEh3PWHWjjDgcrENwa0Z6cfXEmbc4FAlkAecoACgkQ0Z6cfXEm
bc7r4RAApwt6B53lJGTVRPkOmWvOb+FBoLZTxWNUWqkFYNHM4oKiIC2FCzQw+BZA
GvUGWWBZdjmbAZpKPhSVETAHM6+/kVDJg1wmhntoGUIGeT1mjbcOlnsdHLqJkIS6
j1G7WLQ0zsNXqfdM1Oaaya8RjzD1UtaXEEu7GRlpY8MOb24QRNLfJ8hHQd2uJED2
DLMJL4MlnvqLj6Bg5pCaiFlZw7fKKV1hhE3EnHiAFTbFcJ50W+MKL0O/QZUpJwEd
xka1qttQtJFwTkuPh0ftBu/1cIaGvFLkuz/2reO4UUSiX7Os0zDObohpS/bIvd/0
PkRQvFJeITFrRsfdXpvr8WNHmHA5gglpzmOQwvKnlN8Q/VWDntFcmynie9z0IbC0
20ZViBSAL3WT3H99YJVLOUrCux6j2/SVOM+5BFZYbA35mkTEaQsMUOqWk3h5yg8L
H/g8b7Iz02eq80JFCVWAMClma4bqL7fWOlBfRmAXxMLRoG5e3QT7aYeI6DmGxEyb
fuSi0CEw2I6NdyijjEsWl0Ix31EASKOdAQRM+/LROWxrpuGf1jJL7hXnJbtfKozA
lDmdlGHz/qAAH9W8UNOMu10Q49bTRocIQABFOUFMV10/aqKfudTSFXXp6Y7xnEe1
dWl9KDDqJGSvu/lJCiPaEo/mEELm3Tq01/P3YTi3INS49I8/LGI=
=+l7L
-----END PGP SIGNATURE-----

--wx5kkx3prx75hroi--
