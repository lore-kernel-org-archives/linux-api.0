Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793029373;
	b=OiT1Wow/kAiCD7W+nETaIJLUxzq0SQB/wGbzm+eChIRvfqSJrJ13O5mDwo+9iMToHFgE
	 YdJWSw8cGuWGfJ3kOGQroYZk2DvTCHL0lZqA6Js92etkWMG7Gv0qZE9JBIG+AExuKOzGH
	 qj7J5lXGJTQn1BG8JGxZX0McwddVnacnqxzodCNoheYIGOPcl1sIEq7xUmekt+HrAD7Rg
	 zj1PT5gsybmyn3SwDcDHbs05LbUxg+b6msD4TY8Gugs0CD0KsGaoSxoYtdWTUpdm6svxN
	 xQnqsxMWQesDOr/5ABoLkrfEfB/RCIj1k1lUtKBBgefOB9imPgdr7fdLlP1AWaXnCSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793029373;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1WrNMOB9HEon2VbrP0JrPTeRRbxo0PgTYjxSomwfwDw=;
	b=g8oFlbe3kPg1BINQd1NT5zqvwMQ9s9qRxIEVLCB96CjrDPoh3M2oL/NR2HR4n24HLFyb
	 U/cMyV0sRz+oj6RYR8nsT/Pllsp/Noow1EWJv/zS0jLzPJRDtpgmRX8IdKZzodl2AhY77
	 QkEGI4cR0P5iiD24ow6uEhp5j+bjY88OcsyjEImCLOfzgZzmu7D57ILLmuUzWWJ4kZwtp
	 Xa/mEZCALTHvm+Jd6KvdddM4utesJAxJzHaYFsnoC7VyHNLvY8LtB8UInnxLHBFfU2aBe
	 Ga2wXciW15viLUBGx0+6RiuXDLRm4gCfuYzUjGsIwLl/B+35VuZAMxF8SmHx/HDhMeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="PDNRJ/jh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D16606A31A;
	Mon, 26 Oct 2026 15:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PDNRJ/jh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9625A1F01825;
	Mon, 26 Oct 2026 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793029373;
	bh=1WrNMOB9HEon2VbrP0JrPTeRRbxo0PgTYjxSomwfwDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PDNRJ/jhNZPTKQL/wWcCOFiotYB9RbTgJu6Iqmh1TaDFo7OtBvKiuQoMlR/Hx171R
	 oXJkchD6KEIai9VvvVLJ2XBCslCFzwc9I9coqyxEwXyMTT4REpH2ZOUDfw2sEzdPAM
	 9YWRJVBZ3FYu6uF8rv3DGGy6WXTeGae9IOtPNzGhlhnf1Cmuuw8aEQWuPezTVkT+7Z
	 ACuXE3x/h86DGGHDJ3bLFWHurelYc//YdlWpeHpLeLmhljbgStY3PNXXL34Z8yrpf0
	 U9y34/v5x7VajWvFpitmJWpOteltnFQXou0VE6+G1bL+ZCbcT0Ch0+qXjBFtrtWWfh
	 8OWrppyr3Jzbg==
Date: Mon, 26 Oct 2026 16:42:46 +0100
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, 
	linux-api@vger.kernel.org
Subject: Re: [RFC v1] man/man2/at.2: Add page
Message-ID: <at90QEmbZ2bLPdTc@debian>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <at9GMQsNivNuE_jH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
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
	protocol="application/pgp-signature"; boundary="fuzsevfckz2eilts"
Content-Disposition: inline
In-Reply-To: <at9GMQsNivNuE_jH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>


--fuzsevfckz2eilts
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, 
	linux-api@vger.kernel.org
Subject: Re: [RFC v1] man/man2/at.2: Add page
Message-ID: <at90QEmbZ2bLPdTc@debian>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <at9GMQsNivNuE_jH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
MIME-Version: 1.0
In-Reply-To: <at9GMQsNivNuE_jH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

Hi Andrey,

> Date: 2026-10-26 13:27:16+0100
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
> On 2026-10-23 19:40:37, Alejandro Colomar wrote:
> > This page documents conventions common to several system calls
> > (most of them conventionally named ...at()).
> >=20
> > Signed-off-by: Alejandro Colomar <alx@kernel.org>
> > ---
> >=20
> > Hi!
> >=20
> > We have a lot of repeated documentation about these system calls, and
> > each one has sligght differences, and some syscalls even have actual
> > behavior differences (such as some accepting NULL, other not, and others
> > documenting that not while they most likely accept NULL).
> >=20
> > This documentation aims to unify the behavior of as many at() syscalls
> > as possible, and document the odd ones explicitly so that differences
> > are known and justified.
> >=20
> > If you maintain or know of system calls that don't behave as specified
> > in this page, I'm very interested in having a disussion about them.
> >=20
> > If you know some mistake in this page (for example, I have not yet
> > documented anything about NULL, because I want to have a discussion
> > about it), please also let me know.
> >=20
> > I'll reply to this email with a copy of the manual page as it looks when
> > formatted, so you don't need to apply the patch to be able to read it.
> >=20
> >=20
> > Have a lovely night!
> > Alex
> >=20
>=20
> Looks good to me, this should probably be a series including patches
> which update other man pages to reference this. Wouldn't it be
> better to describe differences on the pages itself, for examples,
> for file_attr:
>=20
> 	The dirfd, path and flags arguments are described in *at()*,
> 	with following discrepancy - NULL value could be used for
> 	path argument meaning empty string.

Agree; I'm working on patching pages to refer to this one.

And also agree: the differences should be stated in each page, and
avoided in the main at(2) page.

However, we should minimize differences.  And also, there are
differences that are currently undocumented, and we should discover
them (by asking someone who knows, I guess).  Who is the right person to
be CCed on this?  Do you know anyone who's been working in at()
functions heavily?

I'll send a v2, with some pages being updated (still incomplete).


Have a lovely day!
Alex

--=20
<https://www.alejandro-colomar.es>

--fuzsevfckz2eilts
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrfdPYACgkQ64mZXMKQ
wqnXbg/+KHOBRHr43ssHwgTWNcP5UBgO9z/WDGMoHdq9awo441YhlSlBA4jBY7EX
Dm+79fEVrlQnR8qgsQuBnlHR5m5BYHlNg6FKioeTT85423kkfRJpD3l5qwNOfSkx
QwFBwazV0Dxgyvw2u+SITnsWPC+128YgvPEDlwcaTDauPOeN8fJbZvEixW2bq8aT
L2wHF9OkMK7fVWqfz1ZjGzBev4zJOuRsxfkYIWJ4oEenTvl22xHf+wm4AGQWSqAP
bb+qK8GmOwHII0rkv2cPaVHlwqzrVOXi9JFtBJa6k7iTAMYIuhjuRSeWV2N00sVp
RnrUNt3gKgyerTtqd5yhJ7L9tf1LZrdl/oJmogI4HxT8z4VZWMzZkXdsUB37Je73
gIzwpvcjHviKuYVaR1TCExMBVA7VkU5XDOIbs4hVSaxrgL1RCUQG6DhR2kSAFkfk
bAi8TT3uxKKLAycG3XEJWGmBGjtqD2gc9XuD6F04VcHFrx+3qfl/sXCc+AEpaTJm
WzGjzzHrerzMdfvNWH0FGxLw5SCUg74BoOgj3huu/qQBwICwTKWl47LjWMhwJqtb
gDk9n1fT5aMladSHRBioNVgC1gzPDJTDreKtcKwrjqgRTDXhmciIAV5pO1TZ/kdz
Q256GHfWn/XLdZ38jn9znm5UntsIG4IxfCn13+C9nt3/aIoNu3A=
=TNce
-----END PGP SIGNATURE-----

--fuzsevfckz2eilts--
