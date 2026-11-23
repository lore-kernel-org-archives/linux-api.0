Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795392624;
	b=tSai+mVeaOAIT+AjYPT690a3+C7p3Lqrxb9zzjuQl4gLB/l6AZq4sAFkJF262eSjsZLE
	 6rpMMQbK+8NnQyyCT5mlg1YD8dcGcSHHNpULIkU/gENIKQBYJhE46hQ3/PDdnXpE4a70o
	 NckD5UeXrWYk06CdIuBQBVBE4cBCqaAPZULgAvBKp6ywkFUE5d92Mhg/CrogTBjsM74nH
	 m1xv64cgriFE43h+gq70aovgbeeOOJ73CJCs3ZSskRcMCAhql4VpqFfcOcEXo7qiTpGt4
	 YFbm+ATRhiVucvIbNsSYYvW33gRaoGYu4aDlg2HIMcEhnUXNcHIrgoDDcH8BA+O0Tbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795392624;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZVqAgRNp/806Eu6FhKubSIrbLTDfdOK4rCR11mJ3soA=;
	b=VIMYhMLLnH6RKpz1psoR3+1p3EarWQryosfhBH5i/vGMyOnTqcb+DSsOcSg2DdIKXKG9
	 d6sKIRSAX4Vglk8oTtUbqapJ94L9+E1DymnN0FxhKODyi5aWTg0cb+LEeH+syT3gMYAUv
	 Om4oaGTJNrjj7JEw2DE5OWXqQ07kg56hwI8iFdBk2Hj/WtdJDbOYrWvmWpsPpyqMDBrA6
	 nfT2wDQM8k8duLD5mRXYxP/uyBY1slwGot6AKeRbKVOdZzZghwINH+Cg4c9kjMJ01rYtQ
	 Z36aWj3HUgFHCPdQF8ptJ7edDrNqx0xVW63JrfR34yYp0dHWYCEW6lD408wehHKrzTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIBalDqF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EA047606A31A;
	Mon, 23 Nov 2026 00:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIBalDqF
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 574BA1F000C0;
	Mon, 23 Nov 2026 00:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795392623;
	bh=ZVqAgRNp/806Eu6FhKubSIrbLTDfdOK4rCR11mJ3soA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aIBalDqFUyBaRSQx3VhqHqWOCy356DzFuoO1chw/cAmHvSXvAodD4MbvPpaj96fK0
	 7kG77OT80wpmVRWo8hA4UTxfYDOvNNQ+OPKjT8JIHjGfDyoxJ5mHA0oCR5MqNuJz12
	 sXnZ3AfTd+SHluWBc9scTS910r7uaKlFGTcD3VAMeNTD6CPRRb5C/uuEGDUYWLaxGO
	 4Xoz8L38hCpwtmo1Nups5A87P+5Uu+QzJzway5aRYJikhauRbI82OjUxnAql+Uzlxy
	 1vhRp2jijx/G6uOla6NeECNxbmKVss6aoH3MP/Y0bhy+w0it1R8Sn/KeH7uil/e+Q/
	 Vo6z9i9W8aI0Q==
Date: Mon, 23 Nov 2026 02:10:19 +0200
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
Message-ID: <awOEa303zNUDrzA3@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
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
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>

On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> SYSCALLS
> ========
> 
> Two new system calls are proposed:
> 
> 1. userland_open(): open an opaque staircase-initialized container
>    object (modeled on Intel SGX enclave initialization with separate
>    build and live states) with no embryonic state, opting selected
>    shared namespaces in via an allow-list instead of unshare semantics.
> 2. userns_set_idmap(): configure all UID, GID, and project ID map
>    extents for a container user namespace in a single atomic system
>    call.

Andy, perhaps a bit too far of the box idea but I'll just throw this out.

An alternative to userland_open() would a file e.g., virtual device
file, and necessary wiring for open().

Then the added syscall surface would reduce only to userns_set_idmap(),
and it adds more robustness to access control (e.g. who can create
containers).

What do you think of this?

Br, Jarkko
