Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794875036;
	b=ftaDtT6+Tw+98txgcIyiZ7hjf8ZnDZK2LlZw7CncTVTm1LgF7fO5KExZzpqj0BKBl5Te
	 oQ6BeMF4J/39vAV1bpuw7eZ6Ye0yxRizRn31+Zal/cTZgMAAV5qARXMoWr60z42xql+9e
	 h4/1SUXclXTrdgokFkB49RE2qciqNMNO5Dnh7vM8QTYPyrMYE2Q9aEJYMeWDUagp8iuAP
	 eEatSMoIONieSgtYFUc7XvQkd5dw5DS+oNylOxiMwGFsDMHAk5E7JlsUIMbcSy7D47LSy
	 u8K6DUVgSmvGTW5yf9czGep15DrstJAdpPZ1kHQMXSsSRDV+muaFzf8CBKDHXfeVPPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794875036;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=fQ9eXzHiHeQvVjPE19jWdMNTEPumx4cvvdhCAOpg6rw=;
	b=kXk252XBG6N0GUSuFWb9WsJYgVtYnSjb75Rwy5ht29iOGFbLiX0DFAkbLU0f3MqKCnkq
	 s43CiqQ3aXJXF8SzMGNskw5AjAGPnf1LAsjh5AcKHY9Lvh1ojhIo/LuBNqFxJOAIWGww4
	 1iVGsLpFM/2Va44LZUlmVpmkNT0GFaidDiHKmf7qKETWXJ1sTFn6zVJeuRKv4Jjc3cn+O
	 wrvU8WCVNKJO4mknkjAjF0kZbG3rfdSiwFtFTnx262SDr0uKDPoFfjD59nfeXU2M3qiQ8
	 byD6yz/V7v14n+jvytLXvikM7PAd+5iYliYu8KhGEsyW8gjiufr4U87AKBw5r3V+6Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9RT5rHR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08326606A31C;
	Tue, 17 Nov 2026 00:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9RT5rHR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28B01F000C4;
	Tue, 17 Nov 2026 00:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794875035;
	bh=fQ9eXzHiHeQvVjPE19jWdMNTEPumx4cvvdhCAOpg6rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M9RT5rHRkjvdbtERfl41ONUt+npXwbDS5xCSBC5gEDjcdHO/IQKQD0aWZGNdMqOLx
	 TLikKT4NqIqcrfPuQgRPhm1jA/OqKS7dqy3WSbbDGUtj4vAJIRdqVGUETbMj4mGOAd
	 LS3MBooxdO0l8m7L6fiz3aivGGYi9N5/QTdV4u15GFqj4zwlXwleHnBZ93GnhP/SPY
	 dgTDO2TCve30yY3e2A+V9Vb6GTnBnQthzIcDmJmFJRJcA2hVPR/6fwD/q198uSaOJH
	 PwvIAWN8RW8D+gDstlWKqoj+bUJa6fA4n9pdQ29ZdVqNqzhZm7V5tqiywthpHfPGvC
	 aOdYryYivnOMw==
Date: Tue, 17 Nov 2026 01:23:51 +0100
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: Daniel Tang <danielzgtg.opensource@gmail.com>
Cc: linux-man@vger.kernel.org, 
	Christian Brauner <christian.brauner@ubuntu.com>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, Christoph Hellwig <hch@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] mount_setattr.2: Fix nonexistent perf_setattr
Message-ID: <avuehaeUB2hV031l@devuan>
References: <6099049.DvuYhMxLoT@daniel-desktop3>
 <avuYP6-OQJMhLqCn@devuan>
 <6091006.DvuYhMxLoT@daniel-desktop3>
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
	protocol="application/pgp-signature"; boundary="x46a76etezmfigcd"
Content-Disposition: inline
In-Reply-To: <6091006.DvuYhMxLoT@daniel-desktop3>


--x46a76etezmfigcd
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: Daniel Tang <danielzgtg.opensource@gmail.com>
Cc: linux-man@vger.kernel.org, 
	Christian Brauner <christian.brauner@ubuntu.com>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, Christoph Hellwig <hch@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] mount_setattr.2: Fix nonexistent perf_setattr
Message-ID: <avuehaeUB2hV031l@devuan>
References: <6099049.DvuYhMxLoT@daniel-desktop3>
 <avuYP6-OQJMhLqCn@devuan>
 <6091006.DvuYhMxLoT@daniel-desktop3>
MIME-Version: 1.0
In-Reply-To: <6091006.DvuYhMxLoT@daniel-desktop3>

Hi Daniel

> Date: 2026-11-16 19:17:48-0500
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

Thanks!  I've applied the patch.


Have a lovely night!
Alex

>  man/man2/mount_setattr.2 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/man/man2/mount_setattr.2 b/man/man2/mount_setattr.2
> index 0f4b619d8..bb8da7ca4 100644
> --- a/man/man2/mount_setattr.2
> +++ b/man/man2/mount_setattr.2
> @@ -846,7 +846,7 @@ acting as an implicit version number.
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

--x46a76etezmfigcd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmr7npcACgkQ64mZXMKQ
wqmV7w//XSsZU4i+D/mOQW8FebmPKMUiBb1YHBwA7NbA5EOLddo3U+t8FdqZsdSD
/8Dy5ZtrVQoh2o9x8DpQkbN+ziJGsQtguVS6LuNkCfFFyptvr67T1meMxDOv/vIw
GDvUuNap52Pl+MmJUlNQet+M2LknSP55nkPxmd6N65mJcQ0IU3qUG1TTO0JQ3qKg
d7twweLBOajiuGZk3AJsCo4YSCUenS7+gNMCZrMqo15mzWiceOg0c9qzOUq9qkOz
YN+Y9izDXJyJjIO+yYyI+/KsO8QOFjtcFYWNic2pfpfc8ru3kBEFnMs//hSKhAPJ
1haAjNEQydimdeJ599DHFC7Gv5dEk9mXAT7Jij79y9rzBNgb4fRW3SGBPJXWqz4E
ns+Hbw6NUNMeHw17N1qNUb20G1qB3g7OG509fC/WMyQ83ch1spHAmzlICkLGeb1o
r0LMd0z+nGfvLuo66HFY7eBY2zZFK45b8Xi8zXRBtZke9xiq/UoynslOhQHrNh8w
3pnY6w6zpbIy7b9cFPP4xnQXxLNnNk2li5VNzGLuih+Vj253IEc2XhmUU6jkjGly
7s34ScMG3+dCxM7z596iEuwDQvbZ5TUv9FK4tA1R7eLtTpgQKKAMXw9oWRRjq2ws
wIiwyGDdyY/4+pebbNzHX2KhuGZNpniRUlFyDx9yhI6X6LfAS4M=
=U1Hg
-----END PGP SIGNATURE-----

--x46a76etezmfigcd--
