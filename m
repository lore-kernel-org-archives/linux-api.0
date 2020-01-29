From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Wed, 29 Jan 2020 14:56:08 +0100
Message-ID: <40d52623-5f9c-d804-cdeb-b7da6b13cb4f@samba.org>
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
 <821243e7-b470-ad7a-c1a5-535bee58e76d@samba.org>
 <9a419bc5-4445-318d-87aa-1474b49266dd@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="NTB0gBQdUfNNpY15ycJr8sw77yo161jNa"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9a419bc5-4445-318d-87aa-1474b49266dd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NTB0gBQdUfNNpY15ycJr8sw77yo161jNa
Content-Type: multipart/mixed; boundary="4oagsRBWUl74mM6fBoIyxxcAhkzmIMJpC";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <40d52623-5f9c-d804-cdeb-b7da6b13cb4f-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
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
 <821243e7-b470-ad7a-c1a5-535bee58e76d-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <9a419bc5-4445-318d-87aa-1474b49266dd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <9a419bc5-4445-318d-87aa-1474b49266dd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--4oagsRBWUl74mM6fBoIyxxcAhkzmIMJpC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 29.01.20 um 14:41 schrieb Pavel Begunkov:
> On 1/29/2020 4:11 PM, Stefan Metzmacher wrote:
>> Am 29.01.20 um 11:17 schrieb Pavel Begunkov:
>>> On 29/01/2020 03:54, Jens Axboe wrote:
>>>> On 1/28/20 5:24 PM, Jens Axboe wrote:
>>>>> On 1/28/20 5:21 PM, Pavel Begunkov wrote:
>>>>>> On 29/01/2020 03:20, Jens Axboe wrote:
>>>>>>> On 1/28/20 5:10 PM, Pavel Begunkov wrote:
>>>>>>>>>>> Checked out ("don't use static creds/mm assignments")
>>>>>>>>>>>
>>>>>>>>>>> 1. do we miscount cred refs? We grab one in get_current_cred(=
) for each async
>>>>>>>>>>> request, but if (worker->creds !=3D work->creds) it will neve=
r be put.
>>>>>>>>>>
>>>>>>>>>> Yeah I think you're right, that needs a bit of fixing up.
>>>>>>>>>
>>>>>>>>
>>>>>>>> Hmm, it seems it leaks it unconditionally, as it grabs in a ref =
in
>>>>>>>> override_creds().
>>>>>>>>
>>>>>>>
>>>>>>> We grab one there, and an extra one. Then we drop one of them inl=
ine,
>>>>>>> and the other in __io_req_aux_free().
>>>>>>>
>>>>>> Yeah, with the last patch it should make it even
>>>>>
>>>>> OK good we agree on that. I should probably pull back that bit to t=
he
>>>>> original patch to avoid having a hole in there...
>>>>
>>>> Done
>>>>
>>>
>>> ("io_uring/io-wq: don't use static creds/mm assignments") and ("io_ur=
ing:
>>> support using a registered personality for commands") looks good now.=

>>>
>>> Reviewed-by: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> I'm very happy with the design, thanks!
>> That exactly what I had in mind:-)
>>
>> It would also work with IORING_SETUP_SQPOLL, correct?
>>
>=20
> Yep
>=20
>> However I think there're a few things to improve/simplify.
>>
>=20
> Since 5.6 is already semi-open, it'd be great to have an incremental
> patch for that. I'll retoss things as usual, if nobody do it before.

I'll wait for comments from Jens first:-)
I guess we'll have things changed in his branch, when I wake up
tomorrow. Otherwise I can also create patches and submit them.

But I currently don't have an environment where I can do runtime tests
with it.

>>> https://git.kernel.dk/cgit/linux-block/commit/?h=3Dfor-5.6/io_uring-v=
fs&id=3Da26d26412e1e1783473f9dc8f030c3af3d54b1a6
>>
>> In fs/io_uring.c mmgrab() and get_current_cred() are used together in
>> two places, why is put_cred() called in __io_req_aux_free while
>> mmdrop() is called from io_put_work(). I think both should be called
>> in io_put_work(), that makes the code much easier to understand.
>>
>> My guess is that you choose __io_req_aux_free() for put_cred() because=

>> of the following patches, but I'll explain on the other commit
>> why it's not needed.
>>
>>> https://git.kernel.dk/cgit/linux-block/commit/?h=3Dfor-5.6/io_uring-v=
fs&id=3Dd9db233adf034bd7855ba06190525e10a05868be
>>
>> A minor one would be starting with 1 instead of 0 and using
>> idr_alloc_cyclic() in order to avoid immediate reuse of ids.
>> That way we could include the id in the tracing message and
>> 0 would mean the current creds were used.
>>
>>> +static int io_remove_personalities(int id, void *p, void *data)
>>> +{
>>> +	struct io_ring_ctx *ctx =3D data;
>>> +
>>> +	idr_remove(&ctx->personality_idr, id);
>>
>> Here we need something like:
>> put_creds((const struct cred *)p);
>=20
> Good catch
>=20
>>
>>> +	return 0;
>>> +}
>>
>>
>> The io_uring_register() calles would look like this, correct?
>>
>>  id =3D io_uring_register(ring_fd, IORING_REGISTER_PERSONALITY, NULL, =
0);
>>  io_uring_register(ring_fd, IORING_UNREGISTER_PERSONALITY, NULL, id);
>>
>>> https://git.kernel.dk/cgit/linux-block/commit/?h=3Dfor-5.6/io_uring-v=
fs&id=3Deec9e69e0ad9ad364e1b6a5dfc52ad576afee235
>>> +
>>> +	if (sqe_flags & IOSQE_PERSONALITY) {
>>> +		int id =3D READ_ONCE(sqe->personality);
>>> +
>>> +		req->work.creds =3D idr_find(&ctx->personality_idr, id);
>>> +		if (unlikely(!req->work.creds)) {
>>> +			ret =3D -EINVAL;
>>> +			goto err_req;
>>> +		}
>>> +		get_cred(req->work.creds);> +		old_creds =3D override_creds(req->w=
ork.creds);
>>> +	}
>>> +
>>
>> Here we could use a helper variable
>> const struct cred *personality_creds;
>> and leave req->work.creds as NULL.
>> It means we can avoid the explicit get_cred() call
>> and can skip the following hunk too:
>>
>>> @@ -3977,7 +3977,8 @@ static int io_req_defer_prep(struct io_kiocb *r=
eq,
>>>  		mmgrab(current->mm);
>>>  		req->work.mm =3D current->mm;
>>>  	}
>>> -	req->work.creds =3D get_current_cred();
>>> +	if (!req->work.creds)
>>> +		req->work.creds =3D get_current_cred();
>>> =20
>>>  	switch (req->opcode) {
>>>  	case IORING_OP_NOP:
>>
>> The override_creds(personality_creds) has changed current->cred
>> and get_current_cred() will just pick it up as in the default case.
>>
>> This would make the patch much simpler and allows put_cred() to be
>> in io_put_work() instead of __io_req_aux_free() as explained above.
>>
>=20
> It's one extra get_current_cred(). I'd prefer to find another way to
> clean this up.

As far as I can see it avoids a get_cred() in the IOSQE_PERSONALITY case
and the if (!req->work.creds) for both cases.

What do you mean exactly with one extra get_current_cred()?
Is that any worse than calling get_cred() and having an if check?

It also seems to avoid req->work.creds from being filled at all
for the non-blocking case.

metze


--4oagsRBWUl74mM6fBoIyxxcAhkzmIMJpC--

--NTB0gBQdUfNNpY15ycJr8sw77yo161jNa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAl4xjvgACgkQDbX1YShp
vVZPuA/9GsZUy5n2V65wP/ORdqSSilH3/f7pM/NKPaL2On4Z/4BTxe/M5DMMH60M
hDwHHU4Mz0W4ks5SPRdU5x/i5NFpu8uKcEOVds18O1f+LrFePiFBF6NuS2F8cofZ
DJN6GMFHGFOa1ZrrxGjQxXlrr5RebQ10bl6yzctnDC+rKoh5eFuY9/A1fxQ1/m35
F1PnY4TehJL6segKGexdLgs2WYnmFNS2anw7X7XUZ1Tx2oQa3E1V46doORLl6FAD
F0chSXvfEIwTHSOyEenDkHpcL5LMp7ug+dZzXokCWg4YA50z1ZoOucUoo5u9SsHM
kHeOa6QLIm1/UogM04hwLfU6oAcoaWpSrWNRilqmqlXb99Tou3XJNpsaqeTV3jHZ
8jOTQzyJCtjSUZhtKJTdqLoMsETwe/O5dej7wCFvtB3+FvbFbohKeNnQei9v1RiN
TCgw4xcmhI5Ti/A9jV8djn3QhlHp9q0KwZ7j3phfBca+mfAZj3j47hAWxObUrW3S
oMx5MhcUwhUon3Ea1Z2P4We/pOBtIHGY7kpWQWXdNkfegDK8CfIDuBocUnmaKdzQ
vCunAii8LIyKZvZVNBfDRvWYDjmVNwOAfm0x0khllDn7ueMmGlulX6ELfXlm2HZY
frkelhxdt9IkVV+GYWNmLHUKrfvKqFo7ruh8IJhxsxFgOL3QJTg=
=aZdi
-----END PGP SIGNATURE-----

--NTB0gBQdUfNNpY15ycJr8sw77yo161jNa--
