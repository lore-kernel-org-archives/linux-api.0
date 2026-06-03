Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E003AE183;
	Wed,  3 Jun 2026 18:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780510325; cv=none; b=bZMlE/YI6WOEOhOq/N/K/7P9Db7/CmeqhmEdhBa6CuuNfITUIr+dXoJgYWoSdW/Svp3vxUCJi0+912RdoLRH3AGe0PZYOe55opFuj4cIKGt+nyBJcdJ8cz7Xul/SN6U70BbqeM522fx6PAxRKNrCS1S95He//l6lZfNBPpaOB7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780510325; c=relaxed/simple;
	bh=jVbPCJj3YloTg3b6cS/Yizub5EX0jFtfIogzscWW0nw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UcIJf5wFrDMSvvajojZGQnKqO/v983i2AHDoY3deF+T8jF4bg/F3bazyv7pSdYakgSVJvz+Dq5Ufo2YOWPF6RWauq2WCyICIMmC+jAAkUn9GZ6pSsULltqe+7yK/6ms2yP4JknETA0G+rD4ZsoRl7P0sCPkIgsXer0Sjcw4qNy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B27+dQYG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B27+dQYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3666A1F00893;
	Wed,  3 Jun 2026 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780510323;
	bh=QRkJ7uiiD7zKB9qnDeo6XCLMAk07QjESwe3HgS4riFA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=B27+dQYG4LhyQcTqGA591Kk0r+cQwyIZLXxmrccFJ2B9HzR7TNwYvuHIGqmq3s2H1
	 EmB5sy0V/0O0vJpdyC/No8VJQ4GC10uNe5ogoLYFfGmKmOhrPnqCWjIscZuxzv+y5K
	 U4mQD3HD2lJA8Oos00E9ZuiH3YIac/rbWjQQPb9IVi+mFl0Jjf3pMvGDxjQ0reUqtr
	 pxI9FIArphTePWwWLL3O/CTNFj7F1W70JLdvvfUVeq83Zyus2t0XgSajDuoDDALGPn
	 HR99k4B70qSrT+ZnxSbXlaR/Jr+0L4duz/in0PoUwZ+22M5k6K5gpWKCf2//rZYvvF
	 kFZGH08MfCfig==
Date: Wed, 3 Jun 2026 11:12:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Askar Safin
 <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk,
 brauner@kernel.org, david@kernel.org, dhowells@redhat.com,
 hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
 willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260603111201.6c723264@kernel.org>
In-Reply-To: <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 2 Jun 2026 21:20:13 -0700 Linus Torvalds wrote:
> They were all in the networking and crypto code that just didn't deal
> with shared data correctly.
> 
> So in that sense, it's a bit sad to discuss castrating splice.

+1 IMVHO the networking bugs where people just not knowing what they
were doing. Presumably AI has scrounged all the occurrences of that
bug by now. I'd also hate to render splice optimizations moot based
on those bugs.
