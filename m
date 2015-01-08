From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Subject: Re: [PATCH] selftests/vm: fix link error for transhuge-stress test
Date: Fri, 9 Jan 2015 00:30:06 +0300
Message-ID: <20150108213006.GC2776@yulia-desktop>
References: <1420655754-10076-1-git-send-email-Andrej.Skvortzov@gmail.com>
 <54AD872E.9060802@osg.samsung.com>
 <20150107201045.GA5704@yulia-desktop>
 <54AEA86D.60709@osg.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54AEA86D.60709@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 08:55:25AM -0700, Shuah Khan wrote:

> On 01/07/2015 01:10 PM, Andrey Skvortsov wrote:
> > man page for clock_gettime says 'Link with -lrt'. So I think the
> > error message is correct.
> >=20
>=20
> Thanks for fixing it. Applied to linux-kselftest fixes branch
>=20


Hi Shuah,

thanks for taking the patch.

sorry for the late reply. I've just checked e-mail. Different
timezone. =3D)

I have couple questions about selftests/vm/hugetlbfstest. It is called by
make run_tests, but fails always on my machine.
What does it actually test? if I understand the code right,
it tests whether RSS (read from /proc/self/statm) grows/shrinks not much du=
ring
allocation/deallocation of 16Mb.=20

Here are couple of questions about some tests in the code.
1)
hugetlbfstest.c:75
	do_mmap(-1, MAP_ANONYMOUS, 1);

it does not use hugetlbfs. So it does not correspond to the
actual test name. That confused me a little. Does it test usage of
transparent huge pages?=20

2)=20
hugetlbfstest.c:78
	do_mmap(hugefd, 0, 1);

Despite the fact, that hugefd is open at wrong location
(run_tests script mounts hugetlbfs at ./huge) the test actually does
use hugetlbfs. Unfortunately on my machine it fails always too.=20
RSS does not grow after allocation, but is the same as before.
So assertion 'llabs(after - before - length) < 0x40000' fails.
But hugepages are definitely allocated, I can see that HugePages_Free decre=
ases in
/proc/meminfo. To find this out I placed delays in the test code.
Does rss field in /proc/statm counts only normal non-huge pages?=20

       =20
--=20
Best regards,
Andrey Skvortsov

Secure e-mail with gnupg: See http://www.gnupg.org/
PGP Key ID: 0x57A3AEAD



--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJUrvbeAAoJEAF8y6L1SLCtNecP/jzivU9/JRcAuGvnpXs/fhrL
IRyfB3rVtRLHrydkeNpfcwKXb63iPI4i8Qcarx/0BgbMYfHDgQDSwVTlv3ilvS8+
IyR+4Arqk9P3p+W++wGtRpj2FTkC80jeyR+R57Y+43mtjPdz7FpXVaW1jzIJ3mKl
rpcx7v3ny/ncxzvhVibpx7Udm2GQqKPae0XIVUFPz82OxmNr0lgoe9wDTqGDLrqK
qLukfC19iBdsRZd2P8IIMhIxVJVzJD0YgtILIqzYO90TAQv8LfA1sA/S/Udf9T8h
vCLyJX6QY9S+5O8aloUxb69FH3vWrOe5uxK1SNq43CrV/MKIad17IVo9EZWu11f8
Uok3NNqz4uhAG10kKEsEapXyU6myQDNpT++I/j6nj3oqnsUMp1nDnThe5Y7ZS7P6
hS+8NU9fbtXCTKqIGc6ufrMEC6iEHHdGQgFBnGIuLEqZg2ERw1NQUneIp15XzHyZ
cXOtVZ8j7Dcm4n49lPyE7P76dcS5aLHXlHsLw5COjvgcznMrReU/zDqN3szgpXSy
bK8sz7vQUzU8azIPMb0TVgqpmBpwHiMuhDLfM2+hQjwwVNly2ucEjaxqWdp7S3P2
8XMnfXtDP/cvNYBPcgA4sviTlT4Ajc991XfkJKLYgAvQS/oBCuvqHG0TuMs0uJhu
u0zv6CPpNz0vmiST5Acf
=KBWQ
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
