Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795100730;
	b=K6IK5S9XmtCJJ1F4RdydsRLPfnTOYmjMGGvPKPB1vKgDXerMHJjM5Bhp6btB+0yViTDH
	 oVfovkYYvsB3ZKoOW+dPir8rbpxqXJIyQ5GInpW1NpueAnwUW/ARGj0AxAn6dtN/mFVHf
	 e1KBD+fJIJAKAxk+6b682Tg+66n8h3DEwuOpZPDUnb+K0bOfA7cw7g+VTbVAQvcMSwxAE
	 RmAnJuot7v6e+Mbpl9KvGjy7ZZz5CwSH8xYQi82hLB8k44Cm0+VxhcVoEvPuYlaUcHY1z
	 1nrJDf5OJYf6i3k63PN/uZ6zH69hVOqepp6FXNTFUo4C+QLKn/kMnL7+JN1sDscDB0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795100730;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2IrwUYnRl/CCcIkHyQ8rD1wVGp6x0G+ouTuLDtWvXeE=;
	b=Ih9eYJW6P0+ko3S+GYlDYiTlRKDRb7m0BVkWyVMgZhZn2VUulVGbtPryZJftrJv38lyZ
	 ksXgcK/olt9GkijapRRz7FzeHUFNIhE8XC3QqH8NK074pinH+Z9JGnb8Du9sKQugx7gke
	 0wzkKpKOwXs8D6UHu5ioaRLmMiRLOE8jFBKlodYOy8C3x0DIzmC38Mqc/vsuHzeLJ3037
	 XjqzY6E0uTaEncGR8xOzgt0cU1MiHtCoHAjMaKY4vCr4Q5AV8fEby1uY7VPKavX0qqNYq
	 aPfZiiZ2Z7oBgqGJQSNGEYb7Z4URafSe/jMTJ8zw71h83aYyLub6L+VBNUP4sFeWhig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FVCdDZz9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 82453606A324;
	Thu, 19 Nov 2026 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FVCdDZz9
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7F96D1F000C4;
	Thu, 19 Nov 2026 15:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795100730;
	bh=2IrwUYnRl/CCcIkHyQ8rD1wVGp6x0G+ouTuLDtWvXeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FVCdDZz9CLOzCqQsYElv7NRpYqkN3P7TxOGmYw37Nt2LIqrKvGPDv0cm+uD2pfsxo
	 reNk0EkMxZdKrLdZ9uuI4nobaoUOyq381WXDOPT/qbY+/22pTATrYksY1SPKUCQUwU
	 OeDqUtESjF2OrtNUkoeMWt1WYxoX9OfHUTybLCGUCbsvEw8mIdp8GykomUioTiRIql
	 Tv4B61awo0otLnhmH6ZEzySA2YUo2/dTWIXuWTVYnkNG8ODdZfVNrDyXx+NGvRHCa1
	 dXZ7iSefdREPcENzx9AlTrLesVex9IbQhbtBvPv7IZ/YCBmIafp1kxixS5wRA92LpZ
	 g/47LCbfIpyMA==
Date: Thu, 19 Nov 2026 17:05:26 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Hallgrimur H. Gunnarsson" <halg@google.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Serge Hallyn <sergeh@kernel.org>, Andy Lutomirski <luto@kernel.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	David Howells <dhowells@redhat.com>, Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Jonathan Calmels <jcalmels@3xx0.net>, Jann Horn <jannh@google.com>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	KP Singh <kpsingh@kernel.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org,
	containers@lists.linux.dev, keyrings@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] userns: introduce capability bounding set for
 user namespaces
Message-ID: <av8QNiFcnGWocORy@kernel.org>
References: <20261119104208.782900-1-halg@google.com>
 <20261119104208.782900-2-halg@google.com>
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
In-Reply-To: <20261119104208.782900-2-halg@google.com>

On Thu, Nov 19, 2026 at 10:42:05AM +0000, Hallgrimur H. Gunnarsson wrote:
>  static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)

I read the diff through but this led me to dead end. Cannot find this
function from anywhere. I look the changes again once this is sorted
out becaus this is interesting.

I wanted to look at the call site to understand how cap_bset gets set,
which is not now possible but I do get the gist and agree with it.

I'd figure getting this relates to my rootns patches (perhas). One key
mechanism for me resolving the unprivileged in my use case is
MOVE_MOUNT_T_MNTNS [1], which is orthogonal but just pointing out
the problem space.

I read through https://lwn.net/Articles/978846/ to understand the topic
overall. Just mentionining as a possible addition to the cover letter
(not a priority/necessity).

Hope these help and can be kept in the loop :-)

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/commit/?h=rootns&id=cb058646b3dd76b13f5044846c119fe1d28db4bf

Br, Jarkko
