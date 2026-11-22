Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795379284;
	b=lhRwsbBcE8CC3oEG9PlmejTlLgoK633nzCvnUmrowSDyUnMPBvLmiIUuA1EVMusuqxCP
	 GmWrqo3craAJoZYcxHY/yzTF5/xh8tiPWyFpGQdUU+R7H5UTy6JQuSQRGUwkkF9kLLi+x
	 5ypVMBkymtdS2aAcPEnf/lYSn9QC16FHONMtYDmWpt9NjD0nKBU/DjlPnT8z/fpdWxBOZ
	 4aGntLO6OBp9QX1toPOlCKU5sPTc3gsx2GGHrcOMrDq3BRuiLo1detYMLmd73nKE057YY
	 xvqn6BGvrQmL7x5RitS1Xj7sMvG7dZOTD4EYVjJZtJ3RNwpx+/7/Eco8dqrvutkw4vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795379284;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=hX4n2ELcNNj0/4nHT8RN7SbsIUQvyFqPuov+TG5Nv9g=;
	b=0PpT/jxKVddrsw+T1qelY5W5A9EGWH4NJQaZtQadGNIVNi9Y8FoLwpaRMUhV/bmeYU0z
	 GHca0wBngnckJ9HMvGta6cpXHZqQ27HSp6J2ikpTPkmO6ydDsQL/xtLh6KrhgxYZNXCB7
	 CBcqHfwRKXRZqS4aAVZyCXodvcjcA7eEKmmBpRj86g57ZTQgLiiGZW9lBJe0U3//aEINd
	 v016eNA1pinA6kIzPE67EnLq7+aIZC4zhvKCsKjkrD7w/6tPsEiwHFhnbygHY/EB7YeGp
	 ydGrGBCstSienFbSGrrvRo4aUpFGRxW2zs/O1QSDbPgEzA0ZcV5pFQABGAulSj2hytA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="DtQFC/+B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D14606A31A;
	Sun, 22 Nov 2026 20:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DtQFC/+B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579341F000C0;
	Sun, 22 Nov 2026 20:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795379283;
	bh=hX4n2ELcNNj0/4nHT8RN7SbsIUQvyFqPuov+TG5Nv9g=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=DtQFC/+BjIVL35yRIkQAYiez++FX6dq1X7g9+U5wiM9l5aQa2bCiQa0lA2KTXkgKO
	 2GT1VmmiI5zeFd1FOhAPus/+fS4ofCKzqBssX2tUSpnCu5DOjAqzn3puJ0tq8KB9t4
	 GpNPbpdGJuuLtuJfgKRWiznvitvtiWUv388C8tOsf0YN4/CfgUZ1IiMn3x35uwU0Mn
	 1Ao9M5lEIvKdmb/YeWSZ7g4sl3nh/deToqadEqFwGkeoAk1OyDwjyExdU9l/1PjW8N
	 jHMgktO+4YczGQbKoF+Q9d+vLGJmsYwWWN9aZj/3h6aCyWyoR5o2gpSdRDOswa7+zR
	 QEgyW1cP1w0QQ==
Content-Type: multipart/mixed; boundary="===============7306649944735902366=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <b6da91bd7d0e63cbf8a3d96298191544d46afbc7d0ba1a7fa55b996f7d7cd7c3@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-11-jarkko@kernel.org>
References: <20261122193539.3334213-11-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 10/26] userland: Add core infrastructure
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:28:00 +0000 (UTC)

--===============7306649944735902366==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userland: Add core infrastructure

TL;DR:
- USERLAND_ALL_FLAGS in the uapi header becomes fixed ABI; adding flags later
  may break rebuilt programs, so consider keeping it kernel-internal
- USERLAND_CLOSE_ON_EXEC naming nit: other flags use *_CLOEXEC

> diff --git a/include/uapi/linux/userland.h b/include/uapi/linux/userland.h
> new file mode 100644
> --- /dev/null
> +++ b/include/uapi/linux/userland.h

[ ... ]

> +enum userland_flags {
> +	USERLAND_KILL_ON_CLOSE	= 0x00000001,
> +	USERLAND_CLOSE_ON_EXEC	= 0x00000002,
> +	USERLAND_ALL_FLAGS	= 0x00000003,
> +};

Should the USERLAND_ALL_FLAGS mask be exported in the uapi header?  The
later userland_open() syscall validates with:

  if (flags & ~USERLAND_ALL_FLAGS)
          return -EINVAL;

Once released, the value of this mask is fixed ABI.  If a later kernel adds
a flag and grows the mask, a program rebuilt against the new header that
uses USERLAND_ALL_FLAGS would get -EINVAL on older kernels.  If the mask is
left unchanged, the in-kernel check stops covering the new flag.

fanotify hit this: include/uapi/linux/fanotify.h marks FAN_ALL_CLASS_BITS,
FAN_ALL_INIT_FLAGS and FAN_ALL_MARK_FLAGS as "Deprecated - do not use this
in programs and do not add new flags here!", and the valid masks live in
include/linux/fanotify.h (FANOTIFY_INIT_FLAGS).  Other fd-returning
syscalls keep their valid-flag masks kernel-internal, for example
CLONE_LEGACY_FLAGS in include/linux/sched/task.h and VALID_RESOLVE_FLAGS in
include/linux/fcntl.h.  Would it make sense to move the mask to
include/linux/userland.h?

Also, this isn't a bug, but should USERLAND_CLOSE_ON_EXEC be spelled
USERLAND_CLOEXEC?  The other close-on-exec flags under include/uapi all use
the *_CLOEXEC form (FSOPEN_CLOEXEC, FSMOUNT_CLOEXEC, OPEN_TREE_CLOEXEC,
MFD_CLOEXEC, EFD_CLOEXEC, ...), and the name cannot be changed after the
ABI is released.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============7306649944735902366==--
