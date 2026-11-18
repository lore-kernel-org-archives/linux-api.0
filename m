Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023025;
	b=QhZ7jnzkJeU3CGZhg5+/lKzubMfFL/gcm/HJIA7iwwIeElCO8CWaQH4ZIcvbaPIkjkmG
	 rtyGnvZN+HEVJ15AbeyaA2roU5SOq1sBzHVdjxknfK84Ba7K5+iM3c2LttOZ3nSbwGOOK
	 fkv9HquYSSqqbAm92a7BToImadTtTMM/g7y9oL8xV1vQKY/NN35dQdgugeK3uh57Oa7mp
	 /Z6LUpmP6fC77Aa/3SVoYJ4hphbhVyUVuGcBOyPvy8vtTxjflPxW5gdSzHq+77eyowPy6
	 CBEPkZBhEZ1Ein3xG+qIbVoTi7eTiO1/HD7qptR9WSSpLQp2G5NjZKLjsSbbP3vDsSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023025;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=AXyr34eZLB1bS8MATPL8FPR/LLqo+MrnU3tB91TSYQo=;
	b=MgzHzLb4qmVeSH6oIYDt+VXlXlh5+E+0/VHmmfCdLrFu7G8sVSP26FuPYTU2199hvONs
	 df7O9zPw7nhc8sE9BlF6/c3X2CCwvlVnd1zj6oa6poCoZqjgX4Sihvlc6u/DQsoRfTgk/
	 6rbyFq7lgAM3jZDl3NvJJTEryCQO7oW52Rk4495/RX/fo0hOHdKGgXDkDbEdv6XoYqHSK
	 iflxKtzdLCnvTKY0cpBSzf1s93WdWsctjFJrK+wdXydwhP/1iDG4qfzm7SAUpQZoFGgow
	 ddmve1CY6Jz4uCbKxaSeM8W2S35jxnXkdYQnirQ3vAtNi7CUGVP3Jt1rdizkthdWAfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=djw2K2od;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E8548606A320;
	Wed, 18 Nov 2026 17:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=djw2K2od
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 142AF1F000C4;
	Wed, 18 Nov 2026 17:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795023024;
	bh=AXyr34eZLB1bS8MATPL8FPR/LLqo+MrnU3tB91TSYQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=djw2K2odyCnHPUAoZZ3QMzDgwKhcnKfCVolEDh7zqTyPwLHrWwWgrXoaKOMifxeQB
	 PgA8i2s3h5GY9GH6UgyJRCnufAKqxM+DK7OrqT6iwZZayXJSuMLirY6EZLYMetmPZP
	 xHwqm2IO9NHoInWN3XwvKTAuj4wPHcJw+Rz48D7XjH7KB1TAck71C0Awt/Oofy0Tqy
	 +TMVLuo0zS5w2qngKq6+nTM7SmxR+FenCGhNkse+bueiZMaT+cpR4UM8EMprS6IO/s
	 V9Cw1fpesTrfw+QK3tQlIs2+d5U6WxpY/Iaqw0nIvP08ZxP0ZlS9mSoa5MHbLW2qSI
	 1k7w52jwbTcvA==
Date: Wed, 18 Nov 2026 19:30:20 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: josef@toxicpanda.com, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <av3grNWlMRsZrqaq@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org>
 <av3bkDnwmjunTleX@kernel.org>
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
In-Reply-To: <av3bkDnwmjunTleX@kernel.org>

On Wed, Nov 18, 2026 at 07:08:36PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 07:04:21PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 18, 2026 at 08:59:39AM -0800, Andy Lutomirski wrote:
> > > On Tue, Nov 17, 2026 at 3:14 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > Would it make sense to come up with a patchset that does *just* the
> > > configure-a-namespace-by-fd part?  It seems to me that this should be
> > > an easier thing to agree on, and it's a big part of the complexity of
> > > all of this, and it solves a real problem even without
> > > cells/rootnses/jails/whatever.
> > 
> > Is it  more accurately scope the part that is "just the fd-part" and
> > what you consider as "extra cruft"?
> > 
> > I.e., where do you draw the border?
> 
> I'm asking this because I had similar thoughts when I started this back
> in 2025. David had some good ideas but it did more than having a fd
> that does not go live before everything is set up properly.
> 
> Then I thought that, I guess people who proactively on the topic do
> something more lean and compact, and never sent roonts patches.
> I'm not seeing anything more lean and compact.

What if "A full or partial set of detached namespaces" would be changed
into "full set of detached namespaces"?

That would simplify the patch set a lot.

By pratical means we would take this:

enum rootns_flags {
	ROOTNS_CGROUP		= 0x00000001,
	ROOTNS_UTS		= 0x00000002,
	ROOTNS_IPC		= 0x00000004,
	ROOTNS_USER		= 0x00000008,
	ROOTNS_NET		= 0x00000010,
	ROOTNS_KILL_ON_CLOSE	= 0x00000100,
	ROOTNS_CLOSE_ON_EXEC	= 0x00000200,
	ROOTNS_ALL_NAMESPACES	= 0x0000001f,
	ROOTNS_ALL_FLAGS	= 0x0000031f,
};

And outcome would be:

enum rootns_flags {
	ROOTNS_KILL_ON_CLOSE	= 0x00000001,
	ROOTNS_CLOSE_ON_EXEC	= 0x00000002,
	ROOTNS_ALL_FLAGS	= 0x00000003,
};

If I was using this I would at any time just take em all. "Partial" is
just something that I've been just carrying since probably David's
original patches i.e., it simply has not been considered that much.

Br, Jarkko
