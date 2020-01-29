From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Wed, 29 Jan 2020 03:21:36 +0300
Message-ID: <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294@gmail.com>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IxCXwQS2qPJ4CdqPK7LaTW20A24t4bFhg"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c9e58b5c-f66e-8406-16d5-fd6df1a27e77-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IxCXwQS2qPJ4CdqPK7LaTW20A24t4bFhg
Content-Type: multipart/mixed; boundary="ifVV2pBJdDMlWRXC5H7I9Ds7Auciv5DLJ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
In-Reply-To: <c9e58b5c-f66e-8406-16d5-fd6df1a27e77-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

--ifVV2pBJdDMlWRXC5H7I9Ds7Auciv5DLJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29/01/2020 03:20, Jens Axboe wrote:
> On 1/28/20 5:10 PM, Pavel Begunkov wrote:
>>>>> Checked out ("don't use static creds/mm assignments")
>>>>>
>>>>> 1. do we miscount cred refs? We grab one in get_current_cred() for =
each async
>>>>> request, but if (worker->creds !=3D work->creds) it will never be p=
ut.
>>>>
>>>> Yeah I think you're right, that needs a bit of fixing up.
>>>
>>
>> Hmm, it seems it leaks it unconditionally, as it grabs in a ref in
>> override_creds().
>>
>=20
> We grab one there, and an extra one. Then we drop one of them inline,
> and the other in __io_req_aux_free().
>=20
Yeah, with the last patch it should make it even

--=20
Pavel Begunkov


--ifVV2pBJdDMlWRXC5H7I9Ds7Auciv5DLJ--

--IxCXwQS2qPJ4CdqPK7LaTW20A24t4bFhg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4w0BAACgkQWt5b1Glr
+6UVZxAAqtyQo0bEPEkxePdczP3/QBzaH0sR0xAPY9MkrLRguWxUtzc+b5bey8NM
C8r4ZK0N8/Qpzp6pLfPHuxRg1brZcq5hYpSiV5SdxqiTLZ9ck7tZSdjBSc1XEpjd
HnIQPHoEA3zy4cQN/+XZYOEMxRuE56T4EUeg8N5Ecal8R3SGZvtMJa/ByfmTNhEp
ROwWixMJ1CTTM8QnXU+bShTve+5qz2COJSOo08js/dhp7X75dV8d3QskkyCKRNVn
JjDpo4RDHczJ/bHa9CEsHPEVr9VaKx3uxwI2PDuSQ0g09MGM945i29/NBvbZ151Z
FpJ+dHE0k+42o+dUM6lLUk6hqBWmBY0FUZrYrb26vo+j1zi2ER85P1JpPkO4Uu9t
R1gEuY0clxmyqwILYzN0/q7w6+yY/7XsgDVOrDm0X5TIrINgzdm0xdXVU6lQGKXT
8XMGj6cGgt15+cp5mefPGkkUE/TjNgb/pstxMnVUTQcvFKGs+LrDb283kgFIgGTL
CBSW1kz1UZVM+k/4oJDK3CAlX9ob8WywreOHrgjdoh1LKZAjHIhaC5jWyQY6KVMi
QAhGB+3UN8kslL0QD7zS0boqHmlrBqLdotSXGwsoisZMFiDALNDXzIOJYZrDcfDU
FIwfznHLyhkh7892vCws2K6tVkOOKGgXWLabWyU926ty7o9NfkU=
=4Ptb
-----END PGP SIGNATURE-----

--IxCXwQS2qPJ4CdqPK7LaTW20A24t4bFhg--
