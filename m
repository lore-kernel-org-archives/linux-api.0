Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016387;
	b=jmakDu3LjE9NSRK+4ecB8GCCPY2c9vXRDY5DwczS11fo9tC8+Y8EwufnNLcl1Df+WOp4
	 6007jr6aWzQ808xKaxxNiBqY9uXcC8v58wL+WOQOYCG3in20cabE6ZVl6uczrpYDc2ayU
	 n2DAu4uvXQI87M4Ct+Xr5srw7KVKX51vNrwp2CuIcdwwemZeVXcX7fDLZUFeSoSDr3t4u
	 bHJ9gH+PZ5O2OxlDHmnAqeQHtNQ60WowZ3q4d08G6pvKgRE5hhJxc7zMMAsnrTn1rh9mn
	 tzpJWszWIbvKAompooZ9GoRaTH2PEugJQauxUgPiTz0Way0sF+JpcjOoZCU5uypHiMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016387;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+05d7QYBTtK1JZ1EQU9jtzeT6f65KemfkCy86aAw/hc=;
	b=4jUjy5dyG8au6xmjXGt9Z03mzRyIO43UgUcAnhGbQMJijy+viTCeakrEHc279JrjsZ4y
	 Uljy1LLdDvTuyw/fGHstROjYJ3Z23v0sdqE0NWhE7TGnNA1kuf3mcABPbR/bNRikh5+dX
	 CfkyI0iZodhX8jL+5aaGO85HHVATXi6xHNpMYpyDQeIe79wzw2imkKaIbaV9jwhcqf9RC
	 X0w9X57VgP2o8Q5hf6kEvN8j73G9tHiwQcB5giERYR4Qn3wqS53+2hzt/qnPaix2H+en2
	 bC28sMHZ/f1Ehxs8OcvaA4PwygsZezoFzxfPEXJL8ApwcSaByM30D7Tuh6RDjFNbJyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QL9BK19y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 87EE360A3804;
	Wed, 18 Nov 2026 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QL9BK19y
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A1F7F1F000C8;
	Wed, 18 Nov 2026 15:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795016387;
	bh=+05d7QYBTtK1JZ1EQU9jtzeT6f65KemfkCy86aAw/hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QL9BK19yEFO48QBM8Oed0W9oi92dO17PMdCUfI4Ave2mN8VCby8UeUADTDtlBlnhl
	 8956S5U32BRlMxLcxEy6IAMqj9bT2tV2nflNwCBhCavrWkNEoQkheI2gLQvRKTpI8D
	 OZYSUCXLOErgiBwyPwpylot9xQFP/t/vCgNg8r4flgC0gqU4eMWbyhVsOGh1EyDmdT
	 AturQVWjzfd6JHA+/q4WxYoguSu3eaa6rEnmd+YHCgTTQhv/n26rd7Wd7ZKXXpuZ4A
	 bPwYGWM6BkAgAblBCTxgHP1gaY/o5KKvkEmIc2++SxtdNNn83/E5nsgC10+wJUhAdr
	 VrrU/x5wTXzoQ==
Date: Wed, 18 Nov 2026 17:39:43 +0200
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
Message-ID: <av3Gv3MwP40bqvnG@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <wdwc3b5edgtgvrgqfhlzhrachr5hrqb7ahipcuqdz5pffxlc5b@662cpwhxwjer>
 <av3EBpSuzn_TcrDk@kernel.org>
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
In-Reply-To: <av3EBpSuzn_TcrDk@kernel.org>

On Wed, Nov 18, 2026 at 05:28:10PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 02:47:34PM +0000, Josef Bacik wrote:
> > On Wed, Nov 18, 2026 at 01:13:39AM +0200, Jarkko Sakkinen wrote:
> > > OVERVIEW
> > > ========
> > > 
> > > A root namespace (rootns) is a kernel object backed by a file descriptor
> > > that binds together:
> > > 
> > > 1. A full or partial set of detached namespaces.
> > > 2. A dedicated PID namespace for spawning processes into, signaling
> > >    members, and polling or waiting on PID 1 exit.
> > > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
> > >    populated before going live, without inheriting host mount-tree
> > >    ancestors.
> > 
> > This is what cells is doing https://lwn.net/Articles/1102593/, you may
> > want to take a look at that work. Christian, Lennart, Alex, myself
> > and others are working towards this in a more wholistic way. There's a
> > lot more that goes into this outside of just the object itself. I've got
> > my version deployed inside Anthropic for securing containers and I've
> > tripped over a lot of pre-work that needs to come because we can tackle
> > this. Alex has my rough outline for kuid64 for example, which is
> > necessary for making sure we don't overlap UID's on the system and
> > create holes this way. The cells work/anything that wants to have clear
> > security boundaries is going to require that as a pre-requisite. If
> > you'd like I can include you in our planning so we can get something
> > that will solve all of our problems. Thanks,
> > 
> > Josef
> 
> No it's not doing the same, and this why I sent the patch set.
> 
> I don't see cells fighting with rootns and given that rootns has a small
> surface and it leverages already battle-tested code, instead of
> reinventing the wheel, it also has benefits. It neither doubles the
> number of container frameworks in kernel.
> 
> What I'm not claiming is that this is better. I just wanted to fact
> correct "this is what cells is doing". It is not true. It could be
> better solution but still that statement is untrue.

For better or worse, cells does a lot more; just looking at the patch set
size.

For rootns one can point out with a finger its possible problems BUT here's
the thing: it does not haven unknown unknowns. Even if cells had less
of known problems; we have zero idea what will come up if that ever
lands. The possible consequence have less predictability.

Also, as per integration, they actually are not fighting features, as
they are in different layers. There's no same thing at all.


Br, Jarkko
