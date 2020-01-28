From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Tue, 28 Jan 2020 17:17:13 +0100
Message-ID: <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="i0nLsXxEVxzJsU57jrAvOGMbQah2EHqM6"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i0nLsXxEVxzJsU57jrAvOGMbQah2EHqM6
Content-Type: multipart/mixed; boundary="2CVcKtUZ7PqxAqWMJJn6FqcVvVQHAgFfq";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <688e187a-75dd-89d9-921c-67de228605ce-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
In-Reply-To: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

--2CVcKtUZ7PqxAqWMJJn6FqcVvVQHAgFfq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 28.01.20 um 17:10 schrieb Jens Axboe:
> On 1/28/20 3:18 AM, Stefan Metzmacher wrote:
>> Hi Jens,
>>
>> now that we have IORING_FEAT_CUR_PERSONALITY...
>>
>> How can we optimize the fileserver case now, in order to avoid the
>> overhead of always calling 5 syscalls before io_uring_enter()?:
>>
>>  /* gain root again */
>>  setresuid(-1,0,-1); setresgid(-1,0,-1)
>>  /* impersonate the user with groups */
>>  setgroups(num, grps); setresgid(-1,gid,-1); setresuid(-1,uid,-1);
>>  /* trigger the operation */
>>  io_uring_enter();
>>
>> I guess some kind of IORING_REGISTER_CREDS[_UPDATE] would be
>> good, together with a IOSQE_FIXED_CREDS in order to specify
>> credentials per operation.
>>
>> Or we make it much more generic and introduce a credsfd_create()
>> syscall in order to get an fd for a credential handle, maybe
>> together with another syscall to activate the credentials of
>> the current thread (or let a write to the fd trigger the activation
>> in order to avoid an additional syscall number).
>>
>> Having just an fd would allow IORING_REGISTER_CREDS[_UPDATE]
>> to be just an array of int values instead of a more complex
>> structure to define the credentials.
>=20
> I'd rather avoid having to add more infrastructure for this, even if
> credsfd_create() would be nifty.
>=20
> With that in mind, something like:
>=20
> - Application does IORING_REGISTER_CREDS, which returns some index
>
> - Add a IORING_OP_USE_CREDS opcode, which sets the creds associated
>   with dependent commands
> - Actual request is linked to the IORING_OP_USE_CREDS command, any
>   link off IORING_OP_USE_CREDS will use those credentials

Using links for this sounds ok.

> - IORING_UNREGISTER_CREDS removes the registered creds
>=20
> Just throwing that out there, definitely willing to entertain other
> methods that make sense for this. Trying to avoid needing to put this
> information in the SQE itself, hence the idea to use a chain of links
> for it.
>=20
> The downside is that we'll need to maintain an array of key -> creds,
> but that's probably not a big deal.
>=20
> What do you think?

So IORING_REGISTER_CREDS would be a simple operation that just takes a
snapshot of the current_cred() and returns an id that can be passed to
IORING_OP_USE_CREDS or IORING_UNREGISTER_CREDS?

> Ideally I'd like to get this done for 5.6 even if we
> are a bit late, so you'll have everything you need with that release.

That would be great!

Thanks!
metze


--2CVcKtUZ7PqxAqWMJJn6FqcVvVQHAgFfq--

--i0nLsXxEVxzJsU57jrAvOGMbQah2EHqM6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAl4wXo0ACgkQDbX1YShp
vVZ+9g//TbwV8ranhMitu1LREcnpsTgRZ9yEuO6R35mzjHsbsxe80D/JiHgCiDPQ
Gt2dT131Z6U6R0V1hyQ6dhiG2FqF4pGwSEkUZje9Z6aysH57TaOyM74Vybz9zEEF
7nVl6iHODV3TMs35gqOUhVQXZg/p9PjAqGQ9Y7tX+/2v/9IjP1sV0J+gU9RtDJJD
yn5+6GYZJ71R/OIJAFt1zAaF3d088F7hMtE7+us3Pr38lizXBy6ZXVms1rWrtwCb
+ciAZTGkXz1o38E2X3fec/bArW8Jk0JfvbzAy4k9RkEEEIFF+qIch03eQp6crrGC
TeRpMrefxA33NAv795FGTtMD0mUfQvnZKekGgGHVya0dwwCAOfyfCDzbfiRaCthi
AjVKa5jWJucNzao8Q4IL8JeRFIA21IDWvuOSUyOcdcGohnOp7mYtrQAPgLra6FZl
1WqrHqLICWPEsfz/nUvG8/mWCusY6qJnvhMzDaOXzk5SvQCvK+Uo9O8tlQoZ9JOn
yEQbslyEPB91R+vLXmxMPC9/WGPvsm6EfHG/m4hehRZhHR4rA6MaGcWVe9ptxZNm
O4H7rRRARBBSwNpj+f9UNJAEfCrSSaIL0zqGLwiAz52oVdfPEIrIJbwFL0hOQTvr
xpF5pL1Yzx7Mq0vPprAekRojvmZcu8eLdPhVyjp52JoNUZMOSSk=
=QZAr
-----END PGP SIGNATURE-----

--i0nLsXxEVxzJsU57jrAvOGMbQah2EHqM6--
