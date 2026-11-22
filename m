Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795313638;
	b=SB9pBR6ZhPS+2bIBPw/Gar9OUbZx7j1idvtTWJ8DI2EBxFUxXeDMXxwOxtAwxM0tEeLG
	 PiBN4L3M7S6W5wRK7orZHT1emLQjMHxku75HgPihJK1CzPi4TAvadcdAd2VUqyJxZk9l9
	 6B1yJ0RcO2gdPxyiQCvbt7wZA4IMRGyK5qSyfUYBPvDu+UuVm1+n19NnBvkl3z6RZ2HsS
	 Iif4zrbzW1ucmC0Sitn7P0UrUNA9gtIXZpmodtZ8Z2LGHHuxpkpufPm9AfMnuaQuAEhhN
	 0eVpqQSoOsV8DXBxFNGS/wXScvxZ7HLTZg8cacnkOdOrECE9ugq1c3h/KlE2bBQu6Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795313638;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=wQ82POZlS7r2+ERP/+zIeUXyz4CXRnCCzvZCXGyfWyE=;
	b=GKfhaB0DWIY5YBI7GrWo7uPofQdnAhTTgd90+PVjzn/o7l48YFBQi6sX5N1LXDY3rPqn
	 QqTINOSStYOFRq6eYEwqr/+cng/G7ncXfhtgTvpFFkK2ZWmLtTvCUmtbhNfunQlae4rdz
	 PnmzyOhMS//oFnA5hrngmr4OZKiSPNen5/mNEgdLQqJ60DbPqrUQOWzBFWZC31BpI5bc6
	 9BeMhhJeMOUHgaorzjei6p3o7UaEAoGQFkb1PrpHOgkTfEGUEgycnAg7JmbhdVDXVbGFc
	 mXq2fDoPQfd9JNK3I9xSneU2U+LWjxCYCqM4woHqawpd90gZv7t8q//NCesYrao2bmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lLR/wxyX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92AD606A33F;
	Sun, 22 Nov 2026 02:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lLR/wxyX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD871F000C6;
	Sun, 22 Nov 2026 02:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313638;
	bh=wQ82POZlS7r2+ERP/+zIeUXyz4CXRnCCzvZCXGyfWyE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=lLR/wxyXLGgBm1hR7Rrr5zEpQdI+izxUfnDTQ9baVoWt9TYCTtTbFiXv1MaR8EQRu
	 XBilrRTHsGZrtSXWdnNCEIwLa1KjPuOkPzzrcwmCwAthqjw4ANEYkmS1STf/vbnEAX
	 tBEAguEBMKLv5hUFQ671CrPULalwAiMoh1EWC+r05Ya03pcXY4s9MyAfAtG5YVgpyG
	 6Mjro/EF5MKbBx5Mmea5cPavRnl7GffrOrX/tLB9g2Kkq4Br4FUfSiv/3GZxFcOyKa
	 xc5+OxbErdGOXYf+vxfkFbmsdAB9X3Xv9+lVV6GwPoooqUmueRI9C2J/7IfnLjIfSr
	 9ldrkm365H49Q==
Content-Type: multipart/mixed; boundary="===============6528941915844312338=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <49ce5ae40b28e104e8fcafaddf26c5825c243908ad6a27003e7eeb82b85a0009@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-6-jarkko@kernel.org>
References: <20261122011809.2667684-6-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 05/26] mount: Enforce mount_too_revealing() for foreign mntns
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:54 +0000 (UTC)

--===============6528941915844312338==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mount: Enforce mount_too_revealing() for foreign mntns

TL;DR: Nit only, not a bug: the CAP_SYS_ADMIN check on ns->user_ns in
mount_too_revealing() is repeated, up to three times, and could be computed
once and passed to mnt_already_visible().

> diff --git a/fs/namespace.c b/fs/namespace.c
> --- a/fs/namespace.c
> +++ b/fs/namespace.c

[ ... ]

> @@ -6582,6 +6582,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
>  				const struct super_block *sb,
>  				int *new_mnt_flags)
>  {
> +	bool foreign_ns = !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN);
>  	int new_flags = *new_mnt_flags;
>  	struct mount *mnt;

[ ... ]

> @@ -6650,13 +6656,18 @@ static bool mount_too_revealing(const struct super_block *sb, int *new_mnt_flags
>  	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
>  	unsigned long s_iflags;
>  
> -	if (ns->user_ns == &init_user_ns)
> -		return false;
> -
>  	/* Can this filesystem be too revealing? */
>  	if (!(sb->s_type->fs_flags & FS_USERNS_MOUNT_RESTRICTED))
>  		return false;
>  
> +	if (ns->user_ns == &init_user_ns &&
> +	    ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
> +		return false;
> +
> +	if (!ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN) &&
> +	    current_chrooted())
> +		return true;
> +

This isn't a bug, but could the CAP_SYS_ADMIN-over-ns->user_ns result be
computed once in mount_too_revealing() and passed to mnt_already_visible(),
rather than calling ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN) again for
foreign_ns?

When ns->user_ns is &init_user_ns, the first check here is the same test as
the second, and mnt_already_visible() evaluates it a third time.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============6528941915844312338==--
