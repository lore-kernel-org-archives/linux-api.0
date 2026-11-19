Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795103845;
	b=H3k1wJDKoHQFhl2SPOpNtgT14iG79sPI+WDOWyj6r8hIUsahwC0w0vKyEpN+YhtvvQlH
	 yUJi6Q9WOp6a88eUvCUqHwiWR2W3nTYZw+QSDmDy7f3ElG8N/FOU3NMX56RQv93vZvjys
	 Jm1/QGhmkWvJMx5qd4OpHlUxsxlDtnl8lpQC7fTa7Q45exBxwvz0X6WubBJpenko+U4t2
	 NAtOhMZVs1iC76/L7dUdtobWOmBzhtacxbciaoO2qQrkkjLuamuDoNfpMtck4jZwdTMoH
	 upNffsXdKWMdT3+BHoxozw+TKHZsHT03nBeN3IGJ5wSkC0sh3x66tWqUT3KORujSDPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795103845;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gHSpicP6AXFH7Eu6+1T0bXY5QULxN/p2WvEf/j9QhZY=;
	b=mWH2JL28BaMH4+MhRZVP909w/lejUwlMxjNIqy0NKGs7xGtJ3nTkySeoNFpSEMCbvDko
	 inYzkL+WF1Y0vlfXoAqArdF5qmS8e5CzEh/V3aZiB158Wu2vhPK0CNblm1lVAfR3AOqhT
	 7WbhGO0DBKsGIGoJtg+F0hZOEn+rfOs3+D2NAUwKzioLR3ofA6MdIfpDK+0/i2RE14M+J
	 x8KAnLwT6B+Hv0KoNRx4D2nRPDW6qqxYmdqh7ExM/EebMgGtIrhdGw0Ty7qP2E/kKczv2
	 qvEL+GuDaBnFMtJJy8hJKVNC7EQZCNjjk91X09sqfh4qPJW2zyMRqXa23Im2euoTxmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FKfasLxJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED679606A331;
	Thu, 19 Nov 2026 15:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FKfasLxJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120ED1F000C5;
	Thu, 19 Nov 2026 15:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795103844;
	bh=gHSpicP6AXFH7Eu6+1T0bXY5QULxN/p2WvEf/j9QhZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FKfasLxJ2K3Ih6qLEsySOLePVg5YZLK07DInZ1YwZ4gLik0V9ZbaMeCr0IT0LFL0A
	 03jp2D4uQ7p9ljlD4guOcB3NHk56jxD0YjqFuapwYGcQbyxPBxecNLv6NeR5Uzxcw7
	 wTq1bozLgO5RoxQ/d2PTjHSCaYTwrFBhoEgxqaveOzpH04HitUVolZ9JUrZ9Fu10E3
	 fqP2ex60h47uU7XPJg8GNB5MQO322GsDn6rQ/hzN63Yt55vTD/5NIFzz4GzxD0ZDaF
	 DvQhNJt2ZgxtOOZEHq/Yhjldj07FD+dwhQewiYmxb2XHVfrpJi5Dp2BeZ0bwxJmsWu
	 0J02TDPiVRpcA==
Date: Thu, 19 Nov 2026 15:57:19 +0000
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
Message-ID: <20261119-borough-flap-6481c20b3013@spud>
References: <A039A2DE1DF8F274+20261119130356.1537-1-luojia@rustsbi.com>
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
	protocol="application/pgp-signature"; boundary="kRq95MxRn1fQKyba"
Content-Disposition: inline
In-Reply-To: <A039A2DE1DF8F274+20261119130356.1537-1-luojia@rustsbi.com>

--kRq95MxRn1fQKyba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 09:03:56PM +0800, Zhouqi Jiang wrote:
> Linux queries the SBI specification and implementation identity during
> boot. It caches the specification version, but discards the
> implementation ID and version after logging them. Userspace therefore
> has no structured interface for this immutable firmware metadata.
>=20
> Cache the implementation ID and version and expose the available values
> as read-only attributes under /sys/firmware/sbi:
>=20
>   spec_version
>   impl_id
>   impl_version
>=20
> SBI v0.1 systems expose only spec_version because the implementation
> fields were introduced by the SBI Base extension in v0.2.
>=20
> This gives tools such as lssbi a native source for basic SBI identity
> information and starts moving those queries away from out-of-tree
> kernel modules.
>=20
> Codex was prompted to research lssbi's out-of-tree SBI probe and design
> a minimal in-kernel replacement. It assisted with the sysfs interface,
> implementation, ABI documentation, changelog, and QEMU test setup. The
> result was built with a RISC-V defconfig and boot-tested under QEMU
> virt with:
>=20
>   OpenSBI v1.3
>   RustSBI v0.4.1

I like this idea.

> Assisted-by: Codex:GPT-5

FYI, these tags are now deprecated.

> +static ssize_t impl_id_show(struct kobject *kobj,
> +			    struct kobj_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "0x%lx\n", sbi_impl_id);
> +}

Should this actually be printed as a decimal? It's a minor thing, but
the numbers in the spec are defined that way (see 4.9 SBI Implementation
IDs in the 3.0 spec).

> +
> +static ssize_t impl_version_show(struct kobject *kobj,
> +				 struct kobj_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "0x%lx\n", sbi_impl_version);
> +}

--kRq95MxRn1fQKyba
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCav8cMAAKCRB4tDGHoIJi
0ixDAP4xbETFFphxxj7syOcQqDBHdnUywbHbdu7xa5QQttMYlwEAob6rN4M0Q0hu
vxb7dZm+8Dj0REZDMf4Xsse5UfaHcQ4=
=bSG9
-----END PGP SIGNATURE-----

--kRq95MxRn1fQKyba--
