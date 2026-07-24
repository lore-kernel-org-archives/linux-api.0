Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D983C65F0;
	Fri, 24 Jul 2026 08:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784880271; cv=none; b=GqqKZs11Zzabjd7KzOeGy3XrMGewx9DcUZQFjBuzzhB8iYAMRVOnhg0gblTGayv3+2cpPswJYm7caFKMrbNVpJLRFt35uECGxY3qjUWCtm49IVAroYjO3d0KS7m8B2s8PEmize9wn7GB4UeoVV8kyofHLDftEO7jW2UqT/G0FvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784880271; c=relaxed/simple;
	bh=9KjHpnjrQ11L763ns6b7q1nshB2M2ObqhvgJGHsHT74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wk1TW3ZCJFCutBTT7Q1fUpN0JojQY05WKVljM0+QoOqczpqYkzPPS/X18F944E0IaEBG/cAhc6y66Y+naYxuh9ku1bLsWzCJ0C8VShlWAQlfiSLtRK2CZzVL3QTh7X4M0rmD5OV0hKo12zzcgmH3FTf+6AEbt/gsgwzuM1FRMj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hg/dhdib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hg/dhdib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935DA1F00A3A;
	Fri, 24 Jul 2026 08:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784880269;
	bh=NRTHZmJYuxwypVNAxCEvs71U+5naG8G0pnvyuh9pSf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hg/dhdibhxOrcsUScmSSll27l/p5+49N5w0BN0rX/Z/i+CfktexkZ38LBXXAlsKdV
	 hKtOUUBAHtUcP8ZExxlbOyJ2oDsWOhbjYiCIYLMX6rFvaG3BuDMgM2F6DiY+bwqYv4
	 S/xBiK4wzXxek+/xfVzQF2PJO/5jFLsm1EZa7K9Iw6WPJpLxcVBEFP5TadiFTJCcyu
	 ihp600ZAxnoSGppeJt0jbvypVArTWpg4GwxffIWjyP9BVtpuPxRMyBnJJItoBh3DWE
	 anzFX/RZrAwYp4FCKaO3mTjKo7lFbyVhswTD7XqGaBqdBetNTcoJpwcK7qMEKovr+U
	 wuuUOFYh4d3Kg==
Date: Fri, 24 Jul 2026 10:04:21 +0200
From: Christian Brauner <brauner@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>, John Ericson <mail@johnericson.me>, 
	Li Chen <me@linux.beauty>, Cong Wang <cwang@multikernel.io>, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Kees Cook <kees@kernel.org>, 
	Sergei Zimmerman <sergei@zimmerman.foo>, Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: Re: [RFC] Null Namespaces
Message-ID: <20260724-wagen-melden-gemieden-a45899cdbb7f@brauner>
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <20260629-hauer-erhitzen-sobald-96d3dff68707@brauner>
 <CALCETrVuh0-biOw=TgYN9ERTFAoiki57XeZ3S2T3dO2+hL54gA@mail.gmail.com>
 <20260702-entladen-farbkombinationen-klarheit-fe24cb608f23@brauner>
 <20260706-dabei-radeln-glitzer-71ecb835029c@brauner>
 <CALCETrVjDtBmB+boCUgd069UpZGUB1TCbEn3k1HZQex-_dPgbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrVjDtBmB+boCUgd069UpZGUB1TCbEn3k1HZQex-_dPgbQ@mail.gmail.com>

> > > For my FD_FAILFS_ROOT proposal it would be enough if we make failfs
> > > SB_KERNMOUNT which means it's logically distinct from every mount
> > > namespace. I think that might be the right thing to do. I need to spend
> > > one or more brain cycles on this though.
> >
> > I had to take a long drive on Sunday and I kept thinking about both
> > FD_NULLFS_ROOT and FD_FAILFS_ROOT and ofc there are some things to
> > consider/discuss.
> >
> > I think the straightforward solution to FD_NULLFS_ROOT would be to just:
> >
> > - make it always available
> > - refer to the caller's mount namespace nullfs
> > - work with fchroot()/fchdir()
> >
> > So I considered two chroot() use-cases for the sake of simplicity:
> >
> > (1) You want to isolate yourself for the sake of lookup
> >
> > (2) You want to isolate yourself to assemble a "private mount tree" but
> >     not really be in a separate namespace (very odd use-case... but it
> >     helps to make a point).
> >
> > The problem with this approach is that everyone who chroots into the
> > nullfs root would suffer from the problem that any mount on top of it is
> > still visible. So that kinda makes it pointless for both (1) and (2).
> >
> > Also all mounts that someone else would do would also be visible
> > allowing multiple chroot()ers to affect each others state. That also
> > would somewhat defeat the purpose of the chroot(). So I'm not convinced
> > this is what we should do.
> >
> 
> After some contemplation and a long place flight: are we talking about
> nullfs or failfs?  Because I would expect that it's entirely

nullfs

> impossible to mount anything on top of failfs.  So failfs would be
> useless for #2 but would still solve #1.

Yes, failfs can't be mounted on at all.
