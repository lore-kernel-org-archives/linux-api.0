Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794873808;
	b=zQB/anRn4kk9E6bEhnnwjdDq25tftvijAaF8/RdNy039BHzegz+ovskQjtsA7Oa9ZXtS
	 guups+NqEF632mY0/vPk/rRcKsCh7/AuTRXvkalPAPWVmpJlgLJ9jEXKnG6nOzd1K2etx
	 84XX6JYCUQsD0Jv01F7qe8oKtJNbbu2L6LFMVaTrCH0h5BEXjlEmdj7ASGATZfyrKfPlq
	 A07pO4s+k7HOeogx10OuBVF/dpLc59U50qd1fJnJct3G06KZ4Cv/WKR2s7w8IzlD4cK9D
	 W8D8qHAYCcs4OLUOpAAJqr77o1yMmdETBO/8GQaHz2wQ5wCUQgz587GRmlSHbR6APbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794873808;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3egGb1yTaR5T+abPV32Q7s/CnDfUohQ8vNkrtdSvGHo=;
	b=2aq7ZSuI9+z3MYOYZ8IPeGWKZNjeIVkDEQbT8g1h11GIuJ8ir2YTLceTJXXCUqhRFjH6
	 egiPCZtxGqNmlRGSdLmge3P7f0EZ6lNsWdcwkgwIljzD1Qy9nFZMa4N5dPtYqAZbrsPiQ
	 6SLIlnk2W8eKZ5I+hji4Z3Auz+L+3rwSEql/GM5GGeI099fOdR5puQt8xU5zINvxCletY
	 w8imrVwgY+VahXI3JqOJIueOCphvdTowlRzuZNNkUu4cukb9galnVr44LMSJx7fI6O+gB
	 6Cpzhxl9Rl84qLNm/+X9zXuRBMhm8eHjVHlyncneVvMb9JMrOnNkCiIkeesQOTf7Gng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nTKCwgOr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1C2606A31C;
	Tue, 17 Nov 2026 00:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nTKCwgOr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868A51F000C4;
	Tue, 17 Nov 2026 00:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794873807;
	bh=3egGb1yTaR5T+abPV32Q7s/CnDfUohQ8vNkrtdSvGHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nTKCwgOri5yr35gUkLZJOeYS0lDuEz47J9rdQffNOcKKD9U0uX5msK39KmJ6qR4f0
	 uRB5nrlHpVACol+go4U9wXOPJ3eqr4cJ2QJSbw8pRqMDAjcBaSkBCq1Hs07k/bGqKg
	 6sZegWVv87dieb74Gld+5AxMurth1ozJ9+AxnyQP4W1+0gKTVb/Y7VjFhCf/TsJ1nu
	 /pMMmZQNLLokKS8Ko29FyFTBAa/sqjHtzRtGW2wWOyvqfya7Brz58YI1Nj33gC9BM9
	 k2hsKi1dZwqs6NDrur6O2To92/UyxKw8ttMr+2RPAGf/yM5J9oCP2lcHI9K3hJxTiT
	 OImOM2fLybbqA==
Date: Tue, 17 Nov 2026 01:03:21 +0100
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: Daniel Tang <danielzgtg.opensource@gmail.com>
Cc: linux-man@vger.kernel.org, 
	Christian Brauner <christian.brauner@ubuntu.com>, Alejandro Colomar <alx.manpages@gmail.com>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] mount_setattr.2: Fix nonexistent perf_setattr
Message-ID: <avuYP6-OQJMhLqCn@devuan>
References: <6099049.DvuYhMxLoT@daniel-desktop3>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dnzxl4algc3lluj6"
Content-Disposition: inline
In-Reply-To: <6099049.DvuYhMxLoT@daniel-desktop3>


--dnzxl4algc3lluj6
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: Daniel Tang <danielzgtg.opensource@gmail.com>
Cc: linux-man@vger.kernel.org, 
	Christian Brauner <christian.brauner@ubuntu.com>, Alejandro Colomar <alx.manpages@gmail.com>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] mount_setattr.2: Fix nonexistent perf_setattr
Message-ID: <avuYP6-OQJMhLqCn@devuan>
References: <6099049.DvuYhMxLoT@daniel-desktop3>
MIME-Version: 1.0
In-Reply-To: <6099049.DvuYhMxLoT@daniel-desktop3>

Hi Daniel,

> Date: 2026-11-15 22:33:16-0500
> From: Daniel Tang <danielzgtg.opensource@gmail.com>
>
> The problematic reference had been copied from openat2.2, where it was
> fixed in bbed82c0693a ("openat2.2: tfix: fix minor reference typo"). I
> performed the same fix for mount_setattr.2.
>=20
> Fixes: f3a5ba3f0151 ("mount_setattr.2: New manual page documenting the mo=
unt_setattr() system call")
> Link: https://lore.kernel.org/linux-man/20200929223509.11783-2-cyphar@cyp=
har.com/
> Link: https://lore.kernel.org/linux-man/20191003145542.17490-1-cyphar@cyp=
har.com/
> Link: https://lore.kernel.org/linux-man/20210730094121.3252024-1-brauner@=
kernel.org/
> Signed-off-by: Daniel Tang <danielzgtg.opensource@gmail.com>
> ---
>  man2/mount_setattr.2 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

You seem to have a very old copy of the git repository.
See dcde2f70372b (2024-05-02; "man/, share/mk/: Move man*/ to man/").
Would you mind rebasing the patch?


Have a lovely night!
Alex

>=20
> diff --git a/man2/mount_setattr.2 b/man2/mount_setattr.2
> index 77233f589..5f26119cc 100644
> --- a/man2/mount_setattr.2
> +++ b/man2/mount_setattr.2
> @@ -786,7 +786,7 @@ acting as an implicit version number.
>  (Because new extension fields will always
>  be appended, the structure size will always increase.)
>  This extensibility design is very similar to other system calls such as
> -.BR perf_setattr (2),
> +.BR sched_setattr (2),
>  .BR perf_event_open (2),
>  .BR clone3 (2)
>  and
> --=20
> 2.53.0
>=20
>=20
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--dnzxl4algc3lluj6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmr7mckACgkQ64mZXMKQ
wql7Pw/+NkxZ7e2iZ0zwBns03B9wjAQTuzX9lVqVTjhT1JdpvxQf5nToT4TjTtMQ
vxLcSj6nX7uBrlJplAWKEkEaJ5YbtkRtuyt6ZgOdLuNuugn6wxCo+HhhyVN5wCBl
QgssIWMvDLRgNTtC7PJJN0amyEC5RQOqQvdJtKDnezpW3AcDFCtnp+4is+aqdWX9
rQDpJbOqv+kYlJ1j4gEf+eWfKHsAyyS36wVHlMecdkXBBJIo013RATt9efDpAJE+
h4VZcNu/8dSRrtoVQsMczUV1W7rkPnGPWv2xAJE0QgdF/vxHe2pRWWNw7/W5c8A+
MejT7SAub95XhCYdLBJgPawGgtKkwJzBsCwXE3Qd/Dq0Myn3NCC3HSQGmAyCMc2P
wHfotSwJunYx+ZA5gVW0zmVLQKyWL0VBNO1xPROh1s7ZT97LVlKI6mjAP9QHknG7
vXzpFWA95v1aXprcVBES2trHIiAmm95QGmPpVqa5cElcvDXRV/QC8jVaIFbEAtP6
uKGvYtI9aFDVe2eTXl09e1wuOZqUa4Nf0jVmK7EzU/r5c50zBa7HltGgnFZW+R/2
oyXUDnpEReYctXqvXu7czCwmKkwEYWbjthYiWk2RzWa3j9TzwOxyH03DVQJLV0c8
ClcFWY/WNAE/ysS4w/8u0eAOkhXWPZ240uoztRU9q1uCIAPK6Fw=
=3p8L
-----END PGP SIGNATURE-----

--dnzxl4algc3lluj6--
