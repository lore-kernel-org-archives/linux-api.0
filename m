Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795817319;
	b=uNPRgXnofGYCzBtme+GrRJ8R0uoTlDU0v69u3L/5mA3ul4nbM9A7Gf12gNKGNUXBk7iZ
	 VPs++rr8H8ZQkys4s2oOPoqbmDUZMNwme1nJfvYeOdOCUgnppDk5hro3QyXHwPBsmw/n+
	 fpN+RBcVVpjfzXVFGTJsMP2xY50UzQPzVPF8W8iES4eQLOtgvzXbqPDf/2UznQ9WVP/fN
	 bLrv/V/UZvjDRt2Kac7zOZ1x0VPI4I8O2Cs2edS0qM215mZHyymaOWPl2T7WU8RJJ1UjL
	 zjmv5OIZdTKvLNIKqSSrjw1SqMtb7t5b4wRq4tTPQx9rZpsKuMY218H//7YZQklhJ4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795817319;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Qim2wvS3GLpENphc0viA1C7S9Um1xXiICAsZWzouGmw=;
	b=GSmdanL+/k0HvOXqpsmv9CrVY4aQbGiUPryOPO8ymJUnmCIggv7k8rfaWwAT/qYC0prb
	 iByPGXeWaWXi7ULoGxmrUUZHTYGaY5rN5pD0Le1QQKpBxc/5ycz84l6bmUNYAE02Pi1As
	 5MnNkBNvgRQKhwEEqxEjmjGFzYNmstQmfWZOkXJNGcktOjowK01kfDrYCs7/+rPOeu9tU
	 xXlfjzSACtsJvupivr8DUZIqO0gpn95oofpSSfhjPHbKU33D2blSCNUoFqPe5bFhqalPv
	 +JPYjdxoTPVwhI48dl52HxUsndVQGXpthVmKBpjjoE6MHyGoAWgmKgSKrSVGQO6SEQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eo16aKiJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EDD05606A31C;
	Fri, 27 Nov 2026 22:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eo16aKiJ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C16D01F000C1;
	Fri, 27 Nov 2026 22:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795817318;
	bh=Qim2wvS3GLpENphc0viA1C7S9Um1xXiICAsZWzouGmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Eo16aKiJ7grDNFCjfScqrd4kEpRnZo12pNtIsg5EyqWXflotScK0exfdbqe1GIM6Y
	 Z5prVEfvaIznrN6tK092KaJ8snI1ZguEO+UMWRdCFcd3k2aIuHnaLzk/1XQ/AEoU0k
	 dLT4s6oqIjIOYwQ+AavHCBqpAYFGroWtqt7K30SzDcI4wLYOPGLTHTRIRTYqOwyEtx
	 6WvT7k5p3VbTY0lSLMaQz4UVCT9NYsEUuFn2eib4CM5a0vNocdMxsp+OG/jg0psAGs
	 sdMrF8QYqlg6OcnF/PdxasMHbj7drAY5v76tMbj4kvvddH6e37YZj/x74iYJbgdZp8
	 8jQQXAu64tvQA==
Date: Sat, 28 Nov 2026 00:08:35 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com,
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org,
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com,
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com,
	jack@suse.cz, jlayton@kernel.org, josef@toxicpanda.com,
	kees@kernel.org, kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awn_Y7oI4ckfsjSv@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
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
In-Reply-To: <awn-ioAuksHNV-Rc@kernel.org>

On Sat, Nov 28, 2026 at 12:05:03AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 28, 2026 at 12:41:03AM +0300, Askar Safin wrote:
> > Jarkko Sakkinen <jarkko@kernel.org>:
> > > I personally think that "getting in" should not be a goal in the first
> > > place. I care more about that whaever gets in has a high bar of
> > > quality enough. It can be something different than this but
> > > when I read the LWN article about Cells I was alarmed enough
> > > so that I had to do this and prove my point.
> > 
> > I think that Bacik's patchset has better chances than yours.
> > I think so, because (as Bacik said) it was tested in Anthropic, and also
> > because Brauner reacted positively:
> > https://lore.kernel.org/all/20261021-zeitig-niemals-clubmitglieder-b3973fcebd38@brauner/ .
> > 
> > So I suggest reading Bacik's patchset and say what you don't like about it.
> > You will have chance to influence Bacik's proposal before it will be merged.
> 
> I've read it through and the way I'm seeing it is that it is overdoing,
> and has somewhat complicated life-cycle model tbh. I don't like it.
> 
> This could be of course wrong way to see things and I did this just
> to demonstrate that similar goals can be achieved with a relatively
> lightweight core. And this is also demonstrated with a Python daemon
> emulating Cells style containers (and alos relatively trivial SystemD
> wiring).
> 
> There's no reason to continue this for the time being as it
> demonstrates already how I see the world i.e., "I showed the
> code". It's up to whoever decides these what they do.

And even if Cells is the ultimate solution since I had thought about the
whole problem 1.5 years (mainly for my own entertainment but still) this
was the best way to unpurge all of that. Regardless, world became a
better place... New information arrived.

Br, Jarkko
