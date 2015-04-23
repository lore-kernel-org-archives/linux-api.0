From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] Test compaction of mlocked memory
Date: Thu, 23 Apr 2015 14:41:34 -0400
Message-ID: <20150423184134.GF2282@akamai.com>
References: <1429813301-27216-1-git-send-email-sjayaram@akamai.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pyE8wggRBhVBcj8z"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1429813301-27216-1-git-send-email-sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sri Jayaramappa <sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--pyE8wggRBhVBcj8z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Apr 2015, Sri Jayaramappa wrote:

> Commit commit 5bbe3547aa3b ("mm: allow compaction of unevictable pages")
> introduced a sysctl that allows userspace to enable scanning of locked
> pages for compaction.  This patch introduces a new test which fragments
> main memory and attempts to allocate a number of huge pages to exercise
> this compaction logic.
>=20
> Tested on machines with up to 32 GB RAM. With the patch a much larger
> number of huge pages can be allocated than on the kernel without the
> patch.
>=20
> Example output:
> On a machine with 16 GB RAM:
> sudo make run_tests vm
> ...
> -----------------------
> running compaction_test
> -----------------------
> No of huge pages allocated =3D 3834
> [PASS]
> ...
>=20
> Signed-off-by: Sri Jayaramappa <sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>


--pyE8wggRBhVBcj8z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVOTzeAAoJELbVsDOpoOa90xUQAJb+w+SKuCydWnDkw1cDgrFi
hDiKLAiiI/kToXA/V1r0yQNPLLNQyxLatrfxR/of7OqNOEaZwpo4f5jj/XGB4I7Y
U5IsVm6xireNX216gs7ulfX/8CT6/VsWstKtTV05Sm13WeZiVRQEp1N0wNx/vTKW
cTizA6162F3mzONBRbLi99of32oZW5UngYtHXkIrtImtGa/I8YGd8IZwnZ2VNX51
70DbaT6oJsBh4d1EHW7Nc2rkPcbNhQuoHj/dSIbOOHmvpo2NUqMyFaLtOyvGAJGX
xuCjEBlOoXpAwDRwg4t4mzJLYeesCepOYoL4/n+2fZ6vKG7uvARPi2lY7Bn9X4Ct
MkEu8tqZFUthxtqg7x21aq3WyUqMvXWPvdCwXhxLV3vTXvYvF2whnikQuh68ddKK
5lAu9xxNlFvqaYwE3R/dKF8i8arZjG8Z8AjDwzyuqMxXS8c7crdLGdWAVhssPfdw
Ou1zuydZQqqa1w6Sb6UIaZ/pHGIyrGcpGrHSCmM+Ia2ZkJY4sgDHYVi5IO6lUm0G
fKOZQ8A0/Q5uuD2KP/f3fk7tEHPT033OIlEnzUfxbIBG2BYG83iXYrOkvPs/ntPZ
BUj/G/600omdtyAQna8dKySpLSccoriod3ytTWCKvSnMBDDVaQLZoP6wVTQhRMqM
R01jIJQxvmh5iZRKJ9l+
=SWg1
-----END PGP SIGNATURE-----

--pyE8wggRBhVBcj8z--
