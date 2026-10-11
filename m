Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0A333B6F4;
	Sun, 11 Oct 2026 17:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791739612; cv=none; b=Xg8EWVTH2iG7fmGIzV35BocjJ86TyweGPQsbFd3IklsmOJBDmO/CZ4/POTuNZa99BYxRyk6K2Cfu745WBwpOrlOtQqQZKZ8BJBxkbiokjCu4HSdmtu3eO5pWdBLkNga5uUSPPsziaVgOFke0LvKR9m5BASp4yxl0GacdtArz0Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791739612; c=relaxed/simple;
	bh=Z3qzXzmTboPWPS7qtUkDQeu/L9o8NHFGbVn8bAHtC2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWbhHdSNBcJE/Of8zbccatbZ/JXu1fYvbTdK1TN8HGOHu9JddsbbETREdIVFUMxZ7jU2tWKpN4mb2dQkow+ULzSySoiese2XQkIco3lNGq8LMnhZ3uBKilqrF0dG/M8czHHbLEXEM3qYY86+MjHUbsOc5j/40DGzGPBJrevEcXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NTLRQBZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NTLRQBZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633EA1F0089B;
	Sun, 11 Oct 2026 17:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791739611;
	bh=Dxa33jMLdL4caH+geFXzLmkXLMTzZifeMtsus3YV39g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NTLRQBZ/SbXKSxzhUcOLMUnDI5ziR9z+dSbGq9jfjk8v6GkX03KTXeI2N291Q8XsH
	 mN3FN2TPx2xXfznXiayjXstT2AjCPiLCPSKvwRrmNykSa4XOhfNy5lPHENs2xb4yz4
	 4v2I05qJhLCoBFp3w8YOtvEQAFyEdNcWfTAXItzwbfW3BGYK8+NvT1YzoaBN28ZwdP
	 Lr1HFphXa+2gi/he2d6s4pCJDkEy9ysPxLe21yFMjsIdG3IpVBnItKbDR3c/EO+hvZ
	 bEZ+q7UAzr7BAj9F+ebgAIuzrPvwv5sK09BzvEdYcEELNbARYwFfJ8Qgev3LIaFsH2
	 +dpCGuSFuGLJg==
Date: Sun, 11 Oct 2026 19:26:45 +0200
From: Alejandro Colomar <alx@kernel.org>
To: =?utf-8?B?RGFuacOrbCBIw7ZyY2huZXI=?= <dbjh@gmx.net>, 
	linux-man@vger.kernel.org, Ingo Schwarze <schwarze@openbsd.org>, 
	Thomas Gleixner <tglx@kernel.org>
Cc: victorm007@yahoo.com, t.piekarski@deloquencia.de, 
	linux-api@vger.kernel.org
Subject: Re: Suggestions for an improvement to the man page "iopl - change
 I/O privilege level".
Message-ID: <asvFcQvNlx6Oq9Gc@debian>
References: <trinity-4d271f4c-4816-435f-b8c9-53eef0ff29c7-1786468770978@trinity-msg-rest-gmx-gmx-live-d7f776569-bpnnk>
 <asvEtnxChV2-dELG@debian>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mbjgtmgk44ife7rx"
Content-Disposition: inline
In-Reply-To: <asvEtnxChV2-dELG@debian>


--mbjgtmgk44ife7rx
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: =?utf-8?B?RGFuacOrbCBIw7ZyY2huZXI=?= <dbjh@gmx.net>, 
	linux-man@vger.kernel.org, Ingo Schwarze <schwarze@openbsd.org>, 
	Thomas Gleixner <tglx@kernel.org>
Cc: victorm007@yahoo.com, t.piekarski@deloquencia.de, 
	linux-api@vger.kernel.org
Subject: Re: Suggestions for an improvement to the man page "iopl - change
 I/O privilege level".
Message-ID: <asvFcQvNlx6Oq9Gc@debian>
References: <trinity-4d271f4c-4816-435f-b8c9-53eef0ff29c7-1786468770978@trinity-msg-rest-gmx-gmx-live-d7f776569-bpnnk>
 <asvEtnxChV2-dELG@debian>
MIME-Version: 1.0
In-Reply-To: <asvEtnxChV2-dELG@debian>

[TO +=3D Ingo and tlgx]

Hi Dani=C3=ABl, Thomas, Ingo,

> > Date: 2026-08-11 17:19:31+0000
> > From: Dani=C3=ABl H=C3=B6rchner <dbjh@gmx.net>
> >
>=20
> > Hello,
> >=20
> >=20
> > I have some feedback and suggestions to improve the man page of
> > "iopl - change I/O privilege level".
> > =20
> > The purpose of iopl() is not clearly explained. iopl() is a
> > straightforward way to allow direct access to all I/O ports from
> > user mode, when it is passed the argument 3. In practice, it is
> > always passed the argument 3.
> > =20
> > The description ends with the following paragraph:
> > "This call is deprecated, is significantly slower than ioperm(2),
> > and is only provided for older X servers which require access to
> > all 65536 I/O ports.  It is mostly for the i386 architecture.  On
> > many other architectures it does not exist or will always return
> > an error."
> > =20
> > The (dubious) claim that iopl() is slower than ioperm() is
> > completeley irrelevant, as the most common use case involves
> > calling iopl() or ioperm() once during program initialization.
> > =20
> > Compared to iopl(), ioperm() is more restrictive. In the past
> > NetBSD, FreeBSD, OpenBSD and DragonFly BSD provided analogous
> > implementations in the form of i386_set_ioperm(). OpenBSD/x86_64
> > provided amd64_set_ioperm(). They served the same purpose as
> > ioperm() on Linux/x86{_64}, i.e. controlling access to specific
> > I/O ports.
> > However, as far as I can tell, all mentioned BSDs have dropped
> > that functionality, but NetBSD and OpenBSD retained their version
> > of iopl(): i386_iopl(), x86_64_iopl() (NetBSD/x86_64) and
> > amd64_iopl() (OpenBSD/x86_64). FreeBSD and DragonFly BSD set the
> > IOPL of the relevant process to 3 in the kernel, when the process
> > successfully opens /dev/io.
> > In other words, the BSD projects all preferred to drop their
> > versions of ioperm() in favor of continuing to provide user
> > programs a way to change the IOPL. It is interesting and perhaps
> > noteworthy that the Linux project appears to head in the opposite
> > direction.

Ingo, Thomas, do you have any comments from the OpenBSD and Linux sides?

> > As I stated above the purpose of iopl() goes beyond providing
> > access only to older X servers. It is a mechanism to allow user
> > programs to directly communicate with hardware through I/O ports.
> > Whether this functionality is sufficient for modern hardware is
> > outside the scope of describing iopl().

Thanks for the report.  Do you have any specific wording you'd like to
change?

> > Kind regards,
> > Dani=C3=ABl H=C3=B6rchner


Have a lovely night!
Alex

--=20
<https://www.alejandro-colomar.es>

--mbjgtmgk44ife7rx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrLxtQACgkQ64mZXMKQ
wqk+axAAnk530T4cAKKhbHLXrd7W6zNa9cEEP66Env4hKQiIxublcjmFAXxrxvrx
fjvVxt+rTvcjz8uTnwXvhdKtacB7+jJgxPw4lBN9+/ADD19p/R6IwsrnkE45Dx2s
/ZiqsKZ+S7N/MvtaG5DgZRwLJkulfFjI32g0RQRnDwUxn4yu8bPi4aO5+xtuc/WN
b2WyR1hMWIoHrvlZhTAju5Eco3RZvfiNexLfx9X+JijIBjE2V6h/6k+9qn65iyYk
XxeRQpiJ4eBR1dvVpF/eQwPuzpfkDTKLPP+qMsmUesgCTZ9LDpXJmge5viZ/Ta5n
NePfD330RUCIrAbE6ElcA8Zw00K7jWRrDzntx4ZUNQNdlfyeEXxp7zhoLMwX+oDl
lxVJ58BODbdy9kQAdbVmEjhr8xV+qTPGzoN+qcTtKy0lV78hHScCXXeSkaF6yloq
6WTvDyXEGrx2DP5hFZVDMc7mnb67/xGdCbnCePchEVUdu9YNm8jCGNnesT1y1BhY
mQcHpJYSaEbjQXZUg54TKy886vZjfs8b+nAcJ+Opo4v2Xt7KYJLH6dzaR3d1YE9P
Tk/Q4RaDPxOmhv22/saM7RVHuhSTwiFcpQ+1Hd3EkkQ25cH7N3rqaR3HRWayQoKb
sYGYnBfpQahNoItlJR95maXJjJJPRbpQRMBFxKd6uG1VY00ZQ5o=
=4HD9
-----END PGP SIGNATURE-----

--mbjgtmgk44ife7rx--
