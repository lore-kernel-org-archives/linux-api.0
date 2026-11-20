Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795203306;
	b=R8zxk6pmB5aClnW7dUF5d95BjNQIMCnCPtHrn9e0ImlG4pGs5JtfyHeBRowqofO2/GQC
	 qtyrh+9h7lnZ6c9FaruXGK4hion6ArJkS/vFvS/QBtvkK7oBel/5g9qCGtiUDjlfhOYaS
	 C0VTCHHvidp9hDS+Y5UPBNMZgG/rh5Pbom5BsFBz7FWm4PZw307g984YFBciDuFSxa0cS
	 WokNlCS3RxTrOkrRy89XZYcuLASpG9TiysTjjP1+V9GxdL3BdkM+njj7LN6OHjdqsbYhb
	 Xck2UYVirc/dYO5Lsolq8sYkg2IY2Wn+8RbhnmeEV0KTt6LagKju1eLOkXmJO539MSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795203306;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=f2nwNws6jb2rrcrjqN6IHTTGcIBFf7pHC19yvGssvN4=;
	b=EOWwo7KIOkf6RvaPdokW+QwoIR8RDLD5bLoSo4/pxz/HfiAv2om/vGkjkgq7IRq4S6xI
	 2cOOG8Ct9EhEoySjsAEzanAALcTAPmYY5vy73pPP032TsuFuOnDIoLGLVIteaH/1ZoJPx
	 kNed9RE3i2ubZC3zosaTM3DImuyYjT/J/1DAUBi+zjPfRB3xuOul9A/DCREvuFgK9AD2d
	 OWX2FNKMi99CCAinDe/vX1mS2oSDvXB5bE7KkLv8Oyi/MgaJBpu8VmhfCiT317DqnL+Qv
	 dBRh34PoLKHkzQOqtaGSwe+R5S4Xr61MMyg7vy7p8GnVzokX4HPwP/yeqrHPBBpVLTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WUM6Iykf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E4CB2606A6F9;
	Fri, 20 Nov 2026 19:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WUM6Iykf
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0EDE41F000C6;
	Fri, 20 Nov 2026 19:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795203305;
	bh=f2nwNws6jb2rrcrjqN6IHTTGcIBFf7pHC19yvGssvN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WUM6IykfgvNu8g6AkQkzfo5Kk77jKNOUhYvg5Wz/BbFykaRnSLMtBaIp6+z6erDVN
	 Km4cec9BuB5poq0q69vDCtW3era3rmkANhJ5Rg5TbP0Yz2p9DtyVV7HMT57goJj4U/
	 eVVsS0xSSdDjKfg1KQ9H8doGeXtRX0mCTKZ9xtq9CvNtp/fibr0vLfbgYomkn4kEyL
	 Bo7fvXfIL/2Z7zlhVetzcD6rhw54AW5MOhFvEu0s0qRY+IJDALeniGgZZke54Ff9dT
	 xglz2l4wsMcX2VZzLKsaAcWB2MD5X6WRtIBFZd23FHebjVozUGq68BnlV8YF5ZUMwM
	 BPqaw8BTrIRGA==
Date: Fri, 20 Nov 2026 21:35:01 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexander Mikhalitsyn <alex@amutable.com>,
	Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@amacapital.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>,
	Paul Moore <paul@paul-moore.com>, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <awCg5VYXKJvex9vy@kernel.org>
References: <av3akYFOYaeQZauZ@kernel.org>
 <av3bkDnwmjunTleX@kernel.org>
 <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
 <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com>
 <CALCETrXt-Do28BHDpbrA98kEy-tQuorxD8c2XsW24Tt8Vspdtg@mail.gmail.com>
 <CALCETrUbe8rBoxrC+Q66AMsrJ8Fow7xt5KJKRAmobtXBvHWdqg@mail.gmail.com>
 <c301fff20a4920fcd3baa31dda2e31ad99c93436.camel@amutable.com>
 <awBHZO2VwWyJzvBN@kernel.org>
 <1f12636403bb7af3759cd933b2612d8a5d7317a2.camel@amutable.com>
 <awBRyKgOQlaEqpWX@kernel.org>
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
In-Reply-To: <awBRyKgOQlaEqpWX@kernel.org>

On Fri, Nov 20, 2026 at 03:57:32PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 20, 2026 at 02:24:57PM +0100, Alexander Mikhalitsyn wrote:
> > Yeah, detached mounts API solves a security issue here, but it does not
> > fully enable the use-case Andy describes (if I understood it
> > correctly). My interpretation here is that to fully cover it we need
> > some well-isolated communication channel between container and
> > container manager (vsock for containers? :-D). And some well-defined
> > agreement of how PID 1 inside the container can get an information
> > about a hotplugg-ed stuff. [ But it could be that I completely
> > misunderstood and Andy meant something much more simple here. ]

The sequence for hotplug (Andy's use case) breaks down like this and is
doable:

1. Host creates rootns(ROOTNS_SEAL_MNTNS).
2. Host sets uid/gid maps with NS_USERNS_SET_IDMAP.
3. Host populates "/" with MOVE_MOUNT_T_MNTNS, optionally combined with
   MOVE_MOUNT_CLONE for bind mounts.
4. Host spawns PID 1 with clone3(CLONE_INTO_ROOTNS) (optionally passing
   an AF_UNIX socketpair fd for communication).
5. PID 1 watches /proc/self/ns/mnt via fanotify(FAN_REPORT_MNT |
   FAN_MARK_MNTNS, FAN_MNT_ATTACH) or polls /proc/self/mountinfo.
6. On hotplug, host mounts the filesystem via fsopen()/fsmount() (plus
   optional MOUNT_ATTR_IDMAP).
7. Host creates the mountpoint with openat2(RESOLVE_IN_ROOT) + mkdirat()
   and attaches the mount with MOVE_MOUNT_T_MNTNS.
8. PID 1 receives FAN_MNT_ATTACH and queries the new mount via
   statmount().

ROOTNS_SEAL_MNTS, NS_USERNS_SET_IDMAP and MOVE_MOUNT_CLONE new features
that are yet to be submitted but they were not tedious to ramp up.

I'll include them to v5 of the patch set. Thanks for underlining this
part because that led to having those.

Architecture scales to this even if my choices to address these details
would need some adjustment.

The clear two-phase (build/live) progress with rootns sort of just gives
room to address stuff like this, and I have hard time to believe that it
would get much better than this.

Br, Jarkko
