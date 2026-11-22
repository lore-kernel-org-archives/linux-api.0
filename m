Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795312620;
	b=lFIzneUmXzP1W43SRHnQ/L5RH2/TZmao+GYTi4HsExz0yhXVCgl0bWVd2QQ9zEaujKdG
	 utjzyK6dqECQYRHMY2meNcDPFI3sli9YPSfnAOEyHYx8MJTlhmWn6vQXOr53RVFnHTQNC
	 D7GWjxMBGTXj19Fgp/Z8/dq7DJy7SqcgjuUR7uYRbuf+KNwiGR0ceubLBInzP9sN8uRB9
	 0v2so2Do5+dMzUmrVBUSgM+XO8gD8w6vxbvZQjJsQZeD0rAaOn5/ipvqbp45Y0xlmaYFL
	 7Y3CFOV29bYuf6NoWJgEebhjLjJ7DKUrkbjMXMpQjj3BX4vrSvRDSWrV0PTAvvC+cZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795312620;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=ThwrOz4KQaf/68vZr/EK5L1WefkBvf/yK3CtlQ1HEo4=;
	b=X6ZWxYEv4uEoMlolZOUT9QvraY3is+LXS8/Ghkd5XIaPFtynTgw547/fND4c+7MN0G3P
	 SrnglmRWMcdkSeIb27U1m4LiVq2yDmp8Prz/cC5zLmZgMOvGARW8kIFgN++beGeutE8m9
	 q7B7vgfGEyRJKFf5pu+OTYgfC5PBMgPOtZdH/ZUUdvvZcQ2NKuYpIWlxz7taAJszuiYYi
	 xpNVUH1qtdqgyZqDgHtx7+Ste2fB8DE/W8Eg1fzerRgIeSprDjHCIrXCbQ+1hvj0UwI4W
	 WTOQrWKGzmCP7x7nyN+A2ZD96sKIZszVBsdqL4z/JQLhhomIdIAPifw18TUI/TSboUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GC/IuWKz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E685606A32A;
	Sun, 22 Nov 2026 01:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GC/IuWKz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABEF1F000C4;
	Sun, 22 Nov 2026 01:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795312619;
	bh=ThwrOz4KQaf/68vZr/EK5L1WefkBvf/yK3CtlQ1HEo4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=GC/IuWKzdP3XPrZY10V0RiplZlejXzbWqHWY2QaOy4znVfE3YN5fkGAgzUnxJiKVi
	 SPLiEY5c8KMToEo+eZ/6XZVlUDB4rdVdhYv3Bd3S7cwuW5JxRQ4qJm1JPiKn1EtnXq
	 BOBnnj3U6wWLp2zpdRigdS5yMcgJ3q0jI4h8LsJirUNb1rQi55p1rxggbTdCWzVv42
	 Uo4cPxRFR53JJuCkEghXMu0Iz2lXAlOWLxU3GdMdcDrY5PYQDRu8yP+kBww+bpkOUj
	 e7YbUHBNXVoPyB5Qxq4Ve/oGeOT/tplGDKuacxwSvtew1eVp1UBxIfzR0tUg9cMXMw
	 QofJXhNKIHfqQ==
Content-Type: multipart/mixed; boundary="===============5046235082527952735=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <99f64593ccffc93d735505cff682eecae40a6671b80ad7485c078ff8f335a214@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-25-jarkko@kernel.org>
References: <20261122011809.2667684-25-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 24/26] docs: Document userland uAPI
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 01:56:56 +0000 (UTC)

--===============5046235082527952735==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> docs: Document userland uAPI

TL;DR: Documentation only: the new userland uAPI doc never defines the
INIT/RUNNING/DEAD states or their transitions, so readers can't tell when
USERLAND_SHARE_NSFD is allowed. Commit message also misattributes ioctl docs
to nsfs.h.

>     docs: Document userland uAPI
>
>     Userspace orchestrators need a clear specification of what a userland
>     is, its build and live state transitions, USERLAND_GET_NSFD,
>     USERLAND_SHARE_NSFD, waitid(P_USERLAND), pidfd_send_signal(), mount-tree
>     construction, user namespace ID mapping, credential rules, and process
>     creation semantics.
>
>     Add Documentation/userspace-api/userland.rst to include the kernel-doc
>     sections, ioctl descriptions, and system call reference from
>     kernel/userland.c, kernel/user_namespace.c,
>     include/uapi/linux/userland.h, include/uapi/linux/nsfs.h, fs/fsopen.c,
>     and fs/namespace.c, and register the userland ioctl magic in
>     ioctl-number.rst.
>
>     Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

The message says the ioctl descriptions come from the listed files,
including include/uapi/linux/nsfs.h.  Is that accurate?

The only nsfs.h content included by userland.rst is:

  .. kernel-doc:: include/uapi/linux/nsfs.h
     :identifiers: userns_idmap_extent userns_flags userns_idmap

which documents the structures and enum used by userns_set_idmap().  The
ioctl descriptions (USERLAND_GET_NSFD, USERLAND_SHARE_NSFD) come from
include/uapi/linux/userland.h.

This isn't a bug, but the body paragraphs and the Signed-off-by tag are
also not separated by blank lines in the message as rendered.

> diff --git a/Documentation/userspace-api/userland.rst b/Documentation/userspace-api/userland.rst
> new file mode 100644
> index 000000000000..47d5c39ccb1c
> --- /dev/null
> +++ b/Documentation/userspace-api/userland.rst
> @@ -0,0 +1,73 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=============
> +userland uAPI
> +=============
> +
> +Overview
> +========
> +
> +A userland is an anonymous-inode control object opened by ``userland_open()`` (not
> +an ``nsfs`` namespace) that binds a detached namespace set, an initially empty
> +mount namespace, an owning user namespace, and an init process lifecycle across
> +build (``USERLAND_INIT``) and live (``USERLAND_RUNNING`` / ``USERLAND_DEAD``) phases.

Where are USERLAND_INIT, USERLAND_RUNNING and USERLAND_DEAD defined for
the reader?

These states are not in any uapi header and are only used inside
kernel/userland.c, and no section of this document defines them or the
transitions between them.  Yet the included sections rely on them:

  USERLAND_SHARE_NSFD works only while userland_fd is in USERLAND_INIT
  P_USERLAND waits until USERLAND_DEAD
  USERLAND_GET_NSFD for CLONE_NEWPID needs the init to be running

What moves a userland from USERLAND_INIT to USERLAND_RUNNING, and from
USERLAND_RUNNING to USERLAND_DEAD?  The commit message promises a
specification of the build and live state transitions and of credential
rules, but the document only has this one-paragraph overview plus the
included kernel-doc, so a userspace reader cannot tell when
USERLAND_SHARE_NSFD is still allowed.

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============5046235082527952735==--
