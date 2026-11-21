Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795277393;
	b=CmmOCpe8RxH5fewU8tEjpTcECm/FWf8K9pBolTYoLS3+WFm7UX4WieOKTGwAXkLN0hPr
	 vXRjmZmAWC5wdWBsxqk7T5MJCIAySDktJBdOV3mIniDuv4UyHO6I6hzvQWnKSwp4DU4N/
	 6SG/GmWkSJiDuAMIO1PZRUQzWNmFnNOmZAmOqhxp30v2AOzf7bjCjW4LbJXdKVlk0vUpU
	 yRXsWHM9J4zJ0ja381SnCDzZ5QhlkVcDDIT0n0lrZSEZFVVqP1+gJRMYQC0CiNtquy8qI
	 DNxwlcTS62Hbf9ttlLLCIKV4NPfkew9dGXR0bzYygXfo+asBeyCTed9zz+QQRVLtcRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795277393;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=G4XM20aAeu12Jm5j4NnIE/mMGTDsNHoeQWXmu2VwhZk=;
	b=PqLCJwHCb+ir6ZUfW33sX8+u3X9GcrdcwgSsGEATnEocGryWViDgqj1MmDjsxoMg2Jwz
	 BRPKj9DGfil7muBirT7RulOXP+MclOJISbWjx1bCXjAeqv2BEKFKxtq/x6Pdq/tQpYr6u
	 iiMbKgi2zycI/Rb4cjqoDBUoEZv0ne3QC0Ogn/ej4pXv2vJxWJ5js2Vc6GEVw5mGOw46N
	 caTq/6Yzrss9ehUpwzGy71OquW2DvZbI1THYgkp4psaoWkvQckrCIEypXI6Az077GpuZy
	 c7BGp5fXhrhSjON1IBhw6W1sl3gY7Rgb7uWt6i5wSwFvoOvywTTaJ9kRyybCURC1eZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KBKTCy5U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 47222606A320;
	Sat, 21 Nov 2026 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KBKTCy5U
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 485F21F000C0;
	Sat, 21 Nov 2026 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795277392;
	bh=G4XM20aAeu12Jm5j4NnIE/mMGTDsNHoeQWXmu2VwhZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KBKTCy5U9VGPIKUtr5T+pTPJ8YTcpZUJWGcJg5bDAWFLkwHDKYBxkKooOahCWXEb3
	 gAPAKvuh6WV8yNwn/Rx9emu51PZKosn/+Af9RViI3KMIAyxvZl4PkYSo11RmOhQ9Bx
	 dsiIB7UirdIWN0sst0R5U4jgjVVd5W7gWHFEmxpaGjR+3b/wShv+8PlQkaxQCiAk50
	 N321ye8ZC6CPo9kQqcaZ9bnbNwdV+TYarhT3fvEe3HFojGQGBdQsChw2QzjIL6rxLn
	 wyCCvAjkkXW0aRnHm6xCdC4DjY0koyjaFHxTGhSJ7GfGlolJZIyxj03eVMQUqzVJLJ
	 JD1rerrZ9pB2Q==
Date: Sat, 21 Nov 2026 18:09:48 +0200
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
Message-ID: <awHCTNAo9uMakhAH@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-3-jarkko@kernel.org>
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
In-Reply-To: <20261121000844.1863324-3-jarkko@kernel.org>

On Sat, Nov 21, 2026 at 02:08:21AM +0200, Jarkko Sakkinen wrote:
> Configuring UID, GID, and project ID mappings currently requires writing
> formatted text to /proc/<pid>/{uid_map,gid_map,projid_map,setgroups},
> which depends on a live task in /proc and enforces write(2) file-opener
> CAP_SETUID/CAP_SETGID checks that prevent passing an unprivileged userns
> file descriptor over SCM_RIGHTS to a dedicated CAP_SETUID/CAP_SETGID
> mapping helper.
> 
> Add userns_set_idmap() to atomically configure setgroups policy and UID,
> GID, and project ID extents directly on a CLONE_NEWUSER nsfs file
> descriptor. Require CAP_SYS_ADMIN over the target user namespace in
> either the caller's or the file opener's credentials, and check parent
> ID-range capabilities strictly against the caller's credentials.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

I'll remove the flags. I forgot to remove them from final version.

Br, Jarkko
