From: SeongJae Park <sj38.park@gmail.com>
Subject: Re: [PATCH 4/4] mm/madvise: allow KSM hints for remote API
Date: Sat, 11 Jan 2020 08:42:59 +0100
Message-ID: <20200111074259.25577-1-sj38.park@gmail.com>
References: <20200110213433.94739-5-minchan@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200110213433.94739-5-minchan@kernel.org> (raw)
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Daniel Colascione <dancol@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>
List-Id: linux-api@vger.kernel.org

On Fri, 10 Jan 2020 13:34:33 -0800 Minchan Kim <minchan@kernel.org> wrote:

> From: Oleksandr Natalenko <oleksandr@redhat.com>
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
> Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Reviewed-by: SeongJae Park <sjpark@amazon.de>

> ---
>  mm/madvise.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index eb42b2b7f49b..3aa9aec6bfd9 100644
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
> -- 
> 2.25.0.rc1.283.g88dfdc4193-goog
