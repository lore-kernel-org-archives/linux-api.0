Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794942656;
	b=dzHuaQuaUbL/bvXSWRr9+yzcoc7F01b6KcrCSIo6iSwN8ek5DhKkplWN4uaBZhZY5H/3
	 UCH6QE+7cPSbowhgyFz9BOYM/ze9Di+xizhMKxPQUUHbaJhdq6SPxtjb4apc+OSzjiglS
	 p5HfiNk2BcyGIfjujnzb4WVjydRJXL68Q1dlCRP6miBGzcXrVPJ/AYSvoj8FOpm+3SiWr
	 LdkhgDl59JhVWDE6CH08a5KrxYPB7pCYVj4MhzKgfREAjrrLMN+MdKsPU+2lTp/zk+Gng
	 SxoQ3pRswYNOniWNsO7vvQ2n1VpnbRsjSpvJDKwHGewFXkWF1MTnbLJoVbBEeHyBd3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794942656;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=QNfr1N4SlD4nY5lF2k9NOu1qbIPKIuO18d/t7UojEjc=;
	b=h0SsOLOQJSK6FqR5bJwYggTGtW/lfnar/WIVDmGXSS9TUXGfC4y5uMAF+C24f9mMQzMV
	 AuLSSaMMgWzPY1eJjif3+Kp5GzF6hUGvnnzsLDNh5lrzM5utfmFvhcC6PpcaxP3XGHebV
	 k0GmLDEgegwZz4QGJfCgbA92qvjhnGklrcpdWQdQjB0nsUBY+QpT4WzBRyD9FX++5OJop
	 gjbKQkOoAz51XJi37+xjKynMmXWzF6NyvMN4x+VbQzan2gNQMB8Tz43SkAhPnkZUuMTpg
	 tpZoV1yqGvkJMXDBbVAnaiWv1gslBtaNyVdl8pYIY4toxsTFsNEag6QJePOc6oaOryw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMG9hdFI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E624B606A31C;
	Tue, 17 Nov 2026 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMG9hdFI
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F13BF1F000C5;
	Tue, 17 Nov 2026 19:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794942655;
	bh=QNfr1N4SlD4nY5lF2k9NOu1qbIPKIuO18d/t7UojEjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TMG9hdFI1EiKm12mX2UfRyknIADhNhlisQjyVgB+nCZZIPENEdznv9MneSRYCr7Jv
	 HMIiYw0QYp+qamQPfqOrdhty/ANjv5b9t7CPGrzmhSWmN0XeNjxDExZisM1vNvkZvB
	 UpFB4zHnjkbCr/HfYSCFcCYHjOMWmCUI8BqO2hltxJwBEOdKZRFeWWXCvOnxV672ni
	 hHG6+lRX18Q4qayZUEfaQ5BY2rNuiw3UDZQHStPfEkyhjUU3Pa3cZ+aY5TyWhz3hm2
	 x85mHaTn5JdLS3Brs0i5acaJvE7jsp6MiQ19Qk5biIFf1aBXXwe2VxmXxpdXZJxtFy
	 ROeBDjhz/LeQw==
Date: Tue, 17 Nov 2026 21:10:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
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
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [RFC PATCH 00/13] Namespace for namespace roots
Message-ID: <avymvCZGVcEp8mHu@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <CALCETrUBUnJVhiMkft6hTZZMe8nTpMBRTGY2v=9x5ETBSvmPZQ@mail.gmail.com>
 <avyhl79pygUmV3hr@kernel.org>
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
In-Reply-To: <avyhl79pygUmV3hr@kernel.org>

On Tue, Nov 17, 2026 at 08:48:59PM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 17, 2026 at 09:44:43AM -0800, Andy Lutomirski wrote:
> > Can you clarify what this new API actually does?  I've read this three
> > times, and the best understanding I've come up with is that you've
> > designed a way to create a group of namespaces identified by an fd and
> > you're adding an API to configure and enter them cleanly.  Which
> > sounds very sensible.  But I'm completely confused as to why a
> > namespace needs to be owned by a "rootns" or why that ownership
> > affects even newly created sub-namespaces.
> 
> I think this would postulate the patch set:
> 
> 1. A subset of detached namespaces.
> 2. A dedicated PID namespace for spawning into, signaling members, and
>    polling/waiting on init exit.
> 3. Initially an empty mount mount namespace that must be populated
>    before going live.
> 
> I had to do some head scratching for the second question as I've worked
> seriously on this already some time ago but I think it was as follows.
> 
> If recall it correctly, rootns ownership tracking was meant to stop
> processes inside a rootns from calling setns() into host or other
> namespaces of the other containers.
> 
> However, user_namespace already enforces namespace ownership for
> setns(), and adding a separate rootns check prevents legitimately
> entering a shared external namespace (such as a pre-created netns).
> 
> I will drop the rootns ownership tracking.

While the patch set itself is manually coded, I got inspired by LLM
agents back then. It was quite clear that in the near future OCI
runtimes should try to minimize the live configuration surface.

Another force was that whatever the solution ever can be it should be
made migration friendly for OCI runtimes. This led to the conclusion
that we need yet another namespace instead of a fully parallel
framework.

Br, Jarkko
