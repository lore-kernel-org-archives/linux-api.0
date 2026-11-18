Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015690;
	b=izEW8C/taY1zT65mgGT/bAEhu3dOzj6Ih5kh/qv9A+CBg37UL5Oe2Og0L2ZQT0IfOt42
	 +FBsknKf6HTTLlFzic41aooZuztu0uMmeXHL/rtUcjIupTPj8xdHyTqicS8zFjbBCbDK7
	 wxQAtoJg6vH+kxQ5DOMDGSmuNTa0XL4+DTg7Bu7kJm6tSsunsMZ+ZBDUYk9gwOBZvRiPk
	 a30JG9gWlj7hNioDlOkkHsVJ35ZVrdheR4IUAoorFSO4Ua1zu4VIj9v7D/YTnyU0hrdlT
	 d5dyFFSndDuW7IoKynh4XcBzkzViqPhWmdjela495DD/kDp3mL2Xfa6+UpuAx/2fe5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015690;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WAGnVdZX/dnwB/YL80FuMYmEILyT33bR88HdQuYKvtU=;
	b=oCKlVrOjWZVmfreREw/SGKM4qjqW4APoGqedUSOh0RUJM7e8Ka3aifbPCi1ZKRJmMSa/
	 nrmkE7JAqabJRpmYISf0sepbkHCX3/pgFs4WO3uJS/VvYBM9fb24wNfnj5s6j4bFikPtw
	 +EaJ3IN4Oa7AYlGeMN5l/yUczhBlzeybZcsC1luYPvDnmOuHS8/HIyDR72raSeHHQW61P
	 m/JEXDn0FQQHGVbLTldxM0FEaTl4DPMEkgpAJQVDJ91hpPO1CLxfsu+3+SV127Ab6a1v1
	 c0CvU0SMluRMHFJP66nKu0pNzw6N1THeGAeypnWUQg0yYjZy66k2UCsoGuHEhmii/Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfWAuTIs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2D7A1606A33D;
	Wed, 18 Nov 2026 15:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfWAuTIs
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 28D621F000C6;
	Wed, 18 Nov 2026 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015689;
	bh=WAGnVdZX/dnwB/YL80FuMYmEILyT33bR88HdQuYKvtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lfWAuTIs9elqBsJl8tmIxnEDN32PGAd9hMguq1CqjQ8o/RkfsPYnbLyaCQh0JpMyp
	 fCYFUcg47M+Cd8AFwuhSGC48F6Y5cgH6aM9nlI6/evJByLvuSbtNpi1JGxi7EIwUTJ
	 OBpe67ieUMV93jPV8zcm3tdhPX5s9eusutMgiqm6kM4wKqXDNMLFHJEMZuj5NeUXxH
	 ZIfPVbs2MPGv01KSLzRUChAtf5HJHH1+2P5aDyz3rsuVFgR1gig0jWqw45i+R2qnT3
	 bQzaR2mSDre2f3gEgsLPEbuxSQhiPc4duXWEbVzw1Q34ufIovz83232MT4K4OG8WBG
	 GN+02QKGIh6MQ==
Date: Wed, 18 Nov 2026 17:28:06 +0200
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
Message-ID: <av3EBpSuzn_TcrDk@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <wdwc3b5edgtgvrgqfhlzhrachr5hrqb7ahipcuqdz5pffxlc5b@662cpwhxwjer>
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
In-Reply-To: <wdwc3b5edgtgvrgqfhlzhrachr5hrqb7ahipcuqdz5pffxlc5b@662cpwhxwjer>

On Wed, Nov 18, 2026 at 02:47:34PM +0000, Josef Bacik wrote:
> On Wed, Nov 18, 2026 at 01:13:39AM +0200, Jarkko Sakkinen wrote:
> > OVERVIEW
> > ========
> > 
> > A root namespace (rootns) is a kernel object backed by a file descriptor
> > that binds together:
> > 
> > 1. A full or partial set of detached namespaces.
> > 2. A dedicated PID namespace for spawning processes into, signaling
> >    members, and polling or waiting on PID 1 exit.
> > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
> >    populated before going live, without inheriting host mount-tree
> >    ancestors.
> 
> This is what cells is doing https://lwn.net/Articles/1102593/, you may
> want to take a look at that work. Christian, Lennart, Alex, myself
> and others are working towards this in a more wholistic way. There's a
> lot more that goes into this outside of just the object itself. I've got
> my version deployed inside Anthropic for securing containers and I've
> tripped over a lot of pre-work that needs to come because we can tackle
> this. Alex has my rough outline for kuid64 for example, which is
> necessary for making sure we don't overlap UID's on the system and
> create holes this way. The cells work/anything that wants to have clear
> security boundaries is going to require that as a pre-requisite. If
> you'd like I can include you in our planning so we can get something
> that will solve all of our problems. Thanks,
> 
> Josef

No it's not doing the same, and this why I sent the patch set.

I don't see cells fighting with rootns and given that rootns has a small
surface and it leverages already battle-tested code, instead of
reinventing the wheel, it also has benefits. It neither doubles the
number of container frameworks in kernel.

What I'm not claiming is that this is better. I just wanted to fact
correct "this is what cells is doing". It is not true. It could be
better solution but still that statement is untrue.

Br, Jarkko
