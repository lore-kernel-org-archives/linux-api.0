Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793270702;
	b=29aSHhEbSCZ31xSBfJv5K9muDjmAIwbI7ONCwTf+UmzIW5XW6AKU6bRP8BvfzpXvUL9S
	 BmogCBMVyeYEIkrxeDMXMhVqYb0YnzpeGZG2Nqg2w5RpcLmGwZZDtO+A6x4GgaWrVoyC5
	 LNi84jlRLbDwvx8CtcGIgOrFoD6kDli6fxLlmIiQ+yia97t3rOKgGbftrmML2ZiNwnBt2
	 bjhM3RlE0RfBy5E/pqbb+0IYIErtM/JGrnW8EVfhq9cLAp5uEjtafP1cc9DCb4VjpDsja
	 w5bqvFP43KECG/F6Ks08/PntMHFHxBqPhtc9RSJah8wQXUibLGgRPwrcjwTGNc+DBCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793270702;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=0dCSBHfUVHBP5GH3Zssr2yssdn3VkCL1gUTLqNUcb1c=;
	b=3g0GjEFfFfK3bdiVjF2Fdb1J/4Gm/QksdLuuGkVBI3y1WFvMmkuKsMhRgl9+7dQ31pTb
	 x68yyDC9/YCvxZdyjSg8mBO4O9U1DZ2p1uoyLXYbIfuL2fND+gsPh2VZIHqYJIZ4bLEJB
	 cwtFFLmlqVwI7sQjphZTEKksfsg0+Eeemt80AhFHATnh/GBKRQKNzbjtZU/15ltKI+FWk
	 PLCQ8z7FaZ4XKK9cMc9zFSWVndQpch6bGIuIoSx3KO2ohdWfVeuRzHnY7vHM5Kp++wBg6
	 2Oblunedc5SjdW5JBeD7GE9T/DyiDYP8rz1fgDRI3o9N9gZNj+NJfBfjqCn4FBzviwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nxT2VMz4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBDD606A31F;
	Thu, 29 Oct 2026 10:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nxT2VMz4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569071F031E2;
	Thu, 29 Oct 2026 10:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270702;
	bh=0dCSBHfUVHBP5GH3Zssr2yssdn3VkCL1gUTLqNUcb1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nxT2VMz4fnyBGepb2y6DIfK6SE3t2B76Yk1hsA8J6xw19WDTRWQkc5zer0rtHjzZQ
	 Gb5inbSwozgewNJrlxHySAlYyumEcf2I2H89YJtQ2mKV0FR1qRmlFr6921WsPFWLvf
	 mDO6xtXeNV75v/I7AsXrq4ElCmke3k3ksppR2nVk6RK7nwvVoDAMyGrK3MqSVHCrLS
	 tx08eVD4EuQq6XQyn5UuT1nZTBQdXegs6VSSweVrPGuWGxNOLxCoSSp+LhLfxnwPRU
	 jvL20xWFcOw1tu/0Ngm+yTfllKoTUKGa6bFKvqepHlY87fecj0Xp5xBmzDsbE6PVCD
	 GcxWud5QzBBKw==
Date: Thu, 29 Oct 2026 11:44:52 +0100
From: Alexey Gladkov <legion@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Hallgrimur H. Gunnarsson" <halg@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jan Kara <jack@suse.cz>, James Morris <jmorris@namei.org>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	KP Singh <kpsingh@kernel.org>, Jonathan Calmels <jcalmels@3xx0.net>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org,
	containers@lists.linux.dev, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
Message-ID: <auMjpJwXQJyXr3fW@example.org>
References: <20261028221705.3915340-1-halg@google.com>
 <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>

On Wed, Oct 28, 2026 at 03:56:11PM -0700, Andy Lutomirski wrote:
> On Wed, Oct 28, 2026 at 3:18 PM Hallgrimur H. Gunnarsson
> <halg@google.com> wrote:
> >
> > When an unprivileged process creates a new user namespace, it is granted
> > a full set of capabilities (CAP_FULL_SET) scoped to that namespace.
> > While these capabilities are isolated to the namespace, they allow
> > unprivileged local users to reach deep kernel subsystems (most notably
> > networking configuration and raw sockets via CAP_NET_ADMIN and
> > CAP_NET_RAW) that historically assumed a trusted caller and have
> > accounted for a large share of local privilege escalation
> > vulnerabilities.
> >
> > Many workloads and sandboxes use unprivileged user namespaces strictly
> > for basic UID/GID, mount, PID, or network isolation and never need
> > high-risk capabilities like CAP_NET_ADMIN or CAP_NET_RAW. Likewise,
> > system administrators often want a host-wide policy ceiling restricting
> > which capabilities unprivileged user namespaces may acquire, without
> > disabling unprivileged user namespaces altogether.
> >
> > Prior work by Jonathan Calmels [1] proposed addressing this via a sixth
> > per-thread capability set (cap_userns) alongside a global sysctl mask.
> > During that discussion [1, 2], feedback (e.g. from Casey Schaufler)
> > suggested that rather than adding another per-thread capability set and
> > prctl() interface, capability restrictions could be integrated directly
> > into struct user_namespace and configured via clone3(). At the same
> > time, as noted in [1], a clone3() flag alone is not sufficient for
> > administrators who need to enforce a host-wide ceiling on unprivileged
> > user namespaces without modifying every userspace callsite.
> >
> > This series combines both pieces of feedback: it embeds a capability
> > bounding set (cap_bset) directly into struct user_namespace, reusing
> > the existing task cap_bset, cap_permitted, and cap_effective sets on
> > namespace entry, and provides both a system-wide sysctl ceiling for
> > unprivileged user namespaces and a CLONE_NEWUSER_BSET flag for
> > voluntary per-namespace restriction via clone3().
> 
> Why should the task's cap masks affect this?  *Maybe* cap_bset makes
> sense, but I'm struggling a bit to see why cap_permitted and
> cap_effective should matter.
> 
> Also, I think that Docker in non-userns mode restricts cap_bset, and
> the purpose of that restriction is rather at odds with interpreting it
> as a restriction on newly created user namespaces for purposes of
> vulnerability mitigation.
> 
> >
> > In addition, because restricting CAP_NET_ADMIN at user namespace
> > creation time prevents userspace from bringing up the loopback
> > interface in new network namespaces, the series first introduces
> > an opt-in flag to automatically enable loopback on network namespace
> > creation:
> >
> > 1. Opt-in loopback activation on netns creation (Patch 1)
> >
> >   New network namespaces start with the loopback interface (lo) DOWN by
> >   default, requiring CAP_NET_ADMIN over the owning user namespace to
> >   bring it up. To block external network access while preserving
> >   localhost networking, sandboxes commonly create an isolated network
> >   namespace with only the loopback interface enabled.
> >
> 
> The whole unshare/clone flag situation is getting out of hand, IMO.
> And this new thing makes logical sense but is really about reducing
> exposure.
> 
> Perhaps we should instead have a small list associated with a userns
> (extensible in the future) of things that the ns's admin (i.e. whoever
> has CAP_SYS_ADMIN relative to the ns) may do.  That list could
> include:
> 
> - Create loopback with sensible defaults for ipv4 and/or ipv6 (i see
> no obvious reason to separate them)
> - Create tun/tap interfaces in that ns (and attach them, etc)
> 
> And add a very simple new API to do these things.  Actually, the
> tun/tap could just use the normal mechanism.
> 
> Thoughts?

I think that's an interesting idea. I also think the whole flag issue is
moving in the wrong direction.

Are you thinking of something like `struct open_how` in openat2,
or something else?

-- 
Rgrds, legion

