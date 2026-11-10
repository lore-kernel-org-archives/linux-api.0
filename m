Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794324696;
	b=2F/y47nzVuKfK6u+0XD+uwyOJDuiv6OvSwXgvasHuNBEkJALc1JoQunUAC33+iv7un1d
	 5oFHXNLghw2wVrk9q5RtjYBLv/PEtgEh0PXHQMbGMn3u4V/W5fkUIGD98V3t49vRmTSiw
	 GVsI13DQgxC33wk2Y8fVxV9HUm3yItahC+QsVg3gD4lftoxWcFY4sh9lUpzvLduUJSTnh
	 rr9k9OCqWrK1dMCZg4eL5CWWblIprp90OVxjJE0NQq9sDw3zfMo4hohWUTnBca7lrqgxA
	 yay+m2efT9j8vYgdne4TurABVN1m65LhscFdcRLw3A61D0RMuTpjX3cwxaCKuTwcqrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794324696;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=SJjtzkP+sBHxUstFA6XSyOLuoy/E3cjaVl7XAdp7TZ4=;
	b=3uU2VXN6yQ5aMqn8fFidJsPwDKoX8pMvK29T7/u3IEkyuuJfLs9OfGACfZDcEHs+zqMg
	 ZbWQCg/Fb0oer0/FZTHgI9GnADWf2BbRvF4NDBl+nvbPbD1vCH3scvszoxjBjDMnooi42
	 Epf3mdSHLnloOLFMDPwC9a9EZite4i1Em20QiO8yTB3cV1WO6jf7LOt4wn1b8fuh5/Ds2
	 HIy12kk7utKCeQqpwiTCkcwHdsiey+g+Yzxh8h8lp2SB+pAraS5Ui+vQHqI7HFlTZe/Y/
	 Zn2wNO4zK6gYuUBCUoSTbSsQV8sWNY7y00cb0vJ/bLHRCAQIBSDZP4fjrtfpOyBi1lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EbaSWAnJ;
	arc=none smtp.remote-ip=209.85.208.71
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A6B606A32A
	for <linux-api@vger.kernel.org>; Tue, 10 Nov 2026 15:31:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89A6B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EbaSWAnJ
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b3f840cb9cso2626399a12.1
        for <linux-api@vger.kernel.org>; Tue, 10 Nov 2026 07:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794324695; x=1794929495; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SJjtzkP+sBHxUstFA6XSyOLuoy/E3cjaVl7XAdp7TZ4=;
        b=EbaSWAnJ7A533qGpAvii2NS3I9zxkDKlvnsqDPtzIBKMTuzOPF5jRLHhwfsyK6diIL
         2En3fr/6Wz2Zy14HVjG0BjTT6HzN+p6NPYlr8unPhlA6m2umktQnoqp2AYSjldSAJssk
         xHzbOcqVaFfuuKFkgO7UgDfRrsaoBkRPDiUM6rHPYGDOR3M31dOOpz5vbhmi2t4d+DUT
         jeFEACxiutXh0J7ifsM5tXZOXkDouo9+ARx8MVQmgZYMid1HxFVWY6jc0+kGfKGLmr9K
         dwtVL5ln+2ptHee8NSHeS1SxVprCYBr2xvsLYm8F3UiIKYeFqvbgvqwm4UzA816ruQV6
         HNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794324695; x=1794929495;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SJjtzkP+sBHxUstFA6XSyOLuoy/E3cjaVl7XAdp7TZ4=;
        b=i0PuVKmmT0bbFZ2/TLFO9/xcPvma32h+KDKSYpU0PfQKDG28CAEoycLtE9hK05HD9e
         FsOW0cL1uno0zrDi+hRCCnAndHfJlQY0K3kSVWR9asD8oQraz0UY597+pP/s3/72FlBl
         +zh20xxesh6jb7gTcifnsMntiKIT/+3VoIRdT8oWNWVs12zfGKrKs4h2BDEm8T3PaBcj
         vjhIRrmsjRRnBksCRPt/YgfqwUFnMeWZqXQ2CJeVOWg9kKpFH2r7OsPVijUQeDUdsMlB
         CKx5az9zgBGGZpKVMbWp9L2mOt+LRipMAbpq1BHQ1tZ3zTndBelOnkzTE4PXS5+csjP2
         q+bA==
X-Forwarded-Encrypted: i=1; AL+hErH8OyHh+QDDaNLT2wEwzhk+T0un2v/oHScon6xYRTjLOSRGHP7z8axF7klN5iQUMQ7VdY4nyh0HZeo=@vger.kernel.org
X-Gm-Message-State: APuU4Z/U/9HWxkx7GPzFzYxyXaVmPRAl89ixu/ZZGpqQcOe00UigSGW0
	lVNiiTaHFuUfRja5jDVxxGsWVpR5F/QZzjseVkl4x6jJBlngzD+Y6ZY/fm6CAmchAt9CoFrDVg=
	=
X-Received: from edsw12.prod.google.com ([2002:aa7:da4c:0:b0:6b7:834:31d9])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:68a:b0:6b7:675e:7a2f
 with SMTP id 4fb4d7f45d1cf-6b7675e7a95mr879624a12.1.1794324694693; Tue, 10
 Nov 2026 07:31:34 -0800 (PST)
Date: Tue, 10 Nov 2026 15:31:33 +0000
In-Reply-To: <CALCETrWa1SBLcb5oWjqjgzZvKvCoHjmYFk=Lf5ytEM9uqm5jYA@mail.gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028221705.3915340-1-halg@google.com> <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>
 <20261106-befreien-addieren-eislauf-e09212803534@brauner> <CALCETrWa1SBLcb5oWjqjgzZvKvCoHjmYFk=Lf5ytEM9uqm5jYA@mail.gmail.com>
Message-ID: <avM41a80aig2de-R@google.com>
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jan Kara <jack@suse.cz>, 
	James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-api@vger.kernel.org, containers@lists.linux.dev, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 07, 2026 at 10:47:41AM -0800, Andy Lutomirski wrote:
> On Fri, Nov 6, 2026 at 5:13=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
> >
> > On Wed, Oct 28, 2026 at 03:56:11PM -0700, Andy Lutomirski wrote:
> > > The whole unshare/clone flag situation is getting out of hand, IMO.
> > > And this new thing makes logical sense but is really about reducing
> > > exposure.
> > >
> > > Perhaps we should instead have a small list associated with a userns
> > > (extensible in the future) of things that the ns's admin (i.e. whoeve=
r
> > > has CAP_SYS_ADMIN relative to the ns) may do.  That list could
> > > include:
> > >
> > > - Create loopback with sensible defaults for ipv4 and/or ipv6 (i see
> > > no obvious reason to separate them)
> > > - Create tun/tap interfaces in that ns (and attach them, etc)
> > >
> > > And add a very simple new API to do these things.  Actually, the
> >
> > We've had this idea in the past and I think it is reasonable. I had
> > always thought that we should expose a system call to create empty
> > namespaces ot any type. Usually I'd be excited about that but I think
> > that point is a bit moot and I'd really like see whether we can turn
> > cells (or whatever other name) into a first class api.
> >
> > The problem I have with the patchset as written is that adds a lot of
> > moving parts. And yes, I find the CLONE_* and UNSHARE_* flags plus
> > sysctl to be suboptimal as well.
> >
> > So the TL;DR is that CAP_NET_ADMIN + userns =3D
> > CAP_NET_PRIVILEGE_ESCALATION 10+ years later. And this patchset wants t=
o
> > put it back on a leash.
> >
> > So why isn't an aggressively stupid solution to this problem to split a
> > new capability out of CAP_NET_ADMIN so it covers the absolute minimal
> > set of things that should be allowed instead of doing effectively the
> > same thing but split over multiple apis?
>=20
> Because we don't actually have a clean way to make a list of
> privileges that are, in theory, harmless but are hazardous from an
> attack surface perspective and assign them only to tasks that ought to
> have them.

Exactly. Furthermore, even if we split a minimal capability out of
CAP_NET_ADMIN, create_user_ns() still grants CAP_FULL_SET to new
unprivileged user namespaces by default. Without a mechanism to
withhold capabilities that are namespaced in scope but carry high
attack surface risk (like CAP_NET_ADMIN and CAP_NET_RAW) and only
selectively grant them to tasks that really need them, an unprivileged
userns would still receive the full set of capabilities.

Providing that mechanism is the core goal of the per-userns capability
bounding set in this series. Even on its own, without any loopback
changes, it can be configured to prevent unprivileged users from acquiring
CAP_NET_ADMIN and CAP_NET_RAW when creating a new userns + netns, while
still supporting sandboxes that use a completely disconnected netns or
containers whose networking is configured externally.

Finding a solution for loopback simply makes this bounding set more
practical, as it allows us to also support sandboxes that rely on
localhost networking without forcing them to retain full CAP_NET_ADMIN.

With a way to withhold CAP_NET_ADMIN from unprivileged userns, splitting
out a minimal capability (as Christian suggests) is a very appealing way
to handle the allowed subset for loopback, though the main challenge is
defining a scope that justifies a capability bit without re-introducing
LPE risk.

Looking at the CAP_NET_ADMIN LPEs from Google's kernelCTF, most are
concentrated in netfilter and tc, with a smaller number in virtual
interfaces and routing. Simply bringing up loopback at netns init
shouldn't carry any LPE risk, but something like CAP_NET_LOOPBACK_UP
is obviously too specific to warrant a capability bit. Conversely,
broadening it into something like CAP_NET_IFCONFIG (allowing link state,
L3 address and basic route configuration on existing interfaces) might
justify a bit, but even such a basic subset would still re-introduce
some LPE risk (see e.g. CVE-2026-53259 / commit f723ccaff2fb),
although it would drastically reduce the risk by excluding the most
high-risk components.

Furthermore, I think splitting out a smaller CAP_NET_ADMIN would also
run into some practical difficulties when it comes to clean enforcement
in rtnetlink. Currently, rtnetlink_rcv_msg() relies on a coarse
CAP_NET_ADMIN check at the beginning before any complex message parsing
occurs. To support more fine-grained capabilities, we would have to push
these checks much deeper into the stack, spreading security checks
across many locations, which could easily lead to mistakes.

Given this, I was hoping to have a minimal mechanism to just allow
bringing up loopback without going for a new capability bit. Ultimately,
it's a pragmatic judgment call. Maybe something like CAP_NET_IFCONFIG
offers enough value and risk reduction to be worth the trade-off.

Otherwise, if we want to avoid consuming a capability bit just for
loopback, we could also consider other alternatives, e.g. a small nsfs
ioctl on the netns fd (e.g. NS_NET_LOOPBACK_UP). This would align with
Andy's earlier suggestion of adding a "very simple new API" dedicated
to these safely scoped operations.

If we drop CLONE_NEWNET_LOOPBACK / UNSHARE_NEWNET_LOOPBACK from this
series and handle loopback separately, do you think the per-userns
bounding set is a reasonable approach for withholding capabilities
(e.g. CAP_NET_ADMIN and CAP_NET_RAW) from unprivileged userns, or
would you prefer a different mechanism?

I think the single-deep case we were discussing on the other thread
could also be cleanly built on top of this. The per-userns bounding
set provides the underlying enforcement mechanism. How we configure
and trigger that bounding, whether via sysctl and clone3() as proposed
in this series, or via a per-task securebit to handle single-deep
containers in init_user_ns as discussed on the other thread, is a
policy control interface decision that can feed directly into the
same mechanism.

To address the concern about the number of moving parts, I am also
happy to simplify the control interfaces. If we decide a per-task
securebit is the cleanest way to drive this configuration for both
single-deep and nested cases, we could focus on that and drop the
clone3() and sysctl from this series entirely, or only expose whatever
subset you prefer.

Thanks!

