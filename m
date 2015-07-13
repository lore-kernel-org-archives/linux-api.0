From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [RFCv3 2/5] mm/compaction: enable mobile-page migration
Date: Mon, 13 Jul 2015 17:45:46 +0900
Message-ID: <55A37ABA.3000001@lge.com>
References: <1436243785-24105-1-git-send-email-gioh.kim@lge.com>	<1436243785-24105-3-git-send-email-gioh.kim@lge.com> <CALYGNiPBPzA0QCXZKXKye++xVSeO_nBW4gV+ukk2jPiBOM+n=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALYGNiPBPzA0QCXZKXKye++xVSeO_nBW4gV+ukk2jPiBOM+n=A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, Bruce Fields <bfields@fieldses.org>, Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Al Viro <viro@zeniv.linux.org.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Minchan Kim <minchan@kernel.org>, Rafael Aquini <aquini@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, gunho.lee@lge.com, Andrew Morton <akpm@linux-foundation.org>, Gioh Kim <gurugio@hanmail.net>
List-Id: linux-api@vger.kernel.org


>> @@ -51,6 +54,66 @@ extern void compaction_defer_reset(struct zone *zone, int order,
>>                                  bool alloc_success);
>>   extern bool compaction_restarting(struct zone *zone, int order);
>>
>> +static inline bool mobile_page(struct page *page)
>> +{
>> +       return page->mapping && page->mapping->a_ops &&
>
> Dereferncing mapping->a_ops isn't safe without page-lock and isn't required:
> all mappings always have ->a_ops.
>

I got it.

>> +static inline void putback_mobilepage(struct page *page)
>> +{
>> +       /*
>> +        * 'lock_page()' stabilizes the page and prevents races against
>> +        * concurrent isolation threads attempting to re-isolate it.
>> +        */
>> +       lock_page(page);
>> +       if (mobile_page(page) && page->mapping->a_ops->putbackpage) {
>
> It seems "if (page->mapping && page->mapping->a_ops->putbackpage)"
> should be enough: we already seen that page as mobile.

Ditto.

>
>> +               page->mapping->a_ops->putbackpage(page);
>> +               /* drop the extra ref count taken for mobile page isolation */
>> +               put_page(page);
>> +       }
>> +       unlock_page(page);
>
> call put_page() after unlock and do that always -- putback must drop
> page reference from caller.
>
> lock_page(page);
> if (page->mapping && page->mapping->a_ops->putbackpage)
>       page->mapping->a_ops->putbackpage(page);
> unlock_page();
> put_page(page);
>

Ditto.

>> +}
>>   #else
>>   static inline unsigned long try_to_compact_pages(gfp_t gfp_mask,
>>                          unsigned int order, int alloc_flags,
>> @@ -83,6 +146,19 @@ static inline bool compaction_deferred(struct zone *zone, int order)
>>          return true;
>>   }
>>
>> +static inline bool mobile_page(struct page *page)
>> +{
>> +       return false;
>> +}
>> +
>> +static inline bool isolate_mobilepage(struct page *page, isolate_mode_t mode)
>> +{
>> +       return false;
>> +}
>> +
>> +static inline void putback_mobilepage(struct page *page)
>> +{
>> +}
>>   #endif /* CONFIG_COMPACTION */
>>
>>   #if defined(CONFIG_COMPACTION) && defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 35ec87e..33c9aa5 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -395,6 +395,8 @@ struct address_space_operations {
>>           */
>>          int (*migratepage) (struct address_space *,
>>                          struct page *, struct page *, enum migrate_mode);
>> +       bool (*isolatepage) (struct page *, isolate_mode_t);
>> +       void (*putbackpage) (struct page *);
>>          int (*launder_page) (struct page *);
>>          int (*is_partially_uptodate) (struct page *, unsigned long,
>>                                          unsigned long);
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index f34e040..abef145 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -582,6 +582,25 @@ static inline void __ClearPageBalloon(struct page *page)
>>          atomic_set(&page->_mapcount, -1);
>>   }
>>
>> +#define PAGE_MOBILE_MAPCOUNT_VALUE (-255)
>> +
>> +static inline int PageMobile(struct page *page)
>> +{
>> +       return atomic_read(&page->_mapcount) == PAGE_MOBILE_MAPCOUNT_VALUE;
>> +}
>> +
>> +static inline void __SetPageMobile(struct page *page)
>> +{
>> +       VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);
>> +       atomic_set(&page->_mapcount, PAGE_MOBILE_MAPCOUNT_VALUE);
>> +}
>> +
>> +static inline void __ClearPageMobile(struct page *page)
>> +{
>> +       VM_BUG_ON_PAGE(!PageMobile(page), page);
>> +       atomic_set(&page->_mapcount, -1);
>> +}
>> +
>>   /*
>>    * If network-based swap is enabled, sl*b must keep track of whether pages
>>    * were allocated from pfmemalloc reserves.
>> diff --git a/include/uapi/linux/kernel-page-flags.h b/include/uapi/linux/kernel-page-flags.h
>> index a6c4962..d50d9e8 100644
>> --- a/include/uapi/linux/kernel-page-flags.h
>> +++ b/include/uapi/linux/kernel-page-flags.h
>> @@ -33,6 +33,7 @@
>>   #define KPF_THP                        22
>>   #define KPF_BALLOON            23
>>   #define KPF_ZERO_PAGE          24
>> +#define KPF_MOBILE             25
>>
>>
>>   #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
>> --
>> 2.1.4
>>
>

I fixed the code as your comments and I found patch 3/5 and 4/5 could not be applied separately.
So I merge them and report new [PATCH].
I appreciate your reviews.

