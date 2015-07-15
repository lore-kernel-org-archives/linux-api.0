From: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -mm v8 2/7] hwpoison: use page_cgroup_ino for filtering by memcg
Date: Wed, 15 Jul 2015 12:00:13 -0700
Message-ID: <CAJu=L59BaBswPw1XpWQBbPDNegUM56YQ_95Vv_Bf73AmfD4-UQ@mail.gmail.com>
References: <cover.1436967694.git.vdavydov@parallels.com>
	<5c4d3594a5b0a79248fffae67ea677d54d06aacf.1436967694.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5c4d3594a5b0a79248fffae67ea677d54d06aacf.1436967694.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 15, 2015 at 6:54 AM, Vladimir Davydov
<vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> Hwpoison allows to filter pages by memory cgroup ino. Currently, it
> calls try_get_mem_cgroup_from_page to obtain the cgroup from a page and
> then its ino using cgroup_ino, but now we have an apter method for that,
> page_cgroup_ino, so use it instead.
>
> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Reviewed-by: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  mm/hwpoison-inject.c |  5 +----
>  mm/memory-failure.c  | 16 ++--------------
>  2 files changed, 3 insertions(+), 18 deletions(-)
>
> diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
> index bf73ac17dad4..5015679014c1 100644
> --- a/mm/hwpoison-inject.c
> +++ b/mm/hwpoison-inject.c
> @@ -45,12 +45,9 @@ static int hwpoison_inject(void *data, u64 val)
>         /*
>          * do a racy check with elevated page count, to make sure PG_hwpoison
>          * will only be set for the targeted owner (or on a free page).
> -        * We temporarily take page lock for try_get_mem_cgroup_from_page().
>          * memory_failure() will redo the check reliably inside page lock.
>          */
> -       lock_page(hpage);
>         err = hwpoison_filter(hpage);
> -       unlock_page(hpage);
>         if (err)
>                 goto put_out;
>
> @@ -126,7 +123,7 @@ static int pfn_inject_init(void)
>         if (!dentry)
>                 goto fail;
>
> -#ifdef CONFIG_MEMCG_SWAP
> +#ifdef CONFIG_MEMCG
>         dentry = debugfs_create_u64("corrupt-filter-memcg", 0600,
>                                     hwpoison_dir, &hwpoison_filter_memcg);
>         if (!dentry)
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 1cf7f2988422..97005396a507 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -130,27 +130,15 @@ static int hwpoison_filter_flags(struct page *p)
>   * can only guarantee that the page either belongs to the memcg tasks, or is
>   * a freed page.
>   */
> -#ifdef CONFIG_MEMCG_SWAP
> +#ifdef CONFIG_MEMCG
>  u64 hwpoison_filter_memcg;
>  EXPORT_SYMBOL_GPL(hwpoison_filter_memcg);
>  static int hwpoison_filter_task(struct page *p)
>  {
> -       struct mem_cgroup *mem;
> -       struct cgroup_subsys_state *css;
> -       unsigned long ino;
> -
>         if (!hwpoison_filter_memcg)
>                 return 0;
>
> -       mem = try_get_mem_cgroup_from_page(p);
> -       if (!mem)
> -               return -EINVAL;
> -
> -       css = mem_cgroup_css(mem);
> -       ino = cgroup_ino(css->cgroup);
> -       css_put(css);
> -
> -       if (ino != hwpoison_filter_memcg)
> +       if (page_cgroup_ino(p) != hwpoison_filter_memcg)
>                 return -EINVAL;
>
>         return 0;
> --
> 2.1.4
>



-- 
Andres Lagar-Cavilla | Google Kernel Team | andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
