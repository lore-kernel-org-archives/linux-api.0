From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/14] twl4030_charger: use devres for
 power_supply_register and kzalloc.
Date: Fri, 24 Jul 2015 16:35:20 +0200
Message-ID: <20150724143520.GC27569@earth>
References: <20150322231635.23789.70149.stgit@notabene.brown>
 <20150322232028.23789.38570.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KN5l+BnMqAQyZLvT"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150322232028.23789.38570.stgit-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>
Cc: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, inux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--KN5l+BnMqAQyZLvT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 23, 2015 at 10:20:28AM +1100, NeilBrown wrote:
> From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
>=20
> Final allocations/registrations are now managed by devres.
>=20
> Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>

Thanks for the patch, rebased to current master and queued with
Pavel's ACK:

http://git.infradead.org/battery-2.6.git/commit/325b50aa5d1c7dae57d1e44defd=
bacd1e2bcabde

-- Sebastian

--KN5l+BnMqAQyZLvT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVsk0oAAoJENju1/PIO/qazIAP/031Kw8cIY2pvDbSK2mZg63P
SJcObnHGB2RJMqlBA3OvTfqrz5+rLJiG5XhjNZRvBKQ8mcUjH2agzdPMqfmDX+hE
NRtfgjAo8L+MnsNhcIB5JKLmI6FT0HgdavpM6ixB0w5i3U9tgspxHyB3c/SZ9+42
+NK+w+Pm/nHiTkoaWn8uE8Tyb+LzohL/ZK3A9RdM3J9OJGEixSSZ2hvEK2EsNquV
4Y/7xEGRzkQSvVCpNpy/oatZKvfNc3l3bhYo/VUZG8xf+gomKLknl+tiAvRe5W1I
WlU5H2pzLkcLWsMXuiZo6XXfO1tb4EhPuiTpVJ3rfUXUqDiEKtEaHa42hOA5kLHX
JNfzsikqwEkdvKIuVW7ctMz9ijikh8ys85/GIouS++GpW9o2Nl4+9zNVx62MZfwe
Qnw1xqz3Y2f92k35DG+ETIhgYLhjSGT32dT0z60tip/jxc+akQu3OJEs24x65dIv
I31WRYI2lCT11VyEpmgur9zhh5VxZDWLIbFr3hG6b6X/Jmw9SwjRbNmtAPCdfZKr
xSRnvsstaBnLEroU+a5st1dZ50aGMM1ybmMVhq2kxf3hl0FkBiATqmPi0WDH+3od
ZqI80RN+u9EvQEcGqNMhkXhHyUYoIXn/Fc/S4kAvJ6yL1Q1/HKgxtg1vEnjsyo1H
/jiPmZ7LF14mZZhC7Uaz
=ZsA7
-----END PGP SIGNATURE-----

--KN5l+BnMqAQyZLvT--
