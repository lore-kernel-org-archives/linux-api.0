Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795313633;
	b=haC+CZDGIAKi1WgKWiXIwalEJ5H9XCaMsjQz6KzrwCN/haNNxpzgofTIeZV8Q2yJ3CWi
	 zrXCuVaTXN6F1S8BJKXDX4Tv552CeTEezPWh+pdOq1EEeTQYMtiDPiq3mUBaweYs1XmH7
	 pXt3MddF41RjY/9x55fd0+JAtulMylfA2K2n8Dq8aBOqOb8V7P9eON/1CZlYk36lYGY+S
	 2GHwHu5ZGY2Hq7VvGh5aFHTp6PWdFdhU5vHEZJ4xrsYuDuW3HgRvnQwXW0b1qflwNSv4F
	 9Oa3n8ITUDyI7LjAVcT1K6wgapIpRmM1WvGF4qqc9aPHiQ7VwpniztvuFtnbKgxC4bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795313633;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=9QITS/QYva23ozmEaxii1esTMO7DrH16wtmaozkU9sY=;
	b=cowpIE7asx7/2K6eqrvKnMrCXI4/Bq8UcQuat51WWCV3tC2itU+ZMr4/e3pUMiuKW53X
	 +fsF6nx4stP/4m9h+1JJ6JU1qIQ2vFzq4RMJ4XkR/QtBs0GTA2zpBQvO1xL/Zdj8dKzG2
	 SGcsgl0wWzKF2ZIIP5j3UFu1qkH70HRZR0Ukd4obo7bE+dN/6kuKWOq4JuPzkc/oW5R9P
	 f3uyOGlDltsSpljV8oiKZcuXjT72z+4fH9vj/dsdT/I5KqdpKidp4opd/+zEPk7bZDKA5
	 iCa20FRgMLqMg6eY4SPZn/X2AFQB87J/VJp03CslyKoc6GuWgoiX2Ebzq0EQatvSUag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i8SRVkQV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E610606A335;
	Sun, 22 Nov 2026 02:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i8SRVkQV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6314E1F008B2;
	Sun, 22 Nov 2026 02:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313632;
	bh=9QITS/QYva23ozmEaxii1esTMO7DrH16wtmaozkU9sY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=i8SRVkQVfMVUSOaeRqW/22HFBTQge0lZRo7DxOFvUpD9ypGTq29MRAjHTk6SHaO89
	 u6EN/oWjsUlxlOanYJ9itHDIlKZ5neQql1kEbhKM2sTHIM6+d/j2Nz0pU22v4W5rcD
	 dhmBZuK0OxEL6Y29d3M28n8tCwoGAx4AmH9KulxtBm1TMFDESvMWXeDgVmShNOY4hU
	 DCL37N7yglLu0K3JedUaPAHu2eihppaY6yfB1mP+5nlrj3yhBTjRycd3H7d9JGAS9Y
	 qNEkFhW7PWH6LDeM95M0kf0klzOjG2Tb460O6p+++5cQ3Vg0mGhjFnJzxLIv4+sZaC
	 XCLLsPM0e3Wzg==
Content-Type: multipart/mixed; boundary="===============0836080936566238576=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <fac042dcb631adc09d227a590d8790c36bf5aa71a7f047f7c07feef2cf8abc93@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-3-jarkko@kernel.org>
References: <20261122011809.2667684-3-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 02/26] userns: Add userns_set_idmap() system call
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:49 +0000 (UTC)

--===============0836080936566238576==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userns: Add userns_set_idmap() system call

TL;DR: Design nit only: the new idmap permission checks in userns_set_idmap()
seem to duplicate existing new_idmap_permitted()/verify_root_map() logic; the
review suggests a shared helper. No bug is claimed.

> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c

[ ... ]

> +static bool idmap_maps_root(const struct uid_gid_map *new_map)
> +{
> +	unsigned int idx;
> +
> +	for (idx = 0; idx < new_map->nr_extents; idx++) {
> +		const struct uid_gid_extent *e;
> +
> +		if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
> +			e = &new_map->extent[idx];
> +		else
> +			e = &new_map->forward[idx];
> +		if (e->lower_first == 0)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static bool caller_idmap_permitted(struct user_namespace *ns, int cap_setid,
> +				   unsigned long ns_flags,
> +				   const struct uid_gid_map *new_map)
> +{
> +	const struct cred *cred = current_cred();
> +
> +	if (cap_setid == CAP_SETUID && idmap_maps_root(new_map)) {

[ ... ]

> +	if (new_map->nr_extents == 1 && new_map->extent[0].count == 1 &&
> +	    uid_eq(ns->owner, cred->euid)) {
> +		u32 id = new_map->extent[0].lower_first;

[ ... ]

This isn't a bug, but the root-mapping loop in idmap_maps_root() and the
single-extent unprivileged block here look like copies of the logic in
verify_root_map() and new_idmap_permitted(), differing only in where the
cred (current_cred() vs file->f_cred) and the setgroups flags (ns_flags
vs ns->flags) come from.

Could new_idmap_permitted()/verify_root_map() and
caller_idmap_permitted()/idmap_maps_root() share a helper that takes the
cred and the setgroups flags, so the unprivileged single-ID rule and the
root-mapping test are written only once?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============0836080936566238576==--
