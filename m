From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 15:22:35 +0200
Message-ID: <20140515132235.GM30445@twins.programming.kicks-ass.net>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
 <20140515081444.GD11096@twins.programming.kicks-ass.net>
 <5374BE9E.8080408@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y8f0OdbJ4Wm/1jzW"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5374BE9E.8080408-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--Y8f0OdbJ4Wm/1jzW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 09:18:22AM -0400, Carlos O'Donell wrote:
> On 05/15/2014 04:14 AM, Peter Zijlstra wrote:
> > On Wed, May 14, 2014 at 04:23:38PM -0400, Carlos O'Donell wrote:
> >> There are other syscalls like gettid() that have a:
> >> NOTE: There is no glibc wrapper for this system call; see NOTES.
> >=20
> > Yes, can we finally fix that please? It gets tedious having to endlessly
> > copy/paste that thing around.
>=20
> What exactly would you like fixed?

Not having gettid() in glibc.

--Y8f0OdbJ4Wm/1jzW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdL+bAAoJEHZH4aRLwOS6xloP/2+Dg9kFtmCHAJJNl4IJQBgj
mmpDB/VgcRYQo0D2gKtaXwFeFhUJqR0SvWJIEA/wH5PXMG8ItJ5KvJ8DgBlp+IFT
QTrFjwM2LaW/uoDn7T34ubtqUZHJYRJycgFEXIh1m/57CYH41svEEWukUMjf0vU0
9ov0nmp3c3imJ8EYl9a2yudoH2IIL1bY+UNyYguMusPNCG42F2+nWttKhVhKzm5i
oBHgrJjWF49DgHvykNswNj+cB1aeuNf93G9wGNkVZ0xiuFrAbZVCOYXECJT/M01R
nxpMKeM9jWuIvhJEYZ6tcpqjkxkTjaa64fGHoIYgU7mXuVebs1ED6ia4W5398tjm
nUGMrRPrRhy2YgHBlqvJN4b4R25kneVMQ0z2rV7utx5RqiDl60kjcl4K7yHfdisM
JjxRuFOWhN1EgjyEDWCzaW7Ja8ns+SWhIDYfAL4VN7fCcS4G7jY+5pdurM5IxgU+
7+HGgLkAeYqFhRpoC3s1TA7VuxMDXvUCc+YQeP9whs1XDtcznlPlelYBrPbbf9Pt
oJpEhA/VnYKpmiV+CXLxJo5IwDYTJQj+ZHTe5KNSfHCwYe9zF2ytf+R1v+iz2Vy1
hWXTopePCszGVQ50Ls/8kUkFhLY9HnTDEhy9YY0vkLikRUSFWd1P4Ng3dWg9Q+nC
Q22G1Kj7iYiw701hMj2X
=3HGs
-----END PGP SIGNATURE-----

--Y8f0OdbJ4Wm/1jzW--
