Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49123932DF;
	Wed,  3 Jun 2026 06:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780469126; cv=none; b=RwcxhOsS1wDSEADMw0NwVs8EpKH4g0C1KlONjEfM8e7rWnTAt8ufCR+3laCS2PtUlDU3vo/E6UalrS+hB6IKDUwRY+TUqzGEgX1Wacd5wGbvSljpa5d0S1iEPNuNR/G2vNptMfDBzFGT7+FbIPnrGLbDWtItDoDiIQmYs58EtNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780469126; c=relaxed/simple;
	bh=FlJX/aRC5LQrcfnGKapUv9zoRlnJeo22WPPm/BdM1zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZXfRnkytcPLE6Nu6EQ2DB8eW5ylvkDeX8Q3BoBqP8QuK9c4nkN39b8NC9o2VffTgitgqd2niCz6jw5dQ2ovAmobD1SEyAhvtLcs6Ezrwj0fGhN706jCtixfPBStzM5DmeJJEKkIw0opIWKNIvpEbl/aTeotrvvHMC8WueDTQpis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIkoHRVh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIkoHRVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6561F00893;
	Wed,  3 Jun 2026 06:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780469124;
	bh=7ObTrJ9GazdR2NdJ+eeFKlgqk42+5iCHPfrmuB4B+lo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QIkoHRVhXdigDLO3Ti27f6bvHuF4ODHiAa2mlkrpEM1nLC7f6datXVoGlV8VMvS1S
	 a/mrSKIIQyHnmLLbge3o/ckSjxEDCAHku3TeAOPTkSP2Wm8tFg1XNrlnJQOR5r7AoA
	 0qxJUH1Ds5R906ZYV1bqz/sdInIfpC71u5DlLK9vhTZvn8xVm+pt9vxjHdhsfcE2Qm
	 rMfUhj/V8wuFctgcxRA+YtchnLIrWE7kb4wfTR4PXwAeG3wQH7lmsv9/Zh/GDdipaj
	 AU8B0rLgs2KbbD5CMbC+YnHvqBoqCkajxZFGVq0AlS1m+28agSYJaNqAZ9BI6qQKi3
	 X9JAdqxUcHvQQ==
Date: Wed, 3 Jun 2026 08:45:18 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, 
	Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, david@kernel.org, 
	dhowells@redhat.com, hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	miklos@szeredi.hu, netdev@vger.kernel.org, patches@lists.linux.dev, 
	pfalcato@suse.de, viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260603-navigieren-pleite-stilvoll-60e6da66b1d4@brauner>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com>
 <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>

On Tue, Jun 02, 2026 at 09:20:13PM -0700, Linus Torvalds wrote:
> On Tue, 2 Jun 2026 at 20:51, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > Am I understanding correctly that this will completely break zerocopy
> > sendfile?
> 
> Very much, yes.
> 
> And it's worth making it very very clear that ABSOLUTELY NONE of the
> recent big security bugs were in splice.
> 
> They were all in the networking and crypto code that just didn't deal
> with shared data correctly.
> 
> So in that sense, it's a bit sad to discuss castrating splice.

Well, we're completely ignoring the fact that splice()'s locking and
interactions with pipe_lock() are complete insanity. So unless someone
sits down and really thinks about how to rework the locking I think
degrading splice() is just fine.

> But it's probably still the right thing to at least try.

Yes.

> I just suspect we'll never get real answers without going the "let's
> just see what happens" route...

Yes.
