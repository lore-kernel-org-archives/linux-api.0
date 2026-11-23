Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795465106;
	b=uuobfx5mWKgz5kza50QY5/70Uc/XRhBPsLJP0vYZCmsi5lIA6rqrEZZaTTXTdeKmkRQW
	 wHGEFZXTNyYzDyg4ZFrQ328aklsuKRdSYJriR/hp6zEdvVi9SQjEwLIcAHDeynAqyJ4XG
	 8Wo2j731CD0KzNy/JyEcPCQyV3+Cfh5fNDL/pwzo7zcWUMObfQWhdmoWOZZwhZjIYYpHz
	 zIuRnFCBm+gvjYeJfvbIhPqfksUXjrJRY8thHYlH3o4lfo3akzak7mjsk+fBUOTBHmETG
	 yXx8cnp/xJoyUqU+EephDdXxPqZGe2VKHyx4O7fNJRTBIQXiQdBtBqKEur7sd3+pdqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465106;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=8AUjLkJf+AzfntX6iFDwsoJRr0FO8Zc2d0H24MDxBvI=;
	b=5qjDrhLWQJ2tBo552pH8dySfLUau+cXiTrfAMuWXsF8E2SqhCYgfd2JOtoDfOKs8s+Bb
	 CZjo2TOO2UCPWMMauUueGXtZ9MrwU4MegOL0CyxBTpOYqYsKJmmT6yE7cRD5HZUtdSib8
	 2D9mxI6hEM1SV7rAZN3kM6GZDALitg235KDkFTVcHLJGkj4bpzrQMA6+opoDEmIV0zsyw
	 E9QvfvQKdbxYfjv2jh9iNny+L6RJQhjQ5w4aFwSKLUxPYilHDQTzALS74kecZXbLDccsW
	 5uoTSEdMFtjkD0W9E6J+Vu3a+QlzY9VS8WB4X0THdrPjcyk1P8YEgfs9/WsTGpc/SIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVyzKebp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D833A606A31E;
	Mon, 23 Nov 2026 20:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVyzKebp
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 674E81F000C0;
	Mon, 23 Nov 2026 20:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795465106;
	bh=8AUjLkJf+AzfntX6iFDwsoJRr0FO8Zc2d0H24MDxBvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UVyzKebpzwIv1Yn/drpovJ7QjKcAtXZdZD3OApmocb00ceKrmEfJyDHHIOPR6rxGL
	 dTlkkM2zSU+UbZRpUQ+0dvozMcV8vxWcZeWOo0r5n6suKMFSxE8JBMe1jVb3u4rql3
	 ms3Ao00f7Pon1f08VL7Hn46kMq6Iz6j3sYGeU35V56ovusnZnR6pYUrnDPbWr/p+wb
	 gIPYdrgT9PV8u20SWsFW944fnSAR4vKt9Jf/y5k3dQM9rNHyJbrWrSx4gBe9b8kfLw
	 1jiBkulqoMOpNt8DLyxG67WYmZUqfyURRMTL1VvHecFgRyFtDF6VEFNUqMvhuv5ulT
	 aypeV1ThO2hjw==
Date: Mon, 23 Nov 2026 22:18:22 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Serge Hallyn <sergeh@kernel.org>, Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	David Howells <dhowells@redhat.com>, Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Jonathan Calmels <jcalmels@3xx0.net>, Jann Horn <jannh@google.com>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	Singh KP <kpsingh@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org,
	containers@lists.linux.dev, keyrings@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] userns: introduce capability bounding set for
 user namespacesg
Message-ID: <awSfjslSDxyWvrHt@kernel.org>
References: <20261119104208.782900-1-halg@google.com>
 <20261119104208.782900-2-halg@google.com>
 <CALCETrVqc+1bjH1bhqHee9bsUdk2B6314z7PMexbsnNpMhk14g@mail.gmail.com>
 <CALCETrV=zSxb6sgA08DLiK2bQovdMEj9ycG=Cc71mLn2C5Pgeg@mail.gmail.com>
 <4db941ba-3001-4019-8910-63e534b29f89@schaufler-ca.com>
 <awSVO9Zc-233M7_P@kernel.org>
 <awSWK7o9PCk4ApM8@kernel.org>
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
In-Reply-To: <awSWK7o9PCk4ApM8@kernel.org>

On Mon, Nov 23, 2026 at 09:38:23PM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 09:35:16PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Nov 23, 2026 at 09:22:29AM -0800, Casey Schaufler wrote:
> > > On 11/20/2026 9:09 AM, Andy Lutomirski wrote:
> > > >> On Nov 19, 2026, at 2:52 PM, Andy Lutomirski <luto@kernel.org> wrote:
> > > >> ﻿On Thu, Nov 19, 2026 at 2:43 AM Hallgrimur H. Gunnarsson
> > > >> <halg@google.com> wrote:
> > > >>> When a process creates a new user namespace, it receives a full set of
> > > >>> capabilities (CAP_FULL_SET) scoped to that namespace. While namespaced
> > > >>> in scope, several of these capabilities (such as CAP_NET_ADMIN and
> > > >>> CAP_NET_RAW) expose broad kernel attack surface that many sandboxes and
> > > >>> containers never need. However, there is currently no configurable way
> > > >>> to withhold such capabilities from user namespaces while still granting
> > > >>> them to workloads that require them.
> > > >>
> > > >> One thought (from the rootns thread): the other decent sized attack
> > > >> surface here is CAP_MOUNT_ADMIN.  Which doesn't exist as a capability
> > > >> bit.
> > > >>
> > > >> A sort of horrible solution (but maybe not so awful) would be to
> > > >> declare that the bits in cap_userns aren't actually capability bits,
> > > >> and that you need the bit in cap_userns *and* the bit in cap_effective
> > > >> to do sensitive things, and that mounting needs cap_userns to have
> > > >> NSCAP_MOUNT_ADMIN *and* cap_effective to have CAP_SYS_ADMIN.
> > > >>
> > > >> I want to sleep on this.  It might actually solve several problems,
> > > >> e.g. controlling creation of ipv4 and ipv6 loopback or tunnel devices
> > > >> or whatever.
> > > > I slept on it. Here’s a counterproposal.  I’m not saying I think this
> > > > is better than this patch set, but I think it’s worth weighting the
> > > > options.
> > > >
> > > > Define a whole new set of privilege bits.  As a
> > > > poorly-painted-bikeshed option, I’ll call them eprivs (for exposure
> > > > privileges - it’s a crappy name but at least it’s pronounceable).
> > > 
> > > I played with a mechanism I called "chits" (all the good terms for security
> > > bits have been consumed for a very long time) that looks a lot like
> > > what you're proposing. I did it to address the CAP_SYS_ADMIN problem,
> > > where any use of the capability opens up a whole barrel of worms.
> > > I cannot, unfortunately, find my patches. :( The basic approach is:
> > > 
> > > A process has an optional set of chits. A process without a chit set is
> > > unaffected by the mechanism. A process with a chit set is allowed only
> > > those operations for which it has a chit. The existing but empty chit set
> > > allows no operations. A process may drop a chit, but not the set, which,
> > > again, can be empty.
> > > 
> > > Because I was after CAP_SYS_ADMIN, I envisioned a call
> > > 	cap_able_chit(capability, chit-list)
> > > but there's no reason there couldn't be a
> > > 	chit_able(chit-list)
> > > as well.
> > > 
> > > I wrote this as an LSM, but the system-wide aspect of it made that
> > > a questionable choice.
> > > 
> > > If you have any interest, I could dig more deeply to try to find the
> > > patches. Otherwise, I'm happy to look at what you come up with.
> > 
> > What if eprivs or chits would take each capability and subvidide
> > them into pieces? CAP_MAC_ADMIN would be formally a set of chits
> > (or eprivs).
> > 
> > And process having e.g., CAP_MAC_ADMIN, would actually have the
> > set of chits that are included to CAP_MAC_ADMIN.
> > 
> > Without that type of relation there's just a space full of chit
> > ;-)
> 
> This would not prevent from combining your own collections of chit
> that do not map to any specific cap, only that each cap should map
> to a specific set.

With decompose/compose relation it would neither matter if caps
would have for some reason the same chit. Internally task could
have just this sets and caps can be dynamically refreshed if
the process' set has all the chits that compose it.

I.e., that would make caps a cached result refresh, and chits
the actually stored security tokens.

Br, Jarkko
