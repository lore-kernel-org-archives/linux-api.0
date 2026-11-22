Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795313617;
	b=kQ5pPdvV4bHcFAWyzGSm5inHpunvoslrInaDOT7K303dtRLbFITOqY2h2ObEEloqdfRG
	 KfKX4A2tYslvkfXOnpH85ApVpgSwRTxXxdHaqjVeryTbKq2NWsSLPMKX9TtrAjVSx4t3a
	 tj3SG0s9aFsFSSIebzyXaASPXabS43i812wzo+LU/9I353E10E1XKo6DmC9nWfuwi3gaP
	 hP5YKB19RVbckOKxNv4fDyrTQLzcVHHeSjm8H8sz5kKWk0HLziQqZWjG/JkJLxLpt1cWl
	 fVZqjtZvSHv4jdm2MByuaouYQuFy3ZlX7iSm9KWQe8QgEuEkliP74Fa1F6KCZFCjsEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795313617;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=cSdr2cBdqkloDgvS8BMjQJSoyDpO64vjXYle1ikr1YQ=;
	b=IHwmCxmjcoB7ClKabAhs8RDOaSuBq59FfKyTnCiiGlQZcYwEHgFm4JhF1TQVdAHJCn+i
	 0Eo1+T+NVKVUhwFvQO4N6jACJ8KazIacENb4FLK2HpK99gL0t8hj3077OlYydksoKn4vu
	 3d+du/gTFggnaBOkvzxgAwqHrVUZMMs2+lkC6fQ1tNvlrGQmXkFBrjK8hFKMK558Iodn7
	 wHb17r0W3WFg8G/yEPf+fUJygSZokjAG7VaoMLWGRGgPX3oYWktn/TZ91/CzfkLuvU6iW
	 v2xgnV0GntfxkugXjVhiQ2Jqw3iETXEIYgK9h9icrKqA89nSyrW3DtyGNlgWAex+gxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B5JOemNw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA33A606A32A;
	Sun, 22 Nov 2026 02:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B5JOemNw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3491F000C0;
	Sun, 22 Nov 2026 02:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313616;
	bh=cSdr2cBdqkloDgvS8BMjQJSoyDpO64vjXYle1ikr1YQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=B5JOemNwzbqZMdKmy8t8vqSrhW01QJnCyEIibiwaUziPQ5Sc5NQavrA2vLyp1LPBp
	 VNQDXSAAD/P1KrEfPW77SO/Pmw9NMoJ93RjyBmmeJMkKa0QJ8aly9oZA5ofCUdn60q
	 LFGpGstl6NI4Akc0S/XxRJINjkl2JCuUhtCX7LP21ZG/3OR7M+J4eSDQWtuBz/wCCw
	 TiqMouXeULkeIph5i3nEqXzCAy3gLKW9e5xLmXYztgXixlP4cGqEfJ2kTvU4M/y2rz
	 djctkzD3/xFfC+61kWTsvVp92OuRRNqHSw6aaSyhd0vkJ042MkVN4cia02bB4g2Isx
	 x3SHdE1JpAy6Q==
Content-Type: multipart/mixed; boundary="===============6118825193041384337=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <5cf1f729e21c52032316bd1351ca28d6bf30e54d9ece35b6f6055c94a61e6883@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-17-jarkko@kernel.org>
References: <20261122011809.2667684-17-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 16/26] signal: Support userland fds in pidfd_send_signal()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:33 +0000 (UTC)

--===============6118825193041384337==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> signal: Support userland fds in pidfd_send_signal()

TL;DR: userland_send_signal() may miss a child forked by a parent outside the
userland's PID namespace (e.g. after setns()), so a broadcast SIGSTOP/SIGTERM
could skip it; otherwise the commit message needs narrowing.

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c

[ ... ]

> +int userland_send_signal(struct file *file, int sig,
> +			 struct siginfo __user *info, unsigned int flags)
> +{

[ ... ]

> +	scoped_guard(rcu) {
> +		read_lock(&tasklist_lock);
> +		idr_for_each_entry(&pid_ns->idr, pid, nr) {
> +			struct task_struct *task = pid_task(pid, PIDTYPE_TGID);
> +			int err;
> +
> +			if (!task)
> +				continue;
> +
> +			err = group_send_sig_info(sig, SEND_SIG_NOINFO, task,
> +						  PIDTYPE_MAX);

The commit message says the signal is delivered "once to each thread group
including in-flight forks".  Does that hold when the forking parent is not
a member of the userland's PID namespace?

The delayed multiprocess signal handling only reaches a child if the parent
itself is in pid_ns->idr, so that group_send_sig_info(..., PIDTYPE_MAX)
hits the parent.  A parent outside the userland can still create a member
process, for example by calling setns() on the PID nsfd from
USERLAND_GET_NSFD(CLONE_NEWPID) and then fork().  A later patch in this
series, "fork: Support CLONE_INTO_USERLAND in clone3()", also lets
subsequent callers join the running PID namespace.

In that case:

  parent P (outside pid_ns)          userland_send_signal()
  copy_process()
    alloc_pid() -> idr_replace()
      child pid now in pid_ns->idr
                                     read_lock(&tasklist_lock)
                                     idr walk: pid_task(child, TGID) == NULL
                                       -> continue (skipped)
                                     P is not in pid_ns->idr, so it is
                                       never signalled
                                     read_unlock(&tasklist_lock); return 0
    write_lock_irq(&tasklist_lock)
    fatal_signal_pending(P) == false
    attach_pid(p, PIDTYPE_TGID)
  child runs without the signal

The comment in copy_process() already notes "If current is not in the same
namespace, we can't rely on fatal_signal_pending() below", and only the
zap_pid_ns_processes() case is covered through the PIDNS_ADDING check.

Can a SIGSTOP, SIGTERM or SIGHUP broadcast miss a process that is being
spawned or exec'd into the userland at the same moment?  Should the walk
cover these entrants, or should the commit message and the DOC comment be
narrowed to forks by member processes?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============6118825193041384337==--
