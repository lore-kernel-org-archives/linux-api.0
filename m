Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ED3380FC1;
	Fri,  5 Jun 2026 01:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780624658; cv=none; b=YaAwXcRzk1GPsDMyAobyXw5QivNFUkKlvsW/YzYO7J3R32bIeVwbBd1wOJVv5iauS8TBF23gxRGtVdUiE/CDHuJli8VleKNvymdGeSTad6R9AUGyT0g08ZtnzHlkYBp8LbyvTE8+NPdskHW1zXdQ9xxL+Hf4ljU5STgARzRzsUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780624658; c=relaxed/simple;
	bh=FyD284KL2h6kq9Zsrb0/HR/oaReskZnD6LUfv9AEEkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SIecx0VqdRaoEhJqTr0/tT+gNAqMHhbqjiblHILGFqOyJFxd+P6WCML/8h29qY/WXsQMxdf7/Fnn4JEedZqPFoOWMHmhrWOV8AYWAqrqEZud2wUwRgvJlBTv1cdSkQyMVoY2pzwF84dnOmogdaA9i3Jfep2U/MIDqUn6qjCGc0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5kFVbKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5kFVbKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4348B1F00898;
	Fri,  5 Jun 2026 01:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780624651;
	bh=hSMeDgYWfG9legqy7nLxVx38jDi5V+SRhptqZ18fLp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h5kFVbKGgWVM4/By8YauS1zHj3ZfSM7nv7xk5g47JSYjO4uExbSJ8vU62gwc4dAjb
	 9QQCREwAtgUZqllgZ0AZ8AUIqgkKZFTwlNCOGAb9zpcS8ZM+lT1XkImHiYqor5wnS1
	 /XlH4Q1yDcsbIC2OsFk+IKqTlK9WBNa20C5VrMvxCEruIE9fHYYaJ7JmPuzX3Wtp2i
	 3EghSwMOFry9oSJBFg7uVX9Lsap2HZmy+EoldQIf4mz2RbBTkpKKaPMVrv4PmoLKgA
	 g6YTizz/03AnztZfkq647HYGn7jqBBAF5k1WupLx5j698k7fx5hbgFDH/ed/3FrRFy
	 43v2riFR3o/4g==
Date: Thu, 4 Jun 2026 18:57:24 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Askar Safin <safinaskar@gmail.com>, metze@samba.org,
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
	david@kernel.org, dhowells@redhat.com, hch@infradead.org,
	jack@suse.cz, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260605015724.GA520134@ax162>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com>
 <20260604100609.6b37f500@pumpkin>
 <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
 <20260604183829.63c35fd9@pumpkin>
 <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
 <20260604223216.73468830@pumpkin>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604223216.73468830@pumpkin>

On Thu, Jun 04, 2026 at 10:32:16PM +0100, David Laight wrote:
> Talking of broken compilers, had you noticed that:
> struct foo {
>     int a;
>     char c[32];
> };
> 
> int b(struct foo *f)
> {
>     return __builtin_object_size(f->c, 1);
> }
> returns -1 (size unknown/indefinite).
> You can't use __builtin_object_size() to stop code running off the end
> of anything referenced by address - even when the size is constant.

That is the entire point of using '-fstrict-flex-arrays=3' in the
kernel:

  df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3")
  https://godbolt.org/z/bvfrh7W58

Without it, all trailing arrays in structures are treated as flexible
arrays, even those with fixed sizes.

-- 
Cheers,
Nathan
