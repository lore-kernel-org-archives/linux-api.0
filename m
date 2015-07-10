From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFCv3 3/5] mm/balloon: apply mobile page migratable into balloon
Date: Fri, 10 Jul 2015 16:29:48 +0300
Message-ID: <CALYGNiPbj6GQPesD3uWU+9-0y-jwouBA3-dXNFxRTRRgcOOzSA@mail.gmail.com>
References: <1436243785-24105-1-git-send-email-gioh.kim@lge.com>
	<1436243785-24105-4-git-send-email-gioh.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436243785-24105-4-git-send-email-gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, gunho.lee-Hm3cg6mZ9cc@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Gioh Kim <gurugio-A7HHaXTFBl7R7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 7, 2015 at 7:36 AM, Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org> wrote:
> From: Gioh Kim <gurugio-A7HHaXTFBl7R7s880joybQ@public.gmane.org>
>
> Apply mobile page migration into balloon driver.
> The balloong driver has an anonymous inode that manages
> address_space_operation for page migration.
>
> Signed-off-by: Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
> ---
>  drivers/virtio/virtio_balloon.c    |  3 ++
>  include/linux/balloon_compaction.h | 15 +++++++--
>  mm/balloon_compaction.c            | 65 +++++++++++++-------------------------
>  mm/compaction.c                    |  2 +-
>  mm/migrate.c                       |  2 +-
>  5 files changed, 39 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 82e80e0..ef5b9b5 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -30,6 +30,7 @@
>  #include <linux/balloon_compaction.h>
>  #include <linux/oom.h>
>  #include <linux/wait.h>
> +#include <linux/anon_inodes.h>
>
>  /*
>   * Balloon device works in 4K page units.  So each page is pointed to by
> @@ -505,6 +506,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
>         balloon_devinfo_init(&vb->vb_dev_info);
>  #ifdef CONFIG_BALLOON_COMPACTION
>         vb->vb_dev_info.migratepage = virtballoon_migratepage;
> +       vb->vb_dev_info.inode = anon_inode_new();
> +       vb->vb_dev_info.inode->i_mapping->a_ops = &balloon_aops;
>  #endif
>
>         err = init_vqs(vb);
> diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
> index 9b0a15d..a9e0bde 100644
> --- a/include/linux/balloon_compaction.h
> +++ b/include/linux/balloon_compaction.h
> @@ -48,6 +48,7 @@
>  #include <linux/migrate.h>
>  #include <linux/gfp.h>
>  #include <linux/err.h>
> +#include <linux/fs.h>
>
>  /*
>   * Balloon device information descriptor.
> @@ -62,6 +63,7 @@ struct balloon_dev_info {
>         struct list_head pages;         /* Pages enqueued & handled to Host */
>         int (*migratepage)(struct balloon_dev_info *, struct page *newpage,
>                         struct page *page, enum migrate_mode mode);
> +       struct inode *inode;
>  };
>
>  extern struct page *balloon_page_enqueue(struct balloon_dev_info *b_dev_info);
> @@ -73,12 +75,16 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
>         spin_lock_init(&balloon->pages_lock);
>         INIT_LIST_HEAD(&balloon->pages);
>         balloon->migratepage = NULL;
> +       balloon->inode = NULL;
>  }
>
>  #ifdef CONFIG_BALLOON_COMPACTION
> -extern bool balloon_page_isolate(struct page *page);
> +extern const struct address_space_operations balloon_aops;
> +extern bool balloon_page_isolate(struct page *page,
> +                                isolate_mode_t mode);
>  extern void balloon_page_putback(struct page *page);
> -extern int balloon_page_migrate(struct page *newpage,
> +extern int balloon_page_migrate(struct address_space *mapping,
> +                               struct page *newpage,
>                                 struct page *page, enum migrate_mode mode);
>
>  /*
> @@ -124,6 +130,7 @@ static inline void balloon_page_insert(struct balloon_dev_info *balloon,
>                                        struct page *page)
>  {
>         __SetPageBalloon(page);
> +       page->mapping = balloon->inode->i_mapping;
>         SetPagePrivate(page);
>         set_page_private(page, (unsigned long)balloon);
>         list_add(&page->lru, &balloon->pages);
> @@ -140,6 +147,7 @@ static inline void balloon_page_insert(struct balloon_dev_info *balloon,
>  static inline void balloon_page_delete(struct page *page)
>  {
>         __ClearPageBalloon(page);
> +       page->mapping = NULL;
>         set_page_private(page, 0);
>         if (PagePrivate(page)) {
>                 ClearPagePrivate(page);
> @@ -191,7 +199,8 @@ static inline bool isolated_balloon_page(struct page *page)
>         return false;
>  }
>
> -static inline bool balloon_page_isolate(struct page *page)
> +static inline bool balloon_page_isolate(struct page *page,
> +                                       isolate_mode_t mode)
>  {
>         return false;
>  }
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index fcad832..0dd0b0d 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -131,43 +131,16 @@ static inline void __putback_balloon_page(struct page *page)
>  }
>
>  /* __isolate_lru_page() counterpart for a ballooned page */
> -bool balloon_page_isolate(struct page *page)
> +bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
>  {
>         /*
> -        * Avoid burning cycles with pages that are yet under __free_pages(),
> -        * or just got freed under us.
> -        *
> -        * In case we 'win' a race for a balloon page being freed under us and
> -        * raise its refcount preventing __free_pages() from doing its job
> -        * the put_page() at the end of this block will take care of
> -        * release this page, thus avoiding a nasty leakage.
> +        * A ballooned page, by default, has PagePrivate set.
> +        * Prevent concurrent compaction threads from isolating
> +        * an already isolated balloon page by clearing it.
>          */
> -       if (likely(get_page_unless_zero(page))) {
> -               /*
> -                * As balloon pages are not isolated from LRU lists, concurrent
> -                * compaction threads can race against page migration functions
> -                * as well as race against the balloon driver releasing a page.
> -                *
> -                * In order to avoid having an already isolated balloon page
> -                * being (wrongly) re-isolated while it is under migration,
> -                * or to avoid attempting to isolate pages being released by
> -                * the balloon driver, lets be sure we have the page lock
> -                * before proceeding with the balloon page isolation steps.
> -                */
> -               if (likely(trylock_page(page))) {
> -                       /*
> -                        * A ballooned page, by default, has PagePrivate set.
> -                        * Prevent concurrent compaction threads from isolating
> -                        * an already isolated balloon page by clearing it.
> -                        */
> -                       if (balloon_page_movable(page)) {
> -                               __isolate_balloon_page(page);
> -                               unlock_page(page);
> -                               return true;
> -                       }
> -                       unlock_page(page);
> -               }
> -               put_page(page);
> +       if (balloon_page_movable(page)) {
> +               __isolate_balloon_page(page);
> +               return true;
>         }
>         return false;
>  }
> @@ -175,30 +148,28 @@ bool balloon_page_isolate(struct page *page)
>  /* putback_lru_page() counterpart for a ballooned page */
>  void balloon_page_putback(struct page *page)
>  {
> -       /*
> -        * 'lock_page()' stabilizes the page and prevents races against
> -        * concurrent isolation threads attempting to re-isolate it.
> -        */
> -       lock_page(page);
> +       if (!isolated_balloon_page(page))
> +               return;
>
>         if (__is_movable_balloon_page(page)) {
>                 __putback_balloon_page(page);
> -               /* drop the extra ref count taken for page isolation */
> -               put_page(page);
>         } else {
>                 WARN_ON(1);
>                 dump_page(page, "not movable balloon page");
>         }
> -       unlock_page(page);
>  }
>
>  /* move_to_new_page() counterpart for a ballooned page */
> -int balloon_page_migrate(struct page *newpage,
> +int balloon_page_migrate(struct address_space *mapping,
> +                        struct page *newpage,
>                          struct page *page, enum migrate_mode mode)
>  {
>         struct balloon_dev_info *balloon = balloon_page_device(page);
>         int rc = -EAGAIN;
>
> +       if (!isolated_balloon_page(page))
> +               return rc;
> +
>         /*
>          * Block others from accessing the 'newpage' when we get around to
>          * establishing additional references. We should be the only one
> @@ -218,4 +189,12 @@ int balloon_page_migrate(struct page *newpage,
>         unlock_page(newpage);

Both pages passed as arguments of ->migratepage() are locked.
So, please remove lock/unlock from this function here and add lock/unlock
newpage in __unmap_and_move() below. Right in this patch.

>         return rc;
>  }
> +
> +/* define the balloon_mapping->a_ops callback to allow balloon page migration */
> +const struct address_space_operations balloon_aops = {
> +       .migratepage = balloon_page_migrate,
> +       .isolatepage = balloon_page_isolate,
> +       .putbackpage = balloon_page_putback,
> +};
> +EXPORT_SYMBOL_GPL(balloon_aops);
>  #endif /* CONFIG_BALLOON_COMPACTION */
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 018f08d..81bafaf 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -719,7 +719,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>                  */
>                 if (!PageLRU(page)) {
>                         if (unlikely(balloon_page_movable(page))) {
> -                               if (balloon_page_isolate(page)) {
> +                               if (balloon_page_isolate(page, isolate_mode)) {
>                                         /* Successfully isolated */
>                                         goto isolate_success;
>                                 }
> diff --git a/mm/migrate.c b/mm/migrate.c
> index f53838f..c94038e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -852,7 +852,7 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
>                  * in order to avoid burning cycles at rmap level, and perform
>                  * the page migration right away (proteced by page lock).
>                  */
> -               rc = balloon_page_migrate(newpage, page, mode);

Here:

lock_page(newpage);

> +               rc = balloon_page_migrate(page->mapping, newpage, page, mode);

unlock_page(newpage);

>                 goto out_unlock;
>         }
>
> --
> 2.1.4
>
