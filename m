Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792500587;
	b=Ufeovq8Z723Vhg/JvhPrgOQO5xnSRxEdyRjqwe5P5Dt1HSr9MgoyoFObHws8nOwiFFX2
	 ELsynx8HW+8+FnYVP+BO38OPEsPpII1DKwqPk8dUDzGwALnYknn0U8todVjcOGbKhIq9A
	 6wqAIeuvVi4xA1maXhBd8VH2au98H4i+GxBm7gKNTnMZJoFXWf2rHVmDMjUdqJDHh8Idr
	 TwLijoBgSLkOpWUA7HwjWhrabw4Q3VDGX7RHDlLfqddFUIUSoS9MTk1x3wJH2wQKumq3j
	 xgvNkGbqVHvle07aiP84vUVNwdd2JS7+z7HCRPHQ2F+fVFF6YK71aQXchb3yKilucbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792500587;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=TIOCIITuSbPT2liliRicmMIM7M6l7fcTvqwiPQyOtNw=;
	b=P3qcUsXQ//AA7x7CswRmqV2A87fWDuhEqj/BoADjlOGF2IguneoLCp2hAEU1Mub8mxe8
	 7pDQk5EX2OYvkrZyjhE421hqE+GtMaMkJawTORIgnjfT7zZpOhdFBpBZ3Zn5w6QtTFbMg
	 S/J+nZPFwngMlornhxMv6qCmskwJgJLkWc/gMEuGIegSc8Q5LboclmhJ3yCDNYAG5J6As
	 gsInHWixsUuAgo5C2sO0JMc4WolsYXTlchZ45E5bKfmwISGev+IBifMaDDYM73jk5NVIg
	 l1+AIoYtFfSZGGBkq92b+6CoKqiLD0FKo17/DOfr+ZELoBz3aPl9GgRHgXjHWqEpOTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=dVs7pl3h;
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1A4606A31B;
	Tue, 20 Oct 2026 12:49:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B1A4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=dVs7pl3h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1792500585;
	bh=VLXJnQpgYJsKuCzhfylAqjVbAh/vojMAxeKyxjm/3TA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=dVs7pl3hCB3VWFPSgI+hHOexpiUyS/N9H3kuThBW+L8MzuKlAjsYIVX7pTAnVNPNm
	 khcRTxSYm0O4T17yeuI6drMgpKYOgs43KW3wlEpT/1Imr8tPyyoVR9dWRThcwLFaj4
	 2IAvrcvFLhjSiLZGwcwIJAHunDVrrcIwmW8UEWMc=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 5CF861C0118;
	Tue, 20 Oct 2026 08:49:44 -0400 (EDT)
Message-ID: <31f7f221d7b63732d057abe064e5b23869103600.camel@HansenPartnership.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Dionna Glaze <drdeeglaze@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, david.quigley@intel.com, 
	lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
 cedric.xing@intel.com, 	sameo@meta.com, aik@amd.com,
 jpiotrowski@nvidia.com, qinkun@google.com, 	pgonda@google.com,
 jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com, 
	jarkko@kernel.org
Date: Tue, 20 Oct 2026 08:49:43 -0400
In-Reply-To: <20261017203407.GM13920@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	 <20261016234354.GA664420@nvidia.com>
	 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
	 <20261017203407.GM13920@nvidia.com>
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

On Sat, 2026-10-17 at 17:34 -0300, Jason Gunthorpe wrote:
> On Sat, Oct 17, 2026 at 11:16:07AM -0700, Dionna Glaze wrote:
>=20
> > > About 3 months ago we started looking simultaneously how to
> > > support roots of trust (ROT) HW in place of TPM and how to
> > > respond to the feedback on the netlink proposal for the TSM SPDM.
> >=20
> > Given that I was tagged on this thread and not that one, I'd
> > appreciate a pointer to which you mean.
>=20
> https://lore.kernel.org/all/20260705220819.2472765-2-djbw@kernel.org/
>=20
> And then later this:
>=20
> https://lore.kernel.org/all/20260921131911.532d81f4@kernel.org/
>=20
> Basically: No netlink.

That may be the local driver for this particular patch set, but the
conversation about how general a system for tracking attestations
should be is much older.  When this all first started as coco TSM, it
was very much an Intel only RTMR tracker for TDX.  The arguments for
adding TPM2 are simple: SEV-SNP doesn't have RTMRs, so if the system
were to cover non-Intel confidential computing then it would have to
include TPM because the way SEV-SNP was going with the SVSM was to
include an enclave protected TPM to do the post launch measurements.

However, the next observation is that there's really nothing
Confidential Computing specific about this (it's just exposing
measurements and log entries) so if it were to be provably general, it
should also work for the existing TPM logging and attestations of
measured boot, so it seemed reasonable to add that from the beginning
to make sure of the generality.

Finally, there are uses for non-repudiable logging even from user space
(attested build systems for instance, or the use case we had when I was
at IBM: attested firewall changes) so if the kernel exposed a generic
system for doing this regardless of underlying technology that would be
great.

I get that there are some things that can't be generalised, like the
form of the signed quote which is highly technology specific, but it
does look like the logging and extension piece is similar enough to
admit a unified interface.

Regards,

James
