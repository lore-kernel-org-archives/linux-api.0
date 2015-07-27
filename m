From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] mm/compaction: enable mobile-page migration
Date: Mon, 27 Jul 2015 21:56:53 +0300
Message-ID: <CALYGNiMJ79HmLkoV_c2BR+ENig0h5aNzeY5YdS7kEYpFbLe=xA@mail.gmail.com>
References: <1436776519-17337-1-git-send-email-gioh.kim@lge.com>
	<1436776519-17337-3-git-send-email-gioh.kim@lge.com>
	<55B63851.1080100@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B63851.1080100-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Gioh Kim <gurugio-A7HHaXTFBl7R7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 27, 2015 at 4:55 PM, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrote:
> On 07/13/2015 10:35 AM, Gioh Kim wrote:
>>
>> From: Gioh Kim <gurugio-A7HHaXTFBl7R7s880joybQ@public.gmane.org>
>>
>> Add framework to register callback functions and check page mobility.
>> There are some modes for page isolation so that isolate interface
>> has arguments of page address and isolation mode while putback
>> interface has only page address as argument.
>
>
> Note that unlike what subject suggest, this doesn't really enable
> mobile-page migration inside compaction, since that only happens with patch
> 3. This might theoretically affect some cherry-pick backports that don't
> care about balloon pages. I can imagine that can easily happen in the world
> of mobile devices?
> It would thus be somewhat cleaner if this patch was complete in that sense.
>
>> Signed-off-by: Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
>> Acked-by: Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>   fs/proc/page.c                         |  3 ++
>>   include/linux/compaction.h             | 80
>> ++++++++++++++++++++++++++++++++++
>>   include/linux/fs.h                     |  2 +
>>   include/linux/page-flags.h             | 19 ++++++++
>>   include/uapi/linux/kernel-page-flags.h |  1 +
>>   5 files changed, 105 insertions(+)
>>
>> diff --git a/fs/proc/page.c b/fs/proc/page.c
>> index 7eee2d8..a4f5a00 100644
>> --- a/fs/proc/page.c
>> +++ b/fs/proc/page.c
>> @@ -146,6 +146,9 @@ u64 stable_page_flags(struct page *page)
>>         if (PageBalloon(page))
>>                 u |= 1 << KPF_BALLOON;
>>
>> +       if (PageMobile(page))
>> +               u |= 1 << KPF_MOBILE;
>
>
> PageMovable() would probably be as good a name and correspond to
> MIGRATE_MOVABLE somewhat, unlike a completely new term. Whatever driver
> starts to using this should probably change allocation flags to allocate
> MIGRATE_MOVABLE, so that it works fine with what fragmentation avoidance
> expects. Guess I should have said that earlier, but can you still
> reconsider?

Well, I've suggested to name it "mobile" because there's already a lot of things
called "movable". Mobile pages are special subset of movable pages: they
are non-lru pages and define their own rules of moving in address
space operations.

Also there's a little pun: I guess main user will zram which is used
mostly in embedded/mobile devices.

>
>> +
>>         u |= kpf_copy_bit(k, KPF_LOCKED,        PG_locked);
>>
>>         u |= kpf_copy_bit(k, KPF_SLAB,          PG_slab);
>> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
>> index aa8f61c..f693072 100644
>> --- a/include/linux/compaction.h
>> +++ b/include/linux/compaction.h
>> @@ -1,6 +1,9 @@
>>   #ifndef _LINUX_COMPACTION_H
>>   #define _LINUX_COMPACTION_H
>>
>> +#include <linux/page-flags.h>
>> +#include <linux/pagemap.h>
>> +
>>   /* Return values for compact_zone() and try_to_compact_pages() */
>>   /* compaction didn't start as it was deferred due to past failures */
>>   #define COMPACT_DEFERRED      0
>> @@ -51,6 +54,70 @@ extern void compaction_defer_reset(struct zone *zone,
>> int order,
>>                                 bool alloc_success);
>>   extern bool compaction_restarting(struct zone *zone, int order);
>>
>> +static inline bool mobile_page(struct page *page)
>> +{
>> +       return page->mapping && (PageMobile(page) || PageBalloon(page));
>> +}
>
>
> I would put this definition to linux/page-flags.h and rename it to
> page_mobile (or better page_movable()), which is more common ordering.
>
>> +
>> +static inline bool isolate_mobilepage(struct page *page, isolate_mode_t
>> mode)
>
>
> Does this have to be in compaction.h? The only user is compaction.c so
> probably move it there, and if there ever is another module using this in
> the future, we can move it to a more appropriate place and declare it in
> e.g. mm/internal.h.
>
>
>> +{
>> +       bool ret = false;
>> +
>> +       /*
>> +        * Avoid burning cycles with pages that are yet under
>> __free_pages(),
>> +        * or just got freed under us.
>> +        *
>> +        * In case we 'win' a race for a mobile page being freed under us
>> and
>> +        * raise its refcount preventing __free_pages() from doing its job
>> +        * the put_page() at the end of this block will take care of
>> +        * release this page, thus avoiding a nasty leakage.
>> +        */
>> +       if (unlikely(!get_page_unless_zero(page)))
>> +               goto out;
>> +
>> +       /*
>> +        * As mobile pages are not isolated from LRU lists, concurrent
>> +        * compaction threads can race against page migration functions
>> +        * as well as race against the releasing a page.
>> +        *
>> +        * In order to avoid having an already isolated mobile page
>> +        * being (wrongly) re-isolated while it is under migration,
>> +        * or to avoid attempting to isolate pages being released,
>> +        * lets be sure we have the page lock
>> +        * before proceeding with the mobile page isolation steps.
>> +        */
>> +       if (unlikely(!trylock_page(page)))
>> +               goto out_putpage;
>> +
>> +       if (!(mobile_page(page) && page->mapping->a_ops->isolatepage))
>> +               goto out_not_isolated;
>> +       ret = page->mapping->a_ops->isolatepage(page, mode);
>> +       if (!ret)
>> +               goto out_not_isolated;
>> +       unlock_page(page);
>> +       return ret;
>> +
>> +out_not_isolated:
>> +       unlock_page(page);
>> +out_putpage:
>> +       put_page(page);
>> +out:
>> +       return ret;
>> +}
>> +
>> +static inline void putback_mobilepage(struct page *page)
>
>
> Likewise, this could go to migrate.c. Or maybe together with
> isolate_mobilepage() if you don't want to split them.
>
>
>> +{
>> +       /*
>> +        * 'lock_page()' stabilizes the page and prevents races against
>> +        * concurrent isolation threads attempting to re-isolate it.
>> +        */
>> +       lock_page(page);
>> +       if (page->mapping && page->mapping->a_ops->putbackpage)
>> +               page->mapping->a_ops->putbackpage(page);
>> +       unlock_page(page);
>> +       /* drop the extra ref count taken for mobile page isolation */
>> +       put_page(page);
>> +}
>>   #else
>>   static inline unsigned long try_to_compact_pages(gfp_t gfp_mask,
>>                         unsigned int order, int alloc_flags,
>> @@ -83,6 +150,19 @@ static inline bool compaction_deferred(struct zone
>> *zone, int order)
>>         return true;
>>   }
>>
>> +static inline bool mobile_page(struct page *page)
>> +{
>> +       return false;
>> +}
>> +
>> +static inline bool isolate_mobilepage(struct page *page, isolate_mode_t
>> mode)
>> +{
>> +       return false;
>> +}
>> +
>> +static inline void putback_mobilepage(struct page *page)
>> +{
>> +}
>>   #endif /* CONFIG_COMPACTION */
>>
>>   #if defined(CONFIG_COMPACTION) && defined(CONFIG_SYSFS) &&
>> defined(CONFIG_NUMA)
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index a0653e5..2cc4b24 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -396,6 +396,8 @@ struct address_space_operations {
>>          */
>>         int (*migratepage) (struct address_space *,
>>                         struct page *, struct page *, enum migrate_mode);
>> +       bool (*isolatepage) (struct page *, isolate_mode_t);
>> +       void (*putbackpage) (struct page *);
>>         int (*launder_page) (struct page *);
>>         int (*is_partially_uptodate) (struct page *, unsigned long,
>>                                         unsigned long);
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index f34e040..abef145 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -582,6 +582,25 @@ static inline void __ClearPageBalloon(struct page
>> *page)
>>         atomic_set(&page->_mapcount, -1);
>>   }
>>
>> +#define PAGE_MOBILE_MAPCOUNT_VALUE (-255)
>> +
>> +static inline int PageMobile(struct page *page)
>> +{
>> +       return atomic_read(&page->_mapcount) ==
>> PAGE_MOBILE_MAPCOUNT_VALUE;
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
>>    * If network-based swap is enabled, sl*b must keep track of whether
>> pages
>>    * were allocated from pfmemalloc reserves.
>> diff --git a/include/uapi/linux/kernel-page-flags.h
>> b/include/uapi/linux/kernel-page-flags.h
>> index a6c4962..d50d9e8 100644
>> --- a/include/uapi/linux/kernel-page-flags.h
>> +++ b/include/uapi/linux/kernel-page-flags.h
>> @@ -33,6 +33,7 @@
>>   #define KPF_THP                       22
>>   #define KPF_BALLOON           23
>>   #define KPF_ZERO_PAGE         24
>> +#define KPF_MOBILE             25
>>
>>
>>   #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
>>
>
