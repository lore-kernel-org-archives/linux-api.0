Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795313606;
	b=JxFejBjJL67/XPYDnw5fyfdkWb8wlyTcaMH1Pf/cyhoyXlcK6OhvC0/arQGGgff2It2b
	 zhywcXwhqIjQA6nNsP0JifwR/mINoYwvbr2cIEPuaBmI4OGpGhd99y81w6Hjgzrow5rcq
	 4HZl+BohKdA3bQVx1tWrntAF1sqnQULSXWRYbMLb3eZfyhYeiI6EBuIXPVzIBpT+gBeyP
	 IWhTyZT7upCSSbxIqbppCSx3GD+Pie3s3sFhkUUD5/GgL7fuPEd7C589q7pgzCi4kZ5Ls
	 AI/fU8Gmcsa0UM34IK+J736RuSDEyMSgORMU9u3g0jtFjQjwcgHuCF4R7U8idHNcohg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795313606;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=JjRuBovetgGLfxfZ7NqPAG69TmUpxN1W3znDQ9aIDdg=;
	b=jsaL4r0OZPrj24GPYFByd+P1Mq6qZjJY53Sx2aTubBGizvqKRACKu2soEjPrMH6MhmY4
	 LbyWIkpxMWimbO0oBqhD/HW1/Dko0+UyjBiMsmkNtgVfvefI8MVJdiC6XlhD0P4QgyLer
	 C6r1lhiT2VXKy9ZhyY4qK/DrmsoWAy4rv2mIB5qh6YFrlF2o4as68cbpaKKGlH+5lZnJk
	 pMM1b1nVdJHc7YhVRIQSDxiu11uxz0i3PrUCCupM/O01SOab2Khk9nocrnAMm1jpvkjyI
	 MiwePAjpO9z6cG/XwYzhku4LllYbxW0XEMLl/8KJJzLLMu1kM8Miwu/FK4BX/rHdS6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MbYntUSj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA2E606A320;
	Sun, 22 Nov 2026 02:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MbYntUSj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DFF1F000C0;
	Sun, 22 Nov 2026 02:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313605;
	bh=JjRuBovetgGLfxfZ7NqPAG69TmUpxN1W3znDQ9aIDdg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=MbYntUSj43KK0XEUMVZMfKsY3aiOU7ksnkok0GlzXj9Vtt28SDssP3J5GsRfJHmI1
	 z6L5M088BaqXgPlcib1rK5rvsISYYuNPrudiwOa6+nxGcI0MqHaoD78Vdv7y/asAMw
	 iztA46mkWl8XPSBv8yaWoBl4ctG+ccfTMbwJgNy/FfhthBLLLo+rNDZtLpK12DojGO
	 03f9hyahjSI/9ZhRu0COiJEvVYkoRgaNYZTQ874FPAe0pSig/gs6fogYJ8Rl/zGDwJ
	 74h5NE+BS8i74tataIgBme9IWkSlKlH3GIKcBDHYgzwoULDGV2yA7lpC0YXbA5SNlZ
	 qTGbHxhSroa2A==
Content-Type: multipart/mixed; boundary="===============0061437725914904412=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <1a12b0b293d0622a6a3f897306f3cf2256be88befcfdc0bf272ceeb1de6bcac6@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-16-jarkko@kernel.org>
References: <20261122011809.2667684-16-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 15/26] exit: Support P_USERLAND in waitid()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:22 +0000 (UTC)

--===============0061437725914904412==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> exit: Support P_USERLAND in waitid()

TL;DR: A blocking waitid(P_USERLAND) may return an unexpected -EAGAIN if a
failed clone3() bootstrap is retried while it sleeps; it should probably
return -ECHILD or keep waiting.

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c

[ ... ]

> +/**
> + * DOC: P_USERLAND
> + *
> + * ``waitid(P_USERLAND, userland_fd, &infop, options, NULL)`` waits freezably until
> + * ``userland_fd`` reaches ``USERLAND_DEAD`` (unless ``WNOHANG`` or ``O_NONBLOCK`` is
> + * set) and writes init's exit information into ``infop`` without consuming it.

[ ... ]

> +	if (!nonblock) {
> +		ret = wait_event_freezable(userland->waitq,
> +					   READ_ONCE(userland->state) ==
> +					   USERLAND_DEAD ||
> +					   READ_ONCE(userland->state) ==
> +					   USERLAND_INIT);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	scoped_guard(spinlock, &userland->lock) {
> +		if (userland->state == USERLAND_INIT)
> +			return -ECHILD;
> +		if (userland->state != USERLAND_DEAD)
> +			return (options & WNOHANG) ? 0 : -EAGAIN;

Can a blocking waitid(P_USERLAND) return -EAGAIN here, even though the DOC
comment says it waits until USERLAND_DEAD unless WNOHANG or O_NONBLOCK is
set?

The wait above ends on DEAD or INIT, but userland->lock is only taken after
the wait returns, so the state can change in between.  INIT is not terminal
once 498ccb2ffbc4 ("fork: Support CLONE_INTO_USERLAND in clone3()") is
applied: userland_finish_fork() sets FORKING back to INIT under
userland->lock when copy_process() fails, and then calls
wake_up_all(&userland->waitq).

Sequence:

  Task A: waitid(P_USERLAND, fd, &si, WEXITED, NULL), blocking fd
          passes the early INIT check and sleeps in wait_event_freezable()

  Task B: clone3(CLONE_INTO_USERLAND), state is FORKING
          copy_process() fails (e.g. -EAGAIN from RLIMIT_NPROC)
          userland_finish_fork() sets INIT and wakes A

  Task B or C: retries clone3(CLONE_INTO_USERLAND)
          userland_prepare_fork() sees INIT and sets FORKING again

  Task A: takes userland->lock, state is FORKING or RUNNING,
          neither INIT nor DEAD, WNOHANG is clear, returns -EAGAIN

With neither WNOHANG nor O_NONBLOCK set, waitid() does not return -EAGAIN
for P_PID or P_PIDFD, so a manager doing a blocking wait gets an error it has
no reason to expect, possibly while the new init is running.

In the !nonblock case a non-DEAD state under the lock means a bootstrap
failed, so should this return -ECHILD like the early INIT check, or go back
to waiting?  -EAGAIN and 0 would then only apply to the nonblock case.

userland_waitid() is unchanged through the end of the series, so no later
commit fixes this.  The path is only reachable once 498ccb2ffbc4 adds the
FORKING state; in this commit the state never leaves INIT.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============0061437725914904412==--
