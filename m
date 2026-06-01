Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F723D3B3;
	Mon,  1 Jun 2026 15:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780328199; cv=none; b=L7SbXpMB5KsSTnAJ9OnZlon733oZbZTBhfZ0Va+L4SAluhKd5uxqHFMO49dp+Qhh53hnpOzDUCLDytQ29d4NkB2bR1qzTh2mSU8WqmfjgkW2nsrItkWuodTw7+UfTHCFwXd0gQKQn7xplKiteTj7n7ptPoJcdBMCQSLE+P7RZoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780328199; c=relaxed/simple;
	bh=H47CwTJuyLbcelpSQG2zpvNI6BVNtzW7wETPeulhYLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UxgJ/+Try8axjj3+0aOyZurriuyCHN6uPayANdHVLBBETxGeHhYyd/0m+zXRu+QH/RHhYN4+eGlAeCuicnMp/bcwN68+ACYrQn8kYlkatR9D4vR2fQjkVu4wZgqzkw/jSx6Up6kbnm2CxJ7iIprryUzv1kaxQ72YrSJaoBpb5rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BHrNpzeG; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BHrNpzeG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=uh/rSo04bA41IYEYhuCEmiPxe1UvV/t0jdyDzVX2YG0=; b=BHrNpzeGZqdKJuNp96JO89ttPJ
	bdb+A5SD0YvtoDoKOX0CC3qchpCkTZ2sI3UM5+vS3aurB3SMNU/xuzXKT6ui9yT8laW8VxXYNd+Rv
	C08f5zIYEOjkeCCyZpXVZEUiPSHLKkaZKuGArp5Bh/d8uXdfJqpl2kKNB4wSH1ss24z4TyrYzHia2
	lHUWhh64JLazy8RinYX0kKD/d0zf5/Z10mlNfPhR1nXy3hJf5z2uOV3OjaIOQK2M2+6ALpsXj0gS3
	Zf1W7XuzTtQBA6MZZwthFzEcFOL6eR9aVlXkTl6XWFmGHUjDcfewUeG3hXPoPtR48i/QVNEPOt0Dw
	9NMgQ7Ww==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU4gu-00000000KjY-0W0S;
	Mon, 01 Jun 2026 15:36:36 +0000
Date: Mon, 1 Jun 2026 16:36:36 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org, netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <ah2nBAdsE5vVJ2PL@casper.infradead.org>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com>

On Sun, May 31, 2026 at 08:11:34PM -0700, Andy Lutomirski wrote:
> On Sat, May 30, 2026 at 6:03 PM Askar Safin <safinaskar@gmail.com> wrote:
> >
> > See recent discussion here:
> > https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u
> >
> > For all these reasons I propose to make vmsplice a simple wrapper for
> > preadv2/pwritev2.
> >
> 
> I have no comment on the code or the history.  But I'm 100% in favor
> of the solution.  vmsplice is a crappy API, and would be incredibly
> complex to get the implementation right,  and it should be removed.
> But it has users, and the approach of just mapping them straight to
> pread/pwrite makes perfect sense.

I agree with Andy.  I think it was appropriate to send this series, since
(as far as I can tell) it's a completely different approach from the others
taken.  I'm not really qualified to judge whether the implementation is
good (it's a bit outside my competency as a reviewer), but the described
approach is more convincing to me than the other approaches.

Can we review this series properly?
