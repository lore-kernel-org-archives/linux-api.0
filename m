Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795492738;
	b=VC1eQlpNlCPQrk4Sv+b1eUAFET0+tak82dIsasf2rB/n8wUJbju3CSuRWJJGVLm+wYRm
	 mRYeEw/c+7QQzj8AohBg8U6BoraaRD6no6s57pptbxBLzMVuKoBnY81KBNdjz5PFYDl5W
	 Zj3NCTnznCG4B5Jdwg+Ui9Kn6gDKEI3ZjxtHLzi+DK8qgsdiHtXSnPu7tcbiy87YUWKhq
	 mDp8gsPw9zv7L79iKQPtpWul7R9TXP75Kp/388lUx/Cw/bjGe/ZouTrSThs2KxIU+RjmF
	 8uQ03b23MXzqNLjeDZhIiNmDZ053iHLYzfr6SwnbPcmE552m7FVi1sn0r80B6Ss6WaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795492738;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=NS45uIMLO58QIZFdFsRqQwpuveO9a35GIgn0ekSZke8=;
	b=DjUTnBsukSIeG/MLC9+o2XR6K6YQkXkfiBlc2+fG2S08gioJ5xHVOTvCA1GZcxrB9Kl4
	 WPbPoKLW5vXb5K2CLyn7eWt08FFPUxpxwj6b5P871fTG5di912CMv3j4sAdpVVBy4zibT
	 OA5ZSuSDEQTsJa7xJ9qlEAt5hPsBwHdnxP7u9Eh1OZ2cEn1ReOJhAVtBuzRATrCg2fjH2
	 hFfE8orV4KWOz+AjD+8T+8+/KAdaGW6bXaEO+YW83SjK3i6A83SEgmVYXg+RM6i8B+vmO
	 he67MgF3qP5UE/e2Y2yAEd9DBl9y6RJ0fxBKHQEzfAEeNmqs2VY15XcHF3H/aidd51w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aTy5+RVI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 32163606A338;
	Tue, 24 Nov 2026 03:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aTy5+RVI
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0A6C91F000C6;
	Tue, 24 Nov 2026 03:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795492737;
	bh=NS45uIMLO58QIZFdFsRqQwpuveO9a35GIgn0ekSZke8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aTy5+RVIdr9BQCwJGNCU+JGZNyIuBkeW2PKcNU22mYFHbK02ep8bNci6jVvu2FCjC
	 mWD0vUNBFxa16W5/KVosNO/h3a9BHaXz88hq25B1gm3Zqah/8hjvcSRZXUfBfkLoGd
	 Lq2QZT48f80Cew+fSSoIoW7VwpGEA5V5tWetW2qZ5rC3QM8ebIt3fnGNCa/k9PNyiv
	 NjXdmCWJsT+P2rZTLcXiveeiQayLn2A4pDDsqdPMUVibLOmgdiSguA2lhUHpOS/zcY
	 Mob1v+oAmz4/cXBraQV7HBSKGBYGrScyIJwnm6LX73iBJi5oQWeFb2pivVAFOqfaIb
	 Ue3TCbDSwse1A==
Date: Tue, 24 Nov 2026 05:58:54 +0200
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
Message-ID: <awULfmZR-pESj2EC@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awTmJIErjasO4lqq@kernel.org>
 <awToL2PFNKVgIfqs@kernel.org>
 <awUGkYoyDXp4P5LJ@kernel.org>
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
In-Reply-To: <awUGkYoyDXp4P5LJ@kernel.org>

On Tue, Nov 24, 2026 at 05:37:58AM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 24, 2026 at 03:28:19AM +0200, Jarkko Sakkinen wrote:
> > On Tue, Nov 24, 2026 at 03:19:36AM +0200, Jarkko Sakkinen wrote:
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
> > > I played on patching systemd and userns_set_idmap() alone does already
> > > a lot of good. I'm figuring out userland_open() integration next.
> > > 
> > > For the test implementation I probe the opcode's and dependening on that
>                                             ~~~~~~~~
> 					    syscalls
> 
> > > use either "userland path" or "fallback path".
> > > 
> > > This auto-probing is done so that I can commit the patches to my kernel
> > > test harness, which already has systemd, and try them out when built
> > > against userland-enabled kernel (via LINUX_OVERRIDE_SRCDIR):
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/?h=main
> > > 
> > > The project builds a hybrid ISO, which is a bootable bootc/composefs
> > > based operating system, and has toolbx bundled i.e., a reasonable test
> > > environment for all of this. It is also device-installable via "npx
> > > @puu/install"
> > > 
> > > I had to level the harness up a lot so that I could realistically test
> > > lockdown-hibernate but it is is also pretty good emulation environment
> > > for any possible container features.
> > 
> > Kernel is ukified and systemd-boot is used as the boot loader i.e., for
> > kernel testing purposes corresponds to something like Silverblue except
> > not using GRUB.
> 
> Experimental systemd patches:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/commit/?h=main&id=e4d6b15da3376ad09c0c575cedf467f69db32a52
> 
> The patches are layered per syscall feature:
> 
> - 1-5: userns_set_idmap
> - 6-10: userland_open()
> 
> Virtual device would add path/mount complexity and generally dependency
> to mounts i.e., I think it was an awful idea. At least initially this
> feels fairly lean way of doing container things now that I've trialed
> systemd-nspawn a bit.
> 
> I'll update the patches over time.

"userland_open" is just a name as I don't have anything better for the
time being (perhaps <something>fd() e.g., containerfd(), would work
better).

Br, Jarkko
