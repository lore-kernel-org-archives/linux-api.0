From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 3/6] mm, page_alloc: pass preferred nid instead of
 zonelist to allocator
Date: Thu, 18 May 2017 12:25:03 +0200
Message-ID: <c748a22c-9a94-52cb-2247-afc281cc5d78@suse.cz>
References: <20170517081140.30654-1-vbabka@suse.cz>
 <20170517081140.30654-4-vbabka@suse.cz>
 <alpine.DEB.2.20.1705171009340.8714@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1705171009340.8714-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/17/2017 05:19 PM, Christoph Lameter wrote:
> On Wed, 17 May 2017, Vlastimil Babka wrote:
> 
>>  struct page *
>> -__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>> -		       struct zonelist *zonelist, nodemask_t *nodemask);
>> +__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
>> +							nodemask_t *nodemask);
>>
>>  static inline struct page *
>> -__alloc_pages(gfp_t gfp_mask, unsigned int order,
>> -		struct zonelist *zonelist)
>> +__alloc_pages(gfp_t gfp_mask, unsigned int order, int preferred_nid)
>>  {
>> -	return __alloc_pages_nodemask(gfp_mask, order, zonelist, NULL);
>> +	return __alloc_pages_nodemask(gfp_mask, order, preferred_nid, NULL);
>>  }
> 
> Maybe use nid instead of preferred_nid like in __alloc_pages? Otherwise
> there may be confusion with the MPOL_PREFER policy.

I'll think about that.

>> @@ -1963,8 +1960,8 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
>>  {
>>  	struct mempolicy *pol;
>>  	struct page *page;
>> +	int preferred_nid;
>>  	unsigned int cpuset_mems_cookie;
>> -	struct zonelist *zl;
>>  	nodemask_t *nmask;
> 
> Same here.
> 
>> @@ -4012,8 +4012,8 @@ static inline void finalise_ac(gfp_t gfp_mask,
>>   * This is the 'heart' of the zoned buddy allocator.
>>   */
>>  struct page *
>> -__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>> -			struct zonelist *zonelist, nodemask_t *nodemask)
>> +__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
>> +							nodemask_t *nodemask)
>>  {
> 
> and here
> 
> This looks clean to me. Still feel a bit uneasy about this since I do
> remember that we had a reason to use zonelists instead of nodes back then
> but cannot remember what that reason was....

My history digging showed me that mempolicies used to have a custom
zonelist attached, not nodemask. So I supposed that's why.

> CCing Dimitri at SGI. This may break a lot of legacy SGIapps. If you read
> this Dimitri then please review this patchset and the discussions around
> it.

Break how? This shouldn't break any apps AFAICS, just out-of-tree kernel
patches/modules as usual when APIs change.

> Reviewed-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Thanks!
