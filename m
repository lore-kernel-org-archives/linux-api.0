Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795198625;
	b=5h+yfFQTjRLiM1b18fbXqQAV70bHUHuKhrFkF0QZpxLCHUpBVutF+VKHDdNoHSsdjNIS
	 EeOaw4nmZqst/2hyPN5Wu3PrwrNWXIJrYk45vye7o4lL5vcWBvWIm5CAos2ql76VPNbBe
	 f1+E08NPNdq4s+N5nGYHVt9iOB57IuDtHDkZ/DfFfX3M/S2lACiC3dVnMfXVLP04MWCvY
	 vLVbbtjh+AFdhi5Xx4luAFHS6tiefkIKMX/6hatI4yqBwsUdnN03tXGB0G6u3+3JuOV+W
	 UWtX0R3DDUJ4Ut0ixoIEhFQ5ph4naCw9t/urmJ6lZlNh4AV62+UlpIvqEt1BfqWFsAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198625;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kHnPkHdygJLWUd6Raio1OZlzrSr7Mg2iPFJR6vcJsn0=;
	b=zgPXnpDV6SoTqwzntHhzHeShTUtCoxEh3gdckCaR7rY6Ld389L7w032nbK1JDr3EjxRV
	 atY4PQzt0WUXR0sotbREfXEsAjkRbK6YgFc8yC2lT77BwXXcXZcd2FH0xmrOWo0d/C1UY
	 nY2m86w2ng/t14zr06AwRrbLJCVZOuWm2Dg8971woDWizR0sntlWUVMPZYezxBEQTJwnV
	 ROcKUuyRiW4YndaS5EFYQ8SP1DNczm1ALiG3FDhmg4/p2iFy0wUlZhlrMBlJ/1o28ROgU
	 wPaS6fz/5FS1cWC48214LhV5s8CS9YX0ykQytA5BN2OgY+ZK4ZNsaarDFcxApSXIhLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FDZ1T56E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E062606BDCE;
	Fri, 20 Nov 2026 18:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FDZ1T56E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22F71F00A3D;
	Fri, 20 Nov 2026 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198624;
	bh=kHnPkHdygJLWUd6Raio1OZlzrSr7Mg2iPFJR6vcJsn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FDZ1T56EY/NGSZoTmntCLex0+4xeE8PucuiZ4OpXHfBdGoiLzo9IrSDqKpJcWcAEx
	 HknAu50zTJt9dXHaiwcX0LMuj3DCFHLZKTlZ0YSp49BB1UazfGAdNiorcEbNBdAlE0
	 Jm9XmV45fyiwhBKVkrrMsFJuZMkH80dEj76iDZAD5W2/MMLs8dD601KcImYLSCmqnA
	 RsuHa3JuDXI8q0CnuESnUy9+uoR0ap/AR56Kh1DZuL9oQd9rYo460sqP0G7aiGVMdG
	 ikxyOkxyt/pNSE1U3xl1nLM3UxG/UnmmNBmnk44dmqDb2p3sgftQKUtl/+bp4ieAy4
	 ZzkCSKckENgFA==
Date: Fri, 20 Nov 2026 18:16:52 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Luigi Rizzo <lrizzo@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
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
	Alexander Lobakin <aleksander.lobakin@intel.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Naman Gulati <namangulati@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	netdev@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
Message-ID: <awCOitDwwIoz632b@gremlin>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <awBYFhnpFGtEXZ6r@gremlin>
 <8c9bd441-db5e-4857-8e39-79f147422454@kernel.org>
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
In-Reply-To: <8c9bd441-db5e-4857-8e39-79f147422454@kernel.org>

On Fri, Nov 20, 2026 at 05:12:25PM +0100, David Hildenbrand (Arm) wrote:
> On 11/20/26 15:54, Lorenzo Stoakes (ARM) wrote:
> > TL;DR: NAK. All of it. (And yeah, I'm steeling myself for the inevitable 'oh
> > Lorenzo' :)
>
> Oh Lorenzo ... you are absolutely right.

:)))

--
Cheers, Lorenzo
