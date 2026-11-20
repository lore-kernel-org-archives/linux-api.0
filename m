Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795184305;
	b=0vS+JTmHYJtrub7qCS0+Vtxk1u1ATSXGULfVSMxdnT9LVeuc5/KZ72dArS9n5JMmmWgc
	 lK2SgnNtW+g+XkvOCB5/bA/aEsEq8uYFtTBm/hYqBxmBFzrs8JeegUZ6gSiNNhK9V54hP
	 JBLTPwHrBkd4pxa9UMdR2WAVXOtiM7ZuoMCM26CipKakcvWnSFxpPWw3L262OD4JRX5Fx
	 02Kk8RtxuJAqi78cd4NKjs2m4LB8ObNKs6s6GbRTTwyqo3aw9nhQsrFSUv+W/0LGrtp13
	 3vqyxGigVwEATEQ8KID+pJr/FSJjHpKO0Brl0ivOOlrdxvO116DPbBPDHl0sUujHCCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795184305;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=R+kufEY/E+bsc6xg+Ks+M0qb/1tUkGUpCidjOKTYsjs=;
	b=ny6vvhxRBxk2xFCEzv0FbJ34hfssNMx6IqVrTV7oOcosRlhf9i9X7S6b2EoTxn0a4r2l
	 GPMe8TTm8empAqSrNFJt5B5pI+/dCrx8gm+3BblMuJN29GAVcBlPLLa0UDrLl+7p43t7P
	 Z4Bn+q6VEcrRlhzSbKEtX2/N6/Ajj//BOyfibmIvVIN1u3WfCeg5jvnoOHmpeooX++8+C
	 j1M/PdVeARzD1noXw449ffDqK0grnWSF0xjmgguOk5FokZmRB7zj3Y8UjssVT9hQUo6BF
	 Q2U5ujryNjJICikFw+mVWmPhQ7QPTIXi2EfJWEEwGccxbkf+uvF5o/JGaAUlLoe9l6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hPYT8FF7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD3E606A325;
	Fri, 20 Nov 2026 14:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hPYT8FF7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB5B1F000C4;
	Fri, 20 Nov 2026 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795184305;
	bh=R+kufEY/E+bsc6xg+Ks+M0qb/1tUkGUpCidjOKTYsjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hPYT8FF7iduFPkJ4iHmWTYzFOXIDVjVzsgEu+b+PIaVxd9rAbDZrkqDn0kvaYa7CN
	 TS3W+Fq7q1SDsZlwymg/X71NkiB0i0GAuYomWvK9HHLnEpKBVxyYJkjNCh2By1iSbO
	 0BtO1ijL7q3ouf7vvLuY9IcTbRVjJ4u6ueLEGNarQU/g+mvyQVKhaMHy/0Ep44opf7
	 JXOGp5ka1d+UYKQqTGGI/z4Y/OX3i2Wm5IDwZgMeNY/u5r8cW98mbVVeu3i49CXM7a
	 /DdbQ8Ua13zkOR4LPXDQFcKeYYXccQJ+ogXOG8CW1kI3GdMEK7Oxd5II8oOmlPAuVQ
	 RcfxGTUxzc2qg==
Date: Fri, 20 Nov 2026 14:18:13 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Luigi Rizzo <lrizzo@google.com>, 
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
Message-ID: <awBVBqaPDmKXXHom@gremlin>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120135013.GO3115493@ziepe.ca>
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
In-Reply-To: <20261120135013.GO3115493@ziepe.ca>

On Fri, Nov 20, 2026 at 09:50:13AM -0400, Jason Gunthorpe wrote:
> On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> > This is v3 of the RFC previously posted as DMA_PMD [0], now renamed PISA
> > ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> > Documentation/core-api/pisa.rst (patch 25/25), which has the details.
>
> I thought the conclusion was to just do this stuff in netdev pagepool,
> now you come with an enormous AI series spread across the entire
> kernel?

Welcome to 2026 :) It's so exhausting.

>
> > - Needs bounce buffers: in Confidential Computing VMs, PISA allocators
> >   pre-decrypt 2MB pages in place, avoiding swiotlb bounce-buffer copies.
>
> It seems this was ignored too. We want the bounce buffers in CC. They
> serve a security purpose. You cannot loose control of the shared
> memory buffers have have them leak into SKBs, user mappings and so
> on. It is not secure.
>
> I don't see how any of this is valuable or necessary for CC,
> especially when we really don't even expect to have an vIOMMU for CC
> very often..
>
> Jason

Agreed, this whole thing needs to be rethought.

Will reply separately to the cover I think :)

--
Cheers, Lorenzo
