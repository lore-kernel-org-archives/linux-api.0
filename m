Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A794945000;
	Tue, 26 May 2026 01:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779758496; cv=none; b=Ybx+nuNLlBIWgPuWjlS8WCm5dEsXwe1igrykfYtTzViRIP1xlUvYtikjB935Hm7UJGH1xP/lE6+Jk6LAz2qeTTHwZ3jVQw0FeoDN8Q3OHSr6cx5R5oTrGkTQLoDf4ixHEnrglfdoKprFLNliHv039lA9mm1WoWdpg9feO5TiW10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779758496; c=relaxed/simple;
	bh=vdpKiJpnLiJnBtR/G9qsmlFQXmcAf1O/2sy78pVFK7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7kpFNMr07+z8vEL8GrfOAn+0+YEMJwp6WTjXsPYpHowj3YdFzR2KUWuC9vMIA8pQorrOKAjLKyPS93xxtnsgjzR9wwtMuf74MvVTqL97Yp3pPC9GbRtpodVF1/xjQqUZRKpUXRcCT7+vUvnh2HdzAjvGa3S/Vn6cdwidZRPs1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0aBwEs0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0aBwEs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC0D1F000E9;
	Tue, 26 May 2026 01:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779758495;
	bh=K08IF8WJnEk+HHOzE8UXb7WzEnURtUvmOtiXBoUticQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n0aBwEs0x5kOqgOGmfUYYQ9pJ4qZYr13caDsJNheuSxzlcgldJfVTK5poT02FgMBr
	 NwwPAddG/4BDkWWsJV7ldW85k/uSYyh+2C3X+q2lF9QrvKVRtxz93mIBkSqArTl53G
	 8Kt+2kJg1gIz3ua5R6yoqVSdQchm5ka34qy2JKKa/YfuxJAHwX4WoeG/MiPeFy8WWR
	 EpMEBen6Oyd4wWZ7R7L5WeMRH2Fxh6Vslu9ypoHIa8LiC+D2g5hButVboP1RRpw0Zm
	 h//Q4aUcFBi4PkmMMfxqvmNluuiVym4t4ZBVAEzv/gFG9DymNyS9IaTN41kRRR7A6L
	 xz/CO9YO/xZKg==
Date: Tue, 26 May 2026 01:21:33 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahT1nT3xsMGkyJab@google.com>
References: <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag9D6_7dttbDGHZ6@casper.infradead.org>
 <ag_UsW_OrlXD9dWX@google.com>
 <ahBSXyOi9b1jxNkX@casper.infradead.org>
 <ahBii6bk0KbK_NHV@google.com>
 <ahPffhaOi2CBtWof@infradead.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahPffhaOi2CBtWof@infradead.org>

On 05/24, Christoph Hellwig wrote:
> On Fri, May 22, 2026 at 02:04:59PM +0000, Jaegeuk Kim wrote:
> > This was a quick buddyinfo right after booting the device.
> > 
> > Before:
> > Node 0, zone   Normal  22684  42284  28704  16901   9515   4566   1854    673    181     36    758
> > 
> > After disabling EROFS large folio:
> > Node 0, zone   Normal   8486   4732   2175   1161    697    272     82     19      3      1    856
> 
> And what are you trying to say us with that?

This means, high-order pages were used up by EROFS which sets large folio by
default. So, I wanted to say the concern was based on actual data which was what
Mattew asked.

> 
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
