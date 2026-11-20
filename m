Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136823;
	b=QF4ItS4a/MOAoRQRhqHUQD9S7uSqCvWHxTax2kp7eAvAb8KxH819ONIINDysez9xTeIh
	 UfPeM0fmJZb37SzDlvb4cbNMi4yVxjOcvxqkToWG2Hw4GbaVzn8YbBtfNom0qp410gyGT
	 KLbATdquWmiU7FntpKb7XzEGFqZ3RAxp2SuIjinmXGPYwU/ilF5fuBzUvWRreFWkS5Uif
	 m1RDtHNsHWAZTClBvUlWFwzS9W7GIx91Ezg85MkNFNa/SRvc8FbyF2BvkIBI8+6Z0r/9T
	 bu+ntyPVpOzK3R33/hbza2zFbKk2jfp/T3T11Ed57/B6SZrhN2iyUw46veiYKygMogg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136823;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=vRgEV73buW9GBPSCDuFlhibk7fFdXhSeJd+kw3YQM8A=;
	b=E4aWP59v7pW5wM/MV6MvbZCsRgrvQsyVjrCJ1ipDdxFUGcaeX1Iw8TQezQOS8pkZcH5/
	 4m5s2jj8cANRAT7/j/YxvdlxG9tlJnuU9annO5HG6w7D+R6jR7D/2YyY2vdozPwt59990
	 uChRnZuzGy6X2hoc3g3qEHrMG4sMxYq25r8UPYZKkqc5S7hKRMbYLt60Jma4QOCkRbG2X
	 tR2ORREzTvaM5ZBmS8sGwh4w8H34eiYMl2Ss/gIT+o3Dz88DgmIuIaJDH3wdOZZ0aR762
	 q3lTN80ZdkcD8F+J6y6IAqAF5DsWlaN2gR5sXIE8ZqGG8mgdmGaRQAY92XO/qqDxVJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WVKxr1b9;
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEB6606A325
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FEB6606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WVKxr1b9
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c50547b4992so21696266b.3
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136821; x=1795741621; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vRgEV73buW9GBPSCDuFlhibk7fFdXhSeJd+kw3YQM8A=;
        b=WVKxr1b9L0sg1AFlRl7Eju1mFkQp5d+tTsGWPzGubiEk+ofpyaUOW6iPmQlPq7c5Lf
         Ajhbb31GF8MP4qI9Os42jLYtpt11ep5EtJ2K73i8mdN5bDDW/EuoCH5JgzRZIC6rYb9u
         /m19FjcQxjfZAImfEJXa3yQZcb28vk1JjUpSHcW3N/xsccaHZqbxpGSL2g7alwNTBF7X
         guVZlh2nZJFRJHP1xFCKKf/vsteFLHbWJ9beu6bdQ+nllhsZ/1J81sK2LIfmDpd8isGu
         YA4qcxa0RPPqgNGPlep6h0NAdTlTGAiB5yxp9mpmmZGBv/QwalDcWfgqrhM4Vjf40Z0y
         HrqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136821; x=1795741621;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vRgEV73buW9GBPSCDuFlhibk7fFdXhSeJd+kw3YQM8A=;
        b=TSmoAg+AONqlZyiMjh/svjt6Lo+UB8hLqdNvVSml5AW99c/ZYIWFGZ9JeJePRQV4q1
         cFk580xxyYvkVMvnAQsVuTnSJXmHo0mpGawjUSmWGLl+vrqgLxsgLiwaNoGnqCtsjH5+
         v98rw0Wlzw0rDEOknxScz2EjXy1PzKMaHYZW+77PZ6DfyB95+8irJbOQ3Nb+5lMI4QEt
         Pi072/5DGTB7DyuPkd3E4tUxiLvsUTsl2nc9mHFPeRLcHMh6wSBgfD2TnWK5/dlYnqXh
         VJfgbINK2kcqUX1SFsYU5bMG+Xgq2xtBW1SRt8UIZvLGnGPunScsh8Gy8KTOvW+J6dLS
         3llg==
X-Forwarded-Encrypted: i=1; AL+hErECnpzHamYxmrZe/9CqFWb3H4wHVnKKjAXxBPfcKoFRegxxRpRfjqJcoNoRp8YF1Wfc0MF61ONXyZs=@vger.kernel.org
X-Gm-Message-State: APuU4Z8t9EqH7aDYujujDjZzgzTjZHZP8SVLYDCCwP7u5gQ6EcD+KeKP
	HfEV7P8NX9MnEEy22O0zmpjESj5ooVb/xC0qKvSXdScSXTLb/YQMhhuxM3p6Jefz0d5k2fZddBe
	Nm+7qow==
X-Received: from edj9-n2.prod.google.com ([2002:a05:6402:3249:20b0:6b7:e5f7:4663])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:3b94:b0:c26:1649:47ad
 with SMTP id a640c23a62f3a-c513ab209f4mr107142966b.35.1795136820223; Thu, 19
 Nov 2026 17:07:00 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:30 +0000
In-Reply-To: <20261109182533.3594984-1-lrizzo@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-1-lrizzo@google.com>
Subject: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator for
 DMA and CoCo
From: Luigi Rizzo <lrizzo@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
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
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, Dragos Tatulea <dtatulea@nvidia.com>, 
	Naman Gulati <namangulati@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"

This is v3 of the RFC previously posted as DMA_PMD [0], now renamed PISA
("Pre-mapped IOVA Superpage Allocator"). The text below follows
Documentation/core-api/pisa.rst (patch 25/25), which has the details.

=== OVERVIEW

PISA is an extension to the page allocator: requests with __GFP_PISA
return memory that makes I/O-related operations cheaper when using DMA-FQ,
DMA, or Confidential Computing swiotlb. I/O devices can individually opt
in to use PISA for specific buffer classes (e.g. read or write data,
headers, zerocopy, ...). Relevant kernel subsystems (mm, iommu, dma, disk
I/O, page cache, the network stack) are modified to make use of PISA
memory for opt-in devices.

The design and implementation have the following main goals:

- no changes to individual device drivers (or minimal changes for NIC
  drivers that use custom RX page allocators)
- minimize changes to base code: in most cases one or a few lines of code
- safety: PISA memory is only used for devices that opt in, and it is
  returned to the buddy allocator only after IOMMU mappings and IOTLB
  entries have been flushed
- no dependency on struct page or struct folio
- compile-time option to disable or enable PISA
- zero runtime overhead when no devices opt in (static keys and inline
  hooks)
- minimal overhead when in use (direct PFN lookup in a flat metadata
  table)
- keep memory overhead as low as possible (adaptive shrinking and
  compaction of memory)

=== MECHANISMS

PISA returns order-N blocks backed by 2MB physically contiguous pages, so
it can use 2MB IOMMU leaves and reduce the IOTLB pressure by up to 512x.
PISA maps memory in pre-allocated per-domain IOVA ranges, and recycles
blocks and mappings until the 2MB page is returned to the buddy allocator.
This makes most of dma map/unmap a no-op, also avoiding related VM exits
in overcommitted VMs. In Confidential Computing VMs, PISA pages are also
decrypted, removing the need for bounce buffers.

The kernel identifies devices and sockets that use an IOMMU or
Confidential Computing and have opted into PISA, and allocates (or
migrates) I/O buffers using PISA memory so that DMA mapping and unmapping
are mostly no-ops. All the above makes performance comparable to identity
mode, with isolation better than DMA-FQ and comparable to DMA.

Devices that do not opt in continue to use their native DMA/DMA-FQ mode.

=== PERFORMANCE

Your mileage may vary. Enabling the IOMMU will increase load on various
system components (CPU, IOTLB, bus latency, increased locking
serialization) but the impact on throughput will only show up when one or
more of these resources become fully congested.

Some anecdotal data:

NVMe: fio throughput in IOPS, 4KB random reads, O_DIRECT, on an x86 system
with 8 NVMe disks capable of 1.7M IOPS each

    drives      DMA     PISA    identity
    1           380K    1.7M    1.7M
    8           1.3M    13.5M   13.5M

Network: throughput in Gbps on a Confidential Computing VM, 200G NIC

    flows/mtu   swiotlb PISA
    1/1460      36      65
    1/4148      45      65
    16/1460     130     170
    16/4148     130     182
    256/1460    140     170
    256/4148    140     182

Network: throughput and SMMU performance counters on a large ARM64 system
with 2x200G NICs running bidirectional traffic (this shows the effect of
IOTLB thrashing)

    === DMA-FQ (total throughput ~440Gbps)
    25,757,488      smmuv3_pmcg_*/event=0x80/   IOTLB lookups
    16,634,941      smmuv3_pmcg_*/event=0x81/   IOTLB misses

    === PISA on top of strict DMA (total throughput ~745Gbps)
    22,693,218      smmuv3_pmcg_*/event=0x80/   IOTLB lookups
        30,536      smmuv3_pmcg_*/event=0x81/   IOTLB misses

=== COMPARISON WITH STANDARD DMA MODES

PISA layered on top of strict DMA, compared with identity, DMA-FQ and
strict DMA ( > means PISA is better ):

                                      identity   DMA-FQ    DMA
  dma_map cost                          ~=         >>       >>
  dma_unmap cost                        ==         >>       >>
  IOTLB friendliness                    na         >>       >>
  Buffer shared across domains          na         <=       <=
  Memory remains accessible to device   >>         >>       <=
  Needs bounce buffers                  >>         >>       >>
  Page alloc/free cost                  >=         >=       >=

- dma_map/dma_unmap cost: once a 2MB PISA page is mapped in a domain's
  reserved IOVA window, dma_map_*() is an offset lookup and dma_unmap_*()
  is a no-op, avoiding IOVA tree allocation, page-table walks, and
  synchronous IOTLB shootdowns.
- IOTLB friendliness: 2MB IOMMU leaves reduce IOTLB pressure by up to 512x
- Buffer shared across domains: even in DMA-FQ and DMA, sub-page buffers
  from task_frag or skb head slabs can cause the underlying page to be
  mapped across multiple domains. PISA exhibits the same behavior, just at
  2MB granularity.
- Memory remains accessible to device: in identity mode all of RAM is
  always accessible. In DMA-FQ, pages returned to the buddy allocator
  remain accessible until the flush queue drains. PISA and DMA both unmap
  the page and perform a synchronous IOTLB flush before returning memory
  to the buddy allocator. In all modes, pagepool keeps receive buffers
  mapped and accessible to the device while queued in the rx socket
  buffer. PISA expands this visibility also to page cache and O_DIRECT
  pages.
- Needs bounce buffers: in Confidential Computing VMs, PISA allocators
  pre-decrypt 2MB pages in place, avoiding swiotlb bounce-buffer copies.

=== BACKGROUND

Enabling the IOMMU costs CPU to install and remove PTEs on dma_map/unmap,
CPU and latency to flush the IOTLB, and higher DMA latency from IOMMU page
walks when the working set exceeds the IOTLB size. The last one is among
the biggest bottlenecks for high speed devices: network devices have very
little IOVA locality, which makes the IOTLB almost completely ineffective.

The known mitigations are recycling buffers and mappings (common for
queues and RX buffers, but not for network TX buffers), lazy IOTLB flush
(DMA-FQ, which recycles memory without waiting for the flush), and larger
mappings (not currently pursued by the kernel). PISA combines them:

- intercept the small set of functions used to allocate, map, unmap, and
  free device-accessible memory (rings and buffers)
- return memory backed by physically contiguous 2MB pages and 2MB IOMMU
  mappings
- heavily recycle memory and mappings
- wait until the IOTLB has been flushed before returning unused PISA pages
  to the system

=== IMPLEMENTATION AND CODE LAYOUT

PISA is implemented by a few groups of commits:

- mm: infrastructure for per-page metadata (no dependency on struct page),
  hook into alloc_pages(), PISA optimizations (per-cpu caches, shrinker,
  background zeroing)
- driver core: per-device sysfs entries to opt in
- iommu/dma: manage PISA IOVA ranges and intercept map/unmap
- block, mm, net: transparently upgrade pages to PISA for disk I/O and
  network tx zerocopy
- net: identify sockets that need PISA pages, hook PISA into page frags,
  skb heads, page_pool

The code layout now matches the "allocator" nature of PISA: most of the
code is in mm/, and iommu and net only carry subsystem-specific changes.

  mm/pisa-*.c                            metadata, allocators, per-node
                                         reservoir, user and page-cache
                                         pages (~5100 lines)
  drivers/iommu/pisa-map.c               IOVA ranges, map/unmap
                                         (~500 lines)
  net/core/pisa-net.c, include/net/pisa.h
                                         socket and skb glue (~450 lines)
  include/linux/pisa*.h                  public API and inline hooks

The functions that need to be intercepted are few:

- page_pool_dev_alloc*(), socket TX page frags, __free_pages()
- dma_alloc_attrs(), dma_map_*(), dma_unmap_*()
- __filemap_get_folio_mpol(), ractl_alloc_folio(), writeback_get_folio(),
  __bio_iov_iter_get_pages(), madvise()

and most devices automatically inherit the benefits. Fast-path hooks are
guarded by static keys: pisa_key remains disabled (a single NOP) until the
first device opts in via sysfs. NIC drivers that do not use page_pool need
a few lines to pass __GFP_PISA_RW when allocating RX buffers; gve is
converted as an example.

=== INTERNAL MECHANISMS

- PISA metadata: each 2MB page used for PISA memory is identified by a
  compact index (slot). Two flat arrays in virtual address space, with
  holes mapped read-only to a zero page:

  1. pisa_pfn2slot[pfn >> PISA_ORDER] (4 bytes per 2MB physical frame)
     packs the status flags and the slot. It is populated for system RAM
     at boot or on hotplug, and grows by 4KB for each 2GB of physical RAM
     regardless of RAM layout.

  2. pisa_meta_array[slot] (256 bytes per 2MB PISA page) holds struct
     pisa_meta: base PFN, flags, free/clean/dirty subpage bitmaps, the
     bitmap of IOMMU domains with an active 2MB mapping, and list/RCU
     linkage. Backing pages are allocated on demand up to pisa.max_pages
     (default 1/8th of RAM).

- Per-domain reserved IOVA ranges: PISA reserves on each domain an IOVA
  range covering the slot table, and a page is mapped on demand at offset
  slot * PISA_SIZE in each domain that requires it. This makes PA-IOVA
  translation just an addition, uniquely identifies PISA IOVAs, and does
  not expose physical addresses.

- alloc_pages() compatible allocator: a pisa_alloc object serves
  fixed-order allocations, returning objects fully compatible with those
  of the page allocator. alloc_pages() and related requests are routed to
  PISA via __GFP_PISA, which makes it easy to select PISA pages where
  needed (two lines in page_pool, similar small changes in page frag
  refill and disk I/O buffers).

- Safe release of memory: freed blocks return to PISA with mappings still
  active. When all blocks of a 2MB page are unused the page becomes idle;
  idle pages above pisa.max_idle are released after pisa.idle_ms, or by
  the shrinker: mappings are removed, a synchronous IOTLB flush is issued,
  and after an RCU grace period (and re-encryption if needed) the page is
  returned to the buddy allocator.

- Memory compaction: partially allocated 2MB pages are classified as dense
  (preferred for new allocations) or sparse (left to drain). For user
  pages, pisa.scrub_migrate also migrates live 4KB pages out of old sparse
  2MB pages in the background.

=== MODIFIED KERNEL APIS AND CONTROLS

Opt-in is per device, through
/sys/devices/.../pisa_{coherent,rx_bufs,tx_bufs,tx_skb_heads,tx_zerocopy}.

- Streaming DMA map and unmap: a buffer belonging to a PISA page is mapped
  via the domain's reserved window with a simple addition, typically
  reusing existing mappings; unmap is a range check and a no-op. Under
  dma-direct, decrypted PISA pages are mapped without swiotlb bounce.
- Coherent DMA (pisa_coherent): sleepable allocations up to 2MB are carved
  out of the per-node order-0 allocator.
- Network receive buffers (pisa_rx_bufs): a two-line change in page_pool
  adds __GFP_PISA_RW, falling back to the buddy allocator on exhaustion.
- Socket TX page fragments (pisa_tx_bufs): fragments come from PISA pages
  mapped DMA_TO_DEVICE, only for data routed to an opt-in device with a
  DMA parent. Loopback, virtual devices, kTLS, sockmap, KCM and MPTCP use
  ordinary pages.
- Small skb heads (pisa_tx_skb_heads): served by an
  skbuff_small_head_pisa slab cache backed by PISA memory mapped
  DMA_TO_DEVICE. Never used in Confidential Computing, where it would
  expose kernel pointers; tx-copybreak avoids the swiotlb cost there.
- Zerocopy receive: RX buffers from PISA pages can be mapped into user
  space by TCP_ZEROCOPY_RECEIVE.
- Zerocopy transmit (pisa_tx_zerocopy): MSG_ZEROCOPY sends migrate
  eligible user pages into DMA_TO_DEVICE PISA blocks on a best-effort
  basis. With pisa_tx_bufs also set, TCP copies the pages that could not
  be migrated.
- User and disk I/O pages: madvise(MADV_PISA) migrates private anonymous
  pages into PISA and MADV_NOPISA migrates them back. For block devices
  with pisa_rx_bufs (reads) or pisa_tx_bufs (writes) on a parent device,
  new order-0 page-cache folios are allocated from PISA, and writeback and
  direct-I/O bio preparation migrate eligible folios.

Global controls are pisa.* parameters: max_pages, reservoir_max, max_idle,
idle_ms, pcp_batch, compact, target_usage_percent, old_ms, scrub_max,
scrub_migrate, user_max_pages. Counters are in
/sys/kernel/debug/pisa/allocs.

=== LIMITATIONS

- Not compatible with PREEMPT_RT (enforced at compile time).
- Only DMA-coherent devices can use PISA (enforced at runtime).
- IOMMU mappings follow the direction the allocator was created with:
  descriptor queues and receive buffers are DMA_BIDIRECTIONAL, disk and
  network write buffers and socket TX fragments are DMA_TO_DEVICE.

=== CHANGES SINCE v2 [1]

The changes are too many to list in detail; at a high level:

- Code layout: the allocator moved from drivers/iommu/pisa-*.c to
  mm/pisa-*.c (and CONFIG_PISA to mm/Kconfig). Only the IOVA window and
  map/unmap code is left in drivers/iommu/pisa-map.c, and the network
  hooks moved from include/net/sock.h to include/net/pisa.h and
  net/core/pisa-net.c. See CODE LAYOUT.
- Flags renamed to __GFP_PISA and __GFP_PISA_RW
- Reworked metadata: a flat pfn-indexed table plus compact per-page
  slots, with the per-domain IOVA window indexed by slot.
  Saves one load access in the hot paths, and
  removes several tuning knobs while allowing 57bit address space
  with negligible memory overhead
- Net: the opt-in flags of the leaf devices are cached on struct
  net_device, and MSG_ZEROCOPY migration has its own per-device knob,
  pisa_tx_zerocopy.
- Confidential Computing: added arm64 Realms support.
- Compaction is driven by a target usage (pisa.target_usage_percent)
  instead of pisa.wasted_pct.
- Series reorganized (mm first, then iommu/dma, block, net, drivers), with
  the three IOVA window patches merged into one.
- Fixes for the issues reported on v2 by the automated review.
- Added NVMe and Confidential Computing results.

=== CHANGES SINCE v1 [0]

v1 presented DMA_PMD as a set of pools and an arena under drivers/iommu,
called explicitly by page_pool, the socket code and four NIC drivers.

- Renamed DMA_PMD to PISA.
- Restructured as an extension to the page allocator: callers pass
  __GFP_PISA / __GFP_PISA_RW to alloc_pages() instead of calling a
  dma_pmd_pool, and the code moved from drivers/iommu/ to mm/ (see CODE
  LAYOUT).
- Per-NUMA-node allocators with per-CPU caches replace the per-CPU and
  per-queue pools; the dma_pmd_arena for dma_alloc_attrs() is merged into
  the per-node order-0 allocator.
- The per-driver TX header bounce buffers (gve, mlx5, idpf, bnxt) are gone,
  replaced by a PISA-backed slab cache for small skb heads.
- New: user pages (MADV_PISA, MSG_ZEROCOPY) and disk I/O (O_DIRECT and
  page cache), with compaction and background migration.
- Opt-in is through per-device pisa_* attributes and pisa.* parameters;
  metadata and static keys are activated on the first opt-in.


[1] v2 (PISA)
    https://lore.kernel.org/all/20261109182533.3594984-1-lrizzo@google.com/
[0] v1 (DMA_PMD):
    https://lore.kernel.org/all/20261003212241.3432303-1-lrizzo@google.com/

Luigi Rizzo (25):
  mm: Introduce CONFIG_PISA and metadata table
  mm: Add PISA allocator lifecycle and page recycle hook
  mm: Add per-NUMA-node PISA page reservoir
  mm/page_alloc: Extend alloc_pages() to __GFP_PISA and PISA block
    allocation
  mm: Add global cap and shrinker for PISA pages
  iommu/dma: Map PISA memory in a per-domain IOVA window
  driver core: Add per-device pisa_* sysfs attributes for PISA optin
  iommu/dma: Use PISA for coherent DMA allocations
  mm: Add per-CPU block caches to PISA allocators
  mm: Add background page scrubber for PISA allocators
  mm: Migrate user pages into PISA
  block, mm: Support PISA for disk I/O and scrub migration
  net: Cache leaf PISA TX flags on struct net_device
  net: Use per-node PISA allocators for skb_page_frag_refill()
  net: Use PISA for page_pool memory
  mm/slub: Add SLAB_CACHE_PISA_RO for PISA-backed slab caches
  net: Allocate small skb heads from PISA
  net: Migrate user pages into PISA for MSG_ZEROCOPY
  mm, iommu/dma: Support decrypted PISA pages
  arm64/mm, mm: Support decrypted PISA pages in Realms
  mm: Add PISA statistics and debugfs
  net/libeth: Use GFP_KERNEL when pre-filling RX rings
  net/gve: Use GFP_KERNEL when pre-filling RX rings
  net/gve: Use PISA memory for RX buffers
  Documentation: Add PISA architecture documentation

 .../admin-guide/kernel-parameters.txt         |    7 +
 Documentation/core-api/index.rst              |    1 +
 Documentation/core-api/pisa.rst               |  485 +++++
 arch/arm64/include/asm/pgtable.h              |   28 +-
 block/bio.c                                   |    9 +
 drivers/base/core.c                           |   78 +
 drivers/iommu/Makefile                        |    3 +
 drivers/iommu/dma-iommu.c                     |   49 +-
 drivers/iommu/iommu.c                         |    7 +-
 drivers/iommu/pisa-map.c                      |  488 +++++
 .../ethernet/google/gve/gve_buffer_mgmt_dqo.c |    8 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |   40 +-
 include/linux/device.h                        |   32 +
 include/linux/gfp_types.h                     |   14 +-
 include/linux/huge_mm.h                       |    7 +
 include/linux/netdevice.h                     |    4 +
 include/linux/pisa-iommu.h                    |  141 ++
 include/linux/pisa-mm.h                       |  205 ++
 include/linux/pisa.h                          |  356 ++++
 include/linux/sched.h                         |    4 +
 include/linux/slab.h                          |   10 +
 include/linux/swap.h                          |    1 +
 include/net/libeth/rx.h                       |   11 +-
 include/net/pisa.h                            |  204 ++
 include/trace/events/mmflags.h                |   11 +-
 include/uapi/asm-generic/mman-common.h        |    2 +
 kernel/dma/direct.c                           |   11 +
 kernel/exit.c                                 |    2 +
 kernel/fork.c                                 |    2 +
 mm/Kconfig                                    |   35 +
 mm/Makefile                                   |    3 +
 mm/filemap.c                                  |   12 +-
 mm/huge_memory.c                              |   36 +-
 mm/ksm.c                                      |    3 +-
 mm/madvise.c                                  |   19 +
 mm/memory.c                                   |    8 +-
 mm/migrate.c                                  |    3 +-
 mm/page-writeback.c                           |    9 +
 mm/page_alloc.c                               |   10 +
 mm/pisa-alloc.c                               | 1758 +++++++++++++++++
 mm/pisa-kunit.c                               |  778 ++++++++
 mm/pisa-meta.c                                |  834 ++++++++
 mm/pisa-node.c                                |  567 ++++++
 mm/pisa-priv.h                                |  319 +++
 mm/pisa-user.c                                |  898 +++++++++
 mm/readahead.c                                |    3 +-
 mm/slab.h                                     |    3 +-
 mm/slab_common.c                              |    2 +-
 mm/slub.c                                     |   23 +-
 mm/swapfile.c                                 |    3 +-
 mm/userfaultfd.c                              |    7 +-
 net/core/Makefile                             |    1 +
 net/core/datagram.c                           |   17 +-
 net/core/page_pool.c                          |    3 +
 net/core/pisa-net.c                           |  264 +++
 net/core/skbuff.c                             |   33 +-
 net/core/sock.c                               |   31 +-
 net/ipv4/esp4.c                               |    7 +-
 net/ipv4/ip_output.c                          |   20 +-
 net/ipv4/raw.c                                |    6 +-
 net/ipv4/tcp.c                                |   17 +-
 net/ipv4/tcp_output.c                         |   14 +-
 net/ipv6/esp6.c                               |    7 +-
 net/ipv6/ip6_output.c                         |   20 +-
 net/ipv6/raw.c                                |    6 +-
 65 files changed, 7907 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/core-api/pisa.rst
 create mode 100644 drivers/iommu/pisa-map.c
 create mode 100644 include/linux/pisa-iommu.h
 create mode 100644 include/linux/pisa-mm.h
 create mode 100644 include/linux/pisa.h
 create mode 100644 include/net/pisa.h
 create mode 100644 mm/pisa-alloc.c
 create mode 100644 mm/pisa-kunit.c
 create mode 100644 mm/pisa-meta.c
 create mode 100644 mm/pisa-node.c
 create mode 100644 mm/pisa-priv.h
 create mode 100644 mm/pisa-user.c
 create mode 100644 net/core/pisa-net.c


base-commit: 20eef29b7c8465ac98d7dd6d6f2ac07a8d8056ca
-- 
2.56.1.809.ga0b61035b5-goog

