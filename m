Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4384E4963B3;
	Thu, 27 Aug 2026 18:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787854474; cv=none; b=n4msWeFIea9+L8gfGOm0YO/fxI8l+NdNC5H1u5cX8d5C/QEoupcJJ3FKbi8Bm2cuBNM8xw0+YhCLqJeihTDYNGo03mpJpGISR+mSWH/81DLQT3H1ytfxofxt81p6B7R3mlfySlHL0W4dP71RPRpwYpmm04F3SSgseX9U3O/eAto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787854474; c=relaxed/simple;
	bh=hD6SEZPfkQWz6Ef4vDrsGLc5w6nhOYqqTLzD0CH/ou8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sei5Of1sGnGlbhJe5Q4DTid9YurWfEkOXQp/MAVyzPIybDi8y0DH/I34u4SpaKFJNk4OVeLyPpWK3gslW7EnFRtNiiCtk3rKU7bMFsS58H1H4idG8ike9YpA8Je4+/WCq+bMeZnPjFPHKz2RSKfcxcXxgabHyZGtnZxwigwXxfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vt4ggbUe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vt4ggbUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2219B1F000E9;
	Thu, 27 Aug 2026 18:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787854472;
	bh=BLqeMPBBFLZB2XtBVAVDJSZch4XELRlb7qugskkfcMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vt4ggbUetYUKJ27EewJQTpgv3qkZTj9ozDFcDv8WygJ3eSNDoxxMV8fBzZLHs9PnA
	 xxxnvaoZsrRyYqFAX4UZZ7TYobmBeZx/FTo05GSUCcrTcQLPNZ4Q7bH2F5eXgDrWRw
	 EcaiZurE6opfx44t9QE5Rqn8848DD59WBL5kcMohlgZX5u+Aug4DF2lxQveaKOL0dc
	 hxzUv8KwTUFyeWOo0IlkU+1ivw7s8z/EI6UmxNB1uUjkZsvnFefYrGbZttRPQN3kTb
	 iYuXAjqHBj7mSV8h8Zz3m6/VaOOFGxNvypQ+ewn9m3+dCXKfZn19mHLfXQGCUTk2+X
	 9S9YOem41Zxmw==
Date: Thu, 27 Aug 2026 19:14:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Bill Roberts <bill.roberts@foss.arm.com>
Cc: "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	linux-arm-kernel@lists.infradead.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-hardening@vger.kernel.org, linux-api@vger.kernel.org,
	dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
	debug@rivosinc.com
Subject: Re: Shadow Stack Locking Semantics between arch's
Message-ID: <d20ccb74-69ed-45d7-a810-846904873588@sirena.org.uk>
References: <a1946d93-370e-4ca9-85d6-60b4a20ffd47@arm.com>
 <3bb672e0-7bc3-434f-904e-aa00394dd01f@foss.arm.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Yf0EwlbjDAgbC5GQ"
Content-Disposition: inline
In-Reply-To: <3bb672e0-7bc3-434f-904e-aa00394dd01f@foss.arm.com>
X-Cookie: Exercise caution in your daily affairs.


--Yf0EwlbjDAgbC5GQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 12:52:28PM -0500, Bill Roberts wrote:

> I have noticed some semantic differences between the arches. Given this
> example of current thread state, current thread locking state and the
> new features requested, as shown below:

> unsigned long locked =3D 0x2; // Kernel Task State -> LOCK WRITE
> unsigned long cur_val =3D 0x3; // Kernel Task State -> WRITE and SHADOWST=
ACK
> ENABLED
> unsigned long new_val =3D 0x0; // Userspace Feature Change via syscall ->
> DISABLE

> | x86-64 | risc-v | arm64 |
> | ---------- | -------- | --------- |
> | Works=A0 | Fails=A0 | Fails=A0 =A0 =A0|

I would not have expected that combination to work at all with the
prctl() (as opposed to arch_prctl()) interface TBH, if you've locked
write on you shouldn't be able to disable it.  The reason that works on
x86 at the minute is that for x86 you can only change one bit at a time
so the new value when disabling is effectively 0x2, not 0x0.

> I am proposing and have questions over the following:
> 1. What should the behavior be if you had write locked and disable the
> shadow stack?
> =A0 - I can argue both ways here, -EPERM or success. I think I and most a=
rches
> lead to failure.

Given that RISC-V doesn't support control of writes it's moot there
at the minute, and x86 currently uses arch_prctl() so will need an
additional API, it seems the path of least resistance is to allow it.
This also avoids locking writes (or pushes, for arm64) on effectively
also locking enable which seems neater.

> 2. riscv should check that the low bit is set in locking not just that its
> 0, it should be 1

I think for ABI compatibility RISC-V will have to continue accepting 0
as being equivalent to locking PR_SHADOW_STACK_ENABLE (or everything,
but it only supports that one bit right now).

> 3. riscv should return -EPERM vs -EINVAL

If you mean for arch_lock_shadow_stack_status() I think -EINVAL is a
sensible error code when the system or task does not support shadow
stacks, I'm not sure we should return -EPERM at all.  On arm64 we
support locking any bit, not just the ones that we currently know about.
This is for future proofing, userspace can lock unknown flags.

> If we can all agree on item 1, that locked bits check can be refactored a=
nd
> shared in one of
> two ways:
> 1. within prctl itself, before the arch hook is called, we would need
> helpers per-arch to extract the thread features and lock bits
> 2. as a helper where folks just pass the unsigned long of the bits to get
> the result

For me option 1 seems a bit nicer, and moves more of the implementation
into generic code which is something we should really be doing in
general with the shadow stack support - there's a lot of cross arch
duplication at the minute.  It has been on my list to look at this
repitition at some point, it had been held up by the clone3() stuff but
that seems to have died a death for now.

--Yf0EwlbjDAgbC5GQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqQfoMACgkQJNaLcl1U
h9CgJQf/RXCfxOLBrpvqx7CGBBJ+UQyh71H64Yy4Tt40trYCcoJLxK6joixB/sT7
g0fKTvETGH7NCIr9NJqTGfvOyZ7Bf4gL2ZL79NU5zTtmWdwB21cDG7tmvoXw2mUw
9SMS62c1y4XEpniYBz7nYA24TgB4ZkpL0J8tOPGVkol0Gjf7ZTnd80JrsdWiYbNY
pFjWClV4iJ/MEwq0Q7dsrRY/3399co/0ZlRMp2LeLEKGce4gGKgmBAJlSv1wQ/lw
qhofehL0NPsqRgdVjXpdoUuRwZ9/odMAZav8deL4wvZJiEtppw7em8wuTszq8NxZ
Ct5MM4+/dYaw4Oh2ftBDOMgYjAL/lA==
=a0+n
-----END PGP SIGNATURE-----

--Yf0EwlbjDAgbC5GQ--
