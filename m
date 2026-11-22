Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795313644;
	b=cSkP49XdB2DgTiXp3Tn2faHhl4t2ZHqxfI+JzUn/FE2TVw9hAzRqib7szXrFtjWhbafW
	 TE/EixaN4VqKAuS4IyfvnDeOjlcUC0PZ50Q+XM9OYpeFHcgYBaHMlsj9wFpWLDjixnSVL
	 NjXuSsAttQfkQAPHVosyZTveIQIsczVPDJwtpnfaTdLaifbvER3a6dJ/GL3GTqTqhwEN6
	 UHdXJNQB5sJQOXuqqdzvY5iQeMnv2kH55yccTpBrGKYtTv6yGQhlNp6L7NYkCHqBKYZeQ
	 SFTNJtly+e7F1PctLV/zlG3ZxXBdlCRoiuUCvXI/pOel+G7RPCGdvqkZqNQ/McL1gOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795313644;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=YDB1yuO+g70nypwHDdydP9Ie+9yV7h/g1apo66kxJw8=;
	b=Nz9rvcUCdY3ZShCC1NRsvl+C0Q+QhCcgwUULaSkP2/q+KipXF0IToBs1L76XXW45/b4J
	 DC8exbXqXOLeTXntEqJddIMcT3kvwWVeWi/eQV+EwyL19X0QZqdFU7nUG16SYXRQVvpJf
	 9+sYOWtj4gRMB7jZ98EoaCo58cvPGZyvzMt035RznH/ZOAFvQHT8ytJOXf3qoX3rK+nm3
	 3e/kGv2X5tJuiewqxgV7MObi4RZucpYvpUa/JxnrTBslhRNO3vtXpCHQlZfZhSU+TYAeO
	 dcUH3XfwOaVsosjOuaZ+4CPC8pCt+OcKkjdyy0S+5FNQ6GenDZhROcqJL0FLvOU+aag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kjKtmid+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3708E606A331;
	Sun, 22 Nov 2026 02:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kjKtmid+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FAC1F000C6;
	Sun, 22 Nov 2026 02:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313643;
	bh=YDB1yuO+g70nypwHDdydP9Ie+9yV7h/g1apo66kxJw8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=kjKtmid+tgBBfQEZ5DMw+UnpV1e7mQ8R6y3MnkUVkjR/LrEQY+y0NkkYdYSM6D4k9
	 uFKZk7MWvBM16LOMVi72HP3JZCuZTAUV4KhIaDeVYv6BbL1q1WmlSEm/iMO7wKzDDd
	 rWdepeysG4QnnTjfkfF6yVoS7GOhL6+m2aWP12KNP3fpmk+FQekI/VY2eJDsp521ZN
	 RzVka1oDb+iFY/TgEnrBU9aFG8Pqdpkg7WpCSosqMYsQJ7QBH3sKdZ4Vd3ZgX+muds
	 fSrG3BbLpjmgMR8vBtAM+67/W7IkN33Ia23qrDyM9LwYue7dDnoFoGYPZFf9rypGHl
	 m1+IuLrc4WC5Q==
Content-Type: multipart/mixed; boundary="===============7190256002040251777=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <e49d1c291f255be48f078b39982b5f2f1b28ad1f0398715c157cff4846a4aa49@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-19-jarkko@kernel.org>
References: <20261122011809.2667684-19-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 18/26] fs: Support FSCONFIG_SET_USERLAND in fsconfig()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:59 +0000 (UTC)

--===============7190256002040251777==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> fs: Support FSCONFIG_SET_USERLAND in fsconfig()

TL;DR:
- fsmount() may call may_mount() needlessly for userland-bound contexts,
  possibly causing spurious LSM denial logs and BPF-LSM hooks
- mount_api.rst may need updating for ->set_userland()

> diff --git a/fs/namespace.c b/fs/namespace.c
> --- a/fs/namespace.c
> +++ b/fs/namespace.c

[ ... ]

> @@ -4705,16 +4705,19 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
>  	struct vfsmount *new_mnt;
>  	struct mount *mnt;
>  	unsigned int mnt_flags = 0;
> +	bool priv;
>  	long ret;
>  
>  	if ((flags & ~(FSMOUNT_CLOEXEC | FSMOUNT_NAMESPACE)) != 0)
>  		return -EINVAL;
>  
> +	priv = may_mount();
>  	if ((flags & FSMOUNT_NAMESPACE) &&
>  	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
>  		return -EPERM;

Previously may_mount() was only called when FSMOUNT_NAMESPACE was clear.
Now it runs on every fsmount() call, but priv is only read later in:

    } else if (!(flags & FSMOUNT_NAMESPACE) && !priv) {

so the result is discarded for FSMOUNT_NAMESPACE callers and for every
userland-bound context.

may_mount() is an audited ns_capable() that goes through security_capable()
and sets PF_SUPERPRIV on success.  Can an external manager under an LSM
policy that denies capability sys_admin but allows the user namespace check
now trigger an LSM denial log entry and BPF-LSM capable programs on each
userland-bound fsmount(), for a privilege the call does not need?

The other conditional callers in this file only evaluate it when the result
matters:

    if ((flags & OPEN_TREE_CLONE) && !may_mount())
    if (!(flags & MOVE_MOUNT_T_MNTNS) && !may_mount())

Could may_mount() be called only on the unbound, non-FSMOUNT_NAMESPACE path
once fc->userland_bound is known?

[ ... ]

> diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
> --- a/include/linux/fs_context.h
> +++ b/include/linux/fs_context.h

[ ... ]

>  struct fs_context_operations {
> @@ -117,6 +122,7 @@ struct fs_context_operations {
>  	int (*dup)(struct fs_context *fc, struct fs_context *src_fc);
>  	int (*parse_param)(struct fs_context *fc, struct fs_parameter *param);
>  	int (*parse_monolithic)(struct fs_context *fc, void *data);
> +	int (*set_userland)(struct fs_context *fc, struct userland *userland);
>  	int (*get_tree)(struct fs_context *fc);
>  	int (*reconfigure)(struct fs_context *fc);
>  };

Documentation/filesystems/mount_api.rst keeps its own copy of struct
fs_context_operations and documents each method.  Should it be updated for
->set_userland(), the new userland_bound and userland_mnt_id fields and the
new fs_context_phase states?

Filesystem implementers currently have to read fsconfig_set_userland() in
fs/fsopen.c to learn the contract:

- it is called after ->init_fs_context() has run with fc->user_ns,
  fc->net_ns and fc->cred already rebound;
- it may rebind fc->user_ns, but must leave it equal to the userland's user
  namespace, or the bind fails with -EOPNOTSUPP;
- the context moves to FS_CONTEXT_FAILED on error.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============7190256002040251777==--
