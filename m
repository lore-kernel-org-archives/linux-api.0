Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795508386;
	b=qBVsg27/PaLnQYPMMUnW0MLKjUBgqrX4Od9xISpNxKL2fQQaXxyj7XbfqSTFx24g85Kh
	 8I4F3VfanQSKQ5zM5jQXwIelu5f666ekMJrbAGeczGmkAhc4tmPXB+HC8RL1TS/mlgI2v
	 jdV3ay23uUth84zG9ChAVylsDtleGNNUrTop7agQoGb2wEPHT9kgvsvuDthlLNX7JUvs7
	 FIe5zx/k35v0Jq7eAljWA49ri7fNIo063nTwfXDdphZN7+G8bZf1CiVRVsIT1Fmv1P2zg
	 6LkKB7QS4Lq717zpbyhxopLCMAfWYKkC/g9rGoQ6YXO/mlPJqt4YHFx4yGT72udsDOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795508386;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=E9abjPcthtIyY+MMEtQrTLzJvidQaqZjoo58q53HUoc=;
	b=4bL36zJAWuFafEASIHo+41ON0b9Uclh5QYwRub0Szu22knTeTYftxtDPxYgRBgrZKwgO
	 1bm7S1Ua8X1btUZss8aZa0fb1AGoQkbbcDbAR3C31m7wUEPBMlefzk1cO2W7vk3++FhiF
	 vaEzOe0WY6WqQG+j71x9PKfQtLkCYxwwxe/pCcGWq7BJyImQ2ffgJf8Aqgj3R8GN6Faol
	 0NRyY5Q/6YkXoRt0Ed08s73iseo7U0h9jThxh0GTKoPLgwo4Ao/CGJ7D+KIjW+Zpec1Vi
	 08hE+A35CEE3Dvz2VHTqguR8+evlzlPpXGjYh/A4tGXaNmxyD7ecnXVl3zS3gszc7AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e3O83Rok;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 10324606A330;
	Tue, 24 Nov 2026 08:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e3O83Rok
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CDE391F000CA;
	Tue, 24 Nov 2026 08:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508385;
	bh=E9abjPcthtIyY+MMEtQrTLzJvidQaqZjoo58q53HUoc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e3O83RokhWRQvZwd1DE9oTpgGvx6IqeB+fzR6eFpiyChO2W7NR7MJQGtBcoiAgXR8
	 Wn3CnXsXOg60lEc79jyvbWLaENSpj7epk3SWKZSxsfG/TzzsD96HViD8sVrUPvjHiI
	 Uu3bfmaxPEXAcEMAc1H7CfoY+IZGDYCSroILEOWmGmLpFtMqe71KxLTvROwTUBBEjK
	 ZVvaTxYXqgEAgFgyKpJXSMDUSEV3VLF1gE9e9SbjHCr8Ql87moA1+n2j36wPzWax7i
	 zLVJg4VgAJDdKWFmBmBJnIeOjxrS95srOseTu7pz6bMmjmadSVRv7TQ8qDqTHAkRSB
	 BmAIIyq5qxSzQ==
Date: Tue, 24 Nov 2026 10:19:41 +0200
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
Message-ID: <awVInf04kGC0uZZo@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awTmJIErjasO4lqq@kernel.org>
 <awToL2PFNKVgIfqs@kernel.org>
 <awUGkYoyDXp4P5LJ@kernel.org>
 <awULfmZR-pESj2EC@kernel.org>
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
In-Reply-To: <awULfmZR-pESj2EC@kernel.org>

On Tue, Nov 24, 2026 at 05:58:58AM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 24, 2026 at 05:37:58AM +0200, Jarkko Sakkinen wrote:
> > On Tue, Nov 24, 2026 at 03:28:19AM +0200, Jarkko Sakkinen wrote:
> > > On Tue, Nov 24, 2026 at 03:19:36AM +0200, Jarkko Sakkinen wrote:
> > > > On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > > > > SYSCALLS
> > > > > ========
> > > > > 
> > > > > Two new system calls are proposed:
> > > > > 
> > > > > 1. userland_open(): open an opaque staircase-initialized container
> > > > >    object (modeled on Intel SGX enclave initialization with separate
> > > > >    build and live states) with no embryonic state, opting selected
> > > > >    shared namespaces in via an allow-list instead of unshare semantics.
> > > > > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> > > > >    extents for a container user namespace in a single atomic system
> > > > >    call.
> > > > 
> > > > I played on patching systemd and userns_set_idmap() alone does already
> > > > a lot of good. I'm figuring out userland_open() integration next.
> > > > 
> > > > For the test implementation I probe the opcode's and dependening on that
> >                                             ~~~~~~~~
> > 					    syscalls
> > 
> > > > use either "userland path" or "fallback path".
> > > > 
> > > > This auto-probing is done so that I can commit the patches to my kernel
> > > > test harness, which already has systemd, and try them out when built
> > > > against userland-enabled kernel (via LINUX_OVERRIDE_SRCDIR):
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/?h=main
> > > > 
> > > > The project builds a hybrid ISO, which is a bootable bootc/composefs
> > > > based operating system, and has toolbx bundled i.e., a reasonable test
> > > > environment for all of this. It is also device-installable via "npx
> > > > @puu/install"
> > > > 
> > > > I had to level the harness up a lot so that I could realistically test
> > > > lockdown-hibernate but it is is also pretty good emulation environment
> > > > for any possible container features.
> > > 
> > > Kernel is ukified and systemd-boot is used as the boot loader i.e., for
> > > kernel testing purposes corresponds to something like Silverblue except
> > > not using GRUB.
> > 
> > Experimental systemd patches:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/commit/?h=main&id=e4d6b15da3376ad09c0c575cedf467f69db32a52
> > 
> > The patches are layered per syscall feature:
> > 
> > - 1-5: userns_set_idmap
> > - 6-10: userland_open()
> > 
> > Virtual device would add path/mount complexity and generally dependency
> > to mounts i.e., I think it was an awful idea. At least initially this
> > feels fairly lean way of doing container things now that I've trialed
> > systemd-nspawn a bit.
> > 
> > I'll update the patches over time.
> 
> "userland_open" is just a name as I don't have anything better for the
> time being (perhaps <something>fd() e.g., containerfd(), would work
> better).

What I did at late 2025 was simply going through the old ML discussions
for David's patches and addressed the remarks one by one. Then I
improved the patch set bit further until other stuff came along, and I
forgot the whole thing for some time.  Last week's burst was really
unwritten todo list starting to remind about itself in flashbacks.

There's not much more in API sense to do except maybe syscall rename and
associated prefixes in constants etc. My Git branch has additional fixes
(e.g., more LSM plumbing) on top of this but they don't change the gist
of this by any possible way so no new RFCs for the time being.

The most up to date version:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=vault

Br, Jarkko


