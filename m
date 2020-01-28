From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Wed, 29 Jan 2020 01:38:50 +0300
Message-ID: <23cf858a-389e-676d-b239-155284eec6e3@gmail.com>
References: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <15ca72fd-5750-db7c-2404-2dd4d53dd196@gmail.com>
 <82b20ec2-ceaa-93f1-4cce-889a933f2c7a@kernel.dk>
 <60253bd9-93a7-4d76-93b6-586e4f55138c@gmail.com>
 <43a57f2a-16da-e657-3dca-5aa3afe31318@kernel.dk>
 <20200128212533.snjm34gct3kmfxfi@wittgenstein>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3eYLF71RS5ivj7kVym3U6jqyooSj8n90X"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200128212533.snjm34gct3kmfxfi@wittgenstein>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3eYLF71RS5ivj7kVym3U6jqyooSj8n90X
Content-Type: multipart/mixed; boundary="oVTFtXAUhKVmeJ9ryUAJuOEX8IAytDe0f";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>,
 Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <23cf858a-389e-676d-b239-155284eec6e3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <688e187a-75dd-89d9-921c-67de228605ce-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <1ac31828-e915-6180-cdb4-36685442ea75-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <15ca72fd-5750-db7c-2404-2dd4d53dd196-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <82b20ec2-ceaa-93f1-4cce-889a933f2c7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <60253bd9-93a7-4d76-93b6-586e4f55138c-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <43a57f2a-16da-e657-3dca-5aa3afe31318-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <20200128212533.snjm34gct3kmfxfi@wittgenstein>
In-Reply-To: <20200128212533.snjm34gct3kmfxfi@wittgenstein>

--oVTFtXAUhKVmeJ9ryUAJuOEX8IAytDe0f
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29/01/2020 00:25, Christian Brauner wrote:
> I've been reading along quietly. In addition to what Jens said, to ease=

> everyone's mind: pidfd_getfd() doesn't allow to unconditionally grab
> file descriptors for any task. That would be crazy. The calling task
> needs ptrace_may_access() permissions on the target task, i.e. the task=

> from which you want to grab the io_uring file descriptor. And any
> calling task that has ptrace_may_access() permissions on the target can=

> do much worse than just grabbing an fd.

Good to know, thanks!

--=20
Pavel Begunkov


--oVTFtXAUhKVmeJ9ryUAJuOEX8IAytDe0f--

--3eYLF71RS5ivj7kVym3U6jqyooSj8n90X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4wt/0ACgkQWt5b1Glr
+6Vd3A/9GISP7sSN8O0lTDXoPvR6y29W8LT9KsLDopisUherenZqMAAze+PtVaF+
ezW+W2zcSUA0EpyfeQkxEy8PM5iNuXp3RQ68LveCpX+Kaj6AJTogu0rFJ2U4ipLR
Xjw+C8X0RbOcA1jsQqikJT6myddh1IrbWQpg0xFRRwJNQHJreZa/VyJ5rUJkbTWH
oQNnIW/2jFvY3Z5dwEtqusBRhKkbvna5JaKa5px/nO5f96G1r+f6sqpB4dap57xA
tUVurLNkdODC708Cg4DAGSrNOJXGY+89FOHmKkQ5jECiNvcjrLE7EVX5o+MU75Qi
H89Hy3bOQbyQzzhy6R41xQ9uNv55nhN+5Qbk0C1qTtVw3JM/N99ST9p3ONqLKSGM
o3siMZ1XCzsO46nZF8zsScIQvMdpkPFsW6C5320T7AI1i3BolLyRW3dVn2jMJgLt
5rL0bKJyu78AhjHGBS+0hnOTte6hionDF4FOriIiPNW69OjH9XcmNF1U/Wdj+bYu
YoFD4bJXCCCNB+CXljOC03jn3XwGId4A7LjlyOn6QpL2omKnavhbC8K15CxWWX2i
xVhPAgG3BkY4IkUy6DZlpZqZ4Ku84c9lbRqmNIyoTHU9+jj3sV5SB8Gd+UR+VA0T
zg6n4yuRxrsmQ/wCZ+jWrHm7rE5PZ3+3+xfQSYUkCQXVjP+e75g=
=xfEc
-----END PGP SIGNATURE-----

--3eYLF71RS5ivj7kVym3U6jqyooSj8n90X--
