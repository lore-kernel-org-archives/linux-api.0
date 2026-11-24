Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483699;
	b=lIUwg84VrnGe9DCmz/uO6Vd87HiRl5XVUyHdbsKeOhj3VyTzWXvoZn5V+TrGrk1laaL0
	 03mRD51F0vJojULPfVOdaL6aUWeFqBmHKcMDx1BV02+ag/XSg9vh7YoPa+Hvk29iHlmiv
	 SwS2vSbSsEfmMRPpFHyDUzjaOifWmGc4yMtBGJd46yHfX4MprIVjyP9VgjyLKE4QYEack
	 giPDh5RTH/et427+2t+scxQvlvON6P77xWMOlYo2yfBWK8Z0fwvhemZGVUmqLCESvCXDC
	 XdDMZ78AP9OLAwOgxYM7cqrwjBITGpyee0QojKGizii8Qmg+crRF3rE3SC+N1pE0/Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483699;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rR3LoSS/CnHxEjvm/yoRjwsCnx6t2+6QYn8uLZ0saD0=;
	b=tMN4xXCS0H7P3ZTQ2JSV9aB6CnVRmzvjG5HOgoYMmuDGXT9PB0eWoVZg1tUIpBNsiL2a
	 VxgN4hvAaNffHE1kuF1poJKfuq2lP+zaS1in/svrTQk0mIQqsyw7bl/xzYX5VmrZaeW9P
	 C4CBbsTxwuaX+ekIxTwOEgPmOGL/rbOHaYHovDVs1DHXBed9J1O4aNpqVt0go6mC7XUeJ
	 DiZ3s54XwTEAkCUP72C3tisgZhKQW3+tv6SKLIUXax215qauuiBjC3KqMdiLJQyeZwG8r
	 otQa0aLURaAtXthtWyYCOR/KMKt1H6iLUDvkoQLEiZoxwau382tr7yPS1BfoSvXX7yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhiLjCcn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 512B7606A31E;
	Tue, 24 Nov 2026 01:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhiLjCcn
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5186A1F000C4;
	Tue, 24 Nov 2026 01:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483699;
	bh=rR3LoSS/CnHxEjvm/yoRjwsCnx6t2+6QYn8uLZ0saD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MhiLjCcnHp95T7HuSLpsxG3/eXdkRaSIRPl4sr8N1U5eHtYO0TTNagpfp9FvmkyLY
	 poVwlubetpPDij/MC3k1nK/9BUf5UjQy69XH3Y/lHA+UmTSurdUcg8YSSYFXRbKlTD
	 jcbh79HqiPBRN4crGCI4oilTmV8umW0Wa4zCjU7Akv5fnudGwO1FhYCxPW8ulDClTP
	 6fMW/Dcsm2g3xZssBeJt/iJjwdDF3L/cHmN6TjWY3Hoes81OGCWTlNSXOZmWrEz+K0
	 9hcKPTnRxdqfj1RyZC5Qoh8kkYy8ExXwELZeyHET1akIkufbVIPoo5520mFH4jAWpG
	 gH3wNwAHcfRDA==
Date: Tue, 24 Nov 2026 03:28:15 +0200
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
Message-ID: <awToL2PFNKVgIfqs@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awTmJIErjasO4lqq@kernel.org>
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
In-Reply-To: <awTmJIErjasO4lqq@kernel.org>

On Tue, Nov 24, 2026 at 03:19:36AM +0200, Jarkko Sakkinen wrote:
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
> I played on patching systemd and userns_set_idmap() alone does already
> a lot of good. I'm figuring out userland_open() integration next.
> 
> For the test implementation I probe the opcode's and dependening on that
> use either "userland path" or "fallback path".
> 
> This auto-probing is done so that I can commit the patches to my kernel
> test harness, which already has systemd, and try them out when built
> against userland-enabled kernel (via LINUX_OVERRIDE_SRCDIR):
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/?h=main
> 
> The project builds a hybrid ISO, which is a bootable bootc/composefs
> based operating system, and has toolbx bundled i.e., a reasonable test
> environment for all of this. It is also device-installable via "npx
> @puu/install"
> 
> I had to level the harness up a lot so that I could realistically test
> lockdown-hibernate but it is is also pretty good emulation environment
> for any possible container features.

Kernel is ukified and systemd-boot is used as the boot loader i.e., for
kernel testing purposes corresponds to something like Silverblue except
not using GRUB.

Br, Jarkko
