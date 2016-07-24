From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: [PATCH 2/5] kernel: add a helper to get an owning user namespace
	for a namespace
Date: Sun, 24 Jul 2016 10:05:32 -0700
Message-ID: <20160724170532.GB5395@odin.tremily.us>
References: <CANaxB-xw_xBUq=0uT14ANv-jfg2NsGaPy=jyDO9=yF03_7toSw@mail.gmail.com>
	<1468548742-32136-1-git-send-email-avagin@openvz.org>
	<1468548742-32136-2-git-send-email-avagin@openvz.org>
	<878twrmxu2.fsf@x220.int.ebiederm.org>
	<20160724063728.GA17810@outlook.office365.com>
	<87shuzglck.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1329455667146002281=="
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87shuzglck.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--===============1329455667146002281==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 24, 2016 at 09:30:03AM -0500, Eric W. Biederman wrote:
> I am not at all certain it makes sense to return -ENOENT.
>=20
> Without the -ENOENT check the code is much cleaner, and clearer.

This is fine with me, and makes even more sense for owner (user)
namespaces than it does for net namespaces [1].  At least, I can't
think of a reason why the root user namespace would have special
userspace-visible behavior ;).

Cheers,
Trevor

[1]: http://thread.gmane.org/gmane.linux.kernel.api/20626/focus=3D30639
     Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationship=
s between namespaces                                                       =
                      =20
     Date: Sat, 23 Jul 2016 23:51:07 -0500
     Message-ID: <877fcboczo.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXlPVZAAoJEBBpoQVgXJg1XCkQANGRgEyhZ9c9t2ldpi+2LrAN
jCSJLSHQuokriRtIXOXWlITMovM2b+p5+xOCPdthpjeQ8WdueNfPJ6c+IdThKZeU
O6fts0JIIiwGvmTI1Stn6/4/mi5WjN4jlws1/ovWwT/hB1dxIy0+QEYcrYkxF3l9
eZ8qiUGBi4Zto746MXRMVp1rnYU4Rf+Eu99temIGWYYoOQ2brWL/+7GKgr2E8ZYl
iaIhDqGVi1r/FKC34RnxWDPZfh8Rlt0wEjTS01xgzIYulWuuh//rA/u/eULN0P4w
GH2IqU39VKwmcbt+6e9NgjmtkKvtg441NR9iFIA0zzMzHKdFQQq3gNt5JUgyIhOw
gbzqA21DATlcAJa2e4SAiVDCiQlXnplC0rBXspIYhRF7VlC9JJsXXx6AQq6GBJGf
jViaAYLRk/jIocUzKmLUEdvCttFKOi22YyMvlFKPDnACQaHnxPMZB2eVU7FIlarT
TMsWwAX6NPVkFmB1XrYRYq7OwP9Pkn9S9mSBS1b6My1KWVSiUxL/kkgO6uOORSA/
xeIQRwaRN4JnOqgQ7I5k5fjxyFDj2tw77SjhOMCWcQoEilp4Y2tFq92/FcyGNNNh
WZE4+rRueTQSDYPi/UhGuiOPZK02+J7OvvjBXwSyBXI+yQPn0no5K6EJQVYyGL4h
GT7T947dEQeYNBrrj7HR
=KO98
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--

--===============1329455667146002281==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--===============1329455667146002281==--
