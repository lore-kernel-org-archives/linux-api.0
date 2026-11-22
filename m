Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795313622;
	b=ma14m/o2pRd6pbJahdtozFOxevuaOo5w4eZ7g83r0GQxzaiaQ7lleNEH/r2cgfuJ3Wje
	 DZYLHBcuBQjUkFe8NQmt3Z5HW8/c3zbCqtuDKeEGbb1LmDr8WjrdPyKCqdO+jrKbCcBxF
	 07v3IZ9rsfDTk+/r7hekkMN5jUWaS4pfG4YAN8rf+QUwVd8z2oxf/0KvrL4jUdMliVnBo
	 qu5PyZO+9omuWL3mSU9Vc/ni93Wgl7pd9gGmAogqGxGQ5TYVzvX8lYIsknvN2hNxr6hcc
	 rshzwzh4tpgTED/5vWPSMCuC/V7J8HubGWBx6yK13NbOi0KxuW3qMAvj8fv22w8shiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795313622;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=fBzgFQxfDK4iLWmYyLcERpDKYI+EngwvDO2PASCaLKo=;
	b=rgIrFOp9ZgLl0JgEfxgQ0SWBYcnZahDhBUK6z5cGbD062z5qn0TgI3tGvJIDqBvOwdb2
	 3rlo9aH7hjczEjgDpTnbxuj7jVYL593x3ZxhwspeHr8UGdE0omw4Bf0vp//gUU5IQ+UaK
	 HUXdTe56B0joEq+WgiKLkOm5jRc0VFxo+Cr4WwfIPV1CDDg82SCxefR38VX+bD5QfantE
	 qCCdqxtF0pAwDRqKmpS++EzozXo+72tlkaTIR6D7Auy5c2O45xAmbUxCTxS/FlTMV/lge
	 SU+aOiiuItMQSB05KkDbo2YBfFLJjsc60vP7DjZjE3Ww51ooU4EgBeO8Pz7BWQIMcag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TpcNti2u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B725606A331;
	Sun, 22 Nov 2026 02:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TpcNti2u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852201F000CA;
	Sun, 22 Nov 2026 02:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313622;
	bh=fBzgFQxfDK4iLWmYyLcERpDKYI+EngwvDO2PASCaLKo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TpcNti2uw/g3I0rkQsslyB6PuY+0GdpBgwPbIyrud8im9z4Yv6rEhMrXaS8RxcOR7
	 DfhXKjvvkSFEeMK2x7O5+XlkT7rA1wCstza/LGnqT45DanBI3Ma1k0ATma9TjS8ql/
	 izYyUyb9Mvy27cBgWCGTZE1Wa61QIocuwKPFlmrlzy4qbrO8YTCcuhqeVh/p8Wz1zX
	 vbXeb+akhaKCY0lk977DvNA4jPn3BdA4kJQT4P4PqDqbZIsjH2JvNmHOd1POz6usqw
	 GXP98O7f/pcQgYh6fSbaSHWkWGoqiSmEdVJnTP2Kb20jJev/IcuOBrsnHeTmXNY4FY
	 BIWfOcDLccv7Q==
Content-Type: multipart/mixed; boundary="===============6662202981018923107=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <e38bde24044ae1f3535fd4708ab53f7e88a826f4ca42f83f2a6429f84240f795@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-13-jarkko@kernel.org>
References: <20261122011809.2667684-13-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 12/26] userland: Add userland_open() system call
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:38 +0000 (UTC)

--===============6662202981018923107==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userland: Add userland_open() system call

TL;DR: Nit only: the current->nsproxy NULL check and -EOPNOTSUPP return in
userland_open() look unnecessary, since unshare() and setns() don't test it;
could it be dropped?

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c

[ ... ]

> +SYSCALL_DEFINE1(userland_open, unsigned int, flags)
> +{
> +	struct userland *c;
> +	int fd;
> +
> +	if (flags & ~USERLAND_ALL_FLAGS)
> +		return -EINVAL;
> +	if (unlikely(!current->nsproxy))
> +		return -EOPNOTSUPP;

This isn't a bug, but can current->nsproxy actually be NULL in a syscall
here?

A task only loses its nsproxy in exit_task_namespaces() from do_exit(),
after which it never returns to user mode.  unshare() and setns() dereference
current->nsproxy without such a test, and userland_create() itself passes
current to create_new_namespaces(), which dereferences tsk->nsproxy
unconditionally.

Could this check (and its -EOPNOTSUPP return) be dropped to match
unshare()/setns()?

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============6662202981018923107==--
