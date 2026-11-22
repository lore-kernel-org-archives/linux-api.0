Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795378154;
	b=j8RJbrUut7P8xT0KLO/r/PuhpFJdYLy+fbw+geZO9Rpx85Y+E9pGuQPPPhHlAO9n+Oya
	 YglKLU5ttxFpd3PRk/Jw5IGFKOhRYq7YHKJCV4VBs+fwRjBUwuEIlUte6jnfaxmqBa9ob
	 zJayQW7einm8uvyRcnXWu3u4gjWKa0UAD7WyQan4lBaIqPYXK795/f4fQPQs0/6R6eKYL
	 p8Qf4bb6Uv5xur5HhHBbzpy6JeI2DK45kQP7ssIqF3laezyOOeZb5jHcCPKRVOZ5SNOz+
	 Lq4n2F2iyd3JSRSkT6pNuFO0LqSj6hPIc57mx7RmcNBTKW4EvZ+HVG8ata9nTKOhmTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795378154;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=qgAd/VA0V0SFS6QRkanen1M9m5R72JoHXnNt9l1b0f0=;
	b=01bUJTZCyZOmddzhEUYHlkrkQBwLrXX9tjPasyOUeuvVNiKPxsgWwAOIplYlfSggY5Qn
	 6wxHRuOzfx4MzSFzqjYF/DHvWxNe1HlKsSnHkNndHNXBe2GGls8RSUOkYyxsua69gXWOC
	 XRehfN2/9GuF/srkCs5glov8YjStx/a8RmaNScWiOXbmm5/E9yySlYk57aiazn4tHaW2I
	 pIYIpHeWbJLLDnCjaqE5cO3mghV9gbAzHwoJlMKHzrKXaVCQzfC6Utx/Cp9SHzaj1ce88
	 LlplUVM2mzYtapdl+rj4tRMaPLl2geRBULUBnTnJLvFdSBDiVYzu9pmoqAVlJKE5wgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="P28TG/jf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A859E606A31A;
	Sun, 22 Nov 2026 20:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P28TG/jf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F891F01568;
	Sun, 22 Nov 2026 20:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795378154;
	bh=qgAd/VA0V0SFS6QRkanen1M9m5R72JoHXnNt9l1b0f0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=P28TG/jfj557Y7MNEKVfg8PB17IIaPG8EaC4Ckjlz91mj3R99wSOaJlPtXNmt8Rjb
	 QUjgXZGIUX5ijXTicGbgnAkNvSfvrerDwEo0ccVCxYsOyP6YALLBbmtkxCFGLPmjFD
	 pDRZvJawql5AxieBhsba3ay0Ylbms82auYGDyB8KgQPP9vPfPuzc8pA4A79Eve+SRh
	 0zxbXKi/4chaRfYvPCYuW9WS+HHgIaqWUeEdEbVQZyi8onJatTBgKPxGqwdrdPGa7+
	 JPlP/KrqNBrHfel0Y0JV06vSuN1GW8oWBKgLQUki/1mbgZHRq+tN9aFty3QtWaqoDB
	 t6Fr3eSQU+EiA==
Content-Type: multipart/mixed; boundary="===============1507986254413833181=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <6d2f2a9724b36a8a1329286865eb8e8502d9e7541d523a21602fd3cb0315fedf@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-12-jarkko@kernel.org>
References: <20261122193539.3334213-12-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 11/26] userland: Track init lifecycle via copy_process() and pid_namespace
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:09:10 +0000 (UTC)

--===============1507986254413833181==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userland: Track init lifecycle via copy_process() and pid_namespace

TL;DR: Nits only: userland_copy() has an unused tsk argument, and the
rcu_read_lock()/unlock() pair around task_uid() in userland_exit() may be
redundant.

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c

[ ... ]

> +void userland_copy(struct task_struct *tsk, struct pid *pid, struct userland *c)
> +{
> +	if (likely(!c || !is_child_reaper(pid)))
> +		return;
> +

This isn't a bug, but is the tsk argument of userland_copy() needed?  It
is not referenced in the body, which uses only pid and c.  Could the
prototype take just the pid and the userland?

[ ... ]

> +void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk)
> +{
[ ... ]
> +	leader = tsk->group_leader;
> +	rcu_read_lock();
> +	uid = task_uid(leader);
> +	rcu_read_unlock();

This isn't a bug, but since task_uid() already takes rcu_read_lock()
itself, could the surrounding rcu_read_lock()/rcu_read_unlock() pair be
dropped?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============1507986254413833181==--
