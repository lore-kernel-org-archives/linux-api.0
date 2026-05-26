Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15EC3C3BE0;
	Tue, 26 May 2026 21:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779832365; cv=none; b=oJNAxaoB9WFYDRSofTVU9ryxTClesw5udCeibJLnAzAjpF3huhPZCjnGJRXo+MMI+Kii2zGY8AzlBm7b9t0q4yKTkFA6SI7XaV0o7TcRLzX/tSNSEcC945G9tyAiRl5lZ4FuKe775UiP7FA54XH8XehJEfYRnYC56UHdzd8/wWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779832365; c=relaxed/simple;
	bh=FXveVn7dWxAP/ZCZ2BR01vj75nt9ZK4d7sZz4LnlIUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0l80vsB+JWPGiVaNzJmdxJ0meTy7fRVSggKuFdyYBEOQgv50hq5QfxilAQMP4sYJCgsaNNfFdDdhjCRvUQ3gU8rrwjuX0tFx89kANzps3JABQ6D31mDUAA8cpqDf9CWaCrnItxSyx6aYSM9DFnLS1kVKrWCfUPPWZ9WWUCDwY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRKFuqdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRKFuqdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAA91F000E9;
	Tue, 26 May 2026 21:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779832362;
	bh=YI4DLcvbXipAMyS1cQ/oZ3L9E0DlHKPUuIOEJebdbEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jRKFuqdwRftvpOm9p7jpjT92MLNyesJVNfVyNIM6a8b28h8abHP+de6smVeNxUS9s
	 AD0l4dGEhJdqCPFSNruEo3kcQA6qGgOohdfyV2+C9smodAtEedm7lj/yYzvCbZkX/N
	 AhBesMpOvOXzZkccXIcGMs8/wpQZew5M3lYM1ffGf2mrdBelcDDj4zS/ARObMxNm3G
	 36RGlLV6aHNIhk8jBnOLufsXmVucf93UgdJIqW71/oUxCpXCxMEbwYXjJTliOyrkre
	 mwMAeN4DB/kKvUYAZAA90cKWwvgyv5XIZYsJd+ohbd9J2C3CKprqObflqhP8pgdeX3
	 4QkN0Jb1ArP3g==
Date: Tue, 26 May 2026 21:52:40 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahYWKH9-ybDlZuJd@google.com>
References: <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>

On 05/26, Theodore Tso wrote:
> On Tue, May 26, 2026 at 01:10:55AM +0000, Jaegeuk Kim wrote:
> > Background
> > ----------
> > The primary use case is accelerating AI model loading, which demands
> > exceptionally high sequential read speeds. In our benchmarks on embedded
> > systems:
> >  - Using high-order page allocations allows the system to saturate the
> >    Universal Flash Storage (UFS) bandwidth, reaching 4 GB/s even at
> >    medium-to-low CPU frequencies.
> >  - In contrast, standard small folios cap performance at 2 GB/s.
> 
> So you're interested in optimizing the I/O speeds.  And apparenty, on
> your hardware, the UFS controller has limits on scatter-gather entries
> --- UFS seems to call this Physical Region Description (PRD) table
> entries.  Per Gemini:
> 
>     1. PRD Segment & Length Limits
> 	
> 	Maximum PRD Entries: Hardware limits typically cap the number
> 	    of PRD entries (or segments) to 255 or 256 per transfer
> 	    request.
> 	
> 	Maximum Transfer Length: Each individual PRD entry typically
> 	    allows a maximum transfer size of (65,535 bytes) per segment.
> 
>     2. Host Controller Hardware Limits (UFSHCI)
>     
> 	Transfer Queue Depth: A UFS controller supports a predefined
> 	    number of outstanding task request entries. This is often
> 	    hard-capped at 32 concurrent transfer requests (slots) by the
> 	    doorbell register array.
> 	
> 	Descriptor Pre-fetch: Some UFS host controllers are
> 	   pre-configured to pre-fetch multiple PRD entries sequentially
> 	   before requiring main memory reads.
> 
> Is this an accurate description of the limits that you are trying to
> work with?  How much data are you trying to read?  Looking at Gemma 4
> models, E2B is about 10GB or 3GB for the 4-bit quantized version.  E4B
> is 15GB, or 5GB for the 4-bit quantized version.  Is that about right?
> 
> It seems... surprising that the additional I/O operations are actually
> throttloing UFS device bandwidth by 2x (4GB/s vs 2GB/s).  Have you dug
> into why this is happening, and whether there is anything that can be
> optimized below the file system?

I can't tell the exact size tho, roughly it's between 1GB and 4GB. And,
per lots of test results with various tunings, it turned out memory
allocation speed was the culprit. If we use 4KB page, we couldn't get
the full bandwidth unless we set the biggest core running the highest frequency.
Unfortunately, however, we can't use the core like that due to performance
drop of other system service and power drain.

> 
> > Problem Statement
> > -----------------
> > High-order pages become heavily fragmented and scarce shortly after
> > device boot.  We cannot afford to deplete these limited resources on
> > default filesystem operations using large folios. Instead, we need a
> > mechanism to strictly prioritize and reserve high-order allocations
> > for specific, critical payloads—specifically, large AI model files.
> 
> There's a fundamental assumption here, which is that the only use of
> high order pages is the page cache.  This doesn't take into account
> anonymous pages used by programs that isn't backed by files.  Nor does
> it take into account kernel memory allocations.
> 
> But that being said, you seem to be assuming that you can reduce the
> pressure on high order pages by only using large folios for these AI
> model files.
> 
> But the problem with using small folios is that if you want to
> actually *use* the memory, unless you want to segment out the memory
> so it can't be used for anything other than the AI models (e.g., by
> using somthing like hugetlbfs) it's just going to break up the memory
> into smaller folios.  So that's not actually going to *help* in actual
> real life use cases.  It might help for your artificial benchmarks /
> experiments, but in the real life case where Android applications are
> running and fragmenting all of the device memory, the large folios
> won't be available *anyway*.

Agreed it's hard to get this done perfectly tho, as the best effort on this
particular AI model case, I focused on two timings when loading the models:
1) right after device boot, 2) dynamic loading when required. To secure high
order pages, for 1), I disabled the large folio consumed by EROFS, while for
2), I tried to call compact_memory before loading the model. Both of cases,
I could observe we could get fair amount of large folios. Yes, not 100% tho.

> 
> > 
> > Q: Why is deregistering the inode number linked to inode deletion?
> > A: We need the high-order allocation hint to persist even if the inode is
> >  temporarily evicted from the VFS cache. To achieve this, we maintain a tracking
> >  list of hinted inode numbers. When a file is permanently deleted, its hint
> >  becomes obsolete, requiring us to deregister it from the list to prevent memory
> >  leaks or identifier reuse conflicts.
> 
> Assuming that the high-order allocation hint is a good thing, why not
> just make it persistent?  e.g., just a *real* extended attribute
> (which is more wateful of space), or grab a flag in the on-disk f2fs
> inode?  Then you don't need to have an in-memory list of hinted
> inodes; instead, you can just have the Android package manager set
> that flag indicating that you want that special treatment.  This is
> all assuming that we need an explicit hint, though....

I think that's doable, yes, if the explict hint is acceptable.

> 
> > Massive AI model loading is a long-term architectural
> > paradigm. Providing a targeted VFS/filesystem hint to optimize read
> > bandwidth for specific large datasets is a highly practical,
> > repeatable pattern that addresses a systemic bottleneck in embedded
> > AI deployments.
> 
> It's really too bad you didn't propose this as a LSF/MM topic, and
> presented this at a session at Zagreb two weeks ago.  That would have
> been a much more upstream-friendly way of collaborating, and it might
> have allowed the mm experts to give you some more dynamic, real-time
> feedback.

Indeed, I was off from LSF/MM for years due to various product issues, not
related F2FS tho. Let me make some effort to attend upcoming ones like LPC,
if I can get the budget from company.

> 
> Cheers,
> 
> 					- Ted
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
