Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136825;
	b=wEYoQsojGoopu/wXMpmUbIdRWOu99QpJqOxWOWWjpHO3A8Ude69msNQTdXEmBZG12Zny
	 nPRvQaVYarUafkIqt0FD3st8u4UbFEROOyqoEqUyiqzq11Fr53Lb8gFUudMkQgyKV0i/U
	 TdIOUIV5IgShzKFtCc1xuZ8DIuReZf9yXKzGK6S7cOGAm4vVkKWl7VoJdLeDhUyp4IDVn
	 seFEwbPhXL6TotAxyKNUuFu9z4DnR/AM6Y7Ioncwn5JPW5+iVk6BKkhjmH0F88kF8egO0
	 3YpR51Orzce+PNFSzoGkiyUD5+uCX3mI7jJwWV/358eWHmjpGz9i/d+DKvu/zRp/eCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136825;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=t1aJB6r6atfUV3ZJTwGzqycv7tGP6J4ozN1DqiUg75A=;
	b=QFmI28VInNIpuKgdgAu434cLQENhwWh2ns3fbHGMguT/wwcIBgeSfkf1iR7KvKTdVDHv
	 T8ji9wW3gSvBcrf8LdvIsybqd54JfQh1q3Ww0Tg1o9QVPwvQqxWh3zbZSUt5Ml/ltcN6j
	 rdSRkNPrPE5eOnUYB3eydSxeDlPpbRiJ/OnpRBig1zn8h0XJqV4jXuJopsy2fkzXsulb/
	 o4E3cflyBEXZOR3CAl3zDzOpTB9V/5WLKy2Z6czG2oB2JWOrYCeCRQ3lgLU/fn148qE8z
	 wR0u0am+krlJDibq8tZWCxk28rGIRmec4nGDkYJ7rp2UiQHqblNr30N8jxcdzwyhmtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hneqdiOm;
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E27A60A2614
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E27A60A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hneqdiOm
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c505ee61160so41018866b.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136822; x=1795741622; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t1aJB6r6atfUV3ZJTwGzqycv7tGP6J4ozN1DqiUg75A=;
        b=hneqdiOm7mfFGhYoWnsMQS9LrgbdSHwfT9nn150vjQRrk4PHl6Vx4FWkJXatMkIQqC
         8+F3GvAGh4wkJoDcLdIjgLtaCIbd3TKjbM2i7tzu4UbVAl0L2hMv8Rqulz3SumlkaEI9
         52jPLwUhycPQ1GQeZgXxueomQs2JL/eoDzHq1/x9/Wip5xtyjpjq2AsHQCN5XKtkv7CN
         DmKgN/gUA3x3idLzaT2EKu6iNfIcrlByG6uQweT0sZjIeHyRSflX/TCIZ6aahPiKmrHy
         ZYG8qyg73MVCvRqzPYjdAl5hOxz7soDWinDS+DyKYOgLP3AqTkm8YpU9TMTPrT/ssqVS
         D2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136822; x=1795741622;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t1aJB6r6atfUV3ZJTwGzqycv7tGP6J4ozN1DqiUg75A=;
        b=0XrBZQid2Z1x5dHbRjaOIRDVZ3VagZGj/GUEtcG+4IJfx8Ae3vzyayc+kFgVcoRQe1
         yAgg4W/Yb4DQ0XU/Eg44GtIZ5C4DghpRZCau3c1XCC5RbodwQeQhcgwaJOE7hLKeyLxA
         l2yRUVbXICjqwYWi8nhuGkN5wdczCl/wScn++2cyWwfg9RsCxJLNX29wTMgQTJwQL55V
         3wdnzv/RiN1GGZcLZDwsJk/CiMTEIUbKffGk72hd8nj1TkAB3+SGKKckCz+4g0YQt8B1
         SmodUyCDH6fiOAtfHB/3tR33PxU5pYZwAEcGzi7zrPWDf+Lut6fQigcpoavvQphNZ17q
         nopQ==
X-Forwarded-Encrypted: i=1; AL+hErEIBr2jjNg0xW2TX6jK61Tomizr51ceUDrw7JkFg4ZmG1+vNzRZwfblNJ9ujV0OEIWZTxhQV1ER0j4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/ACnN+zxsZToubX5GLci62lPcKnk3Mz4UEbfNOZ3uk2UEipey5
	W+b5U/tPuYXhK2gnMwAVxDJPNbrBf5z7ZddkwEmOOv4kivwivDwDxaiZq+UoA46tH3PDiNGUrU8
	MZek26g==
X-Received: from ejcwt19.prod.google.com ([2002:a17:907:b813:b0:c50:5ea1:d028])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6ea9:b0:c46:645f:cee2
 with SMTP id a640c23a62f3a-c513a3ab024mr152966266b.4.1795136821716; Thu, 19
 Nov 2026 17:07:01 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:31 +0000
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
Message-ID: <20261120010655.467825-2-lrizzo@google.com>
Subject: [RFC PATCH v3 01/25] mm: Introduce CONFIG_PISA and metadata table
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

PISA ("Pre-mapped IOVA Superpage Allocator") is an extension to the page
allocator: requests with __GFP_PISA return memory that makes I/O-related
operations cheaper when using DMA-FQ, DMA, or Confidential Computing
swiotlb. I/O devices can individually opt in to use PISA for specific
buffer classes (e.g. read or write data, headers, zerocopy). The
relevant kernel subsystems (mm, iommu, dma, disk I/O, page cache, the
network stack) are modified to use PISA memory for devices that opt in.

PISA returns order-N blocks backed by 2MB physically contiguous pages,
so it can use 2MB IOMMU leaves and reduce IOTLB pressure by up to 512x.
It maps memory in pre-allocated per-domain IOVA ranges, and recycles
blocks and mappings until the 2MB page is returned to the buddy
allocator. This makes most of dma map/unmap a no-op, also avoiding the
related VM exits in overcommitted VMs. In Confidential Computing VMs,
PISA pages are also decrypted, removing the need for bounce buffers.
Performance is comparable to identity mode, with isolation better than
DMA-FQ and comparable to DMA.

The design has the following main goals:
- no changes to individual device drivers (or minimal changes for NIC
  drivers that use custom RX page allocators)
- minimal changes to base code: in most cases one or a few lines
- safety: PISA memory is only used for devices that opt in, and it is
  returned to the buddy allocator only after IOMMU mappings and IOTLB
  entries have been flushed
- no dependency on struct page or struct folio
- a compile-time option to disable or enable PISA
- zero runtime overhead when no devices opt in (static keys and inline
  hooks), minimal overhead when in use (direct PFN lookup in a flat
  metadata table)
- memory overhead as low as possible (adaptive shrinking and compaction)

Devices that do not opt in keep using their native DMA/DMA-FQ mode.
See Documentation/core-api/pisa.rst, added at the end of the series.

Add a CONFIG_PISA option, enabled only on supported kernels (64bit,
!PREEMPT_RT) and introduce two metadata tables, populated on demand, to
hold per-2MB buffer state:

- pisa_pfn2slot[pfn >> PISA_ORDER] to quickly access flags and
  a compact page index (slot). Covers 57 bit address space with
  only 12KB of page tables (unbacked holes are mapped to the shared
  read-only zero page), plus 4KB for each 2GB of RAM.

- pisa_meta_array[slot] (256B per slot, 4KB of RAM per 32MB of active
  PISA buffers)

Also add a built-in KUnit test suite (CONFIG_PISA_META_KUNIT_TEST)
exercising initialization idempotency, PFN/physical round-trip lookups,
out-of-bounds physical address handling, and PISA membership toggling.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/pisa-iommu.h |  40 +++
 include/linux/pisa.h       | 114 +++++++
 mm/Kconfig                 |  34 +++
 mm/Makefile                |   3 +
 mm/pisa-kunit.c            | 112 +++++++
 mm/pisa-meta.c             | 603 +++++++++++++++++++++++++++++++++++++
 mm/pisa-priv.h             |  61 ++++
 7 files changed, 967 insertions(+)
 create mode 100644 include/linux/pisa-iommu.h
 create mode 100644 include/linux/pisa.h
 create mode 100644 mm/pisa-kunit.c
 create mode 100644 mm/pisa-meta.c
 create mode 100644 mm/pisa-priv.h

diff --git a/include/linux/pisa-iommu.h b/include/linux/pisa-iommu.h
new file mode 100644
index 0000000000000..7a04523b28b4c
--- /dev/null
+++ b/include/linux/pisa-iommu.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* PISA page metadata, shared by mm/pisa-*.c and drivers/iommu/pisa-map.c. */
+#ifndef _LINUX_PISA_IOMMU_H
+#define _LINUX_PISA_IOMMU_H
+
+#include <linux/bitmap.h>
+#include <linux/dma-direct.h>
+#include <linux/list.h>
+#include <linux/llist.h>
+#include <linux/pisa.h>
+
+struct pisa_alloc;
+
+#ifdef CONFIG_PISA
+
+/* PISA page byte size and alignment mask. */
+#define PISA_SIZE		(1UL << PISA_SHIFT)
+#define PISA_MASK		(~(PISA_SIZE - 1))
+
+/* size of struct pisa_meta (256B, power of 2) and max blocks per PISA page. */
+#define _PISA_META_SHIFT	8
+#define _PISA_META_SIZE		(1U << _PISA_META_SHIFT)
+#define _PISA_MAX_BLOCKS	512U
+
+/* Metadata for a single PISA page in @pisa_meta_array (indexed by @slot). */
+struct pisa_meta {
+	unsigned long flags;	/* PISA_ACTIVE / PISA_QUARANTINED / PISA_DECRYPTED */
+	unsigned long base_pfn;	/* base PFN of this PISA page */
+	u32 slot;		/* dense index in @pisa_meta_array and IOVA windows */
+	struct list_head list;	/* node in @pa lists or pisa_node.pages */
+} __aligned(_PISA_META_SIZE);
+
+static_assert(sizeof(struct pisa_meta) == _PISA_META_SIZE);
+
+extern struct pisa_meta *pisa_meta_array;
+
+struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn);
+
+#endif /* CONFIG_PISA */
+#endif /* _LINUX_PISA_IOMMU_H */
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
new file mode 100644
index 0000000000000..660329fd448fe
--- /dev/null
+++ b/include/linux/pisa.h
@@ -0,0 +1,114 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* PISA core definitions and inline hooks. See Documentation/core-api/pisa.rst. */
+#ifndef _LINUX_PISA_H
+#define _LINUX_PISA_H
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+#include <linux/jump_label.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
+
+#ifdef CONFIG_PISA
+
+/* PISA page geometry (log2 byte size and base-page order). */
+#define PISA_SHIFT		21U
+#define PISA_ORDER		(PISA_SHIFT - PAGE_SHIFT)
+
+/*
+ * Physical address bits covered by @pisa_pfn2slot. KASAN_VMALLOC populates
+ * shadow for the whole table KVA up front, so cover 49 bits (1GB of KVA) there.
+ */
+#define _PISA_PHYS_BITS		(IS_ENABLED(CONFIG_KASAN_VMALLOC) ? 49U : 57U)
+#define _PISA_MAX_FRAMES	(1UL << (_PISA_PHYS_BITS - PISA_SHIFT))
+
+/*
+ * @pisa_pfn2slot is indexed by PISA frame (pfn >> PISA_ORDER). Each u32 entry
+ * packs the page's status flags in the low _PISA_SLOT_SHIFT bits and the
+ * 1-based compact metadata slot index (into @pisa_meta_array) in the upper
+ * bits. Unbacked physical ranges point to the read-only zero page.
+ */
+#define _PISA_SLOT_SHIFT	3U	/* low bits reserved for PISA_* flags */
+#define _PISA_FLAGS_MASK	((1U << _PISA_SLOT_SHIFT) - 1)
+enum {
+	_PISA_ACTIVE,
+	_PISA_QUARANTINED,
+};
+
+#define PISA_ACTIVE		BIT(_PISA_ACTIVE)	/* set up as a PISA page, not retired yet */
+#define PISA_QUARANTINED	BIT(_PISA_QUARANTINED)	/* IOMMU unmap failed: never reuse */
+
+/* Enabled on first pisa_meta_init() to activate fast-path hooks. */
+DECLARE_STATIC_KEY_FALSE(pisa_key);
+
+extern u32 *pisa_pfn2slot;
+
+int pisa_meta_init(void);
+
+static inline bool pisa_enabled(void)
+{
+	return static_branch_unlikely(&pisa_key);
+}
+
+static inline u32 pisa_pfn_flags(unsigned long pfn)
+{
+	unsigned long frame = pfn >> PISA_ORDER;
+	u32 val;
+
+	if (!pisa_enabled() || unlikely(frame >= _PISA_MAX_FRAMES))
+		return 0;
+	/*
+	 * A fault means that memory hotplug is replacing the page tables of
+	 * this part of @pisa_pfn2slot (break-before-make): no RAM, so no PISA
+	 * page, was there. The entry is published by smp_store_release() in
+	 * pisa_pfn2slot_update(); what a reader does with it depends on its value.
+	 */
+	__get_kernel_nofault(&val, &pisa_pfn2slot[frame], u32, fault);
+	return val;
+fault:
+	return 0;
+}
+
+/*
+ * ============================================================================
+ * Kernel hooks (every hook starts inline with a static-key check)
+ * ============================================================================
+ */
+
+/* PFN / page / physical / virtual membership checks (guarded by @pisa_key). */
+static inline bool is_pisa_pfn(unsigned long pfn)
+{
+	return pisa_pfn_flags(pfn) & PISA_ACTIVE;
+}
+
+static inline bool is_pisa_page(const struct page *page)
+{
+	return is_pisa_pfn(page_to_pfn(page));
+}
+
+static inline bool is_pisa_phys(phys_addr_t phys)
+{
+	return is_pisa_pfn(phys >> PAGE_SHIFT);
+}
+
+static inline struct page *pisa_virt_to_page(const void *addr)
+{
+	struct page *page;
+
+	if (!pisa_enabled() || !addr)
+		return NULL;
+	page = virt_to_page(addr);
+	return is_pisa_page(page) ? page : NULL;
+}
+
+#else /* !CONFIG_PISA */
+
+static inline int pisa_meta_init(void) { return -EOPNOTSUPP; }
+static inline bool pisa_enabled(void) { return false; }
+static inline bool is_pisa_pfn(unsigned long pfn) { return false; }
+static inline bool is_pisa_page(const struct page *page) { return false; }
+static inline bool is_pisa_phys(phys_addr_t phys) { return false; }
+static inline struct page *pisa_virt_to_page(const void *addr) { return NULL; }
+
+#endif /* CONFIG_PISA */
+#endif /* _LINUX_PISA_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b5438..6e7811569d33a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1431,6 +1431,40 @@ config IOMMU_MM_DATA
 config EXECMEM
 	bool
 
+# Pre-mapped IOVA Superpage Allocator
+config PISA
+	bool "Pre-mapped IOVA Superpage Allocator"
+	depends on (X86_64 && !UML) || (ARM64 && ARM64_4K_PAGES && PGTABLE_LEVELS >= 4)
+	depends on SPARSEMEM && !PREEMPT_RT
+	default y
+	help
+	  PISA is a specialized memory allocator with an API similar to
+	  alloc_pages(). For devices that opt-in, it provides DMA-able
+	  pages backed by 2MB physically contiguous pages, and mapped in
+	  the IOMMU maps with a single leaf PTE of the same size (or with
+	  smaller ones if the IOMMU has no such page size). Mapping, unmapping
+	  and IOTLB flushing are done lazily to reduce CPU overhead.
+	  The large mappings greatly reduce IOTLB usage. As in strict iommu
+	  mode, pages are returned to the buddy allocator only when any existing
+	  mappings have been removed and IOTLB flushed.
+	  Uses 4KB of metadata for each 32MB of PISA buffers, allocated on demand.
+
+	  The config option enforces requirements (2MB large pages and !PREEMPT_RT) at compile
+	  time. Other constraints (e.g. dma-coherent devices) are verified at runtime.
+
+	  If unsure, say Y.
+
+config PISA_META_KUNIT_TEST
+	bool "KUnit test for PISA metadata table (built-in)" if !KUNIT_ALL_TESTS
+	depends on PISA && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Builds KUnit unit tests for the sparse, per-PISA-frame metadata table,
+	  and PISA page allocators in mm/pisa-*.c, verifying metadata
+	  lookup, allocator recycling, and coherent block allocation.
+
+	  If unsure, say N.
+
 config NUMA_MEMBLKS
 	bool
 
diff --git a/mm/Makefile b/mm/Makefile
index 2a3ec53d62eef..55dff84df1555 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -146,6 +146,9 @@ obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
 obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
+obj-$(CONFIG_PISA) += pisa.o
+pisa-y := pisa-meta.o
+obj-$(CONFIG_PISA_META_KUNIT_TEST) += pisa-kunit.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
new file mode 100644
index 0000000000000..0b0dda51e8e60
--- /dev/null
+++ b/mm/pisa-kunit.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * KUnit tests for the opaque struct pisa_meta table API.
+ */
+#include <kunit/test.h>
+#include <linux/gfp.h>
+#include <linux/pisa.h>
+#include <linux/mm.h>
+
+#include "pisa-priv.h"
+
+static void test_meta_init_and_roundtrip(struct kunit *test)
+{
+	unsigned long pfn, base_pfn;
+	struct pisa_meta *m_pfn;
+	struct page *page;
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+	/* Second call must be idempotent. */
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+
+	/* Hold the whole PISA frame so that its slot cannot belong to anyone else. */
+	page = alloc_pages(GFP_KERNEL, PISA_ORDER);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+
+	base_pfn = page_to_pfn(page);
+	pfn = base_pfn + 1;
+
+	if (pisa_meta_ensure_pfn(pfn, true)) {
+		__free_pages(page, PISA_ORDER);
+		KUNIT_FAIL(test, "pisa_meta_ensure_pfn(%lu) failed", pfn);
+		return;
+	}
+	m_pfn = pisa_meta_of_pfn(pfn);
+	KUNIT_EXPECT_EQ(test, pisa_meta_to_pfn(m_pfn), base_pfn);
+	pisa_slot_free(m_pfn);
+	__free_pages(page, PISA_ORDER);
+}
+
+static void test_meta_invalid_phys(struct kunit *test)
+{
+	struct pisa_meta *meta;
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+
+	meta = pisa_meta_of_pfn(ULONG_MAX >> PAGE_SHIFT);
+	KUNIT_ASSERT_NOT_NULL(test, meta);
+	KUNIT_EXPECT_EQ(test, pisa_meta_to_pfn(meta), ULONG_MAX);
+	KUNIT_EXPECT_FALSE(test, is_pisa_pfn(ULONG_MAX >> PAGE_SHIFT));
+	KUNIT_EXPECT_NE(test, pisa_meta_ensure_pfn(ULONG_MAX >> PAGE_SHIFT, false), 0);
+}
+
+static void pisa_meta_set_active(struct pisa_meta *meta, bool active)
+{
+	if (active)
+		pisa_meta_set_flags(meta, PISA_ACTIVE);
+	else
+		pisa_meta_clear_flags(meta, PISA_ACTIVE);
+}
+
+static void test_meta_active_toggle(struct kunit *test)
+{
+	unsigned long pfn, base_pfn;
+	struct pisa_meta *meta;
+	struct page *page;
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+
+	page = alloc_pages(GFP_KERNEL, PISA_ORDER);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+
+	pfn = page_to_pfn(page);
+	base_pfn = ALIGN_DOWN(pfn, 1UL << PISA_ORDER);
+	/* The buddy allocator returns naturally aligned blocks. */
+	KUNIT_EXPECT_EQ(test, pfn, base_pfn);
+	if (pisa_meta_ensure_pfn(pfn, true)) {
+		__free_pages(page, PISA_ORDER);
+		KUNIT_FAIL(test, "pisa_meta_ensure_pfn(%lu) failed", pfn);
+		return;
+	}
+	KUNIT_EXPECT_EQ(test, pisa_meta_ensure_pfn(pfn, false), 0);
+	meta = pisa_meta_of_pfn(pfn);
+
+	KUNIT_EXPECT_FALSE(test, is_pisa_pfn(pfn));
+
+	pisa_meta_set_active(meta, true);
+	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(base_pfn));
+	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(pfn));
+	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(base_pfn + (1UL << PISA_ORDER) - 1));
+
+	pisa_meta_set_active(meta, false);
+	KUNIT_EXPECT_FALSE(test, is_pisa_pfn(pfn));
+
+	pisa_slot_free(meta);
+	__free_pages(page, PISA_ORDER);
+}
+
+static struct kunit_case pisa_meta_test_cases[] = {
+	KUNIT_CASE(test_meta_init_and_roundtrip),
+	KUNIT_CASE(test_meta_invalid_phys),
+	KUNIT_CASE(test_meta_active_toggle),
+	{}
+};
+
+static struct kunit_suite pisa_meta_test_suite = {
+	.name = "pisa_meta",
+	.test_cases = pisa_meta_test_cases,
+};
+
+kunit_test_suite(pisa_meta_test_suite);
+MODULE_DESCRIPTION("KUnit tests for struct pisa_meta table");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/mm/pisa-meta.c b/mm/pisa-meta.c
new file mode 100644
index 0000000000000..734f49320047a
--- /dev/null
+++ b/mm/pisa-meta.c
@@ -0,0 +1,603 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * PISA two-level metadata tables: @pisa_pfn2slot and @pisa_meta_array.
+ * See Documentation/core-api/pisa.rst for the architecture overview.
+ *
+ * Metadata is split into two tables to keep fast-path PFN membership checks
+ * compact and cache-friendly while allocating full 256-byte per-page metadata
+ * only for active and reservoir PISA pages:
+ *
+ * 1. @pisa_pfn2slot[pfn >> PISA_ORDER] (4 bytes per PISA_SIZE physical frame):
+ *    Each u32 entry packs status flags (PISA_ACTIVE, PISA_QUARANTINED,
+ *    PISA_DECRYPTED) in the low _PISA_SLOT_SHIFT (3) bits and a 1-based compact
+ *    slot index (1 .. @pisa_nr_slots) in bits [31:3] (0 = not a PISA frame).
+ *
+ *    One PTE page of @pisa_pfn2slot holds 1,024 entries covering 2GB of
+ *    physical address space:
+ *    - At pisa_meta_init(), leaf PTEs for the entire 256GB KVA range (covering
+ *      57-bit physical space, @_PISA_MAX_FRAMES; 1GB and 49-bit with
+ *      KASAN_VMALLOC) are mapped to the shared
+ *      read-only zero page (PAGE_KERNEL_RO) using a single shared PTE table
+ *      (@pisa_zero_ptes) across PMD holes (1TB physical) and a single
+ *      shared PMD table (@pisa_zero_pmds) across 1GB PUD holes (512TB
+ *      physical). Every 2GB chunk overlapping present system RAM is backed with
+ *      a writable PTE page before @pisa_key is enabled (and on MEM_GOING_ONLINE
+ *      for hotplugged RAM).
+ *    - Any PFN < @_PISA_MAX_FRAMES (including MMIO/sparse holes) can therefore be
+ *      read directly without a chunk bitmap or runtime TLB shootdowns, and
+ *      is_pisa_pfn() reduces to a single bounds-checked u32 load.
+ *
+ * 2. @pisa_meta_array[slot] (256 bytes per slot, 16 slots per PTE page):
+ *    Indexed by the 0-based compact @slot in [0, @pisa_nr_slots), which also
+ *    serves as the page's offset, in PISA_SIZE units, in every domain's PISA IOVA window.
+ *    Its PTE page tables are preallocated at pisa_meta_init(), and backing
+ *    pages are installed lazily on first allocation of a slot in each 16-slot
+ *    chunk.
+ *
+ * Memory footprint for 57-bit physical address space and 128K PISA pages:
+ *   - @pisa_pfn2slot KVA reservation: 256GB (PUD-aligned)
+ *   - @pisa_pfn2slot page tables: 2 PTE pages shared + 1 per 1TB slice with RAM
+ *   - @pisa_pfn2slot RAM backing pages: 2KB per 1GB of present RAM (2MB / 1TB)
+ *   - @pisa_meta_array PTE tables (128K slots = 32MB KVA): 64KB
+ *   - @pisa_meta_array backing pages (on demand): 1 PTE page per 16 slots (32MB at 128K)
+ */
+
+#include <linux/bitmap.h>
+#include <linux/cache.h>
+#include <linux/cacheflush.h>
+#include <linux/pisa.h>
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/memblock.h>
+#include <linux/memory.h>
+#include <linux/moduleparam.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/pgalloc.h>
+#include <linux/pgtable.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/vmalloc.h>
+#include <asm/tlbflush.h>
+
+#include "pisa-priv.h"
+
+static_assert(_PISA_META_SIZE <= PAGE_SIZE);
+static_assert(PISA_SIZE <= SZ_2M);
+static_assert(PISA_BLOCKS(0) <= _PISA_MAX_BLOCKS);
+static_assert(PISA_ORDER <= MAX_PAGE_ORDER);
+static_assert(PISA_SHIFT <= SUBSECTION_SHIFT);
+
+/* log2(sizeof(u32)): 4 bytes per PISA frame in @pisa_pfn2slot. */
+#define PISA_PFN2SLOT_SHIFT		2
+/* Base-page order covered by one PTE page of @pisa_pfn2slot (1024 PISA frames, 2GB). */
+#define PISA_PFN2SLOT_CHUNK_ORDER	(PISA_ORDER + PAGE_SHIFT - PISA_PFN2SLOT_SHIFT)
+/* Total KVA size of @pisa_pfn2slot (2^36 frames * 4B = 256GB). */
+#define PISA_PFN2SLOT_SIZE		(_PISA_MAX_FRAMES << PISA_PFN2SLOT_SHIFT)
+/* Number of 256B struct pisa_meta entries per PTE page (16). */
+#define PISA_META_PER_PAGE	(PAGE_SIZE >> _PISA_META_SHIFT)
+/* Max 1-based slot index representable in the upper (32 - _PISA_SLOT_SHIFT) bits. */
+#define PISA_MAX_SLOTS		((1U << (32 - _PISA_SLOT_SHIFT)) - 1)
+
+/* Enabled by pisa_meta_init() to activate fast-path hooks. */
+DEFINE_STATIC_KEY_FALSE(pisa_key);
+EXPORT_SYMBOL(pisa_key);
+
+/*
+ * Number of compact metadata / PISA-page IOVA slots (half of physical RAM). Each
+ * PISA page holds one slot in [0, pisa_nr_slots), indexing @pisa_meta_array[slot]
+ * and mapping at slot * PISA_SIZE in each domain's PISA window.
+ */
+unsigned int pisa_nr_slots __read_mostly;
+/* One bit per slot, set while a PISA page holds the slot. */
+unsigned long *pisa_slot_bitmap __read_mostly;
+
+/* Indirection table from PISA frame (pfn >> PISA_ORDER) to (slot + 1) | flags. */
+u32 *pisa_pfn2slot __read_mostly;
+EXPORT_SYMBOL(pisa_pfn2slot);
+
+/* Compact metadata table, indexed by @slot in [0, @pisa_nr_slots). */
+struct pisa_meta *pisa_meta_array __read_mostly;
+
+/* Shared sink entry returned for unbacked or out-of-range PFNs. */
+static struct pisa_meta pisa_meta_nil __read_mostly = {
+	.base_pfn = ULONG_MAX,
+};
+
+/* Shared read-only page tables mapping unbacked @pisa_pfn2slot holes to ZERO_PAGE. */
+static pte_t *pisa_zero_ptes __read_mostly;
+static pmd_t *pisa_zero_pmds __read_mostly;
+
+/* Protects init and hotplug page-table population. */
+static DEFINE_MUTEX(pisa_meta_mutex);
+/* Protects slot allocation/release and on-demand @pisa_meta_array PTE install. */
+static DEFINE_SPINLOCK(pisa_slot_lock);
+static unsigned int pisa_slot_hint;	/* no free slot below this */
+
+/*
+ * Size the global PISA page budget (@pisa_max_pages, default 12.5% of RAM) and
+ * the compact slot / per-domain IOVA window (@pisa_nr_slots, half of RAM).
+ */
+void pisa_slots_configure(void)
+{
+	pisa_nr_slots = min_t(unsigned long, totalram_pages() >> (PISA_ORDER + 1),
+			      PISA_MAX_SLOTS);
+}
+
+/* Return metadata for @pfn, or shared sink @pisa_meta_nil (flags == 0) if unbacked. */
+struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn)
+{
+	u32 slot = pisa_pfn_flags(pfn) >> _PISA_SLOT_SHIFT;
+
+	if (unlikely(!slot || slot > pisa_nr_slots))
+		return &pisa_meta_nil;
+
+	return &pisa_meta_array[slot - 1];
+}
+
+/* PTE for @addr in a vmalloc metadata table, or NULL if not allocated. */
+static pte_t *pisa_meta_pte(unsigned long addr)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	if (pgd_none(pgdp_get(pgd)))
+		return NULL;
+	p4d = p4d_offset(pgd, addr);
+	if (p4d_none(p4dp_get(p4d)))
+		return NULL;
+	pud = pud_offset(p4d, addr);
+	if (pud_none(pudp_get(pud)))
+		return NULL;
+	pmd = pmd_offset(pud, addr);
+	if (pmd_none(pmdp_get(pmd)))
+		return NULL;
+	return pte_offset_kernel(pmd, addr);
+}
+
+static void pisa_zero_tables_free(void)
+{
+	if (pisa_zero_pmds)
+		pmd_free(&init_mm, pisa_zero_pmds);
+	if (pisa_zero_ptes)
+		pte_free_kernel(&init_mm, pisa_zero_ptes);
+	pisa_zero_pmds = NULL;
+	pisa_zero_ptes = NULL;
+}
+
+/*
+ * Allocate two shared page-table pages for unbacked @pisa_pfn2slot ranges:
+ * - @pisa_zero_ptes (covers one PMD of KVA / 1TB physical): 512 read-only ZERO_PAGE PTEs.
+ * - @pisa_zero_pmds (covers 1GB KVA / 512TB physical): 512 PMDs -> @pisa_zero_ptes.
+ */
+static int pisa_zero_tables_init(void)
+{
+	pisa_zero_ptes = pte_alloc_one_kernel(&init_mm);
+	pisa_zero_pmds = pmd_alloc_one(&init_mm, 0);
+	if (!pisa_zero_ptes || !pisa_zero_pmds) {
+		pisa_zero_tables_free();
+		return -ENOMEM;
+	}
+
+	for (unsigned int i = 0; i < PTRS_PER_PTE; i++)
+		set_pte(&pisa_zero_ptes[i], mk_pte(ZERO_PAGE(0), PAGE_KERNEL_RO));
+
+	for (unsigned int i = 0; i < PTRS_PER_PMD; i++)
+		pmd_populate_kernel(&init_mm, &pisa_zero_pmds[i], pisa_zero_ptes);
+	return 0;
+}
+
+/*
+ * Map the PUD-aligned 256GB KVA range of @pisa_pfn2slot to ZERO_PAGE
+ * by pointing every 1GB PUD entry at @pisa_zero_pmds.
+ */
+static int pisa_pfn2slot_init_zero(unsigned long start)
+{
+	unsigned long end = start + PISA_PFN2SLOT_SIZE, addr;
+	int ret = -ENOMEM;
+
+	for (addr = start; addr < end; addr += PUD_SIZE) {
+		pgd_t *pgd = pgd_offset_k(addr);
+		p4d_t *p4d = p4d_alloc(&init_mm, pgd, addr);
+		pud_t *pud = p4d ? pud_alloc(&init_mm, p4d, addr) : NULL;
+
+		if (!pud)
+			goto undo;
+		/* An earlier user of this vmalloc range may have left page tables. */
+		if (!pud_none(pudp_get(pud)) && !pud_free_pmd_page(pud, addr)) {
+			ret = -EBUSY;
+			goto undo;
+		}
+		pud_populate(&init_mm, pud, pisa_zero_pmds);
+	}
+	return 0;
+
+undo:
+	/* Only the shared zero tables are mapped so far: unhook them. */
+	while (addr > start) {
+		addr -= PUD_SIZE;
+		pud_clear(pud_offset(p4d_offset(pgd_offset_k(addr), addr), addr));
+	}
+	return ret;
+}
+
+/*
+ * Lookups run only with @pisa_key on. Test the key itself, not the patched
+ * branch, and only after clearing an entry: a lookup that could have cached
+ * the old entry started with the key already on.
+ */
+static bool pisa_pfn2slot_has_readers(void)
+{
+	return static_key_enabled(&pisa_key);
+}
+
+/*
+ * Unshare @pisa_zero_pmds and @pisa_zero_ptes along the page-table path to
+ * @addr so the caller can install a writable PTE page at the leaf PTE while
+ * sibling entries remain mapped to ZERO_PAGE.
+ *
+ * A valid entry is cleared before it is replaced (break-before-make, which
+ * arm64 requires) and flushed if lookups may be running. A lookup that runs
+ * in between faults, and pisa_pfn_flags() reads 0. That is right: an entry
+ * that still points to a shared zero table covers no RAM, so only lookups of
+ * addresses without RAM can hit the window. The table-level flushes are
+ * flush_tlb_all(): a range flush may leave intermediate entries cached.
+ */
+static pte_t *pisa_pfn2slot_unshare_pte(unsigned long addr)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	p4d_t *p4d = p4d_offset(pgd, addr);
+	pud_t *pud = pud_offset(p4d, addr);
+	pmd_t *pmd;
+
+	/* Replace shared 1GB @pisa_zero_pmds with a private PMD table. */
+	if (pud_pgtable(pudp_get(pud)) == pisa_zero_pmds) {
+		pmd = pmd_alloc_one(&init_mm, addr);
+		if (!pmd)
+			return NULL;
+		for (unsigned int i = 0; i < PTRS_PER_PMD; i++)
+			pmd_populate_kernel(&init_mm, &pmd[i], pisa_zero_ptes);
+		pud_clear(pud);
+		if (pisa_pfn2slot_has_readers())
+			flush_tlb_all();
+		pud_populate(&init_mm, pud, pmd);
+	}
+
+	/* Replace the shared @pisa_zero_ptes with a private PTE table. */
+	pmd = pmd_offset(pud, addr);
+	if ((pte_t *)pmd_page_vaddr(pmdp_get(pmd)) == pisa_zero_ptes) {
+		pte_t *new_ptes = pte_alloc_one_kernel(&init_mm);
+
+		if (!new_ptes)
+			return NULL;
+		for (unsigned int i = 0; i < PTRS_PER_PTE; i++)
+			set_pte(&new_ptes[i], mk_pte(ZERO_PAGE(0), PAGE_KERNEL_RO));
+		pmd_clear(pmd);
+		if (pisa_pfn2slot_has_readers())
+			flush_tlb_all();
+		pmd_populate_kernel(&init_mm, pmd, new_ptes);
+	}
+
+	return pte_offset_kernel(pmd, addr);
+}
+
+/*
+ * Back each PTE page of @pfn2slot (covering 2GB of physical space, or
+ * 1 << PISA_PFN2SLOT_CHUNK_ORDER base pages) that overlaps [@start_pfn, @end_pfn)
+ * with a writable zeroed page on the corresponding NUMA node.
+ */
+static int pisa_pfn2slot_populate(u32 *pfn2slot, unsigned long start_pfn,
+				  unsigned long end_pfn)
+{
+	unsigned long idx, end_idx;
+
+	end_pfn = min(end_pfn, _PISA_MAX_FRAMES << PISA_ORDER);
+	if (start_pfn >= end_pfn)
+		return 0;
+
+	idx = start_pfn >> PISA_PFN2SLOT_CHUNK_ORDER;
+	end_idx = ((end_pfn - 1) >> PISA_PFN2SLOT_CHUNK_ORDER) + 1;
+	for (; idx < end_idx; idx++) {
+		unsigned long addr = (unsigned long)pfn2slot + (idx << PAGE_SHIFT);
+		unsigned long pfn = max(start_pfn, idx << PISA_PFN2SLOT_CHUNK_ORDER);
+		/* Not pfn_to_online_page(): a range that is going online is not online yet. */
+		int nid = pfn_valid(pfn) ? pfn_to_nid(pfn) : NUMA_NO_NODE;
+		pte_t *ptep = pisa_meta_pte(addr);
+		struct page *page;
+
+		if (WARN_ON_ONCE(!ptep))
+			return -EINVAL;
+		/* Already backed by a writable page from an earlier RAM range. */
+		if (pte_write(ptep_get(ptep)))
+			continue;
+
+		ptep = pisa_pfn2slot_unshare_pte(addr);
+		if (!ptep)
+			return -ENOMEM;
+
+		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_ZERO, 0);
+		if (!page)
+			return -ENOMEM;
+
+		/* Break the zero-page PTE before making the new one, as above. */
+		pte_clear(&init_mm, addr, ptep);
+		if (pisa_pfn2slot_has_readers())
+			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+		set_pte_at(&init_mm, addr, ptep, pfn_pte(page_to_pfn(page), PAGE_KERNEL));
+		flush_cache_vmap(addr, addr + PAGE_SIZE);
+	}
+	return 0;
+}
+
+static int pisa_pfn2slot_populate_ram(unsigned long start_pfn, unsigned long nr_pages, void *arg)
+{
+	return pisa_pfn2slot_populate(arg, start_pfn, start_pfn + nr_pages);
+}
+
+/*
+ * Tear down a partially populated @pisa_pfn2slot VM area on pisa_meta_init()
+ * failure. All PUD entries are cleared before free_vm_area() so
+ * vunmap_range_noflush() does not clear PTEs inside the shared zero tables;
+ * private page tables and their writable pages are freed. The range was never
+ * accessed, so no TLB entry refers to the freed tables.
+ */
+static void pisa_pfn2slot_free(struct vm_struct *vm)
+{
+	unsigned long start = ALIGN((unsigned long)vm->addr, PUD_SIZE);
+	unsigned long end = start + PISA_PFN2SLOT_SIZE;
+
+	for (unsigned long addr = start; addr < end; addr += PUD_SIZE) {
+		pgd_t *pgd = pgd_offset_k(addr);
+		p4d_t *p4d = pgd_none(pgdp_get(pgd)) ? NULL : p4d_offset(pgd, addr);
+		pud_t *pud = (!p4d || p4d_none(p4dp_get(p4d))) ? NULL : pud_offset(p4d, addr);
+		pmd_t *pmds;
+
+		if (!pud || pud_none(pudp_get(pud)))
+			continue;
+		pmds = pud_pgtable(pudp_get(pud));
+		pud_clear(pud);
+		if (pmds == pisa_zero_pmds)
+			continue;
+
+		for (unsigned int i = 0; i < PTRS_PER_PMD; i++) {
+			pte_t *ptes = (pte_t *)pmd_page_vaddr(pmdp_get(&pmds[i]));
+
+			if (ptes == pisa_zero_ptes)
+				continue;
+			for (unsigned int j = 0; j < PTRS_PER_PTE; j++) {
+				pte_t pte = ptep_get(&ptes[j]);
+
+				if (pte_write(pte))
+					__free_page(pte_page(pte));
+			}
+			pte_free_kernel(&init_mm, ptes);
+		}
+		pmd_free(&init_mm, pmds);
+	}
+	free_vm_area(vm);
+}
+
+/* Populate @pisa_pfn2slot chunks for memory about to go online. */
+static int pisa_meta_memory_cb(struct notifier_block *nb, unsigned long action, void *arg)
+{
+	struct memory_notify *mn = arg;
+	int ret = 0;
+
+	if (action != MEM_GOING_ONLINE)
+		return NOTIFY_OK;
+
+	guard(mutex)(&pisa_meta_mutex);
+	if (pisa_pfn2slot)
+		ret = pisa_pfn2slot_populate(pisa_pfn2slot, mn->start_pfn,
+					     mn->start_pfn + mn->nr_pages);
+	return notifier_from_errno(ret);
+}
+
+static struct notifier_block pisa_meta_memory_nb = {
+	.notifier_call = pisa_meta_memory_cb,
+};
+
+/*
+ * Registered at boot so that no MEM_GOING_ONLINE event is missed around
+ * pisa_meta_init(): the callback does nothing until @pisa_pfn2slot is set, and
+ * RAM added before that is in the resource tree that pisa_meta_init() walks.
+ */
+static int __init pisa_meta_notifier_init(void)
+{
+	return register_memory_notifier(&pisa_meta_memory_nb);
+}
+core_initcall(pisa_meta_notifier_init);
+
+/*
+ * Bind @pfn's PISA frame to a compact slot in @pisa_meta_array and record
+ * (slot + 1) << _PISA_SLOT_SHIFT in @pisa_pfn2slot[pfn >> PISA_ORDER]. Backing
+ * PTE pages for @pisa_meta_array (16 slots per page) are allocated lazily on
+ * first use of a slot within each PTE page.
+ */
+int pisa_meta_ensure_pfn(unsigned long pfn, bool can_block)
+{
+	gfp_t gfp = (can_block ? GFP_KERNEL : GFP_ATOMIC) | __GFP_ZERO | __GFP_NOWARN;
+	unsigned long frame = pfn >> PISA_ORDER, flags;
+	struct page *new_page = NULL;
+	struct pisa_meta *meta;
+	unsigned int slot;
+	pte_t *ptep;
+	int ret = 0;
+
+	if (!pisa_enabled() || frame >= _PISA_MAX_FRAMES)
+		return -ERANGE;
+	if (READ_ONCE(pisa_pfn2slot[frame]) >> _PISA_SLOT_SHIFT)
+		return 0;
+	/* Reject PFNs outside present RAM (chunk still mapped to ZERO_PAGE) or offline. */
+	ptep = pisa_meta_pte((unsigned long)&pisa_pfn2slot[frame]);
+	if (unlikely(!ptep || !pte_write(ptep_get(ptep)) || !pfn_to_online_page(pfn)))
+		return -ERANGE;
+
+retry:
+	spin_lock_irqsave(&pisa_slot_lock, flags);
+	if (unlikely(READ_ONCE(pisa_pfn2slot[frame]) >> _PISA_SLOT_SHIFT))
+		goto out_unlock;
+
+	slot = find_next_zero_bit(pisa_slot_bitmap, pisa_nr_slots, pisa_slot_hint);
+	if (unlikely(slot >= pisa_nr_slots)) {
+		ret = -ENOSPC;
+		goto out_unlock;
+	}
+
+	/* Lazily back the PTE page covering this 16-slot chunk of @pisa_meta_array. */
+	meta = &pisa_meta_array[slot];
+	ptep = pisa_meta_pte((unsigned long)meta);
+	if (pte_none(ptep_get(ptep))) {
+		unsigned long addr = (unsigned long)meta & PAGE_MASK;
+
+		if (!new_page) {
+			/* Allocate outside the lock, this opens a race so retry. */
+			spin_unlock_irqrestore(&pisa_slot_lock, flags);
+			new_page = alloc_pages_node(pfn_to_nid(pfn), gfp, 0);
+			if (new_page)
+				goto retry;
+			return -ENOMEM;
+		}
+		set_pte_at(&init_mm, addr, ptep, pfn_pte(page_to_pfn(new_page), PAGE_KERNEL));
+		flush_cache_vmap(addr, addr + PAGE_SIZE);
+		new_page = NULL;
+	}
+
+	memset(meta, 0, sizeof(*meta));
+	meta->base_pfn = frame << PISA_ORDER;
+	meta->slot = slot;
+	INIT_LIST_HEAD(&meta->list);
+	/* Ensure @meta is initialized before @slot is visible in @pisa_slot_bitmap. */
+	smp_wmb();
+	__set_bit(slot, pisa_slot_bitmap);
+	pisa_slot_hint = slot + 1;
+	pisa_pfn2slot_update(meta);
+out_unlock:
+	spin_unlock_irqrestore(&pisa_slot_lock, flags);
+	if (new_page)
+		__free_page(new_page);
+	return ret;
+}
+
+/* Return @meta's slot once no domain or RCU reader can reference it. */
+void pisa_slot_free(struct pisa_meta *meta)
+{
+	unsigned long frame = meta->base_pfn >> PISA_ORDER;
+	unsigned int slot = meta->slot;
+
+	if (unlikely(meta == &pisa_meta_nil || frame >= _PISA_MAX_FRAMES ||
+		     (meta->flags & PISA_QUARANTINED)))
+		return;
+
+	guard(spinlock_irqsave)(&pisa_slot_lock);
+	WRITE_ONCE(pisa_pfn2slot[frame], 0);
+	WRITE_ONCE(meta->base_pfn, ULONG_MAX);
+	__clear_bit(slot, pisa_slot_bitmap);
+	if (slot < pisa_slot_hint)
+		pisa_slot_hint = slot;
+}
+
+/* Reserve @pisa_pfn2slot and @pisa_meta_array and populate page tables. */
+int pisa_meta_init(void)
+{
+	struct vm_struct *pfn2slot_vm, *meta_vm;
+	unsigned long meta_size;
+	unsigned long *bitmap;
+	struct pisa_meta *meta;
+	u32 *pfn2slot;
+	static int pisa_init_err;
+	int ret = 0;
+
+	if (pisa_enabled())
+		return 0;
+
+	mutex_lock(&pisa_meta_mutex);
+	if (pisa_init_err) {
+		/* A previous init attempt failed. */
+		mutex_unlock(&pisa_meta_mutex);
+		return pisa_init_err;
+	}
+	if (pisa_pfn2slot) {
+		/* The previous caller completed init while we waited on the mutex. */
+		mutex_unlock(&pisa_meta_mutex);
+		goto out_enable;
+	}
+
+	pisa_slots_configure();
+	meta_size = ALIGN((unsigned long)pisa_nr_slots << _PISA_META_SHIFT, PMD_SIZE);
+
+	ret = pisa_zero_tables_init();
+	if (ret)
+		goto out_unlock;
+
+	bitmap = kvcalloc(BITS_TO_LONGS(pisa_nr_slots), sizeof(unsigned long), GFP_KERNEL);
+	if (!bitmap) {
+		ret = -ENOMEM;
+		goto out_free_bitmap;
+	}
+
+	/*
+	 * Over-allocate by PUD_SIZE / PMD_SIZE so the aligned base pointers
+	 * span an exact number of PUDs / PMDs with no unaligned fringes.
+	 */
+	pfn2slot_vm = get_vm_area(PISA_PFN2SLOT_SIZE + PUD_SIZE, VM_MAP);
+	if (!pfn2slot_vm) {
+		ret = -ENOMEM;
+		goto out_free_bitmap;
+	}
+
+	meta_vm = get_vm_area(meta_size + PMD_SIZE, VM_MAP);
+	if (!meta_vm) {
+		free_vm_area(pfn2slot_vm);
+		ret = -ENOMEM;
+		goto out_free_bitmap;
+	}
+
+	/* Map all 256GB of @pfn2slot to ZERO_PAGE, then back present RAM chunks. */
+	pfn2slot = PTR_ALIGN(pfn2slot_vm->addr, PUD_SIZE);
+	ret = pisa_pfn2slot_init_zero((unsigned long)pfn2slot);
+	if (ret) {
+		/* Nothing is mapped in either area. */
+		free_vm_area(meta_vm);
+		free_vm_area(pfn2slot_vm);
+		goto out_free_bitmap;
+	}
+
+	ret = walk_system_ram_range(0, _PISA_MAX_FRAMES << PISA_ORDER, pfn2slot,
+				    pisa_pfn2slot_populate_ram);
+	if (ret)
+		goto out_free_vms;
+
+	/* Pre-allocate PTE page tables for @pisa_meta_array (leaf PTEs stay pte_none). */
+	meta = PTR_ALIGN(meta_vm->addr, PMD_SIZE);
+	ret = apply_to_page_range(&init_mm, (unsigned long)meta, meta_size,
+				  NULL, NULL);
+	if (ret)
+		goto out_free_vms;
+
+	pisa_slot_bitmap = bitmap;
+	pisa_meta_array = meta;
+	pisa_pfn2slot = pfn2slot;
+
+	pr_info("pisa: %lu GB pfn2slot KVA, %u slots (%lu KB meta KVA)\n",
+		PISA_PFN2SLOT_SIZE >> 30, pisa_nr_slots, meta_size >> 10);
+	mutex_unlock(&pisa_meta_mutex);
+out_enable:
+	static_branch_enable(&pisa_key);
+	return 0;
+
+out_free_vms:
+	free_vm_area(meta_vm);
+	pisa_pfn2slot_free(pfn2slot_vm);
+out_free_bitmap:
+	kvfree(bitmap);
+	pisa_zero_tables_free();
+out_unlock:
+	pr_err("pisa: metadata init failed (%d)\n", ret);
+	pisa_init_err = ret;
+	mutex_unlock(&pisa_meta_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(pisa_meta_init);
diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
new file mode 100644
index 0000000000000..b52522cb28fcc
--- /dev/null
+++ b/mm/pisa-priv.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* PISA internals shared by mm/pisa-*.c. */
+#ifndef _MM_PISA_PRIV_H
+#define _MM_PISA_PRIV_H
+
+#include <linux/moduleparam.h>
+#include <linux/pisa-iommu.h>
+
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "pisa."
+#include <linux/spinlock.h>
+
+#ifdef CONFIG_PISA
+
+/* Number of order-@order blocks in one PISA page. */
+#define PISA_BLOCKS(order)	(1U << (PISA_ORDER - (order)))
+
+/* Publish meta->flags into the pfn2slot array. */
+static inline void pisa_pfn2slot_update(const struct pisa_meta *meta)
+{
+	u32 entry = ((meta->slot + 1) << _PISA_SLOT_SHIFT) |
+		    (READ_ONCE(meta->flags) & _PISA_FLAGS_MASK);
+
+	/* Pairs with smp_load_acquire() in pisa_pfn_flags(). */
+	smp_store_release(&pisa_pfn2slot[meta->base_pfn >> PISA_ORDER], entry);
+}
+
+/*
+ * Atomic, because pisa_quarantine_page() sets PISA_QUARANTINED concurrently.
+ * PISA_ACTIVE and PISA_DECRYPTED, the only flags read from @pisa_pfn2slot,
+ * have one writer at a time, so the copy published below cannot go backwards.
+ */
+static inline void pisa_meta_set_flags(struct pisa_meta *meta, unsigned long mask)
+{
+	set_mask_bits(&meta->flags, 0, mask);
+	pisa_pfn2slot_update(meta);
+}
+
+static inline void pisa_meta_clear_flags(struct pisa_meta *meta, unsigned long mask)
+{
+	set_mask_bits(&meta->flags, mask, 0);
+	pisa_pfn2slot_update(meta);
+}
+
+int pisa_meta_ensure_pfn(unsigned long pfn, bool can_block);
+void pisa_slots_configure(void);
+
+static inline unsigned long pisa_meta_to_pfn(const struct pisa_meta *meta)
+{
+	return meta->base_pfn;
+}
+
+static inline struct page *pisa_meta_to_page(const struct pisa_meta *meta)
+{
+	return pfn_to_page(pisa_meta_to_pfn(meta));
+}
+
+void pisa_slot_free(struct pisa_meta *meta);
+
+#endif /* CONFIG_PISA */
+#endif /* _MM_PISA_PRIV_H */
-- 
2.56.1.809.ga0b61035b5-goog

