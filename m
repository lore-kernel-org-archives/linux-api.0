From: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -mm v8 1/7] memcg: add page_cgroup_ino helper
Date: Wed, 15 Jul 2015 11:59:22 -0700
Message-ID: <CAJu=L5_Hc-p7n79S-qoSepFR4nVhjR8QkFysKvWPvzb5tqhZOw@mail.gmail.com>
References: <cover.1436967694.git.vdavydov@parallels.com>
	<40a2af5afc7b70a133737226cd9e975df42936e7.1436967694.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <40a2af5afc7b70a133737226cd9e975df42936e7.1436967694.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 15, 2015 at 6:54 AM, Vladimir Davydov
<vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> This function returns the inode number of the closest online ancestor of
> the memory cgroup a page is charged to. It is required for exporting
> information about which page is charged to which cgroup to userspace,
> which will be introduced by a following patch.
>
> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Reviewed-by: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  include/linux/memcontrol.h |  1 +
>  mm/memcontrol.c            | 23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 73b02b0a8f60..50069abebc3c 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -116,6 +116,7 @@ static inline bool mm_match_cgroup(struct mm_struct *mm,
>
>  extern struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg);
>  extern struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
> +extern unsigned long page_cgroup_ino(struct page *page);
>
>  struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *,
>                                    struct mem_cgroup *,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index acb93c554f6e..894dc2169979 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -631,6 +631,29 @@ struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
>         return &memcg->css;
>  }
>
> +/**
> + * page_cgroup_ino - return inode number of the memcg a page is charged to
> + * @page: the page
> + *
> + * Look up the closest online ancestor of the memory cgroup @page is charged to
> + * and return its inode number or 0 if @page is not charged to any cgroup. It
> + * is safe to call this function without holding a reference to @page.
> + */
> +unsigned long page_cgroup_ino(struct page *page)
> +{
> +       struct mem_cgroup *memcg;
> +       unsigned long ino = 0;
> +
> +       rcu_read_lock();
> +       memcg = READ_ONCE(page->mem_cgroup);
> +       while (memcg && !(memcg->css.flags & CSS_ONLINE))
> +               memcg = parent_mem_cgroup(memcg);
> +       if (memcg)
> +               ino = cgroup_ino(memcg->css.cgroup);
> +       rcu_read_unlock();
> +       return ino;
> +}
> +
>  static struct mem_cgroup_per_zone *
>  mem_cgroup_page_zoneinfo(struct mem_cgroup *memcg, struct page *page)
>  {
> --
> 2.1.4
>



-- 
Andres Lagar-Cavilla | Google Kernel Team | andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
