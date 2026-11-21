Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795284537;
	b=gYBl6nAXYqbWU+OCeI8tyeQLYhYeW2o6emV6lmcfOBij7tAVZ0+6R4qmKnZyNM70qbkR
	 ZKwt/ZYEH8VJ0w6MVvyMJO57redKW9WBtQbd5XvHQmMJ4TtVgVdU66Ab1vJRiya4D4M2x
	 RdiKE2ERaye7SZ3xOa5YvUbIxMsjm3TLT/OTMdfonwCk3LuVCJvl4uN02NynLzvyAmWJn
	 MieMBPqXNvFv1VjNzVyp+bG/y4Fgth2tR2j074sjPZkKI+LGjJJLn6mjppPm/7AIeXTnm
	 83B0H6Vt1I+rUMmJ3kapLFxgHTGDqawtvzKpV4PPGMNyt+9dTA5zgJZaP1jmO2yAQEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795284537;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=CQwRyg3E7Pe33Vv03sibxiYkx4sLjX/viouQjlWqGts=;
	b=OocrpgtdIh+UnbuJCylPrn51Wwos8nHYdkDqS+Wh0QMTuTFp0HThdU8/Z563A5UNnqqQ
	 t7sHq6RYSElEULgQqQwyyWyBoaAoU8wkBIBScDVfCNJMvK0Qiy7gXQqrnXoefLVStJTH/
	 WP+Yl+bCIj3xsTGCWMvHhIYxsvqCtZSiEum8fNRSvOeCP4W4ryuyYucQGpClam6bNmNrF
	 cF2j69Md119XQG163ByNloaHd3kXsngapHHXv2bt5Y/XLmLqcf4o1yoYDRPtmablvcVgO
	 4GMWYf38podzbQ3d5wIfQ/9JszIjiUTu6XH5rWtTCgwfgVBq85M0/q989G/LDc3LLaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GAoxKLYr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 554BD606A320;
	Sat, 21 Nov 2026 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GAoxKLYr
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5948B1F000C4;
	Sat, 21 Nov 2026 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795284536;
	bh=CQwRyg3E7Pe33Vv03sibxiYkx4sLjX/viouQjlWqGts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GAoxKLYrQK7IFGuFua6ECbRxuvIaLcAU/LtOyTkJyBMgl/OVoOkIB3UFrBJPoaINW
	 06FrBQ/2qCjQ22IYvJra+Z5722z5hwRmTbK00KQ3v61xStPRNVjlxPO7nemU02AVea
	 gwmkG7hOxhEQGLr3hywsHS2VtbTgD1qjiB0l6wurrkduJcUxxWvxT3tybEjP+f18Va
	 VMyrA6DGwgMzYdypvhitA+V8eTBapQW39m4rA+yqD14hJBKSj57aIsvB66JETZQdAR
	 Yfk2NDC23mDMeQLS+Mb449IVepANsYGFmy2gRZw4sYqiacMom/Wee57laT8Wz8walj
	 iI2ZpUNq9xY9w==
Date: Sat, 21 Nov 2026 20:08:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 12/25] rootns: Track init lifecycle via
 copy_process() and pid_namespace
Message-ID: <awHeNG3WJrRsyTop@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-13-jarkko@kernel.org>
 <awD0lNmhRPaXI9Pg@kernel.org>
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
In-Reply-To: <awD0lNmhRPaXI9Pg@kernel.org>

On Sat, Nov 21, 2026 at 03:32:08AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 02:08:31AM +0200, Jarkko Sakkinen wrote:
> > A root namespace needs to record its init thread group's PID when
> > bootstrapped and capture its exit status once all processes in the root
> > namespace have terminated, without serializing normal fork() and exit()
> > paths inside the container.
> > 
> > Commit the bootstrap child reaper and bind pid_ns->rootns in
> > copy_rootns() after attach_pid(PIDTYPE_PID), and invoke exit_rootns()
> > from zap_pid_ns_processes() after the root namespace's PID namespace has
> > killed and reaped all member tasks.
> > 
> > Co-developed-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> ROOTNS_GET_NSFD will be the only surviving ioctl, which make access
> control wise sense.
> 
> This leaves room for ROOTNS_SHARE_NSFD, which would share a namespace
> from host. This makes whole a lot more sense than unsharing security
> wise as it is allow listing (instead of deny listing).
> 
> It can be post-clone3 disabled. This is what we do in SGX driver i.e.,
> have build phase enabled ioctls.

/**
 * DOC: ROOTNS_SHARE_NSFD
 *
 * ``ioctl(rootns_fd, ROOTNS_SHARE_NSFD, ns_fd)`` replaces the corresponding
 * member namespace of ``rootns_fd`` with the ``nsfs`` namespace referenced by
 * ``ns_fd`` (one of ``CLONE_NEWCGROUP``, ``CLONE_NEWIPC``, ``CLONE_NEWUTS``,
 * ``CLONE_NEWNET``, or ``CLONE_NEWTIME``) while ``rootns_fd`` is in its
 * initial build phase (``ROOTNS_INIT``).
 *
 * Requires ``CAP_SYS_ADMIN`` in the container object's user namespace, and
 * when the caller is not already a member of ``ns_fd``, ``CAP_SYS_ADMIN``
 * in the owning user namespace of ``ns_fd``.
 *
 * Returns ``0`` on success, or ``-1`` with ``errno`` set to ``EBADF`` if
 * ``ns_fd`` is not an open file descriptor, ``EINVAL`` if ``ns_fd`` is not a
 * shareable ``nsfs`` namespace file descriptor, ``EOPNOTSUPP`` if the
 * namespace type is unsupported, ``EPERM`` without required capabilities, or
 * ``EBUSY`` once ``CLONE_INTO_ROOTNS`` has transitioned ``rootns_fd`` out of
 * ``ROOTNS_INIT``.
 */
#define ROOTNS_SHARE_NSFD      _IO(ROOTNS_IOCTL_MAGIC, 0x02)

Makes sense enough to include to the next version.

Br, Jarkko
