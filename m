From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v2 4/5] mm/madvise: allow KSM hints for remote API
Date: Fri, 17 Jan 2020 13:13:14 +0300
Message-ID: <37338e14-5a55-1926-b6c1-5f98b6a6fdb5@virtuozzo.com>
References: <20200116235953.163318-1-minchan@kernel.org>
 <20200116235953.163318-5-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200116235953.163318-5-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Dias <joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, sjpark-ebkRAfMGSJGzQB+pC5nmwQ@public.gmane.org, Minchan Kim <minchan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 17.01.2020 02:59, Minchan Kim wrote:
> From: Oleksandr Natalenko <oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> It all began with the fact that KSM works only on memory that is marked
> by madvise(). And the only way to get around that is to either:
> 
>   * use LD_PRELOAD; or
>   * patch the kernel with something like UKSM or PKSM.
> 
> (i skip ptrace can of worms here intentionally)
> 
> To overcome this restriction, lets employ a new remote madvise API. This
> can be used by some small userspace helper daemon that will do auto-KSM
> job for us.
> 
> I think of two major consumers of remote KSM hints:
> 
>   * hosts, that run containers, especially similar ones and especially in
>     a trusted environment, sharing the same runtime like Node.js;
> 
>   * heavy applications, that can be run in multiple instances, not
>     limited to opensource ones like Firefox, but also those that cannot be
>     modified since they are binary-only and, maybe, statically linked.
> 
> Speaking of statistics, more numbers can be found in the very first
> submission, that is related to this one [1]. For my current setup with
> two Firefox instances I get 100 to 200 MiB saved for the second instance
> depending on the amount of tabs.
> 
> 1 FF instance with 15 tabs:
> 
>    $ echo "$(cat /sys/kernel/mm/ksm/pages_sharing) * 4 / 1024" | bc
>    410
> 
> 2 FF instances, second one has 12 tabs (all the tabs are different):
> 
>    $ echo "$(cat /sys/kernel/mm/ksm/pages_sharing) * 4 / 1024" | bc
>    592
> 
> At the very moment I do not have specific numbers for containerised
> workload, but those should be comparable in case the containers share
> similar/same runtime.
> 
> [1] https://lore.kernel.org/patchwork/patch/1012142/
> 
> Signed-off-by: Oleksandr Natalenko <oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Minchan Kim <minchan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/madvise.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 84cffd0900f1..89557998d287 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1000,6 +1000,8 @@ process_madvise_behavior_valid(int behavior)
>  	switch (behavior) {
>  	case MADV_COLD:
>  	case MADV_PAGEOUT:
> +	case MADV_MERGEABLE:
> +	case MADV_UNMERGEABLE:
>  		return true;
>  	default:
>  		return false;

Remote madvise on KSM parameters should be OK.

One thing is madvise_behavior_valid() places MADV_MERGEABLE/UNMERGEABLE
in #ifdef brackes, so -EINVAL is returned by madvise() syscall if KSM
is not enabled. Here we should follow the same way for symmetry.
