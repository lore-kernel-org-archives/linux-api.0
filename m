Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81000459AD4;
	Fri, 28 Aug 2026 13:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787923631; cv=none; b=I7ff1fcYCcYio8dKQUNtsK0i8CvQNWzghgkC/i292e/ReoSj0lcm010LFpcet9enMh+sDspu30iwNuu21LA9CQz0Im68AJRgmMFuzwZ1aFsORtuqoOiSBRvDVmnD8UD27kolV6qevwpEK5lmsarDdRqQ1vntkVq8d7By5xaIHmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787923631; c=relaxed/simple;
	bh=uNbo0CEaWrgMLh9sZO74UdkdcxmIOMUs2ArIpbaWPUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VXQw//H/Utkt448c7U8VE86oaC50gpys/IjbFd8bZZtI7LVwjdaJfFbDAbDRZf+By8ANKUYQ2Pigvr8ZWsNvrcM4WsHSjJL6A0hsIWDP1p62IbKnBrPpjMpYEOwXmMlLHYnqJHbSe4vrgkHOilcAX61/ayTSgbNrmHPnvp1ZajU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkBlJOVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkBlJOVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8891F000E9;
	Fri, 28 Aug 2026 13:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787923626;
	bh=+FYIQ42DCGzI9ZW5t7HWRgY12JIQOn4Qff8BE8HFkZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lkBlJOVXHDxt+3hZwt6gBCc7+DagH0ifqyudSYMbP8+Gz2cWqLvk6x1RlZR58OmG6
	 qPC0j7hAP5Hd4qf+NHc6IIySvwjtaZaoRHsis//w54P0ERk+Q2zvjUMoaeVQsXLCQZ
	 Zx6odVBiYNueTz4YWsa1AcUUy/b+tz6N3nyUlZ6TRNTSysjh7uJGzErYvvk5Iu0G9J
	 0GDO6yE0cQ8SVMNmjJ0np3Qo94BOgK0rbwlM3Hd60ToSnDgp9D/qH7Q/xndWPUrm+Q
	 vtQTN7V2w6mqlSZvvRb3wSYoQJRe9kGdrX6Tu5vKu+9Eaewy/de7VLBNahXEhXWl+Z
	 RSm77pw+QMBtw==
Date: Fri, 28 Aug 2026 14:27:01 +0100
From: Mark Brown <broonie@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "debug@rivosinc.com" <debug@rivosinc.com>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"bill.roberts@foss.arm.com" <bill.roberts@foss.arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: Shadow Stack Locking Semantics between arch's
Message-ID: <c4ac49d9-1fdb-46c4-9303-f17a517ac4c1@sirena.org.uk>
References: <a1946d93-370e-4ca9-85d6-60b4a20ffd47@arm.com>
 <3bb672e0-7bc3-434f-904e-aa00394dd01f@foss.arm.com>
 <d20ccb74-69ed-45d7-a810-846904873588@sirena.org.uk>
 <01b0fe86d5700847f78b0e6f839119f54ac88b04.camel@intel.com>
 <apCvGct9U1yprAUE@sirena.org.uk>
 <f2819c4f1a86845b5b2f2b6f0e03f4c334e84eaa.camel@intel.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L1v0x8HM/zJNwKCv"
Content-Disposition: inline
In-Reply-To: <f2819c4f1a86845b5b2f2b6f0e03f4c334e84eaa.camel@intel.com>
X-Cookie: Subject to change without notice.


--L1v0x8HM/zJNwKCv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 27, 2026 at 10:37:45PM +0000, Edgecombe, Rick P wrote:
> On Thu, 2026-08-27 at 22:41 +0100, Mark Brown wrote:
> > On Thu, Aug 27, 2026 at 09:27:06PM +0000, Edgecombe, Rick P wrote:

> > > Hmm. I can't think of a reason to lock writes and not lock shadow stack too.
> > > Given likely no one is doing this, I wonder if we could change x86's behavior to
> > > match the others?

> > > The API would makes more sense to prevent disabling shadow stack if writes were
> > > enabled. It could return an EINVAL regardless if it is locked or not? Is that
> > > the arm behavior (forgetting about locked)?

> > arm64 currently treats each bit independently for simplicity.  The main
> > use case I see for actually doing that is for preventing enabling writes
> > or pushes, though in practice I'd expect something doing locks to just
> > fully lock everything after having enabled the shadow stack.

> Locking writes as off makes sense to me. But locking writes on, while leaving
> shadow stack unlocked. I'm not sure why you would do that. I thought that was
> Bill's scenario.

Yeah, it is.  I can't think why someone would ask for that either, but
equally it's more work to explicitly have a list of combinations we
reject for policy reasons.  At least on arm64 each permission just comes
down to a separate bit in a control register so they're fully
independent all the way down to the hardware.

> > > > It has been on my list to look at this
> > > > repitition at some point, it had been held up by the clone3() stuff but
> > > > that seems to have died a death for now.

> > > Oh? What was the blocker?

> > Basically the glibc people weren't convinced they'd ever want to reuse a
> > shadow stack at which point having the kernel free and reallocate each time
> > is just as easy.  It saves having to handle corner cases with threads that
> > didn't exit cleanly.

> I thought it was also because they wanted finer grained control of stack sizes
> too? But yea, if no libc wants it, it's a hard sell.

They'd rather have just a size control for that, probably a process wide
control would be most useful since it's likely to be the same number for
all threads.  I suspect the main use casse would be someone trying to do
green threads, where there's an extra real thread being created.

--L1v0x8HM/zJNwKCv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqRjKUACgkQJNaLcl1U
h9AyUAf9GIV9Gka3OGQ62/nBYTo22uygHAaR+VThEC2Gy9E1mnzyyoDFDcMpGKfq
FTQ0dN/MSRCNUCayYOB9BgR0VWFlUbxPUkqU+nemTJC3LkTv2BU+sZg2WqG/1aVe
NVkES2ZbFx2+OtAKo5nu8aNUwbxRknniwDRmV401BnGnpEX8Bh2HPyK5puZ5Z0rf
Z36MHk8Wya0KCYtiipFxd6rBahozcDQhX6C4RvML20EjPIBAMMtMOTPA1p1RiYdS
azcc6OVruCJNDvTy7JOVPzoK2jAx49oV3hF1cY2xABzmXrL/cURqIjEcdBi0ONfY
Px37thtnUk0aubSa7N6rI9FPbjgqow==
=s+DF
-----END PGP SIGNATURE-----

--L1v0x8HM/zJNwKCv--
