Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016812;
	b=Z/vYluohUtTsU8xGhXqOK+zQotJmtNVqgU2JEsu55Jq3BnPae5vUb3UEfc6l6eVeLIbf
	 U/auHycZlra4ifpQGYVj2XZAnCcy6emXQ7s3vBATyVppTIeaFb99mepuWnJUgv9FuNPz5
	 r7ddIE0vHT9Qcjioj98HkHuqKkwgqGsji98C1Dch3cR6yrARN2EYBJWXiK6jqFbL3BShc
	 f7ZgFbaZ7Mfwo67xHt3NHtA1Yyg8rGFflp+p/14tSN9253FpnT2bGAtWfn3tJ2TQCdUEq
	 8lRB+mQHCjW0s3/gFakgNR4e6Nri/M2uVGrNZQXOGwndgk9UXFrR7exp2ZGaLKHzPig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016812;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Yq7h0/bdeIgVdHwxIZvW/WAXXX6JzsrZsXwYUvWhQj0=;
	b=fxhYMp9UiYaIGa8vFU5irIrWJ0qhU/a8BQnfVVeHHFXj4TttxtbaHobjQjo1LIvHsRHb
	 HElqFz1Ea6UY0aqiwhAFaSdx5KHaUHX936/eXHqxRDsgaujWlhMcorfNiQRsipoatucan
	 1Q65QGKuriMj3ebt9gpmfLYufeQaw85yKd3kilT8SI4lmdvPEGUOa6Wk00tpOuTv+Hsuk
	 CPups4KleZpSW194dFDbiss/BWoLSTCQCF/Iw2ueypFm4ED2scQDNxnbsDRrhETmOyWZT
	 +Opgc1tFupda60jzz3Efzsnook5IncivoDrvKLnTPINrGNvHusn3DE9F8WNDd7c2obg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EXUa+MkZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EF371606A325;
	Wed, 18 Nov 2026 15:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EXUa+MkZ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD8611F000C4;
	Wed, 18 Nov 2026 15:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795016811;
	bh=Yq7h0/bdeIgVdHwxIZvW/WAXXX6JzsrZsXwYUvWhQj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EXUa+MkZ8fF06bmTmwLNd20zxEY9MBiiXX3/inLnec+f3eiqv7AFpfp0RH1t8WMYg
	 07CRxJbvqQzFs79L2fxYmiB+GR4+a2juvf3E/xr2joNJED6DqFsGIRBDrb6+B2ex4E
	 sg6324IqU/NJun40bRWU9DIoQ3Mo45I4I9aqgNnl26gSlTAwOU2rfIBT3J7mwlm413
	 UJVrWzSWKUooQDs+lkwH4rZclpp4/PrgxpZq4RUvzVBa9Zs21JNDTqT58QxIZiaVTm
	 FXz1sMD+7Og8a/cFS0ljKI59wReWg936/UQp9l6X3OLAdeUDi4zCHOdxxm9cSZA5GW
	 Ra3dfEdI9ZjQg==
Date: Wed, 18 Nov 2026 17:46:47 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>,
	alex@amutable.com
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <av3IZ_ZXKJWHdAl0@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <wdwc3b5edgtgvrgqfhlzhrachr5hrqb7ahipcuqdz5pffxlc5b@662cpwhxwjer>
 <av3EBpSuzn_TcrDk@kernel.org>
 <av3Gv3MwP40bqvnG@kernel.org>
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
In-Reply-To: <av3Gv3MwP40bqvnG@kernel.org>

On Wed, Nov 18, 2026 at 05:39:47PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 05:28:10PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 18, 2026 at 02:47:34PM +0000, Josef Bacik wrote:
> > > On Wed, Nov 18, 2026 at 01:13:39AM +0200, Jarkko Sakkinen wrote:
> > > > OVERVIEW
> > > > ========
> > > > 
> > > > A root namespace (rootns) is a kernel object backed by a file descriptor
> > > > that binds together:
> > > > 
> > > > 1. A full or partial set of detached namespaces.
> > > > 2. A dedicated PID namespace for spawning processes into, signaling
> > > >    members, and polling or waiting on PID 1 exit.
> > > > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
> > > >    populated before going live, without inheriting host mount-tree
> > > >    ancestors.
> > > 
> > > This is what cells is doing https://lwn.net/Articles/1102593/, you may
> > > want to take a look at that work. Christian, Lennart, Alex, myself
> > > and others are working towards this in a more wholistic way. There's a
> > > lot more that goes into this outside of just the object itself. I've got
> > > my version deployed inside Anthropic for securing containers and I've
> > > tripped over a lot of pre-work that needs to come because we can tackle
> > > this. Alex has my rough outline for kuid64 for example, which is
> > > necessary for making sure we don't overlap UID's on the system and
> > > create holes this way. The cells work/anything that wants to have clear
> > > security boundaries is going to require that as a pre-requisite. If
> > > you'd like I can include you in our planning so we can get something
> > > that will solve all of our problems. Thanks,
> > > 
> > > Josef
> > 
> > No it's not doing the same, and this why I sent the patch set.
> > 
> > I don't see cells fighting with rootns and given that rootns has a small
> > surface and it leverages already battle-tested code, instead of
> > reinventing the wheel, it also has benefits. It neither doubles the
> > number of container frameworks in kernel.
> > 
> > What I'm not claiming is that this is better. I just wanted to fact
> > correct "this is what cells is doing". It is not true. It could be
> > better solution but still that statement is untrue.
> 
> For better or worse, cells does a lot more; just looking at the patch set
> size.
> 
> For rootns one can point out with a finger its possible problems BUT here's
> the thing: it does not haven unknown unknowns. Even if cells had less
> of known problems; we have zero idea what will come up if that ever
> lands. The possible consequence have less predictability.
> 
> Also, as per integration, they actually are not fighting features, as
> they are in different layers. There's no same thing at all.
> 

Yeah, and there is no obvious causality either that would result a
zero sum game. Rootns is something OCI runtime, any of them, can
quickly adapt to the existing framework. Cells takes longer, but
could be very worth of price. It's called "defense in depth".

Br, Jarkko
