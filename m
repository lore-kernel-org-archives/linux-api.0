Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136844;
	b=f5+zA7VguTZXApeE4pU3oBF1HtzuxYXFrzaoZGY6srsNYlhMLtVGDc8qWPL2V+H/sHBH
	 UydO0kYVtH7RmBFX3i5uXqpJDafUEZh0rPoile+goVs/M0utH3Whq8ZbqLMzxgJj+aBKo
	 nQ3UeVAcKQh8RFUDZWr8dbOY31pvZk7BpmJjMlPTopIwMxvSb3RwmEVsSd0uZ1jW7Sorz
	 AKiyRGC4rV6bz0sAX9snEu72kwZO/c/Lc8TTI+ZuZKz0EaTdmz3JH25Kmc/Lm+0zo47Nw
	 RtyzN5hR71gixTXiIal+K4sXk2CmNG3lNPg2ju6EP8WBb+Jz92KUXZE+ER8u8v1vDeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136844;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=z/nGZDSV0FPahyw766UgGERxU/8sVZCVi6OGiUwkQxo=;
	b=QsoU8sGyySsvfZBSnyFeoaj4VxqALpxGijtZq2fy/fFKYKdOUouNkgSbqL1LYWhGDSg/
	 uVOm+ihS36prXj+XCXGdrQImQEWJ6M4YpXKskgoeVWsp5TQF3XW4A1tcc4/8D7RpiJWGx
	 F5mgkd+yTmLn3abql3Vm1CBRVASKnQOUy5sbDndqVxpFmH+swWOrKKM/1vajo2CoUBBow
	 hQVq+QrdG+bca2Gpdi4FkigmJXm1gaZH6XKIZJvEVreL+BUYJufTRVEUrFMDkgwu4Ufnu
	 Bor9MjqAVAjptHwR69fdIzh2PSTP/Pf6bYe317ZZ7bCCRxJis4SzqJT8CKZ9Dj3YUdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JYuhVIb0;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C48460722A8
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C48460722A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JYuhVIb0
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c5101fd59e3so34807066b.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136842; x=1795741642; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z/nGZDSV0FPahyw766UgGERxU/8sVZCVi6OGiUwkQxo=;
        b=JYuhVIb01umul7ve5l5iukIO18fULCnT0/c33Ja38ZEGqt4/YQacWVypwSSs0SRJnD
         iLMYi98AiTqWAccVIDNYqhCCzkRIJ497cP5aw0/lRBu/W3cHrpuuHjtss/C0ARgiLFMj
         DZQHcijMiueSolcEYRswRfzZBz7lQqxQ/4FJ7k9fWzp8qiBKMm1C7nKVTfDPAy8vokh1
         PmoCTpZ0WFLbyfLawSn2JX1vOJudYkCY/dlvcFT1+CM8+ZWZ4c+2d2axkQ+Kb0howyeG
         cz2/FpDhptWQC7X8RquihqOCyI/2GJSPo28D6P+iADovP3hwKhchgv/gZ4XL9oURLLs4
         RHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136842; x=1795741642;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z/nGZDSV0FPahyw766UgGERxU/8sVZCVi6OGiUwkQxo=;
        b=P1HJvlOkJzMb7h57aOIVFzCeYujZ6ya+bEHTyod072iuR/PcBqT4J1KFhRgSa7m33l
         3ueXNfwK0AVXsnw/fe2t7Gs9vuV8GkSeDwR1jh1PxPKD8/l4sglJt4GQqTstDB/b7GJn
         mCiyWPsRZWfwAWHmM9YZciS1SGhtVHIjDBBh60dSbAl6AjT43MrxM+UUDvpq+yMuImPF
         8XTL1qUg6KfIur66SwJqlweEzYqI6hPgQTCmT0UGrEcVCwYIg+zY0qgKYDqhDmkNcY3n
         1vtqqltxcYhEQum7PjoL2+QPGzyYIAKHS3NrL2UAccasTyezqWAc/jt+f8llGO5bWtdl
         NVSg==
X-Forwarded-Encrypted: i=1; AL+hErGZsheAjSNNCBcbAcsF2SoTE7b7L1Kk9b4Jnop/bfVaqQ6BaOnx5YtEOrDsmrIYKLsy2hEMjewRtkk=@vger.kernel.org
X-Gm-Message-State: APuU4Z/5bqTnMfekUYxT6TaNllL75c8yxiQ4xp+t1seR5UGPb7ALO91e
	bRLQuZy7pwFiKwbonftg6UpKY0+2izzMzoKLW2J/4vje+NSkaknYL6H0k6TrXGehUnWbf7gTrY6
	cU2OXwQ==
X-Received: from ejdlt10-n1.prod.google.com ([2002:a17:907:c64a:10b0:c46:4964:67fb])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:7f01:b0:c4d:2867:281c
 with SMTP id a640c23a62f3a-c513a89466dmr118007866b.1.1795136841664; Thu, 19
 Nov 2026 17:07:21 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:49 +0000
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
Message-ID: <20261120010655.467825-20-lrizzo@google.com>
Subject: [RFC PATCH v3 19/25] mm, iommu/dma: Support decrypted PISA pages
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

In Confidential Computing (CoCo) guests (AMD SEV-SNP, Intel TDX, ARM CCA),
guest memory is private/encrypted by default, and DMA buffers must be
converted to shared/decrypted in the host page tables before a device
can access them.

Doing that hypercall per-packet on 4KB pages is prohibitively expensive,
so guests normally bounce DMA through swiotlb. With PISA, 2MB pages are
decrypted once upfront when allocated and re-encrypted only when retired
back to the buddy allocator, avoiding both per-packet hypercalls and
bounce-buffer copies.

Add the pisa_decrypt_key static key (enabled at boot in CoCo guests,
which report CC_ATTR_GUEST_MEM_ENCRYPT) and the PISA_DECRYPTED flag to
manage 2MB page decryption/re-encryption and bypass swiotlb bouncing for
decrypted PISA pages.

PISA refuses to initialize when memory is encrypted but the platform is
neither such a guest nor a bare-metal SME host, rather than hand a device
memory that it cannot access. That covers arm64 Realms until the next
commit.

Pages are decrypted in sleepable context, so atomic callers are only
served from the per-node reservoirs: in a CoCo guest pisa.reservoir_max
cannot be set to 0, and the reservoirs are filled when PISA is first
enabled.

User PTEs that map a decrypted PISA page are built with
pisa_pgprot_decrypted(), which applies pgprot_decrypted().

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/dma-iommu.c  |   4 +
 drivers/iommu/pisa-map.c   |   8 +-
 include/linux/pisa-iommu.h |   6 ++
 include/linux/pisa-mm.h    |  20 +++++
 include/linux/pisa.h       |  21 +++++
 kernel/dma/direct.c        |   4 +
 mm/ksm.c                   |   3 +-
 mm/memory.c                |   8 +-
 mm/migrate.c               |   3 +-
 mm/pisa-alloc.c            |   9 ++-
 mm/pisa-kunit.c            |  13 ++-
 mm/pisa-meta.c             |  17 ++++
 mm/pisa-node.c             | 159 ++++++++++++++++++++++++++++++++-----
 mm/pisa-priv.h             |   8 +-
 mm/swapfile.c              |   3 +-
 mm/userfaultfd.c           |   7 +-
 16 files changed, 260 insertions(+), 33 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 45e9432d2a020..5e4d9803645b4 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -37,6 +37,7 @@
 
 #include "dma-iommu.h"
 #include <linux/pisa.h>
+#include <linux/pisa-mm.h>
 #include "iommu-pages.h"
 #include "iommu-priv.h"
 
@@ -1780,6 +1781,9 @@ int iommu_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		pfn = vmalloc_to_pfn(cpu_addr);
 	} else {
 		pfn = page_to_pfn(virt_to_page(cpu_addr));
+		/* A decrypted PISA page (CoCo guest) needs a decrypted user mapping too. */
+		vma->vm_page_prot = pisa_pgprot_decrypted(virt_to_page(cpu_addr),
+							  vma->vm_page_prot);
 	}
 
 	return remap_pfn_range(vma, vma->vm_start, pfn + off,
diff --git a/drivers/iommu/pisa-map.c b/drivers/iommu/pisa-map.c
index bbf330877f824..08ac91fafcf20 100644
--- a/drivers/iommu/pisa-map.c
+++ b/drivers/iommu/pisa-map.c
@@ -7,6 +7,7 @@
 #include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/cache.h>
+#include <linux/dma-direct.h>
 #include <linux/dma-map-ops.h>
 #include <linux/dma-mapping.h>
 #include <linux/iommu.h>
@@ -354,7 +355,10 @@ bool __pisa_map_phys(dma_addr_t *iova, struct device *dev,
 
 	/* Every mapping of the page carries IOMMU_CACHE | @meta->prot. */
 	block_prot = IOMMU_CACHE | meta->prot;
-	if (unlikely(prot & ~block_prot))
+	/* In a CoCo guest @dev can only reach decrypted pages; an SME host needs no check. */
+	if (unlikely((prot & ~block_prot) ||
+		     (pisa_decrypt_enabled() && force_dma_unencrypted(dev) &&
+		      !(meta->flags & PISA_DECRYPTED))))
 		return false;
 
 	/* Acquire pairs with the .base release in pisa_domain_init(). */
@@ -388,7 +392,7 @@ bool __pisa_map_phys(dma_addr_t *iova, struct device *dev,
 		phys_addr_t pisa_phys = phys & PISA_MASK;
 
 		ret = iommu_map(domain, pisa_phys_to_iova(pi, meta, pisa_phys),
-				pisa_phys, PISA_SIZE, block_prot, GFP_ATOMIC);
+				pisa_pte_phys(meta, pisa_phys), PISA_SIZE, block_prot, GFP_ATOMIC);
 		if (unlikely(ret))
 			return false;
 		/* Ensure the mapping is visible before setting the domain bit. */
diff --git a/include/linux/pisa-iommu.h b/include/linux/pisa-iommu.h
index 7dd91ff47288a..fed44c2050f9a 100644
--- a/include/linux/pisa-iommu.h
+++ b/include/linux/pisa-iommu.h
@@ -81,6 +81,12 @@ struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn);
 bool pisa_quarantine_page(struct pisa_meta *meta);
 void pisa_schedule_reclaim(void);
 
+/* Physical address for IOMMU PTE of @meta at @phys (shared alias if decrypted). */
+static inline phys_addr_t pisa_pte_phys(const struct pisa_meta *meta, phys_addr_t phys)
+{
+	return (meta->flags & PISA_DECRYPTED) ? dma_addr_unencrypted(phys) : phys;
+}
+
 /* IOVA of @phys inside active RAM page @meta in @pi. */
 static inline dma_addr_t pisa_phys_to_iova(const struct pisa_iova *pi,
 					   const struct pisa_meta *meta, phys_addr_t phys)
diff --git a/include/linux/pisa-mm.h b/include/linux/pisa-mm.h
index fd5e7234e9423..8034850d2c87b 100644
--- a/include/linux/pisa-mm.h
+++ b/include/linux/pisa-mm.h
@@ -121,6 +121,21 @@ static inline bool pisa_writeback_upgrade(const struct address_space *mapping,
 	       __pisa_writeback_upgrade(mapping, folio, index, fbatch);
 }
 
+/*
+ * Hook for the paths that build a user PTE for a page that may be a decrypted
+ * PISA page (CoCo guests, @pisa_decrypt_key). Not tied to @pisa_user_key: RX
+ * buffers and coherent memory are mapped to user space too, and decrypted user
+ * pages outlive pisa.user_max_pages=0.
+ */
+static inline pgprot_t pisa_pgprot_decrypted(const struct page *page, pgprot_t prot)
+{
+	if (pisa_decrypt_enabled() &&
+	    (pisa_pfn_flags(page_to_pfn(page)) & (PISA_ACTIVE | PISA_DECRYPTED)) ==
+	    (PISA_ACTIVE | PISA_DECRYPTED))
+		return pgprot_decrypted(prot);
+	return prot;
+}
+
 #else /* !CONFIG_PISA */
 
 static inline unsigned long
@@ -175,6 +190,11 @@ static inline bool pisa_writeback_upgrade(const struct address_space *mapping,
 	return false;
 }
 
+static inline pgprot_t pisa_pgprot_decrypted(const struct page *page, pgprot_t prot)
+{
+	return prot;
+}
+
 static inline int pisa_madvise(struct vm_area_struct *vma, unsigned long start,
 			       unsigned long end, bool to_pisa)
 {
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 11e3ea9eb263d..92a4c529d1605 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -62,20 +62,24 @@ static inline struct pisa_iova *pisa_dma_iova(struct iommu_domain *domain) { ret
 enum {
 	_PISA_ACTIVE,
 	_PISA_QUARANTINED,
+	_PISA_DECRYPTED,
 };
 
 #define PISA_ACTIVE		BIT(_PISA_ACTIVE)	/* set up as a PISA page, not retired yet */
 #define PISA_QUARANTINED	BIT(_PISA_QUARANTINED)	/* IOMMU unmap failed: never reuse */
+#define PISA_DECRYPTED		BIT(_PISA_DECRYPTED)	/* page was set_memory_decrypted() */
 
 /*
  * Static keys guarding all kernel hooks:
  * - @pisa_key: enabled on first device opt-in (pisa_meta_init()).
  * - @pisa_recycle_check_key: enabled when pisa.compact or pisa.target_usage_percent > 0.
  * - @pisa_user_key: enabled when pisa.user_max_pages > 0.
+ * - @pisa_decrypt_key: enabled at boot in CoCo guests, where PISA pages are decrypted.
  */
 DECLARE_STATIC_KEY_FALSE(pisa_key);
 DECLARE_STATIC_KEY_FALSE(pisa_recycle_check_key);
 DECLARE_STATIC_KEY_FALSE(pisa_user_key);
+DECLARE_STATIC_KEY_FALSE(pisa_decrypt_key);
 
 extern u32 *pisa_pfn2slot;
 extern unsigned int pisa_nr_slots;
@@ -92,6 +96,7 @@ void *__pisa_alloc_map_coherent_dev(struct device *dev, size_t size,
 				    unsigned long attrs);
 bool __pisa_has_free_blocks_rx(unsigned int order, int nid);
 bool __pisa_page_can_recycle(const struct page *page);
+bool __is_pisa_direct(phys_addr_t phys, size_t size);
 bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 			     size_t size, size_t offset,
 			     enum dma_data_direction dir, bool pinned);
@@ -107,6 +112,11 @@ static inline bool pisa_user_enabled(void)
 	return static_branch_unlikely(&pisa_user_key);
 }
 
+static inline bool pisa_decrypt_enabled(void)
+{
+	return static_branch_unlikely(&pisa_decrypt_key);
+}
+
 static inline u32 pisa_pfn_flags(unsigned long pfn)
 {
 	unsigned long frame = pfn >> PISA_ORDER;
@@ -181,6 +191,12 @@ static inline bool pisa_free_coherent(const void *cpu_addr, size_t size)
 	return true;
 }
 
+/* Hook for dma_direct_map_phys() CoCo swiotlb bypass (guarded by @pisa_key). */
+static inline bool is_pisa_direct(phys_addr_t phys, size_t size)
+{
+	return pisa_enabled() && __is_pisa_direct(phys, size);
+}
+
 /* Hook for __page_pool_alloc_netmems_slow() (guarded by @pisa_key). */
 static inline gfp_t pisa_rx_gfp(const struct device *dev)
 {
@@ -237,6 +253,11 @@ static inline bool pisa_free_coherent(const void *cpu_addr, size_t size)
 	return false;
 }
 
+static inline bool is_pisa_direct(phys_addr_t phys, size_t size)
+{
+	return false;
+}
+
 static inline gfp_t pisa_rx_gfp(const struct device *dev)
 {
 	return 0;
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 9ac4912e4a0a1..545f2fdb6088d 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -709,6 +709,10 @@ dma_addr_t dma_direct_map_phys(struct device *dev, phys_addr_t phys,
 		return swiotlb_map(dev, phys, size, dir, attrs);
 	}
 
+	if (force_dma_unencrypted(dev) && !is_swiotlb_for_alloc(dev) &&
+	    is_pisa_direct(phys, size))
+		attrs |= DMA_ATTR_CC_SHARED;
+
 	if (attrs & DMA_ATTR_CC_SHARED)
 		dma_addr = phys_to_dma_unencrypted(dev, phys);
 	else
diff --git a/mm/ksm.c b/mm/ksm.c
index d24b129932bf7..f5763b0bdb4fb 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -23,6 +23,7 @@
 #include <linux/sched/cputime.h>
 #include <linux/rwsem.h>
 #include <linux/pagemap.h>
+#include <linux/pisa-mm.h>
 #include <linux/rmap.h>
 #include <linux/spinlock.h>
 #include <linux/xxhash.h>
@@ -1447,7 +1448,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 	if (!is_zero_pfn(page_to_pfn(kpage))) {
 		folio_get(kfolio);
 		folio_add_anon_rmap_pte(kfolio, kpage, vma, addr, RMAP_NONE);
-		newpte = mk_pte(kpage, vma->vm_page_prot);
+		newpte = mk_pte(kpage, pisa_pgprot_decrypted(kpage, vma->vm_page_prot));
 	} else {
 		/*
 		 * Use pte_mkdirty to mark the zero page mapped by KSM, and then
diff --git a/mm/memory.c b/mm/memory.c
index 7f019afc35ca0..90aad56b97b6d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -50,6 +50,7 @@
 #include <linux/swap.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/pisa-mm.h>
 #include <linux/memremap.h>
 #include <linux/kmsan.h>
 #include <linux/ksm.h>
@@ -915,7 +916,7 @@ static void restore_exclusive_pte(struct vm_area_struct *vma,
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	pte = pte_mkold(mk_pte(page, READ_ONCE(vma->vm_page_prot)));
+	pte = pte_mkold(mk_pte(page, pisa_pgprot_decrypted(page, READ_ONCE(vma->vm_page_prot))));
 	if (pte_swp_soft_dirty(orig_pte))
 		pte = pte_mksoft_dirty(pte);
 
@@ -2487,6 +2488,7 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 	}
 
 	/* Ok, finally just insert the thing.. */
+	prot = pisa_pgprot_decrypted(page, prot);
 	pteval = mk_pte(page, prot);
 	if (unlikely(is_zero_folio(folio))) {
 		pteval = pte_mkspecial(pteval);
@@ -5285,7 +5287,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
 	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
-	pte = mk_pte(page, vma->vm_page_prot);
+	pte = mk_pte(page, pisa_pgprot_decrypted(page, vma->vm_page_prot));
 	if (pte_swp_soft_dirty(vmf->orig_pte))
 		pte = pte_mksoft_dirty(pte);
 	if (pte_swp_uffd(vmf->orig_pte))
@@ -5836,7 +5838,7 @@ void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 	pte_t entry;
 
 	flush_icache_pages(vma, page, nr);
-	entry = mk_pte(page, vma->vm_page_prot);
+	entry = mk_pte(page, pisa_pgprot_decrypted(page, vma->vm_page_prot));
 
 	if (prefault && arch_wants_old_prefaulted_pte())
 		entry = pte_mkold(entry);
diff --git a/mm/migrate.c b/mm/migrate.c
index e6cd83cf32aa1..9b1d40710ff0f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -37,6 +37,7 @@
 #include <linux/gfp.h>
 #include <linux/page_idle.h>
 #include <linux/page_owner.h>
+#include <linux/pisa-mm.h>
 #include <linux/sched/mm.h>
 #include <linux/ptrace.h>
 #include <linux/memory.h>
@@ -398,7 +399,7 @@ static bool remove_migration_pte(struct folio *folio,
 
 		folio_get(folio);
 		new = folio_page(folio, idx);
-		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
+		pte = mk_pte(new, pisa_pgprot_decrypted(new, READ_ONCE(vma->vm_page_prot)));
 		if (!softleaf_is_migration_young(entry))
 			pte = pte_mkold(pte);
 		if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
index 4fc3b4d29de67..edfa7cf424451 100644
--- a/mm/pisa-alloc.c
+++ b/mm/pisa-alloc.c
@@ -9,6 +9,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/cache.h>
+#include <linux/cc_platform.h>
 #include <linux/cpuhotplug.h>
 #include <linux/device.h>
 #include <linux/dma-direct.h>
@@ -178,7 +179,7 @@ static void pisa_reclaim_work_fn(struct work_struct *work)
 
 	node = llist_del_all(&pisa_free_list);
 	llist_for_each_entry_safe(meta, tmp, node, llnode)
-		pisa_release_page(meta);
+		__pisa_release_page(meta);
 
 	if (next_delay != MAX_JIFFY_OFFSET)
 		queue_delayed_work(pisa_wq ?: system_wq, &pisa_reclaim_work, next_delay);
@@ -833,7 +834,7 @@ static struct pisa_meta *pisa_alloc_split_page(unsigned int order, gfp_t gfp, in
 	int err;
 
 	/* __GFP_DMA/__GFP_DMA32 were already declined by pisa_alloc_bulk(). */
-	meta = pisa_reservoir_pop(nid, gfp & ~__GFP_ZERO, &clean);
+	meta = pisa_reservoir_pop(nid, gfp & ~__GFP_ZERO, pisa_want_decrypt(), &clean);
 	if (IS_ERR(meta))
 		return meta;
 
@@ -1268,7 +1269,7 @@ __pisa_alloc_map_coherent(struct device *dev, struct iommu_domain *domain,
 		    !pisa_coherent_dev_fits(dev, pi))
 			return NULL;
 	} else if (is_swiotlb_for_alloc(dev) ||
-		   force_dma_unencrypted(dev) ||
+		   (force_dma_unencrypted(dev) && !pisa_want_decrypt()) ||
 		   !dma_coherent_ok(dev, PFN_PHYS(max_pfn) - 1, 1)) {
 		return NULL;
 	}
@@ -1331,6 +1332,8 @@ __pisa_alloc_map_coherent(struct device *dev, struct iommu_domain *domain,
 			pisa_free_coherent(page_address(page), size);
 			return NULL;
 		}
+	} else if (force_dma_unencrypted(dev)) {
+		*dma_handle = phys_to_dma_unencrypted(dev, page_to_phys(page));
 	} else {
 		*dma_handle = phys_to_dma(dev, page_to_phys(page));
 	}
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
index 0dbc3ecf44465..c195fdfdbd9fa 100644
--- a/mm/pisa-kunit.c
+++ b/mm/pisa-kunit.c
@@ -66,7 +66,7 @@ static void pisa_meta_set_active(struct pisa_meta *meta, bool active)
 	if (active)
 		pisa_meta_set_flags(meta, PISA_ACTIVE);
 	else
-		pisa_meta_clear_flags(meta, PISA_ACTIVE);
+		pisa_meta_clear_flags(meta, PISA_ACTIVE | PISA_DECRYPTED);
 }
 
 static void test_meta_active_toggle(struct kunit *test)
@@ -74,6 +74,7 @@ static void test_meta_active_toggle(struct kunit *test)
 	unsigned long pfn, base_pfn;
 	struct pisa_meta *meta;
 	struct page *page;
+	phys_addr_t pa;
 
 	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
 
@@ -91,16 +92,26 @@ static void test_meta_active_toggle(struct kunit *test)
 	}
 	KUNIT_EXPECT_EQ(test, pisa_meta_ensure_pfn(pfn, false), 0);
 	meta = pisa_meta_of_pfn(pfn);
+	pa = page_to_phys(page);
 
 	KUNIT_EXPECT_FALSE(test, is_pisa_pfn(pfn));
+	KUNIT_EXPECT_FALSE(test, is_pisa_direct(pa, PAGE_SIZE));
 
 	pisa_meta_set_active(meta, true);
 	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(base_pfn));
 	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(pfn));
 	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(base_pfn + (1UL << PISA_ORDER) - 1));
+	KUNIT_EXPECT_FALSE(test, is_pisa_direct(pa, PAGE_SIZE));
+	KUNIT_EXPECT_EQ(test, pisa_pte_phys(meta, pa), pa);
+
+	pisa_meta_set_flags(meta, PISA_ACTIVE | PISA_DECRYPTED);
+	KUNIT_EXPECT_TRUE(test, is_pisa_direct(pa, PAGE_SIZE));
+	KUNIT_EXPECT_FALSE(test, is_pisa_direct(pa, PISA_SIZE + PAGE_SIZE));
+	KUNIT_EXPECT_EQ(test, pisa_pte_phys(meta, pa), dma_addr_unencrypted(pa));
 
 	pisa_meta_set_active(meta, false);
 	KUNIT_EXPECT_FALSE(test, is_pisa_pfn(pfn));
+	KUNIT_EXPECT_FALSE(test, is_pisa_direct(pa, PAGE_SIZE));
 
 	pisa_slot_free(meta);
 	__free_pages(page, PISA_ORDER);
diff --git a/mm/pisa-meta.c b/mm/pisa-meta.c
index 25d3add7a4891..99c5bc42eed10 100644
--- a/mm/pisa-meta.c
+++ b/mm/pisa-meta.c
@@ -176,6 +176,19 @@ struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn)
 	return &pisa_meta_array[slot - 1];
 }
 
+bool __is_pisa_direct(phys_addr_t phys, size_t size)
+{
+	u32 flags = pisa_pfn_flags(PHYS_PFN(phys));
+
+	/*
+	 * Only decrypted active pages can bypass swiotlb bouncing, and the
+	 * transfer must not straddle the end of the PISA frame.
+	 */
+	return (flags & (PISA_ACTIVE | PISA_DECRYPTED)) ==
+	       (PISA_ACTIVE | PISA_DECRYPTED) &&
+	       (phys & (PISA_SIZE - 1)) + size <= PISA_SIZE;
+}
+
 /*
  * Update @meta's position on @pa's lists under @pa->lock. When all blocks
  * become available (avail == bpp), either queues @meta to @pisa_free_list (and
@@ -716,6 +729,9 @@ int pisa_meta_init(void)
 
 	if (pisa_enabled())
 		return 0;
+	/* Never hand a device memory that it cannot access. */
+	if (pisa_cc_unsupported())
+		return -EOPNOTSUPP;
 
 	mutex_lock(&pisa_meta_mutex);
 	if (pisa_init_err) {
@@ -790,6 +806,7 @@ int pisa_meta_init(void)
 	mutex_unlock(&pisa_meta_mutex);
 out_enable:
 	static_branch_enable(&pisa_key);
+	pisa_reservoir_prime();
 	pisa_schedule_reservoir();
 	return 0;
 
diff --git a/mm/pisa-node.c b/mm/pisa-node.c
index 8d6fa9f36bdcf..12fbb617c342b 100644
--- a/mm/pisa-node.c
+++ b/mm/pisa-node.c
@@ -6,6 +6,7 @@
 
 #include <linux/atomic.h>
 #include <linux/bitops.h>
+#include <linux/cc_platform.h>
 #include <linux/device.h>
 #include <linux/export.h>
 #include <linux/pisa.h>
@@ -18,6 +19,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
+#include <linux/set_memory.h>
 #include <linux/spinlock.h>
 #include <linux/topology.h>
 #include <linux/workqueue.h>
@@ -32,6 +34,22 @@
  */
 unsigned int pisa_reservoir_max __read_mostly = 16;
 
+/* Enabled in CoCo guests by pisa_node_init(): new PISA pages are decrypted for DMA. */
+DEFINE_STATIC_KEY_FALSE(pisa_decrypt_key);
+
+/* A confidential guest: PISA pages are decrypted for DMA. A bare-metal SME host is not one. */
+static bool pisa_coco_guest(void)
+{
+	return cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT);
+}
+
+/* Memory encryption that PISA cannot handle: neither an SME host nor a guest it decrypts for. */
+bool pisa_cc_unsupported(void)
+{
+	return cc_platform_has(CC_ATTR_MEM_ENCRYPT) &&
+	       !cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT) && !pisa_coco_guest();
+}
+
 /* Per-NUMA-node PISA state (ring/TX/user allocators, reservoir). */
 struct pisa_node pisa_nodes[MAX_NUMNODES] = {
 	[0 ... MAX_NUMNODES - 1] = {
@@ -45,7 +63,9 @@ struct pisa_node pisa_nodes[MAX_NUMNODES] = {
 
 static int pisa_reservoir_max_set(const char *val, const struct kernel_param *kp)
 {
-	int ret = param_set_uint(val, kp);
+	/* CoCo guests: only the reservoir gives decrypted pages to atomic callers. */
+	unsigned int min = pisa_coco_guest() ? 1 : 0;
+	int ret = param_set_uint_minmax(val, kp, min, UINT_MAX);
 
 	/* Schedule per-node workers to refill or trim once pisa_meta_init() has run. */
 	if (pisa_enabled() && !ret)
@@ -71,9 +91,49 @@ static unsigned int pisa_memalloc_save(gfp_t gfp)
 	return memalloc_flags_save(flags);
 }
 
+/* Return true if a new PISA page should be decrypted: CoCo guests, not bare-metal SME hosts. */
+bool pisa_want_decrypt(void)
+{
+	return pisa_decrypt_enabled();
+}
+
+/* Decrypt and zero a new PISA page. Must be called from sleepable context. */
+static int pisa_page_prepare(struct page *page, struct pisa_meta *meta)
+{
+	void *vaddr = page_address(page);
+	int ret;
+
+	ret = set_memory_decrypted((unsigned long)vaddr, 1 << PISA_ORDER);
+	if (ret) {
+		/* Leak partially shared page rather than returning it to the buddy allocator. */
+		pr_warn_ratelimited("pisa: leaking PISA page that could not be decrypted\n");
+		return ret;
+	}
+	/* Initialize cleartext cachelines after flipping encryption state. */
+	memset(vaddr, 0, PISA_SIZE);
+	pisa_meta_set_flags(meta, PISA_DECRYPTED);
+	return 0;
+}
+
+/* Undo pisa_page_prepare(). */
+static int pisa_page_unprepare(struct pisa_meta *meta)
+{
+	struct page *page;
+
+	if (!(meta->flags & PISA_DECRYPTED))
+		return 0;
+	page = pisa_meta_to_page(meta);
+	if (set_memory_encrypted((unsigned long)page_address(page), 1 << PISA_ORDER)) {
+		pr_warn_ratelimited("pisa: leaking PISA page that could not be re-encrypted\n");
+		return -EIO;
+	}
+	pisa_meta_clear_flags(meta, PISA_DECRYPTED);
+	return 0;
+}
+
 /* Allocate a PISA page from the buddy allocator and initialize its metadata. */
 static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_block,
-					   bool *clean)
+					   bool decrypt, bool *clean)
 {
 	struct pisa_meta *meta;
 	unsigned int memflags;
@@ -97,6 +157,8 @@ static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_block,
 	 * must not dip into emergency reserves or trigger OOM/warnings.
 	 */
 	gfp &= ~(__GFP_COMP | __GFP_HIGHMEM | __GFP_MOVABLE);
+	if (decrypt)
+		gfp &= ~__GFP_ZERO;
 	gfp |= __GFP_NOWARN | __GFP_NOMEMALLOC | (can_block ? __GFP_RETRY_MAYFAIL : __GFP_NORETRY);
 
 	if (can_block)
@@ -116,13 +178,21 @@ static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_block,
 		__free_pages(page, PISA_ORDER);
 		return ERR_PTR(err);
 	}
-	if (can_block)
-		memalloc_flags_restore(memflags);
 
 	meta = pisa_meta_of_pfn(page_to_pfn(page));
 
 	atomic_long_inc(&pisa_nr_pages);
-	*clean = (gfp & __GFP_ZERO) || want_init_on_alloc(0) || want_init_on_free();
+	/* On decrypt failure the page is leaked and stays charged to budget. */
+	if (decrypt && pisa_page_prepare(page, meta)) {
+		pisa_slot_free(meta);
+		if (can_block)
+			memalloc_flags_restore(memflags);
+		return ERR_PTR(-EIO);
+	}
+	if (can_block)
+		memalloc_flags_restore(memflags);
+	*clean = (gfp & __GFP_ZERO) || (meta->flags & PISA_DECRYPTED) ||
+		 want_init_on_alloc(0) || want_init_on_free();
 
 	return meta;
 }
@@ -150,8 +220,8 @@ static void pisa_release_page_rcu(struct rcu_head *head)
 	/* The page has been unmapped from every domain by pisa_release_page() */
 	pisa_slot_free(meta);
 
-	/* Possibly still mapped by a device: leak it, still charged. */
-	if (flags & PISA_QUARANTINED)
+	/* Still shared with the host, or possibly still mapped by a device. */
+	if (flags & (PISA_DECRYPTED | PISA_QUARANTINED))
 		return;
 	atomic_long_dec(&pisa_nr_pages);
 	for (unsigned int i = 0; i < PISA_BLOCKS(order); i++) {
@@ -162,12 +232,20 @@ static void pisa_release_page_rcu(struct rcu_head *head)
 	}
 }
 
-/* Unmap a retired PISA page, clear PISA_ACTIVE, and queue RCU release. */
-void pisa_release_page(struct pisa_meta *meta)
+/*
+ * Unmap a retired PISA page, clear PISA_ACTIVE, and queue RCU release.
+ * Re-encrypting a decrypted page may sleep.
+ */
+void __pisa_release_page(struct pisa_meta *meta)
 {
 	if (!meta->pa) {
 		struct page *page = pisa_meta_to_page(meta);
 
+		/* Unbound (reservoir) page: leaked if re-encryption fails. */
+		if (pisa_page_unprepare(meta)) {
+			pisa_slot_free(meta);
+			return;
+		}
 		pisa_slot_free(meta);
 		__free_pages(page, PISA_ORDER);
 		atomic_long_dec(&pisa_nr_pages);
@@ -182,9 +260,26 @@ void pisa_release_page(struct pisa_meta *meta)
 
 	/* Clear PISA_ACTIVE before the RCU grace period so new readers stop entering. */
 	pisa_meta_clear_flags(meta, PISA_ACTIVE);
+	if ((READ_ONCE(meta->flags) & (PISA_DECRYPTED | PISA_QUARANTINED)) == PISA_DECRYPTED) {
+		synchronize_rcu();
+		if (!(READ_ONCE(meta->flags) & PISA_QUARANTINED))
+			pisa_page_unprepare(meta);
+	}
+
 	call_rcu(&meta->rcu, pisa_release_page_rcu);
 }
 
+/* Release @meta from any context: a decrypted page goes through the reclaim worker. */
+void pisa_release_page(struct pisa_meta *meta)
+{
+	if (meta->flags & PISA_DECRYPTED) {
+		llist_add(&meta->llnode, &pisa_free_list);
+		pisa_schedule_reclaim();
+	} else {
+		__pisa_release_page(meta);
+	}
+}
+
 /* Refill node @nid's reservoir up to pisa_reservoir_max pre-zeroed PISA pages. */
 static void pisa_reservoir_refill_node(struct pisa_node *node, int nid)
 {
@@ -193,13 +288,14 @@ static void pisa_reservoir_refill_node(struct pisa_node *node, int nid)
 		unsigned long flags;
 		bool clean, added;
 
-		meta = __pisa_page_alloc(GFP_KERNEL | __GFP_THISNODE, nid, true, &clean);
+		meta = __pisa_page_alloc(GFP_KERNEL | __GFP_THISNODE, nid, true,
+					 pisa_want_decrypt(), &clean);
 		if (IS_ERR(meta)) {
 			pisa_alloc_backoff(node, false);
 			break;
 		}
 
-		/* init_on_alloc/init_on_free pages are already zeroed. */
+		/* Decrypted and init_on_alloc/init_on_free pages are already zeroed. */
 		if (!clean)
 			memset(page_address(pisa_meta_to_page(meta)), 0, PISA_SIZE);
 
@@ -212,7 +308,7 @@ static void pisa_reservoir_refill_node(struct pisa_node *node, int nid)
 		}
 		spin_unlock_irqrestore(&node->lock, flags);
 		if (!added) {
-			pisa_release_page(meta);
+			__pisa_release_page(meta);
 			break;
 		}
 
@@ -238,7 +334,7 @@ static void pisa_reservoir_trim_node(struct pisa_node *node, unsigned int max)
 		if (!meta)
 			break;
 
-		pisa_release_page(meta);
+		__pisa_release_page(meta);
 		cond_resched();
 	}
 }
@@ -303,8 +399,22 @@ void pisa_schedule_reservoir(void)
 		pisa_schedule_reservoir_node(nid);
 }
 
+/*
+ * CoCo guests: atomic callers only get decrypted pages from the reservoirs, so
+ * fill them before pisa_meta_init() returns instead of waiting for the workers.
+ */
+void pisa_reservoir_prime(void)
+{
+	int nid;
+
+	if (!pisa_want_decrypt())
+		return;
+	for_each_node_state(nid, N_MEMORY)
+		pisa_reservoir_refill_node(&pisa_nodes[nid], nid);
+}
+
 /* Pop one pre-prepared PISA page from node @nid's reservoir under @node->lock. */
-static struct pisa_meta *pisa_reservoir_pop_node(int nid, unsigned int max)
+static struct pisa_meta *pisa_reservoir_pop_node(int nid, unsigned int max, bool decrypt)
 {
 	struct pisa_node *node = &pisa_nodes[nid];
 	struct pisa_meta *meta;
@@ -316,10 +426,12 @@ static struct pisa_meta *pisa_reservoir_pop_node(int nid, unsigned int max)
 
 	spin_lock_irqsave(&node->lock, flags);
 	meta = list_first_entry_or_null(&node->pages, struct pisa_meta, list);
-	if (meta) {
+	if (meta && !!(meta->flags & PISA_DECRYPTED) == decrypt) {
 		list_del_init(&meta->list);
 		WRITE_ONCE(node->nr_pages, node->nr_pages - 1);
 		refill = node->nr_pages <= max / 2;
+	} else {
+		meta = NULL;
 	}
 	spin_unlock_irqrestore(&node->lock, flags);
 
@@ -333,14 +445,14 @@ static struct pisa_meta *pisa_reservoir_pop_node(int nid, unsigned int max)
  * Pop a pre-prepared PISA page from @nid's reservoir (scheduling an async
  * refill when <= half full or empty), or allocate one inline on miss.
  */
-struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean)
+struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool decrypt, bool *clean)
 {
 	bool can_block = gfpflags_allow_blocking(gfp);
 	unsigned int max = READ_ONCE(pisa_reservoir_max);
 	struct pisa_meta *meta;
 
 	if (max) {
-		meta = pisa_reservoir_pop_node(nid, max);
+		meta = pisa_reservoir_pop_node(nid, max, decrypt);
 		if (meta) {
 			*clean = true;
 			return meta;
@@ -352,8 +464,11 @@ struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean)
 		return ERR_PTR(-EAGAIN);
 	if (max)
 		pisa_schedule_reservoir_node(nid);
+	/* Page decryption may sleep; atomic callers must rely on the reservoir. */
+	if (decrypt && !can_block)
+		return ERR_PTR(-EAGAIN);
 
-	meta = __pisa_page_alloc(gfp, nid, can_block, clean);
+	meta = __pisa_page_alloc(gfp, nid, can_block, decrypt, clean);
 	if (IS_ERR(meta))
 		pisa_alloc_backoff(&pisa_nodes[nid], can_block);
 	return meta;
@@ -391,6 +506,14 @@ unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned lon
 
 void __init pisa_node_init(void)
 {
+	/*
+	 * CoCo guests require decrypted pages and cannot decrypt in atomic
+	 * context: those callers rely on the per-node reservoir, which
+	 * pisa_reservoir_max_set() does not let a CoCo guest disable.
+	 */
+	if (pisa_coco_guest())
+		static_branch_enable(&pisa_decrypt_key);
+
 	for (int nid = 0; nid < MAX_NUMNODES; nid++) {
 		spin_lock_init(&pisa_nodes[nid].lock);
 		INIT_LIST_HEAD(&pisa_nodes[nid].pages);
diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
index 08bf1b64bcf2c..865f3d779b84d 100644
--- a/mm/pisa-priv.h
+++ b/mm/pisa-priv.h
@@ -10,6 +10,7 @@
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "pisa."
 #include <linux/jiffies.h>
+#include <linux/mem_encrypt.h>
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
 #include <linux/topology.h>
@@ -204,6 +205,9 @@ static inline void pisa_alloc_backoff(struct pisa_node *node, bool can_block)
 		WRITE_ONCE(node->next_alloc, jiffies + DIV_ROUND_UP(HZ, 100));
 }
 
+bool pisa_want_decrypt(void);
+bool pisa_cc_unsupported(void);
+
 /* pisa-alloc.c, also used by the per-node code in pisa-node.c */
 struct pisa_alloc *pisa_alloc_create(int nid, unsigned int order, enum dma_data_direction dir);
 __printf(2, 3)
@@ -220,6 +224,7 @@ bool pisa_place_meta(struct pisa_meta *meta);
 extern struct llist_head pisa_free_list;
 extern unsigned int pisa_idle_ms;
 void pisa_release_page(struct pisa_meta *meta);
+void __pisa_release_page(struct pisa_meta *meta);
 unsigned long pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp,
 			      unsigned long nr_pages, struct page **page_array, bool frozen);
 
@@ -249,9 +254,10 @@ bool pisa_user_scrub_node(int nid);
 extern unsigned int pisa_reservoir_max;
 void pisa_node_init(void);
 void pisa_schedule_reservoir(void);
+void pisa_reservoir_prime(void);
 void pisa_schedule_scrub(int nid);
 void pisa_schedule_scrub_all(void);
-struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean);
+struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool decrypt, bool *clean);
 unsigned long pisa_reservoir_count(void);
 unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned long nr_to_scan);
 void pisa_user_boot_enable(void);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2d2df53fc51a9..c8952ac306d74 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -17,6 +17,7 @@
 #include <linux/swap.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
+#include <linux/pisa-mm.h>
 #include <linux/namei.h>
 #include <linux/shmem_fs.h>
 #include <linux/blk-cgroup.h>
@@ -2587,7 +2588,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
 	}
-	new_pte = pte_mkold(mk_pte(page, vma->vm_page_prot));
+	new_pte = pte_mkold(mk_pte(page, pisa_pgprot_decrypted(page, vma->vm_page_prot)));
 	if (pte_swp_soft_dirty(old_pte))
 		new_pte = pte_mksoft_dirty(new_pte);
 	if (pte_swp_uffd(old_pte))
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 14fdbf217f00e..200f56bcba069 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/sched/signal.h>
 #include <linux/pagemap.h>
+#include <linux/pisa-mm.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
@@ -341,7 +342,7 @@ static int mfill_atomic_install_pte(pmd_t *dst_pmd,
 	bool page_in_cache = folio_mapping(folio);
 	pte_t dst_ptep;
 
-	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
+	_dst_pte = mk_pte(page, pisa_pgprot_decrypted(page, dst_vma->vm_page_prot));
 	_dst_pte = pte_mkdirty(_dst_pte);
 	if (page_in_cache && !vm_shared)
 		writable = false;
@@ -1303,7 +1304,9 @@ static long move_present_ptes(struct mm_struct *mm,
 		folio_move_anon_rmap(src_folio, dst_vma);
 		src_folio->index = linear_anon_page_index(dst_vma, dst_addr);
 
-		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
+		orig_dst_pte = folio_mk_pte(src_folio,
+					    pisa_pgprot_decrypted(folio_page(src_folio, 0),
+								  dst_vma->vm_page_prot));
 		/* Set soft dirty bit so userspace can notice the pte was moved */
 		if (pgtable_supports_soft_dirty())
 			orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
-- 
2.56.1.809.ga0b61035b5-goog

