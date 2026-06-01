Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D683DD53E;
	Mon,  1 Jun 2026 17:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780335213; cv=none; b=gh39mq3gW7O4Fqd32aQ0YedWoZTtOTUdw3Xg4/LlRsacaLof2pSLLL8gR4hB9kZyT+4nvwsBj9utWPSBSJ3R43AK/6qzfydoAhAX4QJc+YMAQNcZF3VsXSkcCY1ndjr8KSVDxPCtOumKz/Qf8gBC/qq7o0SjXGx9mV7hXachfy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780335213; c=relaxed/simple;
	bh=UIq0QwS9m8Vn34cqT2JX2YbbXgMu17lIdfl6g487i/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XdkILFnRMUyVLYYjy1JgCGNfL+IQi+nzk0IcBHlDXFnETw5m3BYktdDARhD5cqEPFEHC2bNFI76pywy2aikqy3nxhb/j1f4jggDrCHIl4vj15363AWla2IWduT1NSerdQpMLpAHLiSTXnXQnHSIrbERj63x71S5oqZYT/RinF8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=C4F2CJUG; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="C4F2CJUG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UIq0QwS9m8Vn34cqT2JX2YbbXgMu17lIdfl6g487i/A=; b=C4F2CJUGwfl5xKazpWoseKj1wE
	WRgOlgnpACsA11o9vsmsB1IEgIxOgcMlpETmH2q+Pkmy5QKe6KOUTqNF+mzjFAZmW6fSabyetV2cW
	sg4PJwBvnYadtSQUsssgLJfv23FCBmBzKfIJqAjEkjJ8j6aMfSc6ff579wCMlKgyGVa+578BhJf+3
	aqYDiA+xagJzyAsdmYZ+Gofucv2YCBS1b4uUF8Ws6ne0a/OJF3nk0dr/nzPgMKLe6ZYQlNMD2P5vh
	7swJk2/OoPqvxRHMKexP/fcSrQDpePjfupzXW1wLMs+uMptCrx8erMt988UpqDtoAY4rWS8q83sDm
	jWgor8qg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wU6Vx-00000003Mll-0wOR;
	Mon, 01 Jun 2026 17:33:25 +0000
Date: Mon, 1 Jun 2026 18:33:25 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-api@vger.kernel.org,
	netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260601173325.GH2636677@ZenIV>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:

> TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
> a big simplification.

FUSE might be interesting - fuse_dev_splice_read() and its ilk.
Communications between the kernel and fuse server at least used to
seriously want that, so that would be one place to look for unhappy
userland...

splice-related logics in fs/fuse/dev.c is interesting; another place
like this is kernel/trace/, but I'm less familiar with that one.

rostedt Cc'd (miklos already had been)
