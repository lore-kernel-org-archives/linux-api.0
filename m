Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795888509;
	b=XDcziySZIYiwubZ3w11XV5HrUzCzyr0t81sqmQV/BBHcExL4QGuKVH4INJOqQdwS2JsS
	 2CLJeSKzFuKctmgtwHv2jcdLk7jf2mLQcqa8E/B4oWTbG4OvE4CF7YwE4g2G2IIgfz+sf
	 nloEVeR5BefoiGPErnpF+yyyePWMqb0qiUT4OChehgyYW6QxY6+BRSiTB4PReqcHasbdn
	 j4B14SsJx1OhCpJIfagPnd3vQ6YESZvcU5Hn7MoVPmGVMz84rPcNRXp/BbmB323tAG7nP
	 2VWV9U0IOAZHn6eCd4TNTCv0PBBgGb3EWIFOYqeFNZUAbiamv/RIZINao9EiU7S/qnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795888509;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=diPCJctt28WKiNtraULbGiIzJdaRnPUyrGlCnKZMbGQ=;
	b=mObbIfqBCZqY1aOKAqCQxk6aOJtnvQS/FNTBPTstklR7AIcRGo3kIn46Lzg2N9HLeO+Y
	 4kU7cRxzPAwJw1t3oF8oLradFPZ/1reRy8c9VbSwEeKNwVttV7ftvRpnJ6dj9p1Ts1HiV
	 vzai0wTIVub7Gssf8ICRvl+mcYcRVKnjbzcrFHkNcnJLTR/LhiKKWocoZFDSw9nHKA1Fm
	 38n34KJkIzkL4f/fz293udScc4a6wSN20Dhnd3LAY1ia6b4NXuKQ3OuGoOkE1OidOo/4J
	 QsLI59170cuC9BO5iOMILbC/Az9zn1nL6ZS13ZXZN3ZtQ1/wTN9mMqAripGmFrceJeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E4RKCAgd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1AE88606A323;
	Sat, 28 Nov 2026 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E4RKCAgd
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E340C1F00898;
	Sat, 28 Nov 2026 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795888508;
	bh=diPCJctt28WKiNtraULbGiIzJdaRnPUyrGlCnKZMbGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E4RKCAgdvAEPsLkv1go0Ewse7BOnAd67hKljyOA1cezEp2CIKw+DZFQ4K44qMULqj
	 Klrv1XecPHZ+Ku1tRMwfOHYLjpTYMPkDbC5K6GNmcu2yRVN/M9iVeiCGGtlupgxzth
	 0oTvOGIS8MUxX1Dm5hdP2pAFGbOwPZe6DyWnLt4mcbJeyyUbL38y4XswdlFI4Tqhl+
	 h/UZIOyMhlLLkj5imqj0U35X01YbEvTM8tWcYUIL2midmsPlno+DGq+3OchTN1rema
	 LPYqELdNo/7On7s7lK35L5WGa62oWAwZtQ0wldj3B+zYllZm9DrDjDFxgBrTx3n18q
	 29zfNg2NPDmSg==
Date: Sat, 28 Nov 2026 19:55:04 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awsVeNYhLWEhZYId@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awYJnFNt9kkBqj59@kernel.org>
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
In-Reply-To: <awYJnFNt9kkBqj59@kernel.org>

On Wed, Nov 25, 2026 at 12:03:08AM +0200, Jarkko Sakkinen wrote:
> 1. Rebased RFC v7 patches with refined LSM support and fixes to the
>    known issues as of today:
>    https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=userland
> 2. SystemD patches:
>    https://github.com/jarkkojs/systemd/commits/userland/

Bubblewrap: https://github.com/jarkkojs/bubblewrap/commits/userland

README.md update explains all this:

	When supported by the running kernel, bubblewrap opportunistically uses
	userns_set_idmap() to configure user namespace ID mappings and
	userland_open() with CLONE_INTO_USERLAND to populate the sandbox mount
	namespace directly without pivot_root(), falling back to
	/proc/<pid>/{uid_map,setgroups,gid_map} and classic namespace cloning
	otherwise.

Podman ought to be similar wiring as SystemD so that does not have as
much demonstrative value (but would be equally trivial to accomplish).

Br, Jarkko
