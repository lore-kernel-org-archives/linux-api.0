Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136838;
	b=5LkZZZohFal98YhgfQi5fIQiFNtsEx0NHcCIrMWz0QR+JGGLNuEAjXLGv8u3VKhKEGR5
	 dKa2SRk6hNVIwmHsALt/AvlRl0UHNeEqrPzT68geMJe6u5IxWPB2uEE09e2Y86JZNPidt
	 I8uo63o9/pfkexifTEw5GkVA5TamegMFhreWyUNCrXC+005Y/CLGicJLdLLg6qKvY61xM
	 gHTFJ8C3OGKUe40UT9UDp9a4Fw6hpXbAN16VZG5qfR1STyo2If8Pr+B/1/bI0DouPogI4
	 G67HtP0ImzRr3NRSm/XMh5i7kdliojSvo9lpBJ+SB5BWzn+m9CDwRNDQWg7I5WCgrZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136838;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=pY7uast7OOU6AnIkUhhtPtY/1QQKw+j0mOX85z6LMqg=;
	b=ydwXPeL5dvw3rCrFPtMBrQ/reULtIwtxgoJTzdT9mvtReKgmbCENaNFB1HDTvBy8y99M
	 vnROZkicz8UoE1M1Lltew5DnRVtBnN1LNoyb8hJojVp8gET2lN3Nf3UtTb15SQU4Vgt3+
	 OmuyaHfrJAiFixlgq6tRZ30vJE+YrRitv+5NI3nNiN7Gkl4aHzHzacwPfgprr8UPMa4sy
	 Ahdbr1JEGVIT9tR3BKwM+a3wbTWWjezy7rTeszcBFFDMk+ye9jMig0R8jY+iB+Pd/yCnQ
	 hP8tVDJQMob+5NrR17c7z2MWK97BZ71CCTmP4FEQK4MUS3vV2aRoyOCc12z1k3LzYfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Xis2AY3f;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4618F606D55F
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4618F606D55F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Xis2AY3f
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c505f26e9e1so24309066b.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136835; x=1795741635; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pY7uast7OOU6AnIkUhhtPtY/1QQKw+j0mOX85z6LMqg=;
        b=Xis2AY3fTgtXj85N4mZtrysq7IUybbXtbpacWtcYMbJl5mbKX3LHqSIqOgFCWa9WHI
         jAyTjwOnrZ+KAMDKhqyowNwcVnZmlD2gnMEBueS+n54j3HwBc9+6Z6ogiKQ8MhgtZlrV
         k6mxNy2tXq+RjQ/MsY/aD0RFEZOkBBd63G8XH7FVlowk9I9Il0InjIDk9AhgP6qELVr4
         V0kkpGGld1NLvghfVJVLzyuMNASdqO8xjCKlLxJTO3vFVhh+rjUNnsCU0ScvacdPIIa4
         FGFVL9YW96eTOgZUWcjGK8KhfAAFxbNnnV1ONvzU9J7D0iVbFxYtVMkcwVjAtbrGn+yX
         0+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136835; x=1795741635;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pY7uast7OOU6AnIkUhhtPtY/1QQKw+j0mOX85z6LMqg=;
        b=tpHYP+H8rDoZ0xe0nBE5qeLV/RTtuTp+tNtIldATjlrI9Jnt7fI6Xo637Xn4nl+KC1
         cM+Akfr04o10PC+Ijtb2luY3cEK1ob/tWP0EWPhUoqaE+titrMTSkKQWFgc/t8e3e5u5
         85axPzBfiZKqDYbAAAben+e4D8uxbdzxl/hz4QdC9yxuArLVTZd9jSrjTBEnFEG37iUt
         H0auI9XVC1fcFY5NQafu5nQwIEu7dpzF7v7Qq9OrUsGLETsgcsBC6XlhKL9gsIjVzCO/
         5jabcvho+NrDa+aQsXZxj88NGYktVR2mAZXzoWIe0EaI5TA/El2IpgCKCc62gXb+BF4P
         a4AQ==
X-Forwarded-Encrypted: i=1; AL+hErHgTyTeLaUf/h1f7cDqsybhdinghPqrDBO9modW/wrCk9jLn3mhQM81wBUa8bw1XsK20PpCX38FT5k=@vger.kernel.org
X-Gm-Message-State: APuU4Z9SU54u8pog9mFLUbsfRL824kFj9iUDLHidnPdSyaKq1MePKObC
	qfVEBEOReAooD1kcxV13Tknvr7qeWtQOImqEoNBwTUBGjTS5gxl+kE7IjI+p6OIJ6CSnAZ3r/wZ
	h46WBNg==
X-Received: from ejbox7.prod.google.com ([2002:a17:907:1007:b0:c50:5b36:bcd])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:d1da:b0:c4c:a409:5aa3
 with SMTP id a640c23a62f3a-c513a88fad1mr86667566b.17.1795136834157; Thu, 19
 Nov 2026 17:07:14 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:42 +0000
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
Message-ID: <20261120010655.467825-13-lrizzo@google.com>
Subject: [RFC PATCH v3 12/25] block, mm: Support PISA for disk I/O and scrub migration
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

Extend PISA user/page-cache allocators to support O_DIRECT and buffered
disk I/O, gated per block/controller device through pisa_rx_bufs (read)
and pisa_tx_bufs (write):

- Split per-node user_pa into DMA_BIDIRECTIONAL, DMA_TO_DEVICE, and
  DMA_FROM_DEVICE allocators, promoting pages to DMA_BIDIRECTIONAL if
  later accessed in the opposite direction.
- Upgrade pinned O_DIRECT user pages in bio_iov_iter_get_pages(), and
  allocate/promote order-0 page-cache folios for buffered I/O when PISA
  is enabled on the target block device.
- Add pisa.scrub_migrate to compact or demote lingering folios off old,
  sparse user_pa 2MB pages.

Assisted-by: gemini:2.5-pro
Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 block/bio.c             |   9 +
 include/linux/pisa-mm.h |  76 ++++++
 include/linux/pisa.h    |   7 +-
 mm/filemap.c            |  12 +-
 mm/page-writeback.c     |   9 +
 mm/pisa-alloc.c         |  18 +-
 mm/pisa-meta.c          |  15 +-
 mm/pisa-node.c          |  10 +-
 mm/pisa-priv.h          |   9 +-
 mm/pisa-user.c          | 523 ++++++++++++++++++++++++++++++++++++----
 mm/readahead.c          |   3 +-
 11 files changed, 635 insertions(+), 56 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b0fcc69de6535..ad8632661dddf 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -6,6 +6,7 @@
 #include <linux/swap.h>
 #include <linux/bio-integrity.h>
 #include <linux/blkdev.h>
+#include <linux/pisa-mm.h>
 #include <linux/uio.h>
 #include <linux/iocontext.h>
 #include <linux/slab.h>
@@ -1346,6 +1347,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 {
 	iov_iter_extraction_t flags = 0;
 	struct iov_iter saved_iter;
+	bool migrated = false;
 	int ret;
 
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
@@ -1368,6 +1370,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 		flags |= ITER_ALLOW_P2PDMA;
 
 	saved_iter = *iter;
+retry:
 	do {
 		ssize_t size;
 
@@ -1386,6 +1389,12 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 		bio->bi_iter.bi_size += size;
 	} while (iov_iter_count(iter) && !bio_full(bio, 0));
 
+	/* Migrate suitable pages to PISA, re-extract if so. */
+	if (!migrated && pisa_bio_migrate_pages(bio, iter)) {
+		migrated = true;
+		goto retry;
+	}
+
 	if (is_pci_p2pdma_page(bio->bi_io_vec->bv_page))
 		bio->bi_opf |= REQ_NOMERGE;
 	ret = bio_iov_iter_align_down(bio, iter, len_align_mask);
diff --git a/include/linux/pisa-mm.h b/include/linux/pisa-mm.h
index 1e82e081b4004..8caa2afded6ff 100644
--- a/include/linux/pisa-mm.h
+++ b/include/linux/pisa-mm.h
@@ -3,14 +3,29 @@
 #ifndef _LINUX_PISA_MM_H
 #define _LINUX_PISA_MM_H
 
+#include <linux/bio.h>
 #include <linux/pisa.h>
 
+struct address_space;
+struct folio_batch;
+
 #ifdef CONFIG_PISA
 
 unsigned long __pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order,
 				      int preferred_nid, int nr_pages,
 				      struct page **page_array, bool frozen);
 bool __pisa_free_page(struct page *page, unsigned int order);
+bool __pisa_bio_migrate_pages(struct bio *bio, struct iov_iter *iter,
+			      enum dma_data_direction dir);
+bool pisa_bdev_enabled(const struct block_device *bdev,
+		       enum dma_data_direction dir);
+struct folio *__pisa_filemap_alloc(const struct address_space *mapping,
+				   gfp_t gfp);
+bool __pisa_filemap_upgrade(const struct address_space *mapping,
+			    struct folio *folio);
+bool __pisa_writeback_upgrade(const struct address_space *mapping,
+			      struct folio *folio, pgoff_t *index,
+			      struct folio_batch *fbatch);
 int pisa_madvise(struct vm_area_struct *vma, unsigned long start,
 		 unsigned long end, bool to_pisa);
 
@@ -57,6 +72,46 @@ static inline bool pisa_free_page(struct page *page, unsigned int order)
 	return is_pisa_page(page) && __pisa_free_page(page, order);
 }
 
+/*
+ * Hook for bio_iov_iter_get_pages() O_DIRECT migration (@pisa_user_key).
+ * Returns false if @bio and @iter were left untouched; returns true if the
+ * pages were unpinned, migrated to PISA, and @iter rewound for re-extraction.
+ */
+static inline bool pisa_bio_migrate_pages(struct bio *bio, struct iov_iter *iter)
+{
+	enum dma_data_direction dir;
+
+	if (!pisa_user_enabled() || !bio->bi_iter.bi_size ||
+	    !bio_flagged(bio, BIO_PAGE_PINNED))
+		return false;
+	dir = op_is_write(bio_op(bio)) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	return pisa_bdev_enabled(bio->bi_bdev, dir) &&
+	       __pisa_bio_migrate_pages(bio, iter, dir);
+}
+
+/* Hook for __filemap_get_folio_mpol() and ractl_alloc_folio() (@pisa_user_key). */
+#define pisa_filemap_alloc_folio(gfp, order, policy, mapping)		\
+	((pisa_user_enabled() && !(order) ?				\
+	  __pisa_filemap_alloc(mapping, gfp) : NULL) ?:			\
+	 filemap_alloc_folio(gfp, order, policy))
+
+/* Hook for __filemap_get_folio_mpol() existing folio upgrade (@pisa_user_key). */
+static inline bool pisa_filemap_upgrade(const struct address_space *mapping,
+					struct folio *folio, bool write_wait)
+{
+	return pisa_user_enabled() && write_wait &&
+	       __pisa_filemap_upgrade(mapping, folio);
+}
+
+/* Hook for writeback_get_folio() upgrade (guarded by @pisa_user_key). */
+static inline bool pisa_writeback_upgrade(const struct address_space *mapping,
+					  struct folio *folio, pgoff_t *index,
+					  struct folio_batch *fbatch)
+{
+	return pisa_user_enabled() &&
+	       __pisa_writeback_upgrade(mapping, folio, index, fbatch);
+}
+
 #else /* !CONFIG_PISA */
 
 static inline unsigned long
@@ -79,6 +134,27 @@ static inline bool pisa_free_page(struct page *page, unsigned int order)
 	return false;
 }
 
+static inline bool pisa_bio_migrate_pages(struct bio *bio, struct iov_iter *iter)
+{
+	return false;
+}
+
+#define pisa_filemap_alloc_folio(gfp, order, policy, mapping)		\
+	filemap_alloc_folio(gfp, order, policy)
+
+static inline bool pisa_filemap_upgrade(const struct address_space *mapping,
+					struct folio *folio, bool write_wait)
+{
+	return false;
+}
+
+static inline bool pisa_writeback_upgrade(const struct address_space *mapping,
+					  struct folio *folio, pgoff_t *index,
+					  struct folio_batch *fbatch)
+{
+	return false;
+}
+
 static inline int pisa_madvise(struct vm_area_struct *vma, unsigned long start,
 			       unsigned long end, bool to_pisa)
 {
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 9321e7ff00042..6d184e393e297 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -93,7 +93,8 @@ void *__pisa_alloc_map_coherent_dev(struct device *dev, size_t size,
 bool __pisa_has_free_blocks_rx(unsigned int order, int nid);
 bool __pisa_page_can_recycle(const struct page *page);
 bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
-			     size_t size, size_t offset);
+			     size_t size, size_t offset,
+			     enum dma_data_direction dir, bool pinned);
 
 static inline bool pisa_enabled(void)
 {
@@ -241,7 +242,9 @@ static inline bool pisa_page_can_recycle(const struct page *page)
 
 static inline bool pisa_upgrade_user_pages(struct iov_iter *iter,
 					   struct page **pages, size_t size,
-					   size_t offset)
+					   size_t offset,
+					   enum dma_data_direction dir,
+					   bool pinned)
 {
 	return false;
 }
diff --git a/mm/filemap.c b/mm/filemap.c
index f9e34144c53c7..7d870c22abe53 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -15,6 +15,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/sched/signal.h>
+#include <linux/pisa-mm.h>
 #include <linux/uaccess.h>
 #include <linux/capability.h>
 #include <linux/kernel_stat.h>
@@ -1976,6 +1977,7 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 		pgoff_t index, fgf_t fgp_flags, gfp_t gfp, struct mempolicy *policy)
 {
+	bool tried_pisa = false;
 	struct folio *folio;
 
 repeat:
@@ -1985,6 +1987,13 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		goto no_page;
 
+	if (!tried_pisa) {
+		tried_pisa = true;
+		if (pisa_filemap_upgrade(mapping, folio,
+					 (fgp_flags & (FGP_WRITE | FGP_NOWAIT)) == FGP_WRITE))
+			goto repeat;
+	}
+
 	if (fgp_flags & FGP_LOCK) {
 		if (fgp_flags & FGP_NOWAIT) {
 			if (!folio_trylock(folio)) {
@@ -2044,7 +2053,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			err = -ENOMEM;
 			if (order > min_order)
 				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
-			folio = filemap_alloc_folio(alloc_gfp, order, policy);
+			folio = pisa_filemap_alloc_folio(alloc_gfp, order,
+							 policy, mapping);
 			if (!folio)
 				continue;
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0694ec4098f6d..5f1327c22c0e4 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -37,6 +37,7 @@
 #include <linux/sched/rt.h>
 #include <linux/sched/signal.h>
 #include <linux/mm_inline.h>
+#include <linux/pisa-mm.h>
 #include <linux/shmem_fs.h>
 #include <trace/events/writeback.h>
 
@@ -2409,6 +2410,7 @@ static pgoff_t wbc_end(struct writeback_control *wbc)
 static struct folio *writeback_get_folio(struct address_space *mapping,
 		struct writeback_control *wbc)
 {
+	bool tried_pisa = false;
 	struct folio *folio;
 
 retry:
@@ -2423,6 +2425,13 @@ static struct folio *writeback_get_folio(struct address_space *mapping,
 			return NULL;
 	}
 
+	if (!tried_pisa &&
+	    pisa_writeback_upgrade(mapping, folio, &wbc->index, &wbc->fbatch)) {
+		tried_pisa = true;
+		goto retry;
+	}
+	tried_pisa = false;
+
 	folio_lock(folio);
 	if (unlikely(!folio_prepare_writeback(mapping, wbc, folio))) {
 		folio_unlock(folio);
diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
index 2213a56de1242..8c4c0f1f1cf50 100644
--- a/mm/pisa-alloc.c
+++ b/mm/pisa-alloc.c
@@ -574,6 +574,20 @@ static unsigned int pisa_pcp_pop(struct pisa_alloc *pa, unsigned int nr, struct
 	return got;
 }
 
+/* Free blocks in the per-CPU caches of @pa, which @pa->blocks_in_use counts as in use. */
+unsigned long pisa_pcp_cached(struct pisa_alloc *pa)
+{
+	unsigned long n = 0;
+	int cpu;
+
+	/* Pairs with smp_store_release() in pisa_enable_pcp(). */
+	if (!smp_load_acquire(&pa->pcp))
+		return 0;
+	for_each_possible_cpu(cpu)
+		n += READ_ONCE(per_cpu_ptr(pa->pcp, cpu)->count);
+	return n;
+}
+
 /* Return the blocks @cpu caches for @pa. */
 static void pisa_pcp_drain_cpu(struct pisa_alloc *pa, int cpu)
 {
@@ -1316,7 +1330,9 @@ bool __pisa_free_page(struct page *page, unsigned int order)
 			pisa_pcp_push(pa, 1, &page);
 			return true;
 		}
-		pisa_pcp_drain_cpu(pa, raw_smp_processor_id());
+		/* A compaction target drains the caches once, when it is done. */
+		if (!(READ_ONCE(meta->on_list) & PISA_LIST_HOLD))
+			pisa_pcp_drain_cpu(pa, raw_smp_processor_id());
 	}
 
 	spin_lock_irqsave(&pa->lock, flags);
diff --git a/mm/pisa-meta.c b/mm/pisa-meta.c
index 49fa5271a392f..25d3add7a4891 100644
--- a/mm/pisa-meta.c
+++ b/mm/pisa-meta.c
@@ -85,8 +85,8 @@ DEFINE_STATIC_KEY_FALSE(pisa_key);
 EXPORT_SYMBOL(pisa_key);
 
 static unsigned int pisa_compact __read_mostly;
-static unsigned int pisa_target_usage_percent __read_mostly;
-static unsigned int pisa_old_ms __read_mostly;
+unsigned int pisa_target_usage_percent __read_mostly;
+unsigned int pisa_old_ms __read_mostly;
 
 /* Enabled when pisa.compact > 0 or pisa.target_usage_percent > 0. */
 DEFINE_STATIC_KEY_FALSE(pisa_recycle_check_key);
@@ -189,6 +189,10 @@ bool pisa_place_meta(struct pisa_meta *meta)
 
 	lockdep_assert_held(&pa->lock);
 
+	/* A compaction target stays parked until pisa_user_scrub_alloc() is done. */
+	if (meta->on_list & PISA_LIST_HOLD)
+		return false;
+
 	if (avail == bpp) {
 		/* All blocks free: retire immediately if quarantined or over idle cap with idle_ms == 0. */
 		if (pa->num_idle_pages >= pa->max_idle_pages)
@@ -283,6 +287,10 @@ static bool pisa_meta_can_recycle(struct pisa_meta *meta)
 	if (unlikely(READ_ONCE(meta->flags) & PISA_QUARANTINED))
 		return false;
 
+	/* Blocks freed from a compaction target go back to it, not to a cache. */
+	if (READ_ONCE(meta->on_list) & PISA_LIST_HOLD)
+		return false;
+
 	if (!(READ_ONCE(meta->on_list) & PISA_LIST_SPARSE))
 		return true;
 
@@ -317,6 +325,9 @@ static bool pisa_meta_can_recycle(struct pisa_meta *meta)
 	}
 
 	WRITE_ONCE(meta->drain, true);
+	/* Let scrub migration move out what the callers still hold on @meta. */
+	if (READ_ONCE(pisa_scrub_migrate))
+		pisa_schedule_scrub(pa->nid);
 	return false;
 }
 
diff --git a/mm/pisa-node.c b/mm/pisa-node.c
index c013e384b1c7e..8d6fa9f36bdcf 100644
--- a/mm/pisa-node.c
+++ b/mm/pisa-node.c
@@ -248,7 +248,7 @@ void pisa_schedule_scrub(int nid)
 {
 	struct pisa_node *node;
 
-	if (!READ_ONCE(pisa_scrub_max))
+	if (!READ_ONCE(pisa_scrub_max) && !READ_ONCE(pisa_scrub_migrate))
 		return;
 
 	node = &pisa_nodes[nid];
@@ -277,8 +277,12 @@ static void pisa_node_work_fn(struct work_struct *work)
 	if (pisa_enabled() && READ_ONCE(pisa_reservoir_max))
 		pisa_reservoir_refill_node(node, nid);
 
-	if (test_and_clear_bit(PISA_NODE_SCRUB, &node->flags) && pisa_scrub_node(nid))
-		pisa_schedule_scrub(nid);
+	if (test_and_clear_bit(PISA_NODE_SCRUB, &node->flags)) {
+		bool more = pisa_scrub_node(nid);
+
+		if (pisa_user_scrub_node(nid) || more)
+			pisa_schedule_scrub(nid);
+	}
 }
 
 /* Queue node @nid's work if its reservoir is below or above the target. */
diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
index b18d461198ac5..c7f4e30579070 100644
--- a/mm/pisa-priv.h
+++ b/mm/pisa-priv.h
@@ -55,6 +55,7 @@ enum {
 	PISA_LIST_DIRTY		= BIT(3),	/* on @pa->partial_dirty */
 	PISA_LIST_MASK		= 0xf,
 	PISA_LIST_SPARSE	= BIT(4),	/* tail: list_move_tail() */
+	PISA_LIST_HOLD		= BIT(5),	/* parked on @pa->full by compaction */
 };
 
 /* Publish meta->flags into the pfn2slot array. */
@@ -133,10 +134,11 @@ static inline long pisa_alloc_held_pages(const struct pisa_alloc *pa)
 struct pisa_node {
 	unsigned long		next_alloc;	/* atomic alloc backoff jiffies */
 	struct pisa_alloc	*pa[2][PISA_MAX_ALLOC_ORDER + 1]; /* [0]=RW, [1]=RO */
-	struct pisa_alloc	*user_pa;	/* user page migration pa */
+	struct pisa_alloc	*user_pa[3];	/* user/page-cache allocators by dir */
 
 	spinlock_t		lock;		/* protects @pages and @nr_pages */
 	unsigned int		nr_pages;	/* entries in @pages */
+	unsigned int		scrub_dir;	/* round-robin user_pa scrub index */
 	struct list_head	pages;		/* reservoir */
 	unsigned long		flags;		/* PISA_NODE_* requests */
 	struct work_struct	work;		/* refill/trim/scrub, on this node */
@@ -212,6 +214,7 @@ struct pisa_alloc *pisa_alloc_ensure(struct pisa_alloc **pap, int nid,
 #define PISA_PCP_HIGH		64U	/* blocks cached per CPU at most */
 int pisa_enable_pcp(struct pisa_alloc *pa);
 void pisa_pcp_drain(struct pisa_alloc *pa);
+unsigned long pisa_pcp_cached(struct pisa_alloc *pa);
 bool pisa_place_meta(struct pisa_meta *meta);
 extern struct llist_head pisa_free_list;
 extern unsigned int pisa_idle_ms;
@@ -229,6 +232,9 @@ static inline struct page *pisa_alloc(struct pisa_alloc *pa, gfp_t gfp)
 }
 
 #define PISA_OLD_MS_MAX		100000U
+extern unsigned int pisa_target_usage_percent;
+extern unsigned int pisa_old_ms;
+extern unsigned int pisa_scrub_migrate;
 unsigned long pisa_shrink_list(spinlock_t *lock, struct list_head *list,
 			       unsigned int *nr, struct list_head *release_list,
 			       unsigned long nr_to_scan);
@@ -236,6 +242,7 @@ unsigned long pisa_shrink_list(spinlock_t *lock, struct list_head *list,
 #define PISA_SCRUB_RUN_NS	(50 * NSEC_PER_USEC)
 extern unsigned int pisa_scrub_max;
 bool pisa_scrub_node(int nid);
+bool pisa_user_scrub_node(int nid);
 
 /* pisa-node.c: per-NUMA-node PISA page reservoir and work item */
 extern unsigned int pisa_reservoir_max;
diff --git a/mm/pisa-user.c b/mm/pisa-user.c
index 6c3efaee4ecda..5fb1ec7c45204 100644
--- a/mm/pisa-user.c
+++ b/mm/pisa-user.c
@@ -3,14 +3,22 @@
  * PISA user and page-cache folios: allocate or migrate order-0 folios into
  * per-node PISA allocators so zero-copy TX and block I/O use the PISA IOMMU mappings.
  */
+#include <linux/blkdev.h>
+#include <linux/device.h>
 #include <linux/pisa.h>
+#include <linux/fs.h>
 #include <linux/gfp.h>
 #include <linux/huge_mm.h>
+#include <linux/iommu.h>
+#include <linux/jiffies.h>
 #include <linux/migrate.h>
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/nodemask.h>
+#include <linux/pagemap.h>
 #include <linux/pagewalk.h>
+#include <linux/folio_batch.h>
+#include <linux/sched/clock.h>
 #include <linux/swap.h>
 #include <linux/uio.h>
 
@@ -20,9 +28,31 @@
 static unsigned long pisa_user_max_pages __read_mostly;
 DEFINE_STATIC_KEY_FALSE(pisa_user_key);
 
+/*
+ * Scrub-time migration of old sparse user_pa PISA pages when usage is below
+ * pisa.target_usage_percent (0 = off, 1 = compact in allocator, 2 = demote to the buddy allocator).
+ */
+unsigned int pisa_scrub_migrate __read_mostly;
+
+static int pisa_scrub_migrate_set(const char *val, const struct kernel_param *kp)
+{
+	int ret = param_set_uint_minmax(val, kp, 0, 2);
+
+	if (pisa_enabled() && !ret && pisa_scrub_migrate)
+		pisa_schedule_scrub_all();
+	return ret;
+}
+
+static const struct kernel_param_ops pisa_scrub_migrate_ops = {
+	.set = pisa_scrub_migrate_set,
+	.get = param_get_uint,
+};
+module_param_cb(scrub_migrate, &pisa_scrub_migrate_ops, &pisa_scrub_migrate, 0644);
+
 /* Create per-node user allocators and enable pisa_user_key (serialized by param_lock/init). */
 static int pisa_user_init(void)
 {
+	static const char * const dir_names[3] = { "bi", "tx", "rx" };
 	int nid;
 
 	if (pisa_user_enabled())
@@ -30,9 +60,11 @@ static int pisa_user_init(void)
 	if (pisa_meta_init())
 		return -ENOMEM;
 	for_each_node_state(nid, N_MEMORY) {
-		if (!pisa_alloc_ensure(&pisa_nodes[nid].user_pa, nid, 0,
-				       DMA_TO_DEVICE, false, "user_tx_n%d", nid))
-			return -ENOMEM;
+		for (unsigned int dir = 0; dir < ARRAY_SIZE(pisa_nodes[nid].user_pa); dir++) {
+			if (!pisa_alloc_ensure(&pisa_nodes[nid].user_pa[dir], nid, 0,
+					       dir, true, "user_%s_n%d", dir_names[dir], nid))
+				return -ENOMEM;
+		}
 	}
 	static_branch_enable(&pisa_user_key);
 	return 0;
@@ -73,16 +105,25 @@ void __init pisa_user_boot_enable(void)
 }
 
 /* User pages currently held in PISA blocks. */
-static unsigned long pisa_user_in_use(void)
+/* Blocks in use; @exact leaves out the free ones held in per-CPU caches (slower). */
+static unsigned long pisa_user_in_use(bool exact)
 {
-	unsigned long used = 0;
+	unsigned long used = 0, n;
 	int nid;
 
 	for_each_node_state(nid, N_MEMORY) {
-		/* Pairs with smp_store_release() in pisa_user_init(). */
-		const struct pisa_alloc *pa = smp_load_acquire(&pisa_nodes[nid].user_pa);
-
-		used += pa ? READ_ONCE(pa->blocks_in_use) : 0;
+		for (unsigned int dir = 0; dir < ARRAY_SIZE(pisa_nodes[nid].user_pa); dir++) {
+			struct pisa_alloc *pa;
+
+			/* Pairs with smp_store_release() in pisa_user_init(). */
+			pa = smp_load_acquire(&pisa_nodes[nid].user_pa[dir]);
+			if (!pa)
+				continue;
+			n = READ_ONCE(pa->blocks_in_use);
+			if (exact)
+				n -= min(n, pisa_pcp_cached(pa));
+			used += n;
+		}
 	}
 	return used;
 }
@@ -90,18 +131,59 @@ static unsigned long pisa_user_in_use(void)
 /* Pages that can still be moved in before reaching pisa.user_max_pages. */
 static long pisa_user_budget(void)
 {
-	return (long)((READ_ONCE(pisa_user_max_pages) << PISA_ORDER) - pisa_user_in_use());
+	unsigned long max = READ_ONCE(pisa_user_max_pages) << PISA_ORDER;
+	long budget = (long)(max - pisa_user_in_use(false));
+
+	/* Free blocks in per-CPU caches count as in use: recount before refusing. */
+	if (budget <= 0)
+		budget = (long)(max - pisa_user_in_use(true));
+	return budget;
 }
 
-/* Is @folio worth moving into (@to_pisa) or out of PISA memory? */
-static bool pisa_user_want(struct folio *folio, bool to_pisa)
+/*
+ * Return true if @folio should be migrated into (@to_pisa) or out of PISA
+ * memory, promoting existing PISA folios to DMA_BIDIRECTIONAL when needed.
+ */
+static bool pisa_user_want_dir(struct folio *folio, bool to_pisa,
+			       enum dma_data_direction dir, bool allow_file)
 {
-	if (!folio_test_anon(folio) || folio_is_zone_device(folio) ||
-	    folio_test_ksm(folio) || is_huge_zero_folio(folio) ||
-	    (folio_test_large(folio) && !to_pisa) ||
-	    folio_maybe_mapped_shared(folio))
+	unsigned long pfn = folio_pfn(folio);
+
+	if (is_zero_folio(folio) || folio_is_zone_device(folio) ||
+	    folio_test_ksm(folio) || is_huge_zero_folio(folio))
+		return false;
+	if (folio_test_large(folio) && (!to_pisa || !folio_test_anon(folio)))
 		return false;
-	return is_pisa_pfn(folio_pfn(folio)) != to_pisa;
+	if (folio_test_anon(folio)) {
+		if (folio_maybe_mapped_shared(folio))
+			return false;
+	} else if (!allow_file || !folio_mapping(folio) ||
+		   folio_test_locked(folio) || folio_test_writeback(folio)) {
+		return false;
+	}
+
+	if (!to_pisa)
+		return is_pisa_pfn(pfn);
+	if (!is_pisa_pfn(pfn)) {
+		struct address_space *mapping;
+		bool movable;
+
+		if (folio_test_anon(folio))
+			return true;
+		/* Only file folios whose mapping allows movable pages. */
+		rcu_read_lock();
+		mapping = folio_mapping(folio);
+		movable = mapping && (mapping_gfp_mask(mapping) & __GFP_MOVABLE);
+		rcu_read_unlock();
+		return movable;
+	}
+
+	if (dir == DMA_TO_DEVICE || dir == DMA_FROM_DEVICE) {
+		int need = (dir == DMA_FROM_DEVICE) ? IOMMU_WRITE : IOMMU_READ;
+
+		return (READ_ONCE(pisa_meta_of_pfn(pfn)->prot) & need) != need;
+	}
+	return false;
 }
 
 /* Return true if @folio has references beyond its mappings, swap cache, and @extra. */
@@ -110,24 +192,46 @@ static bool pisa_user_busy(struct folio *folio, int extra)
 	return folio_ref_count(folio) > folio_expected_ref_count(folio) + extra;
 }
 
+/*
+ * Return true if @folio has references or pins beyond its mappings, swap
+ * cache, and the @refs entries in the caller's GUP batch.
+ */
+static bool pisa_user_batch_busy(struct folio *folio, int refs, bool pinned)
+{
+	int extra = (pinned && !folio_has_pincount(folio)) ?
+		    refs * GUP_PIN_COUNTING_BIAS : refs;
+
+	if (folio_has_pincount(folio) &&
+	    atomic_read(&folio->_pincount) > (pinned ? refs : 0))
+		return true;
+	return pisa_user_busy(folio, extra);
+}
+
 struct pisa_user_mtc {
-	gfp_t	gfp;
-	long	budget;
+	gfp_t			gfp;
+	long			budget;
+	enum dma_data_direction	dir;
+	bool			same_alloc;
 };
 
 /* new_folio_t for migration into PISA memory. */
 static struct folio *pisa_user_new_folio(struct folio *src, unsigned long private)
 {
 	struct pisa_user_mtc *mtc = (void *)private;
+	bool already_pisa = is_pisa_pfn(folio_pfn(src));
+	enum dma_data_direction dir = mtc->dir;
 	int nid = folio_nid(src);
 	struct page *page;
 
 	/* Callers split large folios first (see pisa_user_split()); none is expected here. */
-	if (mtc->budget <= 0 || folio_test_large(src))
+	if ((!already_pisa && mtc->budget <= 0) || folio_test_large(src))
 		return NULL;
-	page = pisa_alloc(pisa_nodes[nid].user_pa, mtc->gfp);
+	if (already_pisa && !mtc->same_alloc)
+		dir = DMA_BIDIRECTIONAL;
+	page = pisa_alloc(pisa_nodes[nid].user_pa[dir], mtc->gfp);
 	if (!page)
 		return NULL;
+	/* Charged for every destination, so that pisa_user_put_folio() can undo it. */
 	mtc->budget--;
 	return page_folio(page);
 }
@@ -144,17 +248,31 @@ static void pisa_user_put_folio(struct folio *dst, unsigned long private)
 /* new_folio_t for migration out of PISA memory: allocators never serve these. */
 static struct folio *pisa_user_old_folio(struct folio *src, unsigned long private)
 {
-	return __folio_alloc_node(GFP_HIGHUSER_MOVABLE | __GFP_NOWARN, 0, folio_nid(src));
+	struct address_space *mapping = folio_mapping(src);
+	gfp_t gfp = GFP_HIGHUSER_MOVABLE;
+
+	/* A file folio goes back to memory that its mapping allows. */
+	if (!folio_test_anon(src) && mapping)
+		gfp = mapping_gfp_constraint(mapping, gfp);
+	return __folio_alloc_node(gfp | __GFP_NOWARN, 0, folio_nid(src));
 }
 
 /* Migrate the isolated folios on @list; failures are put back. */
-static void pisa_user_migrate(struct list_head *list, bool to_pisa, gfp_t gfp)
+static unsigned int pisa_user_migrate_dir(struct list_head *list, bool to_pisa,
+					  enum dma_data_direction dir,
+					  bool same_alloc, gfp_t gfp)
 {
-	struct pisa_user_mtc mtc = { .gfp = gfp, .budget = LONG_MAX };
+	struct pisa_user_mtc mtc = {
+		.gfp = gfp,
+		.budget = LONG_MAX,
+		.dir = dir,
+		.same_alloc = same_alloc,
+	};
 	enum migrate_mode mode = MIGRATE_SYNC;
+	unsigned int done = 0;
 
 	if (list_empty(list))
-		return;
+		return 0;
 	if (to_pisa) {
 		mtc.budget = pisa_user_budget();
 		if (!gfpflags_allow_blocking(gfp))
@@ -162,8 +280,9 @@ static void pisa_user_migrate(struct list_head *list, bool to_pisa, gfp_t gfp)
 	}
 	if (migrate_pages(list, to_pisa ? pisa_user_new_folio : pisa_user_old_folio,
 			  to_pisa ? pisa_user_put_folio : NULL, (unsigned long)&mtc,
-			  mode, MR_SYSCALL, NULL))
+			  mode, MR_SYSCALL, &done))
 		putback_movable_pages(list);
+	return done;
 }
 
 /*
@@ -221,22 +340,25 @@ static unsigned int pisa_user_split_isolated(struct folio *folio, struct list_he
 }
 
 /**
- * pisa_upgrade_user_pages - Migrate extracted user @pages into PISA
+ * pisa_upgrade_user_pages - Migrate extracted user @pages into PISA for @dir
  * @iter: Iterator from which @pages were just extracted
- * @pages: Extracted page array, one reference each
+ * @pages: Extracted page array
  * @size: Number of bytes extracted from @iter
  * @offset: Byte offset within @pages[0]
+ * @dir: I/O direction (DMA_TO_DEVICE or DMA_FROM_DEVICE)
+ * @pinned: true if @pages are FOLL_PIN-pinned, false if refcounted (+1)
  *
  * Return: false if no pages were isolated (@pages and @iter are untouched);
  * true otherwise, so the caller must re-extract @pages from the reverted @iter.
  */
 bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
-			     size_t size, size_t offset)
+			     size_t size, size_t offset,
+			     enum dma_data_direction dir, bool pinned)
 {
 	unsigned int nr = DIV_ROUND_UP(offset + size, PAGE_SIZE);
-	unsigned int want = 0;
+	unsigned int want = 0, need_budget = 0;
 	struct folio *f, *next;
-	bool drained = false;
+	bool drained = false, no_budget = false;
 	LIST_HEAD(small);
 	LIST_HEAD(list);
 	long budget;
@@ -247,15 +369,29 @@ bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 	 * First pass: check if any page needs migration and whether budget is
 	 * available before draining per-CPU LRU caches or isolating folios.
 	 */
-	for (unsigned int i = 0; i < nr; i++)
-		want += pisa_user_want(page_folio(pages[i]), true);
-	if (!want || pisa_user_budget() <= 0)
+	for (unsigned int i = 0; i < nr; i++) {
+		struct folio *folio = page_folio(pages[i]);
+
+		if (pisa_user_want_dir(folio, true, dir, false)) {
+			want++;
+			need_budget += !is_pisa_pfn(folio_pfn(folio));
+		}
+	}
+	if (!want)
 		return false;
+	if (need_budget && pisa_user_budget() <= 0) {
+		if (want == need_budget)
+			return false;
+		no_budget = true;
+	}
 	for (unsigned int i = 0; i < nr; i++) {
 		struct folio *folio = page_folio(pages[i]);
 		unsigned int refs = 0;
 
-		if (!pisa_user_want(folio, true))
+		if (!pisa_user_want_dir(folio, true, dir, false))
+			continue;
+		/* Out of budget: only PISA folios that need another direction. */
+		if (no_budget && !is_pisa_pfn(folio_pfn(folio)))
 			continue;
 		/* Drain per-CPU LRU batches once so freshly faulted folios can be isolated. */
 		if (!drained && !folio_test_lru(folio)) {
@@ -266,8 +402,7 @@ bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 			continue;
 		for (unsigned int j = 0; j < nr; j++)
 			refs += page_folio(pages[j]) == folio;
-		/* The references from iov_iter_get_pages2() are expected. */
-		if (folio_maybe_dma_pinned(folio) || pisa_user_busy(folio, refs))
+		if (pisa_user_batch_busy(folio, refs, pinned))
 			continue;
 		if (isolate_folio_to_list(folio, &list))
 			list_move_tail(&folio->lru, &list);
@@ -275,11 +410,15 @@ bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 	if (list_empty(&list))
 		return false;
 	/*
-	 * Release the caller's references on @pages before migrating
+	 * Release the caller's references/pins on @pages before migrating
 	 * (migrate_pages() rejects folios with extra references).
 	 */
-	for (unsigned int i = 0; i < nr; i++)
-		put_page(pages[i]);
+	if (pinned) {
+		unpin_user_pages(pages, nr);
+	} else {
+		for (unsigned int i = 0; i < nr; i++)
+			put_page(pages[i]);
+	}
 	/*
 	 * Split large folios while budget remains and keep only their subpages
 	 * that are in @pages: migrate_pages() would split them regardless of
@@ -293,15 +432,307 @@ bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 			budget -= !is_pisa_pfn(folio_pfn(f));
 	}
 	list_splice_tail(&small, &list);
-	pisa_user_migrate(&list, true,
-			  GFP_NOWAIT | __GFP_HARDWALL | __GFP_NOWARN);
+	pisa_user_migrate_dir(&list, true, dir, false,
+			      GFP_NOWAIT | __GFP_HARDWALL | __GFP_NOWARN);
 	/* Rewind @iter so the caller re-extracts the updated page pointers. */
 	iov_iter_revert(iter, size);
 	return true;
 }
 
+/* Migrate the single-page segments already added to @bio; the caller then extracts them again. */
+bool __pisa_bio_migrate_pages(struct bio *bio, struct iov_iter *iter,
+			      enum dma_data_direction dir)
+{
+	ssize_t size = bio->bi_iter.bi_size;
+	struct page *bv_pages[64];
+
+	if (!bio->bi_vcnt || bio->bi_vcnt > ARRAY_SIZE(bv_pages))
+		return false;
+	for (unsigned int i = 0; i < bio->bi_vcnt; i++) {
+		const struct bio_vec *bv = &bio->bi_io_vec[i];
+
+		/* Only segments that lie within one page. */
+		if ((bv->bv_offset + bv->bv_len - 1) / PAGE_SIZE != bv->bv_offset / PAGE_SIZE)
+			return false;
+		bv_pages[i] = bv->bv_page;
+	}
+	if (!pisa_upgrade_user_pages(iter, bv_pages, size,
+				     (size_t)bio->bi_vcnt * PAGE_SIZE - size,
+				     dir, true))
+		return false;
+	bio->bi_vcnt = 0;
+	bio->bi_iter.bi_size = 0;
+	return true;
+}
+
+/*
+ * Return true if @bdev (or one of its parent devices) has opted into PISA for
+ * @dir (pisa_rx_bufs for reads, pisa_tx_bufs for writes).
+ */
+bool pisa_bdev_enabled(const struct block_device *bdev,
+		       enum dma_data_direction dir)
+{
+	if (!bdev || !bdev->bd_disk)
+		return false;
+	for (struct device *dev = disk_to_dev(bdev->bd_disk); dev; dev = dev->parent) {
+		if (dir == DMA_FROM_DEVICE ?
+		    READ_ONCE(dev->pisa_rx_bufs) :
+		    READ_ONCE(dev->pisa_tx_bufs))
+			return true;
+	}
+	return false;
+}
+
+static bool pisa_mapping_enabled(const struct address_space *mapping,
+				 enum dma_data_direction dir)
+{
+	struct super_block *sb;
+
+	if (!mapping || !mapping->host || !mapping->host->i_sb)
+		return false;
+	sb = mapping->host->i_sb;
+	return pisa_bdev_enabled(sb_is_blkdev_sb(sb) ?
+				 I_BDEV(mapping->host) : sb->s_bdev, dir);
+}
+
+/**
+ * __pisa_filemap_alloc - Allocate an order-0 page-cache folio from a PISA user allocator
+ * @mapping: Page-cache address_space
+ * @gfp: GFP flags (__GFP_WRITE indicates buffered write path)
+ *
+ * Return: Newly allocated order-0 folio, or NULL on failure.
+ */
+struct folio *__pisa_filemap_alloc(const struct address_space *mapping,
+				   gfp_t gfp)
+{
+	bool is_write = gfp & __GFP_WRITE;
+	enum dma_data_direction dir = is_write ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	struct page *page;
+	int nid;
+
+	/* User PISA pages are compacted by migration: no unmovable folios in them. */
+	if (!(gfp & __GFP_MOVABLE))
+		return NULL;
+	if (!pisa_mapping_enabled(mapping, dir))
+		return NULL;
+	if (pisa_mapping_enabled(mapping, is_write ? DMA_FROM_DEVICE : DMA_TO_DEVICE))
+		dir = DMA_BIDIRECTIONAL;
+	if (pisa_user_budget() <= 0)
+		return NULL;
+	nid = pisa_sanitize_nid(numa_node_id());
+	page = pisa_alloc(pisa_nodes[nid].user_pa[dir], gfp);
+	if (!page)
+		return NULL;
+	return page_folio(page);
+}
+
+static bool pisa_folio_upgrade(struct folio *folio, enum dma_data_direction dir,
+			       struct folio_batch *fbatch)
+{
+	LIST_HEAD(list);
+
+	if (!pisa_user_want_dir(folio, true, dir, true) ||
+	    (!is_pisa_pfn(folio_pfn(folio)) && pisa_user_budget() <= 0))
+		return false;
+	if (!folio_test_lru(folio))
+		lru_add_drain();
+	if (pisa_user_busy(folio, 1) || !isolate_folio_to_list(folio, &list))
+		return false;
+	/* Drop caller's reference so migrate_pages() sees only expected refs. */
+	if (fbatch)
+		folio_batch_release(fbatch);
+	else
+		folio_put(folio);
+	pisa_user_migrate_dir(&list, true, dir, false,
+			      GFP_NOWAIT | __GFP_HARDWALL | __GFP_NOWARN);
+	return true;
+}
+
+bool __pisa_filemap_upgrade(const struct address_space *mapping,
+			    struct folio *folio)
+{
+	return pisa_mapping_enabled(mapping, DMA_TO_DEVICE) &&
+	       pisa_folio_upgrade(folio, DMA_TO_DEVICE, NULL);
+}
+
+bool __pisa_writeback_upgrade(const struct address_space *mapping,
+			      struct folio *folio, pgoff_t *index,
+			      struct folio_batch *fbatch)
+{
+	pgoff_t idx;
+
+	if (!pisa_mapping_enabled(mapping, DMA_TO_DEVICE))
+		return false;
+	idx = folio->index;
+	if (!pisa_folio_upgrade(folio, DMA_TO_DEVICE, fbatch))
+		return false;
+	*index = idx;
+	return true;
+}
+
 #define PISA_USER_BATCH	512
 
+/* Under RCU: is @pfn still a block of @target, and @target still owned by @pa? */
+static bool pisa_user_block_of(unsigned long pfn, const struct pisa_meta *target,
+			       const struct pisa_alloc *pa)
+{
+	return is_pisa_pfn(pfn) && pisa_meta_of_pfn(pfn) == target &&
+	       READ_ONCE(target->pa) == pa;
+}
+
+static unsigned long pisa_user_scrub_alloc(struct pisa_alloc *pa,
+					   enum dma_data_direction dir,
+					   unsigned int mode,
+					   unsigned long budget)
+{
+	unsigned int target_pct = READ_ONCE(pisa_target_usage_percent);
+	unsigned int old_ms = READ_ONCE(pisa_old_ms);
+	unsigned long bpp = PISA_BLOCKS(0), in_use;
+	unsigned long max_age, base_pfn = 0, flags;
+	DECLARE_BITMAP(inuse_map, _PISA_MAX_BLOCKS);
+	struct list_head *lists[] = { &pa->partial_dirty, &pa->partial };
+	struct pisa_meta *meta, *target = NULL;
+	unsigned int idx, count = 0;
+	unsigned long migrated = 0;
+	LIST_HEAD(list);
+	long held;
+
+	if (!target_pct || !old_ms)
+		return 0;
+
+	pisa_pcp_drain(pa);
+
+	held = pisa_alloc_held_pages(pa);
+	in_use = READ_ONCE(pa->blocks_in_use);
+	if (held <= 0 || in_use * 100 >= (unsigned long)held * bpp * target_pct)
+		return 0;
+
+	max_age = msecs_to_jiffies(min(old_ms, PISA_OLD_MS_MAX));
+
+	spin_lock_irqsave(&pa->lock, flags);
+	for (unsigned int i = 0; i < ARRAY_SIZE(lists) && !target; i++) {
+		list_for_each_entry_reverse(meta, lists[i], list) {
+			if (pisa_meta_avail(meta) < (bpp >> 1))
+				break;
+			/* Compaction needs a sparse page and another partial page to fill. */
+			if (mode == 1 && (!(meta->on_list & PISA_LIST_SPARSE) ||
+					  (list_is_first(&meta->list, lists[i]) &&
+					   list_empty(lists[!i]))))
+				break;
+			if (time_after(jiffies, meta->alloc_jiffies + max_age)) {
+				target = meta;
+				break;
+			}
+		}
+	}
+	if (target) {
+		/*
+		 * Compaction: park @target on @pa->full, so that the blocks
+		 * freed from it are neither cached nor handed out again while
+		 * its folios move to other pages of @pa.
+		 */
+		if (mode == 1) {
+			WRITE_ONCE(target->on_list, PISA_LIST_FULL | PISA_LIST_HOLD);
+			list_move(&target->list, &pa->full);
+		}
+		base_pfn = pisa_meta_to_pfn(target);
+		bitmap_or(inuse_map, target->clean_bitmap, target->dirty_bitmap, bpp);
+		bitmap_complement(inuse_map, inuse_map, bpp);
+	}
+	spin_unlock_irqrestore(&pa->lock, flags);
+
+	if (!target)
+		return 0;
+
+	for_each_set_bit(idx, inuse_map, bpp) {
+		unsigned long pfn = base_pfn + idx;
+		struct folio *folio;
+
+		rcu_read_lock();
+		if (!pisa_user_block_of(pfn, target, pa)) {
+			rcu_read_unlock();
+			break;
+		}
+		folio = page_folio(pfn_to_page(pfn));
+		if (!folio_try_get(folio)) {
+			rcu_read_unlock();
+			continue;
+		}
+		if (!pisa_user_block_of(pfn, target, pa) ||
+		    folio != page_folio(pfn_to_page(pfn))) {
+			rcu_read_unlock();
+			folio_put(folio);
+			continue;
+		}
+		rcu_read_unlock();
+
+		if (!pisa_user_want_dir(folio, false, dir, true) ||
+		    pisa_user_busy(folio, 1) ||
+		    !isolate_folio_to_list(folio, &list)) {
+			folio_put(folio);
+			continue;
+		}
+		folio_put(folio);
+		if (++count >= min_t(unsigned long, budget, PISA_USER_BATCH))
+			break;
+	}
+
+	if (!list_empty(&list)) {
+		migrated = pisa_user_migrate_dir(&list, mode == 1, dir, true,
+						 GFP_KERNEL | __GFP_NOWARN);
+		pisa_pcp_drain(pa);
+	}
+
+	if (mode == 1) {
+		bool should_release;
+
+		/* Put @target back on the list that its free blocks call for. */
+		spin_lock_irqsave(&pa->lock, flags);
+		WRITE_ONCE(target->on_list, PISA_LIST_FULL);
+		should_release = pisa_place_meta(target);
+		spin_unlock_irqrestore(&pa->lock, flags);
+		if (should_release)
+			pisa_schedule_reclaim();
+	}
+
+	/* Nothing moved: do not pick @target again before it ages. */
+	if (!migrated && READ_ONCE(target->pa) == pa)
+		WRITE_ONCE(target->alloc_jiffies, jiffies);
+
+	return migrated;
+}
+
+bool pisa_user_scrub_node(int nid)
+{
+	unsigned long budget = READ_ONCE(pisa_scrub_max) ?: 512;
+	unsigned int mode = READ_ONCE(pisa_scrub_migrate);
+	unsigned int n_dirs = ARRAY_SIZE(pisa_nodes[nid].user_pa);
+	u64 deadline = local_clock() + PISA_SCRUB_RUN_NS;
+	bool progress = false;
+
+	if (!mode || mode > 2)
+		return false;
+
+	for (unsigned int i = 0; i < n_dirs; i++) {
+		unsigned int dir = pisa_nodes[nid].scrub_dir++ % n_dirs;
+		/* Pairs with smp_store_release() in pisa_user_init(). */
+		struct pisa_alloc *pa = smp_load_acquire(&pisa_nodes[nid].user_pa[dir]);
+		unsigned long n;
+
+		if (!pa)
+			continue;
+		n = pisa_user_scrub_alloc(pa, dir, mode, budget);
+		if (n >= budget || local_clock() >= deadline)
+			return true;
+		if (n) {
+			budget -= n;
+			progress = true;
+			cond_resched();
+		}
+	}
+	return progress;
+}
+
 struct pisa_madvise_walk {
 	struct list_head	list;	/* isolated folios waiting to be migrated */
 	unsigned int		n;	/* pages on @list */
@@ -329,7 +760,8 @@ static int pisa_madvise_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long
 			return 1;
 		folio = folio_walk_start(&fw, walk->vma, addr, 0);
 		if (folio) {
-			bool want = pisa_user_want(folio, to_pisa) && folio_test_lru(folio);
+			bool want = pisa_user_want_dir(folio, to_pisa, DMA_TO_DEVICE, false) &&
+				    folio_test_lru(folio);
 			bool busy = want && pisa_user_busy(folio, 0);
 			bool split = want && !busy && folio_test_large(folio);
 
@@ -352,7 +784,8 @@ static int pisa_madvise_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long
 			}
 		}
 		if (w->n >= PISA_USER_BATCH) {
-			pisa_user_migrate(&w->list, to_pisa, PISA_MADVISE_GFP);
+			pisa_user_migrate_dir(&w->list, to_pisa, DMA_TO_DEVICE, false,
+					      PISA_MADVISE_GFP);
 			w->n = 0;
 		}
 		addr += nr << PAGE_SHIFT;
@@ -389,6 +822,6 @@ int pisa_madvise(struct vm_area_struct *vma, unsigned long start, unsigned long
 	lru_add_drain();
 	/* The page walker skips the unpopulated page-table levels of sparse mappings. */
 	ret = walk_page_range_vma(vma, start, end, &pisa_madvise_walk_ops, &w);
-	pisa_user_migrate(&w.list, to_pisa, PISA_MADVISE_GFP);
+	pisa_user_migrate_dir(&w.list, to_pisa, DMA_TO_DEVICE, false, PISA_MADVISE_GFP);
 	return ret < 0 ? ret : 0;
 }
diff --git a/mm/readahead.c b/mm/readahead.c
index 6e5563290287e..82b03ac1161dd 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -114,6 +114,7 @@
  */
 
 #include <linux/blk_plug.h>
+#include <linux/pisa-mm.h>
 #include <linux/kernel.h>
 #include <linux/dax.h>
 #include <linux/gfp.h>
@@ -197,7 +198,7 @@ static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
 {
 	struct folio *folio;
 
-	folio = filemap_alloc_folio(gfp_mask, order, NULL);
+	folio = pisa_filemap_alloc_folio(gfp_mask, order, NULL, ractl->mapping);
 	if (folio && ractl->dropbehind)
 		__folio_set_dropbehind(folio);
 
-- 
2.56.1.809.ga0b61035b5-goog

