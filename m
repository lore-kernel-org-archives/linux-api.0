Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795183052;
	b=FpSI/+Ys0mKvGhh5XdqZddK1KMthi50ZXTAXVe3l3iNCCL784PpvcK7Xsemh9/kXuUYN
	 WF90n3sG3xlnsf/lLaEczwCQwQWq+wrJp11+q51GEPs3x2Vdx0Svw4/R0tiChNoGwigwe
	 ekcEXZilSvLcZhk3gaQFa86damClHRMeLdz025oL1n+7lK4DXDtJipifvs0k5fj9HydR4
	 7/LTAtAKsqcbmFIkqabGTtPIFTCHBXH6o7Ipblui8HdRzKnIj3dxy4H7yu6HVx+DN2dYg
	 +dLU8OQjD8lwdwofBg5P78P3nZjPkDs3/pvm/OaGi1a9qoxk2NviQ0NG5uDKsuIRyrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183052;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=or065ct6iH2dxZM7keHH7/u3PMbUyH1ouhp6nN4Rafg=;
	b=2Kfwh3oZuegGQsV4GR6Ckewm0V+o44T6p15SCemKhUosejjZNv8EeIj0owhTJ2vinFlu
	 SS/xeQX9zR+9KOH1swKG+bZS85QVkb9jemQZgSDgSn60cTxK3AbMmlVQ8U+vq0C9Uq724
	 UY1dN2zz0W9Qd3vKthNy+Ihs4k8jIa66MnypN+RXRT94CJFj4GgdAUeq02VqjyYN/Z7oX
	 Q5TWy/e0+fR8hsANzd1qpSXRpMRJ/heWIs/NwCF5rMRk2BWAJ8iOAG1bqw76AoBAUoC0J
	 qK0ER0OAkDMTmk3Qgjh7Gc4ouxD/uoUVvGnSrQ1req9iJhifXU/5YXvANyEbVC9f4qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jGaRycrV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B353E606A320;
	Fri, 20 Nov 2026 13:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jGaRycrV
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9B3D41F000C6;
	Fri, 20 Nov 2026 13:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795183052;
	bh=or065ct6iH2dxZM7keHH7/u3PMbUyH1ouhp6nN4Rafg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jGaRycrV6mDnn3ij7KW+lj1wpPBafr+hZD8QK62MxZD2w5BsgW1W/d8kJxChQ71y1
	 tiEy34f367xdeP1gnBXzzbN0I+BvvYMIphMSTCJXMhZx4gtYz2QqhHylbW2/Zn2nOh
	 bf3rSlceQXKyi8NCO4UDkuVbwIa/1RB6LZC3CNSA/PECOPGKg28MTK+8KYgHcJ8rJ1
	 sh0LboixMl4r52fMmnJX3dKcGfFiXand7tbTV+aO8oPktrnJsg+oSvyjnJ2f0cicOJ
	 OEx94FHbhkndY8x4GWa/uGPAJJVg/tUyWxb8pOg9WR3twDaOngZa5KG/591ZUtNHVT
	 DhzR2DEMyJA9g==
Date: Fri, 20 Nov 2026 15:57:28 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexander Mikhalitsyn <alex@amutable.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>,
	Paul Moore <paul@paul-moore.com>, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <awBRyKgOQlaEqpWX@kernel.org>
References: <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org>
 <av3bkDnwmjunTleX@kernel.org>
 <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
 <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com>
 <CALCETrXt-Do28BHDpbrA98kEy-tQuorxD8c2XsW24Tt8Vspdtg@mail.gmail.com>
 <CALCETrUbe8rBoxrC+Q66AMsrJ8Fow7xt5KJKRAmobtXBvHWdqg@mail.gmail.com>
 <c301fff20a4920fcd3baa31dda2e31ad99c93436.camel@amutable.com>
 <awBHZO2VwWyJzvBN@kernel.org>
 <1f12636403bb7af3759cd933b2612d8a5d7317a2.camel@amutable.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f12636403bb7af3759cd933b2612d8a5d7317a2.camel@amutable.com>

On Fri, Nov 20, 2026 at 02:24:57PM +0100, Alexander Mikhalitsyn wrote:
> Yeah, detached mounts API solves a security issue here, but it does not
> fully enable the use-case Andy describes (if I understood it
> correctly). My interpretation here is that to fully cover it we need
> some well-isolated communication channel between container and
> container manager (vsock for containers? :-D). And some well-defined
> agreement of how PID 1 inside the container can get an information
> about a hotplugg-ed stuff. [ But it could be that I completely
> misunderstood and Andy meant something much more simple here. ]

I guess you are right, It is good to check that in detail. I'm figuring
out if I can test run it to some near confirmable level.

It has enough steps that it cannot be simply "explained away" so yeah
thanks for pointing that out.

I'm going to use an old NUC for this as I recently made my kernel test
harness installable bootc operating system. This was minimum working
environment for Matthew Garrett's lockdown-hibernate patches, and took
over a month to setup.  Great that it gets more use :-) [1]

I think these type of use cases are also best to test with real hardware
over QEMU up until some guarantees are in place, so I'll just go ahead
and do that...

> 
> Kind regards,
> Alex

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/

Br, Jarkko
