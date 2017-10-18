From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/mempolicy: add node_empty check in SYSC_migrate_pages
Date: Wed, 18 Oct 2017 17:34:15 +0800
Message-ID: <20aac66a-7252-947c-355b-6da4be671dcf@huawei.com>
References: <1508290660-60619-1-git-send-email-xieyisheng1@huawei.com>
 <7086c6ea-b721-684e-fe3d-ff59ae1d78ed@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7086c6ea-b721-684e-fe3d-ff59ae1d78ed-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Vlastimil,

Thanks for your comment!
On 2017/10/18 15:54, Vlastimil Babka wrote:
> +CC linux-api
> 
> On 10/18/2017 03:37 AM, Yisheng Xie wrote:
>> As Xiaojun reported the ltp of migrate_pages01 will failed on ARCH arm64
>> system whoes has 4 nodes[0...3], all have memory and CONFIG_NODES_SHIFT=2:
>>
>> migrate_pages01    0  TINFO  :  test_invalid_nodes
>> migrate_pages01   14  TFAIL  :  migrate_pages_common.c:45: unexpected failure - returned value = 0, expected: -1
>> migrate_pages01   15  TFAIL  :  migrate_pages_common.c:55: call succeeded unexpectedly
>>
>> In this case the test_invalid_nodes of migrate_pages01 will call:
>> SYSC_migrate_pages as:
>>
>> migrate_pages(0, , {0x0000000000000001}, 64, , {0x0000000000000010}, 64) = 0
> 
> is 64 here the maxnode parameter of migrate_pages() ?

Yes, I have print it in the kernel.

> 
>> For MAX_NUMNODES is 4, so 0x10 nodemask will tread as empty set which makes
>> 	nodes_subset(*new, node_states[N_MEMORY])
> 
> According to manpage of migrate_pages:
> 
>         EINVAL The value specified by maxnode exceeds a kernel-imposed
> limit.  Or, old_nodes or new_nodes specifies one or more node IDs that
> are greater than the maximum supported node ID.  Or, none of the node
> IDs specified by new_nodes are on-line and allowed by the process's
> current cpuset context, or none of the specified nodes contain memory.
> 
> if maxnode parameter is 64, but MAX_NUMNODES ("kernel-imposed limit") is
> 4, we should get EINVAL just because of that. I don't see such check in
> the migrate_pages implementation though.

Yes, that is what manpage said, but I have a question about this: if user
set maxnode exceeds a kernel-imposed and try to access node without enough
privilege, which errors values we should return ? For I have seen that all
of the ltp migrate_pages01 will set maxnode to 64 in my system.

> But then at least the
> "new_nodes specifies one or more node IDs that are greater than the
> maximum supported node ID" part should trigger here, because you have
> node number 8 set in the new_nodes nodemask, right?
> get_nodes() should be checking this according to comment:
> 
>         /* When the user specified more nodes than supported just check
>            if the non supported part is all zero. */
> 
> Somehow that doesn't seem to work then? I think we should look into
> this. Your patch may still be needed, or not, after that is resolved.

OK, I will check why get_nodes do not works as it comments.

Thanks
Yisheng Xie

> 
>> return true, as empty set is subset of any set.
>>
>> So this is a common issue which also can happens in X86_64 system eg. 8 nodes[0..7],
>> all with memory and CONFIG_NODES_SHIFT=3. Fix it by adding node_empty check in
>> SYSC_migrate_pages.
>>
>> Reported-by: Tan Xiaojun <tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  mm/mempolicy.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index a2af6d5..1dfd3cc 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -1388,6 +1388,11 @@ static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
>>  	if (err)
>>  		goto out;
>>  
>> +	if (nodes_empty(*new)) {
>> +		err = -EINVAL;
>> +		goto out;
>> +	}
>> +
>>  	/* Find the mm_struct */
>>  	rcu_read_lock();
>>  	task = pid ? find_task_by_vpid(pid) : current;
>>
> 
> 
> .
> 
