Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4BA28C2A1;
	Mon,  1 Jun 2026 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780330661; cv=none; b=uCXNAPw3/Rb+29/E9gZPM1lVsViGrmdmwcW84GYp/JKRYKBpcj+ZhdlqABv6eOlK26ipeapBtUP70c2s8hMC+L0cGfzAzvDJEvHwj0778e7np7jg4bh4kBE9pegItQYJ6ixMliGywCcZXHXqJ11TImMQS0zBjFWBYgQsHRcRRuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780330661; c=relaxed/simple;
	bh=Q/KncJprqoJCnS3aH2kF+5RbWfUXbgZH5dY8f1wE2u8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mahYEJWZfb0cUzaC0snMvoKnfxzDezAwnFGgQSwI8ELRxQcC/mNVf1MWfVL8ZUVjssQaBrJ5Q7q0i0oLosiwFP/4VQD+aWAB0Xgs3nw6de7kmx2CSjg4CcP+TN4JDBh1OsJIrQUDjtSYyA3Di2jhhwnwOXSgU+CEK5AB6+vP9Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BifbDx5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BifbDx5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E1C1F00893;
	Mon,  1 Jun 2026 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780330660;
	bh=rNLnkxLxw0b3sBZzOdV8X6NVlh7ujukPI0iIaNRmGIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BifbDx5D653jXTMEUYB65fYghTtrNqepjSBzEEPnsZHuvMiKkUOlVvAuDnhiuDt+S
	 304eftkIVK3rIX5PhVwBL44KNhsA9dJwCSyTFzVTvI30ARJthbxHrK6U7NK9+WK5GY
	 TC9AesLZFTlE3g6mll/KzrdOMnxuE7tBLKicmwOzeWy73MC+/4AL/ZfXfEjcqljG9V
	 pBY6dZiayBvckutKYiFU/gdYkCs+GfJfmG1ifRYuW+2TFchPjF+q+XEM/3y/pdWpRJ
	 eCatAhyfCn+EEyD2fqdkmd2KXIZ26Uz9dsqb3EYg5nVWNFlArRGKYC3M0cqkoD14cB
	 9u/DYe8gzQbPg==
Date: Mon, 1 Jun 2026 18:17:34 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andy Lutomirski <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>, 
	linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260601-aufweichen-dissens-ausrechnen-0d9b84728113@brauner>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com>
 <ah2nBAdsE5vVJ2PL@casper.infradead.org>
 <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>

On Mon, Jun 01, 2026 at 08:50:00AM -0700, Linus Torvalds wrote:
> On Mon, 1 Jun 2026 at 08:36, Matthew Wilcox <willy@infradead.org> wrote:
> >
> > Can we review this series properly?
> 
> Well, since it pretty much is what I suggested a few years ago, I
> certainly won't NAK it.
> 
> And the patches looked very straightforward to me. Just the final
> diffstat is worth quoting again because that certainly doesn't look
> problematic:
> 
>   7 files changed, 33 insertions(+), 204 deletions(-)
> 
> and it removes that GIFT flag that was truly disgusting.
> 
> So I'm certainly ok with it from a "looking at the patch" standpoint.
> I didn't _test_ it. I don't have any workload that might remotely
> care.
> 
> I did a quick scan on debian code search for vmsplice, and after ten
> pages of entries that weren't actually *using* it but had lists of
> system calls, I grew bored. So there are likely users, but I don't
> know what they are and how much they care. It *might* be a big
> performance issue somewhere. Unlikely, but...

As usual I would argue to accept it and revert in case we get actual
regression reports...
