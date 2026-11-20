Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795136842;
	b=y87ctfYeQhJRbgyyInkFJzVrgj9iMQfkw9m2m3fze7LdfO6rJpSx33NAn8Uh9KFnZFIc
	 rdSs8dPlbJIujDqxJw1auGzet3OHHAehOimt3DUSw7aUIve1EBTDJUhHFL824SqEgArl6
	 Twx8VhkJCuQDH6ul+NqBTlDH5LzVvS1vowmey2U8Cd2ZSwHSsaLORIDJ6/RKi4jGp8cKL
	 nqSSXnVhBHzcubQdpNT4YWS0se3vN+pdY/CQlK5XMddMZfv+T5wo/jDyYxDFgUleKSaGe
	 xq7+Nqs7Q/Ls/vZJa02BkkTV5ptCgqnVRBpq9PmFz50YwwGNPDzkH4MKQY52blMcizw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795136842;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=0NShhv1zd0ubxSJzYJCtkDC/E3Z/rFUVqETx4t7zzV8=;
	b=wtNsBHIn8rISqSMi2H7SlGDOkwYnzl0YyZZyUzcAXClRtziUOrcU6mKY1PWbxXZxqhfS
	 QDsnhCG4cUF/F4NSrnP2Jhe7MaASKzG2gyRh9RAPLDKErq/ziyVknJLU3RIO4tg5cISIc
	 LGJhT2cQHrD+Nxl8Kxgp+7dBDFXRUhjbBHcBMBoxhcDleHnRDPCwCc+TpTab5P6Vrntes
	 xhFmjYdaHY3bO9qht6b02yEI/hX09far9floSKp7JPIkMDG4eECtZHDXBdMpawmaePH1K
	 PM5hKB3tCTG4y0CXpo8FHuJfxKCP6V71vhQMUfqIxoxAPZYQhzf3tOX2GwVIaTAkzPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DjftDs54;
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AE5607112D
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 01:07:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36AE5607112D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DjftDs54
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b1e00100eeso312678a12.3
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136840; x=1795741640; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0NShhv1zd0ubxSJzYJCtkDC/E3Z/rFUVqETx4t7zzV8=;
        b=DjftDs544vagqp8ZbfrpKAacGk7wt+K2MTjKUvjR1lL0aKsCEH7nqIztLprl9b2TkN
         40rUcKgthuIBXgNyeQr20uCxn1L9Tjr8YdQDayVxczqjVEc1elIMri6hW0dGY8WL9Lyg
         S+VmZw5oE3KuG9Vp3KKgYqXn87cmsiJdxkJKgrDfvUZ8Ay1tJaOWocpPocbn3ED4q7Z1
         BBO9oUlpkcLEDw8Zs2pZfAIkegqBYYWeDlhzLko05RRpSz3aQhI6FSiDDz88XGIKHK06
         umNVOVxiZ7NtxQA/uGPuq0jiGYVdTDlxvCnL2/UEoY3l34taghukW3wJg8HIfv1590fR
         LRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136840; x=1795741640;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0NShhv1zd0ubxSJzYJCtkDC/E3Z/rFUVqETx4t7zzV8=;
        b=ZmnKeVwMppXdAqYgt6po7IaBi8wkzyle7ScuK/OL2qaKLfUlUfPRmtORHv1QcjnkVN
         HGcFnrHR5mdVf9HmvfNfsUo1kgTPd9UGoONDRo/glUsT68Nz0eOOgWrIOifrC7kVPiEB
         9FaJZSxRDvLrljqT21e/rfIzJakKQjoAxJ4ISNz5zaW1u2XZuhiwvDHgRlTpOqcao81D
         w+4Z0bOVf9AqdhG0oLRSsaICSxoVcsw3QS4Mor2hgFwVKV5cTGcNXbMnSclNdE+aMC9A
         77FlQ7t/GNtnr3Q4k5WlJgmMn8HD2FpCA5hdo4d7qOrjT15du2Ea0OoomIq4Dk9Jq/8+
         6k1A==
X-Forwarded-Encrypted: i=1; AL+hErGiPs8B4V5oBwCYuw2Lu4j2DgjJocLK88CTQ4kgzhPtOrR5js++N31gFe1eblEs53jMi97bGcuclYs=@vger.kernel.org
X-Gm-Message-State: APuU4Z+j1wN2gqBf8Hzn4a97pC4ASUu00aa0VBFN21WxWcWXv/TGFsMp
	+iYSKKM54HCEIYzNL7b46ELO9q+6KWG7TBzCRNpBysU4KfaYfJvg8D/ysf/+yujmbioI0vYCXnl
	KELxk3A==
X-Received: from edl2-n1.prod.google.com ([2002:a05:6402:4242:10b0:6b5:6602:7fc9])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:448e:b0:6b7:d9df:bb1
 with SMTP id 4fb4d7f45d1cf-6ba37e7ffdfmr805771a12.22.1795136839247; Thu, 19
 Nov 2026 17:07:19 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:47 +0000
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
Message-ID: <20261120010655.467825-18-lrizzo@google.com>
Subject: [RFC PATCH v3 17/25] net: Allocate small skb heads from PISA
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

The linear part of most transmitted skbs is a small head from the
skbuff_small_head cache. To avoid per-packet IOMMU map/unmap operations
or bounce-buffer copies for headers, allow backing small TX skb heads
with PISA memory.

When per-device pisa_tx_skb_heads is enabled, create a parallel
skbuff_small_head_pisa slab cache backed by zeroed, read-only PISA
folios (SLAB_CACHE_PISA_RO). Eligible TX paths passing __GFP_PISA
allocate small heads from this cache and fall back to skbuff_small_head
on failure.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/base/core.c    |  3 +-
 include/linux/device.h |  6 +++
 include/net/pisa.h     | 64 +++++++++++++++++++++++++++++
 mm/pisa-kunit.c        |  5 ++-
 net/core/pisa-net.c    | 93 +++++++++++++++++++++++++++++++++++++-----
 net/core/skbuff.c      | 30 +++++++++++---
 net/core/sock.c        | 21 ++++++++--
 net/ipv4/ip_output.c   |  8 ++--
 net/ipv4/raw.c         |  6 +--
 net/ipv4/tcp.c         |  2 +-
 net/ipv4/tcp_output.c  | 14 ++++---
 net/ipv6/ip6_output.c  |  8 ++--
 net/ipv6/raw.c         |  6 +--
 13 files changed, 224 insertions(+), 42 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 5f1291e644c5e..92eec7d3d4cf1 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2951,7 +2951,7 @@ static DEVICE_ATTR_RW(name)
 PISA_BOOL_ATTR(pisa_coherent);
 PISA_BOOL_ATTR(pisa_rx_bufs);
 PISA_SET_ATTR(pisa_tx_bufs, net_pisa_tx_bufs_set);
-PISA_BOOL_ATTR(pisa_tx_skb_heads);
+PISA_SET_ATTR(pisa_tx_skb_heads, net_pisa_tx_skb_heads_set);
 PISA_BOOL_ATTR(pisa_tx_zerocopy);
 
 static struct attribute *dev_attr_pisa[] = {
@@ -3114,6 +3114,7 @@ static void device_remove_attrs(struct device *dev)
 	if (IS_ENABLED(CONFIG_PISA) && dev->dma_mask) {
 		device_remove_group(dev, &dev_attr_pisa_group);
 		net_pisa_tx_bufs_set(dev, false);
+		net_pisa_tx_skb_heads_set(dev, false);
 	}
 
 	if (dev->physical_location) {
diff --git a/include/linux/device.h b/include/linux/device.h
index 0d867d8255ba5..6776048d05ca8 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -819,6 +819,7 @@ struct device {
 
 #if defined(CONFIG_NET) && defined(CONFIG_PISA)
 int net_pisa_tx_bufs_set(struct device *dev, bool val);
+int net_pisa_tx_skb_heads_set(struct device *dev, bool val);
 #else
 /* Without CONFIG_NET the flag still gates block-device writes (see pisa_bdev_enabled()). */
 static inline int net_pisa_tx_bufs_set(struct device *dev, bool val)
@@ -826,6 +827,11 @@ static inline int net_pisa_tx_bufs_set(struct device *dev, bool val)
 	WRITE_ONCE(dev->pisa_tx_bufs, val);
 	return 0;
 }
+
+static inline int net_pisa_tx_skb_heads_set(struct device *dev, bool val)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #define __create_dev_flag_accessors(accessor_name, flag_name) \
diff --git a/include/net/pisa.h b/include/net/pisa.h
index 8e23d8b01e73d..7fe2e7d5aa97e 100644
--- a/include/net/pisa.h
+++ b/include/net/pisa.h
@@ -7,6 +7,11 @@
 #include <linux/tcp.h>
 #include <net/sock.h>
 
+struct sk_buff *__sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
+				       unsigned long data_len, int noblock,
+				       int *errcode, int max_page_order,
+				       gfp_t gfp);
+
 /*
  * struct net_device caches the PISA enable flags for tx_bufs and tx_heads used
  * by the leaf device, refreshed every 256 jiffies. The helpers below decide
@@ -16,6 +21,7 @@
 
 enum pisa_tx_flags {
 	PISA_TX_FLAG_BUFS	= BIT(0),
+	PISA_TX_FLAG_HEADS	= BIT(1),
 	PISA_TX_XFRM_OK		= BIT(2),
 	PISA_TX_TSTAMP_MASK	= ~0xffU,
 };
@@ -23,10 +29,13 @@ enum pisa_tx_flags {
 /*
  * Static keys guarding networking hooks:
  * - @net_pisa_tx_bufs_key: enabled while any device has pisa_tx_bufs set.
+ * - @net_pisa_tx_skb_heads_key: enabled while any device has pisa_tx_skb_heads set.
  */
 DECLARE_STATIC_KEY_FALSE(net_pisa_tx_bufs_key);
+DECLARE_STATIC_KEY_FALSE(net_pisa_tx_skb_heads_key);
 
 u32 pisa_tx_flags_refresh(struct net_device *dev, u32 now);
+void *__pisa_skb_head_alloc_node(gfp_t flags, int node);
 
 /*
  * May TX data routed through @dst use PISA pages? Those pages stay readable by
@@ -59,6 +68,48 @@ static inline gfp_t __pisa_tx_gfp(const struct dst_entry *dst,
  * ============================================================================
  */
 
+/* Hook for kmalloc_reserve() small skb head allocation (@net_pisa_tx_skb_heads_key). */
+static inline void *pisa_skb_head_alloc_node(gfp_t flags, int node)
+{
+	return static_branch_unlikely(&net_pisa_tx_skb_heads_key) ?
+	       __pisa_skb_head_alloc_node(flags, node) : NULL;
+}
+
+/* Hook for route-based skb head allocation (@net_pisa_tx_skb_heads_key). */
+static inline gfp_t pisa_tx_head_gfp(const struct dst_entry *dst)
+{
+	return static_branch_unlikely(&net_pisa_tx_skb_heads_key) ?
+	       __pisa_tx_gfp(dst, PISA_TX_FLAG_HEADS) : 0;
+}
+
+/* Hook for socket-based TCP skb head allocation (@net_pisa_tx_skb_heads_key). */
+static inline gfp_t pisa_tx_head_sk_gfp(const struct sock *sk)
+{
+	if (!static_branch_unlikely(&net_pisa_tx_skb_heads_key) || !sk)
+		return 0;
+	guard(rcu)();
+	return __pisa_tx_gfp(rcu_dereference(sk->sk_dst_cache), PISA_TX_FLAG_HEADS);
+}
+
+/* Hook for skb_copy*() / pskb_expand_head() (@net_pisa_tx_skb_heads_key). */
+static inline gfp_t skb_head_pisa_gfp(const struct sk_buff *skb)
+{
+	if (static_branch_unlikely(&net_pisa_tx_skb_heads_key) &&
+	    !skb->head_frag && pisa_virt_to_page(skb->head))
+		return __GFP_PISA;
+	return 0;
+}
+
+/* Hook for UDP/raw sock_alloc_send_skb() with @dst (@net_pisa_tx_skb_heads_key). */
+static inline struct sk_buff *sock_alloc_send_skb_dst(struct sock *sk,
+						      unsigned long size,
+						      int noblock, int *errcode,
+						      const struct dst_entry *dst)
+{
+	return __sock_alloc_send_pskb(sk, size, 0, noblock, errcode, 0,
+				      pisa_tx_head_gfp(dst));
+}
+
 /* Hook for route-based TX payload fragment selection (@net_pisa_tx_bufs_key). */
 static inline bool use_pisa_tx_bufs(const struct dst_entry *dst)
 {
@@ -95,6 +146,19 @@ static inline struct page_frag *sk_page_frag_dst(struct sock *sk,
 
 #else /* !CONFIG_PISA */
 
+static inline void *pisa_skb_head_alloc_node(gfp_t flags, int node) { return NULL; }
+static inline gfp_t pisa_tx_head_gfp(const struct dst_entry *dst) { return 0; }
+static inline gfp_t pisa_tx_head_sk_gfp(const struct sock *sk) { return 0; }
+static inline gfp_t skb_head_pisa_gfp(const struct sk_buff *skb) { return 0; }
+
+static inline struct sk_buff *sock_alloc_send_skb_dst(struct sock *sk,
+						      unsigned long size,
+						      int noblock, int *errcode,
+						      const struct dst_entry *dst)
+{
+	return __sock_alloc_send_pskb(sk, size, 0, noblock, errcode, 0, 0);
+}
+
 static inline bool use_pisa_tx_bufs(const struct dst_entry *dst) { return false; }
 static inline gfp_t pisa_tx_bufs_gfp(const struct sk_buff *skb) { return 0; }
 static inline bool is_pisa_pfrag(const struct page_frag *pfrag) { return false; }
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
index ec7af4313915a..0dbc3ecf44465 100644
--- a/mm/pisa-kunit.c
+++ b/mm/pisa-kunit.c
@@ -579,9 +579,10 @@ static void test_dev_pisa_attrs(struct kunit *test)
 	kunit_check_pisa_attr(test, dev, "pisa_coherent", &dev->pisa_coherent);
 	kunit_check_pisa_attr(test, dev, "pisa_rx_bufs", &dev->pisa_rx_bufs);
 	kunit_check_pisa_attr(test, dev, "pisa_tx_zerocopy", &dev->pisa_tx_zerocopy);
-	if (IS_ENABLED(CONFIG_NET))
+	if (IS_ENABLED(CONFIG_NET)) {
 		kunit_check_pisa_attr(test, dev, "pisa_tx_bufs", &dev->pisa_tx_bufs);
-	kunit_check_pisa_attr(test, dev, "pisa_tx_skb_heads", &dev->pisa_tx_skb_heads);
+		kunit_check_pisa_attr(test, dev, "pisa_tx_skb_heads", &dev->pisa_tx_skb_heads);
+	}
 	device_unregister(dev);
 }
 
diff --git a/net/core/pisa-net.c b/net/core/pisa-net.c
index 6d4909c82070c..d0a2c94419187 100644
--- a/net/core/pisa-net.c
+++ b/net/core/pisa-net.c
@@ -10,6 +10,9 @@
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/pisa.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <net/hotdata.h>
 #include <net/pisa.h>
 
 /* Enabled while at least one device has pisa_tx_bufs set. */
@@ -32,15 +35,79 @@ int net_pisa_tx_bufs_set(struct device *dev, bool val)
 }
 
 /*
- * The sysfs attribute pisa_tx_bufs lives on the device that does DMA: the
- * closest ancestor of a leaf net_device that has a dma_mask (dev->dev.parent,
- * or further up behind bus glue such as virtio). A socket route (dst->dev) may
- * instead point to an upper virtual net_device (bond, VLAN, ipvlan, etc.),
- * whose leaves are its lower devices. Walking lower devices via
- * netdev_walk_all_lower_dev_rcu() on every TX allocation would be too
- * expensive, so dev->pisa_tx_flags_tstamp caches the walk result on the net_device
- * and refreshes it at most once every 256 jiffies:
+ * Enabled while at least one device has pisa_tx_skb_heads set; small TX skb
+ * heads (__GFP_PISA) are allocated from skbuff_small_head_pisa.
+ */
+DEFINE_STATIC_KEY_FALSE(net_pisa_tx_skb_heads_key);
+EXPORT_SYMBOL(net_pisa_tx_skb_heads_key);
+
+static struct kmem_cache *pisa_skb_small_head_cache __read_mostly;
+
+/* Lazily initialize skbuff_small_head_pisa on first enable. */
+static int pisa_skb_head_init(void)
+{
+	unsigned int size = kmem_cache_size(net_hotdata.skb_small_head_cache);
+	struct kmem_cache_args args = {
+		/* As skbuff_small_head, see skb_init(). */
+		.useroffset	= 0,
+		.usersize	= SKB_WITH_OVERHEAD(size),
+		.sheaf_capacity	= 32,
+	};
+	static DEFINE_MUTEX(mutex);
+	struct kmem_cache *s;
+
+	guard(mutex)(&mutex);
+	if (pisa_skb_small_head_cache)
+		return 0;
+
+	/* No slab is allocated before the cache is published below. */
+	s = kmem_cache_create("skbuff_small_head_pisa", size, &args,
+			      SLAB_HWCACHE_ALIGN | SLAB_NO_MERGE | SLAB_CACHE_PISA_RO);
+	if (!s)
+		return -ENOMEM;
+	WRITE_ONCE(pisa_skb_small_head_cache, s);
+	return 0;
+}
+
+int net_pisa_tx_skb_heads_set(struct device *dev, bool val)
+{
+	static DEFINE_MUTEX(lock);
+
+	if (val) {
+		int ret = pisa_skb_head_init();
+
+		if (ret)
+			return ret;
+	}
+
+	guard(mutex)(&lock);
+	if (dev->pisa_tx_skb_heads != val) {
+		WRITE_ONCE(dev->pisa_tx_skb_heads, val);
+		if (val)
+			static_branch_inc(&net_pisa_tx_skb_heads_key);
+		else
+			static_branch_dec(&net_pisa_tx_skb_heads_key);
+	}
+	return 0;
+}
+
+void *__pisa_skb_head_alloc_node(gfp_t flags, int node)
+{
+	return kmem_cache_alloc_node(pisa_skb_small_head_cache,
+				     flags | __GFP_NOMEMALLOC | __GFP_NOWARN, node);
+}
+
+/*
+ * The sysfs attributes pisa_tx_bufs and pisa_tx_skb_heads live on the
+ * device that does DMA: the closest ancestor of a leaf net_device that has a
+ * dma_mask (dev->dev.parent, or further up behind bus glue such as virtio).
+ * A socket route (dst->dev) may instead point to an upper virtual net_device
+ * (bond, VLAN, ipvlan, etc.), whose leaves are its lower devices.
+ * Walking lower devices via netdev_walk_all_lower_dev_rcu() on every TX
+ * allocation would be too expensive, so dev->pisa_tx_flags_tstamp caches the walk
+ * result on the net_device and refreshes it at most once every 256 jiffies:
  *   bit 0 (PISA_TX_FLAG_BUFS):       pisa_tx_bufs enabled on lower device(s)
+ *   bit 1 (PISA_TX_FLAG_HEADS):      pisa_tx_skb_heads enabled on lower device(s)
  *   bits 31..8 (PISA_TX_TSTAMP_MASK):  upper 24 bits of (u32)jiffies
  */
 static u32 pisa_tx_flags(const struct net_device *dev)
@@ -50,8 +117,12 @@ static u32 pisa_tx_flags(const struct net_device *dev)
 
 	while (parent && !parent->dma_mask)
 		parent = parent->parent;
-	if (parent && READ_ONCE(parent->pisa_tx_bufs))
-		flags |= PISA_TX_FLAG_BUFS;
+	if (parent) {
+		if (READ_ONCE(parent->pisa_tx_bufs))
+			flags |= PISA_TX_FLAG_BUFS;
+		if (READ_ONCE(parent->pisa_tx_skb_heads))
+			flags |= PISA_TX_FLAG_HEADS;
+	}
 	return flags;
 }
 
@@ -89,7 +160,7 @@ u32 pisa_tx_flags_refresh(struct net_device *dev, u32 now)
 		now |= pisa_tx_flags(dev);
 	} else {
 		struct netdev_nested_priv priv = {
-			.data = (void *)(uintptr_t)PISA_TX_FLAG_BUFS,
+			.data = (void *)(uintptr_t)(PISA_TX_FLAG_BUFS | PISA_TX_FLAG_HEADS),
 		};
 
 		rcu_read_lock();
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1ac1e327ac4c6..4f487e0450d4b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -70,6 +70,7 @@
 #include <net/protocol.h>
 #include <net/dst.h>
 #include <net/sock.h>
+#include <net/pisa.h>
 #include <net/checksum.h>
 #include <net/gro.h>
 #include <net/gso.h>
@@ -93,6 +94,7 @@
 #include <linux/user_namespace.h>
 #include <linux/indirect_call_wrapper.h>
 #include <linux/textsearch.h>
+#include <linux/pisa.h>
 
 #include "dev.h"
 #include "devmem.h"
@@ -607,16 +609,23 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 			     struct sk_buff *skb)
 {
+	bool pisa = flags & __GFP_PISA;
 	size_t obj_size;
 	void *obj;
 
+	flags &= ~__GFP_PISA_RW;
 	obj_size = SKB_HEAD_ALIGN(*size);
 	if (obj_size <= SKB_SMALL_HEAD_CACHE_SIZE &&
 	    !(flags & KMALLOC_NOT_NORMAL_BITS)) {
+		*size = SKB_SMALL_HEAD_CACHE_SIZE;
+		if (unlikely(pisa)) {
+			obj = pisa_skb_head_alloc_node(flags, node);
+			if (likely(obj))
+				goto out;
+		}
 		obj = kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
 				flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 				node);
-		*size = SKB_SMALL_HEAD_CACHE_SIZE;
 		if (likely(obj))
 			goto out;
 		/* Try again but now we are using pfmemalloc reserves */
@@ -2194,6 +2203,7 @@ struct sk_buff *skb_copy(const struct sk_buff *skb, gfp_t gfp_mask)
 
 	headerlen = skb_headroom(skb);
 	size = skb_end_offset(skb) + skb->data_len;
+	gfp_mask |= skb_head_pisa_gfp(skb);
 	n = __alloc_skb(size, gfp_mask,
 			skb_alloc_rx_flag(skb), NUMA_NO_NODE);
 	if (!n)
@@ -2238,7 +2248,10 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 {
 	unsigned int size = skb_headlen(skb) + headroom;
 	int flags = skb_alloc_rx_flag(skb) | (fclone ? SKB_ALLOC_FCLONE : 0);
-	struct sk_buff *n = __alloc_skb(size, gfp_mask, flags, NUMA_NO_NODE);
+	struct sk_buff *n;
+
+	/* For the head only: @gfp_mask is also used to orphan frags below. */
+	n = __alloc_skb(size, gfp_mask | skb_head_pisa_gfp(skb), flags, NUMA_NO_NODE);
 
 	if (!n)
 		goto out;
@@ -2327,7 +2340,8 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
+	/* For the head only: @gfp_mask is also used to orphan frags below. */
+	data = kmalloc_reserve(&size, gfp_mask | skb_head_pisa_gfp(skb), NUMA_NO_NODE, NULL);
 	if (!data)
 		goto nodata;
 	size = SKB_WITH_OVERHEAD(size);
@@ -2535,6 +2549,7 @@ struct sk_buff *skb_copy_expand(const struct sk_buff *skb,
 		return NULL;
 
 	oldheadroom = skb_headroom(skb);
+	gfp_mask |= skb_head_pisa_gfp(skb);
 	n = __alloc_skb(newheadroom + skb->len + newtailroom,
 			gfp_mask, skb_alloc_rx_flag(skb),
 			NUMA_NO_NODE);
@@ -5037,7 +5052,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 				hsize = len;
 
 			nskb = __alloc_skb(hsize + doffset + headroom,
-					   GFP_ATOMIC, skb_alloc_rx_flag(head_skb),
+					   GFP_ATOMIC | skb_head_pisa_gfp(head_skb),
+					   skb_alloc_rx_flag(head_skb),
 					   NUMA_NO_NODE);
 
 			if (unlikely(!nskb))
@@ -7012,7 +7028,8 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
+	/* For the head only: @gfp_mask is also used to orphan frags below. */
+	data = kmalloc_reserve(&size, gfp_mask | skb_head_pisa_gfp(skb), NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
 	size = SKB_WITH_OVERHEAD(size);
@@ -7134,7 +7151,8 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
+	/* For the head only: @gfp_mask is also used to orphan frags below. */
+	data = kmalloc_reserve(&size, gfp_mask | skb_head_pisa_gfp(skb), NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
 	size = SKB_WITH_OVERHEAD(size);
diff --git a/net/core/sock.c b/net/core/sock.c
index 56dea49baaec2..0599c7d1aa6d0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3062,9 +3062,10 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
  *	Generic send/receive buffer handlers
  */
 
-struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
-				     unsigned long data_len, int noblock,
-				     int *errcode, int max_page_order)
+struct sk_buff *__sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
+				       unsigned long data_len, int noblock,
+				       int *errcode, int max_page_order,
+				       gfp_t gfp)
 {
 	struct sk_buff *skb;
 	long timeo;
@@ -3093,7 +3094,8 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 		timeo = sock_wait_for_wmem(sk, timeo);
 	}
 	skb = alloc_skb_with_frags(header_len, data_len, max_page_order,
-				   errcode, sk->sk_allocation);
+				   errcode,
+				   sk->sk_allocation | gfp);
 	if (skb)
 		skb_set_owner_w(skb, sk);
 	return skb;
@@ -3104,6 +3106,17 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 	*errcode = err;
 	return NULL;
 }
+EXPORT_SYMBOL(__sock_alloc_send_pskb);
+
+struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
+				     unsigned long data_len, int noblock,
+				     int *errcode, int max_page_order)
+{
+	/* Callers with data_len != 0 (unix, packet, tun/tap) have no sk_dst_cache, so gfp is 0. */
+	return __sock_alloc_send_pskb(sk, header_len, data_len, noblock,
+				      errcode, max_page_order,
+				      pisa_tx_head_sk_gfp(sk));
+}
 EXPORT_SYMBOL(sock_alloc_send_pskb);
 
 int __sock_cmsg_send(struct sock *sk, struct cmsghdr *cmsg,
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 50b8c92c3cd5e..f710cf959124f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1135,14 +1135,16 @@ static int __ip_append_data(struct sock *sk,
 			alloclen += alloc_extra;
 
 			if (transhdrlen) {
-				skb = sock_alloc_send_skb(sk, alloclen,
-						(flags & MSG_DONTWAIT), &err);
+				skb = sock_alloc_send_skb_dst(sk, alloclen,
+							      flags & MSG_DONTWAIT,
+							      &err, &rt->dst);
 			} else {
 				skb = NULL;
 				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
 				    2 * sk->sk_sndbuf)
 					skb = alloc_skb(alloclen,
-							sk->sk_allocation);
+							sk->sk_allocation |
+							pisa_tx_head_gfp(&rt->dst));
 				if (unlikely(!skb))
 					err = -ENOBUFS;
 			}
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index f33a9dfc53099..87622fc1e2849 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -60,6 +60,7 @@
 #include <linux/ip.h>
 #include <linux/net.h>
 #include <net/ip.h>
+#include <net/pisa.h>
 #include <net/icmp.h>
 #include <net/udp.h>
 #include <net/raw.h>
@@ -358,9 +359,8 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 
 	hlen = LL_RESERVED_SPACE(rt->dst.dev);
 	tlen = rt->dst.dev->needed_tailroom;
-	skb = sock_alloc_send_skb(sk,
-				  length + hlen + tlen + 15,
-				  flags & MSG_DONTWAIT, &err);
+	skb = sock_alloc_send_skb_dst(sk, length + hlen + tlen + 15,
+				      flags & MSG_DONTWAIT, &err, &rt->dst);
 	if (!skb)
 		goto error;
 	skb_reserve(skb, hlen);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3c3edc48705d7..83f8ed2aa9a7e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -932,7 +932,7 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, gfp_t gfp,
 {
 	struct sk_buff *skb;
 
-	skb = alloc_skb_fclone(MAX_TCP_HEADER, gfp);
+	skb = alloc_skb_fclone(MAX_TCP_HEADER, gfp | pisa_tx_head_sk_gfp(sk));
 	if (likely(skb)) {
 		bool mem_scheduled;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cf3ddc055d48d..24629788295b6 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -43,6 +43,7 @@
 #include <net/smc.h>
 #include <net/proto_memory.h>
 #include <net/psp.h>
+#include <net/pisa.h>
 
 #include <linux/compiler.h>
 #include <linux/gfp.h>
@@ -3893,7 +3894,8 @@ void tcp_send_fin(struct sock *sk)
 	} else {
 		skb = alloc_skb_fclone(MAX_TCP_HEADER,
 				       sk_gfp_mask(sk, GFP_ATOMIC |
-						       __GFP_NOWARN));
+						       __GFP_NOWARN) |
+				       pisa_tx_head_sk_gfp(sk));
 		if (unlikely(!skb))
 			return;
 
@@ -3921,7 +3923,7 @@ void tcp_send_active_reset(struct sock *sk, enum sk_rst_reason reason)
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTRSTS);
 
 	/* NOTE: No TCP options attached and we never retransmit this. */
-	skb = alloc_skb(MAX_TCP_HEADER, priority);
+	skb = alloc_skb(MAX_TCP_HEADER, priority | pisa_tx_head_sk_gfp(sk));
 	if (!skb) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTFAILED);
 		return;
@@ -4011,7 +4013,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	int mss;
 	u64 now;
 
-	skb = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC);
+	skb = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC | pisa_tx_head_gfp(dst));
 	if (unlikely(!skb)) {
 		dst_release(dst);
 		return NULL;
@@ -4548,7 +4550,8 @@ void __tcp_send_ack(struct sock *sk, u32 rcv_nxt, u16 flags)
 	 * sock.
 	 */
 	buff = alloc_skb(MAX_TCP_HEADER,
-			 sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN));
+			 sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN) |
+			 pisa_tx_head_sk_gfp(sk));
 	if (unlikely(!buff)) {
 		struct inet_connection_sock *icsk = inet_csk(sk);
 		unsigned long delay;
@@ -4601,7 +4604,8 @@ static int tcp_xmit_probe_skb(struct sock *sk, int urgent, int mib)
 
 	/* We don't queue it, tcp_transmit_skb() sets ownership. */
 	skb = alloc_skb(MAX_TCP_HEADER,
-			sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN));
+			sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN) |
+			pisa_tx_head_sk_gfp(sk));
 	if (!skb)
 		return -1;
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8f6f0bed15499..9a853655f8558 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1699,14 +1699,16 @@ static int __ip6_append_data(struct sock *sk,
 				goto error;
 			}
 			if (transhdrlen) {
-				skb = sock_alloc_send_skb(sk, alloclen,
-						(flags & MSG_DONTWAIT), &err);
+				skb = sock_alloc_send_skb_dst(sk, alloclen,
+							      flags & MSG_DONTWAIT,
+							      &err, &rt->dst);
 			} else {
 				skb = NULL;
 				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
 				    2 * sk->sk_sndbuf)
 					skb = alloc_skb(alloclen,
-							sk->sk_allocation);
+							sk->sk_allocation |
+							pisa_tx_head_gfp(&rt->dst));
 				if (unlikely(!skb))
 					err = -ENOBUFS;
 			}
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 00d832c7cdae9..aa10e74d0db3f 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -33,6 +33,7 @@
 
 #include <net/net_namespace.h>
 #include <net/ip.h>
+#include <net/pisa.h>
 #include <net/sock.h>
 #include <net/snmp.h>
 
@@ -614,9 +615,8 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 	if (flags&MSG_PROBE)
 		goto out;
 
-	skb = sock_alloc_send_skb(sk,
-				  length + hlen + tlen + 15,
-				  flags & MSG_DONTWAIT, &err);
+	skb = sock_alloc_send_skb_dst(sk, length + hlen + tlen + 15,
+				      flags & MSG_DONTWAIT, &err, &rt->dst);
 	if (!skb)
 		goto error;
 	skb_reserve(skb, hlen);
-- 
2.56.1.809.ga0b61035b5-goog

