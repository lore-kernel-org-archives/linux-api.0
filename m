Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792671993;
	b=FixSCkYmY1d5PpEi9yt7uT+xgR7fESaFh4bQCVfFSF+KTKkYJ/ReVVpXw2iHm9xEj7Mm
	 wqRASjvkRvgaOEIo6aC44rctLqadRWkmRoe8Qg4voDavX3OIeTZ33N50qAADrITUWCzdp
	 90RTf2cQqziASO07i5Weqxs+WllNK1FSmPKmNwCJCpJ2R/rZNkLjTBfUV8GlYdhUMLilO
	 uTbg8Sh0l1m7m5raGXIzjiZzW7WAkV+p8dE/juPXlcDAtBWjuThYTqOBPbmTwFAYxR9Pe
	 Wzmb03yLSYYZuPgE19KNIHVyxtAAML0H5EI1fm9YU22e8A4sJxQ8UawDoxCFo81QGug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792671993;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=PlIg5b7irtC1ondYsmLGatfliSaS2p5mdAGGu46MnQ0=;
	b=FE1cFYrsAIKcB2QChp96RARWXkP+IF444xuiZzrQFxFLO3tYkOJeUs7br/ratvUcsmTY
	 LFXaT9smr1h4/8BfW1ZCdE85d4Bq0NzkCQgcpxImx8yAxPkE/0ugC37o0tfzJPtvI1WGW
	 RweQbfakHnmxxqYW2x3+UBAp47mIZBc2I9Zj07NcA5gafZfhslBwkJ1wIl0rmuuQOmug/
	 3Tidi9lcIR7xM/aRrBnxwLLYFL2KJnGZdjV3PJOhpdBjyOG81bOInVp+ED9FQAFkjeOGl
	 YnqscdRPUqJKSy2W32yxj7ZDrg6Xeam0Oh3e1jeRNpC0chf6JCLk/0/7YhxPdtnAtqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=vLQPfAKw;
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230CB606A31E;
	Thu, 22 Oct 2026 12:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 230CB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=vLQPfAKw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1792671990;
	bh=/abHNGNy6tDdomJVZc/PG1jQyE6PJ7b2S5L8Y+aG550=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=vLQPfAKwvImWH/l6HXVWXau4QGrIAPps/FXIooqdo7aoy/rqiLlkf53bQ3eAa5M+f
	 6q3/LIrjb2xovhMNPIBbjeyhU9kogTKdEn57BY4Ex2i3ukX+qbr8TA4ofn+ZGwnkGT
	 L2h+bEz2kOnpCuzkmIFubvMzPaW/2ZFO3Ubd++M4=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id D6CC01C0220;
	Thu, 22 Oct 2026 08:26:29 -0400 (EDT)
Message-ID: <95b895522bb314187ac1cdc5d0c143c01f0705a9.camel@HansenPartnership.com>
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
Date: Thu, 22 Oct 2026 08:26:29 -0400
In-Reply-To: <20261021143529.GP3008132@nvidia.com>
References: 
	<CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
	 <20261017203407.GM13920@nvidia.com> <atPgqROZZxnihYfC@kernel.org>
	 <20261017231007.GP13920@nvidia.com>
	 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
	 <atX9fugGUsI0hGcA@FV6GYCPJ69>
	 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <20261019225658.GS13920@nvidia.com> <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
	 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
	 <20261021143529.GP3008132@nvidia.com>
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

On Wed, 2026-10-21 at 11:35 -0300, Jason Gunthorpe wrote:
> Maybe we can build a multiplexed scheme on the spare? I don't know.

Direct sharing of PCRs is certainly possible, but not in all
circumstances. To share a log, each logging entity must record entries
in such a way that the relying party can disentangle them with absolute
certainty.  The problem with the latter is that both the TCG and the
IMA log format have unmeasured (or advisory) log entries.  You can fool
a relying party trying to disentangle a combined log simply by
converting the advisory entry of one logging entity to being the
advisory entry of another and bingo, it disappears from the other log.

There are certainly ways around the problem by doing indirect sharing
(where the real PCR logs measured capsule entries for each virtual PCR
including the virtual PCR entry) but there are no standards for
attesting, or quoting, such a log.  Even if you look at our gold
standard for virtual PCRs: vTPMs, their quotes are only reliable if you
trust the entity provisioning and running the vTPM.  The closest we
come to having an autonomously attested vTPM is the SVSM-vTPM in SEV-
SNP which can give an attestation of the ephemeral EK tied to the
launch measurement of the enclave.

Regards,

James
