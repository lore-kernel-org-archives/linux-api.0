From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 1/2] mm: introduce page reference manipulation functions
Date: Mon, 9 Nov 2015 16:53:37 +0900
Message-ID: <20151109075337.GC472@swordfish>
References: <1447053784-27811-1-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1447053784-27811-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: owner-linux-mm@kvack.org
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Nazarewicz <mina86@mina86.com>, Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
List-Id: linux-api@vger.kernel.org

Hi,

On (11/09/15 16:23), Joonsoo Kim wrote:
[..]
> +static inline int page_count(struct page *page)
> +{
> +	return atomic_read(&compound_head(page)->_count);
> +}
> +
> +static inline void set_page_count(struct page *page, int v)
> +{
> +	atomic_set(&page->_count, v);
> +}
> +
> +/*
> + * Setup the page count before being freed into the page allocator for
> + * the first time (boot or memory hotplug)
> + */
> +static inline void init_page_count(struct page *page)
> +{
> +	set_page_count(page, 1);
> +}
> +
> +static inline void page_ref_add(struct page *page, int nr)
> +{
> +	atomic_add(nr, &page->_count);
> +}

Since page_ref_FOO wrappers operate with page->_count and there
are already page_count()/set_page_count()/etc. may be name new
wrappers in page_count_FOO() manner?


> +static inline void page_ref_sub(struct page *page, int nr)

for example, page_count_sub(), etc.

	-ss

> +{
> +	atomic_sub(nr, &page->_count);
> +}
> +
> +static inline void page_ref_inc(struct page *page)
> +{
> +	atomic_inc(&page->_count);
> +}
> +
> +static inline void page_ref_dec(struct page *page)
> +{
> +	atomic_dec(&page->_count);
> +}
> +
> +static inline int page_ref_sub_and_test(struct page *page, int nr)
> +{
> +	return atomic_sub_and_test(nr, &page->_count);
> +}
> +
> +static inline int page_ref_dec_and_test(struct page *page)
> +{
> +	return atomic_dec_and_test(&page->_count);
> +}
> +
> +static inline int page_ref_dec_return(struct page *page)
> +{
> +	return atomic_dec_return(&page->_count);
> +}
> +
> +static inline int page_ref_add_unless(struct page *page, int nr, int u)
> +{
> +	return atomic_add_unless(&page->_count, nr, u);
> +}
> +
> +static inline int page_ref_freeze(struct page *page, int count)
> +{
> +	return likely(atomic_cmpxchg(&page->_count, count, 0) == count);
> +}
> +
> +static inline void page_ref_unfreeze(struct page *page, int count)
> +{
> +	VM_BUG_ON_PAGE(page_count(page) != 0, page);
> +	VM_BUG_ON(count == 0);
> +
> +	atomic_set(&page->_count, count);
> +}

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
