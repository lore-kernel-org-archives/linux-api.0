Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795313654;
	b=1u66hBmsCbHb7W0H88ejXSZsMu32tSIB4UhkcjmRU5w2AudM/fpqxfCMR2q6K22y95J5
	 G8TGB6FLbH7AHPgGUGh1Ld/zrhUZrvvRgy8Un0CeK4vHcjNzyFrI7tQYd1xYyKj7wzXyE
	 GmlxCa0KtcFOM6OPgQ3Oqmh0hBOJ6kqNM7coRVeTU8m1MSNwKgxPuUoMw5XPxuK5yZzUo
	 dR8I5KCQ1JiCG5zWvh+9cCNqsytxy6KLDKv0uvTpHaS6gpr7Jhw0MoPCyqmX14ZicLwrH
	 thpSbxqSy1Itnc6PMcrDZwZ31kOUQKKMWwD4yigf+mPX0s/kBqbIVAkJP8FEl1Jf4cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795313654;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=iD7PU7NGCfMwNQSYxjLcnZ/03erTTfgXSUkJ21vjtj4=;
	b=LXOwmkQGI2x092i4hF+2Mr0wuf1pCGIG6ChPXySBLl4W4xNca1cYhUHemT7ap9z54tKS
	 mDp5lEb2EquEj5e3B1rPO9O1sK3jLpXX4bO+GG46eqtQER4p2TXvTZaZ8v3EfqH/vBMdK
	 Ct8a2dyfMWTw7V3jRl6fYtgUL6ZgadI0aXRU6cFpktWZ1n/AS0K8ZZl3misnRKvlWyl+u
	 2OKBIn7F+s+oe/iFMIVVQG54JUvdOBnliBTqQVVaZGIhEC0VYkI5wsPJKCUM2ZDkm38J5
	 KJBIuV2ITmzZfBY/4IozMVqBaPFh2cB6RKDg4cyl3Tf5xIipBoACuv1udGlP3RDKNbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e06Le3L6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80BA606A335;
	Sun, 22 Nov 2026 02:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e06Le3L6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0481F000C0;
	Sun, 22 Nov 2026 02:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313654;
	bh=iD7PU7NGCfMwNQSYxjLcnZ/03erTTfgXSUkJ21vjtj4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=e06Le3L69uIarz6TxZbSSwnjOY2OrQN2BJ1eOkIW53/hqfLug71vs1pllVZsSyRym
	 FrcQ6gSGi1UODlKwR424j+c/ZjV6U8FGmIieiUZR0PMiFeLEy2dcgcsodQCDQBwIf8
	 5DNUe+WeTNk2pmeDrZV0oESzQnlz3MN4N1l/UZ6+TMslyckRBYLsU+reaZAte6yTOr
	 92pGoByfmYr8DAi+v2tD+HNfF1T6U0RyqgNK3mF5qFtwkxWhYii+Zm+9E+vnshHqT9
	 rX2EbP1s8XOpxerozC8ObutQLVaea8GcheD9KolKUGCQy7iZY7USb4LCUx6E2ER63c
	 AmRZlRXhpNiEA==
Content-Type: multipart/mixed; boundary="===============0180983141646698394=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <eeaf83fa0a0e98aa72195ee35fd24ea0b0b539a3cbd53cbdb8200e94839eb49f@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-7-jarkko@kernel.org>
References: <20261122011809.2667684-7-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 06/26] mount: Support MOVE_MOUNT_T_MNTNS in move_mount()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:14:10 +0000 (UTC)

--===============0180983141646698394==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mount: Support MOVE_MOUNT_T_MNTNS in move_mount()

TL;DR: Nits only in attach_recursive_mnt(): the repeated cross-userns
condition could be computed once into a local, and the comment doesn't cover
the new case.

> diff --git a/fs/namespace.c b/fs/namespace.c
> --- a/fs/namespace.c
> +++ b/fs/namespace.c

[ ... ]

> @@ -2728,8 +2741,17 @@ static int attach_recursive_mnt(struct mount *source_mnt,
>  		struct mount *q;
>  		hlist_del_init(&child->mnt_hash);
>  		/* Notice when we are propagating across user namespaces */
> -		if (child->mnt_parent->mnt_ns->user_ns != user_ns)
> +		if (child->mnt_parent->mnt_ns->user_ns != user_ns ||
> +		    (cross_src &&
> +		     !in_userns(child->mnt_parent->mnt_ns->user_ns,
> +				src_user_ns))) {
>  			lock_mnt_tree(child);
> +			if (cross_src &&
> +			    !in_userns(child->mnt_parent->mnt_ns->user_ns,
> +				       src_user_ns) &&
> +			    list_empty(&child->mnt_expire))
> +				child->mnt.mnt_flags |= MNT_LOCKED;
> +		}

This isn't a bug, but could the repeated test

    cross_src && !in_userns(child->mnt_parent->mnt_ns->user_ns, src_user_ns)

be computed once into a local here?  It is evaluated in both the outer
condition and the inner one, and child->mnt_parent->mnt_ns->user_ns is
spelled out three times.

Also, the comment above ("Notice when we are propagating across user
namespaces") doesn't describe the new arm, which fires for the mount the
caller placed itself (child == source_mnt) when the source tree's owner is
outside the destination's user namespace, with no propagation involved.
Could the comment be updated to cover that case?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============0180983141646698394==--
