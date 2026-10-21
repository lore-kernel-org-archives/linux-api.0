Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792586912;
	b=OPWqAGKaAy8iYajLKN6mnInCB2Zs1cutndsFBk+HpWnUJ7ds9fNxPedkRuL8KYYU5YYr
	 UCme/XcfHuJdAragXKa5jimZYWK8piCMG6Q4UaXq2DeNiDNszqLmSkUlmvyVIY25LO+Lx
	 SECTo9fMoKWTJCyw9NDn3aXL0dj7/SruDobKQrkXsK6OBVy8FrndcAL2nJIttldeP5a1M
	 c5WHiEwLY9jCgCnJHFb7fA/vDjPZdD5wDoPHd8yNeU1z9GaPIuGEAo12Bb+AjY4ecP1o3
	 kNbERyqqeQktcyGJPO/hlN1z+phYww5+ZjK60+KqBp5Wqf2A/MFm058niegeSXP/TCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792586912;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=fB3c16dZ4D+sgSMKdvK0GZkHU/5aGTEdEdwnyDxGg40=;
	b=GdD+/sI8LlW7Ip3G4B6sh/aCFAVzDlujWaH2l/GY2+e9lAfrnKyp9QC89/Pl0ThvD9z+
	 YqQJDsb+zk/5AEGYhOs0QtAuUTYe6zAiF3WJ1v3e86oKXsF8z9OWMZT2SpoM+l7jsfnSp
	 WsBCjr82jTst6dJ9ogCxEMPG8bNKyjo2pSzLVMDA2ooTty9fSPJj0bhpiFJG5XRwvNoxj
	 X8VGBMiOmUAN7jHY8I+D63fmyXvAnH3mZJTooVz/wLhVk4jtfNbS67+NCQipP1i7If1M+
	 tO3UvrMdnual++0tykNRXeebozgh5n7VhBcMJkEj0wCGwkSWU7WR4t4PoK8gwnBfDew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b="VQNvl/SE";
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6495F606A31B;
	Wed, 21 Oct 2026 12:48:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6495F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=VQNvl/SE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1792586910;
	bh=HZGAUyKGHPlO5/W6rSvUQbyUWcZMQLA57dSjwnEKhSc=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=VQNvl/SEXE0TKy6UkQmfLJOCRXEm8lR0KvLV5vByn8LQ38xa8T4PfOFbQva8XRlKG
	 Oj+6wJpO3fl2IH5ndx6I32uU+ek4ZefFd+5ntdNueOsxT95SnQx5J3ODn1UtF44+PG
	 fFZ3bEaO/QvGT266qqj3fKTfzwYBlk5PjQCAOmMY=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 42CD61C0372;
	Wed, 21 Oct 2026 08:48:29 -0400 (EDT)
Message-ID: <2641f9f5141126af8a93763fcbdd2ffd5c4e520b.camel@HansenPartnership.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, Mimi Zohar <zohar@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Dionna Glaze <drdeeglaze@gmail.com>, 
 Jiri Pirko <jiri@resnulli.us>, Jarkko Sakkinen <jarkko@kernel.org>,
 linux-coco@lists.linux.dev, 	linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org, 	kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, david.quigley@intel.com, 	lukas@wunner.de,
 ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com, 
	sameo@meta.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com,
 ankita@nvidia.com, 	suzuki.poulose@arm.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, 	elena.reshetova@intel.com,
 dave.hansen@linux.intel.com, 	sathyanarayanan.kuppuswamy@linux.intel.com,
 peter.fang@intel.com, 	roberto.sassu@huawei.com
Date: Wed, 21 Oct 2026 08:48:28 -0400
In-Reply-To: <ateSly15N5mLrM1m@e129823.arm.com>
References: 
	<CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
	 <20261017203407.GM13920@nvidia.com> <atPgqROZZxnihYfC@kernel.org>
	 <20261017231007.GP13920@nvidia.com>
	 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
	 <atX9fugGUsI0hGcA@FV6GYCPJ69>
	 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
	 <20261020140655.GV13920@nvidia.com>
	 <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>
	 <ateSly15N5mLrM1m@e129823.arm.com>
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

On Tue, 2026-10-20 at 17:11 +0100, Yeoreum Yun wrote:
> > On Tue, 2026-10-20 at 11:06 -0300, Jason Gunthorpe wrote:
> > > On Tue, Oct 20, 2026 at 09:45:13AM -0400, Mimi Zohar wrote:
[...]
> > > > To support this framework, IMA requires a strict, atomic
> > > > execution sequence to maintain the Measure =E2=86=92 Extend =E2=86=
=92 Execute
> > > > (Measure Before Use) guarantee. This initializes early during
> > > > the late_initcall phase within the initramfs (via dracut).
> > > >=20
> > > > If the new subsystem introduces a direct kernel-to-kernel
> > > > multiplexing call path, how will it ensure the mandatory
> > > > synchronous wait behavior when extending multiple hardware
> > > > backends?
> > >=20
> > > Everything has this 'measure before use' requirement. Why would
> > > this be hard? Just loop over all the configured measurement
> > > targets if thats the plan? Maybe I'm missing something?
> >=20
> > As long as the measurements aren't queued, but actually wait for
> > the multiple ROTs to complete, it isn't a problem.

Just to be super precise about this, it's the extension of the
measurement to the TPM that must be contemporaneous.  We have a few
examples in UEFI where the TPM gets extended and then a bit later (when
more stuff is ready) the log entry gets added.

Just on the waiting for ROTs to complete ... that's not accurate for a
TPM: the ROT, which is effectively the initial measurement, completed
long ago (in TPM terms this is the RTM - Root of Trust for
Measurement).  The problem is actually a communication problem not a
readiness one, see below.

> But, I have a related concern about deferred probing of RoT devices.
>=20
> For example, if TPM probing is deferred until after the attestation
> subsystem has been initialized, how would the subsystem handle the
> TPM becoming available later (This is reason for IMA_INIT_LATE_SYNC).
>=20
> In particular, when I see breifly proviers/tdx.c and imange for TPM,
> once if it's failed to get tpm_default_chip() in module_init(),
> There is no way to retry and TPM seems not to be exported as RoT
> device.
>=20
> Am I missing something?

Mimi already answered the main thrust of this, but there's a corollary:
because of the early init requirements, the TPM driver must be
available before the first non-EFI kernel measurement is made, which
means TPM drivers can't be modules.

The reason for the above in a UEFI system is because the
ExitBootServices() call in the EFI stub kills the UEFI TPM driver, so
there's no way of using the TPM between that call and the kernel
initializing its own TPM driver.  I've often thought that if we could
prevent that and have a separate callback to kill the UEFI TPM driver
(or probably one before ExitBootServices to say please keep this driver
and then another to say I'm done), we could effectively use that for
early kernel measurements and then engineer a handover to the in-kernel
driver and then not be too worried about when the in-kernel driver
attaches.  Of course, doing all this would require a UEFI spec update,
which means it's not a quick or easy thing.

Regards,

James
