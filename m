From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 3/3] mm/mincore: provide mapped status when cached status
 is not allowed
Date: Fri, 1 Feb 2019 10:04:23 +0100
Message-ID: <99ee4d3e-aeb2-0104-22be-b028938e7f88@suse.cz>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-4-vbabka@suse.cz>
 <20190131100907.GS18811@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190131100907.GS18811@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Jiri Kosina <jikos@kernel.org>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, Jiri Kosina <jkosina@suse.cz>, Josh Snyder <joshs@netflix.com>
List-Id: linux-api@vger.kernel.org

On 1/31/19 11:09 AM, Michal Hocko wrote:
> On Wed 30-01-19 13:44:20, Vlastimil Babka wrote:
>> After "mm/mincore: make mincore() more conservative" we sometimes restrict the
>> information about page cache residency, which we have to do without breaking
>> existing userspace, if possible. We thus fake the resulting values as 1, which
>> should be safer than faking them as 0, as there might theoretically exist code
>> that would try to fault in the page(s) until mincore() returns 1.
>>
>> Faking 1 however means that such code would not fault in a page even if it was
>> not in page cache, with unwanted performance implications. We can improve the
>> situation by revisting the approach of 574823bfab82 ("Change mincore() to count
>> "mapped" pages rather than "cached" pages") but only applying it to cases where
>> page cache residency check is restricted. Thus mincore() will return 0 for an
>> unmapped page (which may or may not be resident in a pagecache), and 1 after
>> the process faults it in.
>>
>> One potential downside is that mincore() will be again able to recognize when a
>> previously mapped page was reclaimed. While that might be useful for some
>> attack scenarios, it's not as crucial as recognizing that somebody else faulted
>> the page in, and there are also other ways to recognize reclaimed pages anyway.
> 
> Is this really worth it? Do we know about any specific usecase that
> would benefit from this change? TBH I would rather wait for the report
> than add a hard to evaluate side channel.

Well it's not that complicated IMHO. Linus said it's worth trying, so
let's see how he likes the result. The side channel exists anyway as
long as process can e.g. check if its rss shrinked, and I doubt we are
going to remove that possibility.

Also CC Josh Snyder since I forgot originally, and keeping rest of mail
for reference.

>> Cc: Jiri Kosina <jikos@kernel.org>
>> Cc: Dominique Martinet <asmadeus@codewreck.org>
>> Cc: Andy Lutomirski <luto@amacapital.net>
>> Cc: Dave Chinner <david@fromorbit.com>
>> Cc: Kevin Easton <kevin@guarana.org>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Cyril Hrubis <chrubis@suse.cz>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Kirill A. Shutemov <kirill@shutemov.name>
>> Cc: Daniel Gruss <daniel@gruss.cc>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/mincore.c | 49 +++++++++++++++++++++++++++++++++----------------
>>  1 file changed, 33 insertions(+), 16 deletions(-)
>>
>> diff --git a/mm/mincore.c b/mm/mincore.c
>> index 747a4907a3ac..d6784a803ae7 100644
>> --- a/mm/mincore.c
>> +++ b/mm/mincore.c
>> @@ -21,12 +21,18 @@
>>  #include <linux/uaccess.h>
>>  #include <asm/pgtable.h>
>>  
>> +struct mincore_walk_private {
>> +	unsigned char *vec;
>> +	bool can_check_pagecache;
>> +};
>> +
>>  static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
>>  			unsigned long end, struct mm_walk *walk)
>>  {
>>  #ifdef CONFIG_HUGETLB_PAGE
>>  	unsigned char present;
>> -	unsigned char *vec = walk->private;
>> +	struct mincore_walk_private *walk_private = walk->private;
>> +	unsigned char *vec = walk_private->vec;
>>  
>>  	/*
>>  	 * Hugepages under user process are always in RAM and never
>> @@ -35,7 +41,7 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
>>  	present = pte && !huge_pte_none(huge_ptep_get(pte));
>>  	for (; addr != end; vec++, addr += PAGE_SIZE)
>>  		*vec = present;
>> -	walk->private = vec;
>> +	walk_private->vec = vec;
>>  #else
>>  	BUG();
>>  #endif
>> @@ -85,7 +91,8 @@ static unsigned char mincore_page(struct address_space *mapping, pgoff_t pgoff)
>>  }
>>  
>>  static int __mincore_unmapped_range(unsigned long addr, unsigned long end,
>> -				struct vm_area_struct *vma, unsigned char *vec)
>> +				struct vm_area_struct *vma, unsigned char *vec,
>> +				bool can_check_pagecache)
>>  {
>>  	unsigned long nr = (end - addr) >> PAGE_SHIFT;
>>  	int i;
>> @@ -95,7 +102,9 @@ static int __mincore_unmapped_range(unsigned long addr, unsigned long end,
>>  
>>  		pgoff = linear_page_index(vma, addr);
>>  		for (i = 0; i < nr; i++, pgoff++)
>> -			vec[i] = mincore_page(vma->vm_file->f_mapping, pgoff);
>> +			vec[i] = can_check_pagecache ?
>> +				 mincore_page(vma->vm_file->f_mapping, pgoff)
>> +				 : 0;
>>  	} else {
>>  		for (i = 0; i < nr; i++)
>>  			vec[i] = 0;
>> @@ -106,8 +115,11 @@ static int __mincore_unmapped_range(unsigned long addr, unsigned long end,
>>  static int mincore_unmapped_range(unsigned long addr, unsigned long end,
>>  				   struct mm_walk *walk)
>>  {
>> -	walk->private += __mincore_unmapped_range(addr, end,
>> -						  walk->vma, walk->private);
>> +	struct mincore_walk_private *walk_private = walk->private;
>> +	unsigned char *vec = walk_private->vec;
>> +
>> +	walk_private->vec += __mincore_unmapped_range(addr, end, walk->vma,
>> +				vec, walk_private->can_check_pagecache);
>>  	return 0;
>>  }
>>  
>> @@ -117,7 +129,8 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  	spinlock_t *ptl;
>>  	struct vm_area_struct *vma = walk->vma;
>>  	pte_t *ptep;
>> -	unsigned char *vec = walk->private;
>> +	struct mincore_walk_private *walk_private = walk->private;
>> +	unsigned char *vec = walk_private->vec;
>>  	int nr = (end - addr) >> PAGE_SHIFT;
>>  
>>  	ptl = pmd_trans_huge_lock(pmd, vma);
>> @@ -128,7 +141,8 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  	}
>>  
>>  	if (pmd_trans_unstable(pmd)) {
>> -		__mincore_unmapped_range(addr, end, vma, vec);
>> +		__mincore_unmapped_range(addr, end, vma, vec,
>> +					walk_private->can_check_pagecache);
>>  		goto out;
>>  	}
>>  
>> @@ -138,7 +152,7 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  
>>  		if (pte_none(pte))
>>  			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
>> -						 vma, vec);
>> +				 vma, vec, walk_private->can_check_pagecache);
>>  		else if (pte_present(pte))
>>  			*vec = 1;
>>  		else { /* pte is a swap entry */
>> @@ -152,8 +166,12 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  				*vec = 1;
>>  			} else {
>>  #ifdef CONFIG_SWAP
>> -				*vec = mincore_page(swap_address_space(entry),
>> +				if (walk_private->can_check_pagecache)
>> +					*vec = mincore_page(
>> +						    swap_address_space(entry),
>>  						    swp_offset(entry));
>> +				else
>> +					*vec = 0;
>>  #else
>>  				WARN_ON(1);
>>  				*vec = 1;
>> @@ -187,22 +205,21 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
>>  	struct vm_area_struct *vma;
>>  	unsigned long end;
>>  	int err;
>> +	struct mincore_walk_private walk_private = {
>> +		.vec = vec
>> +	};
>>  	struct mm_walk mincore_walk = {
>>  		.pmd_entry = mincore_pte_range,
>>  		.pte_hole = mincore_unmapped_range,
>>  		.hugetlb_entry = mincore_hugetlb,
>> -		.private = vec,
>> +		.private = &walk_private
>>  	};
>>  
>>  	vma = find_vma(current->mm, addr);
>>  	if (!vma || addr < vma->vm_start)
>>  		return -ENOMEM;
>>  	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
>> -	if (!can_do_mincore(vma)) {
>> -		unsigned long pages = (end - addr) >> PAGE_SHIFT;
>> -		memset(vec, 1, pages);
>> -		return pages;
>> -	}
>> +	walk_private.can_check_pagecache = can_do_mincore(vma);
>>  	mincore_walk.mm = vma->vm_mm;
>>  	err = walk_page_range(addr, end, &mincore_walk);
>>  	if (err < 0)
>> -- 
>> 2.20.1
> 
