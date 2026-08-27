Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D426F38F65C;
	Thu, 27 Aug 2026 21:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787866917; cv=none; b=hLnOfVQ2Ha6P1P7+6tzPN24t0ln2TUFYMyRnK6TIwUrmYIOSjMzBGeHmLQ0Qin1wJrwVNjaqL9qx7w6I+F1eAHA9mlx8QBvv971wCGztfohxQDRgmegr8tbdRqD1YLrYmQSHkgxOxynHsvCsniYFw6bcnIDGD9d5PZ2HOuKJl8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787866917; c=relaxed/simple;
	bh=vx7ibqNK4H4bQvtmSpwOhxA78qBlIj1ZhgMs+cKy6vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U5aiEP8BGiVv19nbCXyCQAzM3A+WXsJ8h7gMAXpOCmRXlUnzjPBkugAI6rYM5kaeMxgGKpcXHZr4DUr7GAkC1cmi9AUvgelqBeqcik6yOji1O0vGGuxgO4N/nizt78gRAmcpK8e6beeH68SMqGVxG6d1BP+p4+P/l/fsgVq4nwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OnfQnoc3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OnfQnoc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF601F00A3A;
	Thu, 27 Aug 2026 21:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787866908;
	bh=+dJ2/89KzJA+YU6uGo5TNo5P0os2bn6e5V8Hm1Oz+DI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OnfQnoc334MVL1rqM4T9D31HFX7jfHs0Bilng0Pyr/1N9g76l9ZjCj1tvsb32Tvg+
	 NbZFOaPvr9c+YrBJIG1sBBMJh3fKztI/Rgaktyp2zN+w2mkG7qBlwg3d/iwwwgtJg5
	 eUOmwMLNOsfv8Zz2LrTpZMkA3Vi3vLmd+cH8MRdwvRkqxTZ3xcmMQEeHRv09vn/p3W
	 vfhdZ420Tlxqw4CZUuTdAe0KL4kMNP68JVKdAJOREBlzVjjHnUgqXcIzivwloSlrJf
	 TMy8d3IkWxZNmcaRPuqEdq8G6lw8ugX7HwrgLnmcvivIg2Z54ycAQ55Dq9H7QZIycM
	 6qmCuWqTR3UyA==
Received: by traversing.sirena.org.uk (Postfix, from userid 1000)
	id 330E4C67629; Thu, 27 Aug 2026 22:41:45 +0100 (BST)
Date: Thu, 27 Aug 2026 22:41:45 +0100
From: Mark Brown <broonie@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "bill.roberts@foss.arm.com" <bill.roberts@foss.arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"debug@rivosinc.com" <debug@rivosinc.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: Shadow Stack Locking Semantics between arch's
Message-ID: <apCvGct9U1yprAUE@sirena.org.uk>
References: <a1946d93-370e-4ca9-85d6-60b4a20ffd47@arm.com>
 <3bb672e0-7bc3-434f-904e-aa00394dd01f@foss.arm.com>
 <d20ccb74-69ed-45d7-a810-846904873588@sirena.org.uk>
 <01b0fe86d5700847f78b0e6f839119f54ac88b04.camel@intel.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sz/kjGTpENLdkZcp"
Content-Disposition: inline
In-Reply-To: <01b0fe86d5700847f78b0e6f839119f54ac88b04.camel@intel.com>
X-Cookie: I think, therefore I am... I think.


--sz/kjGTpENLdkZcp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 09:27:06PM +0000, Edgecombe, Rick P wrote:
> On Thu, 2026-08-27 at 19:14 +0100, Mark Brown wrote:
> > On Thu, Aug 27, 2026 at 12:52:28PM -0500, Bill Roberts wrote:

> > > I am proposing and have questions over the following:
> > > 1. What should the behavior be if you had write locked and disable the
> > > shadow stack?
> > > =A0 - I can argue both ways here, -EPERM or success. I think I and mo=
st arches
> > > lead to failure.

> > Given that RISC-V doesn't support control of writes it's moot there
> > at the minute, and x86 currently uses arch_prctl() so will need an
> > additional API, it seems the path of least resistance is to allow it.
> > This also avoids locking writes (or pushes, for arm64) on effectively
> > also locking enable which seems neater.

> Hmm. I can't think of a reason to lock writes and not lock shadow stack t=
oo.
> Given likely no one is doing this, I wonder if we could change x86's beha=
vior to
> match the others?

> The API would makes more sense to prevent disabling shadow stack if write=
s were
> enabled. It could return an EINVAL regardless if it is locked or not? Is =
that
> the arm behavior (forgetting about locked)?

arm64 currently treats each bit independently for simplicity.  The main
use case I see for actually doing that is for preventing enabling writes
or pushes, though in practice I'd expect something doing locks to just
fully lock everything after having enabled the shadow stack.  We can compose
the features easily enough so it seemed most straightforward to just let
userspace decide what it wants, it keeps the implementation simpler.

> > It has been on my list to look at this
> > repitition at some point, it had been held up by the clone3() stuff but
> > that seems to have died a death for now.

> Oh? What was the blocker?

Basically the glibc people weren't convinced they'd ever want to reuse a
shadow stack at which point having the kernel free and reallocate each time
is just as easy.  It saves having to handle corner cases with threads that
didn't exit cleanly.

--sz/kjGTpENLdkZcp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqQrxMACgkQJNaLcl1U
h9DLvAf/aD6cLja4vh624NoCAxT31xAb2Z0qfo5lbjna4gi96N7QofiM8YSxwqzY
uERaK8TZBR93wojxkcg9W919KwU9yEHlT9nFeyl8wIwpuMKytvR06lOvwh5NRcCU
Vaa8qjM4Sgl1MHes7onoDrjNVprq7Z3ORz5k/ccIjVQue0S1qJoYciFaxw8gQLTp
NJqHqErqED4YmsnbjW94wK8jJGZzvSORNHmk/+i3HkwdmEmg9MIhj7l/uzVuY2V3
+A2aaqVAiOdvscucQ5DV/gzjM4dJc+3qBoEl1OSVF/oXPkbSTC522w2xrJ4tQGQc
cnYEBs+MNTbaDQJ/lzGwAhbr8aoKWg==
=/1d8
-----END PGP SIGNATURE-----

--sz/kjGTpENLdkZcp--
