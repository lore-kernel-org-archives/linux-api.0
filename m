Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795440349;
	b=YCXhsfJ4MG/DAeHl6a4L+HAy+M+EqMc68HO7pto55B3avvewZnkNRMNxJLWk5eGdWikj
	 i3UWwP8mJMO0QMnNAFcegkc3x4IzIzm/kFsl7X5JYfq1mLe8USz8nORO5XHmTVNS+tmez
	 YdpZNqHdTQyXWS/Utm2VtIuFKzYREmzDvLLupewCRwkihEM6TpmAKBrXA8jkjfc2LCQa6
	 4pccVrK4ovQXtN2ol6D9JmJ/Lsewkg5Pw8oh0n1VEIhBarqGJmyutsgJv71HjQmTzgHuw
	 3stkWldm0LK41lN/7O9Si7upTfcCi+qJBmxTGrdvAIAs0H8iguqcRDSlGVVR7HBCBEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795440349;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=C+AcgEGNVf8XGbfJ61gaQU4lgyQ1Y5lkSyO2e7jckEI=;
	b=dMfi2AzyZ65Fnb6kg3HiXxcvAI97epTvxR0TPh+xa0+CcTobQlD/C8vwirfLPFFzwXMs
	 0gbbqdQQRKSoGyBVFxJe9UEo3PzZVo7sD7Wruz+uecSxpVtFLps8uSiAHtklk/eH0IUeq
	 UmJ0oVg82MPE3uiTLNlkOl2cMHsXJ/lrNz12JUHjx5kV0Xjm2cZQmrdHoc++GRyI5J7aW
	 Zz7nyjQtlxghbu9hjCb0TF+AmXerFYaTM/m4hU1O2Q/yY8oWr4qcNFWLxez+J4VqPvia/
	 PB+iaMS4lIkJja/0LfbNUvt0aiA2frOLHj4BAFADmKlop6W1yRNEufPi2rvr1Jdktug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="IG/CW4cv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4ED8860A263F;
	Mon, 23 Nov 2026 13:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IG/CW4cv
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2272D1F00A3D;
	Mon, 23 Nov 2026 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795440348;
	bh=C+AcgEGNVf8XGbfJ61gaQU4lgyQ1Y5lkSyO2e7jckEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IG/CW4cvGp7/2EHOxmS095yYCn3GkihksF+fkHnCoFwx6rbFuVB66JTeqhPXWQyku
	 zaFFso/3daE8Z53QdIhOFp0amXkx7o/6ekzhmYy5YcEh2Ll3QkH8fkiF3fAmDIYMFq
	 qnSTGKqAaLSspfKaAzMYc5/lnGsoQdIpujd+J58VCB85TDcGwvBMgf42xRTukHTejE
	 fdDWUpyNGnUlyoG4I8BBzO+MltP0IbtJWRgAPVF0vE2l4egwT7mfFigjz5Nts0kXXW
	 0J3zLJo0uIGtZUyLJLxsRWXxespCl3VF1hxfl4Q7HLsAN10wSwuEnnHwGIFO/Pwkbh
	 r298B2xOxSF+w==
Date: Mon, 23 Nov 2026 15:25:45 +0200
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
Message-ID: <awQ-2UtDRtrv9fNu@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>
 <awOQDOel_72Xwjm7@kernel.org>
 <awOUJCbB_j0BuHvo@kernel.org>
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
In-Reply-To: <awOUJCbB_j0BuHvo@kernel.org>

On Mon, Nov 23, 2026 at 03:17:28AM +0200, Jarkko Sakkinen wrote:
> > > The way you're spamming people you're only reducing chances of anything going in.
> > 
> > I personally think that "getting in" should not be a goal in the first
> > place. I care more about that whaever gets in has a high bar of
> > quality enough. It can be something different than this but
> > when I read the LWN article about Cells I was alarmed enough
> > so that I had to do this and prove my point.
> 
> For completeness: I'll consider this final RFC.

Random throws that would not be this but something else (but could be
derived from this basis):

1. It is possible to use file a instead of syscall for container
   creation. This allows to split the framework in two pieces:
   the core piece and the driver piece.
2. It would be possible to create Linux Container Module framework i.e.
   LCMs. I'm underlining the technical side here, not sure if this makes
   sense or not.

Both alt's can be quantatively proven given the existence of this patch
set.

Kernel LOC growth when kselftest is taken into account:

1. v1: 1211 LOC
2. v7: 2149 LOC

It's not exceptional growth, as for a compact implementation like this
that easily comes up from e.g., LSM hooks that were later included.

Further the number of patches has only grown because I wanted to more
accurately slice everything up until they are exactly in logical chunks.

For later issues, I've fixed those that are known ATM to but hold on for
sending any further patch set versions:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=vault

I also think that v7 made most of sense for the reason because  I
realized that the cover letter would better have enumrated all syscall
extensions in addition to new syscalls. It was the primary season
for v7.

If this was skijumping, I would get worse style points, and will
improve on that for sure, but as a feature this does fly further
distance.

Br, Jarkko
