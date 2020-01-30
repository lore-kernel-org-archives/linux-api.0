From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Thu, 30 Jan 2020 07:53:06 +0100
Message-ID: <f1dd34a9-cc4a-f38f-df9b-12deec84421a@samba.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="gQC0mFARULCj9eHHoe6g1iO9DnoLXwQFh"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9ce2e571-ed84-211a-4e99-d830ecdaf0e2-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gQC0mFARULCj9eHHoe6g1iO9DnoLXwQFh
Content-Type: multipart/mixed; boundary="RJ9fujLr8loXIPMC0rxP57gnLzCLrvu8h";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Message-ID: <f1dd34a9-cc4a-f38f-df9b-12deec84421a-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <688e187a-75dd-89d9-921c-67de228605ce-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <1ac31828-e915-6180-cdb4-36685442ea75-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
In-Reply-To: <9ce2e571-ed84-211a-4e99-d830ecdaf0e2-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

--RJ9fujLr8loXIPMC0rxP57gnLzCLrvu8h
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Jens,

> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c5ca84a305d3..0b2c7d800297 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6511,6 +6505,45 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd=
, u32, to_submit,
>  	return submitted ? submitted : ret;
>  }
> =20
> +struct ring_show_idr {
> +	struct io_ring_ctx *ctx;
> +	struct seq_file *m;
> +};
> +
> +static int io_uring_show_cred(int id, void *p, void *data)
> +{
> +	struct ring_show_idr *r =3D data;
> +	const struct cred *cred =3D p;
> +
> +	seq_printf(r->m, "\t%5d: uid=3D%u/gid=3D%u\n", id, cred->uid.val,
> +						cred->gid.val);
> +	return 0;
> +}

I think we should print similar information as task_state(),
there we have:

Uid:    1000   1000   1000   1000
Gid:    1000   1000   1000   1000
Groups: 1 2 3 4 5 1000


--RJ9fujLr8loXIPMC0rxP57gnLzCLrvu8h--

--gQC0mFARULCj9eHHoe6g1iO9DnoLXwQFh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAl4yfVUACgkQDbX1YShp
vVag8w//dvO8hoMg9JhSZ4qJLHczqXHU343uleogT9dssXJaQGAeb3z3yv9W88hC
nMd0HwHtv/pxUHzh5frxkaTj1FoVRsDeoROUlQM0nHeRtX7h9g0wr221wQTVniPs
kBDt2Adw9x06W9fLIyCLbdoi5Z8xqw09tyGLo+DDK3UryugJ0Z4jR7JZpgEveyxg
HLzJfJrgQZw03AOui8jOIygIxsfx4FLVCfLKZDEO2b86KcepwkfEBKcTj9DCCSRJ
wV45VemGleUuVcUC6faGEsTwh9VW3gADXCRNNdV0KX+gGZBEiouK23c86Z0lGhZM
m+bdWZmQjfoi4lGszQpMVX1Y4QdTg3U1aWVdo1uyZl+EQcaTbemyN6tR0XPKAqrE
RzVFtErZy5K3HAb8qpBX2NtqNztmANfnA8kB6rxKTwAK8SE3qEONpdPoawLmJ1Ir
jzPg+1hIfqSvlxx9jRFZAxD0E5f7muiYDQN7MfOLU0yfQXpyY0BYwm63SjxL0gsL
MNdBqG9jI5Dsb9JBoG/3BwSwo5s1wfRmuZEdkQtl1Uub1QPAuMmpPk+ww5roBKxa
uUUJoM/AaAWauByzNQCyAf0kgprUwrqRwupULxO0VZ+InF9FdsyHXCpk9jR2r6bZ
aPUen9442/R8vknVYwSsGUM/sCAaXeUDws9e49jZxE6w2RU2heo=
=SumN
-----END PGP SIGNATURE-----

--gQC0mFARULCj9eHHoe6g1iO9DnoLXwQFh--
