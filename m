Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136843;
	b=DfZc3MxfIG+LkTdbuHoLDmPjrMKV+z9EpVWEs2WyzZpOoD08N9yopJ5Xn2BbIcCKx045
	 rcBnKuX2FGZEPAvmtCVzi3i3jX0Ei1MX5VLXdTXaVtBPHjERXE8NQYHo82g1jkTp2/zgG
	 UaqEnPs3fYIwjzEGney8GVwKrOyNlkDqQ9Hoatx50zkHz/tHd9MGNC5aQPcAZ4E8VJq8B
	 d8G09F3aJKrUoHeTuEB5evSnzfwLGUTsn3q2v9QKd9siGcNUNdN9EaNo/JwH0Gp7lEpPZ
	 nk5en4/e/rrvDlI4h33BpyW0y2I15tL0qBUMugjO7X5YdwK8bMszfSfR98iqQAxc4qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136843;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=5SEs/blsCReRT4hCMThOeNKTJAt5emco8Ap+aYEQIPY=;
	b=gb0FzKXN40XH1wbUT8wFViv7fAVlV5d5aMlvJsvG/KoXGl4wfsEtlSa3xEYBNuEbnA4Y
	 Qq8hPSA+k9Gv+hlHRKzF9XoxoFLkWSzoTgpZ4fQ7bgahlJo2tJFD0b86raHlSPTZXavfw
	 103PEeO2Q/H3IXTZhRf5UnLRtpQ+JsIkzqwx2x3wymf80oloy+yjGBr3e4Cgp5K6BOvT3
	 pl6ZAJzhWHR9JYEGNVhSr5RRwgFnzNuww+WGHY2fRLvfrCkZ1z1csArk+f0niFVjcBsFu
	 Q3F+9hAE33FSXglvmavDM83ePM29f1UYD/KR8kWufGzHlaPge4yyMwC+cGYFFbwSrXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UW7ic8qW;
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D3A60A5BC2
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34D3A60A5BC2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UW7ic8qW
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b8b0fff7e6so276119a12.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136841; x=1795741641; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5SEs/blsCReRT4hCMThOeNKTJAt5emco8Ap+aYEQIPY=;
        b=UW7ic8qWp1qgrT+THHSWIhZ2r5WlYsCTixzD5A1rkCjugIkpGY4NcOcFJBVoSz0VHX
         GSPbO7GoKay4jlKheFbKzaH8NDBxXjnoxjHMtMCHiAfUORVsmgOBKiEfy5Xqms513G4q
         LbY1k4tyHZ3qDR1VRD1IsD3TZINYWnOCJPJ4QmtGKWriR8OI6cIbfUPdlcVxUS1n9r8J
         5JHOSaL5T9LGQ/CoMtXI0SnLpR6qQ6OiBanW+/CXreajhXSXs3uCHlMA9vr1psDVQ6VR
         h1f9kKDeeeeBSPfw1TrgJHqzVlQCOyTtAluBqslv7j8OzlupZnSXYt3k8liJCDCQkWBw
         Qo+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136841; x=1795741641;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5SEs/blsCReRT4hCMThOeNKTJAt5emco8Ap+aYEQIPY=;
        b=i5VYp0lqCyGAalCnMdyMfDSIbOZKQT/gEzN7nZAcQmZXFhbyhHzS1ytxrA7x4g2HRO
         oEQwdueoUy7PdjDXyUGiESOBm1MPRhqx5SyTwiCpG/nrw8wSXGptWEu0BUNISiAvFE9S
         3dL9USQNf3chwxP2rksFr2h01aPjBq+10C8/6XRU/t6S0l6StNC4WfOesJYl6+oDC5qV
         RDuUv/hcRzk6QuGoXTEayRjkyTiuUovrWMfm0i2aT0V4t/VRF085BSiAVeTi1zHYDKzN
         uTfyPWGzkDROurfee74FZu+/FXXbkQab9svj21fkQwQ/83pFbRm4i5ZQ8sBxiJq38QYY
         SXlw==
X-Forwarded-Encrypted: i=1; AL+hErFH67k+SzEK7PnNfTA/6gdLQXWQA2NKgdvI5Ah6fm8+rZJaAGnQd5nx3qTmM+FGltqeDoRu9bkMabE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/XlBdhgDmyuIoehKW8UBcuvnjEBQrGNXadbvz6oXHGMyObbdFN
	C+tX74cPpYVn+N5mwJbI8sCYLxvN5mVtTa4DF8HNIq/sYTYRmiler3lFEAOO3j338IH6wfIt7Uq
	W124trQ==
X-Received: from edcnu5-n1.prod.google.com ([2002:a05:6402:c505:10b0:6ba:2090:b8e7])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:a210:20b0:6b8:81fb:aebc
 with SMTP id 4fb4d7f45d1cf-6ba37e7e94fmr649614a12.19.1795136840334; Thu, 19
 Nov 2026 17:07:20 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:48 +0000
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
Message-ID: <20261120010655.467825-19-lrizzo@google.com>
Subject: [RFC PATCH v3 18/25] net: Migrate user pages into PISA for MSG_ZEROCOPY
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

Perform best-effort migration of user pages into PISA memory on
MSG_ZEROCOPY sends in zerocopy_fill_skb_from_iter() when the egress
device has the per-device attribute pisa_tx_zerocopy enabled. For TCP
over a device that also has pisa_tx_bufs enabled, pages that cannot be
migrated fall back to the regular copy path into PISA TX page_frags
without reporting SO_EE_CODE_ZEROCOPY_COPIED.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/pisa.h |  3 ++
 include/net/pisa.h   | 32 +++++++++++++--
 mm/pisa-user.c       |  8 ++++
 net/core/datagram.c  | 17 ++++++--
 net/core/pisa-net.c  | 95 ++++++++++++++++++++++++++++++++++++++++++--
 net/core/skbuff.c    |  3 +-
 net/ipv4/tcp.c       | 12 +++++-
 7 files changed, 158 insertions(+), 12 deletions(-)

diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 84692852299f1..11e3ea9eb263d 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -95,6 +95,7 @@ bool __pisa_page_can_recycle(const struct page *page);
 bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 			     size_t size, size_t offset,
 			     enum dma_data_direction dir, bool pinned);
+bool pisa_page_tx_ok(const struct page *page);
 
 static inline bool pisa_enabled(void)
 {
@@ -264,6 +265,8 @@ static inline bool pisa_upgrade_user_pages(struct iov_iter *iter,
 	return false;
 }
 
+static inline bool pisa_page_tx_ok(const struct page *page) { return false; }
+
 #endif /* CONFIG_PISA */
 
 #if defined(CONFIG_PISA) && defined(CONFIG_IOMMU_DMA)
diff --git a/include/net/pisa.h b/include/net/pisa.h
index 7fe2e7d5aa97e..c95e4ab1f344f 100644
--- a/include/net/pisa.h
+++ b/include/net/pisa.h
@@ -13,9 +13,9 @@ struct sk_buff *__sock_alloc_send_pskb(struct sock *sk, unsigned long header_len
 				       gfp_t gfp);
 
 /*
- * struct net_device caches the PISA enable flags for tx_bufs and tx_heads used
- * by the leaf device, refreshed every 256 jiffies. The helpers below decide
- * whether to use PISA memory for a given dst, sk, skb.
+ * struct net_device caches the PISA enable flags for tx_bufs, tx_heads and
+ * tx_zerocopy used by the leaf device, refreshed every 256 jiffies. The helpers
+ * below decide whether to use PISA memory for a given dst, sk, skb.
  */
 #ifdef CONFIG_PISA
 
@@ -23,6 +23,7 @@ enum pisa_tx_flags {
 	PISA_TX_FLAG_BUFS	= BIT(0),
 	PISA_TX_FLAG_HEADS	= BIT(1),
 	PISA_TX_XFRM_OK		= BIT(2),
+	PISA_TX_FLAG_ZC		= BIT(3),
 	PISA_TX_TSTAMP_MASK	= ~0xffU,
 };
 
@@ -36,6 +37,10 @@ DECLARE_STATIC_KEY_FALSE(net_pisa_tx_skb_heads_key);
 
 u32 pisa_tx_flags_refresh(struct net_device *dev, u32 now);
 void *__pisa_skb_head_alloc_node(gfp_t flags, int node);
+bool __pisa_zc_iter_stop(struct sk_buff *skb, struct iov_iter *from,
+			 size_t *length, const struct sock *sk,
+			 struct page **pages, int max_pages,
+			 unsigned int orig_len, size_t *start, ssize_t *copied);
 
 /*
  * May TX data routed through @dst use PISA pages? Those pages stay readable by
@@ -144,6 +149,18 @@ static inline struct page_frag *sk_page_frag_dst(struct sock *sk,
 	       sk->sk_use_task_frag ? task_page_frag(dst) : sk_page_frag(sk);
 }
 
+/* Hook for __zerocopy_fill_skb_from_iter() MSG_ZEROCOPY upgrade (@pisa_user_key). */
+static inline bool pisa_zc_iter_stop(struct sk_buff *skb, struct iov_iter *from,
+				     size_t *length, const struct sock *sk,
+				     struct page **pages, int max_pages,
+				     unsigned int orig_len, size_t *start,
+				     ssize_t *copied)
+{
+	return pisa_user_enabled() &&
+	       __pisa_zc_iter_stop(skb, from, length, sk, pages, max_pages,
+				   orig_len, start, copied);
+}
+
 #else /* !CONFIG_PISA */
 
 static inline void *pisa_skb_head_alloc_node(gfp_t flags, int node) { return NULL; }
@@ -174,5 +191,14 @@ static inline struct page_frag *sk_page_frag_dst(struct sock *sk,
 	return sk_page_frag(sk);
 }
 
+static inline bool pisa_zc_iter_stop(struct sk_buff *skb, struct iov_iter *from,
+				     size_t *length, const struct sock *sk,
+				     struct page **pages, int max_pages,
+				     unsigned int orig_len, size_t *start,
+				     ssize_t *copied)
+{
+	return false;
+}
+
 #endif /* CONFIG_PISA */
 #endif /* _NET_PISA_H */
diff --git a/mm/pisa-user.c b/mm/pisa-user.c
index 5fb1ec7c45204..e4a4e1a606b24 100644
--- a/mm/pisa-user.c
+++ b/mm/pisa-user.c
@@ -439,6 +439,14 @@ bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 	return true;
 }
 
+/* Is @page, referenced by the caller, PISA memory that devices can read (usable for TX)? */
+bool pisa_page_tx_ok(const struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	return is_pisa_pfn(pfn) && (READ_ONCE(pisa_meta_of_pfn(pfn)->prot) & IOMMU_READ);
+}
+
 /* Migrate the single-page segments already added to @bio; the caller then extracts them again. */
 bool __pisa_bio_migrate_pages(struct bio *bio, struct iov_iter *iter,
 			      enum dma_data_direction dir)
diff --git a/net/core/datagram.c b/net/core/datagram.c
index ecc30a6f83023..c589a543c3166 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -62,6 +62,7 @@
 #include <net/tcp_states.h>
 #include <trace/events/skb.h>
 #include <net/busy_poll.h>
+#include <net/pisa.h>
 
 #include "devmem.h"
 
@@ -632,10 +633,11 @@ int skb_copy_datagram_from_iter_full(struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter_full);
 
-int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
-				struct iov_iter *from, size_t length)
+static int __zerocopy_fill_skb_from_iter(struct sk_buff *skb, struct iov_iter *from,
+					 size_t length, const struct sock *sk)
 {
 	int frag = skb_shinfo(skb)->nr_frags;
+	unsigned int orig_len = skb->len;
 
 	if (!skb_frags_readable(skb))
 		return -EFAULT;
@@ -654,6 +656,9 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 					    MAX_SKB_FRAGS - frag, &start);
 		if (copied < 0)
 			return -EFAULT;
+		if (pisa_zc_iter_stop(skb, from, &length, sk, pages,
+				      MAX_SKB_FRAGS - frag, orig_len, &start, &copied))
+			return copied;
 
 		length -= copied;
 
@@ -703,6 +708,12 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 	return 0;
 }
 
+int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
+				struct iov_iter *from, size_t length)
+{
+	return __zerocopy_fill_skb_from_iter(skb, from, length, NULL);
+}
+
 static int
 zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
 			      int length,
@@ -760,7 +771,7 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 	else if (binding)
 		ret = zerocopy_fill_skb_from_devmem(skb, from, length, binding);
 	else
-		ret = zerocopy_fill_skb_from_iter(skb, from, length);
+		ret = __zerocopy_fill_skb_from_iter(skb, from, length, sk);
 
 	truesize = skb->truesize - orig_size;
 	if (sk && sk->sk_type == SOCK_STREAM) {
diff --git a/net/core/pisa-net.c b/net/core/pisa-net.c
index d0a2c94419187..6422c472029a1 100644
--- a/net/core/pisa-net.c
+++ b/net/core/pisa-net.c
@@ -12,6 +12,8 @@
 #include <linux/pisa.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/uio.h>
 #include <net/hotdata.h>
 #include <net/pisa.h>
 
@@ -98,9 +100,10 @@ void *__pisa_skb_head_alloc_node(gfp_t flags, int node)
 }
 
 /*
- * The sysfs attributes pisa_tx_bufs and pisa_tx_skb_heads live on the
- * device that does DMA: the closest ancestor of a leaf net_device that has a
- * dma_mask (dev->dev.parent, or further up behind bus glue such as virtio).
+ * The sysfs attributes pisa_tx_bufs, pisa_tx_skb_heads and pisa_tx_zerocopy
+ * live on the device that does DMA: the closest ancestor of a leaf net_device
+ * that has a dma_mask (dev->dev.parent, or further up behind bus glue such as
+ * virtio).
  * A socket route (dst->dev) may instead point to an upper virtual net_device
  * (bond, VLAN, ipvlan, etc.), whose leaves are its lower devices.
  * Walking lower devices via netdev_walk_all_lower_dev_rcu() on every TX
@@ -108,6 +111,7 @@ void *__pisa_skb_head_alloc_node(gfp_t flags, int node)
  * result on the net_device and refreshes it at most once every 256 jiffies:
  *   bit 0 (PISA_TX_FLAG_BUFS):       pisa_tx_bufs enabled on lower device(s)
  *   bit 1 (PISA_TX_FLAG_HEADS):      pisa_tx_skb_heads enabled on lower device(s)
+ *   bit 3 (PISA_TX_FLAG_ZC):         pisa_tx_zerocopy enabled on lower device(s)
  *   bits 31..8 (PISA_TX_TSTAMP_MASK):  upper 24 bits of (u32)jiffies
  */
 static u32 pisa_tx_flags(const struct net_device *dev)
@@ -122,6 +126,8 @@ static u32 pisa_tx_flags(const struct net_device *dev)
 			flags |= PISA_TX_FLAG_BUFS;
 		if (READ_ONCE(parent->pisa_tx_skb_heads))
 			flags |= PISA_TX_FLAG_HEADS;
+		if (READ_ONCE(parent->pisa_tx_zerocopy))
+			flags |= PISA_TX_FLAG_ZC;
 	}
 	return flags;
 }
@@ -160,7 +166,8 @@ u32 pisa_tx_flags_refresh(struct net_device *dev, u32 now)
 		now |= pisa_tx_flags(dev);
 	} else {
 		struct netdev_nested_priv priv = {
-			.data = (void *)(uintptr_t)(PISA_TX_FLAG_BUFS | PISA_TX_FLAG_HEADS),
+			.data = (void *)(uintptr_t)(PISA_TX_FLAG_BUFS | PISA_TX_FLAG_HEADS |
+						    PISA_TX_FLAG_ZC),
 		};
 
 		rcu_read_lock();
@@ -173,3 +180,83 @@ u32 pisa_tx_flags_refresh(struct net_device *dev, u32 now)
 	return now;
 }
 EXPORT_SYMBOL(pisa_tx_flags_refresh);
+
+/*
+ * Upgrade user @pages to PISA memory and, for TCP over a pisa_tx_bufs device,
+ * trim non-PISA trailing pages from the batch.
+ *
+ * MSG_ZEROCOPY sends of @sk may migrate user pages into PISA memory when the
+ * egress device has pisa_tx_zerocopy set. *@tx_bufs tells whether it also has
+ * pisa_tx_bufs set, i.e. whether a copy would land in PISA memory.
+ */
+static bool pisa_zc_enabled(const struct sock *sk, bool *tx_bufs)
+{
+	const struct dst_entry *dst;
+
+	if (!sk || !sk->sk_use_task_frag)
+		return false;
+	guard(rcu)();
+	dst = rcu_dereference(sk->sk_dst_cache);
+	if (!__pisa_tx_gfp(dst, PISA_TX_FLAG_ZC))
+		return false;
+	*tx_bufs = use_pisa_tx_bufs(dst);
+	return true;
+}
+
+bool __pisa_zc_iter_stop(struct sk_buff *skb, struct iov_iter *from,
+			 size_t *length, const struct sock *sk,
+			 struct page **pages, int max_pages,
+			 unsigned int orig_len, size_t *start, ssize_t *copied)
+{
+	unsigned int i, nr;
+	bool tx_bufs;
+	ssize_t keep;
+
+	if (!user_backed_iter(from) || !pisa_zc_enabled(sk, &tx_bufs))
+		return false;
+
+	/* Move user pages into PISA memory, then look them up again. */
+	if (pisa_upgrade_user_pages(from, pages, *copied, *start,
+				    DMA_TO_DEVICE, false)) {
+		*copied = iov_iter_get_pages2(from, pages, *length, max_pages, start);
+		if (*copied <= 0) {
+			if (*copied < 0)
+				*copied = -EFAULT;
+			return true;
+		}
+	}
+
+	/*
+	 * Only TCP plain MSG_ZEROCOPY ubufs can fall back to copy, and the copy
+	 * only helps if it goes into PISA memory.
+	 */
+	if (!tx_bufs || skb->sk ||
+	    (skb_zcopy(skb) && skb_zcopy(skb)->ops != &msg_zerocopy_ubuf_ops))
+		return false;
+
+	/*
+	 * Trim @from to the leading pages that are in PISA memory devices can
+	 * read (an RX-only page would not be mapped for TX): drop the
+	 * references to the others, give their bytes back to @from, and cap
+	 * *@length so that the caller ends after attaching what is left.
+	 */
+	nr = DIV_ROUND_UP(*start + *copied, PAGE_SIZE);
+	for (i = 0; i < nr && pisa_page_tx_ok(pages[i]); i++)
+		;
+	if (i == nr)
+		return false;
+
+	keep = i ? i * PAGE_SIZE - *start : 0;
+	while (nr > i)
+		put_page(pages[--nr]);
+	iov_iter_revert(from, *copied - keep);
+	*length = keep;
+	if (keep) {
+		*copied = keep;
+		return false;
+	}
+
+	/* -EXDEV tells tcp_sendmsg_locked() to copy this chunk instead of zerocopy. */
+	*copied = (skb->len != orig_len) ? 0 : -EXDEV;
+	return true;
+}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4f487e0450d4b..be6b6f42ee77e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1942,7 +1942,8 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 
 	err = __zerocopy_sg_from_iter(msg, sk, skb, &msg->msg_iter, len,
 				      binding);
-	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
+	if (err == -EFAULT ||
+	    ((err == -EMSGSIZE || err == -EXDEV) && skb->len == orig_len)) {
 		u32 delta_truesize = skb->truesize - orig_truesize;
 		struct sock *save_sk = skb->sk;
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 83f8ed2aa9a7e..411714edb90bd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1132,6 +1132,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	int process_backlog = 0;
 	int sockc_err = 0;
 	int zc = 0;
+	bool must_copy = false;	/* copy the next chunk of a MSG_ZEROCOPY send */
 	long timeo;
 
 	flags = msg->msg_flags;
@@ -1293,7 +1294,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (copy > msg_data_left(msg))
 			copy = msg_data_left(msg);
 
-		if (zc == 0) {
+		if (zc == 0 || unlikely(must_copy)) {
 			bool merge = true;
 			int i = skb_shinfo(skb)->nr_frags;
 			struct page_frag *pfrag = sk_page_frag_dst(sk, __sk_dst_get(sk));
@@ -1338,6 +1339,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				page_ref_inc(pfrag->page);
 			}
 			pfrag->offset += copy;
+			must_copy = false;
 		} else if (zc == MSG_ZEROCOPY)  {
 			/* First append to a fragless skb builds initial
 			 * pure zerocopy skb
@@ -1357,6 +1359,14 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				tcp_mark_push(tp, skb);
 				goto new_segment;
 			}
+			/*
+			 * The next user page is not in PISA memory: copy this
+			 * chunk, without reporting SO_EE_CODE_ZEROCOPY_COPIED.
+			 */
+			if (unlikely(err == -EXDEV)) {
+				must_copy = true;
+				continue;
+			}
 			if (err < 0)
 				goto do_error;
 			copy = err;
-- 
2.56.1.809.ga0b61035b5-goog

