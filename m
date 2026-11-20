Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136826;
	b=QGKlnNCEvIVmIa8cCWMfw3sr7vTZDE2asmhgDKIAu+i1YykZUL2s4vXiNR4AWi0WR15s
	 jDQFM4dVr9z0TcqsLCoxEtg2mvHX9gWinCKDpkwnz6TMOoJzq91sk8278FQq2+KzjMKvV
	 WvW8cyrGqnnnEec1CZCa8AyyUos1dx3q9NARbDerNrfhRjp0Kr4fqfv9lzz8lYAmp5OJ6
	 yoembTFTAjzyGejy45bl6hsjKxirscqRRicDs3sIPm9lOrf9MukJ9FaAKN48E89O7nRYR
	 pCiVz358DkJaX5jTnD4MqwYuVmyALtcWz4ksN05ijmXfnJKRga+b6C/cRgnINxJknDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136826;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=7uPQA5T+O/3vWFERJmV3UgW1TOqpVGmvbPRA+uFyVb4=;
	b=LDywGoqH4xi/N0cHPJEBhC+1Zn12sH10eUXKXbaK232zbmIGwb9K41rfm/hRhFcg7Tnj
	 bNW/Qx20j/95V5MW+yfmjQkGJBttaRCEcD7+hovkPE6u+Jpc9Jg6lx2WUiARxn+LQVBwS
	 kk3HHlEZ0PpfbmrlqAbN3NUjXF8bu183iYLwfjCGi5W6odAovqaCN7sIWEPlv3oSKI+UM
	 rk6CnH51pJ+TXrSCuVppt9ozygC6kN36SuSY48o27b2oy7G32GWGCGs0jVT+FctvUI4rq
	 hXBhma+nxMMLfefO15jCroAgnGvPboTgl3iWD+LsIsOiTywstdxwxE0O4jQDuPsF1vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MI83OmDL;
	arc=none smtp.remote-ip=209.85.208.71
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D1260A2623
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43D1260A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MI83OmDL
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b586b0a795so255913a12.1
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136824; x=1795741624; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7uPQA5T+O/3vWFERJmV3UgW1TOqpVGmvbPRA+uFyVb4=;
        b=MI83OmDLHTD8gq2Z1Bs/lc9JH/3iDZOG6aFnbx2IKJeRrti+P12Ov1Ooii4xS7IGIx
         z/7ofpDkRx0kDftlj5tZrsGAafoXdBgikzzoPuui95UrgKdELkDxQ/DtfUpSbyI5psD1
         spMulYu2rfl8lKrfPctDnI5xVHeB/evZXcURCry4rCkjRxzCfyXcCmQjCg3b5sNFlasg
         f4uu0ropwJuJT7g4lwdY4Nvm78IKbjbwPzSR7CKvXXAXJIZQ8Da+LXu6QdeF2CdaspoE
         9o5/F4y9T7XTaUrDUFOEWtpQpQUkO0wBwTsCbMfVXvnKeLcIf/a+r6YuCJmP9R8rKM6Y
         RYjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136824; x=1795741624;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7uPQA5T+O/3vWFERJmV3UgW1TOqpVGmvbPRA+uFyVb4=;
        b=H5Rq0m2hazeKLPj1FgikmSoT0dfeWM1KU3R1pjRP/y37ViY+FGADSu0avyWs/aNzz5
         Fl33Un0pr6F4IX8WIV6qBJ+RkuUF4wXb62jm495MXyjOxtDaAo9k3Zn8G99uh1+5nMBO
         eZx5BfcHu5m2doaJTBxs6BwJspvuUXMyG+VCglks79UbYrpv+dnJ7NbsWT2GTx54R7Ku
         sTZqRFeTKIdukfa/Os8LsYDMxrHI65ad+WoRxZIs6gMfpQhn55vlSGlh8jP2Z47kLS11
         EM/lKzvQ6bVNl3XGKPniU8d0Q0KgtEVlK90pXQx4Dw+qHX690CLrka3HvWFCYUrJbT6v
         rP7w==
X-Forwarded-Encrypted: i=1; AL+hErHxzcHHUDIipo0mCv+bCHpSCcf20CPWa/6xubLyfC9FuKoRcCIV3v6K9QCnzIbQPBHTzWxKAMMQzAA=@vger.kernel.org
X-Gm-Message-State: APuU4Z+fI2TvXcca6vb+IIAUV7pg1cQIgvvk76CxE091eCEurax//0kG
	sO6X1BixBwsLXTAnH/PUYmIdORLqoVyS44i32FjLxcWPvvn+DlE+0HYvl1nHkNQynEDiwsTM8Ip
	p4a2BwA==
X-Received: from edev6-n1.prod.google.com ([2002:a05:6402:a2c6:10b0:6ba:1325:d4d5])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:51c7:b0:6b1:e8e1:a3cd
 with SMTP id 4fb4d7f45d1cf-6ba37ea56d7mr770424a12.35.1795136823046; Thu, 19
 Nov 2026 17:07:03 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:32 +0000
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
Message-ID: <20261120010655.467825-3-lrizzo@google.com>
Subject: [RFC PATCH v3 02/25] mm: Add PISA allocator lifecycle and page
 recycle hook
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

PISA allocators use 2MB physically contiguous memory pages from which IO
buffers are allocated. Recycling memory to the PISA allocator amortizes the
cost of mapping, unmapping and IOTLB flush. Memory is returned to the buddy
allocator only when all active IOMMU/IOTLB mappings have been flushed,
so sensitive data or code will not ever be accessible to IO devices.

Add the allocator creation (struct pisa_alloc, pisa_alloc_create()) and the
page release side, hooking into __free_pages_prepare() so that PISA
pages are returned to the allocator.

Also implement asynchronous PISA page retirement and release to the
buddy allocator via a WQ_MEM_RECLAIM worker. Retirement removes PISA
pages from allocators and destroys the mappings flushing the IOTLB, but
defers the buddy release by an RCU grace period.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/pisa-iommu.h |  24 +++
 include/linux/pisa-mm.h    |  35 ++++
 include/linux/pisa.h       |   2 +
 mm/Makefile                |   2 +-
 mm/page_alloc.c            |   4 +
 mm/pisa-alloc.c            | 338 +++++++++++++++++++++++++++++++++++++
 mm/pisa-kunit.c            | 101 ++++++++++-
 mm/pisa-meta.c             |  71 ++++++++
 mm/pisa-node.c             |  61 +++++++
 mm/pisa-priv.h             |  88 ++++++++++
 10 files changed, 724 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/pisa-mm.h
 create mode 100644 mm/pisa-alloc.c
 create mode 100644 mm/pisa-node.c

diff --git a/include/linux/pisa-iommu.h b/include/linux/pisa-iommu.h
index 7a04523b28b4c..098430c5f864a 100644
--- a/include/linux/pisa-iommu.h
+++ b/include/linux/pisa-iommu.h
@@ -26,8 +26,20 @@ struct pisa_alloc;
 struct pisa_meta {
 	unsigned long flags;	/* PISA_ACTIVE / PISA_QUARANTINED / PISA_DECRYPTED */
 	unsigned long base_pfn;	/* base PFN of this PISA page */
+	u16 nr_clean;		/* zeroed available blocks in @clean_bitmap */
+	u16 nr_dirty;		/* dirty available blocks in @dirty_bitmap */
+	u8 on_list;		/* current placement in @pa (PISA_LIST_*) */
 	u32 slot;		/* dense index in @pisa_meta_array and IOVA windows */
+	struct pisa_alloc *pa;	/* NULL for reservoir pages */
 	struct list_head list;	/* node in @pa lists or pisa_node.pages */
+
+	union {
+		struct llist_node llnode; /* node in lockless pisa_free_list */
+		struct rcu_head rcu;
+	};
+
+	DECLARE_BITMAP(clean_bitmap, _PISA_MAX_BLOCKS) ____cacheline_aligned;
+	DECLARE_BITMAP(dirty_bitmap, _PISA_MAX_BLOCKS) ____cacheline_aligned;
 } __aligned(_PISA_META_SIZE);
 
 static_assert(sizeof(struct pisa_meta) == _PISA_META_SIZE);
@@ -35,6 +47,18 @@ static_assert(sizeof(struct pisa_meta) == _PISA_META_SIZE);
 extern struct pisa_meta *pisa_meta_array;
 
 struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn);
+bool pisa_quarantine_page(struct pisa_meta *meta);
+void pisa_schedule_reclaim(void);
 
 #endif /* CONFIG_PISA */
+
+#if defined(CONFIG_PISA) && defined(CONFIG_IOMMU_DMA)
+
+void pisa_unmap_all_domains(struct pisa_meta *meta);
+
+#else /* !CONFIG_PISA || !CONFIG_IOMMU_DMA */
+
+static inline void pisa_unmap_all_domains(struct pisa_meta *meta) {}
+
+#endif /* CONFIG_PISA && CONFIG_IOMMU_DMA */
 #endif /* _LINUX_PISA_IOMMU_H */
diff --git a/include/linux/pisa-mm.h b/include/linux/pisa-mm.h
new file mode 100644
index 0000000000000..60dae9ab6116d
--- /dev/null
+++ b/include/linux/pisa-mm.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* PISA hooks for mm and the block layer. */
+#ifndef _LINUX_PISA_MM_H
+#define _LINUX_PISA_MM_H
+
+#include <linux/pisa.h>
+
+#ifdef CONFIG_PISA
+
+bool __pisa_free_page(struct page *page, unsigned int order);
+
+/*
+ * ============================================================================
+ * MM hooks (every hook starts inline with a static-key check)
+ * ============================================================================
+ */
+
+/* Hook for __free_pages_prepare() (guarded by @pisa_key). */
+static inline bool pisa_free_page(struct page *page, unsigned int order)
+{
+	if (!pisa_enabled())
+		return false;
+	guard(rcu)();
+	return is_pisa_page(page) && __pisa_free_page(page, order);
+}
+
+#else /* !CONFIG_PISA */
+
+static inline bool pisa_free_page(struct page *page, unsigned int order)
+{
+	return false;
+}
+
+#endif /* CONFIG_PISA */
+#endif /* _LINUX_PISA_MM_H */
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 660329fd448fe..f07432d2e6809 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -5,9 +5,11 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/dma-mapping.h>
 #include <linux/jump_label.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
+#include <linux/rcupdate.h>
 
 #ifdef CONFIG_PISA
 
diff --git a/mm/Makefile b/mm/Makefile
index 55dff84df1555..7d624e4bad456 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,7 +147,7 @@ obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_PISA) += pisa.o
-pisa-y := pisa-meta.o
+pisa-y := pisa-meta.o pisa-alloc.o pisa-node.o
 obj-$(CONFIG_PISA_META_KUNIT_TEST) += pisa-kunit.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2fef4092c913c..e053cc7298eab 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -17,6 +17,7 @@
 #include <linux/stddef.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/pisa-mm.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 #include <linux/compiler.h>
@@ -1324,6 +1325,9 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
+	if (unlikely(pisa_free_page(page, order)))
+		return false;
+
 	trace_mm_page_free(page, order);
 	kmsan_free_page(page, order);
 
diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
new file mode 100644
index 0000000000000..557ec1ba88c78
--- /dev/null
+++ b/mm/pisa-alloc.c
@@ -0,0 +1,338 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * PISA streaming page allocator, async page reclaim, shrinker, and debugfs.
+ * See Documentation/core-api/pisa.rst for the architecture overview.
+ */
+
+#include <linux/atomic.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/cache.h>
+#include <linux/dma-mapping.h>
+#include <linux/pisa.h>
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/kasan.h>
+#include <linux/list.h>
+#include <linux/llist.h>
+#include <linux/mm.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/page_table_check.h>
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/vmstat.h>
+#include <linux/workqueue.h>
+
+#include "pisa-priv.h"
+
+/* Idle PISA pages over the allocator watermark queued locklessly for release. */
+LLIST_HEAD(pisa_free_list);
+
+/* Dedicated WQ_MEM_RECLAIM workqueue, can run without allocations. */
+static struct workqueue_struct *pisa_wq __ro_after_init;
+
+/* Max completely idle PISA pages kept per allocator before async release (at least 1). */
+static unsigned int pisa_max_idle __read_mostly = 1;
+
+/* Grace period in ms before releasing idle PISA pages above @pisa_max_idle (0 = immediate). */
+unsigned int pisa_idle_ms __read_mostly = 200;
+module_param_named(idle_ms, pisa_idle_ms, uint, 0644);
+
+/* All live allocators, protected by pisa_allocs_lock. */
+static LIST_HEAD(pisa_allocs);
+static DEFINE_RWLOCK(pisa_allocs_lock);
+
+/* Allocators copy pisa_max_idle at creation: update the existing ones too. */
+static int pisa_max_idle_set(const char *val, const struct kernel_param *kp)
+{
+	int ret = param_set_uint_minmax(val, kp, 1, UINT_MAX);
+	struct pisa_alloc *pa;
+
+	if (ret)
+		return ret;
+	scoped_guard(read_lock, &pisa_allocs_lock) {
+		list_for_each_entry(pa, &pisa_allocs, node) {
+			guard(spinlock_irqsave)(&pa->lock);
+			WRITE_ONCE(pa->max_idle_pages, pisa_max_idle);
+			/* Pages that the new cap makes excess start their grace period now. */
+			if (pa->num_idle_pages > pisa_max_idle)
+				WRITE_ONCE(pa->idle_jiffies, jiffies);
+		}
+	}
+	/* Release pages that a lower cap made excess (once initialized). */
+	if (pisa_enabled())
+		pisa_schedule_reclaim();
+	return 0;
+}
+
+static const struct kernel_param_ops pisa_max_idle_ops = {
+	.set = pisa_max_idle_set,
+	.get = param_get_uint,
+};
+module_param_cb(max_idle, &pisa_max_idle_ops, &pisa_max_idle, 0644);
+
+static void pisa_reclaim_work_fn(struct work_struct *work);
+
+/* Asynchronous reclaim worker for pisa_free_list and expired idle pages. */
+static DECLARE_DELAYED_WORK(pisa_reclaim_work, pisa_reclaim_work_fn);
+
+static void pisa_reclaim_work_fn(struct work_struct *work)
+{
+	unsigned long grace = msecs_to_jiffies(READ_ONCE(pisa_idle_ms));
+	unsigned long next_delay = MAX_JIFFY_OFFSET;
+	struct pisa_meta *meta, *tmp;
+	struct llist_node *node;
+	struct pisa_alloc *pa;
+
+	read_lock(&pisa_allocs_lock);
+	list_for_each_entry(pa, &pisa_allocs, node) {
+		unsigned long expire = READ_ONCE(pa->idle_jiffies) + grace;
+		unsigned long now = jiffies, flags;
+
+		if (READ_ONCE(pa->num_idle_pages) <= READ_ONCE(pa->max_idle_pages))
+			continue;
+		if (grace && time_before(now, expire)) {
+			next_delay = min(next_delay, expire - now);
+			continue;
+		}
+		spin_lock_irqsave(&pa->lock, flags);
+		while ((!grace || time_after_eq(now, pa->idle_jiffies + grace)) &&
+		       pa->num_idle_pages > pa->max_idle_pages && !list_empty(&pa->idle)) {
+			meta = list_last_entry(&pa->idle, struct pisa_meta, list);
+			list_del_init(&meta->list);
+			WRITE_ONCE(meta->on_list, PISA_LIST_NONE);
+			llist_add(&meta->llnode, &pisa_free_list);
+			pa->num_idle_pages--;
+		}
+		spin_unlock_irqrestore(&pa->lock, flags);
+	}
+	read_unlock(&pisa_allocs_lock);
+
+	node = llist_del_all(&pisa_free_list);
+	llist_for_each_entry_safe(meta, tmp, node, llnode)
+		pisa_release_page(meta);
+
+	if (next_delay != MAX_JIFFY_OFFSET)
+		queue_delayed_work(pisa_wq ?: system_wq, &pisa_reclaim_work, next_delay);
+}
+
+void pisa_schedule_reclaim(void)
+{
+	struct workqueue_struct *wq = pisa_wq ?: system_wq;
+	unsigned int idle_ms = READ_ONCE(pisa_idle_ms);
+
+	if (!llist_empty(&pisa_free_list) || !idle_ms)
+		mod_delayed_work(wq, &pisa_reclaim_work, 0);
+	else
+		queue_delayed_work(wq, &pisa_reclaim_work, msecs_to_jiffies(idle_ms));
+}
+
+/* Mark @meta quarantined after an IOMMU unmap failure; return true if queued for release. */
+bool pisa_quarantine_page(struct pisa_meta *meta)
+{
+	bool released = false;
+	struct pisa_alloc *pa;
+	unsigned long flags;
+
+	set_bit(_PISA_QUARANTINED, &meta->flags);
+	pa = READ_ONCE(meta->pa);
+	if (!pa || READ_ONCE(meta->on_list) == PISA_LIST_NONE)
+		return false;
+	spin_lock_irqsave(&pa->lock, flags);
+	if (meta->pa == pa && meta->on_list != PISA_LIST_NONE) {
+		if (meta->on_list & PISA_LIST_IDLE)
+			pa->num_idle_pages--;
+		released = pisa_place_meta(meta);
+	}
+	spin_unlock_irqrestore(&pa->lock, flags);
+	return released;
+}
+
+/*
+ * pisa_free_page() in __free_pages_prepare() recycles a PISA block into
+ * its allocator before the rest of that function runs. __pisa_free_page() calls
+ * this to apply the buddy allocator's checks, and to clear the order-0 state of
+ * blocks that were user pages (see mm/pisa-user.c).
+ *
+ * Return: false if the block is in a bad state (already reported): leak it.
+ */
+static bool pisa_free_page_prepare(struct page *page, unsigned int order)
+{
+	struct folio *folio = page_folio(page);
+
+	if (!order) {
+		if (unlikely(folio_test_mlocked(folio))) {
+			__folio_clear_mlocked(folio);
+			zone_stat_mod_folio(folio, NR_MLOCK, -1);
+			count_vm_events(UNEVICTABLE_PGCLEARED, 1);
+		}
+		if (folio_test_anon(folio))
+			folio->mapping = NULL;
+	}
+	if (WARN_ON_ONCE(atomic_read(&page->_mapcount) != -1 ||
+			 page->mapping || page_ref_count(page) ||
+			 (page->flags.f & PAGE_FLAGS_CHECK_AT_FREE)))
+		return false;
+	/* Compound blocks: the checks free_tail_page_prepare() does on the first tail page. */
+	if (order && WARN_ON_ONCE(folio_large_mapcount(folio) ||
+				  atomic_read(&folio->_entire_mapcount) != -1 ||
+				  atomic_read(&folio->_pincount)))
+		return false;
+	page_table_check_free(page, order);
+	for (unsigned int i = 0; i < (1U << order); i++)
+		page_kasan_tag_reset(page + i);
+	kasan_unpoison_range(page_address(page), PAGE_SIZE << order);
+	if (!order) {
+		page_cpupid_reset_last(page);
+		page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+		page->private = 0;
+	}
+	return true;
+}
+
+/* Check for hwpoisoned block; if poisoned, warn once and leak it to keep @pa intact. */
+static bool is_pisa_block_poisoned(struct pisa_alloc *pa, struct page *block)
+{
+	for (unsigned int i = 0; i < (1U << pa->order); i++) {
+		if (unlikely(PageHWPoison(block + i))) {
+			pr_err_once("pisa: poisoned block at pfn %lu, leaking it to keep allocator %p intact\n",
+				    page_to_pfn(block), pa);
+			return true;
+		}
+	}
+	return false;
+}
+
+/**
+ * pisa_alloc_create - Create a PISA page allocator
+ * @nid: Home NUMA node for this allocator
+ * @order: Block order to dispense (<= PISA_ORDER)
+ * @dir: Supported DMA direction (DMA_BIDIRECTIONAL, DMA_TO_DEVICE, or
+ *	DMA_FROM_DEVICE); other mappings fall back to per-buffer IOMMU mappings
+ *
+ * Return: Pointer to the created allocator, or NULL on failure.
+ */
+struct pisa_alloc *pisa_alloc_create(int nid, unsigned int order, enum dma_data_direction dir)
+{
+	struct pisa_alloc *pa;
+
+	if ((unsigned int)nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY) ||
+	    order > PISA_ORDER || !valid_dma_direction(dir))
+		return NULL;
+
+	pa = kzalloc(sizeof(*pa), GFP_KERNEL);
+	if (!pa)
+		return NULL;
+
+	spin_lock_init(&pa->lock);
+	pa->order = order;
+	pa->nid = nid;
+	pisa_alloc_set_name(pa, "%ps", (void *)_RET_IP_);
+	INIT_LIST_HEAD(&pa->partial);
+	INIT_LIST_HEAD(&pa->partial_dirty);
+	INIT_LIST_HEAD(&pa->idle);
+	INIT_LIST_HEAD(&pa->full);
+	pa->idle_jiffies = jiffies;
+
+	guard(write_lock)(&pisa_allocs_lock);
+	/* Under the lock, so pisa_max_idle_set() either sees @pa or was seen here. */
+	pa->max_idle_pages = READ_ONCE(pisa_max_idle);
+	list_add_tail(&pa->node, &pisa_allocs);
+
+	return pa;
+}
+
+/**
+ * pisa_alloc_set_name - Name a PISA allocator for debugfs
+ * @pa: Allocator to name (may be NULL)
+ * @fmt: printf-style format, truncated to fit @pa->name
+ */
+void pisa_alloc_set_name(struct pisa_alloc *pa, const char *fmt, ...)
+{
+	va_list args;
+
+	if (!pa)
+		return;
+	va_start(args, fmt);
+	vsnprintf(pa->name, sizeof(pa->name), fmt, args);
+	va_end(args);
+}
+
+/* Return freed @block (at refcount 0) to @pa's bitmaps under @pa->lock. */
+static bool pisa_return_block_locked(struct pisa_alloc *pa, struct page *block)
+{
+	unsigned long pfn = page_to_pfn(block);
+	struct pisa_meta *meta = pisa_meta_of_pfn(pfn);
+	unsigned int idx = (pfn & (PISA_BLOCKS(0) - 1)) >> pa->order;
+
+	lockdep_assert_held(&pa->lock);
+
+	if (WARN_ON_ONCE(test_bit(idx, meta->clean_bitmap) || test_bit(idx, meta->dirty_bitmap)))
+		return false;
+
+	/* __pisa_free_page() zeroed it if init_on_free is set. */
+	if (want_init_on_free()) {
+		__set_bit(idx, meta->clean_bitmap);
+		meta->nr_clean++;
+	} else {
+		__set_bit(idx, meta->dirty_bitmap);
+		meta->nr_dirty++;
+	}
+	return pisa_place_meta(meta);
+}
+
+/**
+ * __pisa_free_page - Recycle a freed block back into its PISA allocator
+ * @page: Block being freed (called from __free_pages_prepare() under RCU)
+ * @order: Order the caller is freeing @page with
+ *
+ * Return: true if the page belonged to a PISA allocator and was recycled.
+ */
+bool __pisa_free_page(struct page *page, unsigned int order)
+{
+	bool should_release;
+	unsigned long pfn = page_to_pfn(page), flags;
+	struct pisa_meta *meta = pisa_meta_of_pfn(pfn);
+	struct pisa_alloc *pa = meta->pa;
+	unsigned int idx = (pfn & (PISA_BLOCKS(0) - 1)) >> pa->order;
+
+	/* Reject double frees, mismatched orders, or unaligned blocks. */
+	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, 1UL << pa->order) ||
+			 order != pa->order || compound_order(page) != pa->order ||
+			 test_bit(idx, meta->clean_bitmap) || test_bit(idx, meta->dirty_bitmap)))
+		return true;
+
+	/* Never reuse or return a hwpoisoned block to the buddy allocator. */
+	if (is_pisa_block_poisoned(pa, page))
+		return true;
+
+	/* Checks skipped by the early return in __free_pages_prepare(). */
+	if (unlikely(!pisa_free_page_prepare(page, pa->order)))
+		return true;
+
+	/* KASAN/KMSAN/pgalloc_tag_sub run when pisa_release_page_rcu() frees to buddy. */
+	if (want_init_on_free())
+		memset(page_address(page), 0, PAGE_SIZE << pa->order);
+
+	spin_lock_irqsave(&pa->lock, flags);
+	should_release = pisa_return_block_locked(pa, page);
+	spin_unlock_irqrestore(&pa->lock, flags);
+
+	if (should_release)
+		pisa_schedule_reclaim();
+
+	return true;
+}
+
+static int __init pisa_init(void)
+{
+	/* Dedicated WQ_MEM_RECLAIM workqueue so reclaim never blocks behind system_wq. */
+	pisa_wq = alloc_workqueue("pisa", WQ_MEM_RECLAIM, 0);
+	if (!pisa_wq)
+		pr_warn("pisa: no reclaim workqueue, falling back to system_wq\n");
+
+	return 0;
+}
+subsys_initcall(pisa_init);
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
index 0b0dda51e8e60..7436d1c9b86a6 100644
--- a/mm/pisa-kunit.c
+++ b/mm/pisa-kunit.c
@@ -3,6 +3,7 @@
  * KUnit tests for the opaque struct pisa_meta table API.
  */
 #include <kunit/test.h>
+#include <linux/delay.h>
 #include <linux/gfp.h>
 #include <linux/pisa.h>
 #include <linux/mm.h>
@@ -95,10 +96,108 @@ static void test_meta_active_toggle(struct kunit *test)
 	__free_pages(page, PISA_ORDER);
 }
 
+static void test_alloc_and_recycle(struct kunit *test)
+{
+	KUNIT_EXPECT_NULL(test, pisa_alloc_create(first_memory_node, 0, DMA_NONE));
+	KUNIT_EXPECT_NULL(test, pisa_alloc_create(first_memory_node, PISA_ORDER + 1,
+						  DMA_BIDIRECTIONAL));
+	pisa_alloc_set_name(NULL, "ignored");
+}
+
+/* Wait for the reclaim worker and its RCU callback to retire @meta. */
+static bool pisa_test_wait_retired(struct pisa_meta *meta)
+{
+	for (int i = 0; i < 250 && READ_ONCE(meta->pa); i++)
+		msleep(20);
+	rcu_barrier();
+	return !READ_ONCE(meta->pa);
+}
+
+/*
+ * A quarantined page serves no allocation, and once its blocks are back it is
+ * retired without giving its slot or its memory back. The state of the page is
+ * built by hand, in a private allocator that nothing else allocates from.
+ */
+static void test_quarantine(struct kunit *test)
+{
+	const unsigned int bpp = PISA_BLOCKS(0);
+	unsigned long pfn, flags;
+	struct pisa_alloc *pa;
+	struct pisa_meta *meta;
+	struct page *page;
+	bool released;
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+	pa = pisa_alloc_create(first_memory_node, 0, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_NULL(test, pa);
+	pisa_alloc_set_name(pa, "kunit_quarantine");
+
+	page = alloc_pages(GFP_KERNEL, PISA_ORDER);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	pfn = page_to_pfn(page);
+	if (pisa_meta_ensure_pfn(pfn, true)) {
+		__free_pages(page, PISA_ORDER);
+		KUNIT_FAIL(test, "pisa_meta_ensure_pfn(%lu) failed", pfn);
+		return;
+	}
+	meta = pisa_meta_of_pfn(pfn);
+
+	/* A page that no allocator owns is only flagged, and keeps its slot. */
+	KUNIT_EXPECT_FALSE(test, pisa_quarantine_page(meta));
+	KUNIT_EXPECT_TRUE(test, meta->flags & PISA_QUARANTINED);
+	pisa_slot_free(meta);
+	KUNIT_EXPECT_PTR_EQ(test, pisa_meta_of_pfn(pfn), meta);
+	pisa_meta_clear_flags(meta, PISA_QUARANTINED);
+
+	/* Give the page to @pa with half of its blocks in use. */
+	spin_lock_irqsave(&pa->lock, flags);
+	meta->pa = pa;
+	meta->nr_clean = bpp / 2;
+	pisa_meta_set_flags(meta, PISA_ACTIVE);
+	pisa_place_meta(meta);
+	spin_unlock_irqrestore(&pa->lock, flags);
+	KUNIT_EXPECT_EQ(test, (unsigned int)meta->on_list, (unsigned int)PISA_LIST_CLEAN);
+	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(pfn));
+
+	/* Quarantined with blocks in use: parked on @full, where nothing allocates from it. */
+	KUNIT_EXPECT_FALSE(test, pisa_quarantine_page(meta));
+	KUNIT_EXPECT_EQ(test, (unsigned int)meta->on_list, (unsigned int)PISA_LIST_FULL);
+	KUNIT_EXPECT_TRUE(test, list_empty(&pa->partial));
+	KUNIT_EXPECT_TRUE(test, list_is_singular(&pa->full));
+
+	/* Last block returned: queued for release, not kept on @idle for reuse. */
+	spin_lock_irqsave(&pa->lock, flags);
+	meta->nr_clean = bpp;
+	released = pisa_place_meta(meta);
+	spin_unlock_irqrestore(&pa->lock, flags);
+	KUNIT_ASSERT_TRUE(test, released);
+	KUNIT_EXPECT_EQ(test, (unsigned int)meta->on_list, (unsigned int)PISA_LIST_NONE);
+	KUNIT_EXPECT_TRUE(test, list_empty(&pa->full));
+	KUNIT_EXPECT_TRUE(test, list_empty(&pa->idle));
+	KUNIT_EXPECT_EQ(test, pa->num_idle_pages, 0U);
+
+	pisa_schedule_reclaim();
+	KUNIT_ASSERT_TRUE(test, pisa_test_wait_retired(meta));
+
+	/* Retired and leaked: not a PISA page any more, slot and memory still held. */
+	KUNIT_EXPECT_FALSE(test, is_pisa_pfn(pfn));
+	KUNIT_EXPECT_TRUE(test, meta->flags & PISA_QUARANTINED);
+	KUNIT_EXPECT_PTR_EQ(test, pisa_meta_of_pfn(pfn), meta);
+	KUNIT_EXPECT_EQ(test, page_count(page), 1);
+
+	/* Undo the quarantine by hand, so that the test itself leaks nothing. */
+	pisa_meta_clear_flags(meta, PISA_QUARANTINED);
+	pisa_slot_free(meta);
+	KUNIT_EXPECT_PTR_NE(test, pisa_meta_of_pfn(pfn), meta);
+	__free_pages(page, PISA_ORDER);
+}
+
 static struct kunit_case pisa_meta_test_cases[] = {
 	KUNIT_CASE(test_meta_init_and_roundtrip),
 	KUNIT_CASE(test_meta_invalid_phys),
 	KUNIT_CASE(test_meta_active_toggle),
+	KUNIT_CASE(test_alloc_and_recycle),
+	KUNIT_CASE(test_quarantine),
 	{}
 };
 
@@ -108,5 +207,5 @@ static struct kunit_suite pisa_meta_test_suite = {
 };
 
 kunit_test_suite(pisa_meta_test_suite);
-MODULE_DESCRIPTION("KUnit tests for struct pisa_meta table");
+MODULE_DESCRIPTION("KUnit tests for struct pisa_meta table and PISA allocator");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/mm/pisa-meta.c b/mm/pisa-meta.c
index 734f49320047a..41ea277c60f00 100644
--- a/mm/pisa-meta.c
+++ b/mm/pisa-meta.c
@@ -48,6 +48,7 @@
 #include <linux/pisa.h>
 #include <linux/export.h>
 #include <linux/gfp.h>
+#include <linux/jiffies.h>
 #include <linux/memblock.h>
 #include <linux/memory.h>
 #include <linux/moduleparam.h>
@@ -135,6 +136,76 @@ struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn)
 	return &pisa_meta_array[slot - 1];
 }
 
+/*
+ * Update @meta's position on @pa's lists under @pa->lock. When all blocks
+ * become available (avail == bpp), either queues @meta to @pisa_free_list (and
+ * returns true so the caller schedules reclaim) or moves it to @pa->idle.
+ */
+bool pisa_place_meta(struct pisa_meta *meta)
+{
+	struct pisa_alloc *pa = meta->pa;
+	unsigned int avail = pisa_meta_avail(meta), bpp = PISA_BLOCKS(pa->order);
+	u8 to_list;
+
+	lockdep_assert_held(&pa->lock);
+
+	if (avail == bpp) {
+		/* All blocks free: retire immediately if quarantined or over idle cap with idle_ms == 0. */
+		if (pa->num_idle_pages >= pa->max_idle_pages)
+			WRITE_ONCE(pa->idle_jiffies, jiffies);
+		if (unlikely(meta->flags & PISA_QUARANTINED) ||
+		    (pa->num_idle_pages >= pa->max_idle_pages && !READ_ONCE(pisa_idle_ms))) {
+			WRITE_ONCE(meta->on_list, PISA_LIST_NONE);
+			list_del_init(&meta->list);
+			llist_add(&meta->llnode, &pisa_free_list);
+			return true;
+		}
+		pa->num_idle_pages++;
+		/* Clean pages go to the head of @idle, dirty pages to the tail. */
+		to_list = PISA_LIST_IDLE | (meta->nr_dirty ? PISA_LIST_SPARSE : 0);
+	} else if (!avail || unlikely(meta->flags & PISA_QUARANTINED)) {
+		/* Quarantined pages stay on pa->full until all blocks drain. */
+		to_list = PISA_LIST_FULL;
+	} else {
+		/*
+		 * Classify partial pages with hysteresis: >= 75% free is sparse
+		 * (tail of partial list, eligible to drain), <= 50% free is dense
+		 * (head of partial list, preferred for allocation). In between,
+		 * keep the current dense/sparse state.
+		 */
+		to_list = meta->nr_clean ? PISA_LIST_CLEAN : PISA_LIST_DIRTY;
+		if (avail >= bpp - (bpp >> 2))
+			to_list |= PISA_LIST_SPARSE;
+		else if (avail > (bpp >> 1))
+			to_list |= meta->on_list & PISA_LIST_SPARSE;
+	}
+
+	if (to_list != meta->on_list) {
+		struct list_head *head;
+
+		WRITE_ONCE(meta->on_list, to_list);
+		switch (to_list & PISA_LIST_MASK) {
+		case PISA_LIST_FULL:
+			head = &pa->full;
+			break;
+		case PISA_LIST_IDLE:
+			head = &pa->idle;
+			break;
+		case PISA_LIST_CLEAN:
+			head = &pa->partial;
+			break;
+		default:
+			head = &pa->partial_dirty;
+			break;
+		}
+		if (to_list & PISA_LIST_SPARSE)
+			list_move_tail(&meta->list, head);
+		else
+			list_move(&meta->list, head);
+	}
+	return avail == bpp && pa->num_idle_pages > pa->max_idle_pages;
+}
+
 /* PTE for @addr in a vmalloc metadata table, or NULL if not allocated. */
 static pte_t *pisa_meta_pte(unsigned long addr)
 {
diff --git a/mm/pisa-node.c b/mm/pisa-node.c
new file mode 100644
index 0000000000000..fe9f37deac755
--- /dev/null
+++ b/mm/pisa-node.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * PISA per-NUMA-node state: PISA page reservoir and background work.
+ * See Documentation/core-api/pisa.rst for the architecture overview.
+ */
+
+#include <linux/atomic.h>
+#include <linux/pisa.h>
+#include <linux/mm.h>
+#include <linux/nodemask.h>
+#include <linux/rcupdate.h>
+
+#include "pisa-priv.h"
+
+/* Per-NUMA-node PISA state (ring/TX/user allocators, reservoir). */
+struct pisa_node pisa_nodes[MAX_NUMNODES];
+
+/*
+ * Idle PISA page release proceeds in three stages:
+ * 1. Detach onto lockless pisa_free_list and schedule pisa_reclaim_work.
+ * 2. In process context (pisa_release_page()), unmap from all IOMMU domains,
+ *    clear PISA_ACTIVE, and queue pisa_release_page_rcu() via call_rcu().
+ * 3. After an RCU grace period, pisa_release_page_rcu() unfreezes all blocks
+ *    and returns them to the buddy allocator.
+ */
+
+/* RCU callback: unfreeze and return a retired PISA page's blocks to the buddy allocator. */
+static void pisa_release_page_rcu(struct rcu_head *head)
+{
+	/* Read @meta before freeing slot/blocks; both can be reused immediately. */
+	struct pisa_meta *meta = container_of(head, struct pisa_meta, rcu);
+	struct page *page = pisa_meta_to_page(meta);
+	unsigned long flags = READ_ONCE(meta->flags);
+	unsigned int order = meta->pa->order;
+
+	WRITE_ONCE(meta->pa, NULL);
+
+	/* The page has been unmapped from every domain by pisa_release_page() */
+	pisa_slot_free(meta);
+
+	/* Possibly still mapped by a device: leak it. */
+	if (flags & PISA_QUARANTINED)
+		return;
+
+	for (unsigned int i = 0; i < PISA_BLOCKS(order); i++) {
+		struct page *block = page + (i << order);
+
+		page_ref_unfreeze(block, 1);
+		__free_pages(block, order);
+	}
+}
+
+/* Unmap a retired PISA page, clear PISA_ACTIVE, and queue RCU release. */
+void pisa_release_page(struct pisa_meta *meta)
+{
+	/* pisa_unmap_all_domains(meta) will be called here once IOMMU mappings are added. */
+
+	/* Clear PISA_ACTIVE before the RCU grace period so new readers stop entering. */
+	pisa_meta_clear_flags(meta, PISA_ACTIVE);
+	call_rcu(&meta->rcu, pisa_release_page_rcu);
+}
diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
index b52522cb28fcc..776462a2f1ee2 100644
--- a/mm/pisa-priv.h
+++ b/mm/pisa-priv.h
@@ -5,16 +5,45 @@
 
 #include <linux/moduleparam.h>
 #include <linux/pisa-iommu.h>
+#include <linux/pisa-mm.h>
 
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "pisa."
+#include <linux/nodemask.h>
 #include <linux/spinlock.h>
+#include <linux/topology.h>
+
 
 #ifdef CONFIG_PISA
 
 /* Number of order-@order blocks in one PISA page. */
 #define PISA_BLOCKS(order)	(1U << (PISA_ORDER - (order)))
 
+/*
+ * Locking (disjoint groups; locks in different groups do not nest):
+ *
+ * 1. Allocators (mm/pisa-alloc.c, mm/pisa-node.c):
+ *    pisa_allocs_lock (rwlock) -> pa->lock (spinlock)
+ *
+ * 2. Metadata tables (mm/pisa-meta.c):
+ *    pisa_meta_mutex (mutex): init and hotplug page-table population.
+ *    pisa_slot_lock (spinlock): slot allocation and @pisa_meta_array PTE install.
+ */
+
+/*
+ * Value of @meta->on_list: low bits select the target list in @pa, and
+ * PISA_LIST_SPARSE selects tail (list_move_tail) vs head (list_move).
+ */
+enum {
+	PISA_LIST_NONE		= 0,		/* not on an allocator list */
+	PISA_LIST_FULL		= BIT(0),	/* on @pa->full (0 free blocks) */
+	PISA_LIST_IDLE		= BIT(1),	/* on @pa->idle (all blocks free) */
+	PISA_LIST_CLEAN		= BIT(2),	/* on @pa->partial */
+	PISA_LIST_DIRTY		= BIT(3),	/* on @pa->partial_dirty */
+	PISA_LIST_MASK		= 0xf,
+	PISA_LIST_SPARSE	= BIT(4),	/* tail: list_move_tail() */
+};
+
 /* Publish meta->flags into the pfn2slot array. */
 static inline void pisa_pfn2slot_update(const struct pisa_meta *meta)
 {
@@ -42,6 +71,40 @@ static inline void pisa_meta_clear_flags(struct pisa_meta *meta, unsigned long m
 	pisa_pfn2slot_update(meta);
 }
 
+static inline unsigned int pisa_meta_avail(const struct pisa_meta *meta)
+{
+	return meta->nr_clean + meta->nr_dirty;
+}
+
+/* Allocator managing blocks of a fixed order, carved from PISA pages. */
+struct pisa_alloc {
+	/* First cacheline: hot fields touched on block alloc and free. */
+	spinlock_t		lock;
+	u8			order;		/* block order (<= PISA_ORDER) */
+	struct list_head	partial;	/* partial pages with nr_clean > 0 */
+	struct list_head	partial_dirty;	/* partial pages with nr_clean == 0 */
+	struct list_head	idle;		/* completely free PISA pages */
+	struct list_head	full;		/* PISA pages with 0 free blocks */
+	unsigned int		num_idle_pages;
+	unsigned int		max_idle_pages;
+	unsigned long		idle_jiffies;	/* last change of @idle at/above @max_idle_pages */
+	/* Cold. */
+	int			nid;		/* home NUMA node */
+	struct list_head	node;		/* node in pisa_allocs */
+	char			name[48];
+} ____cacheline_aligned;
+
+/* Max block order for predefined per-node allocators in pisa_node.pa[][]. */
+#define PISA_MAX_ALLOC_ORDER	3U
+
+/* Per-NUMA-node PISA state. */
+struct pisa_node {
+	struct pisa_alloc	*pa[2][PISA_MAX_ALLOC_ORDER + 1]; /* [0]=RW, [1]=RO */
+} ____cacheline_aligned_in_smp;
+
+/* Per-NUMA-node PISA state (ring/TX/user allocators, reservoir). */
+extern struct pisa_node pisa_nodes[MAX_NUMNODES];
+
 int pisa_meta_ensure_pfn(unsigned long pfn, bool can_block);
 void pisa_slots_configure(void);
 
@@ -57,5 +120,30 @@ static inline struct page *pisa_meta_to_page(const struct pisa_meta *meta)
 
 void pisa_slot_free(struct pisa_meta *meta);
 
+static inline int pisa_sanitize_nid(int nid)
+{
+	if ((unsigned int)nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY))
+		nid = numa_mem_id();
+	if (!node_state(nid, N_MEMORY))
+		nid = first_memory_node;
+	return nid;
+}
+
+/* Return the predefined per-node allocator for (@nid, @order, @read_only), or NULL. */
+static inline struct pisa_alloc *pisa_node_pa(int nid, unsigned int order, bool read_only)
+{
+	return order > PISA_MAX_ALLOC_ORDER ? NULL :
+	       pisa_nodes[pisa_sanitize_nid(nid)].pa[read_only][order];
+}
+
+/* pisa-alloc.c, also used by the per-node code in pisa-node.c */
+struct pisa_alloc *pisa_alloc_create(int nid, unsigned int order, enum dma_data_direction dir);
+__printf(2, 3)
+void pisa_alloc_set_name(struct pisa_alloc *pa, const char *fmt, ...);
+bool pisa_place_meta(struct pisa_meta *meta);
+extern struct llist_head pisa_free_list;
+extern unsigned int pisa_idle_ms;
+void pisa_release_page(struct pisa_meta *meta);
+
 #endif /* CONFIG_PISA */
 #endif /* _MM_PISA_PRIV_H */
-- 
2.56.1.809.ga0b61035b5-goog

