Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793970835;
	b=NAtbdzh6W1wPGaZb3v1D9lVqUGIFnPq2XiGrG1TowwK3BmlZO0i285gYjfb5DHdyrW7E
	 A0v2uAlDsKm4kPIKbEG5rTpytal5/xLxSByq1gCB1Sncu9dj3JW1RlyVYQx/eHCWsE0sr
	 fNqRWo9Fp499sFpG3L1ovQFdFhB8WMiURgJNEOSb11NiJTdJpS/IHXuuKmlTAbeQFQtva
	 SFmFKZjDqat3rXj0UdPHjwlSfrvqLbmm9JDL2RL55Z0k3tHLFxVt4moFKYozDXmjacOpp
	 X336TsV+SHbwAaqTqRBEGtBgGjMEb207Ri0mfxXwr1fmreqvfqADN9UHWroAig/ZPNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793970835;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9iuU7MEsK2c2Pxl1bKzJoGbt24cwSpLcFKHMSnlxVwA=;
	b=tKk/fjXPWg1AaVrBJ/a8KBBH/ZBfrLe6kLgiEeMCZI5j08THcAyifGbDCxmJFDxGwQND
	 JZBvRx8hy27BktTIIvAvqVnIMbQfUA8nwITAv91K09Kznq7aXCQAF7w2uhbjW23vCrotg
	 3A9kEMbuyZFrhTjvJzwdo4ohtgJMJsgn8A0ZUt2KldLds/XjtfCaCdUoOTKtHvoFSQDZ8
	 TecOj2ub2XBROqxjF9W8jwidFSlXUCjsHVJ1O1PFkoC/3WMoYe6qfWpbLvMuqbOAGqJaO
	 VMMCPEU30g0qqOHs5BXbfhcTkUFHEOwJVWOh/ItkDMtoUWuPiiZtM9MGiKoeqQ34s9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KC5lAMVT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFA8606A32F;
	Fri,  6 Nov 2026 13:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KC5lAMVT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9261F008A1;
	Fri,  6 Nov 2026 13:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793970834;
	bh=9iuU7MEsK2c2Pxl1bKzJoGbt24cwSpLcFKHMSnlxVwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KC5lAMVTiD1H0HRO9wudEjkt9ITRbgLn9PNNZsFAY+PQgcAeTb+mLFYjU0VQBr/P4
	 OMgR42zZI/a2XPhf2h7VSdpTnTw+0H4wU7aQXkP7RjIUfB+HBeff4XbbOOVLZiU+Ef
	 d+tf/0NHrAEZuk6IfYvnyUE8lgmnTQjSZ0Bx8YVn6mlfS8I8eHqh0HdwSiV8K805D4
	 bJ5IqHRIeniTOCWEvTu2GBSeCrdyHq1f6RaWtk+BKmv8FhwurXZ0OHdQtFPFH3rTGF
	 N9CtRUIOqssm47/xNL3vOfqwll1NQPWSaNY3Fc6Y80QCDrAqqIW4txwjbaUoMbPGvN
	 WvA32gRJYIsIA==
Date: Fri, 6 Nov 2026 14:13:45 +0100
From: Christian Brauner <brauner@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Hallgrimur H. Gunnarsson" <halg@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jan Kara <jack@suse.cz>, 
	James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	containers@lists.linux.dev, netdev@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
Message-ID: <20261106-befreien-addieren-eislauf-e09212803534@brauner>
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
In-Reply-To: <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>

On Wed, Oct 28, 2026 at 03:56:11PM -0700, Andy Lutomirski wrote:
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

We've had this idea in the past and I think it is reasonable. I had
always thought that we should expose a system call to create empty
namespaces ot any type. Usually I'd be excited about that but I think
that point is a bit moot and I'd really like see whether we can turn
cells (or whatever other name) into a first class api.

The problem I have with the patchset as written is that adds a lot of
moving parts. And yes, I find the CLONE_* and UNSHARE_* flags plus
sysctl to be suboptimal as well.

So the TL;DR is that CAP_NET_ADMIN + userns =
CAP_NET_PRIVILEGE_ESCALATION 10+ years later. And this patchset wants to
put it back on a leash.

So why isn't an aggressively stupid solution to this problem to split a
new capability out of CAP_NET_ADMIN so it covers the absolute minimal
set of things that should be allowed instead of doing effectively the
same thing but split over multiple apis?

Anything that is reasonably advanced should not be the kernel's
responsibility to delegate. I really think the old privilege model where
the kernel grants control over a whole subsystem is inherently flawed
and is much better replaced if you have the means to let userspace
services grant and delegate resources.
