Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795086241;
	b=oJRaqW2H0K1I68gfxCIu98qOYQah8GQXjHOjtBi1JT9iR+EJy0Wc9fCBPHeXum5JzkoA
	 HsdpiNIeOYGKCYM5Mh1M0d0KPD7iLnSC7WEDTG5atHE4yz31HCO5HMCJ8I+yZe5Dv0/oC
	 falLSnG3B6ty6qQJKnbDihk3sfLIjxtEyVabFnKiikkH7mwWDRsb5NSNSF/Hmmaj65CeO
	 T8efPMuTHaZx7OO+JbWEhOPmbmDmRtmbvnV9tRmchsOyTmi9tGhlPp6Tf1C5vjcLjwElq
	 ICkvA3PtaZ/fxrC+P4eWme8ULifPnEAtrQiudnILv90Mp3F6sXvFB0hel8Jilh5p3jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795086241;
	h=Received:DKIM-Signature:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer;
	bh=PdrhZ0ZFsQa7I1snTBf6hYpjeqJIpvbS8rtJD3JX0KU=;
	b=j2cvfzOUBh5VtcN7nX5n0ELWFoqdGXco6e6SsMY0GW7t7kR8NANlWbtHiE0jCjfFKjnh
	 mLevU/gmlF9cbHxInrZbLTGhGCBFCJlfdh3mcmdmriYJIW0UWAub/RSObHN6jj9sI3pGN
	 8ZsypW6v4NCYt/AaM8qSDffof2vyZN3e1pPLkGrXeRRDyi24ifpieBwRQoFCeTOX/bnK0
	 ZIOyS0OhPLyAb/uON33oQWEnT+tK7d80aEWMifL/OM7PKeyg4ND7+klD4GKfFWUzW4RcD
	 TSuXvYRgx73czf22DG9YQvt6cPldJZ1ZIgqmPNvgApjNE0Q3pKpNr9/OnQzdJwS3VeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JEvEy+Zx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B96606A324;
	Thu, 19 Nov 2026 11:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JEvEy+Zx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF111F000C4;
	Thu, 19 Nov 2026 11:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795086240;
	bh=PdrhZ0ZFsQa7I1snTBf6hYpjeqJIpvbS8rtJD3JX0KU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=JEvEy+ZxOHGHpptUbOqQ24Gn0XySdzQDS73WAhlCev/bRpaAyW+iZK0y8E8xcK7qr
	 hi5DDZqqTauBScUapz8LDM3wyXLPATQKb2MvZPneCwVGtmFsLYQmASqGq0Miq49Ttc
	 JEip4CjIuupZ8lK31OLiJeDLd4kSTzctKy3q9+BJptRRO/6vYJXROU8UaJL9nQIqIJ
	 cWyFuC7VDOJJW0tbThUx42h0poMigC2HGiyYPOi4Mh6flax/enQAMoNAjyLkltisQk
	 QOIXdN6Am6b+9bIwL2MIrjUmDG+XAbszHybnQ2dyDWOrKUKe9VnFMk+Zy0pXjo/gQ2
	 pVjFxCulrk7ZA==
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 4/7] liveupdate: luo_flb: serialize outgoing FLBs
 incrementally
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 skhan@linuxfoundation.org, linux-doc@vger.kernel.org, vipinsh@google.com, 
 linux-kernel@vger.kernel.org, corbet@lwn.net, linux-api@vger.kernel.org, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 rdunlap@infradead.org, graf@amazon.com
In-Reply-To: <20261118212845.2855249-5-pasha.tatashin@soleen.com>
References: <20261118212845.2855249-1-pasha.tatashin@soleen.com>
 <20261118212845.2855249-5-pasha.tatashin@soleen.com>
Date: Thu, 19 Nov 2026 13:03:49 +0200
Message-Id: <179508622989.425130.18199233960609980187.b4-review@b4>
X-Mailer: b4 0.16.1-dev

Hi,

> Currently, outgoing FLB metadata is written in a single pass by
> luo_flb_serialize() during liveupdate_reboot(). When sessions are
> serialized ahead of reboot, any FLBs their files depend on must also
> be serialized at that time so the outgoing KHO state stays consistent.
> 
> Serialize each file's FLB dependencies from luo_session_serialize_one(),
> appending new FLB entries or incrementing the serialized file count in
> place. Since every serialized session now updates its FLBs as it is
> serialized, drop the separate luo_flb_serialize() pass from
> liveupdate_reboot().
> 
> Because serialized sessions never unpreserve their files, FLB
> serialization is one-way: once an FLB is serialized, its .unpreserve()
> callback will not run and its root handle from .preserve() remains
> fixed for the rest of the boot.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_core.c     |  10 +--
>  kernel/liveupdate/luo_file.c     |  15 +++++
>  kernel/liveupdate/luo_flb.c      | 102 ++++++++++++++++++++-----------
>  kernel/liveupdate/luo_internal.h |   3 +-
>  kernel/liveupdate/luo_session.c  |   2 +
>  5 files changed, 85 insertions(+), 47 deletions(-)
>
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index 1b2bda22902d2..9fef5161a1f3d 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -219,18 +219,10 @@ late_initcall(luo_late_startup);
>   */
>  int liveupdate_reboot(void)
>  {
> -	int err;
> -
>  	if (!liveupdate_enabled())
>  		return 0;
>  
> -	err = luo_session_serialize();
> -	if (err)
> -		return err;
> -
> -	luo_flb_serialize();
> -
> -	return 0;
> +	return luo_session_serialize();
>  }
>  
>  /**
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 988eb313a135f..cdd3c466e5ac3 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -380,6 +380,21 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
>  	kho_block_set_destroy(&file_set->block_set);
>  }
>  
> +/**
> + * luo_file_serialize_flbs - Serialize FLBs for all preserved files in a file_set.
> + * @file_set: The file_set being serialized.
> + *
> + * Iterates through all preserved files in @file_set and serializes their
> + * associated FLB metadata into the outgoing KHO FLB array.
> + */
> +void luo_file_serialize_flbs(struct luo_file_set *file_set)
> +{
> +	struct luo_file *luo_file;
> +
> +	list_for_each_entry(luo_file, &file_set->files_list, list)
> +		luo_flb_file_serialize(luo_file->fh);
> +}
> +
>  static int luo_file_freeze_one(struct luo_file_set *file_set,
>  			       struct luo_file *luo_file)
>  {
> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> index cd715a7c1d992..4ac534171d423 100644
> --- a/kernel/liveupdate/luo_flb.c
> +++ b/kernel/liveupdate/luo_flb.c
> @@ -34,6 +34,12 @@
>   * This reference-counted approach ensures that shared state is saved exactly
>   * once and restored exactly once, regardless of how many files depend on it,
>   * and that its lifecycle is correctly managed across the kexec transition.
> + *
> + * Serialization: Outgoing FLB metadata is serialized into the KHO FLB array
> + * incrementally as sessions are serialized. Once serialized, the FLB's
> + * .unpreserve() callback is never invoked and its root KHO handle from
> + * .preserve() remains fixed, while later sessions may still update per-FD
> + * state in the shared live object under the FLB handler's own locking.
>   */
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> @@ -72,6 +78,13 @@ static struct luo_flb_global luo_flb_global = {
>  	.list = LIST_HEAD_INIT(luo_flb_global.list),
>  };
>  
> +/*
> + * Serializes updates to luo_flb_global.outgoing.header_ser and .ser[].
> + * Lock hierarchy:
> + *   luo_register_rwlock -> private->outgoing.lock -> luo_flb_ser_lock
> + */
> +static DEFINE_MUTEX(luo_flb_ser_lock);

Why is this needed? luo_flb_file_serialize() is called only from
luo_session_serialize_one() and that runs with sh->rwsem held for write, so
all the writers to the outgoing FLB block set are already serialized.

I'd drop the mutex and add lockdep_assert_held_write() for the outer lock,
or at least mention sh->rwsem in the lock hierarchy comment above.
Currently it lists only the inner part of the hierarchy, which is confusing.

-- 
Sincerely yours,
Mike.

