Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150454D90C6;
	Mon, 11 May 2026 21:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535512; cv=none; b=u0Js2Kq36waYlHL+qboAxcqClZMUhAYWCkZJZ3ByhTwY93XXrHpVauoXGb+6KkJrVvcI5KNYmGKO0oKqLPg5aimNYbx3w+F7bHB95MWmF9EkETiKLNXhkNpAuAfhXX1a85fhC2azaqG9juNzOsXR7MPkEMp9yJmgADWj4O973mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535512; c=relaxed/simple;
	bh=fZhpx1k1xcrrhghih7dNeuimA953Whu88yfFeuou6xw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ag2ETxBqxcsb6WSokAwcaxYtWXPMkDG/nWE2sXbW3Le2RznrgYjJFqzl512FL+lCK84G3wz7wIvy53M5n7WAh1Ii3jXQzRlBGAnn+mMAY4fi+79STWFjaTKE5BMNYiFBywtNshyTRd+nXoETr0SU2rmcUj2pwQokbddLM1N6OBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJGCDQd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJGCDQd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9F2C2BCB0;
	Mon, 11 May 2026 21:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778535511;
	bh=fZhpx1k1xcrrhghih7dNeuimA953Whu88yfFeuou6xw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QJGCDQd7tc8MoxlNTw5nj6nMWf5ehp+blErtcJnFovt4hGMRvgGmv4EmbTT1t8JgH
	 VWFhLe+Hxji3Z/gntJ93r5oLkOT8AoNKqT56iwx9N9EGXZ9OxO6q7gvVJ9xAkpL4i7
	 vrtRXxVOcELejhT2Uo2FeDqIif7KjcDZvv7rh4XKrbfHBcJ5KeLAVNntPRJqYx+KYa
	 fHBsS13dRyiWqH3EihEFCH87w190EE4SLTvo4CII69INrIJ/0crnjLBfD6AVUjPx8J
	 icFGvTIjwMo/+dGz/q8UK8DUPvA/O68dpubBy3pRaPTRt2BJqT+CZpIKtbLodYnrYe
	 BqaafnoWrikmA==
Date: Mon, 11 May 2026 21:38:29 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ignat Korchagin <ignat@linux.win>
Cc: Kamran Khan <kz@inspirated.com>,
	Jeff Barnes <jeffbarnes@linux.microsoft.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] crypto: af_alg - Document the deprecation of AF_ALG
Message-ID: <20260511213829.GA316710@google.com>
References: <CALCETrVqG+1yErRJjkxvJrf=A+Vu84HTR4Bx1Pcd8G1C0PJcMA@mail.gmail.com>
 <14A441D8-5370-44BE-8732-99BF8107C3FD@getmailspring.com>
 <0b8bba44-f6bb-4d69-b9d4-5787c276d41a@inspirated.com>
 <20260510163204.GA2279@sol>
 <3bfcf406-fdde-4303-9bd6-0d8d21ddba37@linux.win>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bfcf406-fdde-4303-9bd6-0d8d21ddba37@linux.win>

On Mon, May 11, 2026 at 10:03:21PM +0100, Ignat Korchagin wrote:
> I don't think fully discounting hardware offloading is beneficial here. HW
> accelerators will be produced and without a common interface vendors would
> start implementing their own "bespoke" drivers with bespoke userspace
> interfaces (we already had such proposals), which in turn may introduce more
> attack surface. Yes, AF_ALG needs substantial improvement, but at least it
> can be a standardisation point.

That isn't the best way to accelerate symmetric crypto anymore though,
if it ever was.  This has been known for a long time.

> > In any case, any hypothetical security benefit provided by AF_ALG would
> > have to be *very high* to outweigh the continuous stream of
> > vulnerabilities in it.  I understand that people using AF_ALG might not
> > be familiar with that continuous stream of vulnerabilities, but it would
> 
> 
> Is it actually that much compared to other features/subsystems, like eBPF or
> user namespaces? But we don't rush to deprecate those - instead trying to
> harden them and come up with better design.

There are plenty of other kernel features with a large attack surface,
of course.  But they tend to be much more useful than AF_ALG.  It's all
about weighing benefits vs. risks.

When we get the point where a large number of Linux users *had* to
disable AF_ALG as an emergency vulnerability response, and at the same
time their systems weren't even using AF_ALG so nothing even broke and
they could have just done that to begin with, I think we get a very
clear idea of which side is heavier for AF_ALG in the real world.

The main relevance of AF_ALG to the Linux community is that it allows
their systems to be exploited.

- Eric
