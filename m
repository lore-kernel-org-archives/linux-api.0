From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Wed, 29 Jan 2020 14:11:02 +0100
Message-ID: <821243e7-b470-ad7a-c1a5-535bee58e76d@samba.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
 <c9e58b5c-f66e-8406-16d5-fd6df1a27e77@kernel.dk>
 <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294@gmail.com>
 <2019e952-df2a-6b57-3571-73c525c5ba1a@kernel.dk>
 <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>
 <5406612e-299d-9d6e-96fc-c962eb93887f@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="RNLVW4EKoBAHUQUfqL7tZ7QYYQEGm1WCn"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5406612e-299d-9d6e-96fc-c962eb93887f-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RNLVW4EKoBAHUQUfqL7tZ7QYYQEGm1WCn
Content-Type: multipart/mixed; boundary="viy5iQdNsiwmTYiYhyjIGXGXRbnYn1RAi";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <821243e7-b470-ad7a-c1a5-535bee58e76d-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <688e187a-75dd-89d9-921c-67de228605ce-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <1ac31828-e915-6180-cdb4-36685442ea75-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <c9e58b5c-f66e-8406-16d5-fd6df1a27e77-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <2019e952-df2a-6b57-3571-73c525c5ba1a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <0df4904f-780b-5d5f-8700-41df47a1b470-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <5406612e-299d-9d6e-96fc-c962eb93887f-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <5406612e-299d-9d6e-96fc-c962eb93887f-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--viy5iQdNsiwmTYiYhyjIGXGXRbnYn1RAi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 29.01.20 um 11:17 schrieb Pavel Begunkov:
> On 29/01/2020 03:54, Jens Axboe wrote:
>> On 1/28/20 5:24 PM, Jens Axboe wrote:
>>> On 1/28/20 5:21 PM, Pavel Begunkov wrote:
>>>> On 29/01/2020 03:20, Jens Axboe wrote:
>>>>> On 1/28/20 5:10 PM, Pavel Begunkov wrote:
>>>>>>>>> Checked out ("don't use static creds/mm assignments")
>>>>>>>>>
>>>>>>>>> 1. do we miscount cred refs? We grab one in get_current_cred() =
for each async
>>>>>>>>> request, but if (worker->creds !=3D work->creds) it will never =
be put.
>>>>>>>>
>>>>>>>> Yeah I think you're right, that needs a bit of fixing up.
>>>>>>>
>>>>>>
>>>>>> Hmm, it seems it leaks it unconditionally, as it grabs in a ref in=

>>>>>> override_creds().
>>>>>>
>>>>>
>>>>> We grab one there, and an extra one. Then we drop one of them inlin=
e,
>>>>> and the other in __io_req_aux_free().
>>>>>
>>>> Yeah, with the last patch it should make it even
>>>
>>> OK good we agree on that. I should probably pull back that bit to the=

>>> original patch to avoid having a hole in there...
>>
>> Done
>>
>=20
> ("io_uring/io-wq: don't use static creds/mm assignments") and ("io_urin=
g:
> support using a registered personality for commands") looks good now.
>=20
> Reviewed-by: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


I'm very happy with the design, thanks!
That exactly what I had in mind:-)

It would also work with IORING_SETUP_SQPOLL, correct?

However I think there're a few things to improve/simplify.

> https://git.kernel.dk/cgit/linux-block/commit/?h=3Dfor-5.6/io_uring-vfs=
&id=3Da26d26412e1e1783473f9dc8f030c3af3d54b1a6

In fs/io_uring.c mmgrab() and get_current_cred() are used together in
two places, why is put_cred() called in __io_req_aux_free while
mmdrop() is called from io_put_work(). I think both should be called
in io_put_work(), that makes the code much easier to understand.

My guess is that you choose __io_req_aux_free() for put_cred() because
of the following patches, but I'll explain on the other commit
why it's not needed.

> https://git.kernel.dk/cgit/linux-block/commit/?h=3Dfor-5.6/io_uring-vfs=
&id=3Dd9db233adf034bd7855ba06190525e10a05868be

A minor one would be starting with 1 instead of 0 and using
idr_alloc_cyclic() in order to avoid immediate reuse of ids.
That way we could include the id in the tracing message and
0 would mean the current creds were used.

> +static int io_remove_personalities(int id, void *p, void *data)
> +{
> +	struct io_ring_ctx *ctx =3D data;
> +
> +	idr_remove(&ctx->personality_idr, id);

Here we need something like:
put_creds((const struct cred *)p);

> +	return 0;
> +}


The io_uring_register() calles would look like this, correct?

 id =3D io_uring_register(ring_fd, IORING_REGISTER_PERSONALITY, NULL, 0);=

 io_uring_register(ring_fd, IORING_UNREGISTER_PERSONALITY, NULL, id);

> https://git.kernel.dk/cgit/linux-block/commit/?h=3Dfor-5.6/io_uring-vfs=
&id=3Deec9e69e0ad9ad364e1b6a5dfc52ad576afee235
> +
> +	if (sqe_flags & IOSQE_PERSONALITY) {
> +		int id =3D READ_ONCE(sqe->personality);
> +
> +		req->work.creds =3D idr_find(&ctx->personality_idr, id);
> +		if (unlikely(!req->work.creds)) {
> +			ret =3D -EINVAL;
> +			goto err_req;
> +		}
> +		get_cred(req->work.creds);> +		old_creds =3D override_creds(req->wor=
k.creds);
> +	}
> +

Here we could use a helper variable
const struct cred *personality_creds;
and leave req->work.creds as NULL.
It means we can avoid the explicit get_cred() call
and can skip the following hunk too:

> @@ -3977,7 +3977,8 @@ static int io_req_defer_prep(struct io_kiocb *req=
,
>  		mmgrab(current->mm);
>  		req->work.mm =3D current->mm;
>  	}
> -	req->work.creds =3D get_current_cred();
> +	if (!req->work.creds)
> +		req->work.creds =3D get_current_cred();
> =20
>  	switch (req->opcode) {
>  	case IORING_OP_NOP:

The override_creds(personality_creds) has changed current->cred
and get_current_cred() will just pick it up as in the default case.

This would make the patch much simpler and allows put_cred() to be
in io_put_work() instead of __io_req_aux_free() as explained above.

metze


--viy5iQdNsiwmTYiYhyjIGXGXRbnYn1RAi--

--RNLVW4EKoBAHUQUfqL7tZ7QYYQEGm1WCn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAl4xhGYACgkQDbX1YShp
vVblORAAk3+0dsJ+7dJDj7s3cPMGwHImQCaRkJPDkVDd1pYf8/+IA1VNfqapN8jw
wsyrPJp7nEy6+W/qtMciv0afEfCNlC6VdAiqWQOriI5qBMIrn8XPlq0+FGpjvUxd
6NrIbxPGsgq7NYiMzVhKyv1lC69OZtZ4rPNaI/QAwZMeyd699sy5al/yGzCaMJEv
RWnrG6OSNvf/Snn2xrz7F3Ri/NJLoKrlA6DyKwWMbD2hygUqrX/wes3RV0cthvvE
h3vYZbeyuhoNWoCx+nK7gizHuNzlT1eW9yJiEtZE6uToKUEVsey0Bf2qHu21MFA3
6Eri0m/EeD7GtNugb6hk4AQL7AtXWRbZotweefttYGPm+tQDtMWmaZA/er0Nk1La
AbImJaWRCaoqXW77c1bzHNsWl9w6VZZrIAqv/cbumRg35Glqh5QbbqP4+nmeEupy
vUvMkd2lctYWEPnUK2BVy4T0tzDhPxjANQ9dG94HFpUI6k9LSkXfl3TaOr/3ntAc
M+/V02YF9IVX31IXrQX4U89BpDnsopfsa8hImBhdl+Y7Bmu7gsjlmOa5FOnIQx0N
O0X3bxrvsU4UEWxPHtBsvqw7MNEnmMo5FjhDx7Lq8j//wSc58qUvqMQINghsWtHr
l7YX0Q+Eig2KV9R/AXd8rzSwmeittDup4DiHm+geTV8RAEuB7xA=
=WGgZ
-----END PGP SIGNATURE-----

--RNLVW4EKoBAHUQUfqL7tZ7QYYQEGm1WCn--
