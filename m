Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795313611;
	b=iVE0r/CaAkUnURgLGrCjo0HrOw/l/nK3m8zzsqMpjRDY+tK8IalF0MXjmqijdXZ+7q9k
	 kbhq7l5lnI6kxrGDFC0Z29E7rl6pn2yXBeJ4Omhj3hMeQy3PqD/oHAK8WpjvNQ/Qmo+Ta
	 XkKlrEtbK8JdlT1WCvXMlMztwovU1oAMzDhtDm1KMvJxQRy42QpocAcYsPbzXjLhvaY0q
	 Ttj27vb/dRfTGK/PhF8NpJRyygX3Dpz9AXCkkncvT3DL3uCcHDvUn8pJhUbqrVofrVvi9
	 a6Lz7sd2FAw6yc+v9vREEqSO4w8BkG1mGL/3LOtcNRHbanT1RXTvWvwAO+Bh49JIbuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795313611;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=6onxn2SinNI7aDwblXFHgIt801pm4vHKztESGvGpEJI=;
	b=gsmv7MkDw/h2d8znvAbQzLvdGyB1RjH7iwiLJaKzNhuVSCGjIH9df47SC9EymKNWpfbw
	 4dNNEQa5XkdVyXTuiaY3HH0S+rcbOqMOFxls47K5b6fqdqoJJXjJqU4JObYTSlgeoKmo7
	 VQm5GiEU5mkTeNVrEP/wyFnsM74w+r3O6LlwlKt33sE8TYfMOEcbG+GnZ2ry1syfJYXsd
	 rmx5iI1noOJPwQxMNcJ3QRDX7K4j1qGJE6G5AJtoKMOA5kKb5O2sDDgos17gSFijd2D5p
	 wmi/5c/2NP65oiB0CFAkgP/S6ttcE38Tn1OKdmaMv+KYmb0HsXgTkmidJzoNMYVRmLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="V/Zo18nh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA32606A336;
	Sun, 22 Nov 2026 02:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V/Zo18nh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68491F000C6;
	Sun, 22 Nov 2026 02:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313611;
	bh=6onxn2SinNI7aDwblXFHgIt801pm4vHKztESGvGpEJI=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=V/Zo18nhbvS+GdkUZnSRduvKQP7SwU1hnOnfyDwKPrDeF9kw0HnG6Fmytp4RuPcc4
	 HfjdoGTbczc9OOYW1q0xE+1zzoPmoit/tUtcvaC/jc8PZtJ3DParoZ8dzgaFLOkCOt
	 96THICVwPgRWc/b8UGWlzqRA+D6MBHzOzWkVM2AYcUoe7cQYP1p5TcsL7AqVTox6cl
	 m8NDk35Dy5mxDQz6qWa6daqB6ki8PtmASiGB+KWQJt3q2xnl+WNbTlvE3F4HZkvPcQ
	 AvwHVxHJFcsyUwb/RkJgxHxkSeidwB7YiGU9KENXXAas4XWXe2rNgkjx0W15n/Urz1
	 xi3VlQHaKI2TQ==
Content-Type: multipart/mixed; boundary="===============4694831360438668141=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <5bdbcf00cb4e4471bbae9999b2dd8ee652650653ac4182840c5c0d416229d7ef@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-12-jarkko@kernel.org>
References: <20261122011809.2667684-12-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 11/26] userland: Track init lifecycle via copy_process() and pid_namespace
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:27 +0000 (UTC)

--===============4694831360438668141==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userland: Track init lifecycle via copy_process() and pid_namespace

TL;DR: userland_copy() may take c->lock inside siglock and tasklist_lock,
while c->lock is taken with IRQs enabled elsewhere; this could trigger a
lockdep report and a possible deadlock once CLONE_INTO_USERLAND goes live.

> diff --git a/kernel/fork.c b/kernel/fork.c
> --- a/kernel/fork.c
> +++ b/kernel/fork.c

[ ... ]

> @@ -2573,12 +2574,14 @@ __latent_entropy struct task_struct *copy_process(
>  		attach_pid(p, PIDTYPE_PID);
> +		if (thread_group_leader(p))
> +			userland_copy(p, pid, NULL);
>  		nr_threads++;
>  	}
>  	total_forks++;
>  	hlist_del_init(&delayed.node);
>  	spin_unlock(&current->sighand->siglock);

[ ... ]

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c
> @@ -82,6 +82,49 @@ static const struct file_operations userland_fops = {

[ ... ]

> +void userland_copy(struct task_struct *tsk, struct pid *pid, struct userland *c)
> +{
> +	if (likely(!c || !is_child_reaper(pid)))
> +		return;
> +
> +	scoped_guard(spinlock, &c->lock) {
> +		if (c->state != USERLAND_FORKING)
> +			return;
> +		refcount_inc(&c->usage);

Can this nest c->lock inside siglock and tasklist_lock in an unsafe way?

userland_copy() is called from copy_process() while tasklist_lock is held
for write with interrupts disabled, and while current->sighand->siglock is
held:

    attach_pid(p, PIDTYPE_PID);
    if (thread_group_leader(p))
        userland_copy(p, pid, NULL);
    nr_threads++;
    ...
    spin_unlock(&current->sighand->siglock);
    write_unlock_irq(&tasklist_lock);

siglock is taken from hard interrupt context.  For example, the ITIMER_REAL
timer uses a non-soft hrtimer, and it_real_fn() -> kill_pid_info() ->
do_send_sig_info() -> lock_task_sighand() takes siglock in hardirq.  So
holding siglock while acquiring c->lock records a siglock -> c->lock
dependency.

Every other acquisition of c->lock in the series uses plain
scoped_guard(spinlock, ...) with interrupts enabled: userland_release(),
userland_exit(), and, from later commits, userland_prepare_fork(),
userland_finish_fork(), userland_waitid(), userland_get_nsfd() and
userland_share_nsfd().  That makes c->lock hardirq-unsafe while it is
nested under a hardirq-safe lock, and lockdep should report "HARDIRQ-safe ->
HARDIRQ-unsafe lock order detected" the first time a userland is
bootstrapped on a CONFIG_PROVE_LOCKING kernel.

It also looks like a real deadlock:

CPU0: a second clone3(CLONE_INTO_USERLAND) caller in
userland_prepare_fork() (or waitid(P_USERLAND), or USERLAND_SHARE_NSFD on
the same userland) holds c->lock with IRQs enabled.

CPU1: the bootstrapping parent is in copy_process() holding tasklist_lock
(write) and its siglock, and spins in userland_copy() on c->lock.

CPU0: takes the parent's ITIMER_REAL (or a posix-timer) hrtimer interrupt,
and it_real_fn() spins on the parent's siglock, which CPU1 holds.

Neither CPU can make progress.  This looks reachable without privilege,
since userland_open() creates its own user namespace and the caller holds
CAP_SYS_ADMIN/CAP_SYS_CHROOT there.

In this commit the call passes NULL, so userland_copy() returns early.  The
path becomes live with 498ccb2ffbc4 ("fork: Support CLONE_INTO_USERLAND in
clone3()"), which changes the call to userland_copy(p, pid, args->userland).
I don't see a later commit in the series that addresses this; at 942764a55437
every c->lock user still uses scoped_guard(spinlock, ...).

Should c->lock be taken IRQ-safe everywhere (spinlock_irq/spinlock_irqsave),
or should the FORKING->RUNNING commit happen outside the tasklist_lock and
siglock section?

> +		ns_of_pid(pid)->userland = c;
> +		WRITE_ONCE(c->init_pid, get_pid(pid));
> +		WRITE_ONCE(c->state, USERLAND_RUNNING);
> +	}
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============4694831360438668141==--
