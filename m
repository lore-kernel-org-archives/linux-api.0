Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795379301;
	b=4+hQ95+e3Cz1dt9qPWXnIfKR8dbZB0DJGIVgzag/usMNipUAPJy2AratVFJc9RP++Wft
	 dDDywvc2zIh/Q3oSPnpk7lhLrlSrDSBBCK+53PBVoI0kDZzeTNPA6Ya3DBpDAfrVnhPVq
	 UJFMiSCZFr6qPGWfzXgR4MwsmZ3+ouMNgd0YSooMpswDWfWdc1tmlYiRSKNjplrGA6nGP
	 RtHkH6pHDb2c3D1GRxi6tzI2ionGFj1EaFAWUpHMs0wwuTDi+fOOZ18HM2Znn4JBWpCVm
	 VQmRI6RY7WrYHVRIzKt07FmpKH9ikYNffyvVOoOmnVz/Qr7mQOBfHqGQSNJX/VyDdEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795379301;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=7hegAlsfKZhGkTRmWASsRIi51iE3yTycidmKuYA20sM=;
	b=iu0GIdlGcFWMvRE+qbR6Dwd59eQH42QgamD7GfQUBENSeo3vQqRpEFwnwhsWnhiyiuOO
	 yBOgwIkJ7TN6D8e6TOQqYg95U6gG7Dc3RYQI3lzr5T3dhUDwX0+aGYKA4gKhy8R8v/NTO
	 DEdAa+wTJzXWtB3EfBKhJkpcWarjIHOUPJKWsPE26HgtzzMUeksy2XH456EVQE2WArQJZ
	 tkz9Uh7uGcq6KuXw88vWG7ZRdFE4JRvfu6dxT0FBGvkOYdswmaMfma8SvF8pguthKwZyY
	 wsFOgG0s5XdpXLEe87xywmemPokWwPXJypl3GQXFY+2rUeMxrwXhQc5AV40vaLumv7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEIbKzUz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5056B606A31D;
	Sun, 22 Nov 2026 20:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEIbKzUz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F59C1F00A3E;
	Sun, 22 Nov 2026 20:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795379300;
	bh=7hegAlsfKZhGkTRmWASsRIi51iE3yTycidmKuYA20sM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=XEIbKzUzCQiRB2aZCrqF5hQW2qtt10VuVYBK2N4JJ/ApWzC1L0LdBsmpNL5+eZmL1
	 OdiaZbs0zfoeU6QqofekKjKxfcM/YQQMSHUZal367Ej+w9pNIMB+1hs9gM5ZvIltFL
	 oC6OyVwx+RN+4O/6LDboojpptdkoctQ+IBmLy6OF/gNO6dd6QFSo+j0u8hBjYhbcVr
	 wICJBLBiXqLV9j4oyPONK7UprRaIjuNvC4ElGXMxMIRfhz5h7PcT6C9AdNDeJ4i3jc
	 U51fRTVhFgIhiS+n0m4gXUvYnlx5v/g3p8+luyiPmfWi/0qx9dhG+jVcym6U3Y2C+U
	 bl906gaOALZEw==
Content-Type: multipart/mixed; boundary="===============7729801098175105974=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <1b6e8842feb8995df8e17c6145e3d543e00124f866912e10a952a9609af79112@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-18-jarkko@kernel.org>
References: <20261122193539.3334213-18-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 17/26] fork: Support CLONE_INTO_USERLAND in clone3()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:28:17 +0000 (UTC)

--===============7729801098175105974==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> fork: Support CLONE_INTO_USERLAND in clone3()

TL;DR: In copy_creds() for CLONE_INTO_USERLAND, the dumpable-reset condition
looks redundant with a user namespace change, so the cred_cap_issubset() term
and init_task_exec_state check may be removable. Not a bug.

> diff --git a/kernel/cred.c b/kernel/cred.c
> --- a/kernel/cred.c
> +++ b/kernel/cred.c

[ ... ]

> @@ -251,6 +254,9 @@ struct cred *prepare_exec_creds(void)
>  	return new;
>  }
>  
> +static bool cred_cap_issubset(const struct cred *set,
> +			      const struct cred *subset);
> +

[ ... ]

> @@ -287,6 +294,24 @@ int copy_creds(struct task_struct *p, u64 clone_flags)
>  	if (!new)
>  		return -ENOMEM;
>  
> +	if (userland) {
> +		const struct cred *old = current_cred();
> +
> +		if (new->user_ns != userland->user_ns) {
> +			ret = install_user_ns_cred(new, userland->user_ns);
> +			if (ret < 0)
> +				goto error_put;
> +		}
> +		if (!cred_cap_issubset(old, new) ||
> +		    old->user_ns != new->user_ns) {
> +			struct task_exec_state *exec_state;
> +
> +			exec_state = rcu_dereference_protected(p->exec_state, true);
> +			if (exec_state != &init_task_exec_state)
> +				WRITE_ONCE(exec_state->dumpable, suid_dumpable);
> +		}
> +	}
> +

this isn't a bug, but does the !cred_cap_issubset(old, new) term ever
change the result here?

new is a prepare_creds() copy of current->cred, so there are two cases:

  - same user namespace: install_user_ns_cred() is skipped, the
    capability sets are unchanged, cred_cap_issubset() returns true, and
    old->user_ns != new->user_ns is false, so no reset happens.

  - different user namespace: install_user_ns_cred() switched
    new->user_ns, so old->user_ns != new->user_ns is true regardless of
    cred_cap_issubset().

The condition looks equivalent to old->user_ns != new->user_ns, which is
the same as "install_user_ns_cred() ran".  It reads as if it follows the
commit_creds() rule that skips the reset when old->euid owns the target
namespace, but the reset always happens on a namespace change, which
matches the "dumpability reset to suid_dumpable" text in the kernel/userland.c
documentation comment.

Also, is the exec_state != &init_task_exec_state test ever false on this
path?  For CLONE_INTO_USERLAND, copy_exec_state() runs before copy_creds()
and always takes the task_exec_state_copy() branch, which allocates a fresh
exec_state.

Could the dumpable reset move into the
if (new->user_ns != userland->user_ns) block, which would let the
cred_cap_issubset() forward declaration and the init_task_exec_state test
go away?  If commit_creds()-like semantics were intended instead, then the
old->user_ns != new->user_ns operand and the documentation comment would
need to change.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============7729801098175105974==--
