Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1E1175A80;
	Mon,  1 Jun 2026 01:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780278748; cv=none; b=fel44mgj6Cjx/Zu1rvTOQAyEHiTkVauBHwYN4qSEMHKrKf9WgiwR5RChQRE1o7mVT/Ui7G8SyBm3vQVZZObSSoGuowSQdsJQrnqbXmKVmXqcPpdwIE7dF7aRbYMj56KcHHRmfL6fS1yKW2YQN95ze4T3pp2cjtqPoF5moFKf+BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780278748; c=relaxed/simple;
	bh=6FDHJIS2M8GTEoiYYDurmOWlUc/Ls7kEkJeXBl+EGEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NYVADZ+x0aZJGHnCOK+4vQtAbx13JLhM9jjmWd1cvj8goI+8iMzF9glpXhY6nzsi+Jem5ppMBRj3vTGLm1RyUM07+54Ukl1aT7ZipvEg2mDBe6b+skpgoSP9iusht0MkGIOeL6PH49zGH2jTBLPev/fAbRCOYcSvI9q/q0pOWs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYRH/paM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYRH/paM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8DC1F00893;
	Mon,  1 Jun 2026 01:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780278746;
	bh=vZcu83wQUzh29/MUzPMLQS8Iv0nVsOwsxAWqxDDGj50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KYRH/paMfV8BeCgbYfsHMCWqDOtr++JkRKX25dlTAVmIboEGh885kBK9CuL9tV7tr
	 8pqNVZlKj2Z5eqkBjCOdCp0sLKsojv97UUmTic4Gw9ws96ZOStR0P5qLHeNR5VBGoj
	 3LqQJbi8ZclVXzUncbIJ1wqdlIzloAzt9PJuFY5D6+UiIWk8GmIvoBVVeICbzTfjsC
	 Pd4h54Ftu3TrtIx88YUPUiS7ncpHA0KUeMphtpkxg9lh+Ru7ktMSIfDkYD33de5fyM
	 gU8LQy89ioRQGwY5FsyGgbwGBRpqJv7qJ25cTr4qdLpzf66OxtRMqTcc+ABTwEWkQp
	 AbzOUsuArFnkA==
Date: Mon, 1 Jun 2026 01:52:24 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Bart Van Assche <bvanassche@acm.org>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahzl2GM1OGsBz9mV@google.com>
References: <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <f4e521ac-2381-49ca-8dcc-3cb3cf3ffaea@acm.org>
 <ahaPDHiXcJoVShPv@infradead.org>
 <ahcU5xbVy7xjps02@google.com>
 <ahkl52N3RDcusCNd@infradead.org>
 <aht812OhSPFqIBPK@google.com>
 <CAGsJ_4yJihngSY0GNcc+MwPHJjpF1qCnS8-UE1GwYoNDtEm9mQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yJihngSY0GNcc+MwPHJjpF1qCnS8-UE1GwYoNDtEm9mQ@mail.gmail.com>

On 05/31, Barry Song via Linux-f2fs-devel wrote:
> On Sun, May 31, 2026 at 8:12 AM Jaegeuk Kim <jaegeuk@kernel.org> wrote:
> >
> > On 05/28, Christoph Hellwig wrote:
> > > On Wed, May 27, 2026 at 03:59:35PM +0000, Jaegeuk Kim wrote:
> > > > F2FS merges bios before submit_bio, regardless of small or large folios,
> > > > since the block addresses are consecutive. So, I think IO subsystem was
> > > > working in full speed.
> > >
> > > As does every other remotely modern file system.  But that merging is
> > > surprisingly expensive, which is why using folios gets really major
> > > performance improvements.
> > >
> > > For one doing these checks to merge touch quite a few cache lines.
> > > Second, devices are often a lot more efficient if they see fewer SGL
> > > entries.  I.e. having a 1MB bio a single SGL tends to work better than
> > > having 256 of them.
> > > The same is true in the kernel code itself, both in the submission path
> > > (dma mapping and co), and even more so in the page cache handling
> > > both before submitting and in the completion path.
> > >
> > > See Bart's patch about how long the walk of the bio_vecs in the f2fs
> > > completion path can take.  We had similar issues in XFS even in the
> > > workqueue completion path due to lack of rescheduling, and these simply
> > > go away when you do the folio manipulation in larger chunks (LAZY_PREEMPT
> > > would avoid the need to explicit rescheduling these days, but that just
> > > papers over the symptoms in this case).
> > >
> >
> > I see. That's also super helpful. Let me kick off the large folio support asap.
> > Thanks.
> 
> Hi Jaegeuk,

Hi Barry,

> 
> Nanzhe has put significant effort into this work at Xiaomi over
> the past several months. Large folios can now be supported on
> non-immutable files.
> 
> He has conducted extensive testing on the Pixel 6 and fixed a
> number of hangs discovered during development. He is still
> benchmarking performance, but the implementation appears to be
> reasonably stable at this point. We can run Android Monkey for
> many hours without observing any hangs.
> 
> If you would like to see an RFC, I can ask Nanzhe to send one
> as soon as possible after some cleanup and polishing.

Yeah, I was about to reach out to you. Let's do some discussion
offline.

Thanks,

> 
> Best regards,
> Barry
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
