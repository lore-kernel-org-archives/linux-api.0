Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792698030;
	b=Nm/MHAeOzIlBreLDSSP/JtepGAD6fOTCYkHktiyzN31P0lrP4OKZ+TP2rKu+BQHeHAlM
	 G3HKaKjz3QEbCUhUZ7gOiYJ8kdGBZhNNeGOycNBxd36ok/XIrCVwZ/ndK829FK16lvYf4
	 9DuwiiRj0Ck92LZe7VEDMc7uq+3gjCFehGAbGnHoSbs8EqO5cRHSFS90LsijKFjDQU9be
	 +XYNN+A4pGmv9roXQ4HEJL6Qgi6HkhJemtwUwXRJusl8sTHSXxaLq1CfT5u4ZYrWyyGGx
	 xcn3j5H66VobDAL4D3OLxmmI/jgwbnqFNUZpf6R9mfggmdu1y7U1RaFsu1J2VtRzQwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792698030;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=CiNaSLZ7KJtfMLbnLfHgj2RCfgbqb3OCveLOdiDgu48=;
	b=BweEfvlkTo2gOK2vDrMEmaP0zOFZAL17xmSBplFq7vuALWVTtoAAyBNSQ/hj/6L0jilQ
	 hJ8hHOnK7Fs9iu9qgyG1TcJn+oeVWNlUgnyLxS71KN0JlswoA3qrObj5QUksiDqnrNnMs
	 JBtp0hGFaaCFm8VOKHJFvVr+xVPN0qruUC8x7WBOLQIZak2SclAZmvyTzieg5bvrS+g+v
	 gsjl4kSNjkTNSivo9d+By+YiLtsCaxs5zpoxPSt/h/p7Dh7jMmHC2yzWfMfDO6N2vWbA8
	 Q59rHfFpl0GEfA2ngu2rRO0VyIapqg6Z9aLQOobOSmO0mF3U14TVxJreTXbHIC7b+Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=rvuqYwDw;
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29288606A338;
	Thu, 22 Oct 2026 19:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29288606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=rvuqYwDw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1792698024;
	bh=9Ic/YqGnbUyLZfDq1sGGScbPs4lDNfkV988SadpUKJU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=rvuqYwDwD68nWH1l6G8dS1r5IBy6U4DXda/CWMk3WPbljGi/z8ys341tfoKqgedhl
	 FvhS+GGp5Rypxd7+OIU6Dlzjc/a/AfZRE1WZs+irWsgT7Ab9A3ypIP/+bK2HaMXp6y
	 X1roi+g/q7xQPJcVarxptMaoy7J8Zk8c3ntm9orQ=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 1872D1C006D;
	Thu, 22 Oct 2026 15:40:24 -0400 (EDT)
Message-ID: <5840db00eaee140e727d5597467255162625327d.camel@HansenPartnership.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Jiri Pirko <jiri@resnulli.us>, Dionna
 Glaze <drdeeglaze@gmail.com>, linux-coco@lists.linux.dev,
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
Date: Thu, 22 Oct 2026 15:40:23 -0400
In-Reply-To: <20261022192322.GD3746973@nvidia.com>
References: 
	<CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <20261019225658.GS13920@nvidia.com> <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
	 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
	 <20261021143529.GP3008132@nvidia.com>
	 <8d8833fac61558a94af415143530884349584a2f.camel@linux.ibm.com>
	 <atnqmDhgaJycTf_Q@FV6GYCPJ69>
	 <2342b42699292d4e5fc85e5dd4d351a3f29ae336.camel@linux.ibm.com>
	 <20261022185133.GA3746973@nvidia.com> <atphzdVThE9L5Kmv@kernel.org>
	 <20261022192322.GD3746973@nvidia.com>
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

On Thu, 2026-10-22 at 16:23 -0300, Jason Gunthorpe wrote:
> On Thu, Oct 22, 2026 at 10:19:41PM +0300, Jarkko Sakkinen wrote:
> > On Thu, Oct 22, 2026 at 03:51:33PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Oct 22, 2026 at 07:24:57AM -0400, Mimi Zohar wrote:
> > > > > Isn't the hypervisor what we are doing now? I mean multiple
> > > > > extension originators share the same register and eventually
> > > > > the same log. Or do you suggest to go even further having a
> > > > > "generic_registerX" exposed for every hw implementation
> > > > > allowing the user to have full abstraction?
> > > > > The "generic_registerX" would be always alias to something hw
> > > > > specific, like RTMR2 for example of TDX.
> > > >=20
> > > > I definitely prefer the latter, as everything continues to work
> > > > as is with minimal, if any, change.
> > > >=20
> > > > AI's wording:
> > > > =E2=80=A2 The Virtual Mapping: The [attestation] subsystem exposes
> > > > "Virtual RTMRs" (vRTMRs) internally to the kernel.
> > > >=20
> > > > =E2=80=A2 IMA's Dedicated Lane: The kernel config routes IMA to
> > > > vRTMR_IMA.
> > >=20
> > > I was thinking something similar too
> > >=20
> > > I called this "PCR policy" in my previous posting, but in-kernel
> > > I would expect something like IMA to request the "IMA PCR" from
> > > the current attestation policy.
> > >=20
> > > This could be a locality 0 TPM PCR, a locality 2 PCR for a DRTM
> > > launch, a TDX RTMR, etc. It keeps the layout in one place, and
> > > lets the multiplexor steer it to different hardware.
> >=20
> > 5 Authenticated hibernate [1]
> >=20
> > This is on the table at least.
>=20
> Yeah, any in-kernel use of PCRs has to fit into the overall system
> policy. Like maybe you don't want to use PCR 5 if you have DRTM, or
> you want to do hibernation using an alternative ROT from TPM..

Right; for DRTM launch we'd absolutely use localities.  The PCR5 scheme
is just a poor man substitute for the fact that in non-DRTM launch on
x86 the localities get restricted to just 0 so we can't use them to
distinguish in-kernel from userspace use of the TPM.

Regards,

James
