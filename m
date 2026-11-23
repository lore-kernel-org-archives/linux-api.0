Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795393574;
	b=n2o/OFk77fcUGA46Sc0QZ9o6CMcVH0jmTSkY7IhLC5tjTsAEc+jUW8HWH/rn2JNsUHwA
	 brubhQM4D7W1Nqpew5fu7ukUs43VVPoEDkuaR1McI6x6o6m1Q7jfRaDRzT3nbilh89Cab
	 BpWowLSzhuJkTgNKX0vZEBzaTWPFLMz8/JqI235LrfA58turEUKsJUpZ2nB7Z3/WbMPe0
	 n+Un2EYMp2jGxx42EkHxek3AD/+spn1Ggu2+WaG1wVXRhbuxsppGOdpd0NGay1Tu/J/10
	 PJjjsiVzZojwMCFkW4E4pTiCP8SjlMTZcCEilnWlscyVqDtsfrd5br2W8WKa8CDwpmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393574;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Np7fZSYURVKo0ykLKnKN/e1CFyZ5GmziW7UTv6oqkBg=;
	b=JPghQysTF/xfVx2xM+qwIFL0XwQDHoxXDFpZzxpqnLidbstXL90Y3ncwVfZh1FZcvt4o
	 7bELXuB08zd3HEn6+3TmsQOZ5J02UGQ1C606Q5EUTawcgMQ8K6HqAeg3UqIDTxmnsn33x
	 0EHaj4NZr8mr/vh6Ekf/uy4i03+bDetjnLL/PNXMggbfANql4oc9p4cVau0QmzsrqYjeD
	 GFVkM9npoZwPx9jHL2Z6FyuVZMSSfcqm/XLExYJoemBXDlYkHl/IcCir9KI+K7BdeiKr/
	 dXAnFFX5yWUDopjQFppchNCIsBcEccr1gNwLm7dWU3S6kFUVwwIxd/P0Jg6V4In8gyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XTTYuAtT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 92486606A320;
	Mon, 23 Nov 2026 00:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XTTYuAtT
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 77F411F000C6;
	Mon, 23 Nov 2026 00:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795393574;
	bh=Np7fZSYURVKo0ykLKnKN/e1CFyZ5GmziW7UTv6oqkBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XTTYuAtTfAlg0WH9XZNPNM7S+HLBop3wyxrt6AZb8BiQ/Gcs79kUj59MMdnE7zjKQ
	 6xk0zPvaGdlG8o9ZUMGLAaOiaoDh4dLG6WNkRYPhuhQSyEsvPBz3KMQjuS6m7xd5dG
	 Ot9O95tbcPRy9IHFMgYR0M5uFEZsIn+69FEAQlQR3rWR6ymXF88kwRbDdIo+Jw4lgY
	 YKAHH8A25VOQvWrywy5q8chM2R+ortwz1L4AYTL89LZ/Swh1LO/3fuwj1dPvoYQS1e
	 rxcdFPD4rGTTlycsU6r7F/Z5zD9ej6TCW+7qcXWzVmur1oME5eDf3FDMxcpULj0bY5
	 LbOIMT1N38+0Q==
Date: Mon, 23 Nov 2026 02:26:10 +0200
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
Message-ID: <awOIIuoNvNLZ_scF@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awOEa303zNUDrzA3@kernel.org>
 <awOFGIWekH9-vlhM@kernel.org>
 <awOHVCpztLQv4Uwv@kernel.org>
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
In-Reply-To: <awOHVCpztLQv4Uwv@kernel.org>

On Mon, Nov 23, 2026 at 02:22:49AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 02:13:16AM +0200, Jarkko Sakkinen wrote:
> > On Mon, Nov 23, 2026 at 02:10:23AM +0200, Jarkko Sakkinen wrote:
> > > On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > > > SYSCALLS
> > > > ========
> > > > 
> > > > Two new system calls are proposed:
> > > > 
> > > > 1. userland_open(): open an opaque staircase-initialized container
> > > >    object (modeled on Intel SGX enclave initialization with separate
> > > >    build and live states) with no embryonic state, opting selected
> > > >    shared namespaces in via an allow-list instead of unshare semantics.
> > > > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> > > >    extents for a container user namespace in a single atomic system
> > > >    call.
> > > 
> > > Andy, perhaps a bit too far of the box idea but I'll just throw this out.
> > > 
> > > An alternative to userland_open() would a file e.g., virtual device
> > > file, and necessary wiring for open().
> > > 
> > > Then the added syscall surface would reduce only to userns_set_idmap(),
> > > and it adds more robustness to access control (e.g. who can create
> > > containers).
> > > 
> > > What do you think of this?
> > 
> > Also, easy way to detect the feature. This does make sense to me.
> 
> This as a side-effect would enable LKM compilation, and reorganization
> of the beef of the core feature as a driver. Not sure what would be
> the best location for the driver tho, perhaps just drivers/userland.
> 
> I.e., full decoupling from the syscalls.

Right, and LKMs are great for live patching. This has enough quantative
weight.

Br, Jarkko
