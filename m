Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795542060;
	b=wvxdfFwNVYVE6RVfGm9q6IO9ehddMlr4wMLdR6Bla4ESq1hvYchquQqm7FyjX3k2tBoU
	 JhsAINlwOinAPdy32bN/36P+Tewdh5/cFSdckETgKk4ytpg+ZncNKWyvcBA3vyuQiF4eL
	 q0OZm5z/Tg1WKOBSTlDc5kEnwIuj3KgomIG4eJwVbdyiNzB4LGfQcWSaKIq4iZoiBuJhX
	 8JbDmUhEKKCGhsAga/Y6q8YbHZF5JJhoave5ktxjQHlv1Qsf0y7/CJ2WFfMv4vuV/QrKG
	 YY4+63M21KN0u141Bc12DsmzqPyMeffntdep8BYKJaCczb0VipKGc8hmTzoGuHq0gXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795542060;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=XO0JyOCM21+vPsOjiZahLAEVYGLcNQHWZ2Nfbp6dLrI=;
	b=uAachXwc1rxNfO7KBbXbFCF5X7xEQ4Dg44ztOtUc1EWMNlSSaYaSbvIbk4T8IEZ5M39D
	 hSGIhhcw6bd64CTpRHaj+HOjmx0ksi6V4Z3Ur9+hSInspdlz4az5Fekn2177LiBN3hFlL
	 s3m1Xq/cHTtSdfoBB3MR36MP2TQy9rGFSGZsJMoJADa2qAAoJB39ZriNhj0BWmiKGy2CR
	 1Yui1jm+zdFLQ7ncmJc4mC7gRYEZyFilq8iffZsnrgtiJuKvf/xB6kJtiNEFTR6neK1/m
	 APSPVBFtVgsXrJt5/l3+Zv6uV63Rsym2vExVQQdIyJgoQoeuwa1Qq4N9Tp9vlJVWPHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b="S+/GEP1R";
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5EA606A31E;
	Tue, 24 Nov 2026 17:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E5EA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=S+/GEP1R
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XO0JyOCM21+vPsOjiZahLAEVYGLcNQHWZ2Nfbp6dLrI=; b=S+/GEP1RI0P6fXVEEVCM53z+Tb
	5c6CQnka2gc2NZ1H2r88y7Q5/GMnqpCuR/ko7IOvNDTjWGbgc55rT/hIxT9WXIWjKZwgDqRZkZ1Ay
	lq46s1/uMwyJYsjIAf3ZJZaAeq3Em7/vKneB8HuQYCY4xNZ0ni82xWskLJ/jrD3sbq2ErzurmP6ny
	eQQuLBmpqXiZSATpElHnCcqxSi/RvcvDMD/2XJaKEaQlLz+k87IP88GEJdgZ+czRvwK3XgWSBgA0d
	ybwcuD0bV+wAUQaCRNWB76km47DAFZrdFcKQaMDl4RahqupQKqgdtshs+v2RzpUxJwS8uaceab1Id
	VE6dTVdg==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xVuVh-0000000ACU9-3LMp;
	Tue, 24 Nov 2026 17:40:53 +0000
Date: Tue, 24 Nov 2026 17:40:53 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shaopei Zhu <shaopei_1012@163.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>, exfat@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] exfat: add EXFAT_IOC_COMBINE to append a file's
 clusters to another
Message-ID: <awXMJaZ58iS3K2N0@casper.infradead.org>
References: <20261124142807.773299-1-shaopei_1012@163.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124142807.773299-1-shaopei_1012@163.com>

On Tue, Nov 24, 2026 at 10:28:07PM +0800, Shaopei Zhu wrote:
> As with EXT4_IOC_MOVE_EXT and F2FS_IOC_MOVE_RANGE, the source must be
> open for reading and writing, the destination for writing, and both must
> be regular files on the same mount.  Files whose allocation, chain
> layout or valid_size are inconsistent, as after a failed truncate or on
> a corrupt volume, are refused with -EIO before anything is changed.

Why are you designing your own ioctl instead of implementing
EXT4_IOC_MOVE_EXT in exfat?  That's the normal way of doing things as
it lets us later hoist the ioctl from all the filesystems implementing
it to the VFS.
