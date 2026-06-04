Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857413BD228;
	Thu,  4 Jun 2026 16:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.59.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780589745; cv=none; b=Voa6+FAgZq+C04Ytgrbb251wGCXnjmpU/J59P5uagi37oojOWlybUJWFRw9zZwcmg5hB0mxlAaFYHAsI1MogH686mdrJpd8LyadueKTIq2MUQRcsQP+hsg20xKeGGRIGNKij/0aZf+M7xLgT5QrIUrSRx1jsq8HEoVfkXhKApe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780589745; c=relaxed/simple;
	bh=0DcYu37NI3Mkq37iWnwZjuqWINU0U2WyJ1Sba8jpETs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qh/FGEtYlXDixIv2KigG4mlSoXIEGNTlFddmA4c4EV3PHv1419GtByeb63PCW9m4LfDfhy2oi8b6dDbr4KB+GKVNtqFDzHvAymAeA0rAOuMbNFOMjqRt/ttdzHDB5I+S5G9Y/o0NBORWR1kUzGSeQELkud6F5HFww78KLjtGmBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu; spf=pass smtp.mailfrom=1wt.eu; dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b=ppwPVJXO; arc=none smtp.client-ip=51.159.59.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b="ppwPVJXO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1780589742; bh=mtMzuRVZcGCklSnA+/FZ/RF0Vg5pOuupQOOgmF8wAFw=;
	h=From:Message-ID:From;
	b=ppwPVJXOvGYaPRdvarE9BWEOVpOna9yvC3pObS8GWFHiL3VuCxL45zGcYB3aZJbbA
	 d1LtvytShpiYHUGqpfrFWU17MFQ7amA6RJz/xe76SyT0sSNTsHwUbT4AiRo0QRPvcu
	 o6g4Sl7kKXm14Zs4EoZaddi6Wq8k04QZEhNLAVHY=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 6F0B7C0BB1;
	Thu, 04 Jun 2026 18:15:42 +0200 (CEST)
Date: Thu, 4 Jun 2026 18:15:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        David Howells <dhowells@redhat.com>,
        David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <aiGkrQnMeyPmEvRB@1wt.eu>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
 <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <aiEb8CTM-ovMIq7-@1wt.eu>
 <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
 <aiGfgRch99l_5z11@1wt.eu>
 <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>

On Thu, Jun 04, 2026 at 08:58:33AM -0700, Linus Torvalds wrote:
> On Thu, 4 Jun 2026 at 08:53, Willy Tarreau <w@1wt.eu> wrote:
> >
> > > It looks like you're actually doing exactly the thing that I thought
> > > was crazy and wouldn't even work reliably: you change the
> > > common_response[] contents dynamically *after* the vmsplice, and
> > > depend on the fact that changing it in user space changes the buffer
> > > in the pipe too.
> >
> > No no, it's definitely not doing that (or it's a bug, but it's not
> > supposed to happen). I'm perfectly aware that one must definitely not
> > do that, and it's a guarantee the user of vmsplice() must provide.
> 
> Whew, good.
> 
> In that case, can you just try the vmsplice patch series (Christian
> already found a bug, but I don't think it will necessarily matter in
> practice - famous last words) and that test patch of mine, and see if
> it all (a) works for you and (b) if you have any numbers for
> performance that would be *great*.

Yes I wanted to do that and noted it on my todo list yesterday when
noticing the ongoing discussion. Just been super busy with yesterday's
by-yearly release ;-) But at least I wanted to share quick feedback in
this thread about existing uses.

> There aren't many obvious splice users out there, and even if they
> were to exist they are typically specialized enough that you have to
> have a real use case to then tell if the patches make a difference in
> real life or not.

I totally agree, that's why I want to share some feedback. I remember
years ago when splice() was broken in 2.6.25, there were so few users
that I was the one reporting an API issue to Eric who addressed it
early by lack of users. And I even consider that due to the very few
users, it's even acceptable to slightly change the way to use it if
it can provide extra guarantees (like requiring a capability to access
non-anonymous pages for example). It should not break that many apps,
and as long as they can preserve their essential benefits, I think
most will be OK to adapt.

> So you testing that thing would seem to be a great first test of
> whether any of this is realistic..

Absolutely! 

Willy
