Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173316;
	b=AiKADyBOVOzTI4zV4hVHfAQVU+QVGdlWW8K+955/8lOH9rwFkZ/Kd14OMbnCJTekYWif
	 IfaSw0gkDTJkJjvbP66yBVy6DAibwcY0xYAb2hamyGxnIClgpyZX2Ca5x2DOVbo9rI4YS
	 DmWyqHUBi/+744If3T99JsW20rE9i6Uj+2E++bkOb0rNzUOqwVK7VNG+v+ivIjxqV3b+b
	 /23wHfjayAtWBrczZAj8qKCl9i0Sp58tTNZjFfJivgQ/5YFnl+RA5hdUZfrVkXxcMjoGF
	 6DkAlKRhtsql4ELMEG4sYZZOx90VMaax51eVy9UAn7OnQc2J8548KTfQwRZVfgrmPeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173316;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ylpOa03watBXcc8NuGp5fAH6bW4gLkgGFrVyqJKXvOY=;
	b=sDk2DXBClDzoSmBXGLVGYkWl9KSfhslbu7QowIljiPkoFmunA+RRu3YIhhgzy7LPglut
	 ZwiUSTCTWB4l8z5M0d3kYBz3LbGlGtFylRiXo0VGuj7yYw1PbP0AAwnFOTwl2t0ZzzzXG
	 +gPnHdo7kOXXnnWiv2LFejJjgC5N+n7SYV4uoPal6vqTADwFIp1BGG5tZACoF1iJFmTCi
	 iEifKNSRD6De9lTSlaXwCeHuNVEfF6fuNsbAijX+VA0QotsRayeigbCHYNwbeSgaRHGyJ
	 ksRac7Z0SNmVyzHRKcPAG4tfoLRlu8rWSvOfnXTg9ZvQ3fuDe7CABKHh+Qf3luwqghw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QR7Qz9nr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0A0606A320
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 11:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QR7Qz9nr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E96B1F000C4;
	Fri, 20 Nov 2026 11:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795173316;
	bh=ylpOa03watBXcc8NuGp5fAH6bW4gLkgGFrVyqJKXvOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QR7Qz9nrT3mwQcuGWuPsIQVvTEaFES6qe+LLNtfCgbhP8DLQkRda0r6SljCNcJIA3
	 RhQYSTjbGiOEZhy64F/bbWEvfIfHWvAnH0LyjB3Y2OfSAQnNa2q6fkRty/yXsRSyOK
	 dw8F9YBO4lv10Q7htcqHB5d75OQKKxtCyc9MuudR0XEZ1pvSfZyzhCzrJAY6AtFz4S
	 puA8yRNHt6Q2F1w3C696qsg1aGm8MA3rF4qBtFtXWRAwVOktguelOjDQPzpa8MmjKj
	 SndII2p+uYuQk57BJoum0VFsX9VeZo843XWERj2fWjIvndreLk37E+92GdyVMuGYm+
	 WuiU0vhNilhJw==
Date: Fri, 20 Nov 2026 11:15:12 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, 
	Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Wupeng Ma <mawupeng1@huawei.com>, Ding Feng <dingf3ng@gmail.com>, 
	Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH] mm/msync: return -ENOMEM if page-aligned length overflows
Message-ID: <awArh0Xnq2FlMM_x@lucifer>
References: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
 <5b916aaa-cc04-4ad2-8008-04a57d8e83a7@kernel.org>
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
In-Reply-To: <5b916aaa-cc04-4ad2-8008-04a57d8e83a7@kernel.org>

On Fri, Nov 20, 2026 at 12:09:07PM +0100, Vlastimil Babka (SUSE) wrote:
> +cc linux-api
>
> On 11/20/26 11:59, Lorenzo Stoakes (ARM) wrote:
> > Currently the msync() system call will simply return 0 if you provide a
> > length parameter which, when page-aligned (rounding up) overflows (i.e.
> > SIZE_MAX - n, where n is in the range [0, PAGE_SIZE - 1).)
>
> Weird, as if it was intended, but seems to be pre-git, so who knows why.

Yeah, likely unintended but doesn't really matter.

I'd like us to completely centralise these kinds of checks for mm syscalls
but on the laterbase...

>
> > This requires broken input, and nobody has complained about this, but for
> > correctness this should really return -ENOMEM, so do so.
>
> Right.
>
> > Also, since error is assigned within the following loop, remove the
> > unnecessary assignments prior to it.
> >
> > Link: https://lore.kernel.org/linux-mm/20230321074035.1526157-5-mawupeng1@huawei.com/
> > Reported-by: Ding Feng <dingf3ng@gmail.com>
> > Closes: https://lore.kernel.org/linux-mm/20261120051413.46167-1-dingf3ng@gmail.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

>
> > ---
> >  mm/msync.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/msync.c b/mm/msync.c
> > index 90b491a27a14..ced41d3c2903 100644
> > --- a/mm/msync.c
> > +++ b/mm/msync.c
> > @@ -46,14 +46,12 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
> >  		goto out;
> >  	if ((flags & MS_ASYNC) && (flags & MS_SYNC))
> >  		goto out;
> > -	error = -ENOMEM;
> > +	if (!len)
> > +		return 0;
> >  	len = (len + ~PAGE_MASK) & PAGE_MASK;
>
> ALIGN(PAGE_SIZE) or something?
> But fair if out of scope.

Yeah can do on respin if needed, but right now I have more deletions than
insertions which is rare for me so :P (maybe not the best reasoning, but
still ;)

>
> >  	end = start + len;
> > -	if (end < start)
> > -		goto out;
> > -	error = 0;
> > -	if (end == start)
> > -		goto out;
> > +	if (end <= start)
> > +		return -ENOMEM;
> >  	/*
> >  	 * If the interval [start,end) covers some unmapped address ranges,
> >  	 * just ignore them, but return -ENOMEM at the end. Besides, if the
> >
> > ---
> > base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
> > change-id: 20261120-msync-enomem-fix-95f830e305dd
> >
> > Cheers,
>

--
Cheers, Lorenzo
