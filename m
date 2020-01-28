From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Tue, 28 Jan 2020 23:50:32 +0300
Message-ID: <60253bd9-93a7-4d76-93b6-586e4f55138c@gmail.com>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <15ca72fd-5750-db7c-2404-2dd4d53dd196@gmail.com>
 <82b20ec2-ceaa-93f1-4cce-889a933f2c7a@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GDuBqivQG276lClroVQehKjSstyRaPJRF"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <82b20ec2-ceaa-93f1-4cce-889a933f2c7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GDuBqivQG276lClroVQehKjSstyRaPJRF
Content-Type: multipart/mixed; boundary="NJOZ8s4IdoExGm4wgAcztkRx4mt6Zct97";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <60253bd9-93a7-4d76-93b6-586e4f55138c-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <688e187a-75dd-89d9-921c-67de228605ce-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <1ac31828-e915-6180-cdb4-36685442ea75-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
 <15ca72fd-5750-db7c-2404-2dd4d53dd196-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <82b20ec2-ceaa-93f1-4cce-889a933f2c7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
In-Reply-To: <82b20ec2-ceaa-93f1-4cce-889a933f2c7a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

--NJOZ8s4IdoExGm4wgAcztkRx4mt6Zct97
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2020 23:19, Jens Axboe wrote:
> On 1/28/20 1:16 PM, Pavel Begunkov wrote:
>> On 28/01/2020 22:42, Jens Axboe wrote:
>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>>>> On 1/28/20 9:19 AM, Jens Axboe wrote:
>>>>>> On 1/28/20 9:17 AM, Stefan Metzmacher wrote:
>>>>> OK, so here are two patches for testing:
>>>>>
>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-5.6/io_uring-vf=
s-creds
>>>>>
>>>>> #1 adds support for registering the personality of the invoking tas=
k,
>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited=
 to
>>>>> just having one link, it doesn't support a chain of them.
>>>>>
>>>>> I'll try and write a test case for this just to see if it actually =
works,
>>>>> so far it's totally untested.=20
>>>>>
>>>>> Adding Pavel to the CC.
>>>>
>>>> Minor tweak to ensuring we do the right thing for async offload as w=
ell,
>>>> and it tests fine for me. Test case is:
>>>>
>>>> - Run as root
>>>> - Register personality for root
>>>> - create root only file
>>>> - check we can IORING_OP_OPENAT the file
>>>> - switch to user id test
>>>> - check we cannot IORING_OP_OPENAT the file
>>>> - check that we can open the file with IORING_OP_USE_CREDS linked
>>>
>>> I didn't like it becoming a bit too complicated, both in terms of
>>> implementation and use. And the fact that we'd have to jump through
>>> hoops to make this work for a full chain.
>>>
>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>> This makes it way easier to use. Same branch:
>>>
>>> https://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-5.6/io_uring-vfs-=
creds
>>>
>>> I'd feel much better with this variant for 5.6.
>>>
>>
>> To be honest, sounds pretty dangerous. Especially since somebody start=
ed talking
>> about stealing fds from a process, it could lead to a nasty loophole s=
omehow.
>> E.g. root registers its credentials, passes io_uring it to non-privile=
ged
>> children, and then some process steals the uring fd (though, it would =
need
>> priviledged mode for code-injection or else). Could we Cc here someone=
 really
>> keen on security?
>=20
> Link? If you can steal fds, then surely you've already lost any sense o=
f

https://lwn.net/Articles/808997/
But I didn't looked up it yet.

> security in the first place? Besides, if root registered the ring, the =
root
> credentials are already IN the ring. I don't see how this adds any extr=
a
> holes.

Isn't it what you fixed in ("don't use static creds/mm assignments") ?

I'm not sure what capability (and whether any) it would need, but better =
to
think such cases through. Just saying, I would prefer to ask a person wit=
h
extensive security experience, unlike me.

>> Stefan, could you please explain, how this 5 syscalls pattern from the=
 first
>> email came in the first place? Just want to understand the case.
>=20
> I think if you go back a bit in the archive, Stefan has a fuller explan=
ation
> of how samba does the credentials dance.

Missed it, I'll take a look, thanks

--=20
Pavel Begunkov


--NJOZ8s4IdoExGm4wgAcztkRx4mt6Zct97--

--GDuBqivQG276lClroVQehKjSstyRaPJRF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4wnpgACgkQWt5b1Glr
+6UUYhAAnwyDs5oaj9TJip9NXzylfycRLKnw3z3CP2YfJ9B+RohjpptXDscylO4Y
MhxUUsGp+N+CXS468OiKbo2Wm2Pagtbgrb3OwOr5lRf4Inuy4cq3avk/nu66PYlF
Kvtrr/V/AGRjrVaa9mdVB8yACjFZXihVe5dWGj673HCY4Q7WOkriirAmZoqeb2TO
l4mAspnooyPS+p9LF+f5ZjRQg+TllRLH/EaN3SpMRMXT9vpfe/8hyM0BYUYzynxi
g8G4PMvU6t9jsbRmp5+PocpNKPGPAligAwOBdPwPIZojdt+IDw4TnwY2wrujbsa1
jGb1w3xLjjQho0TscOg9kvT1YTe2wy8PMWwbcX6EwQw/nJBu+KyW5OpqzQ67igZV
IHnsSUQQvc2fVHhhCRmDH3l4EouZAu6tFDawsq7x8eLFpoAjibQHjiflOKROX37B
HOT5P0eObYsN/oTrTiMiCmjCNApN6NxokE+8WIC4aK1G/QUGxrV3EXIZVb59t0vK
tR37m9MtkK0rGpoEtD1zY+5ss6FLPRItHWeagrRsVVeXR8LeO8ajOJdLwdR9R3Al
n7pTrrQr6yj4q93XrevwXQqdMIP+bsGtoATnWGGjw4yXBaxGBdRjB/cxYnlaqMTG
o7gJtsEhGqYv5W0nTZ+RXNppQU6X56AVsYBlmz02KRwypIU3rvE=
=exYt
-----END PGP SIGNATURE-----

--GDuBqivQG276lClroVQehKjSstyRaPJRF--
