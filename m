Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3F341754;
	Thu, 21 May 2026 17:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779385329; cv=none; b=fQQ/p6Xe453EXrIeYCorz2RGw/oLtIiTBGnRQ/G4gnKVheBiRhLv/Hi+woqmw49sSi4RYE0QiHQU5bgl7QfRcfampZsm2TNhB184LRxt2GX9/J8olR9/Arumy8UBw6t8OUyiqnkRLexz/osWgLHYA4HOOSjyZ/LxCba29i1985U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779385329; c=relaxed/simple;
	bh=zWWj0ezxd6HL6BF4TGyQfRHRwqJz5spsOU9FeDBseqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZ6IAuiIMxv+6mq2gePos35ENA2wcUT4RtHmKEy8FpP6jINIKOe+1jrA11ukOfYDSJgU+h283ylRMpfRetY3g/aBNAM5IziiiDwkTFT00hS0maOuM4PShce/bF7DCCwEChPm1if7NHrUjVF10eAHe9q8jHndzdOHmenbUwVcztc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ejOrg5mg; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ejOrg5mg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mocVZk7k0i4LfDz16F/hYo5gMZPJrjHL7ge9GFVHtqI=; b=ejOrg5mgxSsn7RT/IqWLJYzFmy
	NjacPOHPPk39x+u3OOyZlw/ZOZDCW0fQ5+j7kEh4ns0cWOZDIgh2/xgyxFhO42LNiJuYqfWu14Qyq
	INqflfS2Q5C56RXca4CONSNgXzpsQvC40q9brHTV6cOwrRANsEllx6AZK4PQKsjB7PlcIhsF5CpqN
	QhpXfxqg147N4BeXy5Bv0k94qY/07fYp+a8FjqSGRQh7dVRzAyyXuO3zAztmvK6mhXUPh9EOTJgTP
	fnUKz1TMjfkyI6WIwVEHZ5v3AqVavAwv4Eq7ga7uPWwJfxGJoWW6Y1JZanIeGHyZdizhe1S6ukMYn
	C1VY/WxA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQ7PH-00000008pYv-3GzO;
	Thu, 21 May 2026 17:42:04 +0000
Date: Thu, 21 May 2026 18:42:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <ag9D6_7dttbDGHZ6@casper.infradead.org>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521155748.GA79343@macsyma-wired.lan>

On Thu, May 21, 2026 at 11:57:48AM -0400, Theodore Tso wrote:
> So let me get this straight.  This is a magic xattr interface which is
> not even persisted in the file system, but instead sets a 32-bit
> bitmask in the struct inode which disappears once the inode gets
> flushed from the inode stack.  And it uses a generic xattr name,
> "user.fadvise".
> 
> There's no way in *hell* any other file system is likely to adopt such
> a broken interface, so why didn't you just use an ioctl to set this
> magic f2fs-specific flag?

I mean, yes, this API is horrendous.  But it's just another example of
f2fs thinking it's somehow special and not just enabling large folios
like other filesystems do.  This hurts everyone, not just people who use
f2fs.
