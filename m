Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136848;
	b=0wm5oCqt1txBdaS46hmDqyXfeVkjWcutsuIy219PbqE9cmBbwpjRlLDL0kMZUqeUUm9r
	 BmUHS3w/ptkNGPAyFHeN+7phNsC7litvQ9FdExfDftcR8BvQKs54Uq0gQWiH7P9VcGcom
	 m9GlJeDAgWSdPfr4rKC67iHuafksIDcn83McOz038EPGhdYdXATSCvw719pIKbwanXibA
	 2qRe+/sM0xrZVXJ4bLAa1lHGXQU9m5Dx4wqbfr9dylTLSWXF9Z25n6Pu1ufsMrjdILKIP
	 7rFZFnKB7wId7uPIGfQUPTVjCMfJCJmIgh/9dnm8oO2krWbnl4rlbpC3issRVNc/whw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136848;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=fMOf1Ds2e62LlBqkJZKHMBB0M6dJer17XuuIKiucu3Y=;
	b=5C0/8UdHD2VO7uglO1XvnWz+Tgwn56x7TbHZaXbUVROjQYUvSdU5PEBPtopIHKfMN3Yg
	 q88OpR+E5s108QAQ0ybB1mYNI4i2tnsiWQQikxvWLGFhMoJYEKsz+rIJl9g2lyFt9BX0f
	 4TQsGZM+ypXy8ZlHKxLxVUVOFjwohTwo3i0r2SvvRNeZZxEEh0JF8L/C5XFel6RWT7pFl
	 2oeXkI3t0WlxT79gyUOvvV7ovxHCo6SMzxU1c2ijtEj3hhpf9+m5YS22fREz+xXzya9Tk
	 lSQWgUpvL9M2tFmenvRoe6Dtq66TXird21j4fDwXGfBza6UeIOJPFo+tGv8jnmwI9KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=i189We0s;
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337E86071100
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 337E86071100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=i189We0s
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c50657eaef0so29224966b.3
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136845; x=1795741645; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fMOf1Ds2e62LlBqkJZKHMBB0M6dJer17XuuIKiucu3Y=;
        b=i189We0saAs5Bp4V8qY4wovUVYY62qhNjhuPNGwmz2WgZQ2CjBeaEBLjSJSzSIAZJt
         DZxAPxymE5BFZbHHFMbj1tXyYYzO4odE2OnCKoilxHKM4yjK00PxWU16RP55tGmEAHR1
         d+HYtBK5bCcuh1tNyTGk42cSDCRjrH0HmbFLTpuHFoducY6pxlfzx9ul7OKwbjd9R/BO
         xYcgbROLh65nUCDV6nciy3xsI/Gb2YvOiHT1BDrxY5da5UM46yXKhLNprIcXTlAucPE3
         5FK86P/pTMhAdi+DPKRuotApE88SwvUQQgoe5bvUUq3l3XttpSuc5883t56PwYnUZNwB
         +/2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136845; x=1795741645;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fMOf1Ds2e62LlBqkJZKHMBB0M6dJer17XuuIKiucu3Y=;
        b=Vg/IGLTyHYgxAFbFowzpbWdUp921/pKoDu7C0EvS4XtduILxRyAEjnYmq/Tt5HiTpd
         TFW0o6DQDwfwCJnTYlDmQjsoSmXJKkBPpUbWRIfudQTeiTYfK9sjjiaTh8iyamjUQ+BU
         vPUPEq9tj2tDwSAtqCmlt/jmRKD/RvGTt8dUzEJ/jsmPuA10TpB4r4yjaWWAsi8w1GH+
         kUhA7KhKbd4cdonKIgYPXqbvFnBxsAIgOZLLBrJmyt/zEGh85dhDz7VIFU0OGPjFNzj8
         2ZI6fMPEUQSTiz8MJRunCtWeaFe0wwPbTnlfrND1Qtuw0i3CFUOutjK9FNr+x2JlVZWd
         LNAQ==
X-Forwarded-Encrypted: i=1; AL+hErElE/r/J/kNf5FgbtLRv1nzVIMyFfyuuA3JFreDsTP1wF1OzB63xGVCq1fdCpelqTf2n+EkSF0QqZI=@vger.kernel.org
X-Gm-Message-State: APuU4Z8hyVV2lR9MU+WctV2Ebv9+olFmmQl1ZUOhmUeGIe3dSfat2Y1J
	6XYBF9urchKHajwaLqOJ4ppm0G7dEv55CdxJ+4vQ8EL2wcJGxUvWvAcuuSSI/OTQZXv7Gt5GsBm
	6G/QHbg==
X-Received: from ejpa4.prod.google.com ([2002:a17:906:6704:b0:c50:5fd5:2043])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9d81:b0:c51:3697:d0de
 with SMTP id a640c23a62f3a-c513a81488emr104092666b.20.1795136843993; Thu, 19
 Nov 2026 17:07:23 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:51 +0000
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
Message-ID: <20261120010655.467825-22-lrizzo@google.com>
Subject: [RFC PATCH v3 21/25] mm: Add PISA statistics and debugfs
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

PISA allocation and mapping failures silently fall back to standard page
allocation and per-buffer DMA mappings, making performance regressions
hard to diagnose without observability.

Add per-allocator, per-node reservoir, user-page migration, and global
shrinker/reclaim counters, and expose them via /sys/kernel/debug/pisa/allocs.
Also emit a one-shot dmesg warning on the first 2MB buddy allocation
failure.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/pisa-map.c   |  91 ++++++++++++-
 include/linux/pisa-iommu.h |  20 +++
 include/linux/pisa.h       |   2 +
 mm/pisa-alloc.c            | 270 +++++++++++++++++++++++++++++++++----
 mm/pisa-kunit.c            |   6 +-
 mm/pisa-node.c             |  40 ++++++
 mm/pisa-priv.h             |  57 +++++++-
 mm/pisa-user.c             |  71 +++++++++-
 net/core/pisa-net.c        |   2 +
 9 files changed, 521 insertions(+), 38 deletions(-)

diff --git a/drivers/iommu/pisa-map.c b/drivers/iommu/pisa-map.c
index 08ac91fafcf20..fc6fa3682f045 100644
--- a/drivers/iommu/pisa-map.c
+++ b/drivers/iommu/pisa-map.c
@@ -17,11 +17,21 @@
 #include <linux/mm.h>
 #include <linux/pci.h>
 #include <linux/pisa-iommu.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
 
 #include "iommu-priv.h"
 
+static struct {
+	atomic64_t page_map;
+	atomic64_t unmap_fail;
+	atomic64_t fallback_nowindow;
+	atomic64_t fallback_noidx;
+	atomic64_t fallback_nohuge;
+	atomic64_t fallback_maperr;
+	atomic64_t fallback_prot;
+} pisa_map_stats;
 
 /*
  * Registry of PISA IOMMU domains. Each slot is FREE (!domain && !base),
@@ -32,6 +42,8 @@ static struct {
 	struct iommu_domain *domain;
 	dma_addr_t base;
 	spinlock_t map_lock;	/* serialises iommu_map() in __pisa_map_phys() */
+	atomic_t slots;
+	char name[32];
 } pisa_domains[PISA_MAX_DOMAINS] __read_mostly;
 static DEFINE_SPINLOCK(pisa_domains_lock);
 
@@ -41,12 +53,61 @@ DEFINE_STATIC_SRCU(pisa_srcu);
 /* Bumped under pisa_domains_lock whenever a domain index is released. */
 unsigned int pisa_domains_generation __read_mostly;
 
+void pisa_domains_show(struct seq_file *s)
+{
+	unsigned int active = 0, draining = 0;
+	char bmap[PISA_MAX_DOMAINS];
+
+	for (int idx = 0; idx < PISA_MAX_DOMAINS; idx++) {
+		if (READ_ONCE(pisa_domains[idx].domain)) {
+			active++;
+			bmap[idx] = 'A';
+		} else if (READ_ONCE(pisa_domains[idx].base)) {
+			draining++;
+			bmap[idx] = 'd';
+		} else {
+			bmap[idx] = '.';
+		}
+	}
+
+	pisa_seq_kv(s, "domains", { "active", active }, { "draining", draining },
+		    { "max", PISA_MAX_DOMAINS },
+		    { "mapped", atomic64_read(&pisa_map_stats.page_map) },
+		    { "unmap_fail", atomic64_read(&pisa_map_stats.unmap_fail) });
+	pisa_seq_kv(s, "map_fail",
+		    { "no_window", atomic64_read(&pisa_map_stats.fallback_nowindow) },
+		    { "no_idx", atomic64_read(&pisa_map_stats.fallback_noidx) },
+		    { "no_huge", atomic64_read(&pisa_map_stats.fallback_nohuge) },
+		    { "map_err", atomic64_read(&pisa_map_stats.fallback_maperr) },
+		    { "prot", atomic64_read(&pisa_map_stats.fallback_prot) });
+	for (int idx = 0; idx < PISA_MAX_DOMAINS; idx++) {
+		if ((idx & 63) == 0)
+			seq_printf(s, "  %-12s", idx ? "" : "domains_map");
+		if ((idx & 7) == 0)
+			seq_putc(s, ' ');
+		seq_putc(s, bmap[idx]);
+		if ((idx & 63) == 63 || idx == PISA_MAX_DOMAINS - 1)
+			seq_putc(s, '\n');
+	}
+
+	for (int idx = 0; idx < PISA_MAX_DOMAINS; idx++) {
+		dma_addr_t base = READ_ONCE(pisa_domains[idx].base);
+
+		if (!READ_ONCE(pisa_domains[idx].domain))
+			continue;
+		seq_printf(s, "  domain_%-5d base %pad size %lluM slots %d name %s\n",
+			   idx, &base, pisa_iova_size() >> 20,
+			   atomic_read(&pisa_domains[idx].slots), pisa_domains[idx].name);
+	}
+}
+
 /* Report a short IOMMU unmap and mark @meta quarantined so it is never reused. */
 static bool pisa_quarantine_meta(struct pisa_meta *meta, struct iommu_domain *domain,
 				 int idx, dma_addr_t iova, size_t unmapped)
 {
 	pr_err_ratelimited("pisa: unmap of IOVA %pad in domain %p (index %d) returned %zu, quarantining PISA page\n",
 			   &iova, domain, idx, unmapped);
+	atomic64_inc(&pisa_map_stats.unmap_fail);
 	return pisa_quarantine_page(meta);
 }
 
@@ -71,6 +132,7 @@ void pisa_unmap_all_domains(struct pisa_meta *meta)
 
 		if (!test_and_clear_bit(idx, meta->domains_mapped))
 			continue;
+		atomic_dec(&pisa_domains[idx].slots);
 
 		spin_lock_irqsave(&pisa_domains_lock, flags);
 		domain = pisa_domains[idx].domain;
@@ -138,6 +200,8 @@ void __pisa_domain_release(struct iommu_domain *domain)
 	spin_lock_irqsave(&pisa_domains_lock, flags);
 	/* Mark slot FREE and bump @pisa_domains_generation so NOIDX domains retry. */
 	pisa_domains[idx].base = 0;
+	atomic_set(&pisa_domains[idx].slots, 0);
+	pisa_domains[idx].name[0] = '\0';
 	WRITE_ONCE(pisa_domains_generation, pisa_domains_generation + 1);
 	spin_unlock_irqrestore(&pisa_domains_lock, flags);
 
@@ -176,6 +240,7 @@ void __pisa_domain_quiesce(struct iommu_domain *domain)
 		if (!test_bit(idx, meta->domains_mapped) ||
 		    !test_and_clear_bit(idx, meta->domains_mapped))
 			continue;
+		atomic_dec(&pisa_domains[idx].slots);
 
 		/* Unmap the page, batching the IOTLB flush into @gather. */
 		iova = base + pisa_meta2iova_offset(meta);
@@ -314,6 +379,9 @@ static int pisa_domain_init(struct device *dev, struct iommu_domain *domain,
 	pisa_domains[idx].domain = domain;
 	pisa_domains[idx].base = base;
 	spin_lock_init(&pisa_domains[idx].map_lock);
+	atomic_set(&pisa_domains[idx].slots, 0);
+	strscpy(pisa_domains[idx].name, dev_name(dev),
+		sizeof(pisa_domains[idx].name));
 	WRITE_ONCE(pi->domain_idx, idx + PISA_IDX_FIRST);
 	/* Publish .domain_idx before .base (paired with is_pisa_iova()). */
 	smp_store_release(&pi->base, base);
@@ -358,8 +426,10 @@ bool __pisa_map_phys(dma_addr_t *iova, struct device *dev,
 	/* In a CoCo guest @dev can only reach decrypted pages; an SME host needs no check. */
 	if (unlikely((prot & ~block_prot) ||
 		     (pisa_decrypt_enabled() && force_dma_unencrypted(dev) &&
-		      !(meta->flags & PISA_DECRYPTED))))
+		      !(meta->flags & PISA_DECRYPTED)))) {
+		atomic64_inc(&pisa_map_stats.fallback_prot);
 		return false;
+	}
 
 	/* Acquire pairs with the .base release in pisa_domain_init(). */
 	if (unlikely(!smp_load_acquire(&pi->base))) {
@@ -368,8 +438,15 @@ bool __pisa_map_phys(dma_addr_t *iova, struct device *dev,
 		if (likely(!ret))
 			ret = pisa_domain_init(dev, domain, pi);
 
-		if (ret)
+		if (ret) {
+			if (ret == -EOPNOTSUPP)
+				atomic64_inc(&pisa_map_stats.fallback_nohuge);
+			else if (ret == -EBUSY)
+				atomic64_inc(&pisa_map_stats.fallback_noidx);
+			else
+				atomic64_inc(&pisa_map_stats.fallback_nowindow);
 			return false;
+		}
 	}
 
 	addr = pisa_phys_to_iova(pi, meta, phys);
@@ -377,8 +454,10 @@ bool __pisa_map_phys(dma_addr_t *iova, struct device *dev,
 	/* Check @dev's own DMA mask and bus limit against the window IOVA. */
 	limit = min_not_zero(dma_get_mask(dev), dev->bus_dma_limit);
 	limit = min_not_zero(limit, dev->coherent_dma_mask);
-	if (unlikely(addr + size - 1 > limit))
+	if (unlikely(addr + size - 1 > limit)) {
+		atomic64_inc(&pisa_map_stats.fallback_nowindow);
 		return false;
+	}
 
 	domain_idx = pi->domain_idx - PISA_IDX_FIRST;
 	if (likely(test_bit(domain_idx, meta->domains_mapped))) {
@@ -393,11 +472,15 @@ bool __pisa_map_phys(dma_addr_t *iova, struct device *dev,
 
 		ret = iommu_map(domain, pisa_phys_to_iova(pi, meta, pisa_phys),
 				pisa_pte_phys(meta, pisa_phys), PISA_SIZE, block_prot, GFP_ATOMIC);
-		if (unlikely(ret))
+		if (unlikely(ret)) {
+			atomic64_inc(&pisa_map_stats.fallback_maperr);
 			return false;
+		}
 		/* Ensure the mapping is visible before setting the domain bit. */
 		smp_mb__before_atomic();
 		set_bit(domain_idx, meta->domains_mapped);
+		atomic_inc(&pisa_domains[domain_idx].slots);
+		atomic64_inc(&pisa_map_stats.page_map);
 	}
 
 	*iova = addr;
diff --git a/include/linux/pisa-iommu.h b/include/linux/pisa-iommu.h
index fed44c2050f9a..aa91d3cbaa75c 100644
--- a/include/linux/pisa-iommu.h
+++ b/include/linux/pisa-iommu.h
@@ -11,6 +11,7 @@
 #include <linux/pisa.h>
 
 struct pisa_alloc;
+struct seq_file;
 
 #ifdef CONFIG_PISA
 
@@ -95,6 +96,23 @@ static inline dma_addr_t pisa_phys_to_iova(const struct pisa_iova *pi,
 	       (phys & (PISA_SIZE - 1));
 }
 
+/* One name/value pair of a debugfs statistics line. */
+struct pisa_kv {
+	const char *name;
+	s64 val;
+};
+
+void __pisa_seq_kv(struct seq_file *s, const char *title,
+		   const struct pisa_kv *st, unsigned int n);
+
+/* Print @title and fixed-width name/value pairs to debugfs seq_file @s. */
+#define pisa_seq_kv(s, title, ...)					\
+do {									\
+	const struct pisa_kv __st[] = { __VA_ARGS__ };			\
+									\
+	__pisa_seq_kv(s, title, __st, ARRAY_SIZE(__st));		\
+} while (0)
+
 #endif /* CONFIG_PISA */
 
 #if defined(CONFIG_PISA) && defined(CONFIG_IOMMU_DMA)
@@ -104,11 +122,13 @@ extern unsigned int pisa_domains_generation;
 
 void pisa_unmap_all_domains(struct pisa_meta *meta);
 int pisa_dev_dma_domain(struct device *dev, struct iommu_domain **domain);
+void pisa_domains_show(struct seq_file *s);
 int pisa_iova_declined(const struct pisa_iova *pi);
 
 #else /* !CONFIG_PISA || !CONFIG_IOMMU_DMA */
 
 static inline void pisa_unmap_all_domains(struct pisa_meta *meta) {}
+static inline void pisa_domains_show(struct seq_file *s) {}
 static inline int pisa_iova_declined(const struct pisa_iova *pi) { return -EOPNOTSUPP; }
 
 static inline int pisa_dev_dma_domain(struct device *dev, struct iommu_domain **domain)
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 92a4c529d1605..8ca1a459a2279 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -101,6 +101,7 @@ bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 			     size_t size, size_t offset,
 			     enum dma_data_direction dir, bool pinned);
 bool pisa_page_tx_ok(const struct page *page);
+void pisa_stats_inc_user_copy(void);
 
 static inline bool pisa_enabled(void)
 {
@@ -287,6 +288,7 @@ static inline bool pisa_upgrade_user_pages(struct iov_iter *iter,
 }
 
 static inline bool pisa_page_tx_ok(const struct page *page) { return false; }
+static inline void pisa_stats_inc_user_copy(void) {}
 
 #endif /* CONFIG_PISA */
 
diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
index edfa7cf424451..f3449c0084e28 100644
--- a/mm/pisa-alloc.c
+++ b/mm/pisa-alloc.c
@@ -11,6 +11,7 @@
 #include <linux/cache.h>
 #include <linux/cc_platform.h>
 #include <linux/cpuhotplug.h>
+#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/dma-direct.h>
 #include <linux/dma-map-ops.h>
@@ -35,6 +36,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sched/clock.h>
 #include <linux/sched/mm.h>
+#include <linux/seq_file.h>
 #include <linux/shrinker.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -88,6 +90,9 @@ module_param_named(idle_ms, pisa_idle_ms, uint, 0644);
 unsigned int pisa_scrub_max __read_mostly;
 #define PISA_SCRUB_MAX_LIMIT	65536U
 
+/* Reclaim statistics, see pisa_allocs_show(). */
+struct pisa_reclaim_stats pisa_reclaim_stats;
+
 /* All live allocators, protected by pisa_allocs_lock. */
 static LIST_HEAD(pisa_allocs);
 static DEFINE_RWLOCK(pisa_allocs_lock);
@@ -152,6 +157,9 @@ static void pisa_reclaim_work_fn(struct work_struct *work)
 	struct pisa_meta *meta, *tmp;
 	struct llist_node *node;
 	struct pisa_alloc *pa;
+	unsigned int n = 0;
+
+	pisa_stat_inc(pisa_reclaim_stats.reclaim_run);
 
 	read_lock(&pisa_allocs_lock);
 	list_for_each_entry(pa, &pisa_allocs, node) {
@@ -178,8 +186,11 @@ static void pisa_reclaim_work_fn(struct work_struct *work)
 	read_unlock(&pisa_allocs_lock);
 
 	node = llist_del_all(&pisa_free_list);
-	llist_for_each_entry_safe(meta, tmp, node, llnode)
+	llist_for_each_entry_safe(meta, tmp, node, llnode) {
 		__pisa_release_page(meta);
+		n++;
+	}
+	pisa_stat_add(pisa_reclaim_stats.reclaim_pages, n);
 
 	if (next_delay != MAX_JIFFY_OFFSET)
 		queue_delayed_work(pisa_wq ?: system_wq, &pisa_reclaim_work, next_delay);
@@ -203,7 +214,8 @@ bool pisa_quarantine_page(struct pisa_meta *meta)
 	struct pisa_alloc *pa;
 	unsigned long flags;
 
-	set_bit(_PISA_QUARANTINED, &meta->flags);
+	if (!test_and_set_bit(_PISA_QUARANTINED, &meta->flags))
+		pisa_stat_atomic_inc(pisa_reclaim_stats.quarantined);
 	pa = READ_ONCE(meta->pa);
 	if (!pa || READ_ONCE(meta->on_list) == PISA_LIST_NONE)
 		return false;
@@ -361,6 +373,7 @@ static unsigned long pisa_alloc_scrub_blocks(struct pisa_alloc *pa)
 		__set_bit(idxs[idx], meta->clean_bitmap);
 	meta->nr_clean += count;
 	meta->nr_scrub = 0;
+	pisa_stat_add(pa->stats.block_scrub, count);
 	pa->scrub_demand -= min(count, pa->scrub_demand);
 	should_release = pisa_place_meta(meta);
 	spin_unlock_irqrestore(&pa->lock, flags);
@@ -484,6 +497,7 @@ static bool pisa_return_block_locked(struct pisa_alloc *pa, struct page *block)
 		meta->nr_dirty++;
 	}
 	pa->blocks_in_use--;
+	pisa_stat_inc(pa->stats.block_free);
 	return pisa_place_meta(meta);
 }
 
@@ -511,10 +525,19 @@ static void pisa_free_bulk(struct pisa_alloc *pa, unsigned int n, struct page **
  */
 #define PISA_PCP_BATCH	32U	/* blocks moved per refill or flush */
 
+struct pisa_pcp_stats {
+	u64	alloc;
+	u64	alloc_ks;
+	u64	alloc_as;
+	u64	miss;
+	u64	free;
+};
+
 struct pisa_pcp {
-	spinlock_t	lock;	/* by this CPU, or by a drain from any CPU */
-	unsigned int	count;
-	struct page	*blocks[PISA_PCP_HIGH];
+	spinlock_t		lock;	/* by this CPU, or by a drain from any CPU */
+	unsigned int		count;
+	struct pisa_pcp_stats	stats;
+	struct page		*blocks[PISA_PCP_HIGH];
 };
 
 /* Max blocks moved per per-CPU cache refill or flush (1..PISA_PCP_BATCH). */
@@ -537,7 +560,8 @@ static inline unsigned int pisa_pcp_batch_order(const struct pisa_alloc *pa)
 }
 
 /* Cache @n blocks at refcount 0 on this CPU, @n <= PISA_PCP_BATCH. */
-static void pisa_pcp_push(struct pisa_alloc *pa, unsigned int n, struct page **blocks)
+static void pisa_pcp_push(struct pisa_alloc *pa, unsigned int n, struct page **blocks,
+			  bool is_free)
 {
 	unsigned int batch = pisa_pcp_batch_order(pa);
 	unsigned int high = max(2U, PISA_PCP_HIGH >> pa->order);
@@ -547,6 +571,8 @@ static void pisa_pcp_push(struct pisa_alloc *pa, unsigned int n, struct page **b
 	/* @pcp->lock protects the cache: migrating to another CPU here is harmless. */
 	pcp = raw_cpu_ptr(pa->pcp);
 	spin_lock_irqsave(&pcp->lock, flags);
+	if (is_free)
+		pisa_stat_add(pcp->stats.free, n);
 	for (unsigned int i = 0; i < n; i++) {
 		if (pcp->count >= high) {
 			/* Keep the most recently freed, likely still in cache. */
@@ -617,17 +643,29 @@ void pisa_pcp_drain(struct pisa_alloc *pa)
 		pisa_pcp_drain_cpu(pa, cpu);
 }
 
-/* Blocks in @pa's caches, for shrinker and debugfs. */
-static unsigned long pisa_pcp_count(struct pisa_alloc *pa)
+/* Return cached block count across @pa's per-CPU caches, and sum counters into @st. */
+static unsigned long pisa_pcp_stats(struct pisa_alloc *pa, struct pisa_pcp_stats *st)
 {
+	struct pisa_pcp_stats tmp;
 	unsigned long n = 0;
 	int cpu;
 
+	if (!st)
+		st = &tmp;
+	memset(st, 0, sizeof(*st));
 	if (!pa->pcp)
 		return 0;
+
 	for_each_possible_cpu(cpu) {
+		const struct pisa_pcp *pcp = per_cpu_ptr(pa->pcp, cpu);
+
 		/* A racy sum is good enough for reclaim and statistics. */
-		n += data_race(per_cpu_ptr(pa->pcp, cpu)->count);
+		n += READ_ONCE(pcp->count);
+		st->alloc += READ_ONCE(pcp->stats.alloc);
+		st->alloc_ks += READ_ONCE(pcp->stats.alloc_ks);
+		st->alloc_as += READ_ONCE(pcp->stats.alloc_as);
+		st->miss += READ_ONCE(pcp->stats.miss);
+		st->free += READ_ONCE(pcp->stats.free);
 	}
 	return n;
 }
@@ -900,6 +938,7 @@ static unsigned int pisa_scan_bitmap(struct pisa_meta *meta, bool dirty,
 	}
 	*countp -= used;
 	pa->blocks_in_use += used;
+	pisa_stat_add(pa->stats.block_alloc, used);
 	return got;
 }
 
@@ -948,7 +987,8 @@ static struct pisa_meta *pisa_pick_meta(struct pisa_alloc *pa, bool zero)
 
 /* Extract up to @want blocks from @meta under @pa->lock. */
 static unsigned int take_blocks(struct pisa_meta *meta, unsigned int want,
-				struct page **out, bool zero, bool frozen)
+				struct page **out, bool can_block, bool zero,
+				bool frozen)
 {
 	unsigned int avail_before = pisa_meta_avail(meta), got = 0, used;
 	struct pisa_alloc *pa = meta->pa;
@@ -963,12 +1003,23 @@ static unsigned int take_blocks(struct pisa_meta *meta, unsigned int want,
 		dirty = pisa_scan_bitmap(meta, true, want - got, out + got, false);
 		for (unsigned int i = got; i < got + dirty; i++)
 			set_page_private(out[i], 1);
+		if (can_block) {
+			pisa_stat_add(pa->stats.alloc_kc, got);
+			pisa_stat_add(pa->stats.alloc_ks, dirty);
+		} else {
+			pisa_stat_add(pa->stats.alloc_ac, got);
+			pisa_stat_add(pa->stats.alloc_as, dirty);
+		}
 		got += dirty;
 		pa->scrub_demand = min(pa->scrub_demand + dirty, PISA_SCRUB_DEMAND_MAX);
 	} else {
 		/* First choice are dirty blocks, followed by clean */
 		got += pisa_scan_bitmap(meta, true, want, out, !frozen);
 		got += pisa_scan_bitmap(meta, false, want - got, out + got, !frozen);
+		if (can_block)
+			pisa_stat_add(pa->stats.alloc_kd, got);
+		else
+			pisa_stat_add(pa->stats.alloc_ad, got);
 	}
 
 	used = avail_before - pisa_meta_avail(meta);
@@ -980,14 +1031,35 @@ static unsigned int take_blocks(struct pisa_meta *meta, unsigned int want,
 	if (READ_ONCE(meta->drain))
 		WRITE_ONCE(meta->drain, false);
 	pisa_place_meta(meta);
+	if (page_to_nid(pisa_meta_to_page(meta)) != pa->nid)
+		pisa_stat_add(pa->stats.numa_mismatch, used);
 
 	return got;
 }
 
+/* Count a failed pisa_alloc_split_page(); @none if the caller got no block at all. */
+static void pisa_alloc_count_failure(struct pisa_alloc *pa, long err, bool none)
+{
+	if (err == -EAGAIN) {
+		pisa_stat_atomic_inc(pa->stats.fail_backoff);
+	} else if (err == -ENOSPC) {
+		pisa_stat_atomic_inc(pa->stats.fail_budget);
+	} else if (err == -ENOMEM) {
+		pisa_stat_atomic_inc(pa->stats.fail_nomem);
+		pr_warn_once("pisa: order-%u allocation failed for allocator %p; further failures are counted in debugfs only\n",
+			     PISA_ORDER, pa);
+	} else if (err == -EBUSY) {
+		pisa_stat_atomic_inc(pa->stats.fail_split);
+	}
+	if (none)
+		pisa_stat_atomic_inc(pa->stats.block_alloc_fail);
+}
+
 /* Allocate @nr_pages blocks from @pa. */
 static unsigned long __pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp, unsigned long nr_pages,
 				       struct page **pages, bool zero, bool frozen)
 {
+	bool can_block = gfpflags_allow_blocking(gfp);
 	bool should_scrub = false;
 	unsigned long n, flags;
 	struct pisa_meta *meta;
@@ -995,7 +1067,8 @@ static unsigned long __pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp, unsigne
 
 	/* Held across bitmap scans; dropped around slow-path pisa_alloc_split_page(). */
 	spin_lock_irqsave(&pa->lock, flags);
-	for (n = 0; n < nr_pages; n += take_blocks(meta, want, &pages[n], zero, frozen)) {
+	for (n = 0; n < nr_pages;
+	     n += take_blocks(meta, want, &pages[n], can_block, zero, frozen)) {
 		want = min_t(unsigned long, nr_pages - n, PISA_BLOCKS(pa->order));
 		meta = pisa_pick_meta(pa, zero);
 		if (meta)
@@ -1006,15 +1079,17 @@ static unsigned long __pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp, unsigne
 		spin_unlock_irqrestore(&pa->lock, flags);
 		/* With @zero, fresh dirty blocks are zeroed below. */
 		meta = pisa_alloc_split_page(pa->order, gfp, pa->nid);
-		if (IS_ERR(meta))
+		if (IS_ERR(meta)) {
+			pisa_alloc_count_failure(pa, PTR_ERR(meta), !n);
 			goto out;
+		}
 		spin_lock_irqsave(&pa->lock, flags);
 		meta->pa = pa;
 		meta->prot = pa->prot;
 		WRITE_ONCE(meta->alloc_jiffies, jiffies);
 		/* Set PISA_ACTIVE after @meta is fully set up. */
 		pisa_meta_set_flags(meta, PISA_ACTIVE);
-		pa->stats.page_alloc++;
+		pisa_stat_inc(pa->stats.page_alloc);
 	}
 	/* Queue the scrubber when the inline zeroing crosses the trigger. */
 	should_scrub |= pa->scrub_demand >= PISA_SCRUB_TRIGGER;
@@ -1042,9 +1117,11 @@ static unsigned long pisa_pcp_alloc(struct pisa_alloc *pa, gfp_t gfp, unsigned l
 				    struct page **page_array, bool frozen)
 {
 	unsigned int pcp_batch = pisa_pcp_batch_order(pa);
-	unsigned long got, j = 0;
+	bool zero = want_init_on_alloc(gfp);
+	unsigned long got, local, j = 0;
 
 	got = pisa_pcp_pop(pa, nr_pages, page_array);
+	local = got;
 	if (got < nr_pages) {
 		if (nr_pages - got >= pcp_batch) {
 			got += __pisa_alloc_bulk(pa, gfp, nr_pages - got,
@@ -1058,7 +1135,7 @@ static unsigned long pisa_pcp_alloc(struct pisa_alloc *pa, gfp_t gfp, unsigned l
 				page_array[got++] = batch[i];
 			if (i < n) {
 				if (pa->nid == numa_mem_id())
-					pisa_pcp_push(pa, n - i, batch + i);
+					pisa_pcp_push(pa, n - i, batch + i, false);
 				else
 					pisa_free_bulk(pa, n - i, batch + i);
 			}
@@ -1070,10 +1147,13 @@ static unsigned long pisa_pcp_alloc(struct pisa_alloc *pa, gfp_t gfp, unsigned l
 
 		page_array[i] = NULL;
 		/* Poisoned while cached: leak it, as pisa_scan_bitmap() does. */
-		if (is_pisa_block_poisoned(pa, block))
+		if (is_pisa_block_poisoned(pa, block)) {
+			if (i < local)
+				local--;
 			continue;
+		}
 		pisa_block_prep(block);
-		if (want_init_on_alloc(gfp)) {
+		if (zero) {
 			memset(page_address(block), 0, PAGE_SIZE << pa->order);
 			if (frozen) /* Order zeroing before caller publishes the page. */
 				smp_wmb();
@@ -1084,8 +1164,16 @@ static unsigned long pisa_pcp_alloc(struct pisa_alloc *pa, gfp_t gfp, unsigned l
 	}
 	/* Replace blocks dropped as poisoned, so that callers do not see a short allocation. */
 	if (unlikely(j < got))
-		j += __pisa_alloc_bulk(pa, gfp, nr_pages - j, page_array + j,
-				       want_init_on_alloc(gfp), frozen);
+		j += __pisa_alloc_bulk(pa, gfp, nr_pages - j, page_array + j, zero, frozen);
+	this_cpu_add(pa->pcp->stats.alloc, j);
+	if (zero) {
+		if (gfpflags_allow_blocking(gfp))
+			this_cpu_add(pa->pcp->stats.alloc_ks, j);
+		else
+			this_cpu_add(pa->pcp->stats.alloc_as, j);
+	}
+	if (j > local)
+		this_cpu_inc(pa->pcp->stats.miss);
 	return j;
 }
 
@@ -1108,9 +1196,13 @@ unsigned long pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp,
 	/* Skip any already populated prefix, as alloc_pages_bulk_node() does. */
 	while (i < nr_pages && page_array[i])
 		i++;
-	if (unlikely(!pa || i == nr_pages ||
-		     (gfp & (__GFP_DMA | __GFP_DMA32 | __GFP_THISNODE | __GFP_ACCOUNT))))
+	if (unlikely(!pa || i == nr_pages))
+		return i;
+
+	if (unlikely(gfp & (__GFP_DMA | __GFP_DMA32 | __GFP_THISNODE | __GFP_ACCOUNT))) {
+		pisa_stat_atomic_inc(pa->stats.fail_gfp);
 		return i;
+	}
 	gfp = current_gfp_context(gfp);
 
 	while (i < nr_pages) {
@@ -1211,6 +1303,11 @@ static struct page *pisa_take_contig(struct pisa_meta *meta, unsigned int nblock
 		page_ref_unfreeze(page + i, 1);
 	}
 	pa->blocks_in_use += nblocks;
+	pisa_stat_add(pa->stats.block_alloc, nblocks);
+	pisa_stat_add(pa->stats.alloc_kc, nblocks - dirty);
+	pisa_stat_add(pa->stats.alloc_ks, dirty);
+	if (page_to_nid(pisa_meta_to_page(meta)) != pa->nid)
+		pisa_stat_add(pa->stats.numa_mismatch, nblocks);
 	pa->scrub_demand = min(pa->scrub_demand + dirty, PISA_SCRUB_DEMAND_MAX);
 	*clean = !dirty;
 	pisa_place_meta(meta);
@@ -1298,6 +1395,7 @@ __pisa_alloc_map_coherent(struct device *dev, struct iommu_domain *domain,
 		spin_unlock_irqrestore(&pa->lock, flags);
 		meta = pisa_alloc_split_page(0, gfp, pa->nid);
 		if (IS_ERR(meta)) {
+			pisa_alloc_count_failure(pa, PTR_ERR(meta), true);
 			if (should_scrub)
 				pisa_schedule_scrub(pa->nid);
 			return NULL;
@@ -1307,7 +1405,7 @@ __pisa_alloc_map_coherent(struct device *dev, struct iommu_domain *domain,
 		meta->prot = pa->prot;
 		WRITE_ONCE(meta->alloc_jiffies, jiffies);
 		pisa_meta_set_flags(meta, PISA_ACTIVE);
-		pa->stats.page_alloc++;
+		pisa_stat_inc(pa->stats.page_alloc);
 		page = pisa_take_contig(meta, nblocks, align_mask, &clean);
 		if (unlikely(!page))
 			should_release = pisa_place_meta(meta);
@@ -1337,6 +1435,11 @@ __pisa_alloc_map_coherent(struct device *dev, struct iommu_domain *domain,
 	} else {
 		*dma_handle = phys_to_dma(dev, page_to_phys(page));
 	}
+	/* Pairs with cmpxchg_release() in pisa_enable_pcp(). */
+	if (smp_load_acquire(&pa->pcp)) {
+		this_cpu_add(pa->pcp->stats.alloc, nblocks);
+		this_cpu_inc(pa->pcp->stats.miss);
+	}
 	if (!clean)
 		memset(page_address(page), 0, size);
 	return page_address(page);
@@ -1390,9 +1493,10 @@ bool __pisa_free_page(struct page *page, unsigned int order)
 	if (smp_load_acquire(&pa->pcp) && pa->nid == numa_mem_id() &&
 	    page_to_nid(page) == numa_mem_id()) {
 		if (pisa_page_can_recycle(page)) {
-			pisa_pcp_push(pa, 1, &page);
+			pisa_pcp_push(pa, 1, &page, true);
 			return true;
 		}
+		this_cpu_inc(pa->pcp->stats.free);
 		/* A compaction target drains the caches once, when it is done. */
 		if (!(READ_ONCE(meta->on_list) & PISA_LIST_HOLD))
 			pisa_pcp_drain_cpu(pa, raw_smp_processor_id());
@@ -1417,7 +1521,7 @@ static unsigned long pisa_shrink_count(struct shrinker *shrink, struct shrink_co
 	guard(read_lock)(&pisa_allocs_lock);
 	list_for_each_entry(pa, &pisa_allocs, node) {
 		nr += (unsigned long)READ_ONCE(pa->num_idle_pages) << PISA_ORDER;
-		nr += pisa_pcp_count(pa) << pa->order;
+		nr += pisa_pcp_stats(pa, NULL) << pa->order;
 	}
 
 	return nr;
@@ -1447,11 +1551,14 @@ unsigned long pisa_shrink_list(spinlock_t *lock, struct list_head *list,
 VISIBLE_IF_KUNIT unsigned long pisa_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct pisa_meta *meta, *tmp;
+	unsigned long freed, res_freed;
 	struct pisa_alloc *pa;
-	unsigned long freed;
 	LIST_HEAD(release_list);
 
 	freed = pisa_reservoir_shrink(&release_list, sc->nr_to_scan);
+	res_freed = freed;
+	pisa_stat_atomic_inc(pisa_reclaim_stats.shrink_scan);
+	pisa_stat_atomic_add(pisa_reclaim_stats.pte_pages_res, res_freed);
 
 	if (freed < sc->nr_to_scan) {
 		read_lock(&pisa_allocs_lock);
@@ -1466,6 +1573,7 @@ VISIBLE_IF_KUNIT unsigned long pisa_shrink_scan(struct shrinker *shrink, struct
 				break;
 		}
 		read_unlock(&pisa_allocs_lock);
+		pisa_stat_atomic_add(pisa_reclaim_stats.pte_pages_idle, freed - res_freed);
 	}
 
 	/* Retiring must not run under @pa->lock. */
@@ -1480,6 +1588,114 @@ VISIBLE_IF_KUNIT unsigned long pisa_shrink_scan(struct shrinker *shrink, struct
 	return freed ?: SHRINK_STOP;
 }
 
+/* See pisa_seq_kv(). */
+void __pisa_seq_kv(struct seq_file *s, const char *title, const struct pisa_kv *st, unsigned int n)
+{
+	seq_printf(s, "  %-12s", title);
+	for (; n; n--, st++)
+		seq_printf(s, " %-10s%11lld", st->name, st->val);
+	seq_putc(s, '\n');
+}
+
+/* Output global and active per-allocator statistics in /sys/kernel/debug/pisa/allocs. */
+static int pisa_allocs_show(struct seq_file *s, void *unused)
+{
+	struct pisa_reclaim_stats *rs = &pisa_reclaim_stats;
+	char no_pages[16], *pages = no_pages + 3;
+	struct pisa_alloc *pa;
+
+	snprintf(no_pages, sizeof(no_pages), "no_pages_%luM", PISA_SIZE >> 20);
+
+	seq_puts(s, "global (allocators with no activity are omitted)\n");
+	pisa_seq_kv(s, pages, { "in_use", atomic_long_read(&pisa_nr_pages) },
+		    { "max", pisa_max_pages },
+		    { "slots", pisa_nr_slots });
+	pisa_domains_show(s);
+	pisa_seq_kv(s, "reservoir", { pages, pisa_reservoir_count() },
+		    { "max_node", pisa_reservoir_max });
+	pisa_seq_kv(s, "shrinker",
+		    { "scan", pisa_stat_atomic_read(rs->shrink_scan) },
+		    { "from_res", pisa_stat_atomic_read(rs->pte_pages_res) },
+		    { "from_idle", pisa_stat_atomic_read(rs->pte_pages_idle) });
+	pisa_seq_kv(s, "reclaim",
+		    { "runs", pisa_stat_read(rs->reclaim_run) },
+		    { pages, pisa_stat_read(rs->reclaim_pages) },
+		    { "quarantined", pisa_stat_atomic_read(rs->quarantined) });
+	pisa_reservoir_show(s);
+	pisa_user_show(s);
+
+	guard(read_lock)(&pisa_allocs_lock);
+	list_for_each_entry(pa, &pisa_allocs, node) {
+		u64 pages_in_use, blocks_in_use, used_pct = 0, cached;
+		struct pisa_alloc_stats st = data_race(pa->stats); /* debugfs snapshot */
+		struct pisa_pcp_stats pcp;
+
+		cached = pisa_pcp_stats(pa, &pcp);
+		/* Omit allocators that have never allocated or failed an allocation. */
+		if (!st.page_alloc && !st.block_alloc &&
+		    !pisa_stat_atomic_read(st.block_alloc_fail) &&
+		    !pisa_stat_atomic_read(st.fail_gfp))
+			continue;
+
+		u64 page_free = atomic64_read(&st.page_free);
+
+		pages_in_use = st.page_alloc > page_free ?
+			       st.page_alloc - page_free : 0;
+		blocks_in_use = st.block_alloc > st.block_free + cached ?
+				st.block_alloc - st.block_free - cached : 0;
+		if (pages_in_use)
+			used_pct = div64_u64((blocks_in_use << pa->order) * 100,
+					     pages_in_use << PISA_ORDER);
+
+		seq_printf(s, "alloc %s order %u nid %d%s\n", pa->name, pa->order,
+			   pa->nid, pa->prot == IOMMU_READ ? " tx-only" :
+			   pa->prot == IOMMU_WRITE ? " rx-only" : "");
+		pisa_seq_kv(s, pages, { "got", st.page_alloc },
+			    { "put", page_free }, { "in_use", pages_in_use },
+			    { "idle", READ_ONCE(pa->num_idle_pages) },
+			    { "idle_max", READ_ONCE(pa->max_idle_pages) });
+		pisa_seq_kv(s, no_pages,
+			    { "backoff", pisa_stat_atomic_read(st.fail_backoff) },
+			    { "budget", pisa_stat_atomic_read(st.fail_budget) },
+			    { "nomem", pisa_stat_atomic_read(st.fail_nomem) },
+			    { "split", pisa_stat_atomic_read(st.fail_split) });
+		pisa_seq_kv(s, "blocks", { "alloc", st.block_alloc },
+			    { "free", st.block_free }, { "in_use", blocks_in_use },
+			    { "used_pct", used_pct }, { "scrub", st.block_scrub });
+		pisa_seq_kv(s, "blocks",
+			    { "failed", pisa_stat_atomic_read(st.block_alloc_fail) },
+			    { "gfp", pisa_stat_atomic_read(st.fail_gfp) },
+			    { "numa_miss", st.numa_mismatch });
+		pisa_seq_kv(s, "allocations",
+			    { "KD", st.alloc_kd }, { "KC", st.alloc_kc }, { "KS", st.alloc_ks },
+			    { "AD", st.alloc_ad }, { "AC", st.alloc_ac }, { "AS", st.alloc_as });
+		if (pa->pcp) {
+			int cpu;
+
+			pisa_seq_kv(s, "pcpu", { "alloc", pcp.alloc },
+				    { "miss", pcp.miss },
+				    { "free", pcp.free }, { "cached", cached },
+				    { "KS", pcp.alloc_ks }, { "AS", pcp.alloc_as });
+			for_each_possible_cpu(cpu) {
+				const struct pisa_pcp *pcp = per_cpu_ptr(pa->pcp, cpu);
+				struct pisa_pcp_stats stats = data_race(pcp->stats); /* debugfs snapshot */
+				unsigned int c = READ_ONCE(pcp->count);
+				char title[16];
+
+				if (!stats.alloc && !stats.free && !c)
+					continue;
+				snprintf(title, sizeof(title), "pcpu_%u", cpu);
+				pisa_seq_kv(s, title, { "alloc", stats.alloc },
+					    { "miss", stats.miss },
+					    { "free", stats.free }, { "cached", c });
+			}
+		}
+	}
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(pisa_allocs);
+
 /* Return the blocks a dead CPU cached, which nothing else would. */
 static int pisa_cpu_dead(unsigned int cpu)
 {
@@ -1522,6 +1738,10 @@ static int __init pisa_init(void)
 				      pisa_cpu_dead) < 0)
 		pr_warn("pisa: no CPU hotplug callback, offline CPUs keep cached blocks\n");
 
+	/* Built-in and never unloaded; debugfs stubs are no-ops when disabled. */
+	debugfs_create_file("allocs", 0444, debugfs_create_dir("pisa", NULL),
+			    NULL, &pisa_allocs_fops);
+
 	shrink = shrinker_alloc(0, "pisa");
 	if (!shrink) {
 		pr_warn("pisa: shrinker registration failed\n");
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
index c195fdfdbd9fa..98f06a7f2db7f 100644
--- a/mm/pisa-kunit.c
+++ b/mm/pisa-kunit.c
@@ -389,9 +389,9 @@ static int fake_domain_setup(struct kunit *test)
 
 static void test_map_and_domain_lifecycle(struct kunit *test)
 {
+	struct shrink_control sc = { .nr_to_scan = ULONG_MAX };
 	struct device dev = { .init_name = "pisa_map_kunit", .numa_node = NUMA_NO_NODE,
 			      .coherent_dma_mask = DMA_BIT_MASK(64) };
-	struct shrink_control sc = { .nr_to_scan = ULONG_MAX };
 	struct pisa_iova *pi;
 	struct pisa_meta *meta;
 	struct pisa_alloc *pa;
@@ -676,9 +676,9 @@ static void test_gfp_pisa(struct kunit *test)
 
 static void test_reservoir_and_scrubber(struct kunit *test)
 {
+	struct shrink_control sc = { .nr_to_scan = ULONG_MAX };
 	unsigned int old_res = READ_ONCE(pisa_reservoir_max);
 	unsigned int old_scrub = READ_ONCE(pisa_scrub_max);
-	struct shrink_control sc = { .nr_to_scan = ULONG_MAX };
 	struct pisa_meta *meta;
 	struct pisa_alloc *pa;
 	struct page *p;
@@ -711,9 +711,9 @@ static void test_reservoir_and_scrubber(struct kunit *test)
 			WRITE_ONCE(pisa_scrub_max, 512);
 			pisa_scrub_node(pa->nid);
 			KUNIT_EXPECT_EQ(test, meta->nr_dirty, 0U);
+			KUNIT_EXPECT_GE(test, pa->stats.block_scrub, 1ULL);
 		}
 	}
-	pisa_shrink_scan(NULL, &sc);
 
 	/* Trim reservoirs back to 0. */
 	for_each_node_state(nid, N_MEMORY)
diff --git a/mm/pisa-node.c b/mm/pisa-node.c
index aa4f8759ae5e8..e1ae834d0f9b6 100644
--- a/mm/pisa-node.c
+++ b/mm/pisa-node.c
@@ -19,6 +19,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
+#include <linux/seq_file.h>
 #include <linux/set_memory.h>
 #include <linux/spinlock.h>
 #include <linux/topology.h>
@@ -228,6 +229,7 @@ static void pisa_release_page_rcu(struct rcu_head *head)
 	/* Still shared with the host, or possibly still mapped by a device. */
 	if (flags & (PISA_DECRYPTED | PISA_QUARANTINED))
 		return;
+
 	atomic_long_dec(&pisa_nr_pages);
 	for (unsigned int i = 0; i < PISA_BLOCKS(order); i++) {
 		struct page *block = page + (i << order);
@@ -296,6 +298,7 @@ static void pisa_reservoir_refill_node(struct pisa_node *node, int nid)
 		meta = __pisa_page_alloc(GFP_KERNEL | __GFP_THISNODE, nid, true,
 					 pisa_want_decrypt(), &clean);
 		if (IS_ERR(meta)) {
+			pisa_stat_inc(node->stats.refill_err);
 			pisa_alloc_backoff(node, false);
 			break;
 		}
@@ -310,6 +313,7 @@ static void pisa_reservoir_refill_node(struct pisa_node *node, int nid)
 		if (added) {
 			list_add(&meta->list, &node->pages);
 			WRITE_ONCE(node->nr_pages, node->nr_pages + 1);
+			pisa_stat_inc(node->stats.refill);
 		}
 		spin_unlock_irqrestore(&node->lock, flags);
 		if (!added) {
@@ -334,6 +338,7 @@ static void pisa_reservoir_trim_node(struct pisa_node *node, unsigned int max)
 		if (meta) {
 			list_del_init(&meta->list);
 			WRITE_ONCE(node->nr_pages, node->nr_pages - 1);
+			pisa_stat_inc(node->stats.trim);
 		}
 		spin_unlock_irqrestore(&node->lock, flags);
 		if (!meta)
@@ -434,6 +439,7 @@ static struct pisa_meta *pisa_reservoir_pop_node(int nid, unsigned int max, bool
 	if (meta && !!(meta->flags & PISA_DECRYPTED) == decrypt) {
 		list_del_init(&meta->list);
 		WRITE_ONCE(node->nr_pages, node->nr_pages - 1);
+		pisa_stat_inc(node->stats.hit);
 		refill = node->nr_pages <= max / 2;
 	} else {
 		meta = NULL;
@@ -462,6 +468,7 @@ struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool decrypt, bool *cle
 			*clean = true;
 			return meta;
 		}
+		pisa_stat_atomic_inc(pisa_nodes[nid].stats.miss);
 	}
 
 	/* Back off briefly on GFP_ATOMIC if previous allocation on @nid failed. */
@@ -525,3 +532,36 @@ void __init pisa_node_init(void)
 		INIT_WORK(&pisa_nodes[nid].work, pisa_node_work_fn);
 	}
 }
+
+/* Print the reservoir of each node that has seen any activity. */
+void pisa_reservoir_show(struct seq_file *s)
+{
+	bool header = false;
+	char pages[16];
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct pisa_node *node = &pisa_nodes[nid];
+		unsigned int nr = READ_ONCE(node->nr_pages);
+		s64 refill = pisa_stat_read(node->stats.refill);
+		s64 refill_err = pisa_stat_read(node->stats.refill_err);
+		s64 miss = pisa_stat_atomic_read(node->stats.miss);
+		char title[16];
+
+		/* Pages served or trimmed were refilled first. */
+		if (!nr && !refill && !refill_err && !miss)
+			continue;
+		if (!header) {
+			snprintf(pages, sizeof(pages), "pages_%luM", PISA_SIZE >> 20);
+			seq_puts(s, "reservoir\n");
+			header = true;
+		}
+		snprintf(title, sizeof(title), "node_%d", nid);
+		pisa_seq_kv(s, title, { pages, nr },
+			    { "hit", pisa_stat_read(node->stats.hit) },
+			    { "miss", miss });
+		pisa_seq_kv(s, title, { "refill", refill },
+			    { "refill_err", refill_err },
+			    { "trim", pisa_stat_read(node->stats.trim) });
+	}
+}
diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
index 865f3d779b84d..dc073a36cbc83 100644
--- a/mm/pisa-priv.h
+++ b/mm/pisa-priv.h
@@ -91,10 +91,38 @@ static inline unsigned int pisa_meta_avail(const struct pisa_meta *meta)
 	return meta->nr_clean + meta->nr_dirty;
 }
 
+#define pisa_stat_add(var, val)		((var) += (val))
+#define pisa_stat_inc(var)		pisa_stat_add(var, 1)
+#define pisa_stat_dec(var)		pisa_stat_add(var, -1)
+#define pisa_stat_read(var)		READ_ONCE(var)
+
+#define pisa_stat_atomic_add(var, val)	atomic64_add(val, &(var))
+#define pisa_stat_atomic_inc(var)	atomic64_inc(&(var))
+#define pisa_stat_atomic_read(var)	atomic64_read(&(var))
+
 /* Per-allocator statistics, see pisa_allocs_show(). */
 struct pisa_alloc_stats {
-	u64		page_alloc;
-	atomic64_t	page_free;
+	/* Updated under @pa->lock. */
+	u64		page_alloc;	/* PISA pages allocated */
+	u64		block_alloc;	/* block allocations satisfied */
+	u64		block_free;	/* block frees recycled */
+	u64		block_scrub;	/* dirty blocks zeroed by scrubber */
+	u64		numa_mismatch;	/* blocks from non-target NUMA node */
+	u64		alloc_kd;	/* sleepable non-zeroing */
+	u64		alloc_kc;	/* sleepable zeroing from clean_bitmap */
+	u64		alloc_ks;	/* sleepable zeroing inline */
+	u64		alloc_ad;	/* atomic non-zeroing */
+	u64		alloc_ac;	/* atomic zeroing from clean_bitmap */
+	u64		alloc_as;	/* atomic zeroing inline */
+
+	/* Updated without @pa->lock (e.g. pisa_alloc_split_page()). */
+	atomic64_t	page_free;		/* PISA pages released to buddy */
+	atomic64_t	fail_backoff;		/* skipped due to atomic backoff */
+	atomic64_t	fail_budget;		/* refused by pisa_max_pages */
+	atomic64_t	fail_nomem;		/* buddy allocation failed */
+	atomic64_t	fail_split;		/* split_page_compound() failed */
+	atomic64_t	block_alloc_fail;	/* failed on empty allocator */
+	atomic64_t	fail_gfp;		/* declined unsupported GFP */
 };
 
 /* Allocator managing blocks of a fixed order, carved from PISA pages. */
@@ -144,8 +172,30 @@ struct pisa_node {
 	struct list_head	pages;		/* reservoir */
 	unsigned long		flags;		/* PISA_NODE_* requests */
 	struct work_struct	work;		/* refill/trim/scrub, on this node */
+	struct {
+		u64		hit;		/* requests for this node it served */
+		u64		refill;		/* PISA pages added by the refill */
+		u64		refill_err;	/* refill allocations that failed */
+		u64		trim;		/* PISA pages released by the trim */
+		atomic64_t	miss;		/* requests that found it empty */
+	} stats;
 } ____cacheline_aligned_in_smp;
 
+/* Global reclaim and shrinker statistics, see pisa_allocs_show(). */
+struct pisa_reclaim_stats {
+	/* Updated by singleton pisa_reclaim_work. */
+	u64		reclaim_run;	/* pisa_reclaim_work_fn() runs */
+	u64		reclaim_pages;	/* PISA pages it released */
+
+	/* Updated locklessly. */
+	atomic64_t	shrink_scan;	/* pisa_shrink_scan() calls */
+	atomic64_t	pte_pages_res;	/* PTE pages taken from the reservoirs */
+	atomic64_t	pte_pages_idle;	/* PTE pages taken from idle allocators */
+	atomic64_t	quarantined;	/* PISA pages quarantined */
+};
+
+extern struct pisa_reclaim_stats pisa_reclaim_stats;
+
 /* Per-NUMA-node PISA state (ring/TX/user allocators, reservoir). */
 extern struct pisa_node pisa_nodes[MAX_NUMNODES];
 
@@ -260,6 +310,9 @@ void pisa_schedule_scrub_all(void);
 struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool decrypt, bool *clean);
 unsigned long pisa_reservoir_count(void);
 unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned long nr_to_scan);
+
+void pisa_reservoir_show(struct seq_file *s);
+void pisa_user_show(struct seq_file *s);
 void pisa_user_boot_enable(void);
 
 #endif /* CONFIG_PISA */
diff --git a/mm/pisa-user.c b/mm/pisa-user.c
index e4a4e1a606b24..5020269476845 100644
--- a/mm/pisa-user.c
+++ b/mm/pisa-user.c
@@ -19,6 +19,7 @@
 #include <linux/pagewalk.h>
 #include <linux/folio_batch.h>
 #include <linux/sched/clock.h>
+#include <linux/seq_file.h>
 #include <linux/swap.h>
 #include <linux/uio.h>
 
@@ -49,6 +50,26 @@ static const struct kernel_param_ops pisa_scrub_migrate_ops = {
 };
 module_param_cb(scrub_migrate, &pisa_scrub_migrate_ops, &pisa_scrub_migrate, 0644);
 
+/* Statistics, see pisa_user_show(). */
+struct pisa_user_stats {
+	atomic64_t	in;		/* pages migrated into PISA blocks */
+	atomic64_t	in_fail;	/* ... isolated but not migrated */
+	atomic64_t	out;		/* pages migrated back to ordinary pages */
+	atomic64_t	out_fail;	/* ... isolated but not migrated */
+	atomic64_t	no_budget;	/* pages not moved in: cap reached */
+	atomic64_t	busy;		/* pages skipped: referenced elsewhere */
+	atomic64_t	large;		/* pages skipped: large anon folio not split */
+	atomic64_t	copy;		/* TCP chunks copied: page not in PISA */
+};
+
+static struct pisa_user_stats pisa_user_stats;
+
+/* Called by zerocopy_fill_skb_from_iter() when it asks TCP to copy. */
+void pisa_stats_inc_user_copy(void)
+{
+	pisa_stat_atomic_inc(pisa_user_stats.copy);
+}
+
 /* Create per-node user allocators and enable pisa_user_key (serialized by param_lock/init). */
 static int pisa_user_init(void)
 {
@@ -269,7 +290,8 @@ static unsigned int pisa_user_migrate_dir(struct list_head *list, bool to_pisa,
 		.same_alloc = same_alloc,
 	};
 	enum migrate_mode mode = MIGRATE_SYNC;
-	unsigned int done = 0;
+	unsigned int nr = 0, done = 0;
+	struct folio *folio;
 
 	if (list_empty(list))
 		return 0;
@@ -278,10 +300,19 @@ static unsigned int pisa_user_migrate_dir(struct list_head *list, bool to_pisa,
 		if (!gfpflags_allow_blocking(gfp))
 			mode = MIGRATE_ASYNC;
 	}
+	list_for_each_entry(folio, list, lru)
+		nr += folio_nr_pages(folio);
 	if (migrate_pages(list, to_pisa ? pisa_user_new_folio : pisa_user_old_folio,
 			  to_pisa ? pisa_user_put_folio : NULL, (unsigned long)&mtc,
 			  mode, MR_SYSCALL, &done))
 		putback_movable_pages(list);
+	if (to_pisa) {
+		pisa_stat_atomic_add(pisa_user_stats.in, done);
+		pisa_stat_atomic_add(pisa_user_stats.in_fail, nr - done);
+	} else {
+		pisa_stat_atomic_add(pisa_user_stats.out, done);
+		pisa_stat_atomic_add(pisa_user_stats.out_fail, nr - done);
+	}
 	return done;
 }
 
@@ -313,7 +344,7 @@ static unsigned int pisa_user_split_isolated(struct folio *folio, struct list_he
 					     struct page **pages, unsigned int nr, bool split)
 {
 	const struct page *lo = NULL, *hi = NULL;
-	unsigned int kept = 0;
+	unsigned int kept = 0, skipped = 0;
 	struct folio *f, *next;
 	LIST_HEAD(pieces);
 
@@ -325,9 +356,14 @@ static unsigned int pisa_user_split_isolated(struct folio *folio, struct list_he
 			lo = pages[i];
 		if (!hi || pages[i] > hi)
 			hi = pages[i];
+		skipped++;
 	}
 	list_move(&folio->lru, &pieces);
-	if (split && pisa_user_split(folio, &pieces, false)) {
+	if (!split) {
+		pisa_stat_atomic_add(pisa_user_stats.no_budget, skipped);
+	} else if (!pisa_user_split(folio, &pieces, false)) {
+		pisa_stat_atomic_add(pisa_user_stats.large, skipped);
+	} else {
 		list_for_each_entry_safe(f, next, &pieces, lru) {
 			if (!folio_test_large(f) && &f->page >= lo && &f->page <= hi) {
 				list_move_tail(&f->lru, out);
@@ -380,6 +416,7 @@ bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 	if (!want)
 		return false;
 	if (need_budget && pisa_user_budget() <= 0) {
+		pisa_stat_atomic_add(pisa_user_stats.no_budget, need_budget);
 		if (want == need_budget)
 			return false;
 		no_budget = true;
@@ -402,8 +439,10 @@ bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 			continue;
 		for (unsigned int j = 0; j < nr; j++)
 			refs += page_folio(pages[j]) == folio;
-		if (pisa_user_batch_busy(folio, refs, pinned))
+		if (pisa_user_batch_busy(folio, refs, pinned)) {
+			pisa_stat_atomic_inc(pisa_user_stats.busy);
 			continue;
+		}
 		if (isolate_folio_to_list(folio, &list))
 			list_move_tail(&folio->lru, &list);
 	}
@@ -789,6 +828,9 @@ static int pisa_madvise_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long
 				/* Look at @addr again: it now maps an order-0 folio. */
 				if (split)
 					continue;
+				pisa_stat_atomic_add(pisa_user_stats.large, nr);
+			} else if (busy) {
+				pisa_stat_atomic_add(pisa_user_stats.busy, nr);
 			}
 		}
 		if (w->n >= PISA_USER_BATCH) {
@@ -833,3 +875,24 @@ int pisa_madvise(struct vm_area_struct *vma, unsigned long start, unsigned long
 	pisa_user_migrate_dir(&w.list, to_pisa, DMA_TO_DEVICE, false, PISA_MADVISE_GFP);
 	return ret < 0 ? ret : 0;
 }
+
+/* Print user page state and migration statistics to debugfs seq_file @s. */
+void pisa_user_show(struct seq_file *s)
+{
+	char pages[16];
+
+	snprintf(pages, sizeof(pages), "pages_%luK", PAGE_SIZE >> 10);
+	seq_puts(s, "user\n");
+	pisa_seq_kv(s, pages, { "in_use", pisa_user_in_use(true) },
+		    { "max", pisa_user_max_pages << PISA_ORDER });
+	pisa_seq_kv(s, "migrate",
+		    { "in", pisa_stat_atomic_read(pisa_user_stats.in) },
+		    { "in_fail", pisa_stat_atomic_read(pisa_user_stats.in_fail) },
+		    { "out", pisa_stat_atomic_read(pisa_user_stats.out) },
+		    { "out_fail", pisa_stat_atomic_read(pisa_user_stats.out_fail) });
+	pisa_seq_kv(s, "skipped",
+		    { "no_budget", pisa_stat_atomic_read(pisa_user_stats.no_budget) },
+		    { "busy", pisa_stat_atomic_read(pisa_user_stats.busy) },
+		    { "large", pisa_stat_atomic_read(pisa_user_stats.large) },
+		    { "copy", pisa_stat_atomic_read(pisa_user_stats.copy) });
+}
diff --git a/net/core/pisa-net.c b/net/core/pisa-net.c
index 6422c472029a1..2ff90511cb7ae 100644
--- a/net/core/pisa-net.c
+++ b/net/core/pisa-net.c
@@ -256,6 +256,8 @@ bool __pisa_zc_iter_stop(struct sk_buff *skb, struct iov_iter *from,
 		return false;
 	}
 
+	if (skb->len == orig_len)
+		pisa_stats_inc_user_copy();
 	/* -EXDEV tells tcp_sendmsg_locked() to copy this chunk instead of zerocopy. */
 	*copied = (skb->len != orig_len) ? 0 : -EXDEV;
 	return true;
-- 
2.56.1.809.ga0b61035b5-goog

