Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792777524;
	b=PRmN6h3hZI45rkB6OAJHt9gZiTAeR2dFxT+9SXKkPwA7eG71vwWxW4eUynGysSguSx8r
	 lVSHCpi7EMvwfQYdEMYCI/CJU6hsiUNHd628kE2vZ31JKS2JBNL8oxsOSu6/fbksBe492
	 nfQY26oonUWseTUNyaEVt2KhJjeeaWLrVZB1E4uNMoM42yhoVGBMdTIoauxt93vP0k7cH
	 343OtbOIuwzWHoFYzZGtqM04LtKZP3Bae34L0hZylaVWhJdBnK8cl4d0cTDw2nLVvW3ZA
	 +lFMpvWG4TZ0wr8hohmEToFLln09FUqNptYF/26RxowMzVbCESPTzOHxIrtUslUqxTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792777524;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DOrVtDzdarVRqYar7H62YMt1DgP0G8zc+xyLi+nLls0=;
	b=r5Lw+nhrGI3ULZGPYt8f3gyGdTKSzewGSUM8lHnY9OI654jYNy1GLzWXi33Js0dt6iZb
	 x0MwpybW0vP6PTdNXvA323Uif0DeThFW09remNg9GhjCzvgvL69S373/iCx2mtyPxshMw
	 iMXsbF87/PCJAqE33pg8Yk8W5UIa0/AYPPGARRSoS/Z4LXtPDKou+9JR2lcpgaTMLEUfp
	 QUhKQZHG9skrp/68AiRC/fsoHg72MUCx4+NVb0sfyxKYVLnVCHESSmcIBPMGJRdtPNJuV
	 RNNdYE9MJ1MiZZB2qsDXPaUGP9OvE42kBEwCqwrGpZb1SuAZGfFEIaEdFhjjkE30QXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDDA0YY4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360C2606A320;
	Fri, 23 Oct 2026 17:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDDA0YY4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065EF1F01825;
	Fri, 23 Oct 2026 17:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792777524;
	bh=DOrVtDzdarVRqYar7H62YMt1DgP0G8zc+xyLi+nLls0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jDDA0YY4UuNvft4twJ8lrfJAr4DWtX4AuONlGs6NO/UTR1O0fhF0dr0TlqAArSatR
	 hv7e7wgmvsgE4HQ20mP2pzd/adVWt6VfVO8jr92qFEcIuN1JFJEvVRN6ddxcKGcAdD
	 +t5wBxG9QGmuTU/L+cjN3LbWZrn9XBvR4M14QGS58p18S40VJa3DoovhqGGfAZCmZg
	 lPVJEW5hdW8Hs9mHj6+F7pJu47oLpWBacXNYSeACTrUljCJSWOqquF7FOP0lKxLVFv
	 DXDYtAjEoqbSbF1x0SdyQYHuhLGDZ4esEj979rbiBwqlCoGwmz98vV2OaNp/tPT0oq
	 ivPA/1qPOcXVA==
Date: Fri, 23 Oct 2026 19:45:18 +0200
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: linux-man@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>, 
	libc-alpha@sourceware.org
Subject: Re: [RFC v1] man/man2/at.2: Add page
Message-ID: <atuc6bUb3wWZYrTe@debian>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <atucS0sfOWjgtk-d@debian>
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
	protocol="application/pgp-signature"; boundary="pqegkjvl5t677bog"
Content-Disposition: inline
In-Reply-To: <atucS0sfOWjgtk-d@debian>


--pqegkjvl5t677bog
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: linux-man@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>, 
	libc-alpha@sourceware.org
Subject: Re: [RFC v1] man/man2/at.2: Add page
Message-ID: <atuc6bUb3wWZYrTe@debian>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <atucS0sfOWjgtk-d@debian>
MIME-Version: 1.0
In-Reply-To: <atucS0sfOWjgtk-d@debian>

Hi,

> Date: 2026-10-23 19:42:09+0200
> From: Alejandro Colomar <alx+linux-man@kernel.org>
>
> at(2)                 System Calls Manual                 at(2)
>=20
> NAME
>      at  -  identify  a file at directory specified by file de=E2=80=90
>      scriptor
>=20

Since there's the _ATFILE_SOURCE macro in glibc, I was wondering whether
the page should be _ATFILE_SOURCE(2const).


Cheers,
Alex

--=20
<https://www.alejandro-colomar.es>

--pqegkjvl5t677bog
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrbnS0ACgkQ64mZXMKQ
wqlAbxAAhaRgEbutZ6ID5Sw2T9A598Ls0IDhw0lXUaCl2GTxSFspJS+7d0/JdkzO
ok3amkPOLNfiBNix2ImvkzMlTP+3w5QDzrW3RaHQkWorO+13otXYgs46tZ0Ii/2g
ELjf8dm4VgQT12EfxTsGLrpuL8wbB5Fx1YTPml5b1avT6WuNCKslZvN7+NJlewfy
p/xW0Pv8nJS5I00XVZQeJ492lsE58+07emveR04vpiN2Paqo2bp68eHGjP9VwU+H
pbQJizkzRlBNsIY0NIbKPnXSyfG48UcdodcRi94vg9xA0KfSkp/Dpldl7Mwg/j2p
7moijaCAbN6Ga1OxuQMALj/M012POTPYxkEQ3OcCapToykOAbImX9h1/zAZHa/4c
6i7JBetvBf8Zb5YkCc5arSqhtfc5xuPiUL2q88l2ujAbxFcdIkyWiTKrBWqy560V
igV6PpuMtwrcg8FeBeHhucaqDb5NRkJuLO82MXC8R8tVAcjm3T8CwJDZI94SmY42
nDHdNiPofBptbDwxJ0Y6ZbIc9DagUS/ihMTxj7l+Apv4PMATWIzDq74Vd3zSlPUg
CySt3m1/zROrufqrzmxsYUaCdFoL6aDuw6Bozm2vpqR90DnDNDsQFlRb4IMrHyeC
5D6BHWauzex3J0bME2XzjMojrSwRuIDKO/8OiOjvj3oXzwtUseg=
=V+Ck
-----END PGP SIGNATURE-----

--pqegkjvl5t677bog--
