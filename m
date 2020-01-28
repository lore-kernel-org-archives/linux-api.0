From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Tue, 28 Jan 2020 23:16:01 +0300
Message-ID: <15ca72fd-5750-db7c-2404-2dd4d53dd196@gmail.com>
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
 boundary="jWImSDYGvGcCj1J1u1CVHWUv0abybDqj9"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jWImSDYGvGcCj1J1u1CVHWUv0abybDqj9
Content-Type: multipart/mixed; boundary="cAtZwQMO7PbfoXjRRKXxykDWMx3KT7St6";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <15ca72fd-5750-db7c-2404-2dd4d53dd196-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <688e187a-75dd-89d9-921c-67de228605ce-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <1ac31828-e915-6180-cdb4-36685442ea75-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
In-Reply-To: <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

--cAtZwQMO7PbfoXjRRKXxykDWMx3KT7St6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2020 22:42, Jens Axboe wrote:
> On 1/28/20 11:04 AM, Jens Axboe wrote:
>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>> On 1/28/20 9:19 AM, Jens Axboe wrote:
>>>> On 1/28/20 9:17 AM, Stefan Metzmacher wrote:
>>> OK, so here are two patches for testing:
>>>
>>> https://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-5.6/io_uring-vfs-=
creds
>>>
>>> #1 adds support for registering the personality of the invoking task,=

>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited t=
o
>>> just having one link, it doesn't support a chain of them.
>>>
>>> I'll try and write a test case for this just to see if it actually wo=
rks,
>>> so far it's totally untested.=20
>>>
>>> Adding Pavel to the CC.
>>
>> Minor tweak to ensuring we do the right thing for async offload as wel=
l,
>> and it tests fine for me. Test case is:
>>
>> - Run as root
>> - Register personality for root
>> - create root only file
>> - check we can IORING_OP_OPENAT the file
>> - switch to user id test
>> - check we cannot IORING_OP_OPENAT the file
>> - check that we can open the file with IORING_OP_USE_CREDS linked
>=20
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

To be honest, sounds pretty dangerous. Especially since somebody started =
talking
about stealing fds from a process, it could lead to a nasty loophole some=
how.
E.g. root registers its credentials, passes io_uring it to non-privileged=

children, and then some process steals the uring fd (though, it would nee=
d
priviledged mode for code-injection or else). Could we Cc here someone re=
ally
keen on security?

Stefan, could you please explain, how this 5 syscalls pattern from the fi=
rst
email came in the first place? Just want to understand the case.

--=20
Pavel Begunkov


--cAtZwQMO7PbfoXjRRKXxykDWMx3KT7St6--

--jWImSDYGvGcCj1J1u1CVHWUv0abybDqj9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4wlocACgkQWt5b1Glr
+6Xovg//UAGAujvB0dz9ESbIMLh98oy43Ex/DBifBBez3BrAovlzVnAB6v2p6xM3
7g+nm8lFw2xONCrvaL2Zs+XoC/lrQ6m/uGmCFkPpnqS1a5CIi6m6NqhOd9MoqnFm
Yxxp8/p7tTgvknkxowQru/eeHVoDrackyzOKNmAPqBgJYsmFUHwW6I00luWPXm2G
MOPeu7Kqvy5h8DkaouBbeXQbiN+Obkm8J1j2qNbocsvo3jj1UDUQTvNCTU6//AOJ
V9BigDj0Jkop7jJFTkTmcAikxO7qaxJDnalwXVoZxSZIU6XCySRXjYJnb2Gu0kNe
CfUcKYhCqxEtwJgAuNLdOJkt6/Um+qPARLHQSpUHQjwJXwxH3N/LO46KQjGlFSea
YOOM+5kEEcx54r9LywBd0VeFpq118dCUw0ebfFoU2L2uGlRwwgUDLfj+bCX1CwQM
2gdASDeTY3SuwbvnOD5PNd8B/jjb+2Y/oKC6RBhBfx4pwPb3PdUaP0NQ5xnhQAXj
LDGinWU/eM8Ylrtf5dUejTBVQGApOd3qt5pWWgLpy+B8rD1Q5Zgc9e51hCAJRXf6
wqc8LSrGVr/Nk+G8ZS0qsvQaJmqI2SkIoB68IqXB6KGNGBpsbuyzynWSVFy3dYlR
yZRzpgSzFn2zP3Fhe6ImHPA0F6JzbjGygBBDz1YjGXltxExZjt8=
=iShe
-----END PGP SIGNATURE-----

--jWImSDYGvGcCj1J1u1CVHWUv0abybDqj9--
