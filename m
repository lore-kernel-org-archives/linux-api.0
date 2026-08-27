Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CE4448393;
	Thu, 27 Aug 2026 17:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787850868; cv=none; b=WNy3UqV3Gg9Fy77+7f4Qr2x9lnEOvaxGmKgFN3XJ6UoxdLVg11LYPsFNcBcwW9C9KPMZvPGDSzti+WPqlwGLA+y0l61/xaRpo5i3EU1jerDMr9uPmDjWtzcUNT/ueaOx0IygumuBU3Hfr7lM7tIV/XendpFKBjShSpxLzJLwOT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787850868; c=relaxed/simple;
	bh=98EnpPCM7ehXne7kJF3UPBdleYIe55GtAC+8kpokhpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpRNdcJyF5uVmJDQdQqaxn7LFuMcWTY2tkfa7oShKqC3RpjBJ/UQz2aR5c2t3cUr6a3ZEL5unMgAVZgIUWBxRQ/dyBDACdy8ZPM90M5IOgv1foENy4DVCYcccOlfruT51k0izqHmHqfyZsoj2JbYCy3ErRb8HOzFwqfEdH0K6tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JCSVox6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JCSVox6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6881F000E9;
	Thu, 27 Aug 2026 17:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787850867;
	bh=4lm/k56nr7IHGEr+v1yjkGgSAWBS975WgKpRUfju9b8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JCSVox6GL19a1MTaGMX1VoBUpxeEk51N0QWkSBIaHhujZm9iUPhOUm9Xgpbkd7JZE
	 a3pL4vSkeI8SVuclpzWy452xIPJC/6fz4FQzcBhyDDfM1pIhBwFNAotSj2W5B2z7Qp
	 S82CaLweYkZnhheouvTqSWOdOBcKQ88ir5fZuxzmRiNqhPXQ6OeuVCROsQAy85nIQG
	 iwqGqpl61SDgQjqyiDF6nhCoNkPec6JITmHYh039Xu8xm/8q0zJV2RxsAx1BZS/BYy
	 /eB/d9RgLwScRO9DvSiaNXdzYOIKF+nKaXhAa5x91SDuar5TmnX4JABSlzXWNypJWb
	 ADT6YNf+Pwkcw==
Date: Thu, 27 Aug 2026 18:14:21 +0100
From: Conor Dooley <conor@kernel.org>
To: "Ousherovitch, Alex" <aousherovitch@rambus.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Rob Herring <robh@kernel.org>,
	"Krishnamoorthy, Saravanakrishnan" <skrishnamoorthy@rambus.com>,
	Shuah Khan <shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"Wittenauer, Joel" <Joel.Wittenauer@cryptography.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Nguyen, Thi" <thin@rambus.com>
Subject: Re: [PATCH v4 01/19] dt-bindings: crypto: add Rambus CryptoManager
 Hub
Message-ID: <20260827-crust-giddy-6888a52871a5@spud>
References: <20260825221539.255951-1-aousherovitch@rambus.com>
 <20260825221539.255951-2-aousherovitch@rambus.com>
 <20260826-unwritten-marshland-47cdf3c17cad@spud>
 <SA3PR04MB9001B48FBE7B7C3EB81C5338D7AD2@SA3PR04MB9001.namprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fecVinCGlQpVGphf"
Content-Disposition: inline
In-Reply-To: <SA3PR04MB9001B48FBE7B7C3EB81C5338D7AD2@SA3PR04MB9001.namprd04.prod.outlook.com>

--fecVinCGlQpVGphf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 01:39:35AM +0000, Ousherovitch, Alex wrote:
> On Wed, Aug 26, 2026 at 06:02:16PM +0100, Conor Dooley wrote:
> > On Tue, Aug 25, 2026 at 03:15:20PM -0700, Alex Ousherovitch wrote:
> > > +      command ABI).  A specific SoC integration should list its own
> > > +      "<vendor>,<soc>-cmh" compatible first with "rambus,cmh-v1030" =
as a
> > > +      fallback; that extended form will be added when such a platfor=
m is
> > > +      upstreamed.
> >
> > This commentary should just not be here.
> > Instead, do what's been done in sifive,clint.yaml for the clint2.
>=20
> Will do -- I'll drop the prose and model the compatible on sifive,clint2
> so the schema itself requires an SoC-specific compatible ahead of the IP
> fallback:
>=20
>     compatible:
>       items:
>         - {}
>         - const: rambus,cmh-v1030
>=20
> Since that makes the two-item form the only valid one, I'll also move the
> binding example (and our test DTs) to it, using a placeholder SoC-specific
> compatible under the now-registered rambus prefix, e.g.
>=20
>     compatible =3D "rambus,<soc>-cmh", "rambus,cmh-v1030";
>=20
> and swap in the real "<vendor>,<soc>-cmh" string once the first integrati=
ng
> platform is upstreamed.

With the correct syntax, which I think the sifive example I copied from
doesn't have, but
Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
does, fake compatibles won't be permitted (and we would probably object
to seeing them too). What we want is the binding to force people to use
a soc-specific one to pass validation. Unfortunately this does mean you
can't have an example because it won't pass the validation, which is
annoying!

>=20
> > > +      rambus,cores:
> > > +        $ref: /schemas/types.yaml#/definitions/uint32-array
> > > +        items:
> > > +          enum: [0x02, 0x03, 0x04, 0x05, 0x08, 0x09, 0x0a, 0x18]
> > [...]
> >
> > You could just make this a string array, and then you'd not need this
> > mapping of unintelligible hex values. Of course then your driver has to
> > do it, but I'd rather see understandable (and portable, since a new
> > revision could change the IDs) values in DT.
>=20
> Agreed, that's clearly better.  The next revision makes rambus,cores a
> string array and maps the names to core IDs in the driver, so the
> numbering can change across IP revisions without touching the DT:
>=20
>     rambus,cores:
>       $ref: /schemas/types.yaml#/definitions/string-array
>       items:
>         enum: [hc, aes, sm4, sm3, hcq, qse, pke, ccp]
>=20
> (keeping the affinity semantics in the description -- a core appears on at
> most one queue, unlisted cores are load-balanced -- just without the hex
> table.)
>=20
> > > +required:
> > > +  - compatible
> > > +  - reg
> > > +  - "#address-cells"
> > > +  - "#size-cells"
> >
> > Surely clocks are also mandatory?
>=20
> They can't be mandatory for this binding -- there may be no clock provider
> for the node to reference:
>=20
> - CMH is shared between hosts.  The SIC presents up to four host
>    interfaces; a designated management host owns the privileged
>    configuration (clock, reset and power) while the other hosts are
>    granted only a subset of mailboxes.  A node describing a non-management
>    host therefore has no clock/reset provider to point at -- those lines
>    are driven by the management host or an SoC power controller.
>=20
> - Even where a provider exists, only the main "core" clock is always
>    fitted; "core-div2" is present only on builds that include the
>    side-channel-protected slow cores, and "rt" is the real-time tick,
>    which is why clock-names is a oneOf of subsets rather than a fixed
>    list.
>=20
> So I'd keep clocks (and reset-gpios) optional.  I can add a one-line,
> hardware-framed note to the description if you'd like that rationale on
> record.

Please do, yeah.

Thanks,
Conor.

--fecVinCGlQpVGphf
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCapBwbQAKCRB4tDGHoIJi
0tg1AQDJxvd89lNx3GSYKYhVSI+ByKuzMH06Aat4j5i/Er7GCAD/bUIEGNkrxnPj
TriUguZYuEpl11M5MLqp9TSVpc3RUQw=
=+I7h
-----END PGP SIGNATURE-----

--fecVinCGlQpVGphf--
