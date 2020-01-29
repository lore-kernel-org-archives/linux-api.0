From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Wed, 29 Jan 2020 15:27:11 +0100
Message-ID: <6ebe1e2f-77f4-ae88-e184-c140a911cbd8@samba.org>
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
 <40d52623-5f9c-d804-cdeb-b7da6b13cb4f@samba.org>
 <3e1289de-8d8e-49cf-cc9f-fb7bc67f35d5@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="ZVsCfVoayYRoUhX4w25Ixf0SyELLZG3j3"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3e1289de-8d8e-49cf-cc9f-fb7bc67f35d5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZVsCfVoayYRoUhX4w25Ixf0SyELLZG3j3
Content-Type: multipart/mixed; boundary="5r0GpbJtYryX8qTSoVCWD9vfmpubdHSyQ";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <6ebe1e2f-77f4-ae88-e184-c140a911cbd8-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
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
 <40d52623-5f9c-d804-cdeb-b7da6b13cb4f-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <3e1289de-8d8e-49cf-cc9f-fb7bc67f35d5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <3e1289de-8d8e-49cf-cc9f-fb7bc67f35d5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--5r0GpbJtYryX8qTSoVCWD9vfmpubdHSyQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

>>>>> @@ -3977,7 +3977,8 @@ static int io_req_defer_prep(struct io_kiocb =
*req,
>>>>>  		mmgrab(current->mm);
>>>>>  		req->work.mm =3D current->mm;
>>>>>  	}
>>>>> -	req->work.creds =3D get_current_cred();
>>>>> +	if (!req->work.creds)
>>>>> +		req->work.creds =3D get_current_cred();
>>>>> =20
>>>>>  	switch (req->opcode) {
>>>>>  	case IORING_OP_NOP:
>>>>
>>>> The override_creds(personality_creds) has changed current->cred
>>>> and get_current_cred() will just pick it up as in the default case.
>>>>
>>>> This would make the patch much simpler and allows put_cred() to be
>>>> in io_put_work() instead of __io_req_aux_free() as explained above.
>>>>
>>>
>>> It's one extra get_current_cred(). I'd prefer to find another way to
>>> clean this up.
>>
>> As far as I can see it avoids a get_cred() in the IOSQE_PERSONALITY ca=
se
>> and the if (!req->work.creds) for both cases.
>=20
> Great, that you turned attention to that! override_creds() is already
> grabbing a ref, so it shouldn't call get_cred() there.
> So, that's a bug.
>=20
> It could be I'm wrong with the statement above, need to recheck all thi=
s
> code to be sure.
>=20
> BTW, io_req_defer_prep() may be called twice for a req, so you will
> reassign it without putting a ref. It's safer to leave NULL checks. At
> least, until I've done reworking and fixing preparation paths.

Ok, but that would be already a bug in
"io_uring/io-wq: don't use static creds/mm assignments"
instead of logically being part of
"io_uring: support using a registered personality for commands"

metze


--5r0GpbJtYryX8qTSoVCWD9vfmpubdHSyQ--

--ZVsCfVoayYRoUhX4w25Ixf0SyELLZG3j3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAl4xlj8ACgkQDbX1YShp
vVZ2Mw/+Icg2gzGlq7BrLniDuKtpQPH5QoXvvBjwO/orK6kUolK2MDapdHEBfkmK
0I5OUK5sBzUjyyyMgIqAj4/xA0yMmSR9ifp9iHABc6qBOoxajX6A7Tm/y0zg5e5R
L3xMczewlS+K1/664kBnBsMhV5D+E39uXJS/+cn5UyR+0F4Pkgck7866mIhZK+1Y
LeACyp/thvMnt3srTrDCDmMC5XQlUINDRyOFBc//8IAGlg7naC7xbk8GWJiy8npS
nlV9WwfSjDSUQM0u756Ihqs5RSripQkXGntCThN9ol8E2JLHV4rHQgNPDYiEbQRv
RsWkIQVKOagO8cLVcKx0M3Jm82i9jN+6I9zpaDLyQwRsYCx60QKUkqadykRdAeGn
fbj8xSZzeNMu63iKaZUEKqis/nLg2JMuXdcOrI1XHYIC2qEwKqeMbIQ576p6U8BK
CI25ksOyEHOKlHZC37+SN+g4HBzjzjpJihbU5Dk3Q4P4Iww1xA5tO0Woy+jFJhpC
6/FOVhQTtXmgJOJ7V9KpcF5sMefLzh2hUFd3eGzHra4meVTeLR+Lta5gA3N8rDe4
bn4rvun5sbZ1yfBrhEdx9pZkKfZaAyhhw5vtCYqqcyB79tM/c5/kWqUma1Gn/KYX
tYJ3CD4lYhYbx4XPRsCLVlXONxd5b+2SmINc/eEnPnIyqoc3Wwg=
=MU7k
-----END PGP SIGNATURE-----

--ZVsCfVoayYRoUhX4w25Ixf0SyELLZG3j3--
