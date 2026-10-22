Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792698751;
	b=0EBhy0SA63WPlYdaT1682I3BXDMaY2tIiMbKCS8IZiztQHM1OjXlS6mulgfaFRZcQ/T/
	 COpkrnbNB/VPPAJWV8Pye+vY3StZn3zHG+LeUYs5O1gooqvbVxVj3o+azT/ytwAsMS9HY
	 YO6P3mXm9gXOyNUQq4gwpy91j79au7jCdq1dtvREXCSEsA5Y+U6wP9caYIg+oEr1FRUku
	 CDlj5LGN5gDSAFMOm5gsSYO+3J1nryUXmuj7hgnLgLYJlSYd7kaiTZobnQs1qVFrixoAg
	 BTUhYknkF8/JK5VIaZTcSGJIzdM209fJPrp+xwgKZBkSlkmnBGafDTpXlRV1J8kW6Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792698751;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=iITsCaDoR2wRK6QR8PxH+D2OefapnUznwanjO6I0WB8=;
	b=g3r7A3kq69w0F02+M6g5hZgtEqJ2bIxATPnYm+PXpHQpJeR6/TrVFC3UetTNmM3NS3b/
	 BMFRug9prnxzvq2e2OS/MsP3IuJ7QKPOBLKmdkwTjoK0NCgtVmPkwN34uRRm8ML0cwqkJ
	 aF7se34L9zx2Vj20GodZ2esyrSadg6Pc3MvlN/LAhCC2CVDiPvgc8eWGvKo8pqpfDC4pT
	 DgQ3++9mISlh8XMmCGcPAgxU8EhD+tloxv3SGKo11LOwZqaicA83hmPrlj/0gfZ8A33pI
	 WuR4YXzpCKNSYo6lhPlJofn7MD5pF3k9WOpDdUbqj+HQJO8Byyhh2dr23m/3kZYHDeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=L9h1clPV;
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEA7606A31A;
	Thu, 22 Oct 2026 19:52:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DEA7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=L9h1clPV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1792698750;
	bh=BvdrRZOCMvMIJhNryp7q/vU2kHzDW0VLWASRL9wdWXc=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=L9h1clPVfOQI7X7Dq1yxnXQ/zy/GBxNLCyRvZ0U0oBRyqEqBzJE4vBz13P/yNmgRB
	 00MbbUFE4mL72uyxFGbwzlkPr4MIl1BADI0h4CIwxkQgzbCUMTAsMc0WtSCJcG5kaf
	 fjDSkUaBwT2w6MKlhrK+jd41mviAd3Ek1vJXyiJA=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 419AC1C0594;
	Thu, 22 Oct 2026 15:52:29 -0400 (EDT)
Message-ID: <827296091dbd27becdf85ad8301f94cb16025afb.camel@HansenPartnership.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Mimi Zohar <zohar@linux.ibm.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Dionna Glaze <drdeeglaze@gmail.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, 	linux-api@vger.kernel.org, x86@kernel.org,
 kvm@vger.kernel.org, 	linux-doc@vger.kernel.org, david.quigley@intel.com,
 lukas@wunner.de, 	ksinyuk@kernel.org, rodrigo.vivi@intel.com,
 cedric.xing@intel.com, sameo@meta.com, 	aik@amd.com,
 jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com, 
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com, 
	roberto.sassu@huawei.com
Date: Thu, 22 Oct 2026 15:52:28 -0400
In-Reply-To: <20261022194527.GE3746973@nvidia.com>
References: 
	<CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <20261019225658.GS13920@nvidia.com> <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
	 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
	 <20261021143529.GP3008132@nvidia.com>
	 <95b895522bb314187ac1cdc5d0c143c01f0705a9.camel@HansenPartnership.com>
	 <20261022131141.GD3008132@nvidia.com>
	 <db0f90dde6421c3f2ca0164ea042e73d13b4d02b.camel@HansenPartnership.com>
	 <20261022191911.GB3746973@nvidia.com>
	 <d3274fc7bea368e7e117fdffcff2193210d9d8b7.camel@linux.ibm.com>
	 <20261022194527.GE3746973@nvidia.com>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Thu, 2026-10-22 at 16:45 -0300, Jason Gunthorpe wrote:
> On Thu, Oct 22, 2026 at 03:37:46PM -0400, Mimi Zohar wrote:
>=20
> > > Advisory entries shouldn't matter with a scheme like this.
> >=20
> > IMA has something called violations (e.g. open-writers, ToMToU),
> > which are more
> > than just advisory.=C2=A0 They intentionally invalidate the IMA
> > measurement list
> > since the measurement cannot be trusted.
>=20
> Maybe I got lost, but when James said "advisory" I understood this as
> the TCG type that does not get included in a PCR extend.

No, I meant the TCG type where the event description isn't part of the
measurement (and thus can contain pretty much anything).  In IMA
measurements, the path is part of the log but isn't part of the
measurement (primarily because it's not reliable: a mount namespace
could make it anything it wants).

Regards,

James
