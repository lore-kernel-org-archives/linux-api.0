Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF8C35DA6A;
	Wed, 27 May 2026 03:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779852661; cv=none; b=Hp/DQWr/64XU6eYQzzZuQD2MsCLZbXMBPrQf4h3W91j2BQU+WFlbIJAwNkwqVyP8iSZf3DfctmDP8iQznQkpxGA82GFNWWODrArJAlE1nHOFtntbJP9oedr2GAuiF0xIYULhTTTHecqh0FetPufpSUa40gqqYQa5atORxJqp5n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779852661; c=relaxed/simple;
	bh=8KnJNIZSTxkfTpESO4K1xbD7YUOeugFgPMsuinpfP0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R5sYfIbG/v50VAOrMt2JVnWzMKput5drfT/XTYhYRJoESOQ1uDk3uaE9UguW4mBChs45MUsx3DERSTBmiQcKKjZLNZp/BtFrf+sDcIVSASOgq7JIUQrubl9UxjJARLpW1DszX191Ses9+kmx9FMn72QjfAd1jcUBMrNFIlIZsBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SzjMDLXV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SzjMDLXV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FEJmjXL2EjatPDpj2uMZTIF3mYzVfl1EpI149sPwX1s=; b=SzjMDLXVYmez33PWlioTW3LcSA
	VYfm8lb0dxWyTtKUEXzvQO58VzLd8uZ4A570kIRTn/C5VAfHG5uTI+QTyZlW3WFEQaocZc+sJe+6w
	Dn2IVlbhEmFmRE4Q8gzB4Ig7t0zyq9SP1CWxblCmLyGSyJ6LdmicLI3DvHwBbc7U1+vL453bCEcml
	GazXwnM826IKjic6pIVVwwD0LZ43zntdbgpySyA+4oyJ+v4d36kiZLysUKYHAu/d4LL1hgzaGEC44
	JXSWfpTjZKZLn53sxEolzqYvOlZCFwNi2cN+dKIPQv0K/ZWMffc3WLR+uBHJ/w9F0+cGeGUBlOttu
	i24CpnPQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS4ys-00000001quo-0A9A;
	Wed, 27 May 2026 03:30:54 +0000
Date: Wed, 27 May 2026 04:30:53 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahZlbQPzTUecMKGU@casper.infradead.org>
References: <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <ahYWKH9-ybDlZuJd@google.com>
 <psj3kr2gcze2yll5xdbvyyzxwcwhds5gh55poobpkfxrkpbgr7@ljdindismzd4>
 <ahZaScMpx19ZLQi4@google.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahZaScMpx19ZLQi4@google.com>

On Wed, May 27, 2026 at 02:43:21AM +0000, Jaegeuk Kim wrote:
> Thanks for the context. To clarify a piece I missed earlier: the model pages
> are also utilized for inference. Our data shows that larger chunks yield
> higher inference speeds. Consequently, I required high-order pages to optimize
> both read throughput and inference latency. I will halt my current efforts
> and wait for alternative suggestions.

I think your efforts would be best directed towards general support for
large folios in f2fs.  There's still 40+ places in f2fs that use a
struct page, and converting them all to folios would be a great help.
