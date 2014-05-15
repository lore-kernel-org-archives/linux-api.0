From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 10:14:44 +0200
Message-ID: <20140515081444.GD11096@twins.programming.kicks-ass.net>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhjhOMouxCL2qD2w"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5373D0CA.2050204-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--zhjhOMouxCL2qD2w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 14, 2014 at 04:23:38PM -0400, Carlos O'Donell wrote:
> There are other syscalls like gettid() that have a:
> NOTE: There is no glibc wrapper for this system call; see NOTES.

Yes, can we finally fix that please? It gets tedious having to endlessly
copy/paste that thing around.

--zhjhOMouxCL2qD2w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdHd0AAoJEHZH4aRLwOS6g1YP/j7VD0EhW7eGTLZLQmy/3V9P
a5oY1BkBJM8N8qZ44FUOJPayRGvp9WqswxdP9WxNzqtEq0CkkhTiA5BeSLWHQ0s/
XVOV2Jr693a9wbRP5pBAxS89iMhFkBcPiRDF8yZVYgOSr7sWPv7CnZsQpPX32BYV
DkzBIwNIbmn+5XFH4c8KeGu3OUHXURfOgTGj/hQro2FpfUBLskKLtLEZj7eF0T1I
/0wErUDd8jqbtD7YJwdIFBP4QJGziUaA7HqOu8wFNJT7EP+q1TR2uP+sOgxImrDm
kHho/DBjlPyXjfJtJwzit67h3y4Q7x7RPslzRsIehGJbt3zhuy5oFSsn5IshwZRT
sCotmTEbg5KWxY5RyZap0a1eMqGaW7k6X0ffSaU4p3jGTAsEcUBgkzjTkt4zn2Ot
pofkkklyvkZcqKvwTTZ5INvaRqHvLY4sw7JTOs1oFbVGHnjexfpWj8Nf0S2ii4BU
8rdjwwUtRQqCMvmp1S63p4LJGBn+JPvyOjs/x7Iw6kKxfLE9DvW2Dx70Th6i6p24
fN39/mJg4boWdq6RwpcTfPvqnduUPOpmj1GPcPgv4tm/7sBr0gEjI1azrZLE+QyR
hrFLKwNxKaZGzHrCRkesbc7nm1PNncaPMYtjsssZjA93XnVmtanv5bexTA+bAp+k
kX5xKEdSp8/JpSupKUry
=lINj
-----END PGP SIGNATURE-----

--zhjhOMouxCL2qD2w--
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
