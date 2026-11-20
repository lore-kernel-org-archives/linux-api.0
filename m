Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136831;
	b=llCYujbicyvfmh7P6Hc+wIrE67bTAIU7h/iZueegxyam9yRn1/nuWOj+trJ0ArNjQgb5
	 DQh0t7+C6fNivc7H7Nj5wEcnIrkrg902J9K5ZXe7gBaszZloQJUIgOAAOO18hDcz2f0iq
	 RrNJeWAYiiJT3UrScdm0kE2n05keHCXCZpH7SyN5/YrPQQ4Mf8wm1rtU6Stzv79zvUL3W
	 QQ0TEMpk6A3YkBbWQ+vBsMPdDPa8e8nYcjwMK5+iiluCIDnPid/tlEJ16SYkChAA5R+vf
	 b+32lMiCFy/zm0ZpRn3XMFmVvQwh/dT4lBlkCehJ8N+H9uUOKaMtVmIj9zBZPATPuTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136831;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ezpxehH/mmElZr8dSiJ0yenohdkwcTIPxXbllv/YqEc=;
	b=y1jo7JeSc015aP/NQTYk6pwz9WEVbIgCM0KRbTQxYZ74fpoozAu7zd4tMW5Err49A1jo
	 8SmFdFxspydWd4XYvBe75jFrJTo2PjWxDBJNk/MR2vgRrjgD+fK7py/nsZbrNxOteeO/e
	 QoU4ItZBQLBRgytJSQUFIl6+bHkZfIsGqHW6eccdOjUymXS0ErvIxvSB1aeV9i18lSvZb
	 IoHO1JFeCMvflRvRNtgaYiAO65B5rmPVy9I/ofOKS4UxUInGuFmN2jGspwjSb07q11ATr
	 OTmhrwh0EdLDZ/bcDwjRShibglZCGGZ8aUq2eKr4CcYCZYEfkvC3ymH09iNPmlXI3DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FR4QBvLt;
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D718360A5BE0
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D718360A5BE0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FR4QBvLt
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c429d9d05f0so31391866b.1
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136828; x=1795741628; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ezpxehH/mmElZr8dSiJ0yenohdkwcTIPxXbllv/YqEc=;
        b=FR4QBvLt4eTY5d8CKuhYvNfIBCnUO+TnUMaBABihNuBsNpCIPXh1buqrw5uEiDQ0Ey
         JKDIZlvXbEdrQa2Uw2p41g7o6THBEVgfbQrEJdtPlpyM/3UZZal2dS2/7vpAoRQjKnd1
         ZA2oDBgf4gAEoxpM7kaN6oz/osM+5DP6Y7Puprl8yA6QPVgKiHGkOU8brldQ/AmU11L6
         pTkWDeYnTGlZ6+GIZecDNiRtjafTfTKd+DZOteFHxJ7CYnyG6rgRJJr12d7/GO+X9U2c
         9ZJQ+Eizy29V+11DYDkefzceRng8li80y5VHrMqtf01h2NIIfnRteSsCVkjdo24MyYvF
         +JIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136828; x=1795741628;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ezpxehH/mmElZr8dSiJ0yenohdkwcTIPxXbllv/YqEc=;
        b=pErB/NMjQjq1VufLUhWFGNQEsEmqThS46ppJW8T6dUUuZSHG9CHfCWAtS4LE8IRIki
         uO8vXFyLQaiXkbcW2BvlR3zAy7An75Nyj5tV3guJef1i2HnylDmQWAxYkiHtE95W+I7v
         UuSG2HzSdxkOYvHNNEcfsOyyBdehQr+hPBpANDX7pfEUQBFv/+KTUnkrlaaw6CJl6a3p
         KCYHOuBeOl314OrueNdJ9FvDdsgf04Vg+armQeTzPBAfT/3jJGOOi02tMbQP0WQH7LIl
         g0tzGY8R86xF8c19TDjpniNR0iNqN/EytJgGRYr3UK1J7WeGaOvs2xCba7nNI7LJj9Ir
         sctA==
X-Forwarded-Encrypted: i=1; AL+hErEMrfGLRZqt3kVOPmxfFhj3aMH4ZPQAp7eRZihgSaYo4QsMZSkCYxDR5MMNs4GAnUxjxl+H89WLI90=@vger.kernel.org
X-Gm-Message-State: APuU4Z+1B/e5SXVPvytHTOhL4ZrgEH2Da2/VhDw9lJ0Ucy73bEi/Eqr3
	N/1IBBVIygvvoPIjqv5KmOC2Nf45C1GYhQj5ujAEtMuki1awPqyouYWf14h7bZqEHNs+oEdrhip
	xEKL0Ng==
X-Received: from ejqw12.prod.google.com ([2002:a17:906:480c:b0:c4d:3341:eee2])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:c286:b0:c2e:378c:8ce3
 with SMTP id a640c23a62f3a-c513ab3749emr101514566b.32.1795136827489; Thu, 19
 Nov 2026 17:07:07 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:36 +0000
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
Message-ID: <20261120010655.467825-7-lrizzo@google.com>
Subject: [RFC PATCH v3 06/25] iommu/dma: Map PISA memory in a per-domain IOVA window
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

Each PISA page may have to be mapped in multiple IOMMU domains, and PISA
buffers must be recognized quickly from their IOVA. Both problems are
solved by reserving, in each domain, an IOVA window that only holds PISA
pages. With this:
- a PISA page is mapped at offset "slot * 2MB" in each domain, so there
  is no need to track individual offsets and one bit per domain suffices
  to tell whether the page is mapped.
- since the reserved IOVA window is only used for PISA memory,
  a simple address comparison suffices to identify a PISA-backed buffer.

Reserve an IOVA window in each domain, and use it to map PISA pages as
described above. Unmapping becomes a no-op, after a quick identification
of the address. The actual unmapping happens when the backing PISA page
is retired, or when the domain has no more users.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/Makefile     |   3 +
 drivers/iommu/dma-iommu.c  |  39 +++-
 drivers/iommu/iommu.c      |   7 +-
 drivers/iommu/pisa-map.c   | 385 +++++++++++++++++++++++++++++++++++++
 include/linux/pisa-iommu.h |  42 +++-
 include/linux/pisa.h       |  95 +++++++++
 mm/Kconfig                 |   1 +
 mm/pisa-alloc.c            |   4 +
 mm/pisa-kunit.c            | 170 ++++++++++++++++
 mm/pisa-node.c             |   3 +-
 mm/pisa-priv.h             |  10 +
 11 files changed, 755 insertions(+), 4 deletions(-)
 create mode 100644 drivers/iommu/pisa-map.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 29a26d2a3af12..a04b4458efaaa 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -11,6 +11,9 @@ obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
 obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
+ifdef CONFIG_IOMMU_DMA
+obj-$(CONFIG_PISA) += pisa-map.o
+endif
 obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 78742aeba932d..9b26d0aee9a97 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -36,6 +36,7 @@
 #include <trace/events/swiotlb.h>
 
 #include "dma-iommu.h"
+#include <linux/pisa.h>
 #include "iommu-pages.h"
 #include "iommu-priv.h"
 
@@ -76,6 +77,8 @@ struct iommu_dma_cookie {
 	struct iommu_domain *fq_domain;
 	/* Options for dma-iommu use */
 	struct iommu_dma_options options;
+	/* IOVA window reserved for PISA pages. Nothing else can go here. */
+	struct pisa_iova pisa_iova;
 };
 
 struct iommu_dma_msi_cookie {
@@ -379,6 +382,7 @@ int iommu_get_dma_cookie(struct iommu_domain *domain)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&cookie->msi_page_list);
+	cookie->pisa_iova.iovad = &cookie->iovad;
 	domain->cookie_type = IOMMU_COOKIE_DMA_IOVA;
 	domain->iova_cookie = cookie;
 	return 0;
@@ -427,6 +431,9 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
 	struct iommu_dma_cookie *cookie = domain->iova_cookie;
 	struct iommu_dma_msi_page *msi, *tmp;
 
+	/* Drop cached PISA mappings before the IOVA domain goes away. */
+	pisa_domain_release(domain);
+
 	if (cookie->iovad.granule) {
 		iommu_dma_free_fq(cookie);
 		put_iova_domain(&cookie->iovad);
@@ -831,6 +838,8 @@ static void __iommu_dma_unmap(struct device *dev, dma_addr_t dma_addr,
 	struct iommu_iotlb_gather iotlb_gather;
 	size_t unmapped;
 
+	if (is_pisa_iova(&cookie->pisa_iova, dma_addr))
+		return;
 	dma_addr -= iova_off;
 	size = iova_align(iovad, size + iova_off);
 	iommu_iotlb_gather_init(&iotlb_gather);
@@ -857,6 +866,8 @@ static dma_addr_t __iommu_dma_map(struct device *dev, phys_addr_t phys,
 	    iommu_deferred_attach(dev, domain))
 		return DMA_MAPPING_ERROR;
 
+	if (pisa_map_phys(&iova, dev, domain, phys, size, prot))
+		return iova;
 	/* If anyone ever wants this we'd need support in the IOVA allocator */
 	if (dev_WARN_ONCE(dev, dma_get_min_align_mask(dev) > iova_mask(iovad),
 	    "Unsupported alignment constraint\n"))
@@ -1215,6 +1226,16 @@ static inline size_t iova_unaligned(struct iova_domain *iovad, phys_addr_t phys,
 	return iova_offset(iovad, phys | size);
 }
 
+/* Return @domain's PISA window, or NULL if @domain cannot use PISA. */
+struct pisa_iova *pisa_dma_iova(struct iommu_domain *domain)
+{
+	if (static_branch_unlikely(&iommu_deferred_attach_enabled) || !domain ||
+	    domain->cookie_type != IOMMU_COOKIE_DMA_IOVA)
+		return NULL;
+
+	return &domain->iova_cookie->pisa_iova;
+}
+
 dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
@@ -1256,6 +1277,10 @@ void iommu_dma_unmap_phys(struct device *dev, dma_addr_t dma_handle,
 {
 	phys_addr_t phys;
 
+	/* PISA mapped buffer: nothing to unmap or release. */
+	if (is_pisa_iova(&iommu_get_dma_domain(dev)->iova_cookie->pisa_iova, dma_handle))
+		return;
+
 	if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT)) {
 		__iommu_dma_unmap(dev, dma_handle, size);
 		return;
@@ -1457,6 +1482,13 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 			 */
 			break;
 		case PCI_P2PDMA_MAP_NONE:
+			/* Map PISA pages and mark as bus addresses to skip IOVA alloc and map. */
+			if (pisa_map_phys(&s->dma_address, dev, domain,
+					  sg_phys(s), s_length, prot)) {
+				sg_dma_len(s) = s_length;
+				sg_dma_mark_bus_address(s);
+				continue;
+			}
 			break;
 		case PCI_P2PDMA_MAP_BUS_ADDR:
 			/*
@@ -1822,7 +1854,12 @@ bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
 	dma_addr_t addr;
 
 	memset(state, 0, sizeof(*state));
-	if (!use_dma_iommu(dev))
+	/*
+	 * PISA memory is mapped in its own IOVA window. A PISA page whose
+	 * protection does not cover the request is declined here too, and
+	 * __iommu_dma_map() then maps it as ordinary memory, page by page.
+	 */
+	if (!use_dma_iommu(dev) || is_pisa_phys(phys))
 		return false;
 
 	domain = iommu_get_dma_domain(dev);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b486b8bbd1fcd..ac49b3b33ced6 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -37,6 +37,7 @@
 #include <linux/generic_pt/iommu.h>
 
 #include "dma-iommu.h"
+#include <linux/pisa.h>
 #include "iommu-priv.h"
 
 static struct kset *iommu_group_kset;
@@ -2867,7 +2868,7 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 	while (i <= nents) {
 		phys_addr_t s_phys = sg_phys(sg);
 
-		if (len && s_phys != start + len) {
+		if (len && (sg_dma_is_bus_address(sg) || s_phys != start + len)) {
 			ret = iommu_map_nosync(domain, iova + mapped, start,
 					len, prot, gfp);
 			if (ret)
@@ -3363,6 +3364,10 @@ void iommu_device_unuse_default_domain(struct device *dev)
 	if (!WARN_ON(!group->owner_cnt || !xa_empty(&group->pasid_array)))
 		group->owner_cnt--;
 
+	/* Unmap persistent PISA windows when the last driver detaches. */
+	if (!group->owner_cnt)
+		pisa_domain_quiesce(group->default_domain);
+
 	mutex_unlock(&group->mutex);
 }
 
diff --git a/drivers/iommu/pisa-map.c b/drivers/iommu/pisa-map.c
new file mode 100644
index 0000000000000..3ff9f1a6c5b85
--- /dev/null
+++ b/drivers/iommu/pisa-map.c
@@ -0,0 +1,385 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * PISA per-domain IOVA window management and IOMMU mapping.
+ * See Documentation/core-api/pisa.rst for the architecture overview.
+ */
+
+#include <linux/atomic.h>
+#include <linux/bitops.h>
+#include <linux/cache.h>
+#include <linux/dma-map-ops.h>
+#include <linux/dma-mapping.h>
+#include <linux/iommu.h>
+#include <linux/iova.h>
+#include <linux/log2.h>
+#include <linux/mm.h>
+#include <linux/pci.h>
+#include <linux/pisa-iommu.h>
+#include <linux/spinlock.h>
+#include <linux/srcu.h>
+
+
+/*
+ * Registry of PISA IOMMU domains. Each slot is FREE (!domain && !base),
+ * ACTIVE (domain), or DRAINING (!domain && base).
+ * Protected by pisa_domains_lock.
+ */
+static struct {
+	struct iommu_domain *domain;
+	dma_addr_t base;
+	spinlock_t map_lock;	/* serialises iommu_map() in __pisa_map_phys() */
+} pisa_domains[PISA_MAX_DOMAINS] __read_mostly;
+static DEFINE_SPINLOCK(pisa_domains_lock);
+
+/* Protects pisa_unmap_all_domains() readers against concurrent pisa_domain_release(). */
+DEFINE_STATIC_SRCU(pisa_srcu);
+
+/* Bumped under pisa_domains_lock whenever a domain index is released. */
+unsigned int pisa_domains_generation __read_mostly;
+
+/* Report a short IOMMU unmap and mark @meta quarantined so it is never reused. */
+static bool pisa_quarantine_meta(struct pisa_meta *meta, struct iommu_domain *domain,
+				 int idx, dma_addr_t iova, size_t unmapped)
+{
+	pr_err_ratelimited("pisa: unmap of IOVA %pad in domain %p (index %d) returned %zu, quarantining PISA page\n",
+			   &iova, domain, idx, unmapped);
+	return pisa_quarantine_page(meta);
+}
+
+/* Offset of @meta from the start of a domain's window. */
+static inline dma_addr_t pisa_meta2iova_offset(const struct pisa_meta *meta)
+{
+	return (dma_addr_t)meta->slot << PISA_SHIFT;
+}
+
+/* Unmap @meta from every active domain that maps it. */
+void pisa_unmap_all_domains(struct pisa_meta *meta)
+{
+	dma_addr_t offset = pisa_meta2iova_offset(meta);
+	int idx;
+
+	guard(srcu)(&pisa_srcu);
+	for_each_set_bit(idx, meta->domains_mapped, PISA_MAX_DOMAINS) {
+		struct iommu_domain *domain;
+		unsigned long flags;
+		size_t unmapped;
+		dma_addr_t base;
+
+		if (!test_and_clear_bit(idx, meta->domains_mapped))
+			continue;
+
+		spin_lock_irqsave(&pisa_domains_lock, flags);
+		domain = pisa_domains[idx].domain;
+		base = pisa_domains[idx].base;
+		spin_unlock_irqrestore(&pisa_domains_lock, flags);
+
+		/* Free, or draining: pisa_domain_release() handles the bit. */
+		if (!domain)
+			continue;
+
+		unmapped = iommu_unmap(domain, base + offset, PISA_SIZE);
+		if (unlikely(unmapped != PISA_SIZE))
+			pisa_quarantine_meta(meta, domain, idx, base + offset, unmapped);
+	}
+}
+
+/* Clear domain @idx from all populated slots. */
+static unsigned int pisa_forget_domain(int idx)
+{
+	unsigned int slot, dropped = 0;
+
+	guard(rcu)();
+	for_each_set_bit(slot, pisa_slot_bitmap, pisa_nr_slots) {
+		struct pisa_meta *meta = &pisa_meta_array[slot];
+
+		if (test_bit(idx, meta->domains_mapped) &&
+		    test_and_clear_bit(idx, meta->domains_mapped))
+			dropped++;
+	}
+	return dropped;
+}
+
+/*
+ * Release @domain's registry index and clear its bit in all active
+ * PISA pages, waiting out concurrent unmappers on @pisa_srcu before freeing
+ * the slot.
+ */
+void __pisa_domain_release(struct iommu_domain *domain)
+{
+	struct pisa_iova *pi = pisa_dma_iova(domain);
+	unsigned int dropped;
+	unsigned long flags;
+	int idx;
+
+	/* Pairs with smp_store_release() in pisa_domain_init(). */
+	if (!pi || !smp_load_acquire(&pi->base))
+		return;
+
+	idx = pi->domain_idx - PISA_IDX_FIRST;
+	spin_lock_irqsave(&pisa_domains_lock, flags);
+	/* A window (@pi->base) is only published once @domain is registered at @idx. */
+	if (WARN_ON_ONCE(pisa_domains[idx].domain != domain)) {
+		spin_unlock_irqrestore(&pisa_domains_lock, flags);
+		return;
+	}
+	/* Leave @base set, mark the slot as DRAINING. */
+	pisa_domains[idx].domain = NULL;
+	spin_unlock_irqrestore(&pisa_domains_lock, flags);
+
+	dropped = pisa_forget_domain(idx);
+
+	/* Wait out in-flight pisa_unmap_all_domains() readers before reusing @idx. */
+	synchronize_srcu(&pisa_srcu);
+
+	spin_lock_irqsave(&pisa_domains_lock, flags);
+	/* Mark slot FREE and bump @pisa_domains_generation so NOIDX domains retry. */
+	pisa_domains[idx].base = 0;
+	WRITE_ONCE(pisa_domains_generation, pisa_domains_generation + 1);
+	spin_unlock_irqrestore(&pisa_domains_lock, flags);
+
+	if (dropped)
+		pr_debug("pisa: released %u PISA page mappings for domain %p (index %d)\n",
+			 dropped, domain, idx);
+}
+
+/*
+ * Unmap all PISA pages from a domain whose last DMA API user detached,
+ * keeping its window and domain index so mappings are re-installed on demand.
+ */
+void __pisa_domain_quiesce(struct iommu_domain *domain)
+{
+	struct pisa_iova *pi = pisa_dma_iova(domain);
+	struct iommu_iotlb_gather gather;
+	unsigned int slot, done = 0;
+	bool released = false;
+	dma_addr_t base;
+	int idx;
+
+	/* Pairs with smp_store_release() in pisa_domain_init(). */
+	base = pi ? smp_load_acquire(&pi->base) : 0;
+	if (!base)
+		return;
+	idx = pi->domain_idx - PISA_IDX_FIRST;
+
+	iommu_iotlb_gather_init(&gather);
+	/* Keep call_rcu()-freed pages from reaching the buddy allocator before IOTLB sync. */
+	rcu_read_lock();
+	for_each_set_bit(slot, pisa_slot_bitmap, pisa_nr_slots) {
+		struct pisa_meta *meta = &pisa_meta_array[slot];
+		dma_addr_t iova;
+		size_t unmapped;
+
+		if (!test_bit(idx, meta->domains_mapped) ||
+		    !test_and_clear_bit(idx, meta->domains_mapped))
+			continue;
+
+		/* Unmap the page, batching the IOTLB flush into @gather. */
+		iova = base + pisa_meta2iova_offset(meta);
+		unmapped = iommu_unmap_fast(domain, iova, PISA_SIZE, &gather);
+		if (unlikely(unmapped != PISA_SIZE))
+			released |= pisa_quarantine_meta(meta, domain, idx, iova, unmapped);
+		done++;
+	}
+
+	if (done)
+		iommu_iotlb_sync(domain, &gather);
+	rcu_read_unlock();
+	if (released)
+		pisa_schedule_reclaim();
+	if (done)
+		pr_debug("pisa: unmapped %u PISA pages from idle domain %p (index %d)\n",
+			 done, domain, idx);
+}
+
+/* Return negative errno if @pi's domain was permanently/currently declined, or 0. */
+int pisa_iova_declined(const struct pisa_iova *pi)
+{
+	switch (READ_ONCE(pi->domain_idx)) {
+	case PISA_IDX_NOHUGE:
+		return -EOPNOTSUPP;
+	case PISA_IDX_NOIOVA:
+		return -ENOSPC;
+	case PISA_IDX_NOIDX:
+		return READ_ONCE(pi->idx_gen) == READ_ONCE(pisa_domains_generation) ?
+		       -EBUSY : 0;
+	default:
+		return 0;
+	}
+}
+
+/* Allocate the initial IOVA window of @size bytes for @domain. */
+static dma_addr_t pisa_domain_alloc_iova(struct device *dev, struct iommu_domain *domain,
+					 struct iova_domain *iovad, u64 size)
+{
+	u64 limit = min_not_zero(dma_get_mask(dev), dev->bus_dma_limit);
+	u64 align = min_t(u64, roundup_pow_of_two(size), SZ_1G);
+	unsigned long shift, iova_len;
+	struct iova *new_iova;
+
+	if (!iovad)
+		return 0;
+
+	limit = min_not_zero(limit, dev->coherent_dma_mask);
+	if (domain->geometry.force_aperture)
+		limit = min_t(u64, limit, domain->geometry.aperture_end);
+
+	/* Ignore devices with too many constraints. */
+	if (limit <= DMA_BIT_MASK(32) || size > limit - align)
+		return 0;
+
+	shift = iova_shift(iovad);
+	/* Overallocate to guarantee a 1GB aligned range */
+	iova_len = (size + align) >> shift;
+	new_iova = alloc_iova(iovad, iova_len, limit >> shift, false);
+	return new_iova ? ALIGN((dma_addr_t)new_iova->pfn_lo << shift, align) : 0;
+}
+
+/*
+ * Assign @domain an IOVA window and dense domain index on first use, recording
+ * permanent or retryable failures in @pi->domain_idx.
+ */
+static int pisa_domain_init(struct device *dev, struct iommu_domain *domain,
+			    struct pisa_iova *pi)
+{
+	u64 limit = min_not_zero(dma_get_mask(dev), dev->bus_dma_limit);
+	u64 size = pisa_iova_size();
+	unsigned long flags;
+	dma_addr_t base;
+	int idx, ret;
+
+	limit = min_not_zero(limit, dev->coherent_dma_mask);
+
+	if (!dev_is_dma_coherent(dev) || (dev_is_pci(dev) && to_pci_dev(dev)->untrusted))
+		return -EOPNOTSUPP;
+
+	if (limit <= DMA_BIT_MASK(32) || size > limit - PISA_SIZE)
+		return -ENOSPC;
+
+	if (!pisa_domain_pgsize_ok(domain)) {
+		if (cmpxchg(&pi->domain_idx, PISA_IDX_NONE, PISA_IDX_NOHUGE) == PISA_IDX_NONE)
+			dev_warn_ratelimited(dev, "pisa: domain cannot map %luKB pages, not PISA\n",
+					     (unsigned long)(PISA_SIZE >> 10));
+		return -EOPNOTSUPP;
+	}
+
+	spin_lock_irqsave(&pisa_domains_lock, flags);
+
+	/* Bail if another CPU got here first, or if declined earlier. */
+	ret = pi->base ? 0 : pisa_iova_declined(pi);
+	if (pi->base || ret) {
+		spin_unlock_irqrestore(&pisa_domains_lock, flags);
+		return ret;
+	}
+
+	for (idx = 0; idx < PISA_MAX_DOMAINS; idx++) {
+		if (!pisa_domains[idx].domain && !pisa_domains[idx].base)
+			break;
+	}
+	if (idx == PISA_MAX_DOMAINS) {
+		pi->idx_gen = pisa_domains_generation;
+		WRITE_ONCE(pi->domain_idx, PISA_IDX_NOIDX);
+		spin_unlock_irqrestore(&pisa_domains_lock, flags);
+		pr_warn_ratelimited("pisa: all %d domain indices in use, not PISA for domain %p until one is released\n",
+				    PISA_MAX_DOMAINS, domain);
+		return -EBUSY;
+	}
+
+	base = pisa_domain_alloc_iova(dev, domain, pi->iovad, size);
+	if (!base) {
+		WRITE_ONCE(pi->domain_idx, PISA_IDX_NOIOVA);
+		spin_unlock_irqrestore(&pisa_domains_lock, flags);
+		dev_warn_ratelimited(dev,
+				     "pisa: no free %llu MB IOVA range for a PISA window\n",
+				     size >> 20);
+		return -ENOSPC;
+	}
+
+	pisa_domains[idx].domain = domain;
+	pisa_domains[idx].base = base;
+	spin_lock_init(&pisa_domains[idx].map_lock);
+	WRITE_ONCE(pi->domain_idx, idx + PISA_IDX_FIRST);
+	/* Publish .domain_idx before .base (paired with is_pisa_iova()). */
+	smp_store_release(&pi->base, base);
+	spin_unlock_irqrestore(&pisa_domains_lock, flags);
+
+	dev_info(dev, "pisa: domain %p index %d window %pad + %llu MB%s\n",
+		 domain, idx, &base, size >> 20,
+		 (domain->pgsize_bitmap & PISA_SIZE) ? "" : ", no leaf PTE of PISA page size");
+	return 0;
+}
+
+/*
+ * Set *@iova for address @phys for @dev. @phys is known to be PISA memory.
+ * On first use in a domain, reserves @pi via alloc_iova(), and on first use
+ * of a PISA page in that domain, maps it (with one leaf PTE if the domain has
+ * that page size) via iommu_map(..., GFP_ATOMIC) under spinlocks.
+ * Returns true on success, or false if @phys/@prot/@dev cannot use the window
+ * (callers only need to know whether to fall back to regular DMA mapping, not
+ * the specific error).
+ */
+bool __pisa_map_phys(dma_addr_t *iova, struct device *dev,
+		     struct iommu_domain *domain, phys_addr_t phys,
+		     size_t size, int prot)
+{
+	struct pisa_iova *pi = pisa_dma_iova(domain);
+	unsigned long pfn = phys >> PAGE_SHIFT;
+	unsigned int domain_idx;
+	struct pisa_meta *meta;
+	int block_prot, ret;
+	dma_addr_t addr;
+	u64 limit;
+
+	if (unlikely(!iova || !dev || !pi || !dev_is_dma_coherent(dev) ||
+		     (dev_is_pci(dev) && to_pci_dev(dev)->untrusted) ||
+		     (phys & (PISA_SIZE - 1)) + size > PISA_SIZE))
+		return false;
+
+	meta = pisa_meta_of_pfn(pfn);
+
+	/* Every mapping of the page carries IOMMU_CACHE | @meta->prot. */
+	block_prot = IOMMU_CACHE | meta->prot;
+	if (unlikely(prot & ~block_prot))
+		return false;
+
+	/* Acquire pairs with the .base release in pisa_domain_init(). */
+	if (unlikely(!smp_load_acquire(&pi->base))) {
+		/* Test cached decline in @domain_idx before taking @pisa_domains_lock. */
+		ret = pisa_iova_declined(pi);
+		if (likely(!ret))
+			ret = pisa_domain_init(dev, domain, pi);
+
+		if (ret)
+			return false;
+	}
+
+	addr = pisa_phys_to_iova(pi, meta, phys);
+
+	/* Check @dev's own DMA mask and bus limit against the window IOVA. */
+	limit = min_not_zero(dma_get_mask(dev), dev->bus_dma_limit);
+	limit = min_not_zero(limit, dev->coherent_dma_mask);
+	if (unlikely(addr + size - 1 > limit))
+		return false;
+
+	domain_idx = pi->domain_idx - PISA_IDX_FIRST;
+	if (likely(test_bit(domain_idx, meta->domains_mapped))) {
+		*iova = addr;
+		return true;
+	}
+
+	/* First use of this PISA page in this domain: map it. */
+	guard(spinlock_irqsave)(&pisa_domains[domain_idx].map_lock);
+	if (!test_bit(domain_idx, meta->domains_mapped)) {
+		phys_addr_t pisa_phys = phys & PISA_MASK;
+
+		ret = iommu_map(domain, pisa_phys_to_iova(pi, meta, pisa_phys),
+				pisa_phys, PISA_SIZE, block_prot, GFP_ATOMIC);
+		if (unlikely(ret))
+			return false;
+		/* Ensure the mapping is visible before setting the domain bit. */
+		smp_mb__before_atomic();
+		set_bit(domain_idx, meta->domains_mapped);
+	}
+
+	*iova = addr;
+	return true;
+}
diff --git a/include/linux/pisa-iommu.h b/include/linux/pisa-iommu.h
index b29b405804193..d4c01207dca72 100644
--- a/include/linux/pisa-iommu.h
+++ b/include/linux/pisa-iommu.h
@@ -5,6 +5,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/dma-direct.h>
+#include <linux/iommu.h>
 #include <linux/list.h>
 #include <linux/llist.h>
 #include <linux/pisa.h>
@@ -17,20 +18,46 @@ struct pisa_alloc;
 #define PISA_SIZE		(1UL << PISA_SHIFT)
 #define PISA_MASK		(~(PISA_SIZE - 1))
 
+/*
+ * Can @domain map a PISA page? One leaf PTE of PISA_SIZE is best, but smaller
+ * IOMMU pages that divide PISA_SIZE work too.
+ */
+static inline bool pisa_domain_pgsize_ok(const struct iommu_domain *domain)
+{
+	return domain->pgsize_bitmap &&
+	       IS_ALIGNED(PISA_SIZE, 1UL << __ffs(domain->pgsize_bitmap));
+}
+
 /* size of struct pisa_meta (256B, power of 2) and max blocks per PISA page. */
 #define _PISA_META_SHIFT	8
 #define _PISA_META_SIZE		(1U << _PISA_META_SHIFT)
 #define _PISA_MAX_BLOCKS	512U
 
+/* Max simultaneous PISA IOMMU domains (bit index in pisa_meta.domains_mapped). */
+#define PISA_MAX_DOMAINS	128
+
+/* Sentinel values of pisa_iova.domain_idx below PISA_IDX_FIRST. */
+enum {
+	PISA_IDX_NONE,		/* not attempted yet */
+	PISA_IDX_NOHUGE,	/* @domain can never use PISA */
+	PISA_IDX_NOIOVA,	/* no IOVA range for the window */
+	PISA_IDX_NOIDX,		/* all domain indices were in use */
+	PISA_IDX_FIRST,		/* first valid domain index */
+};
+
 /* Metadata for a single PISA page in @pisa_meta_array (indexed by @slot). */
 struct pisa_meta {
 	unsigned long flags;	/* PISA_ACTIVE / PISA_QUARANTINED / PISA_DECRYPTED */
 	unsigned long base_pfn;	/* base PFN of this PISA page */
+	u8 prot;		/* owning @pa's IOMMU_READ/WRITE protection bits */
 	u16 nr_clean;		/* zeroed available blocks in @clean_bitmap */
 	u16 nr_dirty;		/* dirty available blocks in @dirty_bitmap */
 	u8 on_list;		/* current placement in @pa (PISA_LIST_*) */
 	bool drain;		/* sparse old page draining back to @idle */
 	u32 slot;		/* dense index in @pisa_meta_array and IOVA windows */
+
+	DECLARE_BITMAP(domains_mapped, PISA_MAX_DOMAINS);
+
 	struct pisa_alloc *pa;	/* NULL for reservoir pages */
 	struct list_head list;	/* node in @pa lists or pisa_node.pages */
 
@@ -47,21 +74,34 @@ struct pisa_meta {
 static_assert(sizeof(struct pisa_meta) == _PISA_META_SIZE);
 
 extern struct pisa_meta *pisa_meta_array;
-extern unsigned int pisa_nr_slots;
+extern unsigned long *pisa_slot_bitmap;
 
 struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn);
 bool pisa_quarantine_page(struct pisa_meta *meta);
 void pisa_schedule_reclaim(void);
 
+/* IOVA of @phys inside active RAM page @meta in @pi. */
+static inline dma_addr_t pisa_phys_to_iova(const struct pisa_iova *pi,
+					   const struct pisa_meta *meta, phys_addr_t phys)
+{
+	return pi->base + ((dma_addr_t)meta->slot << PISA_SHIFT) +
+	       (phys & (PISA_SIZE - 1));
+}
+
 #endif /* CONFIG_PISA */
 
 #if defined(CONFIG_PISA) && defined(CONFIG_IOMMU_DMA)
 
+/* Bumped under pisa_domains_lock whenever a domain index is released. */
+extern unsigned int pisa_domains_generation;
+
 void pisa_unmap_all_domains(struct pisa_meta *meta);
+int pisa_iova_declined(const struct pisa_iova *pi);
 
 #else /* !CONFIG_PISA || !CONFIG_IOMMU_DMA */
 
 static inline void pisa_unmap_all_domains(struct pisa_meta *meta) {}
+static inline int pisa_iova_declined(const struct pisa_iova *pi) { return -EOPNOTSUPP; }
 
 #endif /* CONFIG_PISA && CONFIG_IOMMU_DMA */
 #endif /* _LINUX_PISA_IOMMU_H */
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 3307fae1dbd66..cc33e181df097 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -7,10 +7,36 @@
 #include <linux/bitops.h>
 #include <linux/dma-mapping.h>
 #include <linux/jump_label.h>
+#include <linux/device.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 #include <linux/rcupdate.h>
 
+struct iommu_domain;
+struct iova_domain;
+
+/**
+ * struct pisa_iova - A domain's IOVA window reserved for PISA pages
+ * @iovad: Domain's IOVA allocator (&domain->iova_cookie->iovad)
+ * @base: Window base IOVA (PISA_SIZE aligned), or 0 if unassigned
+ * @domain_idx: Dense index + PISA_IDX_FIRST, or PISA_IDX_* sentinel while @base == 0
+ * @idx_gen: Value of pisa_domains_generation when @domain_idx was set to NOIDX
+ *
+ * Lives in iommu_dma_cookie. Active PISA pages map at @base + slot * PISA_SIZE.
+ */
+struct pisa_iova {
+	struct iova_domain *iovad;
+	dma_addr_t base;
+	u16 domain_idx;
+	u32 idx_gen;
+};
+
+#ifdef CONFIG_IOMMU_DMA
+struct pisa_iova *pisa_dma_iova(struct iommu_domain *domain);
+#else
+static inline struct pisa_iova *pisa_dma_iova(struct iommu_domain *domain) { return NULL; }
+#endif
+
 #ifdef CONFIG_PISA
 
 /* PISA page geometry (log2 byte size and base-page order). */
@@ -49,6 +75,13 @@ DECLARE_STATIC_KEY_FALSE(pisa_key);
 DECLARE_STATIC_KEY_FALSE(pisa_recycle_check_key);
 
 extern u32 *pisa_pfn2slot;
+extern unsigned int pisa_nr_slots;
+
+/* Size of the IOVA window each domain reserves for PISA pages: one per metadata slot. */
+static inline u64 pisa_iova_size(void)
+{
+	return (u64)pisa_nr_slots << PISA_SHIFT;
+}
 
 int pisa_meta_init(void);
 bool __pisa_page_can_recycle(const struct page *page);
@@ -131,4 +164,66 @@ static inline bool pisa_page_can_recycle(const struct page *page)
 }
 
 #endif /* CONFIG_PISA */
+
+#if defined(CONFIG_PISA) && defined(CONFIG_IOMMU_DMA)
+
+bool __pisa_map_phys(dma_addr_t *iova, struct device *dev,
+		     struct iommu_domain *domain, phys_addr_t phys,
+		     size_t size, int prot);
+void __pisa_domain_release(struct iommu_domain *domain);
+void __pisa_domain_quiesce(struct iommu_domain *domain);
+
+/* Hook for __iommu_dma_map() and iommu_dma_map_sg() (guarded by @pisa_key). */
+static inline bool pisa_map_phys(dma_addr_t *iova, struct device *dev,
+				 struct iommu_domain *domain, phys_addr_t phys,
+				 size_t size, int prot)
+{
+	return is_pisa_phys(phys) &&
+	       __pisa_map_phys(iova, dev, domain, phys, size, prot);
+}
+
+/* Hook for __iommu_dma_unmap() and __iommu_dma_unmap_phys() (guarded by @pisa_key). */
+static inline bool is_pisa_iova(const struct pisa_iova *pi, dma_addr_t dma)
+{
+	dma_addr_t base;
+
+	if (!pisa_enabled())
+		return false;
+	/* Acquire pairs with the release of @base in pisa_domain_init(). */
+	base = smp_load_acquire(&pi->base);
+	return base && dma - base < pisa_iova_size();
+}
+
+/* Hook for iommu_put_dma_cookie() (guarded by @pisa_key). */
+static inline void pisa_domain_release(struct iommu_domain *domain)
+{
+	if (pisa_enabled())
+		__pisa_domain_release(domain);
+}
+
+/* Hook for iommu_device_unuse_default_domain() (guarded by @pisa_key). */
+static inline void pisa_domain_quiesce(struct iommu_domain *domain)
+{
+	if (pisa_enabled())
+		__pisa_domain_quiesce(domain);
+}
+
+#else /* !CONFIG_PISA || !CONFIG_IOMMU_DMA */
+
+static inline bool pisa_map_phys(dma_addr_t *iova, struct device *dev,
+				 struct iommu_domain *domain, phys_addr_t phys,
+				 size_t size, int prot)
+{
+	return false;
+}
+
+static inline bool is_pisa_iova(const struct pisa_iova *pi, dma_addr_t dma)
+{
+	return false;
+}
+
+static inline void pisa_domain_release(struct iommu_domain *domain) {}
+static inline void pisa_domain_quiesce(struct iommu_domain *domain) {}
+
+#endif /* CONFIG_PISA && CONFIG_IOMMU_DMA */
 #endif /* _LINUX_PISA_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 6e7811569d33a..f96c4017519ee 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1436,6 +1436,7 @@ config PISA
 	bool "Pre-mapped IOVA Superpage Allocator"
 	depends on (X86_64 && !UML) || (ARM64 && ARM64_4K_PAGES && PGTABLE_LEVELS >= 4)
 	depends on SPARSEMEM && !PREEMPT_RT
+	select NEED_SG_DMA_FLAGS
 	default y
 	help
 	  PISA is a specialized memory allocator with an API similar to
diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
index c09f321b07eeb..01d8bbc8d72ff 100644
--- a/mm/pisa-alloc.c
+++ b/mm/pisa-alloc.c
@@ -13,6 +13,7 @@
 #include <linux/pisa.h>
 #include <linux/export.h>
 #include <linux/gfp.h>
+#include <linux/iommu.h>
 #include <linux/kasan.h>
 #include <linux/list.h>
 #include <linux/llist.h>
@@ -261,6 +262,8 @@ struct pisa_alloc *pisa_alloc_create(int nid, unsigned int order, enum dma_data_
 	spin_lock_init(&pa->lock);
 	pa->order = order;
 	pa->nid = nid;
+	pa->prot = (dir != DMA_FROM_DEVICE ? IOMMU_READ : 0) |
+		     (dir != DMA_TO_DEVICE ? IOMMU_WRITE : 0);
 	pisa_alloc_set_name(pa, "%ps", (void *)_RET_IP_);
 	INIT_LIST_HEAD(&pa->partial);
 	INIT_LIST_HEAD(&pa->partial_dirty);
@@ -585,6 +588,7 @@ static unsigned long __pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp, unsigne
 			goto out;
 		spin_lock_irqsave(&pa->lock, flags);
 		meta->pa = pa;
+		meta->prot = pa->prot;
 		WRITE_ONCE(meta->alloc_jiffies, jiffies);
 		/* Set PISA_ACTIVE after @meta is fully set up. */
 		pisa_meta_set_flags(meta, PISA_ACTIVE);
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
index cd2bfbfb0f1a7..eb51007e66de5 100644
--- a/mm/pisa-kunit.c
+++ b/mm/pisa-kunit.c
@@ -6,6 +6,8 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 #include <linux/pisa.h>
+#include <linux/iommu.h>
+#include <linux/iova.h>
 #include <linux/mm.h>
 #include <linux/shrinker.h>
 #include <linux/skbuff.h>
@@ -277,6 +279,170 @@ static void test_quarantine(struct kunit *test)
 	__free_pages(page, PISA_ORDER);
 }
 
+#ifdef CONFIG_IOMMU_DMA
+static void test_iova_helpers(struct kunit *test)
+{
+	struct device dev = { .numa_node = NUMA_NO_NODE };
+	struct iommu_domain dummy_domain = {};
+	struct pisa_iova pi = {};
+	dma_addr_t d;
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+
+	/* Empty window (base == 0) never owns any IOVA. */
+	KUNIT_EXPECT_FALSE(test, is_pisa_iova(&pi, 0));
+	KUNIT_EXPECT_FALSE(test, is_pisa_iova(&pi, SZ_4G));
+
+	pi.base = SZ_4G;
+	KUNIT_EXPECT_FALSE(test, is_pisa_iova(&pi, SZ_4G - 1));
+	KUNIT_EXPECT_TRUE(test, is_pisa_iova(&pi, SZ_4G));
+	KUNIT_EXPECT_TRUE(test, is_pisa_iova(&pi, SZ_4G + pisa_iova_size() - 1));
+	KUNIT_EXPECT_FALSE(test, is_pisa_iova(&pi, SZ_4G + pisa_iova_size()));
+
+	/* Sentinel values in pisa_iova_declined(). */
+	pi.domain_idx = PISA_IDX_NONE;
+	KUNIT_EXPECT_EQ(test, pisa_iova_declined(&pi), 0);
+	pi.domain_idx = PISA_IDX_NOHUGE;
+	KUNIT_EXPECT_EQ(test, pisa_iova_declined(&pi), -EOPNOTSUPP);
+	pi.domain_idx = PISA_IDX_NOIOVA;
+	KUNIT_EXPECT_EQ(test, pisa_iova_declined(&pi), -ENOSPC);
+	pi.domain_idx = PISA_IDX_NOIDX;
+	pi.idx_gen = READ_ONCE(pisa_domains_generation);
+	KUNIT_EXPECT_EQ(test, pisa_iova_declined(&pi), -EBUSY);
+	pi.idx_gen--;
+	KUNIT_EXPECT_EQ(test, pisa_iova_declined(&pi), 0);
+
+	/* A device without an IOMMU group has no PISA window. */
+	KUNIT_EXPECT_FALSE(test, pisa_map_phys(&d, NULL, NULL, 0, PAGE_SIZE, 0));
+	KUNIT_EXPECT_FALSE(test, pisa_map_phys(&d, &dev, NULL, 0, PAGE_SIZE, 0));
+	/* Releasing an unregistered domain with an active allocator is a safe no-op. */
+	pisa_domain_release(&dummy_domain);
+}
+
+/*
+ * Fake DMA domain for the mapping and coherent allocation tests, backed by a
+ * real iommu_dma_cookie and no-op page table ops.
+ */
+static int fake_map_pages(struct iommu_domain *domain, unsigned long iova,
+			  phys_addr_t paddr, size_t pgsize, size_t pgcount,
+			  int prot, gfp_t gfp, size_t *mapped)
+{
+	*mapped = pgsize * pgcount;
+	return 0;
+}
+
+static size_t fake_unmap_pages(struct iommu_domain *domain, unsigned long iova,
+			       size_t pgsize, size_t pgcount,
+			       struct iommu_iotlb_gather *iotlb_gather)
+{
+	return pgsize * pgcount;
+}
+
+static const struct iommu_domain_ops fake_domain_ops = {
+	.map_pages = fake_map_pages,
+	.unmap_pages = fake_unmap_pages,
+};
+
+static struct iommu_domain fake_domain = {
+	.type = IOMMU_DOMAIN_DMA,
+	.pgsize_bitmap = SZ_4K | PISA_SIZE,
+	.ops = &fake_domain_ops,
+};
+
+static void fake_domain_teardown(void *unused)
+{
+	iommu_put_dma_cookie(&fake_domain);
+	fake_domain.cookie_type = IOMMU_COOKIE_NONE;
+	fake_domain.iova_cookie = NULL;
+	iova_cache_put();
+}
+
+static int fake_domain_setup(struct kunit *test)
+{
+	int ret = iova_cache_get();
+
+	if (ret)
+		return ret;
+	ret = iommu_get_dma_cookie(&fake_domain);
+	if (ret) {
+		iova_cache_put();
+		return ret;
+	}
+	init_iova_domain(pisa_dma_iova(&fake_domain)->iovad, SZ_4K, 1);
+	return kunit_add_action_or_reset(test, fake_domain_teardown, NULL);
+}
+
+static void test_map_and_domain_lifecycle(struct kunit *test)
+{
+	struct device dev = { .init_name = "pisa_map_kunit", .numa_node = NUMA_NO_NODE,
+			      .coherent_dma_mask = DMA_BIT_MASK(64) };
+	struct shrink_control sc = { .nr_to_scan = ULONG_MAX };
+	struct pisa_iova *pi;
+	struct pisa_meta *meta;
+	struct pisa_alloc *pa;
+	unsigned int domain_idx;
+	dma_addr_t d1, d2;
+	struct page *p;
+	phys_addr_t phys;
+
+	dev.dma_mask = &dev.coherent_dma_mask;
+	set_dev_node(&dev, first_memory_node);
+	dev_set_dma_coherent(&dev);
+	KUNIT_ASSERT_EQ(test, fake_domain_setup(test), 0);
+	pi = pisa_dma_iova(&fake_domain);
+
+	pa = pisa_node_pa(first_memory_node, SKB_FRAG_PAGE_ORDER, true);
+	KUNIT_ASSERT_NOT_NULL(test, pa);
+	p = pisa_alloc(pa, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+
+	phys = page_to_phys(p);
+	meta = pisa_meta_of_pfn(page_to_pfn(p));
+	KUNIT_EXPECT_TRUE(test, is_pisa_phys(phys));
+
+	/* TX-only allocator declines IOMMU_WRITE mappings. */
+	KUNIT_EXPECT_FALSE(test,
+			   pisa_map_phys(&d1, &dev, &fake_domain, phys, PAGE_SIZE,
+					 IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE));
+
+	/* First map assigns the window and maps the page. */
+	KUNIT_ASSERT_TRUE(test,
+			  pisa_map_phys(&d1, &dev, &fake_domain, phys, PAGE_SIZE,
+					IOMMU_READ | IOMMU_CACHE));
+	KUNIT_EXPECT_TRUE(test, is_pisa_iova(pi, d1));
+	domain_idx = pi->domain_idx - PISA_IDX_FIRST;
+	KUNIT_EXPECT_TRUE(test, test_bit(domain_idx, meta->domains_mapped));
+
+	/* Second map at an offset hits the lockless fast path. */
+	KUNIT_ASSERT_TRUE(test,
+			  pisa_map_phys(&d2, &dev, &fake_domain, phys + 128, 256,
+					IOMMU_READ | IOMMU_CACHE));
+	KUNIT_EXPECT_EQ(test, d2, d1 + 128);
+
+	/* Quiescing the domain unmaps the PISA page but keeps the window. */
+	pisa_domain_quiesce(&fake_domain);
+	KUNIT_EXPECT_FALSE(test, test_bit(domain_idx, meta->domains_mapped));
+	KUNIT_ASSERT_TRUE(test,
+			  pisa_map_phys(&d2, &dev, &fake_domain, phys, PAGE_SIZE,
+					IOMMU_READ | IOMMU_CACHE));
+	KUNIT_EXPECT_EQ(test, d2, d1);
+	KUNIT_EXPECT_TRUE(test, test_bit(domain_idx, meta->domains_mapped));
+
+	/* Releasing the domain forgets the mapping bit across allocators. */
+	pisa_domain_release(&fake_domain);
+	KUNIT_EXPECT_FALSE(test, test_bit(domain_idx, meta->domains_mapped));
+
+	/* Re-map into a fresh window so shrinking exercises pisa_unmap_all_domains(). */
+	*pi = (struct pisa_iova){ .iovad = pi->iovad };
+	KUNIT_EXPECT_TRUE(test,
+			  pisa_map_phys(&d1, &dev, &fake_domain, phys, PAGE_SIZE,
+					IOMMU_READ | IOMMU_CACHE));
+
+	__free_pages(p, SKB_FRAG_PAGE_ORDER);
+	pisa_shrink_scan(NULL, &sc);
+}
+#endif /* CONFIG_IOMMU_DMA */
+
 static void test_reservoir_and_scrubber(struct kunit *test)
 {
 	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
@@ -289,6 +455,10 @@ static struct kunit_case pisa_meta_test_cases[] = {
 	KUNIT_CASE(test_meta_active_toggle),
 	KUNIT_CASE(test_alloc_and_recycle),
 	KUNIT_CASE(test_quarantine),
+#ifdef CONFIG_IOMMU_DMA
+	KUNIT_CASE(test_iova_helpers),
+	KUNIT_CASE(test_map_and_domain_lifecycle),
+#endif
 	KUNIT_CASE(test_reservoir_and_scrubber),
 	{}
 };
diff --git a/mm/pisa-node.c b/mm/pisa-node.c
index 29f6ba866b633..a39251b952263 100644
--- a/mm/pisa-node.c
+++ b/mm/pisa-node.c
@@ -171,7 +171,8 @@ void pisa_release_page(struct pisa_meta *meta)
 	/* Count it now: pisa_alloc_held_pages() must not see a retiring page as held. */
 	atomic64_inc(&meta->pa->stats.page_free);
 
-	/* pisa_unmap_all_domains(meta) will be called here once IOMMU mappings are added. */
+	/* Quarantined on unmap failure and leaked in pisa_release_page_rcu(). */
+	pisa_unmap_all_domains(meta);
 
 	/* Clear PISA_ACTIVE before the RCU grace period so new readers stop entering. */
 	pisa_meta_clear_flags(meta, PISA_ACTIVE);
diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
index a191ede9bf3ce..8736b8d168727 100644
--- a/mm/pisa-priv.h
+++ b/mm/pisa-priv.h
@@ -16,6 +16,11 @@
 #include <linux/workqueue.h>
 
 
+#ifdef CONFIG_IOMMU_DMA
+int iommu_get_dma_cookie(struct iommu_domain *domain);
+void iommu_put_dma_cookie(struct iommu_domain *domain);
+#endif
+
 #ifdef CONFIG_PISA
 
 /* Number of order-@order blocks in one PISA page. */
@@ -31,6 +36,10 @@
  * 2. Metadata tables (mm/pisa-meta.c):
  *    pisa_meta_mutex (mutex): init and hotplug page-table population.
  *    pisa_slot_lock (spinlock): slot allocation and @pisa_meta_array PTE install.
+ *
+ * 3. IOMMU domains (drivers/iommu/pisa-map.c):
+ *    pisa_srcu -> pisa_domains_lock (spinlock, leaf over pisa_domains[]).
+ *    pisa_domains[].map_lock (spinlock): standalone per-domain iommu_map() lock.
  */
 
 /*
@@ -90,6 +99,7 @@ struct pisa_alloc {
 	/* First cacheline: hot fields touched on block alloc and free. */
 	spinlock_t		lock;
 	u8			order;		/* block order (<= PISA_ORDER) */
+	u8			prot;		/* IOMMU_READ and/or IOMMU_WRITE */
 	struct list_head	partial;	/* partial pages with nr_clean > 0 */
 	struct list_head	partial_dirty;	/* partial pages with nr_clean == 0 */
 	struct list_head	idle;		/* completely free PISA pages */
-- 
2.56.1.809.ga0b61035b5-goog

