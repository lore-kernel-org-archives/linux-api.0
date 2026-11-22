Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795379307;
	b=i4gQqVY4ckjXGxrBwyVZJJuA0ddctmGXmzxoFRGU1A3outJBzHkDXEcXRWjcHCCOOfDg
	 yOrt12pncwfPsZ41M5c0z5raAT1eseIOE3aOrst0CaaK5vOhEyy+REkH0kW0k4cMCqIWu
	 BDd74UKZSRrxFAS/KzKSB2gTqaYjKcirEvf2b/pKz5d2VDojQnaKiJM8iJRu5C6+gtuOv
	 QToKMsUy+ZJGsId2AJ+fDyQ4IRbg68uxmJIyPU9XXKcCWXhklAAz3iSIP1ZyYD1MyW5iR
	 0ZRLsZxSqvkqIx57leqV+vwyvBsykdMJWnwsvgg2cbVzuHULsmt03mIKzRCGtkLmKEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795379307;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=MKGFNqJhoZuyA4EsjC0ZPdlEy226OjjF7ifp8YCJ0pw=;
	b=144f4Vtb8ZGY3laXaXMwwi4M6bZuzg3oqI8pznNegTrOG43T1uml35lZIWjFIaqMO/SR
	 nc6cvKExizoxrgCJBLuLdFQrB1BeZPiyo5QjY+RruY3sdaSaJxxADYldwd5vOpQz+sriR
	 adknRfMjN4ATH111Qn78fY5lxMFIParzop7loyHsDr+Yf4sDRCjnepIEs8oNEoKWf5mJ+
	 iD4UpM9CMVnMKdlboK+Zx1pWHzIv7mY/Ksgcl+AJoSMVHbcmHy6Q7wzSWNJPXc1IfmaHw
	 f0jMb47s8bYUqy95/6AcSijtbo5nk0LomdvtWdvUxhoJ270JPtQFqk6Y/TcJHZk7PlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ul+eGqK1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B44E606A320;
	Sun, 22 Nov 2026 20:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ul+eGqK1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D2B1F000C6;
	Sun, 22 Nov 2026 20:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795379306;
	bh=MKGFNqJhoZuyA4EsjC0ZPdlEy226OjjF7ifp8YCJ0pw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Ul+eGqK1TzFk2GoVQ4qrcBtOfQtz9OLX+r4wppvttMllEuX+UwzW1YrAza7piQ2z0
	 WlQEMFrQCqDRV/6+Bcs/s1B/8RLtRAwEleegTr1/l6KB8BQUa19frILcGbvG9dGYpx
	 4zTJxLgzLxbKXvc462NcWNBSfVVSfo6qe05JfkRdnmVJeP+kOzBbvvyX2PoD39sc8d
	 5rNOYL+fMqgCL2eaxnfu8+WJyrOsBaI6KLArf/WCXb4ZiBLFQGQ2bukxmVh7RqbxMt
	 d/k/9lmqJ+g4mDzA1M3aLWKaOzgnTiXB1wXQn63rKSA00Rfuqj1LWJpFWOw6itOPFv
	 WNf9nQHOsewgA==
Content-Type: multipart/mixed; boundary="===============0979252114820036136=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <516d488e2aa670a706837915ba7a73f107db09ac4eb736a4a86dc3624dd1c69c@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-19-jarkko@kernel.org>
References: <20261122193539.3334213-19-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 18/26] fs: Support FSCONFIG_SET_USERLAND in fsconfig()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:28:22 +0000 (UTC)

--===============0979252114820036136==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> fs: Support FSCONFIG_SET_USERLAND in fsconfig()

TL;DR: Nit only: in fsconfig_set_userland(), the fs_type restore block looks
unreachable, since the only swapping filesystem (cpuset) fails the flag check
first; it could possibly be dropped.

> diff --git a/fs/fsopen.c b/fs/fsopen.c
> --- a/fs/fsopen.c
> +++ b/fs/fsopen.c

[ ... ]

> +static int fsconfig_set_userland(struct fs_context *fc, struct fs_parameter *param)
> +{

[ ... ]

> +	if (!(fc->fs_type->fs_flags &
> +	      (FS_USERLAND_MOUNT | FS_USERNS_DELEGATABLE)))
> +		return -EOPNOTSUPP;

[ ... ]

> +	if (fc->log.prefix && strcmp(fc->fs_type->name, fc->log.prefix)) {
> +		struct file_system_type *orig;
> +
> +		orig = get_fs_type_noload(fc->log.prefix);
> +		if (!orig) {
> +			fc->phase = FS_CONTEXT_FAILED;
> +			return -ENODEV;
> +		}
> +		put_filesystem(fc->fs_type);
> +		fc->fs_type = orig;
> +	}

This isn't a bug, but can this restore block be reached?

fc->log.prefix is only set in alloc_fs_context(), to the original
fs_type->name, and no parameters have been parsed yet when
FSCONFIG_SET_USERLAND is accepted, so fc->fs_type can only differ from the
prefix if ->init_fs_context() swapped it.

In this tree cpuset_init_fs_context() is the only init_fs_context that does
that (to cgroup_fs_type), and cgroup_fs_type has neither FS_USERLAND_MOUNT
nor FS_USERNS_DELEGATABLE, so the flag check above returns -EOPNOTSUPP
first.

Is there a filesystem that can reach this restore with a swapped
fc->fs_type?  If not, could the block be dropped to keep
fsconfig_set_userland() shorter?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============0979252114820036136==--
