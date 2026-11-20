Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136834;
	b=K1PQ7YVTl7f48Z6Ei98LLxZmloL5ga+SgjjRhNYkkj1t3Rn3DmCTsoNUDavy1/UVyzjF
	 Zb2vgEfWIa6DBLLaAQ0yjo5GRlKXQSCGfsb5IbfCDBuH1DSZ7rVo6rLIVaYjIebK2qTKB
	 bCkx5AJ3VgQorQfQbnDbYtE46sxRmVTMdG5NdxOEHqo9cx7kq6jr6YbF6zsS2ADGYjKGT
	 DSH0GYNEEAg613/dI/4uQj7sBkow0MuLf2ZZ/DlUoMpzyJ7bd9jwfsVPyelAuoJv63mJ3
	 jncw/9y/hAp3O2d6ZtfO8W/yhUKEOSZ9PwTRJ0zMPmgRQnnRAmhrSYs2cB4mfvfcu7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136834;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=o7dtFNk0+yIq8Hv4mPyl9NzWuSlgV33rwmuJhHvs0eQ=;
	b=MsCizrLVMnqMYhT5T6+yQki2q0YyBSl7d/VyZZYtpDbTtv3Q6t4XLPFXPOCFmh8UcOUa
	 4qQmXmUmU/MjQdDPja6iU9hTOeRqzfl4i6W65gIjEIr0F0Wlc5LDvXGAY6BkcvsSkYMct
	 ulbOG2XedRpk/tyxh/Y56sgHyvYlDR0YQmgBeoqs/k7C5j7mXZxEqMJtQtIrkv3GI8spv
	 KVDf2KTBPPp666ubR9oLvb+dg010rHMlrxtGxbt5fNZCJyFO9MaiEq/7nsOBFJIC/PBNQ
	 89kM2o4fVuNI+5bUFX7ZJ58If71KQMIIDAqEKJ68aGx3xuey16ommVOKcpIPe14tCRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X7v3p1DP;
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E94606A9E9
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23E94606A9E9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X7v3p1DP
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c40bbd26f74so30684866b.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136831; x=1795741631; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o7dtFNk0+yIq8Hv4mPyl9NzWuSlgV33rwmuJhHvs0eQ=;
        b=X7v3p1DPUKFutq6zgum+GDEW9ZEuVvY5oxed2p8qwhnG9zA5QDX7f9EWGWAPnDIJ5L
         7eKzTINs4ZEoqb70mgPwGYXLvlTc3y8Q1LlDLWQ4ZgfYqrEQSIzO4xSa4zfvQoMePbcO
         oIyTvXT9iUrjODzNXlnb96HXbkIcpMUwdgq58UAwlqzucKfIV7Y8fNH0S+N7qgJFDPVA
         UpfV0iq5FHKByUHUk2uM15G4+bWoRrl+jMhDCmskD7fXu0wSU7EmKHK5kyMOttGMyg9G
         j+fN0vjSY7+DDcwiGGRJCzutQsUt8hRrb+/Z2yventqL2QVOZiLXusOMbcNLY2Mvc6Cm
         wFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136831; x=1795741631;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o7dtFNk0+yIq8Hv4mPyl9NzWuSlgV33rwmuJhHvs0eQ=;
        b=TVVD/OIZJK+/K8hyGBsGJiXtb4WkYsgBPGA8AaUd8SWBU5dvaCv95ZUJEiKuWr5X8F
         7RKCvVvXaMOk8J5W7VBWXsM8FDLalKglLHQ4voqLrdDdBjsCds4LmBs0YDZEIpH4QSDD
         KWZ532uY6pLp39lHjLwUVBHigSZMa16zeS64zqLlpq2WRO5D7fE1jzHkRy1Rojo8vthO
         nkmeKFt4nuoQS1QElsHzBUv6GdzWrJ41ESicX69TxAk4VQ9b+RfdK3jzXliUkcwSnEAg
         f7JiG6XVkFyP63Y2/COZ+fizuiliPcd5vFXibgASN09CfVlakz+VjB0S7E3xVoex8vBv
         U7yw==
X-Forwarded-Encrypted: i=1; AL+hErHpR4BkrXV0yeP/x8FZSvH1bWv2N7cqoYRtnLV5dlcRLTKGE448U8mSX4jZhdbiHwxeLEhxV3i9v0k=@vger.kernel.org
X-Gm-Message-State: APuU4Z8WM4PXXNh6KkGUNl3LR6RiKu//DbVM/hHslQCGENLPkEg1bobM
	zblVsmIfQBT+LVd2cAi5y0nhyoU8vNpLNg9dcbbK1nTy9bdHkxAhYCG0wdqZw3Qqsn/U3Lf9jrd
	GaeUF6Q==
X-Received: from ejg13-n1.prod.google.com ([2002:a17:906:e10d:10b0:c50:4d3a:f224])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:68db:b0:c50:475d:980e
 with SMTP id a640c23a62f3a-c513ac9c694mr102081866b.38.1795136831080; Thu, 19
 Nov 2026 17:07:11 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:39 +0000
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
Message-ID: <20261120010655.467825-10-lrizzo@google.com>
Subject: [RFC PATCH v3 09/25] mm: Add per-CPU block caches to PISA allocators
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

Every block allocation and free takes the allocator's lock. Highly
concurrent users e.g. socket tx fragments, can cause significant lock
contention.

Add pisa_enable_pcp(), an opt-in per-CPU front cache, similar
to the page allocator's per-CPU lists:

- Each per-CPU cache keeps up to 64 free blocks, and refills it from
  the main allocator in batches of 32.
- returned blocks belonging to the local NUMA node are kept in the local cache.
- returned blocks belonging to a remote NUMA node are returned to the
  proper per-node allocator.
The cache is fully integrated with the shrinker and CPU offlining to
drain the cache.

Enable per-CPU caches for the per-node order-0 RW and SKB_FRAG_PAGE_ORDER RO
allocators.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 mm/pisa-alloc.c | 272 ++++++++++++++++++++++++++++++++++++++++++++++--
 mm/pisa-kunit.c |  79 ++++++++++++++
 mm/pisa-priv.h  |  11 +-
 3 files changed, 348 insertions(+), 14 deletions(-)

diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
index eda12d475c9a7..896709303f258 100644
--- a/mm/pisa-alloc.c
+++ b/mm/pisa-alloc.c
@@ -9,6 +9,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/cache.h>
+#include <linux/cpuhotplug.h>
 #include <linux/device.h>
 #include <linux/dma-direct.h>
 #include <linux/dma-map-ops.h>
@@ -26,6 +27,7 @@
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
 #include <linux/page_owner.h>
+#include <linux/percpu.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/page_table_check.h>
 #include <linux/pci.h>
@@ -324,13 +326,168 @@ static bool pisa_return_block_locked(struct pisa_alloc *pa, struct page *block)
 	return pisa_place_meta(meta);
 }
 
+/* Return @n freed blocks to @pa under a single acquisition of @pa->lock. */
+static void pisa_free_bulk(struct pisa_alloc *pa, unsigned int n, struct page **blocks)
+{
+	bool released = false;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pa->lock, flags);
+	for (unsigned int i = 0; i < n; i++) {
+		if (likely(!is_pisa_block_poisoned(pa, blocks[i])))
+			released |= pisa_return_block_locked(pa, blocks[i]);
+	}
+	spin_unlock_irqrestore(&pa->lock, flags);
+
+	if (released)
+		pisa_schedule_reclaim();
+}
+
+/*
+ * Per-CPU block cache: each CPU caches up to PISA_PCP_HIGH free blocks
+ * (refcount 0, not in bitmaps), refilling and flushing in PISA_PCP_BATCH
+ * batches. Drained by the shrinker and CPU hotplug.
+ */
+#define PISA_PCP_BATCH	32U	/* blocks moved per refill or flush */
+
+struct pisa_pcp {
+	spinlock_t	lock;	/* by this CPU, or by a drain from any CPU */
+	unsigned int	count;
+	struct page	*blocks[PISA_PCP_HIGH];
+};
+
+/* Max blocks moved per per-CPU cache refill or flush (1..PISA_PCP_BATCH). */
+static unsigned int pisa_pcp_batch __read_mostly = PISA_PCP_BATCH;
+
+static int pisa_pcp_batch_set(const char *val, const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, 1, PISA_PCP_BATCH);
+}
+
+static const struct kernel_param_ops pisa_pcp_batch_ops = {
+	.set = pisa_pcp_batch_set,
+	.get = param_get_uint,
+};
+module_param_cb(pcp_batch, &pisa_pcp_batch_ops, &pisa_pcp_batch, 0644);
+
+static inline unsigned int pisa_pcp_batch_order(const struct pisa_alloc *pa)
+{
+	return max(1U, READ_ONCE(pisa_pcp_batch) >> pa->order);
+}
+
+/* Cache @n blocks at refcount 0 on this CPU, @n <= PISA_PCP_BATCH. */
+static void pisa_pcp_push(struct pisa_alloc *pa, unsigned int n, struct page **blocks)
+{
+	unsigned int batch = pisa_pcp_batch_order(pa);
+	unsigned int high = max(2U, PISA_PCP_HIGH >> pa->order);
+	struct pisa_pcp *pcp;
+	unsigned long flags;
+
+	/* @pcp->lock protects the cache: migrating to another CPU here is harmless. */
+	pcp = raw_cpu_ptr(pa->pcp);
+	spin_lock_irqsave(&pcp->lock, flags);
+	for (unsigned int i = 0; i < n; i++) {
+		if (pcp->count >= high) {
+			/* Keep the most recently freed, likely still in cache. */
+			pisa_free_bulk(pa, batch, pcp->blocks);
+			pcp->count -= batch;
+			memmove(pcp->blocks, pcp->blocks + batch,
+				pcp->count * sizeof(*pcp->blocks));
+		}
+		pcp->blocks[pcp->count++] = blocks[i];
+	}
+	spin_unlock_irqrestore(&pcp->lock, flags);
+}
+
+/* Take up to @nr blocks, at refcount 0, from this CPU's cache. */
+static unsigned int pisa_pcp_pop(struct pisa_alloc *pa, unsigned int nr, struct page **out)
+{
+	struct pisa_pcp *pcp;
+	unsigned int got = 0;
+	unsigned long flags;
+
+	/* @pcp->lock protects the cache: migrating to another CPU here is harmless. */
+	pcp = raw_cpu_ptr(pa->pcp);
+	spin_lock_irqsave(&pcp->lock, flags);
+	while (got < nr && pcp->count)
+		out[got++] = pcp->blocks[--pcp->count];
+	spin_unlock_irqrestore(&pcp->lock, flags);
+
+	return got;
+}
+
+/* Return the blocks @cpu caches for @pa. */
+static void pisa_pcp_drain_cpu(struct pisa_alloc *pa, int cpu)
+{
+	struct pisa_pcp *pcp = per_cpu_ptr(pa->pcp, cpu);
+
+	if (!READ_ONCE(pcp->count))
+		return;
+	guard(spinlock_irqsave)(&pcp->lock);
+	if (pcp->count) {
+		pisa_free_bulk(pa, pcp->count, pcp->blocks);
+		pcp->count = 0;
+	}
+}
+
+/* Drain every non-empty CPU cache of @pa. */
+void pisa_pcp_drain(struct pisa_alloc *pa)
+{
+	int cpu;
+
+	/* Pairs with smp_store_release() in pisa_enable_pcp(). */
+	if (!smp_load_acquire(&pa->pcp))
+		return;
+	for_each_possible_cpu(cpu)
+		pisa_pcp_drain_cpu(pa, cpu);
+}
+
+/* Blocks in @pa's caches, for shrinker and debugfs. */
+static unsigned long pisa_pcp_count(struct pisa_alloc *pa)
+{
+	unsigned long n = 0;
+	int cpu;
+
+	if (!pa->pcp)
+		return 0;
+	for_each_possible_cpu(cpu) {
+		/* A racy sum is good enough for reclaim and statistics. */
+		n += data_race(per_cpu_ptr(pa->pcp, cpu)->count);
+	}
+	return n;
+}
+
+/**
+ * pisa_enable_pcp - Put per-CPU block caches in front of an allocator
+ * @pa: Allocator to cache
+ *
+ * Return: 0, or -ENOMEM; @pa works without the cache.
+ */
+int pisa_enable_pcp(struct pisa_alloc *pa)
+{
+	struct pisa_pcp __percpu *pcp;
+	int cpu;
+
+	if (!pa || pa->pcp)
+		return 0;
+	pcp = alloc_percpu(struct pisa_pcp);
+	if (!pcp)
+		return -ENOMEM;
+	for_each_possible_cpu(cpu)
+		spin_lock_init(&per_cpu_ptr(pcp, cpu)->lock);
+	/* Publish initialized locks; readers depend on the pointer. */
+	if (cmpxchg_release(&pa->pcp, NULL, pcp))
+		free_percpu(pcp);
+	return 0;
+}
+
 static DEFINE_MUTEX(pisa_init_mutex);
 
 /* Return *@pap, creating and publishing it under @pisa_init_mutex if NULL. */
-__printf(5, 6)
+__printf(6, 7)
 struct pisa_alloc *pisa_alloc_ensure(struct pisa_alloc **pap, int nid,
 				     unsigned int order, enum dma_data_direction dir,
-				     const char *fmt, ...)
+				     bool pcp, const char *fmt, ...)
 {
 	/* Pairs with smp_store_release() below. */
 	struct pisa_alloc *pa = smp_load_acquire(pap);
@@ -349,6 +506,8 @@ struct pisa_alloc *pisa_alloc_ensure(struct pisa_alloc **pap, int nid,
 		va_start(args, fmt);
 		vsnprintf(pa->name, sizeof(pa->name), fmt, args);
 		va_end(args);
+		if (pcp)
+			pisa_enable_pcp(pa);
 		/* Pairs with smp_load_acquire() in lockless readers. */
 		smp_store_release(pap, pa);
 	}
@@ -392,7 +551,9 @@ bool __pisa_has_free_blocks_rx(unsigned int order, int nid)
 	struct pisa_alloc *pa = pisa_node_pa(nid, order, false);
 
 	return pa &&
-	       (!list_empty_careful(&pa->partial) ||
+	       /* Pairs with cmpxchg_release() in pisa_enable_pcp(). */
+	       ((smp_load_acquire(&pa->pcp) && raw_cpu_read(pa->pcp->count)) ||
+		!list_empty_careful(&pa->partial) ||
 		!list_empty_careful(&pa->partial_dirty) ||
 		!list_empty_careful(&pa->idle) ||
 		READ_ONCE(pisa_nodes[pa->nid].nr_pages));
@@ -636,6 +797,58 @@ static unsigned long __pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp, unsigne
 	return n;
 }
 
+/* Allocate @nr_pages blocks through this CPU's cache, refilling in batches on miss. */
+static unsigned long pisa_pcp_alloc(struct pisa_alloc *pa, gfp_t gfp, unsigned long nr_pages,
+				    struct page **page_array, bool frozen)
+{
+	unsigned int pcp_batch = pisa_pcp_batch_order(pa);
+	unsigned long got, j = 0;
+
+	got = pisa_pcp_pop(pa, nr_pages, page_array);
+	if (got < nr_pages) {
+		if (nr_pages - got >= pcp_batch) {
+			got += __pisa_alloc_bulk(pa, gfp, nr_pages - got,
+						 page_array + got, false, true);
+		} else {
+			struct page *batch[PISA_PCP_BATCH];
+			unsigned long n, i;
+
+			n = __pisa_alloc_bulk(pa, gfp, pcp_batch, batch, false, true);
+			for (i = 0; i < n && got < nr_pages; i++)
+				page_array[got++] = batch[i];
+			if (i < n) {
+				if (pa->nid == numa_mem_id())
+					pisa_pcp_push(pa, n - i, batch + i);
+				else
+					pisa_free_bulk(pa, n - i, batch + i);
+			}
+		}
+	}
+
+	for (unsigned long i = 0; i < got; i++) {
+		struct page *block = page_array[i];
+
+		page_array[i] = NULL;
+		/* Poisoned while cached: leak it, as pisa_scan_bitmap() does. */
+		if (is_pisa_block_poisoned(pa, block))
+			continue;
+		pisa_block_prep(block);
+		if (want_init_on_alloc(gfp)) {
+			memset(page_address(block), 0, PAGE_SIZE << pa->order);
+			if (frozen) /* Order zeroing before caller publishes the page. */
+				smp_wmb();
+		}
+		if (!frozen)
+			page_ref_unfreeze(block, 1);
+		page_array[j++] = block;
+	}
+	/* Replace blocks dropped as poisoned, so that callers do not see a short allocation. */
+	if (unlikely(j < got))
+		j += __pisa_alloc_bulk(pa, gfp, nr_pages - j, page_array + j,
+				       want_init_on_alloc(gfp), frozen);
+	return j;
+}
+
 /**
  * pisa_alloc_bulk - Allocate up to @nr_pages blocks from @pa
  * @pa: Allocator to allocate from
@@ -665,11 +878,16 @@ unsigned long pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp,
 			i++;
 			continue;
 		}
+
 		/* Fill the run of @n NULL entries at @i. */
 		for (n = 1; i + n < nr_pages && !page_array[i + n]; n++)
 			;
-		got = __pisa_alloc_bulk(pa, gfp, n, page_array + i,
-					want_init_on_alloc(gfp), frozen);
+		/* Pairs with smp_store_release() in pisa_enable_pcp(). */
+		if (smp_load_acquire(&pa->pcp) && pa->nid == numa_mem_id())
+			got = pisa_pcp_alloc(pa, gfp, n, page_array + i, frozen);
+		else
+			got = __pisa_alloc_bulk(pa, gfp, n, page_array + i,
+						want_init_on_alloc(gfp), frozen);
 		i += got;
 		if (got < n)
 			break;
@@ -812,6 +1030,7 @@ __pisa_alloc_map_coherent(struct device *dev, struct iommu_domain *domain,
 	pa = pisa_node_pa(dev_to_node(dev), 0, false);
 	if (!pa)
 		return NULL;
+	pisa_pcp_drain(pa);
 
 	nblocks = size >> PAGE_SHIFT;
 	align_mask = (1UL << get_order(size)) - 1;
@@ -911,6 +1130,16 @@ bool __pisa_free_page(struct page *page, unsigned int order)
 	if (want_init_on_free())
 		memset(page_address(page), 0, PAGE_SIZE << pa->order);
 
+	/* Pairs with cmpxchg_release() in pisa_enable_pcp(). */
+	if (smp_load_acquire(&pa->pcp) && pa->nid == numa_mem_id() &&
+	    page_to_nid(page) == numa_mem_id()) {
+		if (pisa_page_can_recycle(page)) {
+			pisa_pcp_push(pa, 1, &page);
+			return true;
+		}
+		pisa_pcp_drain_cpu(pa, raw_smp_processor_id());
+	}
+
 	spin_lock_irqsave(&pa->lock, flags);
 	should_release = pisa_return_block_locked(pa, page);
 	spin_unlock_irqrestore(&pa->lock, flags);
@@ -924,14 +1153,16 @@ bool __pisa_free_page(struct page *page, unsigned int order)
 /* Shrinker: releases reservoir pages first, then idle allocator pages. */
 static unsigned long pisa_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	unsigned long nr = pisa_reservoir_count();
+	unsigned long nr = pisa_reservoir_count() << PISA_ORDER;
 	struct pisa_alloc *pa;
 
 	guard(read_lock)(&pisa_allocs_lock);
-	list_for_each_entry(pa, &pisa_allocs, node)
-		nr += READ_ONCE(pa->num_idle_pages);
+	list_for_each_entry(pa, &pisa_allocs, node) {
+		nr += (unsigned long)READ_ONCE(pa->num_idle_pages) << PISA_ORDER;
+		nr += pisa_pcp_count(pa) << pa->order;
+	}
 
-	return nr << PISA_ORDER;
+	return nr;
 }
 
 /* Detach PISA pages from @list onto @release_list up to @nr_to_scan base pages. */
@@ -967,6 +1198,8 @@ VISIBLE_IF_KUNIT unsigned long pisa_shrink_scan(struct shrinker *shrink, struct
 	if (freed < sc->nr_to_scan) {
 		read_lock(&pisa_allocs_lock);
 		list_for_each_entry(pa, &pisa_allocs, node) {
+			/* Cached blocks keep PISA pages from going idle. */
+			pisa_pcp_drain(pa);
 			freed += pisa_shrink_list(&pa->lock, &pa->idle,
 						  &pa->num_idle_pages, &release_list,
 						  sc->nr_to_scan - freed);
@@ -989,6 +1222,19 @@ VISIBLE_IF_KUNIT unsigned long pisa_shrink_scan(struct shrinker *shrink, struct
 	return freed ?: SHRINK_STOP;
 }
 
+/* Return the blocks a dead CPU cached, which nothing else would. */
+static int pisa_cpu_dead(unsigned int cpu)
+{
+	struct pisa_alloc *pa;
+
+	guard(read_lock)(&pisa_allocs_lock);
+	list_for_each_entry(pa, &pisa_allocs, node)
+		/* Pairs with smp_store_release() in pisa_enable_pcp(). */
+		if (smp_load_acquire(&pa->pcp))
+			pisa_pcp_drain_cpu(pa, cpu);
+	return 0;
+}
+
 static int __init pisa_init(void)
 {
 	struct shrinker *shrink;
@@ -1001,9 +1247,9 @@ static int __init pisa_init(void)
 	/* Preallocate the supported per-node allocators. */
 	for_each_node_state(nid, N_MEMORY) {
 		pisa_alloc_ensure(&pisa_nodes[nid].pa[0][0], nid, 0,
-				  DMA_BIDIRECTIONAL, "pisa_o0_n%d", nid);
+				  DMA_BIDIRECTIONAL, true, "pisa_o0_n%d", nid);
 		pisa_alloc_ensure(&pisa_nodes[nid].pa[1][SKB_FRAG_PAGE_ORDER],
-				  nid, SKB_FRAG_PAGE_ORDER, DMA_TO_DEVICE,
+				  nid, SKB_FRAG_PAGE_ORDER, DMA_TO_DEVICE, true,
 				  "pisa_ro_o%u_n%d", SKB_FRAG_PAGE_ORDER, nid);
 	}
 
@@ -1012,6 +1258,10 @@ static int __init pisa_init(void)
 	if (!pisa_wq)
 		pr_warn("pisa: no reclaim workqueue, falling back to system_wq\n");
 
+	if (cpuhp_setup_state_nocalls(CPUHP_BP_PREPARE_DYN, "iommu/pisa:dead", NULL,
+				      pisa_cpu_dead) < 0)
+		pr_warn("pisa: no CPU hotplug callback, offline CPUs keep cached blocks\n");
+
 	shrink = shrinker_alloc(0, "pisa");
 	if (!shrink) {
 		pr_warn("pisa: shrinker registration failed\n");
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
index 1040786330cef..0f8cc9baf5d28 100644
--- a/mm/pisa-kunit.c
+++ b/mm/pisa-kunit.c
@@ -583,6 +583,83 @@ static void test_dev_pisa_attrs(struct kunit *test)
 	device_unregister(dev);
 }
 
+static void test_pcp_cache(struct kunit *test)
+{
+	struct page *blocks[PISA_PCP_HIGH + 1];
+	struct pisa_alloc *pa;
+	struct page *p1, *p2;
+	unsigned int i, n = 0;
+
+	KUNIT_EXPECT_EQ(test, pisa_enable_pcp(NULL), 0);
+	pa = pisa_node_pa(numa_mem_id(), 0, false);
+	KUNIT_ASSERT_NOT_NULL(test, pa);
+	KUNIT_ASSERT_EQ(test, pisa_enable_pcp(pa), 0);
+
+	p1 = pisa_alloc(pa, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p1);
+	__free_page(p1);
+	p2 = pisa_alloc(pa, GFP_KERNEL | __GFP_ZERO);
+	KUNIT_EXPECT_PTR_EQ(test, p2, p1);
+	if (p2)
+		__free_page(p2);
+
+	/* Overflowing PISA_PCP_HIGH flushes a batch back to the allocator. */
+	for (i = 0; i < ARRAY_SIZE(blocks); i++) {
+		blocks[i] = pisa_alloc(pa, GFP_KERNEL);
+		if (!blocks[i])
+			break;
+		n++;
+	}
+	KUNIT_EXPECT_EQ(test, n, (unsigned int)ARRAY_SIZE(blocks));
+	for (i = 0; i < n; i++)
+		__free_page(blocks[i]);
+}
+
+static void test_gfp_pisa(struct kunit *test)
+{
+	struct shrink_control sc = { .nr_to_scan = ULONG_MAX };
+	struct device dev = { .numa_node = first_memory_node };
+	struct page *p, *p_ro, *bulk[4] = {};
+	unsigned long n;
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+	pisa_shrink_scan(NULL, &sc);
+	KUNIT_EXPECT_EQ(test, pisa_rx_gfp(NULL), 0);
+	KUNIT_EXPECT_EQ(test, pisa_rx_gfp(&dev), 0);
+	KUNIT_EXPECT_FALSE(test, pisa_has_free_blocks_rx(&dev, 0, first_memory_node));
+
+	dev.pisa_rx_bufs = true;
+	KUNIT_EXPECT_EQ(test, pisa_rx_gfp(&dev), __GFP_PISA_RW);
+
+	p = alloc_pages_node(first_memory_node, GFP_KERNEL | pisa_rx_gfp(&dev), 0);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	if (p) {
+		KUNIT_EXPECT_TRUE(test, is_pisa_page(p));
+		KUNIT_EXPECT_EQ(test, pisa_meta_of_pfn(page_to_pfn(p))->prot,
+				IOMMU_READ | IOMMU_WRITE);
+		__free_page(p);
+		KUNIT_EXPECT_TRUE(test, pisa_has_free_blocks_rx(&dev, 0, first_memory_node));
+	}
+
+	p_ro = alloc_pages(GFP_KERNEL | __GFP_COMP | __GFP_PISA,
+			   SKB_FRAG_PAGE_ORDER);
+	KUNIT_ASSERT_NOT_NULL(test, p_ro);
+	if (p_ro) {
+		KUNIT_EXPECT_TRUE(test, is_pisa_page(p_ro));
+		KUNIT_EXPECT_EQ(test, pisa_meta_of_pfn(page_to_pfn(p_ro))->prot,
+				IOMMU_READ);
+		__free_pages(p_ro, SKB_FRAG_PAGE_ORDER);
+	}
+
+	n = alloc_pages_bulk_node(GFP_KERNEL | __GFP_PISA_RW, first_memory_node,
+				  ARRAY_SIZE(bulk), bulk);
+	KUNIT_EXPECT_EQ(test, n, ARRAY_SIZE(bulk));
+	for (int i = 0; i < n; i++) {
+		KUNIT_EXPECT_TRUE(test, is_pisa_page(bulk[i]));
+		__free_page(bulk[i]);
+	}
+}
+
 static void test_reservoir_and_scrubber(struct kunit *test)
 {
 	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
@@ -601,6 +678,8 @@ static struct kunit_case pisa_meta_test_cases[] = {
 #endif
 	KUNIT_CASE(test_coherent_alloc_and_free),
 	KUNIT_CASE(test_dev_pisa_attrs),
+	KUNIT_CASE(test_pcp_cache),
+	KUNIT_CASE(test_gfp_pisa),
 	KUNIT_CASE(test_reservoir_and_scrubber),
 	{}
 };
diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
index fb26eb3aa9b37..60120a05082a9 100644
--- a/mm/pisa-priv.h
+++ b/mm/pisa-priv.h
@@ -15,6 +15,7 @@
 #include <linux/topology.h>
 #include <linux/workqueue.h>
 
+struct pisa_pcp;
 
 #ifdef CONFIG_IOMMU_DMA
 int iommu_get_dma_cookie(struct iommu_domain *domain);
@@ -30,7 +31,7 @@ void iommu_put_dma_cookie(struct iommu_domain *domain);
  * Locking (disjoint groups; locks in different groups do not nest):
  *
  * 1. Allocators (mm/pisa-alloc.c, mm/pisa-node.c):
- *    pisa_allocs_lock (rwlock) -> pa->lock (spinlock)
+ *    pisa_allocs_lock (rwlock) -> pcp->lock (spinlock) -> pa->lock (spinlock)
  *    pisa_nodes[].lock (spinlock): leaf lock over a node's reservoir.
  *
  * 2. Metadata tables (mm/pisa-meta.c):
@@ -100,6 +101,7 @@ struct pisa_alloc {
 	spinlock_t		lock;
 	u8			order;		/* block order (<= PISA_ORDER) */
 	u8			prot;		/* IOMMU_READ and/or IOMMU_WRITE */
+	struct pisa_pcp __percpu *pcp;
 	struct list_head	partial;	/* partial pages with nr_clean > 0 */
 	struct list_head	partial_dirty;	/* partial pages with nr_clean == 0 */
 	struct list_head	idle;		/* completely free PISA pages */
@@ -200,10 +202,13 @@ static inline void pisa_alloc_backoff(struct pisa_node *node, bool can_block)
 struct pisa_alloc *pisa_alloc_create(int nid, unsigned int order, enum dma_data_direction dir);
 __printf(2, 3)
 void pisa_alloc_set_name(struct pisa_alloc *pa, const char *fmt, ...);
-__printf(5, 6)
+__printf(6, 7)
 struct pisa_alloc *pisa_alloc_ensure(struct pisa_alloc **pap, int nid,
 				     unsigned int order, enum dma_data_direction dir,
-				     const char *fmt, ...);
+				     bool pcp, const char *fmt, ...);
+#define PISA_PCP_HIGH		64U	/* blocks cached per CPU at most */
+int pisa_enable_pcp(struct pisa_alloc *pa);
+void pisa_pcp_drain(struct pisa_alloc *pa);
 bool pisa_place_meta(struct pisa_meta *meta);
 extern struct llist_head pisa_free_list;
 extern unsigned int pisa_idle_ms;
-- 
2.56.1.809.ga0b61035b5-goog

