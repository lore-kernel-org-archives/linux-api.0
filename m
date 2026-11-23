Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795393369;
	b=1xAXtJ7z9SbNtOEoD7vep0ylgMN2Z6CnABswnj9TeWTCnQAsCKxOsGQh0VxPz+B3NgUt
	 /s2KttENA0Mm3Ah+hUxuiebjHG6MXTqxsjsPVgG0mMN+4sGd8vGzC5KpJv7qyZW+3lFa7
	 leq5Bp8gt6tLw0IFGWpcVaOMtjnxDbZjKzYbnD/iHb5lIUZwvdPyFsRhiqvj0K5Ejy25K
	 sqLYjqj+yLit5kOMcDz9UBbQ+S+vW6YzQ6t8SFqatOfgoP5AmQRcBhZIAc4yylXf37B/t
	 qhYrsmCrSGXq9T8RskPZ0sy/A74F6j/gL/Hlhc8QzgY0Gy6Sb3KyxwR6vzMqxXLfegQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393369;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Jz1NKIIKgCd2mV0Gf7xePKwq1B4TLlq2GWrC4ESjcAQ=;
	b=a+6O0JxlwYaBpVCXQfVMzuYNe3tCXOU3MoO5Giw4bz0QmdnhpaVDWFUk3v0JHNPQnhDf
	 PCJuxlz1alW4wVoaNhNVOIhOAjP1MOJfU6yhUjBNpUw+eTJKeiXaqNKaXPtWGpnF/Qrq0
	 0KJKDfPGP26rRVLhyRsYEYjPDQ/FwM5scHZkYT9gUjfHFwwzL3LTf9IhhPeSsYphBO96Y
	 jArE78YtFPlJZEI7n4CAoWD6F7gOt6JhCSQj+D2pzk/x3YZnjZPbIf5OmxRKKhSotDhSr
	 hHGD8JutIcsVsX0FvyksE+iZbpldx4X9AJpty0tANV+m5TRox7jwsk4PJ3aVumAa1eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D9PzkT11;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4BF32606A31A;
	Mon, 23 Nov 2026 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D9PzkT11
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 15F751F000C6;
	Mon, 23 Nov 2026 00:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795393368;
	bh=Jz1NKIIKgCd2mV0Gf7xePKwq1B4TLlq2GWrC4ESjcAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D9PzkT11tfiXFbsmqjxDg4JVSIMsco9OtJLz8dJ3yn2/dEcJVEzcRbuZCSLbL4pIQ
	 NF9VESCGoar573rnroMuamO3celH4JvkzdLprPXCbFU0eHdwWCBjioF8vNDqae4K2U
	 w/0Pd5FZ5y+8wjRW+NkSdYPoaeBvmJBFPMnYS7EPPkexL9VZEZPlE0IRVWk8zCdpaZ
	 My/rP7StpwNbAYvw30XqtjzLOGJXEtSw56b1hzxXaQXLqgX64NeFtM52qSXjYW5fUI
	 mEYW9GYl79/y4A7eEhdM8pWZ1fxk4ooDT4Y4OMfTFDAx9aWat5amCSC7XxETL0zCHh
	 2siz7HXceBmwQ==
Date: Mon, 23 Nov 2026 02:22:44 +0200
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
Message-ID: <awOHVCpztLQv4Uwv@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awOEa303zNUDrzA3@kernel.org>
 <awOFGIWekH9-vlhM@kernel.org>
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
In-Reply-To: <awOFGIWekH9-vlhM@kernel.org>

On Mon, Nov 23, 2026 at 02:13:16AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 02:10:23AM +0200, Jarkko Sakkinen wrote:
> > On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > > SYSCALLS
> > > ========
> > > 
> > > Two new system calls are proposed:
> > > 
> > > 1. userland_open(): open an opaque staircase-initialized container
> > >    object (modeled on Intel SGX enclave initialization with separate
> > >    build and live states) with no embryonic state, opting selected
> > >    shared namespaces in via an allow-list instead of unshare semantics.
> > > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> > >    extents for a container user namespace in a single atomic system
> > >    call.
> > 
> > Andy, perhaps a bit too far of the box idea but I'll just throw this out.
> > 
> > An alternative to userland_open() would a file e.g., virtual device
> > file, and necessary wiring for open().
> > 
> > Then the added syscall surface would reduce only to userns_set_idmap(),
> > and it adds more robustness to access control (e.g. who can create
> > containers).
> > 
> > What do you think of this?
> 
> Also, easy way to detect the feature. This does make sense to me.

This as a side-effect would enable LKM compilation, and reorganization
of the beef of the core feature as a driver. Not sure what would be
the best location for the driver tho, perhaps just drivers/userland.

I.e., full decoupling from the syscalls.

Br, Jarkko
