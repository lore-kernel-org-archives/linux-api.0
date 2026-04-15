Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B854E373C04;
	Wed, 15 Apr 2026 17:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776273353; cv=none; b=mgrvCMwrF9s0uniy6SHMvnMTVv4Yto0QskQ1N7MgngHv6Kf6zkJFu6XqSrbNuUuc8EJ+X20BwG1bH04cssz2Q2BnEwNborkyLK5U0cbdbzc8kuNyT4G2H6v/Ig+r1MSTlbbqPpuKZUS1G/WYvmdgaa31tGEepHdUG+elXYZyvgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776273353; c=relaxed/simple;
	bh=7I7JlqSjbv5jsbL4I06PiKwYdnHw0Y0zTbU0r8ESmCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IlfXaiV6ZTMNcUgk2aCbBWoIVjnVtQx6lNYKcDZ1Y8pk6fnlR8LJoZ7DCTWt6KCXErK4uRaYplTtADaFFnehD1GjwHEfzwui5GCkpauWknazLDdfBXTsgYbN7rEFCvA5WuSxYkbfMAbTrU//8AfsKWWV/0EFUdn7pHgiKt4OSI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y/qzKwPC; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y/qzKwPC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ISsLIKP4bjUxgr4BYttgZs8l+uxApeegxanE10R4kzc=; b=Y/qzKwPC6h8YPlkBZrqWGNfOS9
	5WTrl/NWtmNx2pAqg9rGoNGsdTZbyEoa/UdSYzqUEldGyhWm8V4whdF3OLQUdwLt1eP0fAqmfrL65
	l7Q9dYGb5zIuRdxB3tfwHPxFpEPav9jk3SBFyrVHZsZThn+Lqx9KMem0N9hpLf2rGAPTEH0wvPUNi
	ZqKitex3Q//ilsBhw/U9xr7IxjJotzWolQkSg5uCdBphNeGYZqWaegBkJggGzOJsoSMz0hnvCY4wB
	6cxYIv8YOCP6BT8rt/FLq2pRni5qxu/xDz8E6P7NMiDThQbpryw/4ujK93ThvoueCSWF0CapbVOu5
	49KLzwaA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wD3q6-00000000CP7-1hCw;
	Wed, 15 Apr 2026 17:15:46 +0000
Date: Wed, 15 Apr 2026 18:15:46 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <ad_HwhzlNPUEKQi6@casper.infradead.org>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad_AVHe7RMnGrGTb@google.com>

On Wed, Apr 15, 2026 at 04:44:04PM +0000, Jaegeuk Kim wrote:
> On 04/14, Christoph Hellwig wrote:
> > Please add the relevant mailing lists when adding new user interfaces.
> > 
> > And I'm not sure hacks working around the proper large folio
> > implementation are something that should be merged upstream.
> 
> Cc'ed linux-api and linux-fsdevel onto the patch thread with a proposal that
> I'm not sure it's acceptable or not. 

You haven't sent a proposal.  This is a reply to a reply to a reply of a
patch.  There's no justification for why f2fs is so special that it
needs this.  What the hell is going on?  You know this is not the way to
get code merged into Linux.
