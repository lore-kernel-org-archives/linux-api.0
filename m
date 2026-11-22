Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795312625;
	b=cBEWQtsQ0ZVPs999b01dC/ZdbvR5I2RGWzZlyHkkYssoAndaDldu84bOgfZ8MZ0STGJH
	 yiKZeUcsxqVhlRkKqmZVslOM5nJLWLOP7tXntg4Dl+sa5lp6qRurue0cJ1fvLPR/SCKJ8
	 9XRQLTqQxl79j34ioNf5Mg+kPl7x8iMTiwMit/r7S8kKV14HtvUHLCg4LbrHBgEWCGcU9
	 h3A94aEKTApcOmP9QPbXnoo1a3gRbVZPO53VGW7RV/g+Dk+kCeFhe5BDrkni4pUb7q7WG
	 t5wqRfM24JQlUfwx+uwDbrXWkDWy9qogP5yDlWDjDdEcebyKRaEX0M7oBp0ssnw9wBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795312625;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=6/FyTmAO6EftrsMjGyxjzlp9mWuafpHrb9mW48T2Oss=;
	b=uXzV7Xg9sf+LCzpB2c8xVOyEmO/vt7gRwjQTkmvNZaqYS+plJT6Fm3BZ5cjUrDZpI7sF
	 +LHJmf8MqUc99VY7jyT79h59gj+pK9eJz6CjsK+bmCDebuAvxM2uUPPTwdJIHDUUEAFWy
	 bqsWEz8Fg9ig565mK6s0CqV0JMm+gkyinuhx3a6JlburiIWu/b7TwXprq5yJnuo++h/8u
	 MQxzQEoBToEtACbjWSej2YekIYeaTOpeu8Pwdq++CKptnxlbjhGoJdVKZQSqkz6j/LObd
	 b457LpqPaprXw+0CNiH2ikeb8IGL1BMTQgFt0sHOteiuvyn06pLaB7F0xtQ4tPehJBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LAiB2BDW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC908606A330;
	Sun, 22 Nov 2026 01:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LAiB2BDW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20C01F000C6;
	Sun, 22 Nov 2026 01:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795312625;
	bh=6/FyTmAO6EftrsMjGyxjzlp9mWuafpHrb9mW48T2Oss=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=LAiB2BDWU3KDfnCXLYfa7ih/CTFK11tTVZY3+hcQ/8vJmjiSoq/EV3Fgt7hrC/RwN
	 +EqFbeoqKBYoGn9x471Yg5WTU7aY5g9GaaSEAB3NB2KflPUI5KhBRuyCsEhd5qNQLP
	 FoUZPTG9ZHGlbSGQoFSZSRGIgo9FUgvcF+qWFzrw5lnwZs86zK0kAG6+8hOTAaEf06
	 sAS9sL/Qw2Nmb4LR5oTfDBR5Sf9b+shshushM71J23frttECA+gOdPvLONAVYmyXhO
	 satqdnxwF+LliRSVYYpzkQ8NJpepILIsfD5r6Nliu9SfNY85l+4YcgAEAEOSkN367Y
	 VPkKumdQpdPrQ==
Content-Type: multipart/mixed; boundary="===============6512166407887190360=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <3aca9b48a99eea17865184e5107f26499594cb8e7cb05923abc9cad098e24c5b@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-2-jarkko@kernel.org>
References: <20261122011809.2667684-2-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 01/26] userns: Factor out idmap validation and commit helpers
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 01:57:01 +0000 (UTC)

--===============6512166407887190360==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userns: Factor out idmap validation and commit helpers

TL;DR: Nit only: the smp_rmb() pairing comment in commit_new_idmap() names
map_id_up(), which has no barrier; it should name map_id_range_up(),
map_id_range_down() and m_start().

> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c

[ ... ]

> +static void commit_new_idmap(struct uid_gid_map *map,
> +			     struct uid_gid_map *new_map)
> +{
> +	if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS) {
> +		memcpy(map->extent, new_map->extent,
> +		       new_map->nr_extents * sizeof(new_map->extent[0]));
> +	} else {
> +		map->forward = new_map->forward;
> +		map->reverse = new_map->reverse;
> +	}
> +	/* Pairs with smp_rmb() in map_id_range_down() / map_id_up(). */
                                                         ^^^^^^^^^

This isn't a bug, but the comment doesn't match the readers that contain
the paired smp_rmb().  map_id_up() has no barrier of its own:

    u32 map_id_up(const struct uid_gid_map *map, u32 id)
    {
            return map_id_range_up(map, id, 1);
    }

The barrier is in map_id_range_up(), which is also called directly (for
example from statmount_mnt_idmap()).  The procfs reader m_start() also
pairs with this barrier:

    unsigned extents = map->nr_extents;
    smp_rmb();

Could the comment name map_id_range_down(), map_id_range_up() and
m_start() instead?

> +	smp_wmb();
> +	map->nr_extents = new_map->nr_extents;
> +	memset(new_map, 0, sizeof(*new_map));
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============6512166407887190360==--
