Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021461;
	b=cz2P0/Txlf2GfPtGl39+CsdCpR4Z6oo4XZwVS+jhUiDcvkbeAe0y5bMFiHxXTAiPoc5f
	 chr88ewhMcfy96KoAOcRvX4mNgHNlqZCqlgH5Fii7ZdPHNBJFsOQ04soikUMp9AKzN/oI
	 hBbrGmS6J8je+BvFWMVp3amTCq7y9jrIsdVBPaP+86k4bIpNKC6mZRMXIJtrUL1FA4ZJs
	 Jct7qUD5w4UjvI+xb0GZAlMzk5J01Hpu5Hw+0yYAXkAPwk7A3nVEV4il6hXjBWdmToGqy
	 FKMnggfz2bVDFq9fRNu3mmT6/hRW49/xYgqWHoIeBOI6yUBGkSkY0fQXWcz17Uhd0zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021461;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=Hn/h1bRzbBm5D3N53UiS46oHXc8DeYJZVEs6ylWsGuM=;
	b=ZkIwi4PkGGKU/smnwiVCfRiVsfFtnTcGRPGUoV2vT0brBOH/YHsSrvlBMLsbDiNXrTf1
	 mOr2rMCWU9mRxX29MWt9rn41fs42e5M2PR32VqKfCyVVrYDMB1Rks/exvy18OwByRiaSB
	 cWDwUoINMrHikiq7vRboVQakmv+Umlbkmh8/+c36TneG0w7zeR2QR4UHqq46vriRWk3N3
	 /gQSERmRmIpbo2gKck+n1joTeqE5ieAG2PhZG2m/fuoJzYHskRnmD1Z1kUSR4R7uw+rY6
	 EEceZHyOXrPUBTWuwriqA/Yvtn8fVfS+a8ukcY1yQFPXWHkwCtfKUao8n7NwRAJ0bhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gRdhtVPR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A20DA60A3811;
	Wed, 18 Nov 2026 17:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gRdhtVPR
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B9B401F000C6;
	Wed, 18 Nov 2026 17:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795021461;
	bh=Hn/h1bRzbBm5D3N53UiS46oHXc8DeYJZVEs6ylWsGuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gRdhtVPRVGpWi7iegmc9niJiev9/dezHn8c46qqykKLiB9HRwZZzGoHpH1vyXv2KW
	 WFMn4B83h6Gbp8NrCYOounPjZeu44Vsk90yF7oCuvfSeoxCz+waTCkalOLGF+SWHWW
	 PiZ/vuDcyF2asBN+6a0Zoq9n6AenEf1JpvjbIDqdtDcITPLZ0ntxQARKal2cwpCd8M
	 uWfRzMzyXcBAErCbYnj7156qfhH4uPAv5yDtMjXycJxYWAAtl2wkCzmORf+I4Fb1v0
	 F9yGOFTnVyWDiF1irHNxmq0Znq85hxojQ1sH1hokHi8fYRnupxH1MmQt6M7ItYPqb6
	 g0SKocHpDEQ/w==
Date: Wed, 18 Nov 2026 19:04:17 +0200
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
Message-ID: <av3akYFOYaeQZauZ@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
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
In-Reply-To: <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>

On Wed, Nov 18, 2026 at 08:59:39AM -0800, Andy Lutomirski wrote:
> On Tue, Nov 17, 2026 at 3:14 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
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
> >
> > Work on this feature started in 2025 from David Howells' container object
> > patch set [1], which I turned into a namespace for namespace roots and
> > rebuilt around that premise.
> >
> > While the patch set is manually written, the original motivation came
> > from isolating LLM agents. Running untrusted agent workloads made it
> > clear that OCI runtimes need to minimize their live configuration
> > surface.
> >
> > Assembling mounts, credentials, and namespaces inside helper processes
> > with a half-configured container is what I see as the main challenge,
> > and the existential debate around namespaces and container objects is an
> > unfocused discussion topic.
> 
> 
> I've skimmed some of the series, and I see a bunch of good ideas that
> involve using an fd to manage a thing.  But I'm wondering how much of
> the value is added by that and how much is added by having a new
> *type* of thing: the "rootns".
> 
> How much of the value comes from the rootns vs the new APIs to
> configure namespaces without entering them first?
> 
> For that matter, the cells series also seems to contain a (possibly
> very similar) variant of the same thing.
> 
> Would it make sense to come up with a patchset that does *just* the
> configure-a-namespace-by-fd part?  It seems to me that this should be
> an easier thing to agree on, and it's a big part of the complexity of
> all of this, and it solves a real problem even without
> cells/rootnses/jails/whatever.

Is it  more accurately scope the part that is "just the fd-part" and
what you consider as "extra cruft"?

I.e., where do you draw the border?

> 
> --Andy

Br, Jarkko
