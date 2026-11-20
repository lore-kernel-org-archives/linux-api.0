Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182618;
	b=5tewALm6nlu4zn4rvX2VRtDiT/rXyujhknr71TGPA+mb5fXtk01DOc3kSJMklwGfZfXY
	 Akfo8c8JXGubopdSuFc9t7znU9HWqbDYE8WSJiDlpj9icedyohzOaPJqtwoh9pRBTpCii
	 edZQXqzoLd0Hi6rwc5JxGQao6AQbvBkb9f7eXO7CpkgK/4Dea6DoTAd+5TVcl9NxvXGfZ
	 o8HOd5hHMImBw/nH/pHGjBtoslyqdrWZvD6yWnoHxECMT8mASbpCiT/4rKSfeM+gdbKiv
	 yyCg84BthuWmW+Khu5PYKySNV6fStjHl2DEyenhcI0YN1s3moGYHvFrkFuCgsoaLxcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182618;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=uU+g78pFe3woDmujMNPfhZ/0Qi8mHsxDvK4Ws3nTpkw=;
	b=11Ux7B3yt5m9MJ6TC5NwXLHeCPQ2GZrO+Xkia/2XZhdyHJEtciZqajnnPoN8bNq6Yfvo
	 LO3qgnG2zFlD7f6ex1SyecSJVIROKwqiEe6YDzpoo+IF4gpwH4fmsE+4r+eFXYdU1Oba+
	 XIfCQXVPmB6hxe3OVYd2dUJxggQrInBn6kHEMrlyer16+A7i7FdDs06dsklx4O97UqK9t
	 sQjz7jgTyIXftR+mBZNUAa/suqtDN6/nOXbR9N0MNzznlEs98cCW0mhkxnTzfgDcgYGW5
	 LKz+vix56TCzvUlOuHtTs56/UVFwlHaxQA5X+lcUO1g7PLLtyr5jJar3BRpoRANjG7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=ehz6mMEB;
	arc=none smtp.remote-ip=209.85.219.51
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92041606A337
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 13:50:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92041606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=ehz6mMEB
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-92125687442so5602936d6.2
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 05:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795182616; x=1795787416; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uU+g78pFe3woDmujMNPfhZ/0Qi8mHsxDvK4Ws3nTpkw=;
        b=ehz6mMEBp7FU9O4IkG6ucYOPrN/2FptPlSVzAMegQhkSAM21Hz39XQX76haUWfk977
         A2S7LqWAyzQ/MMpQcJ9hlw5/i8t5QmFoKEbwfS2++6OthszxDFhEwhu48SFckK+V0pvW
         ZrB7pLti4QW/zlyDdG0NHqvUQqc55WcUlTDasvdx4/7cbllh7O44dOopIvf3GjZWbJGD
         Hp2pPFYqt09CILTVYoO85olovSxlw20uhMs3fEFAaJjWsbuz4Ruyjz74FAK8xTbPsjJm
         YNZjjLR6Muw2SduJu6y83jD/L3yp3ZXbUhG9xHOIQjqowZufFq2KjlStO23Q1v2+do05
         Ehqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795182616; x=1795787416;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uU+g78pFe3woDmujMNPfhZ/0Qi8mHsxDvK4Ws3nTpkw=;
        b=yRkxG2bgepYm8SuE+xNOYeG6IgN8SWugK26lWwmY7Z7f4grUKJg8beNlXeQ1S/PDho
         3dfOr7Yy1UVBTtPWPpGnsD6+cx23BIcL0FfRlfCRSMODH6Qo7o4+OUnx6HXPNuCrQ6Nh
         JXYU5SFPRNzicjURlBYB8/YRRlVUtRo739N6a+TP4eLotGJJ4Nc47PwQdXKLiZNRUEgw
         xanPjGmwKAyqeGsai6j+5sHOEF3A11Sr/O+haKipTrPDObzTp3zssUjbk1FFeT6Enr0L
         aC8yGP8BqNBwbQyuM4IS+Sn/dQzXCjRjR/6JsrgMD8+GElYt2K8kSXJC6DlICiJXzyg6
         8Dqw==
X-Forwarded-Encrypted: i=1; AL+hErHbtPEPKNif5YUM2jBPF/+l9KZYOsGpiysedTPURWaYVksKoPf8nfOhqOZYxxxIlg0LPg+V30xwtWI=@vger.kernel.org
X-Gm-Message-State: APuU4Z/gtB1p0gNSCC9capnClo58rI+he5rhrS8ZfJXo2bsvU3Mq4owZ
	ATs1y/9lMC/hKKDc6ykUGbJCwyN1iuAdq2GihQ/tSjxupLR2xIpiG5VYEMkwdmV1N6k=
X-Gm-Gg: AYBFou3yaIJKRoyJMIfLSwK4oZ5J/tE6tAsdjYXx+SUkSoZvvcgRoDnEmtYgyZ3/sCt
	WdTKfOQ/MVe7P0e7o4vZlSLQZ2iHyyXu9fltomHpQUt9GqrrqXVjeKP0vywf/yFAtz5JjJbD/jA
	CD2YQnmZTPIYJO8+q6+T+nuN6wBZXS9L7VYj9hXYvWZBsOqBjQ9sjTLrD+lYVOFIoXbZfZGde+E
	UfunGFbVZSY7VFCiLgE3WNxvj+deN0Wn0MfhGGHVoTAFsjZBav2gCGVFExyYXUsG81/X15CwM1B
	nOwvopF7L+lwAvBM2ctUSKSEmWpckcJBGL5O5BY3QaSFa5IOTJDgiz/1Fb3n4Fqcl8hh/hgf3t1
	nhfA7g5GB2egLEO3mLc7/OZ2NXoPxchDxOOSINuYtXGL5BBsNb6sEO2dHd+woetmyIWrAQkUCbp
	ZoxZQ/VXf81I4y+euXSxOG4rrar283x1tSaD3mM1b5WvO3td6hpG30u1eZRuoW/0g81RAlvsRC2
	rohw44k35qP4Z/YrVsYq5TN1HR9s8EFfqOy39SNwh1JKss6iPaYrTTFNV8p4+wkjQ+ay9J9tZ9Y
	E6nZCw==
X-Received: by 2002:a05:620a:4111:b0:939:5cd5:e243 with SMTP id af79cd13be357-949ba80f8acmr491343985a.6.1795182615989;
        Fri, 20 Nov 2026 05:50:15 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb3f7cf3sm190597085a.31.2026.11.20.05.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 05:50:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xUP0H-00000003hHG-3ovL;
	Fri, 20 Nov 2026 09:50:13 -0400
Date: Fri, 20 Nov 2026 09:50:13 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Luigi Rizzo <lrizzo@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Luigi Rizzo <rizzo.unipi@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Simon Horman <horms@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Naman Gulati <namangulati@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	iommu@lists.linux.dev, netdev@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
Message-ID: <20261120135013.GO3115493@ziepe.ca>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
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
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>

On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> This is v3 of the RFC previously posted as DMA_PMD [0], now renamed PISA
> ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> Documentation/core-api/pisa.rst (patch 25/25), which has the details.

I thought the conclusion was to just do this stuff in netdev pagepool,
now you come with an enormous AI series spread across the entire
kernel?

> - Needs bounce buffers: in Confidential Computing VMs, PISA allocators
>   pre-decrypt 2MB pages in place, avoiding swiotlb bounce-buffer copies.

It seems this was ignored too. We want the bounce buffers in CC. They
serve a security purpose. You cannot loose control of the shared
memory buffers have have them leak into SKBs, user mappings and so
on. It is not secure.

I don't see how any of this is valuable or necessary for CC,
especially when we really don't even expect to have an vIOMMU for CC
very often..

Jason
