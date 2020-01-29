From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Wed, 29 Jan 2020 03:10:00 +0300
Message-ID: <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lRrc6G6gXrup0csTFFZcEntNplhztBpnq"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35eebae7-76dd-52ee-58b2-4f9e85caee40-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lRrc6G6gXrup0csTFFZcEntNplhztBpnq
Content-Type: multipart/mixed; boundary="cK8FbgRep79RadR9iuAsWyEL8b1jMSHXS";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <d3f9c1a4-8b28-3cfe-de88-503837a143bc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
In-Reply-To: <35eebae7-76dd-52ee-58b2-4f9e85caee40-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

--cK8FbgRep79RadR9iuAsWyEL8b1jMSHXS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29/01/2020 02:51, Jens Axboe wrote:
> On 1/28/20 4:40 PM, Jens Axboe wrote:
>> On 1/28/20 4:36 PM, Pavel Begunkov wrote:
>>> On 28/01/2020 22:42, Jens Axboe wrote:
>>>> I didn't like it becoming a bit too complicated, both in terms of
>>>> implementation and use. And the fact that we'd have to jump through
>>>> hoops to make this work for a full chain.
>>>>
>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>>> This makes it way easier to use. Same branch:
>>>>
>>>> https://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-5.6/io_uring-vfs=
-creds
>>>>
>>>> I'd feel much better with this variant for 5.6.
>>>>
>>>
>>> Checked out ("don't use static creds/mm assignments")
>>>
>>> 1. do we miscount cred refs? We grab one in get_current_cred() for ea=
ch async
>>> request, but if (worker->creds !=3D work->creds) it will never be put=
=2E
>>
>> Yeah I think you're right, that needs a bit of fixing up.
>=20

Hmm, it seems it leaks it unconditionally, as it grabs in a ref in overri=
de_creds().

> I think this may have gotten fixed with the later addition posted today=
?
> I'll double check. But for the newer stuff, we put it for both cases
> when the request is freed.

Yeah, maybe. I got tangled trying to verify both at once and decided to s=
tart
with the old one.


>>> 2. shouldn't worker->creds be named {old,saved,etc}_creds? It's set a=
s
>>>
>>>     worker->creds =3D override_creds(work->creds);
>>>
>>> Where override_creds() returns previous creds. And if so, then the fo=
llowing
>>> fast check looks strange:
>>>
>>>     worker->creds !=3D work->creds
>>
>> Don't care too much about the naming, but the logic does appear off.
>> I'll take a look at both of these tonight, unless you beat me to it.

Apparently, you're faster :)

>=20
> Testing this now, what a braino.
>=20
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index ee49e8852d39..8fbbadf04cc3 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -56,7 +56,8 @@ struct io_worker {
> =20
>  	struct rcu_head rcu;
>  	struct mm_struct *mm;
> -	const struct cred *creds;
> +	const struct cred *cur_creds;
> +	const struct cred *saved_creds;
>  	struct files_struct *restore_files;
>  };
> =20
> @@ -135,9 +136,9 @@ static bool __io_worker_unuse(struct io_wqe *wqe, s=
truct io_worker *worker)
>  {
>  	bool dropped_lock =3D false;
> =20
> -	if (worker->creds) {
> -		revert_creds(worker->creds);
> -		worker->creds =3D NULL;
> +	if (worker->saved_creds) {
> +		revert_creds(worker->saved_creds);
> +		worker->cur_creds =3D worker->saved_creds =3D NULL;
>  	}
> =20
>  	if (current->files !=3D worker->restore_files) {
> @@ -424,10 +425,11 @@ static void io_wq_switch_mm(struct io_worker *wor=
ker, struct io_wq_work *work)
>  static void io_wq_switch_creds(struct io_worker *worker,
>  			       struct io_wq_work *work)
>  {
> -	if (worker->creds)
> -		revert_creds(worker->creds);
> +	if (worker->saved_creds)
> +		revert_creds(worker->saved_creds);
> =20
> -	worker->creds =3D override_creds(work->creds);
> +	worker->saved_creds =3D override_creds(work->creds);
> +	worker->cur_creds =3D work->creds;
>  }

How about as follows? rever_creds() is a bit heavier than put_creds().

static void io_wq_switch_creds(struct io_worker *worker,
			       struct io_wq_work *work)
{
	const struct cred *old_creds =3D override_creds(work->creds);

	if (worker->saved_creds)
		put_cred(old_creds);
	else
		worker->saved_creds =3D old;
	worker->cur_creds =3D work->creds;
}

> =20
>  static void io_worker_handle_work(struct io_worker *worker)
> @@ -480,7 +482,7 @@ static void io_worker_handle_work(struct io_worker =
*worker)
>  		}
>  		if (work->mm !=3D worker->mm)
>  			io_wq_switch_mm(worker, work);
> -		if (worker->creds !=3D work->creds)
> +		if (worker->cur_creds !=3D work->creds)
>  			io_wq_switch_creds(worker, work);
>  		/*
>  		 * OK to set IO_WQ_WORK_CANCEL even for uncancellable work,
>=20

--=20
Pavel Begunkov


--cK8FbgRep79RadR9iuAsWyEL8b1jMSHXS--

--lRrc6G6gXrup0csTFFZcEntNplhztBpnq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4wzVgACgkQWt5b1Glr
+6UP7g//TrctzFamRv2q68uGare3sGHZxaIeAkesfEeJM/ltrvQuh/MIIiWnAdlo
3EE7j5ycRgDpviTaNLd43J3wAGHbz4eZHBeBw9opFkjiAbZird6Etc7+ysLFuojO
B8xBhcAfnMN80L4Rb9PTWk6d2pn74YI25mWQxxsbZ2VB44INycF12n1zmeNTF5C7
vOtvr20FVWKE7qDQYbxWbFHhbA0F5btMROOTAqWUtwg0u5sNfgXBst5xKh5yfbjL
fj2L3l2aJIhXHzUNFK7pidZw/3/d9RQrpbw6mPcUEdy8wOX7xSaj6KvVRnyLxBx1
wR7Cwm4Kgb5PGEv4lM8NfFR6a6bafB3q0RPsQjyfi6deNoh55PpqdG3P3tUe/7za
pHOQ5sm1WIypEgnz2pTPt0D6UxGGji9fI43ihugnB4ju/gLYVf2EG8CUykKUnHFB
a83suNfXTKnBR2tub/7Esc2oJ37uX/Um3mYMkXesmempLD+WfSQnaXS+F1mPpD74
hl5LtPhB+tAVExUcZGF78JXogGnUJvbAcdn26nqoq0YPbETMelnGQXWw9+4Ibhik
VtZNOqTU9SygfmHjWlchrvtG/6sckWsmxjvl+YFMlRCR6q+NF2GoiRASrRt8dfUA
t8kwYMIfclv2iqxyLhbJNqDMklj4/KpZS8nRFBv6SeZbU8zmg9Y=
=idCk
-----END PGP SIGNATURE-----

--lRrc6G6gXrup0csTFFZcEntNplhztBpnq--
