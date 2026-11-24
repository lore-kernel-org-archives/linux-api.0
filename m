Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795545347;
	b=pOZoYMM/PMlLvLO5AhnJ6HoGWjPog2WQh5VdCGjWdbj/TW/vVnbl0o56lLXj5elz6wPF
	 CtRljG2Yl+nZEXqLKjc2qPW+f5JK/xa7jjzgMa8z2qLODx4xa2C8bHtAhZxwovgjsD+yo
	 z1H851qPho0wjjG9g4Rolnan6dqVOVVB/vKNxtGaPZR0rifu0ss65eHpO+zpv4Hi2ALeF
	 8RmT/081BM2oU0V8fjWiLKTMvJPYU3exWA8Ts1F4BQ+yAMPNlH3d4Ck0R4mCv3mMCOWRE
	 mR5F87pB6PT1bcK7Tn4s8J+QCQx2D4Q3c7RLHyptXVZ5CaCBIErAFzU3p/WQxQLcHnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795545347;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=NH+LCPbT58VTTOKIoQohmGo8BCrcjnPK+zFjIzwgB7Y=;
	b=zCuf3WKPKArafRG0pyuce/nSAzbT3/wwDyBIqC9YWIjG3fC8kH4KHi7P4lNwRgEJHqWK
	 rUVZr5HxvDgXDs+X49b59GBxyqWJfbFZa0IFudDgo03hmyQxEp9GLjODo/pAl7WXQ1e3N
	 2a26DVcgPh4dOcnrOJ7js7LadQV7rYrU1eGTCuJhJ36DCJe81b8D9kf8blesxu8jgyfzr
	 IuxpX/tG4FJRPdfjtkOFdsAcGCGCBkwobbRBRlS0yIY6+DMwb1dA1FnA2iN30gFcQ+Pzw
	 bz/zaJJmYpE5jCE+Kd8c86VnE1XSlDLK5EhzNucMurI0METtMlKfodHaR5vLXiU7LMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGNhEOdl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3C8B8606A321;
	Tue, 24 Nov 2026 18:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YGNhEOdl
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CA1681F000D8;
	Tue, 24 Nov 2026 18:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795545346;
	bh=NH+LCPbT58VTTOKIoQohmGo8BCrcjnPK+zFjIzwgB7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YGNhEOdlnPN871G/X9PPWV2KDkNfg6lDAYL74NQ4uMZDrqBjOHxooLjxN6J9DJyuN
	 epQrEamKS5eGTLTDPRfDiX5spXFiq6j1WSiqUG/PtKfJ1tZSmLYqwKylZQhk9WPX7B
	 bEM8oPgYlXgUet8cYtuVzgh8rRxJEj8ZgkcD4hk3pA4UHghl4N8J0BPQIsCsPCZAFd
	 +kJTyztWJCLJ50m3BrED2g/opMxeaUu7STWXnyQ8A3/RFw4OBjGhmM9kNWyBlQHyvc
	 cKvYRL1apD8f0X5RwzYPerXPlVzxh1JZGzc30tc5hQHHP60AIzOQqgM3p4OYptBszq
	 3eYlMbouXqYYQ==
Date: Tue, 24 Nov 2026 20:35:42 +0200
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
Message-ID: <awXY_gKSqi-L5V30@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awTmJIErjasO4lqq@kernel.org>
 <awToL2PFNKVgIfqs@kernel.org>
 <awUGkYoyDXp4P5LJ@kernel.org>
 <awULfmZR-pESj2EC@kernel.org>
 <awVInf04kGC0uZZo@kernel.org>
 <awVRz8XC54nfevtW@kernel.org>
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
In-Reply-To: <awVRz8XC54nfevtW@kernel.org>

On Tue, Nov 24, 2026 at 10:58:55AM +0200, Jarkko Sakkinen wrote:
> > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=vault
> 
> The key function to look up from here is spawn_userland_container():
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/br2-external/patches/systemd/0010-nspawn-Start-containers-in-an-experimental-userland.patch?h=main
> 
> It demonstrates an initialization flow that ends up cleanly with
> clone(). userland_share_host_ns() demonstrates the ioctl I added
> previous week i.e., USERLAND_SHARE_NSFD, which is used to punch those
> host namespaces that the guest actually needs. This is the allow-list
> part, which is usually the favorable principle over deny-list.

This proves that bootstrap ends with clone3(CLONE_INTO_USERLAND), which
the most important property to prove at first.

The second part is "hotpluggability" property (hmm... is that even a
word). I have early local patches for this but they ares still unpushed.
I need to test this again with real hardware as I did in ad-hoc manner
previously. I don't think QEMU is acceptable for this alone.

However, it is not really rocket science with these tools, and it would
require effort to get these completely wrong, especially if they are
stressed even slightly with bare-metal hardware:

	nspawn: Hotplug device nodes into userland containers via udev

	Defer absent /dev bind sources when starting a container in a userland,
	keep the userland mount namespace fd open in the supervisor, and attach
	an sd_device_monitor to the supervisor event loop. When matching device
	nodes or optional API devices appear, update the container scope's
	DeviceAllow= property, populate the dev node and /dev/{char,block}
	symlink via its root fd, and attach the device mount with
	MOVE_MOUNT_T_MNTNS.

	machined: Allow bind mounts on user-namespaced containers

	When experimental support is enabled, bind_mount_in_namespace() attaches
	mounts via MOVE_MOUNT_T_MNTNS without entering the target's namespaces
	and refuses to fall back to namespace_fork() for foreign user
	namespaces.

	mount-util: Attach live namespace mounts with MOVE_MOUNT_T_MNTNS

	When experimental support is enabled, create missing target mountpoints
	through the target's root fd and attach bind mounts and dissected images
	directly into the target mount namespace fd instead of forking a
	setns() helper process. Fall back to namespace_fork() when the kernel
	does not support MOVE_MOUNT_T_MNTNS.

They are variation of the same pattern, and pretty obvious even from the
descriptions. When they are known to work, I'll push them.

Br, Jarkko


