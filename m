From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 10:23:08 +0200
Message-ID: <20140515082308.GE11096@twins.programming.kicks-ass.net>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <537407ED.8050606@zytor.com>
 <CF999CD6.90A93%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0yM48dKbQb4SmPLM"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF999CD6.90A93%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--0yM48dKbQb4SmPLM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 10:21:52PM -0700, Darren Hart wrote:
> On 5/14/14, 17:18, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>=20
> >On 05/14/2014 09:18 AM, Darren Hart wrote:
> >>=20
> >> However, unless I'm sorely mistaken, the larger problem is that glibc
> >> removed the futex() call entirely, so these man pages don't describe
> >> something users even have access to anymore. I had to revert to calling
> >> the syscalls directly in the futextest test suite because of this:
> >>=20
> >>=20
> >>http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/i=
nc
> >>lu
> >> de/futextest.h#n67
> >>=20
> >
> >This really comes down to the fact that we should have a libinux which
> >contains the basic system call wrapper machinery for Linux specific
> >things and nothing else.
> >
> >syscall(3) is toxic and breaks randomly on some platforms.
>=20
> Peter Z and I have had a good time discussing this in the past.... And
> here it is again. :-)

Oh but we wanted _way_ more than bare syscalls in there ;-)

For a start we wanted to make the vDSO a proper DSO that gets included
in the (dynamic) link chain.

/sys/lib/libdso{32,64}.so like

That would also allow all those archs that expose raw dso function
pointers for things like cmpxchg or memory barriers to just provide
platform functions instead, far more usable.

And yes, we wanted to hijack libpthread in order to finally fix the
futex mess :-)


--0yM48dKbQb4SmPLM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdHlsAAoJEHZH4aRLwOS6v/0P/1cOrrcFN8ESioCKdLNzpVzl
r/+9O1Cv6bJxDngh5Q4rS2en/4Lu3u6Q/yiBLDpl22ojRRndaiSBEBetOuOoiW+d
Bc0eSIPNd52f0bEVRYybB98pctefpUhVfHwUH2yDo/kEMmzwnfzfefHCSlL3qqL2
YMnS8eShRCLiElOL33DcBRtEhkLP0Ayw+xRtzhYzwPPaJQ4fPeJLixc1W91S9dMh
NDW/h6t6Yryqu8lcQqpdsirY9TNtX1IQxgTZY+80KWACTJhMpwjk9ov+CeW4AfeB
WgEIH7EuNbARFhLj6qPz1SaOE4SQlcF0+P9IS9X2LUryhE2VRQx1wuKpvVHWxLyM
2exojPzuevSw8z17zAeGrWxqS5Lwkms8qRWY42RyS/4dKY1NOpupY0+M5djKn5zu
luJCvtnR2aECSxz8K1o6yyvuhsXiNKRyBpLnzXPiljE34sEDWA77myH4q9x7K5q8
XYGHG3UQfPjFlRnkxK2IDhLm8N9CeqdUx9786Ur36Rh3wJnZoU1oDQ+BCWuvz0XG
Yuiy1aCNCZaVvtPgNltiJwU3S+5f5s+ONxTIFfGAj5H5cDYwjeRGq91FHYNTiwQi
/CFFouVXg/Hcv9hSXFYneiCap+y74aYkNbRnUQaHKWtzx2Mi2bRB4vqm3GS5jud6
n4YS0A3DcOEnhNogrUL8
=Y9PL
-----END PGP SIGNATURE-----

--0yM48dKbQb4SmPLM--
