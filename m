From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Wed, 29 Jan 2020 02:36:23 +0300
Message-ID: <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rEF2fbPYDZSZbOYsEnSrCcCyk8fNHPtJa"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rEF2fbPYDZSZbOYsEnSrCcCyk8fNHPtJa
Content-Type: multipart/mixed; boundary="xCYP6jDf49GkRAEMQysNnTclfI4fZ0DCL";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <2d7e7fa2-e725-8beb-90b9-6476d48bdb33-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <688e187a-75dd-89d9-921c-67de228605ce-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <1ac31828-e915-6180-cdb4-36685442ea75-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
In-Reply-To: <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

--xCYP6jDf49GkRAEMQysNnTclfI4fZ0DCL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2020 22:42, Jens Axboe wrote:
> I didn't like it becoming a bit too complicated, both in terms of
> implementation and use. And the fact that we'd have to jump through
> hoops to make this work for a full chain.
>=20
> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
> This makes it way easier to use. Same branch:
>=20
> https://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-5.6/io_uring-vfs-cr=
eds
>=20
> I'd feel much better with this variant for 5.6.
>=20

Checked out ("don't use static creds/mm assignments")

1. do we miscount cred refs? We grab one in get_current_cred() for each a=
sync
request, but if (worker->creds !=3D work->creds) it will never be put.

2. shouldn't worker->creds be named {old,saved,etc}_creds? It's set as

    worker->creds =3D override_creds(work->creds);

Where override_creds() returns previous creds. And if so, then the follow=
ing
fast check looks strange:

    worker->creds !=3D work->creds

--=20
Pavel Begunkov


--xCYP6jDf49GkRAEMQysNnTclfI4fZ0DCL--

--rEF2fbPYDZSZbOYsEnSrCcCyk8fNHPtJa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4wxXcACgkQWt5b1Glr
+6XIPQ/+JTYE1M2JkCRsNcK/1JXv09mAkVGj/ZSNPna7hmGfykBQEPYdyj2xfOV8
kRsbSF3BnqEEoAakGubgcHcFl+//hfUhu4e3ct3NzmRDY796bkhUdxVvl7D30vln
Qo4Cvh+R6ierzFZ0092TEANyud54fSMUBZqL+2Z7n5XLQkKVbKmbaTDTuzgPztcM
t+wsjWzFRqmoxu4GXLyGWP+SP0GntctdcQbqdxcZ/P4JucbxMTsS2mQrDsmzl3j5
v8AgEudAKabyrzfG3tII7ZVUfZ59GkB1MUXvkLNaKHznHeJx6tsrHES9MhfRiwlz
OTJEW5W7Nxv317X44D4XVe/83oYyG5JL1vVAuT9FjbGZtRPXmvgBa53HcxXl9oBt
88tbmSaOoW9scqgTK/3iOxdqXoWq36v6Ej7uJqAB21ZoZvR58iTWKrvA4iTn0sGg
K4nyY5Xu6SFqmEcIf5SNnzr9adSfZdaCKquOdoEer2TlxAtBiNBzL3qDW6Z7SGc1
2iJlCE0SDzy7agmCX3zvH8qsBStuSdOTcWxhrSHKPgQzJgmlRDANQi+AB/7MYZ/I
LYKAw9Li9+9Ro45DFaePYRrSjKT4NQgQXPYmg427wCNmUkEzCekpmL/YlMCNo0RS
hzrkJDB7Ilme4I2zFAwcWK5vL64BYh7waj5DqPDAj3UKjxfFewk=
=FxiK
-----END PGP SIGNATURE-----

--rEF2fbPYDZSZbOYsEnSrCcCyk8fNHPtJa--
