From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 3/3] mm/mempolicy: add nodes_empty check in
 SYSC_migrate_pages
Date: Mon, 27 Nov 2017 18:25:48 +0100
Message-ID: <ea6e56d5-ede6-580e-ed2d-c1ab975f5d91@suse.cz>
References: <1510882624-44342-1-git-send-email-xieyisheng1@huawei.com>
 <1510882624-44342-4-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510882624-44342-4-git-send-email-xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/17/2017 02:37 AM, Yisheng Xie wrote:
> As manpage of migrate_pages, the errno should be set to EINVAL when
> none of the node IDs specified by new_nodes are on-line and allowed
> by the process's current cpuset context, or none of the specified
> nodes contain memory. However, when test by following case:
> 
> 	new_nodes = 0;
> 	old_nodes = 0xf;
> 	ret = migrate_pages(pid, old_nodes, new_nodes, MAX);
> 
> The ret will be 0 and no errno is set. As the new_nodes is empty,
> we should expect EINVAL as documented.
> 
> To fix the case like above, this patch check whether target nodes
> AND current task_nodes is empty, and then check whether AND
> node_states[N_MEMORY] is empty.
> 
> Signed-off-by: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  mm/mempolicy.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 65df28d..f604b22 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1433,10 +1433,14 @@ static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
>  		goto out_put;
>  	}

Let me add the whole preceding that ends on the lines above:

        task_nodes = cpuset_mems_allowed(task);
        /* Is the user allowed to access the target nodes? */
        if (!nodes_subset(*new, task_nodes) && !capable(CAP_SYS_NICE)) {
                err = -EPERM;
                goto out_put;
        }

>  
> -	if (!nodes_subset(*new, node_states[N_MEMORY])) {
> -		err = -EINVAL;
> +	task_nodes = cpuset_mems_allowed(current);
> +	nodes_and(*new, *new, task_nodes);
> +	if (nodes_empty(*new))
> +		goto out_put;

So if we have CAP_SYS_NICE, we pass (or rather skip) the EPERM check
above, but the current cpuset restriction still applies regardless. This
doesn't make sense to me? If I get Christoph right in the v2 discussion,
then CAP_SYS_NICE should not allow current cpuset escape. In that case,
we should remove the CAP_SYS_NICE check from the EPERM check? Also
should it be a subset check, or a non-empty-intersection check?

Note there's still a danger that we are breaking existing code so this
will have to be reverted in any case...

> +
> +	nodes_and(*new, *new, node_states[N_MEMORY]);
> +	if (nodes_empty(*new))
>  		goto out_put;
> -	}
>  
>  	err = security_task_movememory(task);
>  	if (err)
> 
