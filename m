Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795392796;
	b=jJ5OkAe8X/KNAwxF7m9stVuTcBYMRpacS76smhFSDWMRXVif03NViYlnzYlCrgIxvZxt
	 UVNaOlYYC197m1nk/RF/GxwoQaNFMElNAmYKUMCIqsfLpXvWltjoeRLUzHsmWcY9IVttL
	 LuVjZKdUv31ueRP0FuST3QLyaJe33u0NQi6WlX60Fi2nAHZlh3E0Ovl8nXaB6WEvgQRst
	 /xXGh+sz7QjE/l1kNnm5z40WtA/1r0fQ7uuJlXz19zKvQF7sC8bAZGYTsJZo/MNOQgaWu
	 fMAymEyeB4+peba2da386/u3oadbNqKbCzpWAgiUgtBTgPVScaDPt2jOo4BDLvMyoUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795392796;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wNHqEZsoH0fl0KvemxrRFgEKII9FO4FpbdMxVzBA/es=;
	b=zGmRZL4qgG8JU7nzY63oAJFR4fLPo/fM40sT0XekNczbE3KIdAtUkV3tm+DrLI4jmEgZ
	 2v5t2up3CRl83n+l3jrn1dAzataYPjNH5affgTsFHqUKR65LsUABN0NtJ22KFQ93wyAfh
	 YlBmrr+/SaEOYJ+RuWCoORItbEjN8QYhymiYzWI6XIkTUX2bxsFZQuIAeJIvnmXIFNe4u
	 SrlRgdXlEz5Mr8n9QZnvfk9WTgYb5Z5SGFnOLX/Q73fzGWSoY6aYHB0+NAzHSXgNR1dde
	 eLulw/fJ97CcsiZGAyMrwfkpUzr5uF3pOIre84WFQF8X7aqwaxfIuy9GO7UtQoKppig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Thac0G2i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 32855606A31A;
	Mon, 23 Nov 2026 00:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Thac0G2i
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EB8E31F000C0;
	Mon, 23 Nov 2026 00:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795392795;
	bh=wNHqEZsoH0fl0KvemxrRFgEKII9FO4FpbdMxVzBA/es=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Thac0G2iUDcXz2qgaJW8h/S+5nNIqyajBYdxzDEme/bJSPMTe7c3pRgwzgodAVoQh
	 mSokN09iHBie/kF/x0KahT2ipTDZfjbXgWYwU1GSRAZwJdLyPaFSaN/DwkoxM+5A+p
	 7MshlxsCaWUb+qkLze23KVR1cmAv5hnNsNU939yryaW8IPFXuZTne6FPxmqP8Go0Sa
	 cDfWRGtcKwXGHvXoVygr6TiD71aXKFcfCOU2d6HUw9YdgmFVbrYVyY6igYRm3F9YKb
	 EViZyMRONm1wSRulbDZZ/8V5UuxKVjY/b0SanxkgwkIiE4eozqzbOYfncDgHX+BmsK
	 M4rbopl0ZwExQ==
Date: Mon, 23 Nov 2026 02:13:12 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
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
Message-ID: <awOFGIWekH9-vlhM@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awOEa303zNUDrzA3@kernel.org>
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
In-Reply-To: <awOEa303zNUDrzA3@kernel.org>

On Mon, Nov 23, 2026 at 02:10:23AM +0200, Jarkko Sakkinen wrote:
> On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > SYSCALLS
> > ========
> > 
> > Two new system calls are proposed:
> > 
> > 1. userland_open(): open an opaque staircase-initialized container
> >    object (modeled on Intel SGX enclave initialization with separate
> >    build and live states) with no embryonic state, opting selected
> >    shared namespaces in via an allow-list instead of unshare semantics.
> > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> >    extents for a container user namespace in a single atomic system
> >    call.
> 
> Andy, perhaps a bit too far of the box idea but I'll just throw this out.
> 
> An alternative to userland_open() would a file e.g., virtual device
> file, and necessary wiring for open().
> 
> Then the added syscall surface would reduce only to userns_set_idmap(),
> and it adds more robustness to access control (e.g. who can create
> containers).
> 
> What do you think of this?

Also, easy way to detect the feature. This does make sense to me.

Br, Jarkko
