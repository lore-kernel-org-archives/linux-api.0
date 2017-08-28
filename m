From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm/page_alloc: don't reserve ZONE_HIGHMEM for
 ZONE_MOVABLE request
Date: Mon, 28 Aug 2017 08:45:07 +0200
Message-ID: <78dd0160-14e8-22a6-bd10-d37bbd39f77b@suse.cz>
References: <1503553546-27450-1-git-send-email-iamjoonsoo.kim@lge.com>
 <e919c65e-bc2f-6b3b-41fc-3589590a84ac@suse.cz>
 <20170825002031.GD29701@js1304-P5Q-DELUXE>
 <d57eeb5c-d91d-9718-8473-3c6db465b154@suse.cz>
 <20170828002857.GB9167@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170828002857.GB9167@js1304-P5Q-DELUXE>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Aneesh Kumar K . V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

+CC linux-api

On 08/28/2017 02:28 AM, Joonsoo Kim wrote:
> On Fri, Aug 25, 2017 at 09:56:10AM +0200, Vlastimil Babka wrote:
>> On 08/25/2017 02:20 AM, Joonsoo Kim wrote:
>>> On Thu, Aug 24, 2017 at 11:41:58AM +0200, Vlastimil Babka wrote:
>>>
>>> Hmm, this is already pointed by Minchan and I have answered that.
>>>
>>> lkml.kernel.org/r/<20170421013243.GA13966@js1304-desktop>
>>>
>>> If you have a better idea, please let me know.
>>
>> My idea is that size of sysctl_lowmem_reserve_ratio is ZONE_NORMAL+1 and
>> it has no entries for zones > NORMAL. The
>> setup_per_zone_lowmem_reserve() is adjusted to only set
>> lower_zone->lowmem_reserve[j] for idx <= ZONE_NORMAL.
>>
>> I can't imagine somebody would want override the ratio for HIGHMEM or
>> MOVABLE
>> (where it has no effect anyway) so the simplest thing is not to expose
>> it at all.
> 
> Seems reasonable. However, if there is a user who checks
> sysctl_lowmem_reserve_ratio entry for HIGHMEM and change it, suggested
> interface will cause a problem since it doesn't expose ratio for
> HIGHMEM. Am I missing something?

As you explained, it makes little sense to change it for HIGHMEM which
only affects MOVABLE allocations. Also I doubt there are many systems
with both HIGHMEM (implies 32bit) *and* MOVABLE (implies NUMA, memory
hotplug...) zones. So I would just remove it, and if somebody will
really miss it, we can always add it back. In any case, please CC
linux-api on the next version.

> Thanks.
> 
> 
>>
>>> Thanks.
>>>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
