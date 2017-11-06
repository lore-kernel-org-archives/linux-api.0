From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v2 4/4] mm/mempolicy: add nodes_empty check in
 SYSC_migrate_pages
Date: Mon, 6 Nov 2017 09:31:44 +0800
Message-ID: <bc57f574-92f2-0b69-4717-a1ec7170387c@huawei.com>
References: <1509099265-30868-1-git-send-email-xieyisheng1@huawei.com>
 <1509099265-30868-5-git-send-email-xieyisheng1@huawei.com>
 <dccbeccc-4155-94a8-0e67-b7c28238896d@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dccbeccc-4155-94a8-0e67-b7c28238896d-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Vlastimil,

On 2017/10/31 17:46, Vlastimil Babka wrote:
> +CC Andi and Christoph
> 
> On 10/27/2017 12:14 PM, Yisheng Xie wrote:
>> As manpage of migrate_pages, the errno should be set to EINVAL when none
>> of the specified nodes contain memory. However, when new_nodes is null,
>> i.e. the specified nodes also do not have memory, as the following case:
>>
>> 	new_nodes = 0;
>> 	old_nodes = 0xf;
>> 	ret = migrate_pages(pid, old_nodes, new_nodes, MAX);
>>
>> The ret will be 0 and no errno is set.
>>
>> This patch is to add nodes_empty check to fix above case.
> 
> Hmm, I think we have a bigger problem than "empty set is a subset of
> anything" here.
> 
> The existing checks are:
> 
>         task_nodes = cpuset_mems_allowed(task);
>         if (!nodes_subset(*new, task_nodes) && !capable(CAP_SYS_NICE)) {
>                 err = -EPERM;
>                 goto out_put;
>         }
> 
>         if (!nodes_subset(*new, node_states[N_MEMORY])) {
>                 err = -EINVAL;
>                 goto out_put;
>         }
> 
> 
> And manpage says:
> 
>        EINVAL The value specified by maxnode exceeds a kernel-imposed
> limit.  Or, old_nodes or new_nodes specifies one or more node IDs that
> are greater than the maximum supported node
>               ID.  *Or, none of the node IDs specified by new_nodes are
> on-line and allowed by the process's current cpuset context, or none of
> the specified nodes contain memory.*
> 
>        EPERM  Insufficient privilege (CAP_SYS_NICE) to move pages of the
> process specified by pid, or insufficient privilege (CAP_SYS_NICE) to
> access the specified target nodes.
> 
> - it says "none ... are allowed", but checking for subset means we check
> if "all ... are allowed". Shouldn't we be checking for a non-empty
> intersection?

You are absolutely right. To follow the manpage, we should check non-empty
of intersection instead of subset. I mean：
         nodes_and(*new, *new, task_nodes);
         if (!node_empty(*new) && !capable(CAP_SYS_NICE)) {
                 err = -EPERM;
                 goto out_put;
         }

         nodes_and(*new, *new, node_states[N_MEMORY]);
         if (!node_empty(*new)) {
                 err = -EINVAL;
                 goto out_put;
         }

So finally, we should only migrate the smallest intersection of all the node
set, right?

> - there doesn't seem to be any EINVAL check for "process's current
> cpuset context", there's just an EPERM check for "target process's
> cpuset context".

This also need to be checked as manpage.

Thanks
Yisheng Xie
