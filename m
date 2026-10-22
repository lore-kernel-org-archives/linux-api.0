Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792678057;
	b=yEcZOciTz6zu6gGuJEKJ0opT2pyTfmh7q073RNCCOVXiB0RbF1rSJArT1PcneFG9NzW/
	 FzHU28J6AG+Z4S1QNK/foZFuh3Ljgao+Yak2ATEjM0ORjN/IZX7Joqhh04x97GXau55Om
	 HmC/+3c4HgnsXvO55Numm7lE/xywCzMtbPQvUiIW4dFUOrmu/kpOc5gzAZvNCFM7WJpFJ
	 K7uVIawSan7qgaKaRwONNbh7+9uOPM6W6B1Wej0GqsjqOxslYwUZuKURQpv98ZEnAXlwC
	 OcIEP6mc6uXZrFgHFRV2JM7UdT8hGQLvVSYfburRHXgH20Hrp4dUIPHBO0Edypp0Llg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792678057;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=ikAHeYmhUd+pSeLOt2gRZKQjxtJakarjqWuUONtXLRQ=;
	b=IcyYU/U8kdHvrhW0NdbPndxawO4CSwEBVdAQX5gpWTtbtyJI9p6igMIeqMfTBOCPVAzo
	 Jqnahjo96DfryftbuCt1vRi4M55Cu1pDUW9H2txrTskYrHblSCeWq5E6L9EFGKGGqsq+/
	 hGv4fiG4f1I2ug0d0qgb4xFdla7jRlmtg+oM1bCnrLpNjrdss2bn0B40tPtsCic/s4kdI
	 knMRkz4ZKjmteF+juu4fvEMB1ZzMoapw/YW0/XzjmHEoxatuoaDFHO1YZn/0/XnmGc5IH
	 RJ8ZvBjYHpdwlch/R78sKoDCFY5e5/rKA5BxxOjG7jrJxtVLYq4WMhgYtstIkdWb/Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=TI9y6xrz;
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DB960A2604;
	Thu, 22 Oct 2026 14:07:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88DB960A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=TI9y6xrz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1792678055;
	bh=jgEaUPG9+yoPIR3msoPQeTA36Zp16eG2kj8VeO5lFUQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=TI9y6xrz0Bl9hcBo7qIofmBdVl6cwEZONQM3APtjr3R1uTix8ANxdVu61EmMyXMmc
	 lOQDJ2nlysdN6Bea93kEwSJquflDVgDe4LWuWT+R8CGnjhbGSEi80EnlJTHqHXnZt3
	 s5RCkSsr1cBUoDPe3h3CeTNe4xV1HcqpeIHBcMLY=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 5B3741C0305;
	Thu, 22 Oct 2026 10:07:34 -0400 (EDT)
Message-ID: <db0f90dde6421c3f2ca0164ea042e73d13b4d02b.camel@HansenPartnership.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Jiri Pirko <jiri@resnulli.us>, Dionna
 Glaze <drdeeglaze@gmail.com>, Jarkko Sakkinen <jarkko@kernel.org>,
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
Date: Thu, 22 Oct 2026 10:07:33 -0400
In-Reply-To: <20261022131141.GD3008132@nvidia.com>
References: <atPgqROZZxnihYfC@kernel.org>
	 <20261017231007.GP13920@nvidia.com>
	 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
	 <atX9fugGUsI0hGcA@FV6GYCPJ69>
	 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <20261019225658.GS13920@nvidia.com> <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
	 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
	 <20261021143529.GP3008132@nvidia.com>
	 <95b895522bb314187ac1cdc5d0c143c01f0705a9.camel@HansenPartnership.com>
	 <20261022131141.GD3008132@nvidia.com>
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

On Thu, 2026-10-22 at 10:11 -0300, Jason Gunthorpe wrote:
> On Thu, Oct 22, 2026 at 08:26:29AM -0400, James Bottomley wrote:
> > On Wed, 2026-10-21 at 11:35 -0300, Jason Gunthorpe wrote:
> > > Maybe we can build a multiplexed scheme on the spare? I don't
> > > know.
> >=20
> > Direct sharing of PCRs is certainly possible, but not in all
> > circumstances. To share a log, each logging entity must record
> > entries in such a way that the relying party can disentangle them
> > with absolute certainty.=C2=A0 The problem with the latter is that both
> > the TCG and the IMA log format have unmeasured (or advisory) log
> > entries.=C2=A0 You can fool a relying party trying to disentangle a
> > combined log simply by converting the advisory entry of one logging
> > entity to being the advisory entry of another and bingo, it
> > disappears from the other log.
>=20
> My understanding was the unmeasured entries exist only to help the
> verifier understand the log structure, and what data is in the
> log. Like you might record a firmware version so that the verifier
> can locate the reference measurement.
>=20
> If they are corrupted somehow then the verifier should fail to
> understand or reconstruct the log and fail the verification.=20

That's true, but only if you know the entire log consists of your
measurements.  Because you know, ipso facto, that you should be able to
understand them all.

> It seems to me if corrupting them in any way compromises the
> verification then that's a pretty catastrophic bug in the verifier..

Not if you corrupt them to make them look like an entry belonging to
another log.  If you're the exclusive owner of the PCR you know you
have to be able to understand every entry, but if you're entangled with
another log, you can't process its entries, so with exclusive ownership
you can't discard an entry but with shared ownership, you can because
you make the discarded entry look like it belongs to the other log.

> Though I fully agree with the sentiment, sharing a PCR requires a
> robust scheme for the verifier to recover everything. If we ever
> build sharing we may not end up using TCG log format.
>=20
> > trust the entity provisioning and running the vTPM.=C2=A0 The closest w=
e
> > come to having an autonomously attested vTPM is the SVSM-vTPM in
> > SEV-SNP which can give an attestation of the ephemeral EK tied to
> > the launch measurement of the enclave.
>=20
> I understood the AMD approach a little differently.. The verifier
> gets a signed token from the CVM's ROT (in ARM terms the realm token)
> which has a hash that includes all the vTPM code (launch
> measurement), and the token's report_data/challange/nonce is a hash
> of the random EK the vTPM code built at boot.

That is more or less what I said.  For actual details, they're in the
SVSM spec:

https://lore.kernel.org/linux-coco/39cc8435-5643-4a16-8eb5-5e12f15566a1@amd=
.com/

So it's actually the hash of the nonce supplied plus the vTPM
attestation report that's put into the nonce field of the PSP
attestation report.  The proof that it came from the SVSM is the fact
that it's recorded as being requested at VMPL0.

> So the verifier can construct a chain from ROT, to the VTPM code, to
> the EK, to the quote from the vTPM, to the PCRs.
>=20
> One of the things we need to check in this series is how well it
> represents the AMD scheme where we have the ROT signing lots of
> different things depending on the GUID..

Well, I like the ephemeral scheme because I helped invent it.  However,
we are under pressure to provide a persistent vTPM as well

https://github.com/coconut-svsm/svsm/pull/1195

so attestation of that becomes a bit more problematic because you need
a chain of custody to prove the seeds didn't leak.

Regards,

James
