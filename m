Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136852;
	b=RcAjU004qQFNUYzB+bbmuFWexcwUzaddXl6oLxwIVqKxQldiFg4y54gwVDVZttIviRKT
	 YAehr9BRn1jA1h5+REZIXHLLgNvWDDxAl157P4bxM4oLnVIn/zptT5DjsJ6qXMY43KjcB
	 WwhyF6ZUK/1UudtthCqt3+KK4KU7e+S7fVKXwr1j8+M48Be2nZTtY47tsBuzTgdJDuxih
	 d2IBf+MqxtDEIzDT8mW18EY0hS63pPzhv1jP8G10z/CX6eQhUXerBB0giaBY7blRobdnB
	 /mvljyq+nxJrx039Klk0itZN9JjqHVY2wDBVfsKlDrJIfgMSQvc/8k+ihkWmZmwvIyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136852;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=xT+q1UNFy/eh7DrGUJ9/C9po27WSpF2DlTmU++Yh4W8=;
	b=2ewPjKCfOTCmXS7dOt3Vw5fjr+LXx5YU3dpf/Y3BBfxJCO4LQBaIHjWzX4UG5hLjqjxH
	 t1mtfhtb1B0ERcb8Z2l3YPZ8xYx5X2O/wBjxOAdTIHlwLL4VbpCSGmO6RRyiy5n17NcS1
	 Jo58J4QPWxkrd0X9yPej24aKxR204ZKmJwdA5Pk8mzTOo6Q0uIGEijaIF6g5mwm8sNnYr
	 Fg5vAJEbpY33elYSfYoHDlArf1H74fa+c4zfC2PcvFyrZvva606P+lYjN2VsMxI4FaWF5
	 6E15VLrgMI+1wTRP6j6IgoO7imNHmC8n/h33HD06JEvHX7Iu+1jWAN++kJedOdevN7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="m/aAJyOG";
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18748606A950
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18748606A950
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=m/aAJyOG
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4b9fde3044dso1812765e9.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136849; x=1795741649; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xT+q1UNFy/eh7DrGUJ9/C9po27WSpF2DlTmU++Yh4W8=;
        b=m/aAJyOG791j5yJfwYZpaoBlZRi8N8/0HSTPCHTVZPhmk3fSXv1x+n9Ba9e7POfe4V
         effds6hBZBcMskq7DZ1d3KiHFx+UOtioHkGTulkiKv7uPE2oup2KozcMW05sWI//Q40Y
         ypnJCIkiM48+yTMdshpWYjagdlzdrZ/JSpNTltaT+QtWM0nB1m0kmQSvkMTKKUll4RZ3
         4E3oShMjDGaTSkPd/Tj/u1np3QPK2RsvaGQW567jTrpEkx1xgD/oQXFxmI0r91d8Rw+O
         ejR8Ix/Dorz4SdG0yAN4mwcP+oeuX+NzugSy5aOYLwEFB+E5AQQQ+7+o1mNf+SaWt6WT
         cVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136849; x=1795741649;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xT+q1UNFy/eh7DrGUJ9/C9po27WSpF2DlTmU++Yh4W8=;
        b=xvPqP2RsI0dA2PPr5Hm08NxKPYTJL9Y3RgMXV2xtq7FufIIpXlFMMrTUeKDIz3D/ma
         bwwXbw03uzPKfJufAa9F2WTTMKAzzqgNc1KivdWsZBHQfB9sjoQ00S9mnRDMF/QmaLg4
         S5R/lHYycBfQKBbq3fN+RmUvpssm4oZ9yuP9hfkx+JYjpbUuTxLd85yRaNClnObc6Km+
         ijnhMlgw5N5Z9rv9gmMPBF65vcwhRYULafDtt3AOWutQ3nWrIGSswWSO2XX8kGbEbSrU
         tdchYtYs02NWSpyQcT4oxRMxSJWJLhANYLFHqqht9l4s/bo38b9Bpb8Qr9wd5FcRjKjM
         hD0A==
X-Forwarded-Encrypted: i=1; AL+hErEO4wcffrXCtkYTxj8aazDSHMYE7qgmvk/cQjhKtHfg9B/YEBATKvTowAgPrfXy+iMSKy+kmE6yHow=@vger.kernel.org
X-Gm-Message-State: APuU4Z/hRyYKh87AmhK0DLM/qN7+p8crLsMkCkJht5KalN6LmGAPAZ2I
	Sn7RZ1ThaOnuIX1XoHa0imUqe31J45DlqOTvs/GlZSbgS6nhgq7rAWI1mOkqHBK7PiDW29xMSwx
	x8B8/7g==
X-Received: from wmmu12.prod.google.com ([2002:a05:600c:cc:b0:4a2:9cdb:2bfe])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:848d:b0:4bb:52d8:73ef
 with SMTP id 5b1f17b1804b1-4bb88940f1bmr28030485e9.34.1795136849152; Thu, 19
 Nov 2026 17:07:29 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:55 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-26-lrizzo@google.com>
Subject: [RFC PATCH v3 25/25] Documentation: Add PISA architecture documentation
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

Document the PISA IOMMU 2MB-hugepage-backed DMA memory
subsystem in Documentation/core-api/pisa.rst.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 .../admin-guide/kernel-parameters.txt         |   7 +
 Documentation/core-api/index.rst              |   1 +
 Documentation/core-api/pisa.rst               | 485 ++++++++++++++++++
 3 files changed, 493 insertions(+)
 create mode 100644 Documentation/core-api/pisa.rst

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 176648941aec2..cce75a9abddad 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5345,6 +5345,13 @@ Kernel parameters
 	pirq=		[SMP,APIC] Manual mp-table setup
 			See Documentation/arch/x86/i386/IO-APIC.rst.
 
+	pisa.*=		[ARM64,X86-64] Pre-mapped IOVA Superpage Allocator (PISA)
+			tuning parameters (max_pages, max_idle, idle_ms,
+			reservoir_max, scrub_max, compact,
+			target_usage_percent, old_ms, pcp_batch, user_max_pages,
+			scrub_migrate).
+			See Documentation/core-api/pisa.rst.
+
 	plip=		[PPT,NET] Parallel port network link
 			Format: { parport<nr> | timid | 0 }
 			See also Documentation/admin-guide/parport.rst.
diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index 92f91c6a0d79d..4955f477ed797 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -113,6 +113,7 @@ more memory-management documentation in Documentation/mm/index.rst.
    dma-attributes
    dma-isa-lpc
    swiotlb
+   pisa
    mm-api
    cgroup
    genalloc
diff --git a/Documentation/core-api/pisa.rst b/Documentation/core-api/pisa.rst
new file mode 100644
index 0000000000000..f9690b4a9c96a
--- /dev/null
+++ b/Documentation/core-api/pisa.rst
@@ -0,0 +1,485 @@
+.. SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
+=============================================
+PISA: Pre-mapped IOVA Superpage Allocator
+=============================================
+
+Overview
+========
+
+PISA is an extension to the page allocator: requests with ``__GFP_PISA``
+return memory that makes I/O-related operations cheaper when using
+``DMA-FQ``, ``DMA``, or Confidential Computing ``swiotlb``.  I/O devices
+can individually opt in to use PISA for specific buffer classes (e.g. read
+or write data, headers, zerocopy, ...).  Relevant kernel subsystems
+(mm, iommu, dma, disk I/O, page cache, the network stack) are modified
+to make use of PISA memory for opt-in devices.
+
+The design and implementation have the following main goals:
+
+- no changes to individual device drivers (or minimal changes for NIC drivers
+  that use custom RX page allocators)
+- minimize changes to base code: in most cases one or a few lines of code
+- safety: PISA memory is only used for devices that opt-in,
+  and it is returned to the buddy allocator only after IOMMU mappings
+  and IOTLB entries have been flushed
+- no dependency on ``struct page`` or ``struct folio``
+- compile-time option to disable or enable PISA
+- zero runtime overhead when no devices opt in (via static keys and inline hooks)
+- minimal overhead when in use (direct PFN lookup in a flat metadata table)
+- keep memory overhead as low as possible (adaptive shrinking and compaction
+  of memory)
+
+Mechanisms and performance benefits
+-----------------------------------
+PISA returns order-N blocks backed by 2MB physically contiguous pages, so it
+can use 2MB IOMMU leaves and reduce the IOTLB pressure by up to 512x.
+PISA maps memory in pre-allocated per-domain IOVA ranges, and recycles
+blocks and mappings until the 2MB page is returned to the buddy allocator.
+This makes most of dma map/unmap a no-op, also avoiding related VM exits
+in overcommitted VMs.
+In Confidential Computing VMs, PISA pages are also decrypted, removing the need
+for bounce buffers.
+The kernel identifies devices and sockets that use an
+IOMMU or Confidential Computing and have opted into PISA, and allocates (or
+migrates) I/O buffers using PISA memory so that DMA mapping and unmapping are
+mostly no-ops. All the above makes performance comparable to ``identity`` mode,
+with isolation better than ``DMA-FQ`` and comparable to ``DMA``.
+
+Devices that do not opt in continue to use their native DMA/DMA-FQ mode.
+
+Comparison with standard DMA modes
+----------------------------------
+
+The table below summarizes how PISA (layered on top of strict ``DMA``)
+compares against pass-through/identity mapping (``identity``), batched
+deferred IOTLB flush (``DMA-FQ``), and strict per-request IOMMU mapping
+(``DMA``):
+
+======================================= ==================== ================== ===============
+Feature ( > means better )              vs ``identity``      vs ``DMA-FQ``      vs ``DMA``
+======================================= ==================== ================== ===============
+``dma_map`` cost                        ``PISA ~= identity`` ``PISA >> DMA-FQ`` ``PISA >> DMA``
+``dma_unmap`` cost                      ``PISA == identity`` ``PISA >> DMA-FQ`` ``PISA >> DMA``
+IOTLB friendliness                      ``na``               ``PISA >> DMA-FQ`` ``PISA >> DMA``
+Buffer shared across domains            ``na``               ``PISA <= DMA-FQ`` ``PISA <= DMA``
+Memory remains accessible to device     ``PISA >> identity`` ``PISA >> DMA-FQ`` ``PISA <= DMA``
+Needs bounce buffers                    ``PISA >> identity`` ``PISA >> DMA-FQ`` ``PISA >> DMA``
+Page alloc/free cost                    ``PISA >= identity`` ``PISA >= DMA-FQ`` ``PISA >= DMA``
+======================================= ==================== ================== ===============
+
+Notes on the comparisons:
+
+- **dma_map / dma_unmap cost:** Once a 2MB PISA page is mapped in a domain's
+  reserved IOVA window, ``dma_map_*()`` is an offset lookup and
+  ``dma_unmap_*()`` is a no-op, avoiding IOVA tree
+  allocation, page-table walks, and synchronous IOTLB shootdowns.
+- **IOTLB friendliness:** PISA maps 2MB IOMMU leaves instead of 4KB leaves,
+  covering 512x more memory per IOTLB entry than ``DMA-FQ`` and ``DMA``.
+  A domain without a 2MB page size maps each PISA page with smaller IOMMU
+  pages: mapping is still done once per PISA page, without this benefit.
+- **Buffer shared across domains:** Even in ``DMA-FQ`` and ``DMA``, IOMMU
+  mappings operate at page granularity, so sub-page buffers from ``task_frag``
+  (shared across all sockets of a task) or ``skb`` head slabs can cause the
+  underlying page to be mapped across multiple domains. PISA exhibits the same
+  behavior, just at 2MB granularity.
+- **Memory remains accessible to device:** In ``identity`` mode, all of RAM is
+  always accessible to devices. In ``DMA-FQ``, pages returned to the buddy
+  allocator remain accessible until the asynchronous flush queue drains. Both
+  PISA and ``DMA`` unmap the page and perform a synchronous IOTLB flush before
+  returning memory to the buddy allocator. In all modes, receive buffers remain mapped
+  and accessible to the device while queued in the rx socket buffer.
+- **Needs bounce buffers:** In Confidential Computing (CoCo) VMs, PISA
+  allocators pre-decrypt 2MB pages in place, avoiding ``swiotlb`` bounce-buffer
+  copies across all DMA modes.
+
+Background and motivations
+==========================
+
+I/O devices typically access at least 3-4 different memory regions on
+each transaction (network packet or disk request):
+
+- command, completion and buffer queues
+- optionally, header or metadata buffers (e.g., NIC packet headers, NVMe SGL...)
+- data buffers (TX socket buffers, NIC RX buffers, disk I/O buffers)
+
+Enabling the IOMMU impacts performance for the following reasons:
+
+- CPU cost to install/remove IOMMU Page Table Entries (PTEs)
+  (``dma_map_*()``, ``dma_unmap_*()``)
+- CPU/system overhead to flush the IOTLB, ie remove stale PTEs that could give
+  access to sensitive data or code when memory is recycled for other purposes.
+- Higher DMA read/write latency from IOMMU page walks when the working set
+  exceeds the IOTLB size, backpressuring the bus via flow control.
+  This is one of the biggest bottlenecks for high speed devices:
+  typical network devices have very little IOVA locality, and that makes
+  the IOTLB almost completely ineffective.
+
+There are known methods to mitigate these problems:
+
+1. Recycling I/O buffers and their IOMMU mappings removes most of the DMA
+   map/unmap costs. This is common practice for command, completion and
+   buffer queues, as well as disk I/O and network receive buffers.  Network
+   TX buffers are a noticeable exception. They normally come from
+   ``alloc_pages()`` calls unaware of the leaf device, and require
+   mapping/unmapping on each use.
+
+2. Lazily flushing the IOTLB (as implemented by DMA-FQ) amortizes a
+   very expensive operation (up to several microseconds to wait for
+   completion, necessary for security), but the way it is implemented
+   in DMA-FQ compromises on security: IOTLB flush requests are run
+   periodically in batches, but the underlying memory is recycled without
+   waiting. During that window, the physical memory is still accessible,
+   opening the door to exfiltration or corruption of sensitive data/code.
+
+3. The set of PTEs in active use can be significantly reduced by mapping larger
+   blocks, e.g. 2MB large pages instead of the usual 4KB (PTE). This is not
+   currently pursued by the kernel.
+
+PISA addresses all the above with a combination of simple, known concepts,
+implemented in a way that integrates smoothly with the kernel and drivers:
+
+- intercept calls to the small set of functions used to allocate, map,
+  unmap, and free device-accessible memory (rings and buffers)
+- return memory backed by physically contiguous 2MB PISA pages and 2MB IOMMU
+  mappings
+- heavily recycle memory and mappings
+- wait until the IOTLB has been flushed before returning unused PISA pages
+  to the system
+
+Execution is what makes PISA practical: the implementation intercepts
+a small set of kernel APIs so that devices will inherit the benefits with
+little if any changes, and the design is such that these intercepts have
+minimal impact on the original functions.
+
+Furthermore, since PISA intercepts allocations of device-accessible
+memory, it can transparently configure unencrypted mode, required for
+confidential computing. Under a paravirtualized IOMMU, the long-lived 2MB
+mappings also make host-side pinning of DMA memory a rare event.
+
+Limitations
+===========
+
+The implementation assumes non-preemptible spinlocks, so PISA is not
+compatible with ``PREEMPT_RT``. This is enforced at compile time.
+
+On arm64, PISA requires 4KB pages and at least 4 levels of page tables.
+This is enforced at compile time.
+
+PISA can only be used by DMA-coherent devices. This is enforced at runtime.
+
+IOMMU mappings for data buffers follow the direction the allocator was created
+with. Descriptor queues and receive buffers are ``DMA_BIDIRECTIONAL``, so received
+buffers can be retransmitted (XDP_TX, forwarding) without a new mapping.
+Allocators that only hold transmit data, such as disk/network write buffers and socket TX fragments, are
+``DMA_TO_DEVICE``.
+
+Implementation details
+======================
+
+PISA is implemented by a few groups of commits:
+
+- mm: infrastructure to implement per-page metadata (avoid any dependency on struct page),
+  and hook into ``alloc_pages``, PISA optimizations (per-cpu caches, shrinker, background zeroing)
+- driver core: per-device sysfs entries to opt-in
+- iommu/dma: manage PISA IOVA ranges and intercept map/unmap
+- block/, mm/, net/: transparently upgrade pages to PISA for disk I/O and network tx zerocopy
+- net: identify sockets that need PISA pages, hook PISA into page frags, skb heads, pagepool
+
+Selected NIC drivers that do not use pagepool need small changes (a few lines)
+to pass ``__GFP_PISA_RW`` when allocating RX buffers.
+
+The implementation lives in ``mm/pisa-*.c``, ``drivers/iommu/pisa-map.c``,
+``net/core/pisa-net.c``, and ``include/linux/pisa*.h``.
+
+The set of functions that need to be intercepted is relatively small:
+
+- ``page_pool_dev_alloc*()``, socket TX page frags, ``__free_pages()``
+- ``dma_alloc_attrs()``, ``dma_map_*()``, ``dma_unmap_*()``
+- ``__filemap_get_folio_mpol()``, ``ractl_alloc_folio()``,
+  ``writeback_get_folio()``, ``__bio_iov_iter_get_pages()``, ``madvise()``
+
+and most devices will automatically inherit the benefits. Fast-path hooks
+are guarded by static keys: ``pisa_key`` remains disabled (a single NOP)
+until the first device opts in via sysfs.
+Separate static keys gate TX socket fragments, small TX skb heads,
+user/disk page migration, and compaction checks until those features are
+enabled.
+
+Requirements (for performance and functionality)
+================================================
+
+- efficient identification of PISA pages, based on either their Physical
+  Address (PA) or their I/O Virtual Address (IOVA)
+- fast access to PISA page metadata
+- fast allocation under highly concurrent usage
+- efficient DMA map/unmap
+- comprehensive lifetime management
+- support for confidential computing (decrypted DMA buffers)
+
+Internal mechanisms
+===================
+
+We use the following components:
+
+- **PISA metadata** (``pisa_pfn2slot`` and ``struct pisa_meta``):
+
+  Each 2MB page used for PISA memory is identified by a compact index (``slot``),
+  up to half of physical RAM (256 per 1GB).
+  Identification of PISA pages and per-page metadata use two flat
+  arrays in virtual address space, with holes mapped read-only
+  to a zero page:
+
+  1. ``pisa_pfn2slot[pfn >> PISA_ORDER]`` (4 bytes per 2MB physical frame)
+     packs the page's status flags and the compact page index. It is populated for
+     system RAM at boot or via hotplug events.
+     A full 57-bit address space requires only 256GB of virtual address space
+     and 12KB for page tables, and expands by 4KB for each 2GB of physical RAM,
+     regardless of RAM layout. With ``CONFIG_KASAN_VMALLOC`` the array covers a
+     49-bit address space (1GB of virtual address space), to bound the KASAN
+     shadow memory.
+  2. ``pisa_meta_array[slot]`` (256B per slot/2MB PISA page)
+     holds ``struct pisa_meta``, tracking the page's base PFN, status flags, free/clean/dirty
+     subpage bitmaps, the bitmap of IOMMU domains with an active 2MB mapping
+     for the page, and list/RCU linkage to manage its lifetime.
+     The slot table is sized at boot for up to half of physical RAM (e.g. 128K
+     slots = 32MB of virtual address space for 512GB of RAM), with 4KB backing
+     pages allocated on demand up to ``pisa.max_pages`` (default 1/8th of RAM).
+
+- **Per-domain reserved PISA IOVA ranges**:
+
+  A PISA page can be mapped in multiple domains (e.g.
+  a network buffer used to route packets between different NICs). To simplify
+  address tracking,
+  PISA reserves on each domain an IOVA range covering the slot table
+  (half of physical RAM; the base address may differ per domain),
+  and the page is mapped on demand at an offset ``slot * PISA_SIZE`` in
+  each domain that requires it.
+  This makes PA-IOVA translations just an addition, uniquely identifies
+  PISA IOVAs, and does not expose physical addresses.
+
+- **alloc_pages() compatible pisa_alloc allocator for I/O buffers**:
+
+  PISA implements a pisa_alloc object for fixed-order page allocations
+  returning objects fully compatible with those returned by the page allocator,
+  and with no dependencies on the struct page.
+  ``alloc_pages()`` and related requests are routed to PISA via a
+  ``__GFP_PISA`` flag. This makes it easy to select PISA pages when needed
+  (eg. only two lines in pagepool, similar small changes in page frag refill
+  and disk I/O buffers).
+
+- **Fine grained control**
+
+  Both for experimentation and production use, it is useful to have
+  some form of control on which devices want to use PISA and for
+  what. PISA exposes the following controls. Keep in mind that full
+  performance can only be achieved if all regions are mapped using PISA.
+
+  - ``/sys/devices/*/*/pisa_{coherent,rx_bufs,tx_bufs,tx_skb_heads,tx_zerocopy}``
+    per-device entries that control whether a device uses PISA for coherent
+    allocations, RX/disk-read buffers, TX/disk-write buffers, small TX
+    skb heads, and ``MSG_ZEROCOPY`` user pages
+
+- **Safe release of memory to the system**
+
+  A key feature of PISA is that memory is not released to the system
+  while there are active IOMMU mappings. Release of buffers is managed
+  as follows
+
+  1. on ``__free_pages()`` or ``dma_free_attrs()``, blocks are returned to
+     PISA, IOMMU mappings are still active, and they can be recycled
+
+  2. when all blocks in a PISA page are unused, the page is moved to the
+     allocator's "idle" list, still with active mappings and available for reuse
+
+  3. idle pages above the per-allocator watermark (``pisa.max_idle``) are
+     released by a reclaim work item after the ``pisa.idle_ms`` grace period,
+     and under memory pressure the shrinker also releases reservoir and idle pages
+     from all allocators: the iommu mappings are removed and a synchronous IOTLB
+     flush is issued. The pages are no longer usable for allocations but not
+     returned to the buddy allocator yet
+
+  4. once the previous step is complete, the system schedules ``call_rcu()``
+     and waits for an RCU grace period (and re-encrypts the page if it was
+     decrypted) before returning the PISA page to the buddy allocator.
+
+- **Memory compaction**
+
+  Partially allocated 2MB PISA pages are classified into dense (at most 50%
+  free blocks, placed at the head of the partial list and preferred for new
+  allocations) and sparse (at least 75% free blocks, placed at the tail to
+  drain). When ``pisa.compact`` or ``pisa.target_usage_percent`` is enabled and
+  utilization drops below the target, ``pisa_page_can_recycle()`` stops per-CPU
+  and caller-pool recycling for blocks on old sparse pages so they drain to the
+  idle list. For ``user_pa`` pages, ``pisa.scrub_migrate`` also migrates live
+  4KB pages out of old sparse 2MB pages in the background.
+
+Modified kernel APIs and runtime controls
+=========================================
+
+PISA integrates transparently into existing kernel memory, DMA, and
+networking APIs. Allocation of PISA memory is opt-in via per-device sysfs
+attributes or module parameters.
+
+- **Streaming DMA map and unmap**
+
+  - On map, any buffer belonging to a PISA page
+    (``is_pisa_phys(phys)``) is mapped via the domain's reserved
+    PISA IOVA window with a simple addition, typically reusing
+    existing mappings. Under ``dma-direct``, decrypted PISA pages
+    (``is_pisa_direct(phys, size)``) can be mapped directly without
+    ``swiotlb`` bounce.
+
+    On unmap, IOVAs can be identified as PISA buffers with a simple
+    range check and that results in a no-operation.
+
+- **Coherent DMA allocation and free**
+
+  - PISA is enabled per device via ``/sys/devices/.../pisa_coherent``
+    (``dev->pisa_coherent``). When set, sleepable ``GFP_KERNEL`` coherent
+    allocations up to ``PISA_SIZE`` are rounded up to 4KB, carved out of
+    the per-node order-0 ``pisa_alloc`` via ``pisa_alloc_map_coherent()``, and
+    mapped through the domain's PISA IOVA window (or directly at their
+    physical/decrypted DMA address for ``dma-direct``). ``dma_free_attrs()``
+    releases the order-0 pages via ``pisa_free_coherent()``, which recycles
+    them back to the allocator.
+
+- **Page allocator release**
+
+  - ``pisa_free_page()`` checks ``is_pisa_pfn()``
+    and recycles PISA subpages back to their owning ``pisa_alloc``
+    instead of releasing them to the buddy allocator while their 2MB IOMMU
+    mappings remain active.
+
+- **IOMMU domain teardown**
+
+  - A call to ``pisa_domain_release()`` before freeing a
+    domain's IOVA cookie and page tables clears cached domain state across
+    all allocators. When the last DMA API driver unbinds from a group (or
+    ownership is transferred to VFIO/iommufd), ``pisa_domain_quiesce()``
+    unmaps active PISA pages from that domain and flushes the IOTLB while
+    keeping the reserved window for future rebinds.
+
+Memory allocations are handled as follows:
+
+- **Networking receive packet buffers**
+
+  - PISA is enabled per device via ``pisa_rx_bufs``. A two-line change
+    in pagepool adds ``__GFP_PISA_RW`` to the allocation calls,
+    allocating RX pages from the per-node ``DMA_BIDIRECTIONAL`` PISA
+    allocator and falling back to the buddy allocator on exhaustion.
+
+  - small patches are needed to use PISA memory for RX buffers in devices
+    managing their own page rings e.g. see ``gve`` as an example.
+
+- **Socket TX page fragments**
+
+  - PISA is enabled per device via ``pisa_tx_bufs``, which allows
+    socket TX fragments to be allocated from PISA pages, mapped ``DMA_TO_DEVICE``.
+  - Only data routed to an opt-in device with a DMA parent, outside IPsec,
+    uses PISA memory.  Loopback, virtual devices, kTLS, sockmap, KCM
+    and MPTCP use ordinary pages. ESP output uses PISA memory when its
+    egress device allows it.
+
+    The code implementing these constraints touches multiple
+    files because there isn't a single decision point.
+
+- **Small skb heads**
+
+  - PISA is enabled per device via ``pisa_tx_skb_heads``,
+    which allows small skb heads to come from an ``skbuff_small_head_pisa`` slab cache,
+    backed by PISA memory mapped ``DMA_TO_DEVICE``.
+    PISA memory is only used in the cases listed earlier.
+
+    One exception, PISA memory is never used for skb small heads in Confidential
+    Computing because it would expose kernel pointers and callback structures.
+    The fall back to swiotlb causes allocations, mappings and unmappings
+    per packet that can be avoided with ``ethtool --set-tunable <dev> tx-copybreak <bytes>``
+    which uses PISA memory if ``pisa_coherent`` is enabled.
+
+- **Zerocopy network receive**
+
+  - When ``pisa_rx_bufs`` is enabled, receive buffers allocated from
+    ``DMA_BIDIRECTIONAL`` PISA pages can be mapped directly into user space by
+    ``TCP_ZEROCOPY_RECEIVE`` (``vm_insert_pages()``). On Confidential Computing
+    guests, user PTEs mapping decrypted PISA pages are automatically marked
+    decrypted via ``pgprot_decrypted()``.
+
+- **Zerocopy network transmit**
+
+  - PISA is enabled per device via ``pisa_tx_zerocopy`` (and requires
+    ``pisa.user_max_pages``). ``MSG_ZEROCOPY`` sends best-effort migrate eligible user
+    pages into ``DMA_TO_DEVICE`` PISA blocks (skipping pages still referenced
+    by in-flight skbs). Migrated pages stay readable by the device for as
+    long as they remain in PISA, not only during the send.
+  - If ``pisa_tx_bufs`` is also enabled, TCP copies the pages that could not
+    be migrated into PISA socket fragments. Without ``pisa_tx_zerocopy``,
+    ``MSG_ZEROCOPY`` sends use ordinary per-buffer mappings.
+
+- **User and disk I/O pages**
+
+  - ``madvise(MADV_PISA)`` migrates the present private anonymous pages
+    of a range (splitting large anonymous folios to order 0) into blocks of
+    per-node ``user_pa`` allocators, so that zerocopy sends and I/O from them
+    use the PISA window instead of per-request IOMMU mappings or hypervisor
+    pinning. ``MADV_NOPISA`` migrates them back to ordinary pages. Both are
+    allowed through ``process_madvise()``.
+    Freeing the pages (``munmap()``, ``MADV_DONTNEED``, exit, reclaim)
+    returns the blocks to their allocators.
+  - ``pisa.user_max_pages``: Soft cap on user and page-cache pages held in
+    PISA blocks, in 2MB PISA pages like ``pisa.max_pages``. Setting
+    a non-zero value initializes the per-node ``user_pa`` allocators (for
+    ``DMA_BIDIRECTIONAL``, ``DMA_TO_DEVICE``, and ``DMA_FROM_DEVICE``) and
+    enables ``pisa_user_key``; 0 (default) disables it.
+  - For block devices with ``pisa_rx_bufs`` (reads) or ``pisa_tx_bufs``
+    (writes) enabled on a parent device, new order-0 page-cache folios are
+    allocated directly from ``user_pa``, and writeback or direct-I/O bio
+    preparation migrates eligible folios into ``user_pa`` for the I/O's DMA
+    direction, promoting existing read-only or write-only PISA pages to
+    ``DMA_BIDIRECTIONAL`` when accessed in the opposite direction.
+  - On CoCo guests, user PTEs mapping decrypted PISA blocks are marked
+    decrypted via ``pgprot_decrypted()`` so both user space and the device
+    access the shared page in cleartext.
+
+- **Observability**
+
+  - ``/sys/kernel/debug/pisa/allocs``: Debugfs summary of global, per-node,
+    user-page, and per-allocator allocation, mapping, and fallback counters.
+
+- **Global controls:**
+
+  Module parameters are set on the kernel command line as ``pisa.<name>`` and
+  exposed under ``/sys/module/pisa/parameters/<name>``:
+
+  - ``pisa.max_pages``: Global cap on PISA 2MB pages in use
+    (0 defaults to 1/8th of physical RAM, at least 16 pages). Can be changed
+    at runtime, max is half of physical RAM.
+  - ``pisa.reservoir_max``: Per-NUMA-node reservoir target of pre-allocated
+    PISA pages (defaults to 16 per memory node, 0 = disabled). It cannot be 0
+    in Confidential Computing guests: pages are decrypted in sleepable
+    context, so atomic allocations are only served from the reservoirs, which
+    are also filled when PISA is first enabled.
+  - ``pisa.max_idle``: Per-allocator idle PISA page watermark (default 1,
+    minimum 1) before releasing excess idle pages.
+  - ``pisa.idle_ms``: Grace period in ms (default 200, 0 = immediate) before
+    releasing idle PISA pages above ``pisa.max_idle``.
+  - ``pisa.pcp_batch``: Number of blocks moved per per-CPU cache refill or
+    flush (default 32, range 1..32).
+  - ``pisa.compact``: Usage-based compaction threshold in 2MB PISA pages
+    (0 = disabled). When free blocks across an allocator's non-idle 2MB pages
+    exceed ``compact`` 2MB pages, blocks belonging to sparse partial pages
+    bypass per-CPU caches and caller fragment pools so those sparse pages can
+    drain back to the idle list.
+  - ``pisa.target_usage_percent``: Target minimum block utilization percentage
+    across an allocator's non-idle 2MB pages (0 = disabled, 1..100). When usage
+    is below ``target_usage_percent``%, stop recycling blocks from sparse
+    partial pages older than ``old_ms`` ms so they can drain.
+  - ``pisa.old_ms``: Minimum age in ms before a sparse partial page is drained
+    by ``target_usage_percent`` or migrated by ``scrub_migrate`` (0 = disabled).
+  - ``pisa.scrub_max``: Max 4KB pages of dirty blocks scrubbed per background
+    pass (0 disables background scrubbing).
+  - ``pisa.scrub_migrate``: Background migration of old sparse ``user_pa``
+    pages when usage is below ``target_usage_percent`` (0 = disabled,
+    1 = compact into denser PISA pages, 2 = demote back to the buddy allocator).
+  - ``pisa.user_max_pages``: Soft cap in 2MB PISA pages on user and page-cache
+    pages held in PISA blocks (0 = disabled).
-- 
2.56.1.809.ga0b61035b5-goog

