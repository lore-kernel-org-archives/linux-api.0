From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: Re: [PATCH] mm/mempolicy: add node_empty check in SYSC_migrate_pages
Date: Fri, 20 Oct 2017 14:42:38 +0800
Message-ID: <79f20d60-dd8d-2545-5a9b-09871ad8ee4e@huawei.com>
References: <1508290660-60619-1-git-send-email-xieyisheng1@huawei.com>
 <7086c6ea-b721-684e-fe3d-ff59ae1d78ed@suse.cz>
 <20aac66a-7252-947c-355b-6da4be671dcf@huawei.com>
 <f889d39f-ca1f-9239-dc95-4e1806a6345f@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <f889d39f-ca1f-9239-dc95-4e1806a6345f@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org, mhocko@suse.com, mingo@kernel.org, rientjes@google.com, n-horiguchi@ah.jp.nec.com, salls@cs.ucsb.edu
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, will.deacon@arm.com, tanxiaojun@huawei.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Vlastimil,

Thanks for your comment!
On 2017/10/18 18:46, Vlastimil Babka wrote:
> On 10/18/2017 11:34 AM, Yisheng Xie wrote:
>>>> For MAX_NUMNODES is 4, so 0x10 nodemask will tread as empty set which makes
>>>> 	nodes_subset(*new, node_states[N_MEMORY])
>>>
>>> According to manpage of migrate_pages:
>>>
>>>         EINVAL The value specified by maxnode exceeds a kernel-imposed
>>> limit.  Or, old_nodes or new_nodes specifies one or more node IDs that
>>> are greater than the maximum supported node ID.  Or, none of the node
>>> IDs specified by new_nodes are on-line and allowed by the process's
>>> current cpuset context, or none of the specified nodes contain memory.
>>>
>>> if maxnode parameter is 64, but MAX_NUMNODES ("kernel-imposed limit") is
>>> 4, we should get EINVAL just because of that. I don't see such check in
>>> the migrate_pages implementation though.
>>
>> Yes, that is what manpage said, but I have a question about this: if user
>> set maxnode exceeds a kernel-imposed and try to access node without enough
>> privilege, which errors values we should return ? For I have seen that all
>> of the ltp migrate_pages01 will set maxnode to 64 in my system.
> 
> Hm I don't think it matters much and don't know if there's some commonly
> used priority. Personally I would do the checks resulting in EINVAL
> first, before EPERM, but if the code is structured differently, it may
> stay as it is.

I see，and  I have checked the code of get_nodes, which seems treat
"kernel-imposed limit" as the meaning of
BITS_PER_LONG * BITS_TO_LONGS(MAX_NUMNODES) instead of MAX_NUMNODES,
which I have replied in another mail.

As we use unsigned long to store node bitmap, so the limit should be counted in
multiple of BITS_PER_LONG, fair?

Thanks
Yisheng Xie

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
