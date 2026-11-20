Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136850;
	b=V+z4uhl+Ny3Xs5WmseiO0qPAJe/tyut+IGU0Wmy3vdUogCU78h/3Ye5ePTKDIJ8T9Pm1
	 3zYYmhd+AdE6OxsnpqLKtbB9xR229R2+wACZ+bRtlSKMyfi4vfFJQR26bcR7OlbBbGWmk
	 EQ46FskhaGk1c6omf9LGrc7zd7hsV6STfbx+BNS10XU6RLAHs5OKxCoIVxpZ5jdwDdOuT
	 MY146Eeh32nXD1nmmXJSk4LI6QKReCqPtbpv7amQooKNlt7hJFjwAICKZBjcrVEI9eFgX
	 bMeQKXtOhBezwKSIpz8jlRkc0zh90zIb7M2ZajeWBMAVD69fnlv2O+w03Oax3ko1PeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136850;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=uXiDLRBLPSFfTPfUoJ5i1Hu7TTvZxwWf2XG5sLJAj+k=;
	b=GwYKGR659AwyoWEY52jpAmC7ztHu2HbBCA4mJiLE96gsuOGC6rK7A0+iJ+UtxyrxNsCG
	 Lkcyd5m9PXJCfMWFZvDPP8igPUdKe3hP9FIoIKOnjQyJzPqyzxfXz68w9jCGzW+Fj0fJm
	 9JXRtvo3PGFT+kaxfuUUGmA9f/CHpjZwyRJD/QigekboEN/1ESWTdvfDrgjlesNp3oMDC
	 5oip6zzxqnAHvPnnBYOmAYv00vL1M9+8xQDG7DT2WHOwvLpN+FOz+Um4hRinNyNSwFa9d
	 eUeHaKzaZtQVMnub0CzIXaY19ou+gAFXL+dvYLmHkJL47myMO6Rgrpzu84Uk9nz95zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="o8/jQ8G5";
	arc=none smtp.remote-ip=209.85.208.70
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D3B60758E5
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1D3B60758E5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=o8/jQ8G5
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6b1e00100eeso312808a12.3
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136848; x=1795741648; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uXiDLRBLPSFfTPfUoJ5i1Hu7TTvZxwWf2XG5sLJAj+k=;
        b=o8/jQ8G5sobnDxBkVOsLwhQhLl6twoVamTYKOKL8p2acoeympxvi3nnuJZGHaHHmPt
         GPcmNATKSO7RlIBz+WjhQpGNmzPUbEBltYwSG2kT6r4PgupfWceU7kDoVxphYDUbvWV9
         JyqxPv5fejFgjD4cU4wdkXzlfoTQjcXjvjOYHhvtQR2pK5Vqyky2Aw7GstC5cVwzakXw
         iRyqRchpy3a0dS7w55dKjHHCgEIleGlGBrHpO1uRfACQWTGjLEYNJCw4I24DKcuWuga1
         W8Qpq1Ome2xg3oW9dDnEcQFhLCReGttAlMdUwcEBXu9TpG5Puxgrp1hjuwekRyTxGVDm
         cNfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136848; x=1795741648;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uXiDLRBLPSFfTPfUoJ5i1Hu7TTvZxwWf2XG5sLJAj+k=;
        b=RxvTfALF220LfbVn3kxFloAsYjVleRyqGJ5hAz/K7rskgJVMOvZ6Wl88DpDnOnRu5b
         zTiOw8zd5e9Y3o1J3FIUBj9HdabBFXeUliBfmBW/iaNQOzazp9reil/8PIA5HnNTZ1GY
         6rkCZz+GnkaSJCMfBPOqk0S5FofkNVavxE2xzFvH5ubm4O0LIzdjVPApvWXaAos6YOxo
         UWBNUiFKuJt5s4goK0qvHyx+DDro/gIubLZ24dJggf8obE6t9RNA0xTllQu2Ts4EJQ5f
         1VOUAe8q0EyatUaxLOuPvijfAGyR5nfWvCjA5q9wLYzNhR1XhbTFc+ytxpYCvRr8k2ST
         qECQ==
X-Forwarded-Encrypted: i=1; AL+hErG9Z/XT54EpSAvAWYCsPrKzL8SbHs9vxkxicjyqliy3WRf0aTLXgGShpbP6x+9lvk0QR1MI4Kq2tnc=@vger.kernel.org
X-Gm-Message-State: APuU4Z/PBpkihmJylp1qm2RrUDIUp5ugTRjTYo/46Aoli0MZ0YbIpn9d
	nyCpUKUhXhV66YMC4CllSKJ6V065gkxSC/0Q86yrg8xNi4rF/cGghc9eYDa8ZEnHyPP8sTwiy+b
	JKWkopQ==
X-Received: from edeg28.prod.google.com ([2002:a05:6402:565c:b0:6b7:8448:c876])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:c522:20b0:6b4:c971:589d
 with SMTP id 4fb4d7f45d1cf-6ba37d640bbmr579772a12.13.1795136847835; Thu, 19
 Nov 2026 17:07:27 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:54 +0000
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
Message-ID: <20261120010655.467825-25-lrizzo@google.com>
Subject: [RFC PATCH v3 24/25] net/gve: Use PISA memory for RX buffers
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

When dev->pisa_rx_bufs is enabled, allocate GQI-RDA RX packet buffers
with pisa_rx_gfp(dev) so they come from the per-node PISA
allocator, and evict plain pages when a free PISA RX block is available;
DQO-RDA uses page_pool, which checks dev->pisa_rx_bufs directly.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 34 ++++++++++++++++--------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 7c201fd513ee3..562c11f5bdd24 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2015-2021 Google, Inc.
  */
 
+#include <linux/pisa.h>
 #include "gve.h"
 #include "gve_adminq.h"
 #include "gve_utils.h"
@@ -165,6 +166,8 @@ static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
 	dma_addr_t dma;
 	int err;
 
+	if (rx->data.raw_addressing)
+		gfp |= pisa_rx_gfp(dev);
 	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE, gfp);
 	if (err) {
 		u64_stats_update_begin(&rx->statss);
@@ -494,13 +497,19 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info, __be64 *sl
 	*(slot_addr) ^= offset;
 }
 
-static int gve_rx_can_recycle_buffer(struct gve_rx_slot_page_info *page_info)
+static int gve_rx_can_recycle_buffer(struct gve_rx_ring *rx,
+				     struct gve_rx_slot_page_info *page_info)
 {
 	int pagecount = page_count(page_info->page);
 
 	/* This page is not being used by any SKBs - reuse */
-	if (pagecount == page_info->pagecnt_bias)
+	if (pagecount == page_info->pagecnt_bias) {
+		if (rx && rx->data.raw_addressing &&
+		    !is_pisa_page(page_info->page) &&
+		    pisa_has_free_blocks_rx(&rx->gve->pdev->dev, 0, rx->gve->numa_node))
+			return 0;
 		return 1;
+	}
 	/* This page is still being used by an SKB - we can't reuse */
 	else if (pagecount > page_info->pagecnt_bias)
 		return 0;
@@ -544,7 +553,7 @@ static struct sk_buff *gve_rx_copy_to_pool(struct gve_rx_ring *rx,
 
 	copy_page_info = &rx->qpl_copy_pool[pool_idx];
 	if (!copy_page_info->can_flip) {
-		int recycle = gve_rx_can_recycle_buffer(copy_page_info);
+		int recycle = gve_rx_can_recycle_buffer(NULL, copy_page_info);
 
 		if (unlikely(recycle < 0)) {
 			gve_schedule_reset(rx->gve);
@@ -664,7 +673,7 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
 			u64_stats_update_end(&rx->statss);
 		}
 	} else {
-		int recycle = gve_rx_can_recycle_buffer(page_info);
+		int recycle = gve_rx_can_recycle_buffer(rx, page_info);
 
 		if (unlikely(recycle < 0)) {
 			gve_schedule_reset(priv);
@@ -970,7 +979,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 			 * owns half the page it is impossible to tell which half. Either
 			 * the whole page is free or it needs to be replaced.
 			 */
-			int recycle = gve_rx_can_recycle_buffer(page_info);
+			int recycle = gve_rx_can_recycle_buffer(rx, page_info);
 
 			if (recycle < 0) {
 				if (!rx->data.raw_addressing)
@@ -982,13 +991,16 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 				union gve_rx_data_slot *data_slot =
 						&rx->data.data_ring[idx];
 				struct device *dev = &priv->pdev->dev;
-				gve_rx_free_buffer(dev, page_info, data_slot);
-				page_info->page = NULL;
-				if (gve_rx_alloc_buffer(priv, dev, page_info,
-							data_slot, rx,
-							GFP_ATOMIC)) {
+				struct gve_rx_slot_page_info new_info = {};
+				union gve_rx_data_slot new_slot;
+
+				if (gve_rx_alloc_buffer(priv, dev, &new_info,
+							&new_slot, rx,
+							GFP_ATOMIC))
 					break;
-				}
+				gve_rx_free_buffer(dev, page_info, data_slot);
+				*page_info = new_info;
+				*data_slot = new_slot;
 			}
 		}
 		fill_cnt++;
-- 
2.56.1.809.ga0b61035b5-goog

