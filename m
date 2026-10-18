Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF96F2E8DE3;
	Sun, 18 Oct 2026 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792322729; cv=none; b=OaBgJgmvg2DIIjmkCtvkYNTYBv5OAxfC08nBj87CXY6iQU6L/4a5Ol29DM9gBnlgbloaVIYJ8TxltgkzdzMlx166W8Iuvgu2AruQQqx6iJVS0qzrbVPVm7aaBXJtumEAEOX4cLwyR36KAocvyOQ7dNaY4ARULKHh7iodWV9pP/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792322729; c=relaxed/simple;
	bh=YXEbt7adFo+dexbod2va1AxkyH7DgF28ROcWNGv34Go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qqjo0+maAZTCPY6IMfJpuuabkfUfZONmg5NddbCQEBuTar9TSb/xSXtxZIBpR+A8io5NmDW1bdz8aB5x9PhGCwMc4p29F8WfDFj7HXZn8JBDrn1R2GyxvksgEfoL0/MK1eRbjTupMrrX+dkGZ0F37ymxyMG8dsYoVVOBHi3w/9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpQFnsmb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpQFnsmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E5E1F000C4;
	Sun, 18 Oct 2026 11:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792322727;
	bh=cixWUuqQ0NcxfW0CqKPoz4+R+nlMujR/LsShltuR9Hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MpQFnsmb4CkmMj+Nu2FJHr4A1be2p2sXuJDBCH0Y1pM83XcMpV3WIusRfXg5k1lsm
	 8wyN+A32d5HvtDfi0lItDUiLlgXx+SKfpjr3DvbBSSD2gm1N8BaPDw5sIEAqWx0AsH
	 Dp5KD4Ky5bp8gCgD7MPz+4blAa/5z/ncEThUnvjDFM2KYkfsjkc7WTVLV6kEf11VCe
	 dWcx5H01Ur2qfivQiCtfAXOCyu0vb4e+08K+n9e/Il4htCmY+IkfNXguCzKXdXA64o
	 9EneQvaUr1+qHAVmmUGbNGUD4TtMKT2+H9GsYqp0Bcj0b3H58qB50I5YQpD10EzY8X
	 wBB1nOd7yUALw==
Date: Sun, 18 Oct 2026 13:25:17 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: =?utf-8?B?RGFuacOrbCBIw7ZyY2huZXI=?= <dbjh@gmx.net>, 
	linux-man@vger.kernel.org, Ingo Schwarze <schwarze@openbsd.org>, victorm007@yahoo.com, 
	t.piekarski@deloquencia.de, linux-api@vger.kernel.org, x86@kernel.org
Subject: Re: Suggestions for an improvement to the man page "iopl - change
 I/O privilege level".
Message-ID: <atSsS8Pw9Pzixb7g@debian>
References: <trinity-4d271f4c-4816-435f-b8c9-53eef0ff29c7-1786468770978@trinity-msg-rest-gmx-gmx-live-d7f776569-bpnnk>
 <asvEtnxChV2-dELG@debian>
 <asvFcQvNlx6Oq9Gc@debian>
 <87ecdqewg2.ffs@fw13>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tuzsc32fezsqfbzr"
Content-Disposition: inline
In-Reply-To: <87ecdqewg2.ffs@fw13>


--tuzsc32fezsqfbzr
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: =?utf-8?B?RGFuacOrbCBIw7ZyY2huZXI=?= <dbjh@gmx.net>, 
	linux-man@vger.kernel.org, Ingo Schwarze <schwarze@openbsd.org>, victorm007@yahoo.com, 
	t.piekarski@deloquencia.de, linux-api@vger.kernel.org, x86@kernel.org
Subject: Re: Suggestions for an improvement to the man page "iopl - change
 I/O privilege level".
Message-ID: <atSsS8Pw9Pzixb7g@debian>
References: <trinity-4d271f4c-4816-435f-b8c9-53eef0ff29c7-1786468770978@trinity-msg-rest-gmx-gmx-live-d7f776569-bpnnk>
 <asvEtnxChV2-dELG@debian>
 <asvFcQvNlx6Oq9Gc@debian>
 <87ecdqewg2.ffs@fw13>
MIME-Version: 1.0
In-Reply-To: <87ecdqewg2.ffs@fw13>

Hi Thomas,

> Date: 2026-10-15 18:54:21+0200
> From: Thomas Gleixner <tglx@kernel.org>
>
> On Sun, Oct 11 2026 at 19:26, Alejandro Colomar wrote:
> >> > However, as far as I can tell, all mentioned BSDs have dropped
> >> > that functionality, but NetBSD and OpenBSD retained their version
> >> > of iopl(): i386_iopl(), x86_64_iopl() (NetBSD/x86_64) and
> >> > amd64_iopl() (OpenBSD/x86_64). FreeBSD and DragonFly BSD set the
> >> > IOPL of the relevant process to 3 in the kernel, when the process
> >> > successfully opens /dev/io.
> >> > In other words, the BSD projects all preferred to drop their
> >> > versions of ioperm() in favor of continuing to provide user
> >> > programs a way to change the IOPL. It is interesting and perhaps
> >> > noteworthy that the Linux project appears to head in the opposite
> >> > direction.
> >
> > Ingo, Thomas, do you have any comments from the OpenBSD and Linux sides?
>=20
> The 'iopl() is slower' comment is just voodoo as it really does not
> matter whether a syscall at setup time takes a bit longer or not. But
> 30+ years ago syscall performance bragging was part of the game :)
>=20
> Though the difference between iopl() and ioperm() is not only that
> ioperm() provides a more granular control than iopl() over the I/O ports
> which can be accessed.
>=20
> Up to Linux 5.4 iopl() was implemented using the IOPL bits in
> EFLAGS. Setting them to '3' allows user space to access not only all I/O
> ports via IN/INS/OUT/OUTS, but also allows user space to use CLI/STI.
>=20
> ioperm() was there first (as of Linux 0.96). It allows not only to have
> more granular control over the accessible IO ports but also avoids the
> CLI/STI enablement.
>=20
> iopl() followed in 0.97 and was deprecated after we changed the iopl()
> implementation in 5.5 to utilize the IOPERM bitmap, which effectively
> prevents the usage of CLI/STI in user space. Ancient X-Servers used to
> utilize CLI/STI in user space for serialization, but that code has long
> reached the ugly code museum.
>=20
> Aside of the syscalls the permission bitmap can also be changed via
> X86 specific VT IOCTLs.
>=20
> In all cases the caller must have RAWIO capabilities. The syscalls and
> the IOCTLs can be disabled at compile time and the security framework
> can lock them down, i.e. disable them.
>=20
> So in pratice these syscalls and IOCTLs are ancient ballast and any
> modern distro should not need them anymore.

Thanks!  I'll keep the manual pages unchanged.


Have a lovely day!
Alex

>=20
> Though at least in the enterprise world there have been binary only
> vendor "value add" programs which depended on them. At least that was the
> case seven years ago.
>=20
> But as kernels might have the syscalls disabled or security measures
> make them unacessible at runtime, these syscalls and IOCTLs might be
> indeed just nostalgia.
>=20
> My personal preference would be to just delete them, but if there is a
> legitimate use case then I prefer to have ioperm() as that allows at
> least fine granular permission checks via the syscall security controls
> instead of having the binary all or nothing iopl() mechanism.
>=20
> Thanks,
>=20
>         tglx
>=20

--=20
<https://www.alejandro-colomar.es>

--tuzsc32fezsqfbzr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrUrJ0ACgkQ64mZXMKQ
wqkTEBAAl/7yzHfwnEjVwmG8mnlqpkWROWx37AxI6geSLBvGQwkm+/lTDyExf488
3mG2Ti2rDGp0xDNJFxb4GFI+dtWijnJwTRymqRqbg8dX6L3/yait8PSw4d20eukW
fU/vEAH8NIykKpJWOnaOqTdRuVEXxtUt1BkYX8kyPx+APQFyTc0k9dg+a0Zvo4uT
HdzZUHWnT0goh9z/URIwDHKMErDEob408RLC0gZNWSDTzepi3UPb9/B4SbPckX5K
ZpgtNLEOkPEQfmod03B0B39krXIM7qb2sDzh0KHh2a8+wk85PITyn1KDmql3s+u/
J0fZn98ALxT4EaO38CjQt1NazHNVx5QOB0QOsovw8F1XB0pFtir4bf2H6TFvDbUx
4Bh9ovc729Y3QxuZRPSXT3Pyzi3cai0gN+QtYPdGDyLAE3DXAg9SFN9Wd8TH2ekS
qZ5+KuLbDW6uCKh00gXOKHpDnXnfoxqGfzGIf5VO/JSvh5oTfjXs0qLWG9cuDmZa
7a0pDG5siNCkvDEKWrWuD2U73iEsw3hhd+3mSjGeKA6jam+rYNkrn5OhehnXKvOM
w/Ofp3vq/HQfFFLYa9x4apEksFposfyf2mWtvhgLhPmY0fazp7Fc2hoC88ObuWt0
C+IsyMk8vH0k8pqYQjzSmb5HyNg6FzXN/XV0CsO4bjk4m6cv+Nw=
=584s
-----END PGP SIGNATURE-----

--tuzsc32fezsqfbzr--
