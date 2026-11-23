Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.128.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795456255;
	b=zn+No48kLrN4e2JzkZCtB0kiIqLIGPA/sWe62MO/ioWI7mOnPgfuGOnqVGfSV4vuCPA6
	 pCEzsgA0OmXBXGpPTKPxnu2fFMJnIco1/N1yKIwiCQKfmyrHL90O/d0VACsgGLfjyTIbF
	 CLgZ5Kp/Ws0BF1Ihpu0oPrT5s8ok1BmYcFLXuV8g4ai8IpjMAAPnUAB7PcKCIhwU7QdCY
	 GIoDZQqHVVrh5iAEgR1rOHPvfj85PTLXfgonYKw1/9UHSoyRs1cBroV+k/HMca6NNKKjl
	 blvCSZBw9H2qzhyxjKPINXhBGyLktVYOn11mNfbTeuQiq3GQgy4g+fnIt0o4RL66gfA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795456255;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ezlDWRMj9kmxxJBJDvLQDaV+rNJm+P/qJAKPI2Vbze4=;
	b=cC6XX0TcSGvCs7nepRRJKSMqLfyJKszqRciJrik9nGOiT5iIGThRLJTA1NiOgXJIgmez
	 sQi60nIQDt+5ybnOb2qw45yrXxbKMOO8wQfvJbxiCrsuz5DmFs2Q4XMeItXhPbisokqbY
	 E62+mH0mdnIdgxpCwCIRMxoeEyc/lpduvgEXFepYHy465WeYg3D5rDHg1my/e/YGsq79p
	 pLqE1fdcVpFSnbNRfDV331zRbHJuLSXa/3nPhEAmmfMnF//PjAgaypZmaqFUbmxF5fIYp
	 ncSjXeefqfRzo3ilSill+YnPNpMrWH1WwooVy47g99kje4yERxKT3Xk6/2uEMS3YAJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Rw6Pf2ZE;
	arc=fail smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F12606A31E
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 17:50:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42F12606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Rw6Pf2ZE
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb6860f867so102555e9.1
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 09:50:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795456254; cv=none;
        d=google.com; s=arc-20260327;
        b=FrsazL04bfDaoTMwPthRLxjpsRq1h5lhW+8mIGKsi2FNfJn1Y4xSh5JM9Zv2jYHwME
         Sv9KcqX5xDAbiGYZb0WFlcK/88lb4WkNPJwoBeItqu7WDrwvKJKrQVQzIwBiQlw59u7D
         o2F7Ft335s4J1mv67mm4Tf8Re8tQ+65d9phvC+n3t543K1rEK+P2tpJ4HiSlP1qht6M/
         3TOA5gZaCoavXSanvKuF78f7y4gEjcbOmxat2ccDliqCHw04IXMDbkXlbt0gKN7Q1fMY
         waQpr+w5H3l3+6GS0NcULeOXULBCe2+uhd42biLiVByYBDn/FdCTNGv3vHLkCBRKmfDi
         Lg0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ezlDWRMj9kmxxJBJDvLQDaV+rNJm+P/qJAKPI2Vbze4=;
        fh=IsoqqEc5eZCRMhQxGb47c7kESGV1ksy79c4jvlIsS3M=;
        b=Kv4KNsWUF3AiedwCjtaLk3f13bgp94iL9XiAhokn8mmeFS+SZJQXi4jWSTINYuKYyU
         LnRdtj/0r/o3R6LvaPXndnxhUItWBgwuQxGkVioS1gewR40B/r4duXHA/B4VT2UCYLqF
         w3x3XyRvZSkk8oARdgcZFqsefiAuAnHoD9iUlUxHc282+EUYKPD37+HkqaM5bBZp0Qpn
         armfjZwLu+6h65jBRw+1/cyCIhRD+KXQzI8NQRVnLNl4GRphCLNNDIhDS6rrdCu/gFu6
         SClIOhrIHHlfQ5jbdhqMKAqId8LeK+j8B/9UVAE1W6XYRD8+dxqf/+LJDbwloiHS6yYm
         QuWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795456254; x=1796061054; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ezlDWRMj9kmxxJBJDvLQDaV+rNJm+P/qJAKPI2Vbze4=;
        b=Rw6Pf2ZEwkI1UXO7urWIQFYldmXs8W5N8krS6E97FFE6mZKhIHwUDIn10TfS01gjv0
         2ad/qxb2eC2QJ2UwmKmpX8g2xrOhdsb+6+H6gCquaMukF9SRNBjDmZHbmjQIwwKtRQiz
         4OnUASOkQ+gEQPbp4T/4aQR4JKBPgDMoGv8nxz+UYm2NOW8p0PGH2bBJwz/WImNU3r1U
         7r8Czk+/KdZ24CppBqkaigsCmxPO9BAkydO5jrN1Xf3tfO/6af1kY2RhTIaGc/+at7nS
         QY++jE75t3ZW+U8KeoNEjOh2ljFPeod1xGq4fsrYeZNmNMxs/loEagZUSbz58olNW7Oy
         5/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795456254; x=1796061054;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ezlDWRMj9kmxxJBJDvLQDaV+rNJm+P/qJAKPI2Vbze4=;
        b=y5Bl/+/NNhtsrV6f38HuOKeDXBRkC0SAeYXxSIZLQ/GCah8g+rWyki1xF2VIMuj9gp
         ER/7CXp6wCZ+kNiJsFn7g7itd1DPCP6ho4JcsUdNKzHm3VQYttJTEFMyfcy9ZUejXmZA
         O6ZWKTctqAR2oFfwHUe7rgJ1mtn5vCATOX7qjCUhYlv0+sYHKR81vSlJ3vih7+ghdbUn
         SwqO/Pr+ISWw8fLkjb8yg+hm64ws0yB1Eqszxs9cJlQchEiZ4+l5lkeyqKBDhI5oZYBT
         4lfyRaITKE8rufgWKUyoO04qajBB4w+dKWxonXZCqLoN/8ZrQa5PWOnoVhyuSnMaGmfh
         I7GA==
X-Forwarded-Encrypted: i=1; AL+hErEOvqcqp1ZlDYN0JCxiVIXglDZAY9TvOGgmuKirm2+6ZUVrXLi9gQfZhpPgogXBqWYbsN759LkOUoc=@vger.kernel.org
X-Gm-Message-State: APuU4Z/cyPNp/VS0pfzDg1FOPIIBDgQcsnutS5ZwwgeBVLNY7EpzFkKC
	9vQHW0B2h+ns6Q/JxfeaJ2Y8f0vLvZLMcqL4jkx5/crw2GHV20cWE+Mf1vuZ71DJcT3ucCEc5kY
	5bTY3i6uFtV2QG+XEIMq++K+6owAwxdFC0taz41O3
X-Gm-Gg: AZFdTZfEgHsbL+vrsXxWz+zN7XCy9pP3w2LHdOIjC+bdcJcFZEfYNOrVTOY6omsqaz3
	tULmdxRdHLVmpQwaTjvKPGTtpXogx0fUDM0Vgli+q2OhnNA2YcF7imy5m0E0AQRwj3GEwYvbYEl
	IW+wQ2vwow1mbboDF7oZ689nqSkLQ9QuKqYWI8dOhKj6BzY3r8oNSaEtA8oSjzGXXk8GQYMnmsX
	LN5OstJ8imzHkUKeXfqzMudJmnCbrEfIiXc/ZCeydIcF+TRr16T4rFPHj/q61QUbj1FZStAxdJX
	sx63y2aKH6uqfKrlQk1mcVSQxVx+0FRRI0nGavY8tsId7hhxT+8izq94Srssm9bat0SlUk8cmv8
	52en/mThKHHF3Uat+VIRt8PakIgcCVzvVgg5+Jh1jhMEr87d22S+ZByj6gTVnGk94weE=
X-Received: by 2002:a05:600c:287:b0:4a1:e368:cbf7 with SMTP id
 5b1f17b1804b1-4bb909d0619mr1867585e9.0.1795456253076; Mon, 23 Nov 2026
 09:50:53 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
 <20261120135013.GO3115493@ziepe.ca> <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
 <1f10002ea9ee16a17087bd06e4a1685a973fdf6e.camel@linux.ibm.com>
In-Reply-To: <1f10002ea9ee16a17087bd06e4a1685a973fdf6e.camel@linux.ibm.com>
From: Naman Gulati <namangulati@google.com>
Date: Mon, 23 Nov 2026 09:50:40 -0800
X-Gm-Features: Aa3M54qK7IY8ZMBupflhQ8_7jK3YPX7yjpTGqvTp5f5henwr9osR6FHQsicVdiQ
Message-ID: <CAMP57yVZx=s-JXHfQfd_ouv2jV6MMsJXpxVLkQQHG=7qfFVJfA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Luigi Rizzo <lrizzo@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Dragos Tatulea <dtatulea@nvidia.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 2:10=E2=80=AFAM Niklas Schnelle <schnelle@linux.ibm=
.com> wrote:
>
> On Fri, 2026-11-20 at 15:19 +0100, Luigi Rizzo wrote:
> > On Fri, Nov 20, 2026 at 2:50=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> =
wrote:
> > >
> > > On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> > > > This is v3 of the RFC previously posted as DMA_PMD [0], now renamed=
 PISA
> > > > ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> > > > Documentation/core-api/pisa.rst (patch 25/25), which has the detail=
s.
> > >
> > > I thought the conclusion was to just do this stuff in netdev pagepool=
,
> > > now you come with an enormous AI series spread across the entire
> > > kernel?
> >
> > There were surely comments claiming nothing outside net/ cares or needs=
 this.
> >
> > I respectfully disagree, witness is the fact that e.g. there was alread=
y an
> > io_uring proposal which is smaller, but does not address applications
> > that want to use the standard disk I/O paths (libaio, buffer cache etc)
> >
> > Nothing has changed from the initial series in terms of size, use cases=
 or
> > subsystems involved. Large files are placed where they should,
> > the series covers the same three use cases (disk, network, CoCo), and
> > touches three parts which it has to touch: mm (most of it; it is a
> > memory allocator
> > extension after all), dma (it hooks into map and unmap, not a large cha=
nge)
> > and net (the pagepool change is a couple of lines; the tx path needs to
> > touch more places because the current stack assumes all paths have
> > the same I/O requirements).
> >
> > For CoCo, there are very fine grained controls so the bounce buffers
> > can be enabled only when they don't pose a risk, which in turn
> > depends on the threat model.
> >
> > Specifically, for network tx buffers or disk writes, the user-to-kernel=
 copy
> > is basically a bounce buffer provided it is used correctly and not leak=
ed
> > elsewhere (which is the design; of course the implementation
> > needs to be verified and possibly fixed so that it matches the design).
> >
> > cheers
> > luigi
>
> Hi Luigi, Hi Jason,
>
> I've been lurking but following this series since the start. I am torn.
> On s390 where the IOMMU is always enabled on our closest equivalent to
> bare metal (non paging LPAR hypervisor), and where we also default to
> an emulated IOMMU in KVM guests, the underlying problem is a real pain.
> We're also in the process of enabling large IOMMU mappings via the
> generic_pt API which are 1M and 2G on s390. So, the idea of making
> better use of larger mappings is very attractive to us and I applaud
> you for trying to tackle this very real issue.
>
> That said I do have to agree with the critique. This series is too
> invasive, too unclear in its layering, and most importantly it feels
> like you're trying to do everything in a big swoop ignoring advice from
> the maintainers just because it would limit the scope of a first step.
>
> I also don't think Jason's point is that nothing outside net/ cares, I
> think, it's rather that the IOMMU and DMA layers already offer the
> tools and each subsystem needs to use the right combination for its
> specific requirements. And if a tool is missing this needs to be stated
> very precisely including how the addition keeps layering intact.
>
> I don't claim to have a simple solution to offer, if I did I would have
> sent patches already, but let me state my thoughts. First I think this
> really needs an iterative approach with much smaller self contained
> steps and focus on specific issues. With that, I think this should
> focus on the network stack, while the io_uring specific proposal can go
> after the block layer. Also in my experience networking is where this
> hurts most.
>
> Now, I wonder if we can't start with something simple. What if the page
> pool could start by allocating in batches of PMD sized and aligned
> folios of contiguous pages that can share a single large IOMMU
> translation. The page pool can then still hand out pages from that
> batch without having to do sub-page allocation but would already use
> much fewer IOTLB entries and the locality might even help non IOMMU
> workloads. So, I'd even hope this could be enabled by default and this
> is actually something I don't like about this series, I really don't
> like having a tunable when we know that larger IOMMU mappings are
> strictly better when you have an IOMMU that supports them.
>
> I think that approach would also align with Jason's idea to keep things
> within the network stack and to work with the tools we have until their
> limits become very clear.

Hi Niklas,

I have been working on this idea exactly - extending the network
page-pool with a memory provider that allocates large pages, splitting
them into N smaller pages that all share a single IOMMU entry. I
breifly shared my approach in the v1 PMD series [1]. I'm readying a
short RFC to share shortly, would appreciate your feedback.


[1] https://lore.kernel.org/netdev/CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trmw+=
BJRVYf3JB1g@mail.gmail.com/

>
> Thanks,
> Niklas
> > >
