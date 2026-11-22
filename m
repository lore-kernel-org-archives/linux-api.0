Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795379296;
	b=ZUkAPqSFJcOUaO3r8axWGw+aoI+deFmK1QhBTEWg8hdsFAtlMAo5VwZAD/eaQpOOIUoj
	 ei3VLNaaQlEwJP7aCpW7QrmullvpsiTcXE0ALjrpjbLfxnluBXdZAqgy0vOOdOg5yyXIm
	 tPj/vJ1Zwkyb8CeleO3M/cSvLz+pL49ITCo0WTAA3IpfTc4rduMzhipXXqXObo55P7yB8
	 d3fb9fGA8/TV+hiVgKEYWCgFk10Zh9Z6Br/gaVCRmL3n/j8z+yr4Sw3JHG/2P0PmOWfFn
	 UzV5ALskJ1c/2nm9vMFSp5ytFIINI1hGZfFoFEVRMPBzSieL7g1Vo5AC6zspmUqFycA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795379296;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=2rwax2wpP896bdTS8rm+H3FuFS+cnVXOxY0nVpujxFo=;
	b=fHs/csSMIXTZLVMV8lg/DVFaDDBBQp3RvQ0OqSgK6yA13gXrc4n0svcEl6eSa79JHdmS
	 Y3pDHFPiLDA1+TfEGEmxB1LqMJCHWZepdVFT87KmadnXApSXXNcWVjYfvo1Sjqs0uQCqZ
	 /S0afEYTYjd5kx7DWUK3THhjmgQk+WFJFCJeWc8mqmNpx7JOwa5ByO0CSn7/95lQeOY9J
	 QJ23Pd07LpyvqVDPZMe1vTEu+T9XBCbHTV1r37WyBVt2GGOf8fwmndksdPFEm5hAiY+sq
	 O6J2L0Ce5Jq4swW3XXJ9fmD5aYdz0Kyo2XJCVo6ZI6m/2olTrLAs12VYMB2dBC9fDpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZTwy6TCa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF39E606A33C;
	Sun, 22 Nov 2026 20:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZTwy6TCa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAD11F01568;
	Sun, 22 Nov 2026 20:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795379295;
	bh=2rwax2wpP896bdTS8rm+H3FuFS+cnVXOxY0nVpujxFo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ZTwy6TCa0eRPwX35Jv2r1gWjHUFr+6zJNZuqCB+5gMbCBfHTJOqoFO0JEUJ3n6c3i
	 hvRA4rO6cbOI/xv7KdGe5i45tt+WGyr2G+fc0jVk5lQCOO8SEjpnYjsV7SuhkNlDpv
	 WDE8jeg1ZDRc3EKFBcysidI36X1hR5pVW5gO5lveRLa2Pqnda8eYGj1QzyZaUcCTc/
	 kgiiaWwyupBvbh8ZuG+lkQB9sYKi+kyAJkOYdvKjvEnOiwEpjb3M8DrmykD8Xu5ha0
	 AkNAF5I006DgFO4JQzCTy7wBnGLV5pV24QmD0mCPaVVRuwTIx5F7dyVfKHstZVVU24
	 YnYQInMXwm/bg==
Content-Type: multipart/mixed; boundary="===============4659356257046684705=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <cac1fa0b133e15e7c67629319df17a0d25747093535aa246f44a75cb1073e2ed@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-8-jarkko@kernel.org>
References: <20261122193539.3334213-8-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 07/26] mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:28:11 +0000 (UTC)

--===============4659356257046684705==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS

TL;DR: MOVE_MOUNT_CLONE is reported to LSMs as a plain move, so AppArmor may
mediate it as MS_MOVE rather than a bind and could allow or refuse the clone
wrongly; should LSMs be told it is a clone?

> diff --git a/fs/namespace.c b/fs/namespace.c
> --- a/fs/namespace.c
> +++ b/fs/namespace.c

[ ... ]

> @@ -3842,6 +3840,36 @@ static int do_move_mount(const struct path *old_path,
> +		if (flags & MNT_TREE_CLONE) {
> +			unsigned int copy_flags;
> +
> +			if (!check_mnt(old) || old->mnt_ns == target_mnt_ns ||
> +			    (old->mnt.mnt_sb->s_flags & SB_NOUSER))
> +				return -EINVAL;
> +			src_user_ns = old->mnt_ns->user_ns;
> +			copy_flags = (target_mnt_ns->user_ns != src_user_ns) ?
> +				     (CL_SLAVE | CL_COPY_UNBINDABLE) :
> +				     CL_COPY_MNT_NS_FILE;
> +			cloned = __do_loopback(old_path, true, copy_flags);

With MOVE_MOUNT_CLONE this makes a recursive bind of old_path, but the only
LSM hook on this path is still security_move_mount(from_path, to_path) in
vfs_move_mount().  LSMs get no indication that the operation is a clone
rather than a move.

The clone branch requires check_mnt(old), so from_path is always attached
to the caller's namespace.  AppArmor's aa_move_mount() chooses between its
cases on exactly that property:

    if (!our_mnt(from_path->mnt))
        /* moving a mount detached from the namespace */
        from_path = NULL;
    ... match_mnt(profile, to_path, ..., from_path, ..., MS_MOVE, ...)

So AppArmor will evaluate this as an MS_MOVE of an attached mount at
from_path, the same check it makes for a real move.  But nothing is moved
here.  A copy of the source and of everything mounted below it is attached
at to_path, and since path_mounted() is no longer required, any directory
can be the source.

With open_tree(OPEN_TREE_CLONE) followed by move_mount(), AppArmor sees a
detached source (from_path == NULL) and applies its detached-move rules.
Can a profile that allows moving the mount at /src (an MS_MOVE rule with
/src as the source) now also clone /src, or any directory below it, into
another mount namespace?  Conversely, could a profile that only allows
detached moves refuse an operation that is equivalent to open_tree() plus
move_mount()?

Should the clone be reported to LSMs as a bind, for example through a
separate hook, a flag passed to security_move_mount(), or a call to the
bind-mount mediation?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============4659356257046684705==--
