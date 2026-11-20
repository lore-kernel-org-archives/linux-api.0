Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795185378;
	b=4rsm1foqnkpu+T54GblDZWTH64ZsrcvUp+CzjnhT85jZVkSUX3w8uZrU1cv4NonVLLWz
	 xAjZ3b+KMOLRa9As7hWYgrkzwJWCbB7M1ejM0uMpBwuRjL0Crr6O6498CG1HW7hq3Hd9x
	 YpQ1Sp//bdqpRH7uSK63qsRZIya68IbZUiY4ZmqIu1+xCZPtzrxQn+FNZkdDWrARGNZOl
	 FoiAUSS7g332dcXjghKXNwD9lHjNXbp49wIqhOFf+iDeXYzquF8C7UHZiCooTnIbRXcUP
	 0vSqWs6GHbYch4sB8KSc+STuL3Qobx8vfKzZpTbv2kE139CfL4+20glcVgRkyJrMxkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185378;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=aMOyn5lZK8F+FC2nwU9eJQ2Ic0u6hcRi/jhTZjj9Mvk=;
	b=SXbV2UmOan9DT0ZkCT6fAX+8M0In42eG3MPoqKJ+Ti/EbDZ0BdKuqYlaRxcHqj3qFZIE
	 WV6Ps4CHTkT3rTdg3CHME/D6b+qbbdfTqC4qpAnK/+lfUWG4ufGlI2edMJRqFguDfYVPb
	 2gB/hB7w/rjY/2kNKnldwKkgdfdXUjbbHXWDIVkHVDGMM+Y5a4x8SnjFWrxvZ9BBqIDLl
	 0sOq4mXgnAy9zqBpdagCR/hBZkiEJ/3oCH+fvFwBq8wd6MGKjERet6tWJAsr/QlTE+4Vj
	 gemtetjuOGn4Q2VMRTuL3ViAlXNlsDQ2aZR7hnKcsJ0o5x4VeyGi1qKekJG7bimU8Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="RF/8DK12";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BA5606A320;
	Fri, 20 Nov 2026 14:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RF/8DK12
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634851F000CA;
	Fri, 20 Nov 2026 14:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795185377;
	bh=aMOyn5lZK8F+FC2nwU9eJQ2Ic0u6hcRi/jhTZjj9Mvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RF/8DK121mnm1zavjVGPB5fyWIqpsPt3RkMcjQSO7nVuLPyzhULSY7VJ8tgWd92Wp
	 m5/EkyNoU7Wy4FnigM6acB0fR/zU0d3cp8AC20ZBhGM89M7sbu+VtMLyw7smiDGJ7o
	 qmEKeFVaAhuRrAiQ+TtwLA1QhlytBk+Rsa/JEFprCx9SYgRIT8gVSpAjDxclmIO0rp
	 GLaWW4nrUAxaPB1Jp2uViccsPQI9r+3tNEFsHjAkkI8hAsb+Y/lNbK9SIufkMhzsWe
	 1kZV6p0c5oYrljsBgA65aUmPYzUz4Xzgg/0LNXnoqGa/PAie0cI8Ui6afRuhiln2Dv
	 Hox4znu0xNXxQ==
Date: Fri, 20 Nov 2026 14:36:06 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Luigi Rizzo <lrizzo@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Simon Horman <horms@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Christoph Hellwig <hch@lst.de>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Naman Gulati <namangulati@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	netdev@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
Message-ID: <awBaxljohIuCg-UY@gremlin>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120135013.GO3115493@ziepe.ca>
 <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>

On Fri, Nov 20, 2026 at 03:19:34PM +0100, Luigi Rizzo wrote:
> On Fri, Nov 20, 2026 at 2:50 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> > > This is v3 of the RFC previously posted as DMA_PMD [0], now renamed PISA
> > > ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> > > Documentation/core-api/pisa.rst (patch 25/25), which has the details.
> >
> > I thought the conclusion was to just do this stuff in netdev pagepool,
> > now you come with an enormous AI series spread across the entire
> > kernel?
>
> There were surely comments claiming nothing outside net/ cares or needs this.
>
> I respectfully disagree, witness is the fact that e.g. there was already an
> io_uring proposal which is smaller, but does not address applications
> that want to use the standard disk I/O paths (libaio, buffer cache etc)
>
> Nothing has changed from the initial series in terms of size, use cases or
> subsystems involved. Large files are placed where they should,
> the series covers the same three use cases (disk, network, CoCo), and
> touches three parts which it has to touch: mm (most of it; it is a
> memory allocator
> extension after all), dma (it hooks into map and unmap, not a large change)
> and net (the pagepool change is a couple of lines; the tx path needs to
> touch more places because the current stack assumes all paths have
> the same I/O requirements).
>
> For CoCo, there are very fine grained controls so the bounce buffers
> can be enabled only when they don't pose a risk, which in turn
> depends on the threat model.
>
> Specifically, for network tx buffers or disk writes, the user-to-kernel copy
> is basically a bounce buffer provided it is used correctly and not leaked
> elsewhere (which is the design; of course the implementation
> needs to be verified and possibly fixed so that it matches the design).
>
> cheers
> luigi

NAK.

Cheers, Lorenzo

--
Cheers, Lorenzo
