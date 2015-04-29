From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 3/3] proc: add kpageidle file
Date: Wed, 29 Apr 2015 13:57:59 +0900
Message-ID: <20150429045759.GA27051@blaptop>
References: <cover.1430217477.git.vdavydov@parallels.com>
 <4c24a6bf2c9711dd4dbb72a43a16eba6867527b7.1430217477.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4c24a6bf2c9711dd4dbb72a43a16eba6867527b7.1430217477.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 28, 2015 at 03:24:42PM +0300, Vladimir Davydov wrote:
> Knowing the portion of memory that is not used by a certain application
> or memory cgroup (idle memory) can be useful for partitioning the system
> efficiently, e.g. by setting memory cgroup limits appropriately.
> Currently, the only means to estimate the amount of idle memory provided
> by the kernel is /proc/PID/{clear_refs,smaps}: the user can clear the
> access bit for all pages mapped to a particular process by writing 1 to
> clear_refs, wait for some time, and then count smaps:Referenced.
> However, this method has two serious shortcomings:
> 
>  - it does not count unmapped file pages
>  - it affects the reclaimer logic
> 
> To overcome these drawbacks, this patch introduces two new page flags,
> Idle and Young, and a new proc file, /proc/kpageidle. A page's Idle flag
> can only be set from userspace by writing 1 to /proc/kpageidle at the
> offset corresponding to the page, and it is cleared whenever the page is
> accessed either through page tables (it is cleared in page_referenced()
> in this case) or using the read(2) system call (mark_page_accessed()).
> Thus by setting the Idle flag for pages of a particular workload, which
> can be found e.g. by reading /proc/PID/pagemap, waiting for some time to
> let the workload access its working set, and then reading the kpageidle
> file, one can estimate the amount of pages that are not used by the
> workload.
> 
> The Young page flag is used to avoid interference with the memory
> reclaimer. A page's Young flag is set whenever the Access bit of a page
> table entry pointing to the page is cleared by writing to kpageidle. If
> page_referenced() is called on a Young page, it will add 1 to its return
> value, therefore concealing the fact that the Access bit was cleared.
> 
> Note, since there is no room for extra page flags on 32 bit, this
> feature uses extended page flags when compiled on 32 bit.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> ---
>  Documentation/vm/pagemap.txt |   10 ++-
>  fs/proc/page.c               |  154 ++++++++++++++++++++++++++++++++++++++++++
>  fs/proc/task_mmu.c           |    4 +-
>  include/linux/mm.h           |   88 ++++++++++++++++++++++++
>  include/linux/page-flags.h   |    9 +++
>  include/linux/page_ext.h     |    4 ++
>  mm/Kconfig                   |   12 ++++
>  mm/debug.c                   |    4 ++
>  mm/page_ext.c                |    3 +
>  mm/rmap.c                    |    7 ++
>  mm/swap.c                    |    2 +
>  11 files changed, 295 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/vm/pagemap.txt b/Documentation/vm/pagemap.txt
> index a9b7afc8fbc6..ac6fd32a9296 100644
> --- a/Documentation/vm/pagemap.txt
> +++ b/Documentation/vm/pagemap.txt
> @@ -5,7 +5,7 @@ pagemap is a new (as of 2.6.25) set of interfaces in the kernel that allow
>  userspace programs to examine the page tables and related information by
>  reading files in /proc.
>  
> -There are four components to pagemap:
> +There are five components to pagemap:
>  
>   * /proc/pid/pagemap.  This file lets a userspace process find out which
>     physical frame each virtual page is mapped to.  It contains one 64-bit
> @@ -69,6 +69,14 @@ There are four components to pagemap:
>     memory cgroup each page is charged to, indexed by PFN. Only available when
>     CONFIG_MEMCG is set.
>  
> + * /proc/kpageidle.  For each page this file contains a 64-bit number, which
> +   equals 1 if the page is idle or 0 otherwise, indexed by PFN. A page is
> +   considered idle if it has not been accessed since it was marked idle. To
> +   mark a page idle one should write 1 to this file at the offset corresponding
> +   to the page. Only user memory pages can be marked idle, for other page types
> +   input is silently ignored. Writing to this file beyond max PFN results in
> +   the ENXIO error. Only available when CONFIG_IDLE_PAGE_TRACKING is set.
> +

How about using kpageflags for reading part?

I mean PG_idle is one of the page flags and we already have a feature to
parse of each PFN flag so we could reuse existing feature for reading
idleness.

-- 
Kind regards,
Minchan Kim
