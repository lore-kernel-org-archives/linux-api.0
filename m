Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794934160;
	b=w23blO+/ZUdfvjrzy74VAYXj281IvrJpN3RCiDDb3PXtZbDLRh2hxmQ9vZsddbwbCHsM
	 PH2vHqntXBfwYLxEfj3AOnIVtgK+eWLsu6dhsHdK8XA3ndj7xdmHOtGIpwIpOXZoAtvzq
	 OaBT/ci31k6IKVkxQtTfbAJaYk9/YnxgRx3eemDRcOlIlxkp3rT4HYbCXF9VQwlU3JA8/
	 UU63OBLQPqRjb0n+8rsSSxhaOkd8CWQCJnx4XaGzYdUEX8psQ24r8oErkvpYwyP4cQwuU
	 BPYEOrHAkIaN7AMez4RcQDRXFUSsSkwAUYPer2Qs/eb2m9S8OskkQBTvFrQCmotNfeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794934160;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Scl/VifAjlxPDoAR0t/AhiRabE59EDiCI7/IkrSw3+M=;
	b=hlvW8hUtOdCcFHxnnG/efV0iZyMTx/1kV/YPNzhjf4Q2kohU643zuDzeNXH5geZY32n1
	 fttrzGFsxZcsYMyyUQ02pl4dTFHuu6M8NFZ0sjWpSRJ8BuRrHMKffBdpFmowxLv7IrW43
	 ZMjg2ZLOEKep4suMhlPnDYPMIUeePuNrI2f7V9nlEaPkqQpl+7TBfZtKUqHEphQPEk3EP
	 JiMvnfDUMPMqWblTHq9SHmR2T6bo38IcHidYjju8UF46Hg4igqngZ7xPkkZEjFsRIsXFY
	 zrLbqQa9vcnAC5YsGavNVXdJstCc4Ghu+nUrIZnNh211wV/BMX6G8bTUxVis91h9oVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIeRJ75E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A17606A31C;
	Tue, 17 Nov 2026 16:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIeRJ75E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F431F000CB;
	Tue, 17 Nov 2026 16:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794934159;
	bh=Scl/VifAjlxPDoAR0t/AhiRabE59EDiCI7/IkrSw3+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aIeRJ75E+9ST4vOLKED9LJSC1b+MQ6CDTXIHOyZ4D9fc7EvV6clSf1nXJKIyXN3HO
	 zk8sfd0ETNlAz+2/ewTdVDDUImFZFd2CrtllN00E5B/eFnhnRNeKJ8N6SXaiOosc2N
	 wKZof/4+J3uj2rfto011U4mCJJCpxP8RWdfOITsuOsMLA3crXqexX1mSsQ0/w2M6Bp
	 LyiKPPVX+uZrrbpvaWWe92vRfBL6lf39Syd7GWv8j2iCeWBZXvkOG9hKsSuq7OiI5p
	 8MT3yswJXkDCu1RdrKuyvFEucdhYmxccv7CIOyCD9L+QizogYZbQwMcw/DCPeHAst/
	 ocY+AxXGYimnQ==
Date: Tue, 17 Nov 2026 17:49:11 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Hallgrimur H. Gunnarsson" <halg@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>, 
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
Message-ID: <20261117-grabung-sowie-symmetrie-41925e0f1b84@brauner>
References: <20261028221705.3915340-1-halg@google.com>
 <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>
 <20261106-befreien-addieren-eislauf-e09212803534@brauner>
 <CALCETrWa1SBLcb5oWjqjgzZvKvCoHjmYFk=Lf5ytEM9uqm5jYA@mail.gmail.com>
 <avM41a80aig2de-R@google.com>
 <20261111-behagen-faktisch-entgegen-e2e714373895@brauner>
 <avsymRBSulVZfouF@google.com>
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
In-Reply-To: <avsymRBSulVZfouF@google.com>

On Mon, Nov 16, 2026 at 04:43:05PM +0000, Hallgrimur H. Gunnarsson wrote:
> Quick question on AUDIT_CAPSET: today it's only emitted on capset() and
> only logs capability sets that capset() can modify (explicitly or
> implicitly like cap_ambient). It does not include cap_bset which is
> modified via prctl(). Since capset() never modifies cap_userns either,
> does it make sense to treat it like cap_bset and leave it out of
> AUDIT_CAPSET, relying on prctl auditing instead?

Fine by me as well.

> Thanks for the feedback and the detailed proposal. It looks good to me
> and nicely ties everything together. I'll prepare a V2 for review based
> on this hybrid design.

Sounds good.
