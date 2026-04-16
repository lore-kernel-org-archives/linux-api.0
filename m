Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C33A1F94F;
	Thu, 16 Apr 2026 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776302349; cv=none; b=EdTnsDf9Ms0YVLQxqmomyPZpAaneczTkupXr7khz4KsuRoWbSya4cEfxtc0s0p5fwBJoBi6t6CUBXinYSgiEVadnAOgTP/Sy4jOAsdofUAZEHWHOuxPwFq0uQkblciNXa5U4GFs5xBXHyJNbxOYqtzYbAYgaZW8FaLbhB7f+FHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776302349; c=relaxed/simple;
	bh=sGPVhh1PMoxtSRZpRrI3iao9xw5DxpR7NnDEs0o9Kgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOWyhueA/saPdYzG2n/FUkmmKH2WvhdTVLLqdr9pqL/270mOxo8XqjKHdgQSV0PzKZxSknuFK56HGcVdtCGttDeUIjXPFnhDmL7EWc98E/jzQv2c7GySXWIBJjZrYur7fLrwqpP/GDUsT2GkAV2Yk31X4e1BTGKO7qJ+AoEqJDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4B7BqzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4B7BqzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CC3C19424;
	Thu, 16 Apr 2026 01:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776302349;
	bh=sGPVhh1PMoxtSRZpRrI3iao9xw5DxpR7NnDEs0o9Kgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h4B7BqzBdmwkiQP3eic2DNPc5SfwzxkiQTs6gPXXav+LObOeFH7nkioxT7SaepznJ
	 tKeHtP/Q/R1rN+IYoojyUMD/9KImNkUeDlEZ5WlslsOlCvQ2KqZlW3coZcdxlw3RNz
	 3mCV7tjMjQ2OqsxWlPvw1ydH4/JIGVkdDmVKz1KpUuDTB5O8MyYUvD27sG0B+C9qgU
	 8jolvhM0TULMdqnl/LgRNrTYwCl5WgyWumi8qCF1q67v2K/cuqrhQNUhqaIazzxjtC
	 Apa5NTA7awDPIth5oapqjqZwGGydEyX8hC8yE+ut1WrXAhm2X/Ni0qm5cQBQ819JSR
	 jrW0S6CU0yzgQ==
Date: Thu, 16 Apr 2026 01:19:07 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <aeA5C8byIpXWla7f@google.com>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <aeAK8mFxzgMOepmZ@google.com>
 <20260415234950.GC114184@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415234950.GC114184@frogsfrogsfrogs>

On 04/15, Darrick J. Wong wrote:
> On Wed, Apr 15, 2026 at 10:02:26PM +0000, Jaegeuk Kim wrote:
> > On 04/15, Matthew Wilcox wrote:
> > > On Wed, Apr 15, 2026 at 04:44:04PM +0000, Jaegeuk Kim wrote:
> > > > On 04/14, Christoph Hellwig wrote:
> > > > > Please add the relevant mailing lists when adding new user interfaces.
> > > > > 
> > > > > And I'm not sure hacks working around the proper large folio
> > > > > implementation are something that should be merged upstream.
> > > > 
> > > > Cc'ed linux-api and linux-fsdevel onto the patch thread with a proposal that
> > > > I'm not sure it's acceptable or not. 
> > > 
> > > You haven't sent a proposal.  This is a reply to a reply to a reply of a
> > > patch.  There's no justification for why f2fs is so special that it
> > > needs this.  What the hell is going on?  You know this is not the way to
> > > get code merged into Linux.
> > 
> > I added two ideas in that email. Have you even tried to understand?
> 
> You want to establish "user.fadvise" as an extended attribute containing
> a bitmask.  The sole bit defined in that attribute means "use large
> folios", but you also have to change the file mode and set the IMMUTABLE
> bit for it to actually do anything.

Partly yes. This path has nothing to do with IMMUTABLE bit, since I used to
activate the large folio with that bit, but hit a big pain which requires
clearing the bit whenever just deleting the file.

So, this gives a new way to activate the large folio by chmod(0400) and
setxattr("user.fadvise") only while providing quick inode eviction in order
to set mapping by iget, and allowing file deletion easily.

I feel the arguable points would be 1) the path to evict inode by calling
d_drop in release_file and returning 1 in drop_inode, 2) how to give the
hint between fadvise(FADV_LARGE_FOLIO) or setxattr(user.fadvise) by individual
file system.

> 
> Meanwhile, you can't actually persist any of the fadvise(2) advice
> flags, so the xattr name doesn't even make sense.  Maybe you meant to
> call it "user.madvise" since the closest thing I can think of is
> MADV_HUGEPAGE?
> 
> I've understood enough.  YUCK.

Thank you for taking the time to take a look.

> 
> --D
