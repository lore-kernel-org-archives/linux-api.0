Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105311;
	b=ykJXaEw5TbsbO3s7xFdyZS1HAHR/J03n5gss42BfUBy2uHsZYTesqB595TsaiMPkHokK
	 zdZb95toOCSMRjmkH69wwVnfLdA+tm9WlRlP3t/5czUV5nqmAfSTd3pKfjfZuBNVG5vOH
	 hmeWUk1iAo0mUSQKU0S2NOmMHbYPHk+IKXKtCcPTcMsE/CmyC1+0CQB7gFiX6ROo4XxcI
	 fhuvZBMY8XaRE6ouIApEVLL6jqynHrwRJWPMyju/DAhvRiBvSGDMZzzzfivYhZSzDei0V
	 DEtQTFzR8svKKsDPaGYYr1WofrmIwfUMwL9noGv6crEJaNRA3D+CueFMlt7PgYGkC3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105311;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ogwuGK0yggXwyq45YKr/fwg2TxpvW9p6nHWOQhtoq4I=;
	b=MaBplTJma5DpGqIyNzJtCOOsOEOUCFTMW4Wq+XnHm2Naxv0fgj7gxLL6oss/y1/BHyXq
	 8LwG2gxrvf6/Bw+IbQYTra0qDaYUB8zuUYbgMD+H8Rql5fueiKARcqE0Pcj/b1eWhlscj
	 No1CkQKAp5DIoz94FybbrbAVtpAjFeqajxdsdywhLQOEsNZ0uPTaEx9s8uMItweud2YA8
	 KS6LfHGFsLFQGtUU72lFBxt0S9NaG9//EGyfwDYRgqtAqUWV1wRjg96be5NPiVnVMpKtv
	 P96VAFxjvnkCmfH0xhA34WHJSNj7adGsUm74QeVSpX5BYAdklKYEyh0B1KzKISgwEfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bEyVbTMZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE836070D5E;
	Thu, 19 Nov 2026 16:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bEyVbTMZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263E01F00932;
	Thu, 19 Nov 2026 16:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795105311;
	bh=ogwuGK0yggXwyq45YKr/fwg2TxpvW9p6nHWOQhtoq4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bEyVbTMZqA60ppB2VMFcMUfj4WYvq8nW+47qQuq/k05qCfuwcgMjNxyY2UCKUkeJL
	 BASHzdhXItBRt2uaAzjFFsSB4dMD20MM44LnWNDeabs5SILybthN8cdUds+wpB//B5
	 trX5H6OEYWX5CVkaLsyA+vtlabx3jBUiad0HQGUYr51gTWG68t5HRbkrqdGPNCGcS+
	 yQioZLt5xE8n8a7qN2pygXHM58GXHxcr3jwj+79CrcuuiWQ46QD3WbgwPqCKzczlo/
	 R0pNU0mQrDHHpVRfwvnI1STl8VCJwUx/0o7E4KR8alOzdz4mTEFIu2/wASkjik9aIu
	 BTmCS8hwjeT3A==
Date: Thu, 19 Nov 2026 16:21:45 +0000
From: Conor Dooley <conor@kernel.org>
To: Zhouqi Jiang <luojia@rustsbi.com>
Cc: linux-riscv@lists.infradead.org, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Dongliang Mu <dzm91@hust.edu.cn>, Anup Patel <anup@brainfault.org>,
	Andrew Davis <afd@ti.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Alejandro Colomar <alx@kernel.org>, contact@rustsbi.com
Subject: Re: [RFC PATCH RESEND] riscv: sbi: expose firmware identity in sysfs
Message-ID: <20261119-zoning-appeasing-71d648cfc78c@spud>
References: <A039A2DE1DF8F274+20261119130356.1537-1-luojia@rustsbi.com>
 <20261119-borough-flap-6481c20b3013@spud>
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
	protocol="application/pgp-signature"; boundary="y4ha9iLRTx8cil11"
Content-Disposition: inline
In-Reply-To: <20261119-borough-flap-6481c20b3013@spud>

--y4ha9iLRTx8cil11
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 03:57:19PM +0000, Conor Dooley wrote:
> On Thu, Nov 19, 2026 at 09:03:56PM +0800, Zhouqi Jiang wrote:
> > Linux queries the SBI specification and implementation identity during
> > boot. It caches the specification version, but discards the
> > implementation ID and version after logging them. Userspace therefore
> > has no structured interface for this immutable firmware metadata.
> >=20
> > Cache the implementation ID and version and expose the available values
> > as read-only attributes under /sys/firmware/sbi:
> >=20
> >   spec_version
> >   impl_id
> >   impl_version
> >=20
> > SBI v0.1 systems expose only spec_version because the implementation
> > fields were introduced by the SBI Base extension in v0.2.
> >=20
> > This gives tools such as lssbi a native source for basic SBI identity
> > information and starts moving those queries away from out-of-tree
> > kernel modules.
> >=20
> > Codex was prompted to research lssbi's out-of-tree SBI probe and design
> > a minimal in-kernel replacement. It assisted with the sysfs interface,
> > implementation, ABI documentation, changelog, and QEMU test setup. The
> > result was built with a RISC-V defconfig and boot-tested under QEMU
> > virt with:
> >=20
> >   OpenSBI v1.3
> >   RustSBI v0.4.1
>=20
> I like this idea.

FWIW I tested it with the polarfire hss.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

>=20
> > Assisted-by: Codex:GPT-5
>=20
> FYI, these tags are now deprecated.
>=20
> > +static ssize_t impl_id_show(struct kobject *kobj,
> > +			    struct kobj_attribute *attr, char *buf)
> > +{
> > +	return sysfs_emit(buf, "0x%lx\n", sbi_impl_id);
> > +}
>=20
> Should this actually be printed as a decimal? It's a minor thing, but
> the numbers in the spec are defined that way (see 4.9 SBI Implementation
> IDs in the 3.0 spec).
>=20
> > +
> > +static ssize_t impl_version_show(struct kobject *kobj,
> > +				 struct kobj_attribute *attr, char *buf)
> > +{
> > +	return sysfs_emit(buf, "0x%lx\n", sbi_impl_version);
> > +}



--y4ha9iLRTx8cil11
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCav8iGQAKCRB4tDGHoIJi
0nchAPwMyGXXDEqHemrcQzyFtqOcbeumL62PWeRJvAlUUOXxNwD9FVOQuhadciGN
6UYfq66MOZYm68669t9iCZtqoa1xGQ0=
=IiQb
-----END PGP SIGNATURE-----

--y4ha9iLRTx8cil11--
