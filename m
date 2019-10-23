From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC PATCH 1/2] mm, vmstat: hide /proc/pagetypeinfo from normal
 users
Date: Wed, 23 Oct 2019 18:15:37 +0200
Message-ID: <ed60303a-0775-c6ce-2923-df3ffe6a887f@suse.cz>
References: <20191023095607.GE3016@techsingularity.net>
 <20191023102737.32274-1-mhocko@kernel.org>
 <20191023102737.32274-2-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191023102737.32274-2-mhocko@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Jann Horn <jannh@google.com>, Song Liu <songliubraving@fb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

+ linux-api

On 10/23/19 12:27 PM, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> /proc/pagetypeinfo is a debugging tool to examine internal page
> allocator state wrt to fragmentation. It is not very useful for
> any other use so normal users really do not need to read this file.
> 
> Waiman Long has noticed that reading this file can have negative side
> effects because zone->lock is necessary for gathering data and that
> a) interferes with the page allocator and its users and b) can lead to
> hard lockups on large machines which have very long free_list.
> 
> Reduce both issues by simply not exporting the file to regular users.
> 
> Reported-by: Waiman Long <longman@redhat.com>
> Cc: stable
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> ---
>  mm/vmstat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 6afc892a148a..4e885ecd44d1 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1972,7 +1972,7 @@ void __init init_mm_internals(void)
>  #endif
>  #ifdef CONFIG_PROC_FS
>  	proc_create_seq("buddyinfo", 0444, NULL, &fragmentation_op);
> -	proc_create_seq("pagetypeinfo", 0444, NULL, &pagetypeinfo_op);
> +	proc_create_seq("pagetypeinfo", 0400, NULL, &pagetypeinfo_op);
>  	proc_create_seq("vmstat", 0444, NULL, &vmstat_op);
>  	proc_create_seq("zoneinfo", 0444, NULL, &zoneinfo_op);
>  #endif
> 
