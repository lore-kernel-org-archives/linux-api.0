Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795261660;
	b=E2l4eaE8UvFM1GAUpbupwhxGM12p+usWpDTdiar8nD/h0RjVatZAiZSYuHjPsUckMQkv
	 GlKPD9Lxi5g+k9Y9HMyBEiw1Krc5g3S48i9DT3ITcfnMD22Md0Nz3cqJG/Xtu2Yacns8L
	 W2UudwBpXYBTo9/SZaax4ZRriFl7lNqsMf+DGS9OVj+7/ICCrLeSA+0p58hLHjlQm7uEX
	 CzUKig7y9v6LDNG2shh7fiol4tjaJrkMFuab6XvGbfseAbe4me/DUSvZ9OudE3H7lUsy3
	 ihsCPJ2FogyDbW6xwssoqgY/xRyqmdpqLiM2eTSO0bXO18lbV3gnotHZ3f4ht0aTF+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795261660;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4ALx0sJpj+pkFds0WlOLPKL1r0Eodz+uXw3XkI0BnJQ=;
	b=0cyf9QfaMxbqYvf+G5jzZ6zo0rtqXO8H9w/Ba2XWF4jY3zKvl6I+iTViQmdlZXgyhSZN
	 EgHGtQTzljqM/Wq5VNtA73C3e2WMaTIAZ/8tDGBu65J2T8CZbXFo3BqliBpmDdQ9QMMlX
	 /LvWK2SptkkUiW/DBm+GrR/y+ODtusS4uqIN/PAS/l+U1HCQUyBN+J0RbzO34bbpJQ8Ks
	 mznhRdD25/kLjRQgW4FiGOLOfIja38a1gQLvPu8ICGj0UzuvVciaHI2PB7RYC6uy7bLsN
	 lPMwwwxwKx57MzXSgQWFPFWLrslIeNrbGUTgyS3HIra/gdhLbNVXUAKeuD868/1TyGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IkROlQ0P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 67F4A606A320;
	Sat, 21 Nov 2026 11:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IkROlQ0P
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7B4521F000C0;
	Sat, 21 Nov 2026 11:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795261660;
	bh=4ALx0sJpj+pkFds0WlOLPKL1r0Eodz+uXw3XkI0BnJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IkROlQ0Pq+Rut8U64pvIUJTh/oAnChCaeNYg7hBVBuRUnEhRsa7xNq/JRarTXK2K/
	 1SrKwVoY5oIeDiNoie/5u8U8GgnhTmyy0YX6Ld+DcqlRzwJDYG0Roi6EYh/NSo328Z
	 gtWd1bE18xVGxRviE+EdpOnXwrmVQ8V4R2Hep+47tEdMGgvQkfsf4DeY503xo0UrGz
	 +bmeCFDEAe5+Uy7+IO+cUFDQVBzUpeFHqWg93+bOiVNe0hghenDK7O9YRFT43oKEgj
	 ETQw/sww4Y0GKJuijqz84K+iCyImKpbC8/fpbl33gqZ6lI9qEE90ukgklczuRo0UYy
	 qfTMs+JqLTQJQ==
Date: Sat, 21 Nov 2026 13:47:36 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 20/25] security: Add rootns LSM hooks
Message-ID: <awGE2FTQ6kpWEMJh@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-21-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121000844.1863324-21-jarkko@kernel.org>

On Sat, Nov 21, 2026 at 02:08:39AM +0200, Jarkko Sakkinen wrote:
> Security modules need visibility into root namespace creation, teardown,
> process entry, and container-wide signal delivery so policies can attach
> per-rootns security state and mediate operations on rootns file
> descriptors.
> 
> Add lbs_rootns and rootns->security blob management alongside
> security_rootns_alloc(), security_rootns_free(), security_rootns_clone(),
> and security_rootns_kill().
> 
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  include/linux/lsm_hook_defs.h |  7 +++
>  include/linux/lsm_hooks.h     |  3 ++
>  include/linux/rootns.h        |  3 ++
>  include/linux/security.h      | 30 ++++++++++++
>  kernel/rootns.c               | 44 +++++++++++++-----
>  security/lsm_init.c           |  6 +++
>  security/security.c           | 86 +++++++++++++++++++++++++++++++++++
>  7 files changed, 167 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 87d9d06710cb..2cb90ddedc14 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -480,3 +480,10 @@ LSM_HOOK(int, 0, bdev_alloc_security, struct block_device *bdev)
>  LSM_HOOK(void, LSM_RET_VOID, bdev_free_security, struct block_device *bdev)
>  LSM_HOOK(int, 0, bdev_setintegrity, struct block_device *bdev,
>  	 enum lsm_integrity_type type, const void *value, size_t size)
> +
> +#ifdef CONFIG_ROOTNS
> +LSM_HOOK(int, 0, rootns_alloc, struct rootns *rootns, unsigned int flags)
> +LSM_HOOK(void, LSM_RET_VOID, rootns_free, struct rootns *rootns)
> +LSM_HOOK(int, 0, rootns_clone, struct rootns *rootns)
> +LSM_HOOK(int, 0, rootns_kill, struct rootns *rootns, int sig)


Rootns objects have a security model:

1. No embryonic state by design. Especially staircase initialization
   contributes to this property.
2. Unshare logic is inverted. Right now ROOTNS_SHARE ioctl does not
   exist right now but it is (obviously) doable.
3. Dead obvious and transparent LSM hooks. Really hard to get them
   wrong.
4. We already know by experience that opaque fd-bound objects with
   two-phase state machine (build, live) works. It's what make this
   secure and policy-free implementatiion.

The choices how to do things with closures used in SGX driver are
translatable and they are also pretty well reviewed choices, given all
those years... I would put some weight on this too.

Br, Jarkko
