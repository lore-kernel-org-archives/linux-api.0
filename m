Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795279803;
	b=qxQOg0ULIn06/JTznRrvoxHrOrEp4KBnwXb1B6Gmo8in3j5cmAuE5DQdly3eFCxzDd5y
	 55xHMQ8DJ/eIm65B6X7Wlgic7PKLyD+HZaHPs7FwDYqNqkfR8lxo8A1605ZguvJM0mSVd
	 txPpOW609Ye8rCMhmFScg3HIenZNtz0JETxmmRZKV2z6fcLgJqx4z5vSAvAYQFrmMOi+6
	 FUJAgXdVRm6r/0GLIqokhPhpQr3ZUJQuOGGGZG52WiqpS7jo7ifI3W0Kss1VPkSRsHeXG
	 Z7uf3NePPzpfiT2WVVU4muPf1Nvmidu4mSWGn031LXt97JJUbgqhDhigUDds1N1srPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795279803;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qmKlARszXrRzW/9tlEK7o5BZOIq/QjdgeWG7kY2Dx/k=;
	b=uYCO67PHEiM7cNMqbiLTdcNfzyFhD3pGN4KU1IxrAfi+XNHKXn39ct3U/A+o3FMWHxmy
	 Pqk8UsiVWQGy6hUjVrUzh8J1hgq1mJ+WYxG5JDlYzmIn9788RI0m8DZeGpEHDxVXG4omR
	 cU3Fj9DYCV45eI844ivsDm08gI71tgaJdsSaCmLX/qq2jBAkN37wBL8eZmfp7y9bhPz8Z
	 7unGI26EQrjVk/bzFEIL9WQMGM9Awq+pB0hR5tOV7eOfr7kZxN38KozXSFQWBpTIIeRta
	 67ma9fLyYYTW4uM0vdkEBBaHvvMmgWXOlu9WEsCX6MuUu+NakKTp5//93IVkHLV4cNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcaRsRrH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7A516606A32A;
	Sat, 21 Nov 2026 16:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcaRsRrH
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AE3181F000D0;
	Sat, 21 Nov 2026 16:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795279803;
	bh=qmKlARszXrRzW/9tlEK7o5BZOIq/QjdgeWG7kY2Dx/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hcaRsRrHvGL/Sc0mJK7h1Q60HXVGMSiV07H7e9Wm/eCYP/ovxlZrA3Nws0kSzUEKo
	 7e2wiP4VwNV8c4JoR0QkYD6vXBuGWl0YKGXZKktvtFD1EWMAEV6WwWczGeiIojgRkQ
	 c07DjrcsL7cdhRjvksQw8PqngHKEbho0S1Jxvp1wSikxOKzHJnruyYFpBBzoE4cp3H
	 ED4fr5dv/tOVedrJeaonJMOVrz+FvQOQFrw+zJZl6s/vEw+Xq+Jb4hQmgLd9Oh5qkR
	 qmM+edFAf/pZEZny4gRYJXUJM7NAAy7z/yqpjPMoTWOQ6AiKYnpTmHFksebB0DqtoY
	 /e/wX9IzjItpg==
Date: Sat, 21 Nov 2026 18:49:59 +0200
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
Subject: Re: [RFC PATCH v5 02/25] userns: Add userns_set_idmap() system call
Message-ID: <awHLt1IpLcqxUnDW@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-3-jarkko@kernel.org>
 <awHCTNAo9uMakhAH@kernel.org>
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
In-Reply-To: <awHCTNAo9uMakhAH@kernel.org>

On Sat, Nov 21, 2026 at 06:09:53PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 02:08:21AM +0200, Jarkko Sakkinen wrote:
> > Configuring UID, GID, and project ID mappings currently requires writing
> > formatted text to /proc/<pid>/{uid_map,gid_map,projid_map,setgroups},
> > which depends on a live task in /proc and enforces write(2) file-opener
> > CAP_SETUID/CAP_SETGID checks that prevent passing an unprivileged userns
> > file descriptor over SCM_RIGHTS to a dedicated CAP_SETUID/CAP_SETGID
> > mapping helper.
> > 
> > Add userns_set_idmap() to atomically configure setgroups policy and UID,
> > GID, and project ID extents directly on a CLONE_NEWUSER nsfs file
> > descriptor. Require CAP_SYS_ADMIN over the target user namespace in
> > either the caller's or the file opener's credentials, and check parent
> > ID-range capabilities strictly against the caller's credentials.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> I'll remove the flags. I forgot to remove them from final version.

userns_set_idmap() still has flags-parameter but it is gated:

	if (flags & ~USERNS_SETGROUPS_ALLOWED)
		return -EINVAL;

And used as a bitmask:

	ns->flags = ns->flags & flags;

Br, Jarkko
