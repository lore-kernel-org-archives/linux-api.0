Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186487;
	b=zvpg3MrZFkIyYz4dLJ+F9DMmLa+N7Uv0Dk91X1f7lrSIrjIe+1CqY5FMlWsxKF6rJ/xi
	 XWTaQ337InXHd8g1tsnsfsyEoeRYtAf0scobzG+cTHJxzEZHwyq32YB6LQxUcAZjL5qr6
	 NqtvZXVr7x+n45MnCqW6YEtwZYPJaEpKXUpXOmeFt7Xpr8IhV7lhHaR20iGK43kd9kIhW
	 adczOAbo5UNwvqy3B2zhpHJnVOd7GukeSev/+KW0y8lZfUpuC1hp00hLi9MNgpO2Cs7JG
	 I5zAfaLNmwvHCgiIUA633wGEBobO5bp9v+7vh6uGOA7+0opPw1ovERK/TqDbVFh3B7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186487;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YXkMF49tfbR1XrNxSmARw9QjbBb1TVrWgTfXHrV4vhQ=;
	b=h8n9c45ZgApTZBwWhrUrsYH05LiDNrPlNaXaarzf25K8iCrMM5PuCa+ugY6cUK61RRm9
	 4ZTmW6EJF9Q3chBwhD+HKqA9kr0A1JiFrhFaFdirb9S366giEN21v4zCGAKehgPfmCjqq
	 YZsbg0a9Ml52K+HxOuZw43L7bvWTf5RnBLhj3eNvmlZcFz90jzaB2W+UdXf0taTHaQnZF
	 F/1RNplwWK3hkpslAEEjlNyPCqeIZDJOR1DKe/liu8bGxHojNPDCxzPXaoLfgT8qnNT0R
	 M8Fp22IOmHb/5RTtz3eYqK7ZvZu3nU4+V9AgrblX1xdSyWlzW4oAXxtDeU9qqaKzbGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIK9EkYL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF93606A320;
	Fri, 20 Nov 2026 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIK9EkYL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B33C1F000C4;
	Fri, 20 Nov 2026 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795186486;
	bh=YXkMF49tfbR1XrNxSmARw9QjbBb1TVrWgTfXHrV4vhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eIK9EkYL6YNouxCKFKo9gIUK8cO1ySdVl96yCE1rq7wuTOlqRE8qknkbshPl1xlLN
	 3KOF85Pf3JIzT9160NLAIzPpvBOu/y5o20cpMVSCUStMQJpajDPpxv0xql8onEzdc1
	 Bq24F74qyQyPCe3a0Ub8zjMBlGHRVua3XzC8HlMSh7rc0w+6ewtdOPqMpNqlgASYYX
	 tJIZWZMaiMxfw2qlE06Mu17u4Y3J4CbVNpMEF7mMNe9qziuMXKmrwuDoSUkQLv6pn3
	 yDWp8beOFg/IBB5aoUMH03jJAr+YJNYE609fue5l1rTTHi12txxpruqZ/ms1Gg8eZ0
	 dnkEtvuXJwE/w==
Date: Fri, 20 Nov 2026 14:54:35 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Luigi Rizzo <lrizzo@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
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
Message-ID: <awBYFhnpFGtEXZ6r@gremlin>
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

TL;DR: NAK. All of it. (And yeah, I'm steeling myself for the inevitable 'oh
Lorenzo' :)

Sigh. You know, it's hard being a maintainer, and it's twice as hard lately,
given the endless surge of AI-generated stuff we see every day.

But I am especially frustrated that I have to ask people to do the _absolute
basics_. And from people who are not helping with any of that. Quite the
opposite.

So the basics - you haven't cc'd the right people here and you're sending a
massive new series in-reply-to another. See below for some automatically
generated feedback on that.

In any case, the courteous thing to do would be to familiarise yourself with how
series are sent in mm. And that goes so much more for a series that is so
invasive. And seemingly, AI generated...

And you're sending it when
https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/
is in effect.

Anyway, to the series itself....

This is ludicrous:

>  .../admin-guide/kernel-parameters.txt         |    7 +
>  Documentation/core-api/index.rst              |    1 +
>  Documentation/core-api/pisa.rst               |  485 +++++
>  arch/arm64/include/asm/pgtable.h              |   28 +-
>  block/bio.c                                   |    9 +
>  drivers/base/core.c                           |   78 +
>  drivers/iommu/Makefile                        |    3 +
>  drivers/iommu/dma-iommu.c                     |   49 +-
>  drivers/iommu/iommu.c                         |    7 +-
>  drivers/iommu/pisa-map.c                      |  488 +++++
>  .../ethernet/google/gve/gve_buffer_mgmt_dqo.c |    8 +-
>  drivers/net/ethernet/google/gve/gve_rx.c      |   40 +-
>  include/linux/device.h                        |   32 +
>  include/linux/gfp_types.h                     |   14 +-
>  include/linux/huge_mm.h                       |    7 +
>  include/linux/netdevice.h                     |    4 +
>  include/linux/pisa-iommu.h                    |  141 ++
>  include/linux/pisa-mm.h                       |  205 ++
>  include/linux/pisa.h                          |  356 ++++
>  include/linux/sched.h                         |    4 +
>  include/linux/slab.h                          |   10 +
>  include/linux/swap.h                          |    1 +
>  include/net/libeth/rx.h                       |   11 +-
>  include/net/pisa.h                            |  204 ++
>  include/trace/events/mmflags.h                |   11 +-
>  include/uapi/asm-generic/mman-common.h        |    2 +
>  kernel/dma/direct.c                           |   11 +
>  kernel/exit.c                                 |    2 +
>  kernel/fork.c                                 |    2 +
>  mm/Kconfig                                    |   35 +
>  mm/Makefile                                   |    3 +
>  mm/filemap.c                                  |   12 +-
>  mm/huge_memory.c                              |   36 +-
>  mm/ksm.c                                      |    3 +-
>  mm/madvise.c                                  |   19 +
>  mm/memory.c                                   |    8 +-
>  mm/migrate.c                                  |    3 +-
>  mm/page-writeback.c                           |    9 +
>  mm/page_alloc.c                               |   10 +
>  mm/pisa-alloc.c                               | 1758 +++++++++++++++++
>  mm/pisa-kunit.c                               |  778 ++++++++
>  mm/pisa-meta.c                                |  834 ++++++++
>  mm/pisa-node.c                                |  567 ++++++
>  mm/pisa-priv.h                                |  319 +++
>  mm/pisa-user.c                                |  898 +++++++++
>  mm/readahead.c                                |    3 +-
>  mm/slab.h                                     |    3 +-
>  mm/slab_common.c                              |    2 +-
>  mm/slub.c                                     |   23 +-
>  mm/swapfile.c                                 |    3 +-
>  mm/userfaultfd.c                              |    7 +-
>  net/core/Makefile                             |    1 +
>  net/core/datagram.c                           |   17 +-
>  net/core/page_pool.c                          |    3 +
>  net/core/pisa-net.c                           |  264 +++
>  net/core/skbuff.c                             |   33 +-
>  net/core/sock.c                               |   31 +-
>  net/ipv4/esp4.c                               |    7 +-
>  net/ipv4/ip_output.c                          |   20 +-
>  net/ipv4/raw.c                                |    6 +-
>  net/ipv4/tcp.c                                |   17 +-
>  net/ipv4/tcp_output.c                         |   14 +-
>  net/ipv6/esp6.c                               |    7 +-
>  net/ipv6/ip6_output.c                         |   20 +-
>  net/ipv6/raw.c                                |    6 +-
>  65 files changed, 7907 insertions(+), 92 deletions(-)

I mean ~ +8ksloc. 65 files. These should be clues for you.

>  create mode 100644 Documentation/core-api/pisa.rst
>  create mode 100644 drivers/iommu/pisa-map.c
>  create mode 100644 include/linux/pisa-iommu.h
>  create mode 100644 include/linux/pisa-mm.h
>  create mode 100644 include/linux/pisa.h
>  create mode 100644 include/net/pisa.h
>  create mode 100644 mm/pisa-alloc.c
>  create mode 100644 mm/pisa-kunit.c
>  create mode 100644 mm/pisa-meta.c
>  create mode 100644 mm/pisa-node.c
>  create mode 100644 mm/pisa-priv.h
>  create mode 100644 mm/pisa-user.c

And here is a perfect clue. 'pisa-mm.h'. 'pisa-alloc.c'. You are creating
parallel implementations of core mm mechanics _just for your feature_.

And you didn't even update MAINTAINERS :) though, moving implementation to your
own files and adding hooks elsewhere is its own kind of anti-pattern.

>  create mode 100644 net/core/pisa-net.c

What I'm trying to say, constructively, is that you have gone down the wrong
road here. And it's one we've seen many times before.

You have decided that this feature is exciting and important and really special
and unlike anything else, so it must be implemented through hooks into other
stuff, new special GFP flags, an madvise() hook which amounts to 'I can do what
I want here', your own allocator, your own node code, your own everything.

And I'm sorry but we've seen this before, and it's been a disaster. Hugetlb and
uffd are examples of code like this.

Every feature of this nature imposes a tax. It means that you 'just have to
remember' to consider and deal with feature X when you write code touching Y
because feature X sits outside of the core mm code.

So my constructive suggestion to you (and this is an RFC, so you're asking for
this kind of feedback right? :) is as follows:

Firstly - please rethink using AI to generate massive series like this. You are
not going to get anything like that merged, and it disinclines maintainers from
even looking at your code.

Secondly - think about the problem at an architectural level. Listen to people
like Jason and David who are giving you highly valuable feedback, seriously you
are lucky to get it.

Thirdly - rework it so it _fits in with the existing core mm architecture_.

Finally, please don't send it as an +8 ksloc 65 file monster. Nobody is going to
take a series like that frankly, especially not from a newcomer to the
subsystem who may or may not stick around to maintain it.

IOW - try to find ways to implement it incrementally.

Thanks!

~~

FYI: Issues my scripts picked up:

1. New revisions sent in-reply-to mail

Please always send new revisions of series individually, not in-reply-to
any other email.

The easiest way of accomplishing this is to use b4 [0] (the recommended
way of sending patches to mm), otherwise format patches like this:

For a patch series, e.g. at v2:

$ git format-patch -v2 --cover-letter --thread ...

For an individual patch, e.g. at v2:

$ git format-patch -v2 HEAD~1

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

2. Missing cc's

You are missing cc's. Fixing this is easy with b4 [0] (the recommended way
of sending patches to mm):

$ b4 prep --auto-to-cc

Alternatively, you can use scripts/get_maintainer.pl:

$ scripts/get_maintainer.pl --nogit-fallback <files-or-patches>

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

Specifically, the following appear to be missing:

  chrisl@kernel.org
  kasong@tencent.com
  apopple@nvidia.com
  baohua@kernel.org
  baolin.wang@linux.alibaba.com
  baoquan.he@linux.dev
  byungchul@sk.com
  chengming.zhou@linux.dev
  dev.jain@arm.com
  gourry@gourry.net
  joshua.hahnjy@gmail.com
  kas@kernel.org
  lance.yang@linux.dev
  matthew.brost@intel.com
  nico.pache@linux.dev
  nphamcs@gmail.com
  peterx@redhat.com
  ryan.roberts@arm.com
  shikemeng@huaweicloud.com
  usama.arif@linux.dev
  xu.xin@linux.dev
  ying.huang@linux.alibaba.com
  youngjun.park@lge.com

--
Cheers, Lorenzo
