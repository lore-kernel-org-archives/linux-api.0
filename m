Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410412;
	b=gKAPmIAPdEbsZFsmZ9RrGjXE6SujuQSJOuhRC7LqcErh6w+LpWgzPqQlMVTF4ka702SG
	 07ayTyAGJLuhUOH4uz8dMiWNj+NKmHdY2jNhS3uy4uGO6ufHPx04lZY4niSv9OMfh8wfY
	 PzNxqSBNhqfIwUeOrA9bmjFGZ8fDTWAqtEdN/G0K/OYgRhes5QnBUKib9rV6Zy+saGZXQ
	 KWKX0GRu0sETHkHMhdrWAbX3QtzMGdvi4VUyTn/Q7s660ZBWOrdl11ZNXRXSHFGveeTAV
	 d0c9fB1GTKqbF0+CGcDBcuizuU36wQDp+DzWDJYC5i0KFuqYc/Aq6EXryQINmu2lcKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410412;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+1DCBycizs0FNS95ffvn0ICcr0Hnn6SqaXL7oQg/o08=;
	b=iB7046F2DBRObIsYNVhXAkFjfDTUb5lJWit6Lg7rNEtK2uUV1aAIG/42UN94ex4IIgH6
	 k1uNL9x6+JJJLRqB+0sDKvqrGXYrJlyO2bvImh0ZiHichJ3EdTq8HXD0LqYBKCDLlIOFE
	 LNcq0tTW38RPJxLoFMQH5TPnVb/1dvULlZMeV3WGR9qkXC4xWS8tZZxagNFria8fEv9F5
	 rtqhr5dRDHvZ8UWfROjxQye7k8ALnQVR0x2ytO1Op0zcOFtZrXBv58eynuSGJVNPX3eXx
	 2zBMOtuKCCIIJaa4Uz9zJvwsg+UnRedXtvAOqpznF3E1k8i7isebb0j4/G+mMYKNaEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=InhjEDQu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200EF606A326;
	Wed, 11 Nov 2026 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=InhjEDQu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDF61F00A06;
	Wed, 11 Nov 2026 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794410411;
	bh=+1DCBycizs0FNS95ffvn0ICcr0Hnn6SqaXL7oQg/o08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=InhjEDQuH1m2P9kFzlDGdbDOOuWxtH0LsXmXH060/PyJ7WeBfoqIXupaRw9R0UyRz
	 ra9dv2xEUke2U+I3d5CM7krrKBbqMuElQStXbHoIUKtNATdV4Ckf5+rTZL+XDSuAko
	 oEOBdaI0eXTQWfCH/2NUq4fLFNjx82m6IvjtXAO6wg7XcUHQ3T9FNre8K/WW8iecVy
	 S5DARJ2l3aca1RkWHb6FD0SSQHfP2kPwWC+hH/lsvICBfFdzPav72dQL8z5zPN6ozW
	 pLfxplSiET47nbs7gxpot8ejl0R1XQCUGMB6KTd/ucQ7CwA7TK09HSCG2CkgLOfso8
	 bXuRslVF6fzSQ==
Date: Wed, 11 Nov 2026 16:20:02 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Hallgrimur H. Gunnarsson" <halg@google.com>, 
	Andy Lutomirski <luto@amacapital.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
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
Message-ID: <20261111-behagen-faktisch-entgegen-e2e714373895@brauner>
References: <20261028221705.3915340-1-halg@google.com>
 <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>
 <20261106-befreien-addieren-eislauf-e09212803534@brauner>
 <CALCETrWa1SBLcb5oWjqjgzZvKvCoHjmYFk=Lf5ytEM9uqm5jYA@mail.gmail.com>
 <avM41a80aig2de-R@google.com>
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
In-Reply-To: <avM41a80aig2de-R@google.com>

On Tue, Nov 10, 2026 at 03:31:33PM +0000, Hallgrimur H. Gunnarsson wrote:
> If we drop CLONE_NEWNET_LOOPBACK / UNSHARE_NEWNET_LOOPBACK from this
> series and handle loopback separately, do you think the per-userns
> bounding set is a reasonable approach for withholding capabilities
> (e.g. CAP_NET_ADMIN and CAP_NET_RAW) from unprivileged userns, or
> would you prefer a different mechanism?

Seems ok to me.

> To address the concern about the number of moving parts, I am also
> happy to simplify the control interfaces. If we decide a per-task
> securebit is the cleanest way to drive this configuration for both
> single-deep and nested cases, we could focus on that and drop the
> clone3() and sysctl from this series entirely, or only expose whatever
> subset you prefer.

Just a note on the essay I cut off. I really object to any arguments
that amount to "it's too much work" propped up by a few thin arguments
sprinkled in such as rtnetlink.

I also reject any arguments that amount to underscoping and overscoping
of the new capability. The scope is clear: empty netns with brought up
loop device.

I'm 180 patches deep into fixing procfs and 41 patches deep into
preventing loop devices from abuse. Either we do the work and get
something better or we do the same thing we've always done and hope we
end up happily ever after.

But again, I'm more focussed on cells so here's what I find acceptable:

I'd rather go back to what Jonathan proposed in 2024 (cf. [1]). A
per-task userns capability mask. Serge acked the core of it back
then. It's at least generic and not just the single securebit capability
thing. And we'd burn a new bit for every capability that turns out to be
a problem later.

Jonathan's version had holes though. The restriction only lived in the
task's creds so the owner rule and setns() blew this up. So it needs to
be combined with your per-namespace set. Roughly:

* every task carries a mask, cred->cap_userns, full by default
  fork, exec, setuid and entering a namespace never change it
* a new user namespace records

        ns->cap_bset = parent->cap_bset &
                       (cred->cap_userns | cred->cap_permitted);

  once at creation and never changes it again => it's monotonic downwards
* the creator gets ns->cap_bset instead of CAP_FULL_SET
* a task that setns()es in later gets
  ns->cap_bset & (cred->cap_userns | cred->cap_permitted)
* the owner rule in cap_capable_helper() grants exactly what entering
  would and otherwise falls through to what the owner has

So caps a task actually has always count as allowed
=> should check Andy's "only restrict creators that don't have
   CAP_NET_ADMIN themselves" per capability.

   This amounts to a host-wide default without a sysctl.
   PID 1 drops CAP_NET_ADMIN and CAP_NET_RAW from its own mask at boot
   and everything inherits that.

   Root, sudo and setuid-root binaries have those capabilities so
   nothing changes for them. A regular user doesn't and so their user
   namespaces come without CAP_NET_ADMIN and CAP_NET_RAW.

   This also covers newgrp, su and sudo -u shells which is where
   resetting the mask on setuid exec (Which was raised by Serge in the
   other thread.).

* Root in a container has caps as well so for containers the exemption
  would be wrong.

  So here we need a a lockable SECURE_NO_USERNS_CAP_RAISE bit thingy.
  This turns off the exemption and prevents raising the mask.

  Docker lowers the mask, sets and locks the bit, and
  unshare(CLONE_NEWUSER) in the container doesn't hand out CAP_NET_ADMIN
  anymore.
  
  => no parent user namespace needed for the single-nesting case.

  So a container with CAP_NET_ADMIN lowers its mask before it spawns the
  nested container => should cover your (3) case.

uAPI is a prctl modeled on the ambient capset:
* PR_CAP_USERNS with IS_SET, RAISE, LOWER and CLEAR_ALL
* lowering needs no_new_privs or CAP_SETPCAP

=> handles sendmail-style problem Serge raised on Jonathan's series.

* a new CapUns: line in /proc/<pid>/status
* new audit mask in AUDIT_CAPSET record

Raising needs the capability in the permitted set.

Fwiw, neither series handles ptrace. A task with a restricted mask can
attach a less restricted task of the same uid and then make it create
the namespace.

cap_ptrace_access_check() only compares permitted sets so far. So for
PTRACE_MODE_ATTACH the tracer must be able to get whatever the tracee
could get through user namespaces. A tracer that has CAP_SYS_PTRACE
in its own creds can still attach to anything. But the CAP_SYS_PTRACE
the caller gets over a user namespace just because it owns it must not
count. Otherwise a restricted task could attach to a less restricted
task inside a namespace it owns.

That gets rid of the sysctl, the clone3() field and the clone flags,
doesn't need a new capability bit, and nothing changes for anyone who
doesn't opt in, I think.

And that loopback thing should be its own series. Not as an nsfs ioctl
though. All nsfs ioctls only report namespace state and I'd like to keep
it that way.

Pipe this through an LLM and make sure it makes sense and covers all
holes.

Thoughts?

[1]: https://lore.kernel.org/all/20240609104355.442002-1-jcalmels@3xx0.net
