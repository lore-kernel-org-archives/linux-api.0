From: Li Xinhai <lixinhai_lxh@126.com>
Subject: Re: [PATCH v2] mm: Fix checking unmapped holes for mbind
Date: Thu, 31 Oct 2019 20:32:01 +0800
Message-ID: <696e5cdb-5292-c5fb-43f4-32c91ae82607@126.com>
References: <201910291756045288126@gmail.com>
 <2019103111150700409251@gmail.com>
 <20191031090621.GA8196@hori.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191031090621.GA8196@hori.linux.bs1.fc.nec.co.jp>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Li Xinhai <lixinhai.lxh@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, akpm <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org



On 2019/10/31 17:06, Naoya Horiguchi wrote:
> On Thu, Oct 31, 2019 at 11:15:09AM +0800, Li Xinhai wrote:
>> On 2019-10-29 at 17:56 Li Xinhai wrote:
>>> queue_pages_range() will check for unmapped holes besides queue pages for
>>> migration. The rules for checking unmapped holes are:
>>> 1 Unmapped holes at any part of the specified range should be reported as
>>>    EFAULT if mbind() for none MPOL_DEFAULT cases;
>>> 2 Unmapped holes at any part of the specified range should be ignored if
>>>    mbind() for MPOL_DEFAULT case;
>>> Note that the second rule is the current implementation, but it seems
>>> conflicts the Linux API definition.
>>>
>>> queue_pages_test_walk() is fixed by introduce new fields in struct
>>> queue_pages which help to check:
>>> 1 holes at head and tail side of specified range;
>>> 2 the whole range is in a hole;
>>>
>>> Besides, queue_pages_test_walk() must update previous vma record no matter
>>> the current vma should be considered for queue pages or not.
>>>
>>
>> More details about current issue (which breaks the mbind() API definition):
>> 1. In queue_pages_test_walk()
>> checking on (!vma->vm_next && vma->vm_end < end) would never success,
>> because 'end' passed from walk_page_test() make sure "end <=  vma->vm_end". so hole
>> beyond the last vma can't be detected.
>>
>> 2. queue_pages_test_walk() only called for vma, and 'start', 'end' parameters are guaranteed
>> within vma. Then, if the range starting or ending in an unmapped hole,
>> queue_pages_test_walk() don't have chance to be called to check. In other words, the
>> current code can detect this case (range span over hole):
>> [  vma  ][ hole ][ vma]
>>     [     range      ]
>> but cant not detect these case :
>> [  vma  ][ hole ][ vma]
>>     [  range  ]
>> [  vma  ][ hole ][  vma  ]
>>              [  range  ]
> 
> IIRC, page table walker (walk_page_range()) should be designed to
> handle these range inputs by separating into sub-ranges by vma
> boundaries like below (with your notation):
> 
>    [  vma  ][ hole ][ vma  ]
>       [    ][      ][  ]      // for your 1st case
>       [    ][   ]             // for your 2nd case
>                [   ][  ]      // for your 3rd case
> 
Yes, pagewalk works exactly as your description.

> And I found that .pte_hole is undefined in queue_pages_walk_ops.
> So I'm guessing now that that's why hole regions are ignored and
> the definition of EFAULT behavior in manpage is violated.
> So providing proper .pte_hole callback could be another approach
> for this issue which might fit better to the design.
Using the .pte_hole() can be one option, we may stop detecting the
unmapped holes when .pte_hole() been first called for a hole which
is outside vma. But, .pte_hole() would be called many times during
the walking, because it is called for holes inside and outside VMA.
.test_walk() is called once for one vma, and not called for other
situation, so better for cost.

> IOW, queue_pages_test_walk() might not the right place to handle
> hole regions by definition.
I guess the original design was to avoid walking those vma twice, one
for test holes and one for queue pages. Maybe we can find better
choice?

> 
> Thanks,
> Naoya Horiguchi
> 
>>
>> 3. a checking in mbind_range() try to recover if the hole is in head side, but can't
>> recover if hole is in tail side of range.
>>
>> - Xinhai
>>
>>> Fixes: 9d8cebd4bcd7 ("mm: fix mbind vma merge problem")
>>> Fixes: 6f4576e3687b ("mempolicy: apply page table walker on queue_pages_range()")
>>> Fixes: 48684a65b4e3 ("mm: pagewalk: fix misbehavior of walk_page_range for vma(VM_PFNMAP)")
>>> Signed-off-by: Li Xinhai <lixinhai.li@gmail.com>
>>> ---
>>> Changes in v2:
>>>    - Fix the unmapped holes checking in queue_pages_test_walk() instead of
>>>      mbind_rnage().
>>>
>>>   mm/mempolicy.c | 44 +++++++++++++++++++++++++++++---------------
>>>   1 file changed, 29 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>>> index 4ae967bcf954..24087dfa4dcd 100644
>>> --- a/mm/mempolicy.c
>>> +++ b/mm/mempolicy.c
>>> @@ -411,6 +411,9 @@ struct queue_pages {
>>>   	unsigned long flags;
>>>   	nodemask_t *nmask;
>>>   	struct vm_area_struct *prev;
>>> +	unsigned long start;
>>> +	unsigned long end;
>>> +	int in_hole;
>>>   };
>>>   
>>>   /*
>>> @@ -618,28 +621,31 @@ static int queue_pages_test_walk(unsigned long start, unsigned long end,
>>>   	unsigned long endvma = vma->vm_end;
>>>   	unsigned long flags = qp->flags;
>>>   
>>> -	/*
>>> -	* Need check MPOL_MF_STRICT to return -EIO if possible
>>> -	* regardless of vma_migratable
>>> -	*/
>>> -	if (!vma_migratable(vma) &&
>>> -	   !(flags & MPOL_MF_STRICT))
>>> -	return 1;
>>> -
>>> +	/* range check first */
>>>   	if (endvma > end)
>>>   	endvma = end;
>>> -	if (vma->vm_start > start)
>>> -	start = vma->vm_start;
>>> +	BUG_ON((vma->vm_start > start) || (vma->vm_end < end));
>>>   
>>> +	qp->in_hole = 0;
>>>   	if (!(flags & MPOL_MF_DISCONTIG_OK)) {
>>> -	if (!vma->vm_next && vma->vm_end < end)
>>> +	if ((!vma->vm_next && vma->vm_end < qp->end) ||
>>> +	(vma->vm_next && qp->end < vma->vm_next->vm_start))
>>>   	return -EFAULT;
>>> -	if (qp->prev && qp->prev->vm_end < vma->vm_start)
>>> +	if ((qp->prev && qp->prev->vm_end < vma->vm_start) ||
>>> +	(!qp->prev && qp->start < vma->vm_start))
>>>   	return -EFAULT;
>>>   	}
>>>   
>>>   	qp->prev = vma;
>>>   
>>> +	/*
>>> +	* Need check MPOL_MF_STRICT to return -EIO if possible
>>> +	* regardless of vma_migratable
>>> +	*/
>>> +	if (!vma_migratable(vma) &&
>>> +	   !(flags & MPOL_MF_STRICT))
>>> +	return 1;
>>> +
>>>   	if (flags & MPOL_MF_LAZY) {
>>>   	/* Similar to task_numa_work, skip inaccessible VMAs */
>>>   	if (!is_vm_hugetlb_page(vma) &&
>>> @@ -679,14 +685,23 @@ queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
>>>   	nodemask_t *nodes, unsigned long flags,
>>>   	struct list_head *pagelist)
>>>   {
>>> +	int err;
>>>   	struct queue_pages qp = {
>>>   	.pagelist = pagelist,
>>>   	.flags = flags,
>>>   	.nmask = nodes,
>>>   	.prev = NULL,
>>> +	.start = start,
>>> +	.end = end,
>>> +	.in_hole = 1,
>>>   	};
>>>   
>>> -	return walk_page_range(mm, start, end, &queue_pages_walk_ops, &qp);
>>> +	err = walk_page_range(mm, start, end, &queue_pages_walk_ops, &qp);
>>> +	/* whole range in unmapped hole */
>>> +	if (qp->in_hole && !(flags & MPOL_MF_DISCONTIG_OK))
>>> +	err = -EFAULT;
>>> +
>>> +	return err;
>>>   }
>>>   
>>>   /*
>>> @@ -738,8 +753,7 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
>>>   	unsigned long vmend;
>>>   
>>>   	vma = find_vma(mm, start);
>>> -	if (!vma || vma->vm_start > start)
>>> -	return -EFAULT;
>>> +	BUG_ON(!vma);
>>>   
>>>   	prev = vma->vm_prev;
>>>   	if (start > vma->vm_start)
>>> -- 
>>> 2.22.0
