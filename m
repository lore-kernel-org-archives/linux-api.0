From: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -mm v8 7/7] proc: export idle flag via kpageflags
Date: Wed, 15 Jul 2015 12:17:02 -0700
Message-ID: <CAJu=L58+L9nQDeW0VeaX3fmKy0EWG7js_rg3eWSVTg1D3WWHkg@mail.gmail.com>
References: <cover.1436967694.git.vdavydov@parallels.com>
	<024b60a19e5ef246c9af3c5ff7652e71576e0bcc.1436967694.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <024b60a19e5ef246c9af3c5ff7652e71576e0bcc.1436967694.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 15, 2015 at 6:54 AM, Vladimir Davydov
<vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> As noted by Minchan, a benefit of reading idle flag from
> /proc/kpageflags is that one can easily filter dirty and/or unevictable
> pages while estimating the size of unused memory.
>
> Note that idle flag read from /proc/kpageflags may be stale in case the
> page was accessed via a PTE, because it would be too costly to iterate
> over all page mappings on each /proc/kpageflags read to provide an
> up-to-date value. To make sure the flag is up-to-date one has to read
> /proc/kpageidle first.
>
> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Reviewed-by: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  Documentation/vm/pagemap.txt           | 6 ++++++
>  fs/proc/page.c                         | 3 +++
>  include/uapi/linux/kernel-page-flags.h | 1 +
>  3 files changed, 10 insertions(+)
>
> diff --git a/Documentation/vm/pagemap.txt b/Documentation/vm/pagemap.txt
> index c9266340852c..5896b7d7fd74 100644
> --- a/Documentation/vm/pagemap.txt
> +++ b/Documentation/vm/pagemap.txt
> @@ -64,6 +64,7 @@ There are five components to pagemap:
>      22. THP
>      23. BALLOON
>      24. ZERO_PAGE
> +    25. IDLE
>
>   * /proc/kpagecgroup.  This file contains a 64-bit inode number of the
>     memory cgroup each page is charged to, indexed by PFN. Only available when
> @@ -124,6 +125,11 @@ Short descriptions to the page flags:
>  24. ZERO_PAGE
>      zero page for pfn_zero or huge_zero page
>
> +25. IDLE
> +    page has not been accessed since it was marked idle (see /proc/kpageidle)
> +    Note that this flag may be stale in case the page was accessed via a PTE.
> +    To make sure the flag is up-to-date one has to read /proc/kpageidle first.
> +
>      [IO related page flags]
>   1. ERROR     IO error occurred
>   3. UPTODATE  page has up-to-date data
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 273537885ab4..13dcb823fe4e 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -150,6 +150,9 @@ u64 stable_page_flags(struct page *page)
>         if (PageBalloon(page))
>                 u |= 1 << KPF_BALLOON;
>
> +       if (page_is_idle(page))
> +               u |= 1 << KPF_IDLE;
> +
>         u |= kpf_copy_bit(k, KPF_LOCKED,        PG_locked);
>
>         u |= kpf_copy_bit(k, KPF_SLAB,          PG_slab);
> diff --git a/include/uapi/linux/kernel-page-flags.h b/include/uapi/linux/kernel-page-flags.h
> index a6c4962e5d46..5da5f8751ce7 100644
> --- a/include/uapi/linux/kernel-page-flags.h
> +++ b/include/uapi/linux/kernel-page-flags.h
> @@ -33,6 +33,7 @@
>  #define KPF_THP                        22
>  #define KPF_BALLOON            23
>  #define KPF_ZERO_PAGE          24
> +#define KPF_IDLE               25
>
>
>  #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
> --
> 2.1.4
>



-- 
Andres Lagar-Cavilla | Google Kernel Team | andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
