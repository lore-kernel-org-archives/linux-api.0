From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [v15 0/4] ext4: add project quota support
Date: Sun, 22 Nov 2015 18:45:24 -0700
Message-ID: <951D56EE-D6DD-47BA-8AFA-A7D43E96D1E4@dilger.ca>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com> <43B1BB97-8D53-4D93-9B57-B5E2048F7E7A@dilger.ca> <CAPTn0cBp4d09u9XzQm2cXzd6kcE0+FDRX0b_H=xJBZT-i5eKcw@mail.gmail.com> <7360A48E-8576-49DB-878B-DFC2EFC83BC4@ddn.com> <20151108212830.GL19199@dastard> <81500210-A31E-45CE-A3AE-9F5D0A785954@ddn.com> <20151119214727.GC19199@dastard>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_7EFCBE56-326D-4914-B3F1-C3DEA1E2CA8A"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151119214727.GC19199@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Shuichi Ihara <sihara-LfVdkaOWEx8@public.gmane.org>, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, =?utf-8?B?0JTQvNC40YLRgNC40Lkg0JzQvtC90LDRhdC+0LI=?= <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Shuichi Ihara <ihashu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_7EFCBE56-326D-4914-B3F1-C3DEA1E2CA8A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 19, 2015, at 2:47 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>=20
> On Wed, Nov 18, 2015 at 02:14:32PM +0000, Shuichi Ihara wrote:
>>=20
>> 11/9/15, 6:28 AM , "Dave Chinner" <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>>=20
>>> On Thu, Nov 05, 2015 at 03:13:10PM +0000, Shuichi Ihara wrote:
>>>> Hello Ted, Andreas,
>>>>=20
>>>> Shilong posted an email here a week ago below.
>>>> http://lists.openwall.net/linux-ext4/2015/10/30/2
>>>>=20
>>>> we identified 10 project quota related xfstest and ported them into =
ext4/xxx.
>>>> test number are 304, 305, 299, 244, 196, 134, 108, 107, 106, 050 in =
xfs.
>>>>=20
>>>>=20
>>>> We ported 9/10 tests into ext4/xxx
>>>> ext4/050 ext4/106 ext4/107 ext4/108 ext4/196 ext4/244 ext4/299 =
ext4/400 ext4/401
>>>=20
>>> Please make them generic tests - the ext4 project quota
>>> functioanlity should work with those tests being completely
>>> unchanged except for a "_requires_project_quota()" function...
>>=20
>> Right now, we enhanced quotatool to support project quota and above =
project quota tests in ext4 uses that interface.
>> xfs uses own interface xfs_xx for project quota tests in xfs.
>> what interface are you looking at if we move ext4's project quota =
tests into generic tests?
>=20
> The project quota support in the generic quota tool should work XFS
> as well as ext4. If it doesn't, then it's not a generic tool, right?
> The whole point of having ext4 use the same userspace API as XFS is
> so that all quotas can be managed with the one tool. Essentially, if
> ext4 project quotas cannot be controlled by xfs_quota, then the ext4
> code is not compatible with XFS and hence still needs work.
>=20
> FWIW, if ext4 has implemented the kernel project quota interfaces
> correctly, then it should not matter whether we use xfs_quota or the
> generic quotatool because the kernel will translate the filesystem
> information to whatever format the quota was requested in...
>=20
> So, you should be able to simply use the xfs_quota tool in the tests
> you make generic without needing any significant modification to the
> tests to run them on ext4. Yes, that may mean you need to send a 5
> line patch to make xfs_quota run on ext4, but that's trivial
> compared to duplicating >10 tests and then having to maintain them
> forever...

I think it also makes sense to have tests for the generic quota tools,
which is what current ext4 users will have installed, and not just
xfs_quota.  This applies to both ext4 and xfs using the generic quota
tools with the new interface.  In that light, it makes sense to add
new tests that use the new quota tools, in addition to testing xfs_quota
on XFS and ext4.

Cheers, Andreas






--Apple-Mail=_7EFCBE56-326D-4914-B3F1-C3DEA1E2CA8A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVlJvtnKl2rkXzB/gAQg1Rg//Zw1J0u3EUHJGRVGS6ErKwvM19g/7cp9C
LeJb0fG5f8WBbLkiEMEFHCEeT9/Gy6ilDo5GeRJu2ly/nr0m9an9SnAF5/H+yvBj
oj74mhXbSaFTNUJj9QcuaGQbnAu9ciQtmSWkIf902V5k+w8txesFq9ms0OFGqboV
xbb8htFHh8aoKzWFxV4MRjDKdXcDKzaTD5bG746yEPTo0kqcOhBJAojJOgTeayCw
R2aE7b3pIRzoMNQyAXEMSzLzZOZaBVcJVu3OKLbRWTPiJjwYj863p/ATgOaMksSO
G8oIoizKpTKecR5l8HQWj6V3WG8c0/60pQSsrmkhY9vl6ac409/lUiJaw3nMQwFF
mUNwcrteO4lhJ9Rrsxka9H8xBqFvHh3/oRRkjtkWwdsEWr0H/x5LYBb4FsZa2A5M
bpaHkooSvvj2obJMZuqstj5KXDXH7zUnSM5RpQQDxrm80GMR1/OJNDLVYFtiALo9
d93SvqJOGy7td+xfcptfYyXlgF3H/Ta/5G4XPdnEZiOmFtWvKcrTv9XF92J2BLAj
rdvTAzFjo3Renc4qd4Lc4hD3lGyVrQ1j3WingSY3zqV4CD6i0JtvqcE9HxtOwOmI
8jMQQbT6p9QiwffOiJQHyx406fDOxF4MD50upfO22EEtSB9hYnK/F4V9IZE6+syX
X8fK6Bug+ac=
=RNXY
-----END PGP SIGNATURE-----

--Apple-Mail=_7EFCBE56-326D-4914-B3F1-C3DEA1E2CA8A--
