Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1646D26656D;
	Sun, 11 Oct 2026 19:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791745828; cv=none; b=hY3DEz1kKQKuS3yve7dma8EikDas7mkxkooeDcHiqTsf8MGOas7BRPPuN6HIYUEsk43zz1bWNX0bcaPJsBHXotwb1esL7C2JPQS0Ynqm51WmeZIXsVFyp+1jUY+OPsgqHT2AVSMzjTMbxdDYolKOHlp/CrHv8mXNbdVWH62GVB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791745828; c=relaxed/simple;
	bh=bzlzqcrrIIJNCOvCneF9Psvrm/VvCC4UzfZwqxlOEQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpnzob9ON/GX1C9j3mn+tAQazT4iJ4GxHGnRoFgT+vwn0RyHr1LSH5kzGCxHhGpGLKnt5Fx15ofBix4DXjoIsxAH8bRUTQGOvhU7v3TEkRaZCgXsbEHHK93EcnsFl7XRzJMT9rOxZQwtNli/ckl0/A9awPIc/UAf0SXvpBZtzrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsXi1Mfk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsXi1Mfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103FA1F0089D;
	Sun, 11 Oct 2026 19:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791745826;
	bh=vDN57g9Oo8dZZJryrhMTFTWfys3Fb0O6+iN8oZWjf10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DsXi1MfkcOHTrf3pEWJ4nfXzrrpVesREyuoRAvDvkWU61H1WNJENLvgJME3FMblNn
	 EsCh8U2oDIFg0hvuEkxPY3V27FD4qyoG+Z2irMlEXzksZpDFEAn/nBrQ85WA0GcKPT
	 5j10BfOJNG99sBqAOHRTG56Ag/gbOgvUmn0b72qR5IBZILLhBaxTQ054o/s3JZHKyC
	 3d2tEW6SW2tmF6EI9pt3MR29z9BTtU27Fm5FCm31HdoBGDVowqs+OLExjnRSbYIr/U
	 R5oaBIHwmoA8NTCAW6Jpcsi0DewiLKDxIlqFB6G4BLWiLfxcXPo0+o1DrJPi9KUf0F
	 T7saRE2XJnf7g==
Date: Sun, 11 Oct 2026 21:10:21 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Ingo Schwarze <schwarze@usta.de>
Cc: =?utf-8?B?RGFuacOrbCBIw7ZyY2huZXI=?= <dbjh@gmx.net>, 
	linux-man@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>, victorm007@yahoo.com, 
	t.piekarski@deloquencia.de, linux-api@vger.kernel.org
Subject: Re: Suggestions for an improvement to the man page "iopl - change
 I/O privilege level".
Message-ID: <asveqQx_m64euHbu@debian>
References: <trinity-4d271f4c-4816-435f-b8c9-53eef0ff29c7-1786468770978@trinity-msg-rest-gmx-gmx-live-d7f776569-bpnnk>
 <asvEtnxChV2-dELG@debian>
 <asvFcQvNlx6Oq9Gc@debian>
 <asvb_O-dY5z9xzJZ@isnote.usta.de>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tolezl7ew3pvos2s"
Content-Disposition: inline
In-Reply-To: <asvb_O-dY5z9xzJZ@isnote.usta.de>


--tolezl7ew3pvos2s
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Ingo Schwarze <schwarze@usta.de>
Cc: =?utf-8?B?RGFuacOrbCBIw7ZyY2huZXI=?= <dbjh@gmx.net>, 
	linux-man@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>, victorm007@yahoo.com, 
	t.piekarski@deloquencia.de, linux-api@vger.kernel.org
Subject: Re: Suggestions for an improvement to the man page "iopl - change
 I/O privilege level".
Message-ID: <asveqQx_m64euHbu@debian>
References: <trinity-4d271f4c-4816-435f-b8c9-53eef0ff29c7-1786468770978@trinity-msg-rest-gmx-gmx-live-d7f776569-bpnnk>
 <asvEtnxChV2-dELG@debian>
 <asvFcQvNlx6Oq9Gc@debian>
 <asvb_O-dY5z9xzJZ@isnote.usta.de>
MIME-Version: 1.0
In-Reply-To: <asvb_O-dY5z9xzJZ@isnote.usta.de>

Hi Ingo,

> Date: 2026-10-11 20:57:00+0200
> From: Ingo Schwarze <schwarze@usta.de>
>
> Hello,
>=20
> i'm answering here because Alejandro is asking me directly.
> However, please take my comments with a grain of salt because
> this whole topic is far out of my comfort zone, and i have
> never worked on low-level hardware support.

Thanks!

> My naive impression is that all the mentioned functions are entirely
> anachronistic.  If Daniel is correct that these functions are
> intended to provide mechanisms "to allow user programs to directly
> communicate with hardware through I/O ports" then i suspect that
> goal as a whole is completely misguided and opposed to what the
> point of having any operating system at all is in the first place:
> controlling hardware access and making sure that userland *cannot*
> directly manipulate hardware.
>=20
> I searched the entire source code of the OpenBSD operating system,
> both kernel and userland, and failed to find anything that uses
> these functions.  In the Xenocara tree, which contains the X11
> implementation used by OpenBSD, there is one reference in a highly
> obscure driver, vmmouse(4) =3D VMware Mouse input driver, but
> looking at /usr/X11R6/lib/modules/input/vmmouse_drv.so, i do not
> see it actually used, so i suspect it is disabled by the configure
> script.  There is another reference in xfree86/os-support/bsd/i386_video.=
c,
> but it's only conditionally compiled, so it seems likely that is also
> disabled.  Admittedly, searching very large codebases like this
> is not trivial, so i might have overlooked something.
>=20
> To summarize, i cannot say why OpenBSD retained i386_iopl(2)
> and amd64_iopl(2).  It seems possible to me it was an accident,
> and deleting it was merely forgotten.  Looking through the
> entire commit history of these functions, my impression is
> that since these functions were first provided in OpenBSD
> almost exactly 31 years ago, exactly one persion ever changed
> anything substantial with respect to them, and that single
> change happened in 1998.  Such a low level of activity often
> occurs when the functionality in question is obsolete and unused.
>=20
> If you think that would be helpful, i could ask around inside the
> OpenBSD developer community whether i386_iopl(2) and amd64_iopl(2)
> should be deleted, or whether they still serve any purpose, and if
> so, which purpose, and report back to you.

Yes, it'd be good to get confirmation from them.

> One thing is abundantly clear: in normal multi-user operation,
> amd64_iopl(2) cannot be used on OpenBSD because OpenBSD runs
> with securelevel(7) =3D 1 by default and because OpenBSD runs
> with sysctl(8) machdep.allowaperture=3D0 by default, and i don't
> recall ever needing allowaperture for anything for more than
> a decade now.


Have a lovely night!
Alex

> Yours,
>   Ingo
>=20
> --=20
> Ingo Schwarze             <schwarze@usta.de>
> http://www.openbsd.org/   <schwarze@openbsd.org>
> http://mandoc.bsd.lv/     <schwarze@mandoc.bsd.lv>

--=20
<https://www.alejandro-colomar.es>

--tolezl7ew3pvos2s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrL3xIACgkQ64mZXMKQ
wqm0jQ//SvEJoVLyuvpJkzI6MoXtq8QMSa1cbLw7/Z3B84p+fZlmGrMu1PL141o2
Yw1p0BzVEgrvuaQEvvYgxsU6goIx7sDj8hpyknxXdtO6uJZTPECaeQQ+6AGH7B1X
BmhAgDxYzUbrmwFr7mIRkl4T9T0f42KmaCrURmt7Y90G7fAxH2+H9YXABv4Vpb8p
Z9YtJeDmUJ9Zry49WSY8vN6k60NihhQ2qRCAPmSTw72ny4GSVkEPCYbcYSJT+QnT
ds2Zf65sRf1Ad9M89ZRzq46F4b5sCzxcc8wsJkab4EUbZwD8gA+xbWKe16iId3QO
/cJ6APPXarwn54wI5r91HZB1QUKDMXBY4sBCSlvIrj46x2Un3eKwqV/Fdh8z3TLW
tl37X2ZXFCYYDTyov9sA5c9AYpZjCTugmUfDnKuBP2jorW6FirSdnBwTcI1sNFee
VUkDs/o4S4K9MItzV5/jiFmV6OKWthU+WmaArSTor8ZsQn0dGWGcNus0AckNkFp2
/nULpFIx5sK0QDTfDOgIteNhDvPBGVRfYy2MOWUP4DfYpd8O18MGSM0l02E5Oh82
DqKnWtf2oXogniBUTTKpvaAacntCxaRWpwSbuXYaF/bZ+oJ5oW2M7+VjA61D1nZA
057DpY30hveHD2z9bUa94qP4jyAmCMxTZhRVhBBogSVeNmUYKw4=
=N2dl
-----END PGP SIGNATURE-----

--tolezl7ew3pvos2s--
