Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AF4330B01;
	Wed, 27 May 2026 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897579; cv=none; b=PRhA96na2bJGnC9RtFO4d+I4+FUfR7uqGlLuHD7UBdPnGhFC5Gv14bH3R0rbWYLEpki2lM3jUnWnUIfJML85iwcvJhebZUnwrqSRl7GAfp+VJyC41Ggq3Ty2fnQYMk6GdcfwPaycW1QIp0bHZqy8ofzHsMMmffvnoGk5OWmJw4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897579; c=relaxed/simple;
	bh=93hGzeUNZXSmgPP5rRVCOqylEsp/Noq5x/ntYlDk91Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xnxuog08Msp3H4b6vU5bK368v3oysKUYP66PK0wLnn4YFyM9NfdIrQdvClSghZO0+fdMCpWxIS82jDMSOs3KJB9Ky4doC7nW1BlaaLhTumXxfVzpr8lbxY9QeoHep40ZbTgSivpprJVK7oXxs12hG2MOZR8C/RX8kcXKXzmnzsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYqc0BD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYqc0BD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6866E1F000E9;
	Wed, 27 May 2026 15:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779897577;
	bh=ky5x6VV8bGsiRibL4Mbeireh2/3HHtZ2G1qotL6tKkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RYqc0BD/c9Rk6VG80/Ku4juq+/5NhEA9655oRwH1Wmuep9DRWmqdGxTBZaGOAbx4c
	 tAWp51YEvq1+8lth6riLToTePL3f5jhd0A9B+eajyaSW8fHPYWYjSs9849zYuwPqKi
	 SkmrQ1Sj73F1X2nwofk44uZKbCtcjtNxLKSdqk50qPKRabEVz9ZGdCeRb9P/jUX7Gp
	 ROw64V0uXEJeCATrY80FENgdTyVVifxFzRe5FtVsGqwU6po13npcbonInSgIoCh8L0
	 uwTj53KmkgZ1MFEdp8hsLXFebtZo4DHZROQbE1pFiS8JcRGFroxsy56nkfPhdv80xj
	 RmK8vLj9DyWvQ==
Date: Wed, 27 May 2026 15:59:35 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Theodore Tso <tytso@mit.edu>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahcU5xbVy7xjps02@google.com>
References: <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <f4e521ac-2381-49ca-8dcc-3cb3cf3ffaea@acm.org>
 <ahaPDHiXcJoVShPv@infradead.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahaPDHiXcJoVShPv@infradead.org>

On 05/26, Christoph Hellwig wrote:
> On Tue, May 26, 2026 at 09:14:52AM -0700, Bart Van Assche wrote:
> > On 5/26/26 6:42 AM, Theodore Tso wrote:
> > > It seems... surprising that the additional I/O operations are actually
> > > throttloing UFS device bandwidth by 2x (4GB/s vs 2GB/s).  Have you dug
> > > into why this is happening, and whether there is anything that can be
> > > optimized below the file system?
> > The layers below the filesystem (block, SCSI, UFS) is what I'm
> > responsible for in the Pixel team and I can assure you that these are
> > highly optimized.
> > 
> > Since the transfer size used in Jaegeuk's tests is much larger than 4
> > KiB, how many CPU cycles are used per IO by the layers below the
> > filesystem is not limiting the transfer bandwidth.
> 
> I'm honestly not sure what discussion we have here.  Larger I/O is
> pretty much always more efficient.  If you submit smaller I/O you
> need more merging to build it back up larger, and more I/Os.

F2FS merges bios before submit_bio, regardless of small or large folios,
since the block addresses are consecutive. So, I think IO subsystem was
working in full speed.

> 
> Which is exaxtly why we need large folio support everywhere, as it
> makes a huge difference in I/O performance.
> 
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
