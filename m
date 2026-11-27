Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795821306;
	b=DmKsD2TBXIJmtIhIQRoA2nP5hfhWUE2nFQhyjfI6JE4iACOhcW3fHW9ar3tFmySo5c9O
	 hpPS3aV89S/dB6qhBVBVtc89WyAWwUW3iqGVBMJLWe5Blysif6pmR5cOztlP5pdTPxyuj
	 mojpE3zbN3hvps2ZRK2agLAD7CNDTAb/Xy1ViEDnf1shwDld10tpOFl41RqCtakzJpuVF
	 0xFTlPz+bmhCaOTlsHfog8pTrkxKUSB6rAM4eAcmOmzc6ps2Y/NGXdLPvr0fKtc4d/THN
	 aywreSOxwd0JUTIG4Y9g160iKg3pGzWbs+9o0CC+cguI3tE774RVK3tiZ5azv2DuHyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795821306;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IrDS4A11tKAewGc5ik+OaYkecvMF57R7fCAe0JmkaBc=;
	b=k7NgFRDDSTyePk6iZHx7lRR5L+AuwVLE6qGSN3AyJPFNyYm2RGrH65uUzYWO//cAk51C
	 g18U5c4NCmIsuEAg2gGPqqXxhQOp5pl1Yuze/DXe3ABqlbwhF9ZTb0t1gR8/NZB8UzWV0
	 eCI7m0863OckeeuFCQmScvitlsp3RM5z0jTYNbx99hp46xskBlH85K11CvOYcubt8wVQX
	 uHVpgrLPxrhoo17agc9Ce7zyUTj26CojwOmpSEOH9ypEeYkH6ILO9uDTHfwuTzyJV0+gv
	 sDrQ8MNAq6n9KK4V5+gJuIN2R36mLPcksY0hHGEqUdhRcDfnxxnU29kbfm3siOO16gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EcQaKITO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 26F85606A32A;
	Fri, 27 Nov 2026 23:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EcQaKITO
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0FA1D1F000C1;
	Fri, 27 Nov 2026 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795821305;
	bh=IrDS4A11tKAewGc5ik+OaYkecvMF57R7fCAe0JmkaBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EcQaKITOrl9V263dyfVjJdRqu7KemR4FxN4hFjrTHw+2KzO3Qa+MByOpOjIhMqFmV
	 qCT+jPAFEuySBDSXaWluhEjpN3uxqXzgWRq0njWLczKgZ8oCZVwpsLnlBs2YpNlzDT
	 6JqU5uXjurbdb7FHb3cEAd69Aq8R00ULrBKfvdxNHM8SdS8qBiOd5QCdI9SSVvtDVh
	 gOTGLLnz2XfqY6CjGmNkP/lR9OOP1eTnCzUL7dudMCQbsYed+ylVDuFvMN49yFUckG
	 puAtcdZCbt343YroteKV5W4L6rq6JNEyg4255jegM4RiST3htoJ/dwCChVDytRVczg
	 YZ+0shkfiEW4w==
Date: Sat, 28 Nov 2026 01:15:01 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com,
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org,
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com,
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com,
	jack@suse.cz, jlayton@kernel.org, josef@toxicpanda.com,
	kees@kernel.org, kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awoO9R7YF_5_6dHA@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
 <awn_Y7oI4ckfsjSv@kernel.org>
 <awoHex4LVst2JwkO@kernel.org>
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
In-Reply-To: <awoHex4LVst2JwkO@kernel.org>

On Sat, Nov 28, 2026 at 12:43:12AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 28, 2026 at 12:08:38AM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 28, 2026 at 12:05:03AM +0200, Jarkko Sakkinen wrote:
> > > On Sat, Nov 28, 2026 at 12:41:03AM +0300, Askar Safin wrote:
> > > > Jarkko Sakkinen <jarkko@kernel.org>:
> > > > > I personally think that "getting in" should not be a goal in the first
> > > > > place. I care more about that whaever gets in has a high bar of
> > > > > quality enough. It can be something different than this but
> > > > > when I read the LWN article about Cells I was alarmed enough
> > > > > so that I had to do this and prove my point.
> > > > 
> > > > I think that Bacik's patchset has better chances than yours.
> > > > I think so, because (as Bacik said) it was tested in Anthropic, and also
> > > > because Brauner reacted positively:
> > > > https://lore.kernel.org/all/20261021-zeitig-niemals-clubmitglieder-b3973fcebd38@brauner/ .
> > > > 
> > > > So I suggest reading Bacik's patchset and say what you don't like about it.
> > > > You will have chance to influence Bacik's proposal before it will be merged.
> > > 
> > > I've read it through and the way I'm seeing it is that it is overdoing,
> > > and has somewhat complicated life-cycle model tbh. I don't like it.
> > > 
> > > This could be of course wrong way to see things and I did this just
> > > to demonstrate that similar goals can be achieved with a relatively
> > > lightweight core. And this is also demonstrated with a Python daemon
> > > emulating Cells style containers (and alos relatively trivial SystemD
> > > wiring).
> > > 
> > > There's no reason to continue this for the time being as it
> > > demonstrates already how I see the world i.e., "I showed the
> > > code". It's up to whoever decides these what they do.
> > 
> > And even if Cells is the ultimate solution since I had thought about the
> > whole problem 1.5 years (mainly for my own entertainment but still) this
> > was the best way to unpurge all of that. Regardless, world became a
> > better place... New information arrived.
> 
> When it comes to containers and namespaces I even don't want to have
> any opinions tbh, because it is so opionated area to begin with. Thus,
> I pushed back sending anything using this approach for a year.
> 
> Despite the patch set tsunami (sorry about that, shit started to 
> unpurge as I went on), I was not too hesitate to send this in the
> first place, or have no motivation to compete with any solution.
> 
> I did all this really for the sake of rightful concerns about the
> complexity of the mainstream approach; and in that sense I'm happy about
> myself.

When I was thinking about the whole problem (for mostly fun) I was
thinking more sequencing than data structures. I.e. I have a game where
I need to end up to process creation without embryonic state, and add
just enough weight to kernel to support that outcome, and that leads
to ~2K'ish LOC of extra kernel complexity.

The type of staging that SGX driver uses seems to work really well here,
and allows to create the container state easily in non-running 
state.

Br, Jarkko
