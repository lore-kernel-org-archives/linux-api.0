Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6E539658D;
	Sun, 10 May 2026 16:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778430807; cv=none; b=LEfQPSjuHFOosW1a0wzgdo3924SAiSjjmcnOoaT/aZBvEk64iq39DmQNsYcInKHdZHkQxVPgyEYL/75ybiPdpmRxuh8ItD2zcpRQ4mHnSC67Zc5KUsrGyK2WXo+MH5jOwR1l5+BG8MxRCRUII6V/5u9LBkwqSrJdRpNd8t+retk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778430807; c=relaxed/simple;
	bh=nbare1FdefnkVW8yewuFEqWuJW6U5UvIzCIysMaWq6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FFFOfVm6gXfguBd9t+uw4vB0azqjmblx8r3p9wr9we6gKO6Vu3M3Y33LO8cMu0HV7E36Gj5fYWZ5X12Kzn9VK8YROrfI55fDLXz4XObDx/tO4e0H2b7q077o1QVj0UbuSnj1ab7YrjiunxNMvsx1Vg8WU6h5B69o7WVtlHJ6piw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PnyJuS7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PnyJuS7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F9BC2BCB8;
	Sun, 10 May 2026 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778430807;
	bh=nbare1FdefnkVW8yewuFEqWuJW6U5UvIzCIysMaWq6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PnyJuS7II6dp4uUypc2q3F3TusH0ne2VErre5ysCo/UcdwkLw8fLC6ARCHyIRhqip
	 tyQnorZpF3KySK3fwgPQoaDvuvRSh59RwICtNFCOTtAywhDnMa+BVZtJFtDCQLJ/Tv
	 BvNs+fHPADJQnDGL6o7IXidHuhATGBvpK/bd3DaTh8tUMhYE6jWJ4uQP5uE2mI7M79
	 7JJkrZlUzaQPNT8vosKCHFAq+qI8/IMAji+TiWZrKX6nh0+zDYENoqApV9OoE/7ggh
	 XSEGEzmHdixzSvP9uSZIif9IUmnleY4SR4kh0fdPgrr6wIVvbktv0CxOCcrakFcjBJ
	 +mAcEI1SXWPlg==
Date: Sun, 10 May 2026 09:32:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Kamran Khan <kz@inspirated.com>
Cc: Jeff Barnes <jeffbarnes@linux.microsoft.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] crypto: af_alg - Document the deprecation of AF_ALG
Message-ID: <20260510163204.GA2279@sol>
References: <CALCETrVqG+1yErRJjkxvJrf=A+Vu84HTR4Bx1Pcd8G1C0PJcMA@mail.gmail.com>
 <14A441D8-5370-44BE-8732-99BF8107C3FD@getmailspring.com>
 <0b8bba44-f6bb-4d69-b9d4-5787c276d41a@inspirated.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b8bba44-f6bb-4d69-b9d4-5787c276d41a@inspirated.com>

On Sun, May 10, 2026 at 08:54:07AM -0700, Kamran Khan wrote:
> Hi,
> 
> AF_ALG is useful not just for hardware-offloading, but also for memory
> isolation so that applications only get oracle access to the crypto keys and
> a memory-safety vulnerability in user applications would not immediately put
> the secret key material at risk.

Note that if that memory-safety vulnerability leads to code execution in
the application, then it doesn't matter that it "only" has oracle
access.  It can still decrypt any data encrypted by that key.

The relevant threat model would be arbitrary reads, not any
"memory-safety vulnerability".

> I understand and appreciate the concern with complex attack surface and the
> increased frequency of attacks in this area. But I fear that completely
> removing AF_ALG increases the risk for userspace applications relying on it
> for memory isolation.
> 
> What alternatives do userspace applications have on Linux for ensuring
> crypto keys are not exposed in user memory? That is, FreeBSD and NetBSD
> natively provide /dev/crypto; removing AF_ALG would kill the only equivalent
> option on the Linux side for kernel-delegated cryptography.

The standard solution is simply to use an isolated userspace process
like ssh-agent.  Yes, the keys will be in "user memory".  But "not
exposed in user memory" is *not* a correct statement of the problem.

(Also note that protecting not-actively-in-use data from arbitrary read
primitives doesn't require cryptography at all.  That can be done simply
by using mprotect() to remove read permission from the memory, then
temporarily adding it back when it needs to be accessed.)

In any case, any hypothetical security benefit provided by AF_ALG would
have to be *very high* to outweigh the continuous stream of
vulnerabilities in it.  I understand that people using AF_ALG might not
be familiar with that continuous stream of vulnerabilities, but it would
be worth spending some time researching what has been going on.

- Eric
