Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795183825;
	b=lJnmA+YGdMCO+Q93fJd58Ex9rwdLrTBnqfCHg3199J/ghI2VBXcIIogZNY7L6rjg6qa2
	 Z5kZBqmXsWd9p+I2aAvaE/gPgTLxpAZCcTo2JI1uT9EghpmaGZm0oHzWTYRd/39wlL3yP
	 2fWsVCYIDLWpSHab+nH6p+P9bTcbERw5EGOj8MZj3jINqyFa5Lw7WLmCS5403ysxA17wu
	 LXc09rX1fUdz7xyndHLttenRHNkkYhtVHhfx1X4cp2MpzcJXZwSQdPNGjLr6tyR81E6gT
	 JqxxuDatULuaieUaCRd5/xR7rQaR4ohKiFKEyrHg0N3AXmEPfoBWmpVBzIerv/qHVAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183825;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5cMka++9FgI6SwfLQeaYxr5wwbW+CS32qzbR7n0A0CY=;
	b=X8xytI0R/mKMAl+2pYcFu+i9Q9P49MwH+wjs0tOjOQAJdbkx1lVd5JEDwZ8r/wOW5jmr
	 qw0GnglxEs6LfpR/wy2DqQwo/a2/GI1Qt+E/XylaGeQckg3jkDt1njOVH5APNgMJzaU3m
	 4VllR1gZx8XD3y3NV7dtQIg+yVAeIYxy+VmyFZWAaN/fYYWdcmqLiRE1AKu6dq56UYM09
	 zzTGp5YO8FiZcCw13Uioxfu1S0way9kCLe8HMCJx08G4qq/jS9o3uLFz5UKUuKGXju/24
	 qkxcYyJJ5KPZ86CGafkONBtEB8LSgI+b3TjDiapWZ7naN85pjpjVatFQdKz+peYh2mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hOUr5zyk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CC0606A325;
	Fri, 20 Nov 2026 14:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hOUr5zyk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549111F000C0;
	Fri, 20 Nov 2026 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795183824;
	bh=5cMka++9FgI6SwfLQeaYxr5wwbW+CS32qzbR7n0A0CY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hOUr5zykayAZfx9Utf1WxEc4cwwU/QfDhE1QBWgf9vUOBmvK4ULZYH8eugJ42jBEj
	 EId9K4YAD+/dyXD3vyoSflc1SDnia+PjPpyUcZ4PKEGOw67uZOJwsx2s/Rt0RtmHMH
	 UeEqiHs6+56qG9B3ZOA6tTF8keVAetaWRxWpNUtCx8362Bjy0DCjn3ZWNCqt3Ta9Uf
	 yW9Uy5UeVvPMo1x3SMj/+O/SmBxfGQ7L6Ja1IlrvIz3prAyfJBN/ltfU2aYda+RCkg
	 p1bIpXKbFErmRYeN8uuJn2OMBxgEZJOzyOgbrgVIeMO2no2lv7NCcAvl9DvzROaQRW
	 kNWIDNMHM5ZKw==
Date: Fri, 20 Nov 2026 14:10:13 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Luigi Rizzo <lrizzo@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Simon Horman <horms@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Naman Gulati <namangulati@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	netdev@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 11/25] mm: Migrate user pages into PISA
Message-ID: <awBUG15auEfX2Uc6@gremlin>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-12-lrizzo@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120010655.467825-12-lrizzo@google.com>

On Fri, Nov 20, 2026 at 01:06:41AM +0000, Luigi Rizzo wrote:
> Zero-copy DMA paths (such as O_DIRECT disk I/O and MSG_ZEROCOPY sockets)
> map each user page with a per-buffer IOMMU mapping and IOTLB flush.
> Moving user buffers into PISA blocks once allows subsequent DMA
> operations to reuse pre-mapped 2MB IOMMU entries.
>
> Add mm/pisa-user.c to migrate private anonymous order-0 user pages into
> per-node DMA_TO_DEVICE PISA allocators, controlled by
> pisa.user_max_pages (0 = disabled), via madvise(MADV_PISA) /
> MADV_NOPISA (also supported via process_madvise()) and
> pisa_upgrade_user_pages().

No, this isn't how madvise works. It's not a place to stuff custom hooks for a
feature you want.

>
> Large anonymous folios are split to order 0 first, while budget remains,
> with split_folio_to_list_keep_zero(): a variant of split_folio_to_list()
> that leaves zero-filled subpages mapped instead of remapping them to the
> shared zeropage, so that pages the caller is about to write to (e.g. the
> target of an O_DIRECT read) are still there to migrate.
>
> Signed-off-by: Luigi Rizzo <lrizzo@google.com>

No thanks. This whole approach seems completely wrong.

> ---
>  include/linux/huge_mm.h                |   7 +
>  include/linux/pisa-mm.h                |   8 +
>  include/linux/pisa.h                   |  18 ++
>  include/linux/swap.h                   |   1 +
>  include/uapi/asm-generic/mman-common.h |   2 +
>  mm/Makefile                            |   2 +-
>  mm/huge_memory.c                       |  36 ++-
>  mm/madvise.c                           |  19 ++
>  mm/pisa-alloc.c                        |   2 +
>  mm/pisa-priv.h                         |   2 +
>  mm/pisa-user.c                         | 394 +++++++++++++++++++++++++
>  11 files changed, 483 insertions(+), 8 deletions(-)
>  create mode 100644 mm/pisa-user.c
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index fac05120ab774..d679de8cf261d 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -404,6 +404,7 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>  int folio_split_unmapped(struct folio *folio, unsigned int new_order);
>  unsigned int min_order_for_split(struct folio *folio);
>  int split_folio_to_list(struct folio *folio, struct list_head *list);
> +int split_folio_to_list_keep_zero(struct folio *folio, struct list_head *list);
>  int folio_check_splittable(struct folio *folio, unsigned int new_order,
>  			   enum split_type split_type);
>  int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
> @@ -671,6 +672,12 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
>  	return -EINVAL;
>  }
>
> +static inline int split_folio_to_list_keep_zero(struct folio *folio, struct list_head *list)
> +{
> +	VM_WARN_ON_ONCE_FOLIO(1, folio);
> +	return -EINVAL;
> +}
> +
>  static inline int folio_split(struct folio *folio, unsigned int new_order,
>  		struct page *page, struct list_head *list)
>  {
> diff --git a/include/linux/pisa-mm.h b/include/linux/pisa-mm.h
> index d55a42397c4b3..1e82e081b4004 100644
> --- a/include/linux/pisa-mm.h
> +++ b/include/linux/pisa-mm.h
> @@ -11,6 +11,8 @@ unsigned long __pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order,
>  				      int preferred_nid, int nr_pages,
>  				      struct page **page_array, bool frozen);
>  bool __pisa_free_page(struct page *page, unsigned int order);
> +int pisa_madvise(struct vm_area_struct *vma, unsigned long start,
> +		 unsigned long end, bool to_pisa);
>
>  /*
>   * ============================================================================
> @@ -77,5 +79,11 @@ static inline bool pisa_free_page(struct page *page, unsigned int order)
>  	return false;
>  }
>
> +static inline int pisa_madvise(struct vm_area_struct *vma, unsigned long start,
> +			       unsigned long end, bool to_pisa)
> +{
> +	return -EINVAL;
> +}
> +
>  #endif /* CONFIG_PISA */
>  #endif /* _LINUX_PISA_MM_H */
> diff --git a/include/linux/pisa.h b/include/linux/pisa.h
> index edd34771ad1c4..9321e7ff00042 100644
> --- a/include/linux/pisa.h
> +++ b/include/linux/pisa.h
> @@ -14,6 +14,7 @@
>
>  struct iommu_domain;
>  struct iova_domain;
> +struct iov_iter;
>
>  /**
>   * struct pisa_iova - A domain's IOVA window reserved for PISA pages
> @@ -70,9 +71,11 @@ enum {
>   * Static keys guarding all kernel hooks:
>   * - @pisa_key: enabled on first device opt-in (pisa_meta_init()).
>   * - @pisa_recycle_check_key: enabled when pisa.compact or pisa.target_usage_percent > 0.
> + * - @pisa_user_key: enabled when pisa.user_max_pages > 0.
>   */
>  DECLARE_STATIC_KEY_FALSE(pisa_key);
>  DECLARE_STATIC_KEY_FALSE(pisa_recycle_check_key);
> +DECLARE_STATIC_KEY_FALSE(pisa_user_key);
>
>  extern u32 *pisa_pfn2slot;
>  extern unsigned int pisa_nr_slots;
> @@ -89,12 +92,19 @@ void *__pisa_alloc_map_coherent_dev(struct device *dev, size_t size,
>  				    unsigned long attrs);
>  bool __pisa_has_free_blocks_rx(unsigned int order, int nid);
>  bool __pisa_page_can_recycle(const struct page *page);
> +bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
> +			     size_t size, size_t offset);
>
>  static inline bool pisa_enabled(void)
>  {
>  	return static_branch_unlikely(&pisa_key);
>  }
>
> +static inline bool pisa_user_enabled(void)
> +{
> +	return static_branch_unlikely(&pisa_user_key);
> +}
> +
>  static inline u32 pisa_pfn_flags(unsigned long pfn)
>  {
>  	unsigned long frame = pfn >> PISA_ORDER;
> @@ -195,6 +205,7 @@ static inline bool pisa_page_can_recycle(const struct page *page)
>
>  static inline int pisa_meta_init(void) { return -EOPNOTSUPP; }
>  static inline bool pisa_enabled(void) { return false; }
> +static inline bool pisa_user_enabled(void) { return false; }
>  static inline bool is_pisa_pfn(unsigned long pfn) { return false; }
>  static inline bool is_pisa_page(const struct page *page) { return false; }
>  static inline bool is_pisa_phys(phys_addr_t phys) { return false; }
> @@ -228,6 +239,13 @@ static inline bool pisa_page_can_recycle(const struct page *page)
>  	return true;
>  }
>
> +static inline bool pisa_upgrade_user_pages(struct iov_iter *iter,
> +					   struct page **pages, size_t size,
> +					   size_t offset)
> +{
> +	return false;
> +}
> +
>  #endif /* CONFIG_PISA */
>
>  #if defined(CONFIG_PISA) && defined(CONFIG_IOMMU_DMA)
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4f686709d71f0..3736786ccc5a3 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -314,6 +314,7 @@ extern unsigned long totalreserve_pages;
>  /* linux/mm/folio.c */
>  void folio_add_lru(struct folio *folio);
>  void folio_mark_accessed(struct folio *folio);
> +void lru_add_drain(void);
>  void lru_add_drain_all(void);
>
>  enum lru_cache_drained {
> diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
> index ef1c27fa3c570..c4332db8e56ff 100644
> --- a/include/uapi/asm-generic/mman-common.h
> +++ b/include/uapi/asm-generic/mman-common.h
> @@ -81,6 +81,8 @@
>
>  #define MADV_GUARD_INSTALL 102		/* fatal signal on access to range */
>  #define MADV_GUARD_REMOVE 103		/* unguard range */
> +#define MADV_PISA		210	/* move pages into PISA memory */
> +#define MADV_NOPISA		211	/* move pages out of PISA memory */
>
>  /* compatibility flags */
>  #define MAP_FILE	0
> diff --git a/mm/Makefile b/mm/Makefile
> index 7d624e4bad456..d6b54a6eb3dc0 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -147,7 +147,7 @@ obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
>  obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
>  obj-$(CONFIG_EXECMEM) += execmem.o
>  obj-$(CONFIG_PISA) += pisa.o
> -pisa-y := pisa-meta.o pisa-alloc.o pisa-node.o
> +pisa-y := pisa-meta.o pisa-alloc.o pisa-node.o pisa-user.o
>  obj-$(CONFIG_PISA_META_KUNIT_TEST) += pisa-kunit.o
>  obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
>  obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7791872f14af7..ffa3912f2418b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4113,7 +4113,8 @@ static void folio_reset_partially_mapped(struct folio *folio)
>
>  static int __folio_freeze_split_anon(struct folio *folio,
>  		unsigned int new_order, struct page *split_at, bool do_lru,
> -		struct list_head *list, enum split_type split_type)
> +		struct list_head *list, enum split_type split_type,
> +		bool keep_zero)
>  {
>  	struct folio *end_folio = folio_next(folio);
>  	struct swap_cluster_info *ci = NULL;
> @@ -4207,7 +4208,13 @@ static int __folio_freeze_split_anon(struct folio *folio,
>  out_no_split:
>  	local_irq_enable();
>  	if (anon_vma) {
> -		if (!ret && !folio_is_device_private(folio))
> +		/*
> +		 * Zero-filled anon subpages are normally unmapped, freed and
> +		 * replaced by the shared zeropage. A @keep_zero caller needs
> +		 * the subpages themselves, e.g. to migrate them before a
> +		 * device writes to them.
> +		 */
> +		if (!ret && !folio_is_device_private(folio) && !keep_zero)
>  			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
>  		remap_anon_folio(folio, 1 << old_order, ttu_flags);
>  	}
> @@ -4387,6 +4394,7 @@ static int __folio_freeze_split_file(struct folio *folio,
>   * @lock_at: a page within @folio to be left locked to caller
>   * @list: after-split folios will be put on it if non NULL
>   * @split_type: perform uniform split or not (non-uniform split)
> + * @keep_zero: do not remap zero-filled anon subpages to the shared zeropage
>   *
>   * It calls __split_frozen_folio() to perform uniform and non-uniform split.
>   * It is in charge of checking whether the split is supported or not and
> @@ -4402,7 +4410,8 @@ static int __folio_freeze_split_file(struct folio *folio,
>   */
>  static int __folio_split(struct folio *folio, unsigned int new_order,
>  		struct page *split_at, struct page *lock_at,
> -		struct list_head *list, enum split_type split_type)
> +		struct list_head *list, enum split_type split_type,
> +		bool keep_zero)
>  {
>  	struct folio *end_folio = folio_next(folio);
>  	const bool is_anon = folio_test_anon(folio);
> @@ -4432,7 +4441,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>
>  	if (is_anon)
>  		ret = __folio_freeze_split_anon(folio, new_order, split_at,
> -						true, list, split_type);
> +						true, list, split_type,
> +						keep_zero);
>  	else
>  		ret = __folio_freeze_split_file(folio, new_order, split_at,
>  						list, split_type);
> @@ -4495,7 +4505,7 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
>
>  	return __folio_freeze_split_anon(folio, new_order, &folio->page,
> -					 false, NULL, SPLIT_TYPE_UNIFORM);
> +					 false, NULL, SPLIT_TYPE_UNIFORM, false);
>  }
>
>  /*
> @@ -4551,7 +4561,7 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>  	struct folio *folio = page_folio(page);
>
>  	return __folio_split(folio, new_order, &folio->page, page, list,
> -			     SPLIT_TYPE_UNIFORM);
> +			     SPLIT_TYPE_UNIFORM, false);
>  }
>
>  /**
> @@ -4582,7 +4592,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
>  		struct page *split_at, struct list_head *list)
>  {
>  	return __folio_split(folio, new_order, split_at, &folio->page, list,
> -			     SPLIT_TYPE_NON_UNIFORM);
> +			     SPLIT_TYPE_NON_UNIFORM, false);
>  }
>
>  /**
> @@ -4617,6 +4627,18 @@ int split_folio_to_list(struct folio *folio, struct list_head *list)
>  	return split_huge_page_to_list_to_order(&folio->page, list, 0);
>  }
>
> +/*
> + * As split_folio_to_list(), but zero-filled subpages of an anon folio stay
> + * mapped instead of being remapped to the shared zeropage. For callers that
> + * are about to take write references on the subpages: PISA uses it to migrate
> + * the pages of an I/O buffer, e.g. the target of an O_DIRECT read.
> + */
> +int split_folio_to_list_keep_zero(struct folio *folio, struct list_head *list)
> +{
> +	return __folio_split(folio, 0, &folio->page, &folio->page, list,
> +			     SPLIT_TYPE_UNIFORM, true);
> +}
> +
>  /*
>   * __folio_unqueue_deferred_split() is not to be called directly:
>   * the folio_unqueue_deferred_split() inline wrapper in mm/internal.h
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 0214efd2a014f..46981ad295aa5 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -6,6 +6,7 @@
>   * Copyright (C) 2002  Christoph Hellwig
>   */
>
> +#include <linux/pisa-mm.h>
>  #include <linux/mman.h>
>  #include <linux/pagemap.h>
>  #include <linux/syscalls.h>
> @@ -1393,6 +1394,11 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
>  		return madvise_guard_install(madv_behavior);
>  	case MADV_GUARD_REMOVE:
>  		return madvise_guard_remove(madv_behavior);
> +#ifdef MADV_PISA
> +	case MADV_PISA:
> +	case MADV_NOPISA:
> +		return pisa_madvise(vma, range->start, range->end, behavior == MADV_PISA);
> +#endif
>
>  	/* The below behaviours update VMAs via madvise_update_vma(). */
>
> @@ -1582,6 +1588,11 @@ madvise_behavior_valid(int behavior)
>  	case MADV_HWPOISON:
>  #endif
>  		return true;
> +#ifdef MADV_PISA
> +	case MADV_PISA:
> +	case MADV_NOPISA:
> +		return IS_ENABLED(CONFIG_PISA);
> +#endif
>
>  	default:
>  		return false;
> @@ -1596,6 +1607,10 @@ static bool process_madvise_remote_valid(int behavior)
>  	case MADV_PAGEOUT:
>  	case MADV_WILLNEED:
>  	case MADV_COLLAPSE:
> +#ifdef MADV_PISA
> +	case MADV_PISA:
> +	case MADV_NOPISA:
> +#endif
>  		return true;
>  	default:
>  		return false;
> @@ -1782,6 +1797,10 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
>  	case MADV_POPULATE_READ:
>  	case MADV_POPULATE_WRITE:
>  	case MADV_COLLAPSE:
> +#ifdef MADV_PISA
> +	case MADV_PISA:
> +	case MADV_NOPISA:
> +#endif
>  		return MADVISE_MMAP_READ_LOCK;
>  	case MADV_GUARD_INSTALL:
>  	case MADV_GUARD_REMOVE:
> diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
> index ccba2bf01bd59..2213a56de1242 100644
> --- a/mm/pisa-alloc.c
> +++ b/mm/pisa-alloc.c
> @@ -1432,6 +1432,8 @@ static int __init pisa_init(void)
>  				  "pisa_ro_o%u_n%d", SKB_FRAG_PAGE_ORDER, nid);
>  	}
>
> +	pisa_user_boot_enable();
> +
>  	/* Dedicated WQ_MEM_RECLAIM workqueue so reclaim never blocks behind system_wq. */
>  	pisa_wq = alloc_workqueue("pisa", WQ_MEM_RECLAIM, 0);
>  	if (!pisa_wq)
> diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
> index 9f01173d30f5f..b18d461198ac5 100644
> --- a/mm/pisa-priv.h
> +++ b/mm/pisa-priv.h
> @@ -133,6 +133,7 @@ static inline long pisa_alloc_held_pages(const struct pisa_alloc *pa)
>  struct pisa_node {
>  	unsigned long		next_alloc;	/* atomic alloc backoff jiffies */
>  	struct pisa_alloc	*pa[2][PISA_MAX_ALLOC_ORDER + 1]; /* [0]=RW, [1]=RO */
> +	struct pisa_alloc	*user_pa;	/* user page migration pa */
>
>  	spinlock_t		lock;		/* protects @pages and @nr_pages */
>  	unsigned int		nr_pages;	/* entries in @pages */
> @@ -245,6 +246,7 @@ void pisa_schedule_scrub_all(void);
>  struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean);
>  unsigned long pisa_reservoir_count(void);
>  unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned long nr_to_scan);
> +void pisa_user_boot_enable(void);
>
>  #endif /* CONFIG_PISA */
>  #endif /* _MM_PISA_PRIV_H */
> diff --git a/mm/pisa-user.c b/mm/pisa-user.c
> new file mode 100644
> index 0000000000000..6c3efaee4ecda
> --- /dev/null
> +++ b/mm/pisa-user.c
> @@ -0,0 +1,394 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/*
> + * PISA user and page-cache folios: allocate or migrate order-0 folios into
> + * per-node PISA allocators so zero-copy TX and block I/O use the PISA IOMMU mappings.
> + */
> +#include <linux/pisa.h>
> +#include <linux/gfp.h>
> +#include <linux/huge_mm.h>
> +#include <linux/migrate.h>
> +#include <linux/mm.h>
> +#include <linux/moduleparam.h>
> +#include <linux/nodemask.h>
> +#include <linux/pagewalk.h>
> +#include <linux/swap.h>
> +#include <linux/uio.h>
> +
> +#include "pisa-priv.h"
> +
> +/* Soft cap on user (PTE) pages held in PISA blocks, in PISA pages (0 = disabled). */
> +static unsigned long pisa_user_max_pages __read_mostly;
> +DEFINE_STATIC_KEY_FALSE(pisa_user_key);
> +
> +/* Create per-node user allocators and enable pisa_user_key (serialized by param_lock/init). */
> +static int pisa_user_init(void)
> +{
> +	int nid;
> +
> +	if (pisa_user_enabled())
> +		return 0;
> +	if (pisa_meta_init())
> +		return -ENOMEM;
> +	for_each_node_state(nid, N_MEMORY) {
> +		if (!pisa_alloc_ensure(&pisa_nodes[nid].user_pa, nid, 0,
> +				       DMA_TO_DEVICE, false, "user_tx_n%d", nid))
> +			return -ENOMEM;
> +	}
> +	static_branch_enable(&pisa_user_key);
> +	return 0;
> +}
> +
> +static int pisa_user_max_set(const char *val, const struct kernel_param *kp)
> +{
> +	unsigned long max_pages;
> +	int ret;
> +
> +	ret = kstrtoul(val, 0, &max_pages);
> +	if (ret)
> +		return ret;
> +	WRITE_ONCE(pisa_user_max_pages, max_pages);
> +	if (!max_pages) {
> +		static_branch_disable(&pisa_user_key);
> +	} else if (pisa_nodes[first_memory_node].pa[0][0] && pisa_user_init()) {
> +		WRITE_ONCE(pisa_user_max_pages, 0);
> +		return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops pisa_user_max_ops = {
> +	.set = pisa_user_max_set,
> +	.get = param_get_ulong,
> +};
> +module_param_cb(user_max_pages, &pisa_user_max_ops, &pisa_user_max_pages, 0644);
> +
> +/*
> + * Initialize per-node user allocators if pisa.user_max_pages was set on
> + * the kernel command line before pisa_init() ran.
> + */
> +void __init pisa_user_boot_enable(void)
> +{
> +	if (READ_ONCE(pisa_user_max_pages))
> +		pisa_user_init();
> +}
> +
> +/* User pages currently held in PISA blocks. */
> +static unsigned long pisa_user_in_use(void)
> +{
> +	unsigned long used = 0;
> +	int nid;
> +
> +	for_each_node_state(nid, N_MEMORY) {
> +		/* Pairs with smp_store_release() in pisa_user_init(). */
> +		const struct pisa_alloc *pa = smp_load_acquire(&pisa_nodes[nid].user_pa);
> +
> +		used += pa ? READ_ONCE(pa->blocks_in_use) : 0;
> +	}
> +	return used;
> +}
> +
> +/* Pages that can still be moved in before reaching pisa.user_max_pages. */
> +static long pisa_user_budget(void)
> +{
> +	return (long)((READ_ONCE(pisa_user_max_pages) << PISA_ORDER) - pisa_user_in_use());
> +}
> +
> +/* Is @folio worth moving into (@to_pisa) or out of PISA memory? */
> +static bool pisa_user_want(struct folio *folio, bool to_pisa)
> +{
> +	if (!folio_test_anon(folio) || folio_is_zone_device(folio) ||
> +	    folio_test_ksm(folio) || is_huge_zero_folio(folio) ||
> +	    (folio_test_large(folio) && !to_pisa) ||
> +	    folio_maybe_mapped_shared(folio))
> +		return false;
> +	return is_pisa_pfn(folio_pfn(folio)) != to_pisa;
> +}
> +
> +/* Return true if @folio has references beyond its mappings, swap cache, and @extra. */
> +static bool pisa_user_busy(struct folio *folio, int extra)
> +{
> +	return folio_ref_count(folio) > folio_expected_ref_count(folio) + extra;
> +}
> +
> +struct pisa_user_mtc {
> +	gfp_t	gfp;
> +	long	budget;
> +};
> +
> +/* new_folio_t for migration into PISA memory. */
> +static struct folio *pisa_user_new_folio(struct folio *src, unsigned long private)
> +{
> +	struct pisa_user_mtc *mtc = (void *)private;
> +	int nid = folio_nid(src);
> +	struct page *page;
> +
> +	/* Callers split large folios first (see pisa_user_split()); none is expected here. */
> +	if (mtc->budget <= 0 || folio_test_large(src))
> +		return NULL;
> +	page = pisa_alloc(pisa_nodes[nid].user_pa, mtc->gfp);
> +	if (!page)
> +		return NULL;
> +	mtc->budget--;
> +	return page_folio(page);
> +}
> +
> +/* free_folio_t: give back an unused destination block and the budget it was charged. */
> +static void pisa_user_put_folio(struct folio *dst, unsigned long private)
> +{
> +	struct pisa_user_mtc *mtc = (void *)private;
> +
> +	mtc->budget++;
> +	folio_put(dst);
> +}
> +
> +/* new_folio_t for migration out of PISA memory: allocators never serve these. */
> +static struct folio *pisa_user_old_folio(struct folio *src, unsigned long private)
> +{
> +	return __folio_alloc_node(GFP_HIGHUSER_MOVABLE | __GFP_NOWARN, 0, folio_nid(src));
> +}
> +
> +/* Migrate the isolated folios on @list; failures are put back. */
> +static void pisa_user_migrate(struct list_head *list, bool to_pisa, gfp_t gfp)
> +{
> +	struct pisa_user_mtc mtc = { .gfp = gfp, .budget = LONG_MAX };
> +	enum migrate_mode mode = MIGRATE_SYNC;
> +
> +	if (list_empty(list))
> +		return;
> +	if (to_pisa) {
> +		mtc.budget = pisa_user_budget();
> +		if (!gfpflags_allow_blocking(gfp))
> +			mode = MIGRATE_ASYNC;
> +	}
> +	if (migrate_pages(list, to_pisa ? pisa_user_new_folio : pisa_user_old_folio,
> +			  to_pisa ? pisa_user_put_folio : NULL, (unsigned long)&mtc,
> +			  mode, MR_SYSCALL, NULL))
> +		putback_movable_pages(list);
> +}
> +
> +/*
> + * Split large anon @folio to order 0, with the caller holding the only extra
> + * reference. Zero-filled subpages stay mapped instead of being replaced by the
> + * shared zeropage, so that a GUP for write that follows (e.g. an O_DIRECT
> + * read) finds them. After-split folios go to @list, or to the LRU if NULL.
> + */
> +static bool pisa_user_split(struct folio *folio, struct list_head *list, bool can_wait)
> +{
> +	int ret;
> +
> +	if (can_wait)
> +		folio_lock(folio);
> +	else if (!folio_trylock(folio))
> +		return false;
> +	ret = split_folio_to_list_keep_zero(folio, list);
> +	folio_unlock(folio);
> +	return !ret;
> +}
> +
> +/*
> + * Split isolated large @folio and move to @out the subpages found in @pages.
> + * The others, or all of @folio if @split is false or the split fails, go back
> + * to the LRU. Returns the number of subpages moved to @out.
> + */
> +static unsigned int pisa_user_split_isolated(struct folio *folio, struct list_head *out,
> +					     struct page **pages, unsigned int nr, bool split)
> +{
> +	const struct page *lo = NULL, *hi = NULL;
> +	unsigned int kept = 0;
> +	struct folio *f, *next;
> +	LIST_HEAD(pieces);
> +
> +	/* @folio is held isolated, so page_folio() of its subpages is stable. */
> +	for (unsigned int i = 0; i < nr; i++) {
> +		if (page_folio(pages[i]) != folio)
> +			continue;
> +		if (!lo || pages[i] < lo)
> +			lo = pages[i];
> +		if (!hi || pages[i] > hi)
> +			hi = pages[i];
> +	}
> +	list_move(&folio->lru, &pieces);
> +	if (split && pisa_user_split(folio, &pieces, false)) {
> +		list_for_each_entry_safe(f, next, &pieces, lru) {
> +			if (!folio_test_large(f) && &f->page >= lo && &f->page <= hi) {
> +				list_move_tail(&f->lru, out);
> +				kept++;
> +			}
> +		}
> +	}
> +	putback_movable_pages(&pieces);
> +	return kept;
> +}
> +
> +/**
> + * pisa_upgrade_user_pages - Migrate extracted user @pages into PISA
> + * @iter: Iterator from which @pages were just extracted
> + * @pages: Extracted page array, one reference each
> + * @size: Number of bytes extracted from @iter
> + * @offset: Byte offset within @pages[0]
> + *
> + * Return: false if no pages were isolated (@pages and @iter are untouched);
> + * true otherwise, so the caller must re-extract @pages from the reverted @iter.
> + */
> +bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
> +			     size_t size, size_t offset)
> +{
> +	unsigned int nr = DIV_ROUND_UP(offset + size, PAGE_SIZE);
> +	unsigned int want = 0;
> +	struct folio *f, *next;
> +	bool drained = false;
> +	LIST_HEAD(small);
> +	LIST_HEAD(list);
> +	long budget;
> +
> +	if (!pisa_user_enabled())
> +		return false;
> +	/*
> +	 * First pass: check if any page needs migration and whether budget is
> +	 * available before draining per-CPU LRU caches or isolating folios.
> +	 */
> +	for (unsigned int i = 0; i < nr; i++)
> +		want += pisa_user_want(page_folio(pages[i]), true);
> +	if (!want || pisa_user_budget() <= 0)
> +		return false;
> +	for (unsigned int i = 0; i < nr; i++) {
> +		struct folio *folio = page_folio(pages[i]);
> +		unsigned int refs = 0;
> +
> +		if (!pisa_user_want(folio, true))
> +			continue;
> +		/* Drain per-CPU LRU batches once so freshly faulted folios can be isolated. */
> +		if (!drained && !folio_test_lru(folio)) {
> +			lru_add_drain();
> +			drained = true;
> +		}
> +		if (!folio_test_lru(folio))
> +			continue;
> +		for (unsigned int j = 0; j < nr; j++)
> +			refs += page_folio(pages[j]) == folio;
> +		/* The references from iov_iter_get_pages2() are expected. */
> +		if (folio_maybe_dma_pinned(folio) || pisa_user_busy(folio, refs))
> +			continue;
> +		if (isolate_folio_to_list(folio, &list))
> +			list_move_tail(&folio->lru, &list);
> +	}
> +	if (list_empty(&list))
> +		return false;
> +	/*
> +	 * Release the caller's references on @pages before migrating
> +	 * (migrate_pages() rejects folios with extra references).
> +	 */
> +	for (unsigned int i = 0; i < nr; i++)
> +		put_page(pages[i]);
> +	/*
> +	 * Split large folios while budget remains and keep only their subpages
> +	 * that are in @pages: migrate_pages() would split them regardless of
> +	 * the budget, migrate every subpage and drop the zero-filled ones.
> +	 */
> +	budget = pisa_user_budget();
> +	list_for_each_entry_safe(f, next, &list, lru) {
> +		if (folio_test_large(f))
> +			budget -= pisa_user_split_isolated(f, &small, pages, nr, budget > 0);
> +		else
> +			budget -= !is_pisa_pfn(folio_pfn(f));
> +	}
> +	list_splice_tail(&small, &list);
> +	pisa_user_migrate(&list, true,
> +			  GFP_NOWAIT | __GFP_HARDWALL | __GFP_NOWARN);
> +	/* Rewind @iter so the caller re-extracts the updated page pointers. */
> +	iov_iter_revert(iter, size);
> +	return true;
> +}
> +
> +#define PISA_USER_BATCH	512
> +
> +struct pisa_madvise_walk {
> +	struct list_head	list;	/* isolated folios waiting to be migrated */
> +	unsigned int		n;	/* pages on @list */
> +	bool			to_pisa;
> +};
> +
> +#define PISA_MADVISE_GFP	(GFP_USER | __GFP_NOWARN)
> +
> +/* Isolate the wanted folios mapped in one PMD's range, splitting the large ones first. */
> +static int pisa_madvise_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long end,
> +				  struct mm_walk *walk)
> +{
> +	struct pisa_madvise_walk *w = walk->private;
> +	bool to_pisa = w->to_pisa;
> +	struct folio_walk fw;
> +	struct folio *folio;
> +
> +	while (addr < end) {
> +		unsigned long nr = 1;
> +
> +		if (fatal_signal_pending(current))
> +			return -EINTR;
> +		/* Stop the walk, without an error, once the cap is reached. */
> +		if (to_pisa && pisa_user_budget() <= (long)w->n)
> +			return 1;
> +		folio = folio_walk_start(&fw, walk->vma, addr, 0);
> +		if (folio) {
> +			bool want = pisa_user_want(folio, to_pisa) && folio_test_lru(folio);
> +			bool busy = want && pisa_user_busy(folio, 0);
> +			bool split = want && !busy && folio_test_large(folio);
> +
> +			/* A PMD mapping covers the rest of the range, a PTE maps one page. */
> +			if (fw.level != FW_LEVEL_PTE)
> +				nr = (end - addr) >> PAGE_SHIFT;
> +			if (split) {
> +				folio_get(folio);
> +			} else if (want && !busy && isolate_folio_to_list(folio, &w->list)) {
> +				list_move_tail(&folio->lru, &w->list);
> +				w->n++;
> +			}
> +			folio_walk_end(&fw, walk->vma);
> +			if (split) {
> +				split = pisa_user_split(folio, NULL, true);
> +				folio_put(folio);
> +				/* Look at @addr again: it now maps an order-0 folio. */
> +				if (split)
> +					continue;
> +			}
> +		}
> +		if (w->n >= PISA_USER_BATCH) {
> +			pisa_user_migrate(&w->list, to_pisa, PISA_MADVISE_GFP);
> +			w->n = 0;
> +		}
> +		addr += nr << PAGE_SHIFT;
> +		cond_resched();
> +	}
> +	return 0;
> +}
> +
> +static const struct mm_walk_ops pisa_madvise_walk_ops = {
> +	.pmd_entry	= pisa_madvise_pmd_entry,
> +	.walk_lock	= PGWALK_RDLOCK,
> +};
> +
> +/**
> + * pisa_madvise - MADV_PISA / MADV_NOPISA on [@start, @end) of @vma
> + * @vma: VMA, with the mmap lock held for reading
> + * @start: Start address
> + * @end: End address
> + * @to_pisa: true to move present pages into PISA, false to move them out
> + *
> + * Return: 0, -EINVAL for unsupported mappings, or -EOPNOTSUPP if disabled.
> + */
> +int pisa_madvise(struct vm_area_struct *vma, unsigned long start, unsigned long end, bool to_pisa)
> +{
> +	struct pisa_madvise_walk w = { .list = LIST_HEAD_INIT(w.list), .to_pisa = to_pisa };
> +	int ret;
> +
> +	if (vma->vm_flags & (VM_SHARED | VM_IO | VM_PFNMAP | VM_HUGETLB))
> +		return -EINVAL;
> +	if (to_pisa && !pisa_user_enabled())
> +		return -EOPNOTSUPP;
> +	if (!pisa_enabled() && !to_pisa)
> +		return 0;
> +	lru_add_drain();
> +	/* The page walker skips the unpopulated page-table levels of sparse mappings. */
> +	ret = walk_page_range_vma(vma, start, end, &pisa_madvise_walk_ops, &w);
> +	pisa_user_migrate(&w.list, to_pisa, PISA_MADVISE_GFP);
> +	return ret < 0 ? ret : 0;
> +}
> --
> 2.56.1.809.ga0b61035b5-goog
>

--
Cheers, Lorenzo
