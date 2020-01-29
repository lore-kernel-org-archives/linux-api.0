From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Wed, 29 Jan 2020 13:17:02 +0300
Message-ID: <5406612e-299d-9d6e-96fc-c962eb93887f@gmail.com>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NKiS9UZcCjL2ZSFkMpy7wiDHkdnUqw5qk"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0df4904f-780b-5d5f-8700-41df47a1b470-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NKiS9UZcCjL2ZSFkMpy7wiDHkdnUqw5qk
Content-Type: multipart/mixed; boundary="oxXz7yUoNiNZGjTTa7SyCwONU3gCbMVKy";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <5406612e-299d-9d6e-96fc-c962eb93887f-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
In-Reply-To: <0df4904f-780b-5d5f-8700-41df47a1b470-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

--oxXz7yUoNiNZGjTTa7SyCwONU3gCbMVKy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29/01/2020 03:54, Jens Axboe wrote:
> On 1/28/20 5:24 PM, Jens Axboe wrote:
>> On 1/28/20 5:21 PM, Pavel Begunkov wrote:
>>> On 29/01/2020 03:20, Jens Axboe wrote:
>>>> On 1/28/20 5:10 PM, Pavel Begunkov wrote:
>>>>>>>> Checked out ("don't use static creds/mm assignments")
>>>>>>>>
>>>>>>>> 1. do we miscount cred refs? We grab one in get_current_cred() f=
or each async
>>>>>>>> request, but if (worker->creds !=3D work->creds) it will never b=
e put.
>>>>>>>
>>>>>>> Yeah I think you're right, that needs a bit of fixing up.
>>>>>>
>>>>>
>>>>> Hmm, it seems it leaks it unconditionally, as it grabs in a ref in
>>>>> override_creds().
>>>>>
>>>>
>>>> We grab one there, and an extra one. Then we drop one of them inline=
,
>>>> and the other in __io_req_aux_free().
>>>>
>>> Yeah, with the last patch it should make it even
>>
>> OK good we agree on that. I should probably pull back that bit to the
>> original patch to avoid having a hole in there...
>=20
> Done
>=20

("io_uring/io-wq: don't use static creds/mm assignments") and ("io_uring:=

support using a registered personality for commands") looks good now.

Reviewed-by: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


BTW, why do use decided to use idr, but not linear buffer scheme as for t=
he rest
registered ones? We can rework it later for performance with linear searc=
h in
the buffer upon registration.

--=20
Pavel Begunkov


--oxXz7yUoNiNZGjTTa7SyCwONU3gCbMVKy--

--NKiS9UZcCjL2ZSFkMpy7wiDHkdnUqw5qk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4xW6oACgkQWt5b1Glr
+6VI4g/+J/aF9jE1Rk9qQ5aR4LxbxJ2T7dX+5oLJ5QX48LbxG5YXKQGoBKeR5h7c
Qwq6qDTyAZGfzMbn/cJWNpdGQM2dUGxibIidF6jcZYNzMi/nM+TZvJc6BxFJYqqL
h/l4ewCGTWD1rnEr+sEJ2Mu02Z8ojRZOPMj6PkKww+7GDQOYGqClK9Y3Qz93qbrw
Cv1HlA3poEoNt54SN4QU8IrWunUGxc5t5OtS5RZO6/9hZ+me/tQNvRH3VB9BGMgp
AjcQC874n63xjyExpSSJ3RzVColNxs0sVAuc9Z/P4HfiCz1/zS7CDAluH1hvA2Bm
TNNG4RHUFfClF81gdeyNAdOx/PogNXE9UIH55WhjK+aqd7rUQFucurqRoclpCjz9
W2Oe72MW8fL9kf/Kt1J6cGHEL0doQ9ugkWYSCTwKB0wvqaKgXbjaV005FH1bqo4P
J5Hq0xJ4H1NKkY/GonsuceI0v8kfVw0Hy+Lx5R8NT1+7+hzUxVi4l+RHwSpX4EhG
7EKkSRyPAtUDDsLNPIDZil8ZCecNuvTRL7CkS/aCSe4DR9/FFIImURP42QKA2345
7fFRrleOkI66kYB2VMEGGjsVlrHWzaD45DABXYRHtwdNaM6ySJAYTBhsKA5Ueiei
QEOaJrYi72k0vf1oEl649vuni6NOcXOMxZL2YumK3AzF+oxRmvU=
=bBLT
-----END PGP SIGNATURE-----

--NKiS9UZcCjL2ZSFkMpy7wiDHkdnUqw5qk--
