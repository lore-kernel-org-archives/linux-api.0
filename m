Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021716;
	b=FB+wv+mmD5Iiv+KTYSowvVVpd/bE7O9gMpjzE5Tjy+GsSaWK5NUk4v+s19IU6JEi5SVN
	 AT66201R7mSFeyIipqfjcV8TwxSoKDoEGiDmDjhTfJFSaqcTDNUlwstAir9XTjt/7SxOJ
	 5NFHHFD1g8GS3CI/3szQ0+pNn4CvUUWq6kv1/G1z2Lr7gOkS3tx9c/aBU/K/HtdGlFVvd
	 gsMsgdjYdCgviScTWczyGhF+o7sIKNBfvtRxLmXM6WLjmXDEe7lShaPgMrugt96Z6FHdX
	 vpKqZx7Vm+GixYfYLi/oNLEA6UzOjJ0lwkGxvlYPKo4RemIu6LnSvvkchpFQ72MLfMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021716;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=zINOi7QPXEvi98cbqP6TjwwtqfWoUArKawL5JYAavAU=;
	b=kg5HCxech1uO+62kY+Va49GwEugkM/31UGlftPXBcNj6eUyvcZ9D1V4Ae7Srt6xz4/Nw
	 g8JbI/o+V4x22PRJmZ/zxd4g2psQmvVv3ZcVL00KL7fck5JJ+Q5VrcMUmp8mu4jjKBuwA
	 9FTRwcs85/nK/FNtsYyMljcR16VMS6vQcKPlSyGZ6Bv7n35kxY+SHcBDMBmAUyIrNbTdB
	 hEmBH0fgBcOMsT4MGPdBvDOK2+nJv8mkE43m9U+iqX1lLJkmEZOv0jK11SBAqdhVYuXhV
	 H4rD/O35mM2I/jWKRquXzUMcjP+N0Kax2ZZ7DJ1+t8FilhP2dN8flkisqsUas+XHSng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ai7InkSx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CE4C8606A31C;
	Wed, 18 Nov 2026 17:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ai7InkSx
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CEC651F000C6;
	Wed, 18 Nov 2026 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795021716;
	bh=zINOi7QPXEvi98cbqP6TjwwtqfWoUArKawL5JYAavAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ai7InkSxjpjgivgeXU6eK1BzM9SMFaBHZ97FKtVTgzZrgbTvyMLm/yoQ5iDK2F15o
	 iTRkDOM5FMMC7Su4PQB1NNwWaeJVN/3Q/mYacYUCeTZRfLZiNbc0Psa/woPxI9priV
	 o794AiIxzMMqwmGdfxK1sVY51lnnoLeRxopyMxm3Fw2Wn75jZxgMjWDWGbfvJwR/F7
	 55uapbzqrx1sE6psi4VAyHUC+D/mArx5ooB7wwR90Jm3Q5Q2x2m32mx71CpDNud7Ql
	 0+EGSljYTSewzaz+DAbOKH8by3wxtDmKxsjPI2frMrPXcPdOdqYqLiNXz6oTJsS+vw
	 QjKJcR1CdMiUg==
Date: Wed, 18 Nov 2026 19:08:32 +0200
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
Message-ID: <av3bkDnwmjunTleX@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org>
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
In-Reply-To: <av3akYFOYaeQZauZ@kernel.org>

On Wed, Nov 18, 2026 at 07:04:21PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 08:59:39AM -0800, Andy Lutomirski wrote:
> > On Tue, Nov 17, 2026 at 3:14 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > >
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
> > >
> > > Work on this feature started in 2025 from David Howells' container object
> > > patch set [1], which I turned into a namespace for namespace roots and
> > > rebuilt around that premise.
> > >
> > > While the patch set is manually written, the original motivation came
> > > from isolating LLM agents. Running untrusted agent workloads made it
> > > clear that OCI runtimes need to minimize their live configuration
> > > surface.
> > >
> > > Assembling mounts, credentials, and namespaces inside helper processes
> > > with a half-configured container is what I see as the main challenge,
> > > and the existential debate around namespaces and container objects is an
> > > unfocused discussion topic.
> > 
> > 
> > I've skimmed some of the series, and I see a bunch of good ideas that
> > involve using an fd to manage a thing.  But I'm wondering how much of
> > the value is added by that and how much is added by having a new
> > *type* of thing: the "rootns".
> > 
> > How much of the value comes from the rootns vs the new APIs to
> > configure namespaces without entering them first?
> > 
> > For that matter, the cells series also seems to contain a (possibly
> > very similar) variant of the same thing.
> > 
> > Would it make sense to come up with a patchset that does *just* the
> > configure-a-namespace-by-fd part?  It seems to me that this should be
> > an easier thing to agree on, and it's a big part of the complexity of
> > all of this, and it solves a real problem even without
> > cells/rootnses/jails/whatever.
> 
> Is it  more accurately scope the part that is "just the fd-part" and
> what you consider as "extra cruft"?
> 
> I.e., where do you draw the border?

I'm asking this because I had similar thoughts when I started this back
in 2025. David had some good ideas but it did more than having a fd
that does not go live before everything is set up properly.

Then I thought that, I guess people who proactively on the topic do
something more lean and compact, and never sent roonts patches.
I'm not seeing anything more lean and compact.

> 
> > 
> > --Andy
> 
> Br, Jarkko

Br, Jarkko
