Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795313649;
	b=OOgZw1sLd1ptOx+v7EqC3NbbaxBOT3HglahJxhv2IvMDrbOUMk5YXdA36Mk8gSd307rp
	 gb2u7fpOpCdpp97gkoOXhkX3K25GZnp+qDG2jvh0bbHmePxoFJvwPNC/nW8Lt1K+9ZC37
	 d8F9d5Qof0Rb/uNYS6J+3XBJA97Mg+T6GbcXKwN8SyyYcUzrQWhCyOkFSKOsar4w9rCJr
	 ZjODGWeCUfm8PAiyj0E+wAjS2S3qLImxDYvkxMDxRFTr9k0h4m5quWhwQIs0mDqXIp7iO
	 wGb/TRMwSfNuTwrDuVLMwb08F3tCgcW2f7RkZtXZdteFv5Cls7D8oWh57U8tyii4+eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795313649;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=cGkV5IvqRbWZza57W8pwFxFV6A6gni/+uOQ6Mx1vB6E=;
	b=5TzP7ABbgdIH8FimK76IrQMcH48aDY9G9gCcyukbd82pUPTycHJtDi/hgWSQpUYv7bNi
	 d0EvgjzB9MbkAcUHLqxGF8ywg+z6GD8QwRrQABDAgd7P7JTaR7rPDANy2Gfeh7mZ58zH0
	 YQ6XpLREytWlcinKStqj9qyimexVJzpOAtdpJ+KBCn7Vp2OV4kzZLg7k+jxsnKYW7Y4kY
	 tQVQlmUVN7BK1csqNWYmaMwYEMPLwN0C5zlf9/Uag1h1GPQkk+j1i+PYWv/iSfTysuEHL
	 BOLuIN+M8ETOJhEndqN2FJ1xa5NthawxNm0fUc67sQFOr+WbpxrzSC3/gDiQy4ff7DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UrMQqI1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453C1606A32A;
	Sun, 22 Nov 2026 02:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UrMQqI1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8B71F000D2;
	Sun, 22 Nov 2026 02:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313649;
	bh=cGkV5IvqRbWZza57W8pwFxFV6A6gni/+uOQ6Mx1vB6E=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=UrMQqI1gERAVF9Rw130xSdAu4KNhRVPEMIF+LQbIq4vclZ9OFR+nOGIsxEzhB/+DS
	 rXJVxEZeJiech9JiNW49jUQU6Yhs2nlpwVTh51wTClecfSla7sgQI1ranCFuA47V+b
	 exCEw/MQnkRWmA2fKib+RZzjoQywc4nS1EGqgRrbylS3iSb8sLNTZrg05oa4WgfDvu
	 0OMhk58lbfal1qf0wbvOsGkSiCqtOK5+vkLG/Zex5UDM7F2pXqH2wJEqPmT4kJRHY3
	 mQqGBuZk4oQw9rx6sDCK+ytGMhKBJha6aA80ZKdA0/BbfeloRq0tPcw8pdlYsgZ+nb
	 hhZ0D4CzEc6Vw==
Content-Type: multipart/mixed; boundary="===============3571640751418729453=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <9dea540cf8e18ede2f8471a0a677bfd6dba4a416739a03a462e6797da6a0c51f@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-18-jarkko@kernel.org>
References: <20261122011809.2667684-18-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 17/26] fork: Support CLONE_INTO_USERLAND in clone3()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:14:05 +0000 (UTC)

--===============3571640751418729453==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> fork: Support CLONE_INTO_USERLAND in clone3()

TL;DR: In clone3(CLONE_INTO_USERLAND), userland_copy() takes c->lock under
tasklist_lock and siglock, but c->lock is taken elsewhere with interrupts
enabled. This may deadlock system-wide, and lockdep may report it.

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 2fceacc17e8a..3dd2c098bf32 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c

[ ... ]

> @@ -2578,7 +2599,7 @@ __latent_entropy struct task_struct *copy_process(
>  		}
>  		attach_pid(p, PIDTYPE_PID);
>  		if (thread_group_leader(p))
> -			userland_copy(p, pid, NULL);
> +			userland_copy(p, pid, args->userland);
>  		nr_threads++;
>  	}
>  	total_forks++;

Before this patch userland_copy() was always called with a NULL userland and
returned immediately.  Now the bootstrapping CLONE_INTO_USERLAND child
reaches this in copy_process() while holding write_lock_irq(&tasklist_lock)
and spin_lock(&current->sighand->siglock):

    void userland_copy(struct task_struct *tsk, struct pid *pid,
                       struct userland *c)
    {
        if (likely(!c || !is_child_reaper(pid)))
            return;
        scoped_guard(spinlock, &c->lock) {
            ...

sighand->siglock is taken from hard interrupt context, for example
it_real_fn() -> kill_pid_info() -> lock_task_sighand(), and
posix_timer_fn() -> posix_timer_queue_signal().

Every other user of c->lock takes it with a plain spin_lock() and interrupts
enabled: userland_prepare_fork(), userland_finish_fork(), userland_waitid(),
userland_get_nsfd(), userland_share_nsfd(), userland_release() and
userland_exit().

Can this produce a HARDIRQ-safe -> HARDIRQ-unsafe lock order report from
lockdep on the first bootstrap clone3(CLONE_INTO_USERLAND)?

It also looks like a real deadlock is possible:

CPU0
  thread T2 of process P, in userland_prepare_fork() or waitid(P_USERLAND),
  holds c->lock with interrupts enabled
  hrtimer interrupt for P's ITIMER_REAL runs it_real_fn()
    spins on P->sighand->siglock

CPU1
  thread T1 of process P, in copy_process(), holds tasklist_lock for write
  and P->sighand->siglock
    userland_copy() spins on c->lock

Neither CPU can make progress, and since tasklist_lock is write-held, fork,
exit and wait stall system-wide.

Should c->lock be taken with spin_lock_irq()/irqsave at every site, or should
the FORKING -> RUNNING transition move out of the tasklist_lock/siglock
section, for example into userland_finish_fork()?  I did not find a later
patch in the series (up to 942764a55437) that changes this.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============3571640751418729453==--
