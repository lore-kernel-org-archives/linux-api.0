Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795395601;
	b=SVa4D6LO6kNA0K2asG5r1e+DoMf+OlikkmOu/kCiknvFtiMM0FsfGOAK1cAiXj6guEgC
	 VsnO8qmeaswjMeLwWxu2HfhEYcqNAx8m3R9btwyQJCQkBtfqWkMFgyhy+TtCaRlADyXJn
	 73ve1B3mZ5A3UvX5k71kgTL7OR2yydwNJTE1ouiPw0e8t0OJtU0r5WEq9dWYxYxXw2LHE
	 BYzzG4E3xapCTZmPh9C4vH7yF7HEinto06ljVk2vUZjhT1WTyBS4YFYtepoYkyMJMFuRb
	 aCjm6tKLPZFDzqbqDaOCkgJRqA8k9ZkRCG2/JYBcHe6nZuT0S9lylouezFVmdbnO6lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795395601;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IH6s3imrOjkSSzYR6/sWOdEeFGUNdEc0JcOzWkitMX4=;
	b=za1UGW1WgloD1oFmUdvtKHmuJAP/tendyhrfjFMvd03ofzes4PFL+Y9kBZOhMSCWUiem
	 Wg+Ni/9NGIa9JcKFQQj4D4SroJp52PQt6f6QKUM+FNZN6hg9pQKeif2AZLVK48otaXbv3
	 Ev0JcT+aan1cLWfxcwUVpHc7EQJYcO7rzJRS7pDe5OLM2ROXMZAgdHQC1laRhV3QA6sMo
	 mzlv8GzOa/y7+Q6ttz4klAdZEtOlxDG4wqS9XbuzlQjrMRPxrbCpiAyw2h037W+Imc/ej
	 XuBQfkWeNHsJg7ZCFaMaCQCKpmdH/aqAPO9iQ42RXaRBvRW11JrNspheNvDUDSTITCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iyho16XO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E6863606A693;
	Mon, 23 Nov 2026 01:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iyho16XO
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 48E061F000E0;
	Mon, 23 Nov 2026 00:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795395600;
	bh=IH6s3imrOjkSSzYR6/sWOdEeFGUNdEc0JcOzWkitMX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iyho16XOD66JQTO4jubhBZ0x5ppfRmDr3yr5LFUtdo1H0PSKcslH+DafW6vC8Cnkz
	 DPsyD3bvouIDFeYEgKwGdpN/x9aZcvEM35W8B92UZaq+O0Ce9W9F5NdKyNliOOR8gx
	 lAtWhb0jQMl38Fx9T01rCfo4aSLPmXHsFlJD+cX0T/6PozwKbSgIWKunHlXCgqZoo6
	 eTyKYKU7VwfDLK3zD48tZrYgoFjQB95Bh9oATJp4kQjSeGHm1qTq0zgah8HiSlkFSg
	 pfKe4QtlaYIeRD+rXH6/DNBqw1HpWFM/EnHiiQXg0y7lEwCuZlUww7ZIsj542/TaQr
	 XDucFZ57yBeBg==
Date: Mon, 23 Nov 2026 02:59:56 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
	containers@lists.linux.dev, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awOQDOel_72Xwjm7@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>
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
In-Reply-To: <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>

On Mon, Nov 23, 2026 at 12:21:16AM +0000, Alexei Starovoitov wrote:
> On Sun, Nov 22, 2026 at 11:35 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > v6: https://lore.kernel.org/linux-fsdevel/20261122011809.2667684-1-jarkko@kernel.org/
> 
> v7 was sent 18 hours after v6. v6 got replies from the bots only.
> v1 was +2559 lines. v7 is +5782.
> All six findings of sashiko on v6 are still in v7.
> None of the seven versions got a reply from the vfs or LSM maintainers.

Apologies, I started testing this with bare metal as a result of
hotplug, and things just started to roll out as I got a better touch on
its use as a result.  The growth is by majority in kselftest. The
feature has not really grown but API has shrunk along the way. Still,
demonstrating that full detachment from syscall API is important,
because it sets a bar for any approach trying to do this.

I had no idea that e.g., that  quality would be even possible but
one thing led to another this went a bit out of hands.

I also wanted this to as good form as possible before going on
holiday, which I'll be starting tomorrow but this was not a
motivative reason.

So yeah, again, apologies.

> 
> The way you're spamming people you're only reducing chances of anything going in.

I personally think that "getting in" should not be a goal in the first
place. I care more about that whaever gets in has a high bar of
quality enough. It can be something different than this but
when I read the LWN article about Cells I was alarmed enough
so that I had to do this and prove my point.

Br, Jarkko
