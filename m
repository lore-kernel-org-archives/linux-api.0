Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795313627;
	b=PHlFnoGgMW5JPvgTag7Rdg7hTPjrtLSScH5Lo0mFgo5E4XIwmf82uJ+zWJYT/0VCBmQV
	 Z4i9CNfg9ncwGKPAfpKPVHumRva9q1eQsntwZF11nAF26ptS0uMry/VRLa2MrDyX66oBY
	 h0IfT2nusY7uNgerpRvd1yO7uS34cFk0ZtgNR8DTsosieV7Pefn36HhNjzig9RTZQ65Cl
	 wy1Og5lb7YzFpuuimOvRhywX2E0nwJM1XKpv/M+arNBO9gtlpSMLimaJ48JEkBE+FSbIP
	 45isIyJL6WooZag+IlV6Wz/avQ7/Q3aKrz4xzBwKi9vdBQlohUTt2Vn1mTWUMp4tpDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795313627;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=fZRJwAY0kLkmZpFTl11wk8j7FY+RcHR74PBO3B2HID8=;
	b=U6ZojW06BivzkmdfSSHG/rWjPBNF5i+7S0F0sHK3MsXGh/MumShvBk0FnLAYOgpvogkE
	 m7xvKyn9TZQmMCFh4mtKOlFEeHEfLX3Ff/L+Wzeu2hoaV3MCR1MAQYq/jJ9a3Sq998DZB
	 D3X93rnM3kaN5adQpSwGEfYD5h+Ffnpmk1fqQZ1za0I4jA6+EWJ5xRinfzQF5j6Adwa3h
	 tYLhdk4MXdael7yygolubPPKHokFFxcZZrFuquRufkAFlqSOonorSSavS9IUp+LZzWhLw
	 Q9yZLqmy9aoEtSgVcWBb8/cYAgKKCWrdWHIEskAzAX/nJBM/2f8XrWhEI7+yQgdfdTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HuzYQ3+Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF576606A33B;
	Sun, 22 Nov 2026 02:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HuzYQ3+Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3081F000CA;
	Sun, 22 Nov 2026 02:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313627;
	bh=fZRJwAY0kLkmZpFTl11wk8j7FY+RcHR74PBO3B2HID8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=HuzYQ3+ZJ4kIQAFE0RRBLcAdMCPKIzlkXHrLV4idMRn0R4difRDbB9pQRXrJGFSut
	 drbvK8Hxjyw0a7PVuHsUeBe8N4ajEJ3dwCOOa0P7S1hinBUW56jo2uIcrmCQwuWDR6
	 I6XQiDO1LhCvaQF8w+GKOEYGmNoHAaQ+/nxIvG65kJiY9Isl1nJrjR2Tim1IdXxkWD
	 LEqcqG5WovbXGTZ1ryNg/VsTYR6GAgWmx1XdPJzxoo6bZsZYsS8/c3q8JbKwvX3S4T
	 oQNTD6qfb+ev+ZgDKyIAJDjVNHujT0e7Eyt3OqFOka9tlHd4GAFYSKWMbP5RrsD9lk
	 E0xsl2WH3feww==
Content-Type: multipart/mixed; boundary="===============6920277758331287056=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <1d998074e046fc55d51361a3f7d642ab1405b4ec87d9bcfe315f717fcf52e456@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-14-jarkko@kernel.org>
References: <20261122011809.2667684-14-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 13/26] userland: Add USERLAND_GET_NSFD ioctl
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:43 +0000 (UTC)

--===============6920277758331287056==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userland: Add USERLAND_GET_NSFD ioctl

TL;DR: userland->lock is taken with irqs enabled but, once
clone3(CLONE_INTO_USERLAND) lands later in the series, also under siglock; a
possible deadlock lockdep would report. Latent at this commit.

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c

[ ... ]

> +static long userland_get_nsfd(struct userland *userland, unsigned long nstype)
> +{

[ ... ]

> +	scoped_guard(spinlock, &userland->lock) {
> +		switch (nstype) {
> +		case CLONE_NEWNS:
> +			ns = from_mnt_ns(userland->ns->mnt_ns);
> +			break;

[ ... ]

Can this lock be taken with hardirqs enabled?  Later in the series,
commit 498ccb2ffbc4 ("fork: Support CLONE_INTO_USERLAND in clone3()")
passes args->userland to userland_copy(), and copy_process() calls it
while holding write_lock_irq(&tasklist_lock) and
spin_lock(&current->sighand->siglock):

copy_process()
  write_lock_irq(&tasklist_lock)
  spin_lock(&current->sighand->siglock)
  userland_copy()
    scoped_guard(spinlock, &c->lock)

siglock is hardirq-safe, since it_real_fn() reaches it through
kill_pid_info()->lock_task_sighand() from a hard hrtimer callback.  That
gives siglock -> userland->lock, with userland->lock taken here with
irqs enabled, which lockdep will report and which can deadlock:

CPU0
ioctl(USERLAND_GET_NSFD, CLONE_NEWNET)
  spin_lock(&userland->lock)        irqs still enabled

CPU1
clone3(CLONE_INTO_USERLAND)
  copy_process()
    write_lock_irq(&tasklist_lock)
    spin_lock(&parent->sighand->siglock)
    userland_copy()
      spins on userland->lock

CPU0
hardirq: parent's ITIMER_REAL fires
  it_real_fn()
    lock_task_sighand(parent)       spins on siglock held by CPU1

GET_NSFD has no state check for types other than CLONE_NEWPID, so it can
run while the userland is in USERLAND_INIT or USERLAND_FORKING, at the
same time as the bootstrapping clone.

At this commit userland_copy() is still passed NULL, so this is latent
until that later commit.  userland_release(), userland_exit() and the
later userland_share_nsfd() take the lock the same way, and the series up
to 942764a55437 still uses scoped_guard(spinlock, ...) at every site.
Should these sites use spinlock_irq, or should the userland_copy()
bookkeeping move out of the tasklist_lock/siglock section?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============6920277758331287056==--
