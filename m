From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Tue, 28 Jan 2020 11:18:58 +0100
Message-ID: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="xNzVPy8fiuzDJ2gb2kehFMEhKE9xoboE2"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xNzVPy8fiuzDJ2gb2kehFMEhKE9xoboE2
Content-Type: multipart/mixed; boundary="0TIZ41FG6UqAgh5j0FNuYtlsRwIPAejbR";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?

--0TIZ41FG6UqAgh5j0FNuYtlsRwIPAejbR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Jens,

now that we have IORING_FEAT_CUR_PERSONALITY...

How can we optimize the fileserver case now, in order to avoid the
overhead of always calling 5 syscalls before io_uring_enter()?:

 /* gain root again */
 setresuid(-1,0,-1); setresgid(-1,0,-1)
 /* impersonate the user with groups */
 setgroups(num, grps); setresgid(-1,gid,-1); setresuid(-1,uid,-1);
 /* trigger the operation */
 io_uring_enter();

I guess some kind of IORING_REGISTER_CREDS[_UPDATE] would be
good, together with a IOSQE_FIXED_CREDS in order to specify
credentials per operation.

Or we make it much more generic and introduce a credsfd_create()
syscall in order to get an fd for a credential handle, maybe
together with another syscall to activate the credentials of
the current thread (or let a write to the fd trigger the activation
in order to avoid an additional syscall number).

Having just an fd would allow IORING_REGISTER_CREDS[_UPDATE]
to be just an array of int values instead of a more complex
structure to define the credentials.

What do you think?
metze


--0TIZ41FG6UqAgh5j0FNuYtlsRwIPAejbR--

--xNzVPy8fiuzDJ2gb2kehFMEhKE9xoboE2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAl4wCpYACgkQDbX1YShp
vVZt3BAAjKYeQZedFfZ8ij6ejIxHBo0u3zRitnsiSkVJdsEbF/0Jq8vuBuubvzxi
6XVS+2ltgT+f68teBrkz1kpYoxqU8w7xcT9i3A5bg37mc6wjm05xPYpy9tgfbI4a
Y1hNo+Ia+/OFS/l0obvnL7AFOanWXvE6U9YFIuMJIdNuT54iZZUOSNgHnlQI8im8
80T6D3liylKA7w4qcrT/sy3jaXbeqvazes1R3jOdaGzVt0E1I95xuhnqM2oApW1U
+jnUc1mfUw2teG2T3+PJ2rY+59x38fo/l/WpQ2EGXM/j48IQL59uZGz/umHLyzDR
xtphlKWhXCUzNnqlPPKmgRwh77cwsKtt14FGYlGZmfKFLIIGTITjhz2HQFAAxSpq
TN20FpQsYg4SSWmTWy44fK1J0PQ6beT9b1FD1n051oTcLLgRPxCwOuCS7vAST9Bh
BU3v/k6Yxp1z7FDKvlxN9oXdxWdl2W4T9q6Xoa5sZGTUmb1Uu3EWhVFlJQ4hpZ2O
TaHD60j0tMJcC57/KgNaTxyan0x61juJUtUQfYg2O1+CBN5bnhsZEprdwUY210wO
iJVi+O426r9vQS2kNY3mdp6NX1xSJDl+pzU7UA0bS4aFYbrFq14+0V/TiyVcIGqW
wgVisDPg4eScq8idAJ7yRnh9ArfAV9amdx3snhTKAxpDesizWeM=
=Og5/
-----END PGP SIGNATURE-----

--xNzVPy8fiuzDJ2gb2kehFMEhKE9xoboE2--
