From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2 5/7] mm: rename and change semantics of
 nr_indirectly_reclaimable_bytes
Date: Tue, 17 Jul 2018 10:44:07 +0200
Message-ID: <bfdb3fb1-5d81-e17c-e456-083cca04e2cc@suse.cz>
References: <20180618091808.4419-6-vbabka@suse.cz>
 <201806201923.mC5ZpigB%fengguang.wu@intel.com>
 <38c6a6e1-c5e0-fd7d-4baf-1f0f09be5094@suse.cz>
 <20180629211201.GA14897@castle.DHCP.thefacebook.com>
 <ef2dea13-0102-c4bc-a28f-c1b2408f0753@suse.cz>
 <20180702165223.GA17295@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180702165223.GA17295@castle.DHCP.thefacebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-api@vger.kernel.org, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@techsingularity.net>, Matthew Wilcox <willy@infradead.org>, Vijayanand Jitta <vjitta@codeaurora.org>, Laura Abbott <labbott@redhat.com>, Sumit Semwal <sumit.semwal@linaro.org>
List-Id: linux-api@vger.kernel.org

On 07/02/2018 06:52 PM, Roman Gushchin wrote:
> On Sat, Jun 30, 2018 at 12:09:27PM +0200, Vlastimil Babka wrote:
>> On 06/29/2018 11:12 PM, Roman Gushchin wrote:
>>>>
>>>> The vmstat counter NR_INDIRECTLY_RECLAIMABLE_BYTES was introduced by commit
>>>> eb59254608bc ("mm: introduce NR_INDIRECTLY_RECLAIMABLE_BYTES") with the goal of
>>>> accounting objects that can be reclaimed, but cannot be allocated via a
>>>> SLAB_RECLAIM_ACCOUNT cache. This is now possible via kmalloc() with
>>>> __GFP_RECLAIMABLE flag, and the dcache external names user is converted.
>>>>
>>>> The counter is however still useful for accounting direct page allocations
>>>> (i.e. not slab) with a shrinker, such as the ION page pool. So keep it, and:
>>>
>>> Btw, it looks like I've another example of usefulness of this counter:
>>> dynamic per-cpu data.
>>
>> Hmm, but are those reclaimable? Most likely not in general? Do you have
>> examples that are?
> 
> If these per-cpu data is something like per-cpu refcounters,
> which are using to manage reclaimable objects (e.g. cgroup css objects).
> Of course, they are not always reclaimable, but in certain states.

BTW, seems you seem interested, could you provide some more formal
review as well? Others too. We don't need to cover all use cases
immediately, when the patchset is apparently stalled due to lack of
review. Thanks!

> Thanks!
> 
